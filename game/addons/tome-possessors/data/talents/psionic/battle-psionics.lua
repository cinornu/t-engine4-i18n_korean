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

local function check_1hstar(self, t, silent, only_first)
	if self:attr("disarmed") then
		if not silent then game.logPlayer(self, "You are disarmed.") end
		return false
	end
	local mh1 = self.inven[self.INVEN_MAINHAND]
	local oh1 = self.inven[self.INVEN_OFFHAND]
	if
		mh1 and mh1[1] and mh1[1].combat and mh1[1].combat.talented ~= "mindstar" and
		oh1 and oh1[1] and oh1[1].combat and oh1[1].combat.talented == "mindstar" then
		return true
	elseif not only_first then
		local mh2 = self.inven[self.INVEN_QS_MAINHAND]
		local oh2 = self.inven[self.INVEN_QS_OFFHAND]
		if
			mh2 and mh2[1] and mh2[1].combat and mh2[1].combat.talented ~= "mindstar" and
			oh2 and oh2[1] and oh2[1].combat and oh2[1].combat.talented == "mindstar" then
			return true
		end
	end
	if not silent then game.logPlayer(self, "You require a mainhand weapon and an offhand mindstar to use this talent.") end
	return false
end

local function switch_1hstar(self, t)
	local mh1 = self.inven[self.INVEN_MAINHAND]
	local oh1 = self.inven[self.INVEN_OFFHAND]
	if
		not (
			mh1 and mh1[1] and mh1[1].combat and mh1[1].combat.talented ~= "mindstar" and
			oh1 and oh1[1] and oh1[1].combat and oh1[1].combat.talented == "mindstar"
		)
	then
		local mh2 = self.inven[self.INVEN_QS_MAINHAND]
		local oh2 = self.inven[self.INVEN_QS_OFFHAND]
		if
			mh2 and mh2[1] and mh2[1].combat and mh2[1].combat.talented ~= "mindstar" and
			oh2 and oh2[1] and oh2[1].combat and oh2[1].combat.talented == "mindstar" then
			self:attr("no_sound", 1)
			self:quickSwitchWeapons(true, "possessor", false)
			self:attr("no_sound", -1)
		end
	end
end

newTalent{
	name = "Psionic Disruption",
	type = {"psionic/battle-psionics", 1},
	require = psi_wil_req1,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_psi = 18,
	tactical = { BUFF = 2 },
	on_pre_use = check_1hstar,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 40, 150) end,
	getStacks = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	getDur = function(self, t) return 5 end,
	getBuff = function(self, t) return self:combatTalentScale(t, 50, 150) end,
	updateMindBuff = function(self, t, p, only_gfx)
		if not p then return end

		if not only_gfx then
			local oh = self.inven[self.INVEN_OFFHAND] and self.inven[self.INVEN_OFFHAND][1]
			if p.mid then self:removeTemporaryValue("combat_mindpower", p.mid) end
			if p.cid then self:removeTemporaryValue("combat_mindcrit", p.cid) end
			local mindpower = 0
			local mindcrit = 0
			if oh and oh.combat and oh.combat.talented == "mindstar" then
				mindpower = oh.wielder.combat_mindpower or 0
				mindcrit = oh.wielder.combat_mindcrit or 0
			end
			p.mid = self:addTemporaryValue("combat_mindpower", math.ceil(mindpower * t.getBuff(self, t) / 100))
			p.cid = self:addTemporaryValue("combat_mindcrit", math.floor(mindcrit * t.getBuff(self, t) / 100))
		end

		if core.shader.active() then
			local img = "psi_disruption_active"
			if not check_1hstar(self, t, true, true) then img = "psi_disruption_passive" end
			if p.particle1 then self:removeParticles(p.particle1) end
			if p.particle2 then self:removeParticles(p.particle2) end
			p.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, img=img, a=0.6}, {type="tentacles", appearTime=p.particle1 and 0 or 0.3, time_factor=700, noup=2.0}))
			p.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, img=img, a=0.6}, {type="tentacles", appearTime=p.particle2 and 0 or 0.3, time_factor=700, noup=1.0}))
		end
	end,
	callbackOnQuickSwitchWeapons = function(self, t) t.updateMindBuff(self, t, self:isTalentActive(t.id), true) end,
	callbackOnWear = function(self, t) t.updateMindBuff(self, t, self:isTalentActive(t.id)) end,
	callbackOnTakeoff = function(self, t) t.updateMindBuff(self, t, self:isTalentActive(t.id)) end,
	callbackOnTalentPost = function(self, t, ab)
		if ab.id ~= self.T_PSIBLADES then return end
		game:onTickEnd(function() if self:isTalentActive(self.T_PSIBLADES) then self:forceUseTalent(self.T_PSIBLADES, {ignore_cooldown=true, ignore_energy=true}) end end)
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not check_1hstar(self, t, true, true) then return end
		if self.turn_procs.psionic_disruption or dam <= 0 or not hitted or target:attr("dead") then return end
		self.turn_procs.psionic_disruption = true

		target:setEffect(target.EFF_PSIONIC_DISRUPTION, t.getDur(self, t), {dam=t.getDam(self, t) / t.getDur(self, t), max_stacks=t.getStacks(self, t), stack=1, src=self})
	end,
	activate = function(self, t)
		if self:isTalentActive(self.T_PSIBLADES) then self:forceUseTalent(self.T_PSIBLADES, {ignore_cooldown=true, ignore_energy=true}) end
		switch_1hstar(self, t)
		local ret = {}
		t.updateMindBuff(self, t, ret)
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		self:removeTemporaryValue("combat_mindpower", p.mid)
		self:removeTemporaryValue("combat_mindcrit", p.cid)
		return true
	end,
	info = function(self, t)
		return ([[You imbue your offhand mindstar with wild psionic forces.
		While active you gain %d%% more of your mindstar's mindpower and mind critical chance.
		Each time you make a melee attack you also add a stack of Psionic Disruption to your target.
		Each stack lasts for %d turns and deals %0.2f mind damage over the duration (max %d stacks).
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(t.getBuff(self, t), t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getStacks(self, t))
	end,
}

newTalent{
	name = "Shockstar",
	type = {"psionic/battle-psionics", 2},
	require = psi_wil_req2,
	points = 5,
	psi = 20,
	cooldown = 15,
	tactical = { ATTACK = { weapon = 3 }, DISABLE = 3 },
	range = 1,
	direct_hit = true,
	requires_target = true,
	is_melee = true,
	on_pre_use = check_1hstar,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getMDam = function(self, t) return self:combatTalentWeaponDamage(t, 1.2, 1.9) end,
	getODam = function(self, t) return self:combatTalentWeaponDamage(t, 3.5, 5.5) end,
	getDur = function(self, t) return math.floor(self:combatTalentLimit(t, 14, 6, 12)) end,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 4)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not target then return nil end
		switch_1hstar(self, t)

		local mainhand, offhand = self:hasDualWeapon(nil, "mindstar")
		local speed, hit = self:attackTargetWith(target, mainhand.combat, nil, t.getMDam(self, t))
		if hit then
			local speed, hit = self:attackTargetWith(target, offhand.combat, nil, t.getODam(self, t))
			if hit then
				local eff = target:hasEffect(target.EFF_PSIONIC_DISRUPTION)
				local dur = t.getDur(self, t) / 4 * (eff and eff.stacks or 1)
				local rad = t.getRadius(self, t)
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, dur, {apply_power=self:combatMindpower()})
				end
				self:project({type="ball", radius=rad, x=x, y=y}, x, y, function(px, py)
					local a = game.level.map(px, py, Map.ACTOR)
					if a and a ~= target and a ~= self then
						if target:canBe("stun") then
							a:setEffect(target.EFF_DAZED, dur, {apply_power=self:combatMindpower()})
						end
					end
				end)
				game.level.map:particleEmitter(x, y, rad, "shockwave", {radius=rad, distort_color=colors.simple1(colors.ROYAL_BLUE), allow=core.shader.allow("distort")})
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[You make a first attack with your mainhand for %d%% weapon damage.
		If the attack hits the target is distracted and you use that to violently slam your mindstar into it, dealing %d%% damage.
		The shock is so powerful the target is stunned for %d turns and all creatures around in radius %d are dazed for the same time.
		The stun and daze duration is dependant on the number of psionic disruption charges on the target, the given number is for 4 charges.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(t.getMDam(self, t)*100, t.getODam(self, t)*100, t.getDur(self, t), t.getRadius(self, t))
	end,
}

newTalent{
	name = "Dazzling Lights",
	type = {"psionic/battle-psionics", 3},
	require = psi_wil_req3,
	points = 5,
	psi = 20,
	cooldown = 14,
	tactical = { ATTACKAREA = { MIND = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 2 } },
	direct_hit = true,
	requires_target = true,
	range = 0,
	on_pre_use = check_1hstar,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	getDam = function(self, t) return self:combatTalentWeaponDamage(t, 1, 2.1) end,
	action = function(self, t)
		switch_1hstar(self, t)
		local tg = self:getTalentTarget(t)
		local melee = {}
		self:project(tg, self.x, self.y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a then
				if a:canBe("blind") then
					a:setEffect(a.EFF_BLINDED, t.getDur(self, t), {apply_power=self:combatMindpower(), dist=3})
					if a:hasEffect(a.EFF_BLINDED) and core.fov.distance(self.x, self.y, a.x, a.y) <= 1 then
						melee[#melee+1] = a
					end
				end
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, max_alpha=80})

		if #melee > 0 then
			local mainhand, offhand = self:hasDualWeapon(nil, "mindstar")
			for _, a in ipairs(melee) do
				self:attackTargetWith(a, mainhand.combat, nil, t.getDam(self, t))
			end
			self:addParticles(Particles.new("meleestorm", 1, {radius=1, img="spinningwinds_blue"}))
		end

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[Raising your mindstar in the air you channel a bright flash of light through it. Any creatures in radius %d is blinded for %d turns.
		If any foe in melee range is blinded by the effect you quickly use that to your advantage by striking them with a blow of your main hand weapon doing %d%% damage.
		If you do not have a one handed weapon and a mindstar equiped, but have them in your off set, you instantly automatically switch. The wild psionic powers are incompatible with the focused nature of psiblades.]]):
		tformat(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t) * 100)
	end,
}

newTalent{
	name = "Psionic Block",
	type = {"psionic/battle-psionics", 4},
	require = psi_wil_req4,
	points = 5,
	psi = 30,
	cooldown = 15,
	fixed_cooldown = true,
	on_pre_use = check_1hstar,
	requires_target = true,
	tactical = { DEFEND = 2 },
	getChance = function(self, t) return self:combatTalentLimit(t, 70, 20, 50) end,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 230) end,
	action = function(self, t)
		switch_1hstar(self, t)
		self:setEffect(self.EFF_PSIONIC_BLOCK, 5, {chance=t.getChance(self, t), dam=t.getDam(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[You concentrate to create a psionic block field all around you for 5 turns.
		While the effect holds all damage against you have a %d%% chance to be fully ignored.
		When damage is cancelled you instinctively make a retaliation mind strike against the source, dealing %0.2f mind damage. (The retaliation may only happen 2 times per turn.)
		]]):
		tformat(t.getChance(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
