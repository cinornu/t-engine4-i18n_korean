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
for i = 1, 10 * radius * radius do
	local a = rng.float(0, math.pi * 2)
	local r = rng.range(0, 32 + radius * 64)
	spots[#spots+1] = {
		x = math.cos(a) * r,
		y = math.sin(a) * r,
		a = a + rng.float(-math.pi / 20, math.pi / 20),
	}
end

local idx = 1
return { generator = function()
	local life = rng.range(8,12)
	local spot = spots[idx] idx = idx + 1

	return {
		life = life,
		size = rng.range(55, 75), sizev = 0, sizea = 0,

		x = spot.x, xv = 0, xa = 0,
		y = spot.y, yv = 0, ya = 0,
		dir = 0, dirv = 0, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = 1, rv = 0, ra = 0,
		g = 1, gv = 0, ga = 0,
		b = 1, bv = 0, ba = 0,
		a = 0, av = 1 / (life), aa = 0,
	}
end, },
function(self)
	if nb == 0 then self.ps:emit(#spots / 2)
	elseif nb == 2 then self.ps:emit(#spots / 4)
	elseif nb == 4 then self.ps:emit(#spots / 8)
	elseif nb == 6 then self.ps:emit(#spots / 8) end
	nb = nb + 1 
end,
#spots, "particles_images/particle_volley"
