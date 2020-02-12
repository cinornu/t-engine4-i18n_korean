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

load("/data/general/objects/objects-maj-eyal.lua")

-- Allows undeads to pass as normal humans
newEntity{ define_as = "CLOAK_DECEPTION",
	power_source = {arcane=true},
	unique = true, quest=true,
	slot = "CLOAK",
	type = "armor", subtype="cloak",
	unided_name = _t"black cloak", image = "object/artifact/black_cloak.png",
	moddable_tile = "cloak_%s_05", moddable_tile_hood = true,
	name = "Cloak of Deception",
	display = ")", color=colors.DARK_GREY,
	encumber = 1,
	desc = _t[[A black cloak, with subtle illusion enchantments woven into its very fabric.]],

	wielder = {
		combat_spellpower = 5,
		combat_mindpower = 5,
		combat_dam = 5,
	},
	callbackOnChangeLevel = function(self, who)
		return self:on_wear(who)
	end,
	on_wear = function(self, who)
		if game.party:hasMember(who) then
			for m, _ in pairs(game.party.members) do
				m:setEffect(m.EFF_CLOAK_OF_DECEPTION, 1, {})
			end
		end
	end,
	on_takeoff = function(self, who)
		if self.upgraded_cloak then return end
		if game.party:hasMember(who) then
			for m, _ in pairs(game.party.members) do
				m:removeEffect(m.EFF_CLOAK_OF_DECEPTION, true, true)
			end
		end
	end,
	on_pickup = function(self, who)
		who:setQuestStatus("start-undead", engine.Quest.COMPLETED, "black-cloak")
	end,
}

for i = 1, 4 do
newEntity{ base = "BASE_LORE",
	define_as = "NOTE"..i,
	name = "journal page", lore="blighted-ruins-note-"..i,
	desc = _t[[A paper scrap, left by the Necromancer.]],
	rarity = false,
	encumberance = 0,
}
end
