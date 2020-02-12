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

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}
roomCheck(function(room, zone, level, map)
   return resolvers.current_level >= 5 and resolvers.current_level <= 25
end)
specialList("actor", {
   "/data/general/npcs/crystal.lua",
})
border = 0
startx, starty = 4, 10
defineTile('.', data.floor or "FLOOR")
defineTile(',', "FLOOR")
defineTile('!', "DOOR_VAULT")
defineTile('X', "HARDWALL")
defineTile('G', "FLOOR", {random_filter={type="gem"}})
defineTile('C', "FLOOR", nil, {random_filter={subtype="crystal", add_levels=4}})

rotates = {"default", "90", "180", "270", "flipx", "flipy"}

return {
[[.........]],
[[.XXXXXXX.]],
[[.XXXXXXX.]],
[[.X,C,C,X.]],
[[.XGG,GGX.]],
[[.XGG,GGX.]],
[[.X,C,C,X.]],
[[.XXX!XXX.]],
[[.XXX.XXX.]],
[[.XXX.XXX.]],
[[.........]],
}