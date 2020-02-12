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

local change_inven = function(npc, player)
	local d
	local titleupdator = player:getEncumberTitleUpdator(("Equipment(%s) <=> Inventory(%s)"):tformat(npc.name:capitalize(), player.name:capitalize()))
	d = require("mod.dialogs.ShowEquipInven").new(titleupdator(), npc, nil, function(o, inven, item, button, event)
		if not o then return end
		local ud = require("mod.dialogs.UseItemDialog").new(event == "button", npc, o, item, inven, function(_, _, _, stop)
			d:generate()
			d:generateList()
			d:updateTitle(titleupdator())
			if stop then game:unregisterDialog(d) end
		end, true, player)
		game:registerDialog(ud)
	end, nil, player)
	game:registerDialog(d)
end

local change_talents = function(npc, player)
	local LevelupDialog = require "mod.dialogs.LevelupDialog"
	local ds = LevelupDialog.new(npc, nil, nil)
	game:registerDialog(ds)
end

local change_tactics = function(npc, player)
	game.party:giveOrders(npc)
end

local change_control = function(npc, player)
	game.party:select(npc)
end

local change_name = function(npc, player)
	local d = require("engine.dialogs.GetText").new(_t"Change your golem's name", _t"Name", 2, 25, function(name)
		if name then
			npc.name = ("%s (servant of %s)"):tformat(name, player.name)
			npc.changed = true
		end
	end)
	game:registerDialog(d)
end

local change_appearance = function(npc, player)
	require("mod.dialogs.Birther"):showCosmeticCustomizer(npc, "Golem Cosmetic Options", function()
		npc.golem_appearance_set = true
	end)
end

local ans = {
	{_t"I want to change your equipment.", action=change_inven},
	{_t"I want to change your talents.", action=change_talents},
	{_t"I want to change your tactics.", action=change_tactics},
	{_t"I want to take direct control.", action=change_control},
	{_t"I want to change your name.", cond = function() return golem.sentient_telos == 1 end, jump="name", action=function(npc, player) npc.name = ("Telos the Great and Powerful (reluctant follower of %s)"):tformat(npc.summoner:getName()) game.log("#ROYAL_BLUE#The golem decides to change it's name to #{bold}#%s#{normal}#.", npc.name) end},
	{_t"I want to change your name.", cond = function() return not golem.sentient_telos end, action=change_name},
	{_t"How is it that you speak?", cond = function() return golem.sentient_telos == 1 end, jump="how_speak"},
	{_t"I want to change your appearance (one-time only).", cond = function(npc, player) return profile:isDonator() and not npc.golem_appearance_set end, action=change_appearance},
	{_t"Nothing, let's go."},
}

newChat{ id="how_speak",
	text = _t[[What's the good of immortality if you can't even speak? No archmage worth his salt is going to concoct some immoral life-after-death scheme without including some sort of capacity for making his opinions known. And, by the way, your energy manipulation techniques are on the same level as those of my average pair of shoes. Though I guess you are making up for it with your golem crafting skills.]],
	answers = ans
}

newChat{ id="name",
	text = _t[[Change my name? I'm quite happy being 'Telos' thankyou. Though I wouldn't mind being 'Telos the Great and Powerful'. Do that actually. Yes!]],
	answers = ans
}

if golem.sentient_telos == 1 then

newChat{ id="welcome",
	text = _t[[I'm a golem. How droll!
Oh, did you want something?]],
	answers = ans
}

else

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*The golem talks in a monotonous voice*#WHITE#
Yes master.]],
	answers = ans
}

end
return "welcome"
