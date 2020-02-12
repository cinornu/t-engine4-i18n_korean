local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"

-- Stave randart powers trend towards reinforcing elemental themes
load("/data/general/objects/random-artifacts/generic.lua")


newEntity{ theme={light=true,dark=true,spell=true}, name="stave increased positive/negative energy", points = 3, rarity = 16, level_range = {1, 50},
	wielder = {
		max_negative = resolvers.randartmax(5,20),
		max_positive = resolvers.randartmax(5,20),
	},
}

newEntity{ theme={temporal=true}, name="stave paradox reduce anomalies", points = 1, rarity = 16, level_range = {1, 50},
	wielder = {
		paradox_reduce_anomalies = resolvers.randartmax(5, 20),
	},
}

newEntity{ theme={spell=true}, name="stave spellpower", points = 1, rarity = 15, level_range = {1, 50},
	wielder = { combat_spellpower = resolvers.randartmax(2, 20), },
}

----------------------------------------------------------------
-- Damage %
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="stave inc damage physical", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.PHYSICAL] = resolvers.randartmax(3, 15), }, },
}
newEntity{ theme={mind=true, mental=true}, name="stave inc damage mind", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.MIND] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={fire=true}, name="stave inc damage fire", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.FIRE] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={cold=true}, name="stave inc damage cold", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.COLD] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={acid=true}, name="stave inc damage acid", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.ACID] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={lightning=true}, name="stave inc damage lightning", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.LIGHTNING] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={arcane=true, spell=true}, name="stave inc damage arcane", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.ARCANE] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={nature=true}, name="stave inc damage nature", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.NATURE] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={blight=true, spell=true}, name="stave inc damage blight", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.BLIGHT] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={light=true}, name="stave inc damage light", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.LIGHT] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={dark=true}, name="stave inc damage darkness", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.DARKNESS] = resolvers.randartmax(3, 15),  }, },
}
newEntity{ theme={temporal=true}, name="stave inc damage temporal", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { inc_damage = { [DamageType.TEMPORAL] = resolvers.randartmax(3, 15),  }, },
}

----------------------------------------------------------------
-- Resist Penetration %
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="stave resists pen physical", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.PHYSICAL] = resolvers.randartmax(5, 15), }, },
}
newEntity{ theme={mind=true, mental=true}, name="stave resists pen mind", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.MIND] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={fire=true}, name="stave resists pen fire", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.FIRE] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={cold=true}, name="stave resists pen cold", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.COLD] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={acid=true}, name="stave resists pen acid", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.ACID] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={lightning=true}, name="stave resists pen lightning", points = 11, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.LIGHTNING] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={arcane=true, spell=true}, name="stave resists pen arcane", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.ARCANE] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={nature=true}, name="stave resists pen nature", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.NATURE] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={blight=true, spell=true}, name="stave resists pen blight", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.BLIGHT] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={light=true}, name="stave resists pen light", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.LIGHT] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={dark=true}, name="stave resists pen darkness", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.DARKNESS] = resolvers.randartmax(5, 15),  }, },
}
newEntity{ theme={temporal=true}, name="stave resists pen temporal", points = 1, rarity = 16, level_range = {1, 50},
	wielder = { resists_pen = { [DamageType.TEMPORAL] = resolvers.randartmax(5, 15),  }, },
}
