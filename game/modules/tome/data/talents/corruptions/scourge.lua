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

-- Reaver gets an abnormally low number of melee strikes so its important that cooldowns and such reflect this, otherwise it encourages playing as a ranged caster

local DamageType = require "engine.DamageType"

newTalent{
	name = "Virulent Strike",
	short_name = "REND",
	type = {"corruption/scourge", 1},
	require = corrs_req1,
	points = 5,
	vim = 15,
	cooldown = 4,
	range = 1,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = {PHYSICAL = 2} },
	requires_target = true,
	getIncrease = function(self, t) return math.floor(self:combatTalentLimit(t, 4, 1, 3.5)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.6) end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Virulent Strike without two weapons!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, nil, t.getDamage(self, t))
		local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, t.getDamage(self, t)))
		DamageType:projectingFor(self, nil)

		local effs = target:effectsFilter(function(e) return e.subtype.disease end, 9999)
		if hit1 then
			if #effs > 0 then table.sort(effs, function(a, b)
				local eff = target:hasEffect(a)
				local eff2 = target:hasEffect(b)
				return eff.dur < eff2.dur end)
			end
			local eff2 = target:hasEffect(effs[1])
			if eff2 then
				eff2.dur = eff2.dur + t.getIncrease(self, t)
			end
		end
		if hit2 then
			if #effs > 0 then table.sort(effs, function(a, b)
				local eff = target:hasEffect(a)
				local eff2 = target:hasEffect(b)
				return eff.dur < eff2.dur end)
			end			
			local eff2 = target:hasEffect(effs[1])
			if eff2 then 
				eff2.dur = eff2.dur + t.getIncrease(self, t)
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Strike the target with both weapons dealing %d%% damage with each hit.  Each strike that hits will increase the duration of the lowest duration disease effect by %d.]]):
		tformat(100 * t.getDamage(self, t), t.getIncrease(self, t))
	end,
}

newTalent{
	name = "Ruin",
	type = {"corruption/scourge", 2},
	mode = "sustained",
	require = corrs_req2,
	points = 5,
	sustain_vim = 40,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 40) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {}
		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="ruin_shieldwall"}, shader={type="rotatingshield", noup=2.0, time_factor=2500, appearTime=0.2}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="ruin_shieldwall"}, shader={type="rotatingshield", noup=1.0, time_factor=2500, appearTime=0.2}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self, t))
		return ([[Concentrate on the corruption you bring, enhancing each of your melee strikes with %0.2f blight damage (which also heals you for %0.2f each hit).
		The damage will increase with your Spellpower.]]):
		tformat(dam, dam * 0.4)
	end,
}

newTalent{
	name = "Acid Strike",
	type = {"corruption/scourge", 3},
	require = corrs_req3,
	points = 5,
	vim = 20,
	cooldown = 8,
	range = 1,
	radius = function(self, t) return self:combatTalentLimit(t, 7, 1, 5) end,
	requires_target = true,
	is_melee = true,
	tactical = { ATTACK = {ACID = 2}},
	target = function(self, t)
		-- Tries to simulate the acid splash
		return {type="ballbolt", range=1, radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
	end,
	getSplash = function(self, t) return self:combatTalentSpellDamage(t, 10, 200) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.6) end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Acid Strike without two weapons!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, DamageType.ACID, t.getDamage(self, t))
		local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, DamageType.ACID, self:getOffHandMult(offweapon.combat, t.getDamage(self, t)))
		DamageType:projectingFor(self, nil)

		-- Acid splash !
		if hit1 or hit2 then
			local tg = self:getTalentTarget(t)
			tg.x = target.x
			tg.y = target.y
			self:project(tg, target.x, target.y, DamageType.ACID, self:spellCrit(t.getSplash(self, t)))
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_acid", {radius=tg.radius})
			game:playSoundNear(self, "talents/slime")
		end

		return true
	end,
	info = function(self, t)
		return ([[Strike with each of your weapons, doing %d%% acid weapon damage with each hit.
		If at least one of the strikes hits, an acid splash is generated, doing %0.2f acid damage to all enemies in radius %d around the foe you struck.
		The splash damage will increase with your Spellpower.]]):
		tformat(100 * t.getDamage(self, t), damDesc(self, DamageType.ACID, t.getSplash(self, t)), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Corrupting Strike",
	short_name = "DARK_SURPRISE",
	type = {"corruption/scourge", 4},
	require = corrs_req4,
	points = 5,
	vim = 30,
	cooldown = 8,
	range = 1,
	is_melee = true,
	requires_target = true,
	tactical = { ATTACK = {BLIGHT = 1},},
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 2) end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Corrupting Strike without two weapons!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- Awkward to have this happen first, but part of the point of the talent is to help guarantee any misc disease on hit effects can't be immuned
		target:removeSustainsFilter(function(e) return e.is_nature end, 2)
		target:setEffect(target.EFF_CORRUPTING_STRIKE, 2, {})

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, DamageType.PHYSICAL, t.getDamage(self, t))
		local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, DamageType.PHYSICAL, self:getOffHandMult(offweapon.combat, t.getDamage(self, t)))
		DamageType:projectingFor(self, nil)

		return true
	end,
	info = function(self, t)
		return ([[Corrupt the target reducing disease immunity by 100%% for 2 turns and stripping up to 2 nature sustains then strike with both your weapons dealing %d%% damage.]]):
		tformat(100 * t.getDamage(self, t))
	end,
}
