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
	name = _t"Rak'shor Pride",
	level_range = {30, 60},
	level_scheme = "player",
	max_level = 3,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 50, height = 50,
	persistent = "zone",
--	all_remembered = true,
	all_lited = true,
	day_night = true,
	ambient_music = {"March.ogg", "weather/desert_base.ogg"},
	min_material_level = 4,
	max_material_level = 5,
	effects = {"EFF_ZONE_AURA_RAKSHOR"},
	generator =  {
		map = {
			class = "engine.generator.map.Roomer",
			nb_rooms = 10,
			['.'] = "BONEFLOOR",
			['#'] = "BONEWALL",
			up = "BONE_LADDER_UP",
			down = "BONE_LADDER_DOWN",
			door = "BONE_DOOR",
			subvault_exterior_wall = "HARDBONEWALL",
			static_replace_tiles = {
				FLOOR = "BONEFLOOR",
				DOOR = "BONE_DOOR",
				WALL = "BONEWALL",
				HARDWALL = "HARDBONEWALL",
				DOOR_VAULT = "BONE_VAULT_DOOR",
			},
			rooms = {{"forest_clearing",2}, "random_room", {"lesser_vault",2}},
			lesser_vaults_list = {"orc-armoury", "double-t", "crypt", "hostel", "horror-chamber"},
			lite_room_chance = 20,
		},
		actor = {
			class = "mod.class.generator.actor.Random",
			nb_npc = {35, 40},
			guardian = "RAK_SHOR",
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
				class = "engine.generator.map.MapScript",
				['<'] = "BONE_UP_WILDERNESS", ['>'] = "BONE_LADDER_DOWN",
				['.'] = "BONEFLOOR", ['+'] = "BONE_DOOR", ['#'] = "BONEWALL",
				['_'] = "BONEFLOOR", [';'] = "BONEFLOOR",
				door = "BONE_DOOR",
				mapscript = "!main",
				pride = "rak-shor",
			}, },
		},
		[3] = {
			width = 30, height = 30,
			generator = { map = {
				down = "BONE_UP_WILDERNESS",
			}, },
		},
	},
}
