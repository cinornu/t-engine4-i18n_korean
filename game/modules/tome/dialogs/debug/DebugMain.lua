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

require "engine.class"
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init()
	self:generateList()
	engine.ui.Dialog.init(self, _t"Debug/Cheat! It's BADDDD!", 1, 1)

	local list = List.new{scrollbar=true, width=400, height=500, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c) if self.list and self.list.chars[c] then self:use(self.list[self.list.chars[c]]) end end}
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	if item.dialog then
		package.loaded["mod.dialogs.debug."..item.dialog] = nil
		local d = require("mod.dialogs.debug."..item.dialog).new(item)
		game:registerDialog(d)
		return
	elseif item.class then
		package.loaded["mod.dialogs.debug."..item.class] = nil
		local d = require("mod.dialogs.debug."..item.class).new(item)
		d:run()
		return
	end

	local act = item.action

	local stop = false
	if act == "godmode" then
		if game.player:hasEffect(game.player.EFF_GODMODE) then
			game.player:removeEffect(game.player.EFF_GODMODE, false, true)
			game.log("#LIGHT_BLUE#God mode OFF")
		else
			game.player:setEffect(game.player.EFF_GODMODE, 1, {})
			game.log("#LIGHT_BLUE#God mode ON")
		end
	elseif act == "demigodmode" then
		if game.player:hasEffect(game.player.EFF_DEMI_GODMODE) then
			game.player:removeEffect(game.player.EFF_DEMI_GODMODE, false, true)
			game.log("#LIGHT_BLUE#Demi-God mode OFF")
		else
			game.player:setEffect(game.player.EFF_DEMI_GODMODE, 1, {})
			game.log("#LIGHT_BLUE#Demi-God mode ON")
		end
	elseif act == "weakdamage" then
		game.player.inc_damage.all = -90
	elseif act == "magic_map" then
		game.log("#LIGHT_BLUE#Revealing Map.")
		game.level.map:liteAll(0, 0, game.level.map.w, game.level.map.h)
		game.level.map:rememberAll(0, 0, game.level.map.w, game.level.map.h)
		for i = 0, game.level.map.w - 1 do
			for j = 0, game.level.map.h - 1 do
				local trap = game.level.map(i, j, game.level.map.TRAP)
				if trap then
					trap:setKnown(game.player, true) trap:identify(true)
					game.level.map:updateMap(i, j)
				end
			end
		end
		game.player:setEffect(game.player.EFF_OMNIVISION, 100, {
			range = 200,
		})
	elseif act == "change_level" then
		game:registerDialog(GetQuantity.new(("Zone: %s"):tformat(game.zone.name), ("Level 1-%s"):tformat(game.zone.max_level), game.level.level, game.zone.max_level, function(qty)
			game:changeLevel(qty)
		end), 1)
	elseif act == "shertul-energy" then
		game.player:grantQuest("shertul-fortress")
		game.player:hasQuest("shertul-fortress"):gain_energy(1000)
	elseif act == "all_traps" then
		for _, file in ipairs(fs.list("/data/general/traps/")) do if file:find(".lua$") then
			local list = mod.class.Trap:loadList("/data/general/traps/"..file)
			for i, e in ipairs(list) do
				print("======",e.name,e.rarity)
				if e.rarity then
					local trap = game.zone:finishEntity(game.level, "trap", e)
					trap:setKnown(game.player, true) trap:identify(true)
					local x, y = util.findFreeGrid(game.player.x, game.player.y, 20, true, {[engine.Map.TRAP]=true})
					if x then
						game.zone:addEntity(game.level, trap, "trap", x, y)
					end
				end
			end
		end end
	elseif act == "remove-all" then
		local d = require"engine.ui.Dialog":yesnocancelPopup(_t"Kill or Remove", _t"Remove all (non-party) creatures or kill them for the player (awards experience and drops loot)?",
			function(remove_all, escape)
				if escape then return end
				local l = {}
				for uid, e in pairs(game.level.entities) do
					if e.__is_actor and not game.party:hasMember(e) then l[#l+1] = e end
				end
				local count = 0
				for i, e in ipairs(l) do
					if remove_all then
						game.log("#GREY#Removing [%s] %s at (%s, %s)", e.uid, e.name, e.x, e.y)
						game.level:removeEntity(e)
					else
						game.log("#GREY#Killing [%s] %s at (%s, %s)", e.uid, e.name, e.x, e.y)
						e:die(game.player, "By Cheating!")
					end
					count = count + 1
				end
				game.log("#LIGHT_BLUE#%s %d creatures.", remove_all and _t"Removed" or _t"Killed", count)
			end
		, _t"Remove", _t"Kill", _t"Cancel", false)
	elseif act == "all-ingredients" then
		game.party:giveAllIngredients(100)
		-- Gems count too
		for def, od in pairs(game.zone.object_list) do
			if type(def) == "string" and not od.unique and od.rarity and def:find("^GEM_") then
				local o = game.zone:finishEntity(game.level, "object", od)
				o:identify(true)
				game.player:addObject("INVEN", o)
				game.player:sortInven()
			end
		end
	else
		self:triggerHook{"DebugMain:use", act=act}
	end
end
		
-- Ideas:
-- force reload all shops
function _M:generateList()
	local list = {}

	list[#list+1] = {name=_t"Change Zone", dialog="ChangeZone"}
	list[#list+1] = {name=_t"Change Level", action="change_level"}
	list[#list+1] = {name=_t"Reveal all map", action="magic_map"}
	list[#list+1] = {name=_t"Toggle Demi-Godmode", action="demigodmode"}
	list[#list+1] = {name=_t"Toggle Godmode", action="godmode"}
	list[#list+1] = {name=_t"Alter Faction", dialog="AlterFaction"}
	list[#list+1] = {name=_t"Summon a Creature", dialog="SummonCreature"}
	list[#list+1] = {name=_t"Create Items", dialog="CreateItem"}
	list[#list+1] = {name=_t"Create a Trap", dialog="CreateTrap"}
	list[#list+1] = {name=_t"Grant/Alter Quests", dialog="GrantQuest"}
	list[#list+1] = {name=_t"Advance Player", dialog="AdvanceActor"}
	list[#list+1] = {name=_t"Remove or Kill all creatures", action="remove-all"}
	list[#list+1] = {name=_t"Give Sher'tul fortress energy", action="shertul-energy"}
	list[#list+1] = {name=_t"Give all ingredients", action="all-ingredients"}
	list[#list+1] = {name=_t"Weakdamage", action="weakdamage"}
	list[#list+1] = {name=_t"Spawn Event", dialog="SpawnEvent"}
	list[#list+1] = {name=_t"Endgamify", class="Endgamify"}
	list[#list+1] = {name=_t"Reload/regenerate Zone and level", class="ReloadZone"}
	list[#list+1] = {name=_t"Automatically Clear Zones", class="AdvanceZones"}
	self:triggerHook{"DebugMain:generate", menu=list}

	local chars = {}
	for i, v in ipairs(list) do
		v.name = self:makeKeyChar(i)..") "..v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
