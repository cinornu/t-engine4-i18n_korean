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

-- This is simply an example of how to use levers and some other functions, not a real in-game vault
--unique = true -- one per map
--border = 2
rotates = {"default", "90", "180", "270", "flipx", "flipy"}
prefer_location = function(map) return math.ceil(map.w/2-20), math.ceil(map.h/2-20) end -- try to place in the center of the map
onplace = function(room, zone, level, map)
	game.log("#PINK# Test vault onplace function called: zone:%s, level:%s, map:%s", zone, level, map)
end
roomCheck(function(room, zone, level, map)
	game.log("#PINK# Test vault roomCheck function called: zone:%s, level:%s, map:%s", zone, level, map)
	return true
end)
specialList("actor", {
	"/data/general/npcs/cold-drake.lua",
})
defineTile('C', "FLOOR", nil, {random_filter={add_levels=10, name = "ice wyrm"}})

mapData({test_data="Test of map data"})
map_data = {test_data2 = {"More test data", "Yes, more map data"}}

defineTile('.', "FLOOR")
defineTile('=', "FLOOR", nil, nil, nil, {foobar=true})
defineTile('7', "FLOOR", {random_filter={add_levels=5,tome_mod="vault"}}, nil, nil)
defineTile('&', "GENERIC_LEVER", nil, nil, nil, {lever=1, lever_kind="foo", lever_radius=10, lever_block="foobar"})
defineTile('+', "GENERIC_LEVER_DOOR", nil, nil, nil, {lever_action=3, lever_action_value=0, lever_action_kind="foo"})
defineTile('5', "GENERIC_LEVER_DOOR", nil, nil, nil, {lever_toggle=true, lever_action_kind="foo"})
defineTile('6', "HARDWALL", nil, nil, nil, {on_block_change="FLOOR", on_block_change_msg="Ahah it opens!"})
defineTile('"', "FLOOR", nil, nil, nil, {lever_action_value=0, lever_action_only_once=true, lever_action_kind="foo", lever_action_custom=function(i, j, who, val, old)
	if val == 3 then
		game.level.map:particleEmitter(i, j, 5, "ball_fire", {radius=5})
		return true
	end
end})

return {
[[C7........7]],
[[...+.6.....]],
[[..=====....]],
[[........"..]],
[[..&.&.&....]],
[[...........]],
[[....+5.....]],
[[7.........7]],
}
