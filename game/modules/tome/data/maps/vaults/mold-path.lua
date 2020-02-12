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
   return resolvers.current_level <= 25
end)
rotates = {"default", "90", "180", "270", "flipx", "flipy"}
specialList("terrain", {
   "/data/general/grids/water.lua",
   "/data/general/grids/forest.lua",
})
specialList("actor", {
   "/data/general/npcs/ooze.lua",
   "/data/general/npcs/molds.lua",
})
defineTile('.', "GRASS_SHORT")
defineTile('#', "TREE")
defineTile('X', "HARDTREE")
defineTile('~', "POISON_DEEP_WATER")
defineTile('!', "ROCK_VAULT", nil, nil, nil, {room_map={special=false, room=false, can_open=true}})

defineTile('m', "GRASS_SHORT", nil, {random_filter={subtype="molds", add_levels=5}})
defineTile('j', "GRASS_SHORT", nil, {random_filter={subtype="oozes", add_levels=5}})

defineTile('$', "GRASS_SHORT", {random_filter={add_levels=5, tome_mod="vault"}})
defineTile('*', "GRASS_SHORT", {random_filter={add_levels=10, tome_mod="vault"}})

startx = 3
starty = 7
local version = rng.range(1,4)
if version == 1 then
return { -- switchback, similar to original
[[XXXXXXXXXXXXXXXX]],
[[XXm~~.m....X$*$X]],
[[X~..j..jXX.mmmmX]],
[[X~..mXXXXXXXXXXX]],
[[Xm.jm......jm..X]],
[[XXXXXXXXXXXX~~.X]],
[[X~~...mm....mm.X]],
[[XXX!XXXXXXXXXXXX]],
}
elseif version == 2 then
return { -- big pond, you can go through the poison to the loot, the better loot is in sight of the mob pile though
[[XXXXXXXXXXXXXXXX]],
[[XX...XjmmmmX..*X]],
[[X..XmmjjmmmmmX$X]],
[[X..XXXXXmjmmjX$X]],
[[X..~~~~XXXXXXX~X]],
[[XX.~~~~~~~~~~~~X]],
[[XX...~~~~~~~~~XX]],
[[XXX!XXXXXXXXXXXX]],
}
elseif version == 3 then
return { -- small pond, lots of jellies
[[XXXXXXXXXXXXXXXX]],
[[XXmjmXXj..jXX$XX]],
[[Xj..j..jX..mjjmX]],
[[Xj.~mXXXXXX.jj$X]],
[[Xm.~~~~~~~XjX..X]],
[[XX.mXX~~~~XjXj*X]],
[[Xm..XXX~~~XX~~~X]],
[[XXX!XXXXXXXXXXXX]],
}
else
return { -- small pond, nearly all mold, token jelly
[[XXXXXXXXXXXXXXXX]],
[[XX...mmm..m.X$XX]],
[[Xmm...~~XXXmXmjX]],
[[X....m~~mmXX...X]],
[[X....~~~~~mXmmmX]],
[[XX....m~~~~XX$mX]],
[[XX......m~~X*mmX]],
[[XXX!XXXXXXXXXXXX]],
}
end
