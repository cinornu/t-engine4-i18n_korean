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
	name = "Wild Growth",
	type = {"wild-gift/fungus", 1},
	require = gifts_req1,
	points = 5,
	mode = "passive",
	getLife = function(self, t) return self:combatTalentStatDamage(t, "wil", 10, 600) end,
	getRegen = function(self, t) return self:combatTalentStatDamage(t, "wil", 1, 20) end,
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "max_life", t.getLife(self, t))
		self:talentTemporaryValue(tmptable, "life_regen", t.getRegen(self, t))
	end,
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_WIL then
			self:updateTalentPassives(t)
		end
	end,
	info = function(self, t)
		return ([[Surround yourself with a myriad of tiny, nearly invisible, reinforcing fungi.
		You gain %d maximum life and %d life regeneration.
		The effects will increase with your Willpower.]]):
		tformat(t.getLife(self, t), t.getRegen(self, t))
	end,
}

newTalent{
	name = "Fungal Growth",
	type = {"wild-gift/fungus", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
	getDurationBonus = function(self, t) return math.min(150, self:combatTalentMindDamage(t, 1, 100)) / 100 end,  -- +1 on 5 duration effects (Regeneration infusion) every 20%
	newDuration = function(self, t, dur) return dur + math.ceil(dur * t.getDurationBonus(self, t)) + 1 end,
	callbackOnTemporaryEffect = function(self, t, eff_id, e_def, eff)
		if e_def.subtype.regeneration and e_def.type ~= "other" then
			eff.dur = t:_newDuration(self, eff.dur)
		end
	end,
	info = function(self, t)
		return ([[The fungus on your body allows regeneration effects to last longer.
		Each time you gain a beneficial effect with the regeneration subtype you increase its duration by %d%% + 1 rounded up.
		The effect will increase with your Mindpower.]]):
		tformat(t.getDurationBonus(self, t) * 100)
	end,
}

newTalent{
	name = "Ancestral Life",
	type = {"wild-gift/fungus", 3},
	require = gifts_req3,
	points = 5,
	mode = "passive",
	getEq = function(self, t) return self:combatTalentScale(t, 0.5, 2.5, 0.5, 0.5) end,
	getTurn = function(self, t) return math.min(15, self:combatTalentMindDamage(t, 1, 8)) / 100 end,
	callbackOnHeal = function(self, t, value, src, raw_value)
		local heal = (self.life + value) < self.max_life and value or self.max_life - self.life
		if heal > 0 then
			local amt = (heal / 100) * (t.getTurn(self, t) * game.energy_to_act)
			self.energy.value = self.energy.value + amt
			self.energy.value = math.min(self.energy.value, game.energy_to_act * 2)
			self.ancestral_healing_display_amt = self.ancestral_healing_display_amt or 0
			self.ancestral_healing_display_amt = self.ancestral_healing_display_amt + amt
			game:onTickEnd(function() 
				if not self.ancestral_healing_display_amt then return end
				if self.last_ancestral_display == game.turn then return end
				self:logCombat(self, "#LIGHT_GREEN##Source# gains %d%%%% of a turn from Ancestral Life.#LAST#", self.ancestral_healing_display_amt / 10)
				self.ancestral_healing_display_amt = nil
				self.last_ancestral_display = game.turn
			end)
		end
	end,
 -- Only log turn games after totaling heals for each tick to avoid log spam, but special case talent activation to dump it immediately so instant heals aren't weird
	callbackOnTalentPost = function(self, t,  ab)
		if not self.ancestral_healing_display_amt then return end		
		self:logCombat(self, "#LIGHT_GREEN##Source# gains %d%%%% of a turn from Ancestral Life.#LAST#", self.ancestral_healing_display_amt / 10)
		self.ancestral_healing_display_amt = nil
		self.last_ancestral_display = game.turn
	end,
	info = function(self, t)
		local eq = t.getEq(self, t)
		local turn = t.getTurn(self, t)
		return ([[Your fungus reaches into the primordial ages of the world, granting you ancient instincts.
		Each time you receive non-regeneration healing you gain %0.1f%% of a turn per 100 life healed.  This effect can't add energy past 2 stored turns and overhealing is not counted.
		Also, regeneration effects on you will decrease your equilibrium by %0.1f each turn.
		The turn gain increases with your Mindpower.]]):
		tformat(turn * 100, eq)
	end,
}

newTalent{
	name = "Sudden Growth",
	type = {"wild-gift/fungus", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 22,
	cooldown = 15,
	tactical = { HEAL = function(self, t, target) return self.life_regen > 0 and math.log(self.life_regen + 1)/2 or nil end },
	getMult = function(self, t) return self:combatTalentScale(t, 2, 5) end,
	action = function(self, t)
		local amt = self:mindCrit(self.life_regen * t.getMult(self, t))

		self:attr("allow_on_heal", 1)
		self:heal(amt, t)
		self:attr("allow_on_heal", -1)

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local mult = t.getMult(self, t)
		return ([[A wave of energy passes through your fungus, making it release immediate healing energies on you, healing you for %d%% of your current life regeneration rate (#GREEN#%d#LAST#).]]):
		tformat(mult * 100, self.life_regen * mult)
	end,
}
