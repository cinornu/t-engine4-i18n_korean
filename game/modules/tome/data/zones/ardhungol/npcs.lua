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

load("/data/general/npcs/spider.lua", rarity(0))

load("/data/general/npcs/all.lua", rarity(4, 35))

local Talents = require("engine.interface.ActorTalents")

newEntity{ define_as = "UNGOLE", base = "BASE_NPC_SPIDER",
	allow_infinite_dungeon = true,
	name = "Ungolë", color=colors.VIOLET, unique = true,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/spiderkin_spider_ungole.png", display_h=2, display_y=-1}}},
	desc = _t[[A huge spider, shrouded in darkness, her red glowing eyes darting to fix on you. She looks hungry.]],
	killer_message = _t"and devoured alongside a Sun Paladin",
	level_range = {30, nil}, exp_worth = 2,
	female = 1,
	max_life = 450, life_rating = 15, fixed_rating = true,
	stats = { str=25, dex=10, cun=47, mag=10, con=20 },
	rank = 4,
	size_category = 4,
	move_others=true,
	infravision = 10,
	instakill_immune = 1,

	combat_armor = 17, combat_def = 17,
	resists = { [DamageType.FIRE] = 20, [DamageType.ACID] = 20, [DamageType.COLD] = 20, [DamageType.LIGHTNING] = 20, },

	combat = { dam=resolvers.levelup(resolvers.rngavg(40,58), 1, 1), atk=16, apr=9, damtype=DamageType.NATURE, dammod={str=0.8} },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	resolvers.drops{chance=100, nb=5, {tome_drops="boss"} },
	resolvers.drops{chance=100, nb=1, {defined="ROD_SPYDRIC_POISON"} },
	resolvers.drops{chance=100, nb=1, {unique=true} },
	resolvers.drops{chance=100, nb=1, {defined="NOTE4"} },

	resolvers.talents{
		[Talents.T_KNOCKBACK]={base=4, every=5, max=7},
		[Talents.T_DARKNESS]={base=5, every=5, max=8},
		[Talents.T_SPIT_POISON]={base=5, every=5, max=8},
		[Talents.T_SPIDER_WEB]={base=5, every=5, max=8},
		[Talents.T_LAY_WEB]={base=5, every=5, max=8},

		[Talents.T_CORROSIVE_VAPOUR]={base=5, every=5, max=8},
		[Talents.T_PHANTASMAL_SHIELD]={base=5, every=5, max=8},
	},
	resolvers.sustains_at_birth(),

	ai = "tactical", ai_state = { talent_in=1, ai_move="move_astar", },
	resolvers.inscriptions(5, "infusion"),

	on_die = function(self, who)
		local Chat = require"engine.Chat"
		local chat = Chat.new("ardhungol-end", {name=_t"Sun Paladin Rashim"}, game.player:resolveSource())
		chat:invoke()
	end,
}

-- Now a couple humanoid spiderkins because ... well, you'll see later !
newEntity{ base = "BASE_NPC_SPIDER",
	subtype = "xhaiak", name = "xhaiak arachnomancer", color={0,0,0},  -- spider night, don't change the color
	desc = _t[[A strange looking humanoid spiderkin, its body half covered by a light flowing robe. It looks like tiny spiders are crawling on his skin.]],
	resolvers.nice_tile{tall=1},
	level_range = {38, nil}, exp_worth = 1,
	rarity = 2,
	max_life = 110,
	life_rating = 16,
	rank = 3,

	ai = "tactical",
	ai_tactic = resolvers.tactic"ranged",

	make_escort = {
		{type = "spiderkin", subtype = "spider", number=2, no_subescort=true},
	},
	summon = {
		{type = "spiderkin", subtype = "spider", number=3, hasxp=false},
	},

	resolvers.talents{
		[Talents.T_SUMMON]=1,
		[Talents.T_ENDLESS_WOES]=1,
		[Talents.T_SPIDER_WEB]={base=5, every=6, max=8},
		[Talents.T_DARKNESS]={base=5, every=6, max=8},
		[Talents.T_INVOKE_DARKNESS]={base=3, every=6, max=6},
		[Talents.T_STARFALL]={base=4, every=6, max=8},
	},
}

newEntity{ base = "BASE_NPC_SPIDER",
	subtype = "shiaak", name = "shiaak venomblade", color=colors.GREEN,
	desc = _t[[A strange looking humanoid, covered in black chitinous skin. He dual wields sinuous daggers and seems bent on plunging them in your body.]],
	resolvers.nice_tile{tall=1},
	level_range = {35, nil}, exp_worth = 1,
	rarity = 4,
	max_life = 120,
	life_rating = 19,
	rank = 2,

	ai = "tactical",
	ai_tactic = resolvers.tactic"melee",

	combat_armor = 2, combat_def = 12,
	combat_critical_power = 20,
	resolvers.equip{
		{type="weapon", subtype="dagger", autoreq=true},
		{type="weapon", subtype="dagger", autoreq=true},
		{type="armor", subtype="light", autoreq=true}
	},
	resolvers.talents{
		[Talents.T_KNIFE_MASTERY]={base=2, every=10, max=5},
		[Talents.T_STEALTH]=5,
		[Talents.T_LETHALITY]=4,
		-- [Talents.T_SHADOWSTRIKE]={base=3, every=6, max=5},
		[Talents.T_APPLY_POISON]={base=2, every=8, max=5},
		[Talents.T_VENOMOUS_STRIKE]={last=15, base=0, every=6, max=5},
		[Talents.T_VILE_POISONS]={base=2, every=6, max=5},
	},
}
