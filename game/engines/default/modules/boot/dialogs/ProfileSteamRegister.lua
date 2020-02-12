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
local Button = require "engine.ui.Button"
local Checkbox = require "engine.ui.Checkbox"
local Textbox = require "engine.ui.Textbox"
local Textzone = require "engine.ui.Textzone"

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, _t"Steam User Account", math.min(800, game.w * 0.9), 400)
	self.alpha = 230

	self.c_desc = Textzone.new{width=math.floor(self.iw - 10), auto_height=true, text=_t[[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]]}

	local login_filter = function(c)
		if c:find("^[a-z0-9]$") then return c end
		if c:find("^[A-Z]$") then return c:lower() end
		return nil
	end

	self.c_login = Textbox.new{title=_t"Username: ", text="", chars=30, max_len=20, fct=function(text) self:okclick() end}
	self.c_email = Textbox.new{title=_t"Email: ", size_title=self.c_login.title, text="", chars=30, max_len=60, fct=function(text) self:okclick() end}
	self.c_news = Checkbox.new{title=_t"Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", default=false, fct=function() self:okclick() end}
	self.c_age = Checkbox.new{title=_t"You at least 16 years old, or have parental authorization to play the game.", default=false, fct=function() self:okclick() end}
	local ok = require("engine.ui.Button").new{text=_t"Register", fct=function() self:okclick() end}
	local cancel = require("engine.ui.Button").new{text=_t"Cancel", fct=function() self:cancelclick() end}
	local privacy = require("engine.ui.Button").new{text=_t"Privacy Policy (opens in browser)", fct=function() self:privacypolicy() end}
	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
		{left=0, top=self.c_desc.h, ui=self.c_login},
		{left=0, top=self.c_desc.h+self.c_login.h+5, ui=self.c_email},
		{left=0, top=self.c_desc.h+self.c_login.h+self.c_email.h+5, ui=self.c_news},
		{left=0, top=self.c_desc.h+self.c_login.h+self.c_email.h+self.c_news.h+5, ui=self.c_age},
		{left=0, bottom=0, ui=ok},
		{right=0, bottom=0, ui=cancel},
		{hcenter=0, bottom=0, ui=privacy},
	}
	self:setFocus(self.c_login)
	self:setupUI(true, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end


function _M:okclick()
	if self.c_login.text:len() < 2 then
		self:simplePopup(_t"Username", _t"Your username is too short")
		return
	end
	if self.c_email.text:len() > 0 and not self.c_email.text:find("..@..") then
		self:simplePopup(_t"Email", _t"Your email does not look right.")
		return
	end
	if not self.c_age.checked then
		self:simplePopup(_t"Age Check", _t"You need to be 16 years old or more or to have parental authorization to play this game.")
		return
	end
	
	local d = self:simpleWaiter(_t"Registering...", _t"Registering on https://te4.org/, please wait...") core.display.forceRedraw()
	d:timeout(30, function() Dialog:simplePopup("Steam", _t"Steam client not found.")	end)
	core.steam.sessionTicket(function(ticket)
		if not ticket then
			Dialog:simplePopup("Steam", _t"Steam client not found.")
			return
		end

		profile:performloginSteam(ticket:toHex(), self.c_login.text, self.c_email.text ~= "" and self.c_email.text, self.c_news.checked)
		profile:waitFirstAuth()
		d:done()
		if not profile.auth and profile.auth_last_error then
			if profile.auth_last_error == "already exists" then
				self:simplePopup(_t"Error", _t"Username or Email already taken, please select an other one.")
			end
		elseif profile.auth then
			game:unregisterDialog(self)
		end
	end)
end

function _M:cancelclick()
	self.key:triggerVirtual("EXIT")
end

function _M:privacypolicy()
	util.browserOpenUrl("https://te4.org/privacy-policy-data", {is_external=true})	
end
