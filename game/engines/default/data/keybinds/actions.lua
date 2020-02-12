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
	default = { "uni:<", "uni:>" },
	type = "CHANGE_LEVEL",
	group = "actions",
	name = _t"Go to next/previous level",
}

defineAction{
	default = { "sym:=p:false:false:false:false", "sym:=g:false:true:false:false" },
	type = "LEVELUP",
	group = "actions",
	name = _t"Levelup window",
}
defineAction{
	default = { "sym:=m:false:false:false:false" },
	type = "USE_TALENTS",
	group = "actions",
	name = _t"Use talents",
}

defineAction{
	default = { "sym:=j:false:false:false:false", "sym:_q:true:false:false:false" },
	type = "SHOW_QUESTS",
	group = "actions",
	name = _t"Show quests",
}

defineAction{
	default = { "sym:=r:false:false:false:false", "sym:=r:false:true:false:false" },
	type = "REST",
	group = "actions",
	name = _t"Rest for a while",
}

defineAction{
	default = { "sym:_s:true:false:false:false" },
	type = "SAVE_GAME",
	group = "actions",
	name = _t"Save game",
}

defineAction{
	default = { "sym:_x:true:false:false:false" },
	type = "QUIT_GAME",
	group = "actions",
	name = _t"Quit game",
}

defineAction{
	default = { "sym:_t:false:true:false:false" },
	type = "TACTICAL_DISPLAY",
	group = "actions",
	name = _t"Tactical display on/off",
}

defineAction{
	default = { "sym:=l:false:false:false:false" },
	type = "LOOK_AROUND",
	group = "actions",
	name = _t"Look around",
}

defineAction{
	default = { "sym:_HOME:true:false:false:false"},
	type = "CENTER_ON_PLAYER",
	group = "actions",
	name = _t"Center the view on the player",
}

defineAction{
	default = { "sym:_TAB:false:false:false:false" },
	type = "TOGGLE_MINIMAP",
	group = "actions",
	name = _t"Toggle minimap",
}

defineAction{
	default = { "sym:=t:true:false:false:false" },
	type = "SHOW_TIME",
	group = "actions",
	name = _t"Show game calendar",
}

defineAction{
	default = { "sym:=c:false:false:false:false", "sym:=c:false:true:false:false" },
	type = "SHOW_CHARACTER_SHEET",
	group = "actions",
	name = _t"Show character sheet",
}

defineAction{
	default = { "sym:_s:false:false:true:false" },
	type = "SWITCH_GFX",
	group = "actions",
	name = _t"Switch graphical modes",
}

defineAction{
	default = { "sym:_RETURN:false:false:false:false", "sym:_KP_ENTER:false:false:false:false" },
	type = "ACCEPT",
	group = "actions",
	name = _t"Accept action",
}

defineAction{
	default = { "sym:_ESCAPE:false:false:false:false" },
	type = "EXIT",
	group = "actions",
	name = _t"Exit menu",
}
