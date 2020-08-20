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

local Talents = require("engine.interface.ActorTalents")

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}


specialList("actor", {
	"/data/general/npcs/thieve.lua",
	"/data/general/npcs/minotaur.lua",
	"/data/general/npcs/troll.lua",
})
specialList("terrain", {
   "/data/general/grids/water.lua",
   "/data/general/grids/forest.lua",
}, true)
border = 0
startx = 18
starty = 7
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

local thieves = {
   "rogue",
   "rogue sapper",
   "thief",
   "cutpurse",
   "assassin"
}

local thugs = {
	"bandit",
	"mountain troll",
	"minotaur"
}

local bosses = {
   "bandit lord",
   "assassin",
   "shadowblade"
}

local thuggeries =  {"Berserker", "Bulwark", "Brawler"}

local rogues = {}
local Birther = require "engine.Birther"
for name, data in pairs(Birther.birth_descriptor_def.class["Rogue"].descriptor_choices.subclass) do
	if Birther.birth_descriptor_def.subclass[name] and not Birther.birth_descriptor_def.subclass[name].not_on_random_boss then rogues[#rogues+1] = name end
end

defineTile('.', "FLOOR")
defineTile('#', "HARDWALL")
defineTile('+', "DOOR")
defineTile('!', "DOOR_VAULT")
defineTile('>', "DYNAMIC_ZONE_EXIT")
defineTile('*', "FLOOR", nil, nil, {random_filter={add_levels=20}})

defineTile('g', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=3, random_boss={name_scheme=_t"#rng# the Guard", nb_classes=0, force_classes={(rng.table(rogues))}, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.2}}})
defineTile('G', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=5, random_boss={name_scheme=_t"#rng# the Guard", nb_classes=0, force_classes={(rng.table(rogues))}, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.2}}})
defineTile('t', "FLOOR", nil, {random_filter={name=(rng.table(thugs)), add_levels=4, random_boss={name_scheme=_t"#rng# the Thug", nb_classes=0, force_classes={(rng.table(thuggeries))}, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=3.5}}})
defineTile('T', "FLOOR", nil, {random_filter={name=(rng.table(thugs)), add_levels=6, random_boss={name_scheme=_t"#rng# the Thug", nb_classes=0, force_classes={(rng.table(thuggeries))}, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=3.5}}})
defineTile('r', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=2}})
defineTile('R', "FLOOR", nil, {random_filter={name=(rng.table(thieves)), add_levels=3}})
defineTile('l', "FLOOR", nil, {random_filter={add_levels=10, name = "bandit lord"}})
defineTile('i', "FLOOR", nil, {random_filter={name=(rng.table(thugs)), add_levels=3}})
defineTile('I', "FLOOR", nil, {random_filter={name=(rng.table(thugs)), add_levels=6}})
defineTile('B', "FLOOR", nil, {random_filter={name=(rng.table(bosses)), add_levels=8, random_boss={name_scheme=_t"Bandit Leader #rng#", nb_classes=0, force_classes={(rng.table(rogues)), (rng.table(thuggeries))}, loot_quality="store", loot_quantity=1, loot_unique=true, ai_move="move_complex", rank=4, 
on_die=function(self, who) -- drop lore note on death
	local lore = mod.class.Object.new{
		type = "lore", subtype="lore",
		unided_name = _t"scroll", identified=true,
		display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll.png",
		encumber = 0,
		name = _t"Boss's Journal", lore="bandit-vault-boss",
		desc = _t[[A messily scrawled pile of loose papers.]],
		level_range = {1, 20},
		rarity = false,
	}
	game.zone:addEntity(game.level, lore, "object", self.x, self.y) 
end}}})

defineTile('$', "FLOOR", {random_filter={add_levels=25, type="money"}})
defineTile('g', "FLOOR", {random_filter={add_levels=25, type="gem"}})

local def = {
[[####################]],
[[#gg#$+*.i..+....$l$#]],
[[#$$$$#+#########R$$#]],
[[#ggg$#I...i+*..#####]],
[[######.I...###...g##]],
[[##ggg#+#####..r...##]],
[[###$##..i.r#..###..#]],
[[##$$+G.....#..RT..>#]],
[[###$##...r.#..###.r#]],
[[##$R$#r....#.R...###]],
[[##iBi##+######....*#]],
[[#######.i..+G..###+#]],
[[##gg$##+##########.#]],
[[##$$$r..####$$rr...#]],
[[##RR..$$####t$$$..R#]],
[[####################]],
}

return def
