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

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}
specialList("actor", {
   "/data/general/npcs/troll.lua",
})
specialList("terrain", {
   "/data/general/grids/water.lua",
   "/data/general/grids/forest.lua",
}, true)
border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', "GRASS")
defineTile('~', "DEEP_WATER")
defineTile('#', "HARDWALL")
defineTile('X', "TREE")
defineTile('+', "DOOR")

defineTile('T', "FLOOR", {random_filter={type="scroll", ego_chance=25}}, {random_filter={name="forest troll", add_levels=10}})
defineTile('t', "FLOOR", nil, {random_filter={name="forest troll"}})
defineTile('$', "FLOOR", {random_filter={type="scroll", ego_chance=25}})
defineTile('*', "FLOOR", {random_filter={mod="vault", add_levels=5}})
startx, starty = 0, 9

local version = rng.range(1, 3)
if version == 1 then
return { -- original
[[,,,,,,,,,,,,,,,,,,,,,,]],
[[,,,XX,,X,,,,,,,,,,X,,,]],
[[,,X~~~~~~~,,~~~~~XXX,,]],
[[,XX~#####~,,~#####~,,,]],
[[,XX~#...#~~~~#..*#~,X,]],
[[,XX~#.t.######.T.#~,,,]],
[[,,X~#...#.t..+...#~,X,]],
[[,XX~###+#..t.#####~,,,]],
[[,XX~~~#....#####~~~,,,]],
[[,,,..t+....#$.$#~,,,X,]],
[[,,,..t+....+.$T#~,,,X,]],
[[,XX~~~#....#####~~~,X,]],
[[,,X~###+#..t.#####~,X,]],
[[,,X~#...#.t..+...#~,X,]],
[[,,X~#.T.######.t.#~,,,]],
[[,XX~#*..#~~~~#...#~,,,]],
[[,,X~#####~,,~#####~,,,]],
[[,,X~~~~~~~,,~~~~~~~,,,]],
[[,,XXX,X,,XXX,X,,XXX,,,]],
[[,,,,,,,,,,,,,,,,,,,,,,]],
}
elseif version == 2 then
return { -- ruined
[[,,,,,,,,,,,,,,,,,,,,,,]],
[[,,XXXXXXXXXXXXXXXXXX,,]],
[[,,X~~~~~~~,,~~~~~~~XX,]],
[[,XX~#####~,,~#####~,X,]],
[[,XX~#$.t#~~~~#.*.#~XX,]],
[[,XX~#,t.#.#~.#.T.#~X,,]],
[[,,X~#t..#....+.,,#~XX,]],
[[,XX~###+#..#.#####~,X,]],
[[,XX~~#...#....X.~~~,X,]],
[[,,,.~~.,,..X.t..~~,,X,]],
[[,,,.~t.#..T.,#.~~~~,X,]],
[[,XX~~~..,.,...~~~~~,X,]],
[[,,X~###+#..X.#####~,X,]],
[[,,X~#*.t#....+,,$#~XX,]],
[[,,X~#.T.#..#.#.t.#~X,,]],
[[,XX~#t.,#~~#~#$..#~X,,]],
[[,,X~#####~~~~#####~X,,]],
[[,,X~~~~~~~,,~~~~~~~X,,]],
[[,,XXXXXXXXXXXXXXXXXX,,]],
[[,,,,,,,,,,,,,,,,,,,,,,]],
}
else
return { -- fortified
[[,,,,,,,,,,,,,,,,,,,,,,]],
[[,,,XX,,X,,,,,,,,,,X,,,]],
[[,,X~~~~~~~,,~~~~~XXX,,]],
[[,XX~#####~~~~#####~,,,]],
[[,XX~#...######.$.#~,X,]],
[[,XX~#.T....#..t..#~,,,]],
[[,,X~#....#.#.#.t.#~,X,]],
[[,XX~###..#.#.#.###~,,,]],
[[,XX~~~#..#.#.#.#~~~,,,]],
[[,,,...+t.#.#.#.#~,,,X,]],
[[,,,...+t.#.#T#.#~,,,X,]],
[[,XX~~~#.##.#.#.#~~~,X,]],
[[,,X~#####....#.###~,X,]],
[[,,X~#$.#######t..#~,X,]],
[[,,X~#T.+..tt..t..#~,,,]],
[[,XX~#**#######..$#~,,,]],
[[,,X~#####~~~~#####~,,,]],
[[,,X~~~~~~~,,~~~~~~~,,,]],
[[,,XXX,X,,XXX,X,,XXX,,,]],
[[,,,,,,,,,,,,,,,,,,,,,,]],
}
end