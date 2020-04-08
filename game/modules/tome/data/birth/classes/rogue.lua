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
	name = "Rogue",
	desc = {
		_t"Rogues are masters of tricks; they can strike from the shadows, and lure monsters into deadly traps.",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Rogue = "allow",
			Shadowblade = "allow",
			Marauder = "allow",
			Skirmisher = "allow",
		},
	},
	copy = {
		max_life = 100,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Rogue",
	desc = {
		_t"Rogues are masters of tricks. A Rogue can get behind you unnoticed and stab you in the back for tremendous damage.",
		_t"Rogues usually prefer to dual-wield daggers. They can also become trapping experts, detecting and disarming traps as well as setting them.",
		_t"Their most important stats are: Dexterity and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +1 Strength, +3 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +0 Willpower, +5 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	power_source = {technique=true},
	stats = { dex=3, str=1, cun=5, },
	talents_types = {
		["technique/dualweapon-attack"]={true, 0.3},
		["technique/duelist"]={true, 0.3},
		["technique/combat-techniques-active"]={false, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/mobility"]={true, 0.3},
		["technique/throwing-knives"]={true, 0.3},
		["technique/assassination"]={false, 0.3},
		["cunning/stealth"]={true, 0.3},
		["cunning/trapping"]={true, 0.3},
		["cunning/lethality"]={true, 0.3},
		["cunning/survival"]={true, 0.3},
		["cunning/scoundrel"]={false, 0.3},
		["cunning/dirty"]={true, 0.3},
		["cunning/artifice"]={false, 0.3},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={true, 0.3, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_STEALTH] = 1,
		[ActorTalents.T_DUAL_WEAPON_MASTERY] = 1,
		[ActorTalents.T_LETHALITY] = 1,
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_KNIFE_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="dagger"},
			OFFHAND = {type="weapon", subtype="dagger"},
			BODY = {type="armor", special=function(e) return e.subtype=="light" or e.subtype=="cloth" or e.subtype=="mummy" end},
		},
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Shadowblade",
	desc = {
		_t"Shadowblades are Rogues that are touched by the gift of magic, able to kill with their daggers under a veil of stealth while casting spells to enhance their performance and survival.",
		_t"Their use of magic is innate and not really studied; as such they do not naturally regenerate mana and must use external means of recharging.",
		_t"They use the schools of Phantasm, Temporal, Divination and Conveyance magic to enhance their arts.",
		_t"Their most important stats are: Dexterity, Cunning and Magic",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +3 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +3 Magic, +0 Willpower, +3 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	birth_example_particles = {
		function(actor) if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = actor:attachementSpot("hand1", true) if h1x then actor:addParticles(Particles.new("shader_shield", 1, {img="shadowhands_01", dir=180, a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, {type="flamehands", time_factor=slow and 700 or 1000})) end
			local h2x, h2y = actor:attachementSpot("hand2", true) if h2x then actor:addParticles(Particles.new("shader_shield", 1, {img="shadowhands_01", dir=180, a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, {type="flamehands", time_factor=not slow and 700 or 1000})) end
		end end,
	},
	power_source = {technique=true, arcane=true},
	stats = { dex=3, mag=3, cun=3, },
	talents_types = {
		["spell/phantasm"]={true, 0.0},
		["spell/temporal"]={false, 0.0},
		["spell/divination"]={false, 0.0},
		["spell/conveyance"]={true, 0.0},
		["technique/dualweapon-attack"]={true, 0.0},
		["technique/duelist"]={true, 0.0},
		["technique/combat-techniques-active"]={false, 0.0},
		["technique/combat-techniques-passive"]={false, 0.3},
		["technique/combat-training"]={true, 0.0},
		["technique/mobility"]={true, 0.3},
		["cunning/stealth"]={true, 0.3},
		["cunning/survival"]={true, 0.0},
		["cunning/lethality"]={true, 0.3},
		["cunning/dirty"]={true, 0.0},
		["cunning/shadow-magic"]={true, 0.3},
		["cunning/ambush"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_SHADOW_COMBAT] = 1,
		[ActorTalents.T_PHASE_DOOR] = 1,
		[ActorTalents.T_LETHALITY] = 1,
		[ActorTalents.T_KNIFE_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=15, dur=10, mana=820}, 3),
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="dagger"},
			OFFHAND = {type="weapon", subtype="dagger"},
			BODY = {type="armor", special=function(e) return e.subtype=="light" or e.subtype=="cloth" or e.subtype=="mummy" end},
		},
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Marauder",
	locked = function() return profile.mod.allow_build.rogue_marauder end,
	locked_desc = _t"I will not hide and I will not sneak - come dance with my blades and we'll see who's weak. Snapping bone and cracking skull, it's the sounds of battle that make life full!",
	desc = {
		_t"The wilds of Maj'Eyal are not a safe place. Untamed beasts and wandering dragons may seem a great threat, but the true perils walk on two legs. Thieves and brigands, assassins and opportunistic adventurers, even mad wizards and magic-hating zealots all carry danger to those who venture beyond the safety of city walls.",
		_t"Amidst this chaos wanders one class of rogue that has learned to take by force rather than subterfuge. With refined techniques, agile feats and brawn-backed blades the Marauder seeks out his targets and removes them by the most direct methods. He uses dual weapons backed by advanced combat training to become highly effective in battle, and he is unafraid to use the dirtiest tactics when the odds are against him.",
		_t"Their most important stats are: Strength, Dexterity and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +4 Strength, +4 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +0 Willpower, +1 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	power_source = {technique=true},
	stats = { dex=4, str=4, cun=1, },
	talents_types = {
		["technique/dualweapon-attack"]={true, 0.3},
		["technique/duelist"]={true, 0.3},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={true, 0.0},
		["technique/combat-training"]={true, 0.3},
		["technique/battle-tactics"]={false, 0.3},
		["technique/mobility"]={true, 0.3},
		["technique/thuggery"]={true, 0.3},
		["technique/conditioning"]={true, 0.3},
		["technique/bloodthirst"]={false, 0.0},
		["technique/throwing-knives"]={true, 0.0},
		["cunning/dirty"]={true, 0.3},
		["cunning/tactical"]={false, 0.3},
		["cunning/survival"]={true, 0.3},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, 0.0, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_DIRTY_FIGHTING] = 1,
		[ActorTalents.T_SKULLCRACKER] = 1,
		[ActorTalents.T_VITALITY] = 1,
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="dagger"},
			OFFHAND = {type="weapon", subtype="dagger"}
		},
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="head", name="iron helm", autoreq=true, ego_chance=-1000},
		},
	},
}

local shield_special = function(e) -- allows any object with shield combat
	local combat = e.shield_normal_combat and e.combat or e.special_combat
	return combat and combat.block
end

newBirthDescriptor{
	type = "subclass",
	name = "Skirmisher",
	locked = function() return profile.mod.allow_build.rogue_skirmisher end,
	locked_desc = _t"Fleet of foot and strong of throw, overwhelming every foe, from afar we counter, strike and thud, in the chaos'd skirmish spilling blood.",
	desc = {
		_t"While able to take maximum advantage of their sling by using deft movements to avoid and confuse enemies that try to get close, the Skirmisher truly excels when fighting other ranged users.",
		_t"They have mastered the use of their shield as well as their sling and are nearly impossible to defeat in a standoff.",
		_t"Their most important stats are: Dexterity and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +4 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +1 Willpower, +4 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	--not_on_random_boss = true,
	power_source = {technique=true, technique_ranged=true},
	stats = {dex = 4, cun = 4, wil = 1},
	talents_types = {
		-- class
		["technique/skirmisher-slings"]={true, 0.3},
		["technique/buckler-training"]={true, 0.3},
		["cunning/called-shots"]={true, 0.3},
		["technique/tireless-combatant"]={true, 0.3},
		["cunning/trapping"]={false, 0.0},
		
		-- generic
		["technique/mobility"]={true, 0.3},
		["cunning/survival"]={true, 0.3},
		["technique/combat-training"]={true, 0.3},
		["cunning/scoundrel"]={true, 0.3},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, 0.3, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_DISENGAGE] = 1,
		[ActorTalents.T_SHOOT] = 1,
		[ActorTalents.T_SKIRMISHER_KNEECAPPER] = 1,
		[ActorTalents.T_SKIRMISHER_SLING_SUPREMACY] = 1,
		[ActorTalents.T_SKIRMISHER_BUCKLER_EXPERTISE] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		resolvers.auto_equip_filters{
			MAINHAND = {type="weapon", subtype="sling"},
			OFFHAND = {special=shield_special},
			BODY = {type="armor", special=function(e) return e.subtype=="light" or e.subtype=="cloth" or e.subtype=="mummy" end},
			QUIVER={properties={"archery_ammo"}, special=function(e, filter) -- must match the MAINHAND weapon, if any
				local mh = filter._equipping_entity and filter._equipping_entity:getInven(filter._equipping_entity.INVEN_MAINHAND)
				mh = mh and mh[1]
				if not mh or mh.archery == e.archery_ammo then return true end
			end}
		},
		resolvers.equipbirth{
			id=true,
			{type="armor", subtype="light", name="rough leather armour", autoreq=true,ego_chance=-1000},
			{type="weapon", subtype="sling", name="rough leather sling", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000},
			{type="ammo", subtype="shot", name="pouch of iron shots", autoreq=true, ego_chance=-1000},
		},
		resolvers.generic(function(e)
			e.auto_shoot_talent = e.T_SHOOT
		end),
	},
	copy_add = {
		life_rating = 0,
	},
}
