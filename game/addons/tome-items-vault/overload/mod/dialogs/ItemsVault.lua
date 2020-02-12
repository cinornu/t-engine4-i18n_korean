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
local ListColumns = require "engine.ui.ListColumns"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local Image = require "engine.ui.Image"
local IV = require "mod.class.ItemsVaultDLC"

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	self:generateList()
	if self.iv.error then
		self:simplePopup(_t"Item's Vault", _t"Impossible to contact the server, please wait a few minutes and try again.")
		self.dont_show = true
		return
	end

	Dialog.init(self, ("Item's Vault (%d/%d)"):tformat(#self.iv.list, self.iv.max), game.w * 0.8, game.h * 0.8)

	local txt = Textzone.new{width=math.floor(self.iw - 10), auto_height=true, text=_t[[Retrieve an item from the vault. When you place an item in the vault the paradox energies around it are so powerful you must wait one hour before retrieving it.
	#CRIMSON#Warning: while you *can* retrieve items made with previous versions of the game, no guarantee is given that the universe (or your character) will not explode.]]}

	self.c_list = ListColumns.new{width=math.floor(self.iw - 10), height=self.ih - 10 - txt.h - 20, scrollbar=true, sortable=true, columns={
		{name=_t"Name", width=70, display_prop="name", sort="name"},
		{name=_t"Usable", width=30, display_prop="usable_txt", sort="usable_txt"},
	}, list=self.list, fct=function(item) self:import(item) end, select=function(item, sel) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=txt},
		{left=0, top=txt.h + 20, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:generateList()
	local infos = IV.listVault()
	self.iv = infos

	-- Makes up the list
	local list = {}
	for i, d in ipairs(infos.list) do
		if d.usable then
			d.usable_txt = _t"#LIGHT_GREEN#Yes"
		else
			if d.sec_until / 60 < 1 then
				d.usable_txt = _t"#LIGHT_RED#In less than one minute"
			else
				d.usable_txt = ("#LIGHT_RED#In %d minutes"):tformat(math.ceil(d.sec_until / 60))
			end
		end
		list[#list+1] = d
	end
	-- Add known artifacts
	table.sort(list, function(a, b) return a.name < b.name end)
	self.list = list
end

function _M:select(item)
	if not item then return end
	if self.cur == item then return end
	self.cur = item

	if item.last_display_x then game:tooltipDisplayAtMap(item.last_display_x + self.c_list.w, item.last_display_y, item.desc) end
end

function _M:import(item)
	if not item then return end

	if not item.usable then
		self:simplePopup(_t"Cooldown", _t"This item has been placed recently in the vault, you must wait a bit before removing it.")
		return
	end

	local o = IV.transferFromVault(item.id_entity)
	if o then
		game.player.used_items_vault = true
		game.player:addObject(game.player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.player:sortInven()
		game:saveGame()
		game.log("#LIGHT_BLUE#You transfer %s from the online item's vault.", o:getName{do_colour=true, do_count=true})
	else
		game.log("#LIGHT_RED#Error while transfering from the online item's vault, please retry later.")
	end
	self:generateList()
	self.c_list:setList(self.list, true)
	self:updateTitle(("Item's Vault (%d/%d)"):tformat(#self.iv.list, self.iv.max))
end