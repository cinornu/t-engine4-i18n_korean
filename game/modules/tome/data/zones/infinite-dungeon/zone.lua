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

local rooms = {"random_room", {"pit",3}, {"greater_vault",7}}
if game:isAddonActive("items-vault") then table.insert(rooms, {"!items-vault",5}) end

return {
	name = _t"Infinite Dungeon",
	level_range = {1, 1},
	level_scheme = "player",
	max_level = 1000000000,
	actor_adjust_level = function(zone, level, e) return math.floor((zone.base_level + level.level-1) * 1.2) + e:getRankLevelAdjust() + rng.range(-1,2) end,
	width = 70, height = 70,
--	all_remembered = true,
--	all_lited = true,
	no_worldport = true,
	infinite_dungeon = true,
	events_by_level = true,
	special_level_faction = "enemies",
	ambient_music = function() return rng.table{
		"Battle Against Time.ogg",
		"Breaking the siege.ogg",
		"Broken.ogg",
		"Challenge.ogg",
		"Driving the Top Down.ogg",
		"Enemy at the gates.ogg",
		"Hold the Line.ogg",
		"Kneel.ogg",
		"March.ogg",
		"Mystery.ogg",
		"Rain of Blood.ogg",
		"Sinestra.ogg",
		"Straight Into Ambush.ogg",
		"Suspicion.ogg",
		"Swashing the buck.ogg",
		"Taking flight.ogg",
		"Thrall's Theme.ogg",
		"Through the Dark Portal.ogg",
		"Together We Are Strong.ogg",
		"Treason.ogg",
		"Valve.ogg",
		"Zangarang.ogg",
	} end,
	generator =  {
		map = {
			class = "engine.generator.map.Roomer",
			nb_rooms = 14,
			rooms = rooms,
			rooms_config = {pit={filters={}}},
			lite_room_chance = 50,
			['.'] = "FLOOR",
			['#'] = "WALL",
			['+'] = "DOOR",
			I = "ITEMS_VAULT",
			up = "FLOOR",
			down = "DOWN",
			door = "DOOR",
		},
		actor = {
			class = "mod.class.generator.actor.RandomStairGuard",
			guard_test = function(level) -- periodic chance to place a stair guard after level 4, guaranteed for levels 30+
				if level.level >= 30 then return true, 100
				elseif level.level >= 5 then
					local chance = (level.level - 5)*2
					chance = chance + 25*(1 + math.cos(2*(level.level - 5)))
					return rng.percent(chance), chance
				end
			end,
			guard = {
				{random_boss={rank = 3.5, loot_quantity = 3,}},
			},
			nb_npc = {29, 39},
			filters = { {max_ood=6}, },
		},
		object = {
			class = "engine.generator.object.Random",
			nb_object = {6, 9},
		},
		trap = {
			class = "engine.generator.trap.Random",
			nb_trap = {0, 0},
		},
	},
	alter_level_data = function(zone, lev, data)
		
		-- Randomize the size of the dungeon, increasing it slightly as the game progresses.
		local size = 60 + math.floor(30*lev/(lev + 50)) -- from 60 to 90, 70 @ level 25, 75 @ level 50
		local vx = math.ceil(rng.float(0.6, 1.4)*size) -- from 36 to 126
		local vy = math.ceil(size*size/vx) -- Adjust for vx so that total area scales up smoothly with size(level)
		
		-- Similar to random zone generation, with modifications
		-- Define standard floor layouts:
		local layouts = {
			{	id_layout_name = "default",
				desc = _t", carefully excavated area",
				class = "engine.generator.map.Roomer",
				nb_rooms = 4 + math.ceil(vx * vy * 10/4900), -- 12 @ 60x60, 14 @ 70x70, 21 @ 90x90
				rooms = {"random_room", {"pit",3}, {"greater_vault",7}},
				rooms_config = {pit={filters={}}},
				lite_room_chance = 50,
			},
			{	id_layout_name = "forest",
				desc = _t" wilderness", 
				class = "engine.generator.map.Forest",
				edge_entrances = rng.table{{2,8}, {4,6}, {6,4}, {8,2}},
				zoom = rng.range(2,6),
				sqrt_percent = rng.range(30, 50),
				sqrt_percent = rng.range(5, 10),
				noise = "fbm_perlin",
				nb_rooms = math.random(1, math.ceil(vx*vy/2000)), -- max 2 @ 50x50, 3 @ 64x64, 4 @ 78x78
				rooms = {"forest_clearing", {"lesser_vault", math.floor(40/lev)}, "greater_vault"},
				rooms_config = {forest_clearing={pit_chance=util.bound(lev, 10, 50), filters={{special=function(e) return e.rank <= 3 end}}}},
				enemy_count = math.ceil(vx * vy *40/4900) -- more room for enemies and more cover on this map: avg: 30 @ 60x60, 40 @ 70x70, 67 @ 90x90
			},
			{	id_layout_name = "cavern",
				desc = _t" cavern",
				class = "engine.generator.map.Cavern",
				zoom = math.random(12, 20),
				min_floor = math.floor(rng.range(vx * vy * 0.4 / 2, vx * vy * 0.4)),
			},
			{	id_layout_name = "maze",
				desc = _t" network of corridors",
				class = "engine.generator.map.Maze",
				widen_w = util.bound(rng.normal(2, 2), 1, 7),
				widen_h = util.bound(rng.normal(2, 2), 1, 7),
			},
			{	id_layout_name = "town",
				desc = _t", settled area",
				class = "engine.generator.map.Town",
				building_chance = math.random(50,90),
				max_building_w = math.random(6,11), max_building_h = math.random(6,11),
				edge_entrances = {6,4},
				nb_rooms = math.random(1,2),
				rooms = {"forest_clearing", {"lesser_vault", math.floor(40/lev)}, {"greater_vault", 2*lev}},
				rooms_config = {forest_clearing={pit_chance=util.bound(lev, 10, 50), filters={{special=function(e) return e.rank <= 3 end}}}},
			},
			{	id_layout_name = "building",
				desc = _t", constructed area",
				class = "engine.generator.map.Building",
				nb_rooms = math.random(0, math.ceil(vx*vy/2000)),
				rooms = {{"lesser_vault", math.floor(40/lev)}, "greater_vault"},
				lite_room_chance = rng.range(0, 100),
				max_block_w = rng.range(7, 20), max_block_h = rng.range(7, 20),
				max_building_w = rng.range(4, size/6), max_building_h = rng.range(4, size/6),
				enemy_count = math.ceil(vx * vy *60/4900) -- more room for enemies and more cover on this map: avg: 44 @ 60x60, 60 @ 70x70, 99 @ 90x90
			},
			{	id_layout_name = "octopus",
				desc = _t", subsided area",
				class = "engine.generator.map.Octopus",
				main_radius = {0.25, 0.35},
				arms_radius = {0.1, 0.2},
				arms_range = {0.7, 0.8},
				nb_rooms = {5, 10},
			},
			{	id_layout_name = "hexa",
				desc = _t", geometrically ordered area",
				class = "engine.generator.map.Hexacle",
				segment_wide_chance = 70,
				nb_segments = 8,
				nb_layers = 6,
				segment_miss_percent = 10,
				force_square_size = true,
			},
		}
		-- update for additional layouts 
		zone:triggerHook{"InfiniteDungeon:getLayouts", lev=lev, layouts=layouts, size=size, vx=vx, vy=vy}

		-- define additional grid sets:
		local vgrids = {
			{id_grids_name="default", floor="FLOOR", wall="WALL", door="DOOR", down="DOWN", desc=_t"hewn"},
			{id_grids_name="tree", floor="GRASS", wall="TREE", door="GRASS_ROCK", down="GRASS_DOWN2", desc=_t"sylvan"},
			{id_grids_name="underground", floor="UNDERGROUND_FLOOR", wall="UNDERGROUND_TREE", door="UNDERGROUND_ROCK", down="UNDERGROUND_LADDER_DOWN", desc=_t"subterranean"},
			{id_grids_name="crystals", floor="CRYSTAL_FLOOR", wall={"CRYSTAL_WALL","CRYSTAL_WALL2","CRYSTAL_WALL3","CRYSTAL_WALL4","CRYSTAL_WALL5","CRYSTAL_WALL6","CRYSTAL_WALL7","CRYSTAL_WALL8","CRYSTAL_WALL9","CRYSTAL_WALL10","CRYSTAL_WALL11","CRYSTAL_WALL12","CRYSTAL_WALL13","CRYSTAL_WALL14","CRYSTAL_WALL15","CRYSTAL_WALL16","CRYSTAL_WALL17","CRYSTAL_WALL18","CRYSTAL_WALL19","CRYSTAL_WALL20",}, door="CRYSTAL_ROCK", down="CRYSTAL_LADDER_DOWN", desc=_t"crystalline"},
			{id_grids_name="sand", floor="UNDERGROUND_SAND", wall="SANDWALL", door="SAND_ROCK", down="SAND_LADDER_DOWN", desc=_t"sandy"},
			{id_grids_name="desert", floor="SAND", wall="PALMTREE", door="DESERT_ROCK", down="SAND_DOWN2", desc=_t"arrid"},
			{id_grids_name="slime", floor="SLIME_FLOOR", wall="SLIME_WALL", door="SLIME_DOOR", down="SLIME_DOWN", desc=_t"slimey"},
			{id_grids_name="jungle", floor="JUNGLE_GRASS", wall="JUNGLE_TREE", door="JUNGLE_ROCK", down="JUNGLE_GRASS_DOWN2", desc=_t"humid, tropical"},
			{id_grids_name="cave", floor="CAVEFLOOR", wall="CAVEWALL", door="CAVE_ROCK", down="CAVE_LADDER_DOWN", desc=_t"unhewn"},
			{id_grids_name="burntland", floor="BURNT_GROUND", wall="BURNT_TREE", door="BURNT_DOOR", down="BURNT_DOWN6", desc=_t"burned"},
			{id_grids_name="mountain", floor="ROCKY_GROUND", wall="MOUNTAIN_WALL", door="DOOR", down="ROCKY_DOWN2", desc=_t"mountainous"},
			{id_grids_name="mountain_forest", floor="ROCKY_GROUND", wall="ROCKY_SNOWY_TREE", door="ROCKY_SNOWY_DOOR", down="ROCKY_DOWN2", desc=_t"alpine"},
			{id_grids_name="snowy_forest", floor="SNOWY_GRASS_2", wall="SNOWY_TREE_2", door="SNOWY_DOOR", down="snowy_DOWN2", desc=_t"cold, wooded"},
			{id_grids_name="temporal_void", floor="VOID", wall="SPACETIME_RIFT2", door="VOID", down="RIFT2", desc=_t"empty"},
			{id_grids_name="water", floor="WATER_FLOOR_FAKE", wall="WATER_WALL_FAKE", door="WATER_DOOR_FAKE", down="WATER_DOWN_FAKE", desc=_t"flooded"},
			{id_grids_name="lava", floor="LAVA_FLOOR_FAKE", wall="LAVA_WALL_FAKE", door="LAVA_ROCK", down="LAVA_DOWN_FAKE", desc=_t"molten"},
			{id_grids_name="autumn_forest", floor="AUTUMN_GRASS", wall="AUTUMN_TREE", door="AUTUMN_ROCK", down="AUTUMN_GRASS_DOWN2", desc=_t"temperate"},
		}
		zone:triggerHook{"InfiniteDungeon:getGrids", grids=vgrids}
		
		-- select layout and grids for the level from those set previously (default 1)
		local layoutN = ((zone.layoutN or 1) - 1)%#layouts + 1
		local vgridN = ((zone.vgridN or 1) - 1)%#vgrids + 1
		layout = layouts[layoutN]
		vgrid = vgrids[vgridN]
		print("[Infinite Dungeon] using zone layout #", layoutN, layout.id_layout_name) table.print(layout, "\t")
		print("[Infinite Dungeon] using variable grid set #", vgridN, vgrid.id_grids_name) table.print(vgrid, "\t")

		if layout.rooms and game:isAddonActive("items-vault") then table.insert(layout.rooms, {"!items-vault",3}) end
		
		data.generator.map = layout
		
		-- set up exit properties (to be finished post_process)
		data.alternate_exit = {}
		for i = 1, 2 do
			layoutN = rng.normal(layoutN + 1, 2)%#layouts + 1  --statistically rotate through all sets
			vgridN = rng.normal(vgridN + 1, 2)%#vgrids + 1
			data.alternate_exit[i] = {layoutN=layoutN, layout=layouts[layoutN], vgridN=vgridN, grids=vgrids[vgridN]}
--			print("[Infinite Dungeon] Exit", i, "layout:", layoutN, layouts[layoutN].id_layout_name, "grids:",vgridN, vgrids[vgridN].id_grids_name)
		end

		-- adjust map size for certain layouts
		if layout.id_layout_name == "maze" then -- make map dimensions an even multiple of corridor width/height
			vx = math.round(vx, data.generator.map.widen_w)
			vy = math.round(vy, data.generator.map.widen_h)
		end
		if layout.force_square_size then
			vx = math.max(vx, vy)
			vy = vx
		end
		
		data.generator.map.id_grids_name = vgrid.id_grids_name
		data.generator.map.floor = vgrid.floor
		data.generator.map['.'] = vgrid.floor
		data.generator.map.external_floor = vgrid.external_floor or layout.external_floor or vgrid.floor
		data.generator.map.outside_floor = vgrid.outside_floor or layout.outside_floor or vgrid.floor
		data.generator.map.wall = vgrid.wall
		data.generator.map['#'] = vgrid.wall
		data.generator.map.up = vgrid.floor
--		data.generator.map.down = vgrid.down
		data.generator.map.down = data.alternate_exit[1].grids.down -- exit matches destination
		data.generator.map.door = vgrid.door
		data.generator.map["'"] = vgrid.door
		data.generator.map.I = "ITEMS_VAULT"

		data.width, data.height = vx, vy
		data.generator.map.width, data.generator.map.height = vx, vy

		-- Scale enemy count according to map or with map area
		local enemy_count = layout.enemy_count or math.ceil(vx * vy *34/4900) -- avg: 25 @ 60x60, 34 @ 70x70, 57 @ 90x90
		data.generator.actor.nb_npc = {enemy_count-5, enemy_count+5}
		print(("[Infinite Dungeon] alter_level_data: (%dw, %dh) %s rooms, %d enemies, layout:%s, grids:%s"):format(vx, vy, layout.nb_rooms, enemy_count, data.generator.map.id_layout_name, data.generator.map.id_grids_name))
		game.state:infiniteDungeonChallenge(zone, lev, data, data.generator.map.id_layout_name, vgrid.id_grids_name)
	end,
	post_process = function(level, zone)
		-- Provide some achievements
		if level.level == 10 then world:gainAchievement("INFINITE_X10", game.player)
		elseif level.level == 20 then world:gainAchievement("INFINITE_X20", game.player)
		elseif level.level == 30 then world:gainAchievement("INFINITE_X30", game.player)
		elseif level.level == 40 then world:gainAchievement("INFINITE_X40", game.player)
		elseif level.level == 50 then world:gainAchievement("INFINITE_X50", game.player)
		elseif level.level == 60 then world:gainAchievement("INFINITE_X60", game.player)
		elseif level.level == 70 then world:gainAchievement("INFINITE_X70", game.player)
		elseif level.level == 80 then world:gainAchievement("INFINITE_X80", game.player)
		elseif level.level == 90 then world:gainAchievement("INFINITE_X90", game.player)
		elseif level.level == 100 then world:gainAchievement("INFINITE_X100", game.player)
		elseif level.level == 150 then world:gainAchievement("INFINITE_X150", game.player)
		elseif level.level == 200 then world:gainAchievement("INFINITE_X200", game.player)
		elseif level.level == 300 then world:gainAchievement("INFINITE_X300", game.player)
		elseif level.level == 400 then world:gainAchievement("INFINITE_X400", game.player)
		elseif level.level == 500 then world:gainAchievement("INFINITE_X500", game.player)
		end

		-- update the exit(s) to reflect their destinations
		if level.data.alternate_exit then
			local marker = mod.class.Grid.new{z=5,image = "terrain/farportal-black-vortex.png", display_x=-0.25, display_y=-0.25, display_w=1.5, display_h=1.5}
			for i = 1, #level.data.alternate_exit do
				local ae = level.data.alternate_exit[i]
				local ex, x, y
				if i == 1 then -- update the main exit
					x, y = level.default_down.x, level.default_down.y
					ex = level.map(x, y, engine.Map.TERRAIN)
				else -- create an alternate exit
					ex = zone.grid_list[ae.grids.down]
					-- find a place for the alternate exit, not too close to the main exit or the player start
					x, y = game.state:findEventGrid(level, function(self, level, x, y)
							local min_dist = math.max(level.map.w, level.map.h)/4
							return not level.map(x, y, engine.Map.ACTOR) and not level.map.room_map[x][y].special and core.fov.distance(x, y, level.default_down.x, level.default_down.y) > min_dist and core.fov.distance(x, y, level.default_up.x, level.default_up.y) > min_dist and self:canEventGrid(level, x, y)
						end
					)
					if x and y then -- possibly place an additional stair guard
						-- from mod.class.generator.actor.RandomStairGuard
						local data = level.data.generator.actor
						if data.guard and (not data.guard_test or data.guard_test(level)) then
							local m = zone:makeEntity(level, "actor", rng.table(data.guard), nil, true)
							if m then
								zone:addEntity(level, m, "actor", x, y)
								print("[Infinite Dungeon] placed (additional) stair guard", m.name, "at", x, y)
							end
						end
					end
				end
				
				if x and y and ex and ex.change_level then -- update the exit tile
					ex = ex:clone()
					ex.show_tooltip = true
					ex.desc = (ex.desc or "")..("\nEncroaching terrain:\n%s%s"):tformat(ae.grids.desc or _t"indistinct", ae.layout.desc or _t"continuation of the Infinite Dungeon")
					-- make sure the exit is clearly marked (in case the nice tiler hides it)
					if ex.add_displays then -- migrate graphics up, but below actor and nice tiler 3d z levels
						for i, d in ipairs(ex.add_displays) do
							d.z = math.min(9, (d.z or 0) + 6)
						end
					else ex.add_displays = {}
					end
					ex.add_displays[#ex.add_displays+1] = marker -- add extra marker just in case
					ex.layoutN, ex.vgridN = ae.layoutN, ae.vgridN
					ex.change_level_check = function(self, player)
						game.zone.layoutN = self.layoutN
						game.zone.vgridN = self.vgridN
					end
					zone:addEntity(level, ex, "terrain", x, y)
					level.spots[#level.spots+1] = {x=x, y=y, check_connectivity="exit"}
					print("[Infinite Dungeon] Added/updated Exit#", i, x, y, "layout:", ex.layoutN, ae.layout.id_layout_name, "grids:",ex.vgridN, ae.grids.id_grids_name)
				end
			end
		end
		
		-- Everything hates you in the infinite dungeon!
		for uid, e in pairs(level.entities) do e.faction = e.hard_faction or zone.special_level_faction or "enemies" end
		
		-- Some lore
		if level.level == 1 or level.level == 10 or level.level == 20 or level.level == 30 or level.level == 40 then
			local l = zone:makeEntityByName(level, "object", "ID_HISTORY"..level.level)
			if l then
				for _, coord in pairs(util.adjacentCoords(level.default_up.x, level.default_up.y)) do
					if game.level.map:isBound(coord[1], coord[2]) and (i ~= 0 or j ~= 0) and not game.level.map:checkEntity(coord[1], coord[2], engine.Map.TERRAIN, "block_move") then
						zone:addEntity(level, l, "object", coord[1], coord[2])
						break
					end
				end
			end
		end

		-- Give some random auras
		if level.level >= 5 and rng.percent(level.level * 4) then
			local p = game.player
			local effid = rng.table{
				p.EFF_ZONE_AURA_FIRE, p.EFF_ZONE_AURA_COLD, p.EFF_ZONE_AURA_LIGHTNING, p.EFF_ZONE_AURA_ACID,
				p.EFF_ZONE_AURA_DARKNESS, p.EFF_ZONE_AURA_MIND, p.EFF_ZONE_AURA_LIGHT, p.EFF_ZONE_AURA_ARCANE,
				p.EFF_ZONE_AURA_TEMPORAL, p.EFF_ZONE_AURA_PHYSICAL, p.EFF_ZONE_AURA_BLIGHT, p.EFF_ZONE_AURA_NATURE,
				p.EFF_ZONE_AURA_GORBAT, p.EFF_ZONE_AURA_VOR, p.EFF_ZONE_AURA_GRUSHNAK, p.EFF_ZONE_AURA_RAKSHOR,
				p.EFF_ZONE_AURA_OUT_OF_TIME, p.EFF_ZONE_AURA_THUNDERSTORM, 
			}
			level.data.effects = {effid}
		end

		if config.settings.cheat then -- gather statistics
			local block_count = 0
			for i = 0, level.map.w - 1 do for j = 0, level.map.h - 1 do
				if level.map:checkEntity(i, j, engine.Map.TERRAIN, "block_move") then block_count = block_count + 1 end
			end end
			local closed = 100*block_count/(level.map.w*level.map.h) local open = 100-closed
			print(("[Infinite Dungeon] Open space calculation: (%s, %s, %dw x %dh) space -- (open:%2.1f%%, closed:%2.1f%%)"):format(level.data.id_layout_name, level.data.id_grids_name, level.map.w, level.map.h, open, closed))
		end
	end,
	post_process_end = function(level, zone)
		-- We delay it because at "post_process" the map can STILL decide to regenerate
		-- and if it does, it's a new level and challenge is considered auto failed (or auto success heh)
		game.state:infiniteDungeonChallengeFinish(zone, level)
	end,
}

