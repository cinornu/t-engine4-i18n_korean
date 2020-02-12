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
   "/data/general/npcs/thieve.lua",
})
specialList("terrain", {
   "/data/general/grids/forest.lua",
}, true)
border = 0
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile(',', data.floor or data['.'] or "GRASS")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
local mobs = {
   "bandit",
   "rogue",
   "cutpurse",
}
local bosses = {
   "rogue sapper",
   "assassin",
   "shadowblade"
}

local boss = rng.tableRemove(bosses)

defineTile('1', "FLOOR", nil, {random_filter={name=mobs[rng.range(0, #mobs)], add_levels=4}})
defineTile('2', "FLOOR", nil, {random_filter={name=mobs[rng.range(0, #mobs)], add_levels=5}})
defineTile('3', "FLOOR", nil, {random_filter={name=mobs[rng.range(0, #mobs)], add_levels=6}})
defineTile('B', "FLOOR", nil, {random_filter={name=boss,  add_levels=boss=="shadowblade" and 0 or 12}})
defineTile('T', "FLOOR", nil, {random_filter={name="thief", add_levels=10}})

defineTile('&', "FLOOR", {random_filter={type="scroll", ego_chance=25}})
defineTile('$', "FLOOR", {random_filter={add_levels=15, type="money"}})
defineTile('*', "FLOOR", {random_filter={type="gem"}})
defineTile('%', "FLOOR", {random_filter={mod="gvault", type="armor", add_levels=8}})
defineTile('^', "FLOOR", {random_filter={mod="vault", type="weapon", add_levels=8}})
--startx, starty = 10, 0

local version = rng.range(1, 3)
if version == 1 then
return {
[[,,,,,,,,,,,,,,]],
[[,#######,,,,,,]],
[[,#%#$$$#,,,,,,]],
[[,#^#$*$#,,,,,,]],
[[,#*#$$$#,,,,,,]],
[[,#+##+###!###,]],
[[,#B^#2#1...2#,]],
[[,#&3+1#.312.#,]],
[[,####.#..3..#,]],
[[,#13#.#.....#,]],
[[,#*2+.+..T..#,]],
[[,############,]],
[[,,,,,,,,,,,,,,]],
}
elseif version == 2 then
return {
[[,,,,,,,,,,,,,,]],
[[,,,,,,,,,,,,,,]],
[[,,,,,,,,,,,,,,]],
[[,###########,,]],
[[,.!..213$$.#,,]],
[[,##+######+#,,]],
[[,#..#*B*#12#,,]],
[[,#..#132#3$#,,]],
[[,#..#+#+####,,]],
[[,#12..#$$&^#,,]],
[[,#3T$*#$$%^#,,]],
[[,###########,,]],
[[,,,,,,,,,,,,,,]],
}
else
return {
[[,,,,,,,,,,,,,,]],
[[,#!#####,,,,,,]],
[[,#.#$*$#,,,,,,]],
[[,#.#2$3#,,,,,,]],
[[,#1#.1.#,,,,,,]],
[[,#+#+#+######,]],
[[,#...#.23...#,]],
[[,#.23##1..B2#,]],
[[,#.1T*#...3*#,]],
[[,####+###+###,]],
[[,#$$$$#%*^^&#,]],
[[,############,]],
[[,,,,,,,,,,,,,,]],
}
end