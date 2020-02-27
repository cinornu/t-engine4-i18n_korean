locale "ko_KR"
-- COPYlocal function findJosaType(str)	local length = str:len()		local c1, c2	local c3 = str:lower():byte(length)		local last = 0	if ( length < 3 ) or ( c3 < 128 ) then		--@ 여기오면 일단 한글은 아님		--@ 여기에 숫자나 알파벳인지 검사해서 아니면 마지막 글자 빼고 재귀호출하는 코드 삽입 필요				if ( c3 == '1' or c3 == '7' or c3 == '8' or c3 == 'l' or c3 == 'r' ) then			last = 8 --@ 한글이 아니고, josa2를 사용하지만 '로'가 맞는 경우		elseif ( c3 == '3' or c3 == '6' or c3 == '0' or c3 == 'm' or c3 == 'n' ) then			last = 100 --@ 한글이 아니고, josa2를 사용하는 경우		end  	else --@ 한글로 추정 (정확히는 더 검사가 필요하지만..)		c1 = str:byte(length-2)		c2 = str:byte(length-1)				last = ( (c1-234)*4096 + (c2-128)*64 + (c3-128) - 3072 )%28	end		return lastendlocal function addJosa(str, temp)	local josa1, josa2, index	if temp == 1 or temp == "가" or temp == "이" then		josa1 = "가"		josa2 = "이"		index = 1	elseif temp == 2 or temp == "는" or temp == "은" then		josa1 = "는"		josa2 = "은"		index = 2	elseif temp == 3 or temp == "를" or temp == "을" then		josa1 = "를"		josa2 = "을"		index = 3	elseif temp == 4 or temp == "로" or temp == "으로" then		josa1 = "로"		josa2 = "으로"		index = 4	elseif temp == 5 or temp == "다" or temp == "이다" then		josa1 = "다"		josa2 = "이다"		index = 5	elseif temp == 6 or temp == "와" or temp == "과" then		josa1 = "와"		josa2 = "과"		index = 6	elseif temp == 7 then		josa1 = ""		josa2 = "이"		index = 7	else		if type(temp) == string then return str .. temp		else return str end 	end		local type = findJosaType(str)		if type == 0 or ( index == 4 and type == 8 ) then		return str .. josa1	else		return str .. josa2	endendsetFlag("noun_target_sub", function(str, type, noun)	if type == "#Source#" then		return str:gsub("#Source#", noun):gsub("#Source1#", addJosa(noun, "가")):gsub("#Source2#", addJosa(noun, "는")):gsub("#Source3#", addJosa(noun, "를")):gsub("#Source4#", addJosa(noun, "로")):gsub("#Source5#", addJosa(noun, "다")):gsub("#Source6#", addJosa(noun, "과")):gsub("#Source7#", addJosa(noun, 7))	elseif type == "#source#" then		return str:gsub("#source#", noun):gsub("#source#", addJosa(noun, "가")):gsub("#source2#", addJosa(noun, "는")):gsub("#source3#", addJosa(noun, "를")):gsub("#source4#", addJosa(noun, "로")):gsub("#source5#", addJosa(noun, "다")):gsub("#source6#", addJosa(noun, "과")):gsub("#source7#", addJosa(noun, 7))	elseif type == "#Target#" then		return str:gsub("#Target#", noun):gsub("#Target1#", addJosa(noun, "가")):gsub("#Target2#", addJosa(noun, "는")):gsub("#Target3#", addJosa(noun, "를")):gsub("#Target4#", addJosa(noun, "로")):gsub("#Target5#", addJosa(noun, "다")):gsub("#Target6#", addJosa(noun, "과")):gsub("#Target7#", addJosa(noun, 7))	elseif type == "#target#" then		return str:gsub("#target#", noun):gsub("#target#", addJosa(noun, "가")):gsub("#target2#", addJosa(noun, "는")):gsub("#target3#", addJosa(noun, "를")):gsub("#target4#", addJosa(noun, "로")):gsub("#target5#", addJosa(noun, "다")):gsub("#target6#", addJosa(noun, "과")):gsub("#target7#", addJosa(noun, 7))	elseif type == "@Target@" then		return str:gsub("@Target@", noun):gsub("@Target@", addJosa(noun, "가")):gsub("@Target2@", addJosa(noun, "는")):gsub("@Target3@", addJosa(noun, "를")):gsub("@Target4@", addJosa(noun, "로")):gsub("@Target5@", addJosa(noun, "다")):gsub("@Target6@", addJosa(noun, "과")):gsub("@Target7@", addJosa(noun, 7))	elseif type == "@target@" then		return str:gsub("@target@", noun):gsub("@target@", addJosa(noun, "가")):gsub("@target2@", addJosa(noun, "는")):gsub("@target3@", addJosa(noun, "를")):gsub("@target4@", addJosa(noun, "로")):gsub("@target5@", addJosa(noun, "다")):gsub("@target6@", addJosa(noun, "과")):gsub("@target7@", addJosa(noun, 7))	elseif str == "@playername@" then		return str:gsub("@playername@", noun):gsub("@playername@", addJosa(noun, "가")):gsub("@playername2@", addJosa(noun, "는")):gsub("@playername3@", addJosa(noun, "를")):gsub("@playername4@", addJosa(noun, "로")):gsub("@playername5@", addJosa(noun, "다")):gsub("@playername6@", addJosa(noun, "과")):gsub("@playername7@", addJosa(noun, 7))	elseif type == "@npcname@" then		return str:gsub("@npcname@", noun):gsub("@npcname@", addJosa(noun, "가")):gsub("@npcname2@", addJosa(noun, "는")):gsub("@npcname3@", addJosa(noun, "를")):gsub("@npcname4@", addJosa(noun, "로")):gsub("@npcname5@", addJosa(noun, "다")):gsub("@npcname6@", addJosa(noun, "과")):gsub("@npcname7@", addJosa(noun, 7))	else		return str:gsub(type, noun)	endend)setFlag("tformat_special", function(s, locales_args, special, ...)	local args	if locales_args then		local sargs = {...}		args = {}		for sidx, didx in pairs(locales_args) do			args[sidx] = sargs[didx]		end	else		args = {...}	end	s = _t(s)	for k, v in pairs(special) do		args[k] = addJosa(args[k], v)	end	return s:format(unpack(args))end)------------------------------------------------
section "always_merge"

t([[Today is the %s %s of the %s year of the Age of Ascendancy of Maj'Eyal.
The time is %02d:%02d.]], [[오늘은 주도의 시대를 맞은 마즈'에이알 %s 년 %s %s 일 입니다.
현재 시간은 %02d 시 %02d 분입니다.]])


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



------------------------------------------------
section "game/addons/tome-items-vault/init.lua"

t("Items Vault", "아이템 금고")
t("Adds access to the items vault (donator feature). The items vault will let you upload a few unwanted items to your online profile and retrieve them on other characters.", "아이템 금고를 이용할 수 있는 기능을 추가합니다. (후원자 전용) 아이템 볼트에 사용하지 않는 아이템을 플레이어의 온라인 프로필로 전송하여 다른 캐릭터로 옮길 수 있습니다.")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/chats/items-vault-command-orb-offline.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 금고에 전송 시 %d 레벨의 착용 제한이 적용됩니다.")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.")
t("[Place an item in the vault]", "[금고에 아이템 보관하기]")
t("Item's Vault", "아이템 금고")
t("You can not place an item in the vault from debug mode game.", "디버그 모드에서는 아이템 금고에 아이템을 보관할 수 없습니다.")
t("Place an item in the Item's Vault", "금고에 아이템을 보관하기.")
t("Caution", "경고")
t("Continue?", "계속하시겠습니까?")
t("[Retrieve an item from the vault]", "[금고에서 아이템을 찾아오기.]")
t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/chats/items-vault-command-orb.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 금고에 전송 시 %d 레벨의 착용 제한이 적용됩니다.")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.")
t("[Place an item in the vault]", "[금고에 아이템 보관하기]")
t("Item's Vault", "아이템 금고")
t("You can not place an item in the vault from an un-validated game.", "유효하지 않은 게임의 아이템은 금고에 보관할 수 없습니다.")
t("Place an item in the Item's Vault", "금고에 아이템을 보관하기.")
t("Caution", "경고")
t("Continue?", "계속하시겠습니까?")
t("[Retrieve an item from the vault]", "[금고에서 아이템을 찾아오기.]")
t("#GOLD#I wish to help the funding of this game and donate#WHITE#", "#GOLD#나는 이 게임에 도움을 주기 위해 현금을 기부하고 싶다#WHITE#")
t("[Leave the orb alone]", "[오브를 두고 떠난다.]")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/maps/items-vault/fortress.lua"



------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/class/ItemsVaultDLC.lua"

t("Transfering...", "전송 중...")
t("Transfer failed", "전송 실패")
t("Item's Vault", "아이템 금고")


------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/dialogs/ItemsVault.lua"

t("Item's Vault", "아이템 금고")
t("Name", "이름")


------------------------------------------------
section "game/addons/tome-items-vault/overload/mod/dialogs/ItemsVaultOffline.lua"

t("Item's Vault", "아이템 금고")
t("Name", "이름")


------------------------------------------------
section "game/addons/tome-possessors/data/achievements/possessors.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/birth/psionic.lua"

t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")


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
section "game/dlcs/tome-ashes-urhrok/data/achievements/all.lua"

t("Shasshhiy'Kaish", "샤쉬'카이쉬")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/corrupted.lua"

t("Their most important stats are: Strength and Magic", "그들에게 가장 중요한 능력치는 힘과 마법입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +4 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/doomelf.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/races_cosmetic.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/events/demon-statue.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/events/fire-haven.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/grids/demon_statues.lua"

t("Shasshhiy'Kaish", "샤쉬'카이쉬")
t("floor", "바닥")
t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/grids/malrok_walls.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("door", "문")
t("wall", "벽")
t("open door", "열린 문")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/npcs/aquatic-demon.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/npcs/major-demon.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/objects/world-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/lore/demon.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/quests/re-abducted.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/quests/start-ashes.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/black-magic.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/brutality.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/corruptions.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demon-seeds.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demonic-pact.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demonic-strength.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/doom-covenant.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/doom-shield.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/fearfire.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/heart-of-fire.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/infernal-combat.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/oppression.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/spellblaze.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/torture.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/wrath.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.")
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/misc/races.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/timed_effects.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/objects.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/zone.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/objects.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/zone.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/init.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/chats/ashes-urhrok-walrog-pop.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/texts/intro-ashes-urhrok.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/texts/unlock-corrupter_demonologist.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/texts/unlock-cosmetic_doomhorns.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/texts/unlock-cosmetic_red_skin.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/texts/unlock-race_doomelf.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/mod/class/DemonologistsDLC.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/class/Actor.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/class/Game.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/dialogs/Birther.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/achievements/all.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/birth/demented.lua"

t("Their most important stats are: Strength and Magic", "그들에게 가장 중요한 능력치는 힘과 마법입니다.")
t("Their most important stats are: Magic and Cunning", "그들에게 가장 중요한 능력치는 마법과 교활입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +6 Magic, +0 Willpower, +3 Cunning", "#LIGHT_BLUE# * +6 마법, +0 의지, +3 교활")


------------------------------------------------
section "game/dlcs/tome-cults/data/birth/drem.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# 12", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 12")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")


------------------------------------------------
section "game/dlcs/tome-cults/data/birth/krog.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")


------------------------------------------------
section "game/dlcs/tome-cults/data/birth/misc.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/chats/fanged-collar.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/chats/godfeaster-malyu-escaped.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/chats/godfeaster-malyu.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/chats/space-dwarf-trinket.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/damage_types.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/factions.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/encounters/maj-eyal.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/encounters/var-eyal.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/events/digestive-sack.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/events/scourged-pits.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/events/space-dwarf-ship.lua"

t("floor", "바닥")
t("wall", "벽")
t("previous level", "이전 층")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/events/tentacle-tree.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/fonts.lua"

t("No", "아니요")
t("Yes", "네")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/fortress-ancient.lua"

t("floor", "바닥")
t("door", "문")
t("open door", "열린 문")
t("wall", "벽")
t("sealed door", "봉인된 문")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/fortress-multiverse.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/godfeaster.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/maggot.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/scourge.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/slimy_godfeaster.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/spacedwarf-creep.lua"

t("door", "문")
t("open door", "열린 문")
t("floor", "바닥")
t("wall", "벽")
t("sealed door", "봉인된 문")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/spacedwarf.lua"

t("door", "문")
t("open door", "열린 문")
t("floor", "바닥")
t("wall", "벽")
t("sealed door", "봉인된 문")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/special-cave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/grids/tentacle-tree.lua"

t("floor", "바닥")
t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/blobs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/corrupted_blobs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/horror-special-test.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/horror-special.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/horror.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/humanoid_random_boss.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/scourge-drake.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/npcs/tentacle-tree.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/objects/forbidden-tomes-base.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/objects/lore/eyal.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/objects/special-misc.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/objects/world-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/stores/cults.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/zones-alters/dreadfell.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/zones-alters/elvala.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/general/zones-alters/zigur.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/glyph_sequences/cults.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/glyph_sequences/orcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/lore/dremwarves.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/lore/fay-willows.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/lore/kroshkkur.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/lore/misc.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/lore/zones.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/quests/grung.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/quests/illusory-castle.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/quests/krogs-rescue.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/quests/start-cults.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/beyond-sanity.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/calamity.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/chronophage.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/controlled-horrors.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/demented.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/disfigured-face.lua"

t("Diseased Tongue", "병 걸린 혀")
t([[Your tongue turns into a diseased tentacle that you use to #{italic}#lick#{normal}# enemies in a cone.
		Licked creatures take %d%% tentacle damage that ignores armor and get sick, gaining a random disease for %d turns that deals %0.2f blight damage per turn and reduces strength, dexterity or constitution by %d.
		
		If at least one enemy is hit you gain %d insanity.
		
		Disease damage will increase with your Spellpower.]], [[당신의 혀가 병 걸린 촉수로 변해 원뿔 범위의 적들을 #{italic}#핥습니다.#{normal}#
		핥아진 적들은 방어력을 무시하는 %d%%의 촉수 피해를 입고, %d 턴동안 매 턴마다 %0.2f의 역병 피해를 주는 병에 걸리고, 민첩, 건강, 힘이 %d씩 감소합니다.
		
		하나의 적이라도 맞추면 당신은 %d의 광기를 획득합니다.
		
		역병 피해량은 주문력에 비례하여 증가합니다.]])
t("Dissolved Face", "녹아내린 얼굴")
t([[Your face melts, exploding in a targeted gush of blood and gore dealing %0.2f darkness damage (%0.2f total) in a cone over 5 turns.
		Each turn the target will be dealt an additional %0.2f blight damage per disease.
		Damage will increase with your Spellpower.]], [[당신의 얼굴이 녹아내려 원뿔 범위의 적에게 피를 튀깁니다. 피에 맞은 적은 5턴 간 %0.2f 암흑 피해 (총 %0.2f 피해)를 입습니다.
		매 턴 대상이 걸린 질병 당 %0.2f 역병 피해를 추가로 입힙니다.
		피해량은 주문력이 비례하여 증가합니다.]])
t("Writhing Hairs", "뒤틀린 머리카락")
t([[For a brief moment horrific hairs grow on your head, each of them ending with a creepy eye.
		You use those eyes to gaze upon a target area, creatures caught inside partially turn to stone reducing their movement speed by %d%% and making them brittle for 7 turns.
		Brittle targets have a 35%% chance for any damage they take to be increased by %d%%.
		This cannot be saved against.
		]], [[잠시돟안 눈알이 달린 끔찍한 머리카락이 당신의 머리에서 자라납니다.
		이 눈알은 지정한 지역을 응시하여, 범위 내 대상은 부분적으로 돌로 변해 7턴 간 이동속도가 %d%%만큼 감소하고, 부숴지기 쉽게 됩니다.
		부숴지게 쉽게 된 대상은 35%%의 확률로 %d%%만큼 추가 피해를 입습니다.
		이 효과는 저항할 수 없습니다.
		]])
t("Glimpse of True Horror", "진정한 공포의 낌새")
t([[Whenever you use a disfigured face power you show a glimpse of what True Horror is.
		If the affected targets fail a spell save they become frightened for 2 turns, giving them a %d%% chances to fail using talents.
		When a target becomes afraid it bolsters you to see their anguish, increasing your darkness and blight damage penetration by %d%% for 2 turns.
		The values will increase with your Spellpower.]], [[문드러진 얼굴의 힘을 사용할 때마다 적에게 진정한 공포가 무엇인지 슬쩍 보여줍니다.
		대상이 마법저항 굴림에 실패할 경우 2턴 간 겁에 질려 %d%%의 확률로 기술 시전을 실패합니다.
		겁에 질린 적은 약점이 노출되어, 2턴 간 당신의 암흑 피해 관통력 및 역병 피해 관통력이 %d%% 증가합니다.
		증가량은 당신의 주문력에 비례하여 상승합니다.]])


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/doom.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/entropy.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/friend-of-the-worm.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/horrific-body.lua"

t("Shed Skin", "벗겨진 피부")
t([[You shed the outer layer of your mutated skin and empower it to act as a damage shield for 7 turns.
		The shield can absorb up to %d damage before it crumbles.
		]], [[당신은 변이된 피부의 껍질을 벗겨내어 7턴 간 보호막으로 사용합니다.
		보호막은 부숴지기 전까지 %d의 피해를 흡수할 수 있습니다.
		]])
t("Pustulent Growth", "고름으로 가득찬 성장")
t([[Each time your shed skin looses %d%% of its max power or you take damage over 15%% of your maximum life a black putrescent pustule grows on your body for 5 turns.
		Each pustule increases all your resistances by %d%%. You can have up to %d pustules at once.
		Resistance scales with your Spellpower.]], [[벗겨진 피부가 최대 피해 흡수량의 %d%%만큼의 피해를 흡수하거나, 당신의 최대 생명력의 15%%가 넘는 피해를 받을 경우 고름으로 가득찬 새까만 물집이 5턴 간 몸에서 자라납니다.
		각각의 물집은 모든 저항력을 %d%%만큼 증가시킵니다. 물집은 최대 %d개만큼 자라납니다.
		저항력 증가량은 주문력에 비례하여 증가합니다.]])
t("Pustulent Fulmination", "고름 폭발")
t("You make all your putrescent pustules explode at once, splashing all creatures in radius %d with black fluids that deal %0.2f darkness damage per pustule and healing you for %0.1f per pustule.", "당신의 모든 물집을 한꺼번에 터뜨려, 반경 %d칸 내의 모든 대상에게 물집 하나 당 %0.2f의 암흑 피해를 주고 %0.1f만큼 당신을 회복시킵니다.")
t("Defiled Blood", "오염된 피")
t([[When you make your pustules explode you leave a pool of defiled blood on the ground for 5 turns.
		Foes caught inside get assaulted by black tentacles every turn, dealing %d%% darkness tentacle damage and covering them in your black blood for 2 turns.
		Creatures that hit you while covered in your blood heal you for %d%% of the damage done.
		The healing received increases with your Spellpower.]], [[당신의 고름을 터뜨려 5턴 간 오염된 피로 가득찬 웅덩이를 생성합니다.
		매 턴, 오염된 피를 밟고 있는 적은 까만 촉수들에게 %d%%의 암흑 촉수 피해를 입으며, 당신의 검은 피로 2턴 간 뒤덮습니다.
		검은 피에 뒤덮힌 대상이 당신을 공격하면 피해량의 %d%%만큼 당신을 회복시킵다.
		회복량은 당신의 주문력에 비례하여 증가합니다.]])


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/madness.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/nether.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/oblivion.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/path-of-horror.lua"

t("Carrion Feet", "썩어가는 발")
t([[Your feet start to continuously produce carrion worms that are constantly crushed as you walk, passively increasing movement speed by %d%%.
		You can also activate this talent to instantly destroy more worms, letting you jump in range %d to visible terrain.
		Upon landing you crush more worms, creating a radius 2 cone of gore; any creatures caught inside deals 70%% less damage for one turn.
		If at least 1 enemy is effected by the cone you gain an additional 20 insanity.]], [[당신은 걸을 때마다 당신의 발에서 자라는 지렁이들을 밟아 이동 속도를 %d%% 증가합니다.
		이 기술을 사용하면 즉시 더 많은 지렁이들을 밟아 으깨, %d 칸 내의 시야에 보이는 곳을 향해 점프할 수 있습니다.
		착지 할 때에도 지렁이를 으깨어, 원뿔형 반경 2칸의 피웅덩이를 만듭니다. 피웅덩이를 밟고 있는 모든 생물은 1턴 간 70%% 감소된 피해를 입힙니다.
		하나 이상의 적이 피웅덩이의 영향을 받게 되면 20의 광기를 추가로 획득합니다.]])
t("Horrific Evolution", "끔찍한 진화")
t([[Your mutations have enhanced your offense even farther.
		You gain %d Accuracy and %d Spellpower.
		The effects will increase with your Magic stat.]], [[당신은 변이를 통해 공격 능력을 더욱 증가시킵니다.
		%d의 정확도와 %d의 주문력을 얻습니다.
		이 효과는 마법 능력치에 비례하여 증가합니다.]])
t("Overgrowth", "과대성장")
t([[You trigger a cascade of rapidly mutating cells in your body for %d turns.
		Your body grows much bigger, gaining 2 size categories, making you able to walk through walls and increasing all your damage by %d%% and all your resistances by %d%%.
		Each time you take a step your monstrous form causes a small quake destroying and rearranging nearby terrain.]], [[당신의 세포가 %d턴동안 급속도로 변이하게 만듭니다.
		당신의 신체는 더욱 크게 성장하여, 몸집 크기가 2만큼 증가하여, 벽을 넘어 이동할 수 있습니다. 당신이 가하는 모든 피해량이 %d%%만큼 증가하고, 모든 저항력이 %d%%만큼 증가합니다.
		거대화된 형체로 이동할 때마다 작은 지진을 일으켜 주위 지형을 파괴하거나 재배열합니다.]])


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/rift.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/scourge-drake.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/slow-death.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/tentacles.lua"

t("Mutated Hand", "변이된 손")
t([[Your left hand mutates into a disgusting mass of tentacles.
		When you have your offhand empty you automatically hit your target and those on the side whenever you hit with a basic attack.
		Also increases Physical Power by %d, and increases weapon damage by %d%% for your tentacles attacks.
		Each time you make an attack with your tentacle you gain %d insanity.
		You generate a low power psionic field around you when around #{italic}#'civilized people'#{normal}# that prevents them from seeing you for the horror you are.

		Your tentacle hand currently has these stats%s:
		%s]], [[당신의 왼팔이 역겨운 촉수들로 변이합니다.
		보조무기를 장착하고 있지 않고 기본 공격 시 촉수가 자동적으로 대상과 대상의 좌우를 공격합니다. **
		또한, 물리력이 %d만큼 중가하며, 촉수 공격시 %d%%만큼 무기 피해량이 증가합니다.
		촉수를 이용하여 공격할 때마다 %d의 광기를 생성합니다.
		#{italic}#'문명화된 생명체'#{normal}#가 근처에 있으면 약한 초능력장을 생성하여 당신의 팔이 얼마나 끔찍하게 생겼는지 알 수 없게 만듭니다.

		당신의 촉수 팔의 능력치는 다음과 같습니다.%s:
		%s]])
t(", #CRIMSON# but is currently disabled due to non-empty offhand#WHITE#", ", #CRIMSON# 하지만 보조무기 칸이 비워져있지 않기 때문에 발동하지 않습니다.#WHITE#")
t("Lash Out", "채찍질")
t([[Spin around, extending your weapon and damaging all targets around you for %d%% weapon damage while your tentacle hand extends and hits all targets in radius 3 for %d%% tentacle damage.
				
				If the mainhand attack hits at least one enemy you gain %d insanity.
				If the tentacle attack hits at least one enemy you gain %d insanity.
		
		#YELLOW_GREEN#When constricting:#WHITE# Your tentacle attack is centered around your constricted target (but not your weapon attack) and only in radius 1 but it also dazes anything hit for 5 turns.]], [[회전하여 주위 적에게 %d%%의 무기 피해를 주고, 촉수가 길게 늘어나 주위 반경 3칸 이내의 모든 적에게 %d%%의 촉수 피해를 입힙니다.
				
				주무기를 이용한 공격이 하나 이상의 적에게 명중하면 %d의 광기를 획득합니다.
				촉수를 이용한 공격이 하나 이상의 적에게 명중하면 %d의 광기를 획득합니다.
		
		#YELLOW_GREEN#When constricting:#WHITE# Your tentacle attack is centered around your constricted target (but not your weapon attack) and only in radius 1 but it also dazes anything hit for 5 turns.]])
t("Tendrils Eruption", "덩굴 폭발")
t("%s resists the slimy tendril!", "%s 미끌미끌한 덩굴에 저항합니다!", nil, {"는"})
t([[You plant your tentacle hand in the ground where it splits up and extends to a target zone of radius %d.
		The zone will erupt with many black tendrils to hit all foes caught inside dealing %d%% tentacle damage.
		Any creature hit by the tentacle must save against spell or be numbed by the attack, reducing its damage by %d%% for 5 turns.

		If at least one enemy is hit you gain %d insanity.

		#YELLOW_GREEN#When constricting:#WHITE#The tendrils pummel your constricted target for %d%% tentacle damage and if adjacent you make an additional mainhand weapon attack.  Talent cooldown reduced to 10.]], [[당신의 촉수 팔을 바닥에 심습니다. 촉수는 무수하게 분열하여 반경 %d 내의 적에게 %d%%의 촉수 피해를 입힙니다.
		촉수에 맞은 모든 대상은 주문 내성굴림에 실패할 경우, 5턴 간 %d%% 감소된 피해를 입힙니다.

		공격이 하나 이상의 적에게 명중하면 %d의 광기를 획득합니다.

		#YELLOW_GREEN#When constricting:#WHITE#The tendrils pummel your constricted target for %d%% tentacle damage and if adjacent you make an additional mainhand weapon attack.  Talent cooldown reduced to 10.]])
t([[You extend your tentacle to grab a distant target, pulling it to you.
		As long as Constrict stays active the target is bound by your tentacle, it can try to move away but each turn you pull it back in 1 tile.
		While constricting you cannot use your tentacle to enhance your normal attacks but you deal %d%% tentacle damage each turn to your target.
		Enemies can resist the attempt to pull them but Constrict will always work for purposes of modifying your talents.
		Your other tentacle talents may act differently when used while constricting (check their descriptions).]], [[당신은 촉수를 길게 늘여뜨려 적을 잡아당깁니다.
		조이기를 사용하는 동안 대상은 당신의 촉수에 묶여 있습니다. 대상은 촉수로부터 도망가려고 시도할 수 있으나, 매 턴 촉수를 향해 1칸 씩 당겨집니다.
		조이기를 사용하는 동안 촉수는 당신의 기본 공격을 강화시키지 않지만 매 턴 조이기를 당하고 있는 적에게 %d%%의 촉수 피해를 입힙니다.
		Enemies can resist the attempt to pull them but Constrict will always work for purposes of modifying your talents. 
		당신의 다른 촉수 기술은 조이기를 사용하는 동안에는 효과가 달라집니다. (각각의 기술의 설명 참고).]])


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/timethief.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/void.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/writhing-body.lua"

t(", #CRIMSON# but is currently disabled due to non-empty offhand#WHITE#", ", #CRIMSON# 하지만 보조무기 칸이 비워져있지 않기 때문에 발동하지 않습니다.#WHITE#")


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/misc/misc.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/talents/misc/races.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/spell/necro.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/timed_effects.lua"

t("Carrion Feet", "썩어가는 발")
t("Overgrowth", "과대성장")
t("Dissolved Face", "녹아내린 얼굴")
t("Glimpse of True Horror", "진정한 공포의 낌새")
t("Writhing Hairs", "뒤틀린 머리카락")
t("Defiled Blood", "오염된 피")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/dremshor-tunnel/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/dremshor-tunnel/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/dremshor-tunnel/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/dremshor-tunnel/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/entropic-void/grids.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/entropic-void/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/entropic-void/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/fortress-arena/grids.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/fortress-arena/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-cultist/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")
t("shalore", "샬로레")
t("halfling", "하플링")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-cultist/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-cultist/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-haze-cave/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-haze-cave/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-haze-cave/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-haze-cave/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-home/grids.lua"

t("floor", "바닥")
t("wall", "벽")
t("No", "아니요")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-home/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-horrors/grids.lua"

t("Exit", "나가기")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-horrors/npcs.lua"

t("The One That Writes", "글을 쓰는 자")
t("Even as this creature focuses its attention on you, many of its tentacles are preoccupied with writing letters onto sheets of strange, wispy parchment. With every word it finishes, the environment around you changes its shape, objects become more defined and patches of ground appear to be more detailed. You don't want to know the ending it has planned for your story.", "이 생명체가 당신에게 주의를 기울이고 있다고 해도, 대부분의 촉수들은 신기하게 생긴 양피지에 글을 쓰는 것에 집중하고 있습니다. 글자가 쓰여질 때마다 당신의 주위 환경이 급격히 변합니다. 다양한 사물들이 나타나고, 바닥 또한 더욱 정교해집니다. 이 생명체가 당신을 위해 준비한 결말은 무엇일지 절대로 알고 싶지 않을 것 같습니다.")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-horrors/objects.lua"

t("A page of the tome.", "두꺼운 책의 한 페이지.")
t("Forbidden Tome: \"Home, Horrific Home\"", "금지된 책: \"집, 무시무시한 집\"")
t("A tome of lost knowledge. Touching it you feel both sick and yet strangely at peace.", "잃어버린 지식을 담고 있는 두꺼운 책. 만지면 역겨움과 평화를 동시에 느낄 수 있다.")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-horrors/zone.lua"

t("The Place Which Does Not Exist", "존재하지 않는 장소")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-illusory-castle/generatorMap.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-illusory-castle/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-illusory-castle/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-illusory-castle/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-illusory-castle/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-yaech/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-yaech/npcs.lua"

t("The One That Writes", "글을 쓰는 자")
t("A strange creature sporting 7 formless tentacles each with some kind of pen attached. It is ever focused on its book and does not seem to notice you, yet you can feel its hatred and hostility towards you.", "7개의 흐물흐물한 촉수에 펜처럼 생긴 물체가 달려있는 괴상하게 생긴 생명체입니다. 책에 집중한 탓에, 아직 당신의 인기척을 느끼지 못했습니다. 하지만, 곧 당신을 휩쓸 증오와 적의를 느낄 수 있습니다.")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-yaech/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/godfeaster/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/godfeaster/npcs.lua"

t("humanoid", "인간형")
t("shalore", "샬로레")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/godfeaster/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/godfeaster/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/maggot/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/maggot/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/maggot/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/maggot/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/necromancers-ruins/grids.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/necromancers-ruins/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/necromancers-ruins/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/necromancers-ruins/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/occult-egress/grids.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/occult-egress/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/occult-egress/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/scourged-pits/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/scourged-pits/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/scourged-pits/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/test/grids.lua"

t("door", "문")
t("wall", "벽")
t("previous level", "이전 층")
t("floor", "바닥")
t("next level", "다음 층")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/test/npcs.lua"

t("humanoid", "인간형")
t("thalore", "탈로레")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/test/traps.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/test/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/town-kroshkkur/grids.lua"

t("door", "문")
t("wall", "벽")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/town-kroshkkur/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/town-kroshkkur/objects.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/town-kroshkkur/traps.lua"



------------------------------------------------
section "game/dlcs/tome-cults/data/zones/town-kroshkkur/zone.lua"



------------------------------------------------
section "game/dlcs/tome-cults/hooks/bonestaff.lua"



------------------------------------------------
section "game/dlcs/tome-cults/init.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/intro-cults.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/intro-krog.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/unlock-cosmetic_class_alchemist_glass_golem.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/unlock-demented_cultist_entropy.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/unlock-race_drem.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/unlock-race_krog.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/data/texts/unlock-wyrmic_scourge.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/class/CultsDLC.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/dialogs/EntropicWormhole.lua"



------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/dialogs/FontSacrifice.lua"

t("Name", "이름")


------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/dialogs/ForbiddenTome.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/dialogs/RingOfTheHunter.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/class/Actor.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/class/Game.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/Birther.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyGrandOration.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyRevelation.lua"



------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyTwofoldCurse.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/achievements/special.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/achievements/story.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/classes/empyreal.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/classes/tinker.lua"

t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +3 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +3 교활")
t("#LIGHT_BLUE# * +0 Strength, +3 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +3 민첩, +0 체격")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")


------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/races/orc.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# 12", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 12")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")


------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/races/whitehooves.lua"

t("Undead", "언데드")
t("Undead are humanoids (Humans, Elves, Dwarves, ...) that have been brought back to life by the corruption of dark magics.", "언데드는 타락한 어둠의 마법을 통해 이승으로 돌아온 영장류(인간, 엘프, 드워프, ...)입니다.")
t("Undead can take many forms, from ghouls to vampires and liches.", "언데드는 구울에서부터 흡혈귀와 리치에 이르기까지 다양한 형태를 취할 수 있습니다.")
t("Grave strength, dread will, this flesh cannot stay still. Kings die, masters fall, we will outlast them all.", "막대한 힘, 무시무시한 의지, 이 육체는 멈추지 않는다. 왕은 죽고, 지배자들은 멸망하지만, 우리는 그들 모두보다 오래동안 존재하리라.")
t("- bleeding immunity", "- 출혈 면역")
t("- fear immunity", "- 공포 면역")
t("- no need to breathe", "- 숨 쉴 필요 없음")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# 14", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 14")


------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/races/yeti.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")


------------------------------------------------
section "game/dlcs/tome-orcs/data/birth/worlds.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/aaa.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/aaf.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/destructicus-lead.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/destructicus.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/john-surrender.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/john-worldmap.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/kaltor-entry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/kaltor-shop.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/kruk-tinker-shop.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/metash.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/phonograph.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/shertul-priest.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/chats/weissi-machine.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/damage_types.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/factions.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/encounters/fareast-npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/encounters/fareast.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/encounters/maj-eyal.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/AAA.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/campfire.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/drills.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/herbs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/merchant-stall.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/events/sewer-alligator-nest.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/manacave.lua"

t("previous level", "이전 층")
t("next level", "다음 층")
t("door", "문")
t("floor", "바닥")
t("wall", "벽")
t("open door", "열린 문")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/mechstone.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/mechwall.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("next level", "다음 층")
t("floor", "바닥")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/primal_trunk.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/psicave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/slumbering_cave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/grids/snow_mountains.lua"

t("floor", "바닥")
t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/alligator.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/domestic-yeti.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/hethugoroth.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/horror.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/ritch-extended.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/steam-drone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/steam-giant-arcane.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/steam-giant-gunner.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/steam-giant-warrior.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/steam-spiders.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/sunwall-mage.lua"

t("humanoid", "인간형")
t("human", "인간")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/sunwall-warrior.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/titan.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/troll-pirates.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/undead-drake.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/whitehooves.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/npcs/yeti.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/boss-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/egos/steamgun.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/inscriptions.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/leather-hats.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/lore.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/quest-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/schematics.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/special-misc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/steamgun.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/steamsaw.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinker.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/chemistry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/electricity.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/explosive.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/mechanical.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/smith.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/tinkers/therapeutics.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/world-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/stores/orcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/general/traps/ritch.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/ingredients.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/destructicus.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/dominion-port.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/emporium.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/gem.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/internment-camp.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/krimbul.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/misc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/orcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/palace-fumes.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/pocket-time.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/primal-forest.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/quarry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/slumbering-caves.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/sunwall.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/weissi.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/yeti.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/maps/zones/worldmap.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/amakthel.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/annihilator.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/destroy-sunwall.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/free-prides.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/gem.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/kaltor-shop.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/kill-dominion.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/krimbul.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/kruk-invasion.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/palace.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/quarry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/ritch-hive.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/start-orc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/sunwall-observatory.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/to-mainland.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/voyage.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/weissi.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/yeti-abduction.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/resolvers.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/celestial-empyreal.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/cosmic.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/crepescula.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/energies.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/reflection.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/sol.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/void.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/misc/npcs.lua"

t([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target's Accuracy is reduced by %d for %d turns.
		Accuracy reduction chance increases with your Physical Power.]], [[무기로 대상을 공격해 %d%% 피해를 줍니다. 공격이 적중하면 대상의 명중률이 %d턴 동안 %d 감소합니다.
		명중률 감소 확률은 물리력의 영향을 받아 증가합니다.]], {1,3,2,4})
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/misc/objects.lua"

t("Overgrowth", "과대성장")
t("%s resists!", "%s 저항합니다!", nil, {"가"})
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/misc/races.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/psionic/action-at-a-distance.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/psionic/gestalt.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/psionic/psionic-fog.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/psionic/psionic.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/galvanic-technomancy.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/occult-technomancy.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/other-technomancy.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/spells.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/terrene-technomancy.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/spells/undead-drake.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/artillery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/automated-butchery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/automation.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/avoidance.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/battle-machinery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/battlefield-management.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/blacksmith.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/bullets-mastery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/butchery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/chemical-warfare.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/chemistry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/demolition.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/dread.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/elusiveness.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/engineering.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/furnace.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/gadgets.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/gunner-training.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/gunslinging.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/heavy-weapons.lua"

t("%s resists the disarm!", "%s 무장해제에 저항합니다!", nil, {"가"})
t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/inscriptions.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/magnetism.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/mecharachnid.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/mechstar.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/other.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/physics.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/psytech-gunnery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/sawmaiming.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/steam.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/thoughts-of-iron.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/steam/turrets.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/const.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/cun.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/dex.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/mag.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/str.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/wil.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/timed_effects/floor.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/timed_effects/magical.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/timed_effects/mental.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/timed_effects/other.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/timed_effects/physical.lua"

t("Cloak", "망토")
t("Marked for Death", "죽음의 표식")
t("#ORCHID#%s has recovered!#LAST#", "#ORCHID#%s 회복했습니다!#LAST#", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/chemistry.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/electricity.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/explosive.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/mechanical.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/smith.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/tinkers/therapeutics.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/wda/orcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/cave-hatred/npcs.lua"

t("human", "인간")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/cave-hatred/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/cave-hatred/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/dominion-port/grids.lua"

t("previous level", "이전 층")
t("next level", "다음 층")
t("exit to the worldmap", "월드맵으로의 출구")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/dominion-port/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/dominion-port/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/dominion-port/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gates-of-morning/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gates-of-morning/npcs.lua"

t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린")
t("halfling", "하플링")
t("shalore", "샬로레")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gates-of-morning/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gates-of-morning/traps.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gates-of-morning/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/grids.lua"

t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/internment-camp/grids.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/internment-camp/npcs.lua"

t("halfling", "하플링")
t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/internment-camp/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/internment-camp/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/kaltor-shop/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/kaltor-shop/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/kaltor-shop/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/kaltor-shop/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/krimbul/grids.lua"

t("trigger", "작동 장치")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/krimbul/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/krimbul/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/krimbul/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/lost-city/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/lost-city/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/lost-city/objects.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/lost-city/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/palace-fumes/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/palace-fumes/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/palace-fumes/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/palace-fumes/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/pocket-time/grids.lua"

t("next level", "다음 층")
t("floor", "바닥")
t("previous level", "이전 층")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/pocket-time/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/pocket-time/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/primal-forest/grids.lua"

t("wall", "벽")
t("trigger", "작동 장치")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/primal-forest/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/primal-forest/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/primal-forest/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ritch-hive/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ritch-hive/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ritch-hive/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/shertul-cave/grids.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/shertul-cave/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/shertul-cave/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/slumbering-caves/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/slumbering-caves/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/slumbering-caves/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/steam-quarry/grids.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/steam-quarry/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/steam-quarry/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/steam-quarry/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-observatory/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-observatory/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-observatory/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-observatory/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-outpost/grids.lua"

t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-outpost/npcs.lua"

t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-outpost/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/sunwall-outpost/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/tinker-master/grids.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/tinker-master/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/tinker-master/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/town-kruk/grids.lua"

t("exit to the worldmap", "월드맵으로의 출구")
t("door", "문")
t("wall", "벽")
t("open door", "열린 문")
t("floor", "바닥")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/town-kruk/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/town-kruk/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/town-kruk/traps.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/town-kruk/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ureslak-host/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ureslak-host/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/ureslak-host/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/vaporous-emporium/grids.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/vaporous-emporium/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/vaporous-emporium/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/vaporous-emporium/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/wilderness-add/grids.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/yeti-caves/grids.lua"

t("wall", "벽")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/yeti-caves/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/yeti-caves/objects.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/yeti-caves/zone.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/init.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/calendar_orc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/intro-orc-whitehooves.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/intro-orc-yeti.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/intro-orc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-cosmetic_race_orc.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-mage_technomancer.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-orcs_campaign_all_classes.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-orcs_campaign_mage.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-orcs_campaign_rogue.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-orcs_tinker_eyal.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-race_whitehooves.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-race_yeti.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-tinker_annihilator.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-tinker_psyshot.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/texts/unlock-wyrmic_undead.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/mod/class/OrcCampaign.lua"

t("Name", "이름")


------------------------------------------------
section "game/dlcs/tome-orcs/overload/mod/class/interface/PartyTinker.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/overload/mod/dialogs/CreateTinker.lua"

t("Tinkers", "발명가")
t("Requires:", "요구사항:")


------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/Actor.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/Game.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/Object.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/Projectile.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/interface/Archery.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/interface/Combat.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/class/interface/TooltipsData.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/dialogs/Birther.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/dialogs/LevelupDialog.lua"



------------------------------------------------
section "game/dlcs/tome-orcs/superload/mod/dialogs/debug/DebugMain.lua"



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

t("Talk to people", "사람들과 대화하기")
t("Display chat log", "대화 기록 표시하기")
t("Cycle chat channels", "대화 채널 변경")


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

t("Toggle list of seen creatures", "확인된 생명체 목록 전환")
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
t("Do you want to recreate the same character?", "같은 캐릭터를 재생성하시겠습니까?")
t("Quick Birth", "빠른 탄생")
t("New character", "새로운 캐릭터")
t("Recreate", "재생성")
t("Randomly selected %s.", "무작위로 선택하기 %s.")


------------------------------------------------
section "game/engines/default/engine/DebugConsole.lua"

t("Lua Console", "Lua 콘솔")


------------------------------------------------
section "game/engines/default/engine/Dialog.lua"

t("Yes", "네")
t("No", "아니요")


------------------------------------------------
section "game/engines/default/engine/Game.lua"

t([[Screenshot should appear in your Steam client's #LIGHT_GREEN#Screenshots Library#LAST#.
Also available on disk: %s]], [[스크린샷이 스팀 클라이언트의 #LIGHT_GREEN#스크린샷 라이브러리#LAST#에 저장되었습니다.
저장 경로: %s]])
t("File: %s", "파일: %s")
t("Screenshot taken!", "스크린샷 촬영됨!")


------------------------------------------------
section "game/engines/default/engine/HotkeysDisplay.lua"

t("Missing!", "찾을 수 없음!")


------------------------------------------------
section "game/engines/default/engine/HotkeysIconsDisplay.lua"

t("Missing!", "찾을 수 없음!")


------------------------------------------------
section "game/engines/default/engine/I18N.lua"

t("Testing arg one %d and two %d", "인자 테스트 1번째 %d 와 2번째 %d")


------------------------------------------------
section "game/engines/default/engine/Key.lua"

t("#LIGHT_RED#Keyboard input temporarily disabled.", "#LIGHT_RED#키보드 입력 임시 비활성화.")


------------------------------------------------
section "game/engines/default/engine/LogDisplay.lua"

t("Message Log", "메시지 로그")


------------------------------------------------
section "game/engines/default/engine/MicroTxn.lua"

t("Test", "테스트")


------------------------------------------------
section "game/engines/default/engine/Module.lua"

t("#LIGHT_RED#Online profile disabled(switching to offline profile) due to %s.", "#LIGHT_RED#%s 발생하여 온라인 프로필 비활성화(오프라인 프로파일로 교체됨)", nil, {"이"})


------------------------------------------------
section "game/engines/default/engine/Mouse.lua"

t("#LIGHT_RED#Mouse input temporarily disabled.", "#LIGHT_RED#마우스 입력 임시 비활성화")


------------------------------------------------
section "game/engines/default/engine/Object.lua"

t("Requires:", "요구사항:")
t("%s (level %d)", "%s (%d 레벨)")
t("Level %d", "%d 레벨")
t("Talent %s (level %d)", "기술 %s (%d 레벨)")
t("Talent %s", "기술 %s")


------------------------------------------------
section "game/engines/default/engine/PlayerProfile.lua"

t("#YELLOW#Connection to online server established.", "#YELLOW#온라인 서버에 연결됨.")
t("#YELLOW#Connection to online server lost, trying to reconnect.", "#YELLOW#온라인 서버 연결이 끊김. 재접속 시도 중.")
t("bad game version", "게임 버전이 잘못됨")
t("nothing to update", "업데이트가 존재하지 않음")
t("bad game addon version", "애드온 버전이 잘못됨")
t("no online profile active", "활성화된 온라인 프로필 없음")
t("cheat mode active", "치트 모드 활성화")
t("savefile tainted", "세이브 파일이 오염됨")
t("unknown error", "알 수 없는 오류")
t("Character is being registered on https://te4.org/", "캐릭터는 https://te4.org/ 에 등록됩니다.")
t("Registering character", "캐릭터 등록 중")
t("Retrieving data from the server", "서버에서 데이터를 받아오는 중")
t("Retrieving...", "데이터를 받아오는 중...")


------------------------------------------------
section "game/engines/default/engine/Quest.lua"

t("active", "활성")
t("completed", "완료")
t("done", "성공")
t("failed", "실패")


------------------------------------------------
section "game/engines/default/engine/Savefile.lua"

t("Please wait while saving the world...", "월드를 저장 중 입니다...")
t("Saving world", "월드 저장")
t("Please wait while saving the game...", "게임을 저장 중 입니다...")
t("Saving game", "게임 저장")
t("Please wait while saving the zone...", "지역을 저장 중 입니다...")
t("Saving zone", "지역 저장")
t("Please wait while saving the level...", "지역 내부를 저장 중 입니다...")
t("Saving level", "지역 내부")
t("Please wait while saving the entity...", "엔티티를 저장 중 입니다...")
t("Saving entity", "엔티티 저장")
t("Loading world", "월드 불러오기")
t("Please wait while loading the world...", "월드를 불러오는 중 입니다...")
t("Loading game", "게임 불러오기")
t("Please wait while loading the game...", "게임을 불러오는 중 입니다...")
t("Loading zone", "지역 불러오기")
t("Please wait while loading the zone...", "지역를 불러오는 중 입니다...")
t("Loading level", "지역 내부 불러오기")
t("Please wait while loading the level...", "지역 내부를 불러오는 중 입니다...")
t("Loading entity", "엔티티 불러오기")
t("Please wait while loading the entity...", "엔티티를 불러오는 중 입니다...")


------------------------------------------------
section "game/engines/default/engine/SavefilePipe.lua"

t("Saving done.", "저장 완료.")
t("Please wait while saving...", "저장하는 동안 잠시 기다려주세요...")
t("Saving...", "저장 중...")


------------------------------------------------
section "game/engines/default/engine/Store.lua"

t("Store: %s", "상점: %s")
t("Buy %d %s", "%d %s 구입")
t("Buy", "구입")
t("Sell %d %s", "%d %s 판매")
t("Cancel", "취소")
t("Sell", "판매")


------------------------------------------------
section "game/engines/default/engine/Trap.lua"

t("%s fails to disarm a trap (%s).", "%s %s 함정을 해제하는데 실패함.")
t("%s disarms a trap (%s).", "%s %s 함정을 해제하는데 성공함.")
t("%s triggers a trap (%s)!", "%s %s 함정이 발동됨!")


------------------------------------------------
section "game/engines/default/engine/UserChat.lua"

t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/Zone.lua"

t("Loading level", "지역 내부 불러오기")


------------------------------------------------
section "game/engines/default/engine/ai/talented.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/AudioOptions.lua"

t("Audio Options", "오디오 설정")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatChannels.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ChatFilter.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/ChatIgnores.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/DisplayResolution.lua"

t("Switch Resolution", "해상도 전환")
t("Fullscreen", "전체 화면")
t("Borderless", "전체 창 모드")
t("Windowed", "창 모드")
t("Engine Restart Required", "엔진 재시작 필요")
t(" (progress will be saved)", " (작업 저장 중)")
t("Continue? %s", "%s 계속하시겠습니까?", nil, {"를"})
t("Reset Window Position?", "창 위치를 초기화하시겠습니까?")
t("Simply restart or restart+reset window position?", "게임 재시작 혹은 창 위치 초기화 후 재시작하시겠습니까?")
t("Restart", "재시작")
t("Restart with reset", "창 위치 초기화 후 재시작")
t("No", "아니요")
t("Yes", "네")


------------------------------------------------
section "game/engines/default/engine/dialogs/Downloader.lua"

t("Download: %s", "다운로드: %s")
t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/dialogs/GameMenu.lua"

t("Game Menu", "게임 메뉴")
t("Resume", "재개")
t("Key Bindings", "키 설정")
t("Video Options", "화면 설정")
t("Display Resolution", "표시 해상도")
t("Show Achievements", "도전과제 확인")
t("Audio Options", "오디오 설정")
t("#GREY#Developer Mode", "#GREY#개발자 모드")
t("Disable developer mode?", "개발자 모드를 비활성화하시겠습니까?")
t("Developer Mode", "개발자 모드")
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
]])
t("No", "아니요")
t("Yes", "네")
t("Save Game", "게임 저장")
t("Main Menu", "메인 메뉴")
t("Exit Game", "게임 종료")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantity.lua"

t("Cancel", "취소")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantitySlider.lua"

t("Cancel", "취소")
t("Error", "오류")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"

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

t("Cancel", "취소")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/UserInfo.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"

t("Video Options", "화면 설정")


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
t("Continue", "계속하기")


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

t("Continue", "계속하기")
t("Quit", "종료")


------------------------------------------------
section "game/engines/default/modules/boot/class/Player.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/birth/descriptors.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/damage_types.lua"



------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/basic.lua"

t("door", "문")
t("floor", "바닥")
t("wall", "벽")
t("open door", "열린 문")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/forest.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/underground.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/water.lua"

t("floor", "바닥")


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
t("Login in your account, please wait...", "로그인 중 입니다. 잠시만 기다려주세요...")
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

t("Player Profile", "플레이어 프로필")
t("Logout", "로그아웃")
t("Do you want to log out?", "정말 로그아웃하시겠습니까?")
t("You are logged in", "로그인 됨")
t("Cancel", "취소")
t("Log out", "로그아웃")
t("Login", "로그인")
t("Create Account", "계정 생성")


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
t("Dexterity", "민첩")
t("Constitution", "체격")


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

t("female", "여성")
t("male", "남성")
t("Effective talent level: ", "효과 기술 레벨: ")
t("Passive", "지속형")
t("Sustained", "유지형")
t("Activated", "사용형")
t("Use mode: ", "사용 유형: ")
t("Feedback cost: ", "반작용 비용: ")
t("Fortress Energy cost: ", "요새 에너지 비용: ")
t("Sustain feedback cost: ", "반작용 유지 비용: ")
t("Cancel", "취소")
t("Transmogrification Chest", "변환 상자")


------------------------------------------------
section "game/modules/tome/class/FortressPC.lua"



------------------------------------------------
section "game/modules/tome/class/Game.lua"

t("Loading level", "지역 내부 불러오기")
t("Please wait while loading the level...", "지역 내부를 불러오는 중 입니다...")
t("#Source# hits #Target# for %s (#RED##{bold}#%0.0f#LAST##{normal}# total damage)%s.", "#Source1# #Target3# 공격. %s (총 #RED##{bold}#%0.0f#LAST##{normal}# 데미지)%s.")
t("#Source# hits #Target# for %s damage.", "#Source1# #Target3# 공격하여 %s 피해를 입힘.")
t("Kill (%d)!", "%d 죽음!", nil, {"가"})
t("Message Log", "메시지 로그")
t("Show Achievements", "도전과제 확인")
t("Character Sheet", "캐릭터 시트")
t("Game Options", "게임 설정")


------------------------------------------------
section "game/modules/tome/class/GameState.lua"

t("Exterminator", "절멸자")
t("but nobody knew why #sex# suddenly became evil", "하지만 왜 그 #sex#이 타락했는지는 아무도 모릅니다.")


------------------------------------------------
section "game/modules/tome/class/Grid.lua"



------------------------------------------------
section "game/modules/tome/class/MapEffects.lua"



------------------------------------------------
section "game/modules/tome/class/NPC.lua"



------------------------------------------------
section "game/modules/tome/class/Object.lua"

t("Talent %s", "기술 %s")


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

t("Buy", "구입")
t("Cancel", "취소")
t("Sell", "판매")


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

t("#Source# misses #target#.", "#Source1# #target3# 빗맞힘.")


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
t("Unstoppable", "저지 불가")
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

t("Adventurer", "모험가")
t("Adventurers can learn to do a bit of everything, getting training in whatever they happen to find.", "모험가들은 발견하는 어떤 것이든 훈련받으며 어떤 기술이던지 약간씩 배울 수 있습니다.")
t("#{bold}##GOLD#This is a bonus class for winning the game.  It is by no means balanced.#WHITE##{normal}#", "#{bold}##GOLD#모험가는 본편에서 승리한 사람을 위한 보너스 직업입니다. 밸런스가 맞지 않을 수 있습니다.#WHITE##{normal}#")
t("Their most important stats depend on what they wish to do.", "그들에게 가장 중요한 능력치는 가고자 하는 길에 따라 다릅니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +2 Strength, +2 Dexterity, +2 Constitution", "#LIGHT_BLUE# * +2 힘, +2 민첩, +2 체격")
t("#LIGHT_BLUE# * +2 Magic, +2 Willpower, +2 Cunning", "#LIGHT_BLUE# * +2 마법, +2 의지, +2 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/modules/tome/data/birth/classes/afflicted.lua"

t("Afflicted", "고통받는 자")
t("Some walk in shadow, alone, unloved, unwanted. What powers they wield may be mighty, but their names are forever cursed.", "사랑받지 못하고, 어디서도 환영받지 못하는 채로 홀로 그림자 속을 걷는 이들이 있습니다. 가진 힘은 막강할지 몰라도, 그들의 이름은 영원히 저주받았습니다.")
t("Afflicted classes have been twisted by their association with evil forces.", "고통받는 자들은 사악한 힘과의 연관에 의해 뒤틀려 버렸습니다.")
t("They can use these forces to their advantage, but at a cost...", "가진 힘을 스스로를 위해 사용할 수도 있지만, 그 대가는...")
t("Cursed", "저주받은 자")
t("Affliction can run to the soul, and hatred can fill one's entire being. Overcome someone else's hated curse to know its dreaded meaning.", "고통은 영혼까지 번질 수 있고, 증오는 한 존재를 가득 채울 수 있습니다. 다른 이의 증오스러운 저주를 극복해 그 두려운 진의를 깨달으십시오.")
t("Through ignorance, greed or folly the Cursed served some dark design and are now doomed to pay for their sins.", "무지, 탐욕, 혹은 어리석음으로 인해 저주받은 자들은 한때 어둠의 존재를 섬겼었고 결국 그 죄의 대가로 파멸을 맞이했습니다.")
t("Their only master now is the hatred they carry for every living thing.", "이제 그들을 지배하는 것은 살아 있는 모든 것에 대한 증오 뿐입니다.")
t("Drawing strength from the death of all they encounter, the Cursed become terrifying combatants.", "다른 존재의 죽음으로부터 힘을 끌어내어 저주받은 자들은 무시무시한 전투 능력을 가집니다.")
t("Worse, any who approach the Cursed can be driven mad by their terrible aura.", "심지어 그들에게 다가가는 이들은 저주받은 자들이 내뿜는 끔찍한 기운에 홀려 미쳐버릴 수도 있습니다.")
t("Their most important stats are: Strength and Willpower", "그들에게 가장 중요한 능력치는 힘과 의지입니다.")
t("#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +5 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +0 Magic, +4 Willpower, +0 Cunning", "#LIGHT_BLUE# * +0 마법, +4 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")
t("Doomed", "파멸한 자")
t("In shaded places in unknown lands thou must overcome thyself and see thy doom.", "알려지지 않은 땅의 그늘진 곳에서, 그대는 자기 자신을 넘어서고 그 파멸을 마주해야 하리라.")
t("The Doomed are fallen mages who once wielded powerful magic wrought by ambition and dark bargains.", "파멸당한 자들은 한때 야망에 불타 어둠의 거래로 끌어온 강력한 마법의 힘을 휘두르던, 몰락한 마법사들입니다.")
t("Stripped of their magic by the dark forces that once served them, they have learned to harness the hatred that burns in their minds.", "섬겨 왔던 어둠의 힘에 의해 마법을 빼앗긴 뒤로, 그들은 가슴 속에 불타는 증오를 이용하는 방법을 배웠습니다.")
t("Only time will tell if they can choose a new path or are doomed forever.", "새로운 길을 선택할 수 있을지 혹은 그들이 영원히 파멸당한 것인지는 오직 시간만이 알 것입니다.")
t("The Doomed strike from behind a veil of darkness or a host of shadows.", "파멸당한 자들은 어둠의 장막 뒤에 숨어 적을 공격하거나 그림자들을 사역할 수 있습니다.")
t("They feed upon their enemies as they unleash their minds on all who confront them.", "정신의 힘을 해방해 그들에게 대적하는 모든 자들을 포식하기도 합니다.")
t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +0 Magic, +4 Willpower, +5 Cunning", "#LIGHT_BLUE# * +0 마법, +4 의지, +5 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/modules/tome/data/birth/classes/celestial.lua"

t("The magic of the heavens is known to but a few, and that knowledge has long passed east, forgotten.", "천상의 마법을 알던 사람은 아주 적었고, 그들의 지식은 오래 전 그들이 머나먼 동쪽으로 떠난 뒤 잊혀졌습니다.")
t("Celestial classes are arcane users focused on the heavenly bodies.", "천공의 사도들은 천체의 힘을 끌어내는 것에 집중하는 마법 사용자들입니다.")
t("Most draw their powers from the Sun and the Moons.", "그들의 대부분은 태양과 달로부터 힘을 끌어냅니다.")
t("Sun Paladin", "태양의 기사")
t("The sun rises in the east in full glory, but you must look for it first amidst the darkest places.", "태양은 영광스러운 모습으로 동쪽에서 떠오르지만, 칠흑 같은 어둠 속에서도 그대는 태양을 찾을 수 있으리라.")
t("Sun Paladins hail from the Gates of Morning, the last bastion of the free people in the Far East.", "태양의 기사들은 동대륙 자유민들의 마지막 보루인 아침의 문 출신입니다.")
t("Their way of life is well represented by their motto 'The Sun is our giver, our purity, our essence. We carry the light into dark places, and against our strength none shall pass.'", "그들의 삶의 방식은 '태양은 우리의 힘이요, 순수이자 정수이니, 우리는 어두운 곳에 빛을 가져오며 우리의 힘에 맞서는 이는 누구도 지나갈 수 없다.'라는 좌우명으로 잘 드러납니다.")
t("They can channel the power of the Sun to smite all who seek to destroy the Sunwall.", "그들은 태양의 장벽을 파괴하려는 그 누구라도 태양의 힘을 끌어내어 강타합니다.")
t("Competent in both weapon and shield combat and magic, they usually burn their foes from afar before bashing them in melee.", "태양의 기사들은 무기와 방패 전투법 그리고 마법 모두에 조예가 있기에 멀리서 그들의 적을 불사른 뒤 근접 전투에 들어가곤 합니다.")
t("Their most important stats are: Strength and Magic", "그들에게 가장 중요한 능력치는 힘과 마법입니다.")
t("#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +5 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +4 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")
t("Anorithil", "아노리실")
t("The balance of the heavens' powers is a daunting task. Mighty are those that stand in the twilight places, wielding both light and darkness in their mind.", "천상의 균형을 조율하는 것은 벅찬 일이다. 마음에 빛과 어둠 모두를 받아들인 이들은 황혼에 서서 그 권능을 휘두르리라.")
t("Anorithils hail from the Gates of Morning, the last bastion of the free people in the Far East.", "아노리실들은 동대륙 자유민들의 마지막 보루인 아침의 문 출신입니다.")
t("Their way of life is well represented by their motto 'We stand betwixt the Sun and Moon, where light and darkness meet. In the grey twilight we seek our destiny.'", "그들의 삶의 방식은 '우리는 태양과 달 사이, 빛과 어둠이 만나는 곳에 서 있다. 잿빛의 황혼 속에서 우리의 운명을 찾으리라.'라는 좌우명으로 잘 드러납니다.")
t("They can channel the power of the Sun and the Moons to burn and tear apart all who seek to destroy the Sunwall.", "그들은 태양의 장벽을 파괴하려는 그 누구라도 태양과 달의 힘을 끌어내어 불태우고 찢어냅니다.")
t("Masters of Sun and Moon magic, they usually burn their foes with Sun rays before calling the fury of the stars.", "태양의 마법과 달의 마법 모두에 능통한 그들은 별들의 분노를 불러내기 전에 적을 먼저 태양빛으로 불태웁니다.")
t("Their most important stats are: Magic and Cunning", "그들에게 가장 중요한 능력치는 마법과 교활입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +6 Magic, +0 Willpower, +3 Cunning", "#LIGHT_BLUE# * +6 마법, +0 의지, +3 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/modules/tome/data/birth/classes/chronomancer.lua"

t("Chronomancer", "시공술사")
t("Some do not walk upon the straight road others follow. Seek the hidden paths outside the normal course of life.", "남들과 같이 죽 곧은 시간의 길을 걷지 않는 이들이 있다. 평범한 삶에서 벗어나 샛길을 찾아보아라.")
t("Exploiting a hole in the fabric of spacetime, Chronomancers learn to pull threads from other timelines into their own.", "시공술사들은 시공간의 구조에 뚫린 구멍을 이용해 다른 시간선에서 그들의 시간선으로 시간의 실을 끌어오는 방법을 배웠습니다.")
t("Pulling these threads creates tension and the harder they pull the more tension is produced.", "시간의 실을 끌어오는 것은 장력을 만들어내고, 강하게 끌어올수록 장력 또한 강해집니다.")
t("Constantly they manage this tension, which they call Paradox, to avoid or control the anomalies they inevitably unleash on the world around them.", "시공술사들은 '괴리'라고 부르는 이 장력을 지속적으로 관리하여 불가피한 시공의 뒤틀림이 그들의 주위에 터져나오는 것을 조절합니다.")
t("Paradox Mage", "괴리술사")
t("A hand may clap alone if it returns to clap itself. Search for the power in the paradox.", "한 손을 내밀고 시간을 되돌려 그 손을 치면, 한 손만으로도 박수를 칠 수 있다. 괴리 속에서 힘을 찾아라.")
t("A Paradox Mage studies the very fabric of spacetime, learning not just to bend it but shape it and remake it.", "괴리술사들은 시공간의 구조를 변형할 뿐만 아니라, 형성하고 재창조하는 방법까지도 익힙니다.")
t("Most Paradox Mages lack basic skills that others take for granted (like general fighting sense), but they make up for it through control of cosmic forces.", "대부분의 괴리술사들은 일반적인 전투 기술을 잘 알지 못하지만 시공간의 힘을 다루는 것으로 대신합니다.")
t("Paradox Mages start off with knowledge of all but the most complex Chronomantic schools.", "괴리술사들은 가장 복잡한 시공 마법들을 제외한 모든 시공 마법을 아는 채로 시작합니다.")
t("Their most important stats are: Magic and Willpower", "그들에게 가장 중요한 능력치는 마법과 의지입니다.")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +2 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +2 체격")
t("#LIGHT_BLUE# * +5 Magic, +2 Willpower, +0 Cunning", "#LIGHT_BLUE# * +5 마법, +2 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")
t("Temporal Warden", "시간 감시자")
t("We preserve the past to protect the future. The hands of time are guarded by the arms of war.", "우리는 미래를 위해 과거를 보존한다. 시간의 손을 보호하는 것은 전쟁의 무기일지니.")
t("Their lifelines braided, Temporal Wardens have learned to work with their other selves across multiple timelines.", "시간 감시자들은 여러 시간선의 자기 자신들과 함께 일하는 법을 배웠습니다.")
t("Through their study of chronomancy, they learn to blend archery and dual-weapon fighting, seamlessly switching from one to the other.", "시공 마법의 연구를 통해 그들은 궁술과 쌍수 무기 전투를 접목하여 매끄럽게 두 전투 방식을 오갈 수 있습니다.")
t("Their most important stats are: Magic, Dexterity, and Willpower", "그들에게 가장 중요한 능력치는 힘과 민첩, 의지, 그리고 마법입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +3 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +3 민첩, +0 체격")
t("#LIGHT_BLUE# * +4 Magic, +2 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법c, +2 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")


------------------------------------------------
section "game/modules/tome/data/birth/classes/corrupted.lua"

t("Defiler", "모독자")
t("Dark thoughts, black bloods, vile deeds... Those who spill their brethren's blood will find its power.", "사악한 생각, 검은 피, 타락한 행위... 동포의 피로 땅을 적시는 자는 힘을 얻으리라.")
t("Defilers are touched by the mark of evil. They are a blight on the world. Working to promote the cause of evil, they serve their masters, or themselves become masters.", "모독자들은 악의 낙인을 받은 이들입니다. 세상의 역병이자, 사악한 의지를 위해 일하는 모독자들은 그들의 주인을 섬기거나 스스로 사악한 주인이 되기도 합니다.")
t("Reaver", "약탈자")
t("Reap thee the souls of thine enemies, and the powers of darkness shall enter thy flesh.", "그대에게 대적하는 자들의 영혼을 거두라, 그리하면 그대의 육신에 암흑의 권능이 깃들지니.")
t("Reavers are terrible foes, charging their enemies with a weapon in each hand.", "양 손에 하나씩 무기를 들고 적에게 달려드는 약탈자들은 무시무시한 적수입니다.")
t("They can harness the blight of evil, infecting their foes with terrible contagious diseases while crushing their skulls with devastating combat techniques.", "악과 부패를 받아들인 그들은 파괴적인 전투 기술로 적들의 두개골을 으스러뜨리는 동시에 적들에게 끔찍한 역병을 내립니다.")
t("Their most important stats are: Strength and Magic", "그들에게 가장 중요한 능력치는 힘과 마법입니다.")
t("#LIGHT_BLUE# * +4 Strength, +1 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +4 힘, +1 민첩, +0 체격")
t("#LIGHT_BLUE# * +4 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")
t("Corruptor", "타락자")
t("Blight and depravity hold the greatest powers. Accept temptation and become one with corruption.", "어둠과 부패에는 강력한 힘이 있나니, 유혹을 받아들이고 타락과 하나가 될지어다.")
t("A corruptor is a terrible foe, wielding dark magics that can sap the very soul of her target.", "희생양들의 영혼을 쥐어짜낼 수 있는 어둠의 마법을 다루는 타락자들은 무시무시한 적수입니다.")
t("They can harness the blight of evil, crushing souls, stealing life force to replenish themselves.", "그들은 사악한 힘을 휘둘러 영혼을 파괴하고 생명력을 빼앗아 스스로를 채웁니다.")
t("The most powerful corruptors can even take on some demonic aspects for themselves.", "가장 강력한 타락자들은 악마의 형상을 취할 수도 있습니다.")
t("Their most important stats are: Magic and Willpower", "그들에게 가장 중요한 능력치는 마법과 의지입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +2 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +2 체격")
t("#LIGHT_BLUE# * +4 Magic, +3 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +3 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/modules/tome/data/birth/classes/mage.lua"

t("Their most important stats are: Magic and Willpower", "그들에게 가장 중요한 능력치는 마법과 의지입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")


------------------------------------------------
section "game/modules/tome/data/birth/classes/none.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/psionic.lua"

t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")


------------------------------------------------
section "game/modules/tome/data/birth/classes/rogue.lua"

t("#LIGHT_BLUE# * +0 Strength, +3 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +3 민첩, +0 체격")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")


------------------------------------------------
section "game/modules/tome/data/birth/classes/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/birth/classes/warrior.lua"

t("Berserker", "광전사")
t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +3 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +3 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")


------------------------------------------------
section "game/modules/tome/data/birth/classes/wilder.lua"

t("#GOLD#Life per level:#LIGHT_BLUE# +0", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +0")
t("Their most important stats are: Strength and Willpower", "그들에게 가장 중요한 능력치는 힘과 의지입니다.")
t("Oozemancer", "점액술사")
t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +4 Magic, +3 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +3 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2")


------------------------------------------------
section "game/modules/tome/data/birth/descriptors.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/construct.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")


------------------------------------------------
section "game/modules/tome/data/birth/races/dwarf.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# 14", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 14")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 0%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 0%")


------------------------------------------------
section "game/modules/tome/data/birth/races/elf.lua"

t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#GOLD#Life per level:#LIGHT_BLUE# 11", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 11")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 0%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 0%")


------------------------------------------------
section "game/modules/tome/data/birth/races/giant.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")


------------------------------------------------
section "game/modules/tome/data/birth/races/halfling.lua"

t("Halflings are agile, lucky, and resilient but lacking in strength.", "하플링들은 기민하고, 운이 좋고, 힘이 약하지만 강인합니다.")
t("Halflings are a race of very short stature, rarely exceeding four feet in height.", "하플링들은 대부분 120cm를 넘기지 못하는 작은 종족입니다.")
t("They are like humans in that they can do just about anything they set their minds to, yet they excel at ordering and studying things.", "이들은 인간처럼 하고 싶은 모든 일이든지 잘 해낼 수 있지만, 계획하고 학습하는 것에 특출납니다.")
t("Halfling armies have brought many kingdoms to their knees and they kept a balance of power with the Human kingdoms during the Age of Allure.", "하플링 군대들은 많은 왕국들을 굴복시켰고, 매혹의 시대동안 인간 왕국들과 힘의 균형을 이루었습니다.")
t("They possess the #GOLD#Luck of the Little Folk#WHITE# which allows them to increase their critical strike chance and saves for a few turns.", "잠시동안 치명타 확률과 내성을 올려주는 #GOLD#작은 이의 행운#WHITE#을 사용할 수 있습니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * -3 Strength, +3 Dexterity, +1 Constitution", "#LIGHT_BLUE# * -3 힘, +3 민첩, +1 체격")
t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +3 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +3 교활")
t("#LIGHT_BLUE# * +5 Luck", "#LIGHT_BLUE# * +5 행운")
t("#GOLD#Life per level:#LIGHT_BLUE# 12", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 12")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 10%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 10%")


------------------------------------------------
section "game/modules/tome/data/birth/races/human.lua"

t("Human", "인간")
t("The Humans are one of the main races on Maj'Eyal, along with the Halflings. For many thousands of years they fought each other until events, and great people, unified all the Human and Halfling nations under one rule.", "인간과 하플링은 마즈'에이알의 주요 종족 중 하나입니다. 위대한 인물과 사건이 그들을 하나의 규율 아래 묶어주기 전까지 인간과 하플링들은 수천년간 싸워왔습니다.")
t("Humans of these Allied Kingdoms have known peace for over a century now.", "왕국연합의 지배아래 인간들은 백년 넘게 평화를 누려왔습니다.")
t("Humans are split into two categories: the Highers, and the rest. Highers have latent magic in their blood which gives them higher attributes and senses along with a longer life.", "인간들은 하이어(Higher)와 나머지로 나뉩니다. 하이어의 핏속에 흐르는 마법은 그들이 뛰어난 능력과 감각, 긴 수명을 누리게합니다.")
t("The rest of Humanity is gifted with quick learning and mastery. They can do and become anything they desire.", "나머지 인간들은 빠른 습득과 숙달을 타고났습니다. 이 사람들은 원하는 무었이든지 될 수 있습니다.")
t("Highers are a special branch of Humans that have been imbued with latent magic since the Age of Allure.", "하이어는 매혹의 시대로부터 마법의 잠재력을 물려받은 인간의 부류입니다.")
t("They usually do not breed with other Humans, trying to keep their blood 'pure'.", "하이어들은 '순수 혈통'을 지키기 위해 다른 인간들과 피를 섞지 않습니다.")
t("They possess the #GOLD#Wrath of the Highborn#WHITE# which allows them to increase damage dealt and decrease damage taken once in a while.", "그들은 #GOLD#고귀한 이의 분노#WHITE#를 사용할 수 있습니다. 사용하면 잠시동안 주는 피해를 증가시키고 받는 피해를 감소시킵니다.")
t("#LIGHT_BLUE# * +1 Strength, +1 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +1 힘, +1 민첩, +0 체격")
t("#LIGHT_BLUE# * +1 Magic, +1 Willpower, +0 Cunning", "#LIGHT_BLUE# * +1 마법, +1 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# 11", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 11")
t("Cornacs are Humans from the northern parts of the Allied Kingdoms.", "코르낙은 왕국연합의 북부에서 온 사람들입니다.")
t("Humans are an inherently very adaptable race and as such they gain a #GOLD#talent category point#WHITE# (others only gain one at levels 10, 20 and 34) and both #GOLD#a class and a generic talent point#WHITE# at birth and every 10 levels.", "인간은 선천적으로 아주 적응적인 종족으로 #GOLD#talent category point#WHITE# (다른 종족들은 레벨 10, 20, 34에만 하나씩 얻을 수 있습니다.)와 #GOLD#a class and a generic talent point#WHITE#를 캐릭터 생성시와 레벨 10마다 얻습니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +0 힘, +0 민첩, +0 체격")
t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# 10", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 10")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 0%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 0%")


------------------------------------------------
section "game/modules/tome/data/birth/races/tutorial.lua"



------------------------------------------------
section "game/modules/tome/data/birth/races/undead.lua"

t("Undead", "언데드")
t("Grave strength, dread will, this flesh cannot stay still. Kings die, masters fall, we will outlast them all.", "막대한 힘, 무시무시한 의지, 이 육체는 멈추지 않는다. 왕은 죽고, 지배자들은 멸망하지만, 우리는 그들 모두보다 오래동안 존재하리라.")
t("Undead are humanoids (Humans, Elves, Dwarves, ...) that have been brought back to life by the corruption of dark magics.", "언데드는 타락한 어둠의 마법을 통해 이승으로 돌아온 영장류(인간, 엘프, 드워프, ...)입니다.")
t("Undead can take many forms, from ghouls to vampires and liches.", "언데드는 구울에서부터 흡혈귀와 리치에 이르기까지 다양한 형태를 취할 수 있습니다.")
t("Ghoul", "구울")
t("Slow to shuffle, quick to bite, learn from master, rule the night!", "느리게 걸으나, 물때는 빠르니, 주인에게서 배워, 밤을 지배하리라.")
t("Ghouls are dumb, but resilient, rotting undead creatures, making good fighters.", "구울은 멍청하지만, 강인하여 좋은 투사인 썩어가는 언데드 괴물입니다.")
t("They have access to #GOLD#special ghoul talents#WHITE# and a wide range of undead abilities:", "그들은 #GOLD#구울 종족 특성#WHITE#을 가지며 다양한 언데드 능력을 사용할 수 있습니다.:")
t("- great poison resistance", "- great 중독 저항")
t("- stun resistance", "- 기절 저항")
t("- special ghoul talents: ghoulish leap, gnaw and retch", "- 구울 종족 특성: 구울의 도약, 물어뜯기와 구토하기")
t("The rotting bodies of ghouls also force them to act a bit more slowly than most creatures.", "구울의 썩어가는 육체 때문에 구울들은 대다수의 생물보다 조금 느리게 움직입니다.")
t("#LIGHT_BLUE# * +3 Strength, +1 Dexterity, +5 Constitution", "#LIGHT_BLUE# * +3 힘, +1 민첩, +5 체격")
t("#LIGHT_BLUE# * +0 Magic, -2 Willpower, -2 Cunning", "#LIGHT_BLUE# * +0 마법, -2 의지, -2 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# 14", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 14")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%")
t("#GOLD#Speed penalty:#LIGHT_BLUE# -20%", "#GOLD#속도 패널티:#LIGHT_BLUE# -20%")
t("Skeleton", "스켈레톤")
t("The marching bones, each step we rattle; but servants no more, we march to battle!", "진군하는 해골의 군단, 걸음마다 부들대지만, 더 이상 섬기지 않으리라. 우리는 전장으로 향하리라!")
t("Skeletons are animated bones, undead creatures both strong and dexterous.", "움직이는 뼈다귀인 스켈레톤은 강하고 민첩한 언데드 괴물입니다.")
t("They have access to #GOLD#special skeleton talents#WHITE# and a wide range of undead abilities:", "그들은 #GOLD#스켈레톤 종족 특성#WHITE#을 가지고, 다양한 언데드 능력을 사용할 수 있습니다.:")
t("- poison immunity", "- 중독 면역")
t("- bleeding immunity", "- 출혈 면역")
t("- fear immunity", "- 공포 면역")
t("- no need to breathe", "- 숨 쉴 필요 없음")
t("- special skeleton talents: bone armour, resilient bones, re-assemble", "- 스켈레톤 종족 특성 : 뼈 갑옷, 재생하는 해골, 재조립")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * +3 Strength, +4 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +3 힘, +4 민첩, +0 체격")
t("#LIGHT_BLUE# * +0 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +0 마법, +0 의지, +0 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# 12", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 12")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 20%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 20%")


------------------------------------------------
section "game/modules/tome/data/birth/races/yeek.lua"

t("Yeeks are a mysterious race of small humanoids native to the tropical island of Rel.", "이크는 '렐'이라는 열대의 섬에서 사는 작고 신비로운 영장류입니다.")
t("Their body is covered with white fur and their disproportionate heads give them a ridiculous look.", "그들의 몸은 하얀 털로 뒤덮혀 있고, 머리가 커서 기묘한 생김새를 하고 있습니다.")
t("Although they are now nearly unheard of in Maj'Eyal, they spent many thousand years as secret slaves to the Halfling nation of Nargol.", "이제는 마즈'에이알에서 거의 찾아볼 수 없게 되었지만, 이들은 나르골이라는 하플링의 나라에서 수천년간 노예로 부려졌습니다.")
t("Yeek", "이크")
t("One race, one mind, one way. Our oppression shall end, and we shall inherit Eyal. Do not presume we are weak - our way is true, and only those who help us shall see our strength.", "한 종족, 한 정신, 한 방식. 억압은 끝나리라, 그리고 우리는 에이알을 물려받으리니. 우리의 힘을 얕보지 말지어다. 우리의 방식은 옳으니, 우리를 돕는 자만이 우리의 진정한 힘을 보게 될 것이다.")
t("Yeeks are a mysterious race native to the tropical island of Rel.", "이크는 '렐'이라는 열대의 섬의 원주민인 신비로운 종족입니다.")
t("Although they are now nearly unheard of in Maj'Eyal, they spent many centuries as secret slaves to the Halfling nation of Nargol.", "이제는 마즈'에이알에서 거의 찾아볼 수 없게 되었지만, 이들은 나르골이라는 하플링의 나라에서 수천년간 노예로 부려졌습니다.")
t("They gained their freedom during the Age of Pyre and have since then followed 'The Way' - a unity of minds enforced by their powerful psionics.", "장작더미의 시대에 그들은 풀려났고, 이 시대 이래로 그들은 '한길'을 따릅니다. '한길'은 그들의 강력한 염동력을 통해 강제적인 정신의 통합을 추구하는 것입니다.")
t("They possess the #GOLD#Dominant Will#WHITE# talent which allows them to temporarily subvert the mind of a lesser creature. When the effect ends, the creature dies.", "그들은 #GOLD#지배 의지#WHITE#라는 능력을 통해 일시적으로 하등한 생물들의 정신을 뒤흔듭니다. 효과가 끝날 때, 그 생물은 죽습니다.")
t("While Yeeks are not amphibians, they still have an affinity for water, allowing them to survive longer without breathing.", "이크들은 양서종이 아니지만, 물과의 친화력이 높아서 호흡없이 오랜기간 생존할 수 있습니다.")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:")
t("#LIGHT_BLUE# * -3 Strength, -2 Dexterity, -5 Constitution", "#LIGHT_BLUE# * -3 힘, -2 민첩, -5 체격")
t("#LIGHT_BLUE# * +0 Magic, +6 Willpower, +4 Cunning", "#LIGHT_BLUE# * +0 마법, +6 의지, +4 교활")
t("#GOLD#Life per level:#LIGHT_BLUE# 7", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# 7")
t("#GOLD#Experience penalty:#LIGHT_BLUE# -15%", "#GOLD#경험치 패널티:#LIGHT_BLUE# -15%")
t("#GOLD#Confusion resistance:#LIGHT_BLUE# 35%", "#GOLD#혼란 저항:#LIGHT_BLUE# 35%")


------------------------------------------------
section "game/modules/tome/data/birth/sexes.lua"

t("Female", "여성")
t("Male", "남성")


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

t("%s(%d blocked)#LAST#", "%s(%d 방어됨)#LAST#")
t("%s(%d antimagic)#LAST#", "%s(%d 반마법)#LAST#")
t("%s resists the silence!", "%s 침묵에 저항합니다!", nil, {"가"})
t("%s resists!", "%s 저항합니다!", nil, {"가"})


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

t("Quit", "출구")


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

t("Quit", "출구")


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

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/basic.lua"

t("previous level", "이전 층")
t("next level", "다음 층")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")
t("door", "문")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("sealed door", "봉인된 문")
t("This door seems to have been sealed off. You need to find a way to open it.", "이 문은 봉인되지 않았지만, 열리지 않습니다. 문을 열 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door opening.", "#VIOLET#문이 열리는 소리가 들립니다.")
t("wall", "벽")
t("open door", "열린 문")
t("This door seems to have been sealed off. You need to find a way to close it.", "이 문은 봉인되지 않았지만, 닫히지 않습니다. 문을 닫을 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door closing.", "#VIOLET#문이 닫히는 소리가 들립니다.")
t("floor", "바닥")
t("lever", "레버")
t("huge lever", "거대한 레버")
t("trigger", "작동 장치")


------------------------------------------------
section "game/modules/tome/data/general/grids/bone.lua"

t("door", "문")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("sealed door", "봉인된 문")
t("This door seems to have been sealed off. You need to find a way to open it.", "이 문은 봉인되지 않았지만, 열리지 않습니다. 문을 열 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door opening.", "#VIOLET#문이 열리는 소리가 들립니다.")
t("wall", "벽")
t("open door", "열린 문")
t("This door seems to have been sealed off. You need to find a way to close it.", "이 문은 봉인되지 않았지만, 닫히지 않습니다. 문을 닫을 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door closing.", "#VIOLET#문이 닫히는 소리가 들립니다.")
t("lever", "레버")
t("huge lever", "거대한 레버")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/burntland.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/cave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/crystal.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/elven_forest.lua"

t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/general/grids/forest.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/fortress.lua"

t("door", "문")
t("open door", "열린 문")
t("floor", "바닥")
t("wall", "벽")
t("sealed door", "봉인된 문")


------------------------------------------------
section "game/modules/tome/data/general/grids/gothic.lua"

t("previous level", "이전 층")
t("next level", "다음 층")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")
t("door", "문")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("sealed door", "봉인된 문")
t("This door seems to have been sealed off. You need to find a way to open it.", "이 문은 봉인되지 않았지만, 열리지 않습니다. 문을 열 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door opening.", "#VIOLET#문이 열리는 소리가 들립니다.")
t("wall", "벽")
t("open door", "열린 문")
t("This door seems to have been sealed off. You need to find a way to close it.", "이 문은 봉인되지 않았지만, 닫히지 않습니다. 문을 닫을 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door closing.", "#VIOLET#문이 닫히는 소리가 들립니다.")
t("floor", "바닥")
t("lever", "레버")
t("huge lever", "거대한 레버")
t("trigger", "작동 장치")


------------------------------------------------
section "game/modules/tome/data/general/grids/ice.lua"

t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/icecave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/jungle.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/jungle_hut.lua"

t("floor", "바닥")
t("door", "문")
t("wall", "벽")
t("open door", "열린 문")


------------------------------------------------
section "game/modules/tome/data/general/grids/lava.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/mountain.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/psicave.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/sand.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/sanddunes.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/slime.lua"

t("previous level", "이전 층")
t("floor", "바닥")
t("next level", "다음 층")
t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/general/grids/slimy_walls.lua"

t("previous level", "이전 층")
t("next level", "다음 층")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("way to the next level", "다음 층으로의 길")
t("door", "문")
t("This door seems to have been sealed off. You think you can open it.", "이 문은 봉인되지 않은 것으로 보입니다. 문을 열 수 있을 것 같습니다.")
t("sealed door", "봉인된 문")
t("This door seems to have been sealed off. You need to find a way to open it.", "이 문은 봉인되지 않았지만, 열리지 않습니다. 문을 열 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door opening.", "#VIOLET#문이 열리는 소리가 들립니다.")
t("wall", "벽")
t("open door", "열린 문")
t("This door seems to have been sealed off. You need to find a way to close it.", "이 문은 봉인되지 않았지만, 닫히지 않습니다. 문을 닫을 방법을 찾아봐야 할 것 같습니다.")
t("#VIOLET#You hear a door closing.", "#VIOLET#문이 닫히는 소리가 들립니다.")
t("floor", "바닥")
t("lever", "레버")
t("huge lever", "거대한 레버")
t("trigger", "작동 장치")


------------------------------------------------
section "game/modules/tome/data/general/grids/snowy_forest.lua"

t("wall", "벽")
t("exit to the worldmap", "월드맵으로의 출구")
t("way to the previous level", "이전 층으로의 길")
t("floor", "바닥")
t("way to the next level", "다음 층으로의 길")


------------------------------------------------
section "game/modules/tome/data/general/grids/underground_dreamy.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/underground_gloomy.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/underground_slimy.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/void.lua"

t("wall", "벽")
t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/general/grids/water.lua"

t("door", "문")
t("wall", "벽")
t("open door", "열린 문")
t("exit to the worldmap", "월드맵으로의 출구")
t("previous level", "이전 층")
t("floor", "바닥")
t("next level", "다음 층")


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



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/heavy-armor.lua"



------------------------------------------------
section "game/modules/tome/data/general/objects/egos/helm.lua"



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
t("Transmogrification Chest", "변환 상자")


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

t("%s resists!", "%s 저항합니다!", nil, {"가"})


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
t("but nobody knew why #sex# suddenly became evil", "하지만 왜 그 #sex#이 타락했는지는 아무도 모릅니다.")
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

t("Temporal Warden", "시간 감시자")


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

t("You require two weapons to use this talent.", "이 기술을 사용하기 위해서는 쌍수 무기를 장비해야 합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/bow-threading.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/chronomancer.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/chronomancy.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/energy.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/fate-weaving.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/flux.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/gravity.lua"



------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/guardian.lua"

t("#ORCHID#%s has recovered!#LAST#", "#ORCHID#%s 회복했습니다!#LAST#", nil, {"가"})


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

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/timetravel.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


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

t("%s resists the silence!", "%s 침묵에 저항합니다!", nil, {"가"})
t("%s resists the disarm!", "%s 무장해제에 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/cunning/artifice.lua"

t("You cannot move!", "움직일 수 없습니다!")


------------------------------------------------
section "game/modules/tome/data/talents/cunning/called-shots.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/cunning.lua"

t("Called Shots", "침묵 사격")


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

t("Stealth", "은신")
t("You cannot be stealthy with such heavy armour on!", "중갑을 장비한 채로는 은신할 수 없습니다!")
t("You are being observed too closely to enter Stealth!", "적이 너무 가까이 있어 은신할 수 없습니다!")
t([[Enters stealth mode (power %d, based on Cunning), making you harder to detect.
		If successful (re-checked each turn), enemies will not know exactly where you are, or may not notice you at all.
		Stealth reduces your light radius to 0, increases your infravision by 3, and will not work with heavy or massive armours.
		You cannot enter stealth if there are foes in sight within range %d%s.
		Any non-instant, non-movement action will break stealth if not otherwise specified.

		Enemies uncertain of your location will still make educated guesses at it.
		While stealthed, enemies cannot share information about your location with each other and will be delayed in telling their allies that you exist at all.]], [[은신(power %d, 교활에 비례)하여, 적이 당신은 탐지하기 어렵게 합니다.
		은신에 성공(매 턴 성공 여부를 확인)한다면 적은 당신의 위치를 정확히 파악할 수 없고, 심지어는 당신이 있다는 걸 알아차릴 수 없을 때도 있습니다.
		은신 상태일 때 당신의 빛 반경은 0으로 감소하지만, 야간 투시력이 3만큼 증가합니다. 중갑이나 판갑을 착용한 상태에서는 은신할 수 없습니다.
		%d%s 반경 내에 눈이 보이는 적이 있으면 은신할 수 없습니다.
		이동을 제외한 턴을 소모하는 행동을 하면 은신이 해제됩니다. (은신 상태에서 사용할 수 있다는 설명이 적혀 있지 않는 한)

		적이 당신의 위치를 정확히 모른다고 하여도, 예측하여 공격을 시도할 것입니다.
		은신 상태일 때, 적들은 당신의 위치나 존재에 대한 정보를 공유하지 않습니다.]])
t("Shadowstrike", "암습")
t([[You know how to make the most out of being unseen.
		When striking from stealth, your attacks are automatically critical if the target does not notice you just before you land it.  (Spell and mind attacks critically strike even if the target notices you.)
		Your critical multiplier against targets that cannot see you is increased by up to %d%%. (You must be able to see your target and the bonus is reduced from its full value at range 3 to 0 at range 10.)
		Also, after exiting stealth for any reason, the critical multiplier persists for %d turns (with no range limitation).]], [[당신은 은신하는 동안 이를 최대한 활용하는 법을 알게 됩니다.
		은신 상태에서 공격할 때, 적이 당신을 인식하지 않은 상태라면 무조건 치명타가 발동합니다. (마법이나 정신 공격의 경우 당신을 인식한 상태여도 무조건 치명타가 발동합니다.)
		적이 당신을 인식하지 못했을 경우, 당신의 치명타 배율은 %d%%만큼 상승합니다. (당신은 반드시 대상을 볼 수 있어야 합니다. 치명타 배율 상승량은 대상이 3보다 멀 경우 점차 감소하여 10만큼 떨어진 적을 공격할 경우에는 치명타 배율이 상승하지 않습니다.)
		어떻게든 은신이 해제된 직후에는 %d 턴동안 치명타 배율이 상승합니다. (거리 제한 없음)]])
t("Soothing Darkness", "위로하는 어둠")
t([[You have a special affinity for darkness and shadows.
		When standing in an unlit grid, the minimum range to your foes for activating stealth or for maintaining it after a Shadow Dance is reduced by %d.
		While stealthed, your life regeneration is increased by %0.1f (based on your Cunning) and your stamina regeneration is increased by %0.1f.  The regeneration effects persist for %d turns after exiting stealth, with 5 times the normal rate.]], [[당신은 그림자와 암흑에 특별한 친밀감을 갖습니다.
		불빛이 없는 곳에 있으면, 은신을 시전하기 위한 최소 거리와 어둠의 춤의 지속 시간이 끝난 후 은신하기 위한 최소 거리가 %d만큼 감소합니다.
		은신 상태에서 생명력 회복량 %0.1f (교활에 비례) 만큼 증가하고 체력 회복량이 %0.1f 만큼 증가합니다.  회복량 증가는 은신이 해제될 경우 %d 턴만큼 추가로 유지되며, 회복량이 5배만큼 증가합니다.]])
t("Shadow Dance", "어둠의 춤")
t([[Your mastery of stealth allows you to vanish from sight at any time.
		You automatically enter stealth and cause it to not break from unstealthy actions for %d turns.]], [[당신은 은신을 숙달하여 언제든지 시야에서 사라질 수 있습니다.
		즉시 은신 상태가 되며, %d 턴동안 은신이 풀리는 행동을 하더라도 은신이 풀리지 않습니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/cunning/survival.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/tactical.lua"



------------------------------------------------
section "game/modules/tome/data/talents/cunning/traps.lua"

t("%s resists!", "%s 저항합니다!", nil, {"가"})


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

t("%s resists the silence!", "%s 침묵에 저항합니다!", nil, {"가"})


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

t("%s resists!", "%s 저항합니다!", nil, {"가"})


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

t("%s resists!", "%s 저항합니다!", nil, {"가"})


------------------------------------------------
section "game/modules/tome/data/talents/misc/misc.lua"



------------------------------------------------
section "game/modules/tome/data/talents/misc/npcs.lua"

t("%s resists the stunning blow!", "%s 기절의 일격에 저항합니다!", {"가"}, {"가"})
t("%s resists!", "%s 저항합니다!", nil, {"가"})
t("You cannot be stealthy with such heavy armour on!", "중갑을 장비한 채로는 은신할 수 없습니다!")
t("You require two weapons to use this talent.", "이 기술을 사용하기 위해서는 쌍수 무기를 장비해야 합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/misc/objects.lua"

t("You require a shield to use this talent.", "이 기술을 사용하려면 방패가 필요합니다.")


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

t("You require a shield to use this talent.", "이 기술을 사용하려면 방패가 필요합니다.")


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

t("Vault", "뛰어넘기")
t("You cannot land in that space.", "해당 장소엔 착지할 수 없습니다.")
t("You must vault over someone adjacent to you.", "인접한 누군가를 뛰어넘어야 합니다.")
t("#Source# #YELLOW#vaults#LAST# over #target#!", "#Source1# #target3# #YELLOW#뛰어넘었습니다#LAST#!")
t([[Use an adjacent friend or foe as a springboard, vaulting over them to another tile within range.
		This maneuver grants you a burst of speed from your momentum, allowing you run %d%% faster (movement speed bonus) in the same direction you vaulted for 3 turns.
		The increased speed ends if you change directions or stop moving.
		]], [[인접한 아군이나 적을 발판으로 이용해 범위 내의 다른 타일로 뛰어넘습니다.
		이 움직임으로 가속도를 받아 엄청난 속도를 내며 3턴 동안 도약한 방향으로 %d%% 더 빠르게 달릴 수 있습니다(이동 속도 보너스).
		만약 방향을 바꾸거나 움직임을 멈추면 증가된 속도 효과는 사라질 것입니다.
		]])
t("Tumble", "공중제비")
t("@Source@ tumbles to a better position!", "@Source@ 더 나은 위치로 공중제비했습니다!", nil, {"가"})
t("You cannot move!", "움직일 수 없습니다!")
t("You cannot tumble to that space.", "해당 위치로는 공중제비할 수 없습니다.")
t([[Move to a spot within range, bounding around, over, or through any enemies in the way.
		This maneuver can surprise your foes and improves your tactical position, improving your physical critical chance by %d%% for 1 turn.]], [[사거리 내의 장소로 공중제비하고 경로에 있는 적들을 통과해 이동합니다.
		이 행동으로 적을 기습하고 전술적 위치를 확보해 1턴 동안 물리 치명타 확률이 %d%% 증가합니다.]])
t("Trained Reactions", "훈련된 반사신경")
t([[While this talent is sustained, you anticipate deadly attacks against you.
		Any time you would lose more than %d%% of your maximum life in a single hit, you instead duck out of the way and assume a defensive posture.
		This reduces the triggering damage and all further damage in the same turn by %d%%.
		You need %0.1f Stamina and an adjacent open tile to perform this feat (though it does not cause you to move).]], [[이 기술을 사용 중일 때, 자신을 향한 치명적인 공격을 예측합니다.
		한 번의 공격으로 최대 생명력의 %d%% 이상을 잃을 때마다 회피하고 방어 자세를 취합니다.
		방어 자세를 발동시킨 공격과 같은 턴에 받은 모든 피해가 %d%% 감소합니다.
		이 능력을 사용하기 위해선 %0.1f 체력과 인접한 열린 타일이 있어야 합니다. (하지만 이동하지는 않습니다.)]])
t("Superb Agility", "우월한 재주")
t([[You gain greater facility with your acrobatic moves, lowering the cooldowns of Vault, Tumble, and Trained Reactions by %d, and their stamina costs by %0.1f.
		At Rank 3 you also gain 10%% global speed for 1 turn after Trained Reactions activates. At rank 5 this speed bonus improves to 20%% and lasts for 2 turns.]], [[곡예 행동으로 인한 능력이 크게 증가하여 뛰어넘기, 공중제비, 훈련된 반사신경의 재사용 대기시간이 %d, 체력 소모량이 %0.1f 감소합니다.
		레벨 3에서 훈련된 반사신경 이후 1턴 동안 전체 속도가 10%% 증가합니다. 레벨 5에서 이 속도 보너스가 20%%로 증가하고 2턴 동안 유지됩니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/agility.lua"

t("Agile Defense", "민첩한 방어")
t("%s(%d deflected)#LAST#", "%s(%d 굴절)#LAST#")
t([[You are trained in an agile, mobile fighting technique combining sling and shield. This allows shields to be equipped, using Dexterity instead of Strength as a requirement.
While you have a shield equip and your Block talent is not on cooldown, you have a %d%% chance to deflect any incoming damage, reducing it by 50%% of your shield’s block value.]], [[민첩 훈련을 통해 투석구와 방패를 함께 사용하는 기동력 있는 전투 기술을 익혔습니다. 이를 통해 힘 대신 민첩을 필요조건으로 사용해 방패를 장비할 수 있습니다.
방패를 장비 중이고 방어 기술이 재사용 대기시간이 아닐 때, %d%% 확률로 받는 공격을 굴절시켜 방패 방어 수치의 50%%만큼 피해가 감소합니다.]])
t("Vault", "뛰어넘기")
t("You require a shield to use this talent.", "이 기술을 사용하려면 방패가 필요합니다.")
t("%s resists the daze!", "%s 혼절에 저항했습니다!", nil, {"가"})
t([[Leap onto an adjacent target with your shield, striking them for %d%% damage and dazing them for 2 turns, then using them as a springboard to leap to a tile within range %d.
The shield bash will use Dexterity instead of Strength for the shield's bonus damage.
At talent level 5, you will immediately enter a blocking stance on landing.]], [[인접한 대상을 뛰어넘으며 방패로 공격해 %d%% 피해를 주고 2턴 동안 혼절시킵니다. 그리고 대상을 발판으로 사용해 %d칸 안에 있는 타일로 이동합니다.
방패 강타는 힘 대신 민첩을 사용해 방패의 보너스 피해를 적용합니다.
레벨 5에서 착지 이후 즉시 방어 자세로 진입합니다.]])
t("Bull Shot", "돌진 사격")
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")
t([[You rush toward your foe, readying your shot. If you reach the enemy, you release the shot, imbuing it with great power.
		The shot does %d%% weapon damage and knocks back your target by %d.
		The cooldown of this talent is reduced by 1 each time you move.
		This requires a sling to use.]], [[적을 향해 돌진하며 사격을 준비합니다. 적에게 접근하면 엄청난 힘이 담긴 사격을 합니다.
		사격은 %d%% 무기 피해를 주고 대상을 %d칸 밀어냅니다.
		이 기술의 재사용 대기시간은 이동할 때마다 1씩 감소합니다.
		이 기술을 사용하려면 투석구가 필요합니다.]])
t("Rapid Shot", "속사")
t("You cannot use Rapid Fire without a bow or sling!", "활이나 투석구가 없으면 속사를 사용할 수 없습니다!")
t([[Enter a fluid, mobile shooting stance that excels at close combat. Your ranged attack speed is increased by %d%% and each time you shoot you gain %d%% increased movement speed for 2 turns.
Ranged attacks against targets will also grant you up to %d%% of a turn. This is 100%% effective against targets within 3 tiles, and decreases by 20%% for each tile beyond that (to 0%% at 8 tiles). This cannot occur more than once per turn.
Requires a sling to use.]], [[근거리 전투에 능한 유연하고 유동적인 사격 자세에 돌입합니다. 원거리 공격 속도가 %d%% 증가하고 사격할 때마다 2턴 동안 이동속도가 %d%% 증가합니다.
대상을 향한 원거리 공격은 턴의 최대 %d%%를 사용합니다. 3타일 이내의 대상에겐 100%% 효과적이고 한 칸씩 멀어질 때마다 효과가 20%% 감소해 8타일 거리에서 0%%가 됩니다. 한 턴에 두 번 이상 발동하지 않습니다.
사용하려면 투석구가 필요합니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/archery.lua"

t("Shoot", "사격")
t("@Source@ shoots!", "@Source1@ 사격합니다!")
t("Shoot your bow, sling or other missile launcher!", "활, 투석구 혹은 기타 투사체 발사기로 사격합니다!")
t("Steady Shot", "안정된 사격")
t([[Fire a steady shot, doing %d%% damage with a %d%% chance to mark the target.
If Steady Shot is not on cooldown, this talent will automatically replace your normal attacks (and trigger the cooldown).]], [[안정된 사격으로 %d%% 피해를 주고 %d%% 확률로 대상에 표적을 남깁니다.
만약 안정된 사격이 재사용 대기시간이 아니라면 이 기술은 자동으로 일반 공격을 대체하고 재사용 대기시간을 발동합니다.]])
t("Pin Down", "속박 사격")
t([[You fire a shot for %d%% damage that attempts to pin your target to the ground for %d turns, as well as giving your next Steady Shot or Shoot 100%% increased chance to critically hit and mark (regardless of whether the pin succeeds).
		This shot has a 20%% chance to mark the target.
		The chance to pin increases with your Accuracy.]], [[사격으로 %d%% 피해를 주고 일정 확률로 대상을 %d턴 동안 속박합니다. 다음 안정된 사격이나 사격의 치명타 공격 확률과 표적을 남길 확률이 100%% 증가합니다. (속박 성공 여부와는 상관 없습니다.)
		이 사격은 20%% 확률로 대상에 표적을 남깁니다.
		속박 확률은 정확도의 영향을 받아 증가합니다.]])
t("Fragmentation Shot", "파편 사격")
t([[Fires a shot that explodes into a radius %d ball of razor sharp fragments on impact, dealing %d%% weapon damage and leaving targets crippled for %d turns, reducing their attack, spell and mind speed by %d%%.
		Each target struck has a %d%% chance to be marked.
		The status chance increases with your Accuracy.]], [[원형 %d칸 범위 안에 폭발하는 날카로운 파편을 발사합니다. 폭발하면 %d%% 무기 피해를 주고 %d턴 동안 대상을 불구로 만들어 대상의 공격, 주문, 정신 속도가 %d%% 감소합니다.
		적중한 모든 대상에게 %d%% 확률로 표적을 남깁니다.
		상태 이상 확률은 정확도의 영향을 받아 증가합니다.]])
t("Scatter Shot", "산탄 사격")
t("%s resists the scattershot!", "%s 산탄 사격에 저항했습니다!", nil, {"가"})
t([[Fires a wave of projectiles in a radius %d cone, dealing %d%% weapon damage. All targets struck by this will be knocked back to the maximum range of the cone and stunned for %d turns.
		Each target struck has a %d%% chance to be marked.
		The chance to knockback and stun increases with your Accuracy.]], [[원뿔형 %d칸 범위 안에 다수의 투사체를 발사해 %d%% 무기 피해를 줍니다. 공격에 적중된 모든 대상은 최대 범위 밖으로 밀려나고 %d턴 동안 기절합니다.
		적중한 모든 대상에게 %d%% 확률로 표적을 남깁니다.
		밀어내기와 기절 확률은 정확도의 영향을 받아 증가합니다.]])
t("Headshot", "헤드샷")
t([[Fire a precise shot dealing %d%% weapon damage, with 100 increased accuracy. This shot will bypass other enemies between you and your target.
Only usable against marked targets, and consumes the mark on hit.]], [[정확한 사격으로 정확도가 100 증가하고 %d%% 무기 피해를 줍니다. 사격은 사용자와 대상 사이에 있는 모든 다른 적들을 우회합니다.
표적이 찍힌 대상을 상대로만 사용할 수 있고 적중하면 표적을 소모합니다.]])
t("Volley", "일제 사격")
t([[You fire countless shots into the sky to rain down around your target, inflicting %d%% weapon damage to all within radius %d.
If the primary target is marked, you consume the mark to fire a second volley of arrows for %d%% damage at no ammo cost.]], [[하늘에 셀 수 없이 많은 사격을 해 대상 주변으로 화살비를 내리고 %d칸 안에 있는 모든 대상에게 %d%% 무기 피해를 줍니다.
만약 주요 대상이 표적에 찍힌 상태라면 표적을 소모해 화살을 사용하지 않고 두 번째 일제 사격으로 %d%% 피해를 줍니다.]], {2,1,3})
t("Called Shots", "침묵 사격")
t("%s resists the silence!", "%s 침묵에 저항합니다!", nil, {"가"})
t("%s resists the disarm!", "%s 무장해제에 저항합니다!", nil, {"가"})
t("%s resists the slow!", "%s 감속에 저항합니다!", nil, {"가"})
t([[You fire a disabling shot at a target's throat (or equivalent), dealing %d%% weapon damage and silencing them for %d turns.
If the target is marked, you consume the mark to fire two secondary shots at their arms and legs (or other appendages) dealing %d%% damage, reducing their movement speed by 50%% and disarming them for the duration.
The status chance increases with your Accuracy.]], [[대상의 입이나 비슷한 기관을 막는 사격으로 %d%% 무기 피해를 주고 %d턴 동안 침묵을 겁니다.
만약 대상이 표적에 찍힌 상태라면 표적을 소모하여 대상의 팔과 다리 혹은 부속기관을 노리는 두 번째 사격을 발사하고 %d%% 피해를 줍니다. 동시에 대상의 이동 속도가 50%% 감소하고 무장해제됩니다.
상태이상 확률은 정확도의 영향을 받아 증가합니다.]])
t("Bullseye", "정조준")
t("Each time you consume a mark, you gain %d%% increased attack speed for 2 turns and the cooldown of %d random techniques are reduced by %d turns.", "표적을 소모할 때마다 2턴 동안 공격 속도가 %d%% 증가하고 무작위 기술 %d개의 재사용 대기시간이 %d턴 감소합니다.")
t("Relaxed Shot", "여유로운 사격")
t([[You fire a shot without putting much strength into it, doing %d%% damage.
		That brief moment of relief allows you to regain %d stamina.]], [[많은 힘을 싣지 않고 사격해 %d%% 피해를 줍니다.
		짧은 순간의 안도로 %d 체력을 회복합니다.]])
t("Crippling Shot", "무력화 사격")
t([[You fire a crippling shot, doing %d%% damage and reducing your target's speed by %d%% for 7 turns.
		The status power and status hit chance improve with your Accuracy.]], [[무력화 사격으로 %d%% 피해를 주고 대상의 속도가 7턴 동안 %d%% 감소합니다.
		상태이상의 위력과 확률은 정확도의 영향을 받아 증가합니다.]])
t("Pinning Shot", "속박 사격")
t("%s resists!", "%s 저항합니다!", nil, {"가"})
t([[You fire a pinning shot, doing %d%% damage and pinning your target to the ground for %d turns.
		The pinning chance increases with your Dexterity.]], [[속박 사격으로 %d%% 피해를 주고 %d턴 동안 대상을 속박합니다.
		속박 확률은 민첩의 영향을 받아 증가합니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/assassination.lua"

t("Coup de Grace", "최후의 일격")
t("You require two weapons to use this talent.", "이 기술을 사용하기 위해서는 쌍수 무기를 장비해야 합니다.")
t("You cannot use Coup de Grace without dual wielding!", "쌍수 무기를 장비하지 않으면 최후의 일격을 사용할 수 없습니다!")
t("#Source# delivers a Coup de Grace against #Target#!", "#Source1# #Target#에게 최후의 일격을 날립니다. #Target#!")
t("%s resists the Coup de Grace!", "%s 최후의 일격에 저항합니다!", nil, {"는"})
t("#GREY#%s slips into shadow.", "#GREY#%s 그림자 속으로 사라집니다.", nil, {"는"})
t([[Attempt to finish off a wounded enemy, striking them with both weapons for %d%% increased by 50%% if their life is below 30%%.  A target brought below 20%% of its maximum life must make a physical save against your Accuracy or be instantly slain.
		You may take advantage of finishing your foe this way to activate stealth (if known).]], [[부상을 입은 적을 끝장내려는 시도를 합니다. 양 손에 든 무기로 %d%% 의 피해를 줍니다. 대상의 생명력이 30%% 미만일 경우, 피해량이 50%% 증가합니다. 대상의 생명력이 최대 생명력의 20%% 미만일 경우, 정확도에 따른 즉사 공격을 시도하며, 대상이 물리 내성으로 저항하지 못하면 즉사합니다.
		(은신을 배운 경우에만) 이 기술로 적을 마무리하면 자동으로 은신을 시전합니다.]])
t("Terrorize", "공포")
t([[When you exit stealth, you reveal yourself dramatically, intimidating foes around you. 
		All foes within radius %d that witness you leaving stealth will be stricken with terror, which randomly inflicts stun, slow (40%% power), or confusion (50%% power) for %d turns.
		The chance to terrorize improves with your combat accuracy.]], [[은신이 해제될 때, 극적으로 등장하여 주위의 적을 위협합니다. 
		반경 %d 칸 내의 적은 당신의 등장을 알아채고 겁에 질려 무작위로 기절, 느려짐 (40%% 위력), 혼란(50%% 위력)을 %d동안 유발합니다. 
		정확도가 높을수록 공포에 빠질 확률이 높아집니다.]])
t("Garrote", "교살")
t("#Target# avoids a garrote from #Source#!", "#Target1# #Source#의 교살을 회피했습니다!")
t([[When attacking from stealth, you slip a garrote over the target’s neck (or other vulnerable part).  This strangles for %d turns and silences for %d turns.  Strangled targets are pinned and suffer an automatic unarmed attack for %d%% damage each turn. 
		Your chance to apply the garrote increases with your Accuracy and you must stay adjacent to your target to maintain it.
		This talent has a cooldown.]], [[은신한 상태에서 공격 시, 대상의 목(또는 다른 취약한 부위)을 조릅니다. 목 조르기는 %d턴 동안 유지되며 대상을 %d턴 동안 침묵시킵니다. 목이 졸린 대상은 속박되며 매 턴 %d%%의 맨손 피해를 입습니다. 
		교살이 성공할 확률은 정확도에 비례하며, 교살이 발동하는 동안 대상으로부터 떨어지면 해제됩니다.
		이 기술은 재사용 대기 시간이 존재합니다.]])
t("Marked for Death", "죽음의 표식")
t([[You mark a target for death for 4 turns, causing them to take %d%% increased damage from all sources. When this effect ends they will immediately take physical damage equal to %0.2f plus %d%% of all damage taken while marked.
		If a target dies while marked, the cooldown of this ability is reset and the cost refunded.
		This ability can be used without breaking stealth.
		The base damage dealt will increase with your Dexterity.]], [[4턴 동안 대상에게 죽음의 표식을 부여하여 받는 피해량을 %d%% 증가시킵니다. 표식의 지속 시간이 끝날때 대상은 표식의 지속 시간동안 받은 피해의 %0.2f + %d%% 만큼 추가적인 물리 피해를 입습니다.
		죽음의 표식이 남은 상태로 대상이 사망하면 이 스킬의 재사용 대기 시간이 초기화되며, 사용된 자원이 반환됩니다.
		이 기술은 은신 상태를 해제하지 않습니다.
		민첩에 기반하여 기본 피해량이 증가합니다.]])


------------------------------------------------
section "game/modules/tome/data/talents/techniques/battle-tactics.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/bloodthirst.lua"

t("Unstoppable", "저지 불가")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/bow.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/buckler-training.lua"



------------------------------------------------
section "game/modules/tome/data/talents/techniques/combat-techniques.lua"

t("Rush", "돌진")
t("@Source@ rushes out!", "@Source@ 돌진합니다!", nil, {"가"})
t("You can only rush to a creature.", "오직 다른 대상에게만 돌진할 수 있습니다.")
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")
t([[Rush toward a target enemy with incredible speed and perform a melee attack for 120%% weapon damage that can daze the target for 3 turns if it hits.
		You must rush from at least 2 tiles away.]], [[놀라운 속도로 대상에게 돌진해 120%% 무기 피해를 주고 적중하면 3턴 동안 대상을 혼절시킵니다.
		적어도 2타일 이상 떨어져 있어야 합니다.]])
t("Precise Strikes", "정밀한 일격")
t([[You focus your strikes, reducing your attack speed by %d%% and increasing your Accuracy by %d and critical chance by %d%%.
		The effects will increase with your Dexterity.]], [[공격에 집중해 공격 속도가 %d%% 감소, 정확도가 %d 증가, 치명타율이 %d%% 증가합니다.
		효과는 민첩의 영향을 받아 증가합니다.]])
t("Perfect Strike", "완벽한 일격")
t("You have learned to focus your blows to hit your target, granting +%d accuracy and allowing you to attack creatures you cannot see without penalty for the next %d turns.", "대상을 공격하는 순간 집중하는 법을 깨우쳤습니다. 정확도가 +%d 증가하며 %d턴 동안 보이지 않는 대상을 페널티 없이 공격할 수 있습니다.")
t("Blinding Speed", "눈부신 속도")
t("Through rigorous training, you have learned to focus your actions for a short while, increasing your speed by %d%% for 5 turns.", "철저한 훈련을 통해 일시적으로 집중력을 끌어올리는 법을 익혔습니다. 5턴 동안 속도가 %d%% 증가합니다.")
t("Quick Recovery", "빠른 회복")
t("Your combat focus allows you to regenerate stamina faster (+%0.1f stamina/turn).", "전투 집중을 통해 더 빠르게 체력을 재생할 수 있습니다(+%0.1f 체력/턴).")
t("Fast Metabolism", "빠른 신진대사")
t("Your combat focus allows you to regenerate life faster (+%0.1f life/turn).", "전투 집중을 통해 더 빠르게 생명력을 재생할 수 있습니다(+%0.1f 생명력/턴).")
t("Spell Shield", "주문 방어")
t("Rigorous training allows you to be more resistant to some spell effects (+%d spell save).", "철저한 훈련을 통해 일부 주문 효과에 대한 저항력이 증가합니다(주문 내성 +%d).")
t("Unending Frenzy", "끝나지 않는 광란")
t("You revel in the death of your foes, regaining %0.1f stamina with each death you cause.", "적의 죽음에 고무되어 상대를 죽일 때마다 체력이 %0.1f 회복됩니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/combat-training.lua"

t("Thick Skin", "두꺼운 피부")
t("Your skin becomes more resilient to damage. Increases resistance to all damage by %0.1f%%.", "피부가 튼튼해져 피해에 대한 저항력이 증가합니다. 모든 피해에 대한 저항력이 %0.1f%% 증가합니다.")
t("Heavy Armour Training", "중갑 훈련")
t("You cannot use your %s anymore.", "더 이상 %s 사용할 수 없습니다.", nil, {"를"})
t("(Note that brawlers will be unable to perform many of their talents in massive armour.)", "(격투가는 거대한 갑옷을 입고 많은 기술을 사용할 수 없다는 사실을 명심하십시오.)")
t("(Note that wearing mail or plate armour will interfere with stealth.)", "(중갑이나 판갑을 착용하면 은신에 방해된다는 사실을 명심하십시오.)")
t([[You become better at using your armour to deflect blows and protect your vital areas. Increases Armour value by %d, Armour hardiness by %d%%, and reduces the chance melee or ranged attacks critically hit you by %d%% with your current body armour.
		(This talent only provides bonuses for heavy mail or massive plate armour.)
		At level 1, it allows you to wear heavy mail armour, gauntlets, helms, and heavy boots.
		At level 2, it allows you to wear shields.
		At level 3, it allows you to wear massive plate armour.
		%s]], [[갑옷을 사용해 공격을 흘리거나 주요 부위를 보호하는 기술을 익혔습니다. 방어력 수치가 %d 증가, 방어 효율이 %d%% 증가하고 현재 착용한 갑옷으로 적의 근거리 및 원거리 공격이 치명타로 적용될 확률이 %d%% 감소합니다.
		(이 기술은 중갑 및 판갑에만 보너스가 적용됩니다.)
		레벨 1에서 중갑, 전투 장갑, 투구, 전투 장화를 착용할 수 있습니다.
		레벨 2에서 방패를 착용할 수 있습니다.
		레벨 3에서 판금 갑옷을 착용할 수 있습니다.
		%s]])
t("Light Armour Training", "경갑 훈련")
t([[You learn to maintain your agility and manage your combat posture while wearing light armour.  When wearing armour no heavier than leather in your main body slot, you gain %d Defense, %d%% Armour hardiness, and %d%% reduced Fatigue.
		In addition, when you step adjacent to a (visible) enemy, you use the juxtaposition to increase your total Defense by %d for 2 turns.
		The Defense bonus scales with your Dexterity.]], [[경갑을 착용하며 민첩함과 전투 자세를 유지하는 법을 익혔습니다. 신체에 가죽보다 무겁지 않은 갑옷을 착용할 때, 방어력이 %d, 방어 효율이 %d%% 증가하고 피로도가 %d%% 감소합니다.
		추가로 (눈에 보이는) 적과 인접한 곳으로 이동할 때, 적과 나란히 서서 2턴 동안 총 방어력이 %d 증가합니다.
		방어 보너스는 민첩의 영향을 받아 증가합니다.]])
t("Combat Accuracy", "전투 정확도")
t("Increases the accuracy of unarmed, melee and ranged weapons by %d.", "맨손 전투, 근접 및 원거리 무기의 정확도가 %d 증가합니다.")
t("Weapons Mastery", "무기 숙련")
t("Increases weapon damage by %d%% and physical power by 30 when using swords, axes or maces.", "검, 도끼, 메이스를 사용할 때, 무기 피해가 %d%%, 물리력이 30 증가합니다.")
t("Dagger Mastery", "단검 숙련")
t("Increases weapon damage by %d%% and physical power by 30 when using daggers.", "단검을 사용할 때, 무기 피해가 %d%%, 물리력이 30 증가합니다.")
t("Exotic Weapons Mastery", "이형 무기 숙련")
t("Increases weapon damage by %d%% and physical power by 30 when using exotic weapons.", "이형 무기를 사용할 때, 무기 피해가 %d%%, 물리력이 30 증가합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/conditioning.lua"

t("Vitality", "활력")
t([[You recover faster from poisons, diseases and wounds, reducing the duration of all such effects by %d%%.  
			Whenever your life falls below 50%%, your life regeneration increases by %0.1f for %d turns (%d total). This effect can only happen once every %d turns.
		The regeneration scales with your Constitution.]], [[중독, 질병, 부상에서 더욱 빠르게 회복하고 이러한 모든 효과의 지속시간이 %d%% 감소합니다.  
			생명력이 50%% 이하로 떨어질 때마다 생명력 재생이 %0.1f, %d턴 동안 증가합니다(총 %d). 이 효과는 %d턴당 한 번만 적용됩니다.
		재생 효과는 건강의 영향을 받아 증가합니다.]])
t("Unflinching Resolve", "불굴의 의지")
t("#ORCHID#%s has recovered!#LAST#", "#ORCHID#%s 회복했습니다!#LAST#", nil, {"가"})
t([[You've learned to recover quickly from effects that would disable you. Each turn, you have a %d%% chance to recover from a single stun effect.
		At talent level 2 you may also recover from blindness, at level 3 confusion, level 4 pins, and level 5 disarms and slows.
		Effects will be cleansed with the priority order Stun > Blind > Confusion > Pin > Slow > Disarm.
		Only one effect may be recovered from each turn, and the chance to recover from an effect scales with your Constitution.]], [[무력화 효과로부터 빠르게 회복하는 법을 익혔습니다. 턴마다 %d%% 확률로 하나의 기절 효과에서 회복합니다.
		기술 레벨 2에서 실명, 레벨 3에서 혼란, 레벨 4에서 속박, 레벨 5에서 무장해제 및 감속에서 회복할 수 있습니다.
		효과는 기절 > 실명 > 혼란 > 속박 > 감속 > 무장해제 순으로 회복됩니다.
		턴마다 오직 하나의 효과에서 회복될 수 있으며 회복 확률은 건강의 영향을 받아 증가합니다.]])
t("Daunting Presence", "위협적인 존재감")
t([[Enemies are intimidated by your very presence.
		Enemies within radius %d have their Physical Power, Mindpower, and Spellpower reduced by %d.
		The power of the intimidation effect improves with your Physical power]], [[적들의 당신의 존재에 위협을 받습니다.
		%d 범위 안에 있는 적들은 물리력, 정신력, 주문력이 %d 감소합니다.
		위협 효과는 물리력의 영향을 받아 증가합니다.]])
t("Adrenaline Surge", "아드레날린 분출")
t([[You release a surge of adrenaline that increases your Physical Power by %d for %d turns. While the effect is active, you may continue to fight beyond the point of exhaustion.
		You may continue to use stamina based talents while at zero stamina at the cost of life.
		The Physical Power increase will scale with your Constitution.
		Using this talent does not take a turn.]], [[아드레날린을 분출해 물리력이 %d턴 동안 %d 증가합니다. 효과가 발휘 중일 때, 탈진의 한계를 넘어 계속 싸울 수 있습니다.
		체력이 바닥일 때, 생명력을 사용해 계속해서 체력을 사용할 수도 있습니다.
		물리력은 건강의 영향을 받아 증가합니다.
		이 기술은 사용할 때 턴을 소모하지 않습니다.]], {2,1})


------------------------------------------------
section "game/modules/tome/data/talents/techniques/dualweapon.lua"

t("Dual Weapon Training", "쌍수 무기 훈련")
t("Increases the damage of your off-hand weapon to %d%%.", "보조 무기의 피해가 %d%% 증가합니다.")
t("Dual Weapon Defense", "쌍수 방어")
t([[You have learned to block incoming blows with your offhand weapon.
		When dual wielding, your defense is increased by %d.
		Up to %0.1f times a turn, you have a %d%% chance to parry up to %d damage (based on your your offhand weapon damage) from a melee attack.
		A successful parry reduces damage like armour (before any attack multipliers) and prevents critical strikes.  Partial parries have a proportionally reduced chance to succeed.  It is difficult to parry attacks from unseen attackers and you cannot parry with a mindstar.
		The defense and chance to parry improve with Dexterity.  The number of parries increases with Cunning.]], [[보조 무기로 공격을 막는 방법을 배웠습니다.
		쌍수 무기를 착용 중일 때, 방어가 %d 증가합니다.
		턴마다 %0.1f번, %d%% 확률로 근접 공격의 피해를 최대 %d 쳐냅니다(보조 무기의 피해량 기반).
		성공적으로 공격을 쳐내면 갑옷과 동일하게(공격 계수 적용 전) 피해가 감소하고 치명적인 공격을 방지합니다. 부분적인 쳐내기는 성공 확률이 비례하여 감소합니다. 보이지 않는 적의 공격은 쳐내기 어렵고 마석으로는 쳐내기를 사용할 수 없습니다.
		방어와 쳐내기 확률은 민첩의 영향을 받아 증가합니다. 쳐내기 횟수는 교활의 영향을 받아 증가합니다.]])
t("Close Combat Management", "근접 전투 통제")
t("You must dual wield to use this talent.", "이 기술을 사용하려면 쌍수 무기를 사용해야 합니다.")
t("You must dual wield to manage contact with your target!", "대상과의 접전을 통제하려면 쌍수 무기를 사용해야 합니다!")
t([[You have learned how to carefully manage contact between you and your opponent.
		When striking in melee with your dual wielded weapons, you automatically avoid up to %d damage dealt to you from each of your target's on hit effects.  This improves with your Dexterity, but is not possible with mindstars.
		In addition, while this talent is active, you redirect %d%% of the damage you avoid this way back to your target.]], [[당신과 대상 사이의 접전을 조심스럽게 통제하는 법을 배웠습니다.
		근접해서 쌍수 무기로 공격할 때, 자동으로 대상의 적중 효과로 당신에게 가해지는 피해를 최대 %d 회피합니다. 이 효과는 민첩의 영향을 받아 증가하지만, 마석으로는 사용할 수 없습니다.
		추가로 이 기술이 활성화 상태일 때, 회피한 피해의 %d%%를 대상에게 다시 돌려줍니다.]])
t("Offhand Jab", "보조 찌르기")
t("You must dual wield to perform an Offhand Jab!", "보조 찌르기를 사용하려면 쌍수 무기를 사용해야 합니다!")
t("%s resists the surprise strike!", "%s 기습 공격에 저항했습니다!", nil, {"가"})
t([[With a quick shift of your momentum, you execute a surprise unarmed strike in place of your normal offhand attack.
		This allows you to attack with your mainhand weapon for %d%% damage and unarmed for %d%% damage.  If the unarmed attack hits, the target is confused (%d%% power) for %d turns.
		The chance to confuse increases with your Accuracy.]], [[탄력을 빠르게 이용해 기습적으로 일반적인 보조무기 공격 대신 맨손 공격을 합니다.
		주무기로 공격해 %d%% 피해를 주고 맨손으로 공격해 %d%% 피해를 줍니다. 만약 맨손 공격이 적중하면, 대상은 혼란 상태에(%d%% 위력) %d턴 동안 빠지게 됩니다.
		혼란 확률은 정확도의 영향을 받아 증가합니다.]])
t("Dual Strike", "이중 공격")
t("You cannot use Dual Strike without dual wielding!", "쌍수 무기 없이는 이중 공격을 사용할 수 없습니다!")
t("%s resists the stunning strike!", "%s 기절의 일격에 저항했습니다!", nil, {"가"})
t([[Attack with your offhand weapon for %d%% damage. If the attack hits, the target is stunned for %d turns, and you hit it with your mainhand weapon doing %d%% damage.
		The stun chance increases with your Accuracy.]], [[보조 무기로 공격해 %d%% 피해를 줍니다. 만약 공격이 적중하면 대상은 %d턴 동안 기절하고 주무기로 공격하여 %d%% 피해를 줍니다.
		기절 확률은 정확도의 영향을 받아 증가합니다.]])
t("Flurry", "일진광풍")
t("You cannot use Flurry without dual wielding!", "쌍수 무기 없이는 일진광풍을 사용할 수 없습니다!")
t("Lashes out with a flurry of blows, hitting your target three times with each weapon for %d%% damage.", "일진광풍을 일으켜 각 무기로 세 번씩 %d%% 피해를 줍니다.")
t("Heartseeker", "급소 노리기")
t("Swiftly leap to your target and strike at their vital points with both weapons, dealing %d%% weapon damage. This attack deals %d%% increased critical strike damage.", "민첩하게 대상에게 도약해 각 무기로 대상의 치명적인 부위를 공격하고 %d%% 무기 피해를 줍니다. 이 공격은 %d%% 증가한 치명타 공격 피해를 줍니다.")
t("Whirlwind", "선풍")
t("You require two weapons to use this talent.", "이 기술을 사용하기 위해서는 쌍수 무기를 장비해야 합니다.")
t("The target location must be within range and within view.", "대상이 범위 및 시야 내에 있어야 합니다.")
t("There is no open space in which to land near there.", "근처에 이동할 수 있는 열린 공간이 없습니다.")
t("%s becomes a whirlwind of weapons!", "%s 무기의 선풍을 일으켰습니다!", nil, {"가"})
t("You quickly move up to %d tiles to arrive adjacent to a target location you can see, leaping around or over anyone in your way.  During your movement, you attack all foes within one grid of your path with both weapons for %d%% weapon damage, causing those struck to bleed for 50%% of the damage dealt over 5 turns.", "신속하게 최대 %d타일을 이동해 시야에 들어온 대상과 인접한 장소로 이동하고 경로에 있는 모든 대상을 뛰어넘습니다. 이동 중 경로에서 한 칸 내에 있는 모든 적들을 각 무기로 공격해 %d%% 무기 피해를 주고 출혈을 일으켜 5턴 동안 50%% 만큼의 피해를 줍니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/duelist.lua"

t("You must be able to move to use this talent.", "이 기술을 사용하려면 이동할 수 있어야 합니다.")
t("You require two weapons to use this talent.", "이 기술을 사용하기 위해서는 쌍수 무기를 장비해야 합니다.")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/excellence.lua"

t("Bull Shot", "돌진 사격")
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!")


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

t("Tumble", "공중제비")
t("Trained Reactions", "훈련된 반사신경")


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

t("%s resists!", "%s 저항합니다!", nil, {"가"})


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

t("Ghoul", "구울")


------------------------------------------------
section "game/modules/tome/data/talents/undeads/skeleton.lua"

t("Skeleton", "스켈레톤")


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



------------------------------------------------
section "game/modules/tome/data/timed_effects/mental.lua"



------------------------------------------------
section "game/modules/tome/data/timed_effects/other.lua"

t("Unstoppable", "저지 불가")


------------------------------------------------
section "game/modules/tome/data/timed_effects/physical.lua"

t("Sunder Armour", "방어구 부수기")
t("Sunder Arms", "무기 부수기")
t("Adrenaline Surge", "아드레날린 분출")
t("Superb Agility", "우월한 재주")
t("Garrote", "교살")
t("Marked for Death", "죽음의 표식")
t("Soothing Darkness", "위로하는 어둠")
t("Shadow Dance", "어둠의 춤")
t("Bullseye", "정조준")
t("Shadowstrike", "암습")


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

t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/npcs.lua"

t("halfling", "하플링")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/arena-unlock/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/arena/grids.lua"

t("floor", "바닥")
t("wall", "벽")


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

t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/zones/charred-scar/npcs.lua"

t("shalore", "샬로레")
t("human", "인간")
t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/charred-scar/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/conclave-vault/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/crypt-kryl-feijan/grids.lua"

t("floor", "바닥")
t("sealed door", "봉인된 문")


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

t("door", "문")
t("floor", "바닥")
t("wall", "벽")
t("open door", "열린 문")


------------------------------------------------
section "game/modules/tome/data/zones/dreams/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/dreams/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/dreamscape-talent/grids.lua"

t("floor", "바닥")


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

t("floor", "바닥")
t("wall", "벽")


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

t("floor", "바닥")
t("door", "문")
t("open door", "열린 문")
t("wall", "벽")


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

t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/heart-gloom/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/heart-gloom/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/high-peak/grids.lua"

t("next level", "다음 층")


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

t("door", "문")
t("open door", "열린 문")
t("wall", "벽")
t("floor", "바닥")
t("next level", "다음 층")


------------------------------------------------
section "game/modules/tome/data/zones/infinite-dungeon/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/infinite-dungeon/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/keepsake-meadow/grids.lua"

t("door", "문")
t("floor", "바닥")
t("wall", "벽")
t("open door", "열린 문")


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

t("wall", "벽")
t("floor", "바닥")


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

t("wall", "벽")


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

t("wall", "벽")


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

t("floor", "바닥")
t("wall", "벽")


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

t("sealed door", "봉인된 문")


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

t("but nobody knew why #sex# suddenly became evil", "하지만 왜 그 #sex#이 타락했는지는 아무도 모릅니다.")


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

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/shertul-fortress/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/grids.lua"

t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slazish-fen/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/slime-tunnels/grids.lua"

t("sealed door", "봉인된 문")


------------------------------------------------
section "game/modules/tome/data/zones/slime-tunnels/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/grids.lua"

t("sealed door", "봉인된 문")


------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/npcs.lua"

t("giant", "거인")


------------------------------------------------
section "game/modules/tome/data/zones/sludgenest/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/south-beach/grids.lua"

t("floor", "바닥")
t("exit to the worldmap", "월드맵으로의 출구")


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

t("Temporal Warden", "시간 감시자")


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

t("floor", "바닥")


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

t("wall", "벽")


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

t("floor", "바닥")


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

t("wall", "벽")
t("floor", "바닥")


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

t("floor", "바닥")
t("wall", "벽")


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

t("wall", "벽")


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

t("floor", "바닥")
t("wall", "벽")
t("sealed door", "봉인된 문")


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

t("wall", "벽")


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

t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/zones/valley-moon/npcs.lua"

t("humanoid", "인간형")


------------------------------------------------
section "game/modules/tome/data/zones/valley-moon/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/void/grids.lua"

t("Temporal Warden", "시간 감시자")


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

t("floor", "바닥")


------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/npcs.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/objects.lua"



------------------------------------------------
section "game/modules/tome/data/zones/vor-pride/zone.lua"



------------------------------------------------
section "game/modules/tome/data/zones/wilderness/grids.lua"

t("floor", "바닥")
t("wall", "벽")


------------------------------------------------
section "game/modules/tome/data/zones/wilderness/zone.lua"



------------------------------------------------
section "game/modules/tome/dialogs/ArenaFinish.lua"

t("Message Log", "메시지 로그")


------------------------------------------------
section "game/modules/tome/dialogs/Birther.lua"

t("Female", "여성")
t("Male", "남성")
t("Overwrite character?", "캐릭터를 덮어씌우시겠습니까?")
t("There is already a character with this name, do you want to overwrite it?", "이미 존재하는 캐릭터 명입니다만, 덮어씌우시겠습니까?")
t("Yes", "네")
t("No", "아니요")
t("Cancel", "취소")
t("Name", "이름")


------------------------------------------------
section "game/modules/tome/dialogs/CharacterSheet.lua"

t("Name", "이름")
t("Female", "여성")
t("Male", "남성")
t("Passive", "지속형")
t("Sustained", "유지형")
t("Activated", "사용형")
t("File: %s", "파일: %s")


------------------------------------------------
section "game/modules/tome/dialogs/CursedAuraSelect.lua"



------------------------------------------------
section "game/modules/tome/dialogs/DeathDialog.lua"

t("Message Log", "메시지 로그")


------------------------------------------------
section "game/modules/tome/dialogs/Donation.lua"

t("Cancel", "취소")


------------------------------------------------
section "game/modules/tome/dialogs/GameOptions.lua"

t("Game Options", "게임 설정")
t("no", "아니요")


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
t("Cunning", "교활")
t("Dexterity", "민첩")
t("Magic", "마법")
t("Strength", "힘")
t("Willpower", "의지")


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

t("Passive", "지속형")


------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceActor.lua"

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

t("Tales of Maj'Eyal: Age of Ascendancy", "마즈'에이알의 이야기 : 주도의 시대")
t([[Welcome to Maj'Eyal.

This is the Age of Ascendancy. After over ten thousand years of strife, pain and chaos the known world is at last at relative peace.
The last effects of the #FF0000#Spellblaze#WHITE# have been tamed. The land slowly heals itself and the civilisations rebuild themselves after the Age of Pyre.

It has been one hundred and twenty-two years since the Allied Kingdoms were established under the rule of #14fffc#Toknor#ffffff# and his wife #14fffc#Mirvenia#ffffff#.
Together they ruled the kingdoms with fairness and brought prosperity to both Halflings and Humans.
The King died of old age fourteen years ago, and his son #14fffc#Tolak#ffffff# is now King.

The Elven kingdoms are quiet. The Shaloren Elves in their home of Elvala are trying to make the world forget about their role in the Spellblaze and are living happy lives under the leadership of #14fffc#Aranion Gayaeil#ffffff#.
The Thaloren Elves keep to their ancient tradition of living in the woods, ruled as always by #14fffc#Nessilla Tantaelen#ffffff# the wise.

The Dwarves of the Iron Throne have maintained a careful trade relationship with the Allied Kingdoms for nearly one hundred years, yet not much is known about them, not even their leader's name.

While the people of Maj'Eyal know that the mages helped put an end to the terrors of the Spellblaze, they also did not forget that it was magic that started those events. As such, mages are still shunned from society, if not outright hunted down.
Still, this is a golden age. Civilisations are healing the wounds of thousands of years of conflict, and the Humans and the Halflings have made a lasting peace.

You are an adventurer, set out to discover wonders, explore old places, and venture into the unknown for wealth and glory.
]], [[마즈'에이알에 온 것을 환영합니다.

지금은 주도의 시대입니다. 천년이 넘는 투쟁 끝에 고통과 혼란으로 어지럽던 세상은 마침내 안정을 찾았습니다.
#FF0000#마법폭발#WHITE#의 잔향은 끝내 사그라들었습니다. 장작더미의 시대가 끝나고 대지는 회복되기 시작했고, 문명들은 다시 일어나기 시작했습니다.

#14fffc#Toknor#ffffff#과 그의 아내 #14fffc#Mirvenia#ffffff#의 지배 아래 연합왕국이 세워진 지 백년하고도 22년이 지났습니다..
그들은 함께 공정함으로 왕국을 다스렸고, 하플링과 인간에게 번영을 가져왔습니다.
14년 전 왕이 노환으로 죽고, 이제 그의 아들 #14fffc#Tolak#ffffff#이 왕이 되었습니다.

엘프들의 왕국은 고요합니다. 샬로레들은 엘발라의 집에서 살며 세상이 주문폭발이 일어난 것에 샬로레들이 일조한 것을 잊도록 힘쓰고 있습니다. #14fffc#Aranion Gayaeil#ffffff#의 지도아래 그들은 행복하게 살고 있습니다.
탈로레들은 숲속에서 사는 전통을 지키려고 하고 있습니다. 언제나처럼 현자 #14fffc#Nessilla Tantaelen#ffffff#가 그들을 다스리고 있습니다.

철의 왕좌의 난쟁이들은 백년가까이 왕국연합과 조심스럽게 무역을 하고 있습니다. 이들에 대해서는 알려진 것이 별로 없습니다. 지도자의 이름조차 알려지지 않았습니다.

마즈'에이알의 주민들은 마법사들이 마법폭발의 공포를 끝내도록 도와준 것을 알지만, 이런 끔찍한 사건들이 일어난 것도 마법 때문임을 잊지 않았습니다. 마법사들은 사냥당하지는 않지만 사회로부터 기피당합니다.
그래도 지금은 황금기입니다. 문명들은 수천년의 걸친 분쟁의 상처를 회복하고 있습니다. 인간과 하플링들은 평화를 유지하고 있습니다.

당신은 모험가입니다. 경이를 찾고, 폐허를 탐색하며 부와 명예를 위해 미지의 땅으로 나아가십시오.
]])
t("Though magic is still shunned in Maj'Eyal, rumours abound of secret havens of mages.", "마즈'에이알에서 마법은 여전히 배척받고 있지만, 어딘가에 숨겨진 마법의 천국이 존재한다는 소문이 나돌고 있습니다.")
t("The Rush talent lets you close in on an enemy quickly and daze them, disabling them whilst you hack down their friends.", "질주 능력은 적에게 빠르게 접근하여 적을 멍하게 만듭니다. 적은 그들의 친구가 쓰러지는 동안 내내 무력화 될 것입니다.")
t("Stunning an opponent slows down their movement and reduces their damage output, giving you the opportunity to tactically reposition or finish them off at less risk.", "적을 기절시켜서 느려지게 만들거나 적이 가하는 피해를 줄일 수 있습니다. 그 동안 적을 끝장내거나, 좋은 위치를 잡아 우위를 만드십시오.")
t("Movement is key on the battlefield. A stationary fighter will become a dead fighter. One must always seek the position of greatest tactical advantage and continue to re-evaluate throughout the battle.", "전장에서 계속 움직이는 것은 아주 중요합니다. 가만히 있는 투사는 곧 시체가 될 것입니다. 전투중에 계속 전략적 우위를 점하기 위해 자리를 이동하고, 자신의 자리를 재고하는 것을 멈추지 마십시오.")
t("In the Age of Pyre the orcs learned the secrets of magic, and with their newfound powers nearly overcame the whole of Maj'Eyal.", "장작더미의 시대에 오크들은 마법의 비밀을 배웠습니다. 새로이 얻은 힘으로 마즈'에이알 전체를 위협하고 있습니다.")
t("The orcs once terrorised the whole continent. In the Age of Ascendancy they were rendered extinct, but rumours abound of hidden groups biding their time to return.", "한 때 전 대륙을 공포에 떨게 했던 오크들은, 주도의 시대에는 멸망한 것으로 여겨집니다. 하지만 어딘가에 숨어 살아있으며, 힘을 키우며 때를 기다리고 있다는 불길한 소문이 들려옵니다.")
t("Intense willpower lets wyrmics take on the natural powers of dragons.", "강력한 의지는 용인들이 용의 힘을 얻게 해줍니다.")
t("Alchemists can transmute gems to create fiery explosions, and are known to travel with a sturdy golem for extra protection.", "연금술사들은 보석을 변환시켜 폭발물을 만들 수 있습니다. 이들은 자신의 호위를 위해 강인한 골렘을 데리고 여행합니다.")
t("In the Age of Pyre the giant golem Atamathon was built with the sole purpose of stopping the orcish leader Garkul the Devourer. The golem was single-handedly destroyed by the orc, who then slaughtered an army of thousands before the demonic fighter was finally slain.", "장작더미의 시대에 거대한 골렘인 Atamathon은 오크의 지도자인 포식자 Garkul를 막기 위해 만들어 졌습니다. 이 골렘은 이 강력한 오크에 의해 바로 파괴되었고, 포식자 Garkul은 쓰러지기 전까지 수천의 군대를 학살했습니다.")
t("None know what the Sher'Tul looked like, or what caused them all to disappear thousands of years ago. Their rare ruins are a source of mystery and terror.", "누구도 쉐르'툴이 어떻게 생겼는지, 무엇이 수천년전에 이들을 사라지게 만들었는지 모릅니다. 하지만 그 폐허는 여전히 남아서 공포와 의문을 불러일으킵니다.")
t("In deep places dark things dwell beyond description or understanding. None know the source of these hideous horrors.", "깊은 곳에서 이해의 영역을 넘은 어두운 존재가 살고 있습니다. 누구도 이 끔찍한 괴물이 어디서 왔는지 알지 못합니다.")
t("Who knows what dark thoughts drive people to necromancy? Its art is as old as magic itself, and its creations have plagued all the races since the earliest memories.", "어떤 어두운 생각이 사람이 사령술을 연구하게 할까요? 이 기술은 마법 자체만큼 오래되었고, 태초부터 모든 종족을 오염시켜왔습니다.")
t("Some say that in their early days the Shaloren kings experimented with necromancy to preserve their flesh after death, but with little success. The Shaloren vehemently deny this.", "어떤 사람들은 샬로른 왕들이 죽음 이후에도 육체를 보존하기 위해 오래전부터 사령술을 실험해 왔다고 말합니다. 그들은 거의 성공하지 못했고, 샬로레들은 이런 소문을 단호히 부정합니다.")
t("120 years ago Toknor and Mirvenia united the human and halfling kingdoms and wiped out the orcish race, thus establishing the Age of Ascendancy.", "120년 전 Toknor와 Mirvenia가 인간과 하플링 왕국들은 연합시키고, 오크들을 쓸어버림으로서 주도의 시대를 열었습니다.")
t("\"The Spellblaze tore Eyal apart and nearly brought about the end of all civilisation. Two thousand years on its shadow still hangs over many lands, and the prideful mages have never been forgiven their place in bringing it about.", "\"마법 폭발은 아이알을 찢어 놓았고, 문명들을 모두 끝장낼뻔 했습니다. 2000년이 지난 후에도 아직도 많은 땅에 그 영향은 남아있습니다. 그러나 오만스러운 마법사들은 그런 재앙을 불러온 것을 단 한번도 사과하지 않았습니다.")
t("Some are cursed with mental powers beyond their full control, turning them to a dark life powered by hatred.", "통제할 수 없는 강력한 정신력을 가진 이들은 증오를 받으며 어두운 삶을 살아가게 됩니다.")
t("Dreadfell has always been shunned for its haunted crypts, but of late rumours tell of a darker and more terrible power in residence.", "유령들린 묘지인 두려움의 영역은 언제까지나 무서워하며 피해가는 장소일 것입니다. 그곳에는 어둡고 끔찍한 무엇인가가 살고 있다는 소문들이 많습니다.")
t("Some Sher'Tul artifacts can still be found in hidden places, but it is said they are not to be trifled with.", "몇 개의 쉐르'툴 아티팩트를 숨겨진 장소에서 찾을 수 있습니다. 만일 이것들과 마주친다면 하찮게 여기지 마십시오.")
t("Drakes and wyrms are the strongest natural creatures in the world, capable of powers far beyond most other beings.", "용과 드레이크는 가장 강력한 자연 생물입니다. 이들의 힘은 다른 존재들을 아득히 능가합니다.")
t("Giant worms tear open huge passageways through the deserts in the west. It is said great riches lie buried beneath the sand, still decorating the corpses of those who went there seeking great riches.", "서쪽에 사막을 거대한 벌레는 거대한 통로를 열어재끼며 돌아다닙니다. 모래 밑에 막대한 보물이 있다는 소문을 찾아 온 자들의 시체들은 사막을 수놓고 있습니다.")
t("Arcane Blades employ a fusion of melee and magical combat. Their training is harsh but the most dedicated rise to great powers.", "마법검사는 근접 전투술과 함께 마법을 이용하여 싸웁니다. 이들을 훈련하는 과정은 가혹하지만, 끝까지 견뎌낸다면 강대한 힘을 얻게 될 것입니다.")
t("Wild infusions call upon the powers of nature to protect the flesh and rid oneself of afflictions.", "자연 주입물을 사용하여 자연희 힘을 불러내어 육체를 보호하고, 질병을 제거할 수 있습니다.	")
t("Shield runes act instantly, letting one protect oneself quickly whilst also preparing to flee or launch a counter attack.", "방패 룬은 즉시 발동합니다. 발동하면 즉시 시전자에게 보호막을 제공하여 도망치거나 반격을 날릴 시간을 벌어줍니다.")
t("Greater training in the use of armour lets it be used more effectively, blocking more damage and reducing the chance of an enemy hitting a critical spot.", "갑옷술을 더욱 연마하면 갑옷을 더욱 효과적으로 사용할 수 있게 됩니다. 더 많은 피해를 막아내고, 적이 급소를 공격할 확률을 줄여줍니다.")
t("The Thick Skin talent reduces all incoming damage, letting you survive for longer before needing to heal.", "두거운 피부 기술은 모든 종류의 자신이 입는 피해를 줄여줍니다. 치유할 때까지 오래 생존할 수 있도록 도와줍니다.")
t("Regeneration infusions act over several turns, letting you anticipate damage that will be taken and prepare for it.", "재생 주입물은 여러 턴에 걸쳐 작용합니다. 어느 정도의 피해가 들어올지 예상하여 대응할 수 있습니다.")
t("In the most dire circumstances teleportation can be the best escape, but is not without risk.", "모든 상황에서 순간이동은 최고의 회피기입니다. 물론 위험할 가능성이 없다는 것은 아닙니다.")
t("The Ziguranth are an ancient order vehemently opposed to magic. Some have become so attuned to nature they can resist arcane forces with their will alone.", "지구르 추종자들은 고대의 조직으로 과격하게 마법과 싸웁니다. 일부는 스스로의 의지만으로 아케인 힘에 저항할 수 있을 정도로 자연과 가깝습니다.")
t("Records say that giants once lived civilised lives, with mastery of many crafts and sciences. Now, though, they have adopted nomadic cultures, turning hostile against those that encroach on their lands.", "기록에서는 거인들은 한때 문명화된 생활상을 가졌다고 합니다. 그들은 과학과 공예를 다룰 줄 알았습니다. 하지만 지금은 유목 생활을 하며 앞길에 있는 자들에게 공격적으로 대합니다.")
t("Zigur was founded by escapees of Conclave experiments during the Allure wars between humans and halflings.", "인간과 하플링 사이에 일어난 매혹의 전투의 Conclave 실험 생존자들이 지구르를 세웠습니다.")
t("The Thaloren and Shaloren elves have never had good relations, and have been outright hostile since the Spellblaze devastated many Thaloren lands.", "탈로레와 샬로레들은 좋은 관계였던 적이 없습니다. 마법폭발이 탈로레들의 땅들을 파괴한 후로는 오히려 서로 적대적입니다.")
t("The third elven race, the Naloren, were rendered extinct after a huge cataclysm swept the eastern side of Maj'Eyal into the sea.", "세번째 엘프 종족인 날로레는 마즈'에이알의 동쪽이 바다에 잠기는 재앙이후로 멸절한 것으로 여겨집니다.")
t("Trolls were once seen as little more than beasts or pests, but the orcs trained them up for use in war and they became much more intelligent and fearsome.", "트롤들은 짐승이나 해충과 다를바 없다고 여겨졌었지만, 오크들이 전쟁에 쓰기 위해 훈련시킨 후로는 지능적이고 무서운 괴물이 되었습니다.")
t("The Nargol empire was once the largest force in Maj'Eyal, but a combination of the Spellblaze and orcish attacks have dwindled it into insignificance.", "나르골 제국은 한때 마즈'에이알의 가장 강력한 세력이었습니다. 마법폭발이 쓸고가고 오크들의 공격이 더해진 끝에 이제 그들은 하찮은 세력입니다.")
t("Some of the most powerful undead do not fall easily, and only through extreme persistence can they be put to rest.", "가장 강력한 언데드들은 쉽게 쓰러지지 않습니다. 오직 강력한 인내만이 그들을 잠재울 수 있습니다.")
t("History says little of the ancient race of yeeks that lived in halfling territory, but vanished before the time of the Spellblaze.", "역사에 따르면, 마법폭발이 있기 전 고대종족인 이크들이 하플링의 영역에서 갑자기 사라지기 전까지 살았다고 합니다.")
t("Dwarves are naturally a inquisitive people, but do not enjoy such inquisition turned on them. Most live secretive lives in their closed-off city, the Iron Throne.", "드워프들은 본래 아주 호기심많은 사람들입니다. 호기심이 자기자신들을 향할 때는 싫어하기 때문에 그들 대부분은 철의 왕좌에서 숨어 삽니다.")
t("Alchemists can bind gems to armour to grant them magical effects, to protect the wearer or improve their powers. Some commercial alchemists can imbue gems into jewellery.", "연금술사들은 갑옷에 보석을 박아 마법 효과를 부여할 수 있습니다. 이를테면 착용자를 보호하거나 갑옷의 능력을 향상시킬 수 있습니다. 몇몇의 상업적인 연금술사들은 보석을 장신구로 바꾸기도 합니다.")
t("The Spellblaze was followed by the Age of Dusk, when disease was rife and civilisation collapsed. Necromancers and fell sorcerers took advantage of the chaos to spread their vile deeds.", "황혼의 시대 직후에 마법 폭발이 일어났습니다. 그 결과 질병이 창궐하고, 문명은 붕괴되었습니다. 사령술사들과 사악한 주술사들은 그들의 악한 목적을 이루기 위해 혼란스러운 세상을 이용했습니다.")
t("After the Spellblaze came the Spellhunt, when the normal people rose against the arrogance of the mages and hunted them down like wolves. Some survived and went into hiding, but many innocents were killed.", "마법 폭발 후에는 마법 사냥이 있었습니다. 평범한 사람들이 마법사의 오만함에 반기를 들고, 늑대떼마냥 그들을 사냥했습니다. 일부는 살아서 은신처로 숨었지만, 많은 무고한 사람들이 살해당했습니다.")
t("Demons are thought to come from another world, brought to Eyal by magical forces. Some are highly intelligent and follow their own ambitions. To what end, none know.", "악마들은 다른 세상에서 마법으로 인해 에이알로 불려졌다고 여겨집니다. 일부는 매우 지능적이고, 자신만의 야망을 가지고 있는 경우도 있습니다. 어떻든간에 진실은 누구도 모릅니다.")
t("The art of potion making fell into decline after the Spellhunt, and only a rare few now master the gift.", "물약을 만드는 기술은 마법사냥이래로 쇠퇴해 왔습니다. 이제는 소수의 사람만이 이 기술을 습득하고 있습니다.")
t("It's said that some rare powers can save your soul from the edge of death.", "죽음의 문턱에서도 당신을 구해줄 수 있는 휘귀한 어떤 힘이 존재한다고 합니다.")
t("Rumours tell of a shadowy cult kidnapping women and performing strange rites. Their intentions are unknown, and they have so far evaded capture.", "비밀스러운 종교집단이 여자들을 납치하고 이상한 의식을 치룬다는 소문이 있습니다. 이런 짓을 하는 이유는 불명입니다. 이들은 아직까지도 잡히지 않았습니다.")
t("Though slavery is illegal there is still a black market for it, and in some areas men are even used for blood sports.", "노예를 부리는 것은 불법이지만, 암시장이 어딘가에 있다고 합니다. 어떤 곳에서는 피튀기는 스포츠를 위해 사람이 동원된다고 합니다.")
t("Maj'Eyal is the biggest continent in the world of Eyal. Though records suggest other continents and islands may exist it has not been possible to cross the wide and stormy oceans since the Spellblaze and the Cataclysm.", "마즈'에이알은 에이알의 세계에서 가장 큰 대륙입니다. 기록에 따르면 다른 대륙과 섬들이 있지만, 대재앙과 마법폭발이후로 드넓은 대양을 건너는 것은 불가능합니다.")
t("The effects of the Spellblaze were not all instant, and many centuries later the Cataclysm tore the continent apart once more, devastating coastal areas the destroying all of the Naloren lands.", "마법 폭발의 영향은 여파가 계속 남았습니다. 그리고 수세기 후 대재앙이 대륙을 찢어놓아 해안에 있던 날로레의 땅들이 사라졌습니다.")
t("Archers are fast and deadly, and with pinning shots can render their foes helpless as they swiftly dispatch them.", "궁수는 빠르고 치명적입니다. 화살을 꽂아넣어 적들이 접근하기도 전에 무력화시킬 수 있습니다.")
t("Reavers are powerful fighters with corrupted blood, and the strength to wield a one-handed weapon in each arm.", "타락한 피를 가진 파괴자들은 강력한 투사입니다. 양 팔에 하나씩 한손무기를 장비할 수 있습니다.")
t("Corruptors feed off the essence of others, and can use their own corrupted blood to launch deadly magical attacks.", "타락자들은 다른 생명의 정수를 포식합니다. 타락한 피를 이용하여 치명적인 마법 공격을 할 수 있습니다.")
t("Clever rogues can lay traps to damage or debilitate their foes without having to go near them.", "영리한 도적은 덫을 놓아 적과 근접하지 않은 상태에서 피해를 주고 무력화시킬 수 있습니다.")
t("Rogues can move silently and stealthily, letting them approach foes unaware or avoid them entirely.", "도적들은 조용하고 은밀하게 움직입니다. 적이 눈치채기 전에 접근하거나, 완전히 적을 무시하고 지나갈 수 있습니다.")
t("A movement infusion can let you quickly approach a ranged opponent, or quickly escape a melee one.", "이동 주입물은 원거리 적에 빠르게 접근하거나, 근접 적에게서 빠르게 도망치게 해줍니다.")
t("Invisibility lets you escape notice, giving you the freedom to move or recover your resources, but reduces your damage.", "투명화는 적들의 주의에서 도망치게 해주고, 자유롭게 움직일 수 있게 하며 자원을 회복할 시간을 벌어줍니다. 하지만 가하는 피해가 감소합니다.")
t("Poison is the domain of assassins and master rogues, and its cunning use can cripple or kill enemies over a long fight.", "독은 암살자들과 도적의 대가들의 영역입니다. 적을 불구로 만들거나 오랜 시간에 걸쳐 적을 죽일 수 있습니다.")
t("Summoners can call upon a variety of natural creatures to protect and support them, reducing the risk to their own flesh considerably.", "소환술사들은 다양한 자연의 괴물들을 불러일으켜 자신을 보호하거나 돕게 합니다. 이런 소환물들은 소환술사가 다칠 위험을 줄여줍니다.")
t("The highest sorcerers are known as archmages, and the masters amongst them are said to have the power to change the world. They are feared immensely.", "고위 주술사들은 마도사라고 불리웁니다. 마도사들 중의 대가들은 세상을 바꿀 힘을 가지고 있습니다. 그러기에 그들은 공포의 대상입니다.")
t("Bulwarks are defensive fighters that can take hits more readily than other warriors whilst preparing for the most effective counter attacks.", "기사들은 방어적인 투사들로서 더 많은 피해를 안정적으로 받을 수 있고, 얻어맞는 동안 치명적인 반격을 준비합니다.")
t("Brawlers are trained in the use of their fists and mastery of their bodies. They can be as dangerous in combat as any swordsman.", "격투가들은 구덩이에서 죽기전까지 굴렀고, 이제는 육체의 대가가 되었습니다. 전투에서는 칼을 든 검사들과 다를바 없이 위협적입니다.")
t("Lightning is a chaotic element that is hard to control. It is said that those most attuned to it are eventually driven insane.", "번개는 변덕스러운 원소로 다루기 어렵습니다. 광기에 의해 가장 잘 다루어진다고 일컬어집니다.")


------------------------------------------------
section "game/modules/tome/load.lua"

t("In main hand", "주무기")
t("Most weapons are wielded in the main hand.", "대부분의 무기들은 주무기로 장비합니다.")
t("In off hand", "보조무기")
t("You can use shields or a second weapon in your off-hand, if you have the talents for it.", "방패나 두번째 무기를 그에 맞는 기술이 있다면 보조무기로 장비할 수 있습니다.")
t("Object held in your telekinetic grasp. It can be a weapon or some other item to provide a benefit to your psionic powers.", "염동력 손아귀에 물건을 쥘 수 있습니다. 무기나 다른 물건을 쥐어서 염동력을 강화할 수 있습니다.")
t("Psionic focus", "염동력 집중")
t("On fingers", "손가락")
t("Rings are worn on fingers.", "반지는 손가락에 장비합니다..")
t("Amulets are worn around the neck.", "목걸이는 목에 장비합니다.")
t("Around neck", "목")
t("A light source allows you to see in the dark places of the world.", "광원 장비는 어둠 속에서 볼 수 있게 도와줍니다.")
t("Light source", "광원 장비")
t("Armor protects you from physical attacks. The heavier the armor the more it hinders the use of talents and spells.", "갑옷은 당신을 물리 공격으로부터 보호해 줍니다. 갑옷이 무거울 수록 기술과 주문 사용을 제약합니다.")
t("Main armor", "주갑옷")
t("A cloak can simply keep you warm or grant you wondrous powers should you find a magical one.", "망토는 그저 몸을 따뜻히 해주지만, 마법이 부여된 것을 찾으면 당신에게 놀라운 능력을 줄 수 있다.")
t("Cloak", "망토")
t("On head", "머리")
t("You can wear helmets or crowns on your head.", "투구와 관을 머리에 장비할 수 있습니다.")
t("Around waist", "허리")
t("Belts are worn around your waist.", "벨트는 허리에 장비합니다.")
t("On hands", "손")
t("Various gloves can be worn on your hands.", "장갑을 손에 장비할 수 있습니다.")
t("On feet", "발")
t("Sandals or boots can be worn on your feet.", "신발을 발에 장비할 수 있습니다.")
t("This is your readied tool, always available immediately.", "이것은 준비된 도구입니다. 언제라도 즉시 사용할 수 있습니다.")
t("Tool", "도구")
t("Quiver", "전통")
t("Your readied ammo.", "준비된 탄약.")
t("Gems worn in/on the body, providing their worn bonuses.", "보석을 몸에 장비하면, 명시된 효과를 얻습니다.")
t("Socketed Gems", "소켓에 박힌 보석")
t("Second weapon set: In main hand", "두 번째 무기 세트: 주무기칸")
t("Weapon Set 2: Most weapons are wielded in the main hand. Press 'x' to switch weapon sets.", "무기 세트 2 : 대부분의 무기는 주무기로 장비합니다. 'x'를 눌러 무기 세트를 바꾸십시오.")
t("Second weapon set: In off hand", "두 번째 무기 세트: 보조무기칸")
t("Weapon Set 2: You can use shields or a second weapon in your off-hand, if you have the talents for it. Press 'x' to switch weapon sets.", "무기 세트 2: 맞는 기술을 가지고 있다면 방패나 두 번째 무기를 보조무기로 착용할 수 있습니다. 'x'를 눌러 무기 세트를 바꾸십시오.")
t("Weapon Set 2: Object held in your telekinetic grasp. It can be a weapon or some other item to provide a benefit to your psionic powers. Press 'x' to switch weapon sets.", "무기 세트 2: 염동력 손아귀에 쥔 물체입니다. 무기나 다른 아이템을 쥐어서 염동력을 향상시킬 수 있습니다.'x'를 눌러 무기 세트를 바꾸십시오.")
t("Second weapon set: Quiver", "두 번째 무기 : 전통")
t("Weapon Set 2: Your readied ammo.", "무기 세트 2: 준비된 탄약.")
t("Strength", "힘")
t("Strength defines your character's ability to apply physical force. It increases your melee damage, damage done with heavy weapons, your chance to resist physical effects, and carrying capacity.", "힘은 물리적 힘을 행사하는 능력을 결정합니다. 근접 피해와 무거운 무기로 입히는 피해를 증가시킵니다. 물리 상태 효과에 저항할 확률과 당신이 지닐 수 있는 무게를 증가시킵니다.")
t("Dexterity", "민첩")
t("Dexterity defines your character's ability to be agile and alert. It increases your chance to hit, your ability to avoid attacks, and your damage with light or ranged weapons.", "민첩은 기민하고 경계하는 능력을 결정합니다. 적중 확률을 증가시키고, 공격을 피하는 능력을 향상시킵니다. 가벼운 무기와 원거리 무기로 가하는 피해를 증가시킵니다.")
t("Magic", "마법")
t("Magic defines your character's ability to manipulate the magical energy of the world. It increases your spell power, and the effect of spells and other magic items.", "마법은 마법 에너지를 다루는 능력을 결정합니다. 주문력과 주문 상태 효과를 입힐 확률을 증가시키고, 마법 아이템들을 다루는 능력을 향상시킵니다.")
t("Willpower", "의지")
t("Willpower defines your character's ability to concentrate. It increases your mana, stamina and PSI capacity, and your chance to resist mental attacks.", "의지는 집중할 수 있는 능력을 결정합니다. 마나와 체력, PSI capacity를 증가시킵니다. 정신 공격에 저항할 확률을 증가시킵니다.")
t("Cunning", "교활")
t("Cunning defines your character's ability to learn, think, and react. It allows you to learn many worldly abilities, and increases your mental capabilities and chance of critical hits.", "교활은 배우고, 생각하여, 반응하는 능력을 결정합니다. 다양하고 광범위한 능력을 배우게 도와주고, 정신적 가능성과 치명타 확률을 증가시킵니다.")
t("Constitution", "체격")
t("Constitution defines your character's ability to withstand and resist damage. It increases your maximum life and physical resistance.", "체격은 피해를 견디고 저항해내는 능력을 결정합니다. 최대 생명력과 물리 저항을 증가시킵니다.")
t("Luck", "행운")
t("Luck defines your character's fortune when dealing with unknown events. It increases your critical strike chance, your chance of random encounters, ...", "행운은 미지의 사건에 대처하는 능력을 결정합니다. 치명타 확률과 랜덤 인카운터 확률을 증가시킵니다.")
t("All kinds of weapons", "모든 무기")
t("All kinds of armours", "모든 갑옷")
t("Rings and Amulets", "반지와 목걸이")
t("Gems", "보석")
t("Infusions, Runes, ...", "주입물, 룬, ...")
t("Tinkers", "발명가")
t("Miscellaneous", "기타")
t("Quest and plot related items", "퀘스트와 이야기 진행에 관련된 아이템")
t("Transmogrification Chest", "변환 상자")


