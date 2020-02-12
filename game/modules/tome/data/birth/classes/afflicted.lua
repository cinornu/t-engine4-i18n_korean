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

local Particles = require "engine.Particles"

newBirthDescriptor{
	type = "class",
	name = "Afflicted",
	locked = function() return profile.mod.allow_build.afflicted end,
	locked_desc = _t"Some walk in shadow, alone, unloved, unwanted. What powers they wield may be mighty, but their names are forever cursed.",
	desc = {
		_t"Afflicted classes have been twisted by their association with evil forces.",
		_t"They can use these forces to their advantage, but at a cost...",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Cursed = "allow",
			Doomed = "allow",
		},
	},
	copy = {
		chooseCursedAuraTree = true,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Cursed",
	locked = function() return profile.mod.allow_build.afflicted_cursed end,
	locked_desc = _t"Affliction can run to the soul, and hatred can fill one's entire being. Overcome someone else's hated curse to know its dreaded meaning.",
	desc = {
		_t"Through ignorance, greed or folly the Cursed served some dark design and are now doomed to pay for their sins.",
		_t"Their only master now is the hatred they carry for every living thing.",
		_t"Drawing strength from the death of all they encounter, the Cursed become terrifying combatants.",
		_t"Worse, any who approach the Cursed can be driven mad by their terrible aura.",
		_t"Their most important stats are: Strength and Willpower",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +4 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +2",
	},
	power_source = {psionic=true, technique=true},
	stats = { wil=4, str=5, },
	birth_example_particles = {
		function(actor)
			if not actor:addShaderAura("rampage", "awesomeaura", {time_factor=5000, alpha=0.7}, "particles_images/bloodwings.png") then
				actor:addParticles(Particles.new("rampage", 1))
			end
		end,
	},
	talents_types = {
		["cursed/gloom"]={true, 0.3},
		["cursed/slaughter"]={true, 0.3},
		["cursed/endless-hunt"]={true, 0.3},
		["cursed/strife"]={true, 0.3},
		["cursed/cursed-form"]={true, 0.0},
		-- ["cursed/unyielding"]={true, 0.0},
		["technique/combat-training"]={true, 0.3},
		["cunning/survival"]={false, 0.0},
		["cursed/rampage"]={false, 0.3},
		["cursed/predator"]={true, 0.3},
		["cursed/fears"]={false, 0.0},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_GLOOM] = 1,
		[ActorTalents.T_SLASH] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", properties={"twohanded"}},
			OFFHAND = {special=function(e, filter) -- only allow if there is already a weapon in MAINHAND
				local who = filter._equipping_entity
				if who then
					local mh = who:getInven(who.INVEN_MAINHAND) mh = mh and mh[1]
					if mh and (not mh.slot_forbid or not who:slotForbidCheck(e, who.INVEN_MAINHAND)) then return true end
				end
				return false
			end},
		},
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000}
		},
		show_shield_combat = 1,
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Doomed",
	locked = function() return profile.mod.allow_build.afflicted_doomed end,
	locked_desc = _t"In shaded places in unknown lands thou must overcome thyself and see thy doom.",
	desc = {
		_t"The Doomed are fallen mages who once wielded powerful magic wrought by ambition and dark bargains.",
		_t"Stripped of their magic by the dark forces that once served them, they have learned to harness the hatred that burns in their minds.",
		_t"Only time will tell if they can choose a new path or are doomed forever.",
		_t"The Doomed strike from behind a veil of darkness or a host of shadows.",
		_t"They feed upon their enemies as they unleash their minds on all who confront them.",
		_t"Their most important stats are: Willpower and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +4 Willpower, +5 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	birth_example_particles = {
		function(actor) if core.shader.active() then
			actor:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1, img="call_shadows"}, {type="rotatingshield", noup=2.0, cylinderRotationSpeed=1.7, appearTime=0.2}))
			actor:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1, img="call_shadows"}, {type="rotatingshield", noup=1.0, cylinderRotationSpeed=1.7, appearTime=0.2}))
		end end,
	},
	power_source = {psionic=true},
	random_rarity = 2,
	stats = { wil=4, cun=5, },
	talents_types = {
		["cursed/dark-sustenance"]={true, 0.3},
		["cursed/force-of-will"]={true, 0.3},
		["cursed/gestures"]={true, 0.3},
		["cursed/punishments"]={true, 0.3},
		["cursed/shadows"]={true, 0.3},
		["cursed/darkness"]={true, 0.3},
		["cursed/cursed-form"]={true, 0.0},
		["cunning/survival"]={false, 0.0},
		["cursed/fears"]={false, 0.3},
		["cursed/one-with-shadows"]={false, 0.3},
		["cursed/advanced-shadowmancy"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_FEED] = 1,
		[ActorTalents.T_GESTURE_OF_PAIN] = 1,
		[ActorTalents.T_WILLFUL_STRIKE] = 1,
		[ActorTalents.T_CALL_SHADOWS] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="mindstar"},
			OFFHAND = {type="weapon", subtype="mindstar"},
		},
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
	},
}
