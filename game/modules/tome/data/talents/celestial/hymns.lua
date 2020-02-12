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

--- general tactical function accounting for Hymn Acolyte and Hymn Incantor
--	uses t.base_tactical and t.adept_deac_tactical
local hymn_tactical = function(self, t, aitarget)
	local bt_type, tacs = type(t.base_tactical)
	if bt_type == "function" then
		tacs = t.base_tactical(self, t, aitarget)
	elseif bt_type == "table" then
		tacs = table.clone(t.base_tactical)
	end
	tacs = tacs or {}
	local lvl = self:getTalentLevel(self.T_HYMN_INCANTOR)
	if lvl > 0 then
		tacs.buff = (tacs.buff or 0) + 2*lvl/(lvl + 5)
	end
	lvl = self:getTalentLevel(self.T_HYMN_ADEPT)
	if lvl > 0 and self:isTalentActive(t.id) then
		if t.adept_deac_tactical then
			table.mergeAdd(tacs, t.adept_deac_tactical)
		end
		tacs.special = (tacs.special or 0) + 0.01 -- forces some "inertia" in toggling hymns
	end
	return tacs
end

newTalent{
	name = "Hymn of Shadows",
	type = {"celestial/hymns-hymns", 1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_negative = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = hymn_tactical,
	base_tactical = { buff=1, defend=0.5, escape=1 , closein=1},
	adept_deac_tactical = {escape = -0.5, closein = -0.5}, -- adept tactic adjustments when deactivating (negated)
	range = 0,
	moveSpeed = function(self, t) return self:combatTalentSpellDamage(t, 20, 50) end,
	castSpeed = function(self, t) return self:combatTalentSpellDamage(t, 7, 20) end,
	callbackOnActBase = function(self, t)
		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
			t2.do_beams(self, t2)
		end
	end,
	sustain_slots = 'celestial_hymn',
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {}
		self:talentTemporaryValue(ret, "movement_speed", t.moveSpeed(self, t)/100)
		self:talentTemporaryValue(ret, "combat_spellspeed", t.castSpeed(self, t)/100)
		ret.particle = self:addParticles(Particles.new("darkness_shield", 1))

		if self:knowTalent(self.T_HYMN_INCANTOR) then
			local t2 = self:getTalentFromId(self.T_HYMN_INCANTOR)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.DARKNESS]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.DARKNESS] = t2.getDarkDamageIncrease(self, t2)})
		end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			self:talentTemporaryValue(ret, "infravision", t2.getBonusInfravision(self, t2))
		end

		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		if self.turn_procs.resetting_talents then return true end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			game:onTickEnd(function() self:setEffect(self.EFF_WILD_SPEED, 1, {power=t2.getSpeed(self, t2), no_talents=0}) end)
		end

		return true
	end,
	info = function(self, t)
		return ([[Chant the glory of the Moons, gaining the agility of shadows.
		This increases your movement speed by %d%% and your spell speed by %d%%.
		You may only have one Hymn active at once.
		The effects will increase with your Spellpower.]]):
		tformat(t.moveSpeed(self, t), t.castSpeed(self, t))
	end,
}

newTalent{
	name = "Hymn of Detection",
	type = {"celestial/hymns-hymns", 1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_negative = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = hymn_tactical,
	adept_deac_tactical = {escape = -0.5}, -- adept tactic adjustments when deactivating (negated)
	base_tactical = function(self, t, aitarget) -- buff tactic up to +3 depending on how much the talent helps to see a stealthed/invisible target or a target that is out of sense range
		local buff, max_buff = 0, 4
		if not aitarget or not self.aiSeeTargetPos then -- out of combat, stay vigilant for enemies
			buff = max_buff
		else
			if self:attr("blind") or self:attr("esp_all") then return end -- target automatically seen or unseen
			local ax, ay = self:aiSeeTargetPos(aitarget)
			local dist = core.fov.distance(self.x, self.y, ax, ay)
			if dist <= self.sight then -- target within sight range
				local is_active = self:isTalentActive(t.id)
				local see, see_chance = self:canSeeNoCache(aitarget)
				if see_chance and see_chance < 100 then -- detecting hidden is useful (rules out esp, etc.)
					local tgt_inv = aitarget:attr("invisible")
					if tgt_inv then -- buff value increases depending on relative invisibility detection
						local base_det = self:combatSeeInvisible() - (is_active and self.compute_vals[is_active.invis] or 0)
						if base_det <= 0 then return {buff = max_buff} end -- cannot see at all with no detection ability
						local need_det = tgt_inv - base_det
						buff = buff + math.max(0, max_buff*(0.5 + need_det/(math.abs(need_det) + 20))) -- adds 0 (need_det = -20) to max_buff (need_det = +20)
					end
					local tgt_stealth = aitarget:attr("stealth")
					if tgt_stealth then -- buff value increases depending on relative stealth detection
						tgt_stealth = tgt_stealth + (aitarget:attr("inc_stealth") or 0)
						local base_det = is_active and is_active.base_see_stealth or self:combatSeeStealth()
						local need_det = tgt_stealth - base_det
						buff = buff + math.max(0, max_buff*(0.5 + need_det/(math.abs(need_det) + 20))) -- adds 0 (need_det = -20) to max_buff (need_det = +20)
					end
				end
			end
		end
		buff=math.min(buff, max_buff)
		return {buff=buff + 0.25, special = buff/2}
	end,
	range = 0,
	sustain_slots = 'celestial_hymn',
	getSeeInvisible = function(self, t) return self:combatTalentSpellDamage(t, 2, 25) end,
	getSeeStealth = function(self, t) return self:combatTalentSpellDamage(t, 2, 25) end,
	critPower = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	callbackOnActBase = function(self, t)
		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
			t2.do_beams(self, t2)
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
--		base_see_stealth = self:combatSeeStealth(),
		local ret = {}
		self:talentTemporaryValue(ret, "see_invisible", t.getSeeInvisible(self, t))
		self:talentTemporaryValue(ret, "see_stealth", t.getSeeStealth(self, t))
		self:talentTemporaryValue(ret, "blindfight", 1)
		self:talentTemporaryValue(ret, "combat_critical_power", t.critPower(self, t))
		ret.particle = self:addParticles(Particles.new("darkness_shield", 1))

		if self:knowTalent(self.T_HYMN_INCANTOR) then
			local t2 = self:getTalentFromId(self.T_HYMN_INCANTOR)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.DARKNESS]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.DARKNESS] = t2.getDarkDamageIncrease(self, t2)})
		end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			self:talentTemporaryValue(ret, "infravision", t2.getBonusInfravision(self, t2))
		end

		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		if self.turn_procs.resetting_talents then return true end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			self:setEffect(self.EFF_INVISIBILITY, t2.invisDur(self, t2), {power=t2.invisPower(self, t2), penalty=0.4})
		end

		return true
	end,
	info = function(self, t)
		local invis = t.getSeeInvisible(self, t)
		local stealth = t.getSeeStealth(self, t)
		return ([[Chant the glory of the Moons, granting you stealth detection (+%d power), and invisibility detection (+%d power).
		You may also attack creatures you cannot see without penalty and your critical hits do %d%% more damage.
		You may only have one Hymn active at once.
		The stealth and invisibility detection will increase with your Spellpower.]]):
		tformat(stealth, invis, t.critPower(self, t))
	end,
}

newTalent{
	name = "Hymn of Perseverance",
	type = {"celestial/hymns-hymns",1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_negative = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = hymn_tactical,
	base_tactical = {defend=1}, -- could check base immunities here
	adept_deac_tactical = {defend = -0.5}, -- adept tactic adjustments when deactivating (negated)
	range = 10,
	getImmunities = function(self, t) return self:combatTalentLimit(t, 1, 0.16, 0.4) end, -- Limit < 100%
	callbackOnActBase = function(self, t)
		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
			t2.do_beams(self, t2)
		end
	end,
	sustain_slots = 'celestial_hymn',
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {}
		self:talentTemporaryValue(ret, "stun_immune", t.getImmunities(self, t))
		self:talentTemporaryValue(ret, "confusion_immune", t.getImmunities(self, t))
		self:talentTemporaryValue(ret, "blind_immune", t.getImmunities(self, t))
		ret.particle = self:addParticles(Particles.new("darkness_shield", 1))

		if self:knowTalent(self.T_HYMN_INCANTOR) then
			local t2 = self:getTalentFromId(self.T_HYMN_INCANTOR)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.DARKNESS]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.DARKNESS] = t2.getDarkDamageIncrease(self, t2)})
		end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			self:talentTemporaryValue(ret, "infravision", t2.getBonusInfravision(self, t2))
		end

		if self:isTalentActive(self.T_HYMN_NOCTURNALIST) then
			local t2 = self:getTalentFromId(self.T_HYMN_NOCTURNALIST)
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		if self.turn_procs.resetting_talents then return true end

		if self:knowTalent(self.T_HYMN_ADEPT) then
			local t2 = self:getTalentFromId(self.T_HYMN_ADEPT)
			self:setEffect(self.EFF_DAMAGE_SHIELD, t2.shieldDur(self, t2), {power=t2.shieldPower(self, t2)})
		end

		return true
	end,
	info = function(self, t)
		local immunities = t.getImmunities(self, t)
		return ([[Chant the glory of the Moons, granting you %d%% stun, blindness and confusion resistance.
		You may only have one Hymn active at once.]]):
		tformat(100 * (immunities))
	end,
}

-- Depreciated, but retained for compatability.
newTalent{
	name = "Hymn of Moonlight",
	type = {"celestial/hymns-hymns",1},
	mode = "sustained",
	require = divi_req4,
	points = 5,
	cooldown = 12,
	sustain_negative = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { ATTACKAREA = { DARKNESS = 1 },
		NEGATIVE = function(self, t, target)
			return t.getNegativeDrain(self, t)/15 -- negated for foes
		end
	},
	range = 5,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 7, 80) end,
	getTargetCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getNegativeDrain = function(self, t) return self:combatTalentLimit(t, 0, 8, 3) end, -- Limit > 0, no regen at high levels
	target = function(self, t) -- for AI only
		 return {type="ball", friendlyfire=false, friendlyblock=false, radius=t.range, range=0, talent=t}
	end,
	callbackOnActBase = function(self, t)
		local drain = t.getNegativeDrain(self, t)
		if self:getNegative() < drain then return end

		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 5, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end

		local drain = t.getNegativeDrain(self, t)

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			if self:getNegative() - 1 < drain then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.DARKNESS, rng.avg(1, self:spellCrit(t.getDamage(self, t)), 3))
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(a.x-self.x), math.abs(a.y-self.y)), "shadow_beam", {tx=a.x-self.x, ty=a.y-self.y})
			game:playSoundNear(self, "talents/spell_generic")
			self:incNegative(-drain)
		end
	end,
	sustain_slots = 'celestial_hymn',
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		game.logSeen(self, "#DARK_GREY#A shroud of shadow dances around %s!", self:getName())
		return { name=("%s's %s"):tformat(self:getName():capitalize(), t.name)
		}
	end,
	deactivate = function(self, t, p)
		game.logSeen(self, "#DARK_GREY#The shroud of shadows around %s disappears.", self:getName())
		return true
	end,
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local drain = t.getNegativeDrain(self, t)
		return ([[Chant the glory of the Moons, conjuring a shroud of dancing shadows that follows you as long as this spell is active.
		Each turn, a shadowy beam will hit up to %d of your foes within radius 5 for 1 to %0.2f damage.
		This powerful spell will drain %0.1f negative energy for each beam; no beam will fire if your negative energy is too low.
		You may only have one Hymn active at once.
		The damage will increase with your Spellpower.]]):
		tformat(targetcount, damDesc(self, DamageType.DARKNESS, damage), drain)
	end,
}

newTalent{
	name = "Hymn Acolyte",
	type = {"celestial/hymns", 1},
	require = divi_req1,
	points = 5,
	mode = "passive",
	negative = 0, -- forces learning of Negative pool
	passives = function(self, t)
		self:setTalentTypeMastery("celestial/hymns-hymns", self:getTalentMastery(t))
	end,
	on_learn = function(self, t)
		self:learnTalent(self.T_HYMN_OF_SHADOWS, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_HYMN_OF_DETECTION, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_HYMN_OF_PERSEVERANCE, true, nil, {no_unlearn=true})
	end,
	on_unlearn = function(self, t)
		self:unlearnTalent(self.T_HYMN_OF_SHADOWS)
		self:unlearnTalent(self.T_HYMN_OF_DETECTION)
		self:unlearnTalent(self.T_HYMN_OF_PERSEVERANCE)
	end,
	info = function(self, t)
		local ret = ""
		local old1 = self.talents[self.T_HYMN_OF_SHADOWS]
		local old2 = self.talents[self.T_HYMN_OF_DETECTION]
		local old3 = self.talents[self.T_HYMN_OF_PERSEVERANCE]
		self.talents[self.T_HYMN_OF_SHADOWS] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_DETECTION] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_HYMN_OF_SHADOWS)
			local t2 = self:getTalentFromId(self.T_HYMN_OF_DETECTION)
			local t3 = self:getTalentFromId(self.T_HYMN_OF_PERSEVERANCE)
			ret = ([[You have learned to sing the praises of the Moons, in the form of three defensive Hymns:

Hymn of Shadows: Increases your movement speed by %d%% and your spell casting speed by %d%%.

Hymn of Detection: Increases your ability to see stealthy creatures by %d and invisible creatures by %d, and increases your critical power by %d%%.

Hymn of Perseverance: Increases your resistance to stun, confusion and blinding by %d%%.

You may only have one Hymn active at a time.]]):
			tformat(t1.moveSpeed(self, t1), t1.castSpeed(self, t1), t2.getSeeStealth(self, t2), t2.getSeeInvisible(self, t2), t2.critPower(self, t2), t3.getImmunities(self, t3)*100)
		end)
		self.talents[self.T_HYMN_OF_SHADOWS] = old1
		self.talents[self.T_HYMN_OF_DETECTION] = old2
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = old3
		return ret
	end,
}

newTalent{
	name = "Hymn Incantor",
	type = {"celestial/hymns", 2},
	require = divi_req2,
	points = 5,
	mode = "passive",
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 10, 30) end,
	getDarkDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 10, 30) end,
	info = function(self, t)
		return ([[Your Hymns now focus darkness near you, which increases your darkness damage by %d%% and does %0.2f darkness damage to anyone who hits you in melee.
		These values scale with your Spellpower.]]):tformat(t.getDarkDamageIncrease(self, t), damDesc(self, DamageType.DARKNESS, t.getDamageOnMeleeHit(self, t)))
	end,
}

-- Remember that Hymns can be swapped instantly.
newTalent{
	name = "Hymn Adept",
	type = {"celestial/hymns", 3},
	require = divi_req3,
	points = 5,
	mode = "passive",
	getBonusInfravision = function(self, t) return math.floor(self:combatTalentScale(t, 0.75, 3.5, 0.75)) end,
	getSpeed = function(self, t) return self:combatTalentSpellDamage(t, 300, 600) end,
	shieldDur = function(self, t) return self:combatTalentSpellDamage(t, 5, 10) end,
	shieldPower = function(self, t) return self:combatTalentSpellDamage(t, 50, 500) end,
	invisDur = function(self, t) return self:combatTalentSpellDamage(t, 5, 10) end,
	invisPower = function(self, t) return self:combatTalentSpellDamage(t, 20, 30) end,
	info = function(self, t)
		return ([[Your skill in Hymns now improves your sight in darkness, increasing your infravision radius by %d.
		Also, when you end a Hymn, you will gain a buff of a type based on which Hymn you ended.
		Hymn of Shadows increases your movement speed by %d%% for one turn.
		Hymn of Detection makes you invisible (power %d) for %d turns.
		Hymn of Perseverance grants a damage shield (power %d) for %d turns.]]):tformat(t.getBonusInfravision(self, t), t.getSpeed(self, t),
			t.invisPower(self, t), t.invisDur(self, t), t.shieldPower(self, t), t.shieldDur(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
}

newTalent{
	name = "Hymn Nocturnalist",
	type = {"celestial/hymns", 4},
	require = divi_req4,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_negative = 5,
	range = 5,
	tactical = { SELF = {NEGATIVE = 0.5}, -- this assumes a Hymn is active
		ATTACKAREA = { DARKNESS = 1 },
		DISABLE = { blind = 0.5},
		NEGATIVE = function(self, t, target)
			return t.getNegativeDrain(self, t)/15 -- negated for foes
		end
	},
	target = function(self, t) -- for AI only
		 return {type="ball", friendlyfire=false, friendlyblock=false, radius=t.range, range=0, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 50) end,
	getTargetCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getNegativeDrain = function(self, t) return 5 end,
	do_beams = function(self, t)
		if self:getNegative() < t.getNegativeDrain(self, t) then return end

		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 5, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end

		if #tgts <= 0 then return end

		local drain = t.getNegativeDrain(self, t)
		self:incNegative(-drain)  -- Make sure to pay before Corona procs
		local dam = self:spellCrit(t.getDamage(self, t))

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.DARKNESS_BLIND, dam)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(a.x-self.x), math.abs(a.y-self.y)), "shadow_beam", {tx=a.x-self.x, ty=a.y-self.y})
			game:playSoundNear(self, "talents/spell_generic")
		end
	end,
	activate = function(self, t)
		game:onTickEnd(function()
			self.turn_procs.resetting_talents = true
			local hymn_id = self.sustain_slots and self.sustain_slots.celestial_hymn
			if self:isTalentActive(hymn_id) then
				self:forceUseTalent(hymn_id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true})
				self:forceUseTalent(hymn_id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true})
			end
			self.turn_procs.resetting_talents = nil
		end)
		return {}
	end,
	deactivate = function(self, t, p)
		game:onTickEnd(function()
			self.turn_procs.resetting_talents = true
			local hymn_id = self.sustain_slots and self.sustain_slots.celestial_hymn
			if self:isTalentActive(hymn_id) then
				self:forceUseTalent(hymn_id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true})
				self:forceUseTalent(hymn_id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true})
			end
			self.turn_procs.resetting_talents = nil
		end)
		return true
	end,
	info = function(self, t)
		return ([[Your passion for singing the praises of the Moons reaches its zenith.
		Your Hymns now fire shadowy beams that will hit up to %d of your foes within radius 5 for 1 to %0.2f damage, with a 20%% chance of blinding.
		This powerful effect will drain %0.1f negative energy each time it fires at at least 1 target; no beam will fire if your negative energy is too low.
		These values scale with your Spellpower.]]):tformat(t.getTargetCount(self, t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNegativeDrain(self, t))
	end,
}
