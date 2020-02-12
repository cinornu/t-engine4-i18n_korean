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

module(..., package.seeall, class.inherit(Dialog, CommonData))

function _M:init(player, slot)
	self.slot = slot
	self.true_actor = player
	self.actor = player:cloneFull()
	self.actor.x, self.actor.y = nil, nil
	self.actor:removeAllMOs()

	Dialog.init(self, ("Shimmer: %s"):tformat(self:getShimmerName(player, slot)), 680, 500)

	self:generateList()

	self.c_search = Textbox.new{title=_t"Search: ", text="", chars=20, max_len=60, fct=function() end, on_change=function(text) self:search(text) end}

	self.c_list = ListColumns.new{columns={{name=_t"Name", width=100, display_prop="name", sort="sortname"}}, hide_columns=true, scrollbar=true, width=300, height=self.ih - 5 - self.c_search.h, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local donatortext = ""
	if not profile:isDonator(1) then donatortext = _t"\n#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#" end
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_bleed=true, auto_height=true, text=("You can alter your look.\n#{bold}#This is a purely cosmetic change.#{normal}#%s"):tformat(donatortext)}
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

function _M:applyShimmer(actor, shimmer)
	if not shimmer then return self:resetShimmer(actor) end

	if self.slot == "SHIMMER_DOLL" then
		actor.moddable_tile_base_shimmer = shimmer.moddable_tile
	elseif self.slot == "SHIMMER_HAIR" then
		actor.moddable_tile_base_shimmer_hair = shimmer.moddable_tile
	elseif self.slot == "SHIMMER_FACIAL" then
		actor.moddable_tile_base_shimmer_facial = shimmer.moddable_tile
	elseif self.slot == "SHIMMER_AURA" then
		actor.moddable_tile_base_shimmer_aura = shimmer.moddable_tile
		actor.moddable_tile_base_shimmer_particle = shimmer.moddable_tile2
	end
end

function _M:resetShimmer(actor)
	if self.slot == "SHIMMER_DOLL" then
		actor.moddable_tile_base_shimmer = nil
	elseif self.slot == "SHIMMER_HAIR" then
		actor.moddable_tile_base_shimmer_hair = nil
	elseif self.slot == "SHIMMER_FACIAL" then
		actor.moddable_tile_base_shimmer_facial = nil
	elseif self.slot == "SHIMMER_AURA" then
		actor.moddable_tile_base_shimmer_aura = nil
		actor.moddable_tile_base_shimmer_particle = nil
	end
end

function _M:use(item)
	if not item then end
	game:unregisterDialog(self)

	if profile:isDonator(1) then
		self:applyShimmers(self.true_actor, self.slot, item.id)
	else
		Dialog:yesnoPopup(_t"Donator Cosmetic Feature", _t"This cosmetic feature is only available to donators/buyers.", function(ret) if ret then
			game:registerDialog(require("mod.dialogs.Donation").new(_t"shimmer ingame"))
		end end, _t"Donate", _t"Cancel")
	end
end

function _M:select(item)
	if not item then end
	self:applyShimmers(self.actor, self.slot, item.id)
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
	local unlocked = world.unlocked_shimmers and world.unlocked_shimmers[self.slot] or {}
	local list = {}

	list[#list+1] = {
		moddables = nil,
		name = _t"#GREY#[Default]",
		id = "invisible",
		sortname = "--",
	}

	for name, data in pairs(unlocked) do
		if self:matchSearch(name:removeColorCodes()) then
			local d = {
				moddables = table.clone(data.moddables, true),
				name = name,
				id = name,
				sortname = name:removeColorCodes(),
			}
			d.moddables.name = name
			list[#list+1] = d
		end
	end
	table.sort(list, "sortname")

	self.list = list
	if self.c_list then self.c_list:setList(list) end
end
