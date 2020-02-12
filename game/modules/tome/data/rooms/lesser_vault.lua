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

-- "Lesser" vaults are generally either low level or specific to a particular zone.
-- see engine.generator.map.Static:getLoader for additional commands available within the vault definition

local max_w, max_h = 50, 50
-- Dynamically build the list, this way addons can add new vaults easily
local list = {}
for _, f in ipairs(fs.list("/data/maps/vaults/auto/lesser/")) do
	if f:suffix(".lua") or f:suffix(".tmx") then
		list[#list+1] = f:sub(1, #f - 4)
	end
end
print("[lesser_vault] initializing auto list:")
table.print(list, "---")

local function vault_exists(f)
	if fs.exists("/data/maps/"..f..".lua") or fs.exists("/data/maps/"..f..".tmx") then return f end
	return false
end

return function(gen, id, lev, old_lev)
	local vault_map
	local Static = require("engine.generator.map.Static")
	local data
	local old_map = gen.level.map
	local old_game_level = game.level
	
	game.level = gen.level
	local list = table.clone(gen.data.lesser_vaults_list or list)
	if gen.data.lesser_vaults_list_add then table.append(list, gen.data.lesser_vaults_list_add) end
	local vaultid, vnbr, vault

	--load the vault as a Static map
	local tries = 5 -- try multiple times to generate a vault in case some are not allowed
	repeat
		vaultid, vnbr = rng.table(list)
		if not vaultid then break end
		vault_map = engine.Map.new(max_w, max_h)
		gen.level.map = vault_map
		data = table.clone(gen.data)
		data.map = vault_exists("vaults/auto/lesser/"..vaultid) or vault_exists("vaults/"..vaultid) or vault_exists("vaults/auto/greater/"..vaultid)
		vault = data.map and Static.new(gen.zone, vault_map, gen.level, data)
		if vault then -- make sure the vault can be placed
			vault.name = vaultid
			if vault.unique == true then vault.unique = vaultid end
			local check, failure = gen:roomCheck(vault, gen.zone, old_game_level, old_map)
			if not check then
				table.insert(gen.map.room_map.rooms_failed, {room=vault, failure=failure or "roomcheck"})
				vault = nil table.remove(list, vnbr)
			end
		else table.remove(list, vnbr)
		end
		tries = tries - 1
	until vault or #list <= 0 or tries <= 0
	if vault then
		vault:generate(lev, old_lev)
		print("generated lesser_vault", vaultid)
		if config.settings.cheat then game.log("#GOLD#PLACED LESSER VAULT: %s", vaultid) end
	end
	game.level = old_game_level
	gen.level.map = old_map
	if not vault then print("lesser_vault could not generate a vault") return nil, "lesser_vault: no appropriate vaults found" end
	local w = vault_map.w
	local h = vault_map.h
	-- Convert it to a room, copying certain generation data
	return { name="lesser_vault-"..vaultid.."-"..w.."x"..h, w=w, h=h,
		onplace = vault.onplace,
		unique = vault.unique,
		border = vault.border or 1, -- by default, don't generate within 1 tile of another room
		no_tunnels = vault.no_tunnels,
		prefer_location = vault.prefer_location,
		rotate = vault.rotate,
		generator = function(self, x, y, is_lit)
			gen.level.vaults_list = gen.level.vaults_list or {}
			gen.level.vaults_list[#gen.level.vaults_list+1] = {x=x, y=y, w=w, h=h}
			local vaultuid = #gen.level.vaults_list

			gen.map:import(vault_map, x, y)
			-- Make the grids special by default to prevent tunnelling through
			for i = x, x + w - 1 do for j = y, y + h - 1 do
				gen.map.room_map[i][j].special = gen.map.room_map[i][j].special ~= false and true
				gen.map.room_map[i][j].room = gen.map.room_map[i][j].room ~= false and id
				gen.map.attrs(i, j, "no_decay", true)
				gen.map.attrs(i, j, "vault_id", vaultuid)
				if not gen.map.map[i + j*gen.map.w][Map.TERRAIN] then -- failsafe for undefined grids
					print("[lesser_vault] WARNING: replacing undefined tile for", vault.name, i, j)
					gen.map(i, j, Map.TERRAIN, gen:resolve(".") or engine.Grid.new({name = "undefined"}))
				end
				-- Creatures in vaults don't get to act until it is opened
				if not gen.map.attrs(i, j, "no_vaulted") and gen.map.room_map[i][j].add_entities then for _, rm in ipairs(gen.map.room_map[i][j].add_entities) do
					if rm[1] == "actor" then
						local act = rm[2]
						if act and not act.player then
							act:setEffect(act.EFF_VAULTED, 1, {})
						end
					end
				end end
			end end
			if vault.gen_map.startx and vault.gen_map.starty then
				if not gen.dont_add_vault_check then
					gen.spots[#gen.spots+1] = {x=vault.gen_map.startx + x, y=vault.gen_map.starty + y, check_connectivity=not vault.no_tunnels and "entrance", type="vault", subtype="lesser"}
				end
				return vault.gen_map.startx + x, vault.gen_map.starty + y
			end
		end,
		removed = function(self, lev, old_lev) -- clean up any uniques spawned if the vault can't be placed
			vault:removed(lev, old_lev)
		end
	}
end
