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
require "engine.Generator"
local RoomsLoader = require "engine.generator.map.RoomsLoader"

--- @classmod engine.generator.map.Roomer
module(..., package.seeall, class.inherit(engine.Generator, RoomsLoader))

function _M:init(zone, map, level, data)
	engine.Generator.init(self, zone, map, level)
	self.data = data
	self.data.tunnel_change = self.data.tunnel_change or 30
	self.data.tunnel_random = self.data.tunnel_random or 10
	self.data.door_chance = self.data.door_chance or 50
	self.data.lite_room_chance = self.data.lite_room_chance or 25
	self.grid_list = zone.grid_list

	RoomsLoader.init(self, data)
	self.possible_doors = {}
end

--- Create the stairs inside the level
function _M:makeStairsInside(lev, old_lev, spots)
	-- Put down stairs
	local dx, dy
	if self.forced_down then
		dx, dy = self.forced_down.x, self.forced_down.y
	else
		if lev < self.zone.max_level or self.data.force_last_stair then
			while true do
				dx, dy = rng.range(1, self.map.w - 1), rng.range(1, self.map.h - 1)
				if not self.map:checkEntity(dx, dy, Map.TERRAIN, "block_move") and not self.map.room_map[dx][dy].special then
					self.map(dx, dy, Map.TERRAIN, self:resolve("down"))
					self.map.room_map[dx][dy].special = "exit"
					break
				end
			end
		end
	end

	-- Put up stairs
	local ux, uy
	if self.forced_up then
		ux, uy = self.forced_up.x, self.forced_up.y
	else
		while true do
			ux, uy = rng.range(1, self.map.w - 1), rng.range(1, self.map.h - 1)
			if not self.map:checkEntity(ux, uy, Map.TERRAIN, "block_move") and not self.map.room_map[ux][uy].special then
				self.map(ux, uy, Map.TERRAIN, self:resolve("up"))
				self.map.room_map[ux][uy].special = "exit"
				break
			end
		end
	end

	return ux, uy, dx, dy, spots
end

--- Create the stairs on the sides
function _M:makeStairsSides(lev, old_lev, sides, rooms, spots)
	rooms = table.clone(rooms)
	-- Put down stairs
	local dx, dy
	if self.forced_down then
		dx, dy = self.forced_down.x, self.forced_down.y
	else
		if lev < self.zone.max_level or self.data.force_last_stair then
			while true do
				if     sides[2] == 4 then dx, dy = 0, rng.range(1, self.map.h - 1)
				elseif sides[2] == 6 then dx, dy = self.map.w - 1, rng.range(1, self.map.h - 1)
				elseif sides[2] == 8 then dx, dy = rng.range(1, self.map.w - 1), 0
				elseif sides[2] == 2 then dx, dy = rng.range(1, self.map.w - 1), self.map.h - 1
				end

				if not self.map.room_map[dx][dy].special then
					if not self.data.no_tunnels then
						local i
						repeat
							i = rng.range(1, #rooms)
							if rooms[i].room.no_tunnels then
								print("[Roomer:makeStairsSides] refusing tunnel from exit to room", rooms[i].id)
								table.remove(rooms, i)
							else
								print("[Roomer:makeStairsSides] tunnelling from exit to room", rooms[i].id)
								self:tunnel(dx, dy, rooms[i].cx, rooms[i].cy, rooms[i].id) break
							end
						until #rooms <= 0
					end
					self.map(dx, dy, Map.TERRAIN, self:resolve("down"))
					self.map.room_map[dx][dy].special = "exit"
					break
				end
			end
		end
	end

	-- Put up stairs
	local ux, uy
	if self.forced_up then
		ux, uy = self.forced_up.x, self.forced_up.y
	else
		while true do
			if     sides[1] == 4 then ux, uy = 0, rng.range(1, self.map.h - 1)
			elseif sides[1] == 6 then ux, uy = self.map.w - 1, rng.range(1, self.map.h - 1)
			elseif sides[1] == 8 then ux, uy = rng.range(1, self.map.w - 1), 0
			elseif sides[1] == 2 then ux, uy = rng.range(1, self.map.w - 1), self.map.h - 1
			end
			if not self.map.room_map[ux][uy].special then
				if not self.data.no_tunnels then
					local i
					repeat
						i = rng.range(1, #rooms)
						if rooms[i].room.no_tunnels then
							print("[Roomer:makeStairsSides] refusing tunnel from entrance to room", rooms[i].id)
							table.remove(rooms, i)
						else
							print("[Roomer:makeStairsSides] tunnelling from entrance to room", rooms[i].id)
							self:tunnel(ux, uy, rooms[i].cx, rooms[i].cy, rooms[i].id) break
						end
					until #rooms <= 0
				end
				self.map(ux, uy, Map.TERRAIN, self:resolve("up"))
				self.map.room_map[ux][uy].special = "exit"
				break
			end
		end
	end

	return ux, uy, dx, dy, spots
end

--- Make rooms and connect them with tunnels
function _M:generate(lev, old_lev)
	-- fill in the map
	for i = 0, self.map.w - 1 do for j = 0, self.map.h - 1 do
		self.map(i, j, Map.TERRAIN, self:resolve("#"))
	end end

	local nb_room = util.getval(self.data.nb_rooms or 10)

	local spots = {}
	self.spots = spots

	local rooms = self.map.room_map.rooms
	-- Place rooms we are required to have
	if #self.required_rooms > 0 then
		for i, rroom in ipairs(self.required_rooms) do
			local ok = false
			if type(rroom) == "table" and rroom.chance_room then
				if rng.percent(rroom.chance_room) then rroom = rroom[1] ok = true end
			else ok = true
			end

			if ok then
				local r = self:roomAlloc(rroom, #rooms+1, lev, old_lev)
				if r then nb_room = nb_room - 1
				else self.level.force_recreate = "required_room "..tostring(rroom)
				return end
			end
		end
	end

	-- Place normal, random rooms
	local tries = nb_room * 1.5 -- allow extra attempts for difficult to place rooms
	while tries > 0 and nb_room > 0 do
		local rroom
		while true do
			rroom = self.rooms[rng.range(1, #self.rooms)]
			if type(rroom) == "table" and rroom.chance_room then
				if rng.percent(rroom.chance_room) then rroom = rroom[1] break end
			else
				break
			end
		end
		local r = self:roomAlloc(rroom, #rooms+1, lev, old_lev)
		if r then nb_room = nb_room -1 end
		tries = tries - 1
	end

	-- Tunnels !
	if not self.data.no_tunnels then

		local rs, re, tx, ty = 1, 2
		while rs <= #rooms do
			if rooms[rs].room.no_tunnels then -- don't tunnel to rooms marked no_tunnels
				rs = rs + 1
			else
				re = rs
				repeat
					re = re%#rooms + 1
				until not rooms[re].room.no_tunnels or re <= rs
				if not rooms[re].room.no_tunnels then
--					print("[Roomer]__tunneling: room", rooms[rs].id, "(", rooms[rs].cx, rooms[rs].cy, ") to room", rooms[re].id, "(",rooms[re].cx, rooms[re].cy, ")")
					self:tunnel(rooms[rs].cx, rooms[rs].cy, rooms[re].cx, rooms[re].cy, rooms[re].id)
				end
				if re <= rs then break end
				rs = re
			end
		end
	end
	-- Forced tunnels
	if self.data.force_tunnels then
		for _, t in ipairs(self.data.force_tunnels) do
			local sx, sy, ex, ey
			if type(t[1]) == "string" then
				local i = rng.range(1, #rooms)
				sx, sy = rooms[i].cx, rooms[i].cy
			else
				sx, sy = t[1][1], t[1][2]
			end
			if type(t[2]) == "string" then
				local i = rng.range(1, #rooms)
				ex, ey = rooms[i].cx, rooms[i].cy
			else
				ex, ey = t[2][1], t[2][2]
			end
			self:tunnel(sx, sy, ex, ey, t.id)
		end
	end

	-- Put doors where possible
	self:placeDoors(self.data.door_chance)

	-- Find out "interesting" spots
	for i, r in ipairs(rooms) do
		spots[#spots+1] = {x=rooms[i].cx, y=rooms[i].cy, type="room", subtype=rooms[i].room.name}
	end

	if self.data.edge_entrances then
		return self:makeStairsSides(lev, old_lev, self.data.edge_entrances, rooms, spots)
	else
		return self:makeStairsInside(lev, old_lev, spots)
	end
end
