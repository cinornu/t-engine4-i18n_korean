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

local merge_order = {'.', '_', 'r', '+', '#', 'O', ';', '=', 'T'}

-- Water & trees layer
local wfcwater = WaveFunctionCollapse.new{
	mode="overlapping", async=true,
	sample=self:getFile("!wfctest2.tmx", "samples"),
	size={self.mapsize.w/3, self.mapsize.h},
	n=3, symmetry=8, periodic_out=true, periodic_in=true, has_foundation=false
}
-- Outer buildings
local wfcouter = WaveFunctionCollapse.new{
	mode="overlapping", async=true,
	sample=self:getFile("!wfctest.tmx", "samples"),
	size={self.mapsize.w/3, self.mapsize.h},
	n=3, symmetry=8, periodic_out=true, periodic_in=true, has_foundation=false
}
-- Inner buildings
local wfcinner = WaveFunctionCollapse.new{
	mode="overlapping", async=true,
	sample=self:getFile("!wfctest5.tmx", "samples"),
	size={self.mapsize.w/2, self.mapsize.h-2},
	n=3, symmetry=8, periodic_out=false, periodic_in=false, has_foundation=false
}

-- Load predrawn stuff
local doorway = Static.new(self:getFile("!door.tmx", "samples"))
local doorwaytunnel = doorway:locateTile('E', '.')

-- Wait for all generators to finish
if not WaveFunctionCollapse:waitAll(wfcinner, wfcwater, wfcouter) then print("[inner_outer] a WFC failed") return self:regenerate() end

-- Merge them all
local tm = Tilemap.new(self.mapsize)
wfcouter:merge(1, 1, wfcwater, merge_order)
if wfcouter:eliminateByFloodfill{'#', 'T'} < 400 then print("[inner_outer] outer is too small") return self:regenerate() end
if wfcinner:eliminateByFloodfill{'#', 'T'} < 400 then print("[inner_outer] inner is too small") return self:regenerate() end
tm:merge(1, 1, wfcouter, merge_order)
tm:merge(self.mapsize.w - wfcinner.data_w, 2, wfcinner, merge_order)

-- Place the doorway and tunnel from it to the dungeon part on the right
local doorwaypos = tm:point(self.mapsize.w / 3, (self.mapsize.h - doorway.data_h) / 2)
tm:merge(doorwaypos.x, doorwaypos.y, doorway)
tm:carveLinearPath('.', doorwaytunnel + doorwaypos, 6, '.')

-- Find rooms
local rooms = tm:findGroupsOf{'r'}
local noroomforest = true
tm:applyOnGroups(rooms, function(room, idx)
	local p1, p2, rw, rh = tm:groupOuterRectangle(room)
	print("ROOM", idx, "::", rw, rh, "=>", rw * rh)
	tm:fillGroup(room, '.')
	if noroomforest and rw >= 8 and rh >= 8 then
		local pond = Heightmap.new(1.6, {up_left=0, down_left=0, up_right=0, down_right=0, middle=1}):make(rw-2, rh-2, {' ', ';', ';', 'T', '=', '='})
		pond:printResult()
		-- tm:fillGroup(room, ';')
		tm:merge(p1.x+1, p1.y+1, pond)
		noroomforest = false
	end

	self:addSpot(p1.x + rw/2, p1.y + rh/2, "spawn-spot", "spawn-spot")

	-- table.print()
	for j = 1, #room.list do
		local jn = room.list[j]
		-- data[jn.y][jn.x] = tostring(idx)
	end
end)
if noroomforest then return self:regenerate() end

-- Complete the map by putting wall in all the remaining blank spaces
tm:fillAll()

-- Elimitate the rest
if tm:eliminateByFloodfill{'#', 'T'} < 400 then return self:regenerate() end

tm:printResult()

-- print('---==============---')
-- local noise = Noise.new(nil, 0.5, 2, 3, 6):make(80, 50, {'T', 'T', '=', '=', '=', ';', ';'})
-- noise:printResult()
-- print('---==============---')
-- print('---==============---')
-- local pond = Heightmap.new(1.9, {up_left=0, down_left=0, up_right=0, down_right=0, middle=1}):make(30, 30, {';', 'T', '=', '=', ';'})
-- pond:printResult()
-- print('---==============---')
-- print('---==============---')
-- local maze = Maze.new():makeSimple(31, 31, '.', {'#','T'}, true)
-- maze:printResult()
-- print('---==============---')

-- DGDGDGDG: make at least Tilemap handlers for BSP, roomer (single room), roomers and correctly handle up/down stairs

return tm
