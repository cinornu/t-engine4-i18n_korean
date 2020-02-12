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
local function aura_strength(self, t)
	return self:combatTalentMindDamage(t, 10, 40)
end

local function aura_spike_strength(self, t)
	return aura_strength(self, t) * 10
end

local function aura_mastery(self, t) -- aura energy cost per creature hit/affected
	return 0.5 --9 + self:getTalentLevel(t) * 2
end

local function aura_range(self, t)
	if self:isTalentActive(t.id) then -- Spiked ability
		if type(t.getSpikedRange) == "function" then return t.getSpikedRange(self, t) end
		return t.getSpikedRange
	else -- Normal ability
		if type(t.getNormalRange) == "function" then return t.getNormalRange(self, t) end
		return t.getNormalRange
	end
end

local function aura_radius(self, t)
	if self:isTalentActive(t.id) then -- Spiked ability
		if type(t.getSpikedRadius) == "function" then return t.getSpikedRadius(self, t) end
		return t.getSpikedRadius
	else -- Normal ability
		if type(t.getNormalRadius) == "function" then return t.getNormalRadius(self, t) end
		return t.getNormalRadius
	end
end

local function aura_target(self, t)
	if self:isTalentActive(t.id) then -- Spiked ability
		if type(t.getSpikedTarget) == "function" then return t.getSpikedTarget(self, t) end
		return t.getSpikedTarget
	else -- Normal ability
		if type(t.getNormalTarget) == "function" then return t.getNormalTarget(self, t) end
		return t.getNormalTarget
	end
end

local function aura_requires_target(self, t)
	if self:isTalentActive(t.id) and self:getPsi() >= t.getSpikeCost(self, t) then -- Spiked ability
		return true
	else -- Normal ability
		return false
	end
end

--- will the aura trigger each turn?
local function aura_should_proc(self, t)
	local psiweapon = self:getInven("PSIONIC_FOCUS") and self:getInven("PSIONIC_FOCUS")[1]
	return (psiweapon and ( not psiweapon.combat or psiweapon.subtype == "mindstar" )) -- or not psiweapon
end

--- tactical function (base tactical AI)
-- uses t._DamageType to determine resistances
local aura_tactical = function(self, t, aitarget)
	local is_active, can_proc = self:isTalentActive(t.id), aura_should_proc(self, t)
	return {attackarea = is_active and self:getPsi() >= t.getSpikeCost(self, t) and {[t._DamageType] = 2} or can_proc and {[t._DamageType] = 1} or 0,
	buff = can_proc and 0 or 1}
end

local aura_on_pre_use_ai = function(self, t, silent, fake)
	if self.ai_state._advanced_ai then return true end -- let the AI decide when to use
	local aitarget = self.ai_target.actor
	if not aitarget or self:reactionToward(aitarget) >= 0 then -- no hostile target, keep activated
		return not self:isTalentActive(t.id)
	end
	return true -- requires_target controls if active
end

--(DEBUGGING transitional until reassignment)
local use_aura_tactics = false

-- note: the AI might get stuck with the wrong aura if the target is highly resistant to its damage type

--- tactical function (for improved tactical AI, to replace aura_tactical after ai transition)
-- uses t._DamageType to determine resistances
-- merges t.tactical_spike (containing negative weights) if spike is possible
-- combines aura tactics by merging as self tactics
local aura_tactical_imp = function(self, t, aitarget) -- for improved tactical AI (DEBUGGING transitional until reassignment)
	local log_detail = config.settings.log_detail_ai or 0
	local is_active, aura_proc = self:isTalentActive(t.id), aura_should_proc(self, t)
	local psi_val, aura_cost = self:getPsi(), aitarget and aura_mastery(self, t)/100 or 0
	
	if use_aura_tactics then -- use tactical table for aura
		return {attackarea={[t._DamageType]=1},
			psi = (is_active and -5 or 5)*aura_cost/(aura_cost + 0.4), -- reflects proc costs for aura
			_no_tp_cache = true
		}
	elseif log_detail > 1 then print("=== PSIONIC PROJECTION TACTICAL FUNCTION ===", t.id, "active:", is_active, "aura_should_proc:", aura_proc)
	end
	local aura_tacs
	if aura_proc then-- calculate reflexive aura tactics
		local aura_tg = t.getNormalTarget(self, t)
		local aura_tgts = self:aiTalentTargets(t, aitarget, aura_tg, false, self.x, self.y)

		use_aura_tactics = true
		if log_detail > 2 then print(" == PROJECTION TACTICS == generating aura tactics for", t.id) end
		aura_tacs = self:aiTalentTactics(t, aitarget, aura_tgts, nil, aura_tg, is_active and -1 or 1)
		use_aura_tactics = false
		if log_detail > 1 then print(" == PROJECTION TACTICS == aura tactics for", t.id) table.print(aura_tacs, "\t_at_") end
	end
	-- calculate base (+ possible spike) tactics 
	local tacs = {
		self = {buff = aura_proc and 0.1 or 1, -- with normal weapon psionic focus
			psi = -5*aura_cost/(aura_cost + 0.4) -- reflects weapon proc costs (assumes one proc/turn)
			},
		}
		if is_active and psi_val >= t.getSpikeCost(self, t) then --add spike tactics
			table.merge(tacs, t.tactical_spike or {attack = {[t._DamageType] = -2}}) -- Note: aiTalentTactics negates the tactical values for active sustains
		end
	if log_detail > 1 then print(" == PROJECTION TACTICS == base tactics:", tacs) table.print(tacs, "\t_bt_") end
	if aura_tacs then table.merge(tacs.self, aura_tacs, nil, nil, nil, true) end
	if log_detail > 1 then print(" == PROJECTION TACTICS == final tactics:", t.id) table.print(tacs, "\t_ft_") end
	return tacs
end

newTalent{
	name = "Kinetic Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req1, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	_DamageType = DamageType.PHYSICAL,
	tactical = aura_tactical,
	tactical_imp = aura_tactical_imp, --(DEBUGGING transitional until reassignment)
	tactical_spike = {attack = {PHYSICAL = -1.5}, escape = {knockback = -1}},
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_THERMAL_AURA) and self:isTalentActive(self.T_CHARGED_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	on_pre_use_ai = aura_on_pre_use_ai,
	requires_target = aura_requires_target,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t) return 6 end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t)
		return 0
	end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_TELEKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="beam", nolock=true, range=t.getSpikedRange(self, t), talent=t, selffire=false}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)*.8 -- weaker to balance out the KB effect
	end,
	getKnockback = function(self, t)
		return 3 + math.floor(self:getTalentLevel(t))
	end,
	callbackOnActBase = function(self, t)
		if not aura_should_proc(self, t) then return end
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.PHYSICAL).projector(self, tx, ty, DamageType.PHYSICAL, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local k_dam = t.getAuraStrength(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_TELEKINESIS) then
			local tg = {type="ball", range=10, radius=1, selffire=false, friendlyfire=false}
			self:project(tg, target.x, target.y, function(tx, ty)
				DamageType:get(DamageType.PHYSICAL).projector(self, tx, ty, DamageType.PHYSICAL, k_dam)
			end)
		else
			DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, k_dam)
		end
		self:incPsi(-aura_mastery(self, t))
	end,
	no_energy = function(self, t) return not self:isTalentActive(t.id) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = t.getSpikedTarget(self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local actor = game.level.map(x, y, Map.ACTOR)
		--if core.fov.distance(self.x, self.y, x, y) == 1 and not actor then return true end
		if core.fov.distance(self.x, self.y, x, y) == 0 then return true end
		self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(0.8*dam, dam)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "matter_beam", {tx=x-self.x, ty=y-self.y})
		self:incPsi(-cost)

		return true
	end,

	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[Fills the air around you with reactive currents of force.
		If you have a gem or mindstar in your psionically wielded slot, this will do %0.1f Physical damage to all adjacent enemies, costing %0.1f energy per creature. 
		If you have a conventional weapon in your psionically wielded slot, this will add %0.1f Physical damage to all your weapon hits, costing %0.1f energy per hit.
		When deactivated, if you have at least %d energy, a massive spike of kinetic energy is released as a range %d beam, smashing targets for up to %d physical damage and sending them flying.
		#{bold}#Activating the aura takes no time but de-activating it does.#{normal}#
		To turn off an aura without spiking it, deactivate it and target yourself. The damage will improve with your Mindpower.
		You can only have two of these auras active at once.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, dam), mast, damDesc(self, DamageType.PHYSICAL, dam), mast, spikecost, t.getSpikedRange(self, t),
		damDesc(self, DamageType.PHYSICAL, spikedam))
	end,
}

newTalent{
	name = "Thermal Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req2, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	_DamageType = DamageType.FIRE,
	tactical = aura_tactical,
	tactical_imp = aura_tactical_imp, --(DEBUGGING transitional until reassignment)
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_KINETIC_AURA) and self:isTalentActive(self.T_CHARGED_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	on_pre_use_ai = aura_on_pre_use_ai,
	requires_target = aura_requires_target,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t)
		return 0
	end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t) return 6 end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_PYROKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="cone", range=t.getSpikedRange(self, t), radius=t.getSpikedRadius(self, t), selffire=false, talent=t}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	callbackOnActBase = function(self, t)
		if not aura_should_proc(self, t) then return end
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.FIRE).projector(self, tx, ty, DamageType.FIRE, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local t_dam = t.getAuraStrength(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_PYROKINESIS) then
			local tg = {type="ball", range=10, radius=1, selffire=false, friendlyfire=false}
			self:project(tg, target.x, target.y, function(tx, ty)
				DamageType:get(DamageType.FIRE).projector(self, tx, ty, DamageType.FIRE, t_dam)
			end)
		else
			DamageType:get(DamageType.FIRE).projector(self, target.x, target.y, DamageType.FIRE, t_dam)
		end
		self:incPsi(-aura_mastery(self, t))
	end,
	no_energy = function(self, t) return not self:isTalentActive(t.id) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		--if self:isTalentActive(self.T_CONDUIT) then return true end
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = t.getSpikedTarget(self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local actor = game.level.map(x, y, Map.ACTOR)
		--if core.fov.distance(self.x, self.y, x, y) == 1 and not actor then return true end
		if core.fov.distance(self.x, self.y, x, y) == 0 then return true end
		self:project(tg, x, y, DamageType.FIREBURN, self:mindCrit(rng.avg(0.8*dam, dam)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/fire")
		self:incPsi(-cost)
		return true
	end,
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local rad = t.getSpikedRadius(self,t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[Fills the air around you with reactive currents of furnace-like heat.
		If you have a gem or mindstar in your psionically wielded slot, this will do %0.1f Fire damage to all adjacent enemies, costing %0.1f energy per creature. 
		If you have a conventional weapon in your psionically wielded slot, this will add %0.1f Fire damage to all your weapon hits, costing %0.1f energy per hit.
		When deactivated, if you have at least %d energy, a massive spike of thermal energy is released as a conical blast (radius %d) of superheated air. Anybody caught in it will suffer up to %d fire damage over several turns.
		#{bold}#Activating the aura takes no time but de-activating it does.#{normal}#
		To turn off an aura without spiking it, deactivate it and target yourself. The damage will improve with your Mindpower.
		You can only have two of these auras active at once.]]):
		tformat(damDesc(self, DamageType.FIRE, dam), mast, damDesc(self, DamageType.FIRE, dam), mast, spikecost, rad,
		damDesc(self, DamageType.FIRE, spikedam))
	end,
}

newTalent{
	name = "Charged Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req3, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	_DamageType = DamageType.LIGHTNING,
	tactical = aura_tactical,
	tactical_imp = aura_tactical_imp, --(DEBUGGING transitional until reassignment)
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_KINETIC_AURA) and self:isTalentActive(self.T_THERMAL_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	on_pre_use_ai = aura_on_pre_use_ai,
	requires_target = aura_requires_target,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t) return 6 end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t)
		return 10
	end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="ball", range=t.getSpikedRange(self, t), radius=t.getSpikedRadius(self, t), friendlyfire=false}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)
	end,
	getNumSpikeTargets = function(self, t)
		return 3 + math.floor(0.5*self:getTalentLevel(t))
	end,
	callbackOnActBase = function(self, t)
		if not aura_should_proc(self, t) then return end
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.LIGHTNING).projector(self, tx, ty, DamageType.LIGHTNING, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local c_dam = t.getAuraStrength(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS) then
			local tg = {type="ball", range=10, radius=1, selffire=false, friendlyfire=false}
			self:project(tg, target.x, target.y, function(tx, ty)
				DamageType:get(DamageType.LIGHTNING).projector(self, tx, ty, DamageType.LIGHTNING, c_dam)
			end)
		else
			DamageType:get(DamageType.LIGHTNING).projector(self, target.x, target.y, DamageType.LIGHTNING, c_dam)
		end
		self:incPsi(-aura_mastery(self, t))
	end,
	no_energy = function(self, t) return not self:isTalentActive(t.id) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/thunderstorm")
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		--if self:isTalentActive(self.T_CONDUIT) then return true end
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = {type="bolt", nolock=true, range=self:getTalentRange(t), talent=t}
		local fx, fy = self:getTarget(tg)
		if not fx or not fy then return nil end
		if core.fov.distance(self.x, self.y, fx, fy) == 0 then return true end

		local nb = t.getNumSpikeTargets(self, t)
		local affected = {}
		local first = nil
		--Here's the part where deactivating the aura fires off a huge chain lightning
		self:project(tg, fx, fy, function(dx, dy)
			print("[Charged Aura(Chain lightning)] targetting", fx, fy, "from", self.x, self.y)
			local actor = game.level.map(dx, dy, Map.ACTOR)
			if actor and not affected[actor] then
				affected[actor] = true
				first = actor

				print("[Charged Aura(Chain lightning)] looking for more targets", nb, " at ", dx, dy, "radius ", 10, "from", actor.name)
				self:project({type="ball", friendlyfire=false, x=dx, y=dy, radius=self:getTalentRange(t), range=0}, dx, dy, function(bx, by)
					local actor = game.level.map(bx, by, Map.ACTOR)
					if actor and not affected[actor] and self:reactionToward(actor) < 0 then
						print("[Charged Aura(Chain lightning)] found possible actor", actor.name, bx, by, "distance", core.fov.distance(dx, dy, bx, by))
						affected[actor] = true
					end
				end)
				return true
			end
		end)

		if not first then return true end
		local targets = { first }
		affected[first] = nil
		local possible_targets = table.listify(affected)
		print("[Charged Aura(Chain lightning)] Found targets:", #possible_targets)
		for i = 2, nb do
			if #possible_targets == 0 then break end
			local act = rng.tableRemove(possible_targets)
			targets[#targets+1] = act[1]
		end

		local sx, sy = self.x, self.y
		for i, actor in ipairs(targets) do
			local tgr = {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t, x=sx, y=sy}
			print("[Charged Aura(Chain lightning)] jumping from", sx, sy, "to", actor.x, actor.y)
			self:project(tgr, actor.x, actor.y, DamageType.LIGHTNING_DAZE, {power_check=self:combatMindpower(), dam=self:mindCrit(rng.avg(0.8*dam, dam)), daze=50})
			game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning", {tx=actor.x-sx, ty=actor.y-sy, nb_particles=150, life=6})
			sx, sy = actor.x, actor.y
		end
		game:playSoundNear(self, "talents/lightning")
		self:incPsi(-cost)
		return true
	end,

	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		local nb = t.getNumSpikeTargets(self, t)
		return ([[Fills the air around you with crackling energy.
		If you have a gem or mindstar in your psionically wielded slot, this will do %0.1f Lightning damage to all adjacent enemies, costing %0.1f energy per creature. 
		If you have a conventional weapon in your psionically wielded slot, this will add %0.1f Lightning damage to all your weapon hits, costing %0.1f energy per hit.
		When deactivated, if you have at least %d energy, a massive spike of electrical energy jumps between up to %d nearby targets, doing up to %0.1f Lightning damage to each with a 50%% chance of dazing them.
		#{bold}#Activating the aura takes no time but de-activating it does.#{normal}#
		To turn off an aura without spiking it, deactivate it and target yourself. The damage will improve with your Mindpower.
		You can only have two of these auras active at once.]]):
		tformat(damDesc(self, DamageType.LIGHTNING, dam), mast, damDesc(self, DamageType.LIGHTNING, dam), mast, spikecost, nb, damDesc(self, DamageType.LIGHTNING, spikedam))
	end,
}

newTalent{
	name = "Frenzied Focus",
	type = {"psionic/projection", 4},
	require = psi_wil_req4,
	cooldown = 20,
	psi = 30,
	points = 5,
	tactical = function(self, t, aitarget)
		local btf = self:isTalentActive(self.T_BEYOND_THE_FLESH)
		if btf then
			if btf.mindstar_grab then return {closein = {knockback = 2}} end -- mindstar grab
			local tk = self:getInven("PSIONIC_FOCUS")[1] --Beyond The Flesh has already checked for a focus
			if tk.combat then -- focus gets additional attacks with a larger radius
				return {attackarea = {[tk.combat.damtype or "PHYSICAL"] = 2}}
			elseif tk.type == "gem" then -- elemental attack each turn
				local damType = tk.color_attributes and tk.color_attributes.damage_type or "MIND"
				return {attackarea = {[damType] = 2}}
			end
		end
	end,
	requires_target = false,
	on_pre_use_ai = function(self, t, silent, fake)
		return self:isTalentActive(self.T_BEYOND_THE_FLESH) and not self:hasEffect(self.EFF_PSIFRENZY)
	end,
	radius = function(self, t)
		local tk = self:getInven("PSIONIC_FOCUS") tk = tk[1]
		if tk then return tk.subtype == "mindstar" and 2 + (tk.material_level or 1) or tk.type == "gem" and 6 or tk.combat and t.getTargNum(self, t) + 1 or 1 end
	end,
	range = 0,
	target = function(self, t)
		local tk = self:getInven("PSIONIC_FOCUS") tk = tk[1]
		if tk then
			local radius = t.radius(self, t)
			return {type="ball", range=0, radius=t.radius(self, t), friendlyfire=false, selffire=false}
		end
		return false
	end,
	getTargNum = function(self,t)
		return math.ceil(self:combatTalentScale(t, 1.0, 3.0, "log"))
	end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 10, 200))
	end,
	duration = function(self,t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		self:setEffect(self.EFF_PSIFRENZY, t.duration(self,t), {power=t.getTargNum(self,t), damage=t.getDamage(self,t)})
		return true
	end,
	info = function(self, t)
		local targets = t.getTargNum(self,t)
		local dur = t.duration(self,t)
		return ([[Overcharge your psionic focus with energy for %d turns, producing a different effect depending on what it is.
		A telekinetically wielded melee weapon enters a frenzy, striking up to %d enemies per turn, also increases the radius by %d.
		A mindstar will attempt to pull in all enemies within its normal range.
		A gem will fire an energy bolt at a random enemy in range 6, each turn for %0.1f damage. The type is determined by the colour of the gem. Damage scales with Mindpower.]]):
		tformat(dur, targets, targets, t.getDamage(self,t))
	end,
}
