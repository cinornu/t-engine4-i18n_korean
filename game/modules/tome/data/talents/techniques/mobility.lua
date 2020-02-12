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

local Map = require "engine.Map"

local function mobility_pre_use(self, t, silent, fake)
	if self:attr("never_move") then
		if not silent then game.logPlayer(self, "You must be able to move to use %s!", t.name) end
		return
	elseif self:hasHeavyArmor() then
		if not silent then game.logPlayer(self, "%s is not usable while wearing heavy armour.", t.name) end
		return
	end
	return true
end

local function mobility_stamina(self, t)
	local cost = t.base_stamina or 0
	local eff = self:hasEffect(self.EFF_EXHAUSTION)
	if eff then cost = cost*(1 + eff.fatigue/100) end
	return cost
end

newTalent{
	name = "Disengage",
	type = {"technique/mobility", 1},
	require = techs_dex_req1,
	points = 5,
	random_ego = "utility",
	cooldown = 10,
	base_stamina = 8,
	stamina = mobility_stamina,
	range = 7,
	getSpeed = function(self, t) return self:combatTalentScale(t, 100, 200, "log")/(1 + 2*self:combatFatigue()/100) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3)) end,
	tactical = { ESCAPE = 2},
	requires_target = true,
	on_pre_use = function(self, t, silent, fake)
		if self:attr("never_move") or self:attr("encased_in_ice") then
			if not silent then game.logPlayer(self, "You must be able to move to use %s!", t.name) end
			return
		end
		return true
	end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDist = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7)/(1 + self:combatFatigue()/100)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTarget(tg)
		if not (target and self:canSee(target) and self:canProject(tg, tx, ty)) then return end
		
		local dist = core.fov.distance(self.x, self.y, tx, ty) + t.getDist(self,t)
		local tgt_dist, move_dist = core.fov.distance(self.x, self.y, tx, ty), t.getDist(self,t)

		local block_check = function(_, bx, by)
			return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self)
		end
		local linestep
		local function check_dest(px, py)
			local check = false
			linestep = self:lineFOV(px, py, block_check, nil, tx, ty)
			local lx, ly, is_corner_blocked
			repeat -- make sure line passes through talent user
			--print("check_dest checking", px, py)
				lx, ly, is_corner_blocked = linestep:step()
				if self.x == lx and self.y == ly then check = true break end
			until is_corner_blocked or not lx or not ly or game.level.map:checkEntity(lx, ly, Map.TERRAIN, "block_move", self)
			return check
		end

		local dx, dy
		if self.player then -- player targeting
			local l = target:lineFOV(self.x, self.y)
			l:set_corner_block()
			local lx, ly, is_corner_blocked = l:step(true)
			local possible_x, possible_y = lx, ly
			local pass_self = false
			-- Check for terrain and friendly actors
			while lx and ly and not is_corner_blocked and core.fov.distance(self.x, self.y, lx, ly) <= move_dist do
				local actor = game.level.map(lx, ly, engine.Map.ACTOR)
				if actor == self then
					pass_self = true
				elseif pass_self and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
					-- possible_x, possible_y = lx, ly
					break
				end
				possible_x, possible_y = lx, ly
				lx, ly = l:step(true)
			end

			if pass_self then
				game.target.target.entity = nil
				game.target.target.x = possible_x
				game.target.target.y = possible_y
			end

			local tg2 = {type="beam", source_actor=self, selffire=false, range=move_dist, talent=t, no_start_scan=true, no_move_tooltip=true}
			tg2.display_line_step = function(self, d) -- highlight permissible grids for the player
				local t_range = core.fov.distance(self.target_type.start_x, self.target_type.start_y, d.lx, d.ly)
				if t_range >= 1 and t_range <= tg2.range and not d.block and check_dest(d.lx, d.ly) then
					d.s = self.sb
				else
					d.s = self.sr
				end
				d.display_highlight(d.s, d.lx, d.ly)
			end
			dx, dy = self:getTarget(tg2)
		else -- NPC gets the target location (update with AI changes)
			-- project a cone in opposite direction from target, looking for valid grids
			local cone_angle = 180/math.pi*math.atan(1/(tgt_dist + 1)) + 5 --5° extra angle
			local tg2 = {type="cone", cone_angle=cone_angle, source_actor=self, selffire=false, range=0, radius=move_dist, talent=t}
			dx, dy = self.x - (tx - self.x), self.y - (ty - self.y) -- direction away from target
			-- game.log("#GREY# NPC %s Disengage from (%d, %d) towards (%d, %d) cone_angle=%s", self.name, tx, ty, dx, dy, cone_angle)
			local grids = {}
			self:project(tg2, dx, dy, function(px, py, typ, self)
				local act = game.level.map(px, py, Map.ACTOR)
				if not game.level.map:checkEntity(px, py, Map.TERRAIN, "block_move", self) and (not act or not self:canSee(act)) then
					grids[#grids+1] = {px, py, dist=core.fov.distance(px, py, self.x, self.y) + rng.float(0, 0.1)}
				end
			end)
			table.sort(grids, function(a, b) return a.dist > b.dist end)
			table.print(grids, "\tnpc_grids")
			dx, dy = nil, nil
			for i, grid in ipairs(grids) do
				local chk = check_dest(grid[1], grid[2])
				--print("\tchecking grid", grid[1], grid[2], chk)
				if check_dest(grid[1], grid[2]) then dx, dy = grid[1], grid[2] break end
			end
		end

		if not (dx and dy) or not game.level.map:isBound(dx, dy) or core.fov.distance(dx, dy, self.x, self.y) > move_dist then return end
		local allowed = check_dest(dx, dy)
		if not allowed then
			game.logPlayer(self, "You must disengage directly away from your target in a straight line.")
			return
		end

		local ok_grids = {}
		repeat  -- get list of  allowed grids along path
			local lx, ly, is_corner_blocked = linestep:step()
			--print("linestep:", lx, ly, is_corner_blocked, "actor:", game.level.map(lx, ly, Map.ACTOR))
			if lx and ly then
				if game.level.map:checkEntity(lx, ly, Map.TERRAIN, "block_move", self) then break
				elseif not game.level.map(lx, ly, Map.ACTOR) then
					ok_grids[#ok_grids+1]={lx, ly}
				end
			end
		until is_corner_blocked or not lx or not ly

		local act = game.level.map(dx, dy, Map.ACTOR)
		-- abort for known obstacles
		if self:hasLOS(dx, dy) and (game.level.map:checkEntity(dx, dy, Map.TERRAIN, "block_move", self) or act and self:canSee(act)) then
			game.logPlayer(self, "You must land in an empty space.")
			return false
		else -- move to the furthest allowed grid
			local dest_grid = ok_grids[#ok_grids]
			if dest_grid then -- land short
				if dx ~= dest_grid[1] or dy ~= dest_grid[2] then
					game.logPlayer(self, "Your Disengage was partially blocked.")
				end
			else
				game.logPlayer(self, "You are not able to Disengage in that direction.")
				return false
			end
		end
		
		self:move(dx, dy, true)

		game:onTickEnd(function()
			self:setEffect(self.EFF_WILD_SPEED, 3, {power=t.getSpeed(self,t)})
		end)

		local weapon, ammo, offweapon = self:hasArcheryWeapon()	
		if weapon and ammo and not ammo.infinite then self:reload() end
		if self:knowTalent(self.T_THROWING_KNIVES) then self:callTalent(self.T_THROWING_KNIVES, "callbackOnMove", true, false, tx, ty) end
	
		return true
	end,
	info = function(self, t)
		return ([[Jump back up to %d grids from your target, springing over any creatures in your way. 
		You must disengage in a nearly straight line directly away from your target (which you must be able to see).
		After moving, you gain %d%% increased movement speed for 3 turns (which ends if you take any actions other than movement), and you may reload your ammo (if any).
		The extra speed and maximum distance you can move are reduced by your Fatigue level.]]):
		tformat(t.getDist(self, t), t.getSpeed(self,t), t.getNb(self,t))
	end,
}

newTalent{
	name = "Evasion",
	type = {"technique/mobility", 2},
	points = 5,
	require = techs_dex_req2,
	random_ego = "defensive",
	tactical = { ESCAPE = 2, DEFEND = 2 },
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 28, 15)) end, --shorter cooldown but less duration - as especially on randbosses a long duration evasion is frustrating, this makes it a bit more useful for hit and run
	base_stamina = 25,
	stamina = mobility_stamina,
	no_energy = true,
	getDur = function(self, t) return 4 end,
	getChanceDef = function(self, t)
		if self.perfect_evasion then return 100, 0 end
		return self:combatLimit(5*self:getTalentLevel(t) + self:getDex(50,true), 50, 10, 10, 37.5, 75),
		self:combatScale(self:getTalentLevel(t) * (self:getDex(50, true)), 0, 0, 55, 250, 0.75)
		-- Limit evasion chance < 50%, defense bonus ~= 55 at level 50
	end,
	speed = "combat",
	action = function(self, t)
		local dur = t.getDur(self,t)
		local chance, def = t.getChanceDef(self,t)
		self:setEffect(self.EFF_EVASION, dur, {chance=chance, defense = def})
		return true
	end,
	info = function(self, t)
		local chance, def = t.getChanceDef(self,t)
		return ([[Your quick wit and reflexes allow you to anticipate attacks against you, granting you a %d%% chance to evade melee and ranged attacks and %d increased defense for %d turns.
		The chance to evade and defense bonus increase with your Dexterity.]]):
		tformat(chance, def,t.getDur(self,t))
	end,
}

--quite expensive to use repeatedly but gives a low cooldown instant movement which is super powerful, and at 4/5 the exhaustion will never stack beyond 66~%
newTalent {
	name = "Tumble",
	type = {"technique/mobility", 3},
	require = techs_dex_req3,
	points = 5,
	random_ego = "attack",
	on_pre_use = mobility_pre_use,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 4, 11, 5)) end,
	no_energy = true,
	no_break_stealth = true,
	tactical = { CLOSEIN = 2 },
--	tactical = { ESCAPE = 2, CLOSEIN = 2 }, -- update with AI
	base_stamina = 20,
	stamina = mobility_stamina,
	getExhaustion = function(self, t) return self:combatTalentLimit(t, 25, 75, 40) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4, "log")) end,
	getDuration = function(self, t)	return math.ceil(self:combatTalentLimit(t, 6, 25, 15)) end, -- always >=2 turns higher than cooldown
	target = function(self, t)
		return {type="beam", default_target=self, range=self:getTalentRange(t), talent=t, nolock=true}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return end
		if self.x == x and self.y == y then return end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) or not self:hasLOS(x, y) then return end

		if target or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move", self) then
			game.logPlayer(self, "You must have an empty space to roll to.")
			return false
		end

		self:move(x, y, true)
		
		game:onTickEnd(function()
			self:setEffect(self.EFF_EXHAUSTION, t.getDuration(self,t), { fatigue = t.getExhaustion(self, t) })
		end)
		
		return true
	end,
	info = function(self, t)
		return ([[In an extreme feat of agility, you move to a spot you can see within range, bounding around, over, or through any enemies in the way.
		This talent cannot be used while wearing heavy armor, and leaves you exhausted.  The exhaustion increases the cost of your activated Mobility talents by %d%% (stacking), but fades over %d turns.]]):tformat(t.getExhaustion(self, t), t.getDuration(self, t))
	end
}

newTalent {
	name = "Trained Reactions",
	type = {"technique/mobility", 4},
	mode = "sustained",
	points = 5,
	require = techs_dex_req4,
	sustain_stamina = 10,
	cooldown = 5,
	no_energy = true,
	tactical = { DEFEND = 2 },
--	pinImmune = function(self, t) return self:combatTalentLimit(t, 1, .17, .5) end, -- limit < 100%
--	passives = function(self, t, p)
--		self:talentTemporaryValue(p, "pin_immune", t.pinImmune(self, t))
--	end,
	on_pre_use = function(self, t, silent, fake)
		if self:hasHeavyArmor() then
			if not silent then game.logPlayer(self, "%s is not usable while wearing heavy armour.", t.name) end
			return
		end
		return true
	end,
	getReduction = function(self, t, fake) -- % reduction based on both TL and Defense
		return math.max(0.1, self:combatTalentLimit(t, 0.8, 0.25, 0.6))*self:combatLimit(self:combatDefense(fake), 1.0, 0.25, 0, 0.5, 50) -- vs TL/def: 1/10 == ~08%, 1.3/10 == ~10%, 1.3/50 == ~16%, 6.5/50 == ~32%, 6.5/100 = ~40%
	end,
	getStamina = function(self, t) return 12*(1 + self:combatFatigue()/100)*math.max(0.1, self:combatTalentLimit(t, 0.8, 0.25, 0.45)) end,
	getLifeTrigger = function(self, t)
		return self:combatTalentLimit(t, 10, 30, 15) -- Limit trigger > 10% life
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if dam > 0 and state and not (self:attr("encased_in_ice") or self:attr("invulnerable")) then
			local psrc = src.__project_source
			if psrc then
				local kind = util.getval(psrc.getEntityKind)
				if kind == "projectile" or kind == "trap" or kind == "object" then
				else
					return
				end
			end
			local stam, stam_cost
			local is_attk = state.is_melee or state.is_archery
			if is_attk then
				-- don't charge stamina more than once per melee or ranged attack (state set in Combat.attackTargetWith and Archery.archery_projectile)
				if self.turn_procs[t.id] == state then
					stam_cost = 0
				end
			end
			stam, stam_cost = self:getStamina(), stam_cost or t.getStamina(self, t)
			local lt = t.getLifeTrigger(self, t)/100
			if stam_cost == 0 or dam > self.max_life*lt then
				--print(("[PROJECTOR: Trained Reactions] PASSED life/stam test for %s: %s %s damage (%s) (%0.1f/%0.1f stam) from %s (state:%s)"):tformat(self.name, dam, type, is_attk, stam_cost, stam, src.name, state)) -- debugging
				self.turn_procs[t.id] = state
				self:incStamina(-stam_cost) -- Note: force_talent_ignore_ressources has no effect on this

				local reduce = t.getReduction(self, t)*dam
				if src.logCombat then src:logCombat(self, "#FIREBRICK##Target# reacts to %s from #Source#, mitigating the blow!#LAST#.", is_attk and _t"an attack" or _t"damage") end
				dam = dam - reduce
				print("[PROJECTOR] dam after callbackOnTakeDamage", t.id, dam)
				local d_color = DamageType:get(type).text_color or "#FIREBRICK#"
				local stam_txt = stam_cost > 0 and (" #ffcc80#, -%d stam#LAST#"):tformat(stam_cost) or ""
				game:delayedLogDamage(src, self, 0, ("%s(%d reacted#LAST#%s%s)#LAST#"):tformat(d_color, reduce, stam_txt, d_color), false)
				if not is_attk then self.turn_procs.gen_trained_reactions = true end
				return {dam = dam}
			end
		end
	end,
	activate = function(self, t)
		local ret = {}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
--		local pin = t.pinImmune(self,t)
		local stam = t.getStamina(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t, true)*100
		return ([[You have trained to be very light on your feet and have conditioned your reflexes to react faster than thought to damage you take.
		While this talent is active, you instantly react to any direct damage (not from status effects, etc.) that would hit you for at least %d%% of your maximum life.
		This requires %0.1f stamina and reduces the damage by %d%%.
		Your reactions are too slow for this if you are wearing heavy armour.
		The damage reduction improves with your Defense.]])
		:tformat(trigger, stam, reduce)
	end,
}


