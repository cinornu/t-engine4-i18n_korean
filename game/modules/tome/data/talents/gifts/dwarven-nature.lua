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
	name = "Earthen Missiles", short_name = "DWARVEN_HALF_EARTHEN_MISSILES",
	type = {"spell/other",1},
	points = 5,
	mana = 10,
	cooldown = 2,
	tactical = { ATTACK = { PHYSICAL = 1, cut = 1} },
	range = 10,
	direct_hit = true,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 200) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="stone_shards", trail="earthtrail"}, friendlyfire=false, friendlyblock=false}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local damage = t.getDamage(self, t)
		self:projectile(tg, x, y, DamageType.SPLIT_BLEED, self:spellCrit(damage), nil)
		game:playSoundNear(self, "talents/earth")
		--missile #2
		local tg2 = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="stone_shards", trail="earthtrail"}, friendlyfire=false, friendlyblock=false}
		local x, y = self:getTarget(tg2)
		if x and y then
			self:projectile(tg2, x, y, DamageType.SPLIT_BLEED, self:spellCrit(damage), nil)
			game:playSoundNear(self, "talents/earth")
		end
		--missile #3 (Talent Level 5 Bonus Missile)
		if self:getTalentLevel(t) >= 5 then
			local tg3 = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="stone_shards", trail="earthtrail"}, friendlyfire=false, friendlyblock=false}
			local x, y = self:getTarget(tg3)
			if x and y then
				self:projectile(tg3, x, y, DamageType.SPLIT_BLEED, self:spellCrit(damage), nil)
				game:playSoundNear(self, "talents/earth")
			end
		else end
		return true
	end,
	info = function(self, t)
		local count = 2
		if self:getTalentLevel(t) >= 5 then
			count = count + 1
		end
		local damage = t.getDamage(self, t)
		return ([[Conjures %d missile-shaped rocks that you target individually at any target or targets in range.  Each missile deals %0.2f physical damage, and an additional %0.2f bleeding damage every turn for 5 turns.
		At talent level 5, you can conjure one additional missile.
		The damage will increase with your Spellpower.]]):tformat(count,damDesc(self, DamageType.PHYSICAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/12))
	end,
}

newTalent{
	name = "Elemental Split",
	type = {"wild-gift/dwarven-nature", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 20,
	cooldown = 30,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	on_pre_use = function(self, t)
		if self:hasEffect(self.EFF_DEEPROCK_FORM) then return false end
		local cryst = game.party:findMember{type="dwarven nature crystaline half"}
		local stone = game.party:findMember{type="dwarven nature stone half"}
		if cryst or stone then return false end
		return true
	end,
	unlearn_on_clone = true,
	action = function(self, t)
		local nb_halves = 0

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if x then
			local m = require("mod.class.NPC").new(self:cloneActor{
				shader = "shadow_simulacrum", shader_args = {time_factor=1000, base=0.5, color={0.6, 0.3, 0.6}},
				summoner=self, summoner_gain_exp=true, exp_worth=0,
				max_level=self.level,
				summon_time=t.getDuration(self, t),
				ai_target={actor=nil},
				ai="summoned", ai_real="tactical",
				name=("Crystaline Half (%s)"):tformat(self:getName()),
				desc=([[A crystaline structure that has taken the form of %s.]]):tformat(self:getName()),
			})
			local tids = table.keys(m.talents)
			for i, tid in ipairs(tids) do
				if tid ~= m.T_STONESHIELD and tid ~= m.T_ARMOUR_TRAINING then
					m:unlearnTalentFull(tid)
				end
			end
			
			m:learnTalent(m.T_DWARVEN_HALF_EARTHEN_MISSILES, true, self:getTalentLevelRaw(t))

			if self:knowTalent(self.T_POWER_CORE) then
				m:learnTalent(m.T_RAIN_OF_SPIKES, true, math.floor(self:getTalentLevel(self.T_POWER_CORE)))
			end
			if self:knowTalent(self.T_DWARVEN_UNITY) and self:getTalentLevel(self.T_WEAPON_COMBAT) > 0 then
				m:learnTalent(m.T_WEAPON_COMBAT, true, math.floor(self:getTalentLevel(self.T_WEAPON_COMBAT)))
			end

			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "shadow")
			nb_halves = nb_halves + 1

			if game.party:hasMember(self) then
				game.party:addMember(m, {
					control="no",
					type="dwarven nature crystaline half",
					title=_t"Crystaline Half",
					orders = {target=true},
				})
			end
		end

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if x then
			local m = require("mod.class.NPC").new(self:cloneActor{
				shader = "shadow_simulacrum", shader_args = {time_factor=-8000, base=0.5, color={0.6, 0.4, 0.3}},
				summoner=self, summoner_gain_exp=true, exp_worth=0,
				max_level=self.level,
				summon_time=t.getDuration(self, t),
				ai_target={actor=nil},
				ai="summoned", ai_real="tactical",
				name=("Stone Half (%s)"):tformat(self:getName()),
				desc=([[A stone structure that has taken the form of %s.]]):tformat(self:getName()),
			})
			local tids = table.keys(m.talents)
			for i, tid in ipairs(tids) do
				if tid ~= m.T_STONESHIELD and tid ~= m.T_ARMOUR_TRAINING then
					m:unlearnTalent(tid, m:getTalentLevelRaw(tid))
				end
			end
			m.talent_cd_reduction={[m.T_TAUNT]=3},
			m:learnTalent(m.T_TAUNT, true, self:getTalentLevelRaw(t))
			
			if self:knowTalent(self.T_POWER_CORE) then
				m:learnTalent(m.T_STONE_LINK, true, math.floor(self:getTalentLevel(self.T_POWER_CORE)))
			end
			if self:knowTalent(self.T_DWARVEN_UNITY) and self:getTalentLevel(self.T_WEAPON_COMBAT) > 0 then
				m:learnTalent(m.T_WEAPON_COMBAT, true, math.floor(self:getTalentLevel(self.T_WEAPON_COMBAT)))
			end

			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "shadow")
			nb_halves = nb_halves + 1

			if game.party:hasMember(self) then
				game.party:addMember(m, {
					control="no",
					type="dwarven nature stone half",
					title=_t"Stone Half",
					orders = {target=true},
				})
			end
		end

		if nb_halves == 0 then return end

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[Reach inside your dwarven core and summon your stone and crystaline halves to fight alongside you for %d turns.
		Your Crystaline Half will attack your foes with earthen missiles.
		Your Stone Half will taunt your foes to protect you.
		This power can not be called upon while under the effect of Deeprock Form.
		]]):tformat(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Power Core",
	type = {"wild-gift/dwarven-nature", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
	info = function(self, t)
		return ([[Your halves learn new talents.
		Crystaline Half: Rain of Spikes - A massive effect that makes all nearby foes bleed.
		Stone Half: Stone Link - A protective shield that will redirect all damage against nearby allies to your Stone Half.
		The level of those talents is %d.]]):
		tformat(math.floor(self:getTalentLevel(t)))
	end,
}

newTalent{
	name = "Dwarven Unity",
	type = {"wild-gift/dwarven-nature", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 10,
	cooldown = 6,
	tactical = { ATTACK = 2, PROTECT = 2 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	on_pre_use = function(self, t)
		local cryst = game.party:findMember{type="dwarven nature crystaline half"}
		local stone = game.party:findMember{type="dwarven nature stone half"}

		if not cryst and not stone then return false end
		return true
	end,
	action = function(self, t)
		local cryst = game.party:findMember{type="dwarven nature crystaline half"}
		local stone = game.party:findMember{type="dwarven nature stone half"}

		if cryst then
			self:project({type="ball", radius=self:getTalentRadius(t), friendlyfire=false}, self.x, self.y, function(px, py)
				local target = game.level.map(px, py, Map.ACTOR)
				if not target then return end

				cryst:forceUseTalent(cryst.T_DWARVEN_HALF_EARTHEN_MISSILES, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=self:getTalentLevelRaw(t), ignore_ressources=true})
			end)
		end

		if stone then
			if self:hasLOS(stone.x, stone.y, 10) then
				game.level.map:remove(self.x, self.y, Map.ACTOR)
				game.level.map:remove(stone.x, stone.y, Map.ACTOR)
				game.level.map(self.x, self.y, Map.ACTOR, stone)
				game.level.map(stone.x, stone.y, Map.ACTOR, self)
				self.x, self.y, stone.x, stone.y = stone.x, stone.y, self.x, self.y
				game.level.map:particleEmitter(stone.x, stone.y, 1, "teleport")
				game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
			end

			self:project({type="ball", radius=self:getTalentRadius(t), friendlyfire=false}, self.x, self.y, function(px, py)
				local target = game.level.map(px, py, Map.ACTOR)
				if not target then return end
				target:setTarget(stone)
			end)
		end

		return true
	end,
	info = function(self, t)
		return ([[You call upon the immediate help of your Halves.
		Your Stone Half will trade places (if in sight) with you and all creatures currently targetting you in a radius of %d will target it instead.
		Your Crystaline Half will instantly fire a volley of level %d earthen missiles at all foes near the stone half (or you if the stone half is dead) in radius %d.
		In addition, as passive effect, your halves now also learn your level of Combat Accuracy.]]):
		tformat(self:getTalentRadius(t), self:getTalentLevelRaw(t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Mergeback",
	type = {"wild-gift/dwarven-nature", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 10,
	cooldown = 20,
	no_npc_use = true,
	radius = 3,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9, "log")) end,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "wil", 60, 330) end,
	getHeal = function(self, t) return self:combatTalentStatDamage(t, "wil", 60, 330) end,
	on_pre_use = function(self, t)
		local cryst = game.party:findMember{type="dwarven nature crystaline half"}
		local stone = game.party:findMember{type="dwarven nature stone half"}

		if not cryst and not stone then return false end
		return true
	end,
	action = function(self, t)
		local cryst = game.party:findMember{type="dwarven nature crystaline half"}
		local stone = game.party:findMember{type="dwarven nature stone half"}
		local nb = (cryst and 1 or 0) + (stone and 1 or 0)

		if cryst then cryst:die() end
		if stone then stone:die() end

		local target = self

		local effs = {}
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if (e.type == "magical" or e.type == "mental" or e.type == "physical") and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end

		self:heal((self:mindCrit(t.getHeal(self, t) * nb)))

		self:project({type="ball", radius=self:getTalentRadius(t), friendlyfire=false}, self.x, self.y, DamageType.NATURE, self:mindCrit(t.getDamage(self, t)) * nb)
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "generic_ball", {radius=self:getTalentRadius(t), rm=0, rM=0, gm=200, gM=250, bm=100, bM=170, am=200, aM=255})

		game:playSoundNear(self, "talents/stone")
		return true
	end,
	info = function(self, t)
		local nb = t.getRemoveCount(self, t)
		local dam = t.getDamage(self, t)
		local heal = t.getHeal(self, t)
		return ([[Merges your halves back into you, cleansing your body of %d detrimental magical, mental or physical effects.
		Each half also heals you for %d and releases a shockwave dealing %0.2f Nature damage in a radius 3.]]):
		tformat(nb, heal, damDesc(self, DamageType.NATURE, dam))
	end,
}


-----------------------------------------------------------
-- Halves talents
-----------------------------------------------------------
newTalent{
	name = "Stone Link",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 10,
	cooldown = 10,
	tactical = { BUFF = 2, },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	requires_target = false,
	action = function(self, t)
		self:setEffect(self.EFF_STONE_LINK_SOURCE, 5, {rad=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/stone")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a shield of radius %d that redirects all damage done to friends inside it to you for 5 turns.]]):tformat(radius)
	end,
}

newTalent{
	name = "Rain of Spikes",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 10,
	cooldown = 6,
	requires_target = true,
	tactical = { ATTACKAREA = {PHYSICAL=2}, },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "wil", 60, 330) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), friendlyfire=false} end,
	action = function(self, t)
		self:project(self:getTalentTarget(t), self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			if target:canBe("cut") then
				target:setEffect(target.EFF_CUT, 6, {src = self, apply_power=self:combatMindpower(), power=self:mindCrit(t.getDamage(self, t))/6})
			end
		end, nil, {type="stone_spikes"})
		game:playSoundNear(self, "talents/stone")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[Fires spikes all around you, making your foes within radius %d bleed for %0.2f damage over 6 turns.
		Damage and chance to apply the effect increase with Willpower.]]):tformat(radius, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}
