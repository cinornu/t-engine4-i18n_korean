-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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
	frag = "volumetric/volumetric",
	vert = nil,
	args = {
		tex = { texture = 0 },
		side = noup or 0,

		coneAngle = coneAngle or 0.0,
		topTransperency = topTransperency or 1.0,
		twist = twist or 20.0,
		isSphere = isSphere or 1.0,
		growSpeed = growSpeed or 1.000,

		cylinderRadius = cylinderRadius or 0.5,
		cylinderHeight = cylinderHeight or 1.0,

		shininess = shininess or 20.0,
		density = density or 30.0,

		scrollingSpeed = scrollingSpeed or -0.005,
	},
	resetargs = {
		tick_start = function() return core.game.getFrameTime() end,
	},
	clone = false,
}
