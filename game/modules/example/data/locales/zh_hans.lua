locale "zh_hans"
------------------------------------------------
section "mod-example/class/Actor.lua"

t("%s uses %s.", "%s使用了%s。", "logSeen")
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

t("There is no way out of this level here.", "这里不是离开该层的出口。", "log")
t("Saving game...", "保存游戏...", "log")
-- untranslated text
--[==[
t("NB: %d", "NB: %d", "log")
--]==]


------------------------------------------------
section "mod-example/class/Player.lua"

t("taken damage", "受到伤害", "_t")
t("LOW HEALTH!", "生命值低!", "_t")
t("#00ff00#Talent %s is ready to use.", "#00ff00#技能%s已经可以使用了。", "log")
t("LEVEL UP!", "升级了！", "_t")
-- untranslated text
--[==[
t("#00ffff#Welcome to level %d.", "#00ffff#Welcome to level %d.", "log")
--]==]


------------------------------------------------
section "mod-example/data/birth/descriptors.lua"

t("base", "基础", "birth descriptor name")
t("Destroyer", "毁灭者", "birth descriptor name")
t("Acid-maniac", "狂酸使", "birth descriptor name")

------------------------------------------------
section "mod-example/data/damage_types.lua"

t("Kill!", "击杀!", "_t")
-- untranslated text
--[==[
t("%s hits %s for %s%0.2f %s damage#LAST#.", "%s hits %s for %s%0.2f %s damage#LAST#.", "logSeen")
--]==]


------------------------------------------------
section "mod-example/data/general/grids/basic.lua"

t("previous level", "前往上一层", "entity name")
t("next level", "前往下一层", "entity name")
t("floor", "地板", "entity name")
t("wall", "墙壁", "entity name")
t("door", "门", "entity name")
t("open door", "敞开的门", "entity name")
-- untranslated text
--[==[
t("exit to the wilds", "exit to the wilds", "entity name")
--]==]


------------------------------------------------
section "mod-example/data/general/npcs/kobold.lua"

t("humanoid", "人形生物", "entity type")
-- untranslated text
--[==[
t("kobold", "kobold", "entity subtype")
t("Ugly and green!", "Ugly and green!", "_t")
t("kobold warrior", "kobold warrior", "entity name")
t("armoured kobold warrior", "armoured kobold warrior", "entity name")
--]==]


------------------------------------------------
section "mod-example/data/talents.lua"

t("Kick", "踢", "talent name")
t("Acid Spray", "酸液喷吐", "talent name")
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

t("Strength", "力量", "stat name")
t("str", "力量", "stat short_name")
t("Dexterity", "敏捷", "stat name")
t("dex", "敏捷", "stat short_name")
t("Constitution", "体质", "stat name")
t("con", "体质", "stat short_name")

