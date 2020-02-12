local lfs = require 'lfs'
local colors = require 'ansicolors'
local Parser = require 'luafish.parser'
local p = Parser()

function table.clone(org)
    local ts = {}
    for k, v in pairs(org) do
        ts[k] = v
    end
    return ts
end
  
function table.val_to_str ( v )
    if "string" == type( v ) then
      v = string.gsub( v, "\n", "\\n" )
      if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
        return "'" .. v .. "'"
      end
      return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
    else
      return "table" == type( v ) and table.tostring( v ) or
        tostring( v )
    end
end
  
function table.key_to_str ( k )
    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
      return k
    else
      return "[" .. table.val_to_str( k ) .. "]"
    end
end
    
function table.tostring( tbl )
    local result, done = {}, {}
    for k, v in ipairs( tbl ) do
      table.insert( result, table.val_to_str( v ) )
      done[ k ] = true
    end
    for k, v in pairs( tbl ) do
      if not done[ k ] then
        table.insert( result,
          table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
      end
    end
    return "{" .. table.concat( result, "," ) .. "}"
end
local function suitable_string(string)
    if string:find("\n") and string:sub(1, 1) ~= "\n" then
        return "[[" .. string .. "]]"
    else
        return ("%q"):format(string)
    end
end

local base_dir = "../../tome%-krtr%-v1.3.3.teaa/overload/mod/"
local sub_dir = "../../t%-engine4/game/modules/tome/"

local storage = {}
local count = {}
local state_stor = {}
local state = nil
local skip = false
local function sprint(src, dst)
    if dst == "kr_name" then
        return
    end
    if src ~= dst then
        local text = "t(" .. suitable_string(src) .. ", " .. suitable_string(dst) .. ")"
        print(text)
    end
end
local write_state = false
local function explore(file, ast, status, _flags)
    local flags = table.clone(_flags or {})
    local file = flags.file
    status.is_field = true
    if ast.tag == "String" then
        local str = ast[1]
        if state then
            -- print(table.tostring(flags))
            if flags.write then
                if write_state and state_stor[state] then 
                    sprint(state_stor[state], str)
                else
                    state_stor[state] = str
                end
            end
            state = nil
        end
        if skip then
            skip = false
        else
            local skip_now = false
            local str = ast[1]
            if flags.load then
                storage[file] = storage[file] or {}
                storage[file][#storage[file] + 1] = str
            elseif flags.write then
                if status.is_field and str == "name" then
                    state = "name"
                    write_state = false
                elseif status.is_field and str == "desc" then
                    state = "desc"
                    write_state = false
                elseif status.is_field and str == "unided_name" then
                    state = "unided_name"
                    write_state = false
                elseif status.is_field and str == "display_name" then
                    state = "display_name"
                    write_state = false
                elseif status.is_field and str == "title" then
                    state = "title"
                    write_state = false
                elseif status.is_field and str == "kr_name" then
                    skip_now = true
                    skip = true
                    state = "name"
                    write_state = true
                elseif status.is_field and str == "kr_desc" then
                    skip_now = true
                    skip = true
                    state = "desc"
                    write_state = true
                elseif status.is_field and str == "kr_unided_name" then
                    skip_now = true
                    skip = true
                    state = "unided_name"
                    write_state = true
                elseif status.is_field and str == "kr_display_name" then
                    skip_now = true
                    skip = true
                    state = "display_name"
                    write_state = true
                elseif status.is_field and str == "kr_title" then
                    skip_now = true
                    skip = true
                    state = "kr_title"
                    write_state = true
                elseif str == "addJosa" then
                    skip_now = true
                    skip = true
                elseif str == "engine.krtrUtils" then
                    skip_now = true
                end
                if not skip_now then
                    count[file] = count[file] or 0
                    count[file] = count[file] + 1
                    sprint(storage[file][count[file]], str)
                end
            end
        end
    end
    for i, e in ipairs(ast) do
        local new_flags = table.clone(flags or {})
        if type(e) == "table" then
            local status = {}
            if ast.tag == "Field" then
                status = {is_field = true}
            end
            explore(file, e, status, new_flags)
        end
    end
end
local black_list = {
    ["game/modules/tome/data/chats/alchemist-golem.lua"] = true,
    ["game/modules/tome/data/chats/escort-quest.lua"] = true,
    ["game/modules/tome/data/quests/brotherhood-of-alchemists.lua"] = true,
    ["game/modules/tome/data/talents/techniques/strength-of-the-berserker.lua"] = true,
}
local function handle_file(file, flags)
    local file2 = file:gsub(base_dir, sub_dir)
    local section = file2:gsub("%.%./%.%./t%-engine4/", "")
    if black_list[section] then 
        return
    end
    print([[section "]].. section .. [["]])
    local fl = table.clone(flags or {})
    fl.load = true
    fl.file = file:gsub(base_dir, "")
    explore(file2:gsub("%.%./", ""), p:parse{file2}, {}, fl)
    local fw = table.clone(flags or {})
    fw.write = true
    fw.file = file:gsub(base_dir, "")
    explore(file:gsub("%.%./", ""), p:parse{file}, {}, fw)
end
local function dofolder(dir)
	if lfs.attributes(dir, "mode") == "file" then
		handle_file(dir, {})
		return
	end

	for sfile in lfs.dir(dir) do
		local file = dir.."/"..sfile
		if lfs.attributes(file, "mode") == "directory" and sfile ~= ".." and sfile ~= "." then
			dofolder(file)
		elseif sfile:find("%.lua$") then
			handle_file(file, {})
		end
	end
end
-- handle_file("../../tome-krtr-v1.3.3.teaa/overload/data/achievements/arena.lua")
-- handle_file("../../tome-krtr-v1.3.3.teaa/overload/data/chats/alchemist-derth.lua")
dofolder("../../tome-krtr-v1.3.3.teaa/overload/mod/class")
-- handle_file("../../tome-krtr-v1.3.3.teaa/overload/data/ingredients.lua")
