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

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")
local EscortRewards = require("mod.class.EscortRewards")

local reward = EscortRewards:getReward(npc.reward_type)
local quest = game.player:hasQuest(npc.quest_id)
if quest.to_zigur and reward.antimagic then reward = reward.antimagic reward.is_antimagic = true end

game.player:registerEscorts(quest.to_zigur and "zigur" or "saved")

newChat{ id="welcome",
	text = reward.is_antimagic and _t[[At the last moment you invoke the power of nature.  The portal fizzles and transports @npcname@ to Zigur.
You can feel Nature thanking you.]] or
	_t[[Thank you, my friend. I do not think I would have survived without you.
Please let me reward you:]],
	answers = EscortRewards:rewardChatAnwsers(player, reward, "done", function(npc, player, what, k, v, log)
		player:hasQuest(npc.quest_id).reward_message = log
	end),
}

newChat{ id="done",
	text = _t[[There you go. Farewell!]],
	answers = {
		{_t"Thank you."},
	},
}

return "welcome"
