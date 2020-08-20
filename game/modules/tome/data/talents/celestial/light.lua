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
	name = "Healing Light",
	type = {"celestial/light", 1},
	require = spells_req1,
	points = 5,
	random_ego = "defensive",
	cooldown = 10,
	positive = -10,
	tactical = { HEAL = 2},
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 20, 440) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:spellCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true, size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[An invigorating ray of Sunlight shines upon you, healing your body for %d life.
		The amount healed will increase with your Spellpower.]]):
		tformat(heal)
	end,
}

newTalent{
	name = "Bathe in Light",
	type = {"celestial/light", 2},
	require = spells_req2,
	random_ego = "defensive",
	points = 5,
	cooldown = 20,
	positive = -20,
	tactical = { HEAL = 2.5, SELF = {POSITIVE = 1 }},
	range = 0,
	radius = 2,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 4, 80) * 0.75 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.HEALING_POWER, self:spellCrit(t.getHeal(self, t)),
			self:getTalentRadius(t),
			5, nil,
			{overlay_particle={zdepth=6, only_one=true, type="circle", args={img="sun_circle", a=10, speed=0.04, radius=self:getTalentRadius(t)}}, type="healing_vapour"},
			nil, true
		)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t)
		local heal_fact = heal/(heal+50)
		local duration = t.getDuration(self, t)
		return ([[A magical zone of Sunlight appears around you, healing and shielding all within a radius of %d for %0.2f per turn and increasing healing effects on everyone within by %d%%. The effect lasts for %d turns.
		Existing damage shields will be added to instead of overwritten and have their duration set to 2 if it isn't higher.
		If the same shield is refreshed 20 times it will become unstable and explode, removing it.
		It also lights up the affected area.
		The amount healed will increase with the Magic stat]]):
		tformat(radius, heal, heal_fact*100, duration)
	end,
}

newTalent{
	name = "Barrier",
	type = {"celestial/light", 3},
	require = spells_req3,
	points = 5,
	random_ego = "defensive",
	positive = -20,
	cooldown = 15,
	tactical = { DEFEND = 2, POSITIVE = 0.5 },
	getAbsorb = function(self, t) return self:combatTalentSpellDamage(t, 30, 370) end,
	getDuration = function(self, t) return 10 end,
	action = function(self, t)
		self:setEffect(self.EFF_DAMAGE_SHIELD, t.getDuration(self, t), {color={0xe1/255, 0xcb/255, 0x3f/255}, power=self:spellCrit(t.getAbsorb(self, t))})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local absorb = self:getShieldAmount(t.getAbsorb(self, t))
		local duration = self:getShieldDuration(t.getDuration(self, t))
		return ([[A protective shield forms around you that lasts for up to %d turns and negates %d damage.
 		The total damage the barrier can absorb will increase with your Spellpower and can crit.]]):
		tformat(duration, absorb)
	end,
}

newTalent{
	name = "Providence",
	type = {"celestial/light", 4},
	require = spells_req4,
	points = 5,
	random_ego = "defensive",
	positive = -20,
	cooldown = 30,
	tactical = {CURE = 3},
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		self:setEffect(self.EFF_PROVIDENCE, t.getDuration(self, t), {})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Places you under the protection of a ray of sunlight. For %d turns, the light removes a single negative effect from you every turn.]]):
		tformat(duration)
	end,
}

