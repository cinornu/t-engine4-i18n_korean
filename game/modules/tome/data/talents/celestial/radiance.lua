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
	require = divi_req1,
	points = 5,
	radius = function(self, t) return self:combatTalentLimit(t, 14, 3, 10) end,
	getResist = function(self, t) return self:combatTalentLimit(t, 100, 25, 75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "radiance_aura", radianceRadius(self))
		self:talentTemporaryValue(p, "blind_immune", t.getResist(self, t) / 100)
	end,
	info = function(self, t)
		return ([[You are so infused with sunlight that your body glows permanently in radius %d, even in dark places.
		Your vision adapts to this glow, giving you %d%% blindness resistance.
		The light radius overrides your normal light if it is bigger (it does not stack).
		]]):
		tformat(radianceRadius(self), t.getResist(self, t))
	end,
}

newTalent{
	name = "Illumination",
	type = {"celestial/radiance", 2},
	require = divi_req2,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return 15 + self:combatTalentSpellDamage(t, 1, 100) end,
	getDef = function(self, t) return 5 + self:combatTalentSpellDamage(t, 1, 35) end,
	callbackOnActBase = function(self, t)
		local radius = radianceRadius(self)
		local grids = core.fov.circle_grids(self.x, self.y, radius, true)
		local ss = self:isTalentActive(self.T_SEARING_SIGHT)
		local ss_talent = self:getTalentFromId(self.T_SEARING_SIGHT)
		local damage = ss_talent.getDamage(self, ss_talent)
		local daze = ss_talent.getDaze(self, ss_talent)

		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do local target = game.level.map(x, y, Map.ACTOR) if target and self ~= target then
			if (self:reactionToward(target) < 0) then
				target:setEffect(target.EFF_ILLUMINATION, 1, {power=t.getPower(self, t), def=t.getDef(self, t)})
				if ss and not target:hasEffect(target.EFF_DAZED) then
					DamageType:get(DamageType.LIGHT).projector(self, target.x, target.y, DamageType.LIGHT, damage)
					if daze and rng.percent(ss.daze) and target:canBe("stun") then
						target:setEffect(target.EFF_DAZED, 5, {apply_power=self:combatSpellpower()})
					end
				end
		end
		end end end
	end,
	info = function(self, t)
		return ([[The light of your Radiance allows you to see that which would normally be unseen.
		All enemies in your Radiance aura have their invisibility and stealth power reduced by %d.
		In addition, all actors affected by illumination are easier to see and therefore hit; their defense is reduced by %d and all evasion bonuses from being unseen are negated.
		The effects increase with your Spellpower.]]):
		tformat(t.getPower(self, t), t.getDef(self, t))
	end,
}

newTalent{
	name = "Searing Sight",
	type = {"celestial/radiance",3},
	require = divi_req3,
	mode = "sustained",
	points = 5,
	cooldown = 15,
	range = function(self) return radianceRadius(self) end,
	tactical = { ATTACKAREA = {LIGHT=1} },
	sustain_positive = 10,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 35) end,
	getDaze = function(self, t) return self:combatTalentLimit(t, 35, 5, 25) end,
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
	info = function(self, t)
		return ([[Your Radiance is so powerful it burns all foes caught in it, doing %0.1f light damage to all non-dazed foes caught inside.
		Each enemy effected has a %d%% chance of being dazed for 5 turns.
		The damage increases with your Spellpower.]]):
		tformat(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getDaze(self, t))
	end,
}

newTalent{
	name = "Judgement",
	type = {"celestial/radiance", 4},
	require = divi_req4,
	points = 5,
	cooldown = 25,
	positive = 20,
	tactical = { ATTACKAREA = {LIGHT = 2}, HEAL = 2},
	requires_target = true,
	radius = function(self) return radianceRadius(self) end,
	range = function(self) return radianceRadius(self) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius = self:getTalentRadius(t), selffire = false, friendlyfire = false, talent=t} end,
	getMoveDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 40) end,
	getExplosionDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 150) end,
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
				{speed=1, name=_t"Judgement", dam=dam, movedam=movedam},
				target,
				self:getTalentRange(t),
				function(self, src)
					local DT = require("engine.DamageType")
					DT:get(DT.JUDGEMENT).projector(src, self.x, self.y, DT.JUDGEMENT, self.def.movedam)
				end,
				function(self, src, target)
					local DT = require("engine.DamageType")
					local grids = src:project({type="ball", radius=1, x=self.x, y=self.y}, self.x, self.y, DT.JUDGEMENT, self.def.dam)
					game.level.map:particleEmitter(self.x, self.y, 1, "sunburst", {radius=1, grids=grids, tx=self.x, ty=self.y})
					game:playSoundNear(self, "talents/lightning")
				end
			)
			game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
		end)

		return true
	end,
	info = function(self, t)
		return ([[Fire a glowing orb of light at each enemy within your Radiance.  Each orb will slowly follow its target until it connects dealing %d light damage to anything else it contacts along the way.  When the target is reached the orb will explode dealing %d light damage in radius 1 and healing you for 50%% of the damage dealt.]]):
		tformat(t.getMoveDamage(self, t), t.getExplosionDamage(self, t))
	end,
}

