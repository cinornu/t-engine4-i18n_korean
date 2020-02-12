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

load("/data/general/grids/basic.lua", function(e) if e.image == "terrain/marble_floor.png" then e.image = "terrain/underground_floor.png" end end)
load("/data/general/grids/slimy_walls.lua", function(e) if e.image == "terrain/marble_floor.png" then e.image = "terrain/underground_floor.png" end end)
load("/data/general/grids/underground_slimy.lua")
load("/data/general/grids/lava.lua")
load("/data/general/grids/water.lua")
load("/data/general/grids/forest.lua")

newEntity{
	define_as = "SLIME_TUNNELS",
	name = "entrance to a slimy pit",
	display = '>', color=colors.LIGHT_GREEN, image = "terrain/underground_floor.png", add_displays = {class.new{z=4, image="terrain/slime/slime_stair_down_01.png"}},
	always_remember = true,
	notice = true,
	change_level = 1,
	change_zone = "slime-tunnels",
}

newEntity{
	define_as = "TRAINING_DUMMY",
	name = "training dummy",
	type = "training", subtype = "dummy",
	display = 't', color=colors.GREY, image = "terrain/underground_floor.png", add_displays = {class.new{z=9, image="npc/lure.png"}},
	always_remember = true,
	notice = true,
	does_block_move = true,
	pass_projectile = true,
}
