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
tm:erase('#')

-- self.data.greater_vaults_list = {"32-chambers"}
local sroom_factory = Rooms.new(self, "simple")
local rroom_factory = Rooms.new(self, "random_room")
local vault_factory = Rooms.new(self, "lesser_vault")

local bp = tm:binpack()
local nb_vault = 1
local nb_rooms = 0
while true do
	local proom
	if nb_rooms < 15 then proom = (nb_vault > 0 and vault_factory or (rng.percent(50) and sroom_factory or rroom_factory)):generateRoom()
	else break
	-- else proom = Tilemap.new({rng.range(3, 7), rng.range(3, 7)}, '#') proom.do_not_connect = true
	end
	if proom then
		nb_rooms = nb_rooms + 1
		nb_vault = nb_vault - 1
		if not bp:add(proom):resolve() then break end
	end
end
bp:compute("random")
bp:merge()
game.log("!!! %d + %d", #bp:getMerged(), #bp:getNotMerged())
if not loadMapScript("lib/connect_rooms_multi", {map=tm, rooms=bp:getMerged(), door_chance=60, edges_surplus=3, erraticness=1}) then return self:redo() end


tm:printResult()

return tm
