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

newEntity{ define_as = "TRAP_TEMPORAL",
	type = "temporal", subtype="water", id_by_type=true, unided_name = _t"trap",
	display = '^',
	triggered = function(self, x, y, who)
		return true, self.auto_disarm
	end,
}

newEntity{ base = "TRAP_TEMPORAL",
	name = "disturbed pocket of time", auto_id = true, image = "trap/disturbed_pocket_of_time.png",
	detect_power = resolvers.clscale(10,25,8,0.5),
	disarm_power = resolvers.clscale(25,25,8,0.5),
	rarity = 3, level_range = {1, 50},
	color=colors.VIOLET,
	message = _t"@Target@ is caught in a distorted pocket of time!",
	unided_name = _t"faint distortion",
	desc=_t[[Creates a temporal anomaly when triggered.]],
	triggered = function(self, x, y, who)
		who:paradoxDoAnomaly(100, 0, {anomaly_type="no-major"})
		return true
	end,
}

newEntity{ base = "TRAP_TEMPORAL",
	name = "extremely disturbed pocket of time", auto_id = true, image = "trap/extremely_disturbed_pocket_of_time.png",
	detect_power = resolvers.clscale(8,25,8,0.5),
	disarm_power = resolvers.clscale(32,25,8,0.5),
	rarity = 6, level_range = {10, nil},
	color=colors.PURPLE,
	message = _t"@Target@ is caught in an extremely distorted pocket of time!",
	unided_name = _t"distortion",
	desc=_t[[Creates a major temporal anomaly when triggered.]],
	triggered = function(self, x, y, who)
		who:paradoxDoAnomaly(100, 0, {anomaly_type="major"})
		return true
	end,
}
