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

-- TODO:  More greater suffix psionic; more lesser suffix and prefix psionic

local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"
local DamageType = require "engine.DamageType"

-------------------------------------------------------
--Nature ----------------------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = "blooming ", prefix=true, instant_resolve=true,
	keywords = {blooming=true},
	level_range = {1, 50},
	rarity = 8,
	cost = 8,
	wielder = {
		heal_on_nature_summon = resolvers.mbonus_material(50, 10),
		healing_factor = resolvers.mbonus_material(20, 10, function(e, v) v=v/100 return 0, v end),
	},
}

newEntity{
	power_source = {nature=true},
	name = "gifted ", prefix=true, instant_resolve=true,
	keywords = {gifted=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		combat_mindpower = resolvers.mbonus_material(10, 2),
	},
}

newEntity{
	power_source = {nature=true},
	name = "nature's ", prefix=true, instant_resolve=true,
	keywords = {nature=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		inc_damage={
			[DamageType.NATURE] = resolvers.mbonus_material(8, 2),
		},
		disease_immune = resolvers.mbonus_material(15, 10, function(e, v) v=v/100 return 0, v end),
		resists={
			[DamageType.BLIGHT] = resolvers.mbonus_material(8, 2),
		},
	},
}

-- Suffix
-------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = " of balance", suffix=true, instant_resolve=true,
	keywords = {balance=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		combat_physresist = resolvers.mbonus_material(8, 2),
		combat_spellresist = resolvers.mbonus_material(8, 2),
		combat_mentalresist = resolvers.mbonus_material(8, 2),
		equilibrium_regen_when_hit = resolvers.mbonus_material(20, 5, function(e, v) v=v/10 return 0, v end),
	},
}

newEntity{
	power_source = {nature=true},
	name = " of life", suffix=true, instant_resolve=true,
	keywords = {life=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		max_life = resolvers.mbonus_material(40, 10),
		life_regen = resolvers.mbonus_material(15, 5, function(e, v) v=v/10 return 0, v end),
	},
}

-------------------------------------------------------
--Greater nature --------------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = "caller's ", prefix=true, instant_resolve=true,
	keywords = {callers=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
	    heal_on_nature_summon = resolvers.mbonus_material(30, 15),
	    nature_summon_max = resolvers.mbonus_material(2,1),
		inc_damage = {
			[DamageType.FIRE] = resolvers.mbonus_material(10, 5),
			[DamageType.ACID] = resolvers.mbonus_material(10, 5),
			[DamageType.COLD] = resolvers.mbonus_material(10, 5),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 5),
		},
		resists_pen = {
			[DamageType.FIRE] = resolvers.mbonus_material(8, 2),
			[DamageType.ACID] = resolvers.mbonus_material(8, 2),
			[DamageType.COLD] = resolvers.mbonus_material(8, 2),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "harmonious ", prefix=true, instant_resolve=true,
	keywords = {harmonious=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 40,
	wielder = {
		talents_types_mastery = {
			["wild-gift/harmony"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
		inc_damage={
			[DamageType.NATURE] = resolvers.mbonus_material(8, 2),
		},
		resists_pen={
			[DamageType.NATURE] = resolvers.mbonus_material(8, 2),
		},
		resists={
			[DamageType.NATURE] = resolvers.mbonus_material(8, 2),
		},
	},
}

-- Mitotic Set: Single Mindstar that splits in two
newEntity{
	power_source = {nature=true},
	name = "mitotic ", prefix=true, instant_resolve=true,
	keywords = {mitotic=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 45, -- Rarity is high because melee based mindstar use is rare and you get two items out of one drop
	cost = 40,  -- cost is very low to discourage players from splitting them to make extra gold..  because that would be tedious and unfun
	combat = {
		physcrit = resolvers.mbonus_material(10, 2),
		melee_project = { [DamageType.ITEM_ACID_CORRODE]= resolvers.mbonus_material(15, 5), [DamageType.ITEM_NATURE_SLOW]= resolvers.mbonus_material(15, 5),},
	},
	no_auto_hotkey = true,
	resolvers.charm(_t"divide the mindstar in two", 1,
		function(self, who)
			-- Check for free slot first
			if who:getFreeHands() == 0 then
				game.logPlayer(who, "You must have a free hand to divide the %s.", self:getName({no_add_name = true, do_color = true}))
				return
			end

			if self.tinker then
				game.logPlayer(who, "You cannot split your %s while it has a tinker inside.", self:getName({no_add_name = true, do_color = true}))
				return
			end

			if who:getInven("PSIONIC_FOCUS") and who:getInven("PSIONIC_FOCUS")[1] == self then
				game.logPlayer(who, "You cannot split your %s while using it as a psionic focus.", self:getName({no_add_name = true, do_color = true}))
				return
			end

			local o = self
			local o, pos, inven_id = who:findInAllInventoriesByObject(self)
			
			if o ~= self then
				game.logPlayer(who, "Your %s is too flawed to divide.", self:getName({no_add_name = true, do_color = true}))
				return
			end
			game.logPlayer(who, "You divide your %s in two, forming a linked set.", self:getName({no_add_name = true, do_color = true}))
			
			who:takeoffObject(inven_id, pos)
			-- Remove some properties before cloning
			o.cost = self.cost / 2 -- more don't split for extra gold discouragement
			o.max_power = nil
			o.power_regen = nil
			o.use_power = nil
			o.use_talent = nil
			local o2 = o:clone()

			-- Build the item set
			o.define_as = "MS_EGO_SET_MITOTIC_ACID"
			o2.define_as = "MS_EGO_SET_MITOTIC_SLIME"
			o.set_list = { {"define_as", "MS_EGO_SET_MITOTIC_SLIME"} }
			o2.set_list = { {"define_as", "MS_EGO_SET_MITOTIC_ACID"} }
			o.set_desc = {
				mitotic = _t"This mindstar would symbiotize with another like it.",
			}
			o2.set_desc = {
				mitotic = _t"This mindstar would symbiotize with another like it.",
			}

			o.on_set_complete = function(self, who)
				self:specialWearAdd({"combat","burst_on_crit"}, { [engine.DamageType.ACID_BLIND] = 10 * self.material_level } )
				game.logPlayer(who, "#GREEN#The mindstars pulse with life.")
			end
			o.on_set_broken = function(self, who)
				game.logPlayer(who, "#SLATE#The link between the mindstars is broken.")
			end

			o2.on_set_complete = function(self, who)
				self:specialWearAdd({"combat","burst_on_crit"}, { [engine.DamageType.INSIDIOUS_POISON] = 10 * self.material_level } )
			end

			-- Wearing the second mindstar will complete the set and thus update the first mindstar
			o2.wielded = nil
			who:wearObject(o, true, false, inven_id)
			who:wearObject(o2, true, true)

			-- Because we're removing the use_power we're not returning that it was used; instead we'll have the actor use energy manually
			who:useEnergy()
		end,
		"T_GLOBAL_CD",
		{no_npc_use = true}
	),
}

newEntity{
	power_source = {nature=true},
	name = "wyrm's ", prefix=true, instant_resolve=true,
	keywords = {wyrms=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 40,
	wielder = {
		melee_project={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
			[DamageType.COLD] = resolvers.mbonus_material(8, 2),
			[DamageType.FIRE] = resolvers.mbonus_material(8, 2),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(8, 2),
			[DamageType.ACID] = resolvers.mbonus_material(8, 2),
		},
		resists={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
			[DamageType.COLD] = resolvers.mbonus_material(8, 2),
			[DamageType.FIRE] = resolvers.mbonus_material(8, 2),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(8, 2),
			[DamageType.ACID] = resolvers.mbonus_material(8, 2),
		},
	},
}

-- Suffix
-------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = " of flames", suffix=true, instant_resolve=true,
	keywords = {flames=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		melee_project={
			[DamageType.FIRE] = resolvers.mbonus_material(16, 4),
		},
		inc_damage={
			[DamageType.FIRE] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.FIRE] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.FIRE] = resolvers.mbonus_material(16, 4),
		},
		global_speed_add = resolvers.mbonus_material(8, 2, function(e, v) v=v/100 return 0, v end),
	},
}

newEntity{
	power_source = {nature=true},
	name = " of frost", suffix=true, instant_resolve=true,
	keywords = {frost=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		combat_armor = resolvers.mbonus_material(15, 5),
		melee_project={
			[DamageType.COLD] = resolvers.mbonus_material(16, 4),
		},
		inc_damage={
			[DamageType.COLD] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.COLD] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.COLD] = resolvers.mbonus_material(16, 4),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = " of gales", suffix=true, instant_resolve=true,
	keywords = {gales=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		combat_def = resolvers.mbonus_material(30,6),
		inc_damage={
			[DamageType.COLD] = resolvers.mbonus_material(12, 4),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(12, 4),
			[DamageType.LIGHTNING] = resolvers.mbonus_material(12, 4),
		},
		pin_immune = resolvers.mbonus_material(25, 15, function(e, v) v=v/100 return 0, v end),
	},
}

newEntity{
	power_source = {nature=true},
	name = " of sand", suffix=true, instant_resolve=true,
	keywords = {sand=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		melee_project={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(16, 4),
		},
		inc_damage={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(16, 4),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = " of storms", suffix=true, instant_resolve=true,
	keywords = {storms=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		melee_project={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(16, 4),
		},
		inc_damage={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(16, 4),
		},
		inc_stats = {
			[Stats.STAT_STR] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_DEX] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_MAG] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_WIL] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_CUN] = resolvers.mbonus_material(6, 1),
			[Stats.STAT_CON] = resolvers.mbonus_material(6, 1),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = " of venom", suffix=true, instant_resolve=true,
	keywords = {venom=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		melee_project={
			[DamageType.ACID] = resolvers.mbonus_material(16, 4),
		},
		inc_damage={
			[DamageType.ACID] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.ACID] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.ACID] = resolvers.mbonus_material(16, 4),
		},
		life_regen = resolvers.mbonus_material(4,1),
	},
}

-------------------------------------------------------
--Antimagic -------------------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {antimagic=true},
	name = "manaburning ", prefix=true, instant_resolve=true,
	keywords = {manaburning=true},
	level_range = {20, 50},
	rarity = 20,
	cost = 40,
	combat = {
		melee_project = {
			[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.mbonus_material(15, 10),
		},
	},
	wielder = {
		resists={
			[DamageType.ARCANE] = resolvers.mbonus_material(8, 2),
		},
	},
}

-------------------------------------------------------
--Greater antimagic -----------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {antimagic=true},
	name = "inquisitor's ", prefix=true, instant_resolve=true,
	keywords = {inquisitors=true},
	level_range = {30, 50},
	rarity = 45,
	greater_ego = 1,
	unique_ego = 1,
	cost = 40,
	combat = {
		special_on_crit = {
			desc=function(self, who, special)
				local manaburn = special.manaburn(who)
				return ("Deals #YELLOW#%d#LAST# Manaburn damage and puts 1 random spell talent on cooldown for #YELLOW#%d#LAST# turns (checks Confusion immunity)"):
					tformat(manaburn or 0, 1 + math.ceil(who:combatMindpower() / 20))
			end,
			manaburn=function(who)
				local dam = math.max(10, math.floor(who:combatStatScale(who:combatMindpower(), 1, 150)))
				return dam
			end,
			fct=function(combat, who, target, dam, special)
				local manaburn = special.manaburn(who)
				local tg = {type="hit", range=1}
				who:project(tg, target.x, target.y, engine.DamageType.MANABURN, manaburn)

				local turns = 1 + math.ceil(who:combatMindpower() / 20)
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				if not who:checkHit(check, target:combatMentalResist()) or not target:canBe("confusion") then return end

				local tids = {}
				for tid, lev in pairs(target.talents) do
					local t = target:getTalentFromId(tid)
					if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate and t.is_spell then tids[#tids+1] = t end
				end

				local t = rng.tableRemove(tids)
				if not t then return end
				
				target.talents_cd[t.id] = turns
				game.logSeen(target, "#YELLOW#%s has their %s spell disrupted for for %d turns!", target:getName():capitalize(), t.name, turns)
			end
		},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "protector's ", prefix=true, instant_resolve=true,
	keywords = {protectors=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 45,
	cost = 40,
	wielder = {
		talents_types_mastery = {
			["wild-gift/antimagic"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
		resists={
			all = resolvers.mbonus_material(8, 2),
		},
	},
}

-- Suffix
-------------------------------------------------------
newEntity{
	power_source = {antimagic=true},
	name = " of disruption", suffix=true, instant_resolve=true,
	keywords = {disruption=true},
	level_range = {30, 50},
	greater_ego = 1,
	unique_ego = 1,
	rarity = 50,
	cost = 40,
	combat = {
		inc_damage_type = {
			unnatural=resolvers.mbonus_material(25, 5),
		},
		special_on_hit = {
			desc=function(self, who, special)
				return ("Cause the target to have a 10%% chance to fail spellcasting and 10%% chance to lose a magical sustain each turn, stacking up to 50%%"):tformat()
			end,
			fct=function(combat, who, target, dam, special)
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				target:setEffect(target.EFF_SPELL_DISRUPTION, 5, {src=who, power = 10, max = 50, apply_power=check})
			end
		},
	},
}
-------------------------------------------------------
--Psionic----------------------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = "creative ", prefix=true, instant_resolve=true,
	keywords = {creative=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		inc_stats = {
			[Stats.STAT_CUN] = resolvers.mbonus_material(6, 2),
		},
		combat_critical_power = resolvers.mbonus_material(20, 5),
	},
}

newEntity{
	power_source = {psionic=true},
	name = "horrifying ", prefix=true, instant_resolve=true,
	keywords = {horrifying=true},
	level_range = {1, 50},
	rarity = 4,
	cost = 8,
	wielder = {
		melee_project={
			[DamageType.MIND] = resolvers.mbonus_material(12, 3),
			[DamageType.DARKNESS] = resolvers.mbonus_material(12, 3),
		},
		inc_damage={
			[DamageType.MIND] = resolvers.mbonus_material(8, 2),
			[DamageType.DARKNESS] = resolvers.mbonus_material(8, 2),
		},
	},
}

-- Suffix
-------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = " of clarity", suffix=true, instant_resolve=true,
	keywords = {clarity=true},
	level_range = {1, 50},
	rarity = 8,
	cost = 8,
	wielder = {
		combat_mentalresist = resolvers.mbonus_material(8, 2),
		max_psi = resolvers.mbonus_material(40, 10),
	},
}

newEntity{
	power_source = {psionic=true},
	name = " of resolve", suffix=true, instant_resolve=true,
	keywords = {resolve=true},
	level_range = {1, 50},
	rarity = 8,
	cost = 8,
	wielder = {
		inc_stats = {
			[Stats.STAT_WIL] = resolvers.mbonus_material(6, 2),
		},
		combat_spellresist = resolvers.mbonus_material(8, 2),
	},
}

-------------------------------------------------------
--Greater psionic--------------------------------------
-------------------------------------------------------
-- Prefix
-------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = "absorbing ", prefix=true, instant_resolve=true,
	keywords = {absorbing=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		resists = { 
			[DamageType.FIRE] = resolvers.mbonus_material(20, 5), 
			[DamageType.COLD] = resolvers.mbonus_material(20, 5), 
			[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 5), 
		},
		talents_types_mastery = {
			["psionic/voracity"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
			["psionic/absorption"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
	},
}

newEntity{
	power_source = {psionic=true},
	name = "dreamer's ", prefix=true, instant_resolve=true,
	keywords = {dreamers=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		combat_mentalresist = resolvers.mbonus_material(8, 2),
		psi_regen = resolvers.mbonus_material(12, 3, function(e, v) v=v/10 return 0, v end),
		max_psi = resolvers.mbonus_material(40, 10),
		resists = { [DamageType.MIND] = resolvers.mbonus_material(20, 5), }
	},
}

newEntity{
	power_source = {psionic=true},
	name = "epiphanous ", prefix=true, instant_resolve=true,
	keywords = {epiphanous=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		combat_mindpower = resolvers.mbonus_material(5, 1),
		combat_mindcrit = resolvers.mbonus_material(5, 1),
		inc_damage = { [DamageType.MIND] = resolvers.mbonus_material(20, 5), },
		psi_on_crit = resolvers.mbonus_material(4, 1),
	},
}

newEntity{
	power_source = {psionic=true},
	name = "hateful ", prefix=true, instant_resolve=true,
	keywords = {hateful=true},
	level_range = {30, 50},
	greater_ego =1,
	rarity = 35,
	cost = 35,
	wielder = {
		inc_damage={
			[DamageType.MIND] = resolvers.mbonus_material(20, 5),
			[DamageType.DARKNESS] = resolvers.mbonus_material(20, 5),
		},
		resists_pen={
			[DamageType.MIND] = resolvers.mbonus_material(10, 5),
			[DamageType.DARKNESS] = resolvers.mbonus_material(10, 5),
		},
		inc_damage_type = {humanoid=resolvers.mbonus_material(20, 5)},
		max_hate = resolvers.mbonus_material(8,2),
	},
}

newEntity{
	power_source = {psionic=true},
	name = "honing ", prefix=true, instant_resolve=true,
	keywords = {honing=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 40,
	wielder = {
		inc_damage={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
		},
		resists_pen={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
		},
		resists={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(8, 2),
		},
		inc_stats = {
			[Stats.STAT_CUN] = resolvers.mbonus_material(3, 1),
			[Stats.STAT_WIL] = resolvers.mbonus_material(3, 1),
		},
	},
}

newEntity{
	power_source = {psionic=true},
	name = "hungering ", prefix=true, instant_resolve=true,
	keywords = {hungering=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		talents_types_mastery = {
			["psionic/voracity"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
			["cursed/dark-sustenance"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
		hate_per_kill = resolvers.mbonus_material(4, 1),
		psi_per_kill = resolvers.mbonus_material(4, 1),
	},

	charm_power = resolvers.mbonus_material(80, 20),
	charm_power_def = {add=5, max=10, floor=true},
	resolvers.charm(function(self, who) 
		return ("inflict %0.2f mind damage (range 10), gaining psi and hate equal to 10%%%% of the damage done"):tformat(who:damDesc(engine.DamageType.MIND, self.use_power.damage(self, who)))
		end,
		20,
		function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y, target = who:getTarget(tg)
			if not x or not y then return nil end
			if target then
				game.logSeen(who, "%s feeds %s %s with psychic energy from %s!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}), target:getName():capitalize())
				if target:checkHit(who:combatMindpower(), target:combatMentalResist(), 0, 95, 5) then
					local damage = self.use_power.damage(self, who)
					who:project(tg, x, y, engine.DamageType.MIND, {dam=damage, alwaysHit=true}, {type="mind"})
					who:incPsi(damage/10)
					who:incHate(damage/10)
				else
					game.logSeen(target, "%s resists the mind attack!", target:getName():capitalize())
				end
			end
			return {id=true, used=true}
		end,
		"T_GLOBAL_CD",
		{range = 10,
		target = function(self, who) return {type="hit", range=self.use_power.range} end,
		tactical = {ATTACK = {MIND = 2}, HATE = 1, PSI = 1},
		requires_target = true,
		damage = function(self, who) return self:getCharmPower(who) + (who:combatMindpower() * (1 + self.material_level/5)) end}
	),
}

newEntity{
	power_source = {psionic=true},
	name = "projecting ", prefix=true, instant_resolve=true,
	keywords = {projecting=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 40,
	wielder = {
		inc_damage = { 
			[DamageType.FIRE] = resolvers.mbonus_material(20, 5), 
			[DamageType.COLD] = resolvers.mbonus_material(20, 5), 
			[DamageType.LIGHTNING] = resolvers.mbonus_material(20, 5), 
		},
		talents_types_mastery = {
			["psionic/projection"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
			["psionic/focus"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
	},
}

newEntity{
	power_source = {psionic=true},
	name = "resonating ", prefix=true, instant_resolve=true,
	keywords = {resonating=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 40,
	wielder = {
		damage_resonance = resolvers.mbonus_material(20, 5),
		psi_regen_when_hit = resolvers.mbonus_material(20, 5, function(e, v) v=v/10 return 0, v end),
		inc_damage={
			[DamageType.MIND] = resolvers.mbonus_material(8, 2),
		},
		resists_pen={
			[DamageType.MIND] = resolvers.mbonus_material(8, 2),
		},
		resists={
			[DamageType.MIND] = resolvers.mbonus_material(8, 2),
		},
	},
}

newEntity{
	power_source = {psionic=true},
	name = "wrathful ", prefix=true, instant_resolve=true,
	keywords = {wrath=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	wielder = {
		psi_on_crit = resolvers.mbonus_material(5, 1),
		hate_on_crit = resolvers.mbonus_material(5, 1),
		combat_mindcrit = resolvers.mbonus_material(10, 2),
	},
}

-- Suffix
-------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = " of nightfall", suffix=true, instant_resolve=true,
	keywords = {nightfall=true},
	level_range = {30, 50},
	rarity = 30,
	cost = 40,
	wielder = {
		inc_damage={
			[DamageType.DARKNESS] = resolvers.mbonus_material(16, 4),
		},
		resists_pen={
			[DamageType.DARKNESS] = resolvers.mbonus_material(16, 4),
		},
		resists={
			[DamageType.DARKNESS] = resolvers.mbonus_material(16, 4),
		},
		blind_immune = resolvers.mbonus_material(15, 10, function(e, v) v=v/100 return 0, v end),
		talents_types_mastery = {
			["cursed/darkness"] = resolvers.mbonus_material(1, 1, function(e, v) v=v/10 return 0, v end),
		},
	},
}
