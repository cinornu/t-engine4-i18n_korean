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
	name = _t"Gorbat Pride",
	level_range = {35, 60},
	level_scheme = "player",
	max_level = 3,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 50, height = 40,
	persistent = "zone",
--	all_remembered = true,
	all_lited = true,
	day_night = true,
	ambient_music = {"Breaking the siege.ogg", "weather/desert_base.ogg"},
	min_material_level = 4,
	max_material_level = 5,
	effects = {"EFF_ZONE_AURA_GORBAT"},
	generator =  {
		map = {
			class = "engine.generator.map.MapScript",
			['<'] = "FLAT_UP6", ['>'] = "FLAT_DOWN4",
			['.'] = "FLOOR", ['+'] = "DOOR", ['#'] = "HARDMOUNTAIN_WALL",
			['_'] = "SAND",
			[';'] = "SAND", 
			['^'] = "MOUNTAIN_WALL",
			['='] = "DEEP_WATER",
			door = "DOOR",
			mapscript = "!main",
			pride = "gorbat",
		},
		actor = {
			class = "mod.class.generator.actor.Random",
			nb_npc = {35, 40},
			filters = { {type="humanoid", subtype="orc"}, {type="humanoid", subtype="orc"}, {type="humanoid", subtype="orc"}, {type="humanoid", subtype="orc"}, {}, },
			guardian = "GORBAT",
		},
		object = {
			class = "engine.generator.object.Random",
			nb_object = {3, 6},
		},
	},
	post_process = function(level)
		for uid, e in pairs(level.entities) do e.faction = e.hard_faction or "orc-pride" end

		game.state:makeAmbientSounds(level, {
			desert1={ chance=250, volume_mod=0.6, pitch=0.6, random_pos={rad=10}, files={"ambient/desert/desert1","ambient/desert/desert2","ambient/desert/desert3"}},
			desert2={ chance=250, volume_mod=1, pitch=1, random_pos={rad=10}, files={"ambient/desert/desert1","ambient/desert/desert2","ambient/desert/desert3"}},
			desert3={ chance=250, volume_mod=1.6, pitch=1.4, random_pos={rad=10}, files={"ambient/desert/desert1","ambient/desert/desert2","ambient/desert/desert3"}},
		})
	end,
	levels =
	{
		[1] = {
			generator = { map = {
				['<'] = "UP_WILDERNESS",
			}, },
		},
	},
}
