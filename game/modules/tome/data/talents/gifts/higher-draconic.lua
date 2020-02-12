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

newTalent{
	name = "Prismatic Slash",
	type = {"wild-gift/higher-draconic", 1},
	require = gifts_req_high1,
	points = 5,
	random_ego = "attack",
	equilibrium = 10,
	cooldown = 12,
	range = 1,
	is_melee = true,
	tactical = { ATTACK = { PHYSICAL = 1, COLD = 1, FIRE = 1, LIGHTNING = 1, ACID = 1 } },
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.6, 2.3) end,
	getBurstDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 230) end,
	getPassiveSpeed = function(self, t) return (self:combatTalentScale(t, 2, 10, 0.5)/100) end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physspeed", t.getPassiveSpeed(self, t))
		self:talentTemporaryValue(p, "combat_mindspeed", t.getPassiveSpeed(self, t))
	end,
	action = function(self, t)

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local elem = rng.table{"phys", "cold", "fire", "lightning", "acid",}

		-- We need to alter behavior slightly to accomodate shields since they aren't used in attackTarget
		local attack_mode = function(self, target, dt, dam)
			local shield, shield_combat = self:hasShield()
			local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat or self.combat
			if not shield then
				self:attackTarget(target, dt, dam, true)
			else
				self:attackTargetWith(target, weapon, dt, dam)
				self:attackTargetWith(target, shield_combat, dt, dam)
			end
		end

		if elem == "phys" then
			attack_mode(self, target, DamageType.PHYSICAL, t.getWeaponDamage(self, t))
			local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
			local grids = self:project(tg, x, y, DamageType.SAND, {dur=3, dam=self:mindCrit(t.getBurstDamage(self, t))})
			game.level.map:particleEmitter(x, y, tg.radius, "ball_matter", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		elseif elem == "cold" then
			attack_mode(self, target, DamageType.ICE, t.getWeaponDamage(self, t))
			local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
			local grids = self:project(tg, x, y, DamageType.ICE_SLOW, self:mindCrit(t.getBurstDamage(self, t)))
			game.level.map:particleEmitter(x, y, tg.radius, "ball_ice", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		elseif elem == "fire" then
			attack_mode(self, target, DamageType.FIREBURN, t.getWeaponDamage(self, t))
			local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
			local grids = self:project(tg, x, y, DamageType.FIRE_STUN, self:mindCrit(t.getBurstDamage(self, t)))
			game.level.map:particleEmitter(x, y, tg.radius, "ball_fire", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		elseif elem == "lightning" then
			attack_mode(self, target, DamageType.LIGHTNING_DAZE, t.getWeaponDamage(self, t))
			local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
			local grids = self:project(tg, x, y, DamageType.LIGHTNING_DAZE, self:mindCrit(t.getBurstDamage(self, t)))
			game.level.map:particleEmitter(x, y, tg.radius, "ball_lightning", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		elseif elem == "acid" then
			attack_mode(self, target, DamageType.ACID_DISARM, t.getWeaponDamage(self, t))
			local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
			local grids = self:project(tg, x, y, DamageType.ACID_DISARM, self:mindCrit(t.getBurstDamage(self, t)))
			game.level.map:particleEmitter(x, y, tg.radius, "ball_acid", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		end
		return true
	end,
	info = function(self, t)
		local burstdamage = t.getBurstDamage(self, t)
		local radius = self:getTalentRadius(t)
		local speed = t.getPassiveSpeed(self, t)
		return ([[Unleash raw, chaotic elemental damage upon your enemy.
		You strike your enemy for %d%% weapon damage in one of blinding sand, disarming acid, freezing and slowing ice, dazing lightning or stunning flames, with equal odds.
		Additionally, you will cause a burst that deals %0.2f of that damage to creatures in radius %d, regardless of if you hit with the blow.
		Levels in Prismatic Slash increase your Physical and Mental attack speeds by %d%%.

		This talent will also attack with your shield, if you have one equipped.]]):tformat(100 * self:combatTalentWeaponDamage(t, 1.2, 2.0), burstdamage, radius, 100*speed)
	end,
}

newTalent{
	name = "Venomous Breath",
	type = {"wild-gift/higher-draconic", 2},
	require = gifts_req_high2,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = _t"@Source@ breathes venom!",
	tactical = { ATTACKAREA = { poison = 2 } },
	range = 0,
	radius = function(self, t) return math.min(13, math.floor(self:combatTalentScale(t, 5, 9))) end,
	requires_target = true,
	getDamage = function(self, t) 
		local bonus = self:knowTalent(self.T_CHROMATIC_FURY) and self:combatTalentStatDamage(t, "wil", 60, 750) or 0
		return self:combatTalentStatDamage(t, "str", 60, 750) + bonus
	end,
	getEffect = function(self, t) return math.ceil(self:combatTalentLimit(t, 50, 10, 20)) end,
	on_learn = function(self, t)
		self.resists[DamageType.NATURE] = (self.resists[DamageType.NATURE] or 0) + 3
		self.inc_damage[DamageType.NATURE] = (self.inc_damage[DamageType.NATURE] or 0) + 4
		end,
	on_unlearn = function(self, t)
		self.resists[DamageType.NATURE] = (self.resists[DamageType.NATURE] or 0) - 3
		self.inc_damage[DamageType.NATURE] = (self.inc_damage[DamageType.NATURE] or 0) - 4
		end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target:canBe("poison") then
				target:setEffect(self.EFF_CRIPPLING_POISON, 6, {src=self, power=dam/6, fail=math.ceil(self:combatTalentLimit(t, 100, 10, 20))})
			end
		end)

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_slime", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="poisonwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		local effect = t.getEffect(self, t)
		return ([[You breathe crippling poison in a frontal cone of radius %d. Any target caught in the area will take %0.2f nature damage each turn for 6 turns.
		The poison also gives enemies a %d%% chance to fail actions more complicated than basic attacks and movement, while it is in effect.
		The damage will increase with your Strength, and the critical chance is based on your Mental crit rate.
		Each point in Venomous Breath also increases your nature resistance by 3%%, and your nature damage by 4%%.]] ):tformat(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self,t)/6), effect)
	end,
}

newTalent{
	name = "Wyrmic Guile",
	type = {"wild-gift/higher-draconic", 3},
	require = gifts_req_high3,
	points = 5,
	mode = "passive",
	resistKnockback = function(self, t) return self:combatTalentLimit(t, 1, .17, .5) end, -- Limit < 100%
	resistBlindStun = function(self, t) return self:combatTalentLimit(t, 1, .07, .25) end, -- Limit < 100%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "knockback_immune", t.resistKnockback(self, t))
		self:talentTemporaryValue(p, "stun_immune", t.resistBlindStun(self, t))
		self:talentTemporaryValue(p, "blind_immune", t.resistBlindStun(self, t))
	end,
	info = function(self, t)
		return ([[You have mastered your draconic nature.
		You gain %d%% knockback resistance, and your blindness and stun resistances are increased by %d%%.]]):tformat(100*t.resistKnockback(self, t), 100*t.resistBlindStun(self, t))
	end,
}

newTalent{
	name = "Chromatic Fury",
	type = {"wild-gift/higher-draconic", 4},
	require = gifts_req_high4,
	points = 5,
	mode = "passive",
	getDamageIncrease = function(self, t) return self:combatTalentLimit(t, 50, 5, 15) end, -- Limit < 50%
	getResists = function(self, t) return self:combatTalentScale(t, 0.6, 2.5) end,
	getResistPen = function(self, t) return self:combatTalentLimit(t, 50, 5, 15) end, -- Limit < 50%
	passives = function(self, t, p)
		local dam_inc = t.getDamageIncrease(self, t)
		local resists = t.getResists(self, t)
		local resists_pen = t.getResistPen(self, t)
		self:talentTemporaryValue(p, "inc_damage", {
			[DamageType.PHYSICAL]=dam_inc,
			[DamageType.COLD]=dam_inc,
			[DamageType.FIRE]=dam_inc,
			[DamageType.LIGHTNING]=dam_inc,
			[DamageType.ACID]=dam_inc,
			[DamageType.NATURE]=dam_inc,
			[DamageType.BLIGHT]=dam_inc,
			[DamageType.DARKNESS]=dam_inc,
			})
		self:talentTemporaryValue(p, "resists", {
			[DamageType.PHYSICAL]=resists,
			[DamageType.COLD]=resists,
			[DamageType.FIRE]=resists,
			[DamageType.LIGHTNING]=resists,
			[DamageType.ACID]=resists,
			[DamageType.NATURE]=resists,
			[DamageType.BLIGHT]=resists,
			[DamageType.DARKNESS]=resists,
		})
		self:talentTemporaryValue(p, "resists_pen", {
			[DamageType.PHYSICAL]=resists_pen,
			[DamageType.COLD]=resists_pen,
			[DamageType.FIRE]=resists_pen,
			[DamageType.LIGHTNING]=resists_pen,
			[DamageType.ACID]=resists_pen,
			[DamageType.NATURE]=resists_pen,
			[DamageType.BLIGHT]=resists_pen,
			[DamageType.DARKNESS]=resists_pen,
		})
	end,
	info = function(self, t)
		return ([[You have gained the full power of the various drakes throughout the world, and have become both resistant and attuned to physical, fire, cold, lightning, acid, nature, blight, and darkness damage.
		Your resistance to these elements is increased by %0.1f%% and all damage you deal with them is increased by %0.1f%% with %0.1f%% resistance penetration.

		Learning this talent will add a Willpower bonus to your breath talent damage with the same scaling as Strength, effectively doubling it when the stats are equal.]])
		:tformat(t.getResists(self, t), t.getDamageIncrease(self, t), t.getResistPen(self, t))
	end,
}
