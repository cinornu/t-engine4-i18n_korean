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
	name = "Coup de Grace",
	type = {"technique/assassination", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 24,
	require = techs_dex_req_high1,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.5) end,
	getPercent = function(self, t) return self:combatTalentLimit(t, 0.3, 0.1, 0.25) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Coup de Grace without dual wielding!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not x or not y or not target then return nil end

		local mult = t.getDamage(self,t)
		if (target.life / target.max_life <= 0.3) then mult = mult * 1.5 end
		-- Attack with offhand first
		local hits = 0
		hits = hits + (self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, mult)) and 1 or 0)
		hits = hits + (self:attackTargetWith(target, weapon.combat, nil, mult) and 1 or 0)
		
		if hits > 0 then
			if target:checkHit(self:combatAttack(), target:combatPhysicalResist(), 0, 95) and target:canBe("instakill") and target.life < target.max_life * 0.2 then
				-- KILL IT !
				self:logCombat(target, "#Source# delivers a Coup de Grace against #Target#!")
				target:die(self)
			elseif target.life > 0 and target.life < target.max_life * 0.2 then
				game.logSeen(target, "%s resists the Coup de Grace!", target:getName():capitalize())
			end
		end

		if target.dead and self:knowTalent(self.T_STEALTH) then
			game:onTickEnd(function()
				if not self:isTalentActive(self.T_STEALTH) then
					self.hide_chance = 1000
					self.talents_cd["T_STEALTH"] = 0
					game.logSeen(self, "#GREY#%s slips into shadow.", self:getName():capitalize())
					self:forceUseTalent(self.T_STEALTH, {ignore_energy=true, silent = true})
					self.hide_chance = nil
				end
			end)
		end
		return true
	end,
	info = function(self, t)
		dam = t.getDamage(self,t)*100
		perc = t.getPercent(self,t)*100
		return ([[Attempt to finish off a wounded enemy, striking them with both weapons for %d%% increased by 50%% if their life is below 30%%.  A target brought below 20%% of its maximum life must make a physical save against your Accuracy or be instantly slain.
		You may take advantage of finishing your foe this way to activate stealth (if known).]]):
		tformat(dam, perc)
	end,
}

newTalent{
	name = "Terrorize",
	type = {"technique/assassination", 2},
	require = techs_dex_req_high2,
	points = 5,
	mode = "passive",
	radius = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 2, 5.5)) end,
	range = 0,
	getDuration = function(self, t) return self:combatTalentScale(t, 3, 5) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	terrorize = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.TERROR, {dur=t.getDuration(self,t)})
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self,t)
		return ([[When you exit stealth, you reveal yourself dramatically, intimidating foes around you. 
		All foes within radius %d that witness you leaving stealth will be stricken with terror, which randomly inflicts stun, slow (40%% power), or confusion (50%% power) for %d turns.
		The chance to terrorize improves with your combat accuracy.]])
		:tformat(radius, duration)
	end,
}

newTalent{
	name = "Garrote",
	type = {"technique/assassination", 3},
	require = techs_dex_req_high3,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	mode = "passive",
	requires_target = true,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 0.2, 0.6) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "show_gloves_combat", 1)
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		local dam = t.getDamage(self,t)
		if target and not target.dead and self:isTalentActive(self.T_STEALTH) and not self:isTalentCoolingDown(t) and core.fov.distance(self.x, self.y, target.x, target.y) <= 1 then
			self:startTalentCooldown(t)
			-- check takes the place of normal melee hit chance
			if not self:checkHit(self:combatAttack(), target:combatPhysicalResist()) or not target:canBe("pin") then
				self:logCombat(target, "#Target# avoids a garrote from #Source#!")
				return
			end
			local silence = target:canBe("silence") and math.ceil(t.getDuration(self, t)/2) or 0
			target:setEffect(target.EFF_GARROTE, t.getDuration(self, t), {power=dam, src=self, silence=silence})
		end
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)*100
		local dur = t.getDuration(self,t)
		local sdur = math.ceil(t.getDuration(self,t)/2)
		return ([[When attacking from stealth, you slip a garrote over the target’s neck (or other vulnerable part).  This strangles for %d turns and silences for %d turns.  Strangled targets are pinned and suffer an automatic unarmed attack for %d%% damage each turn. 
		Your chance to apply the garrote increases with your Accuracy and you must stay adjacent to your target to maintain it.
		This talent has a cooldown.]])
		:tformat(dur, sdur, damage)
	end,
}

newTalent{
	name = "Marked for Death",
	type = {"technique/assassination", 4},
	require = techs_dex_req_high4,
	points = 5,
	cooldown = 25,
	range = 10,
	stamina = 30,
	requires_target = true,
	no_break_stealth = true,
	no_npc_use = true, -- lol 
	getPower = function(self, t) return self:combatTalentScale(t, 15, 40) end,
	getPercent = function(self, t) return self:combatTalentLimit(t, 50, 20, 40) end,
	getDamage = function(self,t) return self:combatTalentStatDamage(t, "dex", 15, 180) end,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not (x and y) or not self:canProject(tg, x, y) then return nil end
		
		self:project(tg, x, y, function(px, py)
		    target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
				target:setEffect(target.EFF_MARKED_FOR_DEATH, 4, {src=self, power=t.getPower(self,t), perc=t.getPercent(self,t)/100, dam = t.getDamage(self,t), stam = t.stamina, max_dur=4})
		end)

		return true
	end,
	info = function(self, t)
		power = t.getPower(self,t)
		perc = t.getPercent(self,t)
		dam = t.getDamage(self,t)
		return ([[You mark a target for death for 4 turns, causing them to take %d%% increased damage from all sources. When this effect ends they will immediately take physical damage equal to %0.2f plus %d%% of all damage taken while marked.
		If a target dies while marked, the cooldown of this ability is reset and the cost refunded.
		This ability can be used without breaking stealth.
		The base damage dealt will increase with your Dexterity.]]):
		tformat(power, damDesc(self, DamageType.PHYSICAL, dam), perc)
	end,
}