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

newEntity{
	define_as = "SUMMON_CIRCLE",
	name = "unholy circle", image = "terrain/marble_floor.png",
	-- add_mos = {{image=resolvers.generic(function() return "object/candle_dark"..rng.range(1,3)..".png" end)}},
	force_clone = true,
	display = ';', color=colors.GOLD, back_color=colors.GREY,
	always_remember = true,
	does_block_move = true,
	nice_tiler = { method="replace", base={"SUMMON_CIRCLE", 100, 1, 3}},
}
for i = 1, 3 do newEntity{base = "SUMMON_CIRCLE", define_as = "SUMMON_CIRCLE"..i, embed_particles = {{name="candle", rad=1, args={candle_id="dark1"}}} } end

newEntity{
	define_as = "SUMMON_CIRCLE_BROKEN",
	name = "broken unholy circle", image = "terrain/marble_floor.png", add_mos = {{image="object/candle_dark4.png"}},
	display = '.', color=colors.GOLD, back_color=colors.GREY,
	always_remember = true,
}
