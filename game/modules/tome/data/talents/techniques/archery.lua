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

-- Default archery attack

newTalent{
	name = "Shoot",
	type = {"technique/archery-base", 1},
	no_energy = "fake",
	speed = 'archery',
	hide = true,
	innate = true,
	points = 1,
	target = function(self, t)
		local ff = true
		if self.archery_pass_friendly then ff = false end
		return {type="bolt", range=self:getTalentRange(t), talent=t, display = {particle=particle, trail=trail}, friendlyfire=ff,
			friendlyblock=ff,
		}
	end,
	stamina = function(self, t)
		if not self:isTalentActive("T_SKIRMISHER_BOMBARDMENT") or not wardenPreUse(self, t, false, "sling") then return nil end

		local b = self:getTalentFromId("T_SKIRMISHER_BOMBARDMENT")
		return b.shot_stamina(self, b)
	end,
	range = archery_range,
	message = _t"@Source@ shoots!",
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 } },
	on_pre_use = function(self, t, silent) return wardenPreUse(self, t, silent) end,
	no_unlearn_last = true,
	archery_onreach = function(self, t, x, y, tg, target)
		if not target then return end
		if self:knowTalent(self.T_FIRST_BLOOD) then
			local perc = (target.life / target.max_life)
			if perc >= 0.9 then
				self.turn_procs.first_blood_shoot = target.life
			end
		end
		if target:hasEffect(target.EFF_PIN_DOWN) then self.turn_procs.auto_phys_crit = true end
	end,
	archery_onmiss = function(self, talent, target, x, y)
		if target:hasEffect(target.EFF_PIN_DOWN) then self.turn_procs.auto_phys_crit = nil end
		if self.mark_steady then self.mark_steady = nil end
	end,
	archery_onhit = function(self, t, target, x, y)
		if self:knowTalent(self.T_MASTER_MARKSMAN) then
			local chance = 15 + (self.mark_steady or 0)
			if self:hasEffect(self.EFF_TRUESHOT) then chance = chance + (chance * self:callTalent(self.T_TRUESHOT, "getMarkChance")/100) end
			if self:isTalentActive(self.T_AIM) then	
				chance = chance + self:callTalent(self.T_AIM, "getMarkChance") 
			end
			if target:hasEffect(target.EFF_PIN_DOWN) then 
				local eff = target:hasEffect(target.EFF_PIN_DOWN)
				chance = 100
				self.turn_procs.auto_phys_crit = nil
				target:removeEffect(target.EFF_PIN_DOWN)
			end
			if self.turn_procs.first_blood_shoot then chance = chance + 50 end
			if rng.percent(chance) then target:setEffect(target.EFF_MARKED, 5, {src=self}) end
		end
		if self.turn_procs.first_blood_shoot then
			local life_diff = self.turn_procs.first_blood_shoot - target.life
			local scale = self:callTalent(self.T_FIRST_BLOOD, "getBleed")
			if life_diff > 0 and target:canBe('cut') and scale then
				target:setEffect(target.EFF_CUT, 5, {power=life_diff * scale / 5, src=self, apply_power=self:combatPhysicalpower(), no_ct_effect=true})
			end
		end
		if self.mark_steady then self.mark_steady = nil end
		if self:knowTalent(self.T_FIRST_BLOOD) then self:incStamina(self:callTalent(self.T_FIRST_BLOOD, "getStamina")) end
	end,
	action = function(self, t)
		local swap = not self:attr("disarmed") and (self:attr("warden_swap") and doWardenWeaponSwap(self, t, "bow"))
	
		-- Most of the time use the normal shoot.
		if not wardenPreUse(self, t, true, "sling") or not self:isTalentActive("T_SKIRMISHER_BOMBARDMENT") then
			local targets = self:archeryAcquireTargets(nil, {one_shot=true})
			if not targets then if swap then doWardenWeaponSwap(self, t, "blade") end return end
			if self:knowTalent(self.T_STEADY_SHOT) and not self:isTalentCoolingDown(self.T_STEADY_SHOT) then
				self:archeryShoot(targets, t, nil, {mult=self:callTalent(self.T_STEADY_SHOT, "getDamage")} )
				self.mark_steady = self:callTalent(self.T_STEADY_SHOT, "getBonusMark")
				self:startTalentCooldown(self.T_STEADY_SHOT)
			else
				self:archeryShoot(targets, t, nil) -- use_psi_archery set by Archery:archeryShoot
			end
			return true
		end
		
		-- perform Bombardment if possible
		local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon("sling")
		if not weapon and not pf_weapon then return nil end

		local bombardment = self:getTalentFromId("T_SKIRMISHER_BOMBARDMENT")
		local shots = bombardment.bullet_count(self, bombardment)
		local mult = bombardment.damage_multiplier(self, bombardment)

		-- Do targeting.
		local tg = {type = "bolt", range = archery_range(self),	talent = t}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return end

		-- Fire all shots
		local count = 0
		for i = 1, shots do
			local targets = self:archeryAcquireTargets(nil, {no_energy=true, one_shot=true, type="sling", x=x, y=y})
			if not targets then break end
			
			count = i
			self:archeryShoot(targets, t, nil, {mult=mult, type="sling"})
		end
		if count > 0 then
			local speed = self:combatSpeed(weapon or pf_weapon)
			self:useEnergy(game.energy_to_act * (speed or 1))
		end

		return count > 0
	end,
	info = function(self, t)
		return ([[Shoot your bow, sling or other missile launcher!]]):tformat()
	end,
}

newTalent{
	name = "Steady Shot",
	type = {"technique/archery-training", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 3,
	require = techs_dex_req1,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	getDamage = function(self, t)
		local dam = self:combatTalentWeaponDamage(t, 1.0, 1.8)
		return dam
	end,
	getBonusMark = function(self,t) return 5 + math.floor(self:combatTalentScale(t, 2, 10)) end,
	getChance = function(self,t) 
		local chance = 15 + t.getBonusMark(self,t)
		if self:hasEffect(self.EFF_TRUESHOT) then chance = chance + (chance * self:callTalent(self.T_TRUESHOT, "getMarkChance")/100) end
		if self:isTalentActive(self.T_AIM) then	
			chance = chance + self:callTalent(self.T_AIM, "getMarkChance") 
		end
		return math.min(100, chance)
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onreach = function(self, t, x, y, tg, target)
		if not target then return end
		
		local dam = t.getDamage(self,t)

		if self:knowTalent(self.T_FIRST_BLOOD) then
			local perc = (target.life / target.max_life)
			if perc >= 0.9 then
				self.turn_procs.first_blood_ss = target.life
			end
		end
		if target:hasEffect(target.EFF_PIN_DOWN) then self.turn_procs.auto_phys_crit = true end
	end,
	archery_onmiss = function(self, talent, target, x, y)
		if target:hasEffect(target.EFF_PIN_DOWN) then self.turn_procs.auto_phys_crit = nil end
	end,
	archery_onhit = function(self, t, target, x, y)
		local chance = t.getChance(self,t)
		if target:hasEffect(target.EFF_PIN_DOWN) then 
			local eff = target:hasEffect(target.EFF_PIN_DOWN)
			chance = 100
			self.turn_procs.auto_phys_crit = nil
			target:removeEffect(target.EFF_PIN_DOWN)
		end
		if self.turn_procs.first_blood_ss then chance = chance + 50 end
		if rng.percent(chance) then target:setEffect(target.EFF_MARKED, 5, {src=self}) end
		
		if self.turn_procs.first_blood_ss then
			local life_diff = self.turn_procs.first_blood_ss - target.life
			local scale = self:callTalent(self.T_FIRST_BLOOD, "getBleed")
			if life_diff > 0 and target:canBe('cut') and scale then
				target:setEffect(target.EFF_CUT, 5, {power=life_diff * scale / 5, src=self, apply_power=self:combatPhysicalpower(), no_ct_effect=true})
			end
		end
		if self:knowTalent(self.T_FIRST_BLOOD) then self:incStamina(self:callTalent(self.T_FIRST_BLOOD, "getStamina")) end
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		
		local dam = t.getDamage(self,t)
		
		self:archeryShoot(targets, t, nil, {mult=dam})
		
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local chance = t.getChance(self,t)
		return ([[Fire a steady shot, doing %d%% damage with a %d%% chance to mark the target.
If Steady Shot is not on cooldown, this talent will automatically replace your normal attacks (and trigger the cooldown).]]):
		tformat(dam, chance)
	end,
}

newTalent{
	name = "Pin Down",
	type = {"technique/archery-training", 2},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 9,
	stamina = 10,
	require = techs_dex_req2,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = { pin = 2 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.4) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 5)) end,
	getMarkChance = function(self, t) return math.floor(self:combatTalentScale(t, 5, 20)) end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getChance = function(self,t) 
		local chance = 20
		if self:hasEffect(self.EFF_TRUESHOT) then chance = chance + (chance * self:callTalent(self.T_TRUESHOT, "getMarkChance")/100) end
		if self:isTalentActive(self.T_AIM) then	
			chance = chance + self:callTalent(self.T_AIM, "getMarkChance") 
		end
		return chance
	end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		end
		target:setEffect(target.EFF_PIN_DOWN, t.getDuration(self, t), {src=self})
		local chance = t.getChance(self,t)
		if rng.percent(chance) then target:setEffect(target.EFF_MARKED, 5, {src=self}) end
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		
		local dam = t.getDamage(self,t)
		
		self:archeryShoot(targets, t, nil, {mult=dam})
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local mark = t.getMarkChance(self,t)
		local chance = t.getChance(self,t)
		return ([[You fire a shot for %d%% damage that attempts to pin your target to the ground for %d turns, as well as giving your next Steady Shot or Shoot 100%% increased chance to critically hit and mark (regardless of whether the pin succeeds).
		This shot has a 20%% chance to mark the target.
		The chance to pin increases with your Accuracy.]]):
		tformat(dam, dur, mark, chance)
	end,
}

newTalent{
	name = "Fragmentation Shot",
	type = {"technique/archery-training", 3},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 12,
	require = techs_dex_req3,
	range = archery_range,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	tactical = { ATTACKAREA = { weapon = 2 }, DISABLE = { 3 } },
	requires_target = true,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getSpeedPenalty = function(self, t) return math.floor(self:combatTalentLimit(t, 50, 10, 40))/100 end,
	getChance = function(self,t) 
		local chance = 20
		if self:hasEffect(self.EFF_TRUESHOT) then chance = chance + (chance * self:callTalent(self.T_TRUESHOT, "getMarkChance")/100) end
		if self:isTalentActive(self.T_AIM) then	
			chance = chance + self:callTalent(self.T_AIM, "getMarkChance") 
		end
		return chance
	end,
	archery_onhit = function(self, t, target, x, y)
		target:setEffect(target.EFF_CRIPPLE, t.getDuration(self, t), {speed=t.getSpeedPenalty(self,t), apply_power=self:combatAttack()})
		local chance = t.getChance(self,t)
		if rng.percent(chance) then target:setEffect(target.EFF_MARKED, 5, {src=self}) end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local targets = self:archeryAcquireTargets(tg, {one_shot=true})
		if not targets then return end
		local dam = t.getDamage(self,t)
		self:archeryShoot(targets, t, tg, {mult=dam})
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local speed = t.getSpeedPenalty(self,t)*100
		local chance = t.getChance(self,t)
		return ([[Fires a shot that explodes into a radius %d ball of razor sharp fragments on impact, dealing %d%% weapon damage and leaving targets crippled for %d turns, reducing their attack, spell and mind speed by %d%%.
		Each target struck has a %d%% chance to be marked.
		The status chance increases with your Accuracy.]])
		:tformat(rad, dam, dur, speed, chance)
	end,
}

newTalent{
	name = "Scatter Shot",
	type = {"technique/archery-training", 4},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 15,
	require = techs_dex_req4,
	range = 0,
	radius = function(self, t) return 2 + math.floor(self:combatTalentLimit(t, 8, 3.5, 5.5)) end,
	tactical = { ATTACKAREA = { weapon = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type = "cone", range = self:getTalentRange(t), radius = self:getTalentRadius(t), selffire = false, talent = t }
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.7, 1.5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 5)) end,
	getChance = function(self,t) 
		local chance = 20
		if self:hasEffect(self.EFF_TRUESHOT) then chance = chance + (chance * self:callTalent(self.T_TRUESHOT, "getMarkChance")/100) end
		if self:isTalentActive(self.T_AIM) then	
			chance = chance + self:callTalent(self.T_AIM, "getMarkChance") 
		end
		return chance
	end,
	archery_onhit = function(self, t, target, x, y)
		if target:checkHit(self:combatAttack(), target:combatPhysicalResist(), 0, 95, 15) then
			local dist = self:getTalentRadius(t) - core.fov.distance(self.x, self.y, target.x, target.y)
			if target:canBe("knockback") and dist > 0 then target:knockback(self.x, self.y, dist) end
			if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {}) end
		else	
			game.logSeen(target, "%s resists the scattershot!", target:getName():capitalize())
		end
		local chance = t.getChance(self,t)
		if rng.percent(chance) then target:setEffect(target.EFF_MARKED, 5, {src=self}) end
	end,
	action = function(self, t)
		-- Get list of possible targets, possibly doubled.
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		local targets = {}
		local add_target = function(x, y)
			local target = game.level.map(x, y, game.level.map.ACTOR)
			if target and self:reactionToward(target) < 0 and self:canSee(target) then
				targets[#targets + 1] = target
			end
		end
		self:project(tg, x, y, add_target)
		if #targets == 0 then return end

		table.shuffle(targets)

		-- Fire each shot individually.
		local shot_params_base = {mult = t.getDamage(self, t), phasing = true}
		local fired = nil -- If we've fired at least one shot.
		for i = 1, #targets do
			local target = targets[i]
			local targets = self:archeryAcquireTargets({type = "hit", speed = 200}, {one_shot=true, no_energy = fired, x = target.x, y = target.y})
			if targets then
				local params = table.clone(shot_params_base)
				local target = targets.dual and targets.main[1] or targets[1]
				params.phase_target = game.level.map(target.x, target.y, game.level.map.ACTOR)
				self:archeryShoot(targets, t, {type = "hit", speed = 200}, params)
				fired = true
			else
				-- If no target that means we're out of ammo.
				break
			end
		end

		return fired
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local chance = t.getChance(self,t)
		return ([[Fires a wave of projectiles in a radius %d cone, dealing %d%% weapon damage. All targets struck by this will be knocked back to the maximum range of the cone and stunned for %d turns.
		Each target struck has a %d%% chance to be marked.
		The chance to knockback and stun increases with your Accuracy.]])
		:tformat(rad, dam, dur, chance)
	end,
}

newTalent{
	name = "Headshot",
	type = {"technique/archery-utility", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) -- this makes it a bit less likely that a mob could lob chain headshots at you
		if self.ai and self.ai == "party_member" then 
			return 0
		elseif self.ai then
			return 6
		else
			return 6
		end
	end,	require = techs_dex_req1,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	getDamage = function(self, t)
		return self:combatTalentWeaponDamage(t, 1.1, 2.3)
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onreach = function(self, t, x, y, tg, target)
		if not target then return end
		
		local dam = t.getDamage(self,t)

		if self:knowTalent(self.T_FIRST_BLOOD) then
			local perc = (target.life / target.max_life)
			if perc >= 0.9 then
				self.turn_procs.first_blood_hs = target.life
			end
		end
	end,
	archery_onhit = function(self, t, target, x, y)
		
		if self.turn_procs.first_blood_hs then
			local life_diff = self.turn_procs.first_blood_hs - target.life
			local scale = self:callTalent(self.T_FIRST_BLOOD, "getBleed")
			if life_diff > 0 and target:canBe('cut') and scale then
				target:setEffect(target.EFF_CUT, 5, {power=life_diff * scale / 5, src=self, apply_power=self:combatPhysicalpower(), no_ct_effect=true})
			end
		end
		if target:hasEffect(target.EFF_MARKED) then 
			target:removeEffect(target.EFF_MARKED)
			if self:knowTalent(self.T_BULLSEYE) then self:callTalent(self.T_BULLSEYE, "proc") end
		end
		if self:knowTalent(self.T_FIRST_BLOOD) then self:incStamina(self:callTalent(self.T_FIRST_BLOOD, "getStamina")) end
	end,
	target = function(self, t) return {type = "hit", range = self:getTalentRange(t), talent = t } end,
	action = function(self, t)

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return end
		
		local target = game.level.map(x, y, game.level.map.ACTOR)
		
		if not target or not (target:hasEffect(target.EFF_MARKED) or self:isTalentActive(self.T_CONCEALMENT)) then return nil end 
		local targets = self:archeryAcquireTargets(tg, {one_shot=true, x=target.x, y=target.y})

		if not targets then return end
		local dam = t.getDamage(self,t)
		self:archeryShoot(targets, t, {type = "hit", speed = 200}, {mult=dam, atk=100})
		
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		return ([[Fire a precise shot dealing %d%% weapon damage, with 100 increased accuracy. This shot will bypass other enemies between you and your target.
Only usable against marked targets, and consumes the mark on hit.]]):
		tformat(dam)
	end,
}

newTalent{
	name = "Volley",
	type = {"technique/archery-utility", 2},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 16,
	require = techs_dex_req2,
	range = archery_range,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	tactical = { ATTACKAREA = { weapon = 2 }, },
	requires_target = true,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getDamage = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.6, 1.4)
	end,
	archery_onhit = function(self, t, target, x, y, tg)
		if tg.primarytarget == target then
			game.level.map:particleEmitter(x, y, tg.primaryeffect, "volley", {radius=tg.primaryeffect})
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		
		local target = game.level.map(x, y, game.level.map.ACTOR)
		
		if not target then return end
		local targets = self:archeryAcquireTargets(tg, {x=target.x, y=target.y})
		
		if not targets then return nil end
		local dam = t.getDamage(self,t)
		self:archeryShoot(targets, t, {type = "hit", speed = 200, primaryeffect=tg.radius, primarytarget=target}, {mult=dam})
		
		--acquire secondary targets
		if target:hasEffect(target.EFF_MARKED) or self:isTalentActive(self.T_CONCEALMENT) then 
			local targets = {}
			local add_target = function(x, y)
				local t2 = game.level.map(x, y, game.level.map.ACTOR)
				if t2 and self:reactionToward(t2) < 0 and self:canSee(t2) then
					targets[#targets + 1] = t2
				end
			end
			self:project(tg, x, y, add_target)
			if #targets == 0 then return end
	
			table.shuffle(targets)
	
			-- Fire each shot individually.
			local shot_params_base = {mult = dam/2, phasing = true}
			local fired = nil -- If we've fired at least one shot.
			for i = 1, #targets do
				local target = targets[i]
				local targets = self:archeryAcquireTargets({type = "hit", speed = 200}, {one_shot=true, infinite=true, no_energy = true, x = target.x, y = target.y})
				if targets then
					local params = table.clone(shot_params_base)
					local target = targets.dual and targets.main[1] or targets[1]
					if target then 
						params.phase_target = game.level.map(target.x, target.y, game.level.map.ACTOR)
						self:archeryShoot(targets, t, {type = "hit", speed = 200}, params)
						fired = true
					end
				else
					-- If no target that means we're out of ammo.
					break
				end
			end	
			if target:hasEffect(target.EFF_MARKED) then 
				target:removeEffect(target.EFF_MARKED)
				if self:knowTalent(self.T_BULLSEYE) then self:callTalent(self.T_BULLSEYE, "proc") end
			end
		end 
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		return ([[You fire countless shots into the sky to rain down around your target, inflicting %d%% weapon damage to all within radius %d.
If the primary target is marked, you consume the mark to fire a second volley of arrows for %d%% damage at no ammo cost.]])
		:tformat(dam, rad, dam*0.75)
	end,
}

newTalent{
	name = "Called Shots",
	type = {"technique/archery-utility", 3},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	stamina = 25,
	cooldown = 15,
	require = techs_dex_req3,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	getDamage = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.4, 1.0)
	end,
	no_npc_use = true,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5)) end,
	archery_onhit = function(self, t, target, x, y)
		if target:hasEffect(target.EFF_MARKED) then 
			target:removeEffect(target.EFF_MARKED) 
			if self:knowTalent(self.T_BULLSEYE) and not self.turn_procs.bullseye then
				self.turn_procs.bullseye = true
				self:callTalent(self.T_BULLSEYE, "proc") 
			end --stop this proccing repeatedly
		end
		if not target.turn_procs.called_shot_silence then
			target.turn_procs.called_shot_silence = true
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, t.getDuration(self, t), {apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
			end
		elseif not target.turn_procs.called_shot_disarm then
			target.turn_procs.called_shot_disarm = true
			if target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatAttack(), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the disarm!", target:getName():capitalize())
			end
		elseif not target.turn_procs.called_shot_slow then
			target.turn_procs.called_shot_slow = true
			if target:canBe("slow") then
				target:setEffect(target.EFF_SLOW_MOVE, t.getDuration(self, t), {power=0.5, apply_power=self:combatAttack(), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the slow!", target:getName():capitalize())
			end
		end
	end,
	target = function(self, t) return {type = "hit", range = self:getTalentRange(t), talent = t } end,
	action = function(self, t)

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		
		local target = game.level.map(x, y, game.level.map.ACTOR)
		
		if not target then return nil end 
		local targets = self:archeryAcquireTargets(tg, {x=target.x, y=target.y})

		if not targets then return nil end
		local dam = t.getDamage(self,t)
		self:archeryShoot(targets, t, nil, {mult=dam})
		
		if target:hasEffect(target.EFF_MARKED) or self:isTalentActive(self.T_CONCEALMENT) then 		
			local targets2 = self:archeryAcquireTargets(tg, {multishots=2, x=target.x, y=target.y, no_energy = true})
			if targets2 then self:archeryShoot(targets2, t, nil, {mult=dam*0.25}) end
		end 

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		return ([[You fire a disabling shot at a target's throat (or equivalent), dealing %d%% weapon damage and silencing them for %d turns.
If the target is marked, you consume the mark to fire two secondary shots at their arms and legs (or other appendages) dealing %d%% damage, reducing their movement speed by 50%% and disarming them for the duration.
The status chance increases with your Accuracy.]]):
		tformat(dam, dur, dam*0.25)
	end,
}

newTalent{
	name = "Bullseye",
	type = {"technique/archery-utility", 4},
	points = 5,
	mode = "passive",
	require = techs_dex_req4,
	getSpeed = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 5, 15))/100 end,
	getTalentCount = function(self, t) return math.floor(self:combatTalentLimit(t, 4, 1, 2.5)) end,
	getCooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 1, 3)) end,
	proc = function(self, t)
		if not self:isTalentCoolingDown(t) then 
			self:setEffect(self.EFF_BULLSEYE, 2, {src=self, power=self:callTalent(self.T_BULLSEYE, "getSpeed")})
			
			local talentcount = 0
			local tids = {}
		
			for tid, _ in pairs(self.talents_cd) do
				local tt = self:getTalentFromId(tid)
				if not tt.fixed_cooldown and tt.type[1]:find("^technique/") then
					tids[#tids+1] = tid
					talentcount = talentcount + 1
				end
			end
		
			talentcount = math.min(talentcount, t.getTalentCount(self,t))
			
			for i = 1, talentcount do
					if #tids == 0 then break end
					local tid = rng.tableRemove(tids)
					self.talents_cd[tid] = self.talents_cd[tid] - t.getCooldown(self,t)
					if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
			end
				
			self:startTalentCooldown(t)
		end
		return true
	end,
	info = function(self, t)
		local speed = t.getSpeed(self,t)*100
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[Each time you consume a mark, you gain %d%% increased attack speed for 2 turns and the cooldown of %d random techniques are reduced by %d turns.]]):
		tformat(speed, nb, cd)
	end,
}

-- Deprecated Archery Talents


newTalent{
	name = "Relaxed Shot",
--	type = {"technique/archery-training", 4},
	type = {"technique/other", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 14,
	require = techs_dex_req4,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 }, STAMINA = 1 },
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 0.5, 1.1)})
		self:incStamina(12 + self:getTalentLevel(t) * 8)
		return true
	end,
	info = function(self, t)
		return ([[You fire a shot without putting much strength into it, doing %d%% damage.
		That brief moment of relief allows you to regain %d stamina.]]):tformat(self:combatTalentWeaponDamage(t, 0.5, 1.1) * 100, 12 + self:getTalentLevel(t) * 8)
	end,
}

newTalent{
	name = "Crippling Shot",
--	type = {"technique/archery-utility", 2},
	type = {"technique/other", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
--	require = techs_dex_req2,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = 1 },
	requires_target = true,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onhit = function(self, t, target, x, y)
		target:setEffect(target.EFF_SLOW, 7, {power=util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4), apply_power=self:combatAttack()})
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.5)})
		return true
	end,
	info = function(self, t)
		return ([[You fire a crippling shot, doing %d%% damage and reducing your target's speed by %d%% for 7 turns.
		The status power and status hit chance improve with your Accuracy.]]):tformat(self:combatTalentWeaponDamage(t, 1, 1.5) * 100, util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4) * 100)
	end,
}

newTalent{
	name = "Pinning Shot",
--	type = {"technique/archery-utility", 3},
	type = {"technique/other", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
--	require = techs_dex_req3,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = { pin = 2 } },
	requires_target = true,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 5.5)) end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, t.getDur(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists!", target:getName():capitalize())
		end
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.4)})
		return true
	end,
	info = function(self, t)
		return ([[You fire a pinning shot, doing %d%% damage and pinning your target to the ground for %d turns.
		The pinning chance increases with your Dexterity.]])
		:tformat(self:combatTalentWeaponDamage(t, 1, 1.4) * 100,
		t.getDur(self, t))
	end,
}
