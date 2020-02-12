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

local Object = require "engine.Object"

newTalent{
	name = "Lightning Speed",
	type = {"wild-gift/storm-drake", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 25,
	range = 10,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	requires_target = true,
	no_energy = true,
	getPassiveSpeed = function(self, t) return self:combatTalentScale(t, 0.08, 0.4, 0.7) end,
	getSpeed = function(self, t) return self:combatTalentScale(t, 470, 750, 0.75) end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 1.1, 3.1)) end,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "movement_speed", t.getPassiveSpeed(self, t))
	end,
	on_pre_use = function(self, t) return not self:attr("never_move") end,
	action = function(self, t)
		self:setEffect(self.EFF_LIGHTNING_SPEED, self:mindCrit(t.getDuration(self, t)), {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[You transform into pure lightning, moving %d%% faster for %d game turns.
		Also provides 30%% physical damage resistance and 100%% lightning resistance.
		Any actions other than moving will stop this effect.
		Note: since you will be moving very fast, game turns will pass very slowly.
		Levels in Lightning Speed additionally raises your Movement Speed by %d%%, passively.
		Each point in storm drake talents also increases your lightning resistance by 1%%.]]):tformat(t.getSpeed(self, t), t.getDuration(self, t), t.getPassiveSpeed(self, t)*100)
	end,
}

newTalent{
	name = "Static Field",
	type = {"wild-gift/storm-drake", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 20,
	cooldown = 20,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 6)) end,
	tactical = { ATTACKAREA = { instakill = 5 } },
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getPercent = function(self, t)
		return self:combatLimit(self:combatTalentMindDamage(t, 10, 45), 90, 0, 0, 31, 31) -- Limit to <90%
	end,
	getDamage = function(self, t)
		return self:combatTalentMindDamage(t, 20, 160)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local litdam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if not target:checkHit(self:combatMindpower(), target:combatPhysicalResist(), 10) then
				game.logSeen(target, "%s resists the static field!", target:getName():capitalize())
				return
			end
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatMindpower())
			game.logSeen(target, "%s is caught in the static field!", target:getName():capitalize())

			local perc = t.getPercent(self, t)
			if target.rank >= 5 then perc = perc / 2.5
			elseif target.rank >= 3.5 then perc = perc / 2
			elseif target.rank >= 3 then perc = perc / 1.5
			end

			local dam = target.life * perc / 100
			if target.life - dam < 0 then dam = target.life end
			target:takeHit(dam, self)
			self:project({type="hit", talent=t},target.x,target.y,DamageType.LIGHTNING,litdam)

			game:delayedLogDamage(self, target, dam, ("#PURPLE#%d STATIC#LAST#"):tformat(math.ceil(dam)))
		end, nil, {type="lightning_explosion"})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local percent = t.getPercent(self, t)
		local litdam = t.getDamage(self, t)
		return ([[Generate an electrical field around you in a radius of %d. Any creature caught inside will lose up to %0.1f%% of its current life (%0.1f%% if the target is Elite or Rare, %0.1f%% if the target is a Unique or Boss, and %0.1f%% if they are an Elite Boss.). This life drain is irresistable, but can be saved against with physical save.
		Additionally, it will deal %0.2f lightning damage afterwards, regardless of target rank.
		Current life loss and lightning damage will increase with your Mindpower, and the lightning damage element can critically hit with mental critical chances.
		Each point in storm drake talents also increases your lightning resistance by 1%%.]]):tformat(self:getTalentRadius(t), percent, percent/1.5, percent/2, percent/2.5, damDesc(self, DamageType.LIGHTNING, litdam))
	end,
}

newTalent{
	name = "Tornado",
	type = {"wild-gift/storm-drake", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 14,
	cooldown = 15,
	proj_speed = 1, -- This is purely indicative
	tactical = { ATTACK = { LIGHTNING = 2 }, DISABLE = { stun = 2 } },
	range = function(self, t) return 10 end,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	getMoveDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 30) end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 150) end,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4, 0.5, 0, 0, true)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), selffire=false, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		local movedam = self:mindCrit(t.getMoveDamage(self, t))
		local dam = self:mindCrit(t.getDamage(self, t))
		local rad = t.getRadius(self, t)

		local proj = require("mod.class.Projectile"):makeHoming(
			self,
			{particle="bolt_lightning", trail="lightningtrail"},
			{speed=1, name=_t"Tornado", dam=dam, movedam=movedam, rad=rad, dur=dur},
			target,
			self:getTalentRange(t),
			function(self, src)
				local DT = require("engine.DamageType")
				local Map = require("engine.Map")
				local kb_func = function(px, py)
					local target = game.level.map(px, py, Map.ACTOR)

					if not target or target == self then return end
					if target:canBe("knockback") then
						target:knockback(src.x, src.y, 2)
						game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
					else
						game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
					end
				end
				src:project({type="ball", radius=2, selffire=false, x=self.x, y=self.y, friendlyfire=false}, self.x, self.y, DT.LIGHTNING, self.def.movedam)
				src:project({type="ball", radius=2, selffire=false, x=self.x, y=self.y, friendlyfire=false}, self.x, self.y, kb_func)
			end,
			function(self, src, target)
				local DT = require("engine.DamageType")
				src:project({type="ball", radius=self.def.rad, selffire=false, x=self.x, y=self.y}, self.x, self.y, DT.LIGHTNING, self.def.dam)
				src:project({type="ball", radius=self.def.rad, selffire=false, x=self.x, y=self.y}, self.x, self.y, DT.MINDKNOCKBACK, self.def.dam)

				-- Lightning ball gets a special treatment to make it look neat
				local sradius = (1 + 0.5) * (engine.Map.tile_w + engine.Map.tile_h) / 2
				local nb_forks = 16
				local angle_diff = 360 / nb_forks
				for i = 0, nb_forks - 1 do
					local a = math.rad(rng.range(0+i*angle_diff,angle_diff+i*angle_diff))
					local tx = self.x + math.floor(math.cos(a) * 1)
					local ty = self.y + math.floor(math.sin(a) * 1)
					game.level.map:particleEmitter(self.x, self.y, 1, "lightning", {radius=1, tx=tx-self.x, ty=ty-self.y, nb_particles=25, life=8})
				end
				game:playSoundNear(self, "talents/lightning")
			end
		)
		proj.energy.value = 1500 -- Give it a boost so it moves before our next turn
		proj.homing.count = 20  -- 20 turns max
		game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local rad = t.getRadius(self, t)
		return ([[Summon a tornado that moves very slowly towards the target, following it if it changes position.
		Each time it moves every foes within radius 2 takes %0.2f lightning damage and is knocked back 2 spaces.
		When it reaches the target it explodes in a radius of %d, knocking back targets and dealing %0.2f lightning and %0.2f physical damage.
		The tornado will move a maximum of 20 times.
		Damage will increase with your Mindpower.
		Each point in storm drake talents also increases your lightning resistance by 1%%.]]):tformat(damDesc(self, DamageType.LIGHTNING, t.getMoveDamage(self, t)), rad, damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Lightning Breath",
	type = {"wild-gift/storm-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 20,
	cooldown = 20,
	message = _t"@Source@ breathes lightning!",
	tactical = { ATTACKAREA = {LIGHTNING = 2}, DISABLE = { stun = 1 } },
	range = 0,
	radius = function(self, t) return math.min(13, math.floor(self:combatTalentScale(t, 5, 9))) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t)
		local bonus = self:knowTalent(self.T_CHROMATIC_FURY) and self:combatTalentStatDamage(t, "wil", 30, 670) or 0
		return self:combatTalentStatDamage(t, "str", 30, 670) + bonus
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local damage = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end

			DamageType:get(DamageType.LIGHTNING).projector(self, tx, ty, DamageType.LIGHTNING, rng.avg(damage/3, damage, 3))
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 3, {apply_power = self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		end)

		if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y}, {type="lightning"})
		else game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		end

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="lightningwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You breathe lightning in a frontal cone of radius %d. Any target caught in the area will take %0.2f to %0.2f lightning damage (%0.2f average) and be stunned for 3 turns.
		The damage will increase with your Strength, and the critical chance is based on your Mental crit rate, and the Stun apply power is based on your Mindpower.
		Each point in storm drake talents also increases your lightning resistance by 1%%.]]):tformat(
			self:getTalentRadius(t),
			damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage),
			damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}
