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

local function evil(npc, player)
	engine.Faction:setFactionReaction(player.faction, npc.faction, 100, true)
	player:setQuestStatus("lost-merchant", engine.Quest.COMPLETED, "evil")
	player:setQuestStatus("lost-merchant", engine.Quest.COMPLETED)
	world:gainAchievement("LOST_MERCHANT_EVIL", player)
	game:setAllowedBuild("rogue_poisons", true)
	local p = game.party:findMember{main=true}
	if p.descriptor.subclass == "Rogue"  then
		if p:knowTalentType("cunning/poisons") == nil then
			p:learnTalentType("cunning/poisons", true)
			p:setTalentTypeMastery("cunning/poisons", 1.3)
		end
	elseif p.descriptor.subclass == "Marauder" or p.descriptor.subclass == "Archer" or p.descriptor.subclass == "Skirmisher" then
		if p:knowTalentType("cunning/poisons") == nil then
			p:learnTalentType("cunning/poisons", false)
			if p.descriptor.subclass == "Skirmisher" then p:setTalentTypeMastery("cunning/poisons", 1.3) end
		end
	end
	if p:knowTalentType("cunning/trapping") then
		game.log("#LIGHT_GREEN#You and the Lord discuss your new relationship at some length, including the merits of assassination by proxy and some additional trapping techniques.")
		game.state:unlockTalent(player.T_AMBUSH_TRAP, player)
	end

	game:changeLevel(1, "wilderness")
	game.log("As you depart the assassin lord says: 'And do not forget, I own you now.'")
end

local function do_attack(npc, player)
	engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true)
	if npc.on_takehit then npc:on_takehit() end
end

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*Before you stands a menacing man clothed in black.*#WHITE#
Ahh, the intruder at last... And what shall we do with you? Why did you kill my men?]],
	answers = {
		{_t"I heard some cries, and your men... they were in my way. What's going on here?", jump="what"},
		{_t"I thought there might be some treasure to be had around here.", jump="greed"},
		{_t"Sorry, I have to go!", jump="hostile"},
	}
}

newChat{ id="hostile",
	text = _t[[Oh, you are not going anywhere, I'm afraid! KILL!]],
	answers = {
		{_t"[attack]", action=do_attack},
		{_t"Wait! Maybe we could work out some kind of arrangement; you seem to be a practical man.", jump="offer"},
	}
}

newChat{ id="what",
	text = _t[[Oh, so this is the part where I tell you my plan before you attack me? GET THIS INTRUDER!]],
	answers = {
		{_t"[attack]", action=do_attack},
		{_t"Wait! Maybe we could work out some kind of arrangement; you seem to be a practical man.", jump="offer"},
	}
}
newChat{ id="greed",
	text = _t[[I am afraid this is not your lucky day then. The merchant is ours... and so are you! GET THIS INTRUDER!!]],
	answers = {
		{_t"[attack]", action=do_attack},
		{_t"Wait! Maybe we could work out some kind of arrangement; you seem to be a practical man.", jump="offer"},
	}
}

newChat{ id="offer",
	text = _t[[Well, I need somebody to replace the men you killed. You look sturdy; maybe you could work for me.
You will have to do some dirty work for me, though, and you will be bound to me.  Nevertheless, you may make quite a profit from this venture, if you are as good as you seem to be.
And do not think of crossing me.  That would be... unwise.]],
	answers = {
		{_t"Well, I suppose it is better than dying.", action=evil},
		{_t"Money? I'm in!", action=evil},
		{_t"Just let me and the merchant get out of here and you may live!", action=do_attack},
	}
}

return "welcome"
