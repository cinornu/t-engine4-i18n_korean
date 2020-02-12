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
local HMap = require "engine.Heightmap"

--- Generate map-like data from a heightmap fractal
-- @classmod engine.tilemaps.Heightmap
module(..., package.seeall, class.inherit(Tilemap))

function _M:init(source_map, offset, w, h)
	Tilemap.init(self)
	self.unmergable = true
	self.source_map = source_map
	self.merged_pos = offset
	self:setSize(w, h)

	-- Make data an actual proxy
	self.data = {}

	local proxy_t = {
		__newindex = function(ys, x, v)
			if self.mask and self.mask[ys.__y] and not self.mask[ys.__y][x] then return end -- Woops, not allowed!
			local pos = self.merged_pos + self:point(x, ys.__y) - 1 + self.source_map.merged_pos - 1
			self.source_map:put(pos, v)
		end,
		__index = function(ys, x)
			local pos = self.merged_pos + self:point(x, ys.__y) - 1 + self.source_map.merged_pos - 1
			return self.source_map.data[pos.y][pos.x]
		end,
	}

	for j = 1, h do
		self.data[j] = setmetatable({__y=j}, proxy_t)
	end
end

function _M:maskOtherPoints(list, source_coords)
	if not self.mask then self.mask = self:makeData(self.data_w, self.data_h, false) end
	for _, p in ipairs(list) do
		if source_coords then
			local np = p - self.merged_pos + 1
			self.mask[np.y][np.x] = true
		else
			self.mask[p.y][p.x] = true
		end
	end
end
