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
	define_as = "UNDERGROUND_FLOOR",
	type = "floor", subtype = "underground",
	name = "floor", image = "terrain/underground_floor.png",
	display = '.', color=colors.LIGHT_UMBER, back_color=colors.UMBER,
	grow = "UNDERGROUND_TREE",
	nice_tiler = { method="replace", base={"UNDERGROUND_FLOOR", 50, 1, 20}},
}
for i = 1, 20 do
local add = nil
if rng.percent(40) then add = {{image="terrain/mushrooms/deco_floor_dreamy_mushroom_0"..rng.range(1,8)..".png"}} end
newEntity{base = "UNDERGROUND_FLOOR", define_as = "UNDERGROUND_FLOOR"..i, image = "terrain/underground_floor"..(1 + i % 8)..".png", add_mos=add}
end

local creep_editer = { method="borders_def", def="dreamy_creep"}
newEntity{
	define_as = "UNDERGROUND_CREEP",
	type = "floor", subtype = "creep",
	name = "mushroom creep", image = "terrain/mushrooms/creep_dreamy_mushrooms_main_01.png",
	display = '.', color=colors.GREY, back_color={r=44,g=95,b=43},
	grow = "TREE",
	nice_tiler = { method="replace", base={"UNDERGROUND_CREEP", 100, 1, 4}},
	nice_editer = creep_editer,
}
for i = 1, 4 do newEntity{ base = "UNDERGROUND_CREEP", define_as = "UNDERGROUND_CREEP"..i, image = ("terrain/mushrooms/creep_dreamy_mushrooms_main_%02d.png"):format(i) } end


local treesdef = {
	{"small_dreamy_mushroom_01", {"trunk", {"head_%02d", 1, 2}}},
	{"small_dreamy_mushroom_02", {"trunk", {"head_%02d", 1, 6}}},
	{"small_dreamy_mushroom_03", {"trunk", {"head_%02d", 1, 5}}},
	{"small_dreamy_mushroom_04", {"trunk", {"head_%02d", 1, 3}}},
	{"dreamy_mushroom_01", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_02", {tall=-1, "trunk", {"head_%02d", 1, 3}}},
	{"dreamy_mushroom_03", {tall=-1, "trunk", {"head_%02d", 1, 3}}},
	{"dreamy_mushroom_04", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_05", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_06", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_07", {tall=-1, "trunk", {"head_%02d", 1, 4}}},
	{"dreamy_mushroom_08", {tall=-1, "trunk", {"head_%02d", 1, 4}}},
	{"dreamy_mushroom_09", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_10", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
	{"dreamy_mushroom_11", {tall=-1, "trunk", {"head_%02d", 1, 2}}},
}

newEntity{
	define_as = "UNDERGROUND_TREE",
	type = "wall", subtype = "underground",
	name = "underground thick vegetation",
	image = "terrain/tree.png",
	display = '#', color=colors.PURPLE, back_color=colors.UMBER,
	always_remember = true,
	can_pass = {pass_tree=1},
	does_block_move = true,
	block_sight = true,
	nice_tiler = { method="replace", base={"UNDERGROUND_TREE", 100, 1, 30}},
	dig = "UNDERGROUND_FLOOR",
}
for i = 1, 30 do
	newEntity(class:makeNewTrees({base="UNDERGROUND_TREE", define_as = "UNDERGROUND_TREE"..i, image = "terrain/underground_floor.png"}, treesdef, nil, "terrain/mushrooms/"))
end

newEntity{
	define_as = "UNDERGROUND_HARDTREE",
	type = "wall", subtype = "underground",
	name = "underground thick vegetation",
	image = "terrain/tree.png",
	display = '#', color=colors.PURPLE, back_color=colors.UMBER,
	always_remember = true,
	can_pass = {pass_tree=1},
	does_block_move = true,
	block_sight = true,
	block_esp = true,
	block_sense = true,
	nice_tiler = { method="replace", base={"UNDERGROUND_HARDTREE", 100, 1, 30}},
}
for i = 1, 30 do
	newEntity(class:makeNewTrees({base="UNDERGROUND_HARDTREE", define_as = "UNDERGROUND_HARDTREE"..i, image = "terrain/underground_floor.png"}, treesdef, nil, "terrain/mushrooms/"))
end

newEntity{
	define_as = "UNDERGROUND_VAULT",
	type = "wall", subtype = "underground",
	name = "huge loose rock", image = "terrain/underground_floor.png", add_mos = {{image="terrain/huge_rock.png"}},
	display = '+', color=colors.GREY, back_color={r=44,g=95,b=43},
	notice = true,
	always_remember = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	is_door = true,
	door_player_check = _t"This rock is loose, you think you can move it away.",
	door_opened = "UNDERGROUND_FLOOR",
}

newEntity{
	define_as = "UNDERGROUND_LADDER_DOWN",
	type = "floor", subtype = "underground",
	name = "ladder to the next level", image = "terrain/underground_floor.png", add_displays = {class.new{image="terrain/ladder_down.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "UNDERGROUND_LADDER_UP",
	type = "floor", subtype = "underground",
	name = "ladder to the previous level", image = "terrain/underground_floor.png", add_displays = {class.new{image="terrain/ladder_up.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "UNDERGROUND_LADDER_UP_WILDERNESS",
	type = "floor", subtype = "underground",
	name = "ladder to worldmap", image = "terrain/underground_floor.png", add_displays = {class.new{image="terrain/ladder_up_wild.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}
