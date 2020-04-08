locale "ko_KR"
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

------------------------------------------------
section "always_merge"

t([[Today is the %s %s of the %s year of the Age of Ascendancy of Maj'Eyal.
The time is %02d:%02d.]], [[오늘은 주도의 시대를 맞은 마즈'에이알 %s 년 %s %s 일 입니다.
현재 시간은 %02d 시 %02d 분입니다.]], nil)


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
t("Talent %s", "기술 %s", "tformat")


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
t("Please wait while saving the level...", "현재 층을 저장 중 입니다...", "_t")
t("Saving level", "현재 층 저장 중", "_t")
t("Please wait while saving the entity...", "엔티티를 저장 중 입니다...", "_t")
t("Saving entity", "엔티티 저장 중", "_t")
t("Loading world", "월드 불러오는 중", "_t")
t("Please wait while loading the world...", "월드를 불러오는 중 입니다...", "_t")
t("Loading game", "게임 불러오는 중", "_t")
t("Please wait while loading the game...", "게임을 불러오는 중 입니다...", "_t")
t("Loading zone", "지역 불러오는 중", "_t")
t("Please wait while loading the zone...", "지역를 불러오는 중 입니다...", "_t")
t("Loading level", "현재 층 불러오는 중", "_t")
t("Please wait while loading the level...", "현재 층을 불러오는 중 입니다...", "_t")
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

다시 한번 감사드리며, 에이얄을 즐겨주세요!!

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

t("Loading level", "현재 층 불러오는 중", "_t")
t("Please wait while loading the level... ", "현재 층을 불러오는 중 입니다... ", "_t")
t("Generating level", "현재 층 생성 중", "_t")
t("Please wait while generating the level... ", "현재 층을 생성 중 입니다... ", "_t")


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
t("Key Bindings", "키 설정", "_t")
t("Video Options", "화면 설정", "_t")
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



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowAchievements.lua"

t("Achievements(%s/%s)", "도전과제(%s/%s)", "tformat")
t("Achievement", "도전과제", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipInven.lua"

t("Inventory", "소지품", "_t")
t("Equipment", "장비", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipment.lua"

t("Equipment", "장비", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowErrorStack.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowInventory.lua"

t("Inventory", "소지품", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowPickupFloor.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowQuests.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowStore.lua"

t("Inventory", "소지품", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowText.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/SteamOptions.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/Talkbox.lua"

t("Accept", "수락", "_t")
t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/UserInfo.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"

t("Video Options", "화면 설정", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ViewHighScores.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/MTXMain.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/ShowPurchasable.lua"

t("Name", "이름", "_t")
t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/UsePurchased.lua"

t("Name", "이름", "_t")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ActorInventory.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorLife.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"

t("Cancel", "취소", "_t")
t("Continue", "계속하기", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/GameTargeting.lua"

t("No", "아니요", "_t")
t("Yes", "네", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ObjectActivable.lua"



------------------------------------------------
section "game/engines/default/engine/interface/PlayerExplore.lua"



------------------------------------------------
section "game/engines/default/engine/interface/PlayerHotkeys.lua"



------------------------------------------------
section "game/engines/default/engine/interface/PlayerMouse.lua"



------------------------------------------------
section "game/engines/default/engine/interface/PlayerRest.lua"



------------------------------------------------
section "game/engines/default/engine/interface/PlayerRun.lua"



------------------------------------------------
section "game/engines/default/engine/interface/WorldAchievements.lua"



------------------------------------------------
section "game/engines/default/engine/ui/Dialog.lua"

t("Yes", "네", "_t")
t("No", "아니요", "_t")
t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Gestures.lua"



------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"

t("Inventory", "소지품", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/WebView.lua"

t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/engine/utils.lua"



------------------------------------------------
section "game/engines/default/modules/boot/class/Game.lua"

t("Continue", "계속하기", "_t")
t("Quit", "출구", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/class/Player.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/birth/descriptors.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/damage_types.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/basic.lua"

t("door", "문", "entity name")
t("floor", "바닥", "entity subtype")
t("wall", "벽", "entity type")
t("open door", "열린 문", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/forest.lua"

t("wall", "벽", "entity type")
t("floor", "바닥", "entity type")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/underground.lua"

t("wall", "벽", "entity type")
t("floor", "바닥", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/water.lua"

t("floor", "바닥", "entity type")
t("water", "물", "entity subtype")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/canine.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/skeleton.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/troll.lua"

t("giant", "거인", "entity type")


------------------------------------------------
section "game/engines/default/modules/boot/data/talents.lua"

t("Flame", "불꽃", "talent name")
t("Fireflash", "불꽃섬광", "talent name")
t("Lightning", "번개", "talent name")
t("Flameshock", "불꽃충격", "talent name")


------------------------------------------------
section "game/engines/default/modules/boot/data/timed_effects.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/zones/dungeon/zone.lua"



------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Addons.lua"

t("Show incompatible", "호환되지 않는 버전 보이기", "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Credits.lua"



------------------------------------------------
section "game/engines/default/modules/boot/dialogs/FirstRun.lua"

t("Cancel", "취소", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/LoadGame.lua"

t("Load Game", "게임 불러오기", "_t")
t("Developer Mode", "개발자 모드", "_t")
t("Cancel", "취소", "_t")


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
t("Dexterity", "민첩", "stat name")
t("Constitution", "체격", "stat name")


