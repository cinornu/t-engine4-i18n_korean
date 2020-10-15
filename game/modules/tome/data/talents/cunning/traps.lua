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

local Chat = require "engine.Chat"
local Map = require "engine.Map"

--[[
-- Instructions for adding new traps for use with the Trap Mastery/Trap Priming talents:
-- Define the trap talent with the following fields:

	t.type = {"cunning/traps", 1},
	t.type_no_req = true -- allows the talent to be learned without learning the "cunning/traps" category
	t.trap_mastery_level = raw talent level of Trap Mastery/Trap Priming talent needed to prepare the trap
	t.range = Talents.trap_range -- range (Advanced Trap Deployment talent)
	t.speed = Talents.trap_speed -- usage speed (Advanced Trap Deployment talent)
	t.no_break_stealth = Talents.trap_stealth -- chance to not break stealth (Advanced Trap Deployment talent)
	
Add a terse textual summary of the trap's effects:

	t.short_info = function(self, t) ... return a short description of the trap's effects
	
This should be as short as possible, and will be embedded in the tooltips for Trap Mastery and Trap Priming and used as the description of the trap in its tooltip if the player has identified it.

If the trap must be unlocked:

	t.unlock_talent = <either boolean (true),
					string ("string to display in the log when the talent is unlocked"),
					function(self, t) returning boolean, string (to restrict which npc's can use it)>
	
	To unlock the trap, use game.state:unlockTalent(tid, player) somewhere in the game.

If the trap is usable with Trap Priming, then:

	t.allow_primed_trigger = true

	Make sure appropriate talent functions (t.action, t.requires_target, t.info) check for the condition self.trap_primed == t.id (meaning the trap is using an instant trigger) and act appropriately.

When the level of trap mastery is needed, use the talent mastery functions defined here, which automatically use the correct trap mastery talent and adjust for context, such as tooltips and prompts:
	
	self.trap_mastery_talent(self, t) returns either the Trap Mastery or Trap Priming talent depending on how the trap is prepared.  Use in place of the talent reference, t, for functions that scale up with mastery.

	self.trap_effectiveness(self, t, stat) returns the overall effectiveness value for the trap, using the talent level of the preparing talent, incorporating trap mastery bonuses and stat (usually "cun") effects.  Generally ranges from 1 to 10 at normal character levels.  Used mostly for damage with a multiplier of 20 to 30.

A function has been provided to get the trap placement location within the trap action function:

	x, y = self:trapGetGrid(t, tg, defense)
		
See the definition below.  This replaces the usual call to getTarget and handles getting the targeting coordinates from the player or the AI.  It automatically adjusts for Trap Priming as required and contains code for NPCs to find reasonable spots to place the trap.

The support functions and tables are assigned to ActorTalents.
--]]

----------------------------------------------------------------
-- Trap Support Functions
----------------------------------------------------------------
--- get the base trap detection power
local trapPower = function(self,t) return math.max(1, self:combatScale(self:getTalentLevel(self.T_TRAP_MASTERY) * self:getCun(25, true), 10, 3.75, 75, 125, 0.25)) end -- Used to determine detection and disarm power, ~ 75 at TL 5, 100 cunning

--- get the maximum range at which a trap can be deployed
trap_range = function(self, t)
	if not self:knowTalent(self.T_TRAP_LAUNCHER) then return 1 end
	return math.floor(self:combatTalentLimit(self:getTalentLevel(self.T_TRAP_LAUNCHER), 10, 2, 5.5)) -- limit < 10, 2@1, 6@5 (for mastery 1.3)
end

--- determine if placing a trap will not break stealth
function trap_stealth(self, t)
	local chance = util.bound(trap_effectiveness(self, t, "cun")*10 + self:callTalent(self.T_TRAP_LAUNCHER, 
"trapStealth"), 0, 100)
	return rng.percent(chance), chance
end

--- get trap deployment speed
function trap_speed(self, t)
	return self:callTalent(self.T_TRAP_LAUNCHER, "trapSpeed")
end

--- get the controlling trap mastery talent for a prepared trap
trap_mastery_talent = function(self, t)
	local tid = self.turn_procs.trap_mastery_tid or self.trap_primed == t.id and self.T_TRAP_PRIMING or self.T_TRAP_MASTERY
	return self:getTalentFromId(tid)
end

--- get the general trap effectiveness value
-- this scales with stat (usually cunning) and controlling trap mastery talent level
-- 10 cun, tl 1 -> 1.2, 100 cun, tl 5 -> 10
trap_effectiveness = function(self, t, stat)
	local mastery = 1 + self:callTalent(self.turn_procs.trap_mastery_tid or self.trap_primed == t.id and self.T_TRAP_PRIMING or self.T_TRAP_MASTERY, "getTrapMastery")/100
	if stat then mastery = mastery*self:combatStatScale(stat, 1, 5) end
	return mastery
end

--- generate a list of all trap tids that are either known or unlocked for this actor
traps_getunlocked = function(self)
	local unlocked = {}
	for tid, level in pairs(trap_mastery_tids) do
		if self:knowTalent(tid) or game.state:unlockTalentCheck(tid, self) then
			unlocked[#unlocked+1] = tid
		end
	end
	return unlocked
end

--- default target table for placing a trap
local trap_default_target = {type="bolt", nowarning=true, range=1, nolock=true, simple_dir_request=true}

-- default AI check to use a trap (don't deploy without a target)
traps_on_pre_use_ai = function(self, t, silent, fake) return self.ai_target.actor end

--- Method for NPCs to find a grid in which to place a trap near target coords,
-- tries to place traps as close to the target and nearly inline as possible
-- @param self talent user
-- @param t trap talent
-- @param tx, ty target actor location
-- @param tg targeting table for placing the trap (determines which grids are reachable)
-- @param defense (override) use/don't use defensive placement strategy (try to place between self and target)
local function trap_ai_coords(self, t, tx, ty, tg, defense)
	if not tg then
		tg = trap_default_target
		tg.talent, tg.range = t, trap_range(self, t)
	end
	local range = tg.range or self:getTalentRange(t)
	local tgt_dist = core.fov.distance(self.x, self.y, tx, ty)
	print(("%s advanced trap placement targeting grid (%s, %s) range/dist:%d/%d (defense:%s)"):format(self.name, tx, ty, range, tgt_dist, defense))
	-- heuristic: abort if target too far away
	if tgt_dist > range and (not defense or rng.percent((tgt_dist-range-1)*30)) then
		print("npc trap_ai_coords: target too far to place trap, aborting", t.id, tx, ty)
		return nil
	end
	-- get grid as close to target as possible (and directly in front or behind if possible)
	local gx, gy = engine.Target:pointAtRange(self.x, self.y, tx, ty, range)
	local grid_list = util.adjacentCoords(gx, gy); 	grid_list[5] = {gx, gy} -- all grids near target

	local x, y
	local ivx, ivy = tx - self.x, ty - self.y -- vector to target
	for i = #grid_list, 1, -1 do -- test and assign values to all grids near target
		local coords = grid_list[i]
		x, y = coords[1], coords[2]
		local dist = core.fov.distance(self.x, self.y, x, y)
		if dist > range or tgt_dist > 0 and (defense and dist >= tgt_dist or not defense and dist < tgt_dist or (x == tx and y == ty and not tg._allow_on_target)) or game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") or game.level.map(x, y, engine.Map.TRAP) then
			table.remove(grid_list, i)
		else -- grid OK, weight grid according to distance from target and deviation from centerline
			local tvx, tvy = x - self.x, y - self.y -- prospective trap vector
			local proj = 0 -- projection coef.
			if ivx ~= 0 or ivy ~= 0 then proj = (tvx*ivx + tvy*ivy)/(ivx*ivx + ivy*ivy) end
			local dvx, dvy = tvx - proj*ivx, tvy - proj*ivy -- deviation vector
			local sqdev = dvx*dvx + dvy*dvy -- distance^2 from centerline
			coords.val = math.abs(core.fov.distance(tx, ty, x, y) - 1) + math.abs(dist - (tgt_dist + (defense and -1 or 1)))*1 + 0.25*sqdev + rng.float(0, 0.5)
		end
	end
	table.sort(grid_list, function(a, b) return a.val < b.val end)
	--print("suitable grid list:") table.print(grid_list)

	-- find the best grid that can be projected to
	local best_val, best_x, best_y = tgt_dist -- if projection is blocked, closest grids to target
	for i, grid in ipairs(grid_list) do
		local ok, x0, y0, px, py = self:canProject(tg, grid[1], grid[2])
		print(("# trap_ai_coords checking projection to (%d, %d): (%d, %d) ok: %s"):format(grid[1], grid[2], px, py, ok))
		if ok then return px, py
		elseif defense then -- closer grids may still be OK
			local d = core.fov.distance(grid[1], grid[2], px, py)
			if d <= 1 and grid.val + d < best_val then
				best_val, best_x, best_y = grid.val + d, px, py
			end
		end
	end
	if best_x then return best_x, best_y end -- reachable grid closest to target
end

--- get the location to place a trap
-- handles targeting, adjusts for Trap Priming, NPC's pick a trap spot
-- @param self talent user
-- @param t trap talent
-- @param tg targeting table for placing the trap (defaults to a "bolt" attack that can be blocked by obstacles)
-- @param defense (override) NPC's place trap defensively (between self and target) default: semi-random depending on ai_state
-- @return x, y coords or nil if no location could be found
trapGetGrid = function(self, t, tg, defense)
	if not tg then
		if self.trap_primed == t.id then tg = self:getTalentTarget(t) end
		if not tg then -- default to (updated) standard trap placement targeting parameters
			tg = trap_default_target
			tg.talent, tg.range = t, trap_range(self, t)
		end
	end
	if tg.stop_block == nil then tg.stop_block = true end
	game.logPlayer(self, "#CADET_BLUE#Placing %s...", t.name or "trap")
	local tx, ty, target = self:getTarget(tg)
	if not (tx and ty) then return nil end
	local ok, x0, y0, x, y
	if self.trap_primed == t.id then -- instant trap trigger, just center on target
		ok, x0, y0, x, y = self:canProject(tg, tx, ty)
		x, y = x0, y0
	else -- normal trap placement
		if not self.player then -- find a grid for the NPC placing trap
			if defense == nil then -- pick offensive or defensive placement randomly or based on ai state
				if self.ai_state.tactic == "escape" then defense = true
				elseif self.ai_state.tactic == "closein" then defense = false
				else defense = rng.chance(3)
				end
			end
			x, y = self:trap_ai_coords(t, tx, ty, tg, defense)
			print("NPC Trap Placement for", self.name, t.id, x, y)
			return x, y
		end
		ok, x0, y0, x, y = self:canProject(tg, tx, ty)
		if x0 ~= x or y0 ~= y then
			game.logPlayer(self, "You cannot place a trap there.") return nil
		end
		local trap = game.level.map(x, y, Map.TRAP)
		if trap then
			game.logPlayer(self, trap:knownBy(self) and game.level.map.seens(x, y) and _t"There is already a trap there." or _t"You somehow fail to set the trap.") return nil 
		end
	end
	print("Trap Placement for", self.name, t.id, x, y)
	return x, y
end

--- create a basic trap (to be completed and placed by the calling talent)
-- @param self -- the trap user/source
-- @param t -- trap talent used
-- @param dur -- trap duration (defaults to duration from Trap Mastery
-- @param add -- additional data to merge into the trap entity (must define .triggered function)
-- @return trap object
trapping_CreateTrap = function(self, t, dur, add)
	local Trap = require "mod.class.Trap"
	local trap = {
		id_by_type=true, unided_name = _t"trap",
		display = '^',
		type = "rogue",
		faction = self.faction,
		summoner = self, summoner_gain_exp = true,
		temporary = dur or self:callTalent(self.T_TRAP_MASTERY, "getDuration"),
		detect_power = math.floor(trapPower(self,t)),
		disarm_power = math.floor(trapPower(self,t)*1.25),
		canAct = false,
		energy = {value=0}, -- delays acting by default
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		act = function(self)
			if self.realact then self:realact() end
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then
					game.level.map:remove(self.x, self.y, engine.Map.TRAP)
					if self.summoner and self.stamina and self.stamina > 0 then -- Refund
						self.summoner:incStamina(self.stamina * 0.8)
						game.logPlayer(self.summoner, "#CADET_BLUE#Your %s has expired.", self:getName())
					end
				end
				if self.particles then game.level.map:removeParticleEmitter(self.particles) end
				game.level:removeEntity(self, true)
			end
		end,
	}
	table.merge(trap, add)
	if trap.desc == nil then trap.desc = util.getval(t.short_info, self, t) end
	if t.trap_mastery_level and t.unlock_talent and trap.unlock_talent_on_disarm == nil then -- by default, chance to unlock a trap by disarming it
		trap.unlock_talent_on_disarm = {tid=t.id, chance=20}
	end
	return Trap.new(trap)
end

-- Assign trap support functions to global Talents
-- This allows them to be called as self:<function_name>(...)
Talents.trap_mastery_tids = trap_mastery_tids
Talents.trapPower = trapPower
Talents.trap_mastery_talent = trap_mastery_talent
Talents.trap_effectiveness = trap_effectiveness
Talents.trap_range = trap_range
Talents.trap_stealth = trap_stealth
Talents.trap_speed = trap_speed
Talents.traps_initialize = traps_initialize
Talents.traps_getunlocked = traps_getunlocked
Talents.trap_ai_coords = trap_ai_coords
Talents.traps_on_pre_use_ai = traps_on_pre_use_ai
Talents.trapGetGrid = trapGetGrid
Talents.trapping_CreateTrap = trapping_CreateTrap

local trap_init = false
trap_mastery_tids = {}
--- initialize traps data
traps_initialize = function()
	if not trap_init then
		local trap_talents = Talents.talents_types_def["cunning/traps"].talents
		for i, t in ipairs(trap_talents) do
			if not trap_mastery_tids[t.id] then
				trap_mastery_tids[t.id] = t.trap_mastery_level
			end
			if t.message == nil then -- default, vague talent message
				t.message = _t"@Source@ activates a prepared device."
			end
			if t.on_pre_use_ai == nil then t.on_pre_use_ai = traps_on_pre_use_ai end
		end
	end
	trap_init = true
	return true
end

--- Create and place an assassin ally (Ambush Trap)
summon_assassin = function(self, target, duration, x, y, scale )
	local m = mod.class.NPC.new{
		type = "humanoid", subtype = "human",
		display = "p", color=colors.BLUE, image = "npc/humanoid_human_assassin.png", shader = "shadow_simulacrum",
		name = _t"shadowy assassin", faction = self.faction,
		desc = _t[[A shadowy figure, garbed all in black.]],
		autolevel = "rogue",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=5, },
		stats = { str=8, dex=15, mag=6, cun=15, con=7 },
		infravision = 10,
		max_stamina = 100,
		stealth = self:combatStatScale("cun", 15, 50),
		rank = 2,
		size_category = 3,
		max_level = self.level,
		resolvers.racial(),
		resolvers.sustains_at_birth(),
		open_door = true,
		movement_speed = 1.5, -- fast, so target cannot simply walk away
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		resolvers.equip{
			{type="weapon", subtype="dagger", autoreq=true, ego_filter={ego_chance=-1000}},
			{type="weapon", subtype="dagger", autoreq=true, ego_filter={ego_chance=-1000}},
			{type="armor", subtype="light", autoreq=true, ego_filter={ego_chance=-1000}}
		},
		resolvers.talents{
			[Talents.T_LETHALITY]={base=5, every=6, max=8},
			[Talents.T_KNIFE_MASTERY]={base=0, every=8, max=5},
			[Talents.T_WEAPON_COMBAT]={base=0, every=8, max=5},
		},
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		infravision = 10,
		
		no_drops = 1,
		combat_armor = 3, combat_def = 10,
		summoner = self, summoner_gain_exp=true,
		summon_time = duration,
		trigger_target = target,
	}
	
	m.on_act = function(self)
		if not self.trigger_target or self.trigger_target.dead or not game.level:hasEntity(self.trigger_target) then self.summon_time = 0 end
	end
	m:setTarget(target)
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.no_inventory_access = true
	m.save_hotkeys = true
	m.ai_state = m.ai_state or {}
	m.ai_state.tactic_leash = 100
	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	m:resolve() m:resolve(nil, true)
	m:forceLevelup(self.level)

	game.zone:addEntity(game.level, m, "actor", x, y)
	game.logSeen(m, "#PINK#A %s materializes from the shadows!", m.name:capitalize())
	game.level.map:particleEmitter(x, y, 1, "summon")

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0
	m.summon_time = duration

	mod.class.NPC.castAs(m)
	engine.interface.ActorAI.init(m, m)
	m.energy.value = 0

	return m
end

--- Create and place a bladestorm construct (Bladestorm Trap)
summon_bladestorm = function(self, target, duration, x, y, scale )
	local m = mod.class.NPC.new{
		type = "construct", subtype = "mechanical",
		display = "^", color=colors.BROWN, image = "npc/trap_bladestorm_swish_01.png",
		name = _t"bladestorm construct", faction = self.faction,
		desc = _t[[A lethal contraption of whirling blades.]],
		autolevel = "warrior",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=5, },
		stats = { str=18, dex=15, mag=6, cun=6, con=7 },
		max_stamina = 100,
		rank = 2,
		size_category = 3,
		max_level = self.level,
		resolvers.sustains_at_birth(),
		body = { INVEN = 10, MAINHAND=1 },
		resolvers.equip{
			{type="weapon", subtype="greatsword", autoreq=true, ego_filter={ego_chance=-1000}},
		},
		resolvers.talents{
			[Talents.T_WEAPONS_MASTERY]={base=1, every=6, max=5},
			[Talents.T_WEAPON_COMBAT]={base=1, every=6, max=5},
		},
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		on_act = function(self)
			if self.turn_procs.bladestorm_trap then return end
			self.turn_procs.bladestorm_trap = true
	
			local showoff = false
			local tg = {type="ball", range=0, selffire=false, radius=1}

			self:project(tg, self.x, self.y, function(px, py, tg, self)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if target and self:reactionToward(target) < 0 then
					self:attackTarget(target, nil, 1.0, false)
				end
			end)
			self:addParticles(engine.Particles.new("meleestorm", 1, {img="spinningwinds_red"}))
			self:addParticles(engine.Particles.new("meleestorm", 1, {img="spinningwinds_red"}))
		end,

		life_rating = 12,
		never_move = 1,
		cant_be_moved = 1,
		negative_status_effect_immune = 1,
		combat_armor = math.floor(2*self.level^.75),
		combat_def = self:getCun()^.75,
		resists = {all = self:combatStatLimit("cun", 70, 25, 50)},
		negative_status_immune = 1,
		
		no_drops = 1,
		summoner = self, summoner_gain_exp=true,
		summon_time = duration,
	}
	m:setTarget(target)
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.no_inventory_access = true
	m.save_hotkeys = true
	m.ai_state = m.ai_state or {}
	m.ai_state.tactic_leash = 100
	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	m:resolve() m:resolve(nil, true)
	m:forceLevelup(self.level)

	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "summon")
	m:setTarget(target)

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0
	m.summon_time = duration

	mod.class.NPC.castAs(m)
	engine.interface.ActorAI.init(m, m)
	m.energy.value = game.energy_to_act -- can act immediately
	return m
end

--- Generic NPC trap selection function
-- npc's pick/update their trap selections randomly for Trap Mastery and Trap Priming
-- called with on_pre_use_ai function
traps_ai_select = function(self) -- NPC's automatically assign traps to preparation slots randomly
	local party_member = game.party:hasMember(self)
	local trap_level = self.turn_procs._pick_trap_priming
	local trap_list = traps_getunlocked(self)
	local t = trap_level and self:getTalentFromId(self.T_TRAP_PRIMING)
	if t then -- update Trap Priming Trap
		-- unlearn priming trap (so a new one may be selected from all available)
		if self.trap_primed and self.trap_priming_ai ~= trap_level and not party_member then
			print("traps_ai_select", t.id, self.name, self.uid, "unlearning talent", self.trap_primed)
			self:unlearnTalentFull(self.trap_primed)
			self.trap_primed = nil
		end
		if not self.trap_primed then -- pick a trap with a priming trigger
			local trap_list = table.clone(trap_list)
			while #trap_list > 0 do
				local tid = rng.tableRemove(trap_list)
				local tr = self:getTalentFromId(tid)
				
				if tr.allow_primed_trigger and trap_level >= tr.trap_mastery_level and not self:knowTalent(tid) and self:canLearnTalent(tr) and not (tr.is_antimagic and self:attr("has_arcane_knowledge") or tr.is_spell and self:attr("forbid_arcane")) then
					print("traps_ai_select", t.id, self.name, self.uid, "learning talent", tid)
					if self:learnTalent(tid, true, 1, {no_unlearn=true}) then
						-- starts on cooldown for party members (except temp summons)
						if party_member and not self.summon_time and not self.turn_procs.free_trap_mastery then
							self:startTalentCooldown(tr)
							self:startTalentCooldown(t)
						end
						self.trap_primed = tid
						break
					end
				end
			end
		end
		self.trap_priming_ai = trap_level
	end

	trap_level = self.turn_procs._pick_trap_mastery
	t = trap_level and self:getTalentFromId(self.T_TRAP_MASTERY)
	if t then -- update Trap Mastery Traps
		local traps_ai = self.trap_mastery_ai
		traps_ai.selected = traps_ai.selected or {}
		local reset = traps_ai.trap_level ~= trap_level and not party_member
		local nb_traps = 0
		for tid, state in pairs(traps_ai.selected) do
			if state and self.trap_primed ~= tid then
				if reset then -- unlearn all traps (so that new ones may be selected from all available)
					print("traps_ai_select", t.id, self.name, self.uid, "unlearning talent", tid)
					traps_ai.selected[tid] = false
					self:unlearnTalentFull(tid)
				elseif self:getTalentFromId(tid) then -- count traps already prepared
					nb_traps = nb_traps + 1
				end
			end
		end
		local slots = t.getNbTraps(self, t)
		while nb_traps < slots do
			local tid = rng.tableRemove(trap_list)
			if not tid then break end
			local tr = self:getTalentFromId(tid)
			
			if trap_level >= tr.trap_mastery_level and not self:knowTalent(tid) and self:canLearnTalent(tr) and not (tr.is_antimagic and self:attr("has_arcane_knowledge") or tr.is_spell and self:attr("forbid_arcane")) then
				print("traps_ai_select", t.id, self.name, self.uid, "learning talent", tid)
				if self:learnTalent(tid, true, 1, {no_unlearn=true}) then
					nb_traps = nb_traps + 1
					traps_ai.selected[tid] = true
					-- starts on cooldown for party members (except temp summons)
					if party_member and not self.summon_time and not self.turn_procs.free_trap_mastery then
						self:startTalentCooldown(tr)
						self:startTalentCooldown(t)
					end
				end
			end
		end
		traps_ai.trap_level = trap_level
	end
end

----------------------------------------------------------------
-- Trap Management Talents
----------------------------------------------------------------
newTalent{
	name = "Trap Mastery",
	type = {"cunning/trapping", 1},
	require = {
		stat = { cun=function(level) return 15 + (level-1) * 2 end },
		level = function(level) return math.min(level^2-1, level*5) end,
	},
	points = 5,
	getTrapMastery = function(self, t) return self:combatTalentScale(t, 25, 100) end,
	getPower = trapPower,
	getNbTraps = function(self, t) return util.bound(self:getTalentLevelRaw(t), 1, 3) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 9, 13)) end,
	no_unlearn_last = true,
	tactical = {BUFF = 1},
	stamina = 0, -- forces stamina pool for traps
	on_pre_use = traps_initialize, -- forces initialization of trap data before use
	on_pre_use_ai = function(self, t, silent, fake) -- NPC's automatically assign traps to preparation slots randomly
		local traps_ai = self.trap_mastery_ai or {trap_level=0, selected={}}
		self.trap_mastery_ai = traps_ai
		local trap_level = math.min(5, self:getTalentLevelRaw(t))
		if traps_ai.trap_level ~= trap_level then -- updated talent, select new traps
			print(t.id, self.name, self.uid, "updating from trap level", traps_ai.trap_level, "to level", trap_level)
			self.turn_procs._pick_trap_mastery = trap_level
			game:onTickEnd(function()
				traps_ai_select(self)
			end, "ai_pick_traps")
		end
		return false -- NPC's don't actually use the action function
	end,
	-- allow the player to select traps at the start of the game
	on_levelup_close = function(self, t, lvl, old_lvl, lvl_raw, old_lvl_raw)
		if game.turn == 0 and lvl_raw >= 1 then
			if self:isClassName("mod.dialogs.LevelupDialog") then self = self.actor end
			if self.player and game.turn == 0 and lvl_raw >= 1 then
				for mem, ctrl in pairs(game.party.members) do
					mem.turn_procs.free_trap_mastery = true
				end
				self:forceUseTalent(t.id, {ignore_cd=true, ignore_energy=true})
			end
		end
		t.on_levelup_close = nil
	end,
	action = function(self, t)
		local nb = t.getNbTraps(self,t)
		local txt = ("Prepare which traps? (maximum: %d, up to tier %d)%s"):tformat(nb, math.min(5, self:getTalentLevelRaw(t)), self.turn_procs.free_trap_mastery and _t"\nGame Start: Newly prepared traps will NOT start on cooldown." or _t"\n#YELLOW#Newly prepared traps are put on cooldown.#LAST#")
		local traps_dialog = require("mod.dialogs.TrapsSelect").new(_t"Select Prepared Traps", self,
		txt, t, nb, trap_mastery_tids)
		local traps_sel, traps_prev = self:talentDialog(traps_dialog)

		local changed = false
		if traps_sel and traps_prev then
			for tid, _ in pairs(traps_prev) do
				if not traps_sel[tid] then
					game.log("#YELLOW_GREEN#Dismantling %s", self:getTalentFromId(tid).name)
					self:unlearnTalentFull(tid)
					changed = true
				end
			end
			for tid, sel in pairs(traps_sel) do
				if sel and not traps_prev[tid] then
					game.log("#LIGHT_GREEN#Preparing %s%s", self:getTalentFromId(tid).name, self.trap_primed == tid and _t" (normal trigger)" or "")
					self:learnTalent(tid, true, 1, {no_unlearn=true})
					if self.trap_primed == tid then 
						self.trap_primed = nil
					end
					if not self.turn_procs.free_trap_mastery then self:startTalentCooldown(tid) end -- don't cooldown on birth
					changed = true
				end
			end
		end
		if not changed then game.logPlayer(self, "#LIGHT_BLUE#No changes to trap preparation.") end
		
		self.turn_procs.free_trap_mastery = false
		self.trap_mastery_ai = {trap_level=math.min(5, self:getTalentLevelRaw(t)), selected=traps_sel or {}} -- for possible AI control later
		return changed
	end,
	info = function(self, t)
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local detect_power = t.getPower(self, t)
		local disarm_power = t.getPower(self, t)*1.25

		local trap_list = traps_getunlocked(self, t)
		local player = game:getPlayer(true)
		local show_traps = {}
		for i, tid in ipairs(trap_list) do
			local known = self:knowTalent(tid)
			-- display info only for traps prepared or known to the player
			if known or game.state:unlockTalentCheck(tid, player) then
				local tr = self:getTalentFromId(tid)
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				known = self.trap_primed ~= tid and known, 
				info = tr.short_info and tr.short_info(self, tr) or _t"#GREY#(see trap description)#LAST#"}
			end
		end
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%sTier %d: %s#LAST#\n%s"):tformat(trap.known and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		self.turn_procs.trap_mastery_tid = nil
		return ([[This talent allows you to prepare up to %d different trap(s) of tier %d or less for later deployment. (Use this ability to select which to prepare.)
		Designs known:
%s

		Traps prepared this way are difficult to detect (%d detection 'power') and disarm (%d disarm 'power') based on your Cunning.  They gain %+d%% effectiveness, and can be deployed without breaking stealth %d%% of the time.
		You are immune to the damage and negative effects of your traps, and traps may critically strike based on your physical crit chance.
		Most traps last %d turns if not triggered, and refund 80%% of their stamina cost on expiration.
		More designs may be discovered via disarming or learned from special instructors in the world.]]):
		tformat(t.getNbTraps(self, t), math.min(5, self:getTalentLevelRaw(t)), trap_descs, detect_power, disarm_power, t.getTrapMastery(self, t), stealth_chance, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Lure",
	type = {"cunning/trapping", 2},
	points = 5,
	cooldown = 15,
	stamina = 15,
	no_break_stealth = true,
	require = cuns_req2,
	no_npc_use = true,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7)) end, -- limit < 10
	getDuration = function(self,t) return math.floor(self:combatTalentScale(t, 5, 13)) end,
	getLife = function(self, t) return self:getCun()*self:combatTalentLimit(t, 5, 1.5, 2.5) end,
	getArmor = function(self, t) return math.floor(self:combatTalentScale(t, 10, 25)) end,
	getResist = function(self, t) return self:combatTalentLimit(t, 90, 65, 75) end,
	speed = "combat",
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, simple_dir_request=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local resist = t.getResist(self, t)
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "construct", subtype = "lure",
			display = "*", color=colors.UMBER,
			name = _t"lure", faction = self.faction, image = "npc/lure.png",
			desc = _t[[A noisy lure.]],
			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented", ai_state = { talent_in=1, },
			level_range = {1, nil}, exp_worth = 0,

			max_life = t.getLife(self, t),
			life_rating = 0,
			never_move = 1,

			-- Resistant to damage
			combat_armor = t.getArmor(self, t),
			combat_def = 0, combat_def_ranged = self.level * 2.2,
			-- Hard to kill with spells
			resists = {[DamageType.PHYSICAL] = -resist, all = resist},
			poison_immune = 1,

			talent_cd_reduction={[Talents.T_TAUNT]=2, },
			resolvers.talents{
				[self.T_TAUNT]=self:getTalentLevelRaw(t),
			},

			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self,t),
		}
		if self:getTalentLevel(t) >= 5 then
			m.on_die = function(self, src)
				if not src or src == self then return end
				self:project({type="ball", range=0, radius=2}, self.x, self.y, function(px, py)
					local trap = game.level.map(px, py, engine.Map.TRAP)
					if not trap or not trap.lure_trigger then return end
					trap:trigger(px, py, src)
				end)
			end
		end

		m:resolve() m:resolve(nil, true)
		m:forceLevelup(self.level)
		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")
		return true
	end,
	info = function(self, t)
		local t2 = self:getTalentFromId(self.T_TAUNT)
		local rad = t2.radius(self, t)
		return ([[Deploy a noisy lure that attracts all creatures within radius %d to it for %d turns.
		It has %d life (based on your Cunning) and is very durable, with %d armor and %d%% resistance to non-physical damage.
		At level 5, when the lure is destroyed, it will trigger some traps in a radius of 2 around it (check individual trap descriptions to see if they are triggered).
		Use of this talent will not break stealth.]]):tformat(rad, t.getDuration(self,t), t.getLife(self, t), t.getArmor(self, t), t.getResist(self, t))
	end,
}

newTalent{
	name = "Advanced Trap Deployment", short_name = "TRAP_LAUNCHER",
	type = {"cunning/trapping", 3},
	points = 5,
	mode = "passive",
	require = cuns_req3,
	trapSpeed = function(self, t) return self:combatLimit(self:getTalentLevel(t), 0.5, 1, 0, 0.8, 5) end,
	trapStealth = function(self, t) return math.min(25, self:getTalentLevel(t)) end,
	info = function(self, t)
		return ([[You learn new techniques for setting traps.
		Deploying one of your traps is possible up to %d grids from you, takes %d%% less time than normal, and has %d%% less chance to break stealth.]]):tformat(trap_range(self, t), (1 - t.trapSpeed(self, t))*100, t.trapStealth(self, t))
	end,
}

newTalent{
	name = "Trap Priming",
	type = {"cunning/trapping", 4},
	require = cuns_req4,
	message = false,
	points = 5,
	no_unlearn_last = true,
	getTrapMastery = function(self, t) return self:combatTalentScale(t, 12, 60) end,
	tactical = {BUFF = 1},
	stamina = 0, -- forces stamina pool for traps
	on_pre_use_ai = function(self, t, silent, fake) -- NPC's automatically randomly pick a trap with a priming trigger
		local trap_level = math.min(5, self:getTalentLevelRaw(t))
		if trap_level ~= self.trap_priming_ai then -- updated talent -- select new traps
			print(t.id, self.name, self.uid, "updating from trap level", self.trap_priming_ai, "to level", trap_level)
			self.turn_procs._pick_trap_priming = trap_level
			game:onTickEnd(function() 
					traps_ai_select(self)
				end, "ai_pick_traps")
		end
		return false -- NPC's don't actually use the action function
	end,
	action = function(self, t)
		local chat = Chat.new("trap-priming", self, self, {player=self, trapping_tids=traps_getunlocked(self, t), chat_talent=t})
		local d = chat:invoke()
		d.key:addBinds{ EXIT = function()
			self:talentDialogReturn(self.trap_primed, self.trap_primed)
			game:unregisterDialog(d)
		end}
		local new_trap, old_trap = self:talentDialog(d)
		if new_trap == old_trap then
			game.logPlayer(self, "#LIGHT_BLUE#Cancelled Trap Priming.")
			return
		else
			if old_trap then
				self:unlearnTalentFull(old_trap)
				game.logPlayer(self, "#YELLOW_GREEN#Dismantling %s (instant trigger)", self:getTalentFromId(old_trap).name)
			end
			if new_trap then
				self:learnTalent(new_trap, true, 1, {no_unlearn=true})
				game.logPlayer(self, "#LIGHT_GREEN#Preparing %s (instant trigger)", self:getTalentFromId(new_trap).name)
				if not self.turn_procs.free_trap_mastery then self:startTalentCooldown(new_trap) end -- don't cooldown on birth
			end
			self.trap_primed = new_trap
			self.trap_priming_ai = math.min(5, self:getTalentLevelRaw(t)) -- for possible AI control later
		end
		return true
	end,
	info = function(self, t)
		local m_level, trap_list = self:getTalentLevelRaw(t), traps_getunlocked(self, t)
		local mastery = t.getTrapMastery(self, t)
		local instant = "none"
		local show_traps = {}
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local player = game:getPlayer(true)
		for i, tid in pairs(trap_list) do
			local tr = self:getTalentFromId(tid)
			-- show only primable traps that are primed or that the player knows about
			if tr and tr.allow_primed_trigger and tr.trap_mastery_level and (self:knowTalent(tid) or game.state:unlockTalentCheck(tid, player)) then
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				info = tr.short_info and tr.short_info(self, tr) or _t"#GREY#(see trap description)#LAST#"}
				if tid == self.trap_primed then
					show_traps[#show_traps].instant = true
					instant = tr.name
				end
			end
		end
		self.turn_procs.trap_mastery_tid = nil
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%sTier %d: %s#LAST#\n%s"):tformat(trap.instant and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		return ([[You prepare an additional trap (up to tier %d) with a special primed trigger that causes it to activate immediately when deployed. (Use this ability to select the trap.)
		Not all traps can be prepared this way and each trap can have only one type of preparation.
		Known primable designs:
%s

A trap with a primed trigger gains %+d%% effectiveness (replacing the normal bonus from Trap Mastery) and won't break stealth %d%% of the time.
#YELLOW#Current primed trap: %s#LAST#]]):
		tformat(self:getTalentLevelRaw(t), trap_descs, mastery, stealth_chance, instant)
	end,
}

----------------------------------------------------------------
-- Trap Creation Talents
----------------------------------------------------------------
newTalent{
	name = "Springrazor Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	cooldown = 8,
	stamina = 15,
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 2,
	no_break_stealth = trap_stealth,
	tactical = { ATTACKAREA = { PHYSICAL = 1.5 }, DISABLE = 0.5,
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	no_unlearn_last = true,
	getDamage = function(self, t) return self.trap_effectiveness(self, t, "cun")*25 end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false} end, -- for AI/instant
	getPower = function(self, t) return math.floor(self.trap_effectiveness(self, t, "cun")*3) end,
	allow_primed_trigger = true,
	action = function(self, t)
		local x, y = trapGetGrid(self, t, nil)
		if not (x and y) then return nil end
		
		local tg = self:getTalentTarget(t)
		local dam = self:physicalCrit(t.getDamage(self, t))
		local power = t.getPower(self,t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"springrazor trap", color=colors.LIGHT_RED, image = "trap/trap_springrazor.png",
			dam = dam,
			power = power,
			tg = tg,
			check_hit = self:combatAttack(),
			stamina = t.stamina,
			lure_trigger = true,
			pressure_trap = true,
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local who = game.level.map(px, py, engine.Map.ACTOR)
					if who == self.summoner then return end
					if who then
						who:setEffect(who.EFF_RAZORWIRE, 3, {power=self.power, apply_power=self.check_hit})
					end
					engine.DamageType:get(engine.DamageType.PHYSICAL).projector(self.summoner, px, py, engine.DamageType.PHYSICAL, self.dam)
				end)
				game.level.map:particleEmitter(x, y, 2, "meleestorm", self.tg)
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Shrapnel (radius 2) deals %0.2f physical damage, reduces accuracy, armour, and defence by %d.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getPower(self,t))
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local power = t.getPower(self,t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a pressure triggered trap that explodes into a radius 2 wave of razor sharp wire, doing %0.2f physical damage. Those struck by the wire may be shredded, reducing accuracy, armor and defence by %d.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(damDesc(self, DamageType.PHYSICAL, dam), power, instant)
	end,
}

newTalent{
	name = "Bear Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	cooldown = 12,
	stamina = 10,
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 1,
	tactical = { ATTACK = {PHYSICAL = 1}, ESCAPE = { pin = 2 }, CLOSEIN = { pin = 1 } },
	no_break_stealth = trap_stealth,
	no_unlearn_last = true,
	getDamage = function(self, t) return 20 + self.trap_effectiveness(self, t, "cun")*10 end,
	allow_primed_trigger = true,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end
		
		local dam = self:physicalCrit(t.getDamage(self, t))
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"bear trap", color=colors.UMBER, image = "trap/beartrap01.png",
			dam = dam,
			stamina = t.stamina,
			check_hit = self:combatAttack(),
			pressure_trap = true,
			triggered = function(self, x, y, who)
				local who = game.level.map(x, y, engine.Map.ACTOR)
				if who then
					self:project({type="hit", x=x,y=y}, x, y, engine.DamageType.PHYSICAL, self.dam)
					who:setEffect(who.EFF_BEAR_TRAP, 5, {src=self.summoner, power=0.3, dam=self.dam/5})
					return true, true
				end
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[Deals %0.2f physical damage and pins, slows (30%%), and wounds for an additional %0.2f damage over 5 turns).]]):tformat(dam, dam)
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a pressure triggered bear trap that snaps onto the first creature passing over it.  Victims are dealt %0.2f physical damage and become snared (pinned and slowed 30%%) and wounded for %0.2f bleeding damage over 5 turns.  Creatures that avoid being snared still suffer bleeding damage.%s]]):tformat(dam, dam, instant)
	end,
}

newTalent{
	name = "Disarming Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	trap_mastery_level = 1,
	cooldown = 15,
	stamina = 25,
	tactical = { ATTACK = {ACID = 1.75}, DISABLE = { disarm = 1 }, ESCAPE = 1, CLOSEIN = 1 },
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	getDamage = function(self, t) return 10 + trap_effectiveness(self, t, "cun")*30 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(self.T_TRAP_MASTERY), 2.1, 4.43)) end,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local dam = t.getDamage(self, t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"disarming trap", color=colors.DARK_GREY, image = "trap/trap_magical_disarm_01_64.png",
			dur = t.getDuration(self, t),
			check_hit = self:combatAttack(),
			dam = dam,
			stamina = t.stamina,
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			triggered = function(self, x, y, who)
				self:project({type="hit", x=x,y=y}, x, y, engine.DamageType.ACID, self.dam, {type="acid"})
				if who:canBe("disarm") then
					who:setEffect(who.EFF_DISARMED, self.dur, {apply_power=self.check_hit})
				else
					game.logSeen(who, "%s resists!", who:getName():capitalize())
				end
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Deals %0.2f acid damage, disarms for %d turns.]]):
		tformat(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
	info = function(self, t)
		return ([[Lay a tricky trap that maims creatures passing by with acid doing %0.2f damage and disarming them for %d turns.]]):
		tformat(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Pitfall Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	cooldown = 20,
	stamina = 10,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 3,
	tactical = { ATTACK = {PHYSICAL = 1}, ESCAPE = {pin = 2 }, CLOSEIN = {pin = 1} },
	no_break_stealth = trap_stealth,
	no_unlearn_last = true,
	getDamage = function(self, t) return 10 + self.trap_effectiveness(self, t, "cun")*25 end,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end
		
		local dam = self:physicalCrit(t.getDamage(self, t))
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"pitfall trap", color=colors.UMBER, image = "trap/trap_pitfall_setup.png",
			dam = dam,
			stamina = t.stamina,
			check_hit = self:combatAttack(),
			pressure_trap = true,
			triggered = function(self, x, y, who)

				self:project({}, x, y, engine.DamageType.PHYSICAL, self.dam )
				
				if who.dead then return true, true end -- If they're dead don't remove them
				-- Check hit
				local hit = self:checkHit(self.check_hit, who:combatPhysicalResist())
				if hit and not who.player then 
					game.logSeen(who, "%s disappears into a collapsing pit!", who:getName():capitalize())
				else -- try to pin if they avoided the pit
					if rng.percent(50) or who:canBe("pin") then
						game.logSeen(who, "%s is partially buried in a collapsing pit!", who:getName():capitalize())
						if (table.get(who, "can_pass", "pass_wall") or 0) <= 0 then
							who:setEffect(who.EFF_PINNED, 5, {})
						end
					else
						game.logSeen(who, "%s avoids a collapsing pit!", who:getName():capitalize())
					end
					return true, true
				end
				-- Placeholder for the actor
				local oe = game.level.map(x, y, engine.Map.TERRAIN+1)
				if (oe and oe:attr("temporary")) or game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") then game.logPlayer(self, "Something has prevented the pit.") return true end
				local e = mod.class.Object.new{
					old_feat = oe, type = "pit", subtype = "pit",
					name = _t"pit", image = "trap/trap_pitfall_pit.png",
					display = '&', color=colors.BROWN,
					temporary = 5,
					canAct = false,
					target = who,
					act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						-- return the rifted actor
						if self.temporary <= 0 then
							-- remove ourselves
							if self.old_feat then game.level.map(self.target.x, self.target.y, engine.Map.TERRAIN+1, self.old_feat)
							else game.level.map:remove(self.target.x, self.target.y, engine.Map.TERRAIN+1) end
							game.nicer_tiles:updateAround(game.level, self.target.x, self.target.y)
							game.level:removeEntity(self, true)
							game.level.map:removeParticleEmitter(self.particles)
							
							-- return the actor and reset their values
							local mx, my = util.findFreeGrid(self.target.x, self.target.y, 20, true, {[engine.Map.ACTOR]=true})
							local old_levelup = self.target.forceLevelup
							local old_check = self.target.check
							self.target.forceLevelup = function() end
							self.target.check = function() end
							game.zone:addEntity(game.level, self.target, "actor", mx, my)
							game.logSeen(self.target, "%s emerges from a collapsed pit.", self.target:getName():capitalize())
							self.target.forceLevelup = old_levelup
							self.target.check = old_check
						end
					end,
					summoner_gain_exp = true, summoner = self,
				}
				
				-- Remove the target
				game.level:removeEntity(who, true)
				game.level.map:particleEmitter(x, y, 1, "fireflash", {radius=2, tx=x, ty=y})
				
				local particle = Particles.new("wormhole", 1, {image="shockbolt/trap/trap_pitfall_pit", speed=0})
				particle.zdepth = 6
				e.particles = game.level.map:addParticleEmitter(particle, x, y)
						
				game.level:addEntity(e)
				game.level.map(x, y, engine.Map.TERRAIN+1, e)
				game.level.map:updateMap(x, y)
			
			
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Deals %0.2f physical damage.  Target removed from combat or pinned 5 turns.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
	info = function(self, t)
		return ([[Lay a pressure triggered trap that collapses the ground under the target, dealing %0.2f physical damage while burying them (removing from combat) for 5 turns.
Victims may resist being buried, in which case they are pinned (ignores 50%% pin immunity) instead.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Flash Bang Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	cooldown = 12,
	stamina = 12,
	tactical = { ATTACKAREA = {PHYSICAL = 1.5}, DISABLE = { blind = 1, stun = 1 },
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 4,
	no_break_stealth = trap_stealth,
	no_unlearn_last = true,
	allow_primed_trigger = true,
	getDuration = function(self, t) return 1 + math.floor(2*self.trap_effectiveness(self, t, "cun")^.5) end,
	getDamage = function(self, t) return 25 + self.trap_effectiveness(self, t, "cun")*25 end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t, nil)
		if not (x and y) then return nil end

		local tg = self:getTalentTarget(t)
		local dam = self:physicalCrit(t.getDamage(self, t))
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "elemental", name = _t"flash bang trap", color=colors.YELLOW, image = "trap/trap_flashbang.png",
			dur = t.getDuration(self, t),
			check_hit = self:combatAttack(),
			lure_trigger = true,
			stamina = t.stamina,
			dam = dam,
			tg = tg,
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local who = game.level.map(px, py, engine.Map.ACTOR)
					if who == self.summoner then return end
					engine.DamageType:get(engine.DamageType.PHYSICAL).projector(self.summoner, px, py, engine.DamageType.PHYSICAL, self.dam)
					if who then
						if rng.percent(50) and who:canBe("blind") then
							who:setEffect(who.EFF_BLINDED, self.dur, {apply_power=self.check_hit})
						end
						if rng.percent(50) and who:canBe("stun") then
							who:setEffect(who.EFF_DAZED, self.dur, {apply_power=self.check_hit})
						end
					end
				end)
				game.level.map:particleEmitter(x, y, 2, "sunburst", self.tg)
				game:playSoundNear(self, "talents/lightning_loud")
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Explodes (radius 2) for %0.2f physical damage, 50%% blind/daze for %d turns.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t))
	end,
	info = function(self, t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a trap that explodes in a radius of 2, dealing %0.2f physical damage and blinding and dazing (50%% chance of each) any creature caught inside for %d turns.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t), instant)
	end,
}

newTalent{
	name = "Bladestorm Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	cooldown = 20,
	stamina = 20,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 5,
	tactical = { ATTACKAREA = { PHYSCIAL = 2 }, ESCAPE = 1, CLOSEIN = 1 },
	no_break_stealth = trap_stealth,
	no_unlearn_last = true,
	getDuration = function(self, t) return math.floor(self:callTalent(self.T_TRAP_MASTERY, "getDuration")*.75) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=1, friendlyfire=false} end, -- for AI
	action = function(self, t)
		local x, y = trapGetGrid(self, t, nil)
		if not (x and y) then return nil end

		local dur = t.getDuration(self,t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"bladestorm trap", color=colors.BLACK, image = "trap/trap_bladestorm_01.png",
			dur = dur,
			stamina = t.stamina,
			triggered = function(self, x, y, who)
				local tx, ty = util.findFreeGrid(x, y, 1, true, {[engine.Map.ACTOR]=true}) -- don't activate without room
				if not tx or not ty then return nil end
				local m = self.summoner.main_env.summon_bladestorm(self.summoner, who, self.dur, tx, ty)
				
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Construct attacks all adjacent enemies each turn for %d turns.]]):tformat(t.getDuration(self, t))
	end,
	info = function(self, t)
		return ([[Lay a trap that activates a lethal contraption of whirling blades, lasting %d turns.  This stationary construct is very durable, receives your damage bonuses, and automatically attacks all adjacent enemies each turn.]]):tformat(t.getDuration(self,t))
	end,
}

-- unlocked in Derth after the lightning-overload quest or by disarming "spinning beam trap"
newTalent{
	name = "Beam Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = table.merge({ stat={mag=20}}, cuns_req_unlock),
	is_spell = true,
	trap_mastery_level = 3,
	unlock_talent = function(self, t) return self.player or self.level > 5 and not self:attr("forbid_arcane"), "You have learned how to create beam traps!" end,
	no_unlearn_last = true,
	cooldown = 15,
	stamina = 24,
	requires_target = true,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	target = function(self, t) return {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, simple_dir_request=true, talent=t} end, -- for AI
	getDuration = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(self.T_TRAP_MASTERY), 3, 6)) end,
	getDamage = function(self, t) return (15 + self:combatStatScale("cun", 10, 60) * self:callTalent(self.T_TRAP_MASTERY,"getTrapMastery") / 20)/3 end,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end
		
		local dam = self:physicalCrit(t.getDamage(self, t))

		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"beam trap", color=colors.BLUE, image = "trap/trap_beam.png",
			dam = dam,
			proj_speed = 2,
			triggered = function(self, x, y, who) return true, false end,
			energy = {value=0, mod=1},
			message = false,
			temporary = t.getDuration(self, t),
			disarmed = function(self, x, y, who)
				game.level:removeEntity(self, true)
			end,
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			realact = function(self)
                local tgts = {}
                local grids = core.fov.circle_grids(self.x, self.y, 5, true)
                for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
                local a = game.level.map(x, y, engine.Map.ACTOR)
                if a and self:reactionToward(a) < 0 then
                   tgts[#tgts+1] = a
                end
                end end
				
				if #tgts <= 0 then return end
				local a, id = rng.table(tgts)
				table.remove(tgts, id)
				self:project({type="beam", x=self.x, y=self.y}, a.x, a.y, engine.DamageType.ARCANE, self.dam, nil)
				game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(a.x-self.x), math.abs(a.y-self.y)), "mana_beam", {tx=a.x-self.x, ty=a.y-self.y})
				
			end
		})
	  
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Fires a beam (range 5) at a foe each turn for %0.2f arcane damage.  Lasts %d turns.]]):
		tformat(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)), t.getDuration(self, t))
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[Lay a magical trap that fires a beam of arcane energy at a random foe (within range 5) each turn for %d turns, inflicting %0.2f arcane damage.
This trap requires 20 Magic to prepare and does not refund stamina when it expires.
#YELLOW#Activates immediately when placed.#LAST#]]):tformat(dur, damDesc(self, DamageType.ARCANE, dam))
	end,
}

-- unlocked in the Maze or by disarming certain traps ("poison spore", "poison blast trap")
newTalent{
	name = "Poison Gas Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = _t"You have learned how to create Poison Gas traps!",
	cooldown = 10,
	stamina = 12,
	tactical = { ATTACKAREA = { poison = 1.5 }, DISABLE = { poison = 0.5 },
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	no_unlearn_last = true,
	trap_mastery_level = 2,
	allow_primed_trigger = true,
	getDamage = function(self, t) return 10 + trap_effectiveness(self, t, "cun")*25 end,
	getPower = function(self, t) return math.floor(self:combatTalentScale(trap_mastery_talent(self, t), 10, 20)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=3, selffire=self.trap_primed == t.id} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t, nil)
		if not (x and y) then return nil end

		local dam = self:physicalCrit(t.getDamage(self, t))
		local power = t.getPower(self,t)

		local trap = trapping_CreateTrap(self, t, nil, {
			type = "nature", name = _t"poison gas trap", color=colors.LIGHT_RED, image = "trap/trap_poison_gas.png",
			dam = dam,
			power = power,
			check_hit = self:combatAttack(),
			stamina = t.stamina,
			lure_trigger = true,
			unlock_talent_on_disarm = {tid=t.id, chance=100},
			triggered = function(self, x, y, who)
				-- Add a lasting map effect
				game.level.map:addEffect(self,
					x, y, 4,
					engine.DamageType.RANDOM_POISON,
					{dam=self.dam, power=self.power, apply_power=self.check_hit, random_chance=25},
					3,
					5, nil,
					{type="vapour"},
					nil, true
				)
				game:playSoundNear(self, "talents/cloud")
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Releases a radius 3 poison gas cloud, poisoning for %0.2f nature damage over 5 turns with a 25%% for enhanced effects.]]):tformat(damDesc(self, DamageType.POISON, t.getDamage(self, t)))
	end,
	info = function(self, t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a trap that releases a radius 3 cloud of thick poisonous gas lasting 4 turns.
		Each turn, the cloud poisons all within (%0.2f nature damage over 5 turns).   There is a 25%% chance the poison is enhanced with crippling, numbing or insidious effects.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(damDesc(self, DamageType.POISON, t.getDamage(self, t)), instant)
	end,
}

-- unlocked in Daikara or by disarming certain traps ("cold flames trap")
newTalent{
	name = "Freezing Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = function(self, t) return self.player or self.level > 15, "You have learned how to create Freezing traps!" end,
	no_unlearn_last = true,
	cooldown = 12,
	stamina = 12,
	tactical = { ATTACKAREA = { COLD = 1.5 }, ESCAPE = {pin = 1}, CLOSEIN = {pin = 1}},
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	trap_mastery_level = 3,
	allow_primed_trigger = true,
	no_break_stealth = trap_stealth,
	getDamage = function(self, t) return 10 + trap_effectiveness(self, t, "cun")*15 end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, friendlyfire=false} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local dam = self:physicalCrit(t.getDamage(self, t))
		local tg = self:getTalentTarget(t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "cold", name = _t"freezing trap", color=colors.BLUE, image = "trap/trap_freezing.png",
			dam = dam,
			tg = tg,
			power = power,
			check_hit = self:combatAttack(),
			stamina = t.stamina,
			lure_trigger = true,
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local who = game.level.map(px, py, engine.Map.ACTOR)
					if who == self.summoner then return end
					if who and who:canBe("pin") then
						who:setEffect(who.EFF_FROZEN_FEET, 3, {apply_power=self.check_hit})
					end
					engine.DamageType:get(engine.DamageType.COLD).projector(self.summoner, px, py, engine.DamageType.COLD, self.dam)
				end)
				game.level.map:particleEmitter(x, y, 2, "circle", {oversize=1.1, a=255, limit_life=16, grow=true, speed=0, img="ice_nova", radius=2})
				-- Add a lasting map effect
				game.level.map:addEffect(self,
					x, y, 5,
					engine.DamageType.ICE, self.dam/3,
					2,
					5, nil,
					{type="ice_vapour"},
					nil, false, false
				)
				game:playSoundNear(self, "talents/cloud")
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")
		return true
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		return ([[Explodes (radius 2):  Deals %0.2f cold damage and pins for 3 turns.  Area freezes (%0.2f cold damage, 25%% freeze chance) for 5 turns.]]):tformat(dam, dam/3)
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a trap that explodes into a radius 2 cloud of freezing vapour when triggered.  Foes take %0.2f cold damage and are pinned for 3 turns.
		The freezing vapour persists for 5 turns, dealing %0.2f cold damage each turn to foes with a 25%% chance to freeze.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(dam, dam/3, instant)
	end,
}

-- unlocked in Daikara or by disarming "dragon fire trap"
newTalent{
	name = "Dragonsfire Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = function(self, t) return self.player or self.level > 20, "You have learned how to create Dragonsfire traps!" end,
	no_unlearn_last = true,
	cooldown = 15,
	stamina = 15,
	tactical = { ATTACKAREA = {fire = 2}, DISABLE = {stun = 1.5},
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	trap_mastery_level = 5,
	allow_primed_trigger = true,
	getDamage = function(self, t) return 10 + trap_effectiveness(self, t, "cun")*18 end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, friendlyfire=false} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local tg = self:getTalentTarget(t)
		local dam = self:physicalCrit(t.getDamage(self, t))
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "fire", name = _t"dragonsfire trap", color=colors.RED, image = "trap/trap_dragonsfire.png",
			dam = dam,
			tg = tg,
			power = power,
			check_hit = self:combatAttack(),
			stamina = t.stamina,
			lure_trigger = true,
			pressure_trap = true,
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if target == self.summoner then return end
					if target and self:reactionToward(target) < 0 then
						if target:canBe("stun") then
							target:setEffect(target.EFF_BURNING_SHOCK, 3, {src=self, power=self.dam/3, apply_power=self.check_hit})
						else
							target:setEffect(target.EFF_BURNING, 3, {src=self, power=self.dam/3})
						end
					end
				end)
				-- Add a lasting map effect
				game.level.map:addEffect(self,
					x, y, 5,
					engine.DamageType.FIRE, self.dam/2,
					2,
					5, nil,
					{type="inferno"},
					nil, false, false
				)
				game.level.map:particleEmitter(x, y, 2, "fireflash", {radius=2, proj_x=x, proj_y=y, src_x=self.x, src_y=self.y})
				game:playSoundNear(self, "talents/devouringflame")
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[Explodes (radius 2): stuns and combusts for %0.2f fire damage per turn for 3 turns.  Area deflagrates (%0.2f fire damage) for 5 turns.]]):tformat(dam/3, dam/2)
	end,
	info = function(self, t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[Lay a pressure triggered trap that explodes in a radius 2 cloud of searing flames when triggered, stunning foes with the blast (%0.2f fire damage per turn) for 3 turns.
		The deflagration persists in the area for 5 turns, burning foes for %0.2f fire damage each turn.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(dam/3, dam/2, instant)
	end,
}

-- learned only with the Mystical Cunning prodigy
newTalent{
	name = "Gravitic Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	no_unlearn_last = true,
	cooldown = 20,
	stamina = 15,
	tactical = { ATTACKAREA = { temporal = 2 }, CLOSEIN = 1.5, ESCAPE = 1.5},
	is_spell = true,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	message = _t"@Source@ deploys a warped device.",
	getDamage = function(self, t) return 10 + trap_effectiveness(self, t, "mag")*10 end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(self:getTalentLevel(self.T_TRAP_MASTERY), 20/2, 3, 5)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=5} end, -- for AI
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, simple_dir_request=true, _allow_on_target=true}
		local x, y = trapGetGrid(self, t, tg, self.ai_state.tactic == "closein" or self.ai_state.tactic ~= "escape" and rng.chance(2))
		if not (x and y) then return nil end

		local tg = self:getTalentTarget(t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self, t)
		local trap = trapping_CreateTrap(self, t, nil, {
			subtype = "arcane", name = _t"gravitic trap", color=colors.LIGHT_RED, image = "invis.png",
			embed_particles = {{name="wormhole", rad=5, args={image="shockbolt/trap/trap_gravitic", speed=1}}},
			dam = dam,
			check_hit = math.max(self:combatAttack(), self:combatSpellpower()),
			tg = tg,
			stamina = t.stamina,
			dur = dur,
			gravity = dur,
			turns_to_act = 0,
			triggered = function(self, x, y, who)
				if self.turns_to_act <= 0 then self.turns_to_act = math.min(self.dur, self.gravity) end
				return self.turns_to_act > 0
			end,
			energy = {mod=1, value=game.energy_to_act}, -- can activate immediately
			realact = function(self)
				local target
				if self.turns_to_act <= 0 then -- not active
					if self.particles then game.level.map:removeParticleEmitter(self.particles) self.particles = nil end
					if self.gravity >= 2 then -- detect nearby targets
						self:project({type="ball", range=0, friendlyfire=false, radius=1}, self.x, self.y, function(px, py)
							if not target then target = game.level.map(px, py, engine.Map.ACTOR) end
						end)
					end
					if target then
						self.turns_to_act = math.min(self.dur, self.gravity) self.gravity, self.stamina = 0, 0
					else -- recharge gravity level
						self.gravity = self.gravity + 1
						return
					end
				else -- active, count down turns_to_act
					self.gravity = 0
					self.turns_to_act = self.turns_to_act - 1 
				end
				local tgts = {}
				if not self.particles then
					game.logSeen(self, "#LIGHT_STEEL_BLUE#%s distorts time and space!", self:getName())
					local particle = engine.Particles.new("generic_vortex", 5, {radius=5, rm=255, rM=255, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
					if core.shader.allow("distort") then particle:setSub("vortex_distort", 5, {radius=5}) end
					self.particles = game.level.map:addParticleEmitter(particle, self.x, self.y)
				end
				self:project(self.tg, self.x, self.y, function(px, py)
					target = game.level.map(px, py, engine.Map.ACTOR)
					if not target then return end
					if not tgts[target] then
						tgts[target] = true
						local ox, oy = target.x, target.y
						self:setKnown(target, true, ox, oy)
						if self.summoner then self.summoner.__project_source = self end
						engine.DamageType:get(engine.DamageType.TEMPORAL).projector(self.summoner, target.x, target.y, engine.DamageType.TEMPORAL, self.dam)
						if self.summoner then self.summoner.__project_source = nil end
						if self:checkHitOld(self.check_hit, target:combatPhysicalResist()) and target:canBe("knockback") then
							target:pull(self.x, self.y, 1)
							if target.x ~= ox or target.y ~= oy then
								target:logCombat(self, "#LIGHT_STEEL_BLUE##Target# pulls #Source# in!")
								if target.x == self.x and target.y == self.y then -- chance to disarm
									self:disarm(self.x, self.y, target)
								end
							end
						else
							target:logCombat(self, "#LIGHT_STEEL_BLUE##Source# resists the pull of #Target#!")
						end
					end
				end)
				game.level.map:particleEmitter(self.x, self.y, 5, "gravity_spike", {radius=5, allow=core.shader.allow("distort")})
			end,
			removed = function(self, x, y, who)
				if self.particles then game.level.map:removeParticleEmitter(self.particles) end
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Creates a radius 5 gravitic anomaly lasting up to %d turns.  Hostile creatures are dealt %d temporal damgae and pulled in.  Triggers out to range 1.]]):
		tformat(t.getDuration(self,t), damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)))
	end,
	info = function(self, t)
		return ([[Lay a trap that creates a radius 5 gravitic anomaly when triggered by foes approaching within range 1.  Each turn, the anomaly deals %0.2f temporal damage (based on your Magic) to foes while pulling them towards its center (chance increases with your combat accuracy or spell power, whichever is higher).
		Each anomaly lasts %d turns (up to the amount of time since the last anomaly dissipated, based on your Trap Mastery skill).
		The trap may trigger more than once, but requires at least 2 turns to recharge between activations.
This design does not require advanced preparation to use.]]):
		tformat(damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)), t.getDuration(self,t))
	end,
}

-- unlocked by the Assassin Lord in the thieves-tunnels, the lost merchant, or by disarming some alarm traps
newTalent{
	name = "Ambush Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = _t"You have learned how to create Ambush traps!",
	no_unlearn_last = true,
	cooldown = 25,
	stamina = 20,
	range = trap_range,
	speed = trap_speed,
	is_spell = true,
	tactical = { ATTACK = 2, ESCAPE = 1, CLOSEIN = 1},
	no_break_stealth = trap_stealth,
	trap_mastery_level = 5,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(self:getTalentLevel(self.T_TRAP_MASTERY), 25, 3, 7)) end,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local dur = t.getDuration(self,t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "annoy", subtype = "alarm", name = _t"ambush trap", color=colors.BLACK, image = "trap/trap_ambush.png",
			dur = dur,
			unlock_talent_on_disarm = {tid=t.id, chance=20},
			triggered = function(self, x, y, who)
				local nb = 0
				for i = 1, 3 do
					local tx, ty = util.findFreeGrid(x, y, 10, true, {[engine.Map.ACTOR]=true})
					if not tx or not ty then break end
					local m = self.summoner.main_env.summon_assassin(self.summoner, who, self.dur, tx, ty)
					nb = nb + 1
				end
				if nb == 0 then return end
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[3 stealthed rogues attack the target for %d turns.]]):tformat(t.getDuration(self,t))
	end,
	info = function(self, t)
		return ([[Lay a magical trap that summons a trio of shadowy rogues to attack the target.
The rogues receive your damage bonuses and are permanently stealthed.
They disappear after %d turns or when their work is done.]]):
		tformat(t.getDuration(self,t))
	end,
}

-- unlocked by Protector Myssil in Zigur or by disarming certain traps ("anti-magic trap")
newTalent{
	name = "Purging Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = table.merge({ stat={wil=25}}, cuns_req_unlock),
	unlock_talent = function(self, t) return self.player or self.level > 15, "You have learned how to create Purging traps!" end,
	no_unlearn_last = true,
	cooldown = 15,
	stamina = 20,
	tactical = { ATTACK = {
		ARCANE = function(self, t, target)
			return target and (target.mana or 0)/100 + (target.vim or 0)/200 + (target.positive or 0)/400 + (target.negative or 0)/400 or 0
		end},
		DISABLE = function(self, t, target)
			return target and math.min(2, (target:attr("has_arcane_knowledge") or 0)/5)
		end,
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	requires_target = function(self, t) return self.trap_primed == t.id end,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	trap_mastery_level = 4,
	allow_primed_trigger = true,
	is_antimagic = true,
	getNb = function(self, t) return math.floor(self:combatTalentScale(trap_mastery_talent(self, t), 1, 3, "log")) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(trap_mastery_talent(self, t), 2.5, 4.5)) end,
	getDamage = function(self, t) return 25 + self.trap_effectiveness(self, t, "wil")*25 end,
	target = function(self, t) return {type="ball", nowarning=true, range=self:getTalentRange(t), radius=2, nolock=true, simple_dir_request=true, talent=t, selffire=false} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local tg = self:getTalentTarget(t)
		local dam = self:physicalCrit(t.getDamage(self, t))
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "nature", name = _t"purging trap", color=colors.YELLOW, image = "trap/trap_purging.png",
			check_hit = self:combatAttack(),
			lure_trigger = true,
			stamina = t.stamina,
			tg = tg,
			dam = dam,
			dur = dur,
			nb = nb,
			unlock_talent_on_disarm = {tid=t.id, chance=25},
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local who = game.level.map(px, py, engine.Map.ACTOR)
					if who == self.summoner then return end
					if who then
						who:setEffect(who.EFF_SILENCED, self.dur, {apply_power=self.check_hit})
						
						local effs = {}

						-- Go through all spell effects
						for eff_id, p in pairs(who.tmp) do
							local e = who.tempeffect_def[eff_id]
							if e.type == "magical" and e.status == "beneficial" then
								effs[#effs+1] = {"effect", eff_id}
							end
						end
				
						-- Go through all sustained spells
						for tid, act in pairs(who.sustain_talents) do
							if act then
								local talent = who:getTalentFromId(tid)
								if talent.is_spell then effs[#effs+1] = {"talent", tid} end
							end
						end
				
						for i = 1, self.nb do
							if #effs == 0 then break end
							local eff = rng.tableRemove(effs)
				
							who:dispel(eff[2], self.summoner)
						end
					end
					engine.DamageType:get(engine.DamageType.MANABURN).projector(self.summoner, px, py, engine.DamageType.MANABURN, self.dam)
				end)
				game.level.map:particleEmitter(x, y, 2, "acidflash", {radius=2, tx=x, ty=y})
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)

		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")
		
		return true
	end,
	short_info = function(self, t)
		local base = t.getDamage(self,t)
		local mana = base
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		return ([[Radius 2 antimagic: Drains up to %d mana, %d vim, %d positive/negative, deals up to %0.2f arcane damage.  Removes %d magical effects and silences for %d turns.]]):
		tformat(base, base/2, base/4, damDesc(self, DamageType.ARCANE, base), nb, dur)
	end,
	info = function(self, t)
		local base = t.getDamage(self,t)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a trap that releases a burst of antimagic energies (radius 2), draining up to %d mana, %d vim, %d positive and %d negative energies from affected targets, while inflicting up to %0.2f arcane damage based on the resources drained, silencing for %d turns, and removing up to %d beneficial magical effects or sustains.
		The draining effect scales with your Willpower, and you must have 25 Willpower to prepare this trap.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(mana, vim, positive, negative, damDesc(self, DamageType.ARCANE, base), dur, nb, instant)
	end,
}

-- unlocked by disarming certain traps ("fire blast trap", "delayed explosion trap")
newTalent{
	name = "Explosion Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = _t"You have learned how to create Explosion traps!",
	no_unlearn_last = true,
	cooldown = 8,
	stamina = 15,
	requires_target = function(self, t) return self.trap_primed == t.id end,
	trap_mastery_level = 2,
	allow_primed_trigger = true,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	tactical = { ATTACKAREA = { FIRE = 1.5 },
		ESCAPE = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end,
		CLOSEIN = function(self, t) return self.trap_primed ~= t.id and 1 or 0 end },
	getDamage = function(self, t) return 30 + self:trap_effectiveness(t, "cun")*35 end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false} end, -- for AI/instant
	action = function(self, t)
		local x, y = trapGetGrid(self, t, nil)
		if not (x and y) then return nil end

		local tg = self:getTalentTarget(t)
		local dam = t.getDamage(self, t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "elemental", name = _t"explosion trap", color=colors.LIGHT_RED, image = "trap/blast_fire01.png",
			dam = dam,
			stamina = t.stamina,
			lure_trigger = true,
			tg = tg,
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			triggered = function(self, x, y, who)
				self.tg.x, self.tg.y = x, y
				self:project(self.tg, x, y, function(px, py)
					local who = game.level.map(px, py, engine.Map.ACTOR)
					if who == self.summoner then return end
					engine.DamageType:get(engine.DamageType.FIREBURN).projector(self.summoner, px, py, engine.DamageType.FIREBURN, self.dam)
				end)
				game.level.map:particleEmitter(x, y, 2, "fireflash", self.tg)
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)

		if self.trap_primed == t.id then
			print("Using trap instant trigger for ", t.id)
			trap.x, trap.y = x, y
			local known, del = trap:triggered(x, y)
			if del or game.level.map(x, y, Map.TRAP) then return true end
		end
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		return ([[Explodes (radius 2) for %0.2f fire damage over 3 turns.]]):
		tformat(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
	info = function(self, t)
		local instant = self.trap_primed == t.id and _t"\n#YELLOW#Triggers immediately when placed.#LAST#" or ""
		return ([[Lay a simple yet effective trap that explodes in a radius 2 on contact, setting those affected on fire for %0.2f fire damage over 3 turns.
		This trap can use a primed trigger and a high level lure can trigger it.%s]]):
		tformat(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), instant)
	end,
}

-- unlocked in Dreadfell by killing Filio Flightfond or by disarming "giant boulder trap"
newTalent{
	name = "Catapult Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = _t"You have learned how to create Catapult traps!",
	no_unlearn_last = true,
	cooldown = 10,
	stamina = 15,
	tactical = { ESCAPE = { knockback = 1.5 }, CLOSEIN = { knockback = 1 } },
	trap_mastery_level = 3,
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	getDistance = function(self, t) return 1 + math.floor(self:combatTalentScale(self:getTalentLevel(self.T_TRAP_MASTERY), 2, 6)) end,
	resetChance = function(self, t) return self:combatTalentLimit(self:getTalentLevel(self.T_TRAP_MASTERY), 100, 90, 95) end,
	action = function(self, t)
		local defense -- pick offensive or defensive placement randomly or based on ai state
		if self.ai_state.tactic == "escape" then defense = true
		elseif self.ai_state.tactic == "closein" then defense = false
		else defense = rng.chance(2)
		end

		local x, y = trapGetGrid(self, t, nil, defense)
		if not (x and y) then return nil end

		local trap = trapping_CreateTrap(self, t, nil, {
			type = "physical", name = _t"catapult trap", color=colors.LIGHT_UMBER, image = "trap/trap_catapult_01_64.png",
			dist = t.getDistance(self, t),
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			check_hit = self:combatAttack(),
			stamina = t.stamina,
			pressure_trap = true,
			message = false,
			resetChance = t.resetChance(self, t),
			reset = true,
			realact = function(self) self.reset = true end, -- reset each turn
			target_x = self.x, -- by default catapult back towards self (offense)
			target_y = self.y,
			desc = function(self)
				local dir = game.level.map:compassDirection(self.target_x-self.x, self.target_y-self.y)
				dir = dir and (" (%s)"):tformat(dir) or ""
				return ([[Target knocked back up to %d grids%s and dazed.]]):tformat(self.dist, dir)
			end,
			disarm = function(self, x, y, who) -- summoner won't disarm
--game.log("custom disarm for %s at (%s, %s) by %s", self.name, x, y, who:getName())
				if who == self.summoner then return false end
--game.log("non summoner disarm")
				return mod.class.Trap.disarm(self, x, y, who)
			end,
			triggered = function(self, x, y, who)
--				if not self.reset or who == self.summoner then return false, false end
				if not self.reset then return false, false end
				self.reset = false

				-- Try to knockback!
				local kb_test = function(target)
					if target:checkHit(self.check_hit, target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
						return true
					end
				end

				if kb_test(who) then
					game.logSeen(who, "%s knocks %s back!", self:getName():capitalize(), who:getName():capitalize())
					who:pull(self.target_x, self.target_y, self.dist, kb_test)
					if who:canBe("stun") then who:setEffect(who.EFF_DAZED, 5, {}) end
				else
					game.logSeen(who, "%s fails to knock %s back!", self:getName():capitalize(), who:getName():capitalize())
				end
				return true, not rng.percent(self.resetChance)
			end,
		})
		trap.faction = nil -- triggers for all targets (including the user)
		trap:identify(self.player)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		if self.player then -- get catapult target grid from player
			game.logPlayer(self, "#LIGHT_BLUE#Aim the catapult")
			local tx, ty = self:getTarget({type="hit", nowarning=true, range=t.getDistance(self, t), nolock=true, simple_dir_request=true, talent=t, start_x=x, start_y=y})
			trap.target_x, trap.target_y = tx or x, ty or y
		else -- npc selects target
			-- update spring target coords based on ai_state (default away from summoner (when placed)
			if defense then -- push away from summoner instead of push towards
				local dx, dy = x-self.x, y-self.y
				if dx ~= 0 or dy ~= 0 then
					local tar_dist = (dx*dx+dy*dy)^.5
					trap.target_x, trap.target_y = math.round(x + dx*trap.dist/tar_dist), math.round(y + dy*trap.dist/tar_dist)
				else -- pick random adjacent grid
					trap.target_x, trap.target_y = x, y
					local adj_coords = util.adjacentCoords(x, y)
					while #adj_coords > 0 do
						local grid = rng.tableRemove(adj_coords)
						if grid and not game.level.map:checkEntity(grid[1], grid[2], engine.Map.TERRAIN, "block_move") then
							trap.target_x, trap.target_y = grid[1], grid[2] break
						end
					end
				end
			end
		end
		return true
	end,
	short_info = function(self, t)
		return ([[Target knocked back %d grids and dazed.]]):
		tformat(t.getDistance(self, t))
	end,
	info = function(self, t)
		return ([[Deploy a hidden spring-loaded catapult that will trigger (by pressure) for any creature passing over it.  Victims will be knocked back towards a target location up to %d grids away and be dazed for 5 turns.
		This trap has a %d%% chance to reset itself after triggering, but can only trigger once per turn.
		The chance to affect the target improves with your combat accuracy.]]):
		tformat(t.getDistance(self, t), t.resetChance(self, t))
	end,
}

-- unlocked by disarming certain traps ("poison vine")
newTalent{
	name = "Nightshade Trap",
	type = {"cunning/traps", 1},
	points = 1,
	type_no_req = true,
	require = cuns_req_unlock,
	unlock_talent = _t"You have learned how to create Nightshade traps!",
	no_unlearn_last = true,
	trap_mastery_level = 4,
	cooldown = 8,
	stamina = 15,
	tactical = { ATTACK = {NATURE = 2}, DISABLE = { stun = 1.5 }, ESCAPE = 1, CLOSEIN = 1 },
	range = trap_range,
	speed = trap_speed,
	no_break_stealth = trap_stealth,
	getDamage = function(self, t) return 20 + trap_effectiveness(self, t, "cun")*35 end,
	action = function(self, t)
		local x, y = trapGetGrid(self, t)
		if not (x and y) then return nil end

		local dam = t.getDamage(self, t)
		local trap = trapping_CreateTrap(self, t, nil, {
			type = "nature", name = _t"nightshade trap", color=colors.LIGHT_BLUE, image = "trap/poison_vines01.png",
			dam = dam,
			stamina = t.stamina,
			check_hit = self:combatAttack(),
			unlock_talent_on_disarm = {tid=t.id, chance=50},
			triggered = function(self, x, y, who)
				self:project({type="hit", x=x,y=y}, x, y, engine.DamageType.NATURE, self.dam, {type="slime"})
				if who:canBe("stun") then
					who:setEffect(who.EFF_STUNNED, 4, {src=self.summoner, apply_power=self.check_hit})
				end
				if who:canBe("poison") then
					who:setEffect(who.EFF_POISONED, 4, {src=self.summoner, apply_power=self.check_hit, power=self.dam/10})
				end
				return true, true
			end,
		})
		trap:identify(true)

		trap:resolve() trap:resolve(nil, true)
		trap:setKnown(self, true)
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[Deals %0.1f nature damage, stuns and poisons for %0.1f nature/turn for 4 turns.]]):
		tformat(dam, dam/10)
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[Lay a trap armed with potent venom.  A creature passing over it will be dealt %0.2f nature damage and be stunned and poisoned for %0.2f nature damage per turn for 4 turns.]]):
		tformat(dam, dam/10)
	end,
}

-- set up traps data
traps_initialize()
trap_init = false -- force re-initialization again in case additional trap talents are loaded with addons
