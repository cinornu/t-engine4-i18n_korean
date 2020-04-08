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
	name = "Vitality",
	type = {"technique/conditioning", 1},
	require = techs_con_req1,
	mode = "passive",
	points = 5,
	cooldown = 15,
	getHealValues = function(self, t)
		return self:combatTalentStatDamage(t, "con", 1, 200)
	end,
	getWoundReduction = function(self, t) return self:combatTalentLimit(t, 0.6, 0.17, 0.5) end, -- Limit <60%%
	getDuration = function(self, t) return 8 end,
	do_vitality_recovery = function(self, t)
		if self:isTalentCoolingDown(t) then return end
		local baseheal = t.getHealValues(self, t)
		self:setEffect(self.EFF_RECOVERY, t.getDuration(self, t), {regen = baseheal})
		self:startTalentCooldown(t)
	end,
	info = function(self, t)
		local wounds = t.getWoundReduction(self, t) * 100
		local baseheal = t.getHealValues(self, t)
		local duration = t.getDuration(self, t)
		local totalheal = baseheal
		return ([[You recover faster from poisons, diseases and wounds, reducing the duration of all such effects by %d%%.  
			Whenever your life falls below 50%%, your life regeneration increases by %0.1f for %d turns (%d total). This effect can only happen once every %d turns.
		The regeneration scales with your Constitution.]]):
		tformat(wounds, baseheal, duration, baseheal*duration, self:getTalentCooldown(t))
	end,
}

newTalent{
	name = "Unflinching Resolve",
	type = {"technique/conditioning", 2},
	require = techs_con_req2,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return self:combatStatLimit("con", 1, .28, .745)*self:combatTalentLimit(t,100, 28,74.8) end, -- Limit < 100%
	callbackOnActBase = function(self, t)
		local effs = {}
		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" then
				if e.subtype.stun then 
					effs[#effs+1] = {"effect", eff_id, priority=1}
				elseif e.subtype.blind and self:getTalentLevel(t) >=2 then
					effs[#effs+1] = {"effect", eff_id, priority=2}
				elseif e.subtype.confusion and self:getTalentLevel(t) >=3 then
					effs[#effs+1] = {"effect", eff_id, priority=3}
				elseif e.subtype.pin and self:getTalentLevel(t) >=3 then
					effs[#effs+1] = {"effect", eff_id, priority=4}
				elseif e.subtype.disarm and self:getTalentLevel(t) >=4 then
					effs[#effs+1] = {"effect", eff_id, priority=5}
				elseif e.subtype.slow and self:getTalentLevel(t) >=4 then
					effs[#effs+1] = {"effect", eff_id, priority=6}
				end
			end
		end

		table.sort(effs, "priority")
		
		if #effs > 0 then
			local eff = effs[1]
			if eff[1] == "effect" and rng.percent(t.getChance(self, t)) then
				self:removeEffect(eff[2])
				game.logSeen(self, "#ORCHID#%s has recovered!#LAST#", self:getName():capitalize())
			end
		end
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[You've learned to recover quickly from effects that would disable you. Each turn, you have a %d%% chance to recover from a single stun effect.
		At talent level 2 you may also recover from Blindness, at level 3 Confusion and Pins, and level 4 Disarms and Slows.
		Effects will be cleansed with the priority order Stun > Blind > Confusion > Pin > Disarm > Slow.
		Only one effect may be recovered from each turn, and the chance to recover from an effect scales with your Constitution.]]):
		tformat(chance)
	end,
}

newTalent{
	name = "Daunting Presence",
	type = {"technique/conditioning", 3},
	require = techs_con_req3,
	points = 5,
	mode = "sustained",
	sustain_stamina = 20,
	cooldown = 8,
	tactical = { BUFF = 2, DISABLE = 1, },
	range = 0,
	getRadius = function(self, t) return 6 end,
	getPenalty = function(self, t) return self:combatTalentPhysicalDamage(t, 5, 36) end,
	do_daunting_presence = function(self, t)
		if self.__do_daunting_presence_running then return end
		self.__do_daunting_presence_running = true
		local tg = {type="ball", range=0, radius=t.getRadius(self, t), friendlyfire=false, talent=t}
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if target then
				target:setEffect(target.EFF_INTIMIDATED, 2, {power=t.getPenalty(self, t)})
			end
		end)
		self.__do_daunting_presence_running = nil
	end,
	callbackOnAct = function(self, t)
		t.do_daunting_presence(self, t)
	end,
	activate = function(self, t)
		local ret = {	}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local penalty = t.getPenalty(self, t)
		return ([[Enemies are intimidated by your very presence.
		Enemies within radius %d have their Physical Power, Mindpower, and Spellpower reduced by %d.
		The power of the intimidation effect improves with your Physical power]]):
		tformat(radius, penalty)
	end,
}

newTalent{
	name = "Adrenaline Surge", -- no stamina cost; it's main purpose is to give the player an alternative means of using stamina based talents
	type = {"technique/conditioning", 4},
	require = techs_con_req4,
	points = 5,
	cooldown = 24,
	tactical = { STAMINA = 1, BUFF = 1 },
	on_pre_use_ai = function(self, t) -- save it for combat
		local tgt = self.ai_target.actor
		if self.stamina/self.max_stamina < 0.5 or tgt and core.fov.distance(self.x, self.y, tgt.x, tgt.y) < 10 and self:hasLOS(tgt.x, tgt.y) then return true end
	end,
	getAttackPower = function(self, t) return self:combatTalentStatDamage(t, "con", 5, 45) end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7)) end, -- Limit < 24
	no_energy = true,
	action = function(self, t)
		self:setEffect(self.EFF_ADRENALINE_SURGE, t.getDuration(self, t), {power = t.getAttackPower(self, t)})
		return true
	end,
	info = function(self, t)
		local attack_power = t.getAttackPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[You release a surge of adrenaline that increases your Physical Power by %d for %d turns. While the effect is active, you may continue to fight beyond the point of exhaustion.
		You may continue to use stamina based talents while at zero stamina at the cost of life.
		The Physical Power increase will scale with your Constitution.
		Using this talent does not take a turn.]]):
		tformat(attack_power, duration)
	end,
}
