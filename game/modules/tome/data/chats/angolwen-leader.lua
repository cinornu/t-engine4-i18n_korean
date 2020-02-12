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

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*A tall woman stands before you. Her fair skin radiates incredible power through her white robe.*#WHITE#
I am Linaniil of the Kar'Krul. Welcome to our city, @playerdescriptor.subclass@. What may I do for thee?]],
	answers = {
		{_t"I require all the help I can get, not for my sake but for the town of Derth, to the northeast of here.", jump="save-derth", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and q:isCompleted("saved-derth") and not q:isCompleted("tempest-located") and not q:isStatus(q.DONE) end},
		{_t"I am ready! Send me to Urkis!", jump="teleport-urkis", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and not q:isEnded("tempest-located") and q:isCompleted("tempest-located") and not q:isCompleted("angolwen-reward") end},
		{_t"Urkis has been slain.", jump="reward-urkis", cond=function(npc, player) 
			local q = player:hasQuest("lightning-overload") 
			return q and q:isCompleted("tempest-urkis-slain") and not q:isCompleted("angolwen-reward") and not q:isStatus(q.DONE) end},
		{_t"Nothing for now. Sorry to have taken your time. Farewell, my lady."},
	}
}

newChat{ id="save-derth",
	text = _t[[Yes, we have noticed the devastation that happened there. I have sent some friends thence to disperse the cloud, but the true threat lies not there.
He who created this abomination is Urkis. He is a Tempest, a powerful Archmage who channels the storms.
Years ago he went rogue, severing himself from Angolwen. At first he remained quiet, and thus we withheld action, but it seems we have no choice now.
Cleansing the skies will take much time. In the meanwhile, if thou art willing, we can send thee to Urkis' lair to face him.
I will not lie to thee: we can send thee thence, but this could be a death trap, and we have no means for thou to depart his lair, as he lives atop a tall peak in the Daikara mountains.]],
	answers = {
		{_t"I need to prepare myself. I will be back soon.", action=function(npc, player) player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED, "tempest-located") end},
		{_t"I am ready. Send me. I will not let the good people of Derth down.", action=function(npc, player)
			player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED, "tempest-located")
			player:hasQuest("lightning-overload"):teleport_urkis()
			game:unlockBackground("linaniil", "Archmage Linaniil")
		end},
	}
}

newChat{ id="teleport-urkis",
	text = _t[[Good luck to thee. Thou hast the blessings of Angolwen.]],
	answers = {
		{_t"Thank you.", action=function(npc, player)
			player:hasQuest("lightning-overload"):teleport_urkis()
			game:unlockBackground("linaniil", "Archmage Linaniil")
		end},
	}
}

newChat{ id="reward-urkis",
	text = _t[[I see the storm is calmed.  Take this rune as a token of my appreciation.]],
	answers = {
		{_t"Thank you.", action=function(npc, player)
			local o = game.zone:makeEntityByName(game.level, "object", "RUNE_DISSIPATION")
			if not o then return end
			o:identify(true)
			game.zone:addEntity(game.level, o, "object")
			player:addObject(player:getInven("INVEN"), o)
			player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED, "angolwen-reward")
			player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED)
		end},
	}
}

return "welcome"
