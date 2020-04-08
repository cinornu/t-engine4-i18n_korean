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
local List = require "engine.ui.List"

--- Main game menu
-- @classmod engine.dialogs.GameMenu
module(..., package.seeall, class.inherit(Dialog))

function _M:init(actions)
	self:generateList(actions)

	Dialog.init(self, _t"Game Menu", 300, 20)

	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:use(item)
	item.fct()
end

function _M:generateList(actions)
	local default_actions = {
		resume = { _t"Resume", function() game:unregisterDialog(self) end },
		language = { _t"Language", function()
			game:unregisterDialog(self)
			package.loaded["engine.dialogs.LanguageSelect"] = nil
			local menu = require("engine.dialogs.LanguageSelect").new()
			game:registerDialog(menu)
		end },
		keybinds = { _t"Key Bindings", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.KeyBinder").new(game.normal_key, nil, game.gestures)
			game:registerDialog(menu)
		end },
		keybinds_all = { _t"Key Bindings", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.KeyBinder").new(game.normal_key, true, game.gestures)
			game:registerDialog(menu)
		end },
		video = { _t"Video Options", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.VideoOptions").new()
			game:registerDialog(menu)
		end },
		resolution = { _t"Display Resolution", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.DisplayResolution").new()
			game:registerDialog(menu)
		end },
		achievements = { _t"Show Achievements", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.ShowAchievements").new(nil, game:getPlayer())
			game:registerDialog(menu)
		end },
		sound = { _t"Audio Options", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.AudioOptions").new()
			game:registerDialog(menu)
		end },
		-- highscores = { "View High Scores", function()
		-- 	game:unregisterDialog(self)
		-- 	local menu = require("engine.dialogs.ViewHighScores").new()
		-- 	game:registerDialog(menu)
		-- end },
		steam = { "Steam", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.SteamOptions").new()
			game:registerDialog(menu)
		end },
		cheatmode = { _t"#GREY#Developer Mode", function()
			game:unregisterDialog(self)
			if config.settings.cheat then
				Dialog:yesnoPopup(_t"Developer Mode", _t"Disable developer mode?", function(ret) if ret then
					config.settings.cheat = false
					game:saveSettings("cheat", "cheat = nil\n")
					util.showMainMenu()
				end end, nil, nil, true)
			else
				Dialog:yesnoLongPopup(_t"Developer Mode", _t[[Enable developer mode?
Developer Mode is a special game mode used to debug and create addons.
Using it will #CRIMSON#invalidate#LAST# any savefiles loaded.
When activated you will have access to special commands:
- CTRL+L: bring up a lua console that lets you explore and alter all the game objects, enter arbitrary lua commands, ...
- CTRL+A: bring up a menu to easily do many tasks (create NPCs, teleport to zones, ...)
- CTRL+left click: teleport to the clicked location
]], 500, function(ret) if not ret then
					config.settings.cheat = true
					game:saveSettings("cheat", "cheat = true\n")
					util.showMainMenu()
				end end, _t"No", _t"Yes", true)
		
			end
		end },
		save = { _t"Save Game", function() game:unregisterDialog(self) game:saveGame() end },
		quit = { _t"Main Menu", function() game:unregisterDialog(self) game:onQuit() end },
		exit = { _t"Exit Game", function() game:unregisterDialog(self) game:onExit() end },
	}

	-- Makes up the list
	local list = {}
	local i = 0
	for _, act in ipairs(actions) do
		if type(act) == "string" then
			if act ~= "steam" or core.steam then
				local a = default_actions[act]
				if a then
					list[#list+1] = { name=a[1], fct=a[2] }
					i = i + 1
				end
			end
		else
			local a = act
			list[#list+1] = { name=a[1], fct=a[2] }
			i = i + 1
		end
	end
	self.list = list
end
