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

base_size = 64
toback = false
can_shift = true

local run = true
return { generator = function()
	local ad = rng.range(0, 360)
	local a = math.rad(ad)
	local dir = math.rad(90)
	local r = rng.range(18, 22)
	local dirchance = rng.chance(2)
	local x = rng.range(-6, 6) + x * 64
	local y = rng.range(-6, -2) + y * 64

	return {
		trail = 2,
		life = 32,
		size = rng.range(6, 12), sizev = 0, sizea = -0.016,

		x = x, xv = 0, xa = 0,
		y = y, yv = 0.2, ya = 0.04,
		dir = 0, dirv = 0, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = 10/255, rv = 0, ra = 0,
		g = 168/255, gv = 0, ga = 0,
		b = 13/255, bv = 0, ba = 0,
		a = 1.0, av = -1.0/32, aa = 0,
	}
end, },
function(self)
	if run then self.ps:emit(1) end
	run = not run
end,
32,
"particles_images/apply_poison"..rng.range(1, 4)
