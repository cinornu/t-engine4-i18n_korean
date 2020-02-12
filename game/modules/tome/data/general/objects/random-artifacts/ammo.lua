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

-- melee.lua loads generic.lua too so we get rid of anything with a "wielder" field and any melee specific parts to ranged
load("/data/general/objects/random-artifacts/melee.lua", function(e)
	if e.combat and e.combat.melee_project then
		e.combat.ranged_project = table.clone(e.combat.melee_project)
		e.combat.melee_project = nil
	end
	if e.wielder then
		e.rarity = nil
	end
end)

----------------------------------------------------------------
-- Ammo Properties
----------------------------------------------------------------
newEntity{ theme={physical=true}, name="ammo reload", points = 1, rarity = 10, level_range = {1, 50},
	wielder = { ammo_reload_speed = resolvers.randartmax(1, 4), },
}
newEntity{ theme={physical=true}, name="travel speed", points = 1, rarity = 10, level_range = {1, 50},
	combat = { travel_speed = resolvers.randartmax(1, 2), },
}