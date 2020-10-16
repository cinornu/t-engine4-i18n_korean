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

--- get a list of diseases on a target
local getTargetDiseases = function(self, target)
	if not target then return end
	local diseases = self.turn_procs.target_diseases and self.turn_procs.target_diseases[target.uid]
	if diseases then return diseases end

	local num, dur = 0, 0
	diseases = {}
	for eff_id, p in pairs(target.tmp) do
		local e = target.tempeffect_def[eff_id]
		if e.subtype.disease then
			num, dur = num + 1, dur + p.dur
			diseases[#diseases+1] = {id=eff_id, params=p}
		end
	end
	diseases.num, diseases.dur = num, dur
	self.turn_procs.target_diseases = self.turn_procs.target_diseases or {}
	self.turn_procs.target_diseases[target.uid] = diseases
	return diseases
end

-- Fix dead priority
-- Add a clear display on where the disease went
newTalent{
	name = "Virulent Disease",
	type = {"corruption/plague", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 3,
	mode = "passive",
	do_disease = function(self, t, target, val)
		if self:isTalentCoolingDown(t) then return end

		-- Grab an enemy of radius 5 of the damaged target that has the most diseases else default to the actor damaged
		local disease_target = {actor=target, count=0}
		if dead then disease_target.actor = "none" end
		self:project({type="ball", radius=5, friendlyfire=false, selffire=false, x=target.x, y=target.y}, target.x, target.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			local count = #target:effectsFilter(function(e) return e.subtype.disease end, 9)
			if (count > 0 and disease_target.count < count) or disease_target.actor == "none" then  -- If the initial target was dead then we grab a semi-random one
				disease_target.actor = target
				disease_target.count = count
			end
		end)

		if disease_target.actor == "none" then return end
		target = disease_target.actor
		local diseases = {{self.EFF_WEAKNESS_DISEASE, "str"}, {self.EFF_ROTTING_DISEASE, "con"}, {self.EFF_DECREPITUDE_DISEASE, "dex"}}
		local disease = rng.table(diseases)

		if target:canBe("disease") then
			local str, dex, con = not target:hasEffect(self.EFF_WEAKNESS_DISEASE) and target:getStr() or 0, not target:hasEffect(self.EFF_DECREPITUDE_DISEASE) and target:getDex() or 0, not target:hasEffect(self.EFF_ROTTING_DISEASE) and target:getCon() or 0

			if str >= dex and str >= con then
				disease = {self.EFF_WEAKNESS_DISEASE, "str"}
			elseif dex >= str and dex >= con then
				disease = {self.EFF_DECREPITUDE_DISEASE, "dex"}
			elseif con > 0 then
				disease = {self.EFF_ROTTING_DISEASE, "con"}
			end

			target:setEffect(disease[1], 6, {src=self, dam=self:spellCrit(7 + self:combatTalentSpellDamage(t, 6, 45)), [disease[2]]=self:combatTalentSpellDamage(t, 5, 35), apply_power=self:combatSpellpower()})
		else
			game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
		end
		self:startTalentCooldown(t)
		game.level.map:particleEmitter(target.x, target.y, 1, "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=0})
		game:playSoundNear(self, "talents/slime")
	end,
	info = function(self, t)
		return ([[Whenever you deal non-disease blight damage you apply a disease dealing %0.2f blight damage per turn for 6 turns and reducing one of its physical stats (strength, constitution, dexterity) by %d. The three diseases can stack.
		Virulent Disease will always try to apply a disease the target does not currently have, and also one that will have the most debilitating effect for the target.
		This disease will try to prioritize being applied to an enemy with a high disease count near the target.
		The effect will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.BLIGHT, 7 + self:combatTalentSpellDamage(t, 6, 45)), self:combatTalentSpellDamage(t, 5, 35))
	end,
}

newTalent{
	name = "Cyst Burst",
	type = {"corruption/plague", 2},
	require = corrs_req2,
	points = 5,
	vim = 18,
	cooldown = 4,
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	getTargetDiseases = getTargetDiseases,
	tactical = function(self, t, aitarget)
		local diseases = t.getTargetDiseases(self, aitarget)
		local tacs
		if diseases then
			tacs = {attackarea = {
				BLIGHT = function(self, t, target)
					if target == aitarget then -- blight damage only
						return {diseases.num}
					else -- blight damage with chance to disease
						return {diseases.num, disease=diseases.num}
					end
				end
				},
				__wt_cache_turns = 1
			}
		end
		return tacs
	end,
	requires_target = true,
	target = function(self, t)
		-- Target trying to combine the bolt and the ball disease spread
		return {type="ballbolt", radius=self:getTalentRadius(t), range=self:getTalentRange(t), friendlyfire=false, selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 15, 90))
		local diseases
		
		-- Try to rot !
		local source = nil
		self:project(tg, x, y, function(px, py) -- bolt hits the first target in line
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			diseases = t.getTargetDiseases(self, target)
			if diseases and #diseases > 0 then
				DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, dam * #diseases)
				game.level.map:particleEmitter(px, py, 1, "slime")
			end
			source = target
		end)

		if diseases and #diseases > 0 then -- burst in a radius
			self:project({type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t}, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target or target == source or target == self or (self:reactionToward(target) >= 0) then return end

				for _, disease in ipairs(diseases) do
					local parameters = table.clone(disease.params, true)
					parameters.src = self
					parameters.apply_power = self:combatSpellpower()
					parameters.__tmpvals = nil

					local dur = math.max(6, parameters.dur)
					if target:canBe("disease") then
						target:setEffect(disease.id, dur, parameters)
					else
						game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
					end
				end
			end)
			game.level.map:particleEmitter(x, y,self:getTalentRadius(t), "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=self:getTalentRadius(t)})
		end
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		return ([[Make your target's diseases burst, doing %0.2f blight damage for each disease it is infected with.
		This will also spread any diseases to any nearby foes in a radius of %d with a minimum duration of 6.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 115)), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Catalepsy",
	type = {"corruption/plague", 3},
	require = corrs_req3,
	points = 5,
	vim = 20,
	cooldown = 15,
	range = 8,
	getTargetDiseases = getTargetDiseases,
	tactical = { DISABLE = function(self, t, target)
			local diseases = t.getTargetDiseases(self, target)
			if diseases and diseases.num > 0 then return {stun=0.1} end  -- We want the disable to be a small part of this calculation, partially to emphasize delaying its use
		end,
		ATTACKAREA = function(self, t, target)
			local diseases = t.getTargetDiseases(self, target)
			if diseases and diseases.num > 0 then -- low weight since the damage is unchanged (just accelerated)
				return {BLIGHT=self:combatLimit(diseases.dur/diseases.num - 1, 3, 0, 0, 1, 5)}
			end
		end,
		__wt_cache_turns = 1 },
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return (100 + self:combatTalentSpellDamage(t, 0, 50)) / 100 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.7)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=t.getRadius(self, t), friendlyfire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local source = nil
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			-- get all diseases on the target
			local diseases = t.getTargetDiseases(self, target)			

			if diseases and #diseases > 0 then -- Ravage diseased targets!
				game.logSeen(target, "Diseases #DARK_GREEN#BURN THROUGH#LAST# %s!", target:getName():capitalize())
				for i, d in ipairs(diseases) do
					target:removeEffect(d.id)
					DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, d.params.dam * d.params.dur * t.getDamage(self, t))
				end

				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
				end
			end
		end)
		game.level.map:particleEmitter(x, y, t.getRadius(self, t), "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="blight_circle", radius=t.getRadius(self, t)})
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[All your foes within a radius %d ball infected with a disease enter a cataleptic state, stunning them for %d turns and dealing %d%% of all remaining disease damage instantly.]]):
		tformat(radius, duration, damage * 100)
	end,
}

newTalent{
	name = "Epidemic",
	type = {"corruption/plague", 4},
	require = corrs_req4,
	points = 5,
	vim = 20,
	cooldown = 13,
	range = 8,
	radius = 2,
	tactical = { ATTACK = {BLIGHT = 2} },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	requires_target = true,
	healloss = function(self,t) return self:combatTalentLimit(t, 150, 50, 75) end, -- Limit < 150%
	disfact = function(self,t) return self:combatTalentLimit(t, 100, 35, 60) end, -- Limit < 100%
	-- Desease spreading handled in mod.data.damage_types.lua for BLIGHT
	spreadFactor = function(self, t) return self:combatTalentLimit(t, 0.05, 0.35, 0.17) end, -- Based on previous formula: 256 damage gave 100% chance (1500 hps assumed)
	
	do_spread = function(self, t, carrier, dam)
		if not dam or type(dam) ~= "number" then return end
		if not rng.percent(100*dam/(t.spreadFactor(self, t)*carrier.max_life)) then return end
		game.logSeen(self, "The diseases of %s spread!", self:getName())
		-- List all diseases
		local diseases = {}
		for eff_id, p in pairs(carrier.tmp) do
			local e = carrier.tempeffect_def[eff_id]
			if e.subtype.disease then
				diseases[#diseases+1] = {id=eff_id, params=p}
			end
		end

		if #diseases == 0 then return end
		self:project({type="ball", radius=self:getTalentRadius(t), friendlyfire=false}, carrier.x, carrier.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target or target == carrier or target == self then return end

			local disease = rng.table(diseases)
			local params = table.clone(disease.params, true)
			params.__tmpvals = nil
			params.src = self
			params.apply_power = self:combatSpellpower()
			local dur = math.max(6, params.dur)

			if target:canBe("disease") then
				target:setEffect(disease.id, dur, params)
			else
				game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
			end
			game.level.map:particleEmitter(px, py, 1, "slime")
		end)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		-- Try to rot !
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target or (self:reactionToward(target) >= 0) then return end
			target:setEffect(self.EFF_EPIDEMIC, 6, {src=self, dam=self:spellCrit(self:combatTalentSpellDamage(t, 15, 70)), heal_factor=t.healloss(self,t), resist=t.disfact(self,t), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(px, py, 1, "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		return ([[Infects the target with a very contagious disease, doing %0.2f damage per turn for 6 turns.
		If any blight damage from non-diseases hits the target, the epidemic may activate and spread a random disease to nearby targets within a radius 2 ball.
		The chance to spread increases with the blight damage dealt and is 100%% if it is at least %d%% of the target's maximum life.
		Creatures suffering from that disease will also suffer healing reduction (%d%%) and diseases immunity reduction (%d%%).
		Epidemic is an extremely potent disease; as such, it fully ignores the target's diseases immunity.
		The damage will increase with your Spellpower, and the spread chance increases with the amount of blight damage dealt.]]):
		tformat(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 70)), t.spreadFactor(self, t)*100 ,t.healloss(self,t), t.disfact(self,t))
	end,
}
