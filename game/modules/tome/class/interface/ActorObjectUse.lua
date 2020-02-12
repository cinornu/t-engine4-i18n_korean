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
local Talents = require "engine.interface.ActorTalents"
local ActorInventory = require "engine.interface.ActorInventory"

module(..., package.seeall, class.make)
--[[
Interface for NPC (non-player controlled actors) to use objects with activatable powers
When a usable object is added to an Actor inventory (and can be activated -- generally worn in the appropriate slot, .no_inventory_access not true), the Actor may get a talent that can be activated to use the power.
This talent is similar to normal talents, but translates the object definition as needed for NPC use.
This talent's .on_pre_use function includes checks for the object being off cooldown, etc.
The activatable object may have either .use_power (most uniquely defined powers), .use_simple (uniquely defined, mostly for consumables), or .use_talent (many charms and other objects that activate a talent as their power).
If more than one of the fields is defined only one will be used: use_power before use_simple before use_talent.
Energy use matches the object (based on standard action speed).
Objects that use a talent for their power generally don't need any extra parameters, but use_power and use_simple must include extra info (range, radius, target, tactical, requires_target) for the ai to use them properly.

Objects with a .use_power field are usable unless .no_npc_use (which may be a function(obj, who)) is true.
For these items:
	use_power = {
		name = constant or function(object, who), description of the power for the user
		power = number, power points used when activated
		use = function(object, who), called when the object is used, should include all effects and special log messages
		target = table or function(object, who), targeting parameters (interpreted by engine.Target:getType and used by the AI when targeting the power)
		requires_target<optional> = boolean or function(object, who), if true, the ai will not use the power if its target is out of range, should generally be false for powers that target the user
		tactical = tactics table for interpretation by the tactical AI (mod.ai.tactical.lua)
			(may be a function(object, who, aitarget) which returns a table), format:
			{TACTIC1 = constant or function(who, t, aitarget),
			TACTIC2 = constant or function(who, t, aitarget), ...}
			each field uses the same format as talents, where t is the talent defined here
			(See mod.class.interface.ActorAI "==== TALENT TACTICAL TABLES ====" for an explanation of how to construct tactical tables.)
		range<optional> = number or function(object, who), should be defined here to allow the AI to determine the range of the power for targeting other Actors with the power, defaults to 1
		radius<optional> = number or function(object, who), as range, defaults to 0
		on_pre_use<optional> = function(object, who, silent, fake), optional function (similar to talent.on_pre_use, to test if the power is usable via the talents defined here (return true to allow use)
		on_pre_use_ai<optional> = function(object, who, silent, fake), like on_pre_use, but only called by the AI, generally used to make the ai smarter by telling it when not to use the power
		talent_level<optional, integer or function(object, who)> = the effective talent level of the power
	}
	The raw talent level of the activation talent(defined here) equals the material level of the object or 1 by default.

Objects with a .use_simple field (uniquely defined, mostly for consumables), are not usable unless .allow_npc_use (which can be a function(object, who) is true or the .tactical field is defined.
They otherwise use the same format as .use_power.

Objects with a .use_talent field use a defined talent as their power.  They are usable if .allow_npc_use (which can be a function(object, who)) is true or talent.no_npc_use is not true and use_talent.no_npc_use (may be a function(object, who)) is not true
For these items:
	use_talent = {
		id = string, talent_id to use (i.e. Talents.T_ILLUMINATE)
		level = <integer or function(object, who)>, raw talent level for the power (uses the user's mastery levels)
		power = number, power points used when activated
		on_pre_use<optional> = function(who, t), override talent.on_pre_use function, t matches talent_id
		on_pre_use_ai<optional> = function(who, t), override talent.on_pre_use_ai function, t matches talent_id
		message<optional> = function(who, t), override talent use message if any, t matches talent_id
	}
	The raw talent level of the activation talent equals the talent level specified in use_talent.
--]]

_M.base_object_talent_name = "Activate Object"
_M.max_object_use_talents = 50 --(allows for approximately 15 items worn and 35 items carried.)

--- Generate an object use talent name
-- returns tid, short_name
local useObjectTalentId = function(base_name, num)
	num = num or 1
	base_name = base_name or _M.base_object_talent_name
	local short_name = base_name:upper():gsub("[ ]", "_").."_"..num
	return "T_"..short_name, short_name
end

--- Init object use tables
function _M:init(t)
	self.object_talent_data = self.object_talent_data or {}
end

--- call a function within an object talent
-- returns values from the object data table, (possibly defaulting to those specified in a talent definition if appropriate)
-- @param tid = talent id (object use talents)
-- @param what = property to compute/retrieve
-- @return what(self, t, ...) or what(obj, who, ...) for powers defined as talents or in the object code respectively
function _M:callObjectTalent(tid, what, ...)
	local data = self.object_talent_data and self.object_talent_data[tid]
	if not data then return end
	local item = data[what]
	
	if data.tid then -- defined by a talent, functions(self, t, ...) format (may be overridden)
		local t = self:getTalentFromId(data.tid)
		item = item or t[what]
		if type(item) == "function" then
			data.old_talent_level = self.talents[data.tid]; self.talents[data.tid] = data.talent_level
			local ok, ret = pcall(item, self, t, ...)
			self.talents[data.tid] = data.old_talent_level; data.old_talent_level = nil
			if ok then return ret
			else
				error(ret)
				return 
			end
		else
			return item
		end
	else -- defined in object code, functions(obj, who, ...) format
		if type(item) == "function" then
			return item(data.obj, self, ...)
		else
			return item
		end
	end
end

-- base Object Activation talent template
_M.useObjectBaseTalent ={
	name = _M.base_object_talent_name,
	type = {"misc/objects", 1},
	points = 1,
	image = "talents/charm_mastery.png", --Note:displayentity is not a function
	hide = "always",
	no_auto_hotkey = true,
	never_fail = true, -- most actor status effects will not prevent use
	innate = true, -- make sure this talent can't be put on cooldown by other talents or effects
	display_name = function(self, t)
		local data = self.object_talent_data and self.object_talent_data[t.id]
		if not (data and data.obj and data.obj:isIdentified()) then return _t"Activate an object" end
		local objname = data.obj:getName({no_add_name = true, do_color = true})
		return ("Activate: %s"):tformat(objname)
	end,
	no_message = true, --messages handled by object code or action function
	is_object_use = true, -- flag for npc control and removing from prompts
	no_energy = function(self, t) -- energy use based on object
		return self:callObjectTalent(t.id, "no_energy")
	end,
	getObject = function(self, t)
		return self.object_talent_data and self.object_talent_data[t.id] and self.object_talent_data[t.id].obj
	end,
	cycle_time = function(self, t) -- how long until the talent(object) can be used, starting from 0 power (for automatic talents checks)
		local reduce = 100 - util.bound(self:attr("use_object_cooldown_reduce") or 0, 0, 100)
		local o = t.getObject(self, t)
		local need = ((o.use_power and o.use_power.power) or (o.use_talent and o.use_talent.power) or 0)*reduce/100
		return math.ceil(need/((o.power_regen and o.power_regen > 0 and o.power_regen) or 1))
	end,
	on_pre_use = function(self, t, silent, fake) -- test for item usability, not on cooldown, etc.
		if self.no_inventory_access then return end
		local data = self.object_talent_data
		if data.cleanup then self:objectTalentCleanup() end
		data = data[t.id]
		if not data then
			print("[ActorObjectUse] ERROR: Talent ", t.name, " has no object data")
			return false
		end
		local o = data.obj
		if not o then
			print("[ActorObjectUse] ERROR: Talent ", t.name, " has no object")
			return false
		end
		local cooldown = o:getObjectCooldown(self) -- disable while object is cooling down
		if cooldown and cooldown > 0 then
			return false
		end
		local useable, msg = o:canUseObject(who)
		if not useable and not (silent or fake) then
			game.logPlayer(self, msg)
			return false
		end
		if data.on_pre_use or (data.tid and self.talents_def[data.tid].on_pre_use) then
			return self:callObjectTalent(t.id, "on_pre_use", silent, fake)
		end
		return true 
	end,
	on_pre_use_ai = function(self, t, silent, fake) -- called as an extra check for NPC use
		local data = self.object_talent_data and self.object_talent_data[t.id]
		if data and (data.on_pre_use_ai or (data.tid and self.talents_def[data.tid].on_pre_use_ai)) then
			return self:callObjectTalent(t.id, "on_pre_use_ai", silent, fake)
		end
		return true
	end,
	mode = "activated",  -- Assumes all abilities are activated
	range = function(self, t)
		return self:callObjectTalent(t.id, "range") or 1
	end,
	radius = function(self, t)
		return self:callObjectTalent(t.id, "radius") or 0
	end,
	proj_speed = function(self, t)
		return self:callObjectTalent(t.id, "proj_speed")
	end,
	requires_target = function(self, t)
		return self:callObjectTalent(t.id, "requires_target")
	end,
--	onAIGetTarget ? return self:callObjectTalent(t.id, "onAIGetTarget")
--	getEnergy=function(self, t) -- speed function?
	target = function(self, t)
		return self:callObjectTalent(t.id, "target")
	end,
	action = function(self, t)
		local data = self.object_talent_data and self.object_talent_data[t.id]
		if not data then return end
		local obj, inven = data.obj, data.inven_id
		local ret
		local co = coroutine.create(function()
			if data.tid then -- replace normal talent use message
				game.logSeen(self, "%s activates %s %s!", self:getName():capitalize(), self:his_her(), data.obj:getName({no_add_name=true, do_color = true}))
				t.message = self:callObjectTalent(t.id, "message")
				local msg = self:useTalentMessage(t)
				t.message = nil
				if msg then game.logSeen(self, "%s", msg) end
			end

			local old_energy = self.energy.value
			ret = obj:use(self, nil, data.inven_id, data.slot)
			self.energy.value = old_energy -- postUseTalent handles energy use
			if ret and ret.used then
				if ret.destroy then -- destroy the item after use
					local _, item = self:findInInventoryByObject(self:getInven(data.inven_id), data.obj)
					if item then self:removeObject(data.inven_id, item) end
				end
			else
				return
			end
		end)
		coroutine.resume(co)
		return ret and ret.used
	end,
	info = function(self, t)
		local o = t.getObject(self, t)
		if not (o and o:isIdentified()) then return _t"Activate an object." end
		local objname = o:getName({do_color = true}) or _t"(unknown object)"
		local usedesc = o and o:getUseDesc(self) or ""
		return ([[Use %s:

%s]]):tformat(objname, usedesc)
	end,
	short_info = function(self, t)
		local obj = t.getObject(self, t)
		return ([[Activate %s]]):tformat(obj and obj:getName({do_color = true}) or _t"nothing")
	end,
}

-- define object use talent based on number
-- defines a new talent if it doesn't already exist
function _M:useObjectTalent(base_name, num)
	base_name = base_name or _M.base_object_talent_name
	local tid, short_name = useObjectTalentId(base_name, num)
	local t = Talents:getTalentFromId(tid)
	if not t then -- define a new talent
		t = table.clone(self.useObjectBaseTalent)
		t.id = tid
		t.short_name = short_name
		t.no_unlearn_last = true
		Talents:newTalent(t)
		-- defined here after parsing in data.talents.lua
		t.tactical = function(self, t, ...)
			return self:callObjectTalent(t.id, "tactical", ...)
		end
	end
	return t.id, t
end

--- Set up an object for actor use via talent interface
-- @param o = object to set up to use
-- @param inven_id = <optional>id of inventory holding object
-- @param slot = <optional>inventory position of object
-- @param base_name = base object use talent name <"Activate Object">
-- @param returns false or o, talent id, talent level if the item is usable
function _M:useObjectEnable(o, inven_id, slot, base_name)
	print("[ActorObjectUse] useObjectEnable: ", o and o.name or "no name", "by", self.name, "inven/slot", inven_id, slot)
	if not o:canUseObject() or o.lore or (o:wornInven() and not o.wielded and not o.use_no_wear) then -- don't enable certain objects (lore, etc.)
		print("[ActorObjectUse] Object", o.name, o.uid, "is ineligible for talent interface")
		return false
	end
	local tid, t, place
	if not inven_id or not slot then -- find the object if needed
		place, slot, inven_id = self:findInAllInventoriesByObject(o)
		if place ~= o then
			print("[ActorObjectUse] Object", o.name, o.uid, " not in inventory")
			return false
		end
	end
	self.object_talent_data = self.object_talent_data or {} -- for older actors
	local data = self.object_talent_data
	
	local oldobjdata = data[o]

	if oldobjdata then
		if not self:knowTalent(oldobjdata.tid) or (data[oldobjdata.tid] and data[oldobjdata.tid].obj == o) then
			tid = oldobjdata.tid
		end
	end

	local talent_level = false
	if not tid then --find an unused talentid (if possible, rotating through the list of available tids)
		data.last_talent = data.last_talent or 0
		local tries = self.max_object_use_talents
		repeat
			tries = tries - 1
			data.last_talent = data.last_talent%self.max_object_use_talents + 1
			tid = useObjectTalentId(base_name, data.last_talent)
			if not self:knowTalent(tid) then break else tid = nil end
		until tries <= 0
	end
	if not tid then return false end
		
	self:unlearnTalentFull(tid) -- Note clears talent settings
	talent_level = self:useObjectSetData(tid, o) --includes checks for npc usability
	if not talent_level then return false end
	data[tid].inven_id = inven_id
	data[tid].slot = slot
	self:learnTalent(tid, true, talent_level)
	return o, tid, talent_level
end

--- disable object use via talent interface(when object is removed from inventory)
-- @param o = object to disable <optional if tid is specified>
-- @param inven_id = id of inventory holding object <optional>
-- @param slot = inventory position of object <optional>
-- @param tid = talent id to disable <optional, defaults to talent associated with object>
-- if neither o or tid is specified, disables all object use talents
-- @param base_name = base object use talent name <"Activate Object">
function _M:useObjectDisable(o, inven_id, slot, tid, base_name)
	print("[ActorObjectUse] useObjectDisable: ", o and o.name or "no name", "inven/slot", inven_id, slot, "tid", tid)
	self.object_talent_data = self.object_talent_data or {} -- for older actors
	base_name = base_name or _M.base_object_talent_name
	if not (o or tid) then --clear all object use data and unlearn all object use talents
		for i = 1, self.max_object_use_talents do
			tid = useObjectTalentId(base_name, i)
			self:unlearnTalentFull(tid)
		end
		self.object_talent_data = {}
		return
	end
	local data = self.object_talent_data
	if o then
		tid = tid or data[o] and data[o].tid
		if (tid and data[tid] and data[tid].obj) ~= o then tid = nil end
		data.cleanup = data.cleanup or {}  -- set up object to check for cleanup later
		data.cleanup[o]=true
	else
		o = data[tid] and data[tid].obj
	end
	if tid then
		if data[tid] and data[tid].old_talent_level then self.talents[tid] = data[tid].old_talent_level end
		data[tid]=nil
		table.removeFromList(data, tid)
		if o then --keep object use settings (ai_talents, confirm/auto use settings -- referenced by object)
			data[o] = {tid = tid,
				talents_auto = self:isTalentAuto(tid),
				talents_confirm_use = self:isTalentConfirmable(tid),
				ai_talent = self.ai_talents and self.ai_talents[tid],}
				-- update summoner stored_ai_talents
				if self.summoner and self.summoner.stored_ai_talents and self.summoner.stored_ai_talents[self.name] then
					self.summoner.stored_ai_talents[self.name][o] = self.ai_talents and self.ai_talents[tid]
				end
		end
		if self.ai_talents then self.ai_talents[tid] = nil end
		self:setTalentConfirmable(tid, false)
		self:setTalentAuto(tid)
	end
	self:unlearnTalentFull(tid)
end

--- forget settings and object references for objects no longer in the party
function _M:objectTalentCleanup()
	local data = self.object_talent_data
	if not (data and data.cleanup) then return end
	for tid, lev in pairs(self.talents) do
		if self.talents_def[tid] and self.talents_def[tid].is_object_use then
			local o = data[tid] and data[tid].obj
			if not o or not engine.interface.ObjectActivable.canUseObject(o) then
				self:useObjectDisable(o, nil, nil, tid)
			end
		end
	end
	for o, r in pairs(data.cleanup) do
		local found = false
		for j, mem in ipairs(game.party.m_list) do
			if mem:findInAllInventoriesByObject(o) then
				found = true
				break
			end
		end
		if not found then
			print("[ActorObjectUse]", self.name, "Cleaning up: ", o.name, o.uid)
			for j, mem in ipairs(game.party.m_list) do
				-- clean up local stored object data
				if mem.object_talent_data then mem.object_talent_data[o] = nil end
				if mem.ai_talents then mem.ai_talents[o] = nil end
				-- clean up summoner stored_ai_talents object data
				if mem.stored_ai_talents then
					for memname, tt in pairs(mem.stored_ai_talents) do
						tt[o] = nil
					end
				end
			end
		end
	end
	data.cleanup = nil
end

-- debugging transitional this does not check for t.tactical_imp
-- function to call base talent-defined tactical functions from the object talent (with overridden talent level)
local AOUtactical_translate = function(self, t, target, tactic) -- called by mod.ai.tactical
	local data = self.object_talent_data[t.id]
	local tal = self.talents_def[data.tid]
	local tac = tal.tactical and tal.tactical[tactic]
	if type(tac) == "function" then
		data.old_talent_level = self.talents[tal.id]; self.talents[tal.id] = data.talent_level
		local ok, ret = pcall(tac, self, tal, target)
		self.talents[tal.id] = data.old_talent_level; data.old_talent_level = nil
		if ok then return ret
		else
			error(ret)
			return 
		end
	else return tac end
end

--- sets up the object data for the talent
--	@param tid = the talent id
--	@param o = the usable object
--	o.use_talent is usable unless the talent.no_npc_use (boolean or function(self, t)) is true
--	o.use_power is usable unless use_power.no_npc_use (boolean or function(obj, who)) is true
--  o.use_simple is usable if use_simple.allow_npc_use (boolean or function(obj, who)) is true or use_simple.tactical is defined
--	returns raw talent level (for tid) if successful
function _M:useObjectSetData(tid, o)
	self.object_talent_data[tid] = {obj = o}
	if self.object_talent_data[o] then --get object use settings saved previously
		self:setTalentAuto(tid, true, self.object_talent_data[o].talents_auto)
		self:setTalentConfirmable(tid, self.object_talent_data[o].talents_confirm_use)
		-- handle ai_talents weights
		if self.summoner and self.summoner.stored_ai_talents and self.summoner.stored_ai_talents[self.name] and self.summoner.stored_ai_talents[self.name][o] then -- get summoner's tactical weight for this actor and object
			self.ai_talents = self.ai_talents or {}
			self.ai_talents[tid] = self.summoner.stored_ai_talents[self.name][o]
		elseif self.object_talent_data[o].ai_talent then -- get last used tactical weight for this object
			self.ai_talents = self.ai_talents or {}
			self.ai_talents[tid] = self.object_talent_data[o].ai_talent
		end
		self.object_talent_data[o].tid = tid
	else
		self.object_talent_data[o] = {tid = tid}
	end
	
	local data = self.object_talent_data[tid]
	local talent_level = false
	local power
	
	-- assign use data based on object power definition or used talent
	if o.use_power then -- power is a general power
		power = o.use_power
		if not util.getval(power.no_npc_use, o, self) then
			talent_level = util.getval(power.talent_level, o, self) or o.material_level or 1
		end
	elseif o.use_simple then -- Generally for consumables
		power = o.use_simple
		if power.tactical or util.getval(power.allow_npc_use, o, self) then
			talent_level = util.getval(power.talent_level, o, self) or o.material_level or 1
		end
	elseif o.use_talent then -- power is a talent
		local use_talent = o.use_talent
		local t = self:getTalentFromId(use_talent.id)
		if t and t.mode == "activated" and (not t.no_npc_use and not util.getval(use_talent.no_npc_use, o, self) or util.getval(use_talent.allow_npc_use, o, self)) then
			data.tid = use_talent.id
			data.talent_level = util.getval(use_talent.level, o, self)
			data.message = use_talent.message
			data.on_pre_use = use_talent.on_pre_use
			data.on_pre_use_ai = use_talent.on_pre_use_ai
			data.tactical = Talents.aiLowerTacticals(use_talent.tactical or t.tactical) --this clones tables
			if type(data.tactical) == "table" then
				for tact, val in pairs(data.tactical) do
					if type(val) == "function" then
						data.tactical[tact] = AOUtactical_translate
					end
				end
			end
			talent_level = data.talent_level
		end
	else
		print("[ActorObjectUse]: ERROR, object", o.name, o.uid, "has no usable power")
	end
	data.no_energy = o.use_no_energy -- talent speed determined by object
	if not talent_level then
		self.object_talent_data[o] = nil
		data = nil
	elseif power then
		data.on_pre_use = power.on_pre_use
		data.on_pre_use_ai = power.on_pre_use_ai
		data.range = power.range
		data.radius = power.radius
		data.target = power.target
		data.requires_target = power.requires_target
		if power.tactical then
			if type(power.tactical) == "table" then
				data.tactical = Talents.aiLowerTacticals(power.tactical)
			else -- allow tactical table to be a function for general powers
				data.tactical = function(obj, who, ...)
					return obj.use_power.tactical(obj, who, ...)
				end
			end
		end
	end
	return talent_level -- the raw talent level (used as weighting factor in tactical ai)
end
