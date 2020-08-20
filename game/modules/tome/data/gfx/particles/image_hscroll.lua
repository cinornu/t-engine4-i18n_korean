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

local x = x or 0
local r = r or 1
local g = g or 1
local b = b or 1
local a = a or 1
local av = av or 0

local xv = xv or 5

local nb = 0
return { generator = function()
	local x = x
	local life = size / xv
	if nb > 1 then
		x = x - size
		life = life * 2
	end
	return {
		life = life,
		size = size, sizev = 0, sizea = 0,

		x = x, xv = xv, xa = 0,
		y = y, yv = 0, ya = 0,
		dir = 0, dirv = dirv, dira = 0,
		vel = 0, velv = 0, vela = 0,

		r = r, rv = 0, ra = 0,
		g = g, gv = 0, ga = 0,
		b = b, bv = 0, ba = 0,
		a = a, av = av, aa = 0,
	}
end, },
function(self)
	nb = nb + 1
	if nb == 1 then
		self.ps:emit(1)
		nb = nb + 1
		self.ps:emit(1)
	else
		self.ps:emit(1)
	end
end,
2,
image
