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

-----------------------------------------
-- Dungeony exits
-----------------------------------------
newEntity{
	define_as = "MALROK_UP_WILDERNESS",
	type = "floor", subtype = "rocks",
	name = "exit to the worldmap", image = "terrain/red_floating_rocks05_01.png", add_mos = {{image="terrain/stair_up_wild.png"}},
	display = '<', color_r=255, color_g=0, color_b=255,
	always_remember = true,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}

newEntity{
	define_as = "MALROK_UP", image = "terrain/red_floating_rocks05_01.png", add_mos = {{image="terrain/malrok_wall/malrok_malrok_wall_stairs_up2.png"}},
	type = "floor", subtype = "rocks",
	name = "previous level",
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "MALROK_DOWN", image = "terrain/red_floating_rocks05_01.png", add_mos = {{image="terrain/malrok_wall/malrok_malrok_wall_stairs_down2.png"}},
	type = "floor", subtype = "rocks",
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}

-----------------------------------------
-- Basic floors
-----------------------------------------
newEntity{
	define_as = "MALROK_FLOOR",
	type = "floor", subtype = "rocks",
	name = "floor", image = "terrain/red_floating_rocks05_01.png",
	display = '.', color_r=255, color_g=255, color_b=255, back_color=colors.DARK_GREY,
	grow = "MALROK_WALL",
}

-----------------------------------------
-- Walls
-----------------------------------------
newEntity{
	define_as = "MALROK_WALL",
	type = "wall", subtype = "rocks",
	name = "wall", image = "terrain/malrok_wall/malrok_wall_block1.png",
	display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
	z = 3,
	nice_tiler = { method="wall3d", inner={"MALROK_WALL", 100, 1, 41}, north={"MALROK_WALL_NORTH", 100, 1, 41}, south={"MALROK_WALL_SOUTH", 100, 1, 36}, north_south="MALROK_WALL_NORTH_SOUTH", pillar_4="MALROK_WALL_NORTH_SOUTH", pillar_6="MALROK_WALL_NORTH_SOUTH", pillar_2="MALROK_WALL_SOUTH1", pillar_8="MALROK_WALL_NORTH1", small_pillar="MALROK_WALL_NORTH_SOUTH" },
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	air_level = -20,
	can_pass = {pass_wall=1},
}
for i = 1, 41 do
	local ri = math.max(1, i - 20)
	newEntity{ base = "MALROK_WALL", define_as = "MALROK_WALL"..i, image = "terrain/malrok_wall/malrok_wall_block"..ri..".png", z = 3}
	newEntity{ base = "MALROK_WALL", define_as = "MALROK_WALL_NORTH"..i, image = "terrain/malrok_wall/malrok_wall_block"..ri..".png", z = 3, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}}
end
newEntity{ base = "MALROK_WALL", define_as = "MALROK_WALL_NORTH_SOUTH", image = "terrain/malrok_wall/malrok_wall_wall1.png", z = 3, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}}
newEntity{ base = "MALROK_WALL", define_as = "MALROK_WALL_SOUTH", image = "terrain/malrok_wall/malrok_wall_wall1.png", z = 3}
for i = 1, 36 do newEntity{ base = "MALROK_WALL", define_as = "MALROK_WALL_SOUTH"..i, image = "terrain/malrok_wall/malrok_wall_wall"..i..".png", z = 3} end

-----------------------------------------
-- Walls
-----------------------------------------
newEntity{
	define_as = "MALROK_HARDWALL",
	type = "wall", subtype = "rocks",
	name = "wall", image = "terrain/malrok_wall/malrok_wall_block1.png",
	display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
	z = 3,
	nice_tiler = { method="wall3d", inner={"MALROK_HARDWALL", 100, 1, 3}, north={"MALROK_HARDWALL_NORTH", 100, 1, 3}, south={"MALROK_HARDWALL_SOUTH", 40, 1, 11}, north_south="MALROK_HARDWALL_NORTH_SOUTH", pillar_4="MALROK_HARDWALL_NORTH_SOUTH", pillar_6="MALROK_HARDWALL_NORTH_SOUTH", pillar_2="MALROK_HARDWALL_SOUTH1", pillar_8="MALROK_HARDWALL_NORTH", small_pillar="MALROK_HARDWALL_NORTH_SOUTH" },
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	air_level = -20,
}
for i = 1, 3 do
	newEntity{ base = "MALROK_HARDWALL", define_as = "MALROK_HARDWALL"..i, image = "terrain/malrok_wall/malrok_wall_block"..i..".png", z = 3}
	newEntity{ base = "MALROK_HARDWALL", define_as = "MALROK_HARDWALL_NORTH"..i, image = "terrain/malrok_wall/malrok_wall_block"..i..".png", z = 3, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}}
end
newEntity{ base = "MALROK_HARDWALL", define_as = "MALROK_HARDWALL_NORTH_SOUTH", image = "terrain/malrok_wall/malrok_wall_wall1.png", z = 3, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}}
newEntity{ base = "MALROK_HARDWALL", define_as = "MALROK_HARDWALL_SOUTH", image = "terrain/malrok_wall/malrok_wall_wall1.png", z = 3}
for i = 1, 11 do newEntity{ base = "MALROK_HARDWALL", define_as = "MALROK_HARDWALL_SOUTH"..i, image = "terrain/malrok_wall/malrok_wall_wall"..i..".png", z = 3} end

-----------------------------------------
-- Doors
-----------------------------------------
newEntity{
	define_as = "MALROK_DOOR",
	type = "wall", subtype = "rocks",
	name = "door", image = "terrain/malrok_wall/malrok_granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	nice_tiler = { method="door3d", north_south="MALROK_DOOR_VERT", west_east="MALROK_DOOR_HORIZ" },
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "MALROK_DOOR_OPEN",
	dig = "FLOOR",
	can_pass = {pass_wall=1},
}
newEntity{
	define_as = "MALROK_DOOR_OPEN",
	type = "wall", subtype = "rocks",
	name = "open door", image="terrain/malrok_wall/malrok_granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	always_remember = true,
	door_closed = "MALROK_DOOR",
}
newEntity{ base = "MALROK_DOOR", define_as = "MALROK_DOOR_HORIZ", image = "terrain/red_floating_rocks05_01.png", add_mos={{image = "terrain/malrok_wall/malrok_wall_closed_doors1.png"}}, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}, door_opened = "MALROK_DOOR_HORIZ_OPEN"}
newEntity{ base = "MALROK_DOOR_OPEN", define_as = "MALROK_DOOR_HORIZ_OPEN", image = "terrain/red_floating_rocks05_01.png", add_mos={{image = "terrain/malrok_wall/malrok_wall_open_doors1.png"}}, add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_top_block1.png", z=18, display_y=-1}}, door_closed = "MALROK_DOOR_HORIZ"}
newEntity{ base = "MALROK_DOOR", define_as = "MALROK_DOOR_VERT", image = "terrain/red_floating_rocks05_01.png", add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_door1_vert.png", z=17}, class.new{image="terrain/malrok_wall/malrok_wall_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "MALROK_DOOR_OPEN_VERT"}
newEntity{ base = "MALROK_DOOR_OPEN", define_as = "MALROK_DOOR_OPEN_VERT", image = "terrain/red_floating_rocks05_01.png", add_displays = {class.new{image="terrain/malrok_wall/malrok_wall_door1_open_vert.png", z=17}, class.new{image="terrain/malrok_wall/malrok_wall_door1_open_vert_north.png", z=18, display_y=-1}}, door_closed = "MALROK_DOOR_VERT"}
