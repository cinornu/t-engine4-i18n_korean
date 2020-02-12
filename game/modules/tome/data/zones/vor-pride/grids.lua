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
load("/data/general/grids/gothic.lua", function(e)
	if e.define_as and e.define_as ~= "GOTHIC_FLOOR" and not e.define_as:prefix("GOTHIC_FLAT") and e.image == "terrain/gothic_walls/marble_floor.png" then
		e.image = "terrain/grass_burnt1.png"
	end
end)
load("/data/general/grids/forest.lua")
load("/data/general/grids/water.lua")
load("/data/general/grids/burntland.lua")

newEntity{
	define_as = "GENERIC_BOOK1", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/book_generic1.png"}},
	type = "floor", subtype = "floor",
	name = "book",
	display = '_', color_r=255, color_g=0, color_b=0,
	notice = true,
	always_remember = true,
}

newEntity{
	define_as = "GENERIC_BOOK2", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/book_generic2.png"}},
	type = "floor", subtype = "floor",
	name = "book",
	display = '_', color_r=255, color_g=0, color_b=0,
	notice = true,
	always_remember = true,
}

newEntity{
	define_as = "GENERIC_BOOK3", image = "terrain/gothic_walls/marble_floor.png", add_mos = {{image="terrain/book_generic3.png"}},
	type = "floor", subtype = "floor",
	name = "book",
	display = '_', color_r=255, color_g=0, color_b=0,
	notice = true,
	always_remember = true,
}

newEntity{
	define_as = "CANDLE",
	type = "floor", subtype = "floor",
	name = "reading candle", image = "terrain/gothic_walls/marble_floor.png",
	force_clone = true,
	display = ';', color=colors.GOLD,
	always_remember = true,
	nice_tiler = { method="replace", base={"CANDLE", 100, 1, 3}},
}
for i = 1, 3 do newEntity{base = "CANDLE", define_as = "CANDLE"..i, embed_particles = {{name="candle", rad=1, args={candle_id="light1"}}} } end
