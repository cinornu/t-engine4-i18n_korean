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

----------------------------------------------------------------
-- Resists Lesser - Suffix
----------------------------------------------------------------
newEntity{
	power_source = {technique=true},
	name = " of fire resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {fire=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 4,
	wielder = {
		resists={[DamageType.FIRE] = resolvers.mbonus_material(15, 15)},
	},
}
newEntity{
	power_source = {technique=true},
	name = " of cold resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {cold=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 4,
	wielder = {
		resists={[DamageType.COLD] = resolvers.mbonus_material(15, 15)},
	},
}

newEntity{
	power_source = {technique=true},
	name = " of lightning resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {lightning=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 4,
	wielder = {
		resists={[DamageType.LIGHTNING] = resolvers.mbonus_material(15, 15)},
	},
}
----------------------------------------------------------------
-- Rare Resists
----------------------------------------------------------------
newEntity{
	power_source = {technique=true},
	name = " of acid resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {acid=true},
	level_range = {1, 50},
	rarity = 12,
	cost = 4,
	wielder = {
		resists={[DamageType.ACID] = resolvers.mbonus_material(15, 15)},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = " of arcane resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {arcane=true},
	level_range = {10, 50},
	rarity = 12,
	cost = 4,
	wielder = {
		resists={[DamageType.ARCANE] = resolvers.mbonus_material(10, 10)},
	},
}
newEntity{
	power_source = {psionic=true},
	name = " of mind resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {mind=true},
	level_range = {10, 50},
	rarity = 12,
	cost = 4,
	wielder = {
		resists={[DamageType.MIND] = resolvers.mbonus_material(10, 10)},
	},
}
newEntity{
	power_source = {technique=true},
	name = " of physical resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {physical=true},
	level_range = {10, 50},
	rarity = 12,
	cost = 4,
	wielder = {
		resists={[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 10)},
	},
}
newEntity{
	power_source = {nature=true},
	name = " of purity", suffix=true, instant_resolve=true,
	keywords = {purity=true},
	level_range = {10, 50},
	rarity = 12,
	cost = 10,
	wielder = {
		resists={
			[DamageType.NATURE] = resolvers.mbonus_material(10, 10),
			[DamageType.BLIGHT] = resolvers.mbonus_material(10, 10),
		},
	},
}
newEntity{
	power_source = {arcane=true},
	name = " of reflection", suffix=true, instant_resolve=true,
	keywords = {reflection=true},
	level_range = {10, 50},
	rarity = 12,
	cost = 10,
	wielder = {
		resists={
			[DamageType.LIGHT] = resolvers.mbonus_material(10, 10),
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 10),
		},
	},
}
newEntity{
	power_source = {nature=true},
	name = " of temporal resistance (#RESIST#)", suffix=true, instant_resolve=true,
	keywords = {temporal=true},
	level_range = {10, 50},
	rarity = 18,
	cost = 4,
	wielder = {
		resists={[DamageType.TEMPORAL] = resolvers.mbonus_material(10, 10)},
		on_melee_hit={[DamageType.ITEM_TEMPORAL_ENERGIZE] = resolvers.mbonus_material(25, 10)},
	},
}

----------------------------------------------------------------
-- Lesser Elemental - Prefix
----------------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = "flaming ", prefix=true, instant_resolve=true,
	keywords = {flaming=true},
	level_range = {10, 50},
	rarity = 8,
	cost = 8,
	special_combat = {
		burst_on_hit={[DamageType.FIRE] = resolvers.mbonus_material(10, 10)},
	},
	wielder = {
		on_melee_hit={[DamageType.FIRE] = resolvers.mbonus_material(20, 1)},
		melee_project={
			[DamageType.FIRE] = resolvers.mbonus_material(5, 5),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "icy ", prefix=true, instant_resolve=true,
	keywords = {icy=true},
	level_range = {10, 50},
	rarity = 20,
	cost = 10,
	wielder = {
		on_melee_hit={[DamageType.ICE] = resolvers.mbonus_material(20, 1)},
		melee_project={
			[DamageType.COLD] = resolvers.mbonus_material(30, 5),
		},
	},
}
newEntity{
	power_source = {nature=true},
	name = "shocking ", prefix=true, instant_resolve=true,
	keywords = {shocking=true},
	level_range = {10, 50},
	rarity = 8,
	cost = 8,
	wielder = {
		on_melee_hit={[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 1)},
		melee_project={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(30, 5),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "acidic ", prefix=true, instant_resolve=true,
	keywords = {acidic=true},
	level_range = {10, 50},
	rarity = 8,
	cost = 8,
	special_combat = {
		melee_project={[DamageType.ITEM_ACID_CORRODE] = resolvers.mbonus_material(20, 10)},
	},
	wielder = {
		on_melee_hit={[DamageType.ACID] = resolvers.mbonus_material(20, 1)},
		melee_project={
			[DamageType.ACID] = resolvers.mbonus_material(5, 5),
		},
	},
}


----------------------------------------------------------------
-- Greater Elemental - Prefix 
----------------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = "exposing ", prefix=true, instant_resolve=true,
	keywords = {exposing=true},
	level_range = {10, 50},
	rarity = 20,
	cost = 12,
	wielder = {
		on_melee_hit={[DamageType.ITEM_MIND_EXPOSE] = resolvers.mbonus_material(25, 10)},
		melee_project={
			[DamageType.ITEM_MIND_EXPOSE] = resolvers.mbonus_material(10, 5),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "coruscating ", prefix=true, instant_resolve=true,
	keywords = {coruscating=true},
	level_range = {10, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.FIRE] = resolvers.mbonus_material(10, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.FIRE] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_STR] = resolvers.mbonus_material(5, 1),
		},
		on_melee_hit = {
			[DamageType.FIRE] = resolvers.mbonus_material(30, 1),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "crackling ", prefix=true, instant_resolve=true,
	keywords = {crackling=true},
	level_range = {1, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.LIGHTNING] = resolvers.mbonus_material(10, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_DEX] = resolvers.mbonus_material(5, 1),
		},
		on_melee_hit = {
			[DamageType.LIGHTNING] = resolvers.mbonus_material(30, 1),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "corrosive ", prefix=true, instant_resolve=true,
	keywords = {corrosive=true},
	level_range = {1, 50},
	greater_ego = 1,
	rarity = 20,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.ACID] = resolvers.mbonus_material(10, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.ACID] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(5, 1),
		},
		on_melee_hit = {
			[DamageType.ITEM_ACID_CORRODE] = resolvers.mbonus_material(10, 10),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = " of winter", suffix=true, instant_resolve=true,
	keywords = {wintry=true},
	level_range = {10, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 30,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.COLD] = resolvers.mbonus_material(20, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.COLD] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_WIL] = resolvers.mbonus_material(5, 1),
		},
	},
	on_block = {
		desc=function(self, who, special)
			local dam = special.shield_wintry(who)
			return ("Deals #YELLOW#%d#LAST# cold damage and freezes enemies in radius 4 to the ground for 3 turns (1/turn)"):tformat(dam)
		end,
		shield_wintry=function(who)
			local dam = math.max(15, math.floor(who:combatStatScale(who:combatMindpower(), 1, 300)))
			return dam
		end,
		fct=function(self, who, target, type, dam, eff, special)
			local DamageType = require "engine.DamageType"
			if who.turn_procs and who.turn_procs.shield_wintry then return end
			who.turn_procs.shield_wintry = true
			
			local dam = special.shield_wintry(who)
			local damage = who:spellCrit(dam)
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			local tg = {type="ball", range=0, radius=4, selffire=false, friendlyfire=false}
			local grids = who:project(tg, who.x, who.y, DamageType.COLDNEVERMOVE, {dur=3, dam=dam, apply_power = check})
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "circle", {oversize=1.1, a=255, limit_life=16, grow=true, speed=0, img="ice_nova", radius=tg.radius})
			game:playSoundNear(self, "talents/ice")
		end,			
	},
}

newEntity{
	power_source = {psionic=true},
	name = "windwalling ", prefix=true, instant_resolve=true,
	keywords = {windwalling=true},
	level_range = {1, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 20,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.PHYSICAL] = resolvers.mbonus_material(20, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_WIL] = resolvers.mbonus_material(5, 1),
		},
		slow_projectiles = resolvers.mbonus_material(30, 10),
		shield_windwall = resolvers.mbonus_material(100, 10),
	},
}

----------------------------------------------------------------
-- Lesser Misc
----------------------------------------------------------------
newEntity{
	power_source = {technique=true},
	name = "reinforced ", prefix=true, instant_resolve=true,
	keywords = {reinforced=true},
	level_range = {1, 50},
	rarity = 8,
	cost = 8,
	special_combat = {
		block = resolvers.mbonus_material(80, 20),
	},
	wielder = {
		combat_armor = resolvers.mbonus_material(10, 1),
	},
}

newEntity{
	power_source = {nature=true},
	name = " of resilience", suffix=true, instant_resolve=true,
	keywords = {resilience=true},
	level_range = {10, 50},
	rarity = 10,
	cost = 10,
	wielder = {
		max_life=resolvers.mbonus_material(60, 40),
	},
}

----------------------------------------------------------------
-- Greater Prefix
----------------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = "living ", prefix=true, instant_resolve=true,
	keywords = {living=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 60,
	special_combat = {
		melee_project = {
			[DamageType.NATURE] = resolvers.mbonus_material(10, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.NATURE] = resolvers.mbonus_material(10, 10),
			[DamageType.BLIGHT] = resolvers.mbonus_material(10, 10),
		},
		max_life = resolvers.mbonus_material(100, 20),
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "scouring ", prefix=true, instant_resolve=true,
	keywords = {scouring=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 25,
	cost = 30,
	wielder = {
		resists={
			[DamageType.ACID] = resolvers.mbonus_material(15, 5),
			[DamageType.NATURE] = resolvers.mbonus_material(15, 5),
		},
		on_melee_hit = {
			[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.mbonus_material(10, 5),
		},
		melee_project = {
			[DamageType.ACID] = resolvers.mbonus_material(20, 5),
			[DamageType.NATURE] = resolvers.mbonus_material(20, 5),
			[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.mbonus_material(20, 5),
		},
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(4, 3),
		},
	},
}


newEntity{
	power_source = {arcane=true},
	name = "warded ", prefix=true, instant_resolve=true,
	keywords = {ward=true},
	level_range = {10, 50},
	rarity = 40,
	greater_ego = 1,
	cost = 5,
	special_combat = {
		special_on_hit = {desc=_t"reduce the cooldown of your ward talent by 1", fct=function(combat, who, target)
		if who.talents_cd[who.T_WARD] then
			who.talents_cd[who.T_WARD] = who.talents_cd[who.T_WARD] - 1
		end
			
		end},
	},
	wielder = {
		wards = {
			-- Non-phys
			[DamageType.FIRE] = resolvers.mbonus_material(5, 3),
			[DamageType.COLD] = resolvers.mbonus_material(5, 3),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(5, 3),
			[DamageType.TEMPORAL] = resolvers.mbonus_material(5, 3),
			[DamageType.BLIGHT] = resolvers.mbonus_material(5, 3),
			[DamageType.ARCANE] = resolvers.mbonus_material(5, 3),
			[DamageType.DARKNESS] = resolvers.mbonus_material(5, 3),
			[DamageType.LIGHT] = resolvers.mbonus_material(5, 3),
			[DamageType.NATURE] = resolvers.mbonus_material(5, 3),
		},
		learn_talent = {[Talents.T_WARD] = 1},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "wrathful ", prefix=true, instant_resolve=true,
	keywords = {wrathful=true},
	level_range = {10, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 20,
	cost = 60,
	special_combat = {  -- Aggressive values are safe even at L10 because this is on crit
		burst_on_crit={
			[DamageType.FIRE] = resolvers.mbonus_material(30, 10),
			[DamageType.LIGHT] = resolvers.mbonus_material(30, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.FIRE] = resolvers.mbonus_material(10, 5),
			[DamageType.LIGHT] = resolvers.mbonus_material(10, 5),
		},
	},
	on_block = {
		desc=function(self, who, special)
			local dam = special.shield_wrathful(who)
			return ("Deals #VIOLET#%d#LAST# light and fire damage to each enemy blocked"):tformat(dam)
		end,
		shield_wrathful=function(who)
			local dam = math.max(15, math.floor(who:combatStatScale(who:combatSpellpower(), 1, 450) / 2))
			return dam
		end,
		fct=function(self, who, target, type, dam, eff, special)
			if not target or target:attr("dead") or not target.x or not target.y then return end
			if who.turn_procs and who.turn_procs.shield_wrathful and who.turn_procs.shield_wrathful[target.uid] then return end

			-- Set this *before* damage or reflect/martyr avoids the limit
			if not who.turn_procs.shield_wrathful then who.turn_procs.shield_wrathful = {} end
			who.turn_procs.shield_wrathful[target.uid] = true
			

			local tg = {type="hit", range=10}
			local dam = special.shield_wrathful(who)
			local damage = who:spellCrit(dam)

			who:project(tg, target.x, target.y, engine.DamageType.FIRE, damage)
			who:project(tg, target.x, target.y, engine.DamageType.LIGHT, damage)
		end,
	},
}

newEntity{
	power_source = {technique=true},
	name = "impervious ", prefix=true, instant_resolve=true,
	keywords = {impervious=true},
	level_range = {40, 50},
	greater_ego = 1,
	rarity = 18,
	cost = 40,
	special_combat = {
		block = resolvers.mbonus_material(90, 30),
	},
	wielder = {
		combat_armor = resolvers.mbonus_material(8, 4),
		combat_physresist = resolvers.mbonus_material(10, 5),
		inc_stats = {
			[Stats.STAT_CON] = resolvers.mbonus_material(4, 3),
		},
	},
}

newEntity{
	power_source = {technique=true},
	name = "swashbuckler's ", prefix=true, instant_resolve=true,
	keywords = {impervious=true},
	level_range = {10, 50},
	greater_ego = 1,
	rarity = 18,
	cost = 40,
	wielder = {
		combat_atk = resolvers.mbonus_material(20, 4),
		inc_stats = {
			[Stats.STAT_DEX] = resolvers.mbonus_material(12, 1),
			[Stats.STAT_STR] = resolvers.mbonus_material(12, 1),
		},
	},
}


----------------------------------------------------------------
-- Greater Suffix
----------------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = " of resistance", suffix=true, instant_resolve=true,
	keywords = {resistance=true},
	level_range = {10, 50},
	greater_ego = 1,
	rarity = 24,
	cost = 20,
	wielder = {
		resists={
			[DamageType.ACID] = resolvers.mbonus_material(8, 5),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(8, 5),
			[DamageType.FIRE] = resolvers.mbonus_material(8, 5),
			[DamageType.COLD] = resolvers.mbonus_material(8, 5),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of patience", suffix=true, instant_resolve=true,
	keywords = {patience=true},
	level_range = {30, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 30,
	cost = 40,
	resolvers.charmt(Talents.T_TIME_SHIELD, {2,3,4,5}, 30 ),
	wielder = {
		resists={
			[DamageType.TEMPORAL] = resolvers.mbonus_material(10, 10),
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of the stars", suffix=true, instant_resolve=true,
	keywords = {stars=true},
	level_range = {10, 50},
	rarity = 14,
	greater_ego = 1,
	cost = 12,
	special_combat = {
		melee_project={
			[DamageType.LIGHT] = resolvers.mbonus_material(10, 10),
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.LIGHT] = resolvers.mbonus_material(10, 10),
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 10),
		},
		inc_damage={
			[DamageType.LIGHT] = resolvers.mbonus_material(10, 10),
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 10),
		},
		inc_stats = {
			[Stats.STAT_MAG] = resolvers.mbonus_material(10, 1),
			[Stats.STAT_CUN] = resolvers.mbonus_material(10, 1),
		},
	},
}


newEntity{
	power_source = {technique=true},
	name = " of crushing", suffix=true, instant_resolve=true,
	keywords = {crushing=true},
	level_range = {30, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 18,
	cost = 20,
	special_combat = {
		dam = resolvers.mbonus_material(5, 5),
		special_on_crit = {
			desc=_t"Smash the target reducing mind, spell, and combat action speeds by 30%", 
			fct=function(combat, who, target)
				target:setEffect(target.EFF_CRIPPLE, 4, {src=who, apply_power=who:combatAttack(combat)})
			end
		},
	},
	wielder = {
		combat_dam = resolvers.mbonus_material(10, 5),
		combat_physcrit = resolvers.mbonus_material(15, 3),
	},
}

-- needs gfx
newEntity{
	power_source = {technique=true},
	name = " of shrapnel", suffix=true, instant_resolve=true,
	keywords = {shrapnel=true},
	level_range = {10, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 20,
	cost = 60,
	on_block = {
		desc=function(self, who, special)
			local dam = special.shield_shrapnel(who)
			return ("Cause enemies within radius 6 to bleed for #RED#%d#LAST# physical damage over 5 turns (1/turn)"):tformat(dam)
		end,
		shield_shrapnel=function(who)
			local dam = math.max(15, math.floor(who:combatStatScale(who:combatPhysicalpower(), 1, 350)))
			return dam
		end,
		fct=function(self, who, target, type, dam, eff, special)
			if who.turn_procs and who.turn_procs.shield_shrapnel then return end
			who.turn_procs.shield_shrapnel = true
			game.logSeen(who, "Shards of metal explode from %s's shield!", who:getName():capitalize())
			local tg = {type="ball", friendlyfire=false, radius=6}
			local dam = special.shield_shrapnel(who)
			local damage = who:physicalCrit(dam)
			local grids = who:project(tg, who.x, who.y, engine.DamageType.BLEED, damage)
		end,
	},
}

newEntity{
	power_source = {nature=true},
	name = " of earthen fury", suffix=true, instant_resolve=true,
	keywords = {earth=true},
	level_range = {30, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 25,
	cost = 40,
	special_combat = {
		special_on_hit = {
		desc=function(self, who, special)
			local dam = who:combatArmor()
			return ("Deal physical damage equal to your armor (%d)"):tformat(dam)
		end,
		fct=function(combat, who, target)
			local tg = {type="hit", range=1}
			local damage = who:combatArmor()
			who:project(tg, target.x, target.y, engine.DamageType.PHYSICAL, damage)
		end
		},
	},
	wielder = {
		combat_armor = resolvers.mbonus_material(10, 1),
	},
}

