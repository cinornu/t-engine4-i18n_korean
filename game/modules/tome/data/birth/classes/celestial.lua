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

newBirthDescriptor{
	type = "class",
	name = "Celestial",
	locked = function() return profile.mod.allow_build.divine end,
	locked_desc = _t"The magic of the heavens is known to but a few, and that knowledge has long passed east, forgotten.",
	desc = {
		_t"Celestial classes are arcane users focused on the heavenly bodies.",
		_t"Most draw their powers from the Sun and the Moons.",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			['Sun Paladin'] = "allow-nochange",
			Anorithil = "allow-nochange",
		},
	},
	copy = {
		class_start_check = function(self)
			if self.descriptor.world == "Maj'Eyal" and (self.descriptor.race == "Human" or self.descriptor.race == "Elf") and not self._forbid_start_override then
				self.celestial_race_start_quest = self.starting_quest
				self.default_wilderness = {"zone-pop", "ruined-gates-of-morning"}
				self.starting_zone = "town-gates-of-morning"
				self.starting_quest = "start-sunwall"
				self.starting_intro = "sunwall"
				self.faction = "sunwall"
			end
		end,
	},
}

local shield_special = function(e) -- allows any object with shield combat
	local combat = e.shield_normal_combat and e.combat or e.special_combat
	return combat and combat.block
end

newBirthDescriptor{
	type = "subclass",
	name = "Sun Paladin",
	locked = function() return profile.mod.allow_build.divine_sun_paladin end,
	locked_desc = _t"The sun rises in the east in full glory, but you must look for it first amidst the darkest places.",
	desc = {
		_t"Sun Paladins hail from the Gates of Morning, the last bastion of the free people in the Far East.",
		_t"Their way of life is well represented by their motto 'The Sun is our giver, our purity, our essence. We carry the light into dark places, and against our strength none shall pass.'",
		_t"They can channel the power of the Sun to smite all who seek to destroy the Sunwall.",
		_t"Competent in both weapon and shield combat and magic, they usually burn their foes from afar before bashing them in melee.",
		_t"Their most important stats are: Strength and Magic",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +4 Magic, +0 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +2",
	},
	power_source = {technique=true, arcane=true},
	stats = { mag=4, str=5, },
	talents_types = {
		["technique/shield-offense"]={true, 0.0},
		["technique/2hweapon-assault"]={true, 0.0},
		["technique/combat-techniques-active"]={false, 0.0},
		["technique/combat-training"]={true, 0.0},
		["cunning/survival"]={false, 0.0},
		["technique/combat-techniques-passive"]={true, 0.0},
		["celestial/sun"]={true, 0.3},
		["celestial/chants"]={true, 0.3},
		["celestial/combat"]={true, 0.3},
		["celestial/light"]={true, 0.3},
		["celestial/guardian"]={false, 0.3},
		["celestial/radiance"]={false, 0.3},
		["celestial/crusader"]={false, 0.3},
	},
	birth_example_particles = "golden_shield",
	talents = {
		[ActorTalents.T_SUN_BEAM] = 1,
		[ActorTalents.T_WEAPON_OF_LIGHT] = 1,
		[ActorTalents.T_CHANT_ACOLYTE] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 2,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", special=function(e, filter) -- allow any weapon that doesn't forbid OFFHAND
				if e.slot_forbid == "OFFHAND" then
					local who = filter._equipping_entity
					return who and not who:slotForbidCheck(e, who.INVEN_MAINHAND)
				end
				return true
			end},
			OFFHAND = {special=shield_special},
			BODY = {type="armor", special=function(e, filter)
				if e.subtype=="heavy" or e.subtype=="massive" then return true end
				local who = filter._equipping_entity
				if who then
					local body = who:getInven(who.INVEN_BODY)
					return not (body and body[1])
				end
			end},
		},
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mace", name="iron mace", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true,
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance= -1000},
		},

	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Anorithil",
	locked = function() return profile.mod.allow_build.divine_anorithil end,
	locked_desc = _t"The balance of the heavens' powers is a daunting task. Mighty are those that stand in the twilight places, wielding both light and darkness in their mind.",
	desc = {
		_t"Anorithils hail from the Gates of Morning, the last bastion of the free people in the Far East.",
		_t"Their way of life is well represented by their motto 'We stand betwixt the Sun and Moon, where light and darkness meet. In the grey twilight we seek our destiny.'",
		_t"They can channel the power of the Sun and the Moons to burn and tear apart all who seek to destroy the Sunwall.",
		_t"Masters of Sun and Moon magic, they usually burn their foes with Sun rays before calling the fury of the stars.",
		_t"Their most important stats are: Magic and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +6 Magic, +0 Willpower, +3 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	power_source = {arcane=true},
	stats = { mag=6, cun=3, },
	talents_types = {
		["cunning/survival"]={false, 0.0},
		["celestial/sunlight"]={true, 0.3},
		["celestial/chants"]={true, 0.3},
		["celestial/glyphs"]={false, 0.3},
		["celestial/circles"]={false, 0.3},
		["celestial/eclipse"]={true, 0.3},
		["celestial/light"]={true, 0.3},
		["celestial/twilight"]={true, 0.3},
		["celestial/hymns"]={true, 0.3},
		["celestial/star-fury"]={true, 0.3},
	},
	birth_example_particles = "darkness_shield",
	talents = {
		[ActorTalents.T_SEARING_LIGHT] = 1,
		[ActorTalents.T_MOONLIGHT_RAY] = 1,
		[ActorTalents.T_HYMN_ACOLYTE] = 1,
		[ActorTalents.T_TWILIGHT] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="staff"},
			OFFHAND = {special=function(e, filter) -- only allow if there is a 1H weapon in MAINHAND
				local who = filter._equipping_entity
				if who then
					local mh = who:getInven(who.INVEN_MAINHAND) mh = mh and mh[1]
					if mh and (not mh.slot_forbid or not who:slotForbidCheck(e, who.INVEN_MAINHAND)) then return true end
				end
				return false
			end}
		},
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
}
