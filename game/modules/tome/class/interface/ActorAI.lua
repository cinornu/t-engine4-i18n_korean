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
--local Base = require "engine.interface.ActorAI"
local DamageType = require "engine.DamageType"
local Actor = require "mod.class.Actor"
local ActorResource = require "engine.interface.ActorResource"
local Astar = require "engine.Astar"
local Talents = require "engine.interface.ActorTalents"

--- Additional AI functions
--module(..., package.seeall, class.inherit(Base))

module(..., package.seeall, class.inherit(engine.interface.ActorAI))

--config.settings.log_detail_ai = 0 -- debugging general output for AI messages

--- dgdgdgdgdg REMOVE THIS SECTION after the transitional AI phase ---
-- soft switch enabling new AIs during transition phase
-- set true to redirect "tactical" to "improved_tactical" and "dumb_talented_simple" to "improved_talented_simple"
config.settings.ai_transition = true -- set for transition AIs

--- Overloaded to force certain NPC's to use the new AI's
--- Run an AI for an actor
-- @param ai the name of the ai to run
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

	-- allows Actor specific log detail level
	local old_detail = config.settings.log_detail_ai
	if self.log_detail_ai ~= nil then config.settings.log_detail_ai = self.log_detail_ai end
if config.settings.ai_transition then
	-- debugging: force use of "improved_tactical" in place of "tactical" and "improved_talented_simple" in place of "dumb_talented_simple" for all actors
	if ai == "tactical" then ai = "improved_tactical"
	elseif ai == "dumb_talented_simple" then ai = "improved_talented_simple"
	end -- debugging end
	
	-- force use of "improved_tactical" in place of "tactical" for randbosses
	if self.randboss and ai == "tactical" then ai = "improved_tactical"
	-- force use of "improved_talented_simple" in place of "dumb_talented_simple" for elites
	elseif self.rank >= 3 and ai == "dumb_talented_simple" then ai = "improved_talented_simple"
	end
end
	if config.settings.log_detail_ai > 2.5 then print("[ActorAI:runAI(transitional)] turn:", game.turn, self.uid, self.name, "running AI:", ai, ...) end
	local ret1, ret2, ret3 = _M.ai_def[ai](self, ...)
	config.settings.log_detail_ai = old_detail
	return ret1, ret2, ret3
end
--- dgdgdgdgdg END TRANSITIONAL CODE section ---

--- Master list of tactics defined for the tactical AI
-- Each TACTIC is assigned a benefit coefficient (multiplier) according to the nature of the TACTIC (how beneficial it is to its intended target(s)):
-- val > 0 (usually +1) -> BENEFICIAL: good when it affects self and allies, bad when it affects foes
-- val < 0 (usually -1) -> HARMFUL: bad when it affects self and allies, good when it affects foes
_M.AI_TACTICS = {attackarea=-1, areaattack=-1, attack=-1, closein=-1, escape=-1, surrounded=-1,  disable=-1, attackall=-1,
	cure=1, heal=1, special=1, defend=1, protect=1, ammo=1, feedback=1, buff=1, none=0,
	_no_tp_cache=false, -- non-TACTIC flag: do not store results in the turn_procs cache
	__wt_cache_turns=false -- non-TACTIC setting: maximum number of game turns to store tactical weight cache
	}

--- Additional methods for calculating WANT VALUEs for the tactical AI
-- Each should be a number or a function(self, want, actions, avail, fight_data)
-- calculated WANT VALUEs should range from -10 to +10, and be 0 or negative when the TACTIC isn't useful
-- See the tactical AI for an explanation of want values and the actions, avail, and fight_data tables
_M.AI_TACTICS_WANTS = {}

--- Default bonus per character level for AI actions in the tactical AI
--  AI action tactical weights are multiplied by (1+self.level*self.AI_TACTICAL_AI_ACTION_BONUS)
--  See --== Final Action Evaluation and Selection ==-- in the tactical AI
_M.AI_TACTICAL_AI_ACTION_BONUS = 0.02

--- Default bonus per (raw) talent level for Talent actions in the tactical AI
--  AI talent TACTICAL WEIGHTs are multiplied by (1+self.talents[tid]*self..AI_TACTICAL_TALENT_LEVEL_BONUS)
--  See --== Final Action Evaluation and Selection ==-- in the tactical AI
_M.AI_TACTICAL_TALENT_LEVEL_BONUS = 0.2

--- size of random weight bonus added to actions by the tactical AI (higher makes actions more random)
-- 0.5 --> a bonus of 0% to 50% added to the TACTICAL SCORE for each action
-- replaced by ai_state.tactical_random_range if present
_M.AI_TACTICAL_RANDOM_RANGE = 0.5

--- Maximum # of game turns before refreshing advanced tactical functions cached data for all talents
-- Affects cached actor weights for talent tactics (aiTalentTactics)
-- (100 game turns == 10 actions for normal global speed)
_M.AI_TACTICAL_CACHE_TURNS = 100

--- AI resource parameters
_M.AI_RESOURCE_LEVEL_TRIGGER = 0.9 -- Minimum resource level (fraction of maximum capacity) before the AI will try to replenish it (used by aiResourceAction)
_M.AI_RESOURCE_USE_EST = 0.05 -- Fraction of standard resource pool assumed to be used each turn by the AI, affects various resource valuations
_M.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD = 10 -- (for simple AI's) Minimum (estimated) number of turns a sustained talent can be maintained below which the AI may deactivate it or (possibly) refuse to activate it

--[[
-- Consider a variable to allow dumb AI's to consult talent tactical tables?
-- This would allow actors with simple AI's to evaluate tactical tables when picking talents
_M.AI_SIMPLE_USE_TACTICAL_VALUES = false
--]]

local tactical_ai_init = false

--- Initialize some AI data (after addons, etc. from tome.load, mostly for optimization)
-- parses each talent definition
-- adds resource TACTICs (+1 benefit coefficient) for each defined resource
-- outputs a summary of all TACTICs detected in talent tactical tables
function _M.AI_InitializeData()
	print("[AI_InitializeData] updating talent definitions and data for AIs")
	-- update master tactics list for resources
	for i, res_def in ipairs(ActorResource.resources_def) do
		_M.AI_TACTICS[res_def.short_name] = _M.AI_TACTICS[res_def.short_name] or 1
	end
	for tid, t in pairs(Talents.talents_def) do -- parse each talent, setting some values
		_M.aiParseTalent(t)
	end
	tactical_ai_init = true
	print("[AI_InitializeData] DETECTED TALENT TACTICS:")
	print("\tTACTIC\t\t\tBENEFIT\t\tWANT CALCULATION")
	for tact, _ in pairs(Talents.ai_tactics_list) do
		local want = "AI auto"
		local swant = _M.AI_TACTICS_WANTS[tact]
		_M.AI_TACTICS[tact] = _M.AI_TACTICS[tact] == nil and -1 or _M.AI_TACTICS[tact]
		if swant then
			if type(swant) == "function" then
				local info = debug.getinfo(swant)
				want = "function @:"..tostring(info.short_src).." line "..tostring(info.linedefined)
			else
				want = "constant:"..tostring(swant)
			end
		end
		print(("\t* %-15s\t%s\t\t%s"):format(tact, tostring(_M.AI_TACTICS[tact]), want))
	end
end

--- parse a talent, adding some values for later AI use
-- @param t a talent definition
-- @param who (optional) target actor
-- adds the tables:
-- _may_restore_resources if the talent has (possible) negative resource costs
-- _may_drain_resources if the talent is sustainable and has (possible) resource drains defined
-- sets a flag, _may_heal if the talent may (possibly) heal
function _M.aiParseTalent(t, who)
	t._ai_parsed = false
	if t.mode == "passive" or t.is_object_use then -- simple AI's will not consider object use talents
		t._ai_parsed = true
	else --  debugging: Note: doesn't look for t.tactical_imp field
		local tactical
		if type(t.tactical) == "function" then
			local ok
			ok, tactical = pcall(t.tactical, who, t, who) -- (test function with who as target, only looking for fields)
			if not ok then -- defer parsing without proper input
				print("[aiParseTalent] FAILED TO PARSE tactical table function for", t.id, who and who.uid, who and who.name)
				print("   => because of error", tactical)
				t._ai_parsed = nil return
			end
		else tactical = t.tactical
		end
		for res, res_def in ipairs(ActorResource.resources_def) do
			local r_name = res_def.short_name
			local may_restore = false
			 -- look for the resource in the tactical table (to be evaluated later)
			if tactical then
				if tactical[r_name] or tactical.self and type(tactical.self) == "table" and tactical.self[r_name] then
					may_restore = true
				end
			end
			-- examine resource costs
			if not may_restore and t[r_name] then
				may_restore = type(t[r_name]) == "function" or t[r_name] < 0
			end
			if may_restore then
				t._may_restore_resources = t._may_restore_resources or {}
				t._may_restore_resources[r_name] = true
--print("[aiParseTalent] talent", t.short_name, t.name, "may restore resource", res_def.name) -- debugging
			end
			if t.mode == "sustained" then -- look for resource drains
				if t[res_def.drain_prop] then
--print("[aiParseTalent] talent", t.short_name, t.name, "sustain may drain resource", res_def.name) -- debugging
					t._may_drain_resources = t._may_drain_resources or {}
					t._may_drain_resources[r_name] = true
				end
			end
		end
		-- look for healing
		if t.is_heal or tactical and (tactical.heal or tactical.self and type(tactical.self) == "table" and tactical.self.heal) then
--print("[aiParseTalent] talent", t.short_name, t.name, "may heal") -- debugging
			t._may_heal = true
		end
		t._ai_parsed = true
	end
end

-- Special attributes contributing to an actor's defensive hash value for the tactical AI (self.aiDHash)
-- These directly affect the TACTICAL VALUEs of targeted actors (defenders)
--		changes cause the cache reset
-- used by Actor:onTemporaryValueChange(prop, v, base)
-- The defensive hash value is used as a fingerprint by aiTalentTactics when updating its cache
-- Update as needed (for custom tactics in the tactical AI)
_M.aiDHashProps = {}
local DHashProps = {"aiDHashvalue", "fly", "levitation", "never_move", "encased_in_ice", "stoned", "invulnerable", "negative_status_effect_immune", "mental_negative_status_effect_immune", "physical_negative_status_effect_immune", "spell_negative_status_effect_immune", "lucid_dreamer"}
for typ, tag in pairs(Actor.StatusTypes) do
	table.insert(DHashProps, type(tag) == "string" and tag or typ .. "_immune")
end
for i, prop in ipairs(DHashProps) do -- use random values to keep these variables independent
	_M.aiDHashProps[prop] = rng.float(0, 1)
end

-- Special attributes contributing to an actor's offensive hash value for the tactical AI (self.aiOHash)
-- These directly affect the TACTICAL VALUEs of actors targeting other actors (attackers)
--		changes cause the cache reset
-- used by Actor:onTemporaryValueChange(prop, v, base)
-- The offensive hash value is used as a fingerprint by aiTalentTactics when updating its cache
-- Update as needed (for custom tactics in the tactical AI)
_M.aiOHashProps = {}
local OHashProps = {"aiOHashvalue", "disarmed", "additional_melee_chance"}
for i, prop in ipairs(OHashProps) do -- use random values to keep these variables independent
	_M.aiOHashProps[prop] = rng.float(0, 1)
end

--- Substitute DamageTypes
-- These are predefined methods that can replace DamageType labels in tactical tables.
-- Each is a function(self, t, target) that returns: DamageType label or status condition tag, tactical weight multiplier
-- Those defined here are primarily focused on weapons and weapon skill, but more can be added for other effects:
-- "weapon" -- returns mainhand or unarmed weapon DamageType and up to 2x multiplier based on weapon skill
--		returns the result of the "archery" function if the talent is an archery talent
-- "offhand" -- as "weapon" but for offhand (offhand penalty applies, 0 multiplier if unarmed)
-- "archery" -- returns the ammo DamageType and up to 2x multiplier based on launcher weapon skill (or 0 if no archery weapon/ammo)
-- "sleep" -- checks the target's "lucid_dreamer" attribute
_M.aiSubstDamtypes = {
	weapon = function(self, t, target) -- get mainhand DamageType and special weight modifier (or switch to archery)
		if self:getTalentSpeedType(t) == "archery" then return self.aiSubstDamtypes.archery(self, t, target) end
		local wt, DType = 0
		local mh, oh
		if self:attr("warden_swap") then
			mh, oh = self.main_env.doWardenPreUse(self, "dual", true)
		end
		mh = mh or not self:attr("disarmed") and table.get(self:getInven("MAINHAND"), 1)
		mh = mh and not mh.archery and (mh.combat or mh.special_combat) or self:getObjectCombat(nil, "barehand")
		DType = mh.damtype or DamageType.PHYSICAL
		wt = self:combatGetTraining(mh)
		wt = wt and self:combatLimit(self:getTalentLevel(wt), 2, 1, 0, 1.25, 1/self.AI_TACTICAL_TALENT_LEVEL_BONUS) or 1
		local gwf = self:hasEffect(self.EFF_GREATER_WEAPON_FOCUS)
		if gwf then -- adjust weight to account for extra blows from greater weapon focus
			wt = wt*(1 + gwf.chance/100)
		end
		return DType, wt
	end,
	offhand = function(self, t, target) -- get offhand DamageType and special weight modifier (or switch to archery)
		-- check for archery talent
		if self:getTalentSpeedType(t) == "archery" then return self.aiSubstDamtypes.archery(self, t, target, true) end
		local wt, DType = 0, "PHYSICAL"
		local mh, oh
		if self:attr("warden_swap") then
			mh, oh = self.main_env.doWardenPreUse(self, "dual", true)
		end
		oh = oh or not self:attr("disarmed") and table.get(self:getInven("OFFHAND"), 1)
		oh = oh and not oh.archery and (oh.combat or oh.special_combat)
		if oh then
			DType = oh.damtype or DamageType.PHYSICAL
			wt = self:combatGetTraining(oh)
			wt = (wt and self:combatLimit(self:getTalentLevel(wt), 2, 1, 0, 1.25, 1/self.AI_TACTICAL_TALENT_LEVEL_BONUS) or 1)*self:getOffHandMult(oh)
			local gwf = self:hasEffect(self.EFF_GREATER_WEAPON_FOCUS)
			if gwf then -- adjust weight to account for extra blows from greater weapon focus
				wt = wt*(1 + gwf.chance/100)
			end
		end
		return DType, wt
	end,
	archery = function(self, t, target, offhand) -- get archery DamageType and special weight modifier
		local wt, DType = 0, "PHYSICAL"
		local launcher, ammo, oh
		if self:attr("warden_swap") then
			launcher, ammo, oh = self.main_env.doWardenPreUse(self, "bow", true)
		end
		if not launcher or not ammo then
			launcher, ammo, oh = self:hasArcheryWeapon()
		end
		if offhand then launcher = oh end
		if launcher and ammo then
			wt = self:combatGetTraining(launcher.combat)
			wt = wt and self:combatLimit(self:getTalentLevel(wt), 2, 1, 0, 1.25, 1/self.AI_TACTICAL_TALENT_LEVEL_BONUS) or 1
			local recurse = launcher.combat and launcher.combat.talent_on_hit and launcher.combat.talent_on_hit.T_SHOOT and launcher.combat.talent_on_hit.T_SHOOT.chance
			if recurse then wt = wt*(1 + recurse/100) end
			DType = ammo.combat.damtype or DamageType.PHYSICAL
		end
		return DType, wt
	end,
	sleep = function(self, t, target) -- Sleep immunity is modified by the "lucid_dreamer" attribute
		return sleep, target:attr("lucid_dreamer") and 0 or 1
	end
}

-- Still count grids we can potentially shove or swap our way into
function _M:aiPathingBlockCheck(x, y, actor_checking)
	return not self:block_move(x, y, actor_checking) or not actor_checking.canBumpDisplace or not actor_checking:canBumpDisplace(self)
end

-- Can an NPC shove or swap positions with a space occupied by another NPC?
function _M:canBumpDisplace(target)
	if target == game.player then return end
	if target.rank >= self.rank then return false end
	if not target.x then return end
	if self.never_move or target.never_move or target.cant_be_moved then return false end
	if not self.move_others then return false end
	return true
end

--- Move one step towards the given coordinates if possible
-- This tries the most direct route, if not available it checks sides and always tries to get closer
-- If a friendly actor is in the way, try to get it to move (shove_pressure)
-- @param[type=int] x coordinate of the destination
-- @param[type=int] y coordinate of the destination
-- @param[type=boolean] force setting passed to self:move, ignores self.energy
function _M:moveDirection(x, y, force)
	if not (x and y and self.x and self.y) or not force and self:attr("never_move") then return false end
	local log_detail = config.settings.log_detail_ai or 0
	local l = line.new(self.x, self.y, x, y)
	local lx, ly = l()
	if lx and ly then
		-- aiCanPass fails for friendly targets
		if self:aiCanPass(lx, ly) then return self:move(lx, ly, force) end
	
		-- if blocked, evaluate other possible directions
		local l = {}

		-- Find all possible directions to move, including towards friendly targets
		local target = game.level.map(lx, ly, engine.Map.ACTOR)
		if target and self:reactionToward(target) > 0 and self.canBumpDisplace and self:canBumpDisplace(target) then l[#l+1] = {lx,ly, core.fov.distance(x,y,lx,ly)/2+rng.float(0, .1), target} end -- Add straight ahead if shoveable
		local dir = util.getDir(lx, ly, self.x, self.y)
		local sides = util.dirSides(dir, self.x, self.y)
		for _, dir in pairs(sides) do -- sides
			local dx, dy = util.coordAddDir(self.x, self.y, dir)
			if log_detail > 3 then print("[moveDirection] checking grid", dx, dy) end
			if self:aiCanPass(dx, dy) then
				l[#l+1] = {dx,dy, core.fov.distance(x,y,dx,dy)}
			else
				target = game.level.map(dx, dy, engine.Map.ACTOR)
				if target and self:reactionToward(target) > 0 and self.canBumpDisplace and self:canBumpDisplace(target) then
					l[#l+1] = {dx,dy, core.fov.distance(x,y,dx,dy)/2+rng.float(0, .1), target}
				end
			end
		end

		-- Find the best (most direct) direction
		if #l > 0 then
			table.sort(l, function(a,b) return a[3]<b[3] end)
			local target = l[1][4]
			if target then -- Try to shove the blocker aside before trying to swap, this way we favor the NPCs "spreading out"
				if log_detail > 3 then print("[moveDirection]", self.uid, self.name, "attempting to shove", target.name, l[1][1], l[1][2]) end
				local dir = util.getDir(target.x, target.y, self.x, self.y)
				local sides = util.dirSides(dir, target.x, target.y)
				local check_order = {}
				if rng.percent(50) then
					table.insert(check_order, "left")
					table.insert(check_order, "right")
				else
					table.insert(check_order, "right")
					table.insert(check_order, "left")
				end
				if rng.percent(50) then
					table.insert(check_order, "hard_left")
					table.insert(check_order, "hard_right")
				else
					table.insert(check_order, "hard_right")
					table.insert(check_order, "hard_left")
				end
				for _, side in ipairs(check_order) do
					local check_dir = sides[side]
					local sx, sy = util.coordAddDir(target.x, target.y, check_dir)
--	print("[moveDirection] checking shove target pos", check_dir, sx, sy)
					-- move the friendly target if possible
					if target:canMove(sx, sy) and target:move(sx, sy, true) then
						print("[moveDirection]", self.uid, self.name, "moved (shove)", target.uid, target.name, "to", sx, sy)
						self:logCombat(target, "#Source# shoves #Target# aside.")
						return self:move(l[1][1], l[1][2], force)
--	print("attempting to move", self.name, "to", l[1][1], l[1][2])
					end
				end

				-- We failed to shove the blocker, so swap positions with them instead via the default bumpInto behavior
				-- Since swapping only happens with a rank advantage we don't need to worry about swapping back and forth
				return self:move(l[1][1], l[1][2], force)
			else
				return self:move(l[1][1], l[1][2], force)
			end
		end
	end
end

--- Called before a talent is used by (simple) AIs -- determines if the talent SHOULD (not CAN) be used.
-- @param[type=table] talent the talent definition
-- @param[type=boolean] silent no messages will be outputted
-- @param[type=boolean] fake no actions are taken, only checks
-- @return[1] true to continue
-- @return[2] false to stop
-- talent.on_pre_use_ai (if present) always controls
-- checks aiCheckSustainedTalent for sustained talents
function _M:aiPreUseTalent(talent, silent, fake)
	-- don't recalculate results during a turn
	local ret = self.turn_procs.aiPreUseTalent and self.turn_procs.aiPreUseTalent[talent.id]
	if ret == nil then
		if talent.on_pre_use_ai then ret = talent.on_pre_use_ai(self, talent, silent, fake)
		elseif talent.mode == "sustained" then
			ret = self:aiCheckSustainedTalent(talent)
		else ret = true
		end
		ret = ret or false
		self.turn_procs.aiPreUseTalent = self.turn_procs.aiPreUseTalent or {}
		self.turn_procs.aiPreUseTalent[talent.id] = ret
	end
	if config.settings.log_detail_ai > 3 then print("[aiPreUseTalent]", talent.id, ret) end
	return ret
end

--- Additional checks (resource drains) to determine if the AI should toggle a sustainable talent
-- @param t, a (sustained) talent definition
-- @return boolean representing if the talent may be toggled
-- @return sustained table (if active)
-- By default:
--		a sustained talent may be activated (if it won't deactivate another talent) but not deactivated
-- If the talent drains resources (has a resource.drain_prop field), however, each resource is checked.
--		If (when the talent is active) a resource would be depleted:
--		with no aitarget, an inactive talent may not be activated and an active talent may always be deactivated
--		with an aitarget, drain_time (an estimate of how many turns before depleting the resource) is used
--		this drain time includes an estimate of resource use = self.AI_RESOURCE_USE_EST*default pool size
--		(default pool size is (resource.max or 100) - (resource.min or 0))
--		if drain_time > self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD, the chance to activate/deactivate is 100%/0%
--		as drain_time decreases below self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD:
--		- the chance to activate an inactive talent decreases towards zero
--		- the chance to deactivate an active talent increases towards 100%
function _M:aiCheckSustainedTalent(t)
	local log_detail = config.settings.log_detail_ai or 0
	local is_active = self:isTalentActive(t.id)
	if log_detail > 2 then print("[aiCheckSustainedTalent]", self.uid, self.name, "checking usability", is_active and "active" or "inactive", t.id) end
	local ok = not is_active -- by default, sustains can be activated but not deactivated
	
	-- don't activate if another talent would be deactivated (sustain_slots), unless the AI is smart enough
	if ok and t.sustain_slots and not self.ai_state._advanced_ai and self:getSustainSlot(t.sustain_slots) then
		return false
	end
	-- Note: resources are updated every self.global_speed turns
	if t._may_drain_resources then -- during AI parsing, potential resource drains were detected
		local chance
		local r_invert -- unary value of resource (-1 for inverted values, +1 otherwise)
		local std_pool -- resource standard pool size (default max or 100 - min or 0)
		local t_drain -- resource drain for this talent per action (@ self.global_speed)
		local drain_time -- estimated (self) turns to depletion of resource pool
		local recover_time -- how fast resource would recover std pool size if drain rate is reversed
		local regen -- net regen rate of resource

		for res, _ in pairs(t._may_drain_resources) do
			local res_def = self.resources_def[res]
			t_drain = (util.getval(t[res_def.drain_prop], self, t) or 0)/self.global_speed
			--print("Pre check", res_def.name, "OK set:", ok)
			if t_drain > 0 then -- sustain depletes this resource
				regen = self[res_def.regen_prop] or 0
				r_invert = res_def.invert_values and -1 or 1
				if log_detail > 2 then print(("[aiCheckSustainedTalent] Talent %s[%s] (%s) drains: %0.2f %s -- vs %0.2f regen"):format(t.name, t.id, is_active and "active" or "inactive", t_drain, res_def.name, regen)) end
				if self.ai_target.actor then  -- in combat, chance to activate/deactivate depends on the time to deplete the resource
					std_pool = (res_def.max or 100) - (res_def.min or 0)
					drain_time = self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD
					recover_time = self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD
					if is_active then -- chance to turn OFF increases with depletion rate
						if res_def.invert_values then
							if self[res_def.maxname] and regen >= 0 then
								drain_time = (self[res_def.maxname] - self[res_def.getFunction](self))/(regen + std_pool*self.AI_RESOURCE_USE_EST) -- includes estimated resource use per turn
								recover_time = std_pool/t_drain
							end
						else
							if self[res_def.minname] and regen <= 0 then
								drain_time = (self[res_def.getFunction](self) - self[res_def.minname])/(-regen + std_pool*self.AI_RESOURCE_USE_EST) -- includes estimated resource use per turn
								recover_time = std_pool/t_drain
							end
						end
						-- increased chance to deactivate high-drain talents
						chance = 1/(1/drain_time + 1/recover_time)
						if log_detail > 3 then print(" ->", self[res_def.getFunction](self), res_def.name, "depleted (active) in", drain_time, "turns", t.id, "recovery factor:", recover_time, "turns", "deactivate chance: 1 in", chance) end
						if drain_time < self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD and rng.chance(chance) then ok = true break end
					else -- chance to turn ON decreases with depletion rate
						--compute prospective regen rate and available pool after the talent is activated
						regen = regen - r_invert*t_drain
						local cost = util.getval(t[res_def.sustain_prop], self, t) or 0
						if res_def.invert_values then
							if self[res_def.maxname] and regen >= 0 then
								drain_time = (self[res_def.maxname] - math.max(self[res_def.getFunction](self), (self[res_def.miname] or 0) + cost))/(regen + std_pool*self.AI_RESOURCE_USE_EST) -- includes estimated resource use per turn
								recover_time = std_pool/t_drain
							end
						else
							if self[res_def.minname] and regen <= 0 then
								drain_time = (math.min(self[res_def.getFunction](self), (self[res_def.maxname] or 100) - cost) - self[res_def.minname])/(-regen + std_pool*self.AI_RESOURCE_USE_EST) -- includes estimated resource use per turn
								recover_time = std_pool/t_drain
							end
						end
						-- decreased chance to activate high-drain talents
						chance = 1/math.max(0, (1-(1/drain_time + 1/recover_time)))
						if log_detail > 3 then print(" ->", self[res_def.getFunction](self), res_def.name, "depleted (inactive) in", drain_time, "turns", t.id, "recovery factor:", recover_time, "turns", "activate chance: 1 in", chance) end
						if drain_time < self.AI_SUSTAIN_TALENT_RESOURCE_THRESHOLD and not rng.chance(chance) then ok = false break end
					end
				else -- out of combat: keep deactivated talents that can't be sustained indefinitely
					if is_active and regen*r_invert < 0 then
						ok = true break
					-- do not turn the talent on if the resource would be depleted
					elseif not is_active and (regen - t_drain*r_invert)*r_invert < 0 then
						ok = false break
					end
				end
			end
		end -- end resource loop
	end
	if log_detail > 2 then print("[aiCheckSustainedTalent]:",self.name, self.uid, ok and "::ai SHOULD" or "::ai SHOULD NOT", is_active and "de-activate" or "activate", t.name, t.id) end
	return ok, is_active
end

local resource_def, resource_vals -- variables for aiGetResourceTalent

-- filter to find talents to replenish a resource (used by aiGetResourceTalent, for simple AIs)
-- updates a table of weights based on tactical tables values
-- calls aiTalentTactics to evaluate the associated resource tactic for sustained talents that drain resources
_M.AI_RESOURCE_TALENT_FILTER = {
	properties_include = {"_may_restore_resources", "_may_drain_resources"},
	special = function(t, self)
		local val
		-- weight = tactical value or 1 if it replenishes resources
		-- check tactical table for the resource
		if t.tactical and (t._may_restore_resources and t._may_restore_resources[resource_def.short_name] or t._may_drain_resources and t._may_drain_resources[resource_def.short_name]) then 
			val = self:aiTalentTactics(t, self.ai_target.actor, nil, resource_def.short_name)
		end
		if not val or val == 0 then -- look for negative resource cost or drains
			if t.mode == "activated" and t._may_restore_resources and t[resource_def.short_name] and (util.getval(t[resource_def.short_name], self, t) or 0) < 0 then val = 1
			elseif t.mode == "sustained" and t._may_drain_resources and t[resource_def.drain_prop] and (util.getval(t[resource_def.drain_prop], self, t) or 0) < 0 then val = 1
			end
		end
		if val and val > 0 then
			resource_vals[t.id] = val
			return true
		end
	end
}

--- Randomly pick a talent to replenish a resource, choosing from all known talents or a list (for simple AIs)
-- @param res_def the resource short_name or definition for the resource that needs replenishing
-- @param t_filter <optional, default self.AI_RESOURCE_TALENT_FILTER> filter passed to _M:aiGetAvailableTalents
-- 		with environment set: resource_def = resource definition, resource_vals = table of weights
-- @param t_list <optional> list of talent id's to consider, defaults to self.talents
-- @return a tid for a talent than can restore the resource or nil
-- available talents are weighted according their tactical value or 1 if they have a negative resource cost
function _M:aiGetResourceTalent(res_def, t_filter, t_list)
	if type(res_def) == "string" then res_def = self.resources_def[res_def] end
	if not res_def then return end
	resource_def = res_def resource_vals = {} -- initialize locals for filter
	
	t_filter = t_filter or self.AI_RESOURCE_TALENT_FILTER
	if t_fliter ~= _M.AI_RESOURCE_TALENT_FILTER and t_filter.special then
		setfenv(t_filter.special, setmetatable({resource_def=resource_def, resource_vals=resource_vals}, {__index=_G}))
	end

	local avail = self:aiGetAvailableTalents(nil, t_filter, t_list)
	if #avail > 0 then
		local total = 0
		for i = 1, #avail do resource_vals[avail[i]] = resource_vals[avail[i]] or 1 total = total + resource_vals[avail[i]] end
		local pick = rng.float(0, total)
		for i = 1, #avail do
			pick = pick - resource_vals[avail[i]]
			if pick <= 0 then
				return avail[i], avail, resource_vals
			end
		end
	end
end

--- Find an action to perform to replenish a resource (called by the maintenance AI)
-- The action may be to use a talent or to invoke an AI
-- @param res_def the resource short_name or definition for the resource that requires action
-- @param t_filter <optional> talent filter passed to aiGetResourceTalent
-- @param t_list <optional> list of talent id's to consider, defaults to self.talents
-- by default, if a resource is at least 10% (self.AI_RESOURCE_LEVEL_TRIGGER) depleted, will try to find a talent to replenish it
--  self.ai_state parameters used:
--		.no_talents == true or non 0 -> never look for available talents
-- @return an action table (or nil) format:
--		talent format:	{tid=<talent id>, force_target=<optional target for the talent, defaults to self>}
--		ai format:		{ai=<ai to invoke>, ... <list of arguments to the ai>}
-- Returns the result of util.getval(resource_def.ai.aiResourceAction, self, resource_def, t_list) if it is defined
-- note: depleted air will trigger a search for a non-suffocating tile (see air resource definition)
function _M:aiResourceAction(res_def, t_filter, t_list)
	if type(res_def) == "string" then res_def = self.resources_def[res_def] end
	if config.settings.log_detail_ai > 2 then print("[aiResourceAction]: called for", self.uid, self.name, res_def and res_def.short_name) end
	if not res_def then return end
	if res_def.ai and res_def.ai.aiResourceAction ~= nil then -- use resource specific method to find an action
		return util.getval(res_def.ai.aiResourceAction, self, res_def, t_filter, t_list)
	end

	if (not self.ai_state.no_talents or self.ai_state.no_talents == 0) then	-- look for a talent
		local val, min, max = self[res_def.short_name], self[res_def.minname], self[res_def.maxname]
		if val and min and max then
			if (res_def.invert_values and max - val or val - min) < (max - min)*self.AI_RESOURCE_LEVEL_TRIGGER then  -- try to replenish
				local tid = self:aiGetResourceTalent(res_def, t_filter, t_list)
				if config.settings.log_detail_ai > 2 then print("[aiResourceAction]:", self.name, self.uid, "found talent", tid, "to replenish", res_def.name) end
				if tid then
					return {name = res_def.short_name, tid=tid}
				end
			end
		end
	end
end

local aitarget = "none"
--- Filter to find talents to heal self (used by aiHealingAction for simple AIs)
_M.AI_HEALING_TALENT_FILTER={
	properties = {"_may_heal"},
	special = function(t, self)
		--print("aitarget=", aitarget)
		local val = self:aiTalentTactics(t, aitarget, nil, "heal")
		return val and val > 0 
	end
}

--- Find an action to heal self (called by the maintenance AI)
-- may move if standing in harmful terrain (aiFindSafeGrid)
-- @param target <optional, defaults to self> target for the heal (talents)
-- @param t_filter <optional, default self.AI_HEALING_TALENT_FILTER> filter passed to _M:aiGetAvailableTalents
-- 		with environment set: aitarget = target (argument to this function)
-- @param t_list <optional> list of talent id's to consider, defaults to all known
--  self.ai_state parameters used:
--		.no_talents == true or non 0 -> never look for available talents
-- @return nil or action <table, containing information on the action to perform> with format:
--		talent format:	{tid=<talent id>, force_target=<optional target for the talent, defaults to self>}
--		ai format:		{ai=<ai to invoke>, ... <list of arguments to the ai>}
function _M:aiHealingAction(target, t_filter, t_list)
	if config.settings.log_detail_ai > 2 then print("[aiHealingAction]: called for", self.uid, self.name) end
	aitarget = target or self
	t_filter = t_filter or self.AI_HEALING_TALENT_FILTER
	if t_filter ~= _M.AI_HEALING_TALENT_FILTER and t_filter.special then
		setfenv(t_filter.special, setmetatable({aitarget=aitarget}, {__index=_G}))
	end
	local tid
	if (not self.ai_state.no_talents or self.ai_state.no_talents == 0) then
		tid = rng.table(self:aiGetAvailableTalents(aitarget, t_filter, t_list))
	end
	-- if standing on a damaging grid, 50% chance to move away from it
	if self:aiGridDamage() > 0 and (not tid or rng.chance(2)) then
		local grid = self:aiFindSafeGrid()
		if grid then return {ai="move_safe_grid", name="move from grid hazard", grid} end
	end

	return tid and {tid=tid, name="self_heal"}, avail, t_filter
end

--- calculate net damage (after applying resistance and affinity) and air loss for standing in a grid
-- @param gx, gy grid coordinates (defaults to self.x, self.y)
-- @return net damage
-- @return air loss per turn
function _M:aiGridDamage(gx, gy)
	gx = gx or self.x
	gy = gy or self.y
	local g = game.level.map(gx, gy, engine.Map.TERRAIN)
	if not g then return 0, 0 end
	local dam, air = 0, 0
	if not self:attr("no_breath") then -- check for suffocating terrain
		local air_level, air_condition = g:check("air_level", gx, gy), g:check("air_condition", gx, gy)
		if air_level and air_level < 0 and (not air_condition or not self.can_breath[air_condition] or self.can_breath[air_condition] <= 0) then
			air = air_level
		end
	end
	
-- can check map effects here also? (need to be standardized, particularly w.r.t. damage types)

	if g.DamageType and not self:attr("invulnerable") then -- check for damaging terrain
		if not g.faction or self:reactionToward(g) < 0 then
			if type(g.maxdam) == "table" or type(g.mindam) == "table" then dam = 0
			else dam = ((g.maxdam or 0) + (g.mindam or 0))/2 * (100 - self:combatGetResist(g.DamageType)-self:combatGetAffinity(g.DamageType))/100
			end
		end
	end
	if config.settings.log_detail_ai > 3 then print(("[aiGridDamage] for %s (%d, %d) dam: %s, air: %s"):format(self.name, gx, gy, dam, air)) end
	return dam, air
end

--- Calculate the hazard level for a grid (used by aiFindSafeGrid)
-- @param gx, gy = <default self.x, self.y> grid coords to test
-- @param dam_wt <optional, default 1, minimum 0.1> grid weight for damage (as % life lost)
-- @param air_wt <optional, default 1, minimum 0.1> grid weight for air loss (as % air lost)
-- @return hazard value for the grid based on grid damage and air loss computed by aiGridDamage
--	Lower values are safer/better (<= 0 is safe) -- calculation:
--	 val = %health lost*dam_wt + %air lost*air_wt
function _M:aiGridHazard(gx, gy, dam_wt, air_wt)
	local dam, air = self:aiGridDamage(gx or self.x, gy or self.y)
	-- values increase in proportion to the % life lost + % air depleted by the grid
	local val = math.max(0.1, dam_wt or 1)*dam*100/(self.life-self.die_at) - math.max(0.1,( air_wt or 1))*air*100/(self.air + 1)
	return val, dam, air
end

--- Find a (nearest, reachable) safe grid (based on terrain damage and air levels, possibly approaching or avoiding ai target)
-- uses Astar pathing
-- @param radius <optional, default 10> radius to search
-- @param dam_wt <optional, default 1> grid weight for damage
-- @param air_wt <optional, default 1> grid weight for air loss
-- @param dist_weight <optional, default 1 (with ai target) or 0.1> = weight per move needed to reach a grid, (use zero to ignore distance)
-- @param want_closer <optional, default 0.5> weight multiplier for grid distance to ai target (positive values favor grids closer to the target)
-- @param ignore_blocked <optional, default false> set true to search (unreachable) grids beyond blocking terrain
-- @param grid_hazard <optional, function, defaults to self.aiGridHazard> = grid hazard function(self, gx, gy, dam_wt, air_wt)
--	 computes the relative hazard level of each grid, lower is better (0 or less is safe)
-- @return grid found <table> : {
--		[1]=<x coordinate>, [2]=<y coordinate>,
--		val = <net grid value>, start_haz = <start grid hazard value>, end_haz = <end grid hazard value>,
--		move_cost = relative movement cost per grid (compared to std action with global speed 1)
-- 		dist=<path length to reach grid>,
--		Astar = <Astar pathing object (if reachable)>,
--		path = <Astar node_list (if reachable)>}
-- Grid value calculation:
-- 	grid value = grid_hazard(self, x, y, dam_wt, air_wt) + distance*dist_weight/movement speed + want_closer*distance to target
-- 	Always returns the current grid if safe (grid hazard <= 0)
function _M:aiFindSafeGrid(radius, dam_wt, air_wt, dist_weight, want_closer, ignore_blocked, grid_hazard)
	grid_hazard = grid_hazard or self.aiGridHazard
	local haz, dam, air = grid_hazard(self, self.x, self.y, dam_wt, air_wt)
	local val = haz
	local move_cost = self:combatMovementSpeed()/(self.global_speed or 1)-- doesn't take destination terrain speed into account
	local grid = {self.x, self.y, move_cost=move_cost, dist=0, val=val, start_haz=haz, end_haz=haz, dam=dam, air=air}
	if val <= 0 or self:attr("never_move") then return grid end -- already on a safe grid or can't move (enemies don't matter in this case)
	local aitarget, tx, ty = self.ai_target.actor
	dist_weight = (dist_weight or (aitarget and 1 or .1))*move_cost -- less time pressure out of combat
	local log_detail = config.settings.log_detail_ai or 0
	-- possible improvement: update ast.heuristicCloserPath function _M:heuristicCloserPath(sx, sy, cx, cy, tx, ty) to navigate for minimum intervening grid damage

	if aitarget and want_closer ~= 0 then
		tx, ty = self:aiSeeTargetPos(aitarget)
		want_closer = want_closer or 0.5
		grid.val = haz + math.max(0, want_closer*core.fov.distance(tx, ty, self.x, self.y))
		grid.want_closer = want_closer
	else want_closer = 0
	end
	local best_val = grid.val
	local ast, path = Astar.new(game.level.map, self)
	local dist

	if log_detail > 0 then
		print(("[aiFindSafeGrid]%s searching for safer grids [radius %s from (%s, %s), val = %s], dam_wt=%s, air_wt=%s, dist_weight=%s, want_closer=%s"):format(self.name, radius, self.x, self.y, grid.val, dam_wt, air_wt, dist_weight, want_closer))
if log_detail > 1.4 and config.settings.cheat then game.log("%s #PINK#searching for safer grids [radius %s from (%s, %s), val = %s], dam_wt=%s, air_wt=%s, dist_weight=%s, want_closer=%s", self:getName():capitalize(), radius, self.x, self.y, grid.val, dam_wt, air_wt, dist_weight, want_closer) end -- debugging
	 end
	local grid_count = 0
	core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, radius or 10,
		function(_, lx, ly)
			--print(("--checking block for grid #%s (%s, %s)"):format(grid_count, lx, ly))
			-- by default, don't look beyond impassible grids
			if not (ignore_blocked or self:canMove(lx, ly)) then return true end
			-- mark the grid impassible if grids further away cannot possibly be better
			local min_val = (core.fov.distance(self.x, self.y, lx, ly)+1)*dist_weight
			if want_closer ~= 0 then
				min_val = math.max(0, min_val + want_closer*(core.fov.distance(tx, ty, lx, ly)-1))
			end
			if min_val >= best_val then
			--print("...setting block for grid at", lx, ly, min_val, "vs.", best_val)
				return true
			end
		end,
		function(_, lx, ly)
			grid_count = grid_count + 1
			if not self:canMove(lx, ly) then return end
			dist = core.fov.distance(self.x, self.y, lx, ly)
			haz, dam, air = grid_hazard(self, lx, ly, dam_wt, air_wt)
			--print(("--checking grid #%s (%s, %s)[%s] %s(base=%s, dam=%d, air=%d) vs. %s"):format(grid_count, lx, ly, dist, val+dist*dist_weight, val, dam, air, best_val))
			val = haz + math.max(0, dist*dist_weight + (want_closer ~= 0 and core.fov.distance(tx, ty, lx, ly)*want_closer or 0))
			if log_detail > 3 then print(("--checking grid #%s (%s, %s)[%s] val=%4.4f(haz=%4.4f)(dam=%d, air=%d) vs. %4.4f"):format(grid_count, lx, ly, dist, val, haz, dam, air, best_val)) end
			if val <= best_val then -- possible better grid found based on straight line path
				path = ast:calc(self.x, self.y, lx, ly, nil, nil, add_check)
				if path then -- grid is reachable, calculate true value with length of actual path
					dist = #path
					val = haz + math.max(0, dist*dist_weight + (want_closer ~= 0 and core.fov.distance(tx, ty, lx, ly)*want_closer or 0))
					if log_detail > 2 then print(("----possible better grid (%s, %s)[%s] %s(%s)(path, dam=%d, air=%d) vs. %s"):format(lx, ly, dist, val, haz, dam, air, best_val)) end
					if val < best_val then -- update the best grid found
						grid[1], grid[2] = lx, ly
						grid.val, grid.dam, grid.air = val, dam, air
						grid.end_haz = haz
						grid.Astar = ast grid.path = path
						grid.dist = dist
						best_val = val
--game.log("#PINK# --updating best reachable grid to: (%d, %d) (dist: %s, val: %s)", grid[1], grid[2], dist, val)
					end
				end
			end
		end,
	nil)
	if log_detail > 0 then
		print("[aiFindSafeGrid] found best grid:", grid[1], grid[2], "val=", grid.val, grid_count, "grids searched")
if log_detail > 1.4 and config.settings.cheat then game.log("#PINK# --best reachable grid: (%d, %d) (dist: %s, val: %s(%s))", grid[1], grid[2], grid.dist, grid.val, grid.end_haz) end -- debugging
	end
	return grid
end

-- Find a grid to flee to while keeping LOS (from self.ai_target.actor)
-- uses the distanceMap
-- returns true/false (grid found?), grid x, grid y
function _M:aiCanFleeDmapKeepLos()
	if self:attr("never_move") then return false end -- Dont move, dont flee
	if self.ai_target.actor and self.ai_target.actor.distanceMap then
		local act = self.ai_target.actor
		local ax, ay = self:aiSeeTargetPos(act)
		local dir, c
		if self:hasLOS(ax, ay) then
			dir = 5
			c = act:distanceMap(self.x, self.y)
			if not c then return end
		end
		for _, i in ipairs(util.adjacentDirs()) do
			local sx, sy = util.coordAddDir(self.x, self.y, i)
			-- Check LOS first
			if self:hasLOS(ax, ay, nil, nil, sx, sy) then
				local cd = act:distanceMap(sx, sy)
--				print("looking for dmap", dir, i, "::", c, cd)
				if not cd or ((not c or cd < c) and self:canMove(sx, sy)) then c = cd; dir = i end
			end
		end
		if dir and dir ~= 5 then
			local dx, dy = util.dirToCoord(dir, self.x, self.y)
			return true, self.x + dx, self.y + dy
		else
			return false
		end
	end
end

--[[
==== TALENT TACTICAL TABLES ==== (with examples)
Tactical tables are the primary data structures used by the tactical AI (and some other AI's, like maintenance) to determine how useful individual talents are to a talent user.  This section describes their format and how they are interpreted (resolved), and provides guidelines and examples for their construction.  The tactical AI has detailed documentation on how it uses tactical tables to choose useful actions.

In this documentation, terms in ALL CAPS refer to specific variables; e.g. "SELF" refers to the acting NPC running its AI.  Also, section labels with format "-== LABEL ==-" (e.g. "-== SUSTAINED TALENTS ==-") are tagged exactly in the relevant code for text searching.

Some examples are included in the "--==TACTICAL TABLE  EXAMPLES ==--" section below.  Also, the value of config.settings.log_detail_ai can be increased to increase the detail of AI information output to the log file.

For a talent with definition t, the tactical table for a talent is defined in the field t.tactical, which can be either a table or a function(self, t, aitarget) that returns a table.  Here, self refers to the talent user ("SELF") and aitarget is the actor the talent targets ("AITARGET", usually self.ai_target.actor, which may not necessarily be one of the actors affected by it.)

As a typical example, a talent that has defined:

	t.tactical = {attack = {LIGHTNING = 2}}
	
is interpreted as fulfilling the "attack" TACTIC with base effectiveness 2, modified by damage modifiers for the LIGHTNING DamageType.  This table is resolved (based on the targets it may affect) to a summary of TACTIC WEIGHTs:

	{attack = X}
	
where X is a number reflecting the overall effectiveness of the talent at fulfilling the "attack" TACTIC.

This table is further interpreted by the tactical AI, using other factors such as talent level and speed, targeting information, situational weight modifiers, etc., to evaluate how effective the talent is at fulfilling the current needs of the talent user.

TACTICAL TABLE FORMAT:

	{TACTIC1 = WEIGHT1, TACTIC2 = WEIGHT2, ...}

Each TACTIC ("attack", "heal", "escape", etc.) is a label that associates the capabilities of the talent with some possible needs for SELF.  (Note: TACTIC labels are converted from UPPER CASE (in talent definitions) to LOWER CASE (as used by the AI) during talent parsing.  TACTIC labels in full or partial tactical tables returned by functions, should be lower case to be consistent.)

Each WEIGHT is (resolved to) a number, reflecting how effective the talent is at satisfying the corresponding TACTIC.  The full table of TACTIC WEIGHTs reflects all of the tactical uses the tactical AI considers for the talent.

-== INTERPRETATION ==-
When evaluating a talent, the AI generates a list of actor(s) the talent may affect and then resolves the corresponding WEIGHT for each listed actor, summing the results to get the TACTIC WEIGHT. (These tasks are performed, respectively, by the functions engine.interface.ActorAI:aiTalentTargets(t, aitarget, tg, all_targets, ax, ay) and _M:aiTalentTactics(t, aitarget, target_list, tactic, tg, wt_mod), defined in this file.)

Each WEIGHT can be defined as a number, a table, or a function(SELF, t, actor) (A function is called as needed when the tactical table is evaluated by aiTalentTactics, and must return a number or a table.  The actor argument is the actor in the list being affected.)

Each WEIGHT is resolved as follows for each actor:

	First, if WEIGHT is a function(SELF, t, actor), it is computed to get a number or table.
	If WEIGHT is a number, it is used directly. (It will be the same for each actor.)
	If WEIGHT is a table (It may be different for each actor.):
		
			{TYPE1 = VALUE1, TYPE2 = VALUE2, ... }
			
		Each TYPE is evaluated to determine the expected effectiveness of the TACTIC against the actor (on the basis of 1 = 100% effective), to be multiplied by the corresponding resolved VALUE.
		If TYPE is a function or is a label that matches the name of a function in the list SELF.aiSubstDamtypes ("weapon", etc., defined above), that function will be called as function(SELF, t, actor), returning a replacement TYPE (DamageType label or status condition tag) and a WEIGHT multiplier.
		If TYPE is an engine.DamageType label (e.g. "FIRE", "PHYSICAL"):
			The effectiveness is SELF's damage multiplier for the DamageType times the fraction that penetrates the actor's resistances, with any affinity being treated as extra resistance.
		otherwise, if TYPE is a status condition tag (e.g. "stun", "pin"):
			The effectiveness is the percent chance for actor:canBe(TYPE)/100.
		
		Each VALUE is resolved into a number as follows:
		
			If VALUE is a function(SELF, t, actor) it is computed first.
			Then, if it's a number, it's used directly.  Otherwise, if it's a table:
			
				{STATUS1=STATUSVALUE1, STATUS2=STATUSVALUE2, ...}
			
			it is resolved as the weighted sum of all of the STATUSVALUEs (using the chance from actor:canBe(STATUS)/100).
			
		Each TYPE is evaluated independently, and the VALUE of all TYPEs are summed to get the WEIGHT for the actor being considered.

The TACTIC WEIGHT is the sum of all of the computed WEIGHTs for each actor in the list.

To reference resistances correctly, TYPE should be upper case for damage types and lower case for status conditions (e.g. "disarm").  Damage types should all be basic elemental damage types for which resistances are defined, e.g. "PHYSICAL", "COLD", "FIRE", "LIGHTNING", "ACID", "NATURE", "ARCANE", "BLIGHT", "LIGHT", "DARK", "MIND", "TEMPORAL".

If TACTIC == "self", it will be interpreted as an independent set of TACTICs applied only to SELF.  WEIGHT will be interpreted as a completely separate tactical table, and all of its TACTIC WEIGHTs will be merged into the main tactical table after all other TACTICs are computed.  This is useful for talents that have different affects on the user and other actors.

_M.aiSubstDamtypes (defined above) contains predefined functions associated with TYPE labels.  These are used to generate appropriate DamageTypes and multipliers for some common attack types, such as melee attacks.  Each returns an appropriate TYPE (DamageType label or status condition tag) and a WEIGHT multiplier.  The predefined functions are:

	"weapon" -- returns mainhand or unarmed weapon DamageType and a multiplier (1x to 2x) based on weapon skill
		returns the result of the "archery" function if the talent is an archery talent
	"offhand" -- as "weapon" but for offhand (offhand penalty applies)
	"archery" -- returns the ammo DamageType and a multiplier (1x to 2x) based on launcher weapon skill

--BENEFICIAL VS. HARMFUL TACTICS and HOSTILE VS. FRIENDLY TARGETS--
Each defined TACTIC has a numerical benefit coefficient (multiplier) in the table _M.AI_TACTICS.  TACTICs are broadly categorized as either beneficial or harmful, depending on the sign of this value.  Positive coefficients generally mean the TACTIC is good (for SELF) when applied to itself or allies and bad when applied to foes.  Negative coefficients reverse this.  Undefined TACTICs have a default benefit coefficient of 0, and always receive 0 TACTIC WEIGHT.

The TACTIC WEIGHTs for actors affected by a talent are modified by SELF's reaction to them (each is either SELF, an ally, or a foe).  The TACTIC WEIGHTs for actors friendly to SELF that are adversely affected by a harmful TACTIC may be multiplied by compassion values.  These are self_compassion (self.ai_state.self_compassion, default 5) and ally_compassion (self.ai_state.ally_compassion, default 1) for self and allies, respectively.

Note that the AI usually selects an enemy as AITARGET if possible.  The logic for how WEIGHTs are modified by SELF's reaction to each actor depends on the talent's targeting parameters and the TACTIC (This is handled in the "--== TACTIC INTERPRETATION ==--" section of code within the _M:aiTalentTactics function below.):

	If the talent requires a target (AITARGET is the primary target for the talent.):

	AITARGET is assumed to be appropriate for the talent and all (positive) WEIGHTS are treated as useful for the talent user for both beneficial and harmful TACTICs:

		If AITARGET is hostile, then the talent is treated as useful against foes:
			Each beneficial TACTIC is treated as beneficial (for the talent user) for all actors affected.
			Each harmful TACTIC is treated as harmful to each actor affected, and is penalized for hitting allies (compassion applies).
			
		If AITARGET is friendly, then the talent is treated as useful on allies:
			The TACTIC WEIGHT is increased for each ally affected and decreased for each foe affected.

	If the talent does not require a target (It is used on SELF if AITARGET is undefined.):

		If the talent has targeting parameters (SELF:getTalentTarget(t) returns non-nil), then it is designed to affect other actors (possibly, but not necessarily including SELF):
			Each beneficial TACTIC is treated as beneficial to each target affected, and is penalized for hitting foes.
			Each harmful TACTIC is treated as harmful to each target affected, and is penalized for hitting allies (compassion applies).
			
		if the talent has no targeting parameters (SELF:getTalentTarget(t) returns nil), it is designed to affect the user only:
			The talent is assumed to affect the user if no targets are designated.
			Each (positive) WEIGHT is treated as useful to SELF (for both beneficial and harmful TACTICs).

The "special" TACTIC is an exception: it treats all affected targets the same and ignores compassion.
			
--== SUSTAINED TALENTS ==--
Sustained talents get some special treatment.

The TACTIC WEIGHTs for active sustains are negated, since turning a talent off reverses the effects gained from turning it on.  So if the talent has tactical = {buff = 2}, then while active it has tactical = {buff = -2}.

The TACTIC WEIGHTs for active sustains are reduced if the cooldown > 10 and AITARGET is defined (i.e. SELF is assumed to be in combat and the long cooldown may prevent it from being used again.).

If a sustained talent automatically turns off other sustains when activated (it has defined the .sustain_slots field, e.g. celestial chants), the TACTIC WEIGHTs for each talent that would be deactivated will be calculated and subtracted from the final tactical table.

If a sustained talent drains resources while active (e.g. Fearscape drains vim), aiTalentTactics will automatically generate additional (usually negative) resource-based TACTIC WEIGHTs for each drained resource (unless already defined in the tactic table, requires talent[drain_prop] be defined according to the resources definition).  The TACTIC WEIGHT for these tactics are scaled to be 1 for a drain rate of 10% of a standard size pool per turn and are limited to |TACTIC WEIGHT| < 5.  (The standard pool is defined from the resource definition as max <default 100> - min <default 0>.  This is 100 for most resources, but can be specified by setting a value for ai.tactical.default_pool_size when defining the resource.)

In addition, resource drains will cause an estimate to be computed for how long a sustained talent can be maintained.  This is based on the rate the resource(s) are drained, plus an allowance for resource usage (The standard pool*SELF.AI_RESOURCE_USE_EST). If the estimated time is less than 10 turns, all TACTIC WEIGHTs (except those automatically generated for drain resources) will be decreased (for inactive talents) or increased (for active talents).

-== SPECIAL FLAGS ==-
Some flags can be added to tactical tables as special instructions to aiTalentTactics:

	__wt_cache_turns: specify the maximum number of game turns (not actions) to cache TACTIC values for other actors (default SELF.ai_state._tactical_cache_turns or SELF.AI_TACTICAL_CACHE_TURNS)
		This is only needed (typically set to 1) for talents that affect actors other than SELF for which the TACTIC value is likely to change very frequently (e.g. CURE, which depends on temporary status effects, or HEAL, which depends on life levels).  Set to 0 to disable caching TACTIC values.
	_no_tp_cache: set to true to prevent caching of the final TACTIC WEIGHTs in the SELF.turn_procs cache.
		This is useful to prevent storing intermediate results when building complex TACTIC WEIGHT tables in stages.  (Such as when merging various TACTIC WEIGHTs into the tactics.self subtable.  See T_SUN_BEAM and the cunning/poisons and psionic/projection talents for examples.)

-== TACTICS CACHING STRUCTURE ==-
For each talent, the aiTalentTactics function caches a list of targets affected (within SELF.turn_procs) and tactical data for each target.  This allows previously computed TACTIC values for a talent vs possible targets to be remembered, so that they don't need to be recomputed unnecessarily.  The main variables used and their structure are as follows:

	SELF.aiOHash = offensive hash value:
		Used as a fingerprint to trigger reset of most cached tactical information for SELF.
		Updated by Actor:onTemporaryValueChange (when one of the properties in ActorAI.aiOHashProps changes).
	ACTOR.aiDHash = defensive hash value for ACTOR:
		Used as a fingerprint to trigger reset of cached TACTIC values for SELF against a specific ACTOR.
		Updated by Actor:onTemporaryValueChange (when one of the properties in ActorAI.aiDHashProps changes).
	
	computed TACTIC values (for various actors, never for SELF):
	SELF._ai_tact_wt_cache = {
		_computed = game.turn of last full reset,
		[TID] = {
			_computed = game.turn of last reset for TID,
			_OHash = SELF.aiOHash at last reset,
			[TACTIC] = {
				[actor1] = value1, [actor2] = value2, ..., computed TACTIC values indexed by actor reference
				[actor1.uid] = actor1.aiDHash, [actor2.uid] = actor2.aiDHash, ...  defensive hash values matching TACTIC values
				}
			}
		}
		
	final TACTIC WEIGHT results (for each talent evaluated in the current turn):
	SELF._turn_ai_tactical = {_new_tact_wt_cache = <boolean> actor weights cache has been reset,
			[TID] = {base_tacs = {base tactics = computed explicit tactics for TID,
				implicit_tacs = computed implicit tactics for TID},
				selffire = computed selffire coefficient,
				friendlyfire = computed friendlyfire coefficent,
				targets = {list of targets possibly affected by TID},
				tactics = last computed TACTIC WEIGHT table,
				weight_mod = weight mod used for last computed TACTIC WEIGHT table
			}
		}
	}

The soft switch config.settings.tactical_cache_test can be set to force recomputing cached values while checking them against newly computed values.  This triggers extra output to the game log (and incurs a performance penalty).

--==TACTICAL TABLE  EXAMPLES ==--
EXAMPLE 1 -- Step by step interpretation of multiple TACTICs with multiple DamageTypes:
Consider a hypothetical talent with the following tactical table:

	talent.tactical = {ATTACK = {LIGHTNING = 1, NATURE = 2}, DISABLE = {stun = 2}}

During talent parsing, the TACTIC labels are converted to lower case to get the form used by the AI:
	
	talent.tactical = {attack = {LIGHTNING = 1, NATURE = 2}, disable = {stun = 2}}
	
This table is interpreted as:
	
	TACTIC1 = "attack"		WEIGHT1 = {LIGHTNING = 1, NATURE = 2}
	TACTIC2 = "disable"		WEIGHT2 = {stun = 2}

The labels in the WEIGHT1 table are upper case in order to exactly match one of the standard DamageType labels.

If the TACTICs are evaluated against a list of 2 (hostile) actors:
	
	actor 1: (50% resistant to LIGHTNING)
	actor 2: (20% resistant to NATURE, 100% immune to stun)
	
(with no other resistances or other effects), the WEIGHTs for each actor are evaluated as:

	for actor 1: WEIGHT1 = 0.5*1 + 1.0*2 = 2.5		WEIGHT2 	= 1.0*2 = 2
	for actor 2: WEIGHT1 = 1.0*1 + 0.8*2 = 2.6		WEIGHT2 	= 0.0*2 = 0
	totals:		 WEIGHT1 (attack)		 = 5.1		WEIGHT2 (disable)	= 2

So the resolved tactical table for this talent (versus these actors) is:

	TACTIC WEIGHTs = {attack = 5.1, disable = 2}
	
This resolved table is used by the tactical AI to determine how useful the talent is to SELF based on the tactical circumstances. (Larger values reflect more effectiveness.)

Note to talent developers: This example uses slightly inflated TACTIC VALUEs for clarity.  To prevent the AI over or under using a talent, typical WEIGHTs should evaluate, for a single actor, to a maximum of around 2 for most talent's primary TACTIC(s), and to smaller values for secondary TACTICs. (A WEIGHT of 3 is usually treated as VERY effective by the AI.)

EXAMPLE 2 -- Compound resistances (PHYSICAL and NATURE-based poison attack):
Consider a talent (requiring a hostile AITARGET) that deals modest PHYSICAL damage, but that afflicts the target with a powerful poison effect that deals NATURE damage.  The tactical table might look like:

	talent.tactical = {ATTACK = {PHYSICAL = 1, NATURE = {poison = 2}}

If this is applied against a target with 50% PHYSCIAL resistance and 90% NATURE resistance and no poison immunity:

	TACTIC WEIGHT (attack) = 0.5*1 + 0.1*(1.0*2) = 0.5 + 0.2 = 0.7

Against another target with no PHYSICAL or NATURE resistance that is immune to poison:

	TACTIC WEIGHT (attack) = 1.0*1 + 1.0*(0.0*2) = 1 + 0 = 1
	
If the attack would hit 10 of the resistant targets and 10 of the poison-immune targets (all hostile) it would have a base TACTICAL WEIGHT (attackarea) of 10*0.7 + 10*1 = 17:

	TACTIC WEIGHTs = {attack = 17}

EXAMPLE 3 -- multiple targets, mixed DamageTypes (Darkfire talent):
This talent deals 50% FIRE and 50% DARKNESS damage in an area.  It requires a target and AITARGET will be hostile.

	talent.tactical = { ATTACKAREA = {FIRE = 1, DARKNESS = 1}}

Against 3 targets:

	foe1: (immune to FIRE damage)
	foe2: (no resistances)
	ally: (immune to DARKNESS)
	
the TACTICAL WEIGHT for the (harmful) ATTACKAREA tactic is computed as:

	foe1:	(0.0*1 + 1.0*1) 		= 1
	foe2:	(1.0*1 + 1.0*1) 		= 2
	ally:	(1.0*1 + 0.0*1)*-1		= -1
	total:							= 2

The WEIGHT for the ally is multiplied by -1 (-1*ally_compassion), because ATTACKAREA is a harmful TACTIC (_M.AI_TACTICS.attackarea = -1) affecting an ally for a talent that requires a hostile target.

EXAMPLE 4 -- functional TACTIC value, Nature's Touch talent:
This talent heals the target if it's not undead.  It does not require a target, and so is assumed to be used on SELF if AITARGET is undefined.  This means that the tactics are useful when affecting friendly targets.

	talent.tactical = { HEAL = function(self, t, target)
		return not target:attr("undead") and 2*(target.healing_factor or 1) or 0 
	end}

The talent gets a base tactical weight for the HEAL tactic of 0 if the target is undead or 2 times the target's (usually SELF's) healing_factor.  If targeting SELF (not undead), this resolves to:

	TACTICAL WEIGHTs (affecting SELF) = {heal = 2*SELF.healing_factor}
	
EXAMPLE 5 -- combined friendly and hostile effects (Blood Grasp talent):
This talent deals blight damage to a single target and heals the talent user for half the damage done.  It requires a target; AITARGET will be hostile.

	talent.tactical = { ATTACK = {BLIGHT = 1.75}, HEAL = {BLIGHT = 1}}

(Note that TACTIC WEIGHTs are not necessarily proportional to the talent's effects.)  If the target is a foe with no blight resistance, the tactical table resolves to:

	TACTICAL WEIGHTs (affecting a foe) = {attack = 1.75, heal = 1}

The ATTACK TACTIC is detrimental and the HEAL TACTIC is beneficial and so have opposite values in SELF.AI_TACTICS.  Since the talent requires a target, however, and is assumed to be targeted correctly, both TACTICs are treated as useful (to the talent user).

If the target is an ally (with ally_compassion = 1):

	TACTICAL WEIGHTs (affecting an ally) = {attack = -1.75, heal = 1}
	
since the talent would hurt the ally but still heal SELF.  If the talent allowed the same ally and foe to both be affected, the tactical table for hitting both actors would be:

	TACTICAL WEIGHTs (affecting one foe and one ally) = {attack = 0, heal = 2}

since the ATTACK WEIGHTs would offset each other, but the HEAL WEIGHTs would be added.

EXAMPLE 6 -- split effects on self and others (Rune: Lightning talent):
The talent deals moderate lightning damage to a target, while providing a strong defensive effect to the user.  It requires a target (and is targeted on a foe).

	talent.tactical = { SELF = {defend = 2}, ATTACK = { LIGHTNING = 1 } }
	
If it is targeted on a foe that is immune to LIGHTNING damage in such a way that an additional foe and an ally are also hit, the tactical table resolves to:

	tactical = {defend = 2, attack = 0}
	
For the ATTACK TACTIC, the talent target adds no tactical value (it is immune), while the additional foe and ally hit (ally_compassion = 1) offset each other.
The defend tactic applies only to the talent user, regardless of the targets.  It is is applied directly, and only once.

EXAMPLE 7 -- sustained talent affecting others (Body of Fire talent):
This sustained talent continuously fires out flaming bolts in a radius around the user against enemies, provides some fire resistance, burns melee attackers, and drains mana continuously.  (Sustained talents get special treatment in the "--== SUSTAINED TALENTS ==--" section of the aiTalentTactics function.)

	tactical = { ATTACKAREA = { FIRE = 1.5 }, SELF = {defend = 1}}
	
This talent uses t.target to determine which targets are affected each turn.  If there is a single hostile target (no fire resistance) within range, the tactical table resolves to:

	tactical = { attackarea = 1.5, defend = 1, mana = <negative WEIGHT>}
	
where the mana TACTIC is automatically added by SELF.aiTalentTactics.  The <negative WEIGHT> is computed based on the mana drain rate (defined by the talent definition), and the default resource pool size for mana (100).  This assumes that there is enough mana available to maintain the talent for at least 10 turns.  If there is less, the TACTIC WEIGHTs for "attackarea" and "defend," but not "mana" will be reduced.

If the talent is already active, the base tactical table is negated by default:
	
	tactical = { attackarea = -1.5, defend = -1, mana = <positive WEIGHT>}

Turning off talents with long cooldowns is penalized while in combat, however.  This talent's cooldown (of 40 turns) results in a weight modifier of 0.5 ((10/cooldown)^.5).  The base tactical table for the active talent is then:

	tactical = { attackarea = -0.75, defend = -0.5, mana = <positive WEIGHT>*.5}
	
If there is insufficient mana to maintain the talent for at least 10 turns, the magnitude of the attackarea and defend WEIGHTs may be further decreased.
--]]

--- Compute the effectiveness of a tactic effect_type against foes, allies, and self in a list of actors
-- matches functionality in aiTalentTactics, for use by the old tactical ai interpreting updated tactical tables
-- @param targets = actor or list of actors to affect, defaults to current target or self
-- @param effect_type = a number (used directly) or a DamageType or status effect label (checked against resistances of each actor)
-- @param effect_wt =  <optional, default 1> base effectiveness value evaluated for each actor as follows:
-- 		If it's a function, it is evaluated as effect_wt(self, t, actor) or 0, then:
--		If it's a number, is used directly as the weight
--		If it's a table, (i.e. {status1=weight1, status2=weight2,...}),
--			it is evaluated as the sum of all the weights for which actor:canBe(status) returns true
--		The net weight for each actor is then adjusted for selffire, friendlyfire according to reaction
-- @param t = talent definition (for effect_wt function calls)
-- @param selffire, friendlyfire <optional, 0 - 1, default 0> fractional chance to affect self, allies
-- @return effective numbers of foes, self, allies affected by the effect_type, accounting for DamageType resistance/affinity and immunity to status effects
function _M:aiTacticEffectValues(targets, effect_type, effect_wt, t, selffire, friendlyfire)
	effect_wt = effect_wt or 1
	local pen, res = DamageType[effect_type] and util.bound(self:combatGetResistPen(effect_type), 0, 100) or 0, 0
	local log_detail = config.settings.log_detail_ai or 0
	targets = targets or self.ai_target.actor or self
	selffire = (selffire == true and 1) or selffire or 0
	friendlyfire = (friendlyfire == true and 1) or friendlyfire or 0

	local nb_foes_hit, nb_self_hit,	nb_allies_hit = 0, 0, 0
	local weight, act_type
	local done = false
	local i, act
	
	repeat
		if targets.__CLASSNAME then
			act, done = targets, true
		else
			i, act = next(targets, i)
			if not act then break end
		end
		if act == self then -- hit self
			act_type = "self"
			weight = selffire*friendlyfire -- matches actor:project
		elseif self:reactionToward(act) >= 0 then -- hit ally
			act_type = "ally"
			weight = friendlyfire
		else -- hit foe
			act_type = "foe"
			weight = 1
		end
		if weight ~= 0 then
			if log_detail > 2 then print("[aiTacticEffectValues]", self.uid, self.name, "vs", act.uid, act.name, act_type, weight) end
			local effect_type, effect_wt = effect_type, effect_wt
			local _, status_chance
			-- special case for effect_type is a function
			if type(effect_type) == "function" then -- evaluate the function against the actor
--				effect_type = effect_type(self, t, act) or 0
				effect_type, effect_wt = "function", effect_type(self, t, act) or 0
			end
			if type(effect_type) == "number" then -- numerical weights are used directly (no resistances)
				effect_wt = effect_type
			else -- adjust for effective resistance (table)
				if DamageType[effect_type] then -- calculate effective DamageType resistance and affinity
					res = act:combatGetResist(effect_type)
					res = util.bound(res > 0 and res * (100 - pen) / 100 or res, -100, 100) + act:combatGetAffinity(effect_type)
					if log_detail > 2 then print("\t\t_DamageType Modifiers:", effect_type, "pen, res, aff=", pen, res, act:combatGetAffinity(effect_type)) end
				else
					_, status_chance = act:canBe(effect_type) --Status immunity
					if log_detail > 2 then print("\t\t--- status_chance", effect_type, status_chance) end
					res = 100 - status_chance
				end
				if type(effect_wt) == "function" then effect_wt = effect_wt(self, t, act) or 0 end -- evaluate function
				if type(effect_wt) == "table" then -- sum the list of statuses and weights that can affect the actor
					local weight = 0
					for status, wt in pairs(effect_wt) do
						_, status_chance = act:canBe(status) --Status immunity
						if log_detail > 2 then print("\t\t--- status_chance", effect_type, status, status_chance) end
						weight = weight + wt*status_chance/100
					end
					effect_wt = weight
				end
				if log_detail > 2 then print("\traw effect_wt ", effect_type, "against", act.name, effect_wt) end
				effect_wt = effect_wt * (100 - res) / 100 -- apply the effective resistance
			end
			-- update totals
			if act_type == "foe" then
				nb_foes_hit = nb_foes_hit + effect_wt
			elseif act_type == "self" then
				nb_self_hit = nb_self_hit + effect_wt
			else
				nb_allies_hit = nb_allies_hit + effect_wt
			end
			if log_detail >= 2 then print("[aiTacticEffectValues] adjusted effect_wt ", effect_type, "against", act.uid, act.name, effect_wt) end
		end
	until done or not i
	return nb_foes_hit, nb_self_hit, nb_allies_hit
end

--- force reset and testing of cached data in aiTalentTactics
-- for debugging complex tactical tables
config.settings.tactical_cache_test = false
--config.settings.tactical_cache_test = true -- debugging

--- Compute the (resolved) TACTICAL WEIGHT(s) for a talent to determine what TACTICs it fulfils
-- @see the tactical AI
--	WEIGHTs can be positive (good for self) or negative (bad for self)
-- 	uses data contained in the talent definition (t.tactical_imp or t.tactical)
--	See the "==== TALENT TACTICAL TABLES ====" section above for a detailed explanation of how talent tactical tables are interpreted
-- @param t, a talent definition
-- @param aitarget <optional> the AI's target (actor) for the talent
-- @param target_list <optional> = list or single actor (Entity) affected
--		default: self:aiTalentTargets(t, aitarget, tg, true) untargeted beneficial effects assumed to affect self
-- @param tactic <optional, defaults to t.tactical> either a single tactic label <string> to evaluate or
--		a tactical table or function(self, t, aitarget) to evaluate in place of the one defined in the talent
--		changing the tactical info forces a cache reset
-- @param tg <optional, default: return of getTalentTarget> targeting table
--		used to determine targets (if no target_list) for the talent and to define selffire/friendlyfire
-- @param wt_mod <optional> if defined, overrides the multiplier for all tactical weights
--		Use to prevent adjustments for sustained talents (weights always negated for active sustains).
-- Additional (non-parameter) inputs:
--	self.ai_state.self_compassion <default 5> = multiplier for non beneficial tactics applied to self
--	self.ai_state.ally_compassion <default 1> = multiplier for non beneficial tactics applied to allies
--  self.ai_state._tactical_cache_turns <default self.AI_TACTICAL_CACHE_TURNS> = maximum game turns before all actor tactic weight caches are reset
-- @return[1] <table> TACTICAL WEIGHTs {tact1 = <number>, tact2 = <number>, ...}
-- @return[2] <number> the value of a specific tactic (if the tactic argument is a string, i.e. TACTIC label)
-- @return[3] false if no TACTICs could be generated
-- For a sustainable talent:
--		If active:
--			TACTICAL WEIGHTs are negated (i.e. the weights for turning the talent off)
--			TACTICAL WEIGHTs are reduced if the cooldown > 10 (if aitarget is defined)
--		If inactive:
--			TACTICAL WEIGHTs of any talents that would be deactivated (sustain_slots) are subtracted
--			TACTICAL WEIGHTs are reduced if drains would prevent sustaining the talent for at least 10 turns
--		Additional TACTICAL WEIGHTs are generated for drained resources (unless they are already defined in the tactical table or tactic parameter defines a new tactical table):
--			(i.e. t.drain_vim > 0 --> ["vim"]=<negative value>)
function _M:aiTalentTactics(t, aitarget, target_list, tactic, tg, wt_mod)
	-- set up caching for tactical values
	local cache_turns = self.ai_state._tactical_cache_turns or self.AI_TACTICAL_CACHE_TURNS -- # game turns cached values are valid (all talents)
	local cache_wt_values -- allow caching of tactical weights in self._ai_tact_wt_cache
	local tp_cache_tactics -- allow caching of tactics results in self._turn_ai_tactical
	self._turn_ai_tactical = self._turn_ai_tactical or {_new_tact_wt_cache = false}
	local tp_cache = self._turn_ai_tactical -- turn_procs tactical cache
	local tpid_cache = tp_cache[t.id] -- turn_procs tactical cache (this talent)
	local log_detail = config.settings.log_detail_ai or 0
	
	local force_cache_test = config.settings.tactical_cache_test
	
	if log_detail > 1 then print(("[aiTalentTactics] COMPUTING TACTICs [%d]%s(OHash:%s) (%s, wt_mod:%s, wt cache_turns:%d) for talent: %s targeted on %s[%s], tg=%s"):format(self.uid, self.name, self.aiOHash, tactic or "all", wt_mod, cache_turns, t.id, aitarget and aitarget.uid, aitarget and aitarget.name, tg)) end 

	-- build/reset the master target tactical weight cache periodically
	if not self._ai_tact_wt_cache or game.turn - self._ai_tact_wt_cache._computed >= cache_turns and not tp_cache._new_tact_wt_cache then
		if log_detail > 2 then print("[aiTalentTactics] *** creating new TACTICAL WEIGHT CACHE, turn", game.turn) end
		self._ai_tact_wt_cache = {_computed=game.turn}
		tp_cache._new_tact_wt_cache = true
	end

	local tac_cache = self._ai_tact_wt_cache -- master target tactical weight cache
	local tid_cache -- target tactical weight cache (this talent)
	local cache_tactic = type(tactic) ~= "string" and tactic or nil -- tactical data reference
	local targets = target_list -- specified target list	
	-- initialize the tactical weight cache for this talent if the tactical table (tactic argument) has changed
	local reset_cache = not tac_cache[t.id] or cache_tactic ~= tac_cache[t.id].tactic
	local tactical, no_implicit -- final resolved tactical table, flag to exclude implicit tactics
	local requires_target = self:getTalentRequiresTarget(t)
	local hostile_target = aitarget and (self:reactionToward(aitarget) < 0 or aitarget:attr("encased_in_ice"))
	local is_active = self:isTalentActive(t.id)
	local weight_mod = 1 -- master tactic weight modifier
	local tactics, has_tacs
	local implicit_tacs, deac_tactics --implicit (resource) tactics, and tactics for sustains that would need to be deactivated

	local cache_tactics -- cache values
	
	if force_cache_test and log_detail > 2 then -- output cache summary
		print("[aiTalentTactics] _**_ summary of CACHED DATA", self.uid, self.name, t.id) table.print(tpid_cache, "\t_tp_c_")
		if tpid_cache and tpid_cache.targets then
			local tgts = tpid_cache.targets
			print("[aiTalentTactics] _______turn_procs CACHED TARGETS for talent", t.id, "selffire=", tpid_cache.selffire,"friendlyfire=", tpid_cache.friendlyfire)
			local last_act, i, act
			repeat
				if tgts.__CLASSNAME then
					act, last_act = tgts, true
				else
					i, act = next(tgts, i)
					if not act then break end
				end
				print("\t", i, act, "at", act.x, act.y, act.uid, act.name)
			until last_act or not i
		end
		print("[aiTalentTactics] _**_ai_state CACHED TARGET TACTICAL WEIGHTS for talent", t.id) table.print(tac_cache[t.id], "\t_ais_twc_")
	end

	 -- If possible, get/reconstruct TACTIC WEIGHTs from turn_procs cached data (for consistent inputs)
	if tpid_cache and not reset_cache then
		-- The base and implicit tactics are stored separately so that the final tactics table can be reconstructed
		-- This allows the cached data to be used for different values of weight_mod (if an instant action changes resource status, for example)

		-- Possibly get the tactics from cached data (if present and inputs are consistent)
		if tpid_cache.tactics and tpid_cache.tactic == cache_tactic and (tpid_cache.target_list == target_list or table.equivalence(tpid_cache.target_list, target_list)) then

			if log_detail > 3 then print("[aiTalentTactics] ***using cached TACTICS DATA ***", t.id, "tactic=", tactic, "cached tactic=", tpid_cache.tactic, "tpid_cache.wt_mod=", tpid_cache.wt_mod, "wt_mod=", wt_mod) end

			if tpid_cache.wt_mod == wt_mod then -- exact same inputs, use last computed tactics directly
				tactics, has_tacs = tpid_cache.tactics, tpid_cache.has_tacs
				weight_mod = 1 -- tactics don't need any adjustment
				if log_detail >= 2 then print("[aiTalentTactics] ***TACTICS TABLE (RETRIEVED from cache)***", t.id) table.print(tactics, "\t_ctr_") end
			else -- different wt_mod, reconstruct last computed tactics from last base_tacs, implicit_tacs
				tactical, tactics = tpid_cache.tactical, table.clone(tpid_cache.base_tacs)
				has_tacs, implicit_tacs = tpid_cache.has_tacs, tpid_cache.implicit_tacs
				weight_mod = (wt_mod and wt_mod*(is_active and -1 or 1) or tpid_cache.calc_weight_mod or 1)
				if log_detail > 3 then print("\tcached base_tacs:") table.print(tactics, "_*cbt_") end
				if weight_mod ~= 1 then -- adjust cached base tactics (once) for wt_mod
					for tact, val in pairs(tactics) do
						tactics[tact] = val*weight_mod
					end
				end
				weight_mod = 1
				if implicit_tacs then -- add any implicit tactics
					if log_detail > 3 then print("\tcached implicit_tacs:") table.print(implicit_tacs, "_*cit_") end
					local iwt_mod = (wt_mod or 1)*(is_active and -1 or 1)
					for tact, val in pairs(implicit_tacs) do
						tactics[tact] = (tactics[tact] or 0) + val*iwt_mod
					end
					implicit_tacs = nil -- ensures it's not added again at end
				end
				if log_detail >= 2 then print("[aiTalentTactics] ***TACTICS TABLE (RECONSTRUCTED from cache)***", t.id) table.print(tactics, "\t_ctR_") end

			end
			cache_tactics = tactics -- for possible later comparison with force_cache_test
		end
	end
	if force_cache_test or not tactics then -- perform tactics computation (no cache)
		--FIRST, process the talent tactical info (tactical table or function)
		if type(tactic) == "function" then tactic = tactic(self, t, aitarget) end
		if type(tactic) == "table" then -- use the tactical table supplied as an argument
			tactical = tactic
			tactic = nil no_implicit = true
		else -- or get the tactical table from the talent
			tactical = t.tactical
			if self.ai_state._imp_tactical and t.tactical_imp then --(DEBUGGING transitional, try to get the "improved" tactical table for full tactical table support)
			if log_detail >= 2 then print("[aiTalentTactics] *** retrieving talent IMPROVED TACTICAL information ***") end
				tactical = t.tactical_imp
			end --(DEBUGGING transitional)
			if type(tactical) == "function" then tactical = tactical(self, t, aitarget) end
		end
		if log_detail >= 2 then print("[aiTalentTactics]__ using talent tactical table for", t.id) table.print(tactical, "\t___") end
		if not tactical then return false end

		if not tpid_cache then -- set up new turn_procs cache
			if log_detail > 2 then print("[aiTalentTactics] *** creating new turn_procs CACHE for talent", t.id) end
			tpid_cache = {} tp_cache[t.id] = tpid_cache
		end

		-- reset if the (possibly talent-specific) cache duration has expired or the offensive hash has changed
		cache_turns = tactical.__wt_cache_turns or cache_turns
		reset_cache = reset_cache or game.turn - tac_cache[t.id]._computed >= cache_turns or tac_cache[t.id]._OHash ~= self.aiOHash

		-- consider marking the weight cache (turn_procs?) table for no save self._no_save_fields (to avoid possible collisions of UID's in _tact_wt_cache[t.id][act.uid]

		if reset_cache then
			if log_detail > 2 then print("[aiTalentTactics] *** creating new target WEIGHT CACHE for talent", t.id, "cache validity(turns):", cache_turns, "aiOHash:", self.aiOHash, "vs (cache):", tac_cache[t.id] and tac_cache[t.id]._OHash) end
			tac_cache[t.id] = {_computed=game.turn, tactic=cache_tactic, _OHash=self.aiOHash}
		end
		tid_cache = tac_cache[t.id]

		tactics, weight_mod, has_tacs, implicit_tacs = {}, 1, false, nil -- initialize output data
		local selffire, friendlyfire
		-- SECOND, get the target(s) for the talent
		if not targets then
			if tpid_cache.targets and not force_cache_test then -- retrieve targets, selffire, friendlyfire, tg from cache
				targets, selffire, friendlyfire, tg = tpid_cache.targets, tpid_cache.selffire, tpid_cache.friendlyfire, tpid_cache.tg
				if log_detail >= 2 then print("[aiTalentTactics] \t targets from turn_procs cache for", t.id, "SF=", selffire, "FF=", friendlyfire, "targets=", targets.__CLASSNAME and targets.name or targets, "tg=", tg) end
			else -- generate targets, selffire, friendlyfire
				local SF, FF
				if log_detail >= 2 then print("[aiTalentTactics] extracting targets, selffire, friendlyfire from tg:", tg or "(from talent)") if tg then table.print(tg, "\t_tg_") end end
				targets, SF, FF, tg = self:aiTalentTargets(t, aitarget, tg, true)
				selffire, friendlyfire = SF/100, FF/100
			end
		else -- use specified target list but compute friendlyfire and selffire from targeting table
			if self:attr("nullify_all_friendlyfire") and not t.ignore_nullify_all_friendlyfire then 
				selffire, friendlyfire = 0, 0
			else
				tg = tg or self:getTalentTarget(t)
				if tg then
					if log_detail >= 2 then print("[aiTalentTactics] extracting selffire, friendlyfire from", tg) table.print(tg, "\t_tg_") end
					local typ = engine.Target:getType(tg)
					selffire = typ.selffire and (type(typ.selffire) == "number" and typ.selffire/100 or 1) or 0
					friendlyfire = typ.friendlyfire and (type(typ.friendlyfire) == "number" and typ.friendlyfire/100 or 1) or 0
				else selffire, friendlyfire = 1, 1
				end
			end
		end

		if not tactical._no_tp_cache then -- update tp_cache values, including inputs for later comparison
			if log_detail > 2 then print("[aiTalentTactics] *** updating turn_procs CACHE for talent", t.id) end
			tp_cache_tactics = true -- trigger pushing computed tactical info to turn_procs
			tpid_cache.target_list, tpid_cache.tactic, tpid_cache.wt_mod = target_list, cache_tactic, wt_mod
			tpid_cache.tactics, tpid_cache.tactical = tactics, tactical
			tpid_cache.targets, tpid_cache.selffire, tpid_cache.friendlyfire, tpid_cache.tg = targets, selffire, friendlyfire, tg
		end

		-- compassion only affects harmful tactics (self.AI_TACTICS[tact] < 0, e.g. attack) used against self and allies
		local self_compassion = (self.ai_state.self_compassion == false and 0) or self.ai_state.self_compassion or 5
		local ally_compassion = (self.ai_state.ally_compassion == false and 0) or self.ai_state.ally_compassion or 1		
		if log_detail >= 2 then --summarize the list of targets for the talent
			print(("[aiTalentTactics]\ttargets for %s: RT:%s(hostile:%s%s) TG:%s SF(x%s)=%s, FF(x%s)=%s"):format(t.id, requires_target, hostile_target, t.onAIGetTarget and ",onAIGetTarget" or "", tg, self_compassion, selffire, ally_compassion, friendlyfire))
			if targets.__CLASSNAME then
				print("\t____", t.id, "may hit", targets.uid, targets.name, "at", targets.x, targets.y)
			else
				for i, tgt in ipairs(targets) do
					print("\t____", t.id, "may hit", tgt.uid, tgt.name, "at", tgt.x, tgt.y)
				end
			end	
		end

		-- THIRD, evaluate each TACTIC using the list of targets
		local tact, val, all_tactics
		local self_tactics
		-- don't cache weights if caching is disabled or SELF is the only target
		cache_wt_values = targets ~= self and cache_turns > 0

		repeat -- FOR EACH TACTIC
			tact, val = next(tactical, tact)
			if not val then
				if self_tactics then -- compute self tactics last, don't cache tactical weights (recompute each time)
					if log_detail >= 2 then print("[aiTalentTactics] begin processing self_tactics:", self_tactics, "\t") table.print(self_tactics, "\t_st_") end
					tactical, self_tactics, cache_wt_values = self_tactics, nil, false
					requires_target, hostile_target = true, false
					targets, selffire, friendlyfire = self, 1, 1
					tact, val = next(tactical)
				end
				if not val then break end
			end
			
			local benefit = self.AI_TACTICS[tact]
			if tact == "self" then -- set up tactics applied only to self for last loop iteration
				if type(val) == "function" then self_tactics = val(self, t, aitarget) else self_tactics = val end
			elseif benefit then -- evaluate the tactic
				local weighted_sum = 0 -- total weight for this tactic
				-- initialize the tactic cache for this tactic if needed
				if cache_wt_values and not tid_cache[tact] then tid_cache[tact] = {} end

				-- note: the "heal" tactic does not take healing_factor of the target into account (can affect either aitarget or self)
				--== TACTIC INTERPRETATION ==-- use target parameters and current target to interpret tactical values
				local f_mult, s_mult, a_mult = 1, 1, 1 -- reaction weights for foes, self, allies
				if tact ~= "special" then
					if requires_target then -- talent explicitly targeted: correct target is assumed
						--all tactics (positive values) are useful (for the talent user) against ai_target
						-- compassion only affects harmful tactics against friendly targets (to avoid over-stacking of beneficial tactical values)
						if hostile_target then -- talent targets foes
							if benefit < 0 then -- harmful tactic used on foes (e.g. attack) penalized for hitting allies (compassion applied)
								f_mult, s_mult, a_mult = -1, self_compassion, ally_compassion
							else -- beneficial tactic (e.g. heal) used on foes beneficial (for self) against all targets
								f_mult, s_mult, a_mult = 1, 1, 1
							end
						else -- talent targets allies (no compassion effects)
							if benefit < 0 then -- harmful tactic (e.g. attack) used on allies, penalized for hitting foes (this is a little weird but follows the rule)
								f_mult, s_mult, a_mult = 1, -1, -1
							else -- beneficial tactic (e.g. heal) used on allies, penalized for hitting foes
								f_mult, s_mult, a_mult = -1, 1, 1
							end
						end
					else -- talent may be used without a target (applied to self if there are no targets)
						if tg then -- talent has targeting parameters; intended to affect others
							if benefit < 0 then -- harmful tactic penalized for hitting allies (compassion applied)
								f_mult, s_mult, a_mult = -1, self_compassion, ally_compassion
							else -- beneficial tactic (e.g. heal) penalized for hitting foes
								f_mult, s_mult, a_mult = -1, 1, 1
							end
						else -- no targeting parameters, talent assumed to affect the user (no adjustments)
							if benefit < 0 then -- harmful tactic useful against self (like escape) penalized for hitting allies (no compassion effects)
								f_mult, s_mult, a_mult = 1, -1, -1
							else -- beneficial tactic useful against self (like heal) penalized for hitting foes
								f_mult, s_mult, a_mult = -1, 1, 1
							end
						end
					end
				end
				if log_detail >= 2 then print(("[aiTalentTactics] computing tactic %s(%s), val=%s, RT:%s, HT:%s, reaction weights (f=%s, s=%s, a=%s):"):format(tact, benefit, val, requires_target, hostile_target, f_mult, s_mult, a_mult)) end
				local last_act = false
				local i, act--, use_cache
				repeat -- FOR EACH TARGET: retrieve/compute the effectiveness of the tactic for each target
					if targets.__CLASSNAME then
						act, last_act = targets, true
					else
						i, act = next(targets, i)
						if not act then break end
					end
					-- Note: always recalculate weights against self or for the "cure" tactic
					local tgt_weight = cache_wt_values and act ~= self and tact ~= "cure" and tid_cache[tact] and tid_cache[tact][act]
--					if force_cache_test and log_detail > 2 then print("\t__cached weight for tactic:", tact, "vs", act.uid, act.name, "==", tid_cache[tact] and tid_cache[tact][act]) end

					-- Discard the cached tactic weight value for the actor if its defensive hash value has changed
					if tgt_weight and tid_cache[tact][act.uid] ~= act.aiDHash then
						if log_detail > 3 then print("\t__DEFENSIVE HASH reset for tactic:", tact, act.aiDHash, "vs (cached DHash)", tid_cache[tact][act.uid], "for aitarget:", act.uid, act.name) end
						tgt_weight = nil
					end

					local cache_tgt_weight = tgt_weight -- save cached value for possible later check
					if force_cache_test then -- force recomputation of tactical weights
						if log_detail > 2 then print("\t__cached weight for tactic:", tact, "vs", act.uid, act.name, "==", tid_cache[tact] and tid_cache[tact][act]) end
						tgt_weight = nil
					end
					
					if not tgt_weight then -- compute the tactic weight value for this target
						local val = val
						if type(val) == "function" then -- evaluate a function
							if log_detail > 2 then print("\t resolving functional tactic value", val) end
							val = val(self, t, act) or 0
							if log_detail > 2 then print("\t tactic value:", val) table.print(val, "\t\t") end
						end

						local all_vals, val_type, val_wt = false
						tgt_weight = 0
						local count = 10 -- maximum # tactics
						repeat -- FOR EACH WEIGHT parameter: compute the tactical weight for this target
							weight = 0
							count = count - 1
							if type(val) ~= "table" then -- numerical or functional
								val_type, val_wt = val, val
								all_vals = true
							else
								val_type, val_wt = next(val, val_type) if not val_wt then break end
							end
							if act == self then -- hit self
								weight = selffire*friendlyfire*s_mult*benefit -- matches actor:project
							elseif self:reactionToward(act) >= 0 then -- hit ally
								weight = friendlyfire*a_mult*benefit
							else -- hit foe
								weight = f_mult*benefit
							end
							if log_detail > 2 then print("[aiTalentTactics] tactic:", tact, "val_type =", val_type, "val_wt=", val_wt, "weight", weight, "against", act and act.uid, act and act.name) end
							if weight ~= 0 then
								local effect_type, effect_wt = val_type, val_wt
								local res = 0
								local _, status_chance
	
								-- evaluate function for effect type (update DamageType and weight (wt_adj))
								-- handle predefined "weapon", "archery", "offhand" functions
								local special = type(effect_type) == "function" and effect_type or self.aiSubstDamtypes[effect_type]
								if special then
									if log_detail > 2 then print("\t resolving special effect_type:", effect_type) end
									local wt_adj
									effect_type, wt_adj = special(self, t, act)
									if log_detail > 2 then print("\t special effect_type returned:", effect_type, wt_adj) end
									weight = weight*(wt_adj or 1)
								end
								if type(effect_type) == "number" then -- numerical weights assume no resistances
									effect_wt = effect_type
								else -- evaluate table (adjust for DamageType resistance and status immunities)
									-- evaluate function for effect weight
									if type(effect_wt) == "function" then effect_wt = effect_wt(self, t, act) or 0 end
									
									-- Note: this does not handle the "all_damage_convert_percent" attribute
									--if src:attr("all_damage_convert") and src:attr("all_damage_convert_percent") and src.all_damage_convert ~= type
									
									if DamageType[effect_type] then -- calculate effective DamageType modifiers (increase, resistance, penetration, and affinity)
										local inc, pen = self:combatGetDamageIncrease(effect_type), util.bound(self:combatGetResistPen(effect_type), 0, 100)
										weight = weight*(1 + inc/100)
										res = act:combatGetResist(effect_type)
										if log_detail > 2 then print("\t\t_DamageType Modifiers:", effect_type, "inc, pen, res, aff=", inc, pen, res, act:combatGetAffinity(effect_type)) end
										res = util.bound(res > 0 and res * (100 - pen) / 100 or res, -100, 100) + act:combatGetAffinity(effect_type)
									else -- calculate status immunity
										_, status_chance = act:canBe(effect_type) --Status immunity
										if log_detail > 2 then print("\t\t--- status_chance", effect_type, status_chance) end
										res = 100 - status_chance or 0
									end
									if type(effect_wt) == "table" then -- sum the list of statuses and weights that can affect the actor
										local e_wt = 0
										for status, wt in pairs(effect_wt) do
											_, status_chance = act:canBe(status) --Status immunity
											e_wt = e_wt + wt*status_chance/100
											if log_detail > 3 then print("\t\t__status_chance", effect_type, status, status_chance) end
										end
										effect_wt = e_wt
--										if log_detail > 2 then print("\t__status effect weight sum", effect_type, "against", act.uid, act.name, "res=", res, "raw wt:", effect_wt) end
									end
									if log_detail > 2 then print("\t__raw effect_wt ", effect_type, "against", act.uid, act.name, "res=", res, "raw wt:", effect_wt) end
									effect_wt = effect_wt*(100 - res) / 100 -- apply the effective resistance
								end
								effect_wt = effect_wt*weight
								if log_detail > 2 then print("\t__mod effect_wt ", effect_type, "against", act.uid, act.name, "weight=", weight, "res=", res, "mod wt:", effect_wt) end
								-- update totals
								tgt_weight = tgt_weight + effect_wt
							end
						until all_vals or not val_type or count <= 0 -- end target weight loop
						if log_detail > 2 then print("\t__total effect weight tactic:", tact, "actor:", act.uid, act.name, "==", tgt_weight) end
						if cache_wt_values and act ~= self then -- cache the tactical weight value
							-- compare to the previously cached weight value if instructed
							if force_cache_test and cache_tgt_weight then
								local color, msg if act == aitarget then color, msg = "#YELLOW#", "MAIN TARGET" else color, msg = "#ORANGE#", "off target" end
								if math.abs(tgt_weight - cache_tgt_weight) > 1e-6 then -- cache mismatch
									print(("\t***TACTICAL WEIGHT CACHE MISMATCH: [%d]%s %s (%s) on [%d]%s{%s}: %s vs %s(cache)"):format(self.uid, self.name, t.id, tact, act.uid, act.name, msg, tgt_weight, cache_tgt_weight))
									if log_detail > 1.4 and config.settings.cheat then game.log("_[%d]%s %s%s tactical weight CACHE MISMATCH (%s) vs %s[%d]{%s}: %s vs %s(cache)", self.uid, self.name, color, t.id, tact, act.name, act.uid, msg, tgt_weight, cache_tgt_weight) end
								elseif log_detail > 3 then
									print(("\t***TACTICAL WEIGHT CACHE MATCHES: [%d]%s %s (%s) on [%d]%s{%s}: %s vs %s(cache)"):format(self.uid, self.name, t.id, tact, act.uid, act.name, msg, tgt_weight, cache_tgt_weight))
								end
							end
							tid_cache[tact][act] = tgt_weight
							tid_cache[tact][act.uid] = act.aiDHash
							if log_detail > 3 then print("\t__updated cached weight for tactic:", tact, "vs", act.uid, act.name, "==", tid_cache[tact][act]) end
						end
					end -- end compute target weight branch
					weighted_sum = weighted_sum + tgt_weight
				until last_act or not i -- end target loop				
				if log_detail > 2 then print(("[aiTalentTactics] --- total tactical weight: %s=%s(%s),{RT=%s, tgt=%s (aitarget:%s, %s)}"):format(tact, weighted_sum, benefit, requires_target, t.target, aitarget and aitarget.name, hostile_target and "hostile")) end
				-- add to the tactic value
				if not tactics[tact] then
					tactics[tact] = 0
					has_tacs = true
				end
				tactics[tact] = tactics[tact] + weighted_sum
			elseif tact == nil then
				print("[aiTalentTactics]", t.id, "disregarding UNDEFINED TACTIC:", tact)
			end
		until all_tactics -- end tactic loop

		--Note: implicit resource tactics for normal resource costs could be generated here.
		--This would allow the AI to consider resource costs when choosing talents and try to conserve depleted resources, etc.
	
		--== SUSTAINED TALENTS ==-- (special handling)
		-- generate implicit resource tactics and modify weight (if the talent drains resources)
		-- negate tactic weights for active talents and subtract talents to deactivate (sustain_slots)
		if t.mode == "sustained" then
			-- if the talent drains resources (table from initialization), add resource tactics to the tactics table
			local drain_time = 100 -- (estimated) turns the talent can be kept up before a resource runs out
			if t._may_drain_resources and not no_implicit then
				implicit_tacs = {}
				if log_detail > 2 then print("===evaluating resource draining sustained talent", t.id, is_active and "(active)" or "(inactive)") end
				local drains = {} -- drained resources
				local drain, tact, res_def
				local recover_rate -- fraction of std pool recovered/turn if drain rate is reversed
				local std_pool -- pool size against which to weigh gains, losses, and regeneration
				for res, i in pairs(t._may_drain_resources) do
					res_def = ActorResource.resources_def[res]
					drain = util.getval(t[res_def.drain_prop], self, t)
					if drain and drain ~= 0 then -- drains/replenishes resource
						drains[res] = drain
					end
				end
				--print("--- sustained talent drains resources:") table.print(drains, "====")
				for res, drain in pairs(drains) do
					if not tactics[res] then -- generate a tactic for the resource if it's not already present
						res_def = ActorResource.resources_def[res]
						local turns = 100 -- depletion time for resource
						 -- resource computations assume the talent is active
						local regen = self[res_def.regen_prop] + (not is_active and drain*(res_def.invert_values and 1 or -1) or 0)
						std_pool = res_def.ai and res_def.ai.tactical and res_def.ai.tactical.default_pool_size or ((res_def.max or 100) - (res_def.min or 0))
						recover_rate = drain/std_pool
						 -- if the resource is being depleted, compute estimated time to depletion, allowing for  estimated use each turn
						if res_def.invert_values then
							if regen >= 0 then
								if self[res_def.maxname] then
									turns = (self[res_def.maxname] - self[res_def.getFunction](self))/(regen + std_pool*self.AI_RESOURCE_USE_EST)
								else
									turns = std_pool/(regen + std_pool*self.AI_RESOURCE_USE_EST)
								end
							end
						else
							if regen <= 0 then
								if self[res_def.minname] then
									turns = (self[res_def.getFunction](self) - self[res_def.minname])/(-regen + std_pool*self.AI_RESOURCE_USE_EST)
								else
									turns = std_pool/(-regen + std_pool*self.AI_RESOURCE_USE_EST)
								end
							end
						end
						drain_time = math.min(drain_time, turns)
						implicit_tacs[res] = -5*recover_rate/(recover_rate + 0.4) -- < 5, = 1 for 10% recovery/turn
						has_tacs = true
						if log_detail > 2 then print("  ===implicit resource tactic:", t.id, "drains", drain, res, "active regen:", regen, "value:", implicit_tacs[res] ,"--depleted in", turns, "turns, recovery:", recover_rate, "/turn") end
					end
				end
			end
			if is_active then
				if aitarget then  -- in combat, reduce weight if the cooldown is > 10 turns, unless the talent cannot be sustained for long
					weight_mod = math.min(weight_mod, (100/math.min(10, drain_time)/util.bound(self:getTalentCooldown(t) or 1, 2, 50))^.5)
				end
				weight_mod = -weight_mod -- negate for active sustains
			else --reduce weight for inactive sustains if they can't be kept up for at least 10 turns
				weight_mod = math.min(weight_mod, math.max(0, drain_time-1)/9)
				--sustain_slots: add the (negative) tactical values for sustain(s) that would be deactivated
				local slots = t.sustain_slots
				if slots and self.sustain_slots then -- inlined from Actor:getReplacedSustains(talent) for speed
					if 'string' == type(slots) then slots = {slots} end
					for _, slot in pairs(slots) do
						local talid = self.sustain_slots[slot]
						if talid and self:isTalentActive(talid) then --calculate tactical table for talent that would be turned off
							local tal = self:getTalentFromId(talid)
							if log_detail >= 2 then print("[aiTalentTactics]", t.id, "**DEACTIVATES**", talid, ":::") end
							deac_tactics = self:aiTalentTactics(tal, aitarget, nil, nil, nil, 1) -- use full weight here (ignore cooldown and drain effects for deactivated talent)
							if log_detail >= 2 then print("[aiTalentTactics]", t.id, "**DEACTIVATION TACTICS**", talid, "tactics:", string.fromTable(deac_tactics)) end
							if deac_tactics then -- add to the tactics table
								table.merge(tactics, deac_tactics, true, nil, nil, true) -- deep merge, add numbers
								has_tacs = true
							end
						end
					end
				end
			end
			if log_detail >= 2 then print("\t--- sustained weight modifier adjustment:", weight_mod, drain_time, "usable_turns, cooldown turns:", self:getTalentCooldown(t), is_active and "active" or "inactive") end
		end -- end sustained branch
		if tp_cache_tactics then -- cache computed tactical info to turn_procs to reconstruct the tactical table on later calls
			tpid_cache.base_tacs, tpid_cache.tactics = table.clone(tactics), tactics -- save base tactics (weight_mod not applied)
			tpid_cache.implicit_tacs = implicit_tacs
			if log_detail > 2 or force_cache_test then
				print("  ***tp_caching base tactical table,", self.uid, self.name, t.id, tpid_cache.base_tacs) table.print(tpid_cache.base_tacs, "\t_bt_")
				if implicit_tacs then print("  ***tp_caching implicit tactics:") table.print(implicit_tacs, "\t_it_") end
			end
			tpid_cache.wt_mod = wt_mod -- cache input wt_mod
			tpid_cache.has_tacs = has_tacs
			tpid_cache.calc_weight_mod = weight_mod -- cache the computed weight_mod
		end
		if wt_mod then weight_mod = weight_mod*wt_mod end
	end -- end tactics computation (no cache) branch
	-- apply the weight modifier (weight_mod, will be negated for active sustains)
	if log_detail >= 2 then print("\t\tis_active=", is_active, "wt_mod=", wt_mod, "weight_mod=", weight_mod) end
	if weight_mod ~= 1 then
		for tact, val in pairs(tactics) do
			tactics[tact] = val*weight_mod
		end
	end
	-- add any implicit tactics (not affected by weight_mod, but negated for active sustains)
	if implicit_tacs then
		--if log_detail >= 2 then print("  ***adding implicit tactics:") table.print(implicit_tacs, "\t_it_") end -- debugging
		local iwt_mod = (wt_mod or 1)*(is_active and -1 or 1)
		for tact, val in pairs(implicit_tacs) do
			tactics[tact] = (tactics[tact] or 0) + val*iwt_mod
		end
	end
	if log_detail >= 2 then print("[aiTalentTactics] ***COMPUTED TACTICS TABLE***", t.id, is_active and "active sustain", "wt_mod=", wt_mod, "weight_mod=", weight_mod, "tactics:") table.print(tactics, "\t_ft_") end
	
	-- if requested, compare results to the cache-reconstructed tactical table
	if force_cache_test and cache_tactics and tp_cache_tactics then
		print("[aiTalentTactics] ***previous TACTICS TABLE (from tp cache)***", self.uid, self.name, t.id, "cache_tactics:") table.print(cache_tactics, "\t_octf_")

		if not table.equivalence(tactics, cache_tactics) then
			print("[aiTalentTactics] ***tp TACTICS TABLE CACHE MISMATCH", self.uid, self.name, t.id)
			local ctt = string.fromTable(cache_tactics, nil, nil, nil, nil, true)
			print("____Cached tactics:", ctt)
			local ntt = string.fromTable(tactics, nil, nil, nil, nil, true)
			print("____Computed tactics:", ntt)
			if log_detail > 1.4 and config.settings.cheat then -- debugging
				game.log("_[%d]%s #YELLOW# TACTICAL turn_procs CACHE MISMATCH for %s", self.uid, self.name, t.id)
				game.log("#YELLOW_GREEN#____Cached tactics: %s", ctt)
				game.log("#YELLOW_GREEN#__Computed tactics: %s", ntt)
			end -- debugging end
		else
			print("[aiTalentTactics] ***tp CACHED TACTICS TABLE MATCHES new TACTICS TABLE", self.uid, self.name, t.id)
		end
	end
	
	if has_tacs then
		if type(tactic) == "string" then
			return tactics[tactic] or 0
		else
			return tactics
		end
	end
	return false
end

--- Sets the current AI target
-- @param [type=Entity, optional] target the target to set (assign nil to clear the target)
-- @param [type=table, optional] last_seen data for use by aiSeeTargetPos
-- When targeting a new entity, checks self.on_acquire_target and target.on_targeted
function _M:setTarget(target, last_seen)
	local old_target = self.ai_target.actor
	engine.interface.ActorAI.setTarget(self, target, last_seen)
	if target and target ~= old_target and game.level:hasEntity(target) then
		if target.fireTalentCheck then target:fireTalentCheck("callbackOnTargeted", self) end
	end
end
