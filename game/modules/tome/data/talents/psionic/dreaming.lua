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
	name = "Sleep",
	type = {"psionic/dreaming", 1},
	points = 5, 
	require = psi_wil_req1,
	cooldown = function(self, t) return math.max(4, 9 - self:getTalentLevelRaw(t)) end,
	psi = 5,
	tactical = { DISABLE = {sleep = 1} },
	direct_hit = true,
	requires_target = true,
	range = 7,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.25, 2.25)) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 2.1, 3.5)) end,
	getInsomniaPower = function(self, t)
		if not self:knowTalent(self.T_SANDMAN) then return 20 end
		local t = self:getTalentFromId(self.T_SANDMAN)
		local reduction = t.getInsomniaPower(self, t)
		return 20 - reduction
	end,
	getSleepPower = function(self, t) 
		local power = self:combatTalentMindDamage(t, 5, 25) -- This probably needs a buff
		if self:knowTalent(self.T_SANDMAN) then
			local t = self:getTalentFromId(self.T_SANDMAN)
			power = power * t.getSleepPowerBonus(self, t)
		end
		return math.ceil(power)
	end,
	doContagiousSleep = function(self, target, p, t)
		local tg = {type="ball", radius=1, talent=t}
		self:project(tg, target.x, target.y, function(tx, ty)
			local t2 = game.level.map(tx, ty, Map.ACTOR)
			if t2 and t2 ~= target and rng.percent(p.contagious) and t2:canBe("sleep") and not t2:hasEffect(t2.EFF_SLEEP) then
				t2:setEffect(t2.EFF_SLEEP, p.dur, {src=self, power=p.power, waking=p.waking, insomnia=p.insomnia, no_ct_effect=true, apply_power=self:combatMindpower()})
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=0, rM=0, gm=100, gM=200, bm=200, bM=255, am=35, aM=90})
			end
		end)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		--Contagious?
		local is_contagious = 0
		if self:getTalentLevel(t) >= 5 then
			is_contagious = 25
		end
		--Restless?
		local is_waking =0
		if self:knowTalent(self.T_RESTLESS_NIGHT) then
			local t = self:getTalentFromId(self.T_RESTLESS_NIGHT)
			is_waking = t.getDamage(self, t)
		end

		local power = self:mindCrit(t.getSleepPower(self, t))
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if target then
				if target:canBe("sleep") then
					target:setEffect(target.EFF_SLEEP, t.getDuration(self, t), {src=self, power=power,  contagious=is_contagious, waking=is_waking, insomnia=t.getInsomniaPower(self, t), no_ct_effect=true, apply_power=self:combatMindpower()})
					game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					game.logSeen(self, "%s resists the sleep!", target:getName():capitalize())
				end
			end
		end)
		game:playSoundNear(self, "talents/dispel")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[Puts targets in a radius of %d to sleep for %d turns, rendering them unable to act.  Every %d points of damage the target suffers will reduce the effect duration by one turn.
		When Sleep ends, the target will suffer from Insomnia for a number of turns equal to the amount of time it was asleep (up to ten turns max), granting it %d%% sleep immunity for each turn of the Insomnia effect.
		At talent level 5 Sleep will become contagious and has a 25%% chance to spread to nearby targets each turn.
		The damage threshold will scale with your Mindpower.]]):tformat(radius, duration, power, insomnia)
	end,
}

newTalent{
	name = "Lucid Dreamer",
	type = {"psionic/dreaming", 2},
	points = 5,
	require = psi_wil_req2,
	mode = "sustained",
	sustain_psi = 20,
	cooldown = 12,
	tactical = { BUFF=2 },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 5, 25) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local power = t.getPower(self, t)
		local ret = {
			phys = self:addTemporaryValue("combat_physresist", power),
			mental = self:addTemporaryValue("combat_mentalresist", power),
			spell = self:addTemporaryValue("combat_spellresist", power),
			dreamer = self:addTemporaryValue("lucid_dreamer", power),
			sleep = self:addTemporaryValue("sleep", 1),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physresist", p.phys)
		self:removeTemporaryValue("combat_mentalresist", p.mental)
		self:removeTemporaryValue("combat_spellresist", p.spell)
		self:removeTemporaryValue("lucid_dreamer", p.dreamer)
		self:removeTemporaryValue("sleep", p.sleep)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[Slip into a lucid dream.  While in this state, you are considered sleeping, but can still act, are immune to insomnia, inflict %d%% more damage to targets under the effects of Insomnia, and your Physical, Mental, and Spell saves are increased by %d.
		Note that being asleep may make you more vulnerable to certain effects (such as Inner Demons, Night Terror, and Waking Nightmare).
		The saving throw bonuses scale with your Mindpower.]]):tformat(power, power)
	end,
}

newTalent{
	name = "Dream Walk",
	type = {"psionic/dreaming", 3},
	points = 5, 
	require = psi_wil_req3,
	psi= 10,
	cooldown = 10,
	tactical = { SELF = {ESCAPE = 2},
		CLOSEIN = function(self, t, target)
			return (target and target:attr("sleep") or game.zone.is_dream_scape) and 2 or 1
		end
	},
	range = 7,
	radius = function(self, t) return math.max(0, 7 - math.floor(self:getTalentLevel(t))) end,
	target = function(self, t)
		local tg = {type="beam", nolock=true, pass_terrain=false, nowarning=true, range=self:getTalentRange(t)}
		if not self.player then
			tg.grid_params = {want_range=self.ai_state.tactic == "escape" and self:getTalentCooldown(t) + 11 or self.ai_tactic.safe_range or 0, max_delta=-1}
		end
		return tg
	end,
	direct_hit = true,
	is_teleport = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
			game.logPlayer(self, "You may only dream walk to an open space within your line of sight.")
			return nil
		end
		local __, x, y = self:canProject(tg, x, y)
		local teleport = self:getTalentRadius(t)
		target = game.level.map(x, y, Map.ACTOR)
		if (target and target:attr("sleep")) or game.zone.is_dream_scape then
			teleport = 0
		end
		
		game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})

		if not self:teleportRandom(x, y, teleport) then
			game.logSeen(self, "Your dream walk fails!")
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
		game:playSoundNear(self, "talents/teleport")

		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[You move through the dream world, reappearing at a nearby location.
		If there is a sleeping creature at the target location, you'll appear as close to them as possible, otherwise, you'll appear within %d tiles of your intended destination.]]):tformat(radius)
	end,
}

newTalent{
	name = "Dream Prison",
	type = {"psionic/dreaming", 4},
	points = 5,
	require = psi_wil_req4,
	mode = "sustained",
	sustain_psi = 40,
	cooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 45, 25)) end, -- Limit > 0
	tactical = { DISABLE = function(self, t, target)
			if target and target:attr("sleep") then return 2 else return 0 end
		end,
	},
	range = 7,
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRange(t), range=0}
	end,
	direct_hit = true,
	remove_on_zero = true,
	getDrain = function(self, t) return self:combatTalentLimit(t, 1, 5, 2.5) end,
	drain_psi = function(self, t)
		local max_psi = self:getMaxPsi() + (self:isTalentActive(t.id) and t.sustain_psi or 0)
		return t.getDrain(self, t)*max_psi/100
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {}
	end,
	deactivate = function(self, t, p)
		if p.drain then self:removeTemporaryValue("psi_regen", p.drain) end -- compatibility with older versions of this talent
		return true
	end,
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[Imprisons all sleeping targets within range in their dream state, effectively extending sleeping effects for as long as Dream Prison is maintainted.
		This powerful effect constantly drains %0.2f%% of your maximum Psi (excluding this talent) per turn, and is considered a psionic channel; as such it will break if you move.
		(Note that sleeping effects that happen each turn, such as Nightmare's damage and Sleep's contagion, will cease to function for the duration of the effect.)]]):tformat(drain)
	end,
}
