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

-- Themes list: physical, mental, spell, defense, misc, fire, lightning, acid, mind, arcane, blight, nature, temporal, light, dark, antimagic, cold

----------------------------------------------------------------
-- Spell Themes
----------------------------------------------------------------
----------------------------------------------------------------
-- Spell damage
----------------------------------------------------------------
newEntity{ theme={spell=true}, name="generic spellpower", points = 1, rarity = 8, level_range = {1, 50},
	wielder = { combat_spellpower = resolvers.randartmax(5, 30), },
}
newEntity{ theme={spell=true}, name="generic spellcrit", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_spellcrit = resolvers.randartmax(1, 8), },
}
newEntity{ theme={spell=true}, name="generic spell crit magnitude", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { combat_critical_power = resolvers.randartmax(5, 20), },
}
newEntity{ theme={spell=true}, name="generic spellsurge", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { spellsurge_on_crit = resolvers.randartmax(2, 10), },
}
----------------------------------------------------------------
-- Resources
----------------------------------------------------------------
newEntity{ theme={spell=true}, name="generic mana regeneration", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { mana_regen = resolvers.randartmax(.04, .6), },
}
newEntity{ theme={spell=true}, name="generic increased mana", points = 1, rarity = 14, level_range = {1, 50},
	wielder = { max_mana = resolvers.randartmax(20, 100), },
}
newEntity{ theme={spell=true}, name="generic mana on crit", points = 1, rarity = 14, level_range = {1, 50},
	wielder = { mana_on_crit = resolvers.randartmax(1, 2), },
}
newEntity{ theme={spell=true}, name="generic increased vim", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { max_vim = resolvers.randartmax(10, 50), },
}
newEntity{ theme={spell=true}, name="generic vim on crit", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { vim_on_crit = resolvers.randartmax(1, 2), },
}
----------------------------------------------------------------
-- Misc
----------------------------------------------------------------
newEntity{ theme={spell=true}, name="generic phasing", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { damage_shield_penetrate = resolvers.randartmax(10, 30), },
}

----------------------------------------------------------------
-- Mental Themes
----------------------------------------------------------------
----------------------------------------------------------------
-- Mental Damage
----------------------------------------------------------------
newEntity{ theme={mental=true}, name="generic mindpower", points = 1, rarity = 8, level_range = {1, 50},
	wielder = { combat_mindpower = resolvers.randartmax(5, 30), },
}
newEntity{ theme={mental=true}, name="generic mindcrit", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_mindcrit = resolvers.randartmax(1, 8), },
}
newEntity{ theme={mental=true}, name="generic mind crit magnitude", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { combat_critical_power = resolvers.randartmax(5, 20), },
}
----------------------------------------------------------------
-- Resources
----------------------------------------------------------------
newEntity{ theme={mental=true}, name="generic equilibrium on hit", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { equilibrium_regen_when_hit = resolvers.randartmax(.04, 2), },
}
newEntity{ theme={mental=true}, name="generic max hate", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { max_hate = resolvers.randartmax(2, 10), },
}
newEntity{ theme={mental=true}, name="generic hate on crit", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { hate_on_crit = resolvers.randartmax(1, 5), },
}
newEntity{ theme={mental=true}, name="generic max psi", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { max_psi = resolvers.randartmax(10, 50), },
}
newEntity{ theme={mental=true}, name="generic psi on hit", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { psi_regen_when_hit = resolvers.randartmax(.04, 2), },
}

----------------------------------------------------------------
-- Physical Themes
----------------------------------------------------------------
----------------------------------------------------------------
-- Physical Damage
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="generic phys dam", points = 1, rarity = 8, level_range = {1, 50},
	wielder = { combat_dam = resolvers.randartmax(5, 30), },
}
newEntity{ theme={physical=true}, name="generic phys apr", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_apr = resolvers.randartmax(1, 15), },
}
newEntity{ theme={physical=true}, name="generic phys crit", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_physcrit = resolvers.randartmax(1, 8), },
}
newEntity{ theme={physical=true}, name="generic phys atk", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_atk = resolvers.randartmax(5, 30), },
}
newEntity{ theme={physical=true}, name="generic phys crit magnitude", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { combat_critical_power = resolvers.randartmax(5, 20),   },
}
----------------------------------------------------------------
-- Resources
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="generic stamina regeneration", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { stamina_regen = resolvers.randartmax(1, 3), },
}
newEntity{ theme={physical=true}, name="generic increased stamina", points = 1, rarity = 14, level_range = {1, 50},
	wielder = { max_stamina = resolvers.randartmax(10, 30), },
}

----------------------------------------------------------------
-- Misc
----------------------------------------------------------------

----------------------------------------------------------------
-- Defense Themes
----------------------------------------------------------------
----------------------------------------------------------------
-- Defense
----------------------------------------------------------------
newEntity{ theme={defense=true, physical=true}, name="generic def", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_def = resolvers.randartmax(5, 30),
				},
}
newEntity{ theme={defense=true, physical=true}, name="generic armor", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_armor = resolvers.randartmax(2, 16), },
}
newEntity{ theme={defense=true}, name="generic life regeneration", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { life_regen = resolvers.randartmax(2, 4), },
}
newEntity{ theme={defense=true}, name="generic increased life", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { max_life = resolvers.randartmax(20, 100), },
}
newEntity{ theme={defense=true}, name="generic improve heal", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { healing_factor = resolvers.randartmax(0.05, .2), },
}
----------------------------------------------------------------
-- Saves
----------------------------------------------------------------
newEntity{ theme={defense=true, physical=true}, name="generic save physical", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { combat_physresist = resolvers.randartmax(3, 18), },
}
newEntity{ theme={defense=true, spell=true, antimagic=true}, name="generic save spell", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { combat_spellresist = resolvers.randartmax(3, 18), },
}
newEntity{ theme={defense=true, mental=true}, name="generic save mental", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { combat_mentalresist = resolvers.randartmax(3, 18), },
}
--------------------------------------------------------------
-- Immunities
-------------------------	-------------------------------------
newEntity{ theme={defense=true}, name="generic immune stun", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { stun_immune = resolvers.randartmax(0.1, 0.2), },
}
newEntity{ theme={defense=true}, name="generic immune knockback", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { knockback_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune blind", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { blind_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune confusion", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { confusion_immune = resolvers.randartmax(0.1, 0.2), },
}
newEntity{ theme={defense=true}, name="generic immune pin", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { pin_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune poison", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { poison_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune disease", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { disease_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune silence", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { silence_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune disarm", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { disarm_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune cut", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { cut_immune = resolvers.randartmax(0.1, 0.2),  },
}
newEntity{ theme={defense=true}, name="generic immune teleport", points = 2, rarity = 25, level_range = {1, 50},
	wielder = { teleport_immune = resolvers.randartmax(0.1, 0.2),  },
}
--------------------------------------------------------------
-- Resist %
--------------------------------------------------------------
newEntity{ theme={defense=true, physical=true}, name="generic resist physical", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { resists = { [DamageType.PHYSICAL] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={defense=true, mind=true}, name="generic resist mind", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { resists = { [DamageType.MIND] = resolvers.randartmax(3, 15), }, },
}
newEntity{ theme={defense=true, antimagic=true, fire=true}, name="generic resist fire", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.FIRE] = resolvers.randartmax(3, 30), }, },
}
newEntity{ theme={defense=true, antimagic=true, cold=true}, name="generic resist cold", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.COLD] = resolvers.randartmax(3, 30), }, },
}
newEntity{ theme={defense=true, antimagic=true, acid=true}, name="generic resist acid", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.ACID] = resolvers.randartmax(3, 30), }, },
}
newEntity{ theme={defense=true, antimagic=true, lightning=true}, name="generic resist lightning", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.LIGHTNING] = resolvers.randartmax(3, 30), }, },
}
newEntity{ theme={defense=true, antimagic=true, arcane=true}, name="generic resist arcane", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { resists = { [DamageType.ARCANE] = resolvers.randartmax(5, 5), }, },
}
newEntity{ theme={defense=true, antimagic=true, nature=true}, name="generic resist nature", points = 2, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.NATURE] = resolvers.randartmax(3, 20), }, },
}
newEntity{ theme={defense=true, antimagic=true, blight=true}, name="generic resist blight", points = 2, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.BLIGHT] = resolvers.randartmax(3, 20), }, },
}
newEntity{ theme={defense=true, antimagic=true, light=true}, name="generic resist light", points = 2, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.LIGHT] = resolvers.randartmax(3, 20), }, },
}
newEntity{ theme={defense=true, antimagic=true, dark=true}, name="generic resist darkness", points = 2, rarity = 11, level_range = {1, 50},
	wielder = { resists = { [DamageType.DARKNESS] = resolvers.randartmax(3, 20), }, },
}
newEntity{ theme={defense=true, antimagic=true, temporal=true}, name="generic resist temporal", points = 2, rarity = 15, level_range = {1, 50},
	wielder = { resists = { [DamageType.TEMPORAL] = resolvers.randartmax(3, 15), }, },
}

----------------------------------------------------------------
--- Elemental Themes ---
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
-- Elemental Retribution
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="generic physical retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.PHYSICAL] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={mind=true, mental=true}, name="generic mind retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.MIND] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={acid=true}, name="generic acid retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.ACID] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={lightning=true}, name="generic lightning retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.LIGHTNING] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={fire=true}, name="generic fire retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.FIRE] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={cold=true}, name="generic cold retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.COLD] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={light=true}, name="generic light retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.LIGHT] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={dark=true}, name="generic dark retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.DARKNESS] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={blight=true, spell=true}, name="generic blight retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.BLIGHT] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={nature=true}, name="generic nature retribution", points = 1, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.NATURE] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={arcane=true, spell=true}, name="generic arcane retribution", points = 2, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.ARCANE] = resolvers.randartmax(2, 10), }, },
}
newEntity{ theme={temporal=true}, name="generic temporal retribution", points = 2, rarity = 35, level_range = {1, 50},
	wielder = { on_melee_hit = {[DamageType.TEMPORAL] = resolvers.randartmax(2, 10), }, },
}

----------------------------------------------------------------
-- Damage %
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="generic inc damage physical", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.PHYSICAL] = resolvers.randartmax(3, 30), }, },
}
newEntity{ theme={mind=true, mental=true}, name="generic inc damage mind", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.MIND] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={fire=true}, name="generic inc damage fire", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.FIRE] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={cold=true}, name="generic inc damage cold", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.COLD] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={acid=true}, name="generic inc damage acid", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.ACID] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={lightning=true}, name="generic inc damage lightning", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.LIGHTNING] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={arcane=true, spell=true}, name="generic inc damage arcane", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.ARCANE] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={nature=true}, name="generic inc damage nature", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.NATURE] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={blight=true, spell=true}, name="generic inc damage blight", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.BLIGHT] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={light=true}, name="generic inc damage light", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.LIGHT] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={dark=true}, name="generic inc damage darkness", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.DARKNESS] = resolvers.randartmax(3, 30),  }, },
}
newEntity{ theme={temporal=true}, name="generic inc damage temporal", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.TEMPORAL] = resolvers.randartmax(3, 30),  }, },
}

----------------------------------------------------------------
-- Resist Penetration %
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="generic resists pen physical", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.PHYSICAL] = resolvers.randartmax(5, 25), }, },
}
newEntity{ theme={mind=true, mental=true}, name="generic resists pen mind", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.MIND] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={fire=true}, name="generic resists pen fire", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.FIRE] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={cold=true}, name="generic resists pen cold", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.COLD] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={acid=true}, name="generic resists pen acid", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.ACID] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={lightning=true}, name="generic resists pen lightning", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.LIGHTNING] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={arcane=true, spell=true}, name="generic resists pen arcane", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.ARCANE] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={nature=true}, name="generic resists pen nature", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.NATURE] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={blight=true, spell=true}, name="generic resists pen blight", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.BLIGHT] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={light=true}, name="generic resists pen light", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.LIGHT] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={dark=true}, name="generic resists pen darkness", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.DARKNESS] = resolvers.randartmax(5, 25),  }, },
}
newEntity{ theme={temporal=true}, name="generic resists pen temporal", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.TEMPORAL] = resolvers.randartmax(5, 25),  }, },
}

----------------------------------------------------------------
--- Misc Themes ---
----------------------------------------------------------------
----------------------------------------------------------------
-- Stats
----------------------------------------------------------------
newEntity{ theme={misc=true, physical=true}, name="generic stat str", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_STR] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={misc=true, physical=true}, name="generic stat dex", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_DEX] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={misc=true, spell=true}, name="generic stat mag", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_MAG] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={misc=true, spell=true, mental=true}, name="generic stat wil", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_WIL] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={misc=true, mental=true}, name="generic stat cun", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_CUN] = resolvers.randartmax(1, 15), }, },
}
newEntity{ theme={misc=true, physical=true}, name="generic stat con", points = 1, rarity = 7, level_range = {1, 50},
	wielder = { inc_stats = { [Stats.STAT_CON] = resolvers.randartmax(1, 15), }, },
}
----------------------------------------------------------------
-- Other
----------------------------------------------------------------
newEntity{ theme={misc=true, darkness=true}, name="generic see invisible", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { see_invisible = resolvers.randartmax(3, 24), },
}
newEntity{ theme={misc=true, darkness=true}, name="generic infravision radius", points = 1, rarity = 14, level_range = {1, 50},
	wielder = { infravision = resolvers.randartmax(1, 3), },
}
newEntity{ theme={misc=true, light=true}, name="generic lite radius", points = 1, rarity = 14, level_range = {1, 50},
	wielder = { lite = resolvers.randartmax(1, 3), },
}
-- newEntity{ theme={misc=true}, name="generic telepathy", points = 60, rarity = 130, level_range = {1, 50}, unique=1,
-- 	wielder = { esp_all = 1 },
-- }
-- newEntity{ theme={misc=true, mental=true}, name="generic orc telepathy", points = 2, rarity = 50, level_range = {1, 50}, unique=1,
-- 	wielder = { esp = {["humanoid/orc"]=1}, },
-- }
-- newEntity{ theme={misc=true, mental=true}, name="generic dragon telepathy", points = 2, rarity = 40, level_range = {1, 50}, unique=1,
-- 	wielder = { esp = {dragon=1}, },
-- }
-- newEntity{ theme={misc=true, mental=true}, name="generic demon telepathy", points = 2, rarity = 40, level_range = {1, 50}, unique=1,
-- 	wielder = { esp = {["demon/minor"]=1, ["demon/major"]=1}, },
-- }

----------------------------------------------------------------
-- Melee damage Projection (rare)
----------------------------------------------------------------
newEntity{ theme={blight=true}, name="generic corrupted blood melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_BLIGHT_DISEASE] = resolvers.randartmax(10, 20), }, 
	}
}
newEntity{ theme={acid=true}, name="generic acid corrode melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { melee_project = {[DamageType.ITEM_ACID_CORRODE] = resolvers.randartmax(10, 20), }, 
			}
	 }
newEntity{ theme={mind=true}, name="generic mind expose melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_MIND_EXPOSE] = resolvers.randartmax(10, 20), }, 
	},
}
newEntity{ theme={antimagic=true}, name="generic manaburn melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.randartmax(10, 20), }, 
	},
}
newEntity{ theme={temporal=true}, name="generic temporal energize melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_TEMPORAL_ENERGIZE] = resolvers.randartmax(10, 20), }, 
	},
}
newEntity{ theme={nature=true, antimagic=true}, name="generic slime melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_NATURE_SLOW] = resolvers.randartmax(10, 20), },
	},
}
newEntity{ theme={dark=true}, name="generic dark numbing melee", points = 2, rarity = 20, level_range = {1, 50},
	wielder = { 
		melee_project = {[DamageType.ITEM_DARKNESS_NUMBING] = resolvers.randartmax(10, 20), }, 
	},
}

-- The ultimate Ghoul buff
newEntity{ theme={physical=true, defense=true}, name="generic die at", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { die_at = resolvers.randartmax(-20, -80), },
}

newEntity{ theme={defense=true, misc=true}, name="generic ignore crit", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { ignore_direct_crits = resolvers.randartmax(5, 15), },
}

newEntity{ theme={defense=true, spell=true, temporal=true}, name="generic void", points = 1, rarity = 20, level_range = {1, 50},
	wielder = { defense_on_teleport = resolvers.randartmax(5, 15), 
				resist_all_on_teleport = resolvers.randartmax(5, 15), 
				effect_reduction_on_teleport = resolvers.randartmax(5, 15)
	},
}

