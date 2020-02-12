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

can_shift = true
base_size = 32

return { generator = function()
	local a = rng.float(0,math.pi*2)
	local dir = a+math.pi*0.5
	local r = (engine.Map.tile_w + engine.Map.tile_h) / 5

	return {
		life = 14,
		size = rng.range(1,2), sizev = 0.3, sizea = -0.01,

		x = r * math.cos(a), xv = 0.01*math.cos(a), xa = -0.25*math.cos(a),
		y = r * math.sin(a), yv = 0.167*math.cos(a), ya = 0,
		dir = dir, dirv = 0, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = rng.range(160, 180)/255, rv = 0, ra = 0,
		g = rng.range(180, 200)/255, gv = 0, ga = 0,
		b = rng.range(195, 225)/255, gv = 0, ga = 0,
		a = 1, av = 0, aa = 0,
	}
end, },
function(self)
	self.ps:emit(4)
end,
240