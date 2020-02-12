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

-- vault reachable only by a teleporter

setStatusAll{no_teleport=true, vault_only_door_open=true}
border = 1
no_tunnels = true
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

-- The Big, the Bad, and The Ugly....
local themes = {"Undead", "Casters", "Horrors", "Demons", "Constructs"}
-- create filters based on possible themes
local big_filter = {add_levels=10, not_properties={"unique"}}
local bad_filter = {add_levels=5, not_properties={"unique"}}
local ugly_filter = {add_levels=15, max_ood=10, not_properties={"unique"}}
filters = {Demons = {big = table.merge({type="demon"}, big_filter),
	bad = table.merge({type="demon", subtype="minor"}, bad_filter),
	ugly = table.merge({type="demon", subtype="major"}, ugly_filter)
	},
	Undead = {big = table.merge({type="undead"}, big_filter),
	bad = table.merge({type="undead", special=function(e) return (e.rank or 0) <= 2 end}, bad_filter),
	ugly = table.merge({type="undead", special=function(e) return (e.rank or 0) > 2 end}, ugly_filter)
	},
	Horrors = {big = table.merge({type="horror"}, big_filter),
	bad = table.merge({type="horror", special=function(e) return (e.rank or 0) <= 2 end}, bad_filter),
	ugly = table.merge({type="horror", special=function(e) return (e.rank or 0) > 2 end}, ugly_filter)
	},
	Casters = {big = table.merge({type="humanoid", special=function(e) return (e.autolevel == "caster" or e.autolevel == "warriormage") end}, big_filter),
	bad = table.merge({type="humanoid", special=function(e) return (e.autolevel == "caster" or e.autolevel == "warriormage") and (e.rank or 0) <= 2 end}, bad_filter),
	ugly = table.merge({type="humanoid", special=function(e) return (e.autolevel == "caster" or e.autolevel == "warriormage") and (e.rank or 0) > 2 end}, ugly_filter)
	},
	Constructs = {big = table.merge({special=function(e) return e.type == "elemental" or e.type == "construct" end}, big_filter),
	bad = table.merge({special=function(e) return (e.type == "elemental" or e.type == "construct") and (e.rank or 0) <= 2 end}, bad_filter),
	ugly = table.merge({special=function(e) return (e.type == "elemental" or e.type == "construct") and (e.rank or 0) > 2 end}, ugly_filter)
	},
	None = {big = big_filter, bad = bad_filter, ugly = ugly_filter},
}

-- find a theme that can generate each tier of appropriate actors
local get_theme = function(filters, zone, level)
	local themes = table.clone(themes)
	repeat
		local theme = rng.tableRemove(themes)
		if not theme then return false end
		local bad = zone:makeEntity(level, "actor", filters[theme].bad)
		local big = zone:makeEntity(level, "actor", filters[theme].big)
		local ugly = zone:makeEntity(level, "actor", filters[theme].ugly)
		if big and bad and ugly then
			return theme
		end
	until not theme
	return false
end
local theme = get_theme(filters, zone, level)

mapData({theme = theme})

roomcheck = function(room, zone, level, map)
	if resolvers.current_level < 15 then return nil, "inappropriate level" end
	if not room.theme then room.theme = get_theme(filters, zone, level) end
	return room.theme, not room.theme and "no appropriate npcs"
end

local RoomsLoader = require("engine.generator.map.RoomsLoader")

-- This uses the 'CHANGE_LEVEL' interface, but can be made to use another command
-- NOT usable by npc's (would require some ai tweaks)
local trigger = function(self, who)
	-- check for pinned
	if who:attr("never_move") then return end
	local locations, tx, ty = self._locations
	if locations then
		if self.define_as == "VAULT_TELEPORTER_IN" and locations.inx then
			tx, ty = locations.inx, locations.iny
		elseif self.define_as == "VAULT_TELEPORTER_OUT" and locations.outx then
			tx, ty = locations.outx, locations.outy
		end
		tx, ty = util.findFreeGrid(tx, ty, 1, false, {[engine.Map.ACTOR]=true})
		if who.player then
			if not tx then
				game.logPlayer(who, "#YELLOW#The Portal repels you briefly before becoming quiescent.  The other side seems to be blocked.")
			else
				require("engine.ui.Dialog"):yesnoPopup(_t"Malevolent Portal", _t"An ominous aura emanates from this portal. Are you sure you want to go through?", function(ret) if ret then
					game.logPlayer(who, "#YELLOW#You overcome intense #LIGHT_BLUE#REPULSIVE FORCES#LAST# as you traverse the Portal.")
					game:playSoundNear(who, "talents/distortion")
					who:move(tx, ty, true)
				end end, _t"Teleport", _t"Cancel")
			end
		end
	else
		game.logPlayer(who, "#YELLOW#Nothing happens when you use the Portal.")
	end
	who:useEnergy() -- intended to be like walking up to a group of npcs
	return true
end

--[[ these would be used to allow npc's to use the portal
local move_trigger = function(self, x, y, e, act)
	local locations = game.level.map._portal_vault_locations
	if config.settings.cheat then
game.log("on_move triggered: %s, (%s, %s), e:%s, act:%s", self.name, x, y, e and e.name, act)
if locations then game.log("TP Coords: In(%s, %s), Out(%s, %s)", locations.In.x, locations.In.y, locations.Out.x, locations.Out.y) end
	end
end

local stand_trigger = function(self, x, y, who)
	if config.settings.cheat then game.log("%s standing on %s at (%s, %s)", who.name, self.name, x, y) end
end
--]]

TeleportIn = mod.class.Grid.new{
	define_as = "VAULT_TELEPORTER_IN",
	__position_aware = true,
	type = "floor", subtype = "floor",
	name = _t"Portal", image = "terrain/marble_floor.png", add_displays={mod.class.Grid.new{z=5, image = "terrain/demon_portal.png"}},
	desc = _t"A strange portal to some place else.",
	show_tooltip = true, always_remember = true, notice = true,
	display='&', color_r=225, color_g=0, color_b=255,
	on_move = move_trigger,
	on_stand = stand_trigger,
	change_level_check = trigger,
	block_move = function(self, x, y) -- makes Map:updateMap update coordinates
		table.merge(self._locations, {outx=x, outy=y})
		if self._locations.inx and self._locations.iny and self._locations.outx and self._locations.outy then self.block_move = nil end
		return false
	end,
}

TeleportOut = mod.class.Grid.new{
	define_as = "VAULT_TELEPORTER_OUT",
	__position_aware = true,
	type = "floor", subtype = "floor",
	name = _t"Portal", image = "terrain/marble_floor.png", add_displays={mod.class.Grid.new{z=5, image = "terrain/demon_portal4.png"}},
	desc = _t"A portal out of this place.",
	show_tooltip = true, always_remember = true, notice = true,
	display='&', color_r=225, color_g=0, color_b=255,
	on_move = move_trigger,
	on_stand = stand_trigger,
	change_level_check = trigger,
	block_move = function(self, x, y) -- makes Map:updateMap update coordinates
			table.merge(self._locations, {inx=x, iny=y})
		if self._locations.inx and self._locations.iny and self._locations.outx and self._locations.outy then self.block_move = nil end
		return false
	end,
}

local locations = {}
TeleportIn._locations = locations
TeleportOut._locations = locations

-- linked portal room
local portal_def = {name = "portal_room",
map_data={startx=2, starty=2},
[[;;;]],
[[;;;]],
[[;;;]],
}
local portal_room = RoomsLoader:roomParse(portal_def)

-- Set up the satellite room as a way into the vault
onplace = function(room, zone, level, map, placement_data, gen)
	local rooms = gen.map.room_map.rooms
	TeleportIn.change_level = level.level
	TeleportOut.change_level = level.level
	local ret = gen:roomAlloc(portal_room, #rooms+1, level.level, level.level-1)
	if ret then
		map(ret.cx, ret.cy, Map.TERRAIN, TeleportIn)
		placement_data.cx, placement_data.cy = ret.cx, ret.cy -- direct all connections to the portal room
		gen.map.room_map[ret.cx][ret.cy].special = true
	else
		print("portal-vault: could not create a portal room, creating a vault door instead")
		local g = zone:makeEntityByName(level, "grid", "DOOR_VAULT")
		map(placement_data.cx, placement_data.cy, Map.TERRAIN, g)
	end
end

defineTile('P', TeleportOut)
defineTile(';', data.floor or data['.'] or "FLOOR")
defineTile('.', "FLOOR")
defineTile('X', "HARDWALL")
defineTile('#', "WALL")
defineTile('D', "DOOR")
defineTile('1', "FLOOR", {random_filter={add_levels=15, tome_mod="vault"}}, nil)
defineTile('2', "FLOOR", {random_filter={add_levels=12, tome_mod="vault"}}, nil)
defineTile('3', "FLOOR", {random_filter={add_levels=5}}, nil)
defineTile('^', "FLOOR", {random_filter={type="scroll", ego_chance=25}}, nil)
defineTile('$', "FLOOR", {random_filter={type="money"}}, nil)

-- define tiles with npcs matching the theme
theme = theme or "None"
print("portal-vault: populating with theme:", theme)
defineTile('B', "FLOOR", {random_filter={add_levels=12, tome_mod="vault"}}, {random_filter = filters[theme].big})
defineTile('b', "FLOOR", nil, {random_filter = filters[theme].bad})
defineTile('U', "FLOOR", {random_filter={add_levels=15, tome_mod="vault"}}, {random_filter = filters[theme].ugly})

local ret = {
[[##XXXXXXXXX##]],
[[#XX...P...XX#]],
[[XX.........XX]],
[[X###b...b###X]],
[[X3.........3X]],
[[X3.........3X]],
[[X.....B.....X]],
[[X.b#######b.X]],
[[X.....B.....X]],
[[X...........X]],
[[X#....#....#X]],
[[X#....#....#X]],
[[X2....#....2X]],
[[XU....#....UX]],
[[XX3.......3XX]],
[[#XX32.U.23XX#]],
[[##XXXXXXXXX##]],
}
startx = math.floor(#ret[1]/2)
starty = 0

-- randomly place some more monsters
for i = 1, 3 do
	local x, y = rng.range(2, #ret[1]), rng.range(math.ceil(#ret/2), #ret-1)
	if ret[y]:sub(x, x) == '.' then
		ret[y] = ret[y]:sub(1, x-1)..'B'..ret[y]:sub(x+1, #ret[y])
	end
end
for i = 1, 3 do
	local x, y = rng.range(2, #ret[1]), rng.range(3, math.ceil(#ret/2))
	if ret[y]:sub(x, x) == '.' then
		ret[y] = ret[y]:sub(1, x-1)..'b'..ret[y]:sub(x+1, #ret[y])
	end
end

return ret
