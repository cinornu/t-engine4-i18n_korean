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
--                      Halflings                      --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Halfling",
	desc = {
		_t"Halflings are a race of very short stature, rarely exceeding four feet in height.",
		_t"They are like humans in that they can do just about anything they set their minds to, yet they excel at ordering and studying things.",
		_t"Halfling armies have brought many kingdoms to their knees and they kept a balance of power with the Human kingdoms during the Age of Allure.",
		_t"Halflings are agile, lucky, and resilient but lacking in strength.",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Halfling = "allow",
		},
		subclass = {
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	copy = {
		faction = "allied-kingdoms",
		type = "humanoid", subtype="halfling",
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "halfling",
		size_category = 2,
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=100}, 1),
		resolvers.inscription("INFUSION:_WILD", {cooldown=14, what={physical=true}, dur=4, power=14}, 2),
		resolvers.inscription("INFUSION:_HEALING", {cooldown=12, heal=50}, 3),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	moddable_attachement_spots = "race_halfling",
	cosmetic_options = {
		skin = {
			{name=_t"Skin Color 1", file="base_01"},
			{name=_t"Skin Color 2", file="base_02"},
			{name=_t"Skin Color 3", file="base_03"},
			{name=_t"Skin Color 4", file="base_04"},
			{name=_t"Skin Color 5", file="base_05"},
			{name=_t"Skin Color 6", file="base_06"},
		},
		hairs = {
			{name=_t"Blond Hair 1", file="hair_blond_01"},
			{name=_t"Blond Hair 2", file="hair_blond_02"},
			{name=_t"Blond Hair 3", file="hair_blond_03"},
			{name=_t"Blond Hair 4", file="hair_blond_04"},
			{name=_t"Dark Hair 1", file="hair_black_01"},
			{name=_t"Dark Hair 2", file="hair_black_02"},
			{name=_t"Dark Hair 3", file="hair_black_03"},
			{name=_t"Dark Hair 4", file="hair_black_04"},
			{name=_t"Redhead 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 3", file="hair_redhead_03", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead 4", file="hair_redhead_04", unlock="cosmetic_race_human_redhead"},
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
--                      Halflings                      --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Halfling",
	desc = {
		_t"Halflings are a race of very short stature, rarely exceeding four feet in height.",
		_t"They are like humans in that they can do just about anything they set their minds to, yet they excel at ordering and studying things.",
		_t"Halfling armies have brought many kingdoms to their knees and they kept a balance of power with the Human kingdoms during the Age of Allure.",
		_t"They possess the #GOLD#Luck of the Little Folk#WHITE# which allows them to increase their critical strike chance and saves for a few turns.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * -3 Strength, +3 Dexterity, +1 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +0 Willpower, +3 Cunning",
		_t"#LIGHT_BLUE# * +5 Luck",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 12",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 10%",
	},
	inc_stats = { str=-3, dex=3, con=1, cun=3, lck=5, },
	experience = 1.10,
	talents_types = { ["race/halfling"]={true, 0} },
	talents = {
		[ActorTalents.T_HALFLING_LUCK]=1,
	},
	default_cosmetics = { {"hairs", _t"Dark Hair 1", only_for={sex="Male"}}, {"hairs", _t"Blond Hair 1", only_for={sex="Female"}} },
	copy = {
		moddable_tile = "halfling_#sex#",
		random_name_def = "halfling_#sex#",
		life_rating = 12,
	},
}
