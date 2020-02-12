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
	{group="majeyal-generic", percent_factor=0.5},
	{name="cultists", percent=5, level_range={15,nil}},
	{name="icy-ground", minor=true, percent=20},
	{name="font-life", minor=true, percent=20},
	{name="whistling-vortex", minor=true, percent=20},
	{name="antimagic-bush", minor=true, percent=20},
	{name="bligthed-soil", minor=true, percent=20},
	{name="fell-aura", minor=true, percent=20},
	{name="glimmerstone", minor=true, percent=20},
	{name="necrotic-air", minor=true, percent=20},
	{name="protective-aura", minor=true, percent=20},
	{name="spellblaze-scar", minor=true, percent=20},
	{name="glowing-chest", minor=true, percent=30},

	{name="rat-lich", percent=5, level_range={2,20}, unique=true},
	{name="old-battle-field", percent=5, level_range={8,40}},
	{name="damp-cave", percent=5, level_range={2,20}},
	{name="drake-cave", percent=5, level_range={10,nil}},
	{name="fearscape-portal", percent=5, level_range={18,nil}},
	{name="naga-portal", percent=5, level_range={15,nil}},

}
