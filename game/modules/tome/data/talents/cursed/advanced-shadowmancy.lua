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

function shadowWarriorMult(self)
	if self:knowTalent(self.T_SHADOW_WARRIORS) then
		t = self:getTalentFromId(self.T_SHADOW_WARRIORS)
		return 1 + t.getIncDamage(self, t) / 100
	else
		return 1
	end
end

newTalent{
	name = "Merge",
	type = {"cursed/advanced-shadowmancy", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	range = 10,
	hate = -8,
	require = cursed_cun_req_high1,
	tactical = { DISABLE = 2 },
	getReduction = function(self, t) return self:combatTalentScale(t, 10, 40) end,
	on_pre_use = function(self, t) return game.level and self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend", pass_terrain=self:knowTalent(self.T_SHADOW_SENSES)}
		local x, y, target = self:getTargetLimited(tg)
		if x and y and target and target.summoner and target.summoner == self and target.is_doomed_shadow then
			local tg2 = {type="hit", range=self:getTalentRange(t), start_x=x, start_y=y, source_actor=target, pass_terrain=true}
			local x, y, target2 = self:getTargetLimited(tg2)
			if x and y and target2 and target2.x == x and target2.y == y then
				game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
				game.level.map:particleEmitter(target2.x, target2.y, 1, "teleport")

				target.die(target)
				target2:setEffect(target2.EFF_CURSE_IMPOTENCE, 5, {power=t.getReduction(self, t)})
				game:playSoundNear(target, "talents/earth")
			else return nil end
		else return nil end

		return true
	end,
	info = function(self, t)
		return ([[Target a nearby shadow, and command it to merge into a nearby enemy, reducing their damage by %d%% for 5 turns.
		Killing your shadow releases some of your inner hatred, restoring 8 Hate to yourself.]]):
		tformat(t.getReduction(self, t))
	end,
}

newTalent{
	name = "Stone",
	type = {"cursed/advanced-shadowmancy", 2},
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	range = 10,
	hate = 5,
	require = cursed_cun_req_high2,
	tactical = { ATTACK = {PHYSICAL = 2} },
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 280) end,
	on_pre_use = function(self, t) return game.level and self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend", pass_terrain=self:knowTalent(self.T_SHADOW_SENSES)}
		local x, y, target = self:getTargetLimited(tg)
		if x and y and target and target.x == x and target.y == y and target.is_doomed_shadow and target.summoner and target.summoner == self then
			local tg2 = {type="hit", range=self:getTalentRange(t), start_x=x, start_y=y, source_actor=target, friendlyblock=false, pass_terrain=true,}
			local x, y, target2 = self:getTargetLimited(tg2)
			if x and y and target2 and target2.x == x and target2.y == y then
				local ox, oy = target.x, target.y
				local sx, sy = util.findFreeGrid(x, y, 3, true, {[engine.Map.ACTOR]=true})

				target:move(sx, sy, true)
				if config.settings.tome.smooth_move > 0 then
					target:resetMoveAnim()
					target:setMoveAnim(ox, oy, 8, 5)
				end

				target:setTarget(target2)
				target2:setTarget(target)

				game.level.map:particleEmitter(target2.x, target2.y, 1, "ball_earth", {radius=1})
				game:playSoundNear(target2, "talents/earth")
				
				target:project(target2, x, y, DamageType.PHYSICAL, self:mindCrit(t.getDamage(self, t)))

			else return nil end
			

		else return nil end

		return true
	end,
	info = function(self, t)
		return ([[Target a nearby shadow, and force it to slam into a nearby enemy, dealing %0.1f Physical damage.
		Your shadow will then set them as their target, and they will target your shadow.
		Damage increases with your Mindpower.]]):
		tformat(t.getDamage(self, t) * shadowWarriorMult(self))
	end,
}

newTalent{
	name = "Shadow's Path",
	type = {"cursed/advanced-shadowmancy", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	hate = 8,
	tactical = { ATTACK = {PHYSICAL = 2} },
	require = cursed_cun_req_high3,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 210) end,
	target = function(self, t)
		return {type="beam", nolock=true, range=self:getTalentRange(t), friendlyfire=false, selffire=false, talent=t, pass_terrain=true, nowarning=true}
	end,
	on_pre_use = function(self, t) return game.level and self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t)
		-- I wouldn't recommend doing this on a regular basis. We're copying an Engine function. This is so that we can put a manual check on targeting so shadows will never go farther than 10 tiles away from us.
		-- We have to copy it as well, so that we can call it afterwards for normal block_path checks.
		local old_block_path = engine.Target.defaults.block_path
		
		-- Grab all shadows in sight range, and link them together in grayswandir's quite amazing multi-target targeting.
		local tg = {nolock=true, multiple=true}
		local shadows = {}
		local grids = nil
		local targeted = false
		if self:knowTalent(self.T_SHADOW_SENSES) then
			grids = core.fov.circle_grids(self.x, self.y, 10)
		else
			grids = core.fov.circle_grids(self.x, self.y, 10, true)
		end
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a.is_doomed_shadow and a.summoner == self then
				shadows[#shadows+1] = a
				tg[#tg+1] = {type="beam", nolock=true, range=20, friendlyfire=false, selffire=false, talent=t, pass_terrain=true, nowarning=true, source_actor=a, block_path=function(typ, lx, ly, for_highlights) if core.fov.distance(self.x, self.y, lx, ly) > 10 then return true, false, false else return old_block_path(typ, lx, ly, for_highlights) end end}
				if targeted == false then targeted = true end
			end
		end end
		
		if targeted == false then
			game.logPlayer(self, "You need a shadow in sight range!")
			return
		end
		
		-- Get a target.
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		
		-- Go back to normal targeting.
		local tg = self:getTalentTarget(t)
		local _ _, x, y = self:canProject(tg, x, y)

		-- Rushing time.
		local dam = self:mindCrit(t.getDamage(self, t))
		for i = 1, #shadows do
			if #shadows <= 0 then break end
			local a, id = rng.table(shadows)
			table.remove(shadows, id)
			local sx, sy = util.findFreeGrid(x, y, 2, true, {[engine.Map.ACTOR]=true})
			if sx and sy then
				tg.source_actor = a

				game.level.map:particleEmitter(a.x, a.y, math.max(math.abs(x-a.x), math.abs(y-a.y)), "earth_beam", {tx=x-a.x, ty=y-a.y})
				game.level.map:particleEmitter(a.x, a.y, math.max(math.abs(x-a.x), math.abs(y-a.y)), "shadow_beam", {tx=x-a.x, ty=y-a.y})

				a:project(tg, x, y, DamageType.PHYSICAL, dam)
				dam = dam * 0.6

				a:move(sx, sy, true)
				
			end
		end

		game.level.map:particleEmitter(x, y, 0, "teleport")
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		return ([[Command all Shadows within sight to tele-dash to a target location, damaging any enemies they pass through for %0.1f Physical damage.
		Each successive shadow deal 40%% less damage.
		For the purpose of this talent, you force your shadows through any walls in their way.
		Damage increases with your Mindpower.]]):
		tformat(t.getDamage(self, t) * shadowWarriorMult(self))
	end,
}

newTalent{
	name = "Cursed Bolt",
	type = {"cursed/advanced-shadowmancy", 4},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	range = 6,
	hate = 10,
	tactical = { ATTACK = {MIND = 2} },
	require = cursed_cun_req_high4,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 180) end,
	on_pre_use = function(self, t) return game.level and self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t)
		local shadows = {}
		local grids = nil
		if self:knowTalent(self.T_SHADOW_SENSES) then
			grids = core.fov.circle_grids(self.x, self.y, 10)
		else
			grids = core.fov.circle_grids(self.x, self.y, 10, true)
		end
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a.is_doomed_shadow and a.summoner == self then
				shadows[#shadows+1] = a
			end
		end end
		
		if #shadows <= 0 then
			game.logPlayer(self, "You need a shadow in sight range!")
			return
		end
		
		local damage = t.getDamage(self, t)
		
		local first = true
		local failed = false
		for i = 1, #shadows do
			if failed == false then
				local a, id = rng.table(shadows)
				table.remove(shadows, id)
				local tg = {type="bolt", source_actor = a, range=self:getTalentRange(t), talent=t, friendlyblock=false}
				local x, y = self:getTarget(tg)
				local _ _, x, y = a:canProject(tg, x, y)
				if x and y then
					if first == true then
						damage = self:mindCrit(damage)
						first = false
					end
					a:project(tg, x, y, DamageType.MIND, {dist=10, dam=damage})
					game.level.map:particleEmitter(x, y, 1, "mind")
					game:playSoundNear(a, "talents/cloud")
				elseif first == true then
					first = false
					failed = true
				end
			end
		end
		
		if failed == true then return nil else return true end
	end,
	info = function(self, t)
		return ([[Share your hatred with all shadows within sight range, gaining temporary full control. You then fire a blast of pure hatred from all affected shadows, dealing %0.1f Mind damage per blast.
		You cannot cancel this talent once the first bolt is cast.
		Damage increases with your Mindpower.]]):
		tformat(t.getDamage(self, t) * shadowWarriorMult(self))
	end,
}