-- TE4 - T-Engine 4
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

--- Handles actors life and death
-- @classmod engine.generator.interface.ActorResource
module(..., package.seeall, class.make)

_M.resources_def = {}

local fast_cache = {}
setmetatable(fast_cache, {__mode="v"})

--- Defines an Actor resource
-- Resources are numeric quantities that decrease in value as the resource is depleted (set params.invert_values to reverse this)
-- Static!
-- This defines for all actors the methods :getResource(), :incResource(), :getMinResource(), :incMinResource(), :getMaxResource(), and :incMaxResource()
-- (where "Resource" = short_name:lower():capitalize())
-- Actors can have self[short_name], self[min_short_name], self[max_short_name], and self[regen_prop (if defined)] initialized on creation by calling ActorResource:init()
-- It is advised to NOT access .resourcename directly and use the get/inc methods to properly handle talent dependencies
-- @param name -- name of the Resource
-- @param short_name -- internal name for the resource, self[short_name] holds the (numeric) resource value
-- @param talent -- talent associated with the resource (generally a resource pool)
-- @param regen_prop -- self[short_name] is incremented by self[regen_prop] when self:regenResources is called
-- @param desc -- textual description of the resource
-- @param min, max -- minimum and maximum values for the resource <0, 100>, Assign false for no limit
-- @param params -- table of additional parameters to merge (last) into the definition table
function _M:defineResource(name, short_name, talent, regen_prop, desc, min, max, params)
	assert(name, "no resource name")
	assert(short_name, "no resource short_name")
	assert(self.resources_def[short_name] == nil, "Attempt to redefine existing resource: "..short_name)
	local minname = "min_"..short_name
	local maxname = "max_"..short_name
	table.insert(self.resources_def, {
		name = name,
		short_name = short_name,
		talent = talent,
		regen_prop = regen_prop,
		invert_values = false, -- resource value decreases as it is consumed by default
		switch_direction = false, -- resource value prefers to go to the min instead of max
		description = desc,
		minname = minname,
		maxname = maxname,
		min = (min == nil) and 0 or min,
		max = (max == nil) and 100 or max,
	})
	self.resources_def[#self.resources_def].id = #self.resources_def
	self.resources_def[short_name] = self.resources_def[#self.resources_def]
	self["RS_"..short_name:upper()] = #self.resources_def
	local def=self.resources_def[short_name]
	def.incFunction = "inc"..short_name:lower():capitalize()
	def.incMinFunction = "incMin"..short_name:lower():capitalize()
	def.incMaxFunction = "incMax"..short_name:lower():capitalize()
	def.getFunction = "get"..short_name:lower():capitalize()
	def.getMinFunction = "getMin"..short_name:lower():capitalize()
	def.getMaxFunction = "getMax"..short_name:lower():capitalize()
	def.sustain_prop = "sustain_"..short_name
	def.drain_prop = "drain_"..def.short_name
	self[def.incFunction] = function(self, v)
		self[short_name] = util.bound(self[short_name] + v, self[minname], self[maxname])
	end
	self[def.incMinFunction] = function(self, v)
		self[minname] = self[minname] + v
		self[def.incFunction](self, 0)
	end
	self[def.incMaxFunction] = function(self, v)
		self[maxname] = self[maxname] + v
		self[def.incFunction](self, 0)
	end
	if talent then -- if there is an associated talent, reference functions return default values
		self[def.getFunction] = function(self)
			if self:knowTalent(talent) then
				return self[short_name]
			else
				return 0
			end
		end
		self[def.getMinFunction] = function(self)
			if self:knowTalent(talent) then
				return self[minname]
			else
				return 0
			end
		end
		self[def.getMaxFunction] = function(self)
			if self:knowTalent(talent) then
				return self[maxname]
			else
				return 0
			end
		end
	else
		self[def.getFunction] = function(self)
			return self[short_name]
		end
		self[def.getMinFunction] = function(self)
			return self[minname]
		end
		self[def.getMaxFunction] = function(self)
			return self[maxname]
		end
	end
	if params then
		table.merge(def, params)
	end
	print("[ActorResource] Defined Resource:", short_name)
end

-- Initialize actor resources (at construction)
function _M:init(t)
	for i, r in ipairs(_M.resources_def) do
		self[r.minname] = t[r.minname] or r.min
		self[r.maxname] = t[r.maxname] or r.max
		self[r.short_name] = t[r.short_name] or (r.switch_direction and self[r.minname] or self[r.maxname])
		if r.regen_prop then
			self[r.regen_prop] = t[r.regen_prop] or 0
		end
	end
end

-- use a lists of resources (no resources are used unless there are enough of all of them)
-- @param costs a table of costs = {resource1 = value1, resource2 = value2, ...}
-- @check if true the available resources will be checked but not depleted
-- @return true if there are/were adequate resources to deplete
function _M:useResources(costs, check)
	local ok = true
	if costs then
		local res_def, avail, invert
		local min, max
		local inc = {}
		-- check for availability of each resource and record increments
		for kind, val in pairs(costs) do -- fatigue effects not applied
			res_def = self.resources_def[kind]
			invert = res_def and res_def.invert_values or false
			avail = res_def and self[res_def.getFunction](self) or util.getval(self['get'..kind:capitalize()], self) or 0
			if invert then
				max = (res_def and self[res_def.maxname]) or (not res_def and util.getval(self['getMax'..kind:capitalize()], self))
				if max and avail + val > max then -- too much
					ok = false
				end
				inc[kind] = val
			else
				min = (res_def and self[res_def.minname]) or (not res_def and util.getval(self['getMin'..kind:capitalize()], self))
				if min and avail - val < min then -- too little
					ok = false
				end
				inc[kind] = -val
			end
			if not ok then return false, kind end
		end
		if ok and not check then -- Adequate resources available, apply the cost(s)
			for kind, val in pairs(inc) do
				res_def = self.resources_def[kind]
				if res_def then
					self[res_def.incFunction](self, val)
				else
					local incFun = self["inc"..kind:capitalize()]
					if incFun then incFun(self, val) else self[kind] = self[kind] + val end
				end
			end
		end
	end
	return ok
end

function _M:recomputeRegenResources()
	if not self._no_save_fields.regenResourcesFast then return end
	local fstr = "return function(self) "

	local r
	for i = 1, #_M.resources_def do
		r = _M.resources_def[i]
		if r.regen_prop and (not r.talent or self:knowTalent(r.talent)) then
			fstr = fstr..("self.%s = util.bound(self.%s + self.%s, self.%s, self.%s) "):format(r.short_name, r.short_name, r.regen_prop, r.minname, r.maxname)
		end
	end

	fstr = fstr.." end"
	if not fast_cache[fstr] then fast_cache[fstr] = loadstring(fstr)() end
	self.regenResourcesFast = fast_cache[fstr]
end

--- Regen resources, should be called in your actor's act() method
function _M:regenResources()
	if self.regenResourcesFast then return self:regenResourcesFast() end

	local r
	for i = 1, #_M.resources_def do
		r = _M.resources_def[i]
		if r.regen_prop then
			self[r.short_name] = util.bound(self[r.short_name] + self[r.regen_prop], self[r.minname], self[r.maxname])
		end
	end
end
