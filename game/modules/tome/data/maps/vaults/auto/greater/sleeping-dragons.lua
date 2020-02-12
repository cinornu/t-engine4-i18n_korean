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

startx = 4
starty = 7

setStatusAll{no_teleport=true}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}
unique = "sleeping_dragon_vault"
defineTile('o', "WALL")
defineTile('.', "FLOOR")
defineTile('#', "HARDWALL")
defineTile('X', "DOOR_VAULT")

local Talents = require("engine.interface.ActorTalents")
specialList("actor", {
   "/data/general/npcs/cold-drake.lua",
   "/data/general/npcs/fire-drake.lua",
   "/data/general/npcs/storm-drake.lua",
   "/data/general/npcs/venom-drake.lua"
}, true)
local wyrm_types = {
   cold={"cold drake", "ice wyrm"},
   fire={"fire drake", "fire wyrm"},
   storm={"storm drake", "storm wyrm"},
   venom={"venom drake", "venom wyrm"}
}

local wyrm_types_names = {"cold", "fire", "storm", "venom"}
roomCheck(function(room, zone, level, map)
   local wyrm_types_name = rng.table(wyrm_types_names)
   local wyrm_type = wyrm_types[wyrm_types_name]
   local drake_name, wyrm_name = wyrm_type[1], wyrm_type[2]
   for i, e in ipairs(room.npc_list) do -- set up special wyrm rarity
      if not e.wyrm_rarity and e.name == wyrm_name then
         e.wyrm_rarity = e.rarity; e.rarity = nil
      elseif not e.drake_rarity and e.name == drake_name then
         e.drake_rarity = e.rarity; e.rarity = nil
      end
   end
   return true
end)

local check_sleep = function(self)
   if game.level.wyrm_awoken == true then
      return true
   end
   if not game.level.seen_wyrm_awoken then
      game.level.seen_wyrm_awoken = true
      game.log("The dragons here are asleep. You may try to steal their treasure... at your own risk.")
   end
   if not self:hasEffect(self.EFF_DOZING) then
      self:setEffect(self.EFF_DOZING, 999, {})
	  self.energy.value = 0
   end
   return true
end

local aggro_wyrm = function()
   if game.level.wyrm_awoken == true then
      return false
   end
   game.level.wyrm_awoken = true
   for uid, e in pairs(game.level.entities) do
      if e.sleeping_wyrm == true then
         e:removeEffect(e.EFF_DOZING)
         e:setTarget(game.player)
      end
   end
   game.log("#CRIMSON#The dragons awaken from their slumber detecting their loot being stolen!")
   return true
end

local aggro_wyrm_takehit = function(self, value, src)
   self:aggro_wyrm()
   return value
end

local aggro_wyrm_grid = function(chance)
   local g = game.zone.grid_list.FLOOR:clone()
   g.aggro_wyrm_chance = chance
   g.aggro_wyrm = aggro_wyrm
   g.on_move = function(self, x, y, actor, forced)
      if not actor.player then return end
      if forced then return end
      if game.level.wyrm_awoken then return end
      if not rng.percent(self.aggro_wyrm_chance) then return end
      self:aggro_wyrm()
   end
   return g
end
defineTile('1', aggro_wyrm_grid(3), {random_filter={add_levels=25, type="money"}})
defineTile('2', aggro_wyrm_grid(10), {random_filter={add_levels=15, tome_mod="uvault"}})
defineTile('3', aggro_wyrm_grid(33), {random_filter={add_levels=25, tome_mod="gvault"}})
defineTile('W', "FLOOR", nil,
   {entity_mod=function(e)
      e.make_escort = nil
      e.on_seen = check_sleep
      e.on_act = check_sleep
      e.on_takehit = aggro_wyrm_takehit
      e.aggro_wyrm = aggro_wyrm
      e.sleeping_wyrm = true
      return e
   end,
   random_filter={special_rarity="wyrm_rarity",
      add_levels=10,
      random_boss={name_scheme=_t"Sleeping #rng#", force_classes={Wyrmic=true}, class_filter=function(d) return d.power_source and ((d.power_source.nature or d.power_source.technique) and not d.power_source.arcane) and d.name ~= "Wyrmic" end, loot_quality="store", loot_quantity=1, rank=3.5}
      }
   }
)
defineTile('D', "FLOOR", nil,
   {entity_mod=function(e)
      e.make_escort = nil
      e.on_seen = check_sleep
      e.on_act = check_sleep
      e.on_takehit = aggro_wyrm_takehit
      e.aggro_wyrm = aggro_wyrm
      e.sleeping_wyrm = true
      return e
   end,
   random_filter={special_rarity="drake_rarity",
      random_boss={name_scheme=_t"Dozing #rng#", force_classes={Wyrmic=true}, class_filter=function(d) return d.power_source and ((d.power_source.nature or d.power_source.technique) and not d.power_source.arcane) and d.name ~= "Wyrmic" end, nb_classes=1, loot_quality="store", loot_quantity=1, rank=3.5}
      }
   }
)
return {
 [[#########]],
 [[#...W...#]],
 [[#..131..#]],
 [[#..232..#]],
 [[#D.121.D#]],
 [[#..111..#]],
 [[#..o.o..#]],
 [[####X####]],
}