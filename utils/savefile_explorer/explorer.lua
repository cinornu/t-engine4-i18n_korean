local lfs = require "lfs"
local files_list = {}
for file in lfs.dir(".") do
	if lfs.attributes(file, "mode") == "file" then files_list[#files_list+1] = file end
end

local args = {...}

function table.print(src, offset, line_feed)
	if not line_feed then line_feed = '\n' end
	if type(src) ~= "table" then io.write("table.print has no table:", src) io.write(line_feed) return end
	offset = offset or ""
	for k, e in pairs(src) do
		-- Deep copy subtables, but not objects!
		if type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			io.write(("%s[%s] = {"):format(offset, tostring(k))) io.write(line_feed)
			table.print(e, offset.."  ", line_feed)
			io.write(("%s}"):format(offset)) io.write(line_feed)
		else
			io.write(("%s[%s] = %s"):format(offset, tostring(k), tostring(e))) io.write(line_feed)
		end
	end
end

function loadObj(file)
	local deps = {}

	local env = {
		loadstring = function() end,
		setLoaded = function() end,
		loadObject = function(f) return {__dep_finder__=f} end,
	}
	local f, err = loadfile(file)
	if not f then error(err) end
	setfenv(f, env)
	local ok, o = pcall(f)
	if not ok then error(o) end

	local function explore(o, path)
		for k, e in pairs(o) do
			if type(k) == "table" then
				if k.__dep_finder__ then
					deps[k.__dep_finder__] = path..","..tostring(k)
				else
					explore(k, path..","..tostring(k))
				end
			end
			if type(e) == "table" then
				if e.__dep_finder__ then
					deps[e.__dep_finder__] = path..","..tostring(k)
				else
					explore(e, path..","..tostring(k))
				end
			end
		end
	end
	explore(o, "")

	return {name=file, deps=deps, parents={}}
end

local obj = {}
for i, file in ipairs(files_list) do
	local o = loadObj(file)
	obj[file] = o
end

for file, o in pairs(obj) do
	for f, _ in pairs(o.deps) do
		if not obj[f] then error("wtf") end
		obj[f].parents[file] = true
	end
end

function find_file(f)
	local seens = {}
	local toexplore = {main="main"}

	while next(toexplore) do
		local k, path = next(toexplore)
		toexplore[k] = nil
		local e = obj[k]
		seens[e.name] = true

		for sf, spath in pairs(e.deps) do
			if sf == f then
				print("found")
				print(path.."\n- "..sf.." ["..spath.."]")
				return
			else
				if not seens[sf] then toexplore[sf] = path.."\n- "..sf.." ["..spath.."]" end
			end
		end
	end
end

if args[1] then find_file(args[1]) end
-- table.print(obj)
