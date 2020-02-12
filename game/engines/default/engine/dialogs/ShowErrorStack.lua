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
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local Textbox = require "engine.ui.Textbox"

--- Show Error Stack
-- @classmod engine.dialogs.ShowErrorStack
module(..., package.seeall, class.inherit(Dialog))

function _M:init(errs)
	local display_errs = table.concat(errs, "\n")

	local beta = engine.version_hasbeta()
	if game.getPlayer and game:getPlayer(true) and game:getPlayer(true).__created_in_version then
		table.insert(errs, 1, "Game version (character creation): "..game:getPlayer(true).__created_in_version)
	end
	table.insert(errs, 1, "Game version: "..game.__mod_info.version_name..(beta and "-"..beta or ""))
	local addons = {}
	for name, data in pairs(game.__mod_info.addons or {}) do
		local extra = ""
		-- So ugly!!! :<
		if data.for_module == "tome" then
			extra = "["..(data.author[1]=="DarkGod" and "O" or "X")..(engine.version_patch_same(game.__mod_info.version, data.version) and "" or "!").."]"
		end
		addons[#addons+1] = name.."-"..data.version_txt..extra
	end
	table.insert(errs, 2, "Addons: "..table.concat(addons, ", ").."\n")
	self.errs_t = errs
	errs = table.concat(errs, "\n")
	self.errs = errs
	Dialog.init(self, _t"Lua Error", 700, 500)

	local md5 = require "md5"
	local errmd5 = md5.sumhexa(errs)
	self.errmd5 = errmd5

	fs.mkdir("/error-reports")
	local errdir = "/error-reports/"..game.__mod_info.version_name
	self.errdir = errdir
	fs.mkdir(errdir)
	local infos = {}
	local f, err = loadfile(errdir.."/"..errmd5)
	if f then
		setfenv(f, infos)
		if pcall(f) then infos.loaded = true end
	end

	local realpath_errfile = nil

	local reason = _t"If you already reported that error, you do not have to do it again (unless you feel the situation is different)."
	if infos.loaded then
		if infos.reported then reason = _t"You #LIGHT_GREEN#already reported#WHITE# that error, you do not have to do it again (unless you feel the situation is different)."
		else reason = _t"You have already got this error but #LIGHT_RED#never reported#WHITE# it, please do."
		end
	else
		reason = _t"You have #LIGHT_RED#never seen#WHITE# that error, please report it."

		print(pcall(function()
			fs.mkdir("/error-logs")
			local errlogdir = "/error-logs/"..game.__mod_info.version_name
			fs.mkdir(errlogdir)
			local errfile = errlogdir.."/"..os.date("%Y-%m-%d_%H-%M-%S")..".txt"
			local f = fs.open(errfile, "w")
			truncate_printlog(5000)
			local log = get_printlog()
			for _, line in ipairs(log) do
				local max = 1
				for k, _ in pairs(line) do max = math.max(max, k) end
				local list = {}
				for i = 1, max do list[i] = tostring(line[i]) end
				f:write(table.concat(list, "\t").."\n")
			end
			f:write("\n\nERROR:\n"..errs.."\n")
			f:close()
			realpath_errfile = fs.getRealPath(errfile)
		end))
	end

	self:saveError(true, infos.reported)

	local errmsg = Textzone.new{text=_t[[#{bold}#Oh my! It seems there was an error!
The game might still work but this is suspect, please type in your current situation and click on "Send" to send an error report to the game creator.
If you are not currently connected to the internet, please report this bug when you can on the forums at http://forums.te4.org/

]]..reason..[[#{normal}#]], width=690, auto_height=true}
	local errzone = Textzone.new{text=display_errs, width=690, height=300}
	self.what = Textbox.new{title=_t"What happened?: ", text=_t"", chars=60, max_len=1000, fct=function(text) self:send() end}
	local ok = require("engine.ui.Button").new{text=_t"Send", fct=function() self:send() end}
	local cancel = require("engine.ui.Button").new{text=_t"Close", fct=function() game:unregisterDialog(self) end}
	local cancel_all = require("engine.ui.Button").new{text=_t"Close All", fct=function()
		for i = #game.dialogs, 1, -1 do
			local d = game.dialogs[i]
			if d.__CLASSNAME == "engine.dialogs.ShowErrorStack" then
				game:unregisterDialog(d)
			end
		end
	end}


	local many_errs = false
	for i = #game.dialogs, 1, -1 do local d = game.dialogs[i] if d.__CLASSNAME == "engine.dialogs.ShowErrorStack" then many_errs = true break end end

	local uis = {
		{left=0, top=0, padding_h=10, ui=errmsg},
		{left=0, top=errmsg.h + 10, padding_h=10, ui=errzone},
		{left=0, bottom=ok.h, ui=self.what},
		{left=0, bottom=0, ui=ok},
		{right=0, bottom=0, ui=cancel},
	}
	if many_errs then
		table.insert(uis, #uis, {right=cancel.w, bottom=0, ui=cancel_all})
	end

	if realpath_errfile then
		local realpath_errfile_t = Textzone.new{text=("Log saved to file (click to copy to clipboard):#LIGHT_BLUE#%s"):tformat(realpath_errfile), width=self.iw, auto_height=true, fct=function() core.key.setClipboard(realpath_errfile) game.log("File location copied to clipboard.") end}
		for i, ui in ipairs(uis) do if ui.bottom then ui.bottom = ui.bottom + realpath_errfile_t.h end end
		table.insert(uis, 1, {left=0, bottom=0, ui=realpath_errfile_t})
	end

	self:loadUI(uis)
	self:setFocus(self.what)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
		LUA_CONSOLE = function()
			if config.settings.cheat then
				local DebugConsole = require "engine.DebugConsole"
				game:registerDialog(DebugConsole.new())
			end
		end,
	}
end

function _M:saveError(seen, reported)
	local f = fs.open(self.errdir.."/"..self.errmd5, "w")
	f:write(("error = %q\n"):format(self.errs))
	f:write(("seen = %s\n"):format(seen and "true" or "false"))
	f:write(("reported = %s\n"):format(reported and "true" or "false"))
	f:close()
end

function _M:send()
	local errs = self.errs_t
	for i, line in ripairs(errs) do pcall(function()
		local _, _, file = line:find("(/.*.lua):%d+")
		if file then
			local sep = fs.getPathSeparator()
			local rpath = fs.getRealPath(file)
			table.insert(errs, i+1, "      =from= "..(rpath:gsub("^.*"..sep.."game"..sep, "")))
		end
	end) end
	errs = table.concat(errs, "\n")
	print(errs)

	game:unregisterDialog(self)
	profile:sendError(self.what.text, errs)
	game.log("#YELLOW#Error report sent, thank you.")
	self:saveError(true, true)
end
