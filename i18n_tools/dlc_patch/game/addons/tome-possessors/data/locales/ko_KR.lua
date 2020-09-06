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
t("You require a mainhand weapon and an offhand mindstar to use this talent.", "이 기술을 사용하기 위해서는, 주 무기 칸에 무기를 장착하고, 보조 무기 칸에 마석을 장착해야 한다.", "logPlayer")
t("Psionic Disruption", "염동력 방해", "talent name")
t([[You imbue your offhand mindstar with wild psionic forces.
		While active you gain %d%% more of your mindstar's mindpower and mind critical chance.
		Each time you make a melee attack you also add a stack of Psionic Disruption to your target.
		Each stack lasts for %d turns and deals %0.2f mind damage over the duration (max %d stacks).
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[마석에 격렬한 초능력을 불어넣습니다.
		활성화 된 동안, 마석의 정신력과 정신 치명타 확률이 %d%% 증가합니다.
		근접 공격을 가할 때 마다, 대상에게 염동력 방해 1 중첩을 적용합니다.
		매 중첩은 %d 턴 동안 유지되며, 지속 기간 동안 %0.2f 정신 피해를 가합니다. 최대 %d 번 중첩 가능합니다.
		한손 무기와 마석이 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Shockstar", "충격의 별", "talent name")
t([[You make a first attack with your mainhand for %d%% weapon damage.
		If the attack hits the target is distracted and you use that to violently slam your mindstar into it, dealing %d%% damage.
		The shock is so powerful the target is stunned for %d turns and all creatures around in radius %d are dazed for the same time.
		The stun and daze duration is dependant on the number of psionic disruption charges on the target, the given number is for 4 charges.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[한 손 무기로 타격해 %d%% 무기 피해를 입힙니다.
		명중 시, 대상은 짧은 시간 동안 정신을 집중하지 못하게되고, 이 때, 시전자는 마석을 맹렬하게 내리쳐, %d%% 피해를 가합니다.
		충격은 너무나 강력해, 대상은 %d 턴 동안 기절하게 되고, 반경 %d 칸 내의 모든 적이 같은 시간동안 혼절하게 됩니다.
		기절과 혼절의 지속시간은 대상에게 적용된 염동력 방해 중첩에 비례하여 증가합니다. 이 기술 설명에 적혀져 있는 지속시간은 4 중첩일 경우를 상정한 설명입니다.
		한손 무기와 마석이 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Dazzling Lights", "눈부신 빛", "talent name")
t([[Raising your mindstar in the air you channel a bright flash of light through it. Any creatures in radius %d is blinded for %d turns.
		If any foe in melee range is blinded by the effect you quickly use that to your advantage by striking them with a blow of your main hand weapon doing %d%% damage.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[마석을 공중에 띄워, 강렬한 섬광을 마석을 통해 내보냅니다. 반경 %d 칸 내의 모든 적은 %d 턴 동안 실명합니다.
		인접한 위치에 적이 있을 경우, 실명 효과의 이점을 최대한 활용해, 주무기로 가격하여 %d%% 피해를 가합니다.
		한손 무기와 마석이 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Psionic Block", "염동력 방어장", "talent name")
t([[You concentrate to create a psionic block field all around you for 5 turns.
		While the effect holds all damage against you have a %d%% chance to be fully ignored.
		When damage is cancelled you instinctively make a retaliation mind strike against the source, dealing %0.2f mind damage. (The retaliation may only happen 2 times per turn.)
		]], [[염동력의 힘으로 이루어진 방어장을 만드는데 정신을 집중합니다. 방어장은 5 턴 동안 유지됩니다.
		지속기간 동안, 피격 시 받는 피해가 %d%% 확률로 완전히 무효화됩니다.
		공격이 무효화되면, 시전자는 즉각 정신 보복 공격을 공격자에게 가해, %0.2f 정신피해를 줍니다. (보복 효과는 한 턴에 2 번만 일어납니다)
		]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/body-snatcher.lua"

t("Bodies Reserve", "비축된 육체", "talent name")
t([[Your mind is so powerful it can bend reality, providing you with an extra-natural #{italic}#storage#{normal}# for bodies you snatch.
		You can store up to %d bodies.]], [[정신의 힘이 너무 강한 나머지, 현실 구조를 뒤틀리게하여, 시전자가 빼앗은 육체를 보관할 초자연적 #{italic}#보관소#{normal}#를 이용할 수 있게됩니다.
		최대 %d 구의 육체를 보관할 수 있습니다.]], "tformat")
t("Psionic Minion", "초능력 하수인", "talent name")
t("Not enough space to invoke your minion!", "하수인을 소환할 공간이 부족하다!", "logPlayer")
t("%s (Psionic Minion)", "%s (초능력 하수인)", "tformat")
t([[You imbue a part of your own mind into a body without actually taking its form.
		The body will work as your minion for %d turns.
		Psionic minions can not heal in any way.
		When the effect ends the body is permanently lost.]], [[형태가 잡히지 않은 육체에 정신의 일부를 주입합니다.
		해당 육체는 %d 턴 동안 시전자의 하수인이 됩니다.
		초능력 하수인은 회복이 불가능합니다.
		효과가 끝나면, 해당 육체는 영구적으로 파괴됩니다.]], "tformat")
t("Psionic Duplication", "초능력 복제", "talent name")
t([[When you store a body you also store %d more identical copies of it that you can use later.
		When you store a rare/unique/boss or higher rank creature you only get a third of the uses (but never less than one).]], [[육체를 보관할 때, 추후에 사용할 수 있는 %d 구의 복제 육체를 같이 보관합니다.
		희귀/단일/보스, 또는 더 높은 등급의 개체는 위 수치의 1/3 만 복제됩니다. (최소 1 구의 복제 육체는 보장됩니다)]], "tformat")
t("Cannibalize", "육체 부품 교체", "talent name")
t("You require need to assume a form first.", "우선 형태를 취해야한다.", "logPlayer")
t("Rank of body too low.", "육체의 등급이 너무 낮다.", "logPlayer")
t([[When you assume a form you may cannibalize a body in your reserve to replenish your current body.
		You can only use bodies that are of same or higher rank for the effect to work and each time you heal a body the effect will be reduced by 33%% for that body.
		Your current body will heal for %d%% of the max life of the cannibalized one and you will also regenerate 50%% of this value as psi.
		The healing effect is more psionic in nature than a real heal. As such may things that prevent healing will not prevent cannibalize from working.
		Cannibalize is the only possible way to heal a body.
		]], [[형태를 취하고 있을 때, 현재 육체를 보충하기 위해서, 보관소 내의 육체 하나를 일개 부품으로 이용할 수 있습니다.
		동일하거나, 상위 등급의 육체만이 이 효과를 위해 사용될 수 있습니다. 이 기술을 사용할 때 마다, 해당 육체에 대한 회복량은 33%% 씩 감소하게됩니다.
		현재 육체는 부품이 된 육체가 가진 최대 생명력의 %d%% 만큼 회복되며, 해당 수치의 50%% 만큼 염력을 회복합니다.
		회복 효과는 실제 회복 효과보다 자연적이 아닌, 초능력적인 성질을 훨씬 많이 띄고있습니다. 따라서 이 회복은 여러 회복을 막는 기술들을 무시하고 작동합니다.
		육체 부품 교체만이 육체를 회복할 수 있는 유일한 방법입니다.
		]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/deep-horror.lua"

t("%s resists the mind steal!", "%s 정신 강탈에 저항했다!", "logSeen", nil, {"는"})
t("%s has no stealable talents.", "%s 빼앗을만한 기술이 없다.", "logPlayer", nil, {"는"})
t("Choose a talent to steal:", "빼앗을 기술을 선택하세요 :", "_t")
t("Mind Steal", "정신 강탈", "_t")
t([[Your mere presence is a blight in your foes minds. Using this link you are able to reach out and steal a talent from a target.
		For %d turns you will be able to use a random active (not passive, not sustained) talent from your target, and they will loose it.
		You may not steal a talent which you already know.
		The stolen talent will not use any resources to activate.
		At level 5 you are able to choose which talent to steal.
		The talent stolen will be limited to at most level %d.]], [[존재만으로도 적들의 정신을 황폐하게 합니다. 이 연결을 통해, 정신을 뻗어 대상의 기술 하나를 강탈할 수 있게되었습니다.
		%d 턴 동안, 시전자는 대상의 무작위한 사용형 기술을 사용할 수 있고, 대상은 그 기술을 잃어버리게 됩니다. (지속 기술과 유지 기술은 강탈할 수 없습니다)
		시전자가 이미 알고있는 기술은 강탈할 수 없습니다.
		강탈한 기술은 사용시, 어떤 원천력도 소모하지 않습니다.
		기술 레벨 5 일 때, 강탈할 기술을 선택할 수 있게됩니다.
		강탈한 기술의 기술 레벨은 %d 으로 제한됩니다.]], "tformat")
t("Spectral Dash", "망령 질주", "talent name")
t([[For a brief moment your whole body becomes etheral and you dash into a nearby creature and all those in straight line behind it (in range %d).
		You reappear on the other side, with %d more psi and having dealt %0.2f mind damage to your targets.
		]], [[짧은 시간동안, 몸 전체를 영체로 바꿔 가까운 대상을 향해 질주합니다. 사거리 %d 내의 모든 개체를 무시하고 대상에게 질주합니다.
		시전자는 반대편에서 나타나며, 염력이 %d 회복되고, 대상에게 %0.2f 정신 피해를 가합니다.
		]], "tformat")
t("Writhing Psionic Mass", "뒤틀린 정신 물질", "talent name")
t([[Your physical form is but a mere extension of your mind, you can bend it at will for %d turns.
		While under the effect you gain %d%% all resistances and have %d%% chance to ignore all critical hits.
		On activation you also remove up to %d physical or mental effects.
		]], [[육체는 정신의 연장선에 불과합니다. 시전자는 %d 턴 동안 육체를 마음대로 조작합니다.
		지속 시간동안 모든 저항 %d%% 와 치명타 무시 확률 %d%% 를 얻게됩니다.
		이 기술을 발동할 때, 최대 %d 개의 정신적 또는 물리적 효과를 제거합니다.
		]], "tformat")
t("Ominous Form", "불길한 형체", "talent name")
t("You are already assuming a form.", "당신은 이미 형태를 취하고있다.", "logPlayer")
t("%s resists your attack!", "%s 공격에 저항했다!", "logPlayer", nil, {"는"})
t([[Your psionic powers have no limits. You are now able to assault a target and clone its body without killing it.
		The form is only temporary, lasting %d turns and subject to the same restrictions as your normal powers.
		While using a stolen form your health is bound to your target. (Your life%% will always be identical to your target's life%%)
		]], [[시전자의 초능력은 한계를 모릅니다. 적에게 맹공을 가해, 적을 쓰러뜨리지 않고 적을 복제할 수 있게됩니다.
		이 형체는 일시적인 것으로, 오직 %d 턴 동안 지속되며 시전자의 정상적인 능력과 같은 수준의 제한을 받습니다.
		이렇게 형태를 취할 때, 시전자의 생명력은 대상에게 속박됩니다. (시전자의 생명력 비율은 언제나 대상의 생명력 비율과 같게됩니다)
		]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/possession.lua"

t("Possession Talent %d", "빙의 기술 %d", "tformat")
t("You must assume a form to use that form's talents.", "형태를 취해야만 해당 육체의 기술을 사용할 수 있다.", "logPlayer")
t([[When you assume a form, this talent will be replaced with one of the body's talents.
			The only use for this talent is to pre-organize your hotkeys bar.]], [[형태를 취할 때, 이 기술은 해당 육체의 기술 중 하나로 대체됩니다.
			이 기술은 단지 단축키 할당을 위해 사용됩니다.]], "tformat")
t("none", "없음", "_t")
t("\
%s%s%d)%s#LAST# (#LIGHT_BLUE#lv %d#LAST#, #LIGHT_RED#HP:%d/%d#LAST#)", "\
%s%s%d)%s#LAST# (#LIGHT_BLUE#레벨 %d#LAST#, #LIGHT_RED#생명력:%d/%d#LAST#)", "tformat")
t("Destroy Body", "육체 파괴", "talent name")
t("You have no stored bodies to delete.", "파괴할만한 육체가 보관소에 존재하지 않는다.", "logPlayer")
t([[Discard a body from your psionic reserve.
		Bodies possessed:
		%s]], [[초능력 보관소에서 육체 하나를 폐기합니다.
		빙의한 육체:
		%s]], "tformat")
t("Assume Form", "형태 취하기", "talent name")
t("You have no stored bodies to use.", "사용할만한 육체가 남아있지 않다.", "logPlayer")
t("#CRIMSON#A strange feeling comes over you as two words imprint themselves on your mind: '#{italic}#Not yet.#{normal}#'", "#CRIMSON#두 단어가 당신의 정신에 새겨지며, 기이한 기분이 엄습한다 : '#{italic}#아직 아니야.#{normal}#'", "logPlayer")
t([[You call upon one of your reserve bodies, assuming its form.
		A body used this way may not be healed in any way.
		You can choose to exit the body at any moment by using this talent again, returning it to your reserve as it is.
		When you reach 0 life you are forced out of it and the shock deals %d%% of the maximum life of your normal body to you while reducing your movement speed by 50%% and your damage by 60%% for 6 turns.
		The cooldown only starts when you resume your normal form.
		While in another body all experience you gain still goes to you but will not be applied until you revert back.
		While in another body your currently equiped objects are #{italic}#merged#{normal}# in you, you can not take them of or wear new ones.
		Bodies possessed:
		%s]], [[저장한 육체중 하나를 불러내, 형태를 취합니다.
		해당 육체는 어떤 방법으로도 회복될 수 없습니다.
		언제라도 이 기술을 다시 사용해 해당 육체에서 벗어날 수 있습니다. 해당 육체는 해제 시의 상태 그대로 보관소로 돌아가게 됩니다.
		시전자의 생명력이 0 에 도달하면, 육체에서 강제로 사출되어, 시전자의 원래 생명력의 %d%% 에 해당하는 피해를 입고, 6 턴 동안 이동 속도가 50%% 감소하며, 가하는 피해량이 60%% 감소합니다.
		시전자가 본래 형태를 취할 때만 재사용 대기시간이 돌아갑니다.
		다른 개체의 형태를 취할 때, 경험치는 정상적으로 얻게 되지만, 원래 모습으로 돌아올 때만 레벨 업이 가능합니다.
		다른 개체의 형태를 취할때, 현재 장착한 장비들은 시전자에게로 #{italic}#융합#{normal}# 되어, 장비를 벗거나, 새로 장착할 수 없습니다.
		빙의한 육체:
		%s]], "tformat")
t("You do not have enough room in your bodies storage.", "육체 보관소에 충분한 공간이 없다.", "logPlayer")
t("This creature is immune to possession.", "이 개체는 빙의에 면역이다.", "logPlayer")
t("You may not possess a creature which you summoned.", "당신이 소환한 소환물에 빙의할 수는 없다.", "logPlayer")
t("You may not possess a creature which has an expiration time or a master.", "지속 시간이 정해져있거나, 주인이 있는 대상에게는 빙의할 수 없다.", "logPlayer")
t("You may not possess a creature of this rank (%s%s#LAST#).", "이 등급의 적에게는 빙의할 수 없다. (%s%s#LAST#).", "logPlayer")
t("No", "아니요", "_t")
t("Permanently learn to possess creatures of type #LIGHT_BLUE#%s#LAST# (you may only do that a few times, based on talent level) ?", "영구적으로 #LIGHT_BLUE#%s#LAST# 종족에 대한 빙의 방법을 배우시겠습니까? (이 기술은 기술 레벨에 비례해, 아주 적은 횟수만 사용 가능합니다)", "tformat")
t("Possess", "빙의", "_t")
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
		When you try to possess a creature of a different type you may learn this type permanently, you can do that %d more times.]], [[%d 턴 동안 지속되는 초능력 망을 대상에게 씌웁니다. 초능력 망은 매 턴, 적에게 %0.2f 정신 피해를 가합니다.
		초능력 망의 영향을 받고있는 도중, 대상이 죽으면, 시전자가 해당 육체를 강탈해, 숨겨진 초능력 보관소에 안치합니다.
		이후, 형태 취하기 기술을 사용하면, 해당 육체의 형태를 취해, 육체의 강점과 약점을 모두 적용받습니다.
		보관소에 남은 공간이 없으면, 육체를 강탈할 수 없습니다.

		시전자는 등급이 %s%s#LAST# 이하인 육체를 강탈 할 수 있습니다.
		기술 레벨 3 일 때, 최대 %s%s#LAST# 등급까지.
		기술 레벨 5 일 때, 최대 %s%s#LAST# 등급까지.
		기술 레벨 7 일 때, 최대 %s%s#LAST# 등급까지.

		오직 다음과 같은 종족의 육체만 강탈할 수 있습니다 : #LIGHT_BLUE#%s#LAST#
		위에 포함되지 않는 종족의 육체를 강탈하려고 시도하면, 해당 종족에 대한 빙의 방법을 익힙니다. %d 종류 더 익힐 수 있습니다.]], "tformat")
t("Self Persistence", "자기 지속성", "talent name")
t("When you assume the form of an other body you can still keep %d%% of the values (defences, crits, powers, save, ...) of your own body.", "육체의 형태를 취할 때, 시전자는 원래 능력치의 %d%% 를 유지 할 수 있게됩니다. (회피도, 치명타, 내성 등등 ...).", "tformat")
t("Improved Form", "강화된 형태", "talent name")
t([[When you assume the form of another body you gain %d%% of the values (defences, crits, powers, save, ...) of the body.
		In addition talents gained from bodies are limited to level %0.1f.]], [[육체의 형태를 취할 때, 해당 육체의 능력치 %d%% 를 추가합니다. (회피도, 치명타, 내성 등등 ...)
		추가로, 육체의 형태를 취할 때, 해당 육체으로 얻게되는 기술의 레벨 상한이 %0.1f 이 됩니다.]], "tformat")
t("Full Control", "완벽한 통제", "talent name")
t([[When you assume the form of an other body you gain more control over the body:
		- at level 1 you gain one more talent slot
		- at level 2 you gain one more talent slot
		- at level 3 you gain resistances and flat resistances
		- at level 4 you gain one more talent slot
		- at level 5 you gain all speeds (only if they are superior to yours)
		- at level 6+ you gain one more talent slot
		]], [[형태를 취할 때, 해당 육체에 대한 통제력이 강해집니다
		- 기술 레벨 1 일 때, 기술 슬롯을 하나 더 얻습니다
		- 기술 레벨 2 일 때, 기술 슬롯을 하나 더 얻습니다
		- 기술 레벨 3 일 때, 저항과, 고정 피해 감소를 얻습니다
		- 기술 레벨 4 일 때, 기술 슬롯을 하나 더 얻습니다
		- 기술 레벨 5 일 때, 전체 속도가 향상됩니다 (원래 육체보다 속도가 더 높을 때에만 해당됩니다)
		- 기술 레벨 6+ 일 때, 기술 슬롯을 하나 더 얻습니다
		]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic-menace.lua"

t("You are disarmed.", "당신의 무장은 해제됐다.", "logPlayer")
t("You require two mindstars to use this talent.", "이 기술을 사용하기 위해서는, 마석을 2 개 장착해야 한다.", "logPlayer")
t("Mind Whip", "정신 채찍", "talent name")
t([[You lash out your psionic fury at a distant creature, doing %0.2f mind damage.
		The whip can cleave to one nearby foe.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[원거리의 적을 정신의 분노로 채찍질하여 %0.2f 정신 피해를 가합니다.
		정신 채찍은 인접한 적 하나를 추가로 공격합니다.
		마석이 양 손에 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Psychic Wipe", "초능력 소거", "talent name")
t([[You project ethereal fingers inside the target's brain.
		Over %d turns it will take %0.2f total mind damage and have its mental save reduced by %d.
		This powerful effect uses 130%% of your Mindpower to try to overcome your target's initial mental save.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[영체 상태의 손가락을 대상의 뇌에 투사합니다.
		대상은 %d 턴 동안 총 %0.2f 정신 피해를 입고, 정신 내성이 %d 감소합니다.
		이 기술은 효과 적용 판정 시, 대상의 정신 내성에 대항한 시전자의 정신력을 130%% 로 적용합니다.
		마석이 양 손에 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Ghastly Wail", "섬뜩한 곡성", "talent name")
t([[You let your mental forces go unchecked for an instant. All foes in a radius %d are knocked 3 grids away from you.
		Creatures that fail a mental save are also dazed for %d turns and take %0.2f mind damage.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[짧은 시간동안 정신력을 해방하, 반경 %d 칸 내의 모든 적을 시전자로 부터 3 칸 밀칩니다.
		정신 내성에 실패한 적은 %d 턴 동안 혼절 상태에 빠지며, %0.2f 정신 피해를 받습니다.
		마석이 양 손에 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")
t("Finger of Death", "죽음의 손가락", "talent name")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.", "#PURPLE##Source1# #Target#의 정신을 산산조각내어, 완전히 파괴시켜버립니다.", "logCombat")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it but has no room to store the body.", "#PURPLE##Source1# #Target#의 정신을 산산조각 내어, 완전히 파괴시켜버렸지만, 보관소에 육체를 안치할 공간이 모자르다.", "logCombat")
t("#CRIMSON#Target is not affected by ghastly wail!", "#CRIMSON#대상이 섬뜩한 곡성에 영향을 받지 않았다!", "logPlayer")
t([[You point your ghastly finger at a foe affected by Ghastly Wail and send a psionic impulse to tell it to simply die.
		The target will take %d%% of the life it already lost as mind damage.
		On targets of rank boss or higher the damage is limited to %d.
		If the target dies from the Finger and is of a type you can already absorb it is directly absorbed into your bodies reserve.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]], [[섬뜩한 곡성에 영향을 받는 적을 망령의 손가락으로 가르켜, 초능력 파장을 통해 순순히 죽으라고 속삭입니다.
		대상은 제거된 생명력의 %d%% 에 해당하는 정신 피해를 받습니다.
		대상이 보스 이상의 등급일 때, 피해량은 %d 으로 제한됩니다.
		죽음의 손가락으로 인해 죽은 대상이, 육체를 강탈할 수 있는 종족일 경우 육체를 강탈해 보관소에 보관합니다.
		마석이 양 손에 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다. 격렬한 초능력은 염동 칼날과 함께 사용할 수 없습니다.]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psionic.lua"

t("Learn to possess the bodies of your foes!", "적들의 육체에 빙의하는 법을 익힙니다!", "_t")
t("possession", "빙의", "_t")
t("Manipulate your dead foes bodies for power and success!", "죽은 적의 육체의 힘을 다루고, 승리합니다!", "_t")
t("body snatcher", "육체 강탈자", "_t")
t("Laught terrible mind attacks to wear down your foes from afar with your double mindstars!", "양 손에 쥔 마석으로 원거리에서 끔찍한 정신 공격을 보내, 적들을 망신창이로 만듭니다!", "_t")
t("psionic menace", "초능력의 위협", "_t")
t("Wield a two handed weapon to channel your psionics into your foes' faces!", "양손 무기를 통해 초능력 에너지를 적의 얼굴에 방출합니다!", "_t")
t("psychic blows", "초능력 타격", "_t")
t("Dual wield a one handed weapon and a mindstar to assail your enemies's minds and bodies!", "한 손 무기와 마석을 들고, 적의 육체와 정신 모두를 공격합니다!", "_t")
t("battle psionics", "전투 초능력", "_t")
t("Through your psionic powers you become a nightmare for your foes.", "초능력을 이용해, 적들의 악몽이 됩니다.", "_t")
t("deep horror", "깊은 공포", "_t")
t("Your mind hungers for pain and suffering! Feed it!", "정신이 고통과 괴로움에 목말라 있습니다! 적의 고통을 집어 삼키십시오!", "_t")
t("psionic", "초능력", "talent category")
t("ravenous mind", "탐식의 정신", "_t")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/psychic-blows.lua"

t("You are disarmed.", "당신의 무장은 해제됐다.", "logPlayer")
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.", "logPlayer")
t("Psychic Crush", "초능력 파쇄", "talent name")
t("%s's Psychic Image", "%s의 초능력 형상", "tformat")
t("#ROYAL_BLUE#%s's psychic imprint appears!", "#ROYAL_BLUE#%s의 초능력 형상이 나타났다!", "logSeen")
t("%s resists the psychic blow!", "%s 초능력 타격에 저항했다!", "logSeen", nil, {"는"})
t([[Using both your mind and your arms you propel your two handed weapon to deal a huge strike doing %d%% weapon mind damage.
		If the blow connects and the target fails a mental save there is %d%% chance that the blow was so powerful it ripped a psychic imprint off the target.
		It will appear nearby and serve you for %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[정신과 두 팔을 사용하여 추진력을 더한 양손무기로 강력한 일격을 가해 %d%% 무기 피해를 정신 속성으로 가합니다.
		공격이 명중하면 대상은 정신 내성 판정을 해, 실패할 경우 %d%% 확률로 적에게서 초능력 형상을 벗겨냅니다.
		초능력 형상은 적 근처에서 생성되며, %d 턴 동안 시전자를 돕습니다.
		양손 무기가 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다.]], "tformat")
t("Force Shield", "힘의 보호막", "talent name")
t([[You create a psionic shield from your weapon that prevents you from ever taking blows that deal more than %d%% of your maximum life and gives you %d%% evasion.
		In addition, each time you take a melee hit the attacker automatically takes revenge strike that deals %d%% weapon damage as mind damage. (This effect can only happen once per turn)
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[무기에서 초능력 보호막을 생성해, 한번에 최대 생명력의 %d%% 이상의 피해를 받지 않게되고, %d%% 의 피해 무효화 확률을 얻게됩니다.
		추가로, 근접 공격을 받을 때 마다, 자동적으로 보복을 가해 %d%% 무기 피해를 정신 속성으로 가합니다. 이 효과는 한 턴에 1 번만 발생합니다)
		양손 무기가 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다.]], "tformat")
t("Unleashed Mind", "해방된 정신", "talent name")
t([[You concentrate your powerful psionic powers on your weapon and briefly unleash your fury.
		All foes in radius %d will take a melee attack dealing %d%% weapon damage as mind damage.
		Any psionic clones in the radius will have its remaining time extended by %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[강력한 염동의 힘을 무기에 집중해, 짧은 시간동안 분노를 해방합니다.
		반경 %d 칸 내의 모든 적은 근접 공격을 받아 %d%% 무기 피해를 정신 속성으로 받습니다.
		범위 내의 모든 초능력 복제는 지속시간이 %d 턴 연장됩니다.
		양손 무기가 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다.]], "tformat")
t("Seismic Mind", "압도적인 정신", "talent name")
t([[You shatter your weapon in the ground, projecting a psionic shockwave in a cone of radius %d.
		Any foes in the area will take %d%% weapon damage as mind damage.
		Any psionic clones hit will instantly shatter, exploding for %0.2f physical damage in radius 1.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]], [[무기를 지면에 던저, 무기를 산산 조각내고, 반경 %d 칸의 원뿔 범위에 초능력 충격파를 풀어놓습니다.
		범위 내의 모든 적은 %d%% 무기 피해를 정신 피해로 받습니다.
		충격파에 휘말린 초능력 복제는 순간, 산산 조각나, 반경 1 칸 내에 %0.2f 물리 피해를 가합니다.
		양손 무기가 장착되어 있지 않았지만, 보조 장비 칸에 착용되어 있는 경우, 즉시 장비를 바꿉니다.]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/talents/psionic/ravenous-mind.lua"

t("Sadist", "사디스트", "talent name")
t([[You feed on the pain of all foes in sight. For each one of them with life under 80%% you gain a stack of Sadist effect that increases your raw mindpower by %d.
		]], [[시야 내의 모든 적이 느끼는 고통을 포식합니다. 적 하나의 생명력이 80%% 이하로 떨어지면, 순수 정신력을 %d 증가시키는 사디스트 중첩을 하나 얻습니다.
		]], "tformat")
t("Channel Pain", "고통 모으기", "talent name")
t("#ORANGE#%s channels pain to %s!", "#ORANGE#%s 고통을 %s에게 모은다!", "logSeen", nil, {"는"})
t("#ORANGE#%s channels pain!", "#ORANGE#%s 고통을 모은다!", "logSeen")
t([[As long as you have at least a stack of Sadist whenever you take damage you use %d psi to harness your stacks of Sadist to divide the damage by your stacks + 1.
		Each time this happens a random foe in sight with 80%% or less life left will take a backlash of %d%% of the absorbed damage as mind damage.
		This effect can only happen once per turn and only triggers for hits over 10%% of your max life.]], [[사디스트 중첩을 하나 이상 갖고있을 때, 피격 시 염력을 %d 소모해, 피해량을 사디스트 중첩 + 1 의 수치로 나눕니다.
		이 효과가 발생할 때마다, 시야 내의 모든, 생명력 80%% 이하의 적이 반동을 받아, 흡수된 피해량의 %d%% 를 대신 받습니다.
		이 효과는 한 턴에 1 번만 일어나며, 한번에 최대 생명력의 10%% 이상의 피해를 받을 때만 발동됩니다.]], "tformat")
t("Radiate Agony", "격통 발산", "talent name")
t([[As long as you have at least a stack of Sadist you can radiate agony to all those you see in radius %d with 80%% or lower life left.
		For 5 turns their mind will be so focused on their own pain that they will deal %d%% less damage to you.]], [[사디스트 중첩을 하나 이상 갖고있을 때, 격통을 반경 %d 칸 내의 시전자가 볼수있는, 생명력 80%% 이하인 적에게 발산할 수 있게됩니다.
		5 턴 동안 적들의 정신이 격통으로 물들어, 가하는 피해량이 %d%% 감소합니다.]], "tformat")
t("Torture Mind", "정신 고문", "talent name")
t([[As long as you have at least a stack of Sadist you can mentally lash out at a target, sending horrible images to its mind.
		The target will reel from the effect for %d turns, rendering %d random talents unusable for the duration.]], [[사디스트 중첩을 하나 이상 갖고있을 때, 대상에게 끔찍한 환상을 보내 정신적인 공격을 가합니다.
		이 효과로 인해 대상은 %d 턴 동안 정신을 놓아, 무작위한 %d 개의 기술을 사용할 수 없게됩니다.]], "tformat")


------------------------------------------------
section "game/addons/tome-possessors/data/timed_effects.lua"

t("Ominous Form", "불길한 형체", "_t")
t("Assume Form", "형태 취하기", "_t")
t("Kryl-Feijan", "키릴-페이얀", "_t")
t("Shasshhiy'Kaish", "샤쉬'카이쉬", "_t")
t("High Sun Paladin Aeryn", "고위 태양의 기사 아에린", "_t")
t("possession", "빙의", "effect subtype")
t("#Target# is stunned!", "#Target1# 기절했다!", "_t")
t("+Stunned", "+기절", "_t")
t("#Target# is not stunned anymore.", "#Target1# 제정신을 되찾았다.", "_t")
t("-Stunned", "-기절", "_t")
t("Possess", "빙의", "_t")
t("#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.", "#PURPLE##Source1# #Target#의 정신을 산산조각내어, 완전히 파괴시켜버립니다.", "logCombat")
t("Psychic Wipe", "초능력 소거", "_t")
t("mind", "정신", "effect subtype")
t("Ghastly Wail", "섬뜩한 곡성", "_t")
t("The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze.", "혼절 / 이동 불가 / 가하는 피해량, 회피도, 모든 내성, 정확도, 주문력, 정신력, 물리력 -50%% / 피해를 받을 시 혼절이 해제됨.", "_t")
t("stun", "기절", "effect subtype")
t("#Target# is dazed!", "#Target1# 혼절 중이다!", "_t")
t("+Dazed", "+혼절", "_t")
t("#Target# is not dazed anymore.", "#Target1# 더 이상 혼절 상태가 아니다.", "_t")
t("-Dazed", "-혼절", "_t")
t("Mind Steal", "정신 강탈", "_t")
t("Writhing Psionic Mass", "뒤틀린 정신 물질", "_t")
t("Psionic Disruption", "염동력 방해", "_t")
t("Psionic Block", "염동력 방어장", "_t")
t("damage", "피해", "effect subtype")
t("Sadist", "사디스트", "_t")
t("Radiate Agony", "격통 발산", "_t")
t("psionic", "초능력", "effect subtype")


------------------------------------------------
section "game/addons/tome-possessors/init.lua"



------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeForm.lua"

t("Assume Form", "형태 취하기", "_t")
t("Summon", "소환", "_t")
t("Cannibalize", "육체 부품 교체", "_t")
t("Destroy Body", "육체 파괴", "_t")
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


