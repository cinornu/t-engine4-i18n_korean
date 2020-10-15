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
	name = "Master Summoner",
	type = {"wild-gift/summon-advanced", 1},
	require = gifts_req_high1,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 20,
	cooldown = 10,
	range = 10,
	tactical = { BUFF = 2 },
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local particle
		if self:addShaderAura("master_summoner", "awesomeaura", {time_factor=6200, alpha=0.7, flame_scale=0.8}, "particles_images/naturewings.png") then
			--
		elseif core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", zoom=2, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
		else
			particle = self:addParticles(Particles.new("master_summoner", 1))
		end
		return {
			cd = self:addTemporaryValue("summon_cooldown_reduction", t.getCooldownReduction(self, t)),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("master_summoner")
		self:removeParticles(p.particle)
		self:removeTemporaryValue("summon_cooldown_reduction", p.cd)
		return true
	end,
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[Reduces the cooldown of all summons by %d%%.]]):
		tformat(cooldownred * 100)
	end,
}

newTalent{
	name = "Grand Arrival",
	type = {"wild-gift/summon-advanced", 2},
	require = gifts_req_high2,
	points = 5,
	mode = "passive",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 3.7, "log")) end,
	effectDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	poisonDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 133) end,
	nbEscorts = function(self, t) return math.max(1,math.floor(self:combatTalentScale(t, 0.3, 2.7, "log"))) end,
	resReduction = function(self, t) return self:combatTalentMindDamage(t, 12, 44) end,
	amtHealing = function(self, t) return 30 + self:combatTalentMindDamage(t, 10, 350) end,
	slowStrength = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 5, 500), 1, 0.1, 0, 0.47 , 369) end, -- Limit speed loss to <100% 
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[While Master Summoner is active, when a creature you summon appears in the world, it will trigger a wild effect:
		- Ritch Flamespitter: Reduce fire resistance of all foes in the radius by %d%%
		- Hydra: Generates a cloud of lingering poison, poisoning all foes caught within for %0.1f nature damage per turn (cumulative)
		- Rimebark: Reduce cold resistance of all foes in the radius by %d%%
		- Fire Drake: Appears with %d fire drake hatchling(s)
		- War Hound: Reduce physical resistance of all foes in the radius by %d%%
		- Jelly: Reduce nature resistance of all foes in the radius by %d%%
		- Minotaur: Reduces movement speed of all foes in the radius by %0.1f%%
		- Stone Golem: Dazes all foes in the radius
		- Turtle: Heals all friendly targets in the radius %d HP
		- Spider: Pins all foes in the radius
		Radius for effects is %d, and the duration of each lasting effect is %d turns.
		The effects improve with your mindpower.]]):tformat(t.resReduction(self, t), t.poisonDamage(self,t) / 6, t.resReduction(self, t), t.nbEscorts(self, t), t.resReduction(self, t), t.resReduction(self, t), 100*t.slowStrength(self,t), t.amtHealing(self,t), radius, t.effectDuration(self, t))
	end,
}

newTalent{
	name = "Nature's Cycle", short_name = "NATURE_CYCLE",
	type = {"wild-gift/summon-advanced", 3},
	require = gifts_req_high3,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return math.min(100, 30 + self:getTalentLevel(t) * 15) end,
	getReduction = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 1.5, 4.1)) end, -- Limit < 5
	info = function(self, t)
		return ([[While Master Summoner is active, each new summon will reduce the remaining cooldown of Pheromones, Detonate and Wild Summon.
		%d%% chance to reduce them by %d.]]):tformat(t.getChance(self, t), t.getReduction(self, t))
	end,
}

newTalent{
	name = "Wild Summon",
	type = {"wild-gift/summon-advanced", 4},
	require = gifts_req_high4,
	points = 5,
	equilibrium = 9,
	cooldown = 25,
	range = 10,
	tactical = { BUFF = 2 },
	no_energy = true,
	on_pre_use = function(self, t, silent)
		return self:isTalentActive(self.T_MASTER_SUMMONER)
	end,
	duration = function(self, t) return math.floor(self:combatTalentLimit(t, 15, 3, 7)) end, -- Limit <15
	action = function(self, t)
		self:setEffect(self.EFF_WILD_SUMMON, t.duration(self,t), {chance=100})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[For %d turn(s), you have 100%% chance that your summons appear as a wild version.
		Each turn the chance disminishes.
		Wild creatures have one more talent/power than the base versions:
		- Ritch Flamespitter: Can fly in the air, spitting its Flamespit past creatures in the path of its target
		- Hydra: Can concentrate its breath into spits when allies would be caught in a breath, instead spitting a bolt
		- Rimebark: Can grab foes, pulling them into range of its ice storm
		- Fire Drake: Can emit a powerful roar to silence its foes
		- War Hound: Can rage, inreasing its critical chance and gaining armour penetration
		- Jelly: Can split into an additional jelly upon taking a large hit (jellies formed by splitting do not count against your summon cap)
		- Minotaur: Can rush toward its target
		- Stone Golem: Can disarm its foes
		- Turtle: Can force all foes in a radius into melee range
		- Spider: Can project an insidious poison at its foes, reducing their healing
		This talent requires Master Summoner to be active to be used.
		Effects scale with levels in summon talents.]]):tformat(t.duration(self,t))
	end,
}
