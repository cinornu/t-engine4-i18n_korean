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

-- MH only, so this favors 2H
newTalent{
	name = "Arcane Strike",
	short_name = "EARTHEN_BARRIER",
	image = "talents/arcane_strike.png",
	type = {"spell/enhancement", 1},
	points = 5,
	cooldown = 4,
	range = 1,
	stamina = 20,
	require = spells_req1,
	tactical = { ATTACK = 0.2 },
	is_melee = true,
	on_pre_use = function(self, t, silent) if not self:hasMHWeapon() then if not silent then game.logPlayer(self, "You require a weapon to use this talent.") end return false end return true end,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getMana = function(self, t) return self:combatTalentSpellDamage(t, 10, 60) end,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 0.6, 1.0) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not x or not y or not target then return end

		local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat
		local hit = false
		for i = 1,2 do
			if self:attackTargetWith(target, weapon, DamageType.ARCANE, t.getDamage(self, t)) or hit then hit = true end
		end

		if hit then 
			self:incMana(t.getMana(self, t)) 
			if core.shader.active(4) then
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			end
			game:playSoundNear(self, "talents/arcane")
		end

		return true
	end,
	info = function(self, t)
		return ([[Strike twice with your mainhand weapon dealing %d%% Arcane damage.
		If either of these attacks hit you gain %d mana.
		The mana gain will increase with your Spellpower.]]):
		tformat(t.getDamage(self, t)*100, t.getMana(self, t))
	end,
}

newTalent{
	name = "Fiery Hands",
	type = {"spell/enhancement", 2},
	require = spells_req2,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_mana = 40,
	tactical = { BUFF = 2 },
	getFireDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 40) end,
	getFireDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 5, 14) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/fire")
		local ret = {
			particle = particle,
			dam = self:addTemporaryValue("melee_project", {[DamageType.FIRE] = t.getFireDamage(self, t)}),
			per = self:addTemporaryValue("inc_damage", {[DamageType.FIRE] = t.getFireDamageIncrease(self, t)}),
			sta = self:addTemporaryValue("stamina_regen_on_hit", self:getTalentLevel(t) / 3),
		}
		if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = self:attachementSpot("hand1", true) if h1x then ret.particle1 = self:addParticles(Particles.new("shader_shield", 1, {img="fireball", a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, {type="flamehands", time_factor=slow and 700 or 1000})) end
			local h2x, h2y = self:attachementSpot("hand2", true) if h2x then ret.particle2 = self:addParticles(Particles.new("shader_shield", 1, {img="fireball", a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, {type="flamehands", time_factor=not slow and 700 or 1000})) end
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		self:removeTemporaryValue("melee_project", p.dam)
		self:removeTemporaryValue("inc_damage", p.per)
		self:removeTemporaryValue("stamina_regen_on_hit", p.sta)
		return true
	end,
	info = function(self, t)
		local firedamage = t.getFireDamage(self, t)
		local firedamageinc = t.getFireDamageIncrease(self, t)
		return ([[Engulfs your hands (and weapons) in a sheath of fire, dealing %0.2f fire damage per melee attack and increasing all fire damage dealt by %d%%.
		Each hit will also regenerate %0.2f stamina.
		The effects will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.FIRE, firedamage), firedamageinc, self:getTalentLevel(t) / 3)
	end,
}

newTalent{
	name = "Shock Hands",
	type = {"spell/enhancement", 3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_mana = 40,
	tactical = { BUFF = 2 },
	getIceDamage = function(self, t) return self:combatTalentSpellDamage(t, 3, 20) end,
	getIceDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 5, 14) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/lightning")
		local ret = {
			dam = self:addTemporaryValue("melee_project", {[DamageType.LIGHTNING_DAZE] = t.getIceDamage(self, t)}),
			per = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING] = t.getIceDamageIncrease(self, t)}),
			man = self:addTemporaryValue("mana_regen_on_hit", self:getTalentLevel(t) / 3),
		}
		if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = self:attachementSpot("hand1", true) if h1x then ret.particle1 = self:addParticles(Particles.new("shader_shield", 1, {img="lightningwings", a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, {type="flamehands", time_factor=slow and 700 or 1000})) end
			local h2x, h2y = self:attachementSpot("hand2", true) if h2x then ret.particle2 = self:addParticles(Particles.new("shader_shield", 1, {img="lightningwings", a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, {type="flamehands", time_factor=not slow and 700 or 1000})) end
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		self:removeTemporaryValue("melee_project", p.dam)
		self:removeTemporaryValue("inc_damage", p.per)
		self:removeTemporaryValue("mana_regen_on_hit", p.man)
		return true
	end,
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[Engulfs your hands (and weapons) in a sheath of lightning, dealing %d lightning damage with a chance to daze (25%%) per melee attack and increasing all lightning damage dealt by %d%%.
		Each hit will also regenerate %0.2f mana.
		The effects will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.LIGHTNING, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

newTalent{
	name = "Inner Power",
	type = {"spell/enhancement", 4},
	require = spells_req4,
	points = 5,
	mode = "passive",
	cooldown = 10,
	getStatIncrease = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 4, 18)) end,
	getShield = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 20, 250)) end,
	callbackOnAct = function(self, t)
		if self.resting then return end
		self:updateTalentPassives(t) 
	end,
	callbackOnActEnd = function(self, t)
		if self.resting then return end
		self:updateTalentPassives(t) 
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if self:isTalentCoolingDown(t) then return end
		self:startTalentCooldown(t)

		self:setEffect(self.EFF_DAMAGE_SHIELD, 2, {power=t.getShield(self, t)})

		return {dam = dam}
	end,
	passives = function(self, t, p)
		local power = t.getStatIncrease(self, t)
		self:talentTemporaryValue(p, "inc_stats", {
			[self.STAT_STR] = power,
			[self.STAT_DEX] = power,
			[self.STAT_MAG] = power,
			[self.STAT_CUN] = power,
		})
	end,
	info = function(self, t)
		local statinc = t.getStatIncrease(self, t)
		local absorb = self:getShieldAmount(t.getShield(self, t))
		return ([[You concentrate on your inner self, increasing your Strength, Dexterity, Magic, and Cunning by %d.
		Additionally, you gain a shield absorbing %d damage before you take damage every %d turns.
		The stat increase and shield will improve with your Spellpower.]]):
		tformat(statinc, absorb, self:getTalentCooldown(t) )
	end,
}