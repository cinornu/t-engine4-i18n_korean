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

-- race & classes
newTalentType{ type="technique/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="spell/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="corruption/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ is_nature=true, type="wild-gift/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ type="psionic/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ type="other/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ type="undead/other", name = _t"other", hide = true, description = _t"Talents of the various entities of the world." }
newTalentType{ type="undead/keepsake", name = _t"keepsake shadow", generic = true, description = _t"Keepsake shadows's innate abilities." }
newTalentType{ is_mind=true, type="cursed/misc", name = _t"misc", description = _t"Talents of the various entities of the world." }

local oldTalent = newTalent
local newTalent = function(t) if type(t.hide) == "nil" then t.hide = true end return oldTalent(t) end

-- Multiply!!!
newTalent{
	name = "Multiply",
	type = {"other/other", 1},
	cooldown = 3,
	range = 10,
	requires_target = true,
	on_pre_use = function(self, t) return self.can_multiply and self.can_multiply > 0 end,
	unlearn_on_clone = true,
	tactical = { ATTACK = function(self, t, aitarget) return 2*(1.2 + self.level/50) end },
	action = function(self, t)

		if not self.can_multiply or self.can_multiply <= 0 then game.logPlayer(self, "You can not multiply anymore.") return nil end

		-- Find a place for the clone
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then print("Multiply: no free space") return nil end

		self.can_multiply = self.can_multiply - 1
		local a = (self.clone_base or self):cloneActor({can_multiply=self.can_multiply-1, exp_worth=0.1})
		mod.class.NPC.castAs(a)

		a:removeTimedEffectsOnClone()
		a:unlearnTalentsOnClone()
		 -- allow chain multiply for now (It's classic!)
		if a.can_multiply > 0 then a:learnTalent(t.id, true, 1) end

		print("[MULTIPLY]", x, y, "::", game.level.map(x,y,Map.ACTOR))
		print("[MULTIPLY]", a.can_multiply, "uids", self.uid,"=>",a.uid, "::", self.player, a.player)
		game.zone:addEntity(game.level, a, "actor", x, y)
		a:check("on_multiply", self)
		a:doFOV()
		return true
	end,
	info = function(self, t)
		return ([[Multiply yourself! (up to %d times)]]):tformat(self.can_multiply or 0)
	end,
}

newTalent{
	short_name = "CRAWL_POISON",
	name = "Poisonous Crawl",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ envelops @target@ with poison.",
	cooldown = 5,
	range = 1,
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[Crawl onto the target, doing %d%% damage and covering it in poison.]]):
		tformat(100*t.getMult(self, t))
	end,
}

newTalent{
	short_name = "CRAWL_ACID",
	name = "Acidic Crawl",
	points = 5,
	type = {"technique/other", 1},
	message = _t"@Source@ envelops @target@ with acid.",
	cooldown = 2,
	range = 1,
	tactical = { ATTACK = { ACID = 2 } },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.ACID, self:combatTalentWeaponDamage(t, 1, 1.8), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[Crawl onto the target, covering it in acid.]]):tformat()
	end,
}

newTalent{
	short_name = "SPORE_BLIND",
	name = "Blinding Spores",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ releases blinding spores at @target@.",
	cooldown = 2,
	range = 1,
	tactical = { DISABLE = { blind = 2 } },
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, DamageType.LIGHT, self:combatTalentWeaponDamage(t, 1, 1.8), true)

		-- Try to blind !
		if hit then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the blinding!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Releases stinging spores at the target, blinding it for %d turns.]]):
		tformat(t.getDuration(self, t))
	end,
}

newTalent{
	short_name = "SPORE_POISON",
	name = "Poisonous Spores",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ releases poisonous spores at @target@.",
	cooldown = 2,
	range = 1,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	requires_target = true,
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[Releases poisonous spores at the target, doing %d%% damage and poisoning it.]]):
		tformat(100 * t.getMult(self, t))
	end,
}

newTalent{
	name = "Stun",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { stun = 2 } },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the stunning blow!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage. If the attack hits, the target is stunned for %d turns.
		The chance to stun improves with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Disarm",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { disarm = 2 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		if hit and target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			target:crossTierEffect(target.EFF_DISARMED, self:combatPhysicalpower())
		else
			game.logSeen(target, "%s resists the blow!", target:getName():capitalize())
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage and trying to disarm the target for %d turns. The chance improves with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Constrict",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = { stun = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 15, 52)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to constrict !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_CONSTRICTED, t.getDuration(self, t), {src=self, power=1.5 * self:getTalentLevel(t), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the constriction!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage. If the attack hits, the target is constricted for %d turns.
		The constriction power improves with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Knockback",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { ATTACK = 1, DISABLE = { knockback = 2 } },
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1.5, 2), true)

		-- Try to knockback !
		if hit then
			if target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then
				target:knockback(self.x, self.y, 4)
				target:crossTierEffect(target.EFF_OFFBALANCE, self:combatPhysicalpower())
			else
				game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target with your weapon doing %d%% damage. If the attack hits, the target is knocked back up to 4 grids.  The chance improves with your Physical Power.]]):tformat(100 * self:combatTalentWeaponDamage(t, 1.5, 2))
	end,
}

newTalent{
	short_name = "BITE_POISON",
	name = "Poisonous Bite",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ bites poison into @target@.",
	cooldown = 5,
	range = 1,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	requires_target = true,
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true, true)
		return true
	end,
	info = function(self, t)
		return ([[Bites the target (an unarmed attack), doing %d%% damage and injecting it with poison.]]):tformat(100 * t.getMult(self, t))
	end,
}

newTalent{
	name = "Summon",
	type = {"wild-gift/other", 1},
	cooldown = 1,
	range = 10,
	equilibrium = 18,
	direct_hit = true,
	requires_target = true,
	tactical = { ATTACK = 2 },
	is_summon = true,
	unlearn_on_clone = true,
	action = function(self, t)
		if not self:canBe("summon") then game.logPlayer(self, "You cannot summon; you are suppressed!") return end

		local filters = self.summon or {{type=self.type, subtype=self.subtype, number=1, hasxp=true, lastfor=20}}
		if #filters == 0 then return end
		local filter = rng.table(filters)

		-- Apply summon destabilization
		if self:getTalentLevel(t) < 5 then self:setEffect(self.EFF_SUMMON_DESTABILIZATION, 500, {power=5}) end

		local num_summon = 0
		for i = 1, filter.number do
			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 10, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				break
			end

			-- Find an actor with that filter
			filter = table.clone(filter)
			filter.max_ood = filter.max_ood or 2
			local m = game.zone:makeEntity(game.level, "actor", filter, nil, true)
			if m then
				if not filter.hasxp then m.exp_worth = 0 end
				m:resolve()

				if not filter.no_summoner_set then
					m.summoner = self
					m.summon_time = filter.lastfor
				end
				if not m.hard_faction then m.faction = self.faction end

				if filter.no_subescort then m.make_escort = nil end
				if not filter.hasloot then m:forgetInven(m.INVEN_INVEN) end

				game.zone:addEntity(game.level, m, "actor", x, y)
				num_summon = num_summon + 1

				self:logCombat(m, "#Source# summons #Target#!")

				-- Apply summon destabilization
				if self:hasEffect(self.EFF_SUMMON_DESTABILIZATION) then
					m:setEffect(m.EFF_SUMMON_DESTABILIZATION, 500, {power=self:hasEffect(self.EFF_SUMMON_DESTABILIZATION).power})
				end

				-- Learn about summoners
				if game.level.map.seens(self.x, self.y) then
					game:setAllowedBuild("wilder_summoner", true)
				end
			end
		end
		return num_summon > 0
	end,
	info = function(self, t)
		return ([[Summon allies.]]):tformat()
	end,
}

newTalent{
	name = "Rotting Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = _t"@Source@ performs a diseased attack against @target@.",
	requires_target = true,
	tactical = { ATTACK = { weapon=1, BLIGHT = { disease = 2 } }, DISABLE = { disease = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatStatScale("str", 6, 33, 0.75) + self:getTalentLevel(t)*2 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to rot !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_ROTTING_DISEASE, t.getDuration(self, t), {src=self, dam=t.getDamage(self, t), con=math.floor(4 + target:getCon() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage. If the attack hits, the target is afflicted with a disease, inflicting %0.2f blight damage per turn for %d turns and reducing constitution by 10%% + 4.  The disease damage increases with your Strength, and the chance to apply it increases with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Decrepitude Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = _t"@Source@ performs a diseased attack against @target@.",
	tactical = { ATTACK = { weapon=1, BLIGHT = { disease = 2 } }, DISABLE = { disease = 1 } },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatStatScale("str", 6, 33, 0.75) + self:getTalentLevel(t)*2 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to decrepitate !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_DECREPITUDE_DISEASE, t.getDuration(self, t), {src=self, dam=t.getDamage(self, t), dex=math.floor(4 + target:getDex() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage. If the attack hits, the target is afflicted with a disease, inflicting %0.2f blight damage per turn for %d turns and reducing dexterity by 10%% + 4.  The disease damage increases with your Strength, and the chance to apply it increases with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Weakness Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = _t"@Source@ performs a diseased attack against @target@.",
	requires_target = true,
	tactical = { ATTACK = { weapon=1, BLIGHT = { disease = 2 } }, DISABLE = { disease = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatStatScale("str", 6, 33, 0.75) + self:getTalentLevel(t)*2 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to weaken !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_WEAKNESS_DISEASE, t.getDuration(self, t), {src=self, dam=t.getDamage(self, t), str=math.floor(4 + target:getStr() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage. If the attack hits, the target is afflicted with a disease, inflicting %0.2f blight damage per turn for %d turns and reducing strength by 10%% + 4.  The disease damage increases with your Strength, and the chance to apply it increases with your Physical Power.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Mind Disruption",
	type = {"spell/other", 1},
	points = 5,
	cooldown = 10,
	mana = 16,
	range = 10,
	direct_hit = true,
	requires_target = true,
	tactical = { DISABLE = { confusion = 3 } },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getConfusion = function(self, t) return self:combatTalentLimit(t, 50, 15, 45) end, -- Confusion hard cap is 50%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.CONFUSION, {dur=t.getDuration(self, t), dam=t.getConfusion(self,t)}, {type="manathrust"})
		return true
	end,
	info = function(self, t)
		return ([[Try to confuse the target's mind for %d (power %d%%) turns.]]):tformat(t.getDuration(self, t), t.getConfusion(self, t))
	end,
}

newTalent{
	name = "Water Bolt",
	type = {"spell/other", },
	points = 5,
	mana = 10,
	cooldown = 3,
	range = 10,
	reflectable = true,
	tactical = { ATTACK = { COLD = 1 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 12, 0, 78.25, 265, 0.67) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.COLD, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[Condenses ambient water on a target, inflicting %0.1f cold damage.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

-- Crystal Flame replacement
newTalent{
	name = "Flame Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_fire", trail="firetrail"}}
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 180) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = nil

			self:projectile(tg, x, y, DamageType.FIREBURN, self:spellCrit(t.getDamage(self, t)), function(self, tg, x, y, grids)
				game.level.map:particleEmitter(x, y, 1, "flame")
				if self:attr("burning_wake") then
					game.level.map:addEffect(self, x, y, 4, engine.DamageType.INFERNO, self:attr("burning_wake"), 0, 5, nil, {type="inferno"}, nil, self:spellFriendlyFire())
				end
			end)

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Conjures up a bolt of fire, setting the target ablaze and doing %0.2f fire damage over 3 turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.FIRE, damage))
	end,
}

-- Crystal Ice Shards replacement
-- Very slow, moderate damage, freezes
newTalent{
	name = "Ice Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 6,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 140) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = self:project(tg, x, y, function(px, py)
			local actor = game.level.map(px, py, Map.ACTOR)
			if actor and actor ~= self then
				local tg2 = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="arrow", particle_args={tile="particles_images/ice_shards"}}}
				self:projectile(tg2, px, py, DamageType.ICE, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
			end
		end)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Hurl ice shard at the target dealing %0.2f ice damage.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD, damage))
	end,
}

-- Crystal Soul Rot replacement
-- Slower projectile, higher damage, crit bonus
newTalent{
	name = "Blight Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { BLIGHT = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 10,
	requires_target = true,
	getCritChance = function(self, t) return self:combatTalentScale(t, 7, 25, 0.75) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 140) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.BLIGHT, self:spellCrit(self:combatTalentSpellDamage(t, 1, 140), t.getCritChance(self, t)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Projects a bolt of pure blight, doing %0.2f blight damage.
		This spell has an improved critical strike chance of +%0.2f%%.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 1, 180)), t.getCritChance(self, t))
	end,
}

newTalent{
	name = "Water Jet",
	type = {"spell/other", },
	points = 5,
	mana = 10,
	cooldown = 8,
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	tactical = { DISABLE = { stun = 2 }, ATTACK = { COLD = 1 } },
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 12, 0, 65, 265, 0.67) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.COLDSTUN, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[Condenses ambient water on a target, inflicting %0.1f cold damage and stunning it for 4 turns.
		The damage will increase with your Spellpower]]):
		tformat(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Void Blast",
	type = {"spell/other", },
	points = 5,
	mana = 3,
	cooldown = 2,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = 10,
	reflectable = true,
	requires_target = true,
	proj_speed = 20,
	target = function(self, t) return {type="beam", range=self:getTalentRange(t), talent=t, selffire=false, display={particle="bolt_void", trail="voidtrail"}} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.VOID_BLAST, self:spellCrit(self:combatTalentSpellDamage(t, 15, 240)), {type="voidblast"})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Fires a blast of void energies that slowly travel to their target, dealing %0.2f arcane damage on impact.
		The damage will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.ARCANE, self:combatTalentSpellDamage(t, 15, 240)))
	end,
}

newTalent{
	name = "Restoration",
	type = {"spell/other", 1},
	points = 5,
	mana = 30,
	cooldown = 15,
	tactical = { CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.poison or e.subtype.disease then nb = nb + 1 end
		end
		return nb
	end },
	getCureCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local target = self
		local effs = {}

		-- Go through all spell effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.poison or e.subtype.disease then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getCureCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local curecount = t.getCureCount(self, t)
		return ([[Call upon the forces of nature to cure your body of %d poisons and diseases.]]):
		tformat(curecount)
	end,
}

newTalent{
	name = "Regeneration",
	type = {"spell/other", 1},
	points = 5,
	mana = 30,
	cooldown = 10,
	tactical = { HEAL = 2 },
	getRegeneration = function(self, t) return 5 + self:combatTalentSpellDamage(t, 5, 25) end,
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	action = function(self, t)
		self:setEffect(self.EFF_REGENERATION, 10, {power=t.getRegeneration(self, t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local regen = t.getRegeneration(self, t)
		return ([[Call upon the forces of nature to regenerate your body for %d life every turn for 10 turns.
		The life healed increases with Spellpower.]]):
		tformat(regen)
	end,
}

newTalent{
	name = "Grab",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { DISABLE = { pin = 1 }, ATTACK = { weapon = 2 } },
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.8, 1.4), true)

		-- Try to pin !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the grab!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target doing %d%% damage; if the attack hits, the target is pinned to the ground for %d turns.  The chance to pin improves with Physical Power.]]):tformat(100 * self:combatTalentWeaponDamage(t, 0.8, 1.4), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Blinding Ink",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 12,
	cooldown = 12,
	message = _t"@Source@ projects ink!",
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRadius(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	tactical = { DISABLE = { blind = 2 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLINDING_INK, t.getDuration(self, t))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_dark", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[You project thick black ink, blinding targets in a radius %d cone for %d turns.  The chance to blind improves with Physical Power.]]):tformat(t.radius(self, t), duration)
	end,
}

newTalent{
	name = "Spit Poison",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t)} end,
	getDamage = function(self, t)
		return self:combatScale(math.max(self:getStr(), self:getDex())*self:getTalentLevel(t), 20, 0, 420, 500)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local s = math.max(self:getDex(), self:getStr())
		self:project(tg, x, y, DamageType.POISON, t.getDamage(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Spit poison at your target, doing %0.2f poison damage over six turns.
		The damage will increase with your Strength or Dexterity (whichever is higher).]]):
		tformat(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}


newTalent{
	name = "Poison Strike",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 400) end,
	is_mind = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.POISON, t.getDamage(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Strike your target with poison, doing %0.2f poison damage over six turns.
		The damage will increase with your mindpower.]]):
		tformat(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}

newTalent{
	name = "Spit Blight",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { BLIGHT = 2 } },
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t)} end,
	getDamage = function(self, t)
		return self:combatScale(self:getMag()*self:getTalentLevel(t), 20, 0, 420, 500)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLIGHT, t.getDamage(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Spit blight at your target doing %0.2f blight damage.
		The damage will increase with your Magic.]]):tformat(t.getDamage(self,t))
	end,
}

newTalent{
	name = "Rushing Claws",
	type = {"wild-gift/other", 1},
	message = _t"@Source@ rushes out, claws sharp and ready!",
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	tactical = { DISABLE = 2, CLOSEIN = 3 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "You cannot do that currently.") return end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		local tx, ty = self.x, self.y
		while lx and ly do
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) == 1 and target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, 5, {})
		end

		return true
	end,
	info = function(self, t)
		return ([[Rushes toward your target with incredible speed. If the target is reached, you use your claws to pin it to the ground for 5 turns.
		You must rush from at least 2 tiles away.]]):tformat()
	end,
}

newTalent{
	name = "Throw Bones",
	type = {"undead/other", 1},
	points = 5,
	cooldown = 6,
	range = 10,
	radius = 2,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	getDamage = function(self, t) return self:combatScale(self:getStr()*self:getTalentLevel(t), 20, 0, 420, 500) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLEED, t.getDamage(self, t), {type="archery"})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		return ([[Throws a pack of bones at your target doing %0.2f physical damage as bleeding within radius %d.
		The damage will increase with the Strength stat]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Lay Web",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	message = _t"@Source@ seems to search the ground...",
	range = 10,
	requires_target = true,
	tactical = { DISABLE = { pin = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDetect = function(self, t) return self:combatTalentScale(t, 10, 30) end,
	getDisarm = function(self, t) return self:combatTalentScale(t, 15, 35) end,
	action = function(self, t)
		local dur = t.getDuration(self,t)
		local trap = mod.class.Trap.new{
			type = "web", subtype="web", id_by_type=true, unided_name = _t"sticky web",
			display = '^', color=colors.YELLOW, image = "trap/trap_spiderweb_01_64.png",
			name = _t"sticky web", auto_id = true,
			detect_power = t.getDetect(self, t),
			disarm_power = t.getDisarm(self, t),
			level_range = {self.level, self.level},
			message = _t"@Target@ is caught in a web!",
			pin_dur = dur,
			temporary = dur * 5,
			summoner = self,
			faction = false,
			canAct = false,
			energy = {value=0},
			x=self.x,
			y=self.y,
			desc = function(self)
				return ("Pins non spiderkin for %d turns. Decays over time."):tformat(self.pin_dur)
			end,
			canTrigger = function(self, x, y, who)
				if who.type == "spiderkin" then return false end
				return mod.class.Trap.canTrigger(self, x, y, who)
			end,
			act = function(self)
				self:useEnergy()
				local weaken = self.temporary/(self.temporary + 1)
				self.pin_dur = self.pin_dur*weaken
				self.detect_power = self.detect_power*weaken
				self.disarm_power = self.disarm_power*weaken
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then
						game.level.map:remove(self.x, self.y, engine.Map.TRAP)
					end
					game.level:removeEntity(self)
				end
			end,
			triggered = function(self, x, y, who)
				if who:canBe("stun") and who:canBe("pin") then
					who:setEffect(who.EFF_PINNED, math.ceil(self.pin_dur), {apply_power=self.disarm_power + 5})
				else
					game.logSeen(who, "%s resists!", who:getName():capitalize())
				end
				return true, true
			end
			}
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", self.x, self.y)
		trap:setKnown(self, true)
		return true
	end,
	info = function(self, t)
		local dur = t.getDuration(self, t)
		return ([[Lay a concealed web (%d detect 'power', %d disarm 'power') under yourself that lasts %d turns and pins all non-spiderkin that pass through it for %d turns.  The web weakens over time.]]):
		tformat(t.getDetect(self, t), t.getDisarm(self, t), dur*5, dur)
	end,
}

newTalent{
	name = "Darkness",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.7, 5.3)) end,
	direct_hit = true,
	tactical = { DISABLE = 3 },
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	darkPower = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local g = engine.Entity.new{name="darkness", show_tooltip=true, block_sight=true, always_remember=false, unlit=t.darkPower(self, t)}
			game.level.map(px, py, Map.TERRAIN+1, g)
			game.level.map.remembers(px, py, false)
			game.level.map.lites(px, py, false)
		end, nil, {type="dark"})
		self:teleportRandom(self.x, self.y, 5)
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[Weave darkness (power %d) in a radius of %d, blocking all light but the most powerful and teleporting you a short range.]]):
		tformat(t.darkPower(self, t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Throw Boulder",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 3,
	range = 10,
	radius = 1,
	direct_hit = true,
	tactical = { DISABLE = { knockback = 3 }, ATTACKAREA = {PHYSICAL = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDam = function(self, t) return self:combatScale(self:getStr() * self:getTalentLevel(t), 12, 0, 262, 500) end,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local target = game.level.map(x, y, engine.Map.ACTOR) or self.ai_target.actor or {name=_t"something"}
		self:logCombat(target, "#Source# hurls a huge boulder at #target#!")
		self:project(tg, x, y, DamageType.PHYSKNOCKBACK, {dist=t.getDist(self, t), dam=self:mindCrit(t.getDam(self, t))}, {type="archery"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[Throw a huge boulder, dealing %0.2f physical damage and knocking targets back %d tiles within radius %d.
		The damage will increase with your Strength.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Howl",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 10,
	message = _t"@Source@ howls",
	range = 10,
	tactical = { ATTACK = 3 },
	direct_hit = true,
	no_difficulty_boost = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		game:playSoundNear(self, "creatures/wolves/wolf_howl_3")
		for i = self.x - rad, self.x + rad do for j = self.y - rad, self.y + rad do if game.level.map:isBound(i, j) then
			local actor = game.level.map(i, j, game.level.map.ACTOR)
			if actor and not actor.player then
				if self:reactionToward(actor) >= 0 then
					local tx, ty, a = self:getTarget()
					if a then
						actor:setTarget(a)
					end
				else
					actor:setTarget(self)
				end
			end
		end end end
		return true
	end,
	info = function(self, t)
		return ([[Howl (radius %d) to call your hunting pack.]]):
		tformat(self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Shriek",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 10,
	message = _t"@Source@ shrieks.",
	range = 10,
	direct_hit = true,
	no_difficulty_boost = true,
	tactical = { ATTACK = 3 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		game:playSoundNear(self, "creatures/swarm/mswarm_4")
		for i = self.x - rad, self.x + rad do for j = self.y - rad, self.y + rad do if game.level.map:isBound(i, j) then
			local actor = game.level.map(i, j, game.level.map.ACTOR)
			if actor and not actor.player then
				if self:reactionToward(actor) >= 0 then
					local tx, ty, a = self:getTarget()
					if a then
						actor:setTarget(a)
					end
				else
					actor:setTarget(self)
				end
			end
		end end end
		return true
	end,
	info = function(self, t)
		return ([[Shriek (radius %d) to call your allies.]]):
		tformat(self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Crush",
	type = {"technique/other", 1},
	require = techs_req1,
	points = 5,
	cooldown = 6,
	stamina = 12,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { pin = 1 } },
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Crush without a two-handed weapon!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1, 1.4))

		-- Try to pin !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the crushing!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target with a mighty blow to the legs doing %d%% weapon damage. If the attack hits, the target is unable to move for %d turns.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 1, 1.4), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Silence",
	type = {"psionic/other", 1},
	points = 5,
	cooldown = 10,
	psi = 5,
	range = 7,
	direct_hit = true,
	requires_target = true,
	tactical = { DISABLE = { silence = 3 } },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SILENCE, {dur=t.getDuration(self, t)}, {type="mind"})
		return true
	end,
	info = function(self, t)
		return ([[Sends a telepathic attack, silencing the target for %d turns.  The chance to silence improves with Mindpower.]]):
		tformat(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Telekinetic Blast",
	type = {"wild-gift/other", 1},
	points = 5,
	cooldown = 2,
	equilibrium = 5,
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	tactical = { ATTACK = { PHYSICAL = 2 }, ESCAPE = { knockback = 2 } },
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 170) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(t.getDamage(self, t)), {type="mind"})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[Sends a telekinetic attack, knocking back the target up to 3 grids and doing %0.2f physical damage.
		The damage will increase with Mindpower.]]):tformat(self:damDesc(engine.DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Blightzone",
	type = {"corruption/other", 1},
	points = 5,
	cooldown = 13,
	vim = 27,
	range = 10,
	radius = 4,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACKAREA = { BLIGHT = 2 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = self:combatTalentSpellDamage(t, 4, 65)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, duration,
			DamageType.BLIGHT, dam,
			self:getTalentRadius(t),
			5, nil,
			{type="blightzone"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		return ([[Corrupted vapour rises at the target location (radius 4) doing %0.2f blight damage every turn for %d turns.
		The damage increases with Spellpower.]]):
		tformat(damDesc(self, engine.DamageType.BLIGHT, self:combatTalentSpellDamage(t, 5, 65)), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Invoke Tentacle",
	type = {"wild-gift/other", 1},
	cooldown = 1,
	range = 10,
	direct_hit = true,
	tactical = { ATTACK = 3 },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, nolock=true}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		if not tx or not ty then return nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 3, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		-- Find an actor with that filter
		local list = mod.class.NPC:loadList("/data/general/npcs/horror.lua")
		local m = list and list.GRGGLCK_TENTACLE and list.GRGGLCK_TENTACLE:clone()
		if m then
			m.exp_worth = 0
			m:resolve()
			m:resolve(nil, true)

			m.summoner = self
			m.summon_time = 10
			if not self.is_grgglck then
				m.ai_real = m.ai
				m.ai = "summoned"
			end

			game.zone:addEntity(game.level, m, "actor", x, y)

			if self.is_grgglck then
				game.logSeen(self, "%s spawns one of its tentacles!", self:getName():capitalize())
			else
				m.name = ("%s's summoned tentacle"):tformat(self:getName())
				m.desc = _t"Ewwww.."
				game.logSeen(self, "%s spawns a tentacle!", self:getName():capitalize())
			end
		else return
		end

		return true
	end,
	info = function(self, t)
		return ([[Invoke a tentacle to assault your foes.  If the tentacle is killed, you will lose life equal to 2/3 of it's maximum life.]]):tformat()
	end,
}

newTalent{
	name = "Explode",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ explodes! @target@ is enveloped in searing light.",
	cooldown = 1,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { LIGHT = 1 } },
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 0, 0, 66.25 , 265, 0.67) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not self:canProject(tg, x, y) then return nil end
		self:project(tg, x, y, DamageType.LIGHT, t.getDamage(self, t), {type="light"})
		game.level.map:particleEmitter(self.x, self.y, 1, "ball_fire", {radius = 1, r = 1, g = 0, b = 0})
		self:die(self)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Causes the user to explode (killing it) in a blinding flash for %0.2f light damage.]]):
		tformat(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Will o' the Wisp Explode",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ explodes! @target@ is enveloped in frost.",
	cooldown = 1,
	range = 1,
	requires_target = true,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = { COLD = 1 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not self:canProject(tg, x, y) then return nil end
		self:project(tg, x, y, DamageType.COLD, self.will_o_wisp_dam or 1)
		game.level.map:particleEmitter(self.x, self.y, 1, "ball_ice", {radius = 1, r = 1, g = 0, b = 0})
		self:die(self)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[Explode against one target for %0.2f cold damage.]]):tformat(damDesc(self, DamageType.COLD, self.will_o_wisp_dam or 1))
	end,
}

newTalent{
	name = "Elemental Bolt",
	type = {"spell/other", 1},
	points = 5,
	mana = 10,
	message = _t"@Source@ casts Elemental Bolt!",
	cooldown = 3,
	range = 20,
	proj_speed = 2,
	requires_target = true,
	tactical = { ATTACK = 2 },
	target = function(self, t) return {type = "bolt", range = self:getTalentRange(t), talent = t} end,
	getDamage = function(self, t) return self:combatScale(self:getMag() * self:getTalentLevel(t), 0, 0, 450, 500) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
			local elem = rng.table{
				{DamageType.ACID, "acid"},
				{DamageType.FIRE, "flame"},
				{DamageType.COLD, "freeze"},
				{DamageType.LIGHTNING, "lightning_explosion"},
				{DamageType.NATURE, "slime"},
				{DamageType.BLIGHT, "blood"},
				{DamageType.LIGHT, "light"},
				{DamageType.ARCANE, "manathrust"},
				{DamageType.DARKNESS, "dark"},
			}
		tg.display={particle="bolt_elemental", trail="generictrail"}
		self:projectile(tg, x, y, elem[1], t.getDamage(self, t), {type=elem[2]})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Fire a slow bolt of a random element for %d damage. Damage increases with the magic stat.]]):
		tformat(t.getDamage(self, t))
	end,
}

newTalent{
	name = "Volcano",
	type = {"spell/other", 1},
	points = 5,
	mana = 10,
	message = _t"A volcano erupts!",
	cooldown = 20,
	range = 10,
	proj_speed = 2,
	requires_target = true,
	tactical = { ATTACK = { FIRE = 1, PHYSICAL = 1 } },
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), nolock=true, talent=t} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	nbProj = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 80) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end

		local oe = game.level.map(x, y, Map.TERRAIN)
		if not oe or oe:attr("temporary") then return end

		local e = Object.new{
			old_feat = oe,
			type = rawget(oe, "type"), subtype = oe.subtype,
			name = _t"raging volcano", image = oe.image, add_mos = {{image = "terrain/lava/volcano_01.png"}},
			display = '&', color=colors.LIGHT_RED, back_color=colors.RED,
			always_remember = true,
			temporary = t.getDuration(self, t),
			x = x, y = y,
			canAct = false,
			nb_projs = t.nbProj(self, t),
			dam = t.getDamage(self, t),
			act = function(self)
				local tgts = {}
				local grids = core.fov.circle_grids(self.x, self.y, 5, true)
				for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
					local a = game.level.map(x, y, engine.Map.ACTOR)
					if a and self.summoner:reactionToward(a) < 0 then tgts[#tgts+1] = a end
				end end

				-- Randomly take targets
				local tg = {type="bolt", range=5, x=self.x, y=self.y, talent=self.summoner:getTalentFromId(self.summoner.T_VOLCANO), display={image="object/lava_boulder.png"}}
				for i = 1, self.nb_projs do
					if #tgts <= 0 then break end
					local a, id = rng.table(tgts)
					table.remove(tgts, id)

					self.summoner:projectile(tg, a.x, a.y, engine.DamageType.MOLTENROCK, self.dam, {type="flame"})
					game:playSoundNear(self, "talents/fire")
				end

				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
					game.level:removeEntity(self)
					game.level.map:updateMap(self.x, self.y)
					game.nicer_tiles:updateAround(game.level, self.x, self.y)
				end
			end,
			summoner_gain_exp = true,
			summoner = self,
		}
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN, e)
		game.nicer_tiles:updateAround(game.level, x, y)
		game.level.map:updateMap(x, y)
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[Summons a small raging volcano for %d turns. Every turn, it will fire a molten boulder towards up to %d of your foes, dealing %0.2f fire and %0.2f physical damage.
		The damage will scale with your Spellpower.]]):
		tformat(t.getDuration(self, t), t.nbProj(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,
}

newTalent{
	name = "Speed Sap",
	type = {"chronomancy/other", 1},
	points = 5,
	paradox = function (self, t) return getParadoxCost(self, t, 10) end,
	cooldown = 8,
	tactical = {
		ATTACK = { TEMPORAL = 1 },
		DISABLE = 2,
		BUFF = 2,
	},
	range = 3,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220, getParadoxSpellpower(self, t)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.WASTING, self:spellCrit(t.getDamage(self, t)))
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SLOW, 3, {power=0.3})
			self:setEffect(self.EFF_SPEED, 3, {power=0.3})
		end
		local _ _, x, y = self:canProject(tg, x, y)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Saps 30%% of the target's speed (increasing yours by the same amount) and inflicts %0.2f temporal damage for three turns.
		]]):tformat(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

newTalent{
	name = "Dredge Frenzy",
	type = {"chronomancy/other", 1},
	points = 5,
	cooldown = 12,
	tactical = {
		BUFF = 4,
	},
	direct_hit = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=true, talent=t}
	end,
	getPower = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 50), 1, 0, 0, 0.329, 32.9) end, -- Limit < 100
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			local reapplied = false
			if target then
				local actor_frenzy = false
				if target.dredge then
					actor_frenzy = true
				end
				if actor_frenzy then
					-- silence the apply message if the target already has the effect
					for eff_id, p in pairs(target.tmp) do
						local e = target.tempeffect_def[eff_id]
						if e.name == "Frenzy" then
							reapplied = true
						end
					end
					target:setEffect(target.EFF_FRENZY, t.getDuration(self, t), {crit = t.getPower(self, t)*100, power=t.getPower(self, t), dieat=t.getPower(self, t)}, reapplied)
				end
			end
		end)

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_light", {radius=tg.radius})
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		local range = t.radius(self,t)
		local power = t.getPower(self,t) * 100
		return ([[Sends Dredges in a radius of %d into a frenzy for %d turns.
		The frenzy will increase global speed by %d%%, physical crit chance by %d%%, and prevent death until -%d%% life.]]):
		tformat(range, t.getDuration(self, t), power, power, power)
	end,
}

newTalent{
	name = "Sever Lifeline",
	type = {"chronomancy/other", 1},
	points = 5,
	paradox = function (self, t) return getParadoxCost(self, t, 1) end,
	cooldown = 20,
	tactical = {ATTACK = 5},
	range = 10,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220, getParadoxSpellpower(self, t)) * 10000 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		target:setEffect(target.EFF_SEVER_LIFELINE, 4, {src=self, power=t.getDamage(self, t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Start to sever the lifeline of the target. After 4 turns, if the target is still in line of sight of you, its existance will be ended (%d temporal damage).]]):tformat(damDesc(self, "TEMPORAL", t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Call of Amakthel",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 2,
	tactical = { DISABLE = 2 },
	range = 0,
	radius = function(self, t)
		return 10
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tgts = {}
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if self:reactionToward(target) < 0 and not tgts[target] then
				tgts[target] = true
				local ox, oy = target.x, target.y
				target:pull(self.x, self.y, 1)
				if target.x ~= ox or target.y ~= oy then game.logSeen(target, "%s is pulled in!", target:getName():capitalize()) end
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[Pull all foes within radius 10 1 grid towards you.]]):tformat()
	end,
}

newTalent{
	name = "Gift of Amakthel",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	tactical = { ATTACK = 2 },
	range = 10,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self.x, self.y
		if not tx or not ty then return nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 3, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		-- Find an actor with that filter
		local m = game.zone:makeEntityByName(game.level, "actor", "SLIMY_CRAWLER")
		if m then
			m.exp_worth = 0
			m.summoner = self
			m.summon_time = 10
			game.zone:addEntity(game.level, m, "actor", x, y)
			local target = game.level.map(tx, ty, Map.ACTOR)
			m:setTarget(target)

			game.logSeen(self, "%s spawns a slimy crawler!", self:getName():capitalize())
		else return
		end

		return true
	end,
	info = function(self, t)
		return ([[Invoke a slimy crawler for 10 turns.]]):tformat()
	end,
}

newTalent{
	short_name = "STRIKE",
	name = "Strike",
	type = {"spell/other", 1},
	points = 5,
	random_ego = "attack",
	mana = 18,
	cooldown = 6,
	tactical = {
		ATTACK = { PHYSICAL = 1 },
		DISABLE = { knockback = 2 },
		ESCAPE = { knockback = 2 },
	},
	range = 10,
	reflectable = true,
	proj_speed = 6,
	requires_target = true,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_earth", trail="earthtrail"}} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 8, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.SPELLKNOCKBACK, self:spellCrit(t.getDamage(self, t)))
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Conjures up a fist of stone, doing %0.2f physical damage and knocking the target back 3 grids.
		The damage will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

newTalent{
	name = "Corrosive Vapour",
	type = {"spell/other",1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 20,
	cooldown = 8,
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 8,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.ACID, t.getDamage(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="vapour"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Corrosive fumes rise from the ground doing %0.2f acid damage in a radius of 3 each turn for %d turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.ACID, damage), duration)
	end,
}

newTalent{
	name = "Manaflow",
	type = {"spell/other", 1},
	points = 5,
	mana = 0,
	cooldown = 25,
	tactical = { MANA = 3 },
	getManaRestoration = function(self, t) return 5 + self:combatTalentSpellDamage(t, 10, 20) end,
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_MANASURGE) end,
	action = function(self, t)
		self:setEffect(self.EFF_MANASURGE, 10, {power=t.getManaRestoration(self, t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local restoration = t.getManaRestoration(self, t)
		return ([[Engulf yourself in a surge of mana, quickly restoring %d mana every turn for 10 turns.
		The mana restored will increase with your Spellpower.]]):
		tformat(restoration)
	end,
}
newTalent{
	name = "Infernal Breath", image = "talents/flame_of_urh_rok.png",
	type = {"spell/other",1},
	random_ego = "attack",
	cooldown = 20,
	tactical = { ATTACKAREA = function(self, t, aitarget)
			return not aitarget:attr("demon") and { FIRE = 2 } or nil
		end,
		HEAL = function(self, t, aitarget)
			return self:attr("demon") and 1 or nil
		end },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "str", 30, 350) end,
	getBurnDamage = function(self, t) return self:combatTalentStatDamage(t, "str", 30, 70) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DEMONFIRE, self:spellCrit(t.getDamage(self, t)))

		game.level.map:addEffect(self,
				self.x, self.y, 4,
				DamageType.DEMONFIRE, self:spellCrit(t.getBurnDamage(self, t)),
				tg.radius,
				{delta_x=x-self.x, delta_y=y-self.y}, 55,
				{type="dark_inferno"},
				nil, true
		)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breathe")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Exhale a wave of dark fire with radius %d. Any non demon caught in the area will take %0.2f fire damage, and flames will be left dealing a further %0.2f each turn. Demons will be healed for the same amount.
		The damage will increase with your Strength Stat.]]):
		tformat(radius, damDesc(self, DamageType.FIRE, t.getDamage(self, t)), damDesc(self, DamageType.FIRE, t.getBurnDamage(self, t)))
	end,
}

newTalent{
	name = "Frost Hands", image = "talents/shock_hands.png",
	type = {"spell/other", 3},
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_mana = 40,
	tactical = { BUFF = 2 },
	getIceDamage = function(self, t) return self:combatTalentSpellDamage(t, 3, 20) end,
	getIceDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 5, 14) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/ice")
		return {
			dam = self:addTemporaryValue("melee_project", {[DamageType.ICE] = t.getIceDamage(self, t)}),
			per = self:addTemporaryValue("inc_damage", {[DamageType.COLD] = t.getIceDamageIncrease(self, t)}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("melee_project", p.dam)
		self:removeTemporaryValue("inc_damage", p.per)
		return true
	end,
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[Engulfs your hands (and weapons) in a sheath of frost, dealing %0.2f cold damage per melee attack and increasing all cold damage by %d%%.
		The effects will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

newTalent{
	name = "Meteor Rain",
	type = {"spell/other", 3},
	points = 5,
	cooldown = 30,
	mana = 70,
	tactical = { ATTACKAREA = { FIRE=2, PHYSICAL=2 } },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 250) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 3.3, 4.8, "log")) end,
	radius = 2,
	range = 5,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local terrains = t.terrains or mod.class.Grid:loadList("/data/general/grids/lava.lua")
		t.terrains = terrains -- cache

		local meteor = function(src, x, y, dam)
			game.level.map:particleEmitter(x, y, 10, "meteor", {x=x, y=y})
			game.level.map:particleEmitter(x, y, 10, "fireflash", {radius=2})
			game:playSoundNear(game.player, "talents/fireflash")

			local grids = {}
			for i = x-1, x+1 do for j = y-1, y+1 do
				local oe = game.level.map(i, j, Map.TERRAIN)
				if oe and not oe:attr("temporary") and
				(core.fov.distance(x, y, i, j) < 1 or rng.percent(40)) and (game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "dig") or game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "grow")) then
					local g = terrains.LAVA_FLOOR:clone()
					g:resolve() g:resolve(nil, true)
					game.zone:addEntity(game.level, g, "terrain", i, j)
					grids[#grids+1] = {x=i,y=j,oe=oe}
				end
			end end
			for i = x-1, x+1 do for j = y-1, y+1 do
				game.nicer_tiles:updateAround(game.level, i, j)
			end end
			for _, spot in ipairs(grids) do
				local i, j = spot.x, spot.y
				local g = game.level.map(i, j, Map.TERRAIN)
				g.temporary = 8
				g.x = i g.y = j
				g.canAct = false
				g.energy = { value = 0, mod = 1 }
				g.old_feat = spot.oe
				g.useEnergy = mod.class.Trap.useEnergy
				g.act = function(self)
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
						game.level:removeEntity(self)
						game.nicer_tiles:updateAround(game.level, self.x, self.y)
					end
				end
				game.level:addEntity(g)
			end

			src:project({type="ball", radius=2, selffire=false}, x, y, engine.DamageType.METEOR, dam)
			if core.shader.allow("distort") then game.level.map:particleEmitter(x, y, 2, "shockwave", {radius=2}) end
			game:getPlayer(true):attr("meteoric_crash", 1)
		end

		local grids = {}
		self:project(tg, x, y, function(px, py) grids[#grids+1] = {x=px, y=py} end)

		for i = 1, t.getNb(self, t) do
			local g = rng.tableRemove(grids)
			if not g then break end
			meteor(self, g.x, g.y, t.getDamage(self, t))
		end
		game.log("") -- forces update of combat log
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[Use arcane forces to summon %d meteors that fall to the ground within range 2 of the target.
		Each meteor smashes everything within radius 2, dealing %0.2f fire and %0.2f physical damage to creatures other than yourself, while liquefying some of the terrain into lava for 8 turns.
		The damage increases with your Spellpower.]]):
		tformat(t.getNb(self, t), damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

newTalent{
	name = "Heal", short_name = "HEAL_NATURE",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 10,
	cooldown = 16,
	tactical = { HEAL = 2 },
	getHeal = function(self, t) return 40 + self:combatTalentMindDamage(t, 10, 520) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:mindCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[Imbues your body with natural energies, healing for %d life.
		The life healed will increase with your Mindpower.]]):
		tformat(heal)
	end,
}

newTalent{
	name = "Call Lightning", image = "talents/lightning.png",
	type = {"wild-gift/other", 1},
	points = 5,
	equi = 4,
	cooldown = 3,
	tactical = { ATTACK = {LIGHTNING = 2} },
	message = _t"@Source@ hurls lightning at @target@!",
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 350) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Calls forth a powerful beam of lightning doing %0.2f to %0.2f lightning damage (%0.2f average).
		The damage will increase with your Mindpower.]]):
		tformat(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

newTalent{
	short_name = "KEEPSAKE_FADE",
	name = "Fade",
	type = {"undead/keepsake",1},
	tactical = { DEFEND = 2 },
	points = 5,
	cooldown = function(self, t)
		return math.max(3, 8 - self:getTalentLevelRaw(t))
	end,
	action = function(self, t)
		self:setEffect(self.EFF_FADED, 1, {})
		return true
	end,
	info = function(self, t)
		return ([[You fade from sight, making you invulnerable until the beginning of your next turn.]]):tformat()
	end,
}

newTalent{
	short_name = "KEEPSAKE_PHASE_DOOR",
	name = "Phase Door",
	type = {"undead/keepsake",1},
	points = 5,
	range = 10,
	tactical = { ESCAPE = 2 },
	is_teleport = true,
	action = function(self, t)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
		self:teleportRandom(self.x, self.y, self:getTalentRange(t))
		game.level.map:particleEmitter(x, y, 1, "teleport_in")
		return true
	end,
	info = function(self, t)
		return ([[Teleports you randomly within range 10.]]):tformat()
	end,
}

newTalent{
	short_name = "KEEPSAKE_BLINDSIDE",
	name = "Blindside",
	type = {"undead/keepsake", 1},
	points = 5,
	random_ego = "attack",
	range = 10,
	requires_target = true,
	tactical = { ATTACK = 1, CLOSEIN = 2 },
	is_melee = true,
	target = function(self, t) return {type="hit", pass_terrain = true, range=self:getTalentRange(t)} end,
	melee_target = function(self, t) return {type="hit", range=1} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		tg = util.getval(t.melee_target, self, t)
		if not target then return nil end

		local start = rng.range(0, 8)
		for i = start, start + 8 do
			local x = target.x + (i % 3) - 1
			local y = target.y + math.floor((i % 9) / 3) - 1
			if game.level.map:isBound(x, y)
					and self:canMove(x, y)
					and not game.level.map.attrs(x, y, "no_teleport") then
				game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
				self:move(x, y, true)
				game.level.map:particleEmitter(x, y, 1, "teleport_in")
				local multiplier = self:combatTalentWeaponDamage(t, 0.9, 1.9)
				self:attackTarget(target, nil, multiplier, true)
				return true
			end
		end

		return false
	end,
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 1.1, 1.9)
		return ([[With blinding speed you suddenly appear next to a target up to %d spaces away and attack for %d%% damage.]]):tformat(self:getTalentRange(t), multiplier)
	end,
}

newTalent{
	name = "Suspended", image = "talents/arcane_feed.png",
	type = {"other/other", 1},
	points = 1,
	mode = "sustained",
	cooldown = 10,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "invulnerable", 1)
		self:talentTemporaryValue(ret, "status_effect_immune", 1)
		self:talentTemporaryValue(ret, "dazed", 1)
		return ret
	end,
	deactivate = function(self, t, p)
		game.logSeen("#VIOLET#%s is freed from the suspended state!", self:getName():capitalize())
		return true
	end,
	info = function(self, t)
		return ([[The target will not react until attacked.]]):tformat()
	end,
}


newTalent{
	name = "Frost Grab",
	type = {"spell/other", 1},
	points = 5,
	mana = 19,
	cooldown = 8,
	range = 10,
	tactical = { ATTACK = {COLD = 1}, DISABLE = {slow = 1}, CLOSEIN = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 5, 140))

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			target:pull(self.x, self.y, tg.range)

			DamageType:get(DamageType.COLD).projector(self, target.x, target.y, DamageType.COLD, dam)
			target:setEffect(target.EFF_SLOW_MOVE, t.getDuration(self, t), {apply_power=self:combatSpellpower(), power=0.5})
		end)
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		return ([[Grab a target and pull it next to you, covering it with frost while reducing its movement speed by 50%% for %d turns.
		The ice will also deal %0.2f cold damage.
		The damage and chance to slow will increase with your Spellpower.]]):
		tformat(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentSpellDamage(t, 5, 140)))
	end,
}

newTalent{
	name = "Body Shot",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 10,
	stamina = 10,
	message = _t"@Source@ throws a body shot.",
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	requires_target = true,
	--on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_COMBO) then if not silent then game.logPlayer(self, "You must have a combo going to use this ability.") end return false end return true end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.8) + getStrikingStyle(self, dam) end,
	getDuration = function(self, t, comb) return math.ceil(self:combatTalentScale(t, 1, 5) * (0.25 + comb/5)) end,
	getDrain = function(self, t) return self:combatTalentScale(t, 2, 10, 0.75) * self:getCombo(combo) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hit then
			-- try to daze
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, t.getDuration(self, t, self:getCombo(combo)), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the body shot!", target:getName():capitalize())
			end

			target:incStamina(- t.getDrain(self, t))

		end

		self:clearCombo()

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local drain = self:getTalentLevel(t) * 2
		local daze = t.getDuration(self, t, 0)
		local dazemax = t.getDuration(self, t, 5)
		return ([[A punch to the body that deals %d%% damage, drains %d of the target's stamina per combo point, and dazes the target for %d to %d turns, depending on the amount of combo points you've accumulated.
		The daze chance will increase with your Physical Power.
		Using this talent removes your combo points.]])
		:tformat(damage, drain, daze, dazemax)
	end,
}

newTalent{
	name = "Combo String",
	type = {"technique/other", 1},
	mode = "passive",
	points = 5,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 0.3, 2.3)) end,
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (5 + self:getCun(5, true)), 100, 0, 0, 50, 50) end, -- Limit < 100%
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[When gaining a combo point, you have a %d%% chance to gain an extra combo point.  Additionally, your combo points will last %d turns longer before expiring.
		The chance of building a second combo point will improve with your Cunning.]]):
		tformat(chance, duration)
	end,
}

newTalent{
	name = "Steady Mind",
	type = {"technique/other", 1},
	mode = "passive",
	points = 5,
	getDefense = function(self, t) return self:combatTalentStatDamage(t, "dex", 5, 35) end,
	getMental = function(self, t) return self:combatTalentStatDamage(t, "cun", 5, 35) end,
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local saves = t.getMental(self, t)
		return ([[Superior cunning and training allows you to outthink and outwit your opponents' physical and mental assaults.  Increases Defense by %d and Mental Save by %d.
		The Defense bonus will scale with your Dexterity, and the save bonus with your Cunning.]]):
		tformat(defense, saves)
	end,
}

newTalent{
	name = "Maim",
	type = {"technique/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 10,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = 2 },
	requires_target = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 10, 100) * getUnarmedTrainingBonus(self) end,
	getMaim = function(self, t) return self:combatTalentPhysicalDamage(t, 5, 30) end,
	-- Learn the appropriate stance
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local grappled = false

		-- breaks active grapples if the target is not grappled
		if target:isGrappled(self) then
			grappled = true
		else
			self:breakGrapples()
		end

		-- end the talent without effect if the target is to big
		if self:grappleSizeCheck(target) then
			return true
		end

		-- start the grapple; this will automatically hit and reapply the grapple if we're already grappling the target
		local hit = self:startGrapple (target)
		-- deal damage and maim if appropriate
		if hit then
			if grappled then
				self:project(target, x, y, DamageType.PHYSICAL, self:physicalCrit(t.getDamage(self, t), nil, target, self:combatAttack(), target:combatDefense()))
				target:setEffect(target.EFF_MAIMED, t.getDuration(self, t), {power=t.getMaim(self, t)})
			else
				self:project(target, x, y, DamageType.PHYSICAL, self:physicalCrit(t.getDamage(self, t), nil, target, self:combatAttack(), target:combatDefense()))
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local maim = t.getMaim(self, t)
		return ([[Grapples the target and inflicts %0.2f physical damage. If the target is already grappled, the target will be maimed as well, reducing damage by %d and global speed by 30%% for %d turns.
		The grapple effects will be based off your grapple talent, if you have it, and the damage will scale with your Physical Power.]])
		:tformat(damDesc(self, DamageType.PHYSICAL, (damage)), maim, duration)
	end,
}

newTalent{
	name = "Bloodrage",
	type = {"technique/other", 1},
	points = 5,
	mode = "passive",
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	on_kill = function(self, t)
		self:setEffect(self.EFF_BLOODRAGE, t.getDuration(self, t), {max=math.floor(self:getTalentLevel(t) * 6), inc=2})
	end,
	info = function(self, t)
		return ([[Each time one of your foes bites the dust, you feel a surge of power, increasing your strength by 2 (stacking up to a maximum of %d) for %d turns.]]):
		tformat(math.floor(self:getTalentLevel(t) * 6), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Martyrdom",
	type = {"spell/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 22,
	positive = 25,
	tactical = { DISABLE = 2 },
	range = 6,
	reflectable = true,
	requires_target = true,
	getReturnDamage = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 15, 1, 40, 2.24) end, -- Limit <100%
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(self.EFF_MARTYRDOM, 10, {src = self, power=t.getReturnDamage(self, t), apply_power=self:combatSpellpower()})
		else
			return
		end
		return true
	end,
	info = function(self, t)
		local returndamage = t.getReturnDamage(self, t)
		return ([[Designate a target as a martyr for 10 turns. When the martyr deals damage, it also damages itself for %d%% of the damage dealt.]]):
		tformat(returndamage)
	end,
}

newTalent{
	name = "Overpower",
	type = {"technique/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 22,
	requires_target = true,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = 2, ESCAPE = { knockback = 1 }, DISABLE = { knockback = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Overpower without a shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- First attack with weapon
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3), true)
		-- Second attack with shield
		self:attackTargetWith(target, shield_combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
		-- Third attack with shield
		local speed, hit = self:attackTargetWith(target, shield_combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Try to stun !
		if hit then
			if target:checkHit(self:combatAttack(shield_combat), target:combatPhysicalResist(), 0, 95, 5 - self:getTalentLevel(t) / 2) and target:canBe("knockback") then
				target:knockback(self.x, self.y, 4)
			else
				game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target with your weapon doing %d%% damage and two shield strikes doing %d%% damage each, trying to overpower your target.
		If the last attack hits, the target is knocked back 4 grids. The chance for knockback increases with your Accuracy.]])
		:tformat(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
	end,
}

newTalent{
	name = "Perfect Control",
	type = {"psionic/other", 1},
	cooldown = 50,
	psi = 15,
	points = 5,
	tactical = { BUFF = 2 },
	getBoost = function(self, t)
		return self:combatScale(self:getTalentLevel(t)*self:combatStatTalentIntervalDamage(t, "combatMindpower", 1, 9), 15, 0, 49, 34)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 50, 6, 10)) end, -- Limit < 50
	action = function(self, t)
		self:setEffect(self.EFF_CONTROL, t.getDuration(self, t), {power= t.getBoost(self, t)})
		return true
	end,
	info = function(self, t)
		local boost = t.getBoost(self, t)
		local dur = t.getDuration(self, t)
		return ([[Encase your body in a sheath of thought-quick forces, allowing you to control your body's movements directly without the inefficiency of dealing with crude mechanisms like nerves and muscles.
		Increases Accuracy by %d and critical strike chance by %0.1f%% for %d turns.]]):
		tformat(boost, 0.5*boost, dur)
	end,
}

newTalent{
	name = "Shattering Charge",
	type = {"psionic/other", 1},
--	require = psi_wil_req4,
	points = 5,
	psi = 40,
	cooldown = 12,
	tactical = { CLOSEIN = 2, ATTACK = { PHYSICAL = 2 } },
	range = function(self, t) return self:combatTalentLimit(t, 10, 6, 9) end,
	direct_hit = true,
	requires_target = true,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 180) end,
	action = function(self, t)
		if self:getTalentLevelRaw(t) < 5 then
			local tg = {type="beam", range=self:getTalentRange(t), nolock=true, talent=t}
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end
			if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end
			if self:hasLOS(x, y) and not game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
				local dam = self:mindCrit(t.getDam(self, t))
				self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(2*dam/3, dam, 3)))
				--local _ _, x, y = self:canProject(tg, x, y)
				game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
				game:playSoundNear(self, "talents/lightning")
				--self:move(x, y, true)
				local fx, fy = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
				if fx then
					self:move(fx, fy, true)
				end
			else
				game.logSeen(self, "You can't move there.")
				return nil
			end
			return true
		else
			local tg = {type="beam", range=self:getTalentRange(t), nolock=true, talent=t, display={particle="bolt_earth", trail="earthtrail"}}
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end
			if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end
			local dam = self:mindCrit(t.getDam(self, t))

			for i = 1, self:getTalentRange(t) do
				self:project(tg, x, y, DamageType.DIG, 1)
			end
			self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(2*dam/3, dam, 3)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
			game:playSoundNear(self, "talents/lightning")

			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, engine.Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			local tx, ty = self.x, self.y
			while lx and ly do
				if is_corner_blocked or block_actor(_, lx, ly) then break end
				tx, ty = lx, ly
				lx, ly, is_corner_blocked = l:step()
			end

			--self:move(tx, ty, true)
			local fx, fy = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if fx then
				self:move(fx, fy, true)
			end
			return true
		end
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDam(self, t))
		return ([[You expend massive amounts of energy to launch yourself across %d squares at incredible speed. All enemies in your path will be knocked flying and dealt between %d and %d Physical damage.
		At talent level 5, you can batter through solid walls.]]):
		tformat(range, 2*dam/3, dam)
	end,
}

newTalent{
	name = "Telekinetic Throw",
	type = {"psionic/other", 1},
--	require = psi_wil_high2,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 20,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	range = function(self, t) return math.floor(self:combatStatScale("str", 1, 5) + self:combatMindpower()/20) end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 10, 170))
	end,
	getKBResistPen = function(self, t) return self:combatTalentLimit(t, 100, 25, 45) end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false, talent=t} end,
	action = function(self, t)
		local tg = {type="hit", range=1}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))

		if target:canBe("knockback") or rng.percent(t.getKBResistPen(self, t)) then
			self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam) --Direct Damage
			local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
			if tx and ty then
				local ox, oy = target.x, target.y
				target:move(tx, ty, true)
				if config.settings.tome.smooth_move > 0 then
					target:resetMoveAnim()
					target:setMoveAnim(ox, oy, 8, 5)
				end
			end
			tg.act_exclude = {[target.uid]=true} -- Don't hit primary target with AOE
			self:project(tg, target.x, target.y, DamageType.SPELLKNOCKBACK, dam/2) --AOE damage
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 4, {apply_power=self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		else --If the target resists the knockback, do half damage to it.
			target:logCombat(self, "#YELLOW##Source# resists #Target#'s throw!")
			self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam/2)
		end
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[Use your telekinetic power to enhance your strength, allowing you to pick up an adjacent enemy and hurl it anywhere within radius %d.
		Upon landing, your target takes %0.1f Physical damage and is stunned for 4 turns.  All other creatures within radius 2 of the landing point take %0.1f Physical damage and are knocked away from you.
		This talent ignores %d%% of the knockback resistance of the thrown target, which takes half damage if it resists being thrown.
		The damage improves with your Mindpower and the range increases with both Mindpower and Strength.]]):
		tformat(range, dam, dam/2, t.getKBResistPen(self, t))
	end,
}

newTalent{
	name = "Reach",
	type = {"psionic/other", 1},
	mode = "passive",
	points = 5,
	rangebonus = function(self,t) return math.max(0, self:combatTalentScale(t, 3, 10)) end,
	info = function(self, t)
		return ""
	end,
}

newTalent{
	name = "Reload",
	type = {"technique/other", 1},
	cooldown = 2,
	innate = true,
	points = 1,
	tactical = { AMMO = 2, BUFF = -2 },
	no_energy = true,
	no_reload_break = true,
	no_break_stealth = true,
	no_dumb_use = true,
	on_pre_use = function(self, t, silent)
		local q = self:hasAmmo()
		if not q then if not silent then game.logPlayer(self, "You must have a quiver or pouch equipped.") end return false end
		if q.combat.shots_left >= q.combat.capacity then return false end
		return true
	end,
	no_unlearn_last = true,
	action = function(self, t)
		if self.resting then return end
		local ret = self:reload()
		if ret then
			self:setEffect(self.EFF_RELOAD_DISARMED, 1, {})
		end
		return true
	end,
	info = function(self, t)
		return ([[Quickly reload your ammo by %d (depends on masteries and object bonuses).
		Doing so requires no turn but you are considered disarmed for 2 turns.

		Reloading does not break stealth.]])
		:tformat(self:reloadRate())
	end,
}

newTalent{
	name = "Sweep",
	type = {"technique/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 30,
--	require = techs_dex_req3,
	requires_target = true,
	tactical = { ATTACKAREA = { weapon = 1, cut = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	cutdur = function(self,t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	cutPower = function(self, t)
		local main, off = self:hasDualWeapon()
		if main then
			-- Damage based on mainhand weapon and dex with an assumed 8 turn cut duration
			return self:combatTalentScale(t, 1, 1.7) * self:combatDamage(main.combat)/8 + self:getDex()/2
		else
			return 0
		end
	end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Sweep without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local dir = util.getDir(x, y, self.x, self.y)
		if dir == 5 then return nil end
		local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
		local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
		local lt, rt = game.level.map(lx, ly, Map.ACTOR), game.level.map(rx, ry, Map.ACTOR)

		local hit
		hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
		if hit and target:canBe("cut") then target:setEffect(target.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end

		if lt then
			hit = self:attackTarget(lt, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
			if hit and lt:canBe("cut") then lt:setEffect(lt.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end
		end

		if rt then
			hit = self:attackTarget(rt, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
			if hit and rt:canBe("cut") then rt:setEffect(rt.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end
		end
		print(x,y,target)
		print(lx,ly,lt)
		print(rx,ry,rt)

		return true
	end,
	info = function(self, t)
		return ([[Attack your foes in a frontal arc, doing %d%% weapon damage and making your targets bleed for %d each turn for %d turns.
		The bleed damage increases with your main hand weapon damage and Dexterity.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 1, 1.7), damDesc(self, DamageType.PHYSICAL, t.cutPower(self, t)), t.cutdur(self, t))
	end,
}

newTalent{
	name = "Empower Poisons",
	type = {"other/other", 1},
	points = 5,
	cooldown = 24,
	stamina = 15,
--	require = cuns_req_high3,
	requires_target = true,
	no_energy = true,
	tactical = { ATTACK = {NATURE = 1} },
	range = 1,
	on_pre_use_ai = function(self, t, silent, fake) -- don't use unless target is poisoned
		local target = self.ai_target.actor
		if not target then return end
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.poison then return true end
		end
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local mod = (100 + self:combatTalentStatDamage(t, "cun", 40, 250)) / 100
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.poison then
				p.dur = math.ceil(p.dur / 2)
				p.power = (p.power or 0) * mod
			end
		end

		game.level.map:particleEmitter(target.x, target.y, 1, "slime")
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Reduces the duration of all poisons on the target by 50%%, but increases their damage by %d%%.
		The effect increases with your Cunning.]]):
		tformat(100 + self:combatTalentStatDamage(t, "cun", 40, 250))
	end,
}

newTalent{
	name = "Willful Combat",
	type = {"other/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 60,
	stamina = 25,
	tactical = { BUFF = 3 },
--	require = cuns_req3,
	no_energy = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 60, 5, 11.1)) end, -- Limit <60
	getDamage = function(self, t) return self:combatStatScale("wil", 4, 40, 0.75) + self:combatStatScale("cun", 4, 40, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_WILLFUL_COMBAT, t.getDuration(self, t), {power=t.getDamage(self, t)})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[For %d turns, you put all your will into your blows, adding %d physical power to each strike.
		The effect will improve with your Cunning and Willpower stats.]]):
		tformat(duration, damage)
	end,
}

newTalent{
	name = "Deadly Strikes",
	type = {"other/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 15,
--	require = cuns_req2,
	tactical = { ATTACK = {weapon = 2} },
	no_energy = true,
	requires_target = true,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.4) end,
	getArmorPierce = function(self, t) return self:combatTalentStatDamage(t, "cun", 5, 45) end,  -- Adjust to scale like armor progression elsewhere
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 12, 6, 10)) end, --Limit to <12
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local _, x, y = self:canProject(tg, self:getTarget(tg))
		local target = game.level.map(x, y, game.level.map.ACTOR)
		if not target then return nil end

		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			self:setEffect(self.EFF_DEADLY_STRIKES, t.getDuration(self, t), {power=t.getArmorPierce(self, t)})
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local apr = t.getArmorPierce(self, t)
		local duration = t.getDuration(self, t)
		return ([[You hit your target, doing %d%% damage. If your attack hits, you gain %d armor penetration (APR) for %d turns.
		The APR will increase with your Cunning.]]):
		tformat(100 * damage, apr, duration)
	end,
}

newTalent{
	name = "Sticky Smoke",
	type = {"other/other", 1},
	points = 5,
	cooldown = 15,
	stamina = 10,
--	require = cuns_req3,
	no_break_stealth = true,
	reflectable = true,
	proj_speed = 10,
	requires_target = true,
	range = 10,
	speed = "combat",
	radius = function(self, t) return math.max(0,math.floor(self:combatTalentScale(t, 0.5, 2.5))) end,
	getSightLoss = function(self, t) return math.floor(self:combatTalentScale(t,1, 6, "log", 0, 4)) end, -- 1@1 6@5
	tactical = { DISABLE = { blind = 2 } },
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t, display={particle="bolt_dark"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.STICKY_SMOKE, t.getSightLoss(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Throws a vial of sticky smoke that explodes in radius %d on your foes, reducing their vision range by %d for 5 turns.
		Creatures affected by smoke bomb can never prevent you from stealthing, even if their proximity would normally forbid it.
		Use of this will not break stealth.]]):
		tformat(self:getTalentRadius(t), t.getSightLoss(self,t))
	end,
}

newTalent{
	name = "Switch Place",
	type = {"other/other", 1},
	points = 5,
	random_ego = "defensive",
	cooldown = 10,
	stamina = 15,
--	require = cuns_req3,
	requires_target = true,
	tactical = { DISABLE = 2 },
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return 3 end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	speed = "weapon",
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local tx, ty, sx, sy = target.x, target.y, self.x, self.y
		local hitted = self:attackTarget(target, nil, 0, true)

		if hitted and not self.dead and tx == target.x and ty == target.y then
			if not self:canMove(tx,ty,true) or not target:canMove(sx,sy,true) then
				self:logCombat(target, "Terrain prevents #Source# from switching places with #Target#.")
				return true
			end
			self:setEffect(self.EFF_EVASION, t.getDuration(self, t), {chance=50})
			-- Displace
			if not target.dead then
				self:move(tx, ty, true)
				target:move(sx, sy, true)
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Using a series of tricks and maneuvers, you switch places with your target.
		Switching places will confuse your foes, granting you Evasion (50%%) for %d turns.
		While switching places, your weapon(s) will connect with the target; this will not do weapon damage, but on hit effects of the weapons can trigger.]]):
		tformat(duration)
	end,
}

newTalent{
	name = "Cripple",
	type = {"other/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 25,
	stamina = 20,
--	require = cuns_req4,
	requires_target = true,
	tactical = { DISABLE = 2, ATTACK = {weapon = 2} },
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.9) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getSpeedPenalty = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "cun", 5, 50), 50, 10, 0, 25, 35.7) end, -- Limit < 50%
	speed = "weapon",
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			local speed = t.getSpeedPenalty(self, t) / 100
			target:setEffect(target.EFF_CRIPPLE, t.getDuration(self, t), {speed=speed, apply_power=self:combatAttack()})
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local speedpen = t.getSpeedPenalty(self, t)
		return ([[You hit your target, doing %d%% damage. If your attack connects, the target is crippled for %d turns, losing %d%% melee, spellcasting and mind speed.
		The chance to land the status improves with Accuracy, and the status power improves with Cunning.]]):
		tformat(100 * damage, duration, speedpen)
	end,
}

newTalent{
	name = "Nimble Movements",
	type = {"other/other",1},
	message = _t"@Source@ dashes quickly!",
	no_break_stealth = true,
--	require = cuns_req3,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 31.9, 17)) end, -- Limit >= 5
	tactical = { CLOSEIN = 3 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6.8, 8.6)) end,
	speed = "movement",
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "You can not do that currently.") return end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then
			game.logPlayer(self, "You cannot dash through that!")
			return
		end
		local tx, ty = lx, ly
		lx, ly, is_corner_blocked = l:step()
		while lx and ly do
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		return true
	end,
	info = function(self, t)
		return ([[Quickly and quietly dash your way to the target square, if it is not blocked by enemies or obstacles. This talent will not break Stealth.]]):tformat()
	end,
}

newTalent{
	name = "Hide in Plain Sight",
	type = {"other/other",3},
--	require = cuns_req3,
	no_energy = true,
	points = 5,
	hide = false,
	stamina = 20,
	cooldown = 40,
	tactical = { DEFEND = 2, ESCAPE = 1 },
	on_pre_use_ai = function(self, t, silent, fake)
		return self.ai_target.actor and not self:isTalentActive(self.T_STEALTH)
	end,
	-- Assume level 50 w/100 cun --> stealth = 54, detection = 50
	-- 90% (~= 47% chance against 1 opponent (range 1) at talent level 1, 270% (~= 75% chance against 1 opponent (range 1) and 3 opponents (range 6) at talent level 5
	stealthMult = function(self, t) return self:combatTalentScale(t, 0.9, 2.7) end,
	no_break_stealth = true,
	on_pre_use = function(self, t, silent, fake)
		local armor = self:getInven("BODY") and self:getInven("BODY")[1]
		if armor and (armor.subtype == "heavy" or armor.subtype == "massive") then
			if not silent then game.logPlayer(self, "You cannot be stealthy with such heavy armour on!") end
			return nil
		end
		return true
	end,
	getChance = function(self, t, fake, estimate)
		local netstealth = t.stealthMult(self, t) * (self:callTalent(self.T_STEALTH, "getStealthPower") + (self:attr("inc_stealth") or 0))
		if fake then return netstealth end
		local detection = self:stealthDetection(10, estimate) -- Default radius 10
		if detection <= 0 then return 100 end
		local _, chance = self:checkHit(netstealth, detection)
		print("Hide in Plain Sight: "..netstealth.." stealth vs "..detection.." detection -->chance "..chance)
		return chance
	end,
	action = function(self, t)
		self.talents_cd[self.T_STEALTH] = nil
		self.changed = true
		self.hide_chance = t.getChance(self, t)
		self:useTalent(self.T_STEALTH)
		self.hide_chance = nil

		for uid, e in pairs(game.level.entities) do
			if e.ai_target and e.ai_target.actor == self then e:setTarget(nil) end
		end
		return true
	end,
	info = function(self, t)
		return ([[You have learned how to be stealthy even when in plain sight of your foes.  You may attempt to enter stealth regardless of how close you are to your enemies, but success is more likely against fewer opponents that are farther away.
		Your chance to succeed is determined by comparing %0.2f times your stealth power (currently %d) to the stealth detection of all enemies (reduced by 10%% per tile distance) that have a clear line of sight to you.
		You always succeed if you are not directly observed.
		This resets the cooldown of your Stealth talent, and, if successful, all creatures currently following you will lose track of your position.
		You estimate your current chance to hide as %0.1f%%.]]):
		tformat(t.stealthMult(self, t), t.getChance(self, t, true), t.getChance(self, t, false, true))
	end,
}

newTalent{
	name = "Unseen Actions",
	type = {"other/other", 1},
--	require = cuns_req4,
	mode = "passive",
	points = 5,
	hide = false,
	-- Assume level 50 w/100 cun --> stealth = 54, detection = 50
	-- 40% (~= 20% chance against 1 opponent (range 1) at talent level 1, 189% (~= 55% chance against 1 opponent (range 1) and 2 opponents (range 6) at talent level 5
	stealthMult = function(self, t) return self:combatTalentScale(t, 0.4, 1.89) end,
	getChance = function(self, t, fake, estimate)
		local netstealth = t.stealthMult(self, t) * (self:callTalent(self.T_STEALTH, "getStealthPower") + (self:attr("inc_stealth") or 0))
		if fake then return netstealth end
		local detection = self:stealthDetection(10, estimate) -- Default radius 10
		if not detection or detection <= 0 then return 100 end
		local _, chance = self:checkHit(netstealth, detection)
		print("Unseen Actions: "..netstealth.." stealth vs "..detection.." detection -->chance(no luck): "..chance)
		if estimate then return chance end
		return util.bound(chance + (self:getLck() - 50) * 0.2, 0, 100)
	end,
	info = function(self, t)
		return ([[You are able to perform usually unstealthy actions (attacking, using objects, ...) without breaking stealth.	 When you perform such an action while stealthed, you have a chance to stay hidden.
		Success is more likely against fewer opponents and is determined by comparing %0.2f times your stealth power (currently %d) to the stealth detection (reduced by 10%% per tile distance) of all enemies that have a clear line of sight to you.
		Your base chance of success is 100%% if you are not directly observed, and good or bad luck may also affect it.
		You estimate your current chance to maintain stealth as %0.1f%%.]]):
		tformat(t.stealthMult(self, t), t.getChance(self, t, true), t.getChance(self, t, false, true))
	end,
}

newTalent{
	name = "Hack'n'Back",
	type = {"other/other", 1},
	points = 5,
	cooldown = 14,
	stamina = 30,
	tactical = { ESCAPE = 1, ATTACK = { weapon = 0.5 } },
--	require = techs_dex_req1,
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.4, 1) end,
	getDist = function(self, t) return math.ceil(self:combatTalentScale(t, 1.2, 3.3)) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			self:knockback(target.x, target.y, t.getDist(self, t))
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dist = t.getDist(self, t)
		return ([[You hit your target, doing %d%% damage, distracting it while you jump back %d squares away.]]):
		tformat(100 * damage, dist)
	end,
}

newTalent{
	name = "Mobile Defence",
	type = {"other/other", 1},
	mode = "passive",
	points = 5,
--	require = techs_dex_req2,
	getDef = function(self, t) return self:combatTalentLimit(t, 1, 0.1, 0.4) end, -- Limit < 100% bonus defense
	getHardiness = function(self, t) return self:getTalentLevel(t) * 0.06 end,
	-- called by _M:combatDefenseBase function in mod\class\interface\Combat.lua
	getDef = function(self, t) return self:combatTalentLimit(t, 1, 0.10, 0.40) end, -- Limit to <100% defense bonus
	-- called by _M:combatArmorHardiness function in mod\class\interface\Combat.lua
	getHardiness = function(self, t) return self:combatTalentLimit(t, 100, 6, 30) end, -- Limit < 100%
	info = function(self, t)
		return ([[Whilst wearing leather or lighter armour, you gain %d%% Defense and %d%% Armour hardiness.]]):
		tformat(t.getDef(self, t) * 100, t.getHardiness(self, t))
	end,
}

newTalent{
	name = "Light of Foot",
	type = {"other/other", 1},
	mode = "passive",
	points = 5,
--	require = techs_dex_req3,
	getFatigue = function(self, t) return self:combatTalentLimit(t, 100, 1.5, 7.5) end, -- Limit < 50%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "fatigue", -t.getFatigue(self, t))
	end,
	info = function(self, t)
		return ([[You are light on your feet, handling your armour better. Each step you take regenerates %0.2f stamina, and your fatigue is permanently reduced by %0.1f%%.
		At level 3 you are able to walk so lightly that you never trigger traps that require pressure.]]):
		tformat(self:getTalentLevelRaw(t) * 0.2, t.getFatigue(self, t))
	end,

}

newTalent{
	name = "Strider",
	type = {"other/other", 1},
	mode = "passive",
	points = 5,
--	require = techs_dex_req4,
	incspeed = function(self, t) return self:combatTalentScale(t, 0.02, 0.10, 0.75) end,
	CDreduce = function(self, t) return math.floor(self:combatTalentLimit(t, 8, 1, 5)) end, -- Limit < 8
	passives = function(self, t, p)
		local cdr = t.CDreduce(self, t)
		self:talentTemporaryValue(p, "movement_speed", t.incspeed(self, t))
		self:talentTemporaryValue(p, "talent_cd_reduction",
			{[Talents.T_RUSH]=cdr, [Talents.T_HACK_N_BACK]=cdr, [Talents.T_DISENGAGE]=cdr, [Talents.T_EVASION]=cdr})
	end,
	info = function(self, t)
		return ([[You literally dance around your foes, increasing your movement speed by %d%% and reducing the cooldown of Hack'n'Back, Rush, Disengage and Evasion by %d turns.]]):
		tformat(t.incspeed(self, t)*100,t.CDreduce(self, t))
	end,
}

newTalent{
	name = "Charm Mastery",
	type = {"other/other", 1},
--	require = cuns_req2,
	mode = "passive",
	points = 5,
	cdReduc = function(tl)
		if tl <=0 then return 0 end
		return math.floor(100*tl/(tl+7.5)) -- Limit < 100%
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "use_object_cooldown_reduce", t.cdReduc(self:getTalentLevel(t)))
	end,
--	on_unlearn = function(self, t)
--	end,
	info = function(self, t)
		return ([[Your cunning manipulations allow you to use charms (wands, totems and torques) more efficiently, reducing their cooldowns by %d%%.]]):
		tformat(t.cdReduc(self:getTalentLevel(t)))
	end,
}

newTalent{
	name = "Piercing Sight",
	type = {"other/other", 1},
--	require = cuns_req3,
	mode = "passive",
	points = 5,
	--  called by functions _M:combatSeeStealth and _M:combatSeeInvisible functions mod\class\interface\Combat.lua
	seePower = function(self, t) return math.max(0, self:combatScale(self:getCun(15, true)*self:getTalentLevel(t), 10, 1, 80, 75, 0.25)) end, --TL 5, cun 100 = 80
	info = function(self, t)
		return ([[You look at your surroundings with more intensity than most people, allowing you to see stealthed or invisible creatures.
		Increases stealth detection by %d and invisibility detection by %d.
		The detection power increases with your Cunning.]]):
		tformat(t.seePower(self,t), t.seePower(self,t))
	end,
}

newTalent{
	name = "Precision",
--	type = {"technique/dualweapon-training", 3},
	type = {"technique/other", 1},
	mode = "sustained",
	points = 5,
	require = techs_dex_req3,
	no_energy = true,
	cooldown = 10,
	sustain_stamina = 20,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getApr = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 25, 500, 0.75) end,
	activate = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Precision without dual wielding!")
			return nil
		end

		return {
			apr = self:addTemporaryValue("combat_apr",t.getApr(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_apr", p.apr)
		return true
	end,
	info = function(self, t)
		return ([[You have learned to hit the right spot, increasing your armor penetration by %d when dual wielding.
		The Armour penetration bonus will increase with your Dexterity.]]):tformat(t.getApr(self, t))
	end,
}

newTalent{
	name = "Momentum",
--	type = {"technique/dualweapon-training", 4},
	type = {"technique/other", 1},
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 50,
	require = techs_dex_req4,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if self:hasArcheryWeapon() or not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two melee weapons to use this talent.") end return false end return true end,
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.11, 0.40) end,
	activate = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Momentum without dual wielding melee weapons!")
			return nil
		end

		return {
			combat_physspeed = self:addTemporaryValue("combat_physspeed", t.getSpeed(self, t)),
			stamina_regen = self:addTemporaryValue("stamina_regen", -6),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.combat_physspeed)
		self:removeTemporaryValue("stamina_regen", p.stamina_regen)
		return true
	end,
	info = function(self, t)
		return ([[When dual wielding, increases attack speed by %d%%, but drains stamina quickly (-6 stamina/turn).]]):tformat(t.getSpeed(self, t)*100)
	end,
}

newTalent{
	name = "Defensive Throw",
--	type = {"technique/unarmed-discipline", 2},
	type = {"technique/other", 1},
--	require = techs_dex_req2,
	mode = "passive",
	points = 5,
	-- Limit defensive throws/turn for balance using a buff (warns attacking players of the talent)
	-- EFF_DEFENSIVE_GRAPPLING effect is refreshed each turn in _M:actBase in mod.class.Actor.lua
	getDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 5, 50) * getUnarmedTrainingBonus(self) end,
	getDamageTwo = function(self, t) return self:combatTalentPhysicalDamage(t, 10, 75) * getUnarmedTrainingBonus(self) end,
	getchance = function(self, t)
		return self:combatLimit(self:getTalentLevel(t) * (5 + self:getCun(5, true)), 100, 0, 0, 50, 50) -- Limit < 100%
	end,
	getThrows = function(self, t)
		return self:combatScale(self:getStr() + self:getDex()-20, 0, 0, 2.24, 180)
	end,
	-- called by _M:attackTargetWith function in mod\class\interface\Combat.lua (includes adjacency check)
	do_throw = function(self, target, t)
		local ef = self:hasEffect(self.EFF_DEFENSIVE_GRAPPLING)
		if not ef or not rng.percent(self.tempeffect_def.EFF_DEFENSIVE_GRAPPLING.throwchance(self, ef)) then return end
		local grappled = target:isGrappled(self)
		local hit = self:checkHit(self:combatAttack(), target:combatDefense(), 0, 95) and (grappled or not self:checkEvasion(target)) -- grappled target can't evade
		ef.throws = ef.throws - 1
		if ef.throws <= 0 then self:removeEffect(self.EFF_DEFENSIVE_GRAPPLING) end

		if hit then
			self:project(target, target.x, target.y, DamageType.PHYSICAL, self:physicalCrit(t.getDamageTwo(self, t), nil, target, self:combatAttack(), target:combatDefense()))
			-- if grappled stun
			if grappled and target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 2, {apply_power=self:combatAttack(), min_dur=1})
				self:logCombat(target, "#Source# slams #Target# into the ground!")
			-- if not grappled daze
			else
				self:logCombat(target, "#Source# throws #Target# to the ground!")
				-- see if the throw dazes the enemy
				if target:canBe("stun") then
					target:setEffect(target.EFF_DAZED, 2, {apply_power=self:combatAttack(), min_dur=1})
				end
			end
		else
			self:logCombat(target, "#Source# misses a defensive throw against #Target#!", self:getName():capitalize(),target:getName():capitalize())
		end
	end,
	on_unlearn = function(self, t)
		self:removeEffect(self.EFF_DEFENSIVE_GRAPPLING)
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damagetwo = t.getDamageTwo(self, t)
		return ([[When you avoid a melee blow while unarmed, you have a %d%% chance to throw the target to the ground.  If the throw lands, the target will take %0.2f damage and be dazed for 2 turns, or %0.2f damage and be stunned for 2 turns if the target is grappled.  You may attempt up to %0.1f throws per turn.
		The chance of throwing increases with your Accuracy, the damage scales with your Physical Power, and the number of attempts with your Strength and Dexterity.]]):
		tformat(t.getchance(self,t), damDesc(self, DamageType.PHYSICAL, (damage)), damDesc(self, DamageType.PHYSICAL, (damagetwo)), t.getThrows(self, t))
	end,
}

newTalent{
	name = "Roundhouse Kick",
--	type = {"technique/unarmed-discipline", 4},
	type = {"technique/other", 1},
--	require = techs_dex_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 18,
	range = 0,
	radius = function(self, t) return 1 end,
	tactical = { ATTACKAREA = { PHYSICAL = 2 }, DISABLE = { knockback = 2 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 15, 150) * getUnarmedTrainingBonus(self) end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end

		self:breakGrapples()

		self:project(tg, x, y, DamageType.PHYSKNOCKBACK, {dam=t.getDamage(self, t), dist=4})

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Attack your foes in a frontal arc with a roundhouse kick, which deals %0.2f physical damage and knocks your foes back 4 grids. This will break any grapples you're maintaining
		The damage improves with your Physical Power.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, (damage)))
	end,
}

newTalent{
	name = "Bone Nova",
	type = {"corruption/other", 1},
	points = 5,
	vim = 25,
	cooldown = 12,
	tactical = { ATTACKAREA = {PHYSICAL = 2} },
	random_ego = "attack",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 8, 180) end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.PHYSICALBLEED, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "circle", {oversize=1.1, a=255, limit_life=8, grow=true, speed=0, img="bone_nova", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Fire bone spears in all directions, hitting all foes within radius %d for %0.2f physical damage, and inflicting bleeding for another %0.2f damage over 5 turns.
		The damage will increase with your Spellpower.]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)/2))
	end,
}

newTalent{
	name = "Shadow Ambush",
	type = {"spell/other", 1},
	points = 5,
	cooldown = 20,
	stamina = 15,
	mana = 15,
	range = 7,
	tactical = { DISABLE = {silence = 2}, CLOSEIN = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	speed = "combat",
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		local sx, sy = util.findFreeGrid(self.x, self.y, 5, true, {[engine.Map.ACTOR]=true})
		if not sx then return end

		target:move(sx, sy, true)

		if core.fov.distance(self.x, self.y, sx, sy) <= 1 then
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, 2, {apply_power=self:combatAttack()})
			end
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, t.getDuration(self, t), {apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the shadow!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[You reach out with shadowy vines toward your target, pulling it to you and silencing it for %d turns and dazing it for 2 turns.
		The chance to hit improves with your Accuracy.]]):
		tformat(duration)
	end,
}

newTalent{
	name = "Ambuscade",
	type = {"spell/other", 1},
	points = 5,
	cooldown = 20,
	stamina = 35,
	mana = 35,
	requires_target = true,
	unlearn_on_clone = true,
	tactical = { ATTACK = {DARKNESS = 3} },
	getStealthPower = function(self, t) return self:combatScale(self:getCun(15, true) * self:getTalentLevel(t), 25, 0, 100, 75) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getHealth = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 20, 500), 1, 0.2, 0, 0.584, 384) end, -- Limit to < 100% health of summoner
	getDam = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 500), 1.6, 0.4, 0, 0.761 , 361) end, -- Limit to <160% Nerf?
	speed = "spell",
	action = function(self, t)
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke your shadow!")
			return
		end

		local m = self:cloneActor({name = ("Shadow of %s"):tformat(self:getName()),
			desc = ([[A dark shadowy form in the shape of %s.]]):tformat(self:getName()),
			summoner=self, summoner_gain_exp=true, exp_worth=0,
			summon_time=t.getDuration(self, t),
			ai_target={actor=nil}, ai="summoned", ai_real="tactical",
			forceLevelup = function() end,
			on_die = function(self) self:removeEffect(self.EFF_ARCANE_EYE,true) end,
			cant_teleport=true,	stealth = t.getStealthPower(self, t),
			force_melee_damage_type = DamageType.DARKNESS,
		
		})
		m:removeTimedEffectsOnClone()
		m:unlearnTalentsOnClone() -- unlearn certain talents (no recursive projections)
		m:unlearnTalentFull(m.T_STEALTH)
		m:unlearnTalentFull(m.T_HIDE_IN_PLAIN_SIGHT)
		m.max_life = m.max_life * t.getHealth(self, t)
		table.mergeAdd(m.resists, {[DamageType.LIGHT]=-70, [DamageType.DARKNESS]=130, all=-30})
		m.inc_damage.all = ((100 + (m.inc_damage.all or 0)) * t.getDam(self, t)) - 100
		m.life = util.bound(m.life, 0, m.max_life)
		m.on_act = function(self)
			if self.summoner.dead or not self:hasLOS(self.summoner.x, self.summoner.y) then
				if not self:hasEffect(self.EFF_AMBUSCADE_OFS) then
					self:setEffect(self.EFF_AMBUSCADE_OFS, 2, {})
				end
			else
				if self:hasEffect(self.EFF_AMBUSCADE_OFS) then
					self:removeEffect(self.EFF_AMBUSCADE_OFS)
				end
			end
		end,

		self:removeEffect(self.EFF_SHADOW_VEIL) -- Remove shadow veil from creator
		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="full",
				type="shadow",
				title=("Shadow of %s"):tformat(self:getName()),
				temporary_level=1,
				orders = {target=true},
				on_control = function(self)
					self.summoner.ambuscade_ai = self.summoner.ai
					self.summoner.ai = "none"
				end,
				on_uncontrol = function(self)
					self.summoner.ai = self.summoner.ambuscade_ai
					game:onTickEnd(function() game.party:removeMember(self) self:removeEffect(self.EFF_ARCANE_EYE, true) self:disappear() end)
				end,
			})
		end
		game:onTickEnd(function() game.party:setPlayer(m) end)

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[You take full control of your own shadow for %d turns.
		Your shadow possesses your talents and stats, has %d%% life and deals %d%% damage, -30%% all resistances, -100%% light resistance and +100%% darkness resistance.
		Your shadow is permanently stealthed (%d power), and all melee damage it deals is converted to darkness damage.
		The shadow cannot teleport.
		If you release control early or if it leaves your sight for too long, your shadow will dissipate.]]):
		tformat(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100, t.getStealthPower(self, t))
	end,
}

newTalent{
	name = "Shadow Leash",
	type = {"spell/other", 1},
	points = 5,
	cooldown = 20,
	stamina = 15,
	mana = 15,
	range = 1,
	tactical = { DISABLE = {disarm = 2} },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	speed = "weapon",
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		if target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the shadow!", target:getName():capitalize())
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[For an instant, your weapons turn into a shadow leash that tries to grab the target's weapon, disarming it for %d turns.
		The chance to hit improves with your Accuracy.]]):
		tformat(duration)
	end,
}

newTalent{
	name = "Dismay",
	type = {"psionic/other", 1},
	mode = "passive",
	points = 1,
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 3.5, 1, 7.83, 2.23) end, -- Limit < 100%
	getDuration = function(self, t)
		return 3
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[Each turn, those caught in your gloom must save against your Mindpower or have an %0.1f%% chance of becoming dismayed for %d turns. When dismayed, the first melee attack against the foe will result in a critical hit.]]):tformat(chance, duration, mindpowerChange)
	end,
}

newTalent{
	name = "Shadow Empathy",
	type = {"cursed/misc", 1},
	points = 5,
	hate = 10,
	cooldown = 25,
	getRandomShadow = function(self, t)
		local shadows = {}
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		end
		return #shadows > 0 and rng.table(shadows)
	end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 10)) end,
	getPower = function(self, t) return 5 + self:combatTalentMindDamage(t, 0, 300) / 8 end,
	on_pre_use = function(self, t) return self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t)
		self:setEffect(self.EFF_SHADOW_EMPATHY, t.getDur(self, t), {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDur(self, t)
		return ([[You are linked to your shadows for %d turns, diverting %d%% of all damage you take to a random shadow.
		Effect increases with Mindpower.]]):
		tformat(duration, power)
	end,
}

newTalent{
	name = "Circle of Blazing Light",
	type = {"spell/other", 2},
	--type = {"celestial/circles", 2},
	--require = divi_req_high2,
	points = 5,
	cooldown = 20,
	positive = 10,
	no_energy = true,
	tactical = { ATTACKAREA = {FIRE = 0.5, LIGHT = 0.5} },
	tactical_imp = { SELF = {POSITIVE = 0.5}, ATTACKAREA = {FIRE = 0.5, LIGHT = 0.5} }, -- debugging transitional
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 2, 15) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t) -- for AI only
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	action = function(self, t)
		local radius = self:getTalentRadius(t)
		local tg = {type="ball", range=0, selffire=true, radius=radius, talent=t}
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.BLAZINGLIGHT, self:spellCrit(t.getDamage(self, t)),
			radius,
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, img="sun_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/sunlight_effect.png"},
			nil, true --self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a circle of radius %d at your feet; the circle lights up affected tiles, increases your positive energy by %d each turn and deals %0.2f light damage and %0.2f fire damage per turn to everyone else within its radius.  The circle lasts %d turns.
		The damage will increase with your Spellpower.]]):
		tformat(radius, 1 + (damage / 4), (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.FIRE, damage)), duration)
	end,
}

newTalent{
	name = "Blur Sight",
	type = {"spell/other", 1},
	mode = "sustained",
	points = 5,
	sustain_mana = 30,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getDefense = function(self, t) return self:combatScale(self:getTalentLevel(t)*self:combatSpellpower(), 0, 0, 28.6, 267, 0.75) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			particle = self:addParticles(Particles.new("phantasm_shield", 1)),
			def = self:addTemporaryValue("combat_def", t.getDefense(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_def", p.def)
		return true
	end,
	info = function(self, t)
		local defence = t.getDefense(self, t)
		return ([[The caster's image blurs, granting a %d bonus to Defense.
		The bonus will increase with your Spellpower.]]):
		tformat(defence)
	end,
}

newTalent{
	name = "Cold Flames",
	type = {"spell/other", 1},
	points = 5,
	mana = 40,
	cooldown = 22,
	range = 5,
	radius = 3,
	tactical = { ATTACK = { COLD = 2 }, DISABLE = { stun = 1 } },
	requires_target = true,
	-- implementation of creeping darkness..used in various locations, but stored here
	canCreep = function(x, y, ignoreCreepingDark)
		-- not on map
		if not game.level.map:isBound(x, y) then return false end
		 -- already dark
		if not ignoreCreepingDark then
			if game.level.map:checkAllEntities(x, y, "coldflames") then return false end
		end
		 -- allow objects and terrain to block, but not actors
		if game.level.map:checkAllEntities(x, y, "block_move") and not game.level.map(x, y, Map.ACTOR) then return false end

		return true
	end,
	doCreep = function(tCreepingDarkness, self, useCreep)
		local start = rng.range(0, 8)
		for i = start, start + 8 do
			local x = self.x + (i % 3) - 1
			local y = self.y + math.floor((i % 9) / 3) - 1
			if not (x == self.x and y == self.y) and tCreepingDarkness.canCreep(x, y) then
				-- add new dark
				local newCreep
				if useCreep then
					 -- transfer some of our creep to the new dark
					newCreep = math.ceil(self.creep / 2)
					self.creep = self.creep - newCreep
				else
					-- just clone our creep
					newCreep = self.creep
				end
				tCreepingDarkness.createDark(self.summoner, x, y, self.damage, self.originalDuration, newCreep, self.creepChance, 0)
				return true
			end

			-- nowhere to creep
			return false
		end
	end,
	createDark = function(summoner, x, y, damage, duration, creep, creepChance, initialCreep)
		local e = Object.new{
			name = _t"cold flames",
			canAct = false,
			canCreep = true,
			x = x, y = y,
			damage = damage,
			originalDuration = duration,
			duration = duration,
			creep = creep,
			creepChance = creepChance,
			summoner = summoner,
			summoner_gain_exp = true,
			act = function(self)
				local Map = require "engine.Map"

				self:useEnergy()

				-- apply damage to anything inside the darkness
				local actor = game.level.map(self.x, self.y, Map.ACTOR)
				if actor and actor ~= self.summoner and (not actor.summoner or actor.summoner ~= self.summoner) then
					self.summoner:project(actor, actor.x, actor.y, engine.DamageType.ICE, self.damage)
					--DamageType:get(DamageType.DARKNESS).projector(self.summoner, actor.x, actor.y, DamageType.DARKNESS, damage)
				end

				if self.duration <= 0 then
					-- remove
					if self.particles then game.level.map:removeParticleEmitter(self.particles) end
					game.level.map:remove(self.x, self.y, Map.TERRAIN+3)
					game.level:removeEntity(self)
					self.coldflames = nil
					--game.level.map:redisplay()
				else
					self.duration = self.duration - 1

					local tCreepingDarkness = self.summoner:getTalentFromId(self.summoner.T_COLD_FLAMES)

					if self.canCreep and self.creep > 0 and rng.percent(self.creepChance) then
						if not tCreepingDarkness.doCreep(tCreepingDarkness, self, true) then
							-- doCreep failed..pass creep on to a neighbor and stop creeping
							self.canCreep = false
							local start = rng.range(0, 8)
							for i = start, start + 8 do
								local x = self.x + (i % 3) - 1
								local y = self.y + math.floor((i % 9) / 3) - 1
								if not (x == self.x and y == self.y) and tCreepingDarkness.canCreep(x, y) then
									local dark = game.level.map:checkAllEntities(x, y, "coldflames")
									if dark and dark.canCreep then
										-- transfer creep
										dark.creep = dark.creep + self.creep
										self.creep = 0
										return
									end
								end
							end
						end
					end
				end
			end,
		}
		e.coldflames = e -- used for checkAllEntities to return the dark Object itself
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN+3, e)

		-- add particles
		e.particles = Particles.new("coldflames", 1, { })
		e.particles.x = x
		e.particles.y = y
		game.level.map:addParticleEmitter(e.particles)

		-- do some initial creeping
		if initialCreep > 0 then
			local tCreepingDarkness = self.summoner:getTalentFromId(summoner.T_COLD_FLAMES)
			while initialCreep > 0 do
				if not tCreepingDarkness.doCreep(tCreepingDarkness, e, false) then
					e.canCreep = false
					e.initialCreep = 0
					break
				end
				initialCreep = initialCreep - 1
			end
		end
	end,

	getDarkCount = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	getDamage = function(self, t)
		return self:combatTalentSpellDamage(t, 10, 90)
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local damage = {dam=t.getDamage(self, t), chance=25}
		local darkCount = t.getDarkCount(self, t)

		local tg = {type="ball", nolock=true, pass_terrain=false, nowarning=true, friendly_fire=true, default_target=self, range=range, radius=radius, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)

		-- get locations in line of movement from center
		local locations = {}
		local grids = core.fov.circle_grids(x, y, radius, true)
		for darkX, yy in pairs(grids) do for darkY, _ in pairs(grids[darkX]) do
			local l = line.new(x, y, darkX, darkY)
			local lx, ly = l()
			while lx and ly do
				if game.level.map:checkAllEntities(lx, ly, "block_move") then break end

				lx, ly = l()
			end
			if not lx and not ly then lx, ly = darkX, darkY end

			if lx == darkX and ly == darkY and t.canCreep(darkX, darkY) then
				locations[#locations+1] = {darkX, darkY}
			end
		end end

		darkCount = math.min(darkCount, #locations)
		if darkCount == 0 then return false end

		for i = 1, darkCount do
			local location, id = rng.table(locations)
			table.remove(locations, id)
			t.createDark(self, location[1], location[2], damage, 8, 4, 70, 0)
		end

		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local darkCount = t.getDarkCount(self, t)
		return ([[Cold Flames slowly spread from %d spots in a radius of %d around the targeted location. The flames deal %0.2f cold damage, and have a chance of freezing.
		Damage improves with your Spellpower.]]):tformat(darkCount, radius, damDesc(self, DamageType.COLD, damage))
	end,
}

newTalent{
	name = "Quicken Spells",
	type = {"spell/other",1},
	points = 5,
	mode = "sustained",
	sustain_mana = 80,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
			cd = self:addTemporaryValue("spell_cooldown_reduction", t.getCooldownReduction(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("spell_cooldown_reduction", p.cd)
		return true
	end,
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[Reduces the cooldown of all spells by %d%%.]]):
		tformat(cooldownred * 100)
	end,
}
