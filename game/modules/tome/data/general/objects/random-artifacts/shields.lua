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

-- melee.lua loads generic.lua for us, then we convert any melee specific parts to special_combat.melee
load("/data/general/objects/random-artifacts/melee.lua", function(e)
	if e.combat then
		e.special_combat = table.clone(e.combat)
		e.combat = nil
	end
end)

newEntity{ theme={defense=true, physical=true}, name="shield block", points = 1, rarity = 10, level_range = {1, 50},
	special_combat = { block = resolvers.randartmax(20, 40), },
}
newEntity{ theme={defense=true, physical=true}, name="shield armor", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { combat_armor = resolvers.randartmax(3, 15), },
}
newEntity{ theme={defense=true}, name="shield increased life", points = 1, rarity = 11, level_range = {1, 50},
	wielder = { max_life = resolvers.randartmax(20, 100), },
}

