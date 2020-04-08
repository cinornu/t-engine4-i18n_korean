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

local Talents = require("engine.interface.ActorTalents")

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}

local turret = function()
   local NPC = require "mod.class.NPC"
   local m = NPC.new{
	type = "construct", subtype = "crystal", image="trap/trap_beam.png",
	display = "t",
	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	life_rating = 20,
	rank = 2,
	inc_damage = { all = -75, },

	open_door = true,
	cut_immune = 1,
	blind_immune = 1,
	fear_immune = 1,
	poison_immune = 1,
	disease_immune = 1,
	stone_immune = 1,
	see_invisible = 30,
	no_breath = 1,
	infravision = 10,
	never_move = 1,

	autolevel = "caster",
	level_range = {1, nil}, exp_worth = 1,
	stats = { mag=16, con=22 },
	size_category = 2,
	name = _t"arcane crystal", color=colors.BLUE,
	combat = { dam=resolvers.rngavg(1,2), atk=2, apr=0, dammod={str=0.4} },
	combat_armor = 10, combat_def = 0,
	talent_cd_reduction={[Talents.T_ELEMENTAL_BOLT]=3, },

	resolvers.talents{
		[Talents.T_ELEMENTAL_BOLT]={base=3, every=3, max=8},
	},

	ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=3, },
   }
   return m
end

specialList("actor", {
   "/data/general/npcs/skeleton.lua",
})
specialList("terrain", {
   "/data/general/grids/water.lua",
   "/data/general/grids/forest.lua",
}, true)
border = 0
--rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('>', "DYNAMIC_ZONE_EXIT")


defineTile('b', "FLOOR", {random_filter={add_levels=20, tome_mod="gvault"}}, {random_filter={add_levels=5, name="skeleton magus"}})
defineTile('$', "FLOOR", {random_filter={add_levels=25, type="money"}})
defineTile('j', "FLOOR", {random_filter={add_levels=10, type="jewelry", tome_mod="gvault"}})
defineTile('t', "FLOOR", {random_filter={add_levels=5, tome_mod="gvault"}}, turret())

local def = {
[[##############]],
[[#tjj##########]],
[[#b$$##########]],
[[##.##t$..t####]],
[[#t.+...>..####]],
[[##.##...$.####]],
[[#b$$#$...t####]],
[[#tjj##########]],
[[##############]],
}

return def
