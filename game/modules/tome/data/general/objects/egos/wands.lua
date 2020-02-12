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

local Talents = require "engine.interface.ActorTalents"
local DamageType = require "engine.DamageType"

load("/data/general/objects/egos/charms.lua")

newEntity{
	name = "warded ", prefix=true, second=true,
	keywords = {ward=true},
	level_range = {20, 50},
	rarity = 12,
	greater_ego = 1,
	cost = 5,
	wielder = {
		wards = {},
		resolvers.genericlast(function(e)
			local types = {"FIRE", "LIGHTNING", "COLD", "ACID", "MIND", "ARCANE", "BLIGHT", "NATURE", "TEMPORAL", "LIGHT", "DARKNESS"}
			local wards = {}
			for _ = 1,4 do
				local pick = rng.tableRemove(types)
				e.wielder.wards[pick] = resolvers.mbonus_material(4, 2)
			end
		end),
		learn_talent = {[Talents.T_WARD] = 1},
	},
}
