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

local function attack(str)
	return function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) npc:doEmote(str, 150) end
end

-----------------------------------------------------------------------
-- Default
-----------------------------------------------------------------------
if not game.player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") then

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*@npcname@'s deep voice booms through the caverns.*#WHITE#
This is my domain, and I do not take kindly to intruders. What is your purpose here?]],
	answers = {
		{_t"I am here to kill you and take your treasures! Die, damned fish!", action=attack(_t"DIE!")},
		{_t"I did not mean to intrude. I shall leave now.", jump="quest"},
	}
}

newChat{ id="quest",
	text = _t[[Wait! You seem to be worthy, so let me tell you a story.
During the Age of Pyre the world was sundered by the last effects of the Spellblaze. A part of the continental shelf of Maj'Eyal was torn apart and thrown into the sea.
The Naloren Elves perished... or so the world thinks. Some of them survived; using ancient Sher'Tul magic they had kept for themselves, they transformed to live underwater.
They are now called the nagas. They live deep in the ocean between Maj'Eyal and the Far East.
One of them, Slasul, rebelled against his order and decided he wanted the world for himself, both underwater and above. He found an ancient temple, probably a Sher'Tul remain, called the Temple of Creation.
He believes he can use it to #{italic}#improve#{normal}# nagas.
But he has become mad and now looks upon all other intelligent water life as a threat, and that includes myself.
I cannot leave this sanctuary, but perhaps you could help me?
After all, it would be an act of mercy to end his madness.]],
	answers = {
		{_t"I would still rather kill you and take your treasure!", action=attack(_t"DIE!")},
		{_t"I shall do as you say, but how do I find him?", jump="givequest"},
		{_t"That seems... unwise. My apologies, but I must refuse.", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") player:setQuestStatus("temple-of-creation", engine.Quest.FAILED) end},
	}
}

newChat{ id="givequest",
	text = _t[[I can open a portal to his lair, far away in the western sea, but be warned: this is one-way only. I cannot bring you back. You will have to find your own way.]],
	answers = {
		{_t"I will.", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") end},
		{_t"This is a death trap! Goodbye.", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") player:setQuestStatus("temple-of-creation", engine.Quest.FAILED) end},
	}
}


-----------------------------------------------------------------------
-- Coming back later
-----------------------------------------------------------------------
else
newChat{ id="welcome",
	text = _t[[Yes?]],
	answers = {
		{_t"[attack]", action=attack(_t"TREACHERY!")},
		{_t"I want your treasures, water beast!", action=attack(_t"Oh, is that so? Well, COME GET THEM!")},
		{_t"I spoke with Slasul, and he did not seem hostile, or mad.", jump="slasul_friend", cond=function(npc, player) return player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "slasul-story") and not player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "kill-slasul") end},
		{_t"Farewell, dragon."},
	}
}

newChat{ id="slasul_friend",
	text = _t[[#LIGHT_GREEN#*@npcname@ roars!*#WHITE# You listen to the lies of this mad naga!
You are corrupted! TAINTED!]],
	answers = {
		{_t"[attack]", action=attack(_t"DO NOT MEDDLE IN THE AFFAIRS OF DRAGONS!")},
		{_t"#LIGHT_GREEN#*Shake your head.*#LAST#He swayed my mind! Please, I am not your enemy.", jump="last_chance", cond=function(npc, player) return rng.percent(30 + player:getLck()) end},
	}
}

newChat{ id="last_chance",
	text = _t[[#LIGHT_GREEN#*@npcname@ calms down!*#WHITE# Very well; he is indeed a trickster.  Now go finish your task, or do not come back!]],
	answers = {
		{_t"Thank you, mighty one."},
	}
}

end

return "welcome"

