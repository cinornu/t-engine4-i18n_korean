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

--- Use the talented AI to engage enemies
-- Attempts to acquire a hostile target
-- With a hostile target: attempts to use a talent (chance in self.ai_state.talent_in <default 6) or move
-- Without a hostile target: manages sustained talents only
-- performs self-maintenance (chance in self.ai_state.maintenance_in <default 3>) if no other action performed
-- @param t_filter <optional> = filter passed to self:aiGetAvailableTalents to restrict talent choices
-- @param t_list, <optional, default self.talents> list of talent id's to pick from, passed to self:aiGetAvailableTalents
-- self.ai_state parameters:
--		.ai_target <default "target_simple"> = ai to invoke to find a target
--		.talent_in <default 6) = rng.chance to invoke the improved_talented ai(requires a hostile target)
--		.maintenance_in <default 3> = rng.chance to invoke the maintenance ai before trying the movement ai
--		.ai_maintenance <default "maintenance">, maintenance ai to use
--		.ai_move <default "move_simple"> = ai to invoke for movement (w.r.t. the target)
--		.no_talents = 0 or true -> never invoke the improved_talented ai or talents with the maintenance ai
-- @return true if an action was performed
newAI("improved_talented_simple", function(self, t_filter, t_list)
	local log_detail = config.settings.log_detail_ai or 0
	local has_target, did_action, moved = self:runAI(self.ai_state.ai_target or "target_simple")
	if log_detail > 0 then print("[ActorAI] Invoking improved_talented_simple AI turn", game.turn, self.uid, self.name, self.x, self.y, "with target", has_target and self.ai_target.actor.name)
--game.log("#LIGHT_BLUE#__[talented]Invoking improved talented AI for %s[%s]", self.name, self.uid, "with target", has_target and self.ai_target.actor.name)
if has_target and log_detail > 1.4 and config.settings.cheat then game.log("%s__turn %d: Invoking improved_talented_simple AI for [%s]%s(%d,%d) target:[%s]%s %s", has_target and "#LIGHT_BLUE#" or "#GREY#", game.turn, self.uid, self.name, self.x, self.y, self.ai_target.actor and self.ai_target.actor.uid, self.ai_target.actor and self.ai_target.actor.name, self.ai_target.actor and ("STP(%s,%s)"):format(ax, ay) or "") end -- debugging
	end
	t_list = t_list or table.clone(self.talents) -- clone to allow pruning of talents by aiGetAvailableTalents

	if (not self.ai_state.no_talents or self.ai_state.no_talents == 0) then
		-- One in "talent_in" chance of using a talent
		if has_target and rng.chance(self.ai_state.talent_in or 6) and self:reactionToward(self.ai_target.actor) < 0 then -- use a talent (in combat)
			did_action = self:runAI("improved_talented", t_filter, t_list)
			if log_detail > 2 then print("[Actor AI] improved_talented AI returned:", did_action) end
		elseif not has_target then -- out of combat, manage sustains only
			if log_detail >= 2 then print("[improved_talented_simple AI] checking SUSTAINS for ", self.uid, self.name) end
			local t_filter = t_filter and table.clone(t_filter) or {} t_filter.mode = "sustained"
			did_action = self:runAI("improved_talented", t_filter, t_list)
		end
		if did_action then self.energy.used = true end -- make sure NPC can use another talent after instant talents
	end
	if not self.energy.used then
		if not has_target or self.ai_state.safe_grid or rng.chance(self.ai_state.maintenance_in or 3) then -- possibly do maintenance (automatic without an ai target or while moving from bad terrain)
			did_action = self:runAI(self.ai_state.ai_maintenance or "maintenance", t_filter, t_list)
			if log_detail > 2 then print("[Actor AI] improved_talented_simple -> maintenance AI returned:", did_action) end
		end
		if not self.energy.used then
			if log_detail >= 2 then print("[improved_talented_simple] std move for", self.name, self.uid, "at", self.x, self.y) end
			moved = self:runAI(self.ai_state.ai_move or "move_simple")
		end
	end
	if did_action then self.energy.used = true end -- make sure NPC can take another action after doing something instant

	if log_detail >= 2 then print("[ActorAI] improved_talented_simple AI completed for", self.uid, self.name, "with target:", self.ai_target.actor and self.ai_target.actor.name) end
	return did_action or moved
end)

