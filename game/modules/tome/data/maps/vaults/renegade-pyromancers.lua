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
   "/data/general/npcs/orc-vor.lua",
   "/data/general/npcs/bird.lua",
   "/data/general/npcs/faeros.lua",
})

specialList("terrain", {
	"/data/general/grids/burntland.lua",
	"/data/general/grids/lava.lua",
	"/data/general/grids/gothic.lua",
	"/data/general/grids/basic.lua",
	"/data/zones/vor-pride/grids.lua",
})

setStatusAll{no_teleport=true}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

local lore = mod.class.Object.new{
	type = "lore", subtype="lore",
	unided_name = _t"scroll", identified=true,
	display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll.png",
	encumber = 0,
	name = _t"How to Summon a Phoenix", lore="renegade-pyromancers-vault",
	desc = _t[[An old and singed scroll, the bottom half burnt off.]],
	level_range = {1, 20},
	rarity = false,
}

defineTile('.', "BURNT_GROUND")
defineTile('T', "LAVA_WALL")
defineTile('L', function() if rng.percent(50) then return "LAVA_FLOOR" else return "BURNT_GROUND" end end)
defineTile('#', "HARDWALL")
defineTile('!', "DOOR_VAULT")
defineTile('B', "GENERIC_BOOK2")

defineTile('*', "BURNT_GROUND", {random_filter={add_levels=15, tome_mod="gvault"}})
defineTile('*', "BURNT_GROUND", {random_filter={add_levels=5, tome_mod="uvault"}})

defineTile('P', "LAVA_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {random_filter={add_levels=22, name = "Phoenix"}})
--fierce guardian being summoned--triple class ultimate faeros
defineTile('F', "LAVA_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {random_filter={add_levels=10, name = "ultimate faeros", random_boss={name_scheme=_t"#rng# the Flamebringer", force_classes={Archmage=true}, nb_classes=2, class_filter=function(d) return d.power_source and (d.power_source.arcane and not d.power_source.technique) and d.name ~= "Archmage" end, ai_move="move_complex", rank=4}}})
defineTile('f', "BURNT_GROUND", nil, {random_filter={add_levels=5, name = "greater faeros"}} )
defineTile('M', "BURNT_GROUND", {random_filter={add_levels=12, tome_mod="uvault"}}, {random_filter={add_levels=7, name = "orc high pyromancer", random_boss={name_scheme=_t"#rng# the Invoker", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.5, force_classes={Archmage=true}}}})
defineTile('m', "BURNT_GROUND", nil, {random_filter={add_levels=5, name = "orc pyromancer"}} )
defineTile('l', "BURNT_GROUND", lore, {random_filter={add_levels=5, name = "orc pyromancer"}} )

if rng.percent(7) then --rare phoenix-7% to show in here plus 35% this vault shows gives 2.5% chance per game for a phoenix from one of these
return {
 [[###########]],
 [[#**Tf.fT**#]],
 [[#lm.LLL.mm#]],
 [[#MB.LPL.BM#]],
 [[#T..LLL..T#]],
 [[#TT.....TT#]],
 [[#+*T...T*+#]],
 [[#####!#####]],
}
else
return {
 [[###########]],
 [[#**Tf.fT**#]],
 [[#mm.LLL.ml#]],
 [[#MB.LFL.BM#]],
 [[#T..LLL..T#]],
 [[#TT.....TT#]],
 [[#+*T...T*+#]],
 [[#####!#####]],
}
end