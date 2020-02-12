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

--- Define and load fonts
-- @classmod engine.FontPackage
module(..., package.seeall, class.make)

--- All of the packages
local packages = {}

--- Loads lore
-- @string file
-- @param env
function _M:loadDefinition(file, env)
	local f, err = loadfile(file)
	if not f and err then error(err) end
	setfenv(f, setmetatable(env or {
		newPackage = function(t) self.new(t) end,
		load = function(f) self:loadDefinition(f, getfenv(2)) end
	}, {__index=_G}))
	f()
end

--- Default font style, "normal"
local cur_size = "normal"
--- @string size "normal", "bold", etc
function _M:setDefaultSize(size)
	cur_size = size
end

--- Default font id, "default"
local cur_id = "default"
--- Set default font to use
-- @string id if it can't find it, then the font will be "basic"
function _M:setDefaultId(id)
	if not packages[id] then id = "basic" end
	cur_id = id
end

--- Resolves a font
-- @string name
-- @string orname
-- @return font object
-- @return size
function _M:resolveFont(name, orname)
	local font = packages[cur_id]
	local size = cur_size
	if not font[name] then name = orname end
	if not font[name] then name = "default" end
	if not font[name][size] then size = "normal" end
	print(font[name], size)
	return font[name], size
end

--- Fetches the actual font by calling `resolveFont`() internally
-- @string name
-- @string orname
-- @return font
-- @return size
function _M:getFont(name, orname)
	local font, size = self:resolveFont(name, orname)
	return font.font, math.ceil(font[size] * config.settings.font_scale / 100)
end

--- Get by name. 
-- @string name
-- @param[type=?boolean] force make a font bold no matter what
function _M:get(name, force)
	local font, size = self:resolveFont(name)
	local f = core.display.newFont(font.font, math.ceil(font[size] * config.settings.font_scale / 100), font.bold or force)
	if font.bold then f:setStyle("bold") end
	return f
end

--- List all fonts
function _M:list()
	local list = {}
	for _, f in pairs(packages) do list[#list+1] = f end
	table.sort(list, function(a, b) return a.weight > b.weight end)
	return list
end

--- Initialize font package
-- @param[type=table] t
-- @string t.id package id
-- @string t.default default font
function _M:init(t)
	assert(t.id, "no font package id")
	assert(t.default, "no font package default")

	for k, e in pairs(t) do self[k] = e end

	packages[t.id] = self
end
