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
	name = "Bone Spear",
	type = {"corruption/bone", 1},
	require = corrs_req1,
	points = 5,
	vim = 13,
	cooldown = 10,
	range = 10,
	tactical = { ATTACK = {PHYSICAL = 2} },
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 250) end,  -- 40, 500 at 5 debuffs
	getBonus = function(self, t) return 0.2 end,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(t.getDamage(self, t))

		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target then return end
			local effs = #target:effectsFilter({status="detrimental", type="magical"})
			local damage = dam * math.min(2, (1 + t.getBonus(self, t) * effs))
			DamageType:get(DamageType.PHYSICAL).projector(self, tx, ty, DamageType.PHYSICAL, damage)
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.range, "bone_spear", {tx=x - self.x, ty=y - self.y})
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		return ([[Conjures up a spear of bones, doing %0.2f physical damage to all targets in a line.  Each target takes an additional %d%% damage for each magical debuff they are afflicted with up to a max of %d%% (%d).
		The damage will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getBonus(self, t)*100, t.getBonus(self, t)*100 * 5, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t) * 2))
	end,
}

newTalent{
	name = "Bone Grab",
	type = {"corruption/bone", 2},
	require = corrs_req2,
	points = 5,
	vim = 15,
	cooldown = 15,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 4, 9)) end,
	tactical = { DISABLE = 1, CLOSEIN = 3 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 140) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), friendlyblock=false, talent=t}
		local x, y, target = self:getTargetLimited(tg)
		if not target or target == self then return nil end
		
		local dam = self:spellCrit(t.getDamage(self, t))
		if core.fov.distance(self.x, self.y, target.x, target.y) > 1 then
			DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, dam)
			if target:canBe("pin") then
				target:setEffect(target.EFF_BONE_GRAB, t.getDuration(self, t), {apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
			end

			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not target:canBe("teleport") or not hit then
				game.logSeen(target, "%s resists being teleported by Bone Grab!", target:getName():capitalize())
				return true
			end

			-- Grab the closest adjacent grid that doesn't have block_move or no_teleport
			local grid = util.closestAdjacentCoord(self.x, self.y, target.x, target.y, true, function(x, y) return game.level.map.attrs(x, y, "no_teleport") end)							
			if not grid then return true end
			target:teleportRandom(grid[1], grid[2], 0)				
		else
			local tg = {type="cone", cone_angle=90, range=0, radius=6, friendlyfire=false}
			
			local grids = {}
			self:project(tg, x, y, function(px, py)
				if game.level.map(tx, ty, engine.Map.ACTOR) then return end
				grids[#grids+1] = {px, py, core.fov.distance(self.x, self.y, px, py)}
			end)
			table.sort(grids, function(a, b) return a[3] > b[3] end )

			DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, dam)
			if target:canBe("pin") then
				target:setEffect(target.EFF_BONE_GRAB, t.getDuration(self, t), {apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
			end

			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not target:canBe("teleport") or not hit then
				game.logSeen(target, "%s resists being teleported by Bone Grab!", target:getName():capitalize())
				return true
			end
			
			if #grids <= 0 then return end
			target:teleportRandom(grids[1][1], grids[1][2], 0)
		end
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[Grab a target and teleport it to your side or if adjacent up to 6 spaces away from you, pinning it there with a bone rising from the ground for %d turns.
		The bone will also deal %0.2f physical damage.
		The damage will increase with your Spellpower.]]):
		tformat(t.getDuration(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Bone Spike",
	type = {"corruption/bone", 3},
	require = corrs_req3,
	image = "talents/bone_nova.png",
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 60) end,
	radius = 10,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
	end,
	callbackOnTalentPost = function(self, t, ab, ret, silent)
		if ab.no_energy then return end
		if ab.mode ~= "activated" then return end
		if self.turn_procs.bone_spike then return end
		self.turn_procs.bone_spike = true
		local tg = self:getTalentTarget(t)
		local dam = t.getDamage(self, t)
		local did_crit = false
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			local nb = #target:effectsFilter({status="detrimental", type="magical"})
			if nb and nb < 3 then return end

			-- Make sure crit is only calculated once, but do it here so we don't trigger a crit if there are no targets
			if did_crit == false then
				dam = self:spellCrit(dam)
				did_crit = true 
			end

			self:projectSource({type="beam", range=10, selffire=false, friendlyfire=false, talent=t}, target.x, target.y, DamageType.PHYSICAL, dam, nil, t)
			local _ _, _, _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, 10, "bone_spear", {speed=0.2, tx=target.x - self.x, ty=target.y - self.y})
		end)
	end,
	info = function(self, t)
		return ([[Whenever you use a non-instant talent you launch a spear of bone at all enemies afflicted by 3 or more magical detrimental effects dealing %d physical damage to all enemies it passes through.
		The damage will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)) )
	end,
}

newTalent{
	name = "Bone Shield",
	type = {"corruption/bone", 4},
	points = 5,
	mode = "sustained", no_sustain_autoreset = true,
	require = corrs_req4,
	cooldown = 15,
	sustain_vim = 50,
	tactical = { DEFEND = 4 },
	direct_hit = true,
	getRegen = function(self, t) return self:combatTalentLimit(t, 3, 20, 3.3) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3.5)) end,
	getThreshold = function(self, t) return math.floor(self:combatSpellpower() * 0.7) end,
	iconOverlay = function(self, t, p)
		local p = self.sustain_talents[t.id]
		if not p or not p.nb then return "" end
		return p.nb.."/"..t.getNb(self, t), "buff_font_smaller"
	end,
	callbackOnRest = function(self, t)
		local nb = t.getNb(self, t)
		local p = self.sustain_talents[t.id]
		if not p or p.nb < nb then return true end
	end,
	callbackOnActBase = function(self, t)
		if not self:isTalentActive(t.id) then return end
		local p = self.sustain_talents[t.id]
		p.next_regen = (p.next_regen or 1) - 1
		if p.next_regen <= 0 then
			p.next_regen = t.getRegen(self, t) or 10

			if p.nb < t.getNb(self, t) then
				p.nb = p.nb + 1
				if p.adv_gfx then
					if p.particles[1] and p.particles[1]._shader and p.particles[1]._shader.shad then
						if not p.particles[1].shader then p.particles[1] = self:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, a=0.5, rotation=0, radius=1.5, img="bone_shield"}, {type="boneshield"})) end
						p.particles[1]._shader.shad:resetClean()
						p.particles[1]._shader:setResetUniform("chargesCount", util.bound(p.nb, 0, 10))
						p.particles[1].shader.chargesCount = util.bound(p.nb, 0, 10)
					end
				else
					p.particles[#p.particles+1] = self:addParticles(Particles.new("bone_shield", 1))
				end
			end
		end
	end,
	callbackOnHit = function(self, t, cb, src, dt)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if not p.nb or p.nb <= 0 then return end
		if not cb.value or cb.value < t.getThreshold(self, t) then return end
		p.nb = p.nb - 1
		if p.adv_gfx then
			if p.particles[1] and p.particles[1]._shader and p.particles[1]._shader.shad then
				-- Clones don't copy this so we need to recreate it sometimes
				if not p.particles[1].shader then p.particles[1] = self:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, a=0.5, rotation=0, radius=1.5, img="bone_shield"}, {type="boneshield"})) end
				p.particles[1]._shader.shad:resetClean()
				p.particles[1]._shader:setResetUniform("chargesCount", util.bound(p.nb, 0, 10))
				p.particles[1].shader.chargesCount = util.bound(p.nb, 0, 10)
			end
		else
			local pid = table.remove(p.particles)
			self:removeParticles(pid)
		end
		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d to bones)#LAST#"):tformat(cb.value), false)
		cb.value = 0
		return true
	end,
	activate = function(self, t)
		local nb = t.getNb(self, t)

		local adv_gfx = core.shader.allow("adv") and true or false
		local ps = {}
		if adv_gfx then
			ps[1] = self:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, a=0.5, rotation=0, radius=1.5, img="bone_shield"}, {type="boneshield"}))
			ps[1]._shader.shad:resetClean()
			ps[1]._shader:setResetUniform("chargesCount", util.bound(nb, 0, 10))
			ps[1].shader.chargesCount = util.bound(nb, 0, 10)
		else
			for i = 1, nb do ps[#ps+1] = self:addParticles(Particles.new("bone_shield", 1)) end
		end

		game:playSoundNear(self, "talents/spell_generic2")
		return {
			adv_gfx = adv_gfx,
			particles = ps,
			clone_test = 1,
			nb = nb,
			next_regen = t.getRegen(self, t),
		}
	end,
	deactivate = function(self, t, p)
		for i, particle in ipairs(p.particles) do self:removeParticles(particle) end
		return true
	end,
	info = function(self, t)
		return ([[Bone shields start circling around you. They will each fully absorb one instance of damage.
		%d shield(s) will be generated when first activated.
		Then every %d turns a new one will be created if not full.
		This will only trigger on hits over %d damage based on Spellpower.]]):
		tformat(t.getNb(self, t), t.getRegen(self, t), t.getThreshold(self, t))
	end,
}
