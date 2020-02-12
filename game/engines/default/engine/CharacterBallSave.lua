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
local Savefile = require "engine.Savefile"

--- Handles a local characters charball saves
-- @classmod engine.CharacterBallSave
module(..., package.seeall, class.inherit(Savefile))

--- init
-- @param[type=Savefile] savefile
-- @thread coroutine 
function _M:init(savefile, coroutine)
	Savefile.init(self, savefile, coroutine)

	fs.mkdir("/charballs")
	self.short_name = savefile:gsub("[^a-zA-Z0-9_-.]", "_")
	self.save_dir = "/charballs/"
	self.quickbirth_file = "/charballs/useless.quickbirth"
	self.load_dir = "/tmp/loadsave/"
end

--- Get a savename for an entity
-- @param[type=Entity] e
-- @return a formatted string 
-- "{e.uuid}-{version_major}.{version_minor}.{version_patch}.charball"
function _M:nameSaveEntity(e)
	e.__version = game.__mod_info.version
	return ("%s-%d.%d.%d.charball"):format(e.__te4_uuid, game.__mod_info.version[1], game.__mod_info.version[2], game.__mod_info.version[3])
end
--- Get a specific savename for an entity
-- @string name
-- @return name.charball
function _M:nameLoadEntity(name)
	return name..".charball"
end

--- Save an entity
-- @see engine.Savefile.saveEntity
-- @param[type=Entity] e
-- @param[type=boolean] no_dialog Show a dialog that we're saving?
function _M:saveEntity(e, no_dialog)
	Savefile.saveEntity(self, e, no_dialog)
end
