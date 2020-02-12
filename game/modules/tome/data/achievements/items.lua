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

newAchievement{
	name = "Deus Ex Machina",
	desc = _t[[Found the Blood of Life and the four unique inscriptions: Primal Infusion, Infusion of Wild Growth, Rune of Reflection and Rune of the Rift.]],
	mode = "player",
	can_gain = function(self, who, obj)
		if obj:getName{force_id=true} == "Blood of Life" then self.blood = true end
		if obj:getName{force_id=true}:toString():prefix("Primal Infusion") then self.primal = true end
		if obj:getName{force_id=true}:toString():prefix("Infusion of Wild Growth") then self.wild = true end
		if obj:getName{force_id=true}:toString():prefix("Rune of Reflection") then self.reflection = true end
		if obj:getName{force_id=true}:toString():prefix("Rune of the Rift") then self.rift = true end
		return self.blood and self.primal and self.wild and self.reflection and self.rift
	end
}

newAchievement{
	name = "Treasure Hunter",
	image = "object/money_large.png",
	show = "name",
	desc = _t[[Amassed 1000 gold pieces.]],
	can_gain = function(self, who)
		return who.money >= 1000
	end,
}

newAchievement{
	name = "Treasure Hoarder",
	image = "object/money_large.png",
	show = "name",
	desc = _t[[Amassed 3000 gold pieces.]],
	can_gain = function(self, who)
		return who.money >= 3000
	end,
}

newAchievement{ id = "DRAGON_GREED",
	name = "Dragon's Greed",
	image = "object/money_large.png",
	show = "name", huge=true,
	desc = _t[[Amassed 8000 gold pieces.]],
	can_gain = function(self, who)
		return who.money >= 8000
	end,
}
