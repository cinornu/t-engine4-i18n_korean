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

local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"

local function knives(self)
	local combat = {
		talented = "knife",
		sound = {"actions/melee_hit_squish", pitch=1.2, vol=1.2}, sound_miss = {"actions/melee_miss", pitch=1, vol=1.2},

		damrange = 1.4,
		physspeed = 1,
		dam = 0,
		apr = 0,
		atk = 0,
		physcrit = 0,
		dammod = {dex=0.7, str=0.5},
		melee_project = {},
		special_on_crit = {fct=function(combat, who, target)
			if not self:knowTalent(self.T_PRECISE_AIM) then return end
			if not rng.percent(self:callTalent(self.T_PRECISE_AIM, "getChance")) then return end
			local eff = rng.table{"disarm", "pin", "silence",}
			if not target:canBe(eff) then return end
			local check = who:combatAttack()
			if not who:checkHit(check, target:combatPhysicalResist()) then return end
			if eff == "disarm" then target:setEffect(target.EFF_DISARMED, 2, {})
			elseif eff == "pin" then target:setEffect(target.EFF_PINNED, 2, {})
			elseif eff == "silence" then target:setEffect(target.EFF_SILENCED, 2, {})
			end

		end},
	}
	if self:knowTalent(self.T_THROWING_KNIVES) then
		local t = self:getTalentFromId(self.T_THROWING_KNIVES)
		local t2 = self:getTalentFromId(self.T_PRECISE_AIM)
		combat.dam = 0 + t.getBaseDamage(self, t)
		combat.apr = 0 + t.getBaseApr(self, t)
		combat.physcrit = 0 + t.getBaseCrit(self,t) + t2.getCrit(self,t2)
		combat.crit_power = 0 + t2.getCritPower(self,t2)
		combat.atk = 0 + self:combatAttack()
	end
	if self:knowTalent(self.T_LETHALITY) then 
		combat.dammod = {dex=0.7, cun=0.5}
	end
	return combat
end

local function throw(self, range, dam, x, y, dtype, special, fok)
	local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
	if not eff and not fok then return nil end
	self.turn_procs.quickdraw = true
	local tg = {speed = 10, type="bolt", range=range, selffire=false, display={display='', particle="arrow", particle_args={tile="particles_images/rogue_throwing_knife"} }}
	game:playSoundNear(self, {"actions/knife_throw", vol=0.8})
	local proj = self:projectile(tg, x, y, function(px, py, tg, self)
		local target = game.level.map(px, py, engine.Map.ACTOR)
		if target and target ~= self then
			local hits = table.get(target.turn_procs, "hit_by_throwing_knife") or 0
			if hits and hits >= 5 then return end
			table.set(target.turn_procs, "hit_by_throwing_knife", hits + 1)
			local t = self:getTalentFromId(self.T_THROWING_KNIVES)
			local t2 = self:getTalentFromId(self.T_PRECISE_AIM)
			local combat = t.getKnives(self, t)
			local hit = self:attackTargetWith(target, combat, dtype, dam)
			if hit then
				if special==1 then
					self:callTalent(self.T_VENOMOUS_STRIKE, "applyVenomousEffects", target)
				end
			end

			if combat.sound and hit then game:playSoundNear(self, combat.sound)
			elseif combat.sound_miss then game:playSoundNear(self, combat.sound_miss) end
		end
	end)
	if not fok then
		eff.stacks = eff.stacks - 1
		if eff.stacks <= 0 then self:removeEffect(self.EFF_THROWING_KNIVES) end
	end
	return proj
end

newTalent{
	name = "Throwing Knives",
	type = {"technique/throwing-knives", 1},
	points = 5,
	require = {
		stat = { dex=function(level) return 12 + (level-1) * 2 end },
		level = function(level) return 0 + (level-1) * 4  end,
	},
	on_learn = function(self, t)
		venomous_throw_check(self)
		local max = t.getNb(self, t)
		self:setEffect(self.EFF_THROWING_KNIVES, 1, {stacks=game.party:hasMember(self) and 0 or max, max_stacks=max})
	end,
	on_unlearn = function(self, t)
		venomous_throw_check(self)
		if self:knowTalent(t.id) then
			if self:hasEffect(self.EFF_THROWING_KNIVES) then
				self:setEffect(self.EFF_THROWING_KNIVES, 1, {stacks=0, max_stacks=t.getNb(self, t)})
			end
		else
			self:removeEffect(self.EFF_THROWING_KNIVES)		
		end
	end,
	speed = "throwing",
	proj_speed = 10,
	tactical = { ATTACK = { PHYSICAL = 0.2 } },
	no_break_stealth = true,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 4, 7)) end,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), selffire=false, talent=t, display={display='', particle="arrow", particle_args={tile="shockbolt/object/knife_steel"} }}
	end,
	on_pre_use = function(self, t)
		local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
		if eff and eff.stacks > 0 then return true end
	end,
	getBaseDamage = function(self, t) return self:combatTalentLimit(t, 72, 10, 42) end, -- Scale as dagger damage by material tier (~voratun dagger @ TL 6.5), limit base damage < voratun greatmaul
	getBaseApr = function(self, t) return self:combatTalentScale(t, 3, 10) end,
	getReload = function(self, t) return 2 end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 6, 9.5, 0.25)) end,
	getBaseCrit = function(self, t) return self:combatTalentScale(t, 2, 5) end,
	getKnives = function(self, t) return knives(self) end, -- To prevent upvalue issues
	callbackOnWait = function(self, t)
		local reload, max = t.getReload(self, t), t.getNb(self, t)
		self:setEffect(self.EFF_THROWING_KNIVES, 1, {stacks=reload, max_stacks=max })
	end,
	callbackOnRest = function(self, t)
		local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
		if not eff or (eff and eff.stacks < eff.max_stacks) then return true end
	end,
	callbackOnMove = function(self, t, moved, force, ox, oy)
		if moved and not force and ox and oy and (ox ~= self.x or oy ~= self.y) then
			if self.turn_procs.tkreload then return end
			local reload = math.ceil(self:callTalent(self.T_THROWING_KNIVES, "getReload")/2)
			local max = self:callTalent(self.T_THROWING_KNIVES, "getNb")
			self:setEffect(self.EFF_THROWING_KNIVES, 1, {stacks=reload, max_stacks=max })
			self.turn_procs.tkreload = true
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		local proj = throw(self, tg.range, 1, x, y, nil, nil, nil)
		proj.name = _t"Throwing Knife"

		return true
	end,
	knivesInfo = function(self, t)
		local combat = knives(self)
		local atk = self:combatAttack(combat)
		local talented = combat.talented or "knife"
		local dmg =  self:combatDamage(combat)
		local apr = self:combatAPR(combat)
		local damrange = combat.damrange or 1.1
		local crit = self:combatCrit(combat)
		local crit_mult = (self.combat_critical_power or 0) + 150
		if self:knowTalent(self.T_PRECISE_AIM) then crit_mult = crit_mult + self:callTalent(self.T_PRECISE_AIM, "getCritPower") end
		
		local stat_desc = {}
		-- I18N Stats using display_short_name
		local dammod = self:getDammod(combat.dammod or {})
		for stat, i in pairs(dammod) do
			local name = engine.interface.ActorStats.stats_def[stat].display_short_name:capitalize()
			stat_desc[#stat_desc+1] = ("%d%% %s"):tformat(i * 100, name)
		end
		stat_desc = table.concat(stat_desc, ", ")
		return ([[Range: %d
Net Damage: %d - %d
Accuracy: %d (%s)
APR: %d
Crit Chance: %+d%%
Crit mult: %d%%
Uses Stats: %s
]]):tformat(t.range(self, t), dmg, dmg*damrange, atk, _t(talented), apr, crit, crit_mult, stat_desc)
	end,
	info = function(self, t)
		local nb = t.getNb(self,t)
		local reload = t.getReload(self,t)
		local knives = knives(self)
		local weapon_damage = knives.dam
		local weapon_range = knives.dam * knives.damrange
		local weapon_atk = knives.atk
		local weapon_apr = knives.apr
		local weapon_crit = knives.physcrit
		return ([[Equip a bandolier holding up to %d throwing knives, allowing you to attack from range.  You automatically reload %d knives per turn while resting, or half as many while moving.
		The base power, Accuracy, Armour penetration, and critical strike chance of your knives increase with talent level, and damage is improved with Dagger Mastery.
		Throwing Knives count as melee attacks for the purpose of on-hit effects.
		Effective Throwing Knife Stats:

%s]]):tformat(nb, reload, t.knivesInfo(self, t))
	end,
}

newTalent{
	name = "Fan of Knives",
	type = {"technique/throwing-knives", 2},
	require = techs_dex_req2,
	points = 5,
	tactical = { ATTACKAREA = { PHYSICAL = 2}},
	speed = "throwing",
	proj_speed = 10,
	getDamage = function (self, t) return self:combatTalentLimit(t, 1, 0.4, 0.75) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 8, 20)) end,
	range = 0,
	cooldown = 10,
	stamina = 20,
	radius = function(self, t) return 5 end,
	target = function(self, t) return {type="cone", cone_angle = 75, range=0, stop_block = true, friendlyfire=false, radius=t.radius(self, t), display_line_step=false} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		local count = t.getNb(self,t)
		
		local tgts = {}
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			tgts[#tgts+1] = {act=target, cnt=0}
		end)

		local dir = math.atan2(x-self.x, -y+self.y) - math.pi / 2
		local tile = "shockbolt/object/knife_voratun"
		for i = -6, 6 do
			local dir = dir + math.pi / 28 * i
			game.level.map:particleEmitter(self.x, self.y, 1, "fan_of_knives", {tile=tile, dir=dir, radius=tg.radius})
		end

		local tgt_cnt = #tgts
		if tgt_cnt > 0 then
			local tgt_max = math.min(5, math.ceil(count/tgt_cnt))
			while count > 0 and #tgts > 0 do
				local tgt, id = rng.table(tgts)
				if tgt then
					local proj = throw(self, self:getTalentRadius(t), t.getDamage(self,t), tgt.act.x, tgt.act.y, nil, nil, 1)
					proj.name = _t"Fan of Knives"
					tgt.cnt = tgt.cnt + 1
					print(("Fan of Knives #%d: target:%s (%s, %s) = %d"):format(count, tgt.act.name, tgt.act.x, tgt.act.y, tgt.cnt))
					count = count - 1
					if tgt.cnt >= tgt_max then table.remove(tgts, id) end
				end
			end
			print(count, "knives untargeted.")
		end

		return true
	end,
	info = function(self, t)
		return ([[You keep a special stash of %d throwing knives in your bandolier, which you can throw all at once at enemies within a radius %d cone, for %d%% damage each.
		Each target can be hit up to 5 times, if the number of knives exceeds the number of enemies.  Creatures block knives from hitting targets behind them.]]):
		tformat(t.getNb(self,t), self:getTalentRadius(t), t.getDamage(self, t)*100)
	end,
}

newTalent{
	name = "Precise Aim",
	type = {"technique/throwing-knives", 3},
	require = techs_dex_req3,
	points = 5,
	mode = "passive",
	range = 0,
	getCrit = function(self, t) return self:combatTalentScale(t, 3, 15) end,
	getCritPower = function(self, t) return self:combatTalentScale(t, 7, 20) end,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 20, 45) end,
	info = function(self, t)
		local crit = t.getCrit(self,t)
		local power = t.getCritPower(self,t)
		local chance = t.getChance(self,t)
		return ([[You are able to target your throwing knives with pinpoint accuracy, increasing their critical strike chance by %d%% and critical strike damage by %d%%. 
In addition, your critical strikes with throwing knives have a %d%% chance to randomly disable your target, possibly disarming, silencing or pinning them for 2 turns.]])
		:tformat(crit, power, chance)
	end,
}

newTalent{
	name = "Quickdraw",
	type = {"technique/throwing-knives", 4},
	require = techs_dex_req4,
	mode = "sustained",
	points = 5,
	cooldown = 50,
	sustain_stamina = 30,
	tactical = { BUFF = 2 },
	range = 7,
	getSpeed = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.35) end, -- Limit < +100% attack speed
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 10, 25) end,
	activate = function(self, t)
		local ret = {
		}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not hitted or self.turn_procs.quickdraw or core.fov.distance(self.x, self.y, target.x, target.y) > 1 or not rng.percent(t.getChance(self,t)) then return nil end
		
		local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
		if not eff or eff.stacks <= 0 then return end
		
		local tg = {type="ball", range=0, radius=7, friendlyfire=false, selffire=false }
		local tgts = {}
		
		self:project(tg, self.x, self.y, function(px, py, tg, self)	
			local target = game.level.map(px, py, Map.ACTOR)	
			if target and self:canSee(target) then
				tgts[#tgts+1] = target
			end	
		end)
		
		if #tgts <= 0 then return nil end
		local a, id = rng.table(tgts)
		local proj = throw(self, self:getTalentRange(t), 1, a.x, a.y, nil, nil, nil)
		proj.name = _t"Quickdraw Knife"
		self.turn_procs.quickdraw = true
	end,
	info = function(self, t)
		local speed = t.getSpeed(self, t)*100
		local chance = t.getChance(self, t)
		return ([[You can throw knives with lightning speed, increasing your attack speed with them by %d%% and giving you a %d%% chance when striking a target in melee to throw a knife at a random foe within 7 tiles for 100%% damage. 
		This bonus attack can only trigger once per turn, and does not trigger from throwing knife attacks.]]):
		tformat(speed, chance)
	end,
}

newTalent{
	name = "Venomous Throw",
	type = {"technique/other", 1},
	points = 1,
	random_ego = "attack",
	cooldown = 8,
	stamina = 14,
	speed = "throwing",
	proj_speed = 10,
	tactical = { ATTACK = { NATURE = 2 } },
	no_break_stealth = true,
	range = function(self, t) 
		local t = self:getTalentFromId(self.T_THROWING_KNIVES)
		return self:getTalentRange(t) 
	end,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), selffire=false, talent=t, display={display='', particle="arrow", particle_args={tile="shockbolt/object/knife_steel"} }}
	end,
	on_pre_use = function(self, t)
		local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
		if eff and eff.stacks > 0 then return true end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		
		local t2 = self:getTalentFromId(self.T_VENOMOUS_STRIKE)
		local dam = t2.getDamage(self,t2)

		local proj = throw(self, self:getTalentRange(t), dam, x, y, DamageType.NATURE, 1, nil)
		proj.name = _t"Venomous Throw"
		self.talents_cd[self.T_VENOMOUS_STRIKE] = 8

		return true
	end,
	info = function(self, t)
		local t = self:getTalentFromId(self.T_VENOMOUS_STRIKE)
		local dam = 100 * t.getDamage(self,t)
		local desc = t.effectsDescription(self, t)
		return ([[Throw a knife coated with venom, doing %d%% damage as nature and inflicting additional effects based on your active vile poisons (as per the Venomous Strike talent):
		
		%s
		Using this talent puts your Venomous Strike talent on cooldown.]]):
		tformat(dam, desc)
	end,
}