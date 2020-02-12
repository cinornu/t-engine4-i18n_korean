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

newInscription = function(t)
	-- Warning, up that if more than 5 inscriptions are ever allowed
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.short_name = tt.name:upper():gsub("[ ]", "_").."_"..i
		tt.display_name = function(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.item_name then
				local n = tstring{t.name, " ["}
				n:merge(data.item_name)
				n:add("]")
				return n
			else
				return t.name
			end
		end
		if tt.type[1] == "inscriptions/infusions" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_INFUSION_COOLDOWN) end
		elseif tt.type[1] == "inscriptions/runes" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_RUNE_COOLDOWN) end
		elseif tt.type[1] == "inscriptions/taints" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_TAINT_COOLDOWN) end
		end
		tt.auto_use_warning = _t"- will only auto use when no saturation effect exists"
		tt.cooldown = function(self, t)
			local data = self:getInscriptionData(t.short_name)
			return data.cooldown
		end
		tt.old_info = tt.info
		tt.info = function(self, t)
			local ret = t.old_info(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\nIts effects scale with your %s stat."):tformat(self.stats_def[data.use_stat].name)
			end
			return ret
		end
		if not tt.image then
			tt.image = "talents/"..(t.short_name or t.name):lower():gsub("[^a-z0-9_]", "_")..".png"
		end
		tt.no_unlearn_last = true
		tt.is_inscription = true
		newTalent(tt)
	end
end

-----------------------------------------------------------------------
-- Infusions
-----------------------------------------------------------------------
newInscription{
	name = "Infusion: Regeneration",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { HEAL = 2 },
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	no_break_stealth = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_REGENERATION, data.dur, {power=(data.heal + data.inc_stat) / data.dur})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the infusion to heal yourself for %d life over %d turns.]]):tformat(data.heal + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[heal %d; %d cd]]):tformat(data.heal + data.inc_stat, data.cooldown)
	end,
}

newInscription{
	name = "Infusion: Healing",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { HEAL = 1,
		CURE = function(self, t, target)
			local cut, poison, disease = 0, 0, 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.status == "detrimental" then
					if e.subtype.wound then cut = 1 end
					if e.subtype.poison then poison = 1 end
					if e.subtype.disease then disease = 1 end
				end
			end
			return cut + poison + disease
		end
	},
	is_heal = true,
	no_energy = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:attr("allow_on_heal", 1)
		self:attr("disable_ancestral_life", 1)
		self:heal(data.heal + data.inc_stat, t)
		self:attr("disable_ancestral_life", -1)
		self:attr("allow_on_heal", -1)

		self:removeEffectsFilter(function(e) return e.subtype.wound end, 1)
		self:removeEffectsFilter(function(e) return e.subtype.poison end, 1)
		self:removeEffectsFilter(function(e) return e.subtype.disease end, 1)

		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
		end
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the infusion to instantly heal yourself for %d then cleanse 1 wound, poison, and disease effect.]]):tformat(data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[heal %d; cd %d]]):tformat(data.heal + data.inc_stat, data.cooldown)
	end,
}

newInscription{
	name = "Infusion: Wild",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = {
		DEFEND = 1,
		CURE = function(self, t, target)
			local data = self:getInscriptionData(t.short_name)
			return #self:effectsFilter({types=data.what, status="detrimental"})
		end
	},
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)

		local target = self
		local effs = {}
		local force = {}
		local removed = 0

		removed = target:removeEffectsFilter({types=data.what, subtype={["cross tier"] = true}, status="detrimental"})
		for k,v in pairs(data.what) do
			removed = removed + target:removeEffectsFilter({type=k, status="detrimental"}, 1)
		end

		if removed > 0 then
			game.logSeen(self, "%s is cured!", self:getName():capitalize())
		end
		self:setEffect(self.EFF_PAIN_SUPPRESSION, data.dur, {power=data.power + data.inc_stat})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concatNice(table.ts(table.keys(data.what)), ", ", _t" and ")

		return ([[Activate the infusion to cure yourself of one random %s effect and reduce all damage taken by %d%% for %d turns.
Also removes cross-tier effects of the affected types for free.]]):tformat(what, data.power+data.inc_stat, data.dur)
	end,
	short_info = function(self, t)	
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.ts(table.keys(data.what)), ", ")
		return ([[res %d%%; %s; dur %d; cd %d]]):tformat(data.power + data.inc_stat, what, data.dur, data.cooldown)
	end,
}

newInscription{
	name = "Infusion: Primal", image = "talents/infusion__wild.png",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = {DEFEND = 2, CURE = 2},
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_PRIMAL_ATTUNEMENT, data.dur, {power=data.power + data.inc_stat*10, reduce=math.floor(data.reduce + data.inc_stat * 2)})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the infusion to heal for %d%% of all damage taken (calculated before resistances) and reduce the duration of a random debuff by %d each turn for %d turns.]]):
			tformat(data.power+data.inc_stat*10, math.floor((data.reduce or 0) + data.inc_stat * 2), data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[affinity %d%%; reduction %d; dur %d; cd %d]]):tformat(data.power + data.inc_stat*10, math.floor((data.reduce or 0) + data.inc_stat * 2), data.dur, data.cooldown )
	end,
}

newInscription{
	name = "Infusion: Movement",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = { ESCAPE = 1, CLOSEIN = 1 },
	on_pre_use = function(self, t) return not self:attr("never_move") end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		game:onTickEnd(function() self:setEffect(self.EFF_WILD_SPEED, 1, {power=data.speed + data.inc_stat}) end)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the infusion to increase movement speed by %d%% for 1 game turn.
		You gain 100%% stun, daze, and pin immunity during the effect.
		Any actions other than movement will cancel the effect.
		Note: since you will be moving very fast, game turns will pass very slowly.]]):tformat(data.speed + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[speed %d%%; cd %d]]):tformat(data.speed + data.inc_stat, data.cooldown)
	end,
}

newInscription{
	name = "Infusion: Heroism",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = { DEFEND = 1 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local bonus = 1 + (1 - self.life / self.max_life)
		self:setEffect(self.EFF_HEROISM, math.floor(data.dur * bonus), {die_at=(data.die_at + data.inc_stat * 30) * bonus})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local bonus = 1 + (1 - self.life / self.max_life)
		local bonus1 = (data.die_at + data.inc_stat * 30) * bonus
		local bonus2 = math.floor(data.dur * bonus)
		return ([[Activate the infusion to endure even the most grievous of wounds for %d turns.
		While Heroism is active, you will only die when reaching -%d life.
		The duration and life will increase by 1%% for every 1%% life you have lost (currently %d life, %d duration)
		If your life is below 0 when this effect wears off it will be set to 1.]]):tformat(data.dur, data.die_at + data.inc_stat * 30, bonus1, bonus2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[die at -%d; dur %d; cd %d]]):tformat(data.die_at + data.inc_stat * 30, data.dur, data.cooldown)
	end,
}

newInscription{
	name = "Infusion: Wild Growth",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { ATTACKAREA = { PHYSICAL = 1, NATURE = 1 }, DEFEND = 1, DISABLE = {pin = 2}},
	range = 0,
	radius = 5,
	direct_hit = true,
	no_energy = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire = false, talent=t}
	end,
	getDamage = function(self, t) return 10 + self:combatMindpower() * 3.6 end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = t.getDamage(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(tx, ty)
			DamageType:get(DamageType.ENTANGLE).projector(self, tx, ty, DamageType.ENTANGLE, dam)
		end)
		self:setEffect(self.EFF_THORNY_SKIN, data.dur, {hard=data.hard or 30, ac=data.armor or 50})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local damage = t.getDamage(self, t)
		return ([[Causes thick vines to spring from the ground and entangle all targets within %d squares for %d turns, pinning them in place for 5 turns and dealing %0.2f physical damage and %0.2f nature damage.
		The vines also grow all around you, increasing your armour by %d and armour hardiness by %d.]]):
		tformat(self:getTalentRadius(t), data.dur, damDesc(self, DamageType.PHYSICAL, damage)/3, damDesc(self, DamageType.NATURE, 2*damage)/3, data.armor or 50, data.hard or 30)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[rad %d; dur %d;]]):tformat(self:getTalentRadius(t), data.dur)
	end,
}

-----------------------------------------------------------------------
-- Runes
-----------------------------------------------------------------------

local function attack_rune(self, btid)
	for tid, lev in pairs(self.talents) do
		if tid ~= btid and self.talents_def[tid].is_attack_rune and not self.talents_cd[tid] then
			self.talents_cd[tid] = 1
		end
	end
end

newInscription{
	name = "Rune: Teleportation",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	no_break_stealth = true,
	tactical = { ESCAPE = 3 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(self.x, self.y, data.range + data.inc_stat, 15)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to teleport randomly in a range of %d with a minimum range of 15.]]):tformat(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[range %d; cd %d]]):tformat(data.range + data.inc_stat, data.cooldown)
	end,
}

newInscription{
	name = "Rune: Shielding",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	allow_autocast = true,
	no_energy = true,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t)
		return not self:hasEffect(self.EFF_DAMAGE_SHIELD)
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_DAMAGE_SHIELD, data.dur, {power=data.power + data.inc_stat})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to create a protective shield absorbing at most %d damage for %d turns.]]):tformat((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[absorb %d; dur %d; cd %d]]):tformat((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur, data.cooldown)
	end,
}

newInscription{
	name = "Rune: Reflection Shield",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	allow_autocast = true,
	no_energy = true,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t)
		return not self:hasEffect(self.EFF_DAMAGE_SHIELD)
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
		self:setEffect(self.EFF_DAMAGE_SHIELD, data.dur or 5, {power=power, reflect=100})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
		return ([[Activate the rune to create a protective shield absorbing and reflecting at most %d damage for %d turns.]]):tformat(power, data.dur or 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
		return ([[absorb and reflect %d; dur %d; cd %d]]):tformat(power, data.dur or 5, data.cd)
	end,
}

newInscription{
	name = "Rune: Biting Gale",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { COLD = 1 }, DISABLE = { stun = 1 } },
	requires_target = true,
	radius = 6,
	range = 0,
	target = function(self, t)
		return {type="cone", cone_angle=25, radius = self:getTalentRadius(t), range=self:getTalentRange(t), talent=t, display={particle="bolt_ice", trail="icetrail"}}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local damage = data.power + data.inc_stat
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			
			DamageType:get(DamageType.COLD).projector(self, tx, ty, DamageType.COLD, damage)
			target:setEffect(target.EFF_WET, 5, {})
			if target:canBe("stun") then
				target:setEffect(target.EFF_FROZEN, data.dur, {hp=damage*2})
			end
		end, data.power + data.inc_stat, {type="freeze"})
		game:playSoundNear(self, "talents/ice")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to direct a cone of chilling stormwind doing %0.2f cold damage.
			The storm will soak enemies hit reducing their resistance to stuns by 50%% then attempt to freeze them for %d turns.
			These effects can be resisted but not saved against.]]):
			tformat(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[damage %d; dur %d; cd %d]]):tformat(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur, data.cooldown)
	end,
}

newInscription{
	name = "Rune: Acid Wave",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = {
		ATTACKAREA = { ACID = 1 },
		DISABLE = { disarm = 1 }
	},
	requires_target = true,
	direct_hit = true,
	radius = 6,
	range = 0,
	target = function(self, t)
		return {type="cone", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, cone_angle=25, talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end

			if target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, data.dur, {})
			end
			DamageType:get(DamageType.ACID).projector(self, tx, ty, DamageType.ACID, data.power + data.inc_stat)
		end)

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_acid", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		  local data = self:getInscriptionData(t.short_name)
		  return ([[Activate the rune to unleash a cone dealing %0.2f acid damage.
			The corrosive acid will also disarm enemies struck for %d turns.
			This effect can be resisted but not saved against.]]):
			tformat(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3)
	   end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local pow = data.power
		return ([[damage %d; dur %d; cd %d]]):tformat(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, data.cooldown)
	end,
}

-- Incredibly specific to one resource top, a generalization applying to the other arcane resources is worth considering
-- This serves as one of the primary counters to mana drain effects since it lets you recover from hitting 0
newInscription{
	name = "Rune: Manasurge",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	use_only_arcane = 1,
	no_break_stealth = true,
	tactical = { MANA = 1 },
	on_pre_use = function(self, t)
		return self:knowTalent(self.T_MANA_POOL) and not self:hasEffect(self.EFF_MANASURGE)
	end,
	on_learn = function(self, t)
		self.mana_regen_on_rest = (self.mana_regen_on_rest or 0) + 0.5
	end,
	on_unlearn = function(self, t)
		self.mana_regen_on_rest = (self.mana_regen_on_rest or 0) - 0.5
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:incMana((data.mana + data.inc_stat) / 20)
		if self.mana_regen > 0 then
			self:setEffect(self.EFF_MANASURGE, data.dur, {power=self.mana_regen * (data.mana + data.inc_stat) / 100})
		else
			if self.mana_regen < 0 then
				game.logPlayer(self, "Your negative mana regeneration rate is unaffected by the rune.")
			else
				game.logPlayer(self, "Your nonexistant mana regeneration rate is unaffected by the rune.")
			end
		end
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local total = (data.mana + data.inc_stat) / 100 * (self.mana_regen or 0) * 10
		return ([[Activate the rune to unleash a manasurge upon yourself, increasing mana regeneration by %d%% for %d turns (%d total) and instantly restoring %d mana.
			Also when resting your mana will regenerate at 0.5 per turn.]]):tformat(data.mana + data.inc_stat, data.dur, total, (data.mana + data.inc_stat) / 20)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[regen %d%% over %d turns; mana %d; cd %d]]):tformat(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20, data.cooldown)
	end,
}

-- Upgrade me
newInscription{
	name = "Rune of the Rift",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	tactical = { DISABLE = 2, ATTACK = { TEMPORAL = 1 } },
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	range = 6,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return 150 + self:getWil() * 4 end,
	getDuration = function(self, t) return 4 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end

		if target:attr("timetravel_immune") then
			game.logSeen(target, "%s is immune!", target:getName():capitalize())
			return true
		end

		local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
		if not hit then game.logSeen(target, "%s resists!", target:getName():capitalize()) return true end

		self:project(tg, x, y, DamageType.TEMPORAL, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(x, y, 1, "temporal_thrust")
		game:playSoundNear(self, "talents/arcane")
		self:incParadox(-25)
		if target.dead or target.player then return true end
		target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		
	-- Placeholder for the actor
		local oe = game.level.map(x, y, Map.TERRAIN+1)
		if (oe and oe:attr("temporary")) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then game.logPlayer(self, "Something has prevented the timetravel.") return true end
		local e = mod.class.Object.new{
			old_feat = oe, type = "temporal", subtype = "instability",
			name = _t"temporal instability",
			display = '&', color=colors.LIGHT_BLUE,
			temporary = t.getDuration(self, t),
			canAct = false,
			target = target,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				-- return the rifted actor
				if self.temporary <= 0 then
					-- remove ourselves
					if self.old_feat then game.level.map(self.target.x, self.target.y, engine.Map.TERRAIN+1, self.old_feat)
					else game.level.map:remove(self.target.x, self.target.y, engine.Map.TERRAIN+1) end
					game.nicer_tiles:updateAround(game.level, self.target.x, self.target.y)
					game.level:removeEntity(self)
					game.level.map:removeParticleEmitter(self.particles)
					
					-- return the actor and reset their values
					local mx, my = util.findFreeGrid(self.target.x, self.target.y, 20, true, {[engine.Map.ACTOR]=true})
					local old_levelup = self.target.forceLevelup
					local old_check = self.target.check
					self.target.forceLevelup = function() end
					self.target.check = function() end
					game.zone:addEntity(game.level, self.target, "actor", mx, my)
					self.target.forceLevelup = old_levelup
					self.target.check = old_check
				end
			end,
			summoner_gain_exp = true, summoner = self,
		}
		
		-- Remove the target
		game.logSeen(target, "%s has moved forward in time!", target:getName():capitalize())
		game.level:removeEntity(target, true)
		
		-- add the time skip object to the map
		local particle = Particles.new("wormhole", 1, {image="shockbolt/terrain/temporal_instability_yellow", speed=1})
		particle.zdepth = 6
		e.particles = game.level.map:addParticleEmitter(particle, x, y)
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN+1, e)
		game.level.map:updateMap(x, y)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Inflicts %0.2f temporal damage.  If your target survives, it will be sent %d turns into the future.
		It will also lower your paradox by 25 (if you have any).
		Note that messing with the spacetime continuum may have unforeseen consequences.]]):tformat(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
	short_info = function(self, t)
		return ("%0.2f temporal damage, removed from time %d turns"):tformat(t.getDamage(self, t), t.getDuration(self, t))
	end,
}

-- New name for the merged Phase Doors
-- Fix requiring vision
newInscription{
	name = "Rune: Blink",
	image = "talents/rune__controlled_phase_door.png",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = {  ESCAPE = 1, CLOSEIN = 1 },
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return math.floor(data.range + data.inc_stat)
	end,
	target = function(self, t) return {type="hit", nolock=true, pass_terrain=false, nowarning=true, range=self:getTalentRange(t), 
		grid_params = {want_range = (not self.ai_target.actor or self.ai_state.tactic == "escape") and 6 or 1	} } end,
	getDur = function(self, t) return 3 end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x then return end
		if not self:hasLOS(x, y) then return end

		local _ _, x, y = self:canProject(tg, x, y)
		local rad = 0
		
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(x, y, rad)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")

		self:setEffect(self.EFF_OUT_OF_PHASE, data.dur or 3, {
			defense = data.power + data.inc_stat * 3,
			resists = data.power + data.inc_stat * 3,
			effect_reduction = data.power + data.inc_stat * 3,
		})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[Activate the rune to teleport up to %d spaces within line of sight.  Afterwards you stay out of phase for %d turns. In this state all new negative status effects duration is reduced by %d%%, your defense is increased by %d and all your resistances by %d%%.]]):
			tformat(data.range + data.inc_stat, t.getDur(self, t), power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[range %d; phase %d; cd %d]]):tformat(self:getTalentRange(t), power, data.cooldown )
	end,
}

-- Invisibility updated to have combat value and more escape potential
newInscription{
	name = "Rune: Ethereal",
	image = "talents/rune__invisibility.png",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_energy = true,
	tactical = { ESCAPE = 1 },
	getDur = function(self, t) return 5 end,
	getResistance = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.resist + data.inc_stat * 2
	end,
	getReduction = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.reduction
	end,
	getPower = function(self, t) 
		local data = self:getInscriptionData(t.short_name)
		return data.power + data.inc_stat * 2
	end,
	getMove = function(self, t) 
		local data = self:getInscriptionData(t.short_name)
		return data.move + data.inc_stat
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_ETHEREAL, t.getDur(self, t), {power=t.getPower(self, t), reduction=t.getReduction(self, t), resist=t.getResistance(self, t), move=t.getMove(self, t)})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to become ethereal for %d turns.
		While ethereal all damage you deal is reduced by %d%%, you gain %d%% all resistance, you move %d%% faster, and you are invisible (power %d).]]):
			tformat(t.getDur(self, t),t.getReduction(self, t) * 100, t.getResistance(self, t), t.getMove(self, t), t.getPower(self, t))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[power %d; resist %d%%; move %d%%; dur %d; cd %d]]):tformat(t.getPower(self, t), t.getResistance(self, t), t.getMove(self, t), t.getDur(self, t), data.cooldown)
	end,
}

-- Lightning Rune replacement, concept partially kept
-- Numbers on this must be done carefully
newInscription{
	name = "Rune: Stormshield",
	image = "talents/rune__lightning.png",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_energy = true,
	tactical = { DEFEND = 1 },
	getDur = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.dur
	end,
	getThreshold = function(self, t) 
		local data = self:getInscriptionData(t.short_name)
		return data.threshold
	end,
	getBlocks = function(self, t) 
		local data = self:getInscriptionData(t.short_name)
		return data.blocks + data.inc_stat
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_STORMSHIELD, t.getDur(self, t), {threshold=t.getThreshold(self, t), blocks=t.getBlocks(self, t)})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to summon a protective storm around you for %d turns.
			While active the storm will completely block all damage over %d up to %d times.]])
				:tformat(t.getDur(self, t), t.getThreshold(self, t), t.getBlocks(self, t) )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[threshold %d; blocks %d; dur %d; cd %d]]):tformat(t.getThreshold(self, t), t.getBlocks(self, t), t.getDur(self, t), data.cooldown  )
	end,
}

-- Fixedart generated with a random ward set
newInscription{
	name = "Rune: Prismatic",
	image = "talents/ward.png", -- re-used icon
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_break_stealth = true,
	tactical = { DEFEND = 3,},
	getDur = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.dur
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_PRISMATIC_SHIELD, t.getDur(self, t), {wards = table.clone(data.wards)})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = ""
		for k,v in pairs(data.wards) do
			str = str .. ", " .. v .. " " .. _t(k:lower())
		end
		str = string.sub(str, 2)
		return ([[Activate the rune to create a shield for %d turns blocking several instances of damage of the following types:%s]]) -- color me
				:tformat(t.getDur(self, t), str)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = table.concat(table.ts(table.lower(table.keys(data.wards))), ", ")
		return ([[%d turns; %s]]):tformat(t.getDur(self, t), str:lower() )
	end,
}

-- Fixedart
newInscription{
	name = "Rune: Mirror Image",
	type = {"inscriptions/runes", 1},
	image = "talents/phase_shift.png",  -- re-used icon
	points = 1,
	is_spell = true,
	no_break_stealth = true,
	tactical = { DEFEND = 3,},
	getDur = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.dur
	end,
	getInheritance = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.inheritance
	end,
	getInheritedResist = function(self, t)
		local res = {}
		for k,v in pairs(self.resists) do
			res[k] = (t.getInheritance(self, t) * (self.resists[k]) or 0)
		end
		return res
	end,
	action = function(self, t)
			if not self:canBe("summon") then game.logPlayer(self, "You cannot summon; you are suppressed!") return end

			-- Find all actors in radius 10 and add them to a table
			local tg = {type="ball", radius=self.sight}
			local grids = self:project(tg, self.x, self.y, function() end)
			local tgts = {}
			for x, ys in pairs(grids) do for y, _ in pairs(ys) do
				local target = game.level.map(x, y, Map.ACTOR)
				if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
			end end

			for _ = 1,3 do
				local target = rng.tableRemove(tgts)
				if target then
					local tx, ty = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
					if tx then
						local Talents = require "engine.interface.ActorTalents"
						local NPC = require "mod.class.NPC"
						local caster = self
						local image = NPC.new{
							name = _t"Mirror Image",
							type = "image", subtype = "image",
							ai = "summoned", ai_real = nil, ai_state = { talent_in=1, }, ai_target = {actor=nil},
							desc = _t"A blurred image.",
							image = caster.image,
							add_mos = caster.add_mos, -- this is horribly wrong isn't it?  seems to work though
							shader = "shadow_simulacrum", shader_args = { color = {0.0, 0.4, 0.8}, base = 0.6, time_factor = 1500 },
							exp_worth=0,
							max_life = caster.max_life,
							life = caster.max_life, -- We don't want to make this only useful before you take damage
							combat_armor_hardiness = caster:combatArmorHardiness(),
							combat_def = caster:combatDefense(),
							combat_armor = caster:combatArmor(),
							size_category = caster.size_category,
							resists = t.getInheritedResist(self, t),
							rank = 1,
							life_rating = 0,
							cant_be_moved = 1,
							never_move = 1,
							never_anger = true,
							resolvers.talents{
								[Talents.T_TAUNT]=1, -- Add the talent so the player can see it even though we cast it manually
							},
							on_act = function(self) -- avoid any interaction with .. uh, anything
								self:forceUseTalent(self.T_TAUNT, {ignore_cd=true, no_talent_fail = true})
							end,
							faction = caster.faction,
							summoner = caster,
							summon_time=t.getDur(self, t),
							no_breath = 1,
							remove_from_party_on_death = true,
						}

						image:resolve()
						game.zone:addEntity(game.level, image, "actor", tx, ty)
						game.party:addMember(image, {
							control=false,
							type="summon",
							title=_t"Summon",
							temporary_level = true,
							orders = {},
						})

						image:forceUseTalent(image.T_TAUNT, {ignore_cd=true, no_talent_fail = true})
					end
				end
			end

		return true
	end,
	info = function(self, t)
		return ([[Activate the rune to create up to 3 images of yourself that taunt nearby enemies each turn and immediately after being summoned.
			Only one image can be created per enemy in radius 10 with the first being created near the closest enemy.
			Images inherit all of your life, resistance, armor, defense, and armor hardiness.]])
				:tformat(t.getInheritance(self, t)*100 )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[dur %d; cd %d]]):tformat(t.getDur(self, t), data.cooldown)
	end
}

-- Counter to mass multitype debuff spam
-- This is the counterpart to Wild but scales differently, acknowledging the fact that triple type cleanse becomes better as the game progresses
newInscription{
	name = "Rune: Shatter Afflictions",
	image = "talents/warp_mine_away.png", -- re-used icon
	type = {"inscriptions/runes", 1},
	points = 1,
	tactical = { CURE = function(self, t, target)
		local types = 0
		types = types + #self:effectsFilter({status="detrimental", type="physical"}, 1)
		types = types + #self:effectsFilter({status="detrimental", type="magical"}, 1)
		types = types + #self:effectsFilter({status="detrimental", type="mental"}, 1)
		return types
	end
	},
	is_spell = true,
	no_energy = true,
	getShield = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.shield + data.inc_stat
	end,
	on_pre_use = function(self, t)
		if next(self:effectsFilter({type="physical", status="detrimental"}, 1)) then return true end
		if next(self:effectsFilter({type="magical", status="detrimental"}, 1)) then return true end
		if next(self:effectsFilter({type="mental", status="detrimental"}, 1)) then return true end
		if next(self:effectsFilter({subtype={["cross tier"] = true}, status="detrimental"}, 3)) then return true end
		return false
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		
		local crosstiers = self:removeEffectsFilter({subtype={["cross tier"] = true}, status="detrimental"}, 3)
		local cleansed = 0
		cleansed = cleansed + self:removeEffectsFilter({type="physical", status="detrimental"}, 1)
		cleansed = cleansed + self:removeEffectsFilter({type="magical", status="detrimental"}, 1)
		cleansed = cleansed + self:removeEffectsFilter({type="mental", status="detrimental"}, 1)

		if crosstiers == 0 and cleansed == 0 then return nil end

		if cleansed > 0 then
			self:setEffect(self.EFF_DAMAGE_SHIELD, 3, {power=(data.shield + data.inc_stat) * cleansed})
		else
			game:onTickEnd(function() self:alterTalentCoolingdown(t.id, -math.floor((self.talents_cd[t.id] or 0) * 0.75)) end)
		end

		return true
	end,
	info = function(self, t)
		return ([[Activate the rune to instantly dissipate the energy of your ailments, cleansing all cross tier effects and 1 physical, mental, and magical effect.
		You use the dissipated energy to create a shield lasting 3 turns and blocking %d damage per debuff cleansed (not counting cross-tier ones).
		If there were only cross-tier effects to cleanse, no shield is created and the rune goes on a 75%% reduced cooldown.]])
		:tformat(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[absorb %d; cd %d]]):tformat(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100, data.cooldown)
	end,
}

newInscription{
	name = "Rune: Dissipation",
	image = "talents/disperse_magic.png",  -- re-used icon
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	range = 10,
	direct_hit = true,
	target = function(self, t) return {default_target=self, type="hit", nowarning=true, range=self:getTalentRange(t)} end,
	tactical = {
		DISABLE = function(self, t, aitarget)
			local nb = 0
			for tid, act in pairs(aitarget.sustain_talents) do
				if act then
					local talent = aitarget:getTalentFromId(tid)
					if talent.is_spell then nb = nb + 1 end
				end
			end
			return nb^0.5
	end},
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not (x and y) or not target or not self:canProject(tg, x, y) then return nil end

		if self:reactionToward(target) < 0 then
			target:removeSustainsFilter(function(o)
				if o.type == "magical" or o.is_spell then
					if o.status and o.status == "detrimental" then return false end
					return true
				end
				return false
			end,
			8)
		else
			target:removeEffectsFilter({type="magical", status="detrimental"}, 999)
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to remove 8 beneficial magical sustains from an enemy target or all magical debuffs from you.]]):
		tformat()
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ ]]):tformat()
	end,
}


-----------------------------------------------------------------------
-- Taints:
-----------------------------------------------------------------------
newInscription{
	name = "Taint: Devourer",
	type = {"inscriptions/taints", 1},
	points = 1,
	is_spell = true,
	tactical = {DISABLE = function(self, t, target)
			if target then
				local effs, data, disable = t.getEffects(self, t, target)
				return math.min(data.effects, disable)/2
			end
		end,
		HEAL = function(self, t, target)
			if target then
				local effs, data, disable = t.getEffects(self, t, target)
				return math.min(data.effects, #effs)/2
			end
		end
	},
	getEffects = function(self, t, target)
		local last_vals = self.turn_procs[t.id]
		if last_vals then return last_vals.effs, last_vals.data, last_vals.disable end
		local effs, disable, data = {}, 0, self:getInscriptionData(t.short_name)

		-- Go through all magical and physical effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.type == "magical" or e.type == "physical" then
				effs[#effs+1] = {"effect", eff_id}
				disable = disable + (e.status == "beneficial" and 1 or -1)
			end
		end

		-- Go through all sustained spells
		for tid, act in pairs(target.sustain_talents) do
			if act then
				effs[#effs+1] = {"talent", tid}
				disable = disable + 1
			end
		end
		self.turn_procs[t.id] = {effs=effs, data=data, disable=disable}
		return effs, data, disable
	end,
	requires_target = true,
	target = function(self, t) return  {type="hit", range=self:getTalentRange(t), talent=t} end,
	direct_hit = true,
	no_energy = true,
	range = 5,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local effs, data = t.getEffects(self, t, target)
			local nb = data.effects
			for i = 1, nb do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					target:removeEffect(eff[2])
				else
					target:forceUseTalent(eff[2], {ignore_energy=true})
				end
				self:attr("allow_on_heal", 1)
				self:heal(data.heal + data.inc_stat, t)
				self:attr("allow_on_heal", -1)
				if core.shader.active(4) then
					self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
					self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
				end
			end

			game.level.map:particleEmitter(px, py, 1, "shadow_zone")
		end)
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the taint on a foe, removing up to %d magical or physical effects or sustains from it and healing you for %d for each effect.]]):tformat(data.effects, data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d effects / %d heal]]):tformat(data.effects, data.heal + data.inc_stat)
	end,
}

-- Counter to mass minor physical debuff spam
newInscription{
	name = "Taint: Purging",
	image = "talents/willful_tormenter.png", -- re-used icon
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_break_stealth = true,
	tactical = { CURE = 2 },
	getDur = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.dur + data.inc_stat
	end,
	action = function(self, t)
		self:setEffect(self.EFF_PURGING, t.getDur(self, t), {})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the taint to purge your body of physical afflictions for %d turns.
			Each turn the purge will attempt to cleanse 1 physical debuff from you, and if one is removed, increase its duration by 1.]])
				:tformat(t.getDur(self, t) )
	end,
	short_info = function(self, t)
		return ([[%d turns]]):tformat(t.getDur(self, t) )
	end,
}

-----------------------------------------------------------------------
-- Legacy:  These inscriptions aren't on the drop tables and are only kept for legacy compatibility and occasionally NPC use
-----------------------------------------------------------------------
newInscription{
	name = "Infusion: Sun",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = {DISABLE = { blind = 2 } },
	range = 0,
	radius = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	requires_target = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		
		self:project(tg, self.x, self.y, engine.DamageType.BLINDCUSTOMMIND, {power=apply, turns=data.turns})
		self:project(tg, self.x, self.y, engine.DamageType.BREAK_STEALTH, {power=apply/2, turns=data.turns})
		tg.selffire = true
		self:project(tg, self.x, self.y, engine.DamageType.LITE, apply >= 19 and 100 or 1)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[Activate the infusion to brighten the area in a radius of %d and illuminate stealthy creatures, possibly revealing them (reduces stealth power by %d).%s
		It will also blind any creatures caught inside (power %d) for %d turns.]]):
		tformat(data.range, apply/2, apply >= 19 and _t"\nThe light is so powerful it will also banish magical darkness" or "", apply, data.turns)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[rad %d; power %d; turns %d%s]]):tformat(data.range, apply, data.turns, apply >= 19 and _t"; dispels darkness" or "")
	end,
}

newInscription{
	name = "Taint: Telepathy",
	type = {"inscriptions/taints", 1},
	points = 1,
	is_spell = true,
	range = 10,
	action = function(self, t)
		self:takeHit(self.max_life * 0.2, self)

		local rad = self:getTalentRange(t)
		self:setEffect(self.EFF_SENSE, 5, {
			range = rad,
			actor = 1,
		})
		self:setEffect(self.EFF_WEAKENED_MIND, 10, {save=10, power=35})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Strip the protective barriers from your mind for %d turns, allowing in the thoughts all creatures within %d squares but reducing mind save by %d and increasing your mindpower by %d for 10 turns.]]):tformat(data.dur, self:getTalentRange(t), 10, 35)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Range %d telepathy for %d turns]]):tformat(self:getTalentRange(t), data.dur)
	end,
}

newInscription{
	name = "Rune: Frozen Spear",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { COLD = 1 }, DISABLE = { stun = 1 }, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "mental" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_ice", trail="icetrail"}}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ICE, data.power + data.inc_stat, {type="freeze"})
		self:removeEffectsFilter({status="detrimental", type="mental", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/ice")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to fire a bolt of ice, doing %0.2f cold damage with a chance to freeze the target.
		The deep cold also crystalizes your mind, removing one random detrimental mental effect from you.]]):tformat(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d cold damage]]):tformat(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
}

newInscription{
	name = "Rune: Heat Beam",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { FIRE = 1 }, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "physical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	direct_hit = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIREBURN, {dur=5, initial=0, dam=data.power + data.inc_stat})
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
		self:removeEffectsFilter({status="detrimental", type="physical", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/fire")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to fire a beam of heat, doing %0.2f fire damage over 5 turns
		The intensity of the heat will also remove one random detrimental physical effect from you.]]):tformat(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d fire damage]]):tformat(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
}

newInscription{
	name = "Rune: Speed",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_energy = true,
	tactical = { BUFF = 4 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_SPEED, data.dur, {power=(data.power + data.inc_stat) / 100})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to increase your global speed by %d%% for %d turns.]]):tformat(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[speed %d%% for %d turns]]):tformat(data.power + data.inc_stat, data.dur)
	end,
}

newInscription{
	name = "Rune: Vision",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_npc_use = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:magicMap(data.range, self.x, self.y, function(x, y)
			local g = game.level.map(x, y, Map.TERRAIN)
			if g and (g.always_remember or g:check("block_move")) then
				for _, coord in pairs(util.adjacentCoords(x, y)) do
					local g2 = game.level.map(coord[1], coord[2], Map.TERRAIN)
					if g2 and not g2:check("block_move") then return true end
				end
			end
		end)
		self:setEffect(self.EFF_SENSE_HIDDEN, data.dur, {power=data.power + data.inc_stat})
		self:setEffect(self.EFF_RECEPTIVE_MIND, data.dur, {what=data.esp or "humanoid"})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to get a vision of the area surrounding you (%d radius) and to allow you to see invisible and stealthed creatures (power %d) for %d turns.
		Your mind will become more receptive for %d turns, allowing you to sense any %s around.]]):
		tformat(data.range, data.power + data.inc_stat, data.dur, data.dur, data.esp or "humanoid")
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[radius %d; dur %d; see %s]]):tformat(data.range, data.dur, data.esp or "humanoid")
	end,
}

newInscription{
	name = "Rune: Phase Door",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = { ESCAPE = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(self.x, self.y, data.range + data.inc_stat)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:setEffect(self.EFF_OUT_OF_PHASE, data.dur or 3, {
			defense=(data.power or 0) + data.inc_stat * 3,
			resists=(data.power or 0) + data.inc_stat * 3,
			effect_reduction=(data.power or 0) + data.inc_stat * 3,
		})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[Activate the rune to teleport randomly in a range of %d.
		Afterwards you stay out of phase for %d turns. In this state all new negative status effects duration is reduced by %d%%, your defense is increased by %d and all your resistances by %d%%.]]):
		tformat(data.range + data.inc_stat, data.dur or 3, power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[range %d; power %d; dur %d]]):tformat(data.range + data.inc_stat, power, data.dur or 3)
	end,
}

newInscription{
	name = "Rune: Controlled Phase Door",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = { CLOSEIN = 2 },
-- update this to allow for escape tactic (after AI update)
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		--copy the block_path function from the engine so that we can call it for normal block_path checks
		local old_block_path = engine.Target.defaults.block_path
		--use an adjusted block_path to check if we have a tile in LOS; display targeting in yellow if we don't so we can warn the player their spell may fizzle
		--note: we only use this if the original block_path would permit targeting 
		local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=data.range + data.inc_stat, radius=3, requires_knowledge=false, block_path=function(typ, lx, ly, for_highlights) if not self:hasLOS(lx, ly) and not old_block_path(typ, lx, ly, for_highlights) then return false, "unknown", true else return old_block_path(typ, lx, ly, for_highlights) end end}		
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)

		-- Check LOS
		local rad = 3
		if not self:hasLOS(x, y) and rng.percent(35 + (game.level.map.attrs(self.x, self.y, "control_teleport_fizzle") or 0)) then
			game.logPlayer(self, "The targetted phase door fizzles and works randomly!")
			x, y = self.x, self.y
			rad = tg.range
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(x, y, rad)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to teleport in a range of %d.]]):tformat(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[range %d]]):tformat(data.range + data.inc_stat)
	end,
}

newInscription{
	name = "Rune: Lightning",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { LIGHTNING = 1 } },
	requires_target = true,
	direct_hit = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = data.power + data.inc_stat
		self:project(tg, x, y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		self:setEffect(self.EFF_ELEMENTAL_SURGE_LIGHTNING, 2, {})
		game:playSoundNear(self, "talents/lightning")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat)
		return ([[Activate the rune to fire a beam of lightning, doing %0.2f to %0.2f lightning damage.
		Also transform you into pure lightning for %d turns; any damage will teleport you to an adjacent tile and ignore the damage (can only happen once per turn)]]):
		tformat(dam / 3, dam, 2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d lightning damage]]):tformat(damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat))
	end,
}

newInscription{
	name = "Infusion: Insidious Poison",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { ATTACK = { NATURE = 1 }, DISABLE= {poison = 1}, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime", trail="slimetrail"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.INSIDIOUS_POISON, {dam=data.power + data.inc_stat, dur=7, heal_factor=data.heal_factor}, {type="slime"})
		self:removeEffectsFilter({status="detrimental", type="magical", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the infusion to spit a bolt of poison doing %0.2f nature damage per turn for 7 turns, and reducing the target's healing received by %d%%.
		The sudden stream of natural forces also strips you of one random detrimental magical effect.]]):tformat(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d nature damage, %d%% healing reduction]]):tformat(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
}

newInscription{
	name = "Rune: Invisibility",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	tactical = { DEFEND = 3, ESCAPE = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_INVISIBILITY, data.dur, {power=data.power + data.inc_stat, penalty=0.4})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Activate the rune to become invisible (power %d) for %d turns.
		As you become invisible you fade out of phase with reality, all your damage is reduced by 40%%.
		]]):tformat(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[power %d for %d turns]]):tformat(data.power + data.inc_stat, data.dur)
	end,
}