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

local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"
local DamageType = require "engine.DamageType"

newEntity{
	power_source = {technique=true},
	name = "cruel ", prefix=true, instant_resolve=true,
	keywords = {cruel=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	wielder = {
		combat_spellcrit = resolvers.mbonus_material(10, 5),
		combat_critical_power = resolvers.mbonus_material(10, 10),
	},
}

newEntity{
	power_source = {arcane=true},
	name = "earthen ", prefix=true, instant_resolve=true,
	keywords = {earthen=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	wielder = {
		combat_armor = resolvers.mbonus_material(10, 2),
		combat_armor_hardiness = resolvers.mbonus_material(10, 2),
		combat_physresist = resolvers.mbonus_material(10, 2),
	},
}

newEntity{
	power_source = {arcane=true},
	name = "potent ", prefix=true, instant_resolve=true,
	keywords = {potent=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 5,
	combat = {
		dam = resolvers.mbonus_material(10, 2),
	},
	wielder = {
		combat_spellpower = resolvers.mbonus_material(3, 2),
	},
	resolvers.command_staff(),
}

newEntity{
	power_source = {arcane=true},
	name = "shimmering ", prefix=true, instant_resolve=true,
	keywords = {shimmering=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 8,
	wielder = {
		max_mana = resolvers.mbonus_material(70, 30),
		mana_regen = resolvers.mbonus_material(30, 10, function(e, v) v=v/100 return 0, v end),
	},
}

newEntity{
	power_source = {arcane=true},
	name = "surging ", prefix=true, instant_resolve=true,
	keywords = {surging=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	wielder = {
		spellsurge_on_crit = resolvers.mbonus_material(10, 2),
	},
}

newEntity{
	power_source = {arcane=true},
	name = "blighted ", prefix=true, instant_resolve=true,
	keywords = {blight=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		vim_on_crit = resolvers.mbonus_material(5, 1),
		max_vim =  resolvers.mbonus_material(30, 10),
		combat_spellpower = resolvers.mbonus_material(10, 2),
		combat_spellcrit = resolvers.mbonus_material(5, 5),
	},
}

newEntity{
	power_source = {arcane=true},
	name = "ethereal ", prefix=true, instant_resolve=true,
	keywords = {ethereal=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(5, 3),
		combat_def = resolvers.mbonus_material(15, 10),
		damage_shield_penetrate = resolvers.mbonus_material(20, 10),
		shield_factor=resolvers.mbonus_material(15, 5),
	},
}

-- Applies all of a Command Staff subtype instead of just one selected element.. I think
newEntity{
	power_source = {arcane=true},
	name = "greater ", prefix=true, instant_resolve=true,
	keywords = {greater=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 45,
	combat = {is_greater = true,},
	wielder = {
		combat_spellpower = resolvers.mbonus_material(10, 3),
	},
	resolvers.command_staff(),
}

newEntity{
	power_source = {arcane=true},
	name = "void walker's ", prefix=true, instant_resolve=true,
	keywords = {['v. walkers']=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 30,
	wielder = {
		resists = {
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 5),
			[DamageType.TEMPORAL] = resolvers.mbonus_material(10, 5),
	},
		resist_all_on_teleport = resolvers.mbonus_material(20, 5),
		defense_on_teleport = resolvers.mbonus_material(20, 5),
		effect_reduction_on_teleport = resolvers.mbonus_material(20, 5),
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of fate", suffix=true, instant_resolve=true,
	keywords = {fate=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	wielder = {
		combat_physresist = resolvers.mbonus_material(10, 5),
		combat_mentalresist = resolvers.mbonus_material(10, 5),
		combat_spellresist = resolvers.mbonus_material(10, 5),
		combat_spellcrit = resolvers.mbonus_material(5, 3),
	},
}

-- this ego needs something
newEntity{
	power_source = {nature=true},
	name = " of illumination", suffix=true, instant_resolve=true,
	keywords = {illumination=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	wielder = {
		combat_def = resolvers.mbonus_material(10, 5),
		lite = resolvers.mbonus_material(3, 2),
	},
	resolvers.charmt(Talents.T_ILLUMINATE, {1,2}, 6, "T_GLOBAL_CD",
		{no_npc_use = function(self, who) return self:restrictAIUseObject(who) end} -- don't let dumb ai do stupid things with this
	),
}

newEntity{
	power_source = {arcane=true},
	name = " of might", suffix=true, instant_resolve=true,
	keywords = {might=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 8,
	wielder = {
		combat_spellcrit = resolvers.mbonus_material(10, 5),
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of power", suffix=true, instant_resolve=true,
	keywords = {power=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 10,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(15, 4),
	},
}

-- Adds wards for each element on the staff?
newEntity{
	power_source = {arcane=true},
	name = " of warding", suffix=true, instant_resolve=true,
	keywords = {warding=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 20,
	wielder = {
		combat_armor = resolvers.mbonus_material(4, 4),
		combat_def = resolvers.mbonus_material(4, 4),
		learn_talent = {
			[Talents.T_WARD] = resolvers.mbonus_material(4, 1),
		},
		wards = {},
	},
	combat = {of_warding = true},
	command_staff = {of_warding = {add=2, mult=0, "wards"}},
	resolvers.command_staff(),
}

-- 50% of all staff elements as resistance penetration
newEntity{
	power_source = {arcane=true},
	name = " of breaching", suffix=true, instant_resolve=true,
	keywords = {breaching=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		resists_pen = {},
	},
	combat = {of_breaching = true},
	command_staff = {resists_pen=0.5,},
	resolvers.command_staff(),
}

newEntity{
	power_source = {arcane=true},
	name = " of channeling", suffix=true, instant_resolve=true,
	keywords = {channeling=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 45,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(10, 8),
		mana_regen = resolvers.mbonus_material(50, 10, function(e, v) v=v/100 return 0, v end),
	},
	resolvers.charm(_t"channel mana (increasing mana regeneration by 2000%% for 5 turns)", 30,
		function(self, who)
			if who.mana_regen > 0 and not who:hasEffect(who.EFF_MANASURGE) then
				game.logSeen(who, "%s channels mana through %s %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
				who:setEffect(who.EFF_MANASURGE, 5, {power=who.mana_regen * 20})
			else
				if who.mana_regen < 0 then
					game.logPlayer(who, "Your negative mana regeneration rate is unaffected by the staff.")
				elseif who:hasEffect(who.EFF_MANASURGE) then
					game.logPlayer(who, "Another mana surge is currently active.")
				else
					game.logPlayer(who, "Your nonexistant mana regeneration rate is unaffected by the staff.")
				end
			end
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{tactical = {MANA = 1}}
	),
}

newEntity{
	power_source = {arcane=true},
	name = " of greater warding", suffix=true, instant_resolve=true,
	keywords = {['g. warding']=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		combat_armor = resolvers.mbonus_material(6, 6),
		combat_def = resolvers.mbonus_material(6, 6),
		learn_talent = {
			[Talents.T_WARD] = resolvers.mbonus_material(4, 1),
		},
		wards = {},
	},
	combat = {of_greater_warding = true},
	command_staff = {of_greater_warding = {add=3, mult=0, "wards"}},
	resolvers.command_staff(),
}

newEntity{
	power_source = {arcane=true},
	name = " of invocation", suffix=true, instant_resolve=true,
	keywords = {invocation=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 50,
	cost = 40,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(5, 5),
		spellsurge_on_crit = resolvers.mbonus_material(5, 5),
	},
	resolvers.charm(
		function(self, who)
			local damtype = engine.DamageType:get(self.combat.element or "ARCANE")
			local radius = self.use_power.radius(self)
			local dam = who:damDesc(damtype, self.use_power.damage(self, who))
			local damrange = self.use_power.damrange(self, who)
			return ("conjure elemental energy in a radius %d cone, dealing %0.2f to %0.2f %s damage"):tformat( radius, dam, dam*damrange, damtype.name)
		end,
		8,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local weapon = who:hasStaffWeapon()
			if not weapon then return end
			local combat = weapon.combat

			local DamageType = require "engine.DamageType"
			local damtype = combat.element or DamageType.ARCANE
			local explosion
			
			if     damtype == DamageType.FIRE then      explosion = "flame"
			elseif damtype == DamageType.COLD then      explosion = "freeze"
			elseif damtype == DamageType.ACID then      explosion = "acid"
			elseif damtype == DamageType.LIGHTNING then explosion = "lightning_explosion"
			elseif damtype == DamageType.LIGHT then     explosion = "light"
			elseif damtype == DamageType.DARKNESS then  explosion = "dark"
			elseif damtype == DamageType.NATURE then    explosion = "slime"
			elseif damtype == DamageType.BLIGHT then    explosion = "slime"
			elseif damtype == DamageType.PHYSICAL then  explosion = "dark"
			elseif damtype == DamageType.TEMPORAL then  explosion = "light"
			else                                        explosion = "manathrust"          -- damtype = DamageType.ARCANE
			end

			local x, y = who:getTarget(tg)
			if not x or not y then return nil end

			-- Compute damage
			local dam = self.use_power.damage(self, who)
			local damrange = self.use_power.damrange(self, who)
			local damTyp = DamageType:get(damtype or "ARCANE")
			dam = rng.range(dam, dam * damrange)
			dam = who:spellCrit(dam)
			game.logSeen(who, "%s channels a cone of %s%s#LAST# energy through %s %s!", who:getName():capitalize(), damTyp.text_color, damTyp.name, who:his_her(), self:getName({no_add_name = true, do_color = true}))
			who:project(tg, x, y, damtype, dam, {type=explosion})

			game:playSoundNear(who, "talents/arcane")
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{range = 0,
		radius = function(self, who) return 2*self.material_level end,
		requires_target = true,
		target = function(self, who) return {type="cone", range=self.use_power.range, radius=self.use_power.radius(self, who), selffire=false} end,
		tactical = { ATTACKAREA = function(who, t, aitarget)
			local weapon = who:hasStaffWeapon()
			if not weapon or not weapon.combat then return 1 end
			return {[weapon.combat.element or "ARCANE"] = 1 + (who.talents["T_STAFF_MASTERY"] or 0)/2.5} -- tactical AI adds staff skill to effective talent level of this ability
		end},
		damage = function(self, who) return who:combatDamage(self.combat) end,
		damrange = function(self, who) return who:combatDamageRange(self.combat) end}
	),
}

-- Adds 50% of each damage element on the staff to resists.. I think
newEntity{
	power_source = {arcane=true},
	name = " of protection", suffix=true, instant_resolve=true,
	keywords = {protection=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		resists = {},
	},
	combat = {of_protection = true},
	command_staff = {resists = 0.5,},
	resolvers.command_staff(),
}

newEntity{
	power_source = {arcane=true},
	name = " of wizardry", suffix=true, instant_resolve=true,
	keywords = {wizardry=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 18,
	cost = 45,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(10, 2),
		max_mana = resolvers.mbonus_material(100, 10),
		inc_stats = { [Stats.STAT_MAG] = resolvers.mbonus_material(5, 1), [Stats.STAT_WIL] = resolvers.mbonus_material(5, 1) },
	},
}

newEntity{
	power_source = {nature=true},
	name = "lifebinding ", prefix=true, instant_resolve=true,
	keywords = {lifebinding=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 16,
	cost = 35,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(7, 3),
		life_regen = resolvers.mbonus_material(15, 5, function(e, v) v=v/10 return 0, v end),
		healing_factor = resolvers.mbonus_material(20, 10, function(e, v) v=v/100 return 0, v end),
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(4, 3),
			},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "infernal ", prefix=true, instant_resolve=true,
	keywords = {infernal=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 16,
	cost = 35,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(7, 3),
		combat_critical_power = resolvers.mbonus_material(25, 15),
		see_invisible = resolvers.mbonus_material(15, 5),
		melee_project = {
			[DamageType.FIRE] = resolvers.mbonus_material(20, 15),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "bloodlich's ", prefix=true, instant_resolve=true,
	keywords = {bloodlich=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 90,
	wielder = {
		inc_stats = {
			[Stats.STAT_CUN] = resolvers.mbonus_material(9, 1),
			[Stats.STAT_CON] = resolvers.mbonus_material(9, 1),
			[Stats.STAT_MAG] = resolvers.mbonus_material(9, 1),
		},
		combat_critical_power = resolvers.mbonus_material(20, 10),
		vim_on_crit = resolvers.mbonus_material(5, 3),
		max_vim =  resolvers.mbonus_material(30, 20),
		max_negative =  resolvers.mbonus_material(30, 20),
		negative_regen = 0.2
	},
}

newEntity{
	power_source = {arcane=true},
	name = "magelord's ", prefix=true, instant_resolve=true,
	keywords = {magelord=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 60,
	wielder = {
		combat_physcrit = resolvers.mbonus_material(8, 6),
		max_mana = resolvers.mbonus_material(100, 20),
		combat_spellpower = resolvers.mbonus_material(5, 5),
		melee_project = {
			[DamageType.ARCANE] = resolvers.mbonus_material(30, 15),
		},
	},
}

newEntity{
	power_source = {technique=true},
	name = "short ", prefix=true, instant_resolve=true, dual_wieldable = true,
	slot_forbid = false,
	twohanded = false,
	keywords = {short=true},
	level_range = {1, 50},
	rarity = 15,
	cost = 25,
	combat = {
		accuracy_effect_scale = 0.5,
	},
	wielder = {
	},
	resolvers.genericlast(function(e)
		if e.moddable_tile:find("_hand_08_0[1-5]") then
			e.moddable_tile = e.moddable_tile:gsub("_hand_08_0([1-5])", "_hand_08_0%1_1h")
		end
	end),
}

newEntity{
	power_source = {technique=true},
	name = "magewarrior's short ", prefix=true, instant_resolve=true, dual_wieldable = true,
	slot_forbid = false,
	twohanded = false,
	keywords = {magewarrior=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 60,
	combat = {
		accuracy_effect_scale = 0.5,
	},
	wielder = {
		combat_atk = resolvers.mbonus_material(10, 5),
		combat_dam = resolvers.mbonus_material(10, 5),
		combat_spellpower = resolvers.mbonus_material(5, 5),
		combat_physcrit = resolvers.mbonus_material(5, 5),
		combat_spellcrit = resolvers.mbonus_material(2, 2),
	},
	resolvers.genericlast(function(e)
		if e.moddable_tile:find("_hand_08_0[1-5]") then
			e.moddable_tile = e.moddable_tile:gsub("_hand_08_0([1-5])", "_hand_08_0%1_1h")
		end
	end)
}

newEntity{
	power_source = {arcane=true},
	name = " of the prodigy", suffix=true, instant_resolve=true,
	keywords = {prodigy=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 50,
	cost = 45,
	wielder = {
		spellsurge_on_crit = resolvers.mbonus_material(5, 5),
		inc_stats = { [Stats.STAT_MAG] = resolvers.mbonus_material(15, 5), [Stats.STAT_WIL] = resolvers.mbonus_material(15, 5), [Stats.STAT_CUN] = resolvers.mbonus_material(15, 5) },
	},
}

newEntity{
	power_source = {arcane=true},
	name = "imbued ", prefix=true, instant_resolve=true,
	keywords = {imbued=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 50,
	cost = 45,
	unique_ego = true,
	imbued_talent_level = resolvers.mbonus_material(5, 1),
	resolvers.genericlast(function(e)
		local talents = {
			T_FLAME = 10,
			T_LIGHTNING = 10,
			T_MANATHRUST = 10,
			T_GLACIAL_VAPOUR = 10,
			T_MOONLIGHT_RAY=10,
			T_SUN_BEAM = 10,
			T_EARTHEN_MISSILES = 10,

			T_SOUL_ROT=8,
			T_DRAIN=8,

			T_TEMPORAL_BOLT=6,
			T_DUST_TO_DUST=6,
			T_RETHREAD=6,

			T_EPIDEMIC=5,
			T_ICE_SHARDS = 5,
			T_CHAIN_LIGHTNING = 5,
			T_FIREFLASH = 5,
			T_ARCANE_VORTEX = 5,

			T_CURSE_OF_DEFENSELESSNESS=3,
			T_CURSE_OF_IMPOTENCE=3,
			T_CURSE_OF_DEATH=3,
			T_CURSE_OF_VULNERABILITY=3,
			T_IMPENDING_DOOM = 3,
			T_FREEZE = 3,
			T_DISPLACEMENT_SHIELD = 3,

			T_SUNCLOAK = 1,
			T_BONE_SPEAR = 1,
			T_CHANNEL_STAFF = 1,
			T_EARTHQUAKE = 1,
			T_ENTROPY = 1,
		}
		local spells_probability = {}
		local picked
		for k,v in pairs(talents) do
			for i=1,v do
				spells_probability[#spells_probability+1] = k
			end
		end
		picked = rng.table(spells_probability);
		e.talent_on_spell = { {chance=10, talent=engine.interface.ActorTalents[picked], level=e.imbued_talent_level or 1} }
	end),
}
