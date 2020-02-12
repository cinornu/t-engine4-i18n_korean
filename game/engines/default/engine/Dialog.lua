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
require "engine.Tiles"
require "engine.KeyBind"

--- Handles dialog windows
-- @classmod engine.Dialog
module(..., package.seeall, class.make)

tiles = engine.Tiles.new(16, 16)

--- Requests a simple, press any key, dialog
-- @string title Display title
-- @string text the text
-- @func[opt] fct the function to call on dialog close
-- @param[type=?boolean] no_leave set this to true to disable closing of the dialog
function _M:simplePopup(title, text, fct, no_leave)
	local font = core.display.newFont("/data/font/DroidSans.ttf", 14)
	local w, h = font:size(text)
	local tw, th = font:size(title)
	local d = new(title, math.max(w, tw) + 8, h + 25, nil, nil, nil, font)
	if no_leave then
		d:keyCommands{}
	else
		d:keyCommands{__DEFAULT=function() game:unregisterDialog(d) if fct then fct() end end}
		d:mouseZones{{x=0, y=0, w=game.w, h=game.h, norestrict=true, fct=function(b) if b ~= "none" then game:unregisterDialog(d) if fct then fct() end end end, norestrict=true}}
	end
	d.drawDialog = function(self, s)
		s:drawColorStringCentered(self.font, text, 2, 2, self.iw - 2, self.ih - 2)
		self.changed = false
	end
	game:registerDialog(d)
	return d
end

--- Requests a simple, press any key, dialog
-- @string title Display title
-- @string text the text
-- @int w width
-- @func[opt] fct the function to call on dialog close
-- @param[type=?boolean] no_leave set this to true to disable closing of the dialog
function _M:simpleLongPopup(title, text, w, fct, no_leave)
	local font = core.display.newFont("/data/font/DroidSans.ttf", 14)
	local list = text:splitLines(w - 10, font)

	local fh = font:lineSkip()
	local th = font:size(title)
	local d = new(title, w + 8, th + fh * #list + 50, nil, nil, nil, font)
	if no_leave then
		d:keyCommands{}
	else
		d:keyCommands{__DEFAULT=function() game:unregisterDialog(d) if fct then fct() end end}
		d:mouseZones{{x=0, y=0, w=game.w, h=game.h, norestrict=true, fct=function(b) if b ~= "none" then game:unregisterDialog(d) if fct then fct() end end end, norestrict=true}}
	end
	d.drawDialog = function(self, s)
		local h = 4
		local r, g, b
		for i = 1, #list do
			r, g, b = s:drawColorStringBlended(self.font, list[i], 5, h, r, g, b) h = h + th
		end
		self.changed = false
	end
	game:registerDialog(d)
	return d
end

--- Requests a simple yes-no dialog
-- @string title Display title
-- @string text the text
-- @func[opt] fct the function to call on dialog close
-- @string[opt="Yes"] yes_text Text for "yes" button
-- @string[opt="No"] no_text Text for "no" button
function _M:yesnoPopup(title, text, fct, yes_text, no_text)
	local font = core.display.newFont("/data/font/DroidSans.ttf", 14)
	local w, h = font:size(text)
	local tw, th = font:size(title)
	local d = new(title, math.max(w, tw) + 8, h + 75, nil, nil, nil, font)
	d.sel = 0
	d:keyCommands({},
	{
		ACCEPT = function() game:unregisterDialog(d) if fct then fct(d.sel == 0) end end,
		MOVE_LEFT = "MOVE_UP",
		MOVE_RIGHT = "MOVE_DOWN",
		MOVE_UP = function() d.sel = 0 d.changed = true end,
		MOVE_DOWN = function() d.sel = 1 d.changed = true end,
	})
	d:mouseZones{{x=2, y=0, w=d.iw, h=d.ih, fct=function(b, _, _, _, _, x, y)
		d.sel = (x < d.iw / 2) and 0 or 1
		d.changed = true
		if b ~= "none" then game:unregisterDialog(d) if fct then fct(d.sel == 0) end end
	end}}
	d.drawDialog = function(self, s)
		s:drawColorStringCentered(self.font, text, 2, 2, self.iw - 2, 25 - 2)
		if d.sel == 0 then
			s:drawColorStringCentered(self.font, yes_text or _t"Yes", 2, 25, self.iw / 2 - 2, 50 - 2, 0, 255, 255)
			s:drawColorStringCentered(self.font, no_text or _t"No", 2 + self.iw / 2, 25, self.iw / 2 - 2, 50 - 2, 255, 255, 255)
		else
			s:drawColorStringCentered(self.font, yes_text or _t"Yes", 2, 25, self.iw / 2 - 2, 50 - 2, 255, 255, 255)
			s:drawColorStringCentered(self.font, no_text or _t"No", 2 + self.iw / 2, 25, self.iw / 2 - 2, 50 - 2, 0, 255, 255)
		end
		self.changed = false
	end
	game:registerDialog(d)
	return d
end

--- Requests a long yes-no dialog
-- @string title Display title
-- @string text the text
-- @int w width
-- @func[opt] fct the function to call on dialog close
-- @string[opt="Yes"] yes_text Text for "yes" button
-- @string[opt="No"] no_text Text for "no" button
function _M:yesnoLongPopup(title, text, w, fct, yes_text, no_text)
	local font = core.display.newFont("/data/font/DroidSans.ttf", 14)
	local list = text:splitLines(w - 10, font)

	local th = font:lineSkip()
	local d = new(title, w + 8, th * #list + 75, nil, nil, nil, font)
	d.sel = 0
	d:keyCommands({},
	{
		ACCEPT = function() game:unregisterDialog(d) if fct then fct(d.sel == 0) end end,
		MOVE_LEFT = "MOVE_UP",
		MOVE_RIGHT = "MOVE_DOWN",
		MOVE_UP = function() d.sel = 0 d.changed = true end,
		MOVE_DOWN = function() d.sel = 1 d.changed = true end,
	})
	d:mouseZones{{x=2, y=0, w=d.iw, h=d.ih, fct=function(b, _, _, _, _, x, y)
		d.sel = (x < d.iw / 2) and 0 or 1
		d.changed = true
		if b ~= "none" then game:unregisterDialog(d) if fct then fct(d.sel == 0) end end
	end}}
	d.drawDialog = function(self, s)
		local h = 4
		local r, g, b
		for i = 1, #list do
			r, g, b = s:drawColorStringBlended(self.font, list[i], 5, h, r, g, b) h = h + th
		end

		if d.sel == 0 then
			s:drawColorStringCentered(self.font, yes_text or _t"Yes", 2, 10 + h, self.iw / 2 - 2, 50 - 2, 0, 255, 255)
			s:drawColorStringCentered(self.font, no_text or _t"No", 2 + self.iw / 2, 10 + h, self.iw / 2 - 2, 50 - 2, 255, 255, 255)
		else
			s:drawColorStringCentered(self.font, yes_text or _t"Yes", 2, 10 + h, self.iw / 2 - 2, 50 - 2, 255, 255, 255)
			s:drawColorStringCentered(self.font, no_text or _t"No", 2 + self.iw / 2, 10 + h, self.iw / 2 - 2, 50 - 2, 0, 255, 255)
		end
		self.changed = false
	end
	game:registerDialog(d)
	return d
end

--- Create a Dialog
-- @string title Display title
-- @int w width
-- @int h height
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int[opt] alpha transparency
-- @param[opt] font defaults to Droid Sans 14pt
-- @param[opt] showup how long it takes to show up?
function _M:init(title, w, h, x, y, alpha, font, showup)
	self.title = title
	self.controls = { }
	self.tabindex = 0
	self.state = ""
	self.currenttabindex = 0
	self.font = font
	if not font then self.font = core.display.newFont("/data/font/DroidSans.ttf", 14) end
	self.font_h = self.font:lineSkip()

	self:resize(w, h, x, y, alpha)
	if showup ~= nil then
		self.__showup = showup
	else
		self.__showup = 2
	end
end

--- Resize
-- @int w width
-- @int h height
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int[opt] alpha defaults to 220
function _M:resize(w, h, x, y, alpha)
	self.w, self.h = math.floor(w), math.floor(h)
	self.display_x = math.floor(x or (game.w - self.w) / 2)
	self.display_y = math.floor(y or (game.h - self.h) / 2)
	self.surface = core.display.newSurface(w, h)
	self.iw, self.ih = w - 2 * 5, h - 8 - 16 - 3
	self.internal_surface = core.display.newSurface(self.iw, self.ih)
	self.surface:alpha(alpha or 220)
	self.texture, self.texture_w, self.texture_h = self.surface:glTexture()
	self.changed = true
end

--- Renders the dialog
function _M:display()
	if not self.changed then return self.surface end

	local s = self.surface
	self.alpha = self.alpha or 200
	s:erase(0,0,0,self.alpha)

	s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_7.png"), 0, 0)
	s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_9.png"), self.w - 8, 0)
	s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_1.png"), 0, self.h - 8)
	s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_3.png"), self.w - 8, self.h - 8)
	for i = 8, self.w - 9 do
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_8.png"), i, 0)
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_8.png"), i, 20)
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_8.png"), i, self.h - 3)
	end
	for i = 8, self.h - 9 do
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_4.png"), 0, i)
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_4.png"), self.w - 3, i)
	end

	self.font:setStyle("bold")
	local tw, th = self.font:size(self.title)
	s:drawColorStringBlended(self.font, self.title, (self.w - tw) / 2, 4, 255,255,255)
	self.font:setStyle("normal")

	self.internal_surface:erase()
	self:drawDialog(self.internal_surface)
	s:merge(self.internal_surface, 5, 20 + 3)

	-- Update texture
	self.surface:updateTexture(self.texture)

	return self.surface
end

--- texture to screen
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int nb_keyframes number of keyframes
function _M:toScreen(x, y, nb_keyframes)
	-- Draw with only the texture
	if self.__showup then
		local eff = self.__showup_effect or "pop"
		if eff == "overpop" then
			local zoom = self.__showup / 7
			if self.__showup >= 9 then
				zoom = (9 - (self.__showup - 9)) / 7 - 1
				zoom = 1 + zoom * 0.5
			end
			self.texture:toScreenFull(x + (self.w - self.w * zoom) / 2, y + (self.h - self.h * zoom) / 2, self.w * zoom, self.h * zoom, self.texture_w * zoom, self.texture_h * zoom)
			self.__showup = self.__showup + nb_keyframes
			if self.__showup >= 11 then self.__showup = nil end
		else
			local zoom = self.__showup / 7
			self.texture:toScreenFull(x + (self.w - self.w * zoom) / 2, y + (self.h - self.h * zoom) / 2, self.w * zoom, self.h * zoom, self.texture_w * zoom, self.texture_h * zoom)
			self.__showup = self.__showup + nb_keyframes
			if self.__showup >= 7 then self.__showup = nil end
		end
	else
		self.texture:toScreenFull(x, y, self.w, self.h, self.texture_w, self.texture_h)
	end
end

--- Draw the dialog
-- @param s screen
function _M:drawDialog(s)
end

--- register keybind and command
-- @param[type=KeyCommand] t
-- @param[type=KeyBind] b
function _M:keyCommands(t, b)
	self.key = engine.KeyBind.new()
	if t then self.key:addCommands(t) end
	if b then self.key:addBinds(b) end
end

--- create a mouse zone
-- @param[type=boolean] t t.norestrict = true, then allow mouse to move out of zone
-- @param[type=boolean] no_new true = don't create a new mouse
function _M:mouseZones(t, no_new)
	-- Offset the x and y with the window position and window title
	if not t.norestrict then
		for i, z in ipairs(t) do
			if not z.norestrict then
				z.x = z.x + self.display_x + 5
				z.y = z.y + self.display_y + 20 + 3
			end
		end
	end

	if not no_new then self.mouse = engine.Mouse.new() end
	self.mouse:registerZones(t)
end

--- Called when dialog is unloading
function _M:unload()
end
--- Called when dialog is cleaning up
function _M:cleanup()
end

--- Draw a horizontal border
-- @param s screen
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int w width
function _M:drawWBorder(s, x, y, w)
	for i = x, x + w do
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_8.png"), i, y)
	end
end
--- Draw a vertical border
-- @param s screen
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int h height
function _M:drawHBorder(s, x, y, h)
	for i = y, y + h do
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_4.png"), x, i)
	end
end

--- draw a selection list
-- @param s screen
-- @int x absolute x coordinate
-- @int y absolute y coordinate
-- @int hskip height padding
-- @param[type=table] list the list to draw
-- @int[opt=nil] sel the selected item
-- @param[type=?opt|tab|string|func] prop property to display for items (can be table/function/string), Default: toString(item)
-- @int[opt=1] scroll how far down the list are we
-- @int[opt=99999] max max number of entries
-- @param[type=?table] color color of items, defaults to colors.WHITE
-- @param[type=?table] selcolor color of selected item, defaults to colors.CYAN
-- @int[opt] max_size max length of displayed strings
-- @int[opt] cutoff_size max width
-- @param[type=?boolean] scrollbar display a scrollbar?
function _M:drawSelectionList(s, x, y, hskip, list, sel, prop, scroll, max, color, selcolor, max_size, cutoff_size, scrollbar)
	selcolor = selcolor or {0,255,255}
	color = color or {255,255,255}
	max = max or 99999
	scroll = util.bound(scroll or 1, 1, #list)

	if scrollbar then
		if max_size then max_size = max_size - 6 end
		if cutoff_size then cutoff_size = cutoff_size - 6 end
	end

	local by = y
	for i = scroll, math.min(#list, scroll + max - 1) do
		local v = list[i]
		local vc = nil
		if v then
			if type(v) == "table" then vc = v.color end
			if prop and type(v[prop]) == "string" then v = tostring(v[prop])
			elseif prop and type(v[prop]) == "function" then v = tostring(v[prop](v))
			else v = tostring(v) end

			local lines
			if max_size then lines = v:splitLines(max_size, self.font)
			else lines = {v} end
			for j = 1, #lines do
				if sel == i then
					local sx, sy = self.font:size(lines[j])
--					s:erase(selcolor[1]/3, selcolor[2]/3, selcolor[3]/3, 1, x, y, sx, sy)
					s:drawColorStringBlended(self.font, lines[j], x, y, selcolor[1], selcolor[2], selcolor[3], nil, cutoff_size)
				else
					local r, g, b = color[1], color[2], color[3]
					if vc then r, g, b = vc[1], vc[2], vc[3] end
					s:drawColorStringBlended(self.font, lines[j], x, y, r, g, b, nil, cutoff_size)
				end
				y = y + hskip
			end
		end
	end

	if not scrollbar or sel < 1 then return end
	local size = y - 4 - by
	for j = by, y - 4 do
		s:merge(tiles:get(nil, 0,0,0, 0,0,0, "border_4.png"), x + cutoff_size - 4, j)
	end
	self:drawWBorder(s, x + cutoff_size - 3, by + sel * size / #list, 6)
end
