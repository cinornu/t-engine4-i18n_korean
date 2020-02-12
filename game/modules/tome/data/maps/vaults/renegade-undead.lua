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

specialList("actor", {
	"/data/general/npcs/orc-rak-shor.lua",
	"/data/general/npcs/horror-undead.lua",
	"/data/general/npcs/ghoul.lua",
	"/data/general/npcs/lich.lua",
})

specialList("terrain", {
	"/data/general/grids/bone.lua",
	"/data/general/grids/gothic.lua",
	"/data/general/grids/basic.lua",
})

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "BONEFLOOR")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('#', "HARDBONEWALL")

defineTile(',', "BONEFLOOR", {random_filter={add_levels=16, tome_mod="gvault"}})
defineTile('a', "BONEFLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=10, name = "necrotic abomination"}})
defineTile('s', "BONEFLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=10, name = "sanguine horror"}})
defineTile('b', "BONEFLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=10, name = "bone horror"}})
defineTile('g', "BONEFLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "ghoulking"}})
defineTile('n', "BONEFLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "orc necromancer"}})
defineTile('l', "BONEFLOOR", {random_filter={add_levels=20, tome_mod="uvault"}}, {random_filter={add_levels=33, name = "lich"}})
defineTile('N', "BONEFLOOR", {random_filter={add_levels=12, tome_mod="uvault"}}, {random_filter={add_levels=22, name = "orc necromancer", random_boss={name_scheme=_t"Grand Necromancer #rng#", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.5, force_classes={Necromancer=true}}}} )
defineTile('C', "BONEFLOOR", {random_filter={add_levels=12, tome_mod="uvault"}}, {random_filter={add_levels=16, name = "orc blood mage", random_boss={name_scheme=_t"Inquisitor #rng#", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.5, force_classes={Corruptor=true}}}} )
defineTile('M', "BONEFLOOR", {random_filter={add_levels=12, tome_mod="uvault"}}, {random_filter={add_levels=25, name = "sanguine horror", random_boss={name_scheme=_t"#rng# the Tortured Mass", nb_classes=2, class_filter=function(d) return d.power_source and d.power_source.arcane and not d.power_source.technique and d.name ~= "Corruptor" end, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=4, force_classes={Corruptor=true}}}} )
defineTile('T', "BONEFLOOR", {random_filter={add_levels=12, tome_mod="uvault"}}, {random_filter={add_levels=25, name = "bone horror", random_boss={name_scheme=_t"Tortured Mass #rng#", nb_classes=2, class_filter=function(d) return d.power_source and d.power_source.arcane and d.power_source.technique and d.name ~= "Reaver" end, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=4, force_classes={Reaver=true}}}} )

return {
[[.#####....#####]],
[[.#,.T######g.,#]],
[[.#,..#n...#..M#]],
[[.#,g.#....+.,,#]],
[[.###+#.n..#####]],
[[..#.....######.]],
[[..!.....#a..l#.]],
[[..!....N+..,,#.]],
[[..#..a..######.]],
[[.###+#...n#####]],
[[.#T.s#....+..g#]],
[[.#..,#C.a.#.,,#]],
[[.#g,,######M,,#]],
[[.#####....#####]],
}
