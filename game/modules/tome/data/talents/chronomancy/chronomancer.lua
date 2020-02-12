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

-- Class Trees
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/blade-threading", name = _t"Blade Threading", description = _t"A blend of chronomancy and dual-weapon combat." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/bow-threading", name = _t"Bow Threading", description = _t"A blend of chronomancy and ranged combat." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/temporal-combat", name = _t"Temporal Combat", description = _t"A blend of chronomancy and physical combat." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/guardian", name = _t"Temporal Guardian", description = _t"Warden combat training and techniques." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/threaded-combat", name = _t"Threaded Combat", min_lev = 10, description = _t"A blend of ranged and dual-weapon combat." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/temporal-hounds", name = _t"Temporal Hounds", min_lev = 10, description = _t"Call temporal hounds to aid you in combat." }

newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/flux", name = _t"flux", description = _t"Fluctuate spacetime." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/gravity", name = _t"gravity", description = _t"Call upon the force of gravity to crush, push, and pull your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/matter", name = _t"matter", description = _t"Change and shape matter itself." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/spacetime-folding", name = _t"Spacetime Folding", description = _t"Mastery of folding points in space." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/speed-control", name = _t"Speed Control", description = _t"Control how fast objects and creatures move through spacetime." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/stasis", name = _t"stasis", description = _t"Stabilize spacetime." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/timeline-threading", name = _t"Timeline Threading", min_lev = 10, description = _t"Examine and alter the timelines that make up the spacetime continuum." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/timetravel", name = _t"timetravel", description = _t"Directly manipulate the flow of time" }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/spellbinding", name = _t"Spellbinding", min_lev = 10, description = _t"Manipulate chronomantic spells." }

-- Generic Chronomancy
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/chronomancy", name = _t"Chronomancy", generic = true, description = _t"Allows you to glimpse the future, or become more aware of the present." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/energy", name = _t"energy", generic = true, description = _t"Manipulate raw energy by addition or subtraction." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/fate-weaving", name = _t"Fate Weaving", generic = true, description = _t"Weave the threads of fate." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/spacetime-weaving", name = _t"Spacetime Weaving", generic = true, description = _t"Weave the threads of spacetime." }

-- Misc and Outdated Trees
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/manifold", name = _t"Manifold", generic = true, description = _t"Passive effects that Weapon Folding can trigger." }
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/other", name = _t"Other", generic = true, description = _t"Miscellaneous Chronomancy effects." }

newTalentType{ no_silence=true, is_spell=true, type="chronomancy/age-manipulation", name = _t"Age Manipulation", description = _t"Manipulate the age of creatures you encounter." }
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/temporal-archery", name = _t"Temporal Archery", description = _t"A blend of chronomancy and ranged combat." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="chronomancy/paradox", name = _t"paradox", description = _t"Break the laws of spacetime." }

-- Anomalies are not learnable but can occur instead of an intended spell when paradox gets to high.
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/anomalies", name = _t"anomalies", description = _t"Spacetime anomalies that can randomly occur when paradox is to high." }

-- Generic requires for chronomancy spells based on talent level
chrono_req1 = {
	stat = { mag=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
chrono_req2 = {
	stat = { mag=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
chrono_req3 = {
	stat = { mag=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
chrono_req4 = {
	stat = { mag=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
chrono_req5 = {
	stat = { mag=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

chrono_req_high1 = {
	stat = { mag=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
chrono_req_high2 = {
	stat = { mag=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
chrono_req_high3 = {
	stat = { mag=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
chrono_req_high4 = {
	stat = { mag=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
chrono_req_high5 = {
	stat = { mag=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}

-- Generic requires for non-spell temporal effects based on talent level
temporal_req1 = {
	stat = { wil=function(level) return 12 + (level-1)*2 end},
	level = function(level) return 0 + (level-1) end,
}
temporal_req2 = {
	stat = { wil=function(level) return 20 + (level-1)*2 end},
	level = function(level) return 4 + (level-1) end,
}
temporal_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
temporal_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
temporal_req5 = {
	stat = { wil=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

load("/data/talents/chronomancy/age-manipulation.lua")
load("/data/talents/chronomancy/blade-threading.lua")
load("/data/talents/chronomancy/bow-threading.lua")
load("/data/talents/chronomancy/chronomancy.lua")
load("/data/talents/chronomancy/energy.lua")
load("/data/talents/chronomancy/fate-weaving.lua")
load("/data/talents/chronomancy/flux.lua")
load("/data/talents/chronomancy/gravity.lua")
load("/data/talents/chronomancy/guardian.lua")
load("/data/talents/chronomancy/matter.lua")
load("/data/talents/chronomancy/paradox.lua")
load("/data/talents/chronomancy/spacetime-folding.lua")
load("/data/talents/chronomancy/spacetime-weaving.lua")
load("/data/talents/chronomancy/speed-control.lua")
load("/data/talents/chronomancy/spellbinding.lua")
load("/data/talents/chronomancy/stasis.lua")
load("/data/talents/chronomancy/temporal-archery.lua")
load("/data/talents/chronomancy/temporal-combat.lua")
load("/data/talents/chronomancy/temporal-hounds.lua")
load("/data/talents/chronomancy/threaded-combat.lua")
load("/data/talents/chronomancy/timeline-threading.lua")
load("/data/talents/chronomancy/timetravel.lua")

-- Loads many functions and misc. talents
load("/data/talents/chronomancy/other.lua")

-- Anomalies, not learnable talents that may be cast instead of the intended spell when paradox gets to high
load("/data/talents/chronomancy/anomalies.lua")

-- Paradox Functions

-- Paradox modifier.  This dictates paradox cost and spellpower scaling
-- Note that 300 is the optimal balance
-- Caps at -50% and +50%
getParadoxModifier = function (self)
	local paradox = self:getParadox()
	local pm = math.sqrt(paradox / 300)
	if paradox < 300 then pm = paradox/300 end
	pm = util.bound(pm, 0.5, 1.5)
	return pm
end

-- Paradox cost (regulates the cost of paradox talents)
getParadoxCost = function (self, t, value)
	local pm = getParadoxModifier(self)
	local multi = 1
	if self:attr("paradox_cost_multiplier") then
		multi = 1 - self:attr("paradox_cost_multiplier")
	end
	return (value * pm) * multi
end

-- Paradox Spellpower (regulates spellpower for chronomancy)
getParadoxSpellpower = function(self, t, mod, add)
	local pm = getParadoxModifier(self)
	local mod = mod or 1

	-- Empower?
	local p = self:isTalentActive(self.T_EMPOWER)
	if p and p.talent == t.id then
		pm = pm + self:callTalent(self.T_EMPOWER, "getPower")
	end

	local spellpower = self:combatSpellpower(mod * pm, add)
	return spellpower
end

-- Extension Spellbinding
getExtensionModifier = function(self, t, value)
	local pm = getParadoxModifier(self)
	local mod = 1
	
	local p = self:isTalentActive(self.T_EXTENSION)
	if p and p.talent == t.id then
		mod = mod + self:callTalent(self.T_EXTENSION, "getPower")
	end
	
	-- paradox modifier rounds down
	value = math.floor(value * pm)
	-- extension modifier rounds up
	value = math.ceil(value * mod)
	
	return math.max(1, value)
end

-- Tunes paradox towards the preferred value
tuneParadox = function(self, t, value)
	local dox = self:getParadox() - (self.preferred_paradox or 300)
	local fix = math.min( math.abs(dox), value )
	if dox > 0 then
		self:incParadox( -fix )
	elseif dox < 0 then
		self:incParadox( fix )
	end
end

-- Target helper function for focus fire
checkWardenFocus = function(self)
	local target
	local eff = self:hasEffect(self.EFF_WARDEN_S_FOCUS)
	if eff then
		target = eff.target
	end
	return target
end

-- Spell functions

--- Creates a temporal clone
-- @param[type=table] self  Actor doing the cloning. Not currently used.
-- @param[type=table] target  Actor to be cloned.
-- @param[type=int] duration  How many turns the clone lasts. Zero is allowed.
-- @param[type=table] alt_nodes  Optional, these nodes will use a specified key/value on the clone instead of copying from the target.
-- @  Table keys should be the nodes to skip/replace (field name or object reference).
-- @  Each key should be set to false (to skip assignment entirely) or a table with up to two nodes:
-- @    k = a name/ref to substitute for instances of this field,
-- @      or nil to use the default name/ref as keys on the clone
-- @    v = the value to assign for instances of this node,
-- @      or nil to use the default assignent value
-- @return a reference to the clone on success, or nil on failure
makeParadoxClone = function(self, target, duration, alt_nodes)
	if not target or not duration then return nil end
	if duration < 0 then duration = 0 end

	-- Don't copy certain fields from the target
	alt_nodes = alt_nodes or {}
--	if target:getInven("INVEN") then alt_nodes[target:getInven("INVEN")] = false end -- Skip main inventory; equipped items are still copied

	-- Don't copy some additional fields for short-lived clones
	if duration == 0 then
		alt_nodes.__particles = {v = {} }
		alt_nodes.hotkey = false
		alt_nodes.talents_auto = {v = {} }
		alt_nodes.talents_confirm_use = {}
	end

	-- force some values in the clone
	local clone_copy = {name=("%s's temporal clone"):tformat(target:getName()),
		desc=_t[[A creature from another timeline.]],
		faction=target.faction, exp_worth=0,
		life=util.bound(target.life, target.die_at, target.max_life),
		summoner=target, summoner_gain_exp=true, summon_time=duration,
		max_level=target.level,
		ai_target={actor=table.NIL_MERGE}, ai="summoned",
		ai_real="tactical", ai_tactic={escape=0}, -- Clones never flee because they're awesome
	}
	
	-- Clone the target (Note: inventory access is disabled by default)
	local m = target:cloneActor(clone_copy, alt_nodes)

	mod.class.NPC.castAs(m)
	engine.interface.ActorFOV.init(m)
	engine.interface.ActorAI.init(m, m)

	-- Remove some unallowed talents
	local tids = {}
	for tid, _ in pairs(m.talents) do
		local t = m:getTalentFromId(tid)
		if (t.no_npc_use or t.unlearn_on_clone) and not t.allow_temporal_clones then tids[#tids+1] = t end
	end
	for i, t in ipairs(tids) do
		if t.mode == "sustained" and m:isTalentActive(t.id) then m:forceUseTalent(t.id, {ignore_energy=true, silent=true}) end
		m:unlearnTalentFull(t.id)
	end

	-- Remove some timed effects
	m:removeTimedEffectsOnClone()
	
	-- Reset folds for Temporal Warden clones
	for tid, cd in pairs(m.talents_cd) do
		local t = m:getTalentFromId(tid)
		if t.type[1]:find("^chronomancy/manifold") and m:knowTalent(tid) then
			m:alterTalentCoolingdown(t, -cd)
		end
	end
	
	-- A bit of sanity in case anyone decides they should blow up the world..
	if m.preferred_paradox and m.preferred_paradox > 600 then m.preferred_paradox = 600 end

	-- Prevent respawning
	m.self_resurrect = nil
	
	return m
end

-- Make sure we don't run concurrent chronoworlds; to prevent lag and possible game breaking bugs or exploits
checkTimeline = function(self)
	if game._chronoworlds  == nil then
		return false
	else
		return true
	end
end
