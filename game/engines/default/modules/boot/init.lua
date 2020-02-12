-- ToME - Tales of Middle-Earth
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

name = "Boot"
long_name = "Tales of Maj'Eyal Main Menu"
short_name = "boot"
author = { "DarkGod", "darkgod@te4.org" }
homepage = "http://te4.org/"
is_boot = true
version = {1,0,0}
engine = {1,0,1,"te4"}
description = [[
Bootmenu!
]]
starter = "mod.load"
publisher_logo = "netcore-logo"
show_funfacts = true
loading_wait_ticks = 1600
allow_userchat = {"mainmenu"} -- We can talk to the online community but not join any channel
if not config.settings.censor_boot then background_name = {"tome","tome2","tome3"}
else background_name = {"tome3"}
end
if config.settings.unlock_background_linaniil then background_name[#background_name+1] = "cards/linaniil" end
if config.settings.unlock_background_master then background_name[#background_name+1] = "cards/master" end
if config.settings.unlock_background_garkul then background_name[#background_name+1] = "cards/garkul" end
if config.settings.unlock_background_aeryn then background_name[#background_name+1] = "cards/aeryn" end
if config.settings.unlock_background_myssil then background_name[#background_name+1] = "cards/myssil" end
if config.settings.unlock_background_derth then background_name[#background_name+1] = "cards/derth" end
if config.settings.unlock_background_fortress then background_name[#background_name+1] = "cards/fortress" end
if config.settings.unlock_background_urkis then background_name[#background_name+1] = "cards/urkis" end
keep_background_texture = true

font_package_id = function() config.settings.tome = config.settings.tome or {} if not config.settings.tome.fonts then config.settings.tome.fonts = {type="fantasy", size="normal"} end return config.settings.tome.fonts.type end
font_package_size = function() config.settings.tome = config.settings.tome or {} if not config.settings.tome.fonts then config.settings.tome.fonts = {type="fantasy", size="normal"} end return config.settings.tome.fonts.size end
