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

require "engine.class"
local DamageType = require "engine.DamageType"
local Map = require "engine.Map"
local Chat = require "engine.Chat"
local Target = require "engine.Target"
local Talents = require "engine.interface.ActorTalents"

--- Interface to add ToME combat system
module(..., package.seeall, class.make)

--- Checks what to do with the target
-- Talk ? attack ? displace ?
function _M:bumpInto(target, x, y)
	local reaction = self:reactionToward(target)
	if reaction < 0 then -- attack target if possible
		if target.encounterAttack and self.player then self:onWorldEncounter(target, x, y) return end
		if game.player == self and ((not config.settings.tome.actor_based_movement_mode and game.bump_attack_disabled) or (config.settings.tome.actor_based_movement_mode and self.bump_attack_disabled)) then return end
		return self:enoughEnergy() and self:useTalent(self.T_ATTACK, nil, nil, nil, target)
	elseif reaction >= 0 then
		-- Talk ? Bump ?
		if self.player and target.on_bump then
			target:on_bump(self)
		elseif self.player and target.can_talk then
			local chat = Chat.new(target.can_talk, target, self, {npc=target, player=self})
			chat:invoke()
			if target.can_talk_only_once then target.can_talk = nil end
		elseif target.player and self.can_talk then
			local chat = Chat.new(self.can_talk, self, target, {npc=self, player=target})
			chat:invoke()
			if target.can_talk_only_once then target.can_talk = nil end
		elseif self.player or (self ~= game.player and self.canBumpDisplace and self:canBumpDisplace(target)) then  -- canBumpDisplace is only on NPCs
			-- Check we can both walk in the tile we will end up in
			local blocks = game.level.map:checkAllEntitiesLayersNoStop(target.x, target.y, "block_move", self)
			for kind, v in pairs(blocks) do if kind[1] ~= Map.ACTOR and v then return end end
			blocks = game.level.map:checkAllEntitiesLayersNoStop(self.x, self.y, "block_move", target)
			for kind, v in pairs(blocks) do if kind[1] ~= Map.ACTOR and v then return end end

			-- Displace
			local tx, ty, sx, sy = target.x, target.y, self.x, self.y
			target:move(sx, sy, true)
			self:move(tx, ty, true)
			if target.describeFloor then target:describeFloor(target.x, target.y, true) end
			if self.describeFloor then self:describeFloor(self.x, self.y, true) end

			local eff = self:hasEffect(self.EFF_CURSE_OF_SHROUDS) if eff then eff.moved = true end
			eff = target:hasEffect(target.EFF_CURSE_OF_SHROUDS) if eff then eff.moved = true end

			local energy = game.energy_to_act * self:combatMovementSpeed(x, y)
			if self:attr("bump_swap_speed_divide") then
				energy = energy / self:attr("bump_swap_speed_divide")
			end
			self:useEnergy(energy)
			self.did_energy = true
		end
	end
end

--- Makes the death happen!
--[[
The ToME combat system has the following attributes:
- attack: increases chances to hit against high defense
- defense: increases chances to miss against high attack power
- armor: direct reduction of damage done
- armor penetration: reduction of target's armor
- damage: raw damage done
]]
-- Attempts to attack a target with all melee weapons (calls self:attackTargetWith for each)
-- @param target - target actor
-- @param damtype a damage type ID <PHYSICAL>
-- @param mult a damage multiplier <1>
-- @noenergy if true the attack uses no energy
-- @force_unarmed if true the attacker uses unarmed (innate) combat parameters
-- @return true if an attack hit the target, false otherwise
function _M:attackTarget(target, damtype, mult, noenergy, force_unarmed)
	local speed, hit = nil, false
	local sound, sound_miss = nil, nil

	-- Break before we do the blow, because it might start step up, we dont want to insta-cancel it
	self:breakStepUp()
	self:breakSpacetimeTuning()

	if self:attr("feared") then
		if not noenergy then
			self:useEnergy(game.energy_to_act)
			self.did_energy = true
		end
		game.logSeen(self, "%s is too afraid to attack.", self:getName():capitalize())
		return false
	end

	if self:attr("terrified") and rng.percent(self:attr("terrified")) then
		if not noenergy then
			self:useEnergy(game.energy_to_act)
			self.did_energy = true
		end
		game.logSeen(self, "%s is too terrified to attack.", self:getName():capitalize())
		return false
	end

	-- Cancel stealth early if we are noticed
	if self:attr("stealth") and target:canSee(self) then
		self:breakStealth()
		if self.player then self:logCombat(target, "#Target# notices you at the last moment!") end
	end

--	if target:isTalentActive(target.T_INTUITIVE_SHOTS) and rng.percent(target:callTalent(target.T_INTUITIVE_SHOTS, "getChance")) then
--		local ret = target:callTalent(target.T_INTUITIVE_SHOTS, "proc", self)
--		if ret then return false end
--	end

	if not target.turn_procs.warding_weapon and target:knowTalent(target.T_WARDING_WEAPON) and target:getTalentLevelRaw(target.T_WARDING_WEAPON) >= 5
		and rng.percent(target:callTalent(target.T_WARDING_WEAPON, "getChance")) then
		local t = self:getTalentFromId(self.T_WARDING_WEAPON)
		if target:getPsi() >= t.psi then
			target:setEffect(target.EFF_WEAPON_WARDING, 1, {})
			target.turn_procs.warding_weapon = true
			target:incPsi(-t.psi)
		end
	end

	-- Change attack type if using gems
	if not damtype and self:getInven(self.INVEN_GEM) then
		local gems = self:getInven(self.INVEN_GEM)
		local types = {}
		for i = 1, #gems do
			local damtype = table.get(gems[i], 'color_attributes', 'damage_type')
			if damtype then table.insert(types, damtype) end
		end
		if #types > 0 then
			damtype = rng.table(types)
		end
	elseif not damtype and self:attr("force_melee_damage_type") then
		damtype = self:attr("force_melee_damage_type")
	end

	local break_stealth = false

	local hd = {"Combat:attackTarget", target=target, damtype=damtype, mult=mult, noenergy=noenergy}
	if self:triggerHook(hd) then
		speed, hit, damtype, mult = hd.speed, hd.hit, hd.damtype, hd.mult
		if hd.stop then return hit end
	end
	-- Could add callback here:
	-- self:fireTalentCheck("callbackOnMeleeAttackTarget", hd)

	if not speed and self:isTalentActive(self.T_GESTURE_OF_PAIN) then
		if self.no_gesture_of_pain_recurse then return false end
		print("[ATTACK] attacking with Gesture of Pain")
		local t = self:getTalentFromId(self.T_GESTURE_OF_PAIN)
		if not t.preAttack(self, t, target) then return false end
		self.no_gesture_of_pain_recurse = true
		speed, hit = t.attack(self, t, target)
		self.no_gesture_of_pain_recurse = nil
		break_stealth = true
	end

	local totaldam = 0

	if not speed and not self:attr("disarmed") and not self:isUnarmed() and not force_unarmed then
		local double_weapon
		-- All weapons in main hands
		if self:getInven(self.INVEN_MAINHAND) then
			for i, o in ipairs(self:getInven(self.INVEN_MAINHAND)) do
				local combat = self:getObjectCombat(o, "mainhand")
				if combat and not o.archery then
					if o.double_weapon and not double_weapon then double_weapon = o end
					print("[ATTACK] attacking with (mainhand)", o.name)
					local s, h, _curdam = self:attackTargetWith(target, combat, damtype, mult)
					if _curdam then totaldam = totaldam + _curdam end
					speed = math.max(speed or 0, s)
					hit = hit or h
					if hit and not sound then sound = combat.sound
					elseif not hit and not sound_miss then sound_miss = combat.sound_miss end
					if not combat.no_stealth_break then break_stealth = true end
				end
			end
		end
		-- All weapons in off hands
		local oh_weaps, offhand = table.clone(self:getInven(self.INVEN_OFFHAND)) or {}, false
		-- Offhand attacks are with a damage penalty, that can be reduced by talents
		if double_weapon then oh_weaps[#oh_weaps+1] = double_weapon end -- use double weapon as OFFHAND if there are no others
		for i = 1, #oh_weaps do
			if i == #oh_weaps and double_weapon and offhand then break end
			local o = oh_weaps[i]
			local combat = self:getObjectCombat(o, "offhand")
			local offmult = self:getOffHandMult(combat, mult)
			
			-- no offhand unarmed attacks
			if combat and not o.archery then
				if combat.use_resources and not self:useResources(combat.use_resources, true) then
					print("[ATTACK] Cancelling attack (offhand) with", o.name , "(resources)")
				else
					offhand = true
					print("[ATTACK] attacking with (offhand)", o.name)
					local s, h, _curdam = self:attackTargetWith(target, combat, damtype, offmult)
					if _curdam then totaldam = totaldam + _curdam end
					speed = math.max(speed or 0, s)
					hit = hit or h
					if hit and not sound then sound = combat.sound
					elseif not hit and not sound_miss then sound_miss = combat.sound_miss end
					if not combat.no_stealth_break then break_stealth = true end
				end
			end
		end
	end

	-- Barehanded ?
	if not speed and self.combat then
		print("[ATTACK] attacking with innate combat")
		local combat = self:getObjectCombat(nil, "barehand")
		local s, h, _curdam = self:attackTargetWith(target, combat, damtype, mult)
		if _curdam then totaldam = totaldam + _curdam end
		speed = math.max(speed or 0, s)
		hit = hit or h
		if hit and not sound then sound = combat.sound
		elseif not hit and not sound_miss then sound_miss = combat.sound_miss end
		if not combat.no_stealth_break then break_stealth = true end
	end

	-- We use up our own energy
	if speed and not noenergy then
		self:useEnergy(game.energy_to_act * speed)
		self.did_energy = true
	end

	if sound then game:playSoundNear(self, sound)
	elseif sound_miss then game:playSoundNear(self, sound_miss) end

	game:playSoundNear(self, self.on_hit_sound or "actions/melee_hit_squish")
	if self.sound_moam and rng.chance(7) then game:playSoundNear(self, self.sound_moam) end

	-- cleave second attack
	if self:isTalentActive(self.T_CLEAVE) then
		local t = self:getTalentFromId(self.T_CLEAVE)
		t.on_attackTarget(self, t, target)
	end

	-- Cancel stealth!
	if break_stealth then self:breakStealth() end
	self:breakLightningSpeed()
	return hit, totaldam
end

--- Determines the combat field to use for this item
function _M:getObjectCombat(o, kind)
	if kind == "barehand" then return self.combat end
	if not o then return nil end
	if kind == "mainhand" and o.type == "armor" and o.subtype == "shield" and self:knowTalent(self.T_STONESHIELD) then return o.special_combat end
	if kind == "offhand" and o.type == "armor" and o.subtype == "shield" and self:knowTalent(self.T_STONESHIELD) then return o.special_combat end
	if kind == "mainhand" then return o.combat end
	if kind == "offhand" then return o.combat end
	return nil
end

--- Computes a logarithmic chance to hit, opposing chance to hit to chance to miss
-- This will be used for melee attacks, physical and spell resistance
function _M:checkHitOld(atk, def, min, max, factor)
	if atk < 0 then atk = 0 end
	if def < 0 then def = 0 end
	print("checkHitOld", atk, def)
	if atk == 0 then atk = 1 end
	local hit = nil
	factor = factor or 5

	local one = 1 / (1 + math.exp(-(atk - def) / 7))
	local two = 0
	if atk + def ~= 0 then two = atk / (atk + def) end
	hit = 50 * (one + two)

	hit = util.bound(hit, min or 5, max or 95)
	print("=> chance to hit", hit)
	return rng.percent(hit), hit
end

--- Applies crossTierEffects according to the tier difference between power and save
function _M:crossTierEffect(eff_id, apply_power, apply_save, use_given_e)
	local q = game.player:hasQuest("tutorial-combat-stats")
	if q and not q:isCompleted("final-lesson")then
		return
	end
	local ct_effect
	local save_for_effects = {
		physical = "combatPhysicalResist",
		magical = "combatSpellResist",
		mental = "combatMentalResist",
	}
	local cross_tier_effects = {
		combatPhysicalResist = self.EFF_OFFBALANCE,
		combatSpellResist = self.EFF_SPELLSHOCKED,
		combatMentalResist = self.EFF_BRAINLOCKED,
	}
	local e = self.tempeffect_def[eff_id]
	if not apply_power or not save_for_effects[e.type] then return end
	local save = self[apply_save or save_for_effects[e.type]](self, true)

	if use_given_e then
		ct_effect = self["EFF_"..e.name]
	else
		ct_effect = cross_tier_effects[save_for_effects[e.type]]
	end
	local dur = self:getTierDiff(apply_power, save)
	self:setEffect(ct_effect, dur, {})
	return ct_effect
end

function _M:getTierDiff(atk, def)
	atk = math.floor(atk)
	def = math.floor(def)
	return math.max(0, math.max(math.ceil(atk/20), 1) - math.max(math.ceil(def/20), 1))
end
--[[
--- Gets the duration for crossTier effects based on the tier difference between atk and def
function _M:getTierDiff(atk, def)
	return math.floor(math.max(0, self:combatScale(atk - def, 1, 20, 5, 100)))
end
--]]
--New, simpler checkHit that relies on rescaleCombatStats() being used elsewhere
function _M:checkHit(atk, def, min, max, factor, p)
	if atk < 0 then atk = 0 end
	if def < 0 then def = 0 end
	local min = min or 0
	local max = max or 100
	if game.player:hasQuest("tutorial-combat-stats") then
		min = 0
		max = 100
	end --ensures predictable combat for the tutorial
	local hit = math.ceil(50 + 2.5 * (atk - def))
	hit = util.bound(hit, min, max)
	print("checkHit", atk, "vs", def, "=> chance to hit", hit)
	return rng.percent(hit), hit
end

--- Try to totally evade an attack
function _M:checkEvasion(target)
	local evasion = target:attr("evasion")
	if target:knowTalent(target.T_ARMOUR_OF_SHADOWS) and not game.level.map.lites(target.x, target.y) then
		evasion = (evasion or 0) + 20
	end

	if not evasion or self == target then return end
	if target:attr("no_evasion") then return end

	print("checkEvasion", evasion, target.level, self.level)
	print("=> evasion chance", evasion)
	return rng.percent(evasion)
end

function _M:getAccuracyEffect(weapon, atk, def, scale, max)
	max = max or 10000000
	scale = scale or 1
	return math.min(max, math.max(0, atk - def) * scale * (weapon.accuracy_effect_scale and 0.5 or 1))
end

function _M:isAccuracyEffect(weapon, kind)
	if not weapon then return false, "none" end
	local eff = weapon.accuracy_effect or weapon.talented
	return eff == kind, eff
end

--- Attacks with one weapon
function _M:attackTargetWith(target, weapon, damtype, mult, force_dam)
	-- if insufficient resources, try to use unarmed or cancel attack
	local unarmed = self:getObjectCombat(nil, "barehand")
	local weapon_or_unarmed = weapon or unarmed
	if weapon_or_unarmed and weapon_or_unarmed.use_resources and not self:useResources(weapon_or_unarmed.use_resources) then
		if unarmed == weapon then
			print("[attackTargetWith] (unarmed) against ", target.name, "unarmed attack fails due to resources")
			return self:combatSpeed(unarmed), false, 0
		else
			weapon = unarmed
			print("[attackTargetWith] against ", target.name, "insufficient weapon resources, using unarmed combat")
			if weapon.use_resources and not self:useResources(weapon.use_resources) then
				print("[attackTargetWith] against ", target.name, "unarmed attack fails due to resources")
				return self:combatSpeed(weapon), false, 0
			end
		end
	end
	damtype = damtype or (weapon and weapon.damtype) or DamageType.PHYSICAL
	mult = mult or 1

	if self:attr("force_melee_damtype") then
		damtype = self.force_melee_damtype
	end

	--Life Steal
	if weapon and weapon.lifesteal then
		self:attr("lifesteal", weapon.lifesteal)
		self:attr("silent_heal", 1)
	end

	local mode = "other"
	if self:hasShield() then mode = "shield"
	elseif self:hasTwoHandedWeapon() then mode = "twohanded"
	elseif self:hasDualWeapon() then mode = "dualwield"
	end
	self.turn_procs.weapon_type = {kind=weapon and weapon.talented or "unknown", mode=mode}

	-- Does the blow connect? yes .. complex :/
	local atk, def = self:combatAttack(weapon), target:combatDefense()

	-- add stalker damage and attack bonus
	local effStalker = self:hasEffect(self.EFF_STALKER)
	if effStalker and effStalker.target == target then
		local t = self:getTalentFromId(self.T_STALK)
		atk = atk + t.getAttackChange(self, t, effStalker.bonus)
		mult = mult * t.getStalkedDamageMultiplier(self, t, effStalker.bonus)
	end

	-- Predator atk bonus
	if self:knowTalent(self.T_PREDATOR) then
		if target and target.type and self.predator_type_history and self.predator_type_history[target.type] then
			local typebonus = self.predator_type_history[target.type]
			local t = self:getTalentFromId(self.T_PREDATOR)
			atk = atk + t.getATK(self, t) * typebonus
		end
	end


	local dam, apr, armor = force_dam or self:combatDamage(weapon), self:combatAPR(weapon), target:combatArmor()
	print("[ATTACK] to ", target.name, "dam/apr/atk/mult ::", dam, apr, atk, mult, "vs. armor/def", armor, def)

	-- check repel
	local repelled = false
	if target:isTalentActive(target.T_REPEL) then
		local t = target:getTalentFromId(target.T_REPEL)
		repelled = t.isRepelled(target, t)
	end

	-- melee attack bonus hooks/callbacks  Note: These are post rescaleCombatStats
	local hd = {"Combat:attackTargetWith:attackerBonuses", target=target, weapon=weapon, damtype=damtype, mult=mult, dam=dam, apr=apr, atk=atk, def=def, armor=armor}
	self:triggerHook(hd)
	self:fireTalentCheck("callbackOnMeleeAttackBonuses", hd)
	target, weapon, damtype, mult, dam, apr, atk, def, armor = hd.target, hd.weapon, hd.damtype, hd.mult, hd.dam, hd.apr, hd.atk, hd.def, hd.armor
	if hd.stop then return end
	print("[ATTACK] after melee attack bonus hooks & callbacks::", dam, apr, atk, mult, "vs. armor/def", armor, def)

	-- If hit is over 0 it connects, if it is 0 we still have 50% chance
	local hitted = false
	local crit = false
	local evaded = false
	local deflect = 0
	local old_target_life = target.life

	if target:knowTalent(target.T_SKIRMISHER_BUCKLER_EXPERTISE) then
		local t = target:getTalentFromId(target.T_SKIRMISHER_BUCKLER_EXPERTISE)
		if t.shouldEvade(target, t) then
			game.logSeen(target, "#ORCHID#%s cleverly deflects the attack with %s shield!#LAST#", target:getName():capitalize(), string.his_her(target))
			t.onEvade(target, t, self)
			repelled = true
		end
	end

	if target:hasEffect(target.EFF_WEAPON_WARDING) then
		local e = target.tempeffect_def[target.EFF_WEAPON_WARDING]
		if e.do_block(target, target.tmp[target.EFF_WEAPON_WARDING], self) then
			repelled = true
		end
	end

	if target:knowTalent(target.T_BLADE_WARD) and target:hasDualWeapon() then
		local chance = target:callTalent(target.T_BLADE_WARD, "getChance")
		if rng.percent(chance) then
			game.logSeen(target, "#ORCHID#%s parries the attack with %s dual weapons!#LAST#", target:getName():capitalize(), string.his_her(target))
			repelled = true
		end
	end

	if target:isTalentActive(target.T_INTUITIVE_SHOTS) then
		local chance = target:callTalent(target.T_INTUITIVE_SHOTS, "getChance")
		repelled = target:callTalent(target.T_INTUITIVE_SHOTS, "proc", self)
	end

	-- Dwarves stoneskin
	if target:attr("auto_stoneskin") and rng.percent(15) then
		game.logSeen(target, "#ORCHID#%s instinctively hardens %s skin and ignores the attack!#LAST#", target:getName():capitalize(), string.his_her(target))
		target:setEffect(target.EFF_STONE_SKIN, 5, {power=target:attr("auto_stoneskin")})
		repelled = true
	end

	local no_procs = false

	if repelled then
		self:logCombat(target, "#Target# repels an attack from #Source#.")
	elseif self:checkEvasion(target) then
		evaded = true
		self:logCombat(target, "#Target# evades #Source#.")
	elseif self.turn_procs.auto_melee_hit or (self:checkHit(atk, def) and (self:canSee(target) or self:attr("blind_fight") or target:attr("blind_fighted") or rng.chance(3))) then
		local pres = util.bound(target:combatArmorHardiness() / 100, 0, 1)

		-- Apply weapon damage range
		-- By doing this first, variable damage is more "smooth" against high armor
		local damrange = self:combatDamageRange(weapon)
		dam = rng.range(dam, dam * damrange)
		print("[ATTACK] HIT:: damrange", damrange, "==> dam/apr::", dam, apr, "vs. armor/hardiness", armor, pres)

		if self:isAccuracyEffect(weapon, "mace") then
			local bonus = 1 + self:getAccuracyEffect(weapon, atk, def, 0.002, 0.2)  -- +20% base damage at 100 accuracy
			print("[ATTACK] mace accuracy bonus", atk, def, "=", bonus)
			dam = dam * bonus
		end

		local eff = target.knowTalent and target:hasEffect(target.EFF_PARRY)
		-- check if target deflects the blow (deflected blows cannot crit)
		if eff then
			deflect = target:callEffect(target.EFF_PARRY, "doDeflect", self) or 0
			if deflect > 0 then
				game:delayedLogDamage(self, target, 0, ("%s(%d parried#LAST#)"):tformat(DamageType:get(damtype).text_color or "#aaaaaa#", deflect), false)
				dam = math.max(dam - deflect , 0)
				print("[ATTACK] after PARRY", dam)
			end
		end

		if target.knowTalent and target:hasEffect(target.EFF_GESTURE_OF_GUARDING) and not target:attr("encased_in_ice") then
			local g_deflect = math.min(dam, target:callTalent(target.T_GESTURE_OF_GUARDING, "doGuard")) or 0
			if g_deflect > 0 then
				game:delayedLogDamage(self, target, 0, ("%s(%d gestured#LAST#)"):tformat(DamageType:get(damtype).text_color or "#aaaaaa#", g_deflect), false)
				dam = dam - g_deflect; deflect = deflect + g_deflect
			end
			print("[ATTACK] after GESTURE_OF_GUARDING", dam)
		end

		-- Predator apr bonus
		if self:knowTalent(self.T_PREDATOR) then
			if target and target.type and self.predator_type_history and self.predator_type_history[target.type] then
				local typebonus = self.predator_type_history[target.type]
				local t = self:getTalentFromId(self.T_PREDATOR)
				apr = apr + t.getAPR(self, t) * typebonus
			end
		end

		if self:isAccuracyEffect(weapon, "knife") then
			local bonus = 1 + self:getAccuracyEffect(weapon, atk, def, 0.005, 0.5)  -- +50% APR bonus at 100 accuracy
			apr = apr * bonus
			print("[ATTACK] dagger accuracy bonus", atk, def, "=", bonus, "apr ==>", apr)
		end

		local hd = {"Combat:attackTargetWith:beforeArmor", target=target, weapon=weapon, damtype=damtype, mult=mult, dam=dam, apr=apr, atk=atk, def=def, armor=armor}
		if self:triggerHook(hd) then
			dam = hd.dam
			damtype = hd.damtype
			apr = hd.apr
			armor = hd.armor
			mult = hd.mult
			no_procs = hd.no_procs
		end

		armor = math.max(0, armor - apr)
		dam = math.max(dam * pres - armor, 0) + (dam * (1 - pres))
		print("[ATTACK] after armor", dam)

		if deflect == 0 then dam, crit = self:physicalCrit(dam, weapon, target, atk, def) end
		print("[ATTACK] after crit", dam)
		dam = dam * mult
		print("[ATTACK] after mult", dam)

		if target:hasEffect(target.EFF_COUNTERSTRIKE) and not self:attr("ignore_counterstrike") then
			dam = target:callEffect(target.EFF_COUNTERSTRIKE, "onStrike", dam, self)
			print("[ATTACK] after counterstrike", dam)
		end

		if weapon and weapon.inc_damage_type then
			local inc = 0

			for k, v in pairs(weapon.inc_damage_type) do
				if target:checkClassification(tostring(k)) then inc = math.max(inc, v) end
			end
			dam = dam + dam * inc / 100

			--for t, idt in pairs(weapon.inc_damage_type) do
				--if target.type.."/"..target.subtype == t or target.type == t then dam = dam + dam * idt / 100 break end
			--end
			print("[ATTACK] after inc by type", dam)
		end

		if crit then self:logCombat(target, "#{bold}##Source# performs a melee critical strike against #Target#!#{normal}#") end

		-- Phasing, percent of weapon damage bypasses shields
		-- It's done like this because onTakeHit has no knowledge of the weapon
		if weapon and weapon.phasing then
			self:attr("damage_shield_penetrate", weapon.phasing)
		end

		local oldproj = DamageType:getProjectingFor(self)
		if self.__talent_running then DamageType:projectingFor(self, {project_type={talent=self.__talent_running}}) end

		if weapon and weapon.crushing_blow then self:attr("crushing_blow", 1) end

		-- Convert base damage to other types according to weapon
		local total_conversion = 0
		local melee_state = {is_melee=true}
		if weapon and weapon.convert_damage and dam > 0 then
			local conv_dam
			for typ, conv in pairs(weapon.convert_damage) do
				conv_dam = math.min(dam, dam * (conv / 100))
				print("[ATTACK]\tDamageType conversion%", conv, typ, conv_dam)
				total_conversion = total_conversion + conv_dam
				if conv_dam > 0 then
					DamageType:get(typ).projector(self, target.x, target.y, typ, math.max(0, conv_dam), melee_state)
				end
			end
			dam = dam - total_conversion
			print("[ATTACK]\t after DamageType conversion dam:", dam)
		end
		if dam > 0 then
			DamageType:get(damtype).projector(self, target.x, target.y, damtype, math.max(0, dam), melee_state)
		end

		if weapon and weapon.crushing_blow then self:attr("crushing_blow", -1) end

		if self.__talent_running then DamageType:projectingFor(self, oldproj) end

		-- remove phasing
		if weapon and weapon.phasing then
			self:attr("damage_shield_penetrate", -weapon.phasing)
		end

		-- add damage conversion back in so the total damage still gets passed
		dam = dam + total_conversion

		target:fireTalentCheck("callbackOnMeleeHit", self, dam)

		hitted = true

		if self:attr("vim_on_melee") and self ~= target then self:incVim(self:attr("vim_on_melee")) end
	else
		self:logCombat(target, "#Source# misses #Target#.")
		target:fireTalentCheck("callbackOnMeleeMiss", self, dam)
	end

	-- cross-tier effect for accuracy vs. defense
--[[
	local tier_diff = self:getTierDiff(atk, target:combatDefense(false, target:attr("combat_def_ct")))
	if hitted and not target.dead and tier_diff > 0 then
		local reapplied = false
		-- silence the apply message it if the target already has the effect
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.desc == "Off-guard" then
				reapplied = true
			end
		end
		target:setEffect(target.EFF_OFFGUARD, tier_diff, {}, reapplied)
	end
]]

	if not no_procs then
		hitted = self:attackTargetHitProcs(target, weapon, dam, apr, armor, damtype, mult, atk, def, hitted, crit, evaded, repelled, old_target_life)
	end

	-- Visual feedback
	if hitted then game.level.map:particleEmitter(target.x, target.y, 1, "melee_attack", {color=target.blood_color}) end
	if Map.tiles and Map.tiles.use_images then if self.x and target.x then if target.x < self.x then self:MOflipX(self:isTileFlipped()) elseif target.x > self.x then self:MOflipX(not self:isTileFlipped()) end end end

	self.turn_procs.weapon_type = nil

	--Life Steal
	if weapon and weapon.lifesteal then
		self:attr("lifesteal", -weapon.lifesteal)
		self:attr("silent_heal", -1)
	end

	if weapon and weapon.attack_recurse then
		if self.__attacktargetwith_recursing then
			self.__attacktargetwith_recursing = self.__attacktargetwith_recursing - 1
		else
			self.__attacktargetwith_recursing = weapon.attack_recurse - 1
			self.__attacktargetwith_recursing_procs_reduce = weapon.attack_recurse_procs_reduce
		end

		if self.__attacktargetwith_recursing > 0 and not self.turn_procs._no_melee_recursion then
			local _, newhitted, newdam = self:attackTargetWith(target, weapon, damtype, mult, force_dam)
			hitted = newhitted or hitted
			dam = math.max(dam, newdam)
		else
			self.__attacktargetwith_recursing = nil
			self.__attacktargetwith_recursing_procs_reduce = nil
		end
	end

	return self:combatSpeed(weapon), hitted, dam
end

--- handle various on hit procs for melee combat
function _M:attackTargetHitProcs(target, weapon, dam, apr, armor, damtype, mult, atk, def, hitted, crit, evaded, repelled, old_target_life)
	if self:isAccuracyEffect(weapon, "staff") then
		local bonus = 1 + self:getAccuracyEffect(weapon, atk, def, 0.02, 2)  -- +200% proc damage at 100 accuracy
		print("[ATTACK] staff accuracy bonus", atk, def, "=", bonus)
		self.__global_accuracy_damage_bonus = bonus
	end
	if self:attr("hit_penalty_2h") then
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus or 1
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus * 0.5
	end
	if self.__attacktargetwith_recursing_procs_reduce then
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus or 1
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus / self.__attacktargetwith_recursing_procs_reduce
	end

	if self:attr("unharmed_attack_on_hit") then
		local v = self:attr("unharmed_attack_on_hit")
		self:attr("unharmed_attack_on_hit", -v)
		if rng.percent(50) then self:attackTarget(target, nil, 1, true, true) end
		self:attr("unharmed_attack_on_hit", v)
	end

	-- handle stalk targeting for hits (also handled in Actor for turn end effects)
	if hitted and target ~= self then
		local effStalker = self:hasEffect(self.EFF_STALKER)
		if effStalker then
			-- mark if stalkee was hit
			effStalker.hit = effStalker.hit or effStalker.target == target
		elseif self:isTalentActive(self.T_STALK) then
			local stalk = self:isTalentActive(self.T_STALK)

			if not stalk.hit then
				-- mark a new target
				stalk.hit = true
				stalk.hit_target = target
			elseif stalk.hit_target ~= target then
				-- more than one target; clear it
				stalk.hit_target = nil
			end
		end
	end

	-- Spread diseases
	if hitted and self:knowTalent(self.T_CARRIER) and rng.percent(self:callTalent(self.T_CARRIER, "getDiseaseSpread")) then
		-- Use epidemic talent spreading
		self:callTalent(self.T_EPIDEMIC, "do_spread", target, dam)
	end

	-- Melee project
	if hitted and not target.dead and weapon and weapon.melee_project then for typ, dam in pairs(weapon.melee_project) do
		if dam > 0 then
			DamageType:get(typ).projector(self, target.x, target.y, typ, dam)
		end
	end end
	if hitted and not target.dead then for typ, dam in pairs(self.melee_project) do
		if dam > 0 then
			DamageType:get(typ).projector(self, target.x, target.y, typ, dam)
		end
	end end

	-- Shadow cast
	if hitted and not target.dead and self:knowTalent(self.T_SHADOW_COMBAT) and self:isTalentActive(self.T_SHADOW_COMBAT) then
		local dam = self:callTalent(self.T_SHADOW_COMBAT, "getDamage")
		DamageType:get(DamageType.DARKNESS).projector(self, target.x, target.y, DamageType.DARKNESS, dam)
	end

	-- Ruin
	if hitted and not target.dead and self:knowTalent(self.T_RUIN) and self:isTalentActive(self.T_RUIN) then
		local t = self:getTalentFromId(self.T_RUIN)
		local dam = {dam=t.getDamage(self, t), healfactor=0.4, source=t}
		DamageType:get(DamageType.DRAINLIFE).projector(self, target.x, target.y, DamageType.DRAINLIFE, dam)
	end

	-- Temporal Cast
	if hitted and self:knowTalent(self.T_WEAPON_FOLDING) and self:isTalentActive(self.T_WEAPON_FOLDING) then
		self:callTalent(self.T_WEAPON_FOLDING, "doWeaponFolding", target)
	end

	-- Autospell cast
	if hitted and not target.dead and self:knowTalent(self.T_ARCANE_COMBAT) and self:isTalentActive(self.T_ARCANE_COMBAT) then
		local t = self:getTalentFromId(self.T_ARCANE_COMBAT)
		t.do_trigger(self, t, target)
	end

	-- On hit talent
	-- Disable friendly fire for procs since players can't control when they happen or where they hit
	local old_ff = self.nullify_all_friendlyfire
	self.nullify_all_friendlyfire = true
	if hitted and not target.dead and weapon and weapon.talent_on_hit and next(weapon.talent_on_hit) and not self.turn_procs.melee_talent then
		for tid, data in pairs(weapon.talent_on_hit) do
			if rng.percent(data.chance) then
				self.turn_procs.melee_talent = true
				self:forceUseTalent(tid, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=data.level, ignore_ressources=true})
			end
		end
	end
	-- On crit talent
	if hitted and crit and not target.dead and weapon and weapon.talent_on_crit and next(weapon.talent_on_crit) and not self.turn_procs.melee_talent then
		for tid, data in pairs(weapon.talent_on_crit) do
			if rng.percent(data.chance) then
				self.turn_procs.melee_talent = true
				self:forceUseTalent(tid, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=data.level, ignore_ressources=true})
			end
		end
	end
	self.nullify_all_friendlyfire = old_ff

	-- Shattering Impact
	if hitted and self:attr("shattering_impact") and (not self.shattering_impact_last_turn or self.shattering_impact_last_turn < game.turn) then
		local dam = dam * self.shattering_impact
		game.logSeen(target, "The shattering blow creates a shockwave!")
		self:project({type="ball", radius=1, selffire=false, act_exclude={[target.uid]=true}}, target.x, target.y, DamageType.PHYSICAL, dam)  -- don't hit target with the AOE
		self:incStamina(-8)
		self.shattering_impact_last_turn = game.turn
	end

	-- Damage Backlash
	if dam > 0 and self:attr("damage_backfire") then
		local hurt = math.min(dam, old_target_life) * self.damage_backfire / 100
		if hurt > 0 then
			self:takeHit(hurt, self, {cant_die=true})
		end
	end

	-- Burst on Hit
	if hitted and weapon and weapon.burst_on_hit then
		for typ, dam in pairs(weapon.burst_on_hit) do
			if dam > 0 then
				self:project({type="ball", radius=1, friendlyfire=false}, target.x, target.y, typ, dam)
			end
		end
	end

	-- Critical Burst (generally more damage then burst on hit and larger radius)
	if hitted and crit and weapon and weapon.burst_on_crit then
		for typ, dam in pairs(weapon.burst_on_crit) do
			if dam > 0 then
				self:project({type="ball", radius=2, friendlyfire=false}, target.x, target.y, typ, dam)
			end
		end
	end

	-- Arcane Destruction
	if hitted and crit and weapon and self:knowTalent(self.T_ARCANE_DESTRUCTION) then
		local chance = 100
		if self:hasShield() then chance = 50
		elseif self:hasDualWeapon() then chance = 50
		end
		if rng.percent(chance) then
			local t = self:getTalentFromId(self.T_ARCANE_DESTRUCTION)
			self:project({type="ball", radius=self:getTalentRadius(t), friendlyfire=false}, target.x, target.y, DamageType.ARCANE, t.getDamage(self, t))
			game.level.map:particleEmitter(target.x, target.y, self:getTalentRadius(t), "ball_arcane", {radius=2, tx=target.x, ty=target.y})
		end
	end

	-- Onslaught
	if hitted and self:attr("onslaught") then
		local dir = util.getDir(target.x, target.y, self.x, self.y) or 6
		local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
		local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
		local lt, rt = game.level.map(lx, ly, Map.ACTOR), game.level.map(rx, ry, Map.ACTOR)

		if target:checkHit(self:combatAttack(weapon), target:combatPhysicalResist(), 0, 95, 10) and target:canBe("knockback") then
			target:knockback(self.x, self.y, self:attr("onslaught"))
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatAttack())
		end
		if lt and lt:checkHit(self:combatAttack(weapon), lt:combatPhysicalResist(), 0, 95, 10) and lt:canBe("knockback") then
			lt:knockback(self.x, self.y, self:attr("onslaught"))
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatAttack())
		end
		if rt and rt:checkHit(self:combatAttack(weapon), rt:combatPhysicalResist(), 0, 95, 10) and rt:canBe("knockback") then
			rt:knockback(self.x, self.y, self:attr("onslaught"))
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatAttack())
		end
	end

	-- Reactive target on_melee_hit damage
	if hitted then
		local dr, fa, pct = 0

		-- Use an intermediary talent to give retaliation damage a unique source in the combat log
		local old = target.__project_source
		target.__project_source = target:getTalentFromId(target.T_MELEE_RETALIATION)

		for typ, dam in pairs(target.on_melee_hit) do
			if not fa then
				if self:knowTalent(self.T_CLOSE_COMBAT_MANAGEMENT) then
					fa, pct = self:callTalent(self.T_CLOSE_COMBAT_MANAGEMENT, "reflectArmour", weapon)
					print("[ATTACK]\tresolving on_melee_hit damage with:", fa, "flat_armor", pct, "% reflect")
				else fa, pct = 0, 0
				end
			end
			local DT = DamageType:get(typ)
			if type(dam) == "number" then
				if dam > 0 then
					dr = math.min(dam, fa)
					print("[ATTACK]\ttarget on_melee_hit:", dam, typ, "vs", fa)
					dam = dam - dr
					if dam > 0 then	DT.projector(target, self.x, self.y, typ, dam) end
					if dr > 0 and pct > 0 then
						dr = math.floor(dr*pct/100)
						if dr > 0 then
							print("[ATTACK]\ttarget on_melee_hit", dr, typ, "reflected")
							DT.projector(self, target.x, target.y, typ, dr)
						end
					end
				end
			elseif dam.dam and dam.dam > 0 then
				dr = math.min(dam.dam, fa)
				print("[ATTACK]\ttarget on_melee_hit:", dam.dam, typ, "vs", fa)
				if dr > 0 then dam = table.clone(dam); dam.dam = dam.dam - dr end
				if dam.dam > 0 then DT.projector(target, self.x, self.y, typ, dam) end
				if dr > 0 and pct > 0 then
					dr = math.floor(dr*pct/100)
					if dr > 0 then
						print("[ATTACK]\ttarget on_melee_hit", dr, typ, "reflected")
						dam.dam = dr -- only change dam
						DT.projector(self, target.x, target.y, typ, dam)
					end
				end
			end
		end
		target.__project_source = old

	end
	-- Acid splash
	if hitted and not target.dead and target:knowTalent(target.T_ACID_BLOOD) then
		local t = target:getTalentFromId(target.T_ACID_BLOOD)
		t.do_splash(target, t, self)
	end

	-- Bloodbath
	if hitted and crit and self:knowTalent(self.T_BLOODBATH) then
		local t = self:getTalentFromId(self.T_BLOODBATH)
		t.do_bloodbath(self, t)
	end

	-- Mortal Terror
	if hitted and not target.dead and self:knowTalent(self.T_MORTAL_TERROR) then
		local t = self:getTalentFromId(self.T_MORTAL_TERROR)
		t.do_terror(self, t, target, dam)
	end

	-- Psi Auras
	local psiweapon = self:getInven("PSIONIC_FOCUS") and self:getInven("PSIONIC_FOCUS")[1]
	if psiweapon and psiweapon.combat and psiweapon.subtype ~= "mindstar"  then
		if hitted and not target.dead and self:knowTalent(self.T_KINETIC_AURA) and self:isTalentActive(self.T_KINETIC_AURA) and self.use_psi_combat then
			local t = self:getTalentFromId(self.T_KINETIC_AURA)
			t.do_combat(self, t, target)
		end
		if hitted and not target.dead and self:knowTalent(self.T_THERMAL_AURA) and self:isTalentActive(self.T_THERMAL_AURA) and self.use_psi_combat then
			local t = self:getTalentFromId(self.T_THERMAL_AURA)
			t.do_combat(self, t, target)
		end
		if hitted and not target.dead and self:knowTalent(self.T_CHARGED_AURA) and self:isTalentActive(self.T_CHARGED_AURA) and self.use_psi_combat then
			local t = self:getTalentFromId(self.T_CHARGED_AURA)
			t.do_combat(self, t, target)
		end
	end

	-- Static dis-Charge
	if hitted and not target.dead and self:hasEffect(self.EFF_STATIC_CHARGE) then
		local eff = self:hasEffect(self.EFF_STATIC_CHARGE)
		DamageType:get(DamageType.LIGHTNING).projector(self, target.x, target.y, DamageType.LIGHTNING, eff.power)
		self:removeEffect(self.EFF_STATIC_CHARGE)
	end

	-- Exploit Weakness
	if hitted and not target.dead and self:knowTalent(self.T_EXPLOIT_WEAKNESS) and self:isTalentActive(self.T_EXPLOIT_WEAKNESS) then
		local t = self:getTalentFromId(self.T_EXPLOIT_WEAKNESS)
		t.do_weakness(self, t, target)
	end

	-- Special weapon effects  (passing the special definition to facilitate encapsulating multiple special effects)
	if hitted and weapon and weapon.special_on_hit then
		local specials = weapon.special_on_hit
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct and (not target.dead or special.on_kill) then
				special.fct(weapon, self, target, dam, special)
			end
		end
	end

	if hitted and crit and weapon and weapon.special_on_crit then
		local specials = weapon.special_on_crit
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct and (not target.dead or special.on_kill) then
				special.fct(weapon, self, target, dam, special)
			end
		end
	end

	if hitted and weapon and weapon.special_on_kill and target.dead then
		local specials = weapon.special_on_kill
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct then
				special.fct(weapon, self, target, dam, special)
			end
		end
	end

	-- Regen on being hit
	if self ~= target then
		if hitted and not target.dead and target:attr("stamina_regen_when_hit") then target:incStamina(target.stamina_regen_when_hit) end
		if hitted and not target.dead and target:attr("mana_regen_when_hit") then target:incMana(target.mana_regen_when_hit) end
		if hitted and not target.dead and target:attr("equilibrium_regen_when_hit") then target:incEquilibrium(-target.equilibrium_regen_when_hit) end
		if hitted and not target.dead and target:attr("psi_regen_when_hit") then target:incPsi(target.psi_regen_when_hit) end
		if hitted and not target.dead and target:attr("hate_regen_when_hit") then target:incHate(target.hate_regen_when_hit) end
		if hitted and not target.dead and target:attr("vim_regen_when_hit") then target:incVim(target.vim_regen_when_hit) end

		-- Resource regen on hit
		if hitted and self:attr("stamina_regen_on_hit") then self:incStamina(self.stamina_regen_on_hit) end
		if hitted and self:attr("mana_regen_on_hit") then self:incMana(self.mana_regen_on_hit) end
		if hitted and self:attr("psi_regen_on_hit") then self:incPsi(self.psi_regen_on_hit) end
	end

	-- Ablative armor
	if hitted and not target.dead and target:attr("carbon_spikes") then
		if target.carbon_armor >= 1 then
			target.carbon_armor = target.carbon_armor - 1
		else
			-- Deactivate without loosing energy
			target:forceUseTalent(target.T_CARBON_SPIKES, {ignore_energy=true})
		end
	end

	if hitted and not target.dead and target:knowTalent(target.T_STONESHIELD) then
		local t = target:getTalentFromId(target.T_STONESHIELD)
		local m, mm, e, em = t.getValues(self, t)
		target:incMana(math.min(dam * m, mm))
		target:incEquilibrium(-math.min(dam * e, em))
	end

	-- Set Up
	if not hitted and not target.dead and not evaded and not target:attr("stunned") and not target:attr("dazed") and not target:attr("stoned") and target:hasEffect(target.EFF_DEFENSIVE_MANEUVER) then
		local t = target:getTalentFromId(target.T_SET_UP)
		local power = t.getPower(target, t)
		self:setEffect(self.EFF_SET_UP, 2, {src = target, power=power})
	end

	-- Counter Attack!
	if not hitted and not target.dead and target:knowTalent(target.T_COUNTER_ATTACK) and not target:attr("stunned") and not target:attr("dazed") and not target:attr("stoned") and target:knowTalent(target.T_COUNTER_ATTACK) and self:isNear(target.x,target.y, 1) then --Adjacency check
		local cadam = target:callTalent(target.T_COUNTER_ATTACK,"checkCounterAttack")
		if cadam then
			local t = target:getTalentFromId(target.T_COUNTER_ATTACK)
			t.do_counter(target, self, t)
		end
	end

	-- Gesture of Guarding counterattack
	if hitted and not target.dead and not target:attr("stunned") and not target:attr("dazed") and not target:attr("stoned") and target:hasEffect(target.EFF_GESTURE_OF_GUARDING) then
		local t = target:getTalentFromId(target.T_GESTURE_OF_GUARDING)
		t.on_hit(target, t, self)
	end

	-- Defensive Throw!
	if not hitted and not target.dead and target:knowTalent(target.T_DEFENSIVE_THROW) and not target:attr("stunned") and not target:attr("dazed") and not target:attr("stoned") and target:isNear(self.x,self.y,1) then
		local t = target:getTalentFromId(target.T_DEFENSIVE_THROW)
		t.do_throw(target, self, t)
	end

	-- Zero gravity
	if hitted and game.level.data.zero_gravity and rng.percent(util.bound(dam, 0, 100)) then
		target:knockback(self.x, self.y, math.ceil(math.log(dam)))
	end

	-- Roll with it
	if hitted and target:attr("knockback_on_hit") and not target.turn_procs.roll_with_it and rng.percent(util.bound(dam, 0, 100)) then
		local ox, oy = self.x, self.y
		game:onTickEnd(function()
			target:knockback(ox, oy, 1)
			if not target:hasEffect(target.EFF_WILD_SPEED) then target:setEffect(target.EFF_WILD_SPEED, 1, {power=200}) end
		end)
		target.turn_procs.roll_with_it = true
	end

	-- Weakness hate bonus
	local effGloomWeakness = target:hasEffect(target.EFF_GLOOM_WEAKNESS)
	if hitted and effGloomWeakness and effGloomWeakness.hateBonus or 0 > 0 then
		self:incHate(effGloomWeakness.hateBonus)
		game.logPlayer(self, "#F53CBE#You revel in attacking a weakened foe! (+%d hate)", effGloomWeakness.hateBonus)
		effGloomWeakness.hateBonus = nil
	end

	-- Rampage
	if hitted and crit then
		local eff = self:hasEffect(self.EFF_RAMPAGE)
		if eff and not eff.critHit and eff.actualDuration < eff.maxDuration and self:knowTalent(self.T_BRUTALITY) then
			game.logPlayer(self, "#F53CBE#Your rampage is invigorated by your fierce attack! (+1 duration)")
			eff.critHit = true
			eff.actualDuration = eff.actualDuration + 1
			eff.dur = eff.dur + 1
		end
	end

	if hitted and crit and target:hasEffect(target.EFF_DISMAYED) then
		target:removeEffect(target.EFF_DISMAYED)
	end

	if hitted and not target.dead then
		-- Curse of Madness: Twisted Mind
		--[[if self.hasEffect and self:hasEffect(self.EFF_CURSE_OF_MADNESS) then
			local eff = self:hasEffect(self.EFF_CURSE_OF_MADNESS)
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS]
			def.doConspirator(self, eff, target)
		end
		if target.hasEffect and target:hasEffect(target.EFF_CURSE_OF_MADNESS) then
			local eff = target:hasEffect(target.EFF_CURSE_OF_MADNESS)
			local def = target.tempeffect_def[target.EFF_CURSE_OF_MADNESS]
			def.doConspirator(target, eff, self)
		end]]

		-- Curse of Nightmares: Suffocate
		--[[if self.hasEffect and self:hasEffect(self.EFF_CURSE_OF_NIGHTMARES) then
			local eff = self:hasEffect(self.EFF_CURSE_OF_NIGHTMARES)
			local def = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES]
			def.doSuffocate(self, eff, target)
		end
		if target.hasEffect and target:hasEffect(target.EFF_CURSE_OF_NIGHTMARES) then
			local eff = target:hasEffect(target.EFF_CURSE_OF_NIGHTMARES)
			local def = target.tempeffect_def[target.EFF_CURSE_OF_NIGHTMARES]
			def.doSuffocate(target, eff, self)
		end]]
	end

	if target:isTalentActive(target.T_SHARDS) and hitted and not target.dead and not target.turn_procs.shield_shards then
		local t = target:getTalentFromId(target.T_SHARDS)
		target.turn_procs.shield_shards = true
		self.logCombat(target, self, "#Source# counter attacks #Target# with %s shield shards!", string.his_her(target))
		target:attr("ignore_counterstrike", 1)
		target:attackTarget(self, DamageType.NATURE, self:combatTalentWeaponDamage(t, 0.4, 1), true)
		target:attr("ignore_counterstrike", -1)
	end
	-- post melee attack hooks/callbacks, not included: apr, armor, atk, def, evaded, repelled, old_target_life
	local hd = {"Combat:attackTargetWith", hitted=hitted, crit=crit, target=target, weapon=weapon, damtype=damtype, mult=mult, dam=dam}
	if self:triggerHook(hd) then hitted = hd.hitted end
	self:fireTalentCheck("callbackOnMeleeAttack", target, hitted, crit, weapon, damtype, mult, dam, hd)
	self.__global_accuracy_damage_bonus = nil

	return hitted
end

_M.weapon_talents = {
	sword =   {"T_WEAPONS_MASTERY", "T_STRENGTH_OF_PURPOSE"},
	axe =     {"T_WEAPONS_MASTERY", "T_STRENGTH_OF_PURPOSE"},
	mace =    {"T_WEAPONS_MASTERY", "T_STRENGTH_OF_PURPOSE"},
	knife =   {"T_KNIFE_MASTERY", "T_STRENGTH_OF_PURPOSE"},
	whip  =   "T_EXOTIC_WEAPONS_MASTERY",
	trident = "T_EXOTIC_WEAPONS_MASTERY",
	bow =     {"T_BOW_MASTERY", "T_STRENGTH_OF_PURPOSE", "T_MASTER_MARKSMAN"},
	sling =   {"T_SLING_MASTERY", "T_SKIRMISHER_SLING_SUPREMACY", "T_MASTER_MARKSMAN"},
	staff =   "T_STAFF_MASTERY",
	mindstar ="T_PSIBLADES",
	dream =   "T_DREAM_CRUSHER",
	unarmed = "T_UNARMED_MASTERY",
	shield = {"T_STONESHIELD"},
}

--- Static!
-- Training Talents can have the following fields:
-- getMasteryPriority(self, t, kind) - Only the talent with the highest is used. Defaults to the talent level.
-- getDamage(self, t, kind) - Extra physical power granted. Defaults to level * 10.
-- getPercentInc(self, t, kind) - Percentage increase to damage overall. Defaults to sqrt(level / 5) / 2.
function _M:addCombatTraining(kind, tid)
	local wt = _M.weapon_talents
	if not wt[kind] then wt[kind] = tid return end

	if type(wt[kind]) == "table" then
		wt[kind][#wt[kind]+1] = tid
	else
		wt[kind] = { wt[kind] }
		wt[kind][#wt[kind]+1] = tid
	end
end

--- Checks weapon training
function _M:combatGetTraining(weapon)
	if not weapon then return nil end
	if not weapon.talented then return nil end
	if not _M.weapon_talents[weapon.talented] then return nil end
	if type(_M.weapon_talents[weapon.talented]) == "table" then
		local get_priority = function(tid)
			local t = self:getTalentFromId(tid)
			if t.getMasteryPriority then return util.getval(t.getMasteryPriority, self, t, weapon.talented) end
			return self:getTalentLevel(t)
		end
		local max_tid -- = _M.weapon_talents[weapon.talented][1]
		local max_priority = -math.huge -- get_priority(max_tid)
		for _, tid in ipairs(_M.weapon_talents[weapon.talented]) do
			if self:knowTalent(tid) then
				local priority = get_priority(tid)
				if priority > max_priority then
					max_tid = tid
					max_priority = priority
				end
			end
		end

		return self:getTalentFromId(max_tid)
	else
		return self:getTalentFromId(_M.weapon_talents[weapon.talented])
	end
end

-- Gets the added damage for a weapon based on training.
function _M:combatTrainingDamage(weapon)
	local t = self:combatGetTraining(weapon)
	if not t or not self:knowTalent(t) then return 0 end
	if t.getDamage then return util.getval(t.getDamage, self, t, weapon.talented) end
	return self:getTalentLevel(t) * 10
end

-- Gets the percent increase for a weapon based on training.
function _M:combatTrainingPercentInc(weapon)
	local t = self:combatGetTraining(weapon)
	if not t or not self:knowTalent(t) then return 0 end
	if t.getPercentInc then return util.getval(t.getPercentInc, self, t, weapon.talented) end
	return math.sqrt(self:getTalentLevel(t) / 5) / 2
end

--- Gets the defense
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatDefenseBase(fake)
	local add = 0
	local light_armor = self:hasLightArmor()
	if not self:attr("encased_in_ice") then
		if self:hasDualWeapon() and self:knowTalent(self.T_DUAL_WEAPON_DEFENSE) then
			add = add + self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDefense")
		end
		if light_armor and self:knowTalent(self.T_LIGHT_ARMOUR_TRAINING) then
			add = add + self:callTalent(self.T_LIGHT_ARMOUR_TRAINING,"getDefense")
		end
		if not fake then
			add = add + (self:checkOnDefenseCall("defense") or 0)
		end
		if self:knowTalent(self.T_TACTICAL_EXPERT) then
			local t = self:getTalentFromId(self.T_TACTICAL_EXPERT)
			add = add + t.do_tact_update(self, t)
		end
		if self:knowTalent(self.T_CORRUPTED_SHELL) then
			add = add + self:getCon() / 3
		end
		if self:knowTalent(self.T_STEADY_MIND) then
			local t = self:getTalentFromId(self.T_STEADY_MIND)
			add = add + t.getDefense(self, t)
		end
		if self:isTalentActive(Talents.T_SURGE) then
			local t = self:getTalentFromId(self.T_SURGE)
			add = add + t.getDefenseChange(self, t)
		end
		if self:knowTalent(self.T_UMBRAL_AGILITY) then
			local t = self:getTalentFromId(self.T_UMBRAL_AGILITY)
			add = add + t.getDefense(self, t)
		end
	end
	local d = math.max(0, self.combat_def + (self:getDex() - 10) * 0.7 + (self:getLck() - 50) * 0.4)
	local mult = 1
	if light_armor then
		if self:knowTalent(self.T_MOBILE_DEFENCE) then
			mult = mult + self:callTalent(self.T_MOBILE_DEFENCE,"getDef")
		end
	end

	return math.max(0, d * mult + add) -- Add bonuses last to avoid compounding defense multipliers from talents
end

--- Gets the defense ranged
function _M:combatDefense(fake, add)
	if self.combat_precomputed_defense then return self.combat_precomputed_defense end
	local base_defense = self:combatDefenseBase(true)
	if not fake then base_defense = self:combatDefenseBase() end
	local d = math.max(0, base_defense + (add or 0))
	if self:attr("dazed") then d = d / 2 end
	return self:rescaleCombatStats(d)
end

--- Gets the defense ranged
function _M:combatDefenseRanged(fake, add)
	if self.combat_precomputed_defense then return self.combat_precomputed_defense end
	local base_defense = self:combatDefenseBase(true)
	if not fake then base_defense = self:combatDefenseBase() end
	local d = math.max(0, base_defense + (self.combat_def_ranged or 0) + (add or 0))
	if self:attr("dazed") then d = d / 2 end
	return self:rescaleCombatStats(d)
end

--- Gets the armor
function _M:combatArmor()
	local add = 0
	if self:hasHeavyArmor() and self:knowTalent(self.T_ARMOUR_TRAINING) then
		local at = Talents:getTalentFromId(Talents.T_ARMOUR_TRAINING)
		add = add + at.getArmor(self, at)
		if self:knowTalent(self.T_GOLEM_ARMOUR) then
			local ga = Talents:getTalentFromId(Talents.T_GOLEM_ARMOUR)
			add = add + ga.getArmor(self, ga)
		end
	end
	if self:knowTalent(self.T_ARMOUR_OF_SHADOWS) and not game.level.map.lites(self.x, self.y) then
		add = add + self:callTalent(self.T_ARMOUR_OF_SHADOWS,"ArmourBonus")
	end
	local light_armor = self:hasLightArmor()
	if light_armor then
		if self:knowTalent(self.T_SKIRMISHER_BUCKLER_EXPERTISE) then
			add = add + self:callTalent(self.T_SKIRMISHER_BUCKLER_EXPERTISE, "getArmour")
		end
	end
	if self:knowTalent(self.T_CORRUPTED_SHELL) then
		add = add + self:getCon() / 3.5
	end
	if self:knowTalent(self.T_CARBON_SPIKES) and self:isTalentActive(self.T_CARBON_SPIKES) then
		add = add + self.carbon_armor
	end
	if self:knowTalent(self["T_FORM_AND_FUNCTION"]) then add = add + self:callTalent(self["T_FORM_AND_FUNCTION"], "getArmorBoost") end

	return self.combat_armor + add
end

--- Gets armor hardiness
-- This is how much % of a blow we can reduce with armor
function _M:combatArmorHardiness()
	local add = 0
	local multi = 1
	if self:hasHeavyArmor() and self:knowTalent(self.T_ARMOUR_TRAINING) then
		local at = Talents:getTalentFromId(Talents.T_ARMOUR_TRAINING)
		add = add + at.getArmorHardiness(self, at)
		if self:knowTalent(self.T_GOLEM_ARMOUR) then
			local ga = Talents:getTalentFromId(Talents.T_GOLEM_ARMOUR)
			add = add + ga.getArmorHardiness(self, ga)
		end
	end
	local light_armor = self:hasLightArmor()
	if light_armor then
		if self:knowTalent(self.T_MOBILE_DEFENCE) then
			add = add + self:callTalent(self.T_MOBILE_DEFENCE, "getHardiness")
		end
		if self:knowTalent(self.T_LIGHT_ARMOUR_TRAINING) then
			add = add + self:callTalent(self.T_LIGHT_ARMOUR_TRAINING, "getArmorHardiness")
		end
		if self:knowTalent(self.T_SKIRMISHER_BUCKLER_EXPERTISE) then
			add = add + self:callTalent(self.T_SKIRMISHER_BUCKLER_EXPERTISE, "getArmorHardiness")
		end
	end
	if self:knowTalent(self.T_ARMOUR_OF_SHADOWS) and not game.level.map.lites(self.x, self.y) then
		add = add + 50
	end
	if self:hasEffect(self.EFF_BREACH) then
		multi = 0.5
	end
	return util.bound(30 + self.combat_armor_hardiness + add, 0, 100) * multi
end

--- Gets the attack
function _M:combatAttackBase(weapon, ammo)
	weapon = weapon or self.combat or {}
	local talent = self:callTalent(self.T_WEAPON_COMBAT, "getAttack")
	local atk = 4 + self.combat_atk + talent + (weapon.atk or 0) + (ammo and ammo.atk or 0) + (self:getLck() - 50) * 0.4

	if self:knowTalent(self["T_FORM_AND_FUNCTION"]) then atk = atk + self:callTalent(self["T_FORM_AND_FUNCTION"], "getDamBoost", weapon) end
	if self:knowTalent(self["T_UMBRAL_AGILITY"]) then atk = atk + self:callTalent(self["T_UMBRAL_AGILITY"], "getAccuracy") end

	if self:attr("hit_penalty_2h") then atk = atk * (1 - math.max(0, 20 - (self.size_category - 4) * 5) / 100) end

	return atk
end
function _M:combatAttack(weapon, ammo)
	if self.combat_precomputed_accuracy then return self.combat_precomputed_accuracy end
	local stats
	if self:attr("use_psi_combat") then stats = (self:getCun(100, true) - 10) * (0.6 + self:callTalent(self.T_RESONANT_FOCUS, "bonus")/100)
	elseif weapon and weapon.wil_attack then stats = self:getWil(100, true) - 10
	elseif weapon and weapon.mag_attack then stats = self:getMag(100, true) - 10
	else
		local ret = self:fireTalentCheck("callbackOnCombatAttack", weapon, ammo)
		if ret then stats = ret
		else stats = self:getDex(100, true) - 10 end
	end
	local d = self:combatAttackBase(weapon, ammo) + stats
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end
	return self:rescaleCombatStats(d)
end

function _M:combatAttackRanged(weapon, ammo)
	if self.combat_precomputed_accuracy then return self.combat_precomputed_accuracy end
	local stats
	if self:attr("use_psi_combat") then stats = (self:getCun(100, true) - 10) * (0.6 + self:callTalent(self.T_RESONANT_FOCUS, "bonus")/100)
	elseif weapon and weapon.wil_attack then stats = self:getWil(100, true) - 10
	else stats = self:getDex(100, true) - 10
	end
	local d = self:combatAttackBase(weapon, ammo) + stats + (self.combat_atk_ranged or 0)
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end

	return self:rescaleCombatStats(d)
end

--- Gets the attack using only strength
function _M:combatAttackStr(weapon, ammo)
	local d = self:combatAttackBase(weapon, ammo) + (self:getStr(100, true) - 10)
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end
	return self:rescaleCombatStats(d)
end

--- Gets the attack using only dexterity
function _M:combatAttackDex(weapon, ammo)
	local d = self:combatAttackBase(weapon, ammo) + (self:getDex(100, true) - 10)
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end
	return self:rescaleCombatStats(d)
end

--- Gets the attack using only magic
function _M:combatAttackMag(weapon, ammo)
	local d = self:combatAttackBase(weapon, ammo) + (self:getMag(100, true) - 10)
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end

	return self:rescaleCombatStats(d)
end

--- Gets the armor penetration
function _M:combatAPR(weapon)
	weapon = weapon or self.combat or {}
	local addapr = 0
	return self.combat_apr + (weapon.apr or 0) + addapr
end

--- Gets the weapon speed
function _M:combatSpeed(weapon, add)
	weapon = weapon or self.combat or {}
	return (weapon.physspeed or 1) / math.max(self.combat_physspeed + (add or 0), 0.4)
end

--- Gets the crit rate
function _M:combatCrit(weapon)
	weapon = weapon or self.combat or {}
	local addcrit = 0
	if weapon.talented and self:knowTalent(Talents.T_LETHALITY) then
		addcrit = 1 + self:callTalent(Talents.T_LETHALITY, "getCriticalChance")
	end
	if self:knowTalent(Talents.T_ARCANE_MIGHT) then
		addcrit = addcrit + 0.25 * self.combat_spellcrit
	end
	local crit = self.combat_physcrit + (self.combat_generic_crit or 0) + (self:getCun() - 10) * 0.3 + (self:getLck() - 50) * 0.30 + (weapon.physcrit or 1) + addcrit

	return math.max(crit, 0) -- note: crit > 100% may be offset by crit reduction elsewhere
end

--- Gets the damage range
function _M:combatDamageRange(weapon, add)
	weapon = weapon or self.combat or {}
	return (self.combat_damrange or 0) + (weapon.damrange or (1.1 - (add or 0))) + (add or 0)
end

--- Scale damage values
-- This currently beefs up high-end damage values to make up for the combat stat rescale nerf.
function _M:rescaleDamage(dam)
	if dam <= 0 then return dam end
--	return dam * (1 - math.log10(dam * 2) / 7) --this is the old version, pre-combat-stat-rescale
	return dam ^ 1.04
end

--Diminishing-returns method of scaling combat stats, observing this rule: the first twenty ranks cost 1 point each, the second twenty cost two each, and so on. This is much, much better for players than some logarithmic mess, since they always know exactly what's going on, and there are nice breakpoints to strive for.
-- raw_combat_stat_value = the value being rescaled
-- interval = ranks until cost of each effective stat value increases (default 20)
-- step = increase in cost of raw_combat_stat_value to give 1 effective stat value each interval (default 1)
function _M:rescaleCombatStats(raw_combat_stat_value, interval, step)
	local x = raw_combat_stat_value
	-- the rescaling plot is a convex hull of functions x, 20 + (x - 20) / 2, 40 + (x - 60) / 3, ...
	-- we find the value just by applying minimum over and over
	local result = x
	interval = interval or 20
	step = step or 1
	local shift, tier, base = 1 + step, interval, interval
	while true do
		local nextresult = tier + (x - base) / shift
		if nextresult < result then
			result = nextresult
			base = base + interval * shift
			tier = tier + interval
			shift = shift + step
		else
			return math.floor(result)
		end
	end
end

-- Scale a value up or down by a power
-- x = a numeric value
-- y_low = value to match at x_low
-- y_high = value to match at x_high
-- power = scaling factor (default 0.5)
-- add = amount to add the result (default 0)
-- shift = amount to add to the input value before computation (default 0)
function _M:combatScale(x, y_low, x_low, y_high, x_high, power, add, shift)
	power, add, shift = power or 0.5, add or 0, shift or 0
	local x_low_adj, x_high_adj = (x_low+shift)^power, (x_high+shift)^power
	local m = (y_high - y_low)/(x_high_adj - x_low_adj)
	local b = y_low - m*x_low_adj
	return m * (x + shift)^power + b + add
end

-- Scale a value up or down subject to a limit
-- x = a numeric value
-- limit = value approached as x increases
-- y_high = value to match at when x = x_high
-- y_low = value to match when x = x_low
-- returns limit * (1-{a*(x)^0.75+b})
-- 		(1-(e)^(-x)) ranges from 0 to 1 and can effectively be thought of as giving a percent of limit based on talent level (note that a*(x)^0.75+b will be < 0 for all x)
-- 		note that the progression low->high->limit must be monotone, consistently increasing or decreasing
function _M:combatLimit(x, limit, y_low, x_low, y_high, x_high)
	x_low = x_low^0.75
	x_high = x_high^0.75
	if y_high >= y_low then -- find a and b such that (1-exp{a*sqrt(x)+b}) * limit returns y_low at x_low and y_high at x_high
		-- gaze in horror at how we find our constants 
		local a = math.log( (y_high-limit)/(y_low-limit) )/(x_high - x_low)
		local b = -( (x_high - x_low) * math.log(1 - y_high/limit) - x_high * math.log( (y_high-limit)/(y_low-limit) ) )/(x_low - x_high)
		return limit * (1 - math.exp( ((x)^.75*a+b)) )
	elseif y_low > y_high then -- find a and b such that y_low - (y_low-limit)*(1-exp{a*(x)^0.75+b}) returns y_low at x_low and y_high at x_high
		local a = math.log( (y_high-limit)/(y_low-limit) ) / (x_high - x_low)
		local b = -( (x_high - x_low)*math.log(1-(y_low-y_high)/(y_low-limit)) - x_high * math.log( (y_high-limit)/(y_low-limit) ) )/(x_low - x_high)
		return y_low - (y_low-limit) * (1 - math.exp( ((x)^.75*a+b) ))
	end
end

-- Compute a diminishing returns value based on talent level that scales with a power
-- t = talent def table or a numeric value
-- low = value to match at talent level 1
-- high = value to match at talent level 5
-- power = scaling factor (default 0.5) or "log" for log10
-- add = amount to add the result (default 0)
-- shift = amount to add to the talent level before computation (default 0)
-- raw if true specifies use of raw talent level
function _M:combatTalentScale(t, low, high, power, add, shift, raw)
	local tl = type(t) == "table" and (raw and self:getTalentLevelRaw(t) or self:getTalentLevel(t)) or t
	if tl <= 0 then tl = 0.1 end
	power, add, shift = power or 0.5, add or 0, shift or 0
	local x_low, x_high = 1, 5 -- Implied talent levels to fit
	local x_low_adj, x_high_adj
	if power == "log" then
		x_low_adj, x_high_adj = math.log10(x_low+shift), math.log10(x_high+shift)
		tl = math.max(1, tl)
	else
		x_low_adj, x_high_adj = (x_low+shift)^power, (x_high+shift)^power
	end
	local m = (high - low)/(x_high_adj - x_low_adj)
	local b = low - m*x_low_adj
	if power == "log" then -- always >= 0
		return math.max(0, m * math.log10(tl + shift) + b + add)
--		return math.max(0, m * math.log10(tl + shift) + b + add), m, b
	else
		return math.max(0, m * (tl + shift)^power + b + add)
--		return math.max(0, m * (tl + shift)^power + b + add), m, b
	end
end

-- Compute a diminishing returns value based on a stat value that scales with a power
-- stat == "str", "con",.... or a numeric value
-- low = value to match when stat = 10
-- high = value to match when stat = 100
-- power = scaling factor (default 0.5) or "log" for log10
-- add = amount to add the result (default 0)
-- shift = amount to add to the stat value before computation (default 0)
function _M:combatStatScale(stat, low, high, power, add, shift)
	stat = type(stat) == "string" and self:getStat(stat,nil,true) or stat
	power, add, shift = power or 0.5, add or 0, shift or 0
	local x_low, x_high = 10, 100 -- Implied stat values to match
	local x_low_adj, x_high_adj
	if power == "log" then
		x_low_adj, x_high_adj = math.log10(x_low+shift), math.log10(x_high+shift)
		stat = math.max(1, stat)
	else
		x_low_adj, x_high_adj = (x_low+shift)^power, (x_high+shift)^power
	end
	local m = (high - low)/(x_high_adj - x_low_adj)
	local b = low -m*x_low_adj
	if power == "log" then -- always >= 0
		return math.max(0, m * math.log10(stat + shift) + b + add)
--		return math.max(0, m * math.log10(stat + shift) + b + add), m, b
	else
		return math.max(0, m * (stat + shift)^power + b + add)
--		return math.max(0, m * (stat + shift)^power + b + add), m, b
	end
end

-- Compute a diminishing returns value based on talent level using exponentials that cannot go beyond a limit
-- t = talent def table or a numeric value
-- limit = value approached as talent levels increase
-- high = value at talent level 5 multiplied by mastery (default 6.5)
-- low = value at talent level 1 multiplied by mastery (default 1.3)
-- raw if true specifies use of raw talent level
-- mastery = value used for determining high and low
-- returns limit * (1-exp{a*sqrt(tl)+b})
-- 		(1-(e)^(-x)) ranges from 0 to 1 and can effectively be thought of as giving a percent of limit based on talent level (note that a*sqrt(tl)+b will be < 0 for all tl)
-- 		note that the progression low->high->limit must be monotone, consistently increasing or decreasing
function _M:combatTalentLimit(t, limit, low, high, raw, mastery)
	local x_low = mastery and math.sqrt(mastery) or math.sqrt(1.3)
	local x_high = mastery and math.sqrt(mastery*5) or math.sqrt(6.5)	
	local tl = type(t) == "table" and (raw and self:getTalentLevelRaw(t) or self:getTalentLevel(t)) or t
	if tl <= 0 then tl = 0.5 end
	if high >= low then -- find a and b such that (1-exp{a*sqrt(tl)+b}) * limit returns low at x_low and high at x_high
		-- gaze in horror at how we find our constants 
		local a = math.log( (high-limit)/(low-limit) )/(x_high - x_low)
		local b = -( (x_high - x_low) * math.log(1 - high/limit) - x_high * math.log( (high-limit)/(low-limit) ) )/(x_low - x_high)
		return limit * (1 - math.exp( (math.sqrt(tl)*a+b)) )
	elseif low > high then -- find a and b such that low - (low-limit)*(1-exp{a*sqrt(tl)+b}) returns low at x_low and high at x_high
		local a = math.log( (high-limit)/(low-limit) ) / (x_high - x_low)
		local b = -( (x_high - x_low)*math.log(1-(low-high)/(low-limit)) - x_high * math.log( (high-limit)/(low-limit) ) )/(x_low - x_high)
		return low - (low-limit) * (1 - math.exp( (math.sqrt(tl)*a+b) ))
	end
end

-- Compute a diminishing returns value based on a stat value using exponentials that cannot go beyond a limit
-- stat == "str", "con",.... or a numeric value
-- limit = value approached as stats increase
-- high = value to match when stat = 100
-- low = value to match when stat = 10
-- returns limit * (1-exp{a*(stat)^0.75+b})
-- 		(1-(e)^(-x)) ranges from 0 to 1 and can effectively be thought of as giving a percent of limit based on talent level (note that a*(stat)^0.75+b will be < 0 for all tl)
-- 		note that the progression low->high->limit must be monotone, consistently increasing or decreasing
function _M:combatStatLimit(stat, limit, low, high)
	local x_low = 5.6234 -- 10^0.75
	local x_high = 31.623 --100^0.75
	stat = type(stat) == "string" and self:getStat(stat,nil,true) or stat
	if high >= low then -- find a and b such that (1-exp{a*(stat)^0.75+b}) * limit returns low at 10 stat and high at 100
		-- gaze in horror at how we find our constants 
		local a = math.log( (high-limit)/(low-limit) )/(x_high - x_low)
		local b = -( (x_high - x_low) * math.log(1 - high/limit) - x_high * math.log( (high-limit)/(low-limit) ) )/(x_low - x_high)
		return limit * (1 - math.exp( ((stat)^.75*a+b)) )
	elseif low > high then -- find a and b such that low - (low-limit)*(1-exp{a*(stat)^0.75+b}) returns low at 10 stat and high at 100
		local a = math.log( (high-limit)/(low-limit) ) / (x_high - x_low)
		local b = -( (x_high - x_low)*math.log(1-(low-high)/(low-limit)) - x_high * math.log( (high-limit)/(low-limit) ) )/(x_low - x_high)
		return low - (low-limit) * (1 - math.exp( ((stat)^.75*a+b) ))
	end
end

--- Gets the dammod table for a given weapon.
function _M:getDammod(combat)
	combat = combat or self.combat or {}

	local dammod = table.clone(combat.dammod or {str = 0.6}, true)

	local sub = function(from, to)
		dammod[to] = (dammod[from] or 0) + (dammod[to] or 0)
		dammod[from] = nil
	end

	if combat.talented == 'knife' and self:knowTalent('T_LETHALITY') then sub('str', 'cun') end
	if combat.talented and self:knowTalent('T_STRENGTH_OF_PURPOSE') then sub('str', 'mag') end
	if self:attr 'use_psi_combat' then
		if dammod['str'] then
			dammod['str'] = (dammod['str'] or 0) * (0.6 + self:callTalent(self.T_RESONANT_FOCUS, "bonus")/100)
			sub('str', 'wil')
		end
		if dammod['dex'] then
			dammod['dex'] = (dammod['dex'] or 0) * (0.6 + self:callTalent(self.T_RESONANT_FOCUS, "bonus")/100)
			sub('dex', 'cun')
		end
	end

	-- Add stuff like lethality here.
	local hd = {"Combat:getDammod:subs", combat=combat, dammod=dammod, sub=sub}
	if self:triggerHook(hd) then dammod = hd.dammod end

	local add = function(stat, val)
		dammod[stat] = (dammod[stat] or 0) + val
	end

	if self:knowTalent(self.T_SUPERPOWER) then add('wil', 0.4) end
	if self:knowTalent(self.T_ARCANE_MIGHT) then add('mag', 0.5) end

	return dammod
end

-- Calculate combat damage for a weapon (with an optional damage field for ranged)
-- Talent bonuses are always based on the base weapon
function _M:combatDamage(weapon, adddammod, damage)
	weapon = weapon or self.combat or {}
	local dammod = self:getDammod(damage or weapon)
	local totstat = 0
	for stat, mod in pairs(dammod) do
		totstat = totstat + self:getStat(stat) * mod
	end
	if adddammod then
		for stat, mod in pairs(adddammod) do
			totstat = totstat + self:getStat(stat) * mod
		end
	end
	
	local talented_mod = 1 + self:combatTrainingPercentInc(weapon)
	local power = self:combatDamagePower(damage or weapon)
	local phys = self:combatPhysicalpower(nil, weapon)
	local statmod = self:rescaleCombatStats(totstat, 45, 1/3) -- totstat tends to be lower than values of powers and saves so default interval and step size is too harsh; instead use wider intervals and 1/3 step size
	return self:rescaleDamage(0.3 * (phys + statmod) * power * talented_mod)
end

--- Gets the 'power' portion of the damage
function _M:combatDamagePower(weapon_combat, add)
	if not weapon_combat then return 1 end
	local power = math.max((weapon_combat.dam or 1) + (add or 0), 1)

	if self:knowTalent(self["T_FORM_AND_FUNCTION"]) then power = power + self:callTalent(self["T_FORM_AND_FUNCTION"], "getDamBoost", weapon_combat) end

	return (math.sqrt(power / 10) - 1) * 0.5 + 1
end

function _M:combatPhysicalpowerRaw(weapon, add)
	if self.combat_precomputed_physpower then return self.combat_precomputed_physpower end
	add = add or 0

	if self.combat_generic_power then
		add = add + self.combat_generic_power
	end
	if self:knowTalent(Talents.T_ARCANE_DESTRUCTION) then
		add = add + self:getMag() * self:callTalent(Talents.T_ARCANE_DESTRUCTION, "getSPMult")
	end
	if self:isTalentActive(Talents.T_BLOOD_FRENZY) then
		add = add + self.blood_frenzy
	end
	if self:knowTalent(self.T_BLOODY_BUTCHER) then
		add = add + self:callTalent(Talents.T_BLOODY_BUTCHER, "getDam")
	end
	if self:knowTalent(self.T_EMPTY_HAND) and self:isUnarmed() then
		local t = self:getTalentFromId(self.T_EMPTY_HAND)
		add = add + t.getDamage(self, t)
	end
	if self:attr("psychometry_power") then
		add = add + self:attr("psychometry_power")
	end

	if not weapon then
		local inven = self:getInven(self.INVEN_MAINHAND)
		if inven and inven[1] then weapon = self:getObjectCombat(inven[1], "mainhand") else weapon = self.combat end
	end

	add = add + self:combatTrainingDamage(weapon)

	local str = self:getStr()

	local d = math.max(0, (self.combat_dam or 0) + add + str) -- allows strong debuffs to offset strength
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end

	if self:attr("hit_penalty_2h") then d = d * (1 - math.max(0, 20 - (self.size_category - 4) * 5) / 100) end

	return d
end

function _M:combatPhysicalpower(mod, weapon, add)
	mod = mod or 1
	local d = self:combatPhysicalpowerRaw(weapon, add)

	if self:knowTalent(self.T_ARCANE_MIGHT) then
		return self:combatSpellpower(mod, d) -- will do the rescaling and multiplying for us
	else
		return self:rescaleCombatStats(d) * mod
	end
end

--- Gets damage based on talent
function _M:combatTalentPhysicalDamage(t, base, max)
	-- Compute at "max"
	local mod = max / ((base + 100) * ((math.sqrt(5) - 1) * 0.8 + 1))
	-- Compute real
	return self:rescaleDamage((base + (self:combatPhysicalpower())) * ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) * mod)
end

--- Gets spellpower raw
function _M:combatSpellpowerRaw(add)
	if self.combat_precomputed_spellpower then return self.combat_precomputed_spellpower, 1 end
	add = add or 0

	if self.combat_generic_power then
		add = add + self.combat_generic_power
	end
	if self:knowTalent(self.T_ARCANE_CUNNING) then
		add = add + self:callTalent(self.T_ARCANE_CUNNING,"getSpellpower") * self:getCun() / 100
	end
	if self:knowTalent(self.T_SHADOW_CUNNING) then
		add = add + self:callTalent(self.T_SHADOW_CUNNING,"getSpellpower") * self:getCun() / 100
	end
	if self:knowTalent(self.T_LUNACY) then
		add = add + self:callTalent(self.T_LUNACY,"getSpellpower") * self:getWil() / 100
	end
	if self:hasEffect(self.EFF_BLOODLUST) then
		add = add + self:hasEffect(self.EFF_BLOODLUST).spellpower * self:hasEffect(self.EFF_BLOODLUST).stacks
	end
	if self.summoner and self.summoner:knowTalent(self.summoner.T_BLIGHTED_SUMMONING) then
		add = add + self.summoner:getMag()
	end

	local am = 1
	if self:attr("spellpower_reduction") then am = 1 / (1 + self:attr("spellpower_reduction")) end

	local d = math.max(0, (self.combat_spellpower or 0) + add + self:getMag())
	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end

	if self:attr("hit_penalty_2h") then d = d * (1 - math.max(0, 20 - (self.size_category - 4) * 5) / 100) end

	return d, am
end

--- Gets spellpower
function _M:combatSpellpower(mod, add)
	mod = mod or 1
	local d, am = self:combatSpellpowerRaw(add)
	return self:rescaleCombatStats(d) * mod * am
end

--- Gets damage based on talent
function _M:combatTalentSpellDamage(t, base, max, spellpower_override)
	-- Compute at "max"
	local mod = max / ((base + 100) * ((math.sqrt(5) - 1) * 0.8 + 1))
	-- Compute real
	return self:rescaleDamage((base + (spellpower_override or self:combatSpellpower())) * ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) * mod)
end

--- Gets weapon damage mult based on talent
function _M:combatTalentWeaponDamage(t, base, max, t2)
	if t2 then t2 = t2 / 2 else t2 = 0 end
	local diff = max - base
	local mult = base + diff * math.sqrt((self:getTalentLevel(t) + t2) / 5)
--	print("[TALENT WEAPON MULT]", self:getTalentLevel(t), base, max, t2, mult)
	return mult
end

--- Gets the off hand multiplier
function _M:getOffHandMult(combat, mult)
	if combat and combat.range and not combat.dam then return mult or 1 end --no penalty for ranged shooters
	local offmult = 1/2
	-- Take the bigger multiplier from Dual weapon training, Dual Weapon Mastery and Corrupted Strength
	if self:knowTalent(Talents.T_DUAL_WEAPON_TRAINING) then
		offmult = math.max(offmult,self:callTalent(Talents.T_DUAL_WEAPON_TRAINING,"getoffmult"))
	end
	if self:knowTalent(Talents.T_DUAL_WEAPON_MASTERY) then
		offmult = math.max(offmult,self:callTalent(Talents.T_DUAL_WEAPON_MASTERY,"getoffmult"))
	end
	if self:knowTalent(Talents.T_CORRUPTED_STRENGTH) then
		offmult = math.max(offmult,self:callTalent(Talents.T_CORRUPTED_STRENGTH,"getoffmult"))
	end
	if combat and combat.no_offhand_penalty then offmult = math.max(1, offmult) end

	offmult = (mult or 1)*offmult
	if self:hasEffect(self.EFF_CURSE_OF_MADNESS) then
		local eff = self:hasEffect(self.EFF_CURSE_OF_MADNESS)
		if eff.level >= 1 and eff.unlockLevel >= 1 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS]
			offmult = offmult + ((mult or 1) * def.getOffHandMultChange(eff.level) / 100)
		end
	end

	return offmult
end

--- Gets fatigue
function _M:combatFatigue()
	local min = self.min_fatigue or 0
	local fatigue = self.fatigue

	if self:knowTalent(self["T_FORM_AND_FUNCTION"]) then fatigue = fatigue - self:callTalent(self["T_FORM_AND_FUNCTION"], "getFatigueBoost") end

	if self:knowTalent(self.T_LIGHT_ARMOUR_TRAINING) then
		fatigue = fatigue - self:callTalent(self.T_LIGHT_ARMOUR_TRAINING, "getFatigue")
	end
	if fatigue < min then return min end
	if self:knowTalent(self.T_NO_FATIGUE) then return min end
	return fatigue
end

--- Gets spellcrit
function _M:combatSpellCrit()
	local crit = self.combat_spellcrit + (self.combat_generic_crit or 0) + (self:getCun() - 10) * 0.3 + (self:getLck() - 50) * 0.30 + 1

	return util.bound(crit, 0, 100)
end

--- Gets mindcrit
function _M:combatMindCrit(add)
	local add = add or 0
	if self:knowTalent(self.T_GESTURE_OF_POWER) then
		local t = self:getTalentFromId(self.T_GESTURE_OF_POWER)
		add = t.getMindCritChange(self, t)
	end

	local crit = self.combat_mindcrit + (self.combat_generic_crit or 0) + (self:getCun() - 10) * 0.3 + (self:getLck() - 50) * 0.30 + 1 + add

	return util.bound(crit, 0, 100)
end

--- Gets spellspeed
function _M:combatSpellSpeed()
	return 1 / math.max(self.combat_spellspeed, 0.4)
end

-- Gets mental speed
function _M:combatMindSpeed()
	return 1 / math.max(self.combat_mindspeed, 0.4)
end

--- Gets summon speed
function _M:combatSummonSpeed()
	return math.max(1 - ((self:attr("fast_summons") or 0) / 100), 0.15)
end

--- Computes physical crit chance reduction
function _M:combatCritReduction()
	local crit_reduction = 0
	if self:hasHeavyArmor() and self:knowTalent(self.T_ARMOUR_TRAINING) then
		local at = Talents:getTalentFromId(Talents.T_ARMOUR_TRAINING)
		crit_reduction = crit_reduction + at.getCriticalChanceReduction(self, at)
		if self:knowTalent(self.T_GOLEM_ARMOUR) then
			local ga = Talents:getTalentFromId(Talents.T_GOLEM_ARMOUR)
			crit_reduction = crit_reduction + ga.getCriticalChanceReduction(self, ga)
		end
	end
	if self:attr("combat_crit_reduction") then
		crit_reduction = crit_reduction + self:attr("combat_crit_reduction")
	end
	return crit_reduction
end

--- Computes physical crit for a damage
function _M:physicalCrit(dam, weapon, target, atk, def, add_chance, crit_power_add)
	self.turn_procs.is_crit = nil

	local chance = self:combatCrit(weapon) + (add_chance or 0)
	crit_power_add = crit_power_add or 0
	if weapon and weapon.crit_power then crit_power_add = crit_power_add + weapon.crit_power/100 end

	if target and target:hasEffect(target.EFF_DISMAYED) then
		chance = 100
	end

	local crit = false

	if target and target:attr("combat_crit_vulnerable") then
		chance = chance + target:attr("combat_crit_vulnerable")
	end
	if target and target:hasEffect(target.EFF_SET_UP) then
		local p = target:hasEffect(target.EFF_SET_UP)
		if p and p.src == self then
			chance = chance + p.power
		end
	end
	if target and self:hasEffect(self.EFF_WARDEN_S_FOCUS) then
		local eff = self:hasEffect(self.EFF_WARDEN_S_FOCUS)
		if eff and eff.target == target then
			chance = chance + eff.power
			crit_power_add = crit_power_add + (eff.power/100)
		end
	end

	if target then
		chance = chance - target:combatCritReduction()
	end

	-- Scoundrel's Strategies
	if self:attr("cut") and target and target:knowTalent(self.T_SCOUNDREL) then
		chance = chance - target:callTalent(target.T_SCOUNDREL,"getCritPenalty")
	end

	if self:attr("stealth") and self:knowTalent(self.T_SHADOWSTRIKE) and target and not target:canSee(self) then
		chance = 100
	end

	if self:isAccuracyEffect(weapon, "axe") then
		local bonus = self:getAccuracyEffect(weapon, atk, def, 0.25, 25)  -- +25% crit at 100 accuracy
		print("[PHYS CRIT %] axe accuracy bonus", atk, def, "=", bonus)
		chance = chance + bonus
	end

	chance = util.bound(chance, 0, 100)

	print("[PHYS CRIT %]", self.turn_procs.auto_phys_crit and 100 or chance)
	if self.turn_procs.auto_phys_crit or rng.percent(chance) then
		if target and target:hasEffect(target.EFF_OFFGUARD) then
			crit_power_add = crit_power_add + 0.1
		end

		if self:isAccuracyEffect(weapon, "sword") then
			local bonus = self:getAccuracyEffect(weapon, atk, def, 0.004, 0.4)  -- +40% crit power at 100 accuracy
			print("[PHYS CRIT %] sword accuracy bonus", atk, def, "=", bonus)
			crit_power_add = crit_power_add + bonus
		end

		self.turn_procs.is_crit = "physical"
		self.turn_procs.crit_power = (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		dam = dam * (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		crit = true

		if self:knowTalent(self.T_EYE_OF_THE_TIGER) then self:triggerTalent(self.T_EYE_OF_THE_TIGER, nil, "physical") end

		self:fireTalentCheck("callbackOnCrit", "physical", dam, chance, target)
	end
	return dam, crit
end

-- need to get target for spell/mind crit defense

--- Computes spell crit for a damage
function _M:spellCrit(dam, add_chance, crit_power_add)
	self.turn_procs.is_crit = nil

	crit_power_add = crit_power_add or 0
	local chance = self:combatSpellCrit() + (add_chance or 0)
	local crit = false

	-- Unlike physical crits we can't know anything about our target here so we can't check if they can see us
	if self:attr("stealth") and self:knowTalent(self.T_SHADOWSTRIKE) then
		chance = 100
	end

	print("[SPELL CRIT %]", self.turn_procs.auto_spell_crit and 100 or chance)
	if self.turn_procs.auto_spell_crit or rng.percent(chance) then
		self.turn_procs.is_crit = "spell"
		self.turn_procs.crit_power = (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		dam = dam * (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		crit = true
		game.logSeen(self, "#{bold}#%s's spell attains critical power!#{normal}#", self:getName():capitalize())

		if self:attr("mana_on_crit") then self:incMana(self:attr("mana_on_crit")) end
		if self:attr("vim_on_crit") then self:incVim(self:attr("vim_on_crit")) end
		if self:attr("paradox_on_crit") then self:incParadox(self:attr("paradox_on_crit")) end
		if self:attr("positive_on_crit") then self:incPositive(self:attr("positive_on_crit")) end
		if self:attr("negative_on_crit") then self:incNegative(self:attr("negative_on_crit")) end

		if self:attr("spellsurge_on_crit") then
			local power = self:attr("spellsurge_on_crit")
			self:setEffect(self.EFF_SPELLSURGE, 10, {power=power, max=power*3})
		end

		if self:isTalentActive(self.T_BLOOD_FURY) then
			local t = self:getTalentFromId(self.T_BLOOD_FURY)
			t.on_crit(self, t)
		end

		if self:isTalentActive(self.T_CORONA) then
			local t = self:getTalentFromId(self.T_CORONA)
			t.on_crit(self, t)
		end

		if self:knowTalent(self.T_EYE_OF_THE_TIGER) then self:triggerTalent(self.T_EYE_OF_THE_TIGER, nil, "spell") end

		self:fireTalentCheck("callbackOnCrit", "spell", dam, chance)
	end
	return dam, crit
end

--- Computes mind crit for a damage
function _M:mindCrit(dam, add_chance, crit_power_add)
	self.turn_procs.is_crit = nil

	crit_power_add = crit_power_add or 0
	local chance = self:combatMindCrit() + (add_chance or 0)
	local crit = false

	if self:attr("stealth") and self:knowTalent(self.T_SHADOWSTRIKE) then
		chance = 100
	end

	print("[MIND CRIT %]", self.turn_procs.auto_mind_crit and 100 or chance)
	if self.turn_procs.auto_mind_crit or rng.percent(chance) then
		self.turn_procs.is_crit = "mind"
		self.turn_procs.crit_power = (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		dam = dam * (1.5 + crit_power_add + (self.combat_critical_power or 0) / 100)
		crit = true
		game.logSeen(self, "#{bold}#%s's mind surges with critical power!#{normal}#", self:getName():capitalize())

		if self:attr("hate_on_crit") then self:incHate(self:attr("hate_on_crit")) end
		if self:attr("psi_on_crit") then self:incPsi(self:attr("psi_on_crit")) end
		if self:attr("equilibrium_on_crit") then self:incEquilibrium(self:attr("equilibrium_on_crit")) end

		if self:knowTalent(self.T_EYE_OF_THE_TIGER) then self:triggerTalent(self.T_EYE_OF_THE_TIGER, nil, "mind") end
		if self:knowTalent(self.T_LIVING_MUCUS) then self:callTalent(self.T_LIVING_MUCUS, "on_crit") end

		self:fireTalentCheck("callbackOnCrit", "mind", dam, chance)
	end
	return dam, crit
end

--- Do we get hit by our own AOE ?
function _M:spellFriendlyFire()
	local chance = (self:getLck() - 50) * 0.2
	if self:isTalentActive(self.T_SPELLCRAFT) then chance = chance + self:getTalentLevelRaw(self.T_SPELLCRAFT) * 20 end
	chance = chance + (self.combat_spell_friendlyfire or 0)

	chance = 100 - chance
	print("[SPELL] friendly fire chance", chance)
	return util.bound(chance, 0, 100)
end

--- Gets mindpower
function _M:combatMindpowerRaw(add)
	if self.combat_precomputed_mindpower then return self.combat_precomputed_mindpower end

	add = add or 0

	if self.combat_generic_power then
		add = add + self.combat_generic_power
	end

	if self:knowTalent(self.T_SUPERPOWER) then
		add = add + 60 * self:getStr() / 100
	end

	local gloom = self:knowTalent(self.T_GLOOM)
	if gloom then
		local t = self:getTalentFromId(self.T_GLOOM)
		add = add + t.getMindpower(self)
	end

	if self:knowTalent(self.T_GESTURE_OF_POWER) then
		local t = self:getTalentFromId(self.T_GESTURE_OF_POWER)
		add = add + t.getMindpowerChange(self, t)
	end
	if self:knowTalent(self.T_LUNACY) then
		add = add + self:callTalent(self.T_LUNACY,"getMindpower") * self:getMag() / 100
	end
	if self:attr("psychometry_power") then
		add = add + self:attr("psychometry_power")
	end

	local d = math.max(0, (self.combat_mindpower or 0) + add + self:getWil() * 0.7 + self:getCun() * 0.4)

	if self:attr("dazed") then d = d / 2 end
	if self:attr("scoured") then d = d / 1.2 end

	if self:attr("hit_penalty_2h") then d = d * (1 - math.max(0, 20 - (self.size_category - 4) * 5) / 100) end

	return d
end

--- Gets mindpower
function _M:combatMindpower(mod, add)
	mod = mod or 1
	local d = self:combatMindpowerRaw(add)
	return self:rescaleCombatStats(d) * mod
end

--- Gets damage based on talent
function _M:combatTalentMindDamage(t, base, max)
	-- Compute at "max"
	local mod = max / ((base + 100) * ((math.sqrt(5) - 1) * 0.8 + 1))
	-- Compute real
	return self:rescaleDamage((base + (self:combatMindpower())) * ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) * mod)
end

--- Gets damage based on talent
-- stat == "str", "con", ....
-- base = value to match when stat = 10 before diminishing returns
-- max = value to match when stat = 100 before diminishing returns
-- no_dr = set true to skip extra diminishing returns and force values to match at base = TL1, Stat10 max = TL5, Stat100
function _M:combatTalentStatDamage(t, stat, base, max, no_dr)
	-- Compute at "max"
	local mod = max / ((base + 100) * ((math.sqrt(5) - 1) * 0.8 + 1))
	-- Compute real
	local dam = (base + (self:getStat(stat))) * ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) * mod
	if not no_dr then
		dam =  dam * (1 - math.log10(dam * 2) / 7)
	end
	dam = dam ^ (1 / 1.04)
	return self:rescaleDamage(dam)
end

--- Gets damage based on talent, basic stat, and interval
function _M:combatTalentIntervalDamage(t, stat, min, max, stat_weight)
	local stat_weight = stat_weight or 0.5
	local dam = min + (max - min)*((stat_weight * self:getStat(stat)/100) + (1 - stat_weight) * self:getTalentLevel(t)/6.5)
	dam =  dam * (1 - math.log10(dam * 2) / 7)
	dam = dam ^ (1 / 1.04)
	return self:rescaleDamage(dam)
end

--- Gets damage based on talent, stat, and interval
function _M:combatStatTalentIntervalDamage(t, stat, min, max, stat_weight)
	local stat_weight = stat_weight or 0.5
	return self:rescaleDamage(min + (max - min)*((stat_weight * self[stat](self)/100) + (1 - stat_weight) * self:getTalentLevel(t)/6.5))
end

--- Computes physical resistance (before scaling)
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatPhysicalResistRaw(fake, add)
	add = add or 0
	if not fake then
		add = add + (self:checkOnDefenseCall("physical") or 0)
	end
	if self:knowTalent(self.T_CORRUPTED_SHELL) then
		add = add + self:getCon() / 3
	end
	if self:knowTalent(self.T_POWER_IS_MONEY) then
		add = add + self:callTalent(self.T_POWER_IS_MONEY, "getSaves")
	end

	-- To return later
	local d = self.combat_physresist + (self:getCon() + self:getStr() + (self:getLck() - 50) * 0.5) * 0.35 + add
	if self:attr("dazed") then d = d / 2 end

	return d
end

--- Computes physical resistance (before scaling)
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatPhysicalResist(fake, add)
	local total = self:rescaleCombatStats(self:combatPhysicalResistRaw(fake, add))

	-- Psionic Balance
	if self:knowTalent(self.T_BALANCE) then
		local t = self:getTalentFromId(self.T_BALANCE)
		local ratio = t.getBalanceRatio(self, t)
		total = (1 - ratio)*total + self:combatMentalResist(fake)*ratio
	end
	return total
end

--- Computes spell resistance raw
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatSpellResistRaw(fake, add)
	add = add or 0
	if not fake then
		add = add + (self:checkOnDefenseCall("spell") or 0)
	end
	if self:knowTalent(self.T_CORRUPTED_SHELL) then
		add = add + self:getCon() / 3
	end
	if self:knowTalent(self.T_POWER_IS_MONEY) then
		add = add + self:callTalent(self.T_POWER_IS_MONEY, "getSaves")
	end

	-- To return later
	local d = self.combat_spellresist + (self:getMag() + self:getWil() + (self:getLck() - 50) * 0.5) * 0.35 + add
	if self:attr("dazed") then d = d / 2 end

	return d
end

--- Computes spell resistance
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatSpellResist(fake, add)
	local total = self:rescaleCombatStats(self:combatSpellResistRaw(fake, add))

	-- Psionic Balance
	if self:knowTalent(self.T_BALANCE) then
		local t = self:getTalentFromId(self.T_BALANCE)
		local ratio = t.getBalanceRatio(self, t)
		total = (1 - ratio)*total + self:combatMentalResist(fake)*ratio
	end
	return total
end

--- Computes mental resistance raw
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatMentalResistRaw(fake, add)
	add = add or 0
	if not fake then
		add = add + (self:checkOnDefenseCall("mental") or 0)
	end
	if self:knowTalent(self.T_CORRUPTED_SHELL) then
		add = add + self:getCon() / 3
	end
	if self:knowTalent(self.T_STEADY_MIND) then
		local t = self:getTalentFromId(self.T_STEADY_MIND)
		add = add + t.getMental(self, t)
	end
	if self:knowTalent(self.T_POWER_IS_MONEY) then
		add = add + self:callTalent(self.T_POWER_IS_MONEY, "getSaves")
	end

	local d = self.combat_mentalresist + (self:getCun() + self:getWil() + (self:getLck() - 50) * 0.5) * 0.35 + add
	if self:attr("dazed") then d = d / 2 end

	local nm = self:hasEffect(self.EFF_CURSE_OF_NIGHTMARES)
	if nm and rng.percent(20) and not fake then
		d = d * (1-self.tempeffect_def.EFF_CURSE_OF_NIGHTMARES.getVisionsReduction(nm, nm.level)/100)
	end

	return d
end

--- Computes mental resistance
--- Fake denotes a check not actually being made, used by character sheets etc.
function _M:combatMentalResist(fake, add)
	return self:rescaleCombatStats(self:combatMentalResistRaw(fake, add))
end

-- Called when a Save or Defense is checked
function _M:checkOnDefenseCall(type)
	local add = 0
	return add
end

--- Returns the resistance
function _M:combatGetFlatResist(type)
	if not self.flat_damage_armor then return 0 end
	local dec = (self.flat_damage_armor.all or 0) + (self.flat_damage_armor[type] or 0)
	return dec
end

--- Returns the resistance
function _M:combatGetResist(type)
	if not self.resists then return 0 end -- wtf
	local power = 100
	if self.force_use_resist and self.force_use_resist ~= type then
		type = self.force_use_resist
		power = self.force_use_resist_percent or 100
	end

	local a = math.min((self.resists.all or 0) / 100,1) -- Prevent large numbers from inverting the resist formulas
	local b = (type == "all") and 0 or math.min((self.resists[type] or 0) / 100,1)
	local r = util.bound(100 * (1 - (1 - a) * (1 - b)), -100, (self.resists_cap.all or 0) + (self.resists_cap[type] or 0))
	return r * power / 100
end

--- Returns the resistance penetration
function _M:combatGetResistPen(type, straight)
	if not self.resists_pen then return 0 end
	local pen = (self.resists_pen.all or 0) + (self.resists_pen[type] or 0)
	if straight then return math.min(pen, 70) end
	local add = 0

	if self.auto_highest_resists_pen and self.auto_highest_resists_pen[type] then
		local highest = self.resists_pen.all or 0
		for kind, v in pairs(self.resists_pen) do
			if kind ~= "all" then
				local inc = self:combatGetResistPen(kind, true)
				highest = math.max(highest, inc)
			end
		end
		return highest + self.auto_highest_resists_pen[type]
	end

	if self.knowTalent and self:knowTalent(self.T_UMBRAL_AGILITY) and type == "DARKNESS" then
		local t = self:getTalentFromId(self.T_UMBRAL_AGILITY)
		add = add + t.getPenetration(self, t)
	end

	return math.min(pen + add, 70)
end

--- Returns the damage affinity
function _M:combatGetAffinity(type)
	if not self.damage_affinity then return 0 end
	return (self.damage_affinity.all or 0) + (self.damage_affinity[type] or 0)
end

--- Returns the damage increase
function _M:combatHasDamageIncrease(type)
	if self.inc_damage[type] and self.inc_damage[type] ~= 0 then return true else return false end
end

--- Returns the damage increase
function _M:combatGetDamageIncrease(type, straight)
	local a = self.inc_damage.all or 0
	local b = type ~= "all" and self.inc_damage[type] or 0
	local inc = a + b
	if straight then return inc end

	if self.auto_highest_inc_damage and self.auto_highest_inc_damage[type] and self.auto_highest_inc_damage[type] > 0 then
		local highest = self.inc_damage.all or 0
		for kind, v in pairs(self.inc_damage) do
			if kind ~= "all" then
				local inc = self:combatGetDamageIncrease(kind, true)
				highest = math.max(highest, inc)
			end
		end
		return highest + self.auto_highest_inc_damage[type]
	end

	if self.inc_damage_level_penalty and self.level and self.inc_damage_level_penalty.end_level > self.level then
		local end_level = self.inc_damage_level_penalty.end_level
		local eff_level = end_level - self.level
		local penalty = math.ceil((self.inc_damage_level_penalty.start_at / end_level) * eff_level)
		inc = inc + penalty
	end

	return inc
end

--- Computes movement speed
function _M:combatMovementSpeed(x, y)
	local mult = 1
	if game.level and game.level.data.zero_gravity then
		mult = 3
	end

	local movement_speed = self.movement_speed
	if x and y and game.level.map:checkAllEntities(x, y, "creepingDark") and self:knowTalent(self.T_DARK_VISION) then
		local t = self:getTalentFromId(self.T_DARK_VISION)
		movement_speed = movement_speed + t.getMovementSpeedChange(self, t)
	end
	movement_speed = math.max(movement_speed, 0.4)
	return mult * (self.base_movement_speed or 1) / movement_speed
end

--- Computes see stealth
function _M:combatSeeStealth()
	local bonus = 0
	if self:knowTalent(self.T_PIERCING_SIGHT) then bonus = bonus + self:callTalent(self.T_PIERCING_SIGHT,"seePower") end
	if self:knowTalent(self.T_PRETERNATURAL_SENSES) then bonus = bonus + self:callTalent(self.T_PRETERNATURAL_SENSES, "sensePower") end
	-- level 50 with 100 cun ==> 50
	return self:combatScale(self.level/2 + self:getCun()/4 + (self:attr("see_stealth") or 0), 0, 0, 50, 50) + bonus -- Note bonus scaled separately from talents
end

--- Computes see invisible
function _M:combatSeeInvisible()
	local bonus = 0
	if self:knowTalent(self.T_PIERCING_SIGHT) then bonus = bonus + self:callTalent(self.T_PIERCING_SIGHT,"seePower") end
	if self:knowTalent(self.T_PRETERNATURAL_SENSES) then bonus = bonus + self:callTalent(self.T_PRETERNATURAL_SENSES, "sensePower") end
	return (self:attr("see_invisible") or 0) + bonus
end

--- Check if the actor has a gem bomb in quiver
function _M:hasAlchemistWeapon()
	if not self:getInven("QUIVER") then return nil, "no ammo" end
	local ammo = self:getInven("QUIVER")[1]
	if not ammo or not ammo.alchemist_power then
		return nil, "bad or no ammo"
	end
	return ammo
end

--- Check if the actor has a staff weapon
function _M:hasStaffWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon or weapon.subtype ~= "staff" then
		return nil
	end
	return weapon
end

--- Check if the actor has an axe weapon
function _M:hasAxeWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon or (weapon.subtype ~= "battleaxe" and weapon.subtype ~= "waraxe") then
		return nil
	end
	return weapon
end

--- Check if the actor has a 1H in mainhand
function _M:hasMHWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon or not weapon.combat then
		return nil
	end
	return weapon
end

--- Check if the actor has a weapon
function _M:hasWeaponType(type)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon then return nil end
	if type and weapon.combat.talented ~= type then return nil end
	return weapon
end

--- Check if the actor has a weapon offhand
function _M:hasOffWeaponType(type)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("OFFHAND") then return end
	local weapon = self:getInven("OFFHAND")[1]
	if not weapon then return nil end
	if type and (weapon.special_combat or weapon.combat).talented ~= type then return nil end
	return weapon
end

--- Check if the actor has a cursed weapon
function _M:hasCursedWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon or not weapon.curse then
		return nil
	end
	local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
	if not t.canCurseItem(self, t, weapon) then return nil end

	return weapon
end

--- Check if the actor has a cursed weapon
function _M:hasCursedOffhandWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("OFFHAND") then return end
	local weapon = self:getInven("OFFHAND")[1]
	if not weapon or not weapon.combat or not weapon.curse then
		return nil
	end
	local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
	if not t.canCurseItem(self, t, weapon) then return nil end

	return weapon
end

--- Check if the actor has a two handed weapon
function _M:hasTwoHandedWeapon()
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	if not self:getInven("MAINHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	if not weapon or not weapon.twohanded then
		return nil
	end
	return weapon
end

--- Check if the actor has a shield
function _M:hasShield()
	if self:attr("disarmed") then return nil end

	local shield1 = self:getInven("OFFHAND") and self:getInven("OFFHAND")[1]
	local shield2 = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]

	-- Switch if needed to find one
	if not shield1 then shield1, shield2 = shield2, nil end
	if not shield1 then return nil end

	-- Grab combat datas
	local combat1, combat2 = nil, nil
	if shield1.shield_normal_combat then combat1 = shield1.combat else combat1 = shield1.special_combat end
	if shield2 then if shield2.shield_normal_combat then combat2 = shield2.combat else combat2 = shield2.special_combat end end

	-- If no combat fields, it's not a shield
	if not combat1 then shield1 = nil end
	if not combat2 then shield2 = nil end

	-- Switch if needed to find one that is an actual shield
	if not shield1 then shield1, shield2, combat1, combat2 = shield2, nil, combat2, nil end
	if not shield1 then return nil end

	return shield1, combat1, shield2, combat2
end

function _M:combatShieldBlock()
	local shield1, combat1, shield2, combat2 = self:hasShield()
	if not combat1 then return end

	local block = combat1.block or 0
	if combat2 then block = block + (combat2.block or 0) end

	if self:attr("block_bonus") then block = block + self:attr("block_bonus") end
	if self:attr("shield_windwall") then
		local found = false

		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local i = 0
			local p = game.level.map(x, y, engine.Map.PROJECTILE+i)
			while p do
				if p.src and p.src:reactionToward(self) >= 0 then return end  
				i = i + 1
				p = game.level.map(x, y, engine.Map.PROJECTILE+i)
				found = true
			end end end

		if found then block = block + self:attr("shield_windwall") end
	end
	return block
end

-- Check if actor is unarmed
function _M:isUnarmed()
	local unarmed = true
	if not self:getInven("MAINHAND") or not self:getInven("OFFHAND") then return end
	local weapon = self:getInven("MAINHAND")[1]
	local offweapon = self:getInven("OFFHAND")[1]
	if weapon or offweapon then
		unarmed = false
	end
	return unarmed
end

-- Get the number of free hands the actor has
function _M:getFreeHands()
	if not self:getInven("MAINHAND") or not self:getInven("OFFHAND") then return 0 end
	local weapon = self:getInven("MAINHAND")[1]
	local offweapon = self:getInven("OFFHAND")[1]
	if weapon and offweapon then return 0 end
	if weapon and weapon.twohanded then return 0 end
	if weapon or offweapon then return 1 end
	return 2
end

--- Check if the actor dual wields melee weapons (use Archery:hasDualArcheryWeapon for ranged)
function _M:hasDualWeapon(type, offtype, quickset)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end
	local maininv, offinv = self:getInven(quickset and "QS_MAINHAND" or "MAINHAND"), self:getInven(quickset and "QS_OFFHAND" or "OFFHAND")
	local weapon, offweapon = maininv and maininv[1], offinv and offinv[1]
	if not offweapon and weapon and weapon.double_weapon then offweapon = weapon end

	if not (weapon and weapon.combat and not weapon.archery) or not (offweapon and offweapon.combat and not offweapon.archery) then
		return nil
	end
	offtype = offtype or type
	if type and weapon.combat.talented ~= type then return nil end
	if offtype and offweapon.combat.talented ~= offtype then return nil end
	return weapon, offweapon
end

--- Check if the actor dual wields melee weapons in the quick slot
function _M:hasDualWeaponQS(type, offtype)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end
	return self:hasDualWeapon(type, offtype, true)
end

--- Check if the actor uses psiblades
function _M:hasPsiblades(main, off)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	local weapon, offweapon = nil, nil
	if main then
		if not self:getInven("MAINHAND") then return end
		weapon = self:getInven("MAINHAND")[1]
		if not weapon or not weapon.combat or not weapon.psiblade_active then return nil, "unactivated psiblade" end
	end
	if off then
		if not self:getInven("OFFHAND") then return end
		offweapon = self:getInven("OFFHAND")[1]
		if not offweapon or not offweapon.combat or not offweapon.psiblade_active then return nil, "unactivated psiblade" end
	end
	return weapon, offweapon
end

--- Check if the actor has a light armor
function _M:hasLightArmor()
	if not self:getInven("BODY") then return end
	local armor = self:getInven("BODY")[1]
	if not armor or (armor.subtype ~= "cloth" and armor.subtype ~= "light" and armor.subtype ~= "mummy") then
		return nil
	end
	return armor
end

--- Check if the actor has a heavy armor
function _M:hasHeavyArmor()
	if not self:getInven("BODY") then return end
	local armor = self:getInven("BODY")[1]
	if not armor or (armor.subtype ~= "heavy" and armor.subtype ~= "massive") then
		return nil
	end
	return armor
end

--- Check if the actor has a massive armor
function _M:hasMassiveArmor()
	if not self:getInven("BODY") then return end
	local armor = self:getInven("BODY")[1]
	if not armor or armor.subtype ~= "massive" then
		return nil
	end
	return armor
end

--- Check if the actor has a cloak
function _M:hasCloak()
	if not self:getInven("CLOAK") then return end
	local cloak = self:getInven("CLOAK")[1]
	if not cloak then
		return nil
	end
	return cloak
end

-- Unarmed Combat; this handles grapple checks and building combo points
-- Builds Comob; reduces the cooldown on all unarmed abilities on cooldown by one
function _M:buildCombo()
	local duration = 5
	local power = 1
	-- Combo String bonuses
	if self:knowTalent(self.T_COMBO_STRING) then
		local t = self:getTalentFromId(self.T_COMBO_STRING)
		if rng.percent(t.getChance(self, t)) then
			power = 2
		end
		duration = 5 + t.getDuration(self, t)
	end

	if self:knowTalent(self.T_RELENTLESS_STRIKES) then
		local t = self:getTalentFromId(self.T_RELENTLESS_STRIKES)
		local sta = t.getStamina(self, t)
		local p = self:getCombo()
		if rng.percent(t.getChance(self, t)) then
			power = 2
			sta = sta + sta
		end
		if p>=5 or (power==2 and p>=4) then
			sta = sta + sta
		end
		self:incStamina(sta)
	end

	self:setEffect(self.EFF_COMBO, duration, {power=power})
end

function _M:getCombo(combo)
	local combo = 0
	local p = self:hasEffect(self.EFF_COMBO)
	if p then
		combo = p.cur_power
	end
		return combo
end

function _M:clearCombo()
	if self:hasEffect(self.EFF_COMBO) then
		self:removeEffect(self.EFF_COMBO)
	end
end

-- Check to see if the target is already being grappled; many talents have extra effects on grappled targets
function _M:isGrappled(source)
	local p = self:hasEffect(self.EFF_GRAPPLED)
	if p and p.src == source then
		return true
	else
		return false
	end
end

-- Breaks active grapples; called by a few talents that involve a lot of movement
function _M:breakGrapples()
	if self:hasEffect(self.EFF_GRAPPLING) then
		local p = self:hasEffect(self.EFF_GRAPPLING)
		if p.trgt then
			p.trgt:removeEffect(p.trgt.EFF_GRAPPLED)
		end
		self:removeEffect(self.EFF_GRAPPLING)
	end
end

-- grapple size check; compares attackers size and targets size
function _M:grappleSizeCheck(target)
	local size = target.size_category - self.size_category
	if size > 1 then
		self:logCombat(target, "#Source#'s grapple fails because #Target# is too big!")
		return true
	else
		return false
	end
end

-- Starts the grapple
function _M:startGrapple(target)
	-- pulls boosted grapple effect from the clinch talent if known
	local grappledParam = {src = self, apply_power = 1, silence = 0, power = 1, slow = 0, reduction = 0}
	local grappleParam = {sharePct = 0, drain = 0, trgt = target }
	local duration = 5
	if self:knowTalent(self.T_CLINCH) then
		local t = self:getTalentFromId(self.T_CLINCH)
		if self:knowTalent(self.T_CRUSHING_HOLD) then
			local t2 = self:getTalentFromId(self.T_CRUSHING_HOLD)
			grappledParam = t2.getBonusEffects(self, t2) -- get the 4 bonus parameters first
		end
		local power = self:physicalCrit(t.getPower(self, t), nil, target, self:combatAttack(), target:combatDefense())
		grappledParam["power"] = power -- damage/turn set by Clinch
		duration = t.getDuration(self, t)

		grappleParam["drain"] = t.getDrain(self, t) -- stamina/turn set by Clinch
		grappleParam["sharePct"] = t.getSharePct(self, t) -- damage shared with grappled set by Clinch

	end

	if grappledParam.silence == 1 and not target:canBe("silence") then
		grappledParam.silence = 0
	end
	if grappledParam.slow == 1 and not target:canBe("slow") then
		grappledParam.slow = 0
	end
	-- oh for the love of god why didn't I rewrite this entire structure
	grappledParam["src"] = self
	grappledParam["apply_power"] = self:combatPhysicalpower()
	-- Breaks the grapple before reapplying
	if self:hasEffect(self.EFF_GRAPPLING) then
		self:removeEffect(self.EFF_GRAPPLING, true)
		target:setEffect(target.EFF_GRAPPLED, duration, grappledParam, true)
		self:setEffect(self.EFF_GRAPPLING, duration, grappleParam, true)
		return true
	elseif target:canBe("pin") then
		target:setEffect(target.EFF_GRAPPLED, duration, grappledParam)
		target:crossTierEffect(target.EFF_GRAPPLED, self:combatPhysicalpower())
		self:setEffect(self.EFF_GRAPPLING, duration, grappleParam)
		return true
	else
		game.logSeen(target, "%s resists the grapple!", target:getName():capitalize())
		return false
	end
end

-- Display Combat log messages, highlighting the player and taking LOS and visibility into account
-- #source#|#Source# -> <displayString> self.name|self:getName():capitalize()
-- #target#|#Target# -> target.name|target:getName():capitalize()
function _M:logCombat(target, style, ...)
	if not game.uiset or not game.uiset.logdisplay then return end
	local src = self.__project_source or self
	local visible, srcSeen, tgtSeen = game:logVisible(src, target)  -- should a message be displayed?
	if visible then game.uiset.logdisplay(game:logMessage(src, srcSeen, target, tgtSeen, style, ...)) end
end
