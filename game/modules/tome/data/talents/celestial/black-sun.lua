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
	name = "Breach", short_name = "FALLEN_BREACH",
	type = {"celestial/black-sun", 1},
	require = str_req_high1,
	points = 5,
	cooldown = 12,
	positive = -15,
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", nolock=true, range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 75) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5.6)) end,
	getMaxRadius = function(self, t) return math.max(1, math.floor(self:combatTalentLimit(t, 5, 1, 3))) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, px, py = self:canProject(tg, x, y)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self, t)
		local rad = 1
		local max_radius = t.getMaxRadius(self, t)
		dam = self:spellCrit(dam)
		local oe = game.level.map(px, py, Map.TERRAIN+1)
		if (oe and oe.is_maelstrom) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end
		
		local e = Object.new{
			old_feat = oe,
			type = "void", subtype = "black hole",
			name = self.name:capitalize().. "'s black hole",
			display = ' ',
			tooltip = mod.class.Grid.tooltip,
			always_remember = true,
			temporary = dur,
			is_maelstrom = true,
			x = px, y = py,
			canAct = false,
			dam = dam,
			radius = rad,
			max_radius = max_radius,
			rebuild_particles = function(self)
				if self.particles then game.level.map:removeParticleEmitter(self.particles) end
				if self.particles2 then game.level.map:removeParticleEmitter(self.particles2) end
				
				local particle = engine.Particles.new("generic_vortex", self.radius, {radius=self.radius, rm=255, rM=255, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				local particle2 = engine.Particles.new("image", self.radius, {size=64*self.radius, image="particles_images/breach"}) particle2.zdepth = 4
				if core.shader.allow("distort") then particle:setSub("vortex_distort", self.radius, {radius=self.radius}) end
				self.particles2 = game.level.map:addParticleEmitter(particle2, self.x, self.y)
				self.particles = game.level.map:addParticleEmitter(particle, self.x, self.y)
				game:shakeScreen(10, 3)
			end,
			act = function(self)
				local tgts = {}
				local Map = require "engine.Map"
				local DamageType = require "engine.DamageType"
				if self.radius < self.max_radius then
					self.radius = math.min(self.max_radius, (self.radius + 1))
					self:rebuild_particles()
				end
				local grids = core.fov.circle_grids(self.x, self.y, self.radius, true)
				for x, yy in pairs(grids) do
					for y, _ in pairs(grids[x]) do
						local Map = require "engine.Map"
						local target = game.level.map(x, y, Map.ACTOR)
						local friendlyfire = false
						if target and not (friendlyfire == false and self.summoner:reactionToward(target) >= 0) then 
							tgts[#tgts+1] = {actor=target, sqdist=core.fov.distance(self.x, self.y, x, y)}
						end
					end
				end
				table.sort(tgts, "sqdist")
				for i, target in ipairs(tgts) do
					local old_source = self.summoner.__project_source
					self.summoner.__project_source = self
					DamageType:get(DamageType.BLACK_HOLE_GRAVITY).projector(self.summoner, target.actor.x, target.actor.y, DamageType.BLACK_HOLE_GRAVITY, self.dam)
					self.summoner.__project_source = old_source
				end
				
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					game.level.map:removeParticleEmitter(self.particles)	
					game.level.map:removeParticleEmitter(self.particles2)
					if self.old_feat then game.level.map(self.x, self.y, engine.Map.TERRAIN+1, self.old_feat)
					else game.level.map:remove(self.x, self.y, engine.Map.TERRAIN+1) end
					game.level:removeEntity(self)
					game.level.map:updateMap(self.x, self.y)
					game.nicer_tiles:updateAround(game.level, self.x, self.y)
				end
			end,
			summoner_gain_exp = true,
			summoner = self,
												}
		e:rebuild_particles()
		
		game:playSoundNear(self, "talents/fallen_brokenglass")
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN+1, e)
		game.level.map:updateMap(x, y)
		return true
	end,
	info = function(self, t)
		local rad = t.getMaxRadius(self,t)
		local dam = t.getDamage(self,t)/2
		local dur = t.getDuration(self,t)
		local entropy = 0
		return ([[Open a radius 1 rift in spacetime at the targeted location for %d turns, increasing in radius by 1 each turn to a maximum of %d.
		All caught within the rift are pulled towards the center and take %0.2f gravity damage.
The damage will increase with your Spellpower.]]):
		tformat(dur, rad, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

newTalent{
	name = "Devourer Stance",
	type = {"celestial/black-sun", 2},
	require = str_req_high2,
	points = 5,
	cooldown = 15,
	positive = 10,
	getDuration = function(self,t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getOnhit = function(self,t) return self:combatTalentSpellDamage(t, 10, 50) end,
	action = function(self, t)
		self:setEffect(self.EFF_DEVOURER_STANCE, t.getDuration(self,t), {gravity=t.getOnhit(self,t)})
		return true
	end,
	info = function(self, t)
		return ([[Attune yourself to the endless hunger of distant dead suns.  For the next %d turns, your attacks will inflict an additional %0.2f gravity damage and attempt to pull enemies closer.  After three turns, you will recover half of all damage taken during this effect.
The damage will increase with your Spellpower.]]):tformat(t.getDuration(self,t), damDesc(self, DamageType.PHSYICAL, t.getOnhit(self,t)))
	end,
}

newTalent{
	name = "Singularity Armor",
	type = {"celestial/black-sun", 3},
	require = str_req_high3,
	points = 5,
	mode = "sustained",
	sustain_positive = 20,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	getSlow = function(self, t) return self:combatTalentLimit(t, 80, 10, 50) end,
	getConversion= function(self, t) return self:combatTalentLimit(t, 80, 10, 40) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local particle = Particles.new("ultrashield", 1, {rm=204, rM=220, gm=102, gM=120, bm=0, bM=0, am=15, aM=60, radius=0.5, density=10, life=28, instop=100})
		return {
			converttype = self:addTemporaryValue("all_damage_convert", DamageType.PHYSICAL),
			convertamount = self:addTemporaryValue("all_damage_convert_percent", t.getConversion(self, t)),
			proj = self:addTemporaryValue("slow_projectiles", t.getSlow(self, t)),
			particle = self:addParticles(particle)
					 }
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("all_damage_convert", p.converttype)
		self:removeTemporaryValue("all_damage_convert_percent", p.convertamount)
		self:removeTemporaryValue("slow_projectiles", p.proj)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local conv = t.getConversion(self, t)
		local proj = t.getSlow(self, t)
		return ([[Create a gravity field around you that converts %d%% of all damage you deal into physical damage, slows incoming projectiles by %d%%, and causes your gravity damage to reduce the target's knockback resistance by half for two turns.]]):tformat(conv, proj)
	end,
}

newTalent{
	name = "Doom Spiral",
	type = {"celestial/black-sun", 4},
	require = str_req_high4,
	points = 5,
	random_ego = "attack",
	cooldown = 9,
	positive = 15,
	tactical = { ATTACKAREA = {LIGHT = 2} },
	range = 0,
	radius = 2,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	getOuterDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 1.3) end,
	getInnerDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1.5) end,
	getShield = function(self, t) return self:combatTalentSpellDamage(t, 35, 220) end,
	action = function(self, t)
		local tg1 = self:getTalentTarget(t) tg1.radius = 1
		local tg2 = self:getTalentTarget(t)
		
		-- Gravity pull
		self:addParticles(Particles.new("meleestorm", 2, {radius=2, img="spinningwinds_black"}))
		self:project(tg2, self.x, self.y, function(px, py, tg, self)
									 local target = game.level.map(px, py, Map.ACTOR)
									 if target and target ~= self then
										 self:attackTarget(target, DamageType.BLACK_HOLE_GRAVITY, t.getOuterDamage(self, t), true)
									 end
																			end)
		
		-- Physical hit
		local absorbed = 0
		self:addParticles(Particles.new("meleestorm", 1, {img="spinningwinds_red"}))
		self:project(tg1, self.x, self.y, function(px, py, tg, self)
									 local target = game.level.map(px, py, Map.ACTOR)
									 if target and target ~= self then
										 hitted = self:attackTarget(target, nil, t.getInnerDamage(self, t), true)
										 if hitted then absorbed = absorbed + 1 end
									 end
																			end)
		
		--Shield
		local multShield = 2-0.5^absorbed
		self:setEffect(self.EFF_DAMAGE_SHIELD, 2, {color={0xff/255, 0x3b/255, 0x3f/255}, power=self:spellCrit(t.getShield(self, t)*multShield)})
		
		return true
	end,
	info = function(self, t)
		return ([[Infuse your weapon with overwhelming gravitational power while spinning around.
							All creatures within radius 2 take %d%% weapon damage as physical (gravity) and are pulled closer.
							Then, all adjacent creatures take %d%% weapon damage.  This second strike shields you for between %d and %d, increasing with more enemies hit.  The shield lasts for 2 turns.
The shield strength will increase with your Spellpower.]]):
		tformat(t.getOuterDamage(self, t) * 100,
					 t.getInnerDamage(self, t) * 100,
					 t.getShield(self, t), t.getShield(self, t)*2)
	end,
}
