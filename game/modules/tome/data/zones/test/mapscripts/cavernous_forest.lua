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

-- rng.seed(2)

local tm = Tilemap.new(self.mapsize, '#')

local noise = Noise.new("simplex", 0.2, 4, 12, 1):make(50, 50, {'T', 'T', ';', ';', '=', '='})

-- Eliminate water ponds that are too small
noise:applyOnGroups(noise:findGroupsOf{'='}, function(room, idx)
	if #room.list < 18 then noise:fillGroup(room, ';') end
	-- room.map:carveArea('#', room.map:point(1, 1), room.map.data_size)
end)

-- MAKE MINIMUM SPANNING TREE A GENERIC ALGORITHM IN UTIL

tm:merge(1, 1, noise)

-- if tm:eliminateByFloodfill{'T','#'} < 800 then return self:regenerate() end

return tm
