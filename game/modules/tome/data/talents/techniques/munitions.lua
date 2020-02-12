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

local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"

archery_range = Talents.main_env.archery_range

local function cancelAmmo(self)
	local ammo = {self.T_INCENDIARY_AMMUNITION, self.T_VENOMOUS_AMMUNITION, self.T_PIERCING_AMMUNITION}
	for i, t in ipairs(ammo) do
		if self:isTalentActive(t) then
			self:forceUseTalent(t, {ignore_energy=true})
		end
	end
end

newTalent{
	name = "Exotic Munitions",
	type = {"technique/munitions", 1},
	require = techs_dex_req_high1,
	points = 5,
	mode = "passive",
	getIncendiaryDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.1, 0.4) end,
	getIncendiaryRadius = function(self, t) if self:getTalentLevel(t)>=3 then return 2 else return 1 end end,
	getPoisonDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 20, 180) end,
	getNumb = function(self, t) return 5 + self:combatTalentLimit(t, 25, 5, 15) end,
	getArmorSaveReduction = function(self, t) return self:combatTalentLimit(t, 30, 5, 25, 0.75) end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 35, 10, 25, true) end,
	on_learn = function(self, t)
		local lev = self:getTalentLevelRaw(t)
		if lev == 1 then
			self:learnTalent(self.T_INCENDIARY_AMMUNITION, true, nil, {no_unlearn=true})
			self:learnTalent(self.T_VENOMOUS_AMMUNITION, true, nil, {no_unlearn=true})
			self:learnTalent(self.T_PIERCING_AMMUNITION, true, nil, {no_unlearn=true})
		end
	end,
	on_unlearn = function(self, t)
		local lev = self:getTalentLevelRaw(t)
		if lev == 0 then
			self:unlearnTalent(self.T_INCENDIARY_AMMUNITION)
			self:unlearnTalent(self.T_VENOMOUS_AMMUNITION)
			self:unlearnTalent(self.T_PIERCING_AMMUNITION)
		end
	end,
	info = function(self, t)
		return ([[You have learned to create and equip specialist ammunition:
Incendiary - Shots deal an additional %d%% weapon damage as fire in a radius %d ball. This cannot occur more than once per turn.
Venomous - Shots deal %0.2f nature damage and inflict numbing poison, dealing a further %0.2f nature damage over 5 turns and reducing all damage dealt by %d%%.
Piercing - Shots reduce armor and saves by %d for 3 turns, and your physical penetration is increased by %d%%.
You can only have 1 type of ammunition loaded at a time.
The poison damage dealt, armor penetration and save reduction will increase with your Physical Power.]]):
		tformat(t.getIncendiaryDamage(self, t)*100, t.getIncendiaryRadius(self,t), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)/5), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)), t.getNumb(self, t), t.getArmorSaveReduction(self, t), t.getResistPenalty(self,t))
	end,
}

newTalent{
	name = "Incendiary Ammunition",
	type = {"technique/other", 1},
	mode = "sustained",
	no_energy = true,
	sustain_stamina = 12,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	getIncendiaryDamage = function(self, t) return self:callTalent(self.T_EXOTIC_MUNITIONS, "getIncendiaryDamage") end,
	radius = function(self, t)
		if self:knowTalent(self.T_ENHANCED_MUNITIONS) and not self:isTalentCoolingDown(self.T_ENHANCED_MUNITIONS) then
			return self:callTalent(self.T_EXOTIC_MUNITIONS, "getIncendiaryRadius") + 1 
		else
			return self:callTalent(self.T_EXOTIC_MUNITIONS, "getIncendiaryRadius") 
		end
	end,
	target = function(self, t)
		return {type="ball", range=100, radius=self:getTalentRadius(t), talent=t, friendlyfire=false}
	end,
	activate = function(self, t)
		cancelAmmo(self)
		local ret = {}
		if self:knowTalent(self.T_ALLOYED_MUNITIONS) then
			local t2 = self:getTalentFromId(self.T_ALLOYED_MUNITIONS)
			self:talentTemporaryValue(ret, "resists_pen", {[DamageType.PHYSICAL] = t2.getResistPenalty(self, t2), [DamageType.FIRE] = t2.getResistPenalty(self, t2)})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted)
		if hitted and not self.turn_procs.explosive_ammunition then
			self.turn_procs.explosive_ammunition = true
			local tg = self:getTalentTarget(t)
			
			if self:knowTalent(self.T_ENHANCED_MUNITIONS) then
				local t2 = self:getTalentFromId(self.T_ENHANCED_MUNITIONS)
				if not self:isTalentCoolingDown(t2) then 
					game.level.map:addEffect(self,
						target.x, target.y, 3,
						engine.DamageType.FIRE, t2.getFireDamage(self,t2),
						self:getTalentRadius(t),
						5, nil,
						{type="inferno"},
						nil, false
					)
				self:startTalentCooldown(t2)
				end
			end
			
			local sw = self:getInven("QUIVER")
			if sw then
				sw = sw[1] and sw[1].combat
			end
			sw = sw or self.combat
			local dam = self:combatDamage(sw)
			local dam = self:combatDamage(sw)
			local damrange = self:combatDamageRange(sw)
			dam = rng.range(dam, dam * damrange)
			dam = dam * t.getIncendiaryDamage(self,t)
			
			if self:knowTalent(self.T_ALLOYED_MUNITIONS) then
				local t2 = self:getTalentFromId(self.T_ALLOYED_MUNITIONS)
				self:project(tg, target.x, target.y, function(px, py)
					DamageType:get(DamageType.FIRE_SUNDER).projector(self, px, py, DamageType.FIRE_SUNDER, {src=self, dam=dam, dur=3, power=t2.getArmorSaveReduction(self,t)})
				end)
			else
				self:project(tg, target.x, target.y, function(px, py)
					DamageType:get(DamageType.FIRE).projector(self, px, py, DamageType.FIRE, dam)
				end)
			end


		end
	end,
	info = function(self, t)
		local damage = t.getIncendiaryDamage(self, t)*100
		local radius = self:getTalentRadius(t)
		return ([[Load incendiary ammunition, causing attacks to deal an additional %d%% weapon damage as fire in a radius %d ball around your target. 
		This cannot trigger more than once per turn.
		The damage will scale with your Physical Power.]]):tformat(damage, radius)
	end,
}

newTalent{
	name = "Venomous Ammunition",
	type = {"technique/other", 1},
	mode = "sustained",
	no_energy = true,
	sustain_stamina = 12,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	range = 10,
	getPoisonDamage = function(self, t) return self:callTalent(self.T_EXOTIC_MUNITIONS, "getPoisonDamage") end,
	getNumb = function(self, t) return self:callTalent(self.T_EXOTIC_MUNITIONS, "getNumb") end,
	activate = function(self, t)
		cancelAmmo(self)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted)
		if hitted then
			self:project({type="hit", range=100}, target.x, target.y, DamageType.NATURE, t.getPoisonDamage(self,t)/5)
			if self.turn_procs.venomous_ammunition or not self:knowTalent(self.T_ALLOYED_MUNITIONS) and target:canBe("poison") then
				target:setEffect(target.EFF_NUMBING_POISON, 5, {src=self, power=t.getPoisonDamage(self,t)/5, reduce=t.getNumb(self,t)})
			end
			if self:knowTalent(self.T_ENHANCED_MUNITIONS) then
				local t = self:getTalentFromId(self.T_ENHANCED_MUNITIONS)
				if not self:isTalentCoolingDown(t) and target:canBe("poison") then 
					target:setEffect(target.EFF_LEECHING_POISON, 3, {src=self, power=t.getPoisonDamage(self,t)/3, apply_power=self:combatAttack(), no_ct_effect=true})
					self:startTalentCooldown(t)
				end
			end
			if not self.turn_procs.venomous_ammunition and self:knowTalent(self.T_ALLOYED_MUNITIONS) then
				self.turn_procs.venomous_ammunition = true
				local t2 = self:getTalentFromId(self.T_ALLOYED_MUNITIONS)
				local tg = {type="ball", range=100, radius=1, talent=t, friendlyfire=false}
				
							
				local sw = self:getInven("QUIVER")
				if sw then
					sw = sw[1] and sw[1].combat
				end
				sw = sw or self.combat
				local dam = self:combatDamage(sw)
				local damrange = self:combatDamageRange(sw)
				dam = rng.range(dam, dam * damrange)
				dam = dam * t2.getPoisonDamage(self,t2)
				
				self:project(tg, target.x, target.y, function(px, py)
					local target = game.level.map(px, py, Map.ACTOR)
					DamageType:get(DamageType.NATURE).projector(self, px, py, DamageType.NATURE, dam)
					if target and target:canBe("poison") then target:setEffect(target.EFF_NUMBING_POISON, 5, {src=self, power=t.getPoisonDamage(self,t)/5, reduce=t.getNumb(self,t)}) end
				end)
			end
		end
	end,
	info = function(self, t)
		local damage = t.getPoisonDamage(self, t)
		local numb = t.getNumb(self,t)
		return ([[Load venomous ammunition, causing ranged attacks to deal %0.2f nature damage and inflict numbing poison, dealing %0.2f nature damage over 5 turns and reducing all damage dealt by %d%%. 
		The damage will scale with your Physical Power.]]):tformat(damDesc(self, DamageType.NATURE, damage/5), damDesc(self, DamageType.NATURE, damage), numb)
	end,
}

newTalent{
	name = "Piercing Ammunition",
	type = {"technique/other", 1},
	mode = "sustained",
	no_energy = true,
	sustain_stamina = 12,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	radius = 1,
	range = 10,
	getArmorSaveReduction = function(self, t) return self:callTalent(self.T_EXOTIC_MUNITIONS, "getArmorSaveReduction") end,
	getResistPenalty = function(self, t) return self:callTalent(self.T_EXOTIC_MUNITIONS, "getResistPenalty") end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, friendlyfire=false}
	end,
	activate = function(self, t)
		cancelAmmo(self)
		return {
			resist = self:addTemporaryValue("resists_pen", {[DamageType.PHYSICAL] = t.getResistPenalty(self, t)}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted)
		if hitted then
			target:setEffect(target.EFF_SUNDER_ARMOUR, 3, {src=self, power=t.getArmorSaveReduction(self,t)})
			if self:knowTalent(self.T_ENHANCED_MUNITIONS) then
				local t = self:getTalentFromId(self.T_ENHANCED_MUNITIONS)
				if not self:isTalentCoolingDown(t) then 
					target:setEffect(target.EFF_PUNCTURED_ARMOUR, 3, {src=self, power=t.getResistPenalty(self,t), apply_power=self:combatAttack(), no_ct_effect=true})
					self:startTalentCooldown(t)
				end
			end
			if self:knowTalent(self.T_ALLOYED_MUNITIONS) then
				local t2 = self:getTalentFromId(self.T_ALLOYED_MUNITIONS)
				self:project({type="hit", range=100}, target.x, target.y, DamageType.PHYSICAL, t2.getPhysicalDamage(self,t2)/5)
				target:setEffect(target.EFF_MAIM, 5, {src=self, power=t2.getPhysicalDamage(self,t2)/5, reduce=t2.getNumb(self,t2)})
			end
		end
	end,
	info = function(self, t)
		local reduce = t.getArmorSaveReduction(self, t)
		local resist = t.getResistPenalty(self,t)
		return ([[Load piercing ammunition, causing attacks to reduce the target's armor and saves by %d for 3 turns, and increasing your physical penetration by %d%%.
		The armor and save reduction will scale with your Physical Power.]]):tformat(reduce, resist)
	end,
}
	

newTalent{
	name = "Explosive Shot",
	type = {"technique/munitions", 2},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	stamina = 18,
	cooldown = 12,
	require = techs_dex_req_high2,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = 2 },
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_INCENDIARY_AMMUNITION) or self:isTalentActive(self.T_VENOMOUS_AMMUNITION) or self:isTalentActive(self.T_PIERCING_AMMUNITION) then
			return archerPreUse(self, t, silent) 
		else
			if not silent then game.logPlayer(self, "You require incendiary, venomous or piercing ammunition to use this talent!") end
		end
	end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 1.5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3.3, 5.5)) end,
	getSlow = function(self, t) return math.floor(self:combatTalentLimit(t, 40, 10, 25)) end,	
	getFireResist = function(self, t) return math.floor(self:combatTalentScale(t, 10, 40)) end,	
	getPoisonDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 15, 100) end,
	getPoisonFailure = function(self, t) return math.floor(self:combatTalentScale(t, 10, 35)) end,
	getRemoveCount = function(self, t) return self:combatTalentLimit(t, 4, 1, 2.5) end,
	archery_onreach = function(self, t, x, y)
		local tg = self:getTalentTarget(t)
		if self:isTalentActive(self.T_INCENDIARY_AMMUNITION) then
			self:project(tg, x, y, DamageType.PITCH, {dam=t.getSlow(self,t), dur=t.getDuration(self,t), fire=t.getFireResist(self,t)})
		end
		if self:isTalentActive(self.T_VENOMOUS_AMMUNITION) then
				game.level.map:addEffect(self,
					x, y, t.getDuration(self,t),
					engine.DamageType.CRIPPLING_POISON, {dam=t.getPoisonDamage(self,t), dur=1, fail=t.getPoisonFailure(self,t), apply_power=self:combatAttack()},
					self:getTalentRadius(t),
					5, nil,
					{type="vapour"},
					nil, false
				)
		end
		game.level.map:particleEmitter(x, y, tg.radius, "shrapnel_explosion", {radius=tg.radius})
	end,
	archery_onhit = function(self, t, target, x, y)
		if self:isTalentActive(self.T_PIERCING_AMMUNITION) then
			local effs = {}
	
			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if (e.type == "physical") and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
	
			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					local talent = target:getTalentFromId(tid)
					if 
						not talent.is_mind and not talent.is_spell
						then
							effs[#effs+1] = {"talent", tid}
					end
				end
			end
	
			for i = 1, t.getRemoveCount(self,t) do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)
	
				if eff[1] == "effect" then
					target:removeEffect(eff[2])
				else
					target:forceUseTalent(eff[2], {ignore_energy=true})
				end
			end
		end
	end,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local targets = nil
		if self:isTalentActive(self.T_PIERCING_AMMUNITION) then
			targets = self:archeryAcquireTargets(tg, {one_shot=true})
		else
			targets = self:archeryAcquireTargets(nil, {one_shot=true})
		end
		if not targets then return end
		local dam = t.getDamage(self,t)
		if self:isTalentActive(self.T_PIERCING_AMMUNITION) then
			self:archeryShoot(targets, t, tg, {mult=dam, damtype=DamageType.PHYSICAL})
		elseif self:isTalentActive(self.T_VENOMOUS_AMMUNITION) then
			self:archeryShoot(targets, t, nil, {mult=dam, damtype=DamageType.NATURE})
		elseif self:isTalentActive(self.T_INCENDIARY_AMMUNITION) then
			self:archeryShoot(targets, t, nil, {mult=dam, damtype=DamageType.FIRE})
		end
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local slow = t.getSlow(self,t)
		local fire = t.getFireResist(self,t)
		local poison = t.getPoisonDamage(self,t)
		local fail = t.getPoisonFailure(self,t)
		local nb = t.getRemoveCount(self,t)
		return ([[Fires a special shot based on your currently loaded ammo:
Incendiary - Fire a shot that deals %d%% weapon damage as fire and covers targets in radius %d in sticky pitch for %d turns, reducing global speed by %d%% and increasing fire damage taken by %d%%.
Venomous - Fire a shot that deals %d%% weapon damage as nature and explodes into a radius %d cloud of crippling poison for %d turns, dealing %0.2f nature damage each turn and giving affected targets a %d%% chance to fail talent usage.
Piercing - Fire a shot that explodes into a radius %d burst of shredding shrapnel, dealing %d%% weapon damage as physical and removing %d beneficial physical effects or sustains.
The poison damage dealt increases with your Physical Power, and status chance increases with your Accuracy.]]):
		tformat(dam, radius, dur, slow, fire, dam, radius, dur, damDesc(self, DamageType.NATURE, poison), fail, radius, dam, nb)
	end,
}

newTalent{
	name = "Enhanced Munitions",
	type = {"technique/munitions", 3},
	mode = "passive",
	points = 5,
	cooldown = 8,
	require = techs_dex_req_high3,
	fixed_cooldown = true,
	getFireDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 10, 100) end,
	getPoisonDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 20, 250) end,
	getResistPenalty = function(self, t) return math.floor(self:combatTalentLimit(t, 35, 10, 25)) end,
	info = function(self, t)
		local fire = t.getFireDamage(self,t)
		local poison = t.getPoisonDamage(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[You create enhanced versions of your ammunition, granting them additional effects.
Incendiary - The explosion radius is increased by 1, and the ground beneath is ignited dealing an additional %0.2f fire damage each turn for 3 turns.
Venomous - Inflicts leeching poison, dealing %0.2f nature damage over 3 turns and causing you to heal for 100%% of all damage the poison deals to the target.
Piercing - Punctures the target’s armor, increasing all damage they take by %d%% for 3 turns.
You only have a limited amount of this ammo, causing this talent to have a cooldown.
The damage dealt will increase with your Physical Power, and status chance increases with your Accuracy.]]):
		tformat(damDesc(self, DamageType.FIRE, fire), damDesc(self, DamageType.NATURE, poison), resist)
	end,
}

newTalent{
	name = "Alloyed Munitions",
	type = {"technique/munitions", 4},
	points = 5,
	mode = "passive",
	require = techs_dex_req_high4,
	getPoisonDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.1, 0.4) end,
	getPoisonRadius = function(self, t) if self:getTalentLevel(t)>=3 then return 2 else return 1 end end,
	getPhysicalDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 20, 180) end,
	getNumb = function(self, t) return 5 + self:combatTalentLimit(t, 25, 5, 15) end,
	getArmorSaveReduction = function(self, t) return self:combatTalentLimit(t, 30, 5, 25, 0.75) end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 35, 10, 25, true) end,
	info = function(self, t)
		local poison = t.getPoisonDamage(self,t)*100
		local radius = t.getPoisonRadius(self,t)
		local bleed = t.getPhysicalDamage(self,t)
		local numb = t.getNumb(self,t)
		local armor = t.getArmorSaveReduction(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[You mix together your munitions, leading to powerful new effects:
Incendiary - Targets struck by the explosion have their armor and saves reduced by %d for 3 turns, and your physical and fire penetration is increased by %d%%.
Venomous - Shots deal an additional %d%% weapon damage as nature in a radius %d ball, which applies numbing poison as per Exotic Munitions. This cannot occur more than once per turn.
Piercing - Shots deal %0.2f physical damage and maim the target, bleeding them for a further %0.2f physical damage over 5 turns and reducing all damage dealt by %d%%.
The physical damage dealt, armor penetration and save reduction will increase with your Physical Power.]]):
		tformat(armor, resist, poison, radius, bleed/5, bleed, numb)
	end,
}