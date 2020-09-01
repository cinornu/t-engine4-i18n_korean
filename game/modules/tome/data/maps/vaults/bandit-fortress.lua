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
unique = "bandit-fortress" -- one per map

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}

onplace = function(room, zone, level, map, data) -- flag the map as having this vault
	map._bandit_fortress = level.level
end

onGenerated(function(zone, level, map) -- update the zone after the vault is placed (in case the level was regenerated)
	if map._bandit_fortress == level.level then
		zone._bandit_fortress = level.level
	end
end
)

local stairs = function()
	local terrains = mod.class.Grid:loadList("/data/general/grids/basic.lua")
	return game.state:dynamicZoneEntry(terrains.UP, "bandit-fortress", {
		name = _t"bandit fortress",
		level_range = {game.zone.base_level, game.zone.base_level},
		__applied_difficulty = true, -- Difficulty already applied to parent zone
		level_scheme = "player",
		max_level = 1,
		actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level+4 + rng.range(-2,6) end,
		width = 35, height = 60,
		ambient_music = "Swashing the buck.ogg", -- check for better fit
		persistent = "zone",
		
		no_worldport = true,
		min_material_level = util.bound(util.getval(game.zone.min_material_level) + 1, 1, 5), -- vaults have better loot! acts as reward to compensate for the significant difficulty
		max_material_level = util.bound(util.getval(game.zone.max_material_level) + 1, 1, 5),
		generator = {
			map = {
				class = "engine.generator.map.Static",
				map = "zones/bandit-fortress",
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
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', "GRASS")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('f', function() if rng.percent(35) then return "FLOWER" else return "GRASS" end end) -- so pretty, so beautiful <3
defineTile('~', "DEEP_WATER")
defineTile('#', "WALL")
defineTile('X', "TREE")

specialList("actor", {
	"/data/general/npcs/thieve.lua",
	"/data/general/npcs/minotaur.lua",
	"/data/general/npcs/troll.lua",
})
specialList("trap", {
	"/data/general/traps/natural_forest.lua",
})
local thieves = {
   "rogue",
   "rogue sapper",
   "thief",
   "cutpurse",
   "assassin"
}

local rogues = {}
local Birther = require "engine.Birther"
for name, data in pairs(Birther.birth_descriptor_def.class["Rogue"].descriptor_choices.subclass) do
	if Birther.birth_descriptor_def.subclass[name] and not Birther.birth_descriptor_def.subclass[name].not_on_random_boss then rogues[#rogues+1] = name end
end

defineTile('g', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=4, random_boss={name_scheme=_t"#rng# the Guard", nb_classes=0, force_classes={(rng.table(rogues))}, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.2}}})
defineTile('G', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=6, random_boss={name_scheme=_t"#rng# the Guard", nb_classes=0, force_classes={(rng.table(rogues))}, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.2}}})
defineTile('r', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=4}})
defineTile('R', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=7}})
defineTile('l', "FLOOR", nil, {random_filter={add_levels=10, name = "bandit lord"}})
defineTile('a', "FLOOR", {random_filter={add_levels=5, tome_mod="vault"}}, nil)
defineTile('$', "FLOOR", {random_filter={add_levels=25, type="money"}})
defineTile('t', "FLOOR", nil, nil, {random_filter={add_levels=20}})
defineTile('j', "FLOOR", {random_filter={add_levels=10, type="jewelry", tome_mod="gvault"}})
defineTile('<', stairs(), nil, {random_filter={name=(rng.table(thieves)), add_levels=6, random_boss={name_scheme=_t"#rng# the Guard", nb_classes=0, force_classes={(rng.table(rogues))}, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.2,
on_die=function(self, who) -- drop lore note on death
local lore = mod.class.Object.new{
	type = "lore", subtype="lore",
	unided_name = _t"scroll", identified=true,
	display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll.png",
	encumber = 0,
	name = _t"Guard's Journal", lore="bandit-vault-guard",
	desc = _t[[A messily scrawled pile of loose papers.]],
	level_range = {1, 20},
	rarity = false,
	}
	game.zone:addEntity(game.level, lore, "object", self.x, self.y)
end	}}})

return {
[[,,,,,,,,,,,,,fX#######,]],
[[,,###########ff#R$$$R#,]],
[[,,#.$r.l..$.####...G.#,]],
[[,,#jj.......+.t+.....#,]],
[[,,#R$$..$$$R#######+###]],
[[,,#####+######~~#$$...#]],
[[,,,X#....g#~~~~~#<j.rr#]],
[[,,,,#!#####,,,,,#######]],
}
