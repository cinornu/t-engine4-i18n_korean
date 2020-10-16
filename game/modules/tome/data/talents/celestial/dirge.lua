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

clearDirges = function(self)
	if self:hasEffect(self.EFF_DIRGE_OF_FAMINE) then
		self:removeEffect(self.EFF_DIRGE_OF_FAMINE)
	end
	if self:hasEffect(self.EFF_DIRGE_OF_CONQUEST) then
		self:removeEffect(self.EFF_DIRGE_OF_CONQUEST)
	end
	if self:hasEffect(self.EFF_DIRGE_OF_PESTILENCE) then
		self:removeEffect(self.EFF_DIRGE_OF_PESTILENCE)
	end
end

upgradeDirgeActivate = function(self, t, ret)
	--Fire shield
	if self:knowTalent(self.T_DIRGE_INTONER) then
		local t2 = self:getTalentFromId(self.T_DIRGE_INTONER)
		self:talentTemporaryValue(ret, "on_melee_hit", {[DamageType.MIND]=t2.getDamageOnMeleeHit(self, t2)})
		self:talentTemporaryValue(ret, "stun_immune", t2.getImmune(self, t2))
		self:talentTemporaryValue(ret, "knockback_immune", t2.getImmune(self, t2))
	end
	
	--Adept Upgrade
	if self:knowTalent(self.T_DIRGE_ADEPT) then
		local t3 = self:getTalentFromId(self.T_DIRGE_ADEPT)
		self:talentTemporaryValue(ret, "fear_immune", t3.getImmune(self, t3))
		self:talentTemporaryValue(ret, "confusion_immune", t3.getImmune(self, t3))
	end
	
	--Nihil upgrade
	if self:knowTalent(self.T_DIRGE_NIHILIST) then
		local t4 = self:getTalentFromId(self.T_DIRGE_NIHILIST)
		self:talentTemporaryValue(ret, "flat_damage_armor", {all=t4.getArmor(self, t4)})
	end
end

newTalent{
	name = "Dirge of Famine",
	type = {"celestial/dirges", 1},
	points = 5,
	no_energy = true,
	cooldown = 12,
	sustain_slots = 'fallen_celestial_dirge',
	mode = "sustained",
	getRegen = function(self, t) return self:combatTalentScale(t, 2, 6, 0.75) * math.sqrt(self.level) end,
	activate = function(self, t)
		local ret = {}
		ret.particle = self:addParticles(Particles.new("dirge_shield", 1))
		--Basic effect
		self:talentTemporaryValue(ret, "life_regen", t.getRegen(self, t))
		
		upgradeDirgeActivate(self, t, ret)
		game:playSoundNear(self, "talents/chant_one")
		
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		
		--Adept Upgrade
		if self:knowTalent(self.T_DIRGE_ADEPT) then
			clearDirges(self)
			local t3 = self:getTalentFromId(self.T_DIRGE_ADEPT)
			self:setEffect(self.EFF_DIRGE_OF_FAMINE, t3.getDuration(self, t3), {src=self, heal=t.getRegen(self, t)})
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Sing a song of wasting and desolation which sustains you in hard times.

This dirge increases your health regeneration by %d.  The regeneration will increase with your level.]]):tformat(t.getRegen(self, t))
	end,
				 }

newTalent{
	name = "Dirge of Conquest",
	type = {"celestial/dirges", 1},
	points = 5,
	no_energy = true,
	cooldown = 12,
	sustain_slots = 'fallen_celestial_dirge',
	mode = "sustained",
	getKillEnergy = function(self, t) return self:combatTalentLimit(t, 100, 33, 67) end,
	callbackOnCrit = function(self, t)
		if self.turn_procs.fallen_conquest_on_crit then return end
		self.turn_procs.fallen_conquest_on_crit = true
		
		self.energy.value = self.energy.value + 100
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, circleDescendSpeed=3.5}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, circleDescendSpeed=3.5}))
		end
	end,
	callbackOnKill = function(self, t)
		if self.turn_procs.fallen_conquest_on_kill then return end
		self.turn_procs.fallen_conquest_on_kill = true
		
		self.energy.value = self.energy.value + t.getKillEnergy(self, t) * 10
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, circleDescendSpeed=3.5}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, circleDescendSpeed=3.5}))
      end
	end,
	activate = function(self, t)
		
		local ret = {}
		ret.particle = self:addParticles(Particles.new("dirge_shield", 1))
		--Basic effect is in callbacks
		
		upgradeDirgeActivate(self, t, ret)
		game:playSoundNear(self, "talents/chant_two")
		
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		
		--Adept Upgrade
		if self:knowTalent(self.T_DIRGE_ADEPT) then
			clearDirges(self)
			local t3 = self:getTalentFromId(self.T_DIRGE_ADEPT)
			self:setEffect(self.EFF_DIRGE_OF_CONQUEST, t3.getDuration(self, t3), {power=t.getKillEnergy(self, t), src=self})
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Sing a song of violence and victory (mostly violence) and sustain yourself through cruelty.
Each time you deal a critical strike you gain 10%% of a turn (only once per turn).
Each time you kill a creature you gain %d%% of a turn (only once per turn).
]]):tformat(t.getKillEnergy(self, t))
	end,
}

newTalent{
	name = "Dirge of Pestilence",
	type = {"celestial/dirges", 1},
	points = 5,
	no_energy = true,
	cooldown = 12,
	sustain_slots = 'fallen_celestial_dirge',
	mode = "sustained",
	getShield = function(self, t) return self:combatTalentScale(t, 50, 200, 0.75) end,
	getShieldCD = function(self, t) return 5 end,
	callbackOnTemporaryEffectAdd = function(self, t, eff_id, e_def, eff)
		if not self:hasProc("dirge_shield") then
			if e_def.status == "detrimental" and e_def.type ~= "other" and eff.src ~= self then
				self:setProc("dirge_shield", true, t.getShieldCD(self, t))
				if self:hasEffect(self.EFF_DAMAGE_SHIELD) then
					local shield = self:hasEffect(self.EFF_DAMAGE_SHIELD)
					local shield_power = self:spellCrit(t.getShield(self, t))
					
					shield.power = shield.power + shield_power
					self.damage_shield_absorb = self.damage_shield_absorb + shield_power
					self.damage_shield_absorb_max = self.damage_shield_absorb_max + shield_power
					shield.dur = math.max(eff.dur, shield.dur)
				else
					self:setEffect(self.EFF_DAMAGE_SHIELD, eff.dur, {color={0xff/255, 0x3b/255, 0x3f/255}, power=self:spellCrit(t.getShield(self, t))})
				end
			end
		end
	end,
	activate = function(self, t)      
		local ret = {}
		ret.particle = self:addParticles(Particles.new("dirge_shield", 1))
		
		--Basic effect is in callbacks
		
		upgradeDirgeActivate(self, t, ret)
		game:playSoundNear(self, "talents/chant_three")
		
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		
		--Adept Upgrade
		if self:knowTalent(self.T_DIRGE_ADEPT) then
			clearDirges(self)
			local t3 = self:getTalentFromId(self.T_DIRGE_ADEPT)
			self:setEffect(self.EFF_DIRGE_OF_PESTILENCE, t3.getDuration(self, t3), {src=self, shield=t.getShield(self, t), cd=t.getShieldCD(self, t)})
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Sing a song of decay and defiance and sustain yourself through spite.
							Each time you suffer a detrimental effect, you gain a shield with strength %d, that lasts as long as the effect would.  This will add to and extend an existing shield if possible.
							This can only trigger once every %d turns]]):tformat(t.getShield(self, t), t.getShieldCD(self, t))
	end,
}


newTalent{
	name = "Dirge Acolyte",
	type = {"celestial/dirge", 1},
	require = divi_req1,
	points = 5,
	mode = "passive",
	no_unlearn_last = true,
	on_learn = function(self, t)
		self:learnTalent(self.T_DIRGE_OF_FAMINE, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_DIRGE_OF_CONQUEST, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_DIRGE_OF_PESTILENCE, true, nil, {no_unlearn=true})
	end,
	on_unlearn = function(self, t)
		self:unlearnTalent(self.T_DIRGE_OF_FAMINE)
		self:unlearnTalent(self.T_DIRGE_OF_CONQUEST)
		self:unlearnTalent(self.T_DIRGE_OF_PESTILENCE)
	end,
	
	callbackOnMove = function(self, t, moved, force, ox, oy, x, y)
		if moved and not self:knowTalentType("cursed/cursed-aura") and self.chooseCursedAuraTree then
			if self.player then
				-- function placed in defiling touch where cursing logic exists
				local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
				if t.chooseCursedAuraTree(self, t) then
					self.chooseCursedAuraTree = nil
				end
			end
		end   
	end,
	
	info = function(self, t)
		local ret = ""
		local old1 = self.talents[self.T_DIRGE_OF_FAMINE]
		local old2 = self.talents[self.T_DIRGE_OF_CONQUEST]
		local old3 = self.talents[self.T_DIRGE_OF_PESTILENCE]
		self.talents[self.T_DIRGE_OF_FAMINE] = (self.talents[t.id] or 0)
		self.talents[self.T_DIRGE_OF_CONQUEST] = (self.talents[t.id] or 0)
		self.talents[self.T_DIRGE_OF_PESTILENCE] = (self.talents[t.id] or 0)
		pcall(function()
						local t1 = self:getTalentFromId(self.T_DIRGE_OF_FAMINE)
						local t2 = self:getTalentFromId(self.T_DIRGE_OF_CONQUEST)
						local t3 = self:getTalentFromId(self.T_DIRGE_OF_PESTILENCE)
						ret = ([[Even now, something compels you to sing.
			Dirge of Famine: Increases health regen by %d.
			Dirge of Conquest: Gives you part of a turn on critical (10%%) or kill (%d%%).
			Dirge of Pestilence: Shields you for %d when an enemy inflicts a detrimental effect on you (5 turn cooldown).
			You may only have one Dirge active at a time.]]):
						tformat(t1.getRegen(self, t1), t2.getKillEnergy(self, t), t3.getShield(self, t3))
					end)
		self.talents[self.T_DIRGE_OF_FAMINE] = old1
		self.talents[self.T_DIRGE_OF_CONQUEST] = old2
		self.talents[self.T_DIRGE_OF_PESTILENCE] = old3
		return ret
	end,
}

newTalent{
	name = "Dirge Intoner",
	type = {"celestial/dirge", 2},
	require = divi_req2,
	points = 5,
	mode = "passive",
	getDamageOnMeleeHit = function(self, t) return self:combatTalentMindDamage(t, 5, 50) * (1 + (1 + self.level)/40) end,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.50) end,
	info = function(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local nostun = t.getImmune(self, t)*100
		return ([[Your dirges carry the pain within you, which threatens to swallow those who come too close.  Anyone who hits you in melee suffers %0.2f mind damage.
							You, on the other hand, are steadied by the song.  Your dirges increase your resistance to stun and knockback by %d%%.
							The damage will increase with your Mindpower and your level.]]):tformat(damDesc(self, DamageType.MIND, damage), nostun)
	end,
}

newTalent{
	name = "Dirge Adept",
	type = {"celestial/dirge", 3},
	require = divi_req3,
	points = 5,
	mode = "passive",
	getDuration = function(self, t) return self:getTalentLevel(t) end,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.50) end,
	info = function(self, t)
		return ([[Your dirges echo mournfully through the air.  When you end a dirge, you continue to gain its acolyte-level effects for %d turns.  You can only benefit from one such lingering dirge at a time.

Furthermore, you are given focus by the song.  Your dirges increase your resistance to confusion and fear by %d%%.]]):tformat(t.getDuration(self, t), t.getImmune(self, t)*100)
	end,
}

newTalent{
	name = "Dirge Nihilist",
	type = {"celestial/dirge", 4},
	require = divi_req4,
	points = 5,
	mode = "passive",
	getArmor = function(self, t) return self:combatTalentSpellDamage(t, 2, 40) end,
	info = function(self, t)
		return ([[Your dirges deaden you to the outside world, reducing all incoming damage by %d.
The damage reduction will increase with your Spellpower.]]):tformat(t.getArmor(self, t))
	end,
}
