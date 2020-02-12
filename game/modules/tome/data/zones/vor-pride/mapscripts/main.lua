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

self:defineTile("-", "BURNT_GROUND", nil, nil, nil, {no_teleport=true})
self:defineTile("o", "GOTHIC_FLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end}})
if level.level == zone.max_level then self:defineTile(">", 'BURNT_GROUND') else self:defineTile(">", "FLAT_DOWN4", nil, nil, nil, {no_teleport=true}) end
self:defineTile("O", "GOTHIC_FLOOR", nil, {random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=3, ai_move="move_complex", rank=4,}}})
self:defineTile("X", "BURNT_GROUND", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=3}}}, nil, {no_teleport=true})
self:defineTile('&', "GOTHIC_GENERIC_LEVER", nil, nil, nil, {lever=1, lever_kind="pride-doors", lever_spot={type="lever", subtype="door", check_connectivity="entrance"}}, {type="lever", subtype="lever", check_connectivity="entrance"})
self:defineTile('*', "GOTHIC_GENERIC_LEVER_DOOR", nil, nil, nil, {lever_action=2, lever_action_value=0, lever_action_kind="pride-doors"}, {type="lever", subtype="door", check_connectivity="entrance"})

self:defineTile('B', {"GENERIC_BOOK1","GENERIC_BOOK2","GENERIC_BOOK3"})
self:defineTile('C', "CANDLE", nil, {random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=0, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=3.5, force_classes={Archmage=true}}}})
self:defineTile('D', "CANDLE", nil, {random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=0, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, ai_move="move_complex", rank=3.5, force_classes={Archmage=true}}}})

local wfc = WaveFunctionCollapse.new{
	mode="overlapping",
	sample=self:getFile("!buildings.tmx", "samples"),
	size={34, 34},
	n=3, symmetry=8, periodic_out=false, periodic_in=false, has_foundation=false
}
local outer = Static.new(self:getFile("pride-outer.lua", "mapscripts/maps"))
tm:merge(1, 1, outer, merge_order)
tm:merge(8, 8, wfc, merge_order)

-- Find rooms
local rooms = tm:findGroupsOf{'r'}
tm:applyOnGroups(rooms, function(room, idx)
	tm:fillGroup(room, '.')
	local border = tm:getBorderGroup(room)
	local door = border:pickSpot("inside-wall", "straight", function(p) return tm:isA(p, '#', 'T') end)
	if door then tm:put(door, '+') end

	-- A spot for subvaults
	local event = room:pickSpot("any")
	if event then
		self:addSpot(event, "event-spot", "subvault-place")
		room:remove(event)
	end

	-- Sometimes an archmage rare that reads a book
	if rng.percent(25) then
		local bpos = room:pickSpot("any")
		if bpos then
			local cpos = room:randomNearPoint(bpos)
			if cpos then
				tm:put(bpos, 'B')
				tm:put(cpos, (rng.percent(65) and 'C' or 'D'))
			end
		end
	end
end)

if rng.percent(15) and not game.state:doneEvent("renegade-pyromancers") then 
	game.state:doneEvent("renegade-pyromancers",1) -- special vault! can only show once per game and only in vor pride; contains exceptionally difficult foes and exceptional loot
	game.level.data.generator.map.greater_vaults_list = {"renegade-pyromancers"}
end
		
-- Complete the map by putting wall in all the remaining blank spaces
tm:fillAll()
-- if tm:eliminateByFloodfill{'#', 'T'} < 400 then return self:regenerate() end

-- tm:printResult()
return tm
