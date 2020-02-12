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

tm:fillAll('"')

self:defineTile('"', "HARDWALL")
self:defineTile('t', "TRAINING_DUMMY")
self:defineTile('b', "FLOOR", nil, "ORC_ELITE_BERSERKER")
self:defineTile('f', "FLOOR", nil, "ORC_ELITE_FIGHTER")
self:defineTile("B", "FLOOR", nil, {random_filter={define_as="ORC_ELITE_BERSERKER", random_boss={name_scheme=_t"Combat Trainer #rng#", force_classes={Berserker=true}, nb_classes=1, class_filter=function(d) return d.name ~= "Berserker" end, loot_quality="store", loot_quantity=1, rank=3.5}}})
self:defineTile("F", "FLOOR", nil, {random_filter={define_as="ORC_ELITE_FIGHTER", random_boss={name_scheme=_t"Combat Trainer #rng#", force_classes={Bulwark=true}, nb_classes=1, class_filter=function(d) return d.name ~= "Bulwark" end, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, rank=3.5}}})

-- Make the barracks
local bsp = BSP.new(5, 5, 6):make(30, 30, '.', '#')
tm:merge(2, 2, bsp)

-- Remove a few rooms
for _, room in ripairs(bsp.rooms) do
	if rng.percent(25) then
		bsp:removeRoom(room)
		local from, to = room:bounds()
		tm:carveArea('#', from, to)
	end
end

-- Connect them
for _, edge in ipairs(bsp:mstEdges(1)) do
	local points = edge.points
	tm:put(rng.table(points), '+')
end

tm:applyOnGroups(bsp.rooms, function(room, idx)
	local map = room:submap(tm)
	if (idx == 1 or rng.percent(15)) and map.data_w > 2 and map.data_h > 2 then
		-- Place some training dummies
		if map.data_w > map.data_h then
			local hdummies = math.floor(map.data_h / 2) + 1
			for i = 2, map.data_w - 1 do
				if map.data_h % 2 == 0 then map:put(map:point(i, hdummies-1), 't') end
				map:put(map:point(i, hdummies), 't')
			end
		else
			local wdummies = math.floor(map.data_w / 2) + 1
			for j = 2, map.data_h - 1 do
				if map.data_w % 2 == 0 then map:put(map:point(wdummies-1, j), 't') end
				map:put(map:point(wdummies, j), 't')
			end
		end

		-- Place some trainer and trainees
		local trainer = map:locateTile('.')
		if trainer then
			local kind = rng.percent(50) and 'B' or 'F'
			map:put(trainer, kind)
			for i = 1, rng.range(3, 8) do
				local mook = map:locateTile('.')
				if mook then map:put(mook, kind:lower()) end
			end
		end
	end
end, true)

if rng.percent(22) and not game.state:doneEvent("grushnak-armory") then 
	game.state:doneEvent("grushnak-armory",1) -- special vault! can only show once per game and only in grushnak pride; contains exceptionally difficult foes and exceptional loot
	game.level.data.generator.map.greater_vaults_list = {"grushnak-armory"}
end

-- Ensure enough size
if tm:eliminateByFloodfill{'#', '"', 'T'} < 350 then return self:redo() end

local entry = tm:locateTile('.')
if not entry then return self:redo() else tm:put(entry, '<') end
local exit = tm:locateTile('.')
if not exit then return self:redo() else tm:put(exit, '>') end

tm:printResult()

return tm
