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

--- In the format {1,4,0,"te4",17}  
-- Where values are {major, minor, patch, engine_name, c_core}
-- @script engine.version

engine.version = {1,6,6,"te4",17}
engine.require_c_core = engine.version[5]
engine.version_id = ("%s-%d_%d.%d.%d"):format(engine.version[4], engine.require_c_core, engine.version[1], engine.version[2], engine.version[3])

--- Check which version the engine is
-- @param[type=table] v version table
-- @return[1] "newer" if our version is newer
-- @return[2] "lower" if our version is older
-- @return[3] "same" if our versions are identical
-- @return[4] "different engine" if it's an entirely different engine
-- @return[5] "bad C core" if our c core is incorrect
function engine.version_check(v)
	local ev = engine.version
	if v[5] ~= core.game.VERSION then return "bad C core" end
	if v[4] ~= ev[4] then return "different engine" end
	if v[1] > ev[1] then return "newer" end
	if v[1] == ev[1] and v[2] > ev[2] then return "newer" end
	if v[1] == ev[1] and v[2] == ev[2] and v[3] > ev[3] then return "newer" end
	if v[1] == ev[1] and v[2] == ev[2] and v[3] == ev[3] then return "same" end
	return "lower"
end

--- Formatted engine string
-- @param[type=table] v
-- @return "te4.v[1].[v2].v[3]"
function engine.version_string(v)
	return ("%s-%d.%d.%d"):format(v[4] or "te4", v[1], v[2], v[3])
end

--- Takes a version string and turns it into a table
-- @string[opt] s
-- @return[1] {1, 0, 0} if s is absent
-- @return[2] {x, y, z} if in format "x.y.z"
-- @return[3] {x, y, z, name=str} if in format "x.y.z.str"
function engine.version_from_string(s)
	local v = {1, 0, 0}
	if not s then return v end
	local _, _, M, m, p = s:find("^(%d+).(%d+).(%d+)$")
	if tonumber(M) and tonumber(m) and tonumber(p) then return {tonumber(M), tonumber(m), tonumber(p)} end
	local _, _, name, M, m, p = s:find("^(.+)%-(%d+).(%d+).(%d+)$")
	if tonumber(M) and tonumber(m) and tonumber(p) then return {tonumber(M), tonumber(m), tonumber(p), name=name} end
	return v
end

--- Compare two engine tables
-- @param[type=table] v the version we want to know about
-- @param[type=table] ev the version to compare to
-- @return[1] "newer" if our version is newer
-- @return[2] "lower" if our version is older
-- @return[3] "same" if our versions are identical
function engine.version_compare(v, ev)
	if v[1] > ev[1] then return "newer" end
	if v[1] == ev[1] and v[2] > ev[2] then return "newer" end
	if v[1] == ev[1] and v[2] == ev[2] and v[3] > ev[3] then return "newer" end
	if v[1] == ev[1] and v[2] == ev[2] and v[3] == ev[3] then return "same" end
	return "lower"
end

--- Compare two engine tables
-- @param[type=table] v the version we want to know about
-- @param[type=table] ev the version to compare to
-- @return true if nearly the same
-- @usage version_nearly_same({1.2.3}, {1.2.2}) = true
-- version_nearly_same({1.3.0}, {1.1.5}) = true
-- version_nearly_same({1.1.0}, {1.2.0}) = false
-- version_nearly_same({0.9.2}, {1.2.2}) = false
function engine.version_nearly_same(v, ev)
	if v[1] == ev[1] then
		if v[2] == ev[2] and v[3] >= ev[3] then return true
		elseif v[2] >= ev[2] then return true
		end
	end
	return false
end

--- Check if the two versions are identical
-- @param[type=table] v version1
-- @param[type=table] ev version2
-- @return true if same
function engine.version_patch_same(v, ev)
	if v[1] ~= ev[1] then return false end
	if v[2] ~= ev[2] then return false end
	if v[3] >= ev[3] then return true end
	return false
end

--- Check if we are running as beta
function engine.version_hasbeta()
	if fs.exists("/engine/version_beta.lua") then
		return dofile("/engine/version_beta.lua")
	end
end
