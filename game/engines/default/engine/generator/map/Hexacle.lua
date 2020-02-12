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

--- @classmod engine.generator.map.Hexacle
module(..., package.seeall, class.inherit(engine.Generator))

function _M:init(zone, map, level, data)
	engine.Generator.init(self, zone, map, level)
	data.segment_wide_chance = data.segment_wide_chance or 70
	data.nb_segments = data.nb_segments or 8
	data.a_step = 360 / data.nb_segments
	data.nb_layers = data.nb_layers or 4
	data.segment_miss_percent = data.segment_miss_percent or 10
	self.data = data
	self.grid_list = self.zone.grid_list

	if not data.layers then
		data.layers = {}
		for i = 1, data.nb_layers do
			data.layers[i] = {rad=math.floor(map.w / (data.nb_layers+0.5)) * (data.nb_layers - i + 1) / 2}
		end
	end
	for i = 1, data.nb_layers do data.layers[i].id = i end
end

function _M:connectGroups(group, group2, a, a2)
	local l = core.fov.line(a.center_x, a.center_y, a2.center_x, a2.center_y)
	local lx, ly = l:step()
	while lx and ly do
		self.map(lx, ly, Map.TERRAIN, self:resolve('.'))
		lx, ly = l:step()
	end

	local group2 = self.ids_to_groups[a2.layer.id][a2.id]

	group.connected = group.connected or {}
	group.connected[a2.layer.id] = group.connected[a2.layer.id] or {}
	setmetatable(group.connected[a2.layer.id], {__mode="k"})
	group.connected[a2.layer.id][group2] = true

	group2.connected = group2.connected or {}
	group2.connected[a.layer.id] = group2.connected[a.layer.id] or {}
	setmetatable(group2.connected[a.layer.id], {__mode="k"})
	group2.connected[a.layer.id][group] = true
end

function _M:generate(lev, old_lev)
	for i = 0, self.map.w - 1 do for j = 0, self.map.h - 1 do
		self.map(i, j, Map.TERRAIN, self:resolve("#"))
	end end

	local spots = {}

	local cx, cy = math.floor(self.map.w / 2), math.floor(self.map.h / 2)

	local segments = {}
	local a_step = self.data.a_step

	for i = 1, self.data.nb_layers do
		local layer = self.data.layers[i]
		local segment_miss_percent = self.data.segment_miss_percent
		segments[i] = {}

		-- Compute each segment's angles
		local angles = {}
		local pa = -math.rad(a_step / 2)
		local id = 1
		for ad = a_step / 2, 360, a_step do
			local a = math.rad(ad)
			angles[#angles+1] = {a=a, pa=pa, layer=layer, id=id}
			pa = a
			id = id + 1
		end

		-- Randomly carve out some segments
		for a in rng.tableSampleIterator(angles) do
			if not rng.percent(segment_miss_percent) then
				segments[i][a.id] = a
				segment_miss_percent = segment_miss_percent * 2
			else
				segment_miss_percent = self.data.segment_miss_percent
			end
		end
	end

	-- Compute segment groups
	local layer_groups = {}
	self.ids_to_groups = {}
	local all_groups = {}
	for i = 1, self.data.nb_layers do
		local s = segments[i]
		local cur_group = {}
		local groups = {}
		local first_hole = (#s) % self.data.nb_segments
		if first_hole == 0 and s[1] then
			local test = 2
			while s[test] and test <= self.data.nb_segments do test = test + 1 end
			first_hole = test - 1
		end
		for z = first_hole, first_hole + self.data.nb_segments do
			local z = z % self.data.nb_segments
			z = z + 1
			if not s[z] then
				if #cur_group > 0 then
					groups[#groups+1] = cur_group
					all_groups[cur_group] = true
					self.ids_to_groups[i] = self.ids_to_groups[i] or {}
					for _, id in ipairs(cur_group) do self.ids_to_groups[i][id] = cur_group end
				end
				cur_group = {}
			else
				cur_group[#cur_group+1] = z
			end
		end
		layer_groups[i] = groups
	end

	-- Compute all segment's paths
	for _, layer_segments in pairs(segments) do for _, a in pairs(layer_segments) do
		if not self.ids_to_groups[a.layer.id] or not self.ids_to_groups[a.layer.id][a.id] then return self:generate(lev, old_lev) end -- big whoops

		local rad = a.layer.rad
		local sx, sy = cx + math.floor(rad * math.cos(a.a)), cy + math.floor(rad * math.sin(a.a))
		local ex, ey = cx + math.floor(rad * math.cos(a.pa)), cy + math.floor(rad * math.sin(a.pa))
		a.center_x = math.floor((sx + ex) / 2)
		a.center_y = math.floor((sy + ey) / 2)
		local l = core.fov.line(sx, sy, ex, ey)
		local lx, ly = l:step()
		while lx and ly do
			self.map.room_map[lx][ly].segment = '.'
			self.map.room_map[lx][ly].segment_group = self.ids_to_groups[a.layer.id][a.id]
			lx, ly = l:step()
		end
	end end

	-- Link groups with tunnels
	segments.tunnels = {}
	for i, groups in ipairs(layer_groups) do
		local s = segments[i]
		for _, group in ipairs(groups) do
			local possible_tunnels = {}
			for _, id in ipairs(group) do
				local a = s[id]

				for j = i + 1, self.data.nb_layers do
					local s2 = segments[j]
					local a2 = s2[id]
					if a2 then
						possible_tunnels[#possible_tunnels+1] = {a=a, a2=a2}
						break
					end
				end
			end

			if #possible_tunnels > 0 then
				local t = rng.table(possible_tunnels)
				self:connectGroups(group, group2, t.a, t.a2)
			end
		end
	end

	print("====GROUPS====")
	table.print(layer_groups)
	print("====GROUPS====")

	-- Find orphans and try to connect or remove them
	for i, groups in ipairs(layer_groups) do
		local s = segments[i]
		for _, group in ipairs(groups) do if not group.connected or not next(group.connected) then
			local possible_tunnels = {}
			for _, id in ipairs(group) do
				local a = s[id]

				-- This time we dont only look for descending path
				for j = 1, self.data.nb_layers do if i ~= j then
					local s2 = segments[j]
					local a2 = s2[id]
					if a2 then
						local group2 = self.ids_to_groups[a2.layer.id][a2.id]
						-- Only link to things taht are part of the global network
						if group2.connected and next(group2.connected) then
							possible_tunnels[#possible_tunnels+1] = {a=a, a2=a2}
							break
						end
					end
				end end
			end

			-- Connect or die!
			if #possible_tunnels > 0 then
				local t = rng.table(possible_tunnels)
				self:connectGroups(group, group2, t.a, t.a2)
			else
				group.dead = true
			end
		end end
	end	

	-- Flood fill to make SURE we only have one big cavern
	local function check_all(group)
		if not group.connected or not next(group.connected) then return end -- Something wrong, they should all be connected
		if not all_groups[group] then return end -- already seen
		all_groups[group] = nil
		for layer, groups in pairs(group.connected) do
			for group2, _ in pairs(groups) do
				check_all(group2)
			end
		end
	end
	check_all(layer_groups[1][1])
	if next(all_groups) then
		print("One or more groups left unconnected, restarting generator")
		table.print(all_groups)
		return self:generate(lev, old_lev)
	end


	-- Resolve paths into map data
	for i = 0, self.map.w - 1 do for j = 0, self.map.h - 1 do
		if self.map.room_map[i][j].segment and not self.map.room_map[i][j].segment_group.dead then
			self.map(i, j, Map.TERRAIN, self:resolve(self.map.room_map[i][j].segment))
			if rng.percent(self.data.segment_wide_chance) then self.map(i+1, j, Map.TERRAIN, self:resolve(self.map.room_map[i][j].segment)) end
			if rng.percent(self.data.segment_wide_chance) then self.map(i-1, j, Map.TERRAIN, self:resolve(self.map.room_map[i][j].segment)) end
			if rng.percent(self.data.segment_wide_chance) then self.map(i, j+1, Map.TERRAIN, self:resolve(self.map.room_map[i][j].segment)) end
			if rng.percent(self.data.segment_wide_chance) then self.map(i, j-1, Map.TERRAIN, self:resolve(self.map.room_map[i][j].segment)) end
		end
		self.map.room_map[i][j].segment_group = nil
		self.map.room_map[i][j].segment = nil
	end end

	-- Stairs
	return self:makeStairsInside(lev, old_lev, spots)
end

--- Create the stairs inside the level
function _M:makeStairsInside(lev, old_lev, spots)
	-- Put down stairs
	local dx, dy
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

	-- Put up stairs
	local ux, uy
	while true do
		ux, uy = rng.range(1, self.map.w - 1), rng.range(1, self.map.h - 1)
		if not self.map:checkEntity(ux, uy, Map.TERRAIN, "block_move") and not self.map.room_map[ux][uy].special then
			self.map(ux, uy, Map.TERRAIN, self:resolve("up"))
			self.map.room_map[ux][uy].special = "exit"
			break
		end
	end

	return ux, uy, dx, dy, spots
end
