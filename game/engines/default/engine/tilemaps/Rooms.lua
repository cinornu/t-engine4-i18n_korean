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
local RoomsLoader = require "engine.generator.map.RoomsLoader"

--- Generate map-like data from a heightmap fractal
-- @classmod engine.tilemaps.Heightmap
module(..., package.seeall, class.inherit(Tilemap))

local RoomInstance = class.inherit(Tilemap){}

function _M:init(mapscript, rooms_list)
	self.mapscript = mapscript
	if type(rooms_list) == "string" then rooms_list = {rooms_list} end

	self.rooms = {}
	for _, file in ipairs(rooms_list) do
		table.insert(self.rooms, mapscript:loadRoom(file))
	end

	self.room_next_id = 1
end

function _M:generateRoom(temp_symbol, account_for_border)
	local mapscript = self.mapscript
	local roomdef = rng.table(self.rooms)
	local id = tostring(self)..":"..self.room_next_id
	local room = mapscript:roomGen(roomdef, id, mapscript.lev, mapscript.old_lev)
	if not room then
		print("Tilemap.Rooms failed to generate room")
		return nil
	end

	if account_for_border == nil then account_for_border = false end

	temp_symbol = temp_symbol or {wall='⍓', floor='⎕'}
	
	local tm = RoomInstance.new({room.w - (account_for_border and 2 or 0), room.h - (account_for_border and 2 or 0)}, temp_symbol and temp_symbol.wall)
	room.temp_symbol = temp_symbol
	tm.mapscript = mapscript
	tm.room_data = room
	tm.room_id = id

	self.room_next_id = self.room_next_id + 1
	return tm
end

function RoomInstance:build()
	local mapscript = self.mapscript
	local room = self.room_data
	local id = self.room_id

	if account_for_border == nil then account_for_border = false end

	local map = mapscript:makeTemporaryMap(room.w, room.h, function(map)
		mapscript.dont_add_vault_check = true
		mapscript:roomPlace(room, id, 0, 0)
		mapscript.dont_add_vault_check = nil
	end)
	mapscript.maps_registers[id] = map
	mapscript.maps_positions[id] = account_for_border and self:point(0, 0) or self:point(1, 1)

	local exits = { openables={}, doors={} }

	local function checkexits(i, j, dir)
		if map.room_map[i][j].can_open then
			exits.openables[#exits.openables+1] = self:point(i+1, j+1)
		end
		if map(i, j, map.TERRAIN) and map(i, j, map.TERRAIN).door_opened then
			-- Doors "position" is the actual tile right beside it, not the door itself as we dont want to delete the door
			local dx, dy = util.coordAddDir(i+1, j+1, dir)
			exits.doors[#exits.doors+1] = self:point(dx, dy)
		end
	end
	self.static_map = map
	self.exits = exits

	for i = 0, map.w - 1 do
		checkexits(i, 0, 8)
		checkexits(i, map.h - 1, 2)
	end
	for j = 0, map.h - 1 do
		checkexits(0, j, 4)
		checkexits(map.w - 1, j, 6)
	end

	-- Mark floor & walls
	for i = 0, map.w - 1 do	for j = 0, map.h - 1 do
		if not map:checkEntity(i, j, map.TERRAIN, 'block_move') then
			self.data[j+1][i+1] = room.temp_symbol.floor
		end
	end end

	return self
end

--- Not used, so we remove all entities
function RoomInstance:discard()
	for i = 0, self.static_map.w - 1 do for j = 0, self.static_map.h - 1 do
		local z = i + j * self.static_map.w
		if self.static_map.map[z] then
			for _, e in pairs(self.static_map.map[z]) do
				e:removed()
			end
		end
	end end
end

function RoomInstance:mergedAt(x, y)
	Tilemap.mergedAt(self, x, y)

	local d = self:point(x - 1, y - 1)

	self.mapscript.maps_positions[self.room_id] = self.mapscript.maps_positions[self.room_id] + d
	for _, open in pairs(self.exits.openables) do open.x, open.y = open.x + d.x, open.y + d.y end
	for _, door in pairs(self.exits.doors) do door.x, door.y = door.x + d.x, door.y + d.y end
end

function RoomInstance:findExits(pos, kind)
	local list = {}
	if not kind or kind == "openable" then
		for _, open in pairs(self.exits.openables) do
			local dist = core.fov.distance(pos.x, pos.y, open.x, open.y)
			table.insert(list, {dist = dist, pos = open, kind = "open"})			
		end
	end
	if not kind or kind == "door" then
		for _, door in pairs(self.exits.doors) do
			local dist = core.fov.distance(pos.x, pos.y, door.x, door.y)
			table.insert(list, {dist = dist, pos = door, kind = "door"})			
		end
	end
	table.sort(list, "dist")
	return list
end



function _M:flip(axis) error("Cannot use :flip() on a Room tilemap") end
function _M:rotate(angle) error("Cannot use :rotate() on a Room tilemap") end
function _M:scale(sx, sy) error("Cannot use :scale() on a Room tilemap") end
function RoomInstance:flip(axis) error("Cannot use :flip() on a Room tilemap") end
function RoomInstance:rotate(angle) error("Cannot use :rotate() on a Room tilemap") end
function RoomInstance:scale(sx, sy) error("Cannot use :scale() on a Room tilemap") end
