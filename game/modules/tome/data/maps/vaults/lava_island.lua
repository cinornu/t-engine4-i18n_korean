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

setStatusAll{no_teleport=true, no_vaulted=true, room_map={can_open=true}}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}
border = 0
roomCheck(function(room, zone, level, map)
	return resolvers.current_level >= 45 and zone.grid_list.__loaded_files["/data/general/grids/lava.lua"] and zone.grid_list.__loaded_files["/data/general/grids/sand.lua"]
end)
specialList("actor", {
	"/data/general/npcs/major-demon.lua",
	"/data/general/npcs/minor-demon.lua",
})
defineTile('.', "SAND")
defineTile('~', "LAVA_FLOOR")
defineTile('#', "SAND")
defineTile('T', "PALMTREE")

defineTile('1', "SAND", nil, {random_filter={name="fire imp", add_levels=4}})
defineTile('2', "SAND", nil, {random_filter={name="quasit", add_levels=4}})
defineTile('U', "SAND", {random_filter={name="voratun ring", ignore_material_restriction=true, ego_chance=-1000}}, {random_filter={name="uruivellas", random_elite={name_scheme=_t"#rng# the Witherer", class_filter=function(d) return d.name == "Corruptor" or d.name == "Reaver" end, post=function(b) b:forceUseTalent(b.T_SUSPENDED, {ignore_energy=true}) end}, add_levels=12}})

return {
[[..T............T.TT.]],
[[T..T..~.........~.TT]],
[[T.~....~~..1...~....]],
[[....~.2..~.~.~~.2..T]],
[[..1..~~~~.~.~~~.....]],
[[..~~...~~~~~~~..~~..]],
[[....~..~~####~~~.1..]],
[[...2.~~~##.U##~~~~..]],
[[...~~..~~####~~~....]],
[[.....~~~~~~~~~..1...]],
[[..2....~..~..~~....T]],
[[T...~~~.~...2.~.....]],
[[...~......~....~..1T]],
[[T.T...1..........~TT]],
[[TT.TT...........TTTT]],
}
