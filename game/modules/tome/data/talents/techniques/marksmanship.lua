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
local Object = require "engine.Object"
local Map = require "engine.Map"

archery_range = Talents.main_env.archery_range

newTalent{
	name = "Master Marksman",
	type = {"technique/marksmanship", 1},
	points = 5,
	require = { stat = { dex=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	getReload = function(self, t)
		return math.floor(self:combatTalentScale(t, 0, 2.7, "log"))
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, 'ammo_mastery_reload', t.getReload(self, t))
	end,
	getChance = function(self,t) 
		local chance = 15
		return chance
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reload = t.getReload(self,t)
		local chance = t.getChance(self,t)
		return ([[Increases weapon damage by %d%% and physical power by 30 when using bows or slings, as well as your reload rate by %d.
		In addition, your Shoot has a %d%% chance to mark targets on hit.
The mark lasts for 5 turns, grants you visibility of the target (even through walls and other concealment), and causes them to become vulnerable to Headshot, Volley and Called Shots.]]):
tformat(inc * 100, reload, chance)
	end,
}

newTalent{
	name = "First Blood",
	type = {"technique/marksmanship", 2},
	points = 5,
	mode = "passive",
	require = techs_dex_req2,
	getBleed = function(self, t) return self:combatTalentScale(t, 0.3, 1.0) end,
	getStamina = function(self, t) return self:combatTalentScale(t, 1.5, 4.5) end,
	info = function(self, t)
		local bleed = t.getBleed(self,t)*100
		local sta = t.getStamina(self,t)
		return ([[You take advantage of unwary foes (those at or above 90%% life). Against these targets, Shoot, Steady Shot and Headshot bleed targets for %d%% additional damage over 5 turns and have a 50%% increased chance to mark (if capable of marking).
In addition, your Steady Shot, Shoot and Headshot now restore %0.1f stamina on hit.]])
		:tformat(bleed, sta)
	end,
}

newTalent{
	name = "Flare",
	type = {"technique/marksmanship", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 7,
	stamina = 4,
	require = techs_dex_req3,
	range = archery_range,
	radius = 2,
	tactical = { ATTACKAREA = { weapon = 2 }, DISABLE = { blind = 1 } },
	requires_target = true,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 7)) end,
	getBlindDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	getDefensePenalty = function(self, t) return math.floor(self:combatTalentStatDamage(t, "dex", 10, 60)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local _ _, x, y = self:canProject(tg, x, y)
		self:project({type="ball", x=x, y=y, radius=self:getTalentRadius(t), selffire=false}, x, y, DamageType.FLARE, t.getBlindDuration(self, t), {type="light"})
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self,t),
			DamageType.FLARE_LIGHT, t.getDefensePenalty(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="light_zone"},
			nil, false
		)
		return true
	end,
	info = function(self, t)
		local blind = t.getBlindDuration(self,t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local def = t.getDefensePenalty(self,t)
		return ([[Fire a shot at the target tile that blinds enemies for %d turns, marks them for 2 turns and illuminates the area within radius %d for %d turns. Enemies within the illuminated area lose %d defence and stealth power and cannot benefit from concealment.
		The status chance increases with your Accuracy, and the defense reduction with your Dexterity.]])
		:tformat(blind, rad, dur, def)
	end,
}

newTalent{
	name = "Trueshot",
	type = {"technique/marksmanship", 4},
	no_energy = true,
	points = 5,
	cooldown = 25,
	stamina = 30,
	require = techs_dex_req4,
	random_ego = "attack",
	tactical = { BUFF = 3 },
	getSpeed = function(self, t) return self:combatTalentLimit(t, 40, 10, 30)/100 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 7)) end,
	getMarkChance = function(self,t) return self:combatTalentLimit(t, 100, 10, 50) end,
	action = function(self, t)
		local dur = t.getDuration(self,t)
		local speed = t.getSpeed(self,t)
		self:setEffect(self.EFF_TRUESHOT, dur, {src=self, power=speed})
		return true
	end,
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local speed = t.getSpeed(self,t)*100
		local mark = t.getMarkChance(self,t)
		return ([[Enter a state of heightened focus for %d turns. While in this state your ranged attack speed is increased by %d%%, your shots do not consume ammo, and all shots capable of marking have their chance to mark increased by %d%%.]]):
		tformat(dur, speed, mark)
	end,
}