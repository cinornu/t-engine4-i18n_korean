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

local tacticals = {}
local Entity = require "engine.Entity"
local Tiles = require "engine.Tiles"
local Astar = require "engine.Astar"

---convert TACTIC labels in talent tactical tables to lower case
function Talents.aiLowerTacticals(tactical)
	if type(tactical) ~= "table" then return tactical end
	local tacts = {}
	for tact, val in pairs(tactical) do
		tact = tact:lower()
		tacts[tact] = val
		if tact == "self" then
			tacts[tact]=Talents.aiLowerTacticals(val)
		else
			tacticals[tact] = true
		end
	end
	return tacts
end

local oldNewTalent = Talents.newTalent
Talents.newTalent = function(self, t)
	local tt = engine.interface.ActorTalents.talents_types_def[t.type[1]]
	assert(tt, "No talent category "..tostring(t.type[1]).." for talent "..t.name)
	if tt.generic then t.generic = true end
	if tt.no_silence then t.no_silence = true end
	if tt.is_spell then t.is_spell = true end
	if tt.is_mind then t.is_mind = true end
	if tt.is_nature then t.is_nature = true end
	if tt.is_antimagic then t.is_antimagic = true end
	if tt.is_unarmed then t.is_unarmed = true end
	if tt.is_necromancy then t.is_necromancy = true end
	if tt.autolearn_mindslayer then t.autolearn_mindslayer = true end
	if tt.speed and not t.speed then t.speed = tt.speed end
	if t.tactical then t.tactical = Talents.aiLowerTacticals(t.tactical) end
	if t.tactical_imp then t.tactical_imp = Talents.aiLowerTacticals(t.tactical_imp) end -- DEBUGGING transitional

	if not t.image then
		t.image = "talents/"..(t.short_name or t.name):lower():gsub("[^a-z0-9_]", "_")..".png"
	end
	if fs.exists(Tiles.baseImageFile(t.image)) then t.display_entity = Entity.new{image=t.image, is_talent=true}
	else t.display_entity = Entity.new{image="talents/default.png", is_talent=true}
	end

	if t.is_class_evolution then
		t.short_name = (t.short_name or t.name):upper():gsub("[ ']", "_")
		t.name = ("#LIGHT_STEEL_BLUE#%s (Class Evolution)"):tformat(_t(t.name))
	end
	if t.is_race_evolution then
		t.short_name = (t.short_name or t.name):upper():gsub("[ ']", "_")
		t.name = ("#SANDY_BROWN#%s (Race Evolution)"):tformat(_t(t.name))
	end

	-- Generate easier, reverse parameters, calls for methods
	for k, e in pairsclone(t) do if type(e) == "function" and type(k) == "string" then
		t["_"..k] = function(t, self, ...) return e(self, t, ...) end
	end end

	return oldNewTalent(self, t)
end

damDesc = function(self, type, dam)
	if self:attr("dazed") then
		dam = dam * 0.5
	end
	if self:attr("stunned") then
		dam = dam * 0.5
	end
	if self:attr("invisible_damage_penalty") then
		dam = dam * util.bound(1 - (self.invisible_damage_penalty / (self.invisible_damage_penalty_divisor or 1)), 0, 1)
	end
	if self:attr("numbed") then
		dam = dam - dam * self:attr("numbed") / 100
	end
	if self:attr("generic_damage_penalty") then
		dam = dam - dam * math.min(100, self:attr("generic_damage_penalty")) / 100
	end

	-- Increases damage
	if self.inc_damage then
		if _G.type(type) == "string" then
			local dt = DamageType:get(type)
			if dt.damdesc_split then
				if _G.type(dt.damdesc_split) == "function" then
					type = dt.damdesc_split(self, type, dam)
				else
					type = dt.damdesc_split
				end
			end
		end

		if _G.type(type) == "table" then
			local basedam = dam
			for _, ds in ipairs(type) do
				local inc = self:combatGetDamageIncrease(ds[1])
				dam = dam + (basedam * inc / 100) * ds[2]
			end
		else
			local inc = self:combatGetDamageIncrease(type)
			dam = dam + (dam * inc / 100)
		end
	end
	return dam
end

Talents.is_a_type = {
	is_spell = _t"a spell",
	is_mind = _t"a mind power",
	is_nature = _t"a nature gift",
	is_antimagic = _t"an antimagic ability",
	is_summon = _t"a summon power",
	is_necromancy = _t"necromancy",
	use_only_arcane = _t"usable during Aether Avatar",
}

Talents.damDesc = damDesc
Talents.main_env = getfenv(1)
Talents.ai_tactics_list = tacticals

-- Summoning AI helper functions

--- Generate targeting parameters for summoning talents
-- Only used by the (tactical) AI to test tactical parameters vs. aitarget when evaluating talents
function SummonTarget(self, t)
	return {type="bolt", nowarning=true, pass_terrain = true, friendlyblock=false, nolock=true, talent=t}
end

-- returns grid coords in which to place a summon (if self.__talent_running is set, i.e. t.action is being executed)
-- or the exact coordinates of an NPC's target
-- allows the (tactical) AI to test the talent against aitarget properly
function onAIGetTargetSummon(self, t)
	local aitarget = self.ai_target.actor
	if aitarget and self:reactionToward(aitarget) < 0 then
		if self.__talent_running then -- get coords in which to place the summon
--print("[onAIGetTargetSummon] placing summon", t.id) -- debugging
			return t.aiSummonGrid(self, t)
		else -- getting aitarget info
--print("[onAIGetTargetSummon] getting aitarget info", t.id) -- debugging
			return aitarget.x, aitarget.y, aitarget
		end
	end
end

--- find a path between summoner and target (limit to range 25, effective)
function summonPath(self)
	local aitarget = self.ai_target.actor
	self.turn_procs.summoning = self.turn_procs.summoning or {}
	if aitarget and self:reactionToward(aitarget) < 0 and core.fov.distance(self.x, self.y, aitarget.x, aitarget.y) <= 25 then
		if config.settings.log_detail_ai > 1 then print(("[summonPath] calculating new summoning path [%d]%s at (%s, %s) to [%d]%s at (%s, %s)"):format( self.uid, self.name, self.x, self.y, aitarget.uid, aitarget.name, aitarget.x, aitarget.y)) end
		local tx, ty = self:aiSeeTargetPos(aitarget)
		local ast = Astar.new(game.level.map, self)
		local path = ast:calc(tx, ty, self.x, self.y, nil, nil,
			function(gx, gy) -- path around other actors
				if gx == self.x and gy == self.y then return true end
				return not game.level.map(gx, gy, engine.Map.ACTOR)
			end
		)
		if path then
			local range = 10
			path[0] = {x=tx, y=ty} -- place origin
			local stoptgtLOS, stopselfLOS = false, false
			for i = 0, #path do
				local node = path[i]
				if not stoptgtLOS then 
					node.tgtLOS = self:hasLOS(node.x, node.y, "block_move", range, tx, ty)
					if node.tgtLOS then path.nearTgtLOS = i else stoptgtLOS = true end
				end
				if not stopselfLOS then 
					node.selfLOS = self:hasLOS(node.x, node.y, "block_move", range)
					if node.selfLOS and not path.farSelfLOS then path.farSelfLOS = i stopselfLOS = true end
				end
			end
			self.turn_procs.summoning.path = path
--print("new summoning path:") table.print(path)
			return path
		else
			self.turn_procs.summoning.path = false
		end
	else
		self.turn_procs.summoning.path = false
	end
	if aitarget and config.settings.log_detail_ai > 1 and self.turn_procs.summoning.path == false then print(("[summonPath] no summoning path [%d]%s at (%s, %s) to [%d]%s at (%s, %s)"):format(self.uid, self.name, self.x, self.y, aitarget.uid, aitarget.name, aitarget.x, aitarget.y)) end
	return self.turn_procs.summoning.path
end

-- find a reasonable spot for a MELEE summon to be placed
-- attempts to place the summon adjacent to the target
-- returns x, y coordinates or false if no spot can be found
function aiSummonGridMelee(self, t)
	if self.turn_procs.summoning and self.turn_procs.summoning[t.id] then return self.turn_procs.summoning[t.id][1], self.turn_procs.summoning[t.id][2] end
	local path = self.turn_procs.summoning and self.turn_procs.summoning.path
	if path == nil then path = summonPath(self) end
--print("[aiSummonGridMelee] path:", path) table.print(path)
	if path then
		local range, max_dist = self:getTalentRange(t), 1
		local node = math.max(path.farSelfLOS, #path - range)
		if config.settings.log_detail_ai > 2 then print(("[aiSummonGridMelee] found melee summon node %d at (%d, %d) max_dist=%s"):format(node, path[node].x, path[node].y, max_dist)) end
		if node > max_dist then return false end
		local tg = self:getTalentTarget(t) or {type="bolt", nowarning=true, nolock=true, talent=t}
		tg.range, pass_terrain = range, false
		local ok, nx, ny
		ok, ok, ok, nx, ny = self:canProject(tg, path[node].x, path[node].y)
--print("Projection result:", ok, nx, ny)
		local x, y = util.findFreeGrid(nx, ny, 1, true, {[Map.ACTOR]=true})
		if config.settings.log_detail_ai > 1 then print("[aiSummonGridMelee] Find Free Grid result:", x, y) end
		if not (x and y) or core.fov.distance(path[0].x, path[0].y, x, y) > max_dist then return false end
		self.turn_procs.summoning[t.id] = {nx, ny}
		return nx, ny
	end
	return false
end

-- find a reasonable spot for a RANGED summon to be placed
-- attempts to place the summon within or close to LOS of the target but slightly off axis so it doesn't block the summoner's attacks
-- returns x, y coordinates or false if no spot can be found
function aiSummonGridRanged(self, t)
	if self.turn_procs.summoning and self.turn_procs.summoning[t.id] then return self.turn_procs.summoning[t.id][1], self.turn_procs.summoning[t.id][2] end
	local path = self.turn_procs.summoning and self.turn_procs.summoning.path
	if path == nil then path = summonPath(self) end
	if path then
		local range, max_dist = self:getTalentRange(t), math.min(5, t.on_arrival and self:isTalentActive(self.T_MASTER_SUMMONER) and self:knowTalent(self.T_GRAND_ARRIVAL) and self:callTalent(self.T_GRAND_ARRIVAL, "radius") or 5)
		local node = math.max(path.farSelfLOS, #path - range) -- closest possible node to target
		if node > max_dist then return false end
		node = math.min(max_dist, math.max(path.nearTgtLOS, path.farSelfLOS))
		local nx, ny = path[node].x, path[node].y
		local tgtDir = util.getDir(path[0].x, path[0].y, self.x, self.y)
		if config.settings.log_detail_ai > 2 then print(("[aiSummonGridRanged] found ranged summon node %d at (%d, %d), dir=%s"):format(node, nx, ny, tgtDir)) end
		-- if possible place the summon to the side of the LOS path to the target
		local sides=util.dirSides(tgtDir, self.x, self.y)
		local allow_grids = {}, sx, sy
		local tg = self:getTalentTarget(t) or {type="bolt", nowarning=true, nolock=true, talent=t}
		tg.range = range
		for s, dir in pairs(sides) do
			sx, sy = util.dirToCoord(dir, nx, ny)
			sx, sy = sx + nx, sy + ny
			if not game.level.map:checkAllEntities(sx, sy, "block_move") and self:hasLOS(sx, sy, "block_move", max_dist, path[0].x, path[0].y) and self:canProject(tg, sx, sy) then
				allow_grids[#allow_grids+1] = {sx, sy}
			end
		end
--table.print(allow_grids, "_ag_")
		local grid = rng.table(allow_grids)
		if grid then nx, ny = grid[1], grid[2] end
		self.turn_procs.summoning[t.id] = {nx, ny}
		if config.settings.log_detail_ai > 1 then print(("[aiSummonGridRanged] picked summon grid at (%d, %d)"):format(nx, ny)) end
		return nx, ny
	end
	return false
end

-- Checks that there is a reasonable spot to place a summon
function aiSummonPreUse(self, t, silent, fake)
	if self.ai_target.actor and self:reactionToward(self.ai_target.actor) < 0 then
		if not self.ai_state.target_last_seen or game.turn - (self.ai_state.target_last_seen.GCknown_turn or 0) <=50 then
			return t.aiSummonGrid(self, t)
		end
	end
end

-- Archery range talents
Talents.main_env.archery_range = require("mod.class.interface.Archery").archery_range

load("/data/talents/misc/misc.lua")
load("/data/talents/techniques/techniques.lua")
load("/data/talents/cunning/cunning.lua")
load("/data/talents/spells/spells.lua")
load("/data/talents/gifts/gifts.lua")
load("/data/talents/celestial/celestial.lua")
load("/data/talents/corruptions/corruptions.lua")
load("/data/talents/undeads/undeads.lua")
load("/data/talents/cursed/cursed.lua")
load("/data/talents/chronomancy/chronomancer.lua")
load("/data/talents/psionic/psionic.lua")
load("/data/talents/uber/uber.lua")

