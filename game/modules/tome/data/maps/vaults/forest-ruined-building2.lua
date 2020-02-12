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

startx = 9
starty = 1

setStatusAll{no_teleport=true, room_map = {can_open=true}}

roomCheck(function(room, zone, level, map)
   return zone.npc_list.__loaded_files["/data/general/npcs/bear.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/plant.lua"] and zone.npc_list.__loaded_files["/data/general/npcs/swarm.lua"] --make sure the honey tree can summon
end)

specialList("actor", {"/data/general/npcs/aquatic_demon.lua"}, true)

specialList("terrain", {
   "/data/general/grids/underground_gloomy.lua",
   "/data/general/grids/water.lua",
   "/data/general/grids/forest.lua",
}, true)

border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

local vaultvariations = rng.range(1,3)

defineTile('.', "FLOOR")
defineTile(',', "GRASS")
defineTile('#', "WALL")
defineTile('X', "TREE")
defineTile('+', "DOOR", nil, nil, nil, {room_map = {can_open=true}})

if vaultvariations == 1 then -- Gloomy theme
   defineTile('i', "FLOOR", {random_filter={add_levels=4, tome_mod="gvault"}})
   local Talents = require("engine.interface.ActorTalents")
   defineTile('T', "FLOOR", nil,
      {entity_mod=function(e)
         e.make_escort = nil
         e.name = rng.table{"gloomy ", "deformed ", "sick "}..e.name
         e[#e+1] = resolvers.talents{ [Talents.T_GLOOM]=1, [Talents.T_HATEFUL_WHISPER]=1 }
         e:resolve()
         return e
      end,
      random_filter={name="honey tree", add_levels=4}}
   )
   defineTile('P', "GRASS", nil,
      {entity_mod=function(e)
         e.make_escort = nil
         e.name = rng.table{"gloomy ", "deformed ", "sick "}..e.name
         e[#e+1] = resolvers.talents{ [Talents.T_AGONY]=1, [Talents.T_GLOOM]=1 }
         e:resolve()
         return e
      end,
      random_filter={name="giant venus flytrap", add_levels=4}}
   )
   defineTile('B', "FLOOR", nil,
      {entity_mod=function(e)
         e.make_escort = nil
         e.name = rng.table{"gloomy ", "deformed ", "sick "}..e.name
         e[#e+1] = resolvers.talents{ [Talents.T_REPROACH]=1, [Talents.T_GLOOM]=1 }
         e:resolve()
         return e
      end,
      random_filter={name="brown bear", add_levels=4}}
   )
   return {
   [[,,,,,,,,,,,,,,,,,,,,,]],
   [[,#################X,,]],
   [[,#i...#.....,,#,X,,X,]],
   [[,#P...+......,+,..i#,]],
   [[,######...T...######,]],
   [[,#.,,,,.......+..i.#,]],
   [[,#i.,B#,,.....#B...#,]],
   [[,########+#+########,]],
   [[,,,,,,,,,,,,,,,,,,,,,]],
   }

elseif vaultvariations == 2 then -- FLooded theme
   local Talents = require("engine.interface.ActorTalents")
   defineTile('~', "DEEP_WATER")
   defineTile('i', "GRASS", {random_filter={add_levels=4, tome_mod="gvault"}})
   defineTile('T', "DEEP_WATER", nil,
      {entity_mod=function(e)
         e.make_escort = nil
         e.can_breath={water=1}
         e.name = rng.table{"wet ", "soaked ", "drenched "}..e.name
         e[#e+1] = resolvers.talents{ [Talents.T_TIDAL_WAVE]=2 }
         e:resolve()
         return e
      end,
      random_filter={name="honey tree", add_levels=4}}
   )
   defineTile('B', "DEEP_WATER", nil,
      {entity_mod=function(e)
         e.make_escort = nil
         e.can_breath={water=1}
         e.name = rng.table{"wet ", "soaked ", "drenched "}..e.name
         e[#e+1] = resolvers.talents{ [Talents.T_WATER_BOLT]=1 }
         e:resolve()
         return e
      end,
      random_filter={name="giant venus flytrap", add_levels=4}}
   )
   defineTile('P', "DEEP_WATER", nil, {random_filter={name="water imp", add_levels=4}})
   return {
   [[,,,,,,,,,,,,,,,,,,~~~]],
   [[,#################X~~]],
   [[,#~P~~#~~~~~~~#~~~~X~]],
   [[,#~~~,+,~~~~~~X~~P~#,]],
   [[,######,~~T~~~######,]],
   [[,#~~i,+,~~~~~,+,~~~#,]],
   [[,#B~~,#i,,,,,i#~~~B#,]],
   [[,########+#+########,]],
   [[,,,,,,,,,,,,,,,,,,,,,]],
   }

else -- Normal theme
   defineTile('T', "GRASS", nil, {random_filter={name="honey tree", add_levels=4}})
   defineTile('P', "GRASS", nil, {random_filter={name="giant venus flytrap", add_levels=4}})
   defineTile('B', "FLOOR", nil, {random_filter={name="brown bear", add_levels=4}})
   defineTile('i', "FLOOR", {random_filter={add_levels=4, tome_mod="vault"}})
   return {
   [[,,,,,,,,,,,,,,,,,,,,,]],
   [[,#################X,,]],
   [[,#B...#.,..,..#iX.,X,]],
   [[,#.i..+..,,,..+..,P#,]],
   [[,######..,T,,.######,]],
   [[,#i...+.,,,,..+...P#,]],
   [[,#P...#....,,.#B..i#,]],
   [[,########+#+########,]],
   [[,,,,,,,,,,,,,,,,,,,,,]],
   }
end
