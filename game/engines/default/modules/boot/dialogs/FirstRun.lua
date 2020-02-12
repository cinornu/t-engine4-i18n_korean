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
local Module = require "engine.Module"
local Dialog = require "engine.ui.Dialog"
local List = require "engine.ui.List"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local Button = require "engine.ui.Button"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(text)
	Dialog.init(self, _t"Welcome to Tales of Maj'Eyal", math.min(800, game.w * 0.9), 200)

	local c_desc = Textzone.new{width=self.iw, auto_height=true, text=text}

	local c_register = Button.new{text=_t"Register now!", fct=function() self:doRegister() end}
	local c_login = Button.new{text=_t"Login existing account", fct=function() self:doLogin() end}
	local c_later = Button.new{text=_t"Maybe later", fct=function() self:doLater() end}
	local c_disable = Button.new{text=_t"#RED#Disable all online features", fct=function() self:doDisable() end}

	self:loadUI{
		{left=0, top=0, ui=c_desc},
		{left=0, bottom=0, ui=c_register},
		{left=c_register, bottom=0, ui=c_login},
		{right=0, bottom=0, ui=c_later},
		{right=c_later, bottom=0, ui=c_disable},
	}
	self:setupUI(false, true)
end

function _M:doDisable()
	Dialog:yesnoLongPopup(_t"Disable all connectivity", _t[[You are about to disable all connectivity to the network.
This includes, but is not limited to:
- Player profiles: You will not be able to login, register
- Characters vault: You will not be able to upload any character to the online vault to show your glory
- Item's Vault: You will not be able to access the online item's vault, this includes both storing and retrieving items.
- Ingame chat: The ingame chat requires to connect to the server to talk to other players, this will not be possible.
- Purchaser / Donator benefits: The base game being free, the only way to give donators their bonuses fairly is to check their online profile. This will thus be disabled.
- Easy addons downloading & installation: You will not be able to see ingame the list of available addons, nor to one-click install them. You may still do so manually.
- Version checks: Addons will not be checked for new versions.
- Discord: If you are a Discord user, Rich Presence integration will also be disabled by this setting.
- Ingame game news: The main menu will stop showing you info about new updates to the game.

#{bold}##CRIMSON#This is an extremely restrictive setting. It is recommended you only activate it if you have no other choice as it will remove many fun and acclaimed features.#{normal}#

If you disable this option you can always re-activate it in the Online category of the Game Options menu later on.]], self.iw, function(ret) if not ret then
		profile:checkFirstRun()
		game:saveSettings("disable_all_connectivity", ("disable_all_connectivity = true\n"))
		game:saveSettings("firstrun_gdpr", ("firstrun_gdpr = true\n"))
		util.showMainMenu()
	end end, _t"Cancel", _t"#RED#Disable all!", true)
end

function _M:doLater()
	profile:checkFirstRun()
	game:saveSettings("disable_all_connectivity", ("disable_all_connectivity = false\n"))
	game:saveSettings("firstrun_gdpr", ("firstrun_gdpr = false\n"))
	util.showMainMenu()
end

function _M:doLogin()
	profile:checkFirstRun()
	game:saveSettings("disable_all_connectivity", ("disable_all_connectivity = false\n"))
	game:saveSettings("firstrun_gdpr", ("firstrun_gdpr = false\n"))
	util.showMainMenu()
	-- util.showMainMenu(false, nil, nil, nil, nil, nil, "boot_and_login=true", nil)
end

function _M:doRegister()
	profile:checkFirstRun()
	game:saveSettings("disable_all_connectivity", ("disable_all_connectivity = false\n"))
	game:saveSettings("firstrun_gdpr", ("firstrun_gdpr = false\n"))
	util.showMainMenu(false, nil, nil, nil, nil, nil, "boot_and_register=true", nil)
end
