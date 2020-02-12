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
	name = "Blood Red Moon",
	type = {"celestial/eclipse", 1},
	mode = "passive",
	require = divi_req1,
	points = 5,
	getCrit = function(self, t) return self:combatTalentScale(t, 3, 15, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellcrit", t.getCrit(self, t))
	end,
	info = function(self, t)
		return ([[Increases your spell critical chance by %d%%.]]):
		tformat(t.getCrit(self, t))
	end,
}

newTalent{
	name = "Totality",
	type = {"celestial/eclipse", 2},
	require = divi_req2,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	positive = 15,
	negative = 15,
	fixed_cooldown = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	getResistancePenetration = function(self, t) return self:combatLimit(self:getCun()*self:getTalentLevel(t), 100, 5, 0, 55, 500) end, -- Limit to <100%
	getCooldownReduction = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6, "log")) end,
	action = function(self, t)
		self:setEffect(self.EFF_TOTALITY, t.getDuration(self, t), {power=t.getResistancePenetration(self, t)})
		for tid, cd in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[1]:find("^celestial/") then
				self:alterTalentCoolingdown(tid, -t.getCooldownReduction(self, t))
			end
		end
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local penetration = t.getResistancePenetration(self, t)
		local cooldownreduction = t.getCooldownReduction(self, t)
		return ([[Increases your light and darkness resistance penetration by %d%% for %d turns, and reduces the cooldown of all Celestial skills by %d.
		The resistance penetration will increase with your Cunning.]]):
		tformat(penetration, duration, cooldownreduction)
	end,
}

newTalent{
	name = "Corona",
	type = {"celestial/eclipse", 3},
	mode = "sustained",
	require = divi_req3,
	points = 5,
	proj_speed = 4,
	range = 6,
	cooldown = 10,
	tactical = { BUFF = 2 },
	sustain_negative = 10,
	sustain_positive = 10,
	getTargetCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getLightDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 70) end,
	getDarknessDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 70) end,
	on_crit = function(self, t)
		if self:getPositive() < 2 or self:getNegative() < 2 then
		--	self:forceUseTalent(t.id, {ignore_energy=true})
			return nil
		end
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

		local corona = rng.range(1, 100)
			if corona > 50 then
				local tg = {type="bolt", range=self:getTalentRange(t), talent=t, friendlyfire=false, display={particle="bolt_light"}}
				self:projectile(tg, a.x, a.y, DamageType.LIGHT, t.getLightDamage(self, t), {type="light"})
				self:incPositive(-2)
			else
				local tg = {type="bolt", range=self:getTalentRange(t), talent=t, friendlyfire=false, display={particle="bolt_dark"}}
				self:projectile(tg, a.x, a.y, DamageType.DARKNESS, t.getDarknessDamage(self, t), {type="shadow"})
				self:incNegative(-2)
			end
		end
	end,
	activate = function(self, t)
		local ret = {}
		ret.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="corona_02", radius=0}))
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local darknessdamage = t.getDarknessDamage(self, t)
		return ([[Each time one of your spells criticals, you project a bolt of light or shadow at up to %d targets within radius %d, doing %0.2f light damage or %0.2f darkness damage per bolt.
		This effect costs 2 positive or 2 negative energy each time it's triggered, and will not activate if either your positive or negative energy is below 2.
		The damage scales with your Spellpower.
		This spell cannot crit.]]):
		tformat(targetcount, self:getTalentRange(t), damDesc(self, DamageType.LIGHT, lightdamage), damDesc(self, DamageType.DARKNESS, darknessdamage))
	end,
}

newTalent{
	name = "Darkest Light",
	type = {"celestial/eclipse", 4},
	require = divi_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	positive = 25,
	negative = 25,
	tactical = { ATTACKAREA = {LIGHT = 2} },
	range = 0,
	radius = 10,
	direct_hit = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	getDotDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	getConversion = function(self, t) return math.min(1, self:combatTalentScale(t, 0.1, 0.55)) end,
	getDuration = function(self, t) return 5 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_DARKLIGHT, t.getDuration(self, t), {src=self, dotDam=self:spellCrit(t.getDotDamage(self, t)), conversion=t.getConversion(self, t)})
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "shadow_flash", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y})
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dotDam = t.getDotDamage(self, t)
		local conversion = t.getConversion(self, t)
		local duration = t.getDuration(self, t)
		return ([[Shroud foes within radius %d in darkest light, dealing %0.2f light and %0.2f darkness damage per turn and converting %d%% of the damage they deal between light and darkness for %d turns.]]):tformat(radius, damDesc(self, DamageType.LIGHT, dotDam), damDesc(self, DamageType.DARKNESS, dotDam), conversion*100, duration)
	end,
}
