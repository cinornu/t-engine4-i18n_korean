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

--    Small damage
--    Stun and lower bleed resist.
newTalent{
	name = "Brutalize",
	type = {"celestial/darkside", 1},
	require = divi_req1,
	points = 5,
	cooldown = 6,
	positive = 10,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = { stun = 2 } },
	range = 1,
	requires_target = true,
	is_melee = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 0.6) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)
		
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_BRUTALIZED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the brutality!", target.name:capitalize())
			end
		end
		
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target is stunned for %d turns and has their bleed resistance reduced by 50%%.
The stun chance increases with your Physical Power.

#{italic}#It may not bleed, exactly, but you'll make it hurt.#{normal}#]])
		:tformat(100 * damage, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Lunacy",
	type = {"celestial/darkside", 2},
	mode = "passive",
	points = 5,
	require = divi_req2,
	-- called in _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	getMindpower = function(self, t) return self:combatTalentScale(t, 25, 50, 0.75) end,
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local mindpower = t.getMindpower(self, t)
		return ([[Your curse feeds on the magic, which in turn is powered by the curse.
You gain a bonus to Spellpower equal to %d%% of your Willpower.
You gain a bonus to Mindpower equal to %d%% of your Magic.

#{italic}#Something is not quite right inside you.  Your solar spells are somehow twisted, but your bloody rites make things clear as day.#{normal}#]]):tformat(spellpower, mindpower)
	end,
}


newTalent{
	name = "Flee the Sun",
	type = {"celestial/darkside", 3},
	require = divi_req3,
	points = 5,
	positive = 25,
	cooldown = 12,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7, 0.5, 0, 1)) end,
	requires_target = true,
	is_teleport = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), nolock=true, radius=1, selffire=false, talent=t}
	end,
	getBlastTarget = function(self, t)
		return {type="ball", range=0, radius=1, selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 200) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		
		game.level.map:particleEmitter(self.x, self.y, 1, "circle", {oversize=0.7, a=187, limit_life=8, appear=8, speed=4, img="spiral_dark", radius=1})
		
		if not self:teleportRandom(x, y, 0) then
			game.logSeen(self, "%s's teleportation fizzles!", self.name:capitalize())
		else
			game.logSeen(self, "%s emerges from the darkness!", self.name:capitalize())
			
			local btg = t.getBlastTarget(self, t)
			local dam = self:spellCrit(t.getDamage(self, t))
			self:project(btg, self.x, self.y, DamageType.LIGHT, dam)
			game.level.map:particleEmitter(self.x, self.y, 1, "circle", {oversize=0.7, a=187, limit_life=8, appear=8, speed=4, img="spiral_light", radius=1})
		end
		
		game:playSoundNear(self, "talents/fallen_stardust")
		return true
	end,
	
	info = function(self, t)
		local range = t.range(self, t)
		return ([[Fade into the darkness and reappear elsewhere within range %d.  When you emerge from the shadows, you are accompanied by a bright flash, dealing %0.2f light damage to enemies in radius 1.
						 The damage will increase with your Spellpower.]]):tformat(range, damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Final Sunbeam",
	type = {"celestial/darkside", 4},
	require = divi_req4,
	points = 5,
	cooldown = 20,
	range = 0,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	getRadiusScale = function(self, t) return 15 end,
	radius = function(self, t)
		return math.max(1, math.min(10, math.floor(self:getPositive() / t.getRadiusScale(self, t))))
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.5) end,
	getMult = function(self, t) return self:combatTalentScale(t, 1.0, 2.0) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local damage = t.getDamage(self, t) * (1+(t.getMult(self, t) * self:getPositive() / 100))
		
		self:project(tg, self.x, self.y, function(px, py, tg, self)
									 local target = game.level.map(px, py, Map.ACTOR)
									 if target and target ~= self then
										 self:attackTarget(target, nil, damage, true)
										 if target:canBe("stun") then
											 local power = math.max(self:combatSpellpower(), self:combatMindpower(), self:combatPhysicalpower())
											 target:setEffect(target.EFF_DAZED, 3, {apply_power=power})
										 end
									 end
																		 end)
		
		game:playSoundNear(self, "talents/fallen_sun_whoosh")
		self:addParticles(Particles.new("meleestorm", 2, {radius=t.radius(self, t), img="spinningwinds_black"}))
		if not self:attr("zero_resource_cost") and not self:attr("force_talent_ignore_ressources") then
			self:incPositive(-1 * self:getPositive()) 
			self:setEffect(self.EFF_LIGHTS_OUT, 5, {})
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)*100
		local mult = t.getMult(self, t)
		return ([[Put all of your physical and magical might into one devastating attack.
Strike all adjacent enemies for %d%% weapon damage and daze them (using your highest power) for 3 turns.

Using this talent consumes all of your Positive Energy and prevents you from generating positive energy for 5 turns.
Every point of positive energy increases the damage by %.2f%%.
Every %d points of positive energy increase the radius by 1 (up to 10).]]):tformat(damage, mult, t.getRadiusScale(self, t))
	end,
}
