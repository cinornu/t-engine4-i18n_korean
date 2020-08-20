-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2020 Nicolas Casalini
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
	name = "Boneyard",
	type = {"spell/eradication",1},
	require = spells_req_high1,
	points = 5,
	soul = 1,
	mana = 30,
	range = 0,
	radius = 5,
	cooldown = 20,
	tactical = { BUFF = 2 },
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	getResist = function(self, t) return math.floor(self:combatTalentScale(t, 5, 15)) end,
	getCooldown = function(self, t) return math.floor(self:combatTalentScale(t, 10, 30)) end,
	getPower = function(self, t) return math.floor(self:combatTalentScale(t, 10, 55)) end,
	getResurrect = function(self, t) return math.floor(self:combatTalentScale(t, 1, 9)) end,
	callbackOnSummonDeath = function(self, t, summon, src, death_note)
		if summon.summoner ~= self or not summon.necrotic_minion or summon.boneyard_resurrected or summon.no_boneyard_resurrect then return end
		local ok = false
		for i, e in ipairs(game.level.map.effects) do
			if e.damtype == DamageType.BONEYARD and e.src == self and e.grids[summon.x] and e.grids[summon.x][summon.y] then ok = true break end
		end		
		if not ok then return end

		if summon.summon_time_max then summon.summon_time = math.ceil(summon.summon_time_max * 0.66) end
		summon.boneyard_resurrected = true
		game.logSeen(summon, "#GREY#%s is resurrected by the boneyard!", summon:getName():capitalize())
		return true
	end,
	action = function(self, t)
		game.level.map:addEffect(self,
			self.x, self.y, 8,
			DamageType.BONEYARD, {resist=t:_getResist(self), cooldown=t:_getCooldown(self), power=t:_getPower(self), resurrect=t:_getResurrect(self)},
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=3, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/boneyard_ground_gfx_3.png"},
			nil,
			true, true
		)
		game:playSoundNear(self, "talents/skeleton")
		return true
	end,
	info = function(self, t)
		return ([[Spawn a boneyard of radius %d around you that lasts for 8 turns.
		Any foes inside gain the brittle bones effect, reducing their physical resistance by %d%% and making all cooldowns %d%% longer.
		When one of your minions stands in the boneyard they gain %d more physical and spell power.
		At level 5 when a minion dies inside the boneyard it has a %d%% chance to resurrect instantly. This effect may only happen once per minion.
		]]):tformat(self:getTalentRadius(t), t:_getResist(self), t:_getCooldown(self), t:_getPower(self), t:_getResurrect(self))
	end,
}

newTalent{
	name = "To The Grave",
	type = {"spell/eradication", 2},
	require = spells_req_high2,
	points = 5,
	cooldown = 20,
	soul = 1,
	mana = 28,
	requires_target = true,
	direct_hit = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 9)) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)} end,
	on_pre_use = function(self, t)
		if not game.level then return false end
		for i, e in ipairs(game.level.map.effects) do
			if e.damtype == DamageType.BONEYARD and e.src == self then return true end
		end		
	end,
	action = function(self, t)
		local boneyard = nil
		for i, e in ipairs(game.level.map.effects) do
			if e.damtype == DamageType.BONEYARD and e.src == self then boneyard = e break end
		end
		if not boneyard then return end

		local tg = self:getTalentTarget(t)
		local list = {}
		self:projectApply(tg, self.x, self.y, Map.ACTOR, function(target, x, y)
			list[#list+1] = {target=target, dist=core.fov.distance(target.x, target.y, boneyard.x, boneyard.y)}
		end, "hostile")
		if #list == 0 then return end
		table.sort(list, "dist")

		local _, _, gs = util.findFreeGrid(boneyard.x, boneyard.y, boneyard.radius, true, {[Map.ACTOR]=true})
		if #gs == 0 then return true end

		while #gs > 0 and #list > 0 do
			local foe = table.remove(list, 1).target
			local spot = table.remove(gs, 1)
			if foe:canBe("teleport") and foe:checkHit(self:combatSpellpower(), foe:combatSpellResist(), 0, 95, 15) then
				foe:forceMoveAnim(spot[1], spot[2])
			else
				game.logSeen(foe, "%s resists the call of the boneyard!", foe:getName():capitalize())
			end
		end

		local nb = t:_getNb(self)
		local t_skeleton = self:getTalentFromId(self.T_CALL_OF_THE_CRYPT)
		local t_ghoul = self:getTalentFromId(self.T_CALL_OF_THE_MAUSOLEUM)
		while #gs > 0 and nb > 0 do
			local spot = table.remove(gs, 1)
			nb = nb - 1
			local m
			if rng.percent(50) then
				m = necroSetupSummon(self, t_ghoul.minions_list.ghoul, spot[1], spot[2], 0, 5, true)
			else
				m = necroSetupSummon(self, t_skeleton.minions_list.skel_warrior, spot[1], spot[2], 0, 5, true)
			end
		end

		return true
	end,	
	info = function(self, t)
		return ([[Teleport all foes in radius %d to your boneyard, as close to its center as possible.
		Up to %d ghouls or skeletons are created around them by the boneyard, without any additional soul cost, but they only last 5 turns.
		]]):tformat(self:getTalentRadius(t), t:_getNb(self))
	end,
}

newTalent{
	name = "Impending Doom",
	type = {"spell/eradication", 3},
	require = spells_req_high3,
	points = 5,
	mana = 50,
	soul = 1,
	cooldown = 25,
	tactical = { ATTACK = { COLD = 2, DARKNESS = 2 }, DISABLE = 2 },
	rnd_boss_restrict = function(self, t, data) return data.level < 15 end,
	range = 7,
	requires_target = true,
	getMax = function(self, t) return 200 + self:combatTalentSpellDamage(t, 28, 850) end,
	getDamage = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 100), 150, 50, 0, 117, 67) end, -- Limit damage factor to < 150%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local dam = target.life * t.getDamage(self, t) / 100
			dam = math.min(dam, t.getMax(self, t))
			target:setEffect(target.EFF_IMPENDING_DOOM, 10, {apply_power=self:combatSpellpower(), dam=dam/10, src=self})
		end, 1, {type="freeze"})
		return true
	end,
	info = function(self, t)
		return ([[Your target's doom draws near. Its healing factor is reduced by 80%%, and will take %d%% of its remaining life (or %0.2f, whichever is lower) over 10 turns as frostdusk damage.
		This spell is so powerful that every 2 turns it tears a part of the target's soul, generating one soul for you.
		The damage will increase with your Spellpower.]]):
		tformat(t.getDamage(self, t), t.getMax(self, t))
	end,
}

newTalent{
	name = "Eternal Night",
	type = {"spell/eradication",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getDamageIncrease = function(self, t) return self:combatTalentScale(t, 2.5, 10) end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 17, 50, true) end,
	getVampiric = function(self, t) return math.floor(self:combatTalentLimit(t, 60, 3, 8)) end,
	callbackPriorities={callbackOnActBase = 100}, -- trigger after most others
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id) if not p then return end
		if p.cur_value > 0 then self:heal(p.cur_value, self) end
		p.cur_value = 0
	end,
	callbackOnDealDamage = function(self, t, value, target, dead, death_node)
		if value <= 0 then return end
		local p = self:isTalentActive(t.id) if not p then return end
		p.cur_value = p.cur_value + value * t:_getVampiric(self) / 100
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local ret = { cur_value = 0 }
		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.DARKNESS] = t.getDamageIncrease(self, t), [DamageType.COLD] = t.getDamageIncrease(self, t)})
		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.DARKNESS] = t.getResistPenalty(self, t), [DamageType.COLD] = t.getResistPenalty(self, t)})

		local particle
		if core.shader.active(4) then
			local p1, p2 = self:talentParticles(ret, 
				{type="shader_ring_rotating", args={rotation=0, radius=1.1, img="spinningwinds_black"}, shader={type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=2.0, verticalIntensityAdjust=-3.0}},
				{type="shader_ring_rotating", args={rotation=0, radius=1.1, img="spinningwinds_black"}, shader={type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=1.0, verticalIntensityAdjust=-3.0}}
			)
			p1.toback = true
		else
			self:talentParticles(ret, {type="ultrashield", args={rm=0, rM=0, gm=0, gM=0, bm=10, bM=100, am=70, aM=180, radius=0.4, density=60, life=14, instop=20}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local affinity = t.getVampiric(self, t)
		return ([[Surround yourself with Frostdusk, increasing all your darkness and cold damage by %0.1f%%, and ignoring %d%% of the darkness and cold resistance of your targets.
		In addition, at the end of each turn you are healed for %d%% of all damage you dealt.]])
		:tformat(damageinc, ressistpen, affinity)
	end,
}
