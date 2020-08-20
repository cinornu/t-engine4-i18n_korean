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

-- ToDO: to convert to use targeting grid_params (prevent teleporting targets into vaults)

-- find a spot to escape to via teleport (for NPCs)
-- cx, cy = center of teleport radius (starting location of teleport target)
-- radius = error radius
-- ax, ay = anchor point (location of target to move away from)
-- want_range = desired range from anchor point
local function escapeGrid(self, cx, cy, radius, ax, ay, want_range)
	ax, ay = ax or cx, ay or cy
	want_range = want_range or radius
	local grid = {x = cx, y=cy, dist = math.huge}
	local dist
	core.fov.calc_circle(cx, cy, game.level.map.w, game.level.map.h, radius,
		function(d, lx, ly) -- block
		end,
		function(d, lx, ly) -- apply
			if self:canMove(lx, ly) then
				dist = math.abs(core.fov.distance(ax, ay, lx, ly) - want_range) + rng.float(0, .1)
				if math.abs(dist) < grid.dist then
					grid.dist = dist
					grid.x = lx; grid.y = ly
				end
			end
		end,
	nil)
	if dist then return grid.x, grid.y, grid.dist end
end

local teleport_tactical = function(self, t, aitarget)
	local tacs = { escape = 2}
	if aitarget and self:getTalentLevel(t) >= 5 then
		local ax, ay = self:aiSeeTargetPos(aitarget)
		local dist = core.fov.distance(self.x, self.y, ax, ay)
		tacs.closein = dist/math.max(1, t.getRadius(self, t), dist-t.getRange(self, t))/2
	end
	return tacs
end

-- Reduce accuracy when teleporting to the target based on their distance
local closeinSpread = function(self, t, aitarget)
	local dist = core.fov.distance(self.x, self.y, aitarget.x, aitarget.y)
	local tx, ty = self:aiSeeTargetPos(aitarget, dist, 20)  -- Add distance to target to the random spread radius, cap total spread at 20
	return tx, ty
end

newTalent{
	name = "Phase Door",
	type = {"spell/conveyance",1},
	require = spells_req1,
	points = 5,
	random_ego = "utility",
	mana = function(self, t) return self:attr("phase_door_force_precise") and 1 or 30 end,
	cooldown = function(self, t) return self:attr("phase_door_force_precise") and 3 or 12 end,
	tactical = teleport_tactical,
	getRange = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 15), 40, 4, 0, 13.4, 9.4) end, -- Limit to range 40
	range = function(self, t) return self:getTalentLevel(t) >= 4 and 10 or 0 end, -- for targeting enemies
	getRadius = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 6, 2)) end, -- Limit to radius >=0	
	is_teleport = true,
	action = function(self, t)
		local target = self
		local aitarget = self.ai_target.actor
		local _, tx, ty
		if self:getTalentLevel(t) >= 4 then
			game.logPlayer(self, "Select a target to teleport...")
			local tg = {default_target=self, type="hit", friendlyblock = false, nowarning=true, range=self:getTalentRange(t)}
			if rng.percent(50 + (aitarget and aitarget:attr("teleport_immune") or 0) + (aitarget and aitarget:attr("continuum_destabilization") or 0)/2) then tg.first_target = "friend" end -- npc's select self or aitarget based on target's resistance to teleportation
			tx, ty = self:getTarget(tg)
			if tx then
				 _, _, _, tx, ty = self:canProject(tg, tx, ty)
				if tx then
					target = game.level.map(tx, ty, Map.ACTOR)
					if ai_target and target ~= aitarget then target = self end
				end
			end
		end
		target = target or self
		if target ~= self then
			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not target:canBe("teleport") or not hit then
				game.logSeen(target, "The spell fizzles!")
				return true
			end
		end

		-- get target location, if needed
		local x, y = self.x, self.y
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		if self:getTalentLevel(t) >= 5 or self:attr("phase_door_force_precise") then
			game.logPlayer(self, "Select a teleport location...")
			--copy the block_path function from the engine so that we can call it for normal block_path checks
			local old_block_path = engine.Target.defaults.block_path
			--use an adjusted block_path to check if we have a tile in LOS; display targeting in yellow if we don't so we can warn the player their spell may fizzle
			--note: we only use this if the original block_path would permit targeting 
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=range, radius=radius, requires_knowledge=false, block_path=function(typ, lx, ly, for_highlights) if not self:hasLOS(lx, ly) and not old_block_path(typ, lx, ly, for_highlights) then return false, "unknown", true else return old_block_path(typ, lx, ly, for_highlights) end end}
			if self.aiSeeTargetPos then -- ai code for NPCs
				tx, ty = self:aiSeeTargetPos(aitarget)
				if self.ai_state.tactic == "closein" then -- NPC trying to close in
					local dx, dy = self.x - tx, self.y - ty
					if target == self then -- teleport ourselves to target
						x, y = closeinSpread(self, t, aitarget)
					else -- teleport target to ourselves
						x, y = self.x, self.y
					end
				else --NPC trying to open up distance
					-- range 18 based on cooldown + 10 tiles
					if target == self then -- teleport ourselves
						x, y = escapeGrid(self, self.x, self.y, t.getRange(self, t), tx, ty, self:getTalentCooldown(t)+10)
					else -- teleport target
						x, y = escapeGrid(target, tx, ty, t.getRange(self, t), self.x, self.y,  self:getTalentCooldown(t)+10)
					end
				end
			else -- get player target
				x, y = self:getTarget(tg)
			end
			if not x then return nil end
			_, _, _, x, y = self:canProject(tg, x, y)
			range = radius
			-- Check LOS
			if not self:hasLOS(x, y) and rng.percent(35 + (game.level.map.attrs(self.x, self.y, "control_teleport_fizzle") or 0)) then
				game.logPlayer(self, "The targeted phase door fizzles and works randomly!")
				x, y = self.x, self.y
				range = t.getRange(self, t)
			end
		end

		game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		target:teleportRandom(x, y, range)
		game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		print("[phase door] final location of ", target.name, target.x, target.y, "vs", x, y)
		
		if target ~= self then
			if target:reactionToward(self) < 0 then target:setTarget(self) end -- Annoy them!
			target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		end

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[Teleports you randomly within a small range of up to %d grids.
		At level 4, it allows you to specify which creature to teleport.
		At level 5, it allows you to choose the target area (radius %d).
		If the target area is not in line of sight, there is a chance the spell will partially fail and teleport the target randomly.
		The range will increase with your Spellpower.]]):tformat(range, radius)
	end,
}

newTalent{
	name = "Teleport",
	type = {"spell/conveyance",2},
	require = spells_req2,
	points = 5,
	random_ego = "utility",
	mana = 20,
	cooldown = 30,
	tactical = teleport_tactical,
	getRange = function(self, t) return 100 + self:combatSpellpower(1) end,
	range = function(self, t) return self:getTalentLevel(t) >= 4 and 10 or 0 end, -- for targeting enemies
	getRadius = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 19, 15)) end, -- Limit > 0
	minRange = 15,
	
	is_teleport = true,
	action = function(self, t)
		local target = self
		local aitarget = self.ai_target.actor
		local _, tx, ty
		if self:getTalentLevel(t) >= 4 then
			game.logPlayer(self, "Select a target to teleport...")
			local tg = {default_target=self, type="hit", friendlyblock = false, nowarning=true, range=self:getTalentRange(t)}
			if rng.percent(50 + (aitarget and aitarget:attr("teleport_immune") or 0) + (aitarget and aitarget:attr("continuum_destabilization") or 0)/2) then tg.first_target = "friend" end -- npc's select self or aitarget based on target's resistance to teleportation
			tx, ty = self:getTarget(tg)
			if tx then
				 _, _, _, tx, ty = self:canProject(tg, tx, ty)
				if tx then
					target = game.level.map(tx, ty, Map.ACTOR)
					if ai_target and target ~= aitarget then target = self end
				end
			end
		end
		target = target or self
		if target ~= self then
			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not target:canBe("teleport") or not hit then
				game.logSeen(target, "The spell fizzles!")
				return true
			end
		end

		-- get target location, if needed
		local x, y = self.x, self.y
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		local newpos
		if self:getTalentLevel(t) >= 5 or self:attr("phase_door_force_precise") then
			game.logPlayer(self, "Select a teleport location...")
			--copy the block_path function from the engine so that we can call it for normal block_path checks
			local old_block_path = engine.Target.defaults.block_path
			--use an adjusted block_path to check if we have a tile in LOS; display targeting in yellow if we don't so we can warn the player their spell may fizzle
			--note: we only use this if the original block_path would permit targeting 
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=range, radius=radius, requires_knowledge=false, block_path=function(typ, lx, ly, for_highlights) if not self:hasLOS(lx, ly) and not old_block_path(typ, lx, ly, for_highlights) then return false, "unknown", true else return old_block_path(typ, lx, ly, for_highlights) end end}
			if self.aiSeeTargetPos then -- ai code for NPCs
				tx, ty = self:aiSeeTargetPos(aitarget)
				if self.ai_state.tactic == "closein" then -- NPC trying to close in
					local dx, dy = self.x - tx, self.y - ty
					if target == self then -- teleport ourselves to target
						x, y = closeinSpread(self, t, aitarget)
					else -- teleport target to ourselves
						x, y = self.x, self.y
					end
				else --NPC trying to open up distance
					if target == self then -- teleport ourselves
						x, y = escapeGrid(self, self.x, self.y, t.getRange(self, t), tx, ty,  self:getTalentCooldown(t)+10)
					else -- teleport target
						x, y = escapeGrid(target, tx, ty, t.getRange(self, t), self.x, self.y,  self:getTalentCooldown(t)+10)
					end
				end
			else -- get player target
				x, y = self:getTarget(tg)
			end
			if not x then return nil end
			_, _, _, x, y = self:canProject(tg, x, y)
			range = radius
			-- Check LOS
			-- Should this even be able to fizzle? The point of teleport is to go far away, i.e. out of line of sight, and teleport isn't particularly accurate anyway 
			if not self:hasLOS(x, y) and rng.percent(35 + (game.level.map.attrs(self.x, self.y, "control_teleport_fizzle") or 0)) then
				game.logPlayer(self, "The targetted teleport fizzles and works randomly!")
				x, y = self.x, self.y
				range = t.getRange(self, t)
			end
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
			newpos = target:teleportRandom(x, y, range)
			-- teleport randomly if there was no suitable destination in the target area
			if not newpos then
				newpos = target:teleportRandom(x, y, t.getRange(self, t), t.minRange)
			end
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		else
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
			newpos = target:teleportRandom(x, y, t.getRange(self, t), t.minRange)
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		end
		print("[teleport] final location of ", target.name, target.x, target.y)
		if target ~= self then
			if target:reactionToward(self) < 0 then target:setTarget(self) end -- Annoy them!
			target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		end

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		return ([[Teleports you randomly within a large range (%d).
		At level 4, it allows you to specify which creature to teleport.
		At level 5, it allows you to choose the target area (radius %d).
		If the target area is not in line of sight, there is a chance the spell will partially fail and teleport the target randomly.
		Random teleports have a minimum range of %d.
		The range will increase with your Spellpower.]]):tformat(range, radius, t.minRange)
	end,
}

newTalent{
	name = "Displacement Shield",
	type = {"spell/conveyance", 3},
	require = spells_req3,
	points = 5,
	mana = 40,
	cooldown = 35,
	tactical = { DEFEND = 2 },
	range = 8,
	requires_target = true,
	getTransferChange = function(self, t) return 40 + self:getTalentLevel(t) * 5 end,
	getMaxAbsorb = function(self, t) return 50 + self:combatTalentSpellDamage(t, 20, 400) end,
	getDuration = function(self, t) return util.bound(10 + math.floor(self:getTalentLevel(t) * 3), 10, 25) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end
		if not target then return end

		self:setEffect(self.EFF_DISPLACEMENT_SHIELD, t.getDuration(self, t), {power=t.getMaxAbsorb(self, t), target=target, chance=t.getTransferChange(self, t)})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local chance = t.getTransferChange(self, t)
		local maxabsorb = self:getShieldAmount(t.getMaxAbsorb(self, t))
		local duration = self:getShieldDuration(t.getDuration(self, t))
		return ([[This intricate spell erects a space distortion around the caster that is linked to another distortion, placed around a target.
		Any time the caster should take damage, there is a %d%% chance that it will instead be warped by the shield and hit the designated target.
		Once the maximum damage (%d) is absorbed, the time runs out (%d turns), or the target dies, the shield will crumble.
		The max damage the shield can absorb will increase with your Spellpower.]]):
		tformat(chance, maxabsorb, duration)
	end,
}

newTalent{
	name = "Probability Travel",
	type = {"spell/conveyance",4},
	mode = "sustained",
	require = spells_req4,
	points = 5,
	cooldown = 40,
	sustain_mana = 200,
	no_npc_use = true,
	tactical = { ESCAPE = 1, CLOSEIN = 1 },
	getRange = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.06) * self:getTalentLevel(t), 4, 0, 20, 16)) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/teleport")
		return {
			prob_travel = self:addTemporaryValue("prob_travel", t.getRange(self, t)),
			prob_travel_penalty = self:addTemporaryValue("prob_travel_penalty", 2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("prob_travel", p.prob_travel)
		self:removeTemporaryValue("prob_travel_penalty", p.prob_travel_penalty)
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[When you hit a solid surface, this spell tears down the laws of probability to make you instantly appear on the other side.
		Teleports up to %d grids.
		After a successful probability travel you are left unstable, unable to do it again for a number of turns equal to %d%% of the number of tiles you blinked through.
		The range will improve with your Spellpower.]]):
		tformat(range, (2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2) * 100)
	end,
}
