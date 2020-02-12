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

local imbueEgo = function(gem, ring)
	if not gem then return end
	if not ring then return end
	local Entity = require("engine.Entity")
	local ego = Entity.new{
		fake_ego = true,
		name = "imbued_"..gem.name,
		keywords = {[gem.name] = true},
		wielder = table.clone(gem.imbue_powers, true),
		been_imbued = true,
		egoed = true,
		shop_gem_imbue=true,
	}
	if gem.talent_on_spell then ego.talent_on_spell = table.clone(gem.talent_on_spell, true) end  -- Its really weird that this table structure is different for one property
	game.zone:applyEgo(ring, ego, "object", true)
end

local imbue_ring = function(npc, player)
	player:showInventory(_t"Imbue which ring?", player:getInven("INVEN"), function(o) return o.type == "jewelry" and o.subtype == "ring" and o.material_level and not o.unique and not o.plot and not o.special and not o.tinker and not o.shop_gem_imbue end, function(ring, ring_item)
		player:showInventory(_t"Use which gem?", player:getInven("INVEN"), function(gem) return gem.type == "gem" and gem.imbue_powers and gem.material_level end, function(gem, gem_item)
			local lev = (ring.material_level + gem.material_level) / 2 * 10 + 10  -- Average the material level then add a bonus so we guarantee greater ego level range
			local new_ring
			local r = rng.range(0, 99)
			if r < 20 then
				local ring = game.zone:makeEntity(game.level, "object", 
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="ring",
					ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000},
					special=function(e) return e.material_level == ring.material_level end}
					, lev, true)
				new_ring = game.state:generateRandart{base=ring, lev=lev}
			else
				new_ring = game.zone:makeEntity(game.level, "object",
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="ring",
					ignore_material_restriction=true, tome = {greater=9, double_greater=1}, egos = 2,
					special=function(e) return e.material_level == ring.material_level end}
					, lev, true)
			end
			if not new_ring then
				game.logPlayer(player, "%s failed to craft with %s and %s!", npc.name:capitalize(), ring:getName{do_colour=true, no_count=true}, gem:getName{do_colour=true, no_count=true})
				return false
			end
			
			local price = 200 * (ring.material_level + gem.material_level) / 2
			if gem.unique then price = price * 1.5 end
			if price > player.money then require("engine.ui.Dialog"):simplePopup(_t"Not enough money", ("This costs %d gold, you need more gold."):tformat(price)) return end

			require("engine.ui.Dialog"):yesnoPopup(_t"Imbue cost", ("This will cost you %s gold, do you accept?"):tformat(price), function(ret) if ret then
				imbueEgo(gem, new_ring)
				player:incMoney(-price)
				player:removeObject(player:getInven("INVEN"), gem_item)

				new_ring.name = ("%s %s ring"):tformat(_t(ring.short_name) or _t(ring.name) or _t"weird", _t(gem.name))
				new_ring:identify(true)
				-- player:addObject(player:getInven("INVEN"), new_ring)
				ring:replaceWith(new_ring)
				game.zone:addEntity(game.level, ring, "object")

				game.logPlayer(player, "%s creates: %s", npc.name:capitalize(), new_ring:getName{do_colour=true, no_count=true})
			end end)
		end)
	end)
end

local artifact_imbue_amulet = function(npc, player)
	player:showInventory(_t"Imbue which amulet?", player:getInven("INVEN"), function(o) return o.type == "jewelry" and o.subtype == "amulet" and o.material_level and not o.unique and not o.plot and not o.special and not o.tinker end, function(amulet, amulet_item)
		player:showInventory(_t"Use which first gem?", player:getInven("INVEN"), function(gem1) return gem1.type == "gem" and (gem1.material_level or 99) <= amulet.material_level and gem1.imbue_powers end, function(gem1, gem1_item)
			player:showInventory(_t"Use which second gem?", player:getInven("INVEN"), function(gem2) return gem2.type == "gem" and (gem2.material_level or 99) <= amulet.material_level and gem1.name ~= gem2.name and gem2.imbue_powers end, function(gem2, gem2_item)
				local price = 1000
				if price > player.money then require("engine.ui.Dialog"):simplePopup(_t"Not enough money", _t"Limmir needs more gold for the magical plating.") return end

				require("engine.ui.Dialog"):yesnoPopup(_t"Imbue cost", ("You need to use %s gold for the plating, do you accept?"):tformat(price), function(ret) if ret then
					player:incMoney(-price)
					local gem3, tries = nil, 10
					while gem3 == nil and tries > 0 do gem3 = game.zone:makeEntity(game.level, "object", {type="gem"}, nil, true) tries = tries - 1 end
					if not gem3 then gem3 = rng.percent(50) and gem1 or gem2 end
					print("Imbue third gem", gem3.name)
				
				local new_amulet = game.zone:makeEntity(game.level, "object",
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="amulet",
					ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000},
					special=function(e) return e.material_level == amulet.material_level end}
					, player.level, true)

					if gem1_item > gem2_item then
						player:removeObject(player:getInven("INVEN"), gem1_item)
						player:removeObject(player:getInven("INVEN"), gem2_item)
					else
						player:removeObject(player:getInven("INVEN"), gem2_item)
						player:removeObject(player:getInven("INVEN"), gem1_item)
					end

					imbueEgo(gem1, new_amulet)  -- Should keywords not be applied here since the item is unique?
					imbueEgo(gem2, new_amulet)
					imbueEgo(gem3, new_amulet)

					new_amulet.name = _t"Limmir's Amulet of the Moon"
					new_amulet.unique = util.uuid()
					new_amulet:identify(true)
					-- player:addObject(player:getInven("INVEN"), new_amulet)
					amulet:replaceWith(new_amulet)
					game.zone:addEntity(game.level, amulet, "object")
					game.logPlayer(player, "%s creates: %s", npc.name:capitalize(), new_amulet:getName{do_colour=true, no_count=true})
				end end)
			end)
		end)
	end)
end

newChat{ id="welcome",
	text = _t[[Welcome, @playername@, to my shop.]],
	answers = {
		{_t"Let me see your wares.", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end, cond=function(npc, player) return npc.store and true or false end},
		{_t"I am looking for special jewelry.", jump="jewelry"},
		{_t"So you can infuse amulets in this place?", jump="artifact_jewelry", cond=function(npc, player) return npc.can_craft and player:hasQuest("master-jeweler") and player:isQuestStatus("master-jeweler", engine.Quest.COMPLETED, "limmir-survived") end},
		{_t"I have found this tome; it looked important.", jump="quest", cond=function(npc, player) return npc.can_quest and player:hasQuest("master-jeweler") and player:hasQuest("master-jeweler"):has_tome(player) end},
		{_t"Sorry I have to go!"},
	}
}

newChat{ id="jewelry",
	text = _t[[Then you are at the right place, for I am an expert jeweler.
If you bring me a gem and a ring, I can create a new ring imbued with the properties of the gem.  The original traits of the ring will be lost in the process but new ones of similar quality will be generated.
There is a small fee dependent on the level of the ring, and you need a quality ring to use a quality gem.]],
	answers = {
		{_t"I need your services.", action=imbue_ring},
		{_t"Not now, thanks."},
	}
}

newChat{ id="artifact_jewelry",
	text = _t[[Yes! Thanks to you this place is now free from the corruption. I will stay on this island to study the magical aura, and as promised I can make you powerful amulets.
Bring me a an amulet and two different gems and I will turn them into a powerful amulet, though the original properties of the amulet will be lost.
I will not make you pay a fee for it since you helped me so much, but I am afraid the ritual requires a gold plating. This should be equal to about 1000 gold pieces.]],
	answers = {
		{_t"I need your services.", action=artifact_imbue_amulet},
		{_t"Not now, thanks."},
	}
}

newChat{ id="quest",
	text = _t[[#LIGHT_GREEN#*He quickly looks at the tome and looks amazed.*#WHITE# This is an amazing find! Truly amazing!
With this knowledge I could create potent amulets. However, it requires a special place of power to craft such items.
There are rumours about a site of power in the southern mountains. Old legends tell about a place where a part of the Wintertide Moon melted when it got too close to the Sun and fell from the sky.
A lake formed in the crater of the crash. The water of this lake, soaked in intense Moonlight for eons, should be sufficient to forge powerful artifacts!
Go to the lake and then summon me with this scroll. I will retire to study the tome, awaiting your summon.]],
	answers = {
		{_t"I will see if I can find it.", action=function(npc, player)
			game.level:removeEntity(npc)
			player:hasQuest("master-jeweler"):remove_tome(player)
			player:hasQuest("master-jeweler"):start_search(player)
		end},
	}
}

return "welcome"
