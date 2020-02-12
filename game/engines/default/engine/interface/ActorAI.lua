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

require "engine.class"
require "engine.Actor"
local Map = require "engine.Map"

--- Handles actors artificial intelligence (or dumbness ... ;)
-- @classmod engine.generator.interface.ActorAI
module(..., package.seeall, class.make)

_M.ai_def = {}

--- Level of output detail to the game log for various AIs
-- Higher level -> more detail, level 0 is no additional output, 4 is very verbose
config.settings.log_detail_ai = config.settings.log_detail_ai or 0

--- Define an AI
-- @param[type=string] name a unique AI label
-- @param[type=function] fct a function to invoke (as _M.ai_def[name](self, ...)) when running the ai
function _M:newAI(name, fct)
	_M.ai_def[name] = fct
end

--- Load and run all files in a director to define new AIs
-- Static!
-- @param[type=string] dir directory containing AI definition files
-- loader defines the environment variables:
--		Map = require("engine.Map")
-- 		newAI = function(name, fct) to run _M:newAI(name, fct)
function _M:loadDefinition(dir)
	for i, file in ipairs(fs.list(dir)) do
		if file:find("%.lua$") then
			local f, err = loadfile(dir.."/"..file)
			if not f and err then error(err) end
			setfenv(f, setmetatable({
				Map = require("engine.Map"),
				newAI = function(name, fct) self:newAI(name, fct) end,
			}, {__index=_G}))
			f()
		end
	end
end

function _M:init(t)
	self.ai_state = self.ai_state or {}
	self.ai_target = self.ai_target or {}
	self.ai_actors_seen = self.ai_actors_seen or {}  -- List of actors the AI has had LOS of at least once (regardless of target)
	self:autoLoadedAI()
end

function _M:autoLoadedAI()
	-- Make the table with weak values, so that threat list does not prevent garbage collection
	setmetatable(self.ai_target, {__mode='v'})

	self.ai_actors_seen = self.ai_actors_seen or {}
	setmetatable(self.ai_actors_seen, {__mode='k'})
end

function _M:aiCanPass(x, y)
	-- Nothing blocks, just go on
	if not game.level.map:checkAllEntities(x, y, "block_move", self, nil, true) then return true end

	-- If there is an other actor, check hostility, if hostile, we move to attack
	local target = game.level.map(x, y, Map.ACTOR)
	if target and self:reactionToward(target) < 0 then return true end

	-- If there is a target (not hostile) and we can move it, do so
	if target and self:attr("move_body") then return true end

	return false
end

function _M:aiPathingBlockCheck(x, y, target)

end

--- Move one step to the given target if possible
-- This tries the most direct route, if not available it checks sides and always tries to get closer
function _M:moveDirection(x, y, force)
	if not self.x or not self.y or not x or not y then return false end
	local l = line.new(self.x, self.y, x, y)
	local lx, ly = l()
	if lx and ly then

		-- if we are blocked, try some other way
		if not self:aiCanPass(lx, ly) then
			local dir = util.getDir(lx, ly, self.x, self.y)
			local list = util.dirSides(dir, self.x, self.y)
			local l = {}
			-- Find possibilities
			for _, dir in pairs(list) do
				local dx, dy = util.coordAddDir(self.x, self.y, dir)
				if self:aiCanPass(dx, dy) then
					l[#l+1] = {dx,dy, core.fov.distance(x,y,dx,dy)^2}
				end
			end
			-- Move to closest
			if #l > 0 then
				table.sort(l, function(a,b) return a[3]<b[3] end)
				return self:move(l[1][1], l[1][2], force)
			end
		else
			return self:move(lx, ly, force)
		end
	end
end

--- Responsible for clearing ai target if needed
function _M:clearAITarget()
	if self.ai_target.actor and self.ai_target.actor.dead then self.ai_target.actor = nil end
end

--- Main entry point for AIs
function _M:doAI()
	if self.dead or not self.ai then return end

	-- If we have a target but it is dead (it was not yet garbage collected but it'll come)
	-- we forget it
	self:clearAITarget()

	-- Keep track of actors we've actually seen at least once in our own FOV, NPC calls doFOV right before doAI
	for i,v in ipairs(self.fov.actors_dist) do
		self.ai_actors_seen[v] = true
	end

	-- Update the ai_target table
	local target_pos = self.ai_target.actor and self.fov and self.fov.actors and self.fov.actors[self.ai_target.actor]
	if target_pos then
		local tx, ty = self:aiSeeTargetPos(self.ai_target.actor)
		self.ai_state.target_last_seen=table.merge(self.ai_state.target_last_seen or {}, {x=tx, y=ty, turn=self.fov_last_turn}) -- Merge to keep obfuscation data
	end

	return self:runAI(self.ai)
end

--- Run a specific AI for an actor
-- @param[type=string] ai the name of the ai to run
-- @param ... additional arguments to be passed to the AI
-- @return the result of self.ai_def[ai](self, ...)
function _M:runAI(ai, ...)
	if not (ai and self.ai_def[ai]) then
		print("[runAI] UNDEFINED AI", ai, "for", self.uid, self.name)
		return
	elseif not self.x then
		print("[runAI] CANNOT RUN AI for actor", self.uid, self.name, "(no location)")
		return
	end
	if config.settings.log_detail_ai > 1 then print("[ActorAI:runAI]", self.uid, self.name, "running AI:", ai, ...) end
	return _M.ai_def[ai](self, ...)
end

--- Get coordinates and reference to the current ai target
-- @param[type=table, optional] typ (resolved) targeting parameters
-- @return x coordinate to target
-- @return y coordinate to target
-- @return target actor @ x, y
--	returns the result of typ.talent.onAIGetTarget(self, typ.talent) (if defined)
function _M:getTarget(typ)
	if type(typ) == "table" then
		if typ.talent and typ.talent.onAIGetTarget then -- target according to talent
			return typ.talent.onAIGetTarget(self, typ.talent)
		elseif typ.first_target == "friend" and typ.default_target == self then -- special case: target self
			return self.x, self.y, self
		elseif typ.grid_params then -- target according to AI grid parameters
			return self:getTargetGrid(typ, typ.grid_params)
		end
	end
	-- target current ai_target
	local tx, ty = self:aiSeeTargetPos(self.ai_target.actor)
	local target = game.level.map(tx, ty, Map.ACTOR)
	return tx, ty, target
end

--- Sets the current AI target
-- @param [type=Entity, optional] target the target to set (assign nil to clear the target)
-- @param [type=table, optional] last_seen data for use by aiSeeTargetPos
-- When targeting a new entity, checks self.on_acquire_target and target.on_targeted
function _M:setTarget(target, last_seen)
	local old_target = self.ai_target.actor
	self.ai_target.actor = target
	if last_seen then
		self.ai_state.target_last_seen = last_seen
	else
		local target_pos = target and (self.fov and self.fov.actors and self.fov.actors[target] or {x=target.x, y=target.y}) or {x=self.x, y=self.y} --No FOV: aiSeeTargetPos will assume new target position is ~3 turns old by default (AI_LOCATION_GUESS_ERROR)
		self.ai_state.target_last_seen=table.merge(self.ai_state.target_last_seen or {}, {x=target_pos.x, y=target_pos.y, turn=game.turn}) -- Merge to keep obfuscation data
	end
	if target and target ~= old_target and game.level:hasEntity(target) then
		self:check("on_acquire_target", target)
		target:check("on_targeted", self)
	end
end

--- Called before a talent is used by the AI -- determines if the talent SHOULD (not CAN) be used.
-- Redefine as needed (This version always returns true)
-- @param[type=table] talent the talent (not the id, the table)
-- @param[type=boolean] silent no messages will be outputted
-- @param[type=boolean] fake no actions are taken, only checks
-- @return[1] true to continue
-- @return[2] false to stop
function _M:aiPreUseTalent(talent, silent, fake)
	return true
end

--- AI helper functions

_M.AI_LOCATION_GUESS_ERROR = 3  -- Start position guess errors at ~3 grids

--- Returns the seen coords of the target
-- This will usually return the exact coords, but if the target is only partially visible (or not at all)
-- it will return estimates, to throw the AI a bit off (up to 10 tiles error)
-- @param [type=Entity, optional] target the target we are tracking, defaults to self
-- @param [type=number, optional] add_spread the amount to add to the spread, default 0 (cache is not updated if this param exists)
-- @param [type=number, optional] max_spread the maximum spread used, default 10 (cache is not updated if this param exists)
-- @return x coord to move/cast to
-- @return y coord to move/cast to
function _M:aiSeeTargetPos(target, add_spread, max_spread)
	if not target then return self.x, self.y end
	local tx, ty = target.x, target.y
	local LSeen = self.ai_state.target_last_seen
	local do_cache = not (add_spread or max_spread)  -- Don't update our stored guess if we asked for a special spread
	local add_spread = add_spread or 0
	local max_spread = max_spread or 10
	if type(LSeen) ~= "table" then return tx, ty end
	local spread = 0

	-- Guess Cache turn to update position guess (so it's consistent during a turn)
	-- Set last cache turn before game turn to make sure it gets run the first time.
	LSeen.GCache_turn = LSeen.GCache_turn or game.turn - self.AI_LOCATION_GUESS_ERROR * game.energy_to_act/game.energy_per_tick

	-- Guess Cache known turn for spread calculation (self.ai_state.target_last_seen.turn
	-- can't be used because it's needed by FOV code)
	LSeen.GCknown_turn = LSeen.GCknown_turn or game.turn - self.AI_LOCATION_GUESS_ERROR * game.energy_to_act/game.energy_per_tick

	-- Check if target is currently seen
	local see, chance = self:canSee(target)
	if see and self:hasLOS(target.x, target.y) then -- canSee doesn't check LOS
		LSeen.GCache_x, LSeen.GCache_y = nil, nil
		LSeen.GCknown_turn = game.turn
		LSeen.GCache_turn = game.turn
	else
		if target == self.ai_target.actor and (((LSeen.GCache_turn or 0) + 10 <= game.turn and LSeen.x) or not do_cache) then  -- If we haven't updated cache yet this turn or were not using cache
			if target.last_special_movement and LSeen.GCknown_turn and (target.last_special_movement > LSeen.GCknown_turn) then 
				spread = max_spread  -- If the target has done a "special" movement, such as teleporting a long distance or out of LOS, max out our randomness so we don't cheat chasing them with teleports or whatever
			else
				spread = spread + math.min(max_spread, add_spread + (self:attr("ai_spread_add") or 0) + math.floor((game.turn - (LSeen.GCknown_turn or game.turn)) / (game.energy_to_act / game.energy_per_tick))) -- Limit spread to 10 tiles
			end
			tx, ty = util.bound(tx + rng.range(-spread, spread), 0, game.level.map.w - 1), util.bound(ty + rng.range(-spread, spread), 0, game.level.map.h - 1)
			
			-- Inertial average with last guess: can specify another method here to make the targeting position less random
			if LSeen.GCache_x and not do_cache then -- update guess with new random position
				tx = math.floor(LSeen.GCache_x + (tx-LSeen.GCache_x)/2)
				ty = math.floor(LSeen.GCache_y + (ty-LSeen.GCache_y)/2)
			end

			-- try to find a reasonable spot if target can't be at estimated position
			local act = game.level.map(tx, ty, Map.ACTOR)
			if (act and act ~= target and self:canSee(act)) or (target.canMove and not target:canMove(tx, ty, true)) then
				local nx, ny, grids = util.findFreeGrid(tx, ty, math.max(1, spread), false)
				if not grids then  -- sometimes there is no free grid at low spreads, so try again a bit wider on failure
					nx, ny, grids = util.findFreeGrid(tx, ty, 3, false) 
				end
				if grids then
					for i, grid in ipairs(grids) do
						act = game.level.map(grid[1], grid[2], Map.ACTOR)
						if not act or (act == target or act ~= self and not self:canSee(act)) then
							tx, ty = grid[1], grid[2]
							break
						end
					end
				end
			end
			if do_cache then
				LSeen.GCache_x, LSeen.GCache_y = tx, ty
				LSeen.GCache_turn = game.turn
			else
				-- If were not using cache return early
				return tx, ty
			end
		end
		if LSeen.GCache_x then return LSeen.GCache_x, LSeen.GCache_y end
	end
	return tx, ty -- Fall through to correct coords
end

--- Generate a list of target entities (Actors) a talent MAY affect if used
-- performs a projection of the talent using its targeting and other parameters (but with no effects)
-- @param[type=table] t the talent definition
-- @param[type=Entity, optional] aitarget the AIs target (actor) for the talent, used to target the projection
-- @param[type=table, optional] tg targeting table to use (for interpretation by engine.Target:getType())
--		defaults to self:getTalentTarget(t) or a direct "hit" or "bolt" attack
-- @param[type=boolean, optional] all_targets set true to gather all targets (ignoring selffire, friendlyfire)
-- @param[type=number, optional] ax, ay target coordinates for the talent, defaults to (in order):
--		t.onAIGetTarget(self, t), <tg.x, tg.y>, self:aiSeeTargetPos(aitarget)
-- @return[1] a list of entities that may be affected
-- @return[2] a single entity (actor) that may be affected (use __CLASSNAME to distinguish from list)
-- @return[1] selffire percent chance to affect self, 0 - 100 (based on tg)
-- @return[1] friendlyfire percent chance to affect an ally, 0 - 100 (based on tg)
-- @return[1] the base talent targeting table (if used)
function _M:aiTalentTargets(t, aitarget, tg, all_targets, ax, ay)
	local selffire, friendlyfire, targets = 100, 100
	local log_detail = config.settings.log_detail_ai or 0
	local requires_target = self:getTalentRequiresTarget(t)
	tg = tg or self:getTalentTarget(t)
	if t.onAIGetTarget and not (ax and ay) then -- get talent-specific target
		ax, ay, aitarget = t.onAIGetTarget(self, t)
	elseif not requires_target and not tg then -- no targeting info: target self only
		if log_detail > 2 then print("[aiTalentTargets] ", t.id, "may affect (SELF ONLY)", self.name, self.uid, "at", self.x, self.y) end
		targets, selffire, friendlyfire = self, 100, 100
	end
		
	if not targets then
		-- default direct hit or "bolt" attack
		local typ = engine.Target:getType(tg or {type=util.getval(t.direct_hit, self, t) and "hit" or "bolt"})
		if log_detail > 3 then print("[aiTalentTargets]", t.id, "using targeting parameters", typ) table.print(typ, "\t_typ_") end
		-- special case for some beneficial effects
		if typ.first_target == "friend" and typ.default_target == self and not t.onAIGetTarget then
			targets, selffire, friendlyfire = self, 100, 100
		else -- use targeting info to build target list
			ax, ay = ax or typ.x, ay or typ.y
			if not (ax and ay) then
				ax, ay = self:aiSeeTargetPos(aitarget)
			end
			selffire = typ.selffire and (type(typ.selffire) == "number" and typ.selffire or 100) or 0
			friendlyfire = typ.friendlyfire and (type(typ.friendlyfire) == "number" and typ.friendlyfire or 100) or 0
			if all_targets then	typ.selffire, typ.friendlyfire = 100, 100 end
			targets = {}
			if ax and ay then
				self:project(typ, ax, ay, function(px, py)
					local tgt = game.level.map(px, py, typ.scan_on or Map.ACTOR)
					if tgt and not tgt.dead then
						if log_detail > 2 then print("[aiTalentTargets]", t.id, "may affect", px, py, "actor:", tgt.uid, tgt.name) end
						targets[#targets+1] = tgt
					end
				end)
			end
		end
	end
	return targets, selffire, friendlyfire, tg
end

--- Generate a list of talents that may be used by the AI
-- @param[type=Entity, optional] aitarget target for the AI, used to check range, etc.
-- @param[type=table, optional] t_filter filter passed to self:filterTalent(t, filter)
--		Requires the ActorTalents interface. Only talents that pass the filter may be used.
--		may set flags: allow_dumb_use (ignore talent.no_dumb_use) and ignore_cd (allow talents on cooldown)
-- @param[type=table, optional, defalt: self.talents] t_list list of talent ids to pick from
-- 		if t_list is different than self.talents, it will be pruned of unusable (but not filtered) talent ids
-- @return list of talent id's for talents that can be used
-- talent criteria:
--		talents excluded if talent.no_npc_use or (unless filtered) talent.no_dumb_use are set
--		talent must not be cooling down (unless t_filter.ignore_cd)
--		self:preUseTalent(talent, ...) and self:aiPreUseTalent(talent, ...) must both return true
--		activated talents: checks self:getTalentRequiresTarget(t) or self:canProject(tg, tx, ty)
function _M:aiGetAvailableTalents(aitarget, t_filter, t_list)
	local log_detail = config.settings.log_detail_ai or 0
	if log_detail > 1 then print("[aiGetAvailableTalents]:", self.uid, self.name, "checking talents with target",aitarget and aitarget.uid, aitarget and aitarget.name, "list:", t_list) end
	local avail = {}
	t_list = t_list or self.talents
	local tx, ty = self:aiSeeTargetPos(aitarget)
	local prune, allow_dumb_use, ignore_cd
	if t_filter then allow_dumb_use, ignore_cd = t_filter.allow_dumb_use, t_filter.ignore_cd end
	for tid, _ in pairs(t_list) do
		local t = self:getTalentFromId(tid)
		if t and t.mode ~= "passive" and not t.no_npc_use then
			prune = false
			if (not t.no_dumb_use or allow_dumb_use) and (ignore_cd or not self:isTalentCoolingDown(t)) and (not t_filter or self:filterTalent(t, t_filter)) then
				if self:preUseTalent(t, true, true) and self:aiPreUseTalent(t, true, true) then
					local tx, ty, aitarget = tx, ty, aitarget
					if t.onAIGetTarget then -- handle special targeting (for heals and other friendly effects)
						tx, ty, aitarget = t.onAIGetTarget(self, t)
						if not (tx and ty) then
							tx, ty = self:aiSeeTargetPos(aitarget)
						end
					end
					local requires_target = t.requires_target ~= nil and self:getTalentRequiresTarget(t)
					local tg
					if requires_target then
						tg = self:getTalentTarget(t)
						if tg then -- modify targeting
							if tg == t.target then tg = table.clone(tg) end
							if tg.type ~= "hit" and tg.type ~= "bolt" then
								tg.type = not tg.stop_block and util.getval(t.direct_hit, self, t) and "hit" or "bolt"
							end
						else -- default targeting
							tg = {type=util.getval(t.direct_hit, self, t) and "hit" or "bolt"}	
						end
						tg.range = (self:getTalentRange(t) or 0) + (self:getTalentRadius(t) or 0)
					end
					
					if not tg or aitarget and self:canProject(tg, tx, ty) then
						avail[#avail+1] = tid
						if log_detail > 2 then
							if t.mode == "sustained" then
								print(self.name, self.uid, "::ai may "..(self.sustain_talents[tid] and "de-activate" or "activate").." talent", tid, t.name)
							else
								print(self.name, self.uid, "::ai may use talent", tid, t.name)
							end
						end
					else prune = true
					end
				else -- remove unusable talents from t_list (for additional calls with the same list)
					prune = true
				end
			end
		else prune = true
		end
		if prune and t_list ~= self.talents then
			t_list[tid] = nil
		end
	end
	return avail
end

--- Randomly find a grid, as close to the desired distance from target coordinates as possible 
--	(called by ActorAI:getTarget for NPCs that need to approach/retreat from a target grid)
-- @param[type=table, optional] tg = targeting table determining which grids can be reached via ActorProject:project
--		(defaults to a radius 10 ball at range 1 centered on self)
-- @param[type=table, optional] params parameters for finding acceptable grids:
-- 		center_x, center_y <default: self.x, self.y> = start location for projection (point to move from)
-- 		anchor_x, anchor_y <default: self.x, self.y> = anchor point (point to approach/avoid)
--		anchor_target <default: true> use self.ai_target.actor as the anchor point if possible
-- 		want_range <default: 1> = desired range between destination and anchor point
--		range <default max of tg.radius, tg.range> = maximum range from center point for grids searched
--		max_delta = required change in range - want_range for grids searched (negative -> get closer to want_range)
--		can_move <default: true> -- check self:canMove when determining acceptable grids
-- 		check = function(x, y) that must return true on acceptable grids
--	If tg.target_x, tg.target_y are set, the projection will be performed on the area specified, otherwise, all grids in a circle (radius = max radius or range) centered on center_x, center_y will be searched
-- @return[1] nil if no target grid could be found
-- @return[2] x coordinate of target grid
-- @return[2] y coordinate of target grid
-- @return[2] new range between target grid and anchor point
function _M:getTargetGrid(tg, params)
	local ax, ay, anchor_target, cx, cy, want_range, max_delta, can_move, grid_check
	local log_detail = config.settings.log_detail_ai or 0
	if params then -- set grid search_params
		cx, cy = params.center_x, params.center_y
		ax, ay = params.anchor_x, params.anchor_y
		want_range = params.want_range
		max_delta = params.max_delta
		grid_check = params.check
		can_move = params.can_move
		anchor_target = params.anchor_target
	end
	if anchor_target == nil then anchor_target = true end
	if can_move == nil then can_move = true end
	cx, cy = cx or self.x, cy or self.y
	if anchor_target and not (ax and ay) then
		if self.ai_target.actor then ax, ay = self:aiSeeTargetPos(self.ai_target.actor)	else ax, ay = cx, cy end
	end
	want_range = want_range or 0 -- defaults to closein to anchor point

	-- create a modified targeting table to search grids in a circle
	local tgs = tg and table.clone(tg) or {type="ball", range=0, radius=10}
	if tgs.target_x and tgs.target_y then -- Project with the targeting table provided
	
	else -- or project with a modified targeting table in a circle around the center point
		tgs.type = "ball"
		tgs.radius = params and params.range or math.max((tgs.radius or 0), (tgs.range or 0))
		if tgs.radius == 0 then tgs.radius = want_range + dist end
		tgs.range = 0
	end
	tgs.start_x = tgs.start_x or cx
	tgs.start_y = tgs.start_y or cy
	
	local dist, dist_val = core.fov.distance(cx, cy, ax, ay)

	if log_detail > 1 then print(("[getTargetGrid] searching grids center(%d, %d), anchor(%d, %d), radius %s, want_range:%d vs %d(max_delta:%s)"):format(cx, cy, ax, ay, tgs.radius, want_range, dist, max_delta))
		if log_detail > 2 then print(" working target table:", tgs) table.print(tgs, "\t_tgs_ ") end
	end
	if max_delta then max_delta = math.abs(dist - want_range) + max_delta end -- max diff from want_range allowed
	local grid = {x=cx, y=cy, dist_val=math.huge}
	
	local grid_val = function(px, py, t, self)
		dist = core.fov.distance(ax, ay, px, py)
		if (not max_delta or math.abs(dist - want_range) <= max_delta) and (not can_move or self:canMove(px, py)) then -- allowed grid
			if log_detail > 3 then print("[getTargetGrid] grid at", px, py, "is open, anchor dist:", dist) end
			dist_val = math.abs(dist - want_range) + rng.float(0, .1)
			if dist_val < grid.dist_val and (not grid_check or grid_check(px, py)) then -- better grid
				if log_detail > 2 then print("[getTargetGrid] updating best grid to", px, py, "dist:", dist, "dist_val:", dist_val) end
				grid.x, grid.y, grid.dist, grid.dist_val = px, py, dist, dist_val
			end
		end
	end
	local grids, stop_x, stop_y = self:project(tgs, tgs.target_x or cx, tgs.target_y or cy, grid_val)
	if grid.dist_val < math.huge then
		if log_detail > 1 then print("[getTargetGrid] found target grid at:", grid.x, grid.y, "anchor dist:", grid.dist) end
		return grid.x, grid.y, grid.dist
	elseif log_detail > 1 then print("[getTargetGrid] no acceptable grids found.")
	end
end