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

local unionfind = require "algorithms.unionfind"

--- Find a MST (Minimum Spanning Tree), aka the smallest fully connected graph, from a graph presented as a list of weighted edges
-- @classmod engine.algorithms.MST
module(..., package.seeall, class.make)

-----------------------------------------------------------
-- Small Edge class
-----------------------------------------------------------
local Edge_t
Edge_t = { __index = {
	hash = function(e)
		local s1, s2 = tostring(e.from), tostring(e.to)
		if s2 < s1 then s2, s1 = s1, s2 end
		return s1..":"..s2
	end,
} }

function Edge(r1, r2, cost, data)
	return setmetatable({from=r1, to=r2, cost=cost, data=data}, Edge_t)
end
-----------------------------------------------------------

function _M:init()
	self.mst = {}
	self.edges = {}
	self.sorted_edges = {}
end

function _M:edge(r1, r2, cost, data)
	local e
	if getmetatable(r1) == Edge_t then e = r1
	else e = Edge(r1, r2, cost, data) end
	self.edges[e:hash()] = e
end

function _M:run()
	self.sorted_edges = table.values(self.edges)
	table.sort(self.sorted_edges, "cost")

	-- Find the MST graph
	local uf = unionfind.create()
	for _, edge in ipairs(self.sorted_edges) do
		-- Skip this edge to avoid creating a cycle in MST
		if not uf:connected(edge.from, edge.to) then
			-- Include this edge
			uf:union(edge.from, edge.to)

			-- Add it to the final graph
			self.mst[edge:hash()] = edge

			-- Remove it from the remaining edges
			self.edges[edge:hash()] = nil
		end
	end
	return self.mst
end

function _M:fattenRandom(nb_adds)
	while nb_adds > 0 and next(self.edges) do
		local edge = rng.table(table.values(self.edges))
		self.edges[edge:hash()] = nil
		self.mst[edge:hash()] = edge
		nb_adds = nb_adds - 1
	end
end
