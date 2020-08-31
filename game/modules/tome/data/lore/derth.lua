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
-- The Maze
--------------------------------------------------------------------------

newLore{
	id = "derth-beam-trap",
	category = "derth",
	name = _t"Beam Trap",
	lore = _t[[#{italic}#A villager runs up to you, carrying a hefty looking sack.#{normal}#
You've saved us from the storms!  We can't ever repay you enough, but, well...  Shortly after you stopped them, a witch approached us and offered us some...  magical #{italic}#things#{normal}# and said they would protect our town if anything like that happened again.
It's not that I don't trust her, not after you and they - mostly you! - saved us, but...  I just don't feel comfortable having all this arcane stuff around us all the time.  None of us do.  If you've got a use for these, you're more than welcome to them.
#{italic}#He hands you a sack, containing a few dozen of the same strange magical object; included is a guide to using them and producing more, written for users completely inexperienced with magic.  Apparently, they're designed to be mounted on walls and rooftops, and will try to non-lethally incapacitate outside invaders while sending a message of distress to Angolwen.  With a few tweaks, you can make them deadly instead (and avoid harassing Angolwen while you're at it).#{normal}#]],
	on_learn = function(who, relearning)
		if relearning then return end
		local p = game.party:findMember{main=true}
		if p:knowTalentType("cunning/trapping") then
			game.state:unlockTalent(p.T_BEAM_TRAP, p)
		end
	end,
}
