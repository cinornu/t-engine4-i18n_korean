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

--- Interface to add ToME archery combat system
module(..., package.seeall, class.make)

-- Typical Archery Sequence:
-- targets = archeryAcquireTargets(tg, params) to create a list of target spots for projectiles
-- 		This checks that the actor can shoot, gets the target (blocking until the target is selected)
-- 		and handles expending ammo, actor energy, resources, and displaying log messages as required
-- call archeryShoot(targets, talent, tg, params) to actually create and target the projectiles
--		Should be called only if targeting was successful
--		This creates a projectile targeted on each spot in the target table
-- The order of firing is (one) mainhand shooter, (one, if available) offhand shooter, and (one, if available) psionic focus shooter (if available)
-- archery_projectile(tx, ty, tg, self, tmp) is used to "attack" a target when the projectile reaches it
--		This handles hit chance, special on-hit effects, etc.

--  returns the (maximum) range of the actor's equipped archery weapon(s)
function _M:archery_range(t, type)
	local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon(type)
	if not (weapon and weapon.combat) and not (pf_weapon and pf_weapon.combat) then 
		if self:attr("warden_swap") and self:hasArcheryWeaponQS(type) then
			weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeaponQS(type)
		else
			return 1
		end
	end
	local br = (self.archery_bonus_range or 0)
	return math.max(weapon and br + weapon.combat.range or 6, offweapon and offweapon.combat and br + offweapon.combat.range or 0, pf_weapon and pf_weapon.combat and br + pf_weapon.combat.range or 0, self:attr("archery_range_override") or 0)
end

--- Look for possible archery targets
-- Called by the Shoot and other archery Talents
-- Takes care of removing enough ammo and other resources (once the target is selected)
-- @param tg = target table (interpreted by Target:getType)
--		tg.range specifies a maximum range for each shot, use self:self:attr("archery_range_override") to specify a minimum range for each shot
-- @param params = table of parameters to override target values including:
--		x,y = force target position
--		no_energy = true, use no energy(time)
--		infinite = true (use no ammo)
--		one_shot = true(fire one shot), multishot (# of targets to hit)
--		limit_shots = maximum # of shots to fire
--		ignore_ressources = true, ignore ressource check and don't consume them
--		ignore_weapon_range = true (fire all weapons even if out of range of target)
--		add_speed = add to combat_physspeed for this attack
-- returns a table of target data containing a list of target spots {x=tx, y=ty, ammo=a.combat}
--		entries may include main = {}, off = {}, psi = {}
function _M:archeryAcquireTargets(tg, params, force)
	params = params or {}
	local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon(params.type)

	if force and force.mainhand then weapon = force.mainhand end
	if force and force.offhand then offweapon = force.offhand end
	if force and force.ammo then ammo = force.ammo end

	-- Awesome, we can shoot from our offhand!
	if not weapon and offweapon then weapon, offweapon = offweapon, nil end -- treat offweapon as primary
	if not weapon and not pf_weapon then
		game.logPlayer(self, "You need a missile launcher (%s)!", ammo)
		return nil
	end
	local infinite = ammo and ammo.infinite or self:attr("infinite_ammo") or params.infinite

	if not ammo or (ammo.combat.shots_left <= 0 and not infinite) then
		game.logPlayer(self, "You do not have enough ammo left!")
		return nil
	end
	local br = (self.archery_bonus_range or 0)
	print("[ARCHERY ACQUIRE TARGETS WITH]", weapon and weapon.name, ammo.name, offweapon and offweapon.name, pf_weapon and pf_weapon.name)
	tg = tg or {}
	local max_range, warn_range = self:attr("archery_range_override") or 1, 40

	local weaponC, offweaponC, pf_weaponC
	local use_resources
	if weapon and not params.ignore_ressources then
		weaponC = weapon.combat
		max_range =  math.max(max_range, weaponC.range or 6)
		warn_range = math.min(warn_range, weaponC.range or 6)
		-- check resources
		use_resources = (weaponC.use_resources or ammo.combat.use_resources) and table.mergeAdd(table.clone(weaponC.use_resources) or {}, ammo.combat.use_resources or {}) or nil
		if use_resources then
			local ok, kind = self:useResources(use_resources, true)
			if not ok then
				print("== no ressource", kind)
				game.logPlayer(self, "#ORCHID#Your %s CANNOT SHOOT (Resource: %s%s#LAST#).", weapon:getName({do_color=true, no_add_name=true}), table.get(self.resources_def[kind], "color") or "#SALMON#", table.get(self.resources_def[kind], "name") or kind:capitalize())
				weaponC = nil
			end
		end
	end
	if offweapon and not params.ignore_ressources then
		offweaponC = offweapon.combat
		max_range =  math.max(max_range, offweaponC.range or 6)
		warn_range = math.min(warn_range, offweaponC.range or 6)
		use_resources = (offweaponC.use_resources or ammo.combat.use_resources) and table.mergeAdd(table.clone(offweaponC.use_resources) or {}, ammo.combat.use_resources or {}) or nil
		if use_resources then
			local ok, kind = self:useResources(use_resources, true)
			if not ok then
				game.logPlayer(self, "#ORCHID#Your %s CANNOT SHOOT (Resource: %s%s#LAST#).", offweapon:getName({do_color=true, no_add_name=true}), table.get(self.resources_def[kind], "color") or "#SALMON#", table.get(self.resources_def[kind], "name") or kind:capitalize())
				offweaponC = nil
			end
		end
	end
	if pf_weapon and not params.ignore_ressources then
		pf_weaponC = pf_weapon.combat
		max_range =  math.max(max_range, pf_weaponC.range or 6)
		warn_range = math.min(warn_range, pf_weaponC.range or 6)
		use_resources = (pf_weaponC.use_resources or ammo.combat.use_resources) and table.mergeAdd(table.clone(pf_weaponC.use_resources) or {}, ammo.combat.use_resources or {}) or nil
		if use_resources then
			local ok, kind = self:useResources(use_resources, true)
			if not ok then
				game.logPlayer(self, "#ORCHID#Your %s CANNOT SHOOT (Resource: %s%s#LAST#).", pf_weapon:getName({do_color=true, no_add_name=true}), table.get(self.resources_def[kind], "color") or "#SALMON#", table.get(self.resources_def[kind], "name") or kind:capitalize())
				pf_weaponC = nil
			end
		end
	end
	if not weaponC and not pf_weaponC then return nil end

	-- at least one shot is possible, set up targeting
	tg.type = tg.type or weaponC and weaponC.tg_type or offweaponC and offweaponC.tg_type or pf_weaponC and pf_weaponC.tg_type or ammo.combat.tg_type or "bolt"
	if tg.range then
		tg.warn_range, tg.max_range = br + math.min(tg.range, warn_range), br + math.min(tg.range, max_range)
	else
		tg.warn_range, tg.max_range = br + warn_range, br + max_range
	end
	-- Pass friendly actors
	if self:attr("archery_pass_friendly") then
		tg.friendlyfire=false	
		tg.friendlyblock=false
	end

	tg.display = tg.display or self:archeryDefaultProjectileVisual(weapon, ammo)

	-- hook to trigger before Archery target(s) are selected, resources used, etc.
	self:triggerHook{"Combat:archeryTargetKind", tg=tg, params=params, weapon=weaponC, offweapon=offweaponC, pf_weapon=pf_weaponC, ammo=ammo, mode="target"}

	-- Use the designated target or get one
	local x, y = params.x, params.y
	if not x or not y then
		local tg_range = tg.range
		tg.range = tg.max_range
		local archery_actor = self
		local archery_msg = false
		-- for the player, highlight the targeting cursor based on the range(s) of the weapons
		tg.display_update_min_range = tg.display_update_min_range or function(self, d)
			local range = core.fov.distance(self.target_type.start_x, self.target_type.start_y, d.lx, d.ly)
			if archery_actor.player and range > tg.warn_range and not archery_msg then
				if tg.warn_range ~= tg.max_range then
					game.logPlayer(archery_actor, "#ORCHID#Target out of range.  Hold <ctrl> to force all weapons to fire at targets out of ranges (%d - %d).", tg.warn_range, tg.max_range)
				else
					game.logPlayer(archery_actor, "#ORCHID#Target out of range.  Hold <ctrl> to force your weapon to fire at targets beyond its range (%d).", tg.warn_range)
				end
				archery_msg = true
			end
			if core.key.modState("ctrl") then -- all yellow in forced target mode
				d.s = self.sy return
			end
			if range <= self.target_type.warn_range then --blue up to warn range
				d.s = self.sb
			elseif range <= (self.target_type.max_range) then --yellow up to max range
				d.s = self.sy
			else -- red beyond max range
				d.s = self.sr
			end
		end
		x, y = self:getTarget(tg)  -- Note: this is a blocking routine
		tg.range = tg_range
	end
	if not x or not y then return nil end

	local recursing = false
	local targets = {}
	-- populate the targets table for a weapon using ammo and resources as required
	local runfire runfire = function(weapon, targets, realweapon)
		--	Note: if shooters with built-in infinite ammo are reintroduced, handle it here by specifying ammo to use
		-- calculate the range for the current weapon
		local weapon_range = math.min(tg.range or 40, math.max(br + weapon.range or 6, self:attr("archery_range_override") or 1))
		-- don't fire at targets out of range unless in forced target mode
		if not params.ignore_weapon_range and not core.key.modState("ctrl") and weapon_range < core.fov.distance(x, y, self.x, self.y) then
			print("[archeryAcquireTargets runfire] NOT FIRING", realweapon.name, x, y, "range limit:", weapon_range)
			return
		end
		use_resources = (weapon.use_resources or ammo.combat.use_resources) and table.mergeAdd(table.clone(weapon.use_resources) or {}, ammo.combat.use_resources or {}) or nil
		if params.one_shot then -- set up a single shot, using ammo and resources as needed
			if use_resources then  -- use resources
				local ok, kind = self:useResources(use_resources)
				if not ok then
					print("[archeryAcquireTargets runfire] NOT FIRING", realweapon.name, x, y, "due to resource", kind)
					game.logPlayer(self, "#ORCHID#You COULD NOT SHOOT your %s (Resource: %s%s#LAST#).", realweapon:getName({do_color=true, no_add_name=true}), table.get(self.resources_def[kind], "color") or "#SALMON#", table.get(self.resources_def[kind], "name") or kind:capitalize())
					return nil
			end
			end
			if (infinite or ammo.combat.shots_left > 0) then
				if not infinite then ammo.combat.shots_left = ammo.combat.shots_left - 1 end
				-- hook to trigger when a shot is possible before being designated
				local hd = {"Combat:archeryAcquire", tg=tg, params=params, weapon=weapon, realweapon=realweapon, ammo=ammo}
				self:triggerHook(hd)
				targets[#targets+1] = {x=x, y=y, ammo=ammo.combat}
			end
		else -- set up (possibly) multiple shots, using ammo and resources as needed
			local limit_shots = params.limit_shots
			self:project(tg, x, y, function(tx, ty)
				local target = game.level.map(tx, ty, game.level.map.ACTOR)
				if not target then return end
				if tx == self.x and ty == self.y then return end

				if limit_shots then
					if limit_shots <= 0 then return end
					limit_shots = limit_shots - 1
				end

				for i = 1, params.multishots or 1 do
					if use_resources then  -- use resources
						local ok, kind = self:useResources(use_resources)
						if not ok then
							print("[archeryAcquireTargets runfire] NOT FIRING", realweapon.name, x, y, "due to resource", kind)
							game.logPlayer(self, "#ORCHID#You COULD NOT SHOOT your %s (Resource: %s%s#LAST#).", realweapon:getName({do_color=true, no_add_name=true}), table.get(self.resources_def[kind], "color") or "#SALMON#", table.get(self.resources_def[kind], "name") or kind:capitalize())
							break
						end
					end
					if not infinite then -- use ammo
						if ammo.combat.shots_left > 0 then ammo.combat.shots_left = ammo.combat.shots_left - 1
						else break
						end
					end
					-- hook to trigger when a shot is possible before being designated
					local hd = {"Combat:archeryAcquire", tg=tg, params=params, weapon=weapon, realweapon=realweapon, ammo=ammo}
						self:triggerHook(hd)
					targets[#targets+1] = {x=tx, y=ty, ammo=ammo.combat}
				end
			end)
		end
		if weapon.attack_recurse and not recursing then
			recursing = true
			for i = 1, weapon.attack_recurse do runfire(weapon, targets, realweapon) end
			recursing = false
		end
	end

-- with the target selected, generate a table of spots to fire at
-- note: because talent resources are deducted in Actor:postUseTalent, which is called after this, shot resource costs will not prevent talent usage
	local any = 0
	if weaponC and not offweaponC then
		runfire(weaponC, targets, weapon)
		any = any + #targets
	elseif weaponC and offweaponC then
		targets = {main={}, off={}, dual=true}
		runfire(weaponC, targets.main, weapon)
		runfire(offweaponC, targets.off, offweapon)
		any = any + #targets.main + #targets.off
	end
	if pf_weaponC then
		targets.psi = {}
		runfire(pf_weaponC, targets.psi, pf_weapon)
		any = any + #targets.psi
	end
	if any > 0 then
		local sound = (weaponC or pf_weaponC).sound
		local speed = self:combatSpeed(weaponC or pf_weaponC, params.add_speed or 0)
		print("[SHOOT] speed", speed or 1, "=>", game.energy_to_act * (speed or 1))
		if not params.no_energy then self:useEnergy(game.energy_to_act * (speed or 1)) end
		if not params.no_sound and sound then game:playSoundNear(self, sound) end
		return targets
	else
		return nil
	end
end

--- Archery projectile code used when the projectile projects against targets
local function archery_projectile(tx, ty, tg, self, tmp)
	local DamageType = require "engine.DamageType"
	local weapon, ammo = tg.archery.weapon, tg.archery.ammo
	local talent = self:getTalentFromId(tg.talent_id)

	local target = game.level.map(tx, ty, game.level.map.ACTOR)
	if talent.archery_onreach then
		talent.archery_onreach(self, talent, tx, ty, tg, target)
	end
	if not target then return end

	local damtype = tg.archery.damtype or ammo.damtype or DamageType.PHYSICAL
	local mult = tg.archery.mult or 1

	self.turn_procs.weapon_type = {kind=weapon and weapon.talented or "unknown", mode="archery"}

	-- Does the blow connect? yes .. complex :/
	if tg.archery.use_psi_archery then self:attr("use_psi_combat", 1) end
	local atk, def = self:combatAttackRanged(weapon, ammo), target:combatDefenseRanged()
	local dam, apr, armor = self:combatDamage(weapon, nil, ammo), self:combatAPR(ammo) + (weapon and weapon.apr or 0), target:combatArmor()
	atk = atk + (tg.archery.atk or 0)
	dam = dam + (tg.archery.dam or 0)
	apr = apr + (tg.archery.apr or 0)
	print("[ATTACK ARCHERY]", self.__project_source and self.__project_source.uid," to ", target.name, " :: ", dam, apr, armor, "::", mult)

	-- If hit is over 0 it connects, if it is 0 we still have 50% chance
	local hitted = false
	local crit = false
	local deflect = 0
	if self:checkHit(atk, def) and (self:canSee(target) or self:attr("blind_fight") or rng.chance(3)) then
		print("[ATTACK ARCHERY] raw dam", dam, "versus", armor, "with APR", apr)

		local pres = util.bound(target:combatArmorHardiness() / 100, 0, 1)
		-- check if target deflects the blow (deflected blows cannot crit)
		local eff = target.knowTalent and target:hasEffect(target.EFF_PARRY)
		if eff and eff.parry_ranged then
			deflect = target:callEffect(target.EFF_PARRY, "doDeflect", self) or 0
			if deflect > 0 then
				game:delayedLogDamage(self, target, 0, ("%s(%d parried#LAST#)"):tformat(DamageType:get(damtype).text_color or "#aaaaaa#", deflect), false)
				dam = math.max(dam - deflect , 0)
				print("[ATTACK] after PARRY", dam)
			end
		end
		armor = math.max(0, armor - apr)
		dam = math.max(dam * pres - armor, 0) + (dam * (1 - pres))
		print("[ATTACK ARCHERY] after armor", dam)

		local damrange = self:combatDamageRange(ammo)
		dam = rng.range(dam, dam * damrange)
		print("[ATTACK ARCHERY] after range", dam)

		if target:hasEffect(target.EFF_COUNTERSTRIKE) then
			dam = target:callEffect(target.EFF_COUNTERSTRIKE, "onStrike", dam, self)
			print("[ATTACK] after counterstrike", dam)
		end

		if weapon and weapon.inc_damage_type then
			local inc = 0

			for k, v in pairs(weapon.inc_damage_type) do
				if target:checkClassification(tostring(k)) then inc = math.max(inc, v) end
			end

			dam = dam + dam * inc / 100

			print("[ATTACK] after inc by type (weapon)", dam)
		end

		if ammo and ammo.inc_damage_type then
			local inc = 0

			for k, v in pairs(ammo.inc_damage_type) do
				if target:checkClassification(tostring(k)) then inc = math.max(inc, v) end
			end

			dam = dam + dam * inc / 100

			print("[ATTACK] after inc by type (ammo)", dam)
		end

		if deflect == 0 then dam, crit = self:physicalCrit(dam, ammo, target, atk, def, tg.archery.crit_chance or 0, (tg.archery.crit_power or 0) + (weapon.crit_power or 0)/100) end
		print("[ATTACK ARCHERY] after crit", dam)

		dam = dam * mult * (weapon.dam_mult or 1)
		print("[ATTACK ARCHERY] after mult", dam)

		if self:isAccuracyEffect(ammo, "mace") then
			local bonus = 1 + self:getAccuracyEffect(ammo, atk, def, 0.002, 0.2)
			print("[ATTACK] mace accuracy bonus", atk, def, "=", bonus)
			dam = dam * bonus
		end
		
		if self and dam > 0 and self.knowTalent and self:isTalentActive(self.T_AIM) and self.__CLASSNAME ~= "mod.class.Grid" then
			local dist = math.min(math.max(0, core.fov.distance(self.x, self.y, target.x, target.y) - 3),8)
			if dist > 0 then 
				local dammult = self:callTalent(self.T_AIM, "getDamage") * dist 
				dam = dam * (1 + (dammult/100))
			end
		end

		-- hook to resolve after a hit is determined, before damage has been projected
		local hd = {"Combat:archeryDamage", hitted=hitted, target=target, weapon=weapon, ammo=ammo, damtype=damtype, mult=1, dam=dam}
		if self:triggerHook(hd) then
			dam = dam * hd.mult
		end
		print("[ATTACK ARCHERY] after hook", dam)

		if crit then self:logCombat(target, "#{bold}##Source# performs a ranged critical strike against #Target#!#{normal}#") end

		if tg.archery.crushing_blow then self:attr("crushing_blow", 1) end

		-- Damage conversion?
		-- Convert base damage to other damage types according to weapon and ammo
		local ammo_conversion, weapon_conversion = 0, 0
		if dam > 0 then
			local conv_dam
			local archery_state = {is_archery=true}
			if tmp then table.merge(archery_state, tmp) end
			if ammo and ammo.convert_damage then -- convert to ammo damage types first
				for typ, conv in pairs(ammo.convert_damage) do
					conv_dam = math.min(dam, dam * (conv / 100))
					print("[ATTACK ARCHERY]\tAmmo DamageType conversion%", conv, typ, conv_dam)
					ammo_conversion = ammo_conversion + conv_dam
					if conv_dam > 0 then
						DamageType:get(typ).projector(self, target.x, target.y, typ, conv_dam, archery_state)
					end
				end
				dam = dam - ammo_conversion
				print("[ATTACK ARCHERY]\t after Ammo DamageType conversion dam:", dam)
			end
			if weapon and weapon.convert_damage and dam > 0 then -- convert remaining damage to weapon damage types
				for typ, conv in pairs(weapon.convert_damage) do
					conv_dam = math.min(dam, dam * (conv / 100))
					print("[ATTACK ARCHERY]\tWeapon DamageType conversion%", conv, typ, conv_dam)
					weapon_conversion = weapon_conversion + conv_dam
					if conv_dam > 0 then
						DamageType:get(typ).projector(self, target.x, target.y, typ, conv_dam, archery_state)
					end
				end
				dam = dam - weapon_conversion
				print("[ATTACK ARCHERY]\t after Weapon DamageType conversion dam:", dam)
			end

			if dam > 0 then
				DamageType:get(damtype).projector(self, target.x, target.y, damtype, dam, archery_state)
			end
		end
		if tg.archery.crushing_blow then self:attr("crushing_blow", -1) end

		if not tg.no_archery_particle then game.level.map:particleEmitter(target.x, target.y, 1, "archery") end
		hitted = true

		if talent.archery_onhit then talent.archery_onhit(self, talent, target, target.x, target.y, tg) end

		-- add damage conversion back in so the total damage still gets passed
		dam = dam + ammo_conversion + weapon_conversion
		target:fireTalentCheck("callbackOnArcheryHit", self, dam, tg)
	else
		self:logCombat(target, "#Source# misses #target#.")

		if talent.archery_onmiss then talent.archery_onmiss(self, talent, target, target.x, target.y) end

		target:fireTalentCheck("callbackOnArcheryMiss", self, tg)
	end
	
	if tg.archery.proc_mult then
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus or 1
		self.__global_accuracy_damage_bonus = self.__global_accuracy_damage_bonus * tg.archery.proc_mult
	end
	
	-- Ranged project
	local weapon_ranged_project = weapon.ranged_project or {}
	local ammo_ranged_project = ammo.ranged_project or {}
	local self_ranged_project = self.ranged_project or {}
	local total_ranged_project = {}
	table.mergeAdd(total_ranged_project, weapon_ranged_project, true)
	table.mergeAdd(total_ranged_project, ammo_ranged_project, true)
	table.mergeAdd(total_ranged_project, self_ranged_project, true)
	if hitted and not target.dead then for typ, dam in pairs(total_ranged_project) do
		if dam > 0 then
			DamageType:get(typ).projector(self, target.x, target.y, typ, dam, tmp)
		end
	end end

	if not tg.archery.hit_burst then
		-- Ranged project (burst)
		local weapon_burst_on_hit = weapon.burst_on_hit or {}
		local ammo_burst_on_hit = ammo.burst_on_hit or {}
		local self_burst_on_hit = self.burst_on_hit or {}
		local total_burst_on_hit = {}
		table.mergeAdd(total_burst_on_hit, weapon_burst_on_hit, true)
		table.mergeAdd(total_burst_on_hit, ammo_burst_on_hit, true)
		table.mergeAdd(total_burst_on_hit, self_burst_on_hit, true)
		if hitted and not target.dead then for typ, dam in pairs(total_burst_on_hit) do
			if dam > 0 then
				self:project({type="ball", radius=1, friendlyfire=false}, target.x, target.y, typ, dam)
				tg.archery.hit_burst = true
			end
		end end
	end

	-- Ranged project (burst on crit)
	if not tg.archery.crit_burst then
		local weapon_burst_on_crit = weapon.burst_on_crit or {}
		local ammo_burst_on_crit = ammo.burst_on_crit or {}
		local self_burst_on_crit = self.burst_on_crit or {}
		local total_burst_on_crit = {}
		table.mergeAdd(total_burst_on_crit, weapon_burst_on_crit, true)
		table.mergeAdd(total_burst_on_crit, ammo_burst_on_crit, true)
		table.mergeAdd(total_burst_on_crit, self_burst_on_crit, true)
		if hitted and crit and not target.dead then for typ, dam in pairs(total_burst_on_crit) do
			if dam > 0 then
				self:project({type="ball", radius=2, friendlyfire=false}, target.x, target.y, typ, dam)
				tg.archery.crit_burst = true
			end
		end end
	end

	-- Talent on hit
	if hitted and not target.dead and weapon and weapon.talent_on_hit and next(weapon.talent_on_hit) and not self.turn_procs.ranged_talent then
		for tid, data in pairs(weapon.talent_on_hit) do
			if rng.percent(data.chance) then
				self.turn_procs.ranged_talent = true
				self:forceUseTalent(tid, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=data.level, ignore_ressources=true})
			end
		end
	end

	-- Talent on hit...  AMMO!
	if hitted and not target.dead and ammo and ammo.talent_on_hit and next(ammo.talent_on_hit) and not self.turn_procs.ranged_talent then
		for tid, data in pairs(ammo.talent_on_hit) do
			if rng.percent(data.chance) then
				self.turn_procs.ranged_talent = true
				self:forceUseTalent(tid, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=data.level, ignore_ressources=true})
			end
		end
	end

	-- Poison coating
	if hitted and not target.dead and self.vile_poisons and next(self.vile_poisons) and target:canBe("poison") and weapon and (weapon.talented == "sling" or weapon.talented == "bow") then
		local tid = rng.table(table.keys(self.vile_poisons))
		if tid then
			self:callTalent(tid, "proc", target, weapon)
		end
	end
	
	-- Temporal Cast
	if hitted and self:knowTalent(self.T_WEAPON_FOLDING) and self:isTalentActive(self.T_WEAPON_FOLDING) then
		self:callTalent(self.T_WEAPON_FOLDING, "doWeaponFolding", target)
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
	
	-- Special ammo effects  (passing the special definition to facilitate encapsulating multiple special effects)
	if hitted and ammo and ammo.special_on_hit then
		local specials = ammo.special_on_hit
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct and (not target.dead or special.on_kill) then
				special.fct(ammo, self, target, dam, special)
			end
		end
	end

	--Special effect on crit
	if hitted and crit and weapon and weapon.special_on_crit then
		local specials = weapon.special_on_crit
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct and (not target.dead or special.on_kill) then
				special.fct(weapon, self, target, dam, special)
			end
		end
	end
	
	--Special effect on crit AMMO!
	if hitted and crit and ammo and ammo.special_on_crit then
		local specials = ammo.special_on_crit
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct and (not target.dead or special.on_kill) then
				special.fct(ammo, self, target, dam, special)
			end
		end
	end

	-- Special effect on kill
	if hitted and weapon and weapon.special_on_kill and target.dead then
		local specials = weapon.special_on_kill
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct then
				special.fct(weapon, self, target, dam, special)
			end
		end
	end

	-- Special effect on kill A-A-A-AMMMO!
	if hitted and ammo and ammo.special_on_kill and target.dead then
		local specials = ammo.special_on_kill
		if specials.fct then specials = {specials} end
		for _, special in ipairs(specials) do
			if special.fct then
				special.fct(ammo, self, target, dam, special)
			end
		end
	end
	
	-- Siege Arrows
	if hitted and ammo and ammo.siege_impact and (not self.shattering_impact_last_turn or self.shattering_impact_last_turn < game.turn) then
		local dam = dam * ammo.siege_impact
		local invuln = target.invulnerable
		game.logSeen(target, "The shattering blow creates a shockwave!")
		target.invulnerable = 1 -- Target already hit, don't damage it twice
		self:project({type="ball", radius=1, friendlyfire=false}, target.x, target.y, DamageType.PHYSICAL, dam)
		target.invulnerable = invuln
		self.shattering_impact_last_turn = game.turn
	end

	if self ~= target then
		-- Regen on being hit
		if hitted and not target.dead and target:attr("stamina_regen_when_hit") then target:incStamina(target.stamina_regen_when_hit) end
		if hitted and not target.dead and target:attr("mana_regen_when_hit") then target:incMana(target.mana_regen_when_hit) end
		if hitted and not target.dead and target:attr("equilibrium_regen_when_hit") then target:incEquilibrium(-target.equilibrium_regen_when_hit) end
		if hitted and not target.dead and target:attr("psi_regen_when_hit") then target:incPsi(target.psi_regen_when_hit) end
		if hitted and not target.dead and target:attr("hate_regen_when_hit") then target:incHate(target.hate_regen_when_hit) end
		if hitted and not target.dead and target:attr("vim_regen_when_hit") then target:incVim(target.vim_regen_when_hit) end

		-- Resource regen on hit
		if hitted and self:attr("stamina_regen_on_hit") then self:incStamina(self.stamina_regen_on_hit) end
		if hitted and self:attr("mana_regen_on_hit") then self:incMana(self.mana_regen_on_hit) end
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

	self:fireTalentCheck("callbackOnArcheryAttack", target, hitted, crit, weapon, ammo, damtype, mult, dam, talent)
	-- hook to resolve after archery damage has been applied
	local hd = {"Combat:archeryHit", hitted=hitted, crit=crit, tg=tg, target=target, weapon=weapon, ammo=ammo, damtype=damtype, mult=mult, dam=dam}
	if self:triggerHook(hd) then hitted = hd.hitted end

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

	self.turn_procs.weapon_type = nil	
	if tg.archery.use_psi_archery then self:attr("use_psi_combat", -1) end
	self.__global_accuracy_damage_bonus = nil

end

-- Store it for addons
_M.archery_projectile = archery_projectile

-- launch projectiles to each spot in the targets list (from archeryAcquireTargets)
function _M:archeryShoot(targets, talent, tg, params, force)
	params = params or {}
	-- some extra safety checks
	if self:attr("disarmed") then
		game.logPlayer(self, "You are disarmed!")
		return nil
	end
	local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon(params.type)

	if force and force.mainhand then weapon = force.mainhand end
	if force and force.offhand then offweapon = force.offhand end
	if force and force.ammo then ammo = force.ammo end

	if not weapon and not pf_weapon then
		game.logPlayer(self, "You must wield a ranged weapon (%s)!", ammo)
		return nil
	end
	print("[ARCHERY SHOOT]", self.name, self.uid, "using weapon:", weapon and weapon.name, "ammo:", ammo and ammo.name, "offweapon:", offweapon and offweapon.name, "pf_weapon:", pf_weapon and pf_weapon.name)
	local weaponC, offweaponC, pf_weaponC = weapon and weapon.combat, offweapon and offweapon.combat, pf_weapon and pf_weapon.combat

	local tg = tg or {}
	tg.talent = tg.talent or talent
	
	-- Pass friendly actors
	if self:attr("archery_pass_friendly") or self:knowTalent(self.T_SHOOT_DOWN) then
		tg.friendlyfire=false	
		tg.friendlyblock=false
	end

	-- hook to trigger before any archery projectiles are created
	self:triggerHook{"Combat:archeryTargetKind", tg=tg, params=params, weapon=weaponC, offweapon=offweaponC, pf_weapon=pf_weaponC, ammo=ammo, mode="fire"}

	-- create a projectile for each target on the list
	local dofire = function(weapon, targets, realweapon)

		for i = 1, #targets do
			local tg = table.clone(tg) -- prevent overwriting params from different shooter/ammo combinations
			tg.archery = table.clone(params)
			tg.archery.weapon = weapon
			tg.archery.ammo = targets[i].ammo or ammo.combat
			-- calculate range, speed, type by shooter/ammo combination
			tg.range = math.min(tg.range or 40, math.max((self.archery_bonus_range or 0) + weapon.range or 6, self:attr("archery_range_override") or 1))
			tg.speed = (tg.speed or 10) + (ammo.travel_speed or 0) + (weapon.travel_speed or 0) + (self.combat and self.combat.travel_speed or 0)
			tg.type = tg.type or weapon.tg_type or tg.archery.ammo.tg_type or "bolt"
			tg.display = tg.display or targets[i].display or self:archeryDefaultProjectileVisual(realweapon, ammo)
		
			tg.archery.use_psi_archery = self:attr("use_psi_combat") or weapon.use_psi_archery
			print("[ARCHERY SHOOT dofire] Shooting weapon:", realweapon and realweapon.name, "to:", targets[i].x, targets[i].y)
			if realweapon.on_archery_trigger then realweapon.on_archery_trigger(realweapon, self, tg, params, targets[i], talent) end -- resources must be handled by the weapon function
			-- hook to trigger as each archery projectile is created
			local hd = {"Combat:archeryFire", tg=tg, archery = tg.archery, weapon=weapon, realweapon = realweapon, ammo=ammo}
			self:triggerHook(hd)
			local proj = self:projectile(tg, targets[i].x, targets[i].y, archery_projectile)
		end
	end

	if weapon and not offweapon and not targets.dual then
		dofire(weaponC, targets, weapon)
	elseif weapon and offweapon and targets.dual then
		dofire(weaponC, targets.main, weapon)
		dofire(offweaponC, targets.off, offweapon)
	else
		print("[SHOOT] error, mismatch between dual weapon/dual targets")
	end
	if pf_weapon and targets.psi then
		local combat = table.clone(pf_weaponC)
		combat.use_psi_archery = true -- psionic focus weapons always use psi combat
		dofire(combat, targets.psi, pf_weapon)
	end
end

--- Check if the actor has a missile launcher(s) and corresponding ammo
-- @param type = type of shooter to allow
-- quickset set true to check the quickset inventory slots
-- returns weapon, ammo, offhand weapon, psionic focus weapon (if present)
-- returns nil, msg if no compatible launcher/ammo combination is found
function _M:hasArcheryWeapon(type, quickset)
	if self:attr("disarmed") then
		return nil, "disarmed"
	end

	-- find ammo and shooters
	local ammo = table.get(self:getInven(quickset and "QS_QUIVER" or "QUIVER"), 1)
	if not ammo then return nil, "no ammo" end
	if not ammo.archery_ammo or not ammo.combat then return nil, "bad ammo" end
	local weapon = table.get(self:getInven(quickset and "QS_MAINHAND" or "MAINHAND"), 1)
	local msg
	if weapon and weapon.combat and weapon.archery_kind then
		if type and weapon.archery_kind ~= type then
			msg = "incompatible missile launcher"
		elseif weapon.archery ~= ammo.archery_ammo then
			msg = "incompatible ammo"
		end
		if msg then weapon = nil end
	else weapon = nil
	end
	local offweapon = self:attr("can_offshoot") and table.get(self:getInven(quickset and "QS_OFFHAND" or "OFFHAND"), 1)
	if offweapon and offweapon.combat and offweapon.archery_kind then
		msg = nil
		if type and offweapon.archery_kind ~= type then
			msg = "incompatible missile launcher"
		elseif offweapon.archery ~= ammo.archery_ammo then
			msg = "incompatible ammo"
		end
		if msg then offweapon = nil end
	else offweapon = nil
	end
	-- double_weapon
	if not offweapon and weapon and weapon.double_weapon then offweapon = weapon end
	local pf_weapon = self:attr("psi_focus_combat") and table.get(self:getInven(quickset and "QS_PSIONIC_FOCUS" or "PSIONIC_FOCUS"), 1)
	if pf_weapon and pf_weapon.combat and pf_weapon.archery_kind then
		msg = nil
		if type and pf_weapon.archery_kind ~= type then
			msg = "incompatible missile launcher"
		elseif pf_weapon.archery ~= ammo.archery_ammo then
			msg = "incompatible ammo"
		end
		if msg then pf_weapon = nil end
	else pf_weapon = nil
		end

	if not weapon then
		weapon, offweapon = offweapon, nil 
	end
	if not weapon and not pf_weapon then return nil, msg or "no shooter" end
	return weapon, ammo, offweapon, pf_weapon
end

--- Check if the actor has a missile launcher and corresponding ammo in the quick slots
-- @param type = type of shooter to allow
function _M:hasArcheryWeaponQS(type)
	return self:hasArcheryWeapon(type, true)
end

function _M:archeryDefaultProjectileVisual(weapon, ammo)
	if (ammo and ammo.proj_image) or (weapon and weapon.proj_image) then
		return {display=' ', particle="arrow", particle_args={tile="shockbolt/"..((ammo.shimmer_moddable and ammo.shimmer_moddable.moddable_tile_projectile) or ammo.proj_image or weapon.proj_image):gsub("%.png$", "")}}
		else
		return {display='/'}
		end
end

function _M:hasDualArcheryWeapon(type)
	local w, a, o = self:hasArcheryWeapon(type)
	if w and w.double_weapon and a and not o then return w, a, w end -- double_weapon
	if self.can_solo_dual_archery and w and not o then w, o = w, w end
	if self.can_solo_dual_archery and not w and o then w, o = o, o end
	if w and a and o then return w, a, o end
	return nil
end

--- Check if the actor has ammo
function _M:hasAmmo(type, quickset)
	local ammo = self:getInven(quickset and "QS_QUIVER" or "QUIVER")
	ammo = ammo and ammo[1]
	if not ammo then return nil, "no ammo" end
	if not (ammo.archery_ammo and ammo.combat and ammo.combat.capacity) then return nil, "bad ammo" end
	if type and ammo.archery_ammo ~= type then return nil, "incompatible ammo" end
	return ammo
end

--- Get the ammo in the quick slot.
function _M:hasAmmoQS(type)
	return self:hasAmmo(type, true)
end

-- Get the current reload rate.
function _M:reloadRate()
	return 1 + (self.ammo_reload_speed or 0) + (self.ammo_mastery_reload or 0)
end

-- Get the current reload rate for the quick slot ammo.
function _M:reloadRateQS()
	local ammo_main = self:hasAmmo()
	local ammo_qs = self:hasAmmoQS()
	local add = 0
	if ammo_main and ammo_main.wielder and ammo_main.wielder.ammo_reload_speed then
		add = add - ammo_main.wielder.ammo_reload_speed
	end
	if ammo_qs and ammo_qs.wielder and ammo_qs.wielder.ammo_reload_speed then
		add = add + ammo_qs.wielder.ammo_reload_speed
	end
	return self:reloadRate() + add
end

-- Increase ammo by reload amount. Returns true if actually reloaded.
function _M:reload()
	local ammo, err = self:hasAmmo()
	if not ammo then return end
	if ammo.combat.shots_left >= ammo.combat.capacity then return end
	local reloads = self:reloadRate()
	ammo.combat.shots_left = math.min(ammo.combat.capacity, ammo.combat.shots_left + reloads)
	return true
end

-- Increase qs ammo by reload amount. Returns true if actually reloaded.
function _M:reloadQS()
	local ammo, err = self:hasAmmoQS()
	if not ammo then return end
	if ammo.combat.shots_left >= ammo.combat.capacity then return end
	local reloads = self:reloadRateQS()
	ammo.combat.shots_left = math.min(ammo.combat.capacity, ammo.combat.shots_left + reloads)
	return true
end
