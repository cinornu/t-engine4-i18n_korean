-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

local DamageType = require "engine.DamageType"
local ActorAI = require "mod.class.interface.ActorAI"

--[[
The tactical AI uses a weighted priority system that organizes tactical needs and possible actions into TACTIC categories (e.g. "ATTACK", "HEAL", described with the tactical table format, below), that are then cross-referenced to determine the best action to take.
For a talent to be handled properly by this AI, its definition must include information to determine if the talent is usable and how and when to use it:
--	*tactical = tactical parameter table (described below) used to specify which TACTICs the talent fulfils (Talents without this field will not be used by the tactical ai.)
--	*requires_target must be set true for talents that require a reachable target to use
--	*range (defaults to 1) used to determine if a targeted talent can reach the target
--	*radius (defaults to 0) used to determine if a targeted talent can reach the target
--	*target (defaults to a "bolt" attack) for targeted talents, a parameter table used by engine.Target:getType to define how to target the talent, it usually includes information on AOE dimensions, friendly fire information, etc.

Targeted talents are those with a defined talent.target or for which self:getTalentRequiresTarget(t) returns true.

== Algorithm ==

The basic idea is that the actor evaluates what it needs (healing, attack, etc.) and what available actions (talents) it has availabe.  It then prioritizes the available actions according to how well they meet its needs and picks the best one to perform.

When run, the tactical ai creates a table of tactical wants (want, see below), that assigns a priority to each TACTIC, and a table of available actions (avail), containing a list of talents that can be used.
The want table contains a list of numerical priorities indexed by TACTIC that range from 0 (no need) to 10 (significant need) or higher, determined by the actor's current condition/situation, modified by available actions:

	format: {TACTIC1 = number, TACTIC2 = number, ...}
	
The avail table contains parameters for all actions that can be performed, indexed by TACTIC:

	format: (TACTIC1 = action list, TACTIC2 = action list, ....}
	
Where each action list has the format:

	{val = tactical weight, tid=talent id to use, ... <other parameters>} for talents

As the avail table is populated with available actions, the want table is updated according to the TACTICs that can be fulfilled and their effectiveness.  The availability of highly effective actions can increase the priority of the corresponding TACTICs in the want table.
In general the want table is only populated with TACTICs that have a an available talent to fulfil them.

Once all of the priorities and available actions have been determined, the highest priority TACTIC from the want table is selected, and then the best action that fulfils that TACTIC is selected from the corresponding avail subtable.
--]]

newAI("use_tactical", function(self)
	-- Find available talents
	local avail = {}
	local want = {}
	self.ai_state._avail = avail
	self.ai_state._wants = want
	local log_detail = config.settings.log_detail_ai or 0
	local ok, _ = false
	local aitarget = self.ai_target.actor
	local ax, ay = self:aiSeeTargetPos(aitarget)
	if log_detail > 0 then print("========== TACTICAL AI", self.uid, self.name, self.x, self.y, "with target", aitarget and aitarget.uid, aitarget and aitarget.name, ax, ay, "==========") end
	local target_dist = aitarget and core.fov.distance(self.x, self.y, ax, ay)
	local hate = aitarget and (self:reactionToward(aitarget) < 0)
	local has_los = aitarget and self:hasLOS(ax, ay)
	local self_compassion = (self.ai_state.self_compassion == false and 0) or self.ai_state.self_compassion or 5
	local ally_compassion = (self.ai_state.ally_compassion == false and 0) or self.ai_state.ally_compassion or 1
	for tid, lvl in pairs(self.talents) do local t = self:getTalentFromId(tid) if t then
		if t.ai_level then lvl = util.getval(t.ai_level, self, t) end
		local aitarget = aitarget
		local ax, ay = ax, ay
		local target_dist = target_dist

		if t.onAIGetTarget then -- handles talent-specific targeting (mostly for heals and friendly effects)
			ax, ay, aitarget = t.onAIGetTarget(self, t)
			if not (ax and ay) then
				ax, ay = self:aiSeeTargetPos(aitarget)
			end
			target_dist = aitarget and core.fov.distance(self.x, self.y, ax, ay)
		end

		local t_avail = false
		if log_detail > 0 then print(self.name, "[use_tactical AI] TESTING", t.mode, tid, t.name, t.is_object_use and t.getObject(self, t).name or "", "with target", aitarget and aitarget.name, ax, ay) end
		local tactical = t.tactical
		if type(tactical) == "function" then tactical = tactical(self, t, aitarget) end
		if log_detail > 1 then if tactical then print("** tactical table:") table.print(tactical, "---") else print("** no tactical table **") end end
		if tactical and aitarget then
			local self_tactics = tactical.self -- DEBUGGING transitional extract self_tactics for separate handling
			if self_tactics then
				tactical = table.clone(tactical) tactical.self = nil
				if type(self_tactics) == "function" then self_tactics = self_tactics(self, t, aitarget) end
			end -- end debugging transitional
			local tg = self:getTalentTarget(t)
			local requires_target = self:getTalentRequiresTarget(t)
				-- Only assume range... some talents may not require LOS, etc
				local within_range = target_dist and target_dist <= ((self:getTalentRange(t) or 0) + (self:getTalentRadius(t) or 0))
			if t.mode == "activated" and not t.no_npc_use and not self:isTalentCoolingDown(t) and self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true) and (not requires_target or within_range) then
				t_avail = true
			elseif t.mode == "sustained" and not t.no_npc_use and not self:isTalentCoolingDown(t) and self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true) and (not requires_target or within_range) then -- aiPreUseTalent calls aiCheckSustainedTalent
			   	t_avail = true
			end
			if t_avail then
				if log_detail > 0 then print("[use_tactical AI] talent", tid, "IS AVAILABLE") end
				-- Note: Previously algorithm kept: updated functions allow this to be rewritten for efficiency
				-- Project the talent if possible, counting foes and allies hit
				local foes_hit = {}
				local allies_hit = {}
				local self_hit = {}
				-- default to direct hit
				local typ = engine.Target:getType(tg or {type=util.getval(t.direct_hit, self, t) and "hit" or "bolt"})
				if tg or requires_target then
					if log_detail > 3 then print("\t** performing dummy projection for", tid, "with parameters:") table.print(tg, "\t_tg_\t") end
					self:project(typ, ax, ay, function(px, py)
						local act = game.level.map(px, py, engine.Map.ACTOR)
						if act and not act.dead then
							if self:reactionToward(act) < 0 then
								if log_detail > 2 then print("\t[use_tactical AI] hit foe!", act.uid, act.name) end
								foes_hit[#foes_hit+1] = act
							elseif (typ.selffire) and (act == self) then
								if log_detail > 2 then print("\t[use_tactical AI] hit self!", act.uid, act.name) end
								self_hit[#self_hit+1] = act
							elseif typ.friendlyfire then
								if log_detail > 2 then print("\t[use_tactical AI] hit ally!", act.uid, act.name) end
								allies_hit[#allies_hit+1] = act
							end
						end
					end)
				end
				-- Evaluate the tactical weights and weight functions
				for tact, val in pairs(tactical) do
					if type(val) == "function" then val = val(self, t, aitarget, tact) or 0 end
					-- Handle damage_types and resistances
					local nb_foes_hit, nb_allies_hit, nb_self_hit = 0, 0, 0
					if log_detail > 1 then print("---evaluating tactic:", tact, val) table.print(val, "---\t") end
					if type(val) == "table" then
						for damtype, damweight in pairs(val) do
							local nb_f, nb_s, nb_a = 0, 0, 0
							-- check for special damtypes
							local special = type(damtype) == "function" and damtype or ActorAI.aiSubstDamtypes[damtype]
							if special then
								if log_detail > 2 then print("\t resolving special damtype", damtype) end
								local wt_adj
								damtype, wt_adj = special(self, t)
								if log_detail > 2 then print("\t special damtype returned:", damtype, wt_adj) end
								damweight = damweight*(wt_adj or 1)
							elseif damtype == "self" then damweight = 0 -- self tactics handled separately, last
							end
							-- Allows a shortcut to just say FIRE instead of DamageType.FIRE in talent's tactical table
							damtype = DamageType[damtype] or damtype
							-- calculate effective number of each type of target hit
							nb_f = self:aiTacticEffectValues(foes_hit, damtype, damweight, t, 1, 1)
							_, nb_s = self:aiTacticEffectValues(self_hit, damtype, damweight, t, 1, 1)
							_, _, nb_a = self:aiTacticEffectValues(allies_hit, damtype, damweight, t, 1, 1)
							if log_detail > 2 then print("---tactic", tact, damtype, "affects (f/s/a):", nb_f, nb_s, nb_a)
							end
							nb_foes_hit, nb_self_hit, nb_allies_hit = nb_foes_hit + nb_f, nb_self_hit + nb_s,nb_allies_hit + nb_a
						end
						val = 1
					-- Or assume no resistances
					else
						nb_foes_hit = #foes_hit
						nb_self_hit = #self_hit
						nb_allies_hit = #allies_hit
					end
					-- Apply the selffire and friendlyfire options
					nb_self_hit = nb_self_hit * (type(typ.selffire) == "number" and typ.selffire / 100 or 1)
					nb_allies_hit = nb_allies_hit * (type(typ.friendlyfire) == "number" and typ.friendlyfire / 100 or 1)
					-- Use the player set ai_talents weights along with the (raw) talent level
					val = val * (self.ai_talents and self.ai_talents[t.id] or 1) * (1 + lvl / 5)

					-- Update the weight by the dummy projection data
					-- Also force scaling if the talent requires a target (stand-in for canProject)
					if tact ~= "special" and self.AI_TACTICS[tact] and (requires_target or nb_foes_hit > 0 or nb_allies_hit > 0 or nb_self_hit > 0) then
						val = val * (nb_foes_hit - ally_compassion * nb_allies_hit - self_compassion * nb_self_hit)*-1*self.AI_TACTICS[tact]
					end
					if t.mode == "sustained" and self:isTalentActive(tid) then val = -1*val end
					if log_detail > 1 then print("  -->", tid, tact, "TOTAL VALUE:", val, "(effective) target types (f/s/a):", nb_foes_hit, nb_self_hit, nb_allies_hit) end
					-- Only take values greater than 0... allows the ai_talents to turn talents off
					if val > 0 and not self:hasEffect(self.EFF_RELOADING) then
						if not avail[tact] then avail[tact] = {} end
						-- Save the tactic, if the talent is instant it gets a huge bonus
						-- Note the addition of a less than one random value, this means the sorting will randomly shift equal values
						--untargeted cures and heals go to the talent user
						val = ((util.getval(t.no_energy, self, t)==true) and val * 10 or val) + rng.float(0, 0.9)
						avail[tact][#avail[tact]+1] = {val=val, tid=tid, nb_foes_hit=nb_foes_hit, nb_allies_hit=nb_allies_hit, nb_self_hit=nb_self_hit,
						force_target=(not requires_target) and (tact == "cure" or tact == "heal") and self}
						if log_detail > 0 then print("[use_tactical AI]", self.uid, self.name, "CAN USE", tid, tact, "weight", val) end
						ok = true
					end
				end -- end main tactic loop
				if self_tactics then -- limited support for self_tactics (functions and numerical values only)
					if log_detail > 1 then print("[use_tactical AI] processing self_tactics for", tid, self_tactics) table.print(self_tactics, "---\t") end
					for tact, val in pairs(self_tactics) do
						if type(val) == "function" then	val = val(self, t, self) end
						if log_detail > 2 then print("---(self)tactic", tact, "effective (self)affect:", val) end
						if type(val) == "number" and val > 0 then
							if not avail[tact] then avail[tact] = {} end
							val = val * (self.ai_talents and self.ai_talents[t.id] or 1) * (1 + lvl/5)
							val = ((util.getval(t.no_energy, self, t)==true) and val * 10 or val) + rng.float(0, 0.9)
							avail[tact][#avail[tact]+1] = {val=val, tid=tid, nb_foes_hit=0, nb_allies_hit=0, nb_self_hit=1,
							force_target=(not requires_target) and (tact == "cure" or tact == "heal") and self}
							if log_detail > 0 then print(self.name, self.uid, "tactical ai talents CAN USE", tid, tact, "(self)weight", val) end
							ok = true
						end
					end
				end -- end self_tactics
			end
		end
	end end
	if ok then -- at least one useful talent found
		local need_heal = 0
		local life = 100 * self.life / self.max_life
		-- Subtract solipsism straight from the life value to give us higher than normal weights; helps keep clarity up and avoid solipsism
		if self:knowTalent(self.T_SOLIPSISM) then life = life - (100 * self:getPsi() / self:getMaxPsi()) end
		if life < 20 then need_heal = need_heal + 10 * self_compassion / 5
		elseif life < 30 then need_heal = need_heal + 8 * self_compassion / 5
		elseif life < 40 then need_heal = need_heal + 5 * self_compassion / 5
		elseif life < 60 then need_heal = need_heal + 4 * self_compassion / 5
		elseif life < 80 then need_heal = need_heal + 3 * self_compassion / 5
		end
		-- Need healing
		if avail.heal then
			want.heal = need_heal
		end

		-- Need mana
		if avail.mana then
			want.mana = 0
			local mana = 100 * self.mana / self.max_mana
			if mana < 20 then want.mana = want.mana + 4
			elseif mana < 30 then want.mana = want.mana + 3
			elseif mana < 40 then want.mana = want.mana + 2
			elseif mana < 60 then want.mana = want.mana + 2
			elseif mana < 80 then want.mana = want.mana + 1
			elseif mana < 100 then want.mana = want.mana + 0.5
			end
		end

		-- Need stamina
		if avail.stamina then
			want.stamina = 0
			local stamina = 100 * self.stamina / self.max_stamina
			if stamina < 20 then want.stamina = want.stamina + 4
			elseif stamina < 30 then want.stamina = want.stamina + 3
			elseif stamina < 40 then want.stamina = want.stamina + 2
			elseif stamina < 60 then want.stamina = want.stamina + 2
			elseif stamina < 80 then want.stamina = want.stamina + 1
			elseif stamina < 100 then want.stamina = want.stamina + 0.5
			end
		end

		-- Need vim
		if avail.vim then
			want.vim = 0
			local vim = 100 * self.vim / self.max_vim
			if vim < 20 then want.vim = want.vim + 4
			elseif vim < 30 then want.vim = want.vim + 3
			elseif vim < 40 then want.vim = want.vim + 2
			elseif vim < 60 then want.vim = want.vim + 2
			elseif vim < 80 then want.vim = want.vim + 1
			elseif vim < 100 then want.vim = want.vim + 0.5
			end
		end

		-- Need psi
		if avail.psi then
			want.psi = 0
			local psi = 100 * self.psi / self.max_psi
			if psi < 20 then want.psi = want.psi + 4
			elseif psi < 30 then want.psi = want.psi + 3
			elseif psi < 40 then want.psi = want.psi + 2
			elseif psi < 60 then want.psi = want.psi + 2
			elseif psi < 80 then want.psi = want.psi + 1
			elseif psi < 100 then want.psi = want.psi + 0.5
			end
		end

		-- hate, positive, negative, air, etc. can be added here

		-- Need to reduce equilibrium
		if avail.equilibrium then
			want.equilibrium = 0
			local _, failure_chance = self:equilibriumChance()
			if failure_chance > 10 then want.equilibrium = want.equilibrium + 0.5
			elseif failure_chance > 20 then want.equilibrium = want.equilibrium + 1
			elseif failure_chance > 50 then want.equilibrium = want.equilibrium + 2
			elseif failure_chance > 60 then want.equilibrium = want.equilibrium + 4
			elseif failure_chance > 80 then want.equilibrium = want.equilibrium + 6
			end
		end

		-- Need to reduce paradox
		if avail.paradox then
			want.paradox = 0
			local failure_chance = self:paradoxFailChance()
			if failure_chance > 10 then want.paradox = want.paradox + 0.5
			elseif failure_chance > 20 then want.paradox = want.paradox + 1
			elseif failure_chance > 50 then want.paradox = want.paradox + 2
			elseif failure_chance > 60 then want.paradox = want.paradox + 4
			elseif failure_chance > 80 then want.paradox = want.paradox + 6
			end
		end

		-- Need ammo
		local a = self:hasAmmo()
		if avail.ammo and a and not self:hasEffect(self.EFF_RELOADING) then
			want.ammo = 0
			local ammo = 100 * a.combat.shots_left / a.combat.capacity
			if ammo == 0 then want.ammo = want.ammo + 10
			elseif ammo < 100 then want.ammo = want.ammo + 0.5
		end
		end

		-- Summoner needs protection
		if avail.protect and self.summoner then
			want.protect = 0
			local life = 100 * self.summoner.life / self.summoner.max_life
			if life < 20 then want.protect = want.protect + 10 * ally_compassion
			elseif life < 30 then want.protect = want.protect + 8 * ally_compassion
			elseif life < 40 then want.protect = want.protect + 5 * ally_compassion
			elseif life < 60 then want.protect = want.protect + 4 * ally_compassion
			elseif life < 80 then want.protect = want.protect + 3 * ally_compassion
		end
		end

		-- Need closing-in
		if avail.closein and target_dist and target_dist > 2 and self.ai_tactic.closein then
			want.closein = 1 + target_dist / 2
		end

		-- Need escaping... allow escaping even if there isn't a talent so we can flee
		if target_dist and (avail.escape or self:aiCanFleeDmapKeepLos()) then
			want.escape = need_heal / 2
			if self.ai_tactic.safe_range and target_dist < self.ai_tactic.safe_range then want.escape = want.escape + self.ai_tactic.safe_range / 2 end
		end

		-- Surrounded
		local nb_foes_seen = 0
		local nb_allies_seen = 0
		local arr = self.fov.actors_dist
		local act
		local sqsense = 2 * 2
		for i = 1, #arr do
			act = self.fov.actors_dist[i]
			if act and not act.dead and self.fov.actors[act] and self.fov.actors[act].sqdist <= sqsense then
				if self:reactionToward(act) < 0 then
					nb_foes_seen = nb_foes_seen + 1
				else
					nb_allies_seen = nb_allies_seen + 1
				end
			end
		end

		if avail.surrounded then
			want.surrounded = nb_foes_seen
		end

		-- Need defence
		if avail.defend and need_heal and nb_foes_seen > 0 then
			table.sort(avail.defend, function(a,b) return a.val > b.val end)
			want.defend = 1 + need_heal / 2 + nb_foes_seen * 0.5
		end

		-- Need cure (remove detrimental effects)
		if avail.cure then
			local nb_detrimental_effs = 0
			for eff_id, p in pairs(self.tmp) do
				if (p.dur or 0) > 1 then
					local e = self.tempeffect_def[eff_id]
					if e.status == "detrimental" then
						nb_detrimental_effs = nb_detrimental_effs + (p.dur-1)/5 --weight depends on remaining duration
					end
				end
			end
			if nb_detrimental_effs > 0 then
				table.sort(avail.cure, function(a,b) return a.val > b.val end)
				want.cure = nb_detrimental_effs + avail.cure[1].val
			end
		end
		-- Attacks
		if avail.attack and aitarget then
			-- Use the foe/ally ratio from the best attack talent
			table.sort(avail.attack, function(a,b) return a.val > b.val end)
			want.attack = avail.attack[1].val
		end
		if avail.disable and aitarget then
			-- Use the foe/ally ratio from the best disable talent
			table.sort(avail.disable, function(a,b) return a.val > b.val end)
			want.disable = (want.attack or 0) + avail.disable[1].val
		end
		if avail.attackarea and aitarget then
			-- Use the foe/ally ratio from the best attackarea talent
			table.sort(avail.attackarea, function(a,b) return a.val > b.val end)
			want.attackarea = avail.attackarea[1].val
		end

		-- Need buffs
		if avail.buff and (want.attack and want.attack > 0 or want.attackarea and want.attackarea > 0) then
			want.buff = math.max(0.01, (want.attack or 0) + 0.5, (want.attackarea or 0) + 0.5)
		end

		if avail.special then want.special = avail.special[1].val end

		if log_detail > 0 then
			if log_detail > 1 then
	--			print("### nb_foes_seen:", nb_foes_seen, "### nb_allies_seen:", nb_allies_seen, "### need_heal:", need_heal)
				if log_detail > 2 then
					print("### Available talents:") table.print(avail, "_avail_\t")
				end
				print("### Wants:") table.print(want, "_want_\t")
			end
			print("========== Final Tactical AI report for", self.uid, self.name, "==========") 
		end
		local res = {}
		for k, v in pairs(want) do
			if v > 0 then
				-- Randomize and multiply by the ai_tactic weights (if any)
				v = (v + v + rng.float(0, 0.9)) * (self.ai_tactic[k] or 1)
				if v > 0 then
					if log_detail > 0 then print(" * "..k, v, "(mult)", self.ai_tactic[k]) end
					res[#res+1] = {k,v}
				end
			end
		end
		if #res == 0 then return end
		table.sort(res, function(a,b) return a[2] > b[2] end)
		local selected_talents = avail[res[1][1]]
--print("selected talent parameters:")
--table.print(selected_talents, "--")
		if selected_talents then
			table.sort(selected_talents, function(a,b) return a.val > b.val end)
			local tid = selected_talents[1].tid
			print("[use_tactical AI] == Tactical choice ==", self.uid, self.name, res[1][1], tid)
			self.ai_state.tactic = res[1][1]
			self:useTalent(tid, nil, nil, nil, selected_talents.force_target)
			return tid, res[1][1]
		else
			return nil, res[1][1]
		end
	elseif log_detail > 0 then
		print("[use_tactical AI] == NO TALENTS AVAILABLE ==", self.uid, self.name)
	end
end)

--=== TACTICAL ENTRY POINT ===--
newAI("tactical", function(self)
	local log_detail = config.settings.log_detail_ai or 0
	local targeted = self:runAI(self.ai_state.ai_target or "target_simple")
	self.ai_state.tactic = nil
	-- Keep your distance
	local special_move = false
	local ax, ay = self:aiSeeTargetPos(self.ai_target.actor)
	if self.ai_state.escape then
		special_move = "flee_dmap_keep_los"
	elseif self.ai_tactic.safe_range and self.ai_target.actor and self:hasLOS(ax, ay) then
		local target_dist = core.fov.distance(self.x, self.y, ax, ay)
		if self.ai_tactic.safe_range <= target_dist then
			special_move = "none"
		elseif self.ai_tactic.safe_range > target_dist then
			special_move = "flee_dmap_keep_los"
		end
	end

	local used_talent, want
	-- One in "talent_in" chance of using a talent
	if (not self.ai_state.no_talents or self.ai_state.no_talents == 0) and rng.chance(self.ai_state.talent_in or 2) then
		if log_detail > 0 then
			print("[tactical AI] tactical AI triggered for", self.uid, self.name, self.x, self.y, "with target", self.ai_target.actor and self.ai_target.actor.uid, self.ai_target.actor and self.ai_target.actor.name, ax, ay)
if config.settings.cheat then game.log("%s__turn %d: Invoking old tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", targeted and "#LIGHT_BLUE#" or "#ROYAL_BLUE#", game.turn, self.uid, self.name, self.x, self.y, self.ai_target.actor and self.ai_target.actor.uid, self.ai_target.actor and self.ai_target.actor.name, self.ai_target.actor and ("STP(%s,%s)"):format(ax, ay) or "") end -- debugging
		end
		used_talent, want = self:runAI("use_tactical")
		if log_detail > 2 then print("[tactical AI] use_tactical returned", used_talent, want) end
		if want == "escape" then
			special_move = "flee_dmap_keep_los"
		else self.ai_state.escape = nil
		end
	end

	if targeted and not self.energy.used then
		local moved
		if special_move then
			moved = self:runAI(special_move)
		end
		if not moved and self.ai_state.escape or self.ai_tactic.safe_range and not self:hasLOS(ax, ay) then -- flee
			moved = self:runAI("flee_dmap_keep_los")
		end
		if not moved and not self.ai_state.escape then -- normal move
			if log_detail > 0 then print("[tactical AI]", self.uid, self.name, " performing default move") end
			return self:runAI(self.ai_state.ai_move or "move_simple")
		end
	end
	if used_talent then -- make sure NPC can use another talent after instant talents
		if self.ai_state.last_tid ~= used_talent then --but protect against repeated talent failures
			self.energy.used = true
			self.ai_state.last_tid = used_talent
		end
		return true
	end
	return false
end)

