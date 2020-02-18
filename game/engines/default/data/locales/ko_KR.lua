locale "ko_KR"
-- COPYlocal function findJosaType(str)	local length = str:len()		local c1, c2	local c3 = str:lower():byte(length)		local last = 0	if ( length < 3 ) or ( c3 < 128 ) then		--@ 여기오면 일단 한글은 아님		--@ 여기에 숫자나 알파벳인지 검사해서 아니면 마지막 글자 빼고 재귀호출하는 코드 삽입 필요				if ( c3 == '1' or c3 == '7' or c3 == '8' or c3 == 'l' or c3 == 'r' ) then			last = 8 --@ 한글이 아니고, josa2를 사용하지만 '로'가 맞는 경우		elseif ( c3 == '3' or c3 == '6' or c3 == '0' or c3 == 'm' or c3 == 'n' ) then			last = 100 --@ 한글이 아니고, josa2를 사용하는 경우		end  	else --@ 한글로 추정 (정확히는 더 검사가 필요하지만..)		c1 = str:byte(length-2)		c2 = str:byte(length-1)				last = ( (c1-234)*4096 + (c2-128)*64 + (c3-128) - 3072 )%28	end		return lastendlocal function addJosa(str, temp)	local josa1, josa2, index	if temp == 1 or temp == "가" or temp == "이" then		josa1 = "가"		josa2 = "이"		index = 1	elseif temp == 2 or temp == "는" or temp == "은" then		josa1 = "는"		josa2 = "은"		index = 2	elseif temp == 3 or temp == "를" or temp == "을" then		josa1 = "를"		josa2 = "을"		index = 3	elseif temp == 4 or temp == "로" or temp == "으로" then		josa1 = "로"		josa2 = "으로"		index = 4	elseif temp == 5 or temp == "다" or temp == "이다" then		josa1 = "다"		josa2 = "이다"		index = 5	elseif temp == 6 or temp == "와" or temp == "과" then		josa1 = "와"		josa2 = "과"		index = 6	elseif temp == 7 then		josa1 = ""		josa2 = "이"		index = 7	else		if type(temp) == string then return str .. temp		else return str end 	end		local type = findJosaType(str)		if type == 0 or ( index == 4 and type == 8 ) then		return str .. josa1	else		return str .. josa2	endendsetFlag("noun_target_sub", function(str, type, noun)	if type == "#Source#" then		return str:gsub("#Source#", noun):gsub("#Source1#", addJosa(noun, "가")):gsub("#Source2#", addJosa(noun, "는")):gsub("#Source3#", addJosa(noun, "를")):gsub("#Source4#", addJosa(noun, "로")):gsub("#Source5#", addJosa(noun, "다")):gsub("#Source6#", addJosa(noun, "과")):gsub("#Source7#", addJosa(noun, 7))	elseif type == "#source#" then		return str:gsub("#source#", noun):gsub("#source#", addJosa(noun, "가")):gsub("#source2#", addJosa(noun, "는")):gsub("#source3#", addJosa(noun, "를")):gsub("#source4#", addJosa(noun, "로")):gsub("#source5#", addJosa(noun, "다")):gsub("#source6#", addJosa(noun, "과")):gsub("#source7#", addJosa(noun, 7))	elseif type == "#Target#" then		return str:gsub("#Target#", noun):gsub("#Target1#", addJosa(noun, "가")):gsub("#Target2#", addJosa(noun, "는")):gsub("#Target3#", addJosa(noun, "를")):gsub("#Target4#", addJosa(noun, "로")):gsub("#Target5#", addJosa(noun, "다")):gsub("#Target6#", addJosa(noun, "과")):gsub("#Target7#", addJosa(noun, 7))	elseif type == "#target#" then		return str:gsub("#target#", noun):gsub("#target#", addJosa(noun, "가")):gsub("#target2#", addJosa(noun, "는")):gsub("#target3#", addJosa(noun, "를")):gsub("#target4#", addJosa(noun, "로")):gsub("#target5#", addJosa(noun, "다")):gsub("#target6#", addJosa(noun, "과")):gsub("#target7#", addJosa(noun, 7))	elseif type == "@Target@" then		return str:gsub("@Target@", noun):gsub("@Target@", addJosa(noun, "가")):gsub("@Target2@", addJosa(noun, "는")):gsub("@Target3@", addJosa(noun, "를")):gsub("@Target4@", addJosa(noun, "로")):gsub("@Target5@", addJosa(noun, "다")):gsub("@Target6@", addJosa(noun, "과")):gsub("@Target7@", addJosa(noun, 7))	elseif type == "@target@" then		return str:gsub("@target@", noun):gsub("@target@", addJosa(noun, "가")):gsub("@target2@", addJosa(noun, "는")):gsub("@target3@", addJosa(noun, "를")):gsub("@target4@", addJosa(noun, "로")):gsub("@target5@", addJosa(noun, "다")):gsub("@target6@", addJosa(noun, "과")):gsub("@target7@", addJosa(noun, 7))	elseif str == "@playername@" then		return str:gsub("@playername@", noun):gsub("@playername@", addJosa(noun, "가")):gsub("@playername2@", addJosa(noun, "는")):gsub("@playername3@", addJosa(noun, "를")):gsub("@playername4@", addJosa(noun, "로")):gsub("@playername5@", addJosa(noun, "다")):gsub("@playername6@", addJosa(noun, "과")):gsub("@playername7@", addJosa(noun, 7))	elseif type == "@npcname@" then		return str:gsub("@npcname@", noun):gsub("@npcname@", addJosa(noun, "가")):gsub("@npcname2@", addJosa(noun, "는")):gsub("@npcname3@", addJosa(noun, "를")):gsub("@npcname4@", addJosa(noun, "로")):gsub("@npcname5@", addJosa(noun, "다")):gsub("@npcname6@", addJosa(noun, "과")):gsub("@npcname7@", addJosa(noun, 7))	else		return str:gsub(type, noun)	endend)setFlag("tformat_special", function(s, locales_args, special, ...)	local args	if locales_args then		local sargs = {...}		args = {}		for sidx, didx in pairs(locales_args) do			args[sidx] = sargs[didx]		end	else		args = {...}	end	s = _t(s)	for k, v in pairs(special) do		args[k] = addJosa(args[k], v)	end	return s:format(unpack(args))end)------------------------------------------------
section "always_merge"

t([[Today is the %s %s of the %s year of the Age of Ascendancy of Maj'Eyal.
The time is %02d:%02d.]], [[오늘은 주도의 시대를 맞은 마즈'에이알 %s 년 %s %s 일 입니다.
현재 시간은 %02d 시 %02d 분입니다.]])
t("blocked", "방어됨")


------------------------------------------------
section "game/addons/tome-addon-dev/init.lua"

t("ToME Addon's Development Tools", "ToME 애드온 개발 도구")
t("Provides tools to develop and publish addons.", "애드온을 개발하고 출시할 수 있는 도구를 제공합니다.")


------------------------------------------------
section "game/addons/tome-addon-dev/superload/mod/dialogs/debug/AddonDeveloper.lua"

t("Addon Developer", "애드온 개발자")
t("Name", "이름")


------------------------------------------------
section "game/addons/tome-addon-dev/superload/mod/dialogs/debug/DebugMain.lua"

t("Addon Developer", "애드온 개발자")


------------------------------------------------
section "game/addons/tome-items-vault/data/entities/fortress-grids.lua"

t("Item's Vault Control Orb", "아이템 볼트 제어 오브")


------------------------------------------------
section "game/addons/tome-items-vault/init.lua"

t("Items Vault", "아이템 볼트")
t("Adds access to the items vault (donator feature). The items vault will let you upload a few unwanted items to your online profile and retrieve them on other characters.", "아이템 볼트를 이용할 수 있는 기능을 추가합니다. (후원자 전용) 아이템 볼트에 사용하지 않는 아이템을 플레이어의 온라인 프로필로 전송하여 다른 캐릭터로 옮길 수 있습니다.")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/chats/items-vault-command-orb-offline.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 볼트에 전송 시 %d 레벨의 착용 제한이 적용됩니다.")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.")
t("[Place an item in the vault]", "[볼트에 아이템 보관하기]")
t("Item's Vault", "아이템 볼트")
t("You can not place an item in the vault from debug mode game.", "디버그 모드에서는 아이템 볼트에 아이템을 보관할 수 없습니다.")
t("Place an item in the Item's Vault", "볼트에 아이템을 보관하기.")
t("Caution", "경고")
t("Continue?", "계속하시겠습니까?")
t("[Retrieve an item from the vault]", "[볼트에서 아이템을 찾아오기.]")
t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/chats/items-vault-command-orb.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 볼트에 전송 시 %d 레벨의 착용 제한이 적용됩니다.")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.")
t("Item's Vault", "아이템 볼트")
t("Place an item in the Item's Vault", "볼트에 아이템을 보관하기.")
t("Caution", "경고")
t("Continue?", "계속하시겠습니까?")
t("[Retrieve an item from the vault]", "[볼트에서 아이템을 찾아오기.]")
t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/maps/items-vault/fortress.lua"



------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/class/ItemsVaultDLC.lua"

t("Item's Vault", "아이템 볼트")


------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/dialogs/ItemsVault.lua"

t("Item's Vault", "아이템 볼트")
t("Name", "이름")


------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/dialogs/ItemsVaultOffline.lua"

t("Item's Vault", "아이템 볼트")
t("Name", "이름")


------------------------------------------------
section "game/addons/tome-possessors/data/achievements/possessors.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/birth/psionic.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/battle-psionics.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/body-snatcher.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/deep-horror.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/possession.lua"

t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic-menace.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psychic-blows.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/ravenous-mind.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/timed_effects.lua"

t("Shasshhiy'Kaish", "샤쉬'카이쉬")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")


------------------------------------------------
section "game/addons/tome-possessors/init.lua"



------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeForm.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeFormSelectTalents.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/data/keybinds/actions.lua"

t("Go to next/previous level", "다음/이전 단계로 이동")
t("Levelup window", "레벨업 창")
t("Use talents", "기술 발동")
t("Show quests", "임무 보이기")
t("Rest for a while", "휴식하기")
t("Save game", "게임 저장")
t("Quit game", "게임 종료")
t("Tactical display on/off", "전술정보 표시 전환")
t("Look around", "둘러보기")
t("Center the view on the player", "플레이어를 화면 중앙에 보이기")
t("Toggle minimap", "미니맵 켜기/끄기")
t("Show game calendar", "게임 내 달력 보이기")
t("Show character sheet", "캐릭터 시트 보이기")
t("Switch graphical modes", "그래픽 모드 전환")
t("Accept action", "확인 키")
t("Exit menu", "메뉴에서 나가기")


------------------------------------------------
section "game/engines/default/data/keybinds/chat.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/debug.lua"

t("Show Lua console", "Lua 콘솔 보기")
t("Debug Mode", "디버그 모드")


------------------------------------------------
section "game/engines/default/data/keybinds/hotkeys.lua"

t("Hotkey 1", "단축키 1")
t("Hotkey 2", "단축키 2")
t("Hotkey 3", "단축키 3")
t("Hotkey 4", "단축키 4")
t("Hotkey 5", "단축키 5")
t("Hotkey 6", "단축키 6")
t("Hotkey 7", "단축키 7")
t("Hotkey 8", "단축키 8")
t("Hotkey 9", "단축키 9")
t("Hotkey 10", "단축키 10")
t("Hotkey 11", "단축키 11")
t("Hotkey 12", "단축키 12")
t("Secondary Hotkey 1", "두번째 단축키 1")
t("Secondary Hotkey 2", "두번째 단축키 2")
t("Secondary Hotkey 3", "두번째 단축키 3")
t("Secondary Hotkey 4", "두번째 단축키 4")
t("Secondary Hotkey 5", "두번째 단축키 5")
t("Secondary Hotkey 6", "두번째 단축키 6")
t("Secondary Hotkey 7", "두번째 단축키 7")
t("Secondary Hotkey 8", "두번째 단축키 8")
t("Secondary Hotkey 9", "두번째 단축키 9")
t("Secondary Hotkey 10", "두번째 단축키 10")
t("Secondary Hotkey 11", "두번째 단축키 11")
t("Secondary Hotkey 12", "두번째 단축키 12")
t("Third Hotkey 1", "세번째 단축키 1")
t("Third Hotkey 2", "세번째 단축키 2")
t("Third Hotkey 3", "세번째 단축키 3")
t("Third Hotkey 4", "세번째 단축키 4")
t("Third Hotkey 5", "세번째 단축키 5")
t("Third Hotkey 6", "세번째 단축키 6")
t("Third Hotkey 7", "세번째 단축키 7")
t("Third Hotkey 8", "세번째 단축키 8")
t("Third Hotkey 9", "세번째 단축키 9")
t("Third Hotkey 10", "세번째 단축키 10")
t("Third Hotkey 11", "세번째 단축키 11")
t("Third Hotkey 12", "세번째 단축키 12")
t("Fourth Hotkey 1", "네번째 단축키 1")
t("Fourth Hotkey 2", "네번째 단축키 2")
t("Fourth Hotkey 3", "네번째 단축키 3")
t("Fourth Hotkey 4", "네번째 단축키 4")
t("Fourth Hotkey 5", "네번째 단축키 5")
t("Fourth Hotkey 6", "네번째 단축키 6")
t("Fourth Hotkey 7", "네번째 단축키 7")
t("Fourth Hotkey 8", "네번째 단축키 8")
t("Fourth Hotkey 9", "네번째 단축키 9")
t("Fourth Hotkey 10", "네번째 단축키 10")
t("Fourth Hotkey 11", "네번째 단축키 11")
t("Fourth Hotkey 12", "네번째 단축키 12")
t("Fifth Hotkey 1", "다섯번째 단축키 1")
t("Fifth Hotkey 2", "다섯번째 단축키 2")
t("Fifth Hotkey 3", "다섯번째 단축키 3")
t("Fifth Hotkey 4", "다섯번째 단축키 4")
t("Fifth Hotkey 5", "다섯번째 단축키 5")
t("Fifth Hotkey 6", "다섯번째 단축키 6")
t("Fifth Hotkey 7", "다섯번째 단축키 7")
t("Fifth Hotkey 8", "다섯번째 단축키 8")
t("Fifth Hotkey 9", "다섯번째 단축키 9")
t("Fifth Hotkey 10", "다섯번째 단축키 10")
t("Fifth Hotkey 11", "다섯번째 단축키 11")
t("Fifth Hotkey 12", "다섯번째 단축키 12")
t("Previous Hotkey Page", "이전 단축키 페이지")
t("Next Hotkey Page", "다음 단축키 페이지")
t("Quick switch to Hotkey Page 2", "2번 단축키 페이지로 빠른 전환")
t("Quick switch to Hotkey Page 3", "3번 단축키 페이지로 빠른 전환")


------------------------------------------------
section "game/engines/default/data/keybinds/interface.lua"

t("Toggle list of seen creatures", "확인된 생명체 리스트 전환")
t("Show message log", "메시지 로그 보기")
t("Take a screenshot", "화면 촬영")
t("Show map", "지도 보이기")
t("Scroll map mode", "화면 이동 모드")


------------------------------------------------
section "game/engines/default/data/keybinds/inventory.lua"

t("Show inventory", "가방 보기")
t("Show equipment", "장비창 보기")
t("Pickup items", "물건 줍기")
t("Drop items", "물건 버리기")
t("Wield/wear items", "물건 들기/착용하기")
t("Takeoff items", "물건 탈착하기")
t("Use items", "물건 사용하기")
t("Quick switch weapons set", "무기 세트 빠른 전환")


------------------------------------------------
section "game/engines/default/data/keybinds/move.lua"

t("Move left", "왼쪽으로 이동")
t("Move right", "오른쪽으로 이동")
t("Move up", "위로 이동")
t("Move down", "아래로 이동")
t("Move diagonally left and up", "좌상단으로 대각 이동")
t("Move diagonally right and up", "우상단으로 대각 이동")
t("Move diagonally left and down", "좌하단으로 대각 이동")
t("Move diagonally right and down", "좌상단으로 대각 이동")
t("Stay for a turn", "한턴 대기")
t("Run", "달리기")
t("Run left", "왼쪽으로 달리기")
t("Run right", "오른쪽으로 달리기")
t("Run up", "위로 달리기")
t("Run down", "아래로 달리기")
t("Run diagonally left and up", "좌상단으로 대각 달리기")
t("Run diagonally right and up", "우상단으로 대각 달리기")
t("Run diagonally left and down", "좌하단으로 대각 달리기")
t("Run diagonally right and down", "좌상단으로 대각 달리기")
t("Auto-explore", "자동 탐색")


------------------------------------------------
section "game/engines/default/data/keybinds/mtxn.lua"

t("List purchasable", "구매 가능 목록 보기")
t("Use purchased", "구매한 품목 확인하기")


------------------------------------------------
section "game/engines/default/engine/ActorsSeenDisplay.lua"

t("%s (%d)#WHITE#; distance [%s]", "%s (%d)#WHITE#; 거리 [%s]")


------------------------------------------------
section "game/engines/default/engine/Birther.lua"

t("Enter your character's name", "캐릭터 이름을 입력해주세요")
t("Name", "이름")
t("Character Creation: %s", "캐릭터 생성: %s")
t([[Keyboard: #00FF00#up key/down key#FFFFFF# to select an option; #00FF00#Enter#FFFFFF# to accept; #00FF00#Backspace#FFFFFF# to go back.
Mouse: #00FF00#Left click#FFFFFF# to accept; #00FF00#right click#FFFFFF# to go back.
]], [[키보드: #00FF00#위/아래 방향키#FFFFFF# 로 설정을 변경; #00FF00#엔터키#FFFFFF# 로 확인; #00FF00#백스페이스키#FFFFFF# 로 돌아가기.
마우스: #00FF00#좌클릭#FFFFFF# 으로 확인; #00FF00#우클릭#FFFFFF# 으로 돌아가기.
]])
t("Random", "무작위")


------------------------------------------------
section "game/engines/default/engine/DebugConsole.lua"



------------------------------------------------
section "game/engines/default/engine/Dialog.lua"

t("Yes", "네")
t("No", "아니요")


------------------------------------------------
section "game/engines/default/engine/Game.lua"



------------------------------------------------
section "game/engines/default/engine/I18N.lua"



------------------------------------------------
section "game/engines/default/engine/Key.lua"



------------------------------------------------
section "game/engines/default/engine/LogDisplay.lua"



------------------------------------------------
section "game/engines/default/engine/MicroTxn.lua"



------------------------------------------------
section "game/engines/default/engine/Module.lua"



------------------------------------------------
section "game/engines/default/engine/Mouse.lua"



------------------------------------------------
section "game/engines/default/engine/Object.lua"



------------------------------------------------
section "game/engines/default/engine/PlayerProfile.lua"



------------------------------------------------
section "game/engines/default/engine/Quest.lua"



------------------------------------------------
section "game/engines/default/engine/Savefile.lua"



------------------------------------------------
section "game/engines/default/engine/SavefilePipe.lua"



------------------------------------------------
section "game/engines/default/engine/Store.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/Trap.lua"



------------------------------------------------
section "game/engines/default/engine/UserChat.lua"

t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/Zone.lua"



------------------------------------------------
section "game/engines/default/engine/ai/talented.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/AudioOptions.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ChatChannels.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ChatFilter.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ChatIgnores.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/DisplayResolution.lua"

t("Restart", "재시작")
t("Restart with reset", "재시작 후 창 위치 초기화")
t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/engines/default/engine/dialogs/Downloader.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/dialogs/GameMenu.lua"

t("Game Menu", "게임 메뉴")
t("Resume", "재개")
t("Developer Mode", "개발자 모드")
t("No", "아니요")
t("Yes", "네")
t("Save Game", "게임 저장")
t("Main Menu", "메인 메뉴")
t("Exit Game", "게임 종료")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantity.lua"

t("Accept", "수락")
t("Cancel", "취소")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantitySlider.lua"

t("Accept", "수락")
t("Cancel", "취소")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"

t("Accept", "수락")
t("Cancel", "취소")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/dialogs/KeyBinder.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowAchievements.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipInven.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipment.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowErrorStack.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowInventory.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowPickupFloor.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowQuests.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowStore.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ShowText.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/SteamOptions.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/Talkbox.lua"

t("Accept", "수락")
t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/UserInfo.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ViewHighScores.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/MTXMain.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/ShowPurchasable.lua"

t("Name", "이름")
t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/UsePurchased.lua"

t("Name", "이름")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨")


------------------------------------------------
section "game/engines/default/engine/interface/ActorInventory.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorLife.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/interface/GameTargeting.lua"

t("No", "아니요")
t("Yes", "네")


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

t("Yes", "네")
t("No", "아니요")
t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/ui/Gestures.lua"



------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"



------------------------------------------------
section "game/engines/default/engine/ui/WebView.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/utils.lua"



------------------------------------------------
section "game/engines/default/modules/boot/class/Game.lua"



------------------------------------------------
section "game/engines/default/modules/boot/class/Player.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/birth/descriptors.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/damage_types.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/basic.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/forest.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/underground.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/water.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/canine.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/skeleton.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/troll.lua"

t("giant", "거인")


------------------------------------------------
section "game/engines/default/modules/boot/data/talents.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/timed_effects.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/zones/dungeon/zone.lua"



------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Addons.lua"

t("Show incompatible", "호환되지 않는 버전 보이기")
t("Game Module", "게임 모듈")
t("Version", "버전")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Credits.lua"



------------------------------------------------
section "game/engines/default/modules/boot/dialogs/FirstRun.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/LoadGame.lua"

t("Load Game", "게임 불러오기")
t("Developer Mode", "개발자 모드")
t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/MainMenu.lua"

t("Main Menu", "메인 메뉴")
t("New Game", "새 게임")
t("Load Game", "게임 불러오기")
t("Addons", "애드온")
t("Options", "설정")
t("Game Options", "게임 설정")
t("Credits", "개발진들")
t("Exit", "나가기")
t("Reboot", "재시작")
t("Disable animated background", "움직이는 배경화면 비활성화")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨")
t("#YELLOW#Not installed - Click to download / purchase", "#YELLOW#설치되지 않음 - 클릭 시 다운로드 / 구매")
t("Login", "로그인")
t("Register", "가입")
t("Username: ", "유저명: ")
t("Password: ", "비밀번호: ")
t("#GOLD#Online Profile", "#GOLD#온라인 프로필")
t("Login with Steam", "스팀으로 로그인")
t("#GOLD#Online Profile#WHITE#", "#GOLD#온라인 프로필#WHITE#")
t("#LIGHT_BLUE##{underline}#Logout", "#LIGHT_BLUE##{underline}#로그아웃")
t("Username", "유저명")
t("Your username is too short", "유저명이 너무 짧습니다.")
t("Password", "비밀번호")
t("Your password is too short", "비밀번호가 너무 짧습니다.")
t("Login in your account, please wait...", "로그인 중입니다. 잠시만 기다려주세요...")
t("Login...", "로그인 중...")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/NewGame.lua"

t("New Game", "새 게임")
t("Show all versions", "모든 버전 보이기")
t("Show incompatible", "호환되지 않는 버전 보이기")
t("Game Module", "게임 모듈")
t("Version", "버전")
t("Enter your character's name", "캐릭터 이름을 입력해주세요")
t("Overwrite character?", "캐릭터를 덮어씌우시겠습니까?")
t("There is already a character with this name, do you want to overwrite it?", "이미 존재하는 캐릭터 명입니다만, 덮어씌우시겠습니까?")
t("No", "아니요")
t("Yes", "네")
t("This game is not compatible with your version of T-Engine, you can still try it but it might break.", "이 게임은 현재 T-Engint 버전과 호환되지 않으므로, 실행 시 심각한 오류를 발생시킬 수 있습니다.")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Profile.lua"

t("Cancel", "취소")
t("Login", "로그인")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileLogin.lua"

t("Login", "로그인")
t("Username: ", "유저명: ")
t("Password: ", "비밀번호: ")
t("Cancel", "취소")
t("Username", "유저명")
t("Your username is too short", "유저명이 너무 짧습니다.")
t("Password", "비밀번호")
t("Your password is too short", "비밀번호가 너무 짧습니다.")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileSteamRegister.lua"

t("Username: ", "유저명: ")
t("Register", "가입")
t("Cancel", "취소")
t("Username", "유저명")
t("Your username is too short", "유저명이 너무 짧습니다.")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/UpdateAll.lua"

t("Version", "버전")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ViewHighScores.lua"

t("Game Module", "게임 모듈")
t("Version", "버전")


------------------------------------------------
section "game/engines/default/modules/boot/init.lua"



------------------------------------------------
section "game/engines/default/modules/boot/load.lua"

t("Strength", "힘")
t("str", "힘")
t("Dexterity", "민첩")
t("dex", "민첩")
t("Constitution", "체격")
t("con", "체격")


------------------------------------------------
section "game/modules/tome/ai/escort.lua"



------------------------------------------------
section "game/modules/tome/ai/improved_tactical.lua"



------------------------------------------------
section "game/modules/tome/ai/improved_talented.lua"



------------------------------------------------
section "game/modules/tome/ai/maintenance.lua"



------------------------------------------------
section "game/modules/tome/ai/quests.lua"



------------------------------------------------
section "game/modules/tome/ai/sandworm_tunneler.lua"



------------------------------------------------
section "game/modules/tome/ai/shadow.lua"



------------------------------------------------
section "game/modules/tome/ai/special_movements.lua"



------------------------------------------------
section "game/modules/tome/ai/tactical.lua"



------------------------------------------------
section "game/modules/tome/ai/target.lua"



------------------------------------------------
section "game/modules/tome/class/Actor.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/class/FortressPC.lua"



------------------------------------------------
section "game/modules/tome/class/Game.lua"

t("#Source# hits #Target# for %s (#RED##{bold}#%0.0f#LAST##{normal}# total damage)%s.", "#Source#이(가) #Target#을(를) 공격함. %s (총 #RED##{bold}#%0.0f#LAST##{normal}# 데미지)%s.")
t("#Source# hits #Target# for %s damage.", "#Source#이(가) #Target3#을(를) 공격하여 %s 피해를 입힘.")
t("Game Options", "게임 설정")


------------------------------------------------
section "game/modules/tome/class/GameState.lua"

t("Exterminator", "절멸자")
t("but nobody knew why #sex# suddenly became evil", "하지만 왜 #sex#(조사) 타락했는지는 아무도 모릅니다.")
t("Accept", "수락")


------------------------------------------------
section "game/modules/tome/class/Grid.lua"



------------------------------------------------
section "game/modules/tome/class/MapEffects.lua"



------------------------------------------------
section "game/modules/tome/class/NPC.lua"



------------------------------------------------
section "game/modules/tome/class/Object.lua"



------------------------------------------------
section "game/modules/tome/class/Party.lua"

t("Name", "이름")


------------------------------------------------
section "game/modules/tome/class/PartyMember.lua"



------------------------------------------------
section "game/modules/tome/class/Player.lua"



------------------------------------------------
section "game/modules/tome/class/Projectile.lua"



------------------------------------------------
section "game/modules/tome/class/Store.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/class/Trap.lua"



------------------------------------------------
section "game/modules/tome/class/UserChatExtension.lua"



------------------------------------------------
section "game/modules/tome/class/World.lua"



------------------------------------------------
section "game/modules/tome/class/WorldNPC.lua"



------------------------------------------------
section "game/modules/tome/class/generator/actor/Arena.lua"

t("Reaver", "약탈자")


------------------------------------------------
section "game/modules/tome/class/generator/actor/HighPeakFinal.lua"



------------------------------------------------
section "game/modules/tome/class/generator/actor/ValleyMoon.lua"



------------------------------------------------
section "game/modules/tome/class/interface/ActorAI.lua"



------------------------------------------------
section "game/modules/tome/class/interface/ActorInscriptions.lua"



------------------------------------------------
section "game/modules/tome/class/interface/ActorObjectUse.lua"



------------------------------------------------
section "game/modules/tome/class/interface/Archery.lua"

t("#Source# misses #target#.", "#target#의 공격이 #Source#를 빗맞힘.")


------------------------------------------------
section "game/modules/tome/class/interface/Combat.lua"



------------------------------------------------
section "game/modules/tome/class/interface/PartyDeath.lua"



------------------------------------------------
section "game/modules/tome/class/interface/PartyIngredients.lua"



------------------------------------------------
section "game/modules/tome/class/interface/PartyLore.lua"



------------------------------------------------
section "game/modules/tome/class/interface/PlayerExplore.lua"



------------------------------------------------
section "game/modules/tome/class/interface/TooltipsData.lua"



------------------------------------------------
section "game/modules/tome/class/interface/WorldAchievements.lua"



------------------------------------------------
section "game/modules/tome/class/uiset/Classic.lua"



------------------------------------------------
section "game/modules/tome/class/uiset/ClassicPlayerDisplay.lua"



------------------------------------------------
section "game/modules/tome/class/uiset/Minimalist.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/arena.lua"

t("The Arena", "투기장")
t("Unlocked Arena mode.", "투기장 모드를 해금했다.")
t("Arena Battler 20", "투기장의 투사 20")
t("Got to wave 20 in the arena.", "투기장에서 20웨이브에 도달했다.")
t("Arena Battler 50", "투기장의 투사 50")
t("Got to wave 50 in the arena.", "투기장에서 50웨이브에 도달했다.")
t("Almost Master of Arena", "(거의) 투기장의 지배자")
t("Became the new master of the arena in 30-wave mode.", "30웨이브 모드에서 투기장의 새 지배자가 되었다.")
t("Master of Arena", "투기장의 지배자")
t("Became the new master of the arena in 60-wave mode.", "60웨이브 모드에서 투기장의 새 지배자가 되었다.")
t("XXX the Destroyer", "파괴자 XXX")
t("Earned the rank of Destroyer in the arena.", "투기장에서 '파괴자' 등급에 도달했다.")
t("Grand Master", "최고수")
t("Earned the rank of Grand Master in the arena.", "투기장에서 '최고수' 등급에 도달했다.")
t("Ten at one blow", "한 방에 열 놈")
t("Killed 10 or more enemies in one single attack in the arena.", "투기장에서 한 번의 공격으로 10명 혹은 그 이상의 적을 처치했다.")


------------------------------------------------
section "game/modules/tome/data/achievements/donator.lua"

t("Bronze Donator", "동장 기부자")
t("Donated up to 5 euros to Tales of Maj'Eyal.", "Tales of Maj'Eyal에 5유로만큼을 기부했다.")
t("Silver Donator", "은장 기부자")
t("Donated at least 6 euros to Tales of Maj'Eyal.", "Tales of Maj'Eyal에 최소 6유로를 기부했다.")
t("Gold Donator", "금장 기부자")
t("Donated at least 16 euros to Tales of Maj'Eyal.", "Tales of Maj'Eyal에 최소 16유로를 기부했다.")
t("Stralite Donator", "스트랄라이트 기부자")
t("Donated at least 31 euros to Tales of Maj'Eyal.", "Tales of Maj'Eyal에 최소 31유로를 기부했다.")
t("Voratun Donator", "보라툰 기부자")
t("Donated more than 60 euros to Tales of Maj'Eyal.", "Tales of Maj'Eyal에 60유로 이상을 기부했다.")


------------------------------------------------
section "game/modules/tome/data/achievements/events.lua"

t("The sky is falling!", "하늘이 무너진다!")
t("Saw a huge meteor falling from the sky.", "거대한 유성이 하늘에서 떨어지는 것을 목격했다.")
t("Demonic Invasion", "악마들의 침공")
t("Stopped a demonic invasion by closing their portal.", "차원문을 닫아 악마들의 침공을 막아냈다.")
t("Invasion from the Depths", "심연으로부터의 침공")
t("Stopped a naga invasion by closing their portal.", "차원문을 닫아 나가들의 침공을 막아냈다.")
t("The Restless Dead", "쉬지 못하는 망자들")
t("Disturbed an old battlefield and survived the consequences.", "옛 전장을 파헤치고 그 잔해들로부터 살아남았다.")
t("The Rat Lich", "리치 쥐")
t("Killed the terrible Rat Lich.", "무시무시한 리치 쥐를 처치했다.")
t("Shasshhiy'Kaish", "샤쉬'카이쉬")
t("Killed Shasshhiy'Kaish after letting her grow as powerful as possible.", "샤쉬'카이쉬가 힘을 최대한 키우도록 한 뒤 처치했다.")
t("Bringer of Doom", "멸망의 인도자")
t("Killed a Bringer of Doom.", "멸망의 인도자를 처치했다.")
t("A living one!", "생존자!")
t("Was teleported into Caldizar's Fortress, far into the void between the stars.", "별들 사이의 머나먼 공허에 있는 칼디자르의 요새로 순간이동했다.")
t("Slimefest", "슬라임 축제")
t("Have 100 walls on the sludgenest turn into hostile creatures.", "sludgenest의 벽 100개가 적대적인 생명체로 변할 때까지 기다렸다.")
t("Slime killer party", "슬라임 처치 대잔치")
t("Have 200 walls on the sludgenest turn into hostile creatures.", "sludgenest의 벽 200개가 적대적인 생명체로 변할 때까지 기다렸다.")
t("Mad slime dash", "미친 슬라임 질주")
t("Have 300 walls on the sludgenest turn into hostile creatures.", "sludgenest의 벽 300개가 적대적인 생명체로 변할 때까지 기다렸다.")
t("Don't mind the slimy smell", "슬라임 냄새는 신경쓰지 마")
t("Have 400 walls on the sludgenest turn into hostile creatures.", "sludgenest의 벽 400개가 적대적인 생명체로 변할 때까지 기다렸다.")
t("In the company of slimes", "슬라임 중대와 함께")
t("Have 500 walls on the sludgenest turn into hostile creatures.", "sludgenest의 벽 500개가 적대적인 생명체로 변할 때까지 기다렸다.")


------------------------------------------------
section "game/modules/tome/data/achievements/infinite-dungeon.lua"

t("Infinite x10", "무한의 던전 10층")
t("Got to level 10 of the infinite dungeon.", "무한의 던전 10층에 도달했다.")
t("Infinite x20", "무한의 던전 20층")
t("Got to level 20 of the infinite dungeon.", "무한의 던전 20층에 도달했다.")
t("Infinite x30", "무한의 던전 30층")
t("Got to level 30 of the infinite dungeon.", "무한의 던전 30층에 도달했다.")
t("Infinite x40", "무한의 던전 40층")
t("Got to level 40 of the infinite dungeon.", "무한의 던전 40층에 도달했다.")
t("Infinite x50", "무한의 던전 50층")
t("Got to level 50 of the infinite dungeon.", "무한의 던전 50층에 도달했다.")
t("Infinite x60", "무한의 던전 60층")
t("Got to level 60 of the infinite dungeon.", "무한의 던전 60층에 도달했다.")
t("Infinite x70", "무한의 던전 70층")
t("Got to level 70 of the infinite dungeon.", "무한의 던전 70층에 도달했다.")
t("Infinite x80", "무한의 던전 80층")
t("Got to level 80 of the infinite dungeon.", "무한의 던전 80층에 도달했다.")
t("Infinite x90", "무한의 던전 90층")
t("Got to level 90 of the infinite dungeon.", "무한의 던전 90층에 도달했다.")
t("Infinite x100", "무한의 던전 100층")
t("Got to level 100 of the infinite dungeon.", "무한의 던전 100층에 도달했다.")
t("Infinite x150", "무한의 던전 150층")
t("Got to level 150 of the infinite dungeon.", "무한의 던전 150층에 도달했다.")
t("Infinite x200", "무한의 던전 200층")
t("Got to level 200 of the infinite dungeon.", "무한의 던전 200층에 도달했다.")
t("Infinite x300", "무한의 던전 300층")
t("Got to level 300 of the infinite dungeon.", "무한의 던전 300층에 도달했다.")
t("Infinite x400", "무한의 던전 400층")
t("Got to level 400 of the infinite dungeon.", "무한의 던전 400층에 도달했다.")
t("Infinite x500", "무한의 던전 500층")
t("Got to level 500 of the infinite dungeon.", "무한의 던전 500층에 도달했다.")


------------------------------------------------
section "game/modules/tome/data/achievements/items.lua"

t("Deus Ex Machina", "데우스 엑스 마키나")
t("Found the Blood of Life and the four unique inscriptions: Primal Infusion, Infusion of Wild Growth, Rune of Reflection and Rune of the Rift.", "생명의 피와 네 개의 고유 각인(Primal Infusion, Infusion of Wild Growth, Rune of Reflection 그리고 Rune of the Rift)을 발견했다.")
t("Treasure Hunter", "보물 사냥꾼")
t("Amassed 1000 gold pieces.", "금화 1000개를 모았다.")
t("Treasure Hoarder", "보물 수집광")
t("Amassed 3000 gold pieces.", "금화 3000개를 모았다.")
t("Dragon's Greed", "용의 탐욕")
t("Amassed 8000 gold pieces.", "금화 8000개를 모았다.")


------------------------------------------------
section "game/modules/tome/data/achievements/kills.lua"

t("That was close", "아슬아슬했어")
t("Killed your target while having only 1 life left.", "생명력이 단 1만 남은 채로 적을 처치했다.")
t("Size matters", "크기는 상관 있다")
t("Did over 600 damage in one attack.", "한 번의 공격으로 600 이상의 피해를 입혔다.")
t("Size is everything", "크기가 모든 것")
t("Did over 1500 damage in one attack.", "한 번의 공격으로 1500 이상의 피해를 입혔다.")
t("The bigger the better!", "크면 클수록 좋지!")
t("Did over 3000 damage in one attack.", "한 번의 공격으로 3000 이상의 피해를 입혔다.")
t("Overpowered!", "압도적인 힘!")
t("Did over 6000 damage in one attack.", "한 번의 공격으로 6000 이상의 피해를 입혔다.")
t("Exterminator", "절멸자")
t("Killed 1000 creatures.", "1000마리의 생명체를 처치했다.")
t("Pest Control", "해충 구제")
t("Killed 1000 reproducing vermin.", "1000마리의 증식하는 해충을 처치했다.")
t("Reaver", "약탈자")
t("Killed 1000 humanoids.", "1000마리의 인간형을 처치했다.")
t("Backstabbing Traitor", "뒤를 찌르는 배신자")
t("Killed 6 escorted adventurers while you were supposed to save them.", "호위해 주기로 한 모험가를 6명 살해했다.")
t("Bad Driver", "나쁜 운전자")
t("Failed to save any escorted adventurers.", "모험가를 호위하는 데 전부 실패했다.")
t("Guiding Hand", "이끄는 손")
t("Saved all escorted adventurers.", "모험가를 호위하는 데 전부 성공했다.")
t("Earth Master", "대지의 달인")
t("Killed Harkor'Zun and unlocked Stone magic.", "하코르'준을 죽이고 바위 마법을 해금했다.")
t("Kill Bill!", "킬 빌!")
t("Killed Bill in the Trollmire without leveling beyond your starting level.", "게임을 시작한 뒤 레벨을 올리지 않은 채로 Trollmire에서 빌을 처치했다.")
t("Atamathoned!", "'아타마쏜'당하다!")
t("Killed the giant golem Atamathon after foolishly reactivating it.", "어리석게도 거대한 골렘 아타마쏜을 재활성화한 뒤 처치했다.")
t("Huge Appetite", "왕성한 식욕")
t("Ate 20 bosses.", "20명의 보스를 삼켰다.")
t("Headbanger", "박치기 왕")
t("Headbanged 20 bosses to death.", "20명의 보스를 박치기로 처치했다.")
t("Are you out of your mind?!", "미친 거 아냐?!")
t("Caught the attention of overpowered greater multi-hued wyrms in Vor Armoury. Perhaps fleeing is in order.", "보르 무기고에 있는 무지막지한 고위 다색 용들의 관심을 끌었다. 아마 도망치는 것이 알맞을지도...")
t("I cleared the room of death and all I got was this lousy achievement!", "이 죽음의 방을 싹쓸이했지만 내가 얻은 것이라고는 이 바보 같은 도전과제 뿐이라네!")
t("Killed the seven overpowered wyrms in the \"Room of Death\" in Vor Armoury.", "보르 무기고의 \"죽음의 방\"에 있는 무지막지한 일곱 용들을 처치했다.")
t("I'm a cool hero", "나는 쿨한 영웅")
t("Saved Derth without a single inhabitant dying.", "한 명의 마을 주민도 죽게 놔두지 않고 데르스를 구했다.")
t("Kickin' it old-school", "옛 방식으로 작살내기")
t("Killed Urkis, the Tempest, causing him to drop the Rod of Recall.", "폭풍술사 우르키스를 처치하고 그에게서 Rod of Recall을 얻었다.")
t("Leave the big boys alone", "다 큰 놈은 내버려 둬")
t("Killed The Master, causing him to drop the Rod of Recall.", "'주인' 을 처치하고 그에게서 Rod of Recall을 얻었다.")
t("You know who's to blame", "누구의 책임인지 알지")
t("Killed the Grand Corruptor, causing him to drop the Rod of Recall.", "위대한 타락자를 처치하고 그에게서 Rod of Recall을 얻었다.")
t("You know who's to blame (reprise)", "누구의 책임인지 알지(reprise)")
t("Killed Myssil, causing her to drop the Rod of Recall.", "미씰을 처치하고 그녀에게서 Rod of Recall을 얻었다.")
t("Now, this is impressive!", "이제, 정말 인상적이로군!")
t("Killed Linaniil, the Supreme Archmage of Angolwen.", "앙골웬의 최고 마도사, 리나니일을 처치했다.")
t("Fear of Fours", "넷의 공포")
t("Killed all four bosses of the Slime Tunnels.", "Slime Tunnels의 우두머리 넷을 모두 처치했다.")
t("Well trained", "잘 훈련됨")
t("Deal one million damage to training dummies in a single training session.", "한 번의 연습에서 연습용 허수아비에게 100만 이상의 피해를 입혔다.")
t("I meant to do that...", "내가 말하려 했던 건 말이지...")
t("Avoid death 50 times with a life-saving talent.", "생존 기술로 50번의 죽음을 면했다.")


------------------------------------------------
section "game/modules/tome/data/achievements/lore.lua"

t("Tales of the Spellblaze", "Spellblaze의 이야기")
t("Learned the eight chapters of the Spellblaze Chronicles.", "Spellblaze 연대기의 여덟 장을 배웠다.")
t("The Legend of Garkul", "가르쿨의 전설")
t("Learned the five chapters of the Legend of Garkul.", "가르쿨의 전설의 다섯 장을 배웠다.")
t("A different point of view", "다른 시점에서 보기")
t("Learned the five chapters of Orc history through loremaster Hadak's tales.", "전승의 대가 하다크의 이야기를 통해 다섯 장의 오크 역사를 배웠다.")


------------------------------------------------
section "game/modules/tome/data/achievements/player.lua"

t("Level 10", "레벨 10")
t("Got a character to level 10.", "캐릭터가 레벨 10이 되었다.")
t("Level 20", "레벨 20")
t("Got a character to level 20.", "캐릭터가 레벨 20이 되었다.")
t("Level 30", "레벨 30")
t("Got a character to level 30.", "캐릭터가 레벨 30이 되었다.")
t("Level 40", "레벨 40")
t("Got a character to level 40.", "캐릭터가 레벨 40이 되었다.")
t("Level 50", "레벨 50")
t("Got a character to level 50.", "캐릭터가 레벨 50이 되었다.")
t("Unstoppable", "도저히 막을 수 없습니다")
t("Returned from the dead.", "죽음으로부터 돌아왔다.")
t("Utterly Destroyed", "완전히 파괴되다")
t("Died on the Eidolon Plane.", "에이돌론의 차원에서 죽었다.")
t("Fool of a Took!", "이 멍청아!")
t("Killed oneself as a halfling.", "하플링으로 플레이하는 중 자기 자신을 죽였다.")
t("Emancipation", "해방")
t("Had the golem kill a boss while its master was already dead.", "주인이 이미 죽은 상태에서 골렘이 보스를 처치했다.")
t("Take you with me", "물귀신")
t("Killed a boss while already dead.", "이미 죽은 상태에서 보스를 처치했다.")
t("Look at me, I'm playing a roguelike!", "날 좀 봐, 난 로그라이크를 하고 있다고!")
t("Linked yourself in the in-game chat.", "게임 안의 채팅에 자신의 캐릭터를 링크했다.")
t("Fear me not!", "날 두려워하지 말라!")
t("Survived the Fearscape!", "Fearscape에서 살아 돌아왔다!")


------------------------------------------------
section "game/modules/tome/data/achievements/quests.lua"

t("Baby steps", "걸음마")
t("Completed ToME4 tutorial mode.", "ToME4의 튜토리얼을 완료했다.")
t("Vampire crusher", "뱀파이어 분쇄자")
t("Destroyed the Master in its lair of the Dreadfell.", "Dreadfell에 있는 그의 본거지에서 Master를 파괴했다.")
t("A dangerous secret", "위험한 비밀")
t("Found the mysterious staff and told Last Hope about it.", "신비한 지팡이를 찾아내고 그것을 마지막 희망에 보고했다.")
t("The secret city", "비밀스러운 도시")
t("Discovered the truth about mages.", "마법사들에 대한 진실을 밝혀냈다.")
t("Burnt to the ground", "전소")
t("Gave the staff of absorption to the apprentice mage and watched the fireworks.", "흡수의 지팡이를 견습 마법사에게 건네 주고 불꽃놀이를 지켜봤다.")
t("Against all odds", "불가능에 맟서다")
t("Killed Ukruk in the ambush.", "습격해 온 우크룩을 처치했다.")
t("Sliders", "슬라이더")
t("Activated a portal using the Orb of Many Ways.", "Orb of Many Ways를 사용하여 차원문을 활성화했다.")
t("Destroyer's bane", "파괴자의 파멸")
t("Killed Golbug the Destroyer.", "파괴자 골버그를 처치했다.")
t("Brave new world", "멋진 신세계")
t("Went to the Far East and took part in the war.", "동쪽 대륙으로 건너가 전쟁에 참여했다.")
t("Race through fire", "화염을 뚫고 달려라")
t("Raced through the fires of the Charred Scar to stop the Sorcerers.", "주술사들을 막기 위해 Charred Scar의 화염을 뚫고 달렸다.")
t("Orcrist", "오르크리스트")
t("Killed the leaders of the Orc Pride.", "Orc Pride의 지도자들을 처치했다.")
t("Evil denied", "악을 저지하다")
t("Won ToME by preventing the Void portal from opening.", "공허의 관문이 열리는 것을 막아내어 ToME에서 승리했다.")
t("The High Lady's destiny", "고귀한 여인의 운명")
t("Won ToME by closing the Void portal using Aeryn as a sacrifice.", "아에린의 희생으로 공허의 관문을 닫아 ToME에서 승리했다.")
t("The Sun Still Shines", "태양은 여전히 빛나고")
t("Aeryn survived the last battle.", "아에린이 마지막 전투에서 살아남았다.")
t("Selfless", "이타심")
t("Won ToME by closing the Void portal using yourself as a sacrifice.", "당신의 희생으로 공허의 관문을 닫아 ToME에서 승리했다.")
t("Triumph of the Way", "'한길'의 승리")
t("Won ToME by sacrificing yourself to forcefully spread the Way to every other sentient being on Eyal.", "당신의 희생으로 에이얄의 모든 지성체에게 '한길'을 강제해 ToME에서 승리했다.")
t("No Way!", "그 '길'은 안 돼!")
t("Won ToME by closing the Void portal and letting yourself be killed by Aeryn to prevent the Way to enslave every sentient being on Eyal.", "공허의 관문을 닫고 아에린에게 스스로 죽음을 맞이함으로써 모든 지성체를 노예로 삼으려는 '한길'의 음모를 저지하고 ToME에서 승리했다.")
t("Tactical master", "전술의 달인")
t("Fought the two Sorcerers without closing any invocation portals.", "어떤 소환 차원문도 닫지 않고 두 주술사와 싸워 이겼다.")
t("Portal destroyer", "차원문 파괴자")
t("Fought the two Sorcerers and closed one invocation portal.", "하나의 소환 차원문을 닫고 두 주술사와 싸웠다.")
t("Portal reaver", "차원문 약탈자")
t("Fought the two Sorcerers and closed two invocation portals.", "두 개의 소환 차원문을 닫고 두 주술사와 싸웠다.")
t("Portal ender", "차원문 종결자")
t("Fought the two Sorcerers and closed three invocation portals.", "세 개의 소환 차원문을 닫고 두 주술사와 싸웠다.")
t("Portal master", "차원문 달인")
t("Fought the two Sorcerers and closed four invocation portals.", "네 개의 소환 차원문을 모두 닫고 두 주술사와 싸웠다.")
t("Never Look Back And There Again", "뒤는 돌아보지 않는다")
t("Win the game without ever setting foot on Maj'Eyal.", "마즈'에이얄에 발도 딛지 않고 게임에서 승리했다.")
t("Bikining along!", "비키니와 함께!")
t("Won the game without ever taking off her bikini.", "비키니를 한 번도 벗지 않고 게임에서 승리했다.")
t("Mankining it happen!", "맨키니가 나타났다!")
t("Won the game without ever taking off his mankini.", "맨키니를 한 번도 벗지 않고 게임에서 승리했다.")
t("Rescuer of the lost", "실종자를 구해 내다")
t("Rescued the merchant from the assassin lord.", "암살단의 단장으로부터 상인을 구했다.")
t("Poisonous", "유독한 녀석")
t("Sided with the assassin lord.", "암살단의 단장과 한 편이 되었다.")
t("Destroyer of the creation", "창조의 파괴자")
t("Killed Slasul.", "슬라술을 처치했다.")
t("Treacherous Bastard", "믿을 수 없는 자식")
t("Killed Slasul even though you sided with him to learn the Legacy of the Naloren prodigy.", "'날로레의 유산'을 배우기 위해 슬라술의 편을 든 다음, 슬라술을 처치했다.")
t("Flooder", "홍수를 부르는 자")
t("Defeated Ukllmswwik while doing his own quest.", "우클름스윅의 임무를 진행하는 도중 그를 패배시켰다.")
t("Gem of the Moon", "달의 보석")
t("Completed the Master Jeweler quest with Limmir.", "리미르와 함께 보석 세공 명인 임무를 완료했다.")
t("Curse Lifter", "저주를 걷어낸 자")
t("Killed Ben Cruthdar the Cursed.", "저주받은 자 벤 크루스달을 처치했다.")
t("Fast Curse Dispel", "빠른 해주")
t("Killed Ben Cruthdar the Cursed while saving all the lumberjacks.", "한 명의 나무꾼도 죽게 두지 않고 저주받은 자 벤 크루스달을 처치했다.")
t("Eye of the storm", "폭풍의 눈")
t("Freed Derth from the onslaught of the mad Tempest, Urkis.", "미친 폭풍술사 우르키스로부터 데르스를 해방시켰다.")
t("Antimagic!", "반마법!")
t("Completed antimagic training in the Ziguranth camp.", "지구르의 캠프에서 반마법 훈련을 마쳤다.")
t("Anti-Antimagic!", "반-반마법!")
t("Destroyed the Ziguranth camp with your Rhaloren allies.", "랄로레 아군들과 함께 지구르의 캠프를 파괴했다.")
t("There and back again", "또 다시 그곳에")
t("Opened a portal to Maj'Eyal from the Far East.", "마즈'에이얄에서 동쪽 대륙으로 통하는 차원문을 열었다.")
t("Back and there again", "다시 또 그곳에")
t("Opened a portal to the Far East from Maj'Eyal.", "동쪽 대륙에서 마즈'에이얄로 통하는 차원문을 열었다.")
t("Arachnophobia", "거미 공포증")
t("Destroyed the spydric menace.", "위협적인 거미들을 제거했다.")
t("Clone War", "클론 전쟁")
t("Destroyed your own Shade.", "자기 자신의 그림자를 파괴했다.")
t("Home sweet home", "즐거운 나의 집")
t("Dispatched the Weirdling Beast and took possession of Yiilkgur, the Sher'Tul Fortress for your own usage.", "기이한 짐승을 해치우고 쉐르'툴 요새 일크구르의 소유권을 얻었다.")
t("Squadmate", "전우")
t("Escaped from Reknor alive with your squadmate Norgan.", "같은 분대원 노르간과 함께 레크노르에서 무사히 탈출했다.")
t("Genocide", "종족 학살")
t("Killed the Orc Greatmother in the breeding pits, thus dealing a terrible blow to the orc race.", "번식 구덩이의 오크 큰어미를 처치해 오크들에게 막대한 피해를 입혔다.")
t("Savior of the damsels in distress", "고통받은 소녀의 구원자")
t("Saved Melinda from her terrible fate in the Crypt of Kryl-Feijan.", "크릴-페이얀의 지하묘지에서 끔찍한 운명에 처한 멜린다를 구해냈다.")
t("Impossible Death", "불가능한 죽음")
t("Got killed by your future self.", "미래의 자기 자신에게 처치당했다.")
t("Self-killer", "스스로를 죽인 자")
t("Killed your future self.", "미래의 자신을 처치했다.")
t("Paradoxology", "역설")
t("Both killed your future self and got killed by your future self.", "미래의 자기 자신에게 처치당하는 동시에 미래의 자신을 처치했다.")
t("Explorer", "탐험가")
t("Used the Sher'Tul fortress exploratory farportal at least 7 times with the same character.", "한 캐릭터로 쉐르'툴 요새의 탐험용 차원문을 7차례 이상 이용했다.")
t("Orbituary", "궤도를 안정화하다")
t("Stabilized the Abashed Expanse to maintain it in orbit.", "너무나 광활한 공간을 궤도에 안정화시켰다.")
t("Wibbly Wobbly Timey Wimey Stuff", "뒤죽박죽 엉망진창인 시간")
t("Killed the weaver queen and the temporal defiler.", "무당거미 여왕과 시간의 모독자를 처치했다.")
t("Matrix style!", "매트릭스처럼!")
t("Finished the whole Abashed Expanse zone without being hit by a single void blast or manaworm. Dodging's fun!", "너무나도 광활한 공간을 단 한 번도 공허의 돌풍이나 마나 벌레에게 피격당하지 않고 통과했다. 피하는 건 재미있어!")
t("The Right thing to do", "옳은 일")
t("Did the righteous thing in the ring of blood and disposed of the Blood Master.", "피의 투기장에서 올바른 일을 하고 투기장의 주인을 처치했다.")
t("Thralless", "노예는 없다")
t("Freed at least 30 enthralled slaves in the slavers' compound.", "노예 수용소에서 30명 이상의 매혹된 노예를 해방했다.")
t("Lost in translation", "전송 중 실종")
t("Destroyed the naga portal in the slazish fens and got caught in the after-effect.", "슬라지쉬 늪지의 나가 관문을 파괴하고 그 후폭풍에 휩쓸렸다.")
t("Dreaming my dreams", "꿈을 꾸다")
t("Experienced and completed all the dreams in the Dogroth Caldera.", "도그로스 화산 분지에서 모든 꿈을 경험하고 완료했다.")
t("Oozemancer", "점액술사")
t("Destroyed the corrupted oozemancer.", "타락한 점액술사를 처치했다.")
t("Lucky Girl", "운 좋은 소녀")
t("Saved Melinda again and invited her to the Fortress to cure her.", "멜린다를 다시 한 번 구해 주고 그녀를 치유하기 위해 요새로 초대했다.")


------------------------------------------------
section "game/modules/tome/data/achievements/talents.lua"

t("Pyromancer", "화염술사")
t("Unlocked Archmage class and did over one million fire damage (with any item/talent/class).", "마도사를 해금한 뒤 (아무 아이템/기술/직업으로나) 누적 100만 점 이상의 화염 피해를 입혔다.")
t("Cryomancer", "냉기술사")
t("Unlocked Archmage class and did over one million cold damage (with any item/talent/class).", "마도사를 해금한 뒤 (아무 아이템/기술/직업으로나) 누적 100만 점 이상의 냉기 피해를 입혔다.")
t("Lichform", "리치 형상")
t("Achieved your wild dreams of power and eternal life: you turned into a Lich!", "힘과 영생을 향한 당신의 야망은 이루어졌다: 당신은 리치가 되었다!")
t("Best album ever!", "'더 큐어' 아시는구나!")
t("Removed 89 beneficial effects from enemies via Disintegration.", "'Disintegration' 기술로 적으로부터 '89'개의 이로운 효과를 제거했다.")


------------------------------------------------
section "game/modules/tome/data/birth/classes/adventurer.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/afflicted.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/celestial.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/chronomancer.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/corrupted.lua"

t("Reaver", "약탈자")


------------------------------------------------
section "game/modules/tome/data/birth/classes/mage.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/none.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/psionic.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/rogue.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/warrior.lua"

t("Berserker", "광전사")


------------------------------------------------
section "game/modules/tome/data/birth/classes/wilder.lua"

t("Oozemancer", "점액술사")


------------------------------------------------
section "game/modules/tome/data/birth/descriptors.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/construct.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/dwarf.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/elf.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/giant.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/halfling.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/human.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/undead.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/yeek.lua"



------------------------------------------------
section "game/modules/tome/data/birth/sexes.lua"



------------------------------------------------
section "game/modules/tome/data/birth/worlds.lua"



------------------------------------------------
section "game/modules/tome/data/calendar_allied.lua"



------------------------------------------------
section "game/modules/tome/data/calendar_dwarf.lua"



------------------------------------------------
section "game/modules/tome/data/chats/alchemist-derth.lua"



------------------------------------------------
section "game/modules/tome/data/chats/alchemist-elvala.lua"



------------------------------------------------
section "game/modules/tome/data/chats/alchemist-golem.lua"

t("Name", "이름")


------------------------------------------------
section "game/modules/tome/data/chats/alchemist-hermit.lua"



------------------------------------------------
section "game/modules/tome/data/chats/alchemist-last-hope.lua"



------------------------------------------------
section "game/modules/tome/data/chats/angolwen-leader.lua"



------------------------------------------------
section "game/modules/tome/data/chats/angolwen-staves-store.lua"



------------------------------------------------
section "game/modules/tome/data/chats/antimagic-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ardhungol-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ardhungol-start.lua"



------------------------------------------------
section "game/modules/tome/data/chats/arena-start.lua"



------------------------------------------------
section "game/modules/tome/data/chats/arena-unlock.lua"

t([[#LIGHT_GREEN#*A tall, hooded man stares at you*#WHITE#
Yes...yes...you look like a promising warrior indeed...
I have an offer, @playerdescriptor.race@.
You see...I am an agent for the Arena. I look for promising warriors that
can provide a good show for our audience. Perhaps you are strong enough to join.
All you need to do is beat three of my men in battle, and you shall be rewarded.
#LIGHT_GREEN#*You consider the offer of the mysterious hooded man for a moment*
]], [[#LIGHT_GREEN#*키가 크고, 후드를 뒤집어 쓴 남자가 당신을 쳐다봅니다.*#WHITE#
좋아...좋아... 자넨 정말 대단한 전사가 될 것 같구만...
제안 하나 하겠네, @playerdescriptor.race@.
자네도 알겠지만... 나는 투기장에서 일하는 중개인이라네. 
나는 관객들의 재미를 보장할 수 있는 전사를 찾고 있다네. 자네도 한번 참가해보면 좋을 것 같구만.
*전투에서 3명만 제압한다면 보상을 받을 걸세.
#LIGHT_GREEN#*당신은 후드를 쓴 신비한 남자의 제안을 잠시 고민합니다.*
]])
t("Interesting. Tell me more about that Arena.", "흥미롭군. 투기장에 대해 조금 더 알려줘.")
t("I am strong! What do you have to offer?", "좋아! 보상은 뭐지?")
t("I don't accept deals from shady hooded men.", "후드 뒤집어 쓴 수상한 남자의 제안따윈 수락하지 않아.")
t([[#LIGHT_GREEN#*You can feel the man smiling from inside his hood*#WHITE#
I have wealth and glory to offer, and some very useful
#YELLOW#combat experience#WHITE# from fighting our men...
So, what do you think? Are you up to it?
]], [[#LIGHT_GREEN#*후드를 쓴 남자가 웃고 있음을 느낄 수 있습니다.*#WHITE#
부와 명예를 약속하지, 그리고 아주 유용한 몇 가지 
#YELLOW#전투 경험#WHITE#도 전수해주도록 하마...
그럼, 참가해볼텐가?
]])
t([[#LIGHT_GREEN#*You can feel the man smiling from inside his hood*#WHITE#
The Arena is where the brave come to fight against all odds.
We are still growing up, and we lack challengers...
It's like a gamble, but you use your fighting instead of money to play, you see?
We in the Arena work hard to make a good show, and in return...you can get enough
wealth and glory to last for centuries!
If you can pass my little test...I will #LIGHT_RED#allow you to join the Arena when
you are done with your adventures.#WHITE#
You also shall gather some much needed #LIGHT_RED#combat experience#WHITE# from fighting
our men...so, what do you think? Are you up to it?
]], [[#LIGHT_GREEN#*후드를 쓴 남자가 웃고 있음을 느낄 수 있습니다.*#WHITE#
Arena는 모든 역경을 이겨낼 수 있는 용감한 사람이 찾아오는 곳이지.
규모는 점점 커져가는데, 도전자가 부족하다네...
도박이나 매한가지지만, 돈 대신 전투력을 사용할 뿐이지.
투기장에서 좋은 구경거리를 보여준다면, 그 대가로... 몇 백년동안 이어질 부와 영광을 
얻을 수 있을 걸세.
이 간단한 시험만 통과한다면... 
너는 #LIGHT_RED#투기장에 들어갈 수 있을 걸세.#WHITE#
또한 필요한 #LIGHT_RED#전투 경험#WHITE#도 얻을 수 있을 것이야.
그럼, 참가해볼텐가?
]])
t("I am ready for battle. Let's go!", "싸울 준비는 이미 끝났어. 출발하지!")
t("I don't have time for games, Cornac.", "구경거리가 될 시간 따윈 없어, 코르낙.")
t([[#LIGHT_GREEN#*The man lets out a disappointed sigh*#WHITE#
That's unfortunate. We could have used someone like you.
You are just the type the audience likes. You could have been a champion.
Alas, if you stand by your choice, we shall never meet again.
However, if you change your mind...I will #YELLOW#stay in Derth just a little
longer.#WHITE#
If I am still around, we can have a deal. Think about it, @playerdescriptor.race@.
]], [[#LIGHT_GREEN#*남자는 실망의 한숨을 내뱉었다.*#WHITE#
안됐구만. 당신 같은 부류는 정말 제대로 해낼텐데 말이야.
딱 관중들이 좋아할 타입이야. 자네는 챔피언이 될 수도 있었다네.
아아... 자네의 뜻이 그렇다면, 우리는 다시 만날 일은 없겠군.
하지만, 혹시나 자네의 생각이 바뀐다면... 나는 #YELLOW#데르스에 잠깐 더 머무를 
생각이라네.#WHITE#
지나다니다가 내가 아직도 보인다면, 아직은 기회가 있는 셈이야. 다시 한번 생각해보는게 좋을 걸세, @playerdescriptor.race@.
]])
t("We'll see. [Leave]", "두고보지. [떠난다]")
t([[#LIGHT_GREEN#*The man smiles in approval*#WHITE#
Excellent! A great fighter is always willing to head into battle.
You certainly won't regret meeting us, indeed...
So, are you ready to fight?
]], [[#LIGHT_GREEN#*남자는 허락하는 듯한 미소를 짓고 있다.*#WHITE#
잘됐군! 역시 위대한 싸움꾼은 전투를 좋아한다니까.
당신은 절대로 후회하지 않을걸세...
그럼, 싸울 준비가 되었는가?
]])
t("Sounds like fun. I'm ready!", "재밌어 보이는군, 시작하지!")
t("Wait. I am not ready yet.", "잠깐. 아직 준비되지 않았어.")
t("#LIGHT_GREEN#*The man quietly walks away, after making you a gesture to follow him*", "#LIGHT_GREEN#*남자는 조용히 따라오라는 신호를 보내고 자리를 옮긴다.*")
t("[Follow him]", "[따라간다]")
t("Defeat all three enemies!", "3명의 적을 모두 격파하라!")
t("Get ready!", "준비!")
t([[#LIGHT_GREEN#*The Cornac rogue comes back from the shadows*#WHITE#
Well done, @playerdescriptor.race@! I knew you had potential.
#LIGHT_GREEN#*The rogue takes off his hood, showing a fairly young, but unmistakably
#LIGHT_GREEN#battle-hardened man.#WHITE#
The name's Rej. I work for the arena to recruit great fighters who can give a
good show... and not die in two blows. You are one of those, indeed!
I won't keep you away from your adventures. I was there too, long ago.
But we can make you a true champion, beloved by many and bathing in diamonds.

#LIGHT_GREEN#*As you travel back to Derth in company of the rogue, you discuss your
#LIGHT_GREEN#battles in the forest. He provides you with great insight on your combat technique (#WHITE#+2 generic talent points#LIGHT_GREEN#)*
#WHITE#Very well, @playername@. I must go now.
Good luck in your adventures, and come visit us when you are done!
]], [[#LIGHT_GREEN#*코르낙 도적이 그림자 속에서 나타납니다.*#WHITE#
잘했군, @playerdescriptor.race@! 해낼 줄 알았지,
#LIGHT_GREEN#*도적이 후드를 벗자, 꽤나 젊지만 틀림없이
#LIGHT_GREEN#전투로 단련된 남자임이 드러납니다.#WHITE#
난 레이라고 하네. 투기장에서 실력을 보여줄 위대한 싸움꾼들을 
찾고 있지... 자네 또한 대단한 싸움꾼인 것 같군!
자네의 모험을 방해할 생각은 없다네. 나 또한 머나먼 옛날에는 모험 꽤나 다녔었지.
하지만 우린 자네를 진정한 투사로 만들어 줄 수 있다네, 많은 사람들의 사랑을 받으며 다이아몬드로 샤워할 수도 있을테야.

#LIGHT_GREEN#*도적들과 함께 데르스로 돌아가면서, 숲에서의 전투에 대해
#LIGHT_GREEN#이야기를 나눕니다. 대화를 통해 전투 기술에 대한 통찰력을 얻었습니다.(#WHITE# 일반 기술 점수 +2 #LIGHT_GREEN#)*
#WHITE#좋아, @playername@. 난 이제 가봐야 하네.
모험에 행운이 가득하길, 그리고 모험이 끝나고 나면 찾아오게!
]])
t("I will. Farewell for now.", "그러도록 하지. 잘 지내길.")
t("exit to Derth", "데르스로 이동")
t("Select the party member to receive the +2 generic talent points:", "일반 기술 점수 2점을 받을 파티원을 선택하여 주세요.")
t("#WHITE#I see. I will be waiting... #YELLOW#But not for long.", "#WHITE#알겠네. 기다리고 있겠네... #YELLOW#하지만 오래는 못 기다린다네.")
t([[#LIGHT_GREEN#*The Cornac rogue displays a welcoming smile*#WHITE#
Welcome back, @playerdescriptor.race@. Have you reconsidered my generous offer?
]], [[#LIGHT_GREEN#*코르낙 도적이 환영하며 미소를 짓습니다.*#WHITE#
잘 왔네, @playerdescriptor.race@. 나의 제안은 다시 생각해봤소?
]])
t("Yes, tell me more.", "그래, 좀 더 이야기해줘.")
t("No, see you.", "아니, 잘 가.")
t([[Welcome back, @playerdescriptor.race@. Are you ready to go?
]], [[잘 왔네, @playerdescriptor.race@. 출발할 준비 되었소?
]])
t("Let's go, Cornac.", "출발하지, 코르낙.")
t("Just a minute. I have to prepare my equipment.", "잠깐, 장비 정리 좀 하겠네.")


------------------------------------------------
section "game/modules/tome/data/chats/arena.lua"



------------------------------------------------
section "game/modules/tome/data/chats/artifice-mastery.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/chats/artifice.lua"



------------------------------------------------
section "game/modules/tome/data/chats/assassin-lord-thieves.lua"



------------------------------------------------
section "game/modules/tome/data/chats/assassin-lord.lua"



------------------------------------------------
section "game/modules/tome/data/chats/chronomancy-bias-weave.lua"



------------------------------------------------
section "game/modules/tome/data/chats/chronomancy-see-threads.lua"



------------------------------------------------
section "game/modules/tome/data/chats/command-staff.lua"



------------------------------------------------
section "game/modules/tome/data/chats/conclave-vault-greeting.lua"



------------------------------------------------
section "game/modules/tome/data/chats/corruptor-quest.lua"



------------------------------------------------
section "game/modules/tome/data/chats/derth-attack-over.lua"



------------------------------------------------
section "game/modules/tome/data/chats/dreadfell-ambush.lua"



------------------------------------------------
section "game/modules/tome/data/chats/east-portal-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/eidolon-plane.lua"



------------------------------------------------
section "game/modules/tome/data/chats/elisa-orb-scrying.lua"



------------------------------------------------
section "game/modules/tome/data/chats/elisa-shop.lua"



------------------------------------------------
section "game/modules/tome/data/chats/escort-quest-start.lua"



------------------------------------------------
section "game/modules/tome/data/chats/escort-quest.lua"

t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/chats/fallen-aeryn.lua"



------------------------------------------------
section "game/modules/tome/data/chats/gates-of-morning-main.lua"



------------------------------------------------
section "game/modules/tome/data/chats/gates-of-morning-welcome.lua"



------------------------------------------------
section "game/modules/tome/data/chats/golbug-explains.lua"



------------------------------------------------
section "game/modules/tome/data/chats/jewelry-store.lua"



------------------------------------------------
section "game/modules/tome/data/chats/keepsake-berethh-encounter.lua"



------------------------------------------------
section "game/modules/tome/data/chats/keepsake-caravan-destroyed.lua"



------------------------------------------------
section "game/modules/tome/data/chats/keepsake-kyless-death.lua"



------------------------------------------------
section "game/modules/tome/data/chats/last-hope-elder.lua"



------------------------------------------------
section "game/modules/tome/data/chats/last-hope-lost-merchant.lua"

t("Name", "이름")


------------------------------------------------
section "game/modules/tome/data/chats/last-hope-melinda-father.lua"



------------------------------------------------
section "game/modules/tome/data/chats/last-hope-weapon-store.lua"



------------------------------------------------
section "game/modules/tome/data/chats/limmir-valley-moon.lua"



------------------------------------------------
section "game/modules/tome/data/chats/lost-merchant.lua"



------------------------------------------------
section "game/modules/tome/data/chats/lumberjack-quest-done.lua"



------------------------------------------------
section "game/modules/tome/data/chats/lumberjack-quest.lua"



------------------------------------------------
section "game/modules/tome/data/chats/mage-apprentice-quest.lua"



------------------------------------------------
section "game/modules/tome/data/chats/magic-store.lua"



------------------------------------------------
section "game/modules/tome/data/chats/melinda-beach-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/melinda-beach.lua"



------------------------------------------------
section "game/modules/tome/data/chats/melinda-fortress.lua"



------------------------------------------------
section "game/modules/tome/data/chats/message-last-hope.lua"



------------------------------------------------
section "game/modules/tome/data/chats/myssil.lua"



------------------------------------------------
section "game/modules/tome/data/chats/norgan-saved.lua"



------------------------------------------------
section "game/modules/tome/data/chats/orc-breeding-pits.lua"



------------------------------------------------
section "game/modules/tome/data/chats/paradoxology.lua"



------------------------------------------------
section "game/modules/tome/data/chats/player-inscription.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/chats/point-zero-zemekkys.lua"



------------------------------------------------
section "game/modules/tome/data/chats/pre-charred-scar-eruan.lua"



------------------------------------------------
section "game/modules/tome/data/chats/pre-charred-scar.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ring-of-blood-master.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ring-of-blood-orb.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ring-of-blood-win.lua"



------------------------------------------------
section "game/modules/tome/data/chats/sage-kitty.lua"



------------------------------------------------
section "game/modules/tome/data/chats/shadow-crypt-yeek-clone.lua"



------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-butler.lua"



------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-caldizar.lua"



------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-command-orb.lua"

t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-gladium-orb.lua"

t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-shimmer.lua"



------------------------------------------------
section "game/modules/tome/data/chats/shertul-fortress-training-orb.lua"

t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/modules/tome/data/chats/slasul.lua"



------------------------------------------------
section "game/modules/tome/data/chats/sorcerer-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/sorcerer-fight.lua"

t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")


------------------------------------------------
section "game/modules/tome/data/chats/tannen.lua"



------------------------------------------------
section "game/modules/tome/data/chats/tarelion-start-archmage.lua"



------------------------------------------------
section "game/modules/tome/data/chats/tarelion.lua"



------------------------------------------------
section "game/modules/tome/data/chats/temporal-rift-end.lua"



------------------------------------------------
section "game/modules/tome/data/chats/temporal-rift-start.lua"



------------------------------------------------
section "game/modules/tome/data/chats/the-master-resurrect.lua"



------------------------------------------------
section "game/modules/tome/data/chats/trap-priming.lua"



------------------------------------------------
section "game/modules/tome/data/chats/tutorial-start.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ukllmswwik.lua"



------------------------------------------------
section "game/modules/tome/data/chats/undead-start-game.lua"



------------------------------------------------
section "game/modules/tome/data/chats/undead-start-kill.lua"



------------------------------------------------
section "game/modules/tome/data/chats/unremarkable-cave-bosses.lua"



------------------------------------------------
section "game/modules/tome/data/chats/unremarkable-cave-fillarel.lua"



------------------------------------------------
section "game/modules/tome/data/chats/unremarkable-cave-krogar.lua"



------------------------------------------------
section "game/modules/tome/data/chats/ward.lua"



------------------------------------------------
section "game/modules/tome/data/chats/worldly-knowledge.lua"



------------------------------------------------
section "game/modules/tome/data/chats/yeek-wayist.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zemekkys-done.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zemekkys-start-chronomancers.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zemekkys.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zigur-mindstar-store.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zigur-trainer.lua"



------------------------------------------------
section "game/modules/tome/data/chats/zoisla.lua"



------------------------------------------------
section "game/modules/tome/data/damage_types.lua"

t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/factions.lua"



------------------------------------------------
section "game/modules/tome/data/general/encounters/fareast-npcs.lua"



------------------------------------------------
section "game/modules/tome/data/general/encounters/fareast.lua"



------------------------------------------------
section "game/modules/tome/data/general/encounters/maj-eyal-npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/encounters/maj-eyal.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/antimagic-bush.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/bligthed-soil.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/conclave-vault.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/cultists.lua"

t("Shasshhiy'Kaish", "샤쉬'카이쉬")


------------------------------------------------
section "game/modules/tome/data/general/events/damp-cave.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/drake-cave.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/fearscape-portal.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/fell-aura.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/font-life.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/glimmerstone.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/glowing-chest.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/meteor.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/naga-portal.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/necrotic-air.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/noxious-caldera.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/old-battle-field.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/protective-aura.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/rat-lich.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/slimey-pool.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/sludgenest.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/snowstorm.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/spellblaze-scar.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/sub-vault.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/thunderstorm.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/tombstones.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/weird-pedestals.lua"



------------------------------------------------
section "game/modules/tome/data/general/events/whistling-vortex.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/autumn_forest.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/basic.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/bone.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/burntland.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/cave.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/crystal.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/elven_forest.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/forest.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/fortress.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/gothic.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/ice.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/icecave.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/jungle.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/jungle_hut.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/lava.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/mountain.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/psicave.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/sand.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/sanddunes.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/slime.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/slimy_walls.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/snowy_forest.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/underground_dreamy.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/underground_gloomy.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/underground_slimy.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/void.lua"



------------------------------------------------
section "game/modules/tome/data/general/grids/water.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ant.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/aquatic_critter.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/aquatic_demon.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/bear.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/bird.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/bone-giant.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/general/npcs/canine.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/cold-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/construct.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/crystal.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/elven-caster.lua"

t("humanoid", "인간형")
t("shalore", "샬로레")


------------------------------------------------
section "game/modules/tome/data/general/npcs/elven-warrior.lua"

t("humanoid", "인간형")
t("shalore", "샬로레")


------------------------------------------------
section "game/modules/tome/data/general/npcs/faeros.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/feline.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/fire-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ghost.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ghoul.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/gwelgoroth.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/horror-corrupted.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/horror-undead.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/horror.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/horror_aquatic.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/horror_temporal.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/humanoid_random_boss.lua"

t("humanoid", "인간형")
t("human", "인간")
t("thalore", "탈로레")
t("shalore", "샬로레")
t("halfling", "하플링")
t("dwarf", "드워프")
t("giant", "거인")
t("ogre", "오우거")


------------------------------------------------
section "game/modules/tome/data/general/npcs/jelly.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/lich.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/losgoroth.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/major-demon.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/minor-demon.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/minotaur.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/general/npcs/molds.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/multihued-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/mummy.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/naga.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/ogre.lua"

t("giant", "거인")
t("ogre", "오우거")


------------------------------------------------
section "game/modules/tome/data/general/npcs/ooze.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-gorbat.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-grushnak.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-rak-shor.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-vor.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/orc.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/plant.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ritch.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/rodent.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/sandworm.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/shade.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/shertul.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/shivgoroth.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/skeleton.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/snake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/snow-giant.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/general/npcs/spider.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/storm-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/sunwall-town.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/swarm.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/telugoroth.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/thieve.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/troll.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/general/npcs/undead-rat.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/vampire.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/venom-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/vermin.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/wight.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/wild-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/xorn.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/yaech.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/general/npcs/ziguranth.lua"

t("human", "인간")
t("humanoid", "인간형")
t("dwarf", "드워프")
t("thalore", "탈로레")


------------------------------------------------
section "game/modules/tome/data/general/objects/2haxes.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/2hmaces.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/2hswords.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/2htridents.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/axes.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/boss-artifacts-far-east.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/boss-artifacts-maj-eyal.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/boss-artifacts.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/bows.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/brotherhood-artifacts.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/cloak.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/cloth-armors.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/digger.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/ammo.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/amulets.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/armor.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/belt.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/boots.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/bow.lua"

t("dex", "민첩")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/charged-attack.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/charged-defensive.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/charged-utility.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/charms.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/cloak.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/digger.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/gloves.lua"

t("dex", "민첩")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/heavy-armor.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/helm.lua"

t("con", "체격")
t("dex", "민첩")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/infusions.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/light-armor.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/light-boots.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/lite.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/massive-armor.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/mindstars.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/potions.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/ranged.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/rings.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/robe.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/scrolls.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/shield.lua"

t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/sling.lua"

t("halfling", "하플링")


------------------------------------------------
section "game/modules/tome/data/general/objects/egos/staves.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/torques-powers.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/totems-powers.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/wands-powers.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/wands.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/weapon.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/wizard-hat.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/elixir-ingredients.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/gauntlets.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/gem.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/gloves.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/heavy-armors.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/heavy-boots.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/helms.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/jewelry.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/knifes.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/leather-belt.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/leather-boots.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/leather-caps.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/light-armors.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lites.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lore/fun.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lore/maj-eyal.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lore/misc.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lore/spellhunt.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/lore/sunwall.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/maces.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/massive-armors.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/mindstars.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/misc-tools.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/money.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/mounts.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/mummy-wrappings.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/objects-far-east.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/potions.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/quest-artifacts.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/ammo.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/generic.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/gloves.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/melee.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/ranged.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/shields.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/staves.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/rods.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/scrolls.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/shields.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/slings.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/special-artifacts.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/staves.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/swords.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/torques.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/totems.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/wands.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/whips.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/wizard-hat.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/world-artifacts-far-east.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/world-artifacts-maj-eyal.lua"

t("Genocide", "종족 학살")


------------------------------------------------
section "game/modules/tome/data/general/objects/world-artifacts.lua"



------------------------------------------------
section "game/modules/tome/data/general/stores/basic.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/alarm.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/annoy.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/complex.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/elemental.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/natural_forest.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/store.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/teleport.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/temporal.lua"



------------------------------------------------
section "game/modules/tome/data/general/traps/water.lua"



------------------------------------------------
section "game/modules/tome/data/ingredients.lua"



------------------------------------------------
section "game/modules/tome/data/keybinds/tome.lua"



------------------------------------------------
section "game/modules/tome/data/lore/age-allure.lua"



------------------------------------------------
section "game/modules/tome/data/lore/age-pyre.lua"



------------------------------------------------
section "game/modules/tome/data/lore/angolwen.lua"



------------------------------------------------
section "game/modules/tome/data/lore/ardhungol.lua"



------------------------------------------------
section "game/modules/tome/data/lore/arena.lua"



------------------------------------------------
section "game/modules/tome/data/lore/blighted-ruins.lua"



------------------------------------------------
section "game/modules/tome/data/lore/daikara.lua"



------------------------------------------------
section "game/modules/tome/data/lore/derth.lua"



------------------------------------------------
section "game/modules/tome/data/lore/dreadfell.lua"



------------------------------------------------
section "game/modules/tome/data/lore/elvala.lua"



------------------------------------------------
section "game/modules/tome/data/lore/fearscape.lua"



------------------------------------------------
section "game/modules/tome/data/lore/fun.lua"



------------------------------------------------
section "game/modules/tome/data/lore/high-peak.lua"



------------------------------------------------
section "game/modules/tome/data/lore/infinite-dungeon.lua"



------------------------------------------------
section "game/modules/tome/data/lore/iron-throne.lua"



------------------------------------------------
section "game/modules/tome/data/lore/keepsake.lua"



------------------------------------------------
section "game/modules/tome/data/lore/kor-pul.lua"



------------------------------------------------
section "game/modules/tome/data/lore/last-hope.lua"



------------------------------------------------
section "game/modules/tome/data/lore/maze.lua"



------------------------------------------------
section "game/modules/tome/data/lore/misc.lua"



------------------------------------------------
section "game/modules/tome/data/lore/noxious-caldera.lua"



------------------------------------------------
section "game/modules/tome/data/lore/old-forest.lua"



------------------------------------------------
section "game/modules/tome/data/lore/orc-prides.lua"

t("The Legend of Garkul", "가르쿨의 전설")


------------------------------------------------
section "game/modules/tome/data/lore/rhaloren.lua"



------------------------------------------------
section "game/modules/tome/data/lore/sandworm.lua"



------------------------------------------------
section "game/modules/tome/data/lore/scintillating-caves.lua"



------------------------------------------------
section "game/modules/tome/data/lore/shertul.lua"



------------------------------------------------
section "game/modules/tome/data/lore/slazish.lua"



------------------------------------------------
section "game/modules/tome/data/lore/spellblaze.lua"



------------------------------------------------
section "game/modules/tome/data/lore/spellhunt.lua"



------------------------------------------------
section "game/modules/tome/data/lore/sunwall.lua"



------------------------------------------------
section "game/modules/tome/data/lore/tannen.lua"



------------------------------------------------
section "game/modules/tome/data/lore/trollmire.lua"



------------------------------------------------
section "game/modules/tome/data/lore/zigur.lua"



------------------------------------------------
section "game/modules/tome/data/maps/towns/gates-of-morning.lua"



------------------------------------------------
section "game/modules/tome/data/maps/towns/last-hope.lua"



------------------------------------------------
section "game/modules/tome/data/maps/towns/shatur.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/greater/living-weapons.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/greater/orc-hatred.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/greater/paladin-vs-vampire.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/greater/portal-vault.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/greater/sleeping-dragons.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/auto/lesser/loot-vault.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/collapsed-tower.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/greater-crypt.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/grushnak-armory.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/lava_island.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/renegade-pyromancers.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/renegade-undead.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/renegade-wyrmics.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/test.lua"



------------------------------------------------
section "game/modules/tome/data/maps/vaults/trickvault.lua"



------------------------------------------------
section "game/modules/tome/data/maps/wilderness/eyal.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/collapsed-tower.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/halfling-ruins-last.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/shertul-fortress-caldizar.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/tannen-tower-1.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/tempest-peak-top.lua"



------------------------------------------------
section "game/modules/tome/data/maps/zones/valley-moon.lua"



------------------------------------------------
section "game/modules/tome/data/mapscripts/lib/subvault.lua"



------------------------------------------------
section "game/modules/tome/data/quests/anti-antimagic.lua"



------------------------------------------------
section "game/modules/tome/data/quests/antimagic.lua"



------------------------------------------------
section "game/modules/tome/data/quests/arena-unlock.lua"



------------------------------------------------
section "game/modules/tome/data/quests/arena.lua"

t("The Arena", "투기장")


------------------------------------------------
section "game/modules/tome/data/quests/brotherhood-of-alchemists.lua"



------------------------------------------------
section "game/modules/tome/data/quests/charred-scar.lua"



------------------------------------------------
section "game/modules/tome/data/quests/deep-bellow.lua"



------------------------------------------------
section "game/modules/tome/data/quests/dreadfell.lua"



------------------------------------------------
section "game/modules/tome/data/quests/east-portal.lua"

t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/quests/escort-duty.lua"



------------------------------------------------
section "game/modules/tome/data/quests/grave-necromancer.lua"



------------------------------------------------
section "game/modules/tome/data/quests/high-peak.lua"



------------------------------------------------
section "game/modules/tome/data/quests/infinite-dungeon.lua"



------------------------------------------------
section "game/modules/tome/data/quests/keepsake.lua"



------------------------------------------------
section "game/modules/tome/data/quests/kryl-feijan-escape.lua"



------------------------------------------------
section "game/modules/tome/data/quests/lichform.lua"

t("Lichform", "리치 형상")


------------------------------------------------
section "game/modules/tome/data/quests/lightning-overload.lua"



------------------------------------------------
section "game/modules/tome/data/quests/lost-merchant.lua"



------------------------------------------------
section "game/modules/tome/data/quests/love-melinda.lua"



------------------------------------------------
section "game/modules/tome/data/quests/lumberjack-cursed.lua"



------------------------------------------------
section "game/modules/tome/data/quests/mage-apprentice.lua"



------------------------------------------------
section "game/modules/tome/data/quests/master-jeweler.lua"



------------------------------------------------
section "game/modules/tome/data/quests/orb-command.lua"



------------------------------------------------
section "game/modules/tome/data/quests/orc-breeding-pits.lua"



------------------------------------------------
section "game/modules/tome/data/quests/orc-hunt.lua"



------------------------------------------------
section "game/modules/tome/data/quests/orc-pride.lua"

t("The many Prides of the Orcs", "오크 무리의 다양한 긍지들")
t("Investigate the bastions of the Pride.", "긍지의 요새들을 조사하십시오.")
t("#LIGHT_GREEN#* You have destroyed Rak'shor.#WHITE#", "#LIGHT_GREEN#* 당신은 락'쇼르 긍지를 파괴했습니다.#WHITE#")
t("#SLATE#* Rak'shor Pride, in the west of the southern desert.#WHITE#", "#SLATE#* 남부 사막지대의 서쪽에 위치한 락'쇼르 긍지.#WHITE#")
t("#LIGHT_GREEN#* You have destroyed Vor.#WHITE#", "#LIGHT_GREEN#* 당신은 보르 긍지를 파괴했습니다.#WHITE#")
t("#SLATE#* Vor Pride, in the north east.#WHITE#", "#SLATE#* 북동쪽에 위치랑 보르 긍지.#WHITE#")
t("#LIGHT_GREEN#* You have destroyed Grushnak.#WHITE#", "#LIGHT_GREEN#* 당신은 그루쉬낙 긍지를 파괴했습니다.#WHITE#")
t("#SLATE#* Grushnak Pride, near a small mountain range in the north west.#WHITE#", "#SLATE#* 북서부의 작은 산맥 부근의 그루쉬낙 긍지.#WHITE#")
t("#LIGHT_GREEN#* You have destroyed Gorbat.#WHITE#", "#LIGHT_GREEN#* 당신은 고르뱃 긍지를 파괴했습니다.#WHITE#")
t("#SLATE#* Gorbat Pride, in a mountain range in the southern desert.#WHITE#", "#SLATE#* 남부 사막지대의 산맥에 위치한 고르뱃 긍지.#WHITE#")
t("#LIGHT_GREEN#* All the bastions of the Pride lie in ruins, their masters destroyed. High Sun Paladin Aeryn would surely be glad of the news!#WHITE#", "#LIGHT_GREEN#* 모든 긍지의 요새들은 폐허가 되어 무너졌고 그들의 주인은 멸망했습니다. 고위 태양의 기사 아에린은 이 소식을 듣고 기뻐할 것입니다.#WHITE#")


------------------------------------------------
section "game/modules/tome/data/quests/paradoxology.lua"

t("The Way We Weren't", "우리가 가지 않았던 길")
t([[You have met what seems to be a future version of yourself.
]], [[당신은 미래의 자신인 것 같은 것과 조우했습니다.
]])
t([[You tried to kill yourself to prevent you from doing something, or going somewhere... you were not very clear.
]], [[당신은 자신을 죽여 당신이 무언가를 하거나, 어딘가로 가려 하는 것을 막으려 했습니다... 당신은 이해하지 못하겠지만요.
]])
t([[You were killed by your future self, and thus this event never occured.
]], [[당신은 미래의 자신에게 죽었고, 따라서 이 사건은 일어난 적이 없습니다.
]])
t([[You killed your future self. In the future, you might wish to avoid time-traveling back to this moment...
]], [[당신은 미래의 자신을 죽였습니다. 아마 미래의 당신은 지금 이 순간으로 시간 여행하는 것을 피하려 할 겁니다...
]])
t("%s the Paradox Mage", "괴리마법사 %s")
t("A later (less fortunate?) version of %s, possibly going mad.", "미쳐가고 있는 (불행한?)미래의 %s입니다.")
t("but nobody knew why #sex# suddenly became evil", "하지만 왜 #sex#(조사) 타락했는지는 아무도 모릅니다.")
t("#LIGHT_BLUE#Killing your own future self does feel weird, but you know that you can avoid this future. Just do not time travel.", "#LIGHT_BLUE#미래의 자신을 죽이는 것은 묘한 기분을 들게 합니다. 하지만 당신은 이제 어떻게 하면 이 미래를 피할 수 있는지 알고 있습니다. 그저 시간여행을 하지 않으면 됩니다.")
t("Meet the guardian!", "수호자를 만나다!")
t("#LIGHT_BLUE#Your future self kills you! The timestreams are broken by the paradox!", "#LIGHT_BLUE#미래의 당신이 당신을 죽였습니다! 시간 선이 괴리로 인해 붕괴합니다!")
t("#LIGHT_BLUE#All those events never happened. Except they did, somewhen.", "#LIGHT_BLUE#이 모든 사건은 일어난 적이 없습니다. 언젠가 일어날 사건이란 것만 빼면.")
t("This rift in time has been created by the paradox. You dare not enter it; it could make things worse. Another Warden will have to fix your mess.", "이 시간의 균열은 괴리로 인해 발생했습니다. 상황을 더 악화시키기 싫다면 이곳에 들어가려 하지 마십시오. 다른 감시자가 당신의 실수를 고쳐줘야 할 것입니다.")


------------------------------------------------
section "game/modules/tome/data/quests/pre-charred-scar.lua"

t("Important news", "중대한 소식")
t("Orcs were spotted with the staff you seek in an arid waste in the southern desert.", "남부 사막지대의 에류안 불모지에서 흡수의 지팡이를 가진 오크 무리가 발견되었습니다.")
t("You should go investigate what is happening there.", "당신은 그곳으로 가서 어떤 일이 벌어지고 있는지 조사해야 합니다.You should go investigate what is happening there.")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")
t("Aeryn explained where the orcs were spotted.", "아에린이 오크 무리가 어디서 발견되었는지 설명해주었습니다")


------------------------------------------------
section "game/modules/tome/data/quests/rel-tunnel.lua"



------------------------------------------------
section "game/modules/tome/data/quests/ring-of-blood.lua"



------------------------------------------------
section "game/modules/tome/data/quests/shertul-fortress.lua"



------------------------------------------------
section "game/modules/tome/data/quests/spydric-infestation.lua"



------------------------------------------------
section "game/modules/tome/data/quests/staff-absorption.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-allied.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-archmage.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-dwarf.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-point-zero.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-shaloren.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-sunwall.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-thaloren.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-undead.lua"



------------------------------------------------
section "game/modules/tome/data/quests/start-yeek.lua"



------------------------------------------------
section "game/modules/tome/data/quests/starter-zones.lua"



------------------------------------------------
section "game/modules/tome/data/quests/strange-new-world.lua"



------------------------------------------------
section "game/modules/tome/data/quests/temple-of-creation.lua"



------------------------------------------------
section "game/modules/tome/data/quests/temporal-rift.lua"



------------------------------------------------
section "game/modules/tome/data/quests/trollmire-treasure.lua"



------------------------------------------------
section "game/modules/tome/data/quests/tutorial-combat-stats.lua"



------------------------------------------------
section "game/modules/tome/data/quests/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/quests/void-gerlyk.lua"



------------------------------------------------
section "game/modules/tome/data/quests/west-portal.lua"

t("There and back again", "또 다시 그곳에")


------------------------------------------------
section "game/modules/tome/data/quests/wild-wild-east.lua"



------------------------------------------------
section "game/modules/tome/data/resources.lua"



------------------------------------------------
section "game/modules/tome/data/rooms/greater_vault.lua"



------------------------------------------------
section "game/modules/tome/data/rooms/lesser_vault.lua"



------------------------------------------------
section "game/modules/tome/data/talents.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/celestial.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/chants.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/circles.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/crusader.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/celestial/eclipse.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/glyphs.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/guardian.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/hymns.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/light.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/other.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/radiance.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/star-fury.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/sun.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/sunlight.lua"



------------------------------------------------
section "game/modules/tome/data/talents/celestial/twilight.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/age-manipulation.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/anomalies.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/blade-threading.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/bow-threading.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/chronomancer.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/chronomancy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/energy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/fate-weaving.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/flux.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/gravity.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/guardian.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/induced-phenomena.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/matter.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/other.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/spacetime-folding.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/spacetime-weaving.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/speed-control.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/spellbinding.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/stasis.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/temporal-archery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/temporal-combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/temporal-hounds.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/threaded-combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/timeline-threading.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/timetravel.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/blight.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/blood.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/bone.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/corruptions.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/curses.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/hexes.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/plague.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/reaving-combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/rot.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/sanguisuge.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/scourge.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/shadowflame.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/torment.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/vile-life.lua"



------------------------------------------------
section "game/modules/tome/data/talents/corruptions/vim.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/ambush.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/artifice.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/called-shots.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/cunning.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/dirty.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/lethality.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/poisons.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/scoundrel.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/shadow-magic.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/stealth.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/survival.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/tactical.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/traps.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/advanced-shadowmancy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/cursed-aura.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/cursed-form.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/cursed.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/dark-figure.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/dark-sustenance.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/darkness.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/endless-hunt.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/fears.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/force-of-will.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/gestures.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/gloom.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/one-with-shadows.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/predator.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/primal-magic.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/punishments.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/rampage.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/shadows.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/slaughter.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/strife.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cursed/traveler.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/antimagic.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/call.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/cold-drake.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/corrosive-blades.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/dwarven-nature.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/earthen-power.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/earthen-vines.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/eyals-fury.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/fire-drake.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/fungus.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/gifts.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/harmony.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/higher-draconic.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/malleable-body.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/mindstar-mastery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/moss.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/mucus.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/ooze.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/oozing-blades.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/sand-drake.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/slime.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/storm-drake.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-advanced.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-augmentation.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-distance.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-melee.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-utility.lua"



------------------------------------------------
section "game/modules/tome/data/talents/gifts/venom-drake.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/horrors.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/inscriptions.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/misc.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/npcs.lua"

t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/misc/objects.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/races.lua"

t("shalore", "샬로레")
t("thalore", "탈로레")
t("dwarf", "드워프")
t("halfling", "하플링")
t("ogre", "오우거")


------------------------------------------------
section "game/modules/tome/data/talents/misc/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/absorption.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/augmented-mobility.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/augmented-striking.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/charged-mastery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/discharge.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/distortion.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/dream-forge.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/dream-smith.lua"

t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/psionic/dreaming.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/feedback.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/finer-energy-manipulations.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/focus.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/grip.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/kinetic-mastery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/mental-discipline.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/mentalism.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/nightmare.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/other.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/projection.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/psi-archery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/psi-fighting.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/psionic.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/psychic-assault.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/slumber.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/solipsism.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/telekinetic-combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/thermal-mastery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/thought-forms.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/trance.lua"



------------------------------------------------
section "game/modules/tome/data/talents/psionic/voracity.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/acid-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/advanced-golemancy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/advanced-necrotic-minions.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/aegis.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/aether.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/air.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/animus.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/arcane.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/conveyance.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/deeprock.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/divination.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/earth.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/eldritch-shield.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/eldritch-stone.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/energy-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/enhancement.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/explosives.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/fire-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/fire.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/frost-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/golem.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/golemancy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/grave.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/ice.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/meta.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/necrosis.lua"

t("Lichform", "리치 형상")


------------------------------------------------
section "game/modules/tome/data/talents/spells/necrotic-minions.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/nightfall.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/phantasm.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/shades.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/spells.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/staff-combat.lua"

t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/spells/stone-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/stone.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/storm.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/temporal.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/war-alchemy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/water.lua"



------------------------------------------------
section "game/modules/tome/data/talents/spells/wildfire.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/2h-assault.lua"

t("Stunning Blow", "기절의 일격")
t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})
t([[Hit the target twice with your two-handed weapon, doing %d%% damage. Each hit will try to stun the target for %d turns.
		The stun chance increases with your Physical Power.]], [[양손 무기로 대상을 공격해 %d%% 피해를 줍니다. 매 공격마다 일정 확률로 대상을 %d턴 기절시킵니다.
		기절 확률은 물리력의 영향을 받아 증가합니다.]])
t("Fearless Cleave", "대담한 가로베기")
t("You must be able to move to use this talent.", "이 기술을 사용하려면 이동할 수 있어야 합니다.")
t("Take a step toward your foes then use the momentum to cleave all creatures adjacent to you for %d%% weapon damage.", "적을 항해 한 걸음 이동하면서 가속도를 이용해 주변의 인접한 모든 대상을 가로베고 %d%% 무기 피해를 줍니다.")
t("Death Dance", "죽음의 무도")
t("You cannot use Death Dance without a two-handed weapon!", "양손 무기가 없으면 죽음의 무도를 사용할 수 없습니다!")
t([[Spin around, extending your weapon in radius %d and damaging all targets around you for %d%% weapon damage.
		At level 3 all damage done will also make the targets bleed for an additional %d%% damage over 5 turns]], [[회전하며 반경 %d칸에 무기를 뻗어 주변의 모든 대상에게 %d%% 무기 피해를 줍니다.
		레벨 3에 모든 피해가 대상에게 출혈을 유발해 5턴 동안 %d%% 추가 피해를 줍니다]])
t("Execution", "처형")
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")
t([[Takes advantage of a wounded foe to perform a killing strike.  This attack is an automatic critical hit that does %0.1f%% extra weapon damage for each %% of life the target is below maximum.
		(A victim with 30%% remaining life (70%% damaged) would take %0.1f%% weapon damage.)
		If an enemy dies from this attack then two of your talent cooldowns are reduced by 2 turns and Execution's cooldown is reset.]], [[상처입은 적을 노려 치명적인 일격을 날립니다. 이 공격은 대상의 최대 생명력에서 감소한 %% 생명력마다 %0.1f%% 추가 무기 피해를 주는 자동 치명타입니다.
		(생명력이 30%% 남은 대상(70%% 피해)은 %0.1f%% 무기 피해를 받습니다.)
		만약 이 공격으로 적이 죽으면 두 가지 기술의 쿨다운이 2턴 감소하고 처형의 쿨다운이 초기화됩니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/2hweapon.lua"

t("Death Dance", "죽음의 무도")
t("You cannot use Death Dance without a two-handed weapon!", "양손 무기가 없으면 죽음의 무도를 사용할 수 없습니다!")
t("Berserker", "광전사")
t("You cannot use Berserker without a two-handed weapon!", "양손 무기가 없으면 광전사를 사용할 수 없습니다!")
t([[You enter an aggressive battle stance, increasing Accuracy by %d and Physical Power by %d, at the cost of -10 Defense and -10 Armour.
		While berserking, you are nearly unstoppable, granting you %d%% stun and pinning resistance.
		The Accuracy bonus increases with your Dexterity, and the Physical Power bonus with your Strength.]], [[공격적인 전투 자세를 취하여 회피와 방어가 -10 감소하는 대신 명중률이 %d, 물리력이 %d 증가합니다.
		광전사 상태에서는 무엇으로도 저지할 수 없습니다. 기절과 속박 저항을 %d%% 얻습니다.
		명중률은 민첩의 영향을 받아 증가하고 물리력은 힘의 영향을 받아 증가합니다.]])
t("Warshout", "전투함성")
t("@Source@ uses Warshout.", "@Source@ 전투함성을 사용합니다.", {"가"})
t("@Source@ uses Warsqueak.", "@Source@ 전투함성을 사용합니다.", {"가"})
t("You cannot use Warshout without a two-handed weapon!", "양손 무기 없이는 전투함성을 사용할 수 없습니다!")
t("Shout your warcry in a frontal cone of radius %d. Any targets caught inside will be confused (power %d%%) for %d turns.", "전방의 원뿔 범위 %d칸에 전투함성을 외칩니다. 범위 내의 대상은 %d턴 동안 혼란 상태(위력 %d%%)에 빠집니다.", {1,3,2})
t("Death Blow", "죽음의 일격")
t("You cannot use Death Blow without a two-handed weapon!", "양손 무기 없이는 죽음의 일격을 사용할 수 없습니다!")
t("%s feels the pain of the death blow!", "%s 죽음의 일격으로 고통을 느끼고 있습니다!", {"가"})
t("%s resists the death blow!", "%s 죽음의 일격에 저항합니다!", {"가"})
t([[Tries to perform a killing blow, doing %d%% weapon damage and dealing an automatic critical hit. If the target ends up with low enough life (<20%%), it might be instantly killed.
		At level 4, it drains half your remaining stamina, and uses it to increase the blow damage by 100%% of it.
		The chance to instantly kill will increase with your Physical Power.]], [[죽음의 일격으로 %d%% 무기 피해와 자동 치명타를 가합니다. 대상의 생명력이 충분히 낮아졌다면(<20%%), 즉시 처치합니다.
		레벨 4에서 남은 체력의 절반을 쏟아부어 일격의 피해량이 100%% 증가합니다.
		즉사 확률은 물리력의 영향을 받아 증가합니다.]])
t("Stunning Blow", "기절의 일격")
t("You cannot use Stunning Blow without a two-handed weapon!", "양손 무기 없이는 기절의 일격을 사용할 수 없습니다!")
t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})
t([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target is stunned for %d turns.
		The stun chance increases with your Physical Power.]], [[무기로 대상을 공격해 %d%% 피해를 줍니다. 공격이 적중하면 대상은 %d턴 동안 기절합니다.
		기절 확률은 물리력의 영향을 받아 증가합니다.]])
t("Sunder Armour", "방어구 부수기")
t("You cannot use Sunder Armour without a two-handed weapon!", "양손 무기 없이는 방어구 부수기를 사용할 수 없습니다!!")
t([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target's armour and saves are reduced by %d for %d turns.
		Also if the target is protected by a temporary damage shield there is %d%% chance to shatter it.
		Armor reduction chance increases with your Physical Power.]], [[무기로 대상을 공격해 %d%% 피해를 줍니다. 공격이 적중하면 대상의 방어와 모든 내성이 %d턴 동안 %d 감소합니다.
		또한 대상이 일시적인 피해 보호막에 의해 보호받고 있다면, %d%% 확률로 분쇄합니다.
		방어도 감소 확률은 물리력의 영향을 받아 증가합니다.]], {1,3,2,4})
t("Sunder Arms", "무기 부수기")
t("You cannot use Sunder Arms without a two-handed weapon!", "양손 무기 없이는 무기 부수기를 사용할 수 없습니다!")
t([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target's Accuracy is reduced by %d for %d turns.
		Accuracy reduction chance increases with your Physical Power.]], [[무기로 대상을 공격해 %d%% 피해를 줍니다. 공격이 적중하면 대상의 명중률이 %d턴 동안 %d 감소합니다.
		명중률 감소 확률은 물리력의 영향을 받아 증가합니다.]], {1,3,2,4})
t("Blood Frenzy", "피의 광란")
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")
t("You cannot use Blood Frenzy without a two-handed weapon!", "양손 무기 없이는 피의 광란을 사용할 수 없습니다!")
t([[Enter a blood frenzy, draining stamina quickly (-2 stamina/turn). Each time you kill a foe while in the blood frenzy, you gain a cumulative bonus to Physical Power of %d.
		Each turn, this bonus decreases by 2.]], [[피의 광란 상태에 돌입해 빠르게 체력이 감소합니다(-2 체력/턴). 피의 광란 상태에서 적을 죽일 때마다 물리력이 %d 증가합니다.
		턴마다 보너스가 2 감소합니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/acrobatics.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/agility.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/archery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/assassination.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/battle-tactics.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/bloodthirst.lua"

t("Unstoppable", "도저히 막을 수 없습니다")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/bow.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/buckler-training.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/combat-techniques.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/combat-training.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/conditioning.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/dualweapon.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/duelist.lua"

t("You must be able to move to use this talent.", "이 기술을 사용하려면 이동할 수 있어야 합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/excellence.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/field-control.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/finishing-moves.lua"

t("%s feels the pain of the death blow!", "%s 죽음의 일격으로 고통을 느끼고 있습니다!", {"가"})
t("%s resists the death blow!", "%s 죽음의 일격에 저항합니다!", {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/techniques/grappling.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/magical-combat.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/marksmanship.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/mobility.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/munitions.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/pugilism.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/reflexes.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/skirmisher-slings.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/sling.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/sniper.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/strength-of-the-berserker.lua"

t("Warshout", "전투함성")
t("@Source@ uses Warshout.", "@Source@ 전투함성을 사용합니다.", {"가"})
t("@Source@ uses Warsqueak.", "@Source@ 전투함성을 사용합니다.", {"가"})
t([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target's armour and saves are reduced by %d for %d turns.
		Also if the target is protected by a temporary damage shield there is %d%% chance to shatter it.
		Armor reduction chance increases with your Physical Power.]], [[무기로 대상을 공격해 %d%% 피해를 줍니다. 공격이 적중하면 대상의 방어와 모든 내성이 %d턴 동안 %d 감소합니다.
		또한 대상이 일시적인 피해 보호막에 의해 보호받고 있다면, %d%% 확률로 분쇄합니다.
		방어도 감소 확률은 물리력의 영향을 받아 증가합니다.]], {1,3,2,4})
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/superiority.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/techniques.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/throwing-knives.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/thuggery.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/tireless-combatant.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/unarmed-discipline.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/unarmed-training.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/warcries.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/weaponshield.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/const.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/cun.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/dex.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/mag.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/str.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/uber.lua"



------------------------------------------------
section "game/modules/tome/data/talents/uber/wil.lua"



------------------------------------------------
section "game/modules/tome/data/talents/undeads/ghoul.lua"



------------------------------------------------
section "game/modules/tome/data/talents/undeads/skeleton.lua"



------------------------------------------------
section "game/modules/tome/data/talents/undeads/undeads.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-archmage.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-arena.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-chronomancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-cornac.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-dwarf.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-ghoul.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-halfling.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-higher.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-infinite-dungeon.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-ogre.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-orc.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-shalore.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-skeleton.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-sunwall.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-thalore.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-tutorial-combat-stats.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/texts/intro-yeek.lua"



------------------------------------------------
section "game/modules/tome/data/texts/message-last-hope.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/combat-stats-intro.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/done.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/levelup.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/melee.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/move.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/objects.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/quests.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/ranged.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc0.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc10.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc11.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc3.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc4.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc5.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc6.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc7.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc8.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-calc/calc9.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/informed1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale10.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale11.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale12.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale3.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale4.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale5.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale6.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale7.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale8.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale9.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier0.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier10.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier11.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier12.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier3.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier4.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier5.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier6.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier7.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier8.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier9.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed0.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed3.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed4.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed5.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed6.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed7.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed8.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/mechintro.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats3.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats4.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats5.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats6.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats7.1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats7.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats8.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/stats9.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/tactics1.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/tactics2.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/talents.lua"



------------------------------------------------
section "game/modules/tome/data/texts/tutorial/terrain.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-adventurer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-afflicted_cursed.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-afflicted_doomed.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-birth_transmo_chest.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-birth_zigur_sacrifice.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-campaign_arena.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-campaign_infinite_dungeon.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-chronomancer_paradox_mage.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-chronomancer_temporal_warden.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-corrupter_corruptor.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-corrupter_reaver.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-cosmetic_bikini.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-cosmetic_class_alchemist_drolem.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-cosmetic_race_dwarf_female_beard.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-cosmetic_race_human_redhead.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-difficulty_insane.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-difficulty_madness.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-divine_anorithil.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-divine_sun_paladin.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage_cryomancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage_geomancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage_necromancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage_pyromancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-mage_tempest.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-psionic_mindslayer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-psionic_solipsist.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-race_ogre.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-rogue_marauder.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-rogue_poisons.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-rogue_skirmisher.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-undead_ghoul.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-undead_skeleton.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-warrior_brawler.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-wilder_oozemancer.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-wilder_stone_warden.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-wilder_summoner.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-wilder_wyrmic.lua"



------------------------------------------------
section "game/modules/tome/data/texts/unlock-yeek.lua"



------------------------------------------------
section "game/modules/tome/data/timed_effects.lua"



------------------------------------------------
section "game/modules/tome/data/timed_effects/floor.lua"



------------------------------------------------
section "game/modules/tome/data/timed_effects/magical.lua"

t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/timed_effects/mental.lua"

t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/timed_effects/other.lua"

t("Unstoppable", "도저히 막을 수 없습니다")


------------------------------------------------
section "game/modules/tome/data/timed_effects/physical.lua"

t("Sunder Armour", "방어구 부수기")
t("Sunder Arms", "무기 부수기")
t("physical", "물리")


------------------------------------------------
section "game/modules/tome/data/wda/eyal.lua"



------------------------------------------------
section "game/modules/tome/data/zones/abashed-expanse/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/abashed-expanse/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/abashed-expanse/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/abashed-expanse/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ancient-elven-ruins/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ancient-elven-ruins/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ancient-elven-ruins/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ancient-elven-ruins/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ardhungol/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ardhungol/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ardhungol/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ardhungol/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/npcs.lua"

t("halfling", "하플링")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/npcs.lua"

t("halfling", "하플링")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/arena/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/zone.lua"

t("The Arena", "투기장")


------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/briagh-lair/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/briagh-lair/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/briagh-lair/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/charred-scar/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/charred-scar/npcs.lua"

t("shalore", "샬로레")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/charred-scar/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/crypt-kryl-feijan/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/crypt-kryl-feijan/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/crypt-kryl-feijan/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/crypt-kryl-feijan/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/daikara/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/daikara/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/daikara/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/daikara/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/deep-bellow/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/deep-bellow/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/deep-bellow/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/deep-bellow/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/demon-plane-spell/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/demon-plane-spell/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/demon-plane/grids.lua"

t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/zones/demon-plane/npcs.lua"

t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/zones/demon-plane/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/demon-plane/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell-ambush/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell-ambush/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell-ambush/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreadfell/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreams/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreams/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/dreams/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreamscape-talent/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreamscape-talent/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/eidolon-plane/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/eidolon-plane/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/eruan/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/eruan/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/eruan/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/flooded-cave/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/flooded-cave/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gladium/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gladium/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/golem-graveyard/grids.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/zones/golem-graveyard/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/golem-graveyard/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/golem-graveyard/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gorbat-pride/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gorbat-pride/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gorbat-pride/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/gorbat-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/mapscripts/last.lua"



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/mapscripts/main.lua"



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/objects.lua"

t("The Legend of Garkul", "가르쿨의 전설")


------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/halfling-ruins/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/halfling-ruins/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/halfling-ruins/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/heart-gloom/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/heart-gloom/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/heart-gloom/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/high-peak/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/high-peak/npcs.lua"

t("shalore", "샬로레")
t("human", "인간")
t("humanoid", "인간형")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")


------------------------------------------------
section "game/modules/tome/data/zones/high-peak/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/high-peak/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/illusory-castle/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/infinite-dungeon/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/infinite-dungeon/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/infinite-dungeon/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("thalore", "탈로레")


------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/lake-nur/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/lake-nur/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/lake-nur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/mark-spellblaze/grids.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/data/zones/mark-spellblaze/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/mark-spellblaze/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/mark-spellblaze/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/maze/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/maze/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/zones/maze/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/maze/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/murgol-lair/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/murgol-lair/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/norgos-lair/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/norgos-lair/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/npcs.lua"

t("humanoid", "인간형")
t("thalore", "탈로레")


------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/zones/old-forest/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/orc-breeding-pit/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/orc-breeding-pit/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/orc-breeding-pit/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/paradox-plane/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/paradox-plane/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/paradox-plane/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/paradox-plane/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rak-shor-pride/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rak-shor-pride/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rak-shor-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/npcs.lua"

t("dwarf", "드워프")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/zones/reknor/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/npcs.lua"

t("humanoid", "인간형")
t("shalore", "샬로레")


------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/npcs.lua"

t("humanoid", "인간형")
t("human", "인간")


------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ritch-tunnels/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ritch-tunnels/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ruined-dungeon/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ruined-dungeon/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ruins-kor-pul/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ruins-kor-pul/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ruins-kor-pul/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sandworm-lair/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sandworm-lair/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sandworm-lair/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/scintillating-caves/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/scintillating-caves/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/scintillating-caves/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shadow-crypt/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shadow-crypt/npcs.lua"

t("but nobody knew why #sex# suddenly became evil", "하지만 왜 #sex#(조사) 타락했는지는 아무도 모릅니다.")


------------------------------------------------
section "game/modules/tome/data/zones/shadow-crypt/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress-caldizar/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress-caldizar/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress-caldizar/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slime-tunnels/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slime-tunnels/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/south-beach/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/stellar-system-shandral/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/stellar-system-shandral/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/grids.lua"

t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/telmur/npcs.lua"

t("Back and there again", "다시 또 그곳에")


------------------------------------------------
section "game/modules/tome/data/zones/telmur/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/telmur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tempest-peak/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/tempest-peak/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temple-of-creation/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/temple-of-creation/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temple-of-creation/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temporal-reprieve-talent/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/test/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/thieves-tunnels/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/thieves-tunnels/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/npcs.lua"

t("shalore", "샬로레")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-derth/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-derth/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("halfling", "하플링")


------------------------------------------------
section "game/modules/tome/data/zones/town-derth/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-derth/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-elvala/npcs.lua"

t("humanoid", "인간형")
t("shalore", "샬로레")
t("giant", "거인")
t("ogre", "오우거")


------------------------------------------------
section "game/modules/tome/data/zones/town-elvala/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-elvala/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-elvala/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")


------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/npcs.lua"

t("dwarf", "드워프")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("halfling", "하플링")


------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-lumberjack-village/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/town-lumberjack-village/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("shalore", "샬로레")


------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/npcs.lua"

t("humanoid", "인간형")
t("thalore", "탈로레")


------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/npcs.lua"

t("halfling", "하플링")


------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/trollmire/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/trollmire/npcs.lua"

t("giant", "거인")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/trollmire/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/trollmire/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/unhallowed-morass/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/unhallowed-morass/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/unhallowed-morass/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/unhallowed-morass/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/unremarkable-cave/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/unremarkable-cave/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/valley-moon-caverns/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/valley-moon-caverns/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/valley-moon-caverns/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/valley-moon/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/valley-moon/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/valley-moon/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/void/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/void/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/void/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-armoury/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-armoury/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-armoury/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/wilderness/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/wilderness/zone.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ArenaFinish.lua"



------------------------------------------------
section "game/modules/tome/dialogs/Birther.lua"

t("Overwrite character?", "캐릭터를 덮어씌우시겠습니까?")
t("There is already a character with this name, do you want to overwrite it?", "이미 존재하는 캐릭터 명입니다만, 덮어씌우시겠습니까?")
t("Yes", "네")
t("No", "아니요")
t("Cancel", "취소")
t("Name", "이름")


------------------------------------------------
section "game/modules/tome/dialogs/CharacterSheet.lua"

t("Name", "이름")


------------------------------------------------
section "game/modules/tome/dialogs/CursedAuraSelect.lua"



------------------------------------------------
section "game/modules/tome/dialogs/DeathDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/Donation.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/GameOptions.lua"

t("Game Options", "게임 설정")
t("no", "아니요")
t("yes", "네")


------------------------------------------------
section "game/modules/tome/dialogs/GraphicMode.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/LevelupDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/LorePopup.lua"



------------------------------------------------
section "game/modules/tome/dialogs/MapMenu.lua"

t("Show inventory", "가방 보기")
t("Auto-explore", "자동 탐색")


------------------------------------------------
section "game/modules/tome/dialogs/PartyOrder.lua"



------------------------------------------------
section "game/modules/tome/dialogs/PartySelect.lua"



------------------------------------------------
section "game/modules/tome/dialogs/PartySendItem.lua"



------------------------------------------------
section "game/modules/tome/dialogs/QuestPopup.lua"



------------------------------------------------
section "game/modules/tome/dialogs/SentientWeapon.lua"

t("Constitution", "체격")
t("Dexterity", "민첩")
t("Strength", "힘")


------------------------------------------------
section "game/modules/tome/dialogs/ShowAchievements.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowChatLog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowEquipInven.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowEquipment.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowIngredients.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowInventory.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowLore.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowMap.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ShowStore.lua"



------------------------------------------------
section "game/modules/tome/dialogs/TrapsSelect.lua"



------------------------------------------------
section "game/modules/tome/dialogs/UberTalent.lua"



------------------------------------------------
section "game/modules/tome/dialogs/UnlockDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/UseItemDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/UseTalents.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceActor.lua"

t("Accept", "수락")
t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceZones.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/AlterFaction.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/ChangeZone.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateItem.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateTrap.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/DebugMain.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/debug/Endgamify.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/GrantQuest.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/PlotTalent.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/RandomActor.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/RandomObject.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/SpawnEvent.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/SummonCreature.lua"



------------------------------------------------
section "game/modules/tome/dialogs/orders/Behavior.lua"



------------------------------------------------
section "game/modules/tome/dialogs/orders/Talents.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/CommonData.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/Shimmer.lua"

t("Name", "이름")
t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerDemo.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOther.lua"

t("Name", "이름")
t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOutfits.lua"

t("Name", "이름")
t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerRemoveSustains.lua"

t("Name", "이름")
t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyContingency.lua"



------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyEmpower.lua"



------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyExtension.lua"



------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyMatrix.lua"



------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyQuicken.lua"



------------------------------------------------
section "game/modules/tome/dialogs/talents/MagicalCombatArcaneCombat.lua"



------------------------------------------------
section "game/modules/tome/init.lua"



------------------------------------------------
section "game/modules/tome/load.lua"

t("Strength", "힘")
t("str", "힘")
t("Dexterity", "민첩")
t("dex", "민첩")
t("Constitution", "체격")
t("con", "체격")


