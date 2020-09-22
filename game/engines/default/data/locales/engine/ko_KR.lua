locale "ko_KR"
-- COPY
forceFontPackage("korean")
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
	elseif type == "@Source@" then
		return str:gsub("@Source@", noun):gsub("@Source1@", addJosa(noun, "가")):gsub("@Source2@", addJosa(noun, "는")):gsub("@Source3@", addJosa(noun, "를")):gsub("@Source4@", addJosa(noun, "로")):gsub("@Source5@", addJosa(noun, "다")):gsub("@Source6@", addJosa(noun, "과")):gsub("@Source7@", addJosa(noun, 7))
	elseif type == "@source@" then
		return str:gsub("@source@", noun):gsub("@source@", addJosa(noun, "가")):gsub("@source2@", addJosa(noun, "는")):gsub("@source3@", addJosa(noun, "를")):gsub("@source4@", addJosa(noun, "로")):gsub("@source5@", addJosa(noun, "다")):gsub("@source6@", addJosa(noun, "과")):gsub("@source7@", addJosa(noun, 7))
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

setFlag("tformat_special", function(s, tag, locales_args, special, ...)
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
	s = _t(s, tag)
	for k, v in pairs(special) do
		args[k] = addJosa(args[k], v)
	end
	return s:format(unpack(args))
end)

------------------------------------------------
section "always_merge"

t("3-head", "3-head", nil)
t("3-headed hydra", "세 머리 히드라", nil)
t("Agrimley the hermit", "은둔자 아그림레이", nil)
t("Allied Kingdoms", "왕국연합", nil)
t("Angolwen", "앙골웬", nil)
t("Assassin lair", "암살단", nil)
t("Control Room", "제어실", nil)
t("Cosmic Fauna", "Cosmic Fauna", nil)
t("Dreadfell", "두려움의 영역", nil)
t("Enemies", "적", nil)
t("Experimentation Room", "연습실", nil)
t("Exploratory Farportal", "탐험용 장거리 차원문", nil)
t("FINGER", "반지", nil)
t("Fearscape", "공포의 영역", nil)
t("Hall of Reflection", "반영의 전당", nil)
t("Horrors", "공포", nil)
t("Iron Throne", "철의 왕좌", nil)
t("Keepers of Reality", "현실의 수호자", nil)
t("MAINHAND", "주무기", nil)
t("Marus of Elvala", "엘발라의 말루스", nil)
t("OFFHAND", "보조무기", nil)
t("Orc Pride", "오크 긍지", nil)
t("Portal Room", "차원문의 방", nil)
t("Rhalore", "랄로레", nil)
t("Sandworm Burrowers", "굴 파는 샌드웜", nil)
t("Shalore", "샬로레", nil)
t("Sher'Tul", "쉐르'툴", nil)
t("Slavers", "노예", nil)
t("Sorcerers", "주술사", nil)
t("Stire of Derth", "데르스의 스타이어", nil)
t("Storage Room", "창고", nil)
t("Sunwall", "태양의 장벽", nil)
t("Temple of Creation", "창조의 사원", nil)
t("Thalore", "탈로레", nil)
t("The Way", "한길", nil)
t([[Today is the %s %s of the %s year of the Age of Ascendancy of Maj'Eyal.
The time is %02d:%02d.]], [[오늘은 주도의 시대를 맞은 마즈'에이알 %s 년 %s %s 일 입니다.
현재 시간은 %02d 시 %02d 분입니다.]], nil)
t("Undead", "언데드", nil)
t("Ungrol of Last Hope", "마지막 희망의 웅그롤", nil)
t("Vargh Republic", "바르그 공화국", nil)
t("Victim", "제물", nil)
t("Water lair", "수중단", nil)
t("Zigur", "지구르", nil)
t("absolute", "절대", nil)
t("armours", "갑옷류", nil)
t("bomb", "폭탄", nil)
t("bonestaff", "뼈 마법지팡이", nil)
t("charged", "charged", nil)
t("combat", "전투", nil)
t("daikara", "다이카라", nil)
t("default", "기본", nil)
t("demon", "악마", nil)
t("dragon", "용", nil)
t("dream", "꿈의", nil)
t("east", "동쪽", nil)
t("exit", "출구", nil)
t("harmonystaff", "조화 마법지팡이", nil)
t("humanoid", "인간형", nil)
t("humanoid/orc", "인간형/오크", nil)
t("hydra", "히드라", nil)
t("injured seer", "부상당한 탐시자", nil)
t("kinetic", "동역학", nil)
t("living", "생명", nil)
t("lone alchemist", "외로운 연금술사", nil)
t("lost defiler", "길 잃은 모독자", nil)
t("lost sun paladin", "길 잃은 태양의 기사", nil)
t("lost warrior", "길 잃은 전사", nil)
t("magestaff", "마법사 마법지팡이", nil)
t("magical", "마법적 효과", nil)
t("mainhand", "주무기", nil)
t("melee", "근접", nil)
t("mental", "정신적 효과", nil)
t("mountain chain", "산맥", nil)
t("movement", "이동", nil)
t("north", "북쪽", nil)
t("northeast", "북동쪽", nil)
t("northwest", "북서쪽", nil)
t("offhand", "offhand", nil)
t("portal", "차원문", nil)
t("portal back", "돌아가는 차원문", nil)
t("ranged", "원거리", nil)
t("repented thief", "회개한 도적", nil)
t("rimebark", "서리 나무", nil)
t("seed", "seed", nil)
t("south", "남쪽", nil)
t("southeast", "남동쪽", nil)
t("southwest", "남서쪽", nil)
t("spell", "주문", nil)
t("standard", "표준", nil)
t("standby", "standby", nil)
t("starstaff", "별 마법지팡이", nil)
t("stone golem", "암석 골렘", nil)
t("summon", "소환", nil)
t("summoned", "소환수", nil)
t("tank", "tank", nil)
t("temporal explorer", "시간의 여행자", nil)
t("temporal hound", "시간의 사냥개", nil)
t("thermal", "열역학", nil)
t("throwing", "투척", nil)
t("turtle", "거북이", nil)
t("unarmed", "맨손", nil)
t("undead", "언데드", nil)
t("unliving", "unliving", nil)
t("unnatural", "비자연적 존재", nil)
t("unseen", "알 수 없는 것", nil)
t("vilestaff", "독성 마법지팡이", nil)
t("volcanic mountains", "화산 지형", nil)
t("war hound", "전투견", nil)
t("weapons", "무기류", nil)
t("west", "서쪽", nil)
t("worried loremaster", "근심하는 지식 전달자", nil)


------------------------------------------------
section "game/engines/default/data/keybinds/actions.lua"

t("Go to next/previous level", "다음/이전 단계로 이동", "_t")
t("Levelup window", "레벨업 창", "_t")
t("Use talents", "기술 발동", "_t")
t("Show quests", "임무 보이기", "_t")
t("Rest for a while", "휴식하기", "_t")
t("Save game", "게임 저장", "_t")
t("Quit game", "게임 종료", "_t")
t("Tactical display on/off", "전술정보 표시 전환", "_t")
t("Look around", "둘러보기", "_t")
t("Center the view on the player", "플레이어를 화면 중앙에 보이기", "_t")
t("Toggle minimap", "미니맵 켜기/끄기", "_t")
t("Show game calendar", "게임 내 달력 보이기", "_t")
t("Show character sheet", "캐릭터 시트 보이기", "_t")
t("Switch graphical modes", "그래픽 모드 전환", "_t")
t("Accept action", "확인 키", "_t")
t("Exit menu", "메뉴에서 나가기", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/chat.lua"

t("Talk to people", "사람들과 대화하기", "_t")
t("Display chat log", "대화 기록 표시하기", "_t")
t("Cycle chat channels", "대화 채널 변경", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/debug.lua"

t("Show Lua console", "Lua 콘솔 보기", "_t")
t("Debug Mode", "디버그 모드", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/hotkeys.lua"

t("Hotkey 1", "단축키 1", "_t")
t("Hotkey 2", "단축키 2", "_t")
t("Hotkey 3", "단축키 3", "_t")
t("Hotkey 4", "단축키 4", "_t")
t("Hotkey 5", "단축키 5", "_t")
t("Hotkey 6", "단축키 6", "_t")
t("Hotkey 7", "단축키 7", "_t")
t("Hotkey 8", "단축키 8", "_t")
t("Hotkey 9", "단축키 9", "_t")
t("Hotkey 10", "단축키 10", "_t")
t("Hotkey 11", "단축키 11", "_t")
t("Hotkey 12", "단축키 12", "_t")
t("Secondary Hotkey 1", "두번째 단축키 1", "_t")
t("Secondary Hotkey 2", "두번째 단축키 2", "_t")
t("Secondary Hotkey 3", "두번째 단축키 3", "_t")
t("Secondary Hotkey 4", "두번째 단축키 4", "_t")
t("Secondary Hotkey 5", "두번째 단축키 5", "_t")
t("Secondary Hotkey 6", "두번째 단축키 6", "_t")
t("Secondary Hotkey 7", "두번째 단축키 7", "_t")
t("Secondary Hotkey 8", "두번째 단축키 8", "_t")
t("Secondary Hotkey 9", "두번째 단축키 9", "_t")
t("Secondary Hotkey 10", "두번째 단축키 10", "_t")
t("Secondary Hotkey 11", "두번째 단축키 11", "_t")
t("Secondary Hotkey 12", "두번째 단축키 12", "_t")
t("Third Hotkey 1", "세번째 단축키 1", "_t")
t("Third Hotkey 2", "세번째 단축키 2", "_t")
t("Third Hotkey 3", "세번째 단축키 3", "_t")
t("Third Hotkey 4", "세번째 단축키 4", "_t")
t("Third Hotkey 5", "세번째 단축키 5", "_t")
t("Third Hotkey 6", "세번째 단축키 6", "_t")
t("Third Hotkey 7", "세번째 단축키 7", "_t")
t("Third Hotkey 8", "세번째 단축키 8", "_t")
t("Third Hotkey 9", "세번째 단축키 9", "_t")
t("Third Hotkey 10", "세번째 단축키 10", "_t")
t("Third Hotkey 11", "세번째 단축키 11", "_t")
t("Third Hotkey 12", "세번째 단축키 12", "_t")
t("Fourth Hotkey 1", "네번째 단축키 1", "_t")
t("Fourth Hotkey 2", "네번째 단축키 2", "_t")
t("Fourth Hotkey 3", "네번째 단축키 3", "_t")
t("Fourth Hotkey 4", "네번째 단축키 4", "_t")
t("Fourth Hotkey 5", "네번째 단축키 5", "_t")
t("Fourth Hotkey 6", "네번째 단축키 6", "_t")
t("Fourth Hotkey 7", "네번째 단축키 7", "_t")
t("Fourth Hotkey 8", "네번째 단축키 8", "_t")
t("Fourth Hotkey 9", "네번째 단축키 9", "_t")
t("Fourth Hotkey 10", "네번째 단축키 10", "_t")
t("Fourth Hotkey 11", "네번째 단축키 11", "_t")
t("Fourth Hotkey 12", "네번째 단축키 12", "_t")
t("Fifth Hotkey 1", "다섯번째 단축키 1", "_t")
t("Fifth Hotkey 2", "다섯번째 단축키 2", "_t")
t("Fifth Hotkey 3", "다섯번째 단축키 3", "_t")
t("Fifth Hotkey 4", "다섯번째 단축키 4", "_t")
t("Fifth Hotkey 5", "다섯번째 단축키 5", "_t")
t("Fifth Hotkey 6", "다섯번째 단축키 6", "_t")
t("Fifth Hotkey 7", "다섯번째 단축키 7", "_t")
t("Fifth Hotkey 8", "다섯번째 단축키 8", "_t")
t("Fifth Hotkey 9", "다섯번째 단축키 9", "_t")
t("Fifth Hotkey 10", "다섯번째 단축키 10", "_t")
t("Fifth Hotkey 11", "다섯번째 단축키 11", "_t")
t("Fifth Hotkey 12", "다섯번째 단축키 12", "_t")
t("Previous Hotkey Page", "이전 단축키 페이지", "_t")
t("Next Hotkey Page", "다음 단축키 페이지", "_t")
t("Quick switch to Hotkey Page 2", "2번 단축키 페이지로 빠른 전환", "_t")
t("Quick switch to Hotkey Page 3", "3번 단축키 페이지로 빠른 전환", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/interface.lua"

t("Toggle list of seen creatures", "확인된 생명체 목록 전환", "_t")
t("Show message log", "메시지 로그 보기", "_t")
t("Take a screenshot", "화면 촬영", "_t")
t("Show map", "지도 보이기", "_t")
t("Scroll map mode", "화면 이동 모드", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/inventory.lua"

t("Show inventory", "소지품 보기", "_t")
t("Show equipment", "장비품 보기", "_t")
t("Pickup items", "물건 줍기", "_t")
t("Drop items", "물건 버리기", "_t")
t("Wield/wear items", "장비 착용하기", "_t")
t("Takeoff items", "장비 탈착하기", "_t")
t("Use items", "물건 사용하기", "_t")
t("Quick switch weapons set", "무기 세트 빠른 전환", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/move.lua"

t("Move left", "왼쪽으로 이동", "_t")
t("Move right", "오른쪽으로 이동", "_t")
t("Move up", "위로 이동", "_t")
t("Move down", "아래로 이동", "_t")
t("Move diagonally left and up", "좌상단으로 대각 이동", "_t")
t("Move diagonally right and up", "우상단으로 대각 이동", "_t")
t("Move diagonally left and down", "좌하단으로 대각 이동", "_t")
t("Move diagonally right and down", "좌상단으로 대각 이동", "_t")
t("Stay for a turn", "한턴 대기", "_t")
t("Run", "달리기", "_t")
t("Run left", "왼쪽으로 달리기", "_t")
t("Run right", "오른쪽으로 달리기", "_t")
t("Run up", "위로 달리기", "_t")
t("Run down", "아래로 달리기", "_t")
t("Run diagonally left and up", "좌상단으로 대각 달리기", "_t")
t("Run diagonally right and up", "우상단으로 대각 달리기", "_t")
t("Run diagonally left and down", "좌하단으로 대각 달리기", "_t")
t("Run diagonally right and down", "좌상단으로 대각 달리기", "_t")
t("Auto-explore", "자동 탐색", "_t")
t("movement", "이동", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/mtxn.lua"

t("List purchasable", "구매 가능 목록 보기", "_t")
t("Use purchased", "구매한 품목 확인하기", "_t")


------------------------------------------------
section "game/engines/default/engine/ActorsSeenDisplay.lua"

t("%s (%d)#WHITE#; distance [%s]", "%s (%d)#WHITE#; 거리 [%s]", "tformat")


------------------------------------------------
section "game/engines/default/engine/Birther.lua"

t("Enter your character's name", "캐릭터 이름을 입력해주세요", "_t")
t("Name", "이름", "_t")
t("Character Creation: %s", "캐릭터 생성: %s", "tformat")
t([[Keyboard: #00FF00#up key/down key#FFFFFF# to select an option; #00FF00#Enter#FFFFFF# to accept; #00FF00#Backspace#FFFFFF# to go back.
Mouse: #00FF00#Left click#FFFFFF# to accept; #00FF00#right click#FFFFFF# to go back.
]], [[키보드: #00FF00#위/아래 방향키#FFFFFF# 로 설정을 변경; #00FF00#엔터키#FFFFFF# 로 확인; #00FF00#백스페이스키#FFFFFF# 로 돌아가기.
마우스: #00FF00#좌클릭#FFFFFF# 으로 확인; #00FF00#우클릭#FFFFFF# 으로 돌아가기.
]], "_t")
t("Random", "무작위", "_t")
t("Do you want to recreate the same character?", "같은 캐릭터를 재생성하시겠습니까?", "_t")
t("Quick Birth", "빠른 탄생", "_t")
t("New character", "새로운 캐릭터", "_t")
t("Recreate", "재생성", "_t")
t("Randomly selected %s.", "무작위로 선택하기 %s.", "log")


------------------------------------------------
section "game/engines/default/engine/DebugConsole.lua"

t("Lua Console", "Lua 콘솔", "_t")


------------------------------------------------
section "game/engines/default/engine/Dialog.lua"

t("Yes", "네", "_t")
t("No", "아니요", "_t")


------------------------------------------------
section "game/engines/default/engine/Game.lua"

t([[Screenshot should appear in your Steam client's #LIGHT_GREEN#Screenshots Library#LAST#.
Also available on disk: %s]], [[스크린샷이 스팀 클라이언트의 #LIGHT_GREEN#스크린샷 라이브러리#LAST#에 저장되었습니다.
저장 경로: %s]], "tformat")
t("File: %s", "파일: %s", "tformat")
t("Screenshot taken!", "스크린샷 촬영됨!", "_t")


------------------------------------------------
section "game/engines/default/engine/HotkeysDisplay.lua"

t("Missing!", "찾을 수 없음!", "_t")


------------------------------------------------
section "game/engines/default/engine/HotkeysIconsDisplay.lua"

t("Missing!", "찾을 수 없음!", "_t")


------------------------------------------------
section "game/engines/default/engine/I18N.lua"

t("Testing arg one %d and two %d", "인자 테스트 1번째 %d 와 2번째 %d", "tformat")


------------------------------------------------
section "game/engines/default/engine/Key.lua"

t("#LIGHT_RED#Keyboard input temporarily disabled.", "#LIGHT_RED#키보드 입력 임시 비활성화.", "log")


------------------------------------------------
section "game/engines/default/engine/LogDisplay.lua"

t("Message Log", "메시지 로그", "_t")


------------------------------------------------
section "game/engines/default/engine/MicroTxn.lua"

t("Test", "테스트", "_t")


------------------------------------------------
section "game/engines/default/engine/Module.lua"

t("#LIGHT_RED#Online profile disabled(switching to offline profile) due to %s.", "#LIGHT_RED#%s 발생하여 온라인 프로필 비활성화(오프라인 프로필로 교체됨)", "log", nil, {"이"})


------------------------------------------------
section "game/engines/default/engine/Mouse.lua"

t("#LIGHT_RED#Mouse input temporarily disabled.", "#LIGHT_RED#마우스 입력 임시 비활성화", "log")


------------------------------------------------
section "game/engines/default/engine/Object.lua"

t("Requires:", "요구사항:", "_t")
t("%s (level %d)", "%s (%d 레벨)", "tformat")
t("Level %d", "%d 레벨", "tformat")
t("Talent %s (level %d)", "기술 %s (%d 레벨)", "tformat")
t("Talent %s", "기술 : %s", "tformat")


------------------------------------------------
section "game/engines/default/engine/PlayerProfile.lua"

t("#YELLOW#Connection to online server established.", "#YELLOW#온라인 서버에 연결됨.", "log")
t("#YELLOW#Connection to online server lost, trying to reconnect.", "#YELLOW#온라인 서버 연결이 끊김. 재접속 시도 중.", "log")
t("bad game version", "게임 버전이 잘못됨", "_t")
t("nothing to update", "업데이트가 존재하지 않음", "_t")
t("bad game addon version", "애드온 버전이 잘못됨", "_t")
t("no online profile active", "활성화된 온라인 프로필 없음", "_t")
t("cheat mode active", "치트 모드 활성화", "_t")
t("savefile tainted", "세이브 파일이 오염됨", "_t")
t("unknown error", "알 수 없는 오류", "_t")
t("Character is being registered on https://te4.org/", "캐릭터는 https://te4.org/ 에 등록됩니다.", "_t")
t("Registering character", "캐릭터 등록 중", "_t")
t("Retrieving data from the server", "서버에서 데이터를 받아오는 중", "_t")
t("Retrieving...", "데이터를 받아오는 중...", "_t")


------------------------------------------------
section "game/engines/default/engine/Quest.lua"

t("active", "활성", "_t")
t("completed", "완료", "_t")
t("done", "성공", "_t")
t("failed", "실패", "_t")


------------------------------------------------
section "game/engines/default/engine/Savefile.lua"

t("Please wait while saving the world...", "월드를 저장 중 입니다...", "_t")
t("Saving world", "월드 저장 중", "_t")
t("Please wait while saving the game...", "게임을 저장 중 입니다...", "_t")
t("Saving game", "게임 저장 중", "_t")
t("Please wait while saving the zone...", "지역을 저장 중 입니다...", "_t")
t("Saving zone", "지역 저장 중", "_t")
t("Please wait while saving the level...", "구역을 저장 중 입니다...", "_t")
t("Saving level", "구역 저장 중", "_t")
t("Please wait while saving the entity...", "엔티티를 저장 중 입니다...", "_t")
t("Saving entity", "엔티티 저장 중", "_t")
t("Loading world", "월드 불러오는 중", "_t")
t("Please wait while loading the world...", "월드를 불러오는 중 입니다...", "_t")
t("Loading game", "게임 불러오는 중", "_t")
t("Please wait while loading the game...", "게임을 불러오는 중 입니다...", "_t")
t("Loading zone", "지역 불러오는 중", "_t")
t("Please wait while loading the zone...", "지역를 불러오는 중 입니다...", "_t")
t("Loading level", "구역 불러오는 중", "_t")
t("Please wait while loading the level...", "구역을 불러오는 중 입니다...", "_t")
t("Loading entity", "엔티티 불러오는 중", "_t")
t("Please wait while loading the entity...", "엔티티를 불러오는 중 입니다...", "_t")


------------------------------------------------
section "game/engines/default/engine/SavefilePipe.lua"

t("Saving done.", "저장 완료.", "log")
t("Please wait while saving...", "저장하는 동안 잠시 기다려주세요...", "_t")
t("Saving...", "저장 중...", "_t")


------------------------------------------------
section "game/engines/default/engine/Store.lua"

t("Store: %s", "상점: %s", "tformat")
t("Buy %d %s", "%d %s 구입", "tformat")
t("Buy", "구입", "_t")
t("Sell %d %s", "%d %s 판매", "tformat")
t("Cancel", "취소", "_t")
t("Sell", "판매", "_t")


------------------------------------------------
section "game/engines/default/engine/Trap.lua"

t("%s fails to disarm a trap (%s).", "%s %s 함정을 해제하는데 실패함.", "logSeen")
t("%s disarms a trap (%s).", "%s %s 함정을 해제하는데 성공함.", "logSeen")
t("%s triggers a trap (%s)!", "%s %s 함정이 발동됨!", "logSeen")


------------------------------------------------
section "game/engines/default/engine/UserChat.lua"

t("Ignoring all new messages from %s.", "%s 로부터의 모든 메시지를 무시합니다.", "log")
t([[#{bold}#Thank you#{normal}# for you donation, your support means a lot for the continued survival of this game.

Your current donation total is #LIGHT_GREEN#%0.2f euro#WHITE# which equals to #ROYAL_BLUE#%d voratun coins#WHITE# to use on te4.org.
Your Item Vault has #TEAL#%d slots#WHITE#.

Again, thank you, and enjoy Eyal!

#{italic}#Your malevolent local god of darkness, #GOLD#DarkGod#{normal}#]], [[기부를 해주셔서 정말 #{bold}#감사합니다.#{normal}# 여러분의 후원은 이 게임이 계속 살아남는데에 큰 도움이 됩니다.

당신의 후원액 총합은 #LIGHT_GREEN#%0.2f 유로#WHITE#이며 #ROYAL_BLUE#%d 보라툰 코인#WHITE#으로 te4.org 에서 사용이 가능합니다.
당신의 아이템 금고는 총 #TEAL#%d 칸#WHITE#입니다.

다시 한번 감사드리며, 에이알을 즐겨주세요!!

#{italic}#당신만의 악랄한 어둠의 신, darkgod#GOLD#DarkGod#{normal}#]], "tformat")
t("Thank you!", "감사합니다!", "_t")
t("#{italic}#Joined channel#{normal}#", "#{italic}# 채널에 참가.#{normal}#", "_t")
t("#{italic}#Left channel#{normal}#", "#{italic}# 채널에서 떠남.#{normal}#", "_t")
t("#{italic}##FIREBRICK#has joined the channel#{normal}#", "#{italic}##FIREBRICK# 채널에 참가했습니다#{normal}#", "_t")
t("#{italic}##FIREBRICK#has left the channel#{normal}#", "#{italic}##FIREBRICK# 채널을 떠났습니다#{normal}#", "_t")
t("#CRIMSON#You are not subscribed to any channel, you can change that in the game options.#LAST#", "#CRIMSON#현재 아무런 채널에도 참가되어있지 않습니다. 게임 설정을 확인해주세요.#LAST#", "log")
t("Error", "오류", "_t")
t("The server does not know about this player.", "서버에서 해당 유저를 찾을 수 없습니다.", "_t")
t("Requesting user info...", "유저 정보 요청 중...", "_t")
t("Requesting...", "요청 중...", "_t")


------------------------------------------------
section "game/engines/default/engine/Zone.lua"

t("Loading level", "구역 불러오는 중", "_t")
t("Please wait while loading the level... ", "구역을 불러오는 중 입니다... ", "_t")
t("Generating level", "구역 생성 중", "_t")
t("Please wait while generating the level... ", "구역을 생성 중 입니다... ", "_t")


------------------------------------------------
section "game/engines/default/engine/ai/talented.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/AudioOptions.lua"

t("Audio Options", "오디오 설정", "_t")
t("Enable audio", "오디오 활성화", "_t")
t("Music: ", "음악: ", "_t")
t("Effects: ", "효과음: ", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatChannels.lua"

t("Chat channels", "대화 채널", "_t")
t("Global", "전세계", "_t")
t(" [spoilers]", " [스포일러]", "_t")
t("Select which channels to listen to. You can join new channels by typing '/join <channelname>' in the talkbox and leave channels by typing '/part <channelname>'", "대화를 들을 채널을 선택합니다. 새로운 채널에 참가하려면 '/join <채널명>' 을, 채널에서 나가려면 '/part <channelname>' 을 대화창에 입력해주세요.", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatFilter.lua"

t("Chat filters", "대화 필터", "_t")
t("Public chat", "공개 대화", "_t")
t("Private whispers", "귓속말", "_t")
t("Join/part messages", "메시지 참가/퇴장", "_t")
t("First time achievements (recommended to keep them on)", "최초 달성 도전과제 (항상 켜두는 것을 추천)", "_t")
t("Important achievements (recommended to keep them on)", "중요한 도전과제 (항상 켜두는 것을 추천)", "_t")
t("Other achievements", "기타 도전과제", "_t")
t("Select which types of chat events to see or not.", "확인할 메시지를 선택하세요.", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatIgnores.lua"

t("Chat ignore list", "무시할 대화 목록", "_t")
t("Really stop ignoring: %s", "정말로 %s 의 대화 무시를 해제하시겠습니까?", "tformat")
t("Stop ignoring", "대화 무시 해제", "_t")
t("Click a user to stop ignoring her/his messages.", "유저명을 클릭 시 대화 무시를 해제합니다.", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/DisplayResolution.lua"

t("Switch Resolution", "해상도 전환", "_t")
t("Fullscreen", "전체 화면", "_t")
t("Borderless", "전체 창 모드", "_t")
t("Windowed", "창 모드", "_t")
t("Engine Restart Required", "엔진 재시작 필요", "_t")
t(" (progress will be saved)", " (작업 저장 중)", "_t")
t("Continue? %s", "%s 계속하시겠습니까?", "tformat", nil, {"를"})
t("Reset Window Position?", "창 위치를 초기화하시겠습니까?", "_t")
t("Simply restart or restart+reset window position?", "게임 재시작 혹은 창 위치 초기화 후 재시작하시겠습니까?", "_t")
t("Restart", "재시작", "_t")
t("Restart with reset", "창 위치 초기화 후 재시작", "_t")
t("No", "아니요", "_t")
t("Yes", "네", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/Downloader.lua"

t("Download: %s", "다운로드: %s", "tformat")
t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GameMenu.lua"

t("Game Menu", "게임 메뉴", "_t")
t("Resume", "돌아가기", "_t")
t("Language", "언어", "_t")
t("Key Bindings", "키 설정", "_t")
t("Video Options", "비디오 설정", "_t")
t("Display Resolution", "표시 해상도", "_t")
t("Show Achievements", "도전과제 확인", "_t")
t("Audio Options", "오디오 설정", "_t")
t("#GREY#Developer Mode", "#GREY#개발자 모드", "_t")
t("Disable developer mode?", "개발자 모드를 비활성화하시겠습니까?", "_t")
t("Developer Mode", "개발자 모드", "_t")
t([[Enable developer mode?
Developer Mode is a special game mode used to debug and create addons.
Using it will #CRIMSON#invalidate#LAST# any savefiles loaded.
When activated you will have access to special commands:
- CTRL+L: bring up a lua console that lets you explore and alter all the game objects, enter arbitrary lua commands, ...
- CTRL+A: bring up a menu to easily do many tasks (create NPCs, teleport to zones, ...)
- CTRL+left click: teleport to the clicked location
]], [[개발자 모드를 활성화하시겠습니까?
개발자 모드는 디버그 및 애드온 제작에 사용되는 특별한 게임 모드입니다..
개발자 모드에서 사용한 모든 세이브 파일은 더 이상 #CRIMSON#유효하지 않습니다.#LAST#.
활성화 된 동안 특별한 명령어에 접근할 수 있습니다:
- CTRL+L: 명령어를 입력할 수 있는 lua 콘솔을 불러옵니다. (직접적인 게임 내부 접근)
- CTRL+A: 쉽게 많은 일을 할 수 있는 메뉴를 불러옵니다. (NPC 생성, 텔레포트 등)
- CTRL+좌 클릭: 클릭한 장소로 텔레포트합니다.
]], "_t")
t("No", "아니요", "_t")
t("Yes", "네", "_t")
t("Save Game", "게임 저장", "_t")
t("Main Menu", "메인 메뉴", "_t")
t("Exit Game", "게임 종료", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantity.lua"

t("Quantity", "수량", "_t")
t("Accept", "수락", "_t")
t("Cancel", "취소", "_t")
t("Enter a quantity.", "수량 입력.", "_t")
t("Error", "오류", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantitySlider.lua"

t("Quantity", "수량", "_t")
t("Accept", "수락", "_t")
t("Cancel", "취소", "_t")
t("Enter a quantity.", "수량 입력.", "_t")
t("Error", "오류", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"

t("Accept", "수락", "_t")
t("Cancel", "취소", "_t")
t("Error", "오류", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/KeyBinder.lua"

t("Key bindings", "입력키 설정", "_t")
t("      Press a key (escape to cancel, backspace to remove) for: %s", "      키 입력 (ESC로 취소, 백스페이스로 설정 해제) : %s", "tformat")
t("Bind alternate key", "보조 키 설정", "_t")
t("Bind key", "키 설정", "_t")
t("Make gesture (using right mouse button) or type it (or escape) for: %s", "마우스 제스쳐 (우클릭 후 드래그) 혹은 방향 입력 (혹은 ESC) : %s", "tformat")
t("Gesture", "제스쳐", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/LanguageSelect.lua"

t("Language Selection", "언어 선택", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowAchievements.lua"

t("Achievements(%s/%s)", "도전과제(%s/%s)", "tformat")
t("Yours only", "현재 플레이 중", "_t")
t("All achieved", "모두 달성", "_t")
t("Everything", "전체 실적", "_t")
t("Achievement", "도전과제", "_t")
t("Category", "분류", "_t")
t("When", "위치", "_t")
t("Who", "달성자", "_t")
t([[#GOLD#Also achieved by your current character#LAST#
]], [[#GOLD#현재 캐릭터도 도전과제를 달성했습니다#LAST#
]], "_t")
t([[#GOLD#Achieved on:#LAST# %s
#GOLD#Achieved by:#LAST# %s
%s
#GOLD#Description:#LAST# %s]], [[#GOLD#달성 일자:#LAST# %s
#GOLD#달성한 캐릭터:#LAST# %s
%s
#GOLD#해제 조건:#LAST# %s]], "tformat")
t("Progress: ", "진행상황: ", "_t")
t("-- Unknown --", "-- 알 수 없음 --", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipInven.lua"

t("Inventory", "소지품", "_t")
t("Equipment", "장비", "_t")
t("Category", "분류", "_t")
t("Enc.", "기타", "_t")
t("%s assigned to hotkey %s", "%s %s의 단축키로 지정되었습니다.", "tformat", {2,1}, {[2]="가"})
t("Hotkey %s assigned", "단축키 %s 지정됨", "tformat", nil, {"가"})


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipment.lua"

t("Equipment", "장비", "_t")
t("Category", "분류", "_t")
t("Enc.", "기타", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowErrorStack.lua"

t("Lua Error", "Lua 오류", "_t")
t("If you already reported that error, you do not have to do it again (unless you feel the situation is different).", "만약 이 오류를 이미 알려 주셨다면 또 하실 필요는 없습니다 (다른 상황에서 겪었다면 알려 주세요).", "_t")
t("You #LIGHT_GREEN#already reported#WHITE# that error, you do not have to do it again (unless you feel the situation is different).", "만약 이 오류를 #LIGHT_GREEN#이미 알려 주셨다면#WHITE# 또 하실 필요는 없습니다 (다른 상황에서 겪었다면 알려 주세요).", "_t")
t("You have already got this error but #LIGHT_RED#never reported#WHITE# it, please do.", "이미 이 오류를 보셨더라도 #LIGHT_RED#알려 주시지 않으셨다면#WHITE# 보고해 주시기 바랍니다.", "_t")
t("You have #LIGHT_RED#never seen#WHITE# that error, please report it.", "이 오류를 #LIGHT_RED#처음으로 보셨다면#WHITE# 알려 주시기 바랍니다.", "_t")
t([[#{bold}#Oh my! It seems there was an error!
The game might still work but this is suspect, please type in your current situation and click on "Send" to send an error report to the game creator.
If you are not currently connected to the internet, please report this bug when you can on the forums at http://forums.te4.org/

]], [[#{bold}#이럴 수가! 아무래도 오류가 발생한 것 같네요!
게임은 여전히 작동하겠지만, 이 부분은 의심스러워요. 현재 상황을 써주시고 "보내기"를 눌러 제작자에게 오류가 발생했다는 것을 알려 주시기 바랍니다.
지금 인터넷에 연결되어있지 않다면, 가능할 때 이 오류를 다음 주소의 게시판에 올려 주시기 바랍니다. http://forums.te4.org/

]], "_t")
t("What happened?: ", "무엇이 일어났죠?: ", "_t")
t("Send", "보내기", "_t")
t("Close", "닫기", "_t")
t("Close All", "전부 닫기", "_t")
t("File location copied to clipboard.", "클립보드에 파일 주소가 복사됨.", "log")
t("Log saved to file (click to copy to clipboard):#LIGHT_BLUE#%s", "파일에 로그가 저장됨 (클립보드에 복사하려면 클릭):#LIGHT_BLUE#%s", "tformat")
t("#YELLOW#Error report sent, thank you.", "#YELLOW#보고서가 제출됐습니다. 감사합니다.", "log")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowInventory.lua"

t("Inventory", "소지품", "_t")
t("Category", "분류", "_t")
t("Enc.", "기타", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowPickupFloor.lua"

t("Pickup", "줍기", "_t")
t("(*) Take all", "(*) 전부 줍기", "_t")
t("Item", "물건", "_t")
t("Category", "분류", "_t")
t("Enc.", "기타", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowQuests.lua"

t("Quest Log for %s", "%s의 퀘스트 로그", "tformat")
t("Quest", "퀘스트", "_t")
t("Status", "상태", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowStore.lua"

t("Inventory", "소지품", "_t")
t("Store", "상점", "_t")
t("Category", "분류", "_t")
t("Price", "가격", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowText.lua"

t("Text", "회상", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/SteamOptions.lua"

t("Steam Options", "스팀 설정", "_t")
t([[Enable Steam Cloud saves.
Your saves will be put on steam cloud and always be available everywhere.
Disable if you have bandwidth limitations.#WHITE#]], [[Steam 클라우드 저장을 활성화합니다.
저장된 게임이 Steam 클라우드에 동기화되며, 어디에서든 동기화된 게임을 불러올 수 있게됩니다.
인터넷 속도가 제한된 환경이라면 꺼주세요.#WHITE#]], "_t")
t("#GOLD##{bold}#Cloud Saves#WHITE##{normal}#", "#GOLD##{bold}#클라우드 동기화#WHITE##{normal}#", "_t")
t("disabled", "끄기", "_t")
t("enabled", "켜기", "_t")
t([[Purge all Steam Cloud saves.
This will remove all saves from the cloud cloud (but not your local copy). Only use if you somehow encounter storage problems on it (which should not happen, the game automatically manages it for you).#WHITE#]], [[Steam 클라우드에 저장된 모든 게임을 제거합니다.
컴퓨터 내에 저장된 세이브 파일은 제거되지 않습니다. Steam 클라우드의 저장 공간 문제를 발생했을 때만 사용해주세요. (그러한 문제가 발생하지 않았다면 자동으로 관리됩니다.)#WHITE#]], "_t")
t("#GOLD##{bold}#Purge Cloud Saves#WHITE##{normal}#", "#GOLD##{bold}#클라우드 파일 제거#WHITE##{normal}#", "_t")
t("Confirm purge?", "제거에 동의하십니까?", "_t")
t("All data purged from the cloud.", "모든 파일이 Steam 클라우드에서 제거되었습니다.", "_t")
t("Steam Cloud Purge", "Steam 클라우드 제거", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/Talkbox.lua"

t("Say: ", "말하기: ", "_t")
t("Accept", "수락", "_t")
t("Cancel", "취소", "_t")
t("Target: ", "대상: ", "_t")
t("Channel: %s", "채널: %s", "tformat")
t("Friend: %s", "친구: %s", "tformat")
t("User: %s", "유저: %s", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"

t("Use Talents: ", "기술 사용: ", "tformat")
t([[You can bind a talent to a hotkey be pressing the corresponding hotkey while selecting a talent.
Check out the keybinding screen in the game menu to bind hotkeys to a key (default is 1-0 plus control or shift).
]], [[기술을 고른 상태에서 어떤 자리를 누르는 것으로 그 자리를 그 기술의 단축키로 지정할 수 있습니다.
단축키로 사용할 수 있는 자리를 바꾸려면 키 설정 화면을 확인하세요 (기본 설정은 1-0에 ctrl이나 shift 키입니다).
]], "_t")
t("Talent", "기술", "_t")
t("Status", "상태", "_t")
t("%s assigned to hotkey %s", "%s %s의 단축키로 지정되었습니다.", "tformat", {2,1}, {[2]="가"})
t("Hotkey %s assigned", "단축키 %s 지정됨", "tformat", nil, {"가"})


------------------------------------------------
section "game/engines/default/engine/dialogs/UserInfo.lua"

t("User: %s", "유저: %s", "tformat")
t("Currently playing: ", "현재 게임 중: ", "_t")
t("unknown", "알 수 없음", "_t")
t("Game: ", "게임: ", "_t")
t("Game has been validated by the server", "서버가 인증한 게임", "_t")
t("Game is not validated by the server", "서버가 인증하지 않은 게임", "_t")
t("Validation: ", "인증: ", "_t")
t("Go to online profile", "온라인 프로필 가기", "_t")
t("Go to online charsheet", "온라인 캐릭터 시트 가기", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"

t("Video Options", "비디오 설정", "_t")
t("Display resolution.", "화면 해상도.", "_t")
t("#GOLD##{bold}#Resolution#WHITE##{normal}#", "#GOLD##{bold}#해상도#WHITE##{normal}#", "_t")
t("If you have a very high DPI screen you may want to raise this value. Requires a restart to take effect.#WHITE#", "DPI가 높은 모니터를 사용하신다면 이 수치를 올리는 게 좋습니다. 적용에는 재시작이 필요합니다.#WHITE#", "_t")
t("#GOLD##{bold}#Screen Zoom#WHITE##{normal}#", "#GOLD##{bold}#화면 확대/축소#WHITE##{normal}#", "_t")
t("Enter Zoom %", "비율 입력 %", "_t")
t("From 50 to 400", "50부터 400까지", "_t")
t([[Request this display refresh rate.
Set it lower to reduce CPU load, higher to increase interface responsiveness.#WHITE#]], [[화면 재생률을 조정합니다.
값을 낮추면 CPU 부하가 적어지고, 높이면 인터페이스 반응성이 증가합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#Requested FPS#WHITE##{normal}#", "#GOLD##{bold}#FPS 조정#WHITE##{normal}#", "_t")
t("From 5 to 60", "5부터 60까지", "_t")
t([[Controls the particle effects density.
This option allows to change the density of the many particle effects in the game.
If the game is slow when displaying spell effects try to lower this setting.#WHITE#]], [[입자 효과의 밀도를 조정합니다.
게임 내에서 많은 입자가 사용되는 효과의 밀도를 조절할 수 있습니다.
주문의 시각적 효과가 느리게 출력된다면 이 설정값을 낮춰 보십시오.#WHITE#]], "_t")
t("#GOLD##{bold}#Particle effects density#WHITE##{normal}#", "#GOLD##{bold}#입자 효과 밀도#WHITE##{normal}#", "_t")
t("Enter density", "밀도 입력", "_t")
t("From 0 to 100", "0부터 100까지", "_t")
t([[Activates antialiased texts.
Texts will look nicer but it can be slower on some computers.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[글자 출력 시 계단 현상을 방지합니다.
글자가 깔끔하게 표시되지만, 일부 컴퓨터에서는 게임이 느려질 수도 있습니다.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#Antialiased texts#WHITE##{normal}#", "#GOLD##{bold}#텍스트 안티 앨리어싱#WHITE##{normal}#", "_t")
t([[Apply a global scaling to all fonts.
Applies after restarting the game]], [[모든 글자의 크기 배율을 설정합니다.
게임 재시작 후 적용됩니다.]], "_t")
t("#GOLD##{bold}#Font Scale#WHITE##{normal}#", "#GOLD##{bold}#글자 크기#WHITE##{normal}#", "_t")
t("Font Scale %", "글자 크기 %", "_t")
t([[Activates framebuffers.
This option allows for some special graphical effects.
If you encounter weird graphical glitches try to disable it.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[프레임 버퍼 기능을 활성화합니다.
이 기능은 특수한 시각적 효과를 활성화합니다.
만약 시각적 효과에 문제가 발생했다면, 이 기능을 비활성화해보세요.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#Framebuffers#WHITE##{normal}#", "#GOLD##{bold}#프레임 버퍼#WHITE##{normal}#", "_t")
t([[Activates OpenGL Shaders.
This option allows for some special graphical effects.
If you encounter weird graphical glitches try to disable it.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[OpenGL 셰이더를 활성화합니다.
이 기능은 특수한 시각적 효과를 활성화합니다.
만약 시각적 효과에 문제가 발생했다면, 이 기능을 비활성화해보세요.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 셰이더#WHITE##{normal}#", "_t")
t([[Activates advanced shaders.
This option allows for advanced effects (like water surfaces, ...). Disabling it can improve performance.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[고급 OpenGL 셰이더를 활성화합니다.
이 옵션은 수면 묘사같은 향상된 시각적 효과를 활성화합니다. 이 기능을 끄면 게임 성능이 향상될 수 있습니다.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Advanced#WHITE##{normal}#", "#GOLD##{bold}#고급 OpenGL 셰이더#WHITE##{normal}#", "_t")
t([[Activates distorting shaders.
This option allows for distortion effects (like spell effects doing a visual distortion, ...). Disabling it can improve performance.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[왜곡 효과를 활성화합니다.
이 기능은 주문의 시각적 효과에 쓰이는 화면 왜곡 효과를 활성화합니다. 이 기능을 끄면 게임 성능이 향상될 수 있습니다.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Distortions#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 셰이더: 왜곡#WHITE##{normal}#", "_t")
t([[Activates volumetric shaders.
This option allows for volumetricion effects (like deep starfields). Enabling it will severely reduce performance when shaders are displayed.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[입체 셰이더를 활성화합니다.
이 기능은 밤하늘 등에 쓰이는 입체 효과를 활성화합니다. 이 기능을 켜면 그림자가 표시될 때 게임 성능이 저하될 수 있습니다.

#LIGHT_RED#효과를 적용하려면 반드시 게임을 재시작해야 합니다.#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Volumetric#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 셰이더: 입체#WHITE##{normal}#", "_t")
t([[Use the custom cursor.
Disabling it will use your normal operating system cursor.#WHITE#]], [[게임 내의 마우스 커서를 사용합니다.
이 기능을 끄면 게임 내 커서 대신 기본 마우스 커서를 사용할 수 있습니다.#WHITE#]], "_t")
t("#GOLD##{bold}#Mouse cursor#WHITE##{normal}#", "#GOLD##{bold}#마우스 커서#WHITE##{normal}#", "_t")
t([[Gamma correction setting.
Increase this to get a brighter display.#WHITE#]], [[감마 수치를 조절합니다.
이 수치를 높이면 화면이 밝아집니다.#WHITE#]], "_t")
t("#GOLD##{bold}#Gamma correction#WHITE##{normal}#", "#GOLD##{bold}#감마 조절#WHITE##{normal}#", "_t")
t("From 50 to 300", "50부터 300까지", "_t")
t("Gamma correction", "감마 조절", "_t")
t([[Enable/disable usage of tilesets.
In some rare cases on very slow machines with bad GPUs/drivers it can be detrimental.]], [[타일셋 사용 유무를 변경합니다.
성능이 좋지않거나 드라이버에 문제가 있는 일부 컴퓨터에서 문제가 발생할 수도 있습니다.]], "_t")
t("#GOLD##{bold}#Use tilesets#WHITE##{normal}#", "#GOLD##{bold}#타일셋 사용#WHITE##{normal}#", "_t")
t("disabled", "끄기", "_t")
t("enabled", "켜기", "_t")
t([[Request a specific origin point for the game window.
This point corresponds to where the upper left corner of the window will be located.
Useful when dealing with multiple monitors and borderless windows.

The default origin is (0,0).

Note: This value will automatically revert after ten seconds if not confirmed by the user.#WHITE#]], [[게임 창의 기준점을 설정합니다.
이 지점은 윈도우가 위치한 좌상단 부분과 일치합니다.
여러 개의 모니터를 사용하거나, 경계없는 창을 사용할 때 유용합니다.

기본값은 (0,0)입니다.

노트: 사용자가 10초 내로 결과값을 확정짓지 않으면 이전 값으로 되돌아갑니다..#WHITE#]], "_t")
t("#GOLD##{bold}#Requested Window Position#WHITE##{normal}#", "#GOLD##{bold}#창 위치 설정#WHITE##{normal}#", "_t")
t("Enter the x-coordinate", "x값을 입력", "_t")
t("Window Origin: X-Coordinate", "창 기준점: X값", "_t")
t("Enter the y-coordinate", "y값을 입력", "_t")
t("Window Origin: Y-Coordinate", "창 기준점: Y값", "_t")
t("Position changed.", "위치 변경됨", "_t")
t("Save position?", "위치를 저장하시겠습니까?", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ViewHighScores.lua"

t("High Scores", "최고 점수", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/MTXMain.lua"

t("%s #GOLD#Purchasables#LAST#", "%s #GOLD#구매 가능#LAST#", "tformat")
t("Online Store", "온라인 상점", "_t")
t([[Welcome!

I am #{italic}##ANTIQUE_WHITE#DarkGod#LAST##{normal}#, the creator of the game and before you go on your merry way I wish to take a few seconds of your time to explain why there are microtransactions in the game.

Before you run off in terror let me put it plainly: I am very #{bold}#firmly #CRIMSON#against#LAST# pay2win#{normal}# things so rest assured I will not add this kind of stuff.

So why put microtransactions? Tales of Maj'Eyal is a cheap/free game and has no subscription required to play. It is my baby and I love it; I plan to work on it for many years to come (as I do since 2009!) but for it to be viable I must ensure a steady stream of income as this is sadly the state of the world we live in.

As for what kind of purchases are/will be available:
- #GOLD#Cosmetics#LAST#: in addition to the existing racial cosmetics & item shimmers available in the game you can get new packs of purely cosmetic items & skins to look even more dapper!
- #GOLD#Pay2DIE#LAST#: Tired of your character? End it with style!
- #GOLD#Vault space#LAST#: For those that donated they can turn all those "useless" donations into even more online vault slots.
- #GOLD#Community events#LAST#: A few online events are automatically and randomly triggered by the server. With those options you can force one of them to trigger; bonus point they trigger for the whole server so everybody online benefits from them each time!

I hope I've convinced you of my non-evil intentions (ironic for a DarkGod I know ;)). I must say feel dirty doing microtransactions even as benign as those but I want to find all the ways I can to ensure the game's future.
Thanks, and have fun!]], [[어서 와요!

전 게임 제작자인 #{italic}##ANTIQUE_WHITE#DarkGod#LAST##{normal}#입니다. 게임이 즐기기 전에 잠깐 당신에게 이 게임에 왜 소액 결제 항목이 있는지 설명할게요.

당신이 겁 먹어서 도망치기 전에 분명히 말해 둘게요: 난 정말 #{bold}#완전 #CRIMSON#싫어해요.#LAST# pay2win#{normal}# 같은 것을요. 그러니 그런 건 이 게임에 없을 거라고 단언할게요.

그런데 왜 소액 결제가 있을까요? Tales of Maj'Eyal은 싼/무료 게임이고 게임 플레이에 어떤 비용도 들지 않아요. 이 게임은 제 아이와 같고 전 이 아이를 사랑하죠. 앞으로도 많은 시간을 이 게임에 쏟겠지만(2009년부터 그랬던 것처럼요!) 그것을 실현하기 위해 나는 꾸준한 수입이 있어야 해요. 우리는 슬프게도 현실에 살고 있기 때문이죠.

결제를 통해 무엇이 가능한지 설명할게요
- #GOLD#미용#LAST#: 이미 게임에 있는 종족별 설정이나 아이템에 더해서 새롭게 추가되는 순수한 미용 아이템이나 스킨을 사용해 당신의 캐릭터를 더 멋지게 만들 수 있어요!
- #GOLD#Pay2DIE#LAST#: 당신의 캐릭터에 질리셨나요? 이 기능으로 죽이세요!
- #GOLD#금고 공간#LAST#: 기부하신 분들을 위하여, 그분들은 지금까지 해 온 모든 "무의미한" 기부를 통해서 온라인에 있는 금고칸을 더 확장시킬 수 있어요.
- #GOLD#커뮤니티 이벤트#LAST#: 서버가 어느 정도 있는 온라인 이벤트를 자동적이거나 랜덤하게 작동시킵니다. 이 기능을 사용하신다면 서버가 이벤트 중 하나를 열게 만드실 수도 있어요; 그러실 분이 전체 서버에 대해서 이벤트를 열게 된다면 온라인을 통해 게임을 즐기는 모두가 실시간으로 혜택을 누릴 수 있게 될 거에요!

저의 사악하지 않은 의도를 충분히 이해하셨기를 빕니다 (아이러니하게도 저는 DarkGod이지만요 ;)). 비록 점잖은 수준이긴 합니다만, 소액 결제를 도입하는 것을 제 자신도 역겹다고 느끼고 있습니다. 그러나 이 게임의 미래를 보장할 방법을, 저는 찾아야 합니다.
고맙습니다, 그리고 재밌게 즐겨주시기 바랍니다!]], "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/ShowPurchasable.lua"

t("#{italic}##UMBER#Bonus vault slots from this order: #ROYAL_BLUE#%d#{normal}#", "#{italic}##UMBER#다음 구매에 의한 보너스 금고 공간: #ROYAL_BLUE#%d#{normal}#", "_t")
t([[For every purchase of #{italic}##GREY#%s#LAST##{normal}# you gain a permanent additional vault slot.
#GOLD##{italic}#Because why not!#{normal}#]], [[#{italic}##GREY#%s#LAST##{normal}# 구매할 때마다 금고 공간이 영구적으로 하나 증가합니다.
#GOLD##{italic}#마땅히 그래야 하겠죠!#{normal}#]], "_t", nil, {"를"})
t("#{italic}##UMBER#Voratun Coins available from your donations: #ROYAL_BLUE#%d#{normal}#", "#{italic}##UMBER#다음 기부에 의한 보라툰 코인 획득: #ROYAL_BLUE#%d#{normal}#", "_t")
t([[For every donations you've ever made you have earned voratun coins. These can be spent purchasing expansions or options on the online store. This is the amount you have left, if your purchase total is below this number you'll instantly get your purchase validated, if not you'll need to donate some more first.
#GOLD##{italic}#Thanks for your support, every little bit helps the game survive for years on!#{normal}#]], [[기부한 내역에 따라서 보라툰 코인을 얻습니다. 온라인 스토어에서 DLC나 추가 상품을 구매할 때 사용할 수 있습니다. 이 수치는 현재 소유한 코인의 개수입니다. 구입할 때 소모 합계가 이 수치보다 낮은 경우, 구매가 확정됩니다. 부족할 때는 추가로 기부해 주세요.
#GOLD##{italic}#도와주셔서 감사합니다. 덕분에 게임이 계속해서 개발될 겁니다!#{normal}#]], "_t")
t("%s #GOLD#Online Store#LAST#", "%s #GOLD#온라인 상점#LAST#", "tformat")
t("#YELLOW#-- connecting to server... --", "#YELLOW#-- 서버에 접속 중... --", "_t")
t("Name", "이름", "_t")
t("Price", "가격", "_t")
t("Qty", "구매량", "_t")
t("You need to be logged in before using the store. Please go back to the main menu and login.", "상점을 이용하시려면 로그인하셔야 합니다. 메인 메뉴로 돌아가서 로그인해주시기 바랍니다.", "_t")
t("Steam users need to link their profiles to their steam account. This is very easy in just a few clicks. Once this is done, simply restart the game.", "스팀 유저는 프로필을 스팀 계정과 연동하셔야 합니다. 클릭 몇 번으로 끝나는 쉬운 절차입니다. 연동하셨다면 게임을 재시작해 주시기 바랍니다.", "_t")
t("Let's do it! (Opens in your browser)", "연동하기 (인터넷 브라우저로 열림)", "_t")
t("The Online Store (and expansions) are only purchasable by players that bought the game. Plaese go have a look at the donation page for more explanations.", "온라인 상점(그리고 확장팩)은 이 게임을 구입하신 분만 이용하실 수 있습니다. 자세한 설명을 원하신다면 기부 페이지를 확인해 주세요.", "_t")
t("%d coins", "코인 %d", "tformat")
t("#{bold}#TOTAL#{normal}#", "#{bold}#총합#{normal}#", "_t")
t("  (%d items in cart, %s)", "  (%d 아이템이 장바구니에 들어갔습니다. %s)", "tformat")
t("Cart", "장바구니", "_t")
t("Cart is empty!", "장바구니가 비었습니다!", "_t")
t([[In-game browser is inoperant or disabled, impossible to auto-install shimmer pack.
Please go to https://te4.org/ to download it manually.]], [[게임 브라우저가 작동되지 않거나 유효하지 않기 때문에, 광원팩을 자동 설치할 수 없었습니다.
다음 주소로 들어가서 직접 다운로드해주세요. https://te4.org/ ]], "_t")
t("Shimmer pack installed!", "광원팩을 설치했습니다!", "_t")
t([[Could not dynamically link addon to current character, maybe the installation weng wrong.
You can fix that by manually downloading the shimmer addon from https://te4.org/ and placing it in game/addons/ folder.]], [[현재 캐릭터에 애드온을 적용할 수 없습니다. 잘못 설치된 것 같습니다.
다음 주소에서 광원팩을 직접 다운로드함으로써 이를 해결하실 수 있습니다.  https://te4.org/ 그리고 다운로드한 파일을 다음 경로에 배치해 주세요 game/addons/ folder.]], "_t")
t("Downloading cosmetic pack: #LIGHT_GREEN#%s", "다음 미용팩을 다운로드: #LIGHT_GREEN#%s", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: The pack should be downloading or even finished by now.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: 이 팩을 다운로드하는 중입니다.", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: You can now trigger it whenever you are ready.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: 이용 감사합니다.", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: Your available vault space has increased.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: 사용할 수 있는 금고 공간이 증가했습니다.", "tformat")
t([[Payment accepted.
%s]], [[결제가 완료되었습니다.
%s]], "tformat")
t("Steam Overlay should appear, if it does not please make sure it you have not disabled it.", "스팀 오버레이가 나타납니다. 나타나지 않는다면, 그 기능을 끄지 않았는지 확인해 주시기 바랍니다.", "_t")
t("Connecting to Steam", "스팀에 접속 중", "_t")
t("Finalizing transaction with Steam servers...", "스팀 서버를 통해 구매를 확정 중입니다...", "_t")
t("Connecting to server", "서버에 접속 중", "_t")
t("Please wait...", "기다려 주세요...", "_t")
t("You have enough coins to instantly purchase those options. Confirm?", "이 기능을 구매할 수 있는 코인을 보유하고 있습니다. 구매하시겠습니까?", "_t")
t("Cancel", "취소", "_t")
t("Purchase", "구매", "_t")
t("You need %s more coins to purchase those options. Do you want to go to the donation page now?", "구매에는 %s 코인이 더 필요합니다. 기부 페이지로 이동하시겠습니까?", "tformat")
t("Let's go! (Opens in your browser)", "이동! (브라우저에서 열림)", "_t")
t("Not now", "나중에", "_t")
t("Payment", "구매", "_t")
t("Payment refused, you have not been billed.", "구매에 실패했습니다. 결제되지 않았습니다.", "_t")
t([[#{bold}##GOLD#Community Online Event#WHITE##{normal}#: Once you have purchased a community event you will be able to trigger it at any later date, on whichever character you choose.
Community events once triggered will activate for #{bold}#every player currently logged on#{normal}# including yourself. Every player receiving it will know you sent it and thus that you are to thank for it.
To activate it you will need to have your online events option set to "all" (which is the default value).]], [[#{bold}##GOLD#커뮤니티 온라인 이벤트#WHITE##{normal}#: 커뮤니티 이벤트 구매 후, 원하시는 때, 원하는 캐릭터로 이벤트를 발생시킬 수 있습니다.
한 번 발생한 커뮤니티 이벤트는 당신을 포함하여, #{bold}#현재 로그인 중인 모든 플레이어에게#{normal}# 적용됩니다. 모든 플레이어는 당신이 이 이벤트를 발생시킨 것을 알게 될 것이고 당신에게 감사할 것입니다.
이 기능을 발동하기 위해서는 온라인 이벤트 값을 "전부" (기본값입니다)로 둬야 합니다.]], "_t")
t([[#{bold}##GOLD#Event#WHITE##{normal}#: Once you have purchased an event you will be able to trigger it at any later date, on whichever character you choose.
To activate it you will need to have your online events option set to "all" (which is the default value).]], [[#{bold}##GOLD#이벤트#WHITE##{normal}#: 이벤트 구매 후, 원하시는 때, 원하는 캐릭터로 이벤트를 발생시킬 수 있습니다.
이 기능을 발동하기 위해서는 온라인 이벤트 값을 "전부" (기본값입니다)로 둬야 합니다.]], "_t")
t("#{bold}##GOLD#Non Immediate#WHITE##{normal}#: This events adds new content that you have to find by exploration. If you die before finding it, there can be no refunds.", "#{bold}##GOLD#비즉시요소#WHITE##{normal}#: 이 이벤트는 당신이 탐험에서 찾을 수 있는 새로운 컨텐츠를 추가합니다. 만약 당신이 이를 찾기 전에 죽는다면 무용지물이 됩니다.", "_t")
t("#{bold}##GOLD#Once per Character#WHITE##{normal}#: This event can only be received #{bold}#once per character#{normal}#. Usualy because it adds a new zone or effect to the game that would not make sense to duplicate.", "#{bold}##GOLD#한 캐릭터 한정#WHITE##{normal}#: 이 이벤트는 한 캐릭터가 #{bold}#한 번만#{normal}# 받을 수 있습니다. 왜냐하면 대체로 새로운 지역이나 효과를 추가하기 때문에 두 번 적용받는 의미가 없기 때문입니다.", "_t")
t([[#{bold}##GOLD#Shimmer Pack#WHITE##{normal}#: Once purchased the game will automatically install the shimmer pack to your game and enable it for your current character too (you will still need to use the Mirror of Reflection to switch them on).
#LIGHT_GREEN#Bonus perk:#LAST# purchasing any shimmer pack will also give your characters a portable Mirror of Reflection to be able to change your appearance anywhere, anytime!]], [[#{bold}##GOLD#광원팩#WHITE##{normal}#: 구매 후에 자동으로 게임에 적용됩니다. 지금 모험하고 있는 캐릭터에게도 적용됩니다. (물론 반영의 거울을 켜야 적용됩니다.)
#LIGHT_GREEN#추가 기능:#LAST# 광원팩을 구입하시면 당신의 캐릭터는 휴대할 수 있는 반영의 거울을 받게 됩니다. 반영의 거울을 통해 언제 어디서든 당신의 모습을 바꿀 수 있습니다.]], "_t")
t("#{bold}##GOLD#Vault Space#WHITE##{normal}#: Once purchased your vault space is permanently increased.", "#{bold}##GOLD#금고 공간#WHITE##{normal}#: 구매하시면 금고 공간이 영구적으로 늘어납니다.", "_t")
t("Online Store", "온라인 상점", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/UsePurchased.lua"

t("%s #GOLD#Purchased Options#LAST#", "%s #GOLD#구매창#LAST#", "tformat")
t("#YELLOW#-- connecting to server... --", "#YELLOW#-- 서버에 접속 중... --", "_t")
t("Name", "이름", "_t")
t("Available", "사용가능", "_t")
t("Please use purchased options when not on the worldmap.", "구매창은 세계 지도가 아닌 곳에서만 이용해 주세요.", "_t")
t("This option may only be used once per character to prevent wasting it.", "이 항목들은 무의미한 구매를 막기 위해 캐릭터 하나 당 한 번만 구매할 수 있습니다.", "_t")
t([[This option requires you to accept to receive events from the server.
Either you have the option currently disabled or you are playing a campaign that can not support these kind of events (mainly the Arena).
Make sure you have #GOLD##{bold}#Allow online events#WHITE##{normal}# in the #GOLD##{bold}#Online#WHITE##{normal}# section of the game options set to "all". You can set it back to your own setting once you have received the event.
]], [[이 기능을 사용하기 위해서는 서버로부터 이벤트를 전달받는 기능이 켜져 있어야 합니다.
그 기능을 끄셨거나 이벤트를 적용할 수 없는 아레나 같은 캠페인을 사용 중인지 확인해 주세요.
게임 내의 #GOLD##{bold}#온라인 이벤트에 대해#WHITE##{normal}# 게임의 #GOLD##{bold}#온라인#WHITE##{normal}# 설정에서 그 설정값이 "전부"로 지정되었는지 확인하세요. 이벤트를 받았다면 다시 자신이 원하는 설정으로 되돌리셔도 됩니다.
]], "_t")
t("This pack is already installed and in use for your character.", "이 팩은 이미 설치되었고 당신의 캐릭터에게 적용되었습니다.", "_t")
t("You are about to use a charge of this option. You currently have %d charges remaining.", "이 기능을 한 번 사용하시겠습니까. 현재 당신은 %d 번 사용할 수 있습니다.", "tformat")
t("Please wait while contacting the server...", "서버와 연결 중입니다. 잠시 기다려 주십시오...", "_t")
t("The option has been activated.", "기능이 활성됐습니다.", "_t")
t("There was an error from the server: %s", "서버에서 다음 에러가 발생했습니다: %s", "tformat")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨", "_t")
t("#YELLOW#Installable", "#YELLOW#설치 가능", "_t")
t("Online Store", "온라인 상점", "_t")
t("You have not purchased any usable options yet. Would you like to see the store?", "아직 사용할 수 있는 기능을 구매하지 않으셨습니다. 상점으로 가시겠습니까?", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ActorInventory.lua"

t("%s picks up (%s.): %s%s.", "%s (%s) %s%s 주웠다.", "logSeen", nil, {"는",[4]="를"})
t("%s has no room for: %s.", "%s %s 들어갈 공간이 없다.", "logSeen", nil, {"는","가"})
t("There is nothing to pick up here.", "주울 것이 없다.", "logSeen")
t("There is nothing to drop.", "버릴 것이 없다.", "logSeen")
t("%s drops on the floor: %s.", "%s %s 바닥에 버렸다.", "logSeen", nil, {"는","을"})
t("wrong equipment slot", "이 장비를 낄 수 없는 부위", "_t")
t("not enough stat", "능력치가 부족합니다", "_t")
t("missing %s (level %s )", "부족함 %s (레벨 %s )", "tformat")
t("missing %s", "부족함 %s", "tformat")
t("not enough levels", "레벨 부족", "_t")
t("missing dependency", "습득 조건 미달성", "_t")
t("cannot use currently due to an other worn object", "다른 아이템을 장비하고 있기에 현재 사용할 수 없음", "_t")
t("%s is not wearable.", "장비할 수 없다. (%s)", "logSeen")
t("%s can not wear %s.", "%s %s 장비할 수 없다.", "logSeen", nil, {"는","를"})
t("%s wears: %s.", "%s %s 장비했다.", "logSeen", nil, {"는","를"})
t("%s wears (offslot): %s.", "%s %s 예비로 장비했다.", "logSeen", nil, {"는","를"})
t("%s can not wear (%s): %s (%s).", "%s (%s) 장비할 수 없다: %s (%s).", "logSeen", nil, {"는","를"})
t("%s wears (replacing %s): %s.", "%s %s 대신 %s 장비했다.", "logSeen", nil, {"는",[3]="을"})
t("%s can not wear: %s.", "%s %s 장비할 수 없다.", "logSeen", nil, {"는","를"})


------------------------------------------------
section "game/engines/default/engine/interface/ActorLife.lua"

t("#{bold}#%s killed %s!#{normal}#", "#{bold}#%s %s 죽였다!#{normal}#", "logSeen", nil, {"는","를"})
t("something", "무언가", "_t")
t("%s attacks %s.", "%s %s 공격했다.", "logSeen", nil, {"는","를"})


------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"

t("%s is still on cooldown for %d turns.", "%s 사용하려면 %d 턴이 지나야 합니다.", "logPlayer", nil, {"를"})
t("Talent Use Confirmation", "기술 사용 확인", "_t")
t("Use %s?", "%s 사용하시겠습니까?", "tformat", nil, {"를"})
t("Cancel", "취소", "_t")
t("Continue", "계속하기", "_t")
t("unknown", "알 수 없음", "_t")
t("activates", "활성화했다", "_t")
t("deactivates", "비활성화했다", "_t")
t("%s uses %s.", "%s %s 사용했다.", "logSeen", nil, {"는","를"})
t("not enough stat: %s", "능력치 부족: %s", "tformat")
t("not enough levels", "레벨 부족", "_t")
t("missing dependency", "습득 조건 미달성", "_t")
t("is not %s", "%s 아니다", "tformat", nil, {"가"})
t("unknown talent type", "알 수 없는 기술 타입", "_t")
t("not enough talents of this type known", "이 타입을 습득할 기술이 부족함", "_t")
t("- Talent category known", "- 기술 종류 습득", "_t")
t("- Lower talents of the same category: %d", "- 같은 타입의 기술 수준 부족: %d", "tformat")
t("- Level %d", "- 레벨 %d", "tformat")
t("- Talent %s (not known)", "- 기술 (미습득) %s", "tformat")
t("- Talent %s (%d)", "- 기술 %s (%d)", "tformat")
t("- Talent %s", "- 기술 %s", "tformat")
t("- Is %s", "- %s", "tformat")


------------------------------------------------
section "game/engines/default/engine/interface/GameTargeting.lua"

t("Tactical display disabled. Press shift+'t' to enable.", "전술 시야 비활성. shift+'t'로 활성화", "_t")
t("Are you sure you want to target yourself?", "정말 스스로를 대상으로 하겠습니까?", "_t")
t("No", "아니요", "_t")
t("Target yourself?", "스스로를 대상으로 합니까?", "_t")
t("Yes", "네", "_t")
t("Tactical display enabled. Press shift+'t' to disable.", "전술 시야 활성. shift+'t'로 비활성화.", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ObjectActivable.lua"

t("It can be used to %s, with %d charges out of %d.", "%s 사용할 수 있습니다. %d 중에서 %d 번 남았습니다.", "tformat", {1,3,2}, {"를"})
t("It can be used to %s, costing %d power out of %d/%d.", "%s 사용할 수 있습니다. %d/%d 중에서 %d 번 소모합니다.", "tformat", {1,3,4,2}, {"를"})
t("It can be used to activate talent: %s (level %d).", "기술: %s (레벨 %d)을 사용할 수 있습니다.", "tformat")
t("It can be used to activate talent: %s (level %d), costing %d power out of %d/%d.", "기술: %s (레벨 %d)을 발동할 수 있습니다. %d/%d 중에서 %d 번 소모합니다.", "tformat", {1,2,4,5,3})
t("%s is still recharging.", "%s 재충전 중입니다.", "logPlayer", nil, {"는"})
t("%s can not be used anymore.", "%s 더 이상 사용할 수 없습니다.", "logPlayer", nil, {"는"})


------------------------------------------------
section "game/engines/default/engine/interface/PlayerExplore.lua"

t("Running...", "움직이는 중...", "_t")
t("You are exploring, press any key to stop.", "탐험 중입니다. 멈추시려면 아무 키나 누르세요.", "_t")
t("the path is blocked", "이 길은 막혔습니다", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerHotkeys.lua"

t("Hotkey not defined", "단축키가 지정되지 않았습니다", "_t")
t("You may define a hotkey by pressing 'm' and following the instructions there.", "'m'을 누르고 잇따른 설명을 따르시면 단축키를 지정하실 수 있습니다.", "_t")
t("Item not found", "아이템 없음", "_t")
t("You do not have any %s .", "%s 가지고 있지 않습니다.", "tformat", nil, {"를"})


------------------------------------------------
section "game/engines/default/engine/interface/PlayerMouse.lua"

t("[CHEAT] teleport to %dx%d", "[치트]다음 장소로 텔레포트함: %dx%d", "log")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerRest.lua"

t("resting", "휴식", "_t")
t("rested", "휴식함", "_t")
t("You are %s, press Enter to stop.", "%s 중입니다. Enter키로 종료합니다.", "tformat")
t("%s starts...", "%s 시작...", "log")
t("%s for %d turns (stop reason: %s).", "%d 턴 동안 %s (종료 원인: %s).", "log", {2,1,3})
t("%s for %d turns.", "%d 턴 동안 %s", "log", {2,1})


------------------------------------------------
section "game/engines/default/engine/interface/PlayerRun.lua"

t("You are running, press Enter to stop.", "움직이는 중입니다. 멈추시려면 Enter키를 누르세요.", "_t")
t("You don't see how to get there...", "그 장소로 갈 방법을 찾지 못했습니다...", "logPlayer")
t("Running...", "움직이는 중...", "_t")
t("You are running, press any key to stop.", "움직이는 중입니다. 멈추시려면 아무 키나 누르세요.", "_t")
t("didn't move", "이동하지 못했습니다.", "_t")
t("trap spotted", "함정 발견", "_t")
t("terrain change on the left", "왼쪽부터는 다른 장소", "_t")
t("terrain change on the right", "오른쪽부터는 다른 장소", "_t")
t("at %s", "%s에 도착", "tformat")
t("Ran for %d turns (stop reason: %s).", "%d 턴 동안 달렸다. (멈춘 이유: %s)", "log")


------------------------------------------------
section "game/engines/default/engine/interface/WorldAchievements.lua"

t("#%s#Personal New Achievement: %s!", "#%s#새로운 개인 업적: %s!", "log")
t("Personal New Achievement: #%s#%s", "새로운 개인 업적: #%s#%s", "tformat")
t("#%s#New Achievement: %s!", "#%s#새로운 업적: %s!", "log")
t("New Achievement: #%s#%s", "새로운 업적: #%s#%s", "tformat")
t("New Achievement", "새로운 업적", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Dialog.lua"

t("Close", "닫기", "_t")
t("Yes", "네", "_t")
t("No", "아니요", "_t")
t("Cancel", "취소", "_t")
t("Copy URL", "URL 복사", "_t")
t("URL copied to your clipboard.", "URL이 클립보드에 복사되었습니다.", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Gestures.lua"

t("Mouse Gestures", "마우스 제스쳐", "_t")
t([[You have started to draw a mouse gesture for the first time!
Gestures allow you to use talents or keyboard action by a simple movement of the mouse. To draw one you simply #{bold}#hold right click + move#{normal}#.
By default no bindings are done for gesture so if you want to use them go to the Keybinds and add some, it's easy and fun!

Gestures movements are color coded to better display which movement to do:
#15ed2f##{italic}#green#{normal}##LAST#: moving up
#1576ed##{italic}#blue#{normal}##LAST#: moving down
#ed1515##{italic}#red#{normal}##LAST#: moving left
#d6ed15##{italic}#yellow#{normal}##LAST#: moving right

If you do not wish to see gestures anymore, you can hide them in the UI section of the Game Options.
]], [[처음으로 마우스 제스쳐를 입력하셨습니다!
간단한 동작으로 수행되는 제스쳐를 통해 기술이나 키보드 조작을 할 수 있습니다. 하나 예시를 들자면 #{bold}#우클릭 유지 + 드래그#{normal}# 등 이런 단순한 동작도 가능하죠.
기본적으로는 어떤 동작도 등록되지 않았습니다. 그러니 사용하고 싶으시다면 키 설정에 들어가 원하는 동작을 추가해 주시면 됩니다!

제스쳐 동작을 알아 보기 쉽게, 동선에 다음 색깔을 표시할 수 있습니다:
#15ed2f##{italic}#녹색#{normal}##LAST#: 위쪽 이동
#1576ed##{italic}#파랑#{normal}##LAST#: 아래쪽 이동
#ed1515##{italic}#빨강#{normal}##LAST#: 왼쪽 이동
#d6ed15##{italic}#노랑#{normal}##LAST#: 오른쪽 이동

제스쳐를 더 이상 보기 싫으시다면, 게임 설정의 UI 설정에서 제스쳐를 숨길 수 있습니다.
]], "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"

t("Inventory", "소지품", "_t")
t("Category", "분류", "_t")
t("Enc.", "기타", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/WebView.lua"

t("Download: ", "다운로드: ", "tformat")
t("Cancel", "취소", "_t")
t("Are you sure you want to install this addon: #LIGHT_GREEN##{bold}#%s#{normal}##LAST# ?", "다음 애드온을 설치하시겠습니까?: #LIGHT_GREEN##{bold}#%s#{normal}##LAST# ", "_t")
t("Confirm addon install/update", "애드온 설치/업데이트", "_t")
t("Are you sure you want to install this module: #LIGHT_GREEN##{bold}#%s#{normal}##LAST#?", "다음 모듈을 설치하시겠습니까?: #LIGHT_GREEN##{bold}#%s#{normal}##LAST#", "tformat")
t("Confirm module install/update", "모듈 설치/업데이트", "_t")
t("Addon installation successful. New addons are only active for new characters.", "애드온이 설치됐습니다. 새로운 애드온은 새 캐릭터부터 적용됩니다.", "_t")
t("Addon installed!", "애드온 설치됨!", "_t")
t("Game installation successful. Have fun!", "게임 설치 완료. 좋은 시간 보내시길!", "_t")
t("Game installed!", "게임 설치됨!", "_t")


------------------------------------------------
section "game/engines/default/engine/utils.lua"

t("his", "그", "_t")
t("her", "그녀", "_t")
t("him", "그", "_t")
t("herself", "자기 자신", "_t")
t("himself", "자기 자신", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/class/Game.lua"

t("Welcome to T-Engine and the Tales of Maj'Eyal", "T-Engine과 Tales of Maj'Eyal에 오신 것을 환열합니다", "_t")
t([[#GOLD#"Tales of Maj'Eyal"#WHITE# is the main game, you can also install more addons or modules by going to https://te4.org/

When inside a module remember you can press Escape to bring up a menu to change keybindings, resolution and other module specific options.

Remember that in most roguelikes death is usually permanent so be careful!

Now go and have some fun!]], [[#GOLD#"Tales of Maj'Eyal"#WHITE#은 메인 게임입니다. 다른 애드온이나 모듈을 다음 주소에서 설치하실 수 있습니다. https://te4.org/

모듈에서는 ESC키를 눌러 키 설정이나 해상도 설정 등 다양한 설정을 변경할 수 있습니다.

로그라이크 게임에서 한 번의 죽음은 되돌릴 수 없으니 조심하세요!

그러면 게임을 즐겨주시기 바랍니다!]], "_t")
t([[The way the engine manages saving has been reworked for v1.0.5.

The background saves should no longer lag horribly and as such it is highly recommended that you use the option. The upgrade turned it on for you.

For the same reason the save per level option should not be used unless you have severe memory problems. The upgrade turned it off for you.
]], [[엔진 버전 v1.0.5부터 세이브 방식이 변경됐습니다.

자동 세이브는 더 이상 심각한 렉을 발생시키지 않으며, 이제 이 옵션을 항상 활성화하시는 것을 매우 추천드립니다. 업데이트 후 자동으로 활성화됩니다.

이런 맥락에서, 층마다 세이브하는 옵션은 비활성화하십시오. 심각한 메모리 문제가 있는 경우에만 사용해 주시기 바랍니다. 업데이트 후 자동으로 비활성화됩니다.
]], "_t")
t("Upgrade to 1.0.5", "1.0.5 업데이트 변경점", "_t")
t([[Oops! Either you activated safe mode manually or the game detected it did not start correctly last time and thus you are in #LIGHT_GREEN#safe mode#WHITE#.
Safe Mode disabled all graphical options and sets a low FPS. It is not advisable to play this way (as it will be very painful and ugly).

Please go to the Video Options and try enabling/disabling options and then restarting until you do not get this message.
A usual problem is shaders and thus should be your first target to disable.]], [[이런! 안전 모드를 수동으로 작동하셨거나 게임이 저번 시도 때 올바르게 가동되지 못해서 #LIGHT_GREEN#안전 모드#WHITE#에 진입하셨습니다.
안전 모드는 모든 그래픽 옵션을 끄고 낮은 FPS를 유지합니다. 이 상태일 때는 게임 플레이를 권장드리지 못합니다. (왜냐하면 정말 고통스럽고 역겹거든요).

비디오 옵션으로 가서 이 메시지가 더 이상 뜨지 않을 때까지, 기능들을 활성화/비활성화한 후 게임을 재시작하는 것을 반복해 보세요.
보통 이런 문제는 셰이더로 인한 일이 잦으니 셰이더 기능들을 먼저 꺼보시는 게 좋겠죠.]], "_t")
t("Safe Mode", "안전 모드", "_t")
t("Message", "메시지", "_t")
t("Duplicate Addon", "중복 애드온", "_t")
t([[Oops! It seems like you have the same addon/dlc installed twice.
This is unsupported and would make many things explode. Please remove one of the copies.

Addon name: #YELLOW#%s#LAST#

Check out the following folder on your computer:
%s
%s
]], [[이런! 같은 애드온이나 DLC를 두 번 설치하신 거 같네요.
그런 기능은 지원하지도 않고 많은 문제를 일으킬 수 있습니다. 중복된 것 중에 하나를 지워 주세요.

애드온 명칭: #YELLOW#%s#LAST#

컴퓨터에서 다음 폴더를 확인해 보세요:
%s
%s
]], "_t")
t("Updating addon: #LIGHT_GREEN#%s", "애드온 업데이트 중: #LIGHT_GREEN#%s", "tformat")
t("Really exit T-Engine/ToME?", "T-Engine/ToME를 끄시겠습니까?", "_t")
t("Continue", "계속하기", "_t")
t("Quit", "출구", "_t")
t([[Welcome to #LIGHT_GREEN#Tales of Maj'Eyal#LAST#!

Before you can start dying in many innovative ways we need to ask you about online play.

This is a #{bold}#single player game#{normal}# but it also features many online features to enhance your gameplay and connect you to the community:
* Play from several computers without having to copy unlocks and achievements.
* Talk ingame to other fellow players, ask for advice, share your most memorable moments...
* Keep track of your kill count, deaths, most played classes...
* Cool statistics for to help sharpen your gameplay style
* Install official expansions and third-party addons directly from the game, hassle-free
* Access your purchaser / donator bonuses if you have bought the game or donated on https://te4.org/
* Help the game developers balance and refine the game

You will also have a user page on #LIGHT_BLUE#https://te4.org/#LAST# to show off to your friends.
This is all optional, you are not forced to use this feature at all, but the developer would thank you if you did as it will make balancing easier.]], [[#LIGHT_GREEN#Tales of Maj'Eyal#LAST#에 오신 것을 환영합니다!

혁신적인 방법으로 셀 수 없이 죽으시기 전에 온라인 플레이에 대해 말씀드릴 게 있어요.

이 게임은 #{bold}#싱글 플레이 게임#{normal}#입니다. 하지만 게임 플레이를 돕고, 관련 커뮤니티를 장려하기 위해 다음처럼 많은 온라인 기능도 가지고 있죠:
* 해금 요소나 업적 복사 없이 여러 컴퓨터에서 플레이
* 인게임에서 조언을 듣거나 추억을 얘기하기 위해 친구 플레이어와 채팅
* 킬, 데스, 많이 플레이한 클래스 등에 대한 수치 기록
* 게임 플레이 스타일 향상을 위한 멋진 통계 기능
* 공식 확장팩이나 서드파티 모드를 인게임에서 인스톨
* 게임을 구매하셨거나, 돈을 기부하셨다면 구매자/기부자 보너스를 다음 주소에서 확인해 보세요: https://te4.org/
* 개발자에게 게임 밸런스 조절이나 개선점에 대해 조언하기

#LIGHT_BLUE#https://te4.org/#LAST# 사이트에서 친구들에게 과시할 수 있는 유저 페이지를 가지고 계십니다.
이 모든 것은 선택적이며, 이 모든 기능을 꼭 이용하셔야 하는 것은 아닙니다만 이 기능들을 사용해 주시면 밸런싱이 쉬워지기 때문에 개발자로서는 사용해 주시면 감사할따름입니다.]], "_t")
t("Login in...", "로그인 중...", "_t")
t("Please wait...", "기다려 주세요...", "_t")
t("Profile logged in!", "프로필 로그인!", "_t")
t("Check your login and password or try again in in a few moments.", "로그인 상태와 패스워드를 다시 확인해 주시고 잠시 후에 다시 시도해 주세요.", "_t")
t("Login failed!", "로그인 실패!", "_t")
t("Registering on https://te4.org/, please wait...", "https://te4.org/에 등록 중, 기다려 주세요...", "_t")
t("Registering...", "등록 중...", "_t")
t("Logged in!", "로그인 성공!", "_t")
t("Profile created!", "프로필 생성됨!", "_t")
t("Your online profile is now active. Have fun!", "온라인 프로필이 활성되었습니다. 즐거운 게임하시길!!", "_t")
t("Creation failed: %s (you may also register on https://te4.org/)", "생성 실패: %s (다음 주소에서도 등록하실 수 있습니다: https://te4.org/)", "tformat")
t("Profile creation failed!", "프로필 생성 실패!", "_t")
t("Try again in in a few moments, or try online at https://te4.org/", "잠시 후 다시 시도해 주시거나 다음 주소에서 생성해 주세요: https://te4.org/", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/class/Player.lua"

t("%s available", "%s 사용 가능", "tformat")
t("#00ff00#Talent %s is ready to use.", "#00ff00#기술 %s 사용하실 수 있습니다.", "log", nil, {"을"})
t("LEVEL UP!", "레벨업!", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/birth/descriptors.lua"

t("base", "베이스", "birth descriptor name")
t("Destroyer", "파괴자", "birth descriptor name")
t("Acid-maniac", "애시드 매니아", "birth descriptor name")


------------------------------------------------
section "game/engines/default/modules/boot/data/damage_types.lua"

t("Kill!", "죽임!", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/basic.lua"

t("door", "문", "entity name")
t("floor", "바닥", "entity subtype")
t("wall", "벽", "entity type")
t("open door", "열린 문", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/forest.lua"

t("wall", "벽", "entity type")
t("tree", "나무", "entity name")
t("floor", "바닥", "entity type")
t("grass", "잔디", "entity subtype")
t("flower", "꽃", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/underground.lua"

t("wall", "벽", "entity type")
t("crystals", "수정", "entity name")
t("underground", "지하", "entity subtype")
t("floor", "바닥", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/water.lua"

t("floor", "바닥", "entity type")
t("water", "물", "entity subtype")
t("deep water", "깊은 물", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/canine.lua"

t("animal", "동물", "entity type")
t("canine", "개과", "entity subtype")
t("wolf", "늑대", "entity name")
t("Lean, mean, and shaggy, it stares at you with hungry eyes.", "비쩍 마르고 털이 텁수룩한 것이 굶주린 눈으로 바라보고 있다.", "_t")
t("white wolf", "흰 늑대", "entity name")
t("A large and muscled wolf from the northern wastes. Its breath is cold and icy and its fur coated in frost.", "북쪽 황무지에서 온 크고 근육질인 늑대. 내뱉는 숨은 서늘하며 털은 서리로 뒤덮여 있다.", "_t")
t("warg", "와르그", "entity name")
t("It is a large wolf with eyes full of cunning.", "교활함으로 가득 찬 눈을 가진 거대한 늑대입니다.", "_t")
t("fox", "여우", "entity name")
t("The quick brown fox jumps over the lazy dog.", "빠른 갈색 여우가 게으른 개를 뛰어 넘는다.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/skeleton.lua"

t("skeleton", "스켈레톤", "entity subtype")
t("undead", "언데드", "entity type")
t("degenerated skeleton warrior", "낡은 스켈레톤 전사", "entity name")
t("skeleton warrior", "스켈레톤 전사", "entity name")
t("skeleton mage", "스켈레톤 마법사", "entity name")
t("armoured skeleton warrior", "무장한 스켈레톤 전사", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/troll.lua"

t("giant", "거인", "entity type")
t("troll", "트롤", "entity subtype")
t("forest troll", "숲 트롤", "entity name")
t("Green-skinned and ugly, this massive humanoid glares at you, clenching wart-covered green fists.", "녹색 피부를 가진 거대하고 못생긴 이족 보행체가 사마귀투성이인 녹색 주먹을 꽉 쥐며 당신을 응시한다.", "_t")
t("stone troll", "돌 트롤", "entity name")
t("A giant troll with scabrous black skin. With a shudder, you notice the belt of dwarf skulls around his massive waist.", "우둘투둘한 검은 거죽을 가진 자이언트 트롤입니다. 당신은 전율하면서 그의 거대한 허리춤에 달린 허리띠가 드워프 해골로 만들어졌다는 것을 알아차립니다.", "_t")
t("cave troll", "동굴 트롤", "entity name")
t("This huge troll wields a massive spear and has a disturbingly intelligent look in its piggy eyes.", "이 거대한 트롤은 거대한 창을 휘두르며, 이상하게도 그 살찐 눈에 총명한 표정을 짓습니다.", "_t")
t("mountain troll", "산 트롤", "entity name")
t("mountain troll thunderer", "산 트롤 번개 부르미", "entity name")
t("A large and athletic troll with an extremely tough and warty hide.", "아주 질기고 사마귀 투성이 거죽을 지닌 크고 건강한 트롤입니다.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/talents.lua"

t("misc", "도구", "talent category")
t("Kick", "발차기", "talent name")
t("Acid Spray", "산성 스프레이", "talent name")
t("Manathrust", "마나 쐐기", "talent name")
t("Flame", "불꽃", "talent name")
t("Fireflash", "불꽃섬광", "talent name")
t("Lightning", "번개", "talent name")
t("Sunshield", "태양 방패", "talent name")
t("Flameshock", "불꽃충격", "talent name")


------------------------------------------------
section "game/engines/default/modules/boot/data/timed_effects.lua"

t("Burning from acid", "산성액으로 인한 화상", "_t")
t("#Target# is covered in acid!", "#Target2# 고통의 부식에 휩쌓였다!", "_t")
t("+Acid", "+산성액", "_t")
t("#Target# is free from the acid.", "#Target2# 고통의 부식에서 벗어났다.", "_t")
t("-Acid", "-산성액", "_t")
t("Sunshield", "태양 방패", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/zones/dungeon/zone.lua"

t("Forest", "숲", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Addons.lua"

t("Configure Addons", "애드온 설정", "_t")
t("You can get new addons at #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "새로운 애드온을 다음 주소에서 받으실 수 있습니다: #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "_t")
t("You can get new addons on #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "새로운 애드온을 다음 장소에서 받으실 수 있습니다: #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "_t")
t(", #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", ", #LIGHT_BLUE##{underline}#Te4.org 애드온#{normal}#", "_t")
t("Show incompatible", "호환되지 않는 버전 보이기", "_t")
t("Auto-update on start", "시작하면 자동 업데이트", "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")
t("Addon", "애드온", "_t")
t("Active", "켜짐", "_t")
t("#GREY#Developer tool", "#GREY#개발자 도구", "_t")
t("#LIGHT_RED#Donator Status: Disabled", "#LIGHT_RED#기부자 상태: 꺼짐", "_t")
t("#LIGHT_GREEN#Manual: Active", "#LIGHT_GREEN#수동 조작: 켜짐", "_t")
t("#LIGHT_RED#Manual: Disabled", "#LIGHT_RED#수동 조작: 꺼짐", "_t")
t("#LIGHT_GREEN#Auto: Active", "#LIGHT_GREEN#자동 조작: 켜짐", "_t")
t("#LIGHT_RED#Auto: Incompatible", "#LIGHT_RED#자동 조작: 호환되지 않음", "_t")
t("Addon Version", "애드온 버전", "_t")
t("Game Version", "게임 버전", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Credits.lua"

t("Project Lead", "프로젝트 리더", "_t")
t("Lead Coder", "코더 리더", "_t")
t("World Builders", "맵 제작자", "_t")
t("Graphic Artists", "그래픽 아티스트", "_t")
t("Expert Shaders Design", "셰이더 디자인", "_t")
t("Soundtracks", "사운드트랙", "_t")
t("Sound Designer", "사운드 엔지니어", "_t")
t("Lore Creation and Writing", "스토리 작가", "_t")
t("Code Helpers", "코드 헬퍼", "_t")
t("Community Managers", "커뮤니티 관리자", "_t")
t("Text Editors", "텍스트 편집", "_t")
t("The Community", "커뮤니티", "_t")
t("Others", "그 밖에 도움을 주신 분들", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/FirstRun.lua"

t("Welcome to Tales of Maj'Eyal", "Tales of Maj'Eyal에 오신 것을 환영합니다", "_t")
t("Register now!", "새로 가입!", "_t")
t("Login existing account", "존재하는 계정에 로그인", "_t")
t("Maybe later", "나중에", "_t")
t("#RED#Disable all online features", "#RED#모든 온라인 기능을 끈다", "_t")
t("Disable all connectivity", "모든 연결을 끊는다", "_t")
t([[You are about to disable all connectivity to the network.
This includes, but is not limited to:
- Player profiles: You will not be able to login, register
- Characters vault: You will not be able to upload any character to the online vault to show your glory
- Item's Vault: You will not be able to access the online item's vault, this includes both storing and retrieving items.
- Ingame chat: The ingame chat requires to connect to the server to talk to other players, this will not be possible.
- Purchaser / Donator benefits: The base game being free, the only way to give donators their bonuses fairly is to check their online profile. This will thus be disabled.
- Easy addons downloading & installation: You will not be able to see ingame the list of available addons, nor to one-click install them. You may still do so manually.
- Version checks: Addons will not be checked for new versions.
- Discord: If you are a Discord user, Rich Presence integration will also be disabled by this setting.
- Ingame game news: The main menu will stop showing you info about new updates to the game.

#{bold}##CRIMSON#This is an extremely restrictive setting. It is recommended you only activate it if you have no other choice as it will remove many fun and acclaimed features.#{normal}#

If you disable this option you can always re-activate it in the Online category of the Game Options menu later on.]], [[네트워크 연결을 끊으시려는 중입니다.
다음과 같은 기능들을 사용할 수 없게 됩니다. 이 밖에도 사용할 수 없는 기능이 있을 수 있습니다.
- 플레이어 프로필: 로그인이나 가입을 할 수 없게 됩니다
- 캐릭터 페이지: 캐릭터의 진행 로그를 업로드할 수 없게 되어 영광의 궤적을 보여줄 수 없게 됩니다
- 아이템 금고: 아이템 금고에 접속할 수 없게 됩니다. 아이템을 꺼낼 수도, 보관할 수도 없게 됩니다
- 인게임 채팅: 인게임 채팅은 다른 사람들과 대화하기 위해 온라인 연결을 필요로 합니다. 고로 할 수 없게 됩니다
- 구매자 / 기부자 혜택: 기본 게임은 무료이기 때문에 기부자나 구매자에게 보너스를 주기 위해서는 온라인 프로필을 확인해야 합니다. 고로 혜택을 받으실 수 없게 됩니다.
- 애드온의 쉬운 다운로드 및 설치: 사용할 수 있는 애드온 리스트를 인게임에서 확인할 수 없게 되며, 한 번의 클릭으로 설치하는 것도 할 수 없게 됩니다. 이 모든 것을 수동으로 하셔야 합니다.
- 버전 체크: 애드온 업데이트를 확인할 수 없게 됩니다.
- Discord: Discord를 사용하고 계신다면 Rich Presence 기능을 사용할 수 없게 됩니다.
- 인게임 뉴스: 메인 메뉴가 새로운 업데이트에 대한 사항을 알려주지 않게 됩니다.

#{bold}##CRIMSON#정말 할 수 있는 게 제한되고, 많은 즐거움과 기능을 제거하기 때문에 다른 방법이 없을 경우에만 추천드립니다.#{normal}#

이 옵션을 끄신다면 언제든 게임 옵션의 온라인 항목에서 재활성화할 수 있습니다.]], "_t")
t("#RED#Disable all!", "#RED#전부 끄기!", "_t")
t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/LoadGame.lua"

t("Load Game", "게임 불러오기", "_t")
t("Show older versions", "이전 버전 보기", "_t")
t("Ignore unloadable addons", "불러올 수 없는 애드온 무시", "_t")
t("  Play!  ", "  플레이!  ", "_t")
t([[#{bold}##GOLD#%s: %s#WHITE##{normal}#
Game version: %d.%d.%d
Requires addons: %s

%s]], [[#{bold}##GOLD#%s: %s#WHITE##{normal}#
게임 버전: %d.%d.%d
애드온 요구사항: %s

%s]], "tformat")
t("You can simply grab an older version of the game from where you downloaded it.", "게임을 다운로드한 곳에서 이전 버전을 가지고 오셔도 됩니다.", "_t")
t("You can downgrade the version by selecting it in the Steam's \"Beta\" properties of the game.", "스팀에서 이 게임의 \"Beta\" 항목을 조작하는 것으로 게임을 다운그레이드할 수 있습니다.", "_t")
t("Original game version not found", "원래 게임 버전을 찾을 수 없습니다", "_t")
t([[This savefile was created with game version %s. You can try loading it with the current version if you wish but it is recommended you play it with the old version to ensure compatibility
%s]], [[이 세이브 파일은 다음 게임 버전에서 작성되었습니다: %s. 현재 버전에서 실행하실 수도 있지만 권장하지는 않으며 가급적이면 이전 버전에서 로드하시는 것을 추천드립니다.
%s]], "tformat")
t("Run with newer version", "최신 버전에서 실행", "_t")
t("#LIGHT_RED#WARNING: #LAST#Loading a savefile while in developer mode will permanently invalidate it. Proceed?", "#LIGHT_RED#경고: #LAST#개발자 모드에서 세이브 파일을 로드하는 것은 이를 영구적으로 망가트릴 수도 있습니다. 계속하시겠습니까?", "_t")
t("Developer Mode", "개발자 모드", "_t")
t("Load anyway", "어쨌든 로드한다", "_t")
t("Delete savefile", "세이브 파일 삭제", "_t")
t("Really delete #{bold}##GOLD#%s#WHITE##{normal}#", "정말로 #{bold}##GOLD#%s#WHITE##{normal}# 삭제하시겠습니까?", "tformat", nil, {"를"})
t("Cancel", "취소", "_t")
t("Delete", "삭제", "_t")
t("No data available for this game version.", "이 게임 버전에서 사용할 수 있는 데이터가 없습니다.", "_t")
t("Downloading old game data: #LIGHT_GREEN#", "구 버전 데이터를 다운로드하는 중: #LIGHT_GREEN#", "_t")
t("Old game data for %s correctly installed. You can now play.", "구 버전 데이터 %s 올바르게 설치되었습니다. 이제 플레이하실 수 있습니다.", "tformat", nil, {"가"})
t("Failed to install.", "설치 실패.", "_t")
t("Old game data", "구 버전 데이터", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/MainMenu.lua"

t("Main Menu", "메인 메뉴", "_t")
t("New Game", "새 게임", "_t")
t("Load Game", "게임 불러오기", "_t")
t("Addons", "애드온", "_t")
t("Options", "설정", "_t")
t("Game Options", "게임 설정", "_t")
t("Credits", "개발진들", "_t")
t("Exit", "나가기", "_t")
t("Reboot", "재시작", "_t")
t("Disable animated background", "움직이는 배경화면 비활성화", "_t")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨", "_t")
t("#YELLOW#Not installed - Click to download / purchase", "#YELLOW#설치되지 않음 - 클릭 시 다운로드 / 구매", "_t")
t("Login", "로그인", "_t")
t("Register", "가입", "_t")
t("Username: ", "유저명: ", "_t")
t("Password: ", "비밀번호: ", "_t")
t("#GOLD#Online Profile", "#GOLD#온라인 프로필", "_t")
t("Login with Steam", "스팀으로 로그인", "_t")
t("#GOLD#Online Profile#WHITE#", "#GOLD#온라인 프로필#WHITE#", "_t")
t("#LIGHT_BLUE##{underline}#Logout", "#LIGHT_BLUE##{underline}#로그아웃", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Password", "비밀번호", "_t")
t("Your password is too short", "비밀번호가 너무 짧습니다.", "_t")
t("Login in your account, please wait...", "로그인 중 입니다. 잠시만 기다려주세요...", "_t")
t("Login...", "로그인 중...", "_t")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/NewGame.lua"

t("New Game", "새 게임", "_t")
t("Show all versions", "모든 버전 보이기", "_t")
t("Show incompatible", "호환되지 않는 버전 보이기", "_t")
t([[You can get new games at
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], [[다음 사이트에서 최신 버전을 다운로드 할 수 있습니다
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")
t("Enter your character's name", "캐릭터 이름을 입력해주세요", "_t")
t("Overwrite character?", "캐릭터를 덮어씌우시겠습니까?", "_t")
t("There is already a character with this name, do you want to overwrite it?", "이미 존재하는 캐릭터 명입니다만, 덮어씌우시겠습니까?", "_t")
t("No", "아니요", "_t")
t("Yes", "네", "_t")
t("This game is not compatible with your version of T-Engine, you can still try it but it might break.", "이 게임은 현재 T-Engint 버전과 호환되지 않으므로, 실행 시 심각한 오류를 발생시킬 수 있습니다.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Profile.lua"

t("Player Profile", "플레이어 프로필", "_t")
t("Logout", "로그아웃", "_t")
t("Do you want to log out?", "정말 로그아웃하시겠습니까?", "_t")
t("You are logged in", "로그인 됨", "_t")
t("Cancel", "취소", "_t")
t("Log out", "로그아웃", "_t")
t("Login", "로그인", "_t")
t("Create Account", "계정 생성", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileLogin.lua"

t("Login", "로그인", "_t")
t("Username: ", "유저명: ", "_t")
t("Password: ", "비밀번호: ", "_t")
t("Cancel", "취소", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Password", "비밀번호", "_t")
t("Your password is too short", "비밀번호가 너무 짧습니다.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileSteamRegister.lua"

t("Username: ", "유저명: ", "_t")
t("Register", "가입", "_t")
t("Cancel", "취소", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Registering on https://te4.org/, please wait...", "https://te4.org/에 등록 중, 기다려 주세요...", "_t")
t("Registering...", "등록 중...", "_t")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.", "_t")
t("Error", "오류", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/UpdateAll.lua"

t("Version", "버전", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ViewHighScores.lua"

t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/init.lua"



------------------------------------------------
section "game/engines/default/modules/boot/load.lua"

t("Strength", "힘", "stat name")
t("str", "힘", "stat short_name")
t("Dexterity", "민첩", "stat name")
t("dex", "민첩", "stat short_name")
t("Constitution", "체격", "stat name")
t("con", "체격", "stat short_name")


