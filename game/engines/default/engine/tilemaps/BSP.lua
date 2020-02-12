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

require "engine.class"
local Tilemap = require "engine.tilemaps.Tilemap"
local Proxy = require "engine.tilemaps.Proxy"
local AlgoBSP = require "engine.algorithms.BSP"
local MST = require "engine.algorithms.MST"

--- Generate partitioned "building"
-- @classmod engine.tilemaps.BSP
module(..., package.seeall, class.inherit(Tilemap))

local make_edge

function _M:init(min_w, min_h, max_depth, inner_walls)
	Tilemap.init(self)
	self.a_min_w, self.a_min_h, self.a_max_depth = min_w, min_h, max_depth
	self.inner_walls = inner_walls
end

function _M:make(w, h, floor, wall)
	local bsp = AlgoBSP.new(w, h, self.a_min_w, self.a_min_h, self.a_max_depth)
	bsp:partition()

	self:setSize(w, h, ' ')

	self.rooms = {}

	for idx, leaf in ipairs(bsp.leafs) do
		local from = self:point(leaf.rx + 1, leaf.ry + 1)
		local to = self:point(leaf.rx + 1 + leaf.w - 2, leaf.ry + 1 + leaf.h - 2)
		local group = self:carveArea(idx, from, to)
		group.idx = idx
		if wall then
			if self.inner_walls then
				for i = from.x, to.x do
					self:put(self:point(i, from.y), wall)
					self:put(self:point(i, to.y), wall)
				end
				for j = from.y, to.y do
					self:put(self:point(from.x, j), wall)
					self:put(self:point(to.x, j), wall)
				end
			else
				for i = from.x - 1, to.x + 1 do
					self:put(self:point(i, from.y - 1), wall)
					self:put(self:point(i, to.y + 1), wall)
				end
				for j = from.y - 1, to.y + 1 do
					self:put(self:point(from.x - 1, j), wall)
					self:put(self:point(to.x + 1, j), wall)
				end
			end
		end

		self.rooms[#self.rooms+1] = group
		-- self.rooms[#self.rooms+1] = {
		-- 	from = from, 
		-- 	to = to, 
		-- 	center = center,
		-- 	group = group,
		-- 	map = Proxy.new(self, from, leaf.w - 1, leaf.h - 1),
		-- }
	end

	local up, down, left, right = self:point(0, -2), self:point(0, 2), self:point(-2, 0), self:point(2, 0)
	local up1, down1, left1, right1 = self:point(0, -1), self:point(0, 1), self:point(-1, 0), self:point(1, 0)

	-- Find all the edges per rooms
	self:applyOnGroups(self.rooms, function(room, idx)
		local edges = {up={}, down={}, left={}, right={}}
		local from, to = room:bounds()
		local p1, p2, p3, p4 = from, self:point(to.x, from.y), to, self:point(from.x, to.y)
		for p in p1:iterateTo(p2) do
			local c = self:get(p + up)
			if self.rooms[c] then edges.up[c] = edges.up[c] or {} table.insert(edges.up[c], p+up1) end
		end
		for p in p2:iterateTo(p3) do
			local c = self:get(p + right)
			if self.rooms[c] then edges.right[c] = edges.right[c] or {} table.insert(edges.right[c], p+right1) end
		end
		for p in p3:iterateTo(p4) do
			local c = self:get(p + down)
			if self.rooms[c] then edges.down[c] = edges.down[c] or {} table.insert(edges.down[c], p+down1) end
		end
		for p in p4:iterateTo(p1) do
			local c = self:get(p + left)
			if self.rooms[c] then edges.left[c] = edges.left[c] or {} table.insert(edges.left[c], p+left1) end
		end
		room.edges = edges
	end, true)
	self:applyOnGroups(self.rooms, function(room, idx) self:fillGroup(room, '.') end, true)

	-- Find all edges
	local edges = {}
	local eidx = 1
	for idx, room in ipairs(self.rooms) do
		for dir, list in pairs(room.edges) do
			for tidx, points in pairs(list) do
				local e = make_edge(room, self.rooms[tidx], points, dir)
				e.idx = eidx
				edges[e:hash()] = e
				eidx = eidx + 1
			end
		end
	end
	self.edges = table.values(edges)

	return self
end

function _M:removeRoom(croom)
	-- Remove room edges
	for idx, room in ipairs(self.rooms) do if croom == room then
		for dir, list in pairs(room.edges) do
			for tidx, points in pairs(list) do
				if self.rooms[tidx] == croom then
					list[tidx] = nil
					break
				end
			end
		end
	end end

	-- Remove edges
	for idx, edge in ripairs(self.edges) do
		if edge.from == croom or edge.to == croom then
			table.remove(self.edges, idx)
		end
	end

	-- Remove it now
	for idx, room in ipairs(self.rooms) do if croom == room then
		table.remove(self.rooms, idx)
		break
	end end
end

function _M:mstEdges(fatten)
	local mstrun = MST.new()
	for i, edge in ipairs(self.edges) do mstrun:edge(edge.from, edge.to, edge.from:center():distance(edge.to:center()), edge) end
	mstrun:run()
	mstrun:fattenRandom(fatten or 0)
	local edges = {}
	for _, edge in pairs(mstrun.mst) do
		edges[#edges+1] = edge.data
	end
	return edges
end

function _M:mergedAt(x, y)
	Tilemap.mergedAt(self, x, y)

	for idx, room in ipairs(self.rooms) do
		room:translate(self.merged_pos - 1)
	end

	for idx, edge in ripairs(self.edges) do
		for i, p in ipairs(edge.points) do
			edge.points[i] = p + self.merged_pos - 1
		end
	end
end

-----------------------------------------------------------
-- Small Edge class
-----------------------------------------------------------
Edge_t = { __index = {
	hash = function(e)
		local s1, s2 = tostring(e.from.idx), tostring(e.to.idx)
		if s2 < s1 then s2, s1 = s1, s2 end
		return s1..":"..s2
	end,
} }

make_edge = function(r1, r2, points, dir)
	local e = setmetatable({from=r1, to=r2, points=points, dir=dir}, Edge_t)
	return e
end
-----------------------------------------------------------