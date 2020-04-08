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

local Dialog = require "engine.ui.Dialog"

newTalent{
	name = "Illuminate",
	type = {"spell/phantasm",1},
	require = spells_req1,
	random_ego = "utility",
	points = 5,
	mana = 5,
	cooldown = 14,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	tactical = { DISABLE = function(self, t, aitarget)
			if self:getTalentLevel(t) >= 3 and not aitarget:attr("blind") then
				return 2
			end
			return 0
		end,
		ATTACKAREA = { LIGHT = 1 },
	},
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 210) end,
	getBlindPower = function(self, t) if self:getTalentLevel(t) >= 5 then return 4 else return 3 end end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y, max_alpha=80})
		if self:getTalentLevel(t) >= 3 then
			self:project(tg, self.x, self.y, DamageType.BLIND, t.getBlindPower(self, t))
		end
		self:project(tg, self.x, self.y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)))
		tg.selffire = true
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local turn = t.getBlindPower(self, t)
		local dam = t.getDamage(self, t)
		return ([[Creates a globe of pure light within a radius of %d that illuminates the area and deals %0.2f damage to all creatures.
		At level 3, it also blinds all who see it (except the caster) for %d turns.]]):
		tformat(radius, damDesc(self, DamageType.LIGHT, dam), turn)
	end,
}

newTalent{
	name = "Phantasmal Shield",
	type = {"spell/phantasm", 2},
	mode = "sustained",
	require = spells_req2,
	points = 5,
	sustain_mana = 30,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 200) end,
	getEvade = function(self, t) return self:combatTalentSpellDamage(t, 1, 16) + 5 end,
	getDur = function(self, t) return self:combatTalentLimit(t, 5, 15, 9) end,
	radius = function(self, t) return self:combatTalentScale(t, 1, 4) end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if not p.icd then return end
		p.icd = p.icd - 1
		if p.icd <= 0 then p.icd = nil end
	end,
	callbackOnHit = function(self, t, cb, src, dt)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if cb.value <= 0 then return end
		if rng.percent(t.getEvade(self, t)) then
			game:delayedLogDamage(src, self, 0, ("#YELLOW#(%d ignored)#LAST#"):format(cb.value), false)
			cb.value = 0
			return true
		elseif not p.icd and src.x and src.y then
			p.icd = t.getDur(self, t)
			local dam = self:spellCrit(t.getDamage(self, t))
			self:projectApply({type="ball", selffire=false, radius=self:getTalentRadius(t), x=src.x, y=src.y}, src.x, src.y, Map.ACTOR, function(target, x, y)
				DamageType:get(DamageType.LIGHT).projector(self, x, y, DamageType.LIGHT, dam)
				target:setEffect(target.EFF_DAZZLED, 5, {power=10, apply_power=self:combatSpellpower()})
			end)
			game.level.map:particleEmitter(src.x, src.y, self:getTalentRadius(t), "sunburst", {radius=self:getTalentRadius(t), max_alpha=80})
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local ret = {}
		self:talentParticles(ret, {type="phantasm_shield"})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Surround yourself with a phantasmal shield of pure light.
		Whenever you would take damage there is %d%% chance to become ethereal for an instant and fully ignore it.
		If you do get it, the shield glow brightly, sending triggering a flash of light on the attacker, dealing %0.2f light damage in radius %d around it and dazzling any affected creature (deal 10%% less damage) for 5 turns. This can only happen every %d turns.
		The damage and ignore chance will increase with your Spellpower.]]):
		tformat(t.getEvade(self, t), damDesc(self, DamageType.LIGHT, damage), self:getTalentRadius(t), t.getDur(self, t))
	end,
}

newTalent{
	name = "Invisibility",
	type = {"spell/phantasm", 3},
	require = spells_req3,
	points = 5,
	mana = 35,
	cooldown = 20,
	tactical = { ESCAPE = 2, DEFEND = 2 },
	getInvisibilityPower = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	getDamPower = function(self, t) return self:combatTalentScale(t, 10, 30) end,
	action = function(self, t)
		self:setEffect(self.EFF_GREATER_INVISIBILITY, 7, {dam=t.getDamPower(self, t), power=t.getInvisibilityPower(self, t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[Weave a net of arcane disturbances around your body, removing yourself from the sight of all, granting %d bonus to invisibility for 7 turns.
		While invisible all damage you deal against blinded or dazzled foes is increased by %d%% (additive with other damage increases).
		The invisibility bonus will increase with your Spellpower.]]):
		tformat(t.getInvisibilityPower(self, t), t.getDamPower(self, t))
	end,
}

newTalent{
	name = "Elemental Mirage", image = "talents/blur_sight.png",
	type = {"spell/phantasm", 4},
	mode = "sustained",
	require = spells_req4,
	points = 5,
	sustain_mana = 30,
	cooldown = 20,
	tactical = { BUFF = 2 },
	no_npc_use = true,
	autolearn_talent = "T_ALTER_MIRAGE",
	getBonus = function(self, t) return self:combatTalentScale(t, 10, 30) end,
	chooseElements = function(self, t)
		local DT = DamageType
		local elements = {}
		for _, dtid in ipairs{DT.ARCANE, DT.FIRE, DT.LIGHTNING, DT.COLD, DT.PHYSICAL, DT.LIGHT, DT.TEMPORAL, DT.ACID, DT.NATURE, DT.BLIGHT, DT.DARKNESS} do
			local dt = DT:get(dtid)
			elements[#elements+1] = {name = dt.text_color..dt.name, id=dtid}
		end

		local e1, e2 = nil, nil

		local res = self:talentDialog(Dialog:listPopup("Elemental Mirage", "Choose the first element:", elements, 400, 300, function(item) self:talentDialogReturn(item) end))
		if not res then return nil end
		e1 = res.id
		table.removeFromList(elements, res)

		local res = self:talentDialog(Dialog:listPopup("Elemental Mirage", "Choose the second element:", elements, 400, 300, function(item) self:talentDialogReturn(item) end))
		if not res then return nil end
		e2 = res.id

		return e1, e2
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		self.elemental_mirage_elements = self.elemental_mirage_elements or {}
		if not self.elemental_mirage_elements.e1 then return end
		if not death_note or not death_note.damtype then return end

		if death_note.damtype == self.elemental_mirage_elements.e1 then
			if self.turn_procs.elemental_mirage1 then return end
			self.turn_procs.elemental_mirage1 = true

			local pen = nil
			if self:getTalentLevel(t) >= 5 then
				local ep1 = self:combatGetResistPen(self.elemental_mirage_elements.e1, true)
				local ep2 = self:combatGetResistPen(self.elemental_mirage_elements.e2, true)
				if ep2 < ep1 then pen = ep1 - ep2 end
			end

			self:setEffect(self.EFF_ELEMENTAL_MIRAGE2, 3, {dt=self.elemental_mirage_elements.e2, power=t.getBonus(self, t), pen=pen})
		elseif death_note.damtype == self.elemental_mirage_elements.e2 then
			if self.turn_procs.elemental_mirage2 then return end
			self.turn_procs.elemental_mirage2 = true

			local pen = nil
			if self:getTalentLevel(t) >= 5 then
				local ep1 = self:combatGetResistPen(self.elemental_mirage_elements.e1, true)
				local ep2 = self:combatGetResistPen(self.elemental_mirage_elements.e2, true)
				if ep1 < ep2 then pen = ep2 - ep1 end
			end

			self:setEffect(self.EFF_ELEMENTAL_MIRAGE1, 3, {dt=self.elemental_mirage_elements.e1, power=t.getBonus(self, t), pen=pen})
		end
	end,
	activate = function(self, t)
		self.elemental_mirage_elements = self.elemental_mirage_elements or {}
		local e1, e2
		if self.elemental_mirage_elements.e1 then e1, e2 = self.elemental_mirage_elements.e1, self.elemental_mirage_elements.e2
		else e1, e2 = t.chooseElements(self, t) end

		game:playSoundNear(self, "talents/heal")
		local ret = {}
		self.elemental_mirage_elements = {e1=e1, e2=e2}

		self:addShaderAura("elemental_mirage", "crystalineaura", {time_factor=500, spikeOffset=0.123123, spikeLength=1.1, spikeWidth=3, growthSpeed=5, color={255/255, 215/255, 0/255}}, "particles_images/smoothspikes.png")

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("elemental_mirage")
		return true
	end,
	info = function(self, t)
		self.elemental_mirage_elements = self.elemental_mirage_elements or {}
		local DT = DamageType
		local e1, e2
		if self.elemental_mirage_elements.e1 then
			local dt1 = DT:get(self.elemental_mirage_elements.e1)
			local dt2 = DT:get(self.elemental_mirage_elements.e2)
			e1, e2 = dt1.text_color..dt1.name, dt2.text_color..dt2.name
		else
			e1, e2 = "not selected", "not selected"
		end

		return ([[Your mastery of both illusion and elements knows no bound.
		Upon first sustaining this spell you may select two elements. You may later change them with the Alter Mirage spell, provided automatically upon learning this one.

		Any time you deal damage with one of those elements, the other gets a bonus of %d%% damage for 3 turns.
		At level 5 if the target element has less resistance penetration, it gets increased to match the one of the source element.

		Current elements selected: %s#LAST# and %s]]):
		tformat(t.getBonus(self, t), e1, e2)
	end,
}

newTalent{
	name = "Alter Mirage",
	type = {"spell/other", 1},
	points = 5,
	mana = 3,
	cooldown = 3,
	no_npc_use = true,
	action = function(self, t)
		local e1, e2 = self:callTalent(self.T_ELEMENTAL_MIRAGE, "chooseElements")
		if not e1 then return end
		self.elemental_mirage_elements = {e1=e1, e2=e2}
		return true
	end,
	info = function(self, t)
		return _t[[Change your choice of elements for Elemental Mirage.]]
	end,
}
