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

newTalent{ short_name = "RITCH_FLAMESPITTER_BOLT",
	name = "Flamespit",
	type = {"wild-gift/other",1},
	points = 5,
	equilibrium = 2,
	message = _t"@Source@ spits flames!",
	range = 10,
	reflectable = true,
	requires_target = true,
	tactical = { ATTACK = { FIRE = 2 } },
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIRE, self:mindCrit(self:combatTalentMindDamage(t, 8, 120)), {type="flame"})
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		return ([[Spits a bolt of fire, doing %0.2f fire damage.
		The damage will increase with your Mindpower.]]):tformat(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}

newTalent{ short_name = "WILD_RITCH_FLAMESPITTER_BOLT",
	name = "Flamespit",
	type = {"wild-gift/other",1},
	points = 5,
	equilibrium = 2,
	message = _t"@Source@ spits flames!",
	range = 10,
	reflectable = true,
	requires_target = true,
	direct_hit = true,
	tactical = { ATTACK = { FIRE = 2 } },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIRE, self:mindCrit(self:combatTalentMindDamage(t, 8, 120)), {type="flame"})
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		return ([[Spits a bolt of fire, doing %0.2f fire damage.
		The damage will increase with your Mindpower.]]):tformat(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}

--No longer on summons but is still used by ants
newTalent{
	name = "Flame Fury", image = "talents/blastwave.png",
	type = {"wild-gift/other",1},
	points = 5,
	eqilibrium = 5,
	cooldown = 5,
	tactical = { ATTACKAREA = 2, DISABLE = 2, ESCAPE = 2 },
	direct_hit = true,
	requires_target = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 28, 180) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, DamageType.FIREKNOCKBACK_MIND, {dist=3, dam=self:mindCrit(t.getDamage(self, t))})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_fire", {radius=tg.radius})
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[A wave of fire emanates from you with radius %d, knocking back anything caught inside and setting them ablaze and doing %0.2f fire damage over 3 turns.
		The damage will increase with your Mindpower.]]):tformat(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

newTalent{
	name = "Acid Breath",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ breathes acid!",
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 0,
	radius = 5,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID, self:mindCrit(self:combatTalentStatDamage(t, "wil", 30, 430)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_acid", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")

		self:startTalentCooldown(self.T_ACID_SPIT_HYDRA, 8)
		return true
	end,
	info = function(self, t)
		return ([[Breathe acid on your foes, doing %0.2f damage.
		The damage will increase with your Willpower.]]):tformat(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}

newTalent{
	name = "Acid Spit", short_name = "ACID_SPIT_HYDRA",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ spits acid!",
	tactical = { ATTACK = { ACID = 2 } },
	range = 5,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID, self:mindCrit(self:combatTalentStatDamage(t, "wil", 30, 430)), {type="acid"})
		game:playSoundNear(self, "talents/breath")

		self:startTalentCooldown(self.T_ACID_BREATH, 8)
		return true
	end,
	info = function(self, t)
		return ([[Spit acid on a foe, doing %0.2f damage.
		The damage will increase with your Willpower.]]):tformat(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}

newTalent{
	name = "Lightning Breath", short_name = "LIGHTNING_BREATH_HYDRA", image = "talents/lightning_breath.png",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ breathes lightning!",
	tactical = { ATTACKAREA = { LIGHTNING = 2 } },
	range = 0,
	radius = 5,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:combatTalentStatDamage(t, "wil", 30, 500)
		self:project(tg, x, y, DamageType.LIGHTNING, self:mindCrit(rng.avg(dam / 3, dam, 3)))
		if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y}, {type="lightning"})
		else game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		end
		game:playSoundNear(self, "talents/lightning")

		self:startTalentCooldown(self.T_LIGHTNING_SPIT_HYDRA, 8)
		return true
	end,
	info = function(self, t)
		return ([[Breathe lightning on your foes, doing %d to %d damage.
		The damage will increase with your Willpower.]]):
		tformat(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}

newTalent{
	name = "Lightning Spit", short_name = "LIGHTNING_SPIT_HYDRA", image = "talents/lightning_breath.png",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ spits lightning!",
	tactical = { ATTACK = { LIGHTNING = 2 } },
	range = 5,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:combatTalentStatDamage(t, "wil", 30, 500)
		self:project(tg, x, y, DamageType.LIGHTNING, self:mindCrit(rng.avg(dam / 3, dam, 3)), {type="lightning_explosion"})
		game:playSoundNear(self, "talents/lightning")

		self:startTalentCooldown(self.T_LIGHTNING_BREATH_HYDRA, 8)
		return true
	end,
	info = function(self, t)
		return ([[Spit lightning on your foe, doing %d to %d damage.
		The damage will increase with your Willpower.]]):
		tformat(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}

newTalent{
	name = "Poison Breath",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ breathes poison!",
	tactical = { ATTACKAREA = { NATURE = 1, poison = 1 } },
	range = 0,
	radius = 5,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.POISON, {dam=self:mindCrit(self:combatTalentStatDamage(t, "wil", 30, 460)), apply_power=self:combatMindpower()})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_slime", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")

		self:startTalentCooldown(self.T_POISON_SPIT_HYDRA, 8)
		return true
	end,
	info = function(self, t)
		return ([[Breathe poison on your foes, doing %d damage over a few turns.
		The damage will increase with your Willpower.]]):tformat(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}

newTalent{
	name = "Poison Spit", short_name = "POISON_SPIT_HYDRA",
	type = {"wild-gift/other",1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	message = _t"@Source@ spits poison!",
	tactical = { ATTACK = { NATURE = 1, poison = 1 } },
	range = 5,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.POISON, {dam=self:mindCrit(self:combatTalentStatDamage(t, "wil", 30, 460)), apply_power=self:combatMindpower(), {type="slime"}})
		game:playSoundNear(self, "talents/breath")

		self:startTalentCooldown(self.T_POISON_BREATH, 8)
		return true
	end,
	info = function(self, t)
		return ([[Spit poison on your foes, doing %d damage over a few turns.
		The damage will increase with your Willpower.]]):tformat(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}

newTalent{
	name = "Winter's Fury",
	type = {"wild-gift/other",1},
	require = gifts_req4,
	points = 5,
	equilibrium = 10,
	cooldown = 4,
	tactical = { ATTACKAREA = { COLD = 2 }, DISABLE = { stun = 1 } },
	range = 0,
	radius = 3,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "wil", 30, 120) end,
	getDuration = function(self, t) return 4 end,
	action = function(self, t)
		local friendlyfire = true
		if self.summoner and self.summoner:knowTalent(self.summoner.T_THROUGH_THE_CROWD) then friendlyfire = false end
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.ICE, t.getDamage(self, t),
			3,
			5, nil,
			{type="icestorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false, friendlyfire
		)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[A furious ice storm rages around the user doing %0.2f cold damage in a radius of 3 each turn for %d turns.
		It has 25%% chance to freeze damaged targets.
		The damage and duration will increase with your Willpower.]]):tformat(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

newTalent{
	name = "Winter's Grasp",
	type = {"wild-gift/other", 1},
	require = gifts_req4,
	points = 5,
	equilibrium = 7,
	cooldown = 5,
	range = 10,
	tactical = { ATTACK = {COLD = 1}, DISABLE = {slow = 1}, CLOSEIN = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:mindCrit(self:combatTalentMindDamage(t, 5, 140))

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			target:pull(self.x, self.y, tg.range)

			DamageType:get(DamageType.COLD).projector(self, target.x, target.y, DamageType.COLD, dam)
			target:setEffect(target.EFF_SLOW_MOVE, t.getDuration(self, t), {apply_power=self:combatMindpower(), power=0.5})
		end)
		game:playSoundNear(self, "talents/ice")

		return true
	end,
	info = function(self, t)
		return ([[Grab a target and pull it next to you, covering it with frost while reducing its movement speed by 50%% for %d turns.
		The ice will also deal %0.2f cold damage.
		The damage and chance to slow will increase with your Mindpower.]]):
		tformat(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentMindDamage(t, 5, 140)))
	end,
}

newTalent{
	name = "Ritch Flamespitter",
	type = {"wild-gift/summon-distance", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ summons a Ritch Flamespitter!",
	equilibrium = 2,
	cooldown = 10,
	range = 5,
	radius = 5, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { ATTACK = { FIRE = 2 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local explodeDamage = self:callTalent(self.T_DETONATE,"explodeSecondary")
		local duration = 3
		self:project(tg, m.x, m.y, DamageType.FLAMESHOCK, {dur=duration,apply_power=self:combatMindpower(),dam=self:mindCrit(explodeDamage)})
		game.level.map:particleEmitter(m.x, m.y, tg.radius, "ball_fire", {radius=tg.radius})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL, "effectDuration")
		local reduction = self:callTalent(self.T_GRAND_ARRIVAL, "resReduction")
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_LOWER_FIRE_RESIST, dur=duration, p={power=reduction}})
		game.level.map:particleEmitter(m.x, m.y, tg.radius, "ball_fire", {radius=tg.radius})
	end,
	incStats = function(self, t, fake)
		local mp = self:combatMindpower()
		return{
			wil=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75),
			cun=15 + (fake and mp or self:mindCrit(mp)) * 1.7 * self:combatTalentScale(t, 0.2, 1, 0.75),
			con=10
		}
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 5, 0, 10, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = self.ai_target.actor
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "insect", subtype = "ritch",
			display = "I", color=colors.LIGHT_RED, image = "npc/summoner_ritch.png",
			name = "ritch flamespitter", faction = self.faction,
			desc = _t[[]],
			autolevel = "none",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},
			ai_tactic = resolvers.tactic"ranged",
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = resolvers.rngavg(5,10),
			life_rating = 8,
			infravision = 10,

			combat_armor = 0, combat_def = 0,
			combat = { dam=1, atk=1, },

			wild_gift_detonate = t.id,

			resolvers.talents{
				[self.T_RITCH_FLAMESPITTER_BOLT]=self:getTalentLevelRaw(t),
			},
			resists = { [DamageType.FIRE] = self:getTalentLevel(t)*10 },

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = ("%s (wild summon)"):tformat(_t(m.name))
			m[#m] = resolvers.talents{ [self.T_WILD_RITCH_FLAMESPITTER_BOLT]=self:getTalentLevelRaw(t) }
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[Summon a Ritch Flamespitter for %d turns to burn your foes to death. Flamespitters are weak in melee and die easily, but they can burn your foes from afar.
		It will get %d Willpower, %d Cunning and %d Constitution.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Willpower and Cunning will increase with your Mindpower.]])
		:tformat(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

newTalent{
	name = "Hydra",
	type = {"wild-gift/summon-distance", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ summons a 3-headed hydra!",
	equilibrium = 5,
	cooldown = 18,
	range = 5,
	radius = 5, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { ATTACK = { ACID = 1, LIGHTING = 1, NATURE = 1 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y, ignore_nullify_all_friendlyfire=true}
		local hydraAffinity = self:callTalent(self.T_DETONATE,"hydraAffinity")
		local hydraRegen = self:callTalent(self.T_DETONATE,"hydraRegen")
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:setEffect(target.EFF_SERPENTINE_NATURE, 7, {power=hydraAffinity, regen=hydraRegen})
		end, nil, {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local poisonDmg = self:callTalent(self.T_GRAND_ARRIVAL, "poisonDamage")
		game.level.map:addEffect(self,
			m.x, m.y, self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration"),
			DamageType.POISON, {dam=poisonDmg, apply_power=self:combatMindpower()},
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/poison_effect.png"},
			nil, false, false
		)
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 5, 0, 10, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{
			wil=15 + (fake and mp or self:mindCrit(mp)) * 1.6 * self:combatTalentScale(t, 0.2, 1, 0.75),
			str = 18,
			con=10 + self:combatTalentScale(t, 2, 10, 0.75)
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = self.ai_target.actor
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "hydra", subtype = "3head",
			display = "M", color=colors.GREEN, image = "npc/summoner_hydra.png",
			name = "3-headed hydra", faction = self.faction,
			desc = _t[[A strange reptilian creature with three smouldering heads.]],
			autolevel = "none",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},

			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = resolvers.rngavg(5,10),
			life_rating = 10,
			infravision = 10,

			combat_armor = 7, combat_def = 0,
			combat = { dam=12, atk=5, },

			resolvers.talents{
				[self.T_LIGHTNING_BREATH_HYDRA]=self:getTalentLevelRaw(t),
				[self.T_ACID_BREATH]=self:getTalentLevelRaw(t),
				[self.T_POISON_BREATH]=self:getTalentLevelRaw(t),
			},

			wild_gift_detonate = t.id,

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = ("%s (wild summon)"):tformat(_t(m.name))
			m[#m+1] = resolvers.talents{ [self.T_LIGHTNING_SPIT_HYDRA]=self:getTalentLevelRaw(t) }
			m[#m+1] = resolvers.talents{ [self.T_ACID_SPIT_HYDRA]=self:getTalentLevelRaw(t) }
			m[#m+1] = resolvers.talents{ [self.T_POISON_SPIT_HYDRA]=self:getTalentLevelRaw(t) }
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[Summon a 3-headed Hydra for %d turns to destroy your foes. 3-headed hydras are able to breathe poison, acid and lightning.
		It will get %d Willpower, %d Constitution and 18 Strength.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Willpower will increase with your Mindpower.]])
		:tformat(t.summonTime(self, t), incStats.wil, incStats.con, incStats.str)
	end,
}

newTalent{
	name = "Rimebark",
	type = {"wild-gift/summon-distance", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ summons a Rimebark!",
	equilibrium = 8,
	cooldown = 10,
	range = 5,
	radius = 3, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { ATTACK =  { COLD = 1 }, DISABLE = { stun = 2 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local explodeDamage = self:callTalent(self.T_DETONATE,"explodeSecondary")
		self:project(tg, m.x, m.y, DamageType.ICE, self:mindCrit(explodeDamage), {type="freeze"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		local reduction = self:callTalent(self.T_GRAND_ARRIVAL,"resReduction")
  		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_LOWER_COLD_RESIST, dur=duration, p={power=reduction}}, {type="flame"})
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_LOWER_COLD_RESIST, dur=duration, p={power=self:combatTalentMindDamage(t, 15, 70)}}, {type="flame"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 5, 0, 10, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{
			wil=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75),
			cun=15 + (fake and mp or self:mindCrit(mp)) * 1.6 * self:combatTalentScale(t, 0.2, 1, 0.75),
			con=10
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		target = self.ai_target.actor
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)

		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "immovable", subtype = "plants",
			display = "#", color=colors.WHITE,
			name = "rimebark", faction = self.faction, image = "npc/immovable_plants_rimebark.png",
			resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/immovable_plants_rimebark.png", display_h=2, display_y=-1}}},
			desc = _t[[This huge treant-like being is embedded with the fury of winter itself.]],
			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, ally_compassion=10},
			ai_tactic = resolvers.tactic"ranged",
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,
			never_move = 1,

			max_life = resolvers.rngavg(120,150),
			life_rating = 16,
			infravision = 10,

			combat_armor = 15, combat_def = 0,
			combat = { dam=resolvers.levelup(resolvers.rngavg(15,25), 1, 1.3), atk=resolvers.levelup(resolvers.rngavg(15,25), 1, 1.3), dammod={cun=1.1} },

			wild_gift_detonate = t.id,

			resolvers.talents{
				[self.T_WINTER_S_FURY]=self:getTalentLevelRaw(t),
			},

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = ("%s (wild summon)"):tformat(_t(m.name))
			m[#m+1] = resolvers.talents{ [self.T_WINTER_S_GRASP]=self:getTalentLevelRaw(t) }
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[Summon a Rimebark for %d turns to harass your foes. Rimebarks cannot move, but they have a permanent ice storm around them, damaging and freezing anything coming close in a radius of 3.
		It will get %d Willpower, %d Cunning and %d Constitution.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Willpower and Cunning will increase with your Mindpower.]])
		:tformat(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

newTalent{
	name = "Fire Drake",
	type = {"wild-gift/summon-distance", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	message = _t"@Source@ summons a Fire Drake!",
	equilibrium = 15,
	cooldown = 10,
	range = 5,
	radius = 5, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { ATTACK = { FIRE = 2 }, DISABLE = { knockback = 1 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local explodeFire = self:callTalent(self.T_DETONATE,"explodeFire")
		game.level.map:addEffect(self,
			m.x, m.y, 6,
			DamageType.FIRE, self:mindCrit(explodeFire),
			self:getTalentRadius(t),
			5, nil,
			{type="inferno"},
			nil, false, false
		)
	end,
	on_arrival = function(self, t, m)
		for i = 1, self:callTalent(self.T_GRAND_ARRIVAL, "nbEscorts") do
			-- Find space
			local x, y = util.findFreeGrid(m.x, m.y, 5, true, {[Map.ACTOR]=true})
			if not x then return end

			local NPC = require "mod.class.NPC"
			local mh = NPC.new{
				type = "dragon", subtype = "fire",
				display = "d", color=colors.RED, image = "npc/dragon_fire_fire_drake_hatchling.png",
				name = "fire drake hatchling", faction = self.faction,
				desc = _t[[A mighty fire drake.]],
				autolevel = "none",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},
				stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
				inc_stats = { -- No crit chance for escorts
					str=15 + self:combatMindpower(2) * self:combatTalentScale(t, 1/6, 5/6, 0.75),
					wil=38,
					con=20 + self:combatMindpower(1.5) * self:combatTalentScale(t, 1/6, 5/6, 0.75),
				},
				level_range = {self.level, self.level}, exp_worth = 0,

				max_life = resolvers.rngavg(40, 60),
				life_rating = 10,
				infravision = 10,

				combat_armor = 0, combat_def = 0,
				combat = { dam=resolvers.levelup(resolvers.rngavg(25,40), 1, 0.6), atk=resolvers.rngavg(25,60), apr=25, dammod={str=1.1} },
				on_melee_hit = {[DamageType.FIRE]=resolvers.mbonus(7, 2)},

				resists = { [DamageType.FIRE] = 100, },

				summoner = self, summoner_gain_exp=true, wild_gift_summon=true, wild_gift_summon_ignore_cap=true,
				summon_time = m.summon_time,
				ai_target = {actor=m.ai_target.actor}
			}
			m.is_nature_summon = true
			setupSummon(self, mh, x, y)

			if self:knowTalent(self.T_RESILIENCE) then
				local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
				m.max_life = m.max_life * incLife
				m.life = m.max_life
			end
		end
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 2, 0, 7, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{
			str=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75),
			wil = 38,
			con=20 + (fake and mp or self:mindCrit(mp)) * 1.5 * self:combatTalentScale(t, 0.2, 1, 0.75)
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = self.ai_target.actor
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "dragon", subtype = "fire",
			display = "D", color=colors.RED, image = "npc/dragon_fire_fire_drake.png",
			name = "fire drake", faction = self.faction,
			desc = _t[[A mighty fire drake.]],
			autolevel = "none",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = resolvers.rngavg(100, 150),
			life_rating = 12,
			infravision = 10,

			combat_armor = 0, combat_def = 0,
			combat = { dam=15, atk=10, apr=15 },

			resists = { [DamageType.FIRE] = 100, },

			wild_gift_detonate = t.id,

			resolvers.talents{
				[self.T_FIRE_BREATH]=self:getTalentLevelRaw(t),
				[self.T_BELLOWING_ROAR]=self:getTalentLevelRaw(t),
				[self.T_WING_BUFFET]=self:getTalentLevelRaw(t),
				[self.T_DEVOURING_FLAME]=self:getTalentLevelRaw(t),
			},

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = ("%s (wild summon)"):tformat(_t(m.name))
			m[#m+1] = resolvers.talents{ [self.T_AURA_OF_SILENCE]=self:getTalentLevelRaw(t) }
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[Summon a Fire Drake for %d turns to burn and crush your foes to death. Fire Drakes are behemoths that can burn foes from afar with their fiery breath.
		It will get %d Strength, %d Constitution and 38 Willpower.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Strength and Constitution will increase with your Mindpower.]])
		:tformat(t.summonTime(self, t), incStats.str, incStats.con)
	end,
}
