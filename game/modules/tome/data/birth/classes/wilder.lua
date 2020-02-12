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
	name = "Wilder",
	locked = function() return profile.mod.allow_build.wilder_wyrmic or profile.mod.allow_build.wilder_summoner or profile.mod.allow_build.wilder_stone_warden end,
	locked_desc = _t"Natural abilities can go beyond mere skill. Experience the true powers of nature to learn of its amazing gifts.",
	desc = {
		_t"Wilders are one with nature, in one manner or another. There are as many different Wilders as there are aspects of nature.",
		_t"They can take on the aspects of creatures, summon creatures to them, feel the druidic call, ...",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Summoner = "allow",
			Wyrmic = "allow",
			Oozemancer = "allow",
			["Stone Warden"] = "allow",
		},
	},
	copy = {
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Summoner",
	locked = function() return profile.mod.allow_build.wilder_summoner end,
	locked_desc = _t"Not all might comes from within. Hear the invocations of nature, hear its calling power. See that from without we can find our true strengths.",
	desc = {
		_t"Summoners never fight alone. They are always ready to summon one of their many minions to fight at their side.",
		_t"Summons can range from a combat hound to a fire drake.",
		_t"Their most important stats are: Willpower and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +1 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +5 Willpower, +3 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +0",
	},
	power_source = {nature=true},
	getStatDesc = function(stat, actor)
		if stat == actor.STAT_CUN then
			return ("Max summons: %d"):tformat(math.floor(actor:getCun()/10))
		end
	end,
	stats = { wil=5, cun=3, dex=1, },
	birth_example_particles = {
		function(actor)
			if actor:addShaderAura("master_summoner", "awesomeaura", {time_factor=6200, alpha=0.7, flame_scale=0.8}, "particles_images/naturewings.png") then
			elseif core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", zoom=2, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
	},
	talents_types = {
		["wild-gift/call"]={true, 0.3},
		["wild-gift/harmony"]={false, 0.3},
		["wild-gift/summon-melee"]={true, 0.3},
		["wild-gift/summon-distance"]={true, 0.3},
		["wild-gift/summon-utility"]={true, 0.3},
		["wild-gift/summon-augmentation"]={false, 0.3},
		["wild-gift/summon-advanced"]={false, 0.3},
		["wild-gift/mindstar-mastery"]={true, 0.3},
		["technique/combat-techniques-active"]={false, 0},
		["cunning/survival"]={true, 0},
		["technique/combat-training"]={true, 0},
	},
	talents = {
		[ActorTalents.T_WAR_HOUND] = 1,
		[ActorTalents.T_RITCH_FLAMESPITTER] = 1,
		[ActorTalents.T_MEDITATION] = 1,
		[ActorTalents.T_HEIGHTENED_SENSES] = 1,
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
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000},
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Wyrmic",
	locked = function() return profile.mod.allow_build.wilder_wyrmic end,
	locked_desc = _t"Sleek, majestic, powerful... In the path of dragons we walk, and their breath is our breath. See their beating hearts with your eyes and taste their majesty between your teeth.",
	desc = {
		_t"Wyrmics are fighters who have learnt how to mimic some of the aspects of the dragons.",
		_t"They have access to talents normally belonging to the various kind of drakes.",
		_t"Their most important stats are: Strength and Willpower",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +1 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +3 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +2",
	},
	birth_example_particles = {
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="lightningwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="poisonwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="acidwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="sandwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="icewings", life=18, fade=-0.006, deploy_speed=14})) end end,
	},
	power_source = {nature=true, technique=true},
	stats = { str=5, wil=3, con=1, },
	talents_types = {
		["wild-gift/call"]={true, 0.3},
		["wild-gift/harmony"]={false, 0.0},
		["wild-gift/sand-drake"]={true, 0.3},
		["wild-gift/fire-drake"]={true, 0.3},
		["wild-gift/cold-drake"]={true, 0.3},
		["wild-gift/storm-drake"]={true, 0.3},
		["wild-gift/venom-drake"]={true, 0.3},
		["wild-gift/higher-draconic"]={false, 0.3},
		["wild-gift/fungus"]={true, 0.0},
		["cunning/survival"]={false, 0.0},
		["technique/shield-offense"]={true, 0.3},
		["technique/2hweapon-assault"]={true, 0.3},
		["technique/combat-techniques-active"]={false, 0.3},
		["technique/combat-training"]={true, 0.3},
	},
	talents = {
		[ActorTalents.T_ICE_CLAW] = 1,
		[ActorTalents.T_MEDITATION] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		drake_touched = 2,
		max_life = 110,
		resolvers.auto_equip_filters{  -- This could be improved to check learned trees since Wyrmics can use a lot of weapons
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
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000}		},
	},
	copy_add = {
		life_rating = 2,
	},
}


newBirthDescriptor{
	type = "subclass",
	name = "Oozemancer",
	locked = function() return profile.mod.allow_build.wilder_oozemancer end,
	locked_desc = _t"Magic must fail, magic must lose, nothing arcane can face the ooze...",
	desc = {
		_t"Oozemancers separate themselves from normal civilisation so that they be more in harmony with Nature. Arcane force are reviled by them, and their natural attunement to the wilds lets them do battle with abusive magic-users on an equal footing.",
		_t"They can spawn oozes to protect and attack from a distance while also being adept at harnessing the power of mindstars and psiblades.",
		_t"Their most important stats are: Willpower and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +5 Willpower, +4 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# -3",
	},
	power_source = {nature=true, antimagic=true},
	random_rarity = 3,
	getStatDesc = function(stat, actor)
		if stat == actor.STAT_CUN then
			return ("Max summons: %d"):tformat(math.floor(actor:getCun()/10))
		end
	end,
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=5, npow=2, time_factor=9000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={0,0}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=0.5, npow=4, time_factor=2000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={0,0}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
	},
	stats = { wil=5, cun=4, },
	talents_types = {
		["cunning/survival"]={true, 0.0},
		["wild-gift/call"]={true, 0.3},
		["wild-gift/antimagic"]={true, 0.3},
		["wild-gift/mindstar-mastery"]={true, 0.3},
		["wild-gift/mucus"]={true, 0.3},
		["wild-gift/ooze"]={true, 0.3},
		["wild-gift/fungus"]={false, 0.3},
		["wild-gift/oozing-blades"]={false, 0.3},
		["wild-gift/corrosive-blades"]={false, 0.3},
		["wild-gift/moss"]={true, 0.3},
		["wild-gift/eyals-fury"]={false, 0.3},
		["wild-gift/slime"]={true, 0.3},
	},
	talents = {
		[ActorTalents.T_PSIBLADES] = 1,
		[ActorTalents.T_MITOSIS] = 1,
		[ActorTalents.T_MUCUS] = 1,
		[ActorTalents.T_SLIME_SPIT] = 1,
	},
	copy = {
		forbid_arcane = 2,
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
		life_rating = -3,
	},
}

local shield_special = function(e) -- allows any object with shield combat
	local combat = e.shield_normal_combat and e.combat or e.special_combat
	return combat and combat.block
end

newBirthDescriptor{
	type = "subclass",
	name = "Stone Warden",
	locked = function() return profile.mod.allow_build.wilder_stone_warden end,
	locked_desc = _t"The Spellblaze's scars may be starting to heal,\nbut little can change how the partisans feel.\nNature and arcane could bridge their divide -\nand when it comes down to it, gold won't take sides...",
	desc = {
		_t"Stone Wardens are dwarves trained in both the eldritch arts and the worship of nature.",
		_t"While other races are stuck in their belief that arcane forces and natural forces are meant to oppose, dwarves have found a way to combine them in harmony.",
		_t"Stone Wardens are armoured fighters, dual wielding shields to channel many of their powers.",
		_t"Their most important stats are: Strength, Magic and Willpower",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +2 Strength, +0 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +4 Magic, +3 Willpower, +0 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# +2",
	},
	special_check = function(birth)
		if birth.descriptors_by_type.race ~= "Dwarf" then return false end
		return true
	end,
	power_source = {nature=true, arcane=true},
	not_on_random_boss = true,
	stats = { str=2, wil=3, mag=4, },
	talents_types = {
		["wild-gift/call"]={true, 0.3},
		["wild-gift/earthen-power"]={true, 0.3},
		["wild-gift/earthen-vines"]={true, 0.3},
		["wild-gift/dwarven-nature"]={true, 0.3},
		["spell/stone-alchemy"]={false, 0.3},
		["spell/eldritch-stone"]={false, 0.3},
		["spell/eldritch-shield"]={true, 0.3},
		["spell/deeprock"]={false, 0.3},
		["spell/earth"]={true, 0.3},
		["spell/stone"]={false, 0.3},
		["cunning/survival"]={true, 0.0},
		["technique/combat-training"]={true, 0.0},
	},
	talents = {
		[ActorTalents.T_STONE_VINES] = 1,
		[ActorTalents.T_STONESHIELD] = 1,
		[ActorTalents.T_ELDRITCH_BLOW] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 3,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.auto_equip_filters{
			MAINHAND = {special=shield_special},
			OFFHAND = {special=shield_special}
		},
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}
