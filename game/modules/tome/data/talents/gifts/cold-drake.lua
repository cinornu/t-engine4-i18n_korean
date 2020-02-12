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

local Object = require "mod.class.Object"

newTalent{
	name = "Ice Claw",
	type = {"wild-gift/cold-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	equilibrium = 3,
	cooldown = 10,
	range = 0,
	radius = function(self, t) return 3 end,
	direct_hit = true,
	requires_target = true,
	tactical = { ATTACKAREA = { COLD = 2 } },
	is_melee = true,
	on_learn = function(self, t)
		self.combat_physresist = self.combat_physresist + 2
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1
	end,
	on_unlearn = function(self, t)
		self.combat_physresist = self.combat_physresist - 2
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1
	end,
	damagemult = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.7) end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				-- We need to alter behavior slightly to accomodate shields since they aren't used in attackTarget
				local shield, shield_combat = self:hasShield()
				local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat or self.combat
				if not shield then
					self:attackTarget(target, DamageType.ICE, t.damagemult(self, t), true)
				else
					self:attackTargetWith(target, weapon, DamageType.ICE, t.damagemult(self, t))
					self:attackTargetWith(target, shield_combat, DamageType.ICE, t.damagemult(self, t))
				end
			end
		end)
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[You call upon the mighty claw of a cold drake and rake a wave of freezing cold in front of you, doing %d%% weapon damage as Ice damage in a cone of radius %d. Ice damage gives a chance of freezing the target.
		Every level in Ice Claw additionally raises your Physical Save by 2.
		Each point in cold drake talents also increases your cold resistance by 1%%.

		This talent will also attack with your shield, if you have one equipped.]]):tformat(100 * t.damagemult(self, t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Icy Skin",
	type = {"wild-gift/cold-drake", 2},
	require = gifts_req2,
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_equilibrium = 10,
	range = 10,
	tactical = { ATTACK = 0.5, DEFEND = 2 }, -- doesn't check resistance of the target
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	getArmor = function(self, t) return self:combatTalentMindDamage(t, 5, 25) end,
	getLifePct = function(self, t) return self:combatTalentLimit(t, 1, 0.02, 0.10) end, -- Limit < 100% bonus
	getDamageOnMeleeHit = function(self, t) return 10 +  self:combatTalentMindDamage(t, 10, 30) end,
	activate = function(self, t)
		return {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.COLD]=t.getDamageOnMeleeHit(self, t)}),
			life = self:addTemporaryValue("max_life", t.getLifePct(self, t)*self.max_life),
			armor = self:addTemporaryValue("combat_armor", t.getArmor(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("max_life", p.life)
		self:removeTemporaryValue("combat_armor", p.armor)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		return true
	end,
	info = function(self, t)
		local life = t.getLifePct(self, t)
		return ([[Your skin forms icy scales and your flesh toughens, increasing your Maximum Life by %d%% and your Armour by %d.
		You also deal %0.2f cold damage to any enemies that physically strike you.
		Each point in cold drake talents also increases your cold resistance by 1%%.
		The life increase will scale with your Talent Level, and your Armour and retaliation cold damage will scale with Mindpower.]]):tformat(life * 100, t.getArmor(self, t), damDesc(self, DamageType.COLD, t.getDamageOnMeleeHit(self, t)))
	end,
}

newTalent{
	name = "Ice Wall",
	type = {"wild-gift/cold-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "defensive",
	equilibrium = 10,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 30, 15)) end,
	range = 10,
	tactical = { ATTACKAREA = {COLD = 0.5}, DISABLE = 2 },
	requires_target = true,
	target = function(self, t)
		local halflength = math.floor(t.getLength(self,t)/2)
		local block = function(_, lx, ly)
			return game.level.map:checkAllEntities(lx, ly, "block_move")
		end
		return {type="wall", range=self:getTalentRange(t), halflength=halflength, talent=t, halfmax_spots=halflength+1, block_radius=block} 
	end,
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getLength = function(self, t) return 1 + math.floor(self:combatTalentScale(t, 3, 7)/2)*2 end,
	getIceDamage = function(self, t) return self:combatTalentMindDamage(t, 3, 15) end,
	getIceRadius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 2)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end
		local ice_damage = self:mindCrit(t.getIceDamage(self, t))
		local ice_radius = t.getIceRadius(self, t)

		self:project(tg, x, y, function(px, py, tg, self)
			local oe = game.level.map(px, py, Map.TERRAIN)
			if not oe or oe.special then return end
			if not oe or oe:attr("temporary") or game.level.map:checkAllEntities(px, py, "block_move") then return end
			local e = Object.new{
				old_feat = oe,
				name = _t"ice wall", image = "npc/iceblock.png",
				desc = _t"a summoned, transparent wall of ice",
				type = "wall",
				display = '#', color=colors.LIGHT_BLUE, back_color=colors.BLUE,
				always_remember = true,
				can_pass = {pass_wall=1},
				does_block_move = true,
				show_tooltip = true,
				block_move = true,
				block_sight = false,
				temporary = t.getDuration(self, t),
				x = px, y = py,
				canAct = false,
				dam = ice_damage,
				radius = ice_radius,
				act = function(self)
					local t = self.summoner:getTalentFromId(self.T_ICE_WALL)
					local tg = {type="ball", range=0, radius=self.radius, friendlyfire=false, talent=t, x=self.x, y=self.y}
					self.summoner.__project_source = self
					self.summoner:project(tg, self.x, self.y, engine.DamageType.ICE, self.dam)
					self.summoner.__project_source = nil
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
						game.level:removeEntity(self)
						game.level.map:updateMap(self.x, self.y)
						game.nicer_tiles:updateAround(game.level, self.x, self.y)
					end
				end,
				dig = function(src, x, y, old)
					game.level:removeEntity(old, true)
					return nil, old.old_feat
				end,
				summoner_gain_exp = true,
				summoner = self,
			}
			e.tooltip = mod.class.Grid.tooltip
			game.level:addEntity(e)
			game.level.map(px, py, Map.TERRAIN, e)
		--	game.nicer_tiles:updateAround(game.level, px, py)
		--	game.level.map:updateMap(px, py)
		end)
		return true
	end,
	info = function(self, t)
		local icerad = t.getIceRadius(self, t)
		local icedam = t.getIceDamage(self, t)
		return ([[Summons an icy wall of %d length for %d turns. Ice walls are transparent, but block projectiles and enemies.
		Ice walls also emit freezing cold, dealing %0.2f damage for each ice wall within radius %d of an enemy, and with each wall giving a 25%% chance to freeze an enemy. This cold cannot hurt the talent user or their allies.
		Each point in cold drake talents also increases your cold resistance by 1%%.]]):tformat(3 + math.floor(self:getTalentLevel(t) / 2) * 2, t.getDuration(self, t), damDesc(self, DamageType.COLD, icedam),  icerad)
	end,
}

newTalent{
	name = "Ice Breath",
	type = {"wild-gift/cold-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 20,
	cooldown = 20,
	message = _t"@Source@ breathes ice!",
	tactical = { ATTACKAREA = { COLD = 2 }, DISABLE = { stun = 1 } },
	range = 0,
	radius = function(self, t) return math.min(13, math.floor(self:combatTalentScale(t, 5, 9))) end,
	getDamage = function(self, t)
		local bonus = self:knowTalent(self.T_CHROMATIC_FURY) and self:combatTalentStatDamage(t, "wil", 30, 500) or 0
		return self:combatTalentStatDamage(t, "str", 30, 500) + bonus
	end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local damage = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			
			DamageType:get(DamageType.COLD).projector(self, tx, ty, DamageType.COLD, damage)
			if target:canBe("stun") then
				target:setEffect(target.EFF_FROZEN, 3, {hp=damage, apply_power = self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the freeze!", target:getName():capitalize())
			end
		end, t.getDamage(self, t), {type="freeze"})

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_cold", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="icewings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		return ([[You breathe ice in a frontal cone of radius %d. Any target caught in the area will take %0.2f cold damage and be frozen for 3 turns.
		The damage will increase with your Strength, the critical chance is based on your Mental crit rate, and the Freeze apply power is based on your Mindpower.
		Each point in cold drake talents also increases your cold resistance by 1%%.]]):tformat( self:getTalentRadius(t), damDesc(self, DamageType.COLD, t.getDamage(self, t)))
	end,
}
