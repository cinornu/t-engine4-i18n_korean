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

-- Find a hostile target
-- this requires the ActorFOV interface, or an interface that provides self.fov.actors*
-- This is ToME specific, overriding the engine default target_simple to account for lite, infravision, ...
-- has a chance to keep the current target (90% if hostile, 50% if friendly, 0% if self)
-- otherwise searches for a hostile target within sense range that can be seen and is not invulnerable
newAI("target_simple", function(self)
	if not self.x then return end
	local log_detail = config.settings.log_detail_ai or 0
	if log_detail > 0 then print("[ActorAI] Invoking target_simple AI for", self.uid, self.name, self.x, self.y) end
	local aitarget = self.ai_target.actor
	if aitarget then
		if log_detail >= 2 then print("[target_simple AI] current target:", aitarget.uid, aitarget.name) end
		if aitarget.summoner and (aitarget.dead or not game.level:hasEntity(aitarget)) then
			if log_detail > 0 then print("[target_simple AI] targeting summoner of dead summon:",  aitarget.uid, aitarget.name) end
			self:setTarget(aitarget.summoner)
			aitarget = self.ai_target.actor
		end
	end

	-- chance to keep same target, 90% if hostile, 50% if friendly, 0% if self
	if aitarget then
		if log_detail >= 2 then print("[target_simple AI] testing validity of target:", aitarget.uid, aitarget.name) end
		if aitarget.dead or not game.level:hasEntity(aitarget) then
			if log_detail >= 2 then print("[target_simple AI] clearing target:", aitarget.uid, aitarget.name,  aitarget.dead and "(DEAD)" or "{NOT ON LEVEL}") end
		else
			if aitarget == self then -- allow self to be cleared
			elseif self:reactionToward(aitarget) >= 0 then -- keep friendly 50%
				if rng.percent(50) then return aitarget end
			else
				if rng.percent(90) and not aitarget:attr("invulnerable") then return aitarget end -- keep hostile 90% (never clear it)
				aitarget = nil
			end
		end
	end

	-- Find closest enemy and target it or set no target
	-- Get list of actors ordered by distance
	local arr = self.fov.actors_dist
	local act
	local sqsense = math.max(self.lite or 0, self.infravision or 0, self.heightened_senses or 0)
	if log_detail >= 2 then print("[target_simple AI]", self.uid, self.name, "at", self.x, self.y, "searching for new targets in range", sqsense) end
	sqsense = sqsense * sqsense
	for i = 1, #arr do
		act = self.fov.actors_dist[i]
		if log_detail > 2 then print("\t checking target", act.x, act.y, act.uid, act.name) end
		if act and act.x and not act.dead and self:reactionToward(act) < 0 and game.level.map:isBound(act.x, act.y) and
			(((act.lite or 0) > 0) -- If it has lite we can always see it
				or -- Otherwise check if we can see it with our "senses"
				(self:canSee(act) and (self.fov.actors[act].sqdist <= sqsense) or game.level.map.lites(act.x, act.y))
			) and not act:attr("invulnerable") then

			print("[target_simple AI]", self.uid, self.name, "selecting NEW TARGET", act.x, act.y, act.uid, act.name)
			self:setTarget(act)
			return act
		end
	end
	if aitarget then  -- clear old target if a new one wasn't found or kept
		if log_detail > 0 then print("[target_simple AI] clearing old target (no replacement):", aitarget.uid, aitarget.name) end
if log_detail > 1.4 and config.settings.cheat then game.log("#RED# [%s]%s #ORANGE#CLEARING OLD TARGET#LAST#: [%s]%s", self.uid, self.name, aitarget.uid, aitarget.name) end -- debugging
		self:setTarget()
	end
	return self.ai_target.actor
end)

-- keep current target (90% chance) or target the player if within sense radius
newAI("target_player_radius", function(self)
	if not game.player.x then return end
	local aitarget = self.ai_target.actor
	if aitarget and not aitarget.dead and game.level:hasEntity(aitarget) and rng.percent(90) then return true end

	if core.fov.distance(self.x, self.y, game.player.x, game.player.y) < self.ai_state.sense_radius then
		self:setTarget(game.player)
		return true
	end
end)

-- Target the player if within sense radius or if in sight
newAI("target_simple_or_player_radius", function(self)
	if self:runAI("target_simple") then return true end

	if game.player.x and core.fov.distance(self.x, self.y, game.player.x, game.player.y) < self.ai_state.sense_radius then
		self:setTarget(game.player)
		return true
	end
end)

-- Special targetting for charred scar, select a normal target, if none is found go for the player
newAI("charred_scar_target", function(self)
	if self:runAI("target_simple") then return true end
	self:setTarget(game.player)
	return true
end)

-- Always retarget to closest
-- This is most useful on immobile melee prone to just wasting their turns if their current target isn't adjacent
newAI("target_closest", function(self)
	if not self.x then return end
	local log_detail = config.settings.log_detail_ai or 0
	if log_detail > 0 then print("[ActorAI] Invoking target_closest AI for", self.uid, self.name, self.x, self.y) end
	local aitarget = self.ai_target.actor
	if aitarget then
		if log_detail >= 2 then print("[target_closest AI] current target:", aitarget.uid, aitarget.name) end
		if aitarget.summoner and (aitarget.dead or not game.level:hasEntity(aitarget)) then
			if log_detail > 0 then print("[target_closest AI] targeting summoner of dead summon:",  aitarget.uid, aitarget.name) end
			self:setTarget(aitarget.summoner)
			aitarget = self.ai_target.actor
		end
	end

	-- Find closest enemy and target it or set no target
	-- Get list of actors ordered by distance
	local arr = self.fov.actors_dist
	local act
	local sqsense = math.max(self.lite or 0, self.infravision or 0, self.heightened_senses or 0)
	if log_detail >= 2 then print("[target_closest AI]", self.uid, self.name, "at", self.x, self.y, "searching for new targets in range", sqsense) end
	sqsense = sqsense * sqsense
	for i = 1, #arr do
		act = self.fov.actors_dist[i]
		if log_detail > 2 then print("\t checking target", act.x, act.y, act.uid, act.name) end
		if act and act.x and not act.dead and self:reactionToward(act) < 0 and game.level.map:isBound(act.x, act.y) and
			(((act.lite or 0) > 0) -- If it has lite we can always see it
				or -- Otherwise check if we can see it with our "senses"
				(self:canSee(act) and (self.fov.actors[act].sqdist <= sqsense) or game.level.map.lites(act.x, act.y))
			) and not act:attr("invulnerable") then

			print("[target_closest AI]", self.uid, self.name, "selecting NEW TARGET", act.x, act.y, act.uid, act.name)
			self:setTarget(act)
			return act
		end
	end
	if aitarget then  -- clear old target if a new one wasn't found or kept
		if log_detail > 0 then print("[target_closest AI] clearing old target (no replacement):", aitarget.uid, aitarget.name) end
	if log_detail > 1.4 and config.settings.cheat then game.log("#RED# [%s]%s #ORANGE#CLEARING OLD TARGET#LAST#: [%s]%s", self.uid, self.name, aitarget.uid, aitarget.name) end -- debugging
		self:setTarget()
	end
	return self.ai_target.actor
end)