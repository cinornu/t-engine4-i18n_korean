-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

local has_rod = function(npc, player) return player:findInAllInventoriesBy("define_as", "ROD_OF_RECALL") end
local q = game.player:hasQuest("shertul-fortress")
local ql = game.player:hasQuest("love-melinda")
local set = function(what) return function(npc, player) q:setStatus(q.COMPLETED, "chat-"..what) end end
local isNotSet = function(what) return function(npc, player) return not q:isCompleted("chat-"..what) end end

newChat{ id="welcome",
	text = _t[[*#LIGHT_GREEN#The creature slowly turns to you. You hear its terrible voice directly in your head.#WHITE#*
Welcome, master.]],
	answers = {
		{_t"What are you, and what is this place?", jump="what", cond=isNotSet"what", action=set"what"},
		{_t"Master? I am not your mas...", jump="master", cond=isNotSet"master", action=set"master"},
		{_t"Why do I understand you? The texts are unreadable to me.", jump="understand", cond=isNotSet"understand", action=set"understand"},
		{_t"What can I do here?", jump="storage", cond=isNotSet"storage", action=set"storage"},
		{_t"What else can this place do?", jump="energy", cond=isNotSet"energy", action=set"energy"},
		{_t"Would it be possible to improve my Cloak of Deception so I do not need to wear it to pass as a living being?", jump="permanent-cloak", 
			cond=function(npc, player)
				local cloak = player:findInAllInventoriesBy("define_as", "CLOAK_DECEPTION")
				return not q:isCompleted("permanent-cloak") and q:isCompleted("transmo-chest") and cloak
		end},
		{_t"You asked me to come, about a farportal?", jump="farportal", cond=function() return q:isCompleted("farportal") and not q:isCompleted("farportal-spawn") end},
		{_t"You asked me to come, about the rod of recall?", jump="recall", cond=function() return q:isCompleted("recall") and not q:isCompleted("recall-done") end},
		{_t"Would it be possible for my Transmogrification Chest to automatically extract gems?", jump="transmo-gems", cond=function(npc, player) return not q:isCompleted("transmo-chest-extract-gems") and q:isCompleted("transmo-chest") and player:knowTalent(player.T_EXTRACT_GEMS) end},
		{_t"Are there any training facilities?", jump="training", cond=function() return not q:isCompleted("training") end},
		{_t"Can you use your magic to alter the appearance of my gear?", jump="shimmer", cond=function() return not q:isCompleted("shimmer") end},
		{_t"I find your appearance unsettling. Any way you can change it?", jump="changetile", cond=function() return q:isCompleted("recall-done") end},
		{_t"I have come upon a strange thing indeed. #LIGHT_GREEN#[tell him about Melinda]", jump="cure-melinda", cond=function() return ql and ql:isStatus(engine.Quest.COMPLETED, "saved-beach") and not ql:isStatus(engine.Quest.FAILED) and not ql:isStatus(engine.Quest.COMPLETED, "can_come_fortress") end},
		{_t"[leave]"},
	}
}

newChat{ id="master",
	text = _t[[*#LIGHT_GREEN#The creature glares at you.#WHITE#*
You possess a control rod. You are the master.]],
	answers = {
		{_t"Err... ok.", jump="welcome"},
	}
}
newChat{ id="understand",
	text = _t[[*#LIGHT_GREEN#The creature glares at you.#WHITE#*
You are the master; you have the rod. I am created to speak to the master.]],
	answers = {
		{_t"Err... ok.", jump="welcome"},
	}
}

newChat{ id="what",
	text = _t[[*#LIGHT_GREEN#The creature glares at you with intensity. You 'see' images in your head.
You see titanic wars in an age now forgotten. You see armies of what you suppose are Sher'Tuls since they look like the shadow.
They fight with weapons, magic and other things. They fight gods. They hunt them down, killing or banishing them.
You see great fortresses like this one, flying all over the skies of Eyal - shining bastions of power glittering in the young sun.
You see the gods beaten, defeated and dead. All but one.
Then you see darkness; it seems like the shadow does not know what followed those events.

You shake your head as the vision dissipates, and your normal sight comes back slowly.
#WHITE#*
]],
	answers = {
		{_t"Those are Sher'Tuls? They fought the gods?!", jump="godslayers"},
	}
}

newChat{ id="godslayers",
	text = _t[[They had to. They forged terrible weapons of war. They won.]],
	answers = {
		{_t"But then where are they now if they won?", jump="where"},
	}
}

newChat{ id="where",
	text = _t[[They are gone now. I cannot tell you more.]],
	answers = {
		{_t"But I am the master!", jump="where"},
		{_t"Fine.", jump="welcome"},
	}
}

newChat{ id="storage",
	text = _t[[*#LIGHT_GREEN#The creature glares at you.#WHITE#*
You are the master. You can use this place as you desire. However, most of the energies are depleted and only some rooms are usable.
To the south you will find the storage room.]],
	answers = {
		{_t"Thanks.", jump="welcome"},
	}
}

newChat{ id="energy",
	text = _t[[This Fortress is designed as a mobile base for the Godslayers - it can fly.
It is also equiped with various facilities: exploratory farportal, emergency containment field, remote storage, ...
However, the Fortress is badly damaged and has lain dormant for too long. Its energies are nearly depleted.
Take this Transmogrification Chest. It is linked by a permanent farportal to the Fortress. Any item you put inside will be sent to the power core and dismantled for energy.
There are, however, unwanted byproducts to this operation: the generation of a metal known as gold. It is of no use to the Fortress and thus will be sent back to you.]],
	answers = {
		{_t"I will, thanks.", jump="welcome", action=function() q:spawn_transmo_chest() end, cond=function(npc, player) return not player:attr("has_transmo") end},
		{_t"I have already found such a chest in my travel. Will it work?", jump="alreadychest", action=function() q:setStatus(q.COMPLETED, "transmo-chest") end, cond=function(npc, player) return player:attr("has_transmo") end},
	}
}

newChat{ id="alreadychest",
	text = _t[[Yes, it will. I will attune it to this fortress.
Done.]],
	answers = {
		{_t"Thanks.", jump="welcome"},
	}
}

newChat{ id="farportal",
	text = _t[[Long ago the Sher'tuls used farportals not only for transportation to known locations, but also to explore new parts of the world, or even other worlds.
This Fortress is equipped with an exploratory farportal, and now has enough energy to allow one teleportation. Each teleportation will take you to a random part of the universe and use 45 energy.
Beware that the return portal may not be nearby your arrival point; you will need to find it. You can use the rod of recall to try to force an emergency recall, but it has high chances of breaking the exploratory farportal forever.
You may use the farportal; however, beware - I sense a strange presence in the farportal room.]],
	answers = {
		{_t"I will check it out, thanks.", action=function() q:spawn_farportal_guardian() end},
	}
}

newChat{ id="recall",
	text = _t[[The rod of recall you possess is not a Sher'tul artifact, but it is based on Sher'tul design.
The Fortress now has enough energy to upgrade it. It can be changed to recall you to the Fortress.]],
	answers = {
		{_t"I like it the way it is now. Thanks anyway."},
		{_t"That could be quite useful. Yes, please do it.", action=function() q:upgrade_rod() end},
	}
}

newChat{ id="training",
	text = _t[[Yes master, a training facility is available to the north, but it is not yet powered on.
I will need to use 50 energy to do this.]],
	answers = {
		{_t"Maybe later."},
		{_t"That could be quite useful. Yes, please do it.", cond=function() return q.shertul_energy >= 50 end, action=function() q:open_training() end},
	}
}

newChat{ id="shimmer",
	text = _t[[Yes master, the Mirror of Reflections is what you need. It is currently dormant but could be re-activated.
I will need to use 10 energy to do this.]]..(profile:isDonator(1) and "" or _t"\n#{italic}##CRIMSON#This feature is purely cosmetic is available only to donators/buyers. You can unlock the room and use the preview but you will not be able to validate your choices.#{normal}#"),
	answers = {
		{_t"Maybe later."},
		{_t"That could be quite nice. Yes, please do it.", cond=function() return q.shertul_energy >= 10 end, action=function() q:open_shimmer() end},
	}
}

newChat{ id="transmo-gems",
	text = _t[[Ah yes, you seem to master the simple art of alchemy. I can change the chest to automatically use your power to extract a gem if the transmogrification of the gem would reward more energy.
However, I will need to use 25 energy to do this.]],
	answers = {
		{_t"Maybe sometime later."},
		{_t"That could be quite useful. Yes, please do it.", cond=function() return q.shertul_energy >= 25 end, action=function() q:upgrade_transmo_gems() end},
	}
}

newChat{ id="changetile",
	text = _t[[I can alter the Fortress holographic projection matrix to accomodate your racial tastes. This will require 60 energy, however.]],
	answers = {
		{_t"Can you try for a human female appearance please?", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = mod.class.Actor.new{
				add_mos={{image = "npc/humanoid_female_sluttymaid.png", display_y=-1, display_h=2}},
--				shader = "shadow_simulacrum",
--				shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
			}
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{_t"Can you try for a human male appearance please?", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = mod.class.Actor.new{
				image = "invis.png",
				add_mos={{image = "npc/humanoid_male_sluttymaid.png", display_y=-1, display_h=2}},
--				shader = "shadow_simulacrum",
--				shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
			}
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{_t"Please revert to your default appearance.", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = nil
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{_t"Well, you do not look so bad actually. Let it be for now."},
	}
}

newChat{ id="permanent-cloak",
	text = _t[[Yes Master. I can use 10 energy to infuse your cloak. When you take it off the effect should still persist.
However, I suggest you still carry it with you in case something manages to remove it from you.]],
	answers = {
		{_t"Not now."},
		{_t"That could be quite useful. Yes, please do it.", cond=function() return q.shertul_energy >= 10 end,action=function(npc, player)
			local cloak = player:findInAllInventoriesBy("define_as", "CLOAK_DECEPTION")
			cloak.upgraded_cloak = true
			player.permanent_undead_cloak = true  -- Prevents the effect being removed from moving the flags
			q.shertul_energy = q.shertul_energy - 10
			q:setStatus(engine.Quest.COMPLETED, "permanent-cloak")
		end},
	}
}

newChat{ id="cure-melinda",
	text = _t[[Demonic taint. Yes I have a way to help in the archives. However this is a long process, the subject will need to live here for a while.
She will have to spend 8 hours per day in the regeneration tank.]],
	answers = {
		{_t"This is great news! I will tell her at once.", action=function(npc, player)
		player:setQuestStatus("love-melinda", engine.Quest.COMPLETED, "can_come_fortress")
		end},
	}
}

return "welcome"
