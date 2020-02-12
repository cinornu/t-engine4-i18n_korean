-- TE4 - T-Engine 4
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

defineAction{
	default = { "sym:_y:true:false:false:false" },
	type = "MTXN_PURCHASE",
	group = "microtransactions - cosmetic",
	name = _t"List purchasable",
	check = function() return profile:canMTXN() end,
}

defineAction{
	default = { "sym:_y:false:false:true:false" },
	type = "MTXN_USE",
	group = "microtransactions - cosmetic",
	name = _t"Use purchased",
	check = function() return profile:canMTXN() end,
}
