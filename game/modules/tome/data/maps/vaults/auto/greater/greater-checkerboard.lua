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

startx, starty = 19, 0
setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}
roomCheck(function(room, zone, level, map)
	return resolvers.current_level >= 25
end)
specialList("actor", {
	"/data/general/npcs/all.lua",
})
border = 0
defineTile('.', "FLOOR")
defineTile('#', "DOOR")
defineTile('X', "HARDWALL")
defineTile('8', "FLOOR", {random_filter={add_levels=15, tome_mod="gvault"}}, {random_filter={add_levels=50}})
defineTile('!', "DOOR_VAULT")

defineTile('7', "FLOOR", {random_filter={add_levels=15, tome_mod="uvault"}}, {random_filter={add_levels=15, random_boss={name_scheme=_t"#rng# the Guardian", nb_classes=3, loot_unique=true, ai_move="move_complex", rank=4}}})

rotates = {"default", "90", "180", "270", "flipx", "flipy"}

return {
[[...........................]],
[[.XXXXXXXXXXXXXXXXXXXXXXXXX.]],
[[.!8#8#8#8#8#8#8#8#8#8#8#8X.]],
[[.XXXXXXXXXXXXXXXXXXXXXXX#X.]],
[[.X8#8#8#8#8#8#8#8#8#8#8X.X.]],
[[.X#XXXXXXXXXXXXXXXXXXXXX#X.]],
[[.X8X7#8#8#8#8#8#8#8#8#8#.X.]],
[[.X#XXXXXXXXXXXXXXXXXXXXXXX.]],
[[.X8#8#8#8#8#8#8#8#8#8#8#8!.]],
[[.XXXXXXXXXXXXXXXXXXXXXXXXX.]],
[[...........................]],
}