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

tm:fillAll()
-- rng.seed(2)

self:defineTile('@+', "SLIMED_DOOR")
self:defineTile('@#', "SLIMED_WALL")
self:defineTile('@"', "SLIMED_HARDWALL")
self:defineTile('@.', "SLIMED_FLOOR")
self:defineTile('"', "HARDWALL")
self:defineTile('t', "TRAINING_DUMMY")
self:defineTile('b', "FLOOR", nil, "ORC_ELITE_BERSERKER")
self:defineTile('f', "FLOOR", nil, "ORC_ELITE_FIGHTER")
self:defineTile("B", "FLOOR", nil, {random_filter={define_as="ORC_ELITE_BERSERKER", random_boss={name_scheme=_t"Combat Trainer #rng#", force_classes={Berserker=true}, nb_classes=1, class_filter=function(d) return d.name ~= "Berserker" end, loot_quality="store", loot_quantity=1, rank=3.5}}})
self:defineTile("F", "FLOOR", nil, {random_filter={define_as="ORC_ELITE_FIGHTER", random_boss={name_scheme=_t"Combat Trainer #rng#", force_classes={Bulwark=true}, nb_classes=1, class_filter=function(d) return d.name ~= "Bulwark" end, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, rank=3.5}}})
self:defineTile('>', "SLIME_TUNNELS", nil, nil, nil, {special="slimepit"})
self:defineTile(";", "UNDERGROUND_CREEP", nil, nil, nil, {special="slimepit"})
self:defineTile("s", "UNDERGROUND_CREEP", nil, {random_filter={special_rarity="slime_rarity"}}, nil, {special="slimepit"})
self:defineTile("S", "UNDERGROUND_CREEP", nil, {random_filter={special_rarity="slime_rarity", random_boss={force_classes={Oozemancer=true}, nb_classes=1, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=4}}}, nil, {special="slimepit"})

-- Make the barracks
local bsp = BSP.new(4, 4, 6):make(20, 39, '.', '#')
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
for _, edge in ipairs(bsp:mstEdges(3)) do
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

-- Ensure enough size
if tm:eliminateByFloodfill{'#', '"', 'T'} < 190 then return self:redo() end


-- Start a WFC for the slime pit while we do the rest
local wfcglade
while true do
	wfcglade = WaveFunctionCollapse.new{
		mode="overlapping", async=true,
		sample=self:getFile("!glade.tmx", "samples"),
		size={16, 16},
		n=2, symmetry=8, periodic_out=false, periodic_in=false, has_foundation=false
	}

	-- Finish slimepit and check its size
	wfcglade:waitCompute()
	wfcglade:carveBorder('T', wfcglade:point(1, 1), wfcglade.data_size)
	if wfcglade:eliminateByFloodfill{'T'} >= 25 then
		-- Find a 3x3 zone of floor to place exit in the middle
		local exit = wfcglade:findRandomArea(nil, nil, 3, 3, ';')
		if exit then
			wfcglade:carveArea('s', exit, exit+2)
			wfcglade:put(exit+1, '>')
			break
		end
	end
end

-- Turn one of the slimes into a boss
local slimeboss = wfcglade:locateTile('s')
wfcglade:put(slimeboss, 'S')

-- Some more random slime
for i = 1, 12 do
	local slime = wfcglade:locateTile(';')
	wfcglade:put(slime, 's')
end

-- Extract the group for the pit
local slimegroup = wfcglade:findGroupsOf{';'}
if #slimegroup ~= 1 then return self:redo() end -- Sanity; shouldnt happen
slimegroup = slimegroup[1]

-- Merge pit, and put trees around
tm:carveArea('T', tm:point(23, 4), tm:point(23, 4) + 18)
tm:merge(24, 5, wfcglade, {'T', ';', '>', 's', 'S'})

-- Move the slimegroup to the target area, sort it to find the lower point and use it as tunnel start
slimegroup:translate(tm:point(24, 5) - 1)
slimegroup:sortPoints(function(a, b)
	if a.x == b.x then return a.y > b.y
	else return a.x > b.x end
end)
local slime_entry = slimegroup.list[1]

local bspgroup = tm:findGroupsOf{'.', '+'}
if #bspgroup ~= 1 then return self:redo() end -- Sanity; shouldnt happen
bspgroup = bspgroup[1]
bspgroup:sortPoints(function(a, b)
	if a.x == b.x then return a.y > b.y
	else return a.x > b.x end
end)
local bsp_exit = bspgroup.list[1]

-- Tunnel to barracks
tm:tunnel(bsp_exit, tm:point(slime_entry.x, bsp_exit.y), ';', {'T', '"', '#', ';'}, {}, {tunnel_random=0})
tm:tunnel(tm:point(slime_entry.x, bsp_exit.y), slime_entry, ';', {'T', '"', '#', ';'}, {}, {tunnel_random=0})

-- Entry
bspgroup:sortPoints(function(a, b)
	if a.x == b.x then return a.y < b.y
	else return a.x < b.x end
end)
local entry = bspgroup.list[1]
tm:put(entry, '<')

-- Slime it up!
local replacer = { ['.'] = true, ['#'] = true, ['"'] = true, ['+'] = true }
for i = 1, tm.data_w do for j = 1, tm.data_h do
	if (i/tm.data_w) + (j/tm.data_h) > 0.8 then
		local p = tm:point(i, j)
		local g = tm:get(p)
		if replacer[g] then tm:put(p, "@"..g) end
	end
end end

tm:printResult()

return tm
