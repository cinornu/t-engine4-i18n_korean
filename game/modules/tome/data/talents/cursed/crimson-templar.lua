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
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.	 If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newTalent{
	name = "Shared Agony",
	type = {"cursed/crimson-templar", 1},
	require = cursed_mag_req_high1,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	range = 5,
	tactical = { BUFF = 2, DEFEND = 2 },
	getShrug = function(self, t) return self:combatTalentLimit(t, 50, 10, 25) end,
	getAmp = function(self, t) return self:combatTalentLimit(t, 300, 130, 200) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if dam > 0 and src ~= self and not state.no_reflect then
			
			-- find available targets
			local tgts = {}
			local grids = core.fov.circle_grids(self.x, self.y, 5, true)
			for x, yy in pairs(grids) do
				for y, _ in pairs(grids[x]) do
					local a = game.level.map(x, y, Map.ACTOR)
					if a and self:reactionToward(a) < 0 then
						for eff_id, p in pairs(a.tmp) do
							local e = a.tempeffect_def[eff_id]
							if e.subtype.bleed and e.status == "detrimental" then
								tgts[#tgts+1] = a
								break
							end
						end
					end
				end
			end
			
			-- Displace the damage
			local a = rng.table(tgts)
			if a then
				local displace = dam * t.getShrug(self, t) / 100
				dam = dam - displace
				displace = displace * t.getAmp(self, t) / 100
				state.no_reflect = true
				DamageType.defaultProjector(self, a.x, a.y, type, displace, state)
				state.no_reflect = nil
				
				game:delayedLogDamage(src, self, 0, ("%s(%d shared agony)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", displace), false)

				local hx, hy = self:attachementSpot("back", true)
				local ps = Particles.new("blood_trail", 1, {range=core.fov.distance(self.x, self.y, a.x, a.y), dir=math.deg(math.atan2(a.y-self.y, a.x-self.x)+math.pi/2), img="blood_trail_segment_thin", dx=hx, dy=hy, grab=false})
				self:addParticles(ps)
			end
		end
		
		return {dam=dam}
	end,
	info = function(self, t)
		local shrug = t.getShrug(self, t)
		local amp = t.getAmp(self, t)
		return ([[You displace %d%% of any damage you receive onto a random bleeding enemy within range 5. This redirected damage is amplified by %d%%.

#{italic}#All living things are linked by blood. It is one river, flowing through all.#{normal}#]]):tformat(shrug, amp)
	 end,
}

newTalent{
	name = "Splatter Sigils",
	type = {"cursed/crimson-templar", 2},
	require = cursed_mag_req_high2,
	points = 5,
	cooldown = 20,
	tactical = { DEFEND = 1, DISABLE = {SLOW = 1} },
	range = 0,
	getPrice = function(self, t) return 5 end,
	getStrength = function(self, t) return self:combatTalentSpellDamage(t, 4, 30) end,
	getDuration = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 4, 8))) end,
	radius = function(self, t) return math.min(5, math.floor(self:combatTalentScale(t, 1.5, 3))) end,
	target = function(self, t) -- for AI only
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	
	makeSigil = function(self, t, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
														 x, y, self:spellCrit(t.getDuration(self, t)),
														 DamageType.SOLAR_BLOOD, {dam=self:spellCrit(t.getStrength(self, t)), pow=self:combatSpellpower()},
														 self:getTalentRadius(t),
														 5, nil,
														 MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, oversize=0, img="sun_sigil_dark", radius=self:getTalentRadius(t)*2}}, color_br=255, color_bg=187, color_bb=187, alpha=10, effect_shader="shader_images/sunlight_effect.png"},
														 nil, true
														)
	end,
	
	action = function(self, t)
		self:takeHit(self.max_life * t.getPrice(self, t) / 100, self, {special_death_msg=_t"sacrificed themself"})
		t.makeSigil(self, t, self.x, self.y)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	
	callbackOnKill = function(self, t, src, death_note)
		t.makeSigil(self, t, src.x, src.y)
	end,
	
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local burn = t.getStrength(self, t)
		local cost = t.getPrice(self, t)
		local dur = t.getDuration(self, t)
		return ([[When you kill an enemy, their death forms a cursed magical pattern on the ground. This creates a circle of radius %d which blinds enemies and deals them %0.2f light damage, while giving you %d positive energy per turn. The circle lasts for %d turns.
							The damage will increase with your Spellpower.
							The duration of the circle can be increased by a critical hit.
							The blind chance increases with your Spellpower.
							You can activate this talent to draw the pattern in your own blood, creating it underneath you at the cost of %d%% of your maximum life.
]]):tformat(rad, damDesc(self, DamageType.LIGHT, burn), 2, dur, cost)
	end,
}

newTalent{
	name = "Mark of the Vampire",
	type = {"cursed/crimson-templar", 3},
	require = cursed_mag_req_high3,
	points = 5,
	cooldown = 20,
	positive = 15,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 1, ATTACK = {PHYSICAL = 2} },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, friendlyfire=false}
	end,
	getPower = function(self, t) return self:combatTalentSpellDamage(t, 5, 100) end,
	getBleedIncrease = function(self, t) return self:combatTalentScale(t, 0.15, 0.5) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		dam = self:spellCrit(t.getPower(self, t))
		self:project(tg, x, y, function(tx, ty)
									 local target = game.level.map(tx, ty, Map.ACTOR)
									 if not target or target == self then return end
									 target:setEffect(target.EFF_MARK_OF_THE_VAMPIRE, 20, {src=self, dam=dam, power=t.getBleedIncrease(self, t), apply_power=self:combatSpellpower()})
													 end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, g=90, b=100, a=100, limit_life=8, appear=8, speed=2, img="vampire_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Dooms all enemies within a radius 2 ball for 20 turns. Each time an affected target uses a talent, it takes %0.2f physical damage as its life is drawn out. In addition, any bleed applied to the target will have its power increased by %d%%.
							The damage will increase with your Spellpower.
							The chance to apply will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getPower(self, t)), t.getBleedIncrease(self, t)*100)
	end,
}

newTalent{
	name = "Rosebloom",
	type = {"cursed/crimson-templar", 4},
	require = cursed_mag_req_high4,
	points = 5,
	range = 0,
	radius = 10,
	cooldown = 24,
	positive = 10,
	hate = 10,
	direct_hit = true,
	getExtension = function(self, t) return math.floor(self:combatTalentScale(t, 0, 4)) end,
	getConversion = function(self, t) return 0.20 end,
	getInsomniaPower= function(self, t)
		local t = self:getTalentFromId(self.T_SANDMAN)
		local reduction = t.getInsomniaPower(self, t)
		return 20 - reduction
	end,
	getMinHeal = function(self, t) return self:combatTalentScale(t, 10, 25) end,
	getSleepMultiplier = function(self, t)
		if self:knowTalent(self.T_SANDMAN) then
			local sandman = self:getTalentFromId(self.T_SANDMAN)
			return sandman.getSleepPowerBonus(self, sandman)
		end
		return 1
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,		
	action = function(self, t)
		--Restless night compatibility for adventurers
		local is_waking =0
		if self:knowTalent(self.T_RESTLESS_NIGHT) then
			local t = self:getTalentFromId(self.T_RESTLESS_NIGHT)
			is_waking = t.getDamage(self, t)
		end
		
		-- Store up bleed damage
		local drain = 0
		local conversion = t.getConversion(self, t)
		local healMin = t.getMinHeal(self, t)
		
		local sleepMultiplier = t.getSleepMultiplier(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(tx, ty)
									 local target = game.level.map(tx, ty, Map.ACTOR)
									 if target then
										 
										 local bleeding = false
										 local dur = 1
										 local sleepPower = 0
										 for eff_id, p in pairs(target.tmp) do
											 local e = target.tempeffect_def[eff_id]
											 if e.subtype.bleed and e.status == "detrimental" then
												 bleeding = true
												 local eff = target.tmp[eff_id]
												 drain = drain + math.max(eff.power*eff.dur*conversion, healMin)
												 dur = math.max(dur, eff.dur)
												 sleepPower = sleepPower + eff.power
											 end
										 end
										 
										 if bleeding and target:canBe("sleep") then
											 local hx, hy = self:attachementSpot("back", true)
											 local ps = Particles.new("blood_trail", 1, {range=core.fov.distance(self.x, self.y, target.x, target.y), dir=math.deg(math.atan2(target.y-self.y, target.x-self.x)+math.pi/2), img="blood_trail_segment_thick", grab=true, dx=hx, dy=hy})
											 self:addParticles(ps)
											 target:setEffect(target.EFF_SLEEP, dur+t.getExtension(self, t), {src=self, power = math.ceil(sleepPower * sleepMultiplier * 1.5), contagious=0, waking=is_waking, insomnia=t.getInsomniaPower(self, t), no_ct_effect=true, apply_power=self:combatSpellpower()})
										 else
											 game.logSeen(self, "%s resists the sleep!", target.name:capitalize())
										 end
									 end
																		 end)
		
		-- Heal to heal
		self:attr("allow_on_heal", 1)
		self:heal(drain, self) -- don't crit, would double dip
		self:attr("allow_on_heal", -1)
		
		game:playSoundNear(self, "talents/dispel")
		return true
	end,
	
	info = function(self, t)
		local conversion = t.getConversion(self, t)*100
		local minimum = t.getMinHeal(self, t)
		local extension = t.getExtension(self, t)
		return ([[Draw on the wounds of enemies within range 10, healing yourself and putting them into a merciful sleep.
							The sleep chance increases with your Spellpower.
							You are healed for %d%% of the remaining damage of bleed effects on enemies in range (minimum %d per bleed). Enemies fall asleep for %d turns longer than their longest-lasting bleed, rendering them unable to act. The strength of the sleep effect is based on the strength of the bleed. Excess damage will reduce their sleep duration.
							
							When the sleep ends, each target will benefit from Insomnia for a number of turns equal to the amount of time it was asleep (up to ten turns max), granting it 50%% sleep immunity.]]):tformat(conversion, minimum, extension)
	end,
}
