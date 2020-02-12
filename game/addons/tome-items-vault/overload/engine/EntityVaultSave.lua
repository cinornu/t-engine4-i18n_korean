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

--- Handles a local characters vault saves
module(..., package.seeall, class.inherit(Savefile))

function _M:init(savefile, coroutine)
	Savefile.init(self, savefile, coroutine)

	self.short_name = "__tmp_entity"
	self.save_dir = "/tmp/"
	self.quickbirth_file = "/tmp/useless.quickbirth"
	self.load_dir = "/tmp/loadsave/"
end

--- Get a savename for an entity
function _M:nameSaveEntity(e)
	e.__version = game.__mod_info.version
	return "__tmp_entity.entity"
end
--- Get a savename for an entity
function _M:nameLoadEntity(name)
	return "__tmp_entity.entity"
end

--- Save an entity
function _M:saveEntity(e, no_dialog)
	Savefile.saveEntity(self, e, no_dialog)
end
