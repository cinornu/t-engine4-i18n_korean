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

module(..., package.seeall, class.make)

_M.slots_multiple = {
	MAINHAND = false,
	OFFHAND = false,
	BODY = false,
	CLOAK = false,
	HEAD = false,
	HANDS = false,
	FEET = false,
	QUIVER = false,
	SHIMMER_DOLL = false,
	SHIMMER_HAIR = false,
	SHIMMER_FACIAL = false,
	SHIMMER_AURA = false,
}

function _M:getShimmerName(actor, slot)
	if slot == "SHIMMER_DOLL" then return _t"Character's Skin"
	elseif slot == "SHIMMER_HAIR" then return _t"Character's Hair"
	elseif slot == "SHIMMER_FACIAL" then return _t"Character's Facial Features"
	elseif slot == "SHIMMER_AURA" then return _t"Character's Aura"
	else
		local object = actor:getInven(slot)[1]
		if not object then return _t"unknown" end
		return object:getName{do_color=true, no_add_name=true}
	end
end

function _M:applyShimmers(actor, v1, v2)
	local list
	if not v1 then return end
	if type(v1) == "table" then list = v1
	else list = {[v1] = v2} end

	actor.shimmer_current_outfit = actor.shimmer_current_outfit or {}

	for slot, id in pairs(list) do if slot ~= "set_name" then
		actor.shimmer_current_outfit[slot] = actor.shimmer_current_outfit[slot] or {}
		actor.shimmer_current_outfit[slot] = id

		local unlocked = world.unlocked_shimmers and world.unlocked_shimmers[slot] or {}
		if slot == "MAINHAND" or slot == "OFFHAND" then
			unlocked = table.clone(world.unlocked_shimmers and world.unlocked_shimmers.MAINHAND or {})
			for k, e in pairs(world.unlocked_shimmers and world.unlocked_shimmers.OFFHAND or {}) do unlocked[k] = e end
		end

		local shimmer = unlocked[id]
		if shimmer then shimmer = shimmer.moddables end
		if shimmer then shimmer = table.clone(shimmer, true) end
		if shimmer then shimmer.name = id end

		if slot == "SHIMMER_DOLL" then
			if not shimmer then actor.moddable_tile_base_shimmer = nil
			else actor.moddable_tile_base_shimmer = shimmer.moddable_tile end
		elseif slot == "SHIMMER_HAIR" then
			if not shimmer then actor.moddable_tile_base_shimmer_hair = nil
			else actor.moddable_tile_base_shimmer_hair = shimmer.moddable_tile end
		elseif slot == "SHIMMER_FACIAL" then
			if not shimmer then actor.moddable_tile_base_shimmer_facial = nil
			else actor.moddable_tile_base_shimmer_facial = shimmer.moddable_tile end
		elseif slot == "SHIMMER_AURA" then
			if not shimmer then actor.moddable_tile_base_shimmer_aura = nil
			else actor.moddable_tile_base_shimmer_aura = shimmer.moddable_tile end
			if not shimmer then actor.moddable_tile_base_shimmer_particle = nil
			else actor.moddable_tile_base_shimmer_particle = shimmer.moddable_tile2 end
		else
			local object = actor:getInven(slot)
			if object then object = object[1] end
			if object then
				object.shimmer_moddable = shimmer or {name=_t"#GREY#Invisible#LAST#"}
			end
		end
	end end
	actor:updateModdableTile()
end
