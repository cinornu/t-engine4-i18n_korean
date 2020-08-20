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

--- get a list of diseases on a target
local getTargetDiseases = function(self, target)
	if not target then return end
	local diseases = self.turn_procs.target_diseases and self.turn_procs.target_diseases[target.uid]
	if diseases then return diseases end

	local num, dur = 0, 0
	diseases = {}
	for eff_id, p in pairs(target.tmp) do
		local e = target.tempeffect_def[eff_id]
		if e.subtype.disease then
			num, dur = num + 1, dur + p.dur
			diseases[#diseases+1] = {id=eff_id, params=p}
		end
	end
	diseases.num, diseases.dur = num, dur
	self.turn_procs.target_diseases = self.turn_procs.target_diseases or {}
	self.turn_procs.target_diseases[target.uid] = diseases
	return diseases
end

newTalent{
	name = "Blood Spray",
	type = {"corruption/blood", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 7,
	vim = 24,
	tactical = { ATTACKAREA = {BLIGHT = {1, disease = 1}}, DISABLE = {disease = 1} },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 30, 70) end, -- Limit < 100%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.CORRUPTED_BLOOD, {
			dam = self:spellCrit(self:combatTalentSpellDamage(t, 10, 190)),
			disease_chance = t.getChance(self, t),
			disease_dam = self:spellCrit(self:combatTalentSpellDamage(t, 10, 220)) / 6,
			disease_power = self:combatTalentSpellDamage(t, 10, 20),
			dur = 6,
		})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_blood", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[You extract corrupted blood from your own body, hitting everything in a frontal cone of radius %d for %0.2f blight damage.
		Each creature hit has a %d%% chance of being infected by a random disease, doing %0.2f blight damage and weakening either Constitution, Strength or Dexterity for 6 turns.
		The damage will increase with your Spellpower.]]):
		tformat(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 190)), t.getChance(self, t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 220)))
	end,
}

newTalent{
	name = "Blood Grasp",
	type = {"corruption/blood", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 5,
	vim = 20,
	range = 10,
	proj_speed = 20,
	tactical = { ATTACK = {BLIGHT = 1.75}, HEAL = {BLIGHT = 1}}, -- damage to foe heals self
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 190) end,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), selffire=false, friendlyfire=false, talent=t, display={particle="bolt_blood"}}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local damage = self:spellCrit(t.getDamage(self, t))
		self:projectile(tg, x, y, DamageType.SANGUINE, {dam=damage}, {type="blood"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Project a bolt of corrupted blood, doing %0.2f blight damage and healing you for 20%% the damage dealt.
			50%% of the damage dealt will be gained as maximum life for 7 turns (before the healing).
		The damage will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Blood Boil",
	type = {"corruption/blood", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 8,
	vim = 30,
	getTargetDiseases = getTargetDiseases,
	tactical = { DISABLE = function(self, t, target)
			local diseases = t.getTargetDiseases(self, target)
			if diseases and diseases.num > 0 then return 3 end
		end,
		ATTACKAREA = function(self, t, target)
			local diseases = t.getTargetDiseases(self, target)
			if diseases and diseases.num > 0 then return {BLIGHT=1}	end
		end,},
	range = 0,
	radius = function(self, t) return 10 end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 250) end,
	getSlow = function(self, t) return self:combatTalentLimit(t, 100, 20, 70) end,
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 10, 90) end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self.x, self.y
		local damage = self:spellCrit(t.getDamage(self, t))
		local slow = t.getSlow(self, t) / 100
		local heal = t.getHeal(self, t)
		local amount = 0
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local eff = target:removeEffectsFilter(self, function(e) return e.subtype.poison or e.subtype.disease or e.subtype.wound end, 1)
			if eff and eff > 0 then
				local dealt = DamageType:get(DamageType.BLIGHT).projector(self, target.x, target.y, DamageType.BLIGHT, damage)
				target:setEffect(target.EFF_SLOW, 5, {src=self, power=slow})
				amount = amount + 1
			end
		end)
		if amount > 0 then self:heal(heal * amount, self) end
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "circle", {oversize=1, a=180, appear=8, limit_life=8, speed=-3, img="blood_circle", radius=tg.radius})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Make the impure blood of all creatures around you in radius %d boil.
				Each enemy afflicted by a disease, poison, or wound will have one removed at random dealing %0.2f blight damage, healing you for %d, and slowing them by %d%% for 5 turns.
			The damage will increase with your Spellpower.]]):tformat(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)), t.getHeal(self, t), t.getSlow(self, t))
	end,
}

newTalent{
	name = "Blood Fury",
	type = {"corruption/blood", 4},
	mode = "sustained",
	require = corrs_req4,
	points = 5,
	sustain_vim = 30,
	cooldown = 30,
	tactical = { BUFF = 2 },
	on_crit = function(self, t)
		self:setEffect(self.EFF_BLOOD_FURY, 5, {power=self:combatTalentSpellDamage(t, 10, 30)})
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {
			per = self:addTemporaryValue("combat_spellcrit", self:combatTalentSpellDamage(t, 10, 14)),
		}
		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="blood_fury_sustain_shieldwall"}, shader={type="rotatingshield", noup=2.0, appearTime=0.4}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="blood_fury_sustain_shieldwall"}, shader={type="rotatingshield", noup=1.0, appearTime=0.4}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_spellcrit", p.per)
		return true
	end,
	info = function(self, t)
		return ([[Concentrate on the corruption you bring, increasing your spell critical chance by %d%%.
		Each time your spells go critical, you enter a blood rage for 5 turns, increasing your blight and acid damage by %d%%.
		The critical chance and damage increase will improve with your Spellpower.]]):
		tformat(self:combatTalentSpellDamage(t, 10, 14), self:combatTalentSpellDamage(t, 10, 30))
	end,
}
