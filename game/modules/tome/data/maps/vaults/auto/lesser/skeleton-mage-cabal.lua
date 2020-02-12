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
roomCheck(function(room, zone, level, map)
   return resolvers.current_level >= 5 and resolvers.current_level <= 25
end)
specialList("actor", {
   "/data/general/npcs/skeleton.lua",
   "/data/general/npcs/thieve.lua",
   "/data/general/npcs/horror.lua",
})
specialList("terrain", {
   "/data/general/grids/forest.lua",
}, true)
local mobs = {
   "skeleton mage",
   "skeleton warrior",
   "skeleton archer",
   "thief",
   "bloated horror",
}
local mob = rng.tableRemove(mobs)

local weapon = "staff"
if mob == "skeleton warrior" then weapon = rng.percent(50) and "waraxe" or "battleaxe"
elseif   mob == "skeleton archer" then weapon = "longbow"
elseif   mob == "thief" then weapon = rng.percent(50) and "dagger" or "sling"
elseif   mob == "bloated horror" then weapon = "mindstar"
end

local armor = "cloth"
if mob == "skeleton warrior" then armor = rng.percent(50) and "shield" or "massive"
elseif   mob == "skeleton archer" then armor = rng.percent(50) and "light" or "heavy"
elseif   mob == "thief" then armor = "light"
end

border = 0
startx, starty = 4, 10
defineTile('.', data.floor or "FLOOR")
defineTile(',', "FLOOR")
defineTile('D', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('X', "HARDWALL")
defineTile('S', "FLOOR", {random_filter={type="scroll", ego_chance=50, add_levels=6}})
defineTile('W', "FLOOR", {random_filter={subtype=weapon, tome_mod="vault", add_levels=6, ego_chance=100}})
defineTile('A', "FLOOR", {random_filter={subtype=armor, tome_mod="vault", add_levels=6, ego_chance=100}})
defineTile('M', "FLOOR", nil, {random_filter={name=mob, add_levels=8}})
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

return {
[[.........]],
[[.XXXXXXX.]],
[[.XASSSWX.]],
[[.XXXDXXX.]],
[[.X,,M,,X.]],
[[.X,M,M,X.]],
[[.X,,M,,X.]],
[[.XDX!XDX.]],
[[.XWX.XAX.]],
[[.XXX.XXX.]],
[[.........]],
}
