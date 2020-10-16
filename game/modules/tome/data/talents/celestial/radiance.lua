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

function radianceRadius(self)
	return self:getTalentRadius(self:getTalentFromId(self.T_RADIANCE))
end

newTalent{
	name = "Radiance",
	type = {"celestial/radiance", 1},
	mode = "passive",
	require = divi_req_high1,
	points = 5,
	radius = function(self, t) return self:combatTalentLimit(t, 14, 4, 10) end,
	getResist = function(self, t) return self:combatTalentLimit(t, 100, 25, 67) end,
	getLightResist = function(self, t) return self:combatTalentScale(t, 15, 35) end,
	getAffinity = function(self, t) return self:combatTalentLimit(t, 50, 15, 33) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "radiance_aura", radianceRadius(self))
		self:talentTemporaryValue(p, "blind_immune", t.getResist(self, t) / 100)
		self:talentTemporaryValue(p, "resists",{[DamageType.LIGHT]=t.getLightResist(self, t)})
		self:talentTemporaryValue(p, "damage_affinity", {[DamageType.LIGHT] = t.getAffinity(self, t)})
	end,
	info = function(self, t)
		return ([[You are so infused with sunlight that your body glows permanently in radius %d, even in dark places.
		Your vision and body adapt to this glow, giving you %d%% blindness resistance, %d%% light resistance, and %d%% light affinity.
		The light radius overrides your normal light if it is bigger (it does not stack).
		]]):
		tformat(radianceRadius(self), t.getResist(self, t), t.getLightResist(self, t), t.getAffinity(self, t))
	end,
}

newTalent{
	name = "Judgement",
	type = {"celestial/radiance", 2},
	require = divi_req_high2,
	points = 5,
	cooldown = 30,
	positive = 20,
	tactical = { ATTACKAREA = {LIGHT = 2}, HEAL = 2},
	requires_target = true,
	radius = function(self) return radianceRadius(self) end,
	range = function(self) return radianceRadius(self) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius = self:getTalentRadius(t), selffire = false, friendlyfire = false, talent=t} end,
	getMoveDamage = function(self, t) return self:combatTalentSpellDamage(t, 3, 50) end,
	getExplosionDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 250) end,
	getSavePen = function(self, t) return self:combatTalentSpellDamage(t, 6, 50) end,
	getCritPen = function(self, t) return self:combatTalentSpellDamage(t, 5, 40) end,
	getSplashPct = function(self, t) return self:combatTalentLimit(t, 100, 25, 55) end,
	action = function(self, t)
		local tg = t.target(self, t)
		local movedam = self:spellCrit(t.getMoveDamage(self, t))
		local dam = self:spellCrit(t.getExplosionDamage(self, t))
		self:project(tg, self.x, self.y, function(tx, ty)
			local target = game.level.map(tx, ty, engine.Map.ACTOR)
			if not target then return end

			local proj = require("mod.class.Projectile"):makeHoming(
				self,
				{particle="bolt_light", trail="lighttrail"},
				{speed=1, name=_t"Judgement", dam={dam=dam, save=t.getSavePen(self,t), crit=t.getCritPen(self,t), splash=t.getSplashPct(self,t)}, movedam=movedam},
				target,
				self:getTalentRange(t),
				function(self, src)
					local DT = require("engine.DamageType")
					DT:get(DT.JUDGEMENT).projector(src, self.x, self.y, DT.JUDGEMENT, self.def.movedam)
				end,
				function(self, src, target)
					local DT = require("engine.DamageType")
					local grids = src:project({type="ball", radius=1, x=self.x, y=self.y}, self.x, self.y, DT.JUDGEMENT, self.def.dam.dam)
					local t = src:getTalentFromId(src.T_JUDGEMENT)
					game.level.map:particleEmitter(self.x, self.y, 1, "sunburst", {radius=1, grids=grids, tx=self.x, ty=self.y})
					game:playSoundNear(self, "talents/lightning")
					target:setEffect(target.EFF_LIGHTBLIGHT, 4, {src=src, saves=self.def.dam.save, crit=self.def.dam.crit, splash=self.def.dam.splash, apply_power=src:combatSpellpower()})
				end
			)
			game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
		end)

		return true
	end,
	info = function(self, t)
		return ([[Fire a glowing orb of light at each enemy within your Radiance.  Each orb will slowly follow its target until it connects, dealing %d light damage to anything else it contacts along the way.  When the target is reached the orb will explode dealing %d light damage in radius 1 and healing you for 50%% of the damage dealt.
		All targets struck by your Judgement will be blighted by light, reducing saves by %d, reducing critical power by %d%%, and causing light damage received to splash in radius 2 for %d%% damage against all hostile targets for 4 turns.]]):
		tformat(t.getMoveDamage(self, t), t.getExplosionDamage(self, t), t.getSavePen(self,t), t.getCritPen(self,t), t.getSplashPct(self,t))
	end,
}

newTalent{
	name = "Searing Sight",
	type = {"celestial/radiance",3},
	require = divi_req_high3,
	mode = "sustained",
	points = 5,
	cooldown = 15,
	range = function(self) return radianceRadius(self) end,
	tactical = { ATTACKAREA = {LIGHT=1} },
	sustain_positive = 10,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 3, 35) end,
	getDaze = function(self, t) return self:combatTalentLimit(t, 35, 8, 25) end,
	updateParticle = function(self, t)
		local p = self:isTalentActive(self.T_SEARING_SIGHT)
		if not p then return end
		self:removeParticles(p.particle)
		p.particle = self:addParticles(Particles.new("circle", 1, {toback=true, oversize=1, a=20, appear=4, speed=-0.2, img="radiance_circle", radius=self:getTalentRange(t)}))
	end,
	activate = function(self, t)
		return {
			particle = self:addParticles(Particles.new("circle", 1, {toback=true, oversize=1, a=20, appear=4, speed=-0.2, img="radiance_circle", radius=self:getTalentRange(t)})),
			daze=t.getDaze(self, t),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	callbackOnActBase = function(self, t)
		local radius = radianceRadius(self)
		local grids = core.fov.circle_grids(self.x, self.y, radius, true)
		local damage = t.getDamage(self, t)
		local daze = t.getDaze(self, t)

		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do local target = game.level.map(x, y, Map.ACTOR) if target and self ~= target then
			if (self:reactionToward(target) < 0) then
				DamageType:get(DamageType.LIGHT).projector(self, target.x, target.y, DamageType.LIGHT, damage)
				if not target:hasEffect(target.EFF_DAZED) and daze and not target:hasProc("searing_daze") and rng.percent(daze) and target:canBe("stun") then
					target:setProc("searing_daze", true, 7)
					target:setEffect(target.EFF_DAZED, 3, {apply_power=self:combatSpellpower()})
				end
				if not target:hasEffect(target.EFF_BLINDED) and daze and not target:hasProc("searing_blind") and rng.percent(daze) and target:canBe("blind") then
					target:setProc("searing_blind", true, 7)
					target:setEffect(target.EFF_BLINDED, 3, {apply_power=self:combatSpellpower()})
				end
				if self:knowTalent(self.T_ILLUMINATION) then
					local ill = self:getTalentFromId(self.T_ILLUMINATION)
					target:setEffect(target.EFF_ILLUMINATION, 1, {power=ill.getPower(self, ill), def=ill.getDef(self, ill)})
				end
		end
		end end end
	end,
	info = function(self, t)
		return ([[Your Radiance is so powerful it burns all foes caught in it, dealing %0.1f light damage to all foes caught inside every turn.
		Each enemy effected has a %d%% chance of being dazed and blinded by the light for 3 turns. The daze and blind can be applied to each enemy at most once every 7 turns.
		The damage increases with your Spellpower.]]):
		tformat(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getDaze(self, t))
	end,
}

newTalent{
	name = "Illumination",
	type = {"celestial/radiance", 4},
	require = divi_req_high4,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return 15 + self:combatTalentSpellDamage(t, 1, 100) end,
	getDef = function(self, t) return 5 + self:combatTalentSpellDamage(t, 1, 35) end,
	getLightDamageIncrease = function(self, t) return self:combatTalentScale(t, 2.5, 10) end,
	getResPen = function(self, t) return self:combatTalentLimit(t, 60, 17, 50) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists_pen", {[DamageType.LIGHT] = t.getResPen(self, t)})
		self:talentTemporaryValue(p, "inc_damage", {[DamageType.LIGHT] = t.getLightDamageIncrease(self, t)})
	end,
	info = function(self, t)
		return ([[The light of your Radiance allows you to see that which would normally be unseen and strike that which would normally be protected.
		All enemies in your Radiance aura have their invisibility and stealth power reduced by %d; all actors affected by illumination have their defense reduced by %d as well as all evasion bonuses from being unseen negated.
		In addition, your light damage is increased by %d%% and your strikes ignore %d%% of the light resistance of your targets.
		The invisibility, stealth power, and defense reductions increase with your Spellpower.]]):
		tformat(t.getPower(self, t), t.getDef(self, t), t.getLightDamageIncrease(self, t), t.getResPen(self, t))
	end,
}

