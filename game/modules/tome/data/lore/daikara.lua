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

--------------------------------------------------------------------------
-- The Daikara
--------------------------------------------------------------------------

newLore{
	id = "daikara-note-1",
	category = "daikara",
	name = _t"expedition journal entry (daikara)",
	lore = _t[[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Nothing but hatchlings so far. Honestly, if this keeps up we won't have enough dragonhide to cover a dragon, let alone cover our losses. I've really spared no expense this time as well: Gorran is one of the finest rangers I know, and Sodelost... his prices are exorbitant, but then what else would you expect from those money-grubbing dwarven Thronesmen? I must admit I don't know much about Xann. The locals say there's no finer wyrmic in the area, and I admit she is something special in combat. Now, if only she could turn her draconic talents to FINDING some dragons!]],
}

newLore{
	id = "daikara-note-2",
	category = "daikara",
	name = _t"expedition journal entry (daikara)",
	lore = _t[[#{bold}#Sodelost, Dwarf Rogue#{normal}#
Can't believe I agreed to this expedition. I suppose it's because I've known Relle for a while. We've crossed paths many times at Derth's trading post. I even gave her a special rate for my services. Sentimental fool! All it's got me is boots filled with snow and a light coinpurse. I still don't understand why these Kingdom types are so enamoured with drakeskin... makes superior armour they say. Pah! If you can't handle metal armour, what business do you have even wearing armour? Leather has about as much use as a halfling tied to a... noises up ahead, must stop writing.]],
}

newLore{
	id = "daikara-note-3",
	category = "daikara",
	name = _t"expedition journal entry (daikara)",
	lore = _t[[#{bold}#Gorran, Cornac Archer#{normal}#
That snake. That addlepated beardling. That coin-hounding, blackhearted, stump-kneed dwarf! A scout he calls himself! The finest eyes of the Iron Throne, able to read the sign of the tavern in Last Hope from the tavern in Derth! Surely someone with such grandiose praise for his own eyesight would have spotted that cold drake waiting in ambush for us! Damnable thing, I'll be lucky if I can ever use my left arm again. I can't use my bow now ... I'm effectively dead wood to the team. I'm beginning to think that Sodelost has ulterior motives... I wouldn't put it past a dwarf to lead us up this forsaken mountain to die just so he could rifle through our pockets! I keep telling Relle, but she won't listen. The fool...]],
}

newLore{
	id = "daikara-note-4",
	category = "daikara",
	name = _t"expedition journal entry (daikara)",
	lore = _t[[#{bold}#Relle, Cornac Fighter & Expedition Captain#{normal}#
Sodelost is dead, and so is Gorran. The former by Gorran's hand, the latter by my hand. Even in these wastes I cannot abide such an act of mutiny. I was aware of Gorran's anger ever since the drake attack, but I never dreamed he would turn on Sodelost like he did. He had taken my longsword as I slept the previous night, strode up to Sodelost, unheeding of I and Xann watching him, ran him through and laughed. Simply laughed. There was nothing for it; I wrenched my sword from his hand and brought it down on his neck. The commotion seems to have stirred up a nearby drake's nest, and now I fear we don't have the strength to repel a concentrated attack. We may have to abandon this expedition.]],
}

newLore{
	id = "daikara-note-5",
	category = "daikara",
	name = _t"expedition journal entry (daikara)",
	lore = _t[[#{bold}#Xann, Shaloren Wyrmic#{normal}# (This entry was scrawled by an unsteady hand)
#{italic}#impudent fools treading upon dragon's ground. slaying my dear kin just for their skin they will pay they will pay. i called the drake, told it to be cunning, avoid the dwarf's gaze. i laughed as it bit into that ranger's arm ahaahaa. they're killing each other now, simple creatures, simple soft skinned creatures. not like dragons, so perfect, symbols of power, perfection... their captain still lives, but not for long. i will bring her to you to feast.

rantha i will see you soon#{normal}#]],
}

newLore{
	id = "daikara-dragonsfire-trap",
	category = "daikara",
	name = _t"Dragonsfire Trap",
	lore = _t[[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being charred to a crisp" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of dragonsfire. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]],
	on_learn = function(who)
		local p = game.party:findMember{main=true}
		if p:knowTalentType("cunning/trapping") then
			game.state:unlockTalent(p.T_DRAGONSFIRE_TRAP, p)
		end
	end,
}

newLore{
	id = "daikara-freezing-trap",
	category = "daikara",
	name = _t"Freezing Trap",
	lore = _t[[#{bold}#Relle, Cornac Fighter and Expedition Leader#{normal}#
It knows we're here.  Xann's gone, and I have to assume the worst.  Too late to run.  One option left, a contraption Sodelost ensured us he'd be able to use to get the kill...  shame he didn't leave instructions behind with it, it's unclear how to arm it, and I don't want to add "being frozen solid" to my list of troubles today.
I might not know a great deal about artifice, but I know how wild animals work, and for all the praise they get, dragons are no better.  I don't need to know how to rig this device so it goes off when the beast steps on it - I just need to put it inside something it'll eat whole...
#{italic}#Judging from this note's intact state and delicate placement next to a sack covered in assorted animal viscera, the dragon not only avoided setting off the trap, but has kept it as a trophy.  Inside the sack is a disarmed trap featuring a few recognizable alchemical flasks, and a means of mixing them in the right proportion when a pressure plate is triggered to produce a blast of ice. Figuring out how to arm it is almost as easy as figuring out how to make more traps like it.#{normal}#]],
	on_learn = function(who)
		local p = game.party:findMember{main=true}
		if p:knowTalentType("cunning/trapping") then
			game.state:unlockTalent(p.T_FREEZING_TRAP, p)
		end
	end,
}