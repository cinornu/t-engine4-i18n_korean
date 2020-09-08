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

--local Birther = require "engine.Birther"
local Talents = require "engine.interface.ActorTalents"

--- General object resolver function (for Actors or other entities using the inventory interface)
-- creates a single object according to a filter, possibly equipping it
-- @param e: entity to resolve for (to which the object is added)
-- @param filter: filter to use when generating the object
-- @param do_wear: set true to wear the object if possible (Actors only), set false to not add the object to e
--		calls obj:wornLocations to find appropriate spots to wear
--		worn objects must be antimagic compatible with the wearing entity
-- @param tries: number of attempts allowed to generate the object, default 2 (5 if do_wear is set)
-- @return obj: the resolved object
--	Objects not worn are placed in main inventory (unless do_wear == false)
--	Objects are added to the game when resolved (affects uniques)
-- Additional filter fields interpreted by this resolver:
--		_use_object: object to use (skips random generation)
--		base_list: list of entities or specifier to load the list from a file (format: <classname>:<file path>)
--		defined: specific name (matching obj.DEFINE_AS) for an object
--		replace_unique (requires defined): filter to replace specific object if it cannot be generated
--			set true to use (most) fields from the main filter
--		random_art_replace (requires defined): table of parameters for replacement object when dropping as loot
--			chance: chance to drop in place of the unique object (previously existing uniques are always replaced)
--			filter: object filter for replacement object (defaults to a unique, non-lore object)
--		alter: a function(obj, e) to modify the object (called after generation, before adding to e)
--		check_antimagic: force checking antimagic compatibility
--		autoreq: set true to force gaining talents, stats, levels to equip the object (requires do_wear)
--		force_inven: force adding the object to this inventory id (requires do_wear, skips normal checks)
--		force_item: force adding the object to this inventory slot (requires do_wear, force_inven)
--		force_drop: always drop the object on death (by default, only uniques are dropped)
--		never_drop: never drop the object on death
-- Additional filter fields are interpreted by other functions that can affect equipment generation:
-- @see engine.zone:checkFilter: type, subtype, name, define_as, unique, properties, not_properties,
--		check_filter, special, max_ood
-- @see engine.zone:makeEntity: special_rarity
-- @see game.state:entityFilterAlter: force_tome_drops, no_tome_drops, tome, tome_mod
-- @see game.state:entityFilter: ignore_material_restriction, tome_mod, forbid_power_source, power_source
-- @see game.state:entityFilterPost: random_object
-- @see game.state:egoFilter: automatically creates/updates the ego_filter field to check power_source compatibility
function resolvers.resolveObject(e, filter, do_wear, tries)
	if do_wear then do_wear = e.__is_actor and do_wear end
	filter = filter and table.clone(filter) or {}
	tries = tries or do_wear and 5 or 2
	print("[resolveObject] CREATE FOR", e.uid, e.name, "do_wear/tries:", do_wear, tries, "filter:\n", (string.fromTable(filter, -1)))
	local o = filter._use_object
	if o then -- filter contains the object to use
		print("[resolveObject] using pre-generated object", o.uid, o.name)
	else
		--print("[resolveObject]", e.name, "filter:", filter) table.print(filter, "\t")
		local base_list
		if filter.base_list then -- load the base list defined for makeEntityByName
			if type(filter.base_list) == "table" then base_list = filter.base_list
			else
				local _, _, class, file = filter.base_list:find("(.*):(.*)")
				if class and file then
					base_list = require(class):loadList(file)
					if base_list then
						base_list.__real_type = "object"
					else
						print("[resolveObject] COULD NOT LOAD base_list:", filter.base_list)
					end
				end
			end
			filter.base_list = nil
		end
		repeat
			local ok = true
			tries = tries - 1
			if filter.defined then -- make a specific object
				local forced
				o, forced = game.zone:makeEntityByName(game.level, base_list or "object", filter.defined, filter.random_art_replace and true or false)
				if forced then -- If generation was forced, object is a previously existing unique
					print("[resolveObject] FORCING UNIQUE (replaced on drop):", filter.defined, o.uid, o.name)
					table.set(filter, "random_art_replace", "chance", 100)
				elseif not o and filter.replace_unique then -- Replace with another object
					local rpl_filter = filter.replace_unique
					if type(rpl_filter) ~= "table" then
						rpl_filter = table.clone(filter)
						rpl_filter.ignore_material_restriction, rpl_filter.defined, rpl_filter.replace_unique = true, nil, nil
					end
					o = game.zone:makeEntity(game.level, base_list or "object", rpl_filter, nil, true)
					if o then print("[resolveObject] REPLACING UNIQUE:", filter.defined, o.uid, o.name)
					end
				end
				if not o then break end
			else -- make an object using the normal probabilities after applying the filter
				o = game.zone:makeEntity(game.level, base_list or "object", filter, nil, true)
			end
			-- check for incompatible equipment
			if (do_wear or filter.check_antimagic) and not game.state:checkPowers(e, o, nil, "antimagic_only") then
				ok = false
				print("[resolveObject] for ", e.uid, e.name ," -- incompatible equipment ", o.name, "retrying", tries, "self.not_power_source:", e.not_power_source and table.concat(table.keys(e.not_power_source), ","), "filter forbid ps:", filter.forbid_power_source and table.concat(table.keys(filter.forbid_power_source), ","), "vs ps", o.power_source and table.concat(table.keys(o.power_source), ","))
			end
		until o and ok or tries <= 0
	end

	if o then
		print("[resolveObject] CREATED OBJECT:", o.uid, o.name, "tries left:", tries)
		if filter.alter then filter.alter(o, e) end
		-- curse (done here to ensure object attributes get applied correctly, good place for a talent callback?)
		if do_wear ~= false and e.knowTalent and e:knowTalent(e.T_DEFILING_TOUCH) then
			e:callTalent(e.T_DEFILING_TOUCH, "curseItem", o)
		end

		if do_wear then
			if filter.autoreq then -- Auto alloc talents, stats, and levels to be able to wear the object
				local req, oldreq = e:updateObjectRequirements(o)
				if req then
					if req.level and e.level < req.level then
						print("[resolveObject] autoreq: LEVELUP to", req.level)
						e:forceLevelup(req.level)
					end
					if req.talent then -- learn (forced) talents first (may affect stats)
						for _, tid in ipairs(req.talent) do
							local levls = 0
							if type(tid) == "table" then
								levls = tid[2] - e:getTalentLevelRaw(tid[1])
								if levls > 0 then
									print("[resolveObject] autoreq: LEARNING TALENT", tid[1], levls)
									e:learnTalent(tid[1], true, levls)
								end
							else
								if not e:knowTalent(tid) then
									levls = 1
									print("[resolveObject] autoreq: LEARNING TALENT", tid)
									e:learnTalent(tid, true, levls)
								end
							end
							if levls > 0 then
								local tal = e:getTalentFromId(tid[1])
								if tal and tal.generic then e.unused_generics = e.unused_generics - levls else e.unused_talents = e.unused_talents - levls end
							end
						end
					end
					if req.stat then
						for s, v in pairs(req.stat) do
							local gain = v - e:getStat(s)
							if gain > 0 then
								print("[resolveObject] autoreq: GAINING STAT", s, gain)
								e.unused_stats = e.unused_stats - gain
								e:incStat(s, gain)
							end
						end
					end
				end
				o.require = oldreq
			end

			local worn, invens
			-- select inventories where object may be worn
			if filter.force_inven then
				invens = e:getInven(filter.force_inven)
				if invens then invens = {{inv=invens, slot=filter.force_item, force=true}} end
			else
				 -- checks inventory equipment filters, sorts possible locations by object "power"
				invens = o:wornLocations(e, nil, nil)
			end
			if invens then
				for i, worn_inv in ipairs(invens) do
					--print("[resolveObject] trying inventory", worn_inv.inv.name, worn_inv.slot, "for", o.uid, o.name, worn_inv.force and "FORCED" or "unforced")
					worn = e:wearObject(o, true, false, worn_inv.inv, worn_inv.slot)
					if worn == false then
						if worn_inv.force then  -- force adding the object
							print("[resolveObject]", o.uid, o.name, "FORCING INVENTORY", worn_inv.inv.name, worn_inv.inv.id, "slot", worn_inv.slot)
							local ro = e:removeObject(worn_inv.inv, worn_inv.slot or 1)
							e:addObject(worn_inv.inv, o, true, worn_inv.slot)
							if ro and e:addObject(e.INVEN_INVEN, ro) then  -- replaced object to main inventory
								print("\t\t moved replaced object to main inventory:", ro.uid, ro.name)
							end
							worn = true break
						else
							print("[resolveObject]", o.uid, o.name, "NOT WORN in", worn_inv.name, worn_inv.id)
						end
					else
						print("[resolveObject]", o.uid, o.name, "added to inventory", worn_inv.inv.name)
						 --put a replaced object in main inventory
						if type(worn) == "table" and e:addObject(e.INVEN_INVEN, worn) then
							print("\t\t moved replaced object to main inventory:", worn.uid, worn.name)
						end	
						break
					end
				end
			end
			if not worn then print("[General Object resolver]", o.uid, o.name, "COULD NOT BE WORN") end
		end
		-- if not worn, add to main inventory unless do_wear == false
		if do_wear ~= false then
			if not o.wielded then
				print("[resolveObject] adding to main inventory:", o.uid, o.name)
				e:addObject(e.INVEN_INVEN, o)
			end
			game.zone:addEntity(game.level, o, "object") -- updates uniques list to prevent duplicates
		end

		-- Set the object drop status (only drop uniques by default)
		if not o.unique then o.no_drop = true end
		if filter.force_drop then o.no_drop = false end
		if filter.never_drop then o.no_drop = true end

		if filter.random_art_replace then
			o.__special_boss_drop = filter.random_art_replace
		end
	else
		print("[resolveObject] **FAILED** for", e.uid, e.name, "filter:", (string.fromTable(filter, 2)))
--		game.log("[%s] %s #YELLOW_GREEN#Object resolver FAILED#LAST# \n#AQUAMARINE#filter:%s#LAST#", e.uid, e.name, string.fromTable(filter, 2)) -- debugging
	end
	return o
end

--- Resolves equipment creation for an actor
-- @param t a table of object filters (resolvers.resolveObject is called for each)
--	additional filter fields interpreted:
--		id: identify the object
-- Objects that cannot be equipped are added to main inventory instead
function resolvers.equip(t)
	return {__resolver="equip", __resolve_last=true, t, _allow_random_boss=true}
end

--- Resolves equipment creation for an actor at birth (ignores material restrictions)
function resolvers.equipbirth(t)
	for i, filter in ipairs(t) do
		filter.ignore_material_restriction = true
	end
	return {__resolver="equip", __resolve_last=true, t, _allow_random_boss=true}
end

--- Actually create and equip objects
--  Creates the objects according to the filters and equips them if possible
-- @param t the resolver table created by resolvers.equip
-- @param e the entity (Actor) to add the equipment to
function resolvers.calc.equip(t, e)
	-- Iterate over object filters, trying to create and equip each
	for i, filter in ipairs(t[1]) do
		--print("[resolvers.equip]", e.uid, e.name, (string.fromTable(filter, 1)))
		local o = resolvers.resolveObject(e, filter, true, 5)
		if o then
			o._resolver_type = t.__resolver
			if t[1].id then o:identify(t[1].id) end
		end
	end
	return nil -- Deletes the origin field
end

--- Sets filters by inventory name controlling which objects may be automatically equipped by an entity (Actor)
-- Actors (NPCs) will not auto equip items that don't pass the filter (or removed any equipped items)
-- @see Object:wornLocations
-- @param[1] t: a table of filters indexed by inventory name, format:
--		{[inven_def.name1] = {equipment filter 1}, [inven_def.name2] = {equipment filter 2}, ...}
--		filter.ignore_material_restriction and filter.allow_uniques are set true if not defined
--	Use the e._equipping_entity variable set by Object:wornLocations for the equipping actor within filter special functions
-- @param[2] t: a string matching the name of a Birther subclass ("Rogue", "Bulwark", ...)
--		the autoequip filters for the subclass will be copied
-- @param readonly set true to prevent the inventory filters from being overwritten by later applications
function resolvers.auto_equip_filters(t, readonly)
	return {__resolver="auto_equip_filters", __resolve_instant=true, t, readonly=readonly, _allow_random_boss=true}
end

--- Resolves the auto-equip filters for an actor by inventory slot
--function resolvers.calc.auto_equip_filters(t, e, readonly)
function resolvers.calc.auto_equip_filters(t, e, readonly)
	local filters = t[1]
	if type(filters) == "string" then -- get subclass filters
		local c_name, ok = filters
		local cc = table.get(engine.Birther.birth_descriptor_def, "subclass", c_name, "copy")
		if cc then
			 print("[resolvers.auto_equip_filters] using birth descriptor for subclass:", c_name)
			for i, res in ipairs(cc) do
				if type(res) == "table" and res.__resolver == "auto_equip_filters" then
					res = table.clone(res, true)
					res.readonly = t.readonly or res.readonly
					resolvers.calc.auto_equip_filters(res, e) ok = true
				end
			end
		end
		if not ok then print("[resolvers.auto_equip_filters] NO BIRTH auto_equip_filter for subclass:", c_name) end
		return
	end
	for inv, filter in pairs(filters) do
		local inven = e:getInven(inv)
		if inven then
			if not inven.auto_equip_filter or not inven.auto_equip_filter.readonly then
				local aef = table.clone(filter, true)
				if aef.ignore_material_restriction == nil then aef.ignore_material_restriction = true end
				if aef.allow_uniques == nil then aef.allow_uniques = true end
				aef.readonly = t.readonly
				inven.auto_equip_filter = aef
			end
		end
	end
end

--- Resolves tinkers and attaches them to appropriate worn objects if possible
-- @param t a table of object filters (resolvers.resolveObject is called for each)
--	additional filter fields interpreted:
--		keep_object: place the tinker in main inventory if not attached (default is to discard it)
--		id: identify the tinker
-- a tinker already attached to the worn object is automatically placed in main inventory
function resolvers.attachtinker(t)
	return {__resolver="attachtinker", __resolve_last=true, t, keep_object=t.keep_object, _allow_random_boss=true}
end

--- As resolvers.attachtinker but ignores material restrictions
function resolvers.attachtinkerbirth(t)
	for i, filter in ipairs(t) do
		filter.ignore_material_restriction = true
	end
	return {__resolver="attachtinker", __resolve_last=true, t, _allow_random_boss=true}
end

--- Actually create and attach the tinker
-- @param t the resolver table created by resolvers.attachtinker
-- @param e the entity (Actor) to add the tinker to
function resolvers.calc.attachtinker(t, e)
	-- Iterate over object filters, trying to create and attach each
	for i, filter in ipairs(t[1]) do
		--print("[resolvers.attachtinker]", e.uid, e.name, (string.fromTable(filter, 1)))
		local o = resolvers.resolveObject(e, filter, false, 5)
		if o then
			o._resolver_type = t.__resolver
			--print("[resolvers.attachtinker] created tinker:", o.uid, o:getName())
			local base_inven, base_item = e:findTinkerSpot(o)
			local base_o = base_inven and base_item and base_inven[base_item]
			local ok
			if base_o then
				ok = e:doWearTinker(nil, nil, o, base_inven, base_item, base_o, true)
				if t[1].id then o:identify(t[1].id) end
				print("[resolvers.attachtinker]", o.uid, o.name, ok and "ATTACHED:" or "FAILED TO ATTACH:", base_inven.name, base_item, base_o and base_o:getName())
			else
				print("[resolvers.attachtinker]", o.uid, o.name, "No tinker attach spot", base_inven, base_item)
			end
			if not ok then
				if (t.keep_object or filter.keep_object) and e:addObject(e.INVEN_INVEN, o) then
					print("    --- added to main inventory") ok = true 
				end
			end
			if ok then game.zone:addEntity(game.level, o, "object") end -- updates uniques list to prevent duplicates		
		end
	end
	return nil -- Deletes the origin field
end

--- Resolves inventory creation for an actor
--  Similar to resolvers.equip, but places each object in a specific inventory slot
--  No checks are made for wearability (worn objects will not be replaced)
-- @param t a table of object filters (resolvers.resolveObject is called for each)
--	additional filter fields interpreted:
--		inven: inventory id of the inventory to add to (defaults to t.inven or main inventory)
--		keep_object: set true to try main inventory if the object cannot be added to the specified inventory
--		id: identify the object (defaults to t.id)
--		transmo: set true to designate the object for transmutation (defaults to t.transmo or nil)
function resolvers.inventory(t)
	return {__resolver="inventory", __resolve_last=true, t, _allow_random_boss=true}
end

--- Resolves inventory creation for an actor at birth (ignores material restrictions)
function resolvers.inventorybirth(t)
	for i, filter in ipairs(t) do
		filter.ignore_material_restriction = true
	end
	return {__resolver="inventory", __resolve_last=true, t, _allow_random_boss=true}
end

--- Actually resolve the inventory creation
-- @param t the resolver table created by resolvers.inventory
-- @param e the entity (Actor) to add the objects to
function resolvers.calc.inventory(t, e)
	-- Iterate over object requests, try to create them and add them
	for i, filter in ipairs(t[1]) do
		--print("[resolvers.inventory]", e.uid, e.name, (string.fromTable(filter, 1)))
		local o = resolvers.resolveObject(e, filter, false)
		
		if o then
			o._resolver_type = t.__resolver
			local inven = filter.inven or t[1].inven
			print("[resolvers.inventory] created object:", o.uid, o:getName(), "inventory:", inven, "keep:", filter.keep_object)
			if inven then inven = e:getInven(inven) or filter.keep_object and e.INVEN_INVEN
			else inven = e.INVEN_INVEN
			end
			if inven then
				local id = t[1].id
				if filter.id ~= nil then id = filter.id end
				if e:addObject(inven, o) or filter.keep_object and inven.id ~= e.INVEN_INVEN and e:addObject(e.INVEN_INVEN, o) then
					game.zone:addEntity(game.level, o, "object")
					if id ~= nil then o:identify(id) end
					if filter.transmo or t[1].transmo then o.__transmo = true end
				else
					print("[resolvers.inventory] created object:", o.uid, o:getName(), "NOT ADDED")
				end
			end
		end
	end
	return nil -- Delete the origin field
end

--- Resolves drops creation for an actor
-- 	Places objects in main inventory and marks them to be dropped on death
-- @param t a table of object filters to be randomly selected from (resolvers.resolveObject is called for each)
-- 	additional fields for t:
--		chance = percent chance for drops (all or none, default 100)
--		nb = number of drops (default 1)
--		id: set the identify status of each object
function resolvers.drops(t)
	return {__resolver="drops", __resolve_last=true, t, _allow_random_boss=true}
end

--- Actually resolve the drops creation adding each object to main inventory
-- @param t the resolver table created by resolvers.drops
-- @param e the entity (Actor) to add the objects to
function resolvers.calc.drops(t, e)
	t = t[1]
	if not rng.percent(t.chance or 100) then return nil end
	if t.check and not t.check(e) then return nil end

	-- Iterate over object requests, adding each object to main inventory and marking it to be dropped
	for i = 1, (t.nb or 1) do
		local filter = table.clone(t[rng.range(1, #t)])
		-- Make sure if we request uniques we do not get lore, it would be kinda deceptive
		if filter.unique then
			filter.not_properties = filter.not_properties or {}
			filter.not_properties[#filter.not_properties+1] = "lore"
		end
		--print("[resolvers.drops]", e.uid, e.name, (string.fromTable(filter, 1)))
		local o = resolvers.resolveObject(e, filter, nil)
		
		if o then
			o._resolver_type = "drops"
			o.no_drop = false -- make sure it is dropped
			if t.id ~= nil then o:identify(t.id) end
		end
	end
	return nil -- Deletes the origin field
end

-- Resolves material level based on actor level
-- @param base = base value at level = base_level (scales as sqrt)
-- @param spread = number of std deviations (1 usually) in material level
-- @param min, max = material level limits
function resolvers.matlevel(base, base_level, spread, mn, mx)
	return {__resolver="matlevel", base, base_level, spread, mn, mx}
end
function resolvers.calc.matlevel(t, e)
	local mean = math.min(e.level/10+1,t[1] * (e.level/t[2])^.5) -- material level scales up with sqrt of actor level or level/10
	local spread = math.max(t[3],mean/5) -- spread out probabilities at high level
	local mn = t[4] or 1
	local mx = t[5] or 5
	
	local rand = math.floor(rng.normalFloat(mean,spread))
	return util.bound(rand,mn,mx)
end

-- Estimate actor final level for drop calculations (.__resolve_last does not work)
local function actor_final_level(e)
	local finlevel = math.max(math.max(e.level,e.start_level),1)
	if game.zone.actor_adjust_level and e.forceLevelup then
		return math.max(finlevel, game.zone:actor_adjust_level(game.level, e) + e:getRankLevelAdjust())
	else
		return math.max(finlevel, game.zone.base_level + e:getRankLevelAdjust())
	end
end

--- Creates a randart and adds it to inventory (to be dropped on death)
-- 	@param t table of data to generate the randart:
--	@field t._use_object: object to use (bypasses random generation)
--	@field t.filter: optional filter for the base object
--		(defaults to a random, plain object with material level 2 or more)
-- 	@field t.data: data to pass to game.state:generateRandart
--		(defaults to {lev=resolvers.current_level})
-- 	@field t.id: set to identify the randart
--	@field t.no_add: set true to not add the randart to inventory (return it instead when resolved)
function resolvers.drop_randart(t)
	return {__resolver="drop_randart", __resolve_last=true, t, _allow_random_boss=true}
end

--- Actually resolve the randart
-- @param t the resolver table created by resolvers.drop_randart
-- @param e the entity (Actor) to add the randart to
function resolvers.calc.drop_randart(t, e)
	t = t[1]
	local o = t._use_object
	if not o then
		local data = t.data or {lev=resolvers.current_level}
		if not data.base then -- generate a base object
			local filter = t.filter
			if not filter then
				local matresolver = resolvers.matlevel(5,50,1,2) -- Min material level 2
				filter = {ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true, ego_chance=-1000}, special=function(eq)
					local matlevel = resolvers.calc.matlevel(matresolver,{level = actor_final_level(e)})
					return (not eq.unique and eq.randart_able) and eq.material_level == matlevel and true or false
				end}
			end
			print("[resolvers.drop_randart]", e.uid, e.name, "generating base object using filter:", (string.fromTable(filter, 1)))
			data.base = resolvers.resolveObject(e, filter, false, 5)
		end
		print("[resolvers.drop_randart]", e.uid, e.name, "using data:", (string.fromTable(data, 2)))
		o = game.state:generateRandart(data)
	end
	if o then
		o._resolver_type = "drop_randart"
		o.no_drop = false
		if t.id then o:identify(t.id) end
		if t.no_add then
			return o
		else
			e:addObject(e.INVEN_INVEN, o)
			game.zone:addEntity(game.level, o, "object")
		end
	end
end

--- Resolves drops creation for an actor
function resolvers.store(def, faction, door, sign)
	return {__resolver="store", def, faction, door, sign}
end
--- Actually resolve the drops creation
function resolvers.calc.store(t, e)
	if t[3] then
		e.image = t[3]
		if t[4] then e.add_mos = {{display_x=0.6, image=t[4]}} end
	end

	e.store_faction = t[2]
	t = t[1]

	e.block_move = function(self, x, y, who, act, couldpass)
		if who and who.player and act then
			if self.store_faction and who:reactionToward({faction=self.store_faction}) < 0 then return true end
			self.store:loadup(game.level, game.zone)
			self.store:interact(who, self:getName())
		end
		return true
	end
	e.store = game:getStore(t)
	e.store.faction = e.store_faction
--	print("[STORE] created for entity", t, e, e.name)

	-- Delete the origin field
	return nil
end

--- Resolves chat creation for an actor
function resolvers.chatfeature(def, faction)
	return {__resolver="chatfeature", def, faction}
end
--- Actually resolve the chat creation
function resolvers.calc.chatfeature(t, e)
	e.chat_faction = t[2]
	t = t[1]

	if e.chat_faction then
		e.chat_display_entity = engine.Entity.new{image="faction/"..e.chat_faction..".png"}
	end

	e.block_move = function(self, x, y, who, act, couldpass)
		if who and who.player and act then
			if self.chat_faction and who:reactionToward({faction=self.chat_faction}) < 0 then return true end
			local Chat = require("engine.Chat")
			local chat = Chat.new(self.chat, self, who, {npc=self, player=who})
			chat:invoke()
		end
		return true
	end
	e.chat = t

	-- Delete the origin field
	return nil
end

--- Random bonus based on level (sets the mbonus max level, we use 60 instead of 50 to get some forced randomness at high level)
resolvers.mbonus_max_level = 90

--- Random bonus based on level and material quality
resolvers.current_level = 1
function resolvers.mbonus_material(max, add, pricefct)
	return {__resolver="mbonus_material",  __resolve_instant=true, max, add, pricefct}
end
function resolvers.calc.mbonus_material(t, e)
	local ml = e.effective_ego_material_level or e.material_level or 1
	local v = math.ceil(rng.mbonus(t[1], resolvers.current_level, resolvers.mbonus_max_level) * ml / 5) + (t[2] or 0)

	if e.cost and t[3] then
		local ap, nv = t[3](e, v)
		e.cost = e.cost + ap
		v = nv or v
	end

	if e.ego_bonus_mult then
		if v >= 1 then
			v = math.ceil(v * (1 + e.ego_bonus_mult))
		else
			v = v * (1 + e.ego_bonus_mult)
		end
	end

	return v
end

--- Random bonus based on level, more strict
resolvers.current_level = 1
function resolvers.mbonus_level(max, add, pricefct, step)
	return {__resolver="mbonus_level",  __resolve_instant=true, max, add, step or 10, pricefct}
end
function resolvers.calc.mbonus_level(t, e)
	local max = resolvers.mbonus_max_level

	local ml = 1 + math.floor((resolvers.current_level - 1) / t[3])
	ml = util.bound(rng.float(ml, ml * 1.6), 1, 6)

	local maxl = 1 + math.floor((max - 1) / t[3])
	local power = 1 + math.log10(ml / maxl)

	local v = math.ceil(rng.mbonus(t[1], resolvers.current_level, max) * power) + (t[2] or 0)

	if e.cost and t[4] then
		local ap, nv = t[4](e, v)
		e.cost = e.cost + ap
		v = nv or v
	end

	return v
end

--- Random bonus based on level
resolvers.current_level = 1
function resolvers.mbonus(max, add, pricefct)
	return {__resolver="mbonus",  __resolve_instant=true, max, add, pricefct}
end
function resolvers.calc.mbonus(t, e)
	local v = rng.mbonus(t[1], resolvers.current_level, resolvers.mbonus_max_level) + (t[2] or 0)

	if e.cost and t[3] then
		local ap, nv = t[3](e, v)
		e.cost = e.cost + ap
		v = nv or v
	end

	return v
end

-- bonus scaled up or down with current level (default 0.75 power) with minimum and random factor
-- base = base value at level = base_level
-- spread = random deviation from calculated value
-- result is (base +/- spread)*(current_level/base_level)^power
-- min = optional minimum value
function resolvers.clscale(base, base_level, spread, power, min)
	return {__resolver="clscale",  __resolve_instant=true, base, base_level, spread, power or 0.75, min}
end
function resolvers.calc.clscale(t, e)
	return math.max(math.ceil((t[1] + (t[3] and rng.range(-t[3],t[3]) or 0))*(resolvers.current_level/t[2])^t[4]),t[5] or t[1])
end

--- Generic resolver, takes a function, executes at the end
function resolvers.genericlast(fct)
	return {__resolver="genericlast", __resolve_last=true, fct}
end
function resolvers.calc.genericlast(t, e, ...)
	return t[1](e, ...)
end

--- Charges resolver, gives a random use talent
function resolvers.random_use_talent(types, power)
	types = table.reverse(types)
	return {__resolver="random_use_talent", __resolve_last=true, types, power}
end
function resolvers.calc.random_use_talent(tt, e)
	local ml = e.effective_ego_material_level or e.material_level or 1
	local ts = {}
	for i, t in ipairs(engine.interface.ActorTalents.talents_def) do
		if t.random_ego and tt[1][t.random_ego] and t.type[2] < ml then ts[#ts+1]=t.id end
	end
	local tid = rng.table(ts) or engine.interface.ActorTalents.T_SENSE
	local t = engine.interface.ActorTalents.talents_def[tid]
	local level = util.bound(math.ceil(rng.mbonus(5, resolvers.current_level, resolvers.mbonus_max_level) * ml / 5), 1, 5)
	e.cost = e.cost + t.type[2] * 3 * level
	e.recharge_cost = t.type[2] * 3 * level
	return { id=tid, level=level, power=tt[2] }
end

--- Charms resolver
-- @param desc = power description (function or string) %d will be filled with self:getCharmPower(who)
-- @param cd = cooldown
-- @param fct = function(self, who) called when activated
-- @param tcd = talent id to put on cooldown when used <"T_GLOBAL_CD">
-- @param use_params = parameters to merge into self.use_power table
function resolvers.charm(desc, cd, fct, tcd, use_params)
	return {__resolver="charm", __resolve_last=true, desc, cd, fct, tcd, use_params}
end
function resolvers.calc.charm(tt, e)
	local cd = tt[2]
	e.max_power = cd
	e.power = e.max_power
	e.use_power = table.merge(e.use_power or {}, {name=tt[1], power=cd, use=tt[3], __no_merge_add=true})
	if e.talent_cooldown == nil then e.talent_cooldown = tt[4] or "T_GLOBAL_CD" end
	if tt[5] then table.merge(e.use_power, tt[5], true) end
	return
end

--- Charms talent resolver
-- @param tid = talent id
-- @param tlvl = (raw) talent level (mastery is based on user)
-- @param cd = cooldown
-- @param tcd = talent id to put on cooldown when used <"T_GLOBAL_CD">
-- @param use_params = parameters to merge into self.use_talent table
function resolvers.charmt(tid, tlvl, cd, tcd, use_params)
	return {__resolver="charmt", __resolve_last=true, tid, tlvl, cd, tcd, use_params}
end
function resolvers.calc.charmt(tt, e)
	local cd = tt[3]
	e.max_power = cd
	e.power = e.max_power
	local lvl = util.getval(tt[2], e)
	e.use_talent = {id=tt[1], power=cd, level=lvl, __no_merge_add=true}
	if e.talent_cooldown == nil then e.talent_cooldown = tt[4] or "T_GLOBAL_CD" end
	if tt[5] then table.merge(e.use_talent, tt[5], true) end
	return
end

--- Image based on material level
function resolvers.image_material(image, values)
	return {__resolver="image_material", image, values}
end
function resolvers.calc.image_material(t, e)
	if not t[2] or (type(t[2]) == "string" and t[2] == "metal") then t[2] = {"iron", "steel", "dsteel", "stralite", "voratun"} end
	if type(t[2]) == "string" and t[2] == "sea-metal" then t[2] = {"coral", "bluesteel", "deepsteel", "orite", "orichalcum"} end
	if type(t[2]) == "string" and t[2] == "leather" then t[2] = {"rough", "cured", "hardened", "reinforced", "drakeskin"} end
	if type(t[2]) == "string" and t[2] == "wood" then t[2] = {"elm","ash","yew","elvenwood","dragonbone"} end
	if type(t[2]) == "string" and t[2] == "nature" then t[2] = {"mossy","vined","thorned","pulsing","living"} end
	if type(t[2]) == "string" and t[2] == "cloth" then t[2] = {"linen","woollen","cashmere","silk","elvensilk"} end
	local ml = e.effective_ego_material_level or e.material_level or 1
	return "object/"..t[1].."_"..t[2][ml]..".png"
end

--- Moddable Image based on material level
function resolvers.moddable_tile(image, values)
	return {__resolver="moddable_tile", image}
end
function resolvers.calc.moddable_tile(t, e)
	local slot = t[1]
	local r, r2
	if slot == "cloak" then r = {"cloak_%s_07","cloak_%s_08","cloak_%s_08","cloak_%s_09","cloak_%s_09"}
	elseif slot == "massive" then
		r = {"upper_body_20","upper_body_21","upper_body_22","upper_body_24","upper_body_23",}
		r2 = {"lower_body_09","lower_body_10","lower_body_11","lower_body_13","lower_body_12",}
	elseif slot == "heavy" then
		r = {"upper_body_25","upper_body_11","upper_body_26","upper_body_28","upper_body_27",}
		r2 = {"lower_body_16","lower_body_08","lower_body_17","lower_body_18","lower_body_19",}
	elseif slot == "light" then
		r = {"upper_body_29","upper_body_30","upper_body_31","upper_body_32","upper_body_33",}
		r2 = {"lower_body_03","lower_body_04","lower_body_05","lower_body_14","lower_body_15",}
	elseif slot == "robe" then r = {"upper_body_34","upper_body_35","upper_body_36","upper_body_37","upper_body_38",}
	elseif slot == "shield" then r = {"%s_hand_10_01","%s_hand_11_01","%s_hand_11_02","%s_hand_12_01","%s_hand_12_02",}
	elseif slot == "staff" then r = {"%s_hand_08_01", "%s_hand_08_03", "%s_hand_08_02", "%s_hand_08_04", "%s_hand_08_05"} -- 03 & 02 are reversed due to an error in gfx, don't change it!
	elseif slot == "leather_boots" then r = {"feet_04","feet_10","feet_10","feet_11","feet_11",}
	elseif slot == "heavy_boots" then r = {"feet_06","feet_06","feet_07","feet_09","feet_08",}
	elseif slot == "gauntlets" then r = {"hands_03","hands_04","hands_05","hands_07","hands_06",}
	elseif slot == "gloves" then r = {"hands_02","hands_02","hands_08","hands_08","hands_09"}
	elseif slot == "sword" then r = {"%s_hand_04_01", "%s_hand_04_02", "%s_hand_04_03", "%s_hand_04_04", "%s_hand_04_05"}
	elseif slot == "2hsword" then r = {"%s_2hsword_01", "%s_2hsword_02", "%s_2hsword_03", "%s_2hsword_04", "%s_2hsword_05"}
	elseif slot == "wizard_hat" then r = {"head_21","head_21","head_22","head_22","head_23"}
	elseif slot == "trident" then r = {"%s_hand_13_01", "%s_hand_13_02", "%s_hand_13_03", "%s_hand_13_04", "%s_hand_13_05"}
	elseif slot == "whip" then r = {"%s_hand_09"}
	elseif slot == "mace" then r = {"%s_hand_05_01", "%s_hand_05_02", "%s_hand_05_03", "%s_hand_05_04", "%s_hand_05_05"}
	elseif slot == "2hmace" then r = {"%s_2hmace_01", "%s_2hmace_02", "%s_2hmace_03", "%s_2hmace_04", "%s_2hmace_05"}
	elseif slot == "axe" then r = {"%s_hand_06_01", "%s_hand_06_02", "%s_hand_06_03", "%s_hand_06_04", "%s_hand_06_05"}
	elseif slot == "2haxe" then r = {"%s_2haxe_01", "%s_2haxe_02", "%s_2haxe_03", "%s_2haxe_04", "%s_2haxe_05"}
	elseif slot == "bow" then r = {"%s_hand_01_01", "%s_hand_01_02", "%s_hand_01_03", "%s_hand_01_04", "%s_hand_01_05"}
	elseif slot == "sling" then r = {"%s_hand_02_01", "%s_hand_02_02", "%s_hand_02_03", "%s_hand_02_04", "%s_hand_02_05"}
	elseif slot == "dagger" then r = {"%s_hand_03_01", "%s_hand_03_02", "%s_hand_03_03", "%s_hand_03_04", "%s_hand_03_05"}
	elseif slot == "mindstar" then r = {{"mindstar_mossy_%s_01",true},{"mindstar_vines_%s_01",true},{"mindstar_thorn_%s_01",true},{"mindstar_pulsing_%s_01",true},{"mindstar_living_%s_01",true},}
	elseif slot == "helm" then r = {"head_05","head_06","head_08","head_10","head_09",}
	elseif slot == "leather_cap" then r = {"head_03","head_03","head_19","head_19","head_20"}
	elseif slot == "mummy_wrapping" then r = {{"special/mummy_wrappings",true}}
	elseif slot == "quiver" then r = {"quiver_01","quiver_02","quiver_03","quiver_04","quiver_05"}
	elseif slot == "shotbag" then r = {"shotbag_01","shotbag_02","shotbag_03","shotbag_04","shotbag_05"}
	elseif slot == "gembag" then r = {"gembag_01","gembag_02","gembag_03","gembag_04","gembag_05"}
	end
	if not r then return end
	local ml = e.effective_ego_material_level or e.material_level or 1
	r = r[util.bound(ml, 1, #r)]
	if r2 then
		r2 = r2[util.bound(ml, 1, #r2)]
		e.moddable_tile2 = r2
	end
	if type(r) == "string" then return r else e.moddable_tile_big = true return r[1] end
end

--- Activates all sustains at birth
function resolvers.sustains_at_birth()
	return {__resolver="sustains_at_birth", __resolve_last=true}
end
function resolvers.calc.sustains_at_birth(_, e)
	e.on_added = function(self)
		for tid, _ in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and t.mode == "sustained" and not self:isTalentActive(tid) then
				self.energy.value = game.energy_to_act
				self:useTalent(tid, nil, nil, nil, nil, true)
			end
		end
	end
end

--- Registers callbacks on the actor itself
function resolvers.register_callbacks(list)
	return {__resolver="register_callbacks", __resolve_last=true, list}
end
function resolvers.calc.register_callbacks(t, e)
	e.__self_callbacks = t[1]
	e:registerCallbacks(e.__self_callbacks, e, "self")
end

--- Help creating randarts
function resolvers.randartmax(v, max)
	return {__resolver="randartmax", v=v, max=max}
end
function resolvers.calc.randartmax(t, e)
	return t.v
end

--- Inscription resolver
function resolvers.inscription(name, data, force_id)
	return {__resolver="inscription", name, data, force_id, _allow_random_boss=true}
end
function resolvers.calc.inscription(t, e)
	e:setInscription(t[3] or nil, t[1], t[2], false, false, nil, true, true)
	return nil
end

--- Random inscription resolver
local inscriptions_max = {
	heal = 1,
	protect = 1,
	attack = 1,  -- Reduce instant cast NPC bursts
	movement = 1,
	utility = 6,
	teleport = 0, -- Annoying
}

function resolvers.inscriptions(nb, list, kind, ignore_limits)
	return {__resolver="inscriptions", nb, list, kind, ignore_limits, _allow_random_boss=true}
end
function resolvers.calc.inscriptions(t, e)
	local kind = nil
	if not t[4] then
		if t[3] then
			kind = function(o)
				if 	o.inscription_kind == t[3] and
					(e.__npc_inscription_kinds[o.inscription_kind] or 0) < (inscriptions_max[o.inscription_kind] or 0)
					then return true
				end return false
			end
		else
			kind = function(o)
				if 	(e.__npc_inscription_kinds[o.inscription_kind] or 0) < (inscriptions_max[o.inscription_kind] or 0)
					then return true
				end return false
			end
		end
	end

	e.__npc_inscription_kinds = e.__npc_inscription_kinds or {}
	for i = 1, t[1] do
		local o
		if type(t[2]) == "table" then
			if #t[2] > 0 then
				local name = rng.tableRemove(t[2])
				if not name then return nil end
				o = game.zone:makeEntity(game.level, "object", {special=kind, name=name}, nil, true)
			else
				o = game.zone:makeEntity(game.level, "object", {special=kind, type="scroll"}, nil, true)
			end
		else
			o = game.zone:makeEntity(game.level, "object", {special=kind, type="scroll", subtype=t[2]}, nil, true)
		end
		if o and o.inscription_talent and o.inscription_data then
			o.inscription_data.use_any_stat = 0.5 -- Cheat a bit to scale inscriptions nicely
			o.inscription_data.cooldown = math.ceil(o.inscription_data.cooldown * 1.6)
			e:setInscription(nil, o.inscription_talent, o.inscription_data, false, false, nil, true, true)
			e.__npc_inscription_kinds[o.inscription_kind] = (e.__npc_inscription_kinds[o.inscription_kind] or 0) + 1
		end
	end
	return nil
end

--- Tactical settings made easy
function resolvers.tactic(name)
	return {__resolver="tactic", name}
end
function resolvers.calc.tactic(t, e)
	if t[1] == "default" then return {type="default", }
	elseif t[1] == "standby" then return {type="standby", standby=1}
	elseif t[1] == "melee" then return {type="melee", attack=2, attackarea=2, disable=2, escape=0, closein=2, go_melee=1}
	elseif t[1] == "ranged" then return {type="ranged", disable=1.5, escape=1.5, closein=0, defend=2, heal=2, safe_range=2}
	elseif t[1] == "tank" then return {type="tank", disable=3, escape=0, closein=2, defend=2, protect=2, heal=3, go_melee=1}
	elseif t[1] == "survivor" then return {type="survivor", disable=2, escape=5, closein=0, defend=3, protect=0, heal=6, safe_range=8}
	end
	return {}
end

-- consider revising this system to allow 0 as a default weight wt
-- i.e. actual weight = val + 1 (val > 0) or 1/(1-val) (val < 0)
-- this would allow tempvalues to be used for various tactical weights
-- So Wild Speed effect could deter but not eliminate talent use,
-- Spatial Tether could deemphasize movement, etc..

--- Resolve tactical ai weights based on talents known
--	mostly to make sure randbosses have sensible ai_tactic tables
--	this tends to make npc's slightly more aggressive/defensive depending on their talents
--	@param method = function to be applied to generate the ai_tactic table <generally not implemented>
--		tactics are updated with "on_added_to_level"
--		use "instant" to resolve the tactics immediately using the "simple_recursive" method
-- 	@param tactic_emphasis = average weight of favored tactics, higher values make the NPC more aggressive or defensive <1.5>
--	@param weight_power = smoothing factor (> 0) to balance out weights <0.5>
function resolvers.talented_ai_tactic(method, tactic_emphasis, weight_power)
	local method = method or "simple_recursive"
	return {__resolver="talented_ai_tactic", method, tactic_emphasis or 1.5, weight_power, __resolve_last=true,
	}
end

-- Extra recursive methods not handled yet
function resolvers.calc.talented_ai_tactic(t, e)
	if not e.__ai_tactic_resolver then
		t.old_on_added_to_level = e.on_added_to_level
		e.__ai_tactic_resolver = t
	end
	--print("talented_ai_tactic resolver setting up on_added_to_level function")
	--print(debug.traceback())
	local on_added = function(e, level, x, y)
		if e.ai_tactic then
			for k, v in pairs(e.ai_tactic) do
				if type(v) == "number" and v > 0 then
					print("running talented_ai_tactic resolver but aborting due to existing tactics")
					return
				end
			end
		end

		print("running talented_ai_tactic resolver on_added_to_level function for", e.uid, e.name)
		local t = e.__ai_tactic_resolver
		if not t then print("talented_ai_tactic: No resolver table. Aborting") return end
		e.__ai_tactic_resolver = nil
		if t.old_on_added_to_level then t.old_on_added_to_level(e, level, x, y) end
		
		if type(t[1]) == "function" then
		print("running talented_ai_tactic resolver custom function from on_added_to_level")
			return t[1](t, e, level)
		end
		-- print("  # talented_ai_tactic resolver function for", e.name, "level=", e.level, e.uid)
		local tactic_emphasis = t[2] or t.tactic_emphasis or 1.5 --desired average tactic weight
		local weight_power = t[3] or t.weight_power or 0.5 --smooth out tactical weights
		local tacs_offense = {attack=1, attackarea=1, areaattack=1}
		local tacs_close = {closein=1, go_melee=1}
		local tacs_defense = {escape=1, defend=1, heal=1, protect=1, disable = 1}
		local tactic, tactical = {}, {total = 0} 
		local do_count, counted, count_talent, val
		local tac_count = #table.keys(tacs_offense) + #table.keys(tacs_close) + #table.keys(tacs_defense)
		local count = {resolver = t, tal_count = 0, atk_count = 0, total_range = 0,
			atk_melee = 0, melee_value = 0, range_value = 0, atk_range = 0, 
			escape = 0, close = 0, tac_count = tac_count,
			ranged_values={}, -- obsolete
			atk_range_values={}}
		-- go through all talents, adding up all the tactical weights from the tactical tables
		local tal
		local function get_weight(wt)
			local val = 0
			if type(wt) == "function" then
				wt = wt(e, tal, e) -- try to target self for effectiveness
			end
			if type(wt) == "number" then return wt
			elseif type(wt) == "table" then
				for _, n in pairs(wt) do
					val = math.max(val, get_weight(n))
				end
				if val == 0 then val = 2 end
			end
			return tonumber(val) or 0
		end
		
		for tid, tl in pairs(e.talents) do
			tal = e:getTalentFromId(tid)
			tl = util.getval(tal.ai_level, e, tal) or tl
			count_talent = false, false
			local tactics = tal.tactical
			if type(tactics) == "function" then tactics = tactics(e, tal) end
			if tactics then
				local range, radius = e:getTalentRange(tal), e:getTalentRadius(tal)
				local eff_range = range + radius*2/3
				print("   #- checking tactical table for talent", tal.id, "level", tl, "range:", range, "radius:", radius, "effective:", eff_range)
				--	table.print(tal.tactical)
				do_count = false
				for tt, wt in pairs(tactics) do
					val = get_weight(wt, e) * (1 + (e.AI_TACTICAL_TALENT_LEVEL_BONUS or 0.2)*tl)
					-- print("   --- ", tt, "wt=", val)
					tactical[tt] = (tactical[tt] or 0) + val -- sum up all the input weights
					if tacs_offense[tt] then
						do_count = true
						count.atk_count = count.atk_count + 1
						val = val * tacs_offense[tt]
						count.atk_range_values[range+radius] = (count.ranged_values[range+radius] or 0) + val
						if eff_range >= 2 and not util.getval(tal.is_melee, e, tal) then
							count.atk_range = count.atk_range + 1
							count.range_value = count.range_value + val
							count.ranged_values[range+radius] = (count.ranged_values[range+radius] or 0) + val
						else
							count.atk_melee = count.atk_melee + 1
							count.melee_value = count.melee_value + val
						end
						count.total_range = count.total_range + eff_range
					end
					if tacs_defense[tt] then
						do_count = true
						if tt == "escape" then count.escape = count.escape + 1 end
						if tt == "disable" then -- for range average only
							count.atk_count = count.atk_count + 1
							count.atk_range_values[range+radius] = (count.ranged_values[range+radius] or 0) + val
							if eff_range >= 2 then
								count.range_value = count.range_value + val
								count.ranged_values[range+radius] = (count.ranged_values[range+radius] or 0) + val
								count.total_range = count.total_range + eff_range
						end
					end
					end
					if tacs_close[tt] then
						do_count = true
						count.close = count.close + 1
						count.range_value = count.range_value - val
					end
					if do_count then -- sum up only relevant weights
						count_talent = true
						tactic[tt] = (tactic[tt] or 0) + val
					end
				end
				if count_talent then
					count.tal_count = count.tal_count + 1
					-- table.print(count, "--")
				end
			end
		end

		-- normalize weights
		count.avg_attack_range = count.total_range/count.atk_count
		local norm_total, tact_count = 0, 0
		for tt, wt in pairs(tactic) do
			local ave_weight = (tactic[tt]+count.tal_count)/count.tal_count
			local ave_xweight = ave_weight^weight_power - 1
			if ave_xweight > 1/tac_count then
				tact_count = tact_count + 1
				tactic[tt] = ave_weight
				norm_total = norm_total + ave_weight
			else
				tactic[tt] = nil -- defaults to a weight of 1 in the tactical ai
			end
		end
		--table.print(tactic, "\t_raw_tact_ ")
		--print("norm_total:", norm_total)
		for tt, _ in pairs(tactic) do
			tactic[tt] = tactic[tt]*tactic_emphasis*tact_count/norm_total
			if tactic[tt] < 1 then tactic[tt] = nil end -- defaults to a weight of 1 in the tactical ai
		end
		-- NPC's with predominantly ranged attacks will want to stay at range.
		if count.atk_range + count.escape > count.atk_melee + count.close and count.range_value/(count.melee_value + 1) > 1.5 then
			--tactic.old_safe_range = util.bound(math.ceil(count.avg_attack_range/2), 2, e.sight)
			local sum, break_pt, n, keys = 0, (count.range_value+count.melee_value)/3, 0, {} -- safe_range <= range of 2/3 of all attacks by value
			for range, ct in pairs(count.atk_range_values) do
				n = n + 1; keys[n] = range
			end
			table.sort(keys)
			local last_range, last_ct, ct = 0, 0, 0
			for i, range in ipairs(keys) do
				ct = count.atk_range_values[range]
				--	print("processing range, ct:", range, ct)
				if sum + ct >= break_pt then
					tactic.safe_range = util.bound(math.floor((last_range*last_ct + range*(break_pt - sum))/(last_ct + break_pt - sum)), 2, e.sight)
--if config.settings.cheat then game.log("#LIGHT_BLUE#%s[%s] at (%s, %s): tactical safe_range=%s(vs. old:%s)", e.name, e.uid, x, y, tactic.safe_range, tactic.old_safe_range) end -- debugging
					break
				end
				sum = sum + ct
				last_range, last_ct = range, ct
			end
		end
		
		tactic.tactical_sum=tactical
		tactic.count = count
		tactic.level = e.level
		tactic.type = "simple_recursive"
		--- print("### talented_ai_tactic resolver ai_tactic table:")
		--- for tac, wt in pairs(tactic) do print("    ##", tac, wt) end

		-- No thanks
		tactic.escape = 0
		tactic.safe_range = nil

		e.ai_tactic = tactic
--		e.__ai_tactic_resolver = nil
		return tactic
	end
	if t[1] == "instant" then
		e.__ai_tactic_resolver = t
		on_added(e, level or game.level, e.x, e.y)
	else
		e.on_added_to_level = on_added
	end
end

--- Racial Talents resolver
local racials = {
	halfling = {
		T_HALFLING_LUCK = {last=10, base=0, every=4, max=5},
		T_DUCK_AND_DODGE = {base=0, every=4, max=5},
		T_INDOMITABLE = {last=20, base=0, every=4, max=5},
	},
	human = {
		T_HIGHER_HEAL = {last=20, base=0, every=4, max=5},
		T_BORN_INTO_MAGIC = {base=0, every=4, max=5},
		T_HIGHBORN_S_BLOOM = {last=10, base=0, every=4, max=5},
	},
	shalore = {
		T_SHALOREN_SPEED = {last=30, base=0, every=4, max=5},
		T_MAGIC_OF_THE_ETERNALS = {base=0, every=4, max=5},
		T_SECRETS_OF_THE_ETERNALS = {last=20, base=0, every=4, max=5},
		T_TIMELESS = {last=10, base=0, every=4, max=5},
	},
	thalore = {
		T_THALOREN_WRATH = {last=10, base=0, every=4, max=5},
		T_UNSHACKLED = {base=0, every=4, max=5},
		T_GUARDIAN_OF_THE_WOOD = {last=20, base=0, every=4, max=5},
		T_NATURE_S_PRIDE = {last=30, base=0, every=4, max=5},
	},
	yeek = {
		T_UNITY = {base=0, every=4, max=5},
		T_QUICKENED = {last=10, base=0, every=4, max=5},
		T_WAYIST = {last=20, base=0, every=4, max=5},
	},
	ogre = {
		T_OGRE_WRATH = {base=0, every=4, max=5},
		T_GRISLY_CONSTITUTION = {last=10, base=0, every=4, max=5},
		T_SCAR_SCRIPTED_FLESH = {last=20, base=0, every=4, max=5},
		T_WRIT_LARGE = {last=30, base=0, every=4, max=5},
	},
	dwarf = {
		T_POWER_IS_MONEY = {last=20, base=0, every=4, max=5},
		T_STONESKIN = {base=0, every=4, max=5},
		T_DWARF_RESILIENCE = {last=10, base=0, every=4, max=5},
	},
	orc = {
		T_ORC_FURY = {last=20, base=0, every=4, max=5},
		T_HOLD_THE_GROUND = {base=0, every=4, max=5},
		T_SKIRMISHER = {last=10, base=0, every=4, max=5},
		T_PRIDE_OF_THE_ORCS = {last=30, base=0, every=4, max=5},
	},
	skeleton = {
		T_BONE_ARMOUR = {last=30, base=0, every=4, max=5},
		T_SKELETON_REASSEMBLE = {last=40, base=0, every=4, max=5},
		T_RESILIENT_BONES = {last=20, base=0, every=4, max=5},
		T_SKELETON = {last=10, base=0, every=4, max=5},
	},
	ghoul = {
		T_GHOUL = {last=10, base=0, every=4, max=5},
		T_GHOULISH_LEAP = {last=20, base=0, every=4, max=5},
		T_GNAW = {last=40, base=0, every=4, max=5},
		T_RETCH = {last=30, base=0, every=4, max=5},
	},
}
resolvers.racials_defs = racials

function resolvers.racial(race)
	return {__resolver="racial", race}
end
function resolvers.calc.racial(t, e)
	if e.type ~= "humanoid" and e.type ~= "giant" and e.type ~= "undead" and e.type ~= "construct" then return end
	local race = t[1] or e.subtype
	if not racials[race] then return end

	local levelup_talents = e._levelup_talents or {}
	local rcls = racials[race]
	if type(rcls) == "function" then rcls = rcls(e) end
	for tid, level in pairs(rcls) do
		levelup_talents[tid] = table.clone(level)
	end
	e._levelup_talents = levelup_talents
	return nil
end


--- Racial Visuals resolver
local racials_visuals = {
	Human = {
		Cornac = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="skin", percent=5, filter={"oneof", {"Skin Color 6", "Skin Color 7", "Skin Color 8"}}},
			{kind="hairs", filter={"findname", "Dark Hair"}},
			{kind="hairs", percent=10, filter={"findname", "Redhead "}},
			{kind="facial_features", percent=20, filter={"findname", "Dark Beard "}},
			{kind="facial_features", percent=20, filter={"findname", "Dark Mustache "}},
		},
		Sholtar = {
			{kind="skin", filter={"oneof", {"Skin Color 6", "Skin Color 7", "Skin Color 8"}}},
			{kind="skin", percent=5, filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="hairs", filter={"findname", "Dark Hair"}},
			{kind="hairs", percent=10, filter={"findname", "Redhead "}},
			{kind="facial_features", percent=20, filter={"findname", "Dark Beard "}},
			{kind="facial_features", percent=20, filter={"findname", "Dark Mustache "}},
		},
		Higher = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="skin", percent=5, filter={"oneof", {"Skin Color 6", "Skin Color 7", "Skin Color 8"}}},
			{kind="hairs", filter={"findname", "Blond Hair"}},
			{kind="hairs", percent=10, filter={"findname", "Redhead "}},
			{kind="facial_features", percent=20, filter={"findname", "Blonde Beard "}},
			{kind="facial_features", percent=20, filter={"findname", "Blonde Mustache "}},
		},
	},
	Elf = {
		Shalore = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="skin", percent=15, filter={"oneof", {"Skin Color 6", "Skin Color 7", "Skin Color 8", "Skin Color 9"}}},
			{kind="hairs", filter={"findname", "Blond Hair"}},
			{kind="hairs", percent=15, filter={"findname", "Redhead "}},
		},
		Thalore = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="hairs", filter={"findname", "Dark Hair"}},
			{kind="hairs", percent=15, filter={"findname", "Redhead "}},
		},
	},
	Halfling = {
		Halfling = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4"}}},
			{kind="skin", percent=5, filter={"oneof", {"Skin Color 5", "Skin Color 6"}}},
			{kind="hairs", filter={"all"}},
		},
		DarkSkinHalfling = {
			{kind="skin", filter={"oneof", {"Skin Color 5", "Skin Color 6"}}},
			{kind="skin", percent=5, filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4"}}},
			{kind="hairs", filter={"all"}},
		},
	},
	Dwarf = {
		Dwarf = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="hairs", filter={"all"}},
			{kind="facial_features", percent=25, filter={"findname", "Beard"}},
			{kind="facial_features", percent=25, filter={"findname", "Mustache"}},
		},
	},
	Giant = {
		Ogre = {
			{kind="skin", filter={"oneof", {"Skin Color 1", "Skin Color 2", "Skin Color 3", "Skin Color 4", "Skin Color 5"}}},
			{kind="skin", percent=15, filter={"oneof", {"Skin Color 6", "Skin Color 7", "Skin Color 8", "Skin Color 9"}}},
			{kind="hairs", filter={"all"}},
			{kind="facial_features", percent=20, filter={"all"}},
			{kind="tatoos", percent=35, filter={"all"}},
		},
	},
}
resolvers.racials_visuals_defs = racials_visuals

local racials_visuals_birther = nil

function resolvers.racial_visual(sex, race, subrace)
	return {__resolver="racial_visual", sex, race, subrace}
end
function resolvers.calc.racial_visual(t, e)
	local sex = t[1]
	local race = t[2]
	local subrace = t[3]

	if not sex then sex = rng.table{"Male", "Female"} end
	if type(race) == "table" then race = rng.table(race) end
	if type(subrace) == "table" then subrace = rng.table(subrace) end

	if not racials_visuals[race] or not racials_visuals[race][subrace] then return end

	if sex == "Female" then e.female = true end

	e.descriptor = e.descriptor or {}
	e.descriptor.sex = sex
	e.descriptor.race = race
	e.descriptor.subrace = subrace

	if not racials_visuals_birther then
		local Birther = require "mod.dialogs.Birther"
		racials_visuals_birther = Birther.new("", e, {}, function() end, nil, nil, nil)
		racials_visuals_birther.not_birthing = true
	end

	racials_visuals_birther.actor = e -- Bypass clone

	racials_visuals_birther:setDescriptor("sex", e.descriptor.sex)
	racials_visuals_birther:setDescriptor("race", e.descriptor.race)
	racials_visuals_birther:setDescriptor("subrace", e.descriptor.subrace)

	racials_visuals_birther:selectRandomCosmetics(racials_visuals[race][subrace])

	racials_visuals_birther:setTile(nil, nil, nil, true)

	return nil
end


function resolvers.emote_random(def)
	return {__resolver="emote_random", def}
end
function resolvers.calc.emote_random(t, e)
	local def = t[1]
	def.chance = def.chance or 0.1
	if def.allow_backup_guardian then
		def[#def+1] = function()
			local t = game.state:getBackupGuardianEmotes{}
			return #t > 0 and rng.table(t) or nil
		end
	end
	return def
end

function resolvers.nice_tile(def)
	return {__resolver="nice_tile", def}
end
function resolvers.calc.nice_tile(t, e)
	if engine.Map.tiles.nicer_tiles then
		if t[1].tall and not t[1].wide then t[1] = {image="invis.png", add_mos = {{image="=BASE=TILE=", display_h=2, display_y=-1}}}
		elseif t[1].tall and t[1].wide then t[1] = {image="invis.png", add_mos = {{image="=BASE=TILE=", display_h=2, display_y=-1, display_w=2, display_x=-0.5}}}
		elseif not t[1].tall and t[1].wide then t[1] = {image="invis.png", add_mos = {{image="=BASE=TILE=", display_w=2, display_x=-0.5}}} end
		if t[1].add_mos and t[1].add_mos[1] and t[1].add_mos[1].image == "=BASE=TILE=" then t[1].add_mos[1].image = e.image end
		if t[1].add_mos and t[1].add_mos[1] and t[1].add_mos[1].image then t[1].attachement_spots = t[1].add_mos[1].image end
		table.merge(e, t[1])
	end
	return nil
end

function resolvers.shooter_capacity()
	return {__resolver="shooter_capacity", __resolve_last=true}
end
function resolvers.calc.shooter_capacity(t, e)
	e.combat.capacity = math.floor(e.combat.capacity)
	e.combat.shots_left = e.combat.capacity
	return nil
end

--- Give staves a flavor, appropriate damage type, and the ability to teach the command staff talent
function resolvers.staff_element(name)
	return {__resolver="staff_element", name}
end
function resolvers.calc.staff_element(t, e)
	local command_flavor, command_lement = nil, nil
	if not e.flavor_name then
		if not e.flavors then -- standard
			local staff_type = rng.table{2, 2, 2, 2, 3, 3, 3, 4, 4, 4}
			command_flavor = e["flavor_names"][staff_type]
		else
			command_flavor = rng.tableIndex(e.flavors)
		end
	end
	if not e.combat.element then
		command_element = rng.table(e:getStaffFlavor(e.flavor_name or command_flavor))
	end

	e.combat.damtype = e.combat.damtype or engine.DamageType.PHYSICAL
	if not e.no_command then 
		e.wielder = e.wielder or {}
		e.wielder.learn_talent = e.wielder.learn_talent or {}
		e.wielder.learn_talent[Talents.T_COMMAND_STAFF] = 1
	end

	if command_flavor or command_element then e:commandStaff(command_element, command_flavor) end

	-- hee hee
	if not e.unique and rng.percent(0.1 * (e.material_level or 1) - 0.3) then
		e.combat.sentient = rng.table{"default", "agressive", "fawning"}
	end
end

function resolvers.command_staff()
	return {__resolver = "command_staff", __resolve_last = true}
end
function resolvers.calc.command_staff(t, e)
	e:commandStaff()
end

function resolvers.birth_extra_tier1_zone(data)
	return {__resolver = "birth_extra_tier1_zone", data}
end
function resolvers.calc.birth_extra_tier1_zone(t, e)
	if not game.creating_player then return end
	-- Add bonus starting zones to the tier1 list only if the zone they actually started in matches the race/classes
	-- This is a hacky way to figure out which class/race start got prioritized
	game.state.birth.bonus_zone_tiers = game.state.birth.bonus_zone_tiers or {}
	game.state.birth.bonus_zone_tiers[#game.state.birth.bonus_zone_tiers+1] = e[1]
end

--- Make robes great again
function resolvers.robe_stats()
	return {__resolver="robe_stats", __resolve_last=true}
end
function resolvers.calc.robe_stats(t, e)
	e.wielder = e.wielder or {}
	e.wielder.resists = e.wielder.resists or {}
	e.wielder.resists.all = (e.wielder.resists.all or 0) + 5 + ((e.material_level or 1) * 2)
end

--- Make robes great again
function resolvers.for_campaign(id, fct)
	return {__resolver="for_campaign", __resolve_last=true, id, fct}
end
function resolvers.calc.for_campaign(t, e)
	if game:isCampaign(t[1]) then t[2](e) end
end

--- Make defining combat tables for npcs easy
function resolvers.easy_combat_table(def)
	return {__resolver="easy_combat_table", def}
end
function resolvers.calc.easy_combat_table(t, e)
	local def = table.clone(t[1], true)
	if not e._levelup_info then e._levelup_info = {} end
	local base_level = 1
	if e.level_range and e.level_range[1] then base_level = e.level_range[1] end

	if type(def.dam) == "table" then
		local per_level = (def.dam[2] - def.dam[1]) / 50
		e._levelup_info[#e._levelup_info+1] = {every=1, inc=per_level, max=def.dam.max_at, kchain={"combat"}, k="dam"}
		def.dam = base_level * per_level + def.dam[1]
	end
	if type(def.atk) == "table" then
		local per_level = (def.atk[2] - def.atk[1]) / 50
		e._levelup_info[#e._levelup_info+1] = {every=1, inc=per_level, max=def.atk.max_at, kchain={"combat"}, k="atk"}
		def.atk = base_level * per_level + def.atk[1]
	end
	if type(def.apr) == "table" then
		local per_level = (def.apr[2] - def.apr[1]) / 50
		e._levelup_info[#e._levelup_info+1] = {every=1, inc=per_level, max=def.apr.max_at, kchain={"combat"}, k="apr"}
		def.apr = base_level * per_level + def.apr[1]
	end
	return def
end

--- Levelup resolver
function resolvers.levelup_range(min1, max50, stop_at)
	return {__resolver="levelup_range", min1, max50, stop_at}
end
function resolvers.calc.levelup_range(t, e, _, _, k, kchain)
	if not e._levelup_info then e._levelup_info = {} end

	local base_level = 1
	if e.level_range and e.level_range[1] then base_level = e.level_range[1] end

	local per_level = (t[2] - t[1]) / 50
	e._levelup_info[#e._levelup_info+1] = {every=1, inc=per_level, max=t[3], kchain=table.clone(kchain), k=k}
	return base_level * per_level + t[1]
end
