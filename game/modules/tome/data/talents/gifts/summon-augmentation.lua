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
	name = "Rage",
	type = {"wild-gift/summon-augmentation", 1},
	require = gifts_req1,
	mode = "passive",
	points = 5,
	radius = 5,
	incStats = function(self, t) return self:combatTalentMindDamage(t, 10, 100)/4 end,
	callbackOnSummonDeath = function(self, t, summon, src, death_note)
	if summon.summoner ~= self or not summon.wild_gift_summon or summon.summon_time <= 0 then return end
		local tg = {type="ball", range=0, radius=self:getTalentRadius(t), selffire = false, talent=t}
		summon:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or target.summoner ~= self or not target.wild_gift_summon then return end
			target:setEffect(target.EFF_ALL_STAT, 5, {power=t.incStats(self,t)})
		end)
	end,
	info = function(self, t)
		return ([[Induces a killing rage in all your summons within a radius of 5 when a summon is killed, increasing all their stats by %d for 5 turns. 
		The bonus will increase with your mindpower.]]):tformat(t.incStats(self, t))
	end,
}

newTalent{
	name = "Detonate",
	type = {"wild-gift/summon-augmentation", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 5,
	cooldown = 25,
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8, 0.5, 0, 0, true)) end,
	requires_target = true,
	no_npc_use = true,
--[[ WIP: how to set up tactics: (Not implemented at this time)
-- onAIgetTarget to find summon to detonate (closest to target) within radius
-- make sure target is in LOS and can be seen to not waste the summon
-- (use target.fov.actors_dist or LOS to target from summon grid?)
	
--	summon.wild_gift_detonate == t.id for summoning talent
--	tactical = summon.detonate_tactical

	tactical = function(self, t, aitarget)
		local sy, sy, summon = t.onAIgetTarget(self, t) -- finds summon to detonate
		
		if summon and summon.wild_gift_detonate then
			return self:getTalentFromID(summon.wild_gift_detonate).detonate_tactical
		
		end
	end,
--]]
	explodeBleed = function(self,t) return self:combatTalentMindDamage(t, 50, 500) end,
	explodeSecondary = function(self,t) return self:combatTalentMindDamage(t, 30, 250) end,
	explodeFire = function(self,t) return self:combatTalentMindDamage(t, 30, 120) end,
	hydraAffinity = function(self,t) return self:combatTalentLimit(t, 50, 15, 40) end,
	hydraRegen = function(self,t) return self:combatTalentMindDamage (t, 8, 40) end,
	jellySlow = function(self,t) return self:combatTalentLimit(t, 0.60, 0.25, 0.48) end,
	minotaurConfuse = function(self,t) return self:combatTalentLimit(t, 50, 20, 35) end,
	golemArmour = function(self,t) return self:combatTalentScale(t, 15, 33) end,
	golemHardiness = function(self,t) return 15 + self:getTalentLevel(t)*7.7 end,
	shellShielding = function(self,t) return self:combatTalentMindDamage(t, 10, 35) end,
	spiderKnockback = function(self,t) return 1 + math.floor(self:getTalentLevel(t)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend"}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or target.summoner ~= self or not target.wild_gift_summon or not target.wild_gift_detonate then return nil end

		local dt = self:getTalentFromId(target.wild_gift_detonate)

		if not dt.on_detonate then
			game.logPlayer("You may not detonate this summon.")
			return nil
		end

		dt.on_detonate(self, t, target)
		target:die(self)

		local l = {}
		for tid, cd in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t.is_summon then l[#l+1] = tid end
		end
		if #l > 0 then 
			self.talents_cd[rng.table(l)] = nil
		end

		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Destroys one of your summons, making it detonate in radius of %d.
		- Ritch Flamespitter: Explodes into a fireball dealing %d damage, flameshocking damaged foes
		- Hydra: Grants %d%% lightning, acid, and nature affinity as well as %d life regen per turn to all friendly creatures for 7 turns
		- Rimebark: Explodes into an iceball dealing %d ice damage, possibly freezing damaged foes
		- Fire Drake: Explodes into a cloud of lingering fire, dealing %d damage per turn
		- War Hound: Explodes into a sharp ball, cutting all creatures for %0.1f bleeding damage per turn for 6 turns
		- Jelly: Explodes into a ball of slowing slime, dealing %d nature damage and slowing foes by %0.1f%%
		- Minotaur: Confuses foes at %d%% power for 5 turns
		- Stone Golem: Grants %d armour and %d%% armour hardiness to all friendly creatures for 5 turns
		- Turtle: Grants a small shell shield to all friendly creatures, granting %d%% all resist for 5 turns
		- Spider: Knocks back all foes %d tiles
		In addition, a random summon will come off cooldown.
		Hostile effects will not hit you or your other summons.
		The effects improve with your mindpower, and some can crit.]]):tformat(radius, t.explodeSecondary(self,t), t.hydraAffinity(self,t), t.hydraRegen(self,t), t.explodeSecondary(self,t), t.explodeFire(self,t), t.explodeBleed(self,t) / 6, t.explodeSecondary(self,t), t.jellySlow(self,t) * 100, t.minotaurConfuse(self,t), t.golemArmour(self,t), t.golemHardiness(self,t), t.shellShielding(self,t), t.spiderKnockback(self,t)) 
	end,
}

newTalent{
	name = "Resilience",
	type = {"wild-gift/summon-augmentation", 3},
	require = gifts_req3,
	mode = "passive",
	points = 5,
	incLife = function(self, t) return self:combatTalentLimit(t, 1, 0.125, 0.25) end,
	incDur = function(self, t) return math.floor(self:combatTalentLimit(t, 6, 2, 5)) end,
	info = function(self, t)
		return ([[Increases all your summons' max life by %0.1f%% and extends your summons' maximum lifetime by %d turns.]]):tformat(100*t.incLife(self, t), t.incDur(self,t))
	end,
}

newTalent{
	name = "Phase Summon",
	type = {"wild-gift/summon-augmentation", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 5,
	cooldown = 25,
	range = 10,
	requires_target = true,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = {type="hit", nolock=true, range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or target.summoner ~= self or not target.wild_gift_summon then return nil end

		local dur = t.getDuration(self, t)
		self:setEffect(self.EFF_EVASION, dur, {chance=50})
		target:setEffect(target.EFF_EVASION, dur, {chance=50})

		-- Displace
		target:forceMoveAnim(self.x, self.y)
		self:forceMoveAnim(tx, ty)

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[Switches places with one of your summons. This disorients your foes, granting both you and your summon 50%% evasion for %d turns.]]):tformat(t.getDuration(self, t))
	end,
}
