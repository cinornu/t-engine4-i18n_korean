locale "ko_KR"

------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/achievements/all.lua"

t("Shasshhiy'Kaish", "샤쉬'카이쉬", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/corrupted.lua"

t("Doombringer", "종말을 부르는 자", "birth descriptor name")
t("Weapon in hand and sheathed in flame, a Doombringer is a terrifying force in combat.", "불꽃에 휩싸인 무기를 든 종말을 부르는 자는 전투에서 두려운 힘을 발휘합니다.", "_t")
t("Doombringers are engines of war, cleaving and burning their way through entire armies.", "종말을 부르는 자는 그 자체로 전쟁 기계로, 적의 군대 전체를 불사르고 도살합니다.", "_t")
t("The most powerful Doombringers can harness the full power of their demonic ties and transform themselves into a gigantic demon.", "강력한 종말을 부르는 자는, 그들의 악마적인 힘을 마음껏 휘두르며, 거대한 악마로 변신할 수 있게됩니다.", "_t")
t("Their most important stats are: Strength and Magic", "그들에게 가장 중요한 능력치는 힘과 마법입니다.", "_t")
t("#GOLD#Life per level:#LIGHT_BLUE# +3", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +3", "_t")
t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:", "_t")
t("#LIGHT_BLUE# * +4 Magic, +0 Willpower, +0 Cunning", "#LIGHT_BLUE# * +4 마법, +0 의지, +0 교활", "_t")
t("#GOLD#Life per level:#LIGHT_BLUE# +2", "#GOLD#레벨 당 생명력:#LIGHT_BLUE# +2", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/doomelf.lua"

t("#GOLD#Stat modifiers:", "#GOLD#능력치 변경:", "_t")
t("#GOLD#Experience penalty:#LIGHT_BLUE# 12%", "#GOLD#경험치 패널티:#LIGHT_BLUE# 12%", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/birth/races_cosmetic.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/events/demon-statue.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/events/fire-haven.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/grids/demon_statues.lua"

t("Lithfengel", "리스펭겔", "_t")
t("Shasshhiy'Kaish", "샤쉬'카이쉬", "_t")
t("floor", "바닥", "entity type")
t("lava", "용암", "entity subtype")
t("No", "아니요", "_t")
t("Yes", "네", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/npcs/aquatic-demon.lua"

t("demon", "악마", "entity type")
t("major", "고위", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/npcs/major-demon.lua"

t("demon", "악마", "entity type")
t("major", "고위", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/objects/world-artifacts.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/lore/demon.lua"

t("demon statue: Lithfengel", "악마상: 리스펭겔", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/quests/re-abducted.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/quests/start-ashes.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/black-magic.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/brutality.lua"

t("%s resists the silence!", "%s 침묵에 저항합니다!", "logSeen", nil, {"가"})
t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.", "logPlayer")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/corruptions.lua"

t("torture", "고문", "_t")
t("wrath", "분노", "_t")
t("corruption", "타락", "talent category")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demon-seeds.lua"

t("%s is cured!", "%s 정화되었습니다!", "logSeen", nil, {"이"})
t("Silence", "침묵", "talent name")
t("You require a weapon and a shield to use this talent.", "방패와 근접무기 없이 이 기술을 사용할 수 없다.", "logPlayer")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demonic-pact.lua"

t("You require a weapon and a shield to use this talent.", "방패와 근접무기 없이 이 기술을 사용할 수 없다.", "logPlayer")
t("Select a teleport location...", "순간이동 할 목적지를 선택합니다...", "logPlayer")
t("Not enough space to summon!", "소환할 공간이 부족합니다.", "logPlayer")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demonic-strength.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/doom-covenant.lua"

t("raging volcano", "분출하는 화산", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/doom-shield.lua"

t("You require a weapon and a shield to use this talent.", "방패와 근접무기 없이 이 기술을 사용할 수 없다.", "logPlayer")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/fearfire.lua"

t("You can't move there.", "그곳으로 이동할 수 없다.", "logSeen")
t("The spell fizzles!", "주문이 실패했다!", "logSeen")
t("Infernal Breath", "지옥의 숨결", "talent name")
t([[Exhale a wave of dark fire with radius %d, lasting 4 turns. Any non-demon caught in the area will take %0.2f fire damage, and flames will be left dealing a further %0.2f each turn. Demons will be healed for the same amount.
		The damage will increase with your Strength Stat, but critically hit as a spell.]], [[반경 %d 칸 범위에 어둠 불꽃을 뿜어냅니다. 악마가 아닌 모든 존재는 %0.2f 화염 피해를 입습니다. 내뿜어진 화염은 지면에 남아, 매 턴 %0.2f 피해를 줍니다. 악마는 같은 수치만큼 회복합니다.
		피해량은 힘에 비례하여 증가합니다.]], "tformat")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/heart-of-fire.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/infernal-combat.lua"

t("You require a weapon and a shield to use this talent.", "방패와 근접무기 없이 이 기술을 사용할 수 없다.", "logPlayer")
t("%s resists the shield bash!", "%s 방패 강타에 저항했다!", "logSeen", nil, {"가"})


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/npcs.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/oppression.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/spellblaze.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/torture.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.", "logPlayer")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/wrath.lua"

t("You require a two handed weapon to use this talent.", "이 기술을 사용하려면 양손 무기가 필요합니다.", "logPlayer")
t("You can not do that currently.", "현재 그것을 할 수 없다.", "logPlayer")
t("You are too close to build up momentum!", "거리가 너무 가까워 가속도를 얻을 수 없습니다!", "logPlayer")
t("Destroyer", "파괴자", "talent name")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/misc/races.lua"

t("The various racial bonuses a character can have.", "캐릭터가 가질 수 있는 여러가지 종족의 능력입니다.", "_t")
t("race", "종족", "talent category")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/timed_effects.lua"

t("Destroyer", "파괴자", "_t")
t("pin", "속박", "effect subtype")
t("shield", "보호막", "effect subtype")
t("+Shield", "+보호막", "_t")
t("A shield forms around #target#.", "#target2# 주위에 마력의 보호막을 형성했다.", "_t")
t("-Shield", "-보호막", "_t")
t("The shield around #target# crumbles.", "#target#의 보호막이 부셔졌다.", "_t")
t("#SLATE#(%d absorbed)#LAST#", "#SLATE#(%d 분해됨)#LAST#", "tformat")
t("Your shield crumbles under the damage!", "피해로 인해 보호막이 부셔졌다!", "logPlayer")
t("corruption", "타락", "effect subtype")
t("heal", "회복", "effect subtype")
t("resistance", "저항", "effect subtype")
t("fire", "화염", "effect subtype")
t("#Target# is on fire!", "#Target1# 화상으로 고통스러워한다!", "_t")
t("+Burn", "+화상", "_t")
t("-Burn", "-화상", "_t")
t("armour", "갑옷", "effect subtype")
t("bleed", "출혈", "effect subtype")
t("cut", "상처", "effect subtype")
t("wound", "상처", "effect subtype")
t("#Target# starts to bleed darkness.", "#Target#의 그림자 상처에서 피가 흘러나온다.", "_t")
t("#Target# stops bleeding darkness.", "#Target#의 그림자 상처가 아물었다.", "_t")
t("#CRIMSON#(%d linked)#LAST#", "#CRIMSON#(%d 연결)#LAST#", "tformat")
t("darkness", "암흑", "effect subtype")
t("#Target# stops burning.", "#Target#의 화상이 치유되었다.", "_t")
t("cold", "냉기", "effect subtype")
t("none", "없음", "_t")
t("curse", "저주", "effect subtype")
t("vim", "원기", "effect subtype")
t("#Target# vanishes from sight.", "#Target1# 시야에서 사라졌다.", "_t")
t("#Target# is no longer invisible.", "#Target2# 다시 불투명해졌다.", "_t")
t("arcane", "비전", "effect subtype")
t("blight", "황폐", "effect subtype")
t("#Target# is no longer transformed.", "#Target#의 변신이 끝났다.", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/grids.lua"

t("mural painting", "벽화", "entity name")
t("floor", "바닥", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/npcs.lua"

t("major", "고위", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/objects.lua"

t("tattered paper scrap", "너덜너덜한 종잇조각", "entity name")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/anteroom-agony/zone.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/grids.lua"

t("floor", "바닥", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/npcs.lua"

t("demon", "악마", "entity type")
t("major", "고위", "entity subtype")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/objects.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/zones/searing-halls/zone.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/init.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/overload/data/chats/ashes-urhrok-walrog-pop.lua"

t("Vengeance for...  companions...", "동료들의... 복수를...", "_t")
t([[As the %s falls dead, bubbles start forming beneath you, then frothing as the water grows uncomfortably warm.
#AQUAMARINE#"Thank you...  interloper..."#WHITE# a low voice rumbles.
#AQUAMARINE#"Two obstacles to my rule of the sea...  too cowardly to fight themselves for me to finish off the victor..."#WHITE#
A few meters away, you see the bubbles combining and congregating around a transparent form, invisible before and now visible only by the water boiling around it.
#AQUAMARINE#"How convenient...  so much Sher'Tul magic for my taking...  magic to turn against its creators...  but now... one new obstacle...  one last great warrior under the waves..."#WHITE#]], [[%s 쓰러지자, 당신의 발 아래에서 거품이 생겨나고, 이내 끓어오르며 물이 부자연스럽게 따뜻해집니다.
#AQUAMARINE#"고맙군...  침입자여..."#WHITE# 낮은 목소리가 울려퍼집니다.
#AQUAMARINE#"내 통치에 훼방을 놓던 두 방해꾼들...  겁쟁이 놈들이 내게 죽을 것이 두려워 서로 싸우지도 못 했는가..."#WHITE#
몇 미터 거리에서, 거품이 합쳐지면서 투명한 형상을 만들어내는 것이 보입니다. 투명했던 모습 주변으로 이내 물이 끓어올라 뚜렷하게 볼 수 있습니다.
#AQUAMARINE#"참 편리하군...  셰르'툴의 마법도 내 손에 들어왔다... 그대로 이 마법을 되돌려주지... 하지만 당장은... 새로운 방해꾼 하나가... 파도 아래 위대한 전사가 하나 남아 있군...."#WHITE#]], "tformat", nil, {"가"})
t("The oceans are yours.  The people of Eyal gave up sea travel ages ago!", "바다는 당신의 것이오. 에이알의 사람들은 항해를 포기한지 오래요!", "_t")
t("You're the new Lord of the Seas?  What would you have me do?", "당신의 새로운 바다의 왕입니까? 제가 무엇을 해드릴 수 있겠습니까?", "_t")
t("The seas of Eyal shall know no lord, foul demon!  The chaos and death ends now!", "에이알의 바다에는 더 이상 왕이 없다, 추악한 악마야! 혼돈과 죽음은 이제 끝나리라!", "_t")
t("Stop bubbling and start dying, you overgrown tea-kettle!  Your treasures are mine!", "그만 뽀글 거리고 죽어, 이 거대한 찻주전자 같은 놈! 네 보물은 다 내 꺼다!", "_t")
t([[The frothing form frowns.
#AQUAMARINE#"Will come to the surface eventually...  you may be stronger then..."#WHITE#
The bubbles flare up, as a wave of heat emanates from the demon.
#AQUAMARINE#"No reason to wait..."#WHITE#]], [[끓어오르는 형체가 얼굴을 찡그립니다.
#AQUAMARINE#"결국엔 육지까지 올라설 것이다... 그때가 되면 너는 더 강해지겠지..."#WHITE#
거품이 뜨겁게 끓어오르며, 악마가 열기를 뿜어냅니다.
#AQUAMARINE#"그때까지 살려둘 필요는 없지..."#WHITE#]], "_t")
t([[You did not think it possible for an amorphous mass of bubbles to scowl.
#AQUAMARINE#"%s to the Naloren...  traitor to Ukllmswwik...  I am no fool... "#WHITE#
A jet of boiling water barely misses you, dissipating into bubbles above your head.
#AQUAMARINE#"Your 'loyalty...' would give me their fate..."#WHITE#
The frothing and bubbling around him grows to new heights as he charges you!]], [[당신은 형태가 없는 물체가 당신을 쏘아볼 수 있으리라곤 생각하지 못 했습니다.
#AQUAMARINE#"날로렌에겐 %s...  우클름스윅에겐 배신자... 날 속일 수 있다고 생각하나... "#WHITE#
끓는 물의 기류가 당신을 스쳐지나 가고, 당신의 머리 위로 그 궤적이 끓어오릅니다.
#AQUAMARINE#"네놈의 '충성심' 따위에... 그들처럼 죽지 않겠다..."#WHITE#
그의 주변에 거품이 끓으며 솟아올라 당신을 덮쳐옵니다!]], "tformat")
t("Murderer", "살해자", "_t")
t("Traitor", "배신자", "_t")
t([[He chuckles, bubbles bursting from his mouth with every laugh.
#AQUAMARINE#"So now you feign altruism...  were their deaths just indecision?...  I'll fix that...  scalding or drowning...  your choice..."#WHITE#
The sound of laughter fades under the roaring of water boiling around him as he charges you!]], [[그가 우습다는 듯 들썩이며 웃습니다. 웃을 때마다 그의 입에서 거품이 뿜어져 나옵니다.
#AQUAMARINE#"이제는 영웅 행세를 하는가...  were their deaths just indecision?...  I'll fix that...  타 죽던가, 익사하던가... 네가 골라라..."#WHITE#
웃음 소리가 사라져가고 이내 그의 주변에서 물이 끓어오르며 당신에게 달려듭니다!]], "_t")
t("#LIGHT_GREEN#[fight]#WHITE#", "#LIGHT_GREEN#[싸운다]#WHITE#", "_t")


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

t("dragon", "용", "_t")
t("naga", "나가", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/class/Game.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/class/Object.lua"



------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/dialogs/Birther.lua"



