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

-- TODO: update tactical information for these talents

-- Regen makes resting super slow
-- Looks weaker than the other options, but extra life is a more universally useful stat and mind save is generally lower for celestial classes.
newTalent{
	name = "Chant of Fortitude",
	type = {"celestial/chants-chants", 1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { DEFEND = 2 },
	range = 0,
	getResists = function(self, t) return self:combatTalentSpellDamage(t, 5, 60) end,
	getLifePct = function(self, t) return self:combatTalentLimit(t, 1, 0.10, 0.20) end,
	sustain_slots = 'celestial_chant',
	activate = function(self, t)
		local power = t.getResists(self, t)
		game:playSoundNear(self, "talents/spell_generic2")

		local ret = {}
		self:talentTemporaryValue(ret, "combat_mentalresist", power)
		self:talentTemporaryValue(ret, "max_life", t.getLifePct(self, t)*self.max_life)
		ret.particle = self:addParticles(Particles.new("golden_shield", 1))

		if self:knowTalent(self.T_CHANT_ILLUMINATE) then
			local t2 = self:getTalentFromId(self.T_CHANT_ILLUMINATE)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.LIGHT]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "mana_regen", t2.getBonusRegen(self, t2))
			self:talentTemporaryValue(ret, "stamina_regen", t2.getBonusRegen(self, t2))
		end

		if self:knowTalent(self.T_CHANT_ADEPT) then
			local t2 = self:getTalentFromId(self.T_CHANT_ADEPT)
			self:talentTemporaryValue(ret, "lite", t2.getBonusLight(self, t2))
			t2.doCure(self, t2, "mental")
		end

		if self:knowTalent(self.T_CHANT_RADIANT) then
			local t2 = self:getTalentFromId(self.T_CHANT_RADIANT)
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.LIGHT] = t2.getLightDamageIncrease(self, t2), [DamageType.FIRE] = t2.getLightDamageIncrease(self, t2)})
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local saves = t.getResists(self, t)
		local life = t.getLifePct(self, t)
		return ([[You chant the glory of the Sun, granting you %d Mental Save and increasing your maximum life by %0.1f%% (Currently:  %d).
		You may only have one Chant active at once.
		The effects will increase with your Spellpower.]]):
		tformat(saves, life*100, life*self.max_life)
	end,
}

-- Physical and weapon protection Chant.
newTalent{
	name = "Chant of Fortress",
	type = {"celestial/chants-chants", 1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { DEFEND = 2 },
	range = 0,
	getPhysicalResistance = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 8, 25)) end,
	getResists = function(self, t) return self:combatTalentSpellDamage(t, 5, 60) end,
	sustain_slots = 'celestial_chant',
	activate = function(self, t)
		local power = t.getResists(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {}
		self:talentTemporaryValue(ret, "resists", {[DamageType.PHYSICAL] = t.getPhysicalResistance(self, t)})
		self:talentTemporaryValue(ret, "combat_physresist", power)
		self:talentTemporaryValue(ret, "combat_armor", t.getPhysicalResistance(self, t))
		self:talentTemporaryValue(ret, "combat_armor_hardiness", 15)
		ret.particle = self:addParticles(Particles.new("golden_shield", 1))

		if self:knowTalent(self.T_CHANT_ILLUMINATE) then
			local t2 = self:getTalentFromId(self.T_CHANT_ILLUMINATE)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.LIGHT]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "mana_regen", t2.getBonusRegen(self, t2))
			self:talentTemporaryValue(ret, "stamina_regen", t2.getBonusRegen(self, t2))
		end

		if self:knowTalent(self.T_CHANT_ADEPT) then
			local t2 = self:getTalentFromId(self.T_CHANT_ADEPT)
			self:talentTemporaryValue(ret, "lite", t2.getBonusLight(self, t2))
			t2.doCure(self, t2, "physical")
		end

		if self:knowTalent(self.T_CHANT_RADIANT) then
			local t2 = self:getTalentFromId(self.T_CHANT_RADIANT)
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.LIGHT] = t2.getLightDamageIncrease(self, t2), [DamageType.FIRE] = t2.getLightDamageIncrease(self, t2)})
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local physicalresistance = t.getPhysicalResistance(self, t)
		local saves = t.getResists(self, t)
		return ([[You chant the glory of the Sun, granting you %d%% physical damage resistance, %d physical save, %d armour and +15%% armour hardiness.
		You may only have one Chant active at once.
		The effects will increase with your Spellpower.]]):
		tformat(physicalresistance, saves, physicalresistance)
	end,
}

-- Ranged and magic protection Chant
-- This can be swapped to reactively with a projectile already in the air
newTalent{
	name = "Chant of Resistance",
	type = {"celestial/chants-chants",1},
	mode = "sustained",
	hide = true,
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	dont_provide_pool = true,
	tactical = { DEFEND = 2 },
	no_energy = true,
	range = 0,
	getResists = function(self, t) return self:combatTalentSpellDamage(t, 10, 30) end,
	getDamageChange = function(self, t)
		return -self:combatTalentLimit(t, 50, 14, 30) -- Limit < 50% damage reduction
	end,
	getSpellResists = function(self, t) return self:combatTalentSpellDamage(t, 5, 60) end,
	sustain_slots = 'celestial_chant',
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, tmp, no_martyr)
		if src and src.x and src.y then
			-- assume instantaneous projection and check range to source
			if core.fov.distance(self.x, self.y, src.x, src.y) > 2 then
				dam = dam * (100 + t.getDamageChange(self, t)) / 100
				print("[PROJECTOR] Chant of Resistance (source) dam", dam)
			end
		end
		return {dam=dam}
	end,
	activate = function(self, t)
		local elempower = t.getResists(self, t)
		local spell = t.getSpellResists(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {}
		self:talentTemporaryValue(ret, "resists", {
			[DamageType.FIRE] = elempower,
			[DamageType.LIGHTNING] = elempower,
			[DamageType.ACID] = elempower,
			[DamageType.COLD] = elempower,
		})
		self:talentTemporaryValue(ret, "combat_spellresist", spell)
		ret.particle = self:addParticles(Particles.new("golden_shield", 1))

		if self:knowTalent(self.T_CHANT_ILLUMINATE) then
			local t2 = self:getTalentFromId(self.T_CHANT_ILLUMINATE)
			self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.LIGHT]=t2.getDamageOnMeleeHit(self, t2)})
			self:talentTemporaryValue(ret, "mana_regen", t2.getBonusRegen(self, t2))
			self:talentTemporaryValue(ret, "stamina_regen", t2.getBonusRegen(self, t2))
		end

		if self:knowTalent(self.T_CHANT_ADEPT) then
			local t2 = self:getTalentFromId(self.T_CHANT_ADEPT)
			self:talentTemporaryValue(ret, "lite", t2.getBonusLight(self, t2))
			t2.doCure(self, t2, "magical")
		end

		if self:knowTalent(self.T_CHANT_RADIANT) then
			local t2 = self:getTalentFromId(self.T_CHANT_RADIANT)
			self:talentTemporaryValue(ret, "inc_damage", {[DamageType.LIGHT] = t2.getLightDamageIncrease(self, t2), [DamageType.FIRE] = t2.getLightDamageIncrease(self, t2)})
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local resists = t.getResists(self, t)
		local saves = t.getSpellResists(self, t)
		local range = -t.getDamageChange(self, t)
		return ([[You chant the glory of the Sun, granting you %d%% fire, lightning, acid and cold damage resistance, %d spell save and reduces the damage from enemies 3 or more spaces away by %d%%.
	You may only have one Chant active at once.
	The effects will increase with your Spellpower.]]):
		tformat(resists, saves, range)
	end,
}

-- Depreciated, but retained for compatability.
newTalent{
	name = "Chant of Light",
	type = {"celestial/chants-chants", 4},
	mode = "sustained",
	require = divi_req4,
	points = 5,
	cooldown = 12,
	sustain_positive = 5,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { BUFF = 2 },
	range = 0,
	getLightDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 20, 50) end,
	getLite = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	sustain_slots = 'celestial_chant',
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamageOnMeleeHit(self, t)}),
			phys = self:addTemporaryValue("inc_damage", {[DamageType.LIGHT] = t.getLightDamageIncrease(self, t), [DamageType.FIRE] = t.getLightDamageIncrease(self, t)}),
			lite = self:addTemporaryValue("lite", t.getLite(self, t)),
			particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("inc_damage", p.phys)
		self:removeTemporaryValue("lite", p.lite)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getLightDamageIncrease(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local lite = t.getLite(self, t)
		return ([[You chant the glory of the Sun, empowering your light and fire elemental attacks so that they do %d%% additional damage.
		In addition, this talent surrounds you with a shield of light, dealing %0.1f light damage to anything that hits you in melee.
		Your lite radius is also increased by %d.
		You may only have one Chant active at once and this Chant costs less power to sustain.
		The effects will increase with your Spellpower.]]):
		tformat(damageinc, damDesc(self, DamageType.LIGHT, damage), lite)
	end,
}


newTalent{
	name = "Chant Acolyte",
	type = {"celestial/chants", 1},
	require = divi_req1,
	points = 5,
	mode = "passive",
	positive = 0, -- forces learning of Positive pool
	passives = function(self, t)
		self:setTalentTypeMastery("celestial/chants-chants", self:getTalentMastery(t))
	end,
	on_learn = function(self, t)
		self:learnTalent(self.T_CHANT_OF_FORTITUDE, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_CHANT_OF_FORTRESS, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_CHANT_OF_RESISTANCE, true, nil, {no_unlearn=true})
	end,
	on_unlearn = function(self, t)
		self:unlearnTalent(self.T_CHANT_OF_FORTITUDE)
		self:unlearnTalent(self.T_CHANT_OF_FORTRESS)
		self:unlearnTalent(self.T_CHANT_OF_RESISTANCE)
	end,
	info = function(self, t)
		local ret = ""
		local old1 = self.talents[self.T_CHANT_OF_FORTITUDE]
		local old2 = self.talents[self.T_CHANT_OF_FORTRESS]
		local old3 = self.talents[self.T_CHANT_OF_RESISTANCE]
		self.talents[self.T_CHANT_OF_FORTITUDE] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_FORTRESS] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_RESISTANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_CHANT_OF_FORTITUDE)
			local t2 = self:getTalentFromId(self.T_CHANT_OF_FORTRESS)
			local t3 = self:getTalentFromId(self.T_CHANT_OF_RESISTANCE)
			ret = ([[You have learned to sing the praises of the Sun, in the form of three defensive Chants.
			Chant of Fortitude: Increases your mental save by %d and maximum life by %d%%.
			Chant of Fortress: Increases your physical save by %d, your physical resistance by %d%%, your armour by %d and your armour hardiness by 15%%.
			Chant of Resistance: Increases you spell save by %d, your fire/cold/lightning/acid resistances by %d%% and reduces all damage that comes from distant enemies (3 spaces or more) by %d%%.
			You may only have one Chant active at a time.]]):
			tformat(t1.getResists(self, t1), t1.getLifePct(self, t1)*100, t2.getResists(self, t2), t2.getPhysicalResistance(self, t2), t2.getPhysicalResistance(self, t2), t3.getSpellResists(self, t3), t3.getResists(self, t3), t3.getDamageChange(self, t3))
		end)
		self.talents[self.T_CHANT_OF_FORTITUDE] = old1
		self.talents[self.T_CHANT_OF_FORTRESS] = old2
		self.talents[self.T_CHANT_OF_RESISTANCE] = old3
		return ret
	end,
}

-- Mana regen is given to make it a little more attractive to Anorithils.
-- Might also make some people consider Chants as an escort reward.
newTalent{
	name = "Chant Illuminate",
	type = {"celestial/chants", 2},
	require = divi_req2,
	points = 5,
	mode = "passive",
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 50) end,
	getBonusRegen = function(self, t) return self:combatTalentSpellDamage(t, 10, 20) / 10 end,
	info = function(self, t)
		return ([[Your Chants now bathe you in a cloak of light, which increases your stamina and mana regenerations by %0.2f per turn and does %0.2f light damage to anyone who hits you in melee.
		These values scale with your Spellpower.]]):tformat(t.getBonusRegen(self, t), damDesc(self, DamageType.LIGHT, t.getDamageOnMeleeHit(self, t)))
	end,
}

-- Remember that Chants can be swapped instantly.
newTalent{
	name = "Chant Adept",
	type = {"celestial/chants", 3},
	require = divi_req3,
	points = 5,
	mode = "passive",
	getDebuffCures = function(self, t) return math.floor(self:combatTalentScale(t, 1, 1.8, 0.75)) end,
	getBonusLight = function(self, t) return math.floor(self:combatTalentScale(t, 0.75, 3.5, 0.75)) end,
	doCure = function(self, t, type)
		if self.turn_procs.resetting_talents then return false end  -- Avoid levelup screen cleanse exploit
		local cures = t.getDebuffCures(self, t)
		local effs = {}
		local force = {}
		local known = false

		-- Go through all temporary effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type == type and e.status == "detrimental" and e.subtype["cross tier"] then
				force[#force+1] = {"effect", eff_id}
			elseif e.type == type and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		-- Cross tier effects are always removed and not part of the random game, otherwise it is a huge nerf to wild infusion
		for i = 1, #force do
			local eff = force[i]
			if eff[1] == "effect" then
				self:removeEffect(eff[2])
				known = true
			end
		end

		if cures > 0 then
			for i = 1, cures do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					self:removeEffect(eff[2])
					known = true
				end
			end
		end
		if known then
			game.logSeen(self, "%s is cured!", self:getName():capitalize())
		end
	end,
	info = function(self, t)
		return ([[Your skill at Chanting now extends the cloak of light, increasing your light radius by %d.
		Also, when you start a new Chant, you will be cured of all cross-tier effects and cured of up to %d debuffs.
		Chant of Fortitude cures mental effects.
		Chant of Fortress cures physical effects.
		Chant of Resistance cures magical effects.]]):tformat(t.getBonusLight(self, t), t.getDebuffCures(self, t))
	end,
}

newTalent{
	name = "Chant Radiant",
	type = {"celestial/chants", 4},
	require = divi_req4,
	points = 5,
	mode = "passive",
	getLightDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 10, 30) end,
	getPos = function(self, t) return self:combatTalentScale(t, 2, 5) end,
	getTurnLimit = function(self, t) return self:combatTalentScale(t, 1, 3) end,
	callbackOnMeleeHit = function(self, t, src)
		if not (self:isTalentActive(self.T_CHANT_OF_FORTRESS) or self:isTalentActive(self.T_CHANT_OF_FORTITUDE) or self:isTalentActive(self.T_CHANT_OF_RESISTANCE)) then return end
		if src == self then return end
		if self.turn_procs.chant_radiant and self.turn_procs.chant_radiant > t.getTurnLimit(self, t) then return end
		self.turn_procs.chant_radiant = self.turn_procs.chant_radiant or 0
		self:incPositive(t.getPos(self, t))
		self.turn_procs.chant_radiant = self.turn_procs.chant_radiant + 1
	end,
	callbackOnArcheryHit = function(self, t, dam, src)
		if not (self:isTalentActive(self.T_CHANT_OF_FORTRESS) or self:isTalentActive(self.T_CHANT_OF_FORTITUDE) or self:isTalentActive(self.T_CHANT_OF_RESISTANCE)) then return end
		if src == self then return end
		if self.turn_procs.chant_radiant and self.turn_procs.chant_radiant > t.getTurnLimit(self, t) then return end
		self.turn_procs.chant_radiant = self.turn_procs.chant_radiant or 0
		self:incPositive(t.getPos(self, t))
		self.turn_procs.chant_radiant = self.turn_procs.chant_radiant + 1
	end,
	info = function(self, t)
		return ([[Your passion for singing the praises of the Sun reaches its zenith.
		Your Chanting now increases your light and fire damage by %d%% and up to %d times per turn, when you are hit by a weapon attack, you will gain %0.1f Positive.
		These values scale with your Spellpower.]]):tformat(t.getLightDamageIncrease(self, t), t.getTurnLimit(self, t), t.getPos(self, t))
	end,
}
