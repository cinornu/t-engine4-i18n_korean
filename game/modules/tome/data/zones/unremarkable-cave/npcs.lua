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

load("/data/general/npcs/rodent.lua", rarity(0))
load("/data/general/npcs/vermin.lua", rarity(0))
load("/data/general/npcs/molds.lua", rarity(0))
load("/data/general/npcs/skeleton.lua", rarity(0))
load("/data/general/npcs/snake.lua", rarity(0))

load("/data/general/npcs/all.lua", rarity(0, 10))

local Talents = require("engine.interface.ActorTalents")

newEntity{ define_as = "FILLAREL",
	type = "humanoid", subtype = "elf", unique = true,
	name = "Fillarel Aldaren", faction = "neutral",
	display = "@", color=colors.GOLD,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_elf_fillarel_aldaren.png", display_h=2, display_y=-1}}},
	desc = _t[[An Elven woman. She wears a tight robe decorated with symbols of the Sun and the Moon and wields a staff.]],
	level_range = {25, nil}, exp_worth = 2,
	female = 1,
	max_life = 120, life_rating = 15, fixed_rating = true,
	positive_regen = 10,
	negative_regen = 10,
	rank = 4,
	size_category = 3,
	infravision = 10,
	stats = { str=10, dex=22, cun=25, mag=20, con=12 },
	instakill_immune = 1,
	teleport_immune = 1,
	move_others=true,
	never_anger=true,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=100, nb=3, {tome_drops="boss"} },

	resolvers.talents{
		[Talents.T_STAFF_MASTERY]={base=2, every=8},
		[Talents.T_MOONLIGHT_RAY]={base=4, every = 10},
		[Talents.T_STARFALL]={base=5, every = 8},
		[Talents.T_SHADOW_BLAST]={base=3, every = 10},
		[Talents.T_SEARING_LIGHT]={base=4, every = 8},
		[Talents.T_FIREBEAM]={base=4, every = 8},
		[Talents.T_SUNBURST]={base=3, every = 10},
		[Talents.T_HYMN_OF_SHADOWS]={base=2, every = 6},
		[Talents.T_CHANT_OF_FORTITUDE]={base=2, every = 6},
	},
	resolvers.sustains_at_birth(),

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { talent_in=1, ai_move="move_astar" },

	on_added = function(self)
		self.energy.value = game.energy_to_act self:useTalent(self.T_HYMN_OF_SHADOWS)
		self.energy.value = game.energy_to_act self:useTalent(self.T_CHANT_OF_FORTITUDE)
	end,

	on_die = function(self, who)
		game.player:hasQuest("strange-new-world"):fillarel_dies(self)
	end,

	seen_by = function(self, who)
		if not self.has_been_seen and who.player then
			for uid, act in pairs(game.level.entities) do
				if act.name == "Krogar" then
					local Chat = require("engine.Chat")
					local chat = Chat.new("unremarkable-cave-bosses", self, who)
					chat:invoke()
					break
				end
			end
			self.seen_by = nil
			self.has_been_seen = true
		end
	end,

	can_talk = "unremarkable-cave-fillarel",
	can_talk_only_once = true,
}

newEntity{ define_as = "CORRUPTOR",
	type = "humanoid", subtype = "orc", unique = true,
	name = "Krogar", faction = "neutral",
	display = "@", color=colors.GREEN,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_orc_krogar.png", display_h=2, display_y=-1}}},
	desc = _t[[An orc clad in mail armour, he wields a staff and looks menacing.]],
	level_range = {25, nil}, exp_worth = 2,
	max_life = 120, life_rating = 15, fixed_rating = true,
	positive_regen = 10,
	negative_regen = 10,
	rank = 4,
	size_category = 3,
	stats = { str=10, dex=22, cun=25, mag=20, con=12 },
	instakill_immune = 1,
	teleport_immune = 1,
	move_others=true,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="heavy", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=100, nb=3, {tome_drops="boss"} },
	resolvers.drops{chance=100, nb=1, {type="jewelry", subtype="orb", defined="ORB_MANY_WAYS"} },

	resolvers.talents{
		[Talents.T_STAFF_MASTERY]={base=2, every=8},
		[Talents.T_ARMOUR_TRAINING]={base=2, every=7},
		[Talents.T_MOONLIGHT_RAY]={base=4, every=10},
		[Talents.T_STARFALL]={base=5, every=10},
		[Talents.T_SHADOW_BLAST]={base=3, every=8},
		[Talents.T_SEARING_LIGHT]={base=4, every=8},
		[Talents.T_FIREBEAM]={base=4, every=10},
		[Talents.T_SUNBURST]={base=3, every=10},
		[Talents.T_HYMN_OF_SHADOWS]={base=2, every=8},
		[Talents.T_CHANT_OF_FORTITUDE]={base=2, every=7},
	},
	resolvers.sustains_at_birth(),

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { talent_in=1, ai_move="move_astar" },

	on_die = function(self, who)
		game.player:hasQuest("strange-new-world"):krogar_dies(self)
	end,

	can_talk = "unremarkable-cave-krogar",
}
