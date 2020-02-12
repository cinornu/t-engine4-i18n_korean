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

load("/data/general/grids/basic.lua")
load("/data/general/grids/water.lua")
load("/data/general/grids/forest.lua")
load("/data/general/grids/lava.lua")
load("/data/general/grids/sand.lua")
load("/data/general/grids/underground.lua")
load("/data/general/grids/slime.lua")
load("/data/general/grids/jungle.lua")
load("/data/general/grids/cave.lua")
load("/data/general/grids/burntland.lua")
load("/data/general/grids/mountain.lua")
load("/data/general/grids/fortress.lua")
load("/data/general/grids/void.lua")
load("/data/general/grids/autumn_forest.lua")
load("/data/general/grids/snowy_forest.lua")

newEntity{
	define_as = "GRASS_ROCK",
	type = "wall", subtype = "grass",
	name = "huge loose rock", image = "terrain/grass.png", add_mos = {{image="terrain/huge_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "GRASS",
	dig = "GRASS",
	nice_editer = { method="borders_def", def="grass"},
}

newEntity{
	define_as = "UNDERGROUND_ROCK",
	type = "wall", subtype = "underground",
	name = "huge loose rock", image = "terrain/underground_floor.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "UNDERGROUND_FLOOR",
	dig = "UNDERGROUND_FLOOR",
}

newEntity{
	define_as = "CRYSTAL_ROCK",
	type = "wall", subtype = "crystal",
	name = "huge loose rock", image = "terrain/crystal_floor1.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "CRYSTAL_FLOOR",
	dig = "CRYSTAL_FLOOR",
}

newEntity{
	define_as = "DESERT_ROCK",
	type = "wall", subtype = "sand",
	name = "huge loose rock", image = "terrain/sandfloor.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "SAND",
	dig = "SAND",
}

newEntity{
	define_as = "SAND_ROCK",
	type = "wall", subtype = "sand",
	name = "huge loose rock", image = "terrain/sand.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color={r=203,g=189,b=72}, back_color={r=93,g=79,b=22},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "UNDERGROUND_SAND",
	dig = "UNDERGROUND_SAND",
}

newEntity{
	define_as = "CAVE_ROCK",
	type = "wall", subtype = "grass",
	name = "huge loose rock", image = "terrain/cave/cave_floor_1_01.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "CAVEFLOOR",
	dig = "CAVEFLOOR",
}

newEntity{
	define_as = "JUNGLE_ROCK",
	type = "wall", subtype = "grass",
	name = "huge loose rock", image = "terrain/jungle/jungle_grass_floor_01.png", add_mos = {{image="terrain/huge_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "JUNGLE_GRASS",
	dig = "JUNGLE_GRASS",
}

newEntity{
	define_as = "AUTUMN_ROCK",
	type = "wall", subtype = "autumn_grass",
	name = "huge loose rock", image = "terrain/grass/autumn_grass_main_01.png", add_mos = {{image="terrain/huge_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "AUTUMN_GRASS",
	dig = "AUTUMN_GRASS",
}

newEntity{
	define_as = "LAVA_ROCK",
	type = "wall", subtype = "lava",
	name = "huge loose rock", image = "terrain/lava_floor.png", add_mos = {{image="terrain/maze_rock.png"}},
	display = '+', color=colors.GREY, back_color=colors.DARK_GREY,
	shader = "lava",
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "LAVA_FLOOR_FAKE",
	dig = "LAVA_FLOOR_FAKE",
}

newEntity{ define_as = "BURNT_DOOR",
	type = "wall", subtype = "burnt",
	name='burnt passage',
	display='.', color=colors.UMBER, back_color=colors.DARK_GREY, image="terrain/grass_burnt1.png",
	add_mos = {{image="terrain/burnt_floor_deco6.png"},{image="terrain/trees/small_burned_tree_01_trunk.png", display_w=0.5, display_h=.5, display_x=0.5, display_y=0.5}, {image="terrain/trees/burned_tree_01_trunk.png", display_w=0.5, display_h=.5, display_x=0, display_y=0.5}, {image="terrain/trees/small_burned_tree_01_trunk.png", display_w=0.5, display_h=.5, display_x=0.5, display_y=0}, {image="terrain/trees/burned_tree_01_trunk.png", display_w=0.5, display_h=.5, display_x=0, display_y=0}},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "BURNT_GROUND",
	dig = "BURNT_GROUND",
}

-- add snowy door
newEntity{
	define_as = "SNOWY_GRASS_2",
	type = "floor", subtype = "snowy_grass",
	name = "snowy grass", image = "terrain/grass/snowy_grass_main_01.png",
	display = '.', color=colors.LIGHT_GREEN, back_color={r=44,g=95,b=43},
	grow = "SNOWY_TREE_2",
	nice_tiler = { method="replace", base={"SNOWY_PATCH_2", 100, 1, 14}},
	nice_editer = snowy_editer,
}
for i = 1, 14 do newEntity{ base = "SNOWY_GRASS_2", define_as = "SNOWY_PATCH_2"..i, image = ("terrain/grass/snowy_grass_main_%02d.png"):format(i) } end

local snowy_treesdef = {
	{"small_elm", {"shadow", "trunk", "foliage_winter"}},
	{"elm", {tall=-1, "shadow", "trunk", "foliage_winter"}},
}

newEntity{
	define_as = "SNOWY_TREE_2",
	type = "wall", subtype = "snowy_grass",
	name = "winter tree",
	image = "terrain/snowy_tree.png",
	display = '#', color=colors.LIGHT_GREEN, back_color={r=44,g=95,b=43},
	always_remember = true,
	can_pass = {pass_tree=1},
	does_block_move = true,
	block_sight = true,
	dig = "SNOWY_GRASS_2",
	nice_tiler = { method="replace", base={"SNOWY_TREE_2", 100, 1, 30}},
	nice_editer = snowy_editer,
}
for i = 1, 30 do
	newEntity(class:makeNewTrees({base="SNOWY_TREE_2", define_as = "SNOWY_TREE_2"..i, image = "terrain/grass/snowy_grass_main_01.png"}, snowy_treesdef))
end

newEntity{ define_as = "ROCKY_SNOWY_DOOR",
	type = "wall", subtype = "rock",
	name='snowy passage',
	display= '+', color=colors.UMBER, back_color=colors.LIGHT_UMBER,
	image = "terrain/rocky_ground.png",
	add_mos = {{image="terrain/icecave/icecave_rock_2_01.png", display_w=1, display_h=1.5, display_x=0, display_y=-0.5}, {image="terrain/icecave/icecave_rock_3_01.png", display_w=1, display_h=1.5, display_x=0, display_y=-0.5}},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "ROCKY_GROUND",
	dig = "ROCKY_GROUND",
}

newEntity{ define_as = "SNOWY_DOOR",
	type = "wall", subtype = "snowy_grass",
	name='snowy passage',
	display= '+', color=colors.LIGHT_GREEN, back_color={r=44,g=95,b=43},
	image = "terrain/grass/snowy_grass_main_01.png",
	add_mos = {{image="terrain/trees/narrow_cypress_trunk.png", display_w=1, display_h=1, display_x=-0.25, display_y=-0}, {image="terrain/trees/narrow_cypress_trunk.png", display_w=1, display_h=1, display_x=0.25, display_y=-0}, {image="terrain/icecave/icecave_rock_5_01.png", display_w=1.5, display_h=1.5, display_x=-.5, display_y=-0.5}, {image="terrain/trees/narrow_cypress_foliage_winter_01.png", display_w=1, display_h=1, display_x=-0.25, display_y=-0.25}, {image="terrain/trees/narrow_cypress_foliage_winter_02.png", display_w=1, display_h=1, display_x=0.25, display_y=-0.25}},
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "SNOWY_GRASS",
	dig = "SNOWY_GRASS",
}

newEntity{
	define_as = "RIFT2",
	name = "Temporal Rift",
	add_displays = {class.new{image="terrain/demon_portal2.png"}},
	display = '&', color_r=255, color_g=0, color_b=220, back_color=colors.VIOLET,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc=_t[[The rift leads to another floor of the dungeon.]],
	change_level = 1,
}

local rift_editer = { method="sandWalls_def", def="rift"}

newEntity{
	define_as = "SPACETIME_RIFT2",
	type = "wall", subtype = "rift",
	name = "crack in spacetime",
	display = '#', color=colors.YELLOW, image="terrain/rift/rift_inner_05_01.png",
	always_remember = true,
	does_block_move = true,
	_noalpha = false,
	dig = "VOID",
	block_sight = true,
	nice_editer = rift_editer,
}

------------------------------------------------------------
-- To fake people out.
------------------------------------------------------------

newEntity{
	define_as = "WATER_FLOOR_FAKE",
	type = "floor", subtype = "underwater",
	name = "underwater", image = "terrain/underwater/subsea_floor_02.png",
	display = '.', color=colors.LIGHT_BLUE, back_color=colors.DARK_BLUE,
	nice_tiler = { method="replace", base={"WATER_FLOOR_FAKE", 10, 1, 5}},
}
for i = 1, 5 do newEntity{ base="WATER_FLOOR_FAKE", define_as = "WATER_FLOOR_FAKE"..i, image = "terrain/underwater/subsea_floor_02"..string.char(string.byte('a')+i-1)..".png" } end

newEntity{
	define_as = "WATER_WALL_FAKE",
	type = "wall", subtype = "underwater",
	name = "coral wall", image = "terrain/underwater/subsea_granite_wall1.png",
	display = '#', color=colors.AQUAMARINE, back_color=colors.DARK_BLUE,
	always_remember = true,
	can_pass = {pass_wall=1},
	does_block_move = true,
	block_sight = true,
	z = 3,
	nice_tiler = { method="wall3d", inner={"WATER_WALL_FAKE", 100, 1, 5}, north={"WATER_WALL_NORTH_FAKE", 100, 1, 5}, south={"WATER_WALL_SOUTH_FAKE", 10, 1, 14}, north_south="WATER_WALL_NORTH_SOUTH_FAKE", small_pillar="WATER_WALL_SMALL_PILLAR_FAKE", pillar_2="WATER_WALL_PILLAR_2_FAKE", pillar_8={"WATER_WALL_PILLAR_8_FAKE", 100, 1, 5}, pillar_4="WATER_WALL_PILLAR_4_FAKE", pillar_6="WATER_WALL_PILLAR_6_FAKE" },
	always_remember = true,
	does_block_move = true,
	can_pass = {pass_wall=1},
	block_sight = true,
	dig = "WATER_FLOOR_FAKE",
}

for i = 1, 5 do
	newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_FAKE"..i, image = "terrain/underwater/subsea_granite_wall1_"..i..".png", z = 3}
	newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_NORTH_FAKE"..i, image = "terrain/underwater/subsea_granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall3.png", z=18, display_y=-1}}}
	newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_PILLAR_8_FAKE"..i, image = "terrain/underwater/subsea_granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall_pillar_8.png", z=18, display_y=-1}}}
end
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_NORTH_SOUTH_FAKE", image = "terrain/underwater/subsea_granite_wall2.png", z = 3, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall3.png", z=18, display_y=-1}}}
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_SOUTH_FAKE", image = "terrain/underwater/subsea_granite_wall2.png", z = 3}
for i = 1, 14 do newEntity{ base = "WATER_WALL", define_as = "WATER_WALL_SOUTH_FAKE"..i, image = "terrain/underwater/subsea_granite_wall2_"..i..".png", z = 3} end
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_SMALL_PILLAR_FAKE", image = "terrain/underwater/subsea_floor_02.png", z=1, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall_pillar_small.png",z=3}, class.new{image="terrain/underwater/subsea_granite_wall_pillar_small_top.png", z=18, display_y=-1}}}
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_PILLAR_6_FAKE", image = "terrain/underwater/subsea_floor_02.png", z=1, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall_pillar_3.png",z=3}, class.new{image="terrain/underwater/subsea_granite_wall_pillar_9.png", z=18, display_y=-1}}}
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_PILLAR_4_FAKE", image = "terrain/underwater/subsea_floor_02.png", z=1, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall_pillar_1.png",z=3}, class.new{image="terrain/underwater/subsea_granite_wall_pillar_7.png", z=18, display_y=-1}}}
newEntity{ base = "WATER_WALL_FAKE", define_as = "WATER_WALL_PILLAR_2_FAKE", image = "terrain/underwater/subsea_floor_02.png", z=1, add_displays = {class.new{image="terrain/underwater/subsea_granite_wall_pillar_2.png",z=3}}}


newEntity{
	define_as = "WATER_DOOR_FAKE",
	type = "wall", subtype = "underwater",
	name = "door", image = "terrain/underwater/subsea_stone_wall_door_closed.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	nice_tiler = { method="door3d", north_south="WATER_DOOR_VERT_FAKE", west_east="WATER_DOOR_HORIZ_FAKE" },
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "WATER_DOOR_OPEN_FAKE",
	dig = "WATER_FLOOR_FAKE",
}
newEntity{
	define_as = "WATER_DOOR_OPEN_FAKE",
	type = "wall", subtype = "underwater",
	name = "open door", image="terrain/underwater/subsea_granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	always_remember = true,
	is_door = true,
	door_closed = "WATER_DOOR_FAKE",
}
newEntity{ base = "WATER_DOOR_FAKE", define_as = "WATER_DOOR_HORIZ_FAKE", image = "terrain/underwater/subsea_stone_wall_door_closed.png", add_displays = {class.new{image="terrain/underwater/subsea_granite_wall3.png", z=18, display_y=-1}}, door_opened = "WATER_DOOR_HORIZ_OPEN_FAKE"}
newEntity{ base = "WATER_DOOR_OPEN_FAKE", define_as = "WATER_DOOR_HORIZ_OPEN_FAKE", image = "terrain/underwater/subsea_floor_02.png", add_displays = {class.new{image="terrain/underwater/subsea_stone_store_open.png", z=17}, class.new{image="terrain/underwater/subsea_granite_wall3.png", z=18, display_y=-1}}, door_closed = "WATER_DOOR_HORIZ_FAKE"}
newEntity{ base = "WATER_DOOR_FAKE", define_as = "WATER_DOOR_VERT_FAKE", image = "terrain/underwater/subsea_floor_02.png", add_displays = {class.new{image="terrain/underwater/subsea_granite_door1_vert.png", z=17}, class.new{image="terrain/underwater/subsea_granite_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "WATER_DOOR_OPEN_VERT_FAKE", dig = "WATER_DOOR_OPEN_VERT_FAKE"}
newEntity{ base = "WATER_DOOR_OPEN_FAKE", define_as = "WATER_DOOR_OPEN_VERT_FAKE", image = "terrain/underwater/subsea_floor_02.png", add_displays = {class.new{image="terrain/underwater/subsea_granite_door1_open_vert.png", z=17}, class.new{image="terrain/underwater/subsea_granite_door1_open_vert_north.png", z=18, display_y=-1}}, door_closed = "WATER_DOOR_VERT_FAKE"}

newEntity{
	define_as = "WATER_DOWN_FAKE",
	image = "terrain/underwater/subsea_floor_02.png",
	add_displays = {class.new{image="terrain/underwater/subsea_stair_down_03_64.png"}},
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}

local molten_lava_editer = {method="borders_def", def="molten_lava"}
local lava_editer = {method="borders_def", def="lava"}
local lava_mountain_editer = {method="borders_def", def="lava_mountain"}

newEntity{
	define_as = "LAVA_FLOOR_FAKE",
	type = "floor", subtype = "lava",
	name = "lava floor", image = "terrain/lava_floor.png",
	display = '.', color=colors.RED, back_color=colors.DARK_GREY,
	shader = "lava",
	nice_tiler = { method="replace", base={"LAVA_FLOOR_FAKE", 100, 1, 16}},
	nice_editer = lava_editer,
}
for i = 1, 16 do newEntity{ base = "LAVA_FLOOR_FAKE", define_as = "LAVA_FLOOR_FAKE"..i, image = "terrain/lava/lava_floor"..i..".png" } end

newEntity{
	define_as = "LAVA_WALL_FAKE",
	type = "wall", subtype = "lava",
	name = "lava wall", image = "terrain/lava/lava_mountain5.png",
	display = '#', color=colors.RED, back_color=colors.DARK_GREY,
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	nice_editer = lava_mountain_editer,
	nice_tiler = { method="replace", base={"LAVA_WALL_FAKE", 70, 1, 6} },
	dig = "LAVA_FLOOR_FAKE",
}
for i = 1, 6 do newEntity{ base="LAVA_WALL_FAKE", define_as = "LAVA_WALL_FAKE"..i, image = "terrain/lava/lava_mountain5_"..i..".png"} end

newEntity{
	define_as = "LAVA_DOWN_FAKE",
	type = "floor", subtype = "lava",
	name = "next level", image = "terrain/lava_floor.png",
	add_displays = {class.new{image="terrain/stair_down.png"}},
	display = '.', color=colors.RED, back_color=colors.DARK_GREY,
	shader = "lava",
	nice_tiler = { method="replace", base={"LAVA_FLOOR_FAKE", 100, 1, 16}},
	nice_editer = lava_editer,
	notice = true,
	always_remember = true,
	change_level = 1,
}

newEntity{base = "FLOOR", define_as = "ITEMS_VAULT"}
load("/data-items-vault/entities/fortress-grids.lua", function(e) if e.image == "terrain/solidwall/solid_floor1.png" then e.image = "terrain/marble_floor.png" end end)
