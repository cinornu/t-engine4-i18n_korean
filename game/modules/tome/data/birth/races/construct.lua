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
--                      Constructs                     --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Construct",
	locked = function() return profile.mod.allow_build.construct and true or "hide" end,
	locked_desc = _t"",
	desc = {
		_t"Constructs are not natural creatures.",
		_t"The most usual contructs are golems, but they can vary in shape, form and abilities.",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			["Runic Golem"] = "allow",
		},
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
}

newBirthDescriptor
{
	type = "subrace",
	name = "Runic Golem",
	locked = function() return profile.mod.allow_build.construct_runic_golem and true or "hide" end,
	locked_desc = _t"",
	desc = {
		_t"Runic Golems are creatures made of solid rock and animated using arcane forces.",
		_t"They cannot be of any class, but they have many intrinsic abilities.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +3 Strength, -2 Dexterity, +3 Constitution",
		_t"#LIGHT_BLUE# * +2 Magic, +2 Willpower, -5 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 13",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 25%",
	},
	moddable_attachement_spots = "race_runic_golem", moddable_attachement_spots_sexless=true,
	descriptor_choices =
	{
		sex =
		{
			__ALL__ = "disallow",
			Male = "allow",
		},
		class =
		{
			__ALL__ = "disallow",
			None = "allow",
		},
		subclass =
		{
			__ALL__ = "disallow",
		},
	},
	inc_stats = { str=3, con=3, wil=2, mag=2, dex=-2, cun=-5 },
	talents_types = {
		["golem/arcane"]={true, 0.3},
		["golem/fighting"]={true, 0.3},
	},
	talents = {
		[ActorTalents.T_MANA_POOL]=1,
		[ActorTalents.T_STAMINA_POOL]=1,
	},
	copy = {
		resolvers.generic(function(e) e.descriptor.class = "Golem" e.descriptor.subclass = "Golem" end),
		resolvers.genericlast(function(e) e.faction = "undead" end),
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "ruins-kor-pul",
		starting_quest = "start-allied",
		blood_color = colors.GREY,
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },

		mana_regen = 0.5,
		mana_rating = 7,
		inscription_restrictions = { ["inscriptions/runes"] = true, },
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=25, dur=10, mana=620}),
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}),
		resolvers.inscription("RUNE:_PHASE_DOOR", {cooldown=7, range=10, dur=5, power=15}),

		type = "construct", subtype="golem", image = "npc/alchemist_golem.png",
		starting_intro = "ghoul",
		life_rating=13,
		poison_immune = 1,
		cut_immune = 1,
		stun_immune = 1,
		fear_immune = 1,
		construct = 1,

		moddable_tile = "runic_golem",
		moddable_tile_nude = 1,
	},
	experience = 1.25,

	cosmetic_options = {
		skin = {
			{name=_t"Skin Color 1", file="base_01"},
			{name=_t"Skin Color 2", file="base_02"},
			{name=_t"Skin Color 3", file="base_03"},
			{name=_t"Skin Color 4", file="base_04"},
			{name=_t"Skin Color 5", file="base_05"},
		},
		hairs = {
			{name=_t"Face 1", file="face_01"},
			{name=_t"Face 2", file="face_02"},
			{name=_t"Face 3", file="face_03"},
		},
		facial_features = {
			{name=_t"Mustache 1", file="face_mustache_01"},
			{name=_t"Mustache 2", file="face_mustache_02"},
			{name=_t"Mustache 3", file="face_mustache_03"},
			{name=_t"Mustache 4", file="face_mustache_04"},
			{name=_t"Mustache 5", file="face_mustache_05"},
			{name=_t"Mustache 6", file="face_mustache_06"},
			{name=_t"Mustache 7", file="face_mustache_07"},
			{name=_t"Mustache 8", file="face_mustache_08"},
			{name=_t"Mustache 9", file="face_mustache_09"},
		},
		tatoos = {
			{name=_t"Tatoos 1", file="tattoo_runes_01"},
			{name=_t"Tatoos 2", file="tattoo_runes_02"},
			{name=_t"Tatoos 3", file="tattoo_runes_03"},
			{name=_t"Tatoos 4", file="tattoo_runes_04"},
			{name=_t"Tatoos 5", file="tattoo_runes_05"},
			{name=_t"Tatoos 6", file="tattoo_runes_06"},
			{name=_t"Tatoos 7", file="tattoo_runes_07"},
		},
		special = {
			{name=_t"Bikini / Mankini", birth_only=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name[birther.descriptors_by_type.sex == 'Female' and 'Bikini' or 'Mankini'] if not o then print("No bikini/mankini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull() actor.moddable_tile_nude = 1
				else actor:registerOnBirthForceWear(birther.descriptors_by_type.sex == 'Female' and "FUN_BIKINI" or "FUN_MANKINI") end
			end},
		},
	},
}
