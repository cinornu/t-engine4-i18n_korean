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

if game.player:isQuestStatus("antimagic", engine.Quest.DONE) then
newChat{ id="welcome",
	text = _t[[Well met, friend.]],
	answers = {
		{_t"Farewell."},
	}
}
return "welcome"
end

local sex = game.player.female and _t"Sister" or _t"Brother"

local remove_magic = function(npc, player)
	for tid, _ in pairs(player.sustain_talents) do
		local t = player:getTalentFromId(tid)
		if t.is_spell then player:forceUseTalent(tid, {ignore_energy=true}) end
	end

	-- Remove equipment
	for inven_id, inven in pairs(player.inven) do
		for i = #inven, 1, -1 do
			local o = inven[i]
			if o.power_source and o.power_source.arcane then
				game.logPlayer(player, "You cannot use your %s anymore; it is tainted by magic.", o:getName{do_color=true})
				local o = player:removeObject(inven, i, true)
				player:addObject(player.INVEN_INVEN, o)
				player:sortInven()
			end
		end
	end
	player:attr("forbid_arcane", 1)
	player:attr("zigur_follower", 1)
	player.changed = true
end

newChat{ id="welcome",
	text = ([[#LIGHT_GREEN#*A grim-looking Fighter stands there, clad in mail armour and a large olive cloak. He doesn't appear hostile - his sword is sheathed.*#WHITE#
%s, our guild has been watching you and we believe that you have potential.
We see that the hermetic arts have always been at the root of each and every trial this land has endured, and we also see that one day they will bring about our destruction. So we have decided to take action by calling upon Nature to help us combat those who wield the arcane.
We can train you, but you need to prove you are pure, untouched by the eldritch forces, and ready to fight them to the end.
You will be challenged against magical foes. Should you defeat them, we will teach you our ways, and never again will you be able to be tainted by magic, or use it.

#LIGHT_RED#Note:  Completing this quest will forever prevent this character from using spells or items powered by arcane forces.  In exchange you'll be given access to a mindpower based generic talent tree, Anti-magic, and be able to unlock hidden properties in many arcane-disrupting items.]]):tformat(sex),
	answers = {
		{_t"I will face your challenge!", cond=function(npc, player) return player.level >= 10 end, jump="testok"},
		{_t"I will face your challenge!", cond=function(npc, player) return player.level < 10 end, jump="testko"},
		{_t"I'm not interested.", jump="ko"},
	}
}

newChat{ id="ko",
	text = _t[[Very well. I will say that this is disappointing, but it is your choice. Farewell.]],
	answers = {
		{_t"Farewell."},
	}
}

newChat{ id="testko",
	text = _t[[Ah, you seem eager, but maybe still too young. Come back when you have grown a bit.]],
	answers = {
		{_t"I shall."},
	}
}

local ogretext = ""
if player.descriptor and player.descriptor.subrace == "Ogre" then
	ogretext = _t"\nWorry not, though, Ogre - we can replace your unclean runes with a newly-discovered mixture of infusions, eliminating your dependence on them.  The process will feel...  unpleasant, and will dramatically shorten your lifespan, but you will finally be free from the addictive grip of the arcane!\n"
	if player.descriptor.subclass == "Oozemancer" then
		ogretext = ogretext.._t"We'll also reinforce the infusions you've been granted to replace your runes - the newest mixture should give you about five years of your life that the initial mixture took from you.\n"
	end
end

newChat{ id="testok",
	text = ([[Very well. Before you start, we will make sure no magic can help you:
- You will not be able to use any spells or magical devices
- Any worn objects that are powered by the arcane will be unequipped
%s
Are you ready, or do you wish to prepare first?]]):tformat(ogretext),
	answers = {
		{_t"I am ready", jump="test", action=remove_magic},
		{_t"I need to prepare."},
	}
}

newChat{ id="test",
	text = ([[#VIOLET#*You are grabbed by two olive-clad warriors and thrown into a crude arena!*
#LIGHT_GREEN#*You hear the voice of the Fighter ring above you.*#WHITE#
%s! Your training begins! I want to see you prove your superiority over the works of magic! Fight!]]):tformat(sex),
	answers = {
		{_t"But wha.. [you notice your first opponent is already there]", action=function(npc, player)
			player:grantQuest("antimagic")
			player:hasQuest("antimagic"):start_event()
		end},
	}
}

return "welcome"
