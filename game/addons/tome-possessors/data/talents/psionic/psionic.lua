-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

-- Talent trees
newTalentType{ allow_random=true, is_mind=true, type="psionic/possession", name = _t"possession", description = _t"Learn to possess the bodies of your foes!" }
newTalentType{ allow_random=true, is_mind=true, type="psionic/body-snatcher", name = _t"body snatcher", description = _t"Manipulate your dead foes bodies for power and success!" }
newTalentType{ allow_random=true, is_mind=true, type="psionic/psionic-menace", name = _t"psionic menace", description = _t"Laught terrible mind attacks to wear down your foes from afar with your double mindstars!" }
newTalentType{ allow_random=true, is_mind=true, type="psionic/psychic-blows", name = _t"psychic blows", description = _t"Wield a two handed weapon to channel your psionics into your foes' faces!" }
newTalentType{ allow_random=true, is_mind=true, type="psionic/battle-psionics", name = _t"battle psionics", description = _t"Dual wield a one handed weapon and a mindstar to assail your enemies's minds and bodies!" }
newTalentType{ allow_random=true, is_mind=true, type="psionic/deep-horror", name = _t"deep horror", min_lev = 10, description = _t"Through your psionic powers you become a nightmare for your foes." }
newTalentType{ allow_random=true, is_mind=true, type="psionic/ravenous-mind", name = _t"ravenous mind", generic = true, description = _t"Your mind hungers for pain and suffering! Feed it!" }

damDesc = Talents.main_env.damDesc
psi_wil_req1 = Talents.main_env.psi_wil_req1
psi_wil_req2 = Talents.main_env.psi_wil_req2
psi_wil_req3 = Talents.main_env.psi_wil_req3
psi_wil_req4 = Talents.main_env.psi_wil_req4
psi_wil_req5 = Talents.main_env.psi_wil_req5
psi_wil_high1 = Talents.main_env.psi_wil_high1
psi_wil_high2 = Talents.main_env.psi_wil_high2
psi_wil_high3 = Talents.main_env.psi_wil_high3
psi_wil_high4 = Talents.main_env.psi_wil_high4
psi_wil_high5 = Talents.main_env.psi_wil_high5

load("/data-possessors/talents/psionic/possession.lua")
load("/data-possessors/talents/psionic/body-snatcher.lua")
load("/data-possessors/talents/psionic/psionic-menace.lua")
load("/data-possessors/talents/psionic/psychic-blows.lua")
load("/data-possessors/talents/psionic/battle-psionics.lua")
load("/data-possessors/talents/psionic/deep-horror.lua")
load("/data-possessors/talents/psionic/ravenous-mind.lua")
