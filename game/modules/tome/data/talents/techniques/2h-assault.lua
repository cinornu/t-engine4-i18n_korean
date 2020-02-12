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
	name = "Stunning Blow", short_name = "STUNNING_BLOW_ASSAULT", image = "talents/stunning_blow.png",
	type = {"technique/2hweapon-assault", 1},
	require = techs_req1,
	points = 5,
	cooldown = 8,
	stamina = 8,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getDuration = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 3, 7))) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then return nil end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		for i = 1,2 do
			local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 0.5, 0.7))

			-- Try to stun !
			if hit then
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
				else
					game.logSeen(target, "%s resists the stunning blow!", target:getName():capitalize())
				end
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hit the target twice with your two-handed weapon, doing %d%% damage. Each hit will try to stun the target for %d turns.
		The stun chance increases with your Physical Power.]])
		:tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 0.7), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Fearless Cleave",
	type = {"technique/2hweapon-assault", 2},
	require = techs_req2,
	points = 5,
	cooldown = 0,
	stamina = 20,
	tactical = { ATTACK = { weapon = 2 }, CLOSEIN = 0.5 },
	requires_target = true,
	is_melee = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.4) end,
	on_pre_use = function(self, t, silent)
		if self:attr("never_move") then if not silent then game.logPlayer(self, "You must be able to move to use this talent.") end return false end
		if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end
		return true
	end,
	range = 1,
	radius = 1,
	target = function(self, t) return {type="hitball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), simple_dir_request=true} end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then return nil end

		local tg = self:getTalentTarget(t)
		local hit, x, y = self:canProject(tg, self:getTarget(tg))
		if not hit or not x or not y then return nil end

		if self:canMove(x, y) then
			self:move(x, y, true)
		end

		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				self:attackTargetWith(target, weapon.combat, nil, t.getDamage(self, t))
			end
		end)

		self:addParticles(Particles.new("meleestorm", 1, {radius=self:getTalentRadius(t)}))

		return true
	end,
	info = function(self, t)
	local damage = t.getDamage(self, t) * 100
		return ([[Take a step toward your foes then use the momentum to cleave all creatures adjacent to you for %d%% weapon damage.]])
		:tformat(damage)
	end,
}

newTalent{
	name = "Death Dance", short_name = "DEATH_DANCE_ASSAULT", image = "talents/death_dance.png",
	type = {"technique/2hweapon-assault", 3},
	require = techs_req3,
	points = 5,
	cooldown = 10,
	stamina = 30,
	tactical = { ATTACKAREA = { weapon = 3 } },
	range = 0,
	radius = 2,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getBleed = function(self, t) return self:combatTalentScale(t, 0.3, 1) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Death Dance without a two-handed weapon!")
			return nil
		end

		local scale = nil
		if self:getTalentLevel(t) >= 3 then
			scale = t.getBleed(self, t)
		end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				local oldlife = target.life
				self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1.4, 2.1))
				local life_diff = oldlife - target.life
				if life_diff > 0 and target:canBe('cut') and scale then
					target:setEffect(target.EFF_CUT, 5, {power=life_diff * scale / 5, src=self})
				end
			end
		end)

		self:addParticles(Particles.new("meleestorm", 1, {radius=self:getTalentRadius(t)}))

		return true
	end,
	info = function(self, t)
		return ([[Spin around, extending your weapon in radius %d and damaging all targets around you for %d%% weapon damage.
		At level 3 all damage done will also make the targets bleed for an additional %d%% damage over 5 turns]]):tformat(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 1.4, 2.1), t.getBleed(self, t) * 100)
	end,
}

newTalent{
	name = "Execution",
	type = {"technique/2hweapon-assault", 4},
	require = techs_req4,
	points = 5,
	cooldown = 8,
	stamina = 25,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 } },
	getPower = function(self, t) return self:combatTalentScale(t, 1.0, 2.5, "log") end, -- +125% bonus against 50% damaged foe at talent level 5.0
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	is_melee = true,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then return nil end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local perc = 1 - (target.life / target.max_life)
		local power = t.getPower(self, t)
--		game.logPlayer(self, "perc " .. perc .. " power " .. power) -- debugging code
		self.turn_procs.auto_phys_crit = true
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, 1 + power * perc)
		self.turn_procs.auto_phys_crit = nil

		if target.dead then
			self:talentCooldownFilter(nil, 2, 2)
			game:onTickEnd(function() self:alterTalentCoolingdown(t.id, -9999) end)  -- CD isn't set yet
		end
		return true
	end,
	info = function(self, t)
		return ([[Takes advantage of a wounded foe to perform a killing strike.  This attack is an automatic critical hit that does %0.1f%% extra weapon damage for each %% of life the target is below maximum.
		(A victim with 30%% remaining life (70%% damaged) would take %0.1f%% weapon damage.)
		If an enemy dies from this attack then two of your talent cooldowns are reduced by 2 turns and Execution's cooldown is reset.]]):
		tformat(t.getPower(self, t), 100 + t.getPower(self, t) * 70)
	end,
}
