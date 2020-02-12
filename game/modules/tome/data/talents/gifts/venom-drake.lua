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
	name = "Acidic Spray",
	type = {"wild-gift/venom-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ spits acid!",
	equilibrium = 3,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 3, 6.9, 5.5)) end, -- Limit >=3
	tactical = { ATTACK = { ACID = 2 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5.5, 7.5)) end,
	on_learn = function(self, t)
		self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1
		self.combat_mindpower = self.combat_mindpower + 4
	end,
	on_unlearn = function(self, t)
		self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1
		self.combat_mindpower = self.combat_mindpower - 4
	end,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 5 then return true else return false end end,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		if self:getTalentLevel(t) >= 5 then tg.type = "beam" end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 25, 250) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID_DISARM, self:mindCrit(t.getDamage(self, t)), nil)
		local _ _, x, y = self:canProject(tg, x, y)
		if tg.type == "beam" then
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "acidbeam", {tx=x-self.x, ty=y-self.y})
		else
			game.level.map:particleEmitter(x, y, 1, "acid")
		end
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Spray forth a glob of acidic moisture at your enemy.
		The target will take %0.2f Mindpower-based acid damage.
		Enemies struck have a 25%% chance to be Disarmed for three turns, as their weapon is rendered useless by an acid coating.
		At Talent Level 5, this becomes a piercing line of acid.
		Every level in Acidic Spray additionally raises your Mindpower by 4, passively.
		Each point in acid drake talents also increases your acid resistance by 1%%.]]):tformat(damDesc(self, DamageType.ACID, damage))
	end,
}

newTalent{
	name = "Corrosive Mist",
	type = {"wild-gift/venom-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	equilibrium = 10,
	cooldown = 15,
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 0,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 15, 70) end,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatMindpower(0.04) + self:getTalentLevel(t)/2, 6, 0, 7.67, 5.67)) end,
	getCorrodeDur = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.8)) end,
	getAtk = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	getArmor = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	getDefense = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	action = function(self, t)
		local damage = self:mindCrit(t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local armor = t.getArmor(self, t)
		local defense = t.getDefense(self, t)
		local actor = self
		local radius = self:getTalentRadius(t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.ACID_CORRODE, {dam=damage, dur=cordur, atk=atk, armor=armor, defense=defense},
			radius,
			5, nil,
			{type="acidstorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Exhale a mist of lingering acid, dealing %0.2f acid damage that can critical in a radius of %d each turn for %d turns.
		Enemies in this mist will be corroded for %d turns, lowering their Accuracy, their Armour and their Defense by %d.
		The damage and duration will increase with your Mindpower, and the radius will increase with talent level.
		Each point in acid drake talents also increases your acid resistance by 1%%.]]):tformat(damDesc(self, DamageType.ACID, damage), radius, duration, cordur, atk)
	end,
}

newTalent{
	name = "Dissolve",
	type = {"wild-gift/venom-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	equilibrium = 10,
	cooldown = 12,
	range = 1,
	is_melee = true,
	tactical = { ATTACK = { ACID = 2 }, DISABLE = {blind = 1} },
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.1, 0.60) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		
		-- We need to alter behavior slightly to accomodate shields since they aren't used in attackTarget
		local shield, shield_combat = self:hasShield()
		local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat or self.combat
		if not shield then
			self:attackTarget(target, (self:getTalentLevel(t) >= 2) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t), true)
			self:attackTarget(target, (self:getTalentLevel(t) >= 4) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t), true)
			self:attackTarget(target, (self:getTalentLevel(t) >= 6) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t), true)
			self:attackTarget(target, (self:getTalentLevel(t) >= 8) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t), true)		
		else
			self:attackTargetWith(target, weapon, (self:getTalentLevel(t) >= 2) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))
			self:attackTargetWith(target, shield_combat, (self:getTalentLevel(t) >= 2) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))

			self:attackTargetWith(target, weapon, (self:getTalentLevel(t) >= 4) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))
			self:attackTargetWith(target, shield_combat, (self:getTalentLevel(t) >= 4) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))

			self:attackTargetWith(target, weapon, (self:getTalentLevel(t) >= 6) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))
			self:attackTargetWith(target, shield_combat, (self:getTalentLevel(t) >= 6) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))

			self:attackTargetWith(target, weapon, (self:getTalentLevel(t) >= 8) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))
			self:attackTargetWith(target, shield_combat, (self:getTalentLevel(t) >= 8) and DamageType.ACID_BLIND or DamageType.ACID, t.getDamage(self, t))
		end
		return true
	end,
	info = function(self, t)
		return ([[You strike the enemy with a rain of fast, acidic blows. You strike four times for pure acid damage. Every blow does %d%% damage.
		Every two talent levels, one of your strikes becomes blinding acid instead of normal acid, blinding the target 25%% of the time if it hits.
		Each point in acid drake talents also increases your acid resistance by 1%%.

		This talent will also attack with your shield, if you have one equipped.]]):tformat(100 * self:combatTalentWeaponDamage(t, 0.1, 0.6))
	end,
}

newTalent{
	name = "Corrosive Breath",
	type = {"wild-gift/venom-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 20,
	cooldown = 20,
	message = _t"@Source@ breathes acid!",
	tactical = { ATTACKAREA = { ACID = 2 }, DISABLE = {disarm = 1} },
	range = 0,
	radius = function(self, t) return math.min(13, math.floor(self:combatTalentScale(t, 5, 9))) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) 
		local bonus = self:knowTalent(self.T_CHROMATIC_FURY) and self:combatTalentStatDamage(t, "wil", 30, 520) or 0
		return self:combatTalentStatDamage(t, "str", 30, 520) + bonus
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local damage = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			
			DamageType:get(DamageType.ACID).projector(self, tx, ty, DamageType.ACID, damage)
			if target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, 3, {apply_power = self:combatMindpower()})
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_acid", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="acidwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		return ([[You breathe acid in a frontal cone of radius %d. Any target caught in the area will take %0.2f acid damage.
		Enemies caught in the acid are disarmed for 3 turns.
		The damage will increase with your Strength, the critical chance is based on your Mental crit rate, and the Disarm apply power is based on your Mindpower.
		Each point in acid drake talents also increases your acid resistance by 1%%.]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.ACID, t.getDamage(self, t)))
	end,
}
