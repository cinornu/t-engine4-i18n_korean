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

newEntity{
	define_as = "BASE_SCROLL",
	type = "scroll", subtype="scroll",
	unided_name = _t"scroll", id_by_type = true,
	display = "?", color=colors.WHITE, image="object/scroll.png",
	encumber = 0.1,
	stacking = true,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = _t[[Magical scrolls can have wildly different effects!]],
	egos = "/data/general/objects/egos/scrolls.lua", egos_chance = resolvers.mbonus(10, 5),
}

newEntity{
	define_as = "BASE_INFUSION",
	type = "scroll", subtype="infusion", add_name = " (#INSCRIPTION#)",
	unided_name = _t"infusion", id_by_type = true,
	display = "?", color=colors.LIGHT_GREEN, image="object/rune_green.png",
	encumber = 0.1,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	fire_destroy = {{100,1}, {200,2}, {400,5}, {600,10}, {1200,20}},
	desc = _t[[Natural infusions may be grafted onto your body, granting you an on-demand nature talent.]],
	egos = "/data/general/objects/egos/infusions.lua", egos_chance = resolvers.mbonus(30, 5),
	material_level_min_only = true,

	power_source = {nature=true},
	use_simple = { name=_t"inscribe your skin with the infusion", use = function(self, who, inven, item)
		if who:setInscription(nil, self.inscription_talent, self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return {used=true, id=true, destroy=true}
		end
	end}
}

newEntity{
	define_as = "BASE_RUNE",
	type = "scroll", subtype="rune", add_name = " (#INSCRIPTION#)",
	unided_name = _t"rune", id_by_type = true,
	display = "?", color=colors.LIGHT_BLUE, image="object/rune_red.png",
	encumber = 0.1,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = _t[[Magical runes may be inscribed onto your body, granting you an on-demand spell talent.]],
	egos = "/data/general/objects/egos/infusions.lua", egos_chance = resolvers.mbonus(30, 5),
	material_level_min_only = true,

	power_source = {arcane=true},
	use_simple = { name=_t"inscribe your skin with the rune", use = function(self, who, inven, item)
		if who:setInscription(nil, self.inscription_talent, self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return {used=true, id=true, destroy=true}
		end
	end}
}

newEntity{
	define_as = "BASE_TAINT",
	type = "scroll", subtype="taint", add_name = " (#INSCRIPTION#)",
	unided_name = _t"taint", id_by_type = true,
	display = "?", color=colors.LIGHT_BLUE, image="object/rune_yellow.png",
	encumber = 0.1,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = _t[[Corrupted taints may be inscribed onto your body, granting you an on-demand ability.]],
	egos = "/data/general/objects/egos/infusions.lua", egos_chance = resolvers.mbonus(30, 5),

	power_source = {arcane=true},
	use_simple = { name=_t"inscribe your skin with the taint", use = function(self, who, inven, item)
		if who:setInscription(nil, self.inscription_talent, self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return {used=true, id=true, destroy=true}
		end
	end}
}

newEntity{
	define_as = "BASE_LORE",
	type = "lore", subtype="lore", not_in_stores=true, no_unique_lore=true,
	unided_name = _t"scroll", identified=true,
	display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll-lore.png",
	encumber = 0,
	checkFilter = function(self) if self.lore and game.party.lore_known and game.party.lore_known[self.lore] then print('[LORE] refusing', self.lore) return false else return true end end,
	desc = _t[[This parchment contains some lore.]],
	use_simple = { name=_t"read it", use = function(self, who, inven, item)
		game.party:learnLore(self.lore)
		return {used=true, id=true, destroy=true}
	end}
}

newEntity{
	define_as = "BASE_LORE_RANDOM",
	type = "lore", subtype="lore", not_in_stores=true, no_unique_lore=true,
	unided_name = _t"scroll", identified=true,
	display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll.png",
	encumber = 0,
	checkFilter = function(self) if self.lore and game.party.lore_known and game.party.lore_known[self.lore] then print('[LORE] refusing', self.lore) return false else return true end end,
	desc = _t[[This parchment contains some lore.]],
	use_simple = { name=_t"read it", use = function(self, who, inven, item)
		game.party:learnLore(self.lore)
		return {used=true, id=true, destroy=true}
	end}
}

-----------------------------------------------------------
-- Infusions - 5 types
-----------------------------------------------------------
-- Pros:  Instant cast, clears 3 average/lesser debuff types, which makes other cleanses also more consistent
-- Cons:  Significantly less healing outputper cast than Regeneration
newEntity{ base = "BASE_INFUSION",
	name = "healing infusion",
	level_range = {1, 50},
	rarity = 15,
	cost = 10,

	inscription_kind = "heal",
	inscription_data = {
		cooldown = resolvers.rngrange(10, 15),
		heal = resolvers.mbonus_level(80, 40, function(e, v) return v * 0.06 end),
		use_stat_mod = 2,
	},
	inscription_talent = "INFUSION:_HEALING",
}

newEntity{ base = "BASE_INFUSION",
	name = "regeneration infusion",
	level_range = {1, 50},
	rarity = 15,
	cost = 10,

	inscription_kind = "heal",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 17),
		dur = 5,
		heal = resolvers.mbonus_level(550, 60, function(e, v) return v * 0.06 end),
		use_stat_mod = 3.4,
	},
	inscription_talent = "INFUSION:_REGENERATION",
}

-- colorme
newEntity{ base = "BASE_INFUSION",
	name = "wild infusion",
	level_range = {1, 50},
	rarity = 15,
	cost = 20,
	chance = resolvers.mbonus_level(110, -10), -- No chance of 2 cleanses until higher ilvl to discourage rerolling the earliest shops
	inscription_kind = "utility",
	inscription_data = resolvers.generic(function(e)
		local what = {}
		local effects = {physical=true, mental=true, magical=true}
		local eff1 = rng.tableIndex(effects)
		what[eff1] = true
		local two = rng.percent(e.chance) and true or false
		if two then
			local eff2 = rng.tableIndex(effects, {eff1})
			what[eff2] = true
		end
		return {
			cooldown = rng.range(10, 16),
			dur = rng.range(2, 4),
			power = resolvers.mbonus_level(10, 15),  -- Low variance because duration and chance for second debuff type is enough randomness
			use_stat_mod = 0.2,  -- +20% resist all at 100 stat
			what=what,
		}
	end),
	inscription_talent = "INFUSION:_WILD",
}

newEntity{ base = "BASE_INFUSION",
	name = "movement infusion",
	level_range = {1, 50},
	rarity = 20,
	cost = 30,

	inscription_kind = "movement",
	inscription_data = {
		cooldown = resolvers.rngrange(8, 18),  -- High variance because this is the only really important stat
		speed = resolvers.mbonus_level(500, 400, function(e, v) return v * 0.001 end),
		use_stat_mod = 3,
	},
	inscription_talent = "INFUSION:_MOVEMENT",
}

newEntity{ base = "BASE_INFUSION",
	name = "heroism infusion",
	level_range = {20, 50},
	rarity = 30,
	cost = 40,

	inscription_kind = "utility",
	inscription_data = {
		cooldown = resolvers.rngrange(25, 35),
		dur = resolvers.mbonus_level(5, 5),
		die_at = resolvers.mbonus_level(600, 100, function(e, v) return v * 0.2 end),
		use_stat_mod = 0.14, -- 30x for die_at
	},
	inscription_talent = "INFUSION:_HEROISM",
}

-----------------------------------------------------------
-- Runes - 9 types
-----------------------------------------------------------
newEntity{ base = "BASE_RUNE",
	name = "teleportation rune",
	level_range = {1, 50},
	rarity = 50, -- Very rare because item quality has little impact on this
	cost = 10,

	inscription_kind = "teleport",
	inscription_data = {
		cooldown = resolvers.rngrange(10, 20),  -- High variance because this is the only really important stat
		range = resolvers.mbonus_level(100, 20, function(e, v) return v * 0.03 end),
		use_stat_mod = 1,
	},
	inscription_talent = "RUNE:_TELEPORTATION",
}

newEntity{ base = "BASE_RUNE",
	name = "shielding rune",
	level_range = {1, 50},
	rarity = 15,
	cost = 20,

	inscription_kind = "protect",
	inscription_data = {
		cooldown = resolvers.rngrange(14, 18),
		dur = resolvers.mbonus_level(5, 3),
		power = resolvers.mbonus_level(500, 50, function(e, v) return v * 0.06 end),
		use_stat_mod = 3,
	},
	inscription_talent = "RUNE:_SHIELDING",
}

newEntity{ base = "BASE_RUNE",
	name = "biting gale rune",
	level_range = {10, 50},
	rarity = 35,
	cost = 20,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(15, 23),
		power = resolvers.mbonus_level(200, 30, function(e, v) return v * 0.1 end),
		dur = 4,
		use_stat_mod = 2.2,
	},
	inscription_talent = "RUNE:_BITING_GALE",
}

newEntity{ base = "BASE_RUNE",
	name = "acid wave rune",
	level_range = {10, 50},
	rarity = 35,
	cost = 20,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(15, 23),
		power = resolvers.mbonus_level(200, 30, function(e, v) return v * 0.1 end),
		use_stat_mod = 2.2,
		dur = 4,
	},
	inscription_talent = "RUNE:_ACID_WAVE",
}

newEntity{ base = "BASE_RUNE",
	name = "manasurge rune",
	level_range = {1, 50},
	rarity = 50,  -- Very rare because only a limited number of classes have any use for this
	cost = 10,

	inscription_kind = "utility",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 18),
		dur = 10,
		mana = resolvers.mbonus_level(1200, 600, function(e, v) return v * 0.003 end),
		use_stat_mod = 6,
	},
	inscription_talent = "RUNE:_MANASURGE",
}

newEntity{ base = "BASE_RUNE",
	name = "blink rune",
	level_range = {1, 50},
	rarity = 15,
	cost = 20,
	material_level = 1,
	inscription_kind = "movement",
	inscription_data = {
		cooldown = resolvers.rngrange(10, 20),
		range = resolvers.mbonus_level(5, 3, function(e, v) return v * 0.06 end),
		power = resolvers.mbonus_level(20, 10, function(e, v) return v * 1 end),
		use_stat_mod = 0.04, -- +4 range at 100 stat
	},
	inscription_talent = "RUNE:_BLINK",
}

newEntity{ base = "BASE_RUNE",
	name = "stormshield rune",
	level_range = {30, 50},
	rarity = 35,
	cost = 20,
	inscription_kind = "protect",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 17),
		dur = 4,
		threshold = resolvers.mbonus_level(100, 0), -- Not strictly good or bad so we use a high variance
		blocks = resolvers.mbonus_level(5, 1, function(e, v) return v * 0.06 end),
		use_stat_mod = 0.03, -- +3 blocks at 100 stat
	},
	inscription_talent = "RUNE:_STORMSHIELD",
}

newEntity{ base = "BASE_RUNE",
	name = "shatter afflictions rune",
	level_range = {1, 50},
	rarity = 15,
	cost = 10,
	inscription_kind = "utility",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 22),
		shield = resolvers.mbonus_level(120, 20, function(e, v) return v * 0.06 end),
		use_stat_mod = 1 -- 1x, applied up to 3 times
	},
	inscription_talent = "RUNE:_SHATTER_AFFLICTIONS",
}

newEntity{ base = "BASE_RUNE",
	name = "ethereal rune",
	level_range = {20, 50},
	rarity = 25,
	cost = 20,
	inscription_kind = "protect",
	inscription_data = {
		cooldown = resolvers.rngrange(16, 22),
		dur = 5,
		power = resolvers.mbonus_level(20, 7, function(e, v) return v * 1 end),
		resist = resolvers.mbonus_level(30, 10),
		move = resolvers.mbonus_level(40, 30),
		reduction = 0.5,
		use_stat_mod = 0.08, -- 1x for movement, 2x for resist, 2x for power
	},
	inscription_talent = "RUNE:_ETHEREAL",
}

-----------------------------------------------------------
-- Taints
-----------------------------------------------------------
--[[
newEntity{ base = "BASE_TAINT",
	name = "taint of the devourer",
	level_range = {1, 50},
	rarity = 15,
	cost = 10,
	material_level = 1,

	inscription_kind = "heal",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 17),
		effects = resolvers.mbonus_level(3, 2, function(e, v) return v * 0.06 end),
		heal = resolvers.mbonus_level(70, 40, function(e, v) return v * 0.06 end),
		use_stat_mod = 0.6,
	},
	inscription_talent = "TAINT:_DEVOURER",
}
]]


-----------------------------------------------------------
-- Legacy/depreciated
-----------------------------------------------------------
newEntity{ base = "BASE_RUNE",
	name = "lightning rune",
	level_range = {25, 50},
	cost = 20,
	material_level = 3,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(15, 25),
		range = resolvers.mbonus_level(5, 4),
		power = resolvers.mbonus_level(400, 50, function(e, v) return v * 0.1 end),
		use_stat_mod = 1.8,
	},
	inscription_talent = "RUNE:_LIGHTNING",
}

newEntity{ base = "BASE_RUNE",
	name = "invisibility rune",
	level_range = {18, 50},
	cost = 40,
	material_level = 3,

	inscription_kind = "utility",
	inscription_data = {
		cooldown = resolvers.rngrange(14, 24),
		dur = resolvers.mbonus_level(9, 4, function(e, v) return v * 1 end),
		power = resolvers.mbonus_level(8, 7, function(e, v) return v * 1 end),
		use_stat_mod = 0.08,
	},
	inscription_talent = "RUNE:_INVISIBILITY",
}

newEntity{ base = "BASE_RUNE",
	name = "vision rune",
	level_range = {15, 50},
	cost = 30,
	material_level = 2,

	inscription_kind = "detection",
	inscription_data = {
		cooldown = resolvers.rngrange(20, 30),
		range = resolvers.mbonus_level(10, 8),
		dur = resolvers.mbonus_level(20, 12),
		power = resolvers.mbonus_level(20, 10, function(e, v) return v * 0.3 end),
		esp = resolvers.rngtable{"humanoid","demon","dragon","horror","undead","animal"},
		use_stat_mod = 0.14,
	},
	inscription_talent = "RUNE:_VISION",
}

newEntity{ base = "BASE_RUNE",
	name = "heat beam rune",
	level_range = {25, 50},
	cost = 20,
	material_level = 2,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(12, 20),
		range = resolvers.mbonus_level(5, 4),
		power = resolvers.mbonus_level(200, 60, function(e, v) return v * 0.1 end),
		use_stat_mod = 1.8,
	},
	inscription_talent = "RUNE:_HEAT_BEAM",
}

newEntity{ base = "BASE_RUNE",
	name = "phase door rune",
	level_range = {1, 50},
	cost = 10,
	material_level = 1,

	inscription_kind = "teleport",
	inscription_data = {
		cooldown = resolvers.rngrange(8, 10),
		dur = resolvers.mbonus_level(5, 3),
		power = resolvers.mbonus_level(30, 15, function(e, v) return v * 1 end),
		range = resolvers.mbonus_level(10, 5, function(e, v) return v * 1 end),
		use_stat_mod = 0.07,
	},
	inscription_talent = "RUNE:_PHASE_DOOR",
}

newEntity{ base = "BASE_RUNE",
	name = "controlled phase door rune",
	level_range = {35, 50},
	cost = 50,
	material_level = 4,

	inscription_kind = "movement",
	inscription_data = {
		cooldown = resolvers.rngrange(10, 12),
		range = resolvers.mbonus_level(6, 5, function(e, v) return v * 3 end),
		use_stat_mod = 0.05,
	},
	inscription_talent = "RUNE:_CONTROLLED_PHASE_DOOR",
}

newEntity{ base = "BASE_INFUSION",
	name = "sun infusion",
	level_range = {1, 50},
	cost = 10,
	material_level = 1,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(9, 15),
		range = resolvers.mbonus_level(5, 5, function(e, v) return v * 0.1 end),
		turns = resolvers.rngrange(3, 5),
		power = resolvers.mbonus_level(5, 20, function(e, v) return v * 0.1 end),
		use_stat_mod = 1.2,
	},
	inscription_talent = "INFUSION:_SUN",
}

newEntity{ base = "BASE_INFUSION",
	name = "insidious poison infusion",
	level_range = {10, 50},
	cost = 20,
	material_level = 2,

	inscription_kind = "attack",
	inscription_data = {
		cooldown = resolvers.rngrange(15, 25),
		range = resolvers.mbonus_level(3, 3),
		heal_factor = resolvers.mbonus_level(50, 20, function(e, v) return v * 0.1 end),
		power = resolvers.mbonus_level(300, 70, function(e, v) return v * 0.1 end),
		use_stat_mod = 2,
	},
	inscription_talent = "INFUSION:_INSIDIOUS_POISON",
}
