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

load("/data/general/objects/objects-far-east.lua")
load("/data/general/objects/lore/sunwall.lua")

local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"

newEntity{ base = "BASE_LORE",
	define_as = "ARGONIEL_DIAMOND", image = "object/artifact/bloodsoaked_resonating_diamond.png",
	name = "bloodsoaked diamond", lore="argoniel-1",
	desc = _t[[A strangely wet diamond.]],
	rarity = false,
	encumberance = 0,
}
	
newEntity{ base = "BASE_LORE",
	define_as = "ARGONIEL_ATHAME", image = "object/artifact/bloodsoaked_runed_athame.png",
	name = "bloodsoaked athame", lore="argoniel-2",
	desc = _t[[A strangely wet athame.]],
	rarity = false,
	encumberance = 0,
}

newEntity{ base = "BASE_LORE",
	define_as = "ELANDAR_JOURNAL1",
	name = "journal", lore="elandar-1", image = "object/artifact/elandars_journal.png",
	desc = _t[[A magically-preserved journal.]],
	rarity = false,
	encumberance = 0,
}

newEntity{ base = "BASE_LORE",
	define_as = "ELANDAR_JOURNAL2",
	name = "journal", lore="elandar-2", image = "object/artifact/elandars_journal.png",
	desc = _t[[A magically-preserved journal.]],
	rarity = false,
	encumberance = 0,
}

-- The staff of absorption, the reason the game exists!
newEntity{ define_as = "STAFF_ABSORPTION_AWAKENED", base="BASE_STAFF",
	power_source = {unknown=true},
	unique = true, godslayer=true, flavor_name = "magestaff",
	flavors = {magestaff=true},
	name = "Awakened Staff of Absorption",
--	identified=true,
	unided_name = _t"ominous, dark runed staff",
	force_lore_artifact=true,
	display = "\\", color=colors.VIOLET, image = "object/artifact/staff_absorption.png",
	moddable_tile = "special/%s_awaken_staff_of_absorbtion",
	encumber = 7,
	material_level = 5,
	plot=true,
	desc = _t[[Carved with runes of power, this staff seems to have been made long ago, yet it bears no signs of tarnish.
Light around it seems to dim and you can feel its tremendous power simply by touching it.
The Sorcerers seem to have awakened its power.
#{italic}#"And lo they came to Amakthel himself, and thousands were killed in the assault on his throne, and three of the Godslayers were broken beneath his feet. But Falion with his dying breath pierced the great god on his knee with the icy sword Arkil, and seeing his opportunity Caldizar, leader of the Godslayers, advanced with the Staff of Absorption and struck a terrifying blow against Amakthel. So fell the greatest of the gods by the hands of his own children, and his face was forced into the dust."#{normal}#]],

	require = { stat = { mag=40 }, },
	combat = {
		dam = 60,
		apr = 60,
		atk = 30,
		dammod = {mag=1.3},
		damtype = DamageType.ARCANE,
		is_greater = true,
		of_breaching = true,
	--	of_retribution = true,
	},
	wielder = {
		combat_spellpower = 48,
		combat_spellcrit = 15,
		max_mana = 100,
		max_positive = 50,
		max_negative = 50,
		inc_stats = { [Stats.STAT_MAG] = 10, [Stats.STAT_WIL] = 10 },
		inc_damage={
			[DamageType.FIRE] = 60,
			[DamageType.LIGHTNING] = 60,
			[DamageType.COLD] = 60,
			[DamageType.ARCANE] = 60,
		},
		resists_pen={
			[DamageType.FIRE] = 30,
			[DamageType.LIGHTNING] = 30,
			[DamageType.COLD] = 30,
			[DamageType.ARCANE] = 30,
		},
		--[[elemental_retribution = {
			[DamageType.FIRE] = 1,
			[DamageType.LIGHTNING] = 1,
			[DamageType.COLD] = 1,
			[DamageType.ARCANE] = 1,
		},]]
		learn_talent = { [Talents.T_COMMAND_STAFF] = 1, }, --[Talents.T_ELEMENTAL_RETRIBUTION] = 5,},
		speaks_shertul = 1,
	},

	-- This is not a simple artifact, it is a godslayer, show off!
	resolvers.generic(function(e) e:addParticles(engine.Particles.new("godslayer_swirl", 1, {})) end),
	moddable_tile_particle = {"godslayer_swirl", {size=64, x=-16}},

	max_power = 200, power_regen = 1,
	use_power = {
		name = function(self, who) return ("absorb the essence (ignoring resistance and bypassing most defenses) of a target in range %d, draining 30%% of its life and increasing your own damage by 30%% for %d turns"):tformat(self.use_power.range, self.use_power.duration) end,
		power = 200,
		range = 8,
		duration =7,
		target = function(self, who) return {type="hit", range=self.use_power.range} end,
		tactical = {ATTACK = 3,
			BUFF = function(who, t, aitarget)
				return not who:hasEffect(who.EFF_POWER_OVERLOAD) and 3
			end},
		requires_target = true,
		talent_level = 7,
		use = function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			local target = game.level.map(x, y, engine.Map.ACTOR)
			if not target then return nil end

			-- bypass normal defenses
			local bone_shield = target:isTalentActive(target.T_BONE_SHIELD)
			local nb = bone_shield and bone_shield.nb
			if bone_shield then bone_shield.nb = 0 end
			who:attr("iceblock_pierce", 100)
			who:attr("damage_shield_penetrate", 100)
			_, x = target:takeHit(target.max_life * 0.3, who, {special_death_msg = ("was absorbed by the %s held by %s"):tformat(self:getName(), who.name:capitalize())})
			who:attr("damage_shield_penetrate", -100)
			who:attr("iceblock_pierce", -100)
			if bone_shield then bone_shield.nb = nb end
			who:logCombat(target, "#Source# brandishes %s %s, absorbing the essence of #target#!", who:his_her(), self:getName({do_color=true, no_add_name=true}), target:getName():capitalize())
			game:delayedLogDamage(who, target, x, ("#ORCHID# %d essence drain#LAST#"):tformat(x), false)
			who:setEffect(who.EFF_POWER_OVERLOAD, self.use_power.duration, {power=30})
			return {id=true, used=true}
		end
	},
}

newEntity{ define_as = "PEARL_LIFE_DEATH",
	power_source = {nature=true},
	unique = true,
	type = "gem", subtype="white",
	unided_name = _t"shining pearl",
	name = "Pearl of Life and Death",
	display = "*", color=colors.WHITE, image = "object/artifact/pearl_of_life.png",
	encumber = 2,
	plot=true,
	desc = _t[[A pearl, three times the size of a normal pearl, that glitters in infinite colours, with slight patterns ever shifting away.]],

	carrier = {
		lite = 1,
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_DEX] = 5, [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 5, [Stats.STAT_CUN] = 5, [Stats.STAT_CON] = 5, [Stats.STAT_LCK] = 10 },
		inc_damage = {all = 7},
		resists = {all = 7},
		stun_immune = 1,
	},
}
