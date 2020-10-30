------------------------------------------------
section "game/addons/tome-addon-dev/superload/mod/dialogs/debug/AddonDeveloper.lua"
-- 1 entries
t([[- Your profile has been enabled for addon uploading, you can go to #{italic}##LIGHT_BLUE#https://te4.org/addons/tome#LAST##{normal}# and upload your addon.
]], [[- Your profile has been enabled for addon uploading, you can go to #{italic}##LIGHT_BLUE#https://te4.org/addons/tome#LAST##{normal}# and upload your addon.
]], "_t")


------------------------------------------------
section "game/addons/tome-items-vault/overload/data/maps/items-vault/fortress.lua"
-- 2 entries
t("Psionic Metarial Retention", "Psionic Metarial Retention", "_t")
t("Temporal Locked Vault", "Temporal Locked Vault", "_t")


------------------------------------------------
section "game/addons/tome-possessors/data/timed_effects.lua"
-- 44 entries
t("You stole your current form and share damage and healing with it.", "You stole your current form and share damage and healing with it.", "_t")
t("You use the body of one of your fallen victims. You can not heal in this form.", "You use the body of one of your fallen victims. You can not heal in this form.", "_t")
t("#CRIMSON#While you assume a form you may not levelup. All exp gains are delayed and will be granted when you reintegrate your own body.", "#CRIMSON#While you assume a form you may not levelup. All exp gains are delayed and will be granted when you reintegrate your own body.", "_t")
t("#CRIMSON#Your body died! You quickly return to your normal one but the shock is terrible!", "#CRIMSON#Your body died! You quickly return to your normal one but the shock is terrible!", "say")
t("was killed by possession aftershock", "was killed by possession aftershock", "_t")
t("Your possessed body's eyelids briefly flutter, and a tear rolls down its cheek. You didn't tell it to do that.", "Your possessed body's eyelids briefly flutter, and a tear rolls down its cheek. You didn't tell it to do that.", "_t")
t("The flames surrounding Shasshhiy'Kaish slowly die as she falls to her knees.  \"Fiend...  and I thought #{italic}#I#{normal}# could cause suffering.  It's the one thing Eyalites always did best,\" she spits.  \"I heard what had happened to him, and my followers have given more than enough of their life to restore me after this.  All you've accomplished here - [cough] - is giving us a worthwhile new goal...  and target.  All will be repaid tenfold, Eyalite.\"  Her coughing grows weaker, until she abruptly bursts into flame; her ashes scatter into the wind.", "The flames surrounding Shasshhiy'Kaish slowly die as she falls to her knees.  \"Fiend...  and I thought #{italic}#I#{normal}# could cause suffering.  It's the one thing Eyalites always did best,\" she spits.  \"I heard what had happened to him, and my followers have given more than enough of their life to restore me after this.  All you've accomplished here - [cough] - is giving us a worthwhile new goal...  and target.  All will be repaid tenfold, Eyalite.\"  Her coughing grows weaker, until she abruptly bursts into flame; her ashes scatter into the wind.", "_t")
t("Aeryn's bewildered and terrified cries grow quiet, but...  your ears don't ring or hurt as screams of horror and rage surround you, louder than should be deafening.  When they shift to accusations, an unfamiliar guilt dominates your thoughts; you are forced to abandon your body before it can compel you to punish yourself.", "Aeryn's bewildered and terrified cries grow quiet, but...  your ears don't ring or hurt as screams of horror and rage surround you, louder than should be deafening.  When they shift to accusations, an unfamiliar guilt dominates your thoughts; you are forced to abandon your body before it can compel you to punish yourself.", "_t")
t("Possession Aftershock", "Possession Aftershock", "_t")
t("The target is reeling from the aftershock of a destroyed possessed body, reducing damage by 60%%, reducing movement speed by 50%%.", "The target is reeling from the aftershock of a destroyed possessed body, reducing damage by 60%%, reducing movement speed by 50%%.", "tformat")
t("The victim is snared in a psionic web that is destroying its mind and preparing its body for possession.  It takes %0.2f Mind damage per turn.", "The victim is snared in a psionic web that is destroying its mind and preparing its body for possession.  It takes %0.2f Mind damage per turn.", "tformat")
t("possess", "possess", "effect subtype")
t("#Target#'s mind is convulsing.", "#Target#'s mind is convulsing.", "_t")
t("#Target#'s mind is not convulsing anymore.", "#Target#'s mind is not convulsing anymore.", "_t")
t("#PURPLE##Source# shatters #Target#'s mind and takes possession of its body.", "#PURPLE##Source# shatters #Target#'s mind and takes possession of its body.", "logCombat")
t("Ethereal fingers destroy the brain dealing %0.2f mind damage per turn and reducing mental save by %d.", "Ethereal fingers destroy the brain dealing %0.2f mind damage per turn and reducing mental save by %d.", "tformat")
t("#Target# suddently feels strange in the brain.", "#Target# suddently feels strange in the brain.", "_t")
t("#Target# feels less strange.", "#Target# feels less strange.", "_t")
t("%s can not use %s because it was stolen!", "%s can not use %s because it was stolen!", "_t")
t("Stolen talent: %s", "Stolen talent: %s", "tformat")
t("#Target# stole a talent!", "#Target# stole a talent!", "_t")
t("#Target# forgot a talent.", "#Target# forgot a talent.", "_t")
t("All resists increased by %d%%, chance to be crit reduced by %d%%.", "All resists increased by %d%%, chance to be crit reduced by %d%%.", "tformat")
t("#Target#'s body writhe in psionic energies!", "#Target#'s body writhe in psionic energies!", "_t")
t("#Target#'s body looks more at rest.", "#Target#'s body looks more at rest.", "_t")
t("%d stacks. Each stack deals %0.2f mind damage per turn.", "%d stacks. Each stack deals %0.2f mind damage per turn.", "tformat")
t("#Target# is disprupted by psionic energies!", "#Target# is disprupted by psionic energies!", "_t")
t("#Target# no longer tormented by psionic energies.", "#Target# no longer tormented by psionic energies.", "_t")
t("%d%% chances to ignore damage and to retaliate with %0.2f mind damage.", "%d%% chances to ignore damage and to retaliate with %0.2f mind damage.", "tformat")
t("#Target# is protected by a psionic block!", "#Target# is protected by a psionic block!", "_t")
t("#Target# no longer protected by the psionic block.", "#Target# no longer protected by the psionic block.", "_t")
t("#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", "#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", "logSeen")
t("Mindpower (raw) increased by %d.", "Mindpower (raw) increased by %d.", "tformat")
t("#Target# is empowered by the suffering of others!", "#Target# is empowered by the suffering of others!", "_t")
t("#Target# is no longer empowered.", "#Target# is no longer empowered.", "_t")
t("All damage reduced by %d%%.", "All damage reduced by %d%%.", "tformat")
t("#Target# focuses on pain!", "#Target# focuses on pain!", "_t")
t("#Target# is no longer focusing on pain.", "#Target# is no longer focusing on pain.", "_t")
t("Tortured Mind", "Tortured Mind", "_t")
t("%d talents unusable.", "%d talents unusable.", "tformat")
t("lock", "lock", "effect subtype")
t("#Target# is tormented!", "#Target# is tormented!", "_t")
t("#Target# is less tormented.", "#Target# is less tormented.", "_t")
t("%s can not use %s because of Tortured Mind!", "%s can not use %s because of Tortured Mind!", "_t")


------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeForm.lua"
-- 18 entries
t("Possess Body", "Possess Body", "_t")
t("#SLATE##{italic}#Choose which body to assume. Bodies can never be healed and once they reach 0 life they are permanently destroyed.", "#SLATE##{italic}#Choose which body to assume. Bodies can never be healed and once they reach 0 life they are permanently destroyed.", "_t")
t("Create Minion", "Create Minion", "_t")
t("#SLATE##{italic}#Choose which body to summon. Once the effect ends the body will be lost.", "#SLATE##{italic}#Choose which body to summon. Once the effect ends the body will be lost.", "_t")
t("Cannibalize Body", "Cannibalize Body", "_t")
t("#SLATE##{italic}#Choose which body to cannibalize. The whole stack of clones will be destroyed.", "#SLATE##{italic}#Choose which body to cannibalize. The whole stack of clones will be destroyed.", "_t")
t("#SLATE##{italic}#Choose which body to destroy.", "#SLATE##{italic}#Choose which body to destroy.", "_t")
t("You have no bodies to use.", "You have no bodies to use.", "logPlayer")
t("Discard Body", "Discard Body", "_t")
t("Destroy the most damage copy or all?", "Destroy the most damage copy or all?", "_t")
t("Most damaged", "Most damaged", "_t")
t("Destroy it?", "Destroy it?", "_t")
t("Destroy: %s", "Destroy: %s", "tformat")
t("#AQUAMARINE#You cannot destroy a body you are currently possessing.", "#AQUAMARINE#You cannot destroy a body you are currently possessing.", "log")
t("#AQUAMARINE#You are already using that body!", "#AQUAMARINE#You are already using that body!", "log")
t("%s%s (level %d) [Uses: %s]", "%s%s (level %d) [Uses: %s]", "tformat")
t(" **ACTIVE**", " **ACTIVE**", "_t")
t("Life: ", "Life: ", "_t")


------------------------------------------------
section "game/addons/tome-possessors/overload/mod/dialogs/AssumeFormSelectTalents.lua"
-- 3 entries
t("Assume Form: Select Talents (max talent level %0.1f)", "Assume Form: Select Talents (max talent level %0.1f)", "tformat")
t("Possess Body", "Possess Body", "_t")
t("#SLATE##{italic}#Your level of #LIGHT_BLUE#Full Control talent#LAST# is not high enough to use all the talents of this body. Select which to keep, your choice will be permanent for this body and its clones.", "#SLATE##{italic}#Your level of #LIGHT_BLUE#Full Control talent#LAST# is not high enough to use all the talents of this body. Select which to keep, your choice will be permanent for this body and its clones.", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/general/objects/world-artifacts.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/lore/demon.lua"
-- 70 entries
t("history of Mal'Rok (mistranslated)", "history of Mal'Rok (mistranslated)", "_t")
t([[(You see here a pile of strange tablets, all piled up in a nice, orderly stack.  You remove the top one, and study it; your finger slips across a square in one corner, and strange sentences start playing through your mind. You struggle to make sense of the unfamiliar words and concepts in your thoughts.)

Many #{italic}##FIREBRICK#[moon-craters]#{normal}##LAST# after he #{italic}##FIREBRICK#[planted]#{normal}##LAST# us and #{italic}##FIREBRICK#[retired]#{normal}##LAST#, the #{italic}##FIREBRICK#[Father]#{normal}##LAST# awoke from his #{italic}##FIREBRICK#[cocoon]#{normal}##LAST# to see us #{italic}##FIREBRICK#[rattling]#{normal}##LAST#. He was shocked at our #{italic}##FIREBRICK#[wilted]#{normal}##LAST# state, asking us why we #{italic}##FIREBRICK#[rattled]#{normal}##LAST#; we told him about the #{italic}##FIREBRICK#[shaking]#{normal}##LAST# we had to suffer through, the way the planet was #{italic}##FIREBRICK#[jammed up]#{normal}##LAST# and how although our #{italic}##FIREBRICK#[peas in a pod]#{normal}##LAST# had #{italic}##FIREBRICK#[plugged the leaks]#{normal}##LAST# to keep the #{italic}##FIREBRICK#[beads]#{normal}##LAST# from #{italic}##FIREBRICK#[falling out]#{normal}##LAST#, the #{italic}##FIREBRICK#[brooms]#{normal}##LAST# kept sweeping our #{italic}##FIREBRICK#[dust bunnies]#{normal}##LAST# away, and there wasn't enough empty room to keep the #{italic}##FIREBRICK#[beads]#{normal}##LAST# from #{italic}##FIREBRICK#[cracking]#{normal}##LAST#.

(There is a larger square on the tablet here; you press your hand to it, and suddenly you see a desert planet, ravaged by constant dust-storms. You feel the futility of a short, greenish thing as he looks on his ruined crops; you feel the wrath of a red-skinned humanoid as he rushes at a large horde of small, onyx creatures, a sword in one hand and a fireball in the other. The images disappear as you remove your hand.)

#{italic}##FIREBRICK#[Father]#{normal}##LAST# gave us his #{italic}##FIREBRICK#[tools]#{normal}##LAST#, and after we #{italic}##FIREBRICK#[tripped the janitors?]#{normal}##LAST# he had us #{italic}##FIREBRICK#[shake gently?]#{normal}##LAST#, but instead of #{italic}##FIREBRICK#[rattling]#{normal}##LAST# we were #{italic}##FIREBRICK#[making music]#{normal}##LAST#, only #{italic}##FIREBRICK#[cracking]#{normal}##LAST# the #{italic}##FIREBRICK#[beads]#{normal}##LAST# that made us #{italic}##FIREBRICK#[out of tune]#{normal}##LAST#; our #{italic}##FIREBRICK#[beads]#{normal}##LAST# grew stronger, learned how to use #{italic}##FIREBRICK#[tools]#{normal}##LAST# of different #{italic}##FIREBRICK#[colors]#{normal}##LAST# than what the #{italic}##FIREBRICK#[Father]#{normal}##LAST# gave us. The #{italic}##FIREBRICK#[Father]#{normal}##LAST# loved to #{italic}##FIREBRICK#[hear our music]#{normal}##LAST#, and we were grateful he was there to #{italic}##FIREBRICK#[compose]#{normal}##LAST# for us when we needed; soon we were #{italic}##FIREBRICK#[writing our own music]#{normal}##LAST# and didn't need to #{italic}##FIREBRICK#[rattle]#{normal}##LAST# anymore, and the #{italic}##FIREBRICK#[Father]#{normal}##LAST# #{italic}##FIREBRICK#[retired]#{normal}##LAST#.

(Another larger square. You see a wonderful, loving #{italic}##FIREBRICK#[Father]#{normal}##LAST# descending on the planet, desert turning to lush forest with his touch; you worship him with your green and onyx and ruby brethren, all different shapes and sizes, united for the first time in appreciating all the good he's done for you. For the first time in ages, you know where your next meal is coming from, and you need not fear others killing you for your farmland, nor the dust storms. He holds the corpses of some reclusive earth-mages in his hand, the source of the storms; you would be angry at them, but you can only feel happiness for the future to come. You and your brethren start competing in an organized fashion, occasionally in fights again, but even when you die you know it's for the good of the planet; an age later, you and your brethren are smarter, stronger, and far happier than before, living in paradise. You remove your hand an instant later, and the feelings of worship and admiration drain from you.)

Eventually, the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# came. We tried to #{italic}##FIREBRICK#[crack their beads]#{normal}##LAST# but nothing happened; they did not try to #{italic}##FIREBRICK#[crack]#{normal}##LAST# us but instead promised us even more wonderful #{italic}##FIREBRICK#[sheet music]#{normal}##LAST# than what our #{italic}##FIREBRICK#[Father]#{normal}##LAST# had given us, under the condition that we let them #{italic}##FIREBRICK#[shatter]#{normal}##LAST# him. We refused, but we reached a #{italic}##FIREBRICK#[nasty pod]#{normal}##LAST# together; we'd #{italic}##FIREBRICK#[mute? pot?]#{normal}##LAST# the #{italic}##FIREBRICK#[Father]#{normal}##LAST# with the #{italic}##FIREBRICK#[tools]#{normal}##LAST# he gave us, leaving him a #{italic}##FIREBRICK#[lazy carpenter]#{normal}##LAST# and proving our #{italic}##FIREBRICK#[pod was shut]#{normal}##LAST# with the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST#. The #{italic}##FIREBRICK#[Father]#{normal}##LAST# wouldn't be #{italic}##FIREBRICK#[rattled or cracked]#{normal}##LAST# by this; he wouldn't even know. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# were pleased, and #{italic}##FIREBRICK#[smeared]#{normal}##LAST# their #{italic}##FIREBRICK#[eggsuckers]#{normal}##LAST# on our planet, letting us trade with #{italic}##FIREBRICK#[pods from other plants]#{normal}##LAST# from all other kinds of #{italic}##FIREBRICK#[gardens]#{normal}##LAST#. We tasted new food, learned new #{italic}##FIREBRICK#[tools]#{normal}##LAST#, and some #{italic}##FIREBRICK#[fancy]#{normal}##LAST# types of new #{italic}##FIREBRICK#[beads]#{normal}##LAST# came to our #{italic}##FIREBRICK#[garden]#{normal}##LAST#. We felt a little #{italic}##FIREBRICK#[noise]#{normal}##LAST# about our #{italic}##FIREBRICK#[Father]#{normal}##LAST#, but he was not #{italic}##FIREBRICK#[noisy]#{normal}##LAST# and wouldn't #{italic}##FIREBRICK#[hear]#{normal}##LAST# any #{italic}##FIREBRICK#[sounds]#{normal}##LAST#. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# acted as our #{italic}##FIREBRICK#[pod peas]#{normal}##LAST#, and we treated them with great #{italic}##FIREBRICK#[listening]#{normal}##LAST#, even as they #{italic}##FIREBRICK#[slipped from the pod]#{normal}##LAST# and we could no longer #{italic}##FIREBRICK#[attend each other's concerts]#{normal}##LAST#.

(You touch the panel on the next page. A creature appears before you, stepping out of a massive fortress - it has an egg-shaped body, and limbs like four #{italic}##FIREBRICK#[tendril-weeds]#{normal}##LAST#. You hate this thing with all your being, although you know you did not at the time. They say they want the #{italic}##FIREBRICK#[Father]#{normal}##LAST# dead, and can offer you great magic and technology in return; you loathe to consider the idea, but their fortresses and weapons make you wonder if their offer is truly optional. You consider waking #{italic}##FIREBRICK#[Father]#{normal}##LAST# to ask him for help, but worry that even he could not stand up to the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST#; ultimately you decided to seal him in his sleep, leaving him harmless but unharmed, unconscious until further intervention. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# begrudgingly accept this resolution, and keep up their end of the bargain. They give you strange, powerful artifacts, and build portals on your world that let you pass through to strange worlds, more incredible and beautiful than you could possibly imagine, and filled with other races who've been given these gifts and seek to trade. You taste new foods, learn new magic, hear new music, and discover more beauty than you have in your entire history. If not for the pangs of guilt, life could not be better. Only when you remove your hand and the images start clearing from your mind do you recognize the "egg-weeds" as the Sher'Tul.)

Then, there was great #{italic}##FIREBRICK#[noise]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It was #{italic}##FIREBRICK#[eardrum-bursting]#{normal}##LAST#.

(There is another panel. You dare not touch it, but as you reach to put it away, a finger briefly brushes across it. Starvation, burning, suffocation, misery, fury, and sheer agony rage across your mind for what you know to be a tenth of a second, but feels like half a minute. Your ears are still ringing as you move on to the next square.)

The #{italic}##FIREBRICK#[eggsuckers]#{normal}##LAST# were a trap, a #{italic}##FIREBRICK#[discord]#{normal}##LAST# planted by the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# to #{italic}##FIREBRICK#[crack]#{normal}##LAST# us all, and only cause #{italic}##FIREBRICK#[hairline fracture]#{normal}##LAST# to their own #{italic}##FIREBRICK#[garden]#{normal}##LAST#. Their #{italic}##FIREBRICK#[wrong note]#{normal}##LAST# turned our planet to #{italic}##FIREBRICK#[cacophony]#{normal}##LAST#, and nearly all of us #{italic}##FIREBRICK#[fell out of the pod]#{normal}##LAST#. The #{italic}##FIREBRICK#[apple was peeled]#{normal}##LAST# and a fragment of our #{italic}##FIREBRICK#[shell]#{normal}##LAST# floated in the #{italic}##FIREBRICK#[ocean]#{normal}##LAST#. Our #{italic}##FIREBRICK#[handymen]#{normal}##LAST# acted quickly to give the #{italic}##FIREBRICK#[peel]#{normal}##LAST# and our #{italic}##FIREBRICK#[garden]#{normal}##LAST# #{italic}##FIREBRICK#[tempo]#{normal}##LAST#, and would have failed had the #{italic}##FIREBRICK#[noise]#{normal}##LAST# not woken up #{italic}##FIREBRICK#[Father]#{normal}##LAST#.

We were sorry. We were so sorry. Our #{italic}##FIREBRICK#[pod]#{normal}##LAST# was #{italic}##FIREBRICK#[rotten]#{normal}##LAST# and we knew it; we should never have #{italic}##FIREBRICK#[planted it]#{normal}##LAST#. Father forgave us for our #{italic}##FIREBRICK#[spoiled barrel]#{normal}##LAST# and #{italic}##FIREBRICK#[fertilized our garden]#{normal}##LAST#; it was still burning and #{italic}##FIREBRICK#[salted]#{normal}##LAST#, but by #{italic}##FIREBRICK#[breaking out the toolbox]#{normal}##LAST# we could still #{italic}##FIREBRICK#[plant seeds]#{normal}##LAST# on it. We could not #{italic}##FIREBRICK#[bloom]#{normal}##LAST# but we could #{italic}##FIREBRICK#[hold a note, just one note]#{normal}##LAST#. #{italic}##FIREBRICK#[Father]#{normal}##LAST# is still devoting all his will to #{italic}##FIREBRICK#[nailing our garden together]#{normal}##LAST#; it will #{italic}##FIREBRICK#[splinter and wilt]#{normal}##LAST# if he stopped for even a second. Bless the #{italic}##FIREBRICK#[Father]#{normal}##LAST# in his altruism. Bless the #{italic}##FIREBRICK#[Father]#{normal}##LAST#. We are so sorry.

(You unsteadily touch your palm to the next panel. You stand on a charred, bubbling cliff, and see a black, star-dotted expanse above and below you. Your feet are constantly searing; the mages could give you oxygen and convert ambient magic into caloric energy, but they couldn't undo the terrible magical flames that rage on the blown-off continent, or the eternal pyre of your former planet. Nearly everyone you know is dead, and your scryers tell you the home of the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# has suffered only minor damage; all the others you've contacted through portals were blown apart instantly. Your home only survives from the constant effort and concentration of #{italic}##FIREBRICK#[Father]#{normal}##LAST#, who is exerting every bit of magic he can to keep the shattered fragments from spinning off into the void. There is no part of you that does not feel deep regret; you would commit suicide if you did not hope there was a way you could apologize to #{italic}##FIREBRICK#[Father]#{normal}##LAST#, work as tirelessly and selflessly as he is. The regret drains as your hand leaves the panel.)

We asked #{italic}##FIREBRICK#[Father]#{normal}##LAST# what #{italic}##FIREBRICK#[song to sing]#{normal}##LAST# to #{italic}##FIREBRICK#[make him dance]#{normal}##LAST# again. He told us: #{italic}##FIREBRICK#[rattle]#{normal}##LAST# the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# until their every last #{italic}##FIREBRICK#[bead falls out]#{normal}##LAST#. We know our #{italic}##FIREBRICK#[orchestra hall]#{normal}##LAST#, and we will #{italic}##FIREBRICK#[crash the party]#{normal}##LAST#. For our sake, giving us a new #{italic}##FIREBRICK#[garden]#{normal}##LAST# to replace the one the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# or their #{italic}##FIREBRICK#[sprouts]#{normal}##LAST# stole from us. For #{italic}##FIREBRICK#[Father]#{normal}##LAST#'s sake, to let him #{italic}##FIREBRICK#[retire]#{normal}##LAST# again once we're #{italic}##FIREBRICK#[planted]#{normal}##LAST# once more. For everyone's sake, to avenge the #{italic}##FIREBRICK#[spilled beads]#{normal}##LAST# from the #{italic}##FIREBRICK#[brushfire]#{normal}##LAST# and bring #{italic}##FIREBRICK#[silence]#{normal}##LAST# from the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# and any #{italic}##FIREBRICK#[weeds]#{normal}##LAST# they #{italic}##FIREBRICK#[planted]#{normal}##LAST#.

(There is another panel. You touch it briefly. You hate yourself. You hate Eyal. You hate the Sher'Tul. You hate anything and everything around you. You want to destroy it, letting the souls of trillions know that justice has been done. You want to purge not just the Sher'Tul, but anything that has ever been close to them. Elves. Halflings. Orcs. Humans. All could carry their taint. All survived, while everything else that used a portal burned. If there is even a possibility that a single Sher'Tul remains on Eyal, it must be purged in blighted fire. Justice has to be done to Eyal. You remain angry at nothing in particular for ten minutes after you remove your hand.)

#{italic}##FIREBRICK#[Father]#{normal}##LAST# helped our #{italic}##FIREBRICK#[carpenters]#{normal}##LAST# make #{italic}##FIREBRICK#[power tools]#{normal}##LAST#, forms of his blessed #{italic}##FIREBRICK#[fix-it wrenches]#{normal}##LAST# which could transform us to #{italic}##FIREBRICK#[shake harder]#{normal}##LAST#. The #{italic}##FIREBRICK#[peas]#{normal}##LAST# dripped with acid, the #{italic}##FIREBRICK#[beets]#{normal}##LAST# gained tremendous speed, the #{italic}##FIREBRICK#[peppers]#{normal}##LAST# fused their hands with #{italic}##FIREBRICK#[noisy dirt]#{normal}##LAST# to sling it at those who originally #{italic}##FIREBRICK#[made the racket]#{normal}##LAST#. The #{italic}##FIREBRICK#[blooming]#{normal}##LAST# is a little #{italic}##FIREBRICK#[noisy]#{normal}##LAST#, but nothing compared to the #{italic}##FIREBRICK#[egg-weeds' screech]#{normal}##LAST#. We will either #{italic}##FIREBRICK#[be a handyman]#{normal}##LAST# or #{italic}##FIREBRICK#[wilt in the sun]#{normal}##LAST#. Press the next panel to #{italic}##FIREBRICK#[grab a toolbox]#{normal}##LAST#. Be a #{italic}##FIREBRICK#[handyman]#{normal}##LAST#.

(You know all too well what this next panel does, and memories of being chained and bound while a wretchling presses it to your forehead flash through your mind. Despite a fading compulsion, no force in Eyal could convince you to touch the panel.)
]], [[(You see here a pile of strange tablets, all piled up in a nice, orderly stack.  You remove the top one, and study it; your finger slips across a square in one corner, and strange sentences start playing through your mind. You struggle to make sense of the unfamiliar words and concepts in your thoughts.)

Many #{italic}##FIREBRICK#[moon-craters]#{normal}##LAST# after he #{italic}##FIREBRICK#[planted]#{normal}##LAST# us and #{italic}##FIREBRICK#[retired]#{normal}##LAST#, the #{italic}##FIREBRICK#[Father]#{normal}##LAST# awoke from his #{italic}##FIREBRICK#[cocoon]#{normal}##LAST# to see us #{italic}##FIREBRICK#[rattling]#{normal}##LAST#. He was shocked at our #{italic}##FIREBRICK#[wilted]#{normal}##LAST# state, asking us why we #{italic}##FIREBRICK#[rattled]#{normal}##LAST#; we told him about the #{italic}##FIREBRICK#[shaking]#{normal}##LAST# we had to suffer through, the way the planet was #{italic}##FIREBRICK#[jammed up]#{normal}##LAST# and how although our #{italic}##FIREBRICK#[peas in a pod]#{normal}##LAST# had #{italic}##FIREBRICK#[plugged the leaks]#{normal}##LAST# to keep the #{italic}##FIREBRICK#[beads]#{normal}##LAST# from #{italic}##FIREBRICK#[falling out]#{normal}##LAST#, the #{italic}##FIREBRICK#[brooms]#{normal}##LAST# kept sweeping our #{italic}##FIREBRICK#[dust bunnies]#{normal}##LAST# away, and there wasn't enough empty room to keep the #{italic}##FIREBRICK#[beads]#{normal}##LAST# from #{italic}##FIREBRICK#[cracking]#{normal}##LAST#.

(There is a larger square on the tablet here; you press your hand to it, and suddenly you see a desert planet, ravaged by constant dust-storms. You feel the futility of a short, greenish thing as he looks on his ruined crops; you feel the wrath of a red-skinned humanoid as he rushes at a large horde of small, onyx creatures, a sword in one hand and a fireball in the other. The images disappear as you remove your hand.)

#{italic}##FIREBRICK#[Father]#{normal}##LAST# gave us his #{italic}##FIREBRICK#[tools]#{normal}##LAST#, and after we #{italic}##FIREBRICK#[tripped the janitors?]#{normal}##LAST# he had us #{italic}##FIREBRICK#[shake gently?]#{normal}##LAST#, but instead of #{italic}##FIREBRICK#[rattling]#{normal}##LAST# we were #{italic}##FIREBRICK#[making music]#{normal}##LAST#, only #{italic}##FIREBRICK#[cracking]#{normal}##LAST# the #{italic}##FIREBRICK#[beads]#{normal}##LAST# that made us #{italic}##FIREBRICK#[out of tune]#{normal}##LAST#; our #{italic}##FIREBRICK#[beads]#{normal}##LAST# grew stronger, learned how to use #{italic}##FIREBRICK#[tools]#{normal}##LAST# of different #{italic}##FIREBRICK#[colors]#{normal}##LAST# than what the #{italic}##FIREBRICK#[Father]#{normal}##LAST# gave us. The #{italic}##FIREBRICK#[Father]#{normal}##LAST# loved to #{italic}##FIREBRICK#[hear our music]#{normal}##LAST#, and we were grateful he was there to #{italic}##FIREBRICK#[compose]#{normal}##LAST# for us when we needed; soon we were #{italic}##FIREBRICK#[writing our own music]#{normal}##LAST# and didn't need to #{italic}##FIREBRICK#[rattle]#{normal}##LAST# anymore, and the #{italic}##FIREBRICK#[Father]#{normal}##LAST# #{italic}##FIREBRICK#[retired]#{normal}##LAST#.

(Another larger square. You see a wonderful, loving #{italic}##FIREBRICK#[Father]#{normal}##LAST# descending on the planet, desert turning to lush forest with his touch; you worship him with your green and onyx and ruby brethren, all different shapes and sizes, united for the first time in appreciating all the good he's done for you. For the first time in ages, you know where your next meal is coming from, and you need not fear others killing you for your farmland, nor the dust storms. He holds the corpses of some reclusive earth-mages in his hand, the source of the storms; you would be angry at them, but you can only feel happiness for the future to come. You and your brethren start competing in an organized fashion, occasionally in fights again, but even when you die you know it's for the good of the planet; an age later, you and your brethren are smarter, stronger, and far happier than before, living in paradise. You remove your hand an instant later, and the feelings of worship and admiration drain from you.)

Eventually, the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# came. We tried to #{italic}##FIREBRICK#[crack their beads]#{normal}##LAST# but nothing happened; they did not try to #{italic}##FIREBRICK#[crack]#{normal}##LAST# us but instead promised us even more wonderful #{italic}##FIREBRICK#[sheet music]#{normal}##LAST# than what our #{italic}##FIREBRICK#[Father]#{normal}##LAST# had given us, under the condition that we let them #{italic}##FIREBRICK#[shatter]#{normal}##LAST# him. We refused, but we reached a #{italic}##FIREBRICK#[nasty pod]#{normal}##LAST# together; we'd #{italic}##FIREBRICK#[mute? pot?]#{normal}##LAST# the #{italic}##FIREBRICK#[Father]#{normal}##LAST# with the #{italic}##FIREBRICK#[tools]#{normal}##LAST# he gave us, leaving him a #{italic}##FIREBRICK#[lazy carpenter]#{normal}##LAST# and proving our #{italic}##FIREBRICK#[pod was shut]#{normal}##LAST# with the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST#. The #{italic}##FIREBRICK#[Father]#{normal}##LAST# wouldn't be #{italic}##FIREBRICK#[rattled or cracked]#{normal}##LAST# by this; he wouldn't even know. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# were pleased, and #{italic}##FIREBRICK#[smeared]#{normal}##LAST# their #{italic}##FIREBRICK#[eggsuckers]#{normal}##LAST# on our planet, letting us trade with #{italic}##FIREBRICK#[pods from other plants]#{normal}##LAST# from all other kinds of #{italic}##FIREBRICK#[gardens]#{normal}##LAST#. We tasted new food, learned new #{italic}##FIREBRICK#[tools]#{normal}##LAST#, and some #{italic}##FIREBRICK#[fancy]#{normal}##LAST# types of new #{italic}##FIREBRICK#[beads]#{normal}##LAST# came to our #{italic}##FIREBRICK#[garden]#{normal}##LAST#. We felt a little #{italic}##FIREBRICK#[noise]#{normal}##LAST# about our #{italic}##FIREBRICK#[Father]#{normal}##LAST#, but he was not #{italic}##FIREBRICK#[noisy]#{normal}##LAST# and wouldn't #{italic}##FIREBRICK#[hear]#{normal}##LAST# any #{italic}##FIREBRICK#[sounds]#{normal}##LAST#. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# acted as our #{italic}##FIREBRICK#[pod peas]#{normal}##LAST#, and we treated them with great #{italic}##FIREBRICK#[listening]#{normal}##LAST#, even as they #{italic}##FIREBRICK#[slipped from the pod]#{normal}##LAST# and we could no longer #{italic}##FIREBRICK#[attend each other's concerts]#{normal}##LAST#.

(You touch the panel on the next page. A creature appears before you, stepping out of a massive fortress - it has an egg-shaped body, and limbs like four #{italic}##FIREBRICK#[tendril-weeds]#{normal}##LAST#. You hate this thing with all your being, although you know you did not at the time. They say they want the #{italic}##FIREBRICK#[Father]#{normal}##LAST# dead, and can offer you great magic and technology in return; you loathe to consider the idea, but their fortresses and weapons make you wonder if their offer is truly optional. You consider waking #{italic}##FIREBRICK#[Father]#{normal}##LAST# to ask him for help, but worry that even he could not stand up to the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST#; ultimately you decided to seal him in his sleep, leaving him harmless but unharmed, unconscious until further intervention. The #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# begrudgingly accept this resolution, and keep up their end of the bargain. They give you strange, powerful artifacts, and build portals on your world that let you pass through to strange worlds, more incredible and beautiful than you could possibly imagine, and filled with other races who've been given these gifts and seek to trade. You taste new foods, learn new magic, hear new music, and discover more beauty than you have in your entire history. If not for the pangs of guilt, life could not be better. Only when you remove your hand and the images start clearing from your mind do you recognize the "egg-weeds" as the Sher'Tul.)

Then, there was great #{italic}##FIREBRICK#[noise]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It got #{italic}##FIREBRICK#[louder]#{normal}##LAST#. It was #{italic}##FIREBRICK#[eardrum-bursting]#{normal}##LAST#.

(There is another panel. You dare not touch it, but as you reach to put it away, a finger briefly brushes across it. Starvation, burning, suffocation, misery, fury, and sheer agony rage across your mind for what you know to be a tenth of a second, but feels like half a minute. Your ears are still ringing as you move on to the next square.)

The #{italic}##FIREBRICK#[eggsuckers]#{normal}##LAST# were a trap, a #{italic}##FIREBRICK#[discord]#{normal}##LAST# planted by the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# to #{italic}##FIREBRICK#[crack]#{normal}##LAST# us all, and only cause #{italic}##FIREBRICK#[hairline fracture]#{normal}##LAST# to their own #{italic}##FIREBRICK#[garden]#{normal}##LAST#. Their #{italic}##FIREBRICK#[wrong note]#{normal}##LAST# turned our planet to #{italic}##FIREBRICK#[cacophony]#{normal}##LAST#, and nearly all of us #{italic}##FIREBRICK#[fell out of the pod]#{normal}##LAST#. The #{italic}##FIREBRICK#[apple was peeled]#{normal}##LAST# and a fragment of our #{italic}##FIREBRICK#[shell]#{normal}##LAST# floated in the #{italic}##FIREBRICK#[ocean]#{normal}##LAST#. Our #{italic}##FIREBRICK#[handymen]#{normal}##LAST# acted quickly to give the #{italic}##FIREBRICK#[peel]#{normal}##LAST# and our #{italic}##FIREBRICK#[garden]#{normal}##LAST# #{italic}##FIREBRICK#[tempo]#{normal}##LAST#, and would have failed had the #{italic}##FIREBRICK#[noise]#{normal}##LAST# not woken up #{italic}##FIREBRICK#[Father]#{normal}##LAST#.

We were sorry. We were so sorry. Our #{italic}##FIREBRICK#[pod]#{normal}##LAST# was #{italic}##FIREBRICK#[rotten]#{normal}##LAST# and we knew it; we should never have #{italic}##FIREBRICK#[planted it]#{normal}##LAST#. Father forgave us for our #{italic}##FIREBRICK#[spoiled barrel]#{normal}##LAST# and #{italic}##FIREBRICK#[fertilized our garden]#{normal}##LAST#; it was still burning and #{italic}##FIREBRICK#[salted]#{normal}##LAST#, but by #{italic}##FIREBRICK#[breaking out the toolbox]#{normal}##LAST# we could still #{italic}##FIREBRICK#[plant seeds]#{normal}##LAST# on it. We could not #{italic}##FIREBRICK#[bloom]#{normal}##LAST# but we could #{italic}##FIREBRICK#[hold a note, just one note]#{normal}##LAST#. #{italic}##FIREBRICK#[Father]#{normal}##LAST# is still devoting all his will to #{italic}##FIREBRICK#[nailing our garden together]#{normal}##LAST#; it will #{italic}##FIREBRICK#[splinter and wilt]#{normal}##LAST# if he stopped for even a second. Bless the #{italic}##FIREBRICK#[Father]#{normal}##LAST# in his altruism. Bless the #{italic}##FIREBRICK#[Father]#{normal}##LAST#. We are so sorry.

(You unsteadily touch your palm to the next panel. You stand on a charred, bubbling cliff, and see a black, star-dotted expanse above and below you. Your feet are constantly searing; the mages could give you oxygen and convert ambient magic into caloric energy, but they couldn't undo the terrible magical flames that rage on the blown-off continent, or the eternal pyre of your former planet. Nearly everyone you know is dead, and your scryers tell you the home of the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# has suffered only minor damage; all the others you've contacted through portals were blown apart instantly. Your home only survives from the constant effort and concentration of #{italic}##FIREBRICK#[Father]#{normal}##LAST#, who is exerting every bit of magic he can to keep the shattered fragments from spinning off into the void. There is no part of you that does not feel deep regret; you would commit suicide if you did not hope there was a way you could apologize to #{italic}##FIREBRICK#[Father]#{normal}##LAST#, work as tirelessly and selflessly as he is. The regret drains as your hand leaves the panel.)

We asked #{italic}##FIREBRICK#[Father]#{normal}##LAST# what #{italic}##FIREBRICK#[song to sing]#{normal}##LAST# to #{italic}##FIREBRICK#[make him dance]#{normal}##LAST# again. He told us: #{italic}##FIREBRICK#[rattle]#{normal}##LAST# the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# until their every last #{italic}##FIREBRICK#[bead falls out]#{normal}##LAST#. We know our #{italic}##FIREBRICK#[orchestra hall]#{normal}##LAST#, and we will #{italic}##FIREBRICK#[crash the party]#{normal}##LAST#. For our sake, giving us a new #{italic}##FIREBRICK#[garden]#{normal}##LAST# to replace the one the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# or their #{italic}##FIREBRICK#[sprouts]#{normal}##LAST# stole from us. For #{italic}##FIREBRICK#[Father]#{normal}##LAST#'s sake, to let him #{italic}##FIREBRICK#[retire]#{normal}##LAST# again once we're #{italic}##FIREBRICK#[planted]#{normal}##LAST# once more. For everyone's sake, to avenge the #{italic}##FIREBRICK#[spilled beads]#{normal}##LAST# from the #{italic}##FIREBRICK#[brushfire]#{normal}##LAST# and bring #{italic}##FIREBRICK#[silence]#{normal}##LAST# from the #{italic}##FIREBRICK#[egg-weeds]#{normal}##LAST# and any #{italic}##FIREBRICK#[weeds]#{normal}##LAST# they #{italic}##FIREBRICK#[planted]#{normal}##LAST#.

(There is another panel. You touch it briefly. You hate yourself. You hate Eyal. You hate the Sher'Tul. You hate anything and everything around you. You want to destroy it, letting the souls of trillions know that justice has been done. You want to purge not just the Sher'Tul, but anything that has ever been close to them. Elves. Halflings. Orcs. Humans. All could carry their taint. All survived, while everything else that used a portal burned. If there is even a possibility that a single Sher'Tul remains on Eyal, it must be purged in blighted fire. Justice has to be done to Eyal. You remain angry at nothing in particular for ten minutes after you remove your hand.)

#{italic}##FIREBRICK#[Father]#{normal}##LAST# helped our #{italic}##FIREBRICK#[carpenters]#{normal}##LAST# make #{italic}##FIREBRICK#[power tools]#{normal}##LAST#, forms of his blessed #{italic}##FIREBRICK#[fix-it wrenches]#{normal}##LAST# which could transform us to #{italic}##FIREBRICK#[shake harder]#{normal}##LAST#. The #{italic}##FIREBRICK#[peas]#{normal}##LAST# dripped with acid, the #{italic}##FIREBRICK#[beets]#{normal}##LAST# gained tremendous speed, the #{italic}##FIREBRICK#[peppers]#{normal}##LAST# fused their hands with #{italic}##FIREBRICK#[noisy dirt]#{normal}##LAST# to sling it at those who originally #{italic}##FIREBRICK#[made the racket]#{normal}##LAST#. The #{italic}##FIREBRICK#[blooming]#{normal}##LAST# is a little #{italic}##FIREBRICK#[noisy]#{normal}##LAST#, but nothing compared to the #{italic}##FIREBRICK#[egg-weeds' screech]#{normal}##LAST#. We will either #{italic}##FIREBRICK#[be a handyman]#{normal}##LAST# or #{italic}##FIREBRICK#[wilt in the sun]#{normal}##LAST#. Press the next panel to #{italic}##FIREBRICK#[grab a toolbox]#{normal}##LAST#. Be a #{italic}##FIREBRICK#[handyman]#{normal}##LAST#.

(You know all too well what this next panel does, and memories of being chained and bound while a wretchling presses it to your forehead flash through your mind. Despite a fading compulsion, no force in Eyal could convince you to touch the panel.)
]], "_t")
t("history of Mal'Rok (1)", "history of Mal'Rok (1)", "_t")
t([[First, we were created by our Father, Urh'Rok. Then, many years later, we were in the desert, struggling and fighting each other for the few meager scraps of usable farmland. We do not know anything between these times; our cities, our culture, everything was wiped out by the dust storms. The storms hated us, toyed with us, subsided just long enough for us to raise armies and fight, then raged again the moment peace came. They wanted us to fight. They wanted us to struggle, suffer, die, leaving a few survivors to repopulate, and repeat the process. Green, onyx, red, all brothers who should have been allies, we fought at first because we had to, then because we could, then because we knew it was the only thing that kept the storms entertained.

Eventually, Urh'Rok appeared and told us he had been sealed away, prevented from helping us by people who had been creating the dust storms. Their cities lay hidden among us, shrouded in powerful magic to remain invisible. With a touch, he wiped the storms clean and turned the desert into lush jungle, filled with food. The storms appeared again, weaker this time; Urh'Rok grew furious and shattered the glass cities, reaching into one and pulling out a fistful of sadistic mages. He fed them to us - it was the best, largest feast any of us had eaten in millennia, and it was truly delicious. He did this to all the dust-mages' cities, then declared that we would never have to fear the storms again. We celebrated and worshiped our returned god - thanks to him, we knew where our next meal was coming from, and we had no reason to fight. All of us brethren dropped our weapons and hugged, forgiving each other for the assaults we knew we'd only done from fear. We loved each other, and we loved our god.

Our father began to fret, however. We were supposed to have grown more as species; our squabbling in the desert had stunted our growth, left us behind the curve. He set up a series of competitions and tournaments in all fields of life - magic, combat, negotiation - on a planetary scale. We were used to fighting by now, and now that we knew it was actually accomplishing something, now that we were pleasing an altruistic god, we did not mind it one bit. Those who died did so with smiles on their faces, knowing they'd contributed another data-point to our Father's plan. The weaker members of our many species willingly died off, and we all grew stronger, smarter, and happier as a result. Soon, we were grown enough to organize our own tournaments, and apply the findings to our societies and species; Father said he was pleased with us, and wanted us to determine our own destiny while he slept, recovering from all the work he'd just done. We continued our process of self-improvement - we wanted Father to be proud of us when he woke up.

Then, the Sher'Tul came.
]], [[First, we were created by our Father, Urh'Rok. Then, many years later, we were in the desert, struggling and fighting each other for the few meager scraps of usable farmland. We do not know anything between these times; our cities, our culture, everything was wiped out by the dust storms. The storms hated us, toyed with us, subsided just long enough for us to raise armies and fight, then raged again the moment peace came. They wanted us to fight. They wanted us to struggle, suffer, die, leaving a few survivors to repopulate, and repeat the process. Green, onyx, red, all brothers who should have been allies, we fought at first because we had to, then because we could, then because we knew it was the only thing that kept the storms entertained.

Eventually, Urh'Rok appeared and told us he had been sealed away, prevented from helping us by people who had been creating the dust storms. Their cities lay hidden among us, shrouded in powerful magic to remain invisible. With a touch, he wiped the storms clean and turned the desert into lush jungle, filled with food. The storms appeared again, weaker this time; Urh'Rok grew furious and shattered the glass cities, reaching into one and pulling out a fistful of sadistic mages. He fed them to us - it was the best, largest feast any of us had eaten in millennia, and it was truly delicious. He did this to all the dust-mages' cities, then declared that we would never have to fear the storms again. We celebrated and worshiped our returned god - thanks to him, we knew where our next meal was coming from, and we had no reason to fight. All of us brethren dropped our weapons and hugged, forgiving each other for the assaults we knew we'd only done from fear. We loved each other, and we loved our god.

Our father began to fret, however. We were supposed to have grown more as species; our squabbling in the desert had stunted our growth, left us behind the curve. He set up a series of competitions and tournaments in all fields of life - magic, combat, negotiation - on a planetary scale. We were used to fighting by now, and now that we knew it was actually accomplishing something, now that we were pleasing an altruistic god, we did not mind it one bit. Those who died did so with smiles on their faces, knowing they'd contributed another data-point to our Father's plan. The weaker members of our many species willingly died off, and we all grew stronger, smarter, and happier as a result. Soon, we were grown enough to organize our own tournaments, and apply the findings to our societies and species; Father said he was pleased with us, and wanted us to determine our own destiny while he slept, recovering from all the work he'd just done. We continued our process of self-improvement - we wanted Father to be proud of us when he woke up.

Then, the Sher'Tul came.
]], "_t")
t("history of Mal'Rok (2)", "history of Mal'Rok (2)", "_t")
t([[They arrived in enormous flying fortresses, bristling with weapons and overflowing with magic. They did not directly threaten us, but they met with our leaders and gave us what was either an offer or an ultimatum: let them kill our Father, or kill him ourselves, and be rewarded with technology and magic as grand as theirs.

They were powerful - very powerful. Although their proposal was phrased as a generous offer, we could not help but notice that their fortresses had positioned themselves over our armories and population centers, and none of their fortresses were unarmed. We did not think we could fight them; we considered waking Father for help, but we weren't sure he could fight them either. In desperation, we met and devised a plan: we would seal Urh'Rok away, prevent him from waking up unless disturbed, and then tell the Sher'Tul what we had done. Father would not be hurt or injured by this - he simply wouldn't know what was going on.

We did this, and came to the Sher'Tul. They begrudgingly accepted our treacherous act as a pledge of loyalty to them, and came through with their end of the bargain, giving us knowledge and artifacts beyond our wildest dreams. They built powerful portals all over our planet, allowing us to travel through them not only within our world, but within every world the Sher'Tul had visited before. We saw wonderful new worlds, met and traded with peaceful species from across the universe, enjoyed all kinds of new, alien food, music, magic, and inventions, and generally could not have been happier with how things turned out - if not for the pangs of guilt we felt for betraying our Father. The Sher'Tul eventually stopped visiting us, but we kept trading with new people we met through the portal, and did not notice their absence.

Then everything broke.
]], [[They arrived in enormous flying fortresses, bristling with weapons and overflowing with magic. They did not directly threaten us, but they met with our leaders and gave us what was either an offer or an ultimatum: let them kill our Father, or kill him ourselves, and be rewarded with technology and magic as grand as theirs.

They were powerful - very powerful. Although their proposal was phrased as a generous offer, we could not help but notice that their fortresses had positioned themselves over our armories and population centers, and none of their fortresses were unarmed. We did not think we could fight them; we considered waking Father for help, but we weren't sure he could fight them either. In desperation, we met and devised a plan: we would seal Urh'Rok away, prevent him from waking up unless disturbed, and then tell the Sher'Tul what we had done. Father would not be hurt or injured by this - he simply wouldn't know what was going on.

We did this, and came to the Sher'Tul. They begrudgingly accepted our treacherous act as a pledge of loyalty to them, and came through with their end of the bargain, giving us knowledge and artifacts beyond our wildest dreams. They built powerful portals all over our planet, allowing us to travel through them not only within our world, but within every world the Sher'Tul had visited before. We saw wonderful new worlds, met and traded with peaceful species from across the universe, enjoyed all kinds of new, alien food, music, magic, and inventions, and generally could not have been happier with how things turned out - if not for the pangs of guilt we felt for betraying our Father. The Sher'Tul eventually stopped visiting us, but we kept trading with new people we met through the portal, and did not notice their absence.

Then everything broke.
]], "_t")
t("history of Mal'Rok (3)", "history of Mal'Rok (3)", "_t")
t([[Waves of terrible magic burst forth from the portals, which it's now clear were never intended to help us. They were a deadly trap, a ticking time bomb that would go off when the Sher'Tul wanted it to - and it went off with incredible force. Most of the worlds we had once visited were obliterated completely. Ours was not, but I can barely say we were "spared"; our Father's jungles turned to a cursed pyre instantly, burning with flame that could never be extinguished, and our planet cracked apart, whole continents flying into the void. What little land was left obviously couldn't be used for farming. Most of us died instantly, the survivors being those close enough to a skilled mage who could create enough oxygen to breathe, and convert ambient magic into caloric energy for our bodies. Life for the survivors was - is - endless torment, the burning ground constantly searing our feet, and all the beauty we once knew destroyed.

Fortunately, this woke our Father up. We confessed our treachery, but did not beg forgiveness, as we knew what we had done was unforgivable; he disagreed, and to this day is using nearly every shred of his power to keep the shattered fragments of our planet together. We were not satisfied with this fate, our Father suffering and exhausting himself for the sake of our mistakes. We begged him to give us a command, something we could do to help his situation, or at least make him happier about it.

His command: End the Sher'Tul. End their creations. Never let anything be hurt by Eyal again.

We have taken his words to heart. Our mages have devised new magic from old inspiration, alteration spells to make us warlike and brutal once more - but with our ascended minds and honed bodies, we shall be a force of destruction far greater than the dust-storms ever were. Our green bretheren underwent a process to make their skin drip with acid; not to be outdone, our onyx brethren grew faster and stronger, with a birth-rate high enough to overwhelm whatever Sher'Tul or Sher'Tul-made monsters lay on Eyal. The red ones proclaimed they now existed only to destroy, and fused bits of the burnt earth to their hands, leaving them unable to do anything but sear Eyal with its own fires. The finished results of these alterations have taken up residence on our largest drifting continent, the one drawing ever closer to Eyal.

Once this continent arrives, we shall take revenge on Eyal. Not just for our own sakes, our planet ravaged by their treachery, with a pristine one waiting as our prize. Not just for our Father's sake, condemned to an eternity of suffering for trusting his children too much. But for *everyone's* sake, the untold trillions of souls on planets less fortunate than ours, torn apart in a fiery instant. The Sher'Tul shall never hurt anyone again; we shall make sure of it by cleansing Eyal in blighted fire, and any survivors will be taken back to our planet and chained to the burning earth, kept alive so they can forever feel the flames they created consuming their flesh. Their eternal torture will still not be justice, as they shall feel only a tiny portion of the suffering they inflicted... but it's a start.
]], [[Waves of terrible magic burst forth from the portals, which it's now clear were never intended to help us. They were a deadly trap, a ticking time bomb that would go off when the Sher'Tul wanted it to - and it went off with incredible force. Most of the worlds we had once visited were obliterated completely. Ours was not, but I can barely say we were "spared"; our Father's jungles turned to a cursed pyre instantly, burning with flame that could never be extinguished, and our planet cracked apart, whole continents flying into the void. What little land was left obviously couldn't be used for farming. Most of us died instantly, the survivors being those close enough to a skilled mage who could create enough oxygen to breathe, and convert ambient magic into caloric energy for our bodies. Life for the survivors was - is - endless torment, the burning ground constantly searing our feet, and all the beauty we once knew destroyed.

Fortunately, this woke our Father up. We confessed our treachery, but did not beg forgiveness, as we knew what we had done was unforgivable; he disagreed, and to this day is using nearly every shred of his power to keep the shattered fragments of our planet together. We were not satisfied with this fate, our Father suffering and exhausting himself for the sake of our mistakes. We begged him to give us a command, something we could do to help his situation, or at least make him happier about it.

His command: End the Sher'Tul. End their creations. Never let anything be hurt by Eyal again.

We have taken his words to heart. Our mages have devised new magic from old inspiration, alteration spells to make us warlike and brutal once more - but with our ascended minds and honed bodies, we shall be a force of destruction far greater than the dust-storms ever were. Our green bretheren underwent a process to make their skin drip with acid; not to be outdone, our onyx brethren grew faster and stronger, with a birth-rate high enough to overwhelm whatever Sher'Tul or Sher'Tul-made monsters lay on Eyal. The red ones proclaimed they now existed only to destroy, and fused bits of the burnt earth to their hands, leaving them unable to do anything but sear Eyal with its own fires. The finished results of these alterations have taken up residence on our largest drifting continent, the one drawing ever closer to Eyal.

Once this continent arrives, we shall take revenge on Eyal. Not just for our own sakes, our planet ravaged by their treachery, with a pristine one waiting as our prize. Not just for our Father's sake, condemned to an eternity of suffering for trusting his children too much. But for *everyone's* sake, the untold trillions of souls on planets less fortunate than ours, torn apart in a fiery instant. The Sher'Tul shall never hurt anyone again; we shall make sure of it by cleansing Eyal in blighted fire, and any survivors will be taken back to our planet and chained to the burning earth, kept alive so they can forever feel the flames they created consuming their flesh. Their eternal torture will still not be justice, as they shall feel only a tiny portion of the suffering they inflicted... but it's a start.
]], "_t")
t("Lost Memories (1)", "Lost Memories (1)", "_t")
t([[#{italic}#You clutch your head.  Entering this next floor, memories of your imprisonment flood back to you...#{normal}#

"All right, bring in the next one," says the ruby-skinned leader.  A few small, green and black things mop up the pile of muck that used to be a dwarf, and you move to the front of the line and stand where he used to be.  On the other side of the room, another <?=_t(player.descriptor.subrace)?> stands on an identical platform.  This is exciting - you've been specially chosen as a test subject!  You hope you help them find something effective AND agonizing, and look forward to the pain to come.  A green imp, a little more mutated and knobbly than the rest you've seen, stands on your side of the room and grins at you with anticipation;  on the other side, a more normal imp approaches your counterpart.  "Control group...  go."  The normal wretchling leaps on the <?=_t(player.descriptor.subrace)?>'s face, clutching it tight as a torrent of acid oozes from its skin, then lets go; the red imp looks at his melting flesh, jots down some notes, then mutters "and pain blocks off..."  The <?=_t(player.descriptor.subrace)?>'s smile vanishes, and he clutches his face, then lets out a howling scream, collapses, and begins writhing on the floor.  The red imp looks down again, gives a bored sigh, and takes some more notes.  "That's enough, pain blocks on, patch him up."  The <?=_t(player.descriptor.subrace)?> stops moving, stands up, and smiles again, the acid continuing to eat away at his flesh until a pipe in the floor douses him with some sort of chemical.  Another red imp mutters something and waves his hands before taking his hand and leading him off, and you see his horrible wounds gradually healing.

"Experimental group...  go."  With speed you can't even process until it's already on you, the mutant wretchling leaps onto your face.  You feel no pain as its acid leaks over your torso, although you do feel an odd sensation of your skin layers beginning to dissolve.  The imp leaps off again; apparently it missed your eyes, because you can see the red imp looking somewhat disappointed.  "Structural damage subpar...  okay, pain blocks off."  You know you're not supposed to scream during this next part.

You scream.  You scream harder than you have in your life, to the point where you think you might be tearing your vocal cords apart.  The pain is stronger not just than any pain you've ever felt, but any sensation you've ever felt.  You fall to the ground and claw at your skin, tearing off bits of it as you try to get the acid off.  You struggle and flail, instinctively grabbing at anything that could help you even though you know there's nothing in reach that could.

"All right, nice!  Pain blocks on!"  And just like that, the pain vanishes; your skin still bubbles, but that horrible pain is gone, and even your throat isn't sore.  "Clean him and patch him up.  Pain-amplifying qualities...  significant improvement...  recommend breeding with low-pain high-corrosion specimens."  A shower of unidentifiable goo washes over you, and your skin stops bubbling; your handler takes your arm and leads you away, muttering a healing spell under his breath, and your scars slowly start to fade into smooth skin once again.  You hope they aren't too harsh on you for screaming, but the way that imp spoke...  you must've helped them learn something!  You grin from ear to ear as you leave the room, hearing the red imp yell "Next!" as the door closes behind you.

#{italic}#You shudder.#{normal}#
]], [[#{italic}#You clutch your head.  Entering this next floor, memories of your imprisonment flood back to you...#{normal}#

"All right, bring in the next one," says the ruby-skinned leader.  A few small, green and black things mop up the pile of muck that used to be a dwarf, and you move to the front of the line and stand where he used to be.  On the other side of the room, another <?=_t(player.descriptor.subrace)?> stands on an identical platform.  This is exciting - you've been specially chosen as a test subject!  You hope you help them find something effective AND agonizing, and look forward to the pain to come.  A green imp, a little more mutated and knobbly than the rest you've seen, stands on your side of the room and grins at you with anticipation;  on the other side, a more normal imp approaches your counterpart.  "Control group...  go."  The normal wretchling leaps on the <?=_t(player.descriptor.subrace)?>'s face, clutching it tight as a torrent of acid oozes from its skin, then lets go; the red imp looks at his melting flesh, jots down some notes, then mutters "and pain blocks off..."  The <?=_t(player.descriptor.subrace)?>'s smile vanishes, and he clutches his face, then lets out a howling scream, collapses, and begins writhing on the floor.  The red imp looks down again, gives a bored sigh, and takes some more notes.  "That's enough, pain blocks on, patch him up."  The <?=_t(player.descriptor.subrace)?> stops moving, stands up, and smiles again, the acid continuing to eat away at his flesh until a pipe in the floor douses him with some sort of chemical.  Another red imp mutters something and waves his hands before taking his hand and leading him off, and you see his horrible wounds gradually healing.

"Experimental group...  go."  With speed you can't even process until it's already on you, the mutant wretchling leaps onto your face.  You feel no pain as its acid leaks over your torso, although you do feel an odd sensation of your skin layers beginning to dissolve.  The imp leaps off again; apparently it missed your eyes, because you can see the red imp looking somewhat disappointed.  "Structural damage subpar...  okay, pain blocks off."  You know you're not supposed to scream during this next part.

You scream.  You scream harder than you have in your life, to the point where you think you might be tearing your vocal cords apart.  The pain is stronger not just than any pain you've ever felt, but any sensation you've ever felt.  You fall to the ground and claw at your skin, tearing off bits of it as you try to get the acid off.  You struggle and flail, instinctively grabbing at anything that could help you even though you know there's nothing in reach that could.

"All right, nice!  Pain blocks on!"  And just like that, the pain vanishes; your skin still bubbles, but that horrible pain is gone, and even your throat isn't sore.  "Clean him and patch him up.  Pain-amplifying qualities...  significant improvement...  recommend breeding with low-pain high-corrosion specimens."  A shower of unidentifiable goo washes over you, and your skin stops bubbling; your handler takes your arm and leads you away, muttering a healing spell under his breath, and your scars slowly start to fade into smooth skin once again.  You hope they aren't too harsh on you for screaming, but the way that imp spoke...  you must've helped them learn something!  You grin from ear to ear as you leave the room, hearing the red imp yell "Next!" as the door closes behind you.

#{italic}#You shudder.#{normal}#
]], "_t")
t("Lost Memories (2)", "Lost Memories (2)", "_t")
t([[#{italic}#More memories rush into your mind...#{normal}#

"It's your lucky day, <?=player.name?>," your handler says as he leads you to a large, glowing crystal.  "You're too cooperative to stay in testing any longer.  Today, you're getting promoted to research assistant!"  You're nearly beside yourself with joy!  "Now, we'll need to do a short little process first.  Fireproofing wards here, loyalty reinforcement there, standard-issue alteration, but mostly just linking your consciousness to this," he says, pointing to the crystal.  "With this thing, everything you see, hear, smell, taste, or feel gets fed directly into this little ol' beauty.  Not just that, either - whereever you go, and whatever you think, we'll have it saved for future reference."  You're going to help them learn so much!  "Just step on the plate here, and hold your arms like this so I can get the bindings in place..."

That crystal.  That crystal is how they're keeping track of you, and it has most of what you helped them discover trapped within it.  If you break it, you'll be able to escape their notice for the first time since you arrived here, allowing you to get away without them finding you again, and as an added bonus you'll undo most of what you helped them accomplish.  You need to destroy it, then flee for your life!]], [[#{italic}#More memories rush into your mind...#{normal}#

"It's your lucky day, <?=player.name?>," your handler says as he leads you to a large, glowing crystal.  "You're too cooperative to stay in testing any longer.  Today, you're getting promoted to research assistant!"  You're nearly beside yourself with joy!  "Now, we'll need to do a short little process first.  Fireproofing wards here, loyalty reinforcement there, standard-issue alteration, but mostly just linking your consciousness to this," he says, pointing to the crystal.  "With this thing, everything you see, hear, smell, taste, or feel gets fed directly into this little ol' beauty.  Not just that, either - whereever you go, and whatever you think, we'll have it saved for future reference."  You're going to help them learn so much!  "Just step on the plate here, and hold your arms like this so I can get the bindings in place..."

That crystal.  That crystal is how they're keeping track of you, and it has most of what you helped them discover trapped within it.  If you break it, you'll be able to escape their notice for the first time since you arrived here, allowing you to get away without them finding you again, and as an added bonus you'll undo most of what you helped them accomplish.  You need to destroy it, then flee for your life!]], "_t")
t("orbital base: battle plan (doombringer)", "orbital base: battle plan (doombringer)", "_t")
t([[Engagement Briefing on <?=player.name?>:

This slippery little <?=_t(player.descriptor.subrace)?> has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  Having been exposed to our alteration magic, <?=player:he_she()?> is very formidable in direct melee combat, and in the event that we cannot procure proper warding against this magic before <?=player:his_her()?> arrival, <?=player:he_she()?> can cause significant damage if not properly handled.  Under no circumstances should we let <?=player:him_her()?> run rampant in our back line; furthermore, if we simply try to lure <?=player:him_her()?> into a narrow corridor, we will not be able to bring enough firepower to bear before <?=player:he_she()?> can break through our obstructions.  Instead, use a small flanking squad backed up by a maulotaur (or whatever high-power direct combatant we can get authorization to deploy) to force <?=player:him_her()?> into an open area, where we'll have caster artillery, protected by a front-line of wretchlings backed by quasits.  We may lose these front-line soldiers, but in the time it takes <?=player:him_her()?> to slash <?=player:his_her()?> way through them, our spells should be able to reduce <?=player:him_her()?> to a flayed, quivering wreck.

Above all else, remember: despite <?=player:his_her()?> brute strength, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.
]], [[Engagement Briefing on <?=player.name?>:

This slippery little <?=_t(player.descriptor.subrace)?> has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  Having been exposed to our alteration magic, <?=player:he_she()?> is very formidable in direct melee combat, and in the event that we cannot procure proper warding against this magic before <?=player:his_her()?> arrival, <?=player:he_she()?> can cause significant damage if not properly handled.  Under no circumstances should we let <?=player:him_her()?> run rampant in our back line; furthermore, if we simply try to lure <?=player:him_her()?> into a narrow corridor, we will not be able to bring enough firepower to bear before <?=player:he_she()?> can break through our obstructions.  Instead, use a small flanking squad backed up by a maulotaur (or whatever high-power direct combatant we can get authorization to deploy) to force <?=player:him_her()?> into an open area, where we'll have caster artillery, protected by a front-line of wretchlings backed by quasits.  We may lose these front-line soldiers, but in the time it takes <?=player:him_her()?> to slash <?=player:his_her()?> way through them, our spells should be able to reduce <?=player:him_her()?> to a flayed, quivering wreck.

Above all else, remember: despite <?=player:his_her()?> brute strength, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.
]], "_t")
t("orbital base: battle plan (demonologist)", "orbital base: battle plan (demonologist)", "_t")
t([[Engagement Briefing on <?=player.name?>:

This slippery little <?=_t(player.descriptor.subrace)?> has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  We've heard disturbing reports that some of our species have been spotted fighting alongside <?=player:him_her()?>; we can assume that <?=player:he_she()?> is using a twisted version of the Tablet's power to enslave some of our forces.  Much of <?=player:his_her()?> combat potential comes from these thralls, rather than <?=player:his_her()?> own abilities.  Accordingly, there are three things to keep in mind:

-Prioritize the Eyalite, rather than <?=player:his_her()?> thralls.  We do not yet have a concrete understanding of how <?=player:he_she()?> is controlling our allies, but it seems likely that the mental hold will break once <?=player:he_she()?>'s incapacitated; if <?=player:he_she()?> has managed to take control of a Champion of Urh'Rok or similarly powerful agent, we should focus our firepower on <?=player:him_her()?> instead.  That said, neutralizing <?=player:him_her()?> is more important than saving the time and effort of producing such a creature; in particular, don't worry about catching a few enthralled imps in the crossfire.  No matter what <?=player:he_she()?>'s using, we can make more of it.

-Be ready for anything.  We've never needed to plan out what to do against our own powers, and we have such a diverse set of species that <?=player:he_she()?> could throw all kinds of magic or martial prowess against us.  This might sound hopeless, but remember: you've seen all this in action before, these powers being used alongside yours in training and in combat.  Whatever you've seen your comrades do, expect to see it from <?=player:him_her()?>.

-Do not assume that the onslaught will stop if all of <?=player:his_her()?> thralls are dead.  <?=player:he_she():capitalize()?> has managed to directly imbue <?=player:his_her_self()?> with some of our magic, and may be capable of using our fireballs, acidic bursts, and so forth.  Silencing magic will be helpful here, as will spells that can drain <?=player:his_her()?> energy; furthermore, ripping away <?=player:his_her()?> shield will make <?=player:him_her()?> especially vulnerable to our claws and axes.

Above all else, remember: despite <?=player:his_her()?> enthralled minions, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.
]], [[Engagement Briefing on <?=player.name?>:

This slippery little <?=_t(player.descriptor.subrace)?> has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  We've heard disturbing reports that some of our species have been spotted fighting alongside <?=player:him_her()?>; we can assume that <?=player:he_she()?> is using a twisted version of the Tablet's power to enslave some of our forces.  Much of <?=player:his_her()?> combat potential comes from these thralls, rather than <?=player:his_her()?> own abilities.  Accordingly, there are three things to keep in mind:

-Prioritize the Eyalite, rather than <?=player:his_her()?> thralls.  We do not yet have a concrete understanding of how <?=player:he_she()?> is controlling our allies, but it seems likely that the mental hold will break once <?=player:he_she()?>'s incapacitated; if <?=player:he_she()?> has managed to take control of a Champion of Urh'Rok or similarly powerful agent, we should focus our firepower on <?=player:him_her()?> instead.  That said, neutralizing <?=player:him_her()?> is more important than saving the time and effort of producing such a creature; in particular, don't worry about catching a few enthralled imps in the crossfire.  No matter what <?=player:he_she()?>'s using, we can make more of it.

-Be ready for anything.  We've never needed to plan out what to do against our own powers, and we have such a diverse set of species that <?=player:he_she()?> could throw all kinds of magic or martial prowess against us.  This might sound hopeless, but remember: you've seen all this in action before, these powers being used alongside yours in training and in combat.  Whatever you've seen your comrades do, expect to see it from <?=player:him_her()?>.

-Do not assume that the onslaught will stop if all of <?=player:his_her()?> thralls are dead.  <?=player:he_she():capitalize()?> has managed to directly imbue <?=player:his_her_self()?> with some of our magic, and may be capable of using our fireballs, acidic bursts, and so forth.  Silencing magic will be helpful here, as will spells that can drain <?=player:his_her()?> energy; furthermore, ripping away <?=player:his_her()?> shield will make <?=player:him_her()?> especially vulnerable to our claws and axes.

Above all else, remember: despite <?=player:his_her()?> enthralled minions, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.
]], "_t")
t("orbital base: battle plan (doomelf)", "orbital base: battle plan (doomelf)", "_t")
t([[Engagement Briefing on <?=player.name?>:

This slippery little elf has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  Our standard alterations have synergized with this Shalore's natural reactive magic, giving <?=player:him_her()?> short-range teleportation to rival Draebor and creating a frustratingly evasive target to hit.  Even <?=player:his_her()?> internal organs are affected, and will slide out of the way in anticipation of a blow that would strike an otherwise-vital area.  Compared to standard Shalore, <?=player:he_she()?> cannot directly turn invisible, but seems to have adopted a form of dúathedlen magic to remain out of sight all the same; if the requisition order for light-based wards goes through, this and the blasts of darkness this form grants should both be a non-issue.  Finally, use of more advanced combat maneuvers will be somewhat impeded by <?=player:his_her()?> ability to interfere with our concentration, and the resilience alterations we gave <?=player:him_her()?> will make <?=player:him_her()?> shrug off poisons, flames, and the like much quicker than usual.

What does all this mean?  Just get <?=player:him_her()?> wounded, wait for <?=player:him_her()?> to try to teleport away, then get <?=player:him_her()?> in a corner and beat <?=player:him_her()?> until <?=player:he_she()?> stops moving.  It's really that simple.  Just work that into our standard methods of dealing with <?=string.a_an(_t(player.descriptor.subclass):lower())?>, remember not to break ranks if <?=player:he_she()?> vanishes into darkness, and we'll have this mess cleaned up in no time.

Above all else, remember: despite <?=player:his_her()?> enhancements, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.

]], [[Engagement Briefing on <?=player.name?>:

This slippery little elf has proven to be a thorn in our side so far.  We've reinforced our wards to better protect against the sort of fluke meteor impact that enabled <?=player:his_her()?> escape, but the crystal <?=player:he_she()?> smashed on <?=player:his_her()?> way out prevented us from keeping track of <?=player:his_her()?> location directly.  No matter - the brands and marks we've imbued <?=player:him_her()?> with have nonetheless allowed us to monitor magical energy signals affecting <?=player:him_her()?>, and our scryers have noted that there appears to be a particular pattern that teleports <?=player:him_her()?>, possibly of Sher'Tul origin.  We've sent out a signal of our own to intercept this, and redirect it to our platform, where <?=player:he_she()?> will be safely secured, punished for <?=player:his_her()?> disobedience, then once again exposed to a Tablet of Enlightenment to regain <?=player:his_her()?> servitude.

That said, given that <?=player:he_she()?> has increased dramatically in power since <?=player:his_her()?> escape, it is crucial that we keep proper tactics in mind.  Our standard alterations have synergized with this Shalore's natural reactive magic, giving <?=player:him_her()?> short-range teleportation to rival Draebor and creating a frustratingly evasive target to hit.  Even <?=player:his_her()?> internal organs are affected, and will slide out of the way in anticipation of a blow that would strike an otherwise-vital area.  Compared to standard Shalore, <?=player:he_she()?> cannot directly turn invisible, but seems to have adopted a form of dúathedlen magic to remain out of sight all the same; if the requisition order for light-based wards goes through, this and the blasts of darkness this form grants should both be a non-issue.  Finally, use of more advanced combat maneuvers will be somewhat impeded by <?=player:his_her()?> ability to interfere with our concentration, and the resilience alterations we gave <?=player:him_her()?> will make <?=player:him_her()?> shrug off poisons, flames, and the like much quicker than usual.

What does all this mean?  Just get <?=player:him_her()?> wounded, wait for <?=player:him_her()?> to try to teleport away, then get <?=player:him_her()?> in a corner and beat <?=player:him_her()?> until <?=player:he_she()?> stops moving.  It's really that simple.  Just work that into our standard methods of dealing with <?=string.a_an(_t(player.descriptor.subclass):lower())?>, remember not to break ranks if <?=player:he_she()?> vanishes into darkness, and we'll have this mess cleaned up in no time.

Above all else, remember: despite <?=player:his_her()?> enhancements, this is a pitiful, inferior Eyalite who lucked <?=player:his_her()?> way into obtaining some of our superior power.  <?=player:he_she():capitalize()?> does not know how to use it properly, and does not have the countless years of experience with it that we do.  We have numbers, familiarity, tactics, and the blessing of Urh'Rok himself.  Treat this like a drill; if we stay calm and focused, it is unlikely we will see any casualties.

]], "_t")
t("orbital base: battle info", "orbital base: battle info", "_t")
t([[#{italic}#This note is splattered with the blood of the demon who was carrying it.#{normal}#

#{bold}#URGENT:#{normal}#

Operation to secure <?=player.name?> failure.  Primary defense force routed, secondary team taking heavy casualties.  All is lost.  Highest priority is now containing <?=player.name?> to prevent further damage.  Blow all connectors, break platform off the continent and dispel oxygenation wards befo--

#{italic}#The last O trails off, a line leading from it to the end of the page like the pen was rapidly jerked away.  You must have interrupted this demon's writing.#{normal}#
]], [[#{italic}#This note is splattered with the blood of the demon who was carrying it.#{normal}#

#{bold}#URGENT:#{normal}#

Operation to secure <?=player.name?> failure.  Primary defense force routed, secondary team taking heavy casualties.  All is lost.  Highest priority is now containing <?=player.name?> to prevent further damage.  Blow all connectors, break platform off the continent and dispel oxygenation wards befo--

#{italic}#The last O trails off, a line leading from it to the end of the page like the pen was rapidly jerked away.  You must have interrupted this demon's writing.#{normal}#
]], "_t")
t("orbital base: battle info with #{bold}#a badass#{normal}#", "orbital base: battle info with #{bold}#a badass#{normal}#", "_t")
t([[#{italic}#This note is stained with what appear to be motorcycle tire-tracks.#{normal}#

#{bold}#URGENT:#{normal}#

Operation to secure <?=player.name?> failure.  Primary defense force routed by target's overwhelming badassery, secondary team presumed dead (reports inaudible over sound of face-melting guitar solos).  All is lost.  Totally worth it.  Highest priority is now isolating <?=player.name?>, building a stadium around <?=player:him_her()?>, and selling tickets to spectacle of badassery.  Blow all connectors, break platform off the continent, prepare pyrotechnics, and set up spotlights and speaker systems befo--

#{italic}#The last O trails off, a line leading from it to the end of the page like the pen was rapidly jerked away, then leads to a doodle depicting you, wielding a double-bladed katana and fighting a giant construct labelled "Ninja Atamathon."  Your badassery must have interrupted this demon's writing.#{normal}#
]], [[#{italic}#This note is stained with what appear to be motorcycle tire-tracks.#{normal}#

#{bold}#URGENT:#{normal}#

Operation to secure <?=player.name?> failure.  Primary defense force routed by target's overwhelming badassery, secondary team presumed dead (reports inaudible over sound of face-melting guitar solos).  All is lost.  Totally worth it.  Highest priority is now isolating <?=player.name?>, building a stadium around <?=player:him_her()?>, and selling tickets to spectacle of badassery.  Blow all connectors, break platform off the continent, prepare pyrotechnics, and set up spotlights and speaker systems befo--

#{italic}#The last O trails off, a line leading from it to the end of the page like the pen was rapidly jerked away, then leads to a doodle depicting you, wielding a double-bladed katana and fighting a giant construct labelled "Ninja Atamathon."  Your badassery must have interrupted this demon's writing.#{normal}#
]], "_t")
t("first mural painting", "first mural painting", "_t")
t("second mural painting", "second mural painting", "_t")
t("third mural painting", "third mural painting", "_t")
t("fourth mural painting", "fourth mural painting", "_t")
t("fifth mural painting", "fifth mural painting", "_t")
t("sixth mural painting", "sixth mural painting", "_t")
t("#{italic}#\"To honor the Masters\" - A thrall#{normal}#", "#{italic}#\"To honor the Masters\" - A thrall#{normal}#", "_t")
t("demon statue: wretchling", "demon statue: wretchling", "_t")
t("Behold, the humble wretchling, a testament to our devotion to our Father!  These children of emerald were among the first to alter themselves for our quest for vengeance, and managed an astounding degree of success.  With their bursts of blinding speed, overwhelming numbers, and skin that can release prodigious amounts of corrosive fluid, wretchlings can storm onto the battlefield and pounce on our foes one-by-one, dissolving the ground they walk on while leaving them helpless against our onslaught.  Wretchlings will readily give their lives in combat, serving as obstructions and shields while their acid and our casters do their work, and still remain the most populous of our species thanks to their incredible birth rates.  It is rare to see a wretchling survive to maturity, but make no mistake - every wretchling that fights does an incredible service to our cause.", "Behold, the humble wretchling, a testament to our devotion to our Father!  These children of emerald were among the first to alter themselves for our quest for vengeance, and managed an astounding degree of success.  With their bursts of blinding speed, overwhelming numbers, and skin that can release prodigious amounts of corrosive fluid, wretchlings can storm onto the battlefield and pounce on our foes one-by-one, dissolving the ground they walk on while leaving them helpless against our onslaught.  Wretchlings will readily give their lives in combat, serving as obstructions and shields while their acid and our casters do their work, and still remain the most populous of our species thanks to their incredible birth rates.  It is rare to see a wretchling survive to maturity, but make no mistake - every wretchling that fights does an incredible service to our cause.", "_t")
t("demon statue: fire imp", "demon statue: fire imp", "_t")
t("If the Wretchling speaks to our worship, the Fire Imp speaks to our commitment and loyalty.  When a child of ruby goes out onto the battlefield, she fuses some of the Eyal-scarred earth from our planet to her hands, having perfected a type of magic that uses the raging magic contained within to blast our foes with the fires they've caused.  Aside from this means of appropriate justice being pleasing to Urh'Rok (as he showed when dealing with the dust-mages), it shows how dedicated we are to our cause: without hands, there's very little a Fire Imp would be able to do if she deserted or became demoralized.  Fighting and destroying is what we live for, and what better way to show it than making onesself unable to do anything but fight and destroy?  Although the bulk of the ruby species do not pursue this path, instead focusing on magical research and furthering our alteration projects, the example that the Fire Imp sets is a shining standard of commitment for all of Urh'Rok's children.", "If the Wretchling speaks to our worship, the Fire Imp speaks to our commitment and loyalty.  When a child of ruby goes out onto the battlefield, she fuses some of the Eyal-scarred earth from our planet to her hands, having perfected a type of magic that uses the raging magic contained within to blast our foes with the fires they've caused.  Aside from this means of appropriate justice being pleasing to Urh'Rok (as he showed when dealing with the dust-mages), it shows how dedicated we are to our cause: without hands, there's very little a Fire Imp would be able to do if she deserted or became demoralized.  Fighting and destroying is what we live for, and what better way to show it than making onesself unable to do anything but fight and destroy?  Although the bulk of the ruby species do not pursue this path, instead focusing on magical research and furthering our alteration projects, the example that the Fire Imp sets is a shining standard of commitment for all of Urh'Rok's children.", "_t")
t("demon statue: water imp", "demon statue: water imp", "_t")
t("Though they retain use of their hands, this altered offshoot of the Fire Imp has made a much more powerful sacrifice: the ability to breathe air.  Most of the dominant species of Eyal reside above the water, making its oceans and lakes a prime location for carrying out covert operations, conducting experiments too dangerous to perform on our own soil, and preparing portals for a full-scale invasion.  As our scouts and servants beneath the seas, water imps forego the fire-slinging abilities shared by their brethren, instead focusing on ice-magic that is similarly effective underwater.  Like a wretchling, a Water Imp does not expect to live to see peacetime, and thus has no need to breathe above the surface.  Remember to pay tribute to the Water Imp whenever you can; since they do not fight alongside our land-based forces, it's all too easy to forget the selfless sacrifices they've made, and their enormous contributions in gathering intelligence and setting up remote bases.", "Though they retain use of their hands, this altered offshoot of the Fire Imp has made a much more powerful sacrifice: the ability to breathe air.  Most of the dominant species of Eyal reside above the water, making its oceans and lakes a prime location for carrying out covert operations, conducting experiments too dangerous to perform on our own soil, and preparing portals for a full-scale invasion.  As our scouts and servants beneath the seas, water imps forego the fire-slinging abilities shared by their brethren, instead focusing on ice-magic that is similarly effective underwater.  Like a wretchling, a Water Imp does not expect to live to see peacetime, and thus has no need to breathe above the surface.  Remember to pay tribute to the Water Imp whenever you can; since they do not fight alongside our land-based forces, it's all too easy to forget the selfless sacrifices they've made, and their enormous contributions in gathering intelligence and setting up remote bases.", "_t")
t("demon statue: quasit", "demon statue: quasit", "_t")
t("Clever and tough, the engineers and warriors of our kind, making armor for our forces and holding the front lines against the hordes of Eyal.  While the children of ruby study new magical spells for our arsenal, and the children of emerald study ways to make our own bodies deadlier, the children of onyx focus on making new constructs from scratch, lashing flesh, magic, and steel together into towering creations that strike fear into Eyal.  Those who fight on the front lines have been created to do so rather than born, churned out in a semi-mature state by factories with Forge-Giant-produced armor bolted onto their skin at \"birth.\"  Though they are mostly flesh, the warrior onyx known as Quasits are very much machines, made with bolstered muscles without losing the clever minds they come from.  As eager as they are brilliant, Quasits are well-disciplined and capable in combat, and their armor allows them to easily take blows that would devastate a Wretchling or Fire Imp.  Devotion will get us far on its own, but the Quasit shows how much more we can do when we have fervor and patience working hand-in-hand.", "Clever and tough, the engineers and warriors of our kind, making armor for our forces and holding the front lines against the hordes of Eyal.  While the children of ruby study new magical spells for our arsenal, and the children of emerald study ways to make our own bodies deadlier, the children of onyx focus on making new constructs from scratch, lashing flesh, magic, and steel together into towering creations that strike fear into Eyal.  Those who fight on the front lines have been created to do so rather than born, churned out in a semi-mature state by factories with Forge-Giant-produced armor bolted onto their skin at \"birth.\"  Though they are mostly flesh, the warrior onyx known as Quasits are very much machines, made with bolstered muscles without losing the clever minds they come from.  As eager as they are brilliant, Quasits are well-disciplined and capable in combat, and their armor allows them to easily take blows that would devastate a Wretchling or Fire Imp.  Devotion will get us far on its own, but the Quasit shows how much more we can do when we have fervor and patience working hand-in-hand.", "_t")
t("demon statue: wretch titan", "demon statue: wretch titan", "_t")
t("The modified children of emerald, known as the Wretchlings, willingly accept their role as the arrows in Urh'Rok's quiver, and most only live to see a couple of engagements before giving their lives in battle.  Once in a great while, though, one will stand toe-to-toe with the enemy and repeatedly come out on top.  These outstanding fighters, chosen by fate and their own talent, are recalled, then put through a series of tests to ensure that their survival was not due to luck alone.  Roughly 70% of these are then assigned to breeding duties, ensuring that the Wretchling bloodline gets ever stronger as it is forged in the fires of combat; the rest, whether due to sterility, consuming too much resources to sustain their brood, or simply insisting on staying in the fights for which they were created, are nurtured to maturity and once again let loose on the battlefield.  If wretchlings are our arrows, wretch titans are our trebuchet boulders, causing a tremendous amount of damage to the enemy line with their incredible strength and the geysers of acid spurting from their flesh.  Although no less aggressive than their younger counterparts, wretch titans generally have a much higher survival rate, due to not only their formidable power and size, but the sheer terror they cause when charging at the enemy - few Eyalites would stand and fight against such a foe, particularly when it means standing in a rapidly-growing pool of acid.", "The modified children of emerald, known as the Wretchlings, willingly accept their role as the arrows in Urh'Rok's quiver, and most only live to see a couple of engagements before giving their lives in battle.  Once in a great while, though, one will stand toe-to-toe with the enemy and repeatedly come out on top.  These outstanding fighters, chosen by fate and their own talent, are recalled, then put through a series of tests to ensure that their survival was not due to luck alone.  Roughly 70% of these are then assigned to breeding duties, ensuring that the Wretchling bloodline gets ever stronger as it is forged in the fires of combat; the rest, whether due to sterility, consuming too much resources to sustain their brood, or simply insisting on staying in the fights for which they were created, are nurtured to maturity and once again let loose on the battlefield.  If wretchlings are our arrows, wretch titans are our trebuchet boulders, causing a tremendous amount of damage to the enemy line with their incredible strength and the geysers of acid spurting from their flesh.  Although no less aggressive than their younger counterparts, wretch titans generally have a much higher survival rate, due to not only their formidable power and size, but the sheer terror they cause when charging at the enemy - few Eyalites would stand and fight against such a foe, particularly when it means standing in a rapidly-growing pool of acid.", "_t")
t("demon statue: dolleg", "demon statue: dolleg", "_t")
t("A walking monument to times of prosperity, the dolleg was once a beast of burden, carrying loads of trade goods through the Sher'Tul portals.  Reliable, friendly, and rather intelligent for a beast, dollegs were often taken in as beloved pets as well - their joyous chirps when seeing their master get home could brighten up anyone's day, and despite their large size they were gentle enough to play with our young.  Their kind temperament and dutiful labor were the pride of our breeding practices, and two-thirds of our population either owned, lived in a home with, or worked with a dolleg.  In the wake of Mal'Rok's destruction, the children of emerald developed an effective process to convert these companions into beasts of war, covered in acidic spines and thick plating, and loyally tearing through our enemies with incredible force.  Unfortunately, their friendly demeanor was lost in order to make them merciless in combat; of all the sacrifices we've had to make for our war, it might be the loss of our gentle companions that troubles us the most.", "A walking monument to times of prosperity, the dolleg was once a beast of burden, carrying loads of trade goods through the Sher'Tul portals.  Reliable, friendly, and rather intelligent for a beast, dollegs were often taken in as beloved pets as well - their joyous chirps when seeing their master get home could brighten up anyone's day, and despite their large size they were gentle enough to play with our young.  Their kind temperament and dutiful labor were the pride of our breeding practices, and two-thirds of our population either owned, lived in a home with, or worked with a dolleg.  In the wake of Mal'Rok's destruction, the children of emerald developed an effective process to convert these companions into beasts of war, covered in acidic spines and thick plating, and loyally tearing through our enemies with incredible force.  Unfortunately, their friendly demeanor was lost in order to make them merciless in combat; of all the sacrifices we've had to make for our war, it might be the loss of our gentle companions that troubles us the most.", "_t")
t("demon statue: uruivellas", "demon statue: uruivellas", "_t")
t("The minotaur is one of Eyal's more interesting creatures, and a good example of the devious designs the Sher'Tul had in mind while creating or altering Eyal's races.  Its instincts draw it toward narrow corridors, twisted passages, magical artifacts, and surges of magical energy, resulting in horned beast-men frequently blundering their way into our bases and encampments.  They also seem to soak up empowering magic very readily, and alter their forms accordingly - a typical minotaur is no match for our forces, but occasionally blight will mutate one into an extremely dangerous horror.  Said blighted forms are too unstable for use among our ranks, but with some effort by the children of emerald and ruby, we can give one the gifts of massively increased strength and the ability to unleash waves of flame on our enemies.  While we currently need to keep most of them enthralled to ensure their loyalty, we've recently begun breeding minotaurs on our continent so we can train them from birth to know our cause of righteous revenge - and already some wandering minotaurs accept our cause and our blessings willingly!  It seems the natives of Eyal are no kinder to their own brethren than they are to us.", "The minotaur is one of Eyal's more interesting creatures, and a good example of the devious designs the Sher'Tul had in mind while creating or altering Eyal's races.  Its instincts draw it toward narrow corridors, twisted passages, magical artifacts, and surges of magical energy, resulting in horned beast-men frequently blundering their way into our bases and encampments.  They also seem to soak up empowering magic very readily, and alter their forms accordingly - a typical minotaur is no match for our forces, but occasionally blight will mutate one into an extremely dangerous horror.  Said blighted forms are too unstable for use among our ranks, but with some effort by the children of emerald and ruby, we can give one the gifts of massively increased strength and the ability to unleash waves of flame on our enemies.  While we currently need to keep most of them enthralled to ensure their loyalty, we've recently begun breeding minotaurs on our continent so we can train them from birth to know our cause of righteous revenge - and already some wandering minotaurs accept our cause and our blessings willingly!  It seems the natives of Eyal are no kinder to their own brethren than they are to us.", "_t")
t("Any one of us who's read up on our history will remember the story of the wicked dust-mages, tormenting us with sentient storms from the safety of their hidden cities.  Although we were tempted at the time to erase all vestiges of their knowledge and culture like they did to us, we knew their magic could come in handy someday, and when their cities lay in ruin, we plundered their libraries for their writings, then dutifully copied down the practical details from these while stripping out the rest.  Once the portals were unleashed on us, the children of ruby (after some controversy) managed to use their old spells to create a new kind of storm, one of swirling flames and coals rather than dust and sand.  Obedient and cheap (if hazardous) to make, these living spells will torment and raze Eyal with their firey onslaught, like their predecessors once did to Mal'Rok.", "Any one of us who's read up on our history will remember the story of the wicked dust-mages, tormenting us with sentient storms from the safety of their hidden cities.  Although we were tempted at the time to erase all vestiges of their knowledge and culture like they did to us, we knew their magic could come in handy someday, and when their cities lay in ruin, we plundered their libraries for their writings, then dutifully copied down the practical details from these while stripping out the rest.  Once the portals were unleashed on us, the children of ruby (after some controversy) managed to use their old spells to create a new kind of storm, one of swirling flames and coals rather than dust and sand.  Obedient and cheap (if hazardous) to make, these living spells will torment and raze Eyal with their firey onslaught, like their predecessors once did to Mal'Rok.", "_t")
t("demon statue: champion of Urh'Rok", "demon statue: champion of Urh'Rok", "_t")
t("The Divine Tournament of Combat is the most straightforward of our competitions for the spectator, but those competing have a huge variety of possible divisions to enter.  Most are based on the maximum amount of energy consumed by their entrants since (and including) birth; others include those set in an open field for direct combat, or a difficult-to-navigate forest of pillars to properly evaluate those who use hit-and-run tactics or excel at setting up or detecting ambushes.  In the high-energy divisions, those competing are typically not born in the conventional manner, usually being constructs made by a team performing a collaborative effort.  The constructs we now call Champions of Urh'Rok have utterly devastated most of the high-energy open-field divisions, while performing adequately in the less-direct ones, making them a solid fit for production and deployment in the invasion.  Their development team has earned a place of honor for their ingenious methods of creating such incredible strength with a sustainable amount of energy-input, and once mass-production is in order, these gigantic creatures will become the backbone of our military.  Once they arrive on the surface, Eyal will experience a few fleeting moments of terror before their utter annihilation.", "The Divine Tournament of Combat is the most straightforward of our competitions for the spectator, but those competing have a huge variety of possible divisions to enter.  Most are based on the maximum amount of energy consumed by their entrants since (and including) birth; others include those set in an open field for direct combat, or a difficult-to-navigate forest of pillars to properly evaluate those who use hit-and-run tactics or excel at setting up or detecting ambushes.  In the high-energy divisions, those competing are typically not born in the conventional manner, usually being constructs made by a team performing a collaborative effort.  The constructs we now call Champions of Urh'Rok have utterly devastated most of the high-energy open-field divisions, while performing adequately in the less-direct ones, making them a solid fit for production and deployment in the invasion.  Their development team has earned a place of honor for their ingenious methods of creating such incredible strength with a sustainable amount of energy-input, and once mass-production is in order, these gigantic creatures will become the backbone of our military.  Once they arrive on the surface, Eyal will experience a few fleeting moments of terror before their utter annihilation.", "_t")
t("demon statue: forge giant", "demon statue: forge giant", "_t")
t("The power of Urh'Rok cannot be overstated, except by claiming it to be infinite.  Most of his strength and will are occupied at the moment, keeping our shattered home from splintering off into the void; as such, he cannot spend time or effort making equipment for our army.  The children of onyx recognized this, and worked on a way to maximize the amount of benefit they could get from a small portion of his power; Urh'Rok was pleased by their idea, and granted their request in full, giving them a handful of enormous hammers, each one glowing with his magic.  These were then given to modified variants of the Champion of Urh'Rok template, built for raw strength at the expense of speed and energy-efficient creation, and now they work tirelessly, heating raw metal with their magic until it is workable, then pounding it into their shape, automatically imbuing the resulting armor and weaponry with Urh'Rok's blessing.  Thanks to an assortment of detachable heads for these hammers, every single swing produces several pieces of usable equipment.  The constant exposure to the power of Urh'Rok has made these creatures almost absurdly formidable, but as useful as they would be on the front lines, they are even more useful bolstering the rest of our forces with blessed equipment; that said, should our scouting parties encounter a problem that requires drastic and immediate intervention, sending a Forge-Giant down is a reliable emergency option, and would immediately clear up any combat-related difficulties should the situation call for it.", "The power of Urh'Rok cannot be overstated, except by claiming it to be infinite.  Most of his strength and will are occupied at the moment, keeping our shattered home from splintering off into the void; as such, he cannot spend time or effort making equipment for our army.  The children of onyx recognized this, and worked on a way to maximize the amount of benefit they could get from a small portion of his power; Urh'Rok was pleased by their idea, and granted their request in full, giving them a handful of enormous hammers, each one glowing with his magic.  These were then given to modified variants of the Champion of Urh'Rok template, built for raw strength at the expense of speed and energy-efficient creation, and now they work tirelessly, heating raw metal with their magic until it is workable, then pounding it into their shape, automatically imbuing the resulting armor and weaponry with Urh'Rok's blessing.  Thanks to an assortment of detachable heads for these hammers, every single swing produces several pieces of usable equipment.  The constant exposure to the power of Urh'Rok has made these creatures almost absurdly formidable, but as useful as they would be on the front lines, they are even more useful bolstering the rest of our forces with blessed equipment; that said, should our scouting parties encounter a problem that requires drastic and immediate intervention, sending a Forge-Giant down is a reliable emergency option, and would immediately clear up any combat-related difficulties should the situation call for it.", "_t")
t("demon statue: thaurhereg", "demon statue: thaurhereg", "_t")
t("Thanks to numerous contacts we have on Eyal's surface, ranging from easily-duped natives to our own scouting teams, we've managed to gain a few captive Eyalites.  These prisoners are useful for a variety of tasks, including manual labor, magical research, stress relief, and developing new methods of torture (those last two often being one in the same).  We try to preserve these temporarily-valuable subjects for as long as we can, but invariably, an experiment goes wrong or someone uses too much force, and the captive ends up mortally wounded.  Rather than let these world-breakers escape their eternal fate by simply dying, we put their bodies and life-essence to use, combining several fallen Eyalites into a creature held together by their collective rage and suffering.  You'd think this would be a bad idea to have walking around our base of operations, but as it turns out, it just takes a few simple enchantments to redirect their vengeful instincts towards their former brethren, making them fearsome and sadistic in combat.  Their rampages against their \"tormentors\" are simply hilarious!", "Thanks to numerous contacts we have on Eyal's surface, ranging from easily-duped natives to our own scouting teams, we've managed to gain a few captive Eyalites.  These prisoners are useful for a variety of tasks, including manual labor, magical research, stress relief, and developing new methods of torture (those last two often being one in the same).  We try to preserve these temporarily-valuable subjects for as long as we can, but invariably, an experiment goes wrong or someone uses too much force, and the captive ends up mortally wounded.  Rather than let these world-breakers escape their eternal fate by simply dying, we put their bodies and life-essence to use, combining several fallen Eyalites into a creature held together by their collective rage and suffering.  You'd think this would be a bad idea to have walking around our base of operations, but as it turns out, it just takes a few simple enchantments to redirect their vengeful instincts towards their former brethren, making them fearsome and sadistic in combat.  Their rampages against their \"tormentors\" are simply hilarious!", "_t")
t("demon statue: dúathedlen", "demon statue: dúathedlen", "_t")
t([[#{italic}#This plaque is mostly covered in shifting shadows.  You can only make out a little bit of the text.#{normal}#

#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#heregs are not the only way we recycle #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#arness their fear and suspici#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#outs.  Cautious and yet sadistic, these assassins #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#markably effective in indirect combat, setting ambus#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#justice.  Additionally, the shadows they produce #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#spionage, scouting, and #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#king them a val#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#tion to our intel-gathering camps. Redee#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST# data they contribute on#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST# paving the way for our invasion.

#{italic}#As you reach the end, the text goes completely black, and a new message forms.#{normal}#

#{bold}#WE SEE YOU.#{normal}#]], [[#{italic}#This plaque is mostly covered in shifting shadows.  You can only make out a little bit of the text.#{normal}#

#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#heregs are not the only way we recycle #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#arness their fear and suspici#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#outs.  Cautious and yet sadistic, these assassins #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#markably effective in indirect combat, setting ambus#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#justice.  Additionally, the shadows they produce #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#spionage, scouting, and #927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#king them a val#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST#tion to our intel-gathering camps. Redee#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST# data they contribute on#927e64#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#LAST# paving the way for our invasion.

#{italic}#As you reach the end, the text goes completely black, and a new message forms.#{normal}#

#{bold}#WE SEE YOU.#{normal}#]], "_t")
t("demon statue: Ruin Banshee", "demon statue: Ruin Banshee", "_t")
t("The onslaught of the Sher'Tul portals never truly stopped.  Magic still pours from them, threatening to do even more damage to our home; it would be completely destroyed by now, if not for our Father.  Part of his work to keep Mal'Rok structurally intact is to blow great gusts across the devastated land, forcing the ravenous flames back into the portal network from whence they came.  It would seem, though, that the flames took souvenirs with them; our scouting parties have noted that Sher'Tul portals on Eyal, even those which have been completely deactivated, will occasionally emit a shade of one of our fallen citizens, imbued by some of Urh'Rok's power, smelling of Mal'Rok's ashes, and warped to insanity by its transit through the unstable rifts.  While this is a troubling revalation of the true horror of the Sher'Tul weapons, telling us that even now our fallen cannot rest in peace, the fact that they are arriving on Eyal in defiance of the shield is some consolation, as it means that those most wronged by the betrayal can claim their revenge personally.", "The onslaught of the Sher'Tul portals never truly stopped.  Magic still pours from them, threatening to do even more damage to our home; it would be completely destroyed by now, if not for our Father.  Part of his work to keep Mal'Rok structurally intact is to blow great gusts across the devastated land, forcing the ravenous flames back into the portal network from whence they came.  It would seem, though, that the flames took souvenirs with them; our scouting parties have noted that Sher'Tul portals on Eyal, even those which have been completely deactivated, will occasionally emit a shade of one of our fallen citizens, imbued by some of Urh'Rok's power, smelling of Mal'Rok's ashes, and warped to insanity by its transit through the unstable rifts.  While this is a troubling revalation of the true horror of the Sher'Tul weapons, telling us that even now our fallen cannot rest in peace, the fact that they are arriving on Eyal in defiance of the shield is some consolation, as it means that those most wronged by the betrayal can claim their revenge personally.", "_t")
t("demon statue: Draebor, the Imp", "demon statue: Draebor, the Imp", "_t")
t("Teleportation is one of the most crucial areas of magical research to our cause of revenge; until we break the Sher'Tul-made shield surrounding Eyal, it will remain our only means of reaching the surface.  One of our leading scholars, a child of onyx known as Draebor, has perfected short-range teleportation and has been studying methods to work his skills into a mass-producible artifact to grant this ability to all of our troops.  He's kept his work under wraps as of late, but rumor has it that he's been reverse-engineering the Sher'Tul portals, letting our invasion get through via their own weapons.  Whatever he's up to, keep an eye out - big things are just around the corner, courtesy of his dedicated research!", "Teleportation is one of the most crucial areas of magical research to our cause of revenge; until we break the Sher'Tul-made shield surrounding Eyal, it will remain our only means of reaching the surface.  One of our leading scholars, a child of onyx known as Draebor, has perfected short-range teleportation and has been studying methods to work his skills into a mass-producible artifact to grant this ability to all of our troops.  He's kept his work under wraps as of late, but rumor has it that he's been reverse-engineering the Sher'Tul portals, letting our invasion get through via their own weapons.  Whatever he's up to, keep an eye out - big things are just around the corner, courtesy of his dedicated research!", "_t")
t("demon statue: Shasshhiy'Kaish", "demon statue: Shasshhiy'Kaish", "_t")
t([[Once a naturalist and explorer, this scholar frequently made trips to Eyal in the period before Mal'Rok's destruction.  Her journals about a wide assortment of curious species living in the shadow of the Sher'Tul were a delightful read for our citizens, and she had a genuine love for these pitiable, uncivilized creatures.  She, along with two of her companions, were trapped on Eyal when the portal network was destroyed; for a long time, she was feared dead, or worse, turned traitor and working with the natives against her old home.  In any case, it was assumed she would have expired of old age by the time we arrived in orbit around the planet.  Once we got there, though, something curious happened: by magic we still haven't been able to reverse-engineer, a handful of Eyalites dressed in strange robes appeared on our continent, proclaiming devotion to Shasshhiy'Kaish and wishing to be subjected to our experiments.  Ever since then, batches of these willing captives have been delivered with great regularity.  Sadly, they have not been as great a boon to our research as this would sound - all of them appear with nearly every shred of their essence drained, leaving them on the edge of death, and that's not counting the frequent cases of internal bleeding and the rare occasion of them appearing with a rewired nervous system that perceives pain as pleasure, frustrating our attempts to create better methods of punishment.  Nonetheless, they are both cooperative and plentiful, and have been quite helpful.  We cannot be sure that Shasshhiy'Kaish herself is still alive, but if she is, we can be sure her allegiances are with our cause.

#{italic}#A short message is etched below the main text.#{normal}#

Cute.  I'll let it stay.  
-S.
]], [[Once a naturalist and explorer, this scholar frequently made trips to Eyal in the period before Mal'Rok's destruction.  Her journals about a wide assortment of curious species living in the shadow of the Sher'Tul were a delightful read for our citizens, and she had a genuine love for these pitiable, uncivilized creatures.  She, along with two of her companions, were trapped on Eyal when the portal network was destroyed; for a long time, she was feared dead, or worse, turned traitor and working with the natives against her old home.  In any case, it was assumed she would have expired of old age by the time we arrived in orbit around the planet.  Once we got there, though, something curious happened: by magic we still haven't been able to reverse-engineer, a handful of Eyalites dressed in strange robes appeared on our continent, proclaiming devotion to Shasshhiy'Kaish and wishing to be subjected to our experiments.  Ever since then, batches of these willing captives have been delivered with great regularity.  Sadly, they have not been as great a boon to our research as this would sound - all of them appear with nearly every shred of their essence drained, leaving them on the edge of death, and that's not counting the frequent cases of internal bleeding and the rare occasion of them appearing with a rewired nervous system that perceives pain as pleasure, frustrating our attempts to create better methods of punishment.  Nonetheless, they are both cooperative and plentiful, and have been quite helpful.  We cannot be sure that Shasshhiy'Kaish herself is still alive, but if she is, we can be sure her allegiances are with our cause.

#{italic}#A short message is etched below the main text.#{normal}#

Cute.  I'll let it stay.  
-S.
]], "_t")
t("demon statue: Walrog", "demon statue: Walrog", "_t")
t([[#{italic}#The message at the base of this statue has been scratched out, and a new one has been carved in its place.#{normal}#

Walrog, if you're reading this: We're still alive, but keep up the good work.
-S.]], [[#{italic}#The message at the base of this statue has been scratched out, and a new one has been carved in its place.#{normal}#

Walrog, if you're reading this: We're still alive, but keep up the good work.
-S.]], "_t")
t("demon statue: Kryl-Feijan", "demon statue: Kryl-Feijan", "_t")
t([[#{italic}#The text at the base of this statue has been scratched out.  A note is attached in its place.#{normal}#

Hello, Eyalite.  The text here wouldn't have meant a whole lot to you; a whole lot of blathering about his accomplishments as a naturalist, and his mysterious disappearance.  Let me tell you what you need to know instead.

Kryl-Feijan was my lover, and along with a friend by the name of Walrog we came to Eyal out of curiosity and thirst for knowledge.  It was an enlightening hobby, and the reports we made of your many, primitive species were read all across our world.  Do not think you deserved this attention; you were not special in any way aside from your inferiority.  How could the planet of the powerful, intelligent Sher'Tul create such savages that had barely escaped feudalism?  Your sins were endearing, and your failures amusing.  And it was knowing this, along with the curious absence of the Sher'Tul, that led us to go out and investigate when a wounded child of onyx came through our portal, deactivated it, and told us of horrible destruction unleashed on Mal'Rok by Eyal.  We knew you were not capable of such feats, so we had to learn the answers for ourselves; Kryl-Feijan and I adopted our usual disguises as human mages, while Walrog arranged to scout the seas for anomalies, then meet us back after a few days.

When we emerged from our underground lodge, we were surprised to see firestorms (although not nearly so fierce) raging across Eyal as well.  What surprised us more, though, was an enraged horde of peasants, provoked by our unfortunate choice of disguises - in your ignorance, you chose to blame spellcasters for the disaster.  We tried to escape, but the mob swarmed us from all directions, and were soon upon us.

Soon, I was tied up and restrained, while they gloated and made threats I couldn't hear over the din of the crowd.  I could have fought back, but I kept telling myself only to lash out once I was sure my life was in danger, reassuring myself that the people of Eyal who were once so fascinating to me surely couldn't be aware of what they were doing.  Judging from the geysers of flame bursting above my head, my lover was not so patient; when the blasts stopped and the crowd started to clear away, I saw why he'd fought so fiercely.  His injuries were horrific, clearly done to make him suffer rather than incapacitate him, and he was on the edge of death.  In a moment of desperation, I muttered a spell to myself to understand what was going through their minds, what could possibly justify such treatment.  That's when I learned what they'd done to him, and what they were planning with me, but neither was as awful as the unthinking hate motivating it...  there are both too many words for it and not enough.  Horrible, barbaric, sadistic, all are accurate but none fully convey the evil of it.  That moment is when I learned the true savagery of Eyal, and realized the fate all Eyalites deserve.  That moment is when my patience broke.

There is a type of magic on Mal'Rok that will allow one to transfer his or her life-essence to another, prolonging the latter's lifespan at the expense of the former.  Voluntary donations to honored figures are popular, but the reverse - draining another to help one's self - was considered the gravest of sins, a statement that you considered your life to be worth more than another's, which is a decision nobody should be allowed to make when they have a vested interest in it.  Walrog had taught this forbidden spell to me, and only now did I use it, withering the horde all at once and forcing their lives into Kryl-Feijan.  The survivors, too weak to stand up against me, suffered greatly, playthings of my brief and furious revenge.  Unfortunately, even all the life I'd drained was not quite enough to restore my lover to health; all it could do was keep him in limbo, in incredible pain and unable to act, but still alive.

I took his surviving essence and fled to safety, then started picking the natives off one by one, extending my lifespan and getting ever closer to restoring him to health.  I can only assume Walrog is doing the same, preying on sailors first and then naga; I've lost contact with him, but the stories of terrors from the sea tell me he's still alive.  Keeping Kryl-Feijan in limbo consumes a great deal of energy, though, and soon lone travellers were not enough to keep him stable; I needed others to work for me, gathering victims and willingly sacrificing themselves once they'd outlived their usefulness.  And that is when I learned of the approach of the Fearscape, and came up with an offer I could make to the residents of Eyal.

When the legions of Urh'Rok manage to get an invasion force to Eyal's surface - not if, but when - you will all suffer, more than you can possibly imagine.  Many of you will die; some will not be so lucky, and will be an ever-living target of their rage, tortured until the end of time.  Their reasons are somewhat inaccurate, but make no mistake: you deserve the fate they have lined up for you.  Even if I wanted to, neither I nor anything else in the universe could stop their invasion, save the word of Urh'Rok himself - and that seems rather unlikely.  If you assist me and follow my orders to my satisfaction, I can guarantee you two things.  One, your inevitable agonizing fate WILL end in death, after a maximum of a couple of weeks; even the armies of Mal'Rok can't undo the effects of having your life-essence drained.  And two, before you feel the pain, you will feel nearly-equal pleasure.  With my magical skills, I can alter myself into any form, create all manner of illusions, and manipulate all your senses to your liking.  Your wildest, most unrealistic fantasies will become true; the time before the pain starts will be so enjoyable as to eclipse every moment of your pathetic lives that came before.  And if you think yourself above such hedonism, consider the psionically-gifted servitors I've recently acquired, and the way they could change your memories - when the "demons" are dripping acid into your eyes, then growing them back with more nerve endings than before so you can feel the pain more acutely, won't it be much more bearable if you're under the delusion that you've made a selfless sacrifice to save Eyal, and that your children and loved ones aren't suffering the same fate?

Countless others have agreed to this deal in the millenia before you were even born, and I have amassed enough essence to contain Kryl-Feijan in a stable "seed."  Once it is planted in a suitable victim and allowed to grow, he will once again walk Eyal, far more powerful than he was before, and the two of us will do everything we can to speed up your miserable world's much-deserved death.  Technically, any sentient and fleshy body would work, but I'd like someone who'll be missed, whose death will allow my lover's first act in rebirth to cause great misery to Eyal.  If you'd like to accept my deal, come unarmed and alone to the Crypt of Kryl-Feijan, and join your fellow Eyalites in servitude to me.  And if you were to bring a suitable host for my lover...  well, that'd be deserving of some special, one-on-one attention, wouldn't it?

Eyal is doomed to perish in screaming agony.  Wouldn't you at least like a good-bye kiss first?

-S.]], [[#{italic}#The text at the base of this statue has been scratched out.  A note is attached in its place.#{normal}#

Hello, Eyalite.  The text here wouldn't have meant a whole lot to you; a whole lot of blathering about his accomplishments as a naturalist, and his mysterious disappearance.  Let me tell you what you need to know instead.

Kryl-Feijan was my lover, and along with a friend by the name of Walrog we came to Eyal out of curiosity and thirst for knowledge.  It was an enlightening hobby, and the reports we made of your many, primitive species were read all across our world.  Do not think you deserved this attention; you were not special in any way aside from your inferiority.  How could the planet of the powerful, intelligent Sher'Tul create such savages that had barely escaped feudalism?  Your sins were endearing, and your failures amusing.  And it was knowing this, along with the curious absence of the Sher'Tul, that led us to go out and investigate when a wounded child of onyx came through our portal, deactivated it, and told us of horrible destruction unleashed on Mal'Rok by Eyal.  We knew you were not capable of such feats, so we had to learn the answers for ourselves; Kryl-Feijan and I adopted our usual disguises as human mages, while Walrog arranged to scout the seas for anomalies, then meet us back after a few days.

When we emerged from our underground lodge, we were surprised to see firestorms (although not nearly so fierce) raging across Eyal as well.  What surprised us more, though, was an enraged horde of peasants, provoked by our unfortunate choice of disguises - in your ignorance, you chose to blame spellcasters for the disaster.  We tried to escape, but the mob swarmed us from all directions, and were soon upon us.

Soon, I was tied up and restrained, while they gloated and made threats I couldn't hear over the din of the crowd.  I could have fought back, but I kept telling myself only to lash out once I was sure my life was in danger, reassuring myself that the people of Eyal who were once so fascinating to me surely couldn't be aware of what they were doing.  Judging from the geysers of flame bursting above my head, my lover was not so patient; when the blasts stopped and the crowd started to clear away, I saw why he'd fought so fiercely.  His injuries were horrific, clearly done to make him suffer rather than incapacitate him, and he was on the edge of death.  In a moment of desperation, I muttered a spell to myself to understand what was going through their minds, what could possibly justify such treatment.  That's when I learned what they'd done to him, and what they were planning with me, but neither was as awful as the unthinking hate motivating it...  there are both too many words for it and not enough.  Horrible, barbaric, sadistic, all are accurate but none fully convey the evil of it.  That moment is when I learned the true savagery of Eyal, and realized the fate all Eyalites deserve.  That moment is when my patience broke.

There is a type of magic on Mal'Rok that will allow one to transfer his or her life-essence to another, prolonging the latter's lifespan at the expense of the former.  Voluntary donations to honored figures are popular, but the reverse - draining another to help one's self - was considered the gravest of sins, a statement that you considered your life to be worth more than another's, which is a decision nobody should be allowed to make when they have a vested interest in it.  Walrog had taught this forbidden spell to me, and only now did I use it, withering the horde all at once and forcing their lives into Kryl-Feijan.  The survivors, too weak to stand up against me, suffered greatly, playthings of my brief and furious revenge.  Unfortunately, even all the life I'd drained was not quite enough to restore my lover to health; all it could do was keep him in limbo, in incredible pain and unable to act, but still alive.

I took his surviving essence and fled to safety, then started picking the natives off one by one, extending my lifespan and getting ever closer to restoring him to health.  I can only assume Walrog is doing the same, preying on sailors first and then naga; I've lost contact with him, but the stories of terrors from the sea tell me he's still alive.  Keeping Kryl-Feijan in limbo consumes a great deal of energy, though, and soon lone travellers were not enough to keep him stable; I needed others to work for me, gathering victims and willingly sacrificing themselves once they'd outlived their usefulness.  And that is when I learned of the approach of the Fearscape, and came up with an offer I could make to the residents of Eyal.

When the legions of Urh'Rok manage to get an invasion force to Eyal's surface - not if, but when - you will all suffer, more than you can possibly imagine.  Many of you will die; some will not be so lucky, and will be an ever-living target of their rage, tortured until the end of time.  Their reasons are somewhat inaccurate, but make no mistake: you deserve the fate they have lined up for you.  Even if I wanted to, neither I nor anything else in the universe could stop their invasion, save the word of Urh'Rok himself - and that seems rather unlikely.  If you assist me and follow my orders to my satisfaction, I can guarantee you two things.  One, your inevitable agonizing fate WILL end in death, after a maximum of a couple of weeks; even the armies of Mal'Rok can't undo the effects of having your life-essence drained.  And two, before you feel the pain, you will feel nearly-equal pleasure.  With my magical skills, I can alter myself into any form, create all manner of illusions, and manipulate all your senses to your liking.  Your wildest, most unrealistic fantasies will become true; the time before the pain starts will be so enjoyable as to eclipse every moment of your pathetic lives that came before.  And if you think yourself above such hedonism, consider the psionically-gifted servitors I've recently acquired, and the way they could change your memories - when the "demons" are dripping acid into your eyes, then growing them back with more nerve endings than before so you can feel the pain more acutely, won't it be much more bearable if you're under the delusion that you've made a selfless sacrifice to save Eyal, and that your children and loved ones aren't suffering the same fate?

Countless others have agreed to this deal in the millenia before you were even born, and I have amassed enough essence to contain Kryl-Feijan in a stable "seed."  Once it is planted in a suitable victim and allowed to grow, he will once again walk Eyal, far more powerful than he was before, and the two of us will do everything we can to speed up your miserable world's much-deserved death.  Technically, any sentient and fleshy body would work, but I'd like someone who'll be missed, whose death will allow my lover's first act in rebirth to cause great misery to Eyal.  If you'd like to accept my deal, come unarmed and alone to the Crypt of Kryl-Feijan, and join your fellow Eyalites in servitude to me.  And if you were to bring a suitable host for my lover...  well, that'd be deserving of some special, one-on-one attention, wouldn't it?

Eyal is doomed to perish in screaming agony.  Wouldn't you at least like a good-bye kiss first?

-S.]], "_t")
t("demon statue: Khulmanar, General of Urh'Rok", "demon statue: Khulmanar, General of Urh'Rok", "_t")
t("Our tournaments, run ever since our salvation from the dust mages under the command and inspiration of Urh'Rok, are not simply tests of direct combat, as many may think.  We have those, yes, but we also have competitions for scholarly work, attentiveness, physical endurance, philosophy, and countless other fields.  Perhaps the most prestigious of these, though, is the Divine Tournament of Tactics, by which our military leaders are selected.  Through a series of trials, we are compared in our abilities to assess a combat scenario and swiftly handle it, rated on speed, casualties, deployment efficiency, and a variety of other factors.  Khulmanar, a child of onyx, is the reigning champion of these, and has been for most of the time that we've spent waiting for our continent to reach Eyal.  Chosen by our process as the wisest tactical mind among our people, he was selected to meet with Urh'Rok himself to gain his approval to lead our forces in the invasion.  Urh'Rok was so impressed by Khulmanar that he used a significant portion of the little energy he's not using to hold our world together to build Khulmanar a new body, one strong enough to let him direct battles from the front-line without fear.  With a form and weapons granted by our Father, and a mind given his direct, enthusiastic approval, Khulmanar is considered to be the avatar of Urh'Rok, and his commands in battle are to be treated with the same reverence we would give to the words of Father himself.", "Our tournaments, run ever since our salvation from the dust mages under the command and inspiration of Urh'Rok, are not simply tests of direct combat, as many may think.  We have those, yes, but we also have competitions for scholarly work, attentiveness, physical endurance, philosophy, and countless other fields.  Perhaps the most prestigious of these, though, is the Divine Tournament of Tactics, by which our military leaders are selected.  Through a series of trials, we are compared in our abilities to assess a combat scenario and swiftly handle it, rated on speed, casualties, deployment efficiency, and a variety of other factors.  Khulmanar, a child of onyx, is the reigning champion of these, and has been for most of the time that we've spent waiting for our continent to reach Eyal.  Chosen by our process as the wisest tactical mind among our people, he was selected to meet with Urh'Rok himself to gain his approval to lead our forces in the invasion.  Urh'Rok was so impressed by Khulmanar that he used a significant portion of the little energy he's not using to hold our world together to build Khulmanar a new body, one strong enough to let him direct battles from the front-line without fear.  With a form and weapons granted by our Father, and a mind given his direct, enthusiastic approval, Khulmanar is considered to be the avatar of Urh'Rok, and his commands in battle are to be treated with the same reverence we would give to the words of Father himself.", "_t")
t("Lithfengel, mentor of Draebor and child of emerald, was one of our finest scholars.  When most of us were still too afraid to go near a portal, he recovered an intact one and began to pry apart its secrets, in hopes of reaching Eyal.  His data showed that although this portal was still technically connected to Eyal, the link between the two worlds was still fluctuating far too much to make it safe for travel, the still-raging flames threatening to tear any prospective passengers apart before they reached their destination.  Rather than try to repair the link directly, he went into his lab and didn't emerge for a few days; when he came out, he glowed with a strange new enchantment, proclaiming it would adaptively mutate him to endure whatever damage the portal would otherwise inflict.  Saying that the consequences of failure were too awful to risk inflicting on other test subjects, he entered the portal himself, promising to return immediately after he arrived; he has not been seen since.  May he rest in peace for his selfless devotion.", "Lithfengel, mentor of Draebor and child of emerald, was one of our finest scholars.  When most of us were still too afraid to go near a portal, he recovered an intact one and began to pry apart its secrets, in hopes of reaching Eyal.  His data showed that although this portal was still technically connected to Eyal, the link between the two worlds was still fluctuating far too much to make it safe for travel, the still-raging flames threatening to tear any prospective passengers apart before they reached their destination.  Rather than try to repair the link directly, he went into his lab and didn't emerge for a few days; when he came out, he glowed with a strange new enchantment, proclaiming it would adaptively mutate him to endure whatever damage the portal would otherwise inflict.  Saying that the consequences of failure were too awful to risk inflicting on other test subjects, he entered the portal himself, promising to return immediately after he arrived; he has not been seen since.  May he rest in peace for his selfless devotion.", "_t")
t("demon statue: Rogroth, Eater of Souls", "demon statue: Rogroth, Eater of Souls", "_t")
t("Recently, the cultists of Shasshhiy'Kaish have begun speaking of a \"demon seed,\" a sort of magical cluster of life-essence which can be implanted in a sentient being, allowing it to grow inside of them and eventually become one of our citizens.  Inspired by this idea, the children of emerald have developed a prototype of this form of magic, and the children of onyx have made a chassis to carry it into combat.  Rogroth generates countless essence-less seeds from within its frame, then embeds them in nearby living beings, so when they expire, their life-essence goes directly into the seed and allows it to grow.  We have not yet perfected its production capabilities, so currently the seeds will only become degenerate husks when they grow, but fear not!  As we get data from the tests of this design, we'll improve on it, and soon the slaughter of our foes will cause wretchlings, quasits, and even thaurheregs to spring up from their corpses.  With a little bit of luck and some decisive early skirmishes, we could even bypass the problem of getting an invasion force to the surface entirely, growing it there instead.", "Recently, the cultists of Shasshhiy'Kaish have begun speaking of a \"demon seed,\" a sort of magical cluster of life-essence which can be implanted in a sentient being, allowing it to grow inside of them and eventually become one of our citizens.  Inspired by this idea, the children of emerald have developed a prototype of this form of magic, and the children of onyx have made a chassis to carry it into combat.  Rogroth generates countless essence-less seeds from within its frame, then embeds them in nearby living beings, so when they expire, their life-essence goes directly into the seed and allows it to grow.  We have not yet perfected its production capabilities, so currently the seeds will only become degenerate husks when they grow, but fear not!  As we get data from the tests of this design, we'll improve on it, and soon the slaughter of our foes will cause wretchlings, quasits, and even thaurheregs to spring up from their corpses.  With a little bit of luck and some decisive early skirmishes, we could even bypass the problem of getting an invasion force to the surface entirely, growing it there instead.", "_t")
t("One of the problems with making daelach is the inherent instability that comes from creating something that is almost entirely made of magic.  If ambient levels of blight are even slightly too high, it can set off a chain reaction that at best destroys the daelach, and at worst destroys most of the mages who were building it.  Daelach production is thus theoretically cheap, but in practice involves great expense, and usually a blighted daelach has to be immediately put down lest it cause tremendous damage.  One specimen, though, adapted to the blight in a very interesting way, sprouting wings and bolstering its usual firestorms with blight, but otherwise remaining perfectly balanced and controllable.  We'll try to recreate this happy accident however we can, but in the meantime, it will prove effective on the surface of Eyal.", "One of the problems with making daelach is the inherent instability that comes from creating something that is almost entirely made of magic.  If ambient levels of blight are even slightly too high, it can set off a chain reaction that at best destroys the daelach, and at worst destroys most of the mages who were building it.  Daelach production is thus theoretically cheap, but in practice involves great expense, and usually a blighted daelach has to be immediately put down lest it cause tremendous damage.  One specimen, though, adapted to the blight in a very interesting way, sprouting wings and bolstering its usual firestorms with blight, but otherwise remaining perfectly balanced and controllable.  We'll try to recreate this happy accident however we can, but in the meantime, it will prove effective on the surface of Eyal.", "_t")
t("demon statue: Harkor'Zun", "demon statue: Harkor'Zun", "_t")
t("Of the anomalies and phenomena we've noticed in our studies of the shield protecting Eyal, none have frustrated us so much as meteors.  Certain powerful Eyalite spellcasters can pull a large meteor into low orbit, passing it through the shield relatively unharmed, aside from being split into predictably-sized chunks, which are then called to the surface one-by-one in a series of devastating meteoric crashes.  While we have not yet found a way to reverse-engineer these spells to protect our standard troops from disintegration, we have had some limited success in making a construct that closely resembles a meteor in composition and appearance.  Harkor'Zun, a being made mostly of stone, was simply dropped from our platform; the shield shattered him as expected, but we had designed him to survive this, the fragments merging back into their completed form once he reached the surface.  It would seem, though, that either we made him to be too sturdy, or the shield envelops incoming objects in a sort of anti-magic coating, as he has been unable to start the second stage of this process, wherein he merges these fragments back into a completed form.  Should an Eyalite stumble upon him and attempt to destroy the fragments, Harkor'Zun will be able to re-combine and \"thank\" whoever granted him his ascension.", "Of the anomalies and phenomena we've noticed in our studies of the shield protecting Eyal, none have frustrated us so much as meteors.  Certain powerful Eyalite spellcasters can pull a large meteor into low orbit, passing it through the shield relatively unharmed, aside from being split into predictably-sized chunks, which are then called to the surface one-by-one in a series of devastating meteoric crashes.  While we have not yet found a way to reverse-engineer these spells to protect our standard troops from disintegration, we have had some limited success in making a construct that closely resembles a meteor in composition and appearance.  Harkor'Zun, a being made mostly of stone, was simply dropped from our platform; the shield shattered him as expected, but we had designed him to survive this, the fragments merging back into their completed form once he reached the surface.  It would seem, though, that either we made him to be too sturdy, or the shield envelops incoming objects in a sort of anti-magic coating, as he has been unable to start the second stage of this process, wherein he merges these fragments back into a completed form.  Should an Eyalite stumble upon him and attempt to destroy the fragments, Harkor'Zun will be able to re-combine and \"thank\" whoever granted him his ascension.", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/quests/re-abducted.lua"
-- 1 entries
t("#LIGHT_GREEN#* #WHITE#", "#LIGHT_GREEN#* #WHITE#", "_t")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/data/talents/corruptions/demon-seeds.lua"
-- 1 entries
t("", "", "log")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/class/Object.lua"
-- 1 entries
t("[%s] (%d, %s)", "[%s] (%d, %s)", "tformat")


------------------------------------------------
section "game/dlcs/tome-ashes-urhrok/superload/mod/dialogs/Birther.lua"
-- 1 entries
t(", ", ", ", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/data/chats/fanged-collar.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/data/general/objects/world-artifacts.lua"
-- 1 entries
t("assault the mind of a foe to utterly dominate it", "assault the mind of a foe to utterly dominate it", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/data/lore/fay-willows.lua"
-- 10 entries
t("Escapades of Fay Willows [Book 5, Chapter 4] - Confrontation", "Escapades of Fay Willows [Book 5, Chapter 4] - Confrontation", "_t")
t([[[i]I was oddly able to get back on my feet quite easily after receiving the initial healing spell cast on me, perhaps even quicker than what was normally possibly. This would hold true to the additional healing I would receive moments after. There is something about the chaotic energies within me that interacts with my body and allows it to mend quicker with the more hate I feel. This isn't something I can easily take advantage of however and should the hatred within me dissipate before I receive any medical attention it will result in a long and arduous recovery time.[/i]

It was at that point in the battle that I knew we had won. The bone giants that remained still proved to be quite a threat, but with enough overwhelming force we eventually got through their defenses and defeated them. As the last of the undead were felled the defenders began to break into another victory cheer. I was about to join them but I noticed the bright glow of another healing spell enveloping me once more. Turning around I noticed that the spell was being cast by one of the healers this time. "Get Fay healed as quickly as possibly doctor, I want her back in peak form as fast as possible." Hearing my name I wondered just who this shalore was as few in Elvala knew my name.

As the shalore took off his helmet I immediately would come to recognize Aranion Gawaeil's face. Speaking quickly to me he stated, "We will be exiting through the Shroud to see if we can catch whoever was responsible for this attack. Judging how the undead were acting, it is likely that whoever sent these attacks must be nearby." Registering his words I silently nodded to him, after which he proceeded to put back on his helmet and look out towards the direction of the Shroud. When the healer's healing spell was finished, Aranion directed the healer to get the wounded to the healing grounds, before holding out his hand in my direction. Readying myself I took a deep breath and took his hand.

In an instant Aranion cast a spell to teleport us to the other side of the Shroud. Taking a moment to get my bearings, it didn't take long for us to notice the retreating undead group, or the lone cloaked figure moving among them. I didn't have much time to glimpse at my surroundings before Aranion motioned me to follow. Keeping a good distance we shadowed the undead as we followed them to the northwest. For a couple of days we traveled just west of the Nargol borders, passing many destroyed settlements which showed signs of being recently attacked. I had guessed that the Nargols had attempted to reclaim these settlements, only for them to be attacked and their inhabitants turned into undead thralls, the same of which likely attacked Elvala.

After a time we slowly made our way into another settlement after the undead force, only to notice them stop therein. Nearing the edge of one of the buildings to catch a glimpse of what they were doing we spied the cloaked figure near a well. Out from one of the buildings a couple of skeletons emerged carrying some food on a plate. Whispering in a hushed voice Aranion quietly stated, "It appears, unlike the undead following him, our friend here is alive." As if on cue to Aranion's statement, a low raspy voice spoke from the cloaked figure saying, "Yes very much so alive." Dead silence permeated the air for a long moment after that, apart from the sound of food being eaten by the figure.

The entire time this was happening, the undead stood motionless. Sensing that the figured wished to talk, Aranion stepped out in full view, hand on his weapon but not yet drawn. Seeing Aranion come into view the figure stated, "Ahhhh, you were the one who was capable of crushing my creations in one blow, I must say I wasn't expecting someone to be capable of that, well done. Although your abilities in stealth are perhaps not as notable." At that moment Aranion drew his sword and stood at the ready with it stating, "I'd very much like to crush the creator as well." To this a raspy laugh escaped from the cloaked figure before a hand appeared and motioned towards Aranion to try.

Without hesitation Aranion immediately began charging forwards. Reacting to the sudden movement, the undead quickly moved to form a defensive line and block Aranion's approach. Consisting mostly of mages and archers at this point, they laid down a volley of projectiles and magic in Aranion's direction. In a mere instant Aranion teleported himself next to the cloaked figure, avoiding it all entirely. Reacting to this, the cloaked figure produced a sphere of protective magical energy to meet Aranion's attack. Tightly gripping his sword with both hands, Aranion raised it above his head and brought it down in a powerful swing. After that I am not sure as to what happened as a bright flash shot forward as the two powerful combatants clashed.

I'm not entirely sure of what had happened, but what I do know is that there was an explosion of energy that erupted between Aranion and the necromancer, creating a shock wave that ripped through the remnants of the settlement. Finding myself within one of the buildings I stumbled to my feet and attempted to reorient myself. When I was able to, I made my way out to the hole in the wall I had been thrown through to survey what had happened outside. Looking around all I could see was a scene of destruction as torn ground, ruined buildings, and charred air remained. Stepping out from the building my foot crushed one of many shattered bones that now lay strewn about the battlefield. This would unfortunately be noticed by several skeletons that had survived the blast.

When they raised their weapons in my general direction I knew I needed to act quickly. I approached a couple of the closer ones and deftly broke them into pieces with a couple well placed strikes. I was about to charge towards the rest but then I noticed a couple of the skeletons raising staves in my direction. Rapidly I dove behind the rubble of a nearby building and hid from the barrage of magic that lit up the space I had just been in. Getting to my feet and holding my weapon tightly I could hear them advancing towards my position. I readied myself and waited for the skeletons to come closer and watched for the moment when they would appear around the corner.]], [[[i]I was oddly able to get back on my feet quite easily after receiving the initial healing spell cast on me, perhaps even quicker than what was normally possibly. This would hold true to the additional healing I would receive moments after. There is something about the chaotic energies within me that interacts with my body and allows it to mend quicker with the more hate I feel. This isn't something I can easily take advantage of however and should the hatred within me dissipate before I receive any medical attention it will result in a long and arduous recovery time.[/i]

It was at that point in the battle that I knew we had won. The bone giants that remained still proved to be quite a threat, but with enough overwhelming force we eventually got through their defenses and defeated them. As the last of the undead were felled the defenders began to break into another victory cheer. I was about to join them but I noticed the bright glow of another healing spell enveloping me once more. Turning around I noticed that the spell was being cast by one of the healers this time. "Get Fay healed as quickly as possibly doctor, I want her back in peak form as fast as possible." Hearing my name I wondered just who this shalore was as few in Elvala knew my name.

As the shalore took off his helmet I immediately would come to recognize Aranion Gawaeil's face. Speaking quickly to me he stated, "We will be exiting through the Shroud to see if we can catch whoever was responsible for this attack. Judging how the undead were acting, it is likely that whoever sent these attacks must be nearby." Registering his words I silently nodded to him, after which he proceeded to put back on his helmet and look out towards the direction of the Shroud. When the healer's healing spell was finished, Aranion directed the healer to get the wounded to the healing grounds, before holding out his hand in my direction. Readying myself I took a deep breath and took his hand.

In an instant Aranion cast a spell to teleport us to the other side of the Shroud. Taking a moment to get my bearings, it didn't take long for us to notice the retreating undead group, or the lone cloaked figure moving among them. I didn't have much time to glimpse at my surroundings before Aranion motioned me to follow. Keeping a good distance we shadowed the undead as we followed them to the northwest. For a couple of days we traveled just west of the Nargol borders, passing many destroyed settlements which showed signs of being recently attacked. I had guessed that the Nargols had attempted to reclaim these settlements, only for them to be attacked and their inhabitants turned into undead thralls, the same of which likely attacked Elvala.

After a time we slowly made our way into another settlement after the undead force, only to notice them stop therein. Nearing the edge of one of the buildings to catch a glimpse of what they were doing we spied the cloaked figure near a well. Out from one of the buildings a couple of skeletons emerged carrying some food on a plate. Whispering in a hushed voice Aranion quietly stated, "It appears, unlike the undead following him, our friend here is alive." As if on cue to Aranion's statement, a low raspy voice spoke from the cloaked figure saying, "Yes very much so alive." Dead silence permeated the air for a long moment after that, apart from the sound of food being eaten by the figure.

The entire time this was happening, the undead stood motionless. Sensing that the figured wished to talk, Aranion stepped out in full view, hand on his weapon but not yet drawn. Seeing Aranion come into view the figure stated, "Ahhhh, you were the one who was capable of crushing my creations in one blow, I must say I wasn't expecting someone to be capable of that, well done. Although your abilities in stealth are perhaps not as notable." At that moment Aranion drew his sword and stood at the ready with it stating, "I'd very much like to crush the creator as well." To this a raspy laugh escaped from the cloaked figure before a hand appeared and motioned towards Aranion to try.

Without hesitation Aranion immediately began charging forwards. Reacting to the sudden movement, the undead quickly moved to form a defensive line and block Aranion's approach. Consisting mostly of mages and archers at this point, they laid down a volley of projectiles and magic in Aranion's direction. In a mere instant Aranion teleported himself next to the cloaked figure, avoiding it all entirely. Reacting to this, the cloaked figure produced a sphere of protective magical energy to meet Aranion's attack. Tightly gripping his sword with both hands, Aranion raised it above his head and brought it down in a powerful swing. After that I am not sure as to what happened as a bright flash shot forward as the two powerful combatants clashed.

I'm not entirely sure of what had happened, but what I do know is that there was an explosion of energy that erupted between Aranion and the necromancer, creating a shock wave that ripped through the remnants of the settlement. Finding myself within one of the buildings I stumbled to my feet and attempted to reorient myself. When I was able to, I made my way out to the hole in the wall I had been thrown through to survey what had happened outside. Looking around all I could see was a scene of destruction as torn ground, ruined buildings, and charred air remained. Stepping out from the building my foot crushed one of many shattered bones that now lay strewn about the battlefield. This would unfortunately be noticed by several skeletons that had survived the blast.

When they raised their weapons in my general direction I knew I needed to act quickly. I approached a couple of the closer ones and deftly broke them into pieces with a couple well placed strikes. I was about to charge towards the rest but then I noticed a couple of the skeletons raising staves in my direction. Rapidly I dove behind the rubble of a nearby building and hid from the barrage of magic that lit up the space I had just been in. Getting to my feet and holding my weapon tightly I could hear them advancing towards my position. I readied myself and waited for the skeletons to come closer and watched for the moment when they would appear around the corner.]], "_t")
t("Escapades of Fay Willows [Book 5, Chapter 5] - Staff of Bones", "Escapades of Fay Willows [Book 5, Chapter 5] - Staff of Bones", "_t")
t([[[i]First rule of combat, always have a plan of escape ready in case you get into trouble. Second rule of combat, understand when escape is not an option. Third rule of combat, don't put yourself in a position where you will get flanked on multiple sides. Fourth rule of combat, don't exhaust yourselves before the conclusion of a fight. Fifth rule of combat, don't die.[/i]

Unfortunately not as mindless as I thought they would be, the skeletons were smart enough to keep their distance as they rounded the corner. Cursing, I began to run as fast as I could in an attempt to close the gap as fast as possible as the skeletons sent forth a volley of spells. My anger exploding at this point I felt a chaotic rush of energy fill me and in the next moment I was cleaving my weapon through the body of one of the mages from the side. Not missing a beat at my movement, the other skeleton promptly turned to face the new direction and unleashed a searing ray of arcane energies that clipped through my shoulder. I was about to converge on the other skeleton, but an arrow would then pierce through my foot and pin me to the ground.

Realizing I needed to end this quickly, I raised my arm and immediately discharged my heat beam rune into the other mage, before rushing after the archer that had loosed the arrow. Seeing my advance it released another arrow in my direction which I sidestepped out of the way of with ease. In the next moment I was on top of the archer, senselessly battering it into submission with a relentlessly torrent of blows. When the archer was dealt with I turned once more to look in the direction of the skeleton mage. Merely walking over to it I simply cast my arm out and knocked its skull from its skeletal frame before it had a chance to cast another spell.

I panted heavily for the next few moments as the hatred within me slowly began to subside once again. As I slowly caught my breath then heard the distinct sound of applause and looking for the source of I spied the cloaked figure of the necromancer nearby. As the clapping finished, the necromancer began to speak, "Well done, well done." Checking my surroundings I could not see Aranion around in our vicinity, making me wonder what had happened to him. Deciding to inquire as to Aranion whereabouts I asked, "Where's Aranion." To this I got the response "Oh? As in Aranion Gawaeil? Well, the general is occupied, at least for the moment. Likely he'll be back soon but for now I think I'll entertain myself with you."

A cold feeling immediately took hold of me as the necromancer finished its sentence and abruptly began to wheeze and chuckle. As I approached with my weapon drawn and ready to swing my weapon the necromancer reached within its cloak and teleported away to a pile of shattered bones. I froze in place as a dark sensation as the necromancer pulled something out, something that I knew held great power, great and terrible. Attempting to discern the object, I was able to make out a short thin staff, but not one that looked to be made of any material I had seen a staff made of before. Perhaps sensing my awareness of the staff the necromancer spoke again, "Oh? You don't seem to be a mage yet you can feel this dark power can't you?"

"Bones are so interesting you know, they can tell you a lot about a person. You can learn their owner's identity, where and when they lived, how old they were when they died, the injuries and hardships they had suffered in their lives, and so forth. Quite fascinating really, of course studying them is quite frowned upon, quite bothersome really." The necromancer began to cough and wheeze a few time before continuing. "Some of the most peculiar bones I've come across can be found within my staff, and when I find some peculiar bones I would like to add to my staff..." The sentence trailed off and the necromancer started to chuckle. A chill then went down my spine as I could feel the dark intentions of the necromancer focusing on me.

I watched the necromancer make quick motion of the staff towards the bone pile causing all the bones within the pile to begin to organize themselves into a mass of towering bones. Limbs of all manner of terror and death began to form as a new bone giant was created. The necromancer let loose a raspy joyous cackle before indicating to the bone giant with a motion of the staff that I was an enemy to be clobbered. Responding to the command the bone giant started moving in my direction. Looking to inflict the first blow I unleashed as powerful an attack as I could against the abomination, I charged forward and attacked one of its legs, hoping to knock it off balance and gain a quick advantage over it.

Much like before in Elvala however, this bone giant too would shift its bones around to reinforce the damage I inflicted on it, managing to negate the efforts of my attack. In the next moment I could do nothing as it suddenly shot forth one of its limbs and caught me in the arm. The spikes and razor sharp joints tore through the armor covering my shoulder causing great pain. In an attempt to return a blow I pushed forward again, but due to the pain from my received injury I was prevented from mustering all the physical force that I could. Hatred began to boil within me as I was knocked around by heavy blows before finally I unleashed my chaotic energies into the bone giant in an attempt to stunt its movements.

The bone giant quickly began to falter and become clumsy, my chaotic energies interfering with its ability to move. Trying to attack me while under the pressure of my hatred its attacks became slow and readable and I was able to dodge them. Now on the offensive I slashed heavily against the creature all over its body in an attempt to overwhelm it. Once again a barrier of bones formed to defend it, but not the least bit discouraged I relentlessly continued my attack, eventually breaking through. Unable to withstand my continual ferocity its bones flew in all directions as I tore through it from front to back. Now standing facing the necromancer, I could hear the bone giant behind me collapse back into a pile of bones once more.]], [[[i]First rule of combat, always have a plan of escape ready in case you get into trouble. Second rule of combat, understand when escape is not an option. Third rule of combat, don't put yourself in a position where you will get flanked on multiple sides. Fourth rule of combat, don't exhaust yourselves before the conclusion of a fight. Fifth rule of combat, don't die.[/i]

Unfortunately not as mindless as I thought they would be, the skeletons were smart enough to keep their distance as they rounded the corner. Cursing, I began to run as fast as I could in an attempt to close the gap as fast as possible as the skeletons sent forth a volley of spells. My anger exploding at this point I felt a chaotic rush of energy fill me and in the next moment I was cleaving my weapon through the body of one of the mages from the side. Not missing a beat at my movement, the other skeleton promptly turned to face the new direction and unleashed a searing ray of arcane energies that clipped through my shoulder. I was about to converge on the other skeleton, but an arrow would then pierce through my foot and pin me to the ground.

Realizing I needed to end this quickly, I raised my arm and immediately discharged my heat beam rune into the other mage, before rushing after the archer that had loosed the arrow. Seeing my advance it released another arrow in my direction which I sidestepped out of the way of with ease. In the next moment I was on top of the archer, senselessly battering it into submission with a relentlessly torrent of blows. When the archer was dealt with I turned once more to look in the direction of the skeleton mage. Merely walking over to it I simply cast my arm out and knocked its skull from its skeletal frame before it had a chance to cast another spell.

I panted heavily for the next few moments as the hatred within me slowly began to subside once again. As I slowly caught my breath then heard the distinct sound of applause and looking for the source of I spied the cloaked figure of the necromancer nearby. As the clapping finished, the necromancer began to speak, "Well done, well done." Checking my surroundings I could not see Aranion around in our vicinity, making me wonder what had happened to him. Deciding to inquire as to Aranion whereabouts I asked, "Where's Aranion." To this I got the response "Oh? As in Aranion Gawaeil? Well, the general is occupied, at least for the moment. Likely he'll be back soon but for now I think I'll entertain myself with you."

A cold feeling immediately took hold of me as the necromancer finished its sentence and abruptly began to wheeze and chuckle. As I approached with my weapon drawn and ready to swing my weapon the necromancer reached within its cloak and teleported away to a pile of shattered bones. I froze in place as a dark sensation as the necromancer pulled something out, something that I knew held great power, great and terrible. Attempting to discern the object, I was able to make out a short thin staff, but not one that looked to be made of any material I had seen a staff made of before. Perhaps sensing my awareness of the staff the necromancer spoke again, "Oh? You don't seem to be a mage yet you can feel this dark power can't you?"

"Bones are so interesting you know, they can tell you a lot about a person. You can learn their owner's identity, where and when they lived, how old they were when they died, the injuries and hardships they had suffered in their lives, and so forth. Quite fascinating really, of course studying them is quite frowned upon, quite bothersome really." The necromancer began to cough and wheeze a few time before continuing. "Some of the most peculiar bones I've come across can be found within my staff, and when I find some peculiar bones I would like to add to my staff..." The sentence trailed off and the necromancer started to chuckle. A chill then went down my spine as I could feel the dark intentions of the necromancer focusing on me.

I watched the necromancer make quick motion of the staff towards the bone pile causing all the bones within the pile to begin to organize themselves into a mass of towering bones. Limbs of all manner of terror and death began to form as a new bone giant was created. The necromancer let loose a raspy joyous cackle before indicating to the bone giant with a motion of the staff that I was an enemy to be clobbered. Responding to the command the bone giant started moving in my direction. Looking to inflict the first blow I unleashed as powerful an attack as I could against the abomination, I charged forward and attacked one of its legs, hoping to knock it off balance and gain a quick advantage over it.

Much like before in Elvala however, this bone giant too would shift its bones around to reinforce the damage I inflicted on it, managing to negate the efforts of my attack. In the next moment I could do nothing as it suddenly shot forth one of its limbs and caught me in the arm. The spikes and razor sharp joints tore through the armor covering my shoulder causing great pain. In an attempt to return a blow I pushed forward again, but due to the pain from my received injury I was prevented from mustering all the physical force that I could. Hatred began to boil within me as I was knocked around by heavy blows before finally I unleashed my chaotic energies into the bone giant in an attempt to stunt its movements.

The bone giant quickly began to falter and become clumsy, my chaotic energies interfering with its ability to move. Trying to attack me while under the pressure of my hatred its attacks became slow and readable and I was able to dodge them. Now on the offensive I slashed heavily against the creature all over its body in an attempt to overwhelm it. Once again a barrier of bones formed to defend it, but not the least bit discouraged I relentlessly continued my attack, eventually breaking through. Unable to withstand my continual ferocity its bones flew in all directions as I tore through it from front to back. Now standing facing the necromancer, I could hear the bone giant behind me collapse back into a pile of bones once more.]], "_t")
t("Escapades of Fay Willows [Book 5, Chapter 6] - Evil Malice", "Escapades of Fay Willows [Book 5, Chapter 6] - Evil Malice", "_t")
t([[[i]There is truly no other way to describe the necromancer that I met but completely evil. One might consider the magic hating fanatics I had written about in my earlier books as evil, but even from them I could sense that they were attempting to bring about a better world, despite how twisted their actions might have been. This fiend of undeath though, I could sense no goodwill from, and the actions undertaken seemed to be only for the purpose of personal amusement. Judging from emotions that I could feel from the magic as well, I don't think that necromancy could ever be used by anyone other than those of an evil nature.[/i]

As I felled the bone giant I could hear the necromancer clapping once more. "Very good, well done, quite the display. Your bones will truly be worth adding to my staff,” the necromancer stated in sinister tone. Turning my head towards necromancer I stated boldly, "It will take more than your mere bone giant to kill me." Seemingly caught in thought to my statement the necromancer replied, "Hmmm, bone giant, quite the name. Yes, I think that will do nicely as a name. Of course, you seem to be misunderstanding something. The bone giant, as you call it, is not quite dead yet." Registering the words, I didn't have much time to react before I could feel a hard blow swat me from the side.

Snapping my eyes to what had hit me, I immediately realized that the bone giant was indeed not defeated as it stepped forward to stand in between me and the necromancer. What's more, it had seemed that it had reassembled itself into a new fiendish form that was ready to do battle. As the bone giant approached to attack me I could hear the voice of the necromancer in the background as are battle began to start again. "These Bone Giants as you call them are quite something aren't they. I got inspiration for them from the Nargols when they fought against the Conclave in the Allure Wars. You see, few know this but the Nargols actually used necromancy to ultimately win their fight against the Conclave."

I could hear the necromancer wheeze and cackle in the background for a moment, but I was more concerned with the bone giant attacking me. Somewhat exhausted from beating it down the first time I lacked the strength to overcome its defenses a second time and bring it down again. I slowly proceeded to back away in order to buy some time and examine my options in regards to what I might be able to do to defeat it. The swirling barrier of bones were already circling its body, and I knew that I wouldn't be able to do any lasting damage against it as a result. Sooner or later I would have to commit to fighting it fully, and I knew that I would want to make that commitment on my own terms.

Distressingly however, finding an opportunity was made more difficult as the necromancer continued to prattle on. "These bone giants as you call them, they can be formed in a variety of ways to kill and as you can see they are quite durable. I'm actually quite thankful that you managed to rip through it as you did just now, I can already see ways in which I can improve my next one." Concluding the sentence the necromancer began to laugh and wheeze once more. It was quite infuriating, and I'm not even sure why I remember the necromancer's words so vividly. However, I would not be bested by the bone giant and I decided that I would try to make a final stand and bring it down again.

I rushed into the bone giant, taking a quick swipe that knocked a few bones away. Noticing that the bone barrier didn't absorb the blow I quickly realized that it had since dissipated. Sensing that I only had a brief moment before it would come back, I fully committed to unleashing as much power as I could within the next strike. Hitting with all the strength I could muster I quickly knocked away a good chunk of the bone giant’s mid section, causing it to stumble a bit. Once again like before it attempted to shift its bones around in order to maintain itself, but my attacks were chipping bones away bit by bit. However, the bone giant would not allow itself to be defeated so easily.

With a quick motion the bone giant shot forth one of its limbs against me, once again ripping against my flesh with painful spikes. Not discouraged by this in the slightest however, I let loose my heat beam rune and ignited its bones, and more importantly I relieved the pain from the blow. As I resumed my attacks I could hear the raspy voice in the background seemingly comment, "Hmm, runes... ohhh! I know, I'll graft some runes onto the next one! What interesting ideas you are giving me." Still focused on my fight, I continued to strike it again and again until finally the bone giant fell apart. Not sure if it would get up again I continued to hack at it until I had completely disassembled it.

Forgetting about the necromancer though, I immediately felt my body go numb, and quickly noticed ice forming all around my body. Immobilized, I darted my eyes around before spying the necromancer with an outstretched hand. Slowly the necromancer approached me, coming around to my left arm where my heat beam rune was inscribed. Putting its hand under what I assumed to be its chin, the necromancer noted, "Not once but twice you have defeated my bone giant. I suspected you might be able to bring it down once, but bringing it down again right after was quite unexpected. Now, I really have to wonder who you are? You appear to be a thalore to me, but what were you doing in Elvala? Hmmm."

Continuing around me to stand in front before circling around to my right, necromancer continued to make "hmm, hmm" sounds. Proceeding to stop the necromancer began to muse aloud once more, "Quite surprising seeing you use runes. Are you a criminal exiled from the forests perhaps? Wait, what's this second rune you have inscribed?" While I couldn't see the necromancer I could feel the intent staring at the Rune of Return that had been inscribed on the back of my neck. From behind a remark rang out, "Ahh, interesting. A shaloren design but judging from the markings it appears an ogre's handiwork was involved in inscribing this rune if I am not mistaken. Quite intriguing."

The necromancer continued to talk aloud for several moments as he circled around me again and again, which was fine by me. I could feel the arcane energy replenishing within my heat beam rune, and when I had the chance I would activate it and release myself from my icy imprisonment. Perhaps aware of my intent though the necromancer quickly glanced at my eyes before stating, "You are quite an oddity aren't you? However, you aren't much the conversationalist so there is little reason for me to keep you alive. I can easily study your corpse instead of leaving you alive you see." I could sense the magic beginning to accumulate in one of the necromancer's hands as he concluded by saying, "Farewell thalore." ]], [[[i]There is truly no other way to describe the necromancer that I met but completely evil. One might consider the magic hating fanatics I had written about in my earlier books as evil, but even from them I could sense that they were attempting to bring about a better world, despite how twisted their actions might have been. This fiend of undeath though, I could sense no goodwill from, and the actions undertaken seemed to be only for the purpose of personal amusement. Judging from emotions that I could feel from the magic as well, I don't think that necromancy could ever be used by anyone other than those of an evil nature.[/i]

As I felled the bone giant I could hear the necromancer clapping once more. "Very good, well done, quite the display. Your bones will truly be worth adding to my staff,” the necromancer stated in sinister tone. Turning my head towards necromancer I stated boldly, "It will take more than your mere bone giant to kill me." Seemingly caught in thought to my statement the necromancer replied, "Hmmm, bone giant, quite the name. Yes, I think that will do nicely as a name. Of course, you seem to be misunderstanding something. The bone giant, as you call it, is not quite dead yet." Registering the words, I didn't have much time to react before I could feel a hard blow swat me from the side.

Snapping my eyes to what had hit me, I immediately realized that the bone giant was indeed not defeated as it stepped forward to stand in between me and the necromancer. What's more, it had seemed that it had reassembled itself into a new fiendish form that was ready to do battle. As the bone giant approached to attack me I could hear the voice of the necromancer in the background as are battle began to start again. "These Bone Giants as you call them are quite something aren't they. I got inspiration for them from the Nargols when they fought against the Conclave in the Allure Wars. You see, few know this but the Nargols actually used necromancy to ultimately win their fight against the Conclave."

I could hear the necromancer wheeze and cackle in the background for a moment, but I was more concerned with the bone giant attacking me. Somewhat exhausted from beating it down the first time I lacked the strength to overcome its defenses a second time and bring it down again. I slowly proceeded to back away in order to buy some time and examine my options in regards to what I might be able to do to defeat it. The swirling barrier of bones were already circling its body, and I knew that I wouldn't be able to do any lasting damage against it as a result. Sooner or later I would have to commit to fighting it fully, and I knew that I would want to make that commitment on my own terms.

Distressingly however, finding an opportunity was made more difficult as the necromancer continued to prattle on. "These bone giants as you call them, they can be formed in a variety of ways to kill and as you can see they are quite durable. I'm actually quite thankful that you managed to rip through it as you did just now, I can already see ways in which I can improve my next one." Concluding the sentence the necromancer began to laugh and wheeze once more. It was quite infuriating, and I'm not even sure why I remember the necromancer's words so vividly. However, I would not be bested by the bone giant and I decided that I would try to make a final stand and bring it down again.

I rushed into the bone giant, taking a quick swipe that knocked a few bones away. Noticing that the bone barrier didn't absorb the blow I quickly realized that it had since dissipated. Sensing that I only had a brief moment before it would come back, I fully committed to unleashing as much power as I could within the next strike. Hitting with all the strength I could muster I quickly knocked away a good chunk of the bone giant’s mid section, causing it to stumble a bit. Once again like before it attempted to shift its bones around in order to maintain itself, but my attacks were chipping bones away bit by bit. However, the bone giant would not allow itself to be defeated so easily.

With a quick motion the bone giant shot forth one of its limbs against me, once again ripping against my flesh with painful spikes. Not discouraged by this in the slightest however, I let loose my heat beam rune and ignited its bones, and more importantly I relieved the pain from the blow. As I resumed my attacks I could hear the raspy voice in the background seemingly comment, "Hmm, runes... ohhh! I know, I'll graft some runes onto the next one! What interesting ideas you are giving me." Still focused on my fight, I continued to strike it again and again until finally the bone giant fell apart. Not sure if it would get up again I continued to hack at it until I had completely disassembled it.

Forgetting about the necromancer though, I immediately felt my body go numb, and quickly noticed ice forming all around my body. Immobilized, I darted my eyes around before spying the necromancer with an outstretched hand. Slowly the necromancer approached me, coming around to my left arm where my heat beam rune was inscribed. Putting its hand under what I assumed to be its chin, the necromancer noted, "Not once but twice you have defeated my bone giant. I suspected you might be able to bring it down once, but bringing it down again right after was quite unexpected. Now, I really have to wonder who you are? You appear to be a thalore to me, but what were you doing in Elvala? Hmmm."

Continuing around me to stand in front before circling around to my right, necromancer continued to make "hmm, hmm" sounds. Proceeding to stop the necromancer began to muse aloud once more, "Quite surprising seeing you use runes. Are you a criminal exiled from the forests perhaps? Wait, what's this second rune you have inscribed?" While I couldn't see the necromancer I could feel the intent staring at the Rune of Return that had been inscribed on the back of my neck. From behind a remark rang out, "Ahh, interesting. A shaloren design but judging from the markings it appears an ogre's handiwork was involved in inscribing this rune if I am not mistaken. Quite intriguing."

The necromancer continued to talk aloud for several moments as he circled around me again and again, which was fine by me. I could feel the arcane energy replenishing within my heat beam rune, and when I had the chance I would activate it and release myself from my icy imprisonment. Perhaps aware of my intent though the necromancer quickly glanced at my eyes before stating, "You are quite an oddity aren't you? However, you aren't much the conversationalist so there is little reason for me to keep you alive. I can easily study your corpse instead of leaving you alive you see." I could sense the magic beginning to accumulate in one of the necromancer's hands as he concluded by saying, "Farewell thalore." ]], "_t")
t("Escapades of Fay Willows [Book 5, Chapter 7] - Powers of Undeath", "Escapades of Fay Willows [Book 5, Chapter 7] - Powers of Undeath", "_t")
t([[[i]Something that I have always wondered about is why people give names to inanimate objects. Aranion would lose hold of his weapon at some point during the fight with the Necromancer, though I'm not specifically sure at what time in the fight this would be. Even now as I write this, Aranion frets over his lost sword as if he had lost a loved one. While I can understand how one can get accustomed to a weapon, surely he can find another to use instead?[/i]

Sensing that I needed to act now, I activated the heat beam rune, melting the ice around and me and sending a surging blast of fire towards the necromancer. As the necromancer stumbled back in flames as I took the moment to heave my weapon forward with all the force I could muster, only to pierce through nothing as the necromancer disappeared. Before I had a chance to see where the necromancer had teleported too, a burst of hot flames enveloped me from behind. Turning around I could see the necromancer, singed yet no longer on fire. I had been read completely and now I danced around in searing pain as every inch of my body burned. The necromancer cackled as I noticed the heat beam rune inscribed on the bottom of his outstretched arm.

Annoyed at how easily I had been handled, I grit my teeth and charged forward at the necromancer, only to be stopped by several undead blocking my way. Cackling some more, I felt a sharp pain cut through me as the necromancer released a dark beam of energy that shot through the skeletons and me. As I cringed in pain and had little time to react before the necromancer's minions began to attack me from all sides. Infuriated, I began to strike at everything surrounding me, tearing a path through the undead up to the necromancer. Coming face to face with the fiend I was about to deliver a great blow, but with a simple wave at me I felt a heavy force slam into my chest.

Darkness seemed to pierce my mind and try as I might I could not resist it. I was sent careening backwards where I slammed into a wall. My vision began to blur as I lay on the ground. Despite this however I could still hear the necromancer cackle before the yammering began again. "How pathetic, really you are. Fighting is more than just hitting things with overwhelming force! You are truly powerful thalore, but power in and of itself is meaningless. Your moves are too telegraphed, your attacks are easily countered, and you don't seem to have the slightest idea of how to strategize in combat. Oh well. Perhaps after I kill you I'll just raise your corpse as it is and show you how to properly engage yourself in a fight."

Despite my inability to remember things said to me, I remember those words quite well as they rang through my head. Poetically I could say that they pierced me more than any wound inflicted on me that day, but that would fail to describe just how many spellblasts and cursed spells would be sent into my body. For every action I would make the necromancer would be two steps ahead and for every mistake I would make I would pay dearly. As the battle went on I could feel my body beginning to grow colder and I knew that despite how tough I was I could not continue to sustain my fighting efforts for much longer. My desperation was perhaps just as noticeable as anything else by the necromancer.

Then at last my body could stand no more and I collapsed to the ground unable to move. Waves of cold and dark energy circulated within my body and I realized just how close to the limits of my own mortality I was. I remember as my thoughts turned over to past events of my life in that moment, to a time before the Spellblaze when I lived in the forests with my fellow thaloren, a simpler and more peaceful time to be sure. I didn't want to die, nor suffer whatever mad plans this necromancer would have for me either. Yet I could do nothing more now as the necromancer slowly approached to stand over me and say, "Such a fruitless effort thalore. Perhaps with time you would have become a notable hero of legend. But now you die."

In the next moment I could not describe to you the amount of pain that ripped through my body as the necromancer unleashed a deathly magic that tortured every fibre of my being. As I was engulfed in agony my mind slowly began to black out and I slowly edged closer and closer to death. I might have been killed had Aranion not managed to return just in time to interrupt the necromancer and cancel the spell cast on me. I don't know the specifics of what happened next after that, only that Aranion was somehow able to extract me and himself from the grasp of the necromancer and escape. Somehow I endured long enough after that for Aranion to cast a basic healing spell on me, enough to keep me alive until we returned to Elvala.

I briefly remember when I was initially recovering that I opened my eyes while laying in one of the medical beds back in Elvala. In a chair near me I saw my husband sleeping, waiting for me. I tried to call out but instead I let out a scream. My husband would call for a healer as my body was wracked in pain from the many injuries I had endured for so long. I would sleep for a long time after that, for how long I do not know, but the next time I woke up I would be in my own room within my house. Looking around once again I could see that it was nighttime, and my husband again sat sleeping in a chair, still waiting for me. For how long he waited I do not know.

Once more I called out saying his name "Awain". As he roused from his sleep and looked at me an endless amount of tears would begin streaming down his face. In a cracked voice I heard him say, "You're awake, you're still alive." He hurried over to me, putting his hands under me to embrace me tightly, and began sobbing uncontrollably. For the moment I allowed him to cry, feeling that I should hold back on inquiring as to how I had made it back to Elvala. I didn't know how long I had been unconscious but I had the feeling that he had waited the entire time for me, waiting for the moment I would come back to him. I embraced him back and sobbed too as we were reunited once more.]], [[[i]Something that I have always wondered about is why people give names to inanimate objects. Aranion would lose hold of his weapon at some point during the fight with the Necromancer, though I'm not specifically sure at what time in the fight this would be. Even now as I write this, Aranion frets over his lost sword as if he had lost a loved one. While I can understand how one can get accustomed to a weapon, surely he can find another to use instead?[/i]

Sensing that I needed to act now, I activated the heat beam rune, melting the ice around and me and sending a surging blast of fire towards the necromancer. As the necromancer stumbled back in flames as I took the moment to heave my weapon forward with all the force I could muster, only to pierce through nothing as the necromancer disappeared. Before I had a chance to see where the necromancer had teleported too, a burst of hot flames enveloped me from behind. Turning around I could see the necromancer, singed yet no longer on fire. I had been read completely and now I danced around in searing pain as every inch of my body burned. The necromancer cackled as I noticed the heat beam rune inscribed on the bottom of his outstretched arm.

Annoyed at how easily I had been handled, I grit my teeth and charged forward at the necromancer, only to be stopped by several undead blocking my way. Cackling some more, I felt a sharp pain cut through me as the necromancer released a dark beam of energy that shot through the skeletons and me. As I cringed in pain and had little time to react before the necromancer's minions began to attack me from all sides. Infuriated, I began to strike at everything surrounding me, tearing a path through the undead up to the necromancer. Coming face to face with the fiend I was about to deliver a great blow, but with a simple wave at me I felt a heavy force slam into my chest.

Darkness seemed to pierce my mind and try as I might I could not resist it. I was sent careening backwards where I slammed into a wall. My vision began to blur as I lay on the ground. Despite this however I could still hear the necromancer cackle before the yammering began again. "How pathetic, really you are. Fighting is more than just hitting things with overwhelming force! You are truly powerful thalore, but power in and of itself is meaningless. Your moves are too telegraphed, your attacks are easily countered, and you don't seem to have the slightest idea of how to strategize in combat. Oh well. Perhaps after I kill you I'll just raise your corpse as it is and show you how to properly engage yourself in a fight."

Despite my inability to remember things said to me, I remember those words quite well as they rang through my head. Poetically I could say that they pierced me more than any wound inflicted on me that day, but that would fail to describe just how many spellblasts and cursed spells would be sent into my body. For every action I would make the necromancer would be two steps ahead and for every mistake I would make I would pay dearly. As the battle went on I could feel my body beginning to grow colder and I knew that despite how tough I was I could not continue to sustain my fighting efforts for much longer. My desperation was perhaps just as noticeable as anything else by the necromancer.

Then at last my body could stand no more and I collapsed to the ground unable to move. Waves of cold and dark energy circulated within my body and I realized just how close to the limits of my own mortality I was. I remember as my thoughts turned over to past events of my life in that moment, to a time before the Spellblaze when I lived in the forests with my fellow thaloren, a simpler and more peaceful time to be sure. I didn't want to die, nor suffer whatever mad plans this necromancer would have for me either. Yet I could do nothing more now as the necromancer slowly approached to stand over me and say, "Such a fruitless effort thalore. Perhaps with time you would have become a notable hero of legend. But now you die."

In the next moment I could not describe to you the amount of pain that ripped through my body as the necromancer unleashed a deathly magic that tortured every fibre of my being. As I was engulfed in agony my mind slowly began to black out and I slowly edged closer and closer to death. I might have been killed had Aranion not managed to return just in time to interrupt the necromancer and cancel the spell cast on me. I don't know the specifics of what happened next after that, only that Aranion was somehow able to extract me and himself from the grasp of the necromancer and escape. Somehow I endured long enough after that for Aranion to cast a basic healing spell on me, enough to keep me alive until we returned to Elvala.

I briefly remember when I was initially recovering that I opened my eyes while laying in one of the medical beds back in Elvala. In a chair near me I saw my husband sleeping, waiting for me. I tried to call out but instead I let out a scream. My husband would call for a healer as my body was wracked in pain from the many injuries I had endured for so long. I would sleep for a long time after that, for how long I do not know, but the next time I woke up I would be in my own room within my house. Looking around once again I could see that it was nighttime, and my husband again sat sleeping in a chair, still waiting for me. For how long he waited I do not know.

Once more I called out saying his name "Awain". As he roused from his sleep and looked at me an endless amount of tears would begin streaming down his face. In a cracked voice I heard him say, "You're awake, you're still alive." He hurried over to me, putting his hands under me to embrace me tightly, and began sobbing uncontrollably. For the moment I allowed him to cry, feeling that I should hold back on inquiring as to how I had made it back to Elvala. I didn't know how long I had been unconscious but I had the feeling that he had waited the entire time for me, waiting for the moment I would come back to him. I embraced him back and sobbed too as we were reunited once more.]], "_t")
t("Escapades of Fay Willows [Book 5, Chapter 8] - From the Brink of Death", "Escapades of Fay Willows [Book 5, Chapter 8] - From the Brink of Death", "_t")
t([[Eventually when I got the story from my husband, I found out what had happened after the battle in detail. The necromancer had apparently fled or perhaps had allowed for Aranion to retreat with me back to Elvala. I was very close to death, but the healers worked tirelessly to stabilize my condition, although having difficulties doing so due to my Spellblaze Affliction and terrible injuries that had been wrought on my body by the necromancer's spells. For many days I remained within the medical facilities, as the healers worked to save my life, before eventually being relocated to my own home under the care of my husband.

At this point a sombre expression took hold of my husbands face, his eyes looking in the direction of my body. Lifting the covers up I soon understood why, seeing the blacken scars engraved into my body, a result of my recent battle. Meekly he told me that while the healers were sure I would live, the wounds inflicted on my body would leave deformed scars that would never heal. For a moment I sat still, as I contemplated what to say. Then smiling any without hesitation I looked up, pulling off the covers and made to stand. Pain surged through me as I did so but I stood in front of my husband nonetheless.

Awain's eyes darted around and his mouth stammered, until I looked him in his eyes and made my way over to kiss him. Raising my head I stated to him in a quiet tone, "I do not care how I look as long as you Awain still love me. That alone is enough for me to continue on." At this his body relaxed as I slowly descended to kiss him once more, being embraced within his arms. As I drew closer to him he quietly gave the response, "Yes Fay, I still do,” before he finally began to kiss me back. I remember that night as being one of my most cherished moments in my life. Despite my many travels and life prior I would change nothing for it.

Yet despite the incident that had brought me so close to dying, I knew in my heart that I yearned to leave Elvala once more for adventure. One may think it odd, but at the moment I left with Aranion from the exterior of the Shroud I was reminded of my initial travels that had brought me to Elvala in the first place. Though it has taken a couple decades for me to recover, I now prepare to exit through the Shroud once more to explore the world. Awain deeply disagrees with my decision to leave, but out of his love for me he won't stop me from going. I also know that should I ever truly find myself in danger I can use the Rune of Return still inscribed on me to return from danger.

From what I've learned from the Shaloren scouts there is now much happening outside Elvala's walls to serve as destinations to visit. Lawless bands of men now roam the nearby lands, some driven to banditry by desperation, others seeing an opportunity to take from others as a result of Nargols being unable to exact control over their lands as they once did. Despite our seclusion, it is a problem that affects us here in Elvala as well, as what little interaction we have with the outside world is made even more difficult. It is believed that a major hideout and staging area for attacks can be found in the Old Forest just to the north of here.

Rumours of those magic hating zealots are also abound as are the heinous atrocities that they commit. Their reach is vast and it is believed that they are influencing the politics of many Human Kingdoms and the Eldoral Halflings. No longer content to act in the shadows, trained bands of their anti-magic warriors scour the lands for any who cast magic or are in possession of items powered by the arcane. Curiously there is speculation about some ogres fighting among their ranks, though how that is possible I don't know. Still, I should be careful should I run into one of their traveling groups as I would have a difficult fight on my hands to be sure.

Outside of the various movements of such distasteful groups, some of the shaloren researching the effects caused by the Spellblaze believe that the most prevalent mark of destruction can likely be found along the Blackened Shoreline to the east of Elvala. This was the initial path that the destructive energies of the Spellblaze took and it is reasoned that a better understanding can be obtained by visiting the area. However, the shaloren know that venturing out past the Shroud would be dangerous, not to mention how hazardous those lands are. Despite the dangers, though, it is important to know just what sort of lasting damage the Spellblaze has left on our world.

[i]I won't be discouraged from leaving Elvala because of the battle I lost with the necromancer, though that doesn't mean I will rashly throw my life away either. There are people who need help and villainous schemes to be thwarted and if I can help with this task then I shall. I will be cautious in whatever I pursue in the outside world and you can be sure, Awain, that I will soon be writing another book of my escapades. Wait for me my dear husband for when I come home you know that the first thing I will do is return to your arms. But for now I set off from this land I call home to offer aid where I can.[/i] ]], [[Eventually when I got the story from my husband, I found out what had happened after the battle in detail. The necromancer had apparently fled or perhaps had allowed for Aranion to retreat with me back to Elvala. I was very close to death, but the healers worked tirelessly to stabilize my condition, although having difficulties doing so due to my Spellblaze Affliction and terrible injuries that had been wrought on my body by the necromancer's spells. For many days I remained within the medical facilities, as the healers worked to save my life, before eventually being relocated to my own home under the care of my husband.

At this point a sombre expression took hold of my husbands face, his eyes looking in the direction of my body. Lifting the covers up I soon understood why, seeing the blacken scars engraved into my body, a result of my recent battle. Meekly he told me that while the healers were sure I would live, the wounds inflicted on my body would leave deformed scars that would never heal. For a moment I sat still, as I contemplated what to say. Then smiling any without hesitation I looked up, pulling off the covers and made to stand. Pain surged through me as I did so but I stood in front of my husband nonetheless.

Awain's eyes darted around and his mouth stammered, until I looked him in his eyes and made my way over to kiss him. Raising my head I stated to him in a quiet tone, "I do not care how I look as long as you Awain still love me. That alone is enough for me to continue on." At this his body relaxed as I slowly descended to kiss him once more, being embraced within his arms. As I drew closer to him he quietly gave the response, "Yes Fay, I still do,” before he finally began to kiss me back. I remember that night as being one of my most cherished moments in my life. Despite my many travels and life prior I would change nothing for it.

Yet despite the incident that had brought me so close to dying, I knew in my heart that I yearned to leave Elvala once more for adventure. One may think it odd, but at the moment I left with Aranion from the exterior of the Shroud I was reminded of my initial travels that had brought me to Elvala in the first place. Though it has taken a couple decades for me to recover, I now prepare to exit through the Shroud once more to explore the world. Awain deeply disagrees with my decision to leave, but out of his love for me he won't stop me from going. I also know that should I ever truly find myself in danger I can use the Rune of Return still inscribed on me to return from danger.

From what I've learned from the Shaloren scouts there is now much happening outside Elvala's walls to serve as destinations to visit. Lawless bands of men now roam the nearby lands, some driven to banditry by desperation, others seeing an opportunity to take from others as a result of Nargols being unable to exact control over their lands as they once did. Despite our seclusion, it is a problem that affects us here in Elvala as well, as what little interaction we have with the outside world is made even more difficult. It is believed that a major hideout and staging area for attacks can be found in the Old Forest just to the north of here.

Rumours of those magic hating zealots are also abound as are the heinous atrocities that they commit. Their reach is vast and it is believed that they are influencing the politics of many Human Kingdoms and the Eldoral Halflings. No longer content to act in the shadows, trained bands of their anti-magic warriors scour the lands for any who cast magic or are in possession of items powered by the arcane. Curiously there is speculation about some ogres fighting among their ranks, though how that is possible I don't know. Still, I should be careful should I run into one of their traveling groups as I would have a difficult fight on my hands to be sure.

Outside of the various movements of such distasteful groups, some of the shaloren researching the effects caused by the Spellblaze believe that the most prevalent mark of destruction can likely be found along the Blackened Shoreline to the east of Elvala. This was the initial path that the destructive energies of the Spellblaze took and it is reasoned that a better understanding can be obtained by visiting the area. However, the shaloren know that venturing out past the Shroud would be dangerous, not to mention how hazardous those lands are. Despite the dangers, though, it is important to know just what sort of lasting damage the Spellblaze has left on our world.

[i]I won't be discouraged from leaving Elvala because of the battle I lost with the necromancer, though that doesn't mean I will rashly throw my life away either. There are people who need help and villainous schemes to be thwarted and if I can help with this task then I shall. I will be cautious in whatever I pursue in the outside world and you can be sure, Awain, that I will soon be writing another book of my escapades. Wait for me my dear husband for when I come home you know that the first thing I will do is return to your arms. But for now I set off from this land I call home to offer aid where I can.[/i] ]], "_t")


------------------------------------------------
section "game/dlcs/tome-cults/data/lore/zones.lua"
-- 1 entries
t("An illustrated tome!", "An illustrated tome!", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/data/talents/demented/writhing-body.lua"
-- 7 entries
t("Mutated Hereragegand", "Mutated Hereragegand", "talent name")
t([[		Also increases Physical Power by %d, and increases weapon damage by %d%% for your tentacles attacks.

		Your tentacle hand currently has those stats%s:
		%s]], [[		Also increases Physical Power by %d, and increases weapon damage by %d%% for your tentacles attacks.

		Your tentacle hand currently has those stats%s:
		%s]], "tformat")
t("Lash Outrthrthrth", "Lash Outrthrthrth", "talent name")
t([[Spin around, extending your weapon and damaging all targets around you for %d%% weapon damage while your tentacle hand extends and hits all targets in radius 3 for %d%% tentacle damage.
		]], [[Spin around, extending your weapon and damaging all targets around you for %d%% weapon damage while your tentacle hand extends and hits all targets in radius 3 for %d%% tentacle damage.
		]], "tformat")
t("Piercing Tentacle", "Piercing Tentacle", "talent name")
t([[You quickly extend your tentacle hand up to range %d, impaling all creatures in the way.
		Impaled creatures take %d%% tentacle damage and get sick, gaining a random disease for %d turns that deals %0.2f blight damage per turn and reduces strength, dexterity or constitution by %d.]], [[You quickly extend your tentacle hand up to range %d, impaling all creatures in the way.
		Impaled creatures take %d%% tentacle damage and get sick, gaining a random disease for %d turns that deals %0.2f blight damage per turn and reduces strength, dexterity or constitution by %d.]], "tformat")
t("Tentaclesrsthrhrhrh Ground", "Tentaclesrsthrhrhrh Ground", "talent name")


------------------------------------------------
section "game/dlcs/tome-cults/data/zones/ft-horrors/objects.lua"
-- 1 entries
t("..", "..", "entity name")


------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/class/CultsDLC.lua"
-- 1 entries
t("#AQUAMARINE#%s", "#AQUAMARINE#%s", "log")


------------------------------------------------
section "game/dlcs/tome-cults/overload/mod/dialogs/ForbiddenTome.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyGrandOration.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyRevelation.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-cults/superload/mod/dialogs/ProphecyTwofoldCurse.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/general/objects/world-artifacts.lua"
-- 1 entries
t("%s", "%s", "tformat")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/gem.lua"
-- 1 entries
t("G.E.M", "G.E.M", "newLore category")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/primal-forest.lua"
-- 9 entries
t("a warning sign", "a warning sign", "_t")
t([[WARNING - READ THIS!

---

This forest is the site of a massive and ongoing ecological disaster.  As far as I can tell (and as a Mender, I have at least [i]some[/i] clue of what I'm talking about), Eyal's trying to fight off an infection, and the infection's fighting back for all it's worth.  Given the indiscriminate hostility of the local treants, we can assume the infection's winning, if only slightly; it's concentrated most of its power into a handful of crystalline avatars at the top of the great tree.  Best case scenario, Eyal's pushing them out like splinters, and destroying these avatars will eliminate the problem; worst case, the tree is already infected down to its roots, and these avatars are its spores, growing until they're ready to leave the tree and spread elsewhere.  I came to destroy these crystals myself, but I wasn't counting on the treants turning on me as well; since you're reading this, congratulations!  This is your responsibility now.

My advice?  Head through the portal to Shatur and call for backup.  I don't have that option, as that'd require incriminating myself by admitting that I was in Var'Eyal without a pass (you wouldn't judge me if you knew how much the trolls were paying for cheerblossom).  I can assure you that the others there are considerably more dedicated and competent than I am, even if only as a group; together, they'll be able to control this infection and treat the wounds it's left behind.  If you go in alone, you'll likely get ripped apart by the treants before you can even reach the trunk - and more are waking up every passing minute.  Unless you're the Hero of Maj'Eyal or Garkul's reanimated corpse, you'll be walking into your own grave.  Let the professionals handle this.

If you insist on going in, though, here's what I know:

-The treants, unfortunately, are no longer concerned with discerning friend from foe.  Anything not stemming from Nature is a potential source of the infection in their eyes, and must be purged before they can slumber once more.  I know that saying "please" isn't exactly sufficient for asking you not to defend yourself...  just try to keep the damage to a minimum, so they can heal the land once ravaged by this sickness.  If you want to avoid them, get off the ground level and into the canopy as soon as you can; they won't animate if they don't see anything on the forest floor to attack.  Also, do NOT try to take a core sample!  Trust me on this - as much as I wanted to know how deep the infection had spread, whether it was all the way through the tree or if it had pushed it all to the top, it attracted the treants to me like Shaloren to a stupid decision.  

-The destructive agent in question is a group of animated arcane crystals, of the type previously documented in the Scintillating Caverns.  The exact processes involved in their formation are still unclear, but it's a safe assumption that they're connected to the massive surge of blight introduced by the Spellblaze, and proof that even now, the damage is most likely worse than we can ever be sure of.  Expect to take powerful blasts of every kind of magic if you're not exceptionally evasive; fortunately, although they frequently teleport, they are completely immobile between blinks.  If one teleports near you, either take cover, or destroy it before it can reposition itself.

-The consequences of letting this go unchecked would be disastrous.  Even if this great tree's growth IS a sign of the planet successfully fighting the infection off by pushing it out, the crystalline avatars could simply climb down, bury themselves, and sicken Eyal once more.  And if Eyal's losing...  as much as I loathe to say it, perhaps those Shaloren pyromaniacs could do some good for once in their all-too-long lives, and cauterize the area down to the roots.  Provided, of course, that they can figure out how to do so without blowing up the sun.

I wish you luck, and thank you for doing what I cannot.  There are reasons why this is a risk I cannot afford to take, but it's probably best for both of us that you assume I'm a coward.  It's not too far from the truth.

With unending gratitude,
(This is where I would sign my name, were I an utter moron.)

PS: If you wouldn't mind doing me a personal favor, please destroy any written articles you find.  They spilled out of my bag as I fled; I'm already a coward, and I'd rather not be a litterer as well.]], [[WARNING - READ THIS!

---

This forest is the site of a massive and ongoing ecological disaster.  As far as I can tell (and as a Mender, I have at least [i]some[/i] clue of what I'm talking about), Eyal's trying to fight off an infection, and the infection's fighting back for all it's worth.  Given the indiscriminate hostility of the local treants, we can assume the infection's winning, if only slightly; it's concentrated most of its power into a handful of crystalline avatars at the top of the great tree.  Best case scenario, Eyal's pushing them out like splinters, and destroying these avatars will eliminate the problem; worst case, the tree is already infected down to its roots, and these avatars are its spores, growing until they're ready to leave the tree and spread elsewhere.  I came to destroy these crystals myself, but I wasn't counting on the treants turning on me as well; since you're reading this, congratulations!  This is your responsibility now.

My advice?  Head through the portal to Shatur and call for backup.  I don't have that option, as that'd require incriminating myself by admitting that I was in Var'Eyal without a pass (you wouldn't judge me if you knew how much the trolls were paying for cheerblossom).  I can assure you that the others there are considerably more dedicated and competent than I am, even if only as a group; together, they'll be able to control this infection and treat the wounds it's left behind.  If you go in alone, you'll likely get ripped apart by the treants before you can even reach the trunk - and more are waking up every passing minute.  Unless you're the Hero of Maj'Eyal or Garkul's reanimated corpse, you'll be walking into your own grave.  Let the professionals handle this.

If you insist on going in, though, here's what I know:

-The treants, unfortunately, are no longer concerned with discerning friend from foe.  Anything not stemming from Nature is a potential source of the infection in their eyes, and must be purged before they can slumber once more.  I know that saying "please" isn't exactly sufficient for asking you not to defend yourself...  just try to keep the damage to a minimum, so they can heal the land once ravaged by this sickness.  If you want to avoid them, get off the ground level and into the canopy as soon as you can; they won't animate if they don't see anything on the forest floor to attack.  Also, do NOT try to take a core sample!  Trust me on this - as much as I wanted to know how deep the infection had spread, whether it was all the way through the tree or if it had pushed it all to the top, it attracted the treants to me like Shaloren to a stupid decision.  

-The destructive agent in question is a group of animated arcane crystals, of the type previously documented in the Scintillating Caverns.  The exact processes involved in their formation are still unclear, but it's a safe assumption that they're connected to the massive surge of blight introduced by the Spellblaze, and proof that even now, the damage is most likely worse than we can ever be sure of.  Expect to take powerful blasts of every kind of magic if you're not exceptionally evasive; fortunately, although they frequently teleport, they are completely immobile between blinks.  If one teleports near you, either take cover, or destroy it before it can reposition itself.

-The consequences of letting this go unchecked would be disastrous.  Even if this great tree's growth IS a sign of the planet successfully fighting the infection off by pushing it out, the crystalline avatars could simply climb down, bury themselves, and sicken Eyal once more.  And if Eyal's losing...  as much as I loathe to say it, perhaps those Shaloren pyromaniacs could do some good for once in their all-too-long lives, and cauterize the area down to the roots.  Provided, of course, that they can figure out how to do so without blowing up the sun.

I wish you luck, and thank you for doing what I cannot.  There are reasons why this is a risk I cannot afford to take, but it's probably best for both of us that you assume I'm a coward.  It's not too far from the truth.

With unending gratitude,
(This is where I would sign my name, were I an utter moron.)

PS: If you wouldn't mind doing me a personal favor, please destroy any written articles you find.  They spilled out of my bag as I fled; I'm already a coward, and I'd rather not be a litterer as well.]], "_t")
t("a pamphlet 'Eyal Needs You!'", "a pamphlet 'Eyal Needs You!'", "_t")
t([[EYAL NEEDS YOU!

The damage left in the Scintillating Caverns, in Norgos' Lair, and in countless other places has only now become clear, after the Hero of Maj'Eyal made them safe to explore once more.  Now that peace has been brought to these lands, Eyal is beginning to heal - but with the arrival of our magic-using cousins from the East and the Allied Kingdoms' growing acceptance of magic, the balance may once more tip towards ruin - but YOUR help can keep Eyal healthy!  Join the Menders, and start helping the planet today!

LEARNING AND OBSERVING

Our founders, once Guardians of Shatur, have always known the importance of maintaining a balanced ecosystem.  Do your hobbies include birdwatching, exploring the wilderness, and taking in the sights of natural flora?  We can provide you with a list of animals, plants, and fungi of interest; simply go out and write down where you explored, when, and how many of these species you saw.  Our experienced naturalists can use this information to track migration patterns and monitor the spread or decline of those species, allowing us to take action if one becomes endangered or invasive; already, they're working to restore the balance disrupted by the Hero of Maj'Eyal's constant slaying of local wildlife.  Change is inherent to the natural order; our experts know to only step in if a change would drastically and destructively hurt the ecosystem.  Nature solves most of its problems on its own, but occasionally we may need to hold its hand (particularly in response to mutations caused by unchecked use of arcane magic).  If you'd like to learn more about the natural order, we have a diverse community of knowledgeable naturalists who are happy to answer questions or provide a more thorough education.

REPAIRING AND HEALING

Volunteers who prefer a more hands-on approach can expect to start making a difference right away, by joining our reclamation and decontamination efforts.  It's no secret that the Hero of Maj'Eyal's many battles took their unfortunate toll; many places are still littered with magic-contaminated objects or bodies, and in some places the ground itself has been polluted by the residual effects of these spells.  (This is, of course, to say nothing of the trees burned down, etc. by beasts and ne'er-do-wells trying to stop the Hero!)  You can help by destroying dangerously magical objects, planting trees, slaying ecologically-disruptive beasts (such as Norgos), and participating in cleansing rituals to speed up the healing process.

ABILITY, RESPONSIBILITY, AND ACCEPTANCE

The wilds of Eyal are a dangerous place; we do not expect our scholars to go into them defenseless!  For those who are already accustomed to use of the arcane, our partnership with the Living Fossils allows us to identify safe and responsible methods of using magic, and provide them with an introduction to the ways of Nature, and those who are already adept with Nature can always hone their skills with our veteran members.  If you have no ability with either, you're in luck!  We're eager to show you how to accept Nature's favors to defend yourself.  Anyone can learn to summon loyal beasts or channel wyrmic strength if they're willing to try!  These abilities can be used without giving up your attunement to the arcane, but you may find that you don't need your spells anymore, once you've seen how effective Nature's power is.  We will never force you to give up magic, but if you happen to be looking for a greater commitment, speak to your instructor about following the path of the oozemancer.
]], [[EYAL NEEDS YOU!

The damage left in the Scintillating Caverns, in Norgos' Lair, and in countless other places has only now become clear, after the Hero of Maj'Eyal made them safe to explore once more.  Now that peace has been brought to these lands, Eyal is beginning to heal - but with the arrival of our magic-using cousins from the East and the Allied Kingdoms' growing acceptance of magic, the balance may once more tip towards ruin - but YOUR help can keep Eyal healthy!  Join the Menders, and start helping the planet today!

LEARNING AND OBSERVING

Our founders, once Guardians of Shatur, have always known the importance of maintaining a balanced ecosystem.  Do your hobbies include birdwatching, exploring the wilderness, and taking in the sights of natural flora?  We can provide you with a list of animals, plants, and fungi of interest; simply go out and write down where you explored, when, and how many of these species you saw.  Our experienced naturalists can use this information to track migration patterns and monitor the spread or decline of those species, allowing us to take action if one becomes endangered or invasive; already, they're working to restore the balance disrupted by the Hero of Maj'Eyal's constant slaying of local wildlife.  Change is inherent to the natural order; our experts know to only step in if a change would drastically and destructively hurt the ecosystem.  Nature solves most of its problems on its own, but occasionally we may need to hold its hand (particularly in response to mutations caused by unchecked use of arcane magic).  If you'd like to learn more about the natural order, we have a diverse community of knowledgeable naturalists who are happy to answer questions or provide a more thorough education.

REPAIRING AND HEALING

Volunteers who prefer a more hands-on approach can expect to start making a difference right away, by joining our reclamation and decontamination efforts.  It's no secret that the Hero of Maj'Eyal's many battles took their unfortunate toll; many places are still littered with magic-contaminated objects or bodies, and in some places the ground itself has been polluted by the residual effects of these spells.  (This is, of course, to say nothing of the trees burned down, etc. by beasts and ne'er-do-wells trying to stop the Hero!)  You can help by destroying dangerously magical objects, planting trees, slaying ecologically-disruptive beasts (such as Norgos), and participating in cleansing rituals to speed up the healing process.

ABILITY, RESPONSIBILITY, AND ACCEPTANCE

The wilds of Eyal are a dangerous place; we do not expect our scholars to go into them defenseless!  For those who are already accustomed to use of the arcane, our partnership with the Living Fossils allows us to identify safe and responsible methods of using magic, and provide them with an introduction to the ways of Nature, and those who are already adept with Nature can always hone their skills with our veteran members.  If you have no ability with either, you're in luck!  We're eager to show you how to accept Nature's favors to defend yourself.  Anyone can learn to summon loyal beasts or channel wyrmic strength if they're willing to try!  These abilities can be used without giving up your attunement to the arcane, but you may find that you don't need your spells anymore, once you've seen how effective Nature's power is.  We will never force you to give up magic, but if you happen to be looking for a greater commitment, speak to your instructor about following the path of the oozemancer.
]], "_t")
t("'On Tolerance'", "'On Tolerance'", "_t")
t([[We recognize that times are changing.  Within a year, the Allied Kingdoms have gone from begrudgingly tolerating magic to openly embracing it, due to the influence of our rediscovered allies in the East.  Furthermore, if the reports are to be believed, the ecosystem of Var'Eyal remains healthy and intact, despite millennia of continuous magic-use.  Therefore, our views and approach must change with the times; we are not ignorant to new knowledge.

At this point, it should go without saying that reckless use of magic is a dire threat to...  everything, more or less.  Eyal has yet to fully recover from even the rampant necromancy of the Age of Dusk, let alone the Spellblaze itself.  Eliminating all use of magic is the only way to be safe from this situation repeating...  but it is possible that lesser uses of arcane magic do not have any inherent corrupting or harmful effect, judging from the Sun Paladins and Anorthil.  They have, contrary to our long-held beliefs, managed to use magic responsibly and safely.  We are not so blind as to deny that this is an incredible reassurance.  That said, this proves nothing about the most terrible potential of magic.  Maybe no Sun Paladin or Anorthil has yet sunk to the depths of depravity of the Age of Dusk sorcerers, or the tragically reckless mages responsible for the Spellblaze, but that is no indication that their magic does not have the potential for abuse.  

Fortunately, there is an alternative available!  With the proper respect, care, and concentration given to Nature, one can be rewarded with powers rivaling or besting the popular uses of magic.  On the civilian level, summoned fireflies can replace magical lighting, regeneration salves can replace healing spells, and accelerated crop growth makes for a far more nutritious diet than conjured foodstuffs.  For martial purposes, there's very little that can stand up to the powers of Nature.  An experienced disciple of Eyal can summon loyal beasts faster than any mage can blast them, crush spellswords of all types with draconic might, or dissolve a necromancer's army in a tide of corrosive ooze.  And if the disciple in question is familiar with the practices of the Ziguranth...  We do not condone their approach to defending nature, but their techniques speak for themselves when facing a hostile mage.  The best part about these abilities, though, is that they are self-limiting!  There is no potential for a runaway chain reaction, or a lone megalomaniac destroying much of Eyal.  The planet willingly gives us its power, and is conscious enough to take it away if we start abusing its gifts.  Even the most powerful of Wilders cannot abuse their power to the perverse degree that a necromancer can.

Thus, we're putting our efforts into two areas.  The first is advocacy of Natural alternatives to magic, talking to spellcasters to determine what they use magic for and figuring out ways to use Nature's abilities to do the same task just as well (if not moreso).  We've continued the Ziguranth efforts to make all-natural replacements for Ogric runes (we predict that life expectancy is now only reduced by 40% with our newest mixtures), developed fertilizing recipes that outperform arcane methods of producing food, created wells near desert settlements otherwise dependent on water magic, and developed so many other techniques and applications that make magic just as obsolete as it is hazardous.  The second is minimizing the harm done by the arcane, by educating spellcasters on the safe, responsible, and Nature-conscious use of magic.  Not every spellcaster is evil, and in fact, some may enrich the lives of those around them!  Runic magic is at least somewhat self-limiting, and we are working with the Living Fossils guild in hopes of developing a new type of magic, one inherently linked to and limited by Nature.  Their stone-wardens have maintained perfect harmony with Nature despite constant use of the arcane; if this is truly the way forward, then we shall welcome it with open arms.
]], [[We recognize that times are changing.  Within a year, the Allied Kingdoms have gone from begrudgingly tolerating magic to openly embracing it, due to the influence of our rediscovered allies in the East.  Furthermore, if the reports are to be believed, the ecosystem of Var'Eyal remains healthy and intact, despite millennia of continuous magic-use.  Therefore, our views and approach must change with the times; we are not ignorant to new knowledge.

At this point, it should go without saying that reckless use of magic is a dire threat to...  everything, more or less.  Eyal has yet to fully recover from even the rampant necromancy of the Age of Dusk, let alone the Spellblaze itself.  Eliminating all use of magic is the only way to be safe from this situation repeating...  but it is possible that lesser uses of arcane magic do not have any inherent corrupting or harmful effect, judging from the Sun Paladins and Anorthil.  They have, contrary to our long-held beliefs, managed to use magic responsibly and safely.  We are not so blind as to deny that this is an incredible reassurance.  That said, this proves nothing about the most terrible potential of magic.  Maybe no Sun Paladin or Anorthil has yet sunk to the depths of depravity of the Age of Dusk sorcerers, or the tragically reckless mages responsible for the Spellblaze, but that is no indication that their magic does not have the potential for abuse.  

Fortunately, there is an alternative available!  With the proper respect, care, and concentration given to Nature, one can be rewarded with powers rivaling or besting the popular uses of magic.  On the civilian level, summoned fireflies can replace magical lighting, regeneration salves can replace healing spells, and accelerated crop growth makes for a far more nutritious diet than conjured foodstuffs.  For martial purposes, there's very little that can stand up to the powers of Nature.  An experienced disciple of Eyal can summon loyal beasts faster than any mage can blast them, crush spellswords of all types with draconic might, or dissolve a necromancer's army in a tide of corrosive ooze.  And if the disciple in question is familiar with the practices of the Ziguranth...  We do not condone their approach to defending nature, but their techniques speak for themselves when facing a hostile mage.  The best part about these abilities, though, is that they are self-limiting!  There is no potential for a runaway chain reaction, or a lone megalomaniac destroying much of Eyal.  The planet willingly gives us its power, and is conscious enough to take it away if we start abusing its gifts.  Even the most powerful of Wilders cannot abuse their power to the perverse degree that a necromancer can.

Thus, we're putting our efforts into two areas.  The first is advocacy of Natural alternatives to magic, talking to spellcasters to determine what they use magic for and figuring out ways to use Nature's abilities to do the same task just as well (if not moreso).  We've continued the Ziguranth efforts to make all-natural replacements for Ogric runes (we predict that life expectancy is now only reduced by 40% with our newest mixtures), developed fertilizing recipes that outperform arcane methods of producing food, created wells near desert settlements otherwise dependent on water magic, and developed so many other techniques and applications that make magic just as obsolete as it is hazardous.  The second is minimizing the harm done by the arcane, by educating spellcasters on the safe, responsible, and Nature-conscious use of magic.  Not every spellcaster is evil, and in fact, some may enrich the lives of those around them!  Runic magic is at least somewhat self-limiting, and we are working with the Living Fossils guild in hopes of developing a new type of magic, one inherently linked to and limited by Nature.  Their stone-wardens have maintained perfect harmony with Nature despite constant use of the arcane; if this is truly the way forward, then we shall welcome it with open arms.
]], "_t")
t("primal forest", "primal forest", "newLore category")
t("a leaf-bound journal", "a leaf-bound journal", "_t")
t([[[i](You see here a leaf-bound journal; the moment you open it, it begins to wither and crumble.  You manage to rip out one page; it is still disintegrating, but slowly enough that you can read it before it turns to dust.)[/i]

Another vandalized poster.  Calling us traitors, collaborators, declaring themselves the True Ziguranth.  Fools, the lot of them.

When I established the Menders, it wasn't because I thought the arrival of a handful of magic-users who also happen to be decent people disproved anything taught in Zigur or my childhood in Shatur.  It wasn't because I suddenly forgot that anything derived from arcane magic, no matter whether or not it's wrapped up in some mumbo-jumbo about the heavens, carries the risk of mutating into something that could put the Spellblaze to shame.  It was because those maniacs had ignored the shifting political tides for so long that they found themselves sliding into irrelevance, then went and skipped directly over irrelevance into pariahdom with that foolhardy assassination attempt.  They can blame the Far East all they want, but that was only the last nail in the coffin, alongside widespread acceptance of runes and alchemists operating openly across the continent.

I can appreciate their dedication.  I can appreciate their frustration, and how seeing the world treating magic-use as normal would just make them want to get more violent - but the fact is, the raid on Zigur was a mercy kill, preventing the fanatics from making us look even worse in the public eye.  We are long past the point where intimidation can get us anywhere - so we need to try a new approach.  If reminding the world of the horrors of magic isn't working anymore, the Spellblaze and the Age of Dusk being too faded from public memory, then we need to remind them of the wonders of Nature instead, wonders they can see for themselves, today.  If the public won't believe that magic is evil, they can believe that Nature is better.  If we can't make magic taboo, we can make magic obsolete...  and all of this gathers support we'd otherwise lack, curious minds waiting to be taught the beauty of Nature and warned of the hazards of the arcane.

So maybe the old guard's been overrun with Thaloren, youths, and others who care a great deal more about loving nature than hating magic.  I don't see why this is a problem - making Nature stronger will make it more capable of resisting the damage magic may inflict.  We've allowed the idea of supporting Nature over magic to survive the Allied Kingdoms' treaty with the Gates of Morning, the raid on Zigur, and the attacks on Ziguranth patrols.  We've established ourselves as a selfless, charitable organization working for the good of all, a reputation that will grant us significantly more credibility than our previous public image of a band of crazed fanatics.

Perhaps most meaningfully of all, there are [i]far[/i] more Menders now than there were Ziguranth in the last century.  These allies will help us support Nature to an incredible degree, and we've started offering volunteer courses in classical anti-magic training, allowing them to further refine our techniques for dealing with rogue mages.  If and when arcane magic causes another catastrophe, these allies will rally behind us as we defend Nature from those who threaten it...  And, who knows, maybe we actually CAN teach mages to show a sane level of restraint without wiping them all out.  I'm keeping my eyes open for ways to make that happen, no matter how unlikely they may be.

In the meantime, paying off Stone Warden trainers and buying enough mindstars and herbal infusions for our initiates isn't cheap.  I'm not proud of what I'm doing to pay the bills, and am fully aware of what it'd do to the organization if someone saw me, but this is the fastest and easiest money I've ever made.  Ten minutes of concentration, a few hours to re-establish my equilibrium, and I can grow enough cheerblossom to cover our expenses for a week.]], [[[i](You see here a leaf-bound journal; the moment you open it, it begins to wither and crumble.  You manage to rip out one page; it is still disintegrating, but slowly enough that you can read it before it turns to dust.)[/i]

Another vandalized poster.  Calling us traitors, collaborators, declaring themselves the True Ziguranth.  Fools, the lot of them.

When I established the Menders, it wasn't because I thought the arrival of a handful of magic-users who also happen to be decent people disproved anything taught in Zigur or my childhood in Shatur.  It wasn't because I suddenly forgot that anything derived from arcane magic, no matter whether or not it's wrapped up in some mumbo-jumbo about the heavens, carries the risk of mutating into something that could put the Spellblaze to shame.  It was because those maniacs had ignored the shifting political tides for so long that they found themselves sliding into irrelevance, then went and skipped directly over irrelevance into pariahdom with that foolhardy assassination attempt.  They can blame the Far East all they want, but that was only the last nail in the coffin, alongside widespread acceptance of runes and alchemists operating openly across the continent.

I can appreciate their dedication.  I can appreciate their frustration, and how seeing the world treating magic-use as normal would just make them want to get more violent - but the fact is, the raid on Zigur was a mercy kill, preventing the fanatics from making us look even worse in the public eye.  We are long past the point where intimidation can get us anywhere - so we need to try a new approach.  If reminding the world of the horrors of magic isn't working anymore, the Spellblaze and the Age of Dusk being too faded from public memory, then we need to remind them of the wonders of Nature instead, wonders they can see for themselves, today.  If the public won't believe that magic is evil, they can believe that Nature is better.  If we can't make magic taboo, we can make magic obsolete...  and all of this gathers support we'd otherwise lack, curious minds waiting to be taught the beauty of Nature and warned of the hazards of the arcane.

So maybe the old guard's been overrun with Thaloren, youths, and others who care a great deal more about loving nature than hating magic.  I don't see why this is a problem - making Nature stronger will make it more capable of resisting the damage magic may inflict.  We've allowed the idea of supporting Nature over magic to survive the Allied Kingdoms' treaty with the Gates of Morning, the raid on Zigur, and the attacks on Ziguranth patrols.  We've established ourselves as a selfless, charitable organization working for the good of all, a reputation that will grant us significantly more credibility than our previous public image of a band of crazed fanatics.

Perhaps most meaningfully of all, there are [i]far[/i] more Menders now than there were Ziguranth in the last century.  These allies will help us support Nature to an incredible degree, and we've started offering volunteer courses in classical anti-magic training, allowing them to further refine our techniques for dealing with rogue mages.  If and when arcane magic causes another catastrophe, these allies will rally behind us as we defend Nature from those who threaten it...  And, who knows, maybe we actually CAN teach mages to show a sane level of restraint without wiping them all out.  I'm keeping my eyes open for ways to make that happen, no matter how unlikely they may be.

In the meantime, paying off Stone Warden trainers and buying enough mindstars and herbal infusions for our initiates isn't cheap.  I'm not proud of what I'm doing to pay the bills, and am fully aware of what it'd do to the organization if someone saw me, but this is the fastest and easiest money I've ever made.  Ten minutes of concentration, a few hours to re-establish my equilibrium, and I can grow enough cheerblossom to cover our expenses for a week.]], "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/quarry.lua"
-- 7 entries
t("a very old journal (1)", "a very old journal (1)", "_t")
t([[This is a matter most vexing.  Our digging was going well (if not particularly productively), and those fellows over in Geothermal Surveying told us they'd found a possible heat source, quite near an existing tunnel - but the miners started refusing to go there.  Copious complaints about assorted lesser maladies - nosebleeds, tremors, and general feelings of fear and unease.  On the other hand, a couple claim the vapors down there have done wonders for their clogged pores.

Firing one as an example didn't work, and I have neither the time nor the inclination to get a bunch of layabouts to do their jobs.  I'm bringing in a yeti handler and excavating the whole area.]], [[This is a matter most vexing.  Our digging was going well (if not particularly productively), and those fellows over in Geothermal Surveying told us they'd found a possible heat source, quite near an existing tunnel - but the miners started refusing to go there.  Copious complaints about assorted lesser maladies - nosebleeds, tremors, and general feelings of fear and unease.  On the other hand, a couple claim the vapors down there have done wonders for their clogged pores.

Firing one as an example didn't work, and I have neither the time nor the inclination to get a bunch of layabouts to do their jobs.  I'm bringing in a yeti handler and excavating the whole area.]], "_t")
t("a very old journal (2)", "a very old journal (2)", "_t")
t([[Now I've had to fire a yeti handler as well.  The other workers tell me that the yetis would clutch their heads and hurl themselves into the chasm after no more than a few minutes of work in the promising area; we tried replacing the yetis, but then the handler developed a nosebleed as well, and then refused to do more work.

And this incompetent fool was using a psychic controller!  I would expect this performance from a child attempting it free-hand, but a trained and properly equipped professional should be able to command an entire team of yetis!

I've filed a request for a special order, along with one for the handler's license to be torn up and cast into the chasm.  It's time for drastic measures.]], [[Now I've had to fire a yeti handler as well.  The other workers tell me that the yetis would clutch their heads and hurl themselves into the chasm after no more than a few minutes of work in the promising area; we tried replacing the yetis, but then the handler developed a nosebleed as well, and then refused to do more work.

And this incompetent fool was using a psychic controller!  I would expect this performance from a child attempting it free-hand, but a trained and properly equipped professional should be able to command an entire team of yetis!

I've filed a request for a special order, along with one for the handler's license to be torn up and cast into the chasm.  It's time for drastic measures.]], "_t")
t("steam quarry", "steam quarry", "newLore category")
t("a very old journal (3)", "a very old journal (3)", "_t")
t([[I don't like automatons.  Machines that operate by themselves, with no personal input...  why, they don't require any skill or ability to operate!  You need only rely on what someone else has done by inventing it!  Mark my words, our dependence on these things will be the death of us, making us weak in body and mind...  but I must admit, they have gotten the job done.  Only a few days after we brought in these arachnoid contraptions, they excavated enough of the offending cavern (and presumably purged enough of whatever pollutant was down there) that living workers are once again willing to work in the nearby areas.  I don't care if it was superstition or what, because we're going to make quota for this month - those caves had a lot of vents to work with!

Still not sure why the Council confiscated the cargo from the third machine we sent down there, but whatever.  Those uppity do-nothings can keep the gold or jewels or whatever was in there.
]], [[I don't like automatons.  Machines that operate by themselves, with no personal input...  why, they don't require any skill or ability to operate!  You need only rely on what someone else has done by inventing it!  Mark my words, our dependence on these things will be the death of us, making us weak in body and mind...  but I must admit, they have gotten the job done.  Only a few days after we brought in these arachnoid contraptions, they excavated enough of the offending cavern (and presumably purged enough of whatever pollutant was down there) that living workers are once again willing to work in the nearby areas.  I don't care if it was superstition or what, because we're going to make quota for this month - those caves had a lot of vents to work with!

Still not sure why the Council confiscated the cargo from the third machine we sent down there, but whatever.  Those uppity do-nothings can keep the gold or jewels or whatever was in there.
]], "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/slumbering-caves.lua"
-- 13 entries
t("a journal (1)", "a journal (1)", "_t")
t("O #CRIMSON#AMAKTHEL#LAST#!  Rightful ruler of all touched by the sun's light or the core's warmth!  In the era of gods, You innovated when others remained stagnant.  The others were content to work with the same mold - a head, thin skin, a jointed endoskeleton - but You, You had scores of ideas, and even the common threads between them were testaments to flexibility, invention, and adaptability!  The others struggled with stiff, fragile limbs, an easily obstructed windpipe, and one huge mass of vulnerabilities above their torso; You found this form wanting, and proved Your place as the supreme deity by continuing to improve on it.  You gave us arms and legs we could twist into any useful shape we could dream of, and instead of dreadfully fragile eyes and throats, we can see, eat, and breathe through our skin, skin laden with neurons rather than one centralized brain.  Even today, even when unconscious and dismembered, You continue to invent, Your Magic of Creativity tweaking the other gods' creations to see what results.  You are not merely a god of light - You are a god of enlightenment, and all who create owe it to You.", "O #CRIMSON#AMAKTHEL#LAST#!  Rightful ruler of all touched by the sun's light or the core's warmth!  In the era of gods, You innovated when others remained stagnant.  The others were content to work with the same mold - a head, thin skin, a jointed endoskeleton - but You, You had scores of ideas, and even the common threads between them were testaments to flexibility, invention, and adaptability!  The others struggled with stiff, fragile limbs, an easily obstructed windpipe, and one huge mass of vulnerabilities above their torso; You found this form wanting, and proved Your place as the supreme deity by continuing to improve on it.  You gave us arms and legs we could twist into any useful shape we could dream of, and instead of dreadfully fragile eyes and throats, we can see, eat, and breathe through our skin, skin laden with neurons rather than one centralized brain.  Even today, even when unconscious and dismembered, You continue to invent, Your Magic of Creativity tweaking the other gods' creations to see what results.  You are not merely a god of light - You are a god of enlightenment, and all who create owe it to You.", "_t")
t("a journal (2)", "a journal (2)", "_t")
t([[Great #CRIMSON#AMAKTHEL#LAST#, forgive me, for I could not prevent the actions of my brethren.  I tried.  We tried.  When they spoke of committing the Great Sin, we argued ferociously, until Caldizar and his apostates did it before we could react in time.  We did our best to avenge this foul deed, and used the Magic of Creativity on as many as we could, blessing them with new forms, and blessing ourselves such that we could do battle with their fortresses; alas, it was nonetheless a war we eventually lost, for what chance did we have against weaponry, power, and mercilessness to which even You fell?  Please, Your Brilliance, understand that we did everything we could.  

Our planet lay in ruins, with even the apostates abandoning Eyal for other worlds.  Every one of Your followers fought to our deaths...  except me, coward that I was in those days.  Now, I am all that remains, along with the apostates we blessed with Your magic.  I will not beg for Your forgiveness; as an inventor You are concerned with results over words, and I will prove to You that my moment of weakness will soon have a wondrous result.  With the sinful apostates gone, You will have the time to secure this world for Yourself, purging the creations of the lesser gods...  and preparing to exact justice on the sinners when they return.  
]], [[Great #CRIMSON#AMAKTHEL#LAST#, forgive me, for I could not prevent the actions of my brethren.  I tried.  We tried.  When they spoke of committing the Great Sin, we argued ferociously, until Caldizar and his apostates did it before we could react in time.  We did our best to avenge this foul deed, and used the Magic of Creativity on as many as we could, blessing them with new forms, and blessing ourselves such that we could do battle with their fortresses; alas, it was nonetheless a war we eventually lost, for what chance did we have against weaponry, power, and mercilessness to which even You fell?  Please, Your Brilliance, understand that we did everything we could.  

Our planet lay in ruins, with even the apostates abandoning Eyal for other worlds.  Every one of Your followers fought to our deaths...  except me, coward that I was in those days.  Now, I am all that remains, along with the apostates we blessed with Your magic.  I will not beg for Your forgiveness; as an inventor You are concerned with results over words, and I will prove to You that my moment of weakness will soon have a wondrous result.  With the sinful apostates gone, You will have the time to secure this world for Yourself, purging the creations of the lesser gods...  and preparing to exact justice on the sinners when they return.  
]], "_t")
t("a journal (3)", "a journal (3)", "_t")
t([[The work continues, and soon all shall know the name of their new god.  Even handling the one Hand that I have makes me weep for the sins of my brothers, and yet eager to see their work undone...  The bowels of Eyal shall be the forge in which You will be remade, the newly-drained magma channels above shall be its fire.

I can barely bring myself to tell You the indignity I suffer through in service to You...  Unfit savages, ones not of Your creation and thus undeserving of Your mercy, are in possession of one of the last two pieces of Your body.  I met with the "Atmos," and offered them a tiny fraction of Your approval and power in return for it, far more than enough to make up for the geothermal vents emptied to fuel Your rebirth; they fear Your blessings, and rejected my offer.  They are a proud tribe, one that has been proud for so long that they never noticed that they no longer had anything to be proud of.  I have seen such pride before only once, and it is even more misplaced by the Atmos.  They will remain blind and defiant until the moment they fall, and I shall simply wait to sift through the fragments of their dead civilization.

I am sorry, my god - were I in a better position, Your rebirth would not be contingent on #{italic}#negotiating#{normal}# with the unworthy souls trespassing in Your world...  but I cannot afford the risk of using force.  Perhaps it is some minor consolation that You will now be able to personally show them Your fury.]], [[The work continues, and soon all shall know the name of their new god.  Even handling the one Hand that I have makes me weep for the sins of my brothers, and yet eager to see their work undone...  The bowels of Eyal shall be the forge in which You will be remade, the newly-drained magma channels above shall be its fire.

I can barely bring myself to tell You the indignity I suffer through in service to You...  Unfit savages, ones not of Your creation and thus undeserving of Your mercy, are in possession of one of the last two pieces of Your body.  I met with the "Atmos," and offered them a tiny fraction of Your approval and power in return for it, far more than enough to make up for the geothermal vents emptied to fuel Your rebirth; they fear Your blessings, and rejected my offer.  They are a proud tribe, one that has been proud for so long that they never noticed that they no longer had anything to be proud of.  I have seen such pride before only once, and it is even more misplaced by the Atmos.  They will remain blind and defiant until the moment they fall, and I shall simply wait to sift through the fragments of their dead civilization.

I am sorry, my god - were I in a better position, Your rebirth would not be contingent on #{italic}#negotiating#{normal}# with the unworthy souls trespassing in Your world...  but I cannot afford the risk of using force.  Perhaps it is some minor consolation that You will now be able to personally show them Your fury.]], "_t")
t("a journal (4)", "a journal (4)", "_t")
t([[The foolish creations of the lesser gods have simply handed me Your mouth, in return for a few of the apostates' trinkets!  Unearthed by Dwarves, brought from a distant land by Humans, offered to me by Trolls...  None were aware of how they were helping You, so do not spare these humanoids Your wrath.  They deserve cleansing as much as the Giants, Elves, and other creatures from the lesser gods, creatures that still refuse Your blessing.

The Giants are beginning to falter, as the creations of the pettier gods inevitably do.  As amusing as it would have been to watch them demonstrate their inferiority by tearing at each others' throats, the Orcs have brought them ruin and pushed them to desperation even sooner.  They will reconsider my offer, and then...  ]], [[The foolish creations of the lesser gods have simply handed me Your mouth, in return for a few of the apostates' trinkets!  Unearthed by Dwarves, brought from a distant land by Humans, offered to me by Trolls...  None were aware of how they were helping You, so do not spare these humanoids Your wrath.  They deserve cleansing as much as the Giants, Elves, and other creatures from the lesser gods, creatures that still refuse Your blessing.

The Giants are beginning to falter, as the creations of the pettier gods inevitably do.  As amusing as it would have been to watch them demonstrate their inferiority by tearing at each others' throats, the Orcs have brought them ruin and pushed them to desperation even sooner.  They will reconsider my offer, and then...  ]], "_t")
t("a journal (5)", "a journal (5)", "_t")
t([[This is a time of celebration...  The Atmos have brought us a gift.  I no longer require their cooperation as a people; a handful of Blessed guards (including, in poetic irony, some of the former heretics) will suffice to keep the degenerates from disturbing Your return.  It will only be mere days until You are whole again...  You are an artist, and this world shall be Your canvas.  The degenerates will weep first at Your beauty when they behold You, then for the fate of their world, and then when they realize their sins and the fate they deserve.

I will not beg You for redemption or forgiveness.  My species has already proven itself to be a treacherous, prideful mistake.  All I beg for is to live long enough to see Your masterpiece.]], [[This is a time of celebration...  The Atmos have brought us a gift.  I no longer require their cooperation as a people; a handful of Blessed guards (including, in poetic irony, some of the former heretics) will suffice to keep the degenerates from disturbing Your return.  It will only be mere days until You are whole again...  You are an artist, and this world shall be Your canvas.  The degenerates will weep first at Your beauty when they behold You, then for the fate of their world, and then when they realize their sins and the fate they deserve.

I will not beg You for redemption or forgiveness.  My species has already proven itself to be a treacherous, prideful mistake.  All I beg for is to live long enough to see Your masterpiece.]], "_t")
t("slumbering caves", "slumbering caves", "newLore category")
t("a journal (6)", "a journal (6)", "_t")
t([[the fragments reform
the visage of genius and beauty is once more
the glory of #CRIMSON#AMAKTHEL#LAST# is nigh
the reckoning of the sinners is nigh
the heretics the apostates the degenerates
#CRIMSON#AMAKTHEL#LAST#'s wrath shall be delectable
against the scum trespassing on His world
against those who refuse His vision
against those #CRIMSON#futile fools#LAST# who try to #CRIMSON#interfere#LAST#

change it, #CRIMSON#AMAKTHEL#LAST#
change all You see to fit Your designs
play with it, alter the degenerates, see what happens, learn from it
the world is but a block of marble, You are the sculptor
and Your vision will be seen on Eyal once more
and #CRIMSON#none shall speak the name %s again#LAST#
it shall not even be granted the dignity of being used as an example

and once this world is Your masterpiece
we will find the heretics together

#{italic}#There are several pages filled with "they will burn" written repeatedly.  You throw them away.  You throw #CRIMSON#yourself away.  You will burn.  You will burn you will burn you will burn you will#LAST##{normal}#

this is the first day of a new existence
#{italic}##CRIMSON#and you are not worthy of seeing its dawn#LAST##{normal}#
]], [[the fragments reform
the visage of genius and beauty is once more
the glory of #CRIMSON#AMAKTHEL#LAST# is nigh
the reckoning of the sinners is nigh
the heretics the apostates the degenerates
#CRIMSON#AMAKTHEL#LAST#'s wrath shall be delectable
against the scum trespassing on His world
against those who refuse His vision
against those #CRIMSON#futile fools#LAST# who try to #CRIMSON#interfere#LAST#

change it, #CRIMSON#AMAKTHEL#LAST#
change all You see to fit Your designs
play with it, alter the degenerates, see what happens, learn from it
the world is but a block of marble, You are the sculptor
and Your vision will be seen on Eyal once more
and #CRIMSON#none shall speak the name %s again#LAST#
it shall not even be granted the dignity of being used as an example

and once this world is Your masterpiece
we will find the heretics together

#{italic}#There are several pages filled with "they will burn" written repeatedly.  You throw them away.  You throw #CRIMSON#yourself away.  You will burn.  You will burn you will burn you will burn you will#LAST##{normal}#

this is the first day of a new existence
#{italic}##CRIMSON#and you are not worthy of seeing its dawn#LAST##{normal}#
]], "tformat")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/sunwall.lua"
-- 24 entries
t([[We've done it... we've finally done it. Well, granted, our %s did much of the work, but the result is the same: neither the East nor the West will ever need to fear Orcish rule again. The Prides have been crushed, the survivors have been contained, and our patrols are mopping up the few remaining bands of futile stragglers. Our long-lost allies from the West have come to support us with materials and manpower, and we can finally turn this entire continent into something beautiful. For the first time, Sunwall will not be the solitary bastion of civilization on Var'Eyal.

And yet...

There is one group that remains.  A tiny Orcish pride, really more of a small town, managed to evade our savior's wrath...  a single weed on the edges of our pristine garden, a troubling ember threatening to set the whole continent aflame.  King Tolak has noble aims in trying to set a better example than his vengeful father, but I doubt he'd risk redeeming the Orcs if he'd been through what we have.  The Allied Kingdoms don't know what it's like to live in fear of the Prides, knowing that at any moment they could overrun the Sunwall and take our heads as trophies.  They've got a farportal to hide behind, and don't have to think about their homes and families falling to the same horror that we've been struggling against for our entire lives.  If they did...  suffice to say, they wouldn't have bothered putting up a comfortable camp for the surviving Orcs until the continent was truly safe.

By the Sun...  why would our High Paladin agree to this treaty?  After what we've all been through...

The Orcish scouts are getting bolder.  They've been approaching closer before fleeing, and coming more frequently.  They haven't engaged us yet, but it's only a matter of time...  and all I'm allowed to do is sit and wait on this ugly little bridge, as the West watches from a continent away.  Staring at an open wound, waiting for it to become infected, because they'd rather make a pretty little bow out of the bandages.]], [[We've done it... we've finally done it. Well, granted, our %s did much of the work, but the result is the same: neither the East nor the West will ever need to fear Orcish rule again. The Prides have been crushed, the survivors have been contained, and our patrols are mopping up the few remaining bands of futile stragglers. Our long-lost allies from the West have come to support us with materials and manpower, and we can finally turn this entire continent into something beautiful. For the first time, Sunwall will not be the solitary bastion of civilization on Var'Eyal.

And yet...

There is one group that remains.  A tiny Orcish pride, really more of a small town, managed to evade our savior's wrath...  a single weed on the edges of our pristine garden, a troubling ember threatening to set the whole continent aflame.  King Tolak has noble aims in trying to set a better example than his vengeful father, but I doubt he'd risk redeeming the Orcs if he'd been through what we have.  The Allied Kingdoms don't know what it's like to live in fear of the Prides, knowing that at any moment they could overrun the Sunwall and take our heads as trophies.  They've got a farportal to hide behind, and don't have to think about their homes and families falling to the same horror that we've been struggling against for our entire lives.  If they did...  suffice to say, they wouldn't have bothered putting up a comfortable camp for the surviving Orcs until the continent was truly safe.

By the Sun...  why would our High Paladin agree to this treaty?  After what we've all been through...

The Orcish scouts are getting bolder.  They've been approaching closer before fleeing, and coming more frequently.  They haven't engaged us yet, but it's only a matter of time...  and all I'm allowed to do is sit and wait on this ugly little bridge, as the West watches from a continent away.  Staring at an open wound, waiting for it to become infected, because they'd rather make a pretty little bow out of the bandages.]], "tformat")
t("heroine", "heroine", "_t")
t("a letter addressed to Outpost Leader John", "a letter addressed to Outpost Leader John", "_t")
t([[Sir,

The Orcs grow more impudent every day.  Surely you've noticed too - their scouts growing closer, the smoke of their forges drifting over the mountains alongside the clanging of metal being pounded into weaponry, the guttural shouts of their training drills...  Are you really going to obey this suicidal treaty, and keep us from acting until their swords are already through our throats?
If you were to... [i]see[/i] an approaching assault force, I would verify your report. Legally, we would be untouchable for defending ourselves.  Please, ensure that this inevitable conflict is at least one that gives us the tactical advantage of surprise, not them.

-Cmdr. Trelle]], [[Sir,

The Orcs grow more impudent every day.  Surely you've noticed too - their scouts growing closer, the smoke of their forges drifting over the mountains alongside the clanging of metal being pounded into weaponry, the guttural shouts of their training drills...  Are you really going to obey this suicidal treaty, and keep us from acting until their swords are already through our throats?
If you were to... [i]see[/i] an approaching assault force, I would verify your report. Legally, we would be untouchable for defending ourselves.  Please, ensure that this inevitable conflict is at least one that gives us the tactical advantage of surprise, not them.

-Cmdr. Trelle]], "_t")
t("a letter addressed to Commander Trelle", "a letter addressed to Commander Trelle", "_t")
t([[Trelle,

I respect your intentions and your dedication to our safety, which is the only reason I'm not handing this letter over to Aeryn right this second.  Do you have the faintest clue what this treaty is buying us?  Do you really think we could have kept the Prides' remnants from banding together and becoming, at a minimum, a massive thorn in our side for the next few decades without King Tolak's help? Even if I disagreed with Aeryn that the Orcs deserve a chance of redemption, this treaty is ensuring an [i]extraordinary[/i] amount of help from a nation that, last year, still tolerated roving gangs of mage-lynchers.

I'll spare you the speech about insubordination, lying, and bypassing the chain of command, because a: technically you were "only" asking me to commit those crimes, and b: I've got better things to do than write up a full-blown reprimand for someone who I'm [i]certain[/i] knows exactly what they're doing wrong.  Instead, I'll cut to the chase: Never even think of pulling something like this again.  I'm saving your letter, and if you're ever involved in a questionable use of force, I'm submitting it as evidence.  I thought you were better than this.

-Outpost Leader John]], [[Trelle,

I respect your intentions and your dedication to our safety, which is the only reason I'm not handing this letter over to Aeryn right this second.  Do you have the faintest clue what this treaty is buying us?  Do you really think we could have kept the Prides' remnants from banding together and becoming, at a minimum, a massive thorn in our side for the next few decades without King Tolak's help? Even if I disagreed with Aeryn that the Orcs deserve a chance of redemption, this treaty is ensuring an [i]extraordinary[/i] amount of help from a nation that, last year, still tolerated roving gangs of mage-lynchers.

I'll spare you the speech about insubordination, lying, and bypassing the chain of command, because a: technically you were "only" asking me to commit those crimes, and b: I've got better things to do than write up a full-blown reprimand for someone who I'm [i]certain[/i] knows exactly what they're doing wrong.  Instead, I'll cut to the chase: Never even think of pulling something like this again.  I'm saving your letter, and if you're ever involved in a questionable use of force, I'm submitting it as evidence.  I thought you were better than this.

-Outpost Leader John]], "_t")
t("a large, embossed envelope", "a large, embossed envelope", "_t")
t([[#{bold}#TO WHOM IT MAY CONCERN:#{normal}#

Whereas, it can be assumed with 100% certainty that the individual reading this note is the most esteemed authority of the group residing on the bridge connecting Var'Eyal and the Clork Peninsula, as the construct trusted to deliver this message cannot be coerced to decode it;
and whereas, our observation balloons tell us that this organization is one of high culture and civilization, one comprised of several different species, and would be open to friendly negotiation;
and whereas, the Orcs have none of the aforementioned qualities, and their continued presence on the Clork Peninsula either directly causes or can lead to countless difficulties and unpleasant situations for both of our groups;
and whereas, cooperation in the immediate future would be beneficial to both of us, as would a longer period of peace between our two cultures;
it is therefore imperative that I, and the rest of our species, introduce ourselves.

I am Chief Councillor Tantalos, and I represent the people of #{bold}#Atmos#{normal}#; the orcs call us "Steam Giants" when not using a slew of impolite pejoratives, and we find the name amusing enough to accept it.  The Clork Peninsula is our land, as we have resided here in peace for many thousands of years, before becoming overrun with these distasteful ruffians.  We have been content to let them roam in the undesirable backwater territories of this peninsula, while we looked down from our rightfully elevated places, but various unfortunate circumstances have forced our hand.

We have invented technology #{bold}#far#{normal}# more impressive than yours, or that of any of the remaining miniature races.  Our plebeian citizens are accustomed to luxurious appliances which even your king lacks; our military has abominable weaponry which puts an untrained commoner on even footing with a skilled archer, and lets a moderately experienced marksman kill with range and precision that all but the most powerful archmages would be envious of.  Our people are strong, stronger than any of yours even on a per-pound basis, let alone the advantages of towering over you child-like creatures.  We have countless valuable natural resources, and our many, talented artisans will quickly become accustomed to making smaller garments, jewelry, and bottles of fine spirits for export (among many other high-quality goods).  It should be clear that your diminutive people have much to gain from us; all we wish, for the time being, is for the Clork Peninsula to remain #{bold}#our#{normal}# land, and perhaps that you may grant us some martial or material assistance in #{italic}#addressing#{normal}# the Orcish inconvenience.

We should meet, and discuss this in more detail, or I can arrange to let you borrow an artifact that will allow us to communicate.  Please give your reply to this construct post-haste.

Regards,
#{italic}#-Tantalos#{normal}#]], [[#{bold}#TO WHOM IT MAY CONCERN:#{normal}#

Whereas, it can be assumed with 100% certainty that the individual reading this note is the most esteemed authority of the group residing on the bridge connecting Var'Eyal and the Clork Peninsula, as the construct trusted to deliver this message cannot be coerced to decode it;
and whereas, our observation balloons tell us that this organization is one of high culture and civilization, one comprised of several different species, and would be open to friendly negotiation;
and whereas, the Orcs have none of the aforementioned qualities, and their continued presence on the Clork Peninsula either directly causes or can lead to countless difficulties and unpleasant situations for both of our groups;
and whereas, cooperation in the immediate future would be beneficial to both of us, as would a longer period of peace between our two cultures;
it is therefore imperative that I, and the rest of our species, introduce ourselves.

I am Chief Councillor Tantalos, and I represent the people of #{bold}#Atmos#{normal}#; the orcs call us "Steam Giants" when not using a slew of impolite pejoratives, and we find the name amusing enough to accept it.  The Clork Peninsula is our land, as we have resided here in peace for many thousands of years, before becoming overrun with these distasteful ruffians.  We have been content to let them roam in the undesirable backwater territories of this peninsula, while we looked down from our rightfully elevated places, but various unfortunate circumstances have forced our hand.

We have invented technology #{bold}#far#{normal}# more impressive than yours, or that of any of the remaining miniature races.  Our plebeian citizens are accustomed to luxurious appliances which even your king lacks; our military has abominable weaponry which puts an untrained commoner on even footing with a skilled archer, and lets a moderately experienced marksman kill with range and precision that all but the most powerful archmages would be envious of.  Our people are strong, stronger than any of yours even on a per-pound basis, let alone the advantages of towering over you child-like creatures.  We have countless valuable natural resources, and our many, talented artisans will quickly become accustomed to making smaller garments, jewelry, and bottles of fine spirits for export (among many other high-quality goods).  It should be clear that your diminutive people have much to gain from us; all we wish, for the time being, is for the Clork Peninsula to remain #{bold}#our#{normal}# land, and perhaps that you may grant us some martial or material assistance in #{italic}#addressing#{normal}# the Orcish inconvenience.

We should meet, and discuss this in more detail, or I can arrange to let you borrow an artifact that will allow us to communicate.  Please give your reply to this construct post-haste.

Regards,
#{italic}#-Tantalos#{normal}#]], "_t")
t("a page from Commander Trelle's journal", "a page from Commander Trelle's journal", "_t")
t([[Well.  Turns out this peninsula's also home to an entire civilization of giants lurking in the mountains.  If we weren't so short on troops, my scouts would all be fired.  I appear to have accidentally deceived this construct into mistaking me for Aeryn, John, and King Tolak all at once, and while I am obligated to pass this letter on to them...  on further discussion with this Chief Councilor Tantalos, we have both realized that we can wait to inform them, as this presents an opportunity that neither of us can afford to waste.

Now, officially, both we and the Allied Kingdoms have a policy of capturing the remaining Orcs and taking them to the internment camp rather than killing them (when possible), which would require a far more decisive advantage than this outpost has.  Officially, we are to stay right where we are, containing the potential threat of the Kruk Pride rather than moving into their territory before they can amass their forces.  Officially, it would be forbidden for us to do anything about this problem until it's too late.  But...

#{italic}#Officially,#{normal}# the Atmos don't exist, and we have no knowledge of them whatsoever.  Officially, if a couple of Allied Kingdoms supply ships headed for the internment camp #{italic}#just happened#{normal}# to be waylaid by a hired band of pirates who #{italic}#got lucky#{normal}# and struck them just between their naval patrol routes, it'd be #{italic}#such a shame,#{normal}# and the Atmos couldn't be blamed if that armor and weaponry found itself in their hands.  Officially, we are not to leave our post under any circumstances, and if a mysterious band of giants descended from the mountains, crushed the Kruk Pride in their homeland, and forced them to flee, it would be against our orders to do anything about it, aside from eliminate any refugees who flee to our bridge; officially, this wouldn't impede the Atmos' negotiations with the Allied Kingdoms and Sunwall after this incident, because they couldn't have known we'd pursue a goal as naive as waiting to take the Orcs alive, and would grant them an uncontested claim to Kruk territory.

Unofficially?  I'm going to #{italic}#enjoy#{normal}# this.]], [[Well.  Turns out this peninsula's also home to an entire civilization of giants lurking in the mountains.  If we weren't so short on troops, my scouts would all be fired.  I appear to have accidentally deceived this construct into mistaking me for Aeryn, John, and King Tolak all at once, and while I am obligated to pass this letter on to them...  on further discussion with this Chief Councilor Tantalos, we have both realized that we can wait to inform them, as this presents an opportunity that neither of us can afford to waste.

Now, officially, both we and the Allied Kingdoms have a policy of capturing the remaining Orcs and taking them to the internment camp rather than killing them (when possible), which would require a far more decisive advantage than this outpost has.  Officially, we are to stay right where we are, containing the potential threat of the Kruk Pride rather than moving into their territory before they can amass their forces.  Officially, it would be forbidden for us to do anything about this problem until it's too late.  But...

#{italic}#Officially,#{normal}# the Atmos don't exist, and we have no knowledge of them whatsoever.  Officially, if a couple of Allied Kingdoms supply ships headed for the internment camp #{italic}#just happened#{normal}# to be waylaid by a hired band of pirates who #{italic}#got lucky#{normal}# and struck them just between their naval patrol routes, it'd be #{italic}#such a shame,#{normal}# and the Atmos couldn't be blamed if that armor and weaponry found itself in their hands.  Officially, we are not to leave our post under any circumstances, and if a mysterious band of giants descended from the mountains, crushed the Kruk Pride in their homeland, and forced them to flee, it would be against our orders to do anything about it, aside from eliminate any refugees who flee to our bridge; officially, this wouldn't impede the Atmos' negotiations with the Allied Kingdoms and Sunwall after this incident, because they couldn't have known we'd pursue a goal as naive as waiting to take the Orcs alive, and would grant them an uncontested claim to Kruk territory.

Unofficially?  I'm going to #{italic}#enjoy#{normal}# this.]], "_t")
t("a torn page from John's journal", "a torn page from John's journal", "_t")
t("Aeryn, my love...  I fear Trelle may be right, but I will hold this bridge without resorting to betraying you.  Still, though, I will remain vigilant of approaching attacks, and prepare to strike first if a battle really does seem inevitable.  As long as I stand,  no Orc will ever harm you again.  We will have a bright and shining future ahead of us, walking hand in hand into the dawn of a new, peaceful age...  and while I hope the Kruk Pride has a place there, I will not let them put this new age in jeopardy.", "Aeryn, my love...  I fear Trelle may be right, but I will hold this bridge without resorting to betraying you.  Still, though, I will remain vigilant of approaching attacks, and prepare to strike first if a battle really does seem inevitable.  As long as I stand,  no Orc will ever harm you again.  We will have a bright and shining future ahead of us, walking hand in hand into the dawn of a new, peaceful age...  and while I hope the Kruk Pride has a place there, I will not let them put this new age in jeopardy.", "_t")
t("King Tolak's Condemnation", "King Tolak's Condemnation", "_t")
t([[(As you approach the farportal, a herald emerges, holding an envelope; he doesn't quite hand it to you as much as throw it at you from a safe distance, then salutes and retreats back into the swirling rift.  The letter bears the royal seal of the Allied Kingdoms.)

%s...  I think I'm beginning to understand why you have acted this way.  At first, I was...  well, not as much surprised as disappointed.  I'd thought that showing your people mercy was the right decision.  That my father had been too consumed by rage, that the Orcs could be truly be better people if we gave them a chance, and if you were shown how much of a better place Eyal could be if you were to cooperate with us.  That no matter what my father, my mother, and my allies had told me, the Orcish race contained, somewhere deep down, the same potential for learning, growth, and beauty present in Humans, Halflings, Elves, Dwarves, and Ogres.

But now...  I see no good in you.  So many are dead, because I couldn't bring myself to admit that some people are beyond redemption.  Because I thought all you needed was a second chance, that you had goals other than blind, bloody revenge, that you'd see that we had held you in the grip of our absolute mercy, and opted to offer you an open hand rather than crush you as easily as clenching our fist.

I will not make the same mistake again.

You've shown me that the Orcish heart is empty of everything but lust for death and destruction, that no matter how good a future is laid out in front of you, you will discard it simply for the thrill of battle against the reasonable people who want this better future to come.  You've shown me that the prejudicies I've strived to transcend were right all along.  You've shown me that my father's only mistake was not going far enough - a continent free of Orcs is not enough to keep us safe.  Instead, your kind must be purged from all of Eyal - and the battle to make this happen is inevitable, for you will continue pushing for it no matter how much we try to make peace an option.  And yet...  you've made me understand the reason of this approach, of treating everyone else like an irrational threat to your existence, for it is the only proper way for us to treat you.

You won't get another second chance from us.  Instead, we'll give you the only thing you've ever wanted: a battle.  Through this portal waits the army of the Allied Kingdoms, once foes or begrudging co-inhabitants who have grown into true allies because we have a desire for peace and cooperation that your kind will never know.  We wait on an open battlefield, ready to demonstrate our combined might.  The Shaloren of Elvala prepare spells as the Ogres grip their clubs tighter; the Halflings and Humans of Derth and Last Hope have forgotten their age-old rivalry, working together to brew alchemical bombs and build great golems, or take up positions with a bow or sling; the Dwarves of Iron Throne and the Thaloren of Shatur, not even proper allies with us before now, realize you are too great a threat to go neglected, and now our ranks are lined with Wilders summoning countless beasts and treants, and fierce warriors who will #{italic}#not#{normal}# be moved.  Even the forces of the Sunwall have joined us, a contingent of their finest warriors sent to reinforce our lines and quickly train our soldiers in the magical techniques they've honed over the years, using you irredeemable savages as their sharpening stones.

I shall be waiting in the front line of this glorious alliance, sword in hand.  I, King Tolak the Fair, son of Toknor who once purged your people from Maj'Eyal, I who once fought to spare your kind from slavery or extinction, now eagerly await the opportunity to finish what he started.  If I die, Toknor's bloodline dies with me; this is a risk I am willing - no, #{italic}#excited#{normal}# to take, to settle the fate of all civilized peoples of Eyal, once and for all.

You want your revenge on my father's people, foul cur?  #{italic}#Come and get it.#{normal}#

(You admit, it is rather tempting...  but the guaranteed safety of your people takes priority, and besides, you wouldn't put it past the Allied Kingdoms to have a team of archers and slingers waiting to snipe everyone who came through, one by one.  You destroy the portal, eliminating King Tolak's army as a threat, and ensuring Sun Paladin Aeryn won't be getting any reinforcements.  Time to take advantage of your newfound privacy, and finish off the Sunwall forces, once and for all...)]], [[(As you approach the farportal, a herald emerges, holding an envelope; he doesn't quite hand it to you as much as throw it at you from a safe distance, then salutes and retreats back into the swirling rift.  The letter bears the royal seal of the Allied Kingdoms.)

%s...  I think I'm beginning to understand why you have acted this way.  At first, I was...  well, not as much surprised as disappointed.  I'd thought that showing your people mercy was the right decision.  That my father had been too consumed by rage, that the Orcs could be truly be better people if we gave them a chance, and if you were shown how much of a better place Eyal could be if you were to cooperate with us.  That no matter what my father, my mother, and my allies had told me, the Orcish race contained, somewhere deep down, the same potential for learning, growth, and beauty present in Humans, Halflings, Elves, Dwarves, and Ogres.

But now...  I see no good in you.  So many are dead, because I couldn't bring myself to admit that some people are beyond redemption.  Because I thought all you needed was a second chance, that you had goals other than blind, bloody revenge, that you'd see that we had held you in the grip of our absolute mercy, and opted to offer you an open hand rather than crush you as easily as clenching our fist.

I will not make the same mistake again.

You've shown me that the Orcish heart is empty of everything but lust for death and destruction, that no matter how good a future is laid out in front of you, you will discard it simply for the thrill of battle against the reasonable people who want this better future to come.  You've shown me that the prejudicies I've strived to transcend were right all along.  You've shown me that my father's only mistake was not going far enough - a continent free of Orcs is not enough to keep us safe.  Instead, your kind must be purged from all of Eyal - and the battle to make this happen is inevitable, for you will continue pushing for it no matter how much we try to make peace an option.  And yet...  you've made me understand the reason of this approach, of treating everyone else like an irrational threat to your existence, for it is the only proper way for us to treat you.

You won't get another second chance from us.  Instead, we'll give you the only thing you've ever wanted: a battle.  Through this portal waits the army of the Allied Kingdoms, once foes or begrudging co-inhabitants who have grown into true allies because we have a desire for peace and cooperation that your kind will never know.  We wait on an open battlefield, ready to demonstrate our combined might.  The Shaloren of Elvala prepare spells as the Ogres grip their clubs tighter; the Halflings and Humans of Derth and Last Hope have forgotten their age-old rivalry, working together to brew alchemical bombs and build great golems, or take up positions with a bow or sling; the Dwarves of Iron Throne and the Thaloren of Shatur, not even proper allies with us before now, realize you are too great a threat to go neglected, and now our ranks are lined with Wilders summoning countless beasts and treants, and fierce warriors who will #{italic}#not#{normal}# be moved.  Even the forces of the Sunwall have joined us, a contingent of their finest warriors sent to reinforce our lines and quickly train our soldiers in the magical techniques they've honed over the years, using you irredeemable savages as their sharpening stones.

I shall be waiting in the front line of this glorious alliance, sword in hand.  I, King Tolak the Fair, son of Toknor who once purged your people from Maj'Eyal, I who once fought to spare your kind from slavery or extinction, now eagerly await the opportunity to finish what he started.  If I die, Toknor's bloodline dies with me; this is a risk I am willing - no, #{italic}#excited#{normal}# to take, to settle the fate of all civilized peoples of Eyal, once and for all.

You want your revenge on my father's people, foul cur?  #{italic}#Come and get it.#{normal}#

(You admit, it is rather tempting...  but the guaranteed safety of your people takes priority, and besides, you wouldn't put it past the Allied Kingdoms to have a team of archers and slingers waiting to snipe everyone who came through, one by one.  You destroy the portal, eliminating King Tolak's army as a threat, and ensuring Sun Paladin Aeryn won't be getting any reinforcements.  Time to take advantage of your newfound privacy, and finish off the Sunwall forces, once and for all...)]], "tformat")
t("Sun Paladin report", "Sun Paladin report", "_t")
t([[Lady Aeryn,

My apologies, but you're going to have to go back to King Tolak empty-handed - we still don't have any idea how the smugglers are getting through.  The best evidence we've got is some rumbling in the desert near the Dominion Port (which is still too heavily guarded for a direct attack before the Allied Kingdoms can grant us full assistance), suggesting geomantic tunnel formation, but that could just as easily be the few of Briagh's spawn that the Hero of Maj'Eyal didn't mop up.  Scrying spells aren't helping either - there's some sort of counter-scrying ward being applied, but it's so well-hidden that we can't tell where on the continent it's coming from or how many entities are being affected by it.  The only thing that seems certain is that they've got another farportal hacked together - the only one we know of is right in the middle of Gates of Morning, and I'd like to think that we're not so incompetent we wouldn't notice a steady stream of slavers and bootleggers strolling past 70% of us.  If they're actually using that one, then they're using the best invisibility spell we have ever seen.

...Haven't ever seen?  Whatever.

Anyway, my advice is to request permission to send a few Shining Inquisitors to King Tolak to assist in the investigations on his end.  However they're evading detection here in the East, they either can't use it in the West or simply let their guard down once they're back home, judging from the rising arrest rates - we can help the Allied Kingdoms hit the weak link of this chain, and have the Inquisitors keep an eye on things in Maj'Eyal while they're at it.  Not that I don't trust that King Tolak intends to honor his commitment to keep those foul Ziguranth from ever pulling off anything like the Sunset Massacre again, but...  well, if a farportal altar made it onto the black market under the Allied Kingdoms' watch, possibly courtesy of a mad alchemist who lived practically next door to the King, I don't have too much faith in their ability to drag a bunch of clandestine fanatics into the light, out from the cover of that supposedly-benign Menders group.  I'm sure they're trying their hardest; all I'm suggesting is that we do the same.]], [[Lady Aeryn,

My apologies, but you're going to have to go back to King Tolak empty-handed - we still don't have any idea how the smugglers are getting through.  The best evidence we've got is some rumbling in the desert near the Dominion Port (which is still too heavily guarded for a direct attack before the Allied Kingdoms can grant us full assistance), suggesting geomantic tunnel formation, but that could just as easily be the few of Briagh's spawn that the Hero of Maj'Eyal didn't mop up.  Scrying spells aren't helping either - there's some sort of counter-scrying ward being applied, but it's so well-hidden that we can't tell where on the continent it's coming from or how many entities are being affected by it.  The only thing that seems certain is that they've got another farportal hacked together - the only one we know of is right in the middle of Gates of Morning, and I'd like to think that we're not so incompetent we wouldn't notice a steady stream of slavers and bootleggers strolling past 70% of us.  If they're actually using that one, then they're using the best invisibility spell we have ever seen.

...Haven't ever seen?  Whatever.

Anyway, my advice is to request permission to send a few Shining Inquisitors to King Tolak to assist in the investigations on his end.  However they're evading detection here in the East, they either can't use it in the West or simply let their guard down once they're back home, judging from the rising arrest rates - we can help the Allied Kingdoms hit the weak link of this chain, and have the Inquisitors keep an eye on things in Maj'Eyal while they're at it.  Not that I don't trust that King Tolak intends to honor his commitment to keep those foul Ziguranth from ever pulling off anything like the Sunset Massacre again, but...  well, if a farportal altar made it onto the black market under the Allied Kingdoms' watch, possibly courtesy of a mad alchemist who lived practically next door to the King, I don't have too much faith in their ability to drag a bunch of clandestine fanatics into the light, out from the cover of that supposedly-benign Menders group.  I'm sure they're trying their hardest; all I'm suggesting is that we do the same.]], "_t")
t("journal of High Sun Paladin Aeryn", "journal of High Sun Paladin Aeryn", "_t")
t([[This is it...  the day I've dreaded for most of my life is here, and yet it still comes as a shock.  I expected it for almost every day of my life...  until last year.  The Scourge from the West defeated the Prides, raced down the Charred Scar, and stormed the tower of High Peak to fight by my side against a threat far greater than I dreamed possible.  We'd been reunited with a cooperative and nearly-unified Maj'Eyal, led by a king willing and able to help us in any way, armed with a plan to keep the orcs completely under control...  it's as if the Sun had begun to creep over the horizon to start the dawn of peace in Var'Eyal, right before going dark forever and taking the moons with it.  The love of my life is presumed dead; the candle in the night of the years before has been snuffed out. Nothing - no plan that hasn't been shattered, no inspiration that hasn't fallen, no hope that hasn't turned to despair - is left to guide me.

I must be that light for my allies' sake.  I must be strong, resolute, giving them whatever tiny amounts of hope I can.  Not only to keep their morale up and give us a chance of prevailing against the unstoppable menace which the Sunwall has stood against for ages...  but so that their last thoughts in death might be that their sacrifice has saved us all.  Maybe one of them will be right.

All I can hope is that King Tolak has learned something about the Orcs, before his kingdom falls as well.  I do not begrudge him, everything he did was rooted in wisdom and kindness...  and would have worked for any species but the Orcs.  They are the sole exception that deserves no mercy.]], [[This is it...  the day I've dreaded for most of my life is here, and yet it still comes as a shock.  I expected it for almost every day of my life...  until last year.  The Scourge from the West defeated the Prides, raced down the Charred Scar, and stormed the tower of High Peak to fight by my side against a threat far greater than I dreamed possible.  We'd been reunited with a cooperative and nearly-unified Maj'Eyal, led by a king willing and able to help us in any way, armed with a plan to keep the orcs completely under control...  it's as if the Sun had begun to creep over the horizon to start the dawn of peace in Var'Eyal, right before going dark forever and taking the moons with it.  The love of my life is presumed dead; the candle in the night of the years before has been snuffed out. Nothing - no plan that hasn't been shattered, no inspiration that hasn't fallen, no hope that hasn't turned to despair - is left to guide me.

I must be that light for my allies' sake.  I must be strong, resolute, giving them whatever tiny amounts of hope I can.  Not only to keep their morale up and give us a chance of prevailing against the unstoppable menace which the Sunwall has stood against for ages...  but so that their last thoughts in death might be that their sacrifice has saved us all.  Maybe one of them will be right.

All I can hope is that King Tolak has learned something about the Orcs, before his kingdom falls as well.  I do not begrudge him, everything he did was rooted in wisdom and kindness...  and would have worked for any species but the Orcs.  They are the sole exception that deserves no mercy.]], "_t")
t("kindness", "kindness", "_t")
t([[I stuck up for you. I wanted to forgive you, to give you time and safety to see we meant no harm.  I forgave you for the ages we spent in fear, the lives we lost, for I imagined I could have been tempted to do the same in your position.

Now I see where kindness and mercy get me.]], [[I stuck up for you. I wanted to forgive you, to give you time and safety to see we meant no harm.  I forgave you for the ages we spent in fear, the lives we lost, for I imagined I could have been tempted to do the same in your position.

Now I see where kindness and mercy get me.]], "_t")
t("hope", "hope", "_t")
t([[You took everything from me.  You took the dawn of a beautiful future, you took the fires of hope and happiness, you took the kind, guiding light of my love Aeryn and put out the glow of the life we deserved to have together.  The light is gone...  but you have given me darkness in return.  And you're about to know that darkness very, very well.  Embracing it fully rather than shutting it out...  It's so easy to use these powers now.  I've felt them before, but I had no hate to use as their inspiration,  no true misery to pour into the minds deserving, no empty void inside me to drain your hopes and confidence into.  You've fixed that for me.

My heart still beats, but you have taken my life nonetheless.  You'll understand shortly.]], [[You took everything from me.  You took the dawn of a beautiful future, you took the fires of hope and happiness, you took the kind, guiding light of my love Aeryn and put out the glow of the life we deserved to have together.  The light is gone...  but you have given me darkness in return.  And you're about to know that darkness very, very well.  Embracing it fully rather than shutting it out...  It's so easy to use these powers now.  I've felt them before, but I had no hate to use as their inspiration,  no true misery to pour into the minds deserving, no empty void inside me to drain your hopes and confidence into.  You've fixed that for me.

My heart still beats, but you have taken my life nonetheless.  You'll understand shortly.]], "_t")
t("suffering", "suffering", "_t")
t([[Fall.  Suffer.  Lose the hope that drives you, or whatever brutish instinct suffices for it in your abominable mind.  Feel the pain you caused me, and know that it will never, ever stop...  you can feel it eroding your will to keep going, can't you?

When your shattered mind succumbs to the pain you gave me, I will take it for my own.  I'll give you back just a little of the hope and love I took, so when you're a mere passenger in your own body, I can watch that light grow dark, as you watch your own body finding everyone you love and killing them slowly and painfully.  Their last words will be cursing your name, and you will be both powerless to stop it, and all too aware that it's your own fault for not preventing it sooner.

Then, and only then, will you fully understand what you did to me.]], [[Fall.  Suffer.  Lose the hope that drives you, or whatever brutish instinct suffices for it in your abominable mind.  Feel the pain you caused me, and know that it will never, ever stop...  you can feel it eroding your will to keep going, can't you?

When your shattered mind succumbs to the pain you gave me, I will take it for my own.  I'll give you back just a little of the hope and love I took, so when you're a mere passenger in your own body, I can watch that light grow dark, as you watch your own body finding everyone you love and killing them slowly and painfully.  Their last words will be cursing your name, and you will be both powerless to stop it, and all too aware that it's your own fault for not preventing it sooner.

Then, and only then, will you fully understand what you did to me.]], "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/weissi.lua"
-- 15 entries
t("telepathic message (1)", "telepathic message (1)", "_t")
t([[As you descend the stairway down, you find yourself faced with what appears to be a solid wall of stone, a natural dead-end in a cave.  You start to turn around and walk back up, when you hear a crescendo of cracking and rumbling behind you; you turn back and see the stone falling away, revealing a smooth, white door, which promptly slides into the floor.  The doorway leads to a white hallway of indeterminate construction; rather than having fixed lighting, every square inch of the walls, floors, and ceiling slowly illuminates to a comfortable (if slightly teal-tinged) glow.  It should be beautiful, clean, peaceful, and serene...  and yet your instincts are screaming at you to get out as soon as you can and forget what you've seen here.  A few open panels on the walls reveal an assortment of inscrutable machinery, incorporating a variety of unidentifiable magical and psionic artifacts, yet one appears to be a sort of crushing device made with steam-tech, an invention that is surely newer than these ruins...  the crushing device abruptly activates when you ponder it, pressing minerals into a freshly-formed mindstar-like crystal.  A voice, one that should be soothing but disturbs you on a deeper level than you can translate into conscious thought, enters your mind as the crystal flickers:

"Welcome, %s.  We've been expecting you.  Unfortunately, we can't join you, but we can assure you that what lies ahead can only help you in your quests.  The door will seal behind you to ensure your safety, and reopen the moment you want to leave.  Come.  Learn, discover, and realize how our plans are advantageous to both of us."

Well...  that isn't terribly reassuring.  You hesitantly step forward, expecting a trap and ready to turn around and bolt at a moment's notice--

The floor disappears from under you, and yet after falling only an inch, you suddenly feel weightless.  You turn; the freshly-formed mindstar, already beginning to crack, is glowing intensely.  "We know that isn't terribly reassuring.  We don't care if you WERE expecting a trap, and if we truly wanted to kill you, bolting at a moment's notice wouldn't be fast enough.  In fact, it'd be very easy indeed."  You are abruptly thrown near the bottom of the pit towards a series of spikes by telekinetic force, then stop, held motionless inches above them.  "Clearly, we don't want you dead or even slightly harmed," the voice from inside your head says, as the spikes retract into the pit floor and you slowly levitate back into the illuminated halls.  "Now that we've established that...  let us help you."  You float to the top, and find yourself standing on solid ground as the floor rematerializes under you and the telekinetic force vanishes, moments before the mindstar shatters.

Nonetheless, you feel you shouldn't be here.  The fact that this place exists at all feels...  wrong.
]], [[As you descend the stairway down, you find yourself faced with what appears to be a solid wall of stone, a natural dead-end in a cave.  You start to turn around and walk back up, when you hear a crescendo of cracking and rumbling behind you; you turn back and see the stone falling away, revealing a smooth, white door, which promptly slides into the floor.  The doorway leads to a white hallway of indeterminate construction; rather than having fixed lighting, every square inch of the walls, floors, and ceiling slowly illuminates to a comfortable (if slightly teal-tinged) glow.  It should be beautiful, clean, peaceful, and serene...  and yet your instincts are screaming at you to get out as soon as you can and forget what you've seen here.  A few open panels on the walls reveal an assortment of inscrutable machinery, incorporating a variety of unidentifiable magical and psionic artifacts, yet one appears to be a sort of crushing device made with steam-tech, an invention that is surely newer than these ruins...  the crushing device abruptly activates when you ponder it, pressing minerals into a freshly-formed mindstar-like crystal.  A voice, one that should be soothing but disturbs you on a deeper level than you can translate into conscious thought, enters your mind as the crystal flickers:

"Welcome, %s.  We've been expecting you.  Unfortunately, we can't join you, but we can assure you that what lies ahead can only help you in your quests.  The door will seal behind you to ensure your safety, and reopen the moment you want to leave.  Come.  Learn, discover, and realize how our plans are advantageous to both of us."

Well...  that isn't terribly reassuring.  You hesitantly step forward, expecting a trap and ready to turn around and bolt at a moment's notice--

The floor disappears from under you, and yet after falling only an inch, you suddenly feel weightless.  You turn; the freshly-formed mindstar, already beginning to crack, is glowing intensely.  "We know that isn't terribly reassuring.  We don't care if you WERE expecting a trap, and if we truly wanted to kill you, bolting at a moment's notice wouldn't be fast enough.  In fact, it'd be very easy indeed."  You are abruptly thrown near the bottom of the pit towards a series of spikes by telekinetic force, then stop, held motionless inches above them.  "Clearly, we don't want you dead or even slightly harmed," the voice from inside your head says, as the spikes retract into the pit floor and you slowly levitate back into the illuminated halls.  "Now that we've established that...  let us help you."  You float to the top, and find yourself standing on solid ground as the floor rematerializes under you and the telekinetic force vanishes, moments before the mindstar shatters.

Nonetheless, you feel you shouldn't be here.  The fact that this place exists at all feels...  wrong.
]], "tformat")
t("telepathic message (2)", "telepathic message (2)", "_t")
t([[Did you know the Sher'Tul had brothers?  Long before their creation, when the gods were still young and gleeful, Quekjora convinced them they could work together to bring life to Eyal. Perhaps they could have, were they more mature at the time...  Eager cooperation withered under exposure to personal tastes and creative differences, the friendships of our creators turned to animosity, and yet we were still made.
 
We had no overt flaws.  The gods were mercilessly vigilant, eager to use any imperfections as an excuse to berate their perpetrator and claim superiority, and thus we were only allowed to live when they were out of ammunition to use.  We seemed perfect, even to a deep inspection...
 
I doubt any of them deliberately cursed us - no one of them could've done something so powerful.  Subconscious touches, psychic leakage, and other such imperceptible forces added up over time to indicate one inescapable truth: we were not wanted.  We had been forged in a bitter compromise, one desired by nobody involved; their hatred, their neglect, their frustration is the foundation of everything we are, and we carry it deep within ourselves.  Perhaps such a creature naturally attracts the ire of the universe, of fate itself. 

Or maybe we just angered someone powerful enough to put a retroactive temporal curse on us, or it was Amakthel personally ensuring his pet project would have no equals. We may never be certain.  All we know is, something - be it probability, or the universe's combined will, or simply our own bad luck - will not tolerate our existence, nor that of anything like us.
]], [[Did you know the Sher'Tul had brothers?  Long before their creation, when the gods were still young and gleeful, Quekjora convinced them they could work together to bring life to Eyal. Perhaps they could have, were they more mature at the time...  Eager cooperation withered under exposure to personal tastes and creative differences, the friendships of our creators turned to animosity, and yet we were still made.
 
We had no overt flaws.  The gods were mercilessly vigilant, eager to use any imperfections as an excuse to berate their perpetrator and claim superiority, and thus we were only allowed to live when they were out of ammunition to use.  We seemed perfect, even to a deep inspection...
 
I doubt any of them deliberately cursed us - no one of them could've done something so powerful.  Subconscious touches, psychic leakage, and other such imperceptible forces added up over time to indicate one inescapable truth: we were not wanted.  We had been forged in a bitter compromise, one desired by nobody involved; their hatred, their neglect, their frustration is the foundation of everything we are, and we carry it deep within ourselves.  Perhaps such a creature naturally attracts the ire of the universe, of fate itself. 

Or maybe we just angered someone powerful enough to put a retroactive temporal curse on us, or it was Amakthel personally ensuring his pet project would have no equals. We may never be certain.  All we know is, something - be it probability, or the universe's combined will, or simply our own bad luck - will not tolerate our existence, nor that of anything like us.
]], "_t")
t("telepathic message (3)", "telepathic message (3)", "_t")
t([[Did you know you killed us? You did, in one potential future, ordering our genocide from atop a steel drake.  In others, it was the Dominion, the Allied Kingdoms, Flamewright Industries, the Zigur-Thaloren Pact, or countless other transient mortal city-states.  We've been torn apart by Gerlyk, and dissected by Angolwen at the direction of Headmistress Argoniel or Chief Genius Tannen (yes, the smug git actually called himself that).  We've been devoured (literally and metaphorically) by the New Conclave under Mother Astelrid, wiped out by a plague engineered by the Grand Corruptor, drowned as the world was flooded by the Naloren, and reduced to ash by the reborn Crimson Dragonbrood.  We've been captured as torture-toys by the Demons and The Master's undead servitors, hunted for magical reagents by the Reknor Confederacy, and kept as adding machines by the Greater Republic of Steam.

You know, you should thank the Scourge from the West.  We certainly do.

In most, it was the Sher'Tul, eliminating their closest competitor, or the Mal'Rokka, taking Eyal for themselves.  In the few where we won every war, a meteor destroyed Eyal instead - a meteor that has now been intercepted by debris, from what you call the Spellblaze.  You're welcome - a contingent of our people kept the Mal'Rokka suppressed for long enough to allow that to happen.  If you want to see an example of how thoroughly existence wants to erase us, just ask them what they know about the "Dust Mages."

We don't advise learning psychic prognostication with such commitment as we did.  To see this many possibilities, to gaze into infinity with such detail without infinity gazing back...  you have to feel it.  Every spear through our hearts, every limb burned off...  and we all did it together, linking our minds to accomplish this, so all of us have suffered through this.  And after all that, we still can't be 100% sure it's accurate, although we've gotten to more 9s after 99.9% than we can actually count.]], [[Did you know you killed us? You did, in one potential future, ordering our genocide from atop a steel drake.  In others, it was the Dominion, the Allied Kingdoms, Flamewright Industries, the Zigur-Thaloren Pact, or countless other transient mortal city-states.  We've been torn apart by Gerlyk, and dissected by Angolwen at the direction of Headmistress Argoniel or Chief Genius Tannen (yes, the smug git actually called himself that).  We've been devoured (literally and metaphorically) by the New Conclave under Mother Astelrid, wiped out by a plague engineered by the Grand Corruptor, drowned as the world was flooded by the Naloren, and reduced to ash by the reborn Crimson Dragonbrood.  We've been captured as torture-toys by the Demons and The Master's undead servitors, hunted for magical reagents by the Reknor Confederacy, and kept as adding machines by the Greater Republic of Steam.

You know, you should thank the Scourge from the West.  We certainly do.

In most, it was the Sher'Tul, eliminating their closest competitor, or the Mal'Rokka, taking Eyal for themselves.  In the few where we won every war, a meteor destroyed Eyal instead - a meteor that has now been intercepted by debris, from what you call the Spellblaze.  You're welcome - a contingent of our people kept the Mal'Rokka suppressed for long enough to allow that to happen.  If you want to see an example of how thoroughly existence wants to erase us, just ask them what they know about the "Dust Mages."

We don't advise learning psychic prognostication with such commitment as we did.  To see this many possibilities, to gaze into infinity with such detail without infinity gazing back...  you have to feel it.  Every spear through our hearts, every limb burned off...  and we all did it together, linking our minds to accomplish this, so all of us have suffered through this.  And after all that, we still can't be 100% sure it's accurate, although we've gotten to more 9s after 99.9% than we can actually count.]], "_t")
t("telepathic message (4)", "telepathic message (4)", "_t")
t([[Do you know what would've happened if you hadn't stepped up to defend Kruk Pride?  The Allied Kingdoms could've gone on to keep the entire world under its thumb.  One unified army, marching under one banner, ready to eliminate us when we're reborn...  and that's assuming that a certain greater threat didn't step in first.  We don't want that, and neither do you.

Deception is beneath us; if there's one thing our creation taught us, it's that respect and alliance are unnecessary for cooperation, if there's an immediate common need to be fulfilled.  We've prepared some of this machinery to enhance your abilities, and grant you new knowledge...  it will serve you well in preserving Eyal's immediate existence, and granting the Orcs a land of their own.  A land that'll have to fight to survive, fending off the Dominion, the Allied Kingdoms, the warped Mal'Rokka calling themselves demons, the Naloren remnants...  and I wouldn't want to spoil the fun by saying what other sorts of special guests are arriving.  Don't worry, we won't be giving anyone an unfair advantage; you, and they, would just stab us in the back anyway.

The storm is coming.  It's going to be a bloodbath.  We see no need to be present for it, not until the last man is standing, wounded and exhausted, atop a pile of corpses.  He'll be an easy target.

You could always give up.  Stop fighting.  Let the Allied Kingdoms have Eyal, and be the latest in a long line of factors conspiring to prevent our rebirth.  Sacrifice your people to "save Eyal" from having us on it.  You won't, though, because you have something we'll never have: hope.  Hope that we can be fought off, that our return won't come in your lifetime.  Our predictions aren't 100% accurate anyway; who are we to take that hope from you?
]], [[Do you know what would've happened if you hadn't stepped up to defend Kruk Pride?  The Allied Kingdoms could've gone on to keep the entire world under its thumb.  One unified army, marching under one banner, ready to eliminate us when we're reborn...  and that's assuming that a certain greater threat didn't step in first.  We don't want that, and neither do you.

Deception is beneath us; if there's one thing our creation taught us, it's that respect and alliance are unnecessary for cooperation, if there's an immediate common need to be fulfilled.  We've prepared some of this machinery to enhance your abilities, and grant you new knowledge...  it will serve you well in preserving Eyal's immediate existence, and granting the Orcs a land of their own.  A land that'll have to fight to survive, fending off the Dominion, the Allied Kingdoms, the warped Mal'Rokka calling themselves demons, the Naloren remnants...  and I wouldn't want to spoil the fun by saying what other sorts of special guests are arriving.  Don't worry, we won't be giving anyone an unfair advantage; you, and they, would just stab us in the back anyway.

The storm is coming.  It's going to be a bloodbath.  We see no need to be present for it, not until the last man is standing, wounded and exhausted, atop a pile of corpses.  He'll be an easy target.

You could always give up.  Stop fighting.  Let the Allied Kingdoms have Eyal, and be the latest in a long line of factors conspiring to prevent our rebirth.  Sacrifice your people to "save Eyal" from having us on it.  You won't, though, because you have something we'll never have: hope.  Hope that we can be fought off, that our return won't come in your lifetime.  Our predictions aren't 100% accurate anyway; who are we to take that hope from you?
]], "_t")
t("telepathic message (5)", "telepathic message (5)", "_t")
t([[Did you wonder what happened to us?  We wouldn't give fate the satisfaction of killing us through some unlikely coincidence.  We killed ourselves - but not before planting our seeds.

We accomplished a lot before we did, and we wouldn't want to have to accomplish that all over again.  Of course, if we kept that all in one place, our curse would notice it and eradicate it - so we split ourselves and our accomplishments into pieces, and obfuscated them through millenia of evolution and subtle manipulation.  You've probably met one piece of these - the body.  Strong.  Resilient.  Capable of living in any environment.  Rapidly healing.  Eternally youthful.  And very, very easy to assume control of, via psychic transfer, once we decide the time is right...  You're probably considering ordering your Pride to exterminate all the yetis you can.  Go ahead, eliminate all that free labor and see how you fare when the Dominion's using slaves and the Allied Kingdoms have ogres and dwarves.  Once again, it doesn't matter whether or not it's helping us, because it's something you need to survive.

That's only a third of what we could preserve, though.  The next is our mental processing ability, our psionically adept minds, our ability to assess information rapidly and logically analyze it.  You'll never be able to eradicate the Yeeks - believe us, we checked.  They seem to be as blessed as we are cursed, except that we're still doomed if we simply try to hide in them.  Pity, that.  Regardless, their brains and the system they are carrying will continue to exist; they will maintain our Way in our absence.

Lastly, there's our culture.  Our discoveries.  Everything we learned and didn't put into our bodies or brains, we stored with...  another group.  One that expands beyond the stars, one who we've disseminated countless subtly-encoded bits of information to, one with backups in so many places across the universe...  They'll deliver enough of it back home.  The Yeeks will absorb it, and we will be reborn in their minds until they can put us in our superior bodies.

Once the storm comes to Eyal, once the conflict is resolved...  perhaps the tide of hate and malice brought by such a massive war will distract the universe enough to let us combine our pieces and be reborn.  Or perhaps we will be able to do so once the gods are all dead or mad, their anger forgotten or nullified, the curse in turn having no fuel to keep going.  Perhaps the curse is already dying, only perpetuated by the Sher'Tul planetary shield - one that's gradually beginning to fail, cracks forming on it and the Mal'Rokka eagerly prying them wider.

And if not?  Our culture is everywhere.  We can't be completely removed without destroying it all.  Fate has decided we are a tumor to be excised; if we're going to be a tumor, we're now an invasive one.  Now fate can decide if we're a benign growth, or terminally malignant.  

Would you expect anything less from the physical incarnations of spiteful determination?
]], [[Did you wonder what happened to us?  We wouldn't give fate the satisfaction of killing us through some unlikely coincidence.  We killed ourselves - but not before planting our seeds.

We accomplished a lot before we did, and we wouldn't want to have to accomplish that all over again.  Of course, if we kept that all in one place, our curse would notice it and eradicate it - so we split ourselves and our accomplishments into pieces, and obfuscated them through millenia of evolution and subtle manipulation.  You've probably met one piece of these - the body.  Strong.  Resilient.  Capable of living in any environment.  Rapidly healing.  Eternally youthful.  And very, very easy to assume control of, via psychic transfer, once we decide the time is right...  You're probably considering ordering your Pride to exterminate all the yetis you can.  Go ahead, eliminate all that free labor and see how you fare when the Dominion's using slaves and the Allied Kingdoms have ogres and dwarves.  Once again, it doesn't matter whether or not it's helping us, because it's something you need to survive.

That's only a third of what we could preserve, though.  The next is our mental processing ability, our psionically adept minds, our ability to assess information rapidly and logically analyze it.  You'll never be able to eradicate the Yeeks - believe us, we checked.  They seem to be as blessed as we are cursed, except that we're still doomed if we simply try to hide in them.  Pity, that.  Regardless, their brains and the system they are carrying will continue to exist; they will maintain our Way in our absence.

Lastly, there's our culture.  Our discoveries.  Everything we learned and didn't put into our bodies or brains, we stored with...  another group.  One that expands beyond the stars, one who we've disseminated countless subtly-encoded bits of information to, one with backups in so many places across the universe...  They'll deliver enough of it back home.  The Yeeks will absorb it, and we will be reborn in their minds until they can put us in our superior bodies.

Once the storm comes to Eyal, once the conflict is resolved...  perhaps the tide of hate and malice brought by such a massive war will distract the universe enough to let us combine our pieces and be reborn.  Or perhaps we will be able to do so once the gods are all dead or mad, their anger forgotten or nullified, the curse in turn having no fuel to keep going.  Perhaps the curse is already dying, only perpetuated by the Sher'Tul planetary shield - one that's gradually beginning to fail, cracks forming on it and the Mal'Rokka eagerly prying them wider.

And if not?  Our culture is everywhere.  We can't be completely removed without destroying it all.  Fate has decided we are a tumor to be excised; if we're going to be a tumor, we're now an invasive one.  Now fate can decide if we're a benign growth, or terminally malignant.  

Would you expect anything less from the physical incarnations of spiteful determination?
]], "_t")
t("lost city", "lost city", "newLore category")
t("telepathic message (6)", "telepathic message (6)", "_t")
t([[If you would indulge us...  Next to you is a tablet that was just carved by our machines, moments before you arrived.  If our curse holds, it will be completely illegible, but if it has been lifted, it will bear our name.  A blatant, distinct word that is an undeniable mark of our existence, a sign that no matter how it may have wanted to, the universe could not forget us.  Look to your right, and learn the name of those who have far more right to exist than you do, who have fought far harder for it, and will sink their hooks so deep into reality that it must either lift them up or be dragged into the depths with them.  Learn the name feared by existence itself!

#{italic}#(You look to your right, and see a tablet which has been broken into fragments.  The fragments are still arranged roughly in the right shape, and you can read a single word; another, larger fragment bears a sentence.)#{normal}#

]], [[If you would indulge us...  Next to you is a tablet that was just carved by our machines, moments before you arrived.  If our curse holds, it will be completely illegible, but if it has been lifted, it will bear our name.  A blatant, distinct word that is an undeniable mark of our existence, a sign that no matter how it may have wanted to, the universe could not forget us.  Look to your right, and learn the name of those who have far more right to exist than you do, who have fought far harder for it, and will sink their hooks so deep into reality that it must either lift them up or be dragged into the depths with them.  Learn the name feared by existence itself!

#{italic}#(You look to your right, and see a tablet which has been broken into fragments.  The fragments are still arranged roughly in the right shape, and you can read a single word; another, larger fragment bears a sentence.)#{normal}#

]], "_t")
t([[#{bold}#WEISSI

DO YOU KNOW OUR NAME?#{normal}#]], [[#{bold}#WEISSI

DO YOU KNOW OUR NAME?#{normal}#]], "_t")
t([[#{italic}#(Somehow the name seems to have faded from your memory!)#{normal}#

DO YOU KNOW OUR NAME?#{normal}#]], [[#{italic}#(Somehow the name seems to have faded from your memory!)#{normal}#

DO YOU KNOW OUR NAME?#{normal}#]], "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/lore/yeti.lua"
-- 7 entries
t("crude cave painting (1)", "crude cave painting (1)", "_t")
t("You see here a crude cave painting, depicting a drake attacking a group of yetis, as an indistinct figure watches over them.  To the right, you see a drawing of the figure attacking the drake, and the yetis cheering.", "You see here a crude cave painting, depicting a drake attacking a group of yetis, as an indistinct figure watches over them.  To the right, you see a drawing of the figure attacking the drake, and the yetis cheering.", "_t")
t("crude cave painting (2)", "crude cave painting (2)", "_t")
t("You see here a cave painting, depicting a giant attempting to lead some yetis away in chains, but being pulled down and mauled by other yetis.", "You see here a cave painting, depicting a giant attempting to lead some yetis away in chains, but being pulled down and mauled by other yetis.", "_t")
t("yeti's cave", "yeti's cave", "newLore category")
t("crude cave painting (3)", "crude cave painting (3)", "_t")
t("You see here a cave painting, depicting a giant holding an object, which is projecting some sort of beam at a yeti.  The affected yeti is walking toward the giant, while other yetis are looking on in horror.", "You see here a cave painting, depicting a giant holding an object, which is projecting some sort of beam at a yeti.  The affected yeti is walking toward the giant, while other yetis are looking on in horror.", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/amakthel.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/free-prides.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/gem.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/kill-dominion.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/krimbul.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/palace.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/ritch-hive.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/sunwall-observatory.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/weissi.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/quests/yeti-abduction.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/celestial/celestial-empyreal.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/data/talents/uber/mag.lua"
-- 1 entries
t([[You create an Arcane Amplification Drone at the selected location for 3 turns.
		When you cast a spell that damages the drone it will ripple the damage as 130%% arcane damage of the initial hit in radius 4.]], [[You create an Arcane Amplification Drone at the selected location for 3 turns.
		When you cast a spell that damages the drone it will ripple the damage as 130%% arcane damage of the initial hit in radius 4.]], "tformat")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/objects.lua"
-- 1 entries
t("..", "..", "entity name")


------------------------------------------------
section "game/dlcs/tome-orcs/data/zones/gem/zone.lua"
-- 1 entries
t("G.E.M.", "G.E.M.", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/init.lua"
-- 2 entries
t("Embers of Rage", "Embers of Rage", "init.lua long_name")
t([[Play as an orc of the Kruk Pride, located on an island near Var'Eyal.
Learn to master steam technology, battle the terrible Atmos Tribe and ensure dominion of Var'Eyal for your race.]], [[Play as an orc of the Kruk Pride, located on an island near Var'Eyal.
Learn to master steam technology, battle the terrible Atmos Tribe and ensure dominion of Var'Eyal for your race.]], "init.lua description")


------------------------------------------------
section "game/dlcs/tome-orcs/overload/data/calendar_orc.lua"
-- 8 entries
t("Remembrance", "Remembrance", "calendar orc")
t("Retaking", "Retaking", "calendar orc")
t("Revenge", "Revenge", "calendar orc")
t("Pain", "Pain", "calendar orc")
t("Dearth", "Dearth", "calendar orc")
t("Loss", "Loss", "calendar orc")
t("Destruction", "Destruction", "calendar orc")
t("Renewal", "Renewal", "calendar orc")


------------------------------------------------
section "game/dlcs/tome-orcs/overload/mod/class/OrcCampaign.lua"
-- 1 entries
t("%+d #LAST#(%+d eff.)", "%+d #LAST#(%+d eff.)", "_t")


------------------------------------------------
section "game/dlcs/tome-orcs/overload/mod/dialogs/CreateTinker.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/Birther.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/HotkeysIconsDisplay.lua"
-- 1 entries
t("Unknown!", "Unknown!", "_t")


------------------------------------------------
section "game/engines/default/engine/Module.lua"
-- 3 entries
t("#{italic}##PINK#Addons developers can still test their addons by enabling developer mode.#{normal}#", "#{italic}##PINK#Addons developers can still test their addons by enabling developer mode.#{normal}#", "_t")
t("Beta Addons Disabled", "Beta Addons Disabled", "_t")
t([[This beta version is meant to be tested without addons, as such the following ones are currently disabled:
#GREY#]], [[This beta version is meant to be tested without addons, as such the following ones are currently disabled:
#GREY#]], "_t")


------------------------------------------------
section "game/engines/default/engine/Trap.lua"
-- 1 entries
t("%s", "%s", "logSeen")


------------------------------------------------
section "game/engines/default/engine/ai/talented.lua"
-- 3 entries
t("#ORCHID#__[%d]%s improved talented AI picked talent[att:%d, turn %s]: %s", "#ORCHID#__[%d]%s improved talented AI picked talent[att:%d, turn %s]: %s", "log")
t("__[%d]%s#ORANGE# ACTION FAILED:  %s, %s", "__[%d]%s#ORANGE# ACTION FAILED:  %s, %s", "log")
t("#SLATE#__%s[%d] improved talented AI No talents available [att:%d, turn %s]", "#SLATE#__%s[%d] improved talented AI No talents available [att:%d, turn %s]", "log")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"
-- 2 entries
t("", "", "_t")
t("Must be between %i and %i characters.", "Must be between %i and %i characters.", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowAchievements.lua"
-- 2 entries
t("", "", "_t")
t("???", "???", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipInven.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipment.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowErrorStack.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowInventory.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowPickupFloor.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowStore.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/SteamOptions.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/Talkbox.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/ShowPurchasable.lua"
-- 1 entries
t("%0.2f %s", "%0.2f %s", "tformat")


------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"
-- 2 entries
t("%s", "%s", "logSeen")
t("%s %s %s.", "%s %s %s.", "logSeen")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerRest.lua"
-- 1 entries
t("%s...", "%s...", "tformat")


------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/engines/default/engine/utils.lua"
-- 3 entries
t("its", "its", "_t")
t("it", "it", "_t")
t("itself", "itself", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Addons.lua"
-- 1 entries
t(" and #LIGHT_BLUE##{underline}#Te4.org DLCs#{normal}#", " and #LIGHT_BLUE##{underline}#Te4.org DLCs#{normal}#", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/MainMenu.lua"
-- 5 entries
t("#{bold}##B9E100#T-Engine4 version: %d.%d.%d", "#{bold}##B9E100#T-Engine4 version: %d.%d.%d", "tformat")
t([[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]], [[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]], "_t")
t([[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]], [[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]], "_t")
t([[#{bold}##GOLD#Forgotten Cults - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Not all adventurers seek fortune, not all that defend the world have good deeds in mind. Lately the number of sightings of horrors have grown tremendously. People wander off the beaten paths only to be found years later, horribly mutated and partly insane, if they are found at all. It is becoming evident something is stirring deep below Maj'Eyal. That something is you.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Writhing Ones. Give in to the corrupting forces and turn yourself gradually into an horror, summon horrors to do your bidding, shed your skin and melt your face to assault your foes. With your arm already turned into a tentacle, what creature can stop you?
#LIGHT_UMBER#New class:#WHITE# Cultists of Entropy. Using its insanity and control of entropic forces to unravel the normal laws of physic this caster class can turn healing into attacks and call upon the forces of the void to reduce its foes to dust.
#LIGHT_UMBER#New race:#WHITE# Drems. A corrupt subrace of dwarves, that somehow managed to keep a shred of sanity to not fully devolve into mindless horrors. They can enter a frenzy and even learn to summon horrors.
#LIGHT_UMBER#New race:#WHITE# Krogs. Ogres transformed by the very thing that should kill them. Their powerful attacks can stun their foes and they are so strong they can dual wield any one handed weapons.
#LIGHT_UMBER#Many new zones:#WHITE# Explore the Scourge Pits, fight your way out of a giant worm (don't ask how you get *in*), discover the wonders of the Occult Egress and many more strange and tentacle-filled zones!
#LIGHT_UMBER#New horrors:#WHITE# You liked radiant horrors? You'll love searing horrors! And Nethergames. And Entropic Shards. And ... more
#LIGHT_UMBER#Sick of your own head:#WHITE#  Replace it with a nice cozy horror!
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, events... 

]], [[#{bold}##GOLD#Forgotten Cults - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Not all adventurers seek fortune, not all that defend the world have good deeds in mind. Lately the number of sightings of horrors have grown tremendously. People wander off the beaten paths only to be found years later, horribly mutated and partly insane, if they are found at all. It is becoming evident something is stirring deep below Maj'Eyal. That something is you.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Writhing Ones. Give in to the corrupting forces and turn yourself gradually into an horror, summon horrors to do your bidding, shed your skin and melt your face to assault your foes. With your arm already turned into a tentacle, what creature can stop you?
#LIGHT_UMBER#New class:#WHITE# Cultists of Entropy. Using its insanity and control of entropic forces to unravel the normal laws of physic this caster class can turn healing into attacks and call upon the forces of the void to reduce its foes to dust.
#LIGHT_UMBER#New race:#WHITE# Drems. A corrupt subrace of dwarves, that somehow managed to keep a shred of sanity to not fully devolve into mindless horrors. They can enter a frenzy and even learn to summon horrors.
#LIGHT_UMBER#New race:#WHITE# Krogs. Ogres transformed by the very thing that should kill them. Their powerful attacks can stun their foes and they are so strong they can dual wield any one handed weapons.
#LIGHT_UMBER#Many new zones:#WHITE# Explore the Scourge Pits, fight your way out of a giant worm (don't ask how you get *in*), discover the wonders of the Occult Egress and many more strange and tentacle-filled zones!
#LIGHT_UMBER#New horrors:#WHITE# You liked radiant horrors? You'll love searing horrors! And Nethergames. And Entropic Shards. And ... more
#LIGHT_UMBER#Sick of your own head:#WHITE#  Replace it with a nice cozy horror!
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, events... 

]], "_t")
t("#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "tformat")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileLogin.lua"
-- 11 entries
t("Online profile ", "Online profile ", "_t")
t("Password again: ", "Password again: ", "_t")
t("Email: ", "Email: ", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "You at least 16 years old, or have parental authorization to play the game.", "_t")
t("Privacy Policy (opens in browser)", "Privacy Policy (opens in browser)", "_t")
t("Password mismatch!", "Password mismatch!", "_t")
t("Email", "Email", "_t")
t("Your email seems invalid", "Your email seems invalid", "_t")
t("Age Check", "Age Check", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "You need to be 16 years old or more or to have parental authorization to play this game.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileSteamRegister.lua"
-- 11 entries
t("Steam User Account", "Steam User Account", "_t")
t([[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]], [[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]], "_t")
t("Email: ", "Email: ", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "You at least 16 years old, or have parental authorization to play the game.", "_t")
t("Privacy Policy (opens in browser)", "Privacy Policy (opens in browser)", "_t")
t("Email", "Email", "_t")
t("Your email does not look right.", "Your email does not look right.", "_t")
t("Age Check", "Age Check", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "You need to be 16 years old or more or to have parental authorization to play this game.", "_t")
t("Username or Email already taken, please select an other one.", "Username or Email already taken, please select an other one.", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/UpdateAll.lua"
-- 11 entries
t("Update all game modules", "Update all game modules", "_t")
t([[All those components will be updated:
]], [[All those components will be updated:
]], "_t")
t("Component", "Component", "_t")
t("All your game modules are up to date.", "All your game modules are up to date.", "_t")
t("Nothing to update", "Nothing to update", "_t")
t("Game: #{bold}##GOLD#", "Game: #{bold}##GOLD#", "_t")
t("Engine: #{italic}##LIGHT_BLUE#", "Engine: #{italic}##LIGHT_BLUE#", "_t")
t("Downloading: ", "Downloading: ", "_t")
t([[There was an error while downloading:
]], [[There was an error while downloading:
]], "_t")
t("All updates installed, the game will now restart", "All updates installed, the game will now restart", "_t")
t("Update", "Update", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ViewHighScores.lua"
-- 4 entries
t("View High Scores", "View High Scores", "_t")
t("World", "World", "_t")
t([[#{bold}##GOLD#%s#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s#GREEN# High Scores#WHITE##{normal}#

]], "tformat")
t([[#{bold}##GOLD#%s(%s)#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s(%s)#GREEN# High Scores#WHITE##{normal}#

]], "tformat")


------------------------------------------------
section "game/engines/default/modules/boot/init.lua"
-- 2 entries
t("Tales of Maj'Eyal Main Menu", "Tales of Maj'Eyal Main Menu", "init.lua long_name")
t([[Bootmenu!
]], [[Bootmenu!
]], "init.lua description")


------------------------------------------------
section "game/modules/tome/ai/escort.lua"
-- 1 entries
t(" %s to the %s!", " %s to the %s!", "tformat")


------------------------------------------------
section "game/modules/tome/ai/improved_tactical.lua"
-- 10 entries
t("#ORCHID#%s wants escape(move) %0.2f (air: %s = %0.2f) on %s (%d, %d, air:%s = %s turns)", "#ORCHID#%s wants escape(move) %0.2f (air: %s = %0.2f) on %s (%d, %d, air:%s = %s turns)", "log")
t("#ORCHID#%s wants escape(move) %0.2f (heal) in %s at(%d, %d) dam %d vs %d avail life)", "#ORCHID#%s wants escape(move) %0.2f (heal) in %s at(%d, %d) dam %d vs %d avail life)", "log")
t("#GREY#__%s[%d] tactical AI: NO USEFUL ACTIONS", "#GREY#__%s[%d] tactical AI: NO USEFUL ACTIONS", "log")
t("#GREY#%3d: %-40s score=%-+4.2f[Lx%-5.2f Sx%5.2f Mx%0.2f] (%s)", "#GREY#%3d: %-40s score=%-+4.2f[Lx%-5.2f Sx%5.2f Mx%0.2f] (%s)", "log")
t("%s__%s[%d] tactical AI picked action[att:%d, turn %s]: (%s)%s {%-+4.2f [%s]}", "%s__%s[%d] tactical AI picked action[att:%d, turn %s]: (%s)%s {%-+4.2f [%s]}", "log")
t("#GREY#__[%d]%s ACTION SUCCEEDED:  %s, tacs: %s, FT:%s", "#GREY#__[%d]%s ACTION SUCCEEDED:  %s, tacs: %s, FT:%s", "log")
t("__[%d]%s #ORANGE# ACTION FAILED:  %s, FT:%s", "__[%d]%s #ORANGE# ACTION FAILED:  %s, FT:%s", "log")
t("__[%d]%s #SLATE# tactical AI: NO ACTION, best: %s, %s", "__[%d]%s #SLATE# tactical AI: NO ACTION, best: %s, %s", "log")
t("%s__turn %d: Invoking improved tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", "%s__turn %d: Invoking improved tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", "log")
t("#ROYAL_BLUE#---talents disabled---", "#ROYAL_BLUE#---talents disabled---", "log")


------------------------------------------------
section "game/modules/tome/ai/improved_talented.lua"
-- 1 entries
t("%s__turn %d: Invoking improved_talented_simple AI for [%s]%s(%d,%d) target:[%s]%s %s", "%s__turn %d: Invoking improved_talented_simple AI for [%s]%s(%d,%d) target:[%s]%s %s", "log")


------------------------------------------------
section "game/modules/tome/ai/maintenance.lua"
-- 2 entries
t("#ORCHID#__%s[%d]maintenance AI picked action: %s (%s)", "#ORCHID#__%s[%d]maintenance AI picked action: %s (%s)", "log")
t("__%s[%d] #ORANGE# maintenance ACTION FAILED:  %s", "__%s[%d] #ORANGE# maintenance ACTION FAILED:  %s", "log")


------------------------------------------------
section "game/modules/tome/ai/quests.lua"
-- 2 entries
t("Protect Limmir from the demons coming from north-east. Hold them off!", "Protect Limmir from the demons coming from north-east. Hold them off!", "_t")
t("This place is corrupted! I will cleanse it! Protect me while I do it!", "This place is corrupted! I will cleanse it! Protect me while I do it!", "_t")


------------------------------------------------
section "game/modules/tome/ai/sandworm_tunneler.lua"
-- 1 entries
t("#OLIVE_DRAB#The %s burrows into the ground and disappears.", "#OLIVE_DRAB#The %s burrows into the ground and disappears.", "logSeen")


------------------------------------------------
section "game/modules/tome/ai/shadow.lua"
-- 1 entries
t("#PINK#%s returns to the shadows.", "#PINK#%s returns to the shadows.", "logPlayer")


------------------------------------------------
section "game/modules/tome/ai/special_movements.lua"
-- 4 entries
t("__%s #GREY# (%d, %d) trying to move to a safe grid", "__%s #GREY# (%d, %d) trying to move to a safe grid", "log")
t("#GREY#___Trying existing path to (%s, %s)", "#GREY#___Trying existing path to (%s, %s)", "log")
t("#GREY#___Using new path to (%s, %s)", "#GREY#___Using new path to (%s, %s)", "log")
t("__%s #GREY# (%d, %d) trying to flee_dmap_keep_los to (%d, %d)", "__%s #GREY# (%d, %d) trying to flee_dmap_keep_los to (%d, %d)", "log")


------------------------------------------------
section "game/modules/tome/ai/tactical.lua"
-- 1 entries
t("%s__turn %d: Invoking old tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", "%s__turn %d: Invoking old tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", "log")


------------------------------------------------
section "game/modules/tome/ai/target.lua"
-- 1 entries
t("#RED# [%s]%s #ORANGE#CLEARING OLD TARGET#LAST#: [%s]%s", "#RED# [%s]%s #ORANGE#CLEARING OLD TARGET#LAST#: [%s]%s", "log")


------------------------------------------------
section "game/modules/tome/class/Actor.lua"
-- 6 entries
t("actor", "actor", "_t")
t(" (%d%%)", " (%d%%)", "tformat")
t("%s%d %s#LAST#", "%s%d %s#LAST#", "tformat")
t("You %s %s to activate %s.", "You %s %s to activate %s.", "logPlayer")
t("%s's %s has been disrupted by #ORCHID#anti-psionic forces#LAST#!", "%s's %s has been disrupted by #ORCHID#anti-psionic forces#LAST#!", "logSeen")
t("%s %s: ", "%s %s: ", "tformat")


------------------------------------------------
section "game/modules/tome/class/EscortRewards.lua"
-- 2 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")
t([[#GOLD#%s / %s#LAST#
%s]], [[#GOLD#%s / %s#LAST#
%s]], "tformat")


------------------------------------------------
section "game/modules/tome/class/Game.lua"
-- 4 entries
t("%s the %s %s", "%s the %s %s", "tformat")
t("#TEAL#%s", "#TEAL#%s", "log")
t("the great unknown", "the great unknown", "_t")
t("%s", "%s", "log")


------------------------------------------------
section "game/modules/tome/class/GameState.lua"
-- 73 entries
t("#AQUAMARINE#Most stores should have new stock now.", "#AQUAMARINE#Most stores should have new stock now.", "log")
t("faceted", "faceted", "_t")
t("faded", "faded", "_t")
t("flawless", "flawless", "_t")
t("gleaming", "gleaming", "_t")
t("glistening", "glistening", "_t")
t("glowing", "glowing", "_t")
t("humming", "humming", "_t")
t("immaculate", "immaculate", "_t")
t("jewel-encrusted", "jewel-encrusted", "_t")
t("laminated", "laminated", "_t")
t("plated", "plated", "_t")
t("rune-covered", "rune-covered", "_t")
t("scintillating", "scintillating", "_t")
t("shadowy", "shadowy", "_t")
t("sigiled", "sigiled", "_t")
t("silvered", "silvered", "_t")
t("twisted", "twisted", "_t")
t("unblemished", "unblemished", "_t")
t("%s '%s'", "%s '%s'", "tformat")
t("You have been ambushed!", "You have been ambushed!", "_t")
t("Infinite Dungeon Challenge (Level %s): %s", "Infinite Dungeon Challenge (Level %s): %s", "tformat")
t("Leave the level (to the next level) without killing a single creature. You will get #{italic}#two#{normal}# rewards.", "Leave the level (to the next level) without killing a single creature. You will get #{italic}#two#{normal}# rewards.", "_t")
t("Pacifist", "Pacifist", "_t")
t("Exterminate every foe on the level.", "Exterminate every foe on the level.", "_t")
t("Foes left: #LIGHT_RED#%s", "Foes left: #LIGHT_RED#%s", "tformat")
t([[#LIGHT_RED#EXTERMINATE THIS FOE#LAST#
%s]], [[#LIGHT_RED#EXTERMINATE THIS FOE#LAST#
%s]], "tformat")
t("Proceed directly to the next Infinite Dungeon level in less than %d turns (an exit is revealed on your map).", "Proceed directly to the next Infinite Dungeon level in less than %d turns (an exit is revealed on your map).", "tformat")
t("Rush Hour (%d)", "Rush Hour (%d)", "tformat")
t("\
#ORCHID# Rush Hour: %s turns left!\
", "\
#ORCHID# Rush Hour: %s turns left!\
", "log")
t("Proceed to the next Infinite Dungeon level! An exit has been marked on your map.", "Proceed to the next Infinite Dungeon level! An exit has been marked on your map.", "_t")
t("Dream Hunter", "Dream Hunter", "_t")
t("Wake up and kill the dreaming horror boss '%s'.", "Wake up and kill the dreaming horror boss '%s'.", "tformat")
t("Find, challenge, and kill your mirror clone on the level.", "Find, challenge, and kill your mirror clone on the level.", "_t")
t("Mirror Match", "Mirror Match", "_t")
t("An evil twin of %s%s", "An evil twin of %s%s", "tformat")
t("Mirror Challenge of %s", "Mirror Challenge of %s", "tformat")
t("#ORCHID#%s does not recognize you.", "#ORCHID#%s does not recognize you.", "logPlayer")
t("Challenge your mirror clone and triumph!", "Challenge your mirror clone and triumph!", "_t")
t("Challenge: #PURPLE#Mirror Match", "Challenge: #PURPLE#Mirror Match", "_t")
t("#CRIMSON#The Fight Is Joined!", "#CRIMSON#The Fight Is Joined!", "say")
t("Challenge: #PURPLE#Near Sighted", "Challenge: #PURPLE#Near Sighted", "_t")
t("Proceed to the next Infinite Dungeon level with -7 sight range for a reward.", "Proceed to the next Infinite Dungeon level with -7 sight range for a reward.", "_t")
t("Near Sighted", "Near Sighted", "_t")
t("Proceed to the next Infinite Dungeon level with -7 sight range.", "Proceed to the next Infinite Dungeon level with -7 sight range.", "_t")
t("All foes (including bosses) gain the ability to multiply up to 3 times.  You must survive for at least %d turns before exiting.", "All foes (including bosses) gain the ability to multiply up to 3 times.  You must survive for at least %d turns before exiting.", "tformat")
t("Challenge: #PURPLE#Multiplicity", "Challenge: #PURPLE#Multiplicity", "_t")
t("All foes have the multiply talent!", "All foes have the multiply talent!", "_t")
t("Multiplicity", "Multiplicity", "_t")
t("Turns left: #LIGHT_GREEN#%d", "Turns left: #LIGHT_GREEN#%d", "tformat")
t("#LIGHT_GREEN#Multiplicity: You have survived so far. Exit for your reward!", "#LIGHT_GREEN#Multiplicity: You have survived so far. Exit for your reward!", "say")
t("Survive the multiplicative madness!", "Survive the multiplicative madness!", "_t")
t("#rng# the Spawn of Urh'Rok", "#rng# the Spawn of Urh'Rok", "_t")
t("Challenge: #PURPLE#Headhunter", "Challenge: #PURPLE#Headhunter", "_t")
t("Kill %d spawns of Urh'Rok on the level before killing any other elite (or higher rank) creatures, for an uncommon reward.", "Kill %d spawns of Urh'Rok on the level before killing any other elite (or higher rank) creatures, for an uncommon reward.", "tformat")
t("Headhunter", "Headhunter", "_t")
t("Kill %d spawns of Urh'Rok on the level before killing any elite creatures.", "Kill %d spawns of Urh'Rok on the level before killing any elite creatures.", "tformat")
t("%d / %d demon spawn killed.", "%d / %d demon spawn killed.", "tformat")
t("#ORCHID#You claim the head of %s, giving pause to all foes on the level.", "#ORCHID#You claim the head of %s, giving pause to all foes on the level.", "say")
t("Refuse", "Refuse", "_t")
t("Random Artifact", "Random Artifact", "_t")
t("Random Artifact: %s", "Random Artifact: %s", "tformat")
t("+3 Stat Points", "+3 Stat Points", "_t")
t("+1 Class Point", "+1 Class Point", "_t")
t("+1 Generic Point", "+1 Generic Point", "_t")
t("+1 Category Point", "+1 Category Point", "_t")
t("+1 Prodigy Point", "+1 Prodigy Point", "_t")
t("#OLIVE_DRAB#%s: %s", "#OLIVE_DRAB#%s: %s", "tformat")
t("Reward", "Reward", "_t")
t("Rewards", "Rewards", "_t")
t("#LIGHT_BLUE#%s has received: %s.", "#LIGHT_BLUE#%s has received: %s.", "log")
t("#LIGHT_GREEN#%s", "#LIGHT_GREEN#%s", "logPlayer")
t("You have unlocked a new talent: %s!", "You have unlocked a new talent: %s!", "tformat")


------------------------------------------------
section "game/modules/tome/class/Grid.lua"
-- 2 entries
t("%s", "%s", "logSeen")
t(" (range: ", " (range: ", "_t")


------------------------------------------------
section "game/modules/tome/class/NPC.lua"
-- 3 entries
t(" looking %s", " looking %s", "tformat")
t(" looking at you.", " looking at you.", "_t")
t("UID: ", "UID: ", "_t")


------------------------------------------------
section "game/modules/tome/class/Object.lua"
-- 12 entries
t("Can not use an item in the transmogrification chest.", "Can not use an item in the transmogrification chest.", "_t")
t("%0.2f %s", "%0.2f %s", "tformat")
t("%d%% %s", "%d%% %s", "tformat")
t(", ", ", ", "_t")
t("No left", "No left", "log")
t("No right", "No right", "log")
t(" %s", " %s", "tformat")
t(" / ", " / ", "_t")
t("%s)", "%s)", "tformat")
t(" %s)", " %s)", "tformat")
t(" %s (%+d(-) %s)", " %s (%+d(-) %s)", "tformat")
t("%+d #LAST#(%+d eff.)", "%+d #LAST#(%+d eff.)", "_t")


------------------------------------------------
section "game/modules/tome/class/Party.lua"
-- 19 entries
t("Party member", "Party member", "_t")
t("Can not switch control to this creature.", "Can not switch control to this creature.", "logPlayer")
t("Switching control", "Switching control", "_t")
t("#MOCCASIN#Character control switched to %s.", "#MOCCASIN#Character control switched to %s.", "logPlayer")
t("Can not give orders to this creature.", "Can not give orders to this creature.", "logPlayer")
t("Set action radius: %s", "Set action radius: %s", "tformat")
t("Set the maximum distance this creature can go from the party master", "Set the maximum distance this creature can go from the party master", "_t")
t("%s maximum action radius set to %d.", "%s maximum action radius set to %d.", "logPlayer")
t("that location", "that location", "_t")
t("%s will stay near %s.", "%s will stay near %s.", "logPlayer")
t("%s targets #Target#.", "%s targets #Target#.", "logCombat")
t("Change name of: %s", "Change name of: %s", "tformat")
t("%s is dismissed!", "%s is dismissed!", "log")
t("No, we must hurry!", "No, we must hurry!", "_t")
t("Ok, but not for long.", "Ok, but not for long.", "_t")
t("very close", "very close", "_t")
t("close", "close", "_t")
t("still far away", "still far away", "_t")
t("The portal is %s, to the %s.", "The portal is %s, to the %s.", "tformat")


------------------------------------------------
section "game/modules/tome/class/PartyMember.lua"
-- 2 entries
t("Behavior: %s", "Behavior: %s", "tformat")
t("Action radius: %d", "Action radius: %d", "tformat")


------------------------------------------------
section "game/modules/tome/class/Player.lua"
-- 1 entries
t("", "", "log")


------------------------------------------------
section "game/modules/tome/class/Projectile.lua"
-- 9 entries
t("Projectile: ", "Projectile: ", "_t")
t("Origin: ", "Origin: ", "_t")
t("Speed: %d%% %s", "Speed: %d%% %s", "tformat")
t("Affect origin chance: ", "Affect origin chance: ", "_t")
t("Affect origin's friends chance: ", "Affect origin's friends chance: ", "_t")
t("UID: ", "UID: ", "_t")
t(" homing: %s(%s, %s)", " homing: %s(%s, %s)", "tformat")
t(" range: ", " range: ", "_t")
t("projectile", "projectile", "_t")


------------------------------------------------
section "game/modules/tome/class/Store.lua"
-- 11 entries
t("Not enough gold", "Not enough gold", "_t")
t("You do not have the %0.2f gold needed!", "You do not have the %0.2f gold needed!", "tformat")
t("Buy %d %s for %0.2f gold%s?", "Buy %d %s for %0.2f gold%s?", "tformat")
t("Bought: %s %s for %0.2f gold.", "Bought: %s %s for %0.2f gold.", "log")
t(" (%0.2f each)", " (%0.2f each)", "tformat")
t("Sell %d %s for %0.2f gold%s?", "Sell %d %s for %0.2f gold%s?", "tformat")
t("Sold: %s %s for %0.2f gold.", "Sold: %s %s for %0.2f gold.", "log")
t("Buy for: %0.2f gold (You have %0.2f gold)", "Buy for: %0.2f gold (You have %0.2f gold)", "tformat")
t("Sell for: %0.2f gold (You have %0.2f gold)", "Sell for: %0.2f gold (You have %0.2f gold)", "tformat")
t("This entity can not access inventories.", "This entity can not access inventories.", "logPlayer")
t("You must be level %d to access this shop.", "You must be level %d to access this shop.", "logPlayer")


------------------------------------------------
section "game/modules/tome/class/Trap.lua"
-- 33 entries
t("#LIGHT_GREEN#%d turns #WHITE#", "#LIGHT_GREEN#%d turns #WHITE#", "tformat")
t("<Store>", "<Store>", "_t")
t("(beneficial)", "(beneficial)", "_t")
t("(beneficial to enemies)", "(beneficial to enemies)", "_t")
t("(safe)", "(safe)", "_t")
t("pressure_trigger", "pressure_trigger", "_t")
t("#YELLOW#Detect: %d#WHITE#", "#YELLOW#Detect: %d#WHITE#", "tformat")
t("#YELLOW# Disarm: %d#WHITE#", "#YELLOW# Disarm: %d#WHITE#", "tformat")
t("Dismantling", "Dismantling", "_t")
t("dismantled", "dismantled", "_t")
t("Your level of skill was not enough to understand the workings of this trap.", "Your level of skill was not enough to understand the workings of this trap.", "_t")
t("You quit dismantling the trap.", "You quit dismantling the trap.", "_t")
t("#LIGHT_BLUE#%s: %s#LAST#", "#LIGHT_BLUE#%s: %s#LAST#", "logPlayer")
t("Failure", "Failure", "_t")
t("Success", "Success", "_t")
t("\
#LIGHT_BLUE#Trap Description:#WHITE#\
", "\
#LIGHT_BLUE#Trap Description:#WHITE#\
", "_t")
t("Disarming a trap: %s", "Disarming a trap: %s", "tformat")
t([[As you begin disarming the trap, you think you may be able to learn how it works by carefully dismantling it.  You estimate this will take up to #YELLOW#%d#LAST# uninterrupted turns.
	What do you want to do?
%s
]], [[As you begin disarming the trap, you think you may be able to learn how it works by carefully dismantling it.  You estimate this will take up to #YELLOW#%d#LAST# uninterrupted turns.
	What do you want to do?
%s
]], "tformat")
t("not resting", "not resting", "_t")
t("You set off the trap!", "You set off the trap!", "_t")
t("You successfully dismantled the trap.", "You successfully dismantled the trap.", "_t")
t("You were interrupted.", "You were interrupted.", "_t")
t("Disarm Normally", "Disarm Normally", "_t")
t("Dismantle Carefully", "Dismantle Carefully", "_t")
t("ignore", "ignore", "_t")
t("simply ignore", "simply ignore", "_t")
t("carefully avoid", "carefully avoid", "_t")
t("somehow avoid", "somehow avoid", "_t")
t("dodge", "dodge", "_t")
t("#CADET_BLUE#You %s a trap (%s).", "#CADET_BLUE#You %s a trap (%s).", "log")
t("#CADET_BLUE#%s %ss %s.", "#CADET_BLUE#%s %ss %s.", "logSeen")
t("a trap (%s)", "a trap (%s)", "tformat")
t("something on the floor", "something on the floor", "_t")


------------------------------------------------
section "game/modules/tome/class/UserChatExtension.lua"
-- 5 entries
t("#ANTIQUE_WHITE#has linked an item: #WHITE# %s", "#ANTIQUE_WHITE#has linked an item: #WHITE# %s", "tformat")
t("#ANTIQUE_WHITE#has linked a creature: #WHITE# %s", "#ANTIQUE_WHITE#has linked a creature: #WHITE# %s", "tformat")
t("#ANTIQUE_WHITE#has linked a talent: #WHITE# %s", "#ANTIQUE_WHITE#has linked a talent: #WHITE# %s", "tformat")
t("#CRIMSON#%s#WHITE#", "#CRIMSON#%s#WHITE#", "tformat")
t("SHAKING", "SHAKING", "log")


------------------------------------------------
section "game/modules/tome/class/World.lua"
-- 2 entries
t("%s the %s %s level %s", "%s the %s %s level %s", "tformat")
t("#LIGHT_BLUE#New shimmer option unlocked: #{italic}#%s#{normal}#", "#LIGHT_BLUE#New shimmer option unlocked: #{italic}#%s#{normal}#", "log")


------------------------------------------------
section "game/modules/tome/class/WorldNPC.lua"
-- 3 entries
t("#Target# kills #Source#.", "#Target# kills #Source#.", "logCombat")
t("#Source# kills #Target#.", "#Source# kills #Target#.", "logCombat")
t("Killed by you: ", "Killed by you: ", "tformat")


------------------------------------------------
section "game/modules/tome/class/generator/actor/Arena.lua"
-- 26 entries
t("Skeletal rats", "Skeletal rats", "_t")
t("Gladiators", "Gladiators", "_t")
t("Golden crystals", "Golden crystals", "_t")
t("Master slingers", "Master slingers", "_t")
t("Master Alchemist", "Master Alchemist", "_t")
t("Multi-hued Wyrmic", "Multi-hued Wyrmic", "_t")
t("Headless horror", "Headless horror", "_t")
t("Boss fight!", "Boss fight!", "_t")
t("Victory!!", "Victory!!", "_t")
t(" appear!!", " appear!!", "_t")
t(" appears!!", " appears!!", "_t")
t("#LIGHT_RED#%s%s", "#LIGHT_RED#%s%s", "log")
t("#LIGHT_RED#WARNING! %s appears!!!", "#LIGHT_RED#WARNING! %s appears!!!", "log")
t("Rej the Master of Arena", "Rej the Master of Arena", "_t")
t("#LIGHT_RED#WARNING! Rej Arkatis, the master of the arena, appears!!!", "#LIGHT_RED#WARNING! Rej Arkatis, the master of the arena, appears!!!", "log")
t("The final fight!", "The final fight!", "_t")
t("Congratulations!", "Congratulations!", "_t")
t("%s the Master of Arena", "%s the Master of Arena", "tformat")
t("#LIGHT_RED#WARNING! %s, the master of the arena, appears!!!", "#LIGHT_RED#WARNING! %s, the master of the arena, appears!!!", "log")
t("OVERKILL", "OVERKILL", "_t")
t("#LIGHT_GREEN#Your powerful attack completely obliterates #WHITE#%s#LIGHT_GREEN#!", "#LIGHT_GREEN#Your powerful attack completely obliterates #WHITE#%s#LIGHT_GREEN#!", "log")
t("#LIGHT_GREEN#You destroy #WHITE#%s#LIGHT_GREEN# in a single blow!", "#LIGHT_GREEN#You destroy #WHITE#%s#LIGHT_GREEN# in a single blow!", "log")
t("#LIGHT_GREEN#Your score multiplier increases by #WHITE#%d#LIGHT_GREEN#!", "#LIGHT_GREEN#Your score multiplier increases by #WHITE#%d#LIGHT_GREEN#!", "log")
t("#LIGHT_GREEN#Your score multiplier increases by #WHITE#0.1#LIGHT_GREEN#!", "#LIGHT_GREEN#Your score multiplier increases by #WHITE#0.1#LIGHT_GREEN#!", "log")
t("#YELLOW#You defeat an experienced enemy!", "#YELLOW#You defeat an experienced enemy!", "log")
t("#LIGHT_GREEN#The audience cheers!", "#LIGHT_GREEN#The audience cheers!", "log")


------------------------------------------------
section "game/modules/tome/class/generator/actor/HighPeakFinal.lua"
-- 1 entries
t("An entity appears through the portal!", "An entity appears through the portal!", "logSeen")


------------------------------------------------
section "game/modules/tome/class/generator/actor/ValleyMoon.lua"
-- 1 entries
t("Limmir summons a blast of holy light!", "Limmir summons a blast of holy light!", "logSeen")


------------------------------------------------
section "game/modules/tome/class/interface/ActorAI.lua"
-- 7 entries
t("#Source# shoves #Target# aside.", "#Source# shoves #Target# aside.", "logCombat")
t("%s #PINK#searching for safer grids [radius %s from (%s, %s), val = %s], dam_wt=%s, air_wt=%s, dist_weight=%s, want_closer=%s", "%s #PINK#searching for safer grids [radius %s from (%s, %s), val = %s], dam_wt=%s, air_wt=%s, dist_weight=%s, want_closer=%s", "log")
t("#PINK# --best reachable grid: (%d, %d) (dist: %s, val: %s(%s))", "#PINK# --best reachable grid: (%d, %d) (dist: %s, val: %s(%s))", "log")
t("_[%d]%s %s%s tactical weight CACHE MISMATCH (%s) vs %s[%d]{%s}: %s vs %s(cache)", "_[%d]%s %s%s tactical weight CACHE MISMATCH (%s) vs %s[%d]{%s}: %s vs %s(cache)", "log")
t("_[%d]%s #YELLOW# TACTICAL turn_procs CACHE MISMATCH for %s", "_[%d]%s #YELLOW# TACTICAL turn_procs CACHE MISMATCH for %s", "log")
t("#YELLOW_GREEN#____Cached tactics: %s", "#YELLOW_GREEN#____Cached tactics: %s", "log")
t("#YELLOW_GREEN#__Computed tactics: %s", "#YELLOW_GREEN#__Computed tactics: %s", "log")


------------------------------------------------
section "game/modules/tome/class/interface/ActorInscriptions.lua"
-- 5 entries
t("You are unable to use this kind of inscription.", "You are unable to use this kind of inscription.", "logPlayer")
t("You already have too many of this inscription.", "You already have too many of this inscription.", "logPlayer")
t("You have no more inscription slots.", "You have no more inscription slots.", "logPlayer")
t("You are now inscribed with %s.", "You are now inscribed with %s.", "logPlayer")
t("Your %s is depleted!", "Your %s is depleted!", "logPlayer")


------------------------------------------------
section "game/modules/tome/class/interface/ActorObjectUse.lua"
-- 8 entries
t("Activate an object", "Activate an object", "_t")
t("Activate: %s", "Activate: %s", "tformat")
t("%s", "%s", "logSeen")
t("Activate an object.", "Activate an object.", "_t")
t("(unknown object)", "(unknown object)", "_t")
t([[Use %s:

%s]], [[Use %s:

%s]], "tformat")
t("Activate %s", "Activate %s", "tformat")
t("nothing", "nothing", "_t")


------------------------------------------------
section "game/modules/tome/class/interface/Archery.lua"
-- 9 entries
t("You need a missile launcher (%s)!", "You need a missile launcher (%s)!", "logPlayer")
t("#ORCHID#Your %s CANNOT SHOOT (Resource: %s%s#LAST#).", "#ORCHID#Your %s CANNOT SHOOT (Resource: %s%s#LAST#).", "logPlayer")
t("#ORCHID#Target out of range.  Hold <ctrl> to force all weapons to fire at targets out of ranges (%d - %d).", "#ORCHID#Target out of range.  Hold <ctrl> to force all weapons to fire at targets out of ranges (%d - %d).", "logPlayer")
t("#ORCHID#Target out of range.  Hold <ctrl> to force your weapon to fire at targets beyond its range (%d).", "#ORCHID#Target out of range.  Hold <ctrl> to force your weapon to fire at targets beyond its range (%d).", "logPlayer")
t("#ORCHID#You COULD NOT SHOOT your %s (Resource: %s%s#LAST#).", "#ORCHID#You COULD NOT SHOOT your %s (Resource: %s%s#LAST#).", "logPlayer")
t("%s(%d parried#LAST#)", "%s(%d parried#LAST#)", "tformat")
t("The shattering blow creates a shockwave!", "The shattering blow creates a shockwave!", "logSeen")
t("You are disarmed!", "You are disarmed!", "logPlayer")
t("You must wield a ranged weapon (%s)!", "You must wield a ranged weapon (%s)!", "logPlayer")


------------------------------------------------
section "game/modules/tome/class/interface/Combat.lua"
-- 15 entries
t("%s is too afraid to attack.", "%s is too afraid to attack.", "logSeen")
t("%s is too terrified to attack.", "%s is too terrified to attack.", "logSeen")
t("#Target# notices you at the last moment!", "#Target# notices you at the last moment!", "logCombat")
t("#ORCHID#%s cleverly deflects the attack with %s shield!#LAST#", "#ORCHID#%s cleverly deflects the attack with %s shield!#LAST#", "logSeen")
t("#ORCHID#%s parries the attack with %s dual weapons!#LAST#", "#ORCHID#%s parries the attack with %s dual weapons!#LAST#", "logSeen")
t("#ORCHID#%s instinctively hardens %s skin and ignores the attack!#LAST#", "#ORCHID#%s instinctively hardens %s skin and ignores the attack!#LAST#", "logSeen")
t("#Target# repels an attack from #Source#.", "#Target# repels an attack from #Source#.", "logCombat")
t("#Target# evades #Source#.", "#Target# evades #Source#.", "logCombat")
t("%s(%d parried#LAST#)", "%s(%d parried#LAST#)", "tformat")
t("%s(%d gestured#LAST#)", "%s(%d gestured#LAST#)", "tformat")
t("The shattering blow creates a shockwave!", "The shattering blow creates a shockwave!", "logSeen")
t("#F53CBE#Your rampage is invigorated by your fierce attack! (+1 duration)", "#F53CBE#Your rampage is invigorated by your fierce attack! (+1 duration)", "logPlayer")
t("#Source# counter attacks #Target# with %s shield shards!", "#Source# counter attacks #Target# with %s shield shards!", "logCombat")
t("#Source#'s grapple fails because #Target# is too big!", "#Source#'s grapple fails because #Target# is too big!", "logCombat")
t("%s resists the grapple!", "%s resists the grapple!", "logSeen")


------------------------------------------------
section "game/modules/tome/class/interface/PartyDeath.lua"
-- 12 entries
t("%s(%d %s %s) was %s to death by %s%s on %s %s.", "%s(%d %s %s) was %s to death by %s%s on %s %s.", "_t")
t(" (the fool)", " (the fool)", "_t")
t(" in an act of extreme incompetence", " in an act of extreme incompetence", "_t")
t(" out of supreme humility", " out of supreme humility", "_t")
t(", by accident of course,", ", by accident of course,", "_t")
t(" in some sort of fetish experiment gone wrong", " in some sort of fetish experiment gone wrong", "_t")
t(", providing a free meal to the wildlife", ", providing a free meal to the wildlife", "_t")
t(" (how embarrassing)", " (how embarrassing)", "_t")
t(" (yet again)", " (yet again)", "_t")
t("%s the level %d %s %s %s on level %s of %s.", "%s the level %d %s %s %s on level %s of %s.", "_t")
t("%s(%d %s %s) %s on %s %s.", "%s(%d %s %s) %s on %s %s.", "_t")
t("#{bold}#", "#{bold}#", "_t")


------------------------------------------------
section "game/modules/tome/class/uiset/Classic.lua"
-- 23 entries
t([[Displaying talents (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for creature display]], [[Displaying talents (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for creature display]], "tformat")
t([[Displaying creatures (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for talent display#]], [[Displaying creatures (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for talent display#]], "tformat")
t("#{bold}##GOLD#I#LAST##{normal}#nventory", "#{bold}##GOLD#I#LAST##{normal}#nventory", "_t")
t("Inventory (#{bold}##GOLD#%s#LAST##{normal}#)", "Inventory (#{bold}##GOLD#%s#LAST##{normal}#)", "tformat")
t("#{bold}##GOLD#C#LAST##{normal}#haracter Sheet", "#{bold}##GOLD#C#LAST##{normal}#haracter Sheet", "_t")
t("Character Sheet (#{bold}##GOLD#%s#LAST##{normal}#)", "Character Sheet (#{bold}##GOLD#%s#LAST##{normal}#)", "tformat")
t("Main menu (#{bold}##GOLD#%s#LAST##{normal}#)", "Main menu (#{bold}##GOLD#%s#LAST##{normal}#)", "tformat")
t("Show message/chat log (#{bold}##GOLD#%s#LAST##{normal}#)", "Show message/chat log (#{bold}##GOLD#%s#LAST##{normal}#)", "tformat")
t([[Movement: #LIGHT_GREEN#Default#LAST# (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for passive mode]], [[Movement: #LIGHT_GREEN#Default#LAST# (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for passive mode]], "tformat")
t([[Movement: #LIGHT_RED#Passive#LAST# (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for default mode]], [[Movement: #LIGHT_RED#Passive#LAST# (#{bold}##GOLD#%s#LAST##{normal}#)
Toggle for default mode]], "tformat")
t("Cosmetics & Events shop (#{bold}##GOLD#%s#LAST##{normal}#, #{bold}##GOLD#%s#LAST##{normal}#)", "Cosmetics & Events shop (#{bold}##GOLD#%s#LAST##{normal}#, #{bold}##GOLD#%s#LAST##{normal}#)", "tformat")
t("Left click to use", "Left click to use", "_t")
t("Press 'm' to setup", "Press 'm' to setup", "_t")
t("Right click to configure", "Right click to configure", "_t")
t("Remove this object from your hotkeys?", "Remove this object from your hotkeys?", "_t")
t("Unbind %s", "Unbind %s", "tformat")
t("Developer", "Developer", "_t")
t("Moderator / Helper", "Moderator / Helper", "_t")
t("Donator", "Donator", "_t")
t("Recurring Donator", "Recurring Donator", "_t")
t("Playing: ", "Playing: ", "_t")
t("Linked by: ", "Linked by: ", "_t")
t("Show chat user", "Show chat user", "_t")


------------------------------------------------
section "game/modules/tome/class/uiset/ClassicPlayerDisplay.lua"
-- 44 entries
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], "tformat")
t("%s reduced the duration of this effect by %d turns, from %d to %d.", "%s reduced the duration of this effect by %d turns, from %d to %d.", "tformat")
t([[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], [[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], "tformat")
t("Really cancel %s?", "Really cancel %s?", "tformat")
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Unused stats: %d
Unused class talents: %d
Unused generic talents: %d
Unused categories: %d]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Unused stats: %d
Unused class talents: %d
Unused generic talents: %d
Unused categories: %d]], "tformat")
t("%s#{normal}#", "%s#{normal}#", "tformat")
t("Level / Exp: #00ff00#%s / %2d%%", "Level / Exp: #00ff00#%s / %2d%%", "tformat")
t("Gold: #00ff00#%0.2f", "Gold: #00ff00#%0.2f", "tformat")
t("Accuracy:", "Accuracy:", "_t")
t("Defense:", "Defense:", "_t")
t("M. power:", "M. power:", "_t")
t("M. save:", "M. save:", "_t")
t("P. power:", "P. power:", "_t")
t("P. save:", "P. save:", "_t")
t("S. power:", "S. power:", "_t")
t("S. save:", "S. save:", "_t")
t("Turns remaining: %d", "Turns remaining: %d", "tformat")
t("Air level: %d/%d", "Air level: %d/%d", "tformat")
t("Encumbered! (%d/%d)", "Encumbered! (%d/%d)", "tformat")
t("Str/Dex/Con: #00ff00#%3d/%3d/%3d", "Str/Dex/Con: #00ff00#%3d/%3d/%3d", "tformat")
t("Mag/Wil/Cun: #00ff00#%3d/%3d/%3d", "Mag/Wil/Cun: #00ff00#%3d/%3d/%3d", "tformat")
t("#c00000#Life    :", "#c00000#Life    :", "_t")
t("#WHITE#Shield:", "#WHITE#Shield:", "_t")
t([[#GOLD#%s#LAST#
%s
]], [[#GOLD#%s#LAST#
%s
]], "tformat")
t("no description", "no description", "_t")
t("%-8.8s:", "%-8.8s:", "tformat")
t("#7fffd4#Feedback:", "#7fffd4#Feedback:", "_t")
t("#c00000#Un.body :", "#c00000#Un.body :", "_t")
t("%0.1f (%0.1f/turn)", "%0.1f (%0.1f/turn)", "tformat")
t("#LIGHT_GREEN#Fortress:", "#LIGHT_GREEN#Fortress:", "_t")
t("#ANTIQUE_WHITE#Ammo    :       #ffffff#%d", "#ANTIQUE_WHITE#Ammo    :       #ffffff#%d", "tformat")
t("#ANTIQUE_WHITE#Ammo    :       #ffffff#%d/%d", "#ANTIQUE_WHITE#Ammo    :       #ffffff#%d/%d", "tformat")
t("Saving:", "Saving:", "_t")
t([[#GOLD##{bold}#%s#{normal}##WHITE#
]], [[#GOLD##{bold}#%s#{normal}##WHITE#
]], "tformat")
t("Score(TOP): %d", "Score(TOP): %d", "tformat")
t("Score: %d", "Score: %d", "tformat")
t("Wave(TOP) %d", "Wave(TOP) %d", "tformat")
t("Wave %d", "Wave %d", "tformat")
t(" [MiniBoss]", " [MiniBoss]", "_t")
t(" [Boss]", " [Boss]", "_t")
t(" [Final]", " [Final]", "_t")
t("Bonus: %d (x%.1f)", "Bonus: %d (x%.1f)", "tformat")
t(" VS", " VS", "_t")
t("Rank: %s", "Rank: %s", "tformat")


------------------------------------------------
section "game/modules/tome/class/uiset/Minimalist.lua"
-- 68 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")
t("no description", "no description", "_t")
t("Player Infos", "Player Infos", "_t")
t("Resources", "Resources", "_t")
t("Minimap", "Minimap", "_t")
t("Current Effects", "Current Effects", "_t")
t("Party Members", "Party Members", "_t")
t("Online Chat Log", "Online Chat Log", "_t")
t("Game Actions", "Game Actions", "_t")
t("#CRIMSON#Interface locked, mouse enabled on the map", "#CRIMSON#Interface locked, mouse enabled on the map", "say")
t("#CRIMSON#Interface unlocked, mouse disabled on the map", "#CRIMSON#Interface unlocked, mouse disabled on the map", "say")
t("Reset UI", "Reset UI", "_t")
t("Reset all the interface?", "Reset all the interface?", "_t")
t("Reset interface positions", "Reset interface positions", "_t")
t([[%s
---
Left mouse drag&drop to move the frame
Right mouse drag&drop to scale up/down
Middle click to reset to default scale%s]], [[%s
---
Left mouse drag&drop to move the frame
Right mouse drag&drop to scale up/down
Middle click to reset to default scale%s]], "tformat")
t("Fortress Energy", "Fortress Energy", "_t")
t("Display/Hide resources", "Display/Hide resources", "_t")
t("Toggle:", "Toggle:", "_t")
t("\
Right click to toggle resources bars visibility", "\
Right click to toggle resources bars visibility", "_t")
t("Feedback", "Feedback", "_t")
t("Score[1st]: %d", "Score[1st]: %d", "tformat")
t("Score: %d", "Score: %d", "tformat")
t("[MiniBoss]", "[MiniBoss]", "_t")
t("[Boss]", "[Boss]", "_t")
t("[Final]", "[Final]", "_t")
t("Wave(TOP) %d %s", "Wave(TOP) %d %s", "tformat")
t("Wave %d %s", "Wave %d %s", "tformat")
t("Bonus: %d (x%.1f)", "Bonus: %d (x%.1f)", "tformat")
t(" VS", " VS", "_t")
t("Saving... %d%%", "Saving... %d%%", "tformat")
t("%s reduced the duration of this effect by %d turns, from %d to %d.", "%s reduced the duration of this effect by %d turns, from %d to %d.", "tformat")
t([[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], [[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], "tformat")
t("\
---\
Right click to cancel early.", "\
---\
Right click to cancel early.", "_t")
t("Really cancel %s?", "Really cancel %s?", "tformat")
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], "tformat")
t("\
Turns remaining: %s", "\
Turns remaining: %s", "tformat")
t("Lvl %d", "Lvl %d", "tformat")
t([[Toggle for movement mode.
Default: when trying to move onto a creature it will attack if hostile.
Passive: when trying to move onto a creature it will not attack (use ctrl+direction, or right click to attack manually)]], [[Toggle for movement mode.
Default: when trying to move onto a creature it will attack if hostile.
Passive: when trying to move onto a creature it will not attack (use ctrl+direction, or right click to attack manually)]], "_t")
t("Show character infos", "Show character infos", "_t")
t("Click to assign stats and talents!", "Click to assign stats and talents!", "_t")
t("Show available cosmetic & fun microtransation", "Show available cosmetic & fun microtransation", "_t")
t([[Left mouse to move
Right mouse to scroll
Middle mouse to show full map]], [[Left mouse to move
Right mouse to scroll
Middle mouse to show full map]], "_t")
t("Left click to use", "Left click to use", "_t")
t("Press 'm' to setup", "Press 'm' to setup", "_t")
t("Right click to configure", "Right click to configure", "_t")
t("Remove this object from your hotkeys?", "Remove this object from your hotkeys?", "_t")
t("Unbind %s", "Unbind %s", "tformat")
t([[Left mouse to show inventory
Right mouse to show ingredients]], [[Left mouse to show inventory
Right mouse to show ingredients]], "_t")
t("Left mouse to show known talents", "Left mouse to show known talents", "_t")
t("Left mouse to show message/chat log.", "Left mouse to show message/chat log.", "_t")
t([[Left mouse to show quest log.
Right mouse to show all known lore.]], [[Left mouse to show quest log.
Right mouse to show all known lore.]], "_t")
t("Left mouse to show main menu", "Left mouse to show main menu", "_t")
t("Lock all interface elements so they can not be moved nor resized.", "Lock all interface elements so they can not be moved nor resized.", "_t")
t("Unlock all interface elements so they can be moved and resized.", "Unlock all interface elements so they can be moved and resized.", "_t")
t("Clicking will open#LIGHT_BLUE##{italic}#%s#WHITE##{normal}# in your browser", "Clicking will open#LIGHT_BLUE##{italic}#%s#WHITE##{normal}# in your browser", "_t")
t("Developer", "Developer", "_t")
t("Moderator / Helper", "Moderator / Helper", "_t")
t("Donator", "Donator", "_t")
t("Recurring Donator", "Recurring Donator", "_t")
t("Playing: ", "Playing: ", "_t")
t("Clicking will open ", "Clicking will open ", "_t")
t("Show chat user", "Show chat user", "_t")
t("Report user for bad behavior", "Report user for bad behavior", "_t")
t("#VIOLET#", "#VIOLET#", "log")
t("Really remove %s from your friends?", "Really remove %s from your friends?", "tformat")
t("Remove Friend", "Remove Friend", "_t")
t("Add Friend", "Add Friend", "_t")
t("Really add %s to your friends?", "Really add %s to your friends?", "tformat")


------------------------------------------------
section "game/modules/tome/data/birth/races/construct.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/calendar_allied.lua"
-- 9 entries
t("Allure", "Allure", "calendar allied")
t("Regrowth", "Regrowth", "calendar allied")
t("Time of Balance", "Time of Balance", "calendar allied")
t("Pyre", "Pyre", "calendar allied")
t("Mirth", "Mirth", "calendar allied")
t("Dusk", "Dusk", "calendar allied")
t("Time of Equilibrium", "Time of Equilibrium", "calendar allied")
t("Haze", "Haze", "calendar allied")
t("Decay", "Decay", "calendar allied")


------------------------------------------------
section "game/modules/tome/data/calendar_dwarf.lua"
-- 11 entries
t("Iron", "Iron", "calendar dwarf")
t("Steel", "Steel", "calendar dwarf")
t("Gold", "Gold", "calendar dwarf")
t("Stralite", "Stralite", "calendar dwarf")
t("Voratun", "Voratun", "calendar dwarf")
t("Acquisition", "Acquisition", "calendar dwarf")
t("Profit", "Profit", "calendar dwarf")
t("Wealth", "Wealth", "calendar dwarf")
t("Dearth", "Dearth", "calendar dwarf")
t("Loss", "Loss", "calendar dwarf")
t("Shortage", "Shortage", "calendar dwarf")


------------------------------------------------
section "game/modules/tome/data/chats/arena.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/artifice-mastery.lua"
-- 1 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")


------------------------------------------------
section "game/modules/tome/data/chats/artifice.lua"
-- 1 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")


------------------------------------------------
section "game/modules/tome/data/chats/eidolon-plane.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/keepsake-caravan-destroyed.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/last-hope-lost-merchant.lua"
-- 2 entries
t("while", "while", "_t")
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/mage-apprentice-quest.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/orc-breeding-pits.lua"
-- 6 entries
t([[#LIGHT_GREEN#*A ray of light illuminates the gleam of steal amidst the grass. Investigating, you find a lone sun paladin lying stricken on the ground. Her wounds are minor, but her pallid features bely a poison that is taking its final toll. She whispers to you.*#WHITE#
Help, Help me.
]], [[#LIGHT_GREEN#*A ray of light illuminates the gleam of steal amidst the grass. Investigating, you find a lone sun paladin lying stricken on the ground. Her wounds are minor, but her pallid features bely a poison that is taking its final toll. She whispers to you.*#WHITE#
Help, Help me.
]], "_t")
t("What should I do?", "What should I do?", "_t")
t([[I found it... the abomination Aeryn sent me to seek out. The breeding pits of the orcs... It is more vile than you can imagine... They have it hidden away from their encampments, out of sight of all their people. Their mothers, their young, all there - all vulnerable!
#LIGHT_GREEN#*She pulls out a sketched map, and with some effort puts it in your palm.*#WHITE#

This could be the final solution, the end to the war... forever. We must strike soon, before reinforcements...

#LIGHT_GREEN#*She looks hard at you, exerting all her effort into a final pleading stare.*#WHITE#]], [[I found it... the abomination Aeryn sent me to seek out. The breeding pits of the orcs... It is more vile than you can imagine... They have it hidden away from their encampments, out of sight of all their people. Their mothers, their young, all there - all vulnerable!
#LIGHT_GREEN#*She pulls out a sketched map, and with some effort puts it in your palm.*#WHITE#

This could be the final solution, the end to the war... forever. We must strike soon, before reinforcements...

#LIGHT_GREEN#*She looks hard at you, exerting all her effort into a final pleading stare.*#WHITE#]], "_t")
t("I cannot do this myself... I will tell Aeryn about it, it is in her hands.", "I cannot do this myself... I will tell Aeryn about it, it is in her hands.", "_t")
t("I will go myself and ensure this is thoroughly dealt with.", "I will go myself and ensure this is thoroughly dealt with.", "_t")
t("You want me to kill mothers and children? This is barbaric, I'll have nothing to do with it!", "You want me to kill mothers and children? This is barbaric, I'll have nothing to do with it!", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/player-inscription.lua"
-- 1 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")


------------------------------------------------
section "game/modules/tome/data/chats/trap-priming.lua"
-- 2 entries
t("%s[%s: %s]#LAST#", "%s[%s: %s]#LAST#", "tformat")
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")


------------------------------------------------
section "game/modules/tome/data/chats/tutorial-start.lua"
-- 5 entries
t("Hello there. What subject interests you?", "Hello there. What subject interests you?", "_t")
t("Basic gameplay", "Basic gameplay", "_t")
t("Combat stat mechanics", "Combat stat mechanics", "_t")
t("Is there nothing more for me to learn here?", "Is there nothing more for me to learn here?", "_t")
t("\
You have completed all the tutorials, and should now know the basics of ToME4. You are ready to step forward into the world to find glory, treasures and be mercilessly slaughtered by hordes of creatures you thought you could handle!\
\
During this tutorial some creatures were adjusted according to the needs of the lessons. In the unforgiving world of Eyal, monsters are rarely this nice!\
\
If you need a reminder of which key does what, you can access the game menu by pressing #GOLD#Escape#WHITE# and checking the key binds. You can also adjust them to suit your needs.\
\
If this is your first time with the game, you will find the selection of races and classes limited. Don't worry; many, many more will become available as you unlock them during your adventures. \
\
Now go boldly and remember: #GOLD#have fun!#WHITE#\
Press #GOLD#Escape#WHITE#, then select #GOLD#Save and Exit#WHITE#, and create a new character!", "\
You have completed all the tutorials, and should now know the basics of ToME4. You are ready to step forward into the world to find glory, treasures and be mercilessly slaughtered by hordes of creatures you thought you could handle!\
\
During this tutorial some creatures were adjusted according to the needs of the lessons. In the unforgiving world of Eyal, monsters are rarely this nice!\
\
If you need a reminder of which key does what, you can access the game menu by pressing #GOLD#Escape#WHITE# and checking the key binds. You can also adjust them to suit your needs.\
\
If this is your first time with the game, you will find the selection of races and classes limited. Don't worry; many, many more will become available as you unlock them during your adventures. \
\
Now go boldly and remember: #GOLD#have fun!#WHITE#\
Press #GOLD#Escape#WHITE#, then select #GOLD#Save and Exit#WHITE#, and create a new character!", "_t")


------------------------------------------------
section "game/modules/tome/data/chats/worldly-knowledge.lua"
-- 1 entries
t([[#GOLD#%s / %s#LAST#
]], [[#GOLD#%s / %s#LAST#
]], "tformat")


------------------------------------------------
section "game/modules/tome/data/chats/zoisla.lua"
-- 1 entries
t("...", "...", "_t")


------------------------------------------------
section "game/modules/tome/data/damage_types.lua"
-- 3 entries
t("%s<terror chance>#LAST#", "%s<terror chance>#LAST#", "tformat")
t("%s<blinding powder>#LAST#", "%s<blinding powder>#LAST#", "tformat")
t("%s<smoke>#LAST#", "%s<smoke>#LAST#", "tformat")


------------------------------------------------
section "game/modules/tome/data/general/objects/boss-artifacts-maj-eyal.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/general/objects/gem.lua"
-- 1 entries
t("..", "..", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/objects-far-east.lua"
-- 2 entries
t("ancient tome", "ancient tome", "_t")
t("Ancient Tome titled 'Gems and their uses'", "Ancient Tome titled 'Gems and their uses'", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts.lua"
-- 29 entries
t("resist physical", "resist physical", "entity name")
t("resist fire", "resist fire", "entity name")
t("resist cold", "resist cold", "entity name")
t("resist acid", "resist acid", "entity name")
t("resist lightning", "resist lightning", "entity name")
t("resist arcane", "resist arcane", "entity name")
t("resist nature", "resist nature", "entity name")
t("resist blight", "resist blight", "entity name")
t("resist light", "resist light", "entity name")
t("resist darkness", "resist darkness", "entity name")
t("resist mind", "resist mind", "entity name")
t("save physical", "save physical", "entity name")
t("save spell", "save spell", "entity name")
t("save mental", "save mental", "entity name")
t("mana regeneration", "mana regeneration", "entity name")
t("stamina regeneration", "stamina regeneration", "entity name")
t("life regeneration", "life regeneration", "entity name")
t("increased mana", "increased mana", "entity name")
t("increased stamina", "increased stamina", "entity name")
t("increased life", "increased life", "entity name")
t("see invisible", "see invisible", "entity name")
t("decreased fatigue", "decreased fatigue", "entity name")
t("greater max encumbrance", "greater max encumbrance", "entity name")
t("improve heal", "improve heal", "entity name")
t("lite radius", "lite radius", "entity name")
t("water breathing", "water breathing", "entity name")
t("orc telepathy", "orc telepathy", "entity name")
t("dragon telepathy", "dragon telepathy", "entity name")
t("demon telepathy", "demon telepathy", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/ammo.lua"
-- 2 entries
t("ammo reload", "ammo reload", "entity name")
t("travel speed", "travel speed", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/generic.lua"
-- 111 entries
t("generic spellpower", "generic spellpower", "entity name")
t("generic spellcrit", "generic spellcrit", "entity name")
t("generic spell crit magnitude", "generic spell crit magnitude", "entity name")
t("generic spellsurge", "generic spellsurge", "entity name")
t("generic mana regeneration", "generic mana regeneration", "entity name")
t("generic increased mana", "generic increased mana", "entity name")
t("generic mana on crit", "generic mana on crit", "entity name")
t("generic increased vim", "generic increased vim", "entity name")
t("generic vim on crit", "generic vim on crit", "entity name")
t("generic phasing", "generic phasing", "entity name")
t("generic mindpower", "generic mindpower", "entity name")
t("generic mindcrit", "generic mindcrit", "entity name")
t("generic mind crit magnitude", "generic mind crit magnitude", "entity name")
t("generic equilibrium on hit", "generic equilibrium on hit", "entity name")
t("generic max hate", "generic max hate", "entity name")
t("generic hate on crit", "generic hate on crit", "entity name")
t("generic max psi", "generic max psi", "entity name")
t("generic psi on hit", "generic psi on hit", "entity name")
t("generic phys dam", "generic phys dam", "entity name")
t("generic phys apr", "generic phys apr", "entity name")
t("generic phys crit", "generic phys crit", "entity name")
t("generic phys atk", "generic phys atk", "entity name")
t("generic phys crit magnitude", "generic phys crit magnitude", "entity name")
t("generic stamina regeneration", "generic stamina regeneration", "entity name")
t("generic increased stamina", "generic increased stamina", "entity name")
t("generic def", "generic def", "entity name")
t("generic armor", "generic armor", "entity name")
t("generic life regeneration", "generic life regeneration", "entity name")
t("generic increased life", "generic increased life", "entity name")
t("generic improve heal", "generic improve heal", "entity name")
t("generic save physical", "generic save physical", "entity name")
t("generic save spell", "generic save spell", "entity name")
t("generic save mental", "generic save mental", "entity name")
t("generic immune stun", "generic immune stun", "entity name")
t("generic immune knockback", "generic immune knockback", "entity name")
t("generic immune blind", "generic immune blind", "entity name")
t("generic immune confusion", "generic immune confusion", "entity name")
t("generic immune pin", "generic immune pin", "entity name")
t("generic immune poison", "generic immune poison", "entity name")
t("generic immune disease", "generic immune disease", "entity name")
t("generic immune silence", "generic immune silence", "entity name")
t("generic immune disarm", "generic immune disarm", "entity name")
t("generic immune cut", "generic immune cut", "entity name")
t("generic immune teleport", "generic immune teleport", "entity name")
t("generic resist physical", "generic resist physical", "entity name")
t("generic resist mind", "generic resist mind", "entity name")
t("generic resist fire", "generic resist fire", "entity name")
t("generic resist cold", "generic resist cold", "entity name")
t("generic resist acid", "generic resist acid", "entity name")
t("generic resist lightning", "generic resist lightning", "entity name")
t("generic resist arcane", "generic resist arcane", "entity name")
t("generic resist nature", "generic resist nature", "entity name")
t("generic resist blight", "generic resist blight", "entity name")
t("generic resist light", "generic resist light", "entity name")
t("generic resist darkness", "generic resist darkness", "entity name")
t("generic resist temporal", "generic resist temporal", "entity name")
t("generic physical retribution", "generic physical retribution", "entity name")
t("generic mind retribution", "generic mind retribution", "entity name")
t("generic acid retribution", "generic acid retribution", "entity name")
t("generic lightning retribution", "generic lightning retribution", "entity name")
t("generic fire retribution", "generic fire retribution", "entity name")
t("generic cold retribution", "generic cold retribution", "entity name")
t("generic light retribution", "generic light retribution", "entity name")
t("generic dark retribution", "generic dark retribution", "entity name")
t("generic blight retribution", "generic blight retribution", "entity name")
t("generic nature retribution", "generic nature retribution", "entity name")
t("generic arcane retribution", "generic arcane retribution", "entity name")
t("generic temporal retribution", "generic temporal retribution", "entity name")
t("generic inc damage physical", "generic inc damage physical", "entity name")
t("generic inc damage mind", "generic inc damage mind", "entity name")
t("generic inc damage fire", "generic inc damage fire", "entity name")
t("generic inc damage cold", "generic inc damage cold", "entity name")
t("generic inc damage acid", "generic inc damage acid", "entity name")
t("generic inc damage lightning", "generic inc damage lightning", "entity name")
t("generic inc damage arcane", "generic inc damage arcane", "entity name")
t("generic inc damage nature", "generic inc damage nature", "entity name")
t("generic inc damage blight", "generic inc damage blight", "entity name")
t("generic inc damage light", "generic inc damage light", "entity name")
t("generic inc damage darkness", "generic inc damage darkness", "entity name")
t("generic inc damage temporal", "generic inc damage temporal", "entity name")
t("generic resists pen physical", "generic resists pen physical", "entity name")
t("generic resists pen mind", "generic resists pen mind", "entity name")
t("generic resists pen fire", "generic resists pen fire", "entity name")
t("generic resists pen cold", "generic resists pen cold", "entity name")
t("generic resists pen acid", "generic resists pen acid", "entity name")
t("generic resists pen lightning", "generic resists pen lightning", "entity name")
t("generic resists pen arcane", "generic resists pen arcane", "entity name")
t("generic resists pen nature", "generic resists pen nature", "entity name")
t("generic resists pen blight", "generic resists pen blight", "entity name")
t("generic resists pen light", "generic resists pen light", "entity name")
t("generic resists pen darkness", "generic resists pen darkness", "entity name")
t("generic resists pen temporal", "generic resists pen temporal", "entity name")
t("generic stat str", "generic stat str", "entity name")
t("generic stat dex", "generic stat dex", "entity name")
t("generic stat mag", "generic stat mag", "entity name")
t("generic stat wil", "generic stat wil", "entity name")
t("generic stat cun", "generic stat cun", "entity name")
t("generic stat con", "generic stat con", "entity name")
t("generic see invisible", "generic see invisible", "entity name")
t("generic infravision radius", "generic infravision radius", "entity name")
t("generic lite radius", "generic lite radius", "entity name")
t("generic corrupted blood melee", "generic corrupted blood melee", "entity name")
t("generic acid corrode melee", "generic acid corrode melee", "entity name")
t("generic mind expose melee", "generic mind expose melee", "entity name")
t("generic manaburn melee", "generic manaburn melee", "entity name")
t("generic temporal energize melee", "generic temporal energize melee", "entity name")
t("generic slime melee", "generic slime melee", "entity name")
t("generic dark numbing melee", "generic dark numbing melee", "entity name")
t("generic die at", "generic die at", "entity name")
t("generic ignore crit", "generic ignore crit", "entity name")
t("generic void", "generic void", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/gloves.lua"
-- 38 entries
t("apr", "apr", "entity name")
t("crit", "crit", "entity name")
t("physical melee", "physical melee", "entity name")
t("mind melee", "mind melee", "entity name")
t("temporal melee", "temporal melee", "entity name")
t("corrupted blood melee", "corrupted blood melee", "entity name")
t("temporal energize melee", "temporal energize melee", "entity name")
t("gloom mind melee", "gloom mind melee", "entity name")
t("acid corrode melee", "acid corrode melee", "entity name")
t("light blind melee", "light blind melee", "entity name")
t("lightning daze melee", "lightning daze melee", "entity name")
t("manaburn melee", "manaburn melee", "entity name")
t("slime melee", "slime melee", "entity name")
t("dark numbing melee", "dark numbing melee", "entity name")
t("physical burst", "physical burst", "entity name")
t("mind burst", "mind burst", "entity name")
t("acid burst", "acid burst", "entity name")
t("lightning burst", "lightning burst", "entity name")
t("fire burst", "fire burst", "entity name")
t("cold burst", "cold burst", "entity name")
t("light burst", "light burst", "entity name")
t("dark burst", "dark burst", "entity name")
t("blight burst", "blight burst", "entity name")
t("nature burst", "nature burst", "entity name")
t("arcane burst", "arcane burst", "entity name")
t("temporal burst", "temporal burst", "entity name")
t("physical burst (crit)", "physical burst (crit)", "entity name")
t("mind burst (crit)", "mind burst (crit)", "entity name")
t("acid burst (crit)", "acid burst (crit)", "entity name")
t("lightning burst (crit)", "lightning burst (crit)", "entity name")
t("fire burst (crit)", "fire burst (crit)", "entity name")
t("cold burst (crit)", "cold burst (crit)", "entity name")
t("light burst (crit)", "light burst (crit)", "entity name")
t("dark burst (crit)", "dark burst (crit)", "entity name")
t("blight burst (crit)", "blight burst (crit)", "entity name")
t("nature burst (crit)", "nature burst (crit)", "entity name")
t("arcane burst (crit)", "arcane burst (crit)", "entity name")
t("temporal burst (crit)", "temporal burst (crit)", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/melee.lua"
-- 36 entries
t("apr", "apr", "entity name")
t("crit", "crit", "entity name")
t("physical melee", "physical melee", "entity name")
t("mind melee", "mind melee", "entity name")
t("temporal melee", "temporal melee", "entity name")
t("corrupted blood melee", "corrupted blood melee", "entity name")
t("temporal energize melee", "temporal energize melee", "entity name")
t("expose mind melee", "expose mind melee", "entity name")
t("acid corrode melee", "acid corrode melee", "entity name")
t("manaburn melee", "manaburn melee", "entity name")
t("slime melee", "slime melee", "entity name")
t("dark numbing melee", "dark numbing melee", "entity name")
t("physical burst", "physical burst", "entity name")
t("mind burst", "mind burst", "entity name")
t("acid burst", "acid burst", "entity name")
t("lightning burst", "lightning burst", "entity name")
t("fire burst", "fire burst", "entity name")
t("cold burst", "cold burst", "entity name")
t("light burst", "light burst", "entity name")
t("dark burst", "dark burst", "entity name")
t("blight burst", "blight burst", "entity name")
t("nature burst", "nature burst", "entity name")
t("arcane burst", "arcane burst", "entity name")
t("temporal burst", "temporal burst", "entity name")
t("physical burst (crit)", "physical burst (crit)", "entity name")
t("mind burst (crit)", "mind burst (crit)", "entity name")
t("acid burst (crit)", "acid burst (crit)", "entity name")
t("lightning burst (crit)", "lightning burst (crit)", "entity name")
t("fire burst (crit)", "fire burst (crit)", "entity name")
t("cold burst (crit)", "cold burst (crit)", "entity name")
t("light burst (crit)", "light burst (crit)", "entity name")
t("dark burst (crit)", "dark burst (crit)", "entity name")
t("blight burst (crit)", "blight burst (crit)", "entity name")
t("nature burst (crit)", "nature burst (crit)", "entity name")
t("arcane burst (crit)", "arcane burst (crit)", "entity name")
t("temporal burst (crit)", "temporal burst (crit)", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/ranged.lua"
-- 2 entries
t("ammo reload", "ammo reload", "entity name")
t("travel speed", "travel speed", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/shields.lua"
-- 3 entries
t("shield block", "shield block", "entity name")
t("shield armor", "shield armor", "entity name")
t("shield increased life", "shield increased life", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/random-artifacts/staves.lua"
-- 27 entries
t("stave increased positive/negative energy", "stave increased positive/negative energy", "entity name")
t("stave paradox reduce anomalies", "stave paradox reduce anomalies", "entity name")
t("stave spellpower", "stave spellpower", "entity name")
t("stave inc damage physical", "stave inc damage physical", "entity name")
t("stave inc damage mind", "stave inc damage mind", "entity name")
t("stave inc damage fire", "stave inc damage fire", "entity name")
t("stave inc damage cold", "stave inc damage cold", "entity name")
t("stave inc damage acid", "stave inc damage acid", "entity name")
t("stave inc damage lightning", "stave inc damage lightning", "entity name")
t("stave inc damage arcane", "stave inc damage arcane", "entity name")
t("stave inc damage nature", "stave inc damage nature", "entity name")
t("stave inc damage blight", "stave inc damage blight", "entity name")
t("stave inc damage light", "stave inc damage light", "entity name")
t("stave inc damage darkness", "stave inc damage darkness", "entity name")
t("stave inc damage temporal", "stave inc damage temporal", "entity name")
t("stave resists pen physical", "stave resists pen physical", "entity name")
t("stave resists pen mind", "stave resists pen mind", "entity name")
t("stave resists pen fire", "stave resists pen fire", "entity name")
t("stave resists pen cold", "stave resists pen cold", "entity name")
t("stave resists pen acid", "stave resists pen acid", "entity name")
t("stave resists pen lightning", "stave resists pen lightning", "entity name")
t("stave resists pen arcane", "stave resists pen arcane", "entity name")
t("stave resists pen nature", "stave resists pen nature", "entity name")
t("stave resists pen blight", "stave resists pen blight", "entity name")
t("stave resists pen light", "stave resists pen light", "entity name")
t("stave resists pen darkness", "stave resists pen darkness", "entity name")
t("stave resists pen temporal", "stave resists pen temporal", "entity name")


------------------------------------------------
section "game/modules/tome/data/general/objects/rods.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/general/objects/world-artifacts.lua"
-- 1 entries
t("%s: %s", "%s: %s", "tformat")


------------------------------------------------
section "game/modules/tome/data/lore/age-allure.lua"
-- 14 entries
t([[#{italic}#To: Research Director Hompalan - #{bold}#TOP PRIORITY#{normal}#

Thanks to one of our scouting parties catching a Conclave lieutenant's squad off-guard, we have found directions to a noteworthy laboratory hidden underground, in what's newly Nargol territory.  Unfortunately, the long-legs scuttled the entrances before we could arrive, and it'd take us years to dig ourselves in, even if we could afford recalling our geomancers from the front lines to work on it - which we can't.  

Your new objective is to find a way to warp a recovery team inside to scavenge it, then get them back safely with their data in tow.  It's possible that they've figured out a way to ward it against teleportation; enclosed is a key, in case it's necessary to target a point between the obstruction and the entrance.  I don't want to hear any of your nonsense about it being "impossible" without a linked portal near the destination; thirty years ago, you would've told me that almost everything you're now doing on a daily basis is impossible.

I know you think yourself "above" such "petty politics" like how vital this facility would be to our survival, so I won't bore you with stressing how important this is to us.  Accordingly, let me put this in terms you can relate to: This is an order, and your usual excuses won't cut it.  Your job is on the line.  #{bold}#Make.  It.  Work.#{normal}#

-General Martolep

#{italic}#(Some coordinates are enclosed, along with a large, magic-infused key.  You think you can figure out, roughly, where this sealed Conclave facility is.)#{normal}#
]], [[#{italic}#To: Research Director Hompalan - #{bold}#TOP PRIORITY#{normal}#

Thanks to one of our scouting parties catching a Conclave lieutenant's squad off-guard, we have found directions to a noteworthy laboratory hidden underground, in what's newly Nargol territory.  Unfortunately, the long-legs scuttled the entrances before we could arrive, and it'd take us years to dig ourselves in, even if we could afford recalling our geomancers from the front lines to work on it - which we can't.  

Your new objective is to find a way to warp a recovery team inside to scavenge it, then get them back safely with their data in tow.  It's possible that they've figured out a way to ward it against teleportation; enclosed is a key, in case it's necessary to target a point between the obstruction and the entrance.  I don't want to hear any of your nonsense about it being "impossible" without a linked portal near the destination; thirty years ago, you would've told me that almost everything you're now doing on a daily basis is impossible.

I know you think yourself "above" such "petty politics" like how vital this facility would be to our survival, so I won't bore you with stressing how important this is to us.  Accordingly, let me put this in terms you can relate to: This is an order, and your usual excuses won't cut it.  Your job is on the line.  #{bold}#Make.  It.  Work.#{normal}#

-General Martolep

#{italic}#(Some coordinates are enclosed, along with a large, magic-infused key.  You think you can figure out, roughly, where this sealed Conclave facility is.)#{normal}#
]], "_t")
t("Door to an old Conclave vault", "Door to an old Conclave vault", "_t")
t("Arriving at the location given by the coordinates, you see an enormous crack in the ground; peering down, the gleam of exposed metal catches your eye, and you recognize it as a massive door.  It would seem that the Cataclysm's tectonic upheaval has carved a path right to one of its entrances, bypassing the ruined tunnels entirely. You climb down, just outside the door.", "Arriving at the location given by the coordinates, you see an enormous crack in the ground; peering down, the gleam of exposed metal catches your eye, and you recognize it as a massive door.  It would seem that the Cataclysm's tectonic upheaval has carved a path right to one of its entrances, bypassing the ruined tunnels entirely. You climb down, just outside the door.", "_t")
t("Conclave Vault", "Conclave Vault", "_t")
t("healer Astelrid log 1", "healer Astelrid log 1", "_t")
t([[Work in a hospital like this is more draining than I thought it'd be.  I thought I'd have no trouble with motivation, helping our wounded get back to health again, but seeing so many of them, and knowing there are some I cannot help...  it weighs heavily on my mind.  It would be difficult to go on, if I did not keep a few things in mind: 

One, that I am truly doing the best I can to minimize the world's suffering, both directly by healing, and indirectly by ensuring that the world will be united under the wise, thoughtful rule of the Conclave.  Ready access to regeneration infusions ensures that even the most dire of wounds can be healed in a matter of days, and the soldiers can return to the battlefield; furthermore, the Overseers have granted us access to their amnesia-inducing spells, allowing us to properly treat those who have been traumatized by the horrors of battle.  May the eyes of the Higher watch over this world for thousands of years to come.

Two, that the "side project" the Overseers have assigned me to is working out very well.  Those wounded who have consented to our trial treatments, consisting of a unique combination of experimental variations on heroism infusions and shielding runes, have experienced slightly increased physical strength and endurance, with no sign of the effects wearing off.  There is one mild side effect which has given me cause to worry, though I dare not speak of my misgivings to anyone else; some of those treated have needed to be disciplined for getting too "enthusiastic" in battle.  The Overseers have assured me that this is actually having a net positive effect on morale, and thus I can wait to cure these aggressive tendencies until the war is over.  In the meantime, I am proud of my work, and although it's nothing so glorious as the creation of the Higher race, it will be a tremendous boon to our society in the long term.

And three, that the war will soon be over, and with it we shall no longer have to bear the maiming of our proud soldiers and the impudence of the Nargol.  We have made impressive gains in territory in the last few days, thwarting numerous ambushes and keeping our momentum as we expand further into Nargol lands.  Granted, one cannot be sure of how much of what we're hearing has been "cleaned up" by the Overseers, but one recent statement from the Nargol leads me to believe it is the truth:

"This is your last chance to back down.  A great tragedy will ensue if you continue to push further, and do not accept our previously-stated terms of peaceful resolution.  Do not force us to do this."

After waging a war of trickery and deceit, those halflings think they can bluff us!  Once their military is broken, we can bring their citizens into our fold and enlighten them, and then the true healing can begin.]], [[Work in a hospital like this is more draining than I thought it'd be.  I thought I'd have no trouble with motivation, helping our wounded get back to health again, but seeing so many of them, and knowing there are some I cannot help...  it weighs heavily on my mind.  It would be difficult to go on, if I did not keep a few things in mind: 

One, that I am truly doing the best I can to minimize the world's suffering, both directly by healing, and indirectly by ensuring that the world will be united under the wise, thoughtful rule of the Conclave.  Ready access to regeneration infusions ensures that even the most dire of wounds can be healed in a matter of days, and the soldiers can return to the battlefield; furthermore, the Overseers have granted us access to their amnesia-inducing spells, allowing us to properly treat those who have been traumatized by the horrors of battle.  May the eyes of the Higher watch over this world for thousands of years to come.

Two, that the "side project" the Overseers have assigned me to is working out very well.  Those wounded who have consented to our trial treatments, consisting of a unique combination of experimental variations on heroism infusions and shielding runes, have experienced slightly increased physical strength and endurance, with no sign of the effects wearing off.  There is one mild side effect which has given me cause to worry, though I dare not speak of my misgivings to anyone else; some of those treated have needed to be disciplined for getting too "enthusiastic" in battle.  The Overseers have assured me that this is actually having a net positive effect on morale, and thus I can wait to cure these aggressive tendencies until the war is over.  In the meantime, I am proud of my work, and although it's nothing so glorious as the creation of the Higher race, it will be a tremendous boon to our society in the long term.

And three, that the war will soon be over, and with it we shall no longer have to bear the maiming of our proud soldiers and the impudence of the Nargol.  We have made impressive gains in territory in the last few days, thwarting numerous ambushes and keeping our momentum as we expand further into Nargol lands.  Granted, one cannot be sure of how much of what we're hearing has been "cleaned up" by the Overseers, but one recent statement from the Nargol leads me to believe it is the truth:

"This is your last chance to back down.  A great tragedy will ensue if you continue to push further, and do not accept our previously-stated terms of peaceful resolution.  Do not force us to do this."

After waging a war of trickery and deceit, those halflings think they can bluff us!  Once their military is broken, we can bring their citizens into our fold and enlighten them, and then the true healing can begin.]], "_t")
t("healer Astelrid log 2", "healer Astelrid log 2", "_t")
t([[The Nargol were not bluffing, and what they did was worse than anything we could've imagined.  The details coming from the survivors - of which there are both far too many and far too few - are conflicting at times, but from what I can tell...

As our forces began their final push, the ground began to rumble and give way behind them, and the bones of the war's fallen (halflings and Conclave alike) began to rise up, then draw their once-discarded weapons and rush at our soldiers in a frenzy.  There were so many...  those who were on higher ground when it happened said it was like a sea of bones and rotting flesh.  Outnumbered, our forces broke ranks and tried to retreat, but with the halflings in front of them and the abominations behind them, we took tremendous losses...  and our humble medical center is overflowing with the gravely wounded.  Many come to us with a terrible sickness passed on by the Nargol's ghouls; there is no cure for this, and I have already had to "mercifully" end the lives of over a dozen men and women to save them from a long, drawn-out death, ending in their transfiguration into one of those horrid creatures...  including--

[The end of the preceding paragraph, several lines' worth of text, has been furiously scribbled out.]

No...  the real horrid creatures here are the halflings.  We've seen necromancy before, but mostly as a parlor trick by deranged cults; we never dreamed that any large organization would tolerate it, let alone hide necromantic charms on every one of its ranking officers.  They've been planning to do this since the start of the war, and only sprung the trap now...  Any misgivings I had about the aggression associated with our new treatment are gone forever; we cannot be ferocious enough in purging these fiends from Maj'Eyal.  I have requested an audience with the Overseers to broaden the scope of our experiments, setting our sights higher so we may crush this evil empire as swiftly as possible.  

May the Conclave prevail, and may the Empire's fate serve as a warning to all who would defy our wisdom.]], [[The Nargol were not bluffing, and what they did was worse than anything we could've imagined.  The details coming from the survivors - of which there are both far too many and far too few - are conflicting at times, but from what I can tell...

As our forces began their final push, the ground began to rumble and give way behind them, and the bones of the war's fallen (halflings and Conclave alike) began to rise up, then draw their once-discarded weapons and rush at our soldiers in a frenzy.  There were so many...  those who were on higher ground when it happened said it was like a sea of bones and rotting flesh.  Outnumbered, our forces broke ranks and tried to retreat, but with the halflings in front of them and the abominations behind them, we took tremendous losses...  and our humble medical center is overflowing with the gravely wounded.  Many come to us with a terrible sickness passed on by the Nargol's ghouls; there is no cure for this, and I have already had to "mercifully" end the lives of over a dozen men and women to save them from a long, drawn-out death, ending in their transfiguration into one of those horrid creatures...  including--

[The end of the preceding paragraph, several lines' worth of text, has been furiously scribbled out.]

No...  the real horrid creatures here are the halflings.  We've seen necromancy before, but mostly as a parlor trick by deranged cults; we never dreamed that any large organization would tolerate it, let alone hide necromantic charms on every one of its ranking officers.  They've been planning to do this since the start of the war, and only sprung the trap now...  Any misgivings I had about the aggression associated with our new treatment are gone forever; we cannot be ferocious enough in purging these fiends from Maj'Eyal.  I have requested an audience with the Overseers to broaden the scope of our experiments, setting our sights higher so we may crush this evil empire as swiftly as possible.  

May the Conclave prevail, and may the Empire's fate serve as a warning to all who would defy our wisdom.]], "_t")
t("healer Astelrid log 3", "healer Astelrid log 3", "_t")
t([[The Overseers were ecstatic about my ideas!  Our staff have been relocated to a more secure location, deep underground with several extensive tunnels leading in from different locations.  Although this means we can no longer leave to harvest herbs for our infusions, the increased budget the Overseers have given us does more than enough to compensate.  Many wounded are still brought to me through the tunnels, but now our goal is not simply to make them as strong and healthy as they were before, but far stronger and far healthier than they could've dreamed.  They are brought to us unconscious, with amnesia spells already applied to ensure they do not resist our experiments; although they are not told they will be test subjects before being brought here, we are sure they would consent to these experiments, if they knew how valuable they were to help the Conclave.  As such, although this process violates several oaths we have taken as healers, I ultimately do not see any moral problem with this, and nobody else at this facility has expressed any concerns to me.  After all, those who join the Conclave as soldiers have already volunteered to give their lives in service to the Overseers' enlightened rule, and this is surely a much more productive way to do so than dying to a Nargol sling-bullet.

With access to better components, we can make the same basic improvements to their strength as we could before, but the changes do not stop there!  With so many subjects to work with, and the Overseers' encouragement to take risks, we've made them much larger (with associated multiplying effects on their effectiveness in combat), and reinforced their constitution to be capable of bearing more inscriptions without collapsing under the stress.  A fellow researcher had the brilliant idea to use this runic affinity to both enhance their connection to magic's weave, and make them biologically and structurally dependent on it; now, our front-line soldiers can conjure devastating fireballs with little training, and should those hairy-footed vermin attempt to raise one of these soldiers from the dead, they will collapse, having lost the magic that kept them intact when they still lived.  

The Overseers have been working with us personally to make psychological changes as well; with the blank slate provided by the amnesia spell, we've managed to give them a mindset that will serve them well both during the war and for our glorious reign that shall follow.  Extraordinarily dutiful, helpful and striving for excellence in their daily lives without lusting for power or personal glory, wise about their place in the world, and slow to anger...  but utterly ferocious when needed.  Just as the Higher were created to be scholars and policy-makers, and have proven successful in this role beyond the Conclave's wildest dreams, these new "Ogres" (as the staff has taken to nicknaming them) shall be our laborers and soldiers, a solid foundation of hard work and dutiful enforcement on which our society shall be built.  There will still be a place for the unaltered races, of course; their natural adaptability will make them perfect to fill in the gaps, as the glue that holds everything else together.

These Ogres are integrating into our military very well!  The rank-and-file soldiers know better than to attract attention from the Overseers by asking too many questions about where their new, giant allies came from, and thus acceptance came rather swiftly once they saw these creations in action.  We received one report that an Ogre sergeant was seen eating a particularly insolent halfling alive, after he feigned surrender and attempted to cast a lightning spell; this spectacle was both highly motivating to our troops and demoralized the remnants of that halfling's squad into surrendering, so I shall be enhancing their digestive capabilities as well.  

For the most part, though, our research work is done.  All that's left to do is get a response from the Overseers as to whether to increase their birth rate or not (currently set very low as a precaution against future overpopulation), and improve the training we give freshly-created Ogres for runic magic, given that regular maintenance of their runes is necessary to keep them alive.  This is not to say we have idle staff, however!  Some of us have made a project for after the war ends - a modification to our experimental growth-tanks, rendering them capable of holding a person of Ogric biology indefinitely in a "sleeping" state where they do not age or starve.  We can install tanks filled with these "sleeping" Ogres stationed near bridges that may need regular maintenance, stashed in reserve armories, or any other place where you'd need a batch of dependable workers or guards, without having to incur all the other costs associated with keeping extra citizens around.
]], [[The Overseers were ecstatic about my ideas!  Our staff have been relocated to a more secure location, deep underground with several extensive tunnels leading in from different locations.  Although this means we can no longer leave to harvest herbs for our infusions, the increased budget the Overseers have given us does more than enough to compensate.  Many wounded are still brought to me through the tunnels, but now our goal is not simply to make them as strong and healthy as they were before, but far stronger and far healthier than they could've dreamed.  They are brought to us unconscious, with amnesia spells already applied to ensure they do not resist our experiments; although they are not told they will be test subjects before being brought here, we are sure they would consent to these experiments, if they knew how valuable they were to help the Conclave.  As such, although this process violates several oaths we have taken as healers, I ultimately do not see any moral problem with this, and nobody else at this facility has expressed any concerns to me.  After all, those who join the Conclave as soldiers have already volunteered to give their lives in service to the Overseers' enlightened rule, and this is surely a much more productive way to do so than dying to a Nargol sling-bullet.

With access to better components, we can make the same basic improvements to their strength as we could before, but the changes do not stop there!  With so many subjects to work with, and the Overseers' encouragement to take risks, we've made them much larger (with associated multiplying effects on their effectiveness in combat), and reinforced their constitution to be capable of bearing more inscriptions without collapsing under the stress.  A fellow researcher had the brilliant idea to use this runic affinity to both enhance their connection to magic's weave, and make them biologically and structurally dependent on it; now, our front-line soldiers can conjure devastating fireballs with little training, and should those hairy-footed vermin attempt to raise one of these soldiers from the dead, they will collapse, having lost the magic that kept them intact when they still lived.  

The Overseers have been working with us personally to make psychological changes as well; with the blank slate provided by the amnesia spell, we've managed to give them a mindset that will serve them well both during the war and for our glorious reign that shall follow.  Extraordinarily dutiful, helpful and striving for excellence in their daily lives without lusting for power or personal glory, wise about their place in the world, and slow to anger...  but utterly ferocious when needed.  Just as the Higher were created to be scholars and policy-makers, and have proven successful in this role beyond the Conclave's wildest dreams, these new "Ogres" (as the staff has taken to nicknaming them) shall be our laborers and soldiers, a solid foundation of hard work and dutiful enforcement on which our society shall be built.  There will still be a place for the unaltered races, of course; their natural adaptability will make them perfect to fill in the gaps, as the glue that holds everything else together.

These Ogres are integrating into our military very well!  The rank-and-file soldiers know better than to attract attention from the Overseers by asking too many questions about where their new, giant allies came from, and thus acceptance came rather swiftly once they saw these creations in action.  We received one report that an Ogre sergeant was seen eating a particularly insolent halfling alive, after he feigned surrender and attempted to cast a lightning spell; this spectacle was both highly motivating to our troops and demoralized the remnants of that halfling's squad into surrendering, so I shall be enhancing their digestive capabilities as well.  

For the most part, though, our research work is done.  All that's left to do is get a response from the Overseers as to whether to increase their birth rate or not (currently set very low as a precaution against future overpopulation), and improve the training we give freshly-created Ogres for runic magic, given that regular maintenance of their runes is necessary to keep them alive.  This is not to say we have idle staff, however!  Some of us have made a project for after the war ends - a modification to our experimental growth-tanks, rendering them capable of holding a person of Ogric biology indefinitely in a "sleeping" state where they do not age or starve.  We can install tanks filled with these "sleeping" Ogres stationed near bridges that may need regular maintenance, stashed in reserve armories, or any other place where you'd need a batch of dependable workers or guards, without having to incur all the other costs associated with keeping extra citizens around.
]], "_t")
t("healer Astelrid log 4", "healer Astelrid log 4", "_t")
t([[Announcement to All Staff:

I'm sure you've all heard the rumors about what our scryers saw, and why we've been on lockdown the past few days; it is with a heavy heart that I must confirm that they are true.  The Nargol have taken the land above our facility, and are combing the area with golems to find the entrances.  We've already lost one entrance to the failsafe explosive-rune traps set in place to collapse it, and now they'll be looking to defuse those as well.  In short, we have no means of escape, and if allowed the time, they will find the way in, kill us, and steal our precious work for themselves.  The Empire has been enough of a problem without Ogres; we CANNOT take the risk of them finding us and tipping the balance in their favor.

We are doomed, no matter what happens.  My orders from the Overseers in such a situation would be to destroy our findings, then put an alchemical vial they gave me in the ventilation system, painlessly suffocating us.  I have no intention of throwing away our rightfully-earned place in the history books by doing this.  Instead, I have prematurely detonated all the remaining explosive traps, thoroughly sealing the way in.  We are very, very deep underground, and without any tunnels to follow, it could be decades before a Nargol excavation team reached us.  In other words, we are completely sealed off from the Nargol...  and the rest of the Conclave.

We have a small supply of emergency rations, but it would last us a couple of months at the longest, and we cannot assume the Conclave will reclaim this territory in that time.  We could try to repurpose the infusion herb-garden for making edible crops, but that would only buy us a month after that before the grow-lights lost their magic.  Without drastic steps, we will surely die of starvation; fortunately, we have drastic steps available to us.

This is my last order: I have prepared our surgical golems to apply the Ogric inscriptions to us, and updated all of our records to reflect our best current knowledge of their effects and effectiveness.  I have also had the golems upgrade all of our growth vats (ones in use included) to our newest "stasis tank" design, and furthermore freed up enough space for each of us to use one by...  disposing of some of the test subjects who had low chances of survival (an action I am already beginning to regret).  By the time you find this note, I will have already undergone this process myself, and will be hibernating in a tank I've had moved to my office.  If you do not wish to die, you should acquire a weapon from the armory, then follow my lead.  When we are dormant, we will be immune to the ravages of time, and prepared to greet whoever finally digs their way down and finds us.  Hopefully, it will be Conclave reinforcements, in which case we will stand down, give them our notes, and await further orders.  And if it isn't the Conclave...  make them regret it.  Send a message stronger than any NO TRESPASSING sign ever could, then resume your slumber.

It has been an honor working with such talented individuals, and an honor doing everything I can for a noble cause.  Perhaps we still had some progress to make, but overall I'm proud of what we've accomplished, and the contributions the Ogre race will make to all of Maj'Eyal.  

Long live the Conclave!
Healer Astelrid]], [[Announcement to All Staff:

I'm sure you've all heard the rumors about what our scryers saw, and why we've been on lockdown the past few days; it is with a heavy heart that I must confirm that they are true.  The Nargol have taken the land above our facility, and are combing the area with golems to find the entrances.  We've already lost one entrance to the failsafe explosive-rune traps set in place to collapse it, and now they'll be looking to defuse those as well.  In short, we have no means of escape, and if allowed the time, they will find the way in, kill us, and steal our precious work for themselves.  The Empire has been enough of a problem without Ogres; we CANNOT take the risk of them finding us and tipping the balance in their favor.

We are doomed, no matter what happens.  My orders from the Overseers in such a situation would be to destroy our findings, then put an alchemical vial they gave me in the ventilation system, painlessly suffocating us.  I have no intention of throwing away our rightfully-earned place in the history books by doing this.  Instead, I have prematurely detonated all the remaining explosive traps, thoroughly sealing the way in.  We are very, very deep underground, and without any tunnels to follow, it could be decades before a Nargol excavation team reached us.  In other words, we are completely sealed off from the Nargol...  and the rest of the Conclave.

We have a small supply of emergency rations, but it would last us a couple of months at the longest, and we cannot assume the Conclave will reclaim this territory in that time.  We could try to repurpose the infusion herb-garden for making edible crops, but that would only buy us a month after that before the grow-lights lost their magic.  Without drastic steps, we will surely die of starvation; fortunately, we have drastic steps available to us.

This is my last order: I have prepared our surgical golems to apply the Ogric inscriptions to us, and updated all of our records to reflect our best current knowledge of their effects and effectiveness.  I have also had the golems upgrade all of our growth vats (ones in use included) to our newest "stasis tank" design, and furthermore freed up enough space for each of us to use one by...  disposing of some of the test subjects who had low chances of survival (an action I am already beginning to regret).  By the time you find this note, I will have already undergone this process myself, and will be hibernating in a tank I've had moved to my office.  If you do not wish to die, you should acquire a weapon from the armory, then follow my lead.  When we are dormant, we will be immune to the ravages of time, and prepared to greet whoever finally digs their way down and finds us.  Hopefully, it will be Conclave reinforcements, in which case we will stand down, give them our notes, and await further orders.  And if it isn't the Conclave...  make them regret it.  Send a message stronger than any NO TRESPASSING sign ever could, then resume your slumber.

It has been an honor working with such talented individuals, and an honor doing everything I can for a noble cause.  Perhaps we still had some progress to make, but overall I'm proud of what we've accomplished, and the contributions the Ogre race will make to all of Maj'Eyal.  

Long live the Conclave!
Healer Astelrid]], "_t")
t("age of allure", "age of allure", "newLore category")
t([[FROM: Investigator Churrack
TO: Whoever holds the position of High Overseer of Loyalty when we're let out

Though I'm trapped in here with these healers, I haven't stopped prying to determine if their loyalties lie with us or with themselves. This case has more layers than a damn onion; while Astelrid did disobey a direct order (and several more by revealing the existence of that order), her alternative seems to fit our goals nonetheless. Response from staff has been mixed.  While most are reluctantly going along with her plan for lack of other options, some seem to follow her lead enthusiastically, and have been singing this song as they wait in line for their treatment:

#{italic}#Some Nargol once told me their Empire's gonna roll me
We ain't as strong as all their undead
They looked kind of silly with giant feet so furry
And an ogre's club smashing their foreheads

Well, the Empire's coming and they won't stop coming
So you'd better be ready to hit the ground running
Didn't make sense to kill everyone
Praise the Overseers, but that plan was dumb

So much to do, so much to see
So what's wrong with waiting in stasis?
We'll never know if we don't try
We'll never shine if we just die

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

It's a safe place, even as it gets older
'cause this war's not over until we say it's ogre
But the golems outside beg to differ
Judging by the sights in the scrying-orb's picture

The ground we're under was getting pretty thin
Their scouts are onto us, and they've got us all pinned
We blew the tunnels - no way out,
until the Conclave finds us, give trespassers a rout!

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

Somebody once asked if we'd finished, but alas
While I'm proud of what we've done in this place
We weren't done yet with this project,
but we're close enough where this isn't neglect
Eyal will appreciate our new race!

Well, the years'll start coming and they won't stop coming
So you'd better be ready to hit the ground running
Didn't make sense to kill everyone
Praise the Overseers, but that plan was dumb

So much to do, so much to see
So what's wrong with waiting in stasis?
We'll never know if we don't try
We'll never shine if we just die

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

They won't work on normal humans
But we won't age sleeping in these ruins#{normal}#

...Everyone reacts to grief differently, I guess. #{bold}#-Churrack#{normal}#]], [[FROM: Investigator Churrack
TO: Whoever holds the position of High Overseer of Loyalty when we're let out

Though I'm trapped in here with these healers, I haven't stopped prying to determine if their loyalties lie with us or with themselves. This case has more layers than a damn onion; while Astelrid did disobey a direct order (and several more by revealing the existence of that order), her alternative seems to fit our goals nonetheless. Response from staff has been mixed.  While most are reluctantly going along with her plan for lack of other options, some seem to follow her lead enthusiastically, and have been singing this song as they wait in line for their treatment:

#{italic}#Some Nargol once told me their Empire's gonna roll me
We ain't as strong as all their undead
They looked kind of silly with giant feet so furry
And an ogre's club smashing their foreheads

Well, the Empire's coming and they won't stop coming
So you'd better be ready to hit the ground running
Didn't make sense to kill everyone
Praise the Overseers, but that plan was dumb

So much to do, so much to see
So what's wrong with waiting in stasis?
We'll never know if we don't try
We'll never shine if we just die

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

It's a safe place, even as it gets older
'cause this war's not over until we say it's ogre
But the golems outside beg to differ
Judging by the sights in the scrying-orb's picture

The ground we're under was getting pretty thin
Their scouts are onto us, and they've got us all pinned
We blew the tunnels - no way out,
until the Conclave finds us, give trespassers a rout!

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

Somebody once asked if we'd finished, but alas
While I'm proud of what we've done in this place
We weren't done yet with this project,
but we're close enough where this isn't neglect
Eyal will appreciate our new race!

Well, the years'll start coming and they won't stop coming
So you'd better be ready to hit the ground running
Didn't make sense to kill everyone
Praise the Overseers, but that plan was dumb

So much to do, so much to see
So what's wrong with waiting in stasis?
We'll never know if we don't try
We'll never shine if we just die

Hey, now, you're a healer, get ogrified, go wait
Hey, now, you're a guard now, stand vigil in the tanks
They won't work on normal humans
But we won't age sleeping in these ruins

They won't work on normal humans
But we won't age sleeping in these ruins#{normal}#

...Everyone reacts to grief differently, I guess. #{bold}#-Churrack#{normal}#]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/ardhungol.lua"
-- 9 entries
t("Rashim Journal (1)", "Rashim Journal (1)", "_t")
t([[#{bold}#Journal Entry I#{normal}#

It's been some time since High Sun Paladin Aeryn sent me out on an assignment. According to recent intelligence, it would seem that a cavern has mysteriously emerged near our outpost, the Gates of Morning. They have bestowed the name "Ardhungol" on the newly discovered cavern. The elder warriors seem anxious in regards to the origin of this new subterranean area; they're likely concerned that the orcs are using Ardhungol as a staging point for further aggression against the Gates of Morning. I'll have to make sure I'm well equipped for this journey; the fate of us all could hang in the balance.

#{bold}#Journal Entry II#{normal}#

I spoke with the border patrols tonight. There seem to have been several sightings of orcs and other wild beasts roaming throughout the wilderness, yet strangely enough, none seem to have been anywhere near Ardhungol. Perhaps the subterranean cavern was simply a natural phenomenon with unfortunate timing. It's either that, or an unknown force powerful enough to alter the very foundation of the land upon its arrival. I shudder at the latter thought, but for now this is all merely speculation. If all goes well, I'll be ready to depart by dawn.
]], [[#{bold}#Journal Entry I#{normal}#

It's been some time since High Sun Paladin Aeryn sent me out on an assignment. According to recent intelligence, it would seem that a cavern has mysteriously emerged near our outpost, the Gates of Morning. They have bestowed the name "Ardhungol" on the newly discovered cavern. The elder warriors seem anxious in regards to the origin of this new subterranean area; they're likely concerned that the orcs are using Ardhungol as a staging point for further aggression against the Gates of Morning. I'll have to make sure I'm well equipped for this journey; the fate of us all could hang in the balance.

#{bold}#Journal Entry II#{normal}#

I spoke with the border patrols tonight. There seem to have been several sightings of orcs and other wild beasts roaming throughout the wilderness, yet strangely enough, none seem to have been anywhere near Ardhungol. Perhaps the subterranean cavern was simply a natural phenomenon with unfortunate timing. It's either that, or an unknown force powerful enough to alter the very foundation of the land upon its arrival. I shudder at the latter thought, but for now this is all merely speculation. If all goes well, I'll be ready to depart by dawn.
]], "_t")
t("Rashim Journal (2)", "Rashim Journal (2)", "_t")
t([[#{bold}#Journal Entry III#{normal}#

It was a half days journey from the Gates of Morning to Ardhungol, but I've finally arrived. I've decided to rest beneath the shade of a great oak tree and enjoy one of the sweet rolls my wife Melnela prepared for me. I'm unsure why, but the closer I've come to Ardhungol, the thicker the atmosphere has become, almost as if there is a foreign energy infecting the very air I breathe. I've been to many places in this vast world, but I've never felt an aura quite like this; I will have to uncover the source of this energy before I can bring a full report back to Aeryn.

#{bold}#Journal Entry IV#{normal}#

A thick green veil of mist permeates the air within this cavern; I'm uncertain if this is a byproduct of whatever creatures now inhabit this place, or if it's coming directly from another source. There also seem to be arcane rifts appearing in different locations throughout the cavern, though I dare not approach them; I will leave them for our anorithils to assess after I have secured the area. I must admit, I'm not looking forward to encountering the origin of a threat this grave, yet it is my sworn duty as a Sun Paladin to face what lies ahead; even should it be my own doom.

#{bold}#Journal Entry V#{normal}#

Impossible; how could spiders have grown to such an immense size? Not only that, but the markings and physical traits are unlike any arachnid I have previously encountered. The first one I encountered nearly took my left arm during its initial assault, if my reflexes had been a split second slower, I fear the worst may have transpired. If the Gates of Morning are assaulted by not only the orcs, but also this new –found species of arachnids, I fear all hope will be lost. For the sake of all Eyal, I must venture further into this spider infested cavern and destroy the source of this incursion.
]], [[#{bold}#Journal Entry III#{normal}#

It was a half days journey from the Gates of Morning to Ardhungol, but I've finally arrived. I've decided to rest beneath the shade of a great oak tree and enjoy one of the sweet rolls my wife Melnela prepared for me. I'm unsure why, but the closer I've come to Ardhungol, the thicker the atmosphere has become, almost as if there is a foreign energy infecting the very air I breathe. I've been to many places in this vast world, but I've never felt an aura quite like this; I will have to uncover the source of this energy before I can bring a full report back to Aeryn.

#{bold}#Journal Entry IV#{normal}#

A thick green veil of mist permeates the air within this cavern; I'm uncertain if this is a byproduct of whatever creatures now inhabit this place, or if it's coming directly from another source. There also seem to be arcane rifts appearing in different locations throughout the cavern, though I dare not approach them; I will leave them for our anorithils to assess after I have secured the area. I must admit, I'm not looking forward to encountering the origin of a threat this grave, yet it is my sworn duty as a Sun Paladin to face what lies ahead; even should it be my own doom.

#{bold}#Journal Entry V#{normal}#

Impossible; how could spiders have grown to such an immense size? Not only that, but the markings and physical traits are unlike any arachnid I have previously encountered. The first one I encountered nearly took my left arm during its initial assault, if my reflexes had been a split second slower, I fear the worst may have transpired. If the Gates of Morning are assaulted by not only the orcs, but also this new –found species of arachnids, I fear all hope will be lost. For the sake of all Eyal, I must venture further into this spider infested cavern and destroy the source of this incursion.
]], "_t")
t("Rashim Journal (3)", "Rashim Journal (3)", "_t")
t([[#{bold}#Journal Entry VI#{normal}#

It took some time, but my muscles have started to adapt and react to the unique movements of these arachnid. The way they fight, it's almost as if they possess a higher level of thought, elevating them far beyond the base intelligence of lesser arachnid... is it possible that they could be sentient? Do they act individually, or are they perhaps manipulated by a greater arachnid? Let us pray that this species is not connected through a hive mind, for this threat could become even greater than I had imagined.

#{bold}#Journal Entry VII#{normal}#

I have slain dozens of these arachnids, each one seemingly more difficult than the last. I am unsure if this is a result of my weariness, or if they are also adapting to my movements and battle techniques. I don't see how that could be possible however, a mere spider couldn't possibly adapt to the battle techniques of a veteran Sun Paladin, it's simply not feasible. Furthermore, the origin of these spiders worries me. So far I have not found any other entrances to this cavern, meaning they were transported here via other means. Those arcane rifts I found earlier are starting to worry me, and I fear for us all when I think of what may be waiting for us beyond them. I must put these thoughts out of my mind; distractions will only serve to weaken my resolve.

#{bold}#Journal Entry VIII#{normal}#

Incredible, the size of that arachnid is unimaginable; there is no doubt about it, that spider is the matriarch here. I am heavily wounded, but there is no turning back now; I must finish what I started for the sake of all those awaiting my return. If I don't make it back, whoever is now reading this journal, please make High Sun Paladin Aeryn at the Gates of Morning aware of the grave situation... and tell Melnela that I'm sorry.]], [[#{bold}#Journal Entry VI#{normal}#

It took some time, but my muscles have started to adapt and react to the unique movements of these arachnid. The way they fight, it's almost as if they possess a higher level of thought, elevating them far beyond the base intelligence of lesser arachnid... is it possible that they could be sentient? Do they act individually, or are they perhaps manipulated by a greater arachnid? Let us pray that this species is not connected through a hive mind, for this threat could become even greater than I had imagined.

#{bold}#Journal Entry VII#{normal}#

I have slain dozens of these arachnids, each one seemingly more difficult than the last. I am unsure if this is a result of my weariness, or if they are also adapting to my movements and battle techniques. I don't see how that could be possible however, a mere spider couldn't possibly adapt to the battle techniques of a veteran Sun Paladin, it's simply not feasible. Furthermore, the origin of these spiders worries me. So far I have not found any other entrances to this cavern, meaning they were transported here via other means. Those arcane rifts I found earlier are starting to worry me, and I fear for us all when I think of what may be waiting for us beyond them. I must put these thoughts out of my mind; distractions will only serve to weaken my resolve.

#{bold}#Journal Entry VIII#{normal}#

Incredible, the size of that arachnid is unimaginable; there is no doubt about it, that spider is the matriarch here. I am heavily wounded, but there is no turning back now; I must finish what I started for the sake of all those awaiting my return. If I don't make it back, whoever is now reading this journal, please make High Sun Paladin Aeryn at the Gates of Morning aware of the grave situation... and tell Melnela that I'm sorry.]], "_t")
t("ardhungol", "ardhungol", "newLore category")
t([[#{italic}#A few tattered scraps of paper lie on the ground, ruined from your fight with the creature carrying it.  It's almost completely illegible, but you can piece some of it together to read:#{normal}#
"...pheromone signals effective on much Eyalite wildlife ineffective on species 'sun paladin.'  at current planetary core cooling rates, passive study would lead to great loss - next step of emigration program should be cleaning of local 'sun paladin' nest and establishment of..."]], [[#{italic}#A few tattered scraps of paper lie on the ground, ruined from your fight with the creature carrying it.  It's almost completely illegible, but you can piece some of it together to read:#{normal}#
"...pheromone signals effective on much Eyalite wildlife ineffective on species 'sun paladin.'  at current planetary core cooling rates, passive study would lead to great loss - next step of emigration program should be cleaning of local 'sun paladin' nest and establishment of..."]], "_t")
t("#{italic}#This pile of tattered paper could theoretically be assembled into something legible, but without more text to draw back on, it'd still be in a language you could never interpret.  If only you had more Spydric text to help translate this...#{normal}#", "#{italic}#This pile of tattered paper could theoretically be assembled into something legible, but without more text to draw back on, it'd still be in a language you could never interpret.  If only you had more Spydric text to help translate this...#{normal}#", "_t")


------------------------------------------------
section "game/modules/tome/data/lore/arena.lua"
-- 2 entries
t("arena", "arena", "newLore category")
t([[#{italic}#You find a note with some highlighted words...
#{bold}#SCORING IN THE ARENA

#{normal}#The rules of the arena are simple.
Every wave, the gates will open, releasing enemies. When the gates close, you will be given a bonus score.
The bonus will #YELLOW#decrease every turn #LAST#, but #YELLOW#enemies you kill at this point#LAST#, will
raise your bonus. When you defeat all enemies, you will be granted your bonus score, multiplied by
your bonus multiplier.

Every few rounds, a miniboss round will come. After two miniboss rounds, one out of four bosses will appear.
#YELLOW#Kill enemies before the gates close #LAST#to raise your score multiplier!.
#YELLOW#Kill several enemies at once or very strong enemies #LAST#to please the audience and increase your rank!.
#YELLOW#Collect gold #LAST#to increase your score and resources at the end of each round.
#YELLOW#Kill enemies fast to get better scores!
#YELLOW#Take advantage of the trap at the center of the arena!
Good luck!
]], [[#{italic}#You find a note with some highlighted words...
#{bold}#SCORING IN THE ARENA

#{normal}#The rules of the arena are simple.
Every wave, the gates will open, releasing enemies. When the gates close, you will be given a bonus score.
The bonus will #YELLOW#decrease every turn #LAST#, but #YELLOW#enemies you kill at this point#LAST#, will
raise your bonus. When you defeat all enemies, you will be granted your bonus score, multiplied by
your bonus multiplier.

Every few rounds, a miniboss round will come. After two miniboss rounds, one out of four bosses will appear.
#YELLOW#Kill enemies before the gates close #LAST#to raise your score multiplier!.
#YELLOW#Kill several enemies at once or very strong enemies #LAST#to please the audience and increase your rank!.
#YELLOW#Collect gold #LAST#to increase your score and resources at the end of each round.
#YELLOW#Kill enemies fast to get better scores!
#YELLOW#Take advantage of the trap at the center of the arena!
Good luck!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/blighted-ruins.lua"
-- 6 entries
t("Work on my glorious project has been delayed. This displeases me. The fools from the nearby village are starting to suspect my presence, and have begun guarding their graveyards and cemeteries closely. Whatever meagre remains I can steal away are often too rotted or insubstantial to use for my project, so I have no choice but to use them as sub-par minions instead. Perhaps they will sow enough conflict and discord so that new, fresher remains will become available...", "Work on my glorious project has been delayed. This displeases me. The fools from the nearby village are starting to suspect my presence, and have begun guarding their graveyards and cemeteries closely. Whatever meagre remains I can steal away are often too rotted or insubstantial to use for my project, so I have no choice but to use them as sub-par minions instead. Perhaps they will sow enough conflict and discord so that new, fresher remains will become available...", "_t")
t("The cloak of deception is complete! Truly my finest work, not counting my project of course, it allows my minions to walk amongst the living without arousing their suspicions at all. Already I have taken a stroll to a nearby town alongside a ghoulish thrall, wrapped in the cloak... hah! The fools didn't even bat an eyelid! With this item, acquisition of components for my project shall be all the more simple.", "The cloak of deception is complete! Truly my finest work, not counting my project of course, it allows my minions to walk amongst the living without arousing their suspicions at all. Already I have taken a stroll to a nearby town alongside a ghoulish thrall, wrapped in the cloak... hah! The fools didn't even bat an eyelid! With this item, acquisition of components for my project shall be all the more simple.", "_t")
t("Fate smiles upon me. What did I come across today but the body of an unfortunate %s? Unfortunate indeed, but rather fortunate for me. The body displays next to no decomposition... it shall be perfect! With this new minion and the cloak of deception, the completion of my project is all but assured. I must prepare for the ritual... my dark menagerie shall soon have a new member.", "Fate smiles upon me. What did I come across today but the body of an unfortunate %s? Unfortunate indeed, but rather fortunate for me. The body displays next to no decomposition... it shall be perfect! With this new minion and the cloak of deception, the completion of my project is all but assured. I must prepare for the ritual... my dark menagerie shall soon have a new member.", "tformat")
t("blighted ruins", "blighted ruins", "newLore category")
t("note from the Necromancer", "note from the Necromancer", "_t")
t("My masterpiece walks! It is glorious, beautiful. While it remains unfinished, it is finished enough to serve in its purpose of protecting my lair. No would-be hero will be able to defeat it, and once it is complete it will be nigh invulnerable! Now all that remains is to animate my newest minion and bend it to my will... then they'll see. They'll ALL see. What can possibly stop me now, I ask? What?!", "My masterpiece walks! It is glorious, beautiful. While it remains unfinished, it is finished enough to serve in its purpose of protecting my lair. No would-be hero will be able to defeat it, and once it is complete it will be nigh invulnerable! Now all that remains is to animate my newest minion and bend it to my will... then they'll see. They'll ALL see. What can possibly stop me now, I ask? What?!", "_t")


------------------------------------------------
section "game/modules/tome/data/lore/daikara.lua"
-- 8 entries
t([[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Nothing but hatchlings so far. Honestly, if this keeps up we won't have enough dragonhide to cover a dragon, let alone cover our losses. I've really spared no expense this time as well: Gorran is one of the finest rangers I know, and Sodelost... his prices are exorbitant, but then what else would you expect from those money-grubbing dwarven Thronesmen? I must admit I don't know much about Xann. The locals say there's no finer wyrmic in the area, and I admit she is something special in combat. Now, if only she could turn her draconic talents to FINDING some dragons!]], [[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Nothing but hatchlings so far. Honestly, if this keeps up we won't have enough dragonhide to cover a dragon, let alone cover our losses. I've really spared no expense this time as well: Gorran is one of the finest rangers I know, and Sodelost... his prices are exorbitant, but then what else would you expect from those money-grubbing dwarven Thronesmen? I must admit I don't know much about Xann. The locals say there's no finer wyrmic in the area, and I admit she is something special in combat. Now, if only she could turn her draconic talents to FINDING some dragons!]], "_t")
t([[#{bold}#Sodelost, Dwarf Rogue#{normal}#
Can't believe I agreed to this expedition. I suppose it's because I've known Relle for a while. We've crossed paths many times at Derth's trading post. I even gave her a special rate for my services. Sentimental fool! All it's got me is boots filled with snow and a light coinpurse. I still don't understand why these Kingdom types are so enamoured with drakeskin... makes superior armour they say. Pah! If you can't handle metal armour, what business do you have even wearing armour? Leather has about as much use as a halfling tied to a... noises up ahead, must stop writing.]], [[#{bold}#Sodelost, Dwarf Rogue#{normal}#
Can't believe I agreed to this expedition. I suppose it's because I've known Relle for a while. We've crossed paths many times at Derth's trading post. I even gave her a special rate for my services. Sentimental fool! All it's got me is boots filled with snow and a light coinpurse. I still don't understand why these Kingdom types are so enamoured with drakeskin... makes superior armour they say. Pah! If you can't handle metal armour, what business do you have even wearing armour? Leather has about as much use as a halfling tied to a... noises up ahead, must stop writing.]], "_t")
t([[#{bold}#Gorran, Cornac Archer#{normal}#
That snake. That addlepated beardling. That coin-hounding, blackhearted, stump-kneed dwarf! A scout he calls himself! The finest eyes of the Iron Throne, able to read the sign of the tavern in Last Hope from the tavern in Derth! Surely someone with such grandiose praise for his own eyesight would have spotted that cold drake waiting in ambush for us! Damnable thing, I'll be lucky if I can ever use my left arm again. I can't use my bow now ... I'm effectively dead wood to the team. I'm beginning to think that Sodelost has ulterior motives... I wouldn't put it past a dwarf to lead us up this forsaken mountain to die just so he could rifle through our pockets! I keep telling Relle, but she won't listen. The fool...]], [[#{bold}#Gorran, Cornac Archer#{normal}#
That snake. That addlepated beardling. That coin-hounding, blackhearted, stump-kneed dwarf! A scout he calls himself! The finest eyes of the Iron Throne, able to read the sign of the tavern in Last Hope from the tavern in Derth! Surely someone with such grandiose praise for his own eyesight would have spotted that cold drake waiting in ambush for us! Damnable thing, I'll be lucky if I can ever use my left arm again. I can't use my bow now ... I'm effectively dead wood to the team. I'm beginning to think that Sodelost has ulterior motives... I wouldn't put it past a dwarf to lead us up this forsaken mountain to die just so he could rifle through our pockets! I keep telling Relle, but she won't listen. The fool...]], "_t")
t([[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Sodelost is dead, and so is Gorran. The former by Gorran's hand, the latter by my hand. Even in these wastes I cannot abide such an act of mutiny. I was aware of Gorran's anger ever since the drake attack, but I never dreamed he would turn on Sodelost like he did. He had taken my longsword as I slept the previous night, strode up to Sodelost, unheeding of I and Xann watching him, ran him through and laughed. Simply laughed. There was nothing for it; I wrenched my sword from his hand and brought it down on his neck. The commotion seems to have stirred up a nearby drake's nest, and now I fear we don't have the strength to repel a concentrated attack. We may have to abandon this expedition.]], [[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Sodelost is dead, and so is Gorran. The former by Gorran's hand, the latter by my hand. Even in these wastes I cannot abide such an act of mutiny. I was aware of Gorran's anger ever since the drake attack, but I never dreamed he would turn on Sodelost like he did. He had taken my longsword as I slept the previous night, strode up to Sodelost, unheeding of I and Xann watching him, ran him through and laughed. Simply laughed. There was nothing for it; I wrenched my sword from his hand and brought it down on his neck. The commotion seems to have stirred up a nearby drake's nest, and now I fear we don't have the strength to repel a concentrated attack. We may have to abandon this expedition.]], "_t")
t("expedition journal entry (daikara)", "expedition journal entry (daikara)", "_t")
t([[#{bold}#Xann, Shaloren Wyrmic#{normal}# (This entry was scrawled by an unsteady hand)
#{italic}#impudent fools treading upon dragon's ground. slaying my dear kin just for their skin they will pay they will pay. i called the drake, told it to be cunning, avoid the dwarf's gaze. i laughed as it bit into that ranger's arm ahaahaa. they're killing each other now, simple creatures, simple soft skinned creatures. not like dragons, so perfect, symbols of power, perfection... their captain still lives, but not for long. i will bring her to you to feast.

rantha i will see you soon#{normal}#]], [[#{bold}#Xann, Shaloren Wyrmic#{normal}# (This entry was scrawled by an unsteady hand)
#{italic}#impudent fools treading upon dragon's ground. slaying my dear kin just for their skin they will pay they will pay. i called the drake, told it to be cunning, avoid the dwarf's gaze. i laughed as it bit into that ranger's arm ahaahaa. they're killing each other now, simple creatures, simple soft skinned creatures. not like dragons, so perfect, symbols of power, perfection... their captain still lives, but not for long. i will bring her to you to feast.

rantha i will see you soon#{normal}#]], "_t")
t([[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being charred to a crisp" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of dragonsfire. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]], [[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being charred to a crisp" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of dragonsfire. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]], "_t")
t([[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being frozen solid" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of ice. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]], [[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being frozen solid" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of ice. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/dreadfell.lua"
-- 21 entries
t([[MINIONS: Perhaps you feel your Master has been lax or absent? Well, I shall amend that. I have been studying an object of great import. It is of much greater interest than your foolish unlives. But do not think that I will let you get away with things because of this.

Skeletons, you have been getting noticeably behind in your adventurer slaughtering quotas. The next skeleton archer I see drinking coffee and chatting with the wights shall be rent limb from limb and fed to the orcs. Also, as a punishment for your general laxness, 1,000 skeletons shall be remanded down to Kor'Pul as punishment. A further 250 shall be slaughtered. These orders to be carried out by myself tomorrow at 3am.]], [[MINIONS: Perhaps you feel your Master has been lax or absent? Well, I shall amend that. I have been studying an object of great import. It is of much greater interest than your foolish unlives. But do not think that I will let you get away with things because of this.

Skeletons, you have been getting noticeably behind in your adventurer slaughtering quotas. The next skeleton archer I see drinking coffee and chatting with the wights shall be rent limb from limb and fed to the orcs. Also, as a punishment for your general laxness, 1,000 skeletons shall be remanded down to Kor'Pul as punishment. A further 250 shall be slaughtered. These orders to be carried out by myself tomorrow at 3am.]], "_t")
t([[MINIONS: Be aware, I your great Master have found an item. It is of extreme power, but not yet complete, at least for my purposes.

All hail your brilliant Master. Would you like to walk in the sun? Would you like to be free to roam green meadows and crush innocent children? Such are my wishes also. The reward to anyone who brings me any item that will help me bend this sta... item to my will shall be stupendous.

Also, any new minions who have magical research skills are wanted. Recruit them and you shall be rewarded. Though if they steal my secrets, your blood will be my wine and your heart my appetizer.]], [[MINIONS: Be aware, I your great Master have found an item. It is of extreme power, but not yet complete, at least for my purposes.

All hail your brilliant Master. Would you like to walk in the sun? Would you like to be free to roam green meadows and crush innocent children? Such are my wishes also. The reward to anyone who brings me any item that will help me bend this sta... item to my will shall be stupendous.

Also, any new minions who have magical research skills are wanted. Recruit them and you shall be rewarded. Though if they steal my secrets, your blood will be my wine and your heart my appetizer.]], "_t")
t([[MINIONS: Perhaps you are minor dens of foulness because you have nothing to aspire to? Perhaps you could be greater if you had a worse example before you? Consider Me! I began my long unlife as a foolish pipsqueak such as yourself. Why, there was a time before I had conquered even a pit let alone a level or a dungeon. Now, behold all that is Mine.

You must have aspirations. I am not content with just the rule of Dreadfell. No, soon I shall have more. Much more. My boots shall tread the surface of the earth! I shall explore and destroy the most beautiful mountains. All shall be mine once I can walk in the sun once more. Where will you be? Do you wish to be more than the wight I stepped on yesterday? I shall need great leaders to guide my armies across the land.]], [[MINIONS: Perhaps you are minor dens of foulness because you have nothing to aspire to? Perhaps you could be greater if you had a worse example before you? Consider Me! I began my long unlife as a foolish pipsqueak such as yourself. Why, there was a time before I had conquered even a pit let alone a level or a dungeon. Now, behold all that is Mine.

You must have aspirations. I am not content with just the rule of Dreadfell. No, soon I shall have more. Much more. My boots shall tread the surface of the earth! I shall explore and destroy the most beautiful mountains. All shall be mine once I can walk in the sun once more. Where will you be? Do you wish to be more than the wight I stepped on yesterday? I shall need great leaders to guide my armies across the land.]], "_t")
t([[MINIONS: You are foolish sods. Have you heard of the great Kor'Pul? Perhaps not, because you know very little and he died long before you were so stupid as to be born. However, he was great and had the chance to be greater still. He let himself be cooped into a small hellhole and was destroyed when the right hero invaded it and destroyed his plaything. Now he is but a mere shade of his former glory.

I shall not make this mistake. Be ready, for soon we shall march out upon the lands. Soon we shall conquer as even he could not. Pity the fool who thinks he can keep me stuck in even the grandest of pits, Dreadfell.]], [[MINIONS: You are foolish sods. Have you heard of the great Kor'Pul? Perhaps not, because you know very little and he died long before you were so stupid as to be born. However, he was great and had the chance to be greater still. He let himself be cooped into a small hellhole and was destroyed when the right hero invaded it and destroyed his plaything. Now he is but a mere shade of his former glory.

I shall not make this mistake. Be ready, for soon we shall march out upon the lands. Soon we shall conquer as even he could not. Pity the fool who thinks he can keep me stuck in even the grandest of pits, Dreadfell.]], "_t")
t("note from the Master", "note from the Master", "_t")
t([[MINIONS: To my newest vampire: burn, foolish adventurer, burn! I bet you are sorry for that flame spell now, aren't you? Suffer as I revisit it upon you.

To the rest of you, there will be punishment. An adventurer got down to my bedroom and surprised me. I, Myself, was hurt and almost had to use My special power. All is well now and I am as dangerous as ever, but you shall suffer for letting him get so low. The next minion I see shall be toasted with my marshmallows. Where then were the special pits of doom I organized? Where were the poisons of my wights or the diseases of my ghouls? Indeed, I should slaughter all of you, and I would, but those who were most foully remiss were already slaughtered by the adventurer. The rest of you? Beware My wrath.]], [[MINIONS: To my newest vampire: burn, foolish adventurer, burn! I bet you are sorry for that flame spell now, aren't you? Suffer as I revisit it upon you.

To the rest of you, there will be punishment. An adventurer got down to my bedroom and surprised me. I, Myself, was hurt and almost had to use My special power. All is well now and I am as dangerous as ever, but you shall suffer for letting him get so low. The next minion I see shall be toasted with my marshmallows. Where then were the special pits of doom I organized? Where were the poisons of my wights or the diseases of my ghouls? Indeed, I should slaughter all of you, and I would, but those who were most foully remiss were already slaughtered by the adventurer. The rest of you? Beware My wrath.]], "_t")
t([[Master of life, Master of death,
All fall to a word
From his dreaded breath!

Master of staff, Master of steel,
None can withstand
His ruthless zeal!

Master of magic, Master of fire,
Pity the fool
That stirs his great ire!

Master of strength, Master of will,
Dare not oppose him
Or your blood will spill!

Master of shadows beyond mortal thought,
Against undying death all are as naught.]], [[Master of life, Master of death,
All fall to a word
From his dreaded breath!

Master of staff, Master of steel,
None can withstand
His ruthless zeal!

Master of magic, Master of fire,
Pity the fool
That stirs his great ire!

Master of strength, Master of will,
Dare not oppose him
Or your blood will spill!

Master of shadows beyond mortal thought,
Against undying death all are as naught.]], "_t")
t([[Me like Master,
He's a real laster,
He is faster
than a caster,
Can bring disaster,
Need more'n a plaster
After his attackaster...

Alabaster... raster... pastor? Grr, need more brains...]], [[Me like Master,
He's a real laster,
He is faster
than a caster,
Can bring disaster,
Need more'n a plaster
After his attackaster...

Alabaster... raster... pastor? Grr, need more brains...]], "_t")
t([[No staff will save thee
Against the blindness of pride
Death will catch thee up]], [[No staff will save thee
Against the blindness of pride
Death will catch thee up]], "_t")
t("a note about undead poetry from the Master", "a note about undead poetry from the Master", "_t")
t("As an aside, I notice one of my skeletons has amused himself by writing a poem about me. Whilst my first reaction was to have his bones crunched into dust and what remained of his undead soul sent to the darkest depths of the abyss, I do now realise that there is some merit to this. Every great leader needs tales penned of his brilliant conquest. Therefore I now command you all to write more poetry in my honour, praising my amazing powers, unrivalled leadership, unconquerable strength, etc etc. Any that fail to produce works of sufficient standard shall be annihilated.", "As an aside, I notice one of my skeletons has amused himself by writing a poem about me. Whilst my first reaction was to have his bones crunched into dust and what remained of his undead soul sent to the darkest depths of the abyss, I do now realise that there is some merit to this. Every great leader needs tales penned of his brilliant conquest. Therefore I now command you all to write more poetry in my honour, praising my amazing powers, unrivalled leadership, unconquerable strength, etc etc. Any that fail to produce works of sufficient standard shall be annihilated.", "_t")
t("slain master", "slain master", "_t")
t("A powerful staff is grabbed from the Master's dead hands.", "A powerful staff is grabbed from the Master's dead hands.", "_t")
t("a letter to Borfast from the Master", "a letter to Borfast from the Master", "_t")
t([[Ah, my dear Borfast, welcome to your glorious undeath! Your armour a cage, your hopes despair, your axe enslaved to my will, your soul mine to feast upon. How does it feel? Rather lovely I like to imagine! You were a valiant opponent, and though you were little threat to me I do like to honour you with this special treatment. And you do like honour, don't you? I know you wished to honour your people by defeating me and destroying my tower, but I'm sure you realise now that it was a rather vain endeavour.

I apologise for what happened to that lovely suit of plate. I know it got a little... worn... during the treatment. But I'm afraid I really did need to find out the locations of your companion, and certain pressures had to be applied. You weren't very talkative, now were you? But I soon made you sing, oh yes. Of course, I could have just used a little divination magic to find out what I wanted, but I do so enjoy a good torture... And my, how joyous your screams were whenever the acid splashed against your beard! Hoh, we did chortle, did we not? But no matter, I've had my best skeletal smiths work on fixing your armour, fit to be worn by my new champion.

I hope you enjoy your new work. Approach it with gusto, that sort of thing. I know in life you always dreamed of being a mighty hero of legend. But, well, what can be more glorious than this? You will live forever as my servant, destined to defend my throne for all time! You will be the envy of all the lesser ghouls that shamble about my halls. Well, until you get slain by some dumb intruding adventurer, of course... But that's the beauty of you heroes - one comes in, makes a mess, and then I get a new plaything to toy with. I wonder who shall replace you, eh?

Until then, do enjoy the work, try to keep the place clean, and remember - I own you forever.

- The Master]], [[Ah, my dear Borfast, welcome to your glorious undeath! Your armour a cage, your hopes despair, your axe enslaved to my will, your soul mine to feast upon. How does it feel? Rather lovely I like to imagine! You were a valiant opponent, and though you were little threat to me I do like to honour you with this special treatment. And you do like honour, don't you? I know you wished to honour your people by defeating me and destroying my tower, but I'm sure you realise now that it was a rather vain endeavour.

I apologise for what happened to that lovely suit of plate. I know it got a little... worn... during the treatment. But I'm afraid I really did need to find out the locations of your companion, and certain pressures had to be applied. You weren't very talkative, now were you? But I soon made you sing, oh yes. Of course, I could have just used a little divination magic to find out what I wanted, but I do so enjoy a good torture... And my, how joyous your screams were whenever the acid splashed against your beard! Hoh, we did chortle, did we not? But no matter, I've had my best skeletal smiths work on fixing your armour, fit to be worn by my new champion.

I hope you enjoy your new work. Approach it with gusto, that sort of thing. I know in life you always dreamed of being a mighty hero of legend. But, well, what can be more glorious than this? You will live forever as my servant, destined to defend my throne for all time! You will be the envy of all the lesser ghouls that shamble about my halls. Well, until you get slain by some dumb intruding adventurer, of course... But that's the beauty of you heroes - one comes in, makes a mess, and then I get a new plaything to toy with. I wonder who shall replace you, eh?

Until then, do enjoy the work, try to keep the place clean, and remember - I own you forever.

- The Master]], "_t")
t("a letter to Aletta from the Master", "a letter to Aletta from the Master", "_t")
t([[Ah, sweet Aletta! How rich your blood tasted on my lips! I know it's not quite what you were expecting from the next step in our relationship, but aren't surprises the true joy of any romance?

I don't blame you for falling for me, you know, even to the point of betraying all your companions just for me. Women have always had a weakness for my brooding personality and sparkling wit. Even in life I was quite the charmer, and death only improves things, I assure you. I really do have the reputation as a heartbreaker, in more ways than one... Your heart shall now sit in a special place, next to the rest of the offal in my pits.

Thank you for telling me of Borfast's weaknesses - it shall make overcoming the dwarven grunt all the simpler. Your rogue friend remains more elusive, but he will be found and destroyed. You see I have a sort of persistent bloody-mindedness about this sort of thing. There is not a cockroach in this tower that does not obey my every whim and will, and I shall see to it that it remains that way.

You must feel a little betrayed of course. I promised you power beyond your imaginings, and instead I drained your blood, fed your flesh to my servants, and enthralled your soul to my bidding. Well, we all struggle to manage expectations sometimes, eh? At least be glad I let your tortured essence roam the cold fastness of my fortress, haunting anyone foolish enough to invade. And some power I will impart to you, and it is indeed beyond your imaginings, for your mind could never reach the dark places I can. But open your eyes now, for such dark places shall be with you till the end of time... Welcome, indeed, to the dark place of my heart.

- The Master]], [[Ah, sweet Aletta! How rich your blood tasted on my lips! I know it's not quite what you were expecting from the next step in our relationship, but aren't surprises the true joy of any romance?

I don't blame you for falling for me, you know, even to the point of betraying all your companions just for me. Women have always had a weakness for my brooding personality and sparkling wit. Even in life I was quite the charmer, and death only improves things, I assure you. I really do have the reputation as a heartbreaker, in more ways than one... Your heart shall now sit in a special place, next to the rest of the offal in my pits.

Thank you for telling me of Borfast's weaknesses - it shall make overcoming the dwarven grunt all the simpler. Your rogue friend remains more elusive, but he will be found and destroyed. You see I have a sort of persistent bloody-mindedness about this sort of thing. There is not a cockroach in this tower that does not obey my every whim and will, and I shall see to it that it remains that way.

You must feel a little betrayed of course. I promised you power beyond your imaginings, and instead I drained your blood, fed your flesh to my servants, and enthralled your soul to my bidding. Well, we all struggle to manage expectations sometimes, eh? At least be glad I let your tortured essence roam the cold fastness of my fortress, haunting anyone foolish enough to invade. And some power I will impart to you, and it is indeed beyond your imaginings, for your mind could never reach the dark places I can. But open your eyes now, for such dark places shall be with you till the end of time... Welcome, indeed, to the dark place of my heart.

- The Master]], "_t")
t("dreadfell", "dreadfell", "newLore category")
t("a letter to Filio from the Master", "a letter to Filio from the Master", "_t")
t([[Oh Filio, what a fun game we have had of cat and mouse! Well, perhaps to you it was a life and death struggle, but for me this past three weeks of patiently hunting you through my halls has been the most entertaining of past-times. I have enjoyed extending the game so, letting you escape my clutches when I felt it most prudent, watching as you got ever more desperate. Alas, you have now degraded too much, and it was simply too embarrassing watching you eat your own faeces to survive. I had to put an end to it - I'm sure you understand.

But ah, it's not truly an end, for you get to experience the wonder of undead enslavement! Is it not most exciting? Do your bones not quiver with delight? It is just your bones now, since I have a certain fondness for skeletal servants, but I have been nice enough to pad your heels with leather so you can still sneak about quietly. How you did love to sneak! Now you may spend an eternity doing so, ensuring any future trespassers get quite the surprise wandering through my great keep.

I have let you keep your little sling, since I know you like to play with it. Such a quaint weapon... But this staff I found in your possession - my, what a treasure you have brought me! I do not know whence you stole this artifact, but you clearly were completely unaware of its value or power. It has a history beyond your very comprehension, and in my hands it shall change the future! Thank you kindly, my servant; already you have served your Master well. I'm sure we shall enjoy a great friendship over the many years to come. Well, not friendship exactly - it more involves eternal agony on your part, and a rise to ultimate power and majesty for me. Such is the fate of the weak and the strong, a lesson you have already learned well. What a great teacher I make...

- The Master]], [[Oh Filio, what a fun game we have had of cat and mouse! Well, perhaps to you it was a life and death struggle, but for me this past three weeks of patiently hunting you through my halls has been the most entertaining of past-times. I have enjoyed extending the game so, letting you escape my clutches when I felt it most prudent, watching as you got ever more desperate. Alas, you have now degraded too much, and it was simply too embarrassing watching you eat your own faeces to survive. I had to put an end to it - I'm sure you understand.

But ah, it's not truly an end, for you get to experience the wonder of undead enslavement! Is it not most exciting? Do your bones not quiver with delight? It is just your bones now, since I have a certain fondness for skeletal servants, but I have been nice enough to pad your heels with leather so you can still sneak about quietly. How you did love to sneak! Now you may spend an eternity doing so, ensuring any future trespassers get quite the surprise wandering through my great keep.

I have let you keep your little sling, since I know you like to play with it. Such a quaint weapon... But this staff I found in your possession - my, what a treasure you have brought me! I do not know whence you stole this artifact, but you clearly were completely unaware of its value or power. It has a history beyond your very comprehension, and in my hands it shall change the future! Thank you kindly, my servant; already you have served your Master well. I'm sure we shall enjoy a great friendship over the many years to come. Well, not friendship exactly - it more involves eternal agony on your part, and a rise to ultimate power and majesty for me. Such is the fate of the weak and the strong, a lesson you have already learned well. What a great teacher I make...

- The Master]], "_t")
t("#0080FF#On the back of the letter you can just make out a coarsely scrawled and badly faded diagram.#LAST#", "#0080FF#On the back of the letter you can just make out a coarsely scrawled and badly faded diagram.#LAST#", "log")


------------------------------------------------
section "game/modules/tome/data/lore/fun.lua"
-- 4 entries
t([[#{italic}#4. Necromancers Of Maj'Eyal#{normal}#

The greatest enemy of the necromancer is other necromancers. Well, apart from the Ziguranth, the Allied Kingdoms, the Shaloren, the Thaloren, the Iron Throne, common townsfolk, undead hunters, adventurers, rogue undead and Linaniil. But apart from them, the greatest enemy of the necromancer is other necromancers. Below is listed the location of many notable necromancers, areas possessing above-average undead activity, and other regions considered unfitting for our designs. Budding practitioners of our art are encouraged to perform their work away from these areas, lest they be recognized as threats or nuisances and are subsequently eradicated.

#{italic}#The Ruins Of Kor'Pul#{normal}#: While this necromancer of old may have perished, and his shade has long since lost any trace of sanity, his lair remains a nexus of dark energies, and his minions remain legion.

#{italic}#Blighted Ruins#{normal}#: An ambitious amateur has made his lair within these ruins, thought to be chasing dreams of raising an unstoppable army of the dead. His methods are known to be crude and prone to failure, and I fully expect to hear of him perishing at the hands of his own works within the year.

#{italic}#Dreadfell#{normal}#: Undead have been massing at this abandoned tower in unprecedented numbers. Obviously, a powerful figure has recently made it his home. Regardless, no clue has been given to the identity of this tower's supposed master.

#{italic}#Derth#{normal}#: While there is no formal necromancer presence in this sleepy countryside village, no practitioner of our art has been able to work within its vicinity. Rumours on why this is so are wild and varied, ranging from stories of almost all of its inhabitants being undead minions wearing cloaks of deception, to it being the secret base of the founder of the Tren? method of necromancy. Whatever reason there is, beware.

#{italic}#Zigur#{normal}#: The enemy of our enemy is not our friend in this case. What passes for "normal" magic is enough to send the cult residing here into a frothing, psychotic frenzy - the presence of a necromancer would be enough to instigate a second Age of Pyre!

No further aid awaits you, for we do not tolerate the dependent. All that remains is for you to prove yourself worthy of practising this glorious art...]], [[#{italic}#4. Necromancers Of Maj'Eyal#{normal}#

The greatest enemy of the necromancer is other necromancers. Well, apart from the Ziguranth, the Allied Kingdoms, the Shaloren, the Thaloren, the Iron Throne, common townsfolk, undead hunters, adventurers, rogue undead and Linaniil. But apart from them, the greatest enemy of the necromancer is other necromancers. Below is listed the location of many notable necromancers, areas possessing above-average undead activity, and other regions considered unfitting for our designs. Budding practitioners of our art are encouraged to perform their work away from these areas, lest they be recognized as threats or nuisances and are subsequently eradicated.

#{italic}#The Ruins Of Kor'Pul#{normal}#: While this necromancer of old may have perished, and his shade has long since lost any trace of sanity, his lair remains a nexus of dark energies, and his minions remain legion.

#{italic}#Blighted Ruins#{normal}#: An ambitious amateur has made his lair within these ruins, thought to be chasing dreams of raising an unstoppable army of the dead. His methods are known to be crude and prone to failure, and I fully expect to hear of him perishing at the hands of his own works within the year.

#{italic}#Dreadfell#{normal}#: Undead have been massing at this abandoned tower in unprecedented numbers. Obviously, a powerful figure has recently made it his home. Regardless, no clue has been given to the identity of this tower's supposed master.

#{italic}#Derth#{normal}#: While there is no formal necromancer presence in this sleepy countryside village, no practitioner of our art has been able to work within its vicinity. Rumours on why this is so are wild and varied, ranging from stories of almost all of its inhabitants being undead minions wearing cloaks of deception, to it being the secret base of the founder of the Tren? method of necromancy. Whatever reason there is, beware.

#{italic}#Zigur#{normal}#: The enemy of our enemy is not our friend in this case. What passes for "normal" magic is enough to send the cult residing here into a frothing, psychotic frenzy - the presence of a necromancer would be enough to instigate a second Age of Pyre!

No further aid awaits you, for we do not tolerate the dependent. All that remains is for you to prove yourself worthy of practising this glorious art...]], "_t")
t([[Some men have said that the feet of halflings can nay be harmed, not by fire, blade nor magic. And they do say that this is a truly astounding thing. And some men consider the foot of a halfling to be an item of great luck and protection, and many have one hung above their door or mantle. Though these days 'tis frowned upon to go hunt for one, so 'tis considered a prized heirloom to be passed from father to son.

But women do look upon men and declare them fools. "For how," say they, "Can the foot of a halfling be a lucky thing, when with their large uncomely feet they are not able to wear shoes and footwear of elegant crafts and beauteous materials? And especially 'tis a great misfortune unto them, as with their short stature they could really do with a decent pair of heels..."

And lo, 'tis little mystery why halflings do look upon humans and say "The Big Folk really are very dumb."]], [[Some men have said that the feet of halflings can nay be harmed, not by fire, blade nor magic. And they do say that this is a truly astounding thing. And some men consider the foot of a halfling to be an item of great luck and protection, and many have one hung above their door or mantle. Though these days 'tis frowned upon to go hunt for one, so 'tis considered a prized heirloom to be passed from father to son.

But women do look upon men and declare them fools. "For how," say they, "Can the foot of a halfling be a lucky thing, when with their large uncomely feet they are not able to wear shoes and footwear of elegant crafts and beauteous materials? And especially 'tis a great misfortune unto them, as with their short stature they could really do with a decent pair of heels..."

And lo, 'tis little mystery why halflings do look upon humans and say "The Big Folk really are very dumb."]], "_t")
t("Rogues do it from behind", "Rogues do it from behind", "_t")
t([[An archer from the northern lands
Claimed of his great renown
With peerless skill and countless trials
His name known town to town

He spoke of facing vampire lords
Who promised years of pain
The archer gave a stern retort
An arrow through the brain

A fighter from the southern lands
Claimed armies fled his might
With dragons slain 'most every day
And demons crushed by night

He spoke of ancient sprawling ruins
Home to a ghastly shade
Its years of madness, hate and rage
Were ended on his blade

An archmage from the western lands
Claimed kingdoms feared his name
With countless legends, songs and myths
Attesting to his fame

He spoke of fire, storm and hail
To match the fiercest wyrm
To see one man hold so much power
Can make an empire squirm

A rogue who came from unknown lands
Not known for anything
A leap, a flash, a concealed blade
Three heroes felt its sting

The archer dropped, his bow unplucked
The fighter died as well
The archmage found its poison
Far too potent to dispel

The rogue is unknown to this day
Though rumours persist still
Rogues aren't known by name or deed
But by the names they kill]], [[An archer from the northern lands
Claimed of his great renown
With peerless skill and countless trials
His name known town to town

He spoke of facing vampire lords
Who promised years of pain
The archer gave a stern retort
An arrow through the brain

A fighter from the southern lands
Claimed armies fled his might
With dragons slain 'most every day
And demons crushed by night

He spoke of ancient sprawling ruins
Home to a ghastly shade
Its years of madness, hate and rage
Were ended on his blade

An archmage from the western lands
Claimed kingdoms feared his name
With countless legends, songs and myths
Attesting to his fame

He spoke of fire, storm and hail
To match the fiercest wyrm
To see one man hold so much power
Can make an empire squirm

A rogue who came from unknown lands
Not known for anything
A leap, a flash, a concealed blade
Three heroes felt its sting

The archer dropped, his bow unplucked
The fighter died as well
The archmage found its poison
Far too potent to dispel

The rogue is unknown to this day
Though rumours persist still
Rogues aren't known by name or deed
But by the names they kill]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/infinite-dungeon.lua"
-- 1 entries
t("infinite dungeon", "infinite dungeon", "newLore category")


------------------------------------------------
section "game/modules/tome/data/lore/iron-throne.lua"
-- 15 entries
t([[#{bold}#3800: #{normal}#Gold accepted as standard unit of currency amongst all races after heavy lobbying. This is greatly to our favour, as our vein resources are high and the material otherwise has no practical usage. Must continue to stockpile more.
#{bold}#4200: #{normal}#New smelting techniques developed allow more stralite to be recovered from existing veins. Techniques must be kept hidden from other races.
#{bold}#4362: #{normal}#Grand Smith Dakhtun has discovered new methods of infusing magical effects in weapons and armour. Potential for profit growth in this area very high.
#{bold}#4550: #{normal}#First special meeting of Iron Throne Profits Committee. War with humans and halflings worrying, as it is reducing potential market size. Threat of complete market elimination forces us to drastic action - all weapons trade must cease. Increase stockpiles of construction materials in hope of eventual reconciliation.
#{bold}#5967: #{normal}#Shaloren involvement in war is becoming too grave a risk - legends of Sher'Tul destruction are a pertinent reminder of the dangers of high magic. Increasing investment in new Ziguranth order in hopes of opposing this problem.
#{bold}#6550: #{normal}#War ended. Opportunity presents itself - now reopening trade, with high prices on all construction items. Profits forecast is very high.
#{bold}#6827: #{normal}#Killed Kroltar the Crimson Wyrm and recovered his hoard. Value of hoard: 20 million gold. Resources lost in recovery effort: 7 million gold (estimation based on standard assessment of 350 gold per capita lost). Net profit: 13 million gold. Profit margin is 186%!
#{bold}#6980: #{normal}#Resources based on dragon hoards are dwindling. Must reduce cull targets to allow recovery of numbers.
#{bold}#7420: #{normal}#Major orc attacks are ruining trade arrangements. Cutting off all contracts until markets settle.
#{bold}#7494: #{normal}#Disastrous use of magic by Shaloren elves has had an unprecedented impact on profitability of our operations. Increasing protectionist measures to prevent economic ruin.]], [[#{bold}#3800: #{normal}#Gold accepted as standard unit of currency amongst all races after heavy lobbying. This is greatly to our favour, as our vein resources are high and the material otherwise has no practical usage. Must continue to stockpile more.
#{bold}#4200: #{normal}#New smelting techniques developed allow more stralite to be recovered from existing veins. Techniques must be kept hidden from other races.
#{bold}#4362: #{normal}#Grand Smith Dakhtun has discovered new methods of infusing magical effects in weapons and armour. Potential for profit growth in this area very high.
#{bold}#4550: #{normal}#First special meeting of Iron Throne Profits Committee. War with humans and halflings worrying, as it is reducing potential market size. Threat of complete market elimination forces us to drastic action - all weapons trade must cease. Increase stockpiles of construction materials in hope of eventual reconciliation.
#{bold}#5967: #{normal}#Shaloren involvement in war is becoming too grave a risk - legends of Sher'Tul destruction are a pertinent reminder of the dangers of high magic. Increasing investment in new Ziguranth order in hopes of opposing this problem.
#{bold}#6550: #{normal}#War ended. Opportunity presents itself - now reopening trade, with high prices on all construction items. Profits forecast is very high.
#{bold}#6827: #{normal}#Killed Kroltar the Crimson Wyrm and recovered his hoard. Value of hoard: 20 million gold. Resources lost in recovery effort: 7 million gold (estimation based on standard assessment of 350 gold per capita lost). Net profit: 13 million gold. Profit margin is 186%!
#{bold}#6980: #{normal}#Resources based on dragon hoards are dwindling. Must reduce cull targets to allow recovery of numbers.
#{bold}#7420: #{normal}#Major orc attacks are ruining trade arrangements. Cutting off all contracts until markets settle.
#{bold}#7494: #{normal}#Disastrous use of magic by Shaloren elves has had an unprecedented impact on profitability of our operations. Increasing protectionist measures to prevent economic ruin.]], "_t")
t("Iron Throne Profits History: Age of Dusk", "Iron Throne Profits History: Age of Dusk", "_t")
t([[#{bold}#412: #{normal}#Diseases and food shortages force increased trade with other races. For the first time in our great history we are in the red. Morale amongst the people is at an all-time low, and is badly affecting productivity.
#{bold}#1430: #{normal}#Several mages visited and used their arts to cure many of the plagues we have suffered for centuries. When offered payment they refused. How very odd...
#{bold}#1490: #{normal}#Production now nearing pre-Spellblaze levels. Profits high, and commerce with other races increasing.
#{bold}#1567: #{normal}#Gigantic earthquakes have completely destroyed many of our major production facilities. Loss of personnel resources is also very tragic, especially key production experts. This is having a very negative effect on our forecasts.]], [[#{bold}#412: #{normal}#Diseases and food shortages force increased trade with other races. For the first time in our great history we are in the red. Morale amongst the people is at an all-time low, and is badly affecting productivity.
#{bold}#1430: #{normal}#Several mages visited and used their arts to cure many of the plagues we have suffered for centuries. When offered payment they refused. How very odd...
#{bold}#1490: #{normal}#Production now nearing pre-Spellblaze levels. Profits high, and commerce with other races increasing.
#{bold}#1567: #{normal}#Gigantic earthquakes have completely destroyed many of our major production facilities. Loss of personnel resources is also very tragic, especially key production experts. This is having a very negative effect on our forecasts.]], "_t")
t("Iron Throne Profits History: Age of Pyre", "Iron Throne Profits History: Age of Pyre", "_t")
t([[#{bold}#240: #{normal}#Market forecasts recovering better than expected. Increasing expansion in external trade areas.
#{bold}#490: #{normal}#Orcish attacks have become much worse - seem to be using higher magic and some demonic forces. Potential threat to resources.
#{bold}#581: #{normal}#Several key cities overwhelmed from underground by attacks from orcs and strange horrors. Have collapsed lower caverns to prevent further penetration. Working on continued resource protection measures.
#{bold}#711: #{normal}#Developed key strategic agreements with outside races to help contain orcish threat to resources and infrastructure. Relations with Toknor of the humans are seen to be especially important - have sent him some of our best armour and weapons to ensure a good return on our investments. In hindsight we should have charged more for these.
#{bold}#713: #{normal}#Orcish threat eliminated. Profits beginning to soar due to increased external trade relations.
]], [[#{bold}#240: #{normal}#Market forecasts recovering better than expected. Increasing expansion in external trade areas.
#{bold}#490: #{normal}#Orcish attacks have become much worse - seem to be using higher magic and some demonic forces. Potential threat to resources.
#{bold}#581: #{normal}#Several key cities overwhelmed from underground by attacks from orcs and strange horrors. Have collapsed lower caverns to prevent further penetration. Working on continued resource protection measures.
#{bold}#711: #{normal}#Developed key strategic agreements with outside races to help contain orcish threat to resources and infrastructure. Relations with Toknor of the humans are seen to be especially important - have sent him some of our best armour and weapons to ensure a good return on our investments. In hindsight we should have charged more for these.
#{bold}#713: #{normal}#Orcish threat eliminated. Profits beginning to soar due to increased external trade relations.
]], "_t")
t("Iron Throne Profits History: Age of Ascendancy", "Iron Throne Profits History: Age of Ascendancy", "_t")
t([[#{bold}#28: #{normal}#Mutual defence treaty signed with newly formed Allied Kingdom, and further trade routes opened. Highest ever recorded profit in final quarter of this year.
#{bold}#115: #{normal}#Noted a return of an orcish presence in the collapsed caverns beneath the Iron Throne. Also increased reports of horrors and demons affecting mining operations. Key strategic decision taken: these must be kept hidden from the other races. Uncertainty will only destabilise the markets. Increase stockpiles of weapons and armour, especially voratun and stralite materials, in case of new war trade.
#{bold}#120: #{normal}#Orcish raid has stolen many of our stockpiled weapons. Pressures on mining operations have increased, cutting off key stralite veins. Resource protection measures need increasing, whilst threat must be contained beneath us. Profits are stable, but under heavy threat.]], [[#{bold}#28: #{normal}#Mutual defence treaty signed with newly formed Allied Kingdom, and further trade routes opened. Highest ever recorded profit in final quarter of this year.
#{bold}#115: #{normal}#Noted a return of an orcish presence in the collapsed caverns beneath the Iron Throne. Also increased reports of horrors and demons affecting mining operations. Key strategic decision taken: these must be kept hidden from the other races. Uncertainty will only destabilise the markets. Increase stockpiles of weapons and armour, especially voratun and stralite materials, in case of new war trade.
#{bold}#120: #{normal}#Orcish raid has stolen many of our stockpiled weapons. Pressures on mining operations have increased, cutting off key stralite veins. Resource protection measures need increasing, whilst threat must be contained beneath us. Profits are stable, but under heavy threat.]], "_t")
t([[#{bold}#AN EDICT TO ALL CITIZENS OF THE IRON THRONE. LONG MAY OUR EMPIRE ENDURE.#{normal}#

The rumours you have heard are true. It is with a heavy heart that I confirm one of our mines, Reknor, has been overtaken and inhabited by a large and organised orcish force. How there could be such a decisive and total failure on our part to stop this threat remains a mystery - the source of the orcish invasion remains unknown. A battalion of soldiers will form a defensive perimeter around Reknor until a force to retake the mine and exterminate the orcs can be mustered. All civilians residing within the surrounding halls are to be evacuated.

This is a grave and unprecedented issue, so I decree an oath of silence to be laid upon all citizens of the Iron Throne, regardless of class and station: NO NEWS OF THIS INVASION MUST REACH FOREIGN EARS. We must maintain an image of stability and strength with the Allied Kingdom, as any signs of weakness or internal strife would be catastrophic to our alliance and future trade agreements. Any citizen found divulging this information to any outside party will be punished with exile. Rest assured, I will personally send messages to those outside the Throne who can be trusted with this information, and I trust this orcish intrusion shall be dealt with swiftly and decisively. So speaks the ruler of the Iron Throne, long may our empire endure.]], [[#{bold}#AN EDICT TO ALL CITIZENS OF THE IRON THRONE. LONG MAY OUR EMPIRE ENDURE.#{normal}#

The rumours you have heard are true. It is with a heavy heart that I confirm one of our mines, Reknor, has been overtaken and inhabited by a large and organised orcish force. How there could be such a decisive and total failure on our part to stop this threat remains a mystery - the source of the orcish invasion remains unknown. A battalion of soldiers will form a defensive perimeter around Reknor until a force to retake the mine and exterminate the orcs can be mustered. All civilians residing within the surrounding halls are to be evacuated.

This is a grave and unprecedented issue, so I decree an oath of silence to be laid upon all citizens of the Iron Throne, regardless of class and station: NO NEWS OF THIS INVASION MUST REACH FOREIGN EARS. We must maintain an image of stability and strength with the Allied Kingdom, as any signs of weakness or internal strife would be catastrophic to our alliance and future trade agreements. Any citizen found divulging this information to any outside party will be punished with exile. Rest assured, I will personally send messages to those outside the Throne who can be trusted with this information, and I trust this orcish intrusion shall be dealt with swiftly and decisively. So speaks the ruler of the Iron Throne, long may our empire endure.]], "_t")
t([[#{bold}#IRON THRONE TRADE LEDGER - Allied Kingdom#{normal}#
#{italic}#Age of Ascendancy, 121#{normal}#

#{bold}#Last Hope - Exports#{normal}#
      Steel Plate Armour (Human) - 500pcs.
      Steel Plate Armour (Halfling) - 460pcs.
      Steel Armaments -
      * Longswords - 170pcs.
      * Spears - 200pcs.
      * Maces - 150pcs.
      Crafts, Sundries - 2,200pcs.

#{bold}#Derth - Exports#{normal}#
      Iron Hatchets - 50pcs.
      Tools, Sundries - 65pcs.

#{bold}#Last Hope - Imports#{normal}#
      Gold - 500,000pcs.
      Grains, Etc. - 1,000tons

#{bold}#CONFIDENTIAL: Angolwen - Exports#{normal}#
      Garnets - 50pcs.
      Rubies - 40pcs.
      Diamonds - 20pcs.

low diamond yield this year - +50% charge? ziguranth raided our last ang. caravan - more guards? - D.
yes to diamonds. arm our merchants in the caravan, no extra guards. profits are thin enough as it is! - S.]], [[#{bold}#IRON THRONE TRADE LEDGER - Allied Kingdom#{normal}#
#{italic}#Age of Ascendancy, 121#{normal}#

#{bold}#Last Hope - Exports#{normal}#
      Steel Plate Armour (Human) - 500pcs.
      Steel Plate Armour (Halfling) - 460pcs.
      Steel Armaments -
      * Longswords - 170pcs.
      * Spears - 200pcs.
      * Maces - 150pcs.
      Crafts, Sundries - 2,200pcs.

#{bold}#Derth - Exports#{normal}#
      Iron Hatchets - 50pcs.
      Tools, Sundries - 65pcs.

#{bold}#Last Hope - Imports#{normal}#
      Gold - 500,000pcs.
      Grains, Etc. - 1,000tons

#{bold}#CONFIDENTIAL: Angolwen - Exports#{normal}#
      Garnets - 50pcs.
      Rubies - 40pcs.
      Diamonds - 20pcs.

low diamond yield this year - +50% charge? ziguranth raided our last ang. caravan - more guards? - D.
yes to diamonds. arm our merchants in the caravan, no extra guards. profits are thin enough as it is! - S.]], "_t")
t("Deep Bellow excavation report 1", "Deep Bellow excavation report 1", "_t")
t([[10 days into initial site survey, hmm! Recent tremors have opened deep new chasms, but we must work cautiously to ensure they're stable before conducting major operations, oh yes! Proceeding well at start, with supports being put in place and no flammable gases detected, hmm hmm.

Some Sher'Tul relics have been found. Perhaps great profit to be had here! High margins on Shaloren market, yes yes.

Some miners saying they feel ill, hrm hrm. The drem fools have likely been gorging on too much mead. Will deduct it from their pay, yes yes!

-- Foreman Tamoth]], [[10 days into initial site survey, hmm! Recent tremors have opened deep new chasms, but we must work cautiously to ensure they're stable before conducting major operations, oh yes! Proceeding well at start, with supports being put in place and no flammable gases detected, hmm hmm.

Some Sher'Tul relics have been found. Perhaps great profit to be had here! High margins on Shaloren market, yes yes.

Some miners saying they feel ill, hrm hrm. The drem fools have likely been gorging on too much mead. Will deduct it from their pay, yes yes!

-- Foreman Tamoth]], "_t")
t("Deep Bellow excavation report 2", "Deep Bellow excavation report 2", "_t")
t([[Chasms go deep, yes yes. More relics found, oh yes. Will be mighty profitable! But ah, my secret treasure is even better, indeed! Gold! Beautiful lovely gold, buried deep, so deep... Have kept it hidden, sealed, yes. Looks like the remains of a giant throne. I touched it, yes, I even put my lips to it - ahhh, the taste!

But must stay focussed, much work to be done. Miners are rowdy, hrm! One of the drem fools went mad and killed himself with a pickaxe - messy business. Must restore order, yes yes! More Sher'Tul artifacts found, possibly even remains of weapons. Imagine the profit! Will keep them hidden yes, the dreams say yes, in the darkness, secret, waiting waiting, for the right time...

Hmm, that fellow's blood was so red, spilling on the cavernous floor. I wonder where they buried him? My mouth... it wants to taste, yes yes...

-- Foreman Tamoth]], [[Chasms go deep, yes yes. More relics found, oh yes. Will be mighty profitable! But ah, my secret treasure is even better, indeed! Gold! Beautiful lovely gold, buried deep, so deep... Have kept it hidden, sealed, yes. Looks like the remains of a giant throne. I touched it, yes, I even put my lips to it - ahhh, the taste!

But must stay focussed, much work to be done. Miners are rowdy, hrm! One of the drem fools went mad and killed himself with a pickaxe - messy business. Must restore order, yes yes! More Sher'Tul artifacts found, possibly even remains of weapons. Imagine the profit! Will keep them hidden yes, the dreams say yes, in the darkness, secret, waiting waiting, for the right time...

Hmm, that fellow's blood was so red, spilling on the cavernous floor. I wonder where they buried him? My mouth... it wants to taste, yes yes...

-- Foreman Tamoth]], "_t")
t("Deep Bellow excavation report 3", "Deep Bellow excavation report 3", "_t")
t([[Hah, my mouth, it tastes, it feels, hmm hmm. It grows, yes yes! The others are changing, flying, screaming, squelching, warping. Bad for profit, hmm hmm. My teeth, they grow, they hunger, yes. They want to escape!

I can feel in my dreams, the dark depths. Bound, buried, forgotten. My mouth wants to open, to scream, to destroy! Hmm hmm, deep below, yes... Want to get out!

Must stay down here to be close to the dreams, yes yes. Must plant my mouth in the soil and watch it grow! It will devour me, and grow and grow, hmm hmm. It will call from the dark place, and bring back Him from the deepest below, oh yes.

-- Ta...moth... The mouth... yes yes!]], [[Hah, my mouth, it tastes, it feels, hmm hmm. It grows, yes yes! The others are changing, flying, screaming, squelching, warping. Bad for profit, hmm hmm. My teeth, they grow, they hunger, yes. They want to escape!

I can feel in my dreams, the dark depths. Bound, buried, forgotten. My mouth wants to open, to scream, to destroy! Hmm hmm, deep below, yes... Want to get out!

Must stay down here to be close to the dreams, yes yes. Must plant my mouth in the soil and watch it grow! It will devour me, and grow and grow, hmm hmm. It will call from the dark place, and bring back Him from the deepest below, oh yes.

-- Ta...moth... The mouth... yes yes!]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/keepsake.lua"
-- 32 entries
t("A Tranquil Meadow", "A Tranquil Meadow", "_t")
t([[You've entered a tranquil meadow. Something about this place seems familiar but you're not quite sure.
The only thing that you are sure of is that it has offered you a moment of rest from the long suffering of your cursed life.
You feel the hate inside you melt away. You feel as if the curse has subsided for a moment.

This place makes you wonder if there is a way to end the curse.
And if you can't overcome it you might be able to master it and take back a part of your life.
Either way, you feel the time has come to do something more about this curse.
]], [[You've entered a tranquil meadow. Something about this place seems familiar but you're not quite sure.
The only thing that you are sure of is that it has offered you a moment of rest from the long suffering of your cursed life.
You feel the hate inside you melt away. You feel as if the curse has subsided for a moment.

This place makes you wonder if there is a way to end the curse.
And if you can't overcome it you might be able to master it and take back a part of your life.
Either way, you feel the time has come to do something more about this curse.
]], "_t")
t("A Haunting Dream", "A Haunting Dream", "_t")
t([[As you wander the meadow you grow more relaxed. You lie down for a moment and close your eyes...

You wake up (if you can call it that) in a vivid dream. A small trail winds through the dense forest.
The branches of the trees seem to close in around you. The tranquil feeling of the meadow is gone.
Instead you feel the rising fear and hatred that rule your waking life. Further down the trail you hear voices.
]], [[As you wander the meadow you grow more relaxed. You lie down for a moment and close your eyes...

You wake up (if you can call it that) in a vivid dream. A small trail winds through the dense forest.
The branches of the trees seem to close in around you. The tranquil feeling of the meadow is gone.
Instead you feel the rising fear and hatred that rule your waking life. Further down the trail you hear voices.
]], "_t")
t("Bander's Notes", "Bander's Notes", "_t")
t([[#{italic}#You find a folded up piece of paper with some notes on it...#{normal}#

* Mom apparently died like the others but they refuse to say much more about it. I think all of the bodies were burned.

* Terrik mentioned the caravan was having a good year. Profits were great and the usual bandits and thieves were absent. Something scaring them off?

* Some of the dead had 'normal' wounds but some were just 'lifeless' or 'pale'. Jak was found the same way. That was 2 months earlier.

* All of the attackers were spirits or wisps of darkess. As far as I can tell no one was spared attack, though a few survived. I'll need to check their stories.

* People keep mentioning the 3 new hires when I ask about this. Why do they come to mind? I hear Berethh is some kind of hero around these parts. Alva thought Kyless was a rotten person. She's not the only one.

* Someone said "Bander, you ask too many questions." I'll have to give them some time. Even after all these years.
]], [[#{italic}#You find a folded up piece of paper with some notes on it...#{normal}#

* Mom apparently died like the others but they refuse to say much more about it. I think all of the bodies were burned.

* Terrik mentioned the caravan was having a good year. Profits were great and the usual bandits and thieves were absent. Something scaring them off?

* Some of the dead had 'normal' wounds but some were just 'lifeless' or 'pale'. Jak was found the same way. That was 2 months earlier.

* All of the attackers were spirits or wisps of darkess. As far as I can tell no one was spared attack, though a few survived. I'll need to check their stories.

* People keep mentioning the 3 new hires when I ask about this. Why do they come to mind? I hear Berethh is some kind of hero around these parts. Alva thought Kyless was a rotten person. She's not the only one.

* Someone said "Bander, you ask too many questions." I'll have to give them some time. Even after all these years.
]], "_t")
t("The Acorn", "The Acorn", "_t")
t([[Along the trail you see something at your feet. It's a small acorn, made of iron. You stare at the acorn for a while and pick it up.
It belonged to Bander's mom, and before that, his dad. You remember she never went anywhere without it.
Bander was just a kid then. You wonder how he's turned out. Not well you imagine. Thanks to Berethh, Kyless and you.
You keep turning the acorn in your hand and squeezing it until the cold iron bites into your skin.
That gives you comfort somehow. Unable to part with it, you put it in your pack.
]], [[Along the trail you see something at your feet. It's a small acorn, made of iron. You stare at the acorn for a while and pick it up.
It belonged to Bander's mom, and before that, his dad. You remember she never went anywhere without it.
Bander was just a kid then. You wonder how he's turned out. Not well you imagine. Thanks to Berethh, Kyless and you.
You keep turning the acorn in your hand and squeezing it until the cold iron bites into your skin.
That gives you comfort somehow. Unable to part with it, you put it in your pack.
]], "_t")
t("The Merchant Caravan", "The Merchant Caravan", "_t")
t([[The trail leads out to a clearing where a group of people sit around talking.	
This is the merchant caravan you once belonged to. You haven't thought of them for a long time, but now they haunt your dreams.

You suddenly realize how much you despise them now. Is it this hate that fuels your curse?
They wanted to kill you, but left you to die instead. They could feel what you had become.
And they can feel it now. Each in turn grabs a weapon and begins to head your way...
]], [[The trail leads out to a clearing where a group of people sit around talking.	
This is the merchant caravan you once belonged to. You haven't thought of them for a long time, but now they haunt your dreams.

You suddenly realize how much you despise them now. Is it this hate that fuels your curse?
They wanted to kill you, but left you to die instead. They could feel what you had become.
And they can feel it now. Each in turn grabs a weapon and begins to head your way...
]], "_t")
t("The Dream's End", "The Dream's End", "_t")
t([[You wake up in the tranquil meadow, feeling refreshed. The dream seemed to release you from a burden you've been carrying.
As you lie there you notice yourself turning something around in your hand. It is the small acorn from the dream.
You open your hand and see that it has been stained with someone else's blood. You grip the acorn tighter until you can feel the pain of the biting iron.

Your hate is burning inside you again. If it has to be released then there is only one person who deserves it more than anyone.
He had a sanctuary: a cave where he would store his 'profits'. Perhaps you could find him there.

As you look around the meadow you realize what this place is and perhaps what drew you here.
Kyless had taken you this way once. On the north side of the meadow was a secret path that led to his cave.
]], [[You wake up in the tranquil meadow, feeling refreshed. The dream seemed to release you from a burden you've been carrying.
As you lie there you notice yourself turning something around in your hand. It is the small acorn from the dream.
You open your hand and see that it has been stained with someone else's blood. You grip the acorn tighter until you can feel the pain of the biting iron.

Your hate is burning inside you again. If it has to be released then there is only one person who deserves it more than anyone.
He had a sanctuary: a cave where he would store his 'profits'. Perhaps you could find him there.

As you look around the meadow you realize what this place is and perhaps what drew you here.
Kyless had taken you this way once. On the north side of the meadow was a secret path that led to his cave.
]], "_t")
t("The Stone Marker", "The Stone Marker", "_t")
t([[#{italic}#You find a stone marker at the entrance to a sealed off cave...#{normal}#
#{bold}#Do Not Enter#{normal}#

This cave holds a danger that should never be released upon this world again. Break the seal and you will suffer.

* Under the protection of Berethh
]], [[#{italic}#You find a stone marker at the entrance to a sealed off cave...#{normal}#
#{bold}#Do Not Enter#{normal}#

This cave holds a danger that should never be released upon this world again. Break the seal and you will suffer.

* Under the protection of Berethh
]], "_t")
t("The Sealed Cave", "The Sealed Cave", "_t")
t([[The entrance to the cave appears to be sealed. There are many strange markings and glyphs carved into the rock.
You suspect the cave is protected by some kind of natural magic.

It looks as if the protections were meant to keep someone in. You don't think it would be difficult to force the door from the outside.
]], [[The entrance to the cave appears to be sealed. There are many strange markings and glyphs carved into the rock.
You suspect the cave is protected by some kind of natural magic.

It looks as if the protections were meant to keep someone in. You don't think it would be difficult to force the door from the outside.
]], "_t")
t("The Battle of the Cave", "The Battle of the Cave", "_t")
t([[You step into the cave and give your eyes a moment to adjust to the darkness.
There are signs of an old battle here. Two skeletons lie on the floor dressed in hand-crafted armor, their simple but well-made weapons still in hand.
The bodies don't look old enough to have decomposed but seem rather gnawed on. The remains of several large dogs also lie nearby.
Suddenly you catch movement in the corner. One of the dogs appears to be alive. It's lean and dirty and has an unnatural way of moving.
That's when you notice shadows move across the floor towards the dog. The animal lifts its head as if listening to something.
Together the dog and the shadows rise up to face you.
]], [[You step into the cave and give your eyes a moment to adjust to the darkness.
There are signs of an old battle here. Two skeletons lie on the floor dressed in hand-crafted armor, their simple but well-made weapons still in hand.
The bodies don't look old enough to have decomposed but seem rather gnawed on. The remains of several large dogs also lie nearby.
Suddenly you catch movement in the corner. One of the dogs appears to be alive. It's lean and dirty and has an unnatural way of moving.
That's when you notice shadows move across the floor towards the dog. The animal lifts its head as if listening to something.
Together the dog and the shadows rise up to face you.
]], "_t")
t("Kyless' Journal: First Entry", "Kyless' Journal: First Entry", "_t")
t([[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

I finally made it out. I don't think I could stay another year on that farm.
Dad had no ambition. Every time I went with him to sell our crop he took whatever the merchants offered him.
When the job with the caravan came up, how could I not take it? I'm sure I'll be back to see the parents soon.
So far the work at the caravan is pretty dull. I've been paying attention to the merchants though.
They let me follow them on their trips into the towns. I'm learning a lot. In time I may become one of them.
The caravan hired a couple of other porters too. They won't say but I think the last ones were killed in some kind of raid.
I'll have to learn to defend myself or let others do it for me. Still, this is better than being a farmer.
]], [[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

I finally made it out. I don't think I could stay another year on that farm.
Dad had no ambition. Every time I went with him to sell our crop he took whatever the merchants offered him.
When the job with the caravan came up, how could I not take it? I'm sure I'll be back to see the parents soon.
So far the work at the caravan is pretty dull. I've been paying attention to the merchants though.
They let me follow them on their trips into the towns. I'm learning a lot. In time I may become one of them.
The caravan hired a couple of other porters too. They won't say but I think the last ones were killed in some kind of raid.
I'll have to learn to defend myself or let others do it for me. Still, this is better than being a farmer.
]], "_t")
t("Kyless' Journal: Second Entry", "Kyless' Journal: Second Entry", "_t")
t([[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

Berethh found something in the woods...a dead man and a few dead trolls.
At first we thought they killed each other but there weren't any wounds we could see. It was something awful though; you could see it in their faces.
Berethh just wanted to leave. He didn't like the way it felt. But I just couldn't pass up a free opportunity like that.
They had some money on them and some other things which we divided up. The man also had a book, which I took.
I've been studying it. It seems like some kind of magic, but nothing like any of the magic I've heard in stories.
It's more like a language. A way of thinking or calling out with your mind. I'm learning it now.
I hear what sound like whispers in my head. And I've found I can whisper back.
My mind can reach out. Control things. Control people. But there's more. Something is out there. I have to reach out.
Once I've mastered this I may be able to use it to advance in the caravan. I'm tired of just being a porter.
]], [[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

Berethh found something in the woods...a dead man and a few dead trolls.
At first we thought they killed each other but there weren't any wounds we could see. It was something awful though; you could see it in their faces.
Berethh just wanted to leave. He didn't like the way it felt. But I just couldn't pass up a free opportunity like that.
They had some money on them and some other things which we divided up. The man also had a book, which I took.
I've been studying it. It seems like some kind of magic, but nothing like any of the magic I've heard in stories.
It's more like a language. A way of thinking or calling out with your mind. I'm learning it now.
I hear what sound like whispers in my head. And I've found I can whisper back.
My mind can reach out. Control things. Control people. But there's more. Something is out there. I have to reach out.
Once I've mastered this I may be able to use it to advance in the caravan. I'm tired of just being a porter.
]], "_t")
t("Kyless' Journal: Third Entry", "Kyless' Journal: Third Entry", "_t")
t([[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

I've come so far in the last year. The other merchants listen to me now. They think I have a real gift for trade.
The weak-minded peasants we trade with are so easy to control though. They practically give me their money.
But the real money and power rests with the bandits. Those two that ambushed me got what they deserved. So did the rest of their camp.
The fear on their faces when I struck was priceless. They must have had more gold than the caravan makes in a year!
I got some help carrying it off to a nearby cave. A few more encounters like that and I'll be rich.
Until then, I'll stay with the caravan. The only prolem is Jak. He doesn't trust me.
I guess I threaten his authority. Not sure what I'll have to do about that...
]], [[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

I've come so far in the last year. The other merchants listen to me now. They think I have a real gift for trade.
The weak-minded peasants we trade with are so easy to control though. They practically give me their money.
But the real money and power rests with the bandits. Those two that ambushed me got what they deserved. So did the rest of their camp.
The fear on their faces when I struck was priceless. They must have had more gold than the caravan makes in a year!
I got some help carrying it off to a nearby cave. A few more encounters like that and I'll be rich.
Until then, I'll stay with the caravan. The only prolem is Jak. He doesn't trust me.
I guess I threaten his authority. Not sure what I'll have to do about that...
]], "_t")
t("Kyless' Journal: Fourth Entry", "Kyless' Journal: Fourth Entry", "_t")
t([[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

Berethh! He must have followed me back to the cave. How could he know I was behind the attacks?
And now he's betrayed me. We were friends once! It seems he's made some new friends in these parts.
I thought I could retreat back into the cave. Take them in the darkness like I always do.
But they didn't follow. He must have known I was too strong.
The entrance has been sealed now. I can't seem to break it. Nothing I've tried works.
It's as though the seal were alive, growing stronger with every attack. Berethh must have planned this carefully.
I'm sure I can overcome his wards though. I just need some time to grow my power.
]], [[#{italic}#This is a page from what you assume is Kyless' journal.#{normal}#

Berethh! He must have followed me back to the cave. How could he know I was behind the attacks?
And now he's betrayed me. We were friends once! It seems he's made some new friends in these parts.
I thought I could retreat back into the cave. Take them in the darkness like I always do.
But they didn't follow. He must have known I was too strong.
The entrance has been sealed now. I can't seem to break it. Nothing I've tried works.
It's as though the seal were alive, growing stronger with every attack. Berethh must have planned this carefully.
I'm sure I can overcome his wards though. I just need some time to grow my power.
]], "_t")
t("The Vault", "The Vault", "_t")
t([[You find yourself at the entrance to a small room.
It's one of the vaults that Kyless used to store the valuable things he recovered on his excursions.
For a cut you had helped him carry stuff down here. You made some pretty good money off him.
Funny how it seemed like such a fortune then. The loot of petty bandits.
You should have turned your back on him. Things got pretty bad toward the end.
You knew he was greedy and ambitious but you didn't realize how cold-hearted he was.
You never thought he would go after the caravan. How could you have known?
You've tried to forget that day for a long time. You've tried to forget what he did to those people.
And those things of his almost killed you too. But maybe you were cursed long before that day ever happened.
]], [[You find yourself at the entrance to a small room.
It's one of the vaults that Kyless used to store the valuable things he recovered on his excursions.
For a cut you had helped him carry stuff down here. You made some pretty good money off him.
Funny how it seemed like such a fortune then. The loot of petty bandits.
You should have turned your back on him. Things got pretty bad toward the end.
You knew he was greedy and ambitious but you didn't realize how cold-hearted he was.
You never thought he would go after the caravan. How could you have known?
You've tried to forget that day for a long time. You've tried to forget what he did to those people.
And those things of his almost killed you too. But maybe you were cursed long before that day ever happened.
]], "_t")
t([[A figure squats in the darkness with his face turned your way. At first you're not sure if Kyless recognizes you.
His face seems twisted by hunger and madness. But soon it softens and he begins to look more like the Kyless of old.
He speaks your name in recognition but doesn't move. Slowly, almost imperceptibly, the air in the room begins to change.
A charge seems to fill the space around you. Small gusts of wind pick up and scatter dust across the floor.
You feel as if the room itself is coming to bear upon you. Kyless smiles and then attacks.
]], [[A figure squats in the darkness with his face turned your way. At first you're not sure if Kyless recognizes you.
His face seems twisted by hunger and madness. But soon it softens and he begins to look more like the Kyless of old.
He speaks your name in recognition but doesn't move. Slowly, almost imperceptibly, the air in the room begins to change.
A charge seems to fill the space around you. Small gusts of wind pick up and scatter dust across the floor.
You feel as if the room itself is coming to bear upon you. Kyless smiles and then attacks.
]], "_t")
t([[Berethh lies dead. Kyless has been destroyed. The merchant caravan wiped out. Nothing of your past remains.
You thought you might find answers in this place but you have been left with only one certainty. You are cursed.
As you try to push these thoughts out of your mind, you find yourself turning the iron acorn in your hand.
The cold iron hardens your resolve. Whether the curse consumes you or not, you will press on.
As the iron cuts your flesh, you slowly become aware of a sound coming from the direction of the meadow.
Dogs barking. Following that come the voices of men. These must be Berethh's companions. Arriving too late.
You rise and prepare to kill again.
]], [[Berethh lies dead. Kyless has been destroyed. The merchant caravan wiped out. Nothing of your past remains.
You thought you might find answers in this place but you have been left with only one certainty. You are cursed.
As you try to push these thoughts out of your mind, you find yourself turning the iron acorn in your hand.
The cold iron hardens your resolve. Whether the curse consumes you or not, you will press on.
As the iron cuts your flesh, you slowly become aware of a sound coming from the direction of the meadow.
Dogs barking. Following that come the voices of men. These must be Berethh's companions. Arriving too late.
You rise and prepare to kill again.
]], "_t")
t("keepsake", "keepsake", "newLore category")
t([[Berethh lies dead. Kyless has been destroyed. The merchant caravan wiped out. Nothing of your past remains.
You thought you might find answers in this place but you have been left with only one certainty. You are cursed.
As you try to push these thoughts out of your mind, you find yourself turning the iron acorn in your hand.
The acorn now serves as a focus for your anger. Though the curse may consume you, there are many who deserve your wrath. And they will feel it.
As the iron cuts your flesh, you slowly become aware of a sound coming from the direction of the meadow.
Dogs barking. Following that come the voices of men. These must be Berethh's companions. Arriving too late.
You rise and prepare to kill again.
]], [[Berethh lies dead. Kyless has been destroyed. The merchant caravan wiped out. Nothing of your past remains.
You thought you might find answers in this place but you have been left with only one certainty. You are cursed.
As you try to push these thoughts out of your mind, you find yourself turning the iron acorn in your hand.
The acorn now serves as a focus for your anger. Though the curse may consume you, there are many who deserve your wrath. And they will feel it.
As the iron cuts your flesh, you slowly become aware of a sound coming from the direction of the meadow.
Dogs barking. Following that come the voices of men. These must be Berethh's companions. Arriving too late.
You rise and prepare to kill again.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/kor-pul.lua"
-- 7 entries
t([[Damn that Zemekkys! Damn his insane experiments!! Why in the blackest night did I ever agree to take part in them?!

Oh yeah, because I was broke. Bah...

I think I might have considered things differently had I known I'd be transported without my clothes though! Imagine my embarrassment turning up in a foreign land, with my... my unmentionables on display... Thankfully I managed to borrow a robe from a friendly farmer, and did some work for him to earn gold enough for a bit of food, a journal, and a rusty old sword. When I heard there were ruins filled with undead nearby I knew my calling had come! So here I am, mighty Sun Paladin Telthar, to prove my strength in these foreign lands of the west!

But all I've found so far is rats. I hate rats...]], [[Damn that Zemekkys! Damn his insane experiments!! Why in the blackest night did I ever agree to take part in them?!

Oh yeah, because I was broke. Bah...

I think I might have considered things differently had I known I'd be transported without my clothes though! Imagine my embarrassment turning up in a foreign land, with my... my unmentionables on display... Thankfully I managed to borrow a robe from a friendly farmer, and did some work for him to earn gold enough for a bit of food, a journal, and a rusty old sword. When I heard there were ruins filled with undead nearby I knew my calling had come! So here I am, mighty Sun Paladin Telthar, to prove my strength in these foreign lands of the west!

But all I've found so far is rats. I hate rats...]], "_t")
t([[Aha, I have found the accursed undead that plague this nefarious dungeon! The skeletal fool was thankfully no match for me! I suppose it helped that he had no arms...

I've found myself an old shield that in spite of a few dents seems serviceable enough. Some of these rats are BIG, and giving them a strong bash with the shield helps to stop their poisonous bites before I get my sword to their necks. I also found a few gems - I may have to hunt round for more. Not out of any personal greed of course, but my noble quest requires that I gather resources to defeat the great evils in this land and back home!

Diamonds are my favourite, so sparkly.]], [[Aha, I have found the accursed undead that plague this nefarious dungeon! The skeletal fool was thankfully no match for me! I suppose it helped that he had no arms...

I've found myself an old shield that in spite of a few dents seems serviceable enough. Some of these rats are BIG, and giving them a strong bash with the shield helps to stop their poisonous bites before I get my sword to their necks. I also found a few gems - I may have to hunt round for more. Not out of any personal greed of course, but my noble quest requires that I gather resources to defeat the great evils in this land and back home!

Diamonds are my favourite, so sparkly.]], "_t")
t([[This place is infested! I've found a lot of skeletons now, and unfortunately most of them have borne a full set of limbs. However, my holy quest cannot be denied! Plus I got a really great sword off one of the blighters, I can chop anything up easily now!

The skeletal mages have been a night-born nuisance, but I've found a new weapon to use against them - a phase door rune! As soon as I catch sight of one of the robed wretches I activate my rune and foom, I'm away!

It's not fleeing, it's just tactical repositioning...
]], [[This place is infested! I've found a lot of skeletons now, and unfortunately most of them have borne a full set of limbs. However, my holy quest cannot be denied! Plus I got a really great sword off one of the blighters, I can chop anything up easily now!

The skeletal mages have been a night-born nuisance, but I've found a new weapon to use against them - a phase door rune! As soon as I catch sight of one of the robed wretches I activate my rune and foom, I'm away!

It's not fleeing, it's just tactical repositioning...
]], "_t")
t([[Kor'Pul, Kor'Pul... When the farmer told me what this place was called it reminded me of something, and I think it's coming back to me now. My mother used to tell me a story about our ancestors, how they fled by ship to escape the grasp of an evil sorcerer who dominated the lands. The sorcerer was a vile necromancer who took advantage of the destruction from the Spellblaze and the Cataclysm to create huge armies of undead. The people fought against him time and time again, but though he would be defeated he would still come back, sometimes after hundreds of years. And that sorcerer's name was.... Kor'Pul.

Probably just a coincidence.]], [[Kor'Pul, Kor'Pul... When the farmer told me what this place was called it reminded me of something, and I think it's coming back to me now. My mother used to tell me a story about our ancestors, how they fled by ship to escape the grasp of an evil sorcerer who dominated the lands. The sorcerer was a vile necromancer who took advantage of the destruction from the Spellblaze and the Cataclysm to create huge armies of undead. The people fought against him time and time again, but though he would be defeated he would still come back, sometimes after hundreds of years. And that sorcerer's name was.... Kor'Pul.

Probably just a coincidence.]], "_t")
t("kor'pul", "kor'pul", "newLore category")
t("journal page (kor'pul)", "journal page (kor'pul)", "_t")
t([[It's quiet down here. And dark... very dark. I suppose I should have brought a lantern. Our motto is to bring light into dark places, but I guess I should have thought about that in practical terms. I've cleared out pretty much all of this area, and there's not much left to explore beyond this last room.

This adventuring stuff is quite lonely, I must say. I guess keeping this journal helps a bit. I miss home a lot now. I miss... I miss Falia. Maybe I should have said something to her about how I feel... but I guess running away on an adventure seemed easier. Pah, how brave of me...

I'm not cut out for this paladin work. Here I am, alone in a horrible dark dungeon in an unknown land, without a single sound to keep me company beyond the scratchings of my own quill. Hmm, except for--]], [[It's quiet down here. And dark... very dark. I suppose I should have brought a lantern. Our motto is to bring light into dark places, but I guess I should have thought about that in practical terms. I've cleared out pretty much all of this area, and there's not much left to explore beyond this last room.

This adventuring stuff is quite lonely, I must say. I guess keeping this journal helps a bit. I miss home a lot now. I miss... I miss Falia. Maybe I should have said something to her about how I feel... but I guess running away on an adventure seemed easier. Pah, how brave of me...

I'm not cut out for this paladin work. Here I am, alone in a horrible dark dungeon in an unknown land, without a single sound to keep me company beyond the scratchings of my own quill. Hmm, except for--]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/last-hope.lua"
-- 65 entries
t([[#{italic}#68th of Dusk, Year of Pyre 710#{normal}#
The orcish tribe have routed us. We have retreated to some Mardrop ruins and secured ourselves amongst the fortifications. I have just shy of 2,000 men under my banner, some of the best warriors I have ever served with, but we are simply no match for the numbers we face. Counting them is difficult, but I would put a minimum estimate at 10,000. The tribe has camped a league away - they seem to be waiting for reinforcements. This does not bode well...

I have sent messenger crows to all the kingdoms. I can but hope they send aid in time.]], [[#{italic}#68th of Dusk, Year of Pyre 710#{normal}#
The orcish tribe have routed us. We have retreated to some Mardrop ruins and secured ourselves amongst the fortifications. I have just shy of 2,000 men under my banner, some of the best warriors I have ever served with, but we are simply no match for the numbers we face. Counting them is difficult, but I would put a minimum estimate at 10,000. The tribe has camped a league away - they seem to be waiting for reinforcements. This does not bode well...

I have sent messenger crows to all the kingdoms. I can but hope they send aid in time.]], "_t")
t([[#{italic}#25th of Haze, Year of Pyre 710#{normal}#
Five men tried deserting last night. Today I had them flogged in front of all the others. I have given warning that any future deserters shall be hanged. These are measures I do not like to take, but harsh times call for harsher discipline.

Our supplies are holding steady for now, but I fear they may not last. I've received word that it will take at least fifty days to muster a force that can save us. Alas, food may well be the least of our worries, for the orcs have begun to attack our strongholds. Thankfully we have had time to reinforce the existing structures. Indeed, little work was needed, for the foundations of this place are strong. My loremaster tells me it was abandoned following the Crimson Pox, but was once the capital of Mardrop. The men have taken a fondness to the place, and have named it "Last Hope". Though I normally discourage such romantic notions I cannot help but feel the same. These stone walls give strength to my heart - I feel we can fight through this.

Their attack has begun again. They seem to have mages now. Ah, it will be a long night...]], [[#{italic}#25th of Haze, Year of Pyre 710#{normal}#
Five men tried deserting last night. Today I had them flogged in front of all the others. I have given warning that any future deserters shall be hanged. These are measures I do not like to take, but harsh times call for harsher discipline.

Our supplies are holding steady for now, but I fear they may not last. I've received word that it will take at least fifty days to muster a force that can save us. Alas, food may well be the least of our worries, for the orcs have begun to attack our strongholds. Thankfully we have had time to reinforce the existing structures. Indeed, little work was needed, for the foundations of this place are strong. My loremaster tells me it was abandoned following the Crimson Pox, but was once the capital of Mardrop. The men have taken a fondness to the place, and have named it "Last Hope". Though I normally discourage such romantic notions I cannot help but feel the same. These stone walls give strength to my heart - I feel we can fight through this.

Their attack has begun again. They seem to have mages now. Ah, it will be a long night...]], "_t")
t([[#{italic}#47th of Haze, Year of Pyre 710#{normal}#
Rations low. Men demoralised. Winterhaze wind is making conditions unbearable. The fortress is holding, but each night they pick off some of our troops. It is but a matter of time before we no longer have the strength to resist.

I can hear their blasted trumpets again. Accursed swine! We have no rest or sleep, not the slightest sojourn without their braying, howling, jeering, taunting, insufferable cantations! It is driving me from my wits! But I must remain strong... I must put on a brave face for the men. They are relying on me, and though the burden feels close to crushing me I must bear it with the dignity of a king.

It is getting dark again. Who will die this night? I am so very afraid... but I cannot show it...]], [[#{italic}#47th of Haze, Year of Pyre 710#{normal}#
Rations low. Men demoralised. Winterhaze wind is making conditions unbearable. The fortress is holding, but each night they pick off some of our troops. It is but a matter of time before we no longer have the strength to resist.

I can hear their blasted trumpets again. Accursed swine! We have no rest or sleep, not the slightest sojourn without their braying, howling, jeering, taunting, insufferable cantations! It is driving me from my wits! But I must remain strong... I must put on a brave face for the men. They are relying on me, and though the burden feels close to crushing me I must bear it with the dignity of a king.

It is getting dark again. Who will die this night? I am so very afraid... but I cannot show it...]], "_t")
t([[#{italic}#51st of Haze, Year of Pyre 710#{normal}#
Oh, happy days! Joyous retribution! From the jaws of defeat we have been saved, and never before have I felt such elation!

Last night as dusk approached, the orcish armies began to prepare a major attack. My men were ready, for I was determined that if they were to have our lives they would pay for them thrice over. But as the sun waned in the western sky I saw what looked like a rain of gold falling amongst the orcish troops and suddenly they were in disarray. Another flurry came and I saw that it were not gold, but bolts of steel reflected in the setting sun. "The halflings!" my scout shouted, and lo I saw then it was indeed a large army of halflings come upon the orcs' flank.

The orcish army suddenly forgot about us, turning upon their new enemy. But foolish is any who ignores the wrath of a caged lion which sees its chance for vengeance! I led my men immediately into battle, taking the enemy swiftly from the rear, and throwing their organisation into madness. When the halfling army came upon their flank it was a massacre, and we drove them mercilessly towards the southern lake. There upon the shores we beat them to the last number, and their blood stained the water a horrific black.

Our victory sealed, I immediately met with the halfling leader, and found it to be no less than the princess Mirvenia! Truly words cannot express my joy when I saw her face flushed red in the last embers of the setting sun. I almost felt... no, I should not think such things.]], [[#{italic}#51st of Haze, Year of Pyre 710#{normal}#
Oh, happy days! Joyous retribution! From the jaws of defeat we have been saved, and never before have I felt such elation!

Last night as dusk approached, the orcish armies began to prepare a major attack. My men were ready, for I was determined that if they were to have our lives they would pay for them thrice over. But as the sun waned in the western sky I saw what looked like a rain of gold falling amongst the orcish troops and suddenly they were in disarray. Another flurry came and I saw that it were not gold, but bolts of steel reflected in the setting sun. "The halflings!" my scout shouted, and lo I saw then it was indeed a large army of halflings come upon the orcs' flank.

The orcish army suddenly forgot about us, turning upon their new enemy. But foolish is any who ignores the wrath of a caged lion which sees its chance for vengeance! I led my men immediately into battle, taking the enemy swiftly from the rear, and throwing their organisation into madness. When the halfling army came upon their flank it was a massacre, and we drove them mercilessly towards the southern lake. There upon the shores we beat them to the last number, and their blood stained the water a horrific black.

Our victory sealed, I immediately met with the halfling leader, and found it to be no less than the princess Mirvenia! Truly words cannot express my joy when I saw her face flushed red in the last embers of the setting sun. I almost felt... no, I should not think such things.]], "_t")
t([[#{italic}#2nd of Allure, Year of Pyre 711#{normal}#
We have solidified the defences at Last Hope and received more troops from all of the kingdoms. Our tactical position near the sea is proving an excellent base for further attacks on the orcs. I hope to expand our facilities here much further. I am drawing up an alliance now with the other leaders, for only together can we hope to beat this terrible threat to all our kingdoms.

Mirvenia has been key to the discussions and the plans. She is a tactical genius, and I am constantly amazed by her wealth of knowledge and skills. There is an odd woman that accompanies her though, with long fiery hair and a silken robe - Linaniil is her name. One of my men swears he saw her riding into battle in a blaze of flames, burning all the orcs before her. The idea of a spellweaver in our midst is unsettling, but Mirvenia says I should trust her. And if Mirvenia says so then I must believe her.

She is a remarkable force for good, Mirvenia, popular with all the troops. I feel my normal iron rule smoothed by her presence. Too long have I led the cold life of a soldier... alone...

Ah, the beating of my heart cannot be silenced. I must speak to Mirvenia, and tell her how I feel... I only hope she shares some inkling of my emotion.]], [[#{italic}#2nd of Allure, Year of Pyre 711#{normal}#
We have solidified the defences at Last Hope and received more troops from all of the kingdoms. Our tactical position near the sea is proving an excellent base for further attacks on the orcs. I hope to expand our facilities here much further. I am drawing up an alliance now with the other leaders, for only together can we hope to beat this terrible threat to all our kingdoms.

Mirvenia has been key to the discussions and the plans. She is a tactical genius, and I am constantly amazed by her wealth of knowledge and skills. There is an odd woman that accompanies her though, with long fiery hair and a silken robe - Linaniil is her name. One of my men swears he saw her riding into battle in a blaze of flames, burning all the orcs before her. The idea of a spellweaver in our midst is unsettling, but Mirvenia says I should trust her. And if Mirvenia says so then I must believe her.

She is a remarkable force for good, Mirvenia, popular with all the troops. I feel my normal iron rule smoothed by her presence. Too long have I led the cold life of a soldier... alone...

Ah, the beating of my heart cannot be silenced. I must speak to Mirvenia, and tell her how I feel... I only hope she shares some inkling of my emotion.]], "_t")
t([[#{italic}#6th of Flare, Year of Pyre 713#{normal}#
Why is it only in times of darkness I turn to my journal? Today has been the darkest day in over two years, but it could have been darker still.

Mirvenia's convoy was attacked by a rogue band of orcs. Though the brutes were repelled she was hurt in the conflict, and her labour brought on early. She lay before the halls of death for many hours. It is only thanks to the skill of her people's healers that she and the baby survived.

The baby... our baby. My son! Mirvenia is still recovering, but the boy seems hale as any freshly-born child. But still I worry... How I wish that he were born into a more perfect world. How I worry for my wife and child in this age of suffering. I want to make a new age for them, free from such threats as almost took away the woman I love. I want to give my son the chance to reign in an era of peace.

Too long have we been content with repelling orcish raids and pushing back small tribes. Last Hope is now a gleaming city, and a focal point for all the armies of the west. Now is the time for us to drive forward and root out every orcish colony on the continent. I will not rest until Maj'Eyal is free from their vile influence, till every accursed brood is burned to ashes and every pig-spawn orc is cast from existence. I shall end this terrible Age of Pyre and usher in a new Age of Ascendancy! This I do solemnly swear.]], [[#{italic}#6th of Flare, Year of Pyre 713#{normal}#
Why is it only in times of darkness I turn to my journal? Today has been the darkest day in over two years, but it could have been darker still.

Mirvenia's convoy was attacked by a rogue band of orcs. Though the brutes were repelled she was hurt in the conflict, and her labour brought on early. She lay before the halls of death for many hours. It is only thanks to the skill of her people's healers that she and the baby survived.

The baby... our baby. My son! Mirvenia is still recovering, but the boy seems hale as any freshly-born child. But still I worry... How I wish that he were born into a more perfect world. How I worry for my wife and child in this age of suffering. I want to make a new age for them, free from such threats as almost took away the woman I love. I want to give my son the chance to reign in an era of peace.

Too long have we been content with repelling orcish raids and pushing back small tribes. Last Hope is now a gleaming city, and a focal point for all the armies of the west. Now is the time for us to drive forward and root out every orcish colony on the continent. I will not rest until Maj'Eyal is free from their vile influence, till every accursed brood is burned to ashes and every pig-spawn orc is cast from existence. I shall end this terrible Age of Pyre and usher in a new Age of Ascendancy! This I do solemnly swear.]], "_t")
t("All Hail King Tolak the Fair!", "All Hail King Tolak the Fair!", "_t")
t([[Twice blessed is he of the union of King Toknor of the humans and Queen Mirvenia of the halflings! Praise his glory!
By royal decree it is under absolute conditions forbidden to show racial prejudice against humans or halflings. There shall be no preference of price or service, and no discrimination of trade or business or employment. No halfling shall be named fur-toes, midget or shortbum, and no human shall be named lanklegs, cloudhead or stumpfoot.
The penalty for disobedience shall be flogging. Intolerance will not be tolerated!]], [[Twice blessed is he of the union of King Toknor of the humans and Queen Mirvenia of the halflings! Praise his glory!
By royal decree it is under absolute conditions forbidden to show racial prejudice against humans or halflings. There shall be no preference of price or service, and no discrimination of trade or business or employment. No halfling shall be named fur-toes, midget or shortbum, and no human shall be named lanklegs, cloudhead or stumpfoot.
The penalty for disobedience shall be flogging. Intolerance will not be tolerated!]], "_t")
t("All Hail King Toknor the Brave!", "All Hail King Toknor the Brave!", "_t")
t([[Born the 23th Allure, Year of Pyre 682
Died the 2th Summertide, Year of Ascendancy 108

King of Kings, Founder of Last Hope, Purger of Orcs, Father of the Age of Ascendancy. Great is the memory of the warrior who fought for peace, and won.
Quoth King Toknor: "I have lived for the future, a future of peace and prosperity, a future free for all. How happy I am to see that future now... Aye, and it is brighter than any sword, and stronger than any armour, and more enduring than any war. Though warrior I am in flesh and mind, my heart belongs to peace."]], [[Born the 23th Allure, Year of Pyre 682
Died the 2th Summertide, Year of Ascendancy 108

King of Kings, Founder of Last Hope, Purger of Orcs, Father of the Age of Ascendancy. Great is the memory of the warrior who fought for peace, and won.
Quoth King Toknor: "I have lived for the future, a future of peace and prosperity, a future free for all. How happy I am to see that future now... Aye, and it is brighter than any sword, and stronger than any armour, and more enduring than any war. Though warrior I am in flesh and mind, my heart belongs to peace."]], "_t")
t("All Hail Queen Mirvenia the Inspirer!", "All Hail Queen Mirvenia the Inspirer!", "_t")
t([[Born the 5th Flare, Year of Pyre 688
Died the 2th Summertide, Year of Ascendancy 113

Saviour of the Battle of Last Hope, Bringer of Unity, Soother of Hearts and Minds. Greatly is missed the alchemist that could change sorrow to joy, despair to hope, defeat to victory.
Quoth Queen Mirvenia: "Nothing moves me more than seeing the sun set over Last Hope, seeing all the joy and beauty we have brought here bathed in glorious light. At moments like this I still feel him next to me, and I know I have lived a good life. Today has been a good day... Today I think I shall die."]], [[Born the 5th Flare, Year of Pyre 688
Died the 2th Summertide, Year of Ascendancy 113

Saviour of the Battle of Last Hope, Bringer of Unity, Soother of Hearts and Minds. Greatly is missed the alchemist that could change sorrow to joy, despair to hope, defeat to victory.
Quoth Queen Mirvenia: "Nothing moves me more than seeing the sun set over Last Hope, seeing all the joy and beauty we have brought here bathed in glorious light. At moments like this I still feel him next to me, and I know I have lived a good life. Today has been a good day... Today I think I shall die."]], "_t")
t([[#{italic}#A study into Southspar's most unusual ruler.#{normal}#

Chances are you haven't heard of Southspar.

And why would you have? It was naught but a tiny, provincial island kingdom off the coast of Tar'Eyal that existed within the Ages of Allure and Dusk. By all accounts, Southspar was a pleasant place to live; temperate climate, healthy trade relations with mainland human kingdoms, and by great luck, the island upon which the kingdom sat held great deposits of the much-valued metal stralite.

Despite this good fortune though, Southspar was doomed to mediocrity. Why? The actions of its ruler. By all accounts a bumbling, octogenarian dotard, his name lost to the mists of time, this mouldy monarch mismanaged Southspar almost to its demise. The Dwarves of the Iron Throne, having heard of the stralite beneath the island, manipulated the king into mining it and selling it to them for a fraction of its true worth. Also, despite Southspar's decidedly puny military power, the king saw fit to send whatever troops he could muster to aid mainland human kingdoms in their great and many wars against the halflings, who up to this point had barely registered Southspar's existence. Not only were the undertrained, ill-equipped troops crushed like vermin before the superior halfling forces, but also these foolhardy attacks succeeded in attracting the halflings' attention to their secluded island. Almost immediately, the raids began.

From what records remain, the king was mystified by the decline of his nation, believing to the end that every action he took had been the right one. He passed away soon after the halfling raids began. Whether it was suicide, assassination, or simple old age is unknown. The king never married and had no children, the only remaining member of his family being a distant cousin, a young man named Drake.

And so it was that Drake ascended to the throne, and Southspar entered a golden age.

#{bold}#1. Drake and the Halfling Horde.#{normal}#

To the newly crowned Drake, the most obvious and immediate threat to Southspar was the growing raids and sorties being held by the halflings. To this end, he ordered a complete and total reconstruction of Southspar's military, turning them from a ragtag bunch of militia into a small yet devastatingly efficient engine of war. Drake knew that the only advantage his forces held over the halflings was their knowledge of the island, and so bade them to travel stealthily, carry small, armour-defeating stralite knives rather than spears and swords, and only engage with the halflings strictly on their own terms. Southspar's newly assembled "Army of Rogues" was a success. Although the halflings were great in number, strike after surgical strike from Drake's army weighed heavily on their morale, and finally, grumpily declaring Southspar "not worth the bother", the halfling forces withdrew.

Southspar celebrated its peace and its newly found military might, but for Drake, the celebration was short-lived. The stralite he had used to craft his Army of Rogues' knives and armour was stralite that wasn't going into the Dwarves' pockets, and they were far from happy. Drake formulated a plan - by the time he was through, the Dwarves would be even further from happy.

#{bold}#2. Drake and the Stralite Stratagem.#{normal}#

The Dwarves have always been a secretive race. Even now only a select few know the location of their "Iron Council", and in the days of Southspar there were still those who considered Dwarves nothing but myth. Being a monarch in possession of large amounts of stralite can open even the most concealed of doors, however... Drake had requested an audience with the Iron Council, and the Dwarves, expecting said audience to be a humble apology and promises of further stralite for the gold they were paying, readily accepted.

What they got, in reality, was quite different. Gone was the ineffectual king of Southspar's past, and now the Dwarves found themselves facing a young, hard-eyed human who was demanding that the amount of gold that the Dwarves were paying for Southspar's stralite be increased twenty-fold.

To say the Dwarves scoffed at this would be an understatement; open, derisive laughter hits nearer the mark. Despite Southspar's recent repulsion of the halflings, the Dwarves of the Iron Throne saw no problem in taking Southspar's stralite by force. In his heart, Drake knew they could accomplish this, and it was to this end that he had brought the small pouch around his neck to the Council.

Drake held the small, drakeskin pouch high, opened it and emptied its contents onto the floor: Stralite, ground to dust, muddied with dirt and base metals, made unusable and worthless. The Dwarves of the Council gasped in horror at this waste, one (if rumours are to be believed) even fainting on the spot. Drake went on to say that, if his demands were not met, the entirety of the stralite beneath his island would meet the same fate as the stralite cast upon the chamber's floor.

By the time Drake left the Iron Council, the Dwarves had agreed to pay thirty times the previous amount.
]], [[#{italic}#A study into Southspar's most unusual ruler.#{normal}#

Chances are you haven't heard of Southspar.

And why would you have? It was naught but a tiny, provincial island kingdom off the coast of Tar'Eyal that existed within the Ages of Allure and Dusk. By all accounts, Southspar was a pleasant place to live; temperate climate, healthy trade relations with mainland human kingdoms, and by great luck, the island upon which the kingdom sat held great deposits of the much-valued metal stralite.

Despite this good fortune though, Southspar was doomed to mediocrity. Why? The actions of its ruler. By all accounts a bumbling, octogenarian dotard, his name lost to the mists of time, this mouldy monarch mismanaged Southspar almost to its demise. The Dwarves of the Iron Throne, having heard of the stralite beneath the island, manipulated the king into mining it and selling it to them for a fraction of its true worth. Also, despite Southspar's decidedly puny military power, the king saw fit to send whatever troops he could muster to aid mainland human kingdoms in their great and many wars against the halflings, who up to this point had barely registered Southspar's existence. Not only were the undertrained, ill-equipped troops crushed like vermin before the superior halfling forces, but also these foolhardy attacks succeeded in attracting the halflings' attention to their secluded island. Almost immediately, the raids began.

From what records remain, the king was mystified by the decline of his nation, believing to the end that every action he took had been the right one. He passed away soon after the halfling raids began. Whether it was suicide, assassination, or simple old age is unknown. The king never married and had no children, the only remaining member of his family being a distant cousin, a young man named Drake.

And so it was that Drake ascended to the throne, and Southspar entered a golden age.

#{bold}#1. Drake and the Halfling Horde.#{normal}#

To the newly crowned Drake, the most obvious and immediate threat to Southspar was the growing raids and sorties being held by the halflings. To this end, he ordered a complete and total reconstruction of Southspar's military, turning them from a ragtag bunch of militia into a small yet devastatingly efficient engine of war. Drake knew that the only advantage his forces held over the halflings was their knowledge of the island, and so bade them to travel stealthily, carry small, armour-defeating stralite knives rather than spears and swords, and only engage with the halflings strictly on their own terms. Southspar's newly assembled "Army of Rogues" was a success. Although the halflings were great in number, strike after surgical strike from Drake's army weighed heavily on their morale, and finally, grumpily declaring Southspar "not worth the bother", the halfling forces withdrew.

Southspar celebrated its peace and its newly found military might, but for Drake, the celebration was short-lived. The stralite he had used to craft his Army of Rogues' knives and armour was stralite that wasn't going into the Dwarves' pockets, and they were far from happy. Drake formulated a plan - by the time he was through, the Dwarves would be even further from happy.

#{bold}#2. Drake and the Stralite Stratagem.#{normal}#

The Dwarves have always been a secretive race. Even now only a select few know the location of their "Iron Council", and in the days of Southspar there were still those who considered Dwarves nothing but myth. Being a monarch in possession of large amounts of stralite can open even the most concealed of doors, however... Drake had requested an audience with the Iron Council, and the Dwarves, expecting said audience to be a humble apology and promises of further stralite for the gold they were paying, readily accepted.

What they got, in reality, was quite different. Gone was the ineffectual king of Southspar's past, and now the Dwarves found themselves facing a young, hard-eyed human who was demanding that the amount of gold that the Dwarves were paying for Southspar's stralite be increased twenty-fold.

To say the Dwarves scoffed at this would be an understatement; open, derisive laughter hits nearer the mark. Despite Southspar's recent repulsion of the halflings, the Dwarves of the Iron Throne saw no problem in taking Southspar's stralite by force. In his heart, Drake knew they could accomplish this, and it was to this end that he had brought the small pouch around his neck to the Council.

Drake held the small, drakeskin pouch high, opened it and emptied its contents onto the floor: Stralite, ground to dust, muddied with dirt and base metals, made unusable and worthless. The Dwarves of the Council gasped in horror at this waste, one (if rumours are to be believed) even fainting on the spot. Drake went on to say that, if his demands were not met, the entirety of the stralite beneath his island would meet the same fate as the stralite cast upon the chamber's floor.

By the time Drake left the Iron Council, the Dwarves had agreed to pay thirty times the previous amount.
]], "_t")
t([[#{bold}#3. Drake and the Conclave Mages.#{normal}#

With its borders unassailed, ands its coffers rapidly filling with Dwarven gold, many believed that the fortune of Southspar could not increase any further. Drake, however, had one last task to accomplish, and it regarded the Conclave.

For a long time, a small number of Conclave mages had made their home in Southspar. The remote location and the doddering nature of its old king meant that they could perform experiments and practice magic that would have been disallowed on the mainland. Being reclusive by nature, only a few of their group had heard of the rise of the new king, and none of them had cared much. Drake's royal guards breaking down the door of their study, followed by the king himself, gave them cause to care. Drake had for them an ultimatum:

"This is the kingdom of Southspar, my kingdom, and so everything within her borders must be within my control. This applies to her people, her land, her resources, and now her magic. I shall allow you to remain here in Southspar on one condition: You become members of my royal court, obey my commands, and use your magic for the betterment of the kingdom. When un-needed you may tend to your Conclave matters as you will, but your greatest loyalty will be to me. Do you accept?"

The Conclave mages' response? Laughter. But this laughter was not the mocking laughter of the Dwarves, but laughter of disbelief. As recorded, the mages' response went as:

"King Drake! You needn't have bothered us with such a stern ultimatum! A simple request would have sufficed. True, in the past we may have chosen to reside here for simple seclusion, but it is hard to ignore Southspar's rising star. This kingdom's glory shall continue to grow, and we want to be a part of it. We accept."

Freedom from halfling attacks, Dwarven fortunes, and now the magic of the Conclave blessed Southspar. What, the common people thought, could possibly happen next?

Mere weeks after the Conclave joined the royal court, Drake fell ill and died.

#{bold}#4. Drake and the Empty Throne.#{normal}#

Drake was dead, and Southspar's people were struck with depression and outright horror. Their king, who was fast on his way to making their kingdom one of the greatest in Maj'Eyal, was no more. The throne lay empty; not a single soul vied for the now vacant position of king. As far as Southspar's citizens were concerned, it was Drake's throne, nobody else's.

The norm in tales like this would be that the kingdom slowly managed to get back on its feet, recover from the loss of their king, and finally return to a state resembling normalcy. Not so for Southspar. Drake's demise had left a wound that was not healing, and it was clear that something had to be done. One of the men closest to Drake in his life, his chancellor, left abruptly on a mysterious "errand", hoping that the kingdom would not crumble before his return. After a period of some months he did return, and his first port of call? The study of the Conclave mages. He held in his hand a tome, bound in skin and marked with blood-red runes. Its subject matter was obvious: Necromancy. The chancellor had but one command for the mages:

"Bring him back."

#{bold}#5. Drake and the Pale Kingdom.#{normal}#

Here, sadly, definitive facts on Southspar and Drake's fate vanish. Some say that Drake's rebirth was a resounding success, and Southspar's star continued to rise as the now skeletal Drake retook the throne, the gaze from his exposed skull unchanged from his mortal visage. Others believe that the madness that grasps those returned from the grave took him, and with the new powers that the Conclave had blessed him with began a reign of terror that drowned Southspar in blood. The only fact that can be known for certain was the new name his subjects gave to him in his death: Pale King Drake, the Pale King, or simply Pale Drake.

I leave you with a copy of one of the last pieces of Southspar's history, a partially destroyed scrap of parchment, supposedly written moments before the Cataclysm and Southspar's destruction, falling beneath the waves along with the rest of Tar'Eyal.

"Time grows pressi... ... ome in the boat... ... found. The binding w... a success. Now, to the sea, to l... ... ew, and Dreadfe... ... oble king. Rot in my new du... as you will!"]], [[#{bold}#3. Drake and the Conclave Mages.#{normal}#

With its borders unassailed, ands its coffers rapidly filling with Dwarven gold, many believed that the fortune of Southspar could not increase any further. Drake, however, had one last task to accomplish, and it regarded the Conclave.

For a long time, a small number of Conclave mages had made their home in Southspar. The remote location and the doddering nature of its old king meant that they could perform experiments and practice magic that would have been disallowed on the mainland. Being reclusive by nature, only a few of their group had heard of the rise of the new king, and none of them had cared much. Drake's royal guards breaking down the door of their study, followed by the king himself, gave them cause to care. Drake had for them an ultimatum:

"This is the kingdom of Southspar, my kingdom, and so everything within her borders must be within my control. This applies to her people, her land, her resources, and now her magic. I shall allow you to remain here in Southspar on one condition: You become members of my royal court, obey my commands, and use your magic for the betterment of the kingdom. When un-needed you may tend to your Conclave matters as you will, but your greatest loyalty will be to me. Do you accept?"

The Conclave mages' response? Laughter. But this laughter was not the mocking laughter of the Dwarves, but laughter of disbelief. As recorded, the mages' response went as:

"King Drake! You needn't have bothered us with such a stern ultimatum! A simple request would have sufficed. True, in the past we may have chosen to reside here for simple seclusion, but it is hard to ignore Southspar's rising star. This kingdom's glory shall continue to grow, and we want to be a part of it. We accept."

Freedom from halfling attacks, Dwarven fortunes, and now the magic of the Conclave blessed Southspar. What, the common people thought, could possibly happen next?

Mere weeks after the Conclave joined the royal court, Drake fell ill and died.

#{bold}#4. Drake and the Empty Throne.#{normal}#

Drake was dead, and Southspar's people were struck with depression and outright horror. Their king, who was fast on his way to making their kingdom one of the greatest in Maj'Eyal, was no more. The throne lay empty; not a single soul vied for the now vacant position of king. As far as Southspar's citizens were concerned, it was Drake's throne, nobody else's.

The norm in tales like this would be that the kingdom slowly managed to get back on its feet, recover from the loss of their king, and finally return to a state resembling normalcy. Not so for Southspar. Drake's demise had left a wound that was not healing, and it was clear that something had to be done. One of the men closest to Drake in his life, his chancellor, left abruptly on a mysterious "errand", hoping that the kingdom would not crumble before his return. After a period of some months he did return, and his first port of call? The study of the Conclave mages. He held in his hand a tome, bound in skin and marked with blood-red runes. Its subject matter was obvious: Necromancy. The chancellor had but one command for the mages:

"Bring him back."

#{bold}#5. Drake and the Pale Kingdom.#{normal}#

Here, sadly, definitive facts on Southspar and Drake's fate vanish. Some say that Drake's rebirth was a resounding success, and Southspar's star continued to rise as the now skeletal Drake retook the throne, the gaze from his exposed skull unchanged from his mortal visage. Others believe that the madness that grasps those returned from the grave took him, and with the new powers that the Conclave had blessed him with began a reign of terror that drowned Southspar in blood. The only fact that can be known for certain was the new name his subjects gave to him in his death: Pale King Drake, the Pale King, or simply Pale Drake.

I leave you with a copy of one of the last pieces of Southspar's history, a partially destroyed scrap of parchment, supposedly written moments before the Cataclysm and Southspar's destruction, falling beneath the waves along with the rest of Tar'Eyal.

"Time grows pressi... ... ome in the boat... ... found. The binding w... a success. Now, to the sea, to l... ... ew, and Dreadfe... ... oble king. Rot in my new du... as you will!"]], "_t")
t([[Herewith is set the constitutional declaration of the Allied Kingdoms under the rule of King Toknor and Queen Mirvenia. Any who defy or seek to undermine the laws here set shall suffer torment and death.

As of the 1st of Allure, Age of Pyre year 714, henceforth to be known as the Age of Ascendancy year 1, all human and halfling kingdoms shall be united under the banner of the Allied Kingdoms. This shall include all towns, villages, serfdoms and farmsteads with over 50% human or halfling populace in the whole expanse of Maj'Eyal.

The Allied Kingdoms shall be presided over by the rule of King Toknor and Queen Mirvenia, long may their line endure. Their throne and residency shall be held in the citadel of Last Hope, and here also shall be seated all administrative and military offices. Free trade shall be established between all elements of the Allied Kingdoms, and central taxation shall be administered by the Royal Treasury. All lands within the Allied Kingdoms shall be regularly patrolled by official guards to enforce the peace. One rule and one law shall be applied to all.

This unification shall make our lands stronger, more whole. Too long have we suffered under the shadows of invasion and terror. Too long have we been splintered, broken by petty infighting. But now we shirk off the failures of the past, and with one strong rule, one unbreakable alliance, we shall all prosper and find peace. Together we shall fight back against the darkness, and an age of light shall be born. We will fear the night no more.

To those who oppose this, let thee be afeared, for a new dawn is rising and it shall suffer no obstruction. This Alliance and the era it brings shall be protected at all costs. Treason will not be tolerated, and divisors will be damned. All shall follow the rule of Toknor and Mirvenia, or face the righteous wrath of a new age.

All hail the reign of King Toknor and Queen Mirvenia! All hail the Allied Kingdoms! All hail the Age of Ascendancy!]], [[Herewith is set the constitutional declaration of the Allied Kingdoms under the rule of King Toknor and Queen Mirvenia. Any who defy or seek to undermine the laws here set shall suffer torment and death.

As of the 1st of Allure, Age of Pyre year 714, henceforth to be known as the Age of Ascendancy year 1, all human and halfling kingdoms shall be united under the banner of the Allied Kingdoms. This shall include all towns, villages, serfdoms and farmsteads with over 50% human or halfling populace in the whole expanse of Maj'Eyal.

The Allied Kingdoms shall be presided over by the rule of King Toknor and Queen Mirvenia, long may their line endure. Their throne and residency shall be held in the citadel of Last Hope, and here also shall be seated all administrative and military offices. Free trade shall be established between all elements of the Allied Kingdoms, and central taxation shall be administered by the Royal Treasury. All lands within the Allied Kingdoms shall be regularly patrolled by official guards to enforce the peace. One rule and one law shall be applied to all.

This unification shall make our lands stronger, more whole. Too long have we suffered under the shadows of invasion and terror. Too long have we been splintered, broken by petty infighting. But now we shirk off the failures of the past, and with one strong rule, one unbreakable alliance, we shall all prosper and find peace. Together we shall fight back against the darkness, and an age of light shall be born. We will fear the night no more.

To those who oppose this, let thee be afeared, for a new dawn is rising and it shall suffer no obstruction. This Alliance and the era it brings shall be protected at all costs. Treason will not be tolerated, and divisors will be damned. All shall follow the rule of Toknor and Mirvenia, or face the righteous wrath of a new age.

All hail the reign of King Toknor and Queen Mirvenia! All hail the Allied Kingdoms! All hail the Age of Ascendancy!]], "_t")
t([[The Oceans of Eyal represent a frontier which we have been powerless to break. In spite of advanced craft and skill, and even the more forbidden areas of magic, there are natural barriers that we simply cannot overcome. Long range seafaring has become seen as unprofitable and a fruitless endeavour. The last great ship to be built was the Vanguard, over a thousand years ago, which disappeared over the eastern horizon and was never seen again.

Yet we know that the Sher’Tul once travelled the whole globe, that records exist from our younger days of other continents, of sailing routes that go right round the whole of Eyal. How it stirs my heart to think of the unexplored lands that lie beyond our stormy coasts!

Alas, records from the time of the Spellblaze and the Cataclysm show that those old routes can no longer be traversed. A reshaping of currents, an increase in storms and a greater abundance of dangerous sea creatures have all locked us onto the continent of Maj’Eyal.

Yet my desire for knowledge is not sated. I spoke some time ago with an old fisherman - a halfling sea dog with a crusty beard, hideous scars, and the foul stench of stale ale all about him. Inbetween the wretched smelling breaths from his toothless mouth he told me some valuable information. I transcribe it as best I can here:

“Nay, ya’ll not get long out b’ond coast thar. In th’orth ya’ll run inta ice floes, miles wide stretches at’ll close in on ya and crush yar hull fro’neath. Out west be a field o’ storms, cyclones and hur’canes tha’ll swaller up any ‘at go near. And out east... ack, out east be th’orst. Nagas and sea dragons, switchin’ currents and ocean rifts, storms of hate like y’never seen in yar worst nightmares. As fer south, well tha’s best spot fer fishin’ and the like, we gots some good patches thar. But venture too far and ya meet a... I ‘unno, some magicy barrier or whatnot. Ships hit ‘gainst it like a wall o’ air. Go too fast and ya smash yar prow apart! And out b’ond it... some cloud of darkness lies on t’rizon. We stays clear o’ that, I tells ya.”

It’s a remarkable report, and one I’m minded to believe, in spite of the notorious unreliability of seafarer tales. South was once the continent of Tar’Eyal, said to be a desert-smothered land full of wild energies. What fate has swallowed it from our access now is hard to say. But my curiosity is sorely piqued, and I shall endeavour to charter a ship to investigate this strange barrier to the south. Likely the lesser races that crew these vessels would balk at such an enterprise, but I’m sure that with the leadership and influence of a Higher like myself I can persuade them to have a little more backbone.

- Lord Estevan Asimir

#{italic}#Footnote: After this paper was published Lord Asimir was found dead and stripped of all valuables in one of the ports of Last Hope.#{normal}#]], [[The Oceans of Eyal represent a frontier which we have been powerless to break. In spite of advanced craft and skill, and even the more forbidden areas of magic, there are natural barriers that we simply cannot overcome. Long range seafaring has become seen as unprofitable and a fruitless endeavour. The last great ship to be built was the Vanguard, over a thousand years ago, which disappeared over the eastern horizon and was never seen again.

Yet we know that the Sher’Tul once travelled the whole globe, that records exist from our younger days of other continents, of sailing routes that go right round the whole of Eyal. How it stirs my heart to think of the unexplored lands that lie beyond our stormy coasts!

Alas, records from the time of the Spellblaze and the Cataclysm show that those old routes can no longer be traversed. A reshaping of currents, an increase in storms and a greater abundance of dangerous sea creatures have all locked us onto the continent of Maj’Eyal.

Yet my desire for knowledge is not sated. I spoke some time ago with an old fisherman - a halfling sea dog with a crusty beard, hideous scars, and the foul stench of stale ale all about him. Inbetween the wretched smelling breaths from his toothless mouth he told me some valuable information. I transcribe it as best I can here:

“Nay, ya’ll not get long out b’ond coast thar. In th’orth ya’ll run inta ice floes, miles wide stretches at’ll close in on ya and crush yar hull fro’neath. Out west be a field o’ storms, cyclones and hur’canes tha’ll swaller up any ‘at go near. And out east... ack, out east be th’orst. Nagas and sea dragons, switchin’ currents and ocean rifts, storms of hate like y’never seen in yar worst nightmares. As fer south, well tha’s best spot fer fishin’ and the like, we gots some good patches thar. But venture too far and ya meet a... I ‘unno, some magicy barrier or whatnot. Ships hit ‘gainst it like a wall o’ air. Go too fast and ya smash yar prow apart! And out b’ond it... some cloud of darkness lies on t’rizon. We stays clear o’ that, I tells ya.”

It’s a remarkable report, and one I’m minded to believe, in spite of the notorious unreliability of seafarer tales. South was once the continent of Tar’Eyal, said to be a desert-smothered land full of wild energies. What fate has swallowed it from our access now is hard to say. But my curiosity is sorely piqued, and I shall endeavour to charter a ship to investigate this strange barrier to the south. Likely the lesser races that crew these vessels would balk at such an enterprise, but I’m sure that with the leadership and influence of a Higher like myself I can persuade them to have a little more backbone.

- Lord Estevan Asimir

#{italic}#Footnote: After this paper was published Lord Asimir was found dead and stripped of all valuables in one of the ports of Last Hope.#{normal}#]], "_t")
t("last hope", "last hope", "newLore category")
t("A creased letter", "A creased letter", "_t")
t([[Oh Cecil, what must you think of me? But I remember your words to me, before the fever took you - you told me to live. And live I must... And yet that fever has now spread to me and I feel my days are numbered.

I have a confession to make, my love. Those tinctures I brewed for you towards the end of your disease, those that helped you stay in my arms a few weeks longer, they were not my regular alchemy. In desperation I turned to darker arts in my obsession to save you. But though they kept your eyes open for a little longer, they could not keep you here with me.

How desperately I yearn for you... At nights the pain of my disease tears me apart, yet I could bear it all if only you were by my side. But alone I have not the strength, and the dark thoughts return. My obsession remains.

You would frown were you to see the things I have done. You would be sickened! I cringe each time I think of what your reaction would be to see me now. But please understand, my dear, please forgive me. For I must live! Though each morning I grow weaker, my determination to survive hardens. And it is not just for me...

Amidst this darkness I have good news for you, my darling. I am with child. Though you have died your blood still lives in me, and even as my own flesh withers I can feel our baby blossoming within my womb. It is for this I carry on my experiments, gruesome as they be. It is for our child I struggle with hardened heart to extend my life ever further.

I am cold and alone in this chilly crypt, thinking back on my times of warmth with you. Abominations lie beyond the walls, their haunting cries torturing my ears, reminding me of the black deeds I have performed. But every now and then I feel a gentle kick, and my resolve is stiffened, and to my experiments I return.

I must live. For you, my love, I will live.]], [[Oh Cecil, what must you think of me? But I remember your words to me, before the fever took you - you told me to live. And live I must... And yet that fever has now spread to me and I feel my days are numbered.

I have a confession to make, my love. Those tinctures I brewed for you towards the end of your disease, those that helped you stay in my arms a few weeks longer, they were not my regular alchemy. In desperation I turned to darker arts in my obsession to save you. But though they kept your eyes open for a little longer, they could not keep you here with me.

How desperately I yearn for you... At nights the pain of my disease tears me apart, yet I could bear it all if only you were by my side. But alone I have not the strength, and the dark thoughts return. My obsession remains.

You would frown were you to see the things I have done. You would be sickened! I cringe each time I think of what your reaction would be to see me now. But please understand, my dear, please forgive me. For I must live! Though each morning I grow weaker, my determination to survive hardens. And it is not just for me...

Amidst this darkness I have good news for you, my darling. I am with child. Though you have died your blood still lives in me, and even as my own flesh withers I can feel our baby blossoming within my womb. It is for this I carry on my experiments, gruesome as they be. It is for our child I struggle with hardened heart to extend my life ever further.

I am cold and alone in this chilly crypt, thinking back on my times of warmth with you. Abominations lie beyond the walls, their haunting cries torturing my ears, reminding me of the black deeds I have performed. But every now and then I feel a gentle kick, and my resolve is stiffened, and to my experiments I return.

I must live. For you, my love, I will live.]], "_t")
t([[#{bold}#
Here lies Jake, son of Borlin and Clarise
#{normal}#112 - 118#{italic}#
Rest well, our child
This world was too dark for thee
#{normal}#]], [[#{bold}#
Here lies Jake, son of Borlin and Clarise
#{normal}#112 - 118#{italic}#
Rest well, our child
This world was too dark for thee
#{normal}#]], "_t")
t([[#{bold}#
Here lies Alenda and Pariel
#{normal}#92 - 115, 94 - 115#{italic}#
In sin you lived
In sin you died
Rot here together
#{normal}#]], [[#{bold}#
Here lies Alenda and Pariel
#{normal}#92 - 115, 94 - 115#{italic}#
In sin you lived
In sin you died
Rot here together
#{normal}#]], "_t")
t([[#{bold}#
Marcus the Immortal
#{normal}#23 - 107#{italic}#
Ambitious in life
Humbled in death
#{normal}#]], [[#{bold}#
Marcus the Immortal
#{normal}#23 - 107#{italic}#
Ambitious in life
Humbled in death
#{normal}#]], "_t")
t([[#{bold}#
Lord Gracion Bestelle
#{normal}#41 - 112#{italic}#
The memory of the greatest
Shall never dim
#{normal}#]], [[#{bold}#
Lord Gracion Bestelle
#{normal}#41 - 112#{italic}#
The memory of the greatest
Shall never dim
#{normal}#]], "_t")
t([[#{bold}#
Inilasac Salocin
#{normal}#32 - 120#{italic}#
All tomes shall remember thee
And thine dark blessings
#{normal}#]], [[#{bold}#
Inilasac Salocin
#{normal}#32 - 120#{italic}#
All tomes shall remember thee
And thine dark blessings
#{normal}#]], "_t")
t([[#{bold}#
RIP Cecil Farion
#{normal}#98 - 122#{italic}#
Noble in mind
Pure in spirit
Rest now from the burdens of the flesh

#{normal}#A fresh rose lies here]], [[#{bold}#
RIP Cecil Farion
#{normal}#98 - 122#{italic}#
Noble in mind
Pure in spirit
Rest now from the burdens of the flesh

#{normal}#A fresh rose lies here]], "_t")
t([[#{bold}#
Here lies Golan of Derth
#{normal}#65 - 113#{italic}#
May your memories
Always bring joy and love
#{normal}#]], [[#{bold}#
Here lies Golan of Derth
#{normal}#65 - 113#{italic}#
May your memories
Always bring joy and love
#{normal}#]], "_t")
t([[#{bold}#
Here lies Mara
#{normal}#70 - 109#{italic}#
You knew your doom
And faced it
Rest in peace
#{normal}#]], [[#{bold}#
Here lies Mara
#{normal}#70 - 109#{italic}#
You knew your doom
And faced it
Rest in peace
#{normal}#]], "_t")
t([[#{bold}#
Bodun the Follower
#{normal}#86 - 117#{italic}#
Killed by a friend's untimely death dance
#{normal}#]], [[#{bold}#
Bodun the Follower
#{normal}#86 - 117#{italic}#
Killed by a friend's untimely death dance
#{normal}#]], "_t")
t([[#{bold}#
Tania Pure-Hearted
#{normal}#78 - 115#{italic}#
Our tears are for ourselves
To have lost one so bright as you
#{normal}#]], [[#{bold}#
Tania Pure-Hearted
#{normal}#78 - 115#{italic}#
Our tears are for ourselves
To have lost one so bright as you
#{normal}#]], "_t")
t([[#{bold}#
Unknown
#{normal}#?? - 107#{italic}#
Your bravery will not be forgotten
#{normal}#]], [[#{bold}#
Unknown
#{normal}#?? - 107#{italic}#
Your bravery will not be forgotten
#{normal}#]], "_t")
t([[#{bold}#
Captain Lepant
#{normal}#56 - 102#{italic}#
A hero to all elements of society
#{normal}#]], [[#{bold}#
Captain Lepant
#{normal}#56 - 102#{italic}#
A hero to all elements of society
#{normal}#]], "_t")
t([[#{bold}#
Ghormot the Black
#{normal}#0 - 97#{italic}#
In this bright age
Of new adventures
You are not forgotten
#{normal}#]], [[#{bold}#
Ghormot the Black
#{normal}#0 - 97#{italic}#
In this bright age
Of new adventures
You are not forgotten
#{normal}#]], "_t")
t([[#{bold}#
Gygax the Great
#{normal}#38 - 108#{italic}#
Most blessed are we
To have shared this world with thee
#{normal}#]], [[#{bold}#
Gygax the Great
#{normal}#38 - 108#{italic}#
Most blessed are we
To have shared this world with thee
#{normal}#]], "_t")
t([[#{bold}#
Here lies Opius the Wastrel
#{normal}#89 - 117#{italic}#
Death was too good for you
May you quickly be forgotten
#{normal}#]], [[#{bold}#
Here lies Opius the Wastrel
#{normal}#89 - 117#{italic}#
Death was too good for you
May you quickly be forgotten
#{normal}#]], "_t")
t([[#{bold}#
Wichman Toy
#{normal}#80 - 121#{italic}#
Your rogueish charms
Inspire us forever
#{normal}#]], [[#{bold}#
Wichman Toy
#{normal}#80 - 121#{italic}#
Your rogueish charms
Inspire us forever
#{normal}#]], "_t")
t([[#{bold}#
Annei Caffrey
#{normal}#26 - 102#{italic}#
On the wings of dragons
You forever soar
#{normal}#]], [[#{bold}#
Annei Caffrey
#{normal}#26 - 102#{italic}#
On the wings of dragons
You forever soar
#{normal}#]], "_t")
t([[#{bold}#
Here lies Eden of Derth
#{normal}#97 - 121#{italic}#
Untamed in spirit
Unhesitant in flight
Unlifed in grimmest darkness
#{normal}#]], [[#{bold}#
Here lies Eden of Derth
#{normal}#97 - 121#{italic}#
Untamed in spirit
Unhesitant in flight
Unlifed in grimmest darkness
#{normal}#]], "_t")
t([[#{bold}#
Calici the Brave
#{normal}#86 - 113#{italic}#
Alas that bravery was not enough
#{normal}#]], [[#{bold}#
Calici the Brave
#{normal}#86 - 113#{italic}#
Alas that bravery was not enough
#{normal}#]], "_t")
t([[#{bold}#
Barbrim the Cursed
#{normal}#92 - 119#{italic}#
Betrayed by those he trusted
#{normal}#]], [[#{bold}#
Barbrim the Cursed
#{normal}#92 - 119#{italic}#
Betrayed by those he trusted
#{normal}#]], "_t")
t([[#{bold}#
Falsira Mageslayer
#{normal}#78 - 104#{italic}#
Slain by the dark magics she fought
We shall never forget
Death to the spellweavers!
#{normal}#]], [[#{bold}#
Falsira Mageslayer
#{normal}#78 - 104#{italic}#
Slain by the dark magics she fought
We shall never forget
Death to the spellweavers!
#{normal}#]], "_t")
t([[#{bold}#
Here lies Amalla
#{normal}#86 - 105#{italic}#
Burned for witchcraft
#{normal}#]], [[#{bold}#
Here lies Amalla
#{normal}#86 - 105#{italic}#
Burned for witchcraft
#{normal}#]], "_t")
t([[#{bold}#
Gamrik Dellhorn
#{normal}#47 - 93#{italic}#
Fell to the Wintertide blizzard
#{normal}#]], [[#{bold}#
Gamrik Dellhorn
#{normal}#47 - 93#{italic}#
Fell to the Wintertide blizzard
#{normal}#]], "_t")
t([[#{bold}#
Here lies Peterin
#{normal}#32 - 89#{italic}#
Died alone
#{normal}#]], [[#{bold}#
Here lies Peterin
#{normal}#32 - 89#{italic}#
Died alone
#{normal}#]], "_t")
t([[#{bold}#
Ben Harrison
#{normal}#68 - 104#{italic}#
Praise the name
Of he who helped us band together
#{normal}#]], [[#{bold}#
Ben Harrison
#{normal}#68 - 104#{italic}#
Praise the name
Of he who helped us band together
#{normal}#]], "_t")
t([[#{bold}#
Here rests Raymond Gaustadnes
#{normal}#84 - 120#{italic}#
The Pixels finally got him...
#{normal}#]], [[#{bold}#
Here rests Raymond Gaustadnes
#{normal}#84 - 120#{italic}#
The Pixels finally got him...
#{normal}#]], "_t")
t([[#{bold}#
Here lies Crokar
#{normal}#86 - 113#{italic}#
His love of trolls proved too dangerous a hobby
#{normal}#]], [[#{bold}#
Here lies Crokar
#{normal}#86 - 113#{italic}#
His love of trolls proved too dangerous a hobby
#{normal}#]], "_t")
t([[#{bold}#
Lyrissa the Wyrmfriend
#{normal}#93 - 116#{italic}#
Eaten by dragons
#{normal}#]], [[#{bold}#
Lyrissa the Wyrmfriend
#{normal}#93 - 116#{italic}#
Eaten by dragons
#{normal}#]], "_t")
t([[#{bold}#
Here rests Weldeth the Deserter
#{normal}#86 - 103#{italic}#
Fled from battle
Bereft of pride
On a comrade's sword
He quickly died
#{normal}#]], [[#{bold}#
Here rests Weldeth the Deserter
#{normal}#86 - 103#{italic}#
Fled from battle
Bereft of pride
On a comrade's sword
He quickly died
#{normal}#]], "_t")
t([[#{italic}#
This gravestone has been desecrated
#{normal}#]], [[#{italic}#
This gravestone has been desecrated
#{normal}#]], "_t")
t([[#{bold}#
Seria Swanfoot
#{normal}#56 - 109#{italic}#
May your feet now walk amongst the stars
#{normal}#]], [[#{bold}#
Seria Swanfoot
#{normal}#56 - 109#{italic}#
May your feet now walk amongst the stars
#{normal}#]], "_t")
t([[#{bold}#
Eric and Erik
#{normal}#66 - 114#{italic}#
Met their death investigating dark light
Alas, the pit was darker still
#{normal}#]], [[#{bold}#
Eric and Erik
#{normal}#66 - 114#{italic}#
Met their death investigating dark light
Alas, the pit was darker still
#{normal}#]], "_t")
t([[#{bold}#
Hoblo Sureshot
#{normal}#94 - 120#{italic}#
Death by ricochet
#{normal}#]], [[#{bold}#
Hoblo Sureshot
#{normal}#94 - 120#{italic}#
Death by ricochet
#{normal}#]], "_t")
t([[#{bold}#
Grave of the Unknown Mason
#{normal}#??? - ???#{italic}#
In dedication to all those lost building the dungeons of Maj'Eyal
#{normal}#]], [[#{bold}#
Grave of the Unknown Mason
#{normal}#??? - ???#{italic}#
In dedication to all those lost building the dungeons of Maj'Eyal
#{normal}#]], "_t")
t([[#{bold}#
Here lies Albert Deathproof
#{normal}#75 - ???#{italic}#
Buried alive
#{normal}#]], [[#{bold}#
Here lies Albert Deathproof
#{normal}#75 - ???#{italic}#
Buried alive
#{normal}#]], "_t")
t([[#{bold}#
RIP Legless Jack
#{normal}#26 - 98#{italic}#
His life's dream was to dance
But even dreams must die
#{normal}#]], [[#{bold}#
RIP Legless Jack
#{normal}#26 - 98#{italic}#
His life's dream was to dance
But even dreams must die
#{normal}#]], "_t")
t([[#{bold}#
The Blightbringer
#{normal}#14 - 46#{italic}#
Do not disturb
#{normal}#]], [[#{bold}#
The Blightbringer
#{normal}#14 - 46#{italic}#
Do not disturb
#{normal}#]], "_t")
t([[#{bold}#
Matthew the Brawler
#{normal}#101 - 122#{italic}#
Killed in a ring of blood
#{normal}#]], [[#{bold}#
Matthew the Brawler
#{normal}#101 - 122#{italic}#
Killed in a ring of blood
#{normal}#]], "_t")
t([[#{bold}#
Sarusan the Timeraper
#{normal}#102 - 87#{italic}#
He who wields Time
Dies by Time
#{normal}#]], [[#{bold}#
Sarusan the Timeraper
#{normal}#102 - 87#{italic}#
He who wields Time
Dies by Time
#{normal}#]], "_t")
t([[#{bold}#
Palia the Poacher
#{normal}#94 - 118#{italic}#
Shown no mercy in the cursed woods
#{normal}#]], [[#{bold}#
Palia the Poacher
#{normal}#94 - 118#{italic}#
Shown no mercy in the cursed woods
#{normal}#]], "_t")
t([[#{bold}#
Here lies the merchant Dalio
#{normal}#83 - 121#{italic}#
Slain by an assassin's deadly poison
#{normal}#]], [[#{bold}#
Here lies the merchant Dalio
#{normal}#83 - 121#{italic}#
Slain by an assassin's deadly poison
#{normal}#]], "_t")
t([[#{bold}#
Here lies Jazak
#{normal}#92 - 113#{italic}#
He played with the wildest fires
And got burnt
#{normal}#]], [[#{bold}#
Here lies Jazak
#{normal}#92 - 113#{italic}#
He played with the wildest fires
And got burnt
#{normal}#]], "_t")
t([[#{bold}#
RIP Gedis the Paladin
#{normal}#?? - 118#{italic}#
Bright star from foreign lands
We weep your fallen light
#{normal}#]], [[#{bold}#
RIP Gedis the Paladin
#{normal}#?? - 118#{italic}#
Bright star from foreign lands
We weep your fallen light
#{normal}#]], "_t")
t([[#{bold}#
Foursaw the Clown
#{normal}#82 - 114#{italic}#
We laughed
Until we saw
The joke was over
#{normal}#]], [[#{bold}#
Foursaw the Clown
#{normal}#82 - 114#{italic}#
We laughed
Until we saw
The joke was over
#{normal}#]], "_t")
t("gravestone", "gravestone", "_t")
t("last hope graveyard", "last hope graveyard", "newLore category")


------------------------------------------------
section "game/modules/tome/data/lore/maze.lua"
-- 5 entries
t([[Dear diary,

Lessons are off this week as my tutor has fallen ill, so I've decided to sneak out and have a wander round the old mazed ruins nearby. I know I'll get in trouble if I'm caught, but as long as I'm back in a couple of days no one will notice... Besides, I get so bored cooped up in those mountains! I want some fun!

This is rather a dirty place though. I've come across a few bandits and snakes in here, but nothing to threaten a grade 3 mage like me.

I remember hearing that this labyrinth used to be a prison used by the halfling king Roupar during the Age of Dusk, and that with the lawlessness of the time captives were simply sent here to rot. Some say a magical curse infected the place and turned them into bull-like monsters that patrol the halls to this day. How exciting!!
]], [[Dear diary,

Lessons are off this week as my tutor has fallen ill, so I've decided to sneak out and have a wander round the old mazed ruins nearby. I know I'll get in trouble if I'm caught, but as long as I'm back in a couple of days no one will notice... Besides, I get so bored cooped up in those mountains! I want some fun!

This is rather a dirty place though. I've come across a few bandits and snakes in here, but nothing to threaten a grade 3 mage like me.

I remember hearing that this labyrinth used to be a prison used by the halfling king Roupar during the Age of Dusk, and that with the lawlessness of the time captives were simply sent here to rot. Some say a magical curse infected the place and turned them into bull-like monsters that patrol the halls to this day. How exciting!!
]], "_t")
t("diary (the maze)", "diary (the maze)", "_t")
t([[I'm having so much fun! Probability Travel is making this little trip a breeze. And you should have seen the look on that bandit's face when I came out one wall, disappeared through another, and came around behind him! Hee hee hee...

I still remember Archmage Tarelion's lecture about the spell - "Probability effects can be employed for ease of use, but beware thee of relying on them. With ease of use comes ease of mind and a weakening of one's will and concentration. Soon one will find oneself in a situation of risk, bereft of normal judgement of danger, and low on the mental resources to save onself. Heed thee well." Bah, what tosh!!! How dumb does he really think I am?!

Besides, I'm enjoying myself - I'm having an adventure!!

I saw something! I don't know what it was... but it was big and shadowy! But when I tried chasing it I got lost... Um, maybe I just imagined it? No, I'm sure it must be something cool and exciting, I just have to keep exploring!]], [[I'm having so much fun! Probability Travel is making this little trip a breeze. And you should have seen the look on that bandit's face when I came out one wall, disappeared through another, and came around behind him! Hee hee hee...

I still remember Archmage Tarelion's lecture about the spell - "Probability effects can be employed for ease of use, but beware thee of relying on them. With ease of use comes ease of mind and a weakening of one's will and concentration. Soon one will find oneself in a situation of risk, bereft of normal judgement of danger, and low on the mental resources to save onself. Heed thee well." Bah, what tosh!!! How dumb does he really think I am?!

Besides, I'm enjoying myself - I'm having an adventure!!

I saw something! I don't know what it was... but it was big and shadowy! But when I tried chasing it I got lost... Um, maybe I just imagined it? No, I'm sure it must be something cool and exciting, I just have to keep exploring!]], "_t")
t("maze", "maze", "newLore category")
t([[I have now devised the perfect trap for the horned beast that walks these halls! Truly he cannot avoid this amazing contraption - the perfect blend of technical mastery and nature's lethal gifts. Ah, how I look forward to having that monster's head mounted on my walls - it shall be the pride of my collection!

The contraption is elegant and simple, though many months I have spent getting the formula perfect. There are two vials attached together - one containing finely ground hemlock, the other containing a carefully prepared zinc compound. When the vials are broken the materials react with the air and pump out an amazing cloud of poisonous vapour! The poison is supremely effective, killing within minutes. All I have to do is carefully hide the vials beneath a thin piece of slate and wait for my prey to step upon the trap - then POOF, it's dead!

I have prepared a great many vials to last me throughout the hunting season. By this time next year I will have a trophy collection to match the kings!

I seem to have misplaced one though... I'm sure it must be close by.


No, NO! I have - I --- acci--- pain, such pa--______


#{italic}#You find a dusty case filled with many small vials of powder. They seem serviceable.#{normal}#]], [[I have now devised the perfect trap for the horned beast that walks these halls! Truly he cannot avoid this amazing contraption - the perfect blend of technical mastery and nature's lethal gifts. Ah, how I look forward to having that monster's head mounted on my walls - it shall be the pride of my collection!

The contraption is elegant and simple, though many months I have spent getting the formula perfect. There are two vials attached together - one containing finely ground hemlock, the other containing a carefully prepared zinc compound. When the vials are broken the materials react with the air and pump out an amazing cloud of poisonous vapour! The poison is supremely effective, killing within minutes. All I have to do is carefully hide the vials beneath a thin piece of slate and wait for my prey to step upon the trap - then POOF, it's dead!

I have prepared a great many vials to last me throughout the hunting season. By this time next year I will have a trophy collection to match the kings!

I seem to have misplaced one though... I'm sure it must be close by.


No, NO! I have - I --- acci--- pain, such pa--______


#{italic}#You find a dusty case filled with many small vials of powder. They seem serviceable.#{normal}#]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/misc.lua"
-- 39 entries
t("adventures", "adventures", "newLore category")
t("myths of creation", "myths of creation", "newLore category")
t([[Eyal was raised from Darkness,
And One came who made a blinding light called Sun,
But Eyal flinched and said, "It is too bright!"
So Gerlyk spun Eyal around; thus his face was half-time in light and half-time in shadow,
But in shadow Eyal became lonely and cried.

And so Gerlyk made him two younger sisters who danced around Eyal
And kept him in good spirits.
But the moonsisters became jealous of their brother's affection,
Threatening to fight and scream.
Thus Gerlyk separated them so that Eyal would only ever dance with one at a time.

In the summer Eyal dances with the moonsister Altia.
She sings songs of joy and laughter,
And brings friends and family together,
And she glows yellow with mirth.
In the winter Eyal dances with the moonsister Felia.
She tells tales of times begone,
And makes men walk alone in thought,
And she glows blue with solemness.

But in the time between,
When both sisters are slimly seen on each side of Eyal,
Glaring at each other from behind their brother's belly,
Then the world goes still, and the winds hold their breath, and the oceans lie flat.
For this is the Time of Balance, when the Darkness rises deepest, and all life is in peril.
Aye, and Gerlyk did say, "Let no man walk abroad this night, lest Darkness catch him and take him forever."
Aye, and Gerlyk did walk abroad that night, into Darkness beyond, and has ne'er since been seen.]], [[Eyal was raised from Darkness,
And One came who made a blinding light called Sun,
But Eyal flinched and said, "It is too bright!"
So Gerlyk spun Eyal around; thus his face was half-time in light and half-time in shadow,
But in shadow Eyal became lonely and cried.

And so Gerlyk made him two younger sisters who danced around Eyal
And kept him in good spirits.
But the moonsisters became jealous of their brother's affection,
Threatening to fight and scream.
Thus Gerlyk separated them so that Eyal would only ever dance with one at a time.

In the summer Eyal dances with the moonsister Altia.
She sings songs of joy and laughter,
And brings friends and family together,
And she glows yellow with mirth.
In the winter Eyal dances with the moonsister Felia.
She tells tales of times begone,
And makes men walk alone in thought,
And she glows blue with solemness.

But in the time between,
When both sisters are slimly seen on each side of Eyal,
Glaring at each other from behind their brother's belly,
Then the world goes still, and the winds hold their breath, and the oceans lie flat.
For this is the Time of Balance, when the Darkness rises deepest, and all life is in peril.
Aye, and Gerlyk did say, "Let no man walk abroad this night, lest Darkness catch him and take him forever."
Aye, and Gerlyk did walk abroad that night, into Darkness beyond, and has ne'er since been seen.]], "_t")
t([[Death is nearing. I can feel her chilling breath down the back of my neck. So many of us firstborn have passed on already. I cannot allow it... I will not let myself rot into dirt like the others. I am the mightiest of the Shaloren - I have a right to life!
]], [[Death is nearing. I can feel her chilling breath down the back of my neck. So many of us firstborn have passed on already. I cannot allow it... I will not let myself rot into dirt like the others. I am the mightiest of the Shaloren - I have a right to life!
]], "_t")
t([[Death mocks my experiments. I can preserve the flesh of my servants, tightly wrapped and salted, treated with the correct chemicals. I can animate them, make them shuffle about the empty halls of my mausoleum. But they are but empty shells, devoid of any soul. Is this how my majesty is to end? I demand a greater fate...

My days are numbered. Each night that passes saps strength from me. I must find the way to preserve my soul within my flesh. My greatness cannot be allowed to fade.]], [[Death mocks my experiments. I can preserve the flesh of my servants, tightly wrapped and salted, treated with the correct chemicals. I can animate them, make them shuffle about the empty halls of my mausoleum. But they are but empty shells, devoid of any soul. Is this how my majesty is to end? I demand a greater fate...

My days are numbered. Each night that passes saps strength from me. I must find the way to preserve my soul within my flesh. My greatness cannot be allowed to fade.]], "_t")
t("ancient elven ruins", "ancient elven ruins", "newLore category")
t([[Death has met her match. My results are complete, and I am ready to step to the Beyond. I have my sword by my side, and its icy edge will freeze even the dark one in her tracks. My powers cannot be denied...

Come, Death, try to lay your bony fingers on me! I will vanish before your very eyes and slice you apart! You and your agents are no threat to me. I am immortal!]], [[Death has met her match. My results are complete, and I am ready to step to the Beyond. I have my sword by my side, and its icy edge will freeze even the dark one in her tracks. My powers cannot be denied...

Come, Death, try to lay your bony fingers on me! I will vanish before your very eyes and slice you apart! You and your agents are no threat to me. I am immortal!]], "_t")
t("Rassir's journal part 1", "Rassir's journal part 1", "_t")
t([[I have come to see the moonstone again. My younger brother Limmir understands a little of my obsession with it, yet the others do not care. I have tried to explain how it is of importance to Aeryn, but she simply asked if she could make a sword from it. Bah! Such stupidity from that grunt fighter.

Our ancestors found their powers from the intense study of the stars, yet the people these days seem only to care about their applications in battle. I know our position with the orcs is grim, but we must not forget our roots in the celestial sphere! Only by sun, moons and stars do we find knowledge and power in life.

Ah well, I shall at least be able to study here in peace. The ring of invisibility I have crafted affords me cover from any orc patrols, and the caves around the moonstone are quiet enough. I have set up my telescope in the open air of the Valley of the Moon itself.

Last night I spotted a red star in the early dawn. How very peculiar... Could this be a new celestial body to study?]], [[I have come to see the moonstone again. My younger brother Limmir understands a little of my obsession with it, yet the others do not care. I have tried to explain how it is of importance to Aeryn, but she simply asked if she could make a sword from it. Bah! Such stupidity from that grunt fighter.

Our ancestors found their powers from the intense study of the stars, yet the people these days seem only to care about their applications in battle. I know our position with the orcs is grim, but we must not forget our roots in the celestial sphere! Only by sun, moons and stars do we find knowledge and power in life.

Ah well, I shall at least be able to study here in peace. The ring of invisibility I have crafted affords me cover from any orc patrols, and the caves around the moonstone are quiet enough. I have set up my telescope in the open air of the Valley of the Moon itself.

Last night I spotted a red star in the early dawn. How very peculiar... Could this be a new celestial body to study?]], "_t")
t("Rassir's journal part 2", "Rassir's journal part 2", "_t")
t([[Oh, what terrible horrors! Demons, clawed creatures, dark smog, clouds of acid, skins of lava! Where did they all come from?!

It was when I was studying the moonstone, and as the red star was rising again before the dawn. The stone glowed blood-red and suddenly portals awakened in the rock of the valley. From them poured forth all manner of demonic creatures! I put my ring of invisibility on and fled into the caves. But now the creatures are everywhere! The caves are infested with them, prowling about like hungry animals.

And there is something... something terrible. In the shadows, in the darkness, I can sense it looking for me. It stalks me, an invisible hunter after invisible prey. Now and then I hear the cracking of a terrible whip. I must stay hidden...]], [[Oh, what terrible horrors! Demons, clawed creatures, dark smog, clouds of acid, skins of lava! Where did they all come from?!

It was when I was studying the moonstone, and as the red star was rising again before the dawn. The stone glowed blood-red and suddenly portals awakened in the rock of the valley. From them poured forth all manner of demonic creatures! I put my ring of invisibility on and fled into the caves. But now the creatures are everywhere! The caves are infested with them, prowling about like hungry animals.

And there is something... something terrible. In the shadows, in the darkness, I can sense it looking for me. It stalks me, an invisible hunter after invisible prey. Now and then I hear the cracking of a terrible whip. I must stay hidden...]], "_t")
t("valley of the moon", "valley of the moon", "newLore category")
t("Rassir's journal part 3", "Rassir's journal part 3", "_t")
t([[I fell asleep in a dark hollow, but my sleep was troubled by terrible dreams. The dreams are so vivid in my mind!

I saw the red star, and it became a land of fire floating in the night sky, full of black creatures with yellow eyes and hungry red mouths. And beyond the red star, far beyond was a dim world, but fractured and split all about its surface. As the world spun the split continents crushed against each other, and lava spilled up, and lands sunk into the ground. Demonic mouths screamed up as they disappeared into fiery death. It was if the world was tearing itself apart, but some force of will was desperately trying to keep it held together.

And I saw then in the centre of the world, as it spun and crumpled and crunched, a vast figure with a horned head and outstretched limbs and shining white eyes. It held tight to the innards of the world, holding it together against forces threatening to pull the whole planet apart. The giant face contorted and screamed in pain and fury.

“Urh'Rok,” a deep voice spoke within my head. “Our god, our saviour, holder of our world. In the name of Urh'Rok we seek vengeance against Amakthel and the Sher'Tul. The petty world of Eyal shall fall!” And then I woke up, and I felt sure something was nearby, looking for me. I fled instantly.

Am I going mad? The name “Urh'Rok” still rebounds through my skull and my vision is dimmed. Perhaps I have been wearing this ring too long...

Yes, yes, this is all clearly an illusion! A strange nightmare that I shall wake up from. I shall take the ring off, and go visit the lovely moonstone again. Once I see the stars all shall be well...]], [[I fell asleep in a dark hollow, but my sleep was troubled by terrible dreams. The dreams are so vivid in my mind!

I saw the red star, and it became a land of fire floating in the night sky, full of black creatures with yellow eyes and hungry red mouths. And beyond the red star, far beyond was a dim world, but fractured and split all about its surface. As the world spun the split continents crushed against each other, and lava spilled up, and lands sunk into the ground. Demonic mouths screamed up as they disappeared into fiery death. It was if the world was tearing itself apart, but some force of will was desperately trying to keep it held together.

And I saw then in the centre of the world, as it spun and crumpled and crunched, a vast figure with a horned head and outstretched limbs and shining white eyes. It held tight to the innards of the world, holding it together against forces threatening to pull the whole planet apart. The giant face contorted and screamed in pain and fury.

“Urh'Rok,” a deep voice spoke within my head. “Our god, our saviour, holder of our world. In the name of Urh'Rok we seek vengeance against Amakthel and the Sher'Tul. The petty world of Eyal shall fall!” And then I woke up, and I felt sure something was nearby, looking for me. I fled instantly.

Am I going mad? The name “Urh'Rok” still rebounds through my skull and my vision is dimmed. Perhaps I have been wearing this ring too long...

Yes, yes, this is all clearly an illusion! A strange nightmare that I shall wake up from. I shall take the ring off, and go visit the lovely moonstone again. Once I see the stars all shall be well...]], "_t")
t("Lament for Lands now Lost", "Lament for Lands now Lost", "_t")
t([[You see a moss covered statue of a Thalore reciting a poem, over and over.
#{italic}#"Where bright and berried yews did stand,
Where the eldest oaks grew so grand,
Where singing birds once flew to land,
All is dust, all is dead.

Once flowers rose to reach the sky,
Once blossoms fell from beech on high,
Once thrush and owl did screech and cry,
Now all lost, now all fled.

Oaths from Shaloren mages sworn,
Yet spells of fiery rages born,
Our lands of bygone ages torn,
Gone is trust, wrath is red.#{normal}#
]], [[You see a moss covered statue of a Thalore reciting a poem, over and over.
#{italic}#"Where bright and berried yews did stand,
Where the eldest oaks grew so grand,
Where singing birds once flew to land,
All is dust, all is dead.

Once flowers rose to reach the sky,
Once blossoms fell from beech on high,
Once thrush and owl did screech and cry,
Now all lost, now all fled.

Oaths from Shaloren mages sworn,
Yet spells of fiery rages born,
Our lands of bygone ages torn,
Gone is trust, wrath is red.#{normal}#
]], "_t")
t("Running man", "Running man", "_t")
t([[Running man, running man
Your time is ending soon
Running man, running man
Will not save sun nor moons

Running man, running man
Survival growing slim
Running man, running man
You know your fate is grim

Running man, running man
Now's the time to choose
Running man, running man
Your honour or your shoes!]], [[Running man, running man
Your time is ending soon
Running man, running man
Will not save sun nor moons

Running man, running man
Survival growing slim
Running man, running man
You know your fate is grim

Running man, running man
Now's the time to choose
Running man, running man
Your honour or your shoes!]], "_t")
t("Gifts of Nature", "Gifts of Nature", "_t")
t([[In Age of Allure rose an archmage high
With power beyond compare
And the people poor would not come nigh
His dark and terrible lair

Whilst crops fell dead in drought and blight
And children grew diseased
The wizard dread stole in the night
To pillage what he pleased

But a hero came with shining sword
And a will of solid steel
Not seeking fame or high reward
He followed but his zeal

"From Zigur I come on righteous quest
To battle foes arcane
I will not succumb to magic detest
I will end this evil reign"

And so he rode on pure-white steed
To the warlock's hold
That dank abode of dark misdeed
He entered brave and bold

There battle blazed beyond all sight
Sword clashed with spell
Blood was razed in fearsome fight
Scream followed yell

A beam was cast of arcane pure
Piercing mail and shield
But still steadfast with flesh secure
The hero did not yield

A slash tore through the wizard's cloth
His hat dropped to the ground
From loose grip flew his staff so wroth
Thus fell the mage renowned

Now bare of skin and weaponless
Here lay but a man
No arcane sin could now redress
The blood that freely ran

"Fool warlock dead, you were too vain
To gifts of Nature trust
Your faith instead in tools arcane
Now to Nature you are dust"]], [[In Age of Allure rose an archmage high
With power beyond compare
And the people poor would not come nigh
His dark and terrible lair

Whilst crops fell dead in drought and blight
And children grew diseased
The wizard dread stole in the night
To pillage what he pleased

But a hero came with shining sword
And a will of solid steel
Not seeking fame or high reward
He followed but his zeal

"From Zigur I come on righteous quest
To battle foes arcane
I will not succumb to magic detest
I will end this evil reign"

And so he rode on pure-white steed
To the warlock's hold
That dank abode of dark misdeed
He entered brave and bold

There battle blazed beyond all sight
Sword clashed with spell
Blood was razed in fearsome fight
Scream followed yell

A beam was cast of arcane pure
Piercing mail and shield
But still steadfast with flesh secure
The hero did not yield

A slash tore through the wizard's cloth
His hat dropped to the ground
From loose grip flew his staff so wroth
Thus fell the mage renowned

Now bare of skin and weaponless
Here lay but a man
No arcane sin could now redress
The blood that freely ran

"Fool warlock dead, you were too vain
To gifts of Nature trust
Your faith instead in tools arcane
Now to Nature you are dust"]], "_t")
t("dreamscape", "dreamscape", "newLore category")
t("If I Should Die Before I Wake", "If I Should Die Before I Wake", "_t")
t([[You wake suddenly from your unexpected slumber and attempt to quickly regain your bearings. However, you are not prepared for the bizarre vision that greets you: instead of land and sky you see only amorphous shapes and varying degrees of light. A strange psychedelic haze permeates the air and otherworldly colors and shadows flicker in and out of your peripheral vision. 
As you begin to come to grips with this strange environment, you realize with horror that you cannot move! Your body feels as if it is completely without weight and try as you may you cannot budge an inch. You experience a sense of Déjà Vu as you recall past nightmares of being paralyzed. That's when it strikes you: you never woke up at all, you're still asleep! This epiphany is only reinforced when you notice a strange phenomenon: mirror copies of yourself are being slowly projected from where you stand and are moving about of their own volition.
They all seem to be focused on something in particular, but what? Just as soon as you set your mind to discerning what your dreamselves are focusing on, you feel it. With horror, you realize that you are not alone here. 
Somehow, your foe has invaded your very subconcious and is attacking you in your dreams. Still unable to move, your lucid mind races on how to handle such an insane and horrible situation. On a whim you concentrate on one of your projections and you find that you can control it. 
Free now to face this nightmare, you turn to find your foe. While you have a sense that having one of your dreamselves destroyed may not by itself be catastrophic, what would happen if several or many are cut down? Unwilling to find out, you resolve yourself to end this offensive intrustion into your mind.]], [[You wake suddenly from your unexpected slumber and attempt to quickly regain your bearings. However, you are not prepared for the bizarre vision that greets you: instead of land and sky you see only amorphous shapes and varying degrees of light. A strange psychedelic haze permeates the air and otherworldly colors and shadows flicker in and out of your peripheral vision. 
As you begin to come to grips with this strange environment, you realize with horror that you cannot move! Your body feels as if it is completely without weight and try as you may you cannot budge an inch. You experience a sense of Déjà Vu as you recall past nightmares of being paralyzed. That's when it strikes you: you never woke up at all, you're still asleep! This epiphany is only reinforced when you notice a strange phenomenon: mirror copies of yourself are being slowly projected from where you stand and are moving about of their own volition.
They all seem to be focused on something in particular, but what? Just as soon as you set your mind to discerning what your dreamselves are focusing on, you feel it. With horror, you realize that you are not alone here. 
Somehow, your foe has invaded your very subconcious and is attacking you in your dreams. Still unable to move, your lucid mind races on how to handle such an insane and horrible situation. On a whim you concentrate on one of your projections and you find that you can control it. 
Free now to face this nightmare, you turn to find your foe. While you have a sense that having one of your dreamselves destroyed may not by itself be catastrophic, what would happen if several or many are cut down? Unwilling to find out, you resolve yourself to end this offensive intrustion into your mind.]], "_t")
t([[Dear graverobber,

Try to be a little faster next time.

Love, #{italic}#Eden#{normal}#]], [[Dear graverobber,

Try to be a little faster next time.

Love, #{italic}#Eden#{normal}#]], "_t")
t([[Sixth time this week stuck guarding at the stash. And for what? Just a little fun! 

Almost miss being at the farm sometimes. At least there I wasn't able to screw anything up. Wonder if they would take me back knowing what I've been doing with my life...]], [[Sixth time this week stuck guarding at the stash. And for what? Just a little fun! 

Almost miss being at the farm sometimes. At least there I wasn't able to screw anything up. Wonder if they would take me back knowing what I've been doing with my life...]], "_t")
t([[The best haul we ever got, gone. We could have been set for life, the most legendary outlaws in all the lands! Villages would tremble at the thought of us roaming the woods.

Only a matter of time until that nobleman catches wind and comes after us. We were about to get more gold than we could count for his lassie back, and that dirt farmer set her on fire. Of all the skullbrained things to do for fun!

Ordered my men to kill any who pass by and been running triple guard. We need all the time we can get before they come for us, can't let any word out. Once we find somewhere new, I'll leave that idiot burnt on a stake as tribute and hope we don't catch chase. 

I'm going to enjoy hearing his screams, a log on the pyre a gold he cost us. Nice and slow, need to make sure he doesn't die easy.]], [[The best haul we ever got, gone. We could have been set for life, the most legendary outlaws in all the lands! Villages would tremble at the thought of us roaming the woods.

Only a matter of time until that nobleman catches wind and comes after us. We were about to get more gold than we could count for his lassie back, and that dirt farmer set her on fire. Of all the skullbrained things to do for fun!

Ordered my men to kill any who pass by and been running triple guard. We need all the time we can get before they come for us, can't let any word out. Once we find somewhere new, I'll leave that idiot burnt on a stake as tribute and hope we don't catch chase. 

I'm going to enjoy hearing his screams, a log on the pyre a gold he cost us. Nice and slow, need to make sure he doesn't die easy.]], "_t")
t([[#{bold}#How to Summon a Phoenix#{normal}#
	  10 pouches faeros ash
	  5 vials fire wyrm saliva
	  3 red crystal shards
	  3 pouches bone giant dust
	  1 vial greater demon bile
	  1 skeleton mage skull
	  pinch of luminous horror dust

This is a long and complex ceremony, and all steps must be followed precisely if you wish to succeed. Heed well that for the errant fool who takes on what they cannot finish, there will be consequences. To play with fire and assert your dominance over the flames comes with risks if you overestimate your power. 
	
The ritual begins with a vessel; any man will do. Bind them in place with flame secure bindings, and give a sound gag. The gag isn't strictly necessary, but the screams of agony tend to be quite distracting and inspirit mistakes after a few days.

Take 2 vials fire wyrm saliva and dissolve 2 pouches faeros ash in each. Be sure to dissolve completely. A few fireballs at the vial can do the trick if they're stubborn. Using one of the prepared vials, begin to etch the saliva in the skin of the vessel, heating it so that it brands the shape of --- 

#{italic}#The remainder of the scroll has been singed into a pile of char, illegible and scattering into a cloud of ash as you grasp it#{normal}#
	]], [[#{bold}#How to Summon a Phoenix#{normal}#
	  10 pouches faeros ash
	  5 vials fire wyrm saliva
	  3 red crystal shards
	  3 pouches bone giant dust
	  1 vial greater demon bile
	  1 skeleton mage skull
	  pinch of luminous horror dust

This is a long and complex ceremony, and all steps must be followed precisely if you wish to succeed. Heed well that for the errant fool who takes on what they cannot finish, there will be consequences. To play with fire and assert your dominance over the flames comes with risks if you overestimate your power. 
	
The ritual begins with a vessel; any man will do. Bind them in place with flame secure bindings, and give a sound gag. The gag isn't strictly necessary, but the screams of agony tend to be quite distracting and inspirit mistakes after a few days.

Take 2 vials fire wyrm saliva and dissolve 2 pouches faeros ash in each. Be sure to dissolve completely. A few fireballs at the vial can do the trick if they're stubborn. Using one of the prepared vials, begin to etch the saliva in the skin of the vessel, heating it so that it brands the shape of --- 

#{italic}#The remainder of the scroll has been singed into a pile of char, illegible and scattering into a cloud of ash as you grasp it#{normal}#
	]], "_t")
t("Nature vs Magic", "Nature vs Magic", "_t")
t([[Your arcane abilities have been interfered with!

Eyal is a torn world, and the forces of nature can react strongly to the arcane energies that seek to manipulate them. Some items and areas are imbued with anti-magic, a natural energy that disrupts magical abilities and effects. There are even those who have learned to harness anti-magic into their own wild abilities, and who use them to hunt down and destroy those who practise magic. So beware, caster! It is a hostile world ye wander in.]], [[Your arcane abilities have been interfered with!

Eyal is a torn world, and the forces of nature can react strongly to the arcane energies that seek to manipulate them. Some items and areas are imbued with anti-magic, a natural energy that disrupts magical abilities and effects. There are even those who have learned to harness anti-magic into their own wild abilities, and who use them to hunt down and destroy those who practise magic. So beware, caster! It is a hostile world ye wander in.]], "_t")
t("highfin", "highfin", "newLore category")
t([[I must say, as time grows, I feel so do I grow more and more inclined to distance myself from the calling of an 'adventurer', like so many you can find roaming the countryside. I feel like the myth of a wandering hero has blinded too many with promise of easy fame and riches, with no eye for the other kind of fortune.

Hear me out on this.

Nowadays most don't really recognize how fascinating the world we live in truly is. It is vast, more than you can imagine. I can safely promise, any wild thought you can muster up, dear reader, will not come close to the truth. Such is the breadth of wonders, I would probably dismiss most of what I have seen as myth, be I not there myself. And even then sometimes, I had to wonder whether I could trust my eyes.

Perhaps I'm being too vague, or maybe these promises leave much to be desired. After all, adventuring is not all fun and exotics, it is before all danger and a constant threat of death, or worse. So then if you wish me to be more concrete, think of derelict, crumbling crypts, cults and demons, hungry forests full of monsters and forces beyond time and place. True, there is overwhelming awe, thrill even, but the reason that so little detail reaches you, is because so little live to tell.

What does reach us then, are not people, but objects. Artifacts of great power, legacy of the past. Surely, any drunkard might like to tell tales after a pint or two, but a magical sword is a proof of its own and it keeps quiet of what it has seen. So, a great hero is usually easy to recognize, being practically a walking history book. Clad in half the age of important events which he probably has no idea about.

It is important to remember, that every artifact has a meaning, beings of great power and importance behind them. Stories, that now slowly wane into nothing. This is why it is not artifacts that make an adventurer. It is his great deeds, the will to dare where nobody did before. It is not important if you get known in the process or not, after all, if you were truly great, maybe you will leave behind a legacy of your own.

-#{italic}#Kestin Highfin#{normal}#]], [[I must say, as time grows, I feel so do I grow more and more inclined to distance myself from the calling of an 'adventurer', like so many you can find roaming the countryside. I feel like the myth of a wandering hero has blinded too many with promise of easy fame and riches, with no eye for the other kind of fortune.

Hear me out on this.

Nowadays most don't really recognize how fascinating the world we live in truly is. It is vast, more than you can imagine. I can safely promise, any wild thought you can muster up, dear reader, will not come close to the truth. Such is the breadth of wonders, I would probably dismiss most of what I have seen as myth, be I not there myself. And even then sometimes, I had to wonder whether I could trust my eyes.

Perhaps I'm being too vague, or maybe these promises leave much to be desired. After all, adventuring is not all fun and exotics, it is before all danger and a constant threat of death, or worse. So then if you wish me to be more concrete, think of derelict, crumbling crypts, cults and demons, hungry forests full of monsters and forces beyond time and place. True, there is overwhelming awe, thrill even, but the reason that so little detail reaches you, is because so little live to tell.

What does reach us then, are not people, but objects. Artifacts of great power, legacy of the past. Surely, any drunkard might like to tell tales after a pint or two, but a magical sword is a proof of its own and it keeps quiet of what it has seen. So, a great hero is usually easy to recognize, being practically a walking history book. Clad in half the age of important events which he probably has no idea about.

It is important to remember, that every artifact has a meaning, beings of great power and importance behind them. Stories, that now slowly wane into nothing. This is why it is not artifacts that make an adventurer. It is his great deeds, the will to dare where nobody did before. It is not important if you get known in the process or not, after all, if you were truly great, maybe you will leave behind a legacy of your own.

-#{italic}#Kestin Highfin#{normal}#]], "_t")
t("Warden-Master Galsamae's Orientation Notes", "Warden-Master Galsamae's Orientation Notes", "_t")
t([[Congratulations, sir and/or madam. Whether by invitation, discovering it on your own, or simply being enough of a thorn in our side to recruit rather than dispose of, you have gained the secrets of chronomancy. The ultimate power of time - the ability to reset and try again if you fail, the ability to save time by seeing the results of investigations before they happen. Though our powers are bound to post-Spellblaze Eyal, they are those of nigh-omnipotence with enough patience.

But trust me - "enough patience" is one nasty limiting reagent. You're going to be running out of that fast when you've spent the last week trying to dismantle an Age of Dusk-era house-of-cards system of causally interdependent tyrannies without causing dwarven extinction, and a plague just broke out right when you had things almost perfect, for the sixth time--

Look. The point is, there's a reason the person who writes the invitations and the mission statements isn't someone out in the field - and you're lucky enough to be working for someone who understands that you need more flexibility than idealism allows. Our squad knows that to stay sane, we have to know when "time flows forward at a rate of one second per second" isn't the only rule we have to break. That it's generally okay to skip the trial and just deal with a temporally hazardous jackass as you see fit, if you've foreseen a guilty verdict - as long as your investigations are solid when you actually conduct them (and you do have to do the work once in a while, or you'll only be capable of seeing yourself procrastinating). And if you just need to not be watched, you should know that there are a few decades in the Age of Dusk we and a few other squads recognize as "fair game" - whatever experiments you've wondered about or horrors you want to inflict, just keep it to the time period of infinite forgotten evils and it doesn't hurt anything in the grand scheme. Trust me, we've checked - nothing in that time period matters unless you've got another Spellblaze to set off.

But most importantly, you should know: Zemekkys is even lazier than I am, but he has status to maintain. If you continually violate his will, there will come a point at which you will be informed that you have been caught and should stop resisting. Accept whatever fate he doles out for you. If you do not stop, there will come a point where he will be forced to make an example of you so severe that the entire cosmos will notice your non-existence. Obviously we can't be sure how many of us he's done this to (if any) or how it works, but we're pretty sure that the result looks like something starting with a W.

Everyone here wants the same thing - keep spacetime stable, have fun with your powers, cheat at a few lotteries - but we've got cover to maintain and, in theory, an actual job to do if something ever cracks that Sher'Tul shield or the Greigu find a way to bypass a portal-filter. Scratch backs when yours gets scratched, don't make so much noise that the system comes crashing down on your head, and you'll enjoy your stay in eternity.

Welcome to Point Zero, agent. Enclosed are timespace coordinates to what is, quite literally, the best roast-yeti restaurant that could possibly exist - I'll have the squad meet you there and then. Thank me later.

[i]-Galsamae[/i]

PS: You might encounter a... benefactor of sorts in your travels. You'll know it when you see it, ham-fistedly yanking its puppets back from the brink of death; if you see it for yourself, we regret to inform you that you've taken a one-way trip off prime Timeline-E4-RL territory for a doomed offshoot unless "he" feels like weaving you back in - and it tends to only do that to people who narrowly avert its engineered apocalypses through incredible power or luck. If you have been chosen by its schemes, play along and you might get brought back from the temporal graveyard that is the Timeline-E4-EXPADV subnetwork. We do not know what it is - a runaway creation of our own, a competing culture's weapon, or something far above ourselves - but if it has hostile intent, it has already won. So far it's been... mostly cooperative. Just make a point not to remind it that we're its competition.]], [[Congratulations, sir and/or madam. Whether by invitation, discovering it on your own, or simply being enough of a thorn in our side to recruit rather than dispose of, you have gained the secrets of chronomancy. The ultimate power of time - the ability to reset and try again if you fail, the ability to save time by seeing the results of investigations before they happen. Though our powers are bound to post-Spellblaze Eyal, they are those of nigh-omnipotence with enough patience.

But trust me - "enough patience" is one nasty limiting reagent. You're going to be running out of that fast when you've spent the last week trying to dismantle an Age of Dusk-era house-of-cards system of causally interdependent tyrannies without causing dwarven extinction, and a plague just broke out right when you had things almost perfect, for the sixth time--

Look. The point is, there's a reason the person who writes the invitations and the mission statements isn't someone out in the field - and you're lucky enough to be working for someone who understands that you need more flexibility than idealism allows. Our squad knows that to stay sane, we have to know when "time flows forward at a rate of one second per second" isn't the only rule we have to break. That it's generally okay to skip the trial and just deal with a temporally hazardous jackass as you see fit, if you've foreseen a guilty verdict - as long as your investigations are solid when you actually conduct them (and you do have to do the work once in a while, or you'll only be capable of seeing yourself procrastinating). And if you just need to not be watched, you should know that there are a few decades in the Age of Dusk we and a few other squads recognize as "fair game" - whatever experiments you've wondered about or horrors you want to inflict, just keep it to the time period of infinite forgotten evils and it doesn't hurt anything in the grand scheme. Trust me, we've checked - nothing in that time period matters unless you've got another Spellblaze to set off.

But most importantly, you should know: Zemekkys is even lazier than I am, but he has status to maintain. If you continually violate his will, there will come a point at which you will be informed that you have been caught and should stop resisting. Accept whatever fate he doles out for you. If you do not stop, there will come a point where he will be forced to make an example of you so severe that the entire cosmos will notice your non-existence. Obviously we can't be sure how many of us he's done this to (if any) or how it works, but we're pretty sure that the result looks like something starting with a W.

Everyone here wants the same thing - keep spacetime stable, have fun with your powers, cheat at a few lotteries - but we've got cover to maintain and, in theory, an actual job to do if something ever cracks that Sher'Tul shield or the Greigu find a way to bypass a portal-filter. Scratch backs when yours gets scratched, don't make so much noise that the system comes crashing down on your head, and you'll enjoy your stay in eternity.

Welcome to Point Zero, agent. Enclosed are timespace coordinates to what is, quite literally, the best roast-yeti restaurant that could possibly exist - I'll have the squad meet you there and then. Thank me later.

[i]-Galsamae[/i]

PS: You might encounter a... benefactor of sorts in your travels. You'll know it when you see it, ham-fistedly yanking its puppets back from the brink of death; if you see it for yourself, we regret to inform you that you've taken a one-way trip off prime Timeline-E4-RL territory for a doomed offshoot unless "he" feels like weaving you back in - and it tends to only do that to people who narrowly avert its engineered apocalypses through incredible power or luck. If you have been chosen by its schemes, play along and you might get brought back from the temporal graveyard that is the Timeline-E4-EXPADV subnetwork. We do not know what it is - a runaway creation of our own, a competing culture's weapon, or something far above ourselves - but if it has hostile intent, it has already won. So far it's been... mostly cooperative. Just make a point not to remind it that we're its competition.]], "_t")
t("spydrë", "spydrë", "newLore category")
t("Mantra of a Shiiak", "Mantra of a Shiiak", "_t")
t([[Each morning I wake, happy I'm alive;
the traps of this tomb won't claim me today.
Though its curse of hunger eats at my insides,
I curse it one better by having outstayed.

Say a curse for the goblins' tortures that remained,
and a curse for the gods who stole half the world.
Say a curse for the chill that leaves magic drained,
and a curse for the star that grew dark as it swirled

But most important of all is to note,
in spite of fate's bias, only we survived.
Curse the dead all you want, but we've stayed afloat;
we're the only ones blessed with the skillset to thrive.

Our wit, strength, and teamwork outweigh cosmic powers;
they've done what they could but Spydrë is [b]ours.[/b] ]], [[Each morning I wake, happy I'm alive;
the traps of this tomb won't claim me today.
Though its curse of hunger eats at my insides,
I curse it one better by having outstayed.

Say a curse for the goblins' tortures that remained,
and a curse for the gods who stole half the world.
Say a curse for the chill that leaves magic drained,
and a curse for the star that grew dark as it swirled

But most important of all is to note,
in spite of fate's bias, only we survived.
Curse the dead all you want, but we've stayed afloat;
we're the only ones blessed with the skillset to thrive.

Our wit, strength, and teamwork outweigh cosmic powers;
they've done what they could but Spydrë is [b]ours.[/b] ]], "_t")
t("Z'quikzshl", "Z'quikzshl", "_t")
t([[#{italic}#(The handwriting of this diary entry is poor at best. Whoever wrote this was in poor health.)

#{bold}#53rd Allure, Year 603 of the Age of Pyre#{normal}#

I have done it! My fool of a master said I was not ready for the rites of lichdom, that I would attract undue attention... what utter idiocy. Already I can feel the transformation taking place, and I am certain that this weakness will only be momentary. My master was foolish to leave the Grimoire of Mortality Transcended open and unattended! All I needed was a bone from a magical creature, and as luck would have it, I had found a skeletal corpse of a dragon not far from our tower. The other ingredients were trivial and in possession of my master... surely he will be astounded that I, Zilquick the Eternal, will have transcended mortality!

(Another entry is written beneath this one, in a much more elegant and controlled script.)

Zilquick the Eternal, hah! What an unbearable buffoon, and I am glad his pride was his undoing. The young fool used up the Ruby of Eldoral in creating his phylactery, however; I must acquire a new phylactery for myself. On the bright side, my incompetent apprentice did illustrate why a bone from a creature slain by my own hand is important: the dragon bone he chose had left to fester a mold infection, and the mold somehow infused itself with the bone's inherent magical properties, altering the magical composition of the spell. I do hope whoever finds this note shall kill this "lich" using the most painful means available, and shall deposit him someplace where he is sure to be found.
Oh, look. He is trying to harm me with spells, but all he can manage is a corruption of his own name: Z'quikzshl.]], [[#{italic}#(The handwriting of this diary entry is poor at best. Whoever wrote this was in poor health.)

#{bold}#53rd Allure, Year 603 of the Age of Pyre#{normal}#

I have done it! My fool of a master said I was not ready for the rites of lichdom, that I would attract undue attention... what utter idiocy. Already I can feel the transformation taking place, and I am certain that this weakness will only be momentary. My master was foolish to leave the Grimoire of Mortality Transcended open and unattended! All I needed was a bone from a magical creature, and as luck would have it, I had found a skeletal corpse of a dragon not far from our tower. The other ingredients were trivial and in possession of my master... surely he will be astounded that I, Zilquick the Eternal, will have transcended mortality!

(Another entry is written beneath this one, in a much more elegant and controlled script.)

Zilquick the Eternal, hah! What an unbearable buffoon, and I am glad his pride was his undoing. The young fool used up the Ruby of Eldoral in creating his phylactery, however; I must acquire a new phylactery for myself. On the bright side, my incompetent apprentice did illustrate why a bone from a creature slain by my own hand is important: the dragon bone he chose had left to fester a mold infection, and the mold somehow infused itself with the bone's inherent magical properties, altering the magical composition of the spell. I do hope whoever finds this note shall kill this "lich" using the most painful means available, and shall deposit him someplace where he is sure to be found.
Oh, look. He is trying to harm me with spells, but all he can manage is a corruption of his own name: Z'quikzshl.]], "_t")
t([[Dirge of the Naloren

There once was a village
the Nalore held dear,
but when Ol' Walrog came t'pillage,
they cowered in fear.

He trampled their men
and their babes newly born,
and seeing it finished,
he summoned a storm.

So remember old Shellsea
as she was in the past,
for Ol' Walrog sent the gale
that drowned her at last.]], [[Dirge of the Naloren

There once was a village
the Nalore held dear,
but when Ol' Walrog came t'pillage,
they cowered in fear.

He trampled their men
and their babes newly born,
and seeing it finished,
he summoned a storm.

So remember old Shellsea
as she was in the past,
for Ol' Walrog sent the gale
that drowned her at last.]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/noxious-caldera.lua"
-- 6 entries
t([[What wending path brought me to this place? I know not. The mists have obscured all passage, all trail. I see but the enclosing dominance of the caldera ahead. The ashen cauldron of steam lures me, yet repels me. I feel there is a force here trying to sway my thoughts.

Where are the rest of my party? Have my friends abandoned me?]], [[What wending path brought me to this place? I know not. The mists have obscured all passage, all trail. I see but the enclosing dominance of the caldera ahead. The ashen cauldron of steam lures me, yet repels me. I feel there is a force here trying to sway my thoughts.

Where are the rest of my party? Have my friends abandoned me?]], "_t")
t([[I fell into a trance, I know not how. Were it the rich blossoms or the oppressive heat? I swooned into the grass and the mists swirled over my face, playing out fantastic shapes before my eyes. Dancing ladies strode across the skies, and a row of dwarves stood laughing as their beards flew into the wind. Then I felt a Shadow near, and the ladies scattered and the dwarves in terror screamed, their mouths yowling and spilling black petals. I tried to move, but I couldn't, and frozen in fear I saw the Shadow above me, looking down upon my countenance. It grunted and lurched away. I passed out then, and have just recovered.

I am not sure what to make of this. I wish to leave, but I do not know the way. Only by escaping this mist shall I have a clear view of the land. Yet each path seems to wind unexpected, each step takes me closer to the centre, not further. I must make haste from this place.
]], [[I fell into a trance, I know not how. Were it the rich blossoms or the oppressive heat? I swooned into the grass and the mists swirled over my face, playing out fantastic shapes before my eyes. Dancing ladies strode across the skies, and a row of dwarves stood laughing as their beards flew into the wind. Then I felt a Shadow near, and the ladies scattered and the dwarves in terror screamed, their mouths yowling and spilling black petals. I tried to move, but I couldn't, and frozen in fear I saw the Shadow above me, looking down upon my countenance. It grunted and lurched away. I passed out then, and have just recovered.

I am not sure what to make of this. I wish to leave, but I do not know the way. Only by escaping this mist shall I have a clear view of the land. Yet each path seems to wind unexpected, each step takes me closer to the centre, not further. I must make haste from this place.
]], "_t")
t([[I have found a body, a fellow Thaloren by the looks of things. Her face was contorted in horror, her limbs twisted into painful shapes. Yet there was no blood, and I see not how she were felled. Was it the Shadow? I have buried her as best I could.

There are strange things in this land, and I am afeared. I saw a large ant earlier, and when I tried to stomp it underfoot it screamed at me, and called me names. I crushed it, and its eyes went red and burst, and it let out a shrill death cry that still echoes round my skull, scattering my thoughts.

My head aches, and with each pounding the earth visibly shakes beneath my feet. Is this a fever? I must get out of here!]], [[I have found a body, a fellow Thaloren by the looks of things. Her face was contorted in horror, her limbs twisted into painful shapes. Yet there was no blood, and I see not how she were felled. Was it the Shadow? I have buried her as best I could.

There are strange things in this land, and I am afeared. I saw a large ant earlier, and when I tried to stomp it underfoot it screamed at me, and called me names. I crushed it, and its eyes went red and burst, and it let out a shrill death cry that still echoes round my skull, scattering my thoughts.

My head aches, and with each pounding the earth visibly shakes beneath my feet. Is this a fever? I must get out of here!]], "_t")
t([[Another body, if one could call it that. Mangled remains strewn about a rocky outcrop, of whom I know not. Only the armour and weapon give tell that it were once an intelligent race. The breastplate still polished and undented, the axe still clean and un-notched, yet the flesh ripped apart like shredded paper. What could do this?!

I did not even attempt to bury the remains. I ran, and as frightful thoughts filled my head the sky turned red and the earth turned black, and spiders appeared with morphing faces. They laughed at me and spun their webs. I tore through them, the strands sticking to my fingers, mucousy remnants dripping over my skin. A surge of revulsion pulsed through me and suddenly the webs evaporated and the spiders coalesced into a giant face, its mouth a red flower. I reached into the midst of the crimson petals and it exploded in a wet mess, blinding all sight and thought.

I woke up with my flesh drenched in blood. Or is it blood? Is it my flesh? The ground rumbles with my every moan, the mists swirl with my every sigh. I am closer to the heart of the caldera now. Closer to finding the truth. The truth of this place. The truth of myself...]], [[Another body, if one could call it that. Mangled remains strewn about a rocky outcrop, of whom I know not. Only the armour and weapon give tell that it were once an intelligent race. The breastplate still polished and undented, the axe still clean and un-notched, yet the flesh ripped apart like shredded paper. What could do this?!

I did not even attempt to bury the remains. I ran, and as frightful thoughts filled my head the sky turned red and the earth turned black, and spiders appeared with morphing faces. They laughed at me and spun their webs. I tore through them, the strands sticking to my fingers, mucousy remnants dripping over my skin. A surge of revulsion pulsed through me and suddenly the webs evaporated and the spiders coalesced into a giant face, its mouth a red flower. I reached into the midst of the crimson petals and it exploded in a wet mess, blinding all sight and thought.

I woke up with my flesh drenched in blood. Or is it blood? Is it my flesh? The ground rumbles with my every moan, the mists swirl with my every sigh. I am closer to the heart of the caldera now. Closer to finding the truth. The truth of this place. The truth of myself...]], "_t")
t("dogroth caldera", "dogroth caldera", "newLore category")
t([[Broken land and broken thoughts. If I think clearly the land runs smooth. But my thoughts are not clear. I think.

I am here and here is me, a reflection of my will. Is it my will any more? Perhaps I am the reflection, my actions inspired by the mists about me.

My dreams follow me as I wake, and wake as I follow them. I seek them and summon them and play with them. This is my playground now. Whatever I dream shall appear, and when I am tired I discard of them, rend them away.

Others want to disturb my games. They come as hawks and moths and snakes, and their mouths spill putrescence over my blessed soil. But let them come. I will play with them. We shall have a fun game together, I think.

And what I think is what is real.]], [[Broken land and broken thoughts. If I think clearly the land runs smooth. But my thoughts are not clear. I think.

I am here and here is me, a reflection of my will. Is it my will any more? Perhaps I am the reflection, my actions inspired by the mists about me.

My dreams follow me as I wake, and wake as I follow them. I seek them and summon them and play with them. This is my playground now. Whatever I dream shall appear, and when I am tired I discard of them, rend them away.

Others want to disturb my games. They come as hawks and moths and snakes, and their mouths spill putrescence over my blessed soil. But let them come. I will play with them. We shall have a fun game together, I think.

And what I think is what is real.]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/old-forest.lua"
-- 10 entries
t([[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER ONE: THE SHER'TUL

#{normal}#The Sher'Tul. Who were they? Where did they come from? Where did they go? The mysteries surrounding this ancient race are almost infinite. What little scraps of information we have regarding them allude to a mighty and world-spanning civilisation, wielding power and magic unthinkable. Now, however, all that remains of them are forgotten, wind-swept ruins, the tiniest minutiae of their technology sealed away in the studies of reclusive sages. Does their mystery not call to your curious nature as it does mine, gentle reader?

My quest has drawn me into the Old Forest. What is there to be said about a place like "the old forest"? It is a forest, and it is old. By its unimaginative moniker you can guess how important this place is to the people of Derth; the only locals who commonly venture under its boughs are novice alchemists in search of ingredients, plus the odd hunter with his sights set low. However, the story of this old forest now takes a more interesting twist...

Rumours are growing of trees roaming in its depths, moving as you or I would. Some even claim that they now possess the spark of sentience. The Sher'Tul were rumoured to hold the power of animism... is this mere coincidence?]], [[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER ONE: THE SHER'TUL

#{normal}#The Sher'Tul. Who were they? Where did they come from? Where did they go? The mysteries surrounding this ancient race are almost infinite. What little scraps of information we have regarding them allude to a mighty and world-spanning civilisation, wielding power and magic unthinkable. Now, however, all that remains of them are forgotten, wind-swept ruins, the tiniest minutiae of their technology sealed away in the studies of reclusive sages. Does their mystery not call to your curious nature as it does mine, gentle reader?

My quest has drawn me into the Old Forest. What is there to be said about a place like "the old forest"? It is a forest, and it is old. By its unimaginative moniker you can guess how important this place is to the people of Derth; the only locals who commonly venture under its boughs are novice alchemists in search of ingredients, plus the odd hunter with his sights set low. However, the story of this old forest now takes a more interesting twist...

Rumours are growing of trees roaming in its depths, moving as you or I would. Some even claim that they now possess the spark of sentience. The Sher'Tul were rumoured to hold the power of animism... is this mere coincidence?]], "_t")
t([[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER TWO: ANCIENT RUINS

#{normal}#My inquiries have paid off! It took much searching, and even more arm-twisting and cajoling once I had found my man, but a local lumberjack who plies his trade in the old forest has divulged to me an amazing secret! He speaks of ruins within the forest, a location where the living trees seem to congregate in larger numbers. He would not speak much of the place, and seemed to believe it cursed, but I did manage to squeeze out of him the appearance of the ruins, submerged in the middle of the great lake. There is no longer any doubt in my mind now: They belonged to the Sher'Tul!]], [[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER TWO: ANCIENT RUINS

#{normal}#My inquiries have paid off! It took much searching, and even more arm-twisting and cajoling once I had found my man, but a local lumberjack who plies his trade in the old forest has divulged to me an amazing secret! He speaks of ruins within the forest, a location where the living trees seem to congregate in larger numbers. He would not speak much of the place, and seemed to believe it cursed, but I did manage to squeeze out of him the appearance of the ruins, submerged in the middle of the great lake. There is no longer any doubt in my mind now: They belonged to the Sher'Tul!]], "_t")
t([[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER THREE: DISASTER!

#{normal}#Does my title not tell you enough? Disaster, and again disaster! True enough, these Sher'Tul ruins exist... several hundred feet at the bottom of a mighty lake! The lake of Nur, one of the largest in the old forest, has swallowed up the ruins in its murky depths. I am hardly a strong swimmer, gentle reader, but even if I could swim like a naga-spawned beast I could not hope to explore the ruin's sunken expanses before drowning. I fear I must abandon my present expedition... the trees are paying closer attention to me, and I do not believe it is of the pleasant sort...]], [[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER THREE: DISASTER!

#{normal}#Does my title not tell you enough? Disaster, and again disaster! True enough, these Sher'Tul ruins exist... several hundred feet at the bottom of a mighty lake! The lake of Nur, one of the largest in the old forest, has swallowed up the ruins in its murky depths. I am hardly a strong swimmer, gentle reader, but even if I could swim like a naga-spawned beast I could not hope to explore the ruin's sunken expanses before drowning. I fear I must abandon my present expedition... the trees are paying closer attention to me, and I do not believe it is of the pleasant sort...]], "_t")
t([[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER FOUR: NEEDS MUST...

#{normal}#Before I continue, I must make one thing clear: I am no great friend to the mages. Some powers simply were not meant for mortal hands or minds. As history has taught us time and again, from the sudden disappearance of the Sher'Tul to the Spellblaze and the plagues it brought in its wake, magic is wont to cause more harm than good. But I fear it is a necessity for my current task. During my stay in Derth a fellow traveller and I have become fast friends, often drinking together in the local tavern. I can't put my finger on it, but I believe him to be a mage; he has an unexplainable feeling of power surrounding him, not to mention a rather ostentatious hat. I wonder what his thoughts would be on the art of water-breathing...?]], [[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER FOUR: NEEDS MUST...

#{normal}#Before I continue, I must make one thing clear: I am no great friend to the mages. Some powers simply were not meant for mortal hands or minds. As history has taught us time and again, from the sudden disappearance of the Sher'Tul to the Spellblaze and the plagues it brought in its wake, magic is wont to cause more harm than good. But I fear it is a necessity for my current task. During my stay in Derth a fellow traveller and I have become fast friends, often drinking together in the local tavern. I can't put my finger on it, but I believe him to be a mage; he has an unexplainable feeling of power surrounding him, not to mention a rather ostentatious hat. I wonder what his thoughts would be on the art of water-breathing...?]], "_t")
t("old forest", "old forest", "newLore category")
t("journal entry (old forest)", "journal entry (old forest)", "_t")
t([[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER FIVE: HORR...

#{italic}#This note seems hastily written and stained with water and blood.

#{normal}#I... I haven't got long.
The key is here, but I never ... the door.

I was unprepared! The trees I could avoid, the water I ... traverse, but beyond...
Horrors ... tentacles ... blazing light that burned in an instant ...
My flesh devoured, my mind shattered ... worms, alive, walking tog ...
... barely escaped. But my wounds are too ... blood won't stop ...

I thought the Sher'Tul wonderful, I was entranced ... every facet of knowledge I could gain ...
But this, is this their legacy? ... horrifying ... all my dreams ... Perhaps death is welcome now...

If any come after, I bid you turn ... horrors ... too much. If you are foolish enough to ... my only advice is to ...

#{italic}#You find with the note a tiny, faintly glowing orb - is this the key the note mentions?
#{normal}#]], [[#{italic}#From the notes of Darwood Oakton, explorer:
#{bold}#CHAPTER FIVE: HORR...

#{italic}#This note seems hastily written and stained with water and blood.

#{normal}#I... I haven't got long.
The key is here, but I never ... the door.

I was unprepared! The trees I could avoid, the water I ... traverse, but beyond...
Horrors ... tentacles ... blazing light that burned in an instant ...
My flesh devoured, my mind shattered ... worms, alive, walking tog ...
... barely escaped. But my wounds are too ... blood won't stop ...

I thought the Sher'Tul wonderful, I was entranced ... every facet of knowledge I could gain ...
But this, is this their legacy? ... horrifying ... all my dreams ... Perhaps death is welcome now...

If any come after, I bid you turn ... horrors ... too much. If you are foolish enough to ... my only advice is to ...

#{italic}#You find with the note a tiny, faintly glowing orb - is this the key the note mentions?
#{normal}#]], "_t")
t("lake of nur", "lake of nur", "newLore category")
t("magical barrier", "magical barrier", "_t")
t("As you descend to the next level you traverse a kind of magical barrier keeping the water away. You hear terrible screams.", "As you descend to the next level you traverse a kind of magical barrier keeping the water away. You hear terrible screams.", "_t")


------------------------------------------------
section "game/modules/tome/data/lore/orc-prides.lua"
-- 9 entries
t("Clinician Korbek's experimental notes part one", "Clinician Korbek's experimental notes part one", "_t")
t([[#{bold}#Clinician Korbek's experimental notes part one#{normal}#

What a dread and woeful task I have been given - the revival of our race. The swine humans and halflings have destroyed our whole society, and only the brutes of the military remain to rule our people. We are left with just a handful of women left, and without drastic measures we shall soon be extinct.

And those drastic measures come down to me. I am the sole orc left with any advanced medical knowledge, as I evacuated to the East before our settlement was wiped out. I must find a way to prolong the lives of our remaining females and have them breed at far faster rates. I will use all natural and magical means at my disposal.

I have taken this cavern up as a secret base, far away from the main encampment. I must do dark deeds here, and I wish them to remain hidden...]], [[#{bold}#Clinician Korbek's experimental notes part one#{normal}#

What a dread and woeful task I have been given - the revival of our race. The swine humans and halflings have destroyed our whole society, and only the brutes of the military remain to rule our people. We are left with just a handful of women left, and without drastic measures we shall soon be extinct.

And those drastic measures come down to me. I am the sole orc left with any advanced medical knowledge, as I evacuated to the East before our settlement was wiped out. I must find a way to prolong the lives of our remaining females and have them breed at far faster rates. I will use all natural and magical means at my disposal.

I have taken this cavern up as a secret base, far away from the main encampment. I must do dark deeds here, and I wish them to remain hidden...]], "_t")
t("Clinician Korbek's experimental notes part two", "Clinician Korbek's experimental notes part two", "_t")
t([[#{bold}#Clinician Korbek's experimental notes part two#{normal}#

I have begun work on several of the females. They are being kept in a coma for the duration of the experiments - it's far better that way. Initially I have subjected them to very high levels of wild infusion and arcane regeneration fields, whilst also keeping a direct feed into their stomachs high in protein. Corrupted blood is being pumped into their ovaries with a temporal acceleration field surrounding them. The leaders of each Pride have donated their seed for use in the experiments.

Initial results have mostly been immensely successful. Body mass has grown significantly, especially in the abdominal region. One has even begun developing extra ovaries and sexual organs. I have managed to increase their fertility immensely, and the stimulated foetal growth rate means that new orcs take only eight weeks from conception to birth. The young also seem to be progressing in their development at a very advanced pace, with particularly accelerated muscle development.

Some females have died during the procedures. I can only presume these were the weaker subjects, but it is a tragic loss regardless.]], [[#{bold}#Clinician Korbek's experimental notes part two#{normal}#

I have begun work on several of the females. They are being kept in a coma for the duration of the experiments - it's far better that way. Initially I have subjected them to very high levels of wild infusion and arcane regeneration fields, whilst also keeping a direct feed into their stomachs high in protein. Corrupted blood is being pumped into their ovaries with a temporal acceleration field surrounding them. The leaders of each Pride have donated their seed for use in the experiments.

Initial results have mostly been immensely successful. Body mass has grown significantly, especially in the abdominal region. One has even begun developing extra ovaries and sexual organs. I have managed to increase their fertility immensely, and the stimulated foetal growth rate means that new orcs take only eight weeks from conception to birth. The young also seem to be progressing in their development at a very advanced pace, with particularly accelerated muscle development.

Some females have died during the procedures. I can only presume these were the weaker subjects, but it is a tragic loss regardless.]], "_t")
t("Clinician Korbek's experimental notes part three", "Clinician Korbek's experimental notes part three", "_t")
t([[#{bold}#Clinician Korbek's experimental notes part three#{normal}#

My work is continuing with tremendous success. All subjects now have multiple operational wombs, thanks to the corrupted blood infusions coupled with arcane regeneration fields to quickly repair the corrupted tissues. With greater advances in accelerating the foetal growth stage we are now seeing new orcs every few days! I believe this can be pushed even further.

Though the wombs operate at an advanced rate, we are keeping their vital organs suppressed to extend their lifespans. Perhaps they can live for hundreds, if not thousands of years.

Pumping nutrients directly into their stomach is proving a difficulty with the increased activity in the abdominal region. I am currently investigating ways to condense nutrients into the atmosphere so that the subjects can be passively fed through breathing. Initial tests show a slimy build-up on the skin but no other negative side-effects.]], [[#{bold}#Clinician Korbek's experimental notes part three#{normal}#

My work is continuing with tremendous success. All subjects now have multiple operational wombs, thanks to the corrupted blood infusions coupled with arcane regeneration fields to quickly repair the corrupted tissues. With greater advances in accelerating the foetal growth stage we are now seeing new orcs every few days! I believe this can be pushed even further.

Though the wombs operate at an advanced rate, we are keeping their vital organs suppressed to extend their lifespans. Perhaps they can live for hundreds, if not thousands of years.

Pumping nutrients directly into their stomach is proving a difficulty with the increased activity in the abdominal region. I am currently investigating ways to condense nutrients into the atmosphere so that the subjects can be passively fed through breathing. Initial tests show a slimy build-up on the skin but no other negative side-effects.]], "_t")
t("Clinician Korbek's experimental notes part four", "Clinician Korbek's experimental notes part four", "_t")
t([[#{bold}#Clinician Korbek's experimental notes part four#{normal}#

Oh horrors... Oh black bilious terrors! What have I done? What vile and black sin have I done?!

I have so long been concentrating on my objectives that I never stopped to think of the monstrous acts I was performing on these women. But last night I decided to take one out of her coma to see what reactions there might be. What reaction indeed! Her first action was to moan in pain - her swollen lungs have deprived her of any other form of communication. But then she opened her eyes and saw herself, and saw the others around her, and the panic and disgust that filled those eyes reached into my very soul.

She wanted to die. I know she wanted to die, I could see her accusing eyes on me begging to let her die. But I cannot, I cannot... This is too terrible. I should burn this cave to the ground, and erase my horrible actions from existence! But where would that leave our people...

My mind is in torment. I cannot live like this any longer... I cannot live...]], [[#{bold}#Clinician Korbek's experimental notes part four#{normal}#

Oh horrors... Oh black bilious terrors! What have I done? What vile and black sin have I done?!

I have so long been concentrating on my objectives that I never stopped to think of the monstrous acts I was performing on these women. But last night I decided to take one out of her coma to see what reactions there might be. What reaction indeed! Her first action was to moan in pain - her swollen lungs have deprived her of any other form of communication. But then she opened her eyes and saw herself, and saw the others around her, and the panic and disgust that filled those eyes reached into my very soul.

She wanted to die. I know she wanted to die, I could see her accusing eyes on me begging to let her die. But I cannot, I cannot... This is too terrible. I should burn this cave to the ground, and erase my horrible actions from existence! But where would that leave our people...

My mind is in torment. I cannot live like this any longer... I cannot live...]], "_t")
t([[#{bold}#Captain Gumlarat's report#{normal}#

I have found clinician Korbek's body in his study. It seems he slit his own throat. This would explain the lack of reports in the last few days.

The reason for suicide is beyond understanding. His research has been immensely successful. Our race can now return to strength! I have read through his notes and based on his findings I will increase the procedures being used to allow for even faster birth rates. The Pride leaders will be pleased.

I see his notes also suggest the mothers may be in pain. I will allow a doping infusion to be administered to alleviate this. We would not wish our women to suffer...

]], [[#{bold}#Captain Gumlarat's report#{normal}#

I have found clinician Korbek's body in his study. It seems he slit his own throat. This would explain the lack of reports in the last few days.

The reason for suicide is beyond understanding. His research has been immensely successful. Our race can now return to strength! I have read through his notes and based on his findings I will increase the procedures being used to allow for even faster birth rates. The Pride leaders will be pleased.

I see his notes also suggest the mothers may be in pain. I will allow a doping infusion to be administered to alleviate this. We would not wish our women to suffer...

]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/rhaloren.lua"
-- 8 entries
t([[We must be on guard. The Council of Elders is desperate to find us, to hunt us down and suppress us. But we will not be suppressed. We have our rights! Their scouts try to track us down, and their spies try to infiltrate our numbers. They cannot accept any others having power, or any voice but their own being heard.

We have split away from our people, and we follow our own path now. We are outcasts. They call us renegades, anarchists; they think of us as nothing but vermin to be crushed underfoot. But we will not endure their cruel suppression. Our voice will be heard across the world and they shall recognise a new race of power - the mighty Rhaloren!

-- The Inquisitor
]], [[We must be on guard. The Council of Elders is desperate to find us, to hunt us down and suppress us. But we will not be suppressed. We have our rights! Their scouts try to track us down, and their spies try to infiltrate our numbers. They cannot accept any others having power, or any voice but their own being heard.

We have split away from our people, and we follow our own path now. We are outcasts. They call us renegades, anarchists; they think of us as nothing but vermin to be crushed underfoot. But we will not endure their cruel suppression. Our voice will be heard across the world and they shall recognise a new race of power - the mighty Rhaloren!

-- The Inquisitor
]], "_t")
t([[The Scintillating Caverns must be protected. Our great leader has ordered it so, and his word is more binding than any law. Our numbers are few, and we must move in secrecy, but a quiet watch will be made on the caverns. Any who are seen to interfere in them must be lured here to our place of strength, and brought before me for inquisition.

More have joined our cause. Their eyes have been opened to the injustice our people have suffered, blamed by the other races for the Spellblaze and its effects. They are sick of the cowardice of the Council, who sit in silence as we are scorned and hated across the world. But most of all they are inspired by our great leader, and the powers he has gained from studying the Spellblaze. He alone realizes our full potential, he alone can see in our hearts what we are truly capable of. He has blessed me, rescued me from a tortured life and touched me with his power. Only he can lead our people! With his mastery the world will see our strength and recognise us as a true force to be reckoned with.

Trust in his power, for he shall bring us all to glory.

-- The Inquisitor]], [[The Scintillating Caverns must be protected. Our great leader has ordered it so, and his word is more binding than any law. Our numbers are few, and we must move in secrecy, but a quiet watch will be made on the caverns. Any who are seen to interfere in them must be lured here to our place of strength, and brought before me for inquisition.

More have joined our cause. Their eyes have been opened to the injustice our people have suffered, blamed by the other races for the Spellblaze and its effects. They are sick of the cowardice of the Council, who sit in silence as we are scorned and hated across the world. But most of all they are inspired by our great leader, and the powers he has gained from studying the Spellblaze. He alone realizes our full potential, he alone can see in our hearts what we are truly capable of. He has blessed me, rescued me from a tortured life and touched me with his power. Only he can lead our people! With his mastery the world will see our strength and recognise us as a true force to be reckoned with.

Trust in his power, for he shall bring us all to glory.

-- The Inquisitor]], "_t")
t([[For too long we have been taught that the Spellblaze was a tragedy, that we are responsible for the deaths of millions and for suffering across the world. These are lies! Lies spread to defame us, to prevent our people from using magic to its rightful degree. The lesser races are jealous of our powers, of our amazing potential, and so they think to keep us underfoot, to stop us from ascending to our rightful place in the world. They fear us.

The truth is that the Spellblaze was an experiment that went wrong. Many of our greatest mages died from the resulting energies, and some lands nearby were set ablaze. But there was no loss of life amongst the other races - it is their own wars that caused that, and their own squalid societies that brought about the plagues that followed. Many centuries later a great natural earthquake occurred that tore the lands apart, and the other races had the audacity to blame that on us.

For this reason they persecuted us during the Spellhunt. Many of our mages were killed
mercilessly, and even those with no affinity to magic were brutally slaughtered in the terrible crusade. Even today we suffer discrimination and persecution, and tales still spread of innocent Shaloren burned at the stake or chopped to pieces. And what does the Council do? It sits in silence and hopes people will just forget.

But no more! The time will come when the truth shall be known, and retribution will fall on any that deny us our rights.

-- The Inquisitor]], [[For too long we have been taught that the Spellblaze was a tragedy, that we are responsible for the deaths of millions and for suffering across the world. These are lies! Lies spread to defame us, to prevent our people from using magic to its rightful degree. The lesser races are jealous of our powers, of our amazing potential, and so they think to keep us underfoot, to stop us from ascending to our rightful place in the world. They fear us.

The truth is that the Spellblaze was an experiment that went wrong. Many of our greatest mages died from the resulting energies, and some lands nearby were set ablaze. But there was no loss of life amongst the other races - it is their own wars that caused that, and their own squalid societies that brought about the plagues that followed. Many centuries later a great natural earthquake occurred that tore the lands apart, and the other races had the audacity to blame that on us.

For this reason they persecuted us during the Spellhunt. Many of our mages were killed
mercilessly, and even those with no affinity to magic were brutally slaughtered in the terrible crusade. Even today we suffer discrimination and persecution, and tales still spread of innocent Shaloren burned at the stake or chopped to pieces. And what does the Council do? It sits in silence and hopes people will just forget.

But no more! The time will come when the truth shall be known, and retribution will fall on any that deny us our rights.

-- The Inquisitor]], "_t")
t("letter (rhaloren camp)", "letter (rhaloren camp)", "_t")
t([[I have great news! Our glorious leader has written to me, telling me of his travels. He is on a great pilgrimage, a holy quest to discover more about the Spellblaze and its powers, so that we may show the truth about it to the world. It is a quest fraught with peril, for we have many enemies in the world. But by his powers he cannot fail. He cannot! He cannot...

One day soon he will return to us, and bring us to our proper glory. Look forward to that great time, when he is amongst us once more. Be ready for that moment when he stands tall before us and looks at us with his deep eyes... Work hard now and be attentive in your duties, so that we may make him proud. We fight for him, we struggle for him, and if needs be we will die for him. He is our hope and our glory, and the only joy we have in this dispassionate world.

-- The Inquisitor
]], [[I have great news! Our glorious leader has written to me, telling me of his travels. He is on a great pilgrimage, a holy quest to discover more about the Spellblaze and its powers, so that we may show the truth about it to the world. It is a quest fraught with peril, for we have many enemies in the world. But by his powers he cannot fail. He cannot! He cannot...

One day soon he will return to us, and bring us to our proper glory. Look forward to that great time, when he is amongst us once more. Be ready for that moment when he stands tall before us and looks at us with his deep eyes... Work hard now and be attentive in your duties, so that we may make him proud. We fight for him, we struggle for him, and if needs be we will die for him. He is our hope and our glory, and the only joy we have in this dispassionate world.

-- The Inquisitor
]], "_t")
t("rhaloren", "rhaloren", "newLore category")
t("carefully preserved letter (rhaloren camp)", "carefully preserved letter (rhaloren camp)", "_t")
t([[My dearest,

I hope this letter finds you well. I worry for you, so close to the city, so vulnerable should they find our base... But I trust in your strength, and I know you will be safe. Yet should anything happen...

I wish you were here with me, able to share in the wonders I have seen. Yet this journey has far more perils. The Ziguranth have been on to us, tracking us relentlessly, spoiling many of my plans. They are truly a force to be reckoned with. But luck is with me - I have managed to capture one and find out the location of their base. Soon we shall prepare an attack that shall put an end to their threat forever.

Ah, but there is something more exciting even than that! Near the Charred Scar I have uncovered a truly amazing thing - a mark of the Spellblaze. Oh, how I long for you to be here with me to see its wonders! You of all people know my passions so well, and what delight you would find in what I have discovered here. Here is where our future lies. Here is where we shall gain the power to truly strike out on our own!

Look after our people well, and keep strong our base for when I return. It shall be soon, I hope, and it shall be in glory.

With passion abound,
Your dearest love]], [[My dearest,

I hope this letter finds you well. I worry for you, so close to the city, so vulnerable should they find our base... But I trust in your strength, and I know you will be safe. Yet should anything happen...

I wish you were here with me, able to share in the wonders I have seen. Yet this journey has far more perils. The Ziguranth have been on to us, tracking us relentlessly, spoiling many of my plans. They are truly a force to be reckoned with. But luck is with me - I have managed to capture one and find out the location of their base. Soon we shall prepare an attack that shall put an end to their threat forever.

Ah, but there is something more exciting even than that! Near the Charred Scar I have uncovered a truly amazing thing - a mark of the Spellblaze. Oh, how I long for you to be here with me to see its wonders! You of all people know my passions so well, and what delight you would find in what I have discovered here. Here is where our future lies. Here is where we shall gain the power to truly strike out on our own!

Look after our people well, and keep strong our base for when I return. It shall be soon, I hope, and it shall be in glory.

With passion abound,
Your dearest love]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/sandworm.lua"
-- 6 entries
t([[I have stared in the mouths of crimson wyrms
And felt the claws of drakes so sleek
But through deserts dry and sandy storms
There is something else I seek

In the trail of giant worms I walk
Through tunnels of sand below
Of arcane tools let there be no talk
It's on the wyrmic path I go!]], [[I have stared in the mouths of crimson wyrms
And felt the claws of drakes so sleek
But through deserts dry and sandy storms
There is something else I seek

In the trail of giant worms I walk
Through tunnels of sand below
Of arcane tools let there be no talk
It's on the wyrmic path I go!]], "_t")
t([[The dragon's breath corrodes my eyes
It tears flesh from my skin
But onward I search to see what lies
Amidst the sandy depths within

The piles of sand fall past my head
Nearly crushing me alive
But I hurry on bereft of dread
For my quest I must survive!]], [[The dragon's breath corrodes my eyes
It tears flesh from my skin
But onward I search to see what lies
Amidst the sandy depths within

The piles of sand fall past my head
Nearly crushing me alive
But I hurry on bereft of dread
For my quest I must survive!]], "_t")
t([[The sandworms go from strength to strength
Ever greater do they seem
Of towering height and massive length
It is all as if a dream...

To the darkest depths I now depart
In search of my one fate
How I long to taste the beating heart
Of the legendary worm so great!]], [[The sandworms go from strength to strength
Ever greater do they seem
Of towering height and massive length
It is all as if a dream...

To the darkest depths I now depart
In search of my one fate
How I long to taste the beating heart
Of the legendary worm so great!]], "_t")
t("sandworm lair", "sandworm lair", "newLore category")
t("song of the sands", "song of the sands", "_t")
t([[I have seen the Queen in glory true
And she has moved me to my soul
Oh Queen! Let me be a part of you!
Please devour me! Swallow me whole!!]], [[I have seen the Queen in glory true
And she has moved me to my soul
Oh Queen! Let me be a part of you!
Please devour me! Swallow me whole!!]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/scintillating-caves.lua"
-- 13 entries
t("research journal part 1", "research journal part 1", "_t")
t([[I have been given permission to explore the scintillating caves to the east. Normally they are sealed off, but having a father on the council has its uses, even if he is normally a dumb buffoon...

These caves are the site of where the Spellblaze began. An ancient Sher'Tul farportal lay buried here, and our ancestors tapped into that power to their destruction. Many of the greatest Shaloren mages stood here, and when the energies beyond comprehension erupted they were all annihilated instantly. It was a terrible loss to our people - such knowledge and power lost forever!

Now the ancient ruins have become overgrown by crystals. Reports say that they grow each year. Could they be alive..?

I must admit that stepping into the starting place of the Spellblaze fills me with immense trepidation. This was where the great destruction began, that tore through our world, wiping out cities, tearing the world apart. And yet look at the beauty here!
]], [[I have been given permission to explore the scintillating caves to the east. Normally they are sealed off, but having a father on the council has its uses, even if he is normally a dumb buffoon...

These caves are the site of where the Spellblaze began. An ancient Sher'Tul farportal lay buried here, and our ancestors tapped into that power to their destruction. Many of the greatest Shaloren mages stood here, and when the energies beyond comprehension erupted they were all annihilated instantly. It was a terrible loss to our people - such knowledge and power lost forever!

Now the ancient ruins have become overgrown by crystals. Reports say that they grow each year. Could they be alive..?

I must admit that stepping into the starting place of the Spellblaze fills me with immense trepidation. This was where the great destruction began, that tore through our world, wiping out cities, tearing the world apart. And yet look at the beauty here!
]], "_t")
t("research journal part 2", "research journal part 2", "_t")
t([[I have definitely seen crystals move of their own volition here, and some even seem capable of producing magical effects in self-defence. They are no threat to me whatsoever - my arcane powers are far beyond whatever latent magic seems to possess these things.

Possession... is what it almost seems like. These crystals are not natural. I have broken some down and studied them, and the very structure of the material seems vastly distinct from any other I have seen. I have even studied Sher'Tul relics in the Academy and this is most certainly something different. Truly fascinating!
]], [[I have definitely seen crystals move of their own volition here, and some even seem capable of producing magical effects in self-defence. They are no threat to me whatsoever - my arcane powers are far beyond whatever latent magic seems to possess these things.

Possession... is what it almost seems like. These crystals are not natural. I have broken some down and studied them, and the very structure of the material seems vastly distinct from any other I have seen. I have even studied Sher'Tul relics in the Academy and this is most certainly something different. Truly fascinating!
]], "_t")
t("research journal part 3", "research journal part 3", "_t")
t([[Earth, water, fire, air - these are the elements we forge our magic with, and all of these I have seen manifested in the crystals here. But there is something else, something different... There are dark crystals here which seem to posses some new, destructive element - a very twisting of the nature of the other elements, warping them into malign designs.

Why have I never seen this before?! I must study it, I must understand it - I must comprehend its very nature and hold its power in my own hands... The thirst for knowledge is all-consuming!

I shall name this new element "blight".]], [[Earth, water, fire, air - these are the elements we forge our magic with, and all of these I have seen manifested in the crystals here. But there is something else, something different... There are dark crystals here which seem to posses some new, destructive element - a very twisting of the nature of the other elements, warping them into malign designs.

Why have I never seen this before?! I must study it, I must understand it - I must comprehend its very nature and hold its power in my own hands... The thirst for knowledge is all-consuming!

I shall name this new element "blight".]], "_t")
t("research journal part 4", "research journal part 4", "_t")
t([[I can see it now, I can see so clearly... The forces at work here are not of this world. They are a result of the Spellblaze, from the tearing of the fabric of our world. And from outside that fabric... something else, something truly powerful, trying to force its way in. I feel I can almost reach out and touch it! Such awesome power it is... could this even rival the renowned powers of the Sher'Tul?

The crystals are a corruption of the elements of Maj'Eyal. These outside forces are changing the very make-up of the matter of our world. This cavern is truly a garden of delights, a font of growth and energy. Who knows how far this garden of wonders could spread if we encourage it more? Perhaps the whole of our world could be enveloped in this scintillating glory, a grand corruption for all Eyal!

I have begun to train myself in controlling this "blight". It takes much energy, draining my very vim, but I can feel the tremendous power behind it. I must tap into it more...]], [[I can see it now, I can see so clearly... The forces at work here are not of this world. They are a result of the Spellblaze, from the tearing of the fabric of our world. And from outside that fabric... something else, something truly powerful, trying to force its way in. I feel I can almost reach out and touch it! Such awesome power it is... could this even rival the renowned powers of the Sher'Tul?

The crystals are a corruption of the elements of Maj'Eyal. These outside forces are changing the very make-up of the matter of our world. This cavern is truly a garden of delights, a font of growth and energy. Who knows how far this garden of wonders could spread if we encourage it more? Perhaps the whole of our world could be enveloped in this scintillating glory, a grand corruption for all Eyal!

I have begun to train myself in controlling this "blight". It takes much energy, draining my very vim, but I can feel the tremendous power behind it. I must tap into it more...]], "_t")
t("research journal part 5", "research journal part 5", "_t")
t([[I sought to reach out and touch the abyss, but I found it touched me first... I have been blessed, I have been fully awoken!

There is a wonder here, a wonder beyond all else I have ever seen. A crystal of amazing intricacy and beauty, with a halo of power that echoes of the original energies of the Spellblaze. All the power that our ancestors unlocked, mixed with the glorious corruption that it triggered. What beauty - what tremendous beauty!

I felt it touch me, I felt it reach into my heart and imbue me with its strength. I stood entranced as its energy flowed into me. Oh how the blood now courses through my veins! Blood corrupted with true power!

I see now the path that lies before me. The Spellblaze was not a curse, it was a blessing. I must open our people's eyes to the glory that our race has unlocked! I shall bring the wonders of this corruption to the whole world!]], [[I sought to reach out and touch the abyss, but I found it touched me first... I have been blessed, I have been fully awoken!

There is a wonder here, a wonder beyond all else I have ever seen. A crystal of amazing intricacy and beauty, with a halo of power that echoes of the original energies of the Spellblaze. All the power that our ancestors unlocked, mixed with the glorious corruption that it triggered. What beauty - what tremendous beauty!

I felt it touch me, I felt it reach into my heart and imbue me with its strength. I stood entranced as its energy flowed into me. Oh how the blood now courses through my veins! Blood corrupted with true power!

I see now the path that lies before me. The Spellblaze was not a curse, it was a blessing. I must open our people's eyes to the glory that our race has unlocked! I shall bring the wonders of this corruption to the whole world!]], "_t")
t("scintillating caves", "scintillating caves", "newLore category")
t("exploration journal", "exploration journal", "_t")
t([[#{italic}#10th Mirth, Year 122 of the Age of Ascendancy#{normal}#
The council has seen fit to allow me to investigate the scintillating caverns after that Rhaloren madman started raving on the streets about how someone had "befouled" them... I do not see any such befoulment, but neither do I see the moving crystals this place was rumoured to have. There are oddly misplaced crystal shards, which seem to have sheared off of something larger, but hardly anything spectacular.

#{italic}#2nd Summertide, Year 122 of the Age of Ascendancy#{normal}#
It's strange, really.. from the fragments I've been able to find, they seem to adhere to the ethereal geometry of magics - the red fragments seem to be pieces of fire magic from their geometry; the blue adheres to water, etc... there also seem to be pieces of deformed crystal, as though some terrible power warped whatever colour some of these crystals used to be into something they were never intended to be - is this the "befoulment" the madman raved about?

#{italic}#3rd Summertide, Year 122 of the Age of Ascendancy#{normal}#
Well... that was certainly unexpected. There may be some truth to the rumours that these crystals can move about, or at least that they have some will of their own - I was just about to finish my investigation of the caves, when in the very last part of the cave I hadn't yet explored, I saw what appeared to be two giant... legs, growing from the cavern. I was immediately overcome by feelings of fear and malice, and not my own - that crystal sent them to me, that I was unwelcome here, that it was not yet finished. I dare not tell the council of my cowardice, so I shall... invent a more fitting report in a much safer place. If some wayward adventurer finds these notes, it is my surmise that whomever destroyed the original crystals left such a strong impression of strength and will that the rudimentary intelligence governing them decided the form of its destroyer was stronger than the original, crystalline shapes.]], [[#{italic}#10th Mirth, Year 122 of the Age of Ascendancy#{normal}#
The council has seen fit to allow me to investigate the scintillating caverns after that Rhaloren madman started raving on the streets about how someone had "befouled" them... I do not see any such befoulment, but neither do I see the moving crystals this place was rumoured to have. There are oddly misplaced crystal shards, which seem to have sheared off of something larger, but hardly anything spectacular.

#{italic}#2nd Summertide, Year 122 of the Age of Ascendancy#{normal}#
It's strange, really.. from the fragments I've been able to find, they seem to adhere to the ethereal geometry of magics - the red fragments seem to be pieces of fire magic from their geometry; the blue adheres to water, etc... there also seem to be pieces of deformed crystal, as though some terrible power warped whatever colour some of these crystals used to be into something they were never intended to be - is this the "befoulment" the madman raved about?

#{italic}#3rd Summertide, Year 122 of the Age of Ascendancy#{normal}#
Well... that was certainly unexpected. There may be some truth to the rumours that these crystals can move about, or at least that they have some will of their own - I was just about to finish my investigation of the caves, when in the very last part of the cave I hadn't yet explored, I saw what appeared to be two giant... legs, growing from the cavern. I was immediately overcome by feelings of fear and malice, and not my own - that crystal sent them to me, that I was unwelcome here, that it was not yet finished. I dare not tell the council of my cowardice, so I shall... invent a more fitting report in a much safer place. If some wayward adventurer finds these notes, it is my surmise that whomever destroyed the original crystals left such a strong impression of strength and will that the rudimentary intelligence governing them decided the form of its destroyer was stronger than the original, crystalline shapes.]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/shertul.lua"
-- 40 entries
t("first mural painting", "first mural painting", "_t")
t([[You see here a mural showing a dark and tortured world. Large, god-like figures with powerful auras fight each other, and the earth is torn beneath their feet.
There is some text underneath ]], [[You see here a mural showing a dark and tortured world. Large, god-like figures with powerful auras fight each other, and the earth is torn beneath their feet.
There is some text underneath ]], "_t")
t("#{italic}#'In the beginning the world was dark, and the petty gods fought over their broken lands.'#{normal}#", "#{italic}#'In the beginning the world was dark, and the petty gods fought over their broken lands.'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Sho ch'zun Eyal mor donuth, ik ranaheli donoth trun ze.'#{normal}#", "which you do not understand: #{italic}#'Sho ch'zun Eyal mor donuth, ik ranaheli donoth trun ze.'#{normal}#", "_t")
t("second mural painting", "second mural painting", "_t")
t([[In this picture a huge god with glowing eyes towers above the land, and in his right hand he holds high the sun. The other gods are running from him, wincing from the light.
There is some text underneath ]], [[In this picture a huge god with glowing eyes towers above the land, and in his right hand he holds high the sun. The other gods are running from him, wincing from the light.
There is some text underneath ]], "_t")
t("#{italic}#'But AMAKTHEL came, and his might surpassed all else, and the petty gods fled before his glory. And he made the Sun from his breath and held it above the world and said, \"All that this light touches shall be mine, and this light shall touch all the world.'#{normal}#", "#{italic}#'But AMAKTHEL came, and his might surpassed all else, and the petty gods fled before his glory. And he made the Sun from his breath and held it above the world and said, \"All that this light touches shall be mine, and this light shall touch all the world.'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Fa AMAKTHEL tabak, ik koru bazan tro yu, ik ranaheli tobol don schek ruun. Ik blana dem Soli as banafel ik goriz uf Eyal ik blod, \"Tro fasa goru domus asam, ik goru domit tro Eyal.\"'#{normal}#", "which you do not understand: #{italic}#'Fa AMAKTHEL tabak, ik koru bazan tro yu, ik ranaheli tobol don schek ruun. Ik blana dem Soli as banafel ik goriz uf Eyal ik blod, \"Tro fasa goru domus asam, ik goru domit tro Eyal.\"'#{normal}#", "_t")
t("third mural painting", "third mural painting", "_t")
t([[This picture shows the huge god holding some smaller figures in his hands and pointing out at the lands beyond. You imagine these figures must be the Sher'Tul.
There is some text beneath ]], [[This picture shows the huge god holding some smaller figures in his hands and pointing out at the lands beyond. You imagine these figures must be the Sher'Tul.
There is some text beneath ]], "_t")
t("#{italic}#'And AMAKTHEL made the SHER'TUL, and gave unto us the powers to achieve all that we set our will to, and said to us \"Go forth to where the light touches and take all for your own.\"'#{normal}#", "#{italic}#'And AMAKTHEL made the SHER'TUL, and gave unto us the powers to achieve all that we set our will to, and said to us \"Go forth to where the light touches and take all for your own.\"'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Ik AMAKTHEL cosio SHER'TUL, ik baladath peris furko masa bren doth benna zi, ik blod is \"Fen makel ath goru domus ik denz tro ala fron.\"'#{normal}#", "which you do not understand: #{italic}#'Ik AMAKTHEL cosio SHER'TUL, ik baladath peris furko masa bren doth benna zi, ik blod is \"Fen makel ath goru domus ik denz tro ala fron.\"'#{normal}#", "_t")
t("fourth mural painting", "fourth mural painting", "_t")
t([[You see a mural showing a huge metropolis made of crystal, with small islands of stone floating in the air behind it. In the foreground is sitting a Sher'Tul, with a hand stretched up to the sky.
There is some text beneath ]], [[You see a mural showing a huge metropolis made of crystal, with small islands of stone floating in the air behind it. In the foreground is sitting a Sher'Tul, with a hand stretched up to the sky.
There is some text beneath ]], "_t")
t("#{italic}#'We conquered the world, and built for ourselves towering cities of crystal and fortresses that travelled the skies. But some were not content...'#{normal}#", "#{italic}#'We conquered the world, and built for ourselves towering cities of crystal and fortresses that travelled the skies. But some were not content...'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Batialatoth ro Eyal, ik rinsi akan fronseth sumit kurameth ik linnet pora gasios aeren. Ach nen beswar goreg.'#{normal}#", "which you do not understand: #{italic}#'Batialatoth ro Eyal, ik rinsi akan fronseth sumit kurameth ik linnet pora gasios aeren. Ach nen beswar goreg.'#{normal}#", "_t")
t("fifth mural painting", "fifth mural painting", "_t")
t([[This mural shows nine Sher'Tul standing side by side, each holding aloft a dark weapon. Your eyes are drawn to a runed staff held by the red-robed figure in the centre. It seems familiar somehow...
There is some text beneath ]], [[This mural shows nine Sher'Tul standing side by side, each holding aloft a dark weapon. Your eyes are drawn to a runed staff held by the red-robed figure in the centre. It seems familiar somehow...
There is some text beneath ]], "_t")
t("#{italic}#'Of pride we accepted no equals, and of greed we accepted no servitude. We made for ourselves terrible weapons - the Godslayers - and nine were chosen to wield them.'#{normal}#", "#{italic}#'Of pride we accepted no equals, and of greed we accepted no servitude. We made for ourselves terrible weapons - the Godslayers - and nine were chosen to wield them.'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Zubadon koref noch hesen, ik dorudon koref noch pasor. Cosief maro dondreth karatu - Ranaduzil - ik jein belsan ovrienis.'#{normal}#", "which you do not understand: #{italic}#'Zubadon koref noch hesen, ik dorudon koref noch pasor. Cosief maro dondreth karatu - Ranaduzil - ik jein belsan ovrienis.'#{normal}#", "_t")
t("sixth mural painting", "sixth mural painting", "_t")
t([[You see images of epic battles, with Sher'Tul warriors fighting and slaying god-like figures over ten times their size.
There is some text underneath ]], [[You see images of epic battles, with Sher'Tul warriors fighting and slaying god-like figures over ten times their size.
There is some text underneath ]], "_t")
t("#{italic}#'The petty gods were hunted down and slain, and their spirits rent to nothing. The land became our own. But one god remained...'#{normal}#", "#{italic}#'The petty gods were hunted down and slain, and their spirits rent to nothing. The land became our own. But one god remained...'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Ranaheli meth dondruil ik duzin, ik leisif konru as neremin. Eyal matath bre sun. Ach unu rana soriton...'#{normal}#", "which you do not understand: #{italic}#'Ranaheli meth dondruil ik duzin, ik leisif konru as neremin. Eyal matath bre sun. Ach unu rana soriton...'#{normal}#", "_t")
t("seventh mural painting", "seventh mural painting", "_t")
t([[You see the red-robed Sher'Tul striking the huge god with the dark, runed staff. Bodies litter the floor around them, and the golden throne behind is bathed in blood. The light in the god's eyes seems faded.
There is some text underneath ]], [[You see the red-robed Sher'Tul striking the huge god with the dark, runed staff. Bodies litter the floor around them, and the golden throne behind is bathed in blood. The light in the god's eyes seems faded.
There is some text underneath ]], "_t")
t("#{italic}#'The almighty AMAKTHEL was assaulted on his golden throne, and though many died before his feet, he was finally felled.'#{normal}#", "#{italic}#'The almighty AMAKTHEL was assaulted on his golden throne, and though many died before his feet, he was finally felled.'#{normal}#", "_t")
t("which you do not understand: #{italic}#'Trobazan AMAKTHEL konruata as va aurin leas, ik mab peli zort akan hun, penetar dondeberoth.'#{normal}#", "which you do not understand: #{italic}#'Trobazan AMAKTHEL konruata as va aurin leas, ik mab peli zort akan hun, penetar dondeberoth.'#{normal}#", "_t")
t("eighth mural painting", "eighth mural painting", "_t")
t([[The large mural shows the great god spread on the ground, with the dark staff held against his chest. Sher'Tul surround him, some hacking off his limbs, cutting out his tongue, and binding him with chains. A burst of light flares up from where a tall Sher'Tul warrior is gouging his eye with a black-bladed halberd. In the background a Sher'Tul mage beckons to a huge chasm in the ground.
The text beneath says simply ]], [[The large mural shows the great god spread on the ground, with the dark staff held against his chest. Sher'Tul surround him, some hacking off his limbs, cutting out his tongue, and binding him with chains. A burst of light flares up from where a tall Sher'Tul warrior is gouging his eye with a black-bladed halberd. In the background a Sher'Tul mage beckons to a huge chasm in the ground.
The text beneath says simply ]], "_t")
t("#{italic}#'Meas Abar.'#{normal}#", "#{italic}#'Meas Abar.'#{normal}#", "_t")
t("#{italic}#'The Great Sin.'#{normal}#", "#{italic}#'The Great Sin.'#{normal}#", "_t")
t("ninth mural painting", "ninth mural painting", "_t")
t("This final mural has been ruined, with deep scores and scratches etched across its surface. All you can see of the original appears to be flames.", "This final mural has been ruined, with deep scores and scratches etched across its surface. All you can see of the original appears to be flames.", "_t")
t("Yiilkgur raising toward the sky", "Yiilkgur raising toward the sky", "_t")
t("Yiilkgur, the Sher'Tul Fortress is re-activated and raises from the depths of Nur toward the sky.", "Yiilkgur, the Sher'Tul Fortress is re-activated and raises from the depths of Nur toward the sky.", "_t")
t("a living Sher'Tul?!", "a living Sher'Tul?!", "_t")
t("You somehow got teleported to an other Sher'Tul Fortress, in a very alien location. There you saw a living Sher'Tul.", "You somehow got teleported to an other Sher'Tul Fortress, in a very alien location. There you saw a living Sher'Tul.", "_t")
t("lost farportal", "lost farportal", "_t")
t("%s boldly entering a Sher'Tul farportal.", "%s boldly entering a Sher'Tul farportal.", "tformat")


------------------------------------------------
section "game/modules/tome/data/lore/slazish.lua"
-- 6 entries
t("conch (1)", "conch (1)", "_t")
t([[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a lyrical voice emanating from within:#{normal}#

"Report from Tidewarden Isimon to Tidebringer Zoisla. Alucia and I have, um, begun scouting the outer perimeter. The, uh, the terrain is proving difficult to navigate, but I'm sure we'll make, uh, quick progress. We shall, uh, we'll continue now... in the name of the Saviour!

"...Um, you think that was okay?"

#{italic}#A second, lighter voice joins in.#{normal}# "Yeah, that was fine, Isimon. We'll make a Myrmidon of you yet!"

"Heh, I wouldn't be so sure of that... Guess I'll turn this off and we'll get going."

"Hey, what's the rush? This is the first time we've been alone from the others all week. Maybe we could..."

"What? Surely you don't mean-? What if someone comes along?"

"Oh, who would catch us out here? Come on!"

"I, uh, well, I suppose... I should stop this recording."]], [[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a lyrical voice emanating from within:#{normal}#

"Report from Tidewarden Isimon to Tidebringer Zoisla. Alucia and I have, um, begun scouting the outer perimeter. The, uh, the terrain is proving difficult to navigate, but I'm sure we'll make, uh, quick progress. We shall, uh, we'll continue now... in the name of the Saviour!

"...Um, you think that was okay?"

#{italic}#A second, lighter voice joins in.#{normal}# "Yeah, that was fine, Isimon. We'll make a Myrmidon of you yet!"

"Heh, I wouldn't be so sure of that... Guess I'll turn this off and we'll get going."

"Hey, what's the rush? This is the first time we've been alone from the others all week. Maybe we could..."

"What? Surely you don't mean-? What if someone comes along?"

"Oh, who would catch us out here? Come on!"

"I, uh, well, I suppose... I should stop this recording."]], "_t")
t("conch (2)", "conch (2)", "_t")
t([[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a deep voice emanating from within:#{normal}#

"Waverider Tiamel reporting. Immediate perimeter is secure, though I have sent some members to scout the surrounding areas. I will feel better when we have mapped the land and are ready to sustain a larger team. Still, we should be perfectly safe as long as the landdwellers do not know of our presence. And even if they dare come here the magics of Zoisla will put their puny star worship to shame.

"I fear that some of the team are not taking our mission seriously. Do they not know the responsibility the Saviour has laid on us? We are his arms and tails in this far land, and it is our duty to protect the farportal which will help bring us to greater strengths. We are his first line of attack against the blood relatives of those who doomed our race so long ago. And with our efforts we shall push forward our race to new boundaries, laying the path for the bright future our great Saviour has planned for us. Long live Slasul! Long live the legend of the Devourer!"]], [[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a deep voice emanating from within:#{normal}#

"Waverider Tiamel reporting. Immediate perimeter is secure, though I have sent some members to scout the surrounding areas. I will feel better when we have mapped the land and are ready to sustain a larger team. Still, we should be perfectly safe as long as the landdwellers do not know of our presence. And even if they dare come here the magics of Zoisla will put their puny star worship to shame.

"I fear that some of the team are not taking our mission seriously. Do they not know the responsibility the Saviour has laid on us? We are his arms and tails in this far land, and it is our duty to protect the farportal which will help bring us to greater strengths. We are his first line of attack against the blood relatives of those who doomed our race so long ago. And with our efforts we shall push forward our race to new boundaries, laying the path for the bright future our great Saviour has planned for us. Long live Slasul! Long live the legend of the Devourer!"]], "_t")
t("conch (3)", "conch (3)", "_t")
t([[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a charismatic and commanding voice emanating from within:#{normal}#

"My fellow nagas! I do not envy you on your journey so far from our great Temple. But you have been chosen for a glorious mission, to establish a new outpost for invasion against the landwalkers. These are the cousins and descendants of those who abandoned us and left our race for dead. Whilst we have hidden beneath the waves for centuries, they prance about worshipping the sun! Well, their nightfall comes soon, and the dawn will rise with us as rulers of land and sea.

"Do not despair that we are attacking this outpost instead of the orcs. My stratagem is carefully planned, and the Sunwall is too great a threat to my designs to be allowed to stand any longer. The orcs... will have their uses in the short term. But be assured, when our time comes there shall be none who can stand as equals against us. Our greatness cannot be quelled or submerged! Our long history of suffering will finally bring forth redemption!

"Your immediate mission is clear, my friends. Ensure the farportal is correctly set up and secured, but take care, as the Sher'Tul magics used are still experimental. Then scout out the area and begin to fortify the surroundings, but do so in secret. When your job is done well I, your humble leader Slasul, shall be honoured to join you on the front line. Until then, swim safely my brothers and sisters, and do not forget our glory."

]], [[#{italic}#Touching the conch makes it emit a sound. As you put it to your ear you hear a charismatic and commanding voice emanating from within:#{normal}#

"My fellow nagas! I do not envy you on your journey so far from our great Temple. But you have been chosen for a glorious mission, to establish a new outpost for invasion against the landwalkers. These are the cousins and descendants of those who abandoned us and left our race for dead. Whilst we have hidden beneath the waves for centuries, they prance about worshipping the sun! Well, their nightfall comes soon, and the dawn will rise with us as rulers of land and sea.

"Do not despair that we are attacking this outpost instead of the orcs. My stratagem is carefully planned, and the Sunwall is too great a threat to my designs to be allowed to stand any longer. The orcs... will have their uses in the short term. But be assured, when our time comes there shall be none who can stand as equals against us. Our greatness cannot be quelled or submerged! Our long history of suffering will finally bring forth redemption!

"Your immediate mission is clear, my friends. Ensure the farportal is correctly set up and secured, but take care, as the Sher'Tul magics used are still experimental. Then scout out the area and begin to fortify the surroundings, but do so in secret. When your job is done well I, your humble leader Slasul, shall be honoured to join you on the front line. Until then, swim safely my brothers and sisters, and do not forget our glory."

]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/spellblaze.lua"
-- 2 entries
t("draft letter (mark of the spellblaze)", "draft letter (mark of the spellblaze)", "_t")
t([[Dear Father,

How glad you must be to hear from your "renegade" son. Do not worry overmuch; I keep myself and my group well hidden from your petty Council. I know how you fret about your status amongst those fools.

I write to you to tell you that I have discovered something wonderful. In all my travels I could not have imagined a place so perfect as this. It is a remnant of the Great Spellblaze, a scar in the very fabric of Eyal. How beautiful it is! Ah, and what strength lies here too! You cannot possibly imagine, sitting idly in your little hall of stone.

You are wrong about the Spellblaze, of this I am certain. Seeing this has opened my eyes fully. The success of our ancestors cannot be denied! The power unleashed was tremendous, and still it lasts, 2646 years later. So much power still remains, untapped! You ramble on about the destruction it caused, but I cannot help but think you are exaggerating about the deaths. And were not the orcs also defeated? The grand purpose was achieved. Oh, you prattle about the plagues and blights, but I have seen how those dirty humans live, and those halflings in their grimy holes. Pestilence is rife amongst them. Besides, it seems clear to me that a little help from natural selection can only serve to improve the lesser races. Indeed, I have done some experiments which show just that. But alas, I think with your short vision you would only be disgusted by my advances.

My Rhaloren have come far in the world, and we have learned many things. Oft we have had to flee the terrible Ziguranth and their Death Wilders, but we have pulled through by force of will and grown stronger every day. Here our pilgrimage ends, for here is where we shall truly come into being. You should hear the voices here, screaming from the other side. You should hear their glorious cacophony! The Spellblaze is almost complete; it only needs our gentle push to bring everything to full fruition. The walls between worlds have been worn thin here, and with my strength we can break through to realms of power beyond belief. Such power I shall have! And with it I shall rend forces through this broken world that shall make the Spellblaze seem a happy memory. Eyal will be put to right, and our mighty place restored at the head of all other races! For the Rhaloren this shall truly be the Age of Ascendancy. For the lesser races, herewith comes their Age of Torment.

As I write to you our final plans are in motion. Sleep well when you read this, for it may well be your last night before the Great Torment begins.

With passionate detest,
Your disobedient son]], [[Dear Father,

How glad you must be to hear from your "renegade" son. Do not worry overmuch; I keep myself and my group well hidden from your petty Council. I know how you fret about your status amongst those fools.

I write to you to tell you that I have discovered something wonderful. In all my travels I could not have imagined a place so perfect as this. It is a remnant of the Great Spellblaze, a scar in the very fabric of Eyal. How beautiful it is! Ah, and what strength lies here too! You cannot possibly imagine, sitting idly in your little hall of stone.

You are wrong about the Spellblaze, of this I am certain. Seeing this has opened my eyes fully. The success of our ancestors cannot be denied! The power unleashed was tremendous, and still it lasts, 2646 years later. So much power still remains, untapped! You ramble on about the destruction it caused, but I cannot help but think you are exaggerating about the deaths. And were not the orcs also defeated? The grand purpose was achieved. Oh, you prattle about the plagues and blights, but I have seen how those dirty humans live, and those halflings in their grimy holes. Pestilence is rife amongst them. Besides, it seems clear to me that a little help from natural selection can only serve to improve the lesser races. Indeed, I have done some experiments which show just that. But alas, I think with your short vision you would only be disgusted by my advances.

My Rhaloren have come far in the world, and we have learned many things. Oft we have had to flee the terrible Ziguranth and their Death Wilders, but we have pulled through by force of will and grown stronger every day. Here our pilgrimage ends, for here is where we shall truly come into being. You should hear the voices here, screaming from the other side. You should hear their glorious cacophony! The Spellblaze is almost complete; it only needs our gentle push to bring everything to full fruition. The walls between worlds have been worn thin here, and with my strength we can break through to realms of power beyond belief. Such power I shall have! And with it I shall rend forces through this broken world that shall make the Spellblaze seem a happy memory. Eyal will be put to right, and our mighty place restored at the head of all other races! For the Rhaloren this shall truly be the Age of Ascendancy. For the lesser races, herewith comes their Age of Torment.

As I write to you our final plans are in motion. Sleep well when you read this, for it may well be your last night before the Great Torment begins.

With passionate detest,
Your disobedient son]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/spellhunt.lua"
-- 4 entries
t([[From an objective viewpoint, you would think the Spellhunt futile, but it was not so. You couldn't imagine the barbarism of the magehunting mobs; they would abuse and persecute any they saw as eccentric, many of whom had no connection to magic at all.
...
True mages would sometimes speak up in an act of altruism, just to stop the suffering of the innocent, but this only fuelled the horde's anger...
...
Other mages, those less forgiving and more given to action, would attack the roving mobs, but they soon learnt that against sufficient numbers magic is not omnipotent...
...
Ones I saw were set upon by dozens, their conjured flames and bolts of energy failing against the maddened crowds... they would often literally rip the mage limb from limb. It was horrific.
...
Angolwen, Linaniil calls it. I have known Linaniil for many years, and I know she has lost many loved ones to the Spellhunt, but she still holds true to her belief that one day we will be accepted once again. If this is the course of action she desires, I will follow her without question.]], [[From an objective viewpoint, you would think the Spellhunt futile, but it was not so. You couldn't imagine the barbarism of the magehunting mobs; they would abuse and persecute any they saw as eccentric, many of whom had no connection to magic at all.
...
True mages would sometimes speak up in an act of altruism, just to stop the suffering of the innocent, but this only fuelled the horde's anger...
...
Other mages, those less forgiving and more given to action, would attack the roving mobs, but they soon learnt that against sufficient numbers magic is not omnipotent...
...
Ones I saw were set upon by dozens, their conjured flames and bolts of energy failing against the maddened crowds... they would often literally rip the mage limb from limb. It was horrific.
...
Angolwen, Linaniil calls it. I have known Linaniil for many years, and I know she has lost many loved ones to the Spellhunt, but she still holds true to her belief that one day we will be accepted once again. If this is the course of action she desires, I will follow her without question.]], "_t")
t([[Those who partake in the profane sorcery can oft be marked by their appearance, their mannerisms, their personal keeping and their effect on the environment around them. Keep close watch on all you meet, for they are deceptive creatures that can take on many guises. Even women, children and cripples may be clever disguises of demon-communers and necromancers.

In their appearance you should be wary of the following:
* Particular grossness in complexion
* Unnatural or "elven" beauty
* Extreme thinness, with prominent bones
* Pointed or sharp-tipped ears - beware indeed of those with long hair or hats covering their ears
* Hunched backs and distorting limps
* Peculiar eye colour

In their behaviour you should be wary of the following:
* Tiredness during daylight hours and heavy activity at night
* Social aversion and fear of crowded places
* A questioning and probing attitude, in particular if challenging the precepts and set morals of society
* Quick-wittedness, especially where used for guile
* Furtiveness or a secretive attitude

In their effect on their environment you should be wary of the following:
* Causing grass to wilt and flowers to close as they pass
* Animals are alarmed by their presence, particularly dogs
* Crops wilt and cows' milk turns sour
* Arguments are stirred within their presence
* Women's moontide flow becomes more effluent
* Apparitions and unexplained events occur in their surroundings

Note that a spellweaver will doubtless deny any accusation against them, and will show great emotion when evidence is laid before them. But one should not delay in bringing swift judgement, lest they try to cast a hex or escape by arcane means.]], [[Those who partake in the profane sorcery can oft be marked by their appearance, their mannerisms, their personal keeping and their effect on the environment around them. Keep close watch on all you meet, for they are deceptive creatures that can take on many guises. Even women, children and cripples may be clever disguises of demon-communers and necromancers.

In their appearance you should be wary of the following:
* Particular grossness in complexion
* Unnatural or "elven" beauty
* Extreme thinness, with prominent bones
* Pointed or sharp-tipped ears - beware indeed of those with long hair or hats covering their ears
* Hunched backs and distorting limps
* Peculiar eye colour

In their behaviour you should be wary of the following:
* Tiredness during daylight hours and heavy activity at night
* Social aversion and fear of crowded places
* A questioning and probing attitude, in particular if challenging the precepts and set morals of society
* Quick-wittedness, especially where used for guile
* Furtiveness or a secretive attitude

In their effect on their environment you should be wary of the following:
* Causing grass to wilt and flowers to close as they pass
* Animals are alarmed by their presence, particularly dogs
* Crops wilt and cows' milk turns sour
* Arguments are stirred within their presence
* Women's moontide flow becomes more effluent
* Apparitions and unexplained events occur in their surroundings

Note that a spellweaver will doubtless deny any accusation against them, and will show great emotion when evidence is laid before them. But one should not delay in bringing swift judgement, lest they try to cast a hex or escape by arcane means.]], "_t")
t([[Those who rape the forces of nature with their malign wills doubtless unlock great powers to their advantage. We of noble cause, with our abilities aligned to nature's threads, can struggle to equal the terrible might of these unholy mages. But we must persist, for our cause is just, and the threat to this world from the terrors of the arcane evils cannot be under-stated. Too long has Eyal suffered the torture of their presence, and so we must fight with all the powers that nature can give us.

Mobility is key against spell-slinging warlocks and witches. One must rush with full speed towards them and hack them down, not giving them time to utter a spell of attack or defence. Against multiple opponents this could be difficult, and retreat to less open space is often vital. Do not consider this cowardice, for you play the weaker hand and must take all advantage you can acquire. Get into a tighter environment, and keep behind a concealed corner until they are right upon you, before unleashing all of your strength against them without warning.

Necromancers and fell conjurers can present a great threat when they summon their dark minions to overwhelm you. Oft it is best to take out the wizard first, though it presents risk. You must raise your will and suppress all pain until you come right upon him, and then strike him down quickly before retreating to a safer area. Stunning or dazing the caster before they have a chance to summon aid can also help immensely.

Hexes and curses can wreak terror upon you, and you would do well to have an infusion that removes these and other blighted magic effects when facing dread occultists. Infusions to augment your natural healing are also a must for difficult battles.

Remember to show no mercy, for they will give you none.]], [[Those who rape the forces of nature with their malign wills doubtless unlock great powers to their advantage. We of noble cause, with our abilities aligned to nature's threads, can struggle to equal the terrible might of these unholy mages. But we must persist, for our cause is just, and the threat to this world from the terrors of the arcane evils cannot be under-stated. Too long has Eyal suffered the torture of their presence, and so we must fight with all the powers that nature can give us.

Mobility is key against spell-slinging warlocks and witches. One must rush with full speed towards them and hack them down, not giving them time to utter a spell of attack or defence. Against multiple opponents this could be difficult, and retreat to less open space is often vital. Do not consider this cowardice, for you play the weaker hand and must take all advantage you can acquire. Get into a tighter environment, and keep behind a concealed corner until they are right upon you, before unleashing all of your strength against them without warning.

Necromancers and fell conjurers can present a great threat when they summon their dark minions to overwhelm you. Oft it is best to take out the wizard first, though it presents risk. You must raise your will and suppress all pain until you come right upon him, and then strike him down quickly before retreating to a safer area. Stunning or dazing the caster before they have a chance to summon aid can also help immensely.

Hexes and curses can wreak terror upon you, and you would do well to have an infusion that removes these and other blighted magic effects when facing dread occultists. Infusions to augment your natural healing are also a must for difficult battles.

Remember to show no mercy, for they will give you none.]], "_t")
t([[When a magic-user is captured, they must be slain, and slain fast. Captivity is too great a risk. Preferably they should be killed in a way that utterly removes any means for the body to recover through arcane force. Remember that coming back from the dead is no alien feat to these abominations.

Beheading is simple and effective, especially in a hurry, but ideally their other limbs should be removed too and sealed in separate metal cases wrapped in willow-bark.

Devouring by animals is sometimes used, but is not advised, as it can at the very least can cause severe diarrhoea in the animals, and at the worst can leave you facing a pack of fire-breathing hell hounds corrupted by the mana-wielder's aura.

Freezing is ineffective, and no magic-user can ever be frozen to death, in spite of what rumours you may have heard. Anyone you have heard of that was frozen to death was either not a mage or was pretending.

Burning is popular amongst the less educated towns, but typically no witch or wizard of power would ever allow themselves to be caught, bound and put to stake without finding means of escape. Simply putting together the necessary firewood takes too long, even if stocked in advance. Usually those executed in this manner are magic-sympathisers rather than true magic users. Whilst strictly speaking this does not carry the penalty of death it does well to set an example for others and to warn arcane users to stay well away from the community.

The best method, if time and situation allows, is to very slowly slice the caster to death. One should have them securely bound in a sealed room, with willow-bark or beech-wood around their wrists and cranium. One should start by slowly slicing off the toes, fingers and other extremities, before slicing through all the limbs and finally the torso. Do not cut open the skull, in case resident demons escape. The head should be put into a metal box and incinerated for 24 hours with the rest of the remains. Extremely sharp instruments are needed for the job, and do not be surprised if they need re-sharpening several times during the process, as it is a typical warlock's trick to harden their bones before the procedure as a final act of spite.

]], [[When a magic-user is captured, they must be slain, and slain fast. Captivity is too great a risk. Preferably they should be killed in a way that utterly removes any means for the body to recover through arcane force. Remember that coming back from the dead is no alien feat to these abominations.

Beheading is simple and effective, especially in a hurry, but ideally their other limbs should be removed too and sealed in separate metal cases wrapped in willow-bark.

Devouring by animals is sometimes used, but is not advised, as it can at the very least can cause severe diarrhoea in the animals, and at the worst can leave you facing a pack of fire-breathing hell hounds corrupted by the mana-wielder's aura.

Freezing is ineffective, and no magic-user can ever be frozen to death, in spite of what rumours you may have heard. Anyone you have heard of that was frozen to death was either not a mage or was pretending.

Burning is popular amongst the less educated towns, but typically no witch or wizard of power would ever allow themselves to be caught, bound and put to stake without finding means of escape. Simply putting together the necessary firewood takes too long, even if stocked in advance. Usually those executed in this manner are magic-sympathisers rather than true magic users. Whilst strictly speaking this does not carry the penalty of death it does well to set an example for others and to warn arcane users to stay well away from the community.

The best method, if time and situation allows, is to very slowly slice the caster to death. One should have them securely bound in a sealed room, with willow-bark or beech-wood around their wrists and cranium. One should start by slowly slicing off the toes, fingers and other extremities, before slicing through all the limbs and finally the torso. Do not cut open the skull, in case resident demons escape. The head should be put into a metal box and incinerated for 24 hours with the rest of the remains. Extremely sharp instruments are needed for the job, and do not be surprised if they need re-sharpening several times during the process, as it is a typical warlock's trick to harden their bones before the procedure as a final act of spite.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/sunwall.lua"
-- 5 entries
t([[Loremaster Verutir here. I have been assigned to write an official chronicle of the history of the Sunwall. This will be my notebook as I interview people and travel from place to place. If you are reading this, you are either my patron (thanks again, sir!), a sneak (get out of my journal!), or the finder of my corpse. If the last, please take this to Lord Forosyth of the town of the Sunwall for a reward, tell my wife how I died, and tell the kids that I love them.
With that said I shall be starting this project by investigating the Elves and their connection to the Sunwall. They should be one of the easier races to interview considering their life expectancy and their penchant for remembering their own history. Of course, there aren't as many of them around as there used to be.
...
Unfortunately though, our local Elves are also unwilling to talk to me about their history, saying they do not have records of the earlier times. However, there is a fellow Thanchir who I hear would be happy to help. The only problem is that he lies on the other side of a huge encampment of orcs, so I will need an escort to help me. We will see how that goes. I have heard things about those adventurer escorts ...]], [[Loremaster Verutir here. I have been assigned to write an official chronicle of the history of the Sunwall. This will be my notebook as I interview people and travel from place to place. If you are reading this, you are either my patron (thanks again, sir!), a sneak (get out of my journal!), or the finder of my corpse. If the last, please take this to Lord Forosyth of the town of the Sunwall for a reward, tell my wife how I died, and tell the kids that I love them.
With that said I shall be starting this project by investigating the Elves and their connection to the Sunwall. They should be one of the easier races to interview considering their life expectancy and their penchant for remembering their own history. Of course, there aren't as many of them around as there used to be.
...
Unfortunately though, our local Elves are also unwilling to talk to me about their history, saying they do not have records of the earlier times. However, there is a fellow Thanchir who I hear would be happy to help. The only problem is that he lies on the other side of a huge encampment of orcs, so I will need an escort to help me. We will see how that goes. I have heard things about those adventurer escorts ...]], "_t")
t([[And boy were all the rumors about unreliable adventurers true. I'd heard that many, many escorted people die when their adventurer flees and protects himself. It is TRUE. Once I got an escort, I headed off in the right direction immediately. However, for some reason, he did not immediately follow, let alone lead. Didn't he know the way to go? Foolish man. Why am I offering my special trainings to someone who doesn't even know where the local portals are! Fortunately I survived, but no thanks to him. I won't even mention his snoring...
This Thanchir guy really, really needs to find a more urban spot with accessible public transportation (no adventurers please!). However, once I could get him to talk, he did know quite a bit. Apparently, he claims some distant kinship to the first Elf in these parts. They arrived by boat from some legendary land called "Maj'Eyal". He says that it definitely exists, but could provide no real evidence. This should be investigated further]], [[And boy were all the rumors about unreliable adventurers true. I'd heard that many, many escorted people die when their adventurer flees and protects himself. It is TRUE. Once I got an escort, I headed off in the right direction immediately. However, for some reason, he did not immediately follow, let alone lead. Didn't he know the way to go? Foolish man. Why am I offering my special trainings to someone who doesn't even know where the local portals are! Fortunately I survived, but no thanks to him. I won't even mention his snoring...
This Thanchir guy really, really needs to find a more urban spot with accessible public transportation (no adventurers please!). However, once I could get him to talk, he did know quite a bit. Apparently, he claims some distant kinship to the first Elf in these parts. They arrived by boat from some legendary land called "Maj'Eyal". He says that it definitely exists, but could provide no real evidence. This should be investigated further]], "_t")
t([[However, I have been repeatedly told by the powers that be, that I need to get on with this and turn in another report on how a different race got here. So, I will temporarily pause my researches on whether or not Maj'Eyal is real or just an Elf legend. (Can't trust everything they say despite their long memories.) Instead, I am on to meet the keeper of the Eastern Historical Society who has the best collection of lore about how Humans got here. As such, I will be travelling to northern Vor to use their archives.
And yes, unfortunately I will be travelling by adventurer again. By all the gods, why don't I get a better budget? This is absolutely terrible. It has been a particularly long walk. Longer than I thought it would be, truthfully, so I have run out of food. Foolish, I know, but I figured I could ask the escort for some of his. The snobby piece of troll-liver says he doesn't eat! Now talk about a terrible lie. Did he really think that would fool me? This Eastern Historical Society had better be good...]], [[However, I have been repeatedly told by the powers that be, that I need to get on with this and turn in another report on how a different race got here. So, I will temporarily pause my researches on whether or not Maj'Eyal is real or just an Elf legend. (Can't trust everything they say despite their long memories.) Instead, I am on to meet the keeper of the Eastern Historical Society who has the best collection of lore about how Humans got here. As such, I will be travelling to northern Vor to use their archives.
And yes, unfortunately I will be travelling by adventurer again. By all the gods, why don't I get a better budget? This is absolutely terrible. It has been a particularly long walk. Longer than I thought it would be, truthfully, so I have run out of food. Foolish, I know, but I figured I could ask the escort for some of his. The snobby piece of troll-liver says he doesn't eat! Now talk about a terrible lie. Did he really think that would fool me? This Eastern Historical Society had better be good...]], "_t")
t("history of the Sunwall", "history of the Sunwall", "newLore category")
t([[Finally arrived in Vor safe and mostly sound. (Though I do have some burns on my stomach from mage fire and my coat is a complete wreck. I wonder if I can expense a new coat.) However, the Eastern Historical Society is everything I could have hoped. Who can doubt that Humans are the superior race! You'd never see an Elf or an orc keep neat paper records like this!
In short: Aethidry was the first Human to map out these shores. EHS has his map preserved in good crackly yellow parchment. However, he travelled on and later died on distant shores, so he was neither the first Human to arrive here, nor the one who organized the first settlement. Some historians guess that the first Human to arrive in the east was one Vaeryn Gorthol. At the least, many of the first explorers mention him as a precursor, so he may well have been. A few of the important first settlers were Oweodry Arandur, Aethor (or perhaps Aethur) the Wronged, and Bloran the Black.]], [[Finally arrived in Vor safe and mostly sound. (Though I do have some burns on my stomach from mage fire and my coat is a complete wreck. I wonder if I can expense a new coat.) However, the Eastern Historical Society is everything I could have hoped. Who can doubt that Humans are the superior race! You'd never see an Elf or an orc keep neat paper records like this!
In short: Aethidry was the first Human to map out these shores. EHS has his map preserved in good crackly yellow parchment. However, he travelled on and later died on distant shores, so he was neither the first Human to arrive here, nor the one who organized the first settlement. Some historians guess that the first Human to arrive in the east was one Vaeryn Gorthol. At the least, many of the first explorers mention him as a precursor, so he may well have been. A few of the important first settlers were Oweodry Arandur, Aethor (or perhaps Aethur) the Wronged, and Bloran the Black.]], "_t")


------------------------------------------------
section "game/modules/tome/data/lore/tannen.lua"
-- 9 entries
t("Welcome to your cell", "Welcome to your cell", "_t")
t([[A Note to the Adventurer:

I am truly sorry about this; had circumstances been different, we could've been allies, my weapons and magic letting you fight the hordes of threats to Maj'Eyal.  As it stands, however, your continued existence is highly inconvenient to me.

See, my funding comes from the merchants of Last Hope, who want a functioning portal and will stop paying once they have one; furthermore, my portal research has proved to be a very useful cover story for the other experiments I'm conducting here.  Now that you've gotten a portal working, and will want to use it in full view of the city, I'm out of a job - and there is so much more knowledge for me to find!  The medical applications of necromancy, for one - the only other source of data on this subject went missing shortly after her husband's death, and everyone else has a Ziguranth-like fervor against the idea of using that magic baseline in any way whatsoever.  Also, selective drake breeding programs, experiments on zealots to shatter their anti-magic barriers, studying demons to learn more about their altered biologies and steal that magic for our own militaries...  I could go on, but I'd rather not waste enchanted ink.  The point is, you using the portal without further injury would mean an end to my experiments.  Ideally, you need to disappear, but if you were to emerge from my basement, wounded and raving with wild eyes about impossible beasts in the basement of my humble tower...  well, that'd just further my case that portals need more research to be used safely, wouldn't it?

#{italic}#As you move on to the next paragraph, you notice that everything above it has faded away, and the scroll is beginning to grow warm in your hands.#{normal}#

Worry not, though - you can still help the world, by devoting yourself to my quest for knowledge!  My sources have told me that you've grown exponentially more powerful since you first started making a name for yourself, and you continue to cause prodigious amounts of destruction.  The modified portal I used on you had about a 33% chance of draining some of the power you've accumulated; if you're feeling exhausted, simply lay down and wait for my imp servants to collect you for further testing.  If you aren't, however: I've sealed the way up, and placed the switches in each of the subject holding pens on this floor.  You can fight your way through them, and I'll be watching to see how a creature of your power fares against different types of foes.  I'm sure you'll want to get to the top floor and kill me in revenge, and I encourage you to try!  You may die, but the data you provide will be immortal - and if I can have my drolem subdue you non-lethally, I'll send you back to the bottom and repeat the experiment with tweaked parameters.  We can keep repeating this until I find your breaking point, or figure out what makes you so special, at which point you'll be held until I can work on a reliable method of controlling your mind.  And on the off chance that you do actually manage to kill me...  try not to do too much damage to my notes, please?  Knowledge and progress are bigger matters than either of us; don't let your spite doom thousands of lives that could rely on my research in the future.

Oh, and I can't risk this note getting into anyone else's hands, can I?  It's going to catch fire a few seconds after you're done reading.  Please drop it before it does - you having burnt hands isn't part of the experiment.

#{italic}#You throw the paper away.  After about fifteen seconds, it fizzles, then bursts into flame, not even leaving ashes behind.#{normal}#]], [[A Note to the Adventurer:

I am truly sorry about this; had circumstances been different, we could've been allies, my weapons and magic letting you fight the hordes of threats to Maj'Eyal.  As it stands, however, your continued existence is highly inconvenient to me.

See, my funding comes from the merchants of Last Hope, who want a functioning portal and will stop paying once they have one; furthermore, my portal research has proved to be a very useful cover story for the other experiments I'm conducting here.  Now that you've gotten a portal working, and will want to use it in full view of the city, I'm out of a job - and there is so much more knowledge for me to find!  The medical applications of necromancy, for one - the only other source of data on this subject went missing shortly after her husband's death, and everyone else has a Ziguranth-like fervor against the idea of using that magic baseline in any way whatsoever.  Also, selective drake breeding programs, experiments on zealots to shatter their anti-magic barriers, studying demons to learn more about their altered biologies and steal that magic for our own militaries...  I could go on, but I'd rather not waste enchanted ink.  The point is, you using the portal without further injury would mean an end to my experiments.  Ideally, you need to disappear, but if you were to emerge from my basement, wounded and raving with wild eyes about impossible beasts in the basement of my humble tower...  well, that'd just further my case that portals need more research to be used safely, wouldn't it?

#{italic}#As you move on to the next paragraph, you notice that everything above it has faded away, and the scroll is beginning to grow warm in your hands.#{normal}#

Worry not, though - you can still help the world, by devoting yourself to my quest for knowledge!  My sources have told me that you've grown exponentially more powerful since you first started making a name for yourself, and you continue to cause prodigious amounts of destruction.  The modified portal I used on you had about a 33% chance of draining some of the power you've accumulated; if you're feeling exhausted, simply lay down and wait for my imp servants to collect you for further testing.  If you aren't, however: I've sealed the way up, and placed the switches in each of the subject holding pens on this floor.  You can fight your way through them, and I'll be watching to see how a creature of your power fares against different types of foes.  I'm sure you'll want to get to the top floor and kill me in revenge, and I encourage you to try!  You may die, but the data you provide will be immortal - and if I can have my drolem subdue you non-lethally, I'll send you back to the bottom and repeat the experiment with tweaked parameters.  We can keep repeating this until I find your breaking point, or figure out what makes you so special, at which point you'll be held until I can work on a reliable method of controlling your mind.  And on the off chance that you do actually manage to kill me...  try not to do too much damage to my notes, please?  Knowledge and progress are bigger matters than either of us; don't let your spite doom thousands of lives that could rely on my research in the future.

Oh, and I can't risk this note getting into anyone else's hands, can I?  It's going to catch fire a few seconds after you're done reading.  Please drop it before it does - you having burnt hands isn't part of the experiment.

#{italic}#You throw the paper away.  After about fifteen seconds, it fizzles, then bursts into flame, not even leaving ashes behind.#{normal}#]], "_t")
t("Personal note (1)", "Personal note (1)", "_t")
t([[Angolwen is too timid.  Too paranoid about repeating the mistakes of the past.  Too cautious and infuriatingly non-pragmatic.  Too prone to avoiding the "little sins," ignoring the big picture.  I've told them again and again that our ancestors' mistake wasn't trying to use the Sher'Tul portals, it was trying to weaponize them before we understood how they worked - couldn't we have plundered the Nargol facility for more data, or started kidnapping orc scouting parties as experimental subjects?  Couldn't we have tried to learn more about the Sher'Tul _before_ desperation pushed us into blowing up half of the world?  No, that was "forbidden" magic, "too powerful for mortals to tamper with," right up until we realized we needed all that power after all.  Like a pacifist finally picking up a flail to defend himself, only to bash himself in the head with it, our lack of familiarity led to catastrophe.

My arguments have just gotten me blank stares and an increasing amount of whispering behind my back (aside from a young couple whose abrupt departure might've been inspired by a particularly passionate rant in response to a lecture on "ethics").  Some of them have even resorted to deflecting my arguments, blaming them on my lack of magical power and saying I've spent too much time working on my drolem!  They think they can inspire the world and protect it from danger without getting their hands dirty; the orc invasions proved that, no, they can't, and I fear that if the demons ever start arriving in full force, we'll be even more woefully unprepared for it.  We even cower from the Ziguranth, no matter how many people die from diseases our healers could cure if they could roam freely, and no matter how easily we could find a way around their defenses if we started capturing a few of their agents.

Well, I won't have it.  I've been selling potions and inscriptions on the side for a couple of years now, in spite of Angolwen's regulations, and managed to amass enough money to set up a laboratory far away from Angolwen.  There, I intend to do the experiments my cowardly, squeamish peers won't.  I'm sure they won't approve, but I'm beyond caring - there are certain things we need to know before it's too late, and if a few zealots or criminals die in the process, it won't matter when my data saves countless lives in the long run.  Construction begins tomorrow - I've got three separate sets of contractors lined up to work on it, so none know the tower's full layout, and I've made arrangements with powerful merchants in Last Hope so I can conduct some of my experiments publicly (they want working portals for trade, and I convinced them I won't cause another Spellblaze trying to make one), providing a convenient cover story for the more...  controversial experiments.  I can have my drolem carry in sensitive equipment so I don't have to answer any problematic questions.  I will NOT escape one band of stuck-up fools just to have another confiscate bone-giants which I spent a fortune on.
]], [[Angolwen is too timid.  Too paranoid about repeating the mistakes of the past.  Too cautious and infuriatingly non-pragmatic.  Too prone to avoiding the "little sins," ignoring the big picture.  I've told them again and again that our ancestors' mistake wasn't trying to use the Sher'Tul portals, it was trying to weaponize them before we understood how they worked - couldn't we have plundered the Nargol facility for more data, or started kidnapping orc scouting parties as experimental subjects?  Couldn't we have tried to learn more about the Sher'Tul _before_ desperation pushed us into blowing up half of the world?  No, that was "forbidden" magic, "too powerful for mortals to tamper with," right up until we realized we needed all that power after all.  Like a pacifist finally picking up a flail to defend himself, only to bash himself in the head with it, our lack of familiarity led to catastrophe.

My arguments have just gotten me blank stares and an increasing amount of whispering behind my back (aside from a young couple whose abrupt departure might've been inspired by a particularly passionate rant in response to a lecture on "ethics").  Some of them have even resorted to deflecting my arguments, blaming them on my lack of magical power and saying I've spent too much time working on my drolem!  They think they can inspire the world and protect it from danger without getting their hands dirty; the orc invasions proved that, no, they can't, and I fear that if the demons ever start arriving in full force, we'll be even more woefully unprepared for it.  We even cower from the Ziguranth, no matter how many people die from diseases our healers could cure if they could roam freely, and no matter how easily we could find a way around their defenses if we started capturing a few of their agents.

Well, I won't have it.  I've been selling potions and inscriptions on the side for a couple of years now, in spite of Angolwen's regulations, and managed to amass enough money to set up a laboratory far away from Angolwen.  There, I intend to do the experiments my cowardly, squeamish peers won't.  I'm sure they won't approve, but I'm beyond caring - there are certain things we need to know before it's too late, and if a few zealots or criminals die in the process, it won't matter when my data saves countless lives in the long run.  Construction begins tomorrow - I've got three separate sets of contractors lined up to work on it, so none know the tower's full layout, and I've made arrangements with powerful merchants in Last Hope so I can conduct some of my experiments publicly (they want working portals for trade, and I convinced them I won't cause another Spellblaze trying to make one), providing a convenient cover story for the more...  controversial experiments.  I can have my drolem carry in sensitive equipment so I don't have to answer any problematic questions.  I will NOT escape one band of stuck-up fools just to have another confiscate bone-giants which I spent a fortune on.
]], "_t")
t("Personal note (2)", "Personal note (2)", "_t")
t([[Well...  that was interesting.

Setting up a portal took surprisingly little effort - conjured replicas of a Blood-Runed Athame and a Resonating Diamond work perfectly for setting up a portal, as it turns out, even if it burns them out after making just one.  This solution wouldn't work for the Orb of Many Ways, given that if it shorts out after one use, that means you're trapped on the other side of the portal, so I started working on a more tangible replica.  I noticed that most of them were disrupted by some form of interference, maybe echoes from the Spellblaze; my latest attempt at a more permanent orb was more of a curiosity than anything, an attempt to use those waves as constructive interference to lock onto their source.  I tossed a bandit through (my drolem's flight and relative silence have proven to be very convenient for securing test subjects!) with it tied to him, expecting him to pop into some magical maelstrom, quickly teleport back, and promptly die of terrible burn wounds (like the last four).

I didn't get a bandit back.  I got an imp.

My drolem grabbed it with its jaws, as usual, but I told it to back off on seeing the imp wasn't armed and wasn't even trying to cast any spells.  I apologized, treated its wounds, then asked it to explain what happened to my test subject.  Apparently, the demons have been running their own portal experiments!  The test subject was unharmed when he popped up in their laboratory; after the demons "questioned" him (boiling tar was involved), they realized that another inquisitive mind was on the other side, and hoped to communicate and possibly trade data with that person.  I've managed to make more progress than the demons have - either I'm a genius, or I've severely overestimated the threat the demons pose!

I've "officially" agreed to their deal - they'll supply me with materials, subjects, and what little progress they've made, and in return I've developed a modified orb that'll give them readings when it's used in a portal.  Needless to say, the readings are all bogus, and if they actually try to use those readings to make a second portal of their own, it'll blow them to bits.  The data they've given me has been VERY useful!  I've used it to construct a second altar from scratch - it still has some links to the demonic realm, but a single teleport with a genuine Orb of Many Ways will recalibrate it and cut those off completely, letting me get away scot-free with my knowledge and treasures, and preventing the demons from reaching me again.

Now, I just need to get a genuine orb before the demons catch on...]], [[Well...  that was interesting.

Setting up a portal took surprisingly little effort - conjured replicas of a Blood-Runed Athame and a Resonating Diamond work perfectly for setting up a portal, as it turns out, even if it burns them out after making just one.  This solution wouldn't work for the Orb of Many Ways, given that if it shorts out after one use, that means you're trapped on the other side of the portal, so I started working on a more tangible replica.  I noticed that most of them were disrupted by some form of interference, maybe echoes from the Spellblaze; my latest attempt at a more permanent orb was more of a curiosity than anything, an attempt to use those waves as constructive interference to lock onto their source.  I tossed a bandit through (my drolem's flight and relative silence have proven to be very convenient for securing test subjects!) with it tied to him, expecting him to pop into some magical maelstrom, quickly teleport back, and promptly die of terrible burn wounds (like the last four).

I didn't get a bandit back.  I got an imp.

My drolem grabbed it with its jaws, as usual, but I told it to back off on seeing the imp wasn't armed and wasn't even trying to cast any spells.  I apologized, treated its wounds, then asked it to explain what happened to my test subject.  Apparently, the demons have been running their own portal experiments!  The test subject was unharmed when he popped up in their laboratory; after the demons "questioned" him (boiling tar was involved), they realized that another inquisitive mind was on the other side, and hoped to communicate and possibly trade data with that person.  I've managed to make more progress than the demons have - either I'm a genius, or I've severely overestimated the threat the demons pose!

I've "officially" agreed to their deal - they'll supply me with materials, subjects, and what little progress they've made, and in return I've developed a modified orb that'll give them readings when it's used in a portal.  Needless to say, the readings are all bogus, and if they actually try to use those readings to make a second portal of their own, it'll blow them to bits.  The data they've given me has been VERY useful!  I've used it to construct a second altar from scratch - it still has some links to the demonic realm, but a single teleport with a genuine Orb of Many Ways will recalibrate it and cut those off completely, letting me get away scot-free with my knowledge and treasures, and preventing the demons from reaching me again.

Now, I just need to get a genuine orb before the demons catch on...]], "_t")
t("tannen's tower", "tannen's tower", "newLore category")
t("Demon Orders", "Demon Orders", "_t")
t([[Order to the Portal Excursion Team:

This egotistical human has proven to be very valuable.  We gave him only a very limited amount of data, and yet he still thinks he has the upper hand, thinking he could trick us by giving us faulty information.  No matter - the plans we gave him for a portal altar are feeding their measurements straight to us every time he uses them.  Every time he runs an experiment, we get much closer to devising a way to penetrate Eyal's shield; even the data we already have is enough to take us through one at a time, with the prohibitive limitation of creating a new Orb of Many Ways for each prospective invader.

Your orders are to play along.  Keep giving him what he says he wants - more components, more captured Eyalites, more assistants.  Above all, let him think he's got the upper hand - feign ineptitude, and never let on that we know the data he's giving us is false.  Compared to what we're getting in return, it's a bargain.]], [[Order to the Portal Excursion Team:

This egotistical human has proven to be very valuable.  We gave him only a very limited amount of data, and yet he still thinks he has the upper hand, thinking he could trick us by giving us faulty information.  No matter - the plans we gave him for a portal altar are feeding their measurements straight to us every time he uses them.  Every time he runs an experiment, we get much closer to devising a way to penetrate Eyal's shield; even the data we already have is enough to take us through one at a time, with the prohibitive limitation of creating a new Orb of Many Ways for each prospective invader.

Your orders are to play along.  Keep giving him what he says he wants - more components, more captured Eyalites, more assistants.  Above all, let him think he's got the upper hand - feign ineptitude, and never let on that we know the data he's giving us is false.  Compared to what we're getting in return, it's a bargain.]], "_t")


------------------------------------------------
section "game/modules/tome/data/quests/arena.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/charred-scar.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/east-portal.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/escort-duty.lua"
-- 2 entries
t("", "", "_t")
t("???", "???", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/high-peak.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/orc-breeding-pits.lua"
-- 7 entries
t("Desperate Measures", "Desperate Measures", "_t")
t("You have encountered a dying sun paladin that told you about the orcs breeding pit, a true abomination.", "You have encountered a dying sun paladin that told you about the orcs breeding pit, a true abomination.", "_t")
t("You have decided to report the information to Aeryn so she can deal with it.", "You have decided to report the information to Aeryn so she can deal with it.", "_t")
t("Aeryn said she would send troops to deal with it.", "Aeryn said she would send troops to deal with it.", "_t")
t("You have taken upon yourself to cleanse it and deal a crippling blow to the orcs.", "You have taken upon yourself to cleanse it and deal a crippling blow to the orcs.", "_t")
t("The abominable task is done.", "The abominable task is done.", "_t")
t("Entrance to the orc breeding pit", "Entrance to the orc breeding pit", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/orc-pride.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/ring-of-blood.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/tutorial-combat-stats.lua"
-- 4 entries
t("Tutorial: combat stats", "Tutorial: combat stats", "_t")
t("Explore the Dungeon of Adventurer Enlightenment to learn about ToME's combat mechanics.", "Explore the Dungeon of Adventurer Enlightenment to learn about ToME's combat mechanics.", "_t")
t("#LIGHT_GREEN#You have navigated the Dungeon of Adventurer Enlightenment!#WHITE#", "#LIGHT_GREEN#You have navigated the Dungeon of Adventurer Enlightenment!#WHITE#", "_t")
t("Tutorial Finished", "Tutorial Finished", "_t")


------------------------------------------------
section "game/modules/tome/data/quests/west-portal.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/resources.lua"
-- 1 entries
t("%d/%d (%d%%%%)", "%d/%d (%d%%%%)", "tformat")


------------------------------------------------
section "game/modules/tome/data/rooms/greater_vault.lua"
-- 1 entries
t("#GOLD#PLACED GREATER VAULT: %s", "#GOLD#PLACED GREATER VAULT: %s", "log")


------------------------------------------------
section "game/modules/tome/data/rooms/lesser_vault.lua"
-- 1 entries
t("#GOLD#PLACED LESSER VAULT: %s", "#GOLD#PLACED LESSER VAULT: %s", "log")


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/induced-phenomena.lua"
-- 11 entries
t("Cosmic Cycle", "Cosmic Cycle", "talent name")
t("#LIGHT_BLUE#Your cosmic cycle expands.", "#LIGHT_BLUE#Your cosmic cycle expands.", "logPlayer")
t("#LIGHT_RED#Your cosmic cycle contracts.", "#LIGHT_RED#Your cosmic cycle contracts.", "logPlayer")
t([[Tune yourself into the ebb and flow of spacetime.  When your Paradox crosses a 100 point threshold, your Cosmic Cycle gains or loses one radius.
		While Cosmic Cycle is expanding, your temporal resistance penetration will be increased by %d%%.  While it's contracting, your Willpower for Paradox calculations will be increased by %d%%.]], [[Tune yourself into the ebb and flow of spacetime.  When your Paradox crosses a 100 point threshold, your Cosmic Cycle gains or loses one radius.
		While Cosmic Cycle is expanding, your temporal resistance penetration will be increased by %d%%.  While it's contracting, your Willpower for Paradox calculations will be increased by %d%%.]], "tformat")
t("Polarity Shift", "Polarity Shift", "talent name")
t("You must have Cosmic Cycle active to use this talent.", "You must have Cosmic Cycle active to use this talent.", "logPlayer")
t("Polarity Bolt", "Polarity Bolt", "_t")
t([[Reverses the polarity of your Cosmic Cycle.  If it's currently contracting, it will begin to expand, firing a homing missile at each target within the radius that deals %0.2f temporal damage.
		If it's currently expanding, it will begin to contract, braiding the lifelines of all targets within the radius for %d turns.  Braided targets take %d%% of all damage dealt to other braided targets.
		The damage will scale with your Spellpower.]], [[Reverses the polarity of your Cosmic Cycle.  If it's currently contracting, it will begin to expand, firing a homing missile at each target within the radius that deals %0.2f temporal damage.
		If it's currently expanding, it will begin to contract, braiding the lifelines of all targets within the radius for %d turns.  Braided targets take %d%% of all damage dealt to other braided targets.
		The damage will scale with your Spellpower.]], "tformat")
t("Reverse Causality", "Reverse Causality", "talent name")
t([[When a creature enters your expanding Cosmic Cycle, you heal %d life at the start of your next turn.
		When a creature leaves your contracting Cosmic Cycle, you reduce the duration of one detrimental effect on you by %d at the start of your next turn.
		The healing will scale with your Spellpower.]], [[When a creature enters your expanding Cosmic Cycle, you heal %d life at the start of your next turn.
		When a creature leaves your contracting Cosmic Cycle, you reduce the duration of one detrimental effect on you by %d at the start of your next turn.
		The healing will scale with your Spellpower.]], "tformat")
t([[While your cosmic cycle is expanding, creatures in its radius have a %d%% chance to suffer the effects of aging; pinning, blinding, or confusing them for 3 turns.
		While your cosmic cycle is contracting, creatures in its radius suffer from age regression; reducing their three highest stats by %d.
		The chance and stat reduction will scale with your Spellpower.]], [[While your cosmic cycle is expanding, creatures in its radius have a %d%% chance to suffer the effects of aging; pinning, blinding, or confusing them for 3 turns.
		While your cosmic cycle is contracting, creatures in its radius suffer from age regression; reducing their three highest stats by %d.
		The chance and stat reduction will scale with your Spellpower.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/other.lua"
-- 33 entries
t([[Creates a time distortion in a radius of %d that lasts for %d turns, decreasing global speed by %d%% for 3 turns and inflicting %0.2f temporal damage each turn to all targets within the area.
		The slow effect and damage dealt will scale with your Spellpower.]], [[Creates a time distortion in a radius of %d that lasts for %d turns, decreasing global speed by %d%% for 3 turns and inflicting %0.2f temporal damage each turn to all targets within the area.
		The slow effect and damage dealt will scale with your Spellpower.]], "tformat")
t("Spacetime Mastery", "Spacetime Mastery", "talent name")
t("Your mastery of spacetime reduces the cooldown of Banish, Dimensional Step, Swap, and Temporal Wake by %d, and the cooldown of Wormhole by %d.  Also improves your Spellpower for purposes of hitting targets with chronomancy effects that may cause continuum destabilization (Banish, Time Skip, etc.), as well as your chance of overcoming continuum destabilization, by %d%%.", "Your mastery of spacetime reduces the cooldown of Banish, Dimensional Step, Swap, and Temporal Wake by %d, and the cooldown of Wormhole by %d.  Also improves your Spellpower for purposes of hitting targets with chronomancy effects that may cause continuum destabilization (Banish, Time Skip, etc.), as well as your chance of overcoming continuum destabilization, by %d%%.", "tformat")
t("Quantum Feed", "Quantum Feed", "talent name")
t([[You've learned to boost your magic through your control over the spacetime continuum.  Increases your Magic and your Spell Save by %d.
		The effect will scale with your Willpower.]], [[You've learned to boost your magic through your control over the spacetime continuum.  Increases your Magic and your Spell Save by %d.
		The effect will scale with your Willpower.]], "tformat")
t("Moment of Prescience", "Moment of Prescience", "talent name")
t([[You pull your awareness fully into the moment, increasing your stealth detection, see invisibility, defense, and accuracy by %d for %d turns.
		If you have Spin Fate active when you cast this spell, you'll gain a bonus to these values equal to 50%% of your spin.
		This spell takes no time to cast.]], [[You pull your awareness fully into the moment, increasing your stealth detection, see invisibility, defense, and accuracy by %d for %d turns.
		If you have Spin Fate active when you cast this spell, you'll gain a bonus to these values equal to 50%% of your spin.
		This spell takes no time to cast.]], "tformat")
t([[You begin to gather energy from other timelines. Your Spellpower will increase by %0.2f on the first turn and %0.2f more each additional turn.
		The effect ends either when you cast a spell, or after five turns.
		Eacn turn the effect is active, your Paradox will be reduced by %d.
		This spell will not break Spacetime Tuning, nor will it be broken by activating Spacetime Tuning.]], [[You begin to gather energy from other timelines. Your Spellpower will increase by %0.2f on the first turn and %0.2f more each additional turn.
		The effect ends either when you cast a spell, or after five turns.
		Eacn turn the effect is active, your Paradox will be reduced by %d.
		This spell will not break Spacetime Tuning, nor will it be broken by activating Spacetime Tuning.]], "tformat")
t("Entropic Field", "Entropic Field", "talent name")
t([[You encase yourself in a field that slows incoming projectiles by %d%%, and increases your physical resistance by %d%%.
		The effect will scale with your Spellpower.]], [[You encase yourself in a field that slows incoming projectiles by %d%%, and increases your physical resistance by %d%%.
		The effect will scale with your Spellpower.]], "tformat")
t([[You partially remove yourself from the timeline for 10 turns.
		This increases your resistance to all damage by %d%%, reduces the duration of all detrimental effects on you by %d%%, and reduces all damage you deal by 20%%.
		The resistance bonus, effect reduction, and damage penalty will gradually lose power over the duration of the spell.
		The effects scale with your Spellpower.]], [[You partially remove yourself from the timeline for 10 turns.
		This increases your resistance to all damage by %d%%, reduces the duration of all detrimental effects on you by %d%%, and reduces all damage you deal by 20%%.
		The resistance bonus, effect reduction, and damage penalty will gradually lose power over the duration of the spell.
		The effects scale with your Spellpower.]], "tformat")
t("%s's Paradox Clone", "%s's Paradox Clone", "tformat")
t([[You summon your future self to fight alongside you for %d turns.  At some point in the future, you'll be pulled into the past to fight alongside your past self after the initial effect ends.
		This spell splits the timeline.  Attempting to use another spell that also splits the timeline while this effect is active will be unsuccessful.]], [[You summon your future self to fight alongside you for %d turns.  At some point in the future, you'll be pulled into the past to fight alongside your past self after the initial effect ends.
		This spell splits the timeline.  Attempting to use another spell that also splits the timeline while this effect is active will be unsuccessful.]], "tformat")
t("Displace Damage", "Displace Damage", "talent name")
t("#PINK##Source# displaces some damage onto #Target#!", "#PINK##Source# displaces some damage onto #Target#!", "delayedLogMessage")
t([[You bend space around you, displacing %d%% of any damage you receive onto a random enemy within range.
		]], [[You bend space around you, displacing %d%% of any damage you receive onto a random enemy within range.
		]], "tformat")
t("Repulsion Field", "Repulsion Field", "talent name")
t([[You surround yourself with a radius %d distortion of gravity, knocking back and dealing %0.2f physical damage to all creatures inside it.  The effect lasts %d turns.  Deals 50%% extra damage to pinned targets, in addition to the knockback.
		The blast wave may hit targets more then once, depending on the radius and the knockback effect.
		The damage will scale with your Spellpower.]], [[You surround yourself with a radius %d distortion of gravity, knocking back and dealing %0.2f physical damage to all creatures inside it.  The effect lasts %d turns.  Deals 50%% extra damage to pinned targets, in addition to the knockback.
		The blast wave may hit targets more then once, depending on the radius and the knockback effect.
		The damage will scale with your Spellpower.]], "tformat")
t([[Clones the target creature for up to %d turns.  The duration of the effect will be divided by half the target's rank, and the target will have have %d%% of its normal life and deal %d%% less damage.
		If you clone a hostile creature the clone will target the creature it was cloned from.
		The life and damage penalties will be lessened by your Spellpower.]], [[Clones the target creature for up to %d turns.  The duration of the effect will be divided by half the target's rank, and the target will have have %d%% of its normal life and deal %d%% less damage.
		If you clone a hostile creature the clone will target the creature it was cloned from.
		The life and damage penalties will be lessened by your Spellpower.]], "tformat")
t("%s(%d smeared)#LAST#", "%s(%d smeared)#LAST#", "tformat")
t([[You convert %d%% of all non-temporal damage you receive into temporal damage spread out over %d turns.
		This damage will bypass resistance and affinity.]], [[You convert %d%% of all non-temporal damage you receive into temporal damage spread out over %d turns.
		This damage will bypass resistance and affinity.]], "tformat")
t("Phase Shift", "Phase Shift", "talent name")
t("Phase shift yourself for %d turns; any damage greater than 10%% of your maximum life will teleport you to an adjacent tile and be reduced by 50%% (can only happen once per turn).", "Phase shift yourself for %d turns; any damage greater than 10%% of your maximum life will teleport you to an adjacent tile and be reduced by 50%% (can only happen once per turn).", "tformat")
t("Swap", "Swap", "talent name")
t([[You manipulate the spacetime continuum in such a way that you switch places with another creature with in a range of %d.  The targeted creature will be confused (power %d%%) for %d turns.
		The spell's hit chance will increase with your Spellpower.]], [[You manipulate the spacetime continuum in such a way that you switch places with another creature with in a range of %d.  The targeted creature will be confused (power %d%%) for %d turns.
		The spell's hit chance will increase with your Spellpower.]], "tformat")
t("Temporal Wake", "Temporal Wake", "talent name")
t([[Violently fold the space between yourself and another point within range.
		You teleport to the target location, and leave a temporal wake behind that stuns for %d turns and deals %0.2f temporal and %0.2f physical warp damage to targets in the path.
		The damage will scale with your Spellpower.]], [[Violently fold the space between yourself and another point within range.
		You teleport to the target location, and leave a temporal wake behind that stuns for %d turns and deals %0.2f temporal and %0.2f physical warp damage to targets in the path.
		The damage will scale with your Spellpower.]], "tformat")
t("Destabilize", "Destabilize", "talent name")
t([[Destabilizes the target, inflicting %0.2f temporal damage per turn for 10 turns.  If the target dies while destabilized, it will explode, doing %0.2f temporal damage and %0.2f physical damage in a radius of 4.
		If the target dies while also under the effects of continuum destabilization, all explosion damage will be done as temporal damage.
		The damage will scale with your Spellpower.]], [[Destabilizes the target, inflicting %0.2f temporal damage per turn for 10 turns.  If the target dies while destabilized, it will explode, doing %0.2f temporal damage and %0.2f physical damage in a radius of 4.
		If the target dies while also under the effects of continuum destabilization, all explosion damage will be done as temporal damage.
		The damage will scale with your Spellpower.]], "tformat")
t("Quantum Spike", "Quantum Spike", "talent name")
t("%s has been pulled apart at a molecular level!", "%s has been pulled apart at a molecular level!", "logSeen")
t("%s resists the quantum spike!", "%s resists the quantum spike!", "logSeen")
t([[Attempts to pull the target apart at a molecular level, inflicting %0.2f temporal damage and %0.2f physical damage.  If the target ends up with low enough life (<20%%), it might be instantly killed.
		Quantum Spike deals 50%% additional damage to targets affected by temporal destabilization and/or continuum destabilization.
		The damage will scale with your Spellpower.]], [[Attempts to pull the target apart at a molecular level, inflicting %0.2f temporal damage and %0.2f physical damage.  If the target ends up with low enough life (<20%%), it might be instantly killed.
		Quantum Spike deals 50%% additional damage to targets affected by temporal destabilization and/or continuum destabilization.
		The damage will scale with your Spellpower.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/chronomancy/temporal-archery.lua"
-- 8 entries
t("Phase Shot", "Phase Shot", "talent name")
t("You fire a shot that phases out of time and space allowing it to virtually ignore armor.  The shot will deal %d%% weapon damage as temporal damage to its target.", "You fire a shot that phases out of time and space allowing it to virtually ignore armor.  The shot will deal %d%% weapon damage as temporal damage to its target.", "tformat")
t("Unerring Shot", "Unerring Shot", "talent name")
t("You focus your aim and fire a shot with great accuracy, inflicting %d%% weapon damage.  Afterwords your attack will remain improved for one turn as the chronomantic effects linger.", "You focus your aim and fire a shot with great accuracy, inflicting %d%% weapon damage.  Afterwords your attack will remain improved for one turn as the chronomantic effects linger.", "tformat")
t("Perfect Aim", "Perfect Aim", "talent name")
t([[You focus your aim, increasing your critical damage multiplier by %d%% and your physical and spell critical strike chance by %d%%
		The effect will scale with your Spellpower.]], [[You focus your aim, increasing your critical damage multiplier by %d%% and your physical and spell critical strike chance by %d%%
		The effect will scale with your Spellpower.]], "tformat")
t("Quick Shot", "Quick Shot", "talent name")
t([[You pause time around you long enough to fire a single shot, doing %d%% damage.
		The damage will scale with your Paradox and the cooldown will go down with more talent points invested.]], [[You pause time around you long enough to fire a single shot, doing %d%% damage.
		The damage will scale with your Paradox and the cooldown will go down with more talent points invested.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/cunning/artifice.lua"
-- 2 entries
t([[#YELLOW#%s (%s)#LAST#
]], [[#YELLOW#%s (%s)#LAST#
]], "tformat")
t([[%s (%s)
]], [[%s (%s)
]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/cunning/traps.lua"
-- 1 entries
t(" (%s)", " (%s)", "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/cursed/crimson-templar.lua"
-- 1 entries
t("sacrificed themself", "sacrificed themself", "_t")


------------------------------------------------
section "game/modules/tome/data/talents/cursed/cursed.lua"
-- 2 entries
t("All the things in this dark world are contemptible.  Let yourself hate them and find the power therein.", "All the things in this dark world are contemptible.  Let yourself hate them and find the power therein.", "_t")
t("Hatred", "Hatred", "_t")


------------------------------------------------
section "game/modules/tome/data/talents/cursed/primal-magic.lua"
-- 8 entries
t("Displace", "Displace", "talent name")
t("Selects a displacement location...", "Selects a displacement location...", "logPlayer")
t("Your attempt to displace fails!", "Your attempt to displace fails!", "logSeen")
t("Instantaneously displace yourself within line of sight up to 3 squares away.", "Instantaneously displace yourself within line of sight up to 3 squares away.", "tformat")
t("Primal Skin", "Primal Skin", "talent name")
t([[Years of magic have permeated your skin leaving it resistant to the physical world. Your armor is increased by %d.
		The bonus will increase with the Magic stat.]], [[Years of magic have permeated your skin leaving it resistant to the physical world. Your armor is increased by %d.
		The bonus will increase with the Magic stat.]], "tformat")
t("Vaporize", "Vaporize", "talent name")
t([[Bathes the target in raw magic inflicting %d damage. Such wild magic is difficult to control and if you fail to keep your wits you will be confused for 4 turns.
		The damage will increase with the Magic stat.]], [[Bathes the target in raw magic inflicting %d damage. Such wild magic is difficult to control and if you fail to keep your wits you will be confused for 4 turns.
		The damage will increase with the Magic stat.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/cursed/self-hatred.lua"
-- 5 entries
t("Self-Sacrifice", "Self-Sacrifice", "talent name")
t([[At the start of each turn, if you're bleeding, you gain %d hate.

You can activate this talent to use your own life for power, bleeding yourself for a small portion of your maximum life (%0.2f damage) over the next 5 turns. This bleed cannot be resisted or removed, but can be reduced by Bloodstained.]], [[At the start of each turn, if you're bleeding, you gain %d hate.

You can activate this talent to use your own life for power, bleeding yourself for a small portion of your maximum life (%0.2f damage) over the next 5 turns. This bleed cannot be resisted or removed, but can be reduced by Bloodstained.]], "tformat")
t("#CRIMSON#%d#LAST#", "#CRIMSON#%d#LAST#", "tformat")
t("tore themself apart", "tore themself apart", "_t")
t([[Any direct damage that exceeds %d%% of your maximum life has the excess damage converted to a shallow wound that bleeds over the next %d turns. This bleed cannot be resisted or removed, but can be reduced by Bloodstained. Extremely powerful hits (more than %d%% of your max life) are not fully converted.

#{italic}#You can't just die. That would be too easy.#{normal}#]], [[Any direct damage that exceeds %d%% of your maximum life has the excess damage converted to a shallow wound that bleeds over the next %d turns. This bleed cannot be resisted or removed, but can be reduced by Bloodstained. Extremely powerful hits (more than %d%% of your max life) are not fully converted.

#{italic}#You can't just die. That would be too easy.#{normal}#]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/gifts/malleable-body.lua"
-- 8 entries
t("azdadazdazdazd", "azdadazdazdazd", "talent name")
t([[Your body is more like that of an ooze, you can split into two for %d turns.
		Your original self has the original ooze aspect while your mitosis gains the acid aspect.
		If you know the Oozing Blades tree all the talents inside are exchanged for those of the Corrosive Blades tree.
		Your two selves share the same healthpool.
		While you are split both of you gain %d%% all resistances.
		Resistances will increase with Mindpower.]], [[Your body is more like that of an ooze, you can split into two for %d turns.
		Your original self has the original ooze aspect while your mitosis gains the acid aspect.
		If you know the Oozing Blades tree all the talents inside are exchanged for those of the Corrosive Blades tree.
		Your two selves share the same healthpool.
		While you are split both of you gain %d%% all resistances.
		Resistances will increase with Mindpower.]], "tformat")
t("ervevev", "ervevev", "talent name")
t([[Improve your fungus to allow it to take a part of any healing you receive and improve it.
		Each time you are healed you get a regeneration effect for 6 turns that heals you of %d%% of the direct heal you received.
		The effect will increase with your Mindpower.]], [[Improve your fungus to allow it to take a part of any healing you receive and improve it.
		Each time you are healed you get a regeneration effect for 6 turns that heals you of %d%% of the direct heal you received.
		The effect will increase with your Mindpower.]], "tformat")
t("zeczczeczec", "zeczczeczec", "talent name")
t([[Both of you swap place in an instant, creatures attacking one will target the other.
		While swaping you briefly merge together, boosting all your nature and acid damage by %d%% for 6 turns and healing you for %d.
		Damage and healing increase with Mindpower.]], [[Both of you swap place in an instant, creatures attacking one will target the other.
		While swaping you briefly merge together, boosting all your nature and acid damage by %d%% for 6 turns and healing you for %d.
		Damage and healing increase with Mindpower.]], "tformat")
t("Indiscernible Anatomyblabla", "Indiscernible Anatomyblabla", "talent name")
t([[Your body's internal organs are melted together, making it much harder to suffer critical hits.
		All direct critical hits (physical, mental, spells) against you have a %d%% chance to instead do their normal damage.]], [[Your body's internal organs are melted together, making it much harder to suffer critical hits.
		All direct critical hits (physical, mental, spells) against you have a %d%% chance to instead do their normal damage.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-distance.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/talents/gifts/summon-melee.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/data/talents/misc/inscriptions.lua"
-- 35 entries
t(" ", " ", "tformat")
t("Infusion: Sun", "Infusion: Sun", "talent name")
t([[Activate the infusion to brighten the area in a radius of %d and illuminate stealthy creatures, possibly revealing them (reduces stealth power by %d).%s
		It will also blind any creatures caught inside (power %d) for %d turns.]], [[Activate the infusion to brighten the area in a radius of %d and illuminate stealthy creatures, possibly revealing them (reduces stealth power by %d).%s
		It will also blind any creatures caught inside (power %d) for %d turns.]], "tformat")
t("\
The light is so powerful it will also banish magical darkness", "\
The light is so powerful it will also banish magical darkness", "_t")
t("; dispels darkness", "; dispels darkness", "_t")
t("rad %d; power %d; turns %d%s", "rad %d; power %d; turns %d%s", "tformat")
t("Taint: Telepathy", "Taint: Telepathy", "talent name")
t("Strip the protective barriers from your mind for %d turns, allowing in the thoughts all creatures within %d squares but reducing mind save by %d and increasing your mindpower by %d for 10 turns.", "Strip the protective barriers from your mind for %d turns, allowing in the thoughts all creatures within %d squares but reducing mind save by %d and increasing your mindpower by %d for 10 turns.", "tformat")
t("Range %d telepathy for %d turns", "Range %d telepathy for %d turns", "tformat")
t("Rune: Frozen Spear", "Rune: Frozen Spear", "talent name")
t([[Activate the rune to fire a bolt of ice, doing %0.2f cold damage with a chance to freeze the target.
		The deep cold also crystalizes your mind, removing one random detrimental mental effect from you.]], [[Activate the rune to fire a bolt of ice, doing %0.2f cold damage with a chance to freeze the target.
		The deep cold also crystalizes your mind, removing one random detrimental mental effect from you.]], "tformat")
t("%d cold damage", "%d cold damage", "tformat")
t("Rune: Heat Beam", "Rune: Heat Beam", "talent name")
t([[Activate the rune to fire a beam of heat, doing %0.2f fire damage over 5 turns
		The intensity of the heat will also remove one random detrimental physical effect from you.]], [[Activate the rune to fire a beam of heat, doing %0.2f fire damage over 5 turns
		The intensity of the heat will also remove one random detrimental physical effect from you.]], "tformat")
t("%d fire damage", "%d fire damage", "tformat")
t("Rune: Speed", "Rune: Speed", "talent name")
t("Activate the rune to increase your global speed by %d%% for %d turns.", "Activate the rune to increase your global speed by %d%% for %d turns.", "tformat")
t("speed %d%% for %d turns", "speed %d%% for %d turns", "tformat")
t("Rune: Vision", "Rune: Vision", "talent name")
t([[Activate the rune to get a vision of the area surrounding you (%d radius) and to allow you to see invisible and stealthed creatures (power %d) for %d turns.
		Your mind will become more receptive for %d turns, allowing you to sense any %s around.]], [[Activate the rune to get a vision of the area surrounding you (%d radius) and to allow you to see invisible and stealthed creatures (power %d) for %d turns.
		Your mind will become more receptive for %d turns, allowing you to sense any %s around.]], "tformat")
t("radius %d; dur %d; see %s", "radius %d; dur %d; see %s", "tformat")
t("Rune: Phase Door", "Rune: Phase Door", "talent name")
t([[Activate the rune to teleport randomly in a range of %d.
		Afterwards you stay out of phase for %d turns. In this state all new negative status effects duration is reduced by %d%%, your defense is increased by %d and all your resistances by %d%%.]], [[Activate the rune to teleport randomly in a range of %d.
		Afterwards you stay out of phase for %d turns. In this state all new negative status effects duration is reduced by %d%%, your defense is increased by %d and all your resistances by %d%%.]], "tformat")
t("range %d; power %d; dur %d", "range %d; power %d; dur %d", "tformat")
t("Rune: Controlled Phase Door", "Rune: Controlled Phase Door", "talent name")
t("Activate the rune to teleport in a range of %d.", "Activate the rune to teleport in a range of %d.", "tformat")
t("Rune: Lightning", "Rune: Lightning", "talent name")
t([[Activate the rune to fire a beam of lightning, doing %0.2f to %0.2f lightning damage.
		Also transform you into pure lightning for %d turns; any damage will teleport you to an adjacent tile and ignore the damage (can only happen once per turn)]], [[Activate the rune to fire a beam of lightning, doing %0.2f to %0.2f lightning damage.
		Also transform you into pure lightning for %d turns; any damage will teleport you to an adjacent tile and ignore the damage (can only happen once per turn)]], "tformat")
t("%d lightning damage", "%d lightning damage", "tformat")
t("Infusion: Insidious Poison", "Infusion: Insidious Poison", "talent name")
t([[Activate the infusion to spit a bolt of poison doing %0.2f nature damage per turn for 7 turns, and reducing the target's healing received by %d%%.
		The sudden stream of natural forces also strips you of one random detrimental magical effect.]], [[Activate the infusion to spit a bolt of poison doing %0.2f nature damage per turn for 7 turns, and reducing the target's healing received by %d%%.
		The sudden stream of natural forces also strips you of one random detrimental magical effect.]], "tformat")
t("%d nature damage, %d%% healing reduction", "%d nature damage, %d%% healing reduction", "tformat")
t("Rune: Invisibility", "Rune: Invisibility", "talent name")
t([[Activate the rune to become invisible (power %d) for %d turns.
		As you become invisible you fade out of phase with reality, all your damage is reduced by 40%%.
		]], [[Activate the rune to become invisible (power %d) for %d turns.
		As you become invisible you fade out of phase with reality, all your damage is reduced by 40%%.
		]], "tformat")
t("power %d for %d turns", "power %d for %d turns", "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/misc/npcs.lua"
-- 1 entries
t("", "", "log")


------------------------------------------------
section "game/modules/tome/data/talents/psionic/grip.lua"
-- 3 entries
t([[Bind the target in crushing bands of telekinetic force, immobilizing it for %d turns. 
		The duration will improve with your Mindpower.]], [[Bind the target in crushing bands of telekinetic force, immobilizing it for %d turns. 
		The duration will improve with your Mindpower.]], "tformat")
t("Greater Telekinetic Grasp", "Greater Telekinetic Grasp", "talent name")
t([[Use finely controlled forces to augment both your flesh-and-blood grip, and your telekinetic grip. This does the following:
		Increases disarm immunity by %d%%.
		Allows %d%% of Willpower and Cunning (instead of the usual 60%%) to be substituted for Strength and Dexterity for the purposes of determining damage done by telekinetically-wielded weapons.
		At talent level 5, telekinetically wielded gems and mindstars will be treated as one material level higher than they actually are.
		]], [[Use finely controlled forces to augment both your flesh-and-blood grip, and your telekinetic grip. This does the following:
		Increases disarm immunity by %d%%.
		Allows %d%% of Willpower and Cunning (instead of the usual 60%%) to be substituted for Strength and Dexterity for the purposes of determining damage done by telekinetically-wielded weapons.
		At talent level 5, telekinetically wielded gems and mindstars will be treated as one material level higher than they actually are.
		]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/psionic/mental-discipline.lua"
-- 5 entries
t("Shield Discipline", "Shield Discipline", "talent name")
t("Your expertise in the art of energy absorption grows. Shield cooldowns are all reduced by %d turns, the amount of damage absorption required to gain a point of energy is reduced by %0.1f, and the maximum energy you can gain from each shield is increased by %0.1f per turn.", "Your expertise in the art of energy absorption grows. Shield cooldowns are all reduced by %d turns, the amount of damage absorption required to gain a point of energy is reduced by %0.1f, and the maximum energy you can gain from each shield is increased by %0.1f per turn.", "tformat")
t("Improves Mental Saves by %d, and stun immunity by %d%%.", "Improves Mental Saves by %d, and stun immunity by %d%%.", "tformat")
t("Highly Trained Mind", "Highly Trained Mind", "talent name")
t([[A life of the mind has had predictably good effects on your Willpower and Cunning.
		Increases Willpower and Cunning by %d.]], [[A life of the mind has had predictably good effects on your Willpower and Cunning.
		Increases Willpower and Cunning by %d.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/psionic/psi-archery.lua"
-- 6 entries
t("Thought-quick Shot", "Thought-quick Shot", "talent name")
t("Ready and release an arrow with a flitting thought. This attack does not use a turn, and increases in talent level reduce its cooldown.", "Ready and release an arrow with a flitting thought. This attack does not use a turn, and increases in talent level reduce its cooldown.", "tformat")
t("Masterful Telekinetic Archery", "Masterful Telekinetic Archery", "talent name")
t("You cannot do that without a telekinetically-wielded bow.", "You cannot do that without a telekinetically-wielded bow.", "logPlayer")
t([[You temporarily set aside a part of you mind to direct your telekinetically-wielded bow. It will automatically attack the nearest target each turn for %d turns.
			The telekinetically-wielded bow uses Willpower in place of Strength and Cunning in place of Dexterity to determine attack and damage.
			You are not telekinetically wielding anything right now.]], [[You temporarily set aside a part of you mind to direct your telekinetically-wielded bow. It will automatically attack the nearest target each turn for %d turns.
			The telekinetically-wielded bow uses Willpower in place of Strength and Cunning in place of Dexterity to determine attack and damage.
			You are not telekinetically wielding anything right now.]], "tformat")
t([[You temporarily set aside a part of you mind to direct your telekinetically-wielded bow. It will automatically attack a target each turn for %d turns.
			The telekinetically-wielded bow uses Willpower in place of Strength and Cunning in place of Dexterity to determine attack and damage.
		Combat stats:
		Accuracy: %d
		Damage: %d
		APR: %d
		Crit: %0.2f
		Speed: %0.2f]], [[You temporarily set aside a part of you mind to direct your telekinetically-wielded bow. It will automatically attack a target each turn for %d turns.
			The telekinetically-wielded bow uses Willpower in place of Strength and Cunning in place of Dexterity to determine attack and damage.
		Combat stats:
		Accuracy: %d
		Damage: %d
		APR: %d
		Crit: %0.2f
		Speed: %0.2f]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/psionic/telekinetic-combat.lua"
-- 2 entries
t("Telekinetic Assault", "Telekinetic Assault", "talent name")
t([[Assault your target with all weapons, dealing two strikes with your telekinetically-wielded weapon for %d%% damage followed by an attack with your physical weapon for %d%% damage.
		This physical weapon attack uses your Willpower and Cunning instead of Strength and Dexterity to determine Accuracy and damage.
		Any active Aura damage bonusses will extend to your main weapons for this attack.]], [[Assault your target with all weapons, dealing two strikes with your telekinetically-wielded weapon for %d%% damage followed by an attack with your physical weapon for %d%% damage.
		This physical weapon attack uses your Willpower and Cunning instead of Strength and Dexterity to determine Accuracy and damage.
		Any active Aura damage bonusses will extend to your main weapons for this attack.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/spells/thaumaturgy.lua"
-- 3 entries
t("#LIGHT_BLUE#%s [known, eligible]#LAST#", "#LIGHT_BLUE#%s [known, eligible]#LAST#", "tformat")
t("#YELLOW#%s [known]#LAST#", "#YELLOW#%s [known]#LAST#", "tformat")
t("#GREY#%s [unknown]#LAST#", "#GREY#%s [unknown]#LAST#", "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/spells/war-alchemy.lua"
-- 2 entries
t("Heat", "Heat", "talent name")
t([[Turn part of your target into fire, burning the rest for %0.2f fire damage over 8 turns.
		The damage will increase with your Spellpower.]], [[Turn part of your target into fire, burning the rest for %0.2f fire damage over 8 turns.
		The damage will increase with your Spellpower.]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/techniques/throwing-knives.lua"
-- 1 entries
t("%d%% %s", "%d%% %s", "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/uber/mag.lua"
-- 1 entries
t([[%s
#YELLOW#%s#LAST#
%s
]], [[%s
#YELLOW#%s#LAST#
%s
]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/uber/wil.lua"
-- 1 entries
t([[The code of the Sun Paladins can be a heavy burden.	 Wouldn't you like to let go?
		#{italic}##GREY#To give in to the darkness?#LAST##{normal}#
		
		#CRIMSON#This evolution fundamentally alters your class and character in a huge way. Do not take it lightly.#LAST#

		Any offensive combat techniques or unlockable Celestial talent trees you know will be exchanged for cursed versions, allowing you to cut a bloody trail through enemies, turning your radiance to gloom, and more while also gaining new combat styles and defenses.

		The following talent trees are swapped:
		- #GOLD#Radiance#LAST# turns into #CRIMSON#Gloom#LAST#: Project onto others your own hate, hindering them
		- #GOLD#Guardian#LAST# turns into #CRIMSON#Crimson Templar#LAST#: Use the power of blood to control and defeat the fools that oppose you
		- #GOLD#Crusader#LAST# turns into #CRIMSON#Dark Sun#LAST#: Call upon the energies of dead suns to crush your foes

		You will learn the following talents trees:
		- #CRIMSON#Bloodstained#LAST#: Make your foes bleed!
		- #CRIMSON#Darkside#LAST#: Every light casts a shadow, yours is powerful indeed
		- #CRIMSON#Hatred#LAST#: Manifest your hatred through bleeding
		- #CRIMSON#Dirge#LAST#: Sing of death and sorrow to strengthen your resolve

		You will forget the following talent trees, refunding any talent points: Shield Offense, Two-handed Assault.
		Also the cost of any talents of the Combat Techniques tree will be converted to hate instead of stamina.
		]], [[The code of the Sun Paladins can be a heavy burden.	 Wouldn't you like to let go?
		#{italic}##GREY#To give in to the darkness?#LAST##{normal}#
		
		#CRIMSON#This evolution fundamentally alters your class and character in a huge way. Do not take it lightly.#LAST#

		Any offensive combat techniques or unlockable Celestial talent trees you know will be exchanged for cursed versions, allowing you to cut a bloody trail through enemies, turning your radiance to gloom, and more while also gaining new combat styles and defenses.

		The following talent trees are swapped:
		- #GOLD#Radiance#LAST# turns into #CRIMSON#Gloom#LAST#: Project onto others your own hate, hindering them
		- #GOLD#Guardian#LAST# turns into #CRIMSON#Crimson Templar#LAST#: Use the power of blood to control and defeat the fools that oppose you
		- #GOLD#Crusader#LAST# turns into #CRIMSON#Dark Sun#LAST#: Call upon the energies of dead suns to crush your foes

		You will learn the following talents trees:
		- #CRIMSON#Bloodstained#LAST#: Make your foes bleed!
		- #CRIMSON#Darkside#LAST#: Every light casts a shadow, yours is powerful indeed
		- #CRIMSON#Hatred#LAST#: Manifest your hatred through bleeding
		- #CRIMSON#Dirge#LAST#: Sing of death and sorrow to strengthen your resolve

		You will forget the following talent trees, refunding any talent points: Shield Offense, Two-handed Assault.
		Also the cost of any talents of the Combat Techniques tree will be converted to hate instead of stamina.
		]], "tformat")


------------------------------------------------
section "game/modules/tome/data/talents/undeads/undeads.lua"
-- 1 entries
t("You concentrate for a moment to recall some of your memories as a living being and look for knowledge to identify rare objects.", "You concentrate for a moment to recall some of your memories as a living being and look for knowledge to identify rare objects.", "tformat")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/informed1.lua"
-- 1 entries
t([[Armed with the knowledge of how important #GOLD#combat stats#WHITE# are, we now go in search of them. Yours are displayed in your character sheet. Once you've closed this window, you can open it and move your mouse cursor over them to see a brief description of what they do. The tooltip mentions some stuff we haven't covered yet, but we'll get there.

So what about seeing a monster's #GOLD#combat stats#WHITE#? This would hardly be a dungeon without creepy denizens; there's an orc ahead you can examine. Use the mouse or the 'l'ook command to examine that orc.
]], [[Armed with the knowledge of how important #GOLD#combat stats#WHITE# are, we now go in search of them. Yours are displayed in your character sheet. Once you've closed this window, you can open it and move your mouse cursor over them to see a brief description of what they do. The tooltip mentions some stuff we haven't covered yet, but we'll get there.

So what about seeing a monster's #GOLD#combat stats#WHITE#? This would hardly be a dungeon without creepy denizens; there's an orc ahead you can examine. Use the mouse or the 'l'ook command to examine that orc.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale1.lua"
-- 1 entries
t([[As you can see, the #GOLD#combat stat#WHITE# scores are displayed in two columns with offensive #GOLD#combat stats#WHITE# to the left and defensive #GOLD#combat stats#WHITE# to the right. 

The displayed numbers are color coded according to their value.
]], [[As you can see, the #GOLD#combat stat#WHITE# scores are displayed in two columns with offensive #GOLD#combat stats#WHITE# to the left and defensive #GOLD#combat stats#WHITE# to the right. 

The displayed numbers are color coded according to their value.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale10.lua"
-- 1 entries
t([[How did you do this time? Your #LIGHT_GREEN#Mental Save#WHITE# score is #00FF80#tier 3#WHITE#, and an item that granted you +6 #LIGHT_GREEN#Mental Save#WHITE# only increased this score by 2.

Can you explain what's going on?
]], [[How did you do this time? Your #LIGHT_GREEN#Mental Save#WHITE# score is #00FF80#tier 3#WHITE#, and an item that granted you +6 #LIGHT_GREEN#Mental Save#WHITE# only increased this score by 2.

Can you explain what's going on?
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale11.lua"
-- 1 entries
t([[It simply costs more to increase scores that are in higher tiers.

For each tier, here's the cost of increasing your score by one:

#B4B4B4#Tier 1#WHITE#: 1 point
#FFFFFF#Tier 2#WHITE#: 2 points
#00FF80#Tier 3#WHITE#: 3 points
#0080FF#Tier 4#WHITE#: 4 points
#8d55ff#Tier 5#WHITE#: 5 points
]], [[It simply costs more to increase scores that are in higher tiers.

For each tier, here's the cost of increasing your score by one:

#B4B4B4#Tier 1#WHITE#: 1 point
#FFFFFF#Tier 2#WHITE#: 2 points
#00FF80#Tier 3#WHITE#: 3 points
#0080FF#Tier 4#WHITE#: 4 points
#8d55ff#Tier 5#WHITE#: 5 points
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale12.lua"
-- 1 entries
t([[This gets expensive! It's entirely possible-- even likely-- for a game-winning character to never have any #8d55ff#Tier 5#WHITE# scores.

There are stairs ahead. Descend further into the #GOLD#Dungeon of Adventurer Enlightenment#WHITE# to learn how exactly #GOLD#combat stat#WHITE# scores affect gameplay.
]], [[This gets expensive! It's entirely possible-- even likely-- for a game-winning character to never have any #8d55ff#Tier 5#WHITE# scores.

There are stairs ahead. Descend further into the #GOLD#Dungeon of Adventurer Enlightenment#WHITE# to learn how exactly #GOLD#combat stat#WHITE# scores affect gameplay.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale2.lua"
-- 1 entries
t([[Some clues:

1) #LIGHT_GREEN#Defense#WHITE# is 20 and #LIGHT_GREEN#Physical Save#WHITE# is 21, yet they have different colors and positions.

2) There seems to be no overlap in positions. The 21 is entirely to the right of that 20, for example.

3) Each display scale is ten characters long, and each score takes up two characters.
]], [[Some clues:

1) #LIGHT_GREEN#Defense#WHITE# is 20 and #LIGHT_GREEN#Physical Save#WHITE# is 21, yet they have different colors and positions.

2) There seems to be no overlap in positions. The 21 is entirely to the right of that 20, for example.

3) Each display scale is ten characters long, and each score takes up two characters.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale3.lua"
-- 1 entries
t([[#GOLD#Combat stat#WHITE# scores are between one and one-hundred, with special color coding applied for each interval of twenty. The colors are the same hues as those used in inventory text to indicate gear quality.

These subintervals of twenty we'll call #GOLD#tiers#WHITE# from now on.
]], [[#GOLD#Combat stat#WHITE# scores are between one and one-hundred, with special color coding applied for each interval of twenty. The colors are the same hues as those used in inventory text to indicate gear quality.

These subintervals of twenty we'll call #GOLD#tiers#WHITE# from now on.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale4.lua"
-- 1 entries
t([[A summary of the #GOLD#combat stat#WHITE# tiers:

#B4B4B4#Tier 1#WHITE# scores, those from one to twenty, are displayed in #B4B4B4#grey#WHITE#.
#FFFFFF#Tier 2#WHITE# scores, those from twenty-one to forty, are displayed in #FFFFFF#white#WHITE#.
#00FF80#Tier 3#WHITE# scores, those from forty-one to sixty, are displayed in #00FF80#green#WHITE#.
#0080FF#Tier 4#WHITE# scores, those from sixty-one to eighty, are displayed in #0080FF#blue#WHITE#.
#8d55ff#Tier 5#WHITE# scores, those from eighty-one to one-hundred, are displayed in #8d55ff#purple#WHITE#.
]], [[A summary of the #GOLD#combat stat#WHITE# tiers:

#B4B4B4#Tier 1#WHITE# scores, those from one to twenty, are displayed in #B4B4B4#grey#WHITE#.
#FFFFFF#Tier 2#WHITE# scores, those from twenty-one to forty, are displayed in #FFFFFF#white#WHITE#.
#00FF80#Tier 3#WHITE# scores, those from forty-one to sixty, are displayed in #00FF80#green#WHITE#.
#0080FF#Tier 4#WHITE# scores, those from sixty-one to eighty, are displayed in #0080FF#blue#WHITE#.
#8d55ff#Tier 5#WHITE# scores, those from eighty-one to one-hundred, are displayed in #8d55ff#purple#WHITE#.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale5.lua"
-- 1 entries
t([[These tiers are not just for show. 

Let's see if you can discover a way in which they're NOT purely cosmetic. Go plunder the room ahead!
]], [[These tiers are not just for show. 

Let's see if you can discover a way in which they're NOT purely cosmetic. Go plunder the room ahead!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale6.lua"
-- 1 entries
t([[By how much did the amulet increase your #B4B4B4#tier 1#WHITE# #LIGHT_GREEN#Mindpower#WHITE# score?

By how much did the boots increase your #FFFFFF#tier 2#WHITE# #LIGHT_GREEN#Physical save#WHITE# score?

Take them off and put them back on if you didn't see their effects. One of the results might be surprising.
]], [[By how much did the amulet increase your #B4B4B4#tier 1#WHITE# #LIGHT_GREEN#Mindpower#WHITE# score?

By how much did the boots increase your #FFFFFF#tier 2#WHITE# #LIGHT_GREEN#Physical save#WHITE# score?

Take them off and put them back on if you didn't see their effects. One of the results might be surprising.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale7.lua"
-- 1 entries
t([[Those boots appear to have only increased your #LIGHT_GREEN#Physical save#WHITE# by 5.

What do you suppose would be the effects of putting on a helmet with +6 #LIGHT_GREEN#Accuracy#WHITE#?
]], [[Those boots appear to have only increased your #LIGHT_GREEN#Physical save#WHITE# by 5.

What do you suppose would be the effects of putting on a helmet with +6 #LIGHT_GREEN#Accuracy#WHITE#?
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale8.lua"
-- 1 entries
t([[Test your hypothesis!
]], [[Test your hypothesis!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-scale/scale9.lua"
-- 1 entries
t([[Did you accurately predict that +6 to a #FFFFFF#tier 2#WHITE# #GOLD#combat stat#WHITE# score would result in an increase of only 3?

Let's try again in the next room. What do you suppose will happen when you put on an item that grants you +6 #LIGHT_GREEN#Mental save#WHITE#?
]], [[Did you accurately predict that +6 to a #FFFFFF#tier 2#WHITE# #GOLD#combat stat#WHITE# score would result in an increase of only 3?

Let's try again in the next room. What do you suppose will happen when you put on an item that grants you +6 #LIGHT_GREEN#Mental save#WHITE#?
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier0.lua"
-- 1 entries
t([[Until now, a certain game mechanic has been disabled. Go learn a new talent at the nearby Rune of Enlightenment and use it to blast each of the enemies in the next room. 

Can you identify the new mechanic?
]], [[Until now, a certain game mechanic has been disabled. Go learn a new talent at the nearby Rune of Enlightenment and use it to blast each of the enemies in the next room. 

Can you identify the new mechanic?
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier1.lua"
-- 1 entries
t([[If you don't notice anything, try examining each monster's tooltip immediately after using Mana Gale on it.
]], [[If you don't notice anything, try examining each monster's tooltip immediately after using Mana Gale on it.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier10.lua"
-- 1 entries
t([[Basic attacks, ones that compare #LIGHT_GREEN#Accuracy#WHITE# to #LIGHT_GREEN#Defense#WHITE#, only apply #GOLD#cross-tier afflictions#WHITE# on critical hits.

Still, it's a good reason to not neglect your #LIGHT_GREEN#Defense#WHITE# stat, even if it's not central to your class.
]], [[Basic attacks, ones that compare #LIGHT_GREEN#Accuracy#WHITE# to #LIGHT_GREEN#Defense#WHITE#, only apply #GOLD#cross-tier afflictions#WHITE# on critical hits.

Still, it's a good reason to not neglect your #LIGHT_GREEN#Defense#WHITE# stat, even if it's not central to your class.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier11.lua"
-- 1 entries
t([[#GOLD#Congratulations!#WHITE# You have completed the combat stats tutorial. Hopefully it has been of some use to you.

]], [[#GOLD#Congratulations!#WHITE# You have completed the combat stats tutorial. Hopefully it has been of some use to you.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier12.lua"
-- 1 entries
t([[#LIGHT_GREEN#For those who want to join the discussion on these new mechanics, please first read the document "Transparency.rtf" found here:#WHITE#

tome/data/texts/Transparency.rtf

This is an essay, not code. Open it with something appropriate to avoid being overwhelmed by a dense wall of text.
]], [[#LIGHT_GREEN#For those who want to join the discussion on these new mechanics, please first read the document "Transparency.rtf" found here:#WHITE#

tome/data/texts/Transparency.rtf

This is an essay, not code. Open it with something appropriate to avoid being overwhelmed by a dense wall of text.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier2.lua"
-- 1 entries
t([[Can you explain the difference in the durations for that "Off-balance" timed effect you're inflicting?

Why is one of the spiders unaffected?

Go learn the Blink spell just to the south, then go back and try it on the spiders.
]], [[Can you explain the difference in the durations for that "Off-balance" timed effect you're inflicting?

Why is one of the spiders unaffected?

Go learn the Blink spell just to the south, then go back and try it on the spiders.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier3.lua"
-- 1 entries
t([[Have you determined what's causing those new timed effects?

If not, then consider the following questions:

1) What #GOLD#combat stat#WHITE# are you using as the attacker, and what #GOLD#combat stat#WHITE# are the spiders using as the defenders?

2) What tiers are these #GOLD#combat stats#WHITE#?

Feel free to go batter those spiders some more if you need further experimentation!
]], [[Have you determined what's causing those new timed effects?

If not, then consider the following questions:

1) What #GOLD#combat stat#WHITE# are you using as the attacker, and what #GOLD#combat stat#WHITE# are the spiders using as the defenders?

2) What tiers are these #GOLD#combat stats#WHITE#?

Feel free to go batter those spiders some more if you need further experimentation!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier4.lua"
-- 1 entries
t([[Let's take a closer look at these new timed effects. The easiest way to do that is to have them inflicted on you.

Ahead are a series of bored elves who will happily blast you with whatever spell they have handy. Examine the tooltip of each effect they inflict on you.

]], [[Let's take a closer look at these new timed effects. The easiest way to do that is to have them inflicted on you.

Ahead are a series of bored elves who will happily blast you with whatever spell they have handy. Examine the tooltip of each effect they inflict on you.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier5.lua"
-- 1 entries
t([[Note that all three elves were casting using a #8d55ff#Tier 5#WHITE# #GOLD#combat stat#WHITE#, though they produced effects that varied in duration.

If you hadn't already deduced the rules governing these new status effects, hopefully this helped.
]], [[Note that all three elves were casting using a #8d55ff#Tier 5#WHITE# #GOLD#combat stat#WHITE#, though they produced effects that varied in duration.

If you hadn't already deduced the rules governing these new status effects, hopefully this helped.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier6.lua"
-- 1 entries
t([[These new effects are #GOLD#cross-tier effects#WHITE#. They occur when a talent calls for comparing #GOLD#combat stats#WHITE# that aren't in the same tier. 

Physical effects cause the "Off-balance" effect.

Magic effects cause the "Spellshocked" effect.

Mental effects cause the "Brainlocked" effect.

The effects last one turn per tier difference in the attacker's and defender's #GOLD#combat stats#WHITE#. For example, casting Mana Gale with a #8d55ff#Tier 5#WHITE# #LIGHT_GREEN#Spellpower#WHITE# on a target with a #B4B4B4#Tier 1#WHITE# #LIGHT_GREEN#Physical save#WHITE# would result in applying a four-turn "Off-balance" effect.

]], [[These new effects are #GOLD#cross-tier effects#WHITE#. They occur when a talent calls for comparing #GOLD#combat stats#WHITE# that aren't in the same tier. 

Physical effects cause the "Off-balance" effect.

Magic effects cause the "Spellshocked" effect.

Mental effects cause the "Brainlocked" effect.

The effects last one turn per tier difference in the attacker's and defender's #GOLD#combat stats#WHITE#. For example, casting Mana Gale with a #8d55ff#Tier 5#WHITE# #LIGHT_GREEN#Spellpower#WHITE# on a target with a #B4B4B4#Tier 1#WHITE# #LIGHT_GREEN#Physical save#WHITE# would result in applying a four-turn "Off-balance" effect.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier7.lua"
-- 1 entries
t([[Be very careful about neglecting your defensive #GOLD#combat stats#WHITE#. A long-lasting #GOLD#cross-tier effect#WHITE# is dangerous!

At the same time, be on the lookout for enemies a very low defensive #GOLD#combat stat#WHITE#, and consider hitting them with something appropriate to inflict a #GOLD#cross-tier effect#WHITE#!
]], [[Be very careful about neglecting your defensive #GOLD#combat stats#WHITE#. A long-lasting #GOLD#cross-tier effect#WHITE# is dangerous!

At the same time, be on the lookout for enemies a very low defensive #GOLD#combat stat#WHITE#, and consider hitting them with something appropriate to inflict a #GOLD#cross-tier effect#WHITE#!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier8.lua"
-- 1 entries
t([[What about #LIGHT_GREEN#Defense?#WHITE# Is it safe to neglect that?

Go see how your #B4B4B4#Tier 1#WHITE# #LIGHT_GREEN#Defense#WHITE# holds up against the orcs in the next room.
]], [[What about #LIGHT_GREEN#Defense?#WHITE# Is it safe to neglect that?

Go see how your #B4B4B4#Tier 1#WHITE# #LIGHT_GREEN#Defense#WHITE# holds up against the orcs in the next room.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-tier/tier9.lua"
-- 1 entries
t([[Their melee attacks seem to sometimes apply the "Off-balance" effect, but not always.

Can you figure out when it gets applied and when it doesn't?
]], [[Their melee attacks seem to sometimes apply the "Off-balance" effect, but not always.

Can you figure out when it gets applied and when it doesn't?
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed0.lua"
-- 1 entries
t([[Detrimental #GOLD#timed effects#WHITE# are conditions which cause various short-term problems, such as blindness, confusion, stunning, poisoning, slowing, and much more. Much of what we've seen so far applies to them; the type of effect determines what defensive #GOLD#combat stat#WHITE# the defender uses, and the source of the effect determines what offensive #GOLD#combat stat#WHITE# the attacker uses.

Let's experiment to find out more. Move on to learn a new talent. Be sure to read its description!
]], [[Detrimental #GOLD#timed effects#WHITE# are conditions which cause various short-term problems, such as blindness, confusion, stunning, poisoning, slowing, and much more. Much of what we've seen so far applies to them; the type of effect determines what defensive #GOLD#combat stat#WHITE# the defender uses, and the source of the effect determines what offensive #GOLD#combat stat#WHITE# the attacker uses.

Let's experiment to find out more. Move on to learn a new talent. Be sure to read its description!
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed1.lua"
-- 1 entries
t([[Try the new spell on each of the enemies in the next room. Note that it's a spell, so it uses your #LIGHT_GREEN#Spellpower#WHITE#, and it causes a physical effect (bleeding), so the target will defend with its #LIGHT_GREEN#Physical save#WHITE#.

Note in particular the duration of the effect on each enemy. You can check their tooltip to see detrimental effects and their remaining duration.

]], [[Try the new spell on each of the enemies in the next room. Note that it's a spell, so it uses your #LIGHT_GREEN#Spellpower#WHITE#, and it causes a physical effect (bleeding), so the target will defend with its #LIGHT_GREEN#Physical save#WHITE#.

Note in particular the duration of the effect on each enemy. You can check their tooltip to see detrimental effects and their remaining duration.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed2.lua"
-- 1 entries
t([[Under what circumstances do you appear to inflict the full-duration bleed effect?

For those targets that didn't receive the full duration, how did their applicable #GOLD#combat stat#WHITE# compare to yours?

]], [[Under what circumstances do you appear to inflict the full-duration bleed effect?

For those targets that didn't receive the full duration, how did their applicable #GOLD#combat stat#WHITE# compare to yours?

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed3.lua"
-- 1 entries
t([[If you think you can predict how #GOLD#combat stats#WHITE# affect timed effect durations, test your hypothesis on the enemies in the next room.

If you don't know yet, see if this sequence of enemies gets you any closer.

]], [[If you think you can predict how #GOLD#combat stats#WHITE# affect timed effect durations, test your hypothesis on the enemies in the next room.

If you don't know yet, see if this sequence of enemies gets you any closer.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed4.lua"
-- 1 entries
t([[See what the rune in the next room has to teach you! Hopefully you can use it to get past the troublesome elves ahead.
]], [[See what the rune in the next room has to teach you! Hopefully you can use it to get past the troublesome elves ahead.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed5.lua"
-- 1 entries
t([[Ideally, you thought your way through that challenge instead of just using trial-and-error.

Every five points of #LIGHT_GREEN#Physical Save#WHITE#, #LIGHT_GREEN#Spell Save#WHITE#, and #LIGHT_GREEN#Mental Save#WHITE# knocks a turn off the duration of appropriate timed effects.

This is opposed by the attacker's corresponding offensive #GOLD#combat stat#WHITE#. They undo one turn of your duration reduction for every five points of their offensive #GOLD#combat stat#WHITE#.

]], [[Ideally, you thought your way through that challenge instead of just using trial-and-error.

Every five points of #LIGHT_GREEN#Physical Save#WHITE#, #LIGHT_GREEN#Spell Save#WHITE#, and #LIGHT_GREEN#Mental Save#WHITE# knocks a turn off the duration of appropriate timed effects.

This is opposed by the attacker's corresponding offensive #GOLD#combat stat#WHITE#. They undo one turn of your duration reduction for every five points of their offensive #GOLD#combat stat#WHITE#.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed6.lua"
-- 1 entries
t([[This is fairly close to saying that you knock a turn off the duration of timed effects for every five points that your defensive #GOLD#combat stat#WHITE# score beats the attacker's offensive #GOLD#combat stat#WHITE#.

There are some subtle differences, however.

As you may have noticed earlier, your #LIGHT_GREEN#Spellpower#WHITE# of 56 against an orc's #LIGHT_GREEN#Physical save#WHITE# of 70, despite having a difference of only 14, resulted in a three-turn duration decrease. This is because the orc's score of 70 gives it 14 turns of duration reduction, but your score of 56 only undoes 11 of those turns, resulting in a reduction of 3 turns.
]], [[This is fairly close to saying that you knock a turn off the duration of timed effects for every five points that your defensive #GOLD#combat stat#WHITE# score beats the attacker's offensive #GOLD#combat stat#WHITE#.

There are some subtle differences, however.

As you may have noticed earlier, your #LIGHT_GREEN#Spellpower#WHITE# of 56 against an orc's #LIGHT_GREEN#Physical save#WHITE# of 70, despite having a difference of only 14, resulted in a three-turn duration decrease. This is because the orc's score of 70 gives it 14 turns of duration reduction, but your score of 56 only undoes 11 of those turns, resulting in a reduction of 3 turns.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed7.lua"
-- 1 entries
t([[In general, greatly reducing the durations of timed effects requires rather high defensive #GOLD#combat stat#WHITE# scores. The all-important #GOLD#combat stat#WHITE# score difference of ten that we saw earlier usually results in a mere two-turn reduction of timed effect durations. 

If you want to negate timed effects completely, you're going to have to work hard at finding sources of #LIGHT_GREEN#Physical save#WHITE#, #LIGHT_GREEN#Spell save#WHITE#, and 
#LIGHT_GREEN#Mental save#WHITE#.

]], [[In general, greatly reducing the durations of timed effects requires rather high defensive #GOLD#combat stat#WHITE# scores. The all-important #GOLD#combat stat#WHITE# score difference of ten that we saw earlier usually results in a mere two-turn reduction of timed effect durations. 

If you want to negate timed effects completely, you're going to have to work hard at finding sources of #LIGHT_GREEN#Physical save#WHITE#, #LIGHT_GREEN#Spell save#WHITE#, and 
#LIGHT_GREEN#Mental save#WHITE#.

]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats-timed/timed8.lua"
-- 1 entries
t([[Descend to the final level of the #GOLD#Dungeon of Adventurer Enlightenment#WHITE# to discover more about #GOLD#combat stat#WHITE# tiers, and how they're not just cosmetic.
]], [[Descend to the final level of the #GOLD#Dungeon of Adventurer Enlightenment#WHITE# to discover more about #GOLD#combat stat#WHITE# tiers, and how they're not just cosmetic.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/tutorial/stats/mechintro.lua"
-- 1 entries
t([[ToME 4 is a large, complex game. Despite this, the most important mechanics-- the ones that directly influence the decisions you need to make as a player-- are governed by relatively simple rules. This mechanics guide will provide a brief introduction to these rules.
]], [[ToME 4 is a large, complex game. Despite this, the most important mechanics-- the ones that directly influence the decisions you need to make as a player-- are governed by relatively simple rules. This mechanics guide will provide a brief introduction to these rules.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/texts/unlock-paladin_fallen.lua"
-- 1 entries
t([[#{bold}##GOLD#You aren't so different...#LAST##{normal}#

As a sun paladin, you follow a code.  But with the darkness you've seen in the world, you've started to doubt.

You have unlocked the #LIGHT_GREEN#Fallen class evolution#WHITE# for Sun Paladins.

Learn new Talents:#YELLOW#
- Bloodstained: Make your foes bleed!
- Darkside: Every light casts a shadow, yours is powerful indeed
- Hatred: Manifest your hatred through bleeding
- Dirges: Sing of death and sorrow to strength your resolve#WHITE#

Swap your paladin Talents:#YELLOW#
- Radiance turns into Gloom: Project onto others your own hate, hindering them
- Crusader turns into Dark Sun: Call upon the energies of dead suns to crush your foes
- Guardian turns into Crimson Templar: Use the power of blood to control and defeat the fools that oppose you
#WHITE#

Class evolutions are selected as prodigies and grant new ways to build and expand your class. They are only visible to the concerned class.
]], [[#{bold}##GOLD#You aren't so different...#LAST##{normal}#

As a sun paladin, you follow a code.  But with the darkness you've seen in the world, you've started to doubt.

You have unlocked the #LIGHT_GREEN#Fallen class evolution#WHITE# for Sun Paladins.

Learn new Talents:#YELLOW#
- Bloodstained: Make your foes bleed!
- Darkside: Every light casts a shadow, yours is powerful indeed
- Hatred: Manifest your hatred through bleeding
- Dirges: Sing of death and sorrow to strength your resolve#WHITE#

Swap your paladin Talents:#YELLOW#
- Radiance turns into Gloom: Project onto others your own hate, hindering them
- Crusader turns into Dark Sun: Call upon the energies of dead suns to crush your foes
- Guardian turns into Crimson Templar: Use the power of blood to control and defeat the fools that oppose you
#WHITE#

Class evolutions are selected as prodigies and grant new ways to build and expand your class. They are only visible to the concerned class.
]], "_t")


------------------------------------------------
section "game/modules/tome/data/timed_effects/magical.lua"
-- 2 entries
t("%d%%", "%d%%", "tformat")
t("#Target# summons a corpselight!", "#Target# summons a corpselight!", "_t")


------------------------------------------------
section "game/modules/tome/data/timed_effects/mental.lua"
-- 3 entries
t("#ORANGE#", "#ORANGE#", "_t")
t("#LIGHT_GREEN#", "#LIGHT_GREEN#", "_t")
t("%s", "%s", "tformat")


------------------------------------------------
section "game/modules/tome/data/timed_effects/other.lua"
-- 9 entries
t("was smeared across all space and time", "was smeared across all space and time", "_t")
t("\
- %s%s#LAST#", "\
- %s%s#LAST#", "tformat")
t("\
- #ffa0ff#%s#LAST#", "\
- #ffa0ff#%s#LAST#", "tformat")
t("burnt to death by cauterize", "burnt to death by cauterize", "_t")
t("killed in a dream", "killed in a dream", "_t")
t("%s%d %s#LAST#", "%s%d %s#LAST#", "tformat")
t("???", "???", "_t")
t("failed to complete the lich ressurection ritual", "failed to complete the lich ressurection ritual", "_t")
t("died a well-deserved death by exsanguination", "died a well-deserved death by exsanguination", "_t")


------------------------------------------------
section "game/modules/tome/data/timed_effects/physical.lua"
-- 1 entries
t("%0.1f%%", "%0.1f%%", "tformat")


------------------------------------------------
section "game/modules/tome/data/zones/test/mapscripts/rooms_test.lua"
-- 1 entries
t("!!! %d", "!!! %d", "log")


------------------------------------------------
section "game/modules/tome/data/zones/test/mapscripts/rooms_test2.lua"
-- 1 entries
t("!!! %d + %d", "!!! %d + %d", "log")


------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/grids.lua"
-- 31 entries
t("Lobby Portal", "Lobby Portal", "entity name")
t("This portal will bring you back to the Tutorial Lobby.", "This portal will bring you back to the Tutorial Lobby.", "_t")
t("Enter the portal back to the lobby?", "Enter the portal back to the lobby?", "_t")
t("Tutorial Lobby Portal", "Tutorial Lobby Portal", "_t")
t("#VIOLET#You enter the swirling portal and in the blink of an eye you are back in the lobby.", "#VIOLET#You enter the swirling portal and in the blink of an eye you are back in the lobby.", "logPlayer")
t("Rune of Enlightenment: Summer Vacation", "Rune of Enlightenment: Summer Vacation", "entity name")
t("Causes the player's brain to jettison all recently-acquired knowledge.", "Causes the player's brain to jettison all recently-acquired knowledge.", "_t")
t("#VIOLET#You feel unenlightened.", "#VIOLET#You feel unenlightened.", "logPlayer")
t("#VIOLET#The sound of an ancient door grinding open echoes down the tunnel!", "#VIOLET#The sound of an ancient door grinding open echoes down the tunnel!", "logPlayer")
t("Rune of Enlightenment: Mana Gale", "Rune of Enlightenment: Mana Gale", "entity name")
t("Teaches the player 'Mana Gale'.", "Teaches the player 'Mana Gale'.", "_t")
t("#VIOLET#You have learned the talent Mana Gale.", "#VIOLET#You have learned the talent Mana Gale.", "logPlayer")
t("Rune of Enlightenment: Telekinetic Punt", "Rune of Enlightenment: Telekinetic Punt", "entity name")
t("Teaches the player 'Telekinetic Punt'.", "Teaches the player 'Telekinetic Punt'.", "_t")
t("#VIOLET#You have learned the talent Telekinetic Punt.", "#VIOLET#You have learned the talent Telekinetic Punt.", "logPlayer")
t("Rune of Enlightenment: Blink", "Rune of Enlightenment: Blink", "entity name")
t("Teaches the player 'Blink'.", "Teaches the player 'Blink'.", "_t")
t("#VIOLET#You have learned the talent Blink.", "#VIOLET#You have learned the talent Blink.", "logPlayer")
t("Rune of Enlightenment: Fear", "Rune of Enlightenment: Fear", "entity name")
t("Teaches the player 'Fear'.", "Teaches the player 'Fear'.", "_t")
t("#VIOLET#You have learned the talent Fear.", "#VIOLET#You have learned the talent Fear.", "logPlayer")
t("Rune of Enlightenment: Bleed", "Rune of Enlightenment: Bleed", "entity name")
t("Teaches the player 'Bleed'.", "Teaches the player 'Bleed'.", "_t")
t("#VIOLET#You have learned the talent Bleed.", "#VIOLET#You have learned the talent Bleed.", "logPlayer")
t("Rune of Enlightenment: Confusion", "Rune of Enlightenment: Confusion", "entity name")
t("Teaches the player 'Confusion'.", "Teaches the player 'Confusion'.", "_t")
t("#VIOLET#You have learned the talent Confusion.", "#VIOLET#You have learned the talent Confusion.", "logPlayer")
t("glowing door", "glowing door", "entity name")
t("#VIOLET#You must achieve Enlightenment before you can pass. Seek ye to the west to discover the ancient art of Shoving Stuff.", "#VIOLET#You must achieve Enlightenment before you can pass. Seek ye to the west to discover the ancient art of Shoving Stuff.", "logPlayer")
t("Sign", "Sign", "entity name")
t("Contains a snippet of ToME wisdom.", "Contains a snippet of ToME wisdom.", "_t")


------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/npcs.lua"
-- 27 entries
t("Nain the Guide", "Nain the Guide", "entity name")
t("A pitchfork-wielding human with a welcoming smile.", "A pitchfork-wielding human with a welcoming smile.", "_t")
t("Quick-healing orc", "Quick-healing orc", "entity name")
t("Robe-clad elf", "Robe-clad elf", "entity name")
t("An elf that looks as though he spends a good amount of his time wiggling his fingers and chanting.", "An elf that looks as though he spends a good amount of his time wiggling his fingers and chanting.", "_t")
t("Stubborn orc", "Stubborn orc", "entity name")
t("Obstinate orc", "Obstinate orc", "entity name")
t("Pushy orc", "Pushy orc", "entity name")
t("Rude orc", "Rude orc", "entity name")
t("Troll", "Troll", "entity name")
t("Ugly troll", "Ugly troll", "entity name")
t("Gross troll", "Gross troll", "entity name")
t("Ghastly troll", "Ghastly troll", "entity name")
t("Forum troll", "Forum troll", "entity name")
t("Pushy elf", "Pushy elf", "entity name")
t("Blustering elf", "Blustering elf", "entity name")
t("Breezy elf", "Breezy elf", "entity name")
t("A huge arachnid.", "A huge arachnid.", "_t")
t("chittering spider", "chittering spider", "entity name")
t("A huge, chittering arachnid.", "A huge, chittering arachnid.", "_t")
t("hairy spider", "hairy spider", "entity name")
t("A huge, hairy arachnid.", "A huge, hairy arachnid.", "_t")
t("Bored elf", "Bored elf", "entity name")
t("Idle elf", "Idle elf", "entity name")
t("Loitering elf", "Loitering elf", "entity name")
t("Dull-eyed orc", "Dull-eyed orc", "entity name")
t("Keen-eyed orc", "Keen-eyed orc", "entity name")


------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/objects.lua"
-- 12 entries
t("Boots of Physical Save (+10)", "Boots of Physical Save (+10)", "entity name")
t("Dried-up old boots.", "Dried-up old boots.", "_t")
t("Fine boots that increase your Physical Save by 10.", "Fine boots that increase your Physical Save by 10.", "_t")
t("Amulet of Mindpower (+3)", "Amulet of Mindpower (+3)", "entity name")
t("Glittering amulet.", "Glittering amulet.", "_t")
t("A beautiful amulet that increases your Mindpower by 3.", "A beautiful amulet that increases your Mindpower by 3.", "_t")
t("Helmet of Accuracy (+6)", "Helmet of Accuracy (+6)", "entity name")
t("Hard-looking helmet.", "Hard-looking helmet.", "_t")
t("A finely-wrought helmet that increases your Accuracy by 6.", "A finely-wrought helmet that increases your Accuracy by 6.", "_t")
t("Ring of Mental Save (+6)", "Ring of Mental Save (+6)", "entity name")
t("Smooth ring.", "Smooth ring.", "_t")
t("A ruby-studded ring.", "A ruby-studded ring.", "_t")


------------------------------------------------
section "game/modules/tome/data/zones/tutorial-combat-stats/traps.lua"
-- 14 entries
t("tutorial2", "tutorial2", "entity subtype")
t("tutorial3", "tutorial3", "entity subtype")
t("tutorial4", "tutorial4", "entity subtype")
t("tutorial5", "tutorial5", "entity subtype")
t("tutorial6", "tutorial6", "entity subtype")
t("Mechanics tutorial", "Mechanics tutorial", "entity name")
t("Mechanics Tutorial", "Mechanics Tutorial", "entity name")
t("Combat Stats", "Combat Stats", "entity name")
t("Combat Stat Tooltips", "Combat Stat Tooltips", "entity name")
t("Combat Stat Scale", "Combat Stat Scale", "entity name")
t("Combat Stat Calculations", "Combat Stat Calculations", "entity name")
t("Timed Effects", "Timed Effects", "entity name")
t("Dungeon of Adventurer Enlightenment Completed", "Dungeon of Adventurer Enlightenment Completed", "entity name")
t("Cross-Tier Effects", "Cross-Tier Effects", "entity name")


------------------------------------------------
section "game/modules/tome/dialogs/CharacterSheet.lua"
-- 7 entries
t("%i %s %i %s %i %s %s %s", "%i %s %i %s %i %s %s %s", "tformat")
t("%i %s %i %s %s %s", "%i %s %i %s %s %s", "tformat")
t("%i %s %s %s", "%i %s %s %s", "tformat")
t("%s %s", "%s %s", "tformat")
t("%s%-8.8s: #00ff00#%s ", "%s%-8.8s: #00ff00#%s ", "tformat")
t("vs ", "vs ", "_t")
t("#ORANGE#vs %-11s#LAST#: #00ff00#%3s %s", "#ORANGE#vs %-11s#LAST#: #00ff00#%3s %s", "tformat")


------------------------------------------------
section "game/modules/tome/dialogs/GameOptions.lua"
-- 1 entries
t("UI", "UI", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/GraphicMode.lua"
-- 7 entries
t("ASCII", "ASCII", "_t")
t("ASCII with background", "ASCII with background", "_t")
t("Altefcat/Gervais", "Altefcat/Gervais", "_t")
t("64x64", "64x64", "_t")
t("48x48", "48x48", "_t")
t("32x32", "32x32", "_t")
t("16x16", "16x16", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/LevelupDialog.lua"
-- 4 entries
t("#LIGHT_RED#Requirements for %s not met, prodigy not learnt.", "#LIGHT_RED#Requirements for %s not met, prodigy not learnt.", "log")
t("<Press 'x' to swap to simple display>", "<Press 'x' to swap to simple display>", "_t")
t(" (%+0.1f bonus level)", " (%+0.1f bonus level)", "tformat")
t("<Press 'x' to swap to advanced display>", "<Press 'x' to swap to advanced display>", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/MapMenu.lua"
-- 3 entries
t("Control", "Control", "_t")
t("Target player", "Target player", "_t")
t(" ", " ", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/ShowChatLog.lua"
-- 1 entries
t("#VIOLET#", "#VIOLET#", "log")


------------------------------------------------
section "game/modules/tome/dialogs/ShowLore.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/ShowStore.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/SwiftHands.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/SwiftHandsUse.lua"
-- 3 entries
t("", "", "_t")
t("%d/%d", "%d/%d", "tformat")
t("#RED#%d/%d", "#RED#%d/%d", "tformat")


------------------------------------------------
section "game/modules/tome/dialogs/TrapsSelect.lua"
-- 2 entries
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")
t(" (%s)", " (%s)", "tformat")


------------------------------------------------
section "game/modules/tome/dialogs/UberTalent.lua"
-- 2 entries
t("#{bold}##GOLD#Prodigies#{normal}#", "#{bold}##GOLD#Prodigies#{normal}#", "_t")
t("#{bold}##LIGHT_STEEL_BLUE#Evolutions#{normal}#", "#{bold}##LIGHT_STEEL_BLUE#Evolutions#{normal}#", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/UseTalents.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceActor.lua"
-- 28 entries
t("DEBUG -- Levelup Actor: [%s] %s", "DEBUG -- Levelup Actor: [%s] %s", "tformat")
t([[Levelup an actor.
Optionally set Stat levels, learn all talents possible, and gain points to spend on Levelup. 
The actor is backed up before changes are made.  (Use the "Restore" button to recover.)
]], [[Levelup an actor.
Optionally set Stat levels, learn all talents possible, and gain points to spend on Levelup. 
The actor is backed up before changes are made.  (Use the "Restore" button to recover.)
]], "_t")
t(" Advance to Level: ", " Advance to Level: ", "_t")
t("Restore: %s (v%d)", "Restore: %s (v%d)", "tformat")
t("Restore: none", "Restore: none", "_t")
t("#LIGHT_BLUE#Restoring [%s]%s from backup version %d", "#LIGHT_BLUE#Restoring [%s]%s from backup version %d", "log")
t("Gain points for stats, talents, and prodigies (unlimited respec)", "Gain points for stats, talents, and prodigies (unlimited respec)", "_t")
t(" Force all BASE stats to: ", " Force all BASE stats to: ", "_t")
t("", "", "_t")
t(" Force all BONUS stats to: ", " Force all BONUS stats to: ", "_t")
t("Learn Talents ", "Learn Talents ", "_t")
t("Unlock & Learn all available talents to level: ", "Unlock & Learn all available talents to level: ", "_t")
t("maximum allowed", "maximum allowed", "_t")
t("Ignore requirements", "Ignore requirements", "_t")
t("Force all talent mastery levels to (0.1-5.0): ", "Force all talent mastery levels to (0.1-5.0): ", "_t")
t("no change", "no change", "_t")
t("Unlock all talent types (slow)", "Unlock all talent types (slow)", "_t")
t("#LIGHT_BLUE#AdvanceActor inputs: %s", "#LIGHT_BLUE#AdvanceActor inputs: %s", "log")
t("%s #GOLD#Forcing all Base Stats to %s", "%s #GOLD#Forcing all Base Stats to %s", "log")
t("%s #GOLD#Resetting all talents_types_mastery to %s", "%s #GOLD#Resetting all talents_types_mastery to %s", "log")
t("%s #GOLD#Unlocking All Talent Types", "%s #GOLD#Unlocking All Talent Types", "log")
t("#LIGHT_BLUE#%s -- %s", "#LIGHT_BLUE#%s -- %s", "log")
t("#GOLD#Checking %s Talents (%s)", "#GOLD#Checking %s Talents (%s)", "log")
t("#LIGHT_BLUE#Talent %s learned to level %d", "#LIGHT_BLUE#Talent %s learned to level %d", "log")
t("%s #GOLD#Forcing all Bonus Stats to %s", "%s #GOLD#Forcing all Bonus Stats to %s", "log")
t("#ORCHID#%d prodigy point(s)#LAST#", "#ORCHID#%d prodigy point(s)#LAST#", "tformat")
t("#LIGHT_BLUE#%s has %s to spend", "#LIGHT_BLUE#%s has %s to spend", "log")
t(", and ", ", and ", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/AdvanceZones.lua"
-- 7 entries
t("Advance Through Zones", "Advance Through Zones", "_t")
t("Enter a comma delimited list of zones or zone tiers to clear", "Enter a comma delimited list of zones or zone tiers to clear", "_t")
t("%s:  Level %0.2f to %0.2f (#LIGHT_STEEL_BLUE#+%0.2f#LAST#)", "%s:  Level %0.2f to %0.2f (#LIGHT_STEEL_BLUE#+%0.2f#LAST#)", "tformat")
t("#RED#Low value items have been dropped on the ground.#LAST#", "#RED#Low value items have been dropped on the ground.#LAST#", "log")
t("Unable to level change to floor 1 of %s", "Unable to level change to floor 1 of %s", "log")
t("%s is not valid for autoclear", "%s is not valid for autoclear", "log")
t("Unable to level change to floor %d of %s", "Unable to level change to floor %d of %s", "log")


------------------------------------------------
section "game/modules/tome/dialogs/debug/AlterFaction.lua"
-- 3 entries
t("DEBUG -- Alter Faction", "DEBUG -- Alter Faction", "_t")
t("Alter to which state:", "Alter to which state:", "_t")
t("Alter: %s", "Alter: %s", "tformat")


------------------------------------------------
section "game/modules/tome/dialogs/debug/ChangeZone.lua"
-- 3 entries
t("DEBUG -- Change Zone", "DEBUG -- Change Zone", "_t")
t("Level %s-%s", "Level %s-%s", "tformat")
t("Zone: %s", "Zone: %s", "tformat")


------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateItem.lua"
-- 32 entries
t("DEBUG -- Create Object", "DEBUG -- Create Object", "_t")
t("Load from other zones ", "Load from other zones ", "_t")
t([[#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#
 %s]], [[#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#
 %s]], "log")
t("Generate examples (right-click refreshes) ", "Generate examples (right-click refreshes) ", "_t")
t("#CRIMSON#==Resolved Example==#LAST#", "#CRIMSON#==Resolved Example==#LAST#", "_t")
t([[#LIGHT_BLUE#Object %s could not be generated or identified. Error:
%s]], [[#LIGHT_BLUE#Object %s could not be generated or identified. Error:
%s]], "log")
t("#GOLD#%s#LAST#", "#GOLD#%s#LAST#", "tformat")
t([[Error:
%s]], [[Error:
%s]], "tformat")
t("Object could not be resolved/identified.", "Object could not be resolved/identified.", "_t")
t("#LIGHT_BLUE#Could not add object to %s at (%d, %d)", "#LIGHT_BLUE#Could not add object to %s at (%d, %d)", "log")
t("#LIGHT_BLUE#No creature to add object to at (%d, %d)", "#LIGHT_BLUE#No creature to add object to at (%d, %d)", "log")
t("#LIGHT_BLUE#No object to create", "#LIGHT_BLUE#No object to create", "log")
t("Place Object", "Place Object", "_t")
t("Place the object where?", "Place the object where?", "_t")
t("Inventory of %s%s", "Inventory of %s%s", "tformat")
t(" #LIGHT_GREEN#(player)#LAST#", " #LIGHT_GREEN#(player)#LAST#", "_t")
t("Drop @ (%s, %s)%s", "Drop @ (%s, %s)%s", "tformat")
t("#LIGHT_BLUE#Dropped %s at (%d, %d)", "#LIGHT_BLUE#Dropped %s at (%d, %d)", "log")
t("#LIGHT_BLUE#OBJECT:#LAST# %s%s: #LIGHT_BLUE#[%s] %s {%s, slot %s} at (%s, %s)#LAST#", "#LIGHT_BLUE#OBJECT:#LAST# %s%s: #LIGHT_BLUE#[%s] %s {%s, slot %s} at (%s, %s)#LAST#", "log")
t(", or 0 for the example item", ", or 0 for the example item", "_t")
t("Enter 1-100%s", "Enter 1-100%s", "tformat")
t("Number of items to make", "Number of items to make", "_t")
t("#LIGHT_BLUE# Creating %d items:", "#LIGHT_BLUE# Creating %d items:", "log")
t("Add an ego enhancement if possible?", "Add an ego enhancement if possible?", "_t")
t("Ego", "Ego", "_t")
t("Add a greater ego enhancement if possible?", "Add a greater ego enhancement if possible?", "_t")
t("Greater Ego", "Greater Ego", "_t")
t("#LIGHT_BLUE#Created %s", "#LIGHT_BLUE#Created %s", "log")
t(" #GOLD#All Artifacts#LAST#", " #GOLD#All Artifacts#LAST#", "_t")
t("#LIGHT_BLUE#Creating All Artifacts.", "#LIGHT_BLUE#Creating All Artifacts.", "log")
t("#LIGHT_BLUE#%d artifacts created.", "#LIGHT_BLUE#%d artifacts created.", "log")
t(" #YELLOW#Random Object#LAST#", " #YELLOW#Random Object#LAST#", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/CreateTrap.lua"
-- 3 entries
t("DEBUG -- Create Trap", "DEBUG -- Create Trap", "_t")
t("#LIGHT_BLUE#Trap [%s]%s already occupies (%d, %d)", "#LIGHT_BLUE#Trap [%s]%s already occupies (%d, %d)", "log")
t("#LIGHT_BLUE#Added %s[%s]%s at (%d, %d)", "#LIGHT_BLUE#Added %s[%s]%s at (%d, %d)", "log")


------------------------------------------------
section "game/modules/tome/dialogs/debug/DebugMain.lua"
-- 33 entries
t("Debug/Cheat! It's BADDDD!", "Debug/Cheat! It's BADDDD!", "_t")
t("#LIGHT_BLUE#God mode OFF", "#LIGHT_BLUE#God mode OFF", "log")
t("#LIGHT_BLUE#God mode ON", "#LIGHT_BLUE#God mode ON", "log")
t("#LIGHT_BLUE#Demi-God mode OFF", "#LIGHT_BLUE#Demi-God mode OFF", "log")
t("#LIGHT_BLUE#Demi-God mode ON", "#LIGHT_BLUE#Demi-God mode ON", "log")
t("#LIGHT_BLUE#Revealing Map.", "#LIGHT_BLUE#Revealing Map.", "log")
t("Level 1-%s", "Level 1-%s", "tformat")
t("Zone: %s", "Zone: %s", "tformat")
t("Kill or Remove", "Kill or Remove", "_t")
t("Remove all (non-party) creatures or kill them for the player (awards experience and drops loot)?", "Remove all (non-party) creatures or kill them for the player (awards experience and drops loot)?", "_t")
t("#GREY#Removing [%s] %s at (%s, %s)", "#GREY#Removing [%s] %s at (%s, %s)", "log")
t("#GREY#Killing [%s] %s at (%s, %s)", "#GREY#Killing [%s] %s at (%s, %s)", "log")
t("#LIGHT_BLUE#%s %d creatures.", "#LIGHT_BLUE#%s %d creatures.", "log")
t("Killed", "Killed", "_t")
t("Removed", "Removed", "_t")
t("Kill", "Kill", "_t")
t("Remove", "Remove", "_t")
t("Reveal all map", "Reveal all map", "_t")
t("Toggle Demi-Godmode", "Toggle Demi-Godmode", "_t")
t("Toggle Godmode", "Toggle Godmode", "_t")
t("Alter Faction", "Alter Faction", "_t")
t("Summon a Creature", "Summon a Creature", "_t")
t("Create Items", "Create Items", "_t")
t("Create a Trap", "Create a Trap", "_t")
t("Grant/Alter Quests", "Grant/Alter Quests", "_t")
t("Advance Player", "Advance Player", "_t")
t("Remove or Kill all creatures", "Remove or Kill all creatures", "_t")
t("Give Sher'tul fortress energy", "Give Sher'tul fortress energy", "_t")
t("Give all ingredients", "Give all ingredients", "_t")
t("Weakdamage", "Weakdamage", "_t")
t("Spawn Event", "Spawn Event", "_t")
t("Endgamify", "Endgamify", "_t")
t("Automatically Clear Zones", "Automatically Clear Zones", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/Endgamify.lua"
-- 2 entries
t([[#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#
 %s]], [[#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#
 %s]], "log")
t("Failed to generate %s", "Failed to generate %s", "log")


------------------------------------------------
section "game/modules/tome/dialogs/debug/GrantQuest.lua"
-- 1 entries
t("Debug -- Grant/Alter Quest", "Debug -- Grant/Alter Quest", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/PlotTalent.lua"
-- 2 entries
t("Values plot for: %s (mastery %0.1f)", "Values plot for: %s (mastery %0.1f)", "tformat")
t("TL: ", "TL: ", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/RandomActor.lua"
-- 30 entries
t("#LIGHT_GREEN#(From %s, line %s):#LAST#", "#LIGHT_GREEN#(From %s, line %s):#LAST#", "tformat")
t("DEBUG -- Create Random Actor", "DEBUG -- Create Random Actor", "_t")
t([[Randomly generate actors subject to a filter and/or create random bosses according to a data table.
Filters are interpreted by game.zone:checkFilter.
#ORANGE#Boss Data:#LAST# is interpreted by game.state:createRandomBoss, game.state:applyRandomClass, and Actor.levelupClass.
Generation is performed within the _G environment (used by the Lua Console) using the current zone's #LIGHT_GREEN#npc_list#LAST#.
Press #GOLD#'F1'#LAST# for help.
Mouse over controls for an actor preview (which may be further adjusted when placed on to the level).
(Press #GOLD#'L'#LAST# to lua inspect or #GOLD#'C'#LAST# to open the character sheet.)

The #LIGHT_BLUE#Base Filter#LAST# is used to filter the actor randomly generated.]], [[Randomly generate actors subject to a filter and/or create random bosses according to a data table.
Filters are interpreted by game.zone:checkFilter.
#ORANGE#Boss Data:#LAST# is interpreted by game.state:createRandomBoss, game.state:applyRandomClass, and Actor.levelupClass.
Generation is performed within the _G environment (used by the Lua Console) using the current zone's #LIGHT_GREEN#npc_list#LAST#.
Press #GOLD#'F1'#LAST# for help.
Mouse over controls for an actor preview (which may be further adjusted when placed on to the level).
(Press #GOLD#'L'#LAST# to lua inspect or #GOLD#'C'#LAST# to open the character sheet.)

The #LIGHT_BLUE#Base Filter#LAST# is used to filter the actor randomly generated.]], "_t")
t("Current Base Actor: %s", "Current Base Actor: %s", "tformat")
t("#LIGHT_BLUE# Current base actor: %s", "#LIGHT_BLUE# Current base actor: %s", "log")
t("Default Filter", "Default Filter", "_t")
t("#LIGHT_BLUE# Reset base filter", "#LIGHT_BLUE# Reset base filter", "log")
t("Clear", "Clear", "_t")
t("#LIGHT_BLUE# Clear base actor: %s", "#LIGHT_BLUE# Clear base actor: %s", "log")
t("#LIGHT_BLUE#Base Filter:#LAST# ", "#LIGHT_BLUE#Base Filter:#LAST# ", "_t")
t("The #ORANGE#Boss Data#LAST# is used to transform the base actor into a random boss (which will use a random actor if needed).", "The #ORANGE#Boss Data#LAST# is used to transform the base actor into a random boss (which will use a random actor if needed).", "_t")
t("#GREY#None#LAST#", "#GREY#None#LAST#", "_t")
t("Current Boss Actor: %s", "Current Boss Actor: %s", "tformat")
t("Generate", "Generate", "_t")
t("Default Data", "Default Data", "_t")
t("#LIGHT_BLUE# Reset Randboss Data", "#LIGHT_BLUE# Reset Randboss Data", "log")
t("Place", "Place", "_t")
t("#ORANGE#Boss Data:#LAST# ", "#ORANGE#Boss Data:#LAST# ", "_t")
t("Filter and Data Help", "Filter and Data Help", "_t")
t("#GREY#No Actor to Display#LAST#", "#GREY#No Actor to Display#LAST#", "_t")
t("#LIGHT_BLUE#Inspect [%s]%s", "#LIGHT_BLUE#Inspect [%s]%s", "log")
t("#LIGHT_BLUE#No actor to inspect", "#LIGHT_BLUE#No actor to inspect", "log")
t("#LIGHT_BLUE#Lua Inspect [%s]%s", "#LIGHT_BLUE#Lua Inspect [%s]%s", "log")
t("#LIGHT_BLUE#No actor to Lua inspect", "#LIGHT_BLUE#No actor to Lua inspect", "log")
t("#LIGHT_BLUE#Bad filter for base actor: %s", "#LIGHT_BLUE#Bad filter for base actor: %s", "log")
t("#LIGHT_BLUE#Could not generate a base actor with filter: %s", "#LIGHT_BLUE#Could not generate a base actor with filter: %s", "log")
t([[#LIGHT_BLUE#Base actor could not be generated with filter [%s].
 Error:%s]], [[#LIGHT_BLUE#Base actor could not be generated with filter [%s].
 Error:%s]], "log")
t("#LIGHT_BLUE#Bad data for random boss actor: %s", "#LIGHT_BLUE#Bad data for random boss actor: %s", "log")
t("#LIGHT_BLUE#Could not generate a base actor with data: %s", "#LIGHT_BLUE#Could not generate a base actor with data: %s", "log")
t([[#LIGHT_BLUE#ERROR: Random Boss could not be generated with data [%s].
 Error:%s]], [[#LIGHT_BLUE#ERROR: Random Boss could not be generated with data [%s].
 Error:%s]], "log")


------------------------------------------------
section "game/modules/tome/dialogs/debug/RandomObject.lua"
-- 58 entries
t("#LIGHT_GREEN#(From %-10.60s, line: %s):#LAST#", "#LIGHT_GREEN#(From %-10.60s, line: %s):#LAST#", "tformat")
t("Don't apply a resolver", "Don't apply a resolver", "_t")
t("Object will be equipped if possible, otherwise added to main inventory", "Object will be equipped if possible, otherwise added to main inventory", "_t")
t("Object added to main inventory", "Object added to main inventory", "_t")
t("Drops", "Drops", "_t")
t("Object added to main inventory (dropped on death)", "Object added to main inventory (dropped on death)", "_t")
t("Attach Tinker", "Attach Tinker", "_t")
t("Tinker will be attached to a worn object", "Tinker will be attached to a worn object", "_t")
t("Drop Randart (auto data)", "Drop Randart (auto data)", "_t")
t("Random Artifact (dropped on death) added to main inventory, uses the Base Object or Base Filter plus Randart Data as input", "Random Artifact (dropped on death) added to main inventory, uses the Base Object or Base Filter plus Randart Data as input", "_t")
t("Drop Randart", "Drop Randart", "_t")
t("Random Artifact (dropped on death) added to main inventory", "Random Artifact (dropped on death) added to main inventory", "_t")
t("DEBUG -- Create Random Object", "DEBUG -- Create Random Object", "_t")
t([[Generate objects randomly subject to filters and create Random Artifacts.
Use "Generate" to create objects for preview and inspection.
Use "Add Object" to choose where to put the object and add it to the game.
(Mouse over controls for a preview of the generated object/working Actor. (Press #GOLD#'L'#LAST# to lua inspect.)
#SALMON#Resolvers#LAST# act on the working actor (default: player) to generate a SINGLE object.
They use the #LIGHT_GREEN#Random filter#LAST# as input unless noted otherwise and control object destination.
Filters are interpreted by ToME and engine entity/object generation functions (game.zone:checkFilter, etc.).
Interpretation of tables is within the _G environment (used by the Lua Console) using the current zone's #YELLOW_GREEN#object_list#LAST#.
Hotkeys: #GOLD#'F1'#LAST# :: context sensitive help, #GOLD#'C'#LAST# :: Working Character Sheet, #GOLD#'I'#LAST# :: Working Character Inventory.
]], [[Generate objects randomly subject to filters and create Random Artifacts.
Use "Generate" to create objects for preview and inspection.
Use "Add Object" to choose where to put the object and add it to the game.
(Mouse over controls for a preview of the generated object/working Actor. (Press #GOLD#'L'#LAST# to lua inspect.)
#SALMON#Resolvers#LAST# act on the working actor (default: player) to generate a SINGLE object.
They use the #LIGHT_GREEN#Random filter#LAST# as input unless noted otherwise and control object destination.
Filters are interpreted by ToME and engine entity/object generation functions (game.zone:checkFilter, etc.).
Interpretation of tables is within the _G environment (used by the Lua Console) using the current zone's #YELLOW_GREEN#object_list#LAST#.
Hotkeys: #GOLD#'F1'#LAST# :: context sensitive help, #GOLD#'C'#LAST# :: Working Character Sheet, #GOLD#'I'#LAST# :: Working Character Inventory.
]], "_t")
t("The #LIGHT_GREEN#Random Filter#LAST# controls random generation of a normal object.", "The #LIGHT_GREEN#Random Filter#LAST# controls random generation of a normal object.", "tformat")
t("#GREY#None#LAST#", "#GREY#None#LAST#", "_t")
t("%s: %s", "%s: %s", "tformat")
t("#LIGHT_GREEN#Random Object#LAST#", "#LIGHT_GREEN#Random Object#LAST#", "_t")
t("#LIGHT_GREEN#Random Filter:#LAST# ", "#LIGHT_GREEN#Random Filter:#LAST# ", "_t")
t("The #LIGHT_BLUE#Base Filter#LAST# is to generate a base object for building a Randart.", "The #LIGHT_BLUE#Base Filter#LAST# is to generate a base object for building a Randart.", "tformat")
t("#LIGHT_BLUE#Base Object#LAST#", "#LIGHT_BLUE#Base Object#LAST#", "_t")
t("Default Filter", "Default Filter", "_t")
t("Clear Object", "Clear Object", "_t")
t("#LIGHT_BLUE#Base Filter:#LAST# ", "#LIGHT_BLUE#Base Filter:#LAST# ", "_t")
t("#SALMON#Resolver selected:#LAST# ", "#SALMON#Resolver selected:#LAST# ", "tformat")
t("An object resolver interprets additional filter fields to generate an object and determine where it will go.", "An object resolver interprets additional filter fields to generate an object and determine where it will go.", "_t")
t("Dropdown text", "Dropdown text", "_t")
t("No Tooltip", "No Tooltip", "_t")
t("Use this selector to choose which resolver to use", "Use this selector to choose which resolver to use", "_t")
t([[#ORANGE#Randart Data#LAST# contains parameters used to generate a Randart (interpreted by game.state:generateRandart).
The #LIGHT_BLUE#Base Object#LAST# will be used if possible.]], [[#ORANGE#Randart Data#LAST# contains parameters used to generate a Randart (interpreted by game.state:generateRandart).
The #LIGHT_BLUE#Base Object#LAST# will be used if possible.]], "tformat")
t("Generate", "Generate", "_t")
t("Add Object", "Add Object", "_t")
t("Default Data", "Default Data", "_t")
t("#ORANGE#Randart Data:#LAST# ", "#ORANGE#Randart Data:#LAST# ", "_t")
t("#ORANGE#Randart#LAST#", "#ORANGE#Randart#LAST#", "_t")
t("Show #GOLD#I#LAST#nventory", "Show #GOLD#I#LAST#nventory", "_t")
t("Show #GOLD#C#LAST#haracter Sheet", "Show #GOLD#C#LAST#haracter Sheet", "_t")
t("Set working actor: [%s] %s", "Set working actor: [%s] %s", "tformat")
t(" #LIGHT_GREEN#(player)#LAST#", " #LIGHT_GREEN#(player)#LAST#", "_t")
t("Set working actor: [%s] %s%s", "Set working actor: [%s] %s%s", "tformat")
t("#GREY#No Tooltip to Display#LAST#", "#GREY#No Tooltip to Display#LAST#", "_t")
t("Filter/Data/Resolver Reference", "Filter/Data/Resolver Reference", "_t")
t("#LIGHT_BLUE#Lua Inspect [%s] %s", "#LIGHT_BLUE#Lua Inspect [%s] %s", "log")
t("#LIGHT_BLUE#Nothing to Lua inspect", "#LIGHT_BLUE#Nothing to Lua inspect", "log")
t("#LIGHT_BLUE#Bad %s: %s", "#LIGHT_BLUE#Bad %s: %s", "log")
t("table definition", "table definition", "_t")
t("#LIGHT_BLUE# Generate Random object using resolver: %s", "#LIGHT_BLUE# Generate Random object using resolver: %s", "log")
t(" (resolver: %s)", " (resolver: %s)", "tformat")
t("#LIGHT_BLUE# New random%s object: %s", "#LIGHT_BLUE# New random%s object: %s", "log")
t("#LIGHT_BLUE#Could not generate a random object with filter: %s", "#LIGHT_BLUE#Could not generate a random object with filter: %s", "log")
t([[#LIGHT_BLUE#ERROR generating random object with filter [%s].
 Error: %s]], [[#LIGHT_BLUE#ERROR generating random object with filter [%s].
 Error: %s]], "log")
t("#LIGHT_BLUE#Could not generate a base object with filter: %s", "#LIGHT_BLUE#Could not generate a base object with filter: %s", "log")
t([[#LIGHT_BLUE#ERROR generating base object with filter [%s].
 Error:%s]], [[#LIGHT_BLUE#ERROR generating base object with filter [%s].
 Error:%s]], "log")
t("#LIGHT_BLUE#Could not generate a Randart with data: %s", "#LIGHT_BLUE#Could not generate a Randart with data: %s", "log")
t([[#LIGHT_BLUE#ERROR generating Randart with data [%s].
 Error:%s]], [[#LIGHT_BLUE#ERROR generating Randart with data [%s].
 Error:%s]], "log")
t("#LIGHT_BLUE#No object to add", "#LIGHT_BLUE#No object to add", "log")
t([[#LIGHT_BLUE#ERROR accepting object with resolver %s.
 Error:%s]], [[#LIGHT_BLUE#ERROR accepting object with resolver %s.
 Error:%s]], "log")
t("#LIGHT_BLUE#Working Actor set to [%s]%s at (%d, %d)", "#LIGHT_BLUE#Working Actor set to [%s]%s at (%d, %d)", "log")


------------------------------------------------
section "game/modules/tome/dialogs/debug/SpawnEvent.lua"
-- 1 entries
t("DEBUG -- Spawn Event", "DEBUG -- Spawn Event", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/debug/SummonCreature.lua"
-- 8 entries
t("DEBUG -- Summon Creature", "DEBUG -- Summon Creature", "_t")
t("#LIGHT_BLUE# no actor to place.", "#LIGHT_BLUE# no actor to place.", "log")
t("#LIGHT_BLUE#Actor [%s]%s already occupies (%d, %d)", "#LIGHT_BLUE#Actor [%s]%s already occupies (%d, %d)", "log")
t("#LIGHT_BLUE#Added %s[%s]%s at (%d, %d)", "#LIGHT_BLUE#Added %s[%s]%s at (%d, %d)", "log")
t("#YELLOW#Random Actor#LAST#", "#YELLOW#Random Actor#LAST#", "_t")
t("#PINK#Test Dummy#LAST#", "#PINK#Test Dummy#LAST#", "_t")
t("Test Dummy", "Test Dummy", "_t")
t("Test dummy.", "Test dummy.", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/orders/Behavior.lua"
-- 7 entries
t("Set behavior: %s", "Set behavior: %s", "tformat")
t("%s behavior set to %s.", "%s behavior set to %s.", "logPlayer")
t("Default", "Default", "_t")
t("Melee", "Melee", "_t")
t("Ranged", "Ranged", "_t")
t("Tank", "Tank", "_t")
t("Standby", "Standby", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/orders/Talents.lua"
-- 6 entries
t([[%s is listening attentively, and wants to know what talents to use.
You can modify the tactical weights of various talents to increase or decrease their use.  The weights are multiplicative (zero will turn the talent off) and relative (changing everything to a weight of 2 will not alter how talents are used relative to each other).
Word travels fast in Maj'Eyal, and if %s is a summon all future summons of the same type will remember your preferences.
]], [[%s is listening attentively, and wants to know what talents to use.
You can modify the tactical weights of various talents to increase or decrease their use.  The weights are multiplicative (zero will turn the talent off) and relative (changing everything to a weight of 2 will not alter how talents are used relative to each other).
Word travels fast in Maj'Eyal, and if %s is a summon all future summons of the same type will remember your preferences.
]], "tformat")
t("", "", "_t")
t("Talent Name", "Talent Name", "_t")
t("Weight", "Weight", "_t")
t("0 is off, 1 is normal", "0 is off, 1 is normal", "_t")
t("Enter the talent weight multiplier", "Enter the talent weight multiplier", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/CommonData.lua"
-- 5 entries
t("Character's Skin", "Character's Skin", "_t")
t("Character's Hair", "Character's Hair", "_t")
t("Character's Facial Features", "Character's Facial Features", "_t")
t("Character's Aura", "Character's Aura", "_t")
t("#GREY#Invisible#LAST#", "#GREY#Invisible#LAST#", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/Shimmer.lua"
-- 8 entries
t("Shimmer object: %s", "Shimmer object: %s", "tformat")
t("\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "_t")
t([[You can alter %s to look like another item of the same type/slot.
#{bold}#This is a purely cosmetic change.#{normal}#%s]], [[You can alter %s to look like another item of the same type/slot.
#{bold}#This is a purely cosmetic change.#{normal}#%s]], "tformat")
t("Donator Cosmetic Feature", "Donator Cosmetic Feature", "_t")
t("This cosmetic feature is only available to donators/buyers.", "This cosmetic feature is only available to donators/buyers.", "_t")
t("shimmer ingame", "shimmer ingame", "_t")
t("Donate", "Donate", "_t")
t("#GREY#[Invisible]", "#GREY#[Invisible]", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerDemo.lua"
-- 2 entries
t("Shimmer Demo", "Shimmer Demo", "_t")
t("#GREY#[Invisible]", "#GREY#[Invisible]", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOther.lua"
-- 8 entries
t("Shimmer: %s", "Shimmer: %s", "tformat")
t("\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "_t")
t([[You can alter your look.
#{bold}#This is a purely cosmetic change.#{normal}#%s]], [[You can alter your look.
#{bold}#This is a purely cosmetic change.#{normal}#%s]], "tformat")
t("Donator Cosmetic Feature", "Donator Cosmetic Feature", "_t")
t("This cosmetic feature is only available to donators/buyers.", "This cosmetic feature is only available to donators/buyers.", "_t")
t("shimmer ingame", "shimmer ingame", "_t")
t("Donate", "Donate", "_t")
t("#GREY#[Default]", "#GREY#[Default]", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerOutfits.lua"
-- 9 entries
t("Shimmer Sets: %s", "Shimmer Sets: %s", "tformat")
t([[You can switch your appearance to a saved set of shimmers.
#{bold}#This is a purely cosmetic change.#{normal}#]], [[You can switch your appearance to a saved set of shimmers.
#{bold}#This is a purely cosmetic change.#{normal}#]], "_t")
t("Outfit name?", "Outfit name?", "_t")
t("Save Outfit", "Save Outfit", "_t")
t("Donator Cosmetic Feature", "Donator Cosmetic Feature", "_t")
t("This cosmetic feature is only available to donators/buyers.", "This cosmetic feature is only available to donators/buyers.", "_t")
t("shimmer ingame", "shimmer ingame", "_t")
t("Donate", "Donate", "_t")
t("#GOLD#[save current outfit]", "#GOLD#[save current outfit]", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/shimmer/ShimmerRemoveSustains.lua"
-- 9 entries
t("Shimmer: Remove Sustains Effects", "Shimmer: Remove Sustains Effects", "_t")
t("\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "\
#{italic}##CRIMSON#This cosmetic feature is only available to donators/buyers. You can only preview.#WHITE##{normal}#", "_t")
t([[#{bold}##CRIMSON#WARNING: this is an EXPERIMENTAL feature. It may explode!#LAST##{normal}#
Sustains auras with name in #YELLOW#yellow#LAST# can not be automatically turned back on if disabled. After turning them on here, you need to unsustain and resustain them manually.

#{bold}#This is a purely cosmetic change.#{normal}#]], [[#{bold}##CRIMSON#WARNING: this is an EXPERIMENTAL feature. It may explode!#LAST##{normal}#
Sustains auras with name in #YELLOW#yellow#LAST# can not be automatically turned back on if disabled. After turning them on here, you need to unsustain and resustain them manually.

#{bold}#This is a purely cosmetic change.#{normal}#]], "_t")
t("Donator Cosmetic Feature", "Donator Cosmetic Feature", "_t")
t("This cosmetic feature is only available to donators/buyers.", "This cosmetic feature is only available to donators/buyers.", "_t")
t("shimmer ingame", "shimmer ingame", "_t")
t("Donate", "Donate", "_t")
t("#LIGHT_GREEN#yes", "#LIGHT_GREEN#yes", "_t")
t("#LIGHT_RED#no", "#LIGHT_RED#no", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyContingency.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyEmpower.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyExtension.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyMatrix.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/ChronomancyQuicken.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/dialogs/talents/MagicalCombatArcaneCombat.lua"
-- 1 entries
t("", "", "_t")


------------------------------------------------
section "game/modules/tome/load.lua"
-- 3 entries
t("Second weapon set: psionic focus", "Second weapon set: psionic focus", "_t")
t("List of items that can be instantly used by swift hands.", "List of items that can be instantly used by swift hands.", "_t")
t("lck", "lck", "stat short_name")


