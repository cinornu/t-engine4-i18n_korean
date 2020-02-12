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

local function check_2h(self, t, silent, only_first)
	if self:attr("disarmed") then
		if not silent then game.logPlayer(self, "You are disarmed.") end
		return false
	end
	if not self:hasTwoHandedWeapon() then
		if not only_first then
			local mh2 = self.inven[self.INVEN_QS_MAINHAND]
			if mh2 and mh2[1] and mh2[1].combat and mh2[1].twohanded then
				return true
			end
		end
	else
		return true
	end
	if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end
	return false
end

local function switch_2h(self, t)
	if not self:hasTwoHandedWeapon() then
		local mh2 = self.inven[self.INVEN_QS_MAINHAND]
		if mh2 and mh2[1] and mh2[1].combat and mh2[1].twohanded then
			self:attr("no_sound", 1)
			self:quickSwitchWeapons(true, "possessor", false)
			self:attr("no_sound", -1)
		end
	end
end
newTalent{
	name = "Psychic Crush",
	type = {"psionic/psychic-blows", 1},
	require = psi_wil_req1,
	points = 5,
	cooldown = 6,
	psi = 19,
	tactical = { ATTACK = { weapon = 2 }, ANNOY = 1 },
	range = 1,
	is_melee = true,
	requires_target = true,
	on_pre_use = check_2h,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDam = function(self, t) return self:combatTalentWeaponDamage(t, 1.2, 1.9) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	getChance = function(self, t) return math.floor(util.bound(self:getTalentLevel(t) * 7 + 30, 1, 100)) end,
	summon_minion = function(self, t, target)
		if target:attr("summon_time") then return end

		-- Find space
		local dir = util.getDir(target.x, target.y, self.x, self.y)
		local x, y = util.coordAddDir(target.x, target.y, dir)
		if not target:canMove(x, y) then
			x, y = util.findFreeGrid(target.x, target.y, 1, true, {[Map.ACTOR]=true})
			if not x then return end
		end

		local m = target:cloneFull{
			shader = "shadow_simulacrum", shader_args = { color = {0.3, 0.5, 1}, base = 0.5, time_factor = 1500 },
			no_drops = true, keep_inven_on_death = false,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=target},
			ai = "summoned", ai_real = "tactical",
			name = ("%s's Psychic Image"):tformat(target:getName()),
			desc = [[A temporary psionic imprint.]],
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil
		m.on_added = nil

		mod.class.NPC.castAs(m)
		engine.interface.ActorAI.init(m, m)

		m.psionic_clone = 1
		m.exp_worth = 0
		m.energy.value = 0
		m.player = nil
		m.max_life = m.max_life / 2 / m.rank
		m.life = util.bound(m.life, 0, m.max_life)
		m.inc_damage.all = (m.inc_damage.all or 0) - 50
		m.forceLevelup = function() end
		m.on_die = nil
		m.die = nil
		m.puuid = nil
		m.on_acquire_target = nil
		m.no_inventory_access = true
		m.on_takehit = nil
		m.seen_by = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		m.self_resurrect = nil
		m.no_rod_recall = true
		if m.talents.T_SUMMON then m.talents.T_SUMMON = nil end
		if m.talents.T_MULTIPLY then m.talents.T_MULTIPLY = nil end
		
		-- Inner Demon's never flee
		m.ai_tactic = m.ai_tactic or {}
		m.ai_tactic.escape = 0
		
		-- Remove some talents
		local tids = {}
		for tid, _ in pairs(m.talents) do
			local t = m:getTalentFromId(tid)
			if t.no_npc_use then tids[#tids+1] = t end
		end
		for i, t in ipairs(tids) do
			if t.mode == "sustained" and m:isTalentActive(t.id) then m:forceUseTalent(t.id, {ignore_energy=true}) end
			m.talents[t.id] = nil
		end
		
		-- remove detrimental timed effects
		local effs = {}
		for eff_id, p in pairs(m.tmp) do
			local e = m.tempeffect_def[eff_id]
			if e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		while #effs > 0 do
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" then
				m:removeEffect(eff[2])
			end
		end

		if not target.dead then m:setTarget(target) end

		m.energy.value = -game.energy_to_act
		game.zone:addEntity(game.level, m, "actor", x, y)
		-- game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=20, rM=40, gm=20, gM=110, bm=130, bM=250, am=70, aM=180})

		game.logSeen(target, "#ROYAL_BLUE#%s's psychic imprint appears!", target:getName():capitalize())

		if config.settings.tome.smooth_move > 0 and target.x then
			local ox, oy = target.x, target.y
			game:onTickEnd(function()
				m:resetMoveAnim()
				m:setMoveAnim(ox, oy, 5, 5)
			end)
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) or target == self then return nil end
		switch_2h(self, t)

		local weapon = self:hasTwoHandedWeapon()
		local speed, hit = self:attackTargetWith(target, weapon.combat, DamageType.MIND, t.getDam(self, t))
		local a = util.dirToAngle(util.getDir(target.x, self.y, self.x, target.y))
		game.level.map:particleEmitter(target.x, target.y, 2, "circle", {shader=true, appear_size=0, base_rot=45 + a, a=110, appear=6, limit_life=4, speed=0, img="spatial_fragment", radius=-0.2})
		-- game.level.map:particleEmitter(self.x, self.y, 2, "psychic_blow", {})

		-- Try to stun !
		if hit and rng.percent(t.getChance(self, t)) then
			if target:checkHit(self:combatMindpower(), target:combatMentalResist(), 0, 95, 15) then
				t.summon_minion(self, t, target)
			else
				game.logSeen(target, "%s resists the psychic blow!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Using both your mind and your arms you propel your two handed weapon to deal a huge strike doing %d%% weapon mind damage.
		If the blow connects and the target fails a mental save there is %d%% chance that the blow was so powerful it ripped a psychic imprint off the target.
		It will appear nearby and serve you for %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]]):
		tformat(t.getDam(self, t) * 100, t.getChance(self, t), t.getDuration(self,t))
	end,
}

newTalent{
	name = "Force Shield",
	type = {"psionic/psychic-blows", 2},
	require = psi_wil_req2,
	points = 5,
	mode = "sustained",
	sustain_psi = 20,
	cooldown = 12,
	tactical = { DEFEND = 2, BUFF = 2 },
	on_pre_use = check_2h,
	getDam = function(self, t) return self:combatTalentWeaponDamage(t, 0.2, 0.6) end,
	getEvasion = function(self, t) return self:combatTalentLimit(t, 25, 5, 16) end,
	getMaxDamage = function(self, t) return math.max(60, 100 - self:getTalentLevelRaw(t) * 6) end,
	callbackOnMeleeHit = function(self, t, src, dam)
		local weapon = self:hasTwoHandedWeapon()
		if self.turn_procs.force_shield or not weapon or dam <= 0 then return end
		self.turn_procs.force_shield = true
		local speed, hit = self:attackTargetWith(src, weapon.combat, DamageType.MIND, t.getDam(self, t))
	end,
	updateLook = function(self, t, p)
		if core.shader.active() then
			local type = "volumetric/fast_sphere"
			if not check_2h(self, t, true, true) then type = "volumetric/horizontal_ellipsoid" end
			if p.particle1 then self:removeParticles(p.particle1) end
			if p.particle2 then self:removeParticles(p.particle2) end
			p.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, img="force_shield_texture"}, {type=type, noup=2.0}))
			p.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, img="force_shield_texture"}, {type=type, noup=1.0}))
		end
	end,
	callbackOnQuickSwitchWeapons = function(self, t) t.updateLook(self, t, self:isTalentActive(t.id)) end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "flat_damage_cap", {all=t.getMaxDamage(self, t)})
		self:talentTemporaryValue(ret, "evasion", t.getEvasion(self, t))
		t.updateLook(self, t, ret)
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		return true
	end,
	info = function(self, t)
		return ([[You create a psionic shield from your weapon that prevents you from ever taking blows that deal more than %d%% of your maximum life and gives you %d%% evasion.
		In addition, each time you take a melee hit the attacker automatically takes revenge strike that deals %d%% weapon damage as mind damage. (This effect can only happen once per turn)
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]]):
		tformat(t.getMaxDamage(self, t), t.getEvasion(self, t), t.getDam(self, t) * 100)
	end,
}

newTalent{
	name = "Unleashed Mind",
	type = {"psionic/psychic-blows", 3},
	require = psi_wil_req3,
	points = 5,
	psi = 19,
	cooldown = 13,
	tactical = { ATTACKAREA = { MIND = 3 }, },
	direct_hit = true,
	requires_target = true,
	range = 0,
	on_pre_use = check_2h,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 5, 10)) end,
	getDam = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.9) end,
	action = function(self, t)
		switch_2h(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then return end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				self:attackTargetWith(a, weapon.combat, DamageType.MIND, t.getDam(self, t))
			elseif a and a.psionic_clone then
				a.summon_time = a.summon_time + t.getDur(self, t)
			end
		end)
		self:addParticles(Particles.new("meleestorm", tg.radius, {radius=tg.radius, img="spinningwinds_psi"}))
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[You concentrate your powerful psionic powers on your weapon and briefly unleash your fury.
		All foes in radius %d will take a melee attack dealing %d%% weapon damage as mind damage.
		Any psionic clones in the radius will have its remaining time extended by %d turns.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]]):
		tformat(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getDur(self, t))
	end,
}

newTalent{
	name = "Seismic Mind",
	type = {"psionic/psychic-blows", 4},
	require = psi_wil_req4,
	points = 5,
	psi = 20,
	cooldown = 18,
	tactical = { ATTACKAREA = { MIND = 3 }, },
	direct_hit = true,
	requires_target = true,
	range = 0,
	on_pre_use = check_2h,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	target = function(self, t) return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	getDam = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.8) end,
	getExplosionDam = function(self, t) return self:combatTalentSpellDamage(t, 28, 180) end,
	action = function(self, t)
		switch_2h(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then return end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x then return nil end

		self:project(tg, x, y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				self:attackTargetWith(a, weapon.combat, DamageType.MIND, t.getDam(self, t))
			elseif a and a.psionic_clone then
				a:die(self)
				self:project({type="ball", radius=1, x=px, y=py, friendlyfire=false}, px, py, DamageType.PHYSICAL, t.getExplosionDam(self, t))
				game.level.map:particleEmitter(px, py, 1, "psionicflash", {radius=1})
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "gravity_breath", {radius=tg.radius, tx=x-self.x, ty=y-self.y, allow=core.shader.allow("distort")})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "directional_shout", {tx=x-self.x, ty=y-self.y, additive=true, life=10, size=3, distorion_factor=0.5, radius=tg.radius, nb_circles=8, rm=0.1, rM=0.2, gm=0.8, gM=1, bm=0.5, bM=0.7, am=0.4, aM=0.6})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[You shatter your weapon in the ground, projecting a psionic shockwave in a cone of radius %d.
		Any foes in the area will take %d%% weapon damage as mind damage.
		Any psionic clones hit will instantly shatter, exploding for %0.2f physical damage in radius 1.
		If you do not have a two handed weapon equiped, but have it in your off set, you instantly automatically switch.]]):
		tformat(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getExplosionDam(self, t))
	end,
}
