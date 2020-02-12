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

local _M = loadPrevious(...)

local gainExp = _M.gainExp
function _M:gainExp(value)
	-- Store exp for later
	if self:hasEffect(self.EFF_POSSESSION) then
		local eff = self:hasEffect(self.EFF_POSSESSION)
		eff.exp_to_recover = eff.exp_to_recover + value
		return
	end
	return gainExp(self, value)
end

return _M

