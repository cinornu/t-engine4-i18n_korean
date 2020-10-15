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
	name = "Circle of Shifting Shadows",
	type = {"celestial/circles", 1},
	require = divi_req_high1,
	points = 5,
	cooldown = 20,
	negative = 20,
	no_energy = true,
	tactical = { DEFEND = 1, ATTACKAREA = {DARKNESS = 1} },
	tactical_imp = { SELF = {DEFEND = 1}, ATTACKAREA = {DARKNESS = 1} }, -- debugging transitional
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 30) end,
	getDuration = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 4, 8))) end,
	range = 0,
	radius = function(self, t) return math.min(5, math.floor(self:combatTalentScale(t, 2.5, 4.5))) end,
	target = function(self, t) -- for AI only
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.SHIFTINGSHADOWS, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, oversize=0, img="darkness_celestial_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/darkness_effect.png"},
			nil, true --self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a circle of radius %d at your feet; the circle increases your defense and all saves by %d while dealing %0.2f darkness damage per turn to everyone else within its radius. The circle lasts %d turns.
		The damage will increase with your Spellpower.]]):
		tformat(radius, damage, (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

newTalent{
	name = "Circle of Sanctity",
	type = {"celestial/circles", 2},
	require = divi_req_high2,
	points = 5,
	cooldown = 20,
	positive = 20,
	no_energy = true,
	on_pre_use_ai = function(self, t) return not self:hasEffect(self.EFF_SANCTITY) end,
	tactical = {
		DEFEND = function(self, t, aitarget) -- can the target silence us?
			local num, t = 0
			for tid, lev in pairs(aitarget.talents) do
				t = aitarget.talents_def[tid]
				if t.tactical and type(t.tactical) == "table" and t.tactical.disable and type(t.tactical.disable) == "table" and t.tactical.disable.silence then
					num = num + 1 break
				end
			end
			return math.min(num*2, 2)
		end,
		DISABLE = function(self, t, aitarget)
			if aitarget:attr("has_arcane_knowledge") and self.fov.actors[aitarget] and self.fov.actors[aitarget].sqdist < t.radius(self, t)^2 then return {silence = 2} end
		end
	},
	tactical_imp = { SELF = {DEFEND = function(self, t) -- can our target silence us?
			local aitarget = self.ai_target.actor
			if aitarget then
				local num, t = 0
				for tid, lev in pairs(aitarget.talents) do
					t = aitarget.talents_def[tid]
					if t.tactical and type(t.tactical) == "table" and t.tactical.disable and type(t.tactical.disable) == "table" and t.tactical.disable.silence then
						num = num + 1 break
					end
				end
				return math.min(num*2, 2)
			end
			return 0
		end},
		DISABLE = {silence = function(self, t, target)
				if target:attr("has_arcane_knowledge") then return 2 end
			end}
	},
	getDuration = function(self, t) return math.min(8, math.floor(self:combatTalentScale(t, 3, 6))) end,
	range = 0,
	radius = function(self, t) return math.min(5, math.floor(self:combatTalentScale(t, 2.5, 4.5))) end,
	target = function(self, t) -- for AI only
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire = false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 30) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.SANCTITY, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, img="sun_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/sunlight_effect.png"},
			nil,
			true --self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[Creates a circle of radius %d at your feet; the circle protects you from silence effects while you remain in its radius while silencing and dealing %d light damage to everyone else who enters. The circle lasts %d turns.]]):
		tformat(radius, damDesc(self, DamageType.LIGHT, damage), duration)
	end,
}

newTalent{
	name = "Circle of Warding",
	type = {"celestial/circles", 3},
	require = divi_req_high3,
	points = 5,
	cooldown = 20,
	positive = 10,
	negative = 10,
	no_energy = true,
	tactical = { DEFEND = 0.5, ESCAPE = 1, ATTACKAREA = {LIGHT = 0.5, DARKNESS = 0.5} },
	tactical_imp = { SELF = {DEFEND = 0.5}, ESCAPE = {knockback = 1}, ATTACKAREA = {LIGHT = 0.5, DARKNESS = 0.5} }, -- debugging transitional
	getDuration = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 4, 8))) end,
	range = 0,
	radius = function(self, t) return math.min(5, math.floor(self:combatTalentScale(t, 2.5, 4.5))) end,
	target = function(self, t) -- for AI only
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 2, 20)  end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.WARDING, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, oversize=0, img="moon_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/moonlight_effect.png"},
			nil, true --self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a circle of radius %d at your feet; the circle slows incoming projectiles by %d%% and attempts to push all creatures other than yourself out of its radius, inflicting %0.2f light damage and %0.2f darkness damage per turn as it does so.  The circle lasts %d turns.
		The effects will increase with your Spellpower.]]):
		tformat(radius, damage*5, (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

newTalent{
	name = "Celestial Surge",
	type = {"celestial/circles", 4},
	require = divi_req_high4,
	points = 5,
	cooldown = 20,
	positive = 15,
	negative = 15,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 75) end,
	getSlow = function(self, t) return 50 end,
	getDuration = function(self, t) return self:combatTalentLimit(t, 15, 3.5, 10) end,
	getSlowDur = function(self, t) return self:combatTalentLimit(t, 7, 2, 5) end,
	on_pre_use = function(self, t, silent)
		if not game.level then return end
		for i, e in ipairs(game.level.map.effects) do
			if e.src and e.src == self and (e.damtype == DamageType.SHIFTINGSHADOWS or e.damtype == DamageType.SANCTITY or e.damtype == DamageType.WARDING or e.damtype == DamageType.BLAZINGLIGHT) then return true end
		end
		return false
	end,
	action = function(self, t)
		local dur = t.getDuration(self, t)
		self:setEffect(self.EFF_SURGING_CIRCLES, dur, {})
		local dam = self:spellCrit(t.getDamage(self, t))
		for i, e in ipairs(game.level.map.effects) do
			if e.x and e.y and game.level.map(e.x, e.y, Map.ACTOR) and e.src == self then
				if e.damtype == DamageType.SHIFTINGSHADOWS or e.damtype == DamageType.SANCTITY or e.damtype == DamageType.WARDING or e.damtype == DamageType.BLAZINGLIGHT then
					local tg = {type="ball", radius=e.radius, talent=t, friendlyfire=false}
					local power = t.getSlow(self, t) / 100
					e.src:project(tg, e.x, e.y, DamageType.LIGHT, dam)
					e.src:project(tg, e.x, e.y, DamageType.DARKNESS, dam)
					e.src:project(tg, e.x, e.y, DamageType.SLOW, {dam=power, dur=t.getSlowDur(self, t)})
				end
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[Conjure a surge of celestial power through your circles. Any foe standing within one of your circles will be slowed by %d%% for %d turns and take %d light and %d darkness damage.
		Residual power from the surge will emanate from your circles for %d turns; each circle you stand in will increase your celestial resources.
		Shifting Shadows: +1 negative.
		Sanctity: +1 postive.
		Warding: +0.5 postive and negative.]]):tformat(t.getSlow(self, t), t.getSlowDur(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
