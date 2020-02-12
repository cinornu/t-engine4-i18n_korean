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

--- Generate map-like data from samples using the WaveFunctionCollapse algorithm (in C++)
-- @classmod engine.tilemaps.WaveFunctionCollapse
module(..., package.seeall, class.inherit(Tilemap))

--- Run the algorithm
-- It will produce internal results which this class can then manipulate
-- If async is true in the parameters the generator will run in an asynchronous thread and you must call :waitCompute()
-- before using the results, this allows you to run multiple WFCs for later merging wihtout taking more time (if the user have enoguh CPUs obviously)
function _M:init(t)
	assert(t.mode == "overlapping", "bad WaveFunctionCollapse mode")
	assert(t.size, "WaveFunctionCollapse has no size")

	Tilemap.init(self)

	self:setSize(t.size[1], t.size[2], ' ')

	if t.mode == "overlapping" then
		if type(t.sample) == "string" then
			t.sample = self:collapseToLineFormat(self:tmxLoad(t.sample))
		end
		self:run(t)
	end
end

--- Used internally to parse the results
function _M:parseResult(data)
	print("[WaveFunctionCollapse] compute done", data)
	if not data then return end
	self.data = {}
	for y = 1, #data do
		local x = 1
		self.data[y] = {}
		for c in data[y]:gmatch('.') do
			self.data[y][x] = c
			x = x + 1
		end
	end
end

--- Called by the constructor to actaully start doing stuff
function _M:run(t)
	print("[WaveFunctionCollapse] running with parameter table:")
	table.print(t)
	if not t.async then
		local data = core.generator.wfc.overlapping(t.sample, t.size[1], t.size[2], t.n, t.symmetry, t.periodic_out, t.periodic_in, t.has_foundation)
		self:parseResult(data)
		return false
	else
		self.async_data = core.generator.wfc.asyncOverlapping(t.sample, t.size[1], t.size[2], t.n, t.symmetry, t.periodic_out, t.periodic_in, t.has_foundation)
		return true
	end
end

--- Wait for computation to finish if in async mode, if not it just returns immediately
function _M:waitCompute()
	if not self.async_data then return end
	local data = self.async_data:wait()
	self.async_data = nil

	self:parseResult(data)	
	return self:hasResult()
end

--- Wait for multiple WaveFunctionCollapse at once
-- Static
function _M:waitAll(...)
	local all_have_data = true
	for _, wfcasync in ipairs{...} do
		wfcasync:waitCompute()
		if not wfcasync:hasResult() then all_have_data = false end -- We cant break, we need to wait all the threads to not leave them dangling in the wind
	end
	return all_have_data
end
