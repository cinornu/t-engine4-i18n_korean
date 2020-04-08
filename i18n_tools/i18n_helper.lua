local lfs = require 'lfs'
local locales_trans = {}
local locales_args = {}
local locales_special = {}
local locales_sections ={}
local sections = {}
local current_section = ""
local tcs = {}
local locale = "zh_hans"
local function runfile(file, env)
	-- Base loader
	local prev, err = loadfile(file)
	if err then error(err) end
    setfenv(prev, env)
    print("running "..file)
    prev()
    return
end
local function count_string(str, pattern)
    count = 0
    for i in string.gfind(str, pattern) do
        count = count + 1
    end
    return count
end

local function suitable_string(string)
    if string == nil or string == "nil" then
        return "nil"
    end
    if string:find("\n") and string:sub(1, 1) ~= "\n" then
        return "[[" .. string .. "]]"
    else
        return ("%q"):format(string)
    end
end

local function rev_kv(a)
    local aa = {}
    for k, v in pairs(a) do
        if v ~= nil then
            aa[v] = k
        end
    end
    return aa
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

local function get(table, key, tag, value)
    tag = tag or "nil"
    table["nil"] = table["nil"] or {}
    table[tag] = table[tag] or {}
    if value == nil then
        if table[tag][key] then
            return table[tag][key]
        else
            return table["nil"][key]
        end
    else
        table[tag][key] = value
        table["nil"][key] = value
    end
end

local function introduce_file(file_in)
    local env = setmetatable({
		locale = function(s) end,
        section = function(s)
            current_section = s
            sections[#sections+1] = current_section
            locales_sections[current_section] = locales_sections[current_section] or {}
        end,
        tDef = function(line, src, tag) 
            locales_sections[current_section][src] = {
                line = line,
                src = src,
                tag = tag,
            }
        end,
    }, {__index=getfenv(2)})
    runfile(file_in, env)
end

local function check_src_dst(src, dst, args_order)
    local rex = require 'rex_pcre'
    local pattern = [[(%[+-]?\d*(\.\d*)?[dsfi])]]
    local src_s = {}
    local dst_s = {}
    for k in (rex.gmatch(src, pattern)) do
        src_s[#src_s+1] = k
    end
    for k in (rex.gmatch(dst, pattern)) do
        dst_s[#dst_s+1] = k
    end
    local checked = true
    if args_order then
        for k, v in ipairs(dst_s) do
            if src_s[args_order[k]] ~= v then
                checked = false
            end
        end
    else
        for k, v in ipairs(dst_s) do
            if src_s[k] ~= v then
                checked = false
            end
        end
    end
    if #src_s ~= #dst_s then
        checked = false
    end
    if not checked then
        print("% MISMATCH:")
        print(src)
        print(table.tostring(src_s))
        print(dst)
        print(table.tostring(dst_s))
    end
end
local function merge_file_t(src, dst, tag, args_order, special) 
    if not dst or dst == "" then 
        return
    end
    if tcs[src:lower()] then
        dst = tcs[src:lower()]
    end
    if src == dst and current_section ~= "always_merge" then
        return
    end
    -- check_src_dst(src, dst, args_order)
    if false and count_string(src, "#") ~= count_string(dst, "#") then
        print("# MISMATCH:")
        print(src)
        print(dst)
    end
    if not locales_sections[current_section][src] then
        locales_sections[current_section][src] = {
            line = 999,
            src = src,
            bogus = true,
            tag = tag,
        }
    end
    get(locales_trans, src, tag, dst)
    get(locales_args, src, tag, args_order)
    get(locales_special, src, tag, special)
end
local function merge_file_tt(src, dst, args_order, special)
    return merge_file_t(src, dst, nil, args_order, special)
end
local function merge_file(file_merge)
    local env = setmetatable({
		locale = function(s) end,
        section = function(s)
            current_section = s
            if not locales_sections[current_section] then
                sections[#sections+1] = current_section
                locales_sections[current_section] = locales_sections[current_section] or {} 
            end
        end,
        t = merge_file_t,
        t_old = merge_file_t,
        tc = function(src, dst)
            tcs[src] = dst
        end,
    }, {__index=getfenv(2)})
    runfile(file_merge, env)
end
local merged_src = {}
local translated = 0
local all_entry = 0
local not_merged = 0
local function write_section(f, f2, section)
    local result = ""
    local f2_count = 0
    t = locales_sections[section]
    f:write("------------------------------------------------\n")
    f:write(('section "%s"\n\n'):format(section))
    result = result .. "------------------------------------------------\n"
    result = result .. ('section "%s"\n\n'):format(section)
    local f2_text = ""
    local list = {}
    for _, e in pairs(t) do
        list[#list+1] = e
    end
    if section ~= "not_merged" then
        table.sort(list, function(a, b) 
            if a.line ~= b.line then
                return a.line < b.line
            else
                return a.src < b.src
            end
        end)
    else
        table.sort(list, function(a, b) return a.src < b.src end)
    end
    for _, e in ipairs(list) do
        local src = e.src
        local tag = e.tag or nil

        if section ~= "not_merged" then
            merged_src[src] = true
        end

        local print_str = ""
        local locale_tran = get(locales_trans, src, tag)
        if locale_tran then
            if section ~= "always_merge" and e.bogus then
                print_str = "t_old"
            else
                print_str = "t"
            end
            print_str = print_str .. "(" .. suitable_string(src) .. ", " .. suitable_string(locale_tran) .. ", " .. suitable_string(tag)
            local locale_special = get(locales_special, src, tag)
            local locale_arg = get(locales_args, src, tag)
            if locale_special then
                if locale_arg then
                    print_str = print_str .. ", " .. table.tostring(locale_arg)
                else
                    print_str = print_str .. ", nil"
                end
                print_str = print_str .. ", " .. table.tostring(locale_special) .. ")"
            elseif locale_arg then
                print_str = print_str .. ", " .. table.tostring(locale_arg) .. ")"
            else
                print_str = print_str .. ")"
            end
            if not (section ~= "always_merge" and e.bogus) then
                result = result .. print_str .. "\n"
            end
        else
            print_str = "t(" .. suitable_string(src) .. ", " .. suitable_string(src) .. ", " .. suitable_string(tag) .. ")"
            -- f2:write(print_str .. "\n")
            f2_text = f2_text .. print_str .. "\n"
            f2_count = f2_count + 1
        end
        if section ~= "not_merged" or not merged_src[src] then
            f:write(print_str .. '\n')
        end
        if section ~= "not_merged" then
            all_entry = all_entry + 1
            if locale_tran then
                translated = translated + 1
            end
        end
    end
    f:write("\n\n")
    result = result .. "\n\n"
    if f2_text ~= "" then
        f2:write("------------------------------------------------\n")
        f2:write(('section "%s"\n'):format(section))
        f2:write(("-- %d entries\n"):format(f2_count))
        f2:write(f2_text)
        f2:write("\n\n")
    end
    return result
end
local output_filename ={}
local output_content = {}
local function copy_file(filename)
    local fc = io.open(filename, "r")
    local result = 'locale "' .. locale .. '"\n'
    if fc then
        while true do
            local l = fc:read()
            if not l then break end
            result = result .. l .. "\n"
        end
    end
    return result .. "\n"
end
local function get_section_shortname(section)
    if section == "always_merge" then
        return "engine"
    elseif section:find("game/engines/default/") then
        return "engine"
    elseif section:find("game/modules/tome/") then
        return "tome"
    elseif section:find("game/addons/") then
        return "addon-" .. section:gsub("game/addons/tome%-([^/]+).+", "%1")
    elseif section:find("game/dlcs/") then
        return "dlc-" .. section:gsub("game/dlcs/tome%-([^/]+).+", "%1")
    else
        return nil
    end
end
local function setup_section(shortname)
    local file_name = ""
    if shortname == "tome" then
        lfs.mkdir("../game/modules/tome/data/locales")
        file_name = "../game/modules/tome/data/locales/" .. locale .. ".lua"
    elseif shortname == "engine" then
        lfs.mkdir("../game/engines/default/data/locales")
        lfs.mkdir("../game/engines/default/data/locales/engine")
        file_name = "../game/engines/default/data/locales/engine/" .. locale .. ".lua"
    elseif shortname:find("addon-") then
        local name = shortname:gsub("^addon%-", "")
        lfs.mkdir("../game/addons/tome-" .. name .. "/data/locales")
        file_name = "../game/addons/tome-" .. name .. "/data/locales/" .. locale .. ".lua"
    elseif shortname:find("dlc-") then
        local name = shortname:gsub("^dlc%-", "")
        lfs.mkdir("../game/dlcs/tome-" .. name .. "/data/locales")
        file_name = "../game/dlcs/tome-" .. name .. "/data/locales/" .. locale .. ".lua"
    end
    output_filename[shortname] = file_name
    output_content[shortname] = copy_file(shortname .. "." .. locale .. ".copy.lua")
end
local function check_section(section, result)
    local shortname = get_section_shortname(section)
    if shortname then
        if not output_filename[shortname] then
            setup_section(shortname)
        end
        output_content[shortname] = output_content[shortname] .. result
    end
end
local function print_file(file_out, file_out_2)
    local f = io.open(file_out, "w")
    local f2 = io.open(file_out_2, "w")
    table.sort(sections)
    for _, section in ipairs(sections) do
        local result = write_section(f, f2, section)
        check_section(section, result)
    end
    for shortname, content in pairs(output_content) do
        print(shortname)
        lfs.mkdir("outputs")
        local fn = "outputs/" .. shortname .. "." .. locale .. ".lua"
        local ff = io.open(fn, "w")
        if ff then 
            ff:write(content)
            ff:close()
        end
        fn = output_filename[shortname]
        print(fn)
        ff = io.open(fn, "w")
        if ff then 
            ff:write(content)
            ff:close()
        end
    end
    print(("%d / %d entries translated"):format(translated, all_entry))
end
local function extract(set_locale)
    local file_in = "i18n_list.lua"
    locale = set_locale or locale
    local file_merge = "merge_translation." .. locale .. ".lua"
    local file_out = "output_translation." .. locale .. ".lua"
    local file_out_2 = "untranslated." .. locale .. ".lua"
    introduce_file(file_in)
    merge_file(file_merge)
    print_file(file_out, file_out_2)
end
extract(...)