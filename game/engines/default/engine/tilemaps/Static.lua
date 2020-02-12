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

--- Generate map-like data from a tmx file
-- @classmod engine.tilemaps.Static
module(..., package.seeall, class.inherit(Tilemap))

function _M:init(file)
	Tilemap.init(self)

	if file:find("%.tmx$") then self.data = self:tmxLoad(file)
	else self.data = self:mapLoad(file) end
	self.data_h = #self.data
	self.data_w = self.data[1] and #self.data[1] or 0
	self.data_size = self:point(self.data_w, self.data_h)
end
