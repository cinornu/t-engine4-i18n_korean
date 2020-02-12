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

-- Those are never generated randomly, but used when we want humanoid random bosses

newEntity{
	define_as = "BASE_NPC_HUMANOID_RANDOM_BOSS",
	type = "humanoid", subtype = "human",
	display = "p", color=colors.UMBER,

	level_range = {1, nil},
	infravision = 10,
	lite = 1,

	life_rating = 10,
	rank = 3,
	size_category = 3,

	open_door = true,
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_HUMAN",
	name = "human", subtype = "human", color=colors.LIGHT_UMBER,
	random_name_def = "cornac_#sex#",
	humanoid_random_boss = 1, zigur_random_boss = 1,
	resolvers.racial_visual(nil, "Human", {"Cornac", "Higher"}),
	resolvers.racial(),
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_THALORE",
	name = "thalore", subtype = "thalore", color=colors.LIGHT_GREEN,
	random_name_def = "thalore_#sex#",
	humanoid_random_boss = 1, zigur_random_boss = 1,
	resolvers.racial_visual(nil, "Elf", "Thalore"),
	resolvers.racial(),
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_SHALORE",
	name = "shalore", subtype = "shalore", color=colors.LIGHT_BLUE,
	random_name_def = "shalore_#sex#", random_name_max_syllables = 4,
	humanoid_random_boss = 1,
	resolvers.racial_visual(nil, "Elf", "Shalore"),
	resolvers.racial(),
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_HALFLING",
	name = "halfling", subtype = "halfling", color=colors.BLUE,
	random_name_def = "halfling_#sex#",
	humanoid_random_boss = 1, zigur_random_boss = 1,
	resolvers.racial_visual(nil, "Halfling", "Halfling"),
	resolvers.racial(),
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_DWARF",
	name = "dwarf", subtype = "dwarf", color=colors.UMBER,
	random_name_def = "dwarf_#sex#",
	humanoid_random_boss = 2, zigur_random_boss = 2,
	resolvers.racial_visual(nil, "Dwarf", "Dwarf"),
	resolvers.racial(),
}

newEntity{ base = "BASE_NPC_HUMANOID_RANDOM_BOSS", define_as = "NPC_HUMANOID_OGRE",
	display = 'P',
	name = "giant", subtype = "ogre", color=colors.BLUE,
	random_name_def = "shalore_#sex#",
	humanoid_random_boss = 2,
	resolvers.racial_visual(nil, "Giant", "Ogre"),
	resolvers.racial(),
}
