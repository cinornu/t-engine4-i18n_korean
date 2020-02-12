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
	name = " of psionic shield", addon=true, instant_resolve=true,
	keywords = {['psionic shield']=true},
	level_range = {1, 50},
	rarity = 15,
	charm_power_def = {add=3, max=200, floor=true},
	resolvers.charm(_t"setup a psionic shield, reducing all damage taken by %d for 5 turns", 25, function(self, who)
		who:setEffect(who.EFF_PSIONIC_SHIELD, 5, {kind="all", power=self:getCharmPower(who)})
		game.logSeen(who, "%s uses %s!", who:getName():capitalize(), self:getName{no_add_name=true, do_color=true})
		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{on_pre_use = function(self, who)
		local shield = who:hasEffect(who.EFF_PSIONIC_SHIELD)
		return not (shield and shield.kind == "kinetic")
	end,
	tactical = { DEFEND = 2 }}),
}

-- Scaling on this is pretty dumb
newEntity{
	name = " of clear mind", addon=true, instant_resolve=true,
	keywords = {clearmind=true},
	level_range = {1, 50},
	rarity = 20,
	charm_power_def = {add=1, max=5, floor=true},
	resolvers.charm(_t"remove 1 confusion or silence effect and prevent the application of %d detrimental mental effects for 5 turns", 25, function(self, who)
		who:removeEffectsFilter(function(e) return (e.subtype.confusion or e.subtype.silence) end, 1)
		who:setEffect(who.EFF_CLEAR_MIND, 5, {power=self:getCharmPower(who)})
		game.logSeen(who, "%s uses %s!", who:getName():capitalize(), self:getName{no_add_name=true, do_color=true})
		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{tactical = {CURE = function(who, t, aitarget)
			local nb = 0
			for eff_id, p in pairs(who.tmp) do
				local e = who.tempeffect_def[eff_id]
				if e.status == "detrimental" and (e.subtype.confusion or e.subtype.silence) then
					nb = nb + 1
				end
			end
			return nb
		end,
	}}
	),
}

newEntity{
	name = " of gale force", addon=true, instant_resolve=true,
	keywords = {galeforce=true},
	level_range = {1, 50},
	rarity = 10,
	charm_power_def = {add=50, max=500, floor=true},
	resolvers.charm(
		function(self, who)
			local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
			return ("project a gust of wind in a cone knocking enemies back %d spaces and dealing %d physical damage"):tformat(self.use_power.knockback(self, who), dam)
		end,
		15,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local dam = self.use_power.damage(self, who)
			local kb = self.use_power.knockback(self, who)

			game.logSeen(who, "%s uses %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name=true, do_color=true})
			local DamageType = require "engine.DamageType"
			local state = {}
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "mudflow", {radius=tg.radius, tx=x-who.x, ty=y-who.y})
			who:project(tg, x, y, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if not target or target == who or state[target] then return end
				state[target] = true
				local DamageType = require "engine.DamageType"
				DamageType:get(DamageType.PHYSICAL).projector(who, tx, ty, DamageType.PHYSICAL, dam)
				if target:canBe("knockback") then
					target:knockback(who.x, who.y, kb)		
				end
			end, dam)
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{
		damage = function(self, who) return self:getCharmPower(who) end,
		knockback = function(self, who) return math.floor(self:getCharmPower(who) / 50) + 5 end,
		target = function(self, who) return {type="cone", radius=4, range=0} end,
		requires_target = true,
		tactical = { attackarea = { physical = 2} }
		}
	),
}

newEntity{
	name = " of mindblast", addon=true, instant_resolve=true,
	keywords = {mindblast=true},
	level_range = {1, 50},
	rarity = 10,
	charm_power_def = {add=50, max=500, floor=true},
	resolvers.charm(function(self, who)
			local dam = who:damDesc(engine.DamageType.MIND, self.use_power.damage(self, who))
			return ("blast the opponent's mind dealing %d mind damage and silencing them for 4 turns"):tformat(dam )
		end,
		15,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local damage = self.use_power.damage(self, who)
			game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			if not x or not y then return nil end
			who:project(tg, x, y, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if not target then return end
				local DamageType = require "engine.DamageType"
				DamageType:get(DamageType.MIND).projector(who, tx, ty, DamageType.MIND, damage)
				if target:canBe("silence") then
					target:setEffect(target.EFF_SILENCED, 4, {apply_power = who:combatMindpower()})
				end
			end, dam, {type="mind"})
			game:playSoundNear(who, "talents/mind")
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{ range = 10,
		requires_target = true,
		target = function(self, who) return {type="hit", range=self.use_power.range} end,
		damage = function(self, who) return self:getCharmPower(who) end,
		tactical = {ATTACK = 1}}
	),
}
