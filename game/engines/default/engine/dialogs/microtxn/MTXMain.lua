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
local Entity = require "engine.Entity"
local Dialog = require "engine.ui.Dialog"
local ButtonImage = require "engine.ui.ButtonImage"

module(..., package.seeall, class.inherit(Dialog))

_M.force_ui_inside = "microtxn"

function _M:init(mode)
	self.base_title_text = ("%s #GOLD#Purchasables#LAST#"):tformat(_t(game.__mod_info.long_name))
	Dialog.init(self, self.base_title_text, 200, game.h * 0.8)

	local do_purchase = ButtonImage.new{alpha_unfocus=1, file="microtxn-ui/action_purchase.png", fct=function() game:unregisterDialog(self) game.key:triggerVirtual("MTXN_PURCHASE") end}
	local do_use = ButtonImage.new{alpha_unfocus=1, file="microtxn-ui/action_use.png", fct=function() game:unregisterDialog(self) game.key:triggerVirtual("MTXN_USE") end}

	self:loadUI{
		{left=0, top=20, ui=do_purchase},
		{right=0, top=20, ui=do_use},
	}
	self:setupUI(false, true)

	self.key:addBinds{
		ACCEPT = "EXIT",
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}

-- [=[
	if not config.settings.mtxn_explain_seen then game:onTickEnd(function()
		game:saveSettings("mtxn_explain_seen", ("mtxn_explain_seen = true\n"):format())
		config.settings.mtxn_explain_seen = true

		Dialog:forceNextDialogUI("microtxn")
		self:simpleLongPopup(_t"Online Store", _t[[Welcome!

I am #{italic}##ANTIQUE_WHITE#DarkGod#LAST##{normal}#, the creator of the game and before you go on your merry way I wish to take a few seconds of your time to explain why there are microtransactions in the game.

Before you run off in terror let me put it plainly: I am very #{bold}#firmly #CRIMSON#against#LAST# pay2win#{normal}# things so rest assured I will not add this kind of stuff.

So why put microtransactions? Tales of Maj'Eyal is a cheap/free game and has no subscription required to play. It is my baby and I love it; I plan to work on it for many years to come (as I do since 2009!) but for it to be viable I must ensure a steady stream of income as this is sadly the state of the world we live in.

As for what kind of purchases are/will be available:
- #GOLD#Cosmetics#LAST#: in addition to the existing racial cosmetics & item shimmers available in the game you can get new packs of purely cosmetic items & skins to look even more dapper!
- #GOLD#Pay2DIE#LAST#: Tired of your character? End it with style!
- #GOLD#Vault space#LAST#: For those that donated they can turn all those "useless" donations into even more online vault slots.
- #GOLD#Community events#LAST#: A few online events are automatically and randomly triggered by the server. With those options you can force one of them to trigger; bonus point they trigger for the whole server so everybody online benefits from them each time!

I hope I've convinced you of my non-evil intentions (ironic for a DarkGod I know ;)). I must say feel dirty doing microtransactions even as benign as those but I want to find all the ways I can to ensure the game's future.
Thanks, and have fun!]], math.min(900, game.w))
	end) end
--]=]
end
