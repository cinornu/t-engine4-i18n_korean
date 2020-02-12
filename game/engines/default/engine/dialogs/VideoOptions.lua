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
local Dialog = require "engine.ui.Dialog"
local TreeList = require "engine.ui.TreeList"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local GetQuantity = require "engine.dialogs.GetQuantity"
local GetQuantitySlider = require "engine.dialogs.GetQuantitySlider"

--- Video Options
-- @classmod engine.dialogs.VideoOptions
module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, _t"Video Options", game.w * 0.8, game.h * 0.8)

	self.c_desc = Textzone.new{width=math.floor(self.iw / 2 - 10), height=self.ih, text=_t""}

	self:generateList()

	self.c_list = TreeList.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 10, scrollbar=true, columns={
		{width=60, display_prop="name"},
		{width=40, display_prop="status"},
	}, tree=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=self.c_desc},
		{hcenter=0, top=5, ui=Separator.new{dir="horizontal", size=self.ih - 10}},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:select(item)
	if item and self.uis[2] then
		self.uis[2].ui = item.zone
	end
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=_t"Display resolution."}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Resolution#WHITE##{normal}#"):toTString(), status=function(item)
		return config.settings.window.size
	end, fct=function(item)
		local menu = require("engine.dialogs.DisplayResolution").new(function()	self.c_list:drawItem(item) end)
		game:registerDialog(menu)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"If you have a very high DPI screen you may want to raise this value. Requires a restart to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Screen Zoom#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.screen_zoom * 100).."%"
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new(_t"Enter Zoom %", _t"From 50 to 400", math.floor(config.settings.screen_zoom * 100), 50, 400, 5, function(qty)
			qty = util.bound(qty, 50, 400)
			game:saveSettings("screen_zoom", ("screen_zoom = %f\n"):format(qty / 100))
			config.settings.screen_zoom = qty / 100
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Request this display refresh rate.\nSet it lower to reduce CPU load, higher to increase interface responsiveness.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Requested FPS#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.display_fps)
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new(_t"Enter density", _t"From 5 to 60", config.settings.display_fps, 5, 60, 1, function(qty)
			qty = util.bound(qty, 5, 60)
			game:saveSettings("display_fps", ("display_fps = %d\n"):format(qty))
			config.settings.display_fps = qty
			core.game.setFPS(qty)
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Controls the particle effects density.\nThis option allows to change the density of the many particle effects in the game.\nIf the game is slow when displaying spell effects try to lower this setting.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Particle effects density#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.particles_density).."%"
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new(_t"Enter density", _t"From 0 to 100", config.settings.particles_density, 0, 100, 1, function(qty)
			game:saveSettings("particles_density", ("particles_density = %d\n"):format(qty))
			config.settings.particles_density = qty
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates antialiased texts.\nTexts will look nicer but it can be slower on some computers.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Antialiased texts#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(core.display.getTextBlended() and _t"enabled" or _t"disabled")
	end, fct=function(item)
		local state = not core.display.getTextBlended()
		core.display.setTextBlended(state)
		game:saveSettings("aa_text", ("aa_text = %s\n"):format(tostring(state)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Apply a global scaling to all fonts.\nApplies after restarting the game"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Font Scale#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.font_scale).."%"
	end, fct=function(item)
		game:registerDialog(GetQuantity.new(_t"Font Scale %", _t"From 50 to 300", config.settings.font_scale, 300, function(qty)
			qty = util.bound(qty, 50, 300)
			game:saveSettings("font_scale", ("font_scale = %d\n"):format(qty))
			config.settings.font_scale = qty
			self.c_list:drawItem(item)
		end, 50))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates framebuffers.\nThis option allows for some special graphical effects.\nIf you encounter weird graphical glitches try to disable it.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Framebuffers#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.fbo_active and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.fbo_active = not config.settings.fbo_active
		game:saveSettings("fbo_active", ("fbo_active = %s\n"):format(tostring(config.settings.fbo_active)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates OpenGL Shaders.\nThis option allows for some special graphical effects.\nIf you encounter weird graphical glitches try to disable it.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#OpenGL Shaders#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.shaders_active and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.shaders_active = not config.settings.shaders_active
		game:saveSettings("shaders_active", ("shaders_active = %s\n"):format(tostring(config.settings.shaders_active)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates advanced shaders.\nThis option allows for advanced effects (like water surfaces, ...). Disabling it can improve performance.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#OpenGL Shaders: Advanced#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.shaders_kind_adv and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.shaders_kind_adv = not config.settings.shaders_kind_adv
		game:saveSettings("shaders_kind_adv", ("shaders_kind_adv = %s\n"):format(tostring(config.settings.shaders_kind_adv)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates distorting shaders.\nThis option allows for distortion effects (like spell effects doing a visual distortion, ...). Disabling it can improve performance.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#OpenGL Shaders: Distortions#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.shaders_kind_distort and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.shaders_kind_distort = not config.settings.shaders_kind_distort
		game:saveSettings("shaders_kind_distort", ("shaders_kind_distort = %s\n"):format(tostring(config.settings.shaders_kind_distort)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Activates volumetric shaders.\nThis option allows for volumetricion effects (like deep starfields). Enabling it will severely reduce performance when shaders are displayed.\n\n#LIGHT_RED#You must restart the game for it to take effect.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#OpenGL Shaders: Volumetric#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.shaders_kind_volumetric and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.shaders_kind_volumetric = not config.settings.shaders_kind_volumetric
		game:saveSettings("shaders_kind_volumetric", ("shaders_kind_volumetric = %s\n"):format(tostring(config.settings.shaders_kind_volumetric)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Use the custom cursor.\nDisabling it will use your normal operating system cursor.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Mouse cursor#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.mouse_cursor and _t"enabled" or _t"disabled")
	end, fct=function(item)
		config.settings.mouse_cursor = not config.settings.mouse_cursor
		game:updateMouseCursor()
		game:saveSettings("mouse_cursor", ("mouse_cursor = %s\n"):format(tostring(config.settings.mouse_cursor)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Gamma correction setting.\nIncrease this to get a brighter display.#WHITE#"):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Gamma correction#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.gamma_correction)
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new(_t"Gamma correction", _t"From 50 to 300", config.settings.gamma_correction, 50, 300, 5, function(qty)
			qty = util.bound(qty, 50, 300)
			game:saveSettings("gamma_correction", ("gamma_correction = %d\n"):format(qty))
			config.settings.gamma_correction = qty
			game:setGamma(config.settings.gamma_correction / 100)
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Enable/disable usage of tilesets.\nIn some rare cases on very slow machines with bad GPUs/drivers it can be detrimental."):toTString()}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Use tilesets#WHITE##{normal}#"):toTString(), status=function(item)
		return tostring(config.settings.disable_tilesets and _t"disabled" or _t"enabled")
	end, fct=function(item)
		config.settings.disable_tilesets = not config.settings.disable_tilesets
		game:saveSettings("disable_tilesets", ("disable_tilesets = %s\n"):format(tostring(config.settings.disable_tilesets)))
		self.c_list:drawItem(item)
	end,}

	-- *Requested* Window Position
	--  SDL tends to lie about where windows are positioned in fullscreen mode,
	-- so always store the position requests, not the actual positions. 
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=_t"Request a specific origin point for the game window.\nThis point corresponds to where the upper left corner of the window will be located.\nUseful when dealing with multiple monitors and borderless windows.\n\nThe default origin is (0,0).\n\nNote: This value will automatically revert after ten seconds if not confirmed by the user.#WHITE#"}
	list[#list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Requested Window Position#WHITE##{normal}#"):toTString(), status=function(item)
		config.settings.window.pos = config.settings.window.pos or {x=0, y=0}
		local curX, curY = config.settings.window.pos.x, config.settings.window.pos.y
		return table.concat({"(", curX, ",", curY, ")"})
	end, fct=function(item)
		local itemRef = item
		local oldX, oldY = config.settings.window.pos.x, config.settings.window.pos.y
		local newX, newY
		local function revertMove() 
			core.display.setWindowPos(oldX, oldY)
			config.settings.window.pos.x = oldX
			config.settings.window.pos.y = oldY
			self.c_list:drawItem(itemRef)						 
		end		
		-- TODO: Maybe change this to a GetText and parse?
		game:registerDialog(GetQuantity.new(_t"Window Origin: X-Coordinate", _t"Enter the x-coordinate", oldX, 99999
			, function(qty) 
				newX=util.bound(qty, -99999, 99999) 
				game:registerDialog(GetQuantity.new(_t"Window Origin: Y-Coordinate", _t"Enter the y-coordinate", oldY, 99999
					, function(qty)
						newY = util.bound(qty, -99999, 99999)
						core.display.setWindowPos(newX, newY)
						config.settings.window.pos.x = newX
						config.settings.window.pos.y = newY
						self.c_list:drawItem(itemRef)
						local userAnswered = false
						local confirmDialog = Dialog:yesnoPopup(_t"Position changed.", _t"Save position?"
							, function(ret)
								userAnswered = true
								if ret then
									-- Write out settings
									game:onWindowMoved(newX, newY)
								else
									-- Revert
									revertMove()
								end
							end
							,  _"Accept", _"Revert")
						game:registerTimer(10
							, function()
								-- Blast out changes if no response
								if not userAnswered then
									game:unregisterDialog(confirmDialog)
									revertMove()
								end
							end	)
					end, -99999))
			end, -99999))
	end,}
	
	self.list = list
end
