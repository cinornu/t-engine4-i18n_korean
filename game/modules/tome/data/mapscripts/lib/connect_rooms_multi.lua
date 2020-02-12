-- TE4 - T-Engine 4
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


-- This file uses Kruskals algorithm to find a MST(minimum spanning tree) in a graph of rooms

local MST = require "engine.algorithms.MST"

local max_links = args.max_links or 3
local map = args.map
local rooms = args.rooms

if #rooms <= 1 then return true end -- Easy !

local mstrun = MST.new()

-- Generate all possible edges
for i, room in ipairs(rooms) do
	local c = room:centerPoint()
	for j, proom in ipairs(rooms) do if proom ~= room then
		local c1, c2 = room:centerPoint(), proom:centerPoint()
		mstrun:edge(room, proom, core.fov.distance(c1.x, c1.y, c2.x, c2.y))
	end end
end

-- Compute!
mstrun:run()

-- Add some more randomly selected edges
mstrun:fattenRandom(args.edges_surplus or 0)

-- Draw the paths
local full = true
for _, edge in pairs(mstrun.mst) do
	local pos1, kind1
	local pos2, kind2
	if args.from_center then
		pos1, kind1 = edge.to:centerPoint(), 'open'
		pos2, kind2 = edge.from:centerPoint(), 'open'
	else
		pos1, kind1 = edge.from:findRandomClosestExit(7, edge.to:centerPoint(), nil, args.exitable_chars or {'.', ';', '='})
		pos2, kind2 = edge.to:findRandomClosestExit(7, edge.from:centerPoint(), nil, args.exitable_chars or {'.', ';', '='})
	end
	if pos1 and pos2 then
		map:tunnelAStar(pos1, pos2, args.tunnel_char or '.', args.tunnel_through or {'#'}, args.tunnel_avoid or nil, {erraticness=args.erraticness or 5})
		if kind1 == 'open' then map:smartDoor(pos1, args.door_chance or 40, '+') end
		if kind2 == 'open' then map:smartDoor(pos2, args.door_chance or 40, '+') end
	else
		full = false
	end
end

return full
