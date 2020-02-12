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

setStatusAll{no_teleport=true, no_vaulted=true, room_map = {can_open=true}}
roomCheck(function(room, zone, level, map)
	return resolvers.current_level <= 6 and zone.npc_list.__loaded_files["/data/general/npcs/rodent.lua"]
end)
specialList("actor", {
	"/data/general/npcs/molds.lua"
}, true)
border = 0
local Floor = data.floor or data['.'] or "FLOOR"
defineTile('.', Floor, nil, nil, nil, {room_map={special=false}})
defineTile('D', data.door or "DOOR", nil, nil, nil, {room_map={special=false, can_open=true}})
defineTile('X', data.wall or "WALL")
defineTile('M', Floor, nil, {random_filter={subtype="molds", add_levels=4}})
defineTile('W', Floor, nil, {random_filter={name="giant white rat"}})
defineTile('B', Floor, {random_filter={type="money"}}, {random_filter={name="giant brown rat"}})
defineTile('G', Floor, {random_filter={add_levels=4}}, {random_filter={name="giant grey rat"}})
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

return {
[[.........WW......WW....]],
[[.XXXXXXXXX..XX..XX....W]],
[[.XMWWGWBGWX.XB..WW...X.]],
[[.DBWBXXWWBDWD..WXXB..D.]],
[[.XGBWBWWBMXWXM..MBG.MX.]],
[[.XXXXXXXXXXWXXXXXXXXX.W]],
[[...WW..............WW.W]],
}
