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
	define_as = "BASE_NPC_THIEF",
	type = "humanoid", subtype = "human",
	display = "p", color=colors.BLUE,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	resolvers.drops{chance=20, nb=1, {} },
	resolvers.auto_equip_filters("Rogue"),
	resolvers.equip{
		{type="weapon", subtype="dagger", autoreq=true},
		{type="weapon", subtype="dagger", autoreq=true},
		{type="armor", subtype="light", autoreq=true}
	},
	resolvers.drops{chance=100, nb=2, {type="money"} },
	infravision = 10,

	max_stamina = 100,
	rank = 2,
	size_category = 3,

	resolvers.racial(),
	resolvers.sustains_at_birth(),

	open_door = true,

	resolvers.inscriptions(1, "infusion"),

	autolevel = "rogue",
	ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=5, },
	stats = { str=8, dex=15, mag=6, cun=15, con=7 },

	resolvers.talents{
		[Talents.T_LETHALITY]={base=1, every=6, max=5},
		[Talents.T_KNIFE_MASTERY]={base=0, every=6, max=6},
		[Talents.T_WEAPON_COMBAT]={base=0, every=6, max=6},
	},

	power_source = {technique=true},
}

newEntity{ base = "BASE_NPC_THIEF",
	name = "cutpurse", color_r=0, color_g=0, color_b=resolvers.rngrange(235, 255),
	desc = _t[[The lowest of the thieves, this cutpurse is just learning the tricks of the trade.]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	combat_armor = 1, combat_def = 5,
	max_life = resolvers.rngavg(60,80),
	resolvers.talents{  },
}

newEntity{ base = "BASE_NPC_THIEF",
	name = "rogue", color_r=0, color_g=0, color_b=resolvers.rngrange(215, 235),
	desc = _t[[Stronger than a cutpurse, this thief has been promoted.]],
	level_range = {2, nil}, exp_worth = 1,
	rarity = 1,
	combat_armor = 2, combat_def = 5,
	resolvers.talents{ [Talents.T_STEALTH]={base=1, every=6, max=7}, [Talents.T_SWITCH_PLACE]={last=8, base=0, every=6, max=5},  },
	max_life = resolvers.rngavg(70,90),
}

newEntity{ base = "BASE_NPC_THIEF",
	name = "thief", color_r=0, color_g=0, color_b=resolvers.rngrange(195, 215),
	desc = _t[[He eyes you and your belongings, then suddenly vanishes... strange, why is your pack lighter?]],
	level_range = {3, nil}, exp_worth = 1,
	rarity = 1,
	combat_armor = 3, combat_def = 5,
	resolvers.talents{
		[Talents.T_STEALTH]={base=2, every=6, max=8},
		[Talents.T_DISARM]={base=2, every=6, max=6},
		[Talents.T_APPLY_POISON]={base=0, every=6, max=5},
		[Talents.T_VILE_POISONS]={last=15, base=0, every=6, max=5},
		[Talents.T_VENOMOUS_STRIKE]={last=15, base=0, every=6, max=5},
	},
	max_life = resolvers.rngavg(70,90),
}

newEntity{ base = "BASE_NPC_THIEF", define_as = "THIEF_BANDIT",
	name = "bandit", color_r=0, color_g=0, color_b=resolvers.rngrange(175, 195),
	desc = _t[[These ruffians often employ brute force over thievery, but they are capable of stealing as well.]],
	level_range = {5, nil}, exp_worth = 1,
	rarity = 2,
	combat_armor = 4, combat_def = 6,
	resolvers.talents{
		[Talents.T_STEALTH]={base=3, every=6, max=9},
		[Talents.T_LETHALITY]={base=2, every=6, max=6},
		[Talents.T_VICIOUS_STRIKES]={base=1, every=7, max=6},
	},
	max_life = resolvers.rngavg(80,100),
}

newEntity{ base = "BASE_NPC_THIEF",
	name = "bandit lord", color_r=resolvers.rngrange(75, 85), color_g=0, color_b=resolvers.rngrange(235, 255),
	desc = _t[[He is the leader of a gang of bandits. Watch out for his underlings.]],
	level_range = {8, nil}, exp_worth = 1,
	rarity = 5,
	combat_armor = 5, combat_def = 7,
	max_life = resolvers.rngavg(90,100),
	combat = { dam=resolvers.rngavg(6,7), atk=10, apr=4},
	make_escort = {
		{type="humanoid", subtype="human", name="bandit", number=2},
		{type="humanoid", subtype="human", name="thief", number=2},
		{type="humanoid", subtype="human", name="rogue", number=2},
	},
	summon = {
		{type="humanoid", subtype="human", name="bandit", number=1, hasxp=false},
		{type="humanoid", subtype="human", name="bandit", number=1, hasxp=false},
		{type="humanoid", subtype="human", name="thief", number=1, hasxp=false},
		{type="humanoid", subtype="human", name="rogue", number=2, hasxp=false},
	},
	resolvers.talents{
		[Talents.T_STEALTH]={base=3, every=6, max=7},
		[Talents.T_SUMMON]=1,
		[Talents.T_LETHALITY]={base=3, every=6, max=6},
		[Talents.T_TOTAL_THUGGERY]={base=1, every=5, max=7},
	},
}

newEntity{ base = "BASE_NPC_THIEF", define_as = "THIEF_ASSASSIN",
	name = "assassin", color_r=resolvers.rngrange(0, 10), color_g=resolvers.rngrange(0, 10), color_b=resolvers.rngrange(0, 10),
	desc = _t[[Before you looms a pair of eyes... a glint of steel... death.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 3,
	combat_armor = 3, combat_def = 10,
	combat_critical_power = 20,
	resolvers.talents{
		[Talents.T_STEALTH]={base=3, every=6, max=7},
		[Talents.T_DUAL_WEAPON_MASTERY]={base=2, every=6, max=6},
		[Talents.T_TEMPO]={base=2, every=6, max=6},
		[Talents.T_DUAL_STRIKE]={base=1, every=6, max=6},
		[Talents.T_COUP_DE_GRACE]={base=1, every=6, max=6},
		-- [Talents.T_SHADOWSTRIKE]={base=2, every=6, max=6},
		[Talents.T_LETHALITY]={base=5, every=6, max=8},
		[Talents.T_DISARM]={base=3, every=6, max=6},
	},
	max_life = resolvers.rngavg(70,90),

	resolvers.sustains_at_birth(),
	autolevel = "rogue",
}

newEntity{ base = "BASE_NPC_THIEF", define_as = "THIEF_ASSASSIN",
	name = "shadowblade", color_r=resolvers.rngrange(0, 10), color_g=resolvers.rngrange(0, 10), color_b=resolvers.rngrange(100, 120),
	desc = _t[[Stealthy fighters trying to achieve victory with trickery. Be careful or they will steal your life!]],
	level_range = {14, nil}, exp_worth = 1,
	rarity = 4,
	combat_armor = 3, combat_def = 10,
	combat_critical_power = 20,
	resolvers.talents{
		[Talents.T_STEALTH]={base=3, every=5, max=8},
		[Talents.T_DUAL_WEAPON_MASTERY]={base=2, every=6, max=6},
		[Talents.T_TEMPO]={base=2, every=6, max=6},
		[Talents.T_DUAL_STRIKE]={base=1, every=6, max=6},
		-- [Talents.T_SHADOWSTRIKE]={base=2, every=6, max=6},
		[Talents.T_SHADOWSTEP]={base=2, every=6, max=6},
		[Talents.T_LETHALITY]={base=5, every=6, max=8},
		[Talents.T_SHADOW_LEASH]={base=1, every=6, max=6},
		[Talents.T_SHADOW_AMBUSH]={base=1, every=6, max=6},
		[Talents.T_SHADOW_COMBAT]={base=1, every=6, max=6},
		[Talents.T_SHADOW_VEIL]={last=20, base=0, every=6, max=6},
		[Talents.T_INVISIBILITY]={last=30, base=0, every=6, max=6},
	},
	max_life = resolvers.rngavg(70,90),

	resolvers.sustains_at_birth(),
	autolevel = "rogue",
	power_source = {technique=true, arcane=true},
}

newEntity{ base = "BASE_NPC_THIEF", define_as = "THIEF_SAPPER",
	name = "rogue sapper", color_r=resolvers.rngrange(0, 10), color_g=resolvers.rngrange(0, 10), color_b=resolvers.rngrange(0, 10),
	image = "npc/humanoid_human_assassin.png",
	desc = _t[[Stealthy tricksters that leave a wake of deadfalls and other hazards.  They really just make a mess of things.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 5,
	combat_armor = 3, combat_def = 10,
	ai = "tactical",
	ai_state = { ai_move="move_complex", talent_in=2},
	ai_tactic = {disable=2, defend=2, heal=2, escape=3, closein=0.5, safe_range=3},
	resolvers.talents{
		[Talents.T_STEALTH]={base=1, every=6, max=7},
		[Talents.T_UNSEEN_ACTIONS]={base=0, every=8, max=2},
		[Talents.T_SOOTHING_DARKNESS]={base=1, every=8, max=3},
		[Talents.T_HEIGHTENED_SENSES]={base=1, every=8, max=5},
		[Talents.T_DEVICE_MASTERY]={base=0, every=10, max=4},
		[Talents.T_TRAP_MASTERY]={base=1, every=5, max=5},
		[Talents.T_TRAP_LAUNCHER]={base=1, every=8, max=5},
		[Talents.T_TRAP_PRIMING]={base=-1, every=8, max=5},
		[Talents.T_DUAL_WEAPON_MASTERY]={base=1, every=8, max=5},
		[Talents.T_TEMPO]={base=1, every=8, max=5},
		[Talents.T_DUAL_STRIKE]={base=1, every=10, max=3},
		[Talents.T_DISARM]={base=0, every=8, max=5},
	},
	max_life = resolvers.rngavg(70,90),
	resolvers.sustains_at_birth(),
	autolevel = "rogue",
}
