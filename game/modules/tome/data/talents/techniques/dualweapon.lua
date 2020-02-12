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

------------------------------------------------------
-- General Dual Weapon Techniques
------------------------------------------------------
newTalent{
	name = "Dual Weapon Training",
	type = {"technique/dualweapon-training", 1},
	mode = "passive",
	points = 5,
	require = techs_dex_req1,
	-- called by  _M:getOffHandMult in mod\class\interface\Combat.lua
	-- This talent could probably use a slight buff at higher talent levels after diminishing returns kick in
	getoffmult = function(self,t)
		return	self:combatTalentLimit(t, 1, 0.65, 0.85)-- limit <100%
	end,
	info = function(self, t)
		return ([[Increases the damage of your off-hand weapon to %d%%.]]):tformat(100 * t.getoffmult(self,t))
	end,
}

newTalent{ -- Note: classes: Temporal Warden, Rogue, Shadowblade, Marauder
	name = "Dual Weapon Defense",
	type = {"technique/dualweapon-training", 2},
	mode = "passive",
	points = 5,
	require = techs_dex_req2,
	-- called by _M:combatDefenseBase in mod.class.interface.Combat.lua
	getDefense = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 45.7, 500) end,
	callbackOnLevelup = function(self, t, level) -- make sure NPC's start with the parry buff active
		if not self.player then
			game:onTickEnd(function()
				if not self:hasEffect(self.EFF_PARRY) then
					t.callbackOnActBase(self, t)
				end
			end, self.uid.."PARRY")
		end
	end,
	getDeflectChance = function(self, t) --Chance to parry with an offhand weapon
		return self:combatLimit(self:getTalentLevel(t)*self:getDex(), 90, 15, 20, 60, 250) -- limit < 90%, ~67% at TL 6.5, 55 dex
	end,
	getDamageChange = function(self, t)
		local dam,_,weapon = 0,self:hasDualWeapon()
		if not weapon or weapon.subtype=="mindstar" and not fake then return 0 end
		if weapon then
			dam = self:combatDamage(weapon.combat) * self:getOffHandMult(weapon.combat)
		end
		return self:combatScale(dam, 5, 10, 50, 250)
	end,
	-- deflect count handled in physical effect "PARRY" in mod.data.timed_effects.physical.lua
	getDeflects = function(self, t, fake)
		if fake or self:hasDualWeapon() then
			return self:combatStatScale("cun", 1, 2.25)
		else return 0
		end
	end,
	callbackOnActBase = function(self, t) -- refresh the buff each turn in mod.class.Actor.lua _M:actBase
		local mh, oh = self:hasDualWeapon()
		if (mh and oh) and oh.subtype ~= "mindstar" then
			self:setEffect(self.EFF_PARRY,1,{chance=t.getDeflectChance(self, t), dam=t.getDamageChange(self, t), deflects=t.getDeflects(self, t)})
		end
	end,
	on_unlearn = function(self, t)
		self:removeEffect(self.EFF_PARRY)
	end,
	info = function(self, t)
		return ([[You have learned to block incoming blows with your offhand weapon.
		When dual wielding, your defense is increased by %d.
		Up to %0.1f times a turn, you have a %d%% chance to parry up to %d damage (based on your your offhand weapon damage) from a melee attack.
		A successful parry reduces damage like armour (before any attack multipliers) and prevents critical strikes.  Partial parries have a proportionally reduced chance to succeed.  It is difficult to parry attacks from unseen attackers and you cannot parry with a mindstar.
		The defense and chance to parry improve with Dexterity.  The number of parries increases with Cunning.]]):tformat(t.getDefense(self, t), t.getDeflects(self, t, true), t.getDeflectChance(self,t), t.getDamageChange(self, t, true))
	end,
}

-- flat armor vs only on_hit damage, sustain may be toggled to possibly reflect damage back to defender
newTalent{
	name = "Close Combat Management",
	type = {"technique/dualweapon-training", 3},
	image = "talents/counter_attack.png",
	mode = "sustained",
	points = 5,
	require = techs_dex_req3,
	no_energy = true,
	sustain_stamina = 10,
	tactical = { BUFF = 1 },
	passives = function(self, t)
		self.turn_procs.reflectArmour = nil
	end,
	on_pre_use = function(self, t, silent)
		if not self:hasDualWeapon() then
			if not silent then game.logPlayer(self, "You must dual wield to use this talent.") end
			return false
		end
		return true
	end,
	getReflectArmour = function(self, t)
		return self:combatScale(self:getTalentLevel(t) * self:getDex(25, true), 0, 0, 35, 125, 0.5, 0, 1)
	end,
	getPercent = function(self, t) return math.max(0, self:combatTalentLimit(t, 50, 10, 30)) end,
	reflectArmour = function(self, t, combat) -- called in Combat.attackTargetHitProcs
		local tp_ra = self.turn_procs.reflectArmour
		if not tp_ra then
			local mh, oh = self:hasDualWeapon()
			tp_ra = {fa=t.getReflectArmour(self, t), pct=self:isTalentActive(t.id) and t.getPercent(self, t) or 0}
			if mh then
				if mh.subtype ~= "mindstar" then tp_ra.mh = mh end
				if oh.subtype ~= "mindstar" then tp_ra.oh = oh end
			end
			self.turn_procs.reflectArmour = tp_ra
		end
		if combat == (tp_ra.mh and tp_ra.mh.combat) or combat == (tp_ra.oh and tp_ra.oh.combat) then 
			return tp_ra.fa, tp_ra.pct
		else return 0, 0
		end
	end,
	activate = function(self, t)
		self.turn_procs.reflectArmour = nil
		local weapon, offweapon = self:hasDualWeapon()
		if not (weapon and offweapon) then
			game.logPlayer(self, "You must dual wield to manage contact with your target!")
			return nil
		end
		return {}
	end,
	deactivate = function(self, t, p)
		self.turn_procs.reflectArmour = nil
		return true
	end,
	info = function(self, t)
		return ([[You have learned how to carefully manage contact between you and your opponent.
		When striking in melee with your dual wielded weapons, you automatically avoid up to %d damage dealt to you from each of your target's on hit effects.  This improves with your Dexterity, but is not possible with mindstars.
		In addition, while this talent is active, you redirect %d%% of the damage you avoid this way back to your target.]]):
		tformat(t.getReflectArmour(self, t), t.getPercent(self, t))
	end,
}

--- Attack mainhand plus unarmed, with chance to confuse
newTalent{
	name = "Offhand Jab",
	type = {"technique/dualweapon-training", 3},
	image = "talents/golem_crush.png",
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 5,
	require = techs_dex_req3,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { confusion = 1.5 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getConfusePower = function(self, t) return self:combatTalentLimit(t, 50, 25, 40) end,
	getConfuseDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	on_learn = function(self, t)
		self:attr("show_gloves_combat", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("show_gloves_combat", -1)
	end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You must dual wield to perform an Offhand Jab!")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		
		local dam_mult = t.getDamage(self, t)

		-- First attack with mainhand
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, dam_mult)

		-- Then attack unarmed
		speed, hit = self:attackTargetWith(target, self:getObjectCombat(nil, "barehand"), nil, dam_mult+1.25)
		if hit then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, t.getConfuseDuration(self, t), {apply_power=self:combatAttack(), power=t.getConfusePower(self, t)})
			else
				game.logSeen(target, "%s resists the surprise strike!", target:getName():capitalize())
			end
		end
		return true
	end,
	info = function(self, t)
		local dam = 100 * t.getDamage(self, t)
		return ([[With a quick shift of your momentum, you execute a surprise unarmed strike in place of your normal offhand attack.
		This allows you to attack with your mainhand weapon for %d%% damage and unarmed for %d%% damage.  If the unarmed attack hits, the target is confused (%d%% power) for %d turns.
		The chance to confuse increases with your Accuracy.]])
		:tformat(dam, dam*1.25, t.getConfusePower(self, t), t.getConfuseDuration(self, t))
	end,
}

------------------------------------------------------
-- Primary Attacks
------------------------------------------------------
newTalent{
	name = "Dual Strike",
	type = {"technique/dualweapon-attack", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 15,
	require = techs_dex_req1,
	requires_target = true,
	is_melee = true,
	tactical = { ATTACK = { weapon = 1, offhand = 1 }, DISABLE = { stun = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getStunDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Dual Strike without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- First attack with offhand
		local speed, hit = self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, self:combatTalentWeaponDamage(t, 0.7, 1.5)))

		-- Second attack with mainhand
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStunDuration(self, t), {apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the stunning strike!", target:getName():capitalize())
			end

			-- Attack after the stun, to benefit from backstabs
			self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 0.7, 1.5))
		end

		return true
	end,
	info = function(self, t)
		return ([[Attack with your offhand weapon for %d%% damage. If the attack hits, the target is stunned for %d turns, and you hit it with your mainhand weapon doing %d%% damage.
		The stun chance increases with your Accuracy.]])
		:tformat(100 * self:combatTalentWeaponDamage(t, 0.7, 1.5), t.getStunDuration(self, t), 100 * self:combatTalentWeaponDamage(t, 0.7, 1.5))
	end,
}

newTalent{
	name = "Flurry",
	type = {"technique/dualweapon-attack", 2},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 30,
	require = techs_dex_req2,
	requires_target = true,
	is_melee = true,
	tactical = { ATTACK = { weapon = 4 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Flurry without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)

		return true
	end,
	info = function(self, t)
		return ([[Lashes out with a flurry of blows, hitting your target three times with each weapon for %d%% damage.]]):tformat(100 * self:combatTalentWeaponDamage(t, 0.4, 1.0))
	end,
}

newTalent{
	name = "Heartseeker",
	type = {"technique/dualweapon-attack", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 10,
	require = techs_dex_req3,
	is_melee = true,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.7) end,
	getCrit = function(self, t) return self:combatTalentLimit(t, 50, 10, 30) end,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t)} end,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 5.5))+1 end,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, CLOSEIN = 2 },
	on_pre_use = function(self, t, silent) 
		if not self:hasDualWeapon() then 
			if not silent then 
			game.logPlayer(self, "You require two weapons to use this talent.") 
		end 
			return false 
		end
		if self:attr("never_move") then return false end
		return true 
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		if core.fov.distance(self.x, self.y, x, y) > 1 then
			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
			local linestep = self:lineFOV(x, y, block_actor)
	
			local tx, ty, lx, ly, is_corner_blocked
			repeat  -- make sure each tile is passable
				tx, ty = lx, ly
				lx, ly, is_corner_blocked = linestep:step()
			until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move", self)
	
			if not tx or not ty or core.fov.distance(x, y, tx, ty) > 1 then return nil end
	
			local ox, oy = self.x, self.y
			self:move(tx, ty, true)
			if config.settings.tome.smooth_move > 0 then
				self:resetMoveAnim()
				self:setMoveAnim(ox, oy, 8, 5)
			end
		end
		
		-- Attack
		if not core.fov.distance(self.x, self.y, x, y) == 1 then return nil end
		
		local cpow = t.getCrit(self,t)
		self:attr("combat_critical_power", cpow)			
		self:attackTarget(target, nil, t.getDamage(self,t), true)
		self:attr("combat_critical_power", -cpow)			
		
		return true
	end,
	info = function(self, t)
		dam = t.getDamage(self,t)*100
		crit = t.getCrit(self,t)
		return ([[Swiftly leap to your target and strike at their vital points with both weapons, dealing %d%% weapon damage. This attack deals %d%% increased critical strike damage.]]):
		tformat(dam, crit)
	end,
}

newTalent{
	name = "Whirlwind",
	type = {"technique/dualweapon-attack", 4},
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 10,
	is_melee = true,
	require = techs_dex_req4,
	tactical = { ATTACKAREA = { weapon = 2 }, CLOSEIN = 1.5 },
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 6, 2, 4)) end,
	radius = 1,
	requires_target = true,
	target = function(self, t)
		return  {type="beam", nolock=true, default_target=self, range=self:getTalentRange(t), talent=t }
	end,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 0.6, 1.1) end,
	proj_speed = 20, --not really a projectile, so make this super fast
	on_pre_use = function(self, t, silent) 
		if not self:hasDualWeapon() then 
			if not silent then 
			game.logPlayer(self, "You require two weapons to use this talent.") 
		end 
			return false 
		end
		if self:attr("never_move") then return false end
		return true 
	end,
	action = function(self, t)
		local mh, oh = self:hasDualWeapon()
		if not (mh and oh) then return end
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not (x and y) then return nil end
		if core.fov.distance(self.x, self.y, x, y) > tg.range or not self:hasLOS(x, y) then
			game.logPlayer(self, "The target location must be within range and within view.")
			return nil 
		end
		local _ _, x, y = self:canProject(tg, x, y)
		if not (x and y) or not self:hasLOS(x, y) then return nil end
		-- make sure the grid location is valid
		local mx, my, grids = util.findFreeGrid(x, y, 1, true, {[Map.ACTOR]=true})
		if mx and my then
			if core.fov.distance(self.x, self.y, mx, my) > tg.range or not self:hasLOS(mx, my) then -- not valid,  check other free grids
				mx, my = nil, nil
				for i, grid in ipairs(grids) do
					if core.fov.distance(self.x, self.y, grid[1], grid[2]) <= tg.range and self:hasLOS(grid[1], grid[2]) then
						mx, my = grid[1], grid[2]
						break
					end
				end
			end
		end
		if not (mx and my) then 
			game.logPlayer(self, "There is no open space in which to land near there.")
			return nil 
		end

		game.logSeen(self, "%s becomes a whirlwind of weapons!", self:getName():capitalize())

		local seen_targets = {}
		for px, py in core.fov.lineIterator(self.x, self.y, mx, my, "block_NOTHINGLOL") do
			local aoe = {type="ball", radius=1, friendlyfire=false, selffire=false, talent=t, display={ } }
			game.level.map:particleEmitter(px, py, 1, "meleestorm", {img="spinningwinds_red"})
			self:project(aoe, px, py, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if not target or seen_targets[target] or self.dead then return end
				local dam = 0
				seen_targets[target] = true
				local s, h, d = self:attackTargetWith(target, mh.combat, nil, t.getDamage(self, t))
				if h and d > 0 then dam = dam + d end
				s, h, d = self:attackTargetWith(target, oh.combat, nil, t.getDamage(self, t))
				if h and d > 0 then dam = dam + d end
				if dam > 0 and target:canBe('cut') then
					target:setEffect(target.EFF_CUT, 5, {power=dam*0.1, src=self, apply_power=self:combatPhysicalpower(), no_ct_effect=true})
				end
			end)
		end

		-- move the talent user
		self:move(mx, my, true)

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local range = self:getTalentRange(t)
		return ([[You quickly move up to %d tiles to arrive adjacent to a target location you can see, leaping around or over anyone in your way.  During your movement, you attack all foes within one grid of your path with both weapons for %d%% weapon damage, causing those struck to bleed for 50%% of the damage dealt over 5 turns.]]):
		tformat(range, damage*100)
	end,
}

