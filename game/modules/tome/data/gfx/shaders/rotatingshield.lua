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
	frag = "rotatingshield",
	vert = nil,
	args = {
		tex = { texture = 0 },
		noup = noup or 0,
		time_factor = time_factor or 1000,
		cylinderRotationSpeed = cylinderRotationSpeed or 1,  -- rotation speed of the aura, min: 0, max: 10, def: 1
		cylinderRadius = cylinderRadius or 0.45,  -- radius of the cylinder aura. min: 0.2, max: 0.5, def: 0.45
		cylinderVerticalPos = cylinderVerticalPos or 0,  -- vertical position of the cylinder. 0 is in the middle. min: -0.2, max: 0.2
		cylinderHeight = cylinderHeight or 0.4,  -- height of the cylinder. min: 0.1, max: 1.0, default: 0.4
		appearTime = appearTime or 1,  -- normalized appearence time. min: 0.01, max: 3.0, default: 1.0f
		repeatTimes = repeatTimes or 1,
		unbalancedSize = unbalancedSize or 1,
	},
	resetargs = {
		tick_start = function() return core.game.getFrameTime() end,
	},
	clone = false,
}
