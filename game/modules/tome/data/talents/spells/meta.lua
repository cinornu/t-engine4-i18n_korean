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
	name = "Disperse Magic",
	type = {"spell/meta",1},
	require = spells_req1,
	points = 5,
	random_ego = "utility",
	mana = 40,
	cooldown = 25,
	random_boss_rarity = 50,
	-- no_energy = function(self, t) return self:getTalentLevel(t) >= 7 and true or false end,
	tactical = { CURE = function(self, t, aitarget)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end,
		DISABLE = function(self, t, aitarget)
			local nb = 0
			for eff_id, p in pairs(aitarget.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "beneficial" then nb = nb + 1 end
			end
			for tid, act in pairs(aitarget.sustain_talents) do
				if act then
					local talent = aitarget:getTalentFromId(tid)
					if talent.is_spell then nb = nb + 1 end
				end
			end
			return nb^0.5
		end},
	direct_hit = true,
	requires_target = function(self, t) return self:getTalentLevel(t) >= 3 and (self.player or t.tactical.cure(self, t) <= 0) end,
	range = 10,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local target = self

		if self:getTalentLevel(t) >= 3 then
			local tg = {type="hit", range=self:getTalentRange(t)}
			local tx, ty = self:getTarget(tg)
			if tx and ty and game.level.map(tx, ty, Map.ACTOR) then
				local _ _, tx, ty = self:canProject(tg, tx, ty)
				if not tx then return nil end
				target = game.level.map(tx, ty, Map.ACTOR)
				if not target then return nil end

				target = game.level.map(tx, ty, Map.ACTOR)
			else return nil
			end
		end

		local effs = {}

		-- Go through all spell effects
		if self:reactionToward(target) < 0 then
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					local talent = target:getTalentFromId(tid)
					if talent.is_spell then effs[#effs+1] = {"talent", tid} end
				end
			end
		else
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			target:dispel(eff[2], self)
		end
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[Removes up to %d magical effects (good effects from foes, and bad effects from friends) from the target.
		At level 3, it can be targeted.
		]]):
		-- At level 7, it takes no turn to cast.
		tformat(count)
	end,
}

newTalent{
	name = "Spellcraft",
	type = {"spell/meta",2},
	require = spells_req2,
	points = 5,
	sustain_mana = 80,
	cooldown = 30,
	mode = "sustained",
	tactical = { BUFF = 2 },
	getChance = function(self, t) return self:getTalentLevelRaw(t) * 20 end,
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
			cd = self:addTemporaryValue("spellshock_on_damage", self:combatTalentSpellDamage(t, 10, 320) / 4),
			shock = self:addTemporaryValue("spell_cooldown_reduction", t.getCooldownReduction(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("spellshock_on_damage", p.cd)
		self:removeTemporaryValue("spell_cooldown_reduction", p.shock)
		return true
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[You learn to finely craft and tune your spells, reducing all their cooldowns by %d%%.
		In doing so you can also carve a hole in spells that affect an area to avoid damaging yourself.  The chance of success is %d%%.
		In addition, you hone your damaging spells to spellshock their targets. Whenever you deal damage with a spell you attempt to spellshock them with %d more Spellpower than normal. Spellshocked targets suffer a temporary 20%% penalty to damage resistances.]]):
		tformat(cooldownred * 100, chance, self:combatTalentSpellDamage(t, 10, 320) / 4)
	end,
}

newTalent{
	name = "Energy Alteration", image = "talents/quicken_spells.png",
	type = {"spell/meta",3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	sustain_mana = 80,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getPct = function(self, t) return math.min(100, math.ceil(self:combatTalentScale(t, 30, 90))) end,
	forceActivate = function(self, t, damtype)
		if not self:isTalentActive(t.id) then return end
		if self:hasEffect(self.EFF_ENERGY_ALTERATION_FIRE) or self:hasEffect(self.EFF_ENERGY_ALTERATION_COLD) or self:hasEffect(self.EFF_ENERGY_ALTERATION_ARCANE) or self:hasEffect(self.EFF_ENERGY_ALTERATION_TEMPORAL) or
			self:hasEffect(self.EFF_ENERGY_ALTERATION_PHYSICAL) or self:hasEffect(self.EFF_ENERGY_ALTERATION_MIND) or self:hasEffect(self.EFF_ENERGY_ALTERATION_BLIGHT) or self:hasEffect(self.EFF_ENERGY_ALTERATION_NATURE) or
			self:hasEffect(self.EFF_ENERGY_ALTERATION_LIGHT) or self:hasEffect(self.EFF_ENERGY_ALTERATION_DARKNESS) or self:hasEffect(self.EFF_ENERGY_ALTERATION_LIGHTNING) or self:hasEffect(self.EFF_ENERGY_ALTERATION_ACID)
		then return end
		if not self['EFF_ENERGY_ALTERATION_'..damtype] then return end
		self:setEffect(self['EFF_ENERGY_ALTERATION_'..damtype], 6, {power=t:_getPct(self)})
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not death_note then return end
		if death_note.source_talent_mode ~= "active" then return end
		if not death_note.source_talent or not death_note.source_talent.is_spell then return end
		t.forceActivate(self, t, death_note.damtype)
	end,	
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Your mastery over magic is so great that you can alter the energy of all damaging spells to suit your needs.
		Whenever you deal damage with a spell you attune to the element of that spell for 6 turns, converting %d%% of any damage you deal into that element.
		This effect will not override itself and will only trigger from spells directly cast by you, not from damage over time or ground damage effects.]]):
		tformat(t:_getPct(self))
	end,
}

newTalent{
	name = "Metaflow",
	type = {"spell/meta",4},
	require = spells_req4,
	points = 5,
	mana = 70,
	cooldown = 50,
	fixed_cooldown = true,
	tactical = { BUFF = function(self, t, aitarget)
		local maxcount, maxlevel = t.getTalentCount(self, t), t.getMaxLevel(self, t)
		local count, tt = 0, nil
		for tid, _ in pairs(self.talents_cd) do
			tt = self:getTalentFromId(tid)
			if tt.is_spell and not tt.fixed_cooldown and tt.type[2] <= maxlevel then
				count = count + 1
			end
			if count >= maxcount then break end
		end
		return count ^.5
	end },
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return util.bound(math.floor(self:getTalentLevel(t)), 1, 4) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 2, 12)) end,
	action = function(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if not tt.fixed_cooldown then
				if tt.type[2] <= t.getMaxLevel(self, t) and tt.is_spell then
					tids[#tids+1] = tid
				end
			end
		end
		for i = 1, t.getTalentCount(self, t) do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self:setEffect(self.EFF_METAFLOW, t:_getDur(self), {power=1})
		self.changed = true
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[Your mastery of arcane flows allow you to reset the cooldown of up to %d of your spells (that don't have a fixed cooldown) of tier %d or less.
		In addition for %d turns you are overflowing with energy; all known spells are considered one talent level higher when casting them.]]):
		tformat(talentcount, maxlevel, t:_getDur(self))
	end,
}
