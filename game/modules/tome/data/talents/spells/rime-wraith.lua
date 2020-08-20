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
	name = "Rime Wraith",
	type = {"spell/rime-wraith",1},
	require = spells_req_high1,
	points = 5,
	soul = 3,
	mana = 15,
	range = 10,
	cooldown = 30,
	fixed_cooldown = true,
	tactical = { BUFF = 2 },
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 10, 20)) end,
	getResist = function(self, t) return math.floor(self:combatTalentScale(t, 5, 15)) end,
	getDamageIncrease = function(self, t) return math.floor(self:combatTalentScale(t, 12, 30)) end,
	getSlow = function(self, t) return math.floor(self:combatTalentScale(t, 20, 40)) end,
	createWraith = function(self, t, target, effid, dur)
		local permafrost, permafrost_huge = nil
		if self:knowTalent(self.T_PERMAFROST) then
			permafrost = self:callTalent(self.T_PERMAFROST, "getSaves")
			permafrost_huge = self:getTalentLevel(self.T_PERMAFROST) >= 5
		end
		target:setEffect(target[effid], dur or t:_getDur(self), {src=self, resists=t:_getResist(self), dam=t:_getDamageIncrease(self), slow=t:_getSlow(self), permafrost=permafrost, permafrost_huge=permafrost_huge})
	end,
	action = function(self, t)
		t:_createWraith(self, self, "EFF_RIME_WRAITH", nil)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[You summon a Rime Wraith inside of you, an intangible creature, that haunts both foes and allies for %d turns.
		Every turn the wraith will select a new target and jump to it.
		When the wraith enters a creature they are covered in hoarfrost for 3 turns:
		- if friendly: increases cold resistance by %d%%, converts all damage done to cold and increases cold damage by %d%%.
		- if hostile: reduces cold resistance by %d%% and move %d%% slower
		When selecting a target the wraith prefers one that is not affected by hoarfrost if possible.
		]]):tformat(t:_getDur(self), t:_getResist(self)*2, t:_getDamageIncrease(self), t:_getResist(self), t:_getSlow(self))
	end,
}

newTalent{
	name = "Frigid Plunge",
	type = {"spell/rime-wraith", 2},
	require = spells_req_high2,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 100) end,
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	info = function(self, t)
		return ([[When switching targets your rime wraith now always prefers the one farther away if possible.
		Any creatures on the path of the wraith while it travels are affected:
		- if friendly: they are healed for %d
		- if hostile: they take %0.2f cold damage
		The damage and healing will increase with your Spellpower.]]):
		tformat(t:_getHeal(self), damDesc(self, DamageType.COLD, t:_getDamage(self)))
	end,
}

newTalent{
	name = "Gelid Host",
	type = {"spell/rime-wraith", 3},
	require = spells_req_high3,
	points = 5,
	mana = 20,
	soul = 1,
	cooldown = 15,
	radius = 4,
	tactical = { ATTACKAREA = { COLD = 2 } },
	requires_target = true,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 5, 10)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220) end,
	action = function(self, t)
		local list = table.values(self:projectCollect({type="ball", radius=10}, self.x, self.y, Map.ACTOR, function(target) return target:hasEffect(target.EFF_RIME_WRAITH) and target:hasEffect(target.EFF_RIME_WRAITH).src == self end))
		if #list == 0 then return nil end
		local target = list[1].target

		self:callTalent(self.T_RIME_WRAITH, "createWraith", target, "EFF_RIME_WRAITH_GELID_HOST", t:_getDur(self))

		local radius = self:getTalentRadius(t)
		self:project({type="ball", radius=radius, x=target.x, y=target.y, friendlyfire=false}, target.x, target.y, DamageType.COLD, t:_getDamage(self))
		game.level.map:particleEmitter(target.x, target.y, radius, "iceflash", {radius=radius})

		return true
	end,
	info = function(self, t)
		return ([[By crushing one more soul you reinforce your existing rime wraith, duplicating it out of its current host.
		The new wraith will exist for %d turns and cannot be used for another cast of Gelid Host.
		When it is created the current host and all foes in radius %d are blasted for %0.2f cold damage.
		The damage will increase with your Spellpower.]]):
		tformat(t:_getDur(self), self:getTalentRadius(t), damDesc(self, DamageType.COLD, t:_getDamage(self)))
	end,
}

newTalent{
	name = "Permafrost",
	type = {"spell/rime-wraith",4},
	require = spells_req_high4,
	points = 5,
	mode = "passive",
	getSaves = function(self, t) return math.floor(self:combatTalentScale(t, 10, 30)) end,
	info = function(self, t)
		return ([[Hoarfrost now has additional effects:
		- if friendly: magical and physical saves increased by %d, at level 5 healing factor is also increased by 15%%.
		- if hostile: magical and physical saves reduced by %d, at level 5 all talents cool down 15%% slower.
		]])
		:tformat(t:_getSaves(self), t:_getSaves(self))
	end,
}
