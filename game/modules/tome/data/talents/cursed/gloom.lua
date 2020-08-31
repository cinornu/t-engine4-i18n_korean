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

local function combatTalentDamage(self, t, min, max)
	return self:combatTalentSpellDamage(t, min, max, self.level + self:getWil())
end

local function getWillFailureEffectiveness(self, minChance, maxChance, attackStrength)
	return attackStrength * self:getWil() * 0.05 * (minChance + (maxChance - minChance) / 2)
end

-- mindpower bonus for gloom talents
local function gloomTalentsMindpower(self)
	return self:combatScale(self:getTalentLevel(self.T_GLOOM) + self:getTalentLevel(self.T_WEAKNESS) + self:getTalentLevel(self.T_MINDROT) + self:getTalentLevel(self.T_SANCTUARY), 1, 1, 40, 20, 0.7)
end

newTalent{
	name = "Gloom",
	type = {"cursed/gloom", 1},
	mode = "sustained",
	require = cursed_wil_req1,
	points = 5,
	cooldown = 0,
	range = 3,
	no_energy = true,
	tactical = { BUFF = 5 },
	getChance = function(self, t) return math.min(25, self:combatScale(self:getTalentLevel(t), 7, 1, 15, 6.5) * math.max(1, self:combatScale(self.combat_mindspeed, 1, 1, 1.35, 1.5))) end,
	getMindpower = gloomTalentsMindpower,
	getDuration = function(self, t)
		return 3
	end,
	activate = function(self, t)
		self.torment_turns = nil -- restart torment
		game:playSoundNear(self, "talents/arcane")
		return {
			particle = self:addParticles(Particles.new("gloom", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	callbackOnActBase = function(self, tGloom)
		-- all gloom effects are handled here
		local tWeakness = self:getTalentFromId(self.T_WEAKNESS)
		local tDismay = self:getTalentFromId(self.T_DISMAY)

		local mindpower = self:combatMindpower()

		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(tGloom), true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local target = game.level.map(x, y, Map.ACTOR)
				if target and self:reactionToward(target) < 0 then
					-- check for hate bonus against tough foes
					if target.rank >= 3.5 and not target.gloom_hate_bonus then
						local hateGain = target.rank >= 4 and 20 or 10
						self:incHate(hateGain)
						game.logPlayer(self, "#F53CBE#Your heart hardens as a powerful foe enters your gloom! (+%d hate)", hateGain)
						target.gloom_hate_bonus = true
					end

					-- Gloom
					if self:getTalentLevel(tGloom) > 0 and rng.percent(tGloom.getChance(self, tGloom)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						local effect = rng.range(1, 3)
						if effect == 1 then
							-- confusion
							if target:canBe("confusion") then
								target:setEffect(target.EFF_GLOOM_CONFUSED, tGloom.getDuration(self, t), {power=30})
							end
						elseif effect == 2 then
							-- stun
							if target:canBe("stun") then
								target:setEffect(target.EFF_GLOOM_STUNNED, tGloom.getDuration(self, t), {})
							end
						elseif effect == 3 then
							-- slow
							if target:canBe("slow") then
								target:setEffect(target.EFF_GLOOM_SLOW, tGloom.getDuration(self, t), {power=0.3})
							end
						end
					end

					-- Weakness
					if self:getTalentLevel(tWeakness) > 0 and rng.percent(tWeakness.getChance(self, tWeakness)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						if not target:hasEffect(target.EFF_GLOOM_WEAKNESS) then
							local duration = tWeakness.getDuration(self, tWeakness)
							local incDamageChange = tWeakness.getIncDamageChange(self, tWeakness)
							local hateBonus = tWeakness.getHateBonus(self, tWeakness)
							target:setEffect(target.EFF_GLOOM_WEAKNESS, duration, {incDamageChange=incDamageChange,hateBonus=hateBonus})
						end
					end

					-- Dismay
					if self:getTalentLevel(tDismay) > 0 and rng.percent(tDismay.getChance(self, tDismay)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						target:setEffect(target.EFF_DISMAYED, tDismay.getDuration(self, tDismay), {})
					end

				end
			end
		end

	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[A terrible gloom surrounds you, affecting all those who approach to within radius 3. At the end of each game turn, those caught in your gloom must save against your Mindpower, or have a %d%% chance to suffer from slowness (30%%), stun or confusion (30%%) for %d turns.
		The chance increases with your mind speed.
		This ability is innate, and carries no cost to activate or deactivate.
		Each point in Gloom talents increases your Mindpower (current total: %d).]]):tformat(chance, duration, mindpowerChange)
	end,
}

newTalent{
	name = "Weakness",
	type = {"cursed/gloom", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	getChance = function(self, t) return math.min(25, self:combatScale(self:getTalentLevel(t), 7, 1, 15, 6.5) * math.max(1, self:combatScale(self.combat_mindspeed, 1, 1, 1.35, 1.5))) end,
	getDuration = function(self, t)
		return 3
	end,
	getIncDamageChange = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 65, 12, 1, 26.8, 2.23) end, -- Limit to <65%
	getHateBonus = function(self, t)
		return 2
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local incDamageChange = t.getIncDamageChange(self, t)
		local hateBonus = t.getHateBonus(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[Each turn, those caught in your gloom must save against your Mindpower, or have a %d%% chance to be crippled by fear for %d turns, reducing damage they inflict by %d%%. The first time you melee strike a foe after they have been weakened will give you %d hate.
		The chance increases with your mind speed.
		Each point in Gloom talents increases your Mindpower (current total: %d).]]):tformat(chance, duration, -incDamageChange, hateBonus, mindpowerChange)
	end,
}

newTalent{
	name = "Mindrot",
	image = "talents/dismay.png",
	type = {"cursed/gloom", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 3, 35) end,
	radius = function(self, t) return 3 end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	hasFoes = function(self)
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 then return true end
		end
		return false
	end,
	callbackOnActBase = function(self, t)
		if self:isTalentActive(self.T_GLOOM) and t.hasFoes(self) then
			local tg = self:getTalentTarget(t)
			local damage = self:mindCrit(t.getDamage(self, t) * 0.5)
			damage = damage * (self.global_speed or 1)
			self:projectSource(tg, self.x, self.y, DamageType.MIND, damage, nil, t)
			self:projectSource(tg, self.x, self.y, DamageType.DARKNESS, damage, nil, t)
		end
	end,
	info = function(self, t)
		return ([[Every turn, all enemies in your gloom take %0.2f mind damage and %0.2f darkness damage.
		This damage is increased by your global speed but only happens ever game turn.
		The damage scales with your Mindpower.
		Each point in Gloom talents increases your Mindpower (current total: %d).]]):tformat(damDesc(self, DamageType.MIND, t.getDamage(self, t) * 0.5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) * 0.5), gloomTalentsMindpower(self))
	end,
}

newTalent{
	name = "Sanctuary",
	type = {"cursed/gloom", 4},
	mode = "passive",
	require = cursed_wil_req4,
	points = 5,
	getDamageChange = function(self, t)
		return math.max(-35, -math.sqrt(self:getTalentLevel(t)) * 11)
	end,
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[Your gloom has become a sanctuary from the outside world. Damage from any attack that originates beyond the boundary of your gloom is reduced by %d%%.
		Each point in Gloom talents increases your Mindpower (current total: %d).]]):tformat(-damageChange, mindpowerChange)
	end,
}
