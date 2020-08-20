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

require "engine.class"
require "engine.Trap"
require "engine.interface.ActorProject"
require "engine.interface.ObjectIdentify"
require "mod.class.interface.Combat"
local Faction = require "engine.Faction"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.inherit(
	engine.Trap,
	engine.interface.ObjectIdentify,
	engine.interface.ActorProject,
	mod.class.interface.Combat
))

_M.projectile_class = "mod.class.Projectile"

function _M:init(t, no_default)
	self.faction = "enemies"
	engine.Trap.init(self, t, no_default)
	engine.interface.ObjectIdentify.init(self, t)
	engine.interface.ActorProject.init(self, t)
	self.str = self.str or 10
	self.mag = self.mag or 10
	self.dex = self.dex or 10
	self.wil = self.wil or 10
end

function _M:altered(t)
	if t then for k, v in pairs(t) do self[k] = v end end
	self.__SAVEINSTEAD = nil
	self.__nice_tile_base = nil
	self.nice_tiler = nil
end

function _M:combatPhysicalpower() return mod.class.interface.Combat:rescaleCombatStats(self.str) end
function _M:combatSpellpower() return mod.class.interface.Combat:rescaleCombatStats(self.mag) end
function _M:combatMindpower() return mod.class.interface.Combat:rescaleCombatStats(self.wil) end
function _M:combatAttack() return mod.class.interface.Combat:rescaleCombatStats(self.dex) end

function _M:resolveSource()
	if self.summoner_gain_exp and self.summoner then
		return self.summoner:resolveSource()
	else
		return self
	end
end

--- Percent chance for the trap to automatically fail to trigger
_M.trigger_fail = 5

--- Called when the trap is added to the level
function _M:added()
	engine.Entity.added(self)
	if self.x and self.y then --give adjacent actors a chance to detect the trap when it is placed
		local grids = core.fov.circle_grids(self.x, self.y, 1, true)
		local act
		for x, yy in pairs(grids) do for y, _ in pairs(yy) do
			act = game.level.map(x, y, engine.Map.ACTOR)
			if act and not self:knownBy(act) then
				act:detectTrap(self, self.x, self.y)
			end
		end end
	end
end

-- Gets the full name of the trap
function _M:getName()
	local name = _t(self.name) or _t"trap"
	if not self:isIdentified() and self:getUnidentifiedName() then name = self:getUnidentifiedName() end
	if self.summoner and self.summoner.name then
		return ("%s's %s"):tformat(self.summoner:getName():capitalize(), name)
	else
		return name
	end
end

--- Set the known status for the given actor and make its tile remembered on the map (for the player)
-- The player (only) has a chance (improved with Trap Mastery talent) to identify the trap
function _M:setKnown(actor, v, x, y)
	self.known_by[actor] = v
	if x and y and v and actor.player and not self:isIdentified() and game.level.map(x, y, engine.Map.TRAP) == self then
		game.level.map(x, y, engine.Map.TERRAIN).always_remember = true
		if core.fov.distance(x, y, actor.x, actor.y) <= 1 then
			if actor:checkHitOld(actor:callTalent(actor.T_TRAP_MASTERY, "getPower") + 5, self.disarm_power) then
				self:identify(true) 
			end
		end
	end
end

--- Returns a tooltip for the trap
-- requires the trap be known to player, full info only if identified
function _M:tooltip()
	if self:knownBy(game.player) then
		local res = tstring{{"uid", self.uid}, self:getName(), true}
		local id = self:isIdentified()
		if self.temporary then res:add(("#LIGHT_GREEN#%d turns #WHITE#"):tformat(self.temporary)) end
		if self.is_store then
			res:add(true, {"font","italic"}, _t"<Store>", {"font","normal"})
			if self.store_faction then
				local factcolor, factstate, factlevel = "#ANTIQUE_WHITE#", _t"neutral", Faction:factionReaction(self.store_faction, game.player.faction)
				if factlevel < 0 then factcolor, factstate = "#LIGHT_RED#", _t"hostile"
				elseif factlevel > 0 then factcolor, factstate = "#LIGHT_GREEN#", _t"friendly"
				end
				if Faction.factions[self.store_faction] then res:add(true, _t"Faction: ") res:merge(factcolor:toTString()) res:add(("%s (%s, %d)"):format(Faction.factions[self.store_faction].name, factstate, factlevel), {"color", "WHITE"}, true) end
			end
		else
			if id then
				if self.faction then
					if self.beneficial_trap then 
						if self:reactionToward(game.player) >= 0 then
							res:add({"color", "LIGHT_GREEN"}, _t"(beneficial)", {"color", "WHITE"})
						else
							res:add({"color", "ORANGE"}, _t"(beneficial to enemies)", {"color", "WHITE"})
						end
					elseif self:reactionToward(game.player) >= 0 then
						res:add({"color", "LIGHT_GREEN"}, _t"(safe)", {"color", "WHITE"})
					end
				end
				if self.pressure_trap then
					res:add(true, {"color", "GREEN"}, _t"pressure_trigger", {"color", "WHITE"})
				end
				local desc = util.getval(self.desc, self)
				if desc then res:add(true, desc) end
			end
			res:add(true, ("#YELLOW#Detect: %d#WHITE#"):tformat(self.detect_power))
			if id or config.settings.cheat then
				res:add(("#YELLOW# Disarm: %d#WHITE#"):tformat(self.disarm_power))
			end
		end
		if config.settings.cheat then res:add(true, "UID: "..self.uid, true) end
		return res
	end
end

--- What is our reaction toward the target
-- See Faction:factionReaction()
function _M:reactionToward(target)
	return Faction:factionReaction(self.faction, target.faction)
end

--- Can we disarm this trap?
function _M:canDisarm(x, y, who)
	if not engine.Trap.canDisarm(self, x, y, who) then return false end

	-- do we know how to disarm?
	if (who:getTalentLevel(who.T_DEVICE_MASTERY) > 0) or who:attr("can_disarm") then
		local power = who:callTalent(who.T_DEVICE_MASTERY, "trapDisarm")
		if who:checkHitOld(power, self.disarm_power) and (not self.faction or who:reactionToward(self) < 0) then
			return true
		end
	end
	-- False by default
	return false
end

--- Try to disarm the trap
function _M:disarm(x, y, who)
	-- don't disarm "friendly" traps
	if self.faction and who.reactionToward and who:reactionToward(self) >= 0 then return false end
	if core.fov.distance(x, y, who.x, who.y) <= 1 then self:setKnown(who, true, x, y) end
	return engine.Trap.disarm(self, x, y, who)
end

-- Could make disarming a trap use energy here... (ask the player)

--- Called when disarmed
-- Player may unlock a trap talent if self.unlock_talent_on_disarm is defined
function _M:onDisarm(x, y, who)
	self:check("disarmed", x, y, who)
	--table.set(game, "debug", "last_trap_disarmed", self) -- debugging
	-- The player may unlock a trap talent when disarming a (similar) trap (uses Trap Mastery)
	if self.unlock_talent_on_disarm and who.player and who:knowTalent(who.T_TRAP_MASTERY) and core.fov.distance(x, y, who.x, who.y) <= 1 and not game.state:unlockTalentCheck(self.unlock_talent_on_disarm.tid, who) then
		local hit, chance = who:checkHit(who:callTalent(who.T_TRAP_MASTERY, "getPower") + who:callTalent(who.T_DEVICE_MASTERY, "trapDisarm")*.25, self.disarm_power)
		local t = who:getTalentFromId(self.unlock_talent_on_disarm.tid)
		if t and hit and chance > 20 and (not self.unlock_talent_on_disarm.chance or rng.percent(self.unlock_talent_on_disarm.chance)) and next(who:spotHostiles()) == nil then
			local diff_level = (t.trap_mastery_level or 5)
			local success, consec, msg = false, 0
			local oldrestCheck = rawget(who, "restCheck") -- hack restCheck to perform action each turn
			local turns = math.ceil(diff_level*(1 + rng.float(1, 6*(1-chance/200)))) -- random turns to dismantle
			local dismantle = coroutine.create(function(self, who)
				local wait = function()
					local co = coroutine.running()
					who:restInit(turns, _t"Dismantling", _t"dismantled", function(cnt, max)
						-- "resting" finished, undo the restCheck hack and check results
						who.restCheck = oldrestCheck
						if not success then
							if cnt >= max then -- too difficult
								msg = _t"Your level of skill was not enough to understand the workings of this trap."
							else -- interrupted
								msg = msg or _t"You quit dismantling the trap."
							end
						end
						coroutine.resume(co)
					end)
					coroutine.yield()
					game.logPlayer(who, "#LIGHT_BLUE#%s: %s#LAST#", success and _t"Success" or _t"Failure", msg)
					return success
				end
				if not wait() then
					return 
				end
				game.state:unlockTalent(self.unlock_talent_on_disarm.tid, who)
			end)
			self:identify(true)
			local desc = util.getval(self.desc, self)
			desc = desc and _t"\n#LIGHT_BLUE#Trap Description:#WHITE#\n"..desc or ""
			require "engine.ui.Dialog":yesnoLongPopup(("Disarming a trap: %s"):tformat(self:getName()),
	([[As you begin disarming the trap, you think you may be able to learn how it works by carefully dismantling it.  You estimate this will take up to #YELLOW#%d#LAST# uninterrupted turns.
	What do you want to do?
%s
]]):tformat(turns, desc), math.min(800, game.w*.75),
			function(quit)
				if quit == true then
					who.restCheck = function(player)
						if not player.resting then player.restCheck = oldrestCheck return false, _t"not resting" end
						if player.resting.cnt >= diff_level then -- start making checks at diff_level turns
							if rng.percent(chance) then
								consec = consec + 1
							else -- reset success count
								consec = 0
								if rng.percent(10) then -- oops! 10% chance to set it off
									game:onTickEnd(function() self:triggered(player.x, player.y, player) end)
									msg = _t"You set off the trap!"
									return false, msg
								end
							end
						end
						if consec >= diff_level then -- success after diff_level consecutive checks
							msg = _t"You successfully dismantled the trap."
							success = true return false, msg
						end
						local continue, reason = mod.class.Player.restCheck(player)
						if not continue then msg = _t"You were interrupted." end
						return continue, reason
					end
					game:playSoundNear(who, "ambient/town/town_large2")
					coroutine.resume(dismantle, self, who)
				end
			end,
			_t"Dismantle Carefully", _t"Disarm Normally")
		end
	end
end

--- Called when triggered
function _M:canTrigger(x, y, who, no_random)
	if self.faction and who.reactionToward and who:reactionToward(self) >= 0 then return self.beneficial_trap end

	local avoid
	if who:attr("avoid_traps") then
		avoid = _t"ignore"
	elseif self.pressure_trap and (who:attr("levitation") or who:attr("avoid_pressure_traps")) then
		avoid = _t"simply ignore"
	elseif not no_random and who.trap_avoidance and rng.percent(who.trap_avoidance) then
		avoid = _t"carefully avoid"
	elseif not self.beneficial_trap and rng.percent(self.trigger_fail) then
		avoid = _t"somehow avoid"
	elseif who:attr("walk_sun_path") and game.level then
		for i, e in ipairs(game.level.map.effects) do if e.damtype == DamageType.SUN_PATH and e.grids[x] and e.grids[x][y] then	avoid = _t"dodge" break end
		end
	end
	
	if avoid then
		if self.x == who.x and self.y == who.y and game.level.map.seens(x, y) then
			local known_player = self:knownBy(game.player)
			if who.player then
				if known_player then game.log("#CADET_BLUE#You %s a trap (%s).", avoid, self:getName()) end
			else
				game.logSeen(who, "#CADET_BLUE#%s %ss %s.", who:getName():capitalize(), avoid, known_player and ("a trap (%s)"):tformat(self:getName()) or _t"something on the floor")
			end
		end
		return false
	end

	return true
end

--- Trigger the trap
function _M:trigger(x, y, who)
	engine.Trap.trigger(self, x, y, who)
	if who.player then self:identify(true) end
	if who.runStop and self:canTrigger(x, y, who) then who:runStop(_t"trap") end
end

--- Identify the trap (controls info displayed for the player)
function _M:identify(id)
	self.identified = id
end
