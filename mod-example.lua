------------------------------------------------
section "mod-example/class/Actor.lua"

t("%s uses %s.", "%s %s 사용했다.", "logSeen", nil, {"는","를"})
-- untranslated text
--[==[
t("You do not have enough power to activate %s.", "You do not have enough power to activate %s.", "logPlayer")
t("You do not have enough power to cast %s.", "You do not have enough power to cast %s.", "logPlayer")
t("%s", "%s", "logSeen")
t("%s activates %s.", "%s activates %s.", "logSeen")
t("%s deactivates %s.", "%s deactivates %s.", "logSeen")
--]==]


------------------------------------------------
section "mod-example/class/Game.lua"

t("There is no way out of this level here.", "이 구역에는 출구가 없다.", "log")
t("Saving game...", "게임을 저장합니다...", "log")
-- untranslated text
--[==[
t("NB: %d", "NB: %d", "log")
--]==]


------------------------------------------------
section "mod-example/class/Player.lua"

t("taken damage", "피해를 받았다", "_t")
t("LOW HEALTH!", "생명력 낮음!", "_t")
t("#00ff00#Talent %s is ready to use.", "#00ff00#기술 %s 사용하실 수 있습니다.", "log", nil, {"을"})
t("LEVEL UP!", "레벨업!", "_t")
-- untranslated text
--[==[
t("#00ffff#Welcome to level %d.", "#00ffff#Welcome to level %d.", "log")
--]==]


------------------------------------------------
section "mod-example/data/birth/descriptors.lua"

t("base", "베이스", "birth descriptor name")
t("Destroyer", "파괴자", "birth descriptor name")
t("Acid-maniac", "애시드 매니아", "birth descriptor name")

------------------------------------------------
section "mod-example/data/damage_types.lua"

t("Kill!", "죽임!", "_t")
-- untranslated text
--[==[
t("%s hits %s for %s%0.2f %s damage#LAST#.", "%s hits %s for %s%0.2f %s damage#LAST#.", "logSeen")
--]==]


------------------------------------------------
section "mod-example/data/general/grids/basic.lua"

t("previous level", "이전 구역", "entity name")
t("next level", "다음 구역", "entity name")
t("floor", "바닥", "entity name")
t("wall", "벽", "entity name")
t("door", "문", "entity name")
t("open door", "열린 문", "entity name")
-- untranslated text
--[==[
t("exit to the wilds", "exit to the wilds", "entity name")
--]==]


------------------------------------------------
section "mod-example/data/general/npcs/kobold.lua"

t("humanoid", "인간형", "entity type")
-- untranslated text
--[==[
t("kobold", "kobold", "entity subtype")
t("Ugly and green!", "Ugly and green!", "_t")
t("kobold warrior", "kobold warrior", "entity name")
t("armoured kobold warrior", "armoured kobold warrior", "entity name")
--]==]


------------------------------------------------
section "mod-example/data/talents.lua"

t("Kick", "발차기", "talent name")
t("Acid Spray", "산성 스프레이", "talent name")
-- untranslated text
--[==[
t("role", "role", "talent category")
--]==]


------------------------------------------------
section "mod-example/data/zones/dungeon/zone.lua"


-- untranslated text
--[==[
t("Old ruins", "Old ruins", "_t")
--]==]


------------------------------------------------
section "mod-example/dialogs/DeathDialog.lua"


-- untranslated text
--[==[
t("Death!", "Death!", "_t")
t("#LIGHT_BLUE#You resurrect! CHEATER !", "#LIGHT_BLUE#You resurrect! CHEATER !", "logPlayer")
--]==]


------------------------------------------------
section "mod-example/dialogs/Quit.lua"


-- untranslated text
--[==[
t("Really exit Example Module?", "Really exit Example Module?", "_t")
--]==]


------------------------------------------------
section "mod-example/init.lua"


-- untranslated text
--[==[
t("Example Module for T-Engine4", "Example Module for T-Engine4", "init.lua long_name")
t([[This is *NOT* a game, just an example/template to make your own using the T-Engine4.
]], [[This is *NOT* a game, just an example/template to make your own using the T-Engine4.
]], "init.lua description")
--]==]


------------------------------------------------
section "mod-example/load.lua"

t("Strength", "힘", "stat name")
t("str", "힘", "stat short_name")
t("Dexterity", "민첩", "stat name")
t("dex", "민첩", "stat short_name")
t("Constitution", "체격", "stat name")
t("con", "체격", "stat short_name")

