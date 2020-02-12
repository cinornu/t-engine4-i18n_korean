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
	default = { "sym:=i:false:false:false:false", },
	type = "SHOW_INVENTORY",
	group = "inventory",
	name = _t"Show inventory",
}
defineAction{
	default = { "sym:=e:false:false:false:false", },
	type = "SHOW_EQUIPMENT",
	group = "inventory",
	name = _t"Show equipment",
}

defineAction{
	default = { "sym:=g:false:false:false:false" },
	type = "PICKUP_FLOOR",
	group = "inventory",
	name = _t"Pickup items",
}
defineAction{
	default = { "sym:=d:false:false:false:false" },
	type = "DROP_FLOOR",
	group = "inventory",
	name = _t"Drop items",
}

defineAction{
	default = { "sym:=w:false:false:false:false", },
	type = "WEAR_ITEM",
	group = "inventory",
	name = _t"Wield/wear items",
}
defineAction{
	default = { "sym:=t:false:false:false:false", },
	type = "TAKEOFF_ITEM",
	group = "inventory",
	name = _t"Takeoff items",
}

defineAction{
	default = { "sym:=u:false:false:false:false", },
	type = "USE_ITEM",
	group = "inventory",
	name = _t"Use items",
}

defineAction{
	default = { "sym:=q:false:false:false:false", },
	type = "QUICK_SWITCH_WEAPON",
	group = "inventory",
	name = _t"Quick switch weapons set",
}
