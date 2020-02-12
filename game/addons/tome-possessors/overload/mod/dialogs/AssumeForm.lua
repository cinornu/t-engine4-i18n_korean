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
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local ActorFrame = require "engine.ui.ActorFrame"
local List = require "engine.ui.List"
local Button = require "engine.ui.Button"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor, t, mode, params)
	self.params = params or {}
	self.actor = actor
	self.talent = t
	self.mode = mode
	local title, ok_button = _t"Assume Form", _t"Possess Body"
	local helptext = _t"#SLATE##{italic}#Choose which body to assume. Bodies can never be healed and once they reach 0 life they are permanently destroyed."
	if mode == "minion" then
		title, ok_button = _t"Create Minion", _t"Summon"
		helptext = _t"#SLATE##{italic}#Choose which body to summon. Once the effect ends the body will be lost."
	elseif mode == "cannibalize" then
		title, ok_button = _t"Cannibalize Body", _t"Cannibalize"
		helptext = _t"#SLATE##{italic}#Choose which body to cannibalize. The whole stack of clones will be destroyed."
	elseif mode == "destroy" then
		title, ok_button = _t"Destroy Body", _t"Destroy Body"
		helptext = _t"#SLATE##{italic}#Choose which body to destroy."
	end

	Dialog.init(self, title, 680, 500)

	self:generateList()
	if #self.list == 0 then game.logPlayer(actor, "You have no bodies to use.") self.__refuse_dialog = true return end

	self.c_list = List.new{scrollbar=true, width=300, height=self.ih - 5, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_leed=true, auto_height=true, text=helptext}
	self.actorframe = ActorFrame.new{actor=self.actor, w=64, h=64, tiles=game.level.map.tiles}
	self.c_ok = Button.new{text=ok_button, fct=function() self:use(self.c_list.list[self.c_list.sel]) end}
	self.c_destroy = Button.new{text=_t"Discard Body", fct=function() self:destroyBody(self.c_list.list[self.c_list.sel]) end}
	self.c_desc = TextzoneList.new{scrollbar=true, width=help.w, height=self.ih - help.h - 40 - self.actorframe.h - self.c_destroy.h}
	if mode == "destroy" then self.c_destroy.hide = true end

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=help},
		{right=(help.w - self.actorframe.w) / 2, top=help.h + 40, ui=self.actorframe},
		{right=0, top=self.actorframe, ui=self.c_desc},
		{left=0, bottom=0, ui=self.c_ok},
		{right=0, bottom=0, ui=self.c_destroy},
	}
	self:setupUI(false, false)

	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}

	self:select(self.list[1])
end

-- Alternatively, could for exit from body when destroyed
function _M:destroyBody(item)
	if not item then end
	local function del(all)
		self.actor:talentDialogReturn(nil)
		self.actor:callTalent(self.actor.T_BODIES_RESERVE, "decreaseUse", item.body, all)
		game:unregisterDialog(self)
	end
	if self.actor:callTalent(self.actor.T_BODIES_RESERVE, "usesLeft", item.body) > 1 then
		self:yesnocancelPopup(("Destroy: %s"):tformat(item.name), _t"Destroy the most damage copy or all?", function(r, cancel) if not cancel then del(not r) end end, _t"Most damaged", _t"All", _t"Cancel")
	else
		self:yesnoPopup(("Destroy: %s"):tformat(item.name), _t"Destroy it?", function(r) if r then del(true) end end, _t"Destroy", _t"Cancel")
	end
end

function _M:hasEnoughTalentSlots(body)
	local available_talent_slots = self.actor:callTalent(self.actor.T_FULL_CONTROL, "getNbTalents")
	if body.__possessor_talent_slots_config then return #body.__possessor_talent_slots_config <= available_talent_slots end
	for tid, lev in pairs(body.talents) do
		local t = self.actor:getTalentFromId(tid)
		if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, true) then
			if available_talent_slots > 0 then
				available_talent_slots = available_talent_slots - 1
			else
				return false
			end
		end
	end
	return true
end

function _M:use(item)
	if not item then end
	if self.mode == "destroy" then
		if item.body._in_possession then
			game.log("#AQUAMARINE#You cannot destroy a body you are currently possessing.")
			return
		end
		self:destroyBody(item)
	elseif self.mode == "minion" and item.body._in_possession and item.uses <= 1 then
		game.log("#AQUAMARINE#You are already using that body!")
		return
	elseif self.mode ~= "possess" or self:hasEnoughTalentSlots(item.body) then
		self.actor:talentDialogReturn(item.body)
		game:unregisterDialog(self)
	else
		package.loaded['mod.dialogs.AssumeFormSelectTalents'] = nil
		local AssumeFormSelectTalents = require "mod.dialogs.AssumeFormSelectTalents"
		game:registerDialog(AssumeFormSelectTalents.new(self, self.actor, item.body, function()
			self.actor:talentDialogReturn(item.body)
			game:unregisterDialog(self)
		end))
	end
end

function _M:select(item)
	if not self.actorframe or not item then return end
	self.actorframe:setActor(item.body)
	self.c_desc:switchItem(item.desc, item.desc)
end

function _M:generateList()
	local list = {}

	local function filter(body)
		if self.params.filter_rank and body.body.rank < self.params.filter_rank then return false end
		if self.params.exclude_body and body.body == self.params.exclude_body then return false end
		return true
	end

	for _, body in ipairs(self.actor.bodies_storage) do if filter(body) then
		local _, rankcolor = body.body:TextRank()
		local uses = body.uses
		local name = ("%s%s (level %d) [Uses: %s]"):tformat(rankcolor, body.body:getName(), body.body.level, uses)
		local ts = name:toTString() -- ts:add(true)
		if body.body._in_possession then
			ts:add({"color", "GOLD"}, _t" **ACTIVE**")
		end
		ts:add(true)
		ts:add({"color", 255, 0, 0}, _t"Life: ", math.ceil(body.body.life).."/"..math.ceil(body.body.max_life), true)
		ts:add(_t"#FFD700#Accuracy#FFFFFF#: ", body.body:colorStats("combatAttack"), "  ")
		ts:add(_t"#0080FF#Defense#FFFFFF#:  ", body.body:colorStats("combatDefense"), true)
		ts:add(_t"#FFD700#P. power#FFFFFF#: ", body.body:colorStats("combatPhysicalpower"), "  ")
		ts:add(_t"#0080FF#P. save#FFFFFF#:  ", body.body:colorStats("combatPhysicalResist"), true)
		ts:add(_t"#FFD700#S. power#FFFFFF#: ", body.body:colorStats("combatSpellpower"), "  ")
		ts:add(_t"#0080FF#S. save#FFFFFF#:  ", body.body:colorStats("combatSpellResist"), true)
		ts:add(_t"#FFD700#M. power#FFFFFF#: ", body.body:colorStats("combatMindpower"), "  ")
		ts:add(_t"#0080FF#M. save#FFFFFF#:  ", body.body:colorStats("combatMentalResist"), true)
		ts:add({"color", "WHITE"})
		ts:add(_t"#00FF80#Str/Dex/Con#FFFFFF#:  ", body.body:getStr().."/"..body.body:getDex().."/"..body.body:getCon(), true)
		ts:add(_t"#00FF80#Mag/Wil/Cun#FFFFFF#:  ", body.body:getMag().."/"..body.body:getWil().."/"..body.body:getCun(), true)
		ts:add({"color", "WHITE"})

		if body.body._cannibalize_penalty then
			ts:add({"color", "CRIMSON"}, ("Cannibalize penalty: %d%%"):tformat(100 - body.body._cannibalize_penalty * 100), {"color", "WHITE"}, true)
		end

		local resists = tstring{}
		ts:add({"color", "ANTIQUE_WHITE"}, _t"Resists: ")
		local first = true
		for t, v in pairs(body.body.resists) do
			if t == "all" or t == "absolute" then
				if first then first = false else ts:add(", ") end
				ts:add({"color", "LIGHT_BLUE"}, tostring(math.floor(v)) .. "%", " ", {"color", "LAST"}, t)
			elseif type(t) == "string" and math.abs(v) >= 20 then
				local res = tostring ( math.floor(body.body:combatGetResist(t)) ) .. "%"
				if first then first = false else ts:add(", ") end
				if v > 0 then
					ts:add({"color", "LIGHT_GREEN"}, res, " ", {"color", "LAST"}, DamageType:get(t).name)
				else
					ts:add({"color", "LIGHT_RED"}, res, " ", {"color", "LAST"}, DamageType:get(t).name)
				end
			end
		end
		ts:add(true)

		ts:add(_t"Hardiness/Armour: ", tostring(math.floor(body.body:combatArmorHardiness())), '% / ', tostring(math.floor(body.body:combatArmor())), true)
		ts:add(_t"Size: ", {"color", "ANTIQUE_WHITE"}, body.body:TextSizeCategory(), {"color", "WHITE"}, true)
	
		if (150 + (body.body.combat_critical_power or 0) ) > 150 then
			ts:add(_t"Critical Mult: ", ("%d%%"):format(150 + (body.body.combat_critical_power or 0) ), true )
		end

		ts:add({"color", "WHITE"})
		local retal = 0
		for k, v in pairs(body.body.on_melee_hit) do
			if type(v) == "number" then retal = retal + v
			elseif type(v) == "table" and type(v.dam) == "number" then retal = retal + v.dam
			end
		end
		if retal > 0 then ts:add(_t"Melee Retaliation: ", {"color", "RED"}, tostring(math.floor(retal)), {"color", "WHITE"}, true ) end

		ts:add(true, {"color", "ORANGE"}, _t"Passive Talents: ",{"color", "WHITE"})
		for tid, lvl in pairs(body.body.talents) do
			local t = body.body:getTalentFromId(tid)
			if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, false) then
				ts:add(true, "- ", {"color", "LIGHT_GREEN"}, ("%s (%0.1f)"):format(t.name or "???",body.body:getTalentLevel(t) ), {"color", "WHITE"} )
			end
		end
		if ts[#ts-1] == _t"Passive Talents: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

		ts:add(true, {"color", "ORANGE"}, _t"Active Talents: ",{"color", "WHITE"})
		for tid, lvl in pairs(body.body.talents) do
			local t = body.body:getTalentFromId(tid)
			if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, true) then
				ts:add(true, "- ", {"color", "LIGHT_GREEN"}, ("%s (%0.1f)"):format(t.name or "???",body.body:getTalentLevel(t) ), {"color", "WHITE"} )
			end
		end
		if ts[#ts-1] == _t"Active Talents: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

		local d = {
			body = body.body,
			uses = uses,
			name = name,
			sortname = body.body.name,
			desc = ts,
		}
		list[#list+1] = d
	end end
	table.sort(list, "sortname")

	self.list = list
end
