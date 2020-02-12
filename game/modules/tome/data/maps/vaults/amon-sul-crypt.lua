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
   "/data/general/npcs/skeleton.lua",
   "/data/general/npcs/ghoul.lua",
})
border = 0
defineTile('.', "FLOOR")
defineTile(',', data.floor or data['.'] or "FLOOR")
defineTile('#', "WALL")
defineTile('X', "HARDWALL")
defineTile('!', "DOOR_VAULT")
defineTile('D', "DOOR")

rotates = {"default", "90", "180", "270", "flipx", "flipy"}
startx = 4
starty = 2

local version = rng.range(1, 4)
if version == 1 then -- warriors(more or less the original)
defineTile('S', "FLOOR", {random_filter={add_levels=4, tome_mod="vault"}}, {random_filter={name="skeleton warrior", add_levels=2}})
defineTile('A', "FLOOR", {random_filter={type="armor", tome_mod="vault", add_levels=5}}, {random_filter={name="skeleton warrior", add_levels=6}})
defineTile('G', "FLOOR", nil, {random_filter={name="armoured skeleton warrior" , add_levels=4}})
return {
[[,,,,,,,,,]],
[[,,,X.X,,,]],
[[,,XX!XX,,]],
[[,XXX.XXX,]],
[[,XSD.DSX,]],
[[,XXXGXXX,]],
[[,XSD.DAX,]],
[[,XXX.XXX,]],
[[,,XX!XX,,]],
[[,,,X.X,,,]],
[[,,,,,,,,,]],
}
elseif version == 2 then -- mages
defineTile('S', "FLOOR", {random_filter={add_levels=4, tome_mod="vault"}}, {random_filter={name="skeleton mage", add_levels=2}})
defineTile('A', "FLOOR", {random_filter={type="armor", tome_mod="vault", add_levels=5}}, {random_filter={name="skeleton magus", add_levels=6}})
defineTile('G', "FLOOR", nil, {random_filter={name="skeleton mage" , add_levels=4}})
return {
[[,,,,,,,,,]],
[[,,,X.X,,,]],
[[,,XX!XX,,]],
[[,XXX.XXX,]],
[[,XSX.XSX,]],
[[,X.DAD.X,]],
[[,XSX.XGX,]],
[[,XXX.XXX,]],
[[,,XX!XX,,]],
[[,,,X.X,,,]],
[[,,,,,,,,,]],
}
elseif version == 3 then -- ghouls
defineTile('S', "FLOOR", {random_filter={add_levels=4, tome_mod="vault"}}, {random_filter={name="ghoul", add_levels=2}})
defineTile('A', "FLOOR", {random_filter={type="armor", tome_mod="vault", add_levels=5}}, {random_filter={name="ghast", add_levels=6}})
defineTile('G', "FLOOR", nil, {random_filter={name="ghoul" , add_levels=4}})
return {
[[,,,,,,,,,]],
[[,,,X.X,,,]],
[[,,XX!XX,,]],
[[,XX..,XX,]],
[[,XS..XSX,]],
[[,X,.A,,X,]],
[[,XSX..GX,]],
[[,XX..,XX,]],
[[,,XX!XX,,]],
[[,,,X.X,,,]],
[[,,,,,,,,,]],
}
else -- archers
defineTile('S', "FLOOR", {random_filter={add_levels=4, tome_mod="vault"}}, {random_filter={name="skeleton archer", add_levels=2}})
defineTile('A', "FLOOR", {random_filter={type="armor", tome_mod="vault", add_levels=5}}, {random_filter={name="skeleton master archer", add_levels=6}})
defineTile('G', "FLOOR", nil, {random_filter={name="skeleton archer" , add_levels=4}})
return {
[[,,,,,,,,,]],
[[,,,X.X,,,]],
[[,,XX!XX,,]],
[[,XX..XXX,]],
[[,X.SXXGX,]],
[[,XX.A.XX,]],
[[,XSXXS.X,]],
[[,XXX..XX,]],
[[,,XX!XX,,]],
[[,,,X.X,,,]],
[[,,,,,,,,,]],
}
end