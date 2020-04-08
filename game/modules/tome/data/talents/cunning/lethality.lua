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
	name = "Lethality",
	type = {"cunning/lethality", 1},
	mode = "passive",
	points = 5,
	require = cuns_req1,
	critpower = function(self, t) return self:combatTalentScale(t, 7.5, 20, 0.1) end,
	-- called by _M:combatCrit in mod.class.interface.Combat.lua
	getCriticalChance = function(self, t) return self:combatTalentScale(t, 2.3, 7.5, 0.1) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local critchance = t.getCriticalChance(self, t)
		local power = t.critpower(self, t)
		return ([[You have learned to find and hit weak spots. All your strikes have a %0.1f%% greater chance to be critical hits, and your critical hits do %0.1f%% more damage.
		Also, when using knives and throwing knives, you now use your Cunning instead of your Strength for bonus damage.]]):
		tformat(critchance, power)
	end,
}

newTalent{
	name = "Expose Weakness",
	type = {"cunning/lethality", 2},
	points = 5,
	cooldown = 6,
	stamina = 20,
	require = cuns_req2,
	tactical = { ATTACK = {weapon = 2}, BUFF = 1 },
	requires_target = true,
	is_melee = true,
	range = 1,
	no_npc_use = true,  -- Part of the design of this talent is low cooldown/high cost so Rogue classes can get through defenses easily if they can afford it.. NPcs have too much stamina for this model to work
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.1) end,
	getAPR = function(self, t) return math.floor(self:combatTalentScale(t, 4, 10, 0.75)) end,
	getAPRBuff = function(self, t) return self:combatTalentScale(t, 2, 20) + self:combatStatScale("cun", 2, 20) end,
	getPenetration = function(self, t) return 30 end,
	getAccuracy = function(self, t) return self:combatTalentScale(t, 2, 30) + self:combatStatScale("cun", 2, 30) end,
	getDuration = function(self, t) return 3 end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_apr", t.getAPR(self, t))
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local _, x, y = self:canProject(tg, self:getTarget(tg))
		local target = game.level.map(x, y, game.level.map.ACTOR)
		if not target then return nil end
		
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		self:setEffect(self.EFF_EXPOSE_WEAKNESS, t.getDuration(self, t), {apr = t.getAPRBuff(self, t), penetration=t.getPenetration(self, t), accuracy=t.getAccuracy(self, t)})

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Focus on a single target and perform a probing attack to find flaws in its defences, striking with your melee weapon(s) for %d%% damage.
		For %d turns thereafter, you gain %d armor penetration, %d accuracy, and %d%% all damage peneration.
		Learning this technique allows you to permanently gain %d armour penetration with all melee and archery attacks.
		The temporary armor penetration and accuracy bonuses increase with Cunning.]]):
		tformat(100 * damage, duration, t.getAPRBuff(self, t), t.getAccuracy(self, t), t.getPenetration(self, t), t.getAPR(self, t))
	end,
}

newTalent{
	name = "Blade Flurry",
	type = {"cunning/lethality", 3},
	require = cuns_req3,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 30,
	tactical = { BUFF = 2 },
	drain_stamina = 4,
	remove_on_zero = true,
	no_break_stealth = true,
	no_energy = true,
	deactivate_on = {no_combat=true, run=true, rest=true},
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.10, 0.30) end,
	getDamage = function(self, t) return 1 end,
	activate = function(self, t)
		local ret = {
			combat_physspeed = self:addTemporaryValue("combat_physspeed", t.getSpeed(self, t)),
		}
		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1.2, img="blade_flurry_shieldwall"}, shader={type="rotatingshield", noup=2.0, time_factor=500, appearTime=0.8}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1.2, img="blade_flurry_shieldwall"}, shader={type="rotatingshield", noup=1.0, time_factor=500, appearTime=0.8}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.combat_physspeed)
		return true
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
	
		local tg = {type="ball", range=0, radius=1, friendlyfire=false, act_exclude={[target.uid]=true}}
		local tgts = {}
		
		if hitted and not self.turn_procs.blade_flurry then	
			self:project(tg, self.x, self.y, function(px, py, tg, self)	
				local target = game.level.map(px, py, Map.ACTOR)	
				if target and target ~= self then	
					tgts[#tgts+1] = target
				end	
			end)	
		end
		
		if #tgts <= 0 then return end
		local a, id = rng.table(tgts)
		table.remove(tgts, id)
		self.turn_procs.blade_flurry = true
		self:attackTarget(a, nil, t.getDamage(self,t), true)
	
	end,
	info = function(self, t)
		return ([[Become a whirling storm of blades, increasing attack speed by %d%% and causing melee attacks to strike an additional adjacent target other than your primary target for %d%% weapon damage. 
This talent is exhausting to use, draining 4 stamina each turn.]]):tformat(t.getSpeed(self, t)*100, t.getDamage(self,t)*100)
	end,
}

newTalent{
	name = "Snap",
	type = {"cunning/lethality",4},
	require = cuns_req4,
	points = 5,
	stamina = 25,
	cooldown = 30,
	tactical = { BUFF = 1 },
	fixed_cooldown = true,
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return math.max(1, self:getTalentLevelRaw(t)) end,
	speed = "combat",
	action = function(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if not tt.fixed_cooldown then
				if tt.type[2] <= t.getMaxLevel(self, t) and (tt.type[1]:find("^cunning/") or tt.type[1]:find("^technique/")) then
					tids[#tids+1] = tid
				end
			end
		end
		for i = 1, t.getTalentCount(self, t) do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self.changed = true
		return true
	end,
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[Your quick wits allow you to reset the cooldown of up to %d of your combat talents (cunning or technique) of tier %d or less.]]):
		tformat(talentcount, maxlevel)
	end,
}
