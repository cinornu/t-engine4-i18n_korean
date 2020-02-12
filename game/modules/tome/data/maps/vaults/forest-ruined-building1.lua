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

setStatusAll{no_teleport=true, room_map = {can_open=true}}
specialList("actor", {
   "/data/general/npcs/troll.lua",
   "/data/general/npcs/ghoul.lua",
   "/data/general/npcs/thieve.lua",
   "/data/general/npcs/skeleton.lua",
})
border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', data.floor or data['.'] or "GRASS")
defineTile('#', "HARDWALL")
defineTile('X', "HARDTREE")
defineTile('+', "DOOR")
defineTile('x', "DOOR_VAULT")

local mobs = {
   "cave troll",
   "thief",
   "skeleton magus",
   "ghast",
}
local mob = rng.tableRemove(mobs)
local moblet = "forest troll"
if mob == "thief" then moblet = "bandit"
elseif mob == "skeleton magus" then moblet = "skeleton warrior"
elseif mob == "ghast" then moblet = "ghoul"
end

defineTile('T', "FLOOR", {random_filter={type="scroll", ego_chance =50, add_levels=8}}, {random_filter={name=mob, add_levels=8}})
defineTile('t', "FLOOR", {random_filter={tome_mod="vault", add_levels=5}}, {random_filter={name=moblet, add_levels=6}})
defineTile('m', "FLOOR", nil, {random_filter={name=moblet, add_levels=4}})

local version = rng.range(1,3)
if version == 1 then
return {
[[,,,,,,,,,,,,,]],
[[,#####XXXX,,,]],
[[,#tTt#,,XX,X,]],
[[,#...#,,,XXX,]],
[[,###x#X#X.,#,]],
[[,#,..,,XX,.#,]],
[[,X.m...m,..+,]],
[[,X,,.X.,...+,]],
[[,X,X.m.,,..#,]],
[[,##XX#XXX#X#,]],
[[,,,,,,,,,,,,,]],
}
elseif version == 2 then
return {
[[,,,,,,,,,,,,,]],
[[,##X##XXXX#X,]],
[[,X,,,,.m.XX,,]],
[[,X,.,....,XX,]],
[[,X.###x###,#,]],
[[,Xm#t...t#,#,]],
[[,#.#..T..#,#,]],
[[,#,#######,X,]],
[[,X,,,.,.m.#X,]],
[[,X###++#####,]],
[[,,,,,,,,,,,,,]],
}
else
return {
[[,,,,,,,,,,,,,]],
[[,###++##X#X,,]],
[[,#,.m.,#XX#X,]],
[[,X,...,,,XXX,]],
[[,X.mXX,,,,,#,]],
[[,#...,,,.X.#,]],
[[,#####,,,,.X,]],
[[,#t,.x..mX.#,]],
[[,#Tt.#,.X..#,]],
[[,#########X#,]],
[[,,,,,,,,,,,,,]],
}
end