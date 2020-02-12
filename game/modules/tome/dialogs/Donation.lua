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
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Button = require "engine.ui.Button"
local ButtonImage = require "engine.ui.ButtonImage"
local Numberbox = require "engine.ui.Numberbox"
local Textzone = require "engine.ui.Textzone"
local Checkbox = require "engine.ui.Checkbox"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Dialog))

_M.force_ui_inside = "microtxn"

function _M:init(source)
	self.donation_source = source or "ingame"
	Dialog.init(self, _t"Donations", 600, 300)

	local desc
	local recur = false

	if not profile.auth or not tonumber(profile.auth.donated) or tonumber(profile.auth.donated) <= 1 or true then
		local donation_features = { _t"#GOLD#Character cosmetic customization and special tiles#WHITE#", _t"#GOLD#Exploration mode (infinite lives)#WHITE#", _t"#GOLD#Item's appearance change (Shimmering)#WHITE#"}
		self:triggerHook{"DonationDialog:features", list=donation_features}

		-- First time donation
		desc = Textzone.new{width=self.iw, auto_height=true, text=([[Hi, I am Nicolas (DarkGod), the maker of this game.
It is my dearest hope that you find my game enjoyable, and that you will continue to do so for many years to come!

ToME is free and open-source and will stay that way, but that does not mean I can live without money, so I have come to disturb you here and now to ask for your kindness.
If you feel that the (many) hours you have spent having fun were worth it, please consider making a donation for the future of the game.

Donators are also granted a few special features: %s.]]):tformat(table.concatNice(donation_features, ", ", _t" and "))}
	else
		-- Recurring donation
		recur = true
		desc = Textzone.new{width=self.iw, auto_height=true, text=_t[[Thank you for supporting ToME, your donation was greatly appreciated.
If you want to continue supporting ToME you are welcome to make a new donation or even a reccuring one which helps ensure the future of the game.
Thank you for your kindness!]]}
	end

	self.c_donate = Numberbox.new{title=_t"Donation amount: ", number=10, max=1000, min=5, chars=5, fct=function() end}
	self.c_recur = Checkbox.new{title=_t"Monthly donation", default=recur, fct=function() end}
	local euro = Textzone.new{auto_width=true, auto_height=true, text=_t[[euro]]}
	local patreon = ButtonImage.new{alpha_unfocus=1, file="ui/patreon.png", fct=function() self:patreon() end}
	local paypal = ButtonImage.new{alpha_unfocus=1, file="ui/paypal.png", fct=function() self:paypal() end}
	local cancel = Button.new{text=_t"Cancel", fct=function() self:cancel() end}
	local patreon_explain = Textzone.new{width=patreon.w, auto_height=true, text=_t[[You can also make a pledge on Patreon if you prefer.]]}
	local hsep = Separator.new{dir="horizontal", size=self.c_donate.h+paypal.h+self.c_recur.h-cancel.h}

	self:loadUI{
		{left=0, top=0, ui=desc},
		{left=5, bottom=5 + paypal.h + self.c_recur.h, ui=self.c_donate},
		{left=5+self.c_donate.w, bottom=10 + paypal.h + self.c_recur.h, ui=euro},
		{hcenter=0, bottom=cancel.h, ui=hsep},
		{left=0, bottom=5 + paypal.h, ui=self.c_recur},
		{right=0, bottom=5 + patreon.h, ui=patreon_explain},
		{left=0, bottom=0, ui=paypal},
		{right=0, bottom=0, ui=patreon},
		{hcenter=0, bottom=0, ui=cancel},
	}
	self:setFocus(self.c_donate)
	self:setupUI(false, true)
end

function _M:cancel()
	game:unregisterDialog(self)
end

function _M:paypal()
	if not tonumber(self.c_donate.number) or tonumber(self.c_donate.number) < 5 then return end

	game:unregisterDialog(self)

	local inside = jit and jit.os ~= "Linux" and core.webview and true or false

	if not inside then self:simplePopup(_t"Thank you", _t"Thank you, a paypal page should now open in your browser.") end

	local url = ("https://te4.org/ingame-donate/%s/%s/%s/EUR/%s"):format(self.c_donate.number, self.c_recur.checked and "monthly" or "onetime", (profile.auth and profile.auth.drupid) and profile.auth.drupid or "0", self.donation_source)

	if inside then util.browserOpenUrl(url, {is_external=true})
	else util.browserOpenUrl(url, {webview=true, is_external=true}) end
end

function _M:patreon()
	game:unregisterDialog(self)

	self:simplePopup(_t"Thank you", _t"Thank you, a Patreon page should now open in your browser.")
	util.browserOpenUrl("https://www.patreon.com/darkgodone", {is_external=true})
end
