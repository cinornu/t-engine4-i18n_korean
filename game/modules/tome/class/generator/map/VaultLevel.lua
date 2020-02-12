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

require "engine.class"
local Map = require "engine.Map"
require "engine.Generator"
local RoomsLoader = require "engine.generator.map.RoomsLoader"
--- @classmod engine.generator.map.Roomer
module(..., package.seeall, class.inherit(engine.Generator, RoomsLoader))

-- Generate a simple level containing a single room ("greater_vault")
-- special grids:
--		subvault_wall = grid to use to fill out the level outside of the vault
--		subvault_up = grid for stairs back up
--		entry_path_length = length of tunnel from entrance to vault
function _M:init(zone, map, level, data)
	engine.Generator.init(self, zone, map, level)
	data.rooms = {"greater_vault"}
	data.required_rooms = nil
	self.data = data
	self.grid_list = zone.grid_list
	RoomsLoader.init(self, data)
end

function _M:generate(lev, old_lev)
	self.spots = {}
	local tries, room = 5
	repeat
		tries = tries - 1
		room = self:roomGen(self.rooms[1], 1, lev, old_lev)
	until room or tries <= 0
	local sx, sy, ex, ey = 1, 2, 1, 2
	if not room then
		print("[VaultLevel] has no vault")
		self.level.force_recreate = "no vault"
	else
		print("[VaultLevel] using room:", room and room.name)
		local entry_path_length = util.getval(self.data.entry_path_length) or math.round((self.map.w + self.map.h)/20+1)
		local rx, ry = math.ceil((self.map.w - room.w)/2), math.ceil((self.map.h - room.h)/2)
		local ret = self:roomPlace(room, 1, rx, ry)
		local rm
		for i = 0, self.map.w - 1 do for j = 0, self.map.h - 1 do
			rm = self.map.room_map[i][j]
			if not (rm.room or rm.special or rm.can_open) then
				local g
				if self.level.data.subvaults_surroundings then g = self:resolve(self.level.data.subvaults_surroundings, nil, true)
				else g = self:resolve("subvault_wall") end
				self.map(i, j, Map.TERRAIN, g)
			end
		end end
		-- search for ways into the vault, always including the vault connection point
		local possible_entrances_backup = {{x=ret.cx, y=ret.cy}}
		local possible_entrances = {}
		for i = rx, rx + room.w -1 do
			local y1, y2 = ry, ry + room.h - 1
			if self.map:checkEntity(i, y1, Map.TERRAIN, "is_door") then possible_entrances[#possible_entrances+1] = {x=i, y=y1, sx=i, sy=util.bound(y1-entry_path_length, 0, self.map.h-1)} end
			if self.map:checkEntity(i, y2, Map.TERRAIN, "is_door") then possible_entrances[#possible_entrances+1] = {x=i, y=y2, sx=i, sy=util.bound(y2+entry_path_length, 0, self.map.h-1)} end
		end
		for j = ry, ry + room.h - 1 do
			local x1, x2 = rx, rx + room.w - 1
			if self.map:checkEntity(x1, j, Map.TERRAIN, "is_door") then possible_entrances[#possible_entrances+1] = {x=x1, y=j, sx=util.bound(x1-entry_path_length, 0, self.map.w-1), sy=j} end
			if self.map:checkEntity(x2, j, Map.TERRAIN, "is_door") then possible_entrances[#possible_entrances+1] = {x=x2, y=j, sx=util.bound(x2+entry_path_length, 0, self.map.w-1), sy=j} end
		end
		if #possible_entrances > 0 then
			local e = rng.table(possible_entrances)
			sx, sy = e.sx, e.sy
			ex, ey = e.x, e.y
		elseif #possible_entrances_backup > 0 then
			local e = rng.table(possible_entrances_backup)
			ex, ey = e.x, e.y
			-- vault connection point: connect to a (nearest) non-vault grid
			print("[VaultLevel] generating level start point from vault connection at", ex, ey)
			-- start at center of room and pick a random direction
			sx, sy = math.floor(rx+(room.w-1)/2), math.floor(ry+(room.h-1)/2)
			local dir, xd, yd = util.getDir(ex, ey, sx+rng.normal(0, 1), sy+rng.normal(0, 1))
			if dir == 5 then dir = rng.table(util.primaryDirs()) end
			local rm
			local steps = math.max(room.w, room.h) + 2*(room.border or 0) + 1
			repeat
				steps = steps - 1
				rm = self.map.room_map[sx][sy]
				sx, sy = util.coordAddDir(sx, sy, dir)
				if not (rm.room or rm.border) then entry_path_length = entry_path_length - 1 end
			until steps <= 0 or entry_path_length <= 0 or not self.map:isBound(sx, sy)
			sx, sy = util.bound(sx, 0, self.map.w-1), util.bound(sy, 0, self.map.h-1)
		else
			ex, ey = ret.cx, ret.cy
		end
		-- create a path from the level start to the vault
		print("[VaultLevel] tunnelling from", sx, sy, "to", ex, ey)
		self:tunnel(sx, sy, ex, ey, 1)
	end
	-- create stairs up and place the player at the starting point
	self.map(sx, sy, Map.TERRAIN, self:resolve("subvault_up"))

	return sx, sy, ex, ey, spots
end
