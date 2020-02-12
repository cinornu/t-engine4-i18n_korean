-- TE4 - T-Engine 4
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

--- Factions for actors  
-- Defines 2 factions by default: "Players", "Enemies"
-- @classmod engine.Faction
module(..., package.seeall, class.make)

_M.factions = {}

--- Adds a new faction
-- @static
-- @param[type=table] t the table describing the faction.
-- @string t.name the name of the added faction
-- @string[opt] t.short_name the internally referenced name, defaults to lowercase t.name with "-" for spaces.
-- @param[type=?table] t.reaction table of initial reactions to other factions, where keys are short_names.
-- @return t.short_name see above
function _M:add(t)
	assert(t.name, "no faction name")
	t.short_name = t.short_name or t.name:lower():gsub(" ", "-")
	-- I18N faction
	t.name = _t(t.name)
	if self.factions[t.short_name] then print("[FACTION] tried to redefine", t.name) return t.short_name end

	local r = {}
	t.reaction = t.reaction or {}
	for n, v in pairs(t.reaction) do
		n = n:lower():gsub(" ", "-")
		r[n] = v
	end
	t.reaction = r
	self.factions[t.short_name] = t
	return t.short_name
end

--- Sets the initial reaction.
-- @static
-- @string f1 the source faction short_name.
-- @string f2 the target faction short_name.
-- @number reaction a numerical value representing the reaction, 0 is neutral, <0 is aggressive, >0 is friendly.
-- @param[type=boolean] mutual if true the same status will be set for f2 toward f1.
function _M:setInitialReaction(f1, f2, reaction, mutual)
--	print("[FACTION] initial", f1, f2, reaction, mutual)
	-- Faction always like itself
	if f1 == f2 then return end
	if not self.factions[f1] then return end
	if not self.factions[f2] then return end
	self.factions[f1].reaction[f2] = reaction
	if mutual then
		self.factions[f2].reaction[f1] = reaction
	end
end

--- Gets the faction definition
-- @static
-- @param id
-- @return `Faction`
function _M:get(id)
	return self.factions[id]
end

--- Gets the status of faction f1 toward f2
-- @string f1 the source faction short_name
-- @string f2 the target faction short_name
-- @return reaction a numerical value representing the reaction, 0 is neutral, <0 is aggressive, >0 is friendly.
function _M:factionReaction(f1, f2)
	-- Factions always like itself
	if f1 == f2 then return 100 end
	if game.factions and game.factions[f1] and game.factions[f1][f2] then return game.factions[f1][f2] end
	if not self.factions[f1] then return 0 end
	return self.factions[f1].reaction[f2] or 0
end

--- Sets the status of faction f1 toward f2.
-- This should only be used after the game has loaded (not in load.lua).
-- These changes will be saved to the savefile.
-- @string f1 the source faction short_name.
-- @string f2 the target faction short_name.
-- @number reaction a value representing the reaction, 0 is neutral, <0 is aggressive, >0 is friendly.
-- @param[type=boolean] mutual if true the same status will be set for f2 toward f1.
function _M:setFactionReaction(f1, f2, reaction, mutual)
	reaction = util.bound(reaction, -100, 100)
	print("[FACTION]", f1, f2, reaction, mutual)
	-- Faction always like itself
	if f1 == f2 then return end
	if not self.factions[f1] then return end
	if not self.factions[f2] then return end
	game.factions = game.factions or {}
	game.factions[f1] = game.factions[f1] or {}
	game.factions[f1][f2] = reaction
	if mutual then
		game.factions[f2] = game.factions[f2] or {}
		game.factions[f2][f1] = reaction
	end

	self:triggerHook{"Faction:setReaction", f1=f1, f2=f2, reaction=reaction, mutual=mutual}
end

--- Copies all the reactions from/to a faction onto a new one
function _M:copyReactions(to, from)
	table.merge(self.factions[to].reaction, self.factions[from].reaction)
	for f, data in pairs(self.factions) do if f ~= to and f ~= from then
		if data.reaction[from] then data.reaction[to] = data.reaction[from] end
	end end
end

-- Add a few default factions
_M:add{ name="Players", reaction={enemies=-100} }
_M:add{ name="Enemies", reaction={players=-100} }
