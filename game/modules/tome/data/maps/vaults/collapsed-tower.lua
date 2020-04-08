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

local Talents = require("engine.interface.ActorTalents")

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}

local turret = function(version)
	local NPC = require "mod.class.NPC"
	return NPC.new{
		type = "construct", subtype = "crystal", image="trap/trap_beam.png",
		display = "t",
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
		life_rating = 20,
		rank = 2,
		inc_damage = { all = -75, },

		open_door = true,
		cut_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		poison_immune = 1,
		disease_immune = 1,
		stone_immune = 1,
		see_invisible = 30,
		no_breath = 1,
		infravision = 10,
		never_move = 1,

		autolevel = "caster",
		level_range = {1, nil}, exp_worth = 1,
		stats = { mag=16, con=22 },
		size_category = 2,
		name = _t"elemental crystal", color=colors.BLUE,
		combat = { dam=resolvers.rngavg(1,2), atk=2, apr=0, dammod={str=0.4} },
		combat_armor = 10, combat_def = 0,
		talent_cd_reduction={[Talents.T_ELEMENTAL_BOLT]=3, },

		resolvers.talents{
			[Talents.T_ELEMENTAL_BOLT]={base=2, every=4, max=8},
		},

		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=3, },
	}
end

local stairs = function()
	local terrains = mod.class.Grid:loadList("/data/general/grids/basic.lua")
	return game.state:dynamicZoneEntry(terrains.UP, "collapsed-tower", {
		name = _t"collapsed tower",
		level_range = {game.zone.base_level, game.zone.base_level},
		__applied_difficulty = true, -- Difficulty already applied to parent zone
		level_scheme = "player",
		max_level = 1,
		actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(0,4) end,
		width = 20, height = 20,
		ambient_music = "Swashing the buck.ogg",
		persistent = "zone",
		
		no_worldport = true,
		min_material_level = util.getval(game.zone.min_material_level),
		max_material_level = util.getval(game.zone.max_material_level),
		generator = {
			map = {
				class = "engine.generator.map.Static",
				map = "zones/collapsed-tower",
			},
			trap = { nb_trap = {0, 0} },
			object = { nb_object = {0, 0} },
			actor = { nb_npc = {0, 0} },
		}
	}, {
		npc_list = {"/data/general/npcs/thieve.lua"},
		object_list = {"/data/general/objects/objects.lua"},
		grid_list = {"/data/general/grids/basic.lua"},
		trap_list = {"/data/general/traps/natural_forest.lua"},
	},
	function(zone, goback)
		goback(_t"stairs back to %s", zone.grid_list.DOWN)
	end)
end

specialList("terrain", {
	"/data/general/grids/water.lua",
	"/data/general/grids/forest.lua",
}, true)
border = 0
--rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', "GRASS")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile(';', "FLOWER")
defineTile('~', "DEEP_WATER")
defineTile('#', "WALL")
defineTile('X', "TREE")

specialList("actor", {
	"/data/general/npcs/construct.lua",
	"/data/general/npcs/plant.lua",
	"/data/general/npcs/skeleton.lua",
	"/data/general/npcs/bear.lua",   
})
specialList("trap", {
	"/data/general/traps/natural_forest.lua",
})

defineTile('a', "FLOOR", {random_filter={add_levels=5, tome_mod="vault"}}, nil)
defineTile('S', "FLOOR", {random_filter={type="scroll", ego_chance=100}}, nil)
defineTile('$', "FLOOR", {random_filter={add_levels=25, type="money"}})
defineTile('g', "FLOOR", nil, {random_filter={add_levels=5, name="broken golem"}})
defineTile('p', "GRASS", nil, {random_filter={add_levels=5, name="poison ivy"}})
defineTile('v', "GRASS", nil, {random_filter={add_levels=5, name="giant venus flytrap"}})
defineTile('s', "FLOOR", {random_filter={add_levels=5, tome_mod="vault"}}, {random_filter={add_levels=5, name="skeleton mage"}})
defineTile('b', "FLOWER", nil, {random_filter={name="black bear"}})
defineTile('t', "FLOOR", nil, turret(version))
defineTile('^', "FLOOR", nil, nil, {random_filter={name="sliding rock"}})
defineTile('<', stairs())

return {
[[,,,,,,,,;;;;;,,,,]],
[[,,X##,,#;~~~;,,,,]],
[[,.##,,##;~~~;##,,]],
[[,...XXX,b;;;b###,]],
[[,##.........####,]],
[[,######..####.##,]],
[[.#.#..#####...t#,]],
[[.!...^t#.<+sp;a#,]],
[[.#.#..##..#,;;.#,]],
[[,#.##+#####p...#,]],
[[,#g#p,,,^.#....#,]],
[[,###..;;^v##+###,]],
[[,,##.vp,,....##,,]],
[[,,,##$$SSS$$##,,,]],
[[,,,,#########,,,,]],
[[,,,,,,,,,,,,,,,,,]],
}
