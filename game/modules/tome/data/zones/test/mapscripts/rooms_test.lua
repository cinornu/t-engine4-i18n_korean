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

-- rng.seed(2)

local tm = Tilemap.new(self.mapsize, '#')

-- self.data.greater_vaults_list = {"32-chambers"}
local room_factory = Rooms.new(self, "random_room")
local vault_factory = Rooms.new(self, "greater_vault")

local nb_vault = 1
local rooms = {}
for i = 1, 5 do
	local proom = (nb_vault > 0 and vault_factory or room_factory):generateRoom()
	local pos = proom and tm:findRandomArea(nil, tm.data_size, proom.data_w, proom.data_h, '#', 1)
	if pos then
		tm:merge(pos, proom:build())
		rooms[#rooms+1] = proom
		nb_vault = nb_vault - 1
	end
end

local up_stairs = true
-- for i = 1, 20 do
-- 	-- Make a little lake
-- 	local r = rng.range(7, 15)
-- 	local pond = Heightmap.new(1.6, {up_left=0, down_left=0, up_right=0, down_right=0, middle=1}):make(r, r, {' ', ' ', ';', ';', 'T', '=', '=', up_stairs and '<' or '='})
-- 	-- Ensure exit from the lake to exterrior
-- 	local pond_exit = pond:findRandomExit(pond:centerPoint(), nil, {';'})
-- 	pond:tunnelAStar(pond:centerPoint(), pond_exit, ';', {'T'}, {}, {erraticness=9})
-- 	-- If lake is big enough and we find a spot, place it
-- 	if pond:eliminateByFloodfill{'T', ' '} > 8 then
-- 		local pos = tm:findRandomArea(nil, tm.data_size, pond.data_w, pond.data_h, '#', 1)
-- 		if pos then
-- 			tm:merge(pos, pond)
-- 			rooms[#rooms+1] = pond
-- 			up_stairs = false
-- 		end
-- 	end
-- end

if not loadMapScript("lib/connect_rooms_multi", {map=tm, rooms=rooms, door_chance=60, edges_surplus=0}) then return self:redo() end
-- loadMapScript("lib/connect_rooms_multi", {map=tm, rooms=rooms})


self:setEntrance(tm:locateTile('<'))
self:setExit(rooms[#rooms]:centerPoint()) tm:put(rooms[#rooms]:centerPoint(), '>')


-- Elimitate the rest
-- if tm:eliminateByFloodfill{'#', 'T'} < 600 then return self:redo() end

--local spot = tm:point(1, 1)
--loadMapScript("lib/subvault", {map=tm, spot=spot, char="V", greater_vaults_list={"living-weapons"}})

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
