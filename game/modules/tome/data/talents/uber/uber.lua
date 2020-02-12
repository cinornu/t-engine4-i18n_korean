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

newTalentType{ hide = true, type="uber/strength", name = _t"strength", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/dexterity", name = _t"dexterity", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/constitution", name = _t"constitution", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/magic", name = _t"magic", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/willpower", name = _t"willpower", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/cunning", name = _t"cunning", description = _t"Ultimate talents you may only know one." }
newTalentType{ hide = true, type="uber/other", name = _t"other", description = _t"Ultimate talents you may only know one." }


knowRessource = function(self, r, v)
	local cnt = 0
	for tid, l in pairs(self.talents) do
		local t = self:getTalentFromId(tid)
		if rawget(t, r) or rawget(t, "sustain_"..r) then cnt = cnt + l end
	end
	return cnt >= v
end

uberTalent = function(t)
	t.type = {"uber/strength", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.level = 25
	t.require.stat = t.require.stat or {}
	t.require.stat.str = 50
	t.ai_level = function(self, t) return self:getStr()/10 end
	newTalent(t)
end
load("/data/talents/uber/str.lua")

uberTalent = function(t)
	t.type = {"uber/dexterity", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.stat = t.require.stat or {}
	t.require.level = 25
	t.require.stat.dex = 50
	t.ai_level = function(self, t) return self:getDex()/10 end
	newTalent(t)
end
load("/data/talents/uber/dex.lua")

uberTalent = function(t)
	t.type = {"uber/constitution", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.stat = t.require.stat or {}
	t.require.level = 25
	t.require.stat.con = 50
	t.ai_level = function(self, t) return self:getCon()/10 end
	newTalent(t)
end
load("/data/talents/uber/const.lua")

uberTalent = function(t)
	t.type = {"uber/magic", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.stat = t.require.stat or {}
	t.require.level = 25
	t.require.stat.mag = 50
	t.ai_level = function(self, t) return self:getMag()/10 end
	newTalent(t)
end
load("/data/talents/uber/mag.lua")

uberTalent = function(t)
	t.type = {"uber/willpower", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.level = 25
	t.require.stat = t.require.stat or {}
	t.require.stat.wil = 50
	t.ai_level = function(self, t) return self:getWil()/10 end
	newTalent(t)
end
load("/data/talents/uber/wil.lua")

uberTalent = function(t)
	t.type = {"uber/cunning", 1}
	t.uber = true
	t.require = t.require or {}
	t.require.level = 25
	t.require.stat = t.require.stat or {}
	t.require.stat.cun = 50
	t.ai_level = function(self, t) return self:getCun()/10 end
	newTalent(t)
end
load("/data/talents/uber/cun.lua")
