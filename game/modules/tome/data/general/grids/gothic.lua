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
	define_as = "GOTHIC_UP_WILDERNESS",
	type = "floor", subtype = "floor",
	name = "exit to the worldmap", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/gothic_walls/stair_up_wild.png"}},
	display = '<', color_r=255, color_g=0, color_b=255,
	always_remember = true,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}

newEntity{
	define_as = "GOTHIC_UP", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/gothic_walls/stair_up.png"}},
	type = "floor", subtype = "floor",
	name = "previous level",
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "GOTHIC_DOWN", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/gothic_walls/stair_down.png"}},
	type = "floor", subtype = "floor",
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}

-----------------------------------------
-- Outworld exits
-----------------------------------------
newEntity{
	define_as = "GOTHIC_FLAT_UP_WILDERNESS",
	type = "floor", subtype = "floor",
	name = "exit to the worldmap", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/worldmap.png"}},
	display = '<', color_r=255, color_g=0, color_b=255,
	always_remember = true,
	notice = true,
	change_level = 1,
	change_zone = "wilderness",
}

newEntity{
	define_as = "GOTHIC_FLAT_UP8",
	type = "floor", subtype = "floor",
	name = "way to the previous level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_8.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "GOTHIC_FLAT_UP2",
	type = "floor", subtype = "floor",
	name = "way to the previous level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_2.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "GOTHIC_FLAT_UP4",
	type = "floor", subtype = "floor",
	name = "way to the previous level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_4.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}
newEntity{
	define_as = "GOTHIC_FLAT_UP6",
	type = "floor", subtype = "floor",
	name = "way to the previous level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_6.png"}},
	display = '<', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "GOTHIC_FLAT_DOWN8",
	type = "floor", subtype = "floor",
	name = "way to the next level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_8.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "GOTHIC_FLAT_DOWN2",
	type = "floor", subtype = "floor",
	name = "way to the next level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_2.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "GOTHIC_FLAT_DOWN4",
	type = "floor", subtype = "floor",
	name = "way to the next level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_4.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "GOTHIC_FLAT_DOWN6",
	type = "floor", subtype = "floor",
	name = "way to the next level", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/way_next_6.png"}},
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}

-----------------------------------------
-- Basic floors
-----------------------------------------
newEntity{
	define_as = "GOTHIC_FLOOR",
	type = "floor", subtype = "floor",
	name = "floor", image = "terrain/gothic_walls/marble_floor.png",
	display = '.', color_r=255, color_g=255, color_b=255, back_color=colors.DARK_GREY,
	grow = "GOTHIC_WALL",
}

-----------------------------------------
-- Walls
-----------------------------------------
newEntity{
	define_as = "GOTHIC_WALL",
	type = "wall", subtype = "floor",
	name = "wall", image = "terrain/gothic_walls/granite_wall1.png",
	display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
	z = 3,
	nice_tiler = { method="wall3d", inner={"GOTHIC_WALL", 100, 1, 5}, north={"GOTHIC_WALL_NORTH", 100, 1, 5}, south={"GOTHIC_WALL_SOUTH", 10, 1, 17}, north_south="GOTHIC_WALL_NORTH_SOUTH", small_pillar="GOTHIC_WALL_SMALL_PILLAR", pillar_2="GOTHIC_WALL_PILLAR_2", pillar_8={"GOTHIC_WALL_PILLAR_8", 100, 1, 5}, pillar_4="GOTHIC_WALL_PILLAR_4", pillar_6="GOTHIC_WALL_PILLAR_6" },
	always_remember = true,
	does_block_move = true,
	can_pass = {pass_wall=1},
	block_sight = true,
	air_level = -20,
	dig = "GOTHIC_FLOOR",
}
for i = 1, 5 do
	newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3}
	newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_NORTH"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}}
	newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_PILLAR_8"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_8.png", z=18, display_y=-1}}}
end
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_NORTH_SOUTH", image = "terrain/gothic_walls/granite_wall2.png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_SOUTH", image = "terrain/gothic_walls/granite_wall2.png", z = 3}
for i = 1, 17 do newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_SOUTH"..i, image = "terrain/gothic_walls/granite_wall2_"..i..".png", z = 3} end
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_SMALL_PILLAR", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_small.png",z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_small_top.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_PILLAR_6", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_3.png",z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_9.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_PILLAR_4", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_1.png",z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_7.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_WALL", define_as = "GOTHIC_WALL_PILLAR_2", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_2.png",z=3}}}

-----------------------------------------
-- Hard Walls
-----------------------------------------
newEntity{
	define_as = "GOTHIC_HARDWALL",
	type = "wall", subtype = "floor",
	name = "wall", image = "terrain/gothic_walls/granite_wall1.png",
	display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
	z = 3,
	nice_tiler = { method="wall3d", inner={"GOTHIC_HARDWALL", 100, 1, 5}, north={"GOTHIC_HARDWALL_NORTH", 100, 1, 5}, south={"GOTHIC_HARDWALL_SOUTH", 10, 1, 17}, north_south="GOTHIC_HARDWALL_NORTH_SOUTH", small_pillar="GOTHIC_HARDWALL_SMALL_PILLAR", pillar_2="GOTHIC_HARDWALL_PILLAR_2", pillar_8={"GOTHIC_HARDWALL_PILLAR_8", 100, 1, 5}, pillar_4="GOTHIC_HARDWALL_PILLAR_4", pillar_6="GOTHIC_HARDWALL_PILLAR_6" },
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	air_level = -20,
}
for i = 1, 5 do
	newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3}
	newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_NORTH"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}}
	newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_PILLAR_8"..i, image = "terrain/gothic_walls/granite_wall1_"..i..".png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_8.png", z=18, display_y=-1}}}
end
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_NORTH_SOUTH", image = "terrain/gothic_walls/granite_wall2.png", z = 3, add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_SOUTH", image = "terrain/gothic_walls/granite_wall2.png", z = 3}
for i = 1, 17 do newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_SOUTH"..i, image = "terrain/gothic_walls/granite_wall2_"..i..".png", z = 3} end
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_SMALL_PILLAR", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_small.png", z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_small_top.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_PILLAR_6", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_3.png", z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_9.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_PILLAR_4", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_1.png", z=3}, class.new{image="terrain/gothic_walls/granite_wall_pillar_7.png", z=18, display_y=-1}}}
newEntity{ base = "GOTHIC_HARDWALL", define_as = "GOTHIC_HARDWALL_PILLAR_2", image = "terrain/gothic_walls/marble_floor.png", z=1, add_displays = {class.new{image="terrain/gothic_walls/granite_wall_pillar_2.png", z=3}}}


-----------------------------------------
-- Doors
-----------------------------------------
newEntity{
	define_as = "GOTHIC_DOOR",
	type = "wall", subtype = "floor",
	name = "door", image = "terrain/gothic_walls/granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	nice_tiler = { method="door3d", north_south="GOTHIC_DOOR_VERT", west_east="GOTHIC_DOOR_HORIZ" },
	notice = true,
	always_remember = true,
	block_sight = true,
	is_door = true,
	door_opened = "GOTHIC_DOOR_OPEN",
	dig = "GOTHIC_FLOOR",
}
newEntity{
	define_as = "GOTHIC_DOOR_OPEN",
	type = "wall", subtype = "floor",
	name = "open door", image="terrain/gothic_walls/granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	always_remember = true,
	is_door = true,
	door_closed = "GOTHIC_DOOR",
}
newEntity{ base = "GOTHIC_DOOR", define_as = "GOTHIC_DOOR_HORIZ", z=3, image = "terrain/gothic_walls/granite_door1.png", add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}, door_opened = "GOTHIC_DOOR_HORIZ_OPEN"}
newEntity{ base = "GOTHIC_DOOR_OPEN", define_as = "GOTHIC_DOOR_HORIZ_OPEN", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_open.png", z=17}, class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}, door_closed = "GOTHIC_DOOR_HORIZ"}
newEntity{ base = "GOTHIC_DOOR", define_as = "GOTHIC_DOOR_VERT", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_vert.png", z=17}, class.new{image="terrain/gothic_walls/granite_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "GOTHIC_DOOR_OPEN_VERT", dig = "GOTHIC_DOOR_OPEN_VERT"}
newEntity{ base = "GOTHIC_DOOR_OPEN", define_as = "GOTHIC_DOOR_OPEN_VERT", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_open_vert.png", z=17}, class.new{image="terrain/gothic_walls/granite_door1_open_vert_north.png", z=18, display_y=-1}}, door_closed = "GOTHIC_DOOR_VERT"}

newEntity{
	define_as = "GOTHIC_DOOR_VAULT",
	type = "wall", subtype = "floor",
	name = "sealed door", image = "terrain/gothic_walls/granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	nice_tiler = { method="door3d", north_south="GOTHIC_DOOR_VAULT_VERT", west_east="GOTHIC_DOOR_VAULT_HORIZ" },
	notice = true,
	always_remember = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	is_door = true,
	door_player_check = _t"This door seems to have been sealed off. You think you can open it.",
	door_opened = "GOTHIC_DOOR_OPEN",
}
newEntity{ base = "GOTHIC_DOOR_VAULT", define_as = "GOTHIC_DOOR_VAULT_HORIZ", z=3, image = "terrain/gothic_walls/granite_door1.png", add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}, door_opened = "GOTHIC_DOOR_HORIZ_OPEN"}
newEntity{ base = "GOTHIC_DOOR_VAULT", define_as = "GOTHIC_DOOR_VAULT_VERT", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_vert.png", z=17}, class.new{image="terrain/gothic_walls/granite_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "GOTHIC_DOOR_OPEN_VERT"}

-----------------------------------------
-- Levers & such tricky tings
-----------------------------------------
newEntity{
	define_as = "GOTHIC_GENERIC_LEVER_DOOR",
	type = "wall", subtype = "floor",
	name = "sealed door", image = "terrain/gothic_walls/granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	nice_tiler = { method="door3d", north_south="GOTHIC_GENERIC_LEVER_DOOR_VERT", west_east="GOTHIC_GENERIC_LEVER_DOOR_HORIZ" },
	notice = true,
	always_remember = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	force_clone = true,
	door_player_stop = _t"This door seems to have been sealed off. You need to find a way to open it.",
	is_door = true,
	special = true,
	door_opened = "GOTHIC_GENERIC_LEVER_DOOR_OPEN",
	on_lever_change = function(self, x, y, who, val, oldval)
		local toggle = game.level.map.attrs(x, y, "lever_toggle")
		local trigger = game.level.map.attrs(x, y, "lever_action") or 1
		if toggle or (val > oldval and val >= trigger) then
			game.level.map(x, y, engine.Map.TERRAIN, game.zone.grid_list[self.door_opened])
			game.log("#VIOLET#You hear a door opening.")
			return true
		end
	end,
}
newEntity{ base = "GOTHIC_GENERIC_LEVER_DOOR", define_as = "GOTHIC_GENERIC_LEVER_DOOR_HORIZ", image = "terrain/gothic_walls/granite_door1.png", add_displays = {class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1, add_mos={{image="terrain/padlock2.png", display_y=0.1}}}}, door_opened = "GOTHIC_GENERIC_LEVER_DOOR_HORIZ_OPEN"}
newEntity{ base = "GOTHIC_GENERIC_LEVER_DOOR", define_as = "GOTHIC_GENERIC_LEVER_DOOR_VERT", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_vert.png", z=17, add_mos={{image="terrain/padlock2.png", display_x=0.2, display_y=-0.4}}}, class.new{image="terrain/gothic_walls/granite_door1_vert_north.png", z=18, display_y=-1}}, door_opened = "GOTHIC_GENERIC_LEVER_DOOR_OPEN_VERT"}

newEntity{
	define_as = "GOTHIC_GENERIC_LEVER_DOOR_OPEN",
	type = "wall", subtype = "floor",
	name = "open door", image="terrain/gothic_walls/granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	nice_tiler = { method="door3d", north_south="GOTHIC_GENERIC_LEVER_DOOR_OPEN_VERT", west_east="GOTHIC_GENERIC_LEVER_DOOR_HORIZ_OPEN" },
	always_remember = true,
	is_door = true,
	special = true,
	door_closed = "GOTHIC_GENERIC_LEVER_DOOR",
	door_player_stop = _t"This door seems to have been sealed off. You need to find a way to close it.",
	on_lever_change = function(self, x, y, who, val, oldval)
		local toggle = game.level.map.attrs(x, y, "lever_toggle")
		local trigger = game.level.map.attrs(x, y, "lever_action") or 1
		if toggle or (val < oldval and val < trigger) then
			game.level.map(x, y, engine.Map.TERRAIN, game.zone.grid_list[self.door_closed])
			game.log("#VIOLET#You hear a door closing.")
			return true
		end
	end,
}
newEntity{ base = "GOTHIC_GENERIC_LEVER_DOOR_OPEN", define_as = "GOTHIC_GENERIC_LEVER_DOOR_HORIZ_OPEN", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_open.png", z=17}, class.new{image="terrain/gothic_walls/granite_wall3.png", z=18, display_y=-1}}, door_closed = "GOTHIC_GENERIC_LEVER_DOOR_HORIZ"}
newEntity{ base = "GOTHIC_GENERIC_LEVER_DOOR_OPEN", define_as = "GOTHIC_GENERIC_LEVER_DOOR_OPEN_VERT", image = "terrain/gothic_walls/marble_floor.png", add_displays = {class.new{image="terrain/gothic_walls/granite_door1_open_vert.png", z=17}, class.new{image="terrain/gothic_walls/granite_door1_open_vert_north.png", z=18, display_y=-1}}, door_closed = "GOTHIC_GENERIC_LEVER_DOOR_VERT"}

newEntity{
	define_as = "GOTHIC_GENERIC_LEVER",
	type = "lever", subtype = "floor",
	name = "huge lever", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/lever1_state1.png"}},
	display = '&', color=colors.UMBER, back_color=colors.DARK_UMBER,
	notice = true,
	always_remember = true,
	lever = false,
	force_clone = true,
	special = true,
	block_move = function(self, x, y, e, act)
		if act and e.player then
			if self.lever then
				self.color_r = colors.UMBER.r self.color_g = colors.UMBER.g self.color_b = colors.UMBER.b
				self.add_mos[1].image = "terrain/lever1_state1.png"
			else
				self.color_r = 255 self.color_g = 255 self.color_b = 255
				self.add_mos[1].image = "terrain/lever1_state2.png"
			end
			self:removeAllMOs()
			game.level.map:updateMap(x, y)
			self:leverActivated(x, y, e)
		end
		return true
	end,
}

-- This is for the Map.TRIGGER layer
newEntity{
	define_as = "GOTHIC_GENERIC_TRIGGER_BOOL",
	type = "trigger", subtype = "bool",
	lever = false,
	special = true,
	on_move = function(self, x, y, e)
		if e.player then self:leverActivated(x, y, e) end
	end,
}
