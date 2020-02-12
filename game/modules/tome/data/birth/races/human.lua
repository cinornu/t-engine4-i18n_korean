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

---------------------------------------------------------
--                       Humans                        --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Human",
	desc = {
		_t"The Humans are one of the main races on Maj'Eyal, along with the Halflings. For many thousands of years they fought each other until events, and great people, unified all the Human and Halfling nations under one rule.",
		_t"Humans of these Allied Kingdoms have known peace for over a century now.",
		_t"Humans are split into two categories: the Highers, and the rest. Highers have latent magic in their blood which gives them higher attributes and senses along with a longer life.",
		_t"The rest of Humanity is gifted with quick learning and mastery. They can do and become anything they desire.",
	},
	descriptor_choices =
	{
		subrace =
		{
			["Cornac"] = "allow",
			["Higher"] = "allow",
			__ALL__ = "disallow",
		},
		subclass =
		{
			-- Only human and elves make sense to play celestials
			['Sun Paladin'] = "allow",
			['Anorithil'] = "allow",
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	talents = {},
	copy = {
		faction = "allied-kingdoms",
		type = "humanoid", subtype="human",
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=100}, 1),
		resolvers.inscription("INFUSION:_WILD", {cooldown=14, what={physical=true}, dur=4, power=14}, 2),
		resolvers.inscription("INFUSION:_HEALING", {cooldown=12, heal=50}, 3),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	moddable_attachement_spots = "race_human",
	cosmetic_options = {
		skin = {
			{name=_t"Skin Color 1", file="base_01"},
			{name=_t"Skin Color 2", file="base_02"},
			{name=_t"Skin Color 3", file="base_03"},
			{name=_t"Skin Color 4", file="base_04"},
			{name=_t"Skin Color 5", file="base_05"},
			{name=_t"Skin Color 6", file="base_06"},
			{name=_t"Skin Color 7", file="base_07"},
			{name=_t"Skin Color 8", file="base_08"},
		},
		hairs = {
			{name=_t"Dark Hair 1", file="hair_cornac_01"},
			{name=_t"Dark Hair 2", file="hair_cornac_02"},
			{name=_t"Dark Hair 3", file="hair_cornac_03"},
			{name=_t"Dark Hair 4", file="hair_cornac_04", only_for={sex="Female"}},
			{name=_t"Dark Hair 5", file="hair_cornac_05", only_for={sex="Female"}},
			{name=_t"Dark Hair 6", file="hair_cornac_06", only_for={sex="Female"}},
			{name=_t"Blond Hair 1", file="hair_higher_01"},
			{name=_t"Blond Hair 2", file="hair_higher_02"},
			{name=_t"Blond Hair 3", file="hair_higher_03"},
			{name=_t"Blond Hair 4", file="hair_higher_04", only_for={sex="Female"}},
			{name=_t"Blond Hair 5", file="hair_higher_05", only_for={sex="Female"}},
			{name=_t"Blond Hair 6", file="hair_higher_06", only_for={sex="Female"}},
			{name=_t"Redhead 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 3", file="hair_redhead_03", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 4", file="hair_redhead_04", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead 5", file="hair_redhead_05", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead 6", file="hair_redhead_06", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
		},
		facial_features = {
			{name=_t"Dark Beard 1", file="beard_cornac_01", only_for={sex="Male"}},
			{name=_t"Dark Beard 2", file="beard_cornac_02", only_for={sex="Male"}},
			{name=_t"Dark Beard 3", file="beard_cornac_03", only_for={sex="Male"}},
			{name=_t"Dark Beard 4", file="beard_cornac_04", only_for={sex="Male"}},
			{name=_t"Dark Beard 5", file="beard_cornac_05", only_for={sex="Male"}},
			{name=_t"Blonde Beard 1", file="beard_higher_01", only_for={sex="Male"}},
			{name=_t"Blonde Beard 2", file="beard_higher_02", only_for={sex="Male"}},
			{name=_t"Blonde Beard 3", file="beard_higher_03", only_for={sex="Male"}},
			{name=_t"Blonde Beard 4", file="beard_higher_04", only_for={sex="Male"}},
			{name=_t"Blonde Beard 5", file="beard_higher_05", only_for={sex="Male"}},
			{name=_t"Redhead Beard 1", file="beard_redhead_01", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Redhead Beard 2", file="beard_redhead_02", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Redhead Beard 3", file="beard_redhead_03", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Redhead Beard 4", file="beard_redhead_04", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Redhead Beard 5", file="beard_redhead_05", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Dark Mustache 1", file="face_mustache_cornac_01", only_for={sex="Male"}},
			{name=_t"Dark Mustache 2", file="face_mustache_cornac_02", only_for={sex="Male"}},
			{name=_t"Blond Mustache 1", file="face_mustache_higher_01", only_for={sex="Male"}},
			{name=_t"Blond Mustache 2", file="face_mustache_higher_02", only_for={sex="Male"}},
			{name=_t"Redhead Mustache 1", file="face_mustache_redhead_01", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
			{name=_t"Redhead Mustache 2", file="face_mustache_redhead_02", unlock="cosmetic_race_human_redhead", only_for={sex="Male"}},
		},
		special = {
			{name=_t"Bikini / Mankini", birth_only=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name[birther.descriptors_by_type.sex == 'Female' and 'Bikini' or 'Mankini'] if not o then print("No bikini/mankini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull() actor.moddable_tile_nude = 1
				else actor:registerOnBirthForceWear(birther.descriptors_by_type.sex == 'Female' and "FUN_BIKINI" or "FUN_MANKINI") end
			end},
		},
	},
}

---------------------------------------------------------
--                       Humans                        --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Higher",
	desc = {
		_t"Highers are a special branch of Humans that have been imbued with latent magic since the Age of Allure.",
		_t"They usually do not breed with other Humans, trying to keep their blood 'pure'.",
		_t"They possess the #GOLD#Wrath of the Highborn#WHITE# which allows them to increase damage dealt and decrease damage taken once in a while.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +1 Strength, +1 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +1 Magic, +1 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 11",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 0%",
	},
	inc_stats = { str=1, mag=1, dex=1, wil=1 },
	talents_types = { ["race/higher"]={true, 0} },
	talents = {
		[ActorTalents.T_HIGHER_HEAL]=1,
	},
	default_cosmetics = { {"hairs", _t"Blond Hair 1"} },
	copy = {
		moddable_tile = "human_#sex#",
		moddable_tile_base = "base_01.png",
		random_name_def = "higher_#sex#",
		life_rating = 11,
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "higher",
	},
}

newBirthDescriptor
{
	type = "subrace",
	name = "Cornac",
	desc = {
		_t"Cornacs are Humans from the northern parts of the Allied Kingdoms.",
		_t"Humans are an inherently very adaptable race and as such they gain a #GOLD#talent category point#WHITE# (others only gain one at levels 10, 20 and 34) and both #GOLD#a class and a generic talent point#WHITE# at birth and every 10 levels.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +0 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 10",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 0%",
	},
	experience = 1.0,
	copy_add = {
		unused_talents_types = 1,
		unused_talents = 1,
		unused_generics = 1,
	},
	default_cosmetics = { {"hairs", _t"Dark Hair 1"} },
	copy = {
		moddable_tile = "human_#sex#",
		moddable_tile_base = "base_01.png",
		random_name_def = "cornac_#sex#",
		life_rating = 10,
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "cornac",
		extra_talent_point_every = 10,
		extra_generic_point_every = 10,
	},
}
