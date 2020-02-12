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

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")
local DamageType = require "engine.DamageType"

-------------------------------------------------------
-- Techniques------------------------------------------
-------------------------------------------------------
newEntity{
	power_source = {technique=true},
	name = "mighty ", prefix=true, instant_resolve=true,
	keywords = {mighty=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	wielder = {
		combat_dam = resolvers.mbonus_material(10, 5),
		inc_stats = {
			[Stats.STAT_STR] = resolvers.mbonus_material(6, 1),
		},
	},
}

newEntity{
	power_source = {technique=true},
	name = "ranger's ", prefix=true, instant_resolve=true,
	keywords = {ranger=true},
	level_range = {1, 50},
	rarity = 9,
	cost = 10,
	wielder = {
		inc_stats = {
			[Stats.STAT_DEX] = resolvers.mbonus_material(6, 1),
		},
	},
	resolvers.generic(function(e)
		e.combat.range = math.min(e.combat.range + 1, 10)
	end),
}

newEntity{
	power_source = {technique=true},
	name = "steady ", prefix=true, instant_resolve=true,
	keywords = {steady=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 15,
	wielder={
		combat_atk = resolvers.mbonus_material(10, 5),
		combat_physcrit = resolvers.mbonus_material(6, 1),
	},
}

-- Greater
newEntity{
	power_source = {technique=true},
	name = "swiftstrike ", prefix=true, instant_resolve=true,
	keywords = {swiftstrike=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 25,
	cost = 30,
	combat = {
		travel_speed = 2,
	},
	wielder = {
		inc_stats = {
			[Stats.STAT_CUN] = resolvers.mbonus_material(6, 1),
		},
		combat_physspeed = 0.1,
	},
}

newEntity{
	power_source = {technique=true},
	name = " of true flight", suffix=true, instant_resolve=true,
	keywords = {flight=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 40,
	resolvers.generic(function(e)
		e.combat.range = math.min(e.combat.range + 1, 10)
	end),
	wielder = {
		combat_atk = resolvers.mbonus_material(10, 5),
		combat_physcrit = resolvers.mbonus_material(10, 5),
	},
}

newEntity{
	power_source = {technique=true},
	name = " of piercing", suffix=true, instant_resolve=true,
	keywords = {piercing=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 40,
	wielder = {
		combat_atk = resolvers.mbonus_material(20, 5),
		combat_apr = resolvers.mbonus_material(10, 5),
		resists_pen = {
			['all'] = resolvers.mbonus_material(10, 5),
		},
	},
}


-------------------------------------------------------
-- Arcane Egos-----------------------------------------
-------------------------------------------------------
newEntity{
	power_source = {arcane=true},
	name = " of fire", suffix=true, instant_resolve=true,
	keywords = {fire=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 6,
	combat = {
		ranged_project={[DamageType.FIRE] = resolvers.mbonus_material(15, 5)},
	},
	wielder = {
		inc_damage={ [DamageType.FIRE] = resolvers.mbonus_material(14, 8), },
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of cold", suffix=true, instant_resolve=true,
	keywords = {cold=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 6,
	combat = {
		ranged_project={[DamageType.COLD] = resolvers.mbonus_material(15, 5)},
	},
	wielder = {
		inc_damage={ [DamageType.COLD] = resolvers.mbonus_material(14, 8), },
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of acid", suffix=true, instant_resolve=true,
	keywords = {acid=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 6,
	combat = {
		ranged_project={[DamageType.ACID] = resolvers.mbonus_material(15, 5)},
	},
	wielder = {
		inc_damage={ [DamageType.ACID] = resolvers.mbonus_material(14, 8), },
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of lightning", suffix=true, instant_resolve=true,
	keywords = {lightning=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 6,
	combat = {
		ranged_project={[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 5)},
	},
	wielder = {
		inc_damage={ [DamageType.LIGHTNING] = resolvers.mbonus_material(14, 8), },
	},
}

-- Greater
newEntity{
	power_source = {arcane=true},
	name = "penetrating ", prefix=true, instant_resolve=true,
	keywords = {penetrating=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 40,
	wielder = {
		apr = resolvers.mbonus_material(25, 5),
		resists_pen = {
			[DamageType.PHYSICAL] = resolvers.mbonus_material(20, 5),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "runic ", prefix=true, instant_resolve=true,
	keywords = {runic=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 30,
	wielder = {
		combat_spellpower = resolvers.mbonus_material(10, 5),
		inc_stats = {
			[Stats.STAT_MAG] = resolvers.mbonus_material(6, 1),
		},
		inc_damage = {
			[DamageType.ARCANE] = resolvers.mbonus_material(10, 5),
		},
	},
	combat = {
		talent_on_hit = { [Talents.T_ARCANE_VORTEX] = {level=resolvers.genericlast(function(e) return e.material_level end), chance=10}, },
	}
}

newEntity{
	power_source = {arcane=true},
	name = "warden's ", prefix=true, instant_resolve=true,
	keywords = {wardens=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		inc_stats = {
			[Stats.STAT_MAG] = resolvers.mbonus_material(6, 1),
		},
		resists_pen = {
			[DamageType.TEMPORAL] = resolvers.mbonus_material(5, 5),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 5),
		},
		inc_damage = {
			[DamageType.TEMPORAL] = resolvers.mbonus_material(5, 5),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 5),
		},
		talents_types_mastery = {
			["chronomancy/bow-threading"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
		ammo_reload_speed = resolvers.mbonus_material(4, 1),
		quick_weapon_swap = 1,
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of recursion", suffix=true, instant_resolve=true,
	keywords = {recursion=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	combat = {
		talent_on_hit = { [Talents.T_SHOOT] = {level=1, chance=10} },
	}
}

-------------------------------------------------------
-- Nature/Antimagic Egos:------------------------------
-------------------------------------------------------
-- **  NEED SOME LESSER ** --
newEntity{
	power_source = {nature=true},
	name = "fungal ", prefix=true, instant_resolve=true,
	keywords = {fungal=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 10,
	wielder = {
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(6, 1),
		},
		talents_types_mastery = {
			["wild-gift/fungus"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
	},
	charm_power = resolvers.mbonus_material(100, 5),
	charm_power_def = {add=50, max=200, floor=true},
	resolvers.charm(_t"regenerate %d life over 5 turns", 20,
		function(self, who)
			game.logSeen(who, "%s uses %s %s!", who:getName():capitalize(), who:his_her(), self:getName{no_add_name=true, do_color=true})
			who:setEffect(who.EFF_REGENERATION, 5, {power=self:getCharmPower(who)/5})
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{tactical = { HEAL = 2 }}
	),
}

-- Greater
newEntity{
	power_source = {nature=true},
	name = "blazebringer's ", prefix=true, instant_resolve=true,
	keywords = {blaze=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		global_speed_add = resolvers.mbonus_material(10, 1, function(e, v) v=v/100 return 0, v end),
		resists_pen = {
			[DamageType.FIRE] = resolvers.mbonus_material(20, 5),
		},
	},
	combat = {
		burst_on_crit = {
			[DamageType.FIRE] = resolvers.mbonus_material(80, 5),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "caustic ", prefix=true, instant_resolve=true,
	keywords = {caustic=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		combat_apr = resolvers.mbonus_material(10, 5),
		resists_pen = {
			[DamageType.ACID] = resolvers.mbonus_material(20, 5),
			[DamageType.NATURE] = resolvers.mbonus_material(20, 5),
		},
	},
	combat = {
		burst_on_crit = {
			[DamageType.ACID] = resolvers.mbonus_material(40, 5),
			[DamageType.NATURE] = resolvers.mbonus_material(40, 5),
		},
	}
}

newEntity{
	power_source = {nature=true},
	name = "stormbringer's ", prefix=true, instant_resolve=true,
	keywords = {stormbringer=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		movement_speed = resolvers.mbonus_material(30, 20, function(e, v) v=v/100 return 0, v end),
		resists_pen = {
			[DamageType.COLD] = resolvers.mbonus_material(20, 5),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 5),
		},
	},
	combat = {
		burst_on_crit = {
			[DamageType.LIGHTNING] = resolvers.mbonus_material(40, 5),
			[DamageType.COLD] = resolvers.mbonus_material(40, 5),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "enhanced ", prefix=true, instant_resolve=true,
	keywords = {enhanced=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		inc_stats = {
			[Stats.STAT_STR] = resolvers.mbonus_material(10, 3),
			[Stats.STAT_DEX] = resolvers.mbonus_material(10, 3),
			[Stats.STAT_MAG] = resolvers.mbonus_material(10, 3),
			[Stats.STAT_WIL] = resolvers.mbonus_material(10, 3),
			[Stats.STAT_CUN] = resolvers.mbonus_material(10, 3),
			[Stats.STAT_CON] = resolvers.mbonus_material(10, 3),
		},
	},
}


newEntity{
	power_source = {nature=true},
	name = " of enduring", suffix=true, instant_resolve=true,
	keywords = {enduring=true},
	level_range = {20, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(10, 5),
			[Stats.STAT_WIL] = resolvers.mbonus_material(10, 5),
		},
		max_life = resolvers.mbonus_material(100, 10),
	},
}

-- Antimagic
newEntity{
	power_source = {antimagic=true},
	name = " of dampening", suffix=true, instant_resolve=true,
	keywords = {dampening=true},
	level_range = {1, 50},
	rarity = 30,
	cost = 22,
	wielder = {
		resists={
			all = resolvers.mbonus_material(8, 2),
			[DamageType.ACID] = resolvers.mbonus_material(10, 7),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(10, 7),
			[DamageType.FIRE] = resolvers.mbonus_material(10, 7),
			[DamageType.COLD] = resolvers.mbonus_material(10, 7),
		},
		combat_spellresist = resolvers.mbonus_material(10, 5),
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "mage-hunter's ", prefix=true, instant_resolve=true,
	keywords = {magehunters=true},
	level_range = {30, 50},
	rarity = 30,
	cost = 22,
	greater_ego = 1,
	wielder = {
		inc_stats = {
			[Stats.STAT_WIL] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_CUN] = resolvers.mbonus_material(6, 1),
		},
		combat_mindpower = resolvers.mbonus_material(10, 5),
		talents_types_mastery = {
			["wild-gift/antimagic"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
		ranged_project = { 
			[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.mbonus_material(20, 5),
		},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "throat-seeking ", prefix=true, instant_resolve=true,
	keywords = {throat=true},
	level_range = {30, 50},
	rarity = 30,
	cost = 22,
	greater_ego = 1,
	wielder = {
		resists_pen = {
			[DamageType.NATURE] = resolvers.mbonus_material(10, 5),
		},
	},
	combat = {
		ranged_project = { 
			[DamageType.NATURE] = resolvers.mbonus_material(20, 5),
		},
		special_on_crit = {desc=_t"silences the target", fct=function(combat, who, target)
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, 2, {apply_power=who:combatAttack(), no_ct_effect=true})
			end
		end},
	},
}


-------------------------------------------------------
-- Psionic Egos ---------------------------------------
-------------------------------------------------------
-- **  NEED SOME LESSER ** --
-- Ammo has a lot of these

