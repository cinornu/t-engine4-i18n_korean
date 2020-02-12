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
local CommonData = require "mod.dialogs.shimmer.CommonData"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local ActorFrame = require "engine.ui.ActorFrame"
local Textbox = require "engine.ui.Textbox"
local ListColumns = require "engine.ui.ListColumns"
local GetText = require "engine.dialogs.GetText"

module(..., package.seeall, class.inherit(Dialog, CommonData))

function _M:init(player)
	world.shimmer_sets = world.shimmer_sets or {}
	self.true_actor = player
	self.actor = player:cloneFull()
	self.actor.x, self.actor.y = nil, nil
	self.actor:removeAllMOs()
	self.search_filter = nil

	Dialog.init(self, ("Shimmer Sets: %s"):tformat(player.name), 680, 500)

	self:generateList()

	self.c_search = Textbox.new{title=_t"Search: ", text="", chars=20, max_len=60, fct=function() end, on_change=function(text) self:search(text) end}

	self.c_list = ListColumns.new{columns={{name=_t"Name", width=100, display_prop="name", sort="sortname"}}, hide_columns=true, scrollbar=true, width=300, height=self.ih - 5 - self.c_search.h, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local donatortext = ""
	if not profile:isDonator(1) then donatortext = "\n#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#" end
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_bleed=true, auto_height=true, text=_t"You can switch your appearance to a saved set of shimmers.\n#{bold}#This is a purely cosmetic change.#{normal}#"..donatortext}
	local actorframe = ActorFrame.new{actor=self.actor, w=128, h=128}

	self:loadUI{
		{left=0, top=0, ui=self.c_search},
		{left=0, top=self.c_search, ui=self.c_list},
		{right=0, top=0, ui=help},
		{right=(help.w - actorframe.w) / 2, vcenter=0, ui=actorframe},
	}
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}
end

function _M:use(item)
	if not item then end
	game:unregisterDialog(self)

	if profile:isDonator(1) then
		if item.id == "current" then
			local set = table.clone(self.true_actor.shimmer_current_outfit, true)
			local d = GetText.new(_t"Save Outfit", _t"Outfit name?", 1, 100, function(text)
				set.name = text
				world.shimmer_sets[set.name] = set
				self:generateList()
			end)
			if set.name then d:setText(set.name) end
			game:registerDialog(d)
		else
			self:applyShimmers(self.true_actor, item.set)
		end
	else
		Dialog:yesnoPopup(_t"Donator Cosmetic Feature", _t"This cosmetic feature is only available to donators/buyers.", function(ret) if ret then
			game:registerDialog(require("mod.dialogs.Donation").new(_t"shimmer ingame"))
		end end, _t"Donate", _t"Cancel")
	end
end

function _M:select(item)
	if not item then end
	if item.id == "current" then
		self:applyShimmers(self.actor, self.true_actor.shimmer_current_outfit)
	else
		self:applyShimmers(self.actor, item.set)
	end
end

function _M:search(text)
	if text == "" then self.search_filter = nil
	else self.search_filter = text end

	self:generateList()
end

function _M:matchSearch(name)
	if not self.search_filter then return true end
	return name:lower():find(self.search_filter:lower(), 1, 1)
end

function _M:generateList()
	local sets = world.shimmer_sets
	local list = {}

	if self:matchSearch("current") then
		list[#list+1] = {
			name = _t"#GOLD#[save current outfit]",
			id = "current",
			sortname = "--",
		}
	end

	for name, data in pairs(sets) do
		-- if self.object.type == data.type and self.object.subtype == data.subtype then
		if self:matchSearch(name:removeColorCodes()) then
			local d = {
				set = table.clone(data, true),
				name = name,
				id = name,
				sortname = name:removeColorCodes(),
			}
			list[#list+1] = d
		end
	end
	table.sort(list, "sortname")

	self.list = list
	if self.c_list then self.c_list:setList(list) end
end
