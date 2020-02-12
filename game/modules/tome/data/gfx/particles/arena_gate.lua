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

base_size = 32

return {
	base = 2000,

	angle = { 0, 360 }, anglev = { 4000, 5000 }, anglea = { 20, 60 },

	life = { 20, 30 },
	size = { 7, 8 }, sizev = {0, 0}, sizea = {0, 0},

	r = {240, 255}, rv = {0, 10}, ra = {0, 0},
	g = {200, 214}, gv = {0, 0}, ga = {0, 0},
	b = {150, 163}, bv = {0, 10}, ba = {0, 0},
	a = {25, 120}, av = {0, 0}, aa = {0, 0},

}, function(self)
	self.nb = (self.nb or 0) + 1
	if self.nb < 3 then
		self.ps:emit(20)
	end
end