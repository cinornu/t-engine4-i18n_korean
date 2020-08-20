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
--                       Ghouls                        --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Undead",
	locked = function() return profile.mod.allow_build.undead end,
	locked_desc = _t"Grave strength, dread will, this flesh cannot stay still. Kings die, masters fall, we will outlast them all.",
	desc = {
		_t"Undead are humanoids (Humans, Elves, Dwarves, ...) that have been brought back to life by the corruption of dark magics.",
		_t"Undead can take many forms, from ghouls to vampires and liches.",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Ghoul = "allow",
			Skeleton = "allow",
		},
		class =
		{
			Wilder = "disallow",
		},
		subclass =
		{
			Necromancer = "nolore",
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	talents = {
		[ActorTalents.T_UNDEAD_ID]=1,
	},
	copy = {
		-- Force undead faction to undead
		resolvers.genericlast(function(e) e.faction = "undead" end),
		starting_zone = "blighted-ruins",
		starting_level = 3, starting_level_force_down = true,
		starting_quest = "start-undead",
		undead = 1, true_undead = 1,
		forbid_nature = 1,
		inscription_forbids = { ["inscriptions/infusions"] = true },
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=130}, 1),
		resolvers.inscription("RUNE:_SHATTER_AFFLICTIONS", {cooldown=18, shield=50}, 2),
		resolvers.inscription("RUNE:_BLINK", {cooldown=18, power=10, range=4,}, 3),
		resolvers.birth_extra_tier1_zone{name="tier1", condition=function(e) return e.starting_zone == "blighted-ruins" end, "blighted-ruins"},
	},

	cosmetic_options = {
		special = {
			{name=_t"Bikini / Mankini", birth_only=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name[birther.descriptors_by_type.sex == 'Female' and 'Bikini' or 'Mankini'] if not o then print("No bikini/mankini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull() actor.moddable_tile_nude = 1
				else actor:registerOnBirthForceWear(birther.descriptors_by_type.sex == 'Female' and "FUN_BIKINI" or "FUN_MANKINI") end
			end},
		},
	},
	
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
}

newBirthDescriptor
{
	type = "subrace",
	name = "Ghoul",
	locked = function() return profile.mod.allow_build.undead_ghoul end,
	locked_desc = _t"Slow to shuffle, quick to bite, learn from master, rule the night!",
	desc = {
		_t"Ghouls are dumb, but resilient, rotting undead creatures, making good fighters.",
		_t"They have access to #GOLD#special ghoul talents#WHITE# and a wide range of undead abilities:",
		_t"- great poison resistance",
		_t"- bleeding immunity",
		_t"- stun resistance",
		_t"- fear immunity",
		_t"- special ghoul talents: ghoulish leap, gnaw and retch",
		_t"The rotting bodies of ghouls also force them to act a bit more slowly than most creatures.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +3 Strength, +1 Dexterity, +5 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, -2 Willpower, -2 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 14",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 12%",
		_t"#GOLD#Speed penalty:#LIGHT_BLUE# -20%",
	},
	moddable_attachement_spots = "race_ghoul", moddable_attachement_spots_sexless=true,
	descriptor_choices =
	{
		sex =
		{
			__ALL__ = "disallow",
			Male = "allow",
		},
	},
	inc_stats = { str=3, con=5, wil=-2, mag=0, dex=1, cun=-2 },
	talents_types = {
		["undead/ghoul"]={true, 0.1},
	},
	talents = {
		[ActorTalents.T_GHOUL]=1,
	},
	copy = {
		type = "undead", subtype="ghoul",
		default_wilderness = {"playerpop", "low-undead"},
		starting_intro = "ghoul",
		life_rating=14,
		poison_immune = 0.8,
		cut_immune = 1,
		stun_immune = 0.5,
		fear_immune = 1,
		global_speed_base = 0.8,
		moddable_tile = "ghoul",
		moddable_tile_nude = 1,
	},
	experience = 1.12,

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
		},
		hairs = {
			{name=_t"Hair 1", file="hair_01"},
			{name=_t"Hair 2", file="hair_02"},
			{name=_t"Redhead Hair 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Hair 1", file="hair_white_01"},
			{name=_t"White Hair 2", file="hair_white_02"},
		},
		facial_features = {
			{name=_t"Beard 1", file="beard_01"},
			{name=_t"Beard 2", file="beard_02"},
			{name=_t"Redhead Beard 1", file="beard_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Beard 2", file="beard_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Beard 1", file="beard_white_01"},
			{name=_t"White Beard 2", file="beard_white_02"},
			{name=_t"Alternative Face", file="face_01"},
			{name=_t"Fangs 1", file="face_fangs_01"},
			{name=_t"Fangs 2", file="face_fangs_02"},
			{name=_t"Mustache", file="face_mustache_01"},
			{name=_t"Redhead Mustache", file="face_mustache_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Mustache", file="face_mustache_white_01"},
		},
		tatoos = {
			{name=_t"Bloodstains", file="tattoo_bloodstains"},
			{name=_t"Bones", file="tattoo_bones"},
			{name=_t"Guts", file="tattoo_guts"},
			{name=_t"Runes 1", file="tattoo_runes_01"},
			{name=_t"Runes 2", file="tattoo_runes_02"},
		},
	},
}

newBirthDescriptor
{
	type = "subrace",
	name = "Skeleton",
	locked = function() return profile.mod.allow_build.undead_skeleton end,
	locked_desc = _t"The marching bones, each step we rattle; but servants no more, we march to battle!",
	desc = {
		_t"Skeletons are animated bones, undead creatures both strong and dexterous.",
		_t"They have access to #GOLD#special skeleton talents#WHITE# and a wide range of undead abilities:",
		_t"- poison immunity",
		_t"- bleeding immunity",
		_t"- fear immunity",
		_t"- no need to breathe",
		_t"- special skeleton talents: bone armour, resilient bones, re-assemble",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +3 Strength, +4 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +0 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 12",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 20%",
	},
	moddable_attachement_spots = "race_skeleton", moddable_attachement_spots_sexless=true,
	descriptor_choices =
	{
		sex =
		{
			__ALL__ = "disallow",
			Male = "allow",
		},
	},
	inc_stats = { str=3, con=0, wil=0, mag=0, dex=4, cun=0 },
	talents_types = {
		["undead/skeleton"]={true, 0.1},
	},
	talents = {
		[ActorTalents.T_SKELETON]=1,
	},
	copy = {
		type = "undead", subtype="skeleton",
		default_wilderness = {"playerpop", "low-undead"},
		starting_intro = "skeleton",
		life_rating=12,
		poison_immune = 1,
		cut_immune = 1,
		fear_immune = 1,
		no_breath = 1,
		blood_color = colors.GREY,
		moddable_tile = "skeleton",
		moddable_tile_nude = 1,
	},
	experience = 1.2,

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
			{name=_t"Hair 1", file="hair_01"},
			{name=_t"Hair 2", file="hair_02"},
			{name=_t"Redhead Hair 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Hair 1", file="hair_white_01"},
			{name=_t"White Hair 2", file="hair_white_02"},
		},
		facial_features = {
			{name=_t"Beard 1", file="beard_01"},
			{name=_t"Beard 2", file="beard_02"},
			{name=_t"Redhead Beard 1", file="beard_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Beard 2", file="beard_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Beard 1", file="beard_white_01"},
			{name=_t"White Beard 2", file="beard_white_02"},
			{name=_t"Eyes 1", file="face_eyes_01"},
			{name=_t"Eyes 2", file="face_eyes_02"},
			{name=_t"Eyes 3", file="face_eyes_03"},
			{name=_t"Mustache", file="face_mustache_01"},
			{name=_t"Redhead Mustache", file="face_mustache_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Mustache", file="face_mustache_white_01"},
			{name=_t"Teeth 1", file="face_teeth_01"},
			{name=_t"Teeth 2", file="face_teeth_02"},
		},
		tatoos = {
			{name=_t"Cracks", file="tattoo_cracks"},
			{name=_t"Guts", file="tattoo_guts"},
			{name=_t"Iron Bolt", file="tattoo_iron_bolt"},
			{name=_t"Molds", file="tattoo_mold_01"},
			{name=_t"Runes 1", file="tattoo_runes_01"},
			{name=_t"Runes 2", file="tattoo_runes_02"},
			{name=_t"Rust", file="tattoo_rust_01"},
		},
	},
}

---------------------------------------------------------------------
-- THIS IS NOT TO BIRTH WITH
-- this is to provide cosmetics to liches when the player turns into one
---------------------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Lich",
	locked = function() return true end,
	locked_desc = _t"You should not see this!",
	desc = {
	},
	moddable_attachement_spots = "race_skeleton", moddable_attachement_spots_sexless=true,
	copy = {
		moddable_tile = "skeleton",
		moddable_tile_base = "base_lich_01.png",
		moddable_tile_nude = 1,
	},
	cosmetic_options = {
		skin = {
			{name=_t"Skin Color 1", file="base_lich_01"},
			{name=_t"Skin Color 2", file="base_lich_02"},
			{name=_t"Skin Color 3", file="base_lich_03"},
			{name=_t"Skin Color 4", file="base_lich_04"},
			{name=_t"Skin Color 5", file="base_lich_05"},
			{name=_t"Skin Color 6", file="base_lich_06"},
			{name=_t"Skin Color 7", file="base_lich_07"},
			{name=_t"Skin Color 8", file="base_lich_08"},
		},
		hairs = {
			{name=_t"Hair 1", file="hair_01"},
			{name=_t"Hair 2", file="hair_02"},
			{name=_t"Redhead Hair 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Hair 1", file="hair_white_01"},
			{name=_t"White Hair 2", file="hair_white_02"},
		},
		facial_features = {
			{name=_t"Beard 1", file="beard_01"},
			{name=_t"Beard 2", file="beard_02"},
			{name=_t"Redhead Beard 1", file="beard_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Beard 2", file="beard_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Beard 1", file="beard_white_01"},
			{name=_t"White Beard 2", file="beard_white_02"},
			{name=_t"Eyes 1", file="face_eyes_01"},
			{name=_t"Eyes 2", file="face_eyes_02"},
			{name=_t"Eyes 3", file="face_eyes_03"},
			{name=_t"Mustache", file="face_mustache_01"},
			{name=_t"Redhead Mustache", file="face_mustache_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"White Mustache", file="face_mustache_white_01"},
			{name=_t"Teeth 1", file="face_teeth_01"},
			{name=_t"Teeth 2", file="face_teeth_02"},
			{name=_t"Lich Eyes 1", file="face_lich_eyes_01"},
			{name=_t"Lich Eyes 2", file="face_lich_eyes_02"},
			{name=_t"Lich Eyes 3", file="face_lich_eyes_03"},
			{name=_t"Lich Regalia 1", file="face_lich_regalia_01"},
			{name=_t"Lich Regalia 2", file="face_lich_regalia_02"},
			{name=_t"Lich Regalia 3", file="face_lich_regalia_03"},
			{name=_t"Lich Regalia 4", file="face_lich_regalia_04"},
			{name=_t"Lich Regalia 5", file="face_lich_regalia_05"},
			{name=_t"Lich Regalia 6", file="face_lich_regalia_06"},
			{name=_t"Lich Regalia 7", file="face_lich_regalia_07"},
			{name=_t"Lich Regalia 8", file="face_lich_regalia_08"},
			{name=_t"Lich Regalia 9", file="face_lich_regalia_09"},
			{name=_t"Lich Regalia 10", file="face_lich_regalia_10"},
		},
		tatoos = {
			{name=_t"Cracks", file="tattoo_cracks"},
			{name=_t"Guts", file="tattoo_guts"},
			{name=_t"Iron Bolt", file="tattoo_iron_bolt"},
			{name=_t"Molds", file="tattoo_mold_01"},
			{name=_t"Runes 1", file="tattoo_runes_01"},
			{name=_t"Runes 2", file="tattoo_runes_02"},
			{name=_t"Rust", file="tattoo_rust_01"},
		},
	},
}
