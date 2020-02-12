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

local Particles = require "engine.Particles"

--- Handles a particles system
-- Used by engine.Map
-- @classmod engine.Particles
module(..., package.seeall, class.inherit(Particles))

local Custom = class.make{}

--- Make a particle emitter
function _M:init(fct)
	self.args = {}
	self.def = "custom"
	self.radius = 1
	self.shader = nil
	self.base_size = 64
	self.ps = Custom.new(fct)

	self:loaded()
end

--- Serialization
function _M:save()
	return class.save(self, {
		gl_texture = true,
		_shader = true,
	})
end

-- Fake, to comply with particle methods
function _M:update()
end

function _M:loaded()
end

function _M:setSub(def, radius, args, shader)
	self.subps = Particles.new(def, radius, args, shader)
	self.ps:setSub(self.subps.ps)
end

function Custom:init(fct)
	self.fct = fct
	self.alive = true
	self.subs = {}
end

function Custom:toScreen(x, y, show, zoom)
	if not self.fct then self.alive = false return end
	self.alive = self.fct(x, y, show, zoom)
end

function Custom:isAlive()
	return self.alive
end

function Custom:setSub(sub)
	self.subs[#self.subs+1] = sub
end

function Custom:shift()
	-- nothing
end

function Custom:die()
	self.alive = false
	self.fct = nil
end
