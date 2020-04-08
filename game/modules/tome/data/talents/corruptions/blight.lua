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
	name = "Dark Ritual",
	type = {"corruption/blight", 1},
	mode = "sustained",
	require = corrs_req1,
	points = 5,
	tactical = { ATTACK = 2 },
	sustain_vim = 20,
	cooldown = 30,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {
			per = self:addTemporaryValue("combat_critical_power", self:combatTalentSpellDamage(t, 20, 50)),
		}
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then self:talentParticles(ret, {type="circle", args={toback=true, shader=true, oversize=0.7, a=225, appear=8, speed=0, img="dark_ritual_aura", base_rot=0, radius=0, x=h1x, y=h1y}}) end
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_critical_power", p.per)
		return true
	end,
	info = function(self, t)
		return ([[Increases your spell critical damage multiplier by %d%%.
		The multiplier will increase with your Spellpower.]]):
		tformat(self:combatTalentSpellDamage(t, 20, 50))
	end,
}

newTalent{
	name = "Corrupted Negation",
	type = {"corruption/blight", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 20,
	vim = 30,
	range = 10,
	radius = 3,
	tactical = { ATTACKAREA = {BLIGHT = 1}, DISABLE = 2 },
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, talent=t}
	end,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,  -- Oh for the love of god no, fix me
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 28, 120))
		local nb = t.getRemoveCount(self,t)
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end


			local effs = {}

			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" or e.type == "physical" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					effs[#effs+1] = {"talent", tid}
				end
			end

			for i = 1, nb do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if self:checkHit(self:combatSpellpower(), target:combatSpellResist(), 0, 95, 5) then
					target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
					if eff[1] == "effect" then
						target:removeEffect(eff[2])
					else
						target:forceUseTalent(eff[2], {ignore_energy=true})
					end
				end
			end

			DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, dam)

		end)
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {zdepth=6, oversize=1, a=130, appear=8, limit_life=8, speed=5, img="green_demon_fire_circle", radius=tg.radius})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Project a corrupted blast of power that removes up to %d magical or physical effects or any type of sustain and deals %0.2f blight damage to any creatures caught in the radius 3 ball.
		For each effect, the creature has a chance to resist based on its spell save.
		The damage will increase with your Spellpower.]]):tformat(t.getRemoveCount(self, t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 120)))
	end,
}

newTalent{
	name = "Corrosive Worm",
	type = {"corruption/blight", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 12,
	vim = 12,
	range = 10,
	getResist = function(self, t) return math.ceil(self:combatTalentScale(t, 3, 20)) end,
	getPercent = function(self, t) return self:combatTalentSpellDamage(t, 12, 45) end, -- Scaling?
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 60) end,
	tactical = { ATTACK = {ACID = 2}, DISABLE = 1 },
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CORROSIVE_WORM, 6, {src = self, apply_power=self:combatSpellpower(), finaldam=t.getDamage(self, t), rate=t.getPercent(self, t) *0.01, power=t.getResist(self,t)})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Infects the target with a corrosive worm for 6 turns that reduces blight and acid resistance by %d%% and feeds off damage taken.
		When this effect ends or the target dies the worm will explode, dealing %d acid damage in a 4 radius ball. This damage will increase by %d%% of all damage taken while infected.
		The damage dealt by the effect will increase with spellpower.]]):
		tformat(t.getResist(self,t), t.getDamage(self, t), t.getPercent(self, t))
	end,
}

newTalent{
	name = "Poison Storm",
	type = {"corruption/blight", 4},
	require = corrs_req4,
	points = 5,
	vim = 28,
	cooldown = 24,
	range = 0,
	radius = 4,
	tactical = { ATTACKAREA = {BLIGHT = 3}, DISABLE = 2 },
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 12, 130) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	getEffects = function(self, t)
		local power = self:combatTalentScale(t, 15, 40)
		local heal_factor = 150*power/(power + 50) -- Limit < 150%
		local fail = 50*power/(power + 26) -- Limit < 50% chance
		return power, heal_factor, fail
	end,
	getPoison = function(self,t) 
		if self:getTalentLevel(t) >= 6 then return 4
		elseif self:getTalentLevel(t) >= 4 then return 3
		elseif self:getTalentLevel(t) >= 2 then return 2
		else return 1 end
	end,
	action = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local dam = self:spellCrit(t.getDamage(self,t))
		local poison = t.getPoison(self,t)
		local power, heal_factor, fail = t.getEffects(self, t)
		local actor = self
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.BLIGHT_POISON, {dam=dam, power=power, heal_factor=heal_factor, fail=fail, penetration=0, poison=t.getPoison(self,t), apply_power=actor:combatSpellpower()},
			radius,
			5, nil,
			MapEffect.new{
				color_br=20, color_bg=220, color_bb=70, effect_shader="shader_images/poison_effect.png",
				overlay_particle = { zdepth=6, only_one=true, type="perfect_strike", args={img="spinningwinds_poison_storm", radius=radius}},
			},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self,t))
		local power, heal_factor, fail = t.getEffects(self, t)
		return ([[A furious storm of blighted poison rages around the caster in a radius of %d for %d turns.  Each creature hit by the storm takes %0.2f blight damage and is poisoned for %0.2f blight damage over 4 turns.
		At talent level 2 you have a chance to inflict Insidious Blight, which reduces healing by %d%%.
		At talent level 4 you have a chance to inflict Numbing Blight, which reduces all damage dealt by %d%%.
		At talent level 6 you have a chance to inflict Crippling Blight, which causes talents to have a %d%% chance of failure.
		Each possible effect is equally likely.
		The poison damage dealt is capable of a critical strike.
		The damage will increase with your Spellpower.]]):
		tformat(self:getTalentRadius(t), t.getDuration(self, t), dam/4, dam, heal_factor, power, fail)
	end,
}