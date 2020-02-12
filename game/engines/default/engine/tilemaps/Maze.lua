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

function _M:init()
	Tilemap.init(self)
end

function _M:makeSimple(w, h, floors, walls, enclosed, allow_position)
	if type(floors) == "string" then floors = {floors} end
	if type(walls) == "string" then walls = {walls} end

	self:setSize(w, h, ' ')

	local lastx, lasty = 0, 0

	local mazemap = self:makeData(w, h, false)

	local do_tile = function(i, j, wall)
		self.data[j][i] = wall and rng.table(walls) or rng.table(floors)
		mazemap[j][i] = wall
		if not wall then
			lastx = math.max(lastx, i)
			lasty = math.max(lasty, j)
		end
	end

	for i = 1, w do for j = 1, h do
		do_tile(i, j, true)
	end end

	local mw, Mw = 1, w
	local mh, Mh = 1, h
	if not enclosed then
		mw, Mw = 0, w + 1
		mh, Mh = 0, h + 1
	end

	local xpos, ypos = mw+1, mh+1
	local moves = {{xpos,ypos}}
	local pickp = rng.range(1,4)
	while #moves > 0 do
		local pickn = #moves - math.floor((rng.range(1,100000)/100001)^pickp * #moves)
		local pick = moves[pickn]
		xpos = pick[1]
		ypos = pick[2]
		local dir = {}
		if xpos+2>mw and xpos+2<Mw and mazemap[ypos][xpos+2] and (not allow_position or allow_position(self:point(xpos+2, ypos))) then
			dir[#dir+1] = 6
		end
		if xpos-2>mw and xpos-2<Mw and mazemap[ypos][xpos-2] and (not allow_position or allow_position(self:point(xpos-2, ypos))) then
			dir[#dir+1] = 4
		end
		if ypos-2>mh and ypos-2<Mh and mazemap[ypos-2][xpos] and (not allow_position or allow_position(self:point(xpos, ypos-2))) then
			dir[#dir+1] = 8
		end
		if ypos+2>mh and ypos+2<Mh and mazemap[ypos+2][xpos] and (not allow_position or allow_position(self:point(xpos, ypos+2))) then
			dir[#dir+1] = 2
		end

		if #dir > 0 then
			local d = dir[rng.range(1, #dir)]
			if d == 4 then
				do_tile(xpos-2, ypos, false)
				do_tile(xpos-1, ypos, false)
				xpos = xpos - 2
			elseif d == 6 then
				do_tile(xpos+2, ypos, false)
				do_tile(xpos+1, ypos, false)
				xpos = xpos + 2
			elseif d == 8 then
				do_tile(xpos, ypos-2, false)
				do_tile(xpos, ypos-1, false)
				ypos = ypos - 2
			elseif d == 2 then
				do_tile(xpos, ypos+2, false)
				do_tile(xpos, ypos+1, false)
				ypos = ypos + 2
			end
			table.insert(moves, {xpos, ypos})
		else
			local back = table.remove(moves,pickn)
		end
	end
	
	return self
end
