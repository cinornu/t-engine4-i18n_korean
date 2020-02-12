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

local function check_materials_gave_orb(npc, player)
	local q = player:hasQuest("east-portal")
	if not q or not q:isCompleted("gotoreknor") or not q:isCompleted("gave-orb") then return false end

	--I18N-TODO it should be done in a i18n-friendly style
	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("Resonating Diamond", {raw_name=true})
	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("Blood-Runed Athame", {raw_name=true})
	return gem_o and athame_o
end

local function check_materials_withheld_orb(npc, player)
	local q = player:hasQuest("east-portal")
	if not q or not q:isCompleted("gotoreknor") or not q:isCompleted("withheld-orb") then return false end
	
	--I18N-TODO it should be done in a i18n-friendly style
	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("Resonating Diamond", {raw_name=true})
	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("Blood-Runed Athame", {raw_name=true})
	return gem_o and athame_o
end

if game.player:hasQuest("east-portal") and game.player:isQuestStatus("east-portal", engine.Quest.DONE) then
newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*Nobody answers.*#WHITE#]],
	answers = {
		{_t"[leave]"},
	}
}
elseif game.player:hasQuest("east-portal") and game.player:hasQuest("east-portal").wait_turn and game.player:hasQuest("east-portal").wait_turn > game.turn then
newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*Nobody answers. Tannen is probably still busy studying the orb.*#WHITE#]],
	answers = {
		{_t"[leave]"},
	}
}
else
newChat{ id="welcome",
	text = _t[[How may I be of service, good @playerdescriptor.race@?]],
	answers = {
		{_t"[Relate to him the story of the staff and the Orb of Many Ways and the portals.]", jump="east_portal1", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("talked-elder") and not q:isCompleted("gotoreknor") end},
		{_t"I have the diamond and the athame. [Hand over the Athame and Diamond]", jump="has_material_gave_orb", cond=check_materials_gave_orb},
		{_t"I have the diamond and the athame. [Hand over the Athame and Diamond]", jump="has_material_withheld_orb", cond=check_materials_withheld_orb},
		{_t"Thieving, murderous wretch. Prepare to die!", jump="fake_orb_end", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("tricked-demon") end},
		{_t"How fares your research? Are we ready to create the portal?", jump="wait_end", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("open-telmur") end},
		{_t"Nothing, excuse me. Bye!"},
	}
}
end

---------------------------------------------------------------
-- Explain the situation and get quest going
---------------------------------------------------------------
newChat{ id="east_portal1",
	text = _t[[Astonishing! I have heard tell of this Orb in ancient texts and legends. Might I see it?]],
	answers = {
		{_t"[Show him the Orb of Many Ways]", jump="east_portal2"},
	}
}

newChat{ id="east_portal2",
	text = _t[[Truly, it is the work of a great master. Perhaps Linaniil herself had a hand in its making. And you say you come bearing instructions in its usage?]],
	answers = {
		{_t"I do. [Show him Zemekkys's scribbled notes]", jump="east_portal3"},
	}
}

newChat{ id="east_portal3",
	text = _t[[#LIGHT_GREEN#*He spends a few minutes reading*#WHITE# Ah! I see. I did not at first grasp this Zemekkys's methods, but I see now that they are sound, and it is simply his penmanship that needs improvement. We can manage to reproduce his work here, but, as he says, we will need the Blood-Runed Athame and a Resonating Diamond.]],
	answers = {
		{_t"Have you any idea where they might be found?", jump="east_portal4"},
	}
}

newChat{ id="east_portal4",
	text = _t[[If the orcs created a portal in the depths of Reknor, they must have had access to such items. And if these items cannot pass through the portal they created, then it stands to reason that they must still be in Maj'Eyal. I would search Reknor, starting near the portal itself. Perhaps they did not move the Athame and Diamond far after its creation.]],
	answers = {
		{_t"I'll get searching. Thank you.", jump="east_portal5"},
	}
}

newChat{ id="east_portal5",
	text = _t[[One last thing. I will need to hold onto the Orb of Many Ways while you search. I lack the expertise this Chronomancer Zemekkys possesses, and have much learning on the subject to do if I am to follow in his footsteps.]],
	answers = {
		{_t"[Hand him the Orb] ", action=function(npc, player) player:hasQuest("east-portal"):give_orb(player) end, jump="gave_orb"},
		{_t"I still require the Orb for now.", action=function(npc, player) player:hasQuest("east-portal"):withheld_orb(player) end, jump="withheld_orb"},
	}
}

newChat{ id="gave_orb",
	text = _t[[Thank you. I will treat it with the utmost care.]],
	answers = {
		{_t"Farewell. I'll return with the Athame and Diamond.", action=function(npc, player) player:hasQuest("east-portal"):setStatus(engine.Quest.COMPLETED, "gotoreknor") end},
	}
}

newChat{ id="withheld_orb",
	text = _t[[Very well. There is no hurry. But I will need to spend a number of days studying it before we can create your portal.]],
	answers = {
		{_t"I understand. I'll return with the Athame and Diamond.", action=function(npc, player) player:hasQuest("east-portal"):setStatus(engine.Quest.COMPLETED, "gotoreknor") end},
	}
}

---------------------------------------------------------------
-- back with materials
---------------------------------------------------------------
newChat{ id="has_material_gave_orb",
	text = _t[[Excellent. Return in a few days, and I'll have everything prepared. Oh, take this. #LIGHT_GREEN#*He hands you a key*#WHITE# It opens the ruins of Telmur, which the men of Sholtar sealed many years ago. If you happen to find a text in the ruins entitled "Inverted and Reverted Probabilistic Fields," return with it and your odds of surviving our portal attempt will go up drastically.]],
	answers = {
		{_t"Thank you, and farewell.", action=function(npc, player) player:hasQuest("east-portal"):open_telmur(player) end},
	}
}

newChat{ id="has_material_withheld_orb",
	text = _t[[Excellent. Are you yet willing to leave the Orb in my care for a time?]],
	answers = {
		{_t"I dare not let it out of my sight. I'm sorry.", jump="no_orb_loan"},
		{_t"Here it is. Guard it carefully. I must return to the Far East soon.", jump="orb_loan"},
	}
}

newChat{ id="no_orb_loan",
	text = _t[[#LIGHT_GREEN#*The old man sighs*#WHITE# Very well. I suppose I must make do with a cursory examination under your supervision.]],
	answers = {
		{_t"[Hand him the orb]", jump="no_orb_loan2"},
	}
}

newChat{ id="no_orb_loan2",
	text = _t[[Thank you. Give me a few minutes. #LIGHT_GREEN#*He begins to pace back and forth absently, staring at the Orb.*#WHITE#]],
	answers = {
		{_t"[Wait]", jump="no_orb_loan3"},
	}
}

newChat{ id="no_orb_loan3",
	text = _t[[#LIGHT_GREEN#*He stops pacing and returns the Orb to you.*#WHITE# I believe I know most of what I need to. But I need a few details cleared up. You'll have to return to this Elven Chronomancer and ask him whether he meant an inverted probabilistic field or a reverted probabilistic field. I dare not guess, as the result could be quite unpleasant for you.]],
	answers = {
		{_t"I'll return with the answer.", action=function(npc, player) player:hasQuest("east-portal"):ask_east(player) end},
	}
}

newChat{ id="orb_loan",
	text = _t[[Fear not. Return in a few days, and I'll have everything prepared. Oh, take this. #LIGHT_GREEN#*He hands you a key*#WHITE# It opens the ruins of Telmur, which the men of Sholtar sealed many years ago. If you happen to find a text in the ruins entitled "Inverted and Reverted Probabilistic Fields", return with it and your odds of surviving our portal attempt will go up drastically.]],
	answers = {
		{_t"Thank you, and farewell.", action=function(npc, player) player:hasQuest("east-portal"):open_telmur(player) end},
	}
}

---------------------------------------------------------------
-- Back to the treacherous bastard
---------------------------------------------------------------
newChat{ id="fake_orb_end",
	text = _t[[I think not, fool. Look down.
#LIGHT_GREEN#*You notice you're standing on an etched portal.*#WHITE#]],
	answers = {
		{_t"What in the...", action=function(npc, player) player:hasQuest("east-portal"):tannen_tower(player) end},
	}
}

newChat{ id="wait_end",
	text = _t[[I am ready. You are not. Look down.
#LIGHT_GREEN#*You notice you're standing on an etched portal.*#WHITE#]],
	answers = {
		{_t"What in the...", action=function(npc, player) player:hasQuest("east-portal"):tannen_tower(player) end},
	}
}

return "welcome"
