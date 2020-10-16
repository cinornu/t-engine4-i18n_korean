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
	name = "Greater Weapon Focus",
	type = {"technique/battle-tactics", 1},
	require = techs_req_high1,
	points = 5,
	cooldown = 15,
	stamina = 25,
	tactical = { ATTACK = 3 },
	no_energy = true,
	getdur = function(self,t) return math.floor(self:combatTalentLimit(t, 10, 4, 8)) end, -- Limit to <10
	getchance = function(self,t) return self:combatLimit(self:combatTalentStatDamage(t, "dex", 10, 90),100, 6.8, 6.8, 61, 61) end, -- Limit < 100%
	action = function(self, t)
		self:setEffect(self.EFF_GREATER_WEAPON_FOCUS, t.getdur(self,t), {chance=t.getchance(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[Concentrate on your blows; for %d turns, each strike you land on your target in melee range has a %d%% chance to trigger another, similar strike.
		This works for all blows, even those from other talents and from shield bashes, but you can gain no more than one extra blow with each weapon during a turn.
		The chance increases with your Dexterity.]]):tformat(t.getdur(self, t), t.getchance(self, t))
	end,
}

newTalent{ -- Doesn't scale past level 5, could use some bonus for higher talent levels
	name = "Step Up",
	type = {"technique/battle-tactics", 2},
	require = techs_req_high2,
	mode = "passive",
	points = 5,
	info = function(self, t)
		return ([[After killing a foe, you have a %d%% chance to gain a 1000%% movement speed bonus for 1 game turn.
		The bonus disappears as soon as any action other than moving is done.
		Note: since you will be moving very fast, game turns will pass very slowly.]]):tformat(math.min(100, self:getTalentLevelRaw(t) * 20))
	end,
}

newTalent{
	name = "Bleeding Edge",
	type = {"technique/battle-tactics", 3},
	require = techs_req_high3,
	points = 5,
	cooldown = 12,
	stamina = 14,
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	tactical = { ATTACK = { weapon = 1, cut = 1 }, DISABLE = 2 },
	healloss = function(self,t) return self:combatTalentLimit(t, 150, 40, 75) end, -- Limit to < 150%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
		if hit then
			if target:canBe("cut") then
				local sw = self:getInven("MAINHAND")
				if sw then
					sw = sw[1] and sw[1].combat
				end
				sw = sw or self.combat
				local dam = self:combatDamage(sw)
				local damrange = self:combatDamageRange(sw)
				dam = rng.range(dam, dam * damrange)
				dam = dam * self:combatTalentWeaponDamage(t, 2, 3.2)

				target:setEffect(target.EFF_DEEP_WOUND, 7, {src=self, heal_factor=t.healloss(self, t), power=dam / 7, apply_power=self:combatAttack()})
			end
		end
		return true
	end,
	info = function(self, t)
		local heal = t.healloss(self,t)
		return ([[Lashes at the target, doing %d%% weapon damage.
		If the attack hits, the target will bleed for %d%% weapon damage over 7 turns, and all healing will be reduced by %d%%.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 1, 1.7), 100 * self:combatTalentWeaponDamage(t, 2, 3.2), heal)
	end,
}

newTalent{
	name = "True Grit",
	type = {"technique/battle-tactics", 4},
	require = techs_req_high4,
	points = 5,
	mode = "sustained",
	cooldown = 15,
	sustain_stamina = 10,
	deactivate_on = {no_combat=true, run=true, rest=true},
	tactical = { DEFEND = 2 }, -- AI for this could be better
	--Note: this can result in > 100% resistancs (before cap) at high talent levels to keep up with opposing resistance lowering talents
	resistCoeff = function(self, t) return self:combatTalentScale(t, 25, 45) end,
	getCapApproach = function(self, t) return self:combatTalentLimit(t, 1, 0.25, 0.5) end,
	getResist = function(self, t) return (1 - self.life / self.max_life)*t.resistCoeff(self, t) end,
	getResistCap = function(self, t) return util.bound((100-(self.resists_cap.all or 100))*t.getCapApproach(self, t), 0, 100) end,
	remove_on_zero = true,
	drain_stamina = function(self, t, turn)
		local p = self:isTalentActive(t.id)
		return 1 + (turn or (p and p.turns) or 0)*0.3
	end,
	iconOverlay = function(self, t, p)
		local p = self.sustain_talents[t.id]
		if not p then return end
		return tostring("#RED##{bold}#"..math.floor(t.getResist(self, t))).."#LAST##{normal}#", "buff_font_small"
	end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if p.stamina then self:removeTemporaryValue("stamina_regen", p.stamina) end
		if p.turns then p.turns = p.turns + 1 end
		p.stamina = self:addTemporaryValue("stamina_regen", -(t.drain_stamina(self, t, p.turns) - t.drain_stamina(self, t, 0)))

		-- This should be redundant but there are cases the value won't properly update, ie direct life reductions
		if p.resid then self:removeTemporaryValue("resists", p.resid) end
		if p.cresid then self:removeTemporaryValue("resists_cap", p.cresid) end
		local resistbonus = t.getResist(self, t)
		p.resid = self:addTemporaryValue("resists", {all=resistbonus})
		local capbonus = t.getResistCap(self, t)
		p.cresid = self:addTemporaryValue("resists_cap", {all=capbonus})	
	end,
	callbackOnTakeDamage = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if p.resid then self:removeTemporaryValue("resists", p.resid) end
		if p.cresid then self:removeTemporaryValue("resists_cap", p.cresid) end

		--This makes it impossible to get 100% resist all cap from this talent, and most npc's will get no cap increase
		local resistbonus = t.getResist(self, t)
		p.resid = self:addTemporaryValue("resists", {all=resistbonus})
		local capbonus = t.getResistCap(self, t)
		p.cresid = self:addTemporaryValue("resists_cap", {all=capbonus})
	end,
	activate = function(self, t)
		return {
			turns = 0,
			resid = self:addTemporaryValue("resists", {all = t.getResist(self, t)}),
			cresid = self:addTemporaryValue("resists_cap", {all = t.getResistCap(self, t)})
		}
	end,
	deactivate = function(self, t, p)
		if p.resid then self:removeTemporaryValue("resists", p.resid) end
		if p.cresid then self:removeTemporaryValue("resists_cap", p.cresid) end
		if p.stamina then self:removeTemporaryValue("stamina_regen", p.stamina) end
		return true
	end,
	info = function(self, t)
		local drain = t.drain_stamina(self, t)
		local resistC = t.resistCoeff(self, t)
		return ([[Take a defensive stance to resist the onslaught of your foes.
		While wounded, you gain all damage resistance equal to %d%% of your missing health.
		(So if you have lost 70%% of your life, you gain %d%% all resistance.)
		In addition, your all damage resistance cap increases %0.1f%% closer to 100%%.
		This consumes stamina rapidly the longer it is sustained (%0.1f stamina/turn, increasing by 0.3/turn).
		The resist is recalculated each time you take damage.]]):
		tformat(resistC, resistC*0.7, t.getCapApproach(self, t)*100, drain)
	end,
}
