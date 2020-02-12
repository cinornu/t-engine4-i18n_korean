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

return { one_per_level=true,
	{group="fareast-generic", percent_factor=1.5},
	{name="fell-aura", minor=true, percent=100, max_repeat=3},
	{name="spellblaze-scar", minor=true, percent=50},
	{name="glowing-chest", minor=true, percent=30},
	{name="sub-vault", minor=true, percent=100, max_repeat=rng.percent(33) and 1 or 0}, --33% chance of 2 vaults, 67% chance of 1 for each floor
}
