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
local MST = require "engine.algorithms.MST"

-- rng.seed(1)

local tm = Tilemap.new(self.mapsize, '=', 1)

local bsp = BSP.new(4, 4, 10):make(50, 50, '.', '#')

-- Remove a few rooms
for i = 1, #bsp.rooms / 4 do
	local room = rng.tableRemove(bsp.rooms)
	room.map:carveArea('#', room.map:point(1, 1), room.map.data_size)
end

local mstrun = MST.new()

-- Generate all possible edges
for i, room1 in ipairs(bsp.rooms) do
	local c = room1.map:centerPoint()
	for j, room2 in ipairs(bsp.rooms) do if room1 ~= room2 then
		local c1, c2 = room1.map:centerPoint(), room2.map:centerPoint()
		mstrun:edge(room1, room2, core.fov.distance(c1.x, c1.y, c2.x, c2.y))
	end end
end

-- Compute!
mstrun:run()

for _, edge in pairs(mstrun.mst) do
	if edge.from.from.x - 1 == edge.to.to.x + 1 then
		local min_y, max_y = math.max(edge.from.from.y, edge.to.from.y), math.min(edge.from.to.y, edge.to.to.y)
		bsp:put(bsp:point(edge.from.from.x - 1, rng.range(min_y, max_y)), rng.percent(40) and '+' or '.')
	elseif edge.from.to.x + 1 == edge.to.from.x - 1 then
		local min_y, max_y = math.max(edge.from.from.y, edge.to.from.y), math.min(edge.from.to.y, edge.to.to.y)
		bsp:put(bsp:point(edge.from.to.x + 1, rng.range(min_y, max_y)), rng.percent(40) and '+' or '.')
	elseif edge.from.from.y - 1 == edge.to.to.y + 1 then
		local min_x, max_x = math.max(edge.from.from.x, edge.to.from.x), math.min(edge.from.to.x, edge.to.to.x)
		bsp:put(bsp:point(rng.range(min_x, max_x), edge.from.from.y - 1), rng.percent(40) and '+' or '.')
	elseif edge.from.to.y + 1 == edge.to.from.y - 1 then
		local min_x, max_x = math.max(edge.from.from.x, edge.to.from.x), math.min(edge.from.to.x, edge.to.to.x)
		bsp:put(bsp:point(rng.range(min_x, max_x), edge.from.to.y + 1), rng.percent(40) and '+' or '.')
	end
end

bsp:applyOnGroups(bsp:findGroupsOf{'.', '+'}, function(room, idx)
	room:submap(tm)
	if room.map.data_size:area() < 10 then
		room.map:carveArea('#', room.map:point(1, 1), room.map.data_size)
	end
end)
-- if bsp:eliminateByFloodfill{'#'} < 10 then return self:regenerate() end

tm:merge(1, 1, bsp)


return tm
