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
can_shift = true

local radius = radius or 3
local mult = 4 * math.pi * radius ^ 2
radius = radius * engine.Map.tile_w

local nb = 0

return { generator = function()
	local ad = rng.range(0, 360)
	local a = math.rad(ad)
	local dir = math.rad(ad)
	local r = rng.range(0, radius)

	return {
		life = 100,
		size = rng.range(24, 48), sizev = -0.05, sizea = 0,

		x = r * math.cos(a), xv = 0, xa = 0,
		y = r * math.sin(a), yv = 0, ya = 0,
		dir = 0, dirv = 0, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = 1,   rv = 0, ra = 0,
		g = 1,   gv = 0, ga = 0,
		b = 1,   gv = 0, ga = 0,
		a = rng.float(0.02, 0.1),   av = 0.0152*2, aa = -0.0005*2,
	}
end, },
function(self)
	self.ps:emit(math.floor(mult/100))
end,
20 * mult, "particles_images/putrescent_liquefaction_02_"..img