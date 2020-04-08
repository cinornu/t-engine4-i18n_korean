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

local function combatTalentPhysicalMindDamage(self, t, b, s)
	return math.max(self:combatTalentMindDamage(t, b, s), self:combatTalentPhysicalDamage(t, b, s))
end

newTalent{
	name = "Resolve",
	type = {"wild-gift/antimagic", 1},
	require = gifts_req1,
	mode = "passive",
	points = 5,
	getRegen = function(self, t) return 1 end,
	getResist = function(self, t) return 5 + combatTalentPhysicalMindDamage(self, t, 15, 30) end,  -- This can crit
	on_absorb = function(self, t, damtype)
		if not DamageType:get(damtype).antimagic_resolve then return end
		local max = self:getTalentLevel(t) >= 3 and 3 or 1
		self:incEquilibrium(-t.getRegen(self, t))
		self:incStamina(t.getRegen(self, t))
		local eff = self:hasEffect(self.EFF_RESOLVE)

		-- Only calculate the resistance once for simplicity and to avoid crit spam
		if not eff then
			self:setEffect(self.EFF_RESOLVE, 7, {damtype=damtype, res=self:mindCrit(t.getResist(self, t)), max_types = max})
		else
			self:setEffect(self.EFF_RESOLVE, 7, {damtype=damtype, res=eff.res, max_types = max})
		end

		--game.logSeen(self, "%s is invigorated by the attack!", self:getName():capitalize())  Too spammy, delayedLog maybe?

	end,
	info = function(self, t)
		local resist = t.getResist(self, t)
		local regen = t.getRegen(self, t)
		return([[You stand in the way of magical damage. That which does not kill you will make you stronger.
		When you are hit by hostile non-physical, non-mind damage you gain %d%% resistance to that element for 7 turns.
		At talent level 3, the bonus resistance may apply to 3 elements, refreshing the duration with each element added.
		Additionally, each time you take non-physical, non-mind damage, your equilibrium will decrease and stamina increase by %0.2f.
		The effects will increase with the greater of your Mindpower or Physical power and the bonus resistance can be a mental crit.]]):
		tformat(	resist, regen )
	end,
}

newTalent{
	name = "Antimagic Zone",
	short_name = "AURA_OF_SILENCE",
	type = {"wild-gift/antimagic", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 20,
	cooldown = 12,
	tactical = { DISABLE = { silence = 4 } },
	range = 6,
	radius = function(self, t) return 3 end,
	getduration = function(self, t) return 3 end,
	getFloorDuration = function(self, t) return 6 end,
	getDamage = function(self, t) return combatTalentPhysicalMindDamage(self, t, 1, 110) end,
	getEquiRegen = function(self, t) return math.floor(self:combatTalentScale(t, 5, 20)) end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)

		local nb = 0
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				if target:canBe("silence") then
					target:setEffect(target.EFF_SILENCED, math.ceil(t.getduration(self,t)), {apply_power=math.max(self:combatMindpower(), self:combatPhysicalpower())})
					if target:hasEffect(target.EFF_SILENCED) then nb = nb + 1 end
				else
					game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
				end
			end
		end)
		game.level.map:addEffect(self, x, y, t.getFloorDuration(self, t), DamageType.MANABURN, self:mindCrit(t.getDamage(self, t)), self:getTalentRadius(t), 5, nil, 
			MapEffect.new{color_br=204, color_bg=51, color_bb=255, effect_shader="shader_images/retch_effect.png"}, nil, true)
		nb = util.bound(nb, 0, 5)
		local regen = -t.getEquiRegen(self, t) * nb
		if nb > 0 then game:onTickEnd(function() self:incEquilibrium(regen) end) end
		game.level.map:particleEmitter(x, y, 1, "shout", {size=4, distorion_factor=0.3, radius=self:getTalentRadius(t), life=30, nb_circles=8, rm=0.8, rM=1, gm=0, gM=0, bm=0.5, bM=0.8, am=0.6, aM=0.8})
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[Let out a burst of sound that silences for %d turns all those affected in a radius of %d.
		Each turn for %d turns the effected area will cause %0.2f manaburn damage to all creatures inside.
		For each creature silenced your equilibrium is reduced by %d (up to 5 times).
		The damage and apply power will increase with the greater of your Mindpower or Physical power.

		Learning this talent will let your Nature damage and penetration bonuses apply to all Manaburn damage regardless of source.]]):
		tformat(t.getduration(self,t), rad, t.getFloorDuration(self,t), t.getDamage(self, t), t.getEquiRegen(self, t))
	end,
}

newTalent{
	name = "Antimagic Shield",
	type = {"wild-gift/antimagic", 3},
	require = gifts_req3,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 30,
	cooldown = 6,
	tactical = { DEFEND = 2 },
	getMax = function(self, t)
		local v = combatTalentPhysicalMindDamage(self, t, 20, 85)
		if self:knowTalent(self.T_TRICKY_DEFENSES) then
			v = v * (1 + self:callTalent(self.T_TRICKY_DEFENSES, "shieldmult"))
		end
		return v
	end,
	on_damage = function(self, t, damtype, dam, src)
		if not DamageType:get(damtype).antimagic_resolve then return dam end

		if dam <= self.antimagic_shield then
			self:incEquilibrium(dam / 30)
			dam = 0
		else
			self:incEquilibrium(self.antimagic_shield / 30)
			dam = dam - self.antimagic_shield
		end

		if not self:equilibriumChance() then
			self:forceUseTalent(self.T_ANTIMAGIC_SHIELD, {ignore_energy=true})
			game.logSeen(self, "#GREEN#The antimagic shield of %s crumbles.", self:getName())
		end
		return dam
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local ret = {
			am = self:addTemporaryValue("antimagic_shield", t.getMax(self, t)),
		}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="antimagic_shield"}, shader={type="rotatingshield", noup=2.0, cylinderRotationSpeed=1.7, appearTime=0.2}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="antimagic_shield"}, shader={type="rotatingshield", noup=1.0, cylinderRotationSpeed=1.7, appearTime=0.2}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("antimagic_shield", p.am)
		return true
	end,
	info = function(self, t)
		return ([[Surround yourself with a shield that will absorb at most %d non-physical, non-mind element damage per attack.
		Each time damage is absorbed by the shield, your equilibrium increases by 1 for every 30 points of damage and a standard Equilibrium check is made. If the check fails, the shield will crumble and Antimagic Shield will go on cooldown.
		The damage the shield can absorb will increase with your Mindpower or Physical power (whichever is greater).]]):
		tformat(t.getMax(self, t))
	end,
}

newTalent{
	name = "Mana Clash",
	type = {"wild-gift/antimagic", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = -15,
	cooldown = 15,
	range = 10,
	tactical = { ATTACK = { ARCANE = 3 } },
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return combatTalentPhysicalMindDamage(self, t, 10, 460) end,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:canProject(tg, x, y) then return end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			local base = self:mindCrit(t.getDamage(self, t))
			DamageType:get(DamageType.MANABURN).projector(self, px, py, DamageType.MANABURN, base)
		
			if self:knowTalent(self.T_ANTIMAGIC_ADEPT) then
				target:removeSustainsFilter(function(o)
					if o.is_spell then return true else return false end
				end, 4)
			end
		end, nil, {type="slime"})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local base = t.getDamage(self, t)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4
		local is_adept = self:knowTalent(self.T_ANTIMAGIC_ADEPT) and _t"\n#GREEN#Antimagic Adept:  #LAST#4 magical sustains from the target will be removed." or ""
		return ([[Drain %d mana, %d vim, %d positive and negative energies from your target, triggering a chain reaction that explodes in a burst of arcane damage.
		The damage done is equal to 100%% of the mana drained, 200%% of the vim drained, or 400%% of the positive or negative energy drained, whichever is higher. This effect is called a manaburn.
		The effect will increase with your Mindpower or Physical power (whichever is greater).
		%s]]):
		tformat(mana, vim, positive, is_adept)
	end,
}

-- Player-specific granted by quest to avoid introducing more hard dispel into the game
newTalent{
	name = "Antimagic Adept", image = "talents/mana_clash.png",
	type = {"wild-gift/other", 1},
	mode = "passive",
	points = 1,
	info = function(self, t)
		return ([[Your Mana Clash talent also removes 4 magical sustains from the target.]]):
		tformat()
	end,
}