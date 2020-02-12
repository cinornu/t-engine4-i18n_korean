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

--- Genric generator
-- @classmod engine.Generator
module(..., package.seeall, class.make)

--- Init
-- @param[type=Zone] zone
-- @param[type=Map] map
-- @param[type=Level] level
-- @param[type=table] spots
function _M:init(zone, map, level, spots)
	self.zone = zone
	self.map = map
	self.level = level
	self.spots = spots

	-- Setup the map's room-map
	if not map.room_map then
		map.room_map = {rooms={}, rooms_failed={}}
		for i = 0, map.w - 1 do
			map.room_map[i] = {}
			for j = 0, map.h - 1 do
				map.room_map[i][j] = {}
			end
		end
	end
end

--- Override this in your generator
function _M:generate()
end

--- Resolve 
-- @param[type=string|table|function] c a function or table to resolve
-- @param[type=table] list list to resolve
-- @param[type=boolean] force force the value of c to be used
-- @return[1] nil
-- @return[2] res
function _M:resolve(c, list, force)
	local res = force and c or self.data[c]
	if type(res) == "function" then
		res = res()
	elseif type(res) == "table" then
		res = res[rng.range(1, #res)]
	else
		res = res
	end
	if not res then return end
	res = (list or self.grid_list)[res]
	if not res then return end
	if res.force_clone then
		res = res:clone()
	end
	res:resolve()
	res:resolve(nil, true)
	return res
end

--- Add entity to a room of a map
-- @param i x coord
-- @param j y coord
-- @param[type=string] type the entity type
-- @param[type=Entity] e the entity to add
-- @param[type=table, opt] elists a list of entity lists to use (to override the zone lists)
function _M:roomMapAddEntity(i, j, type, e, elists)
	self.map.room_map[i] = self.map.room_map[i] or {}
	self.map.room_map[i][j] = self.map.room_map[i][j] or {}
	self.map.room_map[i][j].add_entities = self.map.room_map[i][j].add_entities or {}
	local rm = self.map.room_map[i][j].add_entities
	rm[#rm+1] = {type, e, elists = elists}
	e:added() -- we do it here to make sure uniques are uniques
end

--- Remove entities in a room from the map (used if a room has to be removed)
-- @param i x coord
-- @param j y coord
function _M:roomMapRemoveEntities(i, j)
	local ents = self.map.room_map[i] and self.map.room_map[i][j] and self.map.room_map[i][j].add_entities
	if ents then
		for i, e in ipairs(ents) do
			if e[2].removed then e[2]:removed() end -- clears from uniques list
		end
	end
end

-- remove all entities in the room from the level (used if a room was generated but not added to the level)
function _M:roomMapRemoveAllEntities(lev, oldlev)
	for i = 0, self.map.w-1 do for j = 0, self.map.h-1 do
		self:roomMapRemoveEntities(i, j)
	end end
end

-- clean up entities generated if a generator fails (for map generators)
-- overload as needed
function _M:removed(lev, oldlev)
	print("[Generator] removed called for:", self.__CLASSNAME)
	if self.map and self.map.room_map then
		self:roomMapRemoveAllEntities(lev, oldlev)
	end
end

--- Class Gridlist
local Gridlist = class.make{}

--- Create a new gridlist
-- @return Gridlist
function _M:makeGridList()
	return Gridlist.new()
end

--- Gridlist initializer
function Gridlist:init()
	self.list = {}
end

--- Add a new entry to gridlist
-- @number x x coordinate
-- @number y y coordinate
-- @param data
function Gridlist:add(x, y, data)
	if data == nil then data = true end
	if not self.list[x] then self.list[x] = {} end
	self.list[x][y] = data
end

--- Remove entry from gridlist
-- @number x x coordinate
-- @number y y coordinate
function Gridlist:remove(x, y)
	if not self.list[x] then return end
	self.list[x][y] = nil
	if not next(self.list[x]) then self.list[x] = nil end
end

--- Check if gridlist has anything at specified coordinates
-- @number x x coordinate
-- @number y y coordinate
function Gridlist:has(x, y)
	if not self.list[x] then return end
	return self.list[x][y]
end

--- Turn the gridlist into an easily parsed table
-- @return {{x, y, data}, ...}
function Gridlist:toList()
	local list = {}
	for x, yy in pairs(self.list) do for y, data in pairs(yy) do
		list[#list+1] = {x=x, y=y, data=data}
	end end 
	return list
end

--- How many items does our gridlist have??
-- @return number
function Gridlist:count()
	local nb = 0
	for x, yy in pairs(self.list) do for y, data in pairs(yy) do
		nb = nb + 1
	end end 
	return nb
end
