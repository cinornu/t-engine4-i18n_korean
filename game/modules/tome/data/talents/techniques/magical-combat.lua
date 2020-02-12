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

newTalent{
	name = "Arcane Combat",
	type = {"technique/magical-combat", 1},
	mode = "sustained",
	points = 5,
	require = techs_req1,
	sustain_stamina = 20,
	no_sustain_autoreset = true,
	no_energy = true,
	cooldown = 5,
	tactical = { BUFF = 2 },
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (1 + self:getCun(9, true)), 100, 20, 0, 70, 50) end, -- Limit < 100%
	canUseTalent = function(self, t, proc) -- Returns true if the actor can currently trigger the "proc" talent with Arcane Combat
		local talent = self:getTalentFromId(proc)
		if not talent or not talent.allow_for_arcane_combat then return false end
		if not self:knowTalent(talent) then return false end
		if not self:attr("force_talent_ignore_ressources") then
			-- Check all possible resource types and see if the talent has an associated cost
			for _, res_def in ipairs(self.resources_def) do
				local rname = res_def.short_name
				local cost = talent[rname]
				if cost then
					cost = (util.getval(cost, self, talent) or 0) * (util.getval(res_def.cost_factor, self, talent) or 1)
					if cost ~= 0 then
						local rmin, rmax = self[res_def.getMinFunction](self), self[res_def.getMaxFunction](self)
						-- Return false if we can't afford the talent cost
						if res_def.invert_values then
							if rmax and self[res_def.getFunction](self) + cost > rmax then
								return false
							end
						else
							if rmin and self[res_def.getFunction](self) - cost < rmin then
								return false
							end
						end
					end
				end
			end
		end
		return true
	end,
	do_trigger = function(self, t, target)
		if self.x == target.x and self.y == target.y then return nil end

		local chance = t.getChance(self, t)
		if self:hasShield() then chance = chance * 0.5
		elseif self:hasDualWeapon() then chance = chance * 0.5
		end
		
		if rng.percent(chance) then
			local spells = {}
			-- Load previously selected spell
			local p = self:isTalentActive(t.id)
			if p and p.talent then
				local talent = self:getTalentFromId(p.talent)
				if t.canUseTalent(self, t, talent) then
					spells[1] = talent.id
				end
			end
			-- If no appropriate spell is selected, pick a random spell
			if #spells < 1 and (not p or not p.talent) then
				for _, talent in pairs(self.talents_def) do
					if t.canUseTalent(self, t, talent) then
						spells[#spells+1] = talent.id
					end
				end
			end
			local tid = rng.table(spells)
			if tid then
				local l = self:lineFOV(target.x, target.y)
				l:set_corner_block()
				local lx, ly, is_corner_blocked = l:step(true)
				local target_x, target_y = lx, ly
				-- Check for terrain and friendly actors
				while lx and ly and not is_corner_blocked and core.fov.distance(self.x, self.y, lx, ly) <= 10 do
					local actor = game.level.map(lx, ly, engine.Map.ACTOR)
					if actor and (self:reactionToward(actor) >= 0) then
						break
					elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
						target_x, target_y = lx, ly
						break
					end
					target_x, target_y = lx, ly
					lx, ly = l:step(true)
				end
				print("[ARCANE COMBAT] autocast ",self:getTalentFromId(tid).name)
				local old_cd = self:isTalentCoolingDown(self:getTalentFromId(tid))
				self:forceUseTalent(tid, {ignore_energy=true, ignore_cooldown=true, force_target={x=target_x, y=target_y, __no_self=true}})
				-- Do not setup a cooldown
				if not old_cd then
					self.talents_cd[tid] = nil
				end
				self.changed = true
			end
		end
	end,
	activate = function(self, t)
		if self ~= game.player then return {} end
		local talent, use_random = self:talentDialog(require("mod.dialogs.talents.MagicalCombatArcaneCombat").new(self))
		if use_random then
			return {}
		elseif talent then
			return {talent = talent}
		else
			return nil
		end
	end,
	deactivate = function(self, t, p)
		p.talent = nil
		return true
	end,
	info = function(self, t)
		local talent_list = ""
		local build_string = {}
		for _, talent in pairs(self.talents_def) do
			if talent.allow_for_arcane_combat and talent.name then
				if #build_string > 0 then build_string[#build_string+1] = ", " end
				build_string[#build_string+1] = talent.name
			end
		end
		if #build_string > 0 then talent_list = table.concat(build_string) end
		
		local talent_selected = ""
		if self:isTalentActive(t.id) then
			local talent = self:getTalentFromId(self:isTalentActive(t.id).talent)
			if talent and talent.name then
				talent_selected = ([[
				
				Currently selected spell: %s]]):tformat(talent.name)
			else
				talent_selected = _t[[
				
				Currently selected spell: Random]]
			end
		end
		return ([[Allows you to use melee weapons to focus your spells, granting a %d%% chance per melee attack to cast an offensive spell as a free action on the target.
		Delivering the spell this way will not trigger a spell cooldown.
		You may select an allowed spell to trigger this way, or choose to have one randomly selected for each attack.
		While dual wielding or using a shield the chance is halved.
		The chance increases with your Cunning.

		Allowed spells: %s %s]]):
		tformat(t.getChance(self, t), talent_list, talent_selected)
	end,
}

newTalent{
	name = "Arcane Cunning",
	type = {"technique/magical-combat", 2},
	mode = "passive",
	points = 5,
	require = techs_req2,
	-- called by _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local bonus = self:getCun()*spellpower/100
		return ([[The user gains a bonus to Spellpower equal to %d%% of your Cunning (Current bonus: %d).]]):
		tformat(spellpower, bonus)
	end,
}

newTalent{
	name = "Arcane Feed",
	type = {"technique/magical-combat", 3},
	mode = "sustained",
	points = 5,
	cooldown = 5,
	sustain_stamina = 20,
	require = techs_req3,
	range = 10,
	tactical = { BUFF = 2 },
	getManaRegen = function(self, t) return self:combatTalentScale(t, 1/7, 5/7, 0.75) end,
	getCritChance = function(self, t) return self:combatTalentScale(t, 2.5, 11, 0.75) end,
	activate = function(self, t)
		local power = t.getManaRegen(self, t)
		local crit = t.getCritChance(self, t)
		return {
			regen = self:addTemporaryValue("mana_regen", power),
			pc = self:addTemporaryValue("combat_physcrit", crit),
			sc = self:addTemporaryValue("combat_spellcrit", crit),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.regen)
		self:removeTemporaryValue("combat_physcrit", p.pc)
		self:removeTemporaryValue("combat_spellcrit", p.sc)
		return true
	end,
	info = function(self, t)
		return ([[Regenerates %0.2f mana per turn, and increases physical and spell critical chance by %d%% while active.]]):tformat(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

newTalent{
	name = "Arcane Destruction",
	type = {"technique/magical-combat", 4},
	mode = "passive",
	points = 5,
	require = techs_req4,
	radius = function(self, t) return self:getTalentLevel(t) < 5 and 1 or 2 end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 100) end,
	getSPMult = function(self, t) return self:combatTalentScale(t, 1/7, 5/7) end,
	info = function(self, t)
		return ([[Raw magical damage channels through the caster's weapon, increasing raw Physical Power by %d%% of your Magic (current bonus: %d).
		Each time you crit with a melee blow, you will unleash a radius %d ball of arcane damage, doing %0.2f.
		The bonus scales with your Spellpower and talent level.
		If you are using a shield this will only occur 50%% of the time.
		If you are dual wielding this will only occur 50%% of the time.
		At level 5 the ball becomes radius 2.
		]]):
		tformat(t.getSPMult(self, t)*100, self:getMag() * t.getSPMult(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ARCANE, t.getDamage(self, t)) )
	end,
}