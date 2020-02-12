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

if not game.state:isAdvanced() and game.player.level < 20 then
newChat{ id="welcome",
	text = _t[[Good day to you.]],
	answers = {
		{_t"Good day to you too."},
	}
}
return "welcome"
end

if not game.player:hasQuest("spydric-infestation") then
newChat{ id="welcome",
	text = _t[[I have heard you are a great hero of the west. Could you help me, please?]],
	answers = {
		{_t"Maybe, what is it about?", jump="quest", cond=function(npc, player) return not player:hasQuest("spydric-infestation") end},
		{_t"I have got enough problems sorry."},
	}
}
else
newChat{ id="welcome",
	text = _t[[Welcome back, @playername@.]],
	answers = {
		{_t"I have found your husband. I take it he made it home safely?", jump="done", cond=function(npc, player) return player:isQuestStatus("spydric-infestation", engine.Quest.COMPLETED) end},
		{_t"I've got to go. Bye."},
	}
}
end

newChat{ id="quest",
	text = _t[[My husband, Rashim, is a Sun Paladin. He was sent to clear the spider lair of Ardhungol to the north of this town.
It has been three days now. He should be back by now. I have a feeling something terrible has happened to him. Please find him!
He should have a magical stone given by the Anorithil to create a portal back here, yet he did not use it!]],
	answers = {
		{_t"I will see if I can find him.", action=function(npc, player) player:grantQuest("spydric-infestation") end},
		{_t"Spiders? Eww, sorry, but he is probably dead now."},
	}
}

newChat{ id="done",
	text = _t[[Yes, yes he did! He said he would have died if not for you.]],
	answers = {
		{_t"It was nothing.", action=function(npc, player)
			player:setQuestStatus("spydric-infestation", engine.Quest.DONE)
			world:gainAchievement("SPYDRIC_INFESTATION", game.player)
			game:setAllowedBuild("divine")
			game:setAllowedBuild("divine_sun_paladin", true)
		end},
	}
}

return "welcome"
