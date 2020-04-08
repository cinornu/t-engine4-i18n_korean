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

local Object = require "mod.class.Object"
-- Dream-Forge Hammer
function useDreamHammer(self)
	local combat = {
		talented = "dream",
		sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2},

		wil_attack = true,
		damrange = 1.5,
		physspeed = 1,
		dam = 16,
		apr = 0,
		atk = 0,
		physcrit = 0,
		dammod = {wil=1.2},
		melee_project = {},
	}
	if self:knowTalent(self.T_DREAM_HAMMER) then
		local t = self:getTalentFromId(self.T_DREAM_HAMMER)
		combat.dam = 16 + t.getBaseDamage(self, t)
		combat.apr = 0 + t.getBaseApr(self, t)
		combat.physcrit = 0 + t.getBaseCrit(self, t)
		combat.atk = 0 + t.getBaseAtk(self, t)
	end
	if self:knowTalent(self.T_HAMMER_TOSS) then
		local t = self:getTalentFromId(self.T_HAMMER_TOSS)
		combat.atk = t.getAttackTotal(self, t)
	end
	if self:knowTalent(self.T_FORGE_ECHOES) then
		local t = self:getTalentFromId(self.T_FORGE_ECHOES)
		combat.melee_project = { [engine.DamageType.DREAMFORGE] = t.getProject(self, t) }
	end
	return combat
end

-- tactical value (between 1 and 3) for a Dream-Forge Hammer attack, accounting for various talent enhancements
function hammer_tactical(self, t)
	return "PHYSICAL", 1 + util.bound(self:getTalentLevelRaw(self.T_DREAM_HAMMER) + self:getTalentLevelRaw(self.T_HAMMER_TOSS)/2 + self:getTalentLevelRaw(self.T_FORGE_ECHOES)/2, 0, 10)/5
end

newTalent{
	name = "Dream Smith's Hammer",
	short_name = "DREAM_HAMMER",
	type = {"psionic/dream-smith", 1},
	points = 5,
	require = psi_wil_req1,
	cooldown = 6,
	psi = 5,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { [hammer_tactical] = 1 } },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.4, 2.1) end,
	getBaseDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 60) end,
	getBaseAtk = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	getBaseApr = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	getBaseCrit = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})

		-- Reset Dream Smith talents
		if hit then
			local trigger_discharge = false
			local nb = self:getTalentLevel(t) >= 5 and 2 or 1
			for tid, cd in pairs(self.talents_cd) do
				local tt = self:getTalentFromId(tid)
				if tt.type[1]=="psionic/dream-smith" and nb > 0 then
					self.talents_cd[tid] = 0
					trigger_discharge = true
					nb = nb - 1
				end
			end
			if hit and trigger_discharge then
				if rng.percent(50) then
					game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
				else
					game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
				end
				game:playSoundNear(self, "talents/heal")
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local weapon_stats = Object:descCombat(self, {combat=useDreamHammer(self)}, {}, "combat")
		return ([[Craft a hammer from the dream forge and strike an adjacent foe, inflicting %d%% weapon damage. If the attack hits, it will bring one random Dream Smith talent off cooldown.
		At talent level 5, you'll bring a second random talent off cooldown.
		The base power, Accuracy, Armour penetration, and critical strike chance of the weapon will scale with your Mindpower.
		
		Current Dream Hammer Stats:
		%s]]):tformat(damage * 100, tostring(weapon_stats))
	end,
}

newTalent{
	name = "Hammer Toss",
	type = {"psionic/dream-smith", 2},
	points = 5,
	require = psi_wil_req2,
	cooldown = 8,
	psi = 10,
	tactical = { ATTACKAREA = { [hammer_tactical] = 1 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	requires_target = true,
	proj_speed = 10,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), selffire=false, talent=t, nolock=true, display={display='', particle="arrow", particle_args={tile="shockbolt/object/dream_hammer"}, trail="firetrail"}}
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getAttack = function(self, t) return self:getTalentLevel(t) * 10 end, -- Used for the talent display
	getAttackTotal = function(self, t)
		local base_atk = 0
		if self:knowTalent(self.T_DREAM_HAMMER) then
			local t = self:getTalentFromId(self.T_DREAM_HAMMER)
			base_atk = 0 + t.getBaseAtk(self, t)
		end
		return base_atk + t.getAttack(self, t)
	end,
	getDreamHammer = function(self, t) return useDreamHammer(self) end, -- To prevent upvalue issues
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		print("[Dream Hammer Throw] Projection from", self.x, self.y, "to", x, y)
		self:projectile(tg, x, y, function(px, py, tg, self)
			local tmp_target = game.level.map(px, py, engine.Map.ACTOR)
			if tmp_target and tmp_target ~= self then
				local t = self:getTalentFromId(self.T_HAMMER_TOSS)
				self:attackTargetWith(tmp_target, t.getDreamHammer(self, t), nil, t.getDamage(self, t))
			end
			if x == px and y == py and self and self.x and self.y then
				print("[Dream Hammer Return] Projection from", x, y, "to", self.x, self.y)
				local tgr = tg
				tgr.name = _t"Hammer Toss"
				tgr.x, tgr.y = px, py
				self:projectile(tgr, self.x, self.y, function(px, py, tgr, self)
					local tmp_target = game.level.map(px, py, engine.Map.ACTOR)
					local t = self:getTalentFromId(self.T_HAMMER_TOSS)
					if tmp_target and tmp_target ~= self then
						self:attackTargetWith(tmp_target, t.getDreamHammer(self, t), nil, t.getDamage(self, t))
					end
				end)
			end
		end)

		game:playSoundNear(self, "talents/warp")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local attack_bonus = t.getAttack(self, t)
		return ([[Throw your Dream Hammer at a distant location, inflicting %d%% weapon damage on all targets between you and it.  After reaching its destination, the Dream Hammer will return, potentially hitting targets a second time.
		Learning this talent increases the Accuracy of your Dream Hammer by %d.]]):tformat(damage * 100, attack_bonus)
	end,
}

newTalent{
	name = "Dream Crusher",
	type = {"psionic/dream-smith", 3},
	points = 5,
	require = psi_wil_req3,
	cooldown = 12,
	psi = 10,
	requires_target = true,
	tactical = { ATTACK = { [hammer_tactical] = 1 }, DISABLE = { stun = 2 } },
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	getStun = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getWeaponDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStun(self, t), {apply_power=self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the stunning blow!", target:getName():capitalize())
			end
			if rng.percent(50) then
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
			elseif hit then
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
			end
			game:playSoundNear(self, "talents/lightning_loud")
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getWeaponDamage(self, t)
		local power = t.getDamage(self, t)
		local percent = t.getPercentInc(self, t)
		local stun = t.getStun(self, t)
		return ([[Crush your enemy with your Dream Hammer, inflicting %d%% weapon damage.  If the attack hits, the target is stunned for %d turns.
		Stun chance improves with your Mindpower.  Learning this talent increases your Physical Power for Dream Hammer damage calculations by %d and all damage with Dream Hammer attacks by %d%%.
		]]):tformat(damage * 100, stun, power, percent * 100)
	end,
}

newTalent{
	name = "Forge Echoes",
	type = {"psionic/dream-smith", 4},
	points = 5,
	require = psi_wil_req4,
	cooldown = 24,
	psi = 20,
	tactical = { ATTACK = {[hammer_tactical] = 1}, ATTACKAREA = { MIND = 0.5, FIRE = 0.5} },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	requires_target = true,
	on_pre_use_ai = function(self, t, silent, fake) --only usable on melee targets (in spite of radius)
		local aitarget = self.ai_target.actor
		return aitarget and core.fov.distance(self.x, self.y, aitarget.x, aitarget.y) <= 1
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false }
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getProject = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	range = 1,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})

		-- Forge Echo
		if hit then
			local tg = self:getTalentTarget(t)
			self:project(tg, target.x, target.y, function(px, py, tg, self)
				local tmp_target = game.level.map(px, py, Map.ACTOR)
				if tmp_target and tmp_target ~= self and tmp_target ~= target then
					local hit = self:attackTargetWith(tmp_target, useDreamHammer(self), DamageType.DREAMFORGE, t.getDamage(self, t))
					if hit and rng.percent(50) then
						game.level.map:particleEmitter(tmp_target.x, tmp_target.y, 1, "generic_discharge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
					elseif hit then
						game.level.map:particleEmitter(tmp_target.x, tmp_target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
					end
				end
			end)
			game:playSoundNear(self, "talents/echo")
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local project = t.getProject(self, t) /2
		return ([[Strike an adjacent target with a mighty blow from the forge, inflicting %d%% weapon damage.  If the attack hits, the echo of the attack will lash out at all enemies in a %d radius of the impact.
		Learning this talent adds %0.2f mind damage and %0.2f burning damage to your Dream Hammer strikes.
		The mind and fire damage will scale with your Mindpower.]]):tformat(damage * 100, radius, damDesc(self, DamageType.MIND, project), damDesc(self, DamageType.FIRE, project))
	end,
}
