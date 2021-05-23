------------------------------------------------
section "tome-possessors/data/achievements/possessors.lua"

t("Bill Kill!", "빌 킬!", "achievement name")
t("Kill your own Doomed Shade in the body of Bill.", "빌의 육체로 자신의 그림자를 처치했다.", "_t")
t("Unneshasshhary Kryl'ty", "피료엄는 키릴'티", "achievement name")
t("Kill Kryl'Feijan with the body of Shasshhiy'Kaish, or vice-versa.", "샤쉬'카이쉬의 육체로 키릴'페이얀을 처치했다. (반대의 경우도 가능)", "_t")
t("Unneshasshhary Kryl'ty (Redux)", "(돌아온) 피료엄는 키릴'티", "achievement name")
t("Kill High Paladin Aeryn with the body of Sun Paladin John.", "태양의 기사 존의 육체로 고위 태양의 기사 아에린을 처치했다.", "_t")

------------------------------------------------
section "tome-possessors/data/birth/psionic.lua"

t("Possessor", "빙의술사", "birth descriptor name")
t("#CRIMSON#BEWARE: This class is very #{italic}#strange#{normal}# and may be confusing to play for beginners.#LAST#", "#CRIMSON#경고: 이 직업은 굉장히 #{italic}#난해하기에#{normal}# 초보자가 플레이하기는 굉장히 어렵습니다.#LAST#", "_t")
t("Possessors are a rare breed of psionics. Some call them body snatchers. Some call them nightmarish.", "빙의술사는 매우 희귀한 초능력자입니다. 그들은 육체 강탈자라고 불리기도 하고, 악몽 같은 존재라고 불리기도 합니다.", "_t")
t("They are adept at stealing their foes corpses for their own use. Discarding their own bodies for a while to use other's.", "그들은 적의 시체를 능숙하게 훔쳐내어 목적을 달성하는 데에 이용합니다. 자신의 육체를 잠시 버리고 다른 육체를 사용하기도 합니다.", "_t")
t("Their most important stats are: Willpower and Cunning", "그들에게 가장 중요한 능력치는 의지와 교활입니다.", "_t")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:", "_t")
t("#LIGHT_BLUE# * +2 Strength, +2 Dexterity, +0 Constitution", "#LIGHT_BLUE# * +2 힘, +2 민첩, +0 체격", "_t")
t("#LIGHT_BLUE# * +0 Magic, +3 Willpower, +2 Cunning", "#LIGHT_BLUE# * +0 마법, +3 의지, +2 교활", "_t")
t("#GOLD#Life per level:#LIGHT_BLUE# -4", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# -4", "_t")

------------------------------------------------
section "tome-possessors/data/talents/psionic/battle-psionics.lua"

t("You are disarmed.", "무장을 해제했다.", "logPlayer")
t("You require a mainhand weapon and an offhand mindstar to use this talent.", "이 기술을 사용하기 위해서는 주 무기로 한 손 무기, 보조 무기로 마석을 장비해야 한다.", "logPlayer")
t("Psionic Disruption", "염동력 방해", "talent name")
t([[You imbue your offhand mindstar with wild psionic forces.
		While active you gain %d%% more of your mindstar's mindpower and mind critical chance.
		Each time you make a melee attack you also add a stack of Psionic Disruption to your target.
		Each stack lasts for %d turns and deals %0.2f mind damage over the duration (max %d stacks).
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[마석에 격렬한 초능력을 불어넣습니다.
		기술이 활성화되면 마석의 정신력과 정신 치명타 확률이 %d%% 증가합니다.
		또한, 매 근접 공격마다 대상에게 염동력 방해 효과를 1 만큼 누적시킵니다.
		공격을 가할 때마다 효과의 지속시간이 %d 턴으로 갱신되며, 매 턴 %0.2f 정신 피해를 가합니다. 최대 %d 번까지 중첩시킬 수 있습니다.
		현재 한손 무기와 마석을 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Shockstar", "충격의 별", "talent name")
t([[You make a first attack with your mainhand for %d%% weapon damage.
		If the attack hits the target is distracted and you use that to violently slam your mindstar into it, dealing %d%% damage.
		The shock is so powerful the target is stunned for %d turns and all creatures around in radius %d are dazed for the same time.
		The stun and daze duration is dependant on the number of psionic disruption charges on the target, the given number is for 4 charges.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[주무기로 대상을 타격해 %d%% 무기 피해를 입힙니다.
		기술이 명중하면 대상은 짧은 시간 동안 정신을 집중하지 못하게 되며, 시전자는 곧바로 마석을 맹렬히 내려쳐 %d%% 피해를 가합니다.
		너무나도 강력한 충격을 받아 대상은 %d 턴 동안 기절하게 되며, 반경 %d 칸 내의 모든 적 또한 같은 시간동안 혼절하게 됩니다.
		기절과 혼절의 지속시간은 대상에게 누적된 염동력 방해 효과에 비례하여 증가합니다. 이 기술의 설명은 염동력 방해 효과가 4 만큼 누적되었을 때를 기준으로 합니다.
		현재 한손 무기와 마석을 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Dazzling Lights", "눈부신 빛", "talent name")
t([[Raising your mindstar in the air you channel a bright flash of light through it. Any creatures in radius %d is blinded for %d turns.
		If any foe in melee range is blinded by the effect you quickly use that to your advantage by striking them with a blow of your main hand weapon doing %d%% damage.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[마석을 공중에 띄우고 강렬한 섬광을 마석을 통해 내보냅니다. 반경 %d 칸 내의 모든 적은 %d 턴 동안 실명합니다.
		인접한 위치에 적이 있을 경우, 실명 효과의 이점을 최대한 활용합니다. 주무기로 가격하여 적에게 %d%% 피해를 가합니다.
		현재 한손 무기와 마석을 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Psionic Block", "염동력 방어장", "talent name")
t([[You concentrate to create a psionic block field all around you for 5 turns.
		While the effect holds all damage against you have a %d%% chance to be fully ignored.
		When damage is cancelled you instinctively make a retaliation mind strike against the source, dealing %0.2f mind damage. (The retaliation may only happen 2 times per turn.)
		]], [[염동력으로 이루어진 방어장을 만드는 데에 정신을 집중합니다. 방어장은 5 턴 동안 유지됩니다.
		지속시간 동안 피격 시 받는 피해가 %d%% 확률로 완전히 무효화됩니다.
		공격이 무효화되면 시전자는 즉각 공격자에게 정신 공격으로 보복해, %0.2f 정신 피해를 줍니다 (보복 효과는 한 턴에 두 번까지만 일어납니다).
		]], "tformat")

------------------------------------------------
section "tome-possessors/data/talents/psionic/body-snatcher.lua"

t("Bodies Reserve", "육체 비축", "talent name")
t([[Your mind is so powerful it can bend reality, providing you with an extra-natural #{italic}#storage#{normal}# for bodies you snatch.
		You can store up to %d bodies.]], [[정신의 힘이 너무 강한 나머지 현실 구조를 비틀어, 시전자가 빼앗은 육체를 보관할 초자연적 #{italic}#보관소#{normal}#를 이용할 수 있게 됩니다.
		최대 %d 구의 육체를 보관할 수 있습니다.]], "tformat")
t("Psionic Minion", "초능력 하수인", "talent name")
t("Not enough space to invoke your minion!", "하수인을 소환할 공간이 부족하다!", "logPlayer")
t("%s (Psionic Minion)", "%s (초능력 하수인)", "tformat")
t([[You imbue a part of your own mind into a body without actually taking its form.
		The body will work as your minion for %d turns.
		Psionic minions can not heal in any way.
		When the effect ends the body is permanently lost.]], [[육체 하나에 정신의 일부를 주입합니다. 그 육체에 빙의하지는 않습니다.
		해당 육체는 %d 턴 동안 시전자의 하수인이 됩니다.
		초능력 하수인은 어떤 방식으로든 회복이 불가능합니다.
		효과가 끝나면 해당 육체는 영구적으로 파괴됩니다.]], "tformat")
t("Psionic Duplication", "초능력 복제", "talent name")
t([[When you store a body you also store %d more identical copies of it that you can use later.
		When you store a rare/unique/boss or higher rank creature you only get a third of the uses (but never less than one).]], [[육체를 보관할 때, 추후에 사용할 수 있는 %d 구의 복제 육체를 같이 보관합니다.
		희귀/단일/보스, 또는 더 높은 등급의 개체는 위 수치의 1/3 만큼만 복제됩니다. (최소 1 구의 복제 육체는 보장됩니다)]], "tformat")
t("Cannibalize", "육체 부품 교체", "talent name")
t("You require need to assume a form first.", "우선 형상을 취해야 한다.", "logPlayer")
t("Rank of body too low.", "육체의 등급이 너무 낮다.", "logPlayer")
t([[When you assume a form you may cannibalize a body in your reserve to replenish your current body.
		You can only use bodies that are of same or higher rank for the effect to work and each time you heal a body the effect will be reduced by 33%% for that body.
		Your current body will heal for %d%% of the max life of the cannibalized one and you will also regenerate 50%% of this value as psi.
		The healing effect is more psionic in nature than a real heal. As such may things that prevent healing will not prevent cannibalize from working.
		Cannibalize is the only possible way to heal a body.
		]], [[형상을 취하고 있을 때, 보관소 내의 육체 하나를 부품으로 사용하여 현재 육체를 수복할 수 있습니다.
		현재 육체의 등급과 동일하거나 더 높은 등급의 육체만 사용할 수 있습니다. 이 기술을 사용할 때마다 해당 육체가 받는 회복량은 33%%씩 감소하게 됩니다.
		현재 육체의 생명력이 부품이 된 육체가 가진 최대 생명력의 %d%% 만큼 회복되며, 시전자는 해당 수치의 50%% 만큼 염력을 회복합니다.
		이로 인한 회복 효과는 자연적이라기보단 초능력적인 것에 더 가깝습니다. 따라서 회복을 막는 여러 기술들을 무시합니다.
		육체 부품 교체는 육체를 수복할 수 있는 유일한 방법입니다.
		]], "tformat")

------------------------------------------------
section "tome-possessors/data/talents/psionic/deep-horror.lua"

t("Mind Steal", "정신 강탈", "talent name")
t("%s resists the mind steal!", "%s 정신 강탈에 저항했다!", "logSeen", nil, {"는"})
t("%s has no stealable talents.", "%s 빼앗을 만한 기술이 없다.", "logPlayer", nil, {"는"})
t("Mind Steal", "정신 강탈", "_t")
t("Choose a talent to steal:", "빼앗을 기술을 선택하세요:", "_t")
t([[Your mere presence is a blight in your foes minds. Using this link you are able to reach out and steal a talent from a target.
		For %d turns you will be able to use a random active (not passive, not sustained) talent from your target, and they will loose it.
		You may not steal a talent which you already know.
		The stolen talent will not use any resources to activate.
		At level 5 you are able to choose which talent to steal.
		The talent stolen will be limited to at most level %d.]], [[존재만으로도 적들의 정신을 황폐하게 합니다. 이 연결을 통해, 정신을 뻗어 대상의 기술 하나를 강탈할 수 있게 되었습니다.
		%d 턴 동안 시전자는 대상의 무작위 사용형 기술을 하나 사용할 수 있고, 대상은 그 기술을 잃어버리게 됩니다 (지속형 기술과 유지형 기술은 강탈할 수 없습니다).
		시전자가 이미 알고 있는 기술은 강탈할 수 없습니다.
		강탈한 기술은 사용할 때 어떤 원천력도 소모하지 않습니다.
		기술 레벨이 5 일 때, 강탈할 기술을 선택할 수 있게 됩니다.
		강탈한 기술의 기술 레벨은 최대 %d 으로 제한됩니다.]], "tformat")
t("Spectral Dash", "망령 질주", "talent name")
t([[For a brief moment your whole body becomes etheral and you dash into a nearby creature and all those in straight line behind it (in range %d).
		You reappear on the other side, with %d more psi and having dealt %0.2f mind damage to your targets.
		]], [[잠깐 동안 몸 전체를 영체로 바꿔 가까운 대상을 향해 질주합니다. 사거리 %d 칸 내의 모든 개체를 무시하고 대상에게 질주합니다.
		시전자는 염력을 %d 회복한 채로 반대편에서 나타나며, 대상에게 %0.2f 정신 피해를 가합니다.
		]], "tformat")
t("Writhing Psionic Mass", "뒤틀린 정신 물질", "talent name")
t([[Your physical form is but a mere extension of your mind, you can bend it at will for %d turns.
		While under the effect you gain %d%% all resistances and have %d%% chance to ignore all critical hits.
		On activation you also remove up to %d physical or mental effects.
		]], [[육체는 정신의 연장선에 불과합니다. 시전자는 %d 턴 동안 육체를 마음대로 조작합니다.
		지속시간 동안 모든 저항 %d%% 와 치명타 무시 확률 %d%% 를 얻습니다.
		이 기술을 발동하면 정신적 효과나 물리적 효과를 최대 %d 개 제거합니다.
		]], "tformat")
t("Ominous Form", "불길한 형상", "talent name")
t("You are already assuming a form.", "당신은 이미 형상을 취하고 있다.", "logPlayer")
t("%s resists your attack!", "%s 공격에 저항했다!", "logPlayer", nil, {"는"})
t([[Your psionic powers have no limits. You are now able to assault a target and clone its body without killing it.
		The form is only temporary, lasting %d turns and subject to the same restrictions as your normal powers.
		While using a stolen form your health is bound to your target. (Your life%% will always be identical to your target's life%%)
		]], [[시전자의 초능력은 한계가 없습니다. 적에게 맹공을 가해, 죽이지 않고 적을 복제할 수 있게 됩니다.
		이 형상은 일시적인 것으로, %d 턴 동안만 지속되며 시전자의 일반적인 능력과 같은 제한을 받습니다.
		이렇게 형상을 취하면 시전자의 생명력은 대상에게 속박됩니다. (시전자의 생명력 비율은 언제나 대상의 생명력 비율과 같게 됩니다)
		]], "tformat")

------------------------------------------------
section "tome-possessors/data/talents/psionic/possession.lua"

t("Possession Talent %d", "빙의 기술 %d", "tformat")
t("You must assume a form to use that form's talents.", "형상을 취해야만 해당 육체의 기술을 사용할 수 있다.", "logPlayer")
t([[When you assume a form, this talent will be replaced with one of the body's talents.
			The only use for this talent is to pre-organize your hotkeys bar.]], [[형상을 취할 때, 이 기술은 해당 육체의 기술 중 하나로 대체됩니다.
			이 기술은 단지 단축키 할당을 위해 사용됩니다.]], "tformat")
t("none", "없음", "_t")
t("\
%s%s%d)%s#LAST# (#LIGHT_BLUE#lv %d#LAST#, #LIGHT_RED#HP:%d/%d#LAST#)", "\
%s%s%d)%s#LAST# (#LIGHT_BLUE#%d 레벨#LAST#, #LIGHT_RED#생명력:%d/%d#LAST#)", "tformat")
t("Destroy Body", "육체 파괴", "talent name")
t("You have no stored bodies to delete.", "파괴할 육체가 없다.", "logPlayer")
t([[Discard a body from your psionic reserve.
		Bodies possessed:
		%s]], [[초능력 보관소에서 육체 하나를 폐기합니다.
		갖고 있는 육체:
		%s]], "tformat")
t("Assume Form", "형상 취하기", "talent name")
t("You have no stored bodies to use.", "사용할만한 육체가 남아있지 않다.", "logPlayer")
t("#CRIMSON#A strange feeling comes over you as two words imprint themselves on your mind: '#{italic}#Not yet.#{normal}#'", "#CRIMSON#두 단어가 당신의 정신에 새겨지며, 기이한 기분이 엄습한다: '#{italic}#아직은 아니야.#{normal}#'", "logPlayer")
t([[You call upon one of your reserve bodies, assuming its form.
		A body used this way may not be healed in any way.
		You can choose to exit the body at any moment by using this talent again, returning it to your reserve as it is.
		When you reach 0 life you are forced out of it and the shock deals %d%% of the maximum life of your normal body to you while reducing your movement speed by 50%% and your damage by 60%% for 6 turns.
		The cooldown only starts when you resume your normal form.
		While in another body all experience you gain still goes to you but will not be applied until you revert back.
		While in another body your currently equiped objects are #{italic}#merged#{normal}# in you, you can not take them of or wear new ones.
		Bodies possessed:
		%s]], [[비축한 육체 중 하나를 불러내어 그 형상을 취합니다.
		해당 육체는 어떤 방법으로도 회복될 수 없습니다.
		언제라도 이 기술을 다시 사용해 해당 육체에서 벗어날 수 있습니다. 해당 육체는 해제 시의 상태 그대로 보관소로 돌아가게 됩니다.
		육체의 생명력이 0 에 도달하면 육체에서 강제로 사출되어, 시전자의 본래 최대 생명력의 %d%% 에 해당하는 피해를 입고, 6 턴 동안 이동 속도가 50%%, 가하는 피해량이 60%% 감소합니다.
		시전자가 본래의 형상을 취할 때만 재사용 대기시간이 돌아갑니다.
		다른 개체의 형상을 취하고 있어도 경험치는 정상적으로 얻게 되지만, 원래 모습으로 돌아올 때만 레벨 업이 가능합니다.
		다른 개체의 형상을 취하면 현재 장착한 장비들은 시전자에게로 #{italic}#융합#{normal}# 되어, 장비를 벗거나, 새로 장착할 수 없습니다.
		갖고 있는 육체:
		%s]], "tformat")
t("Possess", "빙의", "talent name")
t("You do not have enough room in your bodies storage.", "육체 보관소에 충분한 공간이 없다.", "logPlayer")
t("This creature is immune to possession.", "이 개체는 빙의에 면역이다.", "logPlayer")
t("You may not possess a creature which you summoned.", "당신이 소환한 소환물에 빙의할 수는 없다.", "logPlayer")
t("You may not possess a creature which has an expiration time or a master.", "지속시간이 정해져 있거나, 주인이 있는 대상에게는 빙의할 수 없다.", "logPlayer")
t("You may not possess a creature of this rank (%s%s#LAST#).", "이 등급의 적에게는 빙의할 수 없다. (%s%s#LAST#).", "logPlayer")
t("Possess", "빙의", "_t")
t("Permanently learn to possess creatures of type #LIGHT_BLUE#%s#LAST# (you may only do that a few times, based on talent level) ?", "영구적으로 #LIGHT_BLUE#%s#LAST# 종족에 대한 빙의 방법을 배우시겠습니까? (기술 레벨에 비례해, 아주 적은 횟수만 가능합니다)", "tformat")
t("No", "아니요", "_t")
t("Yes", "네", "_t")
t("You may not possess this kind of creature.", "당신은 이 종류의 적에게 빙의하지 못한다.", "logPlayer")
t("You have no more room available to store a new body.", "보관소에 남는 공간이 없어 새로운 육체를 보관할 수 없다.", "logPlayer")
t("Your target is dead!", "대상이 죽었다!", "logPlayer")
t([[You cast a psionic web at a target that lasts for %d turns. Each turn it deals %0.2f mind damage.
		If the target dies with the web in place you will capture its body and store it in a hidden psionic reserve.
		At any further time you can use the Assume Form talent to temporarily shed your own body and assume your new form, strengths and weaknesses both.
		You may only use this power if you have room for a new body in your storage.

		You may only steal the body of creatures of the following rank %s%s#LAST# or lower.
		At level 3 up to rank %s%s#LAST#.
		At level 5 up to rank %s%s#LAST#.
		At level 7 up to rank %s%s#LAST#.

		You may only steal the body of creatures of the following types: #LIGHT_BLUE#%s#LAST#
		When you try to possess a creature of a different type you may learn this type permanently, you can do that %d more times.]], [[%d 턴 동안 지속되는 초능력 망을 대상에게 씌웁니다. 초능력 망은 매 턴마다 %0.2f 정신 피해를 가합니다.
		초능력 망의 영향을 받고 있는 도중에 대상이 죽게 되면, 시전자가 해당 육체를 강탈하여 숨겨진 초능력 보관소에 안치합니다.
		이후에 형상 취하기 기술을 사용하면, 해당 육체의 형상을 취해 육체의 강점과 약점을 모두 적용받습니다.
		보관소에 남은 공간이 없으면 육체를 강탈할 수 없습니다.

		시전자는 등급이 %s%s#LAST# 이하인 육체를 강탈할 수 있습니다.
		기술 레벨이 3 일 때, 최대 %s%s#LAST# 등급까지.
		기술 레벨이 5 일 때, 최대 %s%s#LAST# 등급까지.
		기술 레벨이 7 일 때, 최대 %s%s#LAST# 등급까지.

		오직 다음과 같은 종족의 육체만 강탈할 수 있습니다: #LIGHT_BLUE#%s#LAST#
		위에 포함되지 않는 종족의 육체를 강탈하려고 시도하면, 해당 종족에 대한 빙의 방법을 익힙니다. %d 종류 더 익힐 수 있습니다.]], "tformat")
t("Self Persistence", "자기 지속성", "talent name")
t("When you assume the form of an other body you can still keep %d%% of the values (defences, crits, powers, save, ...) of your own body.", "육체의 형상을 취할 때, 시전자는 원래 능력치의 %d%% 를 유지할 수 있게 됩니다. (회피도, 치명타, 내성 등등 ...)", "tformat")
t("Improved Form", "강화된 형상", "talent name")
t([[When you assume the form of another body you gain %d%% of the values (defences, crits, powers, save, ...) of the body.
		In addition talents gained from bodies are limited to level %0.1f.]], [[육체의 형상을 취할 때, 해당 육체의 능력치가 %d%% 향상됩니다. (회피도, 치명타, 내성 등등 ...)
		거기에 더해 해당 육체로 얻게 되는 기술의 레벨 상한이 %0.1f 이 됩니다.]], "tformat")
t("Full Control", "완벽한 통제", "talent name")
t([[When you assume the form of an other body you gain more control over the body:
		- at level 1 you gain one more talent slot
		- at level 2 you gain one more talent slot
		- at level 3 you gain resistances and flat resistances
		- at level 4 you gain one more talent slot
		- at level 5 you gain all speeds (only if they are superior to yours)
		- at level 6+ you gain one more talent slot
		]], [[육체의 형상을 취할 때, 해당 육체에 대한 통제력이 강해집니다.
		- 기술 레벨 1 일 때, 기술 슬롯을 하나 더 얻습니다.
		- 기술 레벨 2 일 때, 기술 슬롯을 하나 더 얻습니다.
		- 기술 레벨이 3 일 때, 각종 저항과 고정 피해 감소를 얻습니다.
		- 기술 레벨 4 일 때, 기술 슬롯을 하나 더 얻습니다.
		- 기술 레벨이 5 일 때, 전체 속도가 향상됩니다 (원래 육체보다 속도가 더 빠를 때에만).
		- 기술 레벨 6+ 일 때, 기술 슬롯을 하나 더 얻습니다.
		]], "tformat")

------------------------------------------------
section "tome-possessors/data/talents/psionic/psionic-menace.lua"

t("You are disarmed.", "무장을 해제했다.", "logPlayer")
t("You require two mindstars to use this talent.", "이 기술을 사용하기 위해서는 마석을 두 개 장착해야 한다.", "logPlayer")
t("Mind Whip", "정신 채찍", "talent name")
t([[You lash out your psionic fury at a distant creature, doing %0.2f mind damage.
		The whip can cleave to one nearby foe.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[원거리의 적을 정신력으로 채찍질하여 %0.2f 정신 피해를 가합니다.
		정신 채찍은 인접한 적 하나를 추가로 공격합니다.
		현재 마석을 양손에 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Psychic Wipe", "초능력 소거", "talent name")
t([[You project ethereal fingers inside the target's brain.
		Over %d turns it will take %0.2f total mind damage and have its mental save reduced by %d.
		This powerful effect uses 130%% of your Mindpower to try to overcome your target's initial mental save.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[영체 상태의 손가락을 대상의 뇌에 투사합니다.
		대상은 %d 턴에 걸쳐 총 %0.2f 정신 피해를 입고 정신 내성이 %d 감소합니다.
		이 기술은 효과 적용 판정 시, 대상의 정신 내성에 대항한 시전자의 정신력을 130%% 로 적용합니다.
		현재 마석을 양손에 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Ghastly Wail", "섬뜩한 곡성", "talent name")
t([[You let your mental forces go unchecked for an instant. All foes in a radius %d are knocked 3 grids away from you.
		Creatures that fail a mental save are also dazed for %d turns and take %0.2f mind damage.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[정신력을 순간적으로 해방하여 반경 %d 칸 내의 모든 적을 시전자로부터 3 칸 밀칩니다.
		정신 내성에 실패한 적은 %d 턴 동안 혼절 상태에 빠지며, %0.2f 정신 피해를 받습니다.
		현재 마석을 양손에 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")
t("Finger of Death", "죽음의 손가락", "talent name")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.", "#PURPLE##Source1# #Target#의 정신을 산산조각내어, 완전히 파괴했다.", "logCombat")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it but has no room to store the body.", "#PURPLE##Source1# #Target#의 정신을 산산조각내어 완전히 파괴했지만, 보관소에 육체를 안치할 공간이 부족하다.", "logCombat")
t("#CRIMSON#Target is not affected by ghastly wail!", "#CRIMSON#대상이 섬뜩한 곡성에 영향을 받지 않았다!", "logPlayer")
t([[You point your ghastly finger at a foe affected by Ghastly Wail and send a psionic impulse to tell it to simply die.
		The target will take %d%% of the life it already lost as mind damage.
		On targets of rank boss or higher the damage is limited to %d.
		If the target dies from the Finger and is of a type you can already absorb it is directly absorbed into your bodies reserve.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[섬뜩한 곡성에 영향을 받은 적을 망령의 손가락으로 가리켜, 초능력 파장을 통해 순순히 죽으라고 속삭입니다.
		대상은 이미 잃은 생명력의 %d%% 에 해당하는 정신 피해를 받습니다.
		대상의 등급이 보스 이상이라면 피해량은 %d 으로 제한됩니다.
		죽음의 손가락으로 인해 죽은 대상이 육체를 강탈할 수 있는 종족일 경우, 육체를 강탈해 보관소에 보관합니다.
		현재 마석을 양손에 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다. 염동 칼날은 이러한 종류의 격렬한 초능력과 동시에 사용할 수 없습니다.]], "tformat")

------------------------------------------------
section "tome-possessors/data/talents/psionic/psionic.lua"

t("psionic", "초능력", "talent category")
t("possession", "빙의", "talent type")
t("Learn to possess the bodies of your foes!", "적들의 육체에 빙의하는 법을 익힙니다!", "_t")
t("body snatcher", "육체 강탈자", "talent type")
t("Manipulate your dead foes bodies for power and success!", "죽은 적의 육체를 조작하고, 그 힘을 이용해 승리합니다!", "_t")
t("psionic menace", "초능력 위협", "talent type")
t("Laught terrible mind attacks to wear down your foes from afar with your double mindstars!", "양손에 쥔 마석으로 원거리에서 끔찍한 정신 공격을 보내, 적들을 만신창이로 만듭니다!", "_t")
t("psychic blows", "초능력 타격", "talent type")
t("Wield a two handed weapon to channel your psionics into your foes' faces!", "양손 무기를 통해 초능력 에너지를 적들의 면상에 방출합니다!", "_t")
t("battle psionics", "전투 초능력", "talent type")
t("Dual wield a one handed weapon and a mindstar to assail your enemies's minds and bodies!", "한손 무기와 마석을 들고, 적의 육체와 정신 모두를 공격합니다!", "_t")
t("deep horror", "깊은 공포", "talent type")
t("Through your psionic powers you become a nightmare for your foes.", "초능력을 이용하여 적들의 악몽이 됩니다.", "_t")
t("ravenous mind", "탐식의 정신", "talent type")
t("Your mind hungers for pain and suffering! Feed it!", "정신이 고통과 괴로움에 목말라 있습니다! 적의 고통을 집어삼키세요!", "_t")


------------------------------------------------
section "tome-possessors/data/talents/psionic/psychic-blows.lua"

t("You are disarmed.", "무장을 해제했다.", "logPlayer")
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기를 장비해야 한다.", "logPlayer")
t("Psychic Crush", "초능력 파쇄", "talent name")
t("%s's Psychic Image", "%s의 초능력 투영체", "tformat")
t("#ROYAL_BLUE#%s's psychic imprint appears!", "#ROYAL_BLUE#%s의 초능력 투영체가 나타났다!", "logSeen")
t("%s resists the psychic blow!", "%s 초능력 타격에 저항했다!", "logSeen", nil, {"는"})
t([[Using both your mind and your arms you propel your two handed weapon to deal a huge strike doing %d%% weapon mind damage.
		If the blow connects and the target fails a mental save there is %d%% chance that the blow was so powerful it ripped a psychic imprint off the target.
		It will appear nearby and serve you for %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[무기에 정신을 집중하여 힘을 더하고, 양손 무기로 강력한 일격을 가해 %d%% 무기 피해를 정신 속성으로 가합니다.
		공격이 명중하면 대상은 정신 내성 판정을 거칩니다. 실패할 경우 %d%% 확률로 적에게서 초능력 투영체를 벗겨냅니다.
		초능력 투영체는 적 근처에서 생성되며 %d 턴 동안 시전자를 돕습니다.
		현재 양손 무기를 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다.]], "tformat")
t("Force Shield", "힘의 보호막", "talent name")
t([[You create a psionic shield from your weapon that prevents you from ever taking blows that deal more than %d%% of your maximum life and gives you %d%% evasion.
		In addition, each time you take a melee hit the attacker automatically takes revenge strike that deals %d%% weapon damage as mind damage. (This effect can only happen once per turn)
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[무기에서 초능력 보호막을 생성하여 한 번에 최대 생명력의 %d%% 이상의 피해를 받지 않게 되고, %d%% 의 피해 무효화 확률을 얻게 됩니다.
		추가로, 근접 공격을 맞을 때마다 자동적으로 보복을 가해 %d%% 무기 피해를 정신 속성으로 가합니다 (이 효과는 한 턴에 한 번만 발생합니다).
		현재 양손 무기를 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다.]], "tformat")
t("Unleashed Mind", "해방된 정신", "talent name")
t([[You concentrate your powerful psionic powers on your weapon and briefly unleash your fury.
		All foes in radius %d will take a melee attack dealing %d%% weapon damage as mind damage.
		Any psionic clones in the radius will have its remaining time extended by %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[강력한 초능력을 무기에 집중해, 잠시 동안 분노를 해방합니다.
		반경 %d 칸 내의 모든 적에게 근접 공격을 가해 %d%% 무기 피해를 정신 속성으로 입힙니다.
		범위 내의 모든 초능력 투영체는 지속시간이 %d 턴 연장됩니다.
		현재 양손 무기를 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다.]], "tformat")
t("Seismic Mind", "압도적인 정신", "talent name")
t([[You shatter your weapon in the ground, projecting a psionic shockwave in a cone of radius %d.
		Any foes in the area will take %d%% weapon damage as mind damage.
		Any psionic clones hit will instantly shatter, exploding for %0.2f physical damage in radius 1.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[무기로 지면을 강타하고, 반경 %d 칸의 원뿔 범위에 초능력 충격파를 쏩니다.
		범위 내의 모든 적은 %d%% 무기 피해를 정신 피해로 받습니다.
		충격파에 휘말린 초능력 투영체는 즉시 산산조각나고, 반경 1 칸 내에 %0.2f 물리 피해를 가합니다.
		현재 양손 무기를 장비하고 있지 않더라도, 보조 장비 칸에 해당 무기들을 장비하고 있다면 즉시 장비 칸을 전환합니다.]], "tformat")
t("A temporary psionic imprint.", "일시적인 초능력 투영체입니다.", "_t")


------------------------------------------------
section "tome-possessors/data/talents/psionic/ravenous-mind.lua"

t("Sadist", "사디스트", "talent name")
t([[You feed on the pain of all foes in sight. For each one of them with life under 80%% you gain a stack of Sadist effect that increases your raw mindpower by %d.
		]], [[시야 내의 모든 적들이 느끼는 고통을 포식합니다. 적 하나의 생명력이 80%% 이하로 떨어지면, 시전자는 순수 정신력을 %d 증가시키는 사디스트 중첩을 하나 얻습니다.
		]], "tformat")
t("Channel Pain", "고통 모으기", "talent name")
t("#ORANGE#%s channels pain to %s!", "#ORANGE#%s 고통을 %s에게 모은다!", "logSeen", nil, {"는"})
t("#ORANGE#%s channels pain!", "#ORANGE#%s 고통을 모은다!", "logSeen")
t([[As long as you have at least a stack of Sadist whenever you take damage you use %d psi to harness your stacks of Sadist to divide the damage by your stacks + 1.
		Each time this happens a random foe in sight with 80%% or less life left will take a backlash of %d%% of the absorbed damage as mind damage.
		This effect can only happen once per turn and only triggers for hits over 10%% of your max life.]], [[사디스트 중첩을 하나 이상 갖고 있다면, 피격 시 염력을 %d 소모하여 피해량을 사디스트 중첩 + 1 의 수치로 나눕니다.
		이 효과가 발생할 때마다 시야 내의 생명력 80%% 이하인 적 하나가 반동을 받아, 흡수된 피해량의 %d%% 를 정신 피해로 대신 받습니다.
		이 효과는 한 턴에 한 번만 일어나며, 최대 생명력의 10%% 이상의 피해를 단번에 받을 때만 발동됩니다.]], "tformat")
t("Radiate Agony", "격통 발산", "talent name")
t("You need a Sadist stack to use this talent.", "이 기술을 사용하려면 사디스트 중첩이 필요하다.", "logPlayer")
t([[As long as you have at least a stack of Sadist you can radiate agony to all those you see in radius %d with 80%% or lower life left.
		For 5 turns their mind will be so focused on their own pain that they will deal %d%% less damage to you.]], [[사디스트 중첩을 하나 이상 갖고 있다면, 엄청난 고통을 반경 %d 칸 내, 시야 안의 생명력 80%% 이하인 적들에게 발산할 수 있게 됩니다.
		5 턴 동안 해당 적들의 정신은 격통으로 물들어, 가하는 피해량이 %d%% 감소합니다.]], "tformat")
t("Torture Mind", "정신 고문", "talent name")
t([[As long as you have at least a stack of Sadist you can mentally lash out at a target, sending horrible images to its mind.
		The target will reel from the effect for %d turns, rendering %d random talents unusable for the duration.]], [[사디스트 중첩을 하나 이상 갖고 있다면, 대상에게 끔찍한 환상을 보내 정신적인 공격을 가합니다.
		이 효과로 인해 대상은 %d 턴 동안 정신을 놓게 되어 무작위한 기술 %d 개를 사용할 수 없게 됩니다.]], "tformat")

------------------------------------------------
section "tome-possessors/data/timed_effects.lua"

t("psionic", "초능력", "effect subtype")
t("possession", "빙의", "effect subtype")
t("Ominous Form", "불길한 형상", "_t")
t("You stole your current form and share damage and healing with it.", "피해와 회복을 강탈한 현재 형상과 나눕니다.", "_t")
t("Assume Form", "형상 취하기", "_t")
t("You use the body of one of your fallen victims. You can not heal in this form.", "쓰러진 희생양들 중 하나의 육체를 사용하고 있음: 이 형상으로는 회복이 불가능함.", "_t")
t("#CRIMSON#While you assume a form you may not levelup. All exp gains are delayed and will be granted when you reintegrate your own body.", "#CRIMSON#형상을 취하고 있는 동안은 레벨 상승이 불가능합니다. 모든 경험치 습득이 지연되지만, 원래 모습으로 돌아올 때 지연된 경험치를 한꺼번에 획득합니다.", "_t")
t("#CRIMSON#Your body died! You quickly return to your normal one but the shock is terrible!", "#CRIMSON#육체가 죽었다! 신속하게 원래 육체로 돌아왔지만, 그 충격은 실로 끔찍하다!", "say")
t("was killed by possession aftershock", "빙의 후유증으로 인해 사망했다", "_t")
t("Kryl-Feijan", "키릴-페이얀", "_t")
t("Your possessed body's eyelids briefly flutter, and a tear rolls down its cheek. You didn't tell it to do that.", "빙의된 육체의 눈꺼풀이 잠깐 동안 흔들리고, 눈물이 볼을 타고 흐릅니다. 당신은 영문을 알 수 없습니다.", "_t")
t("Shasshhiy'Kaish", "샤쉬'카이쉬", "_t")
t("The flames surrounding Shasshhiy'Kaish slowly die as she falls to her knees.  \"Fiend...  and I thought #{italic}#I#{normal}# could cause suffering.  It's the one thing Eyalites always did best,\" she spits.  \"I heard what had happened to him, and my followers have given more than enough of their life to restore me after this.  All you've accomplished here - [cough] - is giving us a worthwhile new goal...  and target.  All will be repaid tenfold, Eyalite.\"  Her coughing grows weaker, until she abruptly bursts into flame; her ashes scatter into the wind.", "샤쉬'카이쉬가 마침내 무릎 꿇자, 주위를 휘감던 화염이 느리게 꺼져갔습니다.  \"악귀 같은 놈... 난 #{italic}#나만이#{normal}# 고통을 퍼뜨릴 수 있다고 생각했었어. 하지만 그쪽에서는 에이알인을 따라갈 사람이 없는 것 같네.\" 그녀는 그렇게 내뱉었습니다. \"그에게 무슨 일이 일어났는지 들었어. 그리고 그 사건 뒤 내 추종자들은 날 회복시키려고 목숨을 바쳤고. 네가 여기서 그런 짓을 한 덕분에 - [기침] - 해볼 만한 목표가 하나 생겼어... 노릴 녀석도 하나 생겼고. 열 배로 돌려받게 될 거야, 에이알인.\" 그녀의 기침은 점점 약해지더니, 갑작스러운 화염 폭발에 그녀의 육체가 휘말립니다. 이윽고, 그녀의 재가 바람에 날려 산산이 흩어집니다.", "_t")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린", "_t")
t("Aeryn's bewildered and terrified cries grow quiet, but...  your ears don't ring or hurt as screams of horror and rage surround you, louder than should be deafening.  When they shift to accusations, an unfamiliar guilt dominates your thoughts; you are forced to abandon your body before it can compel you to punish yourself.", "아에린의 당혹스럽고 겁에 질린 절규는 이윽고 조용해집니다. 하지만...  분노와 공포에 질린, 소음보다는 굉음에 가까운 비명소리가 당신을 둘러싸고 있음에도 당신의 귀는 울리지도, 아프지도 않습니다. 그 소리가 당신을 비난하자 익숙하지 않은 죄책감이 당신의 정신을 지배해 갑니다. 죄책감으로 자결하게 되기 전에 이 육체를 포기해야 합니다.", "_t")
t("stun", "기절", "effect subtype")
t("Possession Aftershock", "빙의 후유증", "_t")
t("The target is reeling from the aftershock of a destroyed possessed body, reducing damage by 60%%, reducing movement speed by 50%%.", "대상의 빙의체가 파괴되어 그 충격으로 인해 휘청이고 있음: 피해량 -60%%, 이동 속도 -50%%.", "tformat")
t("#Target# is stunned!", "#Target1# 기절했다!", "_t")
t("+Stunned", "+기절", "_t")
t("#Target# is not stunned anymore.", "#Target1# 제정신을 되찾았다.", "_t")
t("-Stunned", "-기절", "_t")
t("possess", "빙의", "effect subtype")
t("mind", "정신", "effect subtype")
t("Possess", "빙의", "_t")
t("The victim is snared in a psionic web that is destroying its mind and preparing its body for possession.  It takes %0.2f Mind damage per turn.", "대상이 정신을 파괴하고 빙의를 준비하는 초능력 망에 속박됨. 매 턴 %0.2f 의 정신 피해를 받음.", "tformat")
t("#Target#'s mind is convulsing.", "#Target1# 정신적인 고통으로 경련하고 있다.", "_t")
t("#Target#'s mind is not convulsing anymore.", "#Target#의 정신적인 고통이 멈췄다.", "_t")
t("#PURPLE##Source# shatters #Target#'s mind and takes possession of its body.", "#PURPLE##Source1# #Target#의 정신을 박살내고, 그 육체를 강탈했다.", "logCombat")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.", "#PURPLE##Source1# #Target#의 정신을 박살내고, 완전히 파괴했다.", "logCombat")
t("Psychic Wipe", "초능력 소거", "_t")
t("Ethereal fingers destroy the brain dealing %0.2f mind damage per turn and reducing mental save by %d.", "영체 상태의 손가락이 두뇌를 파괴해 매 턴 %0.2f 정신 피해를 받고, 정신 내성이 %d 감소됨.", "tformat")
t("#Target# suddently feels strange in the brain.", "#Target2# 갑자기 뇌에 기이한 느낌을 받기 시작했다.", "_t")
t("#Target# feels less strange.", "#Target1# 느끼던 기이한 느낌이 줄어들었다.", "_t")
t("Ghastly Wail", "섬뜩한 곡성", "_t")
t("The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze.", "혼절 / 이동 불가 / 가하는 피해량, 회피도, 모든 내성, 정확도, 주문력, 정신력, 물리력 -50%% / 피해를 받을 시 혼절이 해제됨.", "_t")
t("#Target# is dazed!", "#Target1# 혼절했다!", "_t")
t("+Dazed", "+혼절", "_t")
t("#Target# is not dazed anymore.", "#Target1# 더 이상 혼절 상태가 아니다.", "_t")
t("-Dazed", "-혼절", "_t")
t("Mind Steal", "정신 강탈", "_t")
t("Stolen talent: %s", "훔친 기술: %s", "tformat")
t("#Target# stole a talent!", "#Target1# 기술을 훔쳐냈다!", "_t")
t("#Target# forgot a talent.", "#Target2# 훔친 기술을 망각했다.", "_t")
t("%s can not use %s because it was stolen!", "%s %s 사용할 수 없다! 해당 기술은 강탈당했다!", "_t", nil, {"는","를"})
t("Writhing Psionic Mass", "뒤틀린 정신 물질", "_t")
t("All resists increased by %d%%, chance to be crit reduced by %d%%.", "모든 저항 +%d%%, 받는 치명타 확률 -%d%%.", "tformat")
t("#Target#'s body writhe in psionic energies!", "#Target1# 염동 에너지로 인해 몸부림치고 있다 !", "_t")
t("#Target#'s body looks more at rest.", "#Target#의 육체가 다시 안정화되었다.", "_t")
t("damage", "피해", "effect subtype")
t("Psionic Disruption", "염동력 방해", "_t")
t("%d stacks. Each stack deals %0.2f mind damage per turn.", "%d 중첩. 매 충첩 당 %0.2f 정신 피해를 매 턴 받음.", "tformat")
t("#Target# is disprupted by psionic energies!", "#Target2# 정신 에너지에 의해 방해받았다!", "_t")
t("#Target# no longer tormented by psionic energies.", "#Target2# 더이상 정신 에너지로 인해 방해받지 않는다.", "_t")
t("Psionic Block", "염동력 방어장", "_t")
t("%d%% chances to ignore damage and to retaliate with %0.2f mind damage.", "%d%% 확률로 피해를 무시하고, 공격자에게 %0.2f 정신 피해로 보복.", "tformat")
t("#Target# is protected by a psionic block!", "#Target1# 염동력 방어장으로 보호받고 있다!", "_t")
t("#Target# no longer protected by the psionic block.", "#Target#의 염동력 방어장이 사라졌다.", "_t")
t("#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", "#ROYAL_BLUE#%s 향한 공격은 염동력 방어장에 의해 무효화 되었다!", "logSeen", nil, {"를"})
t("Sadist", "사디스트", "_t")
t("Mindpower (raw) increased by %d.", "순수 정신력 +%d.", "tformat")
t("#Target# is empowered by the suffering of others!", "#Target1# 적들에게 고통을 퍼뜨리자 강력한 힘을 휘두른다!", "_t")
t("#Target# is no longer empowered.", "#Target#의 강력한 힘은 사라졌다.", "_t")
t("Radiate Agony", "격통 발산", "_t")
t("All damage reduced by %d%%.", "모든 피해가 %d%% 감소.", "tformat")
t("#Target# focuses on pain!", "#Target1# 고통에 집중한다!", "_t")
t("#Target# is no longer focusing on pain.", "#Target#의 고통 집중이 끝났다.", "_t")
t("lock", "잠금", "effect subtype")
t("Tortured Mind", "고문당한 정신", "_t")
t("%d talents unusable.", "%d 개의 기술 사용 불가.", "tformat")
t("#Target# is tormented!", "#Target2# 고문당했다!", "_t")
t("#Target# is less tormented.", "#Target2# 고문으로부터 벗어났다.", "_t")
t("%s can not use %s because of Tortured Mind!", "%s 고문당한 정신으로 인해 %s 사용하지 못한다!", "_t", nil, {"는","를"})

------------------------------------------------
section "tome-possessors/init.lua"

t("Possessor Bonus Class", "빙의술사 추가 직업", "init.lua long_name")
t("Possessor class.", "빙의술사 직업.", "init.lua description")

------------------------------------------------
section "tome-possessors/overload/mod/dialogs/AssumeForm.lua"

t("Assume Form", "형상 취하기", "_t")
t("Possess Body", "육체 빙의", "_t")
t("#SLATE##{italic}#Choose which body to assume. Bodies can never be healed and once they reach 0 life they are permanently destroyed.", "#SLATE##{italic}#형상을 취할 육체를 고르십시오. 선택한 육체는 회복이 불가능하고, 생명력이 0 에 도달하면 영구적으로 파괴됩니다.", "_t")
t("Create Minion", "하수인 생성", "_t")
t("Summon", "소환", "_t")
t("#SLATE##{italic}#Choose which body to summon. Once the effect ends the body will be lost.", "#SLATE##{italic}#소환할 육체를 선택하십시오. 효과가 끝나면 해당 육체는 사라집니다.", "_t")
t("Cannibalize Body", "육체 부품 교체", "_t")
t("Cannibalize", "육체 부품 교체", "_t")
t("#SLATE##{italic}#Choose which body to cannibalize. The whole stack of clones will be destroyed.", "#SLATE##{italic}#부품을 교체할 육체를 선택하십시오. 모든 복제품은 파괴될 것입니다.", "_t")
t("Destroy Body", "육체 파괴", "_t")
t("#SLATE##{italic}#Choose which body to destroy.", "#SLATE##{italic}#파괴할 육체를 선택하십시오.", "_t")
t("You have no bodies to use.", "사용할 수 있는 육체가 없다.", "logPlayer")
t("Discard Body", "육체 폐기", "_t")
t("Destroy: %s", "파괴: %s", "tformat")
t("Destroy the most damage copy or all?", "가장 많은 피해를 받은 육체를 파괴합니까? 아니면 육체 전부를 파괴합니까?", "_t")
t("Most damaged", "가장 많은 피해", "_t")
t("All", "모든", "_t")
t("Cancel", "취소", "_t")
t("Destroy it?", "파괴합니까?", "_t")
t("Destroy", "파괴", "_t")
t("#AQUAMARINE#You cannot destroy a body you are currently possessing.", "#AQUAMARINE#현재 빙의 중인 육체를 파괴할 수는 없다.", "log")
t("#AQUAMARINE#You are already using that body!", "#AQUAMARINE#당신은 이미 그 육체를 사용하고 있다!", "log")
t("%s%s (level %d) [Uses: %s]", "%s%s (레벨 %d) [사용: %s]", "tformat")
t(" **ACTIVE**", " **활성화**", "_t")
t("Life: ", "생명력: ", "_t")
t("#FFD700#Accuracy#FFFFFF#: ", "#FFD700#정확도#FFFFFF#: ", "_t")
t("#0080FF#Defense#FFFFFF#:  ", "#0080FF#회피도#FFFFFF#:  ", "_t")
t("#FFD700#P. power#FFFFFF#: ", "#FFD700#물리력#FFFFFF#: ", "_t")
t("#0080FF#P. save#FFFFFF#:  ", "#0080FF#물리 내성#FFFFFF#:  ", "_t")
t("#FFD700#S. power#FFFFFF#: ", "#FFD700#주문력#FFFFFF#: ", "_t")
t("#0080FF#S. save#FFFFFF#:  ", "#0080FF#주문 내성#FFFFFF#:  ", "_t")
t("#FFD700#M. power#FFFFFF#: ", "#FFD700#정신력#FFFFFF#: ", "_t")
t("#0080FF#M. save#FFFFFF#:  ", "#0080FF#정신 내성#FFFFFF#:  ", "_t")
t("#00FF80#Str/Dex/Con#FFFFFF#:  ", "#00FF80#힘/민첩/체격#FFFFFF#:  ", "_t")
t("#00FF80#Mag/Wil/Cun#FFFFFF#:  ", "#00FF80#마법/의지/교활#FFFFFF#:  ", "_t")
t("Cannibalize penalty: %d%%", "부품 교체 불이익: %d%%", "tformat")
t("Resists: ", "저항: ", "_t")
t("Hardiness/Armour: ", "방어 효율 / 방어력: ", "_t")
t("Size: ", "몸집 크기: ", "_t")
t("Critical Mult: ", "치명타 피해량 증가: ", "_t")
t("Melee Retaliation: ", "근접 공격 보복: ", "_t")
t("Passive Talents: ", "지속형 기술: ", "_t")
t("Active Talents: ", "발동형 기술: ", "_t")

------------------------------------------------
section "tome-possessors/overload/mod/dialogs/AssumeFormSelectTalents.lua"

t("Assume Form: Select Talents (max talent level %0.1f)", "형상 취하기: 기술을 고르십시오 (최대 기술 레벨 %0.1f)", "tformat")
t("Possess Body", "육체 빙의", "_t")
t("Cancel", "취소", "_t")
t("#SLATE##{italic}#Your level of #LIGHT_BLUE#Full Control talent#LAST# is not high enough to use all the talents of this body. Select which to keep, your choice will be permanent for this body and its clones.", "#SLATE##{italic}#당신의 #LIGHT_BLUE#완벽한 통제#LAST# 기술은 해당 육체의 모든 기술을 사용할 수 있을 정도로 높지 않습니다. 어떤 기술을 사용할지 선택하십시오, 이 선택은 해당 육체와 복제품에 있어 영구적입니다.", "_t")

