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

archery_range = Talents.main_env.archery_range

newTalent{
	name = "Shoot Down",
	type = {"technique/reflexes", 1},
	no_energy = true,
	points = 5,
	cooldown = 4,
	stamina = 8,
	range = archery_range,
	require = techs_dex_req1,
	onAIGetTarget = function(self, t)
		local tgts = {}
		self:project({type="ball", radius=self:getTalentRange(t)}, self.x, self.y, function(px, py)
			local tgt = game.level.map(px, py, Map.PROJECTILE)
			if tgt and (not tgt.src or self:reactionToward(tgt.src) < 0) then tgts[#tgts+1] = {x=px, y=py, tgt=tgt, dist=core.fov.distance(self.x, self.y, px, py)} end
		end)
		table.sort(tgts, function(a, b) return a.dist < b.dist end)
		if #tgts > 0 then return tgts[1].x, tgts[1].y, tgts[1].tgt end
	end,
	on_pre_use_ai = function(self, t, silent) return t.onAIGetTarget(self, t) and true or false end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	requires_target = true,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), scan_on=engine.Map.PROJECTILE, no_first_target_filter=true}
	end,
	getSlow = function(self,t) return math.min(90, self:combatTalentScale(t, 15, 50)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "slow_projectiles", t.getSlow(self, t))
	end,
	tactical = {SPECIAL=10},
	action = function(self, t)
		for i = 1, t.getNb(self, t) do
			local targets = self:archeryAcquireTargets(self:getTalentTarget(t), {one_shot=true, no_energy=true})
			if (not targets or #targets == 0) then if i == 1 then return else break end end

			local x, y = targets[1].x, targets[1].y
			local proj = game.level.map(x, y, Map.PROJECTILE)
			if proj then
				proj:terminate(x, y)
				game.level:removeEntity(proj, true)
				proj.dead = true
				self:logCombat(proj, "#Source# shoots down '#Target#'!")
			end
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Your reflexes are lightning-fast, if you spot a projectile (arrow, shot, spell, ...) you can instantly shoot at it without taking a turn to take it down.
		You can shoot down up to %d projectiles.
		In addition, your heightened senses also reduce the speed of incoming projectiles by %d%%, and prevents your own projectiles from striking you.]]):
		tformat(t.getNb(self, t), t.getSlow(self,t))
	end,
}


newTalent{
	name = "Intuitive Shots",
	type = {"technique/reflexes", 2},
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_stamina = 30,
	no_energy = true,
	require = techs_dex_req2,
	tactical = { BUFF = 2 },
	getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 40, 10, 30)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.2, 0.6) end,
	-- called by _M:attackTarget in mod.class.interface.Combat.lua
	proc = function(self, t, target)
		if not rng.percent(t.getChance(self,t)) then return end
		if target.turn_procs.intuitive_shots == true then return true end  -- If we've proc'd once confirm the deflect but skip the counterattack
		local old = self.energy.value
		local weapon, ammo = self:hasArcheryWeapon()
		if not weapon then return end
		local targets = self:archeryAcquireTargets(nil, {one_shot=true, x=target.x, y=target.y}) --Ammo check done here
		if not targets then return end
		if not target.turn_procs.intuitive_shots and not (self:isTalentActive(self.T_CONCEALMENT) or self:hasEffect(self.EFF_WILD_SPEED) or self:hasEffect(self.EFF_ESCAPE)) then self:archeryShoot(targets, t, nil, {mult=t.getDamage(self,t)}) end
		target.turn_procs.intuitive_shots = true
		self.energy.value = old
		return true
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local chance = t.getChance(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[Activating this talent enhances your reflexes to incredible levels.  Each time you are attacked in melee, you have a %d%% chance to fire off a defensive shot off in time to intercept the attack, evading it and dealing %d%% archery damage.
		This cannot damage the same target more than once per turn.]])
		:tformat(chance, dam)
	end,
}

newTalent{
	name = "Sentinel",
	type = {"technique/reflexes", 3},
	require = techs_dex_req3,
	points = 5,
	cooldown = function(self, t) return math.max(6, 13-(math.floor(self:getTalentLevel(t)))) end,
	stamina = 25,
	tactical = { DISABLE=3 },
	range = archery_range,
	requires_target = true,
	no_npc_use = true,
	fixed_cooldown = true, -- there's probably some sort of unexpected interaction that would let you chain this infinitely with cooldown reducers
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3.5)) end, --Limit < 100%
	getCooldown = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3.5)) end, --Limit < 100%
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	archery_onhit = function(self, t, target, x, y)
	
		local tids = {}
		for tid, lev in pairs(target.talents) do
			local t = target:getTalentFromId(tid)
			if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end

		local cdr = t.getCooldown(self, t)
		for i = 1, t.getTalentCount(self, t) do
			local t = rng.tableRemove(tids)
			if not t then break end
			target.talents_cd[t.id] = cdr
			game.logSeen(target, "%s's %s is disrupted by the shot!", target:getName():capitalize(), t.name)
		end
	end,
	doShoot = function(self, t, eff)
		if self:attr("disarmed") then self:removeEffect(self.EFF_SENTINEL) return end
		local target = eff.target
		local targets = self:archeryAcquireTargets({type="hit"}, {one_shot=true, x=target.x, y=target.y, infinite=true, no_energy = true})
		if not targets then return end
		self:archeryShoot(targets, t, {type="hit", start_x=self.x, start_y=self.y}, {mult=0.25})
		target:removeEffect(target.EFF_SENTINEL)
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		target:setEffect(target.EFF_SENTINEL, 5, {src=self, target=target})
		
		return true
	end,
	info = function(self, t)
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[You take close notice of the target for the next 5 turns. If they attempt to use a non-instant talent you react with incredible speed, firing a shot dealing 25%% damage that causes the talent to fail and go on cooldown.
This shot is instant, cannot miss, and puts %d other talents on cooldown for %d turns.]]):
		tformat(nb, cd)
	end,
}

newTalent{
	name = "Escape",
	type = {"technique/reflexes", 4},
	no_energy = true,
	points = 5,
	cooldown = 25,
	require = techs_dex_req4,
	random_ego = "defensive",
	tactical = { ESCAPE = 2, DEFEND = 2 },
	getDamageReduction = function(self, t) return self:combatTalentLimit(t, 70, 15, 40) end,
	getSpeed = function(self, t) return self:combatTalentScale(t, 150, 350) end,
	getStamina = function(self, t) return self:combatTalentScale(t, 5, 10) end,
	action = function(self, t)
		local power = t.getDamageReduction(self,t)
		local speed = t.getSpeed(self,t)
		local stamina = t.getStamina(self,t)
		game:onTickEnd(function() self:setEffect(self.EFF_ESCAPE, 4, {src=self, power=power, stamina=stamina, speed=speed}) end)
		return true
	end,
	info = function(self, t)
		local power = t.getDamageReduction(self,t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[You put all your focus into escaping combat for 4 turns. While under this effect you gain %d%% increased resistance to all damage, %0.1f increased stamina regeneration, immunity to stun, pin, daze and slowing effects and %d%% increased movement speed. 
Any action other than movement will cancel this effect.]]):
		tformat(power, sta, speed)
	end,
}