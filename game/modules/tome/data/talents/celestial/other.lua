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

local Trap = require "mod.class.Trap"

newTalent{
	name = "Glyph of Explosion",
	type = {"celestial/other", 3},
	require = divi_req_high3,
	random_ego = "attack",
	points = 5,
	cooldown = 20,
	positive = -10,
	no_energy = true,
	tactical = { ATTACKAREA = {LIGHT = 2} },
--	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	radius = function() return 1 end,
	direct_hit = true,
	tactical = { ATTACKAREA = { ACID = 2 }, DISABLE = { knockback = 1 } },
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t} end,
	getDamage = function(self, t) return 15 + self:combatSpellpower(0.15) * self:combatTalentScale(t, 1.5, 5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end, -- Duration of glyph
	trapPower = function(self,t) return math.max(1,self:combatScale(self:getTalentLevel(t) * self:getMag(15, true), 0, 0, 75, 75)) end,
	getNb = function(self, t) return 9 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if game.level.map(x, y, Map.TRAP) then game.logPlayer(self, "You somehow fail to set the corrosive seed.") return nil end
		
		local grids = {}
		self:project(tg, x, y, function(px, py)
			if not ((px == x and py == y) or game.level.map:checkEntity(px, py, Map.TERRAIN, "block_move") or game.level.map(px, py, Map.TRAP)) then grids[#grids+1] = {x=px, y=py} end
		end)
		local dam = self:spellCrit(t.getDamage(self, t))
		for i = 1, t.getNb(self, t) do
			local spot = i == 1 and {x=x, y=y} or rng.tableRemove(grids)
			if not spot then break end
			local trap = Trap.new{
				name = _t"glyph of explosion",
				type = "elemental", id_by_type=true, unided_name = _t"trap",
				display = '^', color=colors.GOLD, image = "trap/trap_glyph_explosion_02_64.png",
				faction = self.faction,
				dam = dam,
				desc = function(self)
					return ([[Explodes (radius 1) for %d light damage.]]):tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam))
				end,
				canTrigger = function(self, x, y, who)
					if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
					return false
				end,
				triggered = function(self, x, y, who)
					self:project({type="ball", x=x,y=y, radius=1}, x, y, engine.DamageType.LIGHT, self.dam, {type="light"})
					game.level.map:particleEmitter(x, y, 1, "sunburst", {radius=1, x=x, y=y})
					return true
				end,
				temporary = t.getDuration(self, t),
				x = tx, y = ty,
				disarm_power = math.floor(t.trapPower(self,t) * 0.8),
				detect_power = math.floor(t.trapPower(self,t) * 0.8),
				inc_damage = table.clone(self.inc_damage or {}, true),
				resists_pen = table.clone(self.resists_pen or {}, true),
				canAct = false,
				energy = {value=0},
				act = function(self)
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
						game.level:removeEntity(self)
					end
				end,
				summoner = self,
				summoner_gain_exp = true,
			}
			trap:identify(true)
			trap:resolve() trap:resolve(nil, true)
			trap:setKnown(self, true)
			game.level:addEntity(trap)
			game.zone:addEntity(game.level, trap, "trap", spot.x, spot.y)
			game.level.map:particleEmitter(spot.x, spot.y, 1, "summon")
		end

		return true
	end,
	info = function(self, t)
		return ([[test glyph]]):
		tformat()
	end,
}


newTalent{
	name = "Glyph of Paralysis",
	type = {"celestial/other", 1},
	require = divi_req_high1,
	random_ego = "attack",
	points = 5,
	cooldown = 20,
	positive = -10,
	no_energy = true,
--	requires_target = true,
	tactical = { DISABLE = {stun = 1.5} },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDazeDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end, -- Duration of glyph
	trapPower = function(self,t) return math.max(1,self:combatScale(self:getTalentLevel(t) * self:getMag(15, true), 0, 0, 75, 75)) end, -- Used to determine detection and disarm power, about 75 at level 50
	target = function(self, t) return {type="hit", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self:trapGetGrid(t, tg)
		if not (tx and ty) then return end
		
		local dam = self:spellCrit(t.getDazeDuration(self, t))
		local trap = Trap.new{
			name = _t"glyph of paralysis",
			type = "elemental", id_by_type=true, unided_name = _t"trap",
			display = '^', color=colors.GOLD, image = "trap/trap_glyph_paralysis_01_64.png",
			faction = self.faction,
			desc = function(self)
				return ([[Dazes for %d turns.]]):tformat(self.dam)
			end,
			dam = dam,
			canTrigger = function(self, x, y, who)
				if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
				return false
			end,
			triggered = function(self, x, y, who)
				if who:canBe("stun") then
					who:setEffect(who.EFF_DAZED, self.dam, {})
				end
				return true
			end,
			temporary = t.getDuration(self, t),
			x = tx, y = ty,
			disarm_power = math.floor(t.trapPower(self,t)),
			detect_power = math.floor(t.trapPower(self,t) * 0.8),
			canAct = false,
			energy = {value=0},
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
					game.level:removeEntity(self)
				end
			end,
			summoner = self,
			summoner_gain_exp = true,
		}
		game.level:addEntity(trap)
		trap:identify(true)
		trap:setKnown(self, true)
		game.zone:addEntity(game.level, trap, "trap", tx, ty)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local dazeduration = t.getDazeDuration(self, t)
		local duration = t.getDuration(self, t)
		return ([[You bind light in a glyph on the floor. All enemies walking over the glyph will be dazed for %d turns.
		The glyph is a hidden trap (%d detection and %d disarm power based on your Magic) and lasts for %d turns.]]):tformat(dazeduration, t.trapPower(self,t)*0.8, t.trapPower(self,t), duration)
	end,
}

newTalent{
	name = "Glyph of Repulsion",
	type = {"celestial/other", 2},
	require = divi_req_high2,
	random_ego = "attack",
	points = 5,
	positive = -10,
	cooldown = 20,
	no_energy = true,
	tactical = { ATTACK = {PHYSICAL = 1}, CLOSEIN = {knockback = 1.5}, ESCAPE = {knockback = 1.5} },
--	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDamage = function(self, t) return 15 + self:combatSpellpower(0.12) * self:combatTalentScale(t, 1.5, 5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end, -- Duration of glyph
	trapPower = function(self,t) return math.max(1,self:combatScale(self:getTalentLevel(t) * self:getMag(15, true), 0, 0, 75, 75)) end, -- Used to determine detection and disarm power, about 75 at level 50
	target = function(self, t) return {type="hit", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self:trapGetGrid(t, tg)
		if not (tx and ty) then return end

		local dam = self:spellCrit(t.getDamage(self, t))
		local sp = self:combatSpellpower()
		local trap = Trap.new{
			name = _t"glyph of repulsion",
			type = "elemental", id_by_type=true, unided_name = _t"trap",
			display = '^', color=colors.GOLD, image = "trap/trap_glyph_repulsion_01_64.png",
			faction = self.faction,
			dam = dam,
			desc = function(self)
				return ([[Deals %d physical damage, knocking the target back.]]):tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.PHYSICAL, self.dam))
			end,
			canTrigger = function(self, x, y, who)
				if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
				return false
			end,
			triggered = function(self, x, y, who)
				local ox, oy = self.x, self.y
				local dir = util.getDir(who.x, who.y, who.old_x, who.old_y)
				self.x, self.y = util.coordAddDir(self.x, self.y, dir)
				self:project({type="hit",x=x,y=y}, x, y, engine.DamageType.SPELLKNOCKBACK, self.dam)
				self.x, self.y = ox, oy
				return true
			end,
			temporary = t.getDuration(self, t),
			x = tx, y = ty,
			disarm_power = math.floor(t.trapPower(self,t)),
			detect_power = math.floor(t.trapPower(self,t) * 0.8),
			inc_damage = table.clone(self.inc_damage or {}, true),
			resists_pen = table.clone(self.resists_pen or {}, true),
			canAct = false,
			energy = {value=0},
			combatSpellpower = function(self) return self.sp end, sp = sp,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
					game.level:removeEntity(self)
				end
			end,
			summoner = self,
			summoner_gain_exp = true,
		}
		game.level:addEntity(trap)
		trap:identify(true)
		trap:setKnown(self, true)
		game.zone:addEntity(game.level, trap, "trap", tx, ty)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[You bind light in a glyph on the floor. All enemies walking over the glyph will be hit by a blast that does %0.2f physical damage and knocks them back.
		The glyph is a hidden trap (%d detection and %d disarm power based on your Magic) and lasts for %d turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, damage), t.trapPower(self, t)*0.8, t.trapPower(self, t), duration)
	end,
}
--[=[
newTalent{
	name = "Glyph of Explosion",
	type = {"celestial/other", 3},
	require = divi_req_high3,
	random_ego = "attack",
	points = 5,
	cooldown = 20,
	positive = -10,
	no_energy = true,
	tactical = { ATTACKAREA = {LIGHT = 2} },
--	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDamage = function(self, t) return 15 + self:combatSpellpower(0.15) * self:combatTalentScale(t, 1.5, 5) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end, -- Duration of glyph
	trapPower = function(self,t) return math.max(1,self:combatScale(self:getTalentLevel(t) * self:getMag(15, true), 0, 0, 75, 75)) end, -- Used to determine detection and disarm power, about 75 at level 50
	target = function(self, t) return {type="ball", radius=1, nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not (x and y) then return end
		local _ _, x, y = self:canProject(tg, x, y)
		local dam = self:spellCrit(t.getDamage(self, t))
		
		local grids = {}
		self:project(tg, x, y, function(px, py)
			if not ((px == x and py == y) or game.level.map:checkEntity(px, py, Map.TERRAIN, "block_move") or game.level.map(px, py, Map.TRAP)) then grids[#grids+1] = {x=px, y=py} end
		end)
		local glyphgrids = math.abs(#grids)
		for i = 1, 9 do
			local spot = i == 1 and {x=x, y=y} or rng.tableRemove(grids)
			if not spot then break end
		
		local trap = Trap.new{
			name = _t"glyph of explosion",
			type = "elemental", id_by_type=true, unided_name = _t"trap",
			display = '^', color=colors.GOLD, image = "trap/trap_glyph_explosion_02_64.png",
			faction = self.faction,
			dam = dam,
			desc = function(self)
				return ([[Explodes (radius 1) for %d light damage.]]
--[[			):tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam))
			end,
			canTrigger = function(self, x, y, who)
				if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
				return false
			end,
			triggered = function(self, x, y, who)
				self:project({type="ball", x=x,y=y, radius=1}, x, y, engine.DamageType.LIGHT, self.dam, {type="light"})
				game.level.map:particleEmitter(x, y, 1, "sunburst", {radius=1, x=x, y=y})
				return true
			end,
			temporary = t.getDuration(self, t),
			x = tx, y = ty,
			disarm_power = math.floor(t.trapPower(self,t) * 0.8),
			detect_power = math.floor(t.trapPower(self,t) * 0.8),
			inc_damage = table.clone(self.inc_damage or {}, true),
			resists_pen = table.clone(self.resists_pen or {}, true),
			canAct = false,
			energy = {value=0},
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
					game.level:removeEntity(self)
				end
			end,
			summoner = self,
			summoner_gain_exp = true,
		}
		game.level:addEntity(trap)
		trap:identify(true)
		trap:setKnown(self, true)
		game.zone:addEntity(game.level, trap, "trap", spot.x, spot.y)
		game:playSoundNear(self, "talents/heal")
		return true end
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[You bind light in a glyph on the floor. All enemies walking over the glyph will trigger an explosion of light that does %0.2f damage to everyone within 1 tile.
		The glyph is a hidden trap (%d detection and %d disarm power based on your Magic) and lasts for %d turns.
		The damage will increase with your Spellpower.]]
--[[	):
		tformat(damDesc(self, DamageType.LIGHT, damage), t.trapPower(self, t)*0.8, t.trapPower(self, t)*0.8, duration)
	end,
}
]=]

newTalent{
	name = "Glyph of Fatigue",
	type = {"celestial/other", 4},
	require = divi_req_high4,
	random_ego = "attack",
	points = 5,
	cooldown = 20,
	positive = -10,
	no_energy = true,
	tactical = { DISABLE = {slow = 1.5} },
--	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getSlow = function(self, t) return self:combatTalentLimit(t, 1, 0.20, 0.35) end, -- Limit <100% slow
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end, -- Duration of glyph
	trapPower = function(self,t) return math.max(1,self:combatScale(self:getTalentLevel(t) * self:getMag(15, true), 0, 0, 75, 75)) end, -- Used to determine detection and disarm power, about 75 at level 50
	target = function(self, t) return {type="hit", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self:trapGetGrid(t, tg)
		if not (tx and ty) then return end

		local dam = t.getSlow(self, t)
		local trap = Trap.new{
			name = _t"glyph of fatigue",
			type = "elemental", id_by_type=true, unided_name = _t"trap",
			display = '^', color=colors.GOLD, image = "trap/trap_glyph_fatigue_01_64.png",
			faction = self.faction,
			dam = dam,
			desc = function(self)
				return ([[Slows (%d%%) for 5 turns.]]):tformat(self.dam*100)
			end,
			canTrigger = function(self, x, y, who)
				if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
				return false
			end,
			triggered = function(self, x, y, who)
				who:setEffect(who.EFF_SLOW, 5, {power=self.dam})
				return true
			end,
			temporary = t.getDuration(self, t),
			x = tx, y = ty,
			disarm_power = math.floor(t.trapPower(self,t)),
			detect_power = math.floor(t.trapPower(self,t)),
			canAct = false,
			energy = {value=0},
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
					game.level:removeEntity(self)
				end
			end,
			summoner = self,
			summoner_gain_exp = true,
		}
		game.level:addEntity(trap)
		trap:identify(true)
		trap:setKnown(self, true)
		game.zone:addEntity(game.level, trap, "trap", tx, ty)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		return ([[You bind light in a glyph on the floor. All enemies walking over the glyph will be slowed by %d%% for 5 turns.
		The glyph is a hidden trap (%d detection and %d disarm power based on your Magic) and lasts for %d turns.]]):
		tformat(100 * slow, t.trapPower(self, t), t.trapPower(self, t), duration)
	end,
}

