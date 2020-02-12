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

return { one_per_level = true,
	{name="rat-lich", percent=10},
	{name="weird-pedestals", percent=200},
	{name="bligthed-soil", minor=true, percent=40},
	{name="font-life", minor=true, percent=60},
	{name="whistling-vortex", minor=true, percent=60},
	{name="sub-vault", minor=true, percent=100, max_repeat=1, forbid={11}},
	{name="drake-cave", minor=true, percent=50, forbid={5,6,7,8,9,10,11}},
	{name="glowing-chest", minor=true, percent=70, forbid={1,2,3,4}},
}
