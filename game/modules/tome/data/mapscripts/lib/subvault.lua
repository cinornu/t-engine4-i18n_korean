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

local map = args.map
local spot = args.spot
local char = args.char or '_HV_'..core.game.getTime()

local walltype = args.walltype or "HARDWALL"
local greater_vaults_list = args.greater_vaults_list

local basemap = table.clone(args.basemap or level.data.generator.map, true)
basemap.zoneclass = nil
basemap.rooms = nil
basemap.required_rooms = nil

local terrains = mod.class.Grid:loadList("/data/general/grids/basic.lua")
local g = game.state:dynamicZoneEntry(terrains.DOWN, "sub-vault", {
	name = ("Hidden Vault - %s"):tformat(zone.name),
	level_range = {zone:level_adjust_level(level, zone, "actor"), zone:level_adjust_level(level, zone, "actor")},
	level_scheme = "player",
	max_level = 1,
	__applied_difficulty = true, --Difficulty already applied to parent zone
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 50, height = 50,
	ambient_music = zone.ambient_music,
	persistent = "zone",
	min_material_level = util.getval(zone.min_material_level),
	max_material_level = util.getval(zone.max_material_level),
	no_worldport = zone.no_worldport,
	generator =  {
		map = table.merge(basemap, {
			class = "mod.class.generator.map.VaultLevel",
			subvault_wall = walltype,
			subvault_up = "DYNAMIC_ZONE_EXIT",
			greater_vaults_list = greater_vaults_list or nil,
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
	post_process = function(level)
		for uid, e in pairs(level.entities) do e.faction = e.hard_faction or "enemies" end
	end,
}, {
	npc_list = args.npc_list or {"/data/general/npcs/all.lua"},
	object_list = args.object_list or {"/data/general/objects/objects.lua"},
	grid_list = args.grid_list or {"/data/general/grids/basic.lua", "/data/general/grids/water.lua", "/data/general/grids/lava.lua"},
	trap_list = args.trap_list or {"/data/general/traps/complex.lua", "/data/general/traps/annoy.lua", "/data/general/traps/alarm.lua"},
},
function(zone, goback)
	goback(_t"stairs back to %s", zone.grid_list.UP)
end)

g.name = _t"hidden vault"
g.always_remember = true
g.desc = _t[[Crumbling stairs lead down to something.]]
g.show_tooltip = true
g.color_r=0 g.color_g=0 g.color_b=255 g.notice = true
g.special_minimap = colors.VIOLET
g._use_count = rng.range(2, 4)
g:altered()
g:initGlow()
g.change_level_check = function(self) -- limit stair scumming
	self._use_count = self._use_count - 1
	self.name = _t"collapsing hidden vault"
	if self._use_count < 1 then
		self.change_level_check = nil
		self.change_level = nil
		self.name = _t"collapsed hidden vault"
		self.desc = _t[[It is fully collapsed, no way down.]]
		game.log("#VIOLET# The stairway is about to collapses completely, you may still go back but it will be the last time!")
	elseif self._use_count < 2 then
		self.name = _t"nearly collapsed hidden vault"
		game.log("#VIOLET# The decrepit stairs crumble some more as you climb them.")
	end
	game:changeLevel(1, self:real_change(), {temporary_zone_shift=true, direct_switch=true})
	return true
end
game.zone:addEntity(game.level, g, "terrain", x, y)

self:defineTile(char, g)
if spot then map:put(spot, char) end

return g
