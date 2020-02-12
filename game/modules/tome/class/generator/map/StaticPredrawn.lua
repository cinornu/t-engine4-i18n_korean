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
local Map = require "engine.Map"
local lom = require "lxp.lom"
local mime = require "mime"
require "engine.Generator"

--- @classmod engine.generator.map.Static
module(..., package.seeall, class.inherit(engine.Generator))

auto_handle_spot_offsets = true

function _M:init(zone, map, level, data)
	engine.Generator.init(self, zone, map, level)
	self.grid_list = zone.grid_list
	self.subgen = {}
	self.spots = {}
	data.static_replace_tiles = data.static_replace_tiles or {}
	self.data = data
	data.__import_offset_x = data.__import_offset_x or 0
	data.__import_offset_y = data.__import_offset_y or 0

	if data.adjust_level then
		self.adjust_level = {base=zone.base_level, lev = self.level.level, min=data.adjust_level[1], max=data.adjust_level[2]}
	else
		self.adjust_level = {base=zone.base_level, lev = self.level.level, min=0, max=0}
	end

	self:loadMap(data.map, data.inline_map)
end

function _M:getMapFile(file)
	-- Found in the zone itself ?
	if file:find("^!") then return self.zone:getBaseName().."/maps/"..file:sub(2)..".lua" end

	local _, _, addon, rfile = file:find("^([^+]+)%+(.+)$")
	if addon and rfile then
		return "/data-"..addon.."/maps/"..rfile..".lua"
	end
	return "/data/maps/"..file..".lua"
end

-- create a loader to interpret the map file
-- This sets the environment in which the file is interpreted and defines additional functions available within the map definition
-- Some variables (unique, border, no_tunnels, roomcheck, prefer_location, onplace, map_data) assigned in the definition are automatically passed through to the map object (for rooms)
function _M:getLoader(t)
	return {
		level = self.level,
		zone = self.zone,
		data = self.data,
		Map = require("engine.Map"),
		grid_class = self.zone.grid_class,
		trap_class = self.zone.trap_class,
		npc_class = self.zone.npc_class,
		object_class = self.zone.object_class,
		specialList = function(kind, files, add_zone_lists) -- specify entity lists to use (add_zone_lists == include current list)
			local elist
			if kind == "terrain" then
				if add_zone_lists then elist = table.clone(self.zone.grid_list) end
				self.grid_list = self.zone.grid_class:loadList(files, nil, elist, nil, elist and table.clone(elist.__loaded_files))
--				self.grid_list = self.zone.grid_class:loadList(files, nil, elist, nil, elist and elist.__loaded_files)
			elseif kind == "trap" then
				if add_zone_lists then elist = table.clone(self.zone.trap_list) end
				self.trap_list = self.zone.trap_class:loadList(files, nil, elist, nil, elist and table.clone(elist.__loaded_files))
--				self.trap_list = self.zone.trap_class:loadList(files, nil, elist, nil, elist and elist.__loaded_files)
			elseif kind == "object" then
				if add_zone_lists then elist = table.clone(self.zone.object_list) end
				self.object_list = self.zone.object_class:loadList(files, nil, elist, nil, elist and table.clone(elist.__loaded_files))
--				self.object_list = self.zone.object_class:loadList(files, nil, elist, nil, elist and elist.__loaded_files)
			elseif kind == "actor" then
				if add_zone_lists then elist = table.clone(self.zone.npc_list) end
				self.npc_list = self.zone.npc_class:loadList(files, nil, elist, nil, elist and table.clone(elist.__loaded_files))
--				self.npc_list = self.zone.npc_class:loadList(files, nil, elist, nil, elist and elist.__loaded_files)
			else
				error("kind unsupported")
			end
		end,
		subGenerator = function(g)
			self.subgen[#self.subgen+1] = g
		end,
		defineTile = function(char, grid, obj, actor, trap, status, spot)
			grid = self.data.static_replace_tiles[grid] or grid
			t[char] = {grid=grid, object=obj, actor=actor, trap=trap, status=status, define_spot=spot}
		end,
		quickEntity = function(char, e, status, spot)
			if type(e) == "table" then
				local e = self.zone.grid_class.new(e)
				t[char] = {grid=e, status=status, define_spot=spot}
			else
				t[char] = t[e]
			end
		end,
		prepareEntitiesList = function(type, class, file)
			local list = require(class):loadList(file)
			self.level:setEntitiesList(type, list, true)
		end,
		prepareEntitiesRaritiesList = function(type, class, file)
			local list = require(class):loadList(file)
			list = game.zone:computeRarities(type, list, game.level, nil)
			self.level:setEntitiesList(type, list, true)
		end,
		setStatusAll = function(s) self.status_all = s end,
		mapData = function(params) table.merge(self, params) end, -- add data to the map definition (for use with map generators)
		roomCheck = function(testfn) self.roomcheck = testfn end,-- for rooms, set a function(room, zone, level, map) to test if the room should be added (true) to the map
		onPlace = function(onplace) self.onplace = onplace end, -- for rooms, set a function(room, zone, level, map, placement_data) to be called after the room has been added to the map(see RoomsLoader:roomAlloc)
		addData = function(t)
			table.merge(self.level.data, t, true)
		end,
		getMap = function(t)
			return self.map
		end,
		checkConnectivity = function(dst, src, type, subtype)
			self.spots[#self.spots+1] = {x=dst[1], y=dst[2], check_connectivity=src, type=type or "static", subtype=subtype or "static"}
		end,
		addSpot = function(dst, type, subtype, additional)
			local spot = {x=self.data.__import_offset_x+dst[1], y=self.data.__import_offset_y+dst[2], type=type or "static", subtype=subtype or "static"}
			table.update(spot, additional or {})
			self.spots[#self.spots+1] = spot
		end,
		addZone = function(dst, type, subtype, additional)
			local zone = {x1=self.data.__import_offset_x+dst[1], y1=self.data.__import_offset_y+dst[2], x2=self.data.__import_offset_x+dst[3], y2=self.data.__import_offset_y+dst[4], type=type or "static", subtype=subtype or "static"}
			table.update(zone, additional or {})
			self.level.custom_zones = self.level.custom_zones or {}
			self.level.custom_zones[#self.level.custom_zones+1] = zone
		end,
		updateZones = function(type, subtype, update)
			for i, z in ipairs(self.level.custom_zones or {}) do update(z) end
		end,
		-- It's the module's responsibility to invoke zone:runPostGeneration(level), which will call fct(zone, level, level.map) after the level is generated
		onGenerated = function(fct)
			self.level.post_gen_callbacks = self.level.post_gen_callbacks or {}
			self.level.post_gen_callbacks[#self.level.post_gen_callbacks+1] = fct
		end,
	}
end

function _M:loadLuaInEnv(g, file, code)
	local f, err
	if file then f, err = loadfile(file)
	else f, err = loadstring(code) end
	if not f and err then error(err) end
	setfenv(f, setmetatable(g, {__index=_G}))
	return f()
end

-- load a map definition from a tmx file into the map
-- @param file the file to load the definition from
-- @returns true if successful
-- Some lua functions are available within the map file (see Static:getLoader)
-- Some properties set are passed through to the map object returned by the generator function:
-- map_data: a table of properties to merge into the map (performed first)
-- (for rooms):
-- 	unique: a tag (true is converted to the room name) marking the room as unique, two rooms with the same unique tag will not be generated on the same map
-- 	border: the width (in grids, default 0) of clear map area around the room in which no other rooms are allowed to be placed
--	prefer_location: a function(map) returning the preferred map coordinates to place a room
-- 	no_tunnels: set true to prevent automatically connecting tunnels to the room (handled by the map generator)
-- 	roomcheck: a function(room, zone, level, map) checked (if defined) before the room is added to the map (return true to add)
-- 	onplace: a function(room, zone, level, map, placement_data) called after the room has been added to the map (see RoomsLoader:roomPlace)
function _M:tmxLoad(file)
	file = file:gsub("%.lua$", ".tmx")
	if not fs.exists(file) then return end
	print("Static generator using file", file)
	local f = fs.open(file, "r")
	local data = f:read(10485760)
	f:close()

	local data_ids = {}
	local data_images = {}
	local data_talls = {}
	local g = self:getLoader(t)
	local map = lom.parse(data)
	local mapprops = {}
	if map:findOne("properties") then mapprops = map:findOne("properties"):findAllAttrs("property", "name", "value") end
	local w, h = tonumber(map.attr.width), tonumber(map.attr.height)
	local tw, th = tonumber(map.attr.tilewidth), tonumber(map.attr.tileheight)
	local chars = {}
	local start_tid, end_tid = nil, nil
	if mapprops.map_data then
		local params = self:loadLuaInEnv(g, nil, "return "..mapprops.map_data)
		table.merge(self, params, true)
	end
	self.mapprops = mapprops

	for _, tileset in ipairs(map:findAll("tileset")) do
		local firstgid = tonumber(tileset.attr.firstgid)
		for _, tile in ipairs(tileset:findAll("tile")) do
			local tid = tonumber(tile.attr.id + firstgid)
			local id = tile:findOne("property", "name", "id")
			local tall = tile:findOne("property", "name", "tall")
			local image = tile:findOne("image")
			if id then data_ids[tid] = id.attr.value end
			if tall then data_talls[tid] = true end
			if image then
				local _, _, src = image.attr.source:find("(/data/gfx/[a-zA-Z0-9-_/]+%.png)$")
				if src then
					data_images[tid] = src
				else
					error("Malformed image path: "..tostring(image.attr.source))
				end
			end
		end
	end

	if mapprops.status_all then
		self.status_all = self:loadLuaInEnv(g, nil, "return "..mapprops.status_all) or {}
	end

	if mapprops.add_data then
		table.merge(self.level.data, self:loadLuaInEnv(g, nil, "return "..mapprops.add_data) or {}, true)
	end

	if mapprops.lua then
		self:loadLuaInEnv(g, nil, "return "..mapprops.lua)
	end

	-- copy certain variables from the map file
	if mapprops.roomcheck then
		self.roomcheck = self:loadLuaInEnv(g, nil, "return "..mapprops.roomcheck) 
	end
	self.unique = mapprops.unique
	self.no_tunnels = mapprops.no_tunnels
	self.border = mapprops.border and tonumber(mapprops.border)
	if mapprops.prefer_location then
		self.prefer_location = self:loadLuaInEnv(g, nil, "return "..mapprops.prefer_location) 
	end
	if mapprops.onplace then
		self.onplace = self:loadLuaInEnv(g, nil, "return "..mapprops.onplace) 
	end
	
	local m = { w=w, h=h, prefixes={} }
	local m_images = { w=w, h=h, prefixes={} }

	local function populate(i, j, z, tid, prefix)
		local ii, jj = i, j
		m[ii] = m[ii] or {}
		m_images[ii] = m_images[ii] or {}
		m_images[ii][jj] = m_images[ii][jj] or {}

		if data_ids[tid] then m[ii][jj] = data_ids[tid] end
		if data_images[tid] then 
			table.insert(m_images[ii][jj], {z=z, prefix=prefix, tall=data_talls[tid], image=data_images[tid]})
		end
	end

	self.gen_map = m
	self.gen_images = m_images

	self.map.w = m.w
	self.map.h = m.h

	local layers = {}
	for _, layer in ipairs(map:findAll("layer")) do
		local mapdata = layer:findOne("data")
		local layername = layer.attr.name:lower()
		local _, _, layername, layerz = layername:find("^([a-z:]+):([0-9]+)$")
		local _, _, prefix, name = layername:find("^([a-z]+):([a-z]+)$")
		if prefix then layername = name end
		if layername == "terrain" then layername = "grid" end
		if layername and layerz then layers[#layers+1] = {layername=layername, layerz=tonumber(layerz), prefix=prefix, layer=layer, mapdata=mapdata} end
	end
	table.sort(layers, function(a, b) return a.layerz < b.layerz end)

	for _, mlayer in ipairs(layers) do
		local layer = mlayer.layer
		local mapdata = mlayer.mapdata
		local layername = mlayer.layername
		local layerz = mlayer.layerz
		local prefix = mlayer.prefix

		if mapdata.attr.encoding == "base64" then
			local b64 = mime.unb64(mapdata[1]:trim())
			local data
			if mapdata.attr.compression == "zlib" then data = zlib.decompress(b64)
			elseif not mapdata.attr.compression then data = b64
			else error("tmx map compression unsupported: "..mapdata.attr.compression)
			end
			local gid, i = nil, 1
			local x, y = 1, 1
			while i <= #data do
				gid, i = struct.unpack("<I4", data, i)				
				populate(x, y, layerz, gid, prefix)
				x = x + 1
				if x > w then x = 1 y = y + 1 end
			end
		elseif mapdata.attr.encoding == "csv" then
			local data = mapdata[1]:gsub("[^,0-9]", ""):split(",")
			local x, y = 1, 1
			for i, gid in ipairs(data) do
				gid = tonumber(gid)
				populate(x, y, layerz, gid, prefix)
				x = x + 1
				if x > w then x = 1 y = y + 1 end
			end
		elseif not mapdata.attr.encoding then
			local data = mapdata:findAll("tile")
			local x, y = 1, 1
			for i, tile in ipairs(data) do
				local gid = tonumber(tile.attr.gid)
				populate(x, y, layerz, gid, prefix)
				x = x + 1
				if x > w then x = 1 y = y + 1 end
			end
		end
	end

	self.add_attrs_later = {}
	self.to_spawn = {}

	local fakeid = -1
	for _, og in ipairs(map:findAll("objectgroup")) do
		for _, o in ipairs(og:findAll("object")) do
			local props = {}
			if o:findOne("properties") then props = o:findOne("properties"):findAllAttrs("property", "name", "value") end

			if og.attr.name:find("^addSpot") then
				local x, y, w, h = math.floor(tonumber(o.attr.x) / tw), math.floor(tonumber(o.attr.y) / th), math.floor(tonumber(o.attr.width) / tw), math.floor(tonumber(o.attr.height) / th)
				if props.start then m.startx = x m.starty = y end
				if props['end'] then m.endx = x m.endy = y end
				if props.type and props.subtype then
					local t, st = props.type, props.subtype
					props.type, props.subtype = nil, nil
					for i = x, x + w do for j = y, y + h do
						g.addSpot({i, j}, t, st, props)
					end end
				end
			elseif og.attr.name:find("^addZone") then
				local x, y, w, h = math.floor(tonumber(o.attr.x) / tw), math.floor(tonumber(o.attr.y) / th), math.floor(tonumber(o.attr.width) / tw), math.floor(tonumber(o.attr.height) / th)
				if props.type and props.subtype then
					local t, st = props.type, props.subtype
					props.type, props.subtype = nil, nil
					local i1, j1 = x, y
					local i2, j2 = x + w, y + h
					g.addZone({i1, j1, i2, j2}, t, st, props)
				end
			elseif og.attr.name:find("^attrs") then
				local x, y, w, h = math.floor(tonumber(o.attr.x) / tw), math.floor(tonumber(o.attr.y) / th), math.floor(tonumber(o.attr.width) / tw), math.floor(tonumber(o.attr.height) / th)
				for k, v in pairs(props) do
					for i = x, x + w do for j = y, y + h do
						local i, j = i + 1, j + 1
						i, j = i - 1, j - 1
						self.add_attrs_later[#self.add_attrs_later+1] = {x=i, y=j, key=k, value=self:loadLuaInEnv(g, nil, "return "..v)}
					end end
				end
			elseif og.attr.name:find("^spawn") then
				local x, y, w, h = math.floor(tonumber(o.attr.x) / tw), math.floor(tonumber(o.attr.y) / th), math.floor(tonumber(o.attr.width) / tw), math.floor(tonumber(o.attr.height) / th)
				for i = x, x + w do for j = y, y + h do
					local i, j = i + 1, j + 1
					self.to_spawn[#self.to_spawn+1] = {i=i, j=j, actor=props.actor, object=props.object, trap=props.trap}
				end end
			elseif og.attr.name:find("^particles") then
				local x, y, w, h = math.floor(tonumber(o.attr.x) / tw), math.floor(tonumber(o.attr.y) / th), math.floor(tonumber(o.attr.width) / tw), math.floor(tonumber(o.attr.height) / th)
				for i = x, x + w do for j = y, y + h do
					local i, j = i + 1, j + 1
					self.to_spawn[#self.to_spawn+1] = {i=i, j=j, particles=props}
				end end
			end
		end
	end

	m.startx = m.startx or math.floor(m.w / 2)
	m.starty = m.starty or math.floor(m.h / 2)
	m.endx = m.endx or math.floor(m.w / 2)
	m.endy = m.endy or math.floor(m.h / 2)
	print("[STATIC TMX MAP] size", m.w, m.h)
	return true
end

-- load a map from a lua file
function _M:loadMap(file)
	file = self:getMapFile(file)
	if self:tmxLoad(file) then return end
	error("StaticPredrawn generator requires a tmx file", file)
end

function _M:generate(lev, old_lev)
	local spots = {}

	local function alterg(g, imgs)
		if g.force_clone or (imgs and #imgs > 0) then g = g:cloneFull() end

		if imgs and #imgs > 0 then
			g.image = imgs[1].image
			g.z = imgs[1].z
			g.add_displays = g.add_displays or {}
			for iz = 2, #imgs do
				g.add_displays[#g.add_displays+1] = g:getClass().new{image=imgs[iz].image, z=imgs[iz].z}
				if imgs[iz].tall then
					g.add_displays[#g.add_displays].display_y = -1
					g.add_displays[#g.add_displays].display_h = 2
				end
			end
		end
		g:resolve() g:resolve(nil, true)
		return g
	end

	-- populate the map with the grids specified first
	for i = 1, self.gen_map.w do for j = 1, self.gen_map.h do
		local c = self.gen_map[i][j]
		local g
		if type(c) == "string" then g = self:resolve(c, nil, true)
		else  end

		if g then
			local imgs = table.splitlist(function(i, v) return v.prefix or "base", v end, self.gen_images[i][j])

			g = alterg(g, imgs.base)
			if g.door_opened and self.mapprops.door_open_layers then g.door_opened = alterg(g.door_opened, imgs[self.mapprops.door_open_layers]) end

			self.map(i-1, j-1, Map.TERRAIN, g)

			g:check("addedToLevel", self.level, i-1, j-1)
			g:check("on_added", self.level, i-1, j-1)
		end

		if self.status_all then
			local s = table.clone(self.status_all)
			if s.lite then self.level.map.lites(i-1, j-1, true) s.lite = nil end
			if s.remember then self.level.map.remembers(i-1, j-1, true) s.remember = nil end
			if s.special then self.map.room_map[i-1][j-1].special = s.special s.special = nil end
			if s.room_map then for k, v in pairs(s.room_map) do self.map.room_map[i-1][j-1][k] = v end s.room_map = nil end
			if pairs(s) then for k, v in pairs(s) do self.level.map.attrs(i-1, j-1, k, v) end end
		end
	end end

	-- then generate additional entities since they might need full map data to be correctly made
	-- use specific entity lists, if defined
	local zonelists = {grid_list=self.zone.grid_list, npc_list=self.zone.npc_list, object_list=self.zone.object_list, trap_list=self.zone.trap_list}
	local elists
	if self.grid_list ~= self.zone.grid_list or self.npc_list or self.object_list or self.trap_list then
		self.zone.npc_list, self.zone.object_list, self.zone.trap_list = self.npc_list or self.zone.npc_list, self.object_list or self.zone.object_list, self.trap_list or self.zone.trap_list
		elists = {grid_list = self.zone.grid_list, npc_list = self.zone.npc_list, object_list = self.zone.object_list, trap_list = self.zone.trap_list}
	end
	
	for _, spawn in ipairs(self.to_spawn) do
		local i, j = spawn.i, spawn.j
		local actor, trap, object, particles = spawn.actor, spawn.trap, spawn.object, spawn.particles

		if object then
			local o, mod
			if type(object) == "string" then o = self.zone:makeEntityByName(self.level, "object", object)
			elseif type(object) == "table" and object.random_filter then mod = object.entity_mod o = self.zone:makeEntity(self.level, "object", object.random_filter, nil, true)
			else o = self.zone:finishEntity(self.level, "object", object)
			end
			if o then if mod then o = mod(o) end self:roomMapAddEntity(i-1, j-1, "object", o, elists) end --takes care of uniques
		end

		if trap then
			local t, mod
			if type(trap) == "string" then t = self.zone:makeEntityByName(self.level, "trap", trap)
			elseif type(trap) == "table" and trap.random_filter then mod = trap.entity_mod t = self.zone:makeEntity(self.level, "trap", trap.random_filter, nil, true)
			else t = self.zone:finishEntity(self.level, "trap", trap)
			end
			if t then if mod then t = mod(t) end self:roomMapAddEntity(i-1, j-1, "trap", t, elists) end
		end

		if actor then
			local m, mod
			if type(actor) == "string" then m = self.zone:makeEntityByName(self.level, "actor", actor)
			elseif type(actor) == "table" and actor.random_filter then mod = actor.entity_mod m = self.zone:makeEntity(self.level, "actor", actor.random_filter, nil, true)
			else m = self.zone:finishEntity(self.level, "actor", actor)
			end
			if m then
				if mod then m = mod(m) end
				self:roomMapAddEntity(i-1, j-1, "actor", m, elists)
			end
		end

		if particles then
			local size = 1
			if particles.size then size = particles.size + 1
			elseif particles.radius then size = particles.radius + 1
			elseif particles.tx then size = math.max(particles.tx, particles.ty) + 1
			end
			self.level.map:particleEmitter(i-1, j-1, size, particles.type, particles)
		end
	end

	if self.add_attrs_later then for _, attr in ipairs(self.add_attrs_later) do
		if attr.key == "lite" then self.level.map.lites(attr.x, attr.y, true) end
		if attr.key == "remember" then self.level.map.remembers(attr.x, attr.y, true) end
		if attr.key == "special" then self.map.room_map[attr.x][attr.y].special = s.special end
		if attr.key == "room_map" then for k, v in pairs(s.room_map) do self.map.room_map[attr.x][attr.y][k] = v end end
		self.level.map.attrs(attr.x, attr.y, attr.key, attr.value)
	end end

	self:triggerHook{"MapGeneratorStaticPredrawn:subgenRegister", mapfile=self.data.map, list=self.subgen}

	for i = 1, #self.subgen do
		local g = self.subgen[i]
		local data = g.data
		if type(data) == "string" and data == "pass" then data = self.data end

		local map = self.zone.map_class.new(g.w, g.h)
		data.__import_offset_x = self.data.__import_offset_x+g.x
		data.__import_offset_y = self.data.__import_offset_y+g.y
		local generator = require(g.generator).new(
			self.zone,
			map,
			self.level,
			data
		)
		local ux, uy, dx, dy, subspots = generator:generate(lev, old_lev)
		if ux and uy then
			if data.overlay or g.overlay then
				self.map:overlay(map, g.x, g.y)
			else
				self.map:import(map, g.x, g.y)
			end

			if not generator.auto_handle_spot_offsets then
				for _, spot in ipairs(subspots) do
					spot.x = spot.x + data.__import_offset_x
					spot.y = spot.y + data.__import_offset_y
				end
			end

			table.append(self.spots, subspots)
			if g.define_up then self.gen_map.startx, self.gen_map.starty = ux + self.data.__import_offset_x+g.x, uy + self.data.__import_offset_y+g.y end
			if g.define_down then self.gen_map.endx, self.gen_map.endy = dx + self.data.__import_offset_x+g.x, dy + self.data.__import_offset_y+g.y end
		else -- generator failed
			if generator.removed then generator:removed(lev, old_lev) end
		end
	end
	
	-- restore entity lists
	for l, list in pairs(zonelists) do self.zone[l] = list end
	
	if self.gen_map.startx and self.gen_map.starty then
		self.map.room_map[self.gen_map.startx][self.gen_map.starty].special = "exit"
	end
	if self.gen_map.endx and self.gen_map.endy then
		self.map.room_map[self.gen_map.endx][self.gen_map.endy].special = "exit"
	end
	return self.gen_map.startx, self.gen_map.starty, self.gen_map.endx, self.gen_map.endy, self.spots
end
