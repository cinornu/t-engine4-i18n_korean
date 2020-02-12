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
	"/data/general/npcs/orc-grushnak.lua",
	"/data/general/npcs/orc.lua",
	"/data/general/npcs/bear.lua",
})

specialList("terrain", {
	"/data/general/grids/basic.lua",
	"/data/zones/grushnak-pride/grids.lua",
})

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}   
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile('.', "FLOOR")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('#', "HARDWALL")

defineTile('G', "FLOOR", {random_filter={add_levels=5, tome_mod="uvault"}}, {random_filter={add_levels=15, name = "orc archer", random_boss={name_scheme=_t"#rng# the Archer", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.5, force_classes={Archer=true}}}} )
defineTile('B', "FLOOR", {random_filter={add_levels=5, tome_mod="uvault"}}, {random_filter={add_levels=12, name = "war bear", random_boss={name_scheme=_t"Warbear #rng#", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=3.5, force_classes={Brawler=true}}}} )
defineTile('o', "FLOOR", nil, nil, {random_filter={name="sliding rock"}})
defineTile('T', "FLOOR", {random_filter={add_levels=15, tome_mod="uvault"}}, {random_filter={add_levels=16, name = "orc elite fighter", random_boss={name_scheme=_t"Elite Combat Trainer #rng#", force_classes={Bulwark=true}, nb_classes=2, class_filter=function(d) return d.power_source and d.power_source.technique and not d.power_source.arcane and d.name ~= "Bulwark" end, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, rank=4}}})
defineTile('t', "FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=5, name = "orc elite fighter"}})
defineTile('C', "FLOOR", {random_filter={add_levels=15, tome_mod="uvault"}}, {random_filter={add_levels=16, name = "orc elite berserker", random_boss={name_scheme=_t"Elite Combat Trainer #rng#", force_classes={Berserker=true}, nb_classes=2, class_filter=function(d) return d.power_source and d.power_source.technique and not d.power_source.arcane and d.name ~= "Berserker" end, loot_quality="store", loot_quantity=1, loot_unique=true, no_loot_randart=true, rank=4}}})
defineTile('c', "FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=5, name = "orc elite berserker"}})
defineTile('D', "TRAINING_DUMMY")
defineTile('w', "FLOOR", {random_filter={type='weapon', add_levels=16, tome_mod="gvault"}})
defineTile('W', "FLOOR", {random_filter={type='weapon', add_levels=25, tome_mod="uvault"}})
defineTile('a', "FLOOR", {random_filter={type='armor', add_levels=16, tome_mod="gvault"}})
defineTile('A', "FLOOR", {random_filter={type='armor', add_levels=25, tome_mod="uvault"}})
defineTile('b', "FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=20, name = "orc elite berserker"}})
defineTile('f', "FLOOR", {random_filter={add_levels=10, type="jewelry", tome_mod="gvault"}}, {random_filter={add_levels=20, name = "orc elite fighter"}})

return {
[[#########################]],
[[##.G#DB.+wW#AAaa#B.D#DfD#]],
[[##..#C..#wW###Aa+..T#bfb#]],
[[##..#D.t#wwWW#Aa#c.D#f.b#]],
[[##.###+###########+###+##]],
[[!o..+...................#]],
[[##.###+###########+###+##]],
[[##..#D.c#wwWW#Aa#B.D#b.f#]],
[[##..#T..#wW###Aa+..C#bfb#]],
[[##.G#DB.+wW#AAaa#t.D#DfD#]],
[[#########################]],
}
