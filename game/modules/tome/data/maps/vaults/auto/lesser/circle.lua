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
border = 0
defineTile('.', "FLOOR")
defineTile(',', data.floor or data['.'] or "FLOOR")
defineTile('X', "HARDWALL")
defineTile('!', "DOOR_VAULT")
defineTile('D', "DOOR")
defineTile('1', "FLOOR", {random_filter={add_levels=15, tome_mod="vault"}}, {random_filter={add_levels=20}})
defineTile('2', "FLOOR", {random_filter={add_levels=12, tome_mod="vault"}}, {random_filter={add_levels=17}})
defineTile('3', "FLOOR", {random_filter={add_levels=5}}, nil)

rotates = {"default", "90", "180", "270", "flipx", "flipy"}

startx = 5
starty = 1
local version = rng.range(1, 5)
if version == 1 then
return {
[[,,,,,,,,,,,]],
[[,,,XX!XX,,,]],
[[,,XX.2.XX,,]],
[[,XXXDXDXXX,]],
[[,X...X...X,]],
[[,X3.3X3.3X,]],
[[,XDXDXDXDX,]],
[[,X2X.2.X2X,]],
[[,XXXDXDXXX,]],
[[,XX..X..XX,]],
[[,X...X...X,]],
[[,X3.3X3.3X,]],
[[,XXXDXDXXX,]],
[[,,XX.1.XX,,]],
[[,,,XXXXX,,,]],
[[,,,,,,,,,,,]],
}
elseif version == 2 then
return {
[[,,,,,,,,,,,]],
[[,,,XX!XX,,,]],
[[,,XX.2.XX,,]],
[[,XXXXDXXXX,]],
[[,X3X3.3X3X,]],
[[,X.X...X.X,]],
[[,XDXXDXXDX,]],
[[,X2D.2.D2X,]],
[[,XDXXDXXDX,]],
[[,X.X...X.X,]],
[[,X3X3.3X3X,]],
[[,XXXX.XXXX,]],
[[,XXXXDXXXX,]],
[[,,XX.1.XX,,]],
[[,,,XXXXX,,,]],
[[,,,,,,,,,,,]],
}
elseif version == 3 then
return {
[[,,,,,,,,,,,]],
[[,,,XX!XX,,,]],
[[,,XXX2XXX,,]],
[[,XX3D.D3XX,]],
[[,XXDXXXDXX,]],
[[,X..3X3..X,]],
[[,XXDXXXDXX,]],
[[,X..D2D..X,]],
[[,XXXXDXXXX,]],
[[,X32X2X23X,]],
[[,XXDXDXDXX,]],
[[,X3.....3X,]],
[[,XXXXDXXXX,]],
[[,,XX.1.XX,,]],
[[,,,XXXXX,,,]],
[[,,,,,,,,,,,]],
}
elseif version == 4 then
return {
[[,,,,,,,,,,,]],
[[,,,XX!XX,,,]],
[[,,XX...XX,,]],
[[,XXX.2.XXX,]],
[[,X2D...D2X,]],
[[,X.XXDXX.X,]],
[[,X.X...X.X,]],
[[,X.X.2.X.X,]],
[[,X3X...X3X,]],
[[,X3X...X3X,]],
[[,X3XXDXX3X,]],
[[,X3X...X3X,]],
[[,XXX.1.XXX,]],
[[,,XX...XX,,]],
[[,,,XXXXX,,,]],
[[,,,,,,,,,,,]],
}
else
return {
[[,,,,,,,,,,,]],
[[,,,XX!XX,,,]],
[[,,XXX2XXX,,]],
[[,XXXX.XXXX,]],
[[,X33X.X33X,]],
[[,XDXXDXXDX,]],
[[,X2D...D2X,]],
[[,XDXXDXXDX,]],
[[,X.X...X.X,]],
[[,X.X.2.X.X,]],
[[,X.XXDXX.X,]],
[[,X3.D1D.3X,]],
[[,XXXX.XXXX,]],
[[,,XX3.3XX,,]],
[[,,,XXXXX,,,]],
[[,,,,,,,,,,,]],
}
end
