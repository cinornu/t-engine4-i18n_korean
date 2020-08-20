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

--- Utility functionality used by a lot of the base classes
-- @script engine.utils

if not core.game.stdout_write then core.game.stdout_write = print end
if not core.display.breakTextAllCharacter then core.display.breakTextAllCharacter = function()end end

local lpeg = require "lpeg"

function math.decimals(v, nb)
	nb = 10 ^ nb
	return math.floor(v * nb) / nb
end

-- Rounds to nearest multiple
-- (round away from zero): math.round(4.65, 0.1)=4.7, math.round(-4.475, 0.01) = -4.48
-- num = rounding multiplier to compensate for numerical rounding (default 1000000 for 6 digits accuracy)
function math.round(v, mult, num)
	mult = mult or 1
	num = num or 1000000
	v, mult = v*num, mult*num
	return v >= 0 and math.floor((v + mult/2)/mult) * mult/num or math.ceil((v - mult/2)/mult) * mult/num
end

-- convert a number to a string with a limited number of significant figures (after the decimal)
-- @param[type=number] num -- number to format
-- @param[type=number] sig_figs -- significant figures to display, default 3 (truncates only the fractional portion)
-- @param[type=string] pre_format -- first component of the format field (use "+" to force display of the sign)
-- @return[1][type=string] a string representation of the number with a limited fractional component
-- @return[2][type=string] the format used to display the number
function string.limit_decimals(num, sig_figs, pre_format)
	sig_figs = (sig_figs or 3) - 1
	local fmt = ("%%%s.%df"):format(pre_format or "", util.bound(sig_figs-math.floor(math.log10(math.abs(num))), 0, sig_figs))
	return (fmt):format(num), fmt
end

function math.scale(i, imin, imax, dmin, dmax)
	local bi = i - imin
	local bm = imax - imin
	local dm = dmax - dmin
	return bi * dm / bm + dmin
end

function math.boundscale(i, imin, imax, dmin, dmax)
	local bi = i - imin
	local bm = imax - imin
	local dm = dmax - dmin
	return util.bound(bi * dm / bm + dmin, dmin, dmax)
end

function math.triangle_area(p1, p2, p3)
	local u = {x=p2.x - p1.x, y=p2.y - p1.y}
	local v = {x=p3.x - p1.x, y=p3.y - p1.y}
	local au = math.atan2(u.y, u.x)
	local av = math.atan2(v.y, v.x)
	local lu = math.sqrt(u.x*u.x + u.y*u.y)
	local lv = math.sqrt(v.x*v.x + v.y*v.y)
	return math.abs(0.5 * lu * lv * math.sin(av - au))
end

function lpeg.anywhere (p)
	return lpeg.P{ p + 1 * lpeg.V(1) }
end

function table.concatNice(t, sep, endsep)
	if not endsep or #t == 1 then return table.concat(t, sep) end
	return table.concat(t, sep, 1, #t - 1)..endsep..t[#t]
end

---Convert a table (non-recursively) to a table of strings for each key/value pair
-- @param src <table> = source table
-- @param fmt <string, optional, default "[%s]=%s"> = format to use for each key-value pair
-- @return <table> table containing a string for each key in the source table
table.to_strings = function(src, fmt)
	if type(src) ~= "table" then return {tostring(src)} end
	local tt = {}
	fmt = fmt or "[%s]=%s"
	for label, val in pairs(src) do
		tt[#tt+1] = (fmt):format(label, tostring(val))
	end
	return tt
end

--- Same as ipairs but first shallow clone the table so that the base table can be altered safely
function ipairsclone(t)
	return ipairs(table.clone(t, false))
end

--- Same as pairs but first shallow clone the table so that the base table can be altered safely
function pairsclone(t)
	return pairs(table.clone(t, false))
end

--- Same as ripairs but first shallow clone the table so that the base table can be altered safely
function ripairsclone(t)
	return ripairs(table.clone(t, false))
end

function ripairs(t)
	local i = #t
	return function()
		if i == 0 then return nil end
		local oi = i
		i = i - 1
		return oi, t[oi]
	end
end

function table.weak_keys(t)
	t = t or {}
	setmetatable(t, {__mode="k"})
	return t
end

function table.weak_values(t)
	t = t or {}
	setmetatable(t, {__mode="v"})
	return t
end

function table.empty(t)
	while next(t) do t[next(t)] = nil end
end

function table.replaceWith(t, nt)
	table.empty(t)
	for k, e in pairs(nt) do t[k] = e end
end

function table.count(t)
	local i = 0
	for k, v in pairs(t) do
		i = i + 1
	end
	return i
end

function table.min(t)
	local m = nil
	for _, v in pairs(t) do
		if not m then m = v
		else m = math.min(m, v)
		end
	end
	return m
end

function table.max(t)
	local m = nil
	for _, v in pairs(t) do
		if not m then m = v
		else m = math.max(m, v)
		end
	end
	return m
end

function table.print_shallow(src, offset, line_feed)
	if not line_feed then line_feed = '\n' end
	if type(src) ~= "table" then core.game.stdout_write("table.print has no table:", src) core.game.stdout_write(line_feed) return end
	offset = offset or ""
	for k, e in pairs(src) do
		core.game.stdout_write(("%s[%s] = %s"):format(offset, tostring(k), tostring(e))) core.game.stdout_write(line_feed)
	end
end

function table.print(src, offset, line_feed)
	if not line_feed then line_feed = '\n' end
	if type(src) ~= "table" then core.game.stdout_write("table.print has no table:", src) core.game.stdout_write(line_feed) return end
	offset = offset or ""
	for k, e in pairs(src) do
		-- Deep copy subtables, but not objects!
		if type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			core.game.stdout_write(("%s[%s] = {"):format(offset, tostring(k))) core.game.stdout_write(line_feed)
			table.print(e, offset.."  ", line_feed)
			core.game.stdout_write(("%s}"):format(offset)) core.game.stdout_write(line_feed)
		else
			core.game.stdout_write(("%s[%s] = %s"):format(offset, tostring(k), tostring(e))) core.game.stdout_write(line_feed)
		end
	end
end

function table.iprint(src, offset, line_feed)
	if not line_feed then line_feed = '\n' end
	if type(src) ~= "table" then core.game.stdout_write("table.iprint has no table:", src) core.game.stdout_write(line_feed) return end
	offset = offset or ""
	for k, e in ipairs(src) do
		-- Deep copy subtables, but not objects!
		if type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			core.game.stdout_write(("%s[%s] = {"):format(offset, tostring(k))) core.game.stdout_write(line_feed)
			table.print(e, offset.."  ")
			core.game.stdout_write(("%s}"):format(offset)) core.game.stdout_write(line_feed)
		else
			core.game.stdout_write(("%s[%s] = %s"):format(offset, tostring(k), tostring(e))) core.game.stdout_write(line_feed)
		end
	end
end

function tprint(...)
	local args = {...}
	for i, str in ipairs(args) do
		if type(str) == "table" then core.game.stdout_write('{ ') table.print(str, nil, ', ') core.game.stdout_write(' }')
		else core.game.stdout_write(tostring(str)) end
		if i < #args then core.game.stdout_write('\t') end
	end
	core.game.stdout_write('\n')
end

--- Generate a containing indexes between a and b and set to value v
function table.genrange(a, b, v)
	local t = {}
	for i = a, b do
		t[i] = v
	end
	return t
end

--- Return a new table containing the keys from t1 without the keys from t2
function table.minus_keys(t1, t2)
	local t = table.clone(t1)
	for k, _ in pairs(t2) do t[k] = nil end
	return t
end

--- Returns a clone of a table
-- @param tbl The original table to be cloned
-- @param deep Boolean allow recursive cloning (unless .__ATOMIC or .__CLASSNAME is defined)
-- @param k_skip A table containing key values set to true if you want to skip them.
-- @param clone_meta If true table and subtables that have a metatable will have it assigned to the clone too
-- @return The cloned table.
function table.clone(tbl, deep, k_skip, clone_meta)
	if not tbl then return nil end
	local n = {}
	k_skip = k_skip or {}
	for k, e in pairs(tbl) do
		if not k_skip[k] then
			-- Deep copy subtables, but not objects!
			if deep and type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
				n[k] = table.clone(e, true, k_skip, clone_meta)
			else
				n[k] = e
			end
		end
	end
	if clone_meta then
		setmetatable(n, getmetatable(tbl))
	end
	return n
end

table.NIL_MERGE = {}

--- Merges two tables in-place.
-- @param dst The destination table, which will have all merged values.
-- @param src The source table, supplying values to be merged.
-- @param deep Boolean that determines if tables will be recursively merged.
-- @param k_skip A table containing key values set to true if you want to skip them.
-- @param k_skip_deep Like k_skip, except this table is passed on to the deep recursions.
-- @param addnumbers Boolean that determines if two numbers will be added rather than replaced.
-- assign the special value table.NIL_MERGE in src to set the corresponding dst field to nil.
-- subtables containing .__ATOMIC or .__CLASSNAME will be copied by reference.
function table.merge(dst, src, deep, k_skip, k_skip_deep, addnumbers)
	k_skip = k_skip or {}
	k_skip_deep = k_skip_deep or {}
	for k, e in pairs(src) do
		if not k_skip[k] and not k_skip_deep[k] then
			-- Recursively merge tables
			if e == table.NIL_MERGE then -- remove corresponding field
				dst[k] = nil
			elseif deep and dst[k] and type(e) == "table" and type(dst[k]) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
				table.merge(dst[k], e, deep, nil, k_skip_deep, addnumbers)
			-- Clone tables if into the destination
			elseif deep and not dst[k] and type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
				dst[k] = table.clone(e, deep, nil, k_skip_deep)
			-- Add number entries if "add" is set
			elseif addnumbers and not dst.__no_merge_add and dst[k] and type(dst[k]) == "number" and type(e) == "number" then
				dst[k] = dst[k] + e
			-- Or simply replace/set with the src value
			else
				dst[k] = e
			end
		end
	end
	return dst
end

function table.mergeAppendArray(dst, src, deep, k_skip, k_skip_deep, addnumbers)
	-- Append the array part
	k_skip = k_skip or {}
	for i = 1, #src do
		k_skip[i] = true
		local b = src[i]
		if deep and type(b) == "table" then
			if b.__ATOMIC or b.__CLASSNAME then
				b = b:clone()
			else
				b = table.clone(b, true)
			end
		end
		table.insert(dst, b)
	end
	-- Copy the table part
	return table.merge(dst, src, deep, k_skip, k_skip_deep, addnumbers)
end

function table.mergeAdd(dst, src, deep, k_skip, k_skip_deep)
	return table.merge(dst, src, deep, k_skip, k_skip_deep, true)
end

--- Merges additively the named fields and append the array part
-- Yes this is weird and you'll probably not need it, but the engine does :)
function table.mergeAddAppendArray(dst, src, deep, k_skip, k_skip_deep)
	return table.mergeAppendArray(dst, src, deep, k_skip, k_skip_deep, true)
end

function table.append(dst, src)
	for i = 1, #src do dst[#dst+1] = src[i] end
	return dst
end

function table.reverse(t)
	local tt = {}
	for i, e in ipairs(t) do tt[e] = i end
	return tt
end

function table.reversekey(t, k)
	local tt = {}
	for i, e in ipairs(t) do tt[e[k]] = i end
	return tt
end

function table.listify(t)
	local tt = {}
	for k, e in pairs(t) do tt[#tt+1] = {k, e} end
	return tt
end

function table.keys_to_values(t)
	local tt = {}
	for k, e in pairs(t) do tt[e] = k end
	return tt
end

function table.keys(t)
	local tt = {}
	for k, e in pairs(t) do tt[#tt+1] = k end
	return tt
end

function table.ts(t, tag)
	local tt = {}
	for i, e in ipairs(t) do tt[i] = _t(e, tag) end
	return tt
end

function table.lower(t)
	local tt = {}
	for i, e in ipairs(t) do tt[i] = e:lower() end
	return tt
end

function table.capitalize(t)
	local tt = {}
	for i, e in ipairs(t) do tt[i] = e:capitalize() end
	return tt
end

function string.tslash(str, tag)
	if str:find("/") then
		local pos, _ = str:find("/")
		return _t(str:sub(1, pos - 1), tag) .. "/" .. string.tslash(str:sub(pos + 1), tag)
	else
		return _t(str, tag)
	end
end

function string.ttype(str, type)
	if str:find("/") then
		local pos, _ = str:find("/")
		return _t(str:sub(1, pos - 1), type.. " type") .. "/" .. _t(str:sub(pos + 1), type.." subtype")
	else
		return _t(str, type.." type")
	end
end


function table.values(t)
	local tt = {}
	for k, e in pairs(t) do tt[#tt+1] = e end
	return tt
end

--- Check if 2 tables are equivalent
-- tables are equivalent if they are identical or contain the same values assigned to the same keys
-- search stops after the first difference is found
-- @param t1, t2 tables to compare
-- @param recurse [type=boolean or table] set to recursively check non-identical sub-tables for equivalence
--		if recurse is a table, the keys pointing to the difference will be stored in it in order
--		differing values: table.get(t1, unpack(recurse)), table.get(t2, unpack(recurse))
-- @return[1] [type=boolean] true if the tables are equivalent
-- @return[2] nil (if tables are equivalent)
-- @return[2], first key found holding different value (if recurse == true)
-- @return[2], recurse (if recurse is a table)
function table.equivalence(t1, t2, recurse)
	local save_keys = type(recurse) == "table"
	if t1 ~= t2 then
		if not (t1 and t2) then return false end
		for k1, v1 in pairs(t1) do
			if t2[k1] ~= v1 and not (recurse and type(v1) == "table" and type(t2[k1]) == "table" and table.equivalence(t2[k1], v1, recurse)) then
				if save_keys then table.insert(recurse, 1, k1) return false, recurse else return false, k1 end
			end
		end
		for k2, v2 in pairs(t2) do
			if t1[k2] ~= v2 and not (recurse and type(v2) == "table" and type(t1[k2]) == "table" and table.equivalence(t1[k2], v2, recurse)) then
				if save_keys then table.insert(recurse, 1, k2) return false, recurse else return false, k2 end
			end
		end
	end
	return true
end

--- Check (non-recursively) if 2 indexed tables contain all of the same values
-- @param t1, t2 tables to compare
-- @return true if all values in t1 are also in t2 and visa versa
function table.extract_field(t, field, iterator)
	iterator = iterator or pairs
	local tt = {}
	for k, e in iterator(t) do tt[k] = e[field] end
	return tt
end

function table.same_values(t1, t2)
	for _, e1 in ipairs(t1) do
		local ok = false
		for _, e2 in ipairs(t2) do
			if e1 == e2 then ok = true break end
		end
		if not ok then return false end
	end
	for _, e2 in ipairs(t2) do
		local ok = false
		for _, e1 in ipairs(t1) do
			if e1 == e2 then ok = true break end
		end
		if not ok then return false end
	end
	return true
end

function table.from_list(t, k, v)
	local tt = {}
	for i, e in ipairs(t) do tt[e[k or 1]] = e[v or 2] end
	return tt
end

function table.hasInList(t, v)
	for i = #t, 1, -1 do if t[i] == v then return true end end
	return false
end

function table.removeFromList(t, ...)
	for _, v in ipairs{...} do
		for i = #t, 1, -1 do if t[i] == v then table.remove(t, i) end end
	end
end

function table.pairsRemove(t, check)
	local todel = {}
	for k, v in pairs(t) do
		if check(k, v) then todel[#todel+1] = k end
	end
	for _, k in ipairs(todel) do
		t[k] = nil
	end
	return #todel
end

function table.check(t, fct, do_recurse, path)
	if path and path ~= '' then path = path..'/' else path = '' end
	do_recurse = do_recurse or function() return true end
	for k, e in pairs(t) do
		local tk, te = type(k), type(e)
		if te == "table" and not e.__ATOMIC and not e.__CLASSNAME and do_recurse(e) then
			local ok, err = table.check(e, fct, do_recurse, path..tostring(k))
			if not ok then return nil, err end
		else
			local ok, err = fct(t, path..tostring(k), e, te)
			if not ok then return nil, err end
		end

		if tk == "table" and not k.__ATOMIC and not k.__CLASSNAME and do_recurse(k) then
			local ok, err = table.check(k, fct, do_recurse, path..tostring(k))
			if not ok then return nil, err end
		else
			local ok, err = fct(t, path.."<key>", k, tk)
			if not ok then return nil, err end
		end
	end
	return true
end

--- Adds missing keys from the src table to the dst table.
-- @param dst The destination table, which will have all merged values.
-- @param src The source table, supplying values to be merged.
-- @param deep Boolean that determines if tables will be recursively merged.
function table.update(dst, src, deep)
	for k, e in pairs(src) do
		if deep and dst[k] and type(e) == "table" and type(dst[k]) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			table.update(dst[k], e, deep)
		elseif deep and not dst[k] and type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			dst[k] = table.clone(e, deep)
		elseif not dst[k] and type(dst[k]) ~= "boolean" then
			dst[k] = e
		end
	end
end

--- Creates a read-only table
function table.readonly(src)
   for k, v in pairs(src) do
	if type(v) == "table" then
		src[k] = table.readonly(v)
	end
   end
   return setmetatable(src, {
	 __newindex = function(src, key, value)
					error("Attempt to modify read-only table")
				end,
	__metatable = false
   });
end

-- Make a new table with each k, v = f(k, v) in the original.
function table.map(f, source)
	local result = {}
	for k, v in pairs(source) do
		k2, v2 = f(k, v)
		result[k2] = v2
	end
	return result
end

-- Make a new table with each k, v = k, f(v) in the original.
function table.mapv(f, source)
	local result = {}
	for k, v in pairs(source) do
		result[k] = f(v)
	end
	return result
end

-- Make a new list with each k, v = k, f(v) in the original.
function table.maplist(f, source)
	local result = {}
	for i, v in ipairs(source) do
		local v2 = f(i, v)
		if v2 then result[#result+1] = v2 end
	end
	return result
end

-- Make a new list with each k, v = k, f(v) in the original.
function table.splitlist(f, source)
	local results = {}
	for i, v in ipairs(source) do
		local id, v2 = f(i, v)
		if id and v2 then
			results[id] = results[id] or {}
			table.insert(results[id], v2)
		end
	end
	return results
end

-- Find the keys that are only in left, only in right, and are common
-- to both.
function table.compareKeys(left, right)
	local result = {left = {}, right = {}, both = {}}
	for k, _ in pairs(left) do
		if right[k] then
			result.both[k] = true
		else
			result.left[k] = true
		end
	end
	for k, _ in pairs(right) do
		if not left[k] then
			result.right[k] = true
		end
	end
	return result
end

--- Checks if a (sub)subentry of a table exists
function table.has(t, ...)
	if type(t) ~= 'table' then return false end
	local args = {...}
	local last = table.remove(args)
	for _, key in ipairs(args) do
		t = t[key]
		if type(t) ~= 'table' then return false end
	end
	return t[last]
end

--[=[
  Decends recursively through a table by the given list of keys.

  1st return: The first non-table value found, or the final value if
  we ran out of keys.

  2nd return: If the list of keys was exhausted

  Meant to replace multiple ands to get a value:
  "a and a.b and a.b.c" turns to "rget(a, 'b', 'c')"
]=]
function table.get(table, ...)
	if type(table) ~= 'table' then return table, false end
	for _, key in ipairs({...}) do
		if type(table) ~= 'table' then return table, false end
		table = table[key]
	end
	return table, true
end

--[=[
  Set the nested value in a table, creating empty tables as needed.
]=]
function table.set(table, ...)
	if type(table) ~= 'table' then return false end
	local args = {...}
	for i = 1, #args - 2 do
		local key = args[i]
		local subtable = table[key]
		if not subtable then
			subtable = {}
			table[key] = subtable
		end
		table = subtable
	end
	table[args[#args - 1]] = args[#args]
end

--[=[
	Decends recursively through a table by the given list of keys,
	returning the table at the end. Missing keys will have tables
	created for them. If a non-table value is encountered, return nil.
]=]
function table.getTable(table, ...)
	if 'table' ~= type(table) then return end
	local args = {...}
	for i = 1, #args do
		local key = args[i]
		local subtable = table[key]
		if not subtable then
			subtable = {}
			table[key] = subtable
		end
		if 'table' ~= type(subtable) then return end
		table = subtable
	end
	return table
end

-- Taken from http://lua-users.org/wiki/SortedIteration and modified
local function cmp_multitype(op1, op2)
	local type1, type2 = type(op1), type(op2)
	if type1 ~= type2 then --cmp by type
		return type1 < type2
	elseif type1 == "number" or type1 == "string" then
		return op1 < op2 --comp by default
	elseif type1 == "boolean" then
		return op1 == true
	else
		return tostring(op1) < tostring(op2) --cmp by address
	end
end

function table.orderedPairs(t)
	local sorted_keys = {}
	local n = 0		-- size of key table
	for key, _ in pairs(t) do
		n = n + 1
		sorted_keys[n] = key
	end
	table.sort(sorted_keys, cmp_multitype)

	local i = 0		-- iterator index
	return function ()
		if i < n then
			i = i + 1
			return sorted_keys[i], t[sorted_keys[i]], i == n
		end
	end
end

-- ordering is a function({k1, v1}, {k2, v2}), it should return true
-- when left is < right.
function table.orderedPairs2(t, ordering)
	if not next(t) then return function() end end
	t = table.listify(t)
	if #t > 1 then table.sort(t, ordering) end
	local index = 1
	return function()
		if index <= #t then
			value = t[index]
			index = index + 1
			return value[1], value[2], index == #t + 1
		end
	end
end

--- Shuffles the content of a table (list)
function table.shuffle(t)
	local n = #t
	for i = n, 2, -1 do
		local j = rng.range(1, i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

-- Common table rules.
table.rules = {}

--[[
Applies a series of rules to a pair of tables. rules should be a list of functions
to be applied, in order, until one returns true.

All keys in the table src are looped through, starting with array
indices, and then the rest of the keys. The rules are given the
following arguments:
The dst table's value for the current key.
The src table's value for the current key.
The current key.
The dst table.
The src table.
The list of rules.
A state table which the rules are free to modify.
--]]
function table.applyRules(dst, src, rules, state)
	if not dst or not src then return end
	state = state or {}
	local used_keys = {}
	-- First loop through with ipairs so we get the numbers in order.
	for k, v in ipairs(src) do
		used_keys[k] = true
		for _, rule in ipairs(rules) do
			if rule(dst[k], src[k], k, dst, src, rules, state) then
				break
			end
		end
	end
	-- Then loop through with pairs, skipping the ones we got with ipairs.
	for k, v in pairs(src) do
		if not used_keys[k] then
			for _, rule in ipairs(rules) do
				if rule(dst[k], src[k], k, dst, src, rules, state) then
					break
				end
			end
		end
	end
end

-- Simply overwrites the value.
table.rules.overwrite = function(dvalue, svalue, key, dst)
	if svalue == table.NIL_MERGE then
		svalue = nil
	elseif type(svalue) == 'table' and not svalue.__ATOMIC and not svalue.__CLASSNAME then
		svalue = table.clone(svalue, true)
	end
	dst[key] = svalue
	return true
end
-- Does the recursion.
table.rules.recurse = function(dvalue, svalue, key, dst, src, rules, state)
	if type(svalue) ~= 'table' or
		svalue.__ATOMIC or svalue.__CLASSNAME or
		(type(dvalue) ~= 'table' and svalue == table.NIL_MERGE)
	then return end
	if type(dvalue) ~= 'table' then
		dvalue = {}
		dst[key] = dvalue
	end
	state = table.clone(state)
	state.path = table.clone(state.path) or {}
	table.insert(state.path, key)
	table.applyRules(dvalue, svalue, rules, state)
	return true
end
-- Appends indices.
table.rules.append = function(dvalue, svalue, key, dst, src, rules, state)
	if type(key) ~= 'number' then return end
	if type(svalue) == 'table' then
		if svalue.__ATOMIC or svalue.__CLASSNAME then
			svalue = svalue:clone()
		else
			svalue = table.clone(svalue, true)
		end
	end
	table.insert(dst, svalue)
	return true
end
-- Appends indices if we're on the top level
table.rules.append_top = function(dvalue, svalue, key, dst, src, rules, state)
	if state.path and #state.path > 0 then return end
	if type(key) ~= 'number' then return end
	if type(svalue) == 'table' then
		if svalue.__ATOMIC or svalue.__CLASSNAME then
			svalue = svalue:clone()
		else
			svalue = table.clone(svalue, true)
		end
	end
	table.insert(dst, svalue)
	return true
end
-- Adds numbers
table.rules.add = function(dvalue, svalue, key, dst)
	if type(dvalue) ~= 'number' or
		type(svalue) ~= 'number' or
		dst.__no_merge_add
	then return end
	dst[key] = dvalue + svalue
	return true
end

--[[
A convenience method for merging tables, appending numeric indices,
and adding number values in addition to other rules.
--]]
function table.ruleMergeAppendAdd(dst, src, rules, state)
	rules = table.clone(rules)
	for _, rule in pairs {'append_top', 'recurse', 'add', 'overwrite'} do
		table.insert(rules, table.rules[rule])
	end
	table.applyRules(dst, src, rules, state)
end

string.nextUTF = core.display.stringNextUTF

function string.ordinal(number)
	local suffix = _t"%dth"
	number = tonumber(number)
	local base = number % 10
	if base == 1 then
		suffix = _t"%dst"
	elseif base == 2 then
		suffix = _t"%dnd"
	elseif base == 3 then
		suffix = _t"%drd"
	end
	return (suffix):tformat(number)
end

function string.trim(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

function string.a_an(str)
	local first = str:sub(1, 1)
	if first == "a" or first == "e" or first == "i" or first == "o" or first == "u" or first == "y" then return _t"an "..str
	else return _t"a "..str end
end

function string.he_she(actor)
	if actor.female then return _t"she"
	elseif actor.neuter then return _t"it"
	else return _t"he"
	end
end

function string.his_her(actor)
	if actor.female then return _t"her"
	elseif actor.neuter then return _t"its"
	else return _t"his"
	end
end

function string.him_her(actor)
	if actor.female then return _t"her"
	elseif actor.neuter then return _t"it"
	else return _t"him"
	end
end

function string.his_her_self(actor)
	if actor.female then return _t"herself"
	elseif actor.neuter then return _t"itself"
	else return _t"himself"
	end
end

function string.capitalize(str)
	if #str > 1 then
		return string.upper(str:sub(1, 1))..str:sub(2)
	elseif #str == 1 then
		return str:upper()
	else
		return str
	end
end

function string.bookCapitalize(str)
	local words = str:split(' ')

	for i = 1, #words do
		local word = words[i]

		-- Don't capitalize certain words unless they are at the beginning
		-- of the string.
		if i == 1 or (word ~= "of" and word ~= "the" and word ~= "and" and word ~= "a" and word ~= "an")
		then
			words[i] = word:gsub("^(.)",
							function(x)
								return x:upper()
							end)
		end
	end

	return table.concat(words, " ")
end

local function default_noun_sub(str, type, noun)
	return str:gsub(type, noun)
end
function string.noun_sub(str, type, noun)
	local proc = _getFlagI18N("noun_target_sub") or default_noun_sub
	return proc(str, type, noun)
end

function string.lpegSub(s, patt, repl)
	patt = lpeg.P(patt)
	patt = lpeg.Cs((patt / repl + 1)^0)
	return lpeg.match(patt, s)
end

function string.lpegSubT(s, patt, repl, fct)
	patt = lpeg.Cmt(lpeg.P(patt), function(s, i, c) fct(c, i - #c, i - 1) return true end)
	patt = lpeg.Cs((patt / repl + 1)^0)
	return lpeg.match(patt, s)
end

function string.prefix(s, p)
	if s:sub(1, #p) == p then return true end
	return false
end

function string.suffix(s, p)
	if s:sub(#s - #p + 1) == p then return true end
	return false
end

function string.iterateUTF(str, pos, get_char)
	pos = pos or 1
	return function()
		if not pos then return nil end
		local op = pos
		pos = str:nextUTF(pos)
		local np = pos
		if not np then np = #str + 1 end
		local s = nil
		if get_char == "char" then s = str:sub(op, np-1)
		elseif get_char == "to" then s = str:sub(1, np-1)
		elseif get_char == "from" then s = str:sub(op)
		end
		return op, np-1, s
	end
end

-- Those matching patterns are used both by splitLine and drawColorString*
local Puid = "UID:" * lpeg.R"09"^1 * ":" * lpeg.R"09"
local Puid_cap = "UID:" * lpeg.C(lpeg.R"09"^1) * ":" * lpeg.C(lpeg.R"09")
local Pcolorname = (lpeg.R"AZ" + "_")^3
local Pextra = "&" * lpeg.P"linebg:" * lpeg.C(lpeg.R"09"^1 + Pcolorname)
local Pcode = (lpeg.R"af" + lpeg.R"09" + lpeg.R"AF")
local Pcolorcode = Pcode * Pcode
local Pfontstyle = "{" * (lpeg.P"bold" + lpeg.P"italic" + lpeg.P"underline" + lpeg.P"normal") * "}"
local Pfontstyle_cap = "{" * lpeg.C(lpeg.P"bold" + lpeg.P"italic" + lpeg.P"underline" + lpeg.P"normal") * "}"
local Pcolorcodefull = Pcolorcode * Pcolorcode * Pcolorcode

function string.removeColorCodes(str)
	return str:lpegSub("#" * (Puid + Pcolorcodefull + Pcolorname + Pfontstyle + Pextra) * "#", "")
end

function string.removeColorCodesT(str)
	local posmap = {}
	local last = 0
	local res = str:lpegSubT("#" * (Puid + Pcolorcodefull + Pcolorname + Pfontstyle + Pextra) * "#", "", function(c, p1, p2)
		for i = last + 1, p1 - 1 do
			posmap[#posmap+1] = i
		end
		last = p2
	end)

	for i = last + 1, #str do
		posmap[#posmap+1] = i
	end

	return res, posmap
end

function string.removeUIDCodes(str)
	return str:lpegSub("#" * Puid * "#", "")
end

function string.splitAtSizeSimple(str, size, font)
	local fontoldsize = font.simplesize or font.size
	local left, right
	local cs = 0

	local oldleft
	for pos, pos2, left in str:iterateUTF(1, "to") do
		if not oldleft then oldleft = left end

		local ps = fontoldsize(font, left)
		if ps > size then
			right = str:sub(pos)
			return oldleft, fontoldsize(font, oldleft), right, fontoldsize(font, right)
		end

		oldleft = left
	end
	return str, fontoldsize(font, str), "", 0
end

function string.splitAtSize(bstr, size, font)
	local str, posmap = bstr:removeColorCodesT()
	local fontoldsize = font.simplesize or font.size
	local left, right
	local cs = 0

	local oldpos2
	for pos, pos2, left in str:iterateUTF(1, "to") do
		if not oldpos2 then oldpos2 = pos2 end

		local ps = fontoldsize(font, left)
		if ps > size then
			local left = bstr:sub(1, posmap[oldpos2])
			right = bstr:sub(posmap[pos])
			return left, fontoldsize(font, left), right, fontoldsize(font, right)
		end

		oldpos2 = pos2
	end
	return str, fontoldsize(font, str), "", 0
end

function string.splitLine(str, max_width, font)
	local fontoldsize = font.simplesize or font.size
	local space_w = fontoldsize(font, " ")
	local lines = {}
	local cur_line, cur_size = "", 0
	local v
	local break_all_chars = core.display.getBreakTextAllCharacter()
	local ls = str:split(lpeg.S"\n ")
	for i = 1, #ls do
		local v = ls[i]
		local shortv = v:removeColorCodes()
		local w, h = fontoldsize(font, shortv)

		if cur_size + space_w + w < max_width then
			cur_line = cur_line..(cur_size==0 and "" or " ")..v
			cur_size = cur_size + (cur_size==0 and 0 or space_w) + w
		else
			-- Normal whitespace breaking
			if not break_all_chars then
				lines[#lines+1] = cur_line
				cur_line = v
				cur_size = w
			-- Break on any characters
			else
				local left, left_size, right, right_size
				while true do
					left, left_size, right, right_size = v:splitAtSize(max_width - cur_size, font)

					-- Add to current line
					cur_line = cur_line..(cur_size==0 and "" or " ")..left
					cur_size = cur_size + (cur_size==0 and 0 or space_w) + left_size
					lines[#lines+1] = cur_line

					-- If the right side can fit on a line, we're done, otherwise we split again
					if right_size <= max_width then
						break
					else
						cur_line = ""
						cur_size = 0
						v = right
					end
				end

				-- Put the rest on new line
				cur_line = right
				cur_size = right_size
			end
		end
	end
	if cur_size > 0 then lines[#lines+1] = cur_line end
	return lines
end

function string.splitLines(str, max_width, font)
	local lines = {}
	local ls = str:split(lpeg.S"\n")
	local v
	for i = 1, #ls do
		v = ls[i]
		local ls = v:splitLine(max_width, font)
		if #ls > 0 then
			for i, l in ipairs(ls) do
				lines[#lines+1] = l
			end
		else
			lines[#lines+1] = ""
		end
	end
	return lines
end

--- create a textual abbreviation for a function
--	@param fct the function
--	@param fmt output format for filepath, line number, first line of code
--		(default: "\"<function( defined: %s, line %s): %s>\"" )
--	@return string using the format provided
function string.fromFunction(fct, fmt)
	local info = debug.getinfo(fct, "S")
	local fpath = string.gsub(info.source,"@","")
	local firstline = ""
	fmt = fmt or "\"<function( defined: %s, line %s): %s>\""
	if not fs.exists(fpath) then
		fpath = "no file path"
		firstline = info.short_src
	else
		local f = fs.open(fpath, "r")
		local line_num = 0
		while true do -- could continue with body here
			firstline = f:readLine()
			if firstline then
				line_num = line_num + 1
				if line_num == info.linedefined then break end
			end
		end
	end
	return (fmt):format(fpath, info.linedefined, tostring(firstline))
end

--- Create a textual representation of a value
-- similar to tostring, but includes special handling of tables and functions
--	surrounds non-numbers/booleans/nils/functions with ""
-- @param v: the value
-- @param recurse: the recursion level for string.fromTable, set < 0 for basic tostring
-- @param offset, prefix, suffix: inputs to string.fromTable for converting tables
function string.fromValue(v, recurse, offset, prefix, suffix)
	recurse, offset, prefix, suffix = recurse or 0, offset or ", ", prefix or "{", suffix or "}"
	local vt, vs = type(v)
	if vt == "table" then
		if recurse < 0 then vs = tostring(v)
		elseif v.__ATOMIC or v.__CLASSNAME then -- create entity/atomic label
			local abv = {}
			if v.__CLASSNAME then abv[#abv+1] = "__CLASSNAME="..tostring(v.__CLASSNAME) end
			if v.__ATOMIC then abv[#abv+1] = "ATOMIC" end
			vs = ("%s\"%s%s%s\"%s"):format(prefix, v, v.__CLASSNAME and ", __CLASSname=_t"..tostring(v.__CLASSNAME) or "", v.__ATOMIC and ", ATOMIC" or "", suffix)
		elseif recurse > 0 then -- get recursive string
			vs = string.fromTable(v, recurse - 1, offset, prefix, suffix)
		else vs = prefix.."\""..tostring(v).."\""..suffix
		end
	elseif vt == "function" then
		vs = recurse >= 0 and string.fromFunction(v) or tostring(v)
	elseif not (vt == "number" or vt == "boolean" or vt == "nil") then
		vs = "\""..tostring(v).."\""
	end
	return vs or tostring(v)
end

--- Create a textual representation of a table
--	This is like reverse-interpreting back to lua code, compatible for strings, numbers, and tables
--	@param src: source table
--	@param recurse: recursion level for subtables (default 0)
--	@param offset: string to insert between table fields (default: ", ")
--	@param prefix: prefix for the table and subtables (default: "{")
--	@param suffix: suffix for the table and subtables (default: "}")
--	@param sort: optional sort function(a, b) to sort results (by key, set == true for ascending order)
--  @param key_recurse the recursion level for keys that are tables (default 0)
--	@return[1] single line text representation of src
--		non-string table.keys are surrounded by "[", "]"
--	@return[2] indexed table containing strings for each key/value pair in src (@recursion level 0)
--		recursed subtables are converted and embedded
--		subtables containing .__ATOMIC or .__CLASSNAME are never converted, but are noted
--		functions are converted to embedded strings using string.fromFunction
function string.fromTable(src, recurse, offset, prefix, suffix, sort, key_recurse)
	if type(src) ~= "table" then print("string.fromTable has no table:", src) return tostring(src) end
	local tt = {}
	recurse, offset, prefix, suffix = recurse or 0, offset or ", ", prefix or "{", suffix or "}"
	for k, v in pairs(src) do
		local kt, vt = type(k), type(v)
		local ks, vs
		if kt ~= "string" then
			ks = "["..string.fromValue(k, key_recurse, offset, prefix, suffix).."]"
		end
		vs = string.fromValue(v, recurse, offset, prefix, suffix)
		tt[#tt+1] = ("%s=%s"):format(ks or tostring(k), vs or tostring(v))
	end
	if sort == true then sort = function(a, b) return a < b end end
	if sort then table.sort(tt, sort) end
	-- could sort here if desired
	return prefix..table.concat(tt, offset)..suffix, tt
end

--- Returns the Levenshtein distance between the two given strings
function string.levenshtein_distance(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
	
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
	
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
	
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end
			
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end
	
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

-- Split a string by the given character(s)
function string.split(str, char, keep_separator)
	char = lpeg.P(char)
	if keep_separator then char = lpeg.C(char) end
	local elem = lpeg.C((1 - char)^0)
	local p = lpeg.Ct(elem * (char * elem)^0)
	return lpeg.match(p, str)
end


local hex_to_dec = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["a"] = 10,
	["b"] = 11,
	["c"] = 12,
	["d"] = 13,
	["e"] = 14,
	["f"] = 15,
}
local hexcache = {}
function string.parseHex(str)
	if hexcache[str] then return hexcache[str] end
	local res = 0
	local power = 1
	str = str:lower()
	for i = 1, #str do
		res = res + power * (hex_to_dec[str:sub(#str-i+1,#str-i+1)] or 0)
		power = power * 16
	end
	hexcache[str] = res
	return res
end

function string.toHex(str,spacer)
	return string.gsub(str, ".", function(c) return string.format("%02X%s",string.byte(c), spacer or "") end)
end

function __get_uid_surface(uid, w, h)
	uid = tonumber(uid)
	local e = uid and __uids[uid]
	local tiles
	if game.level then tiles = game.level.map.tiles
	else tiles = require("engine.Map").tiles end
	if e and tiles then
		return e:getEntityFinalSurface(tiles, w, h)
	end
	return nil
end

function __get_uid_entity(uid)
	uid = tonumber(uid)
	local e = uid and __uids[uid]
	if e then
		return e
	end
	return nil
end

local tmps = core.display.newSurface(1, 1)
getmetatable(tmps).__index.drawColorStringBlended = function(s, font, str, x, y, r, g, b, alpha_from_texture, limit_w)
	local tstr = str:toTString()
	return tstr:drawOnSurface(s, limit_w or 99999999, 1, font, x, y, r, g, b, not alpha_from_texture)
end
getmetatable(tmps).__index.drawColorString = getmetatable(tmps).__index.drawColorStringBlended

getmetatable(tmps).__index.drawColorStringBlendedCentered = function(s, font, str, dx, dy, dw, dh, r, g, b, alpha_from_texture, limit_w)
	local w, h = font:size(str)
	local x, y = dx + (dw - w) / 2, dy + (dh - h) / 2
	s:drawColorStringBlended(font, str, x, y, r, g, b, alpha_from_texture, limit_w)
end
getmetatable(tmps).__index.drawColorStringCentered = getmetatable(tmps).__index.drawColorStringBlendedCentered

local font_cache = {}
local oldNewFont = core.display.newFont

core.display.resetAllFonts = function(state)
	for font, sizes in pairs(font_cache) do for size, f in pairs(sizes) do
		f:setStyle(state)
	end end
end

core.display.newFont = function(font, size, no_cache)
	if no_cache then return oldNewFont(font, size) end
	if font_cache[font] and font_cache[font][size] then print("Using cached font", font, size) return font_cache[font][size] end
	font_cache[font] = font_cache[font] or {}
	font_cache[font][size] = oldNewFont(font, size)
	return font_cache[font][size]
end
core.display.getFontCache = function() return font_cache end

local tmps = core.display.newFont("/data/font/Vera.ttf", 12)
local word_size_cache = {}
local fontoldsize = getmetatable(tmps).__index.size
getmetatable(tmps).__index.simplesize = fontoldsize
local fontcachewordsize = function(font, fstyle, v)
	local cache = table.getTable(word_size_cache, font, fstyle)
	if not cache[v] then
		cache[v] = {fontoldsize(font, v)}
	end
	return unpack(cache[v])
end
getmetatable(tmps).__index.size = function(font, str)
	local tstr = str:toTString()
	local mw, mh = 0, 0
	local fstyle = font:getStyle()
	word_size_cache[font] = word_size_cache[font] or {}
	word_size_cache[font][fstyle] = word_size_cache[font][fstyle] or {}
	local v
	for i = 1, #tstr do
		v = tstr[i]
		if type(v) == "table" then
			if v[1] == "font" then
				local fontstyle = v[2]
				font:setStyle(fontstyle)
				fstyle = fontstyle
				word_size_cache[font][fstyle] = word_size_cache[font][fstyle] or {}
			elseif v[1] == "uid" then
				local uid = v[2]
				local e = __uids[uid]
				if e then
					local tiles
					if game.level then tiles = game.level.map.tiles
					else tiles = require("engine.Map").tiles end
					local surf = e:getEntityFinalSurface(tiles, font:lineSkip(), font:lineSkip())
					if surf then
						local w, h = surf:getSize()
						mw = mw + w
						if h > mh then mh = h end
					end
				end
			end -- ignore colors and all that
		elseif type(v) == "string" then
			local w, h = fontcachewordsize(font, fstyle, v)
			if h > mh then mh = h end
			mw = mw + w
		end -- ignore the rest
	end
	return mw, mh
end

local virtualimages = {}
function core.display.virtualImage(path, data)
	virtualimages[path] = data
end

if not core.game.getFrameTime then core.game.getFrameTime = core.game.getTime end

local oldloadimage = core.display.loadImage
function core.display.loadImage(path)
	if virtualimages[path] then return core.display.loadImageMemory(virtualimages[path]) end
	return oldloadimage(path)
end

function fs.iterate(path, filter)
	local list = fs.list(path)
	if filter then
		if type(filter) == "string" then local fstr = filter filter = function(f) return f:find(fstr) end end
		for i = #list, 1, -1 do if not filter(list[i]) then
			table.remove(list, i)
		end end
	end
	local i = 0
	return function()
		i = i + 1
		return list[i]
	end
end

local oldfsexists = fs.exists
function fs.exists(path)
	if virtualimages[path] then return true end
	return oldfsexists(path)
end

local oldfsgetrealpath = fs.getRealPath
function fs.getRealPath(path)
	local p = oldfsgetrealpath(path)
	if not p then return p end
	local sep = fs.getPathSeparator()
	local doublesep = sep..sep
	return p:gsub(doublesep, sep)
end

function fs.readAll(file)
	local f = fs.open(file, "r")
	if not f then return nil, "file not found" end
	local data = f:read(10485760)
	f:close()
	return data
end

tstring = {}
tstring.is_tstring = true

function tstring:add(...)
	local v = {...}
	for i = 1, #v do
		self[#self+1] = v[i]
	end
	return self
end

function tstring:merge(v)
	if not v then return end
	for i = 1, #v do
		self[#self+1] = v[i]
	end
	return self
end

function tstring:clone()
	return tstring(table.clone(self))
end

function tstring:countLines()
	local nb = 1
	local v
	for i = 1, #self do
		v = self[i]
		if type(v) == "boolean" then nb = nb + 1 end
	end
	return nb
end

function tstring:maxWidth(font)
	local max_w = 0
	local old_style = font:getStyle()
	local line_max = 0
	local v
	local w, h = fontoldsize(font, "")
	for i = 1, #self do
		v = self[i]
		if type(v) == "string" then line_max = line_max + fontoldsize(font, v) + 1
	elseif type(v) == "table" then if v[1] == "uid" then line_max = line_max + h -- UID surface is same as font size
		elseif v[1] == "font" and v[2] == "bold" then font:setStyle("bold")
		elseif v[1] == "font" and v[2] == "normal" then font:setStyle("normal") end
		elseif type(v) == "boolean" then max_w = math.max(max_w, line_max) line_max = 0 end
	end
	font:setStyle(old_style)
	max_w = math.max(max_w, line_max) + 1
	return max_w
end

function tstring.from(str)
	if type(str) ~= "table" then
		return tstring{str}
	else
		return str
	end
end

tstring.__tstr_cache = {}
local tstring_cache = tstring.__tstr_cache
setmetatable(tstring_cache, {__mode="v"})

--- Parse a string and return a tstring
function string.toTString(str)
	if tstring_cache[str] then return tstring_cache[str]:clone() end
	local tstr = tstring{}
	local list = str:split(("#" * (Puid + Pcolorcodefull + Pcolorname + Pfontstyle + Pextra) * "#") + lpeg.P"\n", true)
	for i = 1, #list do
		v = list[i]
		local nr, ng, nb = lpeg.match("#" * lpeg.C(Pcolorcode) * lpeg.C(Pcolorcode) * lpeg.C(Pcolorcode) * "#", v)
		local col = lpeg.match("#" * lpeg.C(Pcolorname) * "#", v)
		local uid, mo = lpeg.match("#" * Puid_cap * "#", v)
		local fontstyle = lpeg.match("#" * Pfontstyle_cap * "#", v)
		local extra = lpeg.match("#" * lpeg.C(Pextra) * "#", v)
		if nr and ng and nb then
			tstr:add({"color", nr:parseHex(), ng:parseHex(), nb:parseHex()})
		elseif col then
			tstr:add({"color", col})
		elseif uid and mo then
			tstr:add({"uid", tonumber(uid), tonumber(mo)})
		elseif fontstyle then
			tstr:add({"font", fontstyle})
		elseif extra then
			tstr:add({"extra", extra:sub(2)})
		elseif v == "\n" then
			tstr:add(true)
		else
			tstr:add(v)
		end
	end
	tstring_cache[str] = tstr
	return tstr:clone()
end
function string:toString() return self end

--- Tablestrings degrade "peacefully" into normal formated strings
function tstring:toString()
	local ret = {}
	local v
	for i = 1, #self do
		v = self[i]
		if type(v) == "boolean" then ret[#ret+1] = "\n"
		elseif type(v) == "string" then ret[#ret+1] = v
		elseif type(v) == "table" then
			if v[1] == "color" and v[2] == "LAST" then ret[#ret+1] = "#LAST#"
			elseif v[1] == "color" and not v[3] then ret[#ret+1] = "#"..v[2].."#"
			elseif v[1] == "color" then ret[#ret+1] = ("#%02x%02x%02x#"):format(v[2], v[3], v[4]):upper()
			elseif v[1] == "font" then ret[#ret+1] = "#{"..v[2].."}#"
			elseif v[1] == "uid" then ret[#ret+1] = "#UID:"..v[2]..":0#"
			elseif v[1] == "extra" then ret[#ret+1] = "#&"..v[2].."#"
			end
		end
	end
	return table.concat(ret)
end
function tstring:toTString() return self end

--- Tablestrings can not be formated, this just returns self
function tstring:format() return self end

function tstring:splitLines(max_width, font, max_lines)
	local break_all_chars = core.display.getBreakTextAllCharacter()
	local fstyle = font:getStyle()
	local old_fstyle = fstyle
	local ret = tstring{}
	local cur_size = 0
	local max_w = 0
	local v, tv
	local mustexit = false
	for i = 1, #self do
		v = self[i]
		tv = type(v)
		if tv == "string" then
			local ls = v:split(lpeg.S"\n ", true)
			for i = 1, #ls do
				local vv = ls[i]
				if vv == "\n" then
					ret[#ret+1] = true
					max_w = math.max(max_w, cur_size)
					cur_size = 0
					if max_lines then
						max_lines = max_lines - 1
						if max_lines <= 0 then mustexit = true break end
					end
				else
					local w, h = fontcachewordsize(font, fstyle, vv)
					if cur_size + w < max_width then
						cur_size = cur_size + w
						ret[#ret+1] = vv
					else
						-- Normal whitespace breaking
						if not break_all_chars then
							ret[#ret+1] = true
							max_w = math.max(max_w, cur_size)
							if max_lines then max_lines = max_lines - 1 if max_lines <= 0 then mustexit = true break end end
							ret[#ret+1] = vv
							cur_size = w
						-- Break on any characters
						else
							local left, left_size, right, right_size
							while true do
								left, left_size, right, right_size = vv:splitAtSizeSimple(max_width - cur_size, font)

								-- Add to current line
								ret[#ret+1] = left
								cur_size = cur_size + left_size
								max_w = math.max(max_w, cur_size)

								-- If the right side can fit on a line, we're done, otherwise we split again
								if right_size <= max_width then
									break
								else
									if max_lines then max_lines = max_lines - 1 if max_lines <= 0 then mustexit = true break end end
									ret[#ret+1] = true
									cur_size = 0
									vv = right
								end
							end
							if mustexit then break end

							-- Put the rest on new line
							if max_lines then max_lines = max_lines - 1 if max_lines <= 0 then mustexit = true break end end
							ret[#ret+1] = true
							ret[#ret+1] = right
							cur_size = right_size
							max_w = math.max(max_w, cur_size)
						end
					end
				end
			end
			if mustexit then break end
		elseif tv == "table" and v[1] == "font" then
			font:setStyle(v[2])
			fstyle = v[2]
			ret[#ret+1] = v
		elseif tv == "table" and v[1] == "extra" then
			ret[#ret+1] = v
		elseif tv == "table" and v[1] == "uid" then
			local e = __uids[v[2]]
			if e and game.level then
				local surf = e:getEntityFinalSurface(game.level.map.tiles, font:lineSkip(), font:lineSkip())
				if surf then
					local w, h = surf:getSize()
					if cur_size + w < max_width then
						cur_size = cur_size + w
						ret[#ret+1] = v
					else
						ret[#ret+1] = true
						ret[#ret+1] = v
						max_w = math.max(max_w, cur_size)
						cur_size = w
					end
				end
			end
		elseif tv == "boolean" then
			max_w = math.max(max_w, cur_size)
			cur_size = 0
			ret[#ret+1] = v
			if max_lines then
				max_lines = max_lines - 1
				if max_lines <= 0 then break end
			end
		else
			ret[#ret+1] = v
		end
	end
	max_w = math.max(max_w, cur_size)
	if fstyle ~= old_fstyle then font:setStyle(old_fstyle) end
	return ret, max_w
end

function tstring:tokenize(tokens)
	if type(tokens) == "string" then tokens = lpeg.S("\n"..tokens) end
	local ret = tstring{}
	local v, tv
	for i = 1, #self do
		v = self[i]
		tv = type(v)
		if tv == "string" then
			local ls = v:split(tokens, true)
			for i = 1, #ls do
				local vv = ls[i]
				if vv == "\n" then
					ret[#ret+1] = true
				else
					ret[#ret+1] = vv
				end
			end
		else
			ret[#ret+1] = v
		end
	end
	return ret
end


function tstring:extractLines(keep_color)
	local rets = {}
	local ret = tstring{}
	local last_color = {"color", "WHITE"}
	local v
	for i = 1, #self do
		v = self[i]
		if type(v) == "table" and v[1] == "color" then
			last_color = v
		end
		if v == true then
			rets[#rets+1] = ret
			ret = tstring{}
			if keep_color and #rets > 0 then ret:add(last_color) end
		else
			ret[#ret+1] = v
		end
	end
	if keep_color and #rets > 0 then table.insert(ret, 1, last_color) end
	rets[#rets+1] = ret
	return rets
end

function tstring:isEmpty()
	return #self == 0
end

function tstring:makeLineTextures(max_width, font, no_split, r, g, b)
	local list = no_split and self or self:splitLines(max_width, font)
	local fh = font:lineSkip()
	local s = core.display.newSurface(max_width, fh)
	s:erase(0, 0, 0, 0)
	local texs = {}
	local w = 0
	local r, g, b = r or 255, g or 255, b or 255
	local oldr, oldg, oldb = r, g, b
	local v, tv
	for i = 1, #list do
		v = list[i]
		tv = type(v)
		if tv == "string" then
			s:drawStringBlended(font, v, w, 0, r, g, b, true)
			w = w + fontoldsize(font, v)
		elseif tv == "boolean" then
			w = 0
			local dat = {w=max_width, h=fh}
			dat._tex, dat._tex_w, dat._tex_h = s:glTexture()
			texs[#texs+1] = dat
			s:erase(0, 0, 0, 0)
		else
			if v[1] == "color" and v[2] == "LAST" then
				r, g, b = oldr, oldg, oldb
			elseif v[1] == "color" and not v[3] then
				oldr, oldg, oldb = r, g, b
				r, g, b = unpack(colors.simple(colors[v[2]] or {255,255,255}))
			elseif v[1] == "color" then
				oldr, oldg, oldb = r, g, b
				r, g, b = v[2], v[3], v[4]
			elseif v[1] == "font" then
				font:setStyle(v[2])
				fstyle = v[2]
			elseif v[1] == "extra" then
				--
			elseif v[1] == "uid" then
				local e = __uids[v[2]]
				if e then
					local surf = e:getEntityFinalSurface(game.level.map.tiles, font:lineSkip(), font:lineSkip())
					if surf then
						local sw = surf:getSize()
						s:merge(surf, w, 0)
						w = w + sw
					end
				end
			end
		end
	end

	-- Last line
	local dat = {w=max_width, h=fh}
	dat._tex, dat._tex_w, dat._tex_h = s:glTexture()
	texs[#texs+1] = dat

	return texs
end

function tstring:drawOnSurface(s, max_width, max_lines, font, x, y, r, g, b, no_alpha, on_word)
	local list = self:splitLines(max_width, font, max_lines)
	max_lines = util.bound(max_lines or #list, 1, #list)
	local fh = font:lineSkip()
	local fstyle = font:getStyle()
	local w, h = 0, 0
	r, g, b = r or 255, g or 255, b or 255
	local oldr, oldg, oldb = r, g, b
	local v, tv
	local on_word_w, on_word_h
	local last_line_h = 0
	local max_w = 0
	local lines_drawn = 0
	for i = 1, #list do
		v = list[i]
		tv = type(v)
		if tv == "string" then
			if on_word then on_word_w, on_word_h = on_word(v, w, h) end
			if on_word_w and on_word_h then
				w, h = on_word_w, on_word_h
			else
				local dw, dh = fontcachewordsize(font, fstyle, v)
				last_line_h = math.max(last_line_h, dh)
				s:drawStringBlended(font, v, x + w, y + h, r, g, b, not no_alpha)
				w = w + fontoldsize(font, v)
			end
		elseif tv == "boolean" then
			max_w = math.max(max_w, w)
			w = 0
			h = h + fh
			last_line_h = 0
			lines_drawn = lines_drawn + 1
			max_lines = max_lines - 1
			if max_lines <= 0 then break end
		else
			if v[1] == "color" and v[2] == "LAST" then
				r, g, b = oldr, oldg, oldb
			elseif v[1] == "color" and not v[3] then
				oldr, oldg, oldb = r, g, b
				r, g, b = unpack(colors.simple(colors[v[2]] or {255,255,255}))
			elseif v[1] == "color" then
				oldr, oldg, oldb = r, g, b
				r, g, b = v[2], v[3], v[4]
			elseif v[1] == "font" then
				font:setStyle(v[2])
			elseif v[1] == "extra" then
				--
			elseif v[1] == "uid" then
				local e = __uids[v[2]]
				if e then
					local surf = e:getEntityFinalSurface(game.level.map.tiles, font:lineSkip(), font:lineSkip())
					if surf then
						local sw = surf:getSize()
						s:merge(surf, x + w, y + h)
						w = w + sw
					end
				end
			end
		end
	end
	return r, g, b, math.max(max_w, w), fh * lines_drawn + last_line_h, x, y
end

function tstring:diffWith(str2, on_diff)
	local res = tstring{}
	local j = 1
	for i = 1, #self do
		if type(self[i]) == "string" and self[i] ~= str2[j] then
			on_diff(self[i], str2[j], res)
		else
			res:add(self[i])
		end
		j = j + 1
	end
	return res
end

function tstring:diffMulti(list, on_diff)
	local res = tstring{}
	for i = 1, #list[1] do
		local diffs = {}
		local has_diffs = false
		for j = 2, #list do
			if type(list[1][i]) == "string" and list[1][i] ~= list[j][i] then has_diffs = true break end
		end

		if not has_diffs then
			res:add(list[1][i])
		else
			for j = 1, #list do
				diffs[#diffs+1] = {id=j, str=list[j][i]}
			end
			on_diff(diffs, res)
		end
	end
	return res
end

-- Make tstring into an object
local tsmeta = {__index=tstring, __tostring = tstring.toString}
setmetatable(tstring, {
	__call = function(self, t)
		setmetatable(t, tsmeta)
		return t
	end,
})

local dir_to_angle = table.readonly{
	[1] = 225,
	[2] = 270,
	[3] = 315,
	[4] = 180,
	[5] = 0,
	[6] = 0,
	[7] = 135,
	[8] = 90,
	[9] = 45,
}

local dir_to_coord = table.readonly{
	[1] = {-1, 1},
	[2] = { 0, 1},
	[3] = { 1, 1},
	[4] = {-1, 0},
	[5] = { 0, 0},
	[6] = { 1, 0},
	[7] = {-1,-1},
	[8] = { 0,-1},
	[9] = { 1,-1},
}

local coord_to_dir = table.readonly{
	[-1] = {
		[-1] = 7,
		[ 0] = 4,
		[ 1] = 1,
	},
	[ 0] = {
		[-1] = 8,
		[ 0] = 5,
		[ 1] = 2,
	},
	[ 1] = {
		[-1] = 9,
		[ 0] = 6,
		[ 1] = 3,
	},
}

local dir_sides = table.readonly{
	[1] = {hard_left=3, left=2, right=4, hard_right=7},
	[2] = {hard_left=6, left=3, right=1, hard_right=4},
	[3] = {hard_left=9, left=6, right=2, hard_right=1},
	[4] = {hard_left=2, left=1, right=7, hard_right=8},
	[5] = {hard_left=4, left=7, right=9, hard_right=6}, -- To avoid problems
	[6] = {hard_left=8, left=9, right=3, hard_right=2},
	[7] = {hard_left=1, left=4, right=8, hard_right=9},
	[8] = {hard_left=4, left=7, right=9, hard_right=6},
	[9] = {hard_left=7, left=8, right=6, hard_right=3},
}

local opposed_dir = table.readonly{
	[1] = 9,
	[2] = 8,
	[3] = 7,
	[4] = 6,
	[5] = 5,
	[6] = 4,
	[7] = 3,
	[8] = 2,
	[9] = 1,
}

local hex_dir_to_angle = table.readonly{
	[1] = 210,
	[2] = 270,
	[3] = 330,
	[4] = 180,
	[5] = 0,
	[6] = 0,
	[7] = 150,
	[8] = 90,
	[9] = 30,
}

local hex_dir_to_coord = table.readonly{
	[0] = {
		[1] = {-1, 0},
		[2] = { 0, 1},
		[3] = { 1, 0},
		[4] = {-1, 0},
		[5] = { 0, 0},
		[6] = { 1, 0},
		[7] = {-1,-1},
		[8] = { 0,-1},
		[9] = { 1,-1},
	},
	[1] = {
		[1] = {-1, 1},
		[2] = { 0, 1},
		[3] = { 1, 1},
		[4] = {-1, 0},
		[5] = { 0, 0},
		[6] = { 1, 0},
		[7] = {-1, 0},
		[8] = { 0,-1},
		[9] = { 1, 0},
	}
}

local hex_coord_to_dir = table.readonly{
	[0] = {
		[-1] = {
			[-1] = 7,
			[ 0] = 1, -- or 4
			[ 1] = 1,
		},
		[ 0] = {
			[-1] = 8,
			[ 0] = 5,
			[ 1] = 2,
		},
		[ 1] = {
			[-1] = 9,
			[ 0] = 3, -- or 6
			[ 1] = 3,
		},
	},
	[1] = {
		[-1] = {
			[-1] = 7,
			[ 0] = 7, -- or 4
			[ 1] = 1,
		},
		[ 0] = {
			[-1] = 8,
			[ 0] = 5,
			[ 1] = 2,
		},
		[ 1] = {
			[-1] = 9,
			[ 0] = 9, -- or 6
			[ 1] = 3,
		},
	}
}

local hex_dir_sides = table.readonly{
	[0] = {
		[1] = {hard_left=3, left=2, right=7, hard_right=8},
		[2] = {hard_left=9, left=3, right=1, hard_right=7},
		[3] = {hard_left=8, left=9, right=2, hard_right=1},
		[4] = {hard_left=2, left=1, right=7, hard_right=8},
		[5] = {hard_left=1, left=7, right=9, hard_right=3}, -- To avoid problems
		[6] = {hard_left=8, left=9, right=3, hard_right=2},
		[7] = {hard_left=2, left=1, right=8, hard_right=9},
		[8] = {hard_left=1, left=7, right=9, hard_right=3},
		[9] = {hard_left=7, left=8, right=3, hard_right=2},
	},
	[1] = {
		[1] = {hard_left=3, left=2, right=7, hard_right=8},
		[2] = {hard_left=9, left=3, right=1, hard_right=7},
		[3] = {hard_left=8, left=9, right=2, hard_right=1},
		[4] = {hard_left=2, left=1, right=7, hard_right=8},
		[5] = {hard_left=1, left=7, right=9, hard_right=3}, -- To avoid problems
		[6] = {hard_left=8, left=9, right=3, hard_right=2},
		[7] = {hard_left=2, left=1, right=8, hard_right=9},
		[8] = {hard_left=1, left=7, right=9, hard_right=3},
		[9] = {hard_left=7, left=8, right=3, hard_right=2},
	}
}

local hex_next_zig_zag = table.readonly{
	[1] = "zig",
	[2] = "zig",
	[3] = "zig",
	[7] = "zag",
	[8] = "zag",
	[9] = "zag",
	zag = "zig",
	zig = "zag",
}

local hex_zig_zag = table.readonly{
	[4] = {
		zig = 7,
		zag = 1,
	},
	[6] = {
		zig = 9,
		zag = 3,
	},
}

local hex_opposed_dir = table.readonly{
	[0] = {
		[1] = 9,
		[2] = 8,
		[3] = 7,
		[4] = 3,
		[5] = 5,
		[6] = 1,
		[7] = 3,
		[8] = 2,
		[9] = 1,
	},
	[1] = {
		[1] = 9,
		[2] = 8,
		[3] = 7,
		[4] = 9,
		[5] = 5,
		[6] = 7,
		[7] = 3,
		[8] = 2,
		[9] = 1,
	},
}

util = {}

function util.clipOffset(w, h, total_w, total_h, loffset_x, loffset_y, dest_area)
	w, h = math.floor(w), math.floor(h)
	total_w, total_h, loffset_x, loffset_y = math.floor(total_w), math.floor(total_h), math.floor(loffset_x), math.floor(loffset_y)
	dest_area.w , dest_area.h = math.floor(dest_area.w), math.floor(dest_area.h)
	local clip_y_start = 0
	local clip_y_end = 0
	local clip_x_start = 0
	local clip_x_end = 0
	-- if its visible then compute how much of it needs to be clipped, take centering into account
	if total_h < loffset_y then clip_y_start = loffset_y - total_h end

	-- if it ended after visible area then compute its bottom clip
	if total_h + h > loffset_y + dest_area.h then clip_y_end = total_h + h - (loffset_y + dest_area.h) end

	-- if its visible then compute how much of it needs to be clipped, take centering into account
	if total_w < loffset_x then clip_x_start = loffset_x - total_w end

	-- if it ended after visible area then compute its bottom clip
	if total_w + w > loffset_x + dest_area.w then clip_x_end = total_w + w - (loffset_x + dest_area.w) end

	if clip_x_start > w then clip_x_start = w end
	if clip_x_end < 0 then clip_x_end = 0 end
	if clip_y_start > h then clip_y_start = h end
	if clip_y_end < 0 then clip_y_end = 0 end

	return clip_x_start, clip_x_end, clip_y_start, clip_y_end
end

function util.clipTexture(texture, x, y, w, h, total_w, total_h, loffset_x, loffset_y, dest_area, r, g, b, a)
	if not texture then return 0, 0, 0, 0 end
	x, y, w, h = math.floor(x), math.floor(y), math.floor(w), math.floor(h)
	total_w, total_h, loffset_x, loffset_y = math.floor(total_w), math.floor(total_h), math.floor(loffset_x), math.floor(loffset_y)
	dest_area.w , dest_area.h = math.floor(dest_area.w), math.floor(dest_area.h)
	local clip_y_start = 0
	local clip_y_end = 0
	local clip_x_start = 0
	local clip_x_end = 0
	-- if its visible then compute how much of it needs to be clipped, take centering into account
	if total_h < loffset_y then clip_y_start = loffset_y - total_h end

	-- if it ended after visible area then compute its bottom clip
	if total_h + h > loffset_y + dest_area.h then clip_y_end = total_h + h - (loffset_y + dest_area.h) end

	-- if its visible then compute how much of it needs to be clipped, take centering into account
	if total_w < loffset_x then clip_x_start = loffset_x - total_w end

	-- if it ended after visible area then compute its bottom clip
	if total_w + w > loffset_x + dest_area.w then clip_x_end = total_w + w - (loffset_x + dest_area.w) end

	local one_by_tex_h = 1 / texture._tex_h
	local one_by_tex_w = 1 / texture._tex_w
	--talent icon
	texture._tex:toScreenPrecise(x, y, w - (clip_x_start + clip_x_end), h - (clip_y_start + clip_y_end), clip_x_start * one_by_tex_w, (w - clip_x_end) * one_by_tex_w, clip_y_start * one_by_tex_h, (h - clip_y_end) * one_by_tex_h, r, g, b, a)

	if clip_x_start > w then clip_x_start = w end
	if clip_x_end < 0 then clip_x_end = 0 end
	if clip_y_start > h then clip_y_start = h end
	if clip_y_end < 0 then clip_y_end = 0 end

	return clip_x_start, clip_x_end, clip_y_start, clip_y_end
end

local is_hex = 0
function util.hexOffset(x)
	return 0.5 * (x % 2) * is_hex
end

function util.isHex()
	return is_hex == 1
end

function util.dirToAngle(dir)
	return is_hex == 0 and dir_to_angle[dir] or hex_dir_to_angle[dir]
end

function util.dirToCoord(dir, sx, sy)
	return unpack(is_hex == 0 and dir_to_coord[dir] or (sx and hex_dir_to_coord[sx % 2][dir]))
end

function util.coordToDir(dx, dy, sx, sy)
	return is_hex == 0 and coord_to_dir[dx][dy] or (sx and hex_coord_to_dir[sx % 2][dx][dy])
end

function util.dirSides(dir, sx, sy)
	return is_hex == 0 and dir_sides[dir] or (sx and hex_dir_sides[sx % 2][dir])
end

function util.dirZigZag(dir, sx, sy)
	if is_hex == 0 then
		return nil
	else
		return hex_zig_zag[dir]
	end
end

function util.dirNextZigZag(dir, sx, sy)
	if is_hex == 0 then
		return nil
	else
		return hex_next_zig_zag[dir]
	end
end

function util.opposedDir(dir, sx, sy)
	return is_hex == 0 and opposed_dir[dir] or (sx and hex_opposed_dir[sx % 2][dir])
end

function util.getDir(x1, y1, x2, y2)
	local xd, yd = x1 - x2, y1 - y2
	if xd ~= 0 then xd = xd / math.abs(xd) end
	if yd ~= 0 then yd = yd / math.abs(yd) end
	return util.coordToDir(xd, yd, x2, y2), xd, yd
end

function util.primaryDirs()
	return is_hex == 0 and {2, 4, 6, 8} or {1, 2, 3, 7, 8, 9}
end

function util.adjacentDirs()
	return is_hex == 0 and {1, 2, 3, 4, 6, 7, 8, 9} or {1, 2, 3, 7, 8, 9}
end

--- A list of adjacent coordinates depending on core.fov.set_algorithm.
-- @param x x-coordinate of the source tile.
-- @param y y-coordinate of the source tile.
-- @param no_diagonals Boolean that restricts diagonal motion.
-- @param no_cardinals Boolean that restricts cardinal motion.
-- @return Array of {x, y} coordinate arrays indexed by direction from source.
function util.adjacentCoords(x, y, no_diagonals, no_cardinals)
	local coords = {}

	if is_hex == 0 then
		if not no_cardinals then
			coords[6] = {x+1, y  }
			coords[4] = {x-1, y  }
			coords[2] = {x  , y+1}
			coords[8] = {x  , y-1}
		end
		if not no_diagonals then
			coords[3] = {x+1, y+1}
			coords[9] = {x+1, y-1}
			coords[1] = {x-1, y+1}
			coords[7] = {x-1, y-1}
		end
	elseif not no_cardinals then
		for _, dir in ipairs(util.primaryDirs()) do
			coords[dir] = {util.coordAddDir(x, y, dir)}
		end
	end
	return coords
end

--- Return the closest adjacent coordinate to the source coordinate from the target coordinate (use for gap closer positioning, etc)
-- @param x x-coordinate of the source tile.
-- @param y y-coordinate of the source tile.
-- @param tx x-coordinate of the target tile.
-- @param ty y-coordinate of the target tile.
-- @param check_block Boolean for whether to check for block_move
-- @param extra_check(x,y) Function to run on each grid and return true if that grid is invalid
-- @return Table containing the x,y coordinate of the closest grid.
function util.closestAdjacentCoord(x, y, tx, ty, check_block, extra_check)
	local check_block = check_block or true
	local coords = util.adjacentCoords(x, y)
	local valid = {}
	for _, coord in pairs(coords) do
		if not (check_block and game.level.map:checkEntity(coord[1], coord[2], engine.Map.TERRAIN, "block_move")) and not (extra_check and extra_check(coord[1], coord[2])) then 
			valid[#valid+1] = coord
		end
	end

	if #valid == 0 then return end
	local closest = valid[1]
	for _, coord in pairs(valid) do
		if core.fov.distance(closest[1], closest[2], tx, ty, true) > core.fov.distance(coord[1], coord[2], tx, ty, true) then
			closest = coord
		end
	end

	return closest
end
function util.coordAddDir(x, y, dir)
	local dx, dy = util.dirToCoord(dir, x, y)
	return x + dx, y + dy
end

function util.boundWrap(i, min, max)
	if i < min then i = max
	elseif i > max then i = min end
	return i
end

function util.bound(i, min, max)
	if min then i = math.max(i, min) end
	if max then i = math.min(i, max) end
	return i
end

function util.squareApply(x, y, w, h, fct)
	for i = x, x + w do for j = y, y + h do
		fct(i, j)
	end end
end

function util.minBound(i, min, max)
	return math.max(math.min(max, i), min)
end

function util.scroll(sel, scroll, max)
	if sel > scroll + max - 1 then scroll = sel - max + 1 end
	if sel < scroll then scroll = sel end
	return scroll
end

function util.getval(val, ...)
	if type(val) == "function" then return val(...)
	elseif type(val) == "table" then return val[rng.range(1, #val)]
	else return val
	end
end

function util.finalize(init, uninit, fct)
	return function(...)
		local myenv = {}
		init(myenv, ...)
		local rets = {fct(myenv, ...)}
		uninit(myenv, ...)
		return unpack(rets)
	end
end

function fs.reset()
	local list = fs.getSearchPath(true)
	for i, m in ipairs(list) do
		fs.umount(m.path)
	end
	print("After fs.reset")
	table.print(fs.getSearchPath(true))
end

function fs.mountAll(list)
	for i, m in ipairs(list) do
		fs.mount(m.path, "/" .. (m.mount or ""), true)
	end
end

function util.loadfilemods(file, env)
	-- Base loader
	local prev, err = loadfile(file)
	if err then error(err) end
	setfenv(prev, env)

	for i, addon in ipairs(fs.list("/mod/addons/")) do
		local fn = "/mod/addons/"..addon.."/superload/"..file
		if fs.exists(fn) then
			print("Loading mod", fn)
			local f, err = loadfile(fn)
			if err then error(err) end
			local base = prev
			setfenv(f, setmetatable({
				loadPrevious = function()
					local ok, err = pcall(base, bname)
					if not ok and err then error(err) end
				end
			}, {__index=env}))
			print("Loaded mod", f, fn)
			prev = f
		end
	end
	return prev
end

--- Find a reference to the given value inside a table and all it contains
function util.findAllReferences(t, what)
	local seen = {}
	local function recurs(t, data)
		if seen[t] then return end
		seen[t] = true
		for k, e in pairs(t) do
			if type(k) == "table" then
				local data = table.clone(data)
				data[#data+1] = "k:"..tostring(k)
				recurs(k, data)
			end
			if type(e) == "table" then
				local data = table.clone(data)
				data[#data+1] = "e:"..tostring(k)
				recurs(e, data)
			end
			if type(k) == "function" then
				local fenv = getfenv(k)
				local data = table.clone(data)
				data[#data+1] = "k:fenv:"..tostring(k)
				recurs(fenv, data)
			end
			if type(e) == "function" then
				local fenv = getfenv(e)
				local data = table.clone(data)
				if fenv.__ATOMIC or fenv.__CLASSNAME then
					data[#data+1] = "e:fenv["..(fenv.__CLASSNAME or true)"]:"..tostring(k)
				else
					data[#data+1] = "e:fenv[--]:"..tostring(k)
				end
				recurs(fenv, data)
			end

			if k == what then
				print("KEY", table.concat(data, ", "))
			end
			if e == what then
				print("VAL", table.concat(data, ", "))
			end
		end
	end

	local data = {}
	recurs(t, data)
end

-- if these functions are ever desired elsewhere, don't be shy to make these accessible beyond utils.lua
local function deltaCoordsToReal(dx, dy, source_x, source_y)
	if util.isHex() then
		dy = dy + (math.floor(math.abs(dx) + 0.5) % 2) * (0.5 - math.floor(source_x) % 2)
		dx = dx * math.sqrt(3) / 2
	end
	return dx, dy
end

local function deltaRealToCoords(dx, dy, source_x, source_y)
	if util.isHex() then
		dx = dx < 0 and math.ceil(dx * 2 / math.sqrt(3) - 0.5) or math.floor(dx * 2 / math.sqrt(3) + 0.5)
		dy = dy - (math.floor(math.abs(dx) + 0.5) % 2) * (0.5 - math.floor(source_x) % 2)
	end
	return source_x + dx, source_y + dy
end

function core.fov.calc_wall(x, y, w, h, halflength, halfmax_spots, source_x, source_y, delta_x, delta_y, block, apply)
	apply(_, x, y)
	delta_x, delta_y = deltaCoordsToReal(delta_x, delta_y, source_x, source_y)

	local angle = math.atan2(delta_y, delta_x) + math.pi / 2

	local dx, dy = math.cos(angle) * halflength, math.sin(angle) * halflength
	local adx, ady = math.abs(dx), math.abs(dy)

	local x1, y1 = deltaRealToCoords( dx,  dy, x, y)
	local x2, y2 = deltaRealToCoords(-dx, -dy, x, y)

	local spots = 1
	local wall_block_corner = function(_, bx, by)
		if halfmax_spots and spots > halfmax_spots or math.floor(core.fov.distance(x2, y2, bx, by, true) - 0.25) > 2*halflength then return true end
		apply(_, bx, by)
		spots = spots + 1
		return block(_, bx, by)
	end

	local l = core.fov.line(x+0.5, y+0.5, x1+0.5, y1+0.5, function(_, bx, by) return true end)
	l:set_corner_block(wall_block_corner)
	-- use the correct tangent (not approximate) and round corner tie-breakers toward the player (via wiggles!)
	if adx < ady then
		l:change_step(dx/ady, dy/ady)
		if delta_y < 0 then l:wiggle(true) else l:wiggle() end
	else
		l:change_step(dx/adx, dy/adx)
		if delta_x < 0 then l:wiggle(true) else l:wiggle() end
	end
	while true do
		local lx, ly, is_corner_blocked = l:step(true)
		if not lx or is_corner_blocked or halfmax_spots and spots > halfmax_spots or math.floor(core.fov.distance(x2, y2, lx, ly, true) + 0.25) > 2*halflength then break end
		apply(_, lx, ly)
		spots = spots + 1
		if block(_, lx, ly) then break end
	end

	spots = 1
	wall_block_corner = function(_, bx, by)
		if halfmax_spots and spots > halfmax_spots or math.floor(core.fov.distance(x1, y1, bx, by, true) - 0.25) > 2*halflength then return true end
		apply(_, bx, by)
		spots = spots + 1
		return block(_, bx, by)
	end

	local l = core.fov.line(x+0.5, y+0.5, x2+0.5, y2+0.5, function(_, bx, by) return true end)
	l:set_corner_block(wall_block_corner)
	-- use the correct tangent (not approximate) and round corner tie-breakers toward the player (via wiggles!)
	if adx < ady then
		l:change_step(-dx/ady, -dy/ady)
		if delta_y < 0 then l:wiggle(true) else l:wiggle() end
	else
		l:change_step(-dx/adx, -dy/adx)
		if delta_x < 0 then l:wiggle(true) else l:wiggle() end
	end
	while true do
		local lx, ly, is_corner_blocked = l:step(true)
		if not lx or is_corner_blocked or halfmax_spots and spots > halfmax_spots or math.floor(core.fov.distance(x1, y1, lx, ly, true) + 0.25) > 2*halflength then break end
		apply(_, lx, ly)
		spots = spots + 1
		if block(_, lx, ly) then break end
	end
end

function core.fov.wall_grids(x, y, halflength, halfmax_spots, source_x, source_y, delta_x, delta_y, block)
	if not x or not y or not game.level or not game.level.map then return {} end
	local grids = {}
	core.fov.calc_wall(x, y, game.level.map.w, game.level.map.h, halflength, halfmax_spots, source_x, source_y, delta_x, delta_y,
		function(_, lx, ly)
			if type(block) == "function" then
				return block(_, lx, ly)
			elseif block and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then return true end
		end,
		function(_, lx, ly)
			if not grids[lx] then grids[lx] = {} end
			grids[lx][ly] = true
		end,
	nil)

	-- point of origin
	if not grids[x] then grids[x] = {} end
	grids[x][y] = true

	return grids
end

function core.fov.circle_grids(x, y, radius, block)
	if not x or not y or not game.level or not game.level.map then return {} end
	if radius == 0 then return {[x]={[y]=true}} end
	local grids = {}
	core.fov.calc_circle(x, y, game.level.map.w, game.level.map.h, radius,
		function(_, lx, ly)
			if type(block) == "function" then
				return block(_, lx, ly)
			elseif block and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then return true end
		end,
		function(_, lx, ly)
			if not grids[lx] then grids[lx] = {} end
			grids[lx][ly] = true
		end,
	nil)

	-- point of origin
	if not grids[x] then grids[x] = {} end
	grids[x][y] = true

	return grids
end

function core.fov.beam_grids(x, y, radius, dir, angle, block)
	if not x or not y or not game.level or not game.level.map then return {} end
	if radius == 0 then return {[x]={[y]=true}} end
	local grids = {}
	core.fov.calc_beam(x, y, game.level.map.w, game.level.map.h, radius, dir, angle,
		function(_, lx, ly)
			if type(block) == "function" then
				return block(_, lx, ly)
			elseif block and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then return true end
		end,
		function(_, lx, ly)
			if not grids[lx] then grids[lx] = {} end
			grids[lx][ly] = true
		end,
	nil)

	-- point of origin
	if not grids[x] then grids[x] = {} end
	grids[x][y] = true

	return grids
end

function core.fov.beam_any_angle_grids(x, y, radius, angle, source_x, source_y, delta_x, delta_y, block)
	if not x or not y or not game.level or not game.level.map then return {} end
	if radius == 0 then return {[x]={[y]=true}} end
	local grids = {}
	core.fov.calc_beam_any_angle(x, y, game.level.map.w, game.level.map.h, radius, angle, source_x, source_y, delta_x, delta_y,
		function(_, lx, ly)
			if type(block) == "function" then
				return block(_, lx, ly)
			elseif block and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then return true end
		end,
		function(_, lx, ly)
			if not grids[lx] then grids[lx] = {} end
			grids[lx][ly] = true
		end,
	nil)

	-- point of origin
	if not grids[x] then grids[x] = {} end
	grids[x][y] = true

	return grids
end

local function is_point_in_triangle(P, A, B, C)
	local vector = require "vector"
	local P, A, B, C = vector.newFrom(P), vector.newFrom(A), vector.newFrom(B), vector.newFrom(C)

	if P == A or P == B or P == C then return true end

	-- Compute vectors
	local v0 = C - A
	local v1 = B - A
	local v2 = P - A

	-- Compute dot products
	local dot00 = v0:dot(v0)
	local dot01 = v0:dot(v1)
	local dot02 = v0:dot(v2)
	local dot11 = v1:dot(v1)
	local dot12 = v1:dot(v2)

	-- Compute barycentric coordinates
	local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
	local u = (dot11 * dot02 - dot01 * dot12) * invDenom
	local v = (dot00 * dot12 - dot01 * dot02) * invDenom

	-- Check if point is in triangle
	return (u >= 0) and (v >= 0) and (u + v < 1)
end

-- Very naive implementation, this will do for now
function core.fov.calc_triangle(x, y, w, h, points, mode, block, apply)
	local p1 = {x=x+points[1].x, y=y+points[1].y}
	local p2 = {x=x+points[2].x, y=y+points[2].y}
	local p3 = {x=x+points[3].x, y=y+points[3].y}

	local mx, Mx = math.min(p1.x, p2.x, p3.x), math.max(p1.x, p2.x, p3.x)
	local my, My = math.min(p1.y, p2.y, p3.y), math.max(p1.y, p2.y, p3.y)

	local checkline = function(fx, fy, i, j)
		local l = core.fov.line(fx, fy, i, j)
		while true do
			local lx, ly = l:step(true)
			if not lx then break end
			if lx == i and ly == j then return true end
			if block(_, lx, ly) then break end
		end
		return false
	end

	local check
	if mode == "corners" then
		check = function(i, j)
			return checkline(p1.x, p1.y, i, j) or checkline(p2.x, p2.y, i, j) or checkline(p3.x, p3.y, i, j)
		end
	else
		check = function(i, j)
			return checkline(x, y, i, j)
		end
	end

	for i = mx, Mx do if i >= 0 and i < w then
		for j = my, My do if j >= 0 and j < h then
			if is_point_in_triangle({x=i,y=j}, {x=p1.x, y=p1.y}, {x=p2.x, y=p2.y}, {x=p3.x, y=p3.y}) and check(i, j) then
				apply(nil, i, j)
			end
		end end
	end end
end


-- Very naive implementation, this will do for now
function core.fov.calc_wide_beam(x, y, w, h, sx, sy, radius, block, apply)
	local tgts = {}
	local dist = core.fov.distance(sx, sy, x, y)

	-- Compute the line
	local path = {}
	local l = core.fov.line(sx, sy, x, y)
	local lx, ly = l:step()
	while lx and ly do
		path[#path+1] = {x=lx, y=ly}
		lx, ly = l:step()
	end

	for _, p in ipairs(path) do
		if dist > 1 and p.x == x and p.y == y then
		else
			core.fov.calc_circle(p.x, p.y, w, h, radius, block, function(_, ppx, ppy)
				tgts[ppy*game.level.map.w+ppx] = {x=ppx, y=ppy}
			end, nil)
		end
	end

	for _, p in pairs(tgts) do
		apply(nil, p.x, p.y)
	end
end


function core.fov.set_corner_block(l, block_corner)
	block_corner = type(block_corner) == "function" and block_corner or
		block_corner == false and function(_, x, y) return end or
		type(block_corner) == "string" and function(_, x, y) return game.level.map:checkAllEntities(x, y, what) end or
		function(_, x, y) return game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") and
			not game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "pass_projectile") end
	l.block = block_corner
	return block_corner
end

function core.fov.line(sx, sy, tx, ty, block, start_at_end)
	local what = type(block) == "string" and block or "block_sight"
	block = type(block) == "function" and block or
		block == false and function(_, x, y) return end or
		function(_, x, y)
			return game.level.map:checkAllEntities(x, y, what)
		end

	local line = is_hex == 0 and core.fov.line_base(sx, sy, tx, ty, game.level.map.w, game.level.map.h, start_at_end, block) or
			core.fov.hex_line_base(sx, sy, tx, ty, game.level.map.w, game.level.map.h, start_at_end, block)
	local l = {}
	l.line = line
	l.block = block
	l.set_corner_block = core.fov.set_corner_block
	local mt = {}
	mt.__index = function(t, key, ...) if t.line[key] then return t.line[key] end end
	mt.__call = function(t, ...) return t.line:step(...) end
	setmetatable(l, mt)

	return l
end

--- Sets the permissiveness of FoV based on the shape of blocked terrain
-- @param val can be any number between 0.0 and 1.0 (least permissive to most permissive) or the name of a shape: square, diamond, octagon, firstpeek.
-- val = 0.0 is equivalent to "square", and val = 1.0 is equivalent to "diamond"
-- "firstpeek" is the least permissive setting that allows @ to see r below:
-- @##
-- ..r
-- Default is "square"
function core.fov.set_permissiveness(val)
	val = type(val) == "string" and ((string.lower(val) == "default" or string.lower(val) == "square") and 0.0 or
						string.lower(val) == "diamond" and 0.5 or
						string.lower(val) == "octagon" and 1 - math.sqrt(0.5) or   --0.29289321881345247560 or
						string.lower(val) == "firstpeek" and 0.167) or
					type(tonumber(val)) == "number" and 0.5*tonumber(val)

	if type(val) ~= "number" then return end
	val = util.bound(val, 0.0, 0.5)
	core.fov.set_permissiveness_base(val)
	return 2*val
end

--- Sets the FoV vision size of the source actor (if applicable to the chosen FoV algorithm).
-- @param val should be any number between 0.0 and 1.0 (smallest to largest).  Default is 1.
-- val = 1.0 will result in symmetric vision and targeting (i.e., I can see you if and only if you can see me)
--           for applicable fov algorithms ("large_ass").
function core.fov.set_actor_vision_size(val)
	val = util.bound(0.5*val, 0.0, 0.5)
	core.fov.set_actor_vision_size_base(val)
	return 2*val
end

--- Sets the algorithm used for FoV (and LoS).
-- @param val should be a string: "recursive_shadowcasting" (same as "default"), or "large_actor_recursive_shadowcasting" (same as "large_ass")
-- "large_ass" is symmetric if "actor_vision_size" is set to 1.
-- Note: Hexagonal vision shape currently only supports "recursive_shadowcasting", but all algorithms will eventually be supported in hex grids.
-- For backwards compatibility, if val is "hex" or "hexagon", then grid is changed to hex (one should instead call core.fov.set_vision_shape("hex"))
function core.fov.set_algorithm(val)
	if type(val) == "string" and (string.lower(val) == "hex" or string.lower(val) == "hexagon") then
		core.fov.set_vision_shape("hex")
		core.fov.set_algorithm_base(0) -- TEMPORARY: don't default to a half-implemented FoV/LoS algorithm
		is_hex = 1
		return
	end
	val = type(val) == "string" and ((string.lower(val) == "default" or string.lower(val) == "recursive_shadowcasting") and 0 or
						(string.lower(val) == "large_ass" or string.lower(val) == "large_actor_recursive_shadowcasting") and 1) or
					type(tonumber(val)) == "number" and math.floor(util.bound(tonumber(val), 0, 1))

	core.fov.set_algorithm_base(val)
	return val
end

--- Sets the vision shape or distance metric for field of vision, talent ranges, AoEs, etc.
-- @param val should be a string: circle, circle_round (same as circle), circle_floor, circle_ceil, circle_plus1, octagon, diamond, square.
-- See "src/fov/fov.h" to see how each shape calculates distance and height.
-- "circle_round" is aesthetically pleasing, "octagon" is a traditional roguelike FoV shape, and "circle_plus1" is similar to both "circle_round" and "octagon"
-- Default is "circle_round"
function core.fov.set_vision_shape(val)
	sval = type(val) == "string" and string.lower(val)
	val = sval and ((sval == "default" or sval == "circle" or sval == "circle_round") and 0 or
				sval == "circle_floor" and 1 or
				sval == "circle_ceil" and 2 or
				sval == "circle_plus1" and 3 or
				sval == "octagon" and 4 or
				sval == "diamond" and 5 or
				sval == "square" and 6 or
				(sval == "hex" or sval == "hexagon") and 7) or
			type(tonumber(val)) == "number" and tonumber(val)

	if type(val) ~= "number" then return end
	if val == 7 then  -- hex
		is_hex = 1
		core.fov.set_algorithm_base(0) -- TEMPORARY: don't default to a half-implemented FoV/LoS algorithm
	else
		is_hex = 0
	end
	core.fov.set_vision_shape_base(val)
	return val
end

function core.fov.lineIterator(sx, sy, tx, ty, what)
	what = what or "block_move"
	local l = core.fov.line(sx, sy, tx, ty, what)
	local lx, ly = l:step()
	return function()
		if not lx or not ly then return nil end
		local rx, ry = lx, ly
		lx, ly = l:step()
		return rx, ry
	end
end

--- create a basic bresenham line (or hex equivalent)
line = {}
function line.new(sx, sy, tx, ty)
	return is_hex == 0 and bresenham.new(sx, sy, tx, ty) or core.fov.line(sx, sy, tx, ty, function() end, false)
end

--- Finds free grids around coords in a radius.
-- This will return a random grid, the closest possible to the epicenter
-- @param sx the epicenter coordinates
-- @param sy the epicenter coordinates
-- @param radius the radius in which to search
-- @param block true if we only consider line of sight
-- @param what a table which can have the fields Map.ACTOR, Map.OBJECT, ..., set to true. If so it will only return grids that are free of this kind of entities.
function util.findFreeGrid(sx, sy, radius, block, what)
	if not sx or not sy then return nil, nil, {} end
	what = what or {}
	local grids = core.fov.circle_grids(sx, sy, radius, block)
	local gs = {}
	for x, yy in pairs(grids) do for y, _ in pairs(yy) do
		local ok = true
		if not game.level.map:isBound(x, y) then ok = false end
		for w, _ in pairs(what) do
--			print("findFreeGrid test", x, y, w, ":=>", game.level.map(x, y, w))
			if game.level.map(x, y, w) then ok = false end
		end
		if game.level.map:checkEntity(x, y, game.level.map.TERRAIN, "block_move") then ok = false end
--		print("findFreeGrid", x, y, "from", sx,sy,"=>", ok)
		if ok then
			gs[#gs+1] = {x, y, core.fov.distance(sx, sy, x, y), rng.range(1, 1000)}
		end
	end end

	if #gs == 0 then return nil end

	table.sort(gs, function(a, b)
		if a[3] == b[3] then
			return a[4] < b[4]
		else
			return a[3] < b[3]
		end
	end)

--	print("findFreeGrid using", gs[1][1], gs[1][2])
	return gs[1][1], gs[1][2], gs
end

function util.showMainMenu(no_reboot, reboot_engine, reboot_engine_version, reboot_module, reboot_name, reboot_new, reboot_einfo)
	-- Turn based by default
	core.game.setRealtime(0)

	-- Save any remaining files
	if savefile_pipe then savefile_pipe:forceWait() end

	if game and type(game) == "table" and game.__session_time_played_start then
		if game.onDealloc then game:onDealloc() end
		profile:saveGenericProfile("modules_played", {name=game.__mod_info.short_name, time_played={"inc", os.time() - game.__session_time_played_start}})
	end

	if no_reboot then
		local Module = require("engine.Module")
		local ms = Module:listModules(true)
		local mod = ms[__load_module]
		Module:instanciate(mod, __player_name, __player_new, true)
	else
		if core.steam then
			core.steam.cancelGrabSubscribedAddons()
			core.steam.sessionTicketCancel()
		end

		-- Tell the C engine to discard the current lua state and make a new one
		print("[MAIN] rebooting lua state: ", reboot_engine, reboot_engine_version, reboot_module, reboot_name, reboot_new)
		core.game.reboot("te4core", -1, reboot_engine or "te4", reboot_engine_version or "LATEST", reboot_module or "boot", reboot_name or "player", reboot_new, reboot_einfo or "")
	end
end

function util.lerp(a, b, x)
	return a + x * (b - a)
end

function util.factorial(n)
	local f = 1
	for i = 2, n do
		f = f * i
	end
	return f
end

function rng.poissonProcess(k, turn_scale, rate)
	return math.exp(-rate*turn_scale) * ((rate*turn_scale) ^ k)/ util.factorial(k)
end

--- Randomly select a table from a list of tables based on rarity
-- @param t <table> indexed table containing the tables to choose from
-- @param rarity_field <string, default "rarity">, field in each table containing its rarity value
--		rarity values are numbers > 0, such that higher values reduce the chance to be selected
-- @raturn the table selected, index
function rng.rarityTable(t, rarity_field)
	if #t == 0 then return end
	local rt = {}
	rarity_field = rarity_field or "rarity"
	local total, val = 0
	for i, e in ipairs(t) do
		val = e[rarity_field]; val = val and 1/val or 0
		total = total + val
		rt[i] = total
	end
	val = rng.float(0, total)
	for i, total in ipairs(rt) do
		if total >= val then
			return t[i], i
		end
	end
end

function util.has_upvalues(fct)
	local n, v = debug.getupvalue(fct, 1)
	if not n then return false end
	return true
end

function util.show_function_calls()
	debug.sethook(function(event, line)
		local t = debug.getinfo(2)
		local tp = debug.getinfo(3) or {}
		print(tostring(t.short_src) .. ":" .. tostring(t.name).."@"..tostring(t.linedefined), "<from>", tostring(tp.short_src) .. ":" .. tostring(tp.name).."@"..tostring(tp.linedefined))
	end, "c")
end

function util.show_backtrace()
	local level = 2

	print("backtrace:")
	while true do
		local stacktrace = debug.getinfo(level, "nlS")
		if stacktrace == nil then break end
		print(("    function: %s (%s) at %s:%d"):format(stacktrace.name or "???", stacktrace.what, stacktrace.source or stacktrace.short_src or "???", stacktrace.currentline))
		level = level + 1
	end
end

function util.send_error_backtrace(msg)
	local level = 2
	local errs = {}

	errs[#errs+1] = "backtrace:"
	while true do
		local stacktrace = debug.getinfo(level, "nlS")
		if stacktrace == nil then break end
		local src = stacktrace.source or stacktrace.short_src or "???"
		errs[#errs+1] = (("    function: %s (%s) at %s:%d"):format(stacktrace.name or "???", stacktrace.what, src, stacktrace.currentline))
		if src:prefix("@") then pcall(function()
			local rpath = fs.getRealPath(src:sub(2))
			local sep = fs.getPathSeparator()
			if rpath then errs[#errs+1] = (("      =from= %s"):format(rpath:gsub("^.*"..sep.."game"..sep, ""))) end
		end) end
		level = level + 1
	end

	pcall(function()
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
	end)

	profile:sendError(msg, table.concat(errs, "\n"))
end

function util.uuid()
	local x = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}
	local y = {'8', '9', 'a', 'b'}
	local tpl = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	local uuid = tpl:gsub("[xy]", function(c) if c=='y' then return rng.table(y) else return rng.table(x) end end)
	return uuid
end

function util.browserOpenUrl(url, forbid_methods)
	forbid_methods = forbid_methods or {}
	if forbid_methods.is_external and config.settings.open_links_external then
		forbid_methods.webview = true
		forbid_methods.steam = true
	end

	if core.webview and not forbid_methods.webview then local d = require("engine.ui.Dialog"):webPopup(url) if d then return "webview", d end end
	if core.steam and not forbid_methods.steam and core.steam.openOverlayUrl(url) then return "steam", true end
	
	if forbid_methods.native then return false end
	if core.game.openBrowser(url) then return "native", true end

	return false
end

--- Safeboot mode
function util.setForceSafeBoot()
	local restore = fs.getWritePath()
	fs.setWritePath(engine.homepath)
	local f = fs.open("/settings/force_safeboot.cfg", "w")
	if f then
		f:write("force_safeboot = true\n")
		f:close()
	end
	if restore then fs.setWritePath(restore) end
end
function util.removeForceSafeBoot()
	local restore = fs.getWritePath()
	fs.setWritePath(engine.homepath)
	fs.delete("/settings/force_safeboot.cfg")
	if restore then fs.setWritePath(restore) end
end

--- Alias os.exit to our own exit method for cleanliness
os.crash = os.exit
os.exit = core.game.exit_engine

--- Ultra weird, this is used by the C serialization code because I'm too dumb to make lua_dump() work on windows ...
function __dump_fct(f)
	return string.format("%q", string.dump(f))
end

--- Tries to load a lua module from a list, returns the first available
function require_first(...)
	local list = {...}
	for i = 1, #list do
		local ok, m = xpcall(function() return require(list[i]) end, function(...)
			local str = debug.traceback(...)
			if not str:find("No such file or directory") then print(str) end
		end)
		if ok then return m end
	end
	return nil
end

--- Is steamcloud available?
function util.steamCanCloud()
	if core.steam and core.steam.isCloudEnabled(true) and core.steam.isCloudEnabled(false) and not savefile_pipe.disable_cloud_saves then return true end
end
