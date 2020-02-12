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

-- Some special movement AIs

--local Astar = require "engine.Astar"

--- Try to move to a safer location, avoiding damaging and suffocating terrain, uses aiFindSafeGrid (Astar pathing)
-- @param grid <table, optional> table of safe grid and path parameters (from previous calls to aiFindSafeGrid)
-- @param ... <optional>, arguments for self:aiFindSafeGrid(...), to evaluate each grid
-- @see mod.class.interface.ActorAI:aiFindSafeGrid(radius, dam_wt, air_wt, dist_weight, want_closer, ignore_blocked, grid_hazard)
-- stores working grid and path information in self.ai_state.safe_grid (removed when a safe grid is reached)
newAI("move_safe_grid", function(self, grid, ...)
	if self:attr("never_move") then return false end
	local log_detail = config.settings.log_detail_ai or 0
	if log_detail > 0 then
		print("[ActorAI] Invoking move_safe_grid AI turn", game.turn, self.uid, self.name)
if log_detail > 1.4 and config.settings.cheat then game.log("__%s #GREY# (%d, %d) trying to move to a safe grid", self.name, self.x, self.y) end -- debugging
	end
	local dam, air = self:aiGridDamage(lx, ly)
	if dam == 0 and air + self.air_regen > 0 then -- already on a safe spot
		self.ai_state.safe_grid = nil
		return false
	end
	local moved, path = false
	self.ai_state.safe_grid = grid or self.ai_state.safe_grid
	grid = self.ai_state.safe_grid
	if grid then -- try to use previously calculated grid information
		path = grid.path
		if path and #path > 0 and path[1].x and path[1].y then -- try to use previously calculated path
			if log_detail >= 2 then
				print("[move_safe_grid AI]", self.uid, self.name, "Trying previous path to", path[1].x, path[1].y)
	if log_detail > 1.4 and config.settings.cheat then game.log("#GREY#___Trying existing path to (%s, %s)", path[1].x, path[1].y) end -- debugging
			end
			if core.fov.distance(self.x, self.y, path[1].x, path[1].y) == 1 and self:canMove(path[1].x, path[1].y) then moved = self:move(path[1].x, path[1].y) end
			if moved then
				table.remove(path, 1)
				if #path == 0 then self.ai_state.safe_grid = nil else grid.dist = #path end
			end
		end
	end
	if not moved then -- try to find a new safe grid
		grid = self:aiFindSafeGrid(10, ...) -- no enemy --> low time pressure
		if grid then
			if self.x == grid.x and self.y == grid.y then  -- already at best spot
				self.ai_state.safe_grid = nil
			elseif grid.path and #grid.path > 0 then -- try to move closer to safe grid
				self.ai_state.safe_grid = grid
				path = grid.path
				if log_detail >= 2 then
					print("[move_safe_grid AI]", self.uid, self.name, "Trying new path to", path[1].x, path[1].y)
if log_detail > 1.4 and config.settings.cheat then game.log("#GREY#___Using new path to (%s, %s)", path[1].x, path[1].y) end -- debugging
				end
				if core.fov.distance(self.x, self.y, path[1].x, path[1].y) == 1 then moved = self:move(path[1].x, path[1].y) end
				if moved then
					table.remove(path, 1)
					if #path == 0 then self.ai_state.safe_grid = nil else grid.dist = #path end
				end
			end
		end
	end
	return moved
end)

-- attempt to flee while keeping line of sight to the target
-- sets self.ai_state.escape to true if fleeing is possible/attempted
newAI("flee_dmap_keep_los", function(self, fx, fy)
	local can_flee = fx and fy
	if not can_flee then can_flee, fx, fy = self:aiCanFleeDmapKeepLos() end
	local log_detail = config.settings.log_detail_ai or 0
	if can_flee then
		self.ai_state.escape = true
		if log_detail > 0 then
			print("[flee_dmap_keep_los AI] turn", game.turn, self.uid, self.name, "attempting to flee to", fx, fy)
if log_detail > 1.4 and config.settings.cheat then game.log("__%s #GREY# (%d, %d) trying to flee_dmap_keep_los to (%d, %d)", self.name, self.x, self.y, fx, fy) end -- debugging
		end
		return self:move(fx, fy)
	end
	self.ai_state.escape = nil
	if log_detail > 0 then print("[flee_dmap_keep_los AI]", self.uid, self.name, "no move from", self.x, self.y) end
end)
