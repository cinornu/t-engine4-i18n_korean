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
	name = "Willful Tormenter",
	type = {"corruption/torment", 1},
	require = corrs_req1,
	mode = "passive",
	points = 5,
	VimBonus = function(self, t) return self:combatTalentScale(t, 20, 95, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "max_vim", t.VimBonus(self, t))
	end,
	info = function(self, t)
		return ([[You set your mind toward a single goal: the destruction of all your foes.
		Increases the maximum amount of vim you can store by %d.]]):
		tformat(t.VimBonus(self, t))
	end,
}

newTalent{
	name = "Blood Lock",
	type = {"corruption/torment", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 16,
	vim = 12,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 1 },
	direct_hit = true,
	no_energy = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 12)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_BLOOD_LOCK, t.getDuration(self, t), {src=self, dam=self:combatTalentSpellDamage(t, 4, 90), apply_power=self:combatSpellpower()})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Reach out and touch the blood and health of your foes. Any creatures caught in the radius 2 ball will be unable to heal above their current life value (at the time of the casting) for %d turns.]]):
		tformat(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Overkill",
	type = {"corruption/torment", 3},
	require = corrs_req3,
	points = 5,
	mode = "sustained",
	cooldown = 20,
	sustain_vim = 18,
	tactical = { BUFF = 2 },
	getOversplash = function(self,t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 70), 100, 20, 0, 66.7, 46.7) end, -- Limit to <100%
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not dead or self.turn_procs.overkilling then return end

		self.turn_procs.overkilling = true
		local dam = (target.die_at - target.life) * t.getOversplash(self, t) / 100
		
		local incdam = {}
		for t, v in pairs(self.inc_damage) do incdam[t] = -v end
		local tmpid = self:addTemporaryValue("inc_damage", incdam)

		local ok, err = pcall(function() self:project({type="ball", radius=2, selffire=false, x=target.x, y=target.y, talent=t}, target.x, target.y, DamageType.BLIGHT, dam, {type="acid"}) end)

		self:removeTemporaryValue("inc_damage", tmpid)

		self.turn_procs.overkilling = nil
		if not ok then error(err) end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/flame")
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[When you kill a creature, the remainder of the damage done will not be lost. Instead, %d%% of it will splash in a radius 2 as blight damage.
		The splash damage will increase with your Spellpower.]]):tformat(t.getOversplash(self,t))
	end,
}

--friendlyfire
-- Note:  Normally you would use die_at instead of temporary maximum life for an effect like Sanguine Infusion and not have to special case it like this
--		  Unfortunately, part of the goal of SI is to encourage healing and synergize well with Bone Shield, so were stuck with ugliness		  
newTalent{
	name = "Blood Vengeance",
	type = {"corruption/torment", 4},
	require = corrs_req4,
	points = 5,
	mode = "sustained",
	cooldown = 20,
	getPower = function(self, t) return self:combatTalentLimit(t, 5, 15, 10), self:combatLimit(self:combatTalentSpellDamage(t, 10, 90), 100, 20, 0, 50, 61.3) end, -- Limit threshold > 5%, chance < 100%
	sustain_vim = 22,
	tactical = { BUFF = 2 },
	activate = function(self, t)
		local ret = {}
		game:playSoundNear(self, "talents/flame")
		if core.shader.active(4) then
			self:effectParticles(ret, {type="shader_ring_rotating", args={rotation=0, radius=1.1, img="blood_vengeance_lightningshield"}, shader={type="lightningshield"}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackPriorities={callbackOnHit = -1},  -- Before Bone Shield but after Rot
	callbackOnHit = function(self, t, cb)
		local eff = self:hasEffect(self.EFF_BLOOD_GRASP)
		local max_life = self.max_life - (eff and eff.life or 0)
		local l, c = t.getPower(self, t)
		if cb.value >= max_life * l  / 100 then
		
		local alt = {}
		for tid, cd in pairs(self.talents_cd) do
			if rng.percent(c) and not self:getTalentFromId(tid).fixed_cooldown then alt[tid] = true end
		end
		for tid, cd in pairs(alt) do
			self:alterTalentCoolingdown(tid, -1)
		end
		game.logSeen(self, "#RED#The powerful blow energizes %s reducing their cooldowns!#LAST#", self:getName())
		end
		return cb.value

	end,
	info = function(self, t)
		local l, c = t.getPower(self, t)
		return ([[When you are dealt a blow that reduces your life by at least %d%%, you have a %d%% chance to reduce the remaining cooldown of all your talents by 1.
		Temporary life from Sanguine Infusion will not count against the damage threshold.
		The chance will increase with your Spellpower.]]):
		tformat(l, c)
	end,
}
