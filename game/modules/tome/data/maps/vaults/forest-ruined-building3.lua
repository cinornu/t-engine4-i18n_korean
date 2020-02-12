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

setStatusAll{no_teleport=true, room_map = {can_open=true}}
specialList("actor", {
   "/data/general/npcs/skeleton.lua",
   "/data/general/npcs/snake.lua",
   "/data/general/npcs/molds.lua",
   "/data/general/npcs/feline.lua",
   "/data/general/npcs/ant.lua",
   "/data/general/npcs/sandworm.lua",
   "/data/general/npcs/spider.lua",
   "/data/general/npcs/vermin.lua",
   "/data/general/npcs/rodent.lua",
   "/data/general/npcs/ooze.lua",
   "/data/general/npcs/jelly.lua",
})
border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', "GRASS")
defineTile(';', "FLOWER")
defineTile('~', "DEEP_WATER")
defineTile('#', "HARDWALL")
defineTile('X', "HARDTREE")
defineTile('x', "DOOR_VAULT")

local mobs = {
   "rattlesnake",
   "green worm mass",
   "giant brown ant",
   "snow cat",
   "green mold",
   "giant grey rat",
   "giant spider",
   "sandworm",
   "grey mold",
   "giant brown rat",
   "skeleton mage",
   "skeleton archer",
   "skeleton warrior",
   "giant green ant",
   "giant red ant",
   "giant yellow ant",
   "giant blue ant",
   "brown mold",
   "white worm mass",
   "giant crystal rat",
   "spitting spider",
   "weaver young",
   "green ooze",
   "red ooze",
   "yellow ooze",
   "blue ooze",
   "green jelly",
   "red jelly",
   "blue jelly",
   "yellow jelly",
}

defineTile('s', "FLOOR", "MONEY_SMALL", {random_filter={name="degenerated skeleton warrior"}}) -- retain closet skeleton for posterity; give it a little money to guard so he's not so sad

--ALL OF THE VARIABILITY
defineTile('1', "FLOOR", rng.percent(66)and{random_filter={tome_mod="vault", add_levels=rng.range(1,3)}} or nil, rng.percent(50) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(5,10)}} or nil)
defineTile('2', "FLOOR", rng.percent(50)and{random_filter={tome_mod="vault", add_levels=rng.range(2,5)}} or nil, rng.percent(66) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(4,8)}} or nil)
defineTile('3', "FLOOR", rng.percent(66)and{random_filter={add_levels=rng.range(2,4), ego_chance=rng.range(75,100)}} or nil, rng.percent(50) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(5,10)}} or nil)
defineTile('4', "FLOOR", rng.percent(50)and{random_filter={add_levels=rng.range(3,6), ego_chance=rng.range(66,100)}} or nil, rng.percent(66) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(4,8)}} or nil)
defineTile('5', "FLOOR", rng.percent(66)and{random_filter={tome_mod="vault", add_levels=rng.range(1,3)}} or nil, rng.percent(50) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(5,10)}} or nil)
defineTile('6', "FLOOR", rng.percent(50)and{random_filter={tome_mod="vault", add_levels=rng.range(4,6)}} or nil, rng.percent(66) and {random_filter={name=rng.tableRemove(mobs), add_levels=rng.range(4,8)}} or nil)

return {
[[,,,,,,,,,,,,,,,,]],
[[,#X#########X,,,]],
[[,#2x.;,.x.6,X.X,]],
[[,###.,,.####XXX,]],
[[,#3x.;,.#.5.1.#,]],
[[,###.;;.###x###,]],
[[,#sx..,,#;;;;;;;]],
[[,###.,,X#;;~~~;;]],
[[,#4x..,.,;;~~~;;]],
[[,#####X,,;;~~~;;]],
[[,,,,,,,,,;;;;;;;]],
}
