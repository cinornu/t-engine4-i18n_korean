-- ToME - Tales of Middle-Earth
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
	name = "Instill Fear",
	type = {"cursed/fears", 1},
	require = cursed_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	hate = 8,
	range = 8,
	radius = function(self, t) return 2 end,
	tactical = { DISABLE = 2 },
	getDuration = function(self, t)
		return 8
	end,
	getDamage = function(self,t)
		return math.floor(self:combatTalentMindDamage(t, 10, 75))
	end,
	getParanoidAttackChance = function(self, t)
		return math.min(50, self:combatTalentMindDamage(t, 20, 40))
	end,
	getDespairStatChange = function(self, t)
		return -self:combatTalentMindDamage(t, 15, 40)
	end,
	getTerrifiedDamage = function(self,t)
		return math.floor(self:combatTalentMindDamage(t, 5, 20))
	end,
	getTerrifiedPower = function(self,t)
		return math.floor(self:combatTalentMindDamage(t, 25, 60))
	end,
	getHauntedDamage = function(self, t)
		return self:combatTalentMindDamage(t, 10, 30)
	end,
	hasEffect = function(self, t, target)
		if not target then return false end
		if target:hasEffect(target.EFF_PARANOID) then return true end
		if target:hasEffect(target.EFF_DISPAIR) then return true end
		if target:hasEffect(target.EFF_TERRIFIED) then return true end
		if target:hasEffect(target.EFF_HAUNTED) then return true end
		return false
	end,
	applyEffect = function(self, t, target, no_fearRes)

		--tyrant mindpower bonus
		local tTyrant = nil
		if self:knowTalent(self.T_TYRANT) then tTyrant = self:getTalentFromId(self.T_TYRANT) end
		local mindpowerChange = 0

		--mindpower check
		local mindpower = self:combatMindpower()
		if not target:checkHit(mindpower, target:combatMentalResist()) then
			game.logSeen(target, "%s resists the fear!", target:getName():capitalize())
			return nil
		end

		--apply heighten fear
		local tHeightenFear = nil
		if self:knowTalent(self.T_HEIGHTEN_FEAR) then tHeightenFear = self:getTalentFromId(self.T_HEIGHTEN_FEAR) end
		if tHeightenFear and not target:hasEffect(target.EFF_HEIGHTEN_FEAR) then
			local turnsUntilTrigger = tHeightenFear.getTurnsUntilTrigger(self, tHeightenFear)
			local dur = tHeightenFear.getDuration(self, t)
			local damage = tHeightenFear.getDamage(self, t)
			target:setEffect(target.EFF_HEIGHTEN_FEAR, dur, {src=self, range=self:getTalentRange(tHeightenFear), turns=turnsUntilTrigger, turns_left=turnsUntilTrigger, damage=damage })
		end

		--fear res check & heighten fear bypass
		if not no_fearRes and not target:canBe("fear") then
			game.logSeen(target, "#F53CBE#%s resists the fear!", target:getName():capitalize())
			return true
		end

		--build table of possible fears
		local effects = {}
		if not target:hasEffect(target.EFF_PARANOID) then table.insert(effects, target.EFF_PARANOID) end
		if not target:hasEffect(target.EFF_DISPAIR) then table.insert(effects, target.EFF_DISPAIR) end
		if not target:hasEffect(target.EFF_TERRIFIED) then table.insert(effects, target.EFF_TERRIFIED) end
		if not target:hasEffect(target.EFF_HAUNTED) then table.insert(effects, target.EFF_HAUNTED) end

		--choose fear
		if #effects == 0 then return nil end
		local effectId = rng.table(effects)

		--data for fear effects
		local duration = t.getDuration(self, t)
		local eff = {src=self, duration=duration }
		if effectId == target.EFF_PARANOID then
			eff.attackChance = t.getParanoidAttackChance(self, t)
			eff.mindpower = mindpower
		elseif effectId == target.EFF_DISPAIR then
			eff.statChange = t.getDespairStatChange(self, t)
		elseif effectId == target.EFF_TERRIFIED then
			-- Not really ideal to double crit but whatever
			eff.damage = self:mindCrit(t.getTerrifiedDamage(self, t) / 2)
			eff.cooldownPower = t.getTerrifiedPower(self, t) / 100
		elseif effectId == target.EFF_HAUNTED then
			eff.damage = self:mindCrit(t.getHauntedDamage(self, t) / 2)
		else
			print("* fears: failed to get effect", effectId)
		end

		--tyrant stuff
		if tTyrant then
			--tyrant buff data
			eff.tyrantPower = tTyrant.getTyrantPower(self, tTyrant)
			eff.maxStacks = tTyrant.getMaxStacks(self, tTyrant)
			eff.tyrantDur = tTyrant.getTyrantDur(self, tTyrant)
			--extend fear data
			local extendFear = tTyrant.getExtendFear(self, tTyrant)
			local extendChance = tTyrant.getExtendChance(self, tTyrant)
			--roll to extend heighten fear
			if target:hasEffect(target.EFF_HEIGHTEN_FEAR) and rng.percent(extendChance) then
				local HF = target:hasEffect(target.EFF_HEIGHTEN_FEAR)
				HF.dur = math.max(HF.dur, math.min(8, HF.dur + extendFear))
			end
			--build table of active fears and choose one
			local actfear = {}
			if target:hasEffect(target.EFF_PARANOID) then table.insert(actfear, target.EFF_PARANOID) end
			if target:hasEffect(target.EFF_DISPAIR) then table.insert(actfear, target.EFF_DISPAIR) end
			if target:hasEffect(target.EFF_TERRIFIED) then table.insert(actfear, target.EFF_TERRIFIED) end
			if target:hasEffect(target.EFF_HAUNTED) then table.insert(actfear, target.EFF_HAUNTED) end
			local rndFear = rng.table(actfear)
			--roll to extend chosen fear
			if rndFear and rng.percent(extendChance) then
				local F = target:hasEffect(rndFear)
				F.dur = math.max(F.dur, math.min(8, F.dur + extendFear))
			end
		end

		--set fear
		target:setEffect(effectId, duration, eff)

		return effectId
	end,
	endEffect = function(self, t)
		local tHeightenFear = nil
		if self:knowTalent(self.T_HEIGHTEN_FEAR) then tHeightenFear = self:getTalentFromId(self.T_HEIGHTEN_FEAR) end
		if tHeightenFear then
			if not t.hasEffect(self, t) then
				-- no more fears
				self:removeEffect(self.EFF_HEIGHTEN_FEAR)
			end
		end
	end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		self:project(
			tg, x, y,
			function(px, py)
				local actor = game.level.map(px, py, engine.Map.ACTOR)
				if actor and self:reactionToward(actor) < 0 and actor ~= self then
					local damage = self:mindCrit(t.getDamage(self, t) / 2)
					DamageType:get(DamageType.MIND).projector(self, actor.x, actor.y, DamageType.MIND, { dam=damage, crossTierChance=25 })
					DamageType:get(DamageType.DARKNESS).projector(self, actor.x, actor.y, DamageType.DARKNESS, damage)
					local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
					tInstillFear.applyEffect(self, tInstillFear, actor)
				end
			end,
			nil, nil)
		return true
	end,
	info = function(self, t)
		local damInstil = t.getDamage(self, t) / 2
		local damTerri = t.getTerrifiedDamage(self, t) / 2
		local damHaunt = t.getHauntedDamage(self, t) / 2
		return ([[Instill fear in your foes within %d radius of a target location dealing %0.2f mind and %0.2f darkness damage and causing one of 4 possible fears that last for %d turns.
		The targets can save vs your Mindpower to resist the effect.
		Fear effects improve with your Mindpower.

		Possible fears are:
		#ORANGE#Paranoid:#LAST# Gives the target an %d%% chance to physically attack a nearby creature, friend or foe. If hit, their target will be afflicted with Paranoia as well.
		#ORANGE#Despair:#LAST# Reduces mind resist, mindsave, armour and defence by %d.
		#ORANGE#Terrified:#LAST# Deals %0.2f mind and %0.2f darkness damage per turn and increases cooldowns by %d%%.
		#ORANGE#Haunted:#LAST# Causes the target to suffer %0.2f mind and %0.2f darkness damage for each detrimental mental effect every turn.
		]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.MIND, damInstil), damDesc(self, DamageType.DARKNESS, damInstil), t.getDuration(self, t),
		t.getParanoidAttackChance(self, t),
		-t.getDespairStatChange(self, t),
		damDesc(self, DamageType.MIND, damTerri), damDesc(self, DamageType.DARKNESS, damTerri), t.getTerrifiedPower(self, t),
		damDesc(self, DamageType.MIND, damHaunt), damDesc(self, DamageType.DARKNESS, damHaunt)
	)
	end,
}

newTalent{
	name = "Heighten Fear",
	type = {"cursed/fears", 2},
	require = cursed_wil_req2,
	mode = "passive",
	points = 5,
	range = function(self, t)
		return 8
	end,
	getTurnsUntilTrigger = function(self, t)
		return 4
	end,
	getDuration = function(self, t)
		return 5
	end,
	getDamage = function(self,t)
		return math.floor(self:combatTalentMindDamage(t, 5, 50))
	end,
	tactical = { DISABLE = 2 },
	info = function(self, t)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		local range = self:getTalentRange(t)
		local turnsUntilTrigger = t.getTurnsUntilTrigger(self, t)
		local duration = tInstillFear.getDuration(self, tInstillFear)
		local damage = t.getDamage(self, t)
		return ([[Heighten the fears of those near to you. Any foe you attempt to inflict a fear upon and who remains in a radius of %d and in sight of you for %d (non-consecutive) turns, will take %0.2f mind and %0.2f darkness damage and gain a new fear that lasts for %d turns.
			This effect completely ignores fear resistance, but can be saved against.]]):
			tformat(range, turnsUntilTrigger, damDesc(self, DamageType.MIND, t.getDamage(self, t) / 2), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 2 ), duration)
	end,
}

newTalent{
	name = "Tyrant",
	type = {"cursed/fears", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	on_learn = function(self, t)
	end,
	on_unlearn = function(self, t)
	end,
	getTyrantPower = function(self, t) return 2 end,
	getMaxStacks = function(self, t) return math.floor(self:combatTalentScale(t, 7, 20)) end,
	getTyrantDur = function(self, t) return 5 end,
	getExtendFear = function(self, t) return self:combatTalentScale(t, 1, 4) end,
	getExtendChance = function(self, t) return self:combatTalentLimit(t, 60, 20, 50) end,
	info = function(self, t)
		return ([[Impose your tyranny on the minds of those who fear you. When a foe gains a new fear, you have a %d%% chance to increase the duration of their heightened fear and one random existing fear effect by %d turns, to a maximum of 8 turns.
		Additionally, you gain %d Mindpower and Physical power for 5 turns every time you apply a fear, stacking up to %d times.]]):tformat(t. getExtendChance(self, t), t.getExtendFear(self, t), t.getTyrantPower(self, t), t.getMaxStacks(self, t))
	end,
}

newTalent{
	name = "Panic",
	type = {"cursed/fears", 4},
	require = cursed_wil_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 20,
	hate =  1,
	range = 4,
	tactical = { DISABLE = 4 },
	getDuration = function(self, t)
		return 3 + math.floor(math.pow(self:getTalentLevel(t), 0.5) * 2.2)
	end,
	getChance = function(self, t)
		return math.min(50, math.floor(self:combatTalentScale(t, 25, 40)))
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		self:project(
			{type="ball", radius=range}, self.x, self.y,
			function(px, py)
				local actor = game.level.map(px, py, engine.Map.ACTOR)
				if actor and self:reactionToward(actor) < 0 and actor ~= self then
					if not actor:canBe("fear") then
						game.logSeen(actor, "#F53CBE#%s ignores the panic!", actor:getName():capitalize())
					elseif actor:checkHit(self:combatMindpower(), actor:combatMentalResist(), 0, 95) then
						actor:setEffect(actor.EFF_PANICKED, duration, {src=self, range=10, chance=chance, tyrantPower=tyrantPower, maxStacks=maxStacks, tyrantDur=tyrantDur})
					else
						game.logSeen(actor, "#F53CBE#%s resists the panic!", actor:getName():capitalize())
					end
				end
			end,
			nil, nil)
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[Panic your enemies within a range of %d for %d turns. Anyone who fails to make a mental save against your Mindpower has a %d%% chance each turn of trying to run away from you.]]):tformat(range, duration, chance)
	end,
}
