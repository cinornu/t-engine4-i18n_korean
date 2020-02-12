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

setStatusAll{no_teleport=true}
roomCheck(function(room, zone, level, map)
   return resolvers.current_level <= 25 and zone.npc_list.__loaded_files["/data/general/npcs/swarm.lua"] -- make sure the honey tree can summon
end)
specialList("actor", {
   "/data/general/npcs/bear.lua",
   "/data/general/npcs/plant.lua",
   "/data/general/npcs/swarm.lua",
})

specialList("terrain", {
   "/data/general/grids/forest.lua",
}, true)

local Floor = data.floor or "GRASS"
defineTile('X', "ROCK_VAULT", nil, nil, nil, {room_map={special=false, room=true, can_open=true}})
defineTile(' ', Floor)
defineTile('#', "HARDTREE")
defineTile('*', Floor, {random_filter={add_levels=10, tome_mod="vault"}})
defineTile('T', Floor, nil, {random_filter={name="honey tree", add_levels=15}})
defineTile('t', Floor, nil, {random_filter={name="honey tree"}})
defineTile('B', Floor, nil, {random_filter={name="bee swarm", add_levels=10}})
defineTile('b', Floor, nil, {random_filter={name="bee swarm", add_levels=5}})
defineTile('G', Floor, {random_filter={add_levels=20, tome_mod="vault"}}, {random_filter={name="grizzly bear", add_levels=20}})
defineTile('g', Floor, nil, {random_filter={name="brown bear", add_levels=10}})

startx = 2
starty = 10

rotates = {"default", "90", "180", "270", "flipx", "flipy"}
--Introducing: Our Patented Alt-Vault System(R)
local version = rng.range(1,4)
if version == 4 then
   return { -- more or less the original, 4 weak trees, 4 brown bears, 1 grizzly
   [[#######]],
   [[##*g*##]],
   [[#tgGgt#]],
   [[#t g t#]],
   [[##   ##]],
   [[### ###]],
   [[###X###]],
   }
elseif version == 3 then
   return { -- grizzly bear and a bunch of weak swarms
   [[#######]],
   [[##   ##]],
   [[#bb bb#]],
   [[#*bTb*#]],
   [[## G ##]],
   [[### ###]],
   [[###X###]],
   }
elseif version == 2 then
   return { -- 2 brown bears, 3 strong swarms, no narrow spot
   [[#######]],
   [[## t ##]],
   [[# * * #]],
   [[# gTg #]],
   [[# B*B #]],
   [[## B ##]],
   [[###X###]],
   }
else -- always return something
   return { -- 2 grizzly bears, one strong swarm
   [[#######]],
   [[## * ##]],
   [[# GTG #]],
   [[#  B  #]],
   [[##   ##]],
   [[### ###]],
   [[###X###]],
   }
end