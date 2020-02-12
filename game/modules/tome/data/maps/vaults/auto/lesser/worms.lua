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

startx = 4
starty = 7

specialList("actor", {
   "/data/general/npcs/horror.lua",
   "/data/general/npcs/vermin.lua",
})

setStatusAll{no_teleport=true}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('o', "WALL")
defineTile('.', "FLOOR")
defineTile('#', "HARDWALL")
defineTile('!', "DOOR_VAULT")

defineTile('*', "FLOOR", {random_filter={add_levels=20, tome_mod="gvault"}})
defineTile('~', "FLOOR", {random_filter={add_levels=10, tome_mod="gvault"}})

defineTile('w', "FLOOR", nil, {random_filter={add_levels=10, name = "carrion worm mass"}} )
defineTile('W', "FLOOR", nil, {random_filter={add_levels=5, name = "worm that walks"}} )

return {
 [[#########]],
 [[#~~w*w~~#]],
 [[#..www..#]],
 [[#..ooo..#]],
 [[#..w.o..#]],
 [[#.WowoW.#]],
 [[#~~o.o~~#]],
 [[####!####]],
}