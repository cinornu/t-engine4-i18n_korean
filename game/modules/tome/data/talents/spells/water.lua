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
	name = "Ice Shards",
	type = {"spell/water",1},
	require = spells_req1,
	points = 5,
	mana = 12,
	cooldown = 3,
	tactical = { ATTACKAREA = { COLD = 1, stun = 1 } },
	range = 10,
	radius = 1,
	proj_speed = 8,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 18, 200) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local empower = necroEssenceDead(self)
		self:project(tg, x, y, function(px, py)
			local actor = game.level.map(px, py, Map.ACTOR)
			if actor and actor ~= self then
				if empower then
					local tg2 = {type="beam", range=self:getTalentRange(t), talent=t}
					self:project(tg2, px, py, DamageType.ICE, {chance=25, do_wet=true, dam=self:spellCrit(t.getDamage(self, t))})
					game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(px-self.x), math.abs(py-self.y)), "ice_beam", {tx=px-self.x, ty=py-self.y})
				else
					local tg2 = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="arrow", particle_args={tile="particles_images/ice_shards"}}}
					self:projectile(tg2, px, py, DamageType.ICE, {chance=25, do_wet=true, dam=self:spellCrit(t.getDamage(self, t))}, {type="freeze"})
				end
			end
		end)
		if empower then empower() end

		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Hurl ice shards at the targets in the selected area. Each shard %s and does %0.2f ice damage, hitting all adjacent targets on impact with 25%% chance to freeze them.
		If the target resists being frozen, it instead get wet.
		If the target is wet the damage increases by 30%% and the ice freeze chance increases to 50%%.
		This spell will never hit the caster.
		The damage will increase with your Spellpower.]]):
		tformat(necroEssenceDead(self, true) and _t"affects all foes on its path" or _t"travels slowly", damDesc(self, DamageType.COLD, damage))
	end,
}

newTalent{
	name = "Glacial Vapour",
	type = {"spell/water",2},
	require = spells_req2,
	points = 5,
	mana = 12,
	cooldown = 8,
	tactical = { DISABLE = {stun = 0.5}, ATTACKAREA = { COLD = 1 } },
	range = 8,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 70) end,
	getDuration = function(self, t) return 8 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.GLACIAL_VAPOUR, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			{type="ice_vapour"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Glacial fumes rise from the ground, doing %0.2f cold damage in a radius of 3 each turn for %d turns.
		Creatures that are wet will take 30%% more damage and have 15%% chance to get frozen.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

newTalent{
	name = "Tidal Wave",
	type = {"spell/water",3},
	require = spells_req3,
	points = 5,
	mana = 10,
	cooldown = 10,
	tactical = { ESCAPE = { knockback = 2 }, ATTACKAREA = { COLD = 0.5, PHYSICAL = 0.5 }, DISABLE = { knockback = 1 } },
	direct_hit = true,
	range = 0,
	requires_target = true,
	radius = function(self, t)
		return 1 + 0.5 * t.getDuration(self, t)
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire = false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 90) end,
	getDuration = function(self, t) return 3 + self:combatTalentSpellDamage(t, 5, 5) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.logSeen(self, "A #LIGHT_BLUE#wave of icy water#LAST# erupts from the ground!")
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.WAVE, {dam=t.getDamage(self, t), x=self.x, y=self.y, apply_wet=5},
			1,
			5, nil,
			MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader="shader_images/water_effect1.png"},
--			MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader={"shader_images/water_effect1.png","shader_images/water_effect2.png", max=6}},
			function(e, update_shape_only)
				if not update_shape_only then e.radius = e.radius + 0.5 end
				return true
			end,
			false -- no selffire
		)
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[A wall of water rushes out from the caster with an initial radius of 1, increasing by 1 per turn to a maximum radius of %d, doing %0.2f cold damage and %0.2f physical damage to all inside, as well as knocking back targets each turn.
		The tidal wave lasts for %d turns.
		All creatures hit gain the wet effect, which reduces their stun/freeze immunity by half and interacts with other cold spells.
		The damage and duration will increase with your Spellpower.]]):
		tformat(radius, damDesc(self, DamageType.COLD, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

newTalent{
	name = "Shivgoroth Form",
	type = {"spell/water",4},
	require = spells_req4,
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 20,
	tactical = { BUFF = 3, ATTACKAREA = { COLD = 0.5, PHYSICAL = 0.5 }, DISABLE = { knockback = 1 } },
	direct_hit = true,
	range = 10,
	no_energy = true,
	requires_target = true,
	getDuration = function(self, t) return 4 + math.ceil(self:getTalentLevel(t)) end,
	getPower = function(self, t) return util.bound(50 + self:combatTalentSpellDamage(t, 50, 450), 0, 500) / 500 end,
	on_pre_use = function(self, t, silent) if self:attr("is_shivgoroth") then if not silent then game.logPlayer(self, "You are already a Shivgoroth!") end return false end return true end,
	on_unlearn = function(self, t)
		if self:getTalentLevel(t) == 0 then
			self:removeEffect(self.EFF_SHIVGOROTH_FORM, true, true)
		end
	end,
	action = function(self, t)
		self:setEffect(self.EFF_SHIVGOROTH_FORM, t.getDuration(self, t), {power=t.getPower(self, t), lvl=self:getTalentLevelRaw(t)})
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)

		local t_is = self:getTalentFromId(self.T_ICE_STORM)
		local icestorm = self:getTalentFullDescription(t_is, self:getTalentLevelRaw(t))

		return ([[You absorb latent cold around you, turning into an ice elemental - a shivgoroth - for %d turns.
		While transformed, you do not need to breathe, gain access to the Ice Storm talent at level %d, gain %d%% resistance to cuts and stuns, gain %d%% cold resistance, and all cold damage heals you for %d%% of the damage done.
		The power will increase with your Spellpower.

		#AQUAMARINE#Ice storm:#LAST#
		%s]]):
		tformat(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100, tostring(icestorm or ""))
	end,
}

newTalent{
	name = "Ice Storm",
	type = {"spell/other",1},
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 20,
	tactical = { ATTACKAREA = { COLD = 2, stun = 1 } },
	range = 0,
	radius = 3,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 90) end,
	getDuration = function(self, t) return 5 + self:combatSpellpower(0.05) + self:getTalentLevel(t) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.ICE_STORM, t.getDamage(self, t),
			3,
			5, nil,
			{type="icestorm", only_one=true},
			function(e)
				if e.src.dead then return end
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/icestorm")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[A furious ice storm rages around the caster, doing %0.2f cold damage in a radius of 3 each turn for %d turns.
		It has a 25%% chance to freeze damaged targets.
		If the target is wet the damage increases by 30%% and the freeze chance increases to 50%%.
		The damage and duration will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.COLD, damage), duration)
	end,
}
