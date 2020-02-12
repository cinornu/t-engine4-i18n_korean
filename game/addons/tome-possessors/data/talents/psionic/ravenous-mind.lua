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
	name = "Sadist",
	type = {"psionic/ravenous-mind", 1},
	require = psi_wil_req1,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return self:combatTalentLimit(t, 30, 6, 18) end,
	callbackOnAct = function(self, t)
		local nb_foes = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and self:canSee(act) and act.life <= act.max_life * 0.8 then
				nb_foes = nb_foes + 1
			end
		end
		if nb_foes >= 1 then
			nb_foes = math.min(nb_foes, 5)
			self:setEffect(self.EFF_SADIST, 2, {power=t.getPower(self, t), stacks=nb_foes})
		end
	end,
	info = function(self, t)
		return ([[You feed on the pain of all foes in sight. For each one of them with life under 80%% you gain a stack of Sadist effect that increases your raw mindpower by %d.
		]]):
		tformat(t.getPower(self, t))
	end,
}

newTalent{
	name = "Channel Pain",
	type = {"psionic/ravenous-mind", 2},
	require = psi_wil_req2,
	mode = "sustained",
	points = 5,
	sustain_psi = 5,
	cooldown = 20,
	tactical = { BUFF = 2 },
	getPsi = function(self, t) return self:combatTalentLimit(t, 5, 20, 12) end,
	getBacklash = function(self, t) return self:combatTalentLimit(t, 100, 40, 80) end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if dam < self.max_life * 0.1 then return end
		if self.turn_procs.channel_pain then return end
		local eff = self:hasEffect(self.EFF_SADIST)
		if not eff then return end
		local absorb = dam / (eff.stacks + 1)
		local backlash = absorb * t.getBacklash(self, t) / 100

		local acts = {}
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and self:canSee(act) and act.life <= act.max_life * 0.8 then
				acts[#acts+1] = act
			end
		end
		if #acts > 0 then
			local act = rng.table(acts)
			DamageType:get(DamageType.MIND).projector(self, act.x, act.y, DamageType.MIND, backlash)
			game.level.map:particleEmitter(act.x, act.y, 2, "circle", {appear_size=0, base_rot=45, a=190, appear=6, limit_life=4, speed=0, img="channel_pain", radius=-0.1})
			game.logSeen(self, "#ORANGE#%s channels pain to %s!", self:getName():capitalize(), act.name)
		else
			game.logSeen(self, "#ORANGE#%s channels pain!", self:getName():capitalize())
		end

		self:incPsi(-t.getPsi(self, t))
		self.turn_procs.channel_pain = true
		return {dam=absorb}
	end,
	activate = function(self, t)
		local ret = {}
		self:talentParticles(ret, {type="circle", args={toback=true, oversize=1, a=220, shader=true, appear=12, img="aura_channel_pain", speed=0, base_rot=180, radius=0}})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[As long as you have at least a stack of Sadist whenever you take damage you use %d psi to harness your stacks of Sadist to divide the damage by your stacks + 1.
		Each time this happens a random foe in sight with 80%% or less life left will take a backlash of %d%% of the absorbed damage as mind damage.
		This effect can only happen once per turn and only triggers for hits over 10%% of your max life.]]):
		tformat(t.getPsi(self, t), t.getBacklash(self, t))
	end,
}

newTalent{
	name = "Radiate Agony",
	type = {"psionic/ravenous-mind", 3},
	require = psi_wil_req3,
	cooldown = 12,
	psi = 30,
	points = 5,
	tactical = { DEFEND = 2 },
	radius = function(self, t) return self:combatTalentLimit(t, 7, 1, 5) end,
	getProtection = function(self, t) return self:combatTalentLimit(t, 60, 15, 35) end,
	on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_SADIST) then if not silent then game.logPlayer(self, "You need a Sadist stack to use this talent.") end return false end return true end,
	action = function(self, t)
		self:project({type="ball", radius=self:getTalentRadius(t)}, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and self:reactionToward(target) < 0 and target.life <= target.max_life * 0.8 then
				target:setEffect(target.EFF_RADIATE_AGONY, 5, {apply_power=self:combatMindpower(), power=t.getProtection(self, t)})
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[As long as you have at least a stack of Sadist you can radiate agony to all those you see in radius %d with 80%% or lower life left.
		For 5 turns their mind will be so focused on their own pain that they will deal %d%% less damage to you.]]):
		tformat(self:getTalentRadius(t), t.getProtection(self, t))
	end,
}

newTalent{
	name = "Torture Mind",
	type = {"psionic/ravenous-mind", 4},
	require = psi_wil_req4,
	points = 5,
	psi = 35,
	cooldown = 25,
	range = 7,
	tactical = { ANNOY = 5 },
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 4, 9)) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_SADIST) then if not silent then game.logPlayer(self, "You need a Sadist stack to use this talent.") end return false end return true end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTargetLimited(tg)
		if not tx or not ty or not target then return nil end

		target:setEffect(target.EFF_TORTURE_MIND, t.getDur(self, t), {apply_power=self:combatMindpower(), nb=t.getNb(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[As long as you have at least a stack of Sadist you can mentally lash out at a target, sending horrible images to its mind.
		The target will reel from the effect for %d turns, rendering %d random talents unusable for the duration.]]):
		tformat(t.getDur(self, t), t.getNb(self, t))
	end,
}
