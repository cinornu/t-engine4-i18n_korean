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

local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"

local preUse = function(self, t, silent)
	if not self:hasShield() or not archerPreUse(self, t, true) then
		if not silent then game.logPlayer("You require a ranged weapon and a shield to use this talent.") end
		return false
	end
	return true
end

archery_range = Talents.main_env.archery_range

local function concealmentDetection(self, radius, estimate)
	if not self.x then return nil end
	local dist = 0
	local closest, detect = math.huge, 0
	for i, act in ipairs(self.fov.actors_dist) do
		dist = core.fov.distance(self.x, self.y, act.x, act.y)
		if dist > radius then break end
		if act ~= self and act:reactionToward(self) < 0 and not act:attr("blind") and (not act.fov or not act.fov.actors or act.fov.actors[self]) and (not estimate or self:canSee(act)) then
			detect = detect + act:combatSeeStealth() * (1.1 - dist/10) -- detection strength reduced 10% per tile
			if dist < closest then closest = dist end
		end
	end
	return detect, closest
end
Talents.concealmentDetection = concealmentDetection

newTalent{
	name = "Concealment",
	type = {"technique/sniper", 1},
	points = 5,
	mode = "sustained",
	require = techs_dex_req_high1,
	cooldown = 10,
	no_energy = true,
	tactical = { BUFF = 2 },
	no_npc_use = true, -- range 13 mobs are a bit excessive
	on_pre_use = function(self, t, silent, fake)
		if not archerPreUse(self, t, silent, "bow") then return false end
		if self:isTalentActive(t.id) then return true end
		
		-- Check nearby actors detection ability
		if not self.x or not self.y or not game.level then return end
		if not rng.percent(self.hide_chance or 0) then
			if concealmentDetection(self, t.getRadius(self, t)) > 0 then
				if not silent then game.logPlayer(self, "You are being observed too closely to enter Concealment!") end
				return nil
			end
		end
		return true
	end,
	getAvoidance = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 5, 15)) end,
	getSight = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, "log")) end,
	getRadius = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 8.9, 4.5)) end,
	sustain_lists = "break_with_stealth",
	activate = function(self, t)
		local ret = {}
		self:setEffect(self.EFF_CONCEALMENT, 3, {power=t.getAvoidance(self,t), sight=t.getSight(self,t), charges=3})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnActBase = function(self, t)
		self:setEffect(self.EFF_CONCEALMENT, 3, {power=t.getAvoidance(self,t), max_power=t.getAvoidance(self,t)*3, sight=t.getSight(self,t), charges=3})
	end,
	info = function(self, t)
		local avoid = t.getAvoidance(self,t)*3
		local range = t.getSight(self,t)
		local radius = t.getRadius(self,t)
		return ([[Enter a concealed sniping stance, increasing your weapon's attack range and vision range by %d, giving all incoming damage a %d%% chance to miss you, and causing your Headshot, Volley and Called Shots to behave as if the target was marked.
Any non-instant, non-movement action will break concealment, but the increased range and vision and damage avoidance will persist for 3 turns, with the damage avoidance decreasing in power by 33%% each turn.
This requires a bow to use, and cannot be used if there are foes in sight within range %d.]]):
		tformat(range, avoid, radius)
	end,
}

newTalent{
	name = "Shadow Shot",
	type = {"technique/sniper", 2},
	require = techs_dex_req2,
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	stamina = 18,
	cooldown = 14,
	require = techs_dex_req_high2,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = 2 },
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "bow") end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 2.7)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.6, 1.0) end,
	getSightLoss = function(self, t) return math.floor(self:combatTalentScale(t,1, 6, "log", 0, 4)) end, -- 1@1 6@5
	getCooldownReduction = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 2, 8))) end,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	archery_onreach = function(self, t, x, y)
		local tg = self:getTalentTarget(t)
		self:project(tg, x, y, DamageType.SHADOW_SMOKE, t.getSightLoss(self,t), {type="dark"})
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		local dam = t.getDamage(self,t)
		self:archeryShoot(targets, t, nil, {mult=dam})
		game:onTickEnd(function()
			if self:knowTalent(self.T_CONCEALMENT) and not self:isTalentActive(self.T_CONCEALMENT) then
				self:alterTalentCoolingdown(self.T_CONCEALMENT, -t.getCooldownReduction(self,t))
				if not self:isTalentCoolingDown(self.T_CONCEALMENT) then self:forceUseTalent(self.T_CONCEALMENT, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true}) end
			end
		end)
		game.level.map:redisplay()
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local sight = t.getSightLoss(self,t)
		local cooldown = t.getCooldownReduction(self,t)
		return ([[Fire an arrow tipped with a smoke bomb inflicting %d%% damage and creating a radius %d cloud of thick, disorientating smoke. Those caught within will have their vision range reduced by %d for 5 turns.
The distraction caused by this effect reduces the cooldown of your Concealment by %d turns. If the cooldown is reduced to 0, you instantly activate Concealment regardless of whether foes are too close.
The chance for the smoke bomb to affect your targets increases with your Accuracy. This requires a bow to use.]]):
		tformat(dam, radius, sight, cooldown)
	end,
}

newTalent{
	name = "Aim",
	type = {"technique/sniper", 3},
	mode = "sustained",
	points = 5,
	require = techs_dex_req_high3,
	cooldown = 30,
	sustain_stamina = 50,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "bow") end,
	getPower = function(self, t)  return self:combatTalentStatDamage(t, "dex", 15, 50) end,
	getSpeed = function(self, t) return math.floor(self:combatTalentLimit(t, 150, 50, 100)) end,
	getDamage = function(self, t) return self:combatTalentLimit(t, 8.0, 2.0, 4.0) end,
	getMarkChance = function(self, t) return math.floor(self:combatTalentScale(t, 2, 10)) end,
	sustain_slots = 'archery_stance',
	activate = function(self, t)

		local power = t.getPower(self,t)
		local speed = t.getSpeed(self,t)
		local ret = {
			atk = self:addTemporaryValue("combat_dam", power),
			dam = self:addTemporaryValue("combat_atk", power),
			speed = self:addTemporaryValue("slow_projectiles_outgoing", -speed),
		}
		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="aim_shieldwall"}, shader={type="rotatingshield", noup=2.0, time_factor=600, appearTime=0.2}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="aim_shieldwall"}, shader={type="rotatingshield", noup=1.0, time_factor=600, appearTime=0.2}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("slow_projectiles_outgoing", p.speed)
		self:removeTemporaryValue("combat_atk", p.atk)
		self:removeTemporaryValue("combat_dam", p.dam)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self,t)
		local speed = t.getSpeed(self,t)
		local dam = t.getDamage(self,t)
		local mark = t.getMarkChance(self,t)
		return ([[Enter a calm, focused stance, increasing physical power and accuracy by %d, projectile speed by %d%% and the chance to mark targets by an additional %d%%.
This makes your shots more effective at range, increasing all damage dealt by %0.1f%% per tile travelled beyond 3, to a maximum of %0.1f%% damage at range 8.
The physical power and accuracy increase with your Dexterity. This requires a bow to use.]]):
		tformat(power, speed, mark, dam, dam*5)
	end,
}

newTalent{
	name = "Snipe",
	type = {"technique/sniper", 4},
	points = 5,
	random_ego = "attack",
	stamina = 20,
	cooldown = 10,
	require = techs_dex_req_high4,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 3 }, },
	no_npc_use = true, --no way am i giving a npc a 300%+ ranged shot
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "bow") end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.7, 3.5) end, -- very high damage as this effectively takes 2 turns
	getDamageReduction = function(self, t) return math.floor(self:combatTalentLimit(t, 90, 30, 70)) end,
	action = function(self, t)
		local dam = t.getDamage(self,t)
		local reduction = t.getDamageReduction(self,t)
		self:setEffect(self.EFF_SNIPE, 2, {src=self, power=reduction, dam=dam})
		local eff = self:hasEffect("EFF_SNIPE")
		eff.dur = eff.dur - 1

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local reduction = t.getDamageReduction(self,t)
		return ([[Take aim for 1 turn, preparing a deadly shot. During the next turn, this talent will be replaced with the ability to fire a lethal shot dealing %d%% damage and marking the target.
While aiming, your intense focus causes you to shrug off %d%% incoming damage and all negative effects.
This requires a bow to use.]]):
		tformat(dam, reduction)
	end,
}

newTalent{
	name = "Snipe", short_name = "SNIPE_FIRE",
	type = {"technique/other", 1},
	no_energy = "fake",
	points = 1,
	random_ego = "attack",
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 4 }, },
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onhit = function(self, t, target, x, y)
		target:setEffect(target.EFF_MARKED, 5, {src=self})
	end,
	target = function(self, t) return {type = "hit", range = self:getTalentRange(t), talent = t } end,
	action = function(self, t)
		local eff = self:hasEffect(self.EFF_SNIPE)
		if not eff then return nil end
		
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return end
		
		local target = game.level.map(x, y, game.level.map.ACTOR)
		
		if not target then return nil end
		local targets = self:archeryAcquireTargets(tg, {one_shot=true, x=target.x, y=target.y})

		if not targets then return end

		self:archeryShoot(targets, t, {type = "hit", speed = 200}, {mult=eff.dam, atk=100})
		
		self:removeEffect(self.EFF_SNIPE)
		
		return true
	end,
	info = function(self, t)
		return ([[Fire a lethal shot. This shot will bypass other enemies between you and your target, and gains 100 increased accuracy.]]):
		tformat(dam, reduction)
	end,
}