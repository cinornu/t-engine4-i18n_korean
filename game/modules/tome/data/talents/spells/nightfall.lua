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
	name = "Invoke Darkness",
	type = {"spell/nightfall",1},
	require = spells_req1,
	points = 5,
	mana = 10,
	cooldown = 3,
	tactical = { ATTACKAREA = { DARKNESS = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	direct_hit = true,
	target = function(self, t)
		local tg = {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t}
		if self:getTalentLevel(t) >= 5 then tg = {type="widebeam", radius=1, range=self:getTalentRange(t), friendlyfire=false, talent=t} end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 220) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "shadow_beam", {widebeam=self:getTalentLevel(t) >= 5, tx=x-self.x, ty=y-self.y})

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Conjures up a beam of darkness, doing %0.2f darkness damage.
		At level 5, the beam widens to hit foes on each side.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Night Sphere", short_name = "CIRCLE_OF_DEATH",
	type = {"spell/nightfall",2},
	require = spells_req2,
	points = 5,
	mana = 40,
	cooldown = 16,
	tactical = { ATTACKAREA = { DARKNESS = 2 }, DISABLE = { confusion = 1.5, blind = 1.5 } },
	range = 6,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 60) end,
	getDuration = function(self, t) return 5 end,
	getBaneDur = function(self,t) return math.floor(self:combatTalentScale(t, 4.5, 6.5)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.CIRCLE_DEATH, {dam=self:spellCrit(t.getDamage(self, t)), dur=t.getBaneDur(self,t), ff=true},
			self:getTalentRadius(t),
			5, nil,
			{type="circle_of_death", overlay_particle={zdepth=6, only_one=true, type="circle", args={oversize=1, a=100, appear=8, speed=-0.05, img="necromantic_circle", radius=self:getTalentRadius(t)}}},
--			{zdepth=6, only_one=true, type="circle", args={oversize=1, a=130, appear=8, speed=-0.03, img="arcane_circle", radius=self:getTalentRadius(t)}},
			nil, false, false
		)

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Dark fumes erupt from the ground for 5 turns. Any creature entering the circle will receive either a bane of confusion or a bane of blindness.
		Only one bane can affect a creature.
		Banes last for %d turns, and also deal %0.2f darkness damage.
		The damage will increase with your Spellpower.]]):
		tformat(t.getBaneDur(self,t), damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Erupting Shadows",
	type = {"spell/nightfall",3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	sutain_mana = 20,
	cooldown = 10,
	tactical = { BUFF=1 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 250) / 5 end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if dead or not death_note or not death_note.damtype or target == self then return end
		if death_note.damtype ~= DamageType.DARKNESS then return end
		if target.turn_procs.doing_bane_damage then return end

		local banes = target:effectsFilter{subtype={bane=true}}
		if #banes == 0 then return end

		for _, baneid in ipairs(banes) do
			local bane = target:hasEffect(baneid)
			if bane then bane.dur = bane.dur + 1 end
		end
		
		if target.turn_procs.erupting_shadows then return end
		target.turn_procs.erupting_shadows = true

		DamageType:get(DamageType.DARKNESS).projector(self, target.x, target.y, DamageType.DARKNESS, t:_getDamage(self))
	end,
	activate = function(self, t)
		local ret = {}
		return ret
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Shadows engulf your foes, anytime you deal darkness damage to a creature affected by a bane, the bane's duration is increased by 1 turn and the shadows erupt, dealing an additional %0.2f darkness damage.
		The damage can only happen once per turn per creature, the turn increase however always happens.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "River of Souls",
	type = {"spell/nightfall",4},
	require = spells_req4,
	points = 5,
	mode = "sustained",
	mana = 30, -- Not sustain cost, cast cost
	cooldown = 15,
	tactical = { ATTACKAREA = { DARKNESS = 3 } },
	range = 7,
	direct_hit = true,
	requires_target = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 4)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t, display={particle="bolt_dark", trail="darktrail"}} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220) end,
	iconOverlay = function(self, t, p)
		local val = p.dur
		if val <= 0 then return "" end
		return tostring(math.ceil(val)), "buff_font_small"
	end,
	callbackOnChangeLevel = function(self, t, what)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if what ~= "leave" then return end
		self:forceUseTalent(t.id, {ignore_energy=true})
	end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end

		if self:getSoul() <= 0 then
			self:forceUseTalent(t.id, {ignore_energy=true})
			return
		end

		local tg = self:getTalentTarget(t)
		self:projectile(tg, p.x, p.y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)), {type="dark"})
		self:incSoul(-1)
		p.dur = p.dur - 1

		if self:getSoul() <= 0 or p.dur <= 0 then
			self:forceUseTalent(t.id, {ignore_energy=true})
			return
		end
	end,
	on_pre_use = function(self, t) return self:getSoul() > 0 end,
	activate = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		return {x=x, y=y, dur=5}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You summon a river of tortured souls to launch an onslaught of darkness against your foes.
		Every turn for 5 turns you launch a projectile towards the designated area that explodes in radius %d, dealing %0.2f darkness damage.
		Each projectile consumes a soul and the spell ends when it has sent 5 projectiles or when you have no more souls to use.
		The damage will increase with your Spellpower.]]):
		tformat(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, damage))
	end,
}
