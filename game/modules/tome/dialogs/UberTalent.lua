-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even th+e implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
require "mod.class.interface.TooltipsData"

local Dialog = require "engine.ui.Dialog"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local TalentGrid = require "mod.dialogs.elements.TalentGrid"
local Separator = require "engine.ui.Separator"
local DamageType = require "engine.DamageType"
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(Dialog, mod.class.interface.TooltipsData))

function _M:init(actor, levelup_end_prodigies)
	self.actor = actor
	self.levelup_end_prodigies = levelup_end_prodigies

	self.font = core.display.newFont(FontPackage:getFont("mono_small", "mono"))
	self.font_h = self.font:lineSkip()

	self.actor_dup = actor:clone()
	self.actor_dup.uid = actor.uid -- Yes ...

	Dialog.init(self, ("Prodigies: %s"):tformat(actor:getName()), 800, game.h * 0.9)

	self:generateList()

	self:loadUI(self:createDisplay())
	self:setupUI()

	self.key:addCommands{
	}
	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}

	self.actor:learnTalentType("uber/strength", true)
	self.actor:learnTalentType("uber/dexterity", true)
	self.actor:learnTalentType("uber/constitution", true)
	self.actor:learnTalentType("uber/magic", true)
	self.actor:learnTalentType("uber/willpower", true)
	self.actor:learnTalentType("uber/cunning", true)

	self.fake_evol_attr = 0
	for tid, v in pairs(self.levelup_end_prodigies) do if v then
		local t = self.actor:getTalentFromId(tid)
		if t.is_class_evolution or t.is_race_evolution then
			self.fake_evol_attr = self.fake_evol_attr + 1
			self.actor:attr("has_evolution", 1)
		end
	end end
	self.actor.is_in_uber_dialog = self
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:unload()
	if self.fake_evol_attr > 0 then self.actor:attr("has_evolution", -self.fake_evol_attr) end
	self.actor.is_in_uber_dialog = nil
end

function _M:ignoreUnlocks()
	return false
end

function _M:generateList()
	-- Makes up the list
	local max = 0
	local cols, evocols = {}, {}
	local list, evolist = {}, {}
	for tid, t in pairs(self.actor.talents_def) do
		if t.uber and not t.not_listed then
			if 
			    (
			    	not t.is_class_evolution or
			    	((type(t.is_class_evolution) == "string" and self.actor:hasDescriptor("subclass", t.is_class_evolution))) or
			    	((type(t.is_class_evolution) == "function" and t.is_class_evolution(self.actor, t)))
			    ) and
			    (
			    	not t.is_race_evolution or
			    	((type(t.is_race_evolution) == "string" and self.actor:hasDescriptor("subrace", t.is_race_evolution))) or
			    	((type(t.is_race_evolution) == "function" and t.is_race_evolution(self.actor, t)))
			    ) and
			    (not t.requires_unlock or profile.mod.allow_build[t.requires_unlock] or self:ignoreUnlocks())
			    then
			    	if not t.is_race_evolution and not t.is_class_evolution then
					cols[t.type[1]] = cols[t.type[1]] or {}
					local c = cols[t.type[1]]
					c[#c+1] = t
				else
					evocols[#evocols+1] = t
				end
			end
		end
	end

	-- Handle prodigies
	max = math.max(#cols["uber/strength"], #cols["uber/dexterity"], #cols["uber/constitution"], #cols["uber/magic"], #cols["uber/willpower"], #cols["uber/cunning"])
	for _, s in ipairs{"uber/strength", "uber/dexterity", "uber/constitution", "uber/magic", "uber/willpower", "uber/cunning"} do
		local n = {}
		table.sort(cols[s], function(a,b) return a.name < b.name end)

		for i = 1, max do
			if not cols[s][i] then

			else
				local t = cols[s][i]
				if t.display_entity then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end

				n[#n+1] = {
					rawname = t.name,
					talent = t.id,
					entity=t.display_entity,
					do_shadow = function(item) if not self.actor:canLearnTalent(t) then return true else return false end end,
					color=function(item)
						if self.actor:knowTalent(t) or self.levelup_end_prodigies[t.id] then return {0,255,0} 
						elseif not self.actor:canLearnTalent(t) then return {75,75,75} 
						else return {175,175,175} 
						end
					end,
					status = function(item)
						return tstring{}
					end,
				}
			end
		end

		list[#list+1] = n
	end
	list.max = max

	-- Hande evos
	table.sort(evocols, function(a,b) return a.name < b.name end)
	evolist = {{}, {}, {}, {}, {}, {}}
	evolist.max = 1
	self.has_evos = false
	for i, t in ipairs(evocols) do
		if t.display_entity then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end

		self.has_evos = true
		local n = evolist[(i-1) % 6 + 1]
		n[#n+1] = {
			rawname = t.name,
			talent = t.id,
			entity=t.display_entity,
			do_shadow = function(item) if not self.actor:canLearnTalent(t) then return true else return false end end,
			color=function(item)
				if self.actor:knowTalent(t) or self.levelup_end_prodigies[t.id] then return {0,255,0} 
				elseif not self.actor:canLearnTalent(t) then return {75,75,75} 
				else return {175,175,175} 
				end
			end,
			status = function(item)
				return tstring{}
			end,
		}
		evolist.max = math.max(evolist.max, #n)
	end

	self.list = list
	self.evolist = evolist
end

-----------------------------------------------------------------
-- UI Stuff
-----------------------------------------------------------------

_M.tuttext = _t[[#LIGHT_GREEN#Number available: %d#LAST#
Prodigies are special talents that only the most powerful of characters can attain.%s
All of them require at least 50 in a core stat and many also have more special demands. You can learn a new prodigy at level 25 and 42.]]
_M.evotext = _t"\nEvolutions are special prodigies specific to a class or race. Only one evolution can be choosen, if any are available at all."

function _M:createDisplay()
	self.regentuttext = function() return self.tuttext:format(self.actor.unused_prodigies or 0, self.has_evos and self.evotext or "") end
	self.c_tut = Textzone.new{ width=self.iw, auto_height = true, text=self.regentuttext()}
	
	local vsep = Separator.new{dir="horizontal", size=self.ih - 20 - self.c_tut.h}
	local listsep = Separator.new{dir="vertical", size=370, text=_t"#{bold}##GOLD#Prodigies#{normal}#", text_shadow=1}
	local evosep

	self.c_desc = TextzoneList.new{ focus_check = true, scrollbar = true, pingpong = 20, width=self.iw - 370 - vsep.w - 20, height = self.ih - self.c_tut.h, dest_area = { h = self.ih - self.c_tut.h } }

	if self.has_evos then
		evosep = Separator.new{dir="vertical", size=370, text=_t"#{bold}##LIGHT_STEEL_BLUE#Evolutions#{normal}#", text_shadow=1}
		self.c_evo = TalentGrid.new{
			font = core.display.newFont("/data/font/DroidSans.ttf", 14),
			tiles=game.uiset.hotkeys_display_icons,
			grid=self.evolist,
			width=370, height="auto",
			tooltip=function(item)
				local x = self.display_x + self.uis[2].x + self.uis[2].ui.w
				if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
				local ret = self:getTalentDesc(item), x, nil
				self.c_desc:erase()
				self.c_desc:switchItem(ret, ret)
				return ret
			end,
			on_use = function(item, inc) self:use(item) end,
			no_tooltip = true,
		}
	end
	self.c_list = TalentGrid.new{
		font = core.display.newFont("/data/font/DroidSans.ttf", 14),
		tiles=game.uiset.hotkeys_display_icons,
		grid=self.list,
		width=370, height=self.ih - self.c_tut.h - (self.has_evos and (self.c_evo.h + evosep.h) or 0),
		auto_shrink = true,
		scrollbar = true,
		tooltip=function(item)
			local x = self.display_x + self.uis[2].x + self.uis[2].ui.w
			if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
			local ret = self:getTalentDesc(item), x, nil
			self.c_desc:erase()
			self.c_desc:switchItem(ret, ret)
			return ret
		end,
		on_use = function(item, inc) self:use(item) end,
		no_tooltip = true,
	}

	local ret = {
		{left=0, top=0, ui=self.c_tut},
		{left=0, top=self.c_tut.h, ui=listsep},
		{left=0, top=self.c_tut.h+listsep.h, ui=self.c_list},
		{left=self.c_list, top=self.c_tut.h, ui=vsep},
		{right=0, top=self.c_tut.h, ui=self.c_desc},
	}
	if self.has_evos then
		table.insert(ret, 3, {left=0, top=self.c_tut.h+listsep.h+self.c_list.h, ui=evosep})
		table.insert(ret, 4, {left=0, top=self.c_tut.h+listsep.h+self.c_list.h+evosep.h, ui=self.c_evo})
	end

	return ret
end

function _M:use(item)
	local t = self.actor:getTalentFromId(item.talent)
	if self.actor:knowTalent(item.talent) then
	elseif self.levelup_end_prodigies[item.talent] then
		self.levelup_end_prodigies[item.talent] = false
		self.actor.unused_prodigies = self.actor.unused_prodigies + 1
		if t.is_class_evolution or t.is_race_evolution then
			self.actor:attr("has_evolution", -1)
			self.fake_evol_attr = self.fake_evol_attr - 1
		end
		self.c_tut.text = self.regentuttext()
		self.c_tut:generate()
	elseif (self.actor:canLearnTalent(self.actor:getTalentFromId(item.talent)) and self.actor.unused_prodigies > 0) or config.settings.cheat then
		if not self.levelup_end_prodigies[item.talent] then
			self.levelup_end_prodigies[item.talent] = true
			self.actor.unused_prodigies = math.max(0, self.actor.unused_prodigies - 1)
			if t.is_class_evolution or t.is_race_evolution then
				self.actor:attr("has_evolution", 1)
				self.fake_evol_attr = self.fake_evol_attr + 1
			end
		end
		self.c_tut.text = self.regentuttext()
		self.c_tut:generate()
	else
	end
end

function _M:getTalentDesc(item)
	if not item.talent then return end
	local text = tstring{}

 	text:add({"color", "GOLD"}, {"font", "bold"}, util.getval(item.rawname, item), {"color", "LAST"}, {"font", "normal"})
	text:add(true, true)

	if item.talent then
		local t = self.actor:getTalentFromId(item.talent)
		local req = self.actor:getTalentReqDesc(item.talent)
		text:merge(req)
		if self.actor:knowTalent(t) then
			text:merge(self.actor:getTalentFullDescription(t))
		else
			text:merge(self.actor:getTalentFullDescription(t, 1))
		end
	end

	return text
end
