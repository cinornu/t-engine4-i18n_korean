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
	name = "Wing Buffet",
	type = {"wild-gift/fire-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	equilibrium = 5,
	cooldown = 10,
	range = 0,
	on_learn = function(self, t) 
		self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 
		self.combat_atk = self.combat_atk + 2
		self.combat_dam = self.combat_dam + 2
	end,
	on_unlearn = function(self, t) 
		self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 
		self.combat_atk = self.combat_atk - 2
		self.combat_dam = self.combat_dam - 2
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.7) end,
	radius = function(self, t) return 3 end,
	direct_hit = true,
	tactical = { DEFEND = { knockback = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local state = {}
		local shield, shield_combat = self:hasShield()
		local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat or self.combat
		self:project(tg, x, y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self and not state[target] then				
				-- We need to alter behavior slightly to accomodate shields since they aren't used in attackTarget
				state[target] = true
				if not shield then
					self:attackTarget(target, DamageType.PHYSKNOCKBACK, t.getDamage(self, t), true)
				else
					self:attackTargetWith(target, weapon, DamageType.PHYSKNOCKBACK, t.getDamage(self, t))
					self:attackTargetWith(target, shield_combat, DamageType.PHYSKNOCKBACK, t.getDamage(self, t))
				end
			end
		end)
		game:playSoundNear(self, "talents/breath")

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {life=18, x=bx, y=by, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You summon a powerful gust of wind, knocking back your foes within a radius of %d up to 3 tiles away and hitting them for %d%% weapon damage.
		Every level in Wing Buffet additionally raises your Physical Power and Accuracy by 2, passively.
		Each point in fire drake talents also increases your fire resistance by 1%%.

		This talent will also attack with your shield, if you have one equipped.]]):tformat(self:getTalentRadius(t),damage*100)
	end,
}

newTalent{
	name = "Bellowing Roar",
	type = {"wild-gift/fire-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ roars!",
	equilibrium = 8,
	cooldown = 20,
	range = 0,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	tactical = { DEFEND = 1, DISABLE = { confusion = 3 } },
	requires_target = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.PHYSICAL, self:mindCrit(self:combatTalentStatDamage(t, "str", 30, 380)))
		self:project(tg, self.x, self.y, DamageType.CONFUSION, {
			dur=3,
			dam=20 + 6 * self:getTalentLevel(t),
			power_check=function() return self:combatPhysicalpower() end,
			resist_check=self.combatPhysicalResist,
		})
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "shout", {additive=true, life=10, size=3, distorion_factor=0.5, radius=self:getTalentRadius(t), nb_circles=8, rm=0.8, rM=1, gm=0, gM=0, bm=0.1, bM=0.2, am=0.4, aM=0.6})
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local power = 20 + 6 * self:getTalentLevel(t)
		return ([[You let out a powerful roar that sends your foes in radius %d into utter confusion (power: %d%%) for 3 turns.
		The sound wave is so strong, your foes also take %0.2f physical damage.
		The damage improves with your Strength.
		Each point in fire drake talents also increases your fire resistance by 1%%.]]):tformat(radius, power, self:combatTalentStatDamage(t, "str", 30, 380))
	end,
}

newTalent{
	name = "Devouring Flame",
	type = {"wild-gift/fire-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	equilibrium = 6,
	cooldown = 20,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false}
	end,
	getDamage = function(self, t)
		return self:combatTalentMindDamage(t, 15, 60)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)

		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local damage = self:mindCrit(t.getDamage(self, t))

		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, duration,
			DamageType.FIRE_DRAIN, {dam=damage, healfactor=0.1},
			radius,
			5, nil,
			{type="inferno"},
			nil, false
		)
		game:playSoundNear(self, "talents/devouringflame")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[Spit a cloud of flames, doing %0.2f fire damage in a radius of %d each turn for %d turns.
		The flames will ignore the caster, and will drain 10%% of the damage dealt as the flames consume enemies life force and transfer it to the user.
		The damage will increase with your Mindpower, and can critical.
		Each point in fire drake talents also increases your fire resistance by 1%%.]]):tformat(damDesc(self, DamageType.FIRE, dam), radius, duration)
	end,
}

newTalent{
	name = "Fire Breath",
	type = {"wild-gift/fire-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 20,
	cooldown = 20,
	message = _t"@Source@ breathes fire!",
	tactical = { ATTACKAREA = { FIRE = 2 }},
	range = 0,
	radius = function(self, t) return math.min(13, math.floor(self:combatTalentScale(t, 5, 9))) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t)
		local bonus = self:knowTalent(self.T_CHROMATIC_FURY) and self:combatTalentStatDamage(t, "wil", 30, 650) or 0
		return self:combatTalentStatDamage(t, "str", 30, 650) + bonus
	end,  -- Higher damage because no debuff and delayed
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIREBURN, {dam=self:mindCrit(t.getDamage(self, t)), dur=3})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {life=18, x=bx, y=by, fade=-0.006, deploy_speed=14}))
		end
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[You breathe fire in a frontal cone of radius %d. Any target caught in the area will take %0.2f fire damage over 3 turns.
		The damage will increase with your Strength and the critical chance is based on your Mental crit rate.
		Each point in fire drake talents also increases your fire resistance by 1%%.]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
}
