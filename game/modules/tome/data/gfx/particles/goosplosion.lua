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

return { generator = function()
	local ad = rng.float(0, 360)
	local a = math.rad(ad)

	return {
		life = rng.range(6, 10),
		size = rng.range(24, 64), sizev = 0, sizea = 0,

		x = 0, xv = 0, xa = 0,
		y = 0, yv = 0, ya = 0,
		dir = a, dirv = 0, dira = 0,
		vel = rng.float(6, 9), velv = 0, vela = 0,

		r = 1,   rv = 0, ra = 0,
		g = 1,   gv = 0, ga = 0,
		b = 1,   bv = 0, ba = 0,
		a = rng.float(0.6, 1), av = rng.float(-0.15, -0.07), aa = 0,
	}
end, },
function(self)
	self.nb = (self.nb or 0) + 1
	if self.nb <= 3 then
		self.ps:emit(5)
	end
end,
15, "particles_images/goo_splash_0"..rng.range(1, 5)