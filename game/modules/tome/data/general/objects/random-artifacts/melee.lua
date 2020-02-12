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

load("/data/general/objects/random-artifacts/generic.lua")

----------------------------------------------------------------
-- Weapon Properties
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="damage", points = 1, rarity = 10, level_range = {1, 50},
	combat = { dam = resolvers.randartmax(2, 20), },
}
newEntity{ theme={physical=true}, name="apr", points = 1, rarity = 10, level_range = {1, 50},
	combat = { apr = resolvers.randartmax(1, 15), },
}
newEntity{ theme={physical=true}, name="crit", points = 1, rarity = 10, level_range = {1, 50},
	combat = { physcrit = resolvers.randartmax(1, 15), },
}
newEntity{ theme={physical=true, spell=true}, name="phasing", points = 1, rarity = 30, level_range = {1, 50},
	combat = { phasing = resolvers.randartmax(10, 30), },
}
----------------------------------------------------------------
-- Melee damage projection
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="physical melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.PHYSICAL] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={mind=true, mental=true}, name="mind melee", points = 1, rarity = 24, level_range = {1, 50},
	combat = { melee_project = {[DamageType.MIND] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={acid=true}, name="acid melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ACID] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={lightning=true}, name="lightning melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.LIGHTNING] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={fire=true}, name="fire melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.FIRE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={cold=true}, name="cold melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.COLD] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={light=true}, name="light melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.LIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={dark=true}, name="dark melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.DARKNESS] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={blight=true, spell=true}, name="blight melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.BLIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={nature=true}, name="nature melee", points = 1, rarity = 18, level_range = {1, 50},
	combat = { melee_project = {[DamageType.NATURE] = resolvers.randartmax(4, 20), }, },
}	
newEntity{ theme={arcane=true, spell=true}, name="arcane melee", points = 1, rarity = 24, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ARCANE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={temporal=true}, name="temporal melee", points = 1, rarity = 24, level_range = {1, 50},
	combat = { melee_project = {[DamageType.TEMPORAL] = resolvers.randartmax(4, 20), }, },
}
----------------------------------------------------------------
-- Melee damage Projection (rare)
----------------------------------------------------------------
newEntity{ theme={blight=true}, name="corrupted blood melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_BLIGHT_DISEASE] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={temporal=true}, name="temporal energize melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_TEMPORAL_ENERGIZE] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={mind=true}, name="expose mind melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_MIND_EXPOSE] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={acid=true}, name="acid corrode melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_ACID_CORRODE] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={antimagic=true}, name="manaburn melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={nature=true, antimagic=true}, name="slime melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_NATURE_SLOW] = resolvers.randartmax(10, 20), }, },
}
newEntity{ theme={dark=true}, name="dark numbing melee", points = 2, rarity = 20, level_range = {1, 50},
	combat = { melee_project = {[DamageType.ITEM_DARKNESS_NUMBING] = resolvers.randartmax(10, 20), }, },
}

----------------------------------------------------------------
-- Melee damage burst
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="physical burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.PHYSICAL] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={mind=true, mental=true}, name="mind burst", points = 1, rarity = 30, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.MIND] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={acid=true}, name="acid burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.ACID] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={lightning=true}, name="lightning burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.LIGHTNING] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={fire=true}, name="fire burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.FIRE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={cold=true}, name="cold burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.COLD] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={light=true}, name="light burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.LIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={dark=true}, name="dark burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.DARKNESS] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={blight=true}, name="blight burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.BLIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={nature=true}, name="nature burst", points = 1, rarity = 24, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.NATURE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={arcane=true}, name="arcane burst", points = 1, rarity = 30, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.ARCANE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={temporal=true}, name="temporal burst", points = 1, rarity = 30, level_range = {1, 50},
	combat = { burst_on_hit = {[DamageType.TEMPORAL] = resolvers.randartmax(4, 20), }, },
}
----------------------------------------------------------------
-- Melee damage burst(crit)
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="physical burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.PHYSICAL] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={mind=true, mental=true}, name="mind burst (crit)", points = 1, rarity = 36, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.MIND] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={acid=true}, name="acid burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.ACID] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={lightning=true}, name="lightning burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.LIGHTNING] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={fire=true}, name="fire burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.FIRE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={cold=true}, name="cold burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.COLD] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={light=true}, name="light burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.LIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={dark=true}, name="dark burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.DARKNESS] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={blight=true}, name="blight burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.BLIGHT] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={nature=true}, name="nature burst (crit)", points = 1, rarity = 28, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.NATURE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={arcane=true}, name="arcane burst (crit)", points = 1, rarity = 36, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.ARCANE] = resolvers.randartmax(4, 20), }, },
}
newEntity{ theme={temporal=true}, name="temporal burst (crit)", points = 1, rarity = 36, level_range = {1, 50},
	combat = { burst_on_crit = {[DamageType.TEMPORAL] = resolvers.randartmax(4, 20), }, },
}