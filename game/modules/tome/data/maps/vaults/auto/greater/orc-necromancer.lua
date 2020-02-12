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
startx, starty = 30, 7
border = 0
specialList("terrain", {
	"/data/general/grids/water.lua",
}, true)
specialList("actor", {
	"/data/general/npcs/bone-giant.lua",
}, true)
roomCheck(function(room, zone, level, map)
	local ret = resolvers.current_level >= 20 and zone.npc_list.__loaded_files["/data/general/npcs/orc.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/orc-rak-shor.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/ghost.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/ghoul.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/skeleton.lua"]
	if ret then
		for i, e in ipairs(room.npc_list) do -- set up special bonegiant rarity
			if not e.bonegiant_rarity and e.type == "undead" and e.subtype == "giant" and not e.unique then
				e.bonegiant_rarity = e.rarity; e.rarity = nil
			end
		end
		return true
	end
end)
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile('~', "DEEP_WATER")
defineTile('#', "HARDWALL")
defineTile('%', "WALL")
defineTile('+', "DOOR")
defineTile('X', "DOOR_VAULT")
--a floor tile with a +15 level guaranteed ego and a +15 level dreadmaster
defineTile('$', "FLOOR", {random_filter={add_levels=15, tome_mod="vault"}}, {random_filter={add_levels=15, name="dreadmaster"}})
--a floor tile with a staff and no monster
defineTile('\\', "FLOOR", {random_filter={subtype="staff", tome_mod="vault", add_levels=5}}, nil)
defineTile('(', "FLOOR", {random_filter={subtype="cloth", tome_mod="uvault", add_levels=5}}, nil)
defineTile('o', "FLOOR", nil, {random_filter={subtype="orc", add_levels=5}})
defineTile('O', "FLOOR", nil, {random_filter={add_levels=15, name="orc necromancer"}})
defineTile('K', "FLOOR", nil, {random_filter={add_levels=5, type="undead", subtype="giant", special_rarity="bonegiant_rarity"}})

return {
[[...............................]],
[[.#############################.]],
[[.#...................+...+.K\#.]],
[[.#.......o....o......#####.o\#.]],
[[.#......................K#.K\#.]],
[[.#.....o.................#####.]],
[[.#~~~.....o...###........#o.K#.]],
[[.#~O~..o......%$#........+...X.]],
[[.#~~~.........###........#o.K#.]],
[[.#.......o..o............#####.]],
[[.#......................K#.K(#.]],
[[.#....o....o.........#####.o(#.]],
[[.#...................+...+.K(#.]],
[[.#############################.]],
[[...............................]],
}
