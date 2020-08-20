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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

-- Item specific
newEffect{
	name = "ITEM_ANTIMAGIC_SCOURED", image = "talents/acidic_skin.png",
	desc = _t"Scoured",
	long_desc = function(self, eff) return ("Scoured by natural acid, reducing their offensive power ratings by %d%%."):tformat(eff.pct*100 or 0) end,
	type = "physical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = {pct = 0.3, spell = 0, mind = 0, phys = 0, power_str = ""},
	on_gain = function(self, err) return _t"#Target#'s power is greatly reduced!" end,
	on_lose = function(self, err) return _t"#Target# power has recovered." end,
	on_timeout = function(self, eff)
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "scoured", 1)
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "RELENTLESS_TEMPO", image = "talents/sunder_mind.png",
	desc = _t"Relentless Tempo",
	long_desc = function(self, eff) return ("Attuning to the flow of combat, increasing their combat stats.  \nDefense:  %d\nAll Damage:  %d%%\nStamina Regeneration:  %d\n%s"):
		tformat( eff.cur_defense or 0, eff.cur_damage or 0, eff.cur_stamina or 0, eff.stacks >= 5 and _t"All Resistance:  20%" or "") end,
	charges = function(self, eff) return eff.stacks end,
	type = "physical",
	subtype = { tempo=true },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target# is gaining tempo.", _t"+Tempo" end,
	on_lose = function(self, err) return _t"#Target# loses their tempo.", _t"-Tempo" end,
	parameters = { stamina = 0, defense = 0, damage = 0, stacks = 0, resists = 0 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur =3

		if old_eff.stacks >= 5 then
			if old_eff.resists ~= 20 then
				old_eff.resists = 20
				old_eff.resid = self:addTemporaryValue("resists", {all=old_eff.resists})
			end
			return old_eff
		end

		old_eff.stacks = old_eff.stacks + 1

		self:removeTemporaryValue("stamina_regen", old_eff.staminaid)
		self:removeTemporaryValue("combat_def", old_eff.defenseid)
		self:removeTemporaryValue("inc_damage", old_eff.damageid)

		old_eff.cur_stamina = old_eff.cur_stamina + new_eff.stamina
		old_eff.cur_defense = old_eff.cur_defense + new_eff.defense
		old_eff.cur_damage = old_eff.cur_damage + new_eff.damage

		old_eff.staminaid = self:addTemporaryValue("stamina_regen", old_eff.cur_stamina)
		old_eff.defenseid = self:addTemporaryValue("combat_def", old_eff.cur_defense)
		old_eff.damageid = self:addTemporaryValue("inc_damage", {all = old_eff.cur_damage})

		return old_eff
	end,
	activate = function(self, eff)
		eff.stacks = 1
		eff.cur_stamina = eff.stamina
		eff.cur_defense = eff.defense
		eff.cur_damage = eff.damage

		eff.staminaid = self:addTemporaryValue("stamina_regen", eff.cur_stamina)
		eff.defenseid = self:addTemporaryValue("combat_def", eff.cur_defense)
		eff.damageid = self:addTemporaryValue("inc_damage", {all = eff.cur_damage})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stamina_regen", eff.staminaid)
		self:removeTemporaryValue("combat_def", eff.defenseid)
		self:removeTemporaryValue("inc_damage", eff.damageid)
		if eff.resid then self:removeTemporaryValue("resists", eff.resid) end
	end,
}

newEffect{
	name = "DELIRIOUS_CONCUSSION", image = "talents/slippery_moss.png",
	desc = _t"Concussion",
	long_desc = function(self, eff) return ("The target can't think straight, causing their actions to fail."):tformat() end,
	type = "physical",
	subtype = { concussion=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target#'s brain isn't quite working right!", _t"+Concussion" end,
	on_lose = function(self, err) return _t"#Target# regains their concentration.", _t"-Concussion" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", 100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "CUT", image = "effects/cut.png",
	desc = _t"Bleeding",
	long_desc = function(self, eff) return ("Huge cut that bleeds, doing %0.2f physical damage per turn."):tformat(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# starts to bleed.", _t"+Bleeds" end,
	on_lose = function(self, err) return _t"#Target# stops bleeding.", _t"-Bleeds" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	activate = function(self, eff)
		if eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER) then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
}

newEffect{
	name = "DEEP_WOUND", image = "talents/bleeding_edge.png",
	desc = _t"Deep Wound",
	long_desc = function(self, eff) return ("Huge cut that bleeds, doing %0.2f physical damage per turn and decreasing all heals received by %d%%."):tformat(eff.power, eff.heal_factor) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,	
	type = "physical",
	subtype = { wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = {power=10, heal_factor=30},
	on_gain = function(self, err) return _t"#Target# is cut deeply.", _t"+Deep Wounds" end,
	on_lose = function(self, err) return _t"#Target#'s deep wound closes.", _t"-Deep Wounds" end,
	activate = function(self, eff)
		eff.healid = self:addTemporaryValue("healing_factor", -eff.heal_factor / 100)
		if eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER) then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healid)
	end,
}

newEffect{
	name = "REGENERATION", image = "talents/infusion__regeneration.png",
	desc = _t"Regeneration",
	long_desc = function(self, eff) return ("A flow of life spins around the target, regenerating %0.2f life per turn."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, healing=true, regeneration=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# starts regenerating health quickly.", _t"+Regen" end,
	on_lose = function(self, err) return _t"#Target# stops regenerating health quickly.", _t"-Regen" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("life_regen", eff.power)

		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, circleColor={0,0,0,0}, beamsCount=9}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, circleColor={0,0,0,0}, beamsCount=9}))
		end

	end,
	on_timeout = function(self, eff)
		if self:knowTalent(self.T_ANCESTRAL_LIFE) then
			local t = self:getTalentFromId(self.T_ANCESTRAL_LIFE)
			self:incEquilibrium(-t.getEq(self, t))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.tmpid)
	end,
}

newEffect{
	name = "POISONED", image = "effects/poisoned.png",
	desc = _t"Poison",
	long_desc = function(self, eff) return ("The target is poisoned, taking %0.2f nature damage per turn."):tformat(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Poison" end,
	on_lose = function(self, err) return _t"#Target# stops being poisoned.", _t"-Poison" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the poison
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
}

newEffect{
	name = "SPYDRIC_POISON", image = "effects/spydric_poison.png",
	desc = _t"Spydric Poison",
	long_desc = function(self, eff) return ("The target is poisoned, taking %0.2f nature damage per turn and unable to move (but can otherwise act freely)."):tformat(eff.power) end,
	type = "physical",
	subtype = { poison=true, pin=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return _t"#Target# is poisoned and cannot move!", _t"+Spydric Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Spydric Poison" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "INSIDIOUS_POISON", image = "effects/insidious_poison.png",
	desc = _t"Insidious Poison",
	long_desc = function(self, eff) return ("The target is poisoned, taking %0.2f nature damage per turn and decreasing all heals received by %d%%."):tformat(eff.power, eff.heal_factor) end,
	charges = function(self, eff) return (math.floor(eff.heal_factor).."%") end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, heal_factor=30},
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Insidious Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Insidious Poison" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "healing_factor", -eff.heal_factor / 100)
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CRIPPLING_POISON", image = "talents/crippling_poison.png",
	desc = _t"Crippling Poison",
	long_desc = function(self, eff) return ("The target is poisoned and sick, doing %0.2f nature damage per turn. Each time it tries to use a talent there is %d%% chance of failure."):tformat(eff.power, eff.fail) end,
	charges = function(self, eff) return (math.floor(eff.fail).."%") end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, fail=5},
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Crippling Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Crippling Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "NUMBING_POISON", image = "effects/numbing_poison.png",
	desc = _t"Numbing Poison",
	long_desc = function(self, eff) return ("The target is poisoned and sick, doing %0.2f nature damage per turn. All damage it does is reduced by %d%%."):tformat(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Numbing Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Numbing Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "STONE_POISON", image = "talents/stoning_poison.png",
	desc = _t"Stoning Poison",
	long_desc = function(self, eff)
		local chance = util.bound((eff.turn_count + eff.dur)*100/eff.time_to_stone, 0, 100)
		return ("The target is taking %0.2f nature damage per turn from a potent earth-based poison.  In %d more turn(s), or when the poison has run its course (%d%% chance), the target will be turned to stone for %d turns."):tformat(eff.power, eff.time_to_stone - eff.turn_count, chance, eff.stone)
	end,
	type = "physical",
	subtype = { poison=true, earth=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, stone=1, time_to_stone=10, turn_count=0},
	on_gain = function(self, err) return _t"#Target# is infused with stone poison!", _t"+Stoning Poison" end,
	on_lose = function(self, err) return _t"#Target# is free of the stone poison!", _t"-Stoning Poison" end,
	on_timeout = function(self, eff) -- Damage each turn, stone after enough time
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
		eff.turn_count = eff.turn_count + 1
		if eff.turn_count >= eff.time_to_stone and not self.dead then
			eff.turn_count = 0
			self:callEffect(eff.effect_id, "doStone")
		end
	end,
	charges = function(self, eff)
		return eff.time_to_stone - eff.turn_count
	end,
	doStone = function(self, eff, chance) -- turn to stone
		chance = chance or 100
		if self:canBe("stun") and self:canBe("instakill") and self:canBe("stone") and rng.percent(chance) then
			self:removeEffect(eff.effect_id)
			self:setEffect(self.EFF_STONED, math.floor(eff.stone*chance/100), {})
		else
			game.logSeen(self, "#GREY#%s looks stony for a moment, but resists the transformation.", self:getName():capitalize())
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		local new_fct = new_eff.dur/(new_eff.dur + old_eff.dur)
		local dam = old_eff.power*old_eff.dur + new_eff.power*new_eff.dur
		old_eff.stone = math.floor(new_eff.stone*new_fct + old_eff.stone*(1-new_fct))
		old_eff.time_to_stone = math.ceil(new_eff.time_to_stone*new_fct + old_eff.time_to_stone*(1-new_fct))
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		old_eff.power = dam/old_eff.dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
--		old_eff._from_toxic_death = nil
		return old_eff
	end,
	activate = function(self, eff)
		if eff._from_toxic_death then -- reset turn counter if spread from Toxic Death
			eff.turn_count = 0
--			eff._from_toxic_death = nil
		end
	end,
	deactivate = function(self, eff) -- chance to stone when deactivated
		local chance = eff.dur <= 0 and eff.turn_count*100/eff.time_to_stone or 0
		if chance > 0 then self:callEffect(eff.effect_id, "doStone", chance) end
	end,
}

newEffect{
	name = "BURNING", image = "talents/flame.png",
	desc = _t"Burning",
	long_desc = function(self, eff) return ("The target is on fire, taking %0.2f fire damage per turn."):tformat(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { fire=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# is on fire!", _t"+Burn" end,
	on_lose = function(self, err) return _t"#Target# stops burning.", _t"-Burn" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.FIRE).projector(eff.src, self.x, self.y, DamageType.FIRE, eff.power)
	end,
}

newEffect{
	name = "BURNING_SHOCK", image = "talents/flameshock.png",
	desc = _t"Burning Shock",
	long_desc = function(self, eff) return ("The target is on fire, taking %0.2f fire damage per turn, reducing damage by 50%%, putting 4 random talents on cooldown and reducing movement speed by 50%%. While flameshocked talents cooldown twice as slow."):tformat(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { fire=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is stunned by the burning flame!", _t"+Burning Shock" end,
	on_lose = function(self, err) return _t"#Target# is not stunned anymore.", _t"-Burning Shock" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self:startTalentCooldown(t.id, 1)
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.FIRE).projector(eff.src, self.x, self.y, DamageType.FIRE, eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "STUNNED", image = "effects/stunned.png",
	desc = _t"Stunned",
	long_desc = function(self, eff) return ("The target is stunned, reducing damage by 50%%, putting 3 random talents on cooldown and reducing movement speed by 50%%.  While stunned talents cooldown twice as slow."):tformat() end,
	type = "physical",
	subtype = { stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is stunned!", _t"+Stunned" end,
	on_lose = function(self, err) return _t"#Target# is not stunned anymore.", _t"-Stunned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 3 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self:startTalentCooldown(t.id, 1) -- Just set cooldown to 1 since cooldown does not decrease while stunned
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "DISARMED", image = "talents/disarm.png",
	desc = _t"Disarmed",
	long_desc = function(self, eff) return _t"The target is maimed, unable to correctly wield a weapon." end,
	type = "physical",
	subtype = { disarm=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is disarmed!", _t"+Disarmed" end,
	on_lose = function(self, err) return _t"#Target# rearms.", _t"-Disarmed" end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_COUNTER_ATTACKING) -- Cannot parry or counterattack while disarmed
		self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) 
		self:removeEffect(self.EFF_PARRY) 
		eff.tmpid = self:addTemporaryValue("disarmed", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("disarmed", eff.tmpid)
	end,
}

newEffect{
	name = "CONSTRICTED", image = "talents/constrict.png",
	desc = _t"Constricted",
	long_desc = function(self, eff) return ("The target is constricted, preventing movement and making it suffocate (loses %0.2f air per turn)."):tformat(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return _t"#Target# is constricted!", _t"+Constricted" end,
	on_lose = function(self, err) return _t"#Target# is free to breathe.", _t"-Constricted" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			return true
		end
		self:suffocate(eff.power, eff.src, (" was constricted to death by %s."):tformat(eff.src.unique and eff.src.name or eff.src:getName():a_an()))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "DAZED", image = "effects/dazed.png",
	desc = _t"Dazed",
	long_desc = function(self, eff) return _t"The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze." end,
	type = "physical",
	subtype = { stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is dazed!", _t"+Dazed" end,
	on_lose = function(self, err) return _t"#Target# is not dazed anymore.", _t"-Dazed" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "dazed", 1)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "EVASION", image = "talents/evasion.png",
	desc = _t"Evasion",
	long_desc = function(self, eff)
		return ("The target has %d%% chance to evade melee and ranged attacks"):tformat(eff.chance) .. ((eff.defense>0 and (" and gains %d defense"):tformat(eff.defense)) or "") .. "." 
	end,
	charges = function(self, eff)
		if self:attr("no_evasion") then return 0 end
		return math.floor(eff.chance).."%"
	end,
	type = "physical",
	subtype = { evade=true },
	status = "beneficial",
	parameters = { chance=10, defense=0 },
	on_gain = function(self, err) return _t"#Target# tries to evade attacks.", _t"+Evasion" end,
	on_lose = function(self, err) return _t"#Target# is no longer evading attacks.", _t"-Evasion" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("evasion", eff.chance)
		eff.pid = self:addTemporaryValue("projectile_evasion", eff.chance)
		eff.defid = self:addTemporaryValue("combat_def", eff.defense)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="evasion_tentacles2"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=700, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("evasion", eff.tmpid)
		self:removeTemporaryValue("projectile_evasion", eff.pid)
		self:removeTemporaryValue("combat_def", eff.defid)
	end,
}

newEffect{
	name = "SPEED", image = "talents/shaloren_speed.png",
	desc = _t"Speed",
	long_desc = function(self, eff) return ("Increases global action speed by %d%%."):tformat(eff.power * 100) end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#Target# speeds up.", _t"+Fast" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Fast" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "SLOW", image = "talents/slow.png",
	desc = _t"Slow",
	long_desc = function(self, eff) return ("Reduces global action speed by %d%%."):tformat(math.floor(eff.power * 100)) end,
	charges = function(self, eff) return (math.floor(eff.power * 100).."%") end,
	type = "physical",
	subtype = { slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#Target# slows down.", _t"+Slow" end,
	on_lose = function(self, err) return _t"#Target# speeds up.", _t"-Slow" end,
	on_merge = function(self, old_eff, new_eff)
		if new_eff.power > old_eff.power then
			self:removeTemporaryValue("global_speed_add", old_eff.tmpid)
			old_eff.tmpid = self:addTemporaryValue("global_speed_add", -new_eff.power)
			old_eff.power = new_eff.power
			old_eff.dur = new_eff.dur
		end 
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "BLINDED", image = "effects/blinded.png",
	desc = _t"Blinded",
	long_desc = function(self, eff) return _t"The target is blinded, unable to see anything." end,
	type = "physical",
	subtype = { blind=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# loses sight!", _t"+Blind" end,
	on_lose = function(self, err) return _t"#Target# recovers sight.", _t"-Blind" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("blind", 1)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blind", eff.tmpid)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
}

newEffect{
	name = "STONE_SKIN", image = "talents/stoneskin.png",
	desc = _t"Stoneskin",
	long_desc = function(self, eff) return ("The target's skin reacts to damage, granting %d armour."):tformat(eff.power) end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
	end,
}

newEffect{
	name = "THORNY_SKIN", image = "talents/stoneskin.png",
	desc = _t"Thorny Skin",
	long_desc = function(self, eff) return ("The target's skin reacts to damage, granting %d armour and %d%% armour hardiness."):tformat(eff.ac, eff.hard) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { ac=10, hard=10 },
	on_gain = function(self, err) return _t"#Target#'s skin looks a bit thorny.", _t"+Thorny Skin" end,
	on_lose = function(self, err) return _t"#Target# is less thorny now.", _t"-Thorny Skin" end,
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.ac)
		eff.hid = self:addTemporaryValue("combat_armor_hardiness", eff.hard)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
		self:removeTemporaryValue("combat_armor_hardiness", eff.hid)
	end,
}

newEffect{
	name = "FROZEN_FEET", image = "talents/frozen_ground.png",
	desc = _t"Frozen Feet",
	long_desc = function(self, eff) return _t"The target is frozen on the ground, able to act freely but not move." end,
	type = "physical",
	subtype = { cold=true, pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is frozen to the ground!", _t"+Frozen" end,
	on_lose = function(self, err) return _t"#Target# warms up.", _t"-Frozen" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
		eff.frozid = self:addTemporaryValue("frozen", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
		self:removeTemporaryValue("frozen", eff.frozid)
	end,
}

newEffect{
	name = "FROZEN", image = "talents/freeze.png",
	desc = _t"Frozen",
	long_desc = function(self, eff) return ("The target is encased in ice. All damage done to it will be split, 40%% absorbed by the ice and 60%% by the target. The target's defense is nullified while in the ice, and it may only attack the ice, but it is also immune to any new detrimental status effects (except Wet and Frozen Feet). The target cannot teleport or heal while frozen. %d HP on the iceblock remaining."):tformat(eff.hp) end,
	charges = function(self, eff) return math.floor(eff.hp) end,	
	type = "physical", -- Frozen has some serious effects beyond just being frozen, no healing, no teleport, etc.  But it can be applied by clearly non-magical sources i.e. Ice Breath
	subtype = { cold=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is encased in ice!", _t"+Frozen" end,
	on_lose = function(self, err) return _t"#Target# is free from the ice.", _t"-Frozen" end,
	activate = function(self, eff)
		-- Change color
		eff.old_r = self.color_r
		eff.old_g = self.color_g
		eff.old_b = self.color_b
		self.color_r = 0
		self.color_g = 255
		self.color_b = 155
		if not self.add_displays then
			self.add_displays = { Entity.new{image='npc/iceblock.png', display=' ', display_on_seen=true } }
			eff.added_display = true
		end
		eff.ice = mod.class.Object.new{name = _t"Iceblock", type = "wall", image='npc/iceblock.png', display = ' '} -- use type Object to facilitate the combat log
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		eff.hp = eff.hp or 100
		eff.tmpid = self:addTemporaryValue("encased_in_ice", 1)
		eff.healid = self:addTemporaryValue("no_healing", 1)
		eff.moveid = self:addTemporaryValue("never_move", 1)
		eff.frozid = self:addTemporaryValue("frozen", 1)
		eff.defid = self:addTemporaryValue("combat_def", -self:combatDefenseBase()-10)
		eff.rdefid = self:addTemporaryValue("combat_def_ranged", -self:combatDefenseBase()-10)
		eff.sefid = self:addTemporaryValue("negative_status_effect_immune", 1)
		eff.seffid = self:addTemporaryValue("negative_status_effect_immune_frozen", 1)

		self:setTarget(self)
	end,
	on_timeout = function(self, eff)
		self:setTarget(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("encased_in_ice", eff.tmpid)
		self:removeTemporaryValue("no_healing", eff.healid)
		self:removeTemporaryValue("never_move", eff.moveid)
		self:removeTemporaryValue("frozen", eff.frozid)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("combat_def_ranged", eff.rdefid)
		self:removeTemporaryValue("negative_status_effect_immune", eff.sefid)
		if eff.seffid then self:removeTemporaryValue("negative_status_effect_immune_frozen", eff.seffid) end
		self.color_r = eff.old_r
		self.color_g = eff.old_g
		self.color_b = eff.old_b
		if eff.added_display then self.add_displays = nil end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
		self:setTarget(nil)
	end,
}

newEffect{
	name = "ETERNAL_WRATH", image = "talents/thaloren_wrath.png",
	desc = _t"Wrath of the Woods",
	long_desc = function(self, eff) return ("The target calls upon its inner resources, improving all damage by %d%% and reducing all damage taken by %d%%."):tformat(eff.power, eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# radiates power." end,
	on_lose = function(self, err) return _t"#Target#'s aura of power vanishes." end,
	activate = function(self, eff)
		eff.pid1 = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.pid2 = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid1)
		self:removeTemporaryValue("resists", eff.pid2)
	end,
}

newEffect{
	name = "HIGHBORN_WRATH", image = "talents/higher_heal.png",
	desc = _t"Wrath of the Highborn",
	long_desc = function(self, eff) return ("The target calls upon its inner resources, improving all damage by %d%% and reducing all damage taken by %d%%."):tformat(eff.power, eff.power) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# radiates power." end,
	on_lose = function(self, err) return _t"#Target#'s aura of power vanishes." end,
	activate = function(self, eff)
		eff.pid1 = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.pid2 = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid1)
		self:removeTemporaryValue("resists", eff.pid2)
	end,
}

newEffect{
	name = "SHELL_SHIELD", image = "talents/shell_shield.png",
	desc = _t"Shell Shield",
	long_desc = function(self, eff) return ("The target takes cover in its shell, gaining %d%% all resist."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=50 },
	on_gain = function(self, err) return _t"#Target# takes cover under its shell.", _t"+Shell Shield" end,
	on_lose = function(self, err) return _t"#Target# leaves the cover of its shell.", _t"-Shell Shield" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "SERPENTINE_NATURE", image = "talents/hydra.png",
	desc = _t"Serpentine Nature",
	long_desc = function(self, eff) return ("The target takes on the properties of the hydra, gaining %d%% affinity to lightning, acid, and nature damage and regenerating %d life per turn."):tformat(eff.power, eff.regen) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=15, regen=10 },
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("damage_affinity", {NATURE=eff.power, ACID=eff.power, LIGHTNING=eff.power})
		eff.regenid = self:addTemporaryValue("life_regen", eff.regen)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("damage_affinity", eff.pid)
		self:removeTemporaryValue("life_regen", eff.regenid)
	end,
}

newEffect{
	name = "PAIN_SUPPRESSION", image = "talents/infusion__wild.png",
	desc = _t"Pain Suppression",
	long_desc = function(self, eff) return ("The target ignores pain, reducing all damage taken by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# lessens the pain.", _t"+Pain Suppression" end,
	on_lose = function(self, err) return _t"#Target# feels pain again.", _t"-Pain Suppression" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "PRIMAL_ATTUNEMENT", image = "talents/infusion__wild.png",
	desc = _t"Primal Attunement",
	long_desc = function(self, eff) return ("The target is attuned to the wild, increasing all damage affinity by %d%% and reducing a random debuff duration by %d each turn."):tformat(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20, reduce = 3 },
	on_gain = function(self, err) return _t"#Target# attunes to the wild.", _t"+Primal" end,
	on_lose = function(self, err) return _t"#Target# is no longer one with nature.", _t"-Primal" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("damage_affinity", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("damage_affinity", eff.pid)
	end,
	on_timeout = function(self, eff)
		local effs = self:effectsFilter({status = "detrimental", ignore_crosstier = true}, 1)
		local eff2 = self:hasEffect(effs[1])
		if eff2 then 
			eff2.dur = eff2.dur - eff.reduce
			if eff2.dur <= 0 then self:removeEffect(eff2.effect_id) end
		end
	end,
}

newEffect{
	name = "PURGE_BLIGHT", image = "talents/infusion__wild.png",
	desc = _t"Purge Blight",
	long_desc = function(self, eff) return ("The target is infused with the power of nature, reducing all blight damage taken by %d%%, increasing spell saves by %d, and granting immunity to diseases."):tformat(eff.power, eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# rejects blight!", _t"+Purge" end,
	on_lose = function(self, err) return _t"#Target# is susceptible to blight again.", _t"-Purge" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.BLIGHT]=eff.power})
		eff.spell_save = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.disease = self:addTemporaryValue("disease_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_spellresist", eff.spell_save)
		self:removeTemporaryValue("disease_immune", eff.disease)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "SENSE", image = "talents/track.png",
	desc = _t"Sensing",
	long_desc = function(self, eff) return _t"Improves senses, allowing the detection of unseen things." end,
	type = "physical",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { range=10, actor=1, object=0, trap=0 },
	activate = function(self, eff)
		eff.rid = self:addTemporaryValue("detect_range", eff.range)
		eff.aid = self:addTemporaryValue("detect_actor", eff.actor)
		eff.oid = self:addTemporaryValue("detect_object", eff.object)
		eff.tid = self:addTemporaryValue("detect_trap", eff.trap)
		self.detect_function = eff.on_detect
		game.level.map.changed = true
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("detect_range", eff.rid)
		self:removeTemporaryValue("detect_actor", eff.aid)
		self:removeTemporaryValue("detect_object", eff.oid)
		self:removeTemporaryValue("detect_trap", eff.tid)
		self.detect_function = nil
	end,
}

newEffect{
	name = "HEROISM", image = "talents/infusion__heroism.png",
	desc = _t"Heroism",
	long_desc = function(self, eff)
		local xs = eff.die_at > 0 and ("Keeps you from dying even if your life drops to %+d"):tformat(-eff.die_at) or ""
		return xs
	end,
	type = "physical",
	subtype = { nature=true },
	no_player_remove = true,
	status = "beneficial",
	parameters = { die_at = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.die_at)
	end,
}

newEffect{
	name = "SUNDER_ARMOUR", image = "talents/sunder_armour.png",
	desc = _t"Sunder Armour",
	long_desc = function(self, eff) return ("The target's armour and saves are broken, reducing them by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target#'s armour is damaged!", _t"+Sunder Armor" end,
	on_lose = function(self, err) return _t"#Target#'s armour is more intact.", _t"-Sunder Armor" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_armor", -eff.power)
		self:effectTemporaryValue(eff, "combat_physresist", -eff.power)
		self:effectTemporaryValue(eff, "combat_spellresist", -eff.power)
		self:effectTemporaryValue(eff, "combat_mentalresist", -eff.power)
	end,
}

newEffect{
	name = "SUNDER_ARMS", image = "talents/sunder_arms.png",
	desc = _t"Sunder Arms",
	long_desc = function(self, eff) return ("The target's combat ability is reduced, reducing its attack by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target#'s fighting ability is impaired!", _t"+Sunder Arms" end,
	on_lose = function(self, err) return _t"#Target#'s ability to fight has recovered.", _t"-Sunder Arms" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_atk", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.tmpid)
	end,
}

newEffect{
	name = "PINNED", image = "effects/pinned.png",
	desc = _t"Pinned to the ground",
	long_desc = function(self, eff) return _t"The target is pinned to the ground, unable to move." end,
	type = "physical",
	subtype = { pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is pinned to the ground.", _t"+Pinned" end,
	on_lose = function(self, err) return _t"#Target# is no longer pinned.", _t"-Pinned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "BONE_GRAB", image = "talents/bone_grab.png",
	desc = _t"Pinned to the ground",
	long_desc = function(self, eff) return _t"The target is pinned to the ground, unable to move." end,
	type = "physical",
	subtype = { pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is pinned to the ground.", _t"+Bone Grab" end,
	on_lose = function(self, err) return _t"#Target# is no longer pinned.", _t"-Bone Grab" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)

		if not self.add_displays then
			self.add_displays = { Entity.new{image='npc/bone_grab_pin.png', display=' ', display_on_seen=true } }
			eff.added_display = true
		end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		if eff.added_display then self.add_displays = nil end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "MIGHTY_BLOWS", image = "effects/mighty_blows.png",
	desc = _t"Mighty Blows",
	long_desc = function(self, eff) return ("The target's combat damage is improved by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { golem=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# looks menacing." end,
	on_lose = function(self, err) return _t"#Target# looks less menacing." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "CRIPPLE", image = "talents/cripple.png",
	desc = _t"Cripple",
	long_desc = function(self, eff) return ("The target is crippled, reducing melee, spellcasting and mind speed by %d%%."):tformat(eff.speed*100) end,
	type = "physical",
	subtype = { wound=true, cripple=true, slow=true },
	status = "detrimental",
	parameters = { speed=0.3 },
	on_gain = function(self, err) return _t"#Target# is crippled." end,
	on_lose = function(self, err) return _t"#Target# is not crippled anymore." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", -eff.speed)
		self:effectTemporaryValue(eff, "combat_spellspeed", -eff.speed)
		self:effectTemporaryValue(eff, "combat_mindspeed", -eff.speed)
	end,
}

newEffect{
	name = "BURROW", image = "talents/burrow.png",
	desc = _t"Burrow",
	long_desc = function(self, eff) return ("The target is able to burrow into walls, and additionally has %d more APR and %d%% more physical resistance penetration."):tformat(eff.power, eff.power / 2) end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.pass = self:addTemporaryValue("can_pass", {pass_wall=1})
		eff.dig = self:addTemporaryValue("move_project", {[DamageType.DIG]=1})
		self:effectTemporaryValue(eff, "combat_apr", eff.power)
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.PHYSICAL]=eff.power / 2 })
		self:effectTemporaryValue(eff, "ai_spread_add", 5)  -- Reduce accuracy of AI position guesses so we don't track straight to players that moved out of LOS
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("can_pass", eff.pass)
		self:removeTemporaryValue("move_project", eff.dig)
	end,
}

newEffect{
	name = "DIM_VISION", image = "talents/sticky_smoke.png",
	desc = _t"Reduced Vision",
	long_desc = function(self, eff) return ("The target's vision range is decreased by %d."):tformat(eff.sight) end,
	type = "physical",
	subtype = { sense=true },
	status = "detrimental",
	parameters = { sight=5 },
	on_gain = function(self, err) return _t"#Target# is surrounded by a thick smoke.", _t"+Dim Vision" end,
	on_lose = function(self, err) return _t"The smoke around #target# dissipates.", _t"-Dim Vision" end,
	charges = function(self, eff) return -eff.sight end,
	activate = function(self, eff)
		if self.sight - eff.sight < 1 then eff.sight = self.sight - 1 end
		eff.tmpid = self:addTemporaryValue("sight", -eff.sight)
--		self:setTarget(nil) -- Loose target!
		self:doFOV()
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sight", eff.tmpid)
		self:doFOV()
	end,
}

newEffect{
	name = "RESOLVE", image = "talents/resolve.png",
	desc = _t"Resolve",
	long_desc = function(self, eff)
		local list = table.keys(eff.types)
		for i = 1, #list do if DamageType.dam_def[list[i]] then
			list[i] = DamageType.dam_def[list[i]].name
		end end
		local type_str
		if #list >= 1 then type_str = table.concatNice(list, ", ", _t" and ") else type_str = "" end
		return ("You gain %d%% resistance against %s."):tformat(eff.res, type_str) 
	end,
	charges = function(self, eff) return table.count(eff.types) end,
	type = "physical",
	subtype = { antimagic=true, nature=true },
	status = "beneficial",
	parameters = { res=10, damtype=DamageType.ARCANE,  max_types = 1},
	on_gain = function(self, err) return _t"#Target# attunes to the damage.", _t"+Resolve" end,
	on_lose = function(self, err) return _t"#Target# is no longer attuned.", _t"-Resolve" end,
	activate = function(self, eff)
		eff.types = {}
		self:effectTemporaryValue(eff, "resists", {[eff.damtype] = eff.res})
		eff.types[eff.damtype] = true
	end,
	on_merge = function(self, old_eff, new_eff)
		if old_eff.types[new_eff.damtype] then return old_eff end
		if table.count(old_eff.types) >= new_eff.max_types then
			return old_eff
		end

		self:effectTemporaryValue(old_eff, "resists", {[new_eff.damtype] = new_eff.res})
		old_eff.types[new_eff.damtype] = true
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WILD_SPEED", image = "talents/infusion__movement.png",
	desc = _t"Wild Speed",
	long_desc = function(self, eff) return ("Moving at extreme speed (%d%% faster) and gains 100%% stun, daze and pinning immunity. Any action other than movement will cancel it.")
		:tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, speed=true },
	status = "beneficial",
	parameters = {power=100, no_talents=1},
	on_gain = function(self, err) return _t"#Target# is moving at extreme speed!", _t"+Wild Speed" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Wild Speed" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)

		self:effectTemporaryValue(eff, "ai_spread_add", 5)  -- Reduce accuracy of AI position guesses so we don't track straight to players that moved out of LOS
		
		-- should change priorities rather than forbid all talents
		if self.ai_state and eff.no_talents ~= 0 then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=eff.no_talents}) end -- Makes the AI not use talents while active
		eff.stun = self:addTemporaryValue("stun_immune", 1)
		eff.daze = self:addTemporaryValue("daze_immune", 1)
		eff.pin = self:addTemporaryValue("pin_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
	end,
}

newEffect{
	name = "HUNTER_SPEED", image = "talents/infusion__movement.png",
	desc = _t"Hunter",
	long_desc = function(self, eff) return ("Movement is %d%% faster.  Any action other than movement will end this effect."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, speed=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return ("#Target# prepares %s!"):tformat(not self.player and self.ai_state.tactic == "escape" and _t"to escape" or _t"for the next kill"), _t"+Hunter" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Hunter" end,
	
	on_timeout = function(self, eff)--make sure that NPC's that catch their target (or can't get away) can fight
		if eff.aiid then
			local turns = (game.turn - eff.start_turn)*game.energy_per_tick/game.energy_to_act
			if turns >= 1 then
				local target = self.ai_target and self.ai_target.actor
				if (target and core.fov.distance(self.x, self.y, target.x, target.y) <= 1) or not rng.chance(turns) then
					self:removeTemporaryValue("ai_state", eff.aiid); eff.aiid = nil
					print("---HUNTER_SPEED", self.name, "ai free to act after", turns, "turns")
				end
			end
		end
	end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = (eff.dur+1)*game.energy_to_act/game.energy_per_tick
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "STEP_UP", image = "talents/step_up.png",
	desc = _t"Step Up",
	long_desc = function(self, eff) return ("Movement is %d%% faster."):tformat(eff.power) end,
	type = "physical",
	subtype = { speed=true, tactic=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return _t"#Target# prepares for the next kill!", _t"+Step Up" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Step Up" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("step_up", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("step_up", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "LIGHTNING_SPEED", image = "talents/lightning_speed.png",
	desc = _t"Lightning Speed",
	long_desc = function(self, eff) return ("Turn into pure lightning, moving %d%% faster. It also increases your lightning resistance by 100%% and your physical resistance by 30%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { lightning=true, speed=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# turns into pure lightning!", _t"+Lightning Speed" end,
	on_lose = function(self, err) return _t"#Target# is back to normal.", _t"-Lightning Speed" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("lightning_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
		eff.resistsid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL]=30,
			[DamageType.LIGHTNING]=100,
		})
		eff.capresistsid = self:addTemporaryValue("resists_cap", {
			[DamageType.LIGHTNING]=100,
		})
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
		eff.particle = self:addParticles(Particles.new("bolt_lightning", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("lightning_speed", eff.tmpid)
		self:removeTemporaryValue("resists", eff.resistsid)
		self:removeTemporaryValue("resists_cap", eff.capresistsid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "DRAGONS_FIRE", image = "talents/fire_breath.png",
	desc = _t"Dragon's Fire",
	long_desc = function(self, eff) return ("Dragon blood runs through your veins. You can breathe fire (or have it improved if you already could)."):tformat() end,
	type = "physical",
	subtype = { fire=true },
	status = "beneficial",
	parameters = {power=1},
	on_gain = function(self, err) return _t"#Target#'s throat seems to be burning.", _t"+Dragon's fire" end,
	on_lose = function(self, err) return _t"#Target#'s throat seems to cool down.", _t"-Dragon's fire" end,
	activate = function(self, eff)
		local t_id = self.T_FIRE_BREATH
		if not self.talents[t_id] then
			-- Auto assign to hotkey
			if self.hotkey then
				for i = 1, 36 do
					if not self.hotkey[i] then
						self.hotkey[i] = {"talent", t_id}
						break
					end
				end
			end
		end

		eff.tmpid = self:addTemporaryValue("talents", {[t_id] = eff.power})
	end,
	deactivate = function(self, eff)
		local t_id = self.T_FIRE_BREATH
		self:removeTemporaryValue("talents", eff.tmpid)
		if self.talents[t_id] == 0 then
			self.talents[t_id] = nil
			if self.hotkey then
				for i, known_t_id in pairs(self.hotkey) do
					if known_t_id[1] == "talent" and known_t_id[2] == t_id then self.hotkey[i] = nil end
				end
			end
		end
	end,
}

newEffect{
	name = "GREATER_WEAPON_FOCUS", image = "talents/greater_weapon_focus.png",
	desc = _t"Greater Weapon Focus",
	long_desc = function(self, eff) return ("Each melee blow landed has a %d%% chance to trigger an additional melee blow (up to once per turn for each weapon)."):tformat(eff.chance) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { chance=25 },
	callbackOnMeleeAttack = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam, hd)
	-- trigger up to once per turn for each weapon
	-- checks self.turn_procs._no_melee_recursion to limit possible compounded recursion or other needed special cases
		if hitted and weapon and not (self.turn_procs._gwf_active or self.turn_procs._no_melee_recursion or target.dead) then
			local gwf = self.turn_procs._gwf or {}
			self.turn_procs._gwf = gwf
			if not gwf[weapon] and rng.percent(eff.chance) then
				gwf[weapon] = true
				print("[ATTACK]", eff.effect_id, "callbackOnMeleeAttack triggered with weapon", weapon)
				self.turn_procs._gwf_active = true -- safety net to prevent recursive recursion
				self:attackTargetWith(target, weapon, damtype, mult)
				self.turn_procs._gwf_active = nil
			end
		end
	end,
	activate = function(self, eff)
		eff.src = self
	end,
	deactivate = function(self, eff)
		--self:removeTemporaryValue("additional_melee_chance", eff.extra_blow_chance) -- backwards compatibility
	end,
}

-- Grappling stuff
newEffect{
	name = "GRAPPLING", image = "talents/clinch.png",
	desc = _t"Grappling",
	long_desc = function(self, eff) return ("Engaged in a grapple draining %d stamina per turn and redirecting %d%% of damage taken to %s.  Any movement will break the effect as will some unarmed talents."):tformat(eff.drain, eff.sharePct*100, eff.trgt.name or "unknown") end,
	type = "physical",
	subtype = { grapple=true, },
	status = "beneficial",
	parameters = {trgt, sharePct = 0.1, drain = 0},
	on_gain = function(self, err) return _t"#Target# is engaged in a grapple!", _t"+Grappling" end,
	on_lose = function(self, err) return _t"#Target# has released the hold.", _t"-Grappling" end,
	on_timeout = function(self, eff)
		local p = eff.trgt:hasEffect(eff.trgt.EFF_GRAPPLED)
		if not p or p.src ~= self or core.fov.distance(self.x, self.y, eff.trgt.x, eff.trgt.y) > 1 or eff.trgt.dead or not game.level:hasEntity(eff.trgt) then
			self:removeEffect(self.EFF_GRAPPLING)
		else
			self:incStamina(-eff.drain)
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	callbackOnHit = function(self, eff, cb, src)
		if not src then return cb.value end
		local share = cb.value * eff.sharePct

		-- deal the redirected damage as physical because I don't know how to preserve the damage type in a callback
		if not self.__grapling_feedback_damage then
			self.__grapling_feedback_damage = true
			DamageType:get(DamageType.PHYSICAL).projector(self or eff.src, eff.trgt.x, eff.trgt.y, DamageType.PHYSICAL, share)
			self.__grapling_feedback_damage = nil
		end

		return cb.value - share
	end,
}

newEffect{
	name = "GRAPPLED", image = "talents/grab.png",
	desc = _t"Grappled",
	long_desc = function(self, eff) return ("The target is grappled, unable to move, and limited in its offensive capabilities.\n#RED#%sPinned\n%s\n%s\n%s#LAST#"):tformat(eff.silence > 0 and _t"Silenced\n" or "", ("Physical power reduced by %d"):tformat(math.ceil(eff.reduce)), ("Slowed by %d%%"):tformat(math.floor(eff.slow * 100)), ("Damage per turn %d"):tformat(math.ceil(eff.power))) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = {silence = 0, slow = 0, reduce = 1, power = 1},
	remove_on_clone = true,
	on_gain = function(self, err) return _t"#Target# is grappled!", _t"+Grappled" end,
	on_lose = function(self, err) return _t"#Target# is free from the grapple.", _t"-Grappled" end,
	activate = function(self, eff)
		if self:attr("never_move") then self:effectTemporaryValue(eff, "never_move_before_grapple", 1) end  -- Flag for Hurricane Throw
		self:effectTemporaryValue(eff, "never_move", 1)
		self:effectTemporaryValue(eff, "combat_dam", -eff.reduce)
		if (eff.silence > 0) then
			self:effectTemporaryValue(eff, "silence", 1)
		end
		if (eff.slow > 0) then
			self:effectTemporaryValue(eff, "global_speed_add", -eff.slow)
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="grappled_debuff_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=0.0}})
		end
	end,
	on_timeout = function(self, eff)
		if not self.x or not eff.src or not eff.src.x or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_GRAPPLED)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	deactivate = function(self, eff)

	end, 
}

newEffect{
	name = "CRUSHING_HOLD", image = "talents/crushing_hold.png",
	desc = _t"Crushing Hold",
	long_desc = function(self, eff) return ("The target is being crushed and suffers %d damage each turn"):tformat(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# is being crushed.", _t"+Crushing Hold" end,
	on_lose = function(self, err) return _t"#Target# has escaped the crushing hold.", _t"-Crushing Hold" end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_CRUSHING_HOLD)
		elseif eff.damtype then
			local type = eff.damtype
			DamageType:get(DamageType[type]).projector(eff.src or self, self.x, self.y, DamageType[type], eff.power)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
}

newEffect{
	name = "STRANGLE_HOLD", image = "talents/clinch.png",
	desc = _t"Strangle Hold",
	long_desc = function(self, eff) return ("The target is being strangled and may not cast spells and suffers %d damage each turn."):tformat(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true, silence=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# is being strangled.", _t"+Strangle Hold" end,
	on_lose = function(self, err) return _t"#Target# has escaped the strangle hold.", _t"-Strangle Hold" end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_STRANGLE_HOLD)
		elseif eff.damtype then
			local type = eff.damtype
			DamageType:get(DamageType[type]).projector(eff.src or self, self.x, self.y, DamageType[type], eff.power)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "silence", 1)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MAIMED", image = "talents/maim.png",
	desc = _t"Maimed",
	long_desc = function(self, eff) return ("The target is maimed, reducing damage by %d and global speed by 30%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { wound=true, slow=true },
	status = "detrimental",
	parameters = { atk=10, dam=10 },
	on_gain = function(self, err) return _t"#Target# is maimed.", _t"+Maimed" end,
	on_lose = function(self, err) return _t"#Target# has recovered from the maiming.", _t"-Maimed" end,
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", -eff.dam)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -0.3)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "EXPOSE_WEAKNESS", image = "talents/expose_weakness.png",
	desc = _t"Expose Weakness",
	long_desc = function(self, eff) return ("The target is focused on penetrating defenses, increasing armor penetration by %d, accuracy by %d, and all damage penetration by %d%%."):tformat(eff.apr, eff.accuracy, eff.penetration) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { accuracy=0, apr=0, penetration=0 },
	on_gain = function(self, err) return _t"#Target# is focusing on penetrating defenses.", _t"+Expose Weakness" end,
	on_lose = function(self, err) return _t"#Target# is no longer focused on penetrating defenses.", _t"-Expose Weakness" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_apr", eff.apr)
		self:effectTemporaryValue(eff, "combat_atk", eff.accuracy)
		self:effectTemporaryValue(eff, "resists_pen", {all=eff.penetration})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "COMBO", image = "talents/combo_string.png",
	desc = _t"Combo",
	display_desc = function(self, eff) return ("%d Combo"):tformat(eff.cur_power) end,
	long_desc = function(self, eff) return ("The target is in the middle of a combo chain and has earned %d combo points."):tformat(eff.cur_power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=1, max=5 },
	charges = function(self, eff) return eff.cur_power end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combo", old_eff.tmpid)
		old_eff.cur_power = math.min(old_eff.cur_power + new_eff.power, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("combo", {power = old_eff.cur_power})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("combo", {eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combo", eff.tmpid)
	end,
}

newEffect{
	name = "DEFENSIVE_MANEUVER", image = "talents/set_up.png",
	desc = _t"Defensive Maneuver",
	long_desc = function(self, eff) return ("The target's defense is increased by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { evade=true },
	status = "beneficial",
	parameters = {power = 1},
	on_gain = function(self, err) return _t"#Target# is moving defensively!", _t"+Defensive Maneuver" end,
	on_lose = function(self, err) return _t"#Target# isn't moving as defensively anymore.", _t"-Defensive Maneuver" end,
	activate = function(self, eff)
		eff.defense = self:addTemporaryValue("combat_def", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defense)
	end,
}

newEffect{
	name = "SET_UP", image = "talents/set_up.png",
	desc = _t"Set Up",
	long_desc = function(self, eff) return ("The target is off balance and is %d%% more likely to be crit by the target that set it up.  In addition all its saves are reduced by %d."):tformat(eff.power, eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return _t"#Target# has been set up!", _t"+Set Up" end,
	on_lose = function(self, err) return _t"#Target# has survived the set up.", _t"-Set Up" end,
	activate = function(self, eff)
		eff.mental = self:addTemporaryValue("combat_mentalresist", -eff.power)
		eff.spell = self:addTemporaryValue("combat_spellresist", -eff.power)
		eff.physical = self:addTemporaryValue("combat_physresist", -eff.power)
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="set_up_debuff_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.mental)
		self:removeTemporaryValue("combat_spellresist", eff.spell)
		self:removeTemporaryValue("combat_physresist", eff.physical)
	end,
}

newEffect{
	name = "Recovery",
	desc = _t"Recovery",
	long_desc = function(self, eff) return ("The target has %d increased life regeneration."):tformat(eff.regen) end,
	type = "physical",
	subtype = { heal=true, regeneration=true },
	status = "beneficial",
	parameters = { regen=10 },
	on_gain = function(self, err) return _t"#Target# is recovering from the damage!", _t"+Recovery" end,
	on_lose = function(self, err) return _t"#Target# has finished recovering.", _t"-Recovery" end,
	activate = function(self, eff)
		eff.regenid = self:addTemporaryValue("life_regen", eff.regen)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.regenid)
	end,
}

newEffect{
	name = "REFLEXIVE_DODGING", image = "talents/heightened_reflexes.png",
	desc = _t"Reflexive Dodging",
	long_desc = function(self, eff) return ("Increases global action speed by %d%%."):tformat(eff.power * 100) end,
	type = "physical",
	subtype = { evade=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#Target# speeds up.", _t"+Reflexive Dodging" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Reflexive Dodging" end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "WEAKENED_DEFENSES", image = "talents/exploit_weakness.png",
	desc = _t"Weakened Defenses",
	long_desc = function(self, eff) return ("The target's physical resistance has been reduced by %d%%."):tformat(eff.cur_inc) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { inc=1, max=5 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("resists", old_eff.tmpid)
		old_eff.cur_inc = math.max(old_eff.cur_inc + new_eff.inc, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("resists", {[DamageType.PHYSICAL] = old_eff.cur_inc})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_inc = eff.inc
		eff.tmpid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL] = eff.inc,
		})
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="exploit_weakness_debuff_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "WATERS_OF_LIFE", image = "talents/waters_of_life.png",
	desc = _t"Waters of Life",
	long_desc = function(self, eff) return (_t"The target purifies all diseases and poisons, turning them into healing effects.") end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.poisid = self:addTemporaryValue("purify_poison", 1)
		eff.diseid = self:addTemporaryValue("purify_disease", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("purify_poison", eff.poisid)
		self:removeTemporaryValue("purify_disease", eff.diseid)
	end,
}

newEffect{
	name = "ELEMENTAL_HARMONY", image = "effects/elemental_harmony.png",
	desc = _t"Elemental Harmony",
	long_desc = function(self, eff)
		if eff.type == DamageType.FIRE then return ("Increases global speed by %d%%."):tformat(100 * self:callTalent(self.T_ELEMENTAL_HARMONY, "fireSpeed"))
		elseif eff.type == DamageType.COLD then return ("Increases armour by %d."):tformat(self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.LIGHTNING then return ("Increases all stats by %d."):tformat(self:callTalent(self.T_ELEMENTAL_HARMONY, "lightningStats"))
		elseif eff.type == DamageType.ACID then return ("Increases life regen by %0.2f."):tformat(self:callTalent(self.T_ELEMENTAL_HARMONY, "acidRegen"))
		elseif eff.type == DamageType.NATURE then return ("Increases all resists by %d%%."):tformat(self:callTalent(self.T_ELEMENTAL_HARMONY, "natureRes"))
		end
	end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { },
	no_player_remove = true,
	activate = function(self, eff)
		if eff.type == DamageType.FIRE then
			eff.tmpid = self:addTemporaryValue("global_speed_add", self:callTalent(self.T_ELEMENTAL_HARMONY, "fireSpeed"))
		elseif eff.type == DamageType.COLD then
			eff.tmpid = self:addTemporaryValue("combat_armor", self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.LIGHTNING then
			local stats = self:callTalent(self.T_ELEMENTAL_HARMONY, "lightningStats")
			eff.tmpid = self:addTemporaryValue("inc_stats",
			{
				[Stats.STAT_STR] = stats,
				[Stats.STAT_DEX] = stats,
				[Stats.STAT_MAG] = stats,
				[Stats.STAT_WIL] = stats,
				[Stats.STAT_CUN] = stats,
				[Stats.STAT_CON] = stats,
			})
		elseif eff.type == DamageType.ACID then
			eff.tmpid = self:addTemporaryValue("life_regen", self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.NATURE then
			eff.tmpid = self:addTemporaryValue("resists", {all=self:callTalent(self.T_ELEMENTAL_HARMONY, "natureRes")})
		end
	end,
	deactivate = function(self, eff)
		if eff.type == DamageType.FIRE then
			self:removeTemporaryValue("global_speed_add", eff.tmpid)
		elseif eff.type == DamageType.COLD then
			self:removeTemporaryValue("combat_armor", eff.tmpid)
		elseif eff.type == DamageType.LIGHTNING then
			self:removeTemporaryValue("inc_stats", eff.tmpid)
		elseif eff.type == DamageType.ACID then
			self:removeTemporaryValue("life_regen", eff.tmpid)
		elseif eff.type == DamageType.NATURE then
			self:removeTemporaryValue("resists", eff.tmpid)
		end
	end,
}

newEffect{
	name = "HEALING_NEXUS", image = "talents/healing_nexus.png",
	desc = _t"Healing Nexus Redirection",
	long_desc = function(self, eff)
		return ("All direct healing done to the target fails, and is instead redirected to %s at %d%% effectiveness."):tformat(eff.src:getName(), eff.pct * 100, eff.src:getName())
	end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "detrimental",
	parameters = { pct = 1 },
	callbackPriorities={callbackOnHeal = -5},
	callbackOnHeal = function(self, eff, value, src, raw_value)
		if raw_value > 0 and eff.src and not eff.src.__healing_nexus_running then
			game:delayedLogMessage(eff.src, self, "healing_nexus"..(eff.src.uid or ""), "#YELLOW_GREEN##Source# steals healing from #Target#!")
			eff.src.__healing_nexus_running = true
			eff.src:heal(raw_value*eff.pct, src) -- use raw healing value to avoid compounding healing_factor
			eff.src.__healing_nexus_running = nil
			return {value = 0}
		end
	end,
	activate = function(self, eff)
		if self == eff.src then
			self:setEffect(self.EFF_HEALING_NEXUS_BUFF, eff.dur, {pct=eff.pct})
			self:removeEffect(eff.effect_id)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "HEALING_NEXUS_BUFF", image = "talents/healing_nexus.png",
	desc = _t"Healing Nexus",
	long_desc = function(self, eff)
		return ("All direct healing done to the target is increased by %d%% and each heal restores %0.1f equilibrium."):tformat(eff.pct * 100, eff.eq)
	end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "beneficial",
	parameters = { pct = 1, eq = 0 },
	callbackOnHeal = function(self, eff, value, src, raw_value)
		if value > 0 then
			game:delayedLogMessage(self, self, "healing_nexus_buff", "#YELLOW_GREEN##Source#'s healing is amplified!")
			self:incEquilibrium(-eff.eq)
			return {value=value*(1 + eff.pct)}
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "PSIONIC_BIND", image = "effects/psionic_bind.png",
	desc = _t"Immobilized",
	long_desc = function(self, eff) return _t"Immobilized by telekinetic forces." end,
	type = "physical",
	subtype = { telekinesis=true, pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# is bound by telekinetic forces!", _t"+Paralyzed" end,
	on_lose = function(self, err) return _t"#Target# shakes free of the telekinetic binding", _t"-Paralyzed" end,
	activate = function(self, eff)
		--eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	deactivate = function(self, eff)
		--self:removeParticles(eff.particle)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "IMPLODING", image = "talents/implode.png",
	desc = _t"Imploding (slow)",
	long_desc = function(self, eff) return ("Slowed by 50%% and taking %d crushing damage per turn."):tformat( eff.power) end,
	type = "physical",
	subtype = { telekinesis=true, slow=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is being crushed.", _t"+Imploding" end,
	on_lose = function(self, err) return _t"#Target# shakes off the crushing forces.", _t"-Imploding" end,
	activate = function(self, eff)
		if core.shader.allow("distort") then eff.particle = self:addParticles(Particles.new("gravity_well2", 1, {radius=1})) end
		eff.tmpid = self:addTemporaryValue("global_speed_add", -0.5)
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
}

newEffect{
	name = "FREE_ACTION", image = "effects/free_action.png",
	desc = _t"Free Action",
	long_desc = function(self, eff) return ("The target gains %d%% stun, daze and pinning immunity."):tformat(eff.power * 100) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# is moving freely.", _t"+Free Action" end,
	on_lose = function(self, err) return _t"#Target# is moving less freely.", _t"-Free Action" end,
	activate = function(self, eff)
		eff.stun = self:addTemporaryValue("stun_immune", eff.power)
		eff.daze = self:addTemporaryValue("daze_immune", eff.power)
		eff.pin = self:addTemporaryValue("pin_immune", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
	end,
}

newEffect{
	name = "ADRENALINE_SURGE", image = "talents/adrenaline_surge.png",
	desc = _t"Adrenaline Surge",
	long_desc = function(self, eff) return ("The target's combat damage is improved by %d and it an continue to fight past the point of exhaustion, supplementing life for stamina."):tformat(eff.power) end,
	type = "physical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# feels a surge of adrenaline." end,
	on_lose = function(self, err) return _t"#Target#'s adrenaline surge has come to an end." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "BLINDSIDE_BONUS", image = "talents/blindside.png",
	desc = _t"Blindside Bonus",
	long_desc = function(self, eff) return ("The target has appeared out of nowhere! It's defense is boosted by %d."):tformat(eff.defenseChange) end,
	type = "physical",
	subtype = { evade=true },
	status = "beneficial",
	parameters = { defenseChange=10 },
	activate = function(self, eff)
		eff.defenseChangeId = self:addTemporaryValue("combat_def", eff.defenseChange)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defenseChangeId)
	end,
}

newEffect{
	name = "OFFBALANCE",
	desc = _t"Off-balance",
	long_desc = function(self, eff) return (_t"Badly off balance. Global damage is reduced by 15%.") end,
	type = "physical",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, _t"+Off-balance" end,
	on_lose = function(self, err) return nil, _t"-Off-balance" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("numbed", 15)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.speedid)
	end,
}

newEffect{
	name = "OFFGUARD",
	desc = _t"Off-guard", image = "talents/precise_strikes.png",
	long_desc = function(self, eff) return (_t"Badly off guard. Attackers gain a 10% bonus to physical critical strike chance and physical critcal strike power.") end,
	type = "physical",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, _t"+Off-guard" end,
	on_lose = function(self, err) return nil, _t"-Off-guard" end,
	activate = function(self, eff)
		eff.crit_vuln = self:addTemporaryValue("combat_crit_vulnerable", 10) -- increases chance to be crit
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_crit_vulnerable", eff.crit_vuln)
	end,
}

newEffect{
	name = "SLOW_MOVE",
	desc = _t"Slow movement", image = "talents/slow.png",
	long_desc = function(self, eff) return ("Movement speed is reduced by %d%%."):tformat(eff.power*100) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, _t"+Slow movement" end,
	on_lose = function(self, err) return nil, _t"-Slow movement" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("movement_speed", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.speedid)
	end,
}

newEffect{
	name = "WEAKENED",
	desc = _t"Weakened", image = "talents/ruined_earth.png",
	long_desc = function(self, eff) return ("The target has been weakened, reducing all damage inflicted by %d%%."):tformat(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)).."%" end,
	type = "physical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# has been weakened." end,
	on_lose = function(self, err) return _t"#Target#'s is no longer weakened." end,
	activate = function(self, eff)
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "LOWER_FIRE_RESIST",
	desc = _t"Lowered fire resistance",
	long_desc = function(self, eff) return ("The target fire resistance is reduced by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# becomes more vulnerable to fire.", _t"+Low. fire resist" end,
	on_lose = function(self, err) return _t"#Target# is less vulnerable to fire.", _t"-Low. fire resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.FIRE]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_COLD_RESIST",
	desc = _t"Lowered cold resistance",
	long_desc = function(self, eff) return ("The target cold resistance is reduced by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# becomes more vulnerable to cold.", _t"+Low. cold resist" end,
	on_lose = function(self, err) return _t"#Target# is less vulnerable to cold.", _t"-Low. cold resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.COLD]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_NATURE_RESIST",
	desc = _t"Lowered nature resistance",
	long_desc = function(self, eff) return ("The target nature resistance is reduced by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# becomes more vulnerable to nature.", _t"+Low. nature resist" end,
	on_lose = function(self, err) return _t"#Target# is less vulnerable to nature.", _t"-Low. nature resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.NATURE]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_PHYSICAL_RESIST",
	desc = _t"Lowered physical resistance",
	long_desc = function(self, eff) return ("The target physical resistance is reduced by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# becomes more vulnerable to physical.", _t"+Low. physical resist" end,
	on_lose = function(self, err) return _t"#Target# is less vulnerable to physical.", _t"-Low. physical resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.PHYSICAL]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "CURSED_WOUND", image = "talents/slash.png",
	desc = _t"Cursed Wound",
	long_desc = function(self, eff) return ("The target's has a cursed wound, reducing healing by %d%%."):tformat(-eff.healFactorChange * 100) end,
	type = "physical",
	subtype = { wound=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { healFactorChange=-0.1 },
	on_gain = function(self, err) return _t"#Target# has a cursed wound!", _t"+Cursed Wound" end,
	on_lose = function(self, err) return _t"#Target# no longer has a cursed wound.", _t"-Cursed Wound" end,
	activate = function(self, eff)
		eff.healFactorId = self:addTemporaryValue("healing_factor", eff.healFactorChange)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healFactorId)
	end,
	on_merge = function(self, old_eff, new_eff)
		-- add the remaining healing reduction spread out over the new duration
		old_eff.healFactorChange = math.max(-0.75, (old_eff.healFactorChange / old_eff.totalDuration) * old_eff.dur + new_eff.healFactorChange)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)

		self:removeTemporaryValue("healing_factor", old_eff.healFactorId)
		old_eff.healFactorId = self:addTemporaryValue("healing_factor", old_eff.healFactorChange)
		game.logSeen(self, "%s has re-opened a cursed wound!", self:getName():capitalize())

		return old_eff
	end,
}

newEffect{
	name = "LUMINESCENCE",
	desc = _t"Luminescence ", image = "talents/infusion__sun.png",
	long_desc = function(self, eff) return ("The target has been revealed, reducing its stealth power by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, light=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return _t"#Target# has been illuminated.", _t"+Luminescence" end,
	on_lose = function(self, err) return _t"#Target# is no longer illuminated.", _t"-Luminescence" end,
	activate = function(self, eff)
		eff.stealthid = self:addTemporaryValue("inc_stealth", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stealth", eff.stealthid)
	end,
}

newEffect{
	name = "SPELL_DISRUPTION", image = "talents/mana_clash.png",
	desc = _t"Spell Disruption",
	long_desc = function(self, eff) return ("The target has a %d%% chance to fail any spell it casts and a chance each turn to lose spell sustains."):tformat(eff.cur_power) end,
	charges = function(self, eff) return eff.cur_power end,	
	type = "physical",
	subtype = { antimagic=true, nature=true },
	status = "detrimental",
	parameters = { power=10, max=50 },
	on_gain = function(self, err) return _t"#Target#'s magic has been disrupted." end,
	on_lose = function(self, err) return _t"#Target#'s is no longer disrupted." end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("spell_failure", old_eff.tmpid)
		old_eff.cur_power = math.min(old_eff.cur_power + new_eff.power, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("spell_failure", old_eff.cur_power)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("spell_failure", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("spell_failure", eff.tmpid)
	end,
}

newEffect{
	name = "RESONANCE", image = "talents/alchemist_protection.png",
	desc = _t"Resonance",
	long_desc = function(self, eff) return ("+%d%% %s damage."):tformat(eff.dam, DamageType:get(eff.damtype).name) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { dam=10, damtype=DamageType.ARCANE },
	on_gain = function(self, err) return _t"#Target# resonates with the damage.", _t"+Resonance" end,
	on_lose = function(self, err) return _t"#Target# is no longer resonating.", _t"-Resonance" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_damage", {[eff.damtype]=eff.dam})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "THORN_GRAB", image = "talents/thorn_grab.png",
	desc = _t"Thorn Grab",
	long_desc = function(self, eff) return ("The target is encased in thorny vines, dealing %d nature damage each turn and reducing its speed by %d%%."):tformat(eff.dam, eff.speed*100) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { dam=10, speed=20 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.speed)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.NATURE).projector(eff.src or self, self.x, self.y, DamageType.NATURE, eff.dam)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "LEAVES_COVER", image = "talents/leaves_tide.png",
	desc = _t"Leaves Cover",
	long_desc = function(self, eff) return ("%d%% chance to fully absorb any damaging actions."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# is protected by a layer of thick leaves.", _t"+Leaves Cover" end,
	on_lose = function(self, err) return _t"#Target# cover of leaves falls apart.", _t"-Leaves Cover" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("cancel_damage_chance", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("cancel_damage_chance", eff.tmpid)
	end,
}

-- left in for backwards compatibility
newEffect{ -- Note: This effect is cancelled by EFF_DISARMED
	name = "DUAL_WEAPON_DEFENSE", image = "talents/dual_weapon_defense.png",
	desc = _t"Parrying",
	deflectchance = function(self, eff) -- The last partial deflect has a reduced chance to happen
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(eff.deflects>=1 and eff.chance or eff.chance*math.mod(eff.deflects,1),0,100)
	end,
	long_desc = function(self, eff)
		return ("Parrying melee attacks: Has a %d%% chance to deflect up to %d damage from the next %0.1f attack(s)."):tformat(self.tempeffect_def.EFF_DUAL_WEAPON_DEFENSE.deflectchance(self, eff),eff.dam, math.max(eff.deflects,1))
	end,
	charges = function(self, eff) return math.ceil(eff.deflects) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, dam = 1, deflects = 1},
	activate = function(self, eff)
		if self:attr("disarmed") or not self:hasDualWeapon() then
			eff.dur = 0 self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) return
			end
		eff.dam = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDamageChange")
		eff.deflects = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDeflects")
		eff.chance = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDeflectChance")
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{ -- Note: This effect is cancelled by EFF_DISARMED
	name = "PARRY", image = "talents/dual_weapon_mastery.png",
	desc = _t"Parrying",
	deflectchance = function(self, eff, adj) -- The last partial deflect has a reduced chance to happen
		adj = adj or 1
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(adj*(eff.deflects >=1 and eff.chance or eff.chance*math.mod(eff.deflects, 1)), 0, 100)
	end,
	long_desc = function(self, eff)
		return ("Parrying melee%s attacks: Has a %d%% chance to deflect up to %d damage from the next %0.1f attack(s).  Parried attacks cannot crit."):tformat(eff.parry_ranged and _t" and ranged" or "", math.floor(self:callEffect(self.EFF_PARRY, "deflectchance")), eff.dam, math.max(eff.deflects, 1))
	end,
	charges = function(self, eff) return math.ceil(eff.deflects) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	on_timeout = function(self, eff) -- always remove before refreshing each turn
		self:removeEffect(self.EFF_PARRY)
	end,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, dam = 1, deflects = 1, parry_ranged=false},
	doDeflect = function(self, eff, src) -- determine how much damage is deflected from src
		if not eff then return 0 end
		local deflected = 0
		local s = src.__project_source or src
		local adj = (self:canSee(s) or self:attr("blind_fight")) and 1 or 1/3 -- 1/3 chance to parry attack from unseen source
		if rng.percent(self:callEffect(eff.effect_id, "deflectchance", adj)) then
			deflected = eff.dam
			if self:knowTalent(self.T_TEMPO) then
				self:callTalent(self.T_TEMPO, "do_tempo", src)
			end
		end

		eff.deflects = eff.deflects - 1
		if eff.deflects <= 0 then self:removeEffect(self.EFF_PARRY) end
		return deflected
	end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.chance = 100 - (100 - old_eff.chance)*(100 - new_eff.chance)/100
		new_eff.dam = math.max(old_eff.dam, new_eff.dam)
		new_eff.deflects = math.max(old_eff.deflects, new_eff.deflects) + math.min(old_eff.deflects, new_eff.deflects)*.5
		new_eff.parry_ranged = old_eff.parry_ranged or new_eff.parry_ranged
		return new_eff
	end,
	activate = function(self, eff)
		if self:attr("disarmed") or not self:hasDualWeapon() then
			eff.dur = 0 self:removeEffect(self.EFF_PARRY) return
		end
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLOCKING", image = "talents/block.png",
	desc = _t"Blocking",
	long_desc = function(self, eff) return ("Reduces all damage taken by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	do_block = function(type, dam, eff, self, src)
		if self == src then return dam end
		local dur_inc = 0
		local crit_inc = 0
		local nb = 1
		if self:knowTalent(self.T_RIPOSTE) then
			local t = self:getTalentFromId(self.T_RIPOSTE)
			dur_inc = t.getDurInc(self, t)
			crit_inc = t.getCritInc(self, t)
			nb = nb + dur_inc
		end
		local b = false
		if eff.d_types[type] then b = true end
		if not b then return dam end
		local amt = util.bound(dam - eff.power, 0, dam)
		if eff.bonus_block_pct and eff.bonus_block_pct[type] then amt = amt * eff.bonus_block_pct[type] end
		local blocked = dam - amt
		local shield1, combat1, shield2, combat2 = self:hasShield()

		-- on_block can have two structures, an older single table, and a newer list of on_block functions used by randomly generated items
		if shield1 and shield1.on_block and shield1.on_block.fct then shield1.on_block.fct(shield1, self, src, type, dam, eff) end
		if shield2 and shield2.on_block and shield2.on_block.fct then shield2.on_block.fct(shield2, self, src, type, dam, eff) end

		if shield1 and shield1.on_block and shield1.on_block[1] then
			for _, on_block in pairs(shield1.on_block) do
				on_block.fct(shield1, self, src, type, dam, eff, on_block)
			end
		end
		if shield2 and shield2.on_block and shield2.on_block[1] then
			for _, on_block in pairs(shield2.on_block) do
				on_block.fct(shield2, self, src, type, dam, eff, on_block)
			end
		end

		if eff.properties.br then
			self:heal(blocked, src)
			game:delayedLogMessage(self, src, "block_heal", "#CRIMSON##Source# heals from blocking with %s shield!", string.his_her(self))
		end
		if eff.properties.ref and src.life then DamageType.defaultProjector(src, src.x, src.y, type, blocked, tmp, true) end
		local full = false
		if (self:attr("allow_incomplete_blocks") or amt == 0) and not eff.did_counterstrike and src.life then
			full = true
			if not self.__counterstrike_recurse then
				self.__counterstrike_recurse = true
				if not self:knowTalent(self.T_ETERNAL_GUARD) then eff.did_counterstrike = true end
				src:setEffect(src.EFF_COUNTERSTRIKE, 2, {power=eff.power, no_ct_effect=true, src=self, crit_inc=crit_inc, nb=nb})
				if eff.properties.sb then
					if src:canBe("disarm") then
						src:setEffect(src.EFF_DISARMED, 3, {apply_power=self:combatPhysicalpower()})
					else
						game.logSeen(src, "%s resists the disarming attempt!", src:getName():capitalize())
					end
				end
				if eff.properties.on_cs then
					eff.properties.on_cs(self, eff, dam, type, src)
				end
				self.__counterstrike_recurse = nil
			end
		end
		eff.did_block = true
		self:fireTalentCheck("callbackOnBlock", eff, dam, type, src, blocked)

		return amt
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("block", eff.power)
		if eff.properties.sp then eff.spell = self:addTemporaryValue("combat_spellresist", eff.power) end
		self:effectParticles(eff, {type="block"})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("block", eff.tmpid)
		if eff.properties.sp then self:removeTemporaryValue("combat_spellresist", eff.spell) end
	end,
}

newEffect{
	name = "COUNTERSTRIKE", image = "effects/counterstrike.png",
	desc = _t"Counterstrike",
	long_desc = function(self, eff) return _t"Vulnerable to deadly counterstrikes. Next melee attack will inflict double damage." end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, _t"+Counter" end,
	on_lose = function(self, eff) return nil, _t"-Counter" end,
	onStrike = function(self, eff, dam, src)
		eff.nb = eff.nb - 1
		if eff.nb <= 0 then self:removeEffect(self.EFF_COUNTERSTRIKE) end

		if self.x and src.x and core.fov.distance(self.x, self.y, src.x, src.y) >= 5 then
			game:setAllowedBuild("rogue_skirmisher", true)
		end

		return dam * 2
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("counterstrike", 1)
		eff.def = self:addTemporaryValue("combat_def", -eff.power)
		eff.crit = self:addTemporaryValue("combat_crit_vulnerable", eff.crit_inc or 0)
		local hx, hy = self:attachementSpot("head", true)
		if not hx then hx, hy = -0.4, -0.4
		else hx = hx - 0.4
		end
		self:effectParticles(eff, {type="circle", args={x=hx, y=hy, oversize=0.3, a=220, appear=12, img="counterstrike", speed=0, radius=0, base_rot=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("counterstrike", eff.tmpid)
		self:removeTemporaryValue("combat_def", eff.def)
		self:removeTemporaryValue("combat_crit_vulnerable", eff.crit)
	end,
}

newEffect{
	name = "COUNTER_ATTACKING", image = "talents/counter_attack.png",
	desc = _t"Counter Attacking",
	counterchance = function(self, eff) --The last partial counter attack has a reduced chance to happen
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(eff.counterattacks>=1 and eff.chance or eff.chance*math.mod(eff.counterattacks,1),0,100)
	end,
	long_desc = function(self, eff)
		return ("Countering melee attacks: Has a %d%% chance to get an automatic counter attack when avoiding a melee attack. (%0.1f counters remaining)"):tformat(self.tempeffect_def.EFF_COUNTER_ATTACKING.counterchance(self, eff), math.max(eff.counterattacks,1))
	end,
	charges = function(self, eff) return math.ceil(eff.counterattacks) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, counterattacks = 1},
	activate = function(self, eff)
		if self:attr("disarmed") then eff.dur = 0 return end
		eff.counterattacks = self:callTalent(self.T_COUNTER_ATTACK,"getCounterAttacks")
		eff.chance = self:callTalent(self.T_COUNTER_ATTACK,"counterchance")
		if eff.counterattacks <= 0 or eff.chance <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BRAWLER_BLOCK", image = "talents/block.png",
	desc = _t"Blocking",
	long_desc = function(self, eff)
		return ("Blocking up to %d total damage."):
			tformat(self.brawler_block or 0)
	end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	parameters = {block = 0},
	activate = function(self, eff)
		self.brawler_block = eff.block
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=2, img="open_palm_block_tentacles2"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=500, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self.brawler_block = nil
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, value, tmp)
		if not (self:attr("brawler_block") ) or value <= 0 then return end
		print("[PALM CALLBACK] dam start", value)

		local dam = value
		game:delayedLogDamage(src, self, 0, ("#STEEL_BLUE#(%d blocked)#LAST#"):tformat(math.min(dam, self.brawler_block)), false)
		if dam < self.brawler_block then
			self.brawler_block = self.brawler_block - dam
			dam = 0
		else
			dam = dam - self.brawler_block
			self.brawler_block = 0
		end

		-- If we are at the end of the capacity, release the time shield damage
		if self.brawler_block <= 0 then
			game.logPlayer(self, "#ORCHID#You cannot block any more attacks!#LAST#")
			self:removeEffect(self.EFF_BRAWLER_BLOCK)
		end

		print("[PALM CALLBACK] dam end", dam)

		return {dam = dam}
	end,
}

newEffect{
	name = "DEFENSIVE_GRAPPLING", image = "talents/defensive_throw.png",
	desc = _t"Grappling Defensively",
	throwchance = function(self, eff) -- the last partial defensive throw has a reduced chance to happen
		if not self:isUnarmed() or self:attr("encased_in_ice") then return 0 end	-- Must be unarmed
		return util.bound(eff.throws>=1 and eff.chance or eff.chance*math.mod(eff.throws,1),0,100)
	end,
	long_desc = function(self, eff)
		return ("Has a %d%% chance to counter attack with a defensive throw when avoiding a melee attack, possibly throwing the target to the ground and stunning it. (%0.1f throws remaining)"):tformat(self.tempeffect_def.EFF_DEFENSIVE_GRAPPLING.throwchance(self, eff), math.max(eff.throws,1))
	end,
	charges = function(self, eff) return math.ceil(eff.throws) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, throws = 1},
	activate = function(self, eff)
		if not self:isUnarmed() then eff.dur = 0 self:removeEffect(self.EFF_DEFENSIVE_GRAPPLING) return end
--		if not self:isUnarmed() then eff.dur = 0 return end
		eff.throws = self:callTalent(self.T_DEFENSIVE_THROW,"getThrows")
		eff.chance = self:callTalent(self.T_DEFENSIVE_THROW,"getchance")
		if eff.throws <= 0 or eff.chance <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RAVAGE", image = "talents/ravage.png",
	desc = _t"Ravage",
	long_desc = function(self, eff)
		local ravaged = _t"each turn."
		if eff.ravage then ravaged = _t"and is losing one physical effect turn." end
		return ("The target is being ravaged by distortion, taking %0.2f physical damage %s"):tformat(eff.dam, ravaged)
	end,
	type = "physical",
	subtype = { distortion=true },
	status = "detrimental",
	parameters = {dam=1, distort=0},
	on_gain = function(self, err) return  nil, _t"+Ravage" end,
	on_lose = function(self, err) return _t"#Target# is no longer being ravaged." or nil, _t"-Ravage" end,
	on_timeout = function(self, eff)
		if eff.ravage then
			-- Go through all physical effects
			local effs = {}
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "physical" and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained techniques
			for tid, act in pairs(self.sustain_talents) do
				if act then
					local talent = self:getTalentFromId(tid)
					if talent.type[1]:find("^technique/") then effs[#effs+1] = {"talent", tid} end
				end
			end

			if #effs > 0 then
				local eff = rng.tableRemove(effs)
				self:dispel(eff[2], eff.src)
			end
		end
		self:setEffect(self.EFF_DISTORTION, 2, {power=eff.distort})
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam)
	end,
	activate = function(self, eff)
		self:setEffect(self.EFF_DISTORTION, 2, {power=eff.distort})
		if eff.ravage then
			game.logSeen(self, "#LIGHT_RED#%s is being ravaged by distortion!", self:getName():capitalize())
			eff.dam = eff.dam * 1.5
		end
		local particle = Particles.new("ultrashield", 1, {rm=255, rM=255, gm=180, gM=255, bm=220, bM=255, am=35, aM=90, radius=0.2, density=15, life=28, instop=40})
		if core.shader.allow("distort") then particle:setSub("gravity_well2", 1, {radius=1}) end
		eff.particle = self:addParticles(particle)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "DISTORTION", image = "talents/maelstrom.png",
	desc = _t"Distortion",
	long_desc = function(self, eff) return ("The target has recently taken distortion damage, is vulnerable to distortion effects, and has its physical resistance decreased by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { distortion=true },
	status = "detrimental",
	parameters = {power=0},
	on_gain = function(self, err) return  nil, _t"+Distortion" end,
	on_lose = function(self, err) return _t"#Target# is no longer distorted." or nil, _t"-Distortion" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=-eff.power})
	end,

}

newEffect{
	name = "DISABLE", image = "talents/cripple.png",
	desc = _t"Disable",
	long_desc = function(self, eff) return ("The target is disabled, reducing movement speed by %d%% and accuracy by %d."):tformat(eff.speed * 100, eff.atk) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { speed=0.15, atk=10 },
	on_gain = function(self, err) return _t"#Target# is disabled.", _t"+Disabled" end,
	on_lose = function(self, err) return _t"#Target# is not disabled anymore.", _t"-Disabled" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("movement_speed", -eff.speed)
		eff.atkid = self:addTemporaryValue("combat_atk", -eff.atk)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("combat_atk", eff.atkid)
	end,
}

newEffect{
	name = "ANGUISH", image = "talents/agony.png",
	desc = _t"Anguish",
	long_desc = function(self, eff) return ("The target is in extreme anguish, preventing them from making tactical decisions, and reducing Willpower by %d and Cunning by %d."):tformat(eff.will, eff.cun) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { will=5, cun=5 },
	on_gain = function(self, err) return _t"#Target# is in anguish.", _t"+Anguish" end,
	on_lose = function(self, err) return _t"#Target# is no longer in anguish.", _t"-Anguish" end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("inc_stats", {[Stats.STAT_WIL]=-eff.will, [Stats.STAT_CUN]=-eff.cun})
--		if self.ai_state then eff.ai = self:addTemporaryValue("ai_state", {forbid_tactical=1}) end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.sid)
--		if eff.ai then self:removeTemporaryValue("ai_state", eff.ai) end
	end,
}

newEffect{
	name = "FAST_AS_LIGHTNING", image = "talents/fast_as_lightning.png",
	desc = _t"Fast As Lightning",
	long_desc = function(self, eff) return ("The target is so fast it may blink throught obstacles if moving in the same direction for over two turns."):tformat() end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { },
	on_merge = function(self, old_eff, new_eff)
		return old_eff
	end,
	on_gain = function(self, err) return _t"#Target# is speeding up.", _t"+Fast As Lightning" end,
	on_lose = function(self, err) return _t"#Target# is slowing down.", _t"-Fast As Lightning" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "phase_shift", 0.5)
	end,
	deactivate = function(self, eff)
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "STEAMROLLER", image = "talents/steamroller.png",
	desc = _t"Steamroller",
	long_desc = function(self, eff) return (_t"Resets Rush cooldown if killed.") end,
	type = "physical",
	subtype = { status=true },
	status = "detrimental",
	parameters = { },
	activate = function(self, eff)
		self.reset_rush_on_death = eff.src
	end,
	deactivate = function(self, eff)
		self.reset_rush_on_death = nil
	end,
}


newEffect{
	name = "STEAMROLLER_USER", image = "talents/steamroller.png",
	desc = _t"Steamroller",
	long_desc = function(self, eff) return ("Grants a +%d%% damage bonus."):tformat(eff.buff) end,
	type = "physical",
	subtype = { status=true },
	status = "beneficial",
	parameters = { buff=20 },
	on_merge = function(self, old_eff, new_eff)
		new_eff.buff = math.min(100, old_eff.buff + new_eff.buff)
		self:removeTemporaryValue("inc_damage", old_eff.buffid)
		new_eff.buffid = self:addTemporaryValue("inc_damage", {all=new_eff.buff})
		return new_eff
	end,
	activate = function(self, eff)
		eff.buffid = self:addTemporaryValue("inc_damage", {all=eff.buff})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.buffid)
	end,
}

newEffect{
	name = "SPINE_OF_THE_WORLD", image = "talents/spine_of_the_world.png",
	desc = _t"Spine of the World",
	long_desc = function(self, eff) return (_t"Immune to physical effects.") end,
	type = "physical",
	subtype = { status=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return _t"#Target# become impervious to physical effects.", _t"+Spine of the World" end,
	on_lose = function(self, err) return _t"#Target# is less impervious to physical effects.", _t"-Spine of the World" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "physical_negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "FUNGAL_BLOOD", image = "talents/fungal_blood.png",
	desc = _t"Fungal Blood",
	long_desc = function(self, eff) return ("You have %d fungal energies stored. Release them to heal by using the Fungal Blood prodigy."):tformat(eff.power) end,
	type = "physical",
	subtype = { heal=true },
	status = "beneficial",
	parameters = { power = 10 },
	on_gain = function(self, err) return nil, _t"+Fungal Blood" end,
	on_lose = function(self, err) return nil, _t"-Fungal Blood" end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.power = new_eff.power + old_eff.power
		return new_eff
	end,
	on_timeout = function(self, eff)
		eff.power = util.bound(eff.power * 0.9, 0, eff.power - 10)
	end,
}

newEffect{
	name = "MUCUS", image = "talents/mucus.png",
	desc = _t"Mucus",
	long_desc = function(self, eff) return ("You lay mucus where you walk."):tformat() end,
	type = "physical",
	subtype = { mucus=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return nil, _t"+Mucus" end,
	on_lose = function(self, err) return nil, _t"-Mucus" end,
	on_timeout = function(self, eff)
		self:callTalent(self.T_MUCUS, nil, self.x, self.y, self:getTalentLevel(self.T_MUCUS) >=4 and 1 or 0, eff)
	end,
}

newEffect{
	name = "CORROSIVE_NATURE", image = "talents/corrosive_nature.png",
	desc = _t"Corrosive Nature",
	long_desc = function(self, eff) return ("Acid damage increased by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, acid=true },
	status = "beneficial",
	parameters = { power=1, bonus_level=1},
	charges = function(self, eff) return math.round(eff.power) end,
	on_gain = function(self, err) return _t"#Target#'s acid damage is more potent.", _t"+Corrosive Nature" end,
	on_lose = function(self, err) return _t"#Target#'s acid damage is no longer so potent.", _t"-Corrosive Nature" end,
	on_merge = function(self, eff, new_eff)
		if game.turn < eff.last_update + 10 then return eff end -- update once a turn
		local t = self:getTalentFromId(self.T_CORROSIVE_NATURE)
		eff.dur = t.getDuration(self, t)
		if eff.bonus_level >=5 then return eff end
		game.logSeen(self, "%s's corrosive nature intensifies!",self:getName():capitalize())
		eff.last_update = game.turn
		eff.bonus_level = eff.bonus_level + 1
		eff.power = t.getAcidDamage(self, t, eff.bonus_level)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.ACID]=eff.power})
		return eff
	end,
	activate = function(self, eff)
		eff.power = self:callTalent(self.T_CORROSIVE_NATURE, "getAcidDamage")
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.ACID]=eff.power})
		eff.last_update = game.turn
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
	end,
}

newEffect{
	name = "NATURAL_ACID", image = "talents/natural_acid.png",
	desc = _t"Natural Acid",
	long_desc = function(self, eff) return ("Nature damage increased by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true, acid=true },
	status = "beneficial",
	parameters = { power=1, bonus_level=1},
	charges = function(self, eff) return math.round(eff.power) end,
	on_gain = function(self, err) return _t"#Target#'s nature damage is more potent.", _t"+Natural Acid" end,
	on_lose = function(self, err) return _t"#Target#'s nature damage is no longer so potent.", _t"-Nature Acid" end,
	on_merge = function(self, eff, new_eff)
		if game.turn < eff.last_update + 10 then return eff end -- update once a turn
		local t = self:getTalentFromId(self.T_NATURAL_ACID)
		eff.dur = t.getDuration(self, t)
		if eff.bonus_level >=5 then return eff end
		game.logSeen(self, "%s's natural acid becomes more concentrated!",self:getName():capitalize())
		eff.last_update = game.turn
		eff.bonus_level = eff.bonus_level + 1
		eff.power = t.getNatureDamage(self, t, eff.bonus_level)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.NATURE]=eff.power})
		return eff
	end,
	activate = function(self, eff)
		eff.power = self:callTalent(self.T_NATURAL_ACID, "getNatureDamage")
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.NATURE]=eff.power})
		eff.last_update = game.turn
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
	end,
}

newEffect{
	name = "CORRODE", image = "talents/blightzone.png",
	desc = _t"Corrode",
	long_desc = function(self, eff) return ("The target is corroded, reducing their accuracy by %d, their armor by %d, and their defense by %d."):tformat(eff.atk, eff.armor, eff.defense) end,
	type = "physical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = { atk=5, armor=5, defense=10 }, no_ct_effect = true,
	on_gain = function(self, err) return _t"#Target# is corroded." end,
	on_lose = function(self, err) return _t"#Target# has shook off the effects of their corrosion." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_atk", -eff.atk)
		self:effectTemporaryValue(eff, "combat_armor", -eff.armor)
		self:effectTemporaryValue(eff, "combat_def", -eff.defense)
	end,
}

newEffect{
	name = "SLIPPERY_MOSS", image = "talents/slippery_moss.png",
	desc = _t"Slippery Moss",
	long_desc = function(self, eff) return ("The target is covered in slippery moss. Each time it tries to use a talent there is %d%% chance of failure."):tformat(eff.fail) end,
	type = "physical",
	subtype = { moss=true, nature=true },
	status = "detrimental",
	parameters = {fail=5},
	on_gain = function(self, err) return _t"#Target# is covered in slippery moss!", _t"+Slippery Moss" end,
	on_lose = function(self, err) return _t"#Target# is free from the slippery moss.", _t"-Slippery Moss" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "JUGGERNAUT", image = "talents/juggernaut.png",
	desc = _t"Juggernaut",
	long_desc = function(self, eff) return ("Reduces physical damage received by %d%% and provides a %d%% chance to ignore critical hits."):tformat(eff.power, eff.crits) end,
	type = "physical",
	subtype = { superiority=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# hardens its skin.", _t"+Juggernaut" end,
	on_lose = function(self, err) return _t"#Target#'s skin returns to normal.", _t"-Juggernaut" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("stone_skin", 1, {density=4}))
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=eff.power})
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crits)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "NATURE_REPLENISHMENT", image = "talents/meditation.png",
	desc = _t"Natural Replenishment",
	long_desc = function(self, eff) return ("The target has been directly exposed to arcane energies and has responded by reasserting it's connection to nature, restoring %0.1f Equilibrium per turn."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = {power=1},
	on_gain = function(self, err) return ("#Target# defiantly reasserts %s connection to nature!"):tformat(string.his_her(self)), _t"+Nature Replenishment" end,
	on_lose = function(self, err) return _t"#Target# stops restoring Equilibrium.", _t"-Nature Replenishment" end,
	on_timeout = function(self, eff)
		self:incEquilibrium(-eff.power)
	end,
}


newEffect{
	name = "BERSERKER_RAGE", image = "talents/berserker.png",
	desc = _t"Berserker Rage",
	long_desc = function(self, eff) return ("Increases critical hit chance by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	decrease = 0, no_remove = true,
	parameters = {power=1},
	charges = function(self, eff) return ("%0.1f%%"):tformat(eff.power) end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_physcrit", old_eff.tmpid)
		old_eff.tmpid = self:addTemporaryValue("combat_physcrit", new_eff.power)
		old_eff.power = new_eff.power
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_physcrit", eff.power)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="tentacles_shader/berserker_aura_2"}, shader={type="tentacles", wobblingType=0, appearTime=0.3, time_factor=500, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="tentacles_shader/berserker_aura_2"}, shader={type="tentacles", wobblingType=0, appearTime=0.3, time_factor=500, noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physcrit", eff.tmpid)
	end
}


newEffect{
	name = "RELENTLESS_FURY", image = "talents/relentless_fury.png",
	desc = _t"Relentless Fury",
	long_desc = function(self, eff) return ("Increases stamina regeneration by %d, movement and attack speed by %d%%."):tformat(eff.stamina, eff.speed) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {stamina=1, speed=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "movement_speed", eff.speed/100)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed/100)
	end,
}

local normalize_direction = function(direction)
	return direction % (2*math.pi)
end

local in_angle = function(angle, min, max)
	if min <= max then
		return min <= angle and angle <= max
	else
		return min <= angle or angle <= max
	end
end

newEffect {
	name = "SKIRMISHER_DIRECTED_SPEED",
	desc = _t"Directed Speed",
	type = "physical",
	subtype = {speed = true},
	parameters = {
		-- Movement direction in radians.
		direction = 0,
		-- Allowed deviation from movement direction in radians.
		leniency = math.pi * 0.1,
		-- Movement speed bonus
		move_speed_bonus = 1.00
	},
	status = "beneficial",
	on_lose = function(self, eff) return _t"#Target# loses speed.", _t"-Directed Speed" end,
	lists = 'break_with_step_up',
	callbackOnMove = function(self, eff, moved, force, ox, oy)
		local angle_start = normalize_direction(math.atan2(self.y - eff.start_y, self.x - eff.start_x))
		local angle_last = normalize_direction(math.atan2(self.y - eff.last_y, self.x - eff.last_x))
		if ((self.x ~= eff.start_x or self.y ~= eff.start_y) and
				not in_angle(angle_start, eff.min_angle_start, eff.max_angle_start)) or
			((self.x ~= eff.last_x or self.y ~= eff.last_y) and
			 not in_angle(angle_last, eff.min_angle_last, eff.max_angle_last))
		then
			self:removeEffect(self.EFF_SKIRMISHER_DIRECTED_SPEED)
		end
		eff.last_x = self.x
		eff.last_y = self.y
		eff.min_angle_last = normalize_direction(angle_last - eff.leniency_last)
		eff.max_angle_last = normalize_direction(angle_last + eff.leniency_last)
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "movement_speed", eff.move_speed_bonus)
		eff.leniency_last = math.max(math.pi * 0.25, eff.leniency)

		eff.start_x = self.x
		eff.start_y = self.y
		eff.min_angle_start = normalize_direction(eff.direction - eff.leniency)
		eff.max_angle_start = normalize_direction(eff.direction + eff.leniency)
		eff.last_x = self.x
		eff.last_y = self.y
		eff.min_angle_last = normalize_direction(eff.direction - eff.leniency_last)
		eff.max_angle_last = normalize_direction(eff.direction + eff.leniency_last)

		-- AI won't use talents while active.
		if self.ai_state then
-- should change priorities rather than forbid all talents
			self:effectTemporaryValue(eff, "ai_state", {no_talents=1})
		end
	end,
	long_desc = function(self, eff)
		return ([[Target is currently moving with %d%% additional speed in a single direction (%s). Stopping or changing directions will remove this effect.]])
		:tformat(eff.move_speed_bonus * 100, eff.compass or "unknown")
	end,
}

-- If they don't have stun, stun them. If they do, increase its
-- duration.
newEffect {
	name = "SKIRMISHER_STUN_INCREASE",
	desc = _t"Stun Lengthen",
	long_desc = function(self, eff) return ([[This should not be shown, oops.]]) end,
	type = "physical",
	subtype = {stun = true},
	status = "detrimental",
	on_gain = function(self, eff)
		local stun = self:hasEffect(self.EFF_STUNNED)
		if stun and stun.dur and stun.dur > 1 then
			return ("#Target# is stunned further! (now %d turns)"):tformat(stun.dur), "Stun Lengthened"
		end
	end,
	activate = function(self, eff)
		local stun = self:hasEffect(self.EFF_STUNNED)
		if stun then
			stun.dur = stun.dur + eff.dur
		else
			self:setEffect(self.EFF_STUNNED, eff.dur, {})
		end
		self:removeEffect(self.EFF_SKIRMISHER_STUN_INCREASE)
	end,
}

newEffect {
	name = "SKIRMISHER_ETERNAL_WARRIOR",
	desc = _t"Eternal Warrior",
	image = "talents/skirmisher_the_eternal_warrior.png",
	type = "mental",
	subtype = { morale=true },
	status = "beneficial",
	parameters = {
		-- Resist all increase
		res=.5,
		-- Resist caps increase
		cap=.5,
		-- Maximum stacking applications
		max=5
	},
	on_gain = function(self, err) return nil, _t"+Eternal Warrior" end,
	on_lose = function(self, err) return nil, _t"-Eternal Warrior" end,
	long_desc = function(self, eff)
		return ("The target stands strong, increasing all resistances by %0.1f%% and resistance caps by %0.1f%%."):
		tformat(eff.res, eff.cap)
	end,
	activate = function(self, eff)
		eff.res_id = self:addTemporaryValue("resists", {all = eff.res})
		eff.cap_id = self:addTemporaryValue("resists_cap", {all = eff.cap})
	end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("resists", old_eff.res_id)
			self:removeTemporaryValue("resists_cap", old_eff.cap_id)
		new_eff.res = math.min(new_eff.res + old_eff.res, new_eff.res * new_eff.max)
		new_eff.cap = math.min(new_eff.cap + old_eff.cap, new_eff.cap * new_eff.max)
		new_eff.res_id = self:addTemporaryValue("resists", {all = new_eff.res})
		new_eff.cap_id = self:addTemporaryValue("resists_cap", {all = new_eff.cap})
		return new_eff
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.res_id)
		self:removeTemporaryValue("resists_cap", eff.cap_id)
	end,
}

newEffect {
	name = "SKIRMISHER_TACTICAL_POSITION",
	desc = _t"Tactical Position",
	type = "physical",
	subtype = {tactic = true},
	status = "beneficial",
	parameters = {combat_physcrit = 10},
	long_desc = function(self, eff)
		return ([[The target has relocated to a favorable position, giving them +%d%% physical critical chance.]])
		:tformat(eff.combat_physcrit)
	end,
	on_gain = function(self, eff) return _t"#Target# is poised to strike!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physcrit", eff.combat_physcrit)
	end,
}

newEffect {
	name = "SKIRMISHER_DEFENSIVE_ROLL",
	desc = _t"Defensive Roll",
	type = "physical",
	subtype = {tactic = true},
	status = "beneficial",
	parameters = {
		-- percent of all damage to ignore
		reduce = 50
	},
	on_gain = function(self, eff) return _t"#Target# assumes an extreme defensive posture, avoiding some damage!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "incoming_reduce", eff.reduce)
	end,
	long_desc = function(self, eff)
		return ([[The target is in an extreme defensive posture, avoiding %d%% of all incoming damage.]])
		:tformat(eff.reduce)
	end,
}

newEffect {
	name = "SKIRMISHER_TRAINED_REACTIONS_COOLDOWN",
	desc = _t"Trained Reactions Cooldown",
	type = "other",
	subtype = {cooldown = true},
	status = "detrimental",
	no_stop_resting = true,
	on_lose = function(self, eff) return _t"#LIGHT_BLUE##Target# may dodge again.", _t"+Trained Reactions" end,
	long_desc = function(self, eff)
		return _t"Trained Reactions may not trigger."
	end,
}

newEffect {
	name = "SKIRMISHER_SUPERB_AGILITY",
	desc = _t"Superb Agility",
	image = "talents/skirmisher_superb_agility.png",
	type = "physical",
	subtype = {speed = true},
	status = "beneficial",
	parameters = {
		global_speed_add = 0.1,
	},
	on_gain = function(self, eff) return _t"#Target# has sped up!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "global_speed_add", eff.global_speed_add)
	end,
	long_desc = function(self, eff)
		return ([[The target's reactions have quickened, giving +%d%% global speed.]])
		:tformat(eff.global_speed_add * 100)
	end,
}

newEffect{
	name = "ANTI_GRAVITY", image = "talents/gravity_locus.png",
	desc = _t"Anti-Gravity",
	long_desc = function(self, eff) return ("Target is caught in an anti-gravity field, halving its knockback resistance."):tformat() end,
	type = "physical",
	subtype = { spacetime=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, _t"+Anti-Gravity" end,
	on_lose = function(self, err) return nil, _t"-Anti-Gravity" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("knockback_immune") then
			self:effectTemporaryValue(eff, "knockback_immune", -self:attr("knockback_immune") / 2)
		end
	end,
}

newEffect{
	name = "PARASITIC_LEECHES", image = "talents/blood_suckers.png",
	desc = _t"Parasitic Leeches",
	display_desc = function(self, eff) return ("Parasitic Leeches: %d masses"):tformat(eff.nb) end,
	long_desc = function(self, eff)
		local source = eff.src or self
		return ("The target is being fed upon by %d masses of parasitic leeches for %0.2f physical and %0.2f acid damage each turn.  After a %d turn feeding period, one mass will drop off and multiply."):tformat(eff.nb,
		source:damDesc("PHYSICAL", eff.dam*eff.nb/2), source:damDesc("ACID", eff.dam*eff.nb/2), eff.gestation)
	end,
	type = "physical",
	subtype = { parasite=true },
	status = "detrimental",
	decrease = 0,
	on_merge = function(self, old_eff, new_eff) -- More leeches = faster feeding and more damage.
		old_eff.nb = old_eff.nb + 1
		old_eff.gestation = old_eff.gestation - 1
		return old_eff
	end,
	activate = function(self, eff)
	end,
	charges = function(self, eff) return eff.nb end,
	parameters = {dam=10, nb=1, gestation=5, turns=0 },
	on_gain = function(self, err) return _t"#Target# is #GREEN#INFESTED#LAST# with parasitic leeches!", _t"+Parasitic Leeches" end,
	on_timeout = function(self, eff)
		eff.turns = eff.turns + 1
		-- Creepy, so the player tries to get rid of it as soon as possible...
		local source = eff.src or self
		source:project({}, self.x, self.y, DamageType.PHYSICAL, eff.dam*eff.nb/2)
		source:project({}, self.x, self.y, DamageType.ACID, eff.dam*eff.nb/2)
		if eff.turns >= eff.gestation then
			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
			if not x then
				--game.logPlayer(self, "Not enough space to invoke!")
				return
			end
			local m = game.zone:makeEntityByName(game.level, "actor", "HORROR_PARASITIC_LEECHES")
			if m then
				m.exp_worth = 0
				m.can_multiply = 1
				game.zone:addEntity(game.level, m, "actor", x, y)
				m:learnTalent(m.T_MULTIPLY, 1)

				game.logSeen(self, "Some leeches drop off %s!", self:getName():capitalize())
			end
			eff.turns = 0
			eff.nb = eff.nb - 1
			eff.gestation = 6 - eff.nb
			if eff.nb <= 0 then self:removeEffect(self.EFF_PARASITIC_LEECHES, false, true) end
		end
	end,
	deactivate = function(self, eff)
		if eff.nb >= 0 then -- prematurely removed, drop all leeches without multiply.
			for n=1, eff.nb do
				-- Find space
				local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
				if not x then
					--game.logPlayer(self, "Not enough space to invoke!")
					return
				end
				local m = game.zone:makeEntityByName(game.level, "actor", "HORROR_PARASITIC_LEECHES")
				if m then
					m.exp_worth = 0
					game.zone:addEntity(game.level, m, "actor", x, y)
				end
			end
			game.logSeen(self, "Some leeches drop off %s!", self:getName():capitalize())
		end
	end,
}

newEffect{
	name = "GARROTE", image = "talents/grab.png",
	desc = _t"Garrote",
	long_desc = function(self, eff)
		local silence = eff.silence > 0 and eff.silenceid and ("  It is silenced for the next %d turn(s), preventing it from casting spells and using some vocal talents."):tformat(eff.silence) or ""
		return ("The target is being garrotted by %s, rendering it unable to move and subject to an automatic unarmed attack (at %d%% damage) each turn.%s"):tformat(eff.src and eff.src:getName() or _t"something", eff.power*100, silence) 
	end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = { power = 0.6, silence=0},
	remove_on_clone = true,
	on_gain = function(self, eff) return ("%s has garroted #Target#!"):tformat(eff.src and eff.src:getName() or _t"Something"), _t"+Garrote" end,
	on_lose = function(self, eff) return ("#Target# is free from %s's garrote."):tformat(eff.src and eff.src:getName() or _t"something"), _t"-Garrote" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
		if eff.silence > 0 then eff.silenceid = self:addTemporaryValue("silence", 1) end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1, img="garrote_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=0.0}})
		end
	end,
	charges = function(self, eff) return eff.silence end,
	on_timeout = function(self, eff)
		if eff.silence > 0 then
			eff.silence = eff.silence - 1
			if eff.silenceid and eff.silence <= 0 then self:removeTemporaryValue("silence", eff.silenceid); eff.silenceid = nil end
		end
		if not self.x or not eff.src or not eff.src.x or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_GARROTE)
		else
			eff.src:logCombat(self, "#Source# #LIGHT_RED#strangles#LAST# #Target#!")
			eff.src.turn_procs.auto_melee_hit = true
			self:attr("no_evasion", 1)
			eff.src:attackTarget(self, nil, eff.power, true, true)
			eff.src.turn_procs.auto_melee_hit = nil
			self:attr("no_evasion", -1)
		end
	end,
	deactivate = function(self, eff)
		if eff.silenceid then self:removeTemporaryValue("silence", eff.silenceid) end
	end, 
}

newEffect{
	name = "MARKED_FOR_DEATH", image = "talents/marked_for_death.png",
	desc = _t"Marked for Death",
	long_desc = function(self, eff) return ("The target takes %d%% increased damage from all sources.  If this effect runs its full course, the target will take an additional %0.1f physical damage (increased by %d%% of all damage taken while this effect is active)."):tformat(eff.power, eff.dam, eff.perc*100) end,
	type = "physical",
	subtype = {  },
	status = "detrimental",
	parameters = { power=20, perc=20, stam=0, turns = 0, max_dur=6},
	on_gain = function(self, err) return _t"#Target# is marked for death!", _t"+Marked for Death!" end,
	on_lose = function(self, err) return _t"#Target# is free from the deathmark.", _t"-Marked for Death" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {all=-eff.power})
		self:effectParticles(eff, {type="circle", args={toback=true, oversize=1.8, base_rot=180, a=255, shader=true, appear=12, img="marked_death_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		eff.src.__project_source = eff
		eff.src:project({type="hit", x=self.x, y=self.y}, self.x, self.y, DamageType.PHYSICAL, eff.dam, nil)
		game.level.map:particleEmitter(self.x, self.y, 1, "blood")
		eff.src.__project_source = nil
	end,
	on_timeout = function(self, eff)
		eff.turns = eff.turns + 1
	end,
	callbackOnHit = function(self, eff, cb)
		eff.dam = eff.dam + (cb.value * eff.perc)
		return true
	end,
	on_die = function(self, eff) -- splitting oozes?
		if eff.src then
			eff.src:incStamina(eff.stam)
			eff.src.talents_cd[eff.src.T_MARKED_FOR_DEATH] = 0
		end
	end,
}

newEffect{
	name = "DEADLY_POISON", image = "talents/apply_poison.png",
	desc = _t"Deadly Poison",
	long_desc = function(self, eff)
		local insidious = eff.insidious > 0 and (" Healing received is reduced by %d%%."):tformat(eff.insidious) or ""
		local numbing = eff.numbing > 0 and (" Damage dealt is reduced by %d%%."):tformat(eff.numbing) or ""
		local crippling = eff.crippling > 0 and (" %d%% chance to fail talents."):tformat(eff.crippling) or ""
		local volatile = eff.volatile > 0 and (" Poison damage also hits adjacent targets for 50%%."):tformat() or ""
		local leeching = eff.leeching > 0 and (" The source of this effect receives healing equal to %d%% of the damage it deals to the target."):tformat(eff.leeching) or ""
		return ("The target is poisoned, taking %0.2f nature damage per turn.%s%s%s%s%s"):tformat(eff.power, insidious, numbing, crippling, volatile, leeching) 
	end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Deadly Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Deadly Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff, p, ed)
		if self:attr("purify_poison") then 
			self:heal(eff.power, eff.src)
		elseif self.x and self.y then
			local dam = DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
			if eff.volatile > 0 then
				local tg = {type="ball", radius=1, friendlyfire=false, x=self.x, y=self.y, act_exclude={[self.uid]=true}}
				eff.src:project(tg, self.x, self.y, DamageType.NATURE, eff.power / 2)
			end
			if dam > 0 and eff.leeching > 0 then
				local src = eff.src.resolveSource and eff.src:resolveSource()
				if src then src:heal(dam*eff.leeching/100, ed) end
			end
		end
	end,
	on_merge = function(self, old_eff, new_eff) --Note: on_merge called before activate
		-- Merge the poison
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
		if old_eff.healid then 
			self:removeTemporaryValue("healing_factor", old_eff.healid)
			old_eff.healid = null
		end
		if old_eff.numbid then 
			self:removeTemporaryValue("numbed", old_eff.numbid) 
			old_eff.numbid = null
		end
		if old_eff.cripid then 
			self:removeTemporaryValue("talent_fail_chance", old_eff.cripid) 
			old_eff.cripid = null
		end
		if new_eff.insidious > 0 then old_eff.healid = self:addTemporaryValue("healing_factor", -new_eff.insidious / 100) end
		if new_eff.numbing > 0 then old_eff.numbid = self:addTemporaryValue("numbed", new_eff.numbing) end
		if new_eff.crippling > 0 then old_eff.cripid = self:addTemporaryValue("talent_fail_chance", new_eff.crippling) end
		old_eff.leeching = new_eff.leeching
		old_eff.volatile = new_eff.volatile
		return old_eff
	end,
	activate = function(self, eff)
		-- Only store ids for new temp values (Toxic Death may copy ids from killed victim)
		if eff.insidious > 0 then eff.healid = self:addTemporaryValue("healing_factor", -eff.insidious / 100) else eff.healid = nil end
		if eff.numbing > 0 then eff.numbid = self:addTemporaryValue("numbed", eff.numbing) else eff.numbid = nil end
		if eff.crippling > 0 then eff.cripid = self:addTemporaryValue("talent_fail_chance", eff.crippling) else eff.cripid = nil end
	end,
	deactivate = function(self, eff)
		if eff.healid then self:removeTemporaryValue("healing_factor", eff.healid) end
		if eff.numbid then self:removeTemporaryValue("numbed", eff.numbid) end
		if eff.cripid then self:removeTemporaryValue("talent_fail_chance", eff.cripid) end
	end,
}

newEffect{
	name = "RAZORWIRE", image = "talents/springrazor_trap.png",
	desc = _t"Razorwire",
	long_desc = function(self, eff) return ("The target's equipment has been shredded by razorwire, reducing its accuracy by %d, armour by %d, and defense by %d."):tformat(eff.power, eff.power, eff.power) end,
	type = "physical",
	subtype = { physical=true },
	status = "detrimental",
	parameters = { power=10 }, no_ct_effect = true,
	on_gain = function(self, err) return _t"#Target# is entangled in razorwire!" end,
	on_lose = function(self, err) return _t"#Target# has shook off the razorwire." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_atk", -eff.power)
		self:effectTemporaryValue(eff, "combat_armor", -eff.power)
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
	end,
}

newEffect{
	name = "DIRTY_FIGHTING", image = "talents/dirty_fighting.png",
	desc = _t"Dirty Fighting",
	long_desc = function(self, eff) return ("The target is reeling in pain. Stun, pin, blindness, and confusion immunity are halved and physical save is reduced by %d."):tformat(eff.power) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { power=5 },
	on_gain = function(self, err) return nil, _t"+Dirty Fighting" end,
	on_lose = function(self, err) return nil, _t"-Dirty Fighting" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("stun_immune") then
			self:effectTemporaryValue(eff, "stun_immune", -self:attr("stun_immune") / 2)
		end
		if self:attr("confusion_immune") then
			self:effectTemporaryValue(eff, "confusion_immune", -self:attr("confusion_immune") / 2)
		end
		if self:attr("blind_immune") then
			self:effectTemporaryValue(eff, "blind_immune", -self:attr("blind_immune") / 2)
		end
		if self:attr("pin_immune") then
			self:effectTemporaryValue(eff, "pin_immune", -self:attr("pin_immune") / 2)
		end
		self:effectTemporaryValue(eff, "combat_physresist", -eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "SOOTHING_DARKNESS", image = "talents/soothing_darkness.png",
	desc = _t"Soothing Darkness",
	long_desc = function(self, eff)
		local desc = ("The target is wreathed in shadows, increasing life regeneration by %0.1f"):tformat(eff.life)
		if eff.shadowguard > 0 then
			desc = desc..(", stamina regeneration by %0.1f and all damage resistance by %d%%."):tformat(eff.stamina, eff.shadowguard)
		else
			desc = desc..(" and stamina regeneration by %0.1f."):tformat(eff.stamina) end
		return desc
	end,
	type = "physical",
	subtype = { darkness=true, healing=true, regeneration=true },
	status = "beneficial",
	parameters = { life=1, stamina=0.5, dr=0, shadowguard=0 },
	activate = function(self, eff)
		eff.lifeid = self:addTemporaryValue("life_regen", eff.life)
		eff.staid = self:addTemporaryValue("stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "resists", {all = eff.shadowguard})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("life_regen", eff.lifeid)
		self:removeTemporaryValue("stamina_regen", eff.staid)
	end,
}

newEffect{
	name = "SHADOW_DANCE", image = "talents/shadow_dance.png",
	desc = _t"Shadow Dance", 
	long_desc = function(self, eff) return ("The target is able to make actions and attacks while remaining stealthed."):tformat() end,
	type = "physical",
	subtype = { tactical=true, darkness=true },
	status = "beneficial",
	on_gain = function(self, err) game.logPlayer(self, "#GREY#You begin your Shadow Dance.") end,
	on_lose = function(self, err) game.logPlayer(self, "#GREY#You end your Shadow Dance.") end,
	parameters = {rad=10},
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=2.5, y=0.25, img="shadow_dance_tentacle_wings"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=700, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "SEDATED", image = "talents/dart_launcher.png",
	desc = _t"Sedated",
	long_desc = function(self, eff) return ("The target is in a deep sleep and unable to act.  Every %d damage it takes will reduce the duration of the effect by one turn."):tformat(eff.power) end,
	type = "physical",
	subtype = { sleep=true, poison=true },
	status = "detrimental",
	parameters = { power=10, insomnia=10, slow=0 },
	on_gain = function(self, eff)
		-- check non-poison immunities if this is being applied by Toxic Death
		if eff._from_toxic_death and not (self:checkClassification("living") and self:canBe("sleep")) then
			eff.cancel = true
			return
		end
		return _t"#Target# is in a deep sleep.", "+Sedated"
	end,
	on_lose = function(self, eff) return _t"#Target# is no longer sleeping.", _t"-Sedated" end,
	on_timeout = function(self, eff)
		-- Increment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
				
	end,
	activate = function(self, eff)
		if eff.cancel then self:removeEffect(eff.effect_id, true) return end
		eff._from_toxic_death = false
		self:effectTemporaryValue(eff, "sleep", 1)
	end,
	deactivate = function(self, eff)
		if not eff.cancel and not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.slow > 0 then
			if self:canBe("slow") then
				self:setEffect(self.EFF_SLOW, 4, {src=eff.src, power=eff.slow, no_ct_effect=true})
			end
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "ROGUE_S_BREW", image = "talents/rogue_s_brew_mastery.png",
	desc = _t"Rogue's Brew",
	long_desc = function(self, eff) return ("The target will not die until falling below -%d life."):tformat(eff.power) end,
	charges = function(self, eff) return math.floor(eff.power) end,	
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=1 },
	activate = function(self, eff)
		eff.die = self:addTemporaryValue("die_at", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("die_at", eff.die)
	end,
}

newEffect{
	name = "BEAR_TRAP", image = "talents/bear_trap.png",
	desc = _t"Bear Trap",
	long_desc = function(self, eff)
		local desc = {}
		if eff.pinid then desc[#desc+1] = "pinned" end
		if eff.slowid then desc[#desc+1] = ("slowed (%d%%)"):tformat(eff.power*100) end
		if eff.dam > 0 then desc[#desc+1] = ("taking %0.2f physical damage each turn"):tformat(eff.dam) end
		return _t"Caught in a bear trap: "..table.concat(desc, ", ")
	end,
	type = "physical",
	subtype = { slow=true, pin=true, wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = { power=0.1, dam=10 },
	on_gain = function(self, err) return _t"A bear trap snaps onto #Target#!", _t"+Bear Trap" end,
	on_lose = function(self, err) return _t"#Target# is freed from a bear trap.", _t"-Bear Trap" end,
	activate = function(self, eff)
		local pin, cut = self:canBe("pin"), self:canBe("cut")
		if pin then
			eff.pinid = self:addTemporaryValue("never_move", 1)
			if self:canBe("slow") then eff.slowid = self:addTemporaryValue("global_speed_add", -eff.power) end
			if not cut then eff.dam = 0 end
		else
			self:removeEffect(eff.effect_id)
			if cut then
				self:setEffect(self.EFF_CUT, 5, {src=eff.src, power=eff.dam})
			end
			return
		end
		
		if cut and eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER)then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	deactivate = function(self, eff)
		if eff.slowid then self:removeTemporaryValue("global_speed_add", eff.slowid) end
		if eff.pinid then self:removeTemporaryValue("never_move", eff.pinid) end
	end,
	on_timeout = function(self, eff)
		if eff.dam > 0 then DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam) end
	end,
}

newEffect{
	name = "STONE_VINE",
	desc = _t"Stone Vine",
	long_desc = function(self, eff) return ("A living stone vine holds the target in place, inflicting %0.1f Nature%s damage per turn."):tformat(eff.dam, eff.arcanedam and (" and %0.1f Arcane"):tformat(eff.arcanedam) or "") end,
	type = "physical",
	subtype = { earth=true, pin=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return _t"#Target# is seized by a stone vine.", _t"+Stone Vine" end,
	on_lose = function(self, err) return _t"#Target# is free from the stone vine.", _t"-Stone Vine" end,
	activate = function(self, eff)
		eff.last_x = eff.src.x
		eff.last_y = eff.src.y
		eff.tmpid = self:addTemporaryValue("never_move", 1)
		eff.particle = self:addParticles(Particles.new("stonevine", 1, {tx=eff.src.x-self.x, ty=eff.src.y-self.y}))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		local severed = false
		local src = eff.src or self
		if core.fov.distance(self.x, self.y, src.x, src.y) >= eff.free or src.dead or not game.level:hasEntity(src) then severed = true end
		if rng.percent(eff.free_chance) then severed = true end

		self:removeParticles(eff.particle)
		eff.particle = self:addParticles(Particles.new("stonevine", 1, {tx=eff.src.x-self.x, ty=eff.src.y-self.y}))

		if severed then
			return true
		else
			DamageType:get(DamageType.NATURE).projector(src, self.x, self.y, DamageType.NATURE, eff.dam)
			
			if eff.arcanedam and src:knowTalent(src.T_ELDRITCH_VINES) then
				src:incEquilibrium(-src:callTalent(src.T_ELDRITCH_VINES, "getEquilibrium"))
				src:incMana(src:callTalent(src.T_ELDRITCH_VINES, "getMana"))
				DamageType:get(DamageType.ARCANE).projector(src, self.x, self.y, DamageType.ARCANE, eff.arcanedam)
			end
		end
		eff.last_x = src.x
		eff.last_y = src.y
	end,
}

newEffect{
	name = "DWARVEN_RESILIENCE", image = "talents/dwarf_resilience.png",
	desc = _t"Dwarven Resilience",
	long_desc = function(self, eff)
		if eff.mid_ac then
			return ("The target's skin turns to stone, granting %d armour, %d%% armour hardiness, %d physical save and %d spell save. Also applies %d armour to all non-physical damage."):tformat(eff.armor, eff.armor_hardiness, eff.physical, eff.spell, eff.mid_ac)
		else
			return ("The target's skin turns to stone, granting %d armour, %d%% armour hardiness, %d physical save and %d spell save."):tformat(eff.armor, eff.armor_hardiness, eff.physical, eff.spell)
		end
	end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { armor=10, armor_hardiness=20, spell=10, physical=10 },
	on_gain = function(self, err) return _t"#Target#'s skin turns to stone." end,
	on_lose = function(self, err) return _t"#Target#'s skin returns to normal." end,
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.armor)
		eff.hid = self:addTemporaryValue("combat_armor_hardiness", eff.armor_hardiness)
		eff.pid = self:addTemporaryValue("combat_physresist", eff.physical)
		eff.sid = self:addTemporaryValue("combat_spellresist", eff.spell)
		if self:knowTalent(self.T_STONE_FORTRESS) then
			local ac = self:combatArmor() * self:callTalent(self.T_STONE_FORTRESS, "getPercent")/ 100
			eff.mid_ac = ac
			eff.mid = self:addTemporaryValue("flat_damage_armor", {all=ac, [DamageType.PHYSICAL]=-ac})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
		self:removeTemporaryValue("combat_armor_hardiness", eff.hid)
		self:removeTemporaryValue("combat_physresist", eff.pid)
		self:removeTemporaryValue("combat_spellresist", eff.sid)
		if eff.mid then self:removeTemporaryValue("flat_damage_armor", eff.mid) end
	end,
}

newEffect{
	name = "STONE_LINK_SOURCE", image = "talents/stone_link.png",
	desc = _t"Stone Link",
	long_desc = function(self, eff) return ("The target protects all those around it in radius %d by redirecting all damage against them to itself."):tformat(eff.rad) end,
	type = "physical",
	subtype = { earth=true, shield=true },
	status = "beneficial",
	parameters = { rad=3 },
	on_gain = function(self, err) return ("#Target# begins protecting %s friends with a stone shield."):tformat(string.his_her(self)), _t"+Stone Link" end,
	on_lose = function(self, err) return _t"#Target# is no longer protecting anyone.", _t"-Stone Link" end,
	activate = function(self, eff)
		if core.shader.active() then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=eff.rad}, {type="shield", time_factor=4000, color={0.7, 0.4, 0.3}}))
		else
			eff.particle = self:addParticles(Particles.new("eldritch_stone", 1, {size_factor=eff.rad}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		self:project({type="ball", radius=eff.rad, selffire=false}, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:setEffect(target.EFF_STONE_LINK, 2, {src=self})
		end)
	end,
}

newEffect{
	name = "STONE_LINK", image = "talents/stone_link.png",
	desc = _t"Stone Link",
	long_desc = function(self, eff) return ("The target is protected by %s, redirecting all damage to it."):tformat(eff.src:getName()) end,
	type = "physical",
	subtype = { earth=true, shield=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return _t"#Target# is protected by a stone shield.", _t"+Stone Link" end,
	on_lose = function(self, err) return _t"#Target# is less protected.", _t"-Stone Link" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "EXHAUSTION", image = "talents/slumber.png",
	desc = _t"Exhaustion",
	long_desc = function(self, eff) return ("The target has recently performed an extreme feat of agility and is exhausted.  The stamina cost of activated Mobility talents is increased by %d%%."):tformat(eff.fatigue) end,
	type = "other",
	subtype = {tactic = true},
	status = "detrimental", no_stop_enter_worlmap = true,
	parameters = {fatigue = 50 },
	charges = function(self, eff) return math.round(eff.fatigue) end,
	on_timeout = function(self, eff)
		local turns = eff.dur
		if turns <= 1 then self:removeEffect(eff.effect_id) return end
		eff.fatigue = eff.fatigue*(turns - 1)/turns
	end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.fatigue = math.min(old_eff.fatigue + new_eff.fatigue)
		return new_eff
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MOBILE_DEFENCE", image = "talents/light_armour_training.png",
	desc = _t"Mobile Defense",
	long_desc = function(self, eff)
		local stam = eff.stamina > 0 and ("stamina regeneration by %0.1f and "):tformat(eff.stamina) or ""
		return ("Increases %sdefense by %d."):tformat(stam, eff.power)
	end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {stamina=1, power=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "combat_def", eff.power)
	end,
}

newEffect{
	name = "GHOULISH_LEAP", image = "talents/ghoulish_leap.png",
	desc = _t"Ghoulish Leap",
	long_desc = function(self, eff) return ("The target's global speed is increased by %d%%."):tformat(eff.speed * 100) end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { speed=0.1 },
	on_gain = function(self, err) return _t"#Target# speeds up.", _t"+Fast" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Fast" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.speed)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "FEINT", image = "talents/feint.png",
	desc = _t"Feint",
	long_desc = function(self, eff) return ("The target gains 1 extra parry opportunity each turn, and its chance to fail each parry is reduced by %d%%."):tformat(eff.parry_efficiency*100) end,
	type = "physical",
	subtype = { tactical=true },
	status = "beneficial",
	parameters = { power=0.1, parry_efficiency=0.1 },
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MANA_CLASH", image = "talents/mana_clash.png",
	desc = _t"Mana Clash",
	long_desc = function(self, eff) return ("All damage you do also trigget a manaburn for %d%% of the damage done."):tformat(eff.power * 100) end,
	type = "physical",
	subtype = { antimagic=true },
	status = "beneficial",
	parameters = { power=0.15 },
	on_gain = function(self, err) return _t"#Target# exudes antimagic forces.", true end,
	on_lose = function(self, err) return _t"#Target# is no longer toxic to arcane users.", true end,
	callbackOnDealDamage = function(self, eff, val, target, dead, death_note)
		if self._manaclashing then return end
		if not target.x or dead then return end
		self._manaclashing = true
		DamageType:get(DamageType.MANABURN).projector(self, target.x, target.y, DamageType.MANABURN, val * eff.power)
		self._manaclashing = nil
	end,
}

newEffect{
	name = "BULLSEYE", image = "talents/bullseye.png",
	desc = _t"Bullseye",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%."):tformat(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=0.1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.power)
	end,
}

newEffect{
	name = "TRUESHOT", image = "talents/trueshot.png",
	desc = _t"Trueshot",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%, grants infinite ammo, and causes all marking shots to have a 100%% increased chance to mark."):tformat(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=0.1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.power)
		self:effectTemporaryValue(eff, "infinite_ammo", 1)
		local h1x, h1y = self:attachementSpot("head", true)
		h1x, h1y = h1x or 0, h1y or 0
		self:effectParticles(eff, {type="circle", args={oversize=0.7, x=h1x, y=h1y-0.2, base_rot=0, a=220, shader=true, appear=12, img="true_shot_aura", speed=0, radius=0}})
	end,
}

newEffect{
	name = "ESCAPE", image = "talents/escape.png",
	desc = _t"Escape",
	long_desc = function(self, eff) return ("Focusing on defense and mobility, reducing all damage taken by %d%%, stamina regeneration by %0.1f and movement speed by %d%%. Melee and ranged attacks will break this effect."):tformat(eff.power, eff.stamina, eff.speed) end,
	type = "physical",
	subtype = { tactic=true, speed=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return _t"#Target# enters an evasive stance!", _t"+Escape!" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Escape" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.speed/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
		eff.stun = self:addTemporaryValue("stun_immune", 1)
		eff.daze = self:addTemporaryValue("daze_immune", 1)
		eff.pin = self:addTemporaryValue("pin_immune", 1)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
		eff.staid = self:addTemporaryValue("stamina_regen", eff.stamina)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
		self:removeTemporaryValue("resists", eff.pid)
		self:removeTemporaryValue("stamina_regen", eff.staid)
	end,
}

newEffect{
	name = "SENTINEL", image = "talents/sentinel.png",
	desc = _t"Sentinel",
	long_desc = function(self, eff) return ("Target is watched, causing the next talent used to fail and trigger a counterattack."):tformat() end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, _t"+Sentinel!" end,
	on_lose = function(self, err) return nil, _t"-Sentinel" end,
	do_proc = function(self, eff)
		eff.src:callTalent(eff.src.T_SENTINEL, "doShoot", eff)
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={299/255, 0/255, 0/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={229/255, 0/255, 0/255, 1}, circleColor={0.8,0,0,0.8}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "RAPID_MOVEMENT", image = "talents/rapid_shot.png",
	desc = _t"Rapid Movement",
	long_desc = function(self, eff) return ("Increases movement speed by %d%%."):tformat(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {power=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "movement_speed", eff.power)
	end,
}

newEffect{
	name = "STICKY_PITCH", image = "talents/sticky_smoke.png",
	desc = _t"Sticky Pitch",
	long_desc = function(self, eff) return ("The target's global speed is reduced by %d%% and fire resistance by %d%%."):tformat(eff.slow, eff.resist) end,
	type = "physical",
	subtype = { slow=true },
	status = "detrimental",
	parameters = { slow=0.1, resist=10 },
	on_gain = function(self, err) return _t"#Target# is covered in sticky, flammable pitch.", _t"+Pitch" end,
	on_lose = function(self, err) return _t"#Target# is free from the pitch.", _t"-Pitch" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.slow)
		eff.resid = self:addTemporaryValue("resists", {[DamageType.FIRE] = -eff.resist})
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=2, img="sticky_pitch_debuff_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=500, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeTemporaryValue("resists", eff.resid)
	end,
}


newEffect{
	name = "PUNCTURED_ARMOUR", image = "talents/piercing_ammunition.png",
	desc = _t"Punctured Armour",
	long_desc = function(self, eff) return ("Armour has been punctured, increasing all damage taken by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=20, },
	on_gain = function(self, err) return _t"#Target#'s armour is punctured!", _t"+Punctured Armour!" end,
	on_lose = function(self, err) return _t"#Target#'s armour is more intact.", _t"-Punctured Armour" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {all=-eff.power})
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="pierced_armour_debuff_aura", speed=0, radius=0}})
	end,
}

newEffect{
	name = "LEECHING_POISON", image = "talents/leeching_poison.png",
	desc = _t"Leeching Poison",
	long_desc = function(self, eff) return ("The target is poisoned, doing %0.2f nature damage per turn and restoring life to the attacker equal to the damage dealt."):tformat(eff.power) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, heal=5},
	on_gain = function(self, err) return _t"#Target# is poisoned!", _t"+Leeching Poison" end,
	on_lose = function(self, err) return _t"#Target# is no longer poisoned.", _t"-Leeching Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then 
			self:heal(eff.power, eff)
		else 
			local dam = DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
			local src = eff.src.resolveSource and eff.src:resolveSource()
			if src then src:heal(dam, self) end
		end
	end,
}

newEffect{
	name = "MAIM", image = "effects/deep_wound.png",
	desc = _t"Maim",
	long_desc = function(self, eff) return ("The target is maimed, doing %0.2f physical damage per turn. All damage it does is reduced by %d%%."):tformat(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { cut=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return _t"#Target# is maimed!", _t"+Maim" end,
	on_lose = function(self, err) return _t"#Target# is no longer maimed.", _t"-Maim" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:canBe("cut") then DamageType:get(DamageType.PHYSICAL).projector(eff.src, self.x, self.y, DamageType.PHYSICAL, eff.power) end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

newEffect{
	name = "SNIPE", image = "talents/snipe.png",
	desc = _t"Snipe",
	long_desc = function(self, eff) return ("The target is preparing a deadly sniper shot."):tformat() end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=50 },
	on_gain = function(self, err) return _t"#Target# takes aim...", _t"+Snipe" end,
	on_lose = function(self, err) return _t"#Target# is no longer aiming.", _t"-Snipe" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
		self:effectTemporaryValue(eff, "incoming_reduce", eff.power)

		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SNIPE)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SNIPE_FIRE}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_SNIPE_FIRE, true, 1, {no_unlearn=true})
		self.hotkey = ohk

		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="snipe_tentacles2"}, shader={type="tentacles", appearTime=0.6, time_factor=1600, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SNIPE_FIRE)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SNIPE}
			end
		end

		self:unlearnTalent(self.T_SNIPE_FIRE, 1, nil, {no_unlearn=true})
	end,
}

newEffect{
	name = "CONCEALMENT", image = "talents/concealment.png",
	desc = _t"Concealment",
	long_desc = function(self, eff) return ("The target is concealed, increasing sight and attack range by %d and chance to avoid damage by %d%%."):tformat(eff.sight, eff.power*eff.charges) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	charges = function(self, eff) return eff.charges end,
	parameters = { power=5, duration=1, sight=1, max_power=15, charges=3 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "cancel_damage_chance", eff.max_power)
		self:effectTemporaryValue(eff, "sight", eff.sight)
		self:effectTemporaryValue(eff, "infravision", eff.sight)
		self:effectTemporaryValue(eff, "heightened_senses", eff.sight)
		self:effectTemporaryValue(eff, "archery_bonus_range", eff.sight)
		self:doFOV()
	end,
	deactivate = function(self, eff)
		self:doFOV()
	end,
	on_timeout = function(self, eff)
		if not self:isTalentActive(self.T_CONCEALMENT) then 
			eff.charges = eff.charges -1
			eff.max_power = eff.power*eff.charges
			if eff.charges == 0 then self:removeEffect(self.EFF_CONCEALMENT) end
		end
	end,
}

newEffect{
	name = "SHADOW_SMOKE", image = "talents/shadow_shot.png",
	desc = _t"Shadow Smoke",
	long_desc = function(self, eff) return ("The target is wrapped in disorientating smoke, reducing vision range by %d."):tformat(eff.sight) end,
	type = "physical",
	subtype = { blind=true },
	status = "detrimental",
	parameters = { sight=5 },
	on_gain = function(self, err) return _t"#Target# is surrounded by a thick smoke.", _t"+Shadow Smoke" end,
	on_lose = function(self, err) return _t"The smoke around #target# dissipate.", _t"-Shadow Smoke" end,
	charges = function(self, eff) return -eff.sight end,
	activate = function(self, eff)
		if self:canBe("blind") then
			if self.sight - eff.sight < 1 then eff.sight = self.sight - 1 end
			eff.tmpid = self:addTemporaryValue("sight", -eff.sight)
			self:doFOV()
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="shadow_shot_debuff_tentacles"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		if eff.tmpid then 
			self:removeTemporaryValue("sight", eff.tmpid)
			self:doFOV()
		end
	end,
}

newEffect{
	name = "SHADOWSTRIKE", image = "talents/shadowstrike.png",
	desc = _t"Shadowstrike",
	long_desc = function(self, eff) return ("The target's critical strike damage bonus is increased by %d%%."):tformat(eff.power) end,
	type = "physical",
	subtype = { darkness=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return nil, true end,
	on_lose = function(self, err) return nil, true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_critical_power", eff.power)
	end,
}

-- Premptive Chromatic resistance
newEffect{
	name = "CHROMATIC_RESONANCE", image = "shockbolt/object/artifact/ureslaks_molted_scales.png",
	desc = _t"Chromatic Resonance",
	long_desc = function(self, eff)
		local dt_descs = table.concatNice(eff.type_descs, ", ", ", or ")
		return ("Preemptively reacts to %s damage, increasing the appropriate resistance by %d for 5 turns."):tformat(dt_descs, eff.power)
	end,
	type = "physical",
	subtype = { nature=true, resist=true },
	status = "beneficial",
	parameters = {power=15, resist_types={"FIRE", "COLD", "LIGHTNING", "NATURE", "DARKNESS"} },
	on_gain = function(self, err) return _t"#Target##OLIVE_DRAB# shimmers in multiple hues.", true end,
	on_lose = function(self, err) return _t"#Target#'s#OLIVE_DRAB# multi-hued shimmer fades.", true end,
	callbackOnTakeDamageBeforeResists = function(self, eff, src, x, y, type, dam, state)
		if dam > 0 and src ~= self and not self:hasEffect(self.EFF_CHROMATIC_RESISTANCE) then
			for i, r_type in ipairs(eff.resist_types) do
				if type == r_type then
					self:setEffect(self.EFF_CHROMATIC_RESISTANCE, 5, {type=type, power=eff.power})
					break
				end
			end
		end
		return {dam=dam}
	end,
	activate = function(self, eff)
		eff.type_descs = {}
		for i = #eff.resist_types, 1, -1 do
			local dt = DamageType[eff.resist_types[i]] and DamageType:get(eff.resist_types[i])
			if dt then
				table.insert(eff.type_descs, (dt.text_color or "#aaaaaa#")..dt.name:capitalize().."#LAST#")
			else table.remove(eff.resist_types, i)
			end
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="ureslak_tentacles"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
}

newEffect{
	name = "CHROMATIC_RESISTANCE", image = "shockbolt/object/artifact/ureslaks_molted_scales.png",
	desc = _t"Chromatic Resistance",
	long_desc = function(self, eff)
		local dt = DamageType[eff.type] and DamageType:get(eff.type)
		local type_desc = dt and ((dt.text_color or "#aaaaaa#")..dt.name:capitalize().."#LAST# ") or ""
		return ("%sresistance increased by %d%%."):tformat(type_desc, eff.power)
	end,
	type = "physical",
	subtype = { nature=true, resist=true },
	charges = function(self, eff) return eff.dtype.name:capitalize() end,
	status = "beneficial",
	parameters = { power=15 },
	on_gain = function(self, eff)
		local dt = DamageType[eff.type] and DamageType:get(eff.type)
		if dt then
			eff.dtype = dt
			return ("#Target##OLIVE_DRAB# resonates with %s%s#LAST# damage!"):tformat(dt.text_color or "#aaaaaa#", dt.name:capitalize() ), true
		else eff.type = nil
		end
	end,
	on_lose = function(self, eff)
		if eff.dtype then
			return ("#Target##OLIVE_DRAB# no longer resonates with %s%s#LAST# damage!"):tformat(eff.dtype.text_color or "#aaaaaa#", eff.dtype.name:capitalize() ), true
		end
	end,
	activate = function(self, eff)
		if eff.type then
			self:effectTemporaryValue(eff, "resists", {[eff.type] = eff.power})
		else
			self:removeEffect(eff.effect_id)
		end
	end,
}

newEffect{
	name = "SWIFT_SHOT", image = "talents/skirmisher_swift_shot.png",
	desc = _t"Swift Shot",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%."):tformat(eff.speed * 100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {speed=0.1},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed)
	end,
}

newEffect{ name = "CROOKED", image = "shockbolt/object/artifact/weapon_crooked_club.png",
	desc = _t"Crooked",
	long_desc = function(self, eff) return ("The target becomes more and more primitive, reducing accuracy and powers by %d"):tformat(eff.power*eff.stacks) end,
	type = "physical",
	subtype = { }, 
	status = "detrimental",
	parameters = { power=10, stacks=1, max_stacks=5 },
	
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.stacks = math.min(old_eff.stacks + new_eff.stacks, new_eff.max_stacks)
		self:removeTemporaryValue("combat_atk", old_eff.acc)
		self:removeTemporaryValue("combat_mindpower", old_eff.mental)
		self:removeTemporaryValue("combat_spellpower", old_eff.spell)
		self:removeTemporaryValue("combat_dam", old_eff.physical)	
		old_eff.acc = self:addTemporaryValue("combat_atk", -old_eff.power*old_eff.stacks)
		old_eff.mental = self:addTemporaryValue("combat_mindpower", -old_eff.power*old_eff.stacks)
		old_eff.spell = self:addTemporaryValue("combat_spellpower", -old_eff.power*old_eff.stacks)
		old_eff.physical = self:addTemporaryValue("combat_dam", -old_eff.power*old_eff.stacks)	
		return old_eff
		
	end,
	
	activate = function(self, eff)		
		eff.acc = self:addTemporaryValue("combat_atk", -eff.power*eff.stacks )
		eff.mental = self:addTemporaryValue("combat_mindpower", -eff.power*eff.stacks)
		eff.spell = self:addTemporaryValue("combat_spellpower", -eff.power*eff.stacks)
		eff.physical = self:addTemporaryValue("combat_dam", -eff.power*eff.stacks)
	end,
	
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.acc)
		self:removeTemporaryValue("combat_mindpower", eff.mental)
		self:removeTemporaryValue("combat_spellpower", eff.spell)
		self:removeTemporaryValue("combat_dam", eff.physical)
	end,
}

newEffect{
	name = "ELDORAL", image = "talents/uncanny_reload.png",
	desc = _t"Eldoral",
	long_desc = function(self, eff) return ("Firing slings does not consume shots."):tformat() end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { speed = 20, fatigue = 100},
	on_gain = function(self, err) return _t"#Target# is focused on firing.", _t"+Eldoral" end,
	on_lose = function(self, err) return _t"#Target# is less focused.", _t"-Eldoral" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "infinite_ammo", 1)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed/100)
		self:effectTemporaryValue(eff, "fatigue", -eff.fatigue)
	end,
}

newEffect{
	name = "SILENT_STEALTH", image = "talents/stealth.png",
	desc = _t"Stealthed",
	long_desc = function(self, eff) return ("Gain %d stealth power"):tformat(eff.power) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { power = 30 },
	on_gain = function(self, err) return _t"#Target# is more stealthy.", _t"+Silent stealth" end,
	on_lose = function(self, err) return _t"#Target# is visible again.", _t"-Silent stealth" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stealth", eff.power)
	end,
}

newEffect{
	name = "FORGONE_VISION", image = "effects/blinded.png",
	desc = _t"Blinded",
	long_desc = function(self, eff) return _t"The target is blinded, unable to see anything." end,
	type = "other",
	subtype = {},
	status = "detrimental",
	parameters = {power = 2},
	on_lose = function(self, err) return _t"#Target# recovers sight.", _t"-Blind" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("blind", 1)
		eff.blind = self:addTemporaryValue("blind_immune", eff.power) --Lets the player control blinds for the duration--
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blind", eff.tmpid)
		self:removeTemporaryValue("blind_immune", eff.blind)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	callbackOnTakeoff = function(self, eff, o)
		if o.name and o.name == "Yaldan Baoth" then
			self:removeEffect(self.EFF_FORGONE_VISION)
		end
	end,
}

newEffect{
	name = "GIFT_WOODS", image = "talents/thaloren_wrath.png",
	desc = _t"Gift of the Woods",
	long_desc = function(self, eff) return ("Increases the effectiveness of all healing the target receives by %d%%."):tformat(eff.power * 100) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power = 0.1 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("healing_factor", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.tmpid)
	end,
}

newEffect{
	name = "INTANGIBILITY", image = "talents/intangibility.png",
	desc = _t"Intangible",
	long_desc = function(self, eff) return ("%d%% chance to fully evade any damaging actions or negative effects."):tformat(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("cancel_damage_chance", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("cancel_damage_chance", eff.tmpid)
	end,
	callbackOnTemporaryEffect = function(self, eff, eff_id, e, p)
		if e.status ~= "detrimental" or e.type == "other" or not rng.percent(eff.power) then return end
		game.logSeen(self, "#LIGHT_BLUE#%s evades the effect '%s'!", self.name:capitalize(), e.desc)
		p.dur = 0
		return true
	end,
}
