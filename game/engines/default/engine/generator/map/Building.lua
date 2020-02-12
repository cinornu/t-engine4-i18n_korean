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
local Map = require "engine.Map"
local BSP = require "engine.algorithms.BSP"
require "engine.Generator"
local RoomsLoader = require "engine.generator.map.RoomsLoader"

--- @classmod engine.generator.map.Building
module(..., package.seeall, class.inherit(engine.Generator, RoomsLoader))

--- populate the map with clusters of buildings ("blocks") divided into rooms ("buildings") by walls and corridors
-- special grids (in data):
--		external_floor = grid to use between buildings (rooms)
--		outside_floor = grid to use outside the building area
function _M:init(zone, map, level, data)
	engine.Generator.init(self, zone, map, level)
	self.data = data
	self.grid_list = self.zone.grid_list
	self.max_block_w = data.max_block_w or 20 -- max width of a "block" (map partition)
	self.max_block_h = data.max_block_h or 20 -- max height of a "block" (map partition)
	self.max_building_w = data.max_building_w or 7 -- ~ max building width (width >= 2x this forces partitioning)
	self.max_building_h = data.max_building_h or 7 -- ~ max building height (height >= 2x this forces partitioning)
	self.margin_w = data.margin_w or 0 -- horizontal map border (outside of building area)
	self.margin_h = data.margin_h or 0 -- vertical map border (outside of building area)
	self.data.outside_floor = self.data.outside_floor or self.data.external_floor
	self.max_room_w = data.max_room_w or (map.w - 2*self.margin_w)/2 - 1 -- maximum room width
	self.max_room_h = data.max_room_h or (map.h - 2*self.margin_h)/2 - 1 -- maximum room height
	RoomsLoader.init(self, data)
	
end

--- place a door in a wall
function _M:doorOnWall(wall)
	print("=WALLLDOOR")
	table.print(wall)
	if wall.vert then
		local j = rng.table(table.keys(wall.ps))
		self.map(wall.base, j, Map.TERRAIN, self:resolve("door"))
	else
		local i = rng.table(table.keys(wall.ps))
		self.map(i, wall.base, Map.TERRAIN, self:resolve("door"))
	end
	wall.doored = true
end

--- designate a line of grids as a wall and mark possible door spots
function _M:addWall(vert, base, p1, p2)
	local walls = self.walls
	local ps = table.genrange(p1, p2, true)

	for z, _ in pairs(ps) do
		local x, y
		if vert then x, y = base, z else x, y = z, base end
		local rm_map = self.map.room_map[x][y]
		if rm_map.special or (rm_map.room and not rm_map.can_open) then
			ps[z] = nil
		else
			rm_map.walled = true
			if z == p1 or z == p2 or not self.map:checkEntity(x, y, Map.TERRAIN, "block_move") or 2 ~= 
				(self.map:checkEntity(x - 1, y, Map.TERRAIN, "block_move") and 1 or 0) + 
				(self.map:checkEntity(x + 1, y, Map.TERRAIN, "block_move") and 1 or 0) + 
				(self.map:checkEntity(x, y - 1, Map.TERRAIN, "block_move") and 1 or 0) + 
				(self.map:checkEntity(x, y + 1, Map.TERRAIN, "block_move") and 1 or 0) then 
					ps[z] = nil
			end
		end
	end
	-- remove duplicate door spots in any overlapping walls
	for i = 1, #walls do
		local w = walls[i]
		if w.vert == vert and w.base == base then 
			w.ps = table.minus_keys(w.ps, ps)
		end
	end

	walls[#walls+1] = {vert=vert, base=base, ps=ps}
--	print(("\tAdding wall[%d]: %s:%d, (%d-%d)"):format(#walls, vert and "column" or "row", base, p1, p2))
	return walls[#walls]
end

--- create a "building" as an area within a "block" enclosed by walls
function _M:building(leaf, spots)
	local x1, x2 = leaf.rx, leaf.rx + leaf.w
	local y1, y2 = leaf.ry, leaf.ry + leaf.h
	local ix1, ix2, iy1, iy2 = x1 + 2, x2 - 1, y1 + 2, y2 - 1
	local is_lit = rng.percent(self.data.lite_room_chance or 70)

	-- populate leaf grids
	for i = x1, x2 do for j = y1, y2 do
		local rm_map = self.map.room_map[i][j]
		if not rm_map.special and (not rm_map.room or rm_map.can_open) then
			if i == x1 or i == x2 or j == y1 or j == y2 then
				if not rm_map.walled then self.map(i, j, Map.TERRAIN, self:resolve("wall")) end
				rm_map.walled = true
				rm_map.can_open = true
			elseif not rm_map.walled then
				self.map(i, j, Map.TERRAIN, self:resolve("floor"))
				if is_lit then self.map.lites(i, j, true) end
			end
		end
	end end
	
	local walls = {}
	walls.up = self:addWall(false, y1, x1, x2)
	walls.down = self:addWall(false, y2, x1, x2)
	walls.left = self:addWall(true,  x1, y1, y2)
	walls.right = self:addWall(true,  x2, y1, y2)
	self.rooms[#self.rooms+1] = {cx=math.floor((x1+x2)/2), cy=math.floor((y1+y2)/2), id=#self.rooms, walls=walls}

	spots[#spots+1] = {x=math.floor((x1+x2)/2), y=math.floor((y1+y2)/2), type="building", subtype="building"}
end

--- create a "block" as a contiguous partition of the map containing "buildings"
function _M:block(leaf, spots)
	local x1, x2 = leaf.rx, leaf.rx + leaf.w
	local y1, y2 = leaf.ry, leaf.ry + leaf.h
	local ix1, ix2, iy1, iy2 = x1 + 2, x2 - 1, y1 + 2, y2 - 1

	-- populate grids around the border
	for i = x1, x2 do for j = y1, y2 do
		if (i == x1 or i == x2 or j == y1 or j == y2) and not self.map.room_map[i][j].special and (not self.map.room_map[i][j].room or self.map.room_map[i][j].can_open) then
			self.map(i, j, Map.TERRAIN, self:resolve("external_floor") or self:resolve("floor"))
		end
	end end

	local bsp = BSP.new(leaf.w-2, leaf.h-2, self.max_building_w, self.max_building_h)
	bsp:partition()

	print("Building gen made ", #bsp.leafs, "buildings (BSP leafs)")
	for z, sleaf in ipairs(bsp.leafs) do
		sleaf.rx = sleaf.rx + leaf.rx + 1
		sleaf.ry = sleaf.ry + leaf.ry + 1
		self:building(sleaf, spots)
	end
end

function _M:generate(lev, old_lev)
	for i = 0, self.map.w - 1 do for j = 0, self.map.h - 1 do
		if i <= self.margin_w - 1 or i >= self.map.w - self.margin_w + 0 or j <= self.margin_h - 1 or j >= self.map.h - self.margin_h + 0 then
			self.map(i, j, Map.TERRAIN, self:resolve("outside_floor")) -- outside of building space
		else
			self.map(i, j, Map.TERRAIN, self:resolve("external_floor") or self:resolve("floor")) -- between 'buildings'
		end
	end end
	local spots = {}
	self.spots = spots
	self.walls = {}

	-- place specific rooms if needed
	local nb_room = util.getval(self.data.nb_rooms or 0)
	local rooms = self.map.room_map.rooms

	-- make sure rooms meet size limits and are placed inside the margins
	local add_check = function(room, x, y)
		local border = room.border or 0
		if room.w + 2*border > self.max_room_w or room.h > self.max_room_h + 2*border then
			return false
		end
		if x <= self.margin_w + border or x + room.w + border >= self.map.w - self.margin_w or y <= self.margin_h + border or y + room.h + border >= self.map.h - self.margin_h then
			return false
		end
		return true
	end

	print("[Building] placing", nb_room, "rooms")
	-- Place required rooms
	if #self.required_rooms > 0 then
		for i, rroom in ipairs(self.required_rooms) do
			local ok = false
			if type(rroom) == "table" and rroom.chance_room then
				if rng.percent(rroom.chance_room) then rroom = rroom[1] ok = true end
			else ok = true
			end

			if ok then
				local r = self:roomAlloc(rroom, #rooms+1, lev, old_lev, add_check)
				if r then nb_room = nb_room - 1
				else self.level.force_recreate = "required_room "..tostring(rroom) return end
			end
		end
	end
	
	-- Place normal, random rooms
	local tries = nb_room * 1.5 -- allow for extra attempts for difficult to place rooms
	while tries > 0 and nb_room > 0 do
		local rroom
		while true do
			rroom = self.rooms[rng.range(1, #self.rooms)]
			print("[Building] picked random room", rroom)
			if type(rroom) == "table" and rroom.chance_room then
				if rng.percent(rroom.chance_room) then rroom = rroom[1] break end
			else
				break
			end
		end

		local r = self:roomAlloc(rroom, #rooms+1, lev, old_lev, add_check)
		if r then nb_room = nb_room -1 end
		tries = tries - 1
	end

	-- enable doors in edges of each room placed
	for i, r in ipairs(rooms) do
		if not r.room.no_tunnels then -- don't add doors to unconnected rooms
			local walls = {} -- mark edges of room as walls
			r.walls = walls
			walls.top = self:addWall(false, r.y, r.x , r.x + r.room.w - 1)
			walls.bottom = self:addWall(false, r.y + r.room.h - 1, r.x , r.x + r.room.w - 1)
			walls.left = self:addWall(true, r.x, r.y, r.y + r.room.h - 1)
			walls.right = self:addWall(true, r.x + r.room.w - 1, r.y, r.y + r.room.h - 1)
		end
	end
	
	-- partition the map into "blocks"
	local bsp = BSP.new(self.map.w - 2*self.margin_w, self.map.h - 2*self.margin_h, self.max_block_w, self.max_block_h)
	local store = {x=self.margin_w, y=self.margin_h, rx=self.margin_w, ry=self.margin_h, w=self.map.w - 2*self.margin_w - 1, h=self.map.h - 2*self.margin_h - 1, nodes={}, id=0, depth=0}
	bsp:partition(store)
	print("[Building] generator made ", #bsp.leafs, "blocks (BSP leafs)")
	
	-- resolve each "block"
	for z, leaf in ipairs(bsp.leafs) do
		self:block(leaf, spots)
	end
	
	-- place a door in each designated wall
	for i = 1, #self.walls do
		self:doorOnWall(self.walls[i])
	end

	local ux, uy, dx, dy
	if self.data.edge_entrances then
		ux, uy, dx, dy, spots = self:makeStairsSides(lev, old_lev, self.data.edge_entrances, spots)
	else
		ux, uy, dx, dy, spots = self:makeStairsInside(lev, old_lev, spots)
	end

	return ux, uy, dx, dy, spots
end

--- Create the stairs inside the level (inside the margin, if any)
function _M:makeStairsInside(lev, old_lev, spots)
	local m_w, m_h = self.margin_w, self.margin_h
	-- Put down stairs
	local dx, dy
	if lev < self.zone.max_level or self.data.force_last_stair then
		while true do
			dx, dy = rng.range(m_w + 1, self.map.w - m_w - 1), rng.range(m_h + 1, self.map.h - m_h - 1)
			if not self.map:checkEntity(dx, dy, Map.TERRAIN, "block_move") and not self.map.room_map[dx][dy].special then
				self.map(dx, dy, Map.TERRAIN, self:resolve("down"))
				self.map.room_map[dx][dy].special = "exit"
				break
			end
		end
	end

	-- Put up stairs
	local ux, uy
	while true do
		ux, uy = rng.range(m_w + 1, self.map.w - m_w - 1), rng.range(m_h + 1, self.map.h - m_h - 1)
		if not self.map:checkEntity(ux, uy, Map.TERRAIN, "block_move") and not self.map.room_map[ux][uy].special then
			self.map(ux, uy, Map.TERRAIN, self:resolve("up"))
			self.map.room_map[ux][uy].special = "exit"
			break
		end
	end

	return ux, uy, dx, dy, spots
end

--- Create the stairs on the sides (inside the margin, if any)
function _M:makeStairsSides(lev, old_lev, sides, spots)
	local m_w, m_h = self.margin_w, self.margin_h
	-- Put down stairs
	local dx, dy
	if lev < self.zone.max_level or self.data.force_last_stair then
		while true do
			if     sides[2] == 4 then dx, dy = m_w, rng.range(m_h, self.map.h - m_h - 1)
			elseif sides[2] == 6 then dx, dy = self.map.w - m_w - 1, rng.range(m_h, self.map.h - m_h - 1)
			elseif sides[2] == 8 then dx, dy = rng.range(m_w, self.map.w - m_w - 1), m_h
			elseif sides[2] == 2 then dx, dy = rng.range(m_w, self.map.w - m_w - 1), self.map.h- m_h - 1
			end

			if not self.map.room_map[dx][dy].special then
				self.map(dx, dy, Map.TERRAIN, self:resolve("down"))
				self.map.room_map[dx][dy].special = "exit"
				break
			end
		end
	end

	-- Put up stairs
	local ux, uy
	while true do
		if     sides[1] == 4 then ux, uy = m_w, rng.range(m_h, self.map.h - m_h - 1)
		elseif sides[1] == 6 then ux, uy = self.map.w - m_w - 1, rng.range(m_h, self.map.h - m_h - 1)
		elseif sides[1] == 8 then ux, uy = rng.range(m_w, self.map.w - m_w - 1), m_h
		elseif sides[1] == 2 then ux, uy = rng.range(m_w, self.map.w - m_w - 1), self.map.h- m_h - 1
		end
			
		if not self.map.room_map[ux][uy].special then
			self.map(ux, uy, Map.TERRAIN, self:resolve("up"))
			self.map.room_map[ux][uy].special = "exit"
			break
		end
	end

	return ux, uy, dx, dy, spots
end
