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

function _M:init(dialogdef, profile_help_text)
	Dialog.init(self, _t"Online profile "..dialogdef.name, math.min(800, game.w * 0.9), 400)
	self.profile_help_text = profile_help_text
	self.dialogdef = dialogdef
	self.alpha = 230
	self.justlogin = dialogdef.justlogin

	self.c_desc = Textzone.new{width=math.floor(self.iw), auto_height=true, text=self.profile_help_text}

	local login_filter = function(c)
		if c:find("^[a-z0-9]$") then return c end
		if c:find("^[A-Z]$") then return c:lower() end
		return nil
	end
	local pass_filter = function(c)
		if c == '\t' then return nil end
		return c
	end

	if self.justlogin then
		self.c_login = Textbox.new{title=_t"Username: ", text="", chars=30, max_len=200, fct=function(text) self:okclick() end}
		self.c_pass = Textbox.new{title=_t"Password: ", text="", chars=30, max_len=200, hide=true, fct=function(text) self:okclick() end}
		local ok = require("engine.ui.Button").new{text=_t"Login", fct=function() self:okclick() end}
		local cancel = require("engine.ui.Button").new{text=_t"Cancel", fct=function() self:cancelclick() end}

		self:loadUI{
			{left=0, top=0, ui=self.c_desc},
			{left=0, top=self.c_desc.h, ui=self.c_login},
			{left=0, top=self.c_desc.h+self.c_login.h+5, ui=self.c_pass},
			{left=0, bottom=0, ui=ok},
			{right=0, bottom=0, ui=cancel},
		}
		self:setFocus(self.c_login)
	else
		local pwa = _t"Password again: "
		self.c_login = Textbox.new{title=_t"Username: ", size_title=pwa, text="", chars=30, max_len=20, filter=login_filter, fct=function(text) self:okclick() end}
		self.c_pass = Textbox.new{title=_t"Password: ", size_title=pwa, text="", chars=30, max_len=40, hide=true, filter=pass_filter, fct=function(text) self:okclick() end}
		self.c_pass2 = Textbox.new{title=pwa, text="", size_title=pwa, chars=30, max_len=40, hide=true, filter=pass_filter, fct=function(text) self:okclick() end}
		self.c_email = Textbox.new{title=_t"Email: ", size_title=pwa, text="", chars=30, max_len=80, filter=pass_filter, fct=function(text) self:okclick() end}
		self.c_news = Checkbox.new{title=_t"Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", default=false, fct=function() self:okclick() end}
		self.c_age = Checkbox.new{title=_t"You at least 16 years old, or have parental authorization to play the game.", default=false, fct=function() self:okclick() end}
		local ok = require("engine.ui.Button").new{text=_t"Create", fct=function() self:okclick() end}
		local privacy = require("engine.ui.Button").new{text=_t"Privacy Policy (opens in browser)", fct=function() self:privacypolicy() end}
		local cancel = require("engine.ui.Button").new{text=_t"Cancel", fct=function() self:cancelclick() end}

		self:loadUI{
			{left=0, top=0, ui=self.c_desc},
			{left=0, top=self.c_desc.h, ui=self.c_login},
			{left=0, top=self.c_desc.h+self.c_login.h+5, ui=self.c_pass},
			{left=0, top=self.c_desc.h+self.c_login.h+self.c_pass.h+5, ui=self.c_pass2},
			{left=0, top=self.c_desc.h+self.c_login.h+self.c_pass.h+self.c_pass2.h+10, ui=self.c_email},
			{left=0, top=self.c_desc.h+self.c_login.h+self.c_pass.h+self.c_pass2.h+self.c_email.h+10, ui=self.c_news},
			{left=0, top=self.c_desc.h+self.c_login.h+self.c_pass.h+self.c_pass2.h+self.c_email.h+self.c_news.h+10, ui=self.c_age},
			{left=0, bottom=0, ui=ok},
			{right=0, bottom=0, ui=cancel},
			{hcenter=0, bottom=0, ui=privacy},
		}
		self:setFocus(self.c_login)
	end
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end


function _M:okclick()
	if self.c_pass2 and self.c_pass.text ~= self.c_pass2.text then
		self:simplePopup(_t"Password", _t"Password mismatch!")
		return
	end
	if self.c_login.text:len() < 2 then
		self:simplePopup(_t"Username", _t"Your username is too short")
		return
	end
	if self.c_pass.text:len() < 4 then
		self:simplePopup(_t"Password", _t"Your password is too short")
		return
	end
	if self.c_email and (self.c_email.text:len() < 6 or not self.c_email.text:find("@")) then
		self:simplePopup(_t"Email", _t"Your email seems invalid")
		return
	end
	if not self.c_age.checked then
		self:simplePopup(_t"Age Check", _t"You need to be 16 years old or more or to have parental authorization to play this game.")
		return
	end

	game:unregisterDialog(self)
	game:createProfile({create=self.c_email and true or false, login=self.c_login.text, pass=self.c_pass.text, email=self.c_email and self.c_email.text, news=self.c_news and self.c_news.checked})
end

function _M:cancelclick()
	self.key:triggerVirtual("EXIT")
end

function _M:privacypolicy()
	util.browserOpenUrl("https://te4.org/privacy-policy-data", {is_external=true})	
end
