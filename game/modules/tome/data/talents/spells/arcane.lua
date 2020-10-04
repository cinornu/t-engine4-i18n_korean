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
	name = "Manathrust",
	type = {"spell/arcane", 1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 10,
	cooldown = 3,
	use_only_arcane = 1,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = 10,
	proj_speed = 20,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 3 then return true else return false end end,
	reflectable = true,
	is_beam_spell = true,
	requires_target = true,
	target = function(self, t)
		if thaumaturgyCheck(self) then return {type="widebeam", radius=1, range=self:getTalentRange(t), talent=t, selffire=false, friendlyfire=self:spellFriendlyFire()} end
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_arcane", trail="arcanetrail"}}
		if self:getTalentLevel(t) >= 3 then tg.type = "beam" end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = thaumaturgyBeamDamage(self, self:spellCrit(t.getDamage(self, t)))
		if tg.type == "beam" or tg.type == "widebeam" then
			self:project(tg, x, y, DamageType.ARCANE, dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			if thaumaturgyCheck(self) then
				game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "mana_beam_wide", {tx=x-self.x, ty=y-self.y})
			else
				game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "mana_beam", {tx=x-self.x, ty=y-self.y})
			end
		else
			self:projectile(tg, x, y, DamageType.ARCANE, dam, {type="manathrust"})
		end
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Conjures up mana into a powerful bolt doing %0.2f arcane damage.
		At level 3, it becomes a beam.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.ARCANE, damage))
	end,
}

newTalent{
	name = "Arcane Power",
	type = {"spell/arcane", 2},
	mode = "sustained",
	require = spells_req2,
	sustain_mana = 25,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	use_only_arcane = 1,
	getSpellpowerIncrease = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	getArcaneResist = function(self, t) return 5 + self:combatTalentSpellDamage(t, 10, 500) / 18 end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		return {
			res = self:addTemporaryValue("resists", {[DamageType.ARCANE] = t.getArcaneResist(self, t)}),
			display_resist = t.getArcaneResist(self, t),
			power = self:addTemporaryValue("combat_spellpower", t.getSpellpowerIncrease(self, t)),
			particle = self:addParticles(Particles.new("arcane_power", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_spellpower", p.power)
		self:removeTemporaryValue("resists", p.res)
		return true
	end,
	info = function(self, t)
		local resist = self.sustain_talents[t.id] and self.sustain_talents[t.id].display_resist or t.getArcaneResist(self, t)
		return ([[Your mastery of magic allows you to enter a state of deep concentration, increasing your Spellpower by %d and arcane resistance by %d%%.]]):
		tformat(t.getSpellpowerIncrease(self, t), resist)
	end,
}

newTalent{
	name = "Arcane Vortex",
	type = {"spell/arcane", 3},
	require = spells_req3,
	points = 5,
	mana = 20,
	cooldown = 12,
	use_only_arcane = 1,
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	tactical = { ATTACK = { ARCANE = 2 } },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 340) / 6 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if not target then return nil end

		self:callTalent(self.T_ENERGY_ALTERATION, "forceActivate", DamageType.ARCANE)
		target:setEffect(target.EFF_ARCANE_VORTEX, 6, {src=self, dam=self:spellCrit(t.getDamage(self, t))})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[Creates a vortex of arcane energies on the target for 6 turns. Each turn the vortex will look for another foe in sight and fire a manathrust doing %0.2f arcane damage to all foes in line.
		If no foes are found, the target will take 50%% more arcane damage.
		If the target dies, the vortex explodes, releasing all remaining damage in a radius 2 ball of arcane force.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.ARCANE, dam))
	end,
}

-- Mana gain on deactivation is mostly to preserve this talent's role as a counter to mana drain
newTalent{
	name = "Disruption Shield",
	type = {"spell/arcane",4},
	require = spells_req4, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_mana = 10,
	use_only_arcane = 1,
	no_energy = true,
	tactical = { MANA = 3, DEFEND = 2, },
	radius = function(self, t) return self:hasEffect(self.EFF_AETHER_AVATAR) and 10 or 5 end,
	getMaxAbsorb = function(self, t) return self:getShieldAmount(self:combatTalentSpellDamage(t, 50, 450)) end,
	getManaRatio = function(self, t) return self:combatTalentLimit(t, 0.2, 0.95, 0.35) end,
	-- Note: effects handled in mod.class.Actor:onTakeHit function
	getMaxDamageLimit = function(self, t) return self:combatTalentLimit(t, 1200, 400, 1000) end,
	getMaxDamage = function(self, t) -- Compute damage limit
		local max_dam = self.max_mana
		for i, k in pairs(self.sustain_talents) do -- Add up sustain costs to get total mana pool size
			max_dam = max_dam + (tonumber(self.talents_def[i].sustain_mana) or 0)
		end
		max_dam = math.min(max_dam, t.getMaxDamageLimit(self, t))
		return max_dam * 2 -- Maximum damage is 2x total mana pool
	end,
	explode = function(self, t, dam)
		game.logSeen(self, "#VIOLET#%s's disruption shield collapses and then explodes in a powerful manastorm!", self:getName():capitalize())
		dam = math.min(dam, t.getMaxDamage(self, t)) -- Damage cap
		-- Add a lasting map effect
		local radius = self:getTalentRadius(t)
		game.level.map:addEffect(self,
			self.x, self.y, 5,
			DamageType.ARCANE, self:spellCrit(dam / 5),
			radius,
			5, nil,
			{type="arcanestorm", args={radius=radius}, only_one=true},
			function(e) e.x = e.src.x e.y = e.src.y return true end,
			false
		)
	end,
	damage_feedback = function(self, t, p, src)
		if p.particle and p.particle._shader and p.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			p.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			p.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	iconOverlay = function(self, t, p)
		local val = self.disruption_shield_storage or 0
		if val <= 0 then return "" end
		local fnt = "buff_font_small"
		if val >= 1000 then fnt = "buff_font_smaller" end
		return tostring(math.ceil(val)), fnt
	end,
	callbackOnRest = function(self, t)
		self.disruption_shield_power = self.disruption_shield_power or 0
		if self.disruption_shield_power < t.getMaxAbsorb(self, t) then return true end
	end,
	callbackOnAct = function(self, t, state)
		if self.in_combat then return end
		self.disruption_shield_power = self.disruption_shield_power or 0
		self.disruption_shield_storage = self.disruption_shield_storage or 0
		self.disruption_shield_storage = self.disruption_shield_storage / 3
		if self.disruption_shield_storage < 100 then self.disruption_shield_storage = 0 end
		local max = t.getMaxAbsorb(self, t)
		self.disruption_shield_power = math.min(self.disruption_shield_power + max / 10, max)
	end,
	doLostMana = function(self, t, mana)
		if (self:getMana() - mana) / self:getMaxMana() < 0.5 then
			self:forceUseTalent(self.T_DISRUPTION_SHIELD, {ignore_energy=true})
		end
	end,
	callbackOnHit = function(self, t, cb, src, dt)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if cb.value <= 0 then return end
		if self:getMana() / self:getMaxMana() < 0.5 then
			self:forceUseTalent(self.T_DISRUPTION_SHIELD, {ignore_energy=true})
			return
		end
		-- if self:reactionToward(src) > 0 then return end
		self.disruption_shield_power = self.disruption_shield_power or 0
		self.disruption_shield_storage = self.disruption_shield_storage or 0
		local absorbed = 0

		if cb.value <= self.disruption_shield_power then
			self.disruption_shield_power = self.disruption_shield_power - cb.value
			absorbed = cb.value
			cb.value = 0
			game:delayedLogDamage(src, self, 0, ("#SLATE#(%d absorbed)#LAST#"):tformat(absorbed), false)
			return true
		else
			cb.value = cb.value - self.disruption_shield_power
			absorbed = self.disruption_shield_power
			self.disruption_shield_power = 0
		end

		local do_explode = false
		local ratio = t.getManaRatio(self, t)
		local mana_usage = cb.value * ratio
		local store = cb.value

		if self.disruption_shield_storage + store >= t.getMaxDamage(self, t) then
			do_explode = true
			store = t.getMaxDamage(self, t) - self.disruption_shield_storage
			mana_usage = store * ratio
		end
		if (self:getMana() - mana_usage) / self:getMaxMana() < 0.5 then
			do_explode = true
			local mana_limit = self:getMaxMana() * 0.3
			mana_usage = self:getMana() - mana_limit
			store = mana_usage / ratio
		end
		cb.value = cb.value - store
		absorbed = absorbed + store
		self:incMana(-mana_usage)
		self.disruption_shield_storage = math.min(self.disruption_shield_storage + store, t.getMaxDamage(self, t))

		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d absorbed)#LAST#"):tformat(absorbed), false)
		game:delayedLogDamage(src, self, 0, ("#PURPLE#(%d mana)#LAST#"):tformat(store), false)

		if do_explode then	
			-- Deactivate without losing energy
			self:forceUseTalent(self.T_DISRUPTION_SHIELD, {ignore_energy=true})
		end
		return true
	end,
	doAegis = function(self, t, val)
		local energy = self.disruption_shield_storage or 0
		local max = t.getMaxAbsorb(self, t)
		local eneed = (max - self.disruption_shield_power) * 2

		if eneed < energy then
			self.disruption_shield_power = max
			self:incMana((energy - eneed) * val / 100)
			game.logSeen(self, "%s restores Disruption Shield (+%d) and gains %d mana with Aegis!", self:getName(), eneed/2, (energy - eneed) * val / 100)
		else
			self.disruption_shield_power = self.disruption_shield_power + energy / 2
			game.logSeen(self, "%s restores Disruption Shield (+%d) with Aegis!", self:getName(), energy / 2)
		end
		self.disruption_shield_storage = 0
	end,
	activate = function(self, t)
		self.disruption_shield_storage = 0
		self.disruption_shield_power = t.getMaxAbsorb(self, t)
		game:playSoundNear(self, "talents/arcane")

		local particle
		if core.shader.active(4) then
--			particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="shield6"}, {type="shield", ellipsoidalFactor=1.05, shieldIntensity=0.1, time_factor=-2500, color={0.8, 0.1, 1.0}, impact_color = {0, 1, 0}, impact_time=800}))
			particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="runicshield"}, {type="runicshield", shieldIntensity=0.1, ellipsoidalFactor=1, scrollingSpeed=-1, time_factor=12000, bubbleColor={0.8, 0.1, 1.0, 0.8}, auraColor={0.85, 0.3, 1.0, 0.8}}))
		else
			particle = self:addParticles(Particles.new("disruption_shield", 1))
		end

		return {
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		if self:attr("save_cleanup") then return true end

		-- Explode!
		if self.disruption_shield_storage and self.disruption_shield_storage > 0 then t.explode(self, t, self.disruption_shield_storage) end
		self.disruption_shield_storage = nil
		self.disruption_shield_power = nil
		return true
	end,
	info = function(self, t)
		return ([[Surround yourself with arcane forces, disrupting any attempts to harm you by creating a shield of pure aether which can absorb %d damage.
		In combat, the mental focus required to maintain and monitor the shield is too much and you let it run on its own. In this state once the shield power is depleted it will start using your mana to absorb hits, at a ratio of %0.2f mana per damage.
		Whenever mana is used by the shield it stores a remnant of this energy (up to %d max). When the shield is deactivated any stored energy is released in a radius %d arcane storm that lasts 5 turns, dealing 20%% of the total stored damage each turn.
		Outside of combat the shield regenerates 10%% of its power each turn and stored energy quickly dissipates.
		Dropping below 50%% mana or reaching max energy storage will automatically deactivate this talent.
		The shield power improves with your Spellpower.
		The maximum energy storage is based on your total mana (ignoring sustained spells), with a limit at %d effective mana.

		Current shield power: %d
		Current stored energy: %d]]):
		tformat(t.getMaxAbsorb(self, t), t.getManaRatio(self, t), t.getMaxDamage(self, t), self:getTalentRadius(t), t.getMaxDamageLimit(self, t), self.disruption_shield_power or 0, self.disruption_shield_storage or 0)
	end,
}
