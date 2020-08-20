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
local sroom_factory = Rooms.new(self, "simple")
local rroom_factory = Rooms.new(self, "random_room")
local vault_factory = Rooms.new(self, "greater_vault")

local binpack = require('binpack')
local bp = binpack(tm.data_w, tm.data_h)

local nb_vault = 0
local rooms = {}
local max_area = tm.data_w * tm.data_h
local cur_area = 0
while cur_area < max_area do
	local proom = (nb_vault > 0 and vault_factory or (rng.percent(50) and sroom_factory or rroom_factory)):generateRoom()
	if proom then
		nb_vault = nb_vault - 1
		cur_area = cur_area + (proom.data_w+2) * (proom.data_h+2)
		if cur_area > max_area then break end
		local coords = bp:insert(proom.data_w+2, proom.data_h+2)
		if not coords then break end
		-- tm:carveArea('.', tm:point(coords.x+2,coords.y+2), tm:point(coords.x+2,coords.y+2) + tm:point(coords.w-1, coords.h-1) - 1)
		tm:merge(tm:point(coords.x+2,coords.y+2), proom:build())
		rooms[#rooms+1] = proom
	end
end
game.log("!!! %d", #rooms)
if not loadMapScript("lib/connect_rooms_multi", {map=tm, rooms=rooms, door_chance=60, edges_surplus=3}) then return self:redo() end

tm:printResult()

return tm
