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

load("/data/general/objects/objects-maj-eyal.lua")

newEntity{ base = "BASE_RING",
	power_source = {psionic=true},
	define_as = "RING_OF_BLOOD", rarity=false,
	name = "Bloodcaller", unique=true, image = "object/artifact/jewelry_ring_bloodcaller.png",
	desc = _t[[You won the Ring of Blood trial, and this is your reward.]],
	unided_name = _t"bloody ring",
	special_desc = function(self) return ("You heal for 2.5%% of the damage you deal.\nHealing during current combat:  #GREEN#%0.2f#LAST#"):tformat(self.bloodcaller_heal_amt or 0) end,
	rarity = false,
	cost = 300,
	material_level = 4,
	bloodcaller_heal_amt = 0,
	wielder = {
		combat_mentalresist = -7,
		fatigue = -5,
	},
	callbackOnCombat = function(self, who, combat)
		if not combat then
			self.bloodcaller_heal_amt = nil
		end
	end,
	callbackOnDealDamage = function(self, who, value, target, dead, death_node)
		-- Lifesteal done here to avoid stacking in bad ways with other LS effects
		if value <= 0 then return end
			local leech = value * 0.025
			if leech > 0 then
				local healed = who:heal(leech, self)
				self.bloodcaller_heal_amt = (self.bloodcaller_heal_amt or 0) + healed
			end
	end,
}
