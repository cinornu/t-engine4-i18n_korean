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

--[[-- Savefile code
T-Engine4 savefiles are direct serialization of in game objects

Basically the engine is told to save your Game instance and then it will recursively save all that it contains: level, map, entities, your own objects, ...

The savefile structure is a zip file that contains one file per object to be saved. Unzip one, it is quite obvious

A simple object (that does not do anything too fancy in its constructor) will save/load without anything to code, it's magic!
For more complex objects, look at the methods save() and loaded() in objects that have them
]]
--- @classmod engine.Savefile
module(..., package.seeall, class.make)

_M.current_save = false
_M.hotkeys_file = "/save/quick_hotkeys"
_M.md5_types = {}

_M.TRUNCATE_PRINTLOG_TO = 5000

--- Init a savefile
-- @param savefile the name of the savefile, usually the player's name. It will be sanitized so dont bother doing it
-- @param coroutine if true the saving will yield sometimes to let other code run
function _M:init(savefile, coroutine)
	self.short_name = savefile:gsub("[^a-zA-Z0-9_-.]", "_"):lower()
	self.save_dir = "/save/"..self.short_name.."/"
	self.quickbirth_file = "/save/"..self.short_name..".quickbirth"
	self.load_dir = "/tmp/loadsave/"
	print("Loading savefile ", self.save_dir)

	self.coroutine = coroutine
	self.tables = {}
	self.process = {}
	self.loaded = {}
	self.delayLoad = {}
	_M.current_save = self
end

--- The save file that is currently open
-- @static
-- @return current save
function _M:getCurrent()
	return _M.current_save
end

--- Set this save file as the current one
-- @static
-- @param[type=table] save
-- @return current save
function _M:setCurrent(save)
	_M.current_save = save
end

--- Do we md5 the specified type when saving?
-- @static
-- @string type
function _M:setSaveMD5Type(type)
	self.md5_types[type] = true
end

--- Finishes up a savefile
-- Always call it once done
function _M:close()
	self.tables = nil
	self.process = nil
	self.loaded = nil
	self.delayLoad = nil
	self.current_save_main = nil
end

--- Delete the savefile, if needed
-- Also deletes from steam cloud if it's available
function _M:delete()
	for i, f in ipairs(fs.list(self.save_dir)) do
		fs.delete(self.save_dir..f)
		if util.steamCanCloud() then core.steam.deleteFile(self.save_dir..f) end
	end
	fs.delete(self.save_dir)
	if util.steamCanCloud() then
		local namespace = core.steam.getFileNamespace()
		local list = core.steam.listFilesStartingWith(namespace..self.save_dir)
		core.steam.setFileNamespace("")
		for i, file in ipairs(list) do
			core.steam.deleteFile(file)
		end
		core.steam.setFileNamespace(namespace)
	end
end

--- add to process
function _M:addToProcess(o)
	if not self.tables[o] then
		table.insert(self.process, o)
		self.tables[o] = true
	end
end

--- Add a delayed load for object
-- @param o
function _M:addDelayLoad(o)
--	print("add delayed", _M, "::", self, #self.delayLoad, o)
	table.insert(self.delayLoad, 1, o)
end

--- Get the filename of the object
-- @param o
-- @return[1] "main"
-- @return[2] o.__CLASSNAME.."-"..tostring(o):sub(8)
function _M:getFileName(o)
	if o == self.current_save_main then
		return "main"
	else
		return o.__CLASSNAME.."-"..tostring(o):sub(8)
	end
end

--- Save the object to specified zip
-- @param obj current_save_main
-- @param zip
-- @return int of how many processed
function _M:saveObject(obj, zip)
	local processed = 0
	self.current_save_zip = zip
	self.current_save_main = obj
	self:addToProcess(obj)
	while #self.process > 0 do
		local tbl = table.remove(self.process)
		self.tables[tbl] = self:getFileName(tbl)
		if tbl.onSaving then tbl:onSaving() end
		tbl:save()
		savefile_pipe.current_nb = savefile_pipe.current_nb + 1
		processed = processed + 1
		core.wait.manualTick(1)

		if self.coroutine then coroutine.yield() end
	end
	return processed
end

--- Get a savename for a world
-- @param[type=World] world unused
-- @return "world.teaw"
function _M:nameSaveWorld(world)
	return "world.teaw"
end
--- Get a savename for a world
-- @return "world.teaw"
function _M:nameLoadWorld()
	return "world.teaw"
end

--- Save the given world
-- @param[type=World] world the world to save
-- @param[type=boolean] no_dialog show a popup when saving?
function _M:saveWorld(world, no_dialog)
	collectgarbage("collect")

	fs.mkdir(self.save_dir)

	local popup
	if not no_dialog then
		popup = Dialog:simpleWaiter(_t"Saving world", _t"Please wait while saving the world...")
	end
	core.display.forceRedraw()

	local zip = (self.save_dir..self:nameSaveWorld(world)..".tmp")
	local nb = self:saveObject(world, zip)
	--zip:add("nb", tostring(nb))
	--fs.delete(self.save_dir..self:nameSaveWorld(world))
	--fs.rename(self.save_dir..self:nameSaveWorld(world)..".tmp", self.save_dir..self:nameSaveWorld(world))

	savefile_pipe:pushGeneric("saveWorld_md5", function() self:md5Upload("world", self:nameSaveWorld(world)) end)

	if not no_dialog then popup:done() end
end

--- Save the given birth descriptors, used for quick start
-- @param[type=table] descriptor {key, value}
function _M:saveQuickBirth(descriptor)
	collectgarbage("collect")

	local f = fs.open(self.quickbirth_file, "w")
	for k, e in pairs(descriptor) do
		f:write(("%s = %q\n"):format(tostring(k), tostring(e)))
	end
	f:close()
end

--- Load the given birth descriptors, used for quick start
-- @return[1] nil
-- @return[2] table
function _M:loadQuickBirth()
	collectgarbage("collect")

	local f = loadfile(self.quickbirth_file)
	print("[QUICK BIRTH]", f)
	if f then
		-- Call the file body inside its own private environment
		local def = {}
		setfenv(f, def)
		if pcall(f) then
			return def
		end
	end
	return nil
end

--- Saves the screenshot of a game
-- @param screenshot the screenshot to write to
function _M:saveScreenshot(screenshot)
	if not screenshot then return end
	fs.mkdir(self.save_dir)

	local f = fs.open(self.save_dir.."cur.png", "w")
	f:write(screenshot)
	f:close()
end

--- Get a savename for a game
-- @param[type=Game] game
-- @return "game.teag"
function _M:nameSaveGame(game)
	return "game.teag"
end
--- Get a savename for a game
-- @return "game.teag"
function _M:nameLoadGame()
	return "game.teag"
end

--- Save the given game
-- @param[type=Game] game
-- @param[type=boolean] no_dialog Show a popup when saving?
function _M:saveGame(game, no_dialog)
	collectgarbage("collect")

	fs.mkdir(self.save_dir)

	local popup
	if not no_dialog then
		popup = Dialog:simpleWaiter(_t"Saving game", _t"Please wait while saving the game...")
	end
	core.display.forceRedraw()

	local zip = (self.save_dir..self:nameSaveGame(game)..".tmp")
	local nb = self:saveObject(game, zip)
	--zip:add("nb", tostring(nb))
	--fs.delete(self.save_dir..self:nameSaveGame(game))
	--fs.rename(self.save_dir..self:nameSaveGame(game)..".tmp", self.save_dir..self:nameSaveGame(game))

	savefile_pipe:pushGeneric("saveGame_md5", function() self:md5Upload("game", self:nameSaveGame(game)) end)

	local f = fs.open(self.save_dir.."last_log.txt", "w")
	truncate_printlog(self.TRUNCATE_PRINTLOG_TO)
	local log = get_printlog()
	for _, line in ipairs(log) do
		local max = 1
		for k, _ in pairs(line) do max = math.max(max, k) end
		local list = {}
		for i = 1, max do list[i] = tostring(line[i]) end
		f:write(table.concat(list, "\t").."\n")
	end
	f:close()
	if util.steamCanCloud() then core.steam.writeFile(self.save_dir.."last_log.txt") end

	local desc = game:getSaveDescription()
	local f = fs.open(self.save_dir.."desc.lua", "w")
	f:write(("module = %q\n"):format(game.__mod_info.short_name))
	f:write(("module_version = {%d,%d,%d}\n"):format(game.__mod_info.version[1], game.__mod_info.version[2], game.__mod_info.version[3]))
	local addons = {}
	for add, _ in pairs(game.__mod_info.addons) do addons[#addons+1] = "'"..add.."'" end
	f:write(("addons = {%s}\n"):format(table.concat(addons, ", ")))
	f:write(("name = %q\n"):format(desc.name))
	f:write(("short_name = %q\n"):format(self.short_name))
	f:write(("timestamp = %d\n"):format(os.time()))
	f:write(("loadable = %s\n"):format(game:isLoadable() and "true" or "false"))
	f:write(("cheat = %s\n"):format(game:isTainted() and "true" or "false"))
	f:write(("description = %q\n"):format(desc.description))
	f:close()
	if util.steamCanCloud() then core.steam.writeFile(self.save_dir.."desc.lua") end

	-- TODO: Replace this with saving quickhotkeys to the profile.
	-- Add print_doable_table to utils.lua as table.print_doable?
	local f = fs.open(_M.hotkeys_file, "w")
	local function print_doable_table(src, str, print_func, only, skip, is_first_call)
		str = str or ""
		print_func = print_func or print

		if is_first_call then print_func(str .. " = {}") end
		for k, e in pairs(src) do
			local new_str = str
			if (not skip or (skip and not skip[k])) and (not only or (only and only == k)) then
				if type(e) == "table" then
					if type(k) ~= "string" then new_str = str .. ("[%s]"):format(tostring(k)) else new_str = str .. ("[%q]"):format(tostring(k)) end
					print_func(new_str .. " = {}")
					print_doable_table(e, new_str, print_func)
				else
					if type(k) ~= "string" then new_str = new_str .. ("[%s]"):format(tostring(k)) else new_str = new_str .. ("[%q]"):format(tostring(k)) end
					if type(e) ~= "string" then print_func(new_str .. (" = %s"):format(tostring(e))) else print_func(new_str .. (" = %q"):format(tostring(e))) end
				end
			end
		end
	end

	print_doable_table(engine.interface.PlayerHotkeys.quickhotkeys, "quickhotkeys", function(s) return f:write(s .. "\n") end, "Player: Global", nil, true)
	print_doable_table(engine.interface.PlayerHotkeys.quickhotkeys, "quickhotkeys", function(s) return f:write(s .. "\n") end, "Player: Specific", nil, false)
	print_doable_table(engine.interface.PlayerHotkeys.quickhotkeys, "quickhotkeys", function(s) return f:write(s .. "\n") end, nil, {["Player: Global"] = true, ["Player: Specific"] = true}, false)
	f:close()

	if not no_dialog then popup:done() end
end

--- Get a savename for a zone
-- @param[type=Zone] zone
-- @return "zone-%s.teaz"
function _M:nameSaveZone(zone)
	return ("zone-%s.teaz"):format(zone.short_name)
end
--- Get a savename for a zone
-- @param[type=Zone] zone
-- @return "zone-%s.teaz"
function _M:nameLoadZone(zone)

	return ("zone-%s.teaz"):format(zone)
end

--- Save a zone
-- @param[type=Zone] zone
-- @param[type=?boolean] no_dialog Show a popup when saving?
function _M:saveZone(zone, no_dialog)
	fs.mkdir(self.save_dir)

	local popup
	if not no_dialog then
		popup = Dialog:simpleWaiter(_t"Saving zone", _t"Please wait while saving the zone...")
	end
	core.display.forceRedraw()

	local zip = (self.save_dir..self:nameSaveZone(zone)..".tmp")
	local nb = self:saveObject(zone, zip)
	--zip:add("nb", tostring(nb))
	--fs.delete(self.save_dir..self:nameSaveZone(zone))
	--fs.rename(self.save_dir..self:nameSaveZone(zone)..".tmp", self.save_dir..self:nameSaveZone(zone))

	savefile_pipe:pushGeneric("saveZone_md5", function() self:md5Upload("zone", self:nameSaveZone(zone)) end)

	if not no_dialog then popup:done() end
end

--- Get a savename for a level
-- @param[type=Level] level
-- @return "level-%s-%d.teal"
function _M:nameSaveLevel(level)
	return ("level-%s-%d.teal"):format(level.data.short_name, level.level)
end
--- Get a savename for a level
-- @param[type=Zone] zone
-- @param[type=Level] level
-- @return "level-%s-%d.teal"
function _M:nameLoadLevel(zone, level)
	return ("level-%s-%d.teal"):format(zone, level)
end

--- Save a level
-- @param[type=Level] level
-- @param[type=?boolean] no_dialog Show a popup when saving?
function _M:saveLevel(level, no_dialog)
	fs.mkdir(self.save_dir)

	local popup
	if not no_dialog then
		popup = Dialog:simpleWaiter(_t"Saving level", _t"Please wait while saving the level...")
	end
	core.display.forceRedraw()

	local zip = (self.save_dir..self:nameSaveLevel(level)..".tmp")
	local nb = self:saveObject(level, zip)
	--zip:add("nb", tostring(nb))
	--fs.delete(self.save_dir..self:nameSaveLevel(level))
	--fs.rename(self.save_dir..self:nameSaveLevel(level)..".tmp", self.save_dir..self:nameSaveLevel(level))

	savefile_pipe:pushGeneric("saveLevel_md5", function() self:md5Upload("level", self:nameSaveLevel(level)) end)

	if not no_dialog then popup:done() end
end

--- Get a savename for an entity
-- @return "entity-%s.teae"
function _M:nameSaveEntity(e)
	return ("entity-%s.teae"):format(e.name:gsub("[^a-zA-Z0-9_-.]", "_"):lower())
end
--- Get a savename for an entity
-- @return "entity-%s.teae"
function _M:nameLoadEntity(name)
	return ("entity-%s.teae"):format(name:gsub("[^a-zA-Z0-9_-.]", "_"):lower())
end

--- Save an entity
-- @param[type=Entity] e
-- @param[type=?boolean] no_dialog Show a popup when saving?
function _M:saveEntity(e, no_dialog)
	fs.mkdir(self.save_dir)

	local popup
	if not no_dialog then
		popup = Dialog:simpleWaiter(_t"Saving entity", _t"Please wait while saving the entity...")
	end
	core.display.forceRedraw()

	local zip = (self.save_dir..self:nameSaveEntity(e)..".tmp")
	local nb = self:saveObject(e, zip)
	--zip:add("nb", tostring(nb))
	--fs.delete(self.save_dir..self:nameSaveEntity(e))
	--fs.rename(self.save_dir..self:nameSaveEntity(e)..".tmp", self.save_dir..self:nameSaveEntity(e))

	savefile_pipe:pushGeneric("saveEntity_md5", function() self:md5Upload("entity", self:nameSaveEntity(e)) end)

	if not no_dialog then popup:done() end
end

--- Ensure compatability between saves
-- @param o object
-- @param base base object
-- @param allow_object allow the object to save (called recursively)
local function resolveSelf(o, base, allow_object)
	-- we check both to ensure compatibility with old saves; including world.teaw which is vital to not make everything explode
	if (o.__ATOMIC or o.__CLASSNAME) and not allow_object then return end

	local change = {}
	for k, e in pairs(o) do
		if type(e) == "table" then
			if e == class.LOAD_SELF then change[#change+1] = k
			else resolveSelf(e, base, false)
			end
		end
	end
	for i, k in ipairs(change) do o[k] = base end
end

--- Actually load an object
-- @param load
-- @return[1] nil
-- @return[2] o
function _M:loadReal(load)
	if self.loaded[load] then return self.loaded[load] end
	local f = fs.open(self.load_dir..load, "r")
	if not f then return nil end

	local lines = {}
	while true do
		local l = f:read()
		if not l then break end
		lines[#lines+1] = l
	end
	f:close()
	local o = class.load(table.concat(lines), load)

	-- Resolve self referencing tables now
	resolveSelf(o, o, true)

	core.wait.manualTick(1)
	self.loaded[load] = o
	return o
end

--- Loads a `World`
-- @return[1] nil
-- @return[1] "no savefile"
-- @return[2] `World`
function _M:loadWorld()
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadWorld()) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadWorld())
	if not path or path == "" then return nil, "no savefile" end

	local checker = self:md5Check("world", self:nameLoadWorld())

	fs.mount(path, self.load_dir)

	local popup = Dialog:simpleWaiter(_t"Loading world", _t"Please wait while loading the world...")
	core.display.forceRedraw()

	local loadedWorld = self:loadReal("main")

	-- Delay loaded must run
	for i, o in ipairs(self.delayLoad) do
--		print("loader executed for class", o, o.__CLASSNAME)
		o:loaded()
	end

	fs.umount(path)

	-- We check for the server return, while we loaded the save it probably responded so we do not wait at all
	if not checker() then self:badMD5Load() end

	popup:done()

	return loadedWorld
end

--- Gets the filesize of a `World` savefile
-- @return[1] nil
-- @return[1] "no savefile"
-- @return[2] size
function _M:loadWorldSize()
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadWorld()) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadWorld())
	if not path or path == "" then return nil, "no savefile" end

	fs.mount(path, self.load_dir)

	local f = fs.open(self.load_dir.."nb", "r")
	local nb = 0
	if f then
		nb = tonumber(f:read()) or 100
		f:close()
	end

	fs.umount(path)
	return nb
end

--- Loads a `Game`
-- delay_fct is all of the delayLoad functionality for the save file
-- @return[1] nil
-- @return[1] "no savefile"
-- @return[2] `Game`
-- @return[2] delay_fct
function _M:loadGame()
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadGame()) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadGame())
	if not path or path == "" then return nil, "no savefile" end

	fs.mount(path, self.load_dir)

	local popup = Dialog:simpleWaiter(_t"Loading game", _t"Please wait while loading the game...")
	core.display.forceRedraw()

	local loadedGame = self:loadReal("main")

	local checker = self:md5Check("game", self:nameLoadGame(), loadedGame)

	-- Delay loaded must run
	local delay_fct = function()
		for i, o in ipairs(self.delayLoad) do
--			print("loader executed for class", o, o.__CLASSNAME)
			o:loaded()
		end
	end

	fs.umount(path)

	-- We check for the server return, while we loaded the save it probably responded so we do not wait at all
	if not checker() then self:badMD5Load() end

	popup:done()

	return loadedGame, delay_fct
end


--- Gets the filesize of the `Game` savefile
-- @return[1] nil
-- @return[1] "no savefile"
-- @return[2] size
function _M:loadGameSize()
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadGame()) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadGame())
	if not path or path == "" then return nil, "no savefile" end

	fs.mount(path, self.load_dir)

	local f = fs.open(self.load_dir.."nb", "r")
	local nb = 0
	if f then
		nb = tonumber(f:read()) or 100
		f:close()
	end

	fs.umount(path)
	return nb
end

--- Loads a `Zone`
-- executes all delayLoad automatically
-- @param[type=table] zone
-- @return[1] false
-- @return[2] `Zone`
function _M:loadZone(zone)
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadZone(zone)) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadZone(zone))
	if not path or path == "" then return false end

	local checker = self:md5Check("zone", self:nameLoadZone(zone))

	fs.mount(path, self.load_dir)

	local f = fs.open(self.load_dir.."nb", "r")
	local nb = 0
	if f then
		nb = tonumber(f:read()) or 100
		f:close()
	end

	local popup = Dialog:simpleWaiter(_t"Loading zone", _t"Please wait while loading the zone...", nil, nil, nb > 0 and nb)
	core.wait.enableManualTick(true)
	core.display.forceRedraw()

	local loadedZone = self:loadReal("main")

	-- Delay loaded must run
	for i, o in ipairs(self.delayLoad) do
--		print("loader executed for class", o, o.__CLASSNAME)
		o:loaded()
	end

	-- We check for the server return, while we loaded the save it probably responded so we do not wait at all
	if not checker() then self:badMD5Load() end

	core.wait.enableManualTick(false)
	popup:done()

	fs.umount(path)
	return loadedZone
end

--- Loads a `Level`
-- all delayLoad executes automatically
-- @param[type=table] zone
-- @param[type=table] level
-- @return[1] false
-- @return[2] `Level`
function _M:loadLevel(zone, level)
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadLevel(zone, level)) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadLevel(zone, level))
	if not path or path == "" then return false end

	local checker = self:md5Check("level", self:nameLoadLevel(zone, level))

	fs.mount(path, self.load_dir)

	local f = fs.open(self.load_dir.."nb", "r")
	local nb = 0
	if f then
		nb = tonumber(f:read()) or 100
		f:close()
	end

	local popup = Dialog:simpleWaiter(_t"Loading level", _t"Please wait while loading the level...", nil, nil, nb > 0 and nb)
	core.display.forceRedraw()

	local loadedLevel = self:loadReal("main")

	-- Delay loaded must run
	for i, o in ipairs(self.delayLoad) do
--		print("loader executed for class", o, o.__CLASSNAME)
		o:loaded()
	end

	-- We check for the server return, while we loaded the save it probably responded so we do not wait at all
	if not checker() then self:badMD5Load() end

	popup:done()

	fs.umount(path)
	return loadedLevel
end

--- Loads an entity
-- automatically executes delayLoad
-- @string name
-- @return[1] false
-- @return[2] `Entity`
function _M:loadEntity(name)
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadEntity(name)) end
	local path = fs.getRealPath(self.save_dir..self:nameLoadEntity(name))
	if not path or path == "" then return false end

	local checker = self:md5Check("entity", self:nameLoadEntity(name))

	fs.mount(path, self.load_dir)

	local f = fs.open(self.load_dir.."nb", "r")
	local nb = 0
	if f then
		nb = tonumber(f:read()) or 100
		f:close()
	end

	local popup = Dialog:simpleWaiter(_t"Loading entity", _t"Please wait while loading the entity...", nil, nil, nb > 0 and nb)
	core.display.forceRedraw()

	local loadedEntity = self:loadReal("main")

	-- Delay loaded must run
	local ok = false
	pcall(function()
		for i, o in ipairs(self.delayLoad) do
--			print("loader executed for class", o, o.__CLASSNAME)
			o:loaded()
		end
		ok = true
	end)

	-- We check for the server return, while we loaded the save it probably responded so we do not wait at all
	if ok and not checker() then self:badMD5Load() end

	popup:done()

	fs.umount(path)
	if not ok then return false end
	return loadedEntity
end

--- Checks validity of a kind
-- @string type "Entity" | "World" | "Level" | "Zone"
-- @param object the object to check
-- @return true if valid
function _M:checkValidity(type, object)
	local path = fs.getRealPath(self.save_dir..self['nameSave'..type:lower():capitalize()](self, object))
	if not path or path == "" then
		print("[SAVEFILE] checked validity of type", type, " => path not found")
		print("[SAVEFILE] path info", self.save_dir..self['nameSave'..type:lower():capitalize()](self, object), "=>", path)
		return false
	end
	fs.mount(path, self.load_dir)
	local ok = false
	local f = fs.open(self.load_dir.."main", "r")
	if f then ok = true f:close() end
	fs.umount(path)
	print("[SAVEFILE] checked validity of type", type, " => ", ok and "all fine" or "main not found")
	return ok
end

--- Checks for existence
-- @return true if exists
function _M:check()
	if util.steamCanCloud() then core.steam.readFile(self.save_dir..self:nameLoadGame()) end
	return fs.exists(self.save_dir..self:nameLoadGame())
end

--- Upload type as md5
-- @see setSaveMD5Type
-- @string type savefile type
-- @string f filename
function _M:md5Upload(type, f)
	if not self.md5_types[type] then return end
	local p = game:getPlayer(true)
	if not p.getUUID then return end
	local uuid = p:getUUID()
	if not uuid then return end

	local md5 = require "md5"
	local m = nil
	local fff = fs.open(self.save_dir..f, "r")
	if fff then
		local data = fff:read(10485760)
		if data and data ~= "" then
			m = md5.sumhexa(data)
		end
		fff:close()
	end
	print("Save MD5", uuid, m, type, self.save_dir..f)
	profile:setSaveID(game.__mod_info.short_name, uuid, f, m)
end

--- Check if md5 is correct
-- @see setSaveMD5Type
-- @see PlayerProfile:checkSaveID
-- @string type savefile type
-- @string f filename
-- @param[opt=`Game`] loadgame game we're loading, defaults to static Game
-- @return[1] fct() return false end 
-- @return[2] fct() return true end
function _M:md5Check(type, f, loadgame)
	if not self.md5_types[type] then return function() return true end end

	local bad = function() return false end
	local p = (loadgame or game):getPlayer(true)
	if not p.getUUID then return bad end
	local uuid = p:getUUID()
	if not uuid then return bad end

	local md5 = require "md5"
	local m = nil
	local fff = fs.open(self.save_dir..f, "r")
	if fff then
		local data = fff:read(10485760)
		if data and data ~= "" then
			m = md5.sumhexa(data)
		end
		fff:close()
	end
	print("Check MD5", uuid, m, type, f)
	return profile:checkSaveID(game.__mod_info.short_name, uuid, f, m)
end

--- Called when our md5 is bad
function _M:badMD5Load()
	if game.onBadMD5Load then game:onBadMD5Load() end
	game.bad_md5_loaded = true
end
