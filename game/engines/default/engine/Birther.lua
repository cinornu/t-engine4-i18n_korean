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
local Dialog = require "engine.ui.Dialog"
local ListColumns = require "engine.ui.ListColumns"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"

--- Allows you to create characters using a GUI
-- @classmod engine.Birther
module(..., package.seeall, class.inherit(Dialog))

--- Where descriptors are stored
-- @static
_M.birth_descriptor_def = {}
--- If a descriptor is automatic it gets stored here
-- @static
_M.birth_auto = {}
--- Names for the steps
-- @static
_M.step_names = {}

--- Defines birth descriptors from specified lua file
-- @static
-- @string file the lua file containing the descriptor
function _M:loadDefinition(file, env)
	env = env or setmetatable({
		ActorTalents = require("engine.interface.ActorTalents"),
		newBirthDescriptor = function(t) self:newBirthDescriptor(t) end,
		getBirthDescriptor = function(type, name) return self:getBirthDescriptor(type, name) end,
		setAuto = function(type, v) self.birth_auto[type] = v end,
		setStepNames = function(names) self.step_names = names end,
		load = function(f) self:loadDefinition(f, env) end,
		Birther = self,
	}, {__index=getfenv(2)})
	local f, err = util.loadfilemods(file, env)
	if not f and err then error(err) os.exit() end
	local ok, err = pcall(f)
	if not ok and err then error(err) end
end

--- Defines one birth descriptor
-- @{birth_descriptor.lua|Example Birth Descriptor}
-- @static
-- @param[type=table] t the birth descriptor
function _M:newBirthDescriptor(t)
	assert(t.name, "no birth name")
	assert(t.type, "no birth type")
	t.short_name = t.short_name or t.name
	t.short_name = t.short_name:upper():gsub("[ ]", "_")
	t.display_name = t.display_name or _t(t.name, "birth descriptor name")
	assert(t.desc, "no birth description")
	if type(t.desc) == "table" then t.desc = table.concat(t.desc, "\n") end
	t.desc = t.desc:gsub("\n\t+", "\n")
	t.descriptor_choices = t.descriptor_choices or {}

	table.insert(self.birth_descriptor_def, t)
	t.id = #self.birth_descriptor_def
	self.birth_descriptor_def[t.type] = self.birth_descriptor_def[t.type] or {}
	self.birth_descriptor_def[t.type][t.name] = t
	table.insert(self.birth_descriptor_def[t.type], t)
end

--- Get one birth descriptor
-- @static
-- @string type type of descriptor
-- @string name the name of the descriptor
function _M:getBirthDescriptor(type, name)
	if not self.birth_descriptor_def[type] then return nil end
	return self.birth_descriptor_def[type][name]
end


--- Instantiates a birther for the given actor
-- @string title dialog title
-- @param[type=Actor] actor the actor we're birthing
-- @param[type=table] order the order to display birth descriptors in, referenced by names
-- @func[opt] at_end function to call when finished birthing
-- @param[type=?boolean] quickbirth do we `quickBirth`??
-- @int[opt=600] w width of dialog
-- @int[opt=400] h height of dialog
function _M:init(title, actor, order, at_end, quickbirth, w, h)
	self.quickbirth = quickbirth
	self.actor = actor
	self.order = order
	if order.get_name then
		self.at_end = function()
			game:registerDialog(require('engine.dialogs.GetText').new(_t"Enter your character's name", _t"Name", 2, 25, function(text)
				game:setPlayerName(text)
				at_end()
			end, function()
				util.showMainMenu()
			end))
		end
	else
		self.at_end = at_end
	end

	Dialog.init(self, title and title or ("Character Creation: %s"):tformat(actor:getName()), w or 600, h or 400)

	self.descriptors = {}
	self.descriptors_by_type = {}

	self.c_tut = Textzone.new{width=math.floor(self.iw / 2 - 10), height=1, auto_height=true, no_color_bleed=true, text=_t[[
Keyboard: #00FF00#up key/down key#FFFFFF# to select an option; #00FF00#Enter#FFFFFF# to accept; #00FF00#Backspace#FFFFFF# to go back.
Mouse: #00FF00#Left click#FFFFFF# to accept; #00FF00#right click#FFFFFF# to go back.
]]}

	self.c_random = Button.new{text=_t"Random", width=math.floor(self.iw / 2 - 40), fct=function() self:randomSelect() end}
	self.c_desc = Textzone.new{width=math.floor(self.iw / 2 - 10), height=self.ih - self.c_tut.h - 20, scrollbar=true, no_color_bleed=true, text=_t""}

	self.c_list = ListColumns.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 10 - self.c_random.h, scrollbar=true, all_clicks=true, columns={
		{name=_t"", width=8, display_prop="char"},
		{name=_t"", width=92, display_prop="display_name"},
	}, list={}, fct=function(item, sel, button, event)
		self.sel = sel
		if (event == "key" or event == "button") and button == "left" then self:next()
		elseif event == "button" and button == "right" then self:prev()
		end
	end, select=function(item, sel) self.sel = sel self:select(item) end}

	self.cur_order = 1
	self.sel = 1

	self:loadUI{
		{left=0, top=0, ui=self.c_list},

		{right=0, top=self.c_tut.h + 20, ui=self.c_desc},
		{right=0, top=0, ui=self.c_tut},

		{left=0, bottom=0, ui=self.c_random},
		{hcenter=0, top=5, ui=Separator.new{dir="horizontal", size=self.ih - 10}},
	}
	self:setFocus(self.c_list)
	self:setupUI()
--	self.c_list:selectColumn(2)

	self.key:addCommands{
		_BACKSPACE = function() self:prev() end,
		__TEXTINPUT = function(c)
			if self.list and self.list.chars[c] then
				self.c_list.sel = self.list.chars[c]
				self.sel = self.list.chars[c]
				self:next()
			end
		end,
	}
end

--- Automatically called after using @{engine.Game.registerDialog} for this class
function _M:on_register()
	self:next()
	self:select(self.list[self.c_list.sel])

	self.key:unicodeInput(true)

	if __module_extra_info.no_quickbirth then return end
	if self.quickbirth then
		if __module_extra_info.auto_quickbirth then
			self.do_quickbirth = true
			self:quickBirth()
		else
			self:yesnoPopup(_t"Quick Birth", _t"Do you want to recreate the same character?", function(ret)
				if ret then
					self.do_quickbirth = true
					self:quickBirth()
				end
			end, _t"Recreate", _t"New character")
		end
	end
end

--- Quickly birth the actor using predefined settings.
-- 
function _M:quickBirth()
	if not self.do_quickbirth then return end
	-- Abort quickbirth if stage not found
	if not self.quickbirth[self.current_type] then self.do_quickbirth = false end

	-- Find the correct descriptor
	for i, d in ipairs(self.list) do
		if self.quickbirth[self.current_type] == d.name then
			print("[BIRTHER QUICK] using", d.name, "for", self.current_type)
			self.sel = i
			self:next()
			return true
		end
	end

	-- Abort if not found
	self.do_quickbirth = false
end

--- Populates the dialog with all of the choices for the specified type
-- 
-- @string type birth descriptor type
function _M:selectType(type)
	local default = 1
	self.list = {}
	-- Make up the list
	print("[BIRTHER] selecting type", type)
	for i, d in ipairs(self.birth_descriptor_def[type]) do
		local allowed = true
		print("[BIRTHER] checking allowance for ", d.name)
		for j, od in ipairs(self.descriptors) do
			if od.descriptor_choices and od.descriptor_choices[type] then
				local what = util.getval(od.descriptor_choices[type][d.name], self) or util.getval(od.descriptor_choices[type].__ALL__, self)
				if what and what == "allow" then
					allowed = true
				elseif what and (what == "never" or what == "disallow") then
					allowed = false
				elseif what and what == "forbid" then
					allowed = nil
				end
				print("[BIRTHER] test against ", od.name, "=>", what, allowed)
				if allowed == nil then break end
			end
		end

		-- Check it is allowed
		if allowed then
			table.insert(self.list, d)
			if d.selection_default then default = #self.list end
		end
	end
	self.current_type = type
	self:updateList()
	self.c_list.sel = default
	self.c_list:onSelect()
end

--- Used internally to transform indices into letters for column selection
-- 
-- @int letter
function _M:makeKey(letter)
	if letter >= 26 then
		return string.char(string.byte('A') + letter - 26)
	else
		return string.char(string.byte('a') + letter)
	end
end

--- Called after `selectType` to actually put the generated descriptor values into the list 
-- 
function _M:updateList()
	self.list.chars = {}
	for i, item in ipairs(self.list) do
		item.zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=item.desc}
		item.char = self:makeKey(i-1)
		self.list.chars[item.char] = i
	end
	self.c_list.list = self.list
	self.c_list.columns[2].name = (self.step_names[self.current_type] or self.current_type:capitalize())
	self.c_list:generate()
end

--- Returns to the previous birth descriptor specified in order
-- 
function _M:prev()
	if self.cur_order == 1 then
		if #self.list == 1 and self.birth_auto[self.current_type] ~= false  then self:next() end
		return
	end
	if not self.list then return end
	self.changed = true
	self.descriptors_by_type[self.current_type] = nil
	table.remove(self.descriptors)
	self.cur_order = self.cur_order - 1
	self:selectType(self.order[self.cur_order])
	if #self.list == 0 then
		self:prev()
	elseif #self.list == 1 then
		self:prev()
	end
end

--- Stores the value of the current selected birth descriptor, 
-- then proceeds to the next birth descriptor specified in order
-- 
function _M:next()
	self.changed = true
	if self.list then
		self.descriptors_by_type[self.current_type] = self.list[self.sel] or "none"
		table.insert(self.descriptors, self.list[self.sel] or "none")
		if self.list[self.sel] and self.list[self.sel].on_select then self.list[self.sel]:on_select() end

		self.cur_order = self.cur_order + 1
		if not self.order[self.cur_order] then
			game:unregisterDialog(self)
			self:apply()
			self.at_end()
			print("[BIRTHER] Finished!")
			return
		end
	end
	self:selectType(self.order[self.cur_order])

	if self:quickBirth() then return end

	if #self.list == 0 then
		return self:next()
	elseif #self.list == 1 and self.birth_auto[self.current_type] ~= false then
		return self:next()
	end

	if __module_extra_info.auto_birth and __module_extra_info.auto_birth[self.current_type] then
		-- Random
		if __module_extra_info.auto_birth[self.current_type] == '*' then
			return self:randomSelect()
		else
			for i = 1, #self.list do
				if __module_extra_info.auto_birth[self.current_type] == self.list[i].name then
					self.sel = i
					return self:next()
				end
			end
		end
	end
end

--- Randomly selects an option for the current birth descriptor,
-- then goes to the next one in the order automatically
-- 
function _M:randomSelect()
	self.sel = rng.range(1, #self.list)
	game.log("Randomly selected %s.", self.list[self.sel].name)
	self:next()
end

--- Used by the list that stores birth descriptors, selects the correct item
-- 
-- @param item
function _M:select(item)
	if item and self.uis and self.uis[2] then
		self.uis[2].ui = item.zone
	end
end

--- Tries to apply all birth options to the actor. Should only be called once, at the end of creation
-- 
function _M:apply(self_contained)
	self.actor.descriptor = {}
	local stats, inc_stats = {}, {}
	for i, d in ipairs(self.descriptors) do
		print("[BIRTHER] Applying descriptor "..(d.type or "untyped").."."..(d.name or "none"))
		self.actor.descriptor[d.type or "none"] = (d.name or "none")

		if d.copy then
			local copy = table.clone(d.copy, true)
			-- Append array part
			while #copy > 0 do
				local f = table.remove(copy, 1)
				table.insert(self.actor, f)
			end
			-- Copy normal data
			table.merge(self.actor, copy, true)
		end
		if d.copy_add then
			local copy = table.clone(d.copy_add, true)
			-- Append array part
			while #copy > 0 do
				local f = table.remove(copy, 1)
				table.insert(self.actor, f)
			end
			-- Copy normal data
			table.mergeAdd(self.actor, copy, true)
		end
		-- Change stats
		if d.stats then
			for stat, inc in pairs(d.stats) do
				stats[stat] = (stats[stat] or 0) + inc
			end
		end
		if d.inc_stats then
			for stat, inc in pairs(d.inc_stats) do
				inc_stats[stat] = (inc_stats[stat] or 0) + inc
			end
		end
		if d.talents_types then
			local tt = d.talents_types
			if type(tt) == "function" then tt = tt(self) end
			for t, v in pairs(tt) do
				local mastery
				if type(v) == "table" then
					v, mastery = v[1], v[2]
				else
					v, mastery = v, 0
				end
				self.actor:learnTalentType(t, v)
				self.actor.talents_types_mastery[t] = (self.actor.talents_types_mastery[t] or 0) + mastery
			end
		end
		if d.talents then
			for tid, lev in pairs(d.talents) do
				print("[BIRTHER} learning talent", tid, lev)
				for i = 1, lev do
					self.actor:learnTalent(tid, true)
				end
			end
		end
		if d.experience then self.actor.exp_mod = self.actor.exp_mod * d.experience end
		if d.body then
			self.actor.body = d.body
			self.actor:initBody()
		end
		if self.applyingDescriptor then self:applyingDescriptor(i, d, self_contained) end
	end

	-- Apply stats now to not be overridden by other things
	for stat, inc in pairs(stats) do
		self.actor:incStat(stat, inc)
	end
	for stat, inc in pairs(inc_stats) do
		self.actor:incIncStat(stat, inc)
	end
	self.actor.__stats_resolved = true
end
