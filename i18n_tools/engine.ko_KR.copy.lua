-- COPY
forceFontPackage("chinese")
local function findJosaType(str)
	local length = str:len()
	
	local c1, c2
	local c3 = str:lower():byte(length)
	
	local last = 0
	if ( length < 3 ) or ( c3 < 128 ) then
		--@ 여기오면 일단 한글은 아님

		--@ 여기에 숫자나 알파벳인지 검사해서 아니면 마지막 글자 빼고 재귀호출하는 코드 삽입 필요
		
		if ( c3 == '1' or c3 == '7' or c3 == '8' or c3 == 'l' or c3 == 'r' ) then
			last = 8 --@ 한글이 아니고, josa2를 사용하지만 '로'가 맞는 경우
		elseif ( c3 == '3' or c3 == '6' or c3 == '0' or c3 == 'm' or c3 == 'n' ) then
			last = 100 --@ 한글이 아니고, josa2를 사용하는 경우
		end  
	else --@ 한글로 추정 (정확히는 더 검사가 필요하지만..)
		c1 = str:byte(length-2)
		c2 = str:byte(length-1)
		
		last = ( (c1-234)*4096 + (c2-128)*64 + (c3-128) - 3072 )%28
	end
	
	return last
end

local function addJosa(str, temp)
	local josa1, josa2, index

	if temp == 1 or temp == "가" or temp == "이" then
		josa1 = "가"
		josa2 = "이"
		index = 1
	elseif temp == 2 or temp == "는" or temp == "은" then
		josa1 = "는"
		josa2 = "은"
		index = 2
	elseif temp == 3 or temp == "를" or temp == "을" then
		josa1 = "를"
		josa2 = "을"
		index = 3
	elseif temp == 4 or temp == "로" or temp == "으로" then
		josa1 = "로"
		josa2 = "으로"
		index = 4
	elseif temp == 5 or temp == "다" or temp == "이다" then
		josa1 = "다"
		josa2 = "이다"
		index = 5
	elseif temp == 6 or temp == "와" or temp == "과" then
		josa1 = "와"
		josa2 = "과"
		index = 6
	elseif temp == 7 then
		josa1 = ""
		josa2 = "이"
		index = 7
	else
		if type(temp) == string then return str .. temp
		else return str end 
	end
	
	local type = findJosaType(str)
	
	if type == 0 or ( index == 4 and type == 8 ) then
		return str .. josa1
	else
		return str .. josa2
	end
end

setFlag("noun_target_sub", function(str, type, noun)
	if type == "#Source#" then
		return str:gsub("#Source#", noun):gsub("#Source1#", addJosa(noun, "가")):gsub("#Source2#", addJosa(noun, "는")):gsub("#Source3#", addJosa(noun, "를")):gsub("#Source4#", addJosa(noun, "로")):gsub("#Source5#", addJosa(noun, "다")):gsub("#Source6#", addJosa(noun, "과")):gsub("#Source7#", addJosa(noun, 7))
	elseif type == "#source#" then
		return str:gsub("#source#", noun):gsub("#source#", addJosa(noun, "가")):gsub("#source2#", addJosa(noun, "는")):gsub("#source3#", addJosa(noun, "를")):gsub("#source4#", addJosa(noun, "로")):gsub("#source5#", addJosa(noun, "다")):gsub("#source6#", addJosa(noun, "과")):gsub("#source7#", addJosa(noun, 7))
	elseif type == "#Target#" then
		return str:gsub("#Target#", noun):gsub("#Target1#", addJosa(noun, "가")):gsub("#Target2#", addJosa(noun, "는")):gsub("#Target3#", addJosa(noun, "를")):gsub("#Target4#", addJosa(noun, "로")):gsub("#Target5#", addJosa(noun, "다")):gsub("#Target6#", addJosa(noun, "과")):gsub("#Target7#", addJosa(noun, 7))
	elseif type == "#target#" then
		return str:gsub("#target#", noun):gsub("#target#", addJosa(noun, "가")):gsub("#target2#", addJosa(noun, "는")):gsub("#target3#", addJosa(noun, "를")):gsub("#target4#", addJosa(noun, "로")):gsub("#target5#", addJosa(noun, "다")):gsub("#target6#", addJosa(noun, "과")):gsub("#target7#", addJosa(noun, 7))
	elseif type == "@Target@" then
		return str:gsub("@Target@", noun):gsub("@Target@", addJosa(noun, "가")):gsub("@Target2@", addJosa(noun, "는")):gsub("@Target3@", addJosa(noun, "를")):gsub("@Target4@", addJosa(noun, "로")):gsub("@Target5@", addJosa(noun, "다")):gsub("@Target6@", addJosa(noun, "과")):gsub("@Target7@", addJosa(noun, 7))
	elseif type == "@target@" then
		return str:gsub("@target@", noun):gsub("@target@", addJosa(noun, "가")):gsub("@target2@", addJosa(noun, "는")):gsub("@target3@", addJosa(noun, "를")):gsub("@target4@", addJosa(noun, "로")):gsub("@target5@", addJosa(noun, "다")):gsub("@target6@", addJosa(noun, "과")):gsub("@target7@", addJosa(noun, 7))
	elseif str == "@playername@" then
		return str:gsub("@playername@", noun):gsub("@playername@", addJosa(noun, "가")):gsub("@playername2@", addJosa(noun, "는")):gsub("@playername3@", addJosa(noun, "를")):gsub("@playername4@", addJosa(noun, "로")):gsub("@playername5@", addJosa(noun, "다")):gsub("@playername6@", addJosa(noun, "과")):gsub("@playername7@", addJosa(noun, 7))
	elseif type == "@npcname@" then
		return str:gsub("@npcname@", noun):gsub("@npcname@", addJosa(noun, "가")):gsub("@npcname2@", addJosa(noun, "는")):gsub("@npcname3@", addJosa(noun, "를")):gsub("@npcname4@", addJosa(noun, "로")):gsub("@npcname5@", addJosa(noun, "다")):gsub("@npcname6@", addJosa(noun, "과")):gsub("@npcname7@", addJosa(noun, 7))
	else
		return str:gsub(type, noun)
	end
end)

setFlag("tformat_special", function(s, locales_args, special, ...)
	local args
	if locales_args then
		local sargs = {...}
		args = {}
		for sidx, didx in pairs(locales_args) do
			args[sidx] = sargs[didx]
		end
	else
		args = {...}
	end
	s = _t(s)
	for k, v in pairs(special) do
		args[k] = addJosa(args[k], v)
	end
	return s:format(unpack(args))
end)
