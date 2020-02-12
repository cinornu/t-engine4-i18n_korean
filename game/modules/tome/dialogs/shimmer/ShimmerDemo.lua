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
local Textzone = require "engine.ui.Textzone"
local ActorFrame = require "engine.ui.ActorFrame"
local Textbox = require "engine.ui.Textbox"
local ListColumns = require "engine.ui.ListColumns"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(player, what)
	self.actor = player:cloneFull()
	self.actor.x, self.actor.y = nil, nil
	self.actor:removeAllMOs()
	self.search_filter = what
	self.time_cnt = 0
	
	self.allowed_types = {}
	self.objects = {}
	for _, slot in ipairs{player.INVEN_MAINHAND, player.INVEN_OFFHAND, player.INVEN_BODY, player.INVEN_QUIVER, player.INVEN_FEET, player.INVEN_HANDS, player.INVEN_CLOAK, player.INVEN_HEAD} do
		local o = self.actor:getInven(slot)[1]
		self.objects[#self.objects+1] = {
			o = o,
			slot = player.inven_def[slot].short_name,
		}
		self.allowed_types[o.type] = true
	end

	Dialog.init(self, _t"Shimmer Demo", 680, 500)

	self:generateList()

	self:loadUI{}
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}
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
	local megalist = {}

	for _, def in ipairs(self.objects) do
		local list = {}

		if def.slot ~= "BODY" then
			list[#list+1] = {
				moddables = {},
				name = _t"#GREY#[Invisible]",
				sortname = "--",
				slot = def.slot,
				object = def.o,
			}
		end

		local unlocked = world.unlocked_shimmers and world.unlocked_shimmers[def.slot] or {}
		for name, data in pairs(unlocked) do
			-- if self.object.type == data.type and self.object.subtype == data.subtype then
			if self.allowed_types[data.type] and self:matchSearch(name:removeColorCodes()) then
				local d = {
					moddables = table.clone(data.moddables, true),
					name = name,
					sortname = name:removeColorCodes(),
					slot = def.slot,
					object = def.o,
				}
				d.moddables.name = name
				list[#list+1] = d
			end
		end
		table.sort(list, "sortname")
		megalist[def.slot] = {
			olist = table.clone(list, false),
			list = list,
			max = 120 / #list,
			cnt = 0,
		}
	end

	self.megalist = megalist
end

function _M:changeStuff(nb_keyframes)
	for slot, def in pairs(self.megalist) do
		def.cnt = def.cnt + nb_keyframes
		if def.cnt >= def.max then
			def.cnt = 0

			if #def.list == 0 then def.list = table.clone(def.olist, false) end

			local item = rng.tableRemove(def.list)
			if item then
				item.object.shimmer_moddable = item.moddables
				self.actor:updateModdableTile()
			end
		end
	end
end

function _M:innerDisplay(x, y, nb_keyframes)
	self:changeStuff(nb_keyframes)

	core.display.drawQuad(-1000, -1000, 3000, 3000, 0x10, 0x0e, 0x10, 255)
	-- core.display.drawQuad(-1000, -1000, 3000, 3000, 0x0e, 0x11, 0x11, 255)
	self.actor:toScreen(nil, -50, -42, 100, 100)
end
