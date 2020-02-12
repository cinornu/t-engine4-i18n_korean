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
   "/data/general/npcs/fire-drake.lua",
   "/data/general/npcs/storm-drake.lua",
   "/data/general/npcs/cold-drake.lua",
   "/data/general/npcs/venom-drake.lua",
   "/data/general/npcs/orc-gorbat.lua",
})

specialList("terrain", {
	"/data/general/grids/burntland.lua",
	"/data/general/grids/lava.lua",
	"/data/general/grids/mountain.lua",
	"/data/general/grids/ice.lua",
	"/data/general/grids/slime.lua",
	"/data/general/grids/jungle.lua",
	"/data/general/grids/basic.lua",
	"/data/zones/gorbat-pride/grids.lua",
})

setStatusAll{no_teleport=true, vault_only_door_open=true, room_map = {can_open=true}}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

defineTile(',', "FENCE_FLOOR")
defineTile('.', "FENCE_FLOOR")
defineTile('#', "HARDMOUNTAIN_WALL")
defineTile('D', "DOOR")
defineTile('i', "ICY_FLOOR")
defineTile('a', function() if rng.percent(33) then return "LAVA_FLOOR" else return "BURNT_GROUND" end end)
defineTile('l', "CRYSTAL_FLOOR")
defineTile('L', "WALL")
defineTile('e', "SLIME_FLOOR")
defineTile('!', "DOOR_VAULT")
defineTile('|', "MOUNTAIN_WALL")
defineTile('R', "ROCKY_GROUND")

local Talents = require("engine.interface.ActorTalents")
defineTile('W', "FENCE_FLOOR", {random_filter={add_levels=15, tome_mod="uvault"}}, {random_filter={add_levels=15, name = "orc master wyrmic", random_boss={name_scheme=_t"#rng# the Herald", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=3.5, force_classes={Wyrmic=true}}}} )
defineTile('m', "FENCE_FLOOR", {random_filter={add_levels=30, type="money"}}, {random_filter={add_levels=12, name = "orc grand summoner", random_boss={name_scheme=_t"Beastmaster #rng#", nb_classes=0, loot_quality="store", loot_quantity=1, no_loot_randart=true, ai_move="move_complex", rank=3.2, force_classes={Summoner=true}}}} )
defineTile('F', "LAVA_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {entity_mod=function(e) 
		e[#e+1] = resolvers.talents{
			[Talents.T_BLASTWAVE]={base=4, every=12, max=10},
			[Talents.T_BURNING_WAKE]={base=4, every=12, max=12},
			[Talents.T_CLEANSING_FLAMES]={base=3, every=15, max=8},
			[Talents.T_WILDFIRE]={base=3, every=15, max=7},}
			e:resolve()
		 return e end, random_filter={add_levels=25, name = "fire wyrm", random_boss={name_scheme=_t"#rng# the Flame Terror", nb_classes=2, class_filter=function(d) return d.power_source and (d.power_source.arcane) and d.name ~= "Sun Paladin" end, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=4, force_classes={['Sun Paladin']=true}}}} )
defineTile('f', "BURNT_GROUND", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "fire drake"}} )
defineTile('S', "CRYSTAL_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {entity_mod=function(e) 
		e[#e+1] = resolvers.talents{
			[Talents.T_NOVA]={base=4, every=12, max=10},
			[Talents.T_THUNDERCLAP]={base=4, every=12, max=12},
			[Talents.T_HURRICANE]={base=3, every=15, max=8},
			[Talents.T_TEMPEST]={base=3, every=15, max=7},
			[Talents.T_LIVING_LIGHTNING]={base=1, every=20, max=4},}
			e:resolve()
		 return e end, random_filter={add_levels=25, name = "storm wyrm", random_boss={name_scheme=_t"#rng# the Storm Terror", nb_classes=2, class_filter=function(d) return d.power_source and (d.power_source.arcane) and d.name ~= "Archmage" end, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=4, force_classes={Archmage=true}}}} )
defineTile('s', "CRYSTAL_FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "storm drake"}} )
defineTile('C', "ICY_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {entity_mod=function(e) 
		e[#e+1] = resolvers.talents{
			[Talents.T_FREEZE]={base=4, every=12, max=10},
			[Talents.T_SHIVGOROTH_FORM]={base=4, every=12, max=12},
			[Talents.T_BODY_OF_ICE]={base=3, every=15, max=8},
			[Talents.T_UTTERCOLD]={base=3, every=15, max=7},}
			e:resolve()
		 return e end, random_filter={add_levels=25, name = "ice wyrm", random_boss={name_scheme=_t"#rng# the Fozen Terror", nb_classes=2, class_filter=function(d) return d.power_source and (d.power_source.nature or d.power_source.technique) and d.name ~= "Wyrmic" end, loot_quality="store", loot_quantity=1, no_loot_randart=true, loot_unique=true, ai_move="move_complex", rank=4, force_classes={Wyrmic=true}}}} )
defineTile('c', "ICY_FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "cold drake"}} )
defineTile('V', "SLIME_FLOOR", {random_filter={add_levels=25, tome_mod="uvault"}}, {entity_mod=function(e) 
		e[#e+1] = resolvers.talents{
			[Talents.T_INDISCERNIBLE_ANATOMY]={base=4, every=12, max=10},
			[Talents.T_GRAND_ARRIVAL]=3,
			[Talents.T_WILD_SUMMON]=4,
			[Talents.T_ACIDIC_SOIL]={base=3, every=15, max=7},
			[Talents.T_UNSTOPPABLE_NATURE]={base=3, every=15, max=7},}
			e:resolve()
		 return e end, random_filter={add_levels=25, name = "venom wyrm", random_boss={name_scheme=_t"#rng# the Caustic Terror", nb_classes=2, class_filter=function(d) return d.power_source and (d.power_source.nature) and d.name ~= "Oozemancer" end, loot_quality="store", loot_quantity=1, ai_move="move_complex", rank=4, force_classes={Oozemancer=true}}}} )
defineTile('v', "SLIME_FLOOR", {random_filter={add_levels=20, type="money"}}, {random_filter={add_levels=12, name = "venom drake"}} )


return {
   [[,#######################,]],
   [[,#veeeeLve......fLaaaaf#,]],
   [[,#eeeeeDRRRRRRRRRDaaaaa#,]],
   [[,#veevVLWm..R..mWLFfaaf#,]],
   [[,#||||||||||R||||||||||#,]],
   [[,#sllsSLWm..R..mWLCciic#,]],
   [[,#lllllDRRRRRRRRRDiiiii#,]],
   [[,#sllllLsl..R.iicLiiiic#,]],
   [[,###########!###########,]],
   [[,,,,,,,,,,,,,,,,,,,,,,,,,]],
}
