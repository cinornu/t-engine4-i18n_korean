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
	name = "Dire Plague",
	type = {"spell/age-of-dusk",1},
	require = spells_req_high1,
	points = 5,
	soul = 1,
	mana = 25,
	range = 0,
	cooldown = 20,
	tactical = { ATTACKAREA={DARKNESS=2}, SOUL=1 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, friendlyfire=false} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 70) end,
	getChance = function(self, t) return self:combatTalentScale(t, 2, 7) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local mult = 100
		if self:knowTalent(self.T_THE_END_OF_ALL_HOPE) then
			mult = 100 + self:callTalent(self.T_THE_END_OF_ALL_HOPE, "getChance")
		end
		self:projectApply(tg, self.x, self.y, Map.ACTOR, function(target)
			target:setEffect(target.EFF_DIRE_PLAGUE, 5, {src=self, apply_power=self:combatSpellpower(), dam=t:_getDamage(self), chance=t:_getChance(self) * mult / 100})
		end)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[You unleash the glorious vision of the past when the continent was filled with death and plagues.
		All foes in range %d catch a dire plague for 5 turns, dealing %0.2f darkness damage each turn.
		The Dire Plague is considered a disease but is not prevented by disease immunity.
		Every turn there is a %d%% chance of a piece of the soul to be ripped away, increasing your souls by 1.
		]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t:_getDamage(self)), t:_getChance(self))
	end,
}

newTalent{
	name = "Crepuscule",
	type = {"spell/age-of-dusk", 2},
	require = spells_req_high2,
	points = 5,
	mana = 30,
	soul = 2,
	cooldown = 20,
	tactical = { ATTACK = { COLD = 2, DARKNESS = 2 }, DISABLE = { blind = 2 } },
	range = 0,
	radius = 7,
	requires_target = true,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 8)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 170) end,
	trigger = function(self, t, target)
		-- Find targets
		if not target then
			local targets = table.listify(self:projectCollect({type="ball", radius=self:getTalentRadius(t)}, self.x, self.y, Map.ACTOR, "hostile"))
			if #targets == 0 then return end
			table.sort(targets, function(a, b) return a[2].dist < b[2].dist end)
			target = targets[#targets][1]
		end

		local dam = self:spellCrit(t:_getDamage(self))
		self:projectApply({type="beam", range=self:getTalentRadius(t), friendlyfire=false}, target.x, target.y, Map.ACTOR, function(target)
			if DamageType:get(DamageType.DARKNESS).projector(self, target.x, target.y, DamageType.DARKNESS, dam) > 0 then
				if rng.percent(25) then
					if target:canBe("blind") then target:setEffect(target.EFF_BLINDED, 4, {apply_power=self:combatSpellpower()})
					else game.logSeen(target, "%s resists the crepuscule!", target:getName():capitalize()) end
				end
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "shadow_beam", {tx=target.x-self.x, ty=target.y-self.y})
	end,
	action = function(self, t)
		self:setEffect(self.EFF_CREPUSCULE, t:_getDur(self), {})
		return true
	end,
	info = function(self, t)
		return ([[You call upon an eerie night to aid you for %d turns.
		Each turn you automatically fire a beam of darkness towards a random foe (prioritizing the ones further away) that deals %0.2f darkness damage and has 25%% chance to blind any foes caught inside for 4 turns.
		The damage will increase with your Spellpower.]]):
		tformat(t:_getDur(self), damDesc(self, DamageType.DARKNESS, t:_getDamage(self)))
	end,
}


newTalent{
	name = "The End of All Hope",
	type = {"spell/age-of-dusk", 3},
	require = spells_req_high3,
	points = 5,
	mode = "passive",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 9)) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getChance = function(self, t) return math.floor(self:combatTalentScale(t, 30, 80)) end,
	info = function(self, t)
		return ([[Whenever one of your Dire Plague rips a soul it feels the inescapable coming of the end.
		When this happens the darkness damage of the plague is a critical hit and all Dire Plagues in radius %d around it (including itself) have their durations increased by %d turns.
		The duration increase may happen only once per turn.
		If Crepuscule is currently active it fires an additional free beam at the target.
		In addition the chance to rip a soul by Dire Plague increases by %d%%.
		]]):tformat(self:getTalentRadius(t), t:_getDur(self), t:_getChance(self))
	end,
}

newTalent{
	name = "Golden Age of Necromancy",
	type = {"spell/age-of-dusk",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getImmune = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 20, 50)) end,
	getSaves = function(self, t) return math.floor(self:combatTalentScale(t, 10, 55)) end,
	callbackOnAct = checkLifeThreshold(1, function(self, t)
		if self:getTalentLevel(t) < 5 then return end
		self:setEffect(self.EFF_GOLDEN_AGE_OF_NECROMANCY, 1, {})
		return true
	end),
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local ret = { }
		self:talentTemporaryValue(ret, "combat_physresist", t:_getSaves(self))
		self:talentTemporaryValue(ret, "combat_spellresist", t:_getSaves(self))
		self:talentTemporaryValue(ret, "combat_mentalresist", t:_getSaves(self))
		self:talentTemporaryValue(ret, "confusion_immune", t:_getImmune(self)/100)
		self:talentTemporaryValue(ret, "teleport_immune", t:_getImmune(self)/100)

		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true, size_factor=1.5, img="golden_age_of_necromacy"}, shader={type="tentacles", appearTime=0.6, time_factor=1000, noup=0.0}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[You recall the age long gone where necromancers had free reign over the world.
		Increases all saves by %d, confusion and teleport resistances by %d%%.
		At level 5 any time you cross the 1 life threshold you become invulnerable for 1 turns.]])
		:tformat(t:_getSaves(self), t:_getImmune(self))
	end,
}
