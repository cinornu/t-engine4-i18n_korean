-- ToME - Tales of Maj'Eyal
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
local Dialog = require "engine.ui.Dialog"
local TreeList = require "engine.ui.TreeList"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local GetText = require "engine.dialogs.GetText"

module(..., package.seeall, class.inherit(Dialog))

-- @param title The title string.
-- @param options A list of options.
function _M:init(options, title, width, height)
	self.options = {}

	for _, option in ipairs(options or {}) do
		self:addOption(option)
	end
end

function _M:initialize()
	Dialog.init(self, name, width or 800, height or (game.h * 0.9))

	self.vsep = Separator.new {
		dir = "horizontal",
		size = self.ih - 10}
	self.c_tree = TreeList.new {
		width = math.floor((self.iw - self.vsep.w) / 2),
		height = self.ih,
		sel_by_col = true, scrollbar = true,
		columns = {
			{width = 60, display_prop = "name"},
			{width = 40, display_prop = "status"}},
		fct = function(item, sel, v) self:activateItem(item, sel, v) end,
		select = function(item, sel) self:highlightItem(item, sel) end,
		tree = self.options}
	self.c_desc = Textzone.new {
		width = math.floor((self.iw - self.vsep.w) / 2),
		height = self.ih,
		text = ""}

	self:loadUI {
		{left = 0, top = 0, ui = self.c_tree},
		{hcenter = 0, top = 5, ui = self.vsep},
		{right = 0, top = 0, ui = self.c_desc}}
	self:setupUI()

	self:setFocus(self.c_tree)

	self.key:addBinds {
		EXIT = function() game:unregisterDialog(self) end}
end

function _M:activateItem(item)
end

function _M:highlightItem(item)
	if item and self.uis[3] then
		self.uis[3].ui = Textzone.new {
			width = self.c_desc.w,
			height = self.c_desc.h,
			text = item.desc}
		self.c_desc.text = item.text
	end
end

--- Retrieve the table for an option or group.
-- @param path A list of strings.
function _M:getOptionDef(path)
	local node = {nodes = self.options}
	for _, id in ipairs(path) do
		local child = table.get(node, 'nodes', id)
		if not child then
			child = table.getTable(node, 'nodes', id) -- make child table
			table.insert(node.nodes, child) -- keep track of children order
		end
		node = child
	end
	return node
end

function _M:addOption(t)
	if "group" == t.type then self:addGroup(t.path, t.name, t.desc)
	elseif "boolean" == t.type then self:addBoolean(t)
	elseif "cycling" == t.type then self:addCycling(t)
	elseif "numeric" == t.type then self:addNumeric(t)
	end
end

--- Defines an option group.
-- @param path A list of strings.
-- @param name The displayed name.
-- @param desc The description text.
function _M:addGroup(path, name, desc)
	desc = desc or ''
	local group = self:getOptionDef(path)
	group.name = name
	group.status = ""
	group.desc = desc
	group.shown = true
end

--- Adds a boolean option.
function _M:addBoolean(t)
	local this = self
	local option = self:getOptionDef(t.path)
	local on_value = t.on_value or "enabled"
	local off_value = t.off_value or "disabled"
	if config.settings.tome[t.id] == nil then config.settings.tome[t.id] = t.default end
	option.shown = true
	option.name = string.toTString("#GOLD##{bold}#"..t.name.."#{normal}#")
	option.desc = t.desc
	option.status = function(item)
		return tostring(config.settings.tome[t.id] and on_value or off_value)
	end
	option.fct = function(item)
		config.settings.tome[t.id] = not config.settings.tome[t.id]
		local name = "tome."..(t.id)
		game:saveSettings(name, ("%s = %s\n"):format(name, tostring(config.settings.tome[t.id])))
		this.c_tree:drawItem(item)
		if t.action then t.action(config.settings.tome[t.id]) end
	end
end

--- Adds a cycling option.
function _M:addCycling(t)
	local this = self

	-- Create lookup table for next value in sequence.
	local values = t.values
	local next_value = {}
	for i = 1, #values - 1 do
		next_value[values[i]] = values[i+1]
	end
	next_value[values[#values]] = values[1]

	-- Default to first value.
	if config.settings.tome[t.id] == nil then
		config.settings.tome[t.id] = t.default or values[1]
	end

	-- Create the option.
	local option = self:getOptionDef(t.path)
	option.shown = true
	option.name = string.toTString("#GOLD##{bold}#"..t.name.."#{normal}#")
	option.desc = t.desc
	option.status = function(item)
		return tostring(config.settings.tome[t.id])
	end
	option.fct = function(item)
		config.settings.tome[t.id] = next_value[config.settings.tome[t.id]]
		if config.settings.tome[t.id] == nil then
			config.settings.tome[t.id] = t.default or values[1]
		end
		local name = 'tome.'..(t.id)
		game:saveSettings(name, ('%s = "%s"\n'):format(name, tostring(config.settings.tome[t.id])))
		this.c_tree:drawItem(item)
		if t.action then t.action(config.settings.tome[t.id]) end
	end
end

function _M:addNumeric(t)
	local this = self

	-- Set the default value.
	if config.settings.tome[t.id] == nil then config.settings.tome[t.id] = t.default end

	-- Create the option.
	local option = self:getOptionDef(t.path)
	option.shown = true
	option.name = string.toTString("#GOLD##{bold}#"..t.name.."#{normal}#")
	option.desc = t.desc
	option.status = function(item)
		return tostring(config.settings.tome[t.id])
	end
	option.fct = function(item)
		local assign = function(value)
			config.settings.tome[t.id] = util.bound(value, t.min, t.max)
			local name = 'tome.'..(t.id)
			game:saveSettings(name, ('%s = %s\n'):format(name, tostring(config.settings.tome[t.id])))
			this.c_tree:drawItem(item)
			if t.action then t.action(config.settings.tome[t.id]) end
		end
		game:registerDialog(
			require('engine.dialogs.GetQuantity').new(
				t.display_name or t.name,
				('[%d-%d]'):format(t.min, t.max),
				config.settings.tome[t.id],
				max, assign, min))
	end
end
