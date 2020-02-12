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

local class= require "engine.class"
local Numberbox = require "engine.ui.Numberbox"
local Focusable = require "engine.ui.Focusable"
local WithTitle = require "engine.ui.WithTitle"

-- a slider with an integrated numberbox
-- @classmod engine.ui.NumberSlider
module(..., class.inherit(WithTitle, Focusable))

function _M:init(t)
	self.min = t.min or 0
	self.max = t.max or 9999
	self.value = t.value or self.min
	self.step = t.step or 10
	self.on_change = t.on_change
	self.fct = t.fct
	assert(t.size or t.w, "no numberspinner size")
	self.size = t.size
	self.w = t.w

	WithTitle.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()

	self:generateTitle()
	self.left = self:getUITexture("ui/border_hor_left.png")
	self.middle = self:getUITexture("ui/border_hor_middle.png")
	self.right = self:getUITexture("ui/border_hor_right.png")
	self.nbox = Numberbox.new{
		min=self.min,
		max=self.max,
		title="",
		chars = #tostring(self.max) + 1,
		number = self.value,
		fct = function(v) self:onChange() if self.fct then self.fct() end end,
	}

	self.h = math.max(self.nbox.h, self.middle.h)
	self.w = self.w or self.size + self.title_w
	self.size = self.w - self.title_w

	self.key:addBind("ACCEPT", function() self:onChange() if self.fct then self.fct() end end)
	self.key:addCommands{
		_LEFT = function(sym, ctrl, shift, alt, meta, unicode, key) self.nbox.key:receiveKey(sym, ctrl, shift, alt, meta, unicode, false, key) end,
		_RIGHT = function(sym, ctrl, shift, alt, meta, unicode, key) self.nbox.key:receiveKey(sym, ctrl, shift, alt, meta, unicode, false, key) end,
		_UP = function() self.nbox:updateText(self.step) self:onChange() end,
		_DOWN = function() self.nbox:updateText(-self.step) self:onChange() end,
		_PAGEUP = function() self.nbox:updateText(self.step) self:onChange() end,
		_PAGEDOWN = function() self.nbox:updateText(-self.step) self:onChange() end,
	}
	self.key.atLast = function(sym, ctrl, shift, alt, meta, unicode, isup, key) self.nbox.key:receiveKey(sym, ctrl, shift, alt, meta, unicode, isup, key) end

	-- precise click
	local current_button = "none"
	self.mouse:allowDownEvent(true)
	self.mouse:registerZone(self.title_w + self.left.w, 0, self.size - self.left.w - self.right.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if 
			((event == "button" or event == "button-down") and button == "left") or
			(event == "motion" and current_button == "left")
		then
			x = x - self.title_w - self.left.w
			local full = self.size - self.left.w - self.right.w
			local point = util.bound(x, 0, full)
			local delta = self.max - self.min
			if full > 0 then
				local value = point / full * delta
				value = math.floor((value / self.step) + 0.5) * self.step
				self.nbox:updateText(value + self.min - self.value)
				self:onChange()
			end
		end
		if event == "button-down" then current_button = button
		elseif event == "button" then current_button = "none" end
	end, {button=true, move=true}, "precise")
	-- the box
	self.mouse:registerZone(self.title_w + self.left.w, 0, self.size - self.left.w - self.right.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if event == "button-down" then current_button = button
		elseif event == "button" then current_button = "none" end
		if x < self.range[1] or x > self.range[2] then return false end
		self.nbox.mouse:delegate(button, x, y, xrel, yrel, bx, by, button)
	end, nil, "box")
	self.nbox.mouse.delegate_offset_y = (self.h - self.nbox.h) / 2
	-- wheeeeeeee
	local wheelTable = {wheelup = 1 * self.step, wheeldown = -1 * self.step}
	self.mouse:registerZone(self.title_w, 0, self.size, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if event == "button-down" then return false end
		if event ~= "button" or not wheelTable[button] then return false end
		self.nbox:updateText(wheelTable[button])
		self:onChange()
	end, {button=true})
	-- clicking on arrows
	local stepTable = {left = self.step, right = 1}
	self.mouse:registerZone(self.title_w, 0, self.left.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if event == "button-down" then return false end
		if event ~= "button" or not stepTable[button] then return false end
		self.nbox:updateText(-stepTable[button])
		self:onChange()
	end, {button=true}, "left")
	self.mouse:registerZone(self.title_w + self.size - self.right.w, 0, self.right.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if event == "button-down" then return false end
		if event ~= "button" or not stepTable[button] then return false end
		self.nbox:updateText(stepTable[button])
		self:onChange()
	end, {button=true}, "right")

	self:onChange()
end

function _M:on_focus(v)
	game:onTickEnd(function() self.key:unicodeInput(v) end)
	self.nbox:setFocus(v)
	self:onChange()
end

function _M:onChange()
	self.value = util.bound(self.nbox.number, self.min, self.max)
	if self.on_change then self.on_change(self.value) end

	local halfw = self.nbox.w / 2
	local delta = self.max - self.min
	local shift = self.value - self.min
	local prop = delta > 0 and shift / delta or 0.5
	local xmin, xmax = self.left.w + halfw, self.size - self.right.w - halfw
	local nbx = xmin + (xmax - xmin) * prop
	self.range = {self.title_w + nbx - halfw, self.title_w + nbx + halfw}
	local offsety = (self.h - self.nbox.h) / 2

	self.nbox.mouse.delegate_offset_x = self.range[1]
	self.mouse:updateZone("box", self.range[1], offsety, self.range[2] - self.range[1], self.h - 2 * offsety)
end

function _M:display(x, y, nb_keyframes)
	self:displayTitle(x, y, nb_keyframes)
	self:textureToScreen(self.left, x + self.title_w, y + (self.h - self.left.h) / 2)
	self:textureToScreen(self.right, x + self.title_w + self.size - self.right.w, y + (self.h - self.right.h) / 2)
	self.middle.t:toScreenFull(x + self.title_w + self.left.w, y, self.size - self.left.w - self.right.w, self.middle.h, self.middle.tw, self.middle.th)
	self.nbox:display(x + self.range[1], y + (self.h - self.nbox.h) / 2, nb_keyframes)
end

