-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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
local List = require "engine.ui.List"
local Module = require "engine.Module"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init()
	self:generateList()
	engine.ui.Dialog.init(self, _t"Addon Developer", 1, 1)

	local list = List.new{width=400, height=500, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c) if self.list and self.list.chars[c] then self:use(self.list[self.list.chars[c]]) end end}
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:listAddons(filter)
	local list = {}
	for short_name, add in pairs(game.__mod_info.addons) do
		if not filter or filter(add) then
			list[#list+1] = {
				name = add.long_name.." ["..add.addon_version_txt.."]",
				add = add,
			}
		end
	end
	table.sort(list, function(a, b) return a.name < b.name end)
	return list
end

function _M:zipAddon(add, silent)
	local t = core.game.getTime()

	local base = nil
	if add.teaa then base = fs.getRealPath(add.teaa)
	else base = fs.getRealPath(add.dir) end

	local md5 = require "md5"
	local md5s = {}
	fs.mkdir("/user-generated-addons/")
	local zipname = ("%s-%s.teaa"):format(game.__mod_info.short_name, add.short_name)
	local zip = fs.zipOpen("/user-generated-addons/"..zipname)
	local function fp(dir, initlen)
		for i, file in ipairs(fs.list(dir)) do
			local f = dir.."/"..file
			if file == ".git" or file == ".svn" or file == ".hg" or file == "CVS" or file == "pack.me" then
				-- ignore
			elseif fs.isdir(f) then
				fp(f, initlen)
			else
				local fff = fs.open(f, "r")
				if fff then
					local datas = {}
					while true do
						local data = fff:read(1024 * 1024 * 1024)
						if not data then break end
						datas[#datas+1] = data
					end
					fff:close()
					datas = table.concat(datas)
					zip:add(f:sub(initlen+1), datas, 0)
				end
			end
		end
	end
	fs.mount(base, "/loaded-addons/"..add.short_name, true)
	fp("/loaded-addons/"..add.short_name, #("/loaded-addons/"..add.short_name.."/"))
	fs.umount(base)
	zip:close()

	local more = ""
	if profile.auth then
		more = _t[[
- Your profile has been enabled for addon uploading, you can go to #{italic}##LIGHT_BLUE#http://te4.org/addons/tome#LAST##{normal}# and upload your addon.
]]
		profile:addonEnableUpload()
	end

	local fmd5 = Module:addonMD5(add, fs.getRealPath("/user-generated-addons/"..zipname))
	core.key.setClipboard(fmd5)
	if not silent then
		Dialog:simpleLongPopup(("Archive for %s"):tformat(add.long_name), (_t[[Addon archive created:
- Addon file: #LIGHT_GREEN#%s#LAST# in folder #{bold}#%s#{normal}#
- Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard)
%s
]]):format(zipname, fs.getRealPath("/user-generated-addons/"), fmd5, more), 780)
	end

	return "/user-generated-addons/"..zipname, fmd5
end

function _M:createAddon(add)
	if not add.tags or type(add.tags) ~= "table" then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a tags table, i.e: tags={'foo', 'bar'}")
		return
	end
	if not add.description then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a description field")
		return
	end

	core.profile.pushOrder(table.serialize{o="AddonAuthoring", suborder="create",
		metadata = {
			for_module = game.__mod_info.short_name,
			short_name = add.short_name,
			title = add.long_name,
			desc = add.description,
			tags = add.tags,
		}
	})
	local popup = Dialog:simpleWaiter(_t"Registering new addon", ("Addon: %s"):tformat(add.short_name))
	local ok = false
	local reason = nil
	profile:waitEvent("AddonAuthoring", function(e) ok = e.ok reason = e.reason end, 10000)
	popup:done()

	if ok then
		Dialog:simplePopup(_t"Registering new addon", ("Addon #LIGHT_GREEN#%s#LAST# registered. You may now upload a version for it."):tformat(add.short_name))
	else
		Dialog:simplePopup(_t"Registering new addon", ("Addon #LIGHT_RED#%s#LAST# not registered: %s"):tformat(add.short_name, reason or _t"unknown reason"))
	end
end

function _M:publishAddon(add, release_name)
	if not add.tags or type(add.tags) ~= "table" then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a tags table, i.e: tags={'foo', 'bar'}")
		return
	end
	if not add.description then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a description field")
		return
	end

	local file, fmd5 = self:zipAddon(add, true)

	core.profile.pushOrder(table.serialize{o="AddonAuthoring", suborder="version",
		metadata = {
			for_module = game.__mod_info.short_name,
			short_name = add.short_name,
			title = release_name,
			md5 = fmd5,
			version = add.version,
			addon_version = add.addon_version,
		},
		file = file,
	})
	local popup = Dialog:simpleWaiter(_t"Uploading addon", ("Addon: %s"):tformat(add.short_name), nil, nil, 1) popup:manual()
	local ok = nil
	local reason = nil
	while ok == nil do
		profile:waitEvent("AddonAuthoring", function(e)
			if e.suborder == "version_upload_start" then core.wait.addMaxTicks(e.total)
			elseif e.suborder == "version_upload_progress" and popup then popup:manualStep(e.sent)
			elseif e.suborder == "version" then ok = e.ok reason = e.reason
			end
		end, 10000)
	end
	if popup then popup:done() end

	if ok then
		Dialog:simplePopup(_t"Uploading addon", ("Addon #LIGHT_GREEN#%s#LAST# uploaded, players may now play with it!"):tformat(add.short_name))
	else
		Dialog:simplePopup(_t"Uploading addon", ("Addon #LIGHT_RED#%s#LAST# not upload: %s"):tformat(add.short_name, reason or _t"unknown reason"))
	end
end

function _M:addonPreview(add)
	if not core.display.FBOActive() then return "data-addon-dev/gfx/default_addon_preview.png" end
	local fbo = core.display.newFBO(512, 512)
	if not fbo then return "data-addon-dev/gfx/default_addon_preview.png" end
	local back = core.display.loadImage("data-addon-dev/gfx/default_addon_preview.png"):glTexture()
	local font = core.display.newFont("/data/font/DroidSerif-Bold.ttf", 34)
	local text = font:draw(add.long_name, 500, colors.GOLD.r, colors.GOLD.g, colors.GOLD.b, false, false)
	local Shader = require "engine.Shader"
	local shader = Shader.new("textoutline", {outlineColor={0xd7/255, 0x74/255, 0xfe/255, 0.6}, intensity=0.5, outlineSize={2,2}}).shad

	fbo:use(true)
	back:toScreen(0, 0, 512, 512)
	local y = 220
	if shader then shader:use(true) end
	for i = 1, #text do
		local item = text[i]
		if shader then shader:uniTextSize(item._tex_w, item._tex_h) end
		item._tex:toScreenFull(256 - item.realw / 2, y, item.w, item.h, item._tex_w, item._tex_h)
		y = y + item.h
	end
	if shader then shader:use(false) end
	fbo:use(false)
	local imagedata = fbo:png()
	local png = ("user-generated-addons/%s-%s.png"):format(add.for_module, add.short_name)
	local f = fs.open(png, "w")
	f:write(imagedata)
	f:close()
	return png
end

function _M:publishAddonSteam(add)
	if not add.tags or type(add.tags) ~= "table" then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a tags table, i.e: tags={'foo', 'bar'}")
		return
	end
	if not add.description then
		Dialog:simplePopup(_t"Registering new addon", _t"Addon init.lua must contain a description field")
		return
	end

	local file, fmd5 = self:zipAddon(add, true)

	core.profile.pushOrder(table.serialize{o="AddonAuthoring", suborder="check_steam_pubid",
		for_module = game.__mod_info.short_name,
		short_name = add.short_name,
		version = add.version,
		md5 = fmd5,
	})
	local pubid = nil
	local err = nil
	local popup = Dialog:simpleWaiter(_t"Connecting to server", ("Addon: %s"):tformat(add.short_name))
	profile:waitEvent("AddonAuthoring", function(e) if e.suborder == "check_steam_pubid" then pubid = e.pubid err = e.err end end, 10000)
	popup:done()
	if pubid == '' then pubid = nil end
	print("[STEAM UPLOAD] Got addon steam pubid", pubid)

	if err then
		Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), ("Update error: %s"):tformat(err or _t"unknown"))
		return
	end

	local popup = Dialog:simpleWaiter(_t"Uploading addon to Steam Workshop", ("Addon: %s"):tformat(add.short_name), nil, 10000)
	core.display.forceRedraw()
	if not pubid then
		local preview = "user-generated-addons/"..add.for_module.."-"..add.short_name.."-custom.png"
		if not fs.exists(preview) then preview = self:addonPreview(add) end
		core.steam.publishFile(file:sub(2), preview, add.long_name, add.description, add.tags, function(pubid, needaccept, error)
			popup:done()
			if not error and pubid then
				core.profile.pushOrder(table.serialize{o="AddonAuthoring", suborder="steam_pubid", for_module = game.__mod_info.short_name, short_name = add.short_name, pubid = pubid})
			end

			if error then Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"There was an error uploading the addon.")
			elseif needaccept then
				Dialog:yesnoLongPopup(("Steam Workshop: %s"):tformat(add.long_name), _t"Addon succesfully uploaded to the Workshop.\nYou need to accept Steam Workshop Agreement in your Steam Client before the addon is visible to the community.", 500, function(ret) if ret then
					util.browserOpenUrl("http://steamcommunity.com/sharedfiles/workshoplegalagreement")
				end end, _t"Go to Workshop", _t"Later")
			else Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"Addon succesfully uploaded to the Workshop.")
			end
		end)
	else
		core.steam.publishFileUpdate(pubid, file:sub(2), false, function(error)
			popup:done()
			if fs.exists("/user-generated-addons/"..add.for_module.."-"..add.short_name.."-custom.png") then game:registerTimer(0.01, function()
				local popup = Dialog:simpleWaiter(_t"Uploading addon preview to Steam Workshop", ("Addon: %s"):tformat(add.short_name), nil, 10000)
				core.steam.publishFileUpdate(pubid, "user-generated-addons/"..add.for_module.."-"..add.short_name.."-custom.png", true, function(error)
					popup:done()
					if error then Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"There was an error uploading the addon preview.")
					else Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"Addon update & preview succesfully uploaded to the Workshop.")
					end
				end)
			end) else
				if error then Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"There was an error uploading the addon.")
				else Dialog:simplePopup(("Steam Workshop: %s"):tformat(add.long_name), _t"Addon update succesfully uploaded to the Workshop.")
				end
			end
		end)
	end
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	if item.dialog then
		local d = require("mod.dialogs.debug."..item.dialog).new()
		game:registerDialog(d)
		return
	end

	local act = item.action

	local stop = false
	if act == "md5" then Dialog:listPopup(_t"Choose an addon for MD5", "", self:listAddons(), 400, 500, function(item) if item then
		local fmd5 = Module:addonMD5(item.add)
		core.key.setClipboard(fmd5)
		Dialog:simpleLongPopup(("MD5 for %s"):tformat(item.name), ("Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard).\nHowever you should'nt need that anymore, you can upload your addon directly from here."):tformat(fmd5), 600)
	end end) end

	if act == "zip" then Dialog:listPopup(_t"Choose an addon to archive", "", self:listAddons(function(add) return not add.teaa end), 400, 500, function(item) if item then
		self:zipAddon(item.add)
	end end) end

	if act == "create" then Dialog:listPopup(_t"Choose an addon to register", "", self:listAddons(function(add) return not add.teaa end), 400, 500, function(item) if item then
		self:createAddon(item.add)
	end end) end

	if act == "publish" then Dialog:listPopup(_t"Choose an addon to publish", "", self:listAddons(function(add) return not add.teaa end), 400, 500, function(item) if item then
		local d = require("engine.dialogs.GetText").new(_t"Name for this addon's release", _t"Name", 5, 50, function(name)
			if name then
				self:publishAddon(item.add, name)
			end
		end)
		game:registerDialog(d)
	end end) end

	if act == "publish_steam" then Dialog:listPopup(_t"Choose an addon to publish to Steam Workshop (needs to have been published to te4.org first)", "", self:listAddons(function(add) return not add.teaa end), 400, 500, function(item) if item then
		fs.mkdir("/user-generated-addons/")
		if not fs.exists("/user-generated-addons/"..item.add.for_module.."-"..item.add.short_name.."-custom.png") then
			Dialog:yesnoLongPopup(_t"Addon preview", (_t[[Addons on Steam Workshop need a "preview" image for the listing.
The game has generated a default one, however it is best if you make a custom one and place it in the folder #LIGHT_GREEN#%s#LAST# named #LIGHT_BLUE#%s#LAST# (512x512 is a good size for it)
You can still upload now and place it later.]]):format(fs.getRealPath("/user-generated-addons"), item.add.for_module.."-"..item.add.short_name.."-custom.png"), 600, function(ret)
				self:publishAddonSteam(item.add)
			end, _t"Upload now", _t"Wait")
		else
			self:publishAddonSteam(item.add)
		end
	end end) end
end

function _M:generateList()
	local list = {}

	list[#list+1] = {name=_t"Generate Addon's MD5", action="md5"}
--	list[#list+1] = {name="Generate Addon's archive", action="zip"}
	if profile.auth then
		list[#list+1] = {name=_t"Register new Addon", action="create"}
		list[#list+1] = {name=_t"Publish Addon to te4.org", action="publish"}
		if core.steam and core.steam.connected() then list[#list+1] = {name=_t"Publish Addon to Steam Workshop", action="publish_steam"} end
	end

	local chars = {}
	for i, v in ipairs(list) do
		v.name = self:makeKeyChar(i)..") "..v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
