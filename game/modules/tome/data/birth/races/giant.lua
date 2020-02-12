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
--                       Giants                         --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Giant",
	locked = function() return profile.mod.allow_build.race_giant end,
	locked_desc = _t"Powerful beings that tower over all, but the bigger they are, the harder they fall...",
	desc = {
		_t[[#{italic}#"Giant"#{normal}# is a catch-all term for humanoids which are typically over eight feet in height.  Their origins, cultures, and relationships to other races differ wildly, but they tend to live as refugees and outcasts, shunned by smaller sentient races who usually see them as a threat.]],
	},
	descriptor_choices =
	{
		subrace =
		{
			Ogre = "allow",
			__ALL__ = "disallow",
		},
	},
	copy = {
		type = "giant", subtype="giant",
	},
}

---------------------------------------------------------
--                       Ogres                         --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Ogre",
	locked = function() return profile.mod.allow_build.race_ogre end,
	locked_desc = _t[[Forged in the hatred of ages long passed,
made for a war that they've come to outlast.
Their forgotten birthplace lies deep underground,
its tunnels ruined so it wouldn't be found.
Past burglars have failed, but their data's immortal;
to start, look where halflings once tinkered with portals...]],
	desc = {
		_t"Ogres are an altered form of Human, created in the Age of Allure as workers and warriors for the Conclave.",
		_t"Inscriptions have granted them magical and physical power far beyond their natural limits, but their dependence on runic magic made them a favored target during the Spellhunt, forcing them to take refuge among the Shalore.",
		_t"Their preference for simple and direct solutions has given them an undeserved reputation as dumb brutes, despite their extraordinary talent with runes and their humble, dutiful nature.",
		_t"They possess the #GOLD#Ogric Wrath#WHITE# talent, which grants them critical chance and power, as well as resistance to confusion and stuns, when their attacks miss or are blocked.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +3 Strength, -1 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +2 Magic, -2 Willpower, +2 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 13",
		_t"#GOLD#Experience penalty:#LIGHT_BLUE# 15%",
	},
	moddable_attachement_spots = "race_ogre",
	inc_stats = { str=3, mag=2, wil=-2, cun=2, dex=-1, con=0 },
	experience = 1.15,
	talents_types = { ["race/ogre"]={true, 0} },
	talents = { [ActorTalents.T_OGRE_WRATH]=1 },
	copy = {
		subtype = "ogre",
		moddable_tile = "ogre_#sex#",
		random_name_def = "shalore_#sex#", random_name_max_syllables = 4,
		default_wilderness = {"playerpop", "shaloren"},
		starting_zone = "scintillating-caves",
		starting_quest = "start-shaloren",
		faction = "shalore",
		starting_intro = "ogre",
		life_rating = 13,
		size_category = 4,
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}, 1),
		resolvers.inscription("RUNE:_SHATTER_AFFLICTIONS", {cooldown=18, shield=50}, 2),
		resolvers.inscription("RUNE:_BLINK", {cooldown=16, range=3, dur=3, power=15}, 3),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	default_cosmetics = { {"hairs", _t"Dark Hair 1"} },
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
			{name=_t"Dark Hair 1", file="hair_01"},
			{name=_t"Dark Hair 2", file="hair_02"},
			{name=_t"Dark Hair 3", file="hair_03"},
			{name=_t"Dark Hair 4", file="hair_04", only_for={sex="Female"}},
			{name=_t"Dark Hair 5", file="hair_05", only_for={sex="Female"}},
			{name=_t"Dark Hair 6", file="hair_06", only_for={sex="Female"}},
			{name=_t"Dark Hair 7", file="hair_07", only_for={sex="Female"}},
			{name=_t"Dark Hair 8", file="hair_08", only_for={sex="Female"}},
			{name=_t"Dark Hair 9", file="hair_09", only_for={sex="Female"}},
			{name=_t"Blond Hair 1", file="hair_blond_01"},
			{name=_t"Blond Hair 2", file="hair_blond_02"},
			{name=_t"Blond Hair 3", file="hair_blond_03"},
			{name=_t"Blond Hair 4", file="hair_blond_04", only_for={sex="Female"}},
			{name=_t"Blond Hair 5", file="hair_blond_05", only_for={sex="Female"}},
			{name=_t"Blond Hair 6", file="hair_blond_06", only_for={sex="Female"}},
			{name=_t"Blond Hair 7", file="hair_blond_07", only_for={sex="Female"}},
			{name=_t"Blond Hair 8", file="hair_blond_08", only_for={sex="Female"}},
			{name=_t"Blond Hair 9", file="hair_blond_09", only_for={sex="Female"}},
			{name=_t"Redhead Hair 1", file="hair_redhead_01", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 2", file="hair_redhead_02", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 3", file="hair_redhead_03", unlock="cosmetic_race_human_redhead"},
			{name=_t"Redhead Hair 4", file="hair_redhead_04", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead Hair 5", file="hair_redhead_05", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead Hair 6", file="hair_redhead_06", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead Hair 7", file="hair_redhead_07", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead Hair 8", file="hair_redhead_08", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
			{name=_t"Redhead Hair 9", file="hair_redhead_09", unlock="cosmetic_race_human_redhead", only_for={sex="Female"}},
		},
		facial_features = {
			{name=_t"Facial Infusions 1", file="face_infusion_01"},
			{name=_t"Facial Infusions 2", file="face_infusion_02"},
			{name=_t"Facial Runes 1", file="face_rune_01"},
			{name=_t"Facial Runes 2", file="face_rune_02"},
			{name=_t"Facial Runes 3", file="face_rune_03"},
			{name=_t"Facial Runes 4", file="face_rune_04"},
		},
		tatoos = {
			{name=_t"Body Tatoos 1", file="tattoo_runes_01"},
			{name=_t"Body Tatoos 2", file="tattoo_runes_02"},
			{name=_t"Body Tatoos 3", file="tattoo_runes_03"},
			{name=_t"Body Tatoos 4", file="tattoo_runes_04"},
			{name=_t"Body Tatoos 5", file="tattoo_runes_05"},
			{name=_t"Body Tatoos 6", file="tattoo_runes_06"},
			{name=_t"Body Tatoos 7", file="tattoo_runes_07"},
			{name=_t"Body Tatoos 8", file="tattoo_runes_08"},
		},
		special = {
			{name=_t"Bikini / Mankini", birth_only=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name[birther.descriptors_by_type.sex == 'Female' and 'Bikini' or 'Mankini'] if not o then print("No bikini/mankini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull() actor.moddable_tile_nude = 1
				else actor:registerOnBirthForceWear(birther.descriptors_by_type.sex == 'Female' and "FUN_BIKINI" or "FUN_MANKINI") end
			end},
		},
	},
}
