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

newEntity{ define_as = "TRAP_WATER",
	type = "natural", subtype="water", id_by_type=true, unided_name = _t"trap",
	display = '^',
	triggered = function(self, x, y, who)
		self:project({type="hit",x=x,y=y}, x, y, self.damtype, self.dam, self.particles and {type=self.particles})
		return true, self.auto_disarm
	end,
}

newEntity{ base = "TRAP_WATER",
	name = "water jet", auto_id = true, image = "trap/trap_water_jet_01.png",
	detect_power = resolvers.clscale(6,10,4,0.5),
	disarm_power = resolvers.clscale(16,10,8,0.5),
	rarity = 3, level_range = {1, 50},
	color=colors.LIGHT_BLUE,
	message = _t"@Target@ triggers a water jet!",
	unided_name = _t"a nozzle",
	desc = function(self)
		local dtype = engine.DamageType[self.damtype] and engine.DamageType:get(self.damtype)
		return dtype and ("Deals %s%d#LAST# %s damage."):tformat(dtype.text_color or "#WHITE#", self.dam, dtype.name)
	end,
	dam = resolvers.clscale(100, 50, 25, 0.75, 0),
	damtype = DamageType.PHYSICAL,
	auto_disarm = true,
}

newEntity{ base = "TRAP_WATER",
	name = "water siphon", auto_id = true, image = "trap/trap_water_siphon_01.png",
	detect_power = resolvers.clscale(8,10,6,0.5),
	disarm_power = resolvers.clscale(4,10,3,0.5),
	rarity = 3, level_range = {1, 50},
	color=colors.BLUE,
	message = _t"@Target@ is caught by a water siphon!",
	unided_name = _t"a drain",
	desc = function(self)
		local dtype = engine.DamageType[self.damtype] and engine.DamageType:get(self.damtype)
		return dtype and ("Deals %s%d#LAST# %s damage (radius %d)."):tformat(dtype.text_color or "#WHITE#", self.dam, dtype.name, self.radius or 2)
	end,
	redius = 2,
	dam = resolvers.clscale(60, 50, 15, 0.75, 0),
	damtype = DamageType.PINNING,
	combatPhysicalpower = function(self) return self.disarm_power * 2 end,
	triggered = function(self, x, y, who)
		self:project({type="ball",radius=self.radius,x=x,y=y}, x, y, self.damtype, {dam=self.dam,dur=4})
		return true
	end,
}
