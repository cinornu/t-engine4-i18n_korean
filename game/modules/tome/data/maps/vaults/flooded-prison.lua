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

startx = 1
starty = 2

setStatusAll{no_teleport=true, vault_only_door_open=true}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

specialList("actor", {
   "/data/general/npcs/aquatic_demon.lua",
   "/data/general/npcs/horror_aquatic.lua",
   "/data/general/npcs/naga.lua",
})

specialList("terrain", {
        "/data/general/grids/water.lua",
        "/data/general/grids/basic.lua",
})

defineTile('#', "HARDWALL")
defineTile('~', "WATER_FLOOR")
defineTile('X', "DOOR_VAULT")
defineTile('%', "DOOR")
defineTile('8', "WATER_FLOOR", {random_filter={add_levels=18, tome_mod="gvault"}}, {random_filter={add_levels=20}})

return {
   [[~~~~~~~~~~~~~]],
   [[~###########~]],
   [[~X8%8%8%8%8#~]],
   [[~#########%#~]],
   [[~#8%8%8%8%8#~]],
   [[~#%#########~]],
   [[~#8%8%8%8%8X~]],
   [[~###########~]],
   [[~~~~~~~~~~~~~]],
}
