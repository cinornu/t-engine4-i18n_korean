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

-- Cunning talents
newTalentType{ allow_random=true, type="cunning/stealth-base", name = _t"stealth", description = _t"Allows the user to enter stealth." }
newTalentType{ allow_random=true, type="cunning/stealth", name = _t"stealth", description = _t"Allows the user to enter stealth." }
newTalentType{ allow_random=true, type="cunning/trapping", name = _t"trapping", description = _t"The knowledge of trap laying and assorted trickeries." }
newTalentType{ allow_random=true, type="cunning/traps", name = _t"traps", description = _t"Collection of known traps." }
newTalentType{ allow_random=true, type="cunning/poisons", name = _t"poisons", description = _t"The knowledge of poisons and how to apply them to 'good' effects." }
newTalentType{ allow_random=true, type="cunning/poisons-effects", name = _t"poisons", description = _t"Collection of known poisons." }
newTalentType{ allow_random=true, type="cunning/dirty", name = _t"dirty fighting", description = _t"Teaches various talents to cripple your foes." }
newTalentType{ allow_random=true, type="cunning/lethality", generic = true, name = _t"lethality", description = _t"How to make your foes feel the pain." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="cunning/shadow-magic", name = _t"shadow magic", description = _t"Blending magic and shadows." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="cunning/ambush", name = _t"ambush", min_lev = 10, description = _t"Using darkness and a bit of magic, you manipulate the shadows." }
newTalentType{ allow_random=true, type="cunning/survival", name = _t"survival", generic = true, description = _t"The knowledge of the dangers of the world, and how to best avoid them." }
newTalentType{ allow_random=true, type="cunning/tactical", name = _t"tactical", description = _t"Tactical combat abilities." }
newTalentType{ allow_random=true, type="cunning/scoundrel", name = _t"scoundrel", generic = true, description = _t"The use of ungentlemanly techniques." }
newTalentType{ allow_random=true, type="cunning/artifice", name = _t"artifice", min_lev = 10, description = _t"Create and use cunning tools." }
newTalentType{ allow_random=true, type="cunning/tools", name = _t"tools", description = _t"Artificer's tools." }

-- Skirmisher
newTalentType {
  type = "cunning/called-shots",
  name = _t"Called Shots",
  allow_random = true,
  description = _t"Inflict maximum pain to specific places on your enemies.",
}

-- Generic requires for cunning based on talent level
cuns_req1 = {
	stat = { cun=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
cuns_req2 = {
	stat = { cun=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
cuns_req3 = {
	stat = { cun=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
cuns_req4 = {
	stat = { cun=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
cuns_req5 = {
	stat = { cun=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
cuns_req_high1 = {
	stat = { cun=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
cuns_req_high2 = {
	stat = { cun=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
cuns_req_high3 = {
	stat = { cun=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
cuns_req_high4 = {
	stat = { cun=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
cuns_req_high5 = {
	stat = { cun=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}

-- talents that require unlocking (specific poisons, traps)
cuns_req_unlock = {
	special = {desc=_t"Talent not unlocked", fct=function(self, t, offset)
		return game.state:unlockTalentCheck(t.id, self)
	end}
}

load("/data/talents/cunning/stealth.lua")
load("/data/talents/cunning/traps.lua")
load("/data/talents/cunning/poisons.lua")
load("/data/talents/cunning/dirty.lua")
load("/data/talents/cunning/lethality.lua")
load("/data/talents/cunning/tactical.lua")
load("/data/talents/cunning/survival.lua")
load("/data/talents/cunning/shadow-magic.lua")
load("/data/talents/cunning/ambush.lua")
load("/data/talents/cunning/scoundrel.lua")
load("/data/talents/cunning/called-shots.lua")
load("/data/talents/cunning/artifice.lua")