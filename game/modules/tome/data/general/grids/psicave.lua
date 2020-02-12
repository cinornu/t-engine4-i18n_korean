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

local psitech_wall_editer = { method="sandWalls_def", def="psitechwall"}

newEntity{
	define_as = "PSYCAVEFLOOR",
	type = "floor", subtype = "psitech",
	name = "psitech floor", image = "terrain/psicave/psitech_floor_1_01.png",
	display = '.', color=colors.SANDY_BROWN, back_color=colors.DARK_UMBER,
	grow = "PSYCAVEWALL",
	nice_tiler = { method="replace", base={"PSYCAVEFLOOR", 100, 1, 5}},
}
for i = 1, 5 do newEntity{ base = "PSYCAVEFLOOR", define_as = "PSYCAVEFLOOR"..i, image = "terrain/psicave/psitech_floor_"..i.."_01.png"} end

newEntity{
	define_as = "PSYCAVEWALL",
	type = "wall", subtype = "psitech",
	name = "psitech walls", image = "terrain/psicave/psitechwall_5_1.png",
	display = '#', color={r=203,g=189,b=72}, back_color={r=93,g=79,b=22},
	always_remember = true,
	can_pass = {pass_wall=1},
	does_block_move = true,
	block_sight = true,
	air_level = -10,
	dig = "PSYCAVEFLOOR",
	nice_editer = psitech_wall_editer,
	nice_tiler = { method="replace", base={"PSYCAVEWALL", 100, 1, 9}},
}
for i = 1, 9 do newEntity{ base = "PSYCAVEWALL", define_as = "PSYCAVEWALL"..i, image = "terrain/psicave/psitechwall_5_"..i..".png"} end

-----------------------------------------
-- Doors
-----------------------------------------
newEntity{
	define_as = "PSYCAVE_DOOR",
	type = "wall", subtype = "psitech",
	name = "psitech door", image = "terrain/psicave/psitech_door1.png",
	display = '+', color={r=203,g=189,b=72}, back_color={r=93,g=79,b=22},
	nice_tiler = { method="door3d", north_south="PSYCAVE_DOOR_VERT", west_east="PSYCAVE_DOOR_HORIZ" },
	door_sound = "ambient/door_creaks/icedoor-break",
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "PSYCAVE_DOOR_OPEN",
	dig = "FLOOR",
}
newEntity{
	define_as = "PSYCAVE_DOOR_OPEN",
	type = "wall", subtype = "psitech",
	name = "psitech door (open)", image="terrain/psicave/psitech_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	always_remember = true,
	is_door = true,
	door_closed = "PSYCAVE_DOOR",
}
newEntity{ base = "PSYCAVE_DOOR", define_as = "PSYCAVE_DOOR_HORIZ", z=3, image = "terrain/psicave/psitech_door1.png", add_displays = {class.new{image="terrain/psicave/psitechwall_8_1.png", z=18, display_y=-1}}, door_opened = "PSYCAVE_DOOR_HORIZ_OPEN"}
newEntity{ base = "PSYCAVE_DOOR_OPEN", define_as = "PSYCAVE_DOOR_HORIZ_OPEN", image = "terrain/psicave/psitech_floor_1_01.png", add_mos={{image="terrain/psicave/psitech_door1_open_backg.png"}}, add_displays = {class.new{image="terrain/psicave/psitech_door1_open.png", z=17}, class.new{image="terrain/psicave/psitechwall_8_1.png", z=18, display_y=-1}}, door_closed = "PSYCAVE_DOOR_HORIZ"}
newEntity{ base = "PSYCAVE_DOOR", define_as = "PSYCAVE_DOOR_VERT", image = "terrain/psicave/psitech_floor_1_01.png", add_displays = {class.new{image="terrain/psicave/psitech_door1_vert.png", z=17}, class.new{image="terrain/psicave/psitech_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "PSYCAVE_DOOR_OPEN_VERT", dig = "PSYCAVE_DOOR_OPEN_VERT"}
newEntity{ base = "PSYCAVE_DOOR_OPEN", define_as = "PSYCAVE_DOOR_OPEN_VERT", z=3, image = "terrain/psicave/psitech_floor_1_01.png", add_mos={{image="terrain/psicave/psitech_door1_open_vert_backg.png"}}, add_displays = {class.new{image="terrain/psicave/psitech_door1_open_vert.png", z=17, add_mos={{image="terrain/psicave/psitech_door1_open_vert_north_backg.png", display_y=-1}}}, class.new{image="terrain/psicave/psitech_door1_open_vert_north.png", z=18, display_y=-1}}, door_closed = "PSYCAVE_DOOR_VERT"}

-----------------------------------------
-- Cavy exits
-----------------------------------------

newEntity{
	define_as = "PSYCAVE_LADDER_DOWN",
	type = "floor", subtype = "psitech",
	name = "ladder to the next level", image = "terrain/psicave/psitech_floor_1_01.png", add_displays = {class.new{image="terrain/psicave/psitech_stairs_down_1_01.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "PSYCAVE_LADDER_UP",
	type = "floor", subtype = "psitech",
	name = "ladder to the previous level", image = "terrain/psicave/psitech_floor_1_01.png", add_displays = {class.new{image="terrain/psicave/psitech_stairs_up_1_01.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "PSYCAVE_LADDER_UP_WILDERNESS",
	type = "floor", subtype = "psitech",
	name = "ladder to worldmap", image = "terrain/psicave/psitech_floor_1_01.png", add_displays = {class.new{image="terrain/psicave/psitech_stairs_exit_1_01.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}
