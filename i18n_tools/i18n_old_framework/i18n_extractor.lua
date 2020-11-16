local lfs = require 'lfs'
local colors = require 'ansicolors'
local Parser = require 'luafish.parser'
local p = Parser()

local locales = {}
function string.capitalize(str)
	if #str > 1 then
		return string.upper(str:sub(1, 1))..str:sub(2)
	elseif #str == 1 then
		return str:upper()
	else
		return str
	end
end

function table.keys(t)
	local tt = {}
	for k, e in pairs(t) do tt[#tt+1] = k end
	return tt
end

function table.print(src, offset, ret)
	if type(src) ~= "table" then print("table.print has no table:", src) return end
	offset = offset or ""
	for k, e in pairs(src) do
		-- Deep copy subtables, but not objects!
		if type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
			print(("%s[%s] = {"):format(offset, tostring(k)))
			table.print(e, offset.."\t")
			print(("%s}"):format(offset))
		else
			print(("%s[%s] = %s"):format(offset, tostring(k), tostring(e)))
		end
	end
end

local log_alias = {
	log = {1},
	logSeen = {2, 3},
	logCombat = {2, 3},
	logPlayer = {2},
	logMessage = {5},
	delayedLogMessage = {4},
	say = {2},
	saySimple = {2},
	easing = {3},
	easingSimple = {3},
}
local newTalent_alias = {
	newTalent = true,
	newInscription = true,
	uberTalent = true,
}
local function explore(file, ast)
	--table.print(ast)
	for i, e in ipairs(ast) do
		if type(e) == "table" then
			if e.tag == "Id" and e[1] == "_t" then
				local en = ast[i+1]
				if en and type(en) == "table" and en.tag == "ExpList" and type(en[1]) == "table" and en[1].tag == "String" then
					local tag = "_t"
					if en[2] and type(en[2]) == "table" and en[2].tag == "String" then
						tag = en[2][1]
					end
					print(colors("%{bright cyan}_t"), en[1][1])
					locales[file] = locales[file] or {}
					locales[file][en[1][1]] = {line=en[1].nline, type=tag}
				end
			elseif e.tag == "String" and e[1] == "tformat" and i == 2 then
				local en = ast[i-1]
				if en and type(en) == "table" and en.tag == "Paren" and type(en[1]) == "table" then
					local sn = en[1]
					if sn.tag == "String" and sn[1] then
						print(colors("%{bright yellow}tformat"), sn[1])
						locales[file] = locales[file] or {}
						locales[file][sn[1]] = {line=sn.nline, type="tformat"}
					end
				end
			elseif e.tag == "Id" and newTalent_alias[e[1]] then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						print(colors("%{bright green}".. e[1]), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="talent name"}
					end
				end end
			elseif e.tag == "Id" and e[1] == "newTalentType" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "type" then
						local cat = p[2][1]:gsub("/.*", "")
						print(colors("%{bright green}newTalentType"), cat)
						locales[file] = locales[file] or {}
						locales[file][cat] = {line=p[2].nline, type="talent category"}
					end
				end end
			elseif e.tag == "Id" and e[1] == "newEntity" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						print(colors("%{green}newEntity"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="entity name"}
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "short_name" then
						print(colors("%{green}newEntity"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="entity short_name"}
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "type" then
						print(colors("%{green}newEntity"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="entity type"}
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "subtype" then
						print(colors("%{green}newEntity"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="entity subtype"}
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "keywords" then
						for _, q in ipairs(p[2]) do
							if q[1].tag == "String" then
								print(colors("%{green}newEntity"), q[1][1])
								locales[file] = locales[file] or {}
								locales[file][q[1][1]] = {line=p[2].nline, type="entity keyword"}
							end
						end
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "combat" then
						for _, q in ipairs(p[2]) do
							if q.tag == "Field" and q[1].tag == "String" and q[1][1] == "talented" then
								print(colors("%{green}newEntity"), q[2][1])
								locales[file] = locales[file] or {}
								locales[file][q[2][1]] = {line=p[2].nline, type="entity combat talented"}
							end
						end
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "on_slot" then
						if(p[2].tag == "String") then
							print(colors("%{green}newEntity"), p[2][1])
							locales[file] = locales[file] or {}
							locales[file][p[2][1]] = {line=p[2].nline, type="entity on slot"}
						end
					end
				end end
			elseif e.tag == "Id" and e[1] == "newIngredient" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						print(colors("%{green}newIngredient"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="ingredient name"}
					elseif p[1] and p[2] and p.tag == "Field" and p[1][1] == "type" then
						print(colors("%{green}newIngredient"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="ingredient type"}
					end
				end end
			elseif e.tag == "Id" and e[1] == "newAchievement" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						print(colors("%{bright red}newAchievement"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="achievement name"}
					end
				end end
			elseif e.tag == "Id" and e[1] == "newBirthDescriptor" then
				local en = ast[i+1]
				local dname, name = nil, nil
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						name = p[2]
					end
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "display_name" then
						dname = p[2]
					end
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "cosmetic_options" then
						for _, q in ipairs(p[2]) do
							if q[1].tag == "String" then
								local name = q[1][1]:gsub("_", " "):capitalize()
								print(colors("%{bright cyan}newBirthDescriptor"), name)
								locales[file] = locales[file] or {}
								locales[file][name] = {line=p[2].nline, type="birth facial category"}
							end
						end
					end
				end end
				if dname then
					print(colors("%{bright cyan}newBirthDescriptor"), dname[1])
					locales[file] = locales[file] or {}
					locales[file][dname[1]] = {line=dname.nline, type="birth descriptor name"}
				elseif name then
					print(colors("%{bright cyan}newBirthDescriptor"), name[1])
					locales[file] = locales[file] or {}
					locales[file][name[1]] = {line=name.nline, type="birth descriptor name"}
				end
			elseif e.tag == "Id" and e[1] == "newGem" then
				local en = ast[i+1]
				if en[1].tag == "String" then
					local name = en[1][1]:lower()
					local a_name = "alchemist "..en[1][1]:lower()
					local subtype = en[5][1]
					locales[file] = locales[file] or {}
					print(colors("%{cyan}newGem"), name)
					locales[file][name] = {line=en.nline, type="gem name"}
					print(colors("%{cyan}newGem"), a_name)
					locales[file][a_name] = {line=en.nline, type="alchemist gem"}
					print(colors("%{cyan}newGem"), subtype)
					locales[file][subtype] = {line=en.nline, type="gem subtype"}
				end
			elseif e.tag == "Id" and e[1] == "newEffect" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "subtype" then
						for _, q in ipairs(p[2]) do
							if q[1].tag == "String" then
								print(colors("%{yellow}newEffect"), q[1][1])
								locales[file] = locales[file] or {}
								locales[file][q[1][1]] = {line=p[2].nline, type="effect subtype"}
							end
						end
					end
				end end
			elseif e.tag == "Id" and e[1] == "floorEffect" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "desc" then
						print(colors("%{yellow}floorEffect"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="floorEffect desc"}
					end
				end end
			elseif e.tag == "Id" and e[1] == "newLore" then
				local en = ast[i+1]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "category" then
						print(colors("%{red}newLore"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="newLore category"}
					end
				end end
			elseif e.tag == "VarList" and e[1].tag == "Id" and e[1][1] == "load_tips" then
				if file:find("init.lua$") then 
					local en = ast[i+1][1]
					if en then for _, v in ipairs(en) do 
						for _, p in ipairs(v[2]) do if p.tag == "Field" and p[1][1]=="text" then
							local text = p[2][1]
							print(colors("%{bright red}load_tips"), text)
							locales[file] = locales[file] or {}
							locales[file][text] = {line=p[2].nline, type="init.lua load_tips"}
						end end
					end end
				end
			elseif e.tag == "VarList" and e[1].tag == "Id" and e[1][1] == "description" then
				if file:find("init.lua$") then 
					local en = ast[i+1][1]
					local text = en[1]
					print(colors("%{bright red}init.lua description"), text)
					locales[file] = locales[file] or {}
					locales[file][text] = {line=en.nline, type="init.lua description"}
				end
			elseif e.tag == "VarList" and e[1].tag == "Id" and e[1][1] == "long_name" then
				if file:find("init.lua$") then 
					local en = ast[i+1][1]
					local text = en[1]
					print(colors("%{bright red}init.lua long_name"), text)
					locales[file] = locales[file] or {}
					locales[file][text] = {line=en.nline, type="init.lua long_name"}
				end
			elseif e.tag == "Invoke" and e[1].tag == "Id" and e[1][1] == "ActorStats" and e[2].tag == "String" and e[2][1] == "defineStat" then
				local en = e[3]
				if en and type(en) == "table" and en.tag == "ExpList" and en[1].tag == "String" and en[2].tag == "String" then
					print(colors("%{blue}defineStat"), en[1][1])
					locales[file] = locales[file] or {}
					locales[file][en[1][1]] = {line=e.nline, type="stat name"}
					print(colors("%{blue}defineStat"), en[2][1])
					locales[file] = locales[file] or {}
					locales[file][en[2][1]] = {line=e.nline, type="stat short_name"}
				end
			elseif e.tag == "Invoke" and log_alias[e[2][1] ] then
				local en = e[3]
				local log_type = e[2][1]
				local orders = log_alias[log_type]
				for _, order in ipairs(orders) do
					if en and type(en) == "table" and en.tag == "ExpList" and type(en[order]) == "table" and en[order].tag == "String" then
						print(colors("%{bright blue}"..log_type), en[order][1])
						locales[file] = locales[file] or {}
						locales[file][en[order][1]] = {line=en[order].nline, type=log_type}
					end
				end
			elseif e.tag == "Call" and e[1][2] and log_alias[e[1][2][1] ] then
				local en = e[2]
				local log_type = e[1][2][1]
				local orders = log_alias[log_type]
				for _, order in ipairs(orders) do
					if en and type(en) == "table" and en.tag == "ExpList" and type(en[order]) == "table" and en[order].tag == "String" then
						print(colors("%{bright blue}"..log_type), en[order][1])
						locales[file] = locales[file] or {}
						locales[file][en[order][1]] = {line=en[order].nline, type=log_type}
					end
				end
			elseif e.tag == "Invoke" and
			    e[1] and e[1].tag == "Index" and e[1][1] and e[1][1][1] == "engine" and e[1][1].tag == "Id" and e[1][2][1] == "Faction" and e[1][2].tag == "String" and
			    e[2] and e[2].tag == "String" and e[2][1] == "add" then
				local en = e[3]
				if en then for j, p in ipairs(en[1]) do
					if p[1] and p[2] and p.tag == "Field" and p[1][1] == "name" then
						print(colors("%{blue}newFaction"), p[2][1])
						locales[file] = locales[file] or {}
						locales[file][p[2][1]] = {line=p[2].nline, type="faction name"}
					end
				end end
			end
			explore(file, e)
		end
	end
end

local function dofolder(dir)
	local function handle_file(file)
		if file:find("/locales/") then 
			return
		end
		print(colors("%{bright}-------------------------------------"))
		print(colors("%{bright}-- "..file))
		print(colors("%{bright}-------------------------------------"))
		local function err(x)
			io.stderr:write("In file ".. file .. ":\n")
			io.stderr:write(x .. "\n")
		end
		local function parsefunc()
			return p:parse{file}
		end
		local ok, parsed = xpcall(parsefunc, err)
		if ok then
			explore(file:gsub("%.%./", ""), parsed)
		else
			print()
		end
	end

	if lfs.attributes(dir, "mode") == "file" then
		handle_file(dir)
		return
	end

	for sfile in lfs.dir(dir) do
		local file = dir.."/"..sfile
		if lfs.attributes(file, "mode") == "directory" and sfile ~= ".." and sfile ~= "." then
			dofolder(file)
		elseif sfile:find("%.lua$") then
			handle_file(file)
		end
	end
end

for _, dir in ipairs{...} do
	dofolder(dir)
end

local f = io.open("i18n_list.lua", "w")
local slist = table.keys(locales)
table.sort(slist)
for _, section in ipairs(slist) do
	f:write('------------------------------------------------\n')
	f:write(('section %q\n\n'):format(section))
	
	local list = {}
	for k, v in pairs(locales[section]) do
		if type(k) == "string" then
			list[#list+1] = {text=k, line=v.line, type=v.type}
		end
	end
	table.sort(list, function(a,b) 
		if a.line ~= b.line then
			return a.line < b.line 
		else
			return a.text < b.text
		end
	end)

	-- local list = table.keys(locales[section])
	-- table.sort(list)

	for _, s in ipairs(list) do
		f:write(('tDef(%s, %q, %q) -- \n'):format(s.line, s.text, s.type))
	end
	f:write('\n\n')
end
f:close()
