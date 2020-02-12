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
require "engine.Grid"
local Map = require "engine.Map"
local Dialog = require "engine.ui.Dialog"
local DamageType = require "engine.DamageType"
local Combat = require "mod.class.interface.Combat"

module(..., package.seeall, class.inherit(engine.Grid))

_M.logCombat = Combat.logCombat

function _M:init(t, no_default)
	engine.Grid.init(self, t, no_default)

	self:initGlow()
end

--- Make wilderness zone entrances glow until entered once
function _M:initGlow()
	if self.glow and Map.tiles.nicer_tiles and self.change_zone then
		self.add_displays = self.add_displays or {}
		self.add_displays[#self.add_displays+1] = require("mod.class.WildernessGrid").new{change_zone=self.change_zone, display=' ', z=17}
	end
end

function _M:altered(t)
	if t then for k, v in pairs(t) do self[k] = v end end
	self.__SAVEINSTEAD = nil
	self.__nice_tile_base = nil
	self.nice_tiler = nil
end

function _M:block_move(x, y, e, act, couldpass)
	-- Path strings
	if not e then e = {}
	elseif type(e) == "string" then
		e = loadstring(e)()
	end

	-- Open doors
	if self.door_opened and e.open_door and act then
		local door_g
		if type(self.door_opened) == "string" then door_g = game.zone.grid_list[self.door_opened]
		else door_g = self.door_opened end

		if self.door_player_check then
			if e.player then
				Dialog:yesnoPopup(self:getName(), self.door_player_check, function(ret)
					if ret then
						game.level.map(x, y, engine.Map.TERRAIN, door_g)
						game:playSoundNear({x=x,y=y}, self.door_sound or {"ambient/door_creaks/creak_%d",1,4})
						game.level.map:checkAllEntities(x, y, "on_door_opened", e)

						if game.level.map.attrs(x, y, "vault_id") and e.openVault then e:openVault(game.level.map.attrs(x, y, "vault_id")) end
					end
				end, _t"Open", _t"Leave")
			end
		elseif self.door_player_stop then
			if e.player then
				Dialog:simplePopup(self:getName(), self.door_player_stop)
			end
		else
			game.level.map(x, y, engine.Map.TERRAIN, door_g)
			game:playSoundNear({x=x,y=y}, self.door_sound or {"ambient/door_creaks/creak_%d",1,4})
			game.level.map:checkAllEntities(x, y, "on_door_opened", e)

			if game.level.map.attrs(x, y, "vault_id") and e.openVault then e:openVault(game.level.map.attrs(x, y, "vault_id")) end
		end
		return true
	elseif self.door_opened and not couldpass then
		return true
	elseif self.door_opened and couldpass and not e.open_door then
		return true
	end

	-- Pass walls
	if self.can_pass and e.can_pass then
		for what, check in pairs(e.can_pass) do
			if self.can_pass[what] and self.can_pass[what] <= check then return false end
		end
	end

	-- Huge hack, if we are an actor without position this means we are not yet put on the map
	-- If so make sure we can only go where we can breathe
	if e.__is_actor and not e.x and not e:attr("no_breath") then
		local air_level, air_condition = self:check("air_level"), self:check("air_condition")
		if air_level and (not air_condition or not e.can_breath[air_condition] or e.can_breath[air_condition] <= 0) then
			return true
		end
	end

	if e and act and self.does_block_move and e.player and game.level.map.attrs(x, y, "on_block_change") then
		local ng = game.zone:makeEntityByName(game.level, "terrain", game.level.map.attrs(x, y, "on_block_change"))
		if ng then
			game.zone:addEntity(game.level, ng, "terrain", x, y)
			game.nicer_tiles:updateAround(game.level, x, y)
			if game.level.map.attrs(x, y, "on_block_change_msg") then game.logSeen({x=x, y=y}, "%s", game.level.map.attrs(x, y, "on_block_change_msg")) end
			game.level.map.attrs(x, y, "on_block_change", false)
			game.level.map.attrs(x, y, "on_block_change_msg", false)
		end
	end

	return self.does_block_move
end

--- Setup minimap color for this entity
-- You may overload this method to customize your minimap
function _M:setupMinimapInfo(mo, map)
	if self.special_minimap then mo:minimap(self.special_minimap.r, self.special_minimap.g, self.special_minimap.b) return end
	if self.change_level then mo:minimap(240, 0, 240) return
	elseif self.is_door then
		if self.does_block_move then mo:minimap(140, 80, 25) else mo:minimap(80, 30, 20) end return
	end
	return engine.Grid.setupMinimapInfo(self, mo, map)
end

function _M:on_move(x, y, who, forced)
	if forced then return end
	if who.move_project and next(who.move_project) then
		for typ, dam in pairs(who.move_project) do
			DamageType:get(typ).projector(who, x, y, typ, dam)
		end
	end
end

function _M:resolveSource()
	if self.summoner_gain_exp and self.summoner then
		return self.summoner:resolveSource()
	else
		return self
	end
end

-- Gets the full name of the grid
function _M:getName()
	-- I18N grid names.
	local name = _t(self.name) or _t"spot"
	if self.summoner and self.summoner.name then
		return ("%s's %s"):tformat(self.summoner:getName():capitalize(), name)
	else
		return name
	end
end

function _M:tooltip(x, y)
	if not x or not y then return tstring("") end
	local tstr
	local dist = nil
	if game.player.x and game.player.y then dist = tstring{_t" (range: ", {"font", "italic"}, {"color", "LIGHT_GREEN"}, tostring(core.fov.distance(game.player.x, game.player.y, x, y)), {"color", "LAST"}, {"font", "normal"}, ")"} end
	if self.show_tooltip then
		-- I18N Grid name
		local name = ((self.show_tooltip == true) and self:getName() or self.show_tooltip)
		if self.desc then
			tstr = tstring{{"uid", self.uid}, name}
			if dist then tstr:merge(dist) end
			tstr:add(true, self.desc, true)
		else
			tstr = tstring{{"uid", self.uid}, name}
			if dist then tstr:merge(dist) end
			tstr:add(true)
		end
	else
		tstr = tstring{{"uid", self.uid}, self:getName()}
		if dist then tstr:merge(dist) end
		tstr:add(true)
	end

	if self.change_zone then
		-- Lets make very very sure that funky weird zone files dont explode things
		local ok, data = pcall(function()
			local fakezone = {short_name=self.change_zone}
			local base = engine.Zone.getBaseName(fakezone)
			local f = loadfile(base.."/zone.lua")
			if f then
				setfenv(f, setmetatable({self=fakezone, short_name=fakezone.short_name}, {__index=_G}))
				local ok, z = pcall(f)
				return z
			end
		end)
		if ok and data then
			if data.level_range then
				local p = game:getPlayer(true)
				local color = "AQUAMARINE"
				if p.level <= data.level_range[1] - 10 then color = "CRIMSON"
				elseif p.level <= data.level_range[1] - 4 then color = "ORANGE"
				end
				tstr:add(true, {"font","bold"}, {"color", color}, _t"Min.level: "..data.level_range[1], {"color", "LAST"}, {"font","normal"}, true)
			end
		end
	end

	if game.level.entrance_glow and self.change_zone and not game.visited_zones[self.change_zone] then
		tstr:add(true, {"font","bold"}, {"color","CRIMSON"}, _t"Never visited yet", {"color", "LAST"}, {"font","normal"}, true)
	end

	if game.player:hasLOS(x, y) then tstr:add({"color", "CRIMSON"}, _t"In sight", {"color", "LAST"}, true) end
	if game.level.map.lites(x, y) then tstr:add({"color", "YELLOW"}, _t"Lit", {"color", "LAST"}, true) end
	if self:check("block_sight", x, y) then tstr:add({"color", "UMBER"}, _t"Blocks sight", {"color", "LAST"}, true) end
	if self:check("block_move", x, y, game.player) then tstr:add({"color", "UMBER"}, _t"Blocks movement", {"color", "LAST"}, true) end
	if self:attr("air_level") and self:attr("air_level") < 0 then tstr:add({"color", "LIGHT_BLUE"}, _t"Special breathing method required", {"color", "LAST"}, true) end
	if self:attr("dig") then tstr:add({"color", "LIGHT_UMBER"}, _t"Diggable", {"color", "LAST"}, true) end
	if game.level.map.attrs(x, y, "no_teleport") then tstr:add({"color", "VIOLET"}, _t"Cannot teleport to this place", {"color", "LAST"}, true) end
	

	if config.settings.cheat then
		tstr:add(true, _t(tostring(rawget(self, "type"))), " / ", _t(tostring(rawget(self, "subtype"))))
		tstr:add(true, "UID: ", tostring(self.uid), true, _t"Coords: ", tostring(x), "x", tostring(y))
	
		-- debugging info
		if game.level.map.room_map then
			local data = game.level.map.room_map[x][y]
			local room_base = table.get(game.level.map.room_map.rooms, data.room)
			local room = room_base and room_base.room
			tstr:add(true, {"color", "PINK"}, ("room_map:rm:%s(id:%s,name:%s), spec:%s, c/o:%s, bor:%s, tun:%s, rtun:%s"):format(data.room, room_base and room_base.id, room and room.name, data.special, data.can_open, data.border, data.tunnel, data.real_tunnel))
		end
		local attrs = game.level.map.attrs[x+y*game.level.map.w]
		if attrs then
			tstr:add(true, {"color", "TAN"}, _t"map attrs: ")
			for atr, val in pairs(attrs) do
				tstr:add(("%s=%s%s"):format(atr,val,", "))
			end
		end
	end
	return tstr
end

--- Generate sub entities to make nice trees
function _M:makeNewTrees(g, kindsdefs, max_trees, basedir)
	basedir = basedir or "terrain/trees/"
	max_trees = max_trees or 3
	g.add_displays = g.add_displays or {}
	g.add_mos = g.add_mos or {}
	local basemos = g.add_mos
	local add = g.add_displays
	add[#add+1] = engine.Entity.new{image="invis.png", z=3, display_on_seen = true, display_on_remember = true, add_mos={}}
	local mos = add[#add].add_mos
	local function getname(n)
		if type(n) == "string" then return n end
		return n[1]:format(rng.range(n[2], n[3]))
	end
	local function makeTree(nb, z)
		local inb = 4 - nb
		local treedef = rng.table(kindsdefs)
		local treeid = treedef[1]
		local parts = treedef[2]
		if not parts.inited then
			if not parts.tall then parts.tall = 0 end
			if not parts.alltall then parts.alltall = 0 else parts.tall = parts.alltall end
			parts.inited = true
		end

		local scale = rng.float(0.5 + inb / 6, 1)
		local x = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3)
		local y = rng.float(-1 / 5 * nb / 3, 1 / 4 * nb / 3)

		for i = 1, #parts - 1 do
			mos[#mos+1] = {image=basedir..treeid.."_"..getname(parts[i])..".png", display_x=x, display_y=y + scale * parts.alltall, display_w=scale, display_h=scale * (1 - parts.alltall)}
		end
		if parts.base then
			basemos[#basemos+1] = {image=basedir..treeid.."_"..getname(parts.base)..".png", display_x=x, display_y=y + scale * parts.alltall, display_w=scale, display_h=scale * (1 - parts.alltall)}
		end
		if parts.adds then
			local name = parts.adds[1]
			local t = {
				z = z,
				display_x = x,
				display_y = y,
				display_w = scale,
				display_h = scale,
				display_on_seen = true,
				display_on_remember = true,
				image = basedir..treeid.."_"..getname(name)..".png",
			}
			table.merge(t, parts.adds)
			add[#add+1] = engine.Entity.new(t)
		end
		add[#add+1] = engine.Entity.new{
			z = z,
			_st = y,
			display_x = x,
			display_y = y + scale * parts.tall,
			display_w = scale,
			display_h = scale * (1 - parts.tall),
			display_on_seen = true,
			display_on_remember = true,
			image = basedir..treeid.."_"..getname(parts[#parts])..".png",
			shader = "tree", shader_args = parts.shader_args,
		}
		return add[#add]
	end

	local v = rng.range(0, 100)
	local tbl
	if v < 33 and max_trees >= 3 then
		tbl = { makeTree(3, 16), makeTree(3, 17), makeTree(3, 18), }
	elseif v < 66 and max_trees >= 2 then
		tbl = { makeTree(2, 16), makeTree(2, 17), }
	else
		tbl = { makeTree(1, 16), }
	end
	table.sort(tbl, function(a,b) return a._st < b._st end)
	for i = 1, #tbl do tbl[i].z = 16 + i - 1 end
	return g
end

--- Generate sub entities to make nice trees
function _M:makeTrees(base, max, bigheight_limit, tint, attenuation)
	local function makeTree(nb, z)
		local inb = 4 - nb
		local treeid = rng.range(1, max or 5)
		return engine.Entity.new{
			z = z,
			display_scale = 1,
			display_scale = rng.float(0.5 + inb / 6, 1),
			display_x = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_y = rng.float(-1 / 5 * nb / 3, 1 / 4 * nb / 3) - (treeid < (bigheight_limit or 9) and 0 or 1),
			display_on_seen = true,
			display_on_remember = true,
			display_h = treeid < (bigheight_limit or 9) and 1 or 2,
			image = (base or "terrain/tree_alpha")..treeid..".png",
			tint = tint,
			shader = "tree", shader_args={attenuation=attenuation},
		}
	end

	local v = rng.range(0, 100)
	local tbl
	if v < 33 then
		tbl = { makeTree(3, 16), makeTree(3, 17), makeTree(3, 18), }
	elseif v < 66 then
		tbl = { makeTree(2, 16), makeTree(2, 17), }
	else
		tbl = { makeTree(1, 16), }
	end
	table.sort(tbl, function(a,b) return a.display_scale < b.display_scale end)
	for i = 1, #tbl do tbl[i].z = 16 + i - 1 end
	return tbl
end

--- Generate sub entities to make nice trees
function _M:makeSubTrees(base, max)
	local function makeTree(nb, z)
		local inb = 4 - nb
		return engine.Entity.new{
			z = z,
			display_scale = rng.float(0.5 + inb / 6, 1.3),
			display_x = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_y = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_on_seen = true,
			display_on_remember = true,
			image = (base or "terrain/tree_alpha")..rng.range(1,max or 5)..".png",
		}
	end

	local v = rng.range(0, 100)
	local tbl
	if v < 40 then
--		tbl = { makeTree(3, 16), makeTree(3, 17), makeTree(3, 18), }
--	elseif v < 66 then
		tbl = { makeTree(2, 16), makeTree(2, 17), }
	else
		tbl = { makeTree(1, 16), }
	end
	table.sort(tbl, function(a,b) return a.display_scale < b.display_scale end)
	for i = 1, #tbl do tbl[i].z = 16 + i - 1 end
	return tbl
end

--- Generate sub entities to make nice crystals, same as trees but change tint
function _M:makeCrystals(base, max)
	local function makeTree(nb, z)
		local inb = 4 - nb
		local r = rng.range(1, 100)
		local g = rng.range(1, 100)
		local b = rng.range(1, 100)
		local maxcol = math.max(r, g, b)
		r = r / maxcol
		g = g / maxcol
		b = b / maxcol
		return engine.Entity.new{
			z = z,
			display_scale = rng.float(0.5 + inb / 6, 1.3),
			display_x = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_y = rng.float(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_on_seen = true,
			display_on_remember = true,
			tint_r = r,
			tint_g = g,
			tint_b = b,
			image = (base or "terrain/crystal_alpha")..rng.range(1,max or 6)..".png",
		}
	end

	local v = rng.range(0, 100)
	local tbl
	if v < 33 then
		tbl = { makeTree(3, 16), makeTree(3, 17), makeTree(3, 18), }
	elseif v < 66 then
		tbl = { makeTree(2, 16), makeTree(2, 17), }
	else
		tbl = { makeTree(1, 16), }
	end
	table.sort(tbl, function(a,b) return a.display_scale < b.display_scale end)
	for i = 1, #tbl do tbl[i].z = 16 + i - 1 end
	return tbl
end

--- Generate sub entities to make nice shells
function _M:makeShells(base, max)
	local function makeShell(nb, z)
		local inb = 4 - nb
		return engine.Entity.new{
			z = z,
			display_scale = rng.float(0.1 + inb / 6, 0.2),
			display_x = rng.range(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_y = rng.range(-1 / 3 * nb / 3, 1 / 3 * nb / 3),
			display_on_seen = true,
			display_on_remember = true,
			image = (base or "terrain/tree_alpha")..rng.range(1,max or 5)..".png",
		}
	end

	local v = rng.range(0, 100)
	local tbl
	if v < 33 then
		return nil
	elseif v < 66 then
		tbl = { makeShell(2, 2), makeShell(2, 3), }
	else
		tbl = { makeShell(1, 2), }
	end
	table.sort(tbl, function(a,b) return a.display_y < b.display_y end)
	return tbl
end

--- Generate sub entities to make translucent water
function _M:makeWater(z, prefix)
	prefix = prefix or ""
	return { engine.Entity.new{
		z = z and 16 or 9,
		image = "terrain/"..prefix.."water_floor_alpha.png",
		shader = prefix.."water", textures = { function() return _3DNoise, true end },
		display_on_seen = true,
		display_on_remember = true,
	} }
end

--- Merge sub entities
function _M:mergeSubEntities(...)
	local tbl = {}
	for i, t in ipairs{...} do if t then
		for j, e in ipairs(t) do
			tbl[#tbl+1] = e
		end
	end end
	return tbl
end

--- Push a lever
function _M:leverActivated(x, y, who)
	if self.lever_dead then return end
	self.lever = not self.lever

	local spot = game.level.map.attrs(x, y, "lever_spot") or nil
	local block = game.level.map.attrs(x, y, "lever_block") or nil
	local radius = game.level.map.attrs(x, y, "lever_radius") or 10
	local val = game.level.map.attrs(x, y, "lever")
	local kind = game.level.map.attrs(x, y, "lever_kind")
	if game.level.map.attrs(x, y, "lever_only_once") then self.lever_dead = true end
	if type(kind) == "string" then kind = {[kind]=true} end
	game.log("#VIOLET#You hear a mechanism clicking.")

	local apply = function(i, j, who)
		local akind = game.level.map.attrs(i, j, "lever_action_kind")
		if not akind then return end
		if type(akind) == "string" then akind = {[akind]=true} end
		for k, _ in pairs(kind) do if akind[k] then
			local old = game.level.map.attrs(i, j, "lever_action_value") or 0
			local newval = old + (self.lever and val or -val)
			game.level.map.attrs(i, j, "lever_action_value", newval)
			if game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "on_lever_change", who, newval, old) then
				if game.level.map.attrs(i, j, "lever_action_only_once") then game.level.map.attrs(i, j, "lever_action_kind", false) end
			end
			local fct = game.level.map.attrs(i, j, "lever_action_custom")
			if fct and fct(i, j, who, newval, old) then
				if game.level.map.attrs(i, j, "lever_action_only_once") then game.level.map.attrs(i, j, "lever_action_kind", false) end
			end
		end end
	end

	if spot then
		local spot = game.level:pickSpot(spot)
		if spot then apply(spot.x, spot.y, who) end
	else
		core.fov.calc_circle(x, y, game.level.map.w, game.level.map.h, radius, function(_, i, j)
			if block and game.level.map.attrs(i, j, block) then return true end
		end, function(_, i, j) apply(i, j, who) end, nil)
	end
end