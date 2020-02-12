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

-- Find a random spot
local x, y = game.state:findEventGrid(level)
if not x then return false end

local kind = rng.table{"fire", "fire", "cold", "cold", "storm", "storm", "multihued"}

print("[EVENT] Placing event", kind.."-dragon-cave", "at", x, y)

local g = game.state:dynamicZoneEntry(game.level.map(x, y, engine.Map.TERRAIN):cloneFull(), kind.."-dragon-cave", {
	name = _t"Intimidating Cave",
	level_range = game.zone.actor_adjust_level and {math.floor(game.zone:actor_adjust_level(game.level, game.player)*1.05),
		math.ceil(game.zone:actor_adjust_level(game.level, game.player)*1.15)} or {game.zone.base_level, game.zone.base_level}, -- 5-15% higher levels
	__applied_difficulty = true, -- Difficulty already applied to parent zone
	max_level = 1,
	level_scheme = "player",
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 50, height = 50,
	ambient_music = "Swashing the buck.ogg",
	persistent = "zone",
	
	no_worldport = game.zone.no_worldport,
	min_material_level = util.getval(game.zone.min_material_level),
	max_material_level = util.getval(game.zone.max_material_level),
	generator =  {
		map = {
			class = "engine.generator.map.Cavern",
			zoom = 6,
			min_floor = 1200,
			floor = "CAVEFLOOR",
			wall = "CAVEWALL",
			up = "DYNAMIC_ZONE_EXIT",
			door = "CAVEFLOOR",
		},
		actor = {
			class = "mod.class.generator.actor.Random",
			nb_npc = {25, 25},
			guardian = {special=function(e) return e.rank and e.rank >= 2 end, random_elite={life_rating=function(v) return v * 1.5 + 4 end,
			nb_rares=(rng.percent(resolvers.current_level-50) and 4 or 3),
			nb_classes=(rng.percent(resolvers.current_level-50) and 2 or 1)}
			},
		},
		object = {
			class = "engine.generator.object.Random",
			filters = {{type="gem"}},
			nb_object = {25, 35},
		},
		trap = {
			class = "engine.generator.trap.Random",
			nb_trap = {6, 9},
		},
	},
}, {
	npc_list = {"/data/general/npcs/"..kind.."-drake.lua"},
	object_list = {"/data/general/objects/objects.lua"},
	grid_list = {"/data/general/grids/cave.lua"},
	trap_list = {"/data/general/traps/natural_forest.lua"},
},
function(zone, goback)
	goback(_t"ladder back to %s", zone.grid_list.CAVE_LADDER_UP_WILDERNESS)
end)

g.display='>' g.color_r=0 g.color_g=0 g.color_b=255 g.notice = true
if engine.Map.tiles.nicer_tiles then
	g.add_displays = g.add_displays or {}
	g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/crystal_ladder_down.png", z=5}
end

game.zone:addEntity(game.level, g, "terrain", x, y)

local i, j = util.findFreeGrid(x, y, 10, true, {[engine.Map.ACTOR]=true})
if not i then return end

-- Pop hatchlings at the stairs
local npcs = mod.class.NPC:loadList{"/data/general/npcs/"..kind.."-drake.lua"}
local m = game.zone:makeEntity(game.level, "actor", {base_list=npcs, special=function(e) return e.rank and e.rank == 1 end}, nil, true)
if m then
	game.zone:addEntity(game.level, m, "actor", i, j)
end

return x, y
