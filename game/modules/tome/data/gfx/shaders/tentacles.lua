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

return {
	frag = "tentacles",
	vert = nil,
	args = {
		tex = { texture = 0 },
		mainfbo = { texture = 1 },
		color = color or {0.4, 0.7, 1.0},
		time_factor = time_factor or 2000,
		noup = noup or 0,
		wobblingType = wobblingType or 1,
		appearTime = appearTime or 0.5, -- normalized appearence time. min: 0.01, max: 3.0, default: 1.0f
		backgroundLayersCount = backgroundLayersCount or 1,
	},
	resetargs = {
		tick_start = function() return core.game.getFrameTime() end,
	},
	clone = true,
}
