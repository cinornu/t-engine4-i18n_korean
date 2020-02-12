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

local Map = require "engine.Map"

newTalent{
	name = "Lacerating Strikes",
	type = {"cunning/scoundrel", 1},
	points = 5,
	require = cuns_req1,
	mode = "passive",
	no_break_stealth = true,
	getChance = function(self,t) return self:combatTalentLimit(t, 70, 20, 55) end, --Limit < 50%
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >= 0 then return nil end
		if rng.percent(t.getChance(self, t)) and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 4, {src=self, power=(dam / 4)})
		end		
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted, crit, weapon, ammo, damtype, mult, dam, talent)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >= 0 then return nil end
		if rng.percent(t.getChance(self, t)) and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 4, {src=self, power=(dam / 4)})
		end		
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[Your melee and ranged attacks have a %d%% chance to shred enemies inflicting an additional 100%% of the damage dealt as a bleed over 4 turns.]]):
		tformat(chance)
	end,
}

newTalent{
	name = "Scoundrel's Strategies", short_name = "SCOUNDREL",
	type = {"cunning/scoundrel", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	getCritPenalty = function(self,t) return self:combatTalentScale(t, 20, 60) end,
	getDuration = function(self,t) return 4 end,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 8, 35) end, -- Limit < 100%
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >=0 then return nil end
		target:setEffect(target.EFF_SCOUNDREL, 5, {src=self, power=t.getCritPenalty(self,t) })

		if (self.turn_procs.scoundrel and self.turn_procs.scoundrel[target]) or not rng.percent(t.getChance(self,t)) then return end
		local tids = {}
		for tid, lev in pairs(target.talents) do
			local t = target:getTalentFromId(tid)
			if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		
		local cd = t.getDuration(self,t)
		local t = rng.tableRemove(tids)
		if not t or #tids<=0 then return end
		target.talents_cd[t.id] = cd
		game.logSeen(target, "#CRIMSON#%s's %s is disrupted by %s wounds!#LAST#", target:getName():capitalize(), t.name, target:his_her())
		self.turn_procs.scoundrel = self.turn_procs.scoundrel or {}
		self.turn_procs.scoundrel[target] = true
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted, crit, weapon, ammo, damtype, mult, dam, talent)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >=0 then return nil end
		target:setEffect(target.EFF_SCOUNDREL, 5, {src=self, power=t.getCritPenalty(self,t) })

		if (self.turn_procs.scoundrel and self.turn_procs.scoundrel[target]) or not rng.percent(t.getChance(self,t)) then return end
		
		local tids = {}
		for tid, lev in pairs(target.talents) do
			local t = target:getTalentFromId(tid)
			if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		
		local cd = t.getDuration(self,t)
		local t = rng.tableRemove(tids)
		if not t or #tids<=0 then return end
		target.talents_cd[t.id] = cd
		game.logSeen(target, "#CRIMSON#%s's %s is disrupted by %s wounds!#LAST#", target:getName():capitalize(), t.name, target:his_her())
		self.turn_procs.scoundrel = self.turn_procs.scoundrel or {}
		self.turn_procs.scoundrel[target] = true
	end,
	info = function(self, t)
		local chance = t.getChance(self,t)
		local crit = t.getCritPenalty(self, t)
		local dur = t.getDuration(self,t)
		return ([[Your melee and ranged attacks inflict distracting wounds that reduce the target’s critical strike multiplier by %d%% for 5 turns. 
In addition, your attacks have a %d%% chance to inflict a painful wound that causes them to forget a random talent for %d turns.  The last effect cannot occur more than once per turn per target.
		]]):tformat(crit, chance, dur)
	end,
}

newTalent{
	name = "Misdirection",
	type = {"cunning/scoundrel", 3},
	mode = "passive",
	points = 5,
	require = cuns_req3,
	mode = "passive",
	getDuration = function(self, t) return self:combatTalentLimit(t, 100, 30, 55) end, --limit < 100%
	getChance = function(self, t) return self:combatTalentLimit(t, 50, 10, 35) end, --limit < 100%
	getDefense = function(self, t) return self:combatTalentStatDamage(t, "cun", 15, 60) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_def", t.getDefense(self, t))
	end,
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_CUN then
			self:updateTalentPassives(t)
		end
	end,
	callbackOnTemporaryEffect = function(self, eff, eff_id, e, p)
		if e.status ~= "detrimental" or e.type ~= "physical" or not (p.src and p.src._is_actor) then return end
		local chance = self:callTalent(self.T_MISDIRECTION, "getChance")
		if not rng.percent(chance) then return end
		game.logSeen(self, "#ORANGE#%s redirects the effect '%s'!#LAST#", self:getName():capitalize(), e.desc)
		
		local tgts = {}
		self:project({type="ball", radius=1}, self.x, self.y, function(px, py)
			local act = game.level.map(px, py, Map.ACTOR)
			if not act or self:reactionToward(act) >= 0 then return end
			tgts[#tgts+1] = act
		end)
		if #tgts > 0 then
			local target = rng.table(tgts)
			local newp = table.clone(p, false)
			newp.apply_power = self:combatAttack()
			target:setEffect(eff_id, newp.dur, newp)
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Your abilities in sowing confusion and chaos have reached their peak.  Whenever a foe attempts to apply a detrimental physical effect to you, they have a %d%% chance to fail. If there is an adjacent enemy to you, you misdirect your foe into applying it to them at %d%% duration.
You gain %d defense.
The chance to apply status effects increases with your Accuracy and the Defense with your Cunning.]]):
		tformat(t.getChance(self,t),t.getDuration(self,t), t.getDefense(self, t))
	end,
}

newTalent{
	name = "Fumble",
	type = {"cunning/scoundrel", 4},
	require = cuns_req4,
	mode = "passive",
	points = 5,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "cun", 25, 400) end,
	getStacks = function(self,t) return math.floor(self:combatTalentLimit(t, 20, 3, 15)) end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >=0 then return nil end
		local dam = t.getDamage(self, t)
		local stacks = t.getStacks(self, t)
		target:setEffect(target.EFF_FUMBLE, 5, {power=3, max_power = stacks*3, dam=dam, stacks=1, max_stacks=stacks, src=self })
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted, crit, weapon, ammo, damtype, mult, dam, talent)
		if not (target and hitted and dam > 0) or self:reactionToward(target) >=0 then return nil end
		local dam = t.getDamage(self, t)
		local stacks = t.getStacks(self, t)
		target:setEffect(target.EFF_FUMBLE, 5, {power=3, max_power = stacks*3, dam=dam, stacks=1, max_stacks=stacks, src=self })
	end,
	info = function(self, t)
		local stacks = t.getStacks(self, t)
		local dam = t.getDamage(self, t)
		return ([[Your melee and ranged attacks leave your foes unable to focus on any complex actions, giving them a stacking 3%% chance of failure the next time they try to use a talent (to a maximum of %d%%).
		If any effect causes the target's turn to fail they fumble and injure themself, taking %0.2f physical damage.
		If the turn loss was caused by this effect then Fumble is removed.
		The damage dealt increases with your Cunning.
		]]):tformat(stacks*3, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}