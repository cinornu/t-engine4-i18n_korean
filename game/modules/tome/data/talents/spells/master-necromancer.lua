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
	name = "Aura of Undeath", short_name = "NECROTIC_AURA", image = "talents/aura_mastery.png",
	type = {"spell/master-necromancer",1},
	require = spells_req_high1,
	points = 5,
	mode = "sustained",
	sustain_mana = 15,
	cooldown = 20,
	tactical = { BUFF = 3 },
	radius = function(self, t) return math.floor(util.bound(3 + self:getTalentLevel(t), 4, 10)) end,
	getResists = function(self, t) return math.floor(self:combatTalentScale(t, 8, 18)) end,
	getInherit = function(self, t) return math.floor(self:combatTalentLimit(t, 75, 20, 40)) end,
	callbackOnActBase = function(self, t)
		self:projectApply({type="ball", radius=self:getTalentRadius(t)}, self.x, self.y, Map.ACTOR, function(target)
			if target.summoner == self and target.necrotic_minion and not target:hasEffect(target.EFF_NECROTIC_AURA) then
				target:setEffect(target.EFF_NECROTIC_AURA, 1, {power=t:_getResists(self)})
			end
		end, "friend")
	end,
	activate = function(self, t)
		local ret = {}
		self:talentParticles(ret, {type="necrotic-aura", args={radius=self:getTalentRadius(t)}})
		self:talentParticles(ret, {type="circle", args={oversize=0.7, a=75, appear=8, speed=8, img="necro_aura", radius=self:getTalentRadius(t)}})
		game:playSoundNear(self, "talents/spell_generic2")
		return ret
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Your mastery of necromancy becomes so total that an aura of undeath radiates around you in radius %d.
		Any undead minion standing inside of it is protected, increasing all their resistances by %d%%.
		In addition when you create new minions they inherit %d%% of your spellpower (applied to any powers), spell crit chance (applied to any crit chances), saves, resists and damage increases (applied to all elements).
		]]):tformat(self:getTalentRadius(t), t:_getResists(self), t:_getInherit(self))
	end,
}

newTalent{
	name = "Surge of Undeath",
	type = {"spell/master-necromancer", 2},
	require = spells_req_high2,
	points = 5,
	mana = 30,
	cooldown = 18,
	tactical = { BUFF=function(self) return necroArmyStats(self).nb / 2 end, DISABLE = {daze=2} },
	range = 0,
	radius = function(self, t) return self:callTalent(self.T_NECROTIC_AURA, "radius") end,
	target = function(self, t) return {type="ball", range=0, radius=self:getTalentRadius(t)} end,
	requires_target = true,
	getSpeed = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5)) end,
	getHeal = function(self, t) return math.floor(self:combatTalentScale(t, 12, 22)) end,
	getDaze = function(self, t) return math.floor(self:combatTalentScale(t, 4, 10)) end,
	on_pre_use = function(self, t) return self:isTalentActive(self.T_NECROTIC_AURA) end,
	action = function(self, t, p)
		local tg = self:getTalentTarget(t)
		self:projectApply(tg, self.x, self.y, Map.ACTOR, function(target)
			if self:reactionToward(target) < 0 and not target:attr("undead") then
				if target:canBe("stun") then target:setEffect(target.EFF_DAZED, t:_getDaze(self), {apply_power=self:combatSpellpower()}) end
			elseif target.summoner == self and target.necrotic_minion then
				target:setEffect(target.EFF_HASTE, t:_getSpeed(self), {power=0.25})
				target:heal(target.max_life * t:_getHeal(self) / 100, self)
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_darkness", {radius=tg.radius})
		return true
	end,	
	info = function(self, t)
		return ([[Sends out a surge of undeath energies into your aura.
		All minions inside gain 25%% speed for %d turns and are healed by %d%%.
		All non-undead foes caught inside are dazed for %d turns.]]):
		tformat(t:_getSpeed(self), t:_getHeal(self), t:_getDaze(self))
	end,
}

newTalent{
	name = "Recall Minions",
	type = {"spell/master-necromancer", 3},
	require = spells_req_high3,
	points = 5,
	mana = 25,
	soul = 1,
	cooldown = 20,
	tactical = { ESCAPE=3 },
	range = 0,
	radius = function(self, t) return self:callTalent(self.T_NECROTIC_AURA, "radius") end,
	target = function(self, t) return {type="ball", range=0, radius=self:getTalentRadius(t)} end,
	requires_target = true,
	getNb = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 1, 6)) end,
	on_pre_use = function(self, t) return self:isTalentActive(self.T_NECROTIC_AURA) and necroArmyStats(self).nb > 0 end,
	action = function(self, t)
		local stats = necroArmyStats(self)
		if stats.nb == 0 then return end

		local spots, spots_hostile = {}, {}
		self:projectApply({type="ball", radius=1}, self.x, self.y, Map.TERRAIN, function(_, x, y)
			local target = game.level.map(x, y, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then spots_hostile[#spots_hostile+1] = {x=x, y=y, foe=target}
			elseif not target then spots[#spots+1] = {x=x, y=y}
			end
		end)

		for i = 1, t:_getNb(self) do
			local m = rng.tableRemove(stats.list)
			if not m then break end
			local spot = rng.tableRemove(spots_hostile)
			if not spot then spot = rng.tableRemove(spots) end
			if not spot then break end

			local mx, my = m.x, m.y
			m:forceMoveAnim(spot.x, spot.y)
			if spot.foe then spot.foe:forceMoveAnim(mx, my) end
		end

		return true
	end,
	info = function(self, t)
		return ([[Tighten the ethereal leash to some of your minions currently within your aura of undeath, pulling them to you and swapping place with any eventual foes in the way.
		Up to %d minions are affected.
		When recalling a minion the spell tries to prioritize a spot where there is already a foe, to push it away.]]):
		tformat(t:_getNb(self, t))
	end,
}

newTalent{
	name = "Suffer For Me",
	type = {"spell/master-necromancer",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 30,
	cooldown = 30,
	getPower = function(self, t) return util.bound(self:combatTalentSpellDamage(t, 20, 330) / 10, 5, 40) end,
	callbackOnHit = function(self, t, cb, src)
		if not self:isTalentActive(self.T_NECROTIC_AURA) then return end
		if not cb.value then return end
		local stats = necroArmyStats(self)
		if stats.nb == 0 then return end

		while true do
			local m = rng.tableRemove(stats.list)
			if not m then return end

			if m:hasEffect(m.EFF_NECROTIC_AURA) then
				local remain = cb.value * t:_getPower(self) / 100
				cb.value = cb.value - remain
				game:delayedLogDamage(src, self, 0, ("#GREY#(%d to minion: %s)#LAST#"):tformat(remain, m:getName()), false)
				m:takeHit(remain * 3, src or self)
				return true
			end
		end
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[By creating an arcane link with your minion army you are able to redirect parts of any damage affecting you to them.
		Anytime you take damage %d%% of it is instead redirected to a random minion without your aura of undeath.
		The minion takes 300%% damage from that effect.
		The damage redirected percent depends on your Spellpower.]]):
		tformat(t:_getPower(self))
	end,
}
