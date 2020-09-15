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
local FontPackage = require "engine.FontPackage"
local VariableList = require "engine.ui.VariableList"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"

--- Language selection
-- @classmod engine.dialogs.LanguageSelect
module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, _t"Language Selection", 400, 500)

	self:generateList()

	self.c_list = VariableList.new{width=self.iw, max_height=self.ih, list=self.list, fct=function(item) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:select(item)
	if not item then return end

	game:saveSettings("locale", ("locale = %q\n"):format(item.locale))
	config.settings.locale = item.locale

	game:saveGame()
	util.showMainMenu(false, nil, nil, game.__mod_info.short_name, game.save_name, false)	
end

function _M:generateList()
	local list = {
		{name = "English (English)", locale="en_US"},
		{name = "简体中文 (Simplified Chinese)", locale="zh_hans", font=FontPackage:get("default", nil, "chinese")},
		-- {name = "日本語 (Japanese)", locale="ja_JP", font=FontPackage:get("default", nil, "chinese")},
		-- {name = "한국어 (Korean)", locale="ko_KR", font=FontPackage:get("default", nil, "chinese")},
	}

	if config.settings.cheat then
		list[#list+1] = {name = "TEST (TEST)", locale="test_TEST"}
	end

	self:triggerHook{"I18N:listLanguages", list=list}
	
	self.list = list
end
