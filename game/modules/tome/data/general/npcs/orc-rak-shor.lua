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

newEntity{
	define_as = "BASE_NPC_ORC_RAK_SHOR",
	type = "humanoid", subtype = "orc",
	display = "o", color=colors.DARK_GREY,
	faction = "orc-pride", pride = "rak-shor",

	combat = { dam=resolvers.rngavg(5,12), atk=2, apr=6, physspeed=2 },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1, TOOL=1 },
	resolvers.drops{chance=20, nb=1, {} },
	resolvers.drops{chance=10, nb=1, {type="money"} },
	resolvers.auto_equip_filters("Necromancer"),
	infravision = 10,
	lite = 1,

	life_rating = 11,
	rank = 2,
	size_category = 3,

	resolvers.racial(),

	open_door = true,
	resolvers.inscriptions(3, "rune"),

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=1, },
	stats = { str=20, dex=8, mag=6, con=16 },
	ingredient_on_death = "ORC_HEART",
}

newEntity{ base = "BASE_NPC_ORC_RAK_SHOR",
	name = "orc necromancer", color=colors.DARK_GREY,
	desc = _t[[An orc dressed in black robes. He mumbles in a harsh tongue.]],
	level_range = {25, nil}, exp_worth = 1,
	rarity = 1,
	max_life = resolvers.rngavg(70,80), life_rating = 7,
	resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
	},
	combat_armor = 0, combat_def = 5,

	soul = 10,

	resolvers.talents{
		[Talents.T_HIEMAL_SHIELD]={base=2, every=7, max=7},
		[Talents.T_DESOLATE_WASTE]={last=25, base=0, every=7, max=7},
		[Talents.T_BLEAK_GUARD]={last=30, base=0, every=7, max=7},
		[Talents.T_BLURRED_MORTALITY]={base=3, every=5, max=7},
		[Talents.T_SOUL_LEECH]={base=2, every=8, max=5},
		[Talents.T_STAFF_MASTERY]={base=2, every=8, max=5},
	},
	resolvers.rngtalentsets{
		-- Skeleton theme
		{
			[Talents.T_CALL_OF_THE_CRYPT]={base=5, every=5, max=9},
			[Talents.T_ASSEMBLE]={base=3, every=5, max=7},
			[Talents.T_LORD_OF_SKULLS]={last=25, base=0, every=5, max=7},
			[Talents.T_NECROTIC_AURA]={base=1, every=5, max=7},
			[Talents.T_SURGE_OF_UNDEATH]={base=3, every=5, max=7},
			[Talents.T_RECALL_MINIONS]={base=3, every=5, max=7},
		},
		-- Ghoul theme
		{
			[Talents.T_CALL_OF_THE_MAUSOLEUM]={base=5, every=5, max=9},
			[Talents.T_CORPSE_EXPLOSION]={base=3, every=5, max=7},
			[Talents.T_PUTRESCENT_LIQUEFACTION]={last=25, base=0, every=5, max=7},
			[Talents.T_NECROTIC_AURA]={base=1, every=5, max=7},
			[Talents.T_SURGE_OF_UNDEATH]={base=3, every=5, max=7},
			[Talents.T_SUFFER_FOR_ME]={base=3, every=5, max=7},
		},
		-- Darkness theme
		{
			[Talents.T_INVOKE_DARKNESS]={base=5, every=5, max=9},
			[Talents.T_CIRCLE_OF_DEATH]={base=3, every=5, max=7},
			[Talents.T_ERUPTING_SHADOWS]={last=25, base=0, every=5, max=7},
			[Talents.T_RIVER_OF_SOULS]={last=40, base=0, every=5, max=7},
			[Talents.T_DREAD]={base=3, every=5, max=7},
			[Talents.T_CREPUSCULE]={base=3, every=5, max=7},
		},
		-- Cold theme
		{
			[Talents.T_CHILL_OF_THE_TOMB]={base=5, every=5, max=9},
			[Talents.T_BLACK_ICE]={base=3, every=5, max=7},
			[Talents.T_CORPSELIGHT]={base=3, every=5, max=7},
			[Talents.T_RIME_WRAITH]={base=3, every=5, max=7},
			[Talents.T_FRIGID_PLUNGE]={base=3, every=5, max=7},
			[Talents.T_PERMAFROST]={base=3, every=5, max=7},
		},
	},
	resolvers.sustains_at_birth(),
}

newEntity{ base = "BASE_NPC_ORC_RAK_SHOR",
	name = "orc blood mage", color=colors.CRIMSON,
	desc = _t[[An orc dressed in blood-stained robes. He mumbles in a harsh tongue.]],
	level_range = {27, nil}, exp_worth = 1,
	rarity = 2,
	max_life = resolvers.rngavg(110,120), life_rating = 12,
	resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
	},
	combat_armor = 0, combat_def = 5,

	-- Nullify their cooldowns
	talent_cd_reduction={[Talents.T_SOUL_ROT]=2, [Talents.T_BLOOD_GRASP]=4, },

	resolvers.talents{
		[Talents.T_SOUL_ROT]={base=5, every=10, max=8},
		[Talents.T_BLOOD_GRASP]={base=5, every=10, max=8},
		[Talents.T_STAFF_MASTERY]={base=3, every=8, max=5},
		[Talents.T_CURSE_OF_VULNERABILITY]={base=5, every=10, max=8},
	},
	resolvers.sustains_at_birth(),
}

newEntity{ base = "BASE_NPC_ORC_RAK_SHOR",
	name = "orc corruptor", color=colors.GREY,
	desc = _t[[An orc dressed in putrid robes. He mumbles in a harsh tongue.]],
	level_range = {27, nil}, exp_worth = 1,
	rarity = 4,
	rank = 3,
	max_life = resolvers.rngavg(160,180), life_rating = 15,
	resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
		{type="charm", forbid_power_source={antimagic=true, nature=true}, autoreq=true}
	},
	combat_armor = 0, combat_def = 5,

	ai = "tactical",
	ai_tactic = resolvers.tactic"ranged",

	inc_damage = { [DamageType.BLIGHT] = resolvers.mbonus(20, 10) },

	resolvers.talents{
		[Talents.T_SOUL_ROT]={base=5, every=10, max=8},
		[Talents.T_BLOOD_GRASP]={base=5, every=10, max=8},
		[Talents.T_STAFF_MASTERY]={base=3, every=8, max=5},
		[Talents.T_CURSE_OF_VULNERABILITY]={base=5, every=10, max=8},
		[Talents.T_BLIGHTZONE]={base=3, every=10, max=6},
		[Talents.T_BONE_SHIELD]={base=5, every=150, max=8},
		[Talents.T_BLOOD_SPRAY]={base=4, every=10, max=8},
	},
	resolvers.sustains_at_birth(),
}
