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

-- modify the power and cooldown of charm powers
-- This makes adjustments after zone:finishEntity is finished, which handles any egos added via e.addons
local function modify_charm(e, e, zone, level)
	for i, c_mod in ipairs(e.charm_power_mods) do
		c_mod(e, e, zone, level)
	end
	if e._old_finish and e._old_finish ~= e._modify_charm then return e._old_finish(e, e, zone, level) end
end

-- There are two copies of each of these egos with the same unique_ego identifier as a hack to essentially remove the lesser/greater ego distinction and keep the fairly small pool 
-- diverse.  This is really hacky but there is no good way in the engine to do it that I know of.

newEntity{
	name = "quick ", prefix=true,
	keywords = {quick=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_quick",
	rarity = 15,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying quick ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(0.6, 0.8))
				e.charm_power = math.ceil(e.charm_power * rng.float(0.6, 0.9))
			else
				print("\tquick ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "quick ", prefix=true,
	keywords = {quick=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_quick",
	greater_ego = 1,
	rarity = 15,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying quick ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(0.6, 0.8))
				e.charm_power = math.ceil(e.charm_power * rng.float(0.6, 0.9))
			else
				print("\tquick ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "supercharged ", prefix=true,
	keywords = {['supercharged']=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_supercharged",
	rarity = 15,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying supercharged ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(1.1, 1.3))
				e.charm_power = math.ceil(e.charm_power * rng.float(1.3, 1.5))
			else
				print("\tsupercharged ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "supercharged ", prefix=true,
	keywords = {['supercharged']=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_supercharged",
	greater_ego = 1,
	rarity = 15,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying supercharged ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(1.1, 1.3))
				e.charm_power = math.ceil(e.charm_power * rng.float(1.3, 1.5))
			else
				print("\tsupercharged ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "overpowered ", prefix=true,
	keywords = {['overpower']=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_overpowered",
	rarity = 16,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying overpowered ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(1.2, 1.5))
				e.charm_power = math.ceil(e.charm_power * rng.float(1.6, 1.9))
			else
				print("\toverpowered ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "overpowered ", prefix=true,
	keywords = {['overpower']=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_overpowered",
	greater_ego = 1,
	rarity = 16,
	cost = 5,
	_modify_charm = modify_charm,
	resolvers.genericlast(function(e)
		if e.finish ~= e._modify_charm then e._old_finish = e.finish end
		e.finish = e._modify_charm
		e.charm_power_mods = e.charm_power_mods or {}
		table.insert(e.charm_power_mods, function(e, e, zone, level)
			if e.charm_power and e.use_power and e.use_power.power then
				print("\t Applying overpowered ego changes.")
				e.use_power.power = math.ceil(e.use_power.power * rng.float(1.2, 1.5))
				e.charm_power = math.ceil(e.charm_power * rng.float(1.6, 1.9))
			else
				print("\toverpowered ego changes aborted.")
			end
		end)
	end),
}

newEntity{
	name = "focusing ", prefix=true,
	keywords = {focusing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_focusing",
	rarity = 12,
	cost = 5,
	focusing_amt = resolvers.mbonus_material(2, 1),
	charm_on_use = {
		{100, function(self, who) return ("reduce %d talent cooldowns by 2"):tformat(self.focusing_amt, self.focusing_reduction) end, function(self, who)
			who:talentCooldownFilter(nil, self.focusing_amt, 2, true)
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "focusing ", prefix=true,
	keywords = {focusing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_focusing",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	focusing_amt = resolvers.mbonus_material(2, 1),
	charm_on_use = {
		{100, function(self, who) return ("reduce %d talent cooldowns by 2"):tformat(self.focusing_amt, self.focusing_reduction) end, function(self, who)
			who:talentCooldownFilter(nil, self.focusing_amt, 2, true)
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}


newEntity{
	name = "extending ", prefix=true,
	keywords = {extending=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_extending",
	rarity = 12,
	cost = 5,
	extending_amt = resolvers.mbonus_material(2, 1),
	extending_dur = resolvers.mbonus_material(1.5, 1),

	charm_on_use = {
		{100, function(self, who) return ("increase the duration of %d beneficial effects by %d"):tformat(self.extending_amt, self.extending_dur) end, function(self, who)
			local effs = who:effectsFilter(function(eff)
				if eff.status == "beneficial" and eff.type ~= "other" then return true end
			end)
			if #effs <= 0 then return end
			for i = 1, math.floor(self.extending_amt) do
				local eff = rng.tableRemove(effs)
				if eff and eff.dur then
					eff.dur = eff.dur + math.floor(self.extending_amt)
				end
			end
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "extending ", prefix=true,
	keywords = {extending=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_extending",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	extending_amt = resolvers.mbonus_material(2, 1),
	extending_dur = resolvers.mbonus_material(1.5, 1),

	charm_on_use = {
		{100, function(self, who) return ("increase the duration of %d beneficial effects by %d"):tformat(self.extending_amt, self.extending_dur) end, function(self, who)
			local effs = who:effectsFilter(function(eff)
				if eff.status == "beneficial" and eff.type ~= "other" then return true end
			end)
			if #effs <= 0 then return end
			for i = 1, math.floor(self.extending_amt) do
				local eff = rng.tableRemove(effs)
				if eff and eff.dur then
					eff.dur = eff.dur + math.floor(self.extending_amt)
				end
			end
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}


newEntity{
	name = "evasive ", prefix=true,
	keywords = {evasive=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_evasive",
	rarity = 12,
	cost = 5,
	evasive_chance = resolvers.mbonus_material(30, 10),
	charm_on_use = {
		{100, function(self, who) return ("gain a %d%% chance to evade weapon attacks for 2 turns"):tformat(self.evasive_chance) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_EVASIVE, 2, {chance = self.evasive_chance})
		end},
	},
	use_power = {tactical = {DEFEND = 0.2}}
}

newEntity{
	name = "evasive ", prefix=true,
	keywords = {evasive=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_evasive",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	evasive_chance = resolvers.mbonus_material(30, 10),
	charm_on_use = {
		{100, function(self, who) return ("gain a %d%% chance to evade weapon attacks for 2 turns"):tformat(self.evasive_chance) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_EVASIVE, 2, {chance = self.evasive_chance})
		end},
	},
	use_power = {tactical = {DEFEND = 0.2}}
}

newEntity{
	name = "soothing ", prefix=true,
	keywords = {soothing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_soothing",
	rarity = 12,
	cost = 5,
	soothing_heal = resolvers.mbonus_material(80, 30),
	charm_on_use = {
		{100, function(self, who) return ("heal for %d"):tformat(self.soothing_heal) end, function(self, who)
			who:attr("allow_on_heal", 1)
			who:heal(who:mindCrit(self.soothing_heal), who)
			who:attr("allow_on_heal", -1)		
		end},
	},
	use_power = {tactical = {HEAL = 0.2}}
}

newEntity{
	name = "soothing ", prefix=true,
	keywords = {soothing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_soothing",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	soothing_heal = resolvers.mbonus_material(80, 30),
	charm_on_use = {
		{100, function(self, who) return ("heal for %d"):tformat(self.soothing_heal) end, function(self, who)
			who:attr("allow_on_heal", 1)
			who:heal(who:mindCrit(self.soothing_heal), who)
			who:attr("allow_on_heal", -1)		
		end},
	},
	use_power = {tactical = {HEAL = 0.2}}
}

newEntity{
	name = "cleansing ", prefix=true,
	keywords = {cleansing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_cleansing",
	rarity = 12,
	cost = 5,
	cleansing_amount = resolvers.mbonus_material(2, 1),
	charm_on_use = {
		{100, function(self, who) return ("cleanse %d total effects of type disease, wound, or poison"):tformat(self.cleansing_amount) end, function(self, who)
			who:removeEffectsFilter(function(e) return e.subtype.poison or e.subtype.wound or e.subtype.disease end, self.cleansing_amount)	
		end},
	},
	use_power = {tactical = {CURE = 0.2}}
}

newEntity{
	name = "cleansing ", prefix=true,
	keywords = {cleansing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_cleansing",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	cleansing_amount = resolvers.mbonus_material(2, 1),
	charm_on_use = {
		{100, function(self, who) return ("cleanse %d total effects of type disease, wound, or poison"):tformat(self.cleansing_amount) end, function(self, who)
			who:removeEffectsFilter(function(e) return e.subtype.poison or e.subtype.wound or e.subtype.disease end, self.cleansing_amount)	
		end},
	},
	use_power = {tactical = {CURE = 0.2}}
}

newEntity{
	name = "piercing ", prefix=true,
	keywords = {piercing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_piercing",
	rarity = 12,
	cost = 5,
	piercing_penetration = resolvers.mbonus_material(20, 10),
	charm_on_use = {
		{100, function(self, who) return ("increase all damage penetration by %d%% for 2 turns"):tformat(self.piercing_penetration) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_PIERCING, 2, {penetration = self.piercing_penetration})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "piercing ", prefix=true,
	keywords = {piercing=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_piercing",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	piercing_penetration = resolvers.mbonus_material(20, 10),
	charm_on_use = {
		{100, function(self, who) return ("increase all damage penetration by %d%% for 2 turns"):tformat(self.piercing_penetration) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_PIERCING, 2, {penetration = self.piercing_penetration})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "powerful ", prefix=true,
	keywords = {powerful=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_powerful",
	rarity = 12,
	cost = 5,
	powerful_damage = resolvers.mbonus_material(20, 10),
	charm_on_use = {
		{100, function(self, who) return ("increase all damage by %d%% for 2 turns"):tformat(self.powerful_damage) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_POWERFUL, 2, {damage = self.powerful_damage})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "powerful ", prefix=true,
	keywords = {powerful=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_powerful",
	greater_ego = 1,
	rarity = 12,
	cost = 5,
	powerful_damage = resolvers.mbonus_material(20, 10),
	charm_on_use = {
		{100, function(self, who) return ("increase all damage by %d%% for 2 turns"):tformat(self.powerful_damage) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_POWERFUL, 2, {damage = self.powerful_damage})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}

newEntity{
	name = "innervating ", prefix=true,
	keywords = {innervating=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_innervating",
	rarity = 18,
	cost = 5,
	innervating_fatigue = resolvers.mbonus_material(40, 20),
	charm_on_use = {
		{100, function(self, who) return ("reduce fatigue by %d%% for 2 turns"):tformat(self.innervating_fatigue) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_INNERVATING, 2, {fatigue = self.innervating_fatigue})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}


newEntity{
	name = "innervating ", prefix=true,
	keywords = {innervating=true},
	level_range = {1, 50},
	unique_ego = "charm_proc_innervating",
	greater_ego = 1,
	rarity = 18,
	cost = 5,
	innervating_fatigue = resolvers.mbonus_material(40, 20),
	charm_on_use = {
		{100, function(self, who) return ("reduce fatigue by %d%% for 2 turns"):tformat(self.innervating_fatigue) end, function(self, who)
			who:setEffect(who.EFF_ITEM_CHARM_INNERVATING, 2, {fatigue = self.innervating_fatigue})
		end},
	},
	use_power = {tactical = {BUFF = 0.2}}
}