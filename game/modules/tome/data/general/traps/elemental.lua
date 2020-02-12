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
local Talents = require"engine.interface.ActorTalents"

newEntity{ define_as = "TRAP_ELEMENTAL",
	type = "elemental", id_by_type=true, unided_name = _t"trap",
	display = '^',
	pressure_trap = true,
	triggered = function(self, x, y, who)
		self:project({type="hit",x=x,y=y}, x, y, self.damtype, self.dam, self.particles and {type=self.particles})
		return true
	end,
	desc = function(self)
		local dtype = engine.DamageType[self.damtype] and engine.DamageType:get(self.damtype)
		return dtype and ("Deals %s%d#LAST# %s damage"):tformat(dtype.text_color or "#WHITE#", self.dam, dtype.name)
	end,
}
newEntity{ define_as = "TRAP_ELEMENTAL_BLAST",
	type = "elemental", id_by_type=true, unided_name = _t"trap",
	display = '^',
	triggered = function(self, x, y, who)
		self:project({type="ball",x=x,y=y, radius=self.radius or 2}, x, y, self.damtype, self.dam, self.particles and {type=self.particles})
		return true
	end,
	desc = function(self)
		local dtype = engine.DamageType[self.damtype] and engine.DamageType:get(self.damtype)
		return dtype and ("Deals %s%d#LAST# %s damage (radius %d)"):tformat(dtype.text_color or "#WHITE#", self.dam, dtype.name, self.radius or 2)
	end,
}

-------------------------------------------------------
-- Bolts
-------------------------------------------------------
newEntity{ base = "TRAP_ELEMENTAL",
	subtype = "acid",
	name = "acid trap", image = "trap/blast_acid01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(6,10,4,0.5),
	rarity = 3, level_range = {1, 30},
	color_r=40, color_g=220, color_b=0,
	message = _t"A stream of acid gushes onto @target@!",
	unided_name = _t"corroded spot",
	dam = resolvers.clscale(70, 30, 15, 0.75, 0),
	damtype = DamageType.ACID,
}
newEntity{ base = "TRAP_ELEMENTAL",
	subtype = "fire",
	name = "fire trap", image = "trap/blast_fire01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(6,10,4,0.5),
	rarity = 3, level_range = {1, 30},
	color_r=220, color_g=0, color_b=0,
	message = _t"A bolt of fire blasts onto @target@!",
	unided_name = _t"burnt spot",
	dam = resolvers.clscale(90, 30, 25, 0.75, 0),
	damtype = DamageType.FIREBURN,
}
newEntity{ base = "TRAP_ELEMENTAL",
	subtype = "cold",
	name = "ice trap", image = "trap/blast_ice01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(6,10,4,0.5),
	rarity = 3, level_range = {1, 30},
	color_r=150, color_g=150, color_b=220,
	message = _t"A bolt of ice blasts onto @target@!",
	unided_name = _t"frozen spot",
	dam = resolvers.clscale(70, 30, 15, 0.75, 0),
	damtype = DamageType.ICE,
	combatSpellpower = function(self) return self.disarm_power * 2 end,
}
newEntity{ base = "TRAP_ELEMENTAL",
	subtype = "lightning",
	name = "lightning trap", image = "trap/blast_lightning01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(6,10,4,0.5),
	rarity = 3, level_range = {1, 30},
	color_r=0, color_g=0, color_b=220,
	message = _t"A bolt of lightning fires onto @target@!",
	unided_name = _t"crackling spot",
	dam = resolvers.clscale(70, 30, 15, 0.75, 0),
	damtype = DamageType.LIGHTNING,
}
newEntity{ base = "TRAP_ELEMENTAL",
	subtype = "poison",
	name = "poison trap",
	image = "trap/trap_poison_burst_01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(6,10,4,0.5),
	rarity = 3, level_range = {1, 30},
	color_r=0, color_g=220, color_b=0,
	message = _t"A stream of poison gushes onto @target@!",
	dam = resolvers.clscale(70, 30, 15, 0.75, 0),
	damtype = DamageType.POISON,
	combatAttack = function(self) return self.dam end
}

-------------------------------------------------------
-- Blasts
-------------------------------------------------------
newEntity{ base = "TRAP_ELEMENTAL_BLAST",
	subtype = "acid",
	name = "acid blast trap",
	image = "trap/trap_acid_blast_01.png",
	detect_power = resolvers.clscale(35,25,8,0.5),
	disarm_power = resolvers.clscale(35,25,8,0.5),
	rarity = 3, level_range = {20, nil},
	color_r=40, color_g=220, color_b=0,
	message = _t"A stream of acid gushes onto @target@!",
	unided_name = _t"corroded spot",
	dam = resolvers.clscale(160, 50, 40, 0.75, 60),
	damtype = DamageType.ACID, radius = 2,
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST",
	subtype = "fire",
	name = "fire blast trap", image = "trap/trap_fire_rune_01.png",
	detect_power = resolvers.clscale(35,25,8,0.5),
	disarm_power = resolvers.clscale(35,25,8,0.5),
	rarity = 3, level_range = {20, nil},
	color_r=220, color_g=0, color_b=0,
	message = _t"A bolt of fire fires onto @target@!",
	unided_name = _t"burnt spot",
	dam = resolvers.clscale(200, 50, 50, 0.75, 80),
	damtype = DamageType.FIREBURN, radius = 2,
	unlock_talent_on_disarm = {tid = Talents.T_EXPLOSION_TRAP, chance = 25},
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST",
	subtype = "cold",
	name = "ice blast trap", image = "trap/trap_frost_rune_01.png",
	detect_power = resolvers.clscale(35,25,8,0.5),
	disarm_power = resolvers.clscale(35,25,8,0.5),
	rarity = 3, level_range = {20, nil},
	color_r=150, color_g=150, color_b=220,
	message = _t"A bolt of ice blasts onto @target@!",
	unided_name = _t"frozen spot",
	dam = resolvers.clscale(160, 50, 40, 0.75, 60),
	damtype = DamageType.ICE, radius = 2,
	combatSpellpower = function(self) return self.disarm_power * 2 end,
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST",
	subtype = "lightning",
	name = "lightning blast trap", image = "trap/trap_lightning_rune_02.png",
	detect_power = resolvers.clscale(35,25,8,0.5),
	disarm_power = resolvers.clscale(35,25,8,0.5),
	rarity = 3, level_range = {20, nil},
	color_r=0, color_g=0, color_b=220,
	message = _t"A bolt of lightning fires onto @target@!",
	unided_name = _t"arcing spot",
	dam = resolvers.clscale(160, 50, 40, 0.75, 60),
	damtype = DamageType.LIGHTNING, radius = 2,
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST", image = "trap/trap_poison_blast_01.png",
	subtype = "poison",
	name = "poison blast trap",
	detect_power = resolvers.clscale(35,25,8,0.5),
	disarm_power = resolvers.clscale(35,25,8,0.5),
	rarity = 3, level_range = {20, nil},
	color_r=0, color_g=220, color_b=0,
	message = _t"A stream of poison gushes onto @target@!",
	dam = resolvers.clscale(160, 50, 40, 0.75, 60),
	damtype = DamageType.POISON, radius = 2,
	unlock_talent_on_disarm = {tid = Talents.T_POISON_GAS_TRAP, chance = 25},
	combatAttack = function(self) return self.dam end
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST", image = "trap/trap_purging.png",
	subtype = "nature",
	name = "anti-magic trap",
	detect_power = resolvers.clscale(40,25,15,0.5),
	disarm_power = resolvers.clscale(35,25,15,0.5),
	rarity = 8, level_range = {25, nil},
	color_r=40, color_g=220, color_b=0,
	message = _t"@Target@ is blasted with anti-magic forces!",
	dam = resolvers.clscale(160, 50, 40, 0.75, 60),
	damtype = DamageType.MANABURN, radius = 2,
	unided_name = _t"dull area",
	desc = function(self)
		return ("Deals up to %d manaburn damage, draining mana, vim, and positive and negative energies within radius %d."):tformat(self.dam, self.radius)
	end,
	unlock_talent_on_disarm = {tid = Talents.T_PURGING_TRAP, chance = 15},
}
newEntity{ base = "TRAP_ELEMENTAL_BLAST",
	subtype = "fire",
	name = "dragon fire trap", image = "trap/trap_dragonsfire.png",
	detect_power = resolvers.clscale(40,25,12,0.5),
	disarm_power = resolvers.clscale(40,25,12,0.5),
	rarity = 8, level_range = {25, nil},
	color_r=220, color_g=0, color_b=0,
	message = _t"A powerful blast of fire impacts @target@!",
	unided_name = _t"burned area",
	dam = resolvers.clscale(200, 50, 50, 0.75, 80),
	pressure_trap = true,
	damtype = DamageType.FIRE_STUN, radius = 2,
	desc = function(self)
		return ("All within radius %d are dealt %d fire damage, set on fire for %d more fire damage over 3 turns, and may be stunned."):tformat(self.radius, self.dam/2, self.dam/2)
	end,
	unlock_talent_on_disarm = {tid = Talents.T_DRAGONSFIRE_TRAP, chance = 25},
}