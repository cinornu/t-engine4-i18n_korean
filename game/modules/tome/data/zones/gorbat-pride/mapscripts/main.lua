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

self:defineTile("|", "FENCE_WALL")
self:defineTile(":", "FENCE_FLOOR", nil, nil, nil, {special="roost"})
self:defineTile("!", "FENCE_DOOR")
self:defineTile("/", "ROCK_DOOR")
self:defineTile("-", "FLOOR", nil, nil, nil, {no_teleport=true})
self:defineTile("o", "FLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end}})
if level.level == zone.max_level then self:defineTile(">", 'FLOOR') else self:defineTile(">", "FLAT_DOWN4", nil, nil, nil, {no_teleport=true}) end
self:defineTile("O", "FLOOR", nil, {random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=3, ai_move="move_complex", rank=4,}}})
self:defineTile("X", "FLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=3}}}, nil, {no_teleport=true})
self:defineTile("d", "FENCE_FLOOR", nil, {random_filter={special_rarity="drake_rarity"}}, nil, {special="roost"})
self:defineTile("D", "FENCE_FLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={special_rarity="drake_rarity", special=function(e) return e.rank == 3 end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, ai_move="move_complex", rank=3.5}}}, nil, {special="roost"}) --drops a fixedart
self:defineTile("R", "FENCE_FLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={special_rarity="drake_rarity", special=function(e) return e.rank == 3 end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=3.5}}}, nil, {special="roost"}) --drops a randart
self:defineTile('&', "GENERIC_LEVER_SAND", nil, nil, nil, {special="roost", lever=1, lever_kind="pride-doors", lever_spot={type="lever", subtype="door", check_connectivity="entrance"}}, {type="lever", subtype="lever", check_connectivity="entrance"})
self:defineTile('*', "ROCK_LEVER_DOOR", nil, nil, nil, {lever_action=2, lever_action_value=0, lever_action_kind="pride-doors"}, {type="lever", subtype="door", check_connectivity="entrance"})

local wfc = WaveFunctionCollapse.new{
	mode="overlapping",
	sample=self:getFile("!buildings2.tmx", "samples"),
	size={34, 34},
	n=3, symmetry=8, periodic_out=false, periodic_in=false, has_foundation=false
}
local outer = Static.new(self:getFile("!gorbat-outer.lua", "samples"))
tm:merge(1, 1, outer, merge_order)
tm:merge(8, 4, wfc, merge_order)

-- Find rooms
local levers_placed = 0
local rooms = tm:findGroupsOf{':'}
tm:applyOnGroups(rooms, function(room, idx)
	local border = tm:getBorderGroup(room)
	tm:fillGroup(border, '|') -- Make sure we have walls all around
	local door = border:pickSpot("inside-wall", "straight", function(p) return tm:isA(p, '#', '|') end)
	if door then tm:put(door, '!') end

	local lever = room:pickSpot("any")
	if lever and levers_placed < 2 then
		levers_placed = levers_placed + 1
		tm:put(lever, '&')
		room:remove(lever)
	end

	-- Drakes are not out in the wild in gorbat, they are in the roosts; sometimes there is one more powerful too
	local had_boss = false
	for i = 1, rng.range(1, 5) do
		local drake = room:pickSpot("any")
		if drake then
			local boss = rng.percent(25) and not had_boss
			tm:put(drake, boss and (rng.percent(65) and 'D' or 'R') or 'd')
			room:remove(drake)
			if boss then had_boss = true end
		else
			break
		end
	end
end)
if levers_placed < 2 then return self:redo() end

if rng.percent(15) and not game.state:doneEvent("renegade-wyrmics") then 
	game.state:doneEvent("renegade-wyrmics",1) -- special vault! can only show once per game and only in gorbat pride; contains exceptionally difficult foes and exceptional loot
	game.level.data.generator.map.greater_vaults_list = {"renegade-wyrmics"}
end

-- Complete the map by putting wall in all the remaining blank spaces
tm:fillAll()

-- if tm:eliminateByFloodfill{'#', 'T'} < 400 then return self:redo() end

tm:printResult()

return tm
