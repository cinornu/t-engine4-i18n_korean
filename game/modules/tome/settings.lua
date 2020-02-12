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

if config.settings.tome_init_settings_ran then return end
config.settings.tome_init_settings_ran = true

-- Init settings
config.settings.tome = config.settings.tome or {}
profile.mod.allow_build = profile.mod.allow_build or {}
--if type(config.settings.tome.autosave) == "nil" then
config.settings.tome.autosave = true
--end
if not config.settings.tome.smooth_move then config.settings.tome.smooth_move = 3 end
if type(config.settings.tome.twitch_move) == "nil" then config.settings.tome.twitch_move = true end
if not config.settings.tome.gfx then
	local w, h = core.display.size()
	config.settings.tome.gfx = {size="64x64", tiles="shockbolt"}
	if w >= 1000 then config.settings.tome.gfx = {size="64x64", tiles="shockbolt"}
	else config.settings.tome.gfx = {size="48x48", tiles="shockbolt"}
	end
end
if config.settings.tome.gfx.tiles == "mushroom" then config.settings.tome.gfx.tiles="shockbolt" end
if type(config.settings.tome.weather_effects) == "nil" then config.settings.tome.weather_effects = true end
if type(config.settings.tome.smooth_fov) == "nil" then config.settings.tome.smooth_fov = true end
if type(config.settings.tome.daynight) == "nil" then config.settings.tome.daynight = true end
if type(config.settings.tome.hotkey_icons) == "nil" then config.settings.tome.hotkey_icons = true end
if type(config.settings.tome.effects_icons) == "nil" then config.settings.tome.effects_icons = true end
if type(config.settings.tome.autoassign_talents_on_birth) == "nil" then config.settings.tome.autoassign_talents_on_birth = true end
if type(config.settings.tome.chat_log) == "nil" then config.settings.tome.chat_log = true end
if type(config.settings.tome.actor_based_movement_mode) == "nil" then config.settings.tome.actor_based_movement_mode = true end
if type(config.settings.tome.rest_before_explore) == "nil" then config.settings.tome.rest_before_explore = true end
if type(config.settings.tome.lore_popup) == "nil" then config.settings.tome.lore_popup = true end
if type(config.settings.tome.auto_hotkey_object) == "nil" then config.settings.tome.auto_hotkey_object = true end
if type(config.settings.tome.visual_hotkeys) == "nil" then config.settings.tome.visual_hotkeys = true end
if type(config.settings.tome.talents_flyers) == "nil" then config.settings.tome.talents_flyers = false end
if type(config.settings.tome.immediate_melee_keys) == "nil" then config.settings.tome.immediate_melee_keys = true end
if type(config.settings.tome.immediate_melee_keys_auto) == "nil" then config.settings.tome.immediate_melee_keys_auto = true end
if type(config.settings.tome.small_frame_side) == "nil" then config.settings.tome.small_frame_side = true end
if type(config.settings.tome.fullscreen_stun) == "nil" then config.settings.tome.fullscreen_stun = true end
if type(config.settings.tome.fullscreen_confusion) == "nil" then config.settings.tome.fullscreen_confusion = true end
if type(config.settings.tome.show_grid_lines) == "nil" then config.settings.tome.show_grid_lines = false end
if type(config.settings.tome.tinker_auto_switch) == "nil" then config.settings.tome.tinker_auto_switch = true end
if type(config.settings.tome.quest_popup) == "nil" then config.settings.tome.quest_popup = true end
if type(config.settings.tome.show_cloak_hoods) == "nil" then config.settings.tome.show_cloak_hoods = false end
if type(config.settings.tome.upload_charsheet) == "nil" then config.settings.tome.upload_charsheet = true end
if not config.settings.tome.fonts then config.settings.tome.fonts = {type="fantasy", size="normal"} end
if not config.settings.tome.ui_theme3 then config.settings.tome.ui_theme3 = "dark" end
if not config.settings.tome.uiset_mode then config.settings.tome.uiset_mode = "Minimalist" end
if not config.settings.tome.log_lines then config.settings.tome.log_lines = 5 end
if not config.settings.tome.log_fade then config.settings.tome.log_fade = 3 end
if not config.settings.tome.scroll_dist then config.settings.tome.scroll_dist = 50 end
if not config.settings.tome.hotkey_icons_rows then config.settings.tome.hotkey_icons_rows = 1 end
if not config.settings.tome.hotkey_icons_size then config.settings.tome.hotkey_icons_size = 48 end

print("[TOME] Loaded default settings")
