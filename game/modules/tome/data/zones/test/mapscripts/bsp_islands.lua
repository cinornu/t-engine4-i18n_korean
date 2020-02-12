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

local BSP = require "engine.tilemaps.BSP"

-- rng.seed(2)

local tm = Tilemap.new(self.mapsize, '=', 1)

local bsp = BSP.new(10, 10, 2):make(50, 50, nil, '=')

for _, room in ipairs(bsp.rooms) do
	local pond = Heightmap.new(1.6, {up_left=0, down_left=0, up_right=0, down_right=0, middle=1}):make(room.map.data_w, room.map.data_h, {' ', ' ', ';', ';', 'T', ';', ';', ';'})
	-- Ensure exit from the lake to exterrior
	local pond_exit = pond:findRandomExit(pond:centerPoint(), nil, {';'})
	pond:tunnelAStar(pond:centerPoint(), pond_exit, ';', {'T'}, {}, {erraticness=9})
	-- If lake is big enough and we find a spot, place it
	if pond:eliminateByFloodfill{'T', ' '} < 8 then return self:regenerate() end

	room.map:merge(1, 1, pond)
end

tm:merge(1, 1, bsp)

-- if tm:eliminateByFloodfill{'T','#'} < 800 then return self:regenerate() end

return tm
