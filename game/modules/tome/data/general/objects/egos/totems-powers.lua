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

-- gfx
newEntity{
	name = " of healing", addon=true, instant_resolve=true,
	keywords = {healing=true},
	level_range = {1, 50},
	rarity = 8,

	charm_power_def = {add=50, max=600, floor=true},
	resolvers.charm(
		function(self, who) 
			local heal = self.use_power.heal(self, who)
			return ("heal yourself and all friendly characters within 10 spaces for %d"):
				tformat(heal) end,
		15,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local heal = self.use_power.heal(self, who)
			game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name = true, do_color = true})
			who:project(tg, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if target:reactionToward(who) < 0 then return end
				target:attr("allow_on_heal", 1)
				target:heal(heal, who)
				target:attr("allow_on_heal", -1)
				game:playSoundNear(who, "talents/heal")
			end) 
			return {id=true, used=true}
		end,
	"T_GLOBAL_CD",
	{
	radius = function(self, who) return 10 end,
	heal = function(self, who) return self:getCharmPower(who) end,
	target = function(self, who) return {type="ball", nowarning=true, radius=self.use_power.radius(self, who), ignore_nullify_all_friendlyfire=true} end,
	tactical = {HEAL = 1},
	})
}

newEntity{
	name = " of stinging", addon=true, instant_resolve=true,
	keywords = {stinging=true},
	level_range = {1, 50},
	rarity = 8,

	charm_power_def = {add=50, max=600, floor=true},  -- Higher damage because the damage can be cleansed and is delayed
	resolvers.charm(function(self, who)
			local dam = who:damDesc(engine.DamageType.NATURE, self.use_power.damage(self, who))
			return ("sting an enemy dealing %d nature damage over 7 turns and reducing their healing by 50%%%%"):tformat(dam, 50)
		end,
		15,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local dam = {dam = self.use_power.damage(self, who), heal_factor = 50, dur = 7}
			game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			who:project(tg, x, y, engine.DamageType.INSIDIOUS_POISON, dam, {type="slime"})
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

newEntity{
	name = " of thorny skin", addon=true, instant_resolve=true,
	keywords = {thorny=true},
	level_range = {1, 50},
	rarity = 16,

	charm_power_def = {add=5, max=100, floor=true},
	resolvers.charm(function(self) return ("harden the skin for 7 turns increasing armour by %d and armour hardiness by %d%%%%"):tformat(self:getCharmPower(who), 20 + self.material_level * 10) end, 20, function(self, who)
		game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name = true, do_color = true})
		who:setEffect(who.EFF_THORNY_SKIN, 7, {ac=self:getCharmPower(who), hard=20 + self.material_level * 10})
		game:playSoundNear(who, "talents/heal")
		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{on_pre_use = function(self, who)
		return not who:hasEffect(who.EFF_THORNY_SKIN)
	end,
	tactical = {DEFEND = 1.5}}),
}

-- This is out of theme with nature, but then, it always was, and people are used to tentacle totems.  Consider retheming to Vine Lasher or some such.
newEntity{
	name = " of summon tentacle", addon=true, instant_resolve=true,
	keywords = {tentacle=true},
	level_range = {1, 50},
	rarity = 12,
	charm_power_def = {add=45, max=500, floor=true},
	resolvers.charm(function(self, who)
		local stats = self.use_power.tentacleStats(self, who)
		local str = ("(Tentacle Stats)\nLife:  %d\nBase Damage:  %d\nArmor:  %d\nAll Resist:  %d"):tformat(stats.max_life, stats.combat.dam, stats.combat_armor, stats.resists.all)
		return	("summon a resilient tentacle up to %d spaces away for %d turns.  Each turn the tentacle will strike a random enemy in range 3 dealing physical damage and attempting to pin them.\n\n%s"):
			tformat(5, stats.summon_time, str) 
		end,
		 20, 
		 function(self, who)
			if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end
			local tg = self.use_power.target(self, who)
			local tx, ty, target = who:getTarget(tg)
			if not tx or not ty then return nil end
			local _ _, _, _, tx, ty = who:canProject(tg, tx, ty)
			target = game.level.map(tx, ty, engine.Map.ACTOR)
			if target == who then target = nil end
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			local Talents = require "engine.interface.ActorTalents"
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/horror_eldritch_grgglck_s_tentacle.png", display_h=1, display_y=0}}},
				name = _t"Lashing Tentacle",
				type = "horror", subtype = "tentacle",
				desc = _t"A lashing tentacle.",
				rank = 1,
				display = "T", color = colors.GREY,
				life_rating=1,
				combat = {
					dam=50,
					atk=900, apr=900,  -- Complex as is, let the players not worry about the more fiddly melee stats
					dammod={str=1},
				},
				level_range = {1, who.level}, exp_worth = 0,
				silent_levelup = true,
				combat_armor=20,
				combat_armor_hardiness=100,
				resists = {all = 30},
				autolevel = "warrior",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				never_move=1,
				stats = { str=14, dex=18, con=20, },
				size_category = 3,
				no_breath = 1,
				cant_be_moved = 1,
				knockback_resist=1,
				combat_physresist=100,
				combat_spellresist=100,
				on_act = function(self)
					local tg = {type="ball", radius=3}
					local grids = self:project(tg, self.x, self.y, function() end)
					local tgts = {}
					for x, ys in pairs(grids) do for y, _ in pairs(ys) do
						local target = game.level.map(x, y, engine.Map.ACTOR)
						if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
					end end

					local target = rng.tableRemove(tgts)
					if target then
						if self:attackTarget(target, nil, 1, true) and target:canBe("pin") then target:setEffect(target.EFF_PINNED, 1, {}) end
					end
					self.energy.value = 0
				end,
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time = 0,
			}

			m:resolve()
			who:logCombat(target or {name = _t"a spot nearby"}, "#Source# points %s %s at #target#, releasing a writhing tentacle!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true
			if game.party:hasMember(who) then
				game.party:addMember(m, {
					control=false,
					type="summon",
					title=_t"Summon",
				})
			end
			local stats = self.use_power.tentacleStats(self, who)
			table.mergeAdd(m, stats, true)
			m.life = m.max_life

		game.logSeen(who, "%s activates %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name = true, do_color = true})
		return {id=true, used=true}
	end,
	"T_GLOBAL_CD",
	{
	power = 25,
	range = 5,
	radius = 3,
	target = function(self, who) return {type="ball", nowarning=true, range=self.use_power.range, radius=self.use_power.radius, friendlyfire=false, nolock=true} end,
	-- Stats are part randomly resolved, part linked to charm power
	tentacle_stats = {
		combat = {dam = resolvers.mbonus_material(100, 0)},
		max_life = resolvers.mbonus_material(400, 0),
		combat_armor = resolvers.mbonus_material(50, 0),
		resists = {all = resolvers.mbonus_material(50, 0)},
		summon_time = resolvers.mbonus_material(10, 3),
	},
	tentacleStats = function(self, who)
		local stats = {
			combat = {dam = self:getCharmPower(who)},
			max_life = self:getCharmPower(who)*2,
		}

		-- Add the resolved stat bonuses
		table.mergeAdd(stats, table.clone(self.use_power.tentacle_stats, true), true)

		return stats
	end,
	requires_target = true,
	tactical = {DEFEND = 1.5}}

	),
}