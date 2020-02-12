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

--- Defines damage types used by actors
-- @classmod engine.DamageType
module(..., package.seeall, class.make)

_M.dam_def = {}

--- Default damage projector
-- needs to be overridden, as the default functionality just prints to the console
-- @param[type=Actor] src what is projecting
-- @int x x coordinate
-- @int y y coordinate
-- @param type type of damage
-- @int dam amount of damage
function _M.defaultProject(src, x, y, type, dam)
	print("implement a projector!")
end

--- Defines new damage type
-- @static
-- @string file loads a definition from a lua file
function _M:loadDefinition(file)
	local f, err = loadfile(file)
	if not f and err then error(err) end
	setfenv(f, setmetatable({
		DamageType = _M,
		Map = require("engine.Map"),
		setDefaultProjector = function(fct) self.defaultProjector = fct end,
		newDamageType = function(t) self:newDamageType(t) end,
	}, {__index=_G}))
	f()
end

--- Defines one ability type(group)
-- @static
-- @param[type=table] t
function _M:newDamageType(t)
	assert(t.name, "no ability type name")
	assert(t.type, "no ability type type")
	t.type = t.type:upper()
	t.projector = t.projector or self.defaultProjector

	if not t.color and type(t.text_color) == "string" then
		local ts = t.text_color:toTString()
		if type(ts[2]) == "table" and ts[2][1] == "color" then
			if type(ts[2][2]) == "string" then
				t.color = colors[ts[2][2]]
			elseif type(ts[2][2]) == "string" then
				t.color = {r=ts[2][2], g=ts[2][3], b=ts[2][4]}
			end
		end
	end

	self.dam_def[t.type] = t
	self[t.type] = t.type
end

--- Fetches the damage type by the string id  
-- throws an assert
-- @string id
-- @return damage type
function _M:get(id)
	assert(_M.dam_def[id], "damage type "..tostring(id).." used but undefined")
	return _M.dam_def[id]
end

--- Checks if our damage type exists
-- @string id
-- @return[1] nil
-- @return[2] damage type
function _M:exists(id)
	return _M.dam_def[id]
end

--- Allows an actor to project for another actor
-- @param[type=Actor] src
-- @param[type=Actor] v
function _M:projectingFor(src, v)
	src.__projecting_for = v
end

--- Who is this actor projecting for?
-- @param[type=Actor] src
-- @return `Actor`
function _M:getProjectingFor(src)
	return src.__projecting_for
end
