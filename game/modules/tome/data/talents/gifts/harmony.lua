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
	name = "Waters of Life",
	type = {"wild-gift/harmony", 1},
	require = gifts_req1,
	points = 5,
	cooldown = 30,
	equilibrium = 10,
	tactical = { HEAL=2 },
	no_energy = true,
	on_pre_use = function(self, t)
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.disease or e.subtype.poison then
				return true
			end
		end
		return false
	end,
	is_heal = true,
	getdur = function(self,t) return math.floor(self:combatTalentLimit(t, 30, 6, 10)) end, -- limit to <30
	action = function(self, t)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.disease or e.subtype.poison then
				nb = nb + 1
			end
		end
		self:heal(self:mindCrit(nb * self:combatTalentStatDamage(t, "wil", 20, 60)), self)
		self:setEffect(self.EFF_WATERS_OF_LIFE, t.getdur(self,t), {})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[The waters of life flow through you, purifying any poisons or diseases currently affecting you.
		For %d turns, all poisons and diseases will heal you instead of damaging you.
		When activated, it also heals you for %d life for each disease or poison you have.
		The healing per disease/poison will increase with your Willpower.]]):
		tformat(t.getdur(self,t), self:combatTalentStatDamage(t, "wil", 20, 60))
	end,
}

newTalent{
	name = "Elemental Harmony",
	type = {"wild-gift/harmony", 2},
	require = gifts_req2,
	points = 5,
	mode = "sustained",
	sustain_equilibrium = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	-- The effect "ELEMENTAL_HARMONY" is defined in data\timed_effects\physical.lua and the duration applied in setDefaultProjector function in data\damagetypes.lua	
	duration = function(self,t) return 5 end, --return math.floor(self:combatTalentScale(t, 6, 10, "log"))  end,
	fireSpeed = function(self, t) return self:combatTalentScale(t, 0.1, 0.3) end,
	coldArmor = function(self, t) return self:combatTalentScale(t, 8, 25, 0.75) end,
	lightningStats = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	acidRegen = function(self, t) return self:combatTalentScale(t, 10, 40, 0.75) end,
	natureRes = function(self, t) return self:combatTalentScale(t, 4, 15, 0.75) end,
	activate = function(self, t)
		return {
			tmpid = self:addTemporaryValue("elemental_harmony", self:getTalentLevel(t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("elemental_harmony", p.tmpid)
		return true
	end,
	info = function(self, t)
		local power = self:getTalentLevel(t)
		local turns = t.duration(self, t)
		local fire = 100 * t.fireSpeed(self, t)
		local cold = t.coldArmor(self, t)
		local lightning = t.lightningStats(self, t)
		local acid = t.acidRegen(self, t)
		local nature = t.natureRes(self, t)
		return ([[Befriend the natural elements that constitute nature. Each time you are hit by one of the elements, you gain a special effect for %d turns. This can only happen every %d turns.
		Fire: +%d%% global speed
		Cold: +%d Armour
		Lightning: +%d to all stats
		Acid: +%0.2f life regen
		Nature: +%d%% to all resists]]):
		tformat(turns, turns, fire, cold, lightning, acid, nature)
	end,
}

newTalent{
	name = "One with Nature",
	type = {"wild-gift/harmony", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 15,
	cooldown = 30,
	fixed_cooldown = true,
	no_energy = true,
	tactical = { BUFF = 1 },
	on_pre_use = function(self, t) return self:hasEffect(self.EFF_INFUSION_COOLDOWN) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 4, "log")) end,
	getCooldown = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5, "log")) end,
	action = function(self, t)
		self:removeEffect(self.EFF_INFUSION_COOLDOWN)
		local tids = {}
		local nb = t.getNb(self, t)
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[1] == "inscriptions/infusions" and self:isTalentCoolingDown(tt) then tids[#tids+1] = tid end
		end
		for i = 1, nb do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = self.talents_cd[tid] - t.getCooldown(self, t)
			if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
		end
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local turns = t.getCooldown(self, t)
		local nb = t.getNb(self, t)
		return ([[Commune with nature, removing the infusion saturation effect and reducing the cooldown of %d infusions by %d turns.]]):
		tformat(nb, turns)
	end,
}

newTalent{
	name = "Healing Nexus",
	type = {"wild-gift/harmony", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 24,
	cooldown = 20,
	range = 10,
	tactical = { DISABLE = 2, HEAL = 0.5 },
	direct_hit = true,
	requires_target = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 2, 5.2)) end, -- Limit < 10
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end, -- To be improved after AI update
	getDur = function(self, t) return math.floor(self:combatTalentLimit(t, 20, 4, 8)) end, -- Limit < 20
	getPct = function(self, t) return self:combatTalentLimit(t, 1, 0.4, 0.7) end, -- Limit < 100% healing transfer
	getEquilibrium = function(self, t) return self:combatTalentScale(t, 5, 10, "log", 0, 3) end, -- slow scaling since this can affect a lot of heals quickly
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local dur, pct, eq = t.getDur(self, t), t.getPct(self, t), t.getEquilibrium(self, t)
		self:setEffect(self.EFF_HEALING_NEXUS_BUFF, dur, {src=self, pct=pct, eq=eq})
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_HEALING_NEXUS, dur, {src=self, pct=pct, eq=eq})
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_acid", {radius=tg.radius})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local pct = t.getPct(self, t)*100
		return ([[A wave of natural energies flow around you in a radius of %d.  All creatures in the area will be affected by the Healing Nexus effect for %d turns.
		On you, this effect causes each heal received to restore %d equilibrium and be %d%% effective.
		On other creatures, all healing is intercepted and redirected to you at %d%% efficiency.
		Only direct healing (not normal regeneration) is affected.]]):
		tformat(self:getTalentRadius(t), t.getDur(self, t), t.getEquilibrium(self, t), 100 + pct, pct)
	end,
}
