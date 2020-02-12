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
local ActorFrame = require "engine.ui.ActorFrame"
local Textbox = require "engine.ui.Textbox"
local ListColumns = require "engine.ui.ListColumns"
local Particles = require "engine.Particles"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(player)
	self.actor = player
	self.actor.shimmer_sustains_hide = self.actor.shimmer_sustains_hide or {}

	Dialog.init(self, _t"Shimmer: Remove Sustains Effects", 680, 500)

	self:generateList()

	self.c_list = ListColumns.new{columns={
		{name=_t"Name", width=80, display_prop="name", sort="sortname"},
		{name=_t"Active", width=20, display_prop="active", sort="active"},
	}, hide_columns=true, scrollbar=true, width=300, height=self.ih - 5, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local donatortext = ""
	if not profile:isDonator(1) then donatortext = _t"\n#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#" end
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_bleed=true, auto_height=true, text=_t[[#{bold}##CRIMSON#WARNING: this is an EXPERIMENTAL feature. It may explode!#LAST##{normal}#
Sustains auras with name in #YELLOW#yellow#LAST# can not be automatically turned back on if disabled. After turning them on here, you need to unsustain and resustain them manually.

#{bold}#This is a purely cosmetic change.#{normal}#]]..donatortext}
	local actorframe = ActorFrame.new{actor=self.actor, w=128, h=128}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=help},
		{right=(help.w - actorframe.w) / 2, vcenter=help.h / 2, ui=actorframe},
	}
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}
end

--- STATIC! DONT USE SELF!
function _M:removeAura(actor, tid, p)
	if not p or type(p) ~= "table" then return end

	local function work(over)
		local list = {}
		for k, e in pairs(over) do
			if type(k) == "string" and type(e) == "table" and k:find("particle") and e.isClassName and e:isClassName("engine.Particles") then
				list[k] = e
			end
		end

		for k, e in pairs(list) do
			actor:removeParticles(e)
			over[k] = actor:addParticles(Particles.new("invisible", 1))
		end
	end

	work(p)
	work(p.__tmpparticles or {})
end

--- STATIC! DONT USE SELF!
function _M:hasRemovableAuras(actor)
	for tid, p in pairs(actor.sustain_talents) do
		if self:checkAura(actor, tid) then return true end
	end
	return false
end

function _M:toggleAura(tid)
	local p = self.actor.sustain_talents[tid]
	local t = self.actor:getTalentFromId(tid)

	if not self.actor.shimmer_sustains_hide[tid] then
		self.actor.shimmer_sustains_hide[tid] = true
		self:removeAura(self.actor, tid, p)
	else
		self.actor.shimmer_sustains_hide[tid] = false
		if not t.no_sustain_autoreset then
			self.actor:forceUseTalent(tid, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, talent_reuse=true, silent=true})
			self.actor:forceUseTalent(tid, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, talent_reuse=true, silent=true})
		end
	end

	self:generateList()
end

--- STATIC! DONT USE SELF!
function _M:checkAura(actor, tid)
	local p = actor.sustain_talents[tid]

	local ok = false
	local function work(over)
		local list = {}
		for k, e in pairs(over) do
			if type(k) == "string" and type(e) == "table" and k:find("particle") and e.isClassName and e:isClassName("engine.Particles") then
				ok = true break
			end
		end
	end

	work(p)
	work(p.__tmpparticles or {})
	return ok
end

function _M:use(item)
	if not item then end

	if profile:isDonator(1) then
		self:toggleAura(item.tid)
	else
		Dialog:yesnoPopup(_t"Donator Cosmetic Feature", _t"This cosmetic feature is only available to donators/buyers.", function(ret) if ret then
			game:registerDialog(require("mod.dialogs.Donation").new(_t"shimmer ingame"))
		end end, _t"Donate", _t"Cancel")
	end
end

function _M:select(item)
	if not item then end
end

function _M:generateList()
	local list = {}

	for tid, p in pairs(self.actor.sustain_talents) do
		if self:checkAura(self.actor, tid) then
			local t = self.actor:getTalentFromId(tid)
			local d = {
				tid = tid,
				name = (t.no_sustain_autoreset and "#YELLOW#" or "")..self.actor:getTalentFromId(tid).name,
				sortname = self.actor:getTalentFromId(tid).name,
				active = self.actor.shimmer_sustains_hide[tid] and _t"#LIGHT_RED#no" or _t"#LIGHT_GREEN#yes",
			}
			list[#list+1] = d
		end
	end
	table.sort(list, "sortname")

	self.list = list
	if self.c_list then self.c_list:setList(list) end
end
