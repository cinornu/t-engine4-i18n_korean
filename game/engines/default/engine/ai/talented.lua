-- TE4 - T-Engine 4
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

--- Defines AIs that can use talents, either smartly or "dumbly"
-- @classmod engine.ai.talented

--- Randomly pick a talent to use
-- @return[1] talent id used
-- @return[2] false if no talent was used
-- @return table of available talents
newAI("dumb_talented", function(self, filter)
	local log_detail = config.settings.log_detail_ai or 0
	if log_detail > 0 then print("[ActorAI]Invoking dumb_talented AI turn", game.turn, self.uid, self.name) end
	-- Find available talents
	local avail = {}
	local aitarget = self.ai_target.actor

	local tx, ty = self:aiSeeTargetPos(aitarget)
	
	for tid, _ in pairs(self.talents) do local t = self:getTalentFromId(tid) if t then
		local tx, ty, aitarget = tx, ty, aitarget
		if t.onAIGetTarget then -- handle special targeting (for heals and other friendly effects here)
			tx, ty, aitarget = t.onAIGetTarget(self, t)
			if not (tx and ty) then
				tx, ty = self:aiSeeTargetPos(aitarget)
			end
		end

--		print(self.name, self.uid, "dumb ai talents can try use", t.name, tid, "::", t.mode, not self:isTalentCoolingDown(t), target_dist <= self:getTalentRange(t), self:preUseTalent(t, true), self:canProject({type="bolt"}, self.ai_target.actor.x, self.ai_target.actor.y))
		-- For dumb AI assume we need range and LOS
		-- No special check for bolts, etc.
		local total_range = (self:getTalentRange(t) or 0) + (self:getTalentRadius(t) or 0)
		local tg = {type=util.getval(t.direct_hit, self, t) and "hit" or "bolt", range=total_range}
		if t.mode == "activated" and not t.no_npc_use and not t.no_dumb_use and
		   not self:isTalentCoolingDown(t) and self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true) and
		   (not self:getTalentRequiresTarget(t) or self:canProject(tg, tx, ty)) then
			avail[#avail+1] = tid
			if log_detail >= 2 then print(self.uid, self.name, "\tdumb_talented AI can use", tid, t.name) end
		elseif t.mode == "sustained" and not t.no_npc_use and not t.no_dumb_use and not self:isTalentCoolingDown(t) and
		   self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true)
		   then
			avail[#avail+1] = tid
			if log_detail >= 2 then print(self.uid, self.name, "\tdumb_talented AI can activate", tid, t.name) end
		end
	end end	
	
	local tid = false
	if #avail > 0 then
		if log_detail > 1 then print("[dumb_talented AI] available talents for", self.uid, self.name) table.print(avail, "\t") end
		tid = avail[rng.range(1, #avail)]
		print("[dumb_talented AI] chooses for", self.uid, self.name, tid)
		if not self:useTalent(tid) then
			print(self.uid, self.name, "[dumb_talented AI] ** FAILED ** to use", tid)
			tid = false 
		elseif log_detail > 0 then print(self.uid, self.name, "[dumb_talented AI] successfully used", tid)
		end
	elseif log_detail > 0 then print("[dumb_talented AI] NO TALENTS AVAILABLE for", self.uid, self.name)
	end
	return tid, avail
end)

--- Randomly use a talent, trying alternate talents if one fails (up to 5 total)
-- @param t_filter <optional> = filter passed to self:aiGetAvailableTalents to restrict talent choices
-- @param t_list, <optional, default self.talents> list of talent id's to pick from, passed to self:aiGetAvailableTalents
-- @return talent id used or false
-- @return table of remaining available talents
newAI("improved_talented", function(self, t_filter, t_list)
	local log_detail = config.settings.log_detail_ai or 0
	-- Find available talents
	local aitarget = self.ai_target.actor
	if log_detail > 0 then print("[ActorAI] Invoking improved_talented AI turn", game.turn, self.uid, self.name, "target", aitarget and aitarget.uid, aitarget and aitarget.name, t_filter, t_list) end
	local avail = self:aiGetAvailableTalents(aitarget, t_filter, t_list)
	if log_detail > 1 and #avail > 0 then print("[improved_talented AI] available talents:") table.print(avail, "\t_ ") end
	local tid, attempt = false, 1
	while #avail > 0 and attempt < 5 do
		tid = rng.tableRemove(avail)
		print("[improved_talented AI] chooses for", self.uid, self.name, tid)
		if log_detail > 1.4 and config.settings.cheat then game.log("#ORCHID#__[%d]%s improved talented AI picked talent[att:%d, turn %s]: %s", self.uid, self.name, attempt, game.turn, tid) end-- debugging

		local success = self:useTalent(tid, self)
		if success then
			if log_detail > 2 then
				print("[improved_talented AI]### SUCCESSFUL TALENT returned:", success)
			end
			return tid, avail
		else
			print("[improved_talented AI]### FAILED TALENT returned:", success)
if log_detail > 1.4 and config.settings.cheat then game.log("__[%d]%s#ORANGE# ACTION FAILED:  %s, %s", self.uid, self.name, tid, success) end -- debugging
			tid = false
		end
		attempt = attempt + 1
	end
	if log_detail > 0 then print("[improved_talented AI] NO TALENTS AVAILABLE for", self.uid, self.name)
if aitarget and log_detail > 1.4 and config.settings.cheat then game.log("#SLATE#__%s[%d] improved talented AI No talents available [att:%d, turn %s]", self.name, self.uid, attempt, game.turn) end -- debugging
	end
	return tid, avail
end)

--- Attempts to use a talent (chance in self.ai_state.talent_in <default 6) or move if a hostile target is acquired
-- @return true if an action was performed
newAI("dumb_talented_simple", function(self)
	if config.settings.log_detail_ai > 0 then print("[ActorAI]Invoking dumb_talented_simple AI turn", game.turn, self.uid, self.name) end
	if self:runAI(self.ai_state.ai_target or "target_simple") then
		-- One in "talent_in" chance of using a talent
		local used_talent
		if (not self.ai_state.no_talents or self.ai_state.no_talents == 0) and rng.chance(self.ai_state.talent_in or 6) and self:reactionToward(self.ai_target.actor) < 0 then
			used_talent = self:runAI("dumb_talented")
			-- print("dumb ai used talent", used_talent)
		end
		if not self.energy.used then
			self:runAI(self.ai_state.ai_move or "move_simple")
		end
		if used_talent then self.energy.used = true end -- make sure NPC can use another talent after instant talents
		return true
	end
end)
