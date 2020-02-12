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

newEntity{
	name = " of clairvoyance", addon=true, instant_resolve=true,
	keywords = {clairvoyance=true},
	level_range = {1, 50},
	rarity = 20,

	charm_power_def = {add=8, max=10, floor=true},
	resolvers.charm(function(self, who)
		return ("reveal the area around you, dispelling darkness (radius %d, power %d based on Magic), and detect the presence of nearby creatures for 10 turns"):tformat(self.use_power.radius(self, who), self.use_power.litepower(self, who))
	end,
	15,
	function(self, who)
		local rad = self.use_power.radius(self, who)
		who:setEffect(who.EFF_SENSE, 10, {
			range = rad,
			actor = 1,
		})
		game.logSeen(who, "%s uses %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
		who:project({type="ball", range=0, selffire=true, radius=rad}, who.x, who.y, engine.DamageType.LITE, self.use_power.litepower(self, who))

		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{no_npc_use=true,
	radius = function(self, who) return self:getCharmPower(who) end,
	litepower = function(self, who) return who:combatStatScale("mag", 25, 75) + self:getCharmPower(who) end}),
}

newEntity{
	name = " of lightning storm", addon=true, instant_resolve=true,
	keywords = {['lightning storm']=true},
	level_range = {1, 50},
	rarity = 10,

	charm_power_def = {add=50, max=600, floor=true},
	resolvers.charm(function(self, who)
		local dam = who:damDesc(engine.DamageType.LIGHTNING, self.use_power.damage(self, who))
		local radius = self.use_power.radius
		local duration = 5
		return ("create a radius %d storm for %d turns. Each turn, creatures within take %d lightning damage and will be dazed for 1 turn (%d total damage)"):
			tformat(radius, duration, math.floor(dam / duration), math.floor(dam))
	end,
	15,
	function(self, who)
		local tg = self.use_power.target(self, who)
		local x, y = who:getTarget(tg)
		if not x or not y then return nil end
		local dam = {dam = self.use_power.damage(self, who) / 5, daze = 100, daze_duration = 1}
		game.logSeen(who, "%s conjures a lightning storm from %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
		local DamageType = require "engine.DamageType"
		local MapEffect = require "engine.MapEffect"
		who:project(tg, x, y, function(px, py)
			game.level.map:addEffect(who, px, py, 5, DamageType.LIGHTNING_DAZE, dam, 0, 5, nil, 
				{zdepth=6, type="lightning_storm"}, nil, true)
		end)
		game:playSoundNear(who, "talents/lightning")
		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{
	range = 8,
	radius = 3,
	requires_target = true,
	no_npc_use = function(self, who) return self:restrictAIUseObject(who) end, -- don't let dumb ai hurt friends
	target = function(self, who) return {type="ball", range=self.use_power.range, radius=self.use_power.radius} end,
	tactical = {ATTACKAREA = {LIGHTNING = 2}},
	damage = function(self, who) return self:getCharmPower(who) end
	}),
}

newEntity{
	name = " of conjuration", addon=true, instant_resolve=true,
	keywords = {conjure=true},
	level_range = {1, 50},
	rarity = 10,
	resolvers.genericlast(function(e)
		local DamageType = require "engine.DamageType"
		e.elem = rng.table{
			{DamageType.FIRE, "flame", "fire"},
			{DamageType.COLD, "freeze", "cold"},
			{DamageType.LIGHTNING, "lightning_explosion", "lightning"},
			{DamageType.ACID, "acid", "acid"},
		}
	end),

	charm_power_def = {add=50, max=500, floor=true},
	resolvers.charm(function(self, who)
			local dt = engine.DamageType[self.elem[3]:upper()]
			local dam = who:damDesc(dt, self.use_power.damage(self, who))
			return ("fire a magical bolt dealing %d %s damage"):tformat(dam, engine.DamageType:get(dt).name)
		end,
		15,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local dam = self.use_power.damage(self, who)
			local elem = self.elem
			game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			who:project(tg, x, y, elem[1], dam, {type=elem[2]})
			game:playSoundNear(who, "talents/fire")
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{ range = 8,
		requires_target = true,
		target = function(self, who) return {type="bolt", range=self.use_power.range} end,
		damage = function(self, who) return self:getCharmPower(who) end,
		tactical = {ATTACK = 1}}
	),
}

-- gfx
newEntity{
	name = " of shielding", addon=true, instant_resolve=true,
	keywords = {shielding=true},
	level_range = {1, 50},
	rarity = 8,

	charm_power_def = {add=50, max=600, floor=true},
	resolvers.charm(
		function(self, who) 
			local shield = self.use_power.shield(self, who) * (100 + (who:attr("shield_factor") or 0)) / 100
			return ("create a shield absorbing up to %d damage on yourself and all friendly characters within 10 spaces for %d turns"):
				tformat(shield, 4) end,
		20,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local shield = self.use_power.shield(self, who)
			game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name = true, do_color = true})
			who:project(tg, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if target:reactionToward(who) < 0 then return end
				target:setEffect(target.EFF_DAMAGE_SHIELD, 4, {power=shield})

				--game:playSoundNear(who, "talents/heal")
			end) 
			return {id=true, used=true}
		end,
	"T_GLOBAL_CD",
	{
	radius = function(self, who) return 10 end,
	shield = function(self, who) return self:getCharmPower(who) end,
	target = function(self, who) return {type="ball", nowarning=true, radius=self.use_power.radius(self, who)} end,
	tactical = {HEAL = 1},
	})
}