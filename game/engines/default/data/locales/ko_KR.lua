locale "ko_KR"
-- COPYlocal function findJosaType(str)	local length = str:len()		local c1, c2	local c3 = str:lower():byte(length)		local last = 0	if ( length < 3 ) or ( c3 < 128 ) then		--@ 여기오면 일단 한글은 아님		--@ 여기에 숫자나 알파벳인지 검사해서 아니면 마지막 글자 빼고 재귀호출하는 코드 삽입 필요				if ( c3 == '1' or c3 == '7' or c3 == '8' or c3 == 'l' or c3 == 'r' ) then			last = 8 --@ 한글이 아니고, josa2를 사용하지만 '로'가 맞는 경우		elseif ( c3 == '3' or c3 == '6' or c3 == '0' or c3 == 'm' or c3 == 'n' ) then			last = 100 --@ 한글이 아니고, josa2를 사용하는 경우		end  	else --@ 한글로 추정 (정확히는 더 검사가 필요하지만..)		c1 = str:byte(length-2)		c2 = str:byte(length-1)				last = ( (c1-234)*4096 + (c2-128)*64 + (c3-128) - 3072 )%28	end		return lastendlocal function addJosa(str, temp)	local josa1, josa2, index	if temp == 1 or temp == "가" or temp == "이" then		josa1 = "가"		josa2 = "이"		index = 1	elseif temp == 2 or temp == "는" or temp == "은" then		josa1 = "는"		josa2 = "은"		index = 2	elseif temp == 3 or temp == "를" or temp == "을" then		josa1 = "를"		josa2 = "을"		index = 3	elseif temp == 4 or temp == "로" or temp == "으로" then		josa1 = "로"		josa2 = "으로"		index = 4	elseif temp == 5 or temp == "다" or temp == "이다" then		josa1 = "다"		josa2 = "이다"		index = 5	elseif temp == 6 or temp == "와" or temp == "과" then		josa1 = "와"		josa2 = "과"		index = 6	elseif temp == 7 then		josa1 = ""		josa2 = "이"		index = 7	else		if type(temp) == string then return str .. temp		else return str end 	end		local type = findJosaType(str)		if type == 0 or ( index == 4 and type == 8 ) then		return str .. josa1	else		return str .. josa2	endendsetFlag("noun_target_sub", function(str, type, noun)	if type == "#Source#" then		return str:gsub("#Source#", noun):gsub("#Source1#", addJosa(noun, "가")):gsub("#Source2#", addJosa(noun, "는")):gsub("#Source3#", addJosa(noun, "를")):gsub("#Source4#", addJosa(noun, "로")):gsub("#Source5#", addJosa(noun, "다")):gsub("#Source6#", addJosa(noun, "과")):gsub("#Source7#", addJosa(noun, 7))	elseif type == "#source#" then		return str:gsub("#source#", noun):gsub("#source#", addJosa(noun, "가")):gsub("#source2#", addJosa(noun, "는")):gsub("#source3#", addJosa(noun, "를")):gsub("#source4#", addJosa(noun, "로")):gsub("#source5#", addJosa(noun, "다")):gsub("#source6#", addJosa(noun, "과")):gsub("#source7#", addJosa(noun, 7))	elseif type == "#Target#" then		return str:gsub("#Target#", noun):gsub("#Target1#", addJosa(noun, "가")):gsub("#Target2#", addJosa(noun, "는")):gsub("#Target3#", addJosa(noun, "를")):gsub("#Target4#", addJosa(noun, "로")):gsub("#Target5#", addJosa(noun, "다")):gsub("#Target6#", addJosa(noun, "과")):gsub("#Target7#", addJosa(noun, 7))	elseif type == "#target#" then		return str:gsub("#target#", noun):gsub("#target#", addJosa(noun, "가")):gsub("#target2#", addJosa(noun, "는")):gsub("#target3#", addJosa(noun, "를")):gsub("#target4#", addJosa(noun, "로")):gsub("#target5#", addJosa(noun, "다")):gsub("#target6#", addJosa(noun, "과")):gsub("#target7#", addJosa(noun, 7))	elseif type == "@Target@" then		return str:gsub("@Target@", noun):gsub("@Target@", addJosa(noun, "가")):gsub("@Target2@", addJosa(noun, "는")):gsub("@Target3@", addJosa(noun, "를")):gsub("@Target4@", addJosa(noun, "로")):gsub("@Target5@", addJosa(noun, "다")):gsub("@Target6@", addJosa(noun, "과")):gsub("@Target7@", addJosa(noun, 7))	elseif type == "@target@" then		return str:gsub("@target@", noun):gsub("@target@", addJosa(noun, "가")):gsub("@target2@", addJosa(noun, "는")):gsub("@target3@", addJosa(noun, "를")):gsub("@target4@", addJosa(noun, "로")):gsub("@target5@", addJosa(noun, "다")):gsub("@target6@", addJosa(noun, "과")):gsub("@target7@", addJosa(noun, 7))	elseif str == "@playername@" then		return str:gsub("@playername@", noun):gsub("@playername@", addJosa(noun, "가")):gsub("@playername2@", addJosa(noun, "는")):gsub("@playername3@", addJosa(noun, "를")):gsub("@playername4@", addJosa(noun, "로")):gsub("@playername5@", addJosa(noun, "다")):gsub("@playername6@", addJosa(noun, "과")):gsub("@playername7@", addJosa(noun, 7))	elseif type == "@npcname@" then		return str:gsub("@npcname@", noun):gsub("@npcname@", addJosa(noun, "가")):gsub("@npcname2@", addJosa(noun, "는")):gsub("@npcname3@", addJosa(noun, "를")):gsub("@npcname4@", addJosa(noun, "로")):gsub("@npcname5@", addJosa(noun, "다")):gsub("@npcname6@", addJosa(noun, "과")):gsub("@npcname7@", addJosa(noun, 7))	else		return str:gsub(type, noun)	endend)setFlag("tformat_special", function(s, locales_args, special, ...)	local args	if locales_args then		local sargs = {...}		args = {}		for sidx, didx in pairs(locales_args) do			args[sidx] = sargs[didx]		end	else		args = {...}	end	s = _t(s)	for k, v in pairs(special) do		args[k] = addJosa(args[k], v)	end	return s:format(unpack(args))end)------------------------------------------------
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


------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/dialogs/ItemsVaultOffline.lua"

t("Item's Vault", "아이템 볼트")


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



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/ravenous-mind.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/timed_effects.lua"



------------------------------------------------
section "game/addons/tome-possessors/init.lua"



------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeForm.lua"



------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeFormSelectTalents.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/actions.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/chat.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/debug.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/hotkeys.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/interface.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/inventory.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/move.lua"



------------------------------------------------
section "game/engines/default/data/keybinds/mtxn.lua"



------------------------------------------------
section "game/engines/default/engine/ActorsSeenDisplay.lua"



------------------------------------------------
section "game/engines/default/engine/Birther.lua"

t("Enter your character's name", "캐릭터 이름을 입력해주세요")


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



------------------------------------------------
section "game/engines/default/engine/Trap.lua"



------------------------------------------------
section "game/engines/default/engine/UserChat.lua"



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

t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/engines/default/engine/dialogs/Downloader.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/GameMenu.lua"

t("No", "아니요")
t("Yes", "네")
t("Main Menu", "메인 메뉴")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantity.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantitySlider.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"



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



------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/UsePurchased.lua"

t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨")


------------------------------------------------
section "game/engines/default/engine/interface/ActorInventory.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorLife.lua"



------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"



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


------------------------------------------------
section "game/engines/default/engine/ui/Gestures.lua"



------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"



------------------------------------------------
section "game/engines/default/engine/ui/WebView.lua"



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



------------------------------------------------
section "game/engines/default/modules/boot/dialogs/LoadGame.lua"

t("Load Game", "게임 불러오기")


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

t("Login", "로그인")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileLogin.lua"

t("Login", "로그인")
t("Username: ", "유저명: ")
t("Password: ", "비밀번호: ")
t("Username", "유저명")
t("Your username is too short", "유저명이 너무 짧습니다.")
t("Password", "비밀번호")
t("Your password is too short", "비밀번호가 너무 짧습니다.")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileSteamRegister.lua"

t("Username: ", "유저명: ")
t("Register", "가입")
t("Username", "유저명")
t("Your username is too short", "유저명이 너무 짧습니다.")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.")


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



------------------------------------------------
section "game/modules/tome/class/FortressPC.lua"



------------------------------------------------
section "game/modules/tome/class/Game.lua"

t("#Source# hits #Target# for %s (#RED##{bold}#%0.0f#LAST##{normal}# total damage)%s.", "#Source#이(가) #Target#을(를) 공격함. %s (총 #RED##{bold}#%0.0f#LAST##{normal}# 데미지)%s.")
t("#Source# hits #Target# for %s damage.", "#Source#이(가) #Target3#을(를) 공격하여 %s 피해를 입힘.")
t("Game Options", "게임 설정")


------------------------------------------------
section "game/modules/tome/class/GameState.lua"



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



------------------------------------------------
section "game/modules/tome/class/PartyMember.lua"



------------------------------------------------
section "game/modules/tome/class/Player.lua"



------------------------------------------------
section "game/modules/tome/class/Projectile.lua"



------------------------------------------------
section "game/modules/tome/class/Store.lua"



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



------------------------------------------------
section "game/modules/tome/data/achievements/donator.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/events.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/infinite-dungeon.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/items.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/kills.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/lore.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/player.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/quests.lua"



------------------------------------------------
section "game/modules/tome/data/achievements/talents.lua"



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



------------------------------------------------
section "game/modules/tome/data/birth/classes/wilder.lua"



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



------------------------------------------------
section "game/modules/tome/data/chats/arena.lua"



------------------------------------------------
section "game/modules/tome/data/chats/artifice-mastery.lua"



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



------------------------------------------------
section "game/modules/tome/data/general/npcs/elven-warrior.lua"



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



------------------------------------------------
section "game/modules/tome/data/general/npcs/molds.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/multihued-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/mummy.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/naga.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ogre.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/ooze.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-gorbat.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-grushnak.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-rak-shor.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc-vor.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/orc.lua"



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



------------------------------------------------
section "game/modules/tome/data/general/npcs/spider.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/storm-drake.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/sunwall-town.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/swarm.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/telugoroth.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/thieve.lua"



------------------------------------------------
section "game/modules/tome/data/general/npcs/troll.lua"



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



------------------------------------------------
section "game/modules/tome/data/general/npcs/ziguranth.lua"



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



------------------------------------------------
section "game/modules/tome/data/quests/paradoxology.lua"



------------------------------------------------
section "game/modules/tome/data/quests/pre-charred-scar.lua"



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



------------------------------------------------
section "game/modules/tome/data/talents/misc/objects.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/races.lua"



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



------------------------------------------------
section "game/modules/tome/data/talents/techniques/2hweapon.lua"



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



------------------------------------------------
section "game/modules/tome/data/talents/techniques/excellence.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/field-control.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/finishing-moves.lua"



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



------------------------------------------------
section "game/modules/tome/data/timed_effects/physical.lua"

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



------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/blighted-ruins/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/demon-plane/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/grushnak-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/halfling-ruins/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/last-hope-graveyard/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/mark-spellblaze/grids.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/maze/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/maze/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/murgol-lair/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/noxious-caldera/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/old-forest/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/orc-breeding-pit/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor-escape/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/reknor/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/rhaloren-camp/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/ring-of-blood/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tannen-tower/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/telmur/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/telmur/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/telmur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tempest-peak/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tempest-peak/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temple-of-creation/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/temporal-rift/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/test/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/thieves-tunnels/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/thieves-tunnels/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-angolwen/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/town-derth/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-derth/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-elvala/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-gates-of-morning/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-irkkk/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-iron-council/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-last-hope/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-lumberjack-village/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-lumberjack-village/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-point-zero/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/traps.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-shatur/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/town-zigur/npcs.lua"



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



------------------------------------------------
section "game/modules/tome/data/zones/trollmire/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/trollmire/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/grids.lua"



------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/npcs.lua"



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


------------------------------------------------
section "game/modules/tome/dialogs/CharacterSheet.lua"



------------------------------------------------
section "game/modules/tome/dialogs/CursedAuraSelect.lua"



------------------------------------------------
section "game/modules/tome/dialogs/DeathDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/Donation.lua"



------------------------------------------------
section "game/modules/tome/dialogs/GameOptions.lua"

t("Game Options", "게임 설정")


------------------------------------------------
section "game/modules/tome/dialogs/GraphicMode.lua"



------------------------------------------------
section "game/modules/tome/dialogs/LevelupDialog.lua"



------------------------------------------------
section "game/modules/tome/dialogs/LorePopup.lua"



------------------------------------------------
section "game/modules/tome/dialogs/MapMenu.lua"



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



------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceZones.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/AlterFaction.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/ChangeZone.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateItem.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateTrap.lua"



------------------------------------------------
section "game/modules/tome/dialogs/debug/DebugMain.lua"



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



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerDemo.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOther.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOutfits.lua"



------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerRemoveSustains.lua"



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


