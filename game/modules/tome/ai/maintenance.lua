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

--- Defines AIs to allow npcs to perform maintenance actions (outside of combat, generally)
-- @classmod engine.ai.talented

--- Actor performs maintenance activity
--  This performs various actions (mostly out of combat) that do not require a target, such as healing, replenishing resources, moving out of fires, etc.
-- @param t_filter <optional> filter passed to aiGetAvailableTalents (to restrict talent choices)
-- @param t_list <optional> list of talent id's to consider, defaults to self.talents
--  Uses self:aiHealingAction() to find healing actions and self:aiResoourceAction to find resource replenishing actions
--	and resource maintenance actions (self:aiResourceAction(resource_def, t_list) if it is defined)
--		These functions should return an action table specifying a talent to use or an ai to invoke:
--		talent format:	{tid=<talent id>, force_target=<optional target for the talent, defaults to self>}
--		ai format:		{ai=<ai to invoke>, ... <list of arguments to the ai>}
newAI("maintenance", function(self, t_filter, t_list)
	local log_detail = config.settings.log_detail_ai or 0
	local aitarget = self.ai_target.actor
	if log_detail > 0 then print("[ActorAI] turn", game.turn, "Invoking maintenance AI for", self.uid, self.name, "with target", aitarget and aitarget.uid, aitarget and aitarget.name, t_filter, t_list) end
	local done
	local avail = {}

	-- find a healing action to perform if needed
	if self.life/self.max_life < 0.95 then
		avail[#avail+1] = self:aiHealingAction(aitarget, t_filter, t_list)
	end
	
	-- check resources for any management methods defined
	if self.aiResourceAction then
		for res, res_def in ipairs(self.resources_def) do
			if not res_def.talent or self:knowTalent(res_def.talent) then
				avail[#avail+1] = self:aiResourceAction(res_def, t_filter, t_list)
			end
		end
	end
	
	-- check if any sustained talents need to be deactivated
	for tid, is_active in pairs(self.sustain_talents) do
		local t = self:getTalentFromId(tid)

		if (not t_filter or self:filterTalent(t, t_filter)) and self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true) then -- aiPreUseTalent calls aiCheckSustainedTalent
			avail[#avail+1] = {tid=tid, name="maintenance deactivate"}
		end
	end
	
	if log_detail > 1 and #avail > 0 then print("[maintenance AI] actions available:") table.print(avail, "\t_maint_ ") end
	-- randomly pick an available action
	local action
	while #avail > 0 do
		action = rng.tableRemove(avail)
		print("[maintenance AI] turn", game.turn, self.uid, self.name, "selected action:", action.name, action.ai and "ai:"..action.ai or action.tid and "tid:"..action.tid)
if log_detail > 1.4 and config.settings.cheat then game.log("#ORCHID#__%s[%d]maintenance AI picked action: %s (%s)", self.name, self.uid, action.name, action.ai and "ai:"..action.ai or action.tid and "tid:"..action.tid) end -- debugging

		if action.tid then
			done = self:useTalent(action.tid, nil, nil, nil, action.force_target)
		elseif action.ai then
			done = self:runAI(action.ai, unpack(action))
		end
		if done then done = action.tid or action.ai break
		else
			print("[maintenance AI] ACTION FAILED:", action.name, action.ai and "ai:"..action.ai or action.tid and "tid:"..action.tid, unpack(action))
if log_detail > 1.4 and config.settings.cheat then game.log("__%s[%d] #ORANGE# maintenance ACTION FAILED:  %s", self.name, self.uid, action.tid or action.ai) end -- debugging
		end
	end
	if log_detail >= 2 then print("[maintenance AI] completed:", not (done and action) and "NO ACTION" or action.tid and "talent:"..action.tid or action.ai and "AI:"..action.ai, "for", self.name, self.uid, "with target", aitarget and aitarget.name) end
	return done, action
end)

