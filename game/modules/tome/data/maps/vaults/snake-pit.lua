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

startx = 3
starty = 5

setStatusAll{no_teleport=true, room_map = {can_open=false}}
specialList("actor", {
   "/data/general/npcs/snake.lua",
   "/data/general/npcs/molds.lua",
   "/data/general/npcs/feline.lua",
   "/data/general/npcs/ant.lua",
   "/data/zones/ritch-tunnels/npcs.lua",
   "/data/general/npcs/sandworm.lua",
   "/data/general/npcs/spider.lua",
   "/data/general/npcs/vermin.lua",
   "/data/general/npcs/rodent.lua",
})
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile(',', data.floor or data['.'] or "FLOOR")
defineTile('#', "HARDWALL")
defineTile('w', "WALL")
defineTile('d', "FLOOR", {random_filter={type="tool", subtype="digger", name="iron pickaxe", ego_chance=-1000, ego_chance=-1000}})

local mobs = {
   "rattlesnake",
   "green worm mass",
   "giant brown ant",
   "snow cat",
   "green mold",
   "giant grey rat",
   "giant spider",
   "ritch flamespitter",
   "sandworm"
}
local mob = rng.tableRemove(mobs)

defineTile('s', "FLOOR", {random_filter={type="scroll", ego_chance=25}}, {random_filter={name=mob}})

return {
[[,,,,,,,,]],
[[,######,]],
[[,#sss##,]],
[[,#ssswd,]],
[[,#sss##,]],
[[,######,]],
[[,,,,,,,,]],
}