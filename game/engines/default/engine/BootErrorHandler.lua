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
local UIBase = require "engine.ui.Base"
local Game = require "engine.Game"
local KeyBind = require "engine.KeyBind"

--- Handles dialog windows
-- @classmod engine.Module
module(..., package.seeall, class.inherit(Game))

function _M:init(errs, mod)
	-- I like to fak'it fak'it !
	self.__mod_info = mod
	_G.game = self
	UIBase:changeDefault("dark")

	-- Force load definitions of UI to be able to display the error
	for _, file in ipairs(fs.list("/data/gfx/ui/definitions")) do
		if file:find("%.lua$") then UIBase:loadUIDefinitions("/data/gfx/ui/definitions/"..file) end
	end

	Game.init(self, KeyBind.new())

	self:loaded()

	local d = require("engine.dialogs.ShowErrorStack").new(errs)
	d.unload = function(self)
		util.showMainMenu()
	end
	self:registerDialog(d)	
end
