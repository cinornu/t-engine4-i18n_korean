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

function _M:init(roughness, start)
	Tilemap.init(self)
	self.roughness = roughness or 1.2
	self.start = start or {}
	for k, e in pairs(start) do start[k] = e * HMap.max end
end

function _M:make(w, h, chars, normalize)
	if normalize == nil then normalize = true end

	self:setSize(w, h, ' ')

	local hmap = HMap.new(w, h, self.roughness, self.start)
	hmap:generate()

	local tmp = {}
	local min, max = 1, 0
	for j = 1, h do for i = 1, w do
		local nv = hmap.hmap[i][j] / hmap.max

		tmp[j] = tmp[j] or {}
		tmp[j][i] = nv
		if nv < min then min = nv end
		if nv > max then max = nv end
	end end

	for j = 1, h do for i = 1, w do
		local nv = tmp[j][i]
		if normalize then nv = (nv - min) / (max - min) end

		local c = util.bound(math.floor(nv * (#chars - 1)) + 1, 1, #chars)
		self.data[j][i] = chars[c]
	end end
	
	return self
end
