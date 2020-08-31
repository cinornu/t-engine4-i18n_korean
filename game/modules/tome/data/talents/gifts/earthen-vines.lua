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
	name = "Stone Vines",
	type = {"wild-gift/earthen-vines", 1},
	require = gifts_req1,
	points = 5,
	mode = "sustained",
	sustain_equilibrium = 15,
	cooldown = 10,
	no_energy = true,
	tactical = { ATTACK = { PHYSICAL = 2 }, BUFF = 2, DISABLE = { pin = 2 } },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4.5, 6.5)) end,
	getValues = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)), self:combatTalentStatDamage(t, "wil", 6, 80), self:knowTalent(self.T_ELDRITCH_VINES) and self:callTalent(self.T_ELDRITCH_VINES, "getDamage") or nil end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		local rad = self:getTalentRadius(t)

		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, rad, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 and not a:hasEffect(a.EFF_STONE_VINE) then
				tgts[#tgts+1] = a
			end
		end end
		if #tgts <= 0 then return end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local a, id = rng.table(tgts)
		local hit, chance = a:checkHit(self:combatMindpower(), a:combatPhysicalResist(), 0, 95, 5)
		if a:canBe("pin") and hit then
			local turns, dam, arcanedam = t.getValues(self, t)
			a:setEffect(a.EFF_STONE_VINE, turns, {dam=dam, arcanedam = arcanedam, src=self, free=rad+4, free_chance=100-chance})
			game:playSoundNear(self, "talents/stone")
		end
	end,
	activate = function(self, t)
		return {
			particle = self:addParticles(Particles.new("stonevine_static", 1, {})),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local turns, dam, arcanedam = t.getValues(self, t)
		local xs = arcanedam and (" and %0.1f Arcane"):tformat(damDesc(self, DamageType.ARCANE, arcanedam)) or ""
		return ([[From the ground around you, you form living stone vines extending from your feet.
		Each turn, the vines will attempt to seize a random target within radius %d.
		Affected creatures are pinned to the ground and take %0.1f nature%s damage each turn for %d turns.
		A creature entangled by the vines will have a chance to break free each turn, and will automatically succeed if it is more than %d grids away from you.
		The chance to affect targets and damage increase with talent level and Willpower.]]):
		tformat(rad, damDesc(self, DamageType.NATURE, dam), xs, turns, rad+4)
	end,
}

newTalent{
	name = "Eldritch Vines",
	type = {"wild-gift/earthen-vines", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
	-- called by "STONE_VINE" effect
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "wil", 6, 80) end,
	getEquilibrium = function(self, t) return self:combatTalentScale(t, 0.3, 1.25, "log", 0, 3) end,
	getMana = function(self, t) return self:combatTalentScale(t, 0.4, 1.67) end,
	info = function(self, t)
		return ([[Each time one of your stone vines deals damage to a creature it will restore %0.1f equilibrium and %0.1f mana.
		Your vines also become infused with eldritch energies, dealing an additional %0.1f arcane damage.]])
		:tformat(t.getEquilibrium(self, t), t.getMana(self, t), damDesc(self, DamageType.ARCANE, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Rockwalk",
	type = {"wild-gift/earthen-vines", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 15,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 11, 7)) end,
	requires_target = true,
	range = 20,
	tactical = { HEAL = 2, CLOSEIN = 2 },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if not target:hasEffect(target.EFF_STONE_VINE) then return nil end

		self:attr("allow_on_heal", 1)
		self:heal(100 + self:combatTalentStatDamage(t, "wil", 40, 630), t)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0x90/255, 0xff/255, 0x95/255, 1}, circleDescendSpeed=4}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0x90/255, 0xff/255, 0x95/255, 1}, circleDescendSpeed=4}))
		end

		local tx, ty = util.findFreeGrid(x, y, 2, true, {[Map.ACTOR]=true})
		if tx and ty then
			local ox, oy = self.x, self.y
			self:attr("preserve_body_of_stone", 1)
			self:move(tx, ty, true)
			self:attr("preserve_body_of_stone", -1)
			if config.settings.tome.smooth_move > 0 then
				self:resetMoveAnim()
				self:setMoveAnim(ox, oy, 8, 5)
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Merge with one of your stone vines, traversing it to emerge near an entangled creature (maximum range %d).
		Merging with the stone is beneficial for you, healing %0.2f life (increases with Willpower).
		This will not break Body of Stone.]])
		:tformat(self:getTalentRange(t) ,100 + self:combatTalentStatDamage(t, "wil", 40, 630))
	end,
}

newTalent{
	name = "Rockswallow",
	type = {"wild-gift/earthen-vines", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 15,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 11, 7)) end,
	requires_target = true,
	range = 20,
	tactical = { ATTACK = { PHYSICAL = 2 }, CLOSEIN = 2 },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if not target:hasEffect(target.EFF_STONE_VINE) then return nil end

		DamageType:get(DamageType.NATURE).projector(self, target.x, target.y, DamageType.NATURE, 80 + self:combatTalentStatDamage(t, "wil", 40, 330))

		if target.dead then return true end

		local tx, ty = util.findFreeGrid(self.x, self.y, 2, true, {[Map.ACTOR]=true})
		if tx and ty then
			local ox, oy = target.x, target.y
			target:move(tx, ty, true)
			if config.settings.tome.smooth_move > 0 then
				target:resetMoveAnim()
				target:setMoveAnim(ox, oy, 8, 5)
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Merge your target (within range %d) with one of your stone vines that has seized it, forcing it to traverse the vine and reappear near you.
		Merging with the stone is detrimental for the target, dealing %0.1f nature damage.
		The damage will increases with your Willpower.]])
		:tformat(self:getTalentRange(t), 80 + self:combatTalentStatDamage(t, "wil", 40, 330))
	end,
}
