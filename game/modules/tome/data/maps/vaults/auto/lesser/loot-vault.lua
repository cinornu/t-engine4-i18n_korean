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
--setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {special=false, can_open=true}}
border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}
roomCheck(function(room, zone, level, map)
	return resolvers.current_level > 5 and resolvers.current_level <= 25
end)
specialList("terrain", {
	"/data/general/grids/forest.lua",
}, true)
startx = 4
starty = 6
--defineTile(',', data.floor or data['.'] or "GRASS")
defineTile(',', data.floor or data['.'] or "GRASS", nil, nil, nil, {room_map={special=false, room=false, can_open=true}})
defineTile('.', "FLOOR")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR_VAULT")
-- Forest Tomb
if rng.percent(66) then

	specialList("actor", {
		"/data/general/npcs/wight.lua",
	})
	defineTile('$', "FLOOR", {random_filter={add_levels=10, tome_mod="vault"}})
	defineTile('W', "FLOOR", {random_filter={add_levels=10, tome_mod="vault"}}, {random_filter={add_levels=15, name="forest wight"}})

	return {
	[[,,,,,,,,,]],
	[[,,,###,,,]],
	[[,,#####,,]],
	[[,##$$$##,]],
	[[,##$W$##,]],
	[[,,##.##,,]],
	[[,,,#+#,,,]],
	[[,,,,,,,,,]],
	}
-- Empty vault
else
	local lore = mod.class.Object.new{
		type = "lore", subtype="lore",
		unided_name = _t"scroll", identified=true,
		display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll.png",
		encumber = 0,
		name = _t"Mocking Note", lore="loot-vault-empty",
		desc = _t[[A small scrap of paper written in a mocking tone.]],
		level_range = {1, 20},
		rarity = false,
	}

	defineTile('?', "FLOOR", lore)

	return {
	[[,,,,,,,,,]],
	[[,,,###,,,]],
	[[,,#####,,]],
	[[,##.?.##,]],
	[[,##...##,]],
	[[,,##.##,,]],
	[[,,,#+#,,,]],
	[[,,,,,,,,,]],
	}
end
