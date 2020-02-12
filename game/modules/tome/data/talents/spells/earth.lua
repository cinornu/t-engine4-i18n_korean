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
local Grid = require "mod.class.Grid"

newTalent{
	name = "Pulverizing Auger", short_name="DIG",
	type = {"spell/earth",1},
	require = spells_req1,
	points = 5,
	mana = 15,
	cooldown = 3,
	is_body_of_stone_affected = true,
	range = 10,
	tactical = { ATTACK = {PHYSICAL = 2} },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		local tg = {type="beam", range=self:getTalentRange(t), talent=t}
		return tg
	end,
	getBonus = function(self, t) return math.floor(self:combatTalentScale(t, 15, 30)) end,
	getDigs = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self.turn_procs.has_dug = nil
		tg.range = t.getDigs(self, t)
		for i = 1, t.getDigs(self, t) do self:project(tg, x, y, DamageType.DIG, 1) end
		if self.turn_procs.has_dug and self.turn_procs.has_dug > 0 then
			self:setEffect(self.EFF_AUGER_OF_DESTRUCTION, 6, {power=t.getBonus(self,t)})
		end

		tg.range = self:getTalentRange(t)
		self:project(tg, x, y, DamageType.PHYSICAL, self:spellCrit(t.getDamage(self, t)), nil)
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "earth_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local nb = t.getDigs(self, t)
		return ([[Fire a powerful beam of stone-shattering force, digging out any walls in its path up to %d range.
		The beam continues to a range of %d, affecting any creatures in its path, dealing %0.2f physical damage to them.
		If any walls are dug, you gain %d%% physical damage bonus for 6 turns.
		The damage will increase with your Spellpower.]]):
		tformat(nb, self:getTalentRange(t), damDesc(self, DamageType.PHYSICAL, damage), t.getBonus(self, t))
	end,
}

newTalent{
	name = "Stone Skin",
	type = {"spell/earth", 2},
	mode = "sustained",
	require = spells_req2,
	points = 5,
	sustain_mana = 15,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getArmor = function(self, t) return self:combatTalentSpellDamage(t, 10, 23) end,
	getCDChance = function(self, t) return self:combatTalentLimit(t, 100, 30, 90) end,
	callbackOnMeleeHit = function(self, t, src, dam)
		if self == src then return end  -- This matters, Stone Wall gives you a lot of time to whack yourself
		if not rng.percent(t.getCDChance(self, t)) then return end
		if self.turn_procs.stone_skin_cd or dam <= 0 then return end
		self.turn_procs.stone_skin_cd = true
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local st = self:getTalentFromId(tid)
			if st.type[1] and (st.type[1] == "spell/earth" or st.type[1] == "spell/stone") and self:isTalentCoolingDown(tid) then
				tids[#tids+1] = tid
			end
		end
		if #tids > 0 then
			local tid = rng.table(tids)
			self:alterTalentCoolingdown(tid, -2)
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/earth")
		local ret = {
			armor = self:addTemporaryValue("combat_armor", t.getArmor(self, t)),
		}
		if not self:addShaderAura("stone_skin", "crystalineaura", {time_factor=1500, spikeOffset=0.123123, spikeLength=0.9, spikeWidth=3, growthSpeed=2, color={0xD7/255, 0x8E/255, 0x45/255}}, "particles_images/spikes.png") then
			ret.particle = self:addParticles(Particles.new("stone_skin", 1))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("stone_skin")
		self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_armor", p.armor)
		return true
	end,
	info = function(self, t)
		local armor = t.getArmor(self, t)
		return ([[The caster's skin grows as hard as stone, granting a %d bonus to Armour.
		Each time you are hit in melee, you have a %d%% chance to reduce the cooldown of an Earth or Stone spell by 2 (this effect can only happen once per turn).
		The bonus to Armour will increase with your Spellpower.]]):
		tformat(armor, t.getCDChance(self, t))
	end,
}

newTalent{
	name = "Mudslide",
	type = {"spell/earth",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 20,
	cooldown = 12,
	is_body_of_stone_affected = true,
	direct_hit = true,
	tactical = { ATTACKAREA = { PHYSICAL = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 1 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t) return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 250) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SPELLKNOCKBACK, {dist=8, dam=self:spellCrit(t.getDamage(self, t))})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "mudflow", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Conjures a mudslide, dealing %0.2f physical damage in a radius of %d. Any creatures caught inside will be knocked back 8 spaces.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, damage), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Stone Wall",
	type = {"spell/earth",4},
	require = spells_req4,
	points = 5,
	cooldown = 60,
	mana = 50,
	range = function(self, t) return self:getTalentLevel(t) >= 4 and 7 or 0 end,
	radius = 1,
	target = function(self, t) return {type="ball", nowarning=true, selffire=false, friendlyfire=false, range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	tactical = { ATTACKAREA = {PHYSICAL = 2},
		DISABLE = function(self, t, aitarget)
			return self:getTalentLevel(t) >=4 and self.fov.actors[aitarget] and self.fov.actors[aitarget].sqdist > 1 and 1 or nil
		end,
		DEFEND = function(self, t, aitarget) -- surrounded by foes
			return self.fov.actors[aitarget] and self.fov.actors[aitarget].sqdist <= 1 and 3 or nil
		end,
		PROTECT = function(self, t, aitarget) -- summoner needs protection
			return self.summoner and self:getTalentLevel(t) >=4 and core.fov.distance(self.summoner.x, self.summoner.y, aitarget.x, aitarget.y) > 1 and 3 or nil
		end,
		ESCAPE = function(self, t, aitarget) -- protect self or trap target
			return self.fov.actors[aitarget] and self.fov.actors[aitarget].sqdist > 1 and (self:getTalentLevel(t) >=4 and 3 or 1) or nil
		end
	},
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 250) end,
	requires_target = function(self, t) return self:getTalentLevel(t) >=4 end,
	getDuration = function(self, t) return util.bound(2 + self:combatTalentSpellDamage(t, 5, 12), 2, 25) end,
	action = function(self, t)
		local ok, x, y, tx, ty = true, self.x, self.y
		local tg = self:getTalentTarget(t)
		if self:getTalentLevel(t) >= 4 then --NPC's target based on current tactic
			if self.summoner and self.ai_state.tactic == "protect" then
				ok, tx, ty, x, y = self:canProject(tg, self.summoner.x, self.summoner.y)
			elseif self.ai_state.tactic ~= "defend" then
				x, y = self:getTarget(tg)
				if not x or not y then return nil end
				ok, tx, ty, x, y = self:canProject(tg, x, y)
			end
		end
		if not ok or not x or not y then return nil end

		self:project(tg, x, y, DamageType.PHYSICAL, self:spellCrit(t.getDamage(self, t)))

		for i = -1, 1 do for j = -1, 1 do if game.level.map:isBound(x + i, y + j) then
			local oe = game.level.map(x + i, y + j, Map.TERRAIN)
			if oe and not oe:attr("temporary") and not game.level.map:checkAllEntities(x + i, y + j, "block_move") and not oe.special then
				-- Ok some explanation, we make a new *OBJECT* because objects can have energy and act
				-- it stores the current terrain in "old_feat" and restores it when it expires
				-- We CAN set an object as a terrain because they are all entities

				local e = Object.new{
					old_feat = oe,
					name = _t"stone wall",
					image = oe.image,
					add_mos = table.clone(oe.add_mos or {}, true),
					add_displays = table.clone(oe.add_displays or {}),
					display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
					desc = _t"a summoned wall of stone",
					type = "wall", --subtype = "floor",
					always_remember = true,
					can_pass = {pass_wall=1},
					does_block_move = true,
					show_tooltip = true,
					block_move = true,
					block_sight = true,
					temporary = t.getDuration(self, t),
					x = x + i, y = y + j,
					canAct = false,
					act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
							game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
							game.nicer_tiles:updateAround(game.level, self.x, self.y)
							game.level:removeEntity(self)
							game.level.map:scheduleRedisplay()
						end
					end,
					dig = function(src, x, y, old)
						game.level:removeEntity(old)
						game.level.map:scheduleRedisplay()
						return nil, old.old_feat
					end,
					summoner_gain_exp = true,
					summoner = self,
				}
				e.add_displays[#e.add_displays+1] = Grid.new{image="terrain/spell_stonewall_0"..rng.range(1,3)..".png", z=19}
				e.tooltip = mod.class.Grid.tooltip
				game.level:addEntity(e)
				game.level.map(x + i, y + j, Map.TERRAIN, e)
			end
		end end end

		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[Entomb yourself in a wall of stone for %d turns.
		At level 4, it becomes targetable.
		Any hostile creature caught in the radius will also suffer %0.2f physical damage.
		Duration and damage will improve with your Spellpower.]]):
		tformat(duration, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}
