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
	name = "Blurred Mortality",
	type = {"spell/necrosis",1},
	require = spells_req1,
	mode = "passive",
	points = 5,
	getLifeBonus = function(self, t)
		return self:combatTalentStatDamage(t, "con", 30, 1000)
	end,
	getLifeLostFactor = function(self, t)
		return 0.5
	end,
	getResists = function(self, t)
		return self:combatTalentScale(t, 6, 12)
	end,
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_CON then self:updateTalentPassives(t) end
	end,
	callbackOnAct = checkLifeThreshold(1, function(self, t)
		self:updateTalentPassives(t)
	end),
	passives = function(self, t, p)
		if type(self.max_life) ~= "number" then return end -- Prevent running on NPCs being spawned
		local bonus = t.getLifeBonus(self, t)
		self:talentTemporaryValue(p, "die_at", -bonus)
		self:talentTemporaryValue(p, "max_life", -math.ceil(bonus * t.getLifeLostFactor(self, t)))
		if self.life < 1 then
			self:talentTemporaryValue(p, "resists", {all=t.getResists(self, t)})
		end
	end,
	info = function(self, t)
		local bonus = t.getLifeBonus(self, t)
		return ([[The line between life and death blurs for you.
		You can only die when you reach -%d life but your maximum life is reduced by %d.
		When you are below 1 life you gain %d%% to all resistances.
		The life amount is based on your Constitution attribute.]]):
		tformat(bonus, math.ceil(bonus * t.getLifeLostFactor(self, t)), t.getResists(self, t))
	end,
}

newTalent{
	name = "Across the Veil",
	type = {"spell/necrosis",2},
	require = spells_req2,
	mode = "passive",
	points = 5,
	radius = function(self, t) return self:combatTalentLimit(t, 10, 2, 6) end,
	getCD = function(self, t) return math.ceil(self:combatTalentLimit(t, 12, 2, 8)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 260) end,
	callbackOnAct = checkLifeThreshold(1, function(self, t)
		local list = {}
		for tid, c in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t and not t.fixed_cooldown then list[#list+1] = tid end
		end
		
		local cd = t.getCD(self, t)
		local dam = self:spellCrit(t.getDamage(self, t))
		game.logSeen(self, "#GREY#%s unleashes a blast of frostdusk as %s crosses the veil!", self:getName():capitalize(), string.he_she(self))
		self:projectApply({type="ball", radius=self:getTalentRadius(t), talent=t, friendlyfire=false}, self.x, self.y, Map.ACTOR, function(target, px, py)
			local d = DamageType:get(DamageType.FROSTDUSK).projector(self, target.x, target.y, DamageType.FROSTDUSK, dam)
			if d > 0 and #list > 0 then
				self:alterTalentCoolingdown(rng.tableRemove(list), -cd)
			end
		end, "hostile")
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "shockwave", {radius=self:getTalentRadius(t), distort_color=colors.simple1(colors.BLACK), allow=core.shader.allow("distort")})
		return true
	end),
	info = function(self, t)
		return ([[As you learn to tiptoe across the veil of death you learn to master the dark forces.
		Each time you cross the 1 life threshold you automatically unleash a blast of %0.2f frostdusk damage in radius %d.
		For each creature that takes damage from the blast one of your talent's cooldown is reduced by %d turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.FROSTDUSK, t.getDamage(self, t)), self:getTalentRadius(t), t.getCD(self, t))
	end,
}

newTalent{
	name = "Runeskin",
	type = {"spell/necrosis",3},
	require = spells_req3,
	points = 5,
	mode = "passive",
	no_npc_use = true, -- They mostly wouldnt use it efficiently
	getLifeBonus = function(self, t) return self:combatTalentScale(t, 8, 30) end,
	getCrit = function(self, t) return self:combatTalentScale(t, 1, 3) end,
	countRunes = function(self, t)
		local nb = 0
		for tid, lvl in pairs(self.talents) do
			local tt = self:getTalentFromId(tid)
			if tt.is_inscription then
				if tt.is_nature then nb = -1 break end -- FILTHY NATURE USER! WE ARE DONE WITH YOU!
				if tt.is_spell then nb = nb + 1 end
			end
		end
		return nb
	end,	
	callbackOnTalentChange = function(self, t, tid, mode, lvldiff)
		if self:getTalentFromId(tid).is_inscription then self:updateTalentPassives(t) end
	end,
	passives = function(self, t, p)
		local nb = t.countRunes(self, t)
		if nb < 1 then return end
		self:talentTemporaryValue(p, "die_at", -t.getLifeBonus(self, t) * nb)
		self:talentTemporaryValue(p, "combat_spellcrit", t.getCrit(self, t) * nb)
	end,
	info = function(self, t)
		local bonus
		local nb = t.countRunes(self, t)
		if nb == -1 then bonus = _t"effects disabled because of an infusion"
		elseif nb == 0 then bonus = _t"effects disabled because of no rune"
		elseif nb > 0 then bonus = ("%d runes active"):tformat(nb) end

		return ([[As you continue to attune your body to undeath you reject nature as a whole.
		As long as you have no natural infusion on your skin, each rune on it increases your minimum negative life by -%d and your spells critical chance by %0.1f%%.

		Currently: %s]]):
		tformat(t.getLifeBonus(self, t), t.getCrit(self, t), bonus)
	end,
}

newTalent{
	name = "Spikes of Decrepitude",
	type = {"spell/necrosis",4},
	require = spells_req4,
	mode = "sustained",
	points = 5,
	radius = 10,
	sustain_mana = 10,
	sustain_soul = 2,
	cooldown = 10,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 70) end,
	getReduce = function(self, t) return self:combatTalentLimit(t, 50, 8, 25) end,
	callbackOnActBase = function(self, t)
		local runes = self:callTalent(self.T_RUNESKIN, "countRunes")
		if runes < 1 then return end
		local dam = t.getDamage(self, t) -- no crit
		local reduce = t.getReduce(self, t)
		local targets = table.keys(self:projectCollect({type="ball", radius=self:getTalentRadius(t), talent=t}, self.x, self.y, Map.ACTOR, "hostile"))
		while #targets > 0 and runes > 0 do
			local target = rng.tableRemove(targets)
			runes = runes - 1
			DamageType:get(DamageType.FROSTDUSK).projector(self, target.x, target.y, DamageType.FROSTDUSK, dam)
			game.level.map:particleEmitter(target.x, target.y, 1, "spike_decrepitude", {})
			if self.life < 1 then
				target:setEffect(target.EFF_SPIKE_OF_DECREPITUDE, 2, {apply_power=self:combatSpellpower(), power=reduce})
			end
		end
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Each turn you unleash dark powers through your runeskin.
		For each rune you have a random foe in sight will be hit by a spike of decrepitude, dealing %0.2f frostdusk damage.
		A foe can only be hit by one spike per turn.
		If your life is below 1, the spikes also reduce all damage done by the targets by %d%%.]]):
		tformat(damDesc(self, DamageType.FROSTDUSK, t.getDamage(self, t)), t.getReduce(self, t))
	end,
}
