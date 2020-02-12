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

load("/data/general/npcs/skeleton.lua", rarity(0))
load("/data/general/npcs/ghoul.lua", rarity(0))
load("/data/general/npcs/ghost.lua", rarity(4))
load("/data/general/npcs/bone-giant.lua", rarity(3))

load("/data/general/npcs/all.lua", rarity(4, 35))

local Talents = require("engine.interface.ActorTalents")

newEntity{ define_as = "SHADE_OF_TELOS",
	allow_infinite_dungeon = true,
	type = "undead", subtype = "ghost", unique = true,
	name = "The Shade of Telos",
	display = "G", color=colors.VIOLET,
	desc = _t[[Everybody thought Telos dead and his spirit destroyed, but it seems he still lingers in his old place of power.]],
	killer_message = _t"and was savagely mutilated, a show of his rage towards all living things",
	not_power_source = {nature=true},
	level_range = {38, nil}, exp_worth = 3,
	max_life = 250, life_rating = 22, fixed_rating = true,
	rank = 4,
	size_category = 3,
	infravision = 10,
	stats = { str=1, dex=14, cun=34, mag=25, con=10 },

	combat_def = 40, combat_armor = 30,

	undead = 1,
	no_breath = 1,
	stone_immune = 1,
	confusion_immune = 1,
	fear_immune = 1,
	teleport_immune = 0.5,
	disease_immune = 1,
	poison_immune = 1,
	stun_immune = 1,
	blind_immune = 1,
	see_invisible = 80,
	move_others=true,

	can_pass = {pass_wall=70},
	resists = {all = 25, [DamageType.COLD] = 100, [DamageType.ACID] = 100},

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, },
	resolvers.auto_equip_filters("Archmage"),
	resolvers.equip{
		{type="weapon", subtype="staff", defined="TELOS_TOP_HALF", random_art_replace={chance=75}, autoreq=true},
		{type="weapon", subtype="staff", defined="TELOS_BOTTOM_HALF", autoreq=true,
			replace_unique={not_properties={"slot_forbid"}, forbid_power_source={antimagic=true}, special=function(e) return e.slot == "OFFHAND" or e.offslot == "OFFHAND" end}
		},
	},
	resolvers.drops{chance=100, nb=4, {tome_drops="boss"} },

	resolvers.talents{
		[Talents.T_STAFF_MASTERY]= {base=4, every=8, max=6},
		[Talents.T_ICE_SHARDS]={base=5, every=8, max=6},
		[Talents.T_FREEZE]={base=5, every=8, max=6},
		[Talents.T_TIDAL_WAVE]={base=5, every=8, max=6},
		[Talents.T_ICE_STORM]={base=5, every=8, max=6},
		[Talents.T_UTTERCOLD]={base=8, every=8, max=10},
		[Talents.T_FROZEN_GROUND]={base=5, every=8, max=6},
		[Talents.T_SHATTER]={base=5, every=8, max=6},
		[Talents.T_GLACIAL_VAPOUR]={base=5, every=8, max=6},
		[Talents.T_CURSE_OF_IMPOTENCE]={base=5, every=8, max=6},
		[Talents.T_VIRULENT_DISEASE]={base=5, every=8, max=6},
	},

	autolevel = "caster",
	ai = "tactical", ai_state = { ai_target="target_player", talent_in=1, ai_move="move_astar", },
	resolvers.inscriptions(4, "rune"),
	resolvers.inscriptions(1, {"manasurge rune"}),

	on_die = function(self, who)
		require("engine.ui.Dialog"):simpleLongPopup(_t"Back and there again", _t'As the shade dissipates, you see no sign of the text entitled "Inverted and Reverted Probabilistic Fields". You should go back to Tannen.', 400)
	end,
}
