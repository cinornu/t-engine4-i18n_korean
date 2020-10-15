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

newTalent{
	name = "Dual Weapon Mastery",
	type = {"technique/duelist", 1},
	points = 5,
	require = techs_dex_req1,
	mode = "passive",
	callbackOnLevelup = function(self, t, level) -- make sure NPC's start with the parry buff active
		if not self.player then
			game:onTickEnd(function()
				if not self:hasEffect(self.EFF_PARRY) then
					t.callbackOnActBase(self, t)
				end
			end, self.uid.."PARRY")
		end
	end,
	getDeflectChance = function(self, t) --Chance to parry with an offhand weapon
		local chance = math.min(100, self:combatLimit(self:getTalentLevel(t)*self:getDex(), 90, 15, 20, 60, 250)) -- limit < 90%, ~67% at TL 6.5, 55 dex
		local eff = self:hasEffect(self.EFF_FEINT)
		if eff then chance = 100 - (100 - chance)*(1 - eff.parry_efficiency) end
		return chance
	end,
	-- deflect count handled in physical effect "PARRY" in mod.data.timed_effects.physical.lua
	getDeflects = function(self, t, fake)
		if fake or self:hasDualWeapon() then
			return self:combatStatScale("cun", 2, 3) + (not fake and self:hasEffect(self.EFF_FEINT) and 1 or 0)
		else return 0
		end
	end,
	getDamageChange = function(self, t)
		local dam,_,weapon = 0,self:hasDualWeapon()
		if not weapon or weapon.subtype=="mindstar" and not fake then return 0 end
		if weapon then
			dam = self:combatDamage(weapon.combat) * self:getOffHandMult(weapon.combat)
		end
		return self:combatScale(dam, 5, 10, 50, 250)
	end,
	getoffmult = function(self,t) return self:combatTalentLimit(t, 1, 0.6, 0.85) end, -- limit <100%
	callbackOnActBase = function(self, t)
		local mh, oh = self:hasDualWeapon()
		if (mh and oh) and oh.subtype ~= "mindstar" then
			self:setEffect(self.EFF_PARRY,1,{chance=t.getDeflectChance(self, t), dam=t.getDamageChange(self, t), deflects=t.getDeflects(self, t), parry_ranged=true})
		end
	end,
	on_unlearn = function(self, t) self:removeEffect(self.EFF_PARRY) end,
	info = function(self, t)
		mult = t.getoffmult(self,t)*100
		block = t.getDamageChange(self, t, true)
		chance = t.getDeflectChance(self,t)
		return ([[Your offhand weapon damage penalty is reduced to %d%%.
		Up to %0.1f times a turn, you have a %d%% chance to parry up to %d damage (based on your offhand weapon damage) from a melee or ranged attack.  The number of parries increases with your Cunning.  (A fractional parry has a reduced chance to succeed.)
		A successful parry reduces damage like armour (before any attack multipliers) and prevents critical strikes.  It is difficult to parry attacks from unseen attackers and you cannot parry with a mindstar.]]):
		tformat(100 - mult, t.getDeflects(self, t, true), chance, block)
	end,
}

local function do_tempo(self, t, src) -- handle Tempo defensive bonuses
--game.log("do_tempo called for %s (%s)", self.name, src and src.name)
	if self.turn_procs.tempo then return end
	local mh, oh = self:hasDualWeapon()
	if mh and oh then
		self:incStamina(t.getStamina(self,t))
		self.energy.value = self.energy.value + game.energy_to_act*t.getSpeed(self,t)/100
		self:alterTalentCoolingdown(self.T_LUNGE, -1)
	end
	self.turn_procs.tempo = true
end

newTalent{
	name = "Tempo",
	type = {"technique/duelist", 2},
	require = techs_dex_req2,
	points = 5,
	mode = "passive",
	getStamina = function(self, t) return self:combatTalentLimit(t, 15, 2, 5) end, -- Limit < 15 (effectively scales with actor speed)
	getSpeed = function(self, t) return self:combatTalentLimit(t, 25, 5, 15) end, -- Limit < 25% of a turn gained
	do_tempo = do_tempo,
	callbackOnMeleeMiss = do_tempo,
	callbackOnArcheryMiss = do_tempo,
	-- handle offhand crit
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if crit and not self.turn_procs.tempo_attack then
			local mh, oh = self:hasDualWeapon()
			if oh and oh.combat == weapon then
				self:incStamina(t.getStamina(self,t))
			end
			self.turn_procs.tempo_attack = true
		end
	end,
	info = function(self, t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[The flow of battle invigorates you, allowing you to press your advantage as the fight progresses.
		Up to once each per turn, while dual wielding, you may:
		Riposte -- If a melee or archery attack misses you or you parry it, you instantly restore %0.1f stamina and gain %d%% of a turn.
		Recover -- On performing a critical strike with your offhand weapon, you instantly restore %0.1f stamina.]]):tformat(sta, speed, sta)
	end,
}

newTalent{
	name = "Feint",
	type = {"technique/duelist", 3},
	require = techs_dex_req3,
	points = 5,
	random_ego = "defensive",
	cooldown = 8,
	stamina = 6,
	requires_target = true,
	tactical = { DISABLE = {pin = 1}, DEFEND = 1 },
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 6, 2, 4.5)) end, 
	getParryEfficiency = function(self, t) -- return increased parry efficiency
		return math.floor(self:combatTalentLimit(t, 75, 20, 50))
	end,
	on_pre_use = function(self, t, silent)
		if self:attr("never_move") then
			if not silent then game.logPlayer(self, "You must be able to move to use this talent.") end
			return false
		end
		return true
	end,
	speed = "weapon",
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local tx, ty, sx, sy = target.x, target.y, self.x, self.y

		if not self.dead and tx == target.x and ty == target.y then
		
			if target:attr("never_move") then
				game.logPlayer(self, "%s cannot move!", target:getName():capitalize())
				return false
			elseif not self:canMove(tx,ty,true) or not target:canMove(sx,sy,true) then
				self:logCombat(target, "Terrain prevents #Source# from switching places with #Target#.")
				return false
			end
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, 2, {apply_power=self:combatAttack()})
			end
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, 2, {apply_power=self:combatAttack()})
			end
			self:setEffect(self.EFF_FEINT, t.getDuration(self, t), {parry_efficiency=t.getParryEfficiency(self, t)/100})
			-- Displace
			if not target.dead then
				self:move(tx, ty, true)
				target:move(sx, sy, true)
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Make a cunning feint that tricks your target into swapping places with you.  While moving, you take the opportunity to trip them, pinning and dazing them for 2 turns.
		Switching places distracts your foes and allows you to improve your defenses:  For %d turns, Dual Weapon Mastery yields one extra parry each turn and you are %d%% less likely to miss your parry opportunities.
		The chance to pin and to daze increases with your Accuracy]]):
		tformat(t.getDuration(self, t), t.getParryEfficiency(self, t))
	end,
}

newTalent{
	name = "Lunge",
	type = {"technique/duelist", 4},
	require = techs_dex_req4,
	points = 5,
	cooldown = 18,
	stamina = 12,
	requires_target = true,
	tactical = { DISABLE = {disarm = 2}, ATTACK = {weapon = 2} },
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.8, 3.5) end, --super high scaling because this is offhand only
	on_pre_use = function(self, t, silent)
		if not self:hasDualWeapon() then
			if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end
			return false
		end
		return true
	end,
	speed = "weapon",
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not offweapon then
			game.logPlayer(self, "You cannot use Lunge without dual wielding!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or core.fov.distance(self.x, self.y, x, y) ~= 1 or not self:canProject(tg, x, y) then return nil end

		-- Attack		
		local dam = t.getDamage(self,t)
		local spd, hitted, dmg = self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, dam))
		if hitted and target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the blow!", target:getName():capitalize())
		end
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[Exploiting a gap in your target's defenses, you make a lethal strike with your offhand weapon for %d%% damage that causes them to drop their weapon, disarming them for %d turns.
		Tempo will reduce the cooldown of this talent by 1 turn each time it is triggered defensively.
		The chance to disarm increases with your Accuracy.]]):
		tformat(dam*100, dur)
	end,
}