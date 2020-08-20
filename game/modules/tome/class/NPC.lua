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

require "engine.class"
local Faction = require "engine.Faction"
local Emote = require("engine.Emote")
local Chat = require "engine.Chat"
local Particles = require "engine.Particles"
local Actor = require "mod.class.Actor"

module(..., package.seeall, class.inherit(mod.class.Actor))

function _M:init(t, no_default)
	mod.class.Actor.init(self, t, no_default)

	-- Grab default image name if none is set
	if not self.image and self.name ~= "unknown actor" then self.image = "npc/"..tostring(self.type or "unknown").."_"..tostring(self.subtype or "unknown"):lower():gsub("[^a-z0-9]", "_").."_"..(self.name or "unknown"):lower():gsub("[^a-z0-9]", "_")..".png" end
end

_M._silent_talent_failure = true

function _M:actBase()
	-- Reduce shoving pressure every turn
	if self.shove_pressure then
		if self._last_shove_pressure and (self.shove_pressure < self._last_shove_pressure) then
			self.shove_pressure = nil
			self._last_shove_pressure = nil
		else
			self._last_shove_pressure = self.shove_pressure
			self.shove_pressure = self.shove_pressure / 2
		end
	end
	-- Run out of time ?
	if self.summon_time and not self:attr("no_timeflow") then
		self.summon_time = self.summon_time - 1
		if self.summon_time <= 0 then
			if not self.summon_quiet then
				game.logPlayer(self.summoner, "#PINK#Your summoned %s disappears.", self:getName())
			end
			self:die()
			self.dead_by_unsummon = true
		end
	end
	return mod.class.Actor.actBase(self)
end

-- Entry point for NPC's to act, invoking the AI, called by engine.GameEnergyBased:tickLevel
function _M:act()
	if config.settings.log_detail_ai > 2 then print("[NPC:act] turn", game.turn, "pre act ENERGY for", self.uid, self.name) table.print(self.energy, "\t_energy_") end
	while self:enoughEnergy() and not self.dead do
		-- Do basic actor stuff
		if not mod.class.Actor.act(self) then return end
		local old_energy = self.energy.value

		-- Compute FOV, if needed
		self:doFOV()

		-- Let the AI think .... beware of Shub !
		self:doAI()

		if self.emote_random and self.x and self.y and game.level.map.seens(self.x, self.y) and rng.range(0, 999) < self.emote_random.chance * 10 then
			local e = util.getval(rng.table(self.emote_random))
			if e then
				local dur = util.bound(#e, 80, 120)
				self:doEmote(e, dur)
			end
		end

		-- If AI did nothing, perform resting actions and then use energy anyway
		if not self.energy.used then
			local err, mrr = self:attr("equilibrium_regen_on_rest"), self:attr("mana_regen_on_rest")
			if err then self:incEquilibrium(err) end
			if mrr then self:incMana(mrr) end
			self:waitTurn() -- This triggers "callbackOnWait" effects
		 end
		if config.settings.log_detail_ai > 2 then print("[NPC:act] turn", game.turn, "post act ENERGY for", self.uid, self.name) table.print(self.energy, "\t_energy_") end

		self:fireTalentCheck("callbackOnActEnd")
		if old_energy == self.energy.value then break end -- Prevent infinite loops
	end
end

function _M:doFOV()
	-- If the actor has no special vision we can use the default cache
	if not self.special_vision then
		self:computeFOV(self.sight or 10, "block_sight", nil, nil, nil, true)
	else
		self:computeFOV(self.sight or 10, "block_sight")
	end
	self:postFOVCombatCheck()
end

local function spotHostiles(self)
	local seen = {}
	if not self.x then return seen end

	-- Check for visible monsters, only see LOS actors, so telepathy wont prevent resting
	core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, self.sight or 10, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
		local actor = game.level.map(x, y, game.level.map.ACTOR)
		if actor and self:reactionToward(actor) < 0 and self:canSee(actor) and game.level.map.seens(x, y) then
			seen[#seen + 1] = {x=x,y=y,actor=actor}
		end
	end, nil)
	return seen
end

function _M:onTalentLuaError(ab, err)
	engine.interface.ActorTalents.onTalentLuaError(self, ab, err)
	self:useEnergy()  -- prevent infinitely long erroring out turns
end

--- Try to auto use listed talents
-- This should be called in your actors "act()" method
function _M:automaticTalents()
	if self.no_automatic_talents then return end

	self:attr("_forbid_sounds", 1)
	for tid, c in pairs(self.talents_auto) do
		local t = self.talents_def[tid]
		local spotted = spotHostiles(self)
		if (t.mode ~= "sustained" or not self.sustain_talents[tid]) and not self.talents_cd[tid] and self:preUseTalent(t, true, true) and (not t.auto_use_check or t.auto_use_check(self, t)) then
			if (c == 1) or (c == 2 and #spotted <= 0) or (c == 3 and #spotted > 0) or (c == 5 and not self.in_combat) then
				if c ~= 2 then
					-- Do not fire hostile talents
					--self:useTalent(tid)
				else
					if not self:attr("blind") then
						self:useTalent(tid,nil,nil,nil,self)
					end
				end
			end
			if c == 4 and #spotted > 0 then
				for fid, foe in pairs(spotted) do
					if foe.x >= self.x-1 and foe.x <= self.x+1 and foe.y >= self.y-1 and foe.y <= self.y+1 then
						self:useTalent(tid)
						break
					end
				end
			end
		end
	end
	self:attr("_forbid_sounds", -1)
end

--- Create a line to target based on field of vision
function _M:lineFOV(tx, ty, extra_block, block, sx, sy)
	sx = sx or self.x
	sy = sy or self.y
	local act = game.level.map(tx, ty, engine.Map.ACTOR)
	local sees_target = core.fov.distance(sx, sy, tx, ty) <= self.sight and game.level.map.lites(tx, ty) or
		act and self:canSee(act) and core.fov.distance(sx, sy, tx, ty) <= math.min(self.sight, math.max(self.heightened_senses or 0, self.infravision or 0))

	extra_block = type(extra_block) == "function" and extra_block
		or type(extra_block) == "string" and function(_, x, y) return game.level.map:checkAllEntities(x, y, extra_block) end

	-- This block function can be called *a lot*, so every conditional statement we move outside the function helps
	block = block or sees_target and 
			-- target is NOT seen
			function(_, x, y)
				if core.fov.distance(sx, sy, x, y) <= self.sight and game.level.map.lites(x, y) then
					return game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_sight") or
						game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") and not game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "pass_projectile") or
						extra_block and extra_block(self, x, y)
				else
					return true
				end
			end

	return core.fov.line(sx, sy, tx, ty, block)
end

-- NOTE:  Theres some evidence that this is one of the laggiest functions when a large number of NPCs are active because it causes an insane number of hasLOS calls
--- Gather and share information about enemies from others
--	applied each turn to every actor in LOS by self:computeFOV (or core.fov.calc_default_fov)
-- @param who = actor acting (updating its FOV info), calling self:seen_by(who)
-- @see ActorFOV:computeFOV, ActorAI:aiSeeTargetPos, NPC:doAI
function _M:seen_by(who)
	if self == who then return end
	if self:hasEffect(self.EFF_VAULTED) and who and game.party:hasMember(who) then self:removeEffect(self.EFF_VAULTED, true, true) end

	-- Check if we can pass target
	if self.dont_pass_target then return end -- This means that ghosts can alert other NPC's but not vice versa ;)
	local who_target = who.ai_target and who.ai_target.actor
	if not (who_target and who_target.x) then return end
	if not (who and who.ai_actors_seen and who.ai_actors_seen[who_target]) then return end  -- Only pass target if we've seen them via FOV at least once, this limits chain aggro
	if self.ai_target and self.ai_target.actor == who_target then return end
	if who.getRankTalkativeAdjust and not rng.percent(who:getRankTalkativeAdjust()) then return end
	-- Only receive (usually) hostile targets from allies
	if self:reactionToward(who) <= 0 or not who.ai_state._pass_friendly_target and who:reactionToward(who_target) > 0 then return end
	
	-- Check if we can actually see the ally (range and obstacles)
	if not who.x or not self:hasLOS(who.x, who.y) then return end
	-- Check if it's actually a being of cold machinery and not of blood and flesh
	if not who.aiSeeTargetPos then return end
	if self.ai_target.actor and not who_target:attr("stealthed_prevents_targetting") then
		-- Pass last seen coordinates if we already have the same target
		if self.ai_target.actor == who_target then
			-- Adding some type-safety checks, but this isn't fixing the source of the errors
			local last_seen = {turn=0}
			if self.ai_state.target_last_seen and type(self.ai_state.target_last_seen) == "table" then
				last_seen = self.ai_state.target_last_seen
			end
			if who.ai_state.target_last_seen and type(who.ai_state.target_last_seen) == "table" and who.ai_state.target_last_seen.turn > last_seen.turn then
				last_seen = who.ai_state.target_last_seen
			end
			if last_seen.x and last_seen.y then
				self.ai_state.target_last_seen = last_seen
				who.ai_state.target_last_seen = last_seen
			end
		end
		return
	end
	
	-- Only trust the ally if they can actually see the target
	if not who:canSee(who_target) then return end
	
	if who.ai_state and who.ai_state.target_last_seen and type(who.ai_state.target_last_seen) == "table" then
		-- Don't believe allies if they think the target is too far away (based on distance to ally plus ally to hostile estimate (1.3 * sight range, usually))
		local tx, ty = who:aiSeeTargetPos(who_target)
		local distallyhostile = core.fov.distance(who.x, who.y, tx, ty) or 100
		local range_factor = 1.2
		if distallyhostile + core.fov.distance(self.x, self.y, who.x, who.y) > math.min(10, math.max(self.sight, self.infravision or 0, self.heightened_senses or 0, self.sense_radius or 0))*range_factor then return end

		-- Don't believe allies if they saw the target over 7 turns ago
		if (game.turn - (who.ai_state.target_last_seen.turn or game.turn)) / (game.energy_to_act / game.energy_per_tick) > 7 then return end
	end

	print("[NPC:seen_by] Passing target", who_target.name, "from", who.uid, who.name, "to", self.uid, self.name)
	
	-- If we have no current target but the passed target is stealthed, delay aquiring for 3 turns but make sure they can't avoid aggro entirely
	if who_target:attr("stealthed_prevents_targetting") and not (self.ai_target and self.ai_target.actor) then
		self:setEffect(self.EFF_STEALTH_SKEPTICAL, 3, {target = {actor=who_target, last = who.ai_state.target_last_seen}})
		return
	end
	self:setTarget(who_target, who.ai_state.target_last_seen)
end

--- Check if we are angered
-- @param src the angerer
-- @param set true if value is the finite value, false if it is an increment
-- @param value the value to add/subtract
function _M:checkAngered(src, set, value)
	if not src.resolveSource then return end
	if not src.faction then return end
	if self.never_anger then return end
	if game.party:hasMember(self) then return end
	if self.summoner and self.summoner == src then return end

	-- Cant anger at our own faction unless it's the silly player
	if self.faction == src.faction and not src.player then return end

	local rsrc = src:resolveSource()
	local rid = rsrc.unique or rsrc.name
	if not self.reaction_actor then self.reaction_actor = {} end

	local was_hostile = self:reactionToward(src) < 0

	if not set then
		self.reaction_actor[rid] = util.bound((self.reaction_actor[rid] or 0) + value, -200, 200)
	else
		self.reaction_actor[rid] = util.bound(value, -200, 200)
	end

	if not was_hostile and self:reactionToward(src) < 0 then
		if self.anger_emote then
			self:doEmote(self.anger_emote:gsub("@himher@", src.female and _t"her" or _t"him"), 30)
		end
	end
end

function _M:setPersonalReaction(src, value)
	local rsrc = src:resolveSource()
	local rid = rsrc.unique or rsrc.name
	if not self.reaction_actor then self.reaction_actor = {} end
	self.reaction_actor[rid] = util.bound(value, -200, 200)
end

function _M:getPersonalReaction(src, value)
	local rsrc = src:resolveSource()
	local rid = rsrc.unique or rsrc.name
	if not self.reaction_actor then self.reaction_actor = {} end
	return self.reaction_actor[rid] or 0
end

--- Counts down timedEffects, but need to avoid the damaged A* pathing
function _M:timedEffects(filter)
	self._in_timed_effects = true
	mod.class.Actor.timedEffects(self, filter)
	self._in_timed_effects = nil
end

--- Called by ActorLife interface
-- We use it to pass aggression values between NPCs
function _M:onTakeHit(value, src, death_note)
	value = mod.class.Actor.onTakeHit(self, value, src, death_note)
	
	-- Switch to astar pathing temporarily
	if src and src == self.ai_target.actor and not self._in_timed_effects then
		self.ai_state.damaged_turns = 10
	end

	if value > 0 and src and src ~= self and src.resolveSource then
		if not src.targetable then src = util.getval(src.resolveSource, src) end
		if src then
			if src.targetable and not self.ai_target.actor and not (self.never_anger and self:reactionToward(src) > 0) then self:setTarget(src) end
			-- Get angry if hurt by a friend
			if src.faction and self:reactionToward(src) >= 0 and self.fov and self.checkAngered then
				self:checkAngered(src, false, -50)

				-- Share reaction with allies
				for i = 1, #self.fov.actors_dist do
					local act = self.fov.actors_dist[i]
					if act and act ~= self and not act.dead and act.checkAngered and self:reactionToward(act) > 0 then
						act:checkAngered(src, false, -50)
					end
				end
			end
		end
	end
	
	return value
end

function _M:die(src, death_note)
	if self.dead then self:disappear(src) self:deleteFromMap(game.level.map) if game.level:hasEntity(self) then game.level:removeEntity(self, true) end return true end

	if src and Faction:get(self.faction) and Faction:get(self.faction).hostile_on_attack then
		Faction:setFactionReaction(self.faction, src.faction, Faction:factionReaction(self.faction, src.faction) - self.rank, true)
	end

	-- Get angry if attacked by a friend
	if src and src ~= self and src.resolveSource and src.faction then
		local rsrc = src:resolveSource()
		local rid = rsrc.unique or rsrc.name

		-- Call for help if we become hostile
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and act ~= self and act:reactionToward(rsrc) >= 0 and self:reactionToward(act) > 0 and not act.dead and act.checkAngered then
				act:checkAngered(src, false, -101)
			end
		end
	end

	if self.rank >= 4 and game.state:allowRodRecall() and not self:attr("no_rod_recall") then
		local rod = game.zone:makeEntityByName(game.level, "object", "ROD_OF_RECALL")
		if rod then
			-- If the player can move to the space the NPC died on, drop in the normal way
			-- Else make absolutely sure they get the Rod of Recall by moving it to their inventory directly
			if not game.player:canMove(self.x, self.y, true) then
				game.zone:addEntity(game.level, rod, "object")
				game:getPlayer(true):addObject(game:getPlayer(true):getInven("INVEN"), rod)
				rod:identify(true)
			else
				game.zone:addEntity(game.level, rod, "object", self.x, self.y)
			end

			game.state:allowRodRecall(false)
			if self.define_as == "THE_MASTER" then world:gainAchievement("FIRST_BOSS_MASTER", src)
			elseif self.define_as == "GRAND_CORRUPTOR" then world:gainAchievement("FIRST_BOSS_GRAND_CORRUPTOR", src)
			elseif self.define_as == "PROTECTOR_MYSSIL" then world:gainAchievement("FIRST_BOSS_MYSSIL", src)
			elseif self.define_as == "URKIS" then world:gainAchievement("FIRST_BOSS_URKIS", src)
			end
		end
	end
	-- Ok the player managed to kill a boss dont bother him with tutorial anymore
	if self.rank >= 3.5 and not profile.mod.allow_build.tutorial_done then game:setAllowedBuild("tutorial_done") end

	return mod.class.Actor.die(self, src, death_note)
end

function _M:tooltip(x, y, seen_by)
	local str = mod.class.Actor.tooltip(self, x, y, seen_by)
	if not str then return end
	local killed = game:getPlayer(true).all_kills and (game:getPlayer(true).all_kills[self.name] or 0) or 0
	local target = self.ai_target.actor
	
	str:add(
		true,
		("Killed by you: %s"):tformat(killed), true,
		_t"Target: ", target and target:getName() or _t"none"
	)
	-- Give hints to stealthed/invisible players about where the NPC is looking (if they have LOS)
	if target == game.player and (game.player:attr("stealth") or game.player:attr("invisible")) and game.player:hasLOS(self.x, self.y) then
		local tx, ty = self:aiSeeTargetPos(self.ai_target.actor)
		local dx, dy = tx - self.ai_target.actor.x, ty - self.ai_target.actor.y
		local offset = engine.Map:compassDirection(dx, dy)
		if offset then
			str:add((" looking %s"):tformat(offset))
			if config.settings.cheat then str:add((" (%+d, %+d)"):format(dx, dy)) end
		else
			str:add(_t" looking at you.")
		end
	end
	if config.settings.cheat then
		str:add(true, _t"UID: "..self.uid, true, self.image)
	end
	return str
end

--- Get the current target
-- @param typ <optional> targeting parameters
-- @return x coordinate to target
-- @return y coordinate to target
-- @return target actor @ x, y
--	returns the result of typ.talent.onAIGetTarget(self, typ.talent) (if defined)
function _M:getTarget(typ)
	-- Free ourselves
	if self:attr("encased_in_ice") then	return self.x, self.y, self end
	
	-- get our ai_target according to the targeting parameters (possibly talent-specific)
	return Actor.getTarget(self, typ)
end

--- Make emotes appear in the log too
function _M:setEmote(e)
	game.logSeen(self, "%s says: '%s'", self:getName():capitalize(), e.text)
	mod.class.Actor.setEmote(self, e)
end

--- Simple emote
function _M:doEmote(text, dur, color)
	self:setEmote(Emote.new(text, dur, color))
end

--- Called when added to a level
-- Used to make escorts, adjust to game difficulty settings, etc.
-- Triggered after the entity is resolved
function _M:addedToLevel(level, x, y)
	if not self:attr("difficulty_boosted") and not game.party:hasMember(self) and not (self.summoner or self.summoned) then
		-- make adjustments for game difficulty to talent levels, max life, and bonus fixedboss classes
		local talent_mult = game.state.birth.difficulty_talent_mult or 1
		local life_mult = game.state.birth.difficulty_life_mult or 1
		local level_rate = game.state.birth.default_fixedboss_class_level_rate or 1
		local start_level_pct = game.state.birth.default_fixedboss_class_start_level_pct or 0.8
		if talent_mult ~= 1 then
			-- increase level of innate talents
			-- Note: talent levels from added classes are not adjusted for difficulty directly
			-- This means that the NPC's innate talents are generally higher level, preserving its "character"

			-- Copy the table first so we don't insert talents that teach talents during iteration or double dip their scaling
			local talents = table.clone(self.talents)

			for tid, lev in pairs(talents) do
				local t = self:getTalentFromId(tid)
				if t.points ~= 1 and not t.no_difficulty_boost then
					self:learnTalent(tid, true, math.floor(lev*(talent_mult - 1)))
				end
			end

			-- Resolve bonus classes for fixed bosses
			-- Fixedboss random classes start at player level 10 by default to avoid breaking early game balance
			-- For now if not defined the starting level of fixedboss classes is 80% of their actor level, unsure what this value should be
			if self.rank >= 3.5 and not self.randboss and not self.no_difficulty_random_class then
				if not self.auto_classes then
					local start_level = math.max(10, self.level * 0.8)
					self.start_level = start_level
					local data = {
						forbid_equip=false, start_level = self.level * start_level_pct, nb_classes=1,
						level_rate = level_rate * 100, update_body=true, spend_points=true, autolevel="random_boss", calculate_tactical = true, auto_sustain=true,
					}
					game.state:applyRandomClassNew(self, data, true)
				end

				-- Does this always happen after classes are fully resolved?
				if self.ai_calculate_tactical then self[#self+1] = resolvers.talented_ai_tactic("instant") end -- regenerate AI TACTICS with the new class(es)
				self:resolve() self:resolve(nil, true)
				self:resetToFull()
			end
			
			-- increase maximum life
			self.max_life = self.max_life*life_mult
			self.life = self.max_life
			self:attr("difficulty_boosted", 1)
		end
		-- try to equip items in inventory
		self:wearAllInventory()
		if self:knowTalent(self.T_COMMAND_STAFF) then -- make sure staff aspect is appropriate to talents
			self:forceUseTalent(self.T_COMMAND_STAFF, {ignore_energy = true, ignore_cd=true, silent=true})
		end
	end

	-- Bosses that can pass through things should be smart about finding their target
	if self.rank > 3 and self.can_pass and type(self.can_pass) == "table" and next(self.can_pass) and self.ai_state and not self.ai_state.boss_ghost_no_astar then
		self.ai_state.ai_move = "move_astar"
	end

	return mod.class.Actor.addedToLevel(self, level, x, y)
end

--- Responsible for clearing ai target if needed
-- Pass target to summoner if any
function _M:clearAITarget()
	if self.ai_target.actor and (self.ai_target.actor.dead or not game.level:hasEntity(self.ai_target.actor)) and self.ai_target.actor.summoner then
		self.ai_target.actor = self.ai_target.actor.summoner
		-- You think you can cheat with summons ? let's cheat back !
		-- yeah it's logical because .. hum .. yeah because the npc saw were the summon came from!
		local tx, ty = self:aiSeeTargetPos(self.ai_target.actor)
		self.ai_state.target_last_seen = {x=tx, y=ty, turn=game.turn}
	end

	if self.ai_target.actor and self.ai_target.actor.dead then self.ai_target.actor = nil end
end

--- Returns the seen coords of the target
-- This will usually return the exact coords, but if the target is only partially visible (or not at all)
-- it will return estimates, to throw the AI a bit off
-- @param target the target we are tracking
-- @return x, y coords to move/cast to
function _M:aiSeeTargetPos(target, add_spread, max_spread)
	if not (target and target.x) then return self.x, self.y end
	local tx, ty = target.x, target.y

	-- Special case, a boss that can pass walls can always home in on the target; otherwise it would get lost in the walls for a long while
	-- We check wall walking not on self but rather as a check if the target could reach us
	if self.rank > 3 and target.canMove and not target:canMove(self.x, self.y, true) then
		return util.bound(tx, 0, game.level.map.w - 1), util.bound(ty, 0, game.level.map.h - 1)
	end
	return Actor.aiSeeTargetPos(self, target, add_spread, max_spread)
end