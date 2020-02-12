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

if game.zone.from_farportal then

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*Before you stands a humanoid shape filled with 'nothing'. It seems to stare at you.*#WHITE#
I am the Eidolon and you are not welcome here!
No matter how you came to this plane, #{bold}#DO NOT COME BACK!
NOW BEGONE!
#{normal}#
.]],
	answers = {
		{_t"...", action=function() game.level.data.eidolon_exit(false) end},
	}
}


else

newChat{ id="welcome",
	text = _t[[#LIGHT_GREEN#*Before you stands a humanoid shape filled with 'nothing'. It seems to stare at you.*#WHITE#
I have brought you here on the instant of your death. I am the Eidolon.
I have deemed you worthy of my 'interest'. I will watch your future steps with interest.
You may rest here, and when you are ready I will send you back to the material plane.
But do not abuse my help. I am not your servant, and someday I might just let you die.
As for your probable many questions, they will stay unanswered. I may help, but I am not here to explain why.]],
	answers = {
		{_t"Thank you. I will rest for a while."},
		{_t"Thank you. I am ready to go back!", 
			cond=function() return game.level.source_level and not game.level.source_level.no_return_from_eidolon end,
			action=function() game.level.data.eidolon_exit(false) end
		},
		{_t"Thank you, but I fear I will not survive anyway, can you send me back somewhere else please?",
			cond=function() return game.level.source_level and not game.level.source_level.no_return_from_eidolon and (not game.level.source_level.data or not game.level.source_level.data.no_worldport) end,
			action=function() game.level.data.eidolon_exit(true) end
		},
		{_t"Thank you, but I fear I will not survive anyway, can you send me back somewhere else on the level please?",
			cond=function() return game.level.source_zone and game.level.source_zone.infinite_dungeon end,
			action=function() game.level.data.eidolon_exit("teleport") end
		},
		{_t"Thank you, I am ready to go back!",
			cond=function() return not game.level.source_level or game.level.source_level.no_return_from_eidolon end,
			jump="jump_error",
		},
		{_t"Thank you, but I am weary of this life, I wish no more, please let me go.", jump="die"},
	}
}

newChat{ id="jump_error",
	text = _t[[It seems the threads of time and space have been disrupted...
I will try to send you to safety.]],
	answers = {
		{_t"Thanks.", action=function(npc, player) game:changeLevel(1, "wilderness") end},
	}
}

newChat{ id="die",
	text = _t[[#LIGHT_GREEN#*It seems to stare at you in weird way.*#WHITE#
I...had plans for you, but I cannot go against your free will. Know that you had a destiny waiting for you.
Are you sure?]],
	answers = {
		{_t"Just let me go please.", action=function(npc, player)
			local src = game.player
			game:getPlayer(true):die(game.player, {special_death_msg=("asked the Eidolon to let %s die in peace"):tformat(game.player.female and _t"her" or _t"him")})
			while game.party:findSuitablePlayer() do
				game.player:die(src, {special_death_msg=_t"brought down by Eidolon"})
			end
		end},
		{_t"No actually, perhaps life is still worth it!"},
	}
}

end

return "welcome"
