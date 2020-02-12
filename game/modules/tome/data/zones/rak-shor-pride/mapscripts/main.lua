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

self:defineTile("-", "BONEFLOOR", nil, nil, nil, {no_teleport=true})
self:defineTile("o", "BONEFLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end}})
self:defineTile(">", "BONE_LADDER_DOWN", nil, nil, nil, {no_teleport=true})
self:defineTile("O", "BONEFLOOR", nil, {random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=3, ai_move="move_complex", rank=4,}}})
self:defineTile("X", "BONEFLOOR", nil, {entity_mod=function(e) e.make_escort = nil return e end, random_filter={type='humanoid', subtype='orc', special=function(e) return e.pride == mapdata.pride end, random_boss={nb_classes=1, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=3}}}, nil, {no_teleport=true})
self:defineTile('&', "BONE_GENERIC_LEVER", nil, nil, nil, {lever=1, lever_kind="pride-doors", lever_spot={type="lever", subtype="door", check_connectivity="entrance"}}, {type="lever", subtype="lever", check_connectivity="entrance"})
self:defineTile('*', "BONE_GENERIC_LEVER_DOOR", nil, nil, nil, {lever_action=2, lever_action_value=0, lever_action_kind="pride-doors"}, {type="lever", subtype="door", check_connectivity="entrance"})

local wfc = WaveFunctionCollapse.new{
	mode="overlapping",
	sample=self:getFile("!buildings2.tmx", "samples"),
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
	local door = border:pickSpot("inside-wall")
	if door then tm:put(door, '+') end

	local event = room:pickSpot("any")
	if event then self:addSpot(event, "event-spot", "subvault-place") end
end)

if rng.percent(15) and not game.state:doneEvent("renegade-undead") then 
	game.state:doneEvent("renegade-undead",1) -- special vault! can only show once per game and only in rak'shor pride; contains exceptionally difficult foes and exceptional loot
	game.level.data.generator.map.greater_vaults_list = {"renegade-undead"}
end

-- Complete the map by putting wall in all the remaining blank spaces
tm:fillAll()

-- if tm:eliminateByFloodfill{'#', 'T'} < 400 then return self:regenerate() end

tm:printResult()

return tm
