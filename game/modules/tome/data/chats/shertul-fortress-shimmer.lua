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

local ShimmerRemoveSustains = require("mod.dialogs.shimmer.ShimmerRemoveSustains")

local function shimmer(player, slot)
	return function()
		package.loaded['mod.dialogs.shimmer.CommonData'] = nil
		package.loaded['mod.dialogs.shimmer.Shimmer'] = nil
		local d = require("mod.dialogs.shimmer.Shimmer").new(player, slot)
		game:registerDialog(d)
	end
end

local function shimmer_other(player, slot)
	return function()
		package.loaded['mod.dialogs.shimmer.CommonData'] = nil
		package.loaded['mod.dialogs.shimmer.ShimmerOther'] = nil
		local d = require("mod.dialogs.shimmer.ShimmerOther").new(player, slot)
		game:registerDialog(d)
	end
end

local function sustains_aura_remove(player)
	return function()
		package.loaded['mod.dialogs.shimmer.CommonData'] = nil
		package.loaded['mod.dialogs.shimmer.ShimmerRemoveSustains'] = nil
		local d = require("mod.dialogs.shimmer.ShimmerRemoveSustains").new(player)
		game:registerDialog(d)
	end
end

local function shimmer_outfits(player)
	return function()
		package.loaded['mod.dialogs.shimmer.CommonData'] = nil
		package.loaded['mod.dialogs.shimmer.ShimmerOutfits'] = nil
		local d = require("mod.dialogs.shimmer.ShimmerOutfits").new(player)
		game:registerDialog(d)
	end
end

local answers = {}

for slot, inven in pairs(player.inven) do
	if player.inven_def[slot].infos and player.inven_def[slot].infos.shimmerable and inven[1] then
		local o = inven[1]
		if o.slot then
			answers[#answers+1] = {("[Alter the appearance of %s]"):tformat(o:getName{do_color=true, no_add_name=true}), action=shimmer(player, slot), jump="welcome"}
		end
	end
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_DOLL then
	answers[#answers+1] = {_t"[Alter the appearance of your body]", action=shimmer_other(player, "SHIMMER_DOLL"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_FACIAL then
	answers[#answers+1] = {_t"[Alter the appearance of your facial features]", action=shimmer_other(player, "SHIMMER_FACIAL"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_HAIR then
	answers[#answers+1] = {_t"[Alter the appearance of your hair]", action=shimmer_other(player, "SHIMMER_HAIR"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_AURA then
	answers[#answers+1] = {_t"[Alter the appearance of your cosmetic aura]", action=shimmer_other(player, "SHIMMER_AURA"), jump="welcome"}
end

answers[#answers+1] = {_t"[Load/Save outfit]", action=shimmer_outfits(player), jump="welcome"}

if ShimmerRemoveSustains:hasRemovableAuras(player) then
	answers[#answers+1] = {_t"[Disable the visual effects of your sustains]", action=sustains_aura_remove(player), jump="welcome"}
end

answers[#answers+1] = {_t"[Leave the mirror alone]"}
	
newChat{ id="welcome",
	text = _t[[*#LIGHT_GREEN#As you gaze into the mirror you see an infinite number of slightly different reflections of yourself. You feel dizzy.#WHITE#*]],
	answers = answers
}

return "welcome"
