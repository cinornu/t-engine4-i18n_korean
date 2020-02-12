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

local nb = 0

local spots = {}
for i = 1, 20 * radius * radius do
	local a = rng.float(0, math.pi * 2)
	local r = rng.range(64, 32 + radius * 64)
	spots[#spots+1] = {
		x = math.cos(a) * r,
		y = math.sin(a) * r,
		a = a + rng.float(-math.pi / 20, math.pi / 20),
	}
end

local idx = 1
return { generator = function()
	local life = rng.range(8,15)
	local spot = spots[idx] idx = idx + 1

	return {
		life = life,
		size = rng.range(32, 64), sizev = -0.2, sizea = 0,

		x = spot.x, xv = 0, xa = 0,
		y = spot.y, yv = 0, ya = 0,
		dir = spot.a, dirv = 0, dira = 0,
		vel = rng.float(0.2, 0.5), velv = 0, vela = 0,

		r = 1, rv = 0, ra = 0,
		g = 1, gv = 0, ga = 0,
		b = 1, bv = 0, ba = 0,
		a = 0, av = 1 / (life/2), aa = 0,
	}
end, },
function(self)
	if nb < 1 then self.ps:emit(#spots) nb = nb + 1 end
end,
#spots, "particles_images/butterfly_kick"
