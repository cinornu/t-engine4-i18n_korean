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

local Dialog = require "engine.ui.Dialog"

newTalent{
	name = "Mind Steal",
	type = {"psionic/deep-horror", 1},
	require = psi_wil_high1,
	points = 5,
	cooldown = 30,
	psi = 30,
	tactical = { DISABLE = 1, ANNOY = 1 },
	range = 7,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getMaxTalentsLevel = function(self, t) return math.max(1, math.floor(self:getTalentLevel(t))) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 30)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTargetLimited(tg)
		if not tx or not ty or not target or target == self then return nil end
		if not target:checkHit(self:combatMindpower(), target:combatMentalResist(), 0, 95, 15) then
			game.logSeen(target, "%s resists the mind steal!", target:getName():capitalize())
			return true
		end

		local possibles = {}
		for tid, lev in pairs(target.talents) do
			local t = self:getTalentFromId(tid)
			if self:callTalent(self.T_ASSUME_FORM, "isUsableTalent", t, "activated") and not self:knowTalent(tid) then
				possibles[#possibles+1] = {tid=tid, name=t.name.. "("..lev..")"}
			end
		end
		if #possibles == 0 then game.logPlayer(self, "%s has no stealable talents.", target:getName():capitalize()) return nil end
		local tid = nil

		if self:getTalentLevel(t) >= 5 and #possibles > 1 then
			tid = self:talentDialog(Dialog:listPopup(_t"Mind Steal", _t"Choose a talent to steal:", possibles, 400, 400, function(item) self:talentDialogReturn(item) end))
			if tid then tid = tid.tid
			else return nil end
		else
			tid = rng.table(possibles).tid
		end

		self:setEffect(self.EFF_MIND_STEAL, t.getDuration(self, t), {tid=tid, lev=math.min(target:getTalentLevelRaw(tid), t.getMaxTalentsLevel(self, t))})
		target:setEffect(target.EFF_MIND_STEAL_REMOVE, t.getDuration(self, t), {tid=tid})

		local dx, dy = target.x - self.x, target.y - self.y
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(dx), math.abs(dy)), "mind_steal", { tx=dx, ty=dy })

		-- game.level.map:particleEmitter(self.x, self.y, 2, "circle", {shader=true, appear_size=10, a=110, appear=6, limit_life=8, speed=0, img="healparadox", radius=-0.2})
		-- game.level.map:particleEmitter(target.x, target.y, 2, "circle", {shader=true, appear_size=0, a=110, appear=6, limit_life=8, speed=0, img="healparadox", radius=-0.2})

		return true
	end,
	info = function(self, t)
		return ([[Your mere presence is a blight in your foes minds. Using this link you are able to reach out and steal a talent from a target.
		For %d turns you will be able to use a random active (not passive, not sustained) talent from your target, and they will loose it.
		You may not steal a talent which you already know.
		The stolen talent will not use any resources to activate.
		At level 5 you are able to choose which talent to steal.
		The talent stolen will be limited to at most level %d.]]):
		tformat(t.getDuration(self, t), t.getMaxTalentsLevel(self, t))
	end,
}

newTalent{
	name = "Spectral Dash",
	type = {"psionic/deep-horror", 2},
	require = psi_wil_high2,
	points = 5,
	psi = 16,
	cooldown = 15,
	tactical = { ATTACK = { MIND = 1 }, ESCAPE = 1, CLOSE_IN = 1 },
	range = 1,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 40, 200) end,
	getPsi = function(self, t) return self:getTalentLevel(t) * 14 end,
	getRange = function(self, t) return self:combatTalentLimit(t, 15, 3, 8) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTargetLimited(tg)
		if not tx or not ty or not target or target == self then return nil end

		local ox, oy = self.x, self.y
		self:probabilityTravel(tx, ty, t.getRange(self, t), function(px, py) return not game.level.map(px, py, Map.ACTOR) and true or false end)
		if ox == self.x and oy == self.y then return end

		self:project({type="beam", range=100}, ox, oy, DamageType.MIND, self:mindCrit(t.getDam(self, t)))
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(ox-self.x), math.abs(oy-self.y)), "psionicbeam", {tx=ox-self.x, ty=oy-self.y})

		self:incPsi(self:mindCrit(t.getPsi(self, t)))

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[For a brief moment your whole body becomes etheral and you dash into a nearby creature and all those in straight line behind it (in range %d).
		You reappear on the other side, with %d more psi and having dealt %0.2f mind damage to your targets.
		]]):
		tformat(t.getRange(self,t), t.getPsi(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}

newTalent{
	name = "Writhing Psionic Mass",
	type = {"psionic/deep-horror", 3},
	require = psi_wil_high3,
	points = 5,
	psi = 10,
	cooldown = 18,
	tactical = { DEFEND = 3 },
	requires_target = true,
	no_energy = true,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5)) end,
	getNbEffects = function(self, t) return math.floor(self:combatTalentScale(t, 1, 2)) end,
	getCrit = function(self, t) return math.floor(self:combatTalentScale(t, 12, 30)) end,
	getResist = function(self, t) return math.floor(self:combatTalentScale(t, 12, 40)) end,
	action = function(self, t)
		self:setEffect(self.EFF_WRITHING_PSIONIC_MASS, t.getDur(self, t), {resists=t.getResist(self, t), crit=t.getCrit(self, t)})
		self:removeEffectsFilter({type="physical", status="detrimental"}, t.getNbEffects(self, t))
		return true
	end,
	info = function(self, t)
		return ([[Your physical form is but a mere extension of your mind, you can bend it at will for %d turns.
		While under the effect you gain %d%% all resistances and have %d%% chance to ignore all critical hits.
		On activation you also remove up to %d physical or mental effects.
		]]):
		tformat(t.getDur(self, t), t.getResist(self, t), t.getCrit(self, t), t.getNbEffects(self, t))
	end,
}

newTalent{
	name = "Ominous Form",
	type = {"psionic/deep-horror", 4},
	require = psi_wil_high4,
	points = 5,
	psi = 50,
	cooldown = 40,
	range = 2,
	no_npc_use = true,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDur = function(self, t) return self:combatTalentScale(t, 3, 7) end,
	on_pre_use = function(self, t, silent) if self:hasEffect(self.EFF_POSSESSION) then if not silent then game.logPlayer(self, "You are already assuming a form.") end return false end return true end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTargetLimited(tg)
		if not tx or not ty or not target or target == self then return nil end

		if not self:callTalent(self.T_POSSESS, "basicAbsorbCheck", target) then return nil end

		if not target:checkHit(self:combatMindpower(), target:combatMentalResist(), 0, 95, 15) then
			game.logPlayer(target, "%s resists your attack!", target:getName():capitalize())
			return true
		end

		local body = self:callTalent(self.T_BODIES_RESERVE, "setupBody", target)
		self:setEffect(self.EFF_POSSESSION, 1, {body = body, ominous = true})
		self:setEffect(self.EFF_OMINOUS_FORM, t.getDur(self, t), {target = target})

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[Your psionic powers have no limits. You are now able to assault a target and clone its body without killing it.
		The form is only temporary, lasting %d turns and subject to the same restrictions as your normal powers.
		While using a stolen form your health is bound to your target. (Your life%% will always be identical to your target's life%%)
		]]):
		tformat(t.getDur(self, t))
	end,
}
