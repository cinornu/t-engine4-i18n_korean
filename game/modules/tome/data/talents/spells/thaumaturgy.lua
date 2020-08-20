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
	name = "Orb of Thaumaturgy",
	type = {"spell/thaumaturgy",1},
	require = spells_req_high1,
	points = 5,
	mana = 35,
	cooldown = 20,
	range = 10,
	use_only_arcane = 5,
	tactical = { BUFF=function(self, t)
		if not self:hasEffect(self.EFF_ORB_OF_THAUMATURGY) then return 2 end
	end },
	on_pre_use = thaumaturgyCheck,
	requires_target = true,
	no_energy = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	getDamPct = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 60, 25)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTargetLimitedWallStop(tg)
		if not x or not y then return nil end
		self:setEffect(self.EFF_ORB_OF_THAUMATURGY, t:_getDur(self), {x=x, y=y, dam_pct=t:_getDamPct(self)})
		return true
	end,
	info = function(self, t)
		return ([[You create an orb attuned to thaumaturgy for %d turns.
		While it lasts, any beam spell you cast will be duplicated and also cast for free at the orb for %d%% of the normal damage.
		]]):tformat(t:_getDur(self), 100 - t:_getDamPct(self))
	end,
}

newTalent{
	name = "Multicaster",
	type = {"spell/thaumaturgy",2},
	require = spells_req_high2,
	points = 5,
	mode = "sustained",
	sustain_mana = 70,
	cooldown = 30,
	use_only_arcane = 5,
	tactical = { BUFF = 1 },
	on_pre_use = thaumaturgyCheck,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 10, 30) end,
	spells_list = {
		["spell/fire"] = 	{ "T_FLAMESHOCK", "T_FIREFLASH", "T_INFERNO", "T_BLASTWAVE"},
		["spell/arcane"] = 	{ "T_ARCANE_VORTEX", "T_AETHER_BEAM", "T_AETHER_BREACH"},
		["spell/lightning"] = 	{ "T_CHAIN_LIGHTNING", "T_NOVA", "T_SHOCK" },
		["spell/water"] = 	{ "T_GLACIAL_VAPOUR", "T_TIDAL_WAVE", "T_FREEZE", "T_FROZEN_GROUND" },
		["spell/earth"] = 	{ "T_MUDSLIDE", "T_EARTHEN_MISSILES", "T_EARTHQUAKE" },
	},
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not rng.percent(t:_getChance(self)) then return end
		if not death_note then return end
		if death_note.source_talent_mode ~= "active" and not self._orb_of_thaumaturgy_recurs then return end
		if not death_note.source_talent or not death_note.source_talent.is_beam_spell then return end
		if not thaumaturgyCheck(self) then return end

		local tids = {}
		local is_aethar_avatar = self:hasEffect(self.EFF_AETHER_AVATAR)
		for kind, list in pairs(t.spells_list) do
			for _, tid in ipairs(list) do
				local tt = self:getTalentFromId(tid)
				if self:knowTalent(tid) and (not is_aethar_avatar or (tt.use_only_arcane and self:getTalentLevel(self.T_AETHER_AVATAR) >= tt.use_only_arcane)) then
					-- print(("[%s] %s : %d"):format(kind, tid, self:getTalentCooldown(self:getTalentFromId(tid), true)))
					tids[#tids+1] = {tid=tid, cd=self:getTalentCooldown(tt, true)}
				end
			end
		end
		local choice = rng.rarityTable(tids, "cd")
		if not choice then return end
		self:forceUseTalent(choice.tid, {ignore_cooldown=true, ignore_energy=true, force_target=self._orb_of_thaumaturgy_recurs or target})
	end,	
	activate = function(self, t)
		local ret = {}
		return ret
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Casting beam spells has become so instinctive for you that you can now easily weave in other spells at the same time.
		Anytime you cast a beam spell there is a %d%% chance to automatically cast an offensive spell that you know. This can only happen once per turn.
		Beam spells duplicated by the Orb of Thaumaturgy can also trigger this effect.
		The additional cast will cost mana but no turn and will not active its cooldown.
		During Aether Avatar only compatible spells are used.]]):
		tformat(t:_getChance(self))
	end,
}

newTalent{
	name = "Slipstream",
	type = {"spell/thaumaturgy",3},
	require = spells_req_high3,
	points = 5,
	mode = "sustained",
	mana = 40,
	cooldown = 20,
	use_only_arcane = 5,
	tactical = { BUFF=1 },
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7)) end,
	iconOverlay = function(self, t, p)
		local val = p.charges
		if val <= 0 then return "" end
		return tostring(math.ceil(val)), "buff_font_small"
	end,
	resetStream = function(self, t, ret)
		ret.been_used = nil
		ret.charges = t:_getNb(self)
	end,
	useStream = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		p.charges = p.charges - 1
		p.been_used = true
		if p.charges <= 0 then self:forceUseTalent(t.id, {ignore_energy=true}) end
	end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end

		if p.out_combat_turn and p.out_combat_turn < game.turn - 100 and p.been_used then
			local mana = util.getval(t.mana, self, t) or 0
			mana = self:alterTalentCost(t, "mana", mana)

			if self:getMana() < mana then
				game.logPlayer(self, "#PURPLE#Your Slipstream does not have enough resources!")
				self:forceUseTalent(t.id, {ignore_energy=true})
			else
				game.logPlayer(self, "#PURPLE#Your Slipstream regenerates to full!")
				t:_resetStream(self, p)
				self:incMana(-mana)
			end
		end
	end,
	callbackOnCombat = function(self, t, state)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if state then p.out_combat_turn = nil
		else p.out_combat_turn = game.turn
		end
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not death_note then return end
		if death_note.source_talent_mode ~= "active" then return end
		if not death_note.source_talent or not death_note.source_talent.is_beam_spell then return end
		if not thaumaturgyCheck(self) then return end
		self:setEffect(self.EFF_SLIPSTREAM, 1, {})
	end,	
	on_pre_use = thaumaturgyCheck,
	activate = function(self, t)
		local ret = { charges = t:_getNb(self), max_charges = t:_getNb(self) }
		-- I'm French and I like cheese but I'll still try to prevent it!
		if self.turn_procs.resetting_talents then
			ret.charges = ret.charges - self.turn_procs.slipstream_resetting
			if ret.charges <= 0 then game:onTickEnd(function() self:forceUseTalent(t.id, {ignore_energy=true}) end) end
		end
		return ret
	end,
	deactivate = function(self, t, p)
		-- I'm French and I like cheese but I'll still try to prevent it!
		if self.turn_procs.resetting_talents then self.turn_procs.slipstream_resetting = p.max_charges - p.charges end
		return true
	end,
	info = function(self, t)
		return ([[By weaving arcane triggers around you feet you can use the residual energies of your beam spells for free movement.
		Each time you cast a beam spell you can move right afterwards without spending a turn.
		This spell has %d charges. Once all charges are spent it unsustains.
		If you exit combat with some charges left it will after 10 turn regenerates its charges, if you have enough mana.]]):tformat(t:_getNb(self))
	end,
}

newTalent{
	name = "Elemental Array Burst",
	type = {"spell/thaumaturgy",4},
	require = spells_req_high4,
	points = 5,
	mana = 25,
	use_only_arcane = 5,
	cooldown = 16,
	tactical = { ATTACKAREA = { THAUM = 4 } },
	range = 10,
	is_beam_spell = true,
	requires_target = true,
	target = function(self, t) return {type="widebeam", force_max_range=true, radius=1, range=self:getTalentRange(t), talent=t, selffire=false, friendlyfire=self:spellFriendlyFire()} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 370) end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not death_note then return end
		if death_note.source_talent_mode ~= "active" then return end
		if not death_note.source_talent or not death_note.source_talent.is_beam_spell or death_note.source_talent.id == t.id then return end
		if self.turn_procs.elemental_array_burst then return end
		self.turn_procs.elemental_array_burst = true
		self:alterTalentCoolingdown(t.id, -1)
	end,	
	on_pre_use = thaumaturgyCheck,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = thaumaturgyBeamDamage(self, self:spellCrit(t.getDamage(self, t)))
		local grids = self:project(tg, x, y, DamageType.THAUM, dam)

		if self:attr("burning_wake") and grids then
			for px, ys in pairs(grids) do
				for py, _ in pairs(ys) do
					game.level.map:addEffect(self, px, py, 4, engine.DamageType.INFERNO, self:attr("burning_wake"), 0, 5, nil, {type="inferno"}, nil, self:spellFriendlyFire())
				end
			end
		end

		if self:isTalentActive(self.T_HURRICANE) then
			self:projectApply(tg, x, y, Map.ACTOR, function(target) if rng.percent(25) then self:callTalent(self.T_HURRICANE, "do_hurricane", target) end end)
		end
		if self:isTalentActive(self.T_CRYSTALLINE_FOCUS) then
			self:projectApply(tg, x, y, Map.ACTOR, function(target) if rng.percent(25) then 
				if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, 3, {apply_power=self:combatSpellpower()}) end
			end end)
		end
		if self:isTalentActive(self.T_UTTERCOLD) then
			self:projectApply(tg, x, y, Map.ACTOR, function(target) if rng.percent(25) then 
				if target:canBe("stun") then target:setEffect(target.EFF_FROZEN, 3, {apply_power=self:combatSpellpower(), hp=dam}) end
			end end)
		end

		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam_wide", {tx=x-self.x, ty=y-self.y})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "mana_beam_wide", {tx=x-self.x, ty=y-self.y})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ice_beam_wide", {tx=x-self.x, ty=y-self.y})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "earth_beam_wide", {tx=x-self.x, ty=y-self.y})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "lightning_beam_wide", {tx=x-self.x, ty=y-self.y})
		game:shakeScreen(10, 3)
		game:playSoundNear(self, "talents/reality_breach")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Using your near-perfect knowledge of beam spells you combine them all into a powerful 3-wide beam of pure energy.
		The beam deals %0.2f thaumic damage and always goes as far as possible.
		Thaumic damage can never be resisted by anything but "Resistance: All", always uses your highest resistance penetration and highest damage type bonus and can never be altered into other damage types.
		It can trigger Burning Wake and Hurricane.
		It is affected by the wet status (+30%% damage) if you are in Shivgoroth Form.
		It has a 25%% chance to either stun or freeze the targets for 3 turns (if Crystalline Focus or Uttercold are active, respectively).
		Each time you deal damage with a beam spell, the remaining cooldown is reduced by 1 (this can happen only once per turn).
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.THAUM, damage))
	end,
}

newTalent{
	name = "Thaumaturgy Unlock Checker", short_name = "THAUMATURGIST_UNLOCK_CHECKER",
	type = {"spell/other",1},
	mode = "passive",
	hide = "always",
	no_unlearn_last = true,
	checkValid = function(self, t, death_note)
		if not death_note then print("[Thaumaturgy Checker] fail because no death_note") return false end
		if death_note.source_talent_mode ~= "active" then print("[Thaumaturgy Checker] unsure because no active") return nil end
		if not death_note.source_talent or not death_note.source_talent.is_beam_spell then print("[Thaumaturgy Checker] fail because no beam spell") return false end
		local tg = self:getTalentTarget(death_note.source_talent)
		if tg.type ~= "beam" then print("[Thaumaturgy Checker] fail because beam spell is not yet beam") return false end
		print("[Thaumaturgy Checker] Good for now") 
		return true
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if target.rank < 4 or target.level < 10 then return end
		local res = t:_checkValid(self, death_note)
		if res == false then
			target.__invalid_for_thaumaturgy_unlock = true
		elseif res == true then
			target.__valid_for_thaumaturgy_unlock = true
		end
	end,
	callbackOnKill = function(self, t, target, death_note)
		if target.rank < 4 or target.level < 10 then return end
		local res = t:_checkValid(self, death_note)
		if (res == true or res == nil) and target.__valid_for_thaumaturgy_unlock and not target.__invalid_for_thaumaturgy_unlock then
			game:setAllowedBuild("mage_thaumaturgist", true)
			self:unlearnTalent(t.id)
		end
	end,
	info = function(self, t)
		return "Move along, nothing to see" -- No need to translate
	end,
}
