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

return {
	name = _t"Vor Pride",
	level_range = {35, 60},
	level_scheme = "player",
	max_level = 3,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 48, height = 48,
	persistent = "zone",
	-- all_remembered = true,
	all_lited = true,
	day_night = true,
	ambient_music = "Breaking the siege.ogg",
	min_material_level = 4,
	max_material_level = 5,
	effects = {"EFF_ZONE_AURA_VOR"},
	generator =  {
		map = {
			class = "engine.generator.map.MapScript",
			['<'] = "GOTHIC_FLAT_UP6", ['>'] = "GOTHIC_FLAT_DOWN4",
			['.'] = "GOTHIC_FLOOR", ['+'] = "GOTHIC_DOOR", ['#'] = "GOTHIC_WALL",
			['_'] = "GOTHIC_FLOOR", ['O'] = "GOTHIC_WALL", 
			[';'] = "BURNT_GROUND", ['T'] = "BURNT_TREE",
			['='] = "DEEP_WATER",
			door = "GOTHIC_DOOR",
			mapscript = "!main",
			pride = "vor",
		},
		actor = {
			class = "mod.class.generator.actor.Random",
			nb_npc = {35, 40},
			guardian = "VOR",
		},
		object = {
			class = "engine.generator.object.Random",
			nb_object = {3, 6},
		},
	},
	post_process = function(level)
		-- Place a lore note on each level
		game:placeRandomLoreObjectScale("ORC_HISTORY", 5, level.level)

		for uid, e in pairs(level.entities) do e.faction = e.hard_faction or "orc-pride" end
	end,
	levels =
	{
		[1] = {
			generator = { map = {
				['<'] = "GOTHIC_FLAT_UP_WILDERNESS",
			}, },
		},
	},
}
