function table.print(src, offset, ret)
	if type(src) ~= "table" then print("table.print has no table:", src) return end
	offset = offset or ""
	for k, e in pairs(src) do
		-- Deep copy subtables, but not objects!
		if type(e) == "table" and not e.__ATOMIC then
			print(("%s[%s] = {"):format(offset, tostring(k)))
			table.print(e, offset.."  ")
			print(("%s}"):format(offset))
		else
			print(("%s[%s] = %s"):format(offset, tostring(k), tostring(e)))
		end
	end
end
--- This is a really naive algorithm, it will not handle objects and such.
-- Use only for small tables
function table.serialize(src, sub, no_G)
	local str = ""
	if sub then str = "{" end
	for k, e in pairs(src) do
		local nk, ne = k, e
		local tk, te = type(k), type(e)

		if no_G then
			if tk == "table" then nk = "["..table.serialize(nk, true).."]"
			elseif tk == "string" then -- nothing
			else nk = "["..nk.."]"
			end
		else
			if tk == "table" then nk = "["..table.serialize(nk, true).."]"
			elseif tk == "string" then nk = string.format("[%q]", nk)
			else nk = "["..nk.."]"
			end
			if not sub then nk = "_G"..nk end
		end

		if te == "table" then
			str = str..string.format("%s=%s ", nk, table.serialize(ne, true))
		elseif te == "number" then
			str = str..string.format("%s=%f ", nk, ne)
		elseif te == "string" then
			str = str..string.format("%s=%q ", nk, ne)
		elseif te == "boolean" then
			str = str..string.format("%s=%s ", nk, tostring(ne))
		end
		if sub then str = str..", " end
	end
	if sub then str = str.."}" end
	return str
end


local gd = require "gd"

local ts_size = 1024

function makeSet(w, h)
	local used = {}
	local im = gd.createTrueColor(w, h)
	im:alphaBlending(false)
	im:saveAlpha(true)
	im:filledRectangle(0, 0, w, h, im:colorAllocateAlpha(0, 0, 0, 127))

	for i = 0, ts_size-1, 1 do
		used[i] = {}
		for j = 0, ts_size-1, 1 do
			used[i][j] = false
		end
	end

	return im, used
end

local w, h = ts_size, ts_size
local id = 1

local pos = {}

local list = {...}
local basename = table.remove(list, 1)
local prefix = table.remove(list, 1)

function findPlace(used, d)
	for i = 0, #used do
		for j = 0, #used[i] do if not used[i][j] then
			-- print("Spot", i, j)
			local ok = true
			for a = i, i + d.sw - 1 do for b = j, j + d.sh - 1 do
				-- print("SubSpot", a, b)
				if not used[a] or used[a][b] == true or used[a][b] == nil then ok = false end
			end end
			if ok then return i, j end
		end end
	end
end

function fillSet(rlist)
	local im, used = makeSet(w, h)
	local i, j = 0, 0
	while #rlist > 0 do
		local d = table.remove(rlist)
		print("SRC", d.file, d.mw, d.mh, d.sw, d.sh)

		local i, j = findPlace(used, d)
		if not i then
			im:png(basename..id..".png")
			im, used = makeSet(w, h)
			i, j = findPlace(used, d)
			id = id + 1
		end

		local ri, rj = i, j
		im:copyResampled(d.src, ri, rj, 0, 0, d.mw, d.mh, d.mw, d.mh)
		pos[prefix..d.file] = {x=ri/w, y=rj/h, factorx=d.mw/w, factory=d.mh/h, w=d.mw, h=d.mh, set=prefix..basename..id..".png"}

		for x = i, i - 1 + d.sw do for y = j, j - 1 + d.sh do 
			used[x][y] = true
		end end

		i = i + d.mw
	end
	-- table.print(used)
	im:png(basename..id..".png")
end

local total = 0

local rlist = {}
for i = #list, 1, -1 do
	local file = list[i]
	if file:sub(1, 2) == "./" then file = file:sub(3) end

	local src = gd.createFromPng(file)
	local mw, mh = src:sizeXY()
	rlist[#rlist+1] = {file=file, src=src, mw=mw, mh=mh, sw=mw+4, sh=mh+4}
	table.remove(list, i)
end
table.sort(rlist, function(a,b)
	return a.file < b.file
	-- local ai, bi = a.mw + a.mh, b.mw + b.mh
	-- if ai == bi then return a.file < b.file end
	-- return ai < bi
end)

total = total + #rlist
fillSet(rlist)

-- Missing ones ?
for i = #list, 1, -1 do
	local file = list[i]
	if file:sub(1, 2) == "./" then file = file:sub(3) end

	local src = gd.createFromPng(file)
	local mw, mh = src:sizeXY()
	print("Missed: ", mw, mh, file)
end

local f = io.open(basename..".lua", "w")
f:write(table.serialize(pos))
f:close()

print("Total for", basename, " contains ", total, "images")
