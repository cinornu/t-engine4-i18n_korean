locale "ko_KR"

------------------------------------------------
section "game/addons/tome-possessors/data/achievements/possessors.lua"

t("Bill Kill!", "빌 킬!", "achievement name")
t("Kill your own Doomed Shade in the body of Bill.", "빌의 육체로 자신의 그림자를 처치.", "_t")
t("Unneshasshhary Kryl'ty", "피료엄는 키릴'티", "achievement name")
t("Kill Kryl'Feijan with the body of Shasshhiy'Kaish, or vice-versa.", "샤쉬이'카이쉬의 육체로 키릴'페이얀을 처치. (반대의 경우도 가능)", "_t")
t("Unneshasshhary Kryl'ty (Redux)", "(돌아온) 피료엄는 키릴'티", "achievement name")
t("Kill High Paladin Aeryn with the body of Sun Paladin John.", "태양의 기사 존의 육체로 고위 성기사 아에린을 처치.", "_t")


------------------------------------------------
section "game/addons/tome-possessors/data/birth/psionic.lua"

t("Possessor", "빙의술사", "birth descriptor name")
t("#CRIMSON#BEWARE: This class is very #{italic}#strange#{normal}# and may be confusing to play for beginners.#LAST#", "#CRIMSON#경고: 이 직업은 굉장히 #{italic}#기괴하기에#{normal}# 초보자가 플레이하기엔 굉장히 어렵습니다.#LAST#", "_t")
t("Possessors are a rare breed of psionics. Some call them body snatchers. Some call them nightmarish.", "빙의술사는 매우 희귀한 초능력자입니다. 그들은 육체 강탈자 혹은 악몽같은 존재라고 불리기도 합니다.", "_t")
t("They are adept at stealing their foes corpses for their own use. Discarding their own bodies for a while to use other's.", "그들은 적의 시체를 훔쳐내는 달인이며, 자신의 목적을 달성하기 위해 그것들을 이용합니다. 또한 자신의 몸을 떠나 다른 육체를 사용하기도 합니다.", "_t")
t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.", "_t")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:", "_t")
t("#LIGHT_BLUE# * +2 Strength, +2 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +2 힘, +2 민첩, +0 체격", "_t")
t("#LIGHT_BLUE# * +0 Magic, +3 Willpower, +2 Cunning", "#LIGHT_BLUE# * +0 마법, +3 의지, +2 교활", "_t")
t("#GOLD#Life per level:#LIGHT_BLUE# -4", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# -4", "_t")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/battle-psionics.lua"

t("You are disarmed.", "당신의 무장은 해제됐다.", "logPlayer")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/body-snatcher.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/deep-horror.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/possession.lua"

t("none", "없음", "_t")
t("No", "아니요", "_t")
t("Yes", "네", "_t")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic-menace.lua"

t("You are disarmed.", "당신의 무장은 해제됐다.", "logPlayer")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic.lua"

t("psionic", "초능력", "talent category")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psychic-blows.lua"

t("You are disarmed.", "당신의 무장은 해제됐다.", "logPlayer")
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.", "logPlayer")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/ravenous-mind.lua"



------------------------------------------------
section "game/addons/tome-possessors/data/timed_effects.lua"

t("Kryl-Feijan", "키릴-페이얀", "_t")
t("Shasshhiy'Kaish", "샤쉬'카이쉬", "_t")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린", "_t")
t("#Target# is stunned!", "#Target1# 기절했다!", "_t")
t("+Stunned", "+기절", "_t")
t("#Target# is not stunned anymore.", "#Target1# 제정신을 되찾았다.", "_t")
t("-Stunned", "-기절", "_t")
t("mind", "정신", "effect subtype")
t("The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze.", "혼절 / 이동 불가 / 가하는 피해량, 회피도, 모든 내성, 정확도, 주문력, 정신력, 물리력 -50%% / 피해를 받을 시 혼절이 해제됨.", "_t")
t("stun", "기절", "effect subtype")
t("#Target# is dazed!", "#Target1# 혼절 중이다!", "_t")
t("+Dazed", "+혼절", "_t")
t("#Target# is not dazed anymore.", "#Target1# 더 이상 혼절 상태가 아니다.", "_t")
t("-Dazed", "-혼절", "_t")
t("damage", "피해", "effect subtype")
t("psionic", "초능력", "effect subtype")


------------------------------------------------
section "game/addons/tome-possessors/init.lua"



------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeForm.lua"

t("Summon", "소환", "_t")
t("All", "모든", "_t")
t("Cancel", "취소", "_t")
t("Destroy", "파괴", "_t")
t("#FFD700#Accuracy#FFFFFF#: ", "#FFD700#정확도#FFFFFF#: ", "_t")
t("#0080FF#Defense#FFFFFF#:  ", "#0080FF#회피도#FFFFFF#:  ", "_t")
t("#FFD700#P. power#FFFFFF#: ", "#FFD700#물리력#FFFFFF#: ", "_t")
t("#0080FF#P. save#FFFFFF#:  ", "#0080FF#물리 내성#FFFFFF#:  ", "_t")
t("#FFD700#S. power#FFFFFF#: ", "#FFD700#주문력#FFFFFF#: ", "_t")
t("#0080FF#S. save#FFFFFF#:  ", "#0080FF#주문 내성#FFFFFF#:  ", "_t")
t("#FFD700#M. power#FFFFFF#: ", "#FFD700#정신력#FFFFFF#: ", "_t")
t("#0080FF#M. save#FFFFFF#:  ", "#0080FF#정신 내성#FFFFFF#:  ", "_t")
t("Resists: ", "저항: ", "_t")
t("Hardiness/Armour: ", "방어 효율 / 방어력: ", "_t")
t("Size: ", "몸집 크기: ", "_t")
t("Critical Mult: ", "치명타 피해량 증가: ", "_t")
t("Melee Retaliation: ", "근접 공격 보복: ", "_t")


------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeFormSelectTalents.lua"

t("Cancel", "취소", "_t")


