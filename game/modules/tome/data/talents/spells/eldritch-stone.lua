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
	name = "Stone Spikes",
	type = {"spell/eldritch-stone", 1},
	require = spells_req1,
	points = 5,
	equilibrium = 8,
	mana = 20,
	cooldown = 12,
	tactical = { ATTACK = function(self, t, target)
			local v = { PHYSICAL = 2 }
			if self:knowTalent(self.T_POISONED_SPIKES) then v.NATURE = 1 end
			if self:knowTalent(self.T_ELDRITCH_SPIKES) then v.ARCANE = 1 end
			if self:knowTalent(self.T_IMPALING_SPIKES) then v.PHYSICAL = 3 end
			return v
		end,
		DISABLE = function(self, t, target)
			local v = {}
			if self:knowTalent(self.T_POISONED_SPIKES) then v.heal = 1 end
			if self:knowTalent(self.T_ELDRITCH_SPIKES) then v.silence = 1 end
			if self:knowTalent(self.T_IMPALING_SPIKES) then v.disarm = 1 end
			return next(v) and v or 0
		end,
	},
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4.7, 5.8)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 50, 250) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if target:canBe("cut") then target:setEffect(target.EFF_CUT, 6, {apply_power=math.max(self:combatPhysicalpower(), self:combatSpellpower()), src=self, power=self:spellCrit(t.getDamage(self, t)) / 6}) end
			if self:knowTalent(self.T_POISONED_SPIKES) then
				local st = self:getTalentFromId(self.T_POISONED_SPIKES)
				if target:canBe("poison") then target:setEffect(target.EFF_INSIDIOUS_POISON, 6, {apply_power=math.max(self:combatPhysicalpower(), self:combatSpellpower()), src=self, heal_factor=st.getHeal(self, st), power=self:spellCrit(st.getDamage(self, st)) / 6}) end
			end
			if self:knowTalent(self.T_ELDRITCH_SPIKES) then
				local st = self:getTalentFromId(self.T_ELDRITCH_SPIKES)
				DamageType:get(DamageType.ARCANE).projector(self, px, py, DamageType.ARCANE, self:spellCrit(st.getDamage(self, st)))
				if target:canBe("silence") then target:setEffect(target.EFF_SILENCED, st.getSilence(self, st), {apply_power=math.max(self:combatPhysicalpower(), self:combatSpellpower())}) end
			end
			if self:knowTalent(self.T_IMPALING_SPIKES) then
				local st = self:getTalentFromId(self.T_IMPALING_SPIKES)
				DamageType:get(DamageType.PHYSICAL).projector(self, px, py, DamageType.PHYSICAL, self:spellCrit(st.getDamage(self, st)))
				if target:canBe("disarm") then target:setEffect(target.EFF_DISARMED, st.getDisarm(self, st), {apply_power=math.max(self:combatPhysicalpower(), self:combatSpellpower())}) end
			end
		end, nil, {type="stone_spikes"})

		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local xs = ""
		if self:knowTalent(self.T_POISONED_SPIKES) then
			xs = ("poisoned for %0.1f Nature damage over 6 turns (%d%% healing reduction)"):tformat(damDesc(self, DamageType.NATURE, self:callTalent(self.T_POISONED_SPIKES, "getDamage")), self:callTalent(self.T_POISONED_SPIKES, "getHeal"))
		end
		if self:knowTalent(self.T_ELDRITCH_SPIKES) then
			xs = xs..(", blasted for %0.1f Arcane damage (and silenced for %d turns),"):tformat(damDesc(self, DamageType.ARCANE, self:callTalent(self.T_ELDRITCH_SPIKES, "getDamage")), self:callTalent(self.T_ELDRITCH_SPIKES, "getSilence"))
		end
		if self:knowTalent(self.T_IMPALING_SPIKES) then
			xs = xs..(" impaled for %0.1f Physical damage (and disarmed for %d turns),"):tformat(damDesc(self, DamageType.PHYSICAL, self:callTalent(self.T_IMPALING_SPIKES, "getDamage")), self:callTalent(self.T_IMPALING_SPIKES, "getDisarm"))
		end
		return ([[Stony spikes erupt from the ground in a radius %d cone.
		Creatures caught in the area will be %scut for %0.1f Physical damage dealt over 6 turns.
		The damage increases with your Spellpower, and the chance to apply the detrimental effect(s) improves with Spellpower or Physical Power, whichever is greater.]])
		:tformat(self:getTalentRadius(t), xs ~="" and xs.._t" and " or "", damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Poisoned Spikes",
	type = {"spell/eldritch-stone", 2},
	require = spells_req2,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 200) end,
	getHeal = function(self, t)
		return self:combatLimit(math.max(self:combatTalentSpellDamage(t, 30, 50),self:combatTalentPhysicalDamage(t, 30, 50)), 100, 20, 0, 56.8, 36.8) 
	end, -- fix
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[Coats your stone spikes with insidious poison, dealing %0.1f total nature damage over 6 turns while reducing all healing by %d%%.
		The damage increases with Spellpower and the chance to poison and healing reduction increases with either Spellpower or Physical Power, whichever is greater.]]):
		tformat(damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getHeal(self, t))
	end,
}

newTalent{
	name = "Eldritch Spikes",
	type = {"spell/eldritch-stone", 3},
	require = spells_req3,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 180) end,
	getSilence = function(self, t) return math.ceil(self:combatTalentLimit(t, 12, 4, 8.5)) end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[Imbues your stone spikes with arcane forces, dealing %0.1f Arcane damage and silencing each target hit for %d turns.
		The damage increases with Spellpower and the chance to silence increases with either Spellpower or Physical Power, whichever is greater.]]):
		tformat(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)), t.getSilence(self, t))
	end,
}

newTalent{
	name = "Impaling Spikes",
	type = {"spell/eldritch-stone", 4},
	require = spells_req4,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 200) end,
	getDisarm = function(self, t) return math.ceil(self:combatTalentLimit(t, 12, 4, 8.5)) end,
	info = function(self, t)
		return ([[Your stone spikes grow in length, instantly dealing %0.1f Physical damage and disarming targets hit for %d turns.
		The damage increases with Spellpower and the chance to disarm increases with either Spellpower or Physical Power, whichever is greater.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDisarm(self, t))
	end,
}

