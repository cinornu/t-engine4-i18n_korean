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

local sanddunes_editer = {method="borders_def", def="mountain"}

newEntity{
	define_as = "SAND_FLOOR",
	type = "floor", subtype = "sand",
	name = "sand", image = "terrain/sandfloor.png",
	display = '.', color=colors.SANDY_BROWN, back_color=colors.LIGHT_UMBER,
	grow = "SAND_DUNE",
}

newEntity{
	define_as = "SAND_DUNE",
	type = "dune", subtype = "sand",
	name = "sand dune", image = "terrain/rocky_mountain.png",
	display = '^', color=colors.SANDY_BROWN, back_color=colors.LIGHT_UMBER,
	always_remember = true,
	can_pass = {pass_wall=1},
	does_block_move = true,
	block_sight = true,
	dig = "SAND_FLOOR",
	nice_editer = sanddunes_editer,
	nice_tiler = { method="replace", base={"SAND_DUNE", 70, 1, 6} },
}
for i = 1, 6 do newEntity{ base="SAND_DUNE", define_as = "SAND_DUNE"..i, image = "terrain/mountain5_"..i..".png"} end

newEntity{
	define_as = "HARDSAND_DUNE",
	type = "dune", subtype = "sand",
	name = "solidified sand dune", image = "terrain/rocky_mountain.png",
	display = '#', color=colors.SANDY_BROWN, back_color=colors.LIGHT_UMBER,
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	nice_editer = sanddunes_editer,
	nice_tiler = { method="replace", base={"HARDSAND_DUNE", 70, 1, 6} },
}
for i = 1, 6 do newEntity{ base="HARDSAND_DUNE", define_as = "HARDSAND_DUNE"..i, image = "terrain/mountain5_"..i..".png"} end

newEntity{
	define_as = "PALMTREE",
	type = "wall", subtype = "sand",
	name = "tree", image = "terrain/palmtree.png",
	display = '#', color=colors.LIGHT_GREEN, back_color={r=93,g=79,b=22},
	always_remember = true,
	can_pass = {pass_tree=1},
	does_block_move = true,
	block_sight = true,
	dig = "SAND",
	nice_tiler = { method="replace", base={"PALMTREE", 100, 1, 20}},
	nice_editer = sand_editer,
}
for i = 1, 20 do newEntity{ base="PALMTREE", define_as = "PALMTREE"..i, image = "terrain/sandfloor.png", add_displays = class:makeTrees("terrain/palmtree_alpha", 8, 5, nil, 25) } end

-----------------------------------------
-- Sandy exits
-----------------------------------------
newEntity{
	define_as = "SAND_UP_WILDERNESS",
	type = "floor", subtype = "sand",
	name = "exit to the worldmap", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/worldmap.png"}},
	display = '<', color_r=255, color_g=0, color_b=255,
	always_remember = true,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}

newEntity{
	define_as = "SAND_UP8",
	type = "floor", subtype = "sand",
	name = "way to the previous level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_8.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "SAND_UP2",
	type = "floor", subtype = "sand",
	name = "way to the previous level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_2.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "SAND_UP4",
	type = "floor", subtype = "sand",
	name = "way to the previous level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_4.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "SAND_UP6",
	type = "floor", subtype = "sand",
	name = "way to the previous level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_6.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "SAND_DOWN8",
	type = "floor", subtype = "sand",
	name = "way to the next level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_8.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "SAND_DOWN2",
	type = "floor", subtype = "sand",
	name = "way to the next level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_2.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "SAND_DOWN4",
	type = "floor", subtype = "sand",
	name = "way to the next level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_4.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "SAND_DOWN6",
	type = "floor", subtype = "sand",
	name = "way to the next level", image = "terrain/sandfloor.png", add_displays = {class.new{image="terrain/way_next_6.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
