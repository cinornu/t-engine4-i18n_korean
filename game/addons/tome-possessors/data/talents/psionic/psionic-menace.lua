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

local function check_mindstars(self, t, silent)
	if self:attr("disarmed") then
		if not silent then game.logPlayer(self, "You are disarmed.") end
		return false
	end
	if not self:hasDualWeapon("mindstar") then
		local mh2 = self.inven[self.INVEN_QS_MAINHAND]
		local oh2 = self.inven[self.INVEN_QS_OFFHAND]
		if
			mh2 and mh2[1] and mh2[1].combat and mh2[1].combat.talented == "mindstar" and
			oh2 and oh2[1] and oh2[1].combat and oh2[1].combat.talented == "mindstar" then
			return true
		end
	else
		return true
	end
	if not silent then game.logPlayer(self, "You require two mindstars to use this talent.") end
	return false
end

local function switch_mindstars(self, t)
	if not self:hasDualWeapon("mindstar") then
		local mh2 = self.inven[self.INVEN_QS_MAINHAND]
		local oh2 = self.inven[self.INVEN_QS_OFFHAND]
		if
			mh2 and mh2[1] and mh2[1].combat and mh2[1].combat.talented == "mindstar" and
			oh2 and oh2[1] and oh2[1].combat and oh2[1].combat.talented == "mindstar" then
			self:attr("no_sound", 1)
			self:quickSwitchWeapons(true, "possessor", false)
			self:attr("no_sound", -1)
		end
	end
	if self:isTalentActive(self.T_PSIBLADES) then self:forceUseTalent(self.T_PSIBLADES, {ignore_cooldown=true, ignore_energy=true}) end
end

newTalent{
	name = "Mind Whip",
	type = {"psionic/psionic-menace", 1},
	require = psi_wil_req1,
	points = 5,
	cooldown = 4,
	psi = 12,
	tactical = { ATTACK = { MIND = 2 } },
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 5, 220) end,
	on_pre_use = check_mindstars,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		switch_mindstars(self, t)

		local dam = self:mindCrit(t.getDam(self, t))
		self:project(tg, x, y, function(px, py)
			local tgts = {}
			self:project({type="ball", radius=1, x=px, y=py}, px, py, function(ppx, ppy)
				local a = game.level.map(ppx, ppy, Map.ACTOR)
				if a and self:reactionToward(a) < 0 and self:hasLOS(px, py) and (px ~= ppx or py ~= ppy) then tgts[#tgts+1] = a end
			end)
			DamageType:get(DamageType.MIND).projector(self, px, py, DamageType.MIND, dam)
			game.level.map:particleEmitter(px, py, 1, "image", {once=true, image="particles_images/mindwhip_hit_0"..rng.range(1, 4), life=14, av=-0.6/14, size=64})
			game.level.map:particleEmitter(px, py, 1, "shockwave", {radius=1, distort_color=colors.simple1(colors.ROYAL_BLUE), allow=core.shader.allow("distort")})
			if #tgts > 0 then
				local a = rng.table(tgts)
				game.level.map:particleEmitter(a.x, a.y, 1, "image", {once=true, image="particles_images/mindwhip_hit_0"..rng.range(1, 4), life=14, av=-0.6/14, size=64})
				game.level.map:particleEmitter(a.x, a.y, 1, "shockwave", {radius=1, distort_color=colors.simple1(colors.ROYAL_BLUE), allow=core.shader.allow("distort")})
				DamageType:get(DamageType.MIND).projector(self, a.x, a.y, DamageType.MIND, dam)
			end
		end)

		game:playSoundNear(self, "actions/whip_hit")
		return true
	end,
	info = function(self, t)
		return ([[You lash out your psionic fury at a distant creature, doing %0.2f mind damage.
		The whip can cleave to one nearby foe.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}

-- consider adding a fixed amount to MP instead of a %
newTalent{
	name = "Psychic Wipe",
	type = {"psionic/psionic-menace", 2},
	require = psi_wil_req2,
	points = 5,
	psi = 20,
	cooldown = 12,
	tactical = { ATTACK = { MIND = 2 }, DISABLE = 3 },
	range = 7,
	direct_hit = true,
	requires_target = true,
	on_pre_use = check_mindstars,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 40, 340) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 5, 12)) end,
	getReduct = function(self, t) return self:combatTalentScale(t, 5, 70, 0.2) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		switch_mindstars(self, t)

		local dam = self:mindCrit(t.getDam(self, t))

		self:project(tg, x, y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a then
				local dur = t.getDur(self, t)
				a:setEffect(a.EFF_PSYCHIC_WIPE, dur, {apply_power=self:combatMindpower() * 1.3, reduct=t.getReduct(self, t), dam=self:mindCrit(t.getDam(self, t)) / dur, src=self})
				game.level.map:particleEmitter(px, py, 1, "mindsear", {baseradius=0.66})
			end
		end)

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[You project ethereal fingers inside the target's brain.
		Over %d turns it will take %0.2f total mind damage and have its mental save reduced by %d.
		This powerful effect uses 130%% of your Mindpower to try to overcome your target's initial mental save.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(t.getDur(self,t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getReduct(self, t))
	end,
}

newTalent{
	name = "Ghastly Wail",
	type = {"psionic/psionic-menace", 3},
	require = psi_wil_req3,
	points = 5,
	psi = 35,
	cooldown = 13,
	tactical = { ATTACKAREA = { MIND = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 2 } },
	direct_hit = true,
	requires_target = true,
	range = 0,
	on_pre_use = check_mindstars,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5)) end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 28, 180) end,
	action = function(self, t)
		switch_mindstars(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				DamageType:get(DamageType.MIND).projector(self, px, py, DamageType.MIND, self:mindCrit(t.getDam(self, t)))
				a:knockback(self.x, self.y, 3)
				a:setEffect(a.EFF_GHASTLY_WAIL, t.getDur(self, t), {apply_power=self:combatMindpower(), dist=3})
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "shout", {additive=true, life=10, size=3, distorion_factor=0.5, radius=tg.radius, nb_circles=8, rm=0.1, rM=0.2, gm=0.8, gM=1, bm=0.5, bM=0.7, am=0.4, aM=0.6})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[You let your mental forces go unchecked for an instant. All foes in a radius %d are knocked 3 grids away from you.
		Creatures that fail a mental save are also dazed for %d turns and take %0.2f mind damage.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t))
	end,
}

newTalent{
	name = "Finger of Death",
	type = {"psionic/psionic-menace", 4},
	require = psi_wil_req4,
	points = 5,
	psi = 50,
	cooldown = 13,
	range = 7,
	no_npc_use = true,
	direct_hit = true,
	radius = 7,
	requires_target = true,
	on_pre_use = check_mindstars,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDam = function(self, t) return self:combatTalentScale(t, 25, 90) end,
	getBossMax = function(self, t) return self:combatTalentMindDamage(t, 50, 1000) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		switch_mindstars(self, t)
		
		local ok = false
		self:project(tg, x, y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a then
				if not a:hasEffect(a.EFF_GHASTLY_WAIL) then return end
				ok = true
				local lost_life = a.max_life - a.life
				local dam = lost_life * t.getDam(self, t) / 100
				if a.rank >= 3 then dam = math.min(dam, t.getBossMax(self, t)) end
				DamageType:get(DamageType.MIND).projector(self, px, py, DamageType.MIND, dam)
				game.level.map:particleEmitter(px, py, 1, "image", {once=true, image="particles_images/finger_of_death", life=25, av=-0.6/25, size=64})
				if a:attr("dead") and self:callTalent(self.T_POSSESS, "absorbCheck", a, false) then
					if self:callTalent(self.T_BODIES_RESERVE, "storeBody", a, true) then
						self:logCombat(a, "#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.")
					else
						self:logCombat(a, "#PURPLE##Source# shatters #Target#'s mind, utterly destroying it but has no room to store the body.")
					end
				end
			end
		end)
		if not ok then
			game.logPlayer(self, "#CRIMSON#Target is not affected by ghastly wail!")
			return nil
		end

		game:playSoundNear(self, "actions/whip_hit")
		return true
	end,
	info = function(self, t)
		return ([[You point your ghastly finger at a foe affected by Ghastly Wail and send a psionic impulse to tell it to simply die.
		The target will take %d%% of the life it already lost as mind damage.
		On targets of rank boss or higher the damage is limited to %d.
		If the target dies from the Finger and is of a type you can already absorb it is directly absorbed into your bodies reserve.
		If you do not have two mindstars equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(t.getDam(self, t), t.getBossMax(self, t))
	end,
}
