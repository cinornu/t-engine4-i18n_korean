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
local Module = require "engine.Module"
local Dialog = require "engine.ui.Dialog"
local TreeList = require "engine.ui.TreeList"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local Checkbox = require "engine.ui.Checkbox"
local Savefile = require "engine.Savefile"
local Downloader = require "engine.dialogs.Downloader"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(force_compat)
	Dialog.init(self, _t"Load Game", game.w * 0.8, game.h * 0.8)

	self.c_compat = Checkbox.new{default=force_compat, width=math.floor(self.iw / 3 - 40), title=_t"Show older versions", on_change=function() self:switch() end}
	self.c_force_addons = Checkbox.new{default=false, width=math.floor(self.iw / 3 - 40), title=_t"Ignore unloadable addons"}
	self.c_play = Button.new{text=_t"  Play!  ", fct=function(text) self:playSave() end}
	self.c_delete = Button.new{text=_t"Delete", fct=function(text) self:deleteSave() end}
	self.c_desc = Textzone.new{width=math.floor(self.iw / 3 * 2 - 10), height=self.ih - self.c_delete.h - 10, text=""}

	self:generateList()

	self.save_sel = nil
	self.c_tree = TreeList.new{width=math.floor(self.iw / 3 - 10), height=self.ih, scrollbar=true, columns={
		{width=100, display_prop="name"},
	}, tree=self.tree,
		fct=function(item)
			if self.save_sel == item then self:playSave() end
			if self.save_sel then self.save_sel.color = nil self.c_tree:drawItem(self.save_sel) end
			item.color = function() return colors.simple(colors.LIGHT_GREEN) end
			self.save_sel = item
			self.c_tree:drawItem(item)
			if item.usable then self:toggleDisplay(self.c_play, true) end
			self:toggleDisplay(self.c_delete, true)
		end,
		select=function(item, sel) self:select(item) end,
	}

	local sep = Separator.new{dir="horizontal", size=self.ih - 10}
	local uis = {
		{left=0, top=0, ui=self.c_tree},
		{left=self.c_tree.w+sep.w, top=0, ui=self.c_desc},
		{right=0, bottom=0, ui=self.c_delete, hidden=true},
		{left=0, bottom=0, ui=self.c_play, hidden=true},
		{left=self.c_tree.w + 5, top=5, ui=sep},
	}
	if __module_extra_info.show_ignore_addons_not_loading then
		uis[#uis+1] = {left=self.c_tree.w - self.c_compat.w, bottom=self.c_force_addons.h, ui=self.c_compat}
		uis[#uis+1] = {left=self.c_tree.w - self.c_force_addons.w, bottom=0, ui=self.c_force_addons}
	else
		uis[#uis+1] = {left=self.c_tree.w - self.c_compat.w, bottom=0, ui=self.c_compat}
	end
	self:loadUI(uis)
	self:setFocus(self.c_tree)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:generateList()
	local list = Module:listSavefiles(self.c_compat.checked)
	self.tree = {}
	local found = false
	for i = #list, 1, -1 do
		local m = list[i]
		if m.is_boot then table.remove(list, i) m.savefiles={} end

		local nodes = {}
		local mod_addons = {}

		for j, save in ipairs(m.savefiles) do
			local mod_string = ("%s-%d.%d.%d"):format(m.short_name, save.module_version and save.module_version[1] or -1, save.module_version and save.module_version[2] or -1, save.module_version and save.module_version[3] or -1)
			save.module_string = mod_string
			local mod = list[mod_string]
			if not mod and save.module_version and m.versions and m.versions[1] and m.versions[1].version and engine.version_patch_same(m.versions[1].version, save.module_version) then mod = m.versions[1] end
			if not mod and self.c_compat.checked and m.versions and m.versions[1] then mod = m.versions[1] end
			if mod and save.loadable then
				local laddons = mod_addons[mod]
				if not laddons then
					laddons = table.reversekey(Module:listAddons(mod, true), "short_name")
					mod_addons[mod] = laddons
				end
				local addons = {}
				save.usable = true
				for i, add in ipairs(save.addons or {}) do
					if laddons[add] then addons[#addons+1] = "#LIGHT_GREEN#"..add.."#WHITE#"
					else addons[#addons+1] = "#LIGHT_RED#"..add.."#WHITE#" save.usable = false
					end
				end
				save.mod = mod
				save.base_name = save.short_name
				save.zone = Textzone.new{
					width=self.c_desc.w,
					height=self.c_desc.h,
					text=("#{bold}##GOLD#%s: %s#WHITE##{normal}#\nGame version: %d.%d.%d\nRequires addons: %s\n\n%s"):tformat(mod.long_name, save.name, save.module_version and save.module_version[1] or -1, save.module_version and save.module_version[2] or -1, save.module_version and save.module_version[3] or -1, save.addons and table.concat(addons, ", ") or "none", save.description)
				}
				if save.screenshot then
					local w, h = save.screenshot:getSize()
					save.screenshot = { save.screenshot:glTexture() }
					save.screenshot.w, save.screenshot.h = w, h
				end
				table.insert(nodes, save)
				table.sort(nodes, function(a, b) return (a.timestamp or 0) > (b.timestamp or 0) end)
				found = true
			end
		end

		if #nodes > 0 then
			local mod = m.versions[1]
			table.insert(self.tree, {
				name=tstring{{"font","bold"}, {"color","GOLD"}, mod.name, {"font","normal"}},
				fct=function() end,
				shown=true,
				nodes=nodes,
				zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text="#{bold}##GOLD#"..mod.long_name.."#WHITE##{normal}#\n\n"..mod.description}
			})
		end
	end
end

function _M:switch()
	self:generateList()
	self.c_tree.tree = self.tree
	self.c_tree:generate()
end

function _M:on_focus(id, ui)
	if self.focus_ui and self.focus_ui.ui == self.c_tree then
		self:select(self.cur_sel)
	else
		self:select(self.save_sel)
	end
end

function _M:select(item)
	if item and self.uis[2] then
		self.uis[2].ui = item.zone
		self.cur_sel = item
	else
		self.cur_sel = nil
	end
end

function _M:innerDisplay(x, y, nb_keyframes)
	if not self.cur_sel or not self.cur_sel.screenshot then return end
	local s = self.cur_sel.screenshot
	local r = s.w / s.h
	local w = math.min(s.w, self.c_desc.w - 20)
	local h = w / r
	h = math.min(h, self.ih / 1.7)
	w = h * r
	s[1]:toScreenFull(x + self.ix + self.iw - self.c_desc.w + 10, y + self.ih - h - 20, w, h, s[2] * w / s.w, s[3] * h / s.h)
end

function _M:playSave(ignore_mod_compat)
	if not self.save_sel then return end

	local save_v = engine.version_from_string(self.save_sel.module_string)
	local save_m = engine.version_from_string(self.save_sel.mod.version_string)
	if not ignore_mod_compat and not engine.version_patch_same(save_m, save_v) and save_m.name == save_v.name then
		local howgrabold = _t"You can simply grab an older version of the game from where you downloaded it."
		if core.steam then
			howgrabold = _t[[You can downgrade the version by selecting it in the Steam's "Beta" properties of the game.]]
		end
		Dialog:yesnoLongPopup(_t"Original game version not found", ("This savefile was created with game version %s. You can try loading it with the current version if you wish but it is recommended you play it with the old version to ensure compatibility\n%s"):tformat(self.save_sel.module_string, howgrabold), 500, function(ret)
			if ret then
			else
				self:playSave(true)
			end
		end, _t"Cancel", _t"Run with newer version", true)
		return
	end

	if config.settings.cheat and not self.save_sel.cheat then
		Dialog:yesnoPopup(_t"Developer Mode", _t"#LIGHT_RED#WARNING: #LAST#Loading a savefile while in developer mode will permanently invalidate it. Proceed?", function(ret) if not ret then
			Module:instanciate(self.save_sel.mod, self.save_sel.base_name, false)
		end end, _t"Cancel", _t"Load anyway", true)
	else
		local extra_info = nil
		if self.c_force_addons.checked then extra_info = "ignore_addons_not_loading=true" end
		Module:instanciate(self.save_sel.mod, self.save_sel.base_name, false, nil, extra_info)
	end
end

function _M:deleteSave()
	if not self.save_sel then return end

	Dialog:yesnoPopup(_t"Delete savefile", ("Really delete #{bold}##GOLD#%s#WHITE##{normal}#"):tformat(self.cur_sel.name), function(ret)
		if ret then
			local base = Module:setupWrite(self.save_sel.mod)
			local save = Savefile.new(self.save_sel.base_name)
			save:delete()
			save:close()
			fs.umount(base)

			game.save_list = Module:listSavefiles()

			local d = new()
			d.__showup = false
			game:replaceDialog(self, d)
		end
	end, _t"Delete", _t"Cancel")
end

function _M:installOldGame(version_string)
	if not core.webview then return end
	print("[OLD MODULE] checking for install", version_string)

	local dls = {}
	-- Later on we can request the server for a list, but heh
	if version_string == "tome-1.2.5" then
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.2.5-gfx.team", name="tome-1.2.5-gfx.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.2.5-music.team", name="tome-1.2.5-music.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.2.5.team", name="tome-1.2.5.team"}
	elseif version_string == "tome-1.3.3" then
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.3.3-gfx.team", name="tome-1.3.3-gfx.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.3.3-music.team", name="tome-1.3.3-music.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.3.3.team", name="tome-1.3.3.team"}
	elseif version_string == "tome-1.4.9" then
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.4.9-gfx.team", name="tome-1.4.9-gfx.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.4.9-music.team", name="tome-1.4.9-music.team"}
		dls[#dls+1] = {url="https://te4.org/dl/modules/tome/tome-1.4.9.team", name="tome-1.4.9.team"}
	end

	if #dls == 0 then
		Dialog:simplePopup(_t"Old game data", _t"No data available for this game version.")
		return
	end

	local co co = coroutine.create(function()
	local all_ok = true
	for i, dl in ipairs(dls) do
		local modfile = "/modules/"..dl.name
		print("[OLD MODULE] download file from", dl.url, "to", modfile)
		local d = Downloader.new{title=_t"Downloading old game data: #LIGHT_GREEN#"..dl.name, co=co, dest=modfile..".tmp", url=dl.url, allow_downloads={modules=true}}
		local ok = d:start()
		if ok then
			local wdir = fs.getWritePath()
			local _, _, dir, name = modfile:find("(.+/)([^/]+)$")
			if dir then
				fs.setWritePath(fs.getRealPath(dir))
				fs.delete(name)
				fs.rename(name..".tmp", name)
				fs.setWritePath(wdir)
			end
		else all_ok = false
		end
	end
	if all_ok then Dialog:simplePopup(_t"Old game data", ("Old game data for %s correctly installed. You can now play."):tformat(version_string)) self:regen()
	else Dialog:simplePopup(_t"Old game data", _t"Failed to install.") end
	end)
	print(coroutine.resume(co))
end

function _M:regen()
	local d = new(self.c_compat.checked)
	d.__showup = false
	game:replaceDialog(self, d)
	self.next_dialog = d
end
