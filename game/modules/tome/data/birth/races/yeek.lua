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
--                       Yeeks                       --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Yeek",
	locked = function() return profile.mod.allow_build.yeek end,
	locked_desc = _t"One race, one mind, one way. Our oppression shall end, and we shall inherit Eyal. Do not presume we are weak - our way is true, and only those who help us shall see our strength.",
	desc = {
		_t"Yeeks are a mysterious race of small humanoids native to the tropical island of Rel.",
		_t"Their body is covered with white fur and their disproportionate heads give them a ridiculous look.",
		_t"Although they are now nearly unheard of in Maj'Eyal, they spent many thousand years as secret slaves to the Halfling nation of Nargol.",
		_t"They gained their freedom during the Age of Pyre and have since then followed 'The Way' - a unity of minds enforced by their powerful psionics.",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Yeek = "allow",
		},
	},
	copy = {
		faction = "the-way",
		type = "humanoid", subtype="yeek",
		size_category = 2,
		default_wilderness = {"playerpop", "yeek"},
		starting_zone = "town-irkkk",
		starting_quest = "start-yeek",
		starting_intro = "yeek",
		blood_color = colors.BLUE,

		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=100}, 1),
		resolvers.inscription("INFUSION:_WILD", {cooldown=14, what={physical=true}, dur=4, power=14}, 2),
		resolvers.inscription("INFUSION:_HEALING", {cooldown=12, heal=50}, 3),
		resolvers.birth_extra_tier1_zone{name="tier1", condition=function(e) return e.starting_zone == "town-irkkk" end, "murgol-lair", "ritch-tunnels"},
	},
	game_state = {
		start_tier1_skip = 4,
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
	moddable_attachement_spots = "race_yeek", moddable_attachement_spots_sexless=true,

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
			{name=_t"Skin Color 9", file="base_09"},
			{name=_t"Skin Color 10", file="base_10"},
		},
		hairs = {
			{name=_t"Hair 1", file="hair_01"},
			{name=_t"Hair 2", file="hair_02"},
			{name=_t"Hair 3", file="hair_03"},
			{name=_t"Hair 4", file="hair_04"},
			{name=_t"Hair 5", file="hair_05"},
			{name=_t"Redfur Hair 1", file="hair_redfur_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Hair 2", file="hair_redfur_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Hair 3", file="hair_redfur_03", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Hair 4", file="hair_redfur_04", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Hair 5", file="hair_redfur_05", unlock="cosmetic_race_human_redhead"},
		},
		facial_features = {
			{name=_t"Beard 1", file="beard_01"},
			{name=_t"Beard 2", file="beard_02"},
			{name=_t"Beard 3", file="beard_03"},
			{name=_t"Redfur Beard 1", file="beard_redfur_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Beard 2", file="beard_redfur_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Beard 3", file="beard_redfur_03", unlock="cosmetic_race_human_redhead"},
			{name=_t"Eyes 1", file="face_eyes_01"},
			{name=_t"Eyes 2", file="face_eyes_02"},
			{name=_t"Eyes 3", file="face_eyes_03"},
			{name=_t"Eyes 4", file="face_eyes_04"},
			{name=_t"Eyes 5", file="face_eyes_05"},
			{name=_t"Eyes 6", file="face_eyes_06"},
			{name=_t"Eyes 7", file="face_eyes_07"},
			{name=_t"Eyes 8", file="face_eyes_08"},
			{name=_t"Eyes 9", file="face_eyes_09"},
			{name=_t"Eyes 10", file="face_eyes_10"},
			{name=_t"Eyes 11", file="face_eyes_11"},
			{name=_t"Eyes 12", file="face_eyes_12"},
			{name=_t"Eyes 13", file="face_eyes_13"},
			{name=_t"Mustache 1", file="face_mustache_01"},
			{name=_t"Mustache 2", file="face_mustache_02"},
			{name=_t"Mustache 3", file="face_mustache_03"},
			{name=_t"Redfur Mustache 1", file="face_mustache_redfur_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Mustache 2", file="face_mustache_redfur_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redfur Mustache 3", file="face_mustache_redfur_03", unlock="cosmetic_race_human_redhead"},
		},
		tatoos = {
			{name=_t"Bodypaint 1", file="tattoo_bodypaint_01"},
			{name=_t"Bodypaint 2", file="tattoo_bodypaint_02"},
			{name=_t"Tatoos 1", file="tattoo_pattern_01"},
			{name=_t"Tatoos 2", file="tattoo_pattern_02"},
			{name=_t"Redfur", file="tattoo_redfur", unlock="cosmetic_race_human_redhead"},
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
--                       Yeeks                       --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Yeek",
	locked = function() return profile.mod.allow_build.yeek end,
	locked_desc = _t"One race, one mind, one way. Our oppression shall end, and we shall inherit Eyal. Do not presume we are weak - our way is true, and only those who help us shall see our strength.",
	desc = {
		_t"Yeeks are a mysterious race native to the tropical island of Rel.",
		_t"Although they are now nearly unheard of in Maj'Eyal, they spent many centuries as secret slaves to the Halfling nation of Nargol.",
		_t"They gained their freedom during the Age of Pyre and have since then followed 'The Way' - a unity of minds enforced by their powerful psionics.",
		_t"They possess the #GOLD#Dominant Will#WHITE# talent which allows them to temporarily subvert the mind of a lesser creature. When the effect ends, the creature dies.",
		_t"While Yeeks are not amphibians, they still have an affinity for water, allowing them to survive longer without breathing.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * -3 Strength, -2 Dexterity, -5 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +6 Willpower, +4 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 7",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# -15%",
		_t"#GOLD#Confusion resistance:#LIGHT_BLUE# 35%",
	},
	inc_stats = { str=-3, con=-5, cun=4, wil=6, mag=0, dex=-2 },
	talents_types = { ["race/yeek"]={true, 0} },
	talents = {
		[ActorTalents.T_YEEK_WILL]=1,
		[ActorTalents.T_YEEK_ID]=1,
	},
	copy = {
		life_rating=7,
		confusion_immune = 0.35,
		max_air = 200,
		moddable_tile = "yeek",
		random_name_def = "yeek_#sex#",
	},
	experience = 0.85,
}
