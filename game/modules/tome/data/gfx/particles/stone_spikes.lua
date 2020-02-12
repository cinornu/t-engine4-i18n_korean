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

return { generator = function()
	local size = rng.range(15, 32)
	return {
		trail = 0,
		life = 6,
		size = size, sizev = 0, sizea = 0,

		x = rng.range(-64+size/2, 64-size/2), xv = 0, xa = 0,
		y = rng.range(-64+size/2, 64-size/2), yv = 0, ya = 0,
		dir = 0, dirv = dirv, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = 0.6, rv = 0, ra = 0,
		g = 0.4, gv = 0, ga = 0,
		b = 0.3, bv = 0, ba = 0,
		a = 0.5, av = 0.1, aa = 0.01,
	}
end, },
function(self)
	if nb < 2 then self.ps:emit(4) nb = nb + 1 end
end,
8,
"shockbolt/trap/trap_ground_spikes_01"
