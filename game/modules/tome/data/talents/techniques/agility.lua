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

local preUse = function(self, t, silent)
	if not self:hasShield() or not archerPreUse(self, t, true) then
		if not silent then game.logPlayer("You require a ranged weapon and a shield to use this talent.") end
		return false
	end
	return true
end

archery_range = Talents.main_env.archery_range

newTalent{
	name = "Agile Defense",
	type = {"technique/agility", 1},
	require = techs_dex_req_high1,
	points = 5,
	no_unlearn_last = true,
	mode = "passive",
	getChance = function(self, t) return math.floor(self:combatTalentScale(t, 15, 45)) end,
	on_learn = function(self, t)
		self:attr("allow_wear_shield", 1)
		self:attr("show_shield_combat", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("allow_wear_shield", -1)
		self:attr("show_shield_combat", 1)
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, tmp)
		local chance = t.getChance(self, t)
		if not rng.percent(chance) then return end
		--this might be worth doing later, but for now let it block DoTs
		--local psrc = src.__project_source
		--if psrc then
		--	local kind = util.getval(psrc.getEntityKind)
		--	if kind == "projectile" or kind == "trap" or kind == "object" then
		--	else
		--		return
		--	end
		--end
		local lastdam = dam
		local shield = self:hasShield()
		if not shield then return end
		local t = self:getTalentFromId(self.T_BLOCK)
		if self:isTalentCoolingDown(t) then return end
		local reduce = t.getBlockValue(self,t)/2

		dam = math.max(dam - reduce, 0)
		print("[PROJECTOR] after static reduction dam", dam)
		game:delayedLogDamage(src or self, self, 0, ("%s(%d deflected)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam - dam), false)
		return {dam=dam}
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[You are trained in an agile, mobile fighting technique combining sling and shield. This allows shields to be equipped, using Dexterity instead of Strength as a requirement.
While you have a shield equip and your Block talent is not on cooldown, you have a %d%% chance to deflect any incoming damage, reducing it by 50%% of your shield’s block value.]])
			:tformat(chance)
	end,
}

newTalent{
	name = "Vault",
	type = {"technique/agility", 2},
	require = techs_dex_req_high2,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
	requires_target = true,
	tactical = { ATTACK = 2, ESCAPE = 1, DISABLE = { stun = 1 } },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	is_special_melee = true,
	on_pre_use = function(self, t, silent)
		return preUse(self, t, silent)
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.5, 3.0) end,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5)) end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		if not shield then
			game.logPlayer(self, "You require a shield to use this talent.")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- Leap
		local tg = {type="hit", nolock=true, range=t.getDist(self,t)}
		local x, y  = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		if game.level.map(x, y, Map.ACTOR) then
			x, y = util.findFreeGrid(x, y, 1, true, {[Map.ACTOR]=true})
			if not x then return end
		end

		if game.level.map:checkAllEntities(x, y, "block_move") then return end

		-- Modify shield combat to use dex.
		local combat = table.clone(shield_combat, true)
		if combat.dammod.str and combat.dammod.str > 0 then
			combat.dammod.dex = (combat.dammod.dex or 0) + combat.dammod.str
			combat.dammod.str = nil
		end

		-- First attack with shield
		local speed, hit = self:attackTargetWith(target, combat, nil, t.getDamage(self, t))

		-- Daze
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, 2, {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the daze!", target:getName():capitalize())
			end
		end
		
		local ox, oy = self.x, self.y
		self:move(x, y, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end
		
		-- Free block?
		if self:getTalentLevel(t) >= 5 then
			self:forceUseTalent(self.T_BLOCK, {ignore_energy=true, ignore_cd = true, silent = true})
		end

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t) * 100
		local range = t.getDist(self, t)
		return ([[Leap onto an adjacent target with your shield, striking them for %d%% damage and dazing them for 2 turns, then using them as a springboard to leap to a tile within range %d.
The shield bash will use Dexterity instead of Strength for the shield's bonus damage.
At talent level 5, you will immediately enter a blocking stance on landing.]])
		:tformat(dam, range)
	end,
}


newTalent{
	name = "Bull Shot",
	type = {"technique/agility", 3},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 18,
	require = techs_dex_req_high3,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 } },
	requires_target = true,
	on_pre_use = function(self, t, silent)
		if not archerPreUse(self, t, silent, "sling") then return false end
		if self:attr("never_move") then return false end
		return true
	end,
	callbackOnMove = function(self, t, moved, force, ox, oy)
		if (self.x == ox and self.y == oy) or force then return end
		local cooldown = self.talents_cd[t.id] or 0
		if cooldown > 0 then
			self.talents_cd[t.id] = math.max(cooldown - 1, 0)
		end
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 2.2) end, --high damage, high opportunity cost
	getDist = function(self, t) if self:getTalentLevel(t) >= 3 then return 2 else return 1 end end,
	archery_onhit = function(self, t, target, x, y)
		if not target or not target:canBe("knockback") then return end
		target:knockback(self.x, self.y, t.getDist(self, t))
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local linestep = self:lineFOV(x, y, block_actor)
		
		local tx, ty, lx, ly, is_corner_blocked 
		repeat  -- make sure each tile is passable
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = linestep:step()
		until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move", self)
		if not tx or core.fov.distance(self.x, self.y, tx, ty) < 1 then
			game.logPlayer(self, "You are too close to build up momentum!")
			return
		end
		if not tx or not ty or core.fov.distance(x, y, tx, ty) > 1 then return nil end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end
		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) == 1 then
			local targets = self:archeryAcquireTargets(nil, {one_shot=true, x=x, y=y})
			if targets then
				self:archeryShoot(targets, t, nil, {mult=t.getDamage(self,t)})
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[You rush toward your foe, readying your shot. If you reach the enemy, you release the shot, imbuing it with great power.
		The shot does %d%% weapon damage and knocks back your target by %d.
		The cooldown of this talent is reduced by 1 each time you move.
		This requires a sling to use.]]):
		tformat(t.getDamage(self,t)*100, t.getDist(self, t))
	end,
}

newTalent{
	name = "Rapid Shot",
	type = {"technique/agility", 4},
	points = 5,
	mode = "sustained",
	require = techs_dex_req_high4,
	cooldown = 30,
	sustain_stamina = 50,
	no_energy = true,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent) end,
	getAttackSpeed = function(self, t) return math.floor(self:combatTalentLimit(t, 35, 10, 25))/100 end,
	getMovementSpeed = function(self, t) return math.floor(self:combatTalentScale(t, 25, 50))/100 end,
	getTurn = function(self, t) return math.floor(self:combatTalentLimit(t, 20, 4, 12)) end,
	on_pre_use = function(self, t, silent)
		if not archerPreUse(self, t, silent, "sling") then return false end
		return true
	end,
	callbackOnArcheryAttack = function(self, t, target, hitted)
		local dist = math.max(0, core.fov.distance(self.x, self.y, target.x, target.y) - 3)
		if hitted and not target.turn_procs.rapid_fire and dist < 5 then
			target.turn_procs.rapid_fire = true
			turn = t.getTurn(self,t)/100
			energy = turn - (turn * dist * 0.2)
			self.energy.value = self.energy.value + game.energy_to_act*energy
		end
		game:onTickEnd(function() 
			self:setEffect(self.EFF_RAPID_MOVEMENT, 1, {src=self, power=t.getMovementSpeed(self,t)})
		end)
	end,
	activate = function(self, t)
		local weapon = self:hasArcheryWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Rapid Fire without a bow or sling!")
			return nil
		end

		local speed = t.getAttackSpeed(self, t)
		local ret = {
			speed = self:addTemporaryValue("combat_physspeed", speed),
		}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1.5, rotspeed=7, img="rapid_shot_rotating_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, wobblingType=0, appearTime=0.4, time_factor=600, noup=2.0}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1.5, rotspeed=7, img="rapid_shot_rotating_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, wobblingType=0, appearTime=0.4, time_factor=600, noup=1.0}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		return true
	end,
	info = function(self, t)
		local atk = t.getAttackSpeed(self,t)*100
		local move = t.getMovementSpeed(self,t)*100
		local turn = t.getTurn(self,t)
		return ([[Enter a fluid, mobile shooting stance that excels at close combat. Your ranged attack speed is increased by %d%% and each time you shoot you gain %d%% increased movement speed for 2 turns.
Ranged attacks against targets will also grant you up to %d%% of a turn. This is 100%% effective against targets within 3 tiles, and decreases by 20%% for each tile beyond that (to 0%% at 8 tiles). This cannot occur more than once per turn.
Requires a sling to use.]]):
		tformat(atk, move, turn)
	end,
}
