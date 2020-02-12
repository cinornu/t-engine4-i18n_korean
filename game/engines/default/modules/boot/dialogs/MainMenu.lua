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
local Image = require "engine.ui.Image"
local Button = require "engine.ui.Button"
local ButtonImage = require "engine.ui.ButtonImage"
local Textzone = require "engine.ui.Textzone"
local Textbox = require "engine.ui.Textbox"
local Checkbox = require "engine.ui.Checkbox"
local Separator = require "engine.ui.Separator"
local KeyBind = require "engine.KeyBind"
local FontPackage = require "engine.FontPackage"
local Module = require "engine.Module"

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, _t"Main Menu", 250, 400, 450, 50)
	self.__showup = false
	self.__main_menu = true
	self.absolute = true

	local l = {}
	self.list = l
	l[#l+1] = {name=_t"New Game", fct=function() game:registerDialog(require("mod.dialogs.NewGame").new()) end}
	l[#l+1] = {name=_t"Load Game", fct=function() game:registerDialog(require("mod.dialogs.LoadGame").new()) end}
	l[#l+1] = {name=_t"Addons", fct=function() game:registerDialog(require("mod.dialogs.Addons").new()) end}
	l[#l+1] = {name=_t"Options", fct=function()
		local list = {
			"resume",
			"keybinds_all",
			{_t"Game Options", function()
				-- OMFG this is such a nasty hack, I'm nearly pround of it !
				local mod = Module:listModules().tome
				if not mod then return end

				local allmounts = fs.getSearchPath(true)
				if not mod.team then fs.mount(fs.getRealPath(mod.dir), "/mod", false)
				else fs.mount(fs.getRealPath(mod.team), "/", false) end

				local d = require("mod.dialogs.GameOptions").new()
				function d:unload()
					fs.reset()
					fs.mountAll(allmounts)
				end
				game:registerDialog(d)
			end},
			"video",
			"sound",
			"steam",
			"cheatmode",
		}
		local menu = require("engine.dialogs.GameMenu").new(list)
		game:registerDialog(menu)
	end}
	l[#l+1] = {name=_t"Credits", fct=function() game:registerDialog(require("mod.dialogs.Credits").new()) end}
	l[#l+1] = {name=_t"Exit", fct=function() game:onQuit() end}
	if config.settings.cheat then l[#l+1] = {name=_t"Reboot", fct=function() util.showMainMenu() end} end
	-- if config.settings.cheat then l[#l+1] = {name="webtest", fct=function() util.browserOpenUrl("http://google.com") end} end
--	if config.settings.cheat then l[#l+1] = {name="webtest", fct=function() util.browserOpenUrl("asset://te4/html/test.html") end} end

	self.c_background = Checkbox.new{title=_t"Disable animated background", default=config.settings.boot_menu_background and true or false, on_change=function() self:switchBackground() end}
	-- self.c_background = Button.new{text=game.stopped and "Enable background" or "Disable background", fct=function() self:switchBackground() end}
	self.c_version = Textzone.new{font={FontPackage:getFont("default"), 10}, auto_width=true, auto_height=true, text=("#{bold}##B9E100#T-Engine4 version: %d.%d.%d"):tformat(engine.version[1], engine.version[2], engine.version[3])}

	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) end, font={FontPackage:getFont("default")}}

	self.c_discord = ButtonImage.new{no_decoration=true, alpha_unfocus=0.5, file="discord.png", fct=function() util.browserOpenUrl("https://discord.gg/tales-of-majeyal", {is_external=true}) end}
	self.c_facebook = ButtonImage.new{no_decoration=true, alpha_unfocus=0.5, file="facebook.png", fct=function() util.browserOpenUrl("https://www.facebook.com/tales.of.maj.eyal", {is_external=true}) end}
	self.c_twitter = ButtonImage.new{no_decoration=true, alpha_unfocus=0.5, file="twitter.png", fct=function() util.browserOpenUrl("https://twitter.com/TalesOfMajEyal", {is_external=true}) end}
	self.c_forums = ButtonImage.new{no_decoration=true, alpha_unfocus=0.5, file="forums.png", fct=function() util.browserOpenUrl("http://forums.te4.org/", {is_external=true}) end}

	self.base_uis = {
		{left=0, top=0, ui=self.c_list},
		{right=self.c_facebook.w, bottom=0, absolute=true, ui=self.c_background},
		{right=0, top=0, absolute=true, ui=self.c_version},
		{right=0, bottom=self.c_facebook.h+self.c_twitter.h+self.c_forums.h, absolute=true, ui=self.c_discord},
		{right=0, bottom=self.c_facebook.h+self.c_twitter.h, absolute=true, ui=self.c_forums},
		{right=0, bottom=self.c_twitter.h, absolute=true, ui=self.c_facebook},
		{right=0, bottom=0, absolute=true, ui=self.c_twitter},
	}
	self:setupDLCButtons()

	self:enableWebtooltip()

	if game.__mod_info.publisher_logo then
		local c_pub = ButtonImage.new{no_decoration=true, alpha_unfocus=1, file="background/"..game.__mod_info.publisher_logo..".png", fct=function()
			if game.__mod_info.publisher_url then util.browserOpenUrl(game.__mod_info.publisher_url, {is_external=true}) end
		end}
		if game.w - 450 - 250 - c_pub.w - 20 > 0 then
			table.insert(self.base_uis, 1, {right=0, top=0, absolute=true, ui=c_pub})
		end
	end

	self:updateUI()	
end

function _M:setupDLCButtons()
	local has_ashes, has_embers, has_cults = false, false, false

	local function checker(file)
		if file == "ashes-urhrok.teaac" then has_ashes = true end
		if file == "orcs.teaac" then has_embers = true end
		if file == "cults.teaac" then has_cults = true end
	end
	for file in fs.iterate("/addons/") do checker(file) end
	for file in fs.iterate("/dlcs/") do checker(file) end

	self.c_dlc_ashes = ButtonImage.new{no_decoration=true, alpha_unfocus=1, file="dlcs-icons/"..(has_ashes and "" or "no-").."ashes.png", fct=function() util.browserOpenUrl("https://te4.org/dlc/ashes-urhrok") end}
	self.c_dlc_embers = ButtonImage.new{no_decoration=true, alpha_unfocus=1, file="dlcs-icons/"..(has_embers and "" or "no-").."embers.png", fct=function() util.browserOpenUrl("https://te4.org/dlc/orcs") end}
	self.c_dlc_cults = ButtonImage.new{no_decoration=true, alpha_unfocus=1, file="dlcs-icons/"..(has_cults and "" or "no-").."cults.png", fct=function() util.browserOpenUrl("https://te4.org/dlc/cults") end}
	self.c_dlc_ashes.on_focus_change = function(self, v)
		if v then game:floatingTooltip(self.last_display_x, self.last_display_y, "top", {
			Image.new{file="dlcs-icons/ashes-banner.png", width=467, height=181},
_t[[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]]..(has_ashes and _t"#LIGHT_GREEN#Installed" or _t"#YELLOW#Not installed - Click to download / purchase")})
		else game:floatingTooltip(nil)
		end
	end
	self.c_dlc_embers.on_focus_change = function(self, v)
		if v then game:floatingTooltip(self.last_display_x, self.last_display_y, "top", {
			Image.new{file="dlcs-icons/embers-banner.png", width=467, height=181},
_t[[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]]..(has_embers and _t"#LIGHT_GREEN#Installed" or _t"#YELLOW#Not installed - Click to download / purchase")})
		else game:floatingTooltip(nil)
		end
	end
	self.c_dlc_cults.on_focus_change = function(self, v)
		if v then game:floatingTooltip(self.last_display_x, self.last_display_y, "top", {
			Image.new{file="dlcs-icons/cults-banner.png", width=467, height=181},
_t[[#{bold}##GOLD#Forgotten Cults - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Not all adventurers seek fortune, not all that defend the world have good deeds in mind. Lately the number of sightings of horrors have grown tremendously. People wander off the beaten paths only to be found years later, horribly mutated and partly insane, if they are found at all. It is becoming evident something is stirring deep below Maj'Eyal. That something is you.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Writhing Ones. Give in to the corrupting forces and turn yourself gradually into an horror, summon horrors to do your bidding, shed your skin and melt your face to assault your foes. With your arm already turned into a tentacle, what creature can stop you?
#LIGHT_UMBER#New class:#WHITE# Cultists of Entropy. Using its insanity and control of entropic forces to unravel the normal laws of physic this caster class can turn healing into attacks and call upon the forces of the void to reduce its foes to dust.
#LIGHT_UMBER#New race:#WHITE# Drems. A corrupt subrace of dwarves, that somehow managed to keep a shred of sanity to not fully devolve into mindless horrors. They can enter a frenzy and even learn to summon horrors.
#LIGHT_UMBER#New race:#WHITE# Krogs. Ogres transformed by the very thing that should kill them. Their powerful attacks can stun their foes and they are so strong they can dual wield any one handed weapons.
#LIGHT_UMBER#Many new zones:#WHITE# Explore the Scourge Pits, fight your way out of a giant worm (don't ask how you get *in*), discover the wonders of the Occult Egress and many more strange and tentacle-filled zones!
#LIGHT_UMBER#New horrors:#WHITE# You liked radiant horrors? You'll love searing horrors! And Nethergames. And Entropic Shards. And ... more
#LIGHT_UMBER#Sick of your own head:#WHITE#  Replace it with a nice cozy horror!
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, events... 

]]..(has_cults and _t"#LIGHT_GREEN#Installed" or _t"#YELLOW#Not installed - Click to download / purchase")})
		else game:floatingTooltip(nil)
		end
	end

	table.insert(self.base_uis, {left=0, bottom=0, absolute=true, ui=self.c_dlc_ashes})
	table.insert(self.base_uis, {left=self.c_dlc_ashes.w, bottom=0, absolute=true, ui=self.c_dlc_embers})
	table.insert(self.base_uis, {left=self.c_dlc_ashes.w+self.c_dlc_embers.w, bottom=0, absolute=true, ui=self.c_dlc_cults})
end

function _M:enableWebtooltip()
	if core.webview and game.webtooltip and not self.c_tooltip then
		self.c_tooltip = game.webtooltip
		self.base_uis[#self.base_uis+1] = {left=9, top=9, absolute=true, ui=self.c_tooltip}
	end
end

function _M:updateUI()
	local uis = table.clone(self.base_uis)

	if not config.settings.disable_all_connectivity then
		if profile.auth then
			self:uiStats(uis)
		else
			self:uiLogin(uis)
		end
	end

	self:loadUI(uis)
	self:setupUI(false, true)
	self.key:addBind("LUA_CONSOLE", function()
		if config.settings.cheat then
			game:registerDialog(require("engine.DebugConsole").new())
		end
	end)
	self.key:addBind("SCREENSHOT", function() game:saveScreenshot() end)
	KeyBind:load("chat")
	self.key:bindKeys() -- Make sure it updates
	self.key:addBind("USERCHAT_TALK", function() profile.chat:talkBox(nil, true) end)

	self:setFocus(self.c_list)
end

function _M:uiLogin(uis)
	if core.steam then return self:uiLoginSteam(uis) end

	local str = Textzone.new{auto_width=true, auto_height=true, text=_t"#GOLD#Online Profile"}
	local bt = Button.new{text=_t"Login", width=50, fct=function() self:login() end}
	local btr = Button.new{text=_t"Register", fct=function() self:register() end}
	self.c_login = Textbox.new{title=_t"Username: ", text="", chars=16, max_len=200, fct=function(text) self:login() end}
	self.c_pass = Textbox.new{title=_t"Password: ", size_title=self.c_login.title, text="", chars=16, max_len=200, hide=true, fct=function(text) self:login() end}

	uis[#uis+1] = {left=10, bottom=bt.h + self.c_login.h + self.c_pass.h + str.h, ui=Separator.new{dir="vertical", size=self.iw - 20}}
	uis[#uis+1] = {hcenter=0, bottom=bt.h + self.c_login.h + self.c_pass.h, ui=str}
	uis[#uis+1] = {left=0, bottom=bt.h + self.c_pass.h, ui=self.c_login}
	uis[#uis+1] = {left=0, bottom=bt.h, ui=self.c_pass}
	uis[#uis+1] = {left=0, bottom=0, ui=bt}
	uis[#uis+1] = {right=0, bottom=0, ui=btr}
end

function _M:uiLoginSteam(uis)
	local str = Textzone.new{auto_width=true, auto_height=true, text=_t"#GOLD#Online Profile"}
	local bt = Button.new{text=_t"Login with Steam", fct=function() self:loginSteam() end}

	uis[#uis+1] = {left=10, bottom=bt.h + str.h, ui=Separator.new{dir="vertical", size=self.iw - 20}}
	uis[#uis+1] = {hcenter=0, bottom=bt.h, ui=str}
	uis[#uis+1] = {hcenter=0, bottom=0, ui=bt}
end

function _M:uiStats(uis)
	self.logged_url = "https://te4.org/users/"..profile.auth.page
	local str1 = Textzone.new{auto_width=true, auto_height=true, text=_t"#GOLD#Online Profile#WHITE#"}
	local str2 = Textzone.new{auto_width=true, auto_height=true, text=("#LIGHT_BLUE##{underline}#%s#LAST##{normal}#"):tformat(self.logged_url), fct=function() util.browserOpenUrl(self.logged_url, {is_external=true}) end}

	local logoff = Textzone.new{text=_t"#LIGHT_BLUE##{underline}#Logout", auto_height=true, width=50, fct=function() self:logout() end}

	uis[#uis+1] = {left=10, bottom=logoff.h + str2.h + str1.h, ui=Separator.new{dir="vertical", size=self.iw - 20}}
	uis[#uis+1] = {hcenter=0, bottom=logoff.h + str2.h, ui=str1}
	uis[#uis+1] = {left=0, bottom=logoff.h, ui=str2}
	uis[#uis+1] = {right=0, bottom=0, ui=logoff}
end

function _M:login()
	if self.c_login.text:len() < 2 then
		Dialog:simplePopup(_t"Username", _t"Your username is too short")
		return
	end
	if self.c_pass.text:len() < 4 then
		Dialog:simplePopup(_t"Password", _t"Your password is too short")
		return
	end
	game:createProfile({create=false, login=self.c_login.text, pass=self.c_pass.text})
end

function _M:loginSteam()
	local d = self:simpleWaiter(_t"Login...", _t"Login in your account, please wait...") core.display.forceRedraw()
	d:timeout(10, function() Dialog:simplePopup("Steam", _t"Steam client not found.")	end)
	core.steam.sessionTicket(function(ticket)
		if not ticket then
			Dialog:simplePopup("Steam", _t"Steam client not found.")
			d:done()
			return
		end
		profile:performloginSteam((ticket:toHex()))
		profile:waitFirstAuth()
		d:done()
		if not profile.auth and profile.auth_last_error then
			if profile.auth_last_error == "auth error" then
				game:newSteamAccount()
			end
		end
	end)
end

function _M:register()
	local dialogdef = {}
	dialogdef.fct = function(login) game:setPlayerLogin(login) end
	dialogdef.name = "creation"
	dialogdef.justlogin = false
	game:registerDialog(require('mod.dialogs.ProfileLogin').new(dialogdef, game.profile_help_text))
end

function _M:logout()
	profile:logOut()
	self:on_recover_focus()
end

function _M:switchBackground()
	game.stopped = not game.stopped
	game:saveSettings("boot_menu_background", ("boot_menu_background = %s\n"):format(tostring(game.stopped)))

	if game.stopped then
		core.game.setRealtime(0)
	else
		core.game.setRealtime(8)
	end
end

function _M:on_recover_focus()
	game:unregisterDialog(self)
	local d = new()
	game:registerDialog(d)
end
