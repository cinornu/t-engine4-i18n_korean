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

--- Generate map-like data from a noise generator
-- @classmod engine.tilemaps.Noise
module(..., package.seeall, class.inherit(Tilemap))

function _M:init(noise_kind, hurst, lacunarity, zoom, octave)
	Tilemap.init(self)

	self.noise_kind = noise_kind or "fbm_perlin"
	hurst = hurst or 0.5
	lacunarity = lacunarity or 2
	self.zoom = zoom or 1
	self.octave = octave or 6

	self.noise = core.noise.new(2, self.hurst, self.lacunarity)

	-- self.data_h = #self.data
	-- self.data_w = self.data[1] and #self.data[1] or 0
end

function _M:make(w, h, chars, normalize)
	if normalize == nil then normalize = true end

	self:setSize(w, h, ' ')

	local tmp = {}
	local min, max = 1, 0
	for i = 1, w do for j = 1, h do
		local nv = self.noise[self.noise_kind](self.noise, self.zoom * (i-1) / w, self.zoom * (j-1) / h, self.octave) / 2 + 0.5
		tmp[j] = tmp[j] or {}
		tmp[j][i] = nv
		if nv < min then min = nv end
		if nv > max then max = nv end
	end end

	for i = 1, w do for j = 1, h do
		local nv = tmp[j][i]
		if normalize then nv = (nv - min) / (max - min) end
		local v = math.floor(nv * (#chars - 1))
		if v > #chars then os.crash() end
		self.data[j][i] = chars[v+1]
	end end
	return self
end
