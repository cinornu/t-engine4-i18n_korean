-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2018 Nicolas Casalini
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

--- Can be used to make a module internationalizable
-- @classmod engine.I18N
module(..., package.seeall, class.make)

local locales = {}
local locales_args = {}
local locales_special = {}
local cur_locale_name = "en_US"
local cur_locale = {}
local cur_locale_args = {}
local cur_locale_special = {}
local cur_unlocalized = {}
local flags = {}

_G._getFlagI18N = function (flag)
	return flags[flag] or nil
end

_G._t = function(s, debugadd)
	if not s then
		return nil
	end
	return cur_locale[s] or s
end

_G.default_tformat = function(s, ...)
	if cur_locale_args[s] then
		local sargs = {...}
		local args = {}
		for sidx, didx in pairs(cur_locale_args[s]) do
			args[sidx] = sargs[didx]
		end
		s = _t(s)
		return s:format(unpack(args))
	else
		s = _t(s)
		return s:format(...)
	end
end
function string.tformat(s, ...)
	if cur_locale_special[s] then
		local args_proc = _getFlagI18N("tformat_special") or default_tformat
		return args_proc(s, cur_locale_args[s], cur_locale_special[s], ...)
	end
	return default_tformat(s, ...)
end

function _M:loadLocale(file)
	if not fs.exists(file) then print("[I18N] Warning, localization file does not exists:", file) return end
	local lc = nil
	local env = setmetatable({
		locale = function(s) lc = s; locales[lc] = locales[lc] or {} locales_args[lc] = locales_args[lc] or {} end,
		section = function(s) end, -- Not used ingame
		t = function(src, dst, args_order, special) self:t(lc, src, dst, args_order, special) end,
		setFlag = function(flag, data) 
			self.setFlag(flag, data)
		end,
	}, {__index=getfenv(2)})
	local f, err = util.loadfilemods(file, env)
	if not f and err then error(err) end
	f()
end

function _M:setLocale(lc)
	cur_locale_name = lc
	cur_locale = locales[lc] or {}
	cur_locale_args = locales_args[lc] or {}
	cur_locale_special = locales_special[lc] or {}
end

function _M:t(lc, src, dst, args_order, special)
	locales[lc] = locales[lc] or {}
	locales[lc][src] = dst
	if args_order then
		locales_args[lc] = locales_args[lc] or {}
		locales_args[lc][src] = args_order
	end
	if special then
		locales_special[lc] = locales_special[lc] or {}
		locales_special[lc][src] = special
	end
end

function _M:dumpUnknowns()
	local f = fs.open("/i18n_unknown_"..cur_locale_name..".lua", "w")
	f:write(('locale "%s"\n\n\n'):format(cur_locale_name))

	local slist = table.keys(cur_unlocalized)
	table.sort(slist)
	for _, section in ipairs(slist) do
		f:write('------------------------------------------------\n')
		f:write(('section %q\n\n'):format(section))

		local list = table.keys(cur_unlocalized[section])
		table.sort(list)
		for _, s in ipairs(list) do
			f:write(('t(%q, "")\n'):format(s))
		end
		f:write('\n\n')
	end
	f:close()
end

function _M.setFlag(flag, data)
	if flag and data then
		flags[flag] = data
	end
end


function _M:test()
	self:loadLocale("/data/locales/fr_FR.lua")
	self:setLocale("fr_FR")

	print'==================='
	print'==================='
	print(("Testing arg one %d and two %d"):tformat(1, 2))
	print'==================='
	print'==================='

	os.crash()
end
