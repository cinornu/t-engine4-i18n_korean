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
	name = "Self-Harm", short_name = "SELF_HARM",
	type = {"cursed/self-hatred", 1},
	require = cursed_wil_req1,
	points = 5,
	no_energy = true,
	hate = -8,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 14, 6)) end,
	getDamage = function(self, t)
		return self.max_life / math.ceil(self:combatTalentLimit(t, 50, 10, 20))
	end,
	getHate = function(self, t) return 2 end,
	
	on_pre_use = function(self, t, silent)
		if self.in_combat then
			return true
		end
		if not silent then game.logPlayer(self, "You can only use this while in combat") end
		return false
	end,
	action = function(self, t)
		local damage = t.getDamage(self, t)
		self:setEffect(self.EFF_SELF_JUDGEMENT, 5, {src=self, power=damage/5, no_ct_effect=true, unresistable=true}, true)
		game:playSoundNear(self, "talents/fallen_chop")
			return true
	end,
	callbackOnActBase = function(self, t)
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.bleed and e.status == "detrimental" then
				hateGain = t.getHate(self, t)
				self:incHate(hateGain)
				break
			end
		end
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local regen = t.getHate(self, t)
		return ([[At the start of each turn, if you're bleeding, you gain %d hate.

You can activate this talent to quickly draw a blade across your skin, bleeding yourself for a small portion of your maximum life (%0.2f damage) over the next 5 turns.	This bleed cannot be resisted or removed, but can be reduced by Bloodstained.

#{italic}#Pain is just about the only thing you can still feel.#{normal}#]]):tformat(regen, damage)
	end,
}

newTalent{
	name = "Self-Loathing", short_name = "SELF_LOATHING",
	type = {"cursed/self-hatred", 2},
	require = cursed_wil_req2,
	points = 5,
	mode = "passive",
	critChance = function(self, t) return self:combatTalentScale(t, 3, 10, 0.75) end,
	critPower = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	passives = function(self, t, p)
		local power = t.critPower(self, t) * getHateMultiplier(self, 0.2, 2.0, false)
		self:talentTemporaryValue(p, "combat_generic_crit", t.critChance(self, t))
		self:talentTemporaryValue(p, "combat_critical_power", power)
	end,
	callbackOnAct = function(self, t)
		self:updateTalentPassives(t.id)
	end,
	info = function(self, t)
		return ([[Increases critical chance by %d%% (at all times) and critical strike power by up to %d%% (based on hate).

#{italic}#Anger makes you strong.	 And you're always angry.#{normal}#]]):tformat(t.critChance(self, t), t.critPower(self, t)*2)
	end,
}

newTalent{
	name = "Self-Destruction", short_name = "SELF_DESTRUCTION",
	type = {"cursed/self-hatred", 3},
	require = cursed_wil_req3,
	points = 5,
	no_energy = true,
	cooldown = 40,
	drain_hate = 2,
	mode = "sustained",
	getPrice = function(self, t) return self:combatTalentLimit(t, 5, 15, 7.5) end,
	surge = function(self, t)
		-- Clear status
		local effs = {}
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.type ~= "other" then
				local e2 = self.tmp[eff_id]
				e2.dur = e2.dur - 1
				if e2.dur <= 0 then self:removeEffect(eff_id) end
			end
		end
		
		-- Reduce cooldowns
		for tid, _ in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t and (not t.fixed_cooldown or tid == T_BLOOD_RAGE) then
				self.talents_cd[tid] = self.talents_cd[tid] - 1
			end
		end
	end,		
	activate = function(self, t)
		t.surge(self, t)
		local ret = {}
		game:playSoundNear(self, "talents/fire")
		ret.particle = self:addParticles(Particles.new("blood_inferno", 1))
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	callbackOnRest = function(self, t, mode)
		if mode == "start" then
			self:forceUseTalent(self.T_SELF_DESTRUCTION, {ignore_energy=true, no_talent_fail=true})
			return true
		end
	end,
	callbackOnActBase = function(self, t)
		-- Pay life
		local price = t.getPrice(self, t)
    game:delayedLogDamage(self, self, 0, ("#CRIMSON#%d#LAST#"):tformat(self.max_life * price / 100), false)
		self:takeHit(self.max_life * price / 100, self, {special_death_msg="tore themself apart"})
		t.surge(self, t)
	end,
	
	info = function(self, t)
		local price = t.getPrice(self, t)
		return ([[Call upon your deepest reserves of strength to win no matter the cost.	
Immediately upon activation and every turn while this talent is active, your detrimental effects expire and your talents cool down as if an extra turn had passed.	
This bonus cooldown occurs even if your talents would not normally cool down.
This talent deactivates automatically upon rest.
This strength comes at a cost: you lose %d%% of your maximum life every turn.  This can kill you.

#{italic}#If you're lucky, this will take everything you've got.#{normal}#]]):tformat(price)
	end,
}

newTalent{
	name = "Self-Judgement", short_name = "SELF_JUDGEMENT",
	type = {"cursed/self-hatred", 4},
	require = cursed_wil_req4,
	points = 5,
	mode = "passive",
	getTime = function(self, t) return self:combatTalentScale(t, 3, 5) end,
	getThreshold = function(self, t) return self:combatTalentLimit(t, 10, 30, 15) end,
	getSpillThreshold = function(self, t) return 15 end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if dam < 0 then return {dam = dam} end
		if not state then return {dam = dam} end
		if self:attr("invulnerable") then return {dam = dam} end
		
		local psrc = src.__project_source
		if psrc then
			local kind = util.getval(psrc.getEntityKind)
			if kind == "projectile" or kind == "trap" or kind == "object" then
				-- continue
			else
				return
			end
		end
		
		local lt = t.getThreshold(self, t)/100
		local st = t.getSpillThreshold(self, t)/100
		if dam > self.max_life*lt then
			local reduce = dam - self.max_life*lt
			if reduce > self.max_life * st then
				reduce = math.floor(dam * st / (lt+st))
			end
			local length = t.getTime(self, t)
			if src.logCombat then src:logCombat(self, "#CRIMSON##Target# suffers from %s from #Source#, mitigating the blow!#LAST#.", is_attk and "an attack" or "damage") end
			dam = dam - reduce
			
			self:setEffect(self.EFF_SELF_JUDGEMENT, length, {power=reduce/length})
			
			local d_color = DamageType:get(type).text_color or "#CRIMSON#"
			game:delayedLogDamage(src, self, 0, ("%s(%d bled out#LAST#%s)#LAST#"):tformat(d_color, reduce, d_color), false)
			return {dam = dam}
		end
	end,
	info = function(self, t)
		local time = t.getTime(self, t)
		local threshold = t.getThreshold(self, t)
		local failThreshold = t.getThreshold(self, t) + t.getSpillThreshold(self, t)
		return ([[Any direct damage that exceeds %d%% of your maximum life has the excess damage converted to a shallow wound that bleeds over the next %d turns.	 This bleed cannot be resisted or removed, but can be reduced by Bloodstained. Extremely powerful hits (more than %d%% of your max life) are not fully converted.

#{italic}#You can't just die.	 That would be too easy.	You deserve to die slowly.#{normal}#]]):tformat(threshold, time, failThreshold)
	end,
}
