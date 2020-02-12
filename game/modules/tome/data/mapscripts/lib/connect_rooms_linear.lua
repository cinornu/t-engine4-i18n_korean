-- TE4 - T-Engine 4
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

local map = args.map
local rooms = map:sortListCenter(args.rooms)

local full = true
for i, room in ipairs(rooms) do
	if i > 1 then
		local proom = rooms[i-1]
		local pos1, kind1 = proom:findRandomClosestExit(7, room:centerPoint(), nil, args.exitable_chars or {'.', ';', '='})
		local pos2, kind2 = room:findRandomClosestExit(7, proom:centerPoint(), nil, args.exitable_chars or {'.', ';', '='})
		if pos1 and pos2 then
			map:tunnelAStar(pos1, pos2, args.tunnel_char or '.', args.tunnel_through or {'#'}, args.tunnel_avoid or nil, {erraticness=args.erraticness or 5})
			if kind1 == 'open' then map:smartDoor(pos1, args.door_chance or 40, '+') end
			if kind2 == 'open' then map:smartDoor(pos2, args.door_chance or 40, '+') end
		else
			full = false
		end

	end
	-- map:carveArea(string.char(string.byte('0')+i-1), room.merged_pos, room.merged_pos + room.data_size - 1)
end

return full
