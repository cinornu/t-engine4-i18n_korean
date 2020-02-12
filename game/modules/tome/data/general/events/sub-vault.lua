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

-- Find a random spot
local x, y
local spot = level:pickSpotRemove{type="event-spot", subtype="subvault-place"}
if spot then x, y = spot.x, spot.y
else x, y = game.state:findEventGrid(level) end
if not x then return false end
local id = "sub-vault"..game.turn.."-"..rng.range(1,9999)
print("[EVENT] Placing event", id, "at", x, y)

local changer = function(id)
	local grid_list = table.clone(game.zone.grid_list)
	grid_list.__loaded_files = table.clone(grid_list.__loaded_files, true) -- Separate full cloning to not alter the base
	grid_list.ignore_loaded = true
	mod.class.Grid:loadList({"/data/general/grids/basic.lua", "/data/general/grids/water.lua", "/data/general/grids/lava.lua"}, nil, grid_list, nil, grid_list.__loaded_files)
	local npc_list = table.clone(game.zone.npc_list)
	npc_list.__loaded_files = table.clone(npc_list.__loaded_files, true) -- Separate full cloning to not alter the base
	npc_list.ignore_loaded = true
	mod.class.NPC:loadList("/data/general/npcs/all.lua", nil, npc_list, function(e) if e.rarity then e.rarity = math.ceil(e.rarity * 35 + 4) end end, npc_list.__loaded_files)

	local walltype = "HARDWALL"
	if game.level.data.generator and game.level.data.generator.map and game.level.data.generator.map.subvault_exterior_wall then walltype = game.level.data.generator.map.subvault_exterior_wall end
	-- if game.level.data.generator and game.level.data.generator.map and game.level.data.generator.map.wall then walltype = game.level.data.generator.map.wall end
	-- if game.level.data.generator and game.level.data.generator.map and game.level.data.generator.map['#'] then walltype = game.level.data.generator.map['#'] end

	local uptype = "UP"
	grid_list.UP_SUB_VAULT_BACK = grid_list[uptype]:cloneFull()
	grid_list.UP_SUB_VAULT_BACK.change_level_shift_back = true
	grid_list.UP_SUB_VAULT_BACK.change_zone_auto_stairs = true

	grid_list.UP_SUB_VAULT_BACK.name = ("way up (%s)"):tformat(game.zone.name)
	grid_list.UP_SUB_VAULT_BACK.change_level_check = function(self)
		if not self.change_level then
			game.log("#VIOLET# The stairway collapses completely as you ascend!")
		else
			game.log("#VIOLET# The decrepit stairs crumble some more as you climb them.")
		end
		return
	end
	grid_list.UP_SUB_VAULT_BACK.nicer_tiles = nil
	grid_list.UP_SUB_VAULT_BACK.nice_editer = nil
	grid_list.UP_SUB_VAULT_BACK.nice_editer2 = nil
	
	local basemap = table.clone(game.level.data.generator.map, true)
	basemap.zoneclass = nil
	basemap.rooms = nil
	basemap.required_rooms = nil

	local zone = mod.class.Zone.new(id, {
		name = ("Hidden Vault - %s"):tformat(game.old_zone_name or "???"),
		level_range = {game.zone:level_adjust_level(game.level, game.zone, "actor"), game.zone:level_adjust_level(game.level, game.zone, "actor")},
		level_scheme = "player",
		max_level = 1,
		__applied_difficulty = true, --Difficulty already applied to parent zone
		actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
		width = 50, height = 50,
		ambient_music = game.zone.ambient_music,
		reload_lists = false,
		persistent = "zone",
--		_max_level_generation_count = 5,
		min_material_level = util.getval(game.zone.min_material_level),
		max_material_level = util.getval(game.zone.max_material_level),
		no_worldport = game.zone.no_worldport,
		generator =  {
			map = table.merge(basemap, {
				class = "mod.class.generator.map.VaultLevel",
				subvault_wall = walltype,
				subvault_up = "UP_SUB_VAULT_BACK",
				greater_vaults_list = game.level.data.generator.map.greater_vaults_list or nil,
				entry_path_length = 10, -- path from level entrance to vault (affects space to fight when opening the vault)
			}),
			actor = {
				class = "mod.class.generator.actor.Random",
				nb_npc = {0, 0},
			},
			object = {
				class = "engine.generator.object.Random",
				nb_object = {0, 0},
			},
			trap = {
				class = "engine.generator.trap.Random",
				nb_trap = {0, 0},
			},
		},
		npc_list = npc_list,
		grid_list = grid_list,
		object_list = table.clone(game.zone.object_list, false),
		trap_list = table.clone(game.zone.trap_list, false),
		post_process = function(level)
			for uid, e in pairs(level.entities) do e.faction = e.hard_faction or "enemies" end
		end,
	})
	return zone
end

local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
g.name = _t"hidden vault"
g.always_remember = true
g.desc = _t[[Crumbling stairs lead down to something.]]
g.show_tooltip = true
g.display='>' g.color_r=0 g.color_g=0 g.color_b=255 g.notice = true
g.special_minimap = colors.VIOLET
g.change_level=1 g.change_zone=id g.glow=true
g:removeAllMOs()
if engine.Map.tiles.nicer_tiles then
	g.add_displays = g.add_displays or {}
	g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/stair_down.png", z=5}
end
g._use_count = rng.range(2, 4)
g:altered()
g:initGlow()
g.real_change = changer
g.change_level_check = function(self) -- limit stair scumming
	self._use_count = self._use_count - 1
	self.name = _t"collapsing hidden vault"
	if self._use_count < 1 then
		self.change_level_check = nil
		self.change_level = nil
		self.name = _t"collapsed hidden vault"
		self.desc = _t[[A collapsed stairway, leading down]]
	elseif self._use_count < 2 then
		self.name = _t"nearly collapsed hidden vault"
	end
	game:changeLevel(1, self.real_change(self.change_zone), {temporary_zone_shift=true, direct_switch=true})
	return true
end
game.zone:addEntity(game.level, g, "terrain", x, y)

return x, y
