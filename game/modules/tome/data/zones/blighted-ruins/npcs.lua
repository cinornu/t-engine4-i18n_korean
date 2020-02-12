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

load("/data/general/npcs/rodent.lua", rarity(1))
load("/data/general/npcs/vermin.lua", rarity(2))
load("/data/general/npcs/ghoul.lua", rarity(3))
load("/data/general/npcs/skeleton.lua", rarity(1))
load("/data/general/npcs/bone-giant.lua", function(e) e.rarity = nil end)
load("/data/general/npcs/horror-undead.lua", function(e) e.rarity = nil end)

local Talents = require("engine.interface.ActorTalents")

newEntity{
	define_as = "NECROMANCER",
	type = "humanoid", subtype = "human",
	display = "p", color=colors.DARK_GREY,
	name = "Necromancer", color=colors.DARK_GREY,
	desc = _t[[A Human dressed in black robes. He mumbles in a harsh tongue. He seems to think you are his slave.]],
	level_range = {1, nil}, exp_worth = 1,

	combat = { dam=resolvers.rngavg(5,12), atk=2, apr=6, physspeed=2 },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, CLOAK=1, QUIVER=1 },
	resolvers.drops{chance=20, nb=1, {} },
	resolvers.drops{chance=10, nb=1, {type="money"} },
	infravision = 10,
	lite = 2,

	rank = 2,
	size_category = 2,

	open_door = true,

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=1, },
	stats = { str=10, dex=8, mag=16, con=6 },

	max_life = resolvers.rngavg(70,80), life_rating = 7,
	resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloak", defined="CLOAK_DECEPTION", autoreq=true},
	},

	resolvers.talents{
		[Talents.T_STAFF_MASTERY]={base=1, every=10, max=5},
		[Talents.T_SOUL_ROT]={base=1, every=5, max=5},
	},

	die = function(self, src)
		self.die = function() end
		local Chat = require "engine.Chat"
		local chat = Chat.new("undead-start-kill", self, game.player)
		chat:invoke()
	end,
}

newEntity{ base = "BASE_NPC_BONE_GIANT", define_as = "HALF_BONE_GIANT",
	allow_infinite_dungeon = true,
	name = "Half-Finished Bone Giant", color=colors.VIOLET, unique=true,
	desc = _t[[A towering creature, made from the bones of hundreds of dead bodies. It is covered by an unholy aura.
This specimen looks like it was hastily assembled and is not really complete yet.]],
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_half_finished_bone_giant.png", display_h=2, display_y=-1}}},
	level_range = {7, nil}, exp_worth = 1,
	stats = { str=10, dex=5, mag=16, con=10 },
	rank = 4,
	max_life = 60, life_rating = 14,
	combat_armor = 1, combat_def = -10,
	melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(5, 2)},
	resolvers.talents{ [Talents.T_BONE_ARMOUR]=1, [Talents.T_THROW_BONES]=1, },
	resolvers.sustains_at_birth(),
	movement_speed = 0.7,  -- Allow weak builds to still be able to win, albeit very slowly
	tier1 = true,

	-- Prevent random gear from screwing weak starts early
	resolvers.auto_equip_filters{
		MAINHAND = {special=function(e, filter)
			local who = filter._equipping_entity
			if who and who.level > 10 then return true end
			return false
		end},
		OFFHAND = {special=function(e, filter)
			local who = filter._equipping_entity
			if who and who.level > 10 then return true end
			return false
		end},
		BODY = {special=function(e, filter)
			local who = filter._equipping_entity
			if who and who.level > 10 then return true end
			return false
		end},
		OFFHAND = {special=function(e, filter)
			local who = filter._equipping_entity
			if who and who.level > 10 then return true end
			return false
		end}
	},
	resolvers.drops{chance=100, nb=3, {tome_drops="boss"} },
	equipment = resolvers.equip{
		{type="lite", defined="WINTERTIDE_PHIAL", random_art_replace={chance=75}, autoreq=true},
	},

	ai = "tactical", ai_state = { talent_in=3, ai_move="move_astar", },
	ai_tactic = resolvers.tactic"melee",
	resolvers.inscriptions(1, "rune"),

	on_die = function(self, who)
		game.player:resolveSource():setQuestStatus("start-undead", engine.Quest.COMPLETED)
	end,
}

newEntity{ base = "BASE_NPC_HORROR_UNDEAD",
	name = "fleshy experiment", color=colors.DARK_GREEN,
	desc =_t"This pile of rotting flesh twitches and makes horrid noises.",
	level_range = {1, 5}, exp_worth = 1,
	rarity = 1,
	rank = 2,
	size_category = 2,
	combat_armor = 0, combat_def = 0,
	max_life=10, life_rating=10,
	disease_immune = 1,
	never_move = 1,
	stats = { str=5, dex=5, wil=5, mag=5, con=5, cun=5 },
	ai = nil, ai_tactic = nil, ai_state = nil,
	infravision = 4, sight = 4,
	
	combat = {
		dam=resolvers.levelup(5, 1, 1.2),
		atk=15, apr=0,
		dammod={mag=1.3}, physcrit = 5,
		damtype=engine.DamageType.BLIGHT,
	},
	
	autolevel = "caster",
	
	resolvers.talents{
		[Talents.T_VIRULENT_DISEASE]={base=1, every=5, max=5},
	},
	
	resolvers.sustains_at_birth(),
}

newEntity{ base = "BASE_NPC_HORROR_UNDEAD",
	name = "boney experiment", color=colors.WHITE,
	desc =_t"This pile of bones appears to move on its own, but it can't seem to organise itself into something dangerous.",
	level_range = {1, 5}, exp_worth = 1,
	rarity = 1,
	rank = 2,
	size_category = 2,
	combat_armor = 0, combat_def = 0,
	max_life=10, life_rating = 10,
	disease_immune = 1,
	cut_immune = 1,
	never_move = 1,
	stats = { str=5, dex=5, wil=5, mag=5, con=5, cun=5 },
	ai = nil, ai_tactic = nil, ai_state = nil,
	infravision = 4, sight = 4,
	
	combat = {
		dam=resolvers.levelup(5, 1, 1.2),
		atk=10, apr=0,
		dammod={mag=1, str=0.5}, physcrit = 5,
		damtype=engine.DamageType.PHYSICALBLEED,
	},
	
	autolevel = "warriormage",
		
	resolvers.talents{
		[Talents.T_BONE_GRAB]={base=1, every=5, max=5},
	},
	
	resolvers.sustains_at_birth(),
}

newEntity{ base = "BASE_NPC_HORROR_UNDEAD",
	name = "sanguine experiment", color=colors.RED,
	desc =_t"It looks like a giant blood clot. Is that what its creator intended?",
	level_range = {1, 5}, exp_worth = 1,
	rarity = 1,
	rank = 2, life_rating = 10,
	size_category = 2,
	combat_armor = 0, combat_def = 0,
	max_life=10,
	never_move = 1,
	stats = { str=5, dex=5, wil=5, mag=5, con=5, cun=5 },
	ai = nil, ai_tactic = nil, ai_state = nil,
	infravision = 4, sight = 4,
	
	lifesteal=15,
	
	combat = {
		dam=resolvers.levelup(5, 1, 1.2),
		atk=10, apr=0,
		dammod={mag=1.1}, physcrit = 5,
		damtype=engine.DamageType.CORRUPTED_BLOOD,
	},
	
	autolevel = "caster",
	
	resolvers.talents{
		[Talents.T_BLOOD_GRASP]={base=1, every=5, max = 5},
	},
	
	resolvers.sustains_at_birth(),
}