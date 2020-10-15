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

local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"
local Chat = require "engine.Chat"

-- equipable artifice tool talents and associated mastery talents
-- to add a new tool, define a tool talent and a mastery talent and update this table
artifice_tool_tids = {T_HIDDEN_BLADES="T_ASSASSINATE", T_SMOKESCREEN="T_SMOKESCREEN_MASTERY", T_ROGUE_S_BREW="T_ROGUE_S_BREW_MASTERY", T_DART_LAUNCHER="T_DART_LAUNCHER_MASTERY", T_GRAPPLING_HOOK="T_GRAPPLING_HOOK_MASTERY",}
Talents.artifice_tool_tids = artifice_tool_tids

-- Hook to show artifices on the doll
class:bindHook("Actor:updateModdableTile:middle", function(self, data)
	if not self.artifice_tools then return end
	for _, tool in pairs(self.artifice_tools) do
		local img = self:callTalent(tool, "getDollImage")
		if img then
			data.add[#data.add+1] = {image = data.base..img..".png", auto_tall=1}
		end
	end
end)

--- initialize artifice tools, update mastery level and unlearn any unselected tools talents
function artifice_tools_setup(self, t)
	self.artifice_tools = self.artifice_tools or {}
	self:setTalentTypeMastery("cunning/tools", self:getTalentMastery(t))
	for tid, m_tid in pairs(artifice_tool_tids) do
		if self:knowTalent(tid) then
			local slot
			for slot_id, tool_id in pairs(self.artifice_tools) do
				if tool_id == tid then slot = slot_id break end
			end
			if not slot then self:unlearnTalentFull(tid) end
		end
		if self.artifice_tools_mastery == tid then
			local m_level = self:getTalentLevelRaw(self.T_MASTER_ARTIFICER)
			if self:getTalentLevelRaw(m_tid) ~= m_level then
				self:unlearnTalentFull(m_tid)
				self:learnTalent(m_tid, true, m_level, {no_unlearn=true})
			end
		elseif self:knowTalent(m_tid) then
			self:unlearnTalentFull(m_tid)
		end
	end
	return true
end

--- generate a textual list of available artifice tools
function artifice_tools_get_descs(self, t)
	if not self.artifice_tools then artifice_tools_setup(self, t) end
	local tool_descs = {}
	for tool_id, mt in pairs(artifice_tool_tids) do
		local tool, desc = self:getTalentFromId(tool_id)
		local prepped = self.artifice_tools[t.id] == tool_id
		if prepped then
			desc = ("#YELLOW#%s (prepared, level %s)#LAST#:\n"):tformat(tool.name, self:getTalentLevelRaw(tool))
		else
			desc = tool.name..":\n"
		end
		if tool.short_info then
			desc = desc..tool.short_info(self, tool, t).."\n"
		else
			desc = desc.._t"#GREY#(see talent description)#LAST#\n"
		end
		tool_descs[#tool_descs+1] = desc
	end
	return table.concatNice(tool_descs, "\n\t")
end

--- NPC's automatically pick a tool for each tool slot if needed
-- used as the talent on_pre_use_ai function
-- this causes newly spawned NPC's to prepare their tools the first time they check for usable talents
function artifice_tools_npc_select(self, t, silent, fake)
	if not self.artifice_tools[t.id] then -- slot is empty: pick a tool
		local tool_ids = table.keys(artifice_tool_tids)
		local tid = rng.tableRemove(tool_ids)
		while tid do
			if not self:knowTalent(tid) then -- select the tool
				self:learnTalent(tid, true, self:getTalentLevelRaw(t), {no_unlearn=true})
				self.artifice_tools[t.id] = tid
				if game.party:hasMember(self) then -- cooldowns for party members
					self:startTalentCooldown(t); self:startTalentCooldown(tid)
					self:useEnergy()
				end
				game.logSeen(self, "#GREY#You notice %s has prepared: %s.", self:getName():capitalize(), self:getTalentFromId(tid).name)
				break
			end
			tid = rng.tableRemove(tool_ids)
		end
	end
	return false -- npc's don't need to actually use the tool slot talents
end

newTalent{
	name = "Rogue's Tools",
	type = {"cunning/artifice", 1},
	points = 5,
	require = cuns_req_high1,
	cooldown = 10,
	stamina = 0, -- forces learning stamina pool (npcs)
	no_unlearn_last = true,
	on_pre_use = artifice_tools_setup,
	on_learn = function(self, t)
		self:attr("show_gloves_combat", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("show_gloves_combat", -1)
	end,
	tactical = {BUFF = 2},
	on_pre_use_ai = artifice_tools_npc_select, -- NPC's automatically pick a tool
	action = function(self, t)
		local chat = Chat.new("artifice", self, self, {player=self, slot=1, chat_tid=t.id, tool_ids=artifice_tool_tids})
		local d = chat:invoke()
		d.key:addBinds{ EXIT = function()
			game:unregisterDialog(d)
		end}
		local tool_id, m_id = self:talentDialog(d)
		artifice_tools_setup(self, t)
		self:updateModdableTile()
		return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
	end,
	info = function(self, t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[With some advanced preparation, you learn to create and equip one of a number of useful tools (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
]]):tformat(self:getTalentLevelRaw(t), descs)
	end,
}

newTalent{
	name = "Cunning Tools",
	type = {"cunning/artifice", 2},
	points = 5,
	require = cuns_req_high2,
	cooldown = 10,
	stamina = 0, -- forces learning stamina pool (npcs)
	no_unlearn_last = true,
	on_pre_use = artifice_tools_setup,
	tactical = {BUFF = 2},
	on_pre_use_ai = artifice_tools_npc_select, -- NPC's automatically pick a tool
	action = function(self, t)
		local chat = Chat.new("artifice", self, self, {player=self, slot=2, chat_tid=t.id, tool_ids=artifice_tool_tids})
		local d = chat:invoke()
		d.key:addBinds{ EXIT = function()
			game:unregisterDialog(d)
		end}
		local tool_id, m_id = self:talentDialog(d)
		artifice_tools_setup(self, t)
		self:updateModdableTile()
		return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
	end,
	info = function(self, t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[With some advanced preparation, you learn to create and equip a second tool (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
Only one tool of each type can be equipped at a time.
]]):tformat(self:getTalentLevelRaw(t), descs)
	end,
}

newTalent{
	name = "Intricate Tools",
	type = {"cunning/artifice", 3},
	require = cuns_req_high3,
	points = 5,
	cooldown = 10,
	stamina = 0, -- forces learning stamina pool (npcs)
	no_unlearn_last = true,
	on_pre_use = artifice_tools_setup,
	tactical = {BUFF = 2},
	on_pre_use_ai = artifice_tools_npc_select, -- NPC's automatically pick a tool
	action = function(self, t)
		local chat = Chat.new("artifice", self, self, {player=self, slot=3, chat_tid=t.id, tool_ids=artifice_tool_tids})
		local d = chat:invoke()
		d.key:addBinds{ EXIT = function()
			game:unregisterDialog(d)
		end}
		local tool_id, m_id = self:talentDialog(d)
		artifice_tools_setup(self, t)
		self:updateModdableTile()
		return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
	end,
	info = function(self, t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[With some advanced preparation, you learn to create and equip a third tool (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
Only one tool of each type can be equipped at a time.
]]):tformat(self:getTalentLevelRaw(t), descs)
	end,
}

newTalent{
	name = "Master Artificer",
	type = {"cunning/artifice", 4},
	require = cuns_req_high4,
	points = 5,
	cooldown = 10,
	stamina = 0, -- forces learning stamina pool (npcs)
	no_energy = true,
	no_unlearn_last = true,
	on_pre_use = artifice_tools_setup,
	tactical = {BUFF = 2},
	on_pre_use_ai = function(self, t, silent, fake) -- npc's automatically master a tool they have prepared
		if self.artifice_tools and not self.artifice_tools_mastery then
			game:onTickEnd(function()
				local tools = table.values(self.artifice_tools)
				while #tools > 0 do
					local tool_id = rng.tableRemove(tools)
					local m_tid = artifice_tool_tids[tool_id]
					if m_tid then -- note: talent level affects AI use
						local tl = self:getTalentLevelRaw(m_tid)
						if self:learnTalent(m_tid, true, self:getTalentLevelRaw(t) - tl) then
							self.artifice_tools_mastery = tool_id
							if game.party:hasMember(self) then -- cooldowns for party members
								self:startTalentCooldown(t); self:startTalentCooldown(tool_id); self:startTalentCooldown(m_tid)
							end
							break
						end
					end
				end
			end)
		end
		return false
	end,
	action = function(self, t)
		local chat = Chat.new("artifice-mastery", self, self, {player=self, chat_tid=t.id, tool_ids=artifice_tool_tids})
		local d = chat:invoke()
		d.key:addBinds{ EXIT = function()
			game:unregisterDialog(d)
		end}
		local tool_id = self:talentDialog(d)
		artifice_tools_setup(self, t)
		self:updateModdableTile()
		return tool_id ~= nil -- only use energy/cooldown if a new tool was mastered
	end,
	info = function(self, t)
		local tool = _t"none"
		if self.artifice_tools_mastery then
			tool = self:getTalentFromId(self.artifice_tools_mastery).name
		end
		--- generate a textual list of available artifice tools enhancements
		if not self.artifice_tools then artifice_tools_setup(self, t) end
		local mastery_descs = {}
		for tool_id, m_tid in pairs(artifice_tool_tids) do
			local tool, mt = self:getTalentFromId(tool_id), self:getTalentFromId(m_tid)
			if mt then
				local desc
				local prepped = self.artifice_tools_mastery == tool_id
				if prepped then
					desc = ("#YELLOW#%s (%s)#LAST#\n"):tformat(tool.name, mt.name)
				else
					desc = ("%s (%s)\n"):tformat(tool.name, mt.name)
				end
				if mt.short_info then
					desc = desc..mt.short_info(self, mt).."\n"
				else
					desc = desc.._t"#GREY#(see talent description)#LAST#\n"
				end
				mastery_descs[#mastery_descs+1] = desc
			end
		end
		mastery_descs = table.concatNice(mastery_descs, "\n\t")
		return ([[You become a master of your craft, allowing you to focus on a single tool (#YELLOW#currently %s#LAST#) to greatly improve its capabilities:

%s
The effects depend on this talent's level.
Mastering a new tool places it (and its special effects, as appropriate) on cooldown.]]):tformat(tool, mastery_descs)
	end,
}

--====================--
-- Rogue's tools and enhancements
--====================--
newTalent{
	name = "Hidden Blades",
	type = {"cunning/tools", 1},
	mode = "passive",
	points = 1,
	cooldown = 4,
	getDollImage = function(self, t) return self:knowTalent(self.T_ASSASSINATE) and "artifices/mastery_hidden_blades" or "artifices/hidden_blades" end,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.8) end,
	no_break_stealth = true,
	callbackOnCrit = function(self, t, kind, dam, chance, target)
		if not target then return end
		if target.turn_procs.hb then return end
		if not self:isTalentCoolingDown(t) then
			target.turn_procs.hb = true
			local oldlife = target.life
			self:logCombat(target, "#Source# strikes #target# with hidden blades!")
			self:attackTarget(target, nil, t.getDamage(self,t), true, true)	

			if self:knowTalent(self.T_ASSASSINATE) then
				local scale = nil
				scale = self:callTalent(self.T_ASSASSINATE, "getBleed")	
				local life_diff = oldlife - target.life
				if life_diff > 0 and target:canBe('cut') and scale then
					target:setEffect(target.EFF_CUT, 5, {power=life_diff * scale / 5, src=self})
				end
			end
			self:startTalentCooldown(t)
		end	
	end,
	short_info = function(self, t, slot_talent)
		return ([[Melee criticals trigger an extra unarmed attack, inflicting %d%% damage. 4 turn cooldown.]]):tformat(t.getDamage(self, slot_talent)*100)
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local slot = _t"not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[You conceal spring loaded blades within your equipment. On scoring a critical strike, you follow up with your blades for %d%% damage (as an unarmed attack).
This talent has a cooldown.
#YELLOW#Prepared with: %s#LAST#]]):tformat(dam*100, slot)
	end,
}

newTalent{
	name = "Assassinate",
	type = {"cunning/tools", 1},
	points = 1,
	cooldown = 8,
	stamina = 10,
	message = false,
	tactical = { ATTACK = 3 },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	on_pre_use = function(self, t, silent, fake)
		if not self:knowTalent(self.T_HIDDEN_BLADES) then
			if not silent then game.logPlayer(self, "You must have Hidden Blades prepared to use this talent.") end
			return
		end
		return true
	end,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(self:getTalentFromId(self.T_MASTER_ARTIFICER), 1.8, 3.0) end,
	getBleed = function(self, t) return self:combatTalentScale(self:getTalentFromId(self.T_MASTER_ARTIFICER), 0.3, 1) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canSee(target) or not self:canProject(tg, x, y) then return nil end
		
		target.turn_procs.hb = true -- prevent a crit against this target from triggering an additional hidden blades attack
		self.turn_procs.auto_melee_hit = true
		-- store old values to restore later
		local apr, rpen, evasion = self.combat_apr, self.resists_pen.PHYSICAL, target.evasion
		self:attr("combat_apr", 10000)
		self.resists_pen.PHYSICAL = 100
		target.evasion = 0
		local bleed = t.getBleed(self, t)
		local oldlife = target.life

		self:logCombat(target, "#Source# strikes at a vital spot on #target#!")
		local do_attack = function() self:attackTarget(target, nil, t.getDamage(self, t), true, true) end
		local ok, err = pcall(do_attack)
		if ok then ok, err = pcall(do_attack) end
		self.combat_apr, self.resists_pen.PHYSICAL, target.evasion = apr, rpen, evasion
		if not ok then error(err) end
		self.turn_procs.auto_melee_hit = nil
		
		local life_diff = oldlife - target.life
		if life_diff > 0 and target:canBe('cut') and bleed then
			target:setEffect(target.EFF_CUT, 5, {power=life_diff * bleed / 5, src=self})
		end

		return true
	end,
	short_info = function(self, t)
		return ([[You prime your Hidden Blades to cause bleeding and facilitate the Assassinate ability, which allows you to strike twice for %d%% unarmed damage, hitting automatically while ignoring armor and resistance.]]):tformat(t.getDamage(self, t)*100)
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleed(self,t) * 100
		return ([[You strike your target with your Hidden Blades twice in a vital spot for %d%% unarmed (physical) damage.  You must be able to see your target to use this attack, but it always hits and ignores all armor and physical resistance.
In addition, your hidden blades now inflict a further %d%% of all damage dealt as bleeding over 5 turns.]])
		:tformat(damage, bleed)
	end,
}

newTalent{
	name = "Rogue's Brew",
	type = {"cunning/tools", 1},
	points = 1,
	cooldown = 20,
	getDollImage = function(self, t) return self:knowTalent(self.T_ROGUE_S_BREW_MASTERY) and "artifices/mastery_rogues_brew" or "artifices/rogues_brew" end,
	no_break_stealth = true,
	tactical = { HEAL = 1.5, STAMINA = 1.5,
		CURE = function(self, t, target)
			local num, max = 0, t.getCure(self, t)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "physical" and e.status == "detrimental" then
					num = num + 1
					if num >= max then break end
				end
			end
			return (2*num)^.5
		end
	},
	getHeal = function(self, t)
		return self:combatStatScale("cun", 10, 200, 0.7) + self:combatTalentScale(t, 20, 200, 0.7)
	end,
	getStam = function(self, t)
		return self:combatStatScale("cun", 5, 50, 0.75) + self:combatTalentScale(t, 5, 50, 0.75)
	end,
	getCure = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, "log")) end,
	action = function(self, t)
		local life = t.getHeal(self, t)
		local sta = t.getStam(self, t)
		
		local effs = {}
		-- Go through all temporary effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type == "physical" and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getCure(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
				known = true
			end
		end
		if known then
			game.logSeen(self, "%s is cured!", self:getName():capitalize())
		end
		
		self:incStamina(sta)
		self:attr("allow_on_heal", 1)
		self:heal(life, self)
		self:attr("allow_on_heal", -1)

		if self:knowTalent(self.T_ROGUE_S_BREW_MASTERY) then self:setEffect(self.EFF_ROGUE_S_BREW, 8, {power = self:callTalent(self.T_ROGUE_S_BREW_MASTERY, "getDieAt")}) end
				
		return true

	end,
	short_info = function(self, t, slot_talent)
		return ([[Prepare a potion that restores %d life, %d stamina, and cures %d negative physical effects. 20 turn cooldown.]]):tformat(t.getHeal(self, slot_talent), t.getStam(self, slot_talent), t.getCure(self, slot_talent))
	end,
	info = function(self, t)
	local heal = t.getHeal(self, t)
	local sta = t.getStam(self, t)
	local cure = t.getCure(self,t)
	local slot = _t"not prepared"
	for slot_id, tool_id in pairs(self.artifice_tools or {}) do
		if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
	end
	return ([[Imbibe a potent mixture of energizing and restorative substances, restoring %d life, %d stamina and curing %d detrimental physical effects.  The restorative effects improve with your Cunning.
	#YELLOW#Prepared with: %s#LAST#]]):tformat(heal, sta, cure, slot)
   end,
}

newTalent{
	name = "Rogue's Brew Mastery",
	type = {"cunning/tools", 1},
	mode = "passive",
	points = 1,
	getDieAt = function(self, t) return self:combatTalentScale(self:getTalentFromId(self.T_MASTER_ARTIFICER), 100, 600) end,
	short_info = function(self, t)
		return ([[Your Rogue's Brew fortifies you for 8 turns, preventing you from dying until you reach -%d life.]]):tformat(t.getDieAt(self, t))
	end,
	info = function(self, t)
		return ([[Adjust your Rogue's Brew formulation so that it fortifies you for 8 turns, preventing you from dying until you reach -%d life.]]):tformat(t.getDieAt(self,t))
	end,
}

newTalent{
	name = "Smokescreen",
	type = {"cunning/tools", 1},
	points = 1,
	cooldown = 15,
	stamina = 10,
	range = 6,
	direct_hit = true,
	tactical = { ESCAPE = 2, DISABLE = {blind = 2} },
	requires_target = true,
	no_break_stealth = true,
	radius = 2,
	getDollImage = function(self, t) return self:knowTalent(self.T_SMOKESCREEN_MASTERY) and "artifices/mastery_smokescreen" or "artifices/smokescreen" end,
	getDamage = function(self,t) 
		if self:knowTalent(self.T_SMOKESCREEN_MASTERY) then
			return self:callTalent(self.T_SMOKESCREEN_MASTERY, "getDamage")
		else
			return 0
		end
	end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 3, 5)) end,
	getSightLoss = function(self, t) return math.floor(self:combatTalentScale(t,1, 6, "log", 0, 4)) end, -- 1@1 6@5
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local e = Object.new{
				block_sight=true,
				temporary = t.getDuration(self, t),
				x = px, y = py,
				canAct = false,
				act = function(self)
					local t = self.summoner:getTalentFromId(self.summoner.T_SMOKESCREEN)
					local rad = 2
					local Map = require "engine.Map"
					self:useEnergy()
					
					local actor = game.level.map(self.x, self.y, Map.ACTOR)
					if actor then
						self.summoner:project({type="hit", range=10, talent=self.summoner:getTalentFromId(self.summoner.T_SMOKESCREEN)}, actor.x, actor.y, engine.DamageType.SMOKESCREEN, 
						{
						dam=self.summoner:callTalent(self.summoner.T_SMOKESCREEN, "getSightLoss"), 
						poison=self.summoner:callTalent(self.summoner.T_SMOKESCREEN, "getDamage")
						})
					end

					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						if self.particles then game.level.map:removeParticleEmitter(self.particles) end
						game.level.map:remove(self.x, self.y, engine.Map.TERRAIN+rad)
						self.smokeBomb = nil
						game.level:removeEntity(self)
						game.level.map:scheduleRedisplay()
					end
				end,
				summoner_gain_exp = true,
				summoner = self,
			}
			e.smokeBomb = e -- used for checkAllEntities to return the dark Object itself
			game.level:addEntity(e)
			game.level.map(px, py, Map.TERRAIN+self:getTalentRadius(t), e)
			e.particles = Particles.new("creeping_dark", 1, { })
			e.particles.x = px
			e.particles.y = py
			game.level.map:addParticleEmitter(e.particles)

		end, nil, {type="dark"})

		game:playSoundNear(self, "talents/breath")
		game.level.map:redisplay()
		return true
	end,
	short_info = function(self, t, slot_talent)
		return ([[Throw a smokebomb creating a radius 2 cloud of smoke, lasting %d turns, that blocks sight and reduces enemies' vision by %d. 15 turn cooldown.]]):tformat(t.getDuration(self, slot_talent), t.getSightLoss(self, slot_talent))
	end,
	info = function(self, t)
		local slot = _t"not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[Throw a vial of volatile liquid that explodes in a radius %d cloud of smoke lasting %d turns.  The smoke blocks line of sight, and enemies within will have their vision range reduced by %d.
		Use of this talent will not break stealth, and creatures affected by the smokes can never prevent you from activating stealth, even if their proximity would normally forbid it.
		#YELLOW#Prepared with: %s#LAST#]]):
		tformat(self:getTalentRadius(t), t.getDuration(self, t), t.getSightLoss(self,t), slot)
	end,
}

newTalent{
	name = "Smokescreen Mastery",
	type = {"cunning/tools", 1},
	points = 1,
	mode = "passive",
	getDamage = function (self, t) return 30 + self:combatTalentStatDamage(self:getTalentFromId(self.T_MASTER_ARTIFICER), "cun", 10, 150) end,
	short_info = function(self, t)
		return ([[Your Smokescreen is infused with chokedust. Enemies in the smoke take %0.2f nature damage and may be silenced.]]):tformat(t.getDamage(self, t))
	end,
	info = function(self, t)
		return ([[You infuse your smoke bomb with chokedust. Each turn, enemies in the smoke take %0.2f nature damage and are 50%% likely to be silenced.]]):
		tformat(damDesc(self, DamageType.NATURE, t.getDamage(self,t)))
	end,
}

newTalent{
	name = "Dart Launcher",
	type = {"cunning/tools", 1},
	points = 1,
	tactical = { ATTACK = {PHYSICAL = 1},
		DISABLE = function(self, t, target)
			return target:checkClassification("unliving") and 0 or self:knowTalent(self.T_DART_LAUNCHER_MASTERY) and 2 or {sleep = 1, poison = 1}
		end
	},
	range = 5,
	no_energy = true,
	cooldown = 10,
	stamina = 5,
	requires_target = true,
	no_break_stealth = true,
	getDollImage = function(self, t) return self:knowTalent(self.T_DART_LAUNCHER_MASTERY) and "artifices/mastery_dart_launcher" or "artifices/dart_launcher" end,
	getDamage = function(self, t) return 15 + self:combatTalentStatDamage(t, "cun", 12, 150) end,
	getSleepPower = function(self, t) return 15 + self:combatTalentStatDamage(t, "cun", 15, 180) end,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t)}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		if not tg then return nil end
		
		local slow = 0
		
		if self:knowTalent(self.T_DART_LAUNCHER_MASTERY) then slow = self:callTalent(self.T_DART_LAUNCHER_MASTERY, "getSlow") end

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return nil end
			self:project(tg, x, y, DamageType.PHYSICAL, self:physicalCrit(t.getDamage(self,t)))
			if target:checkClassification("living") and (self:knowTalent(self.T_DART_LAUNCHER_MASTERY) or target:canBe("sleep") and target:canBe("poison")) then
				target:setEffect(target.EFF_SEDATED, 4, {src=self, power=t.getSleepPower(self,t), slow=slow, insomnia=20, no_ct_effect=true, apply_power=self:combatAttack()})
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=180, rM=200, gm=100, gM=120, bm=30, bM=50, am=70, aM=180})
			else
				game.logSeen(self, "%s resists the sedation!", target:getName():capitalize())
			end

		end)

		return true
	end,
	short_info = function(self, t, slot_talent)
		return ([[Fire a poisoned dart dealing %0.2f physical damage that puts the target to sleep for 4 turns. 10 turn cooldown.]]):tformat(t.getDamage(self, slot_talent))
	end,
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local power = t.getSleepPower(self,t)
		local slot = _t"not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[Fire a poisoned dart from a silent, concealed launcher on your person that deals %0.2f physical damage and puts the target (living only) to sleep for 4 turns, rendering them unable to act. Every %d points of damage the target takes brings it closer to waking by 1 turn.
This can be used without breaking stealth.
#YELLOW#Prepared with: %s#LAST#]]):
	tformat(damDesc(self, DamageType.PHYSICAL, dam), power, slot)
	end,
}

newTalent{
	name = "Dart Launcher Mastery",
	type = {"cunning/tools", 1},
	mode = "passive",
	points = 1,
	getSlow = function(self, t) return self:combatTalentLimit(self:getTalentFromId(self.T_MASTER_ARTIFICER), 50, 20, 40)/100 end,
	short_info = function(self, t)
		return ([[Your darts ignore poison and sleep immunity and waking targets are slowed by %d%% for 4 turns.]]):tformat(t.getSlow(self, t)*100)
	end,
	info = function(self, t)
		return ([[The sleeping poison of your Dart Launcher becomes potent enough to ignore immunity, and upon waking the target is slowed by %d%% for 4 turns.]]):
		tformat(t.getSlow(self, t)*100)
	end,
}

newTalent{
	name = "Grappling Hook",
	type = {"cunning/tools", 1},
	points = 1,
	tactical = { DISABLE = {pin = 1}, CLOSEIN = 3 },
	range = function(self, t) return self:combatTalentScale(t, 4, 7) end,
	message = false,
	cooldown = 8,
	stamina = 14,
	requires_target = true,
	getDollImage = function(self, t) return self:knowTalent(self.T_GRAPPLING_HOOK_MASTERY) and "artifices/mastery_grappling_hook" or "artifices/grappling_hook" end,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t, nolock=true} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local dist = core.fov.distance(self.x, self.y, x, y)
		if dist > tg.range then return end
		if dist <= 1 then
			game.logPlayer(self, "You are too close to your target to swing your hook effectively!")
			return
		end
		local ok = true
		self:project(tg, x, y, function(px, py)
			print(("Grappling hook projection at (%s, %s) vs target (%s, %s)"):format(px, py, x, y))
			local target = game.level.map(px, py, engine.Map.ACTOR)

			if target then -- hook actor
				local tx, ty
				local size = target.size_category - self.size_category
				if size >= 1 or not target:canBe("knockback") then
					if self:attr("never_move") then game.logPlayer(self, "You cannot move!") ok = false return end
					local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
					local linestep = self:lineFOV(x, y, block_actor)
					local lx, ly, is_corner_blocked
					repeat  -- make sure each tile is passable
						tx, ty = lx, ly
						lx, ly, is_corner_blocked = linestep:step()
					until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move", self)
					if not tx or not ty or core.fov.distance(x, y, tx, ty) > 1 then ok = false return end
				end

				local dam, dam2 = 0, 0
				local hit = false
				self:logCombat(target, "#Source# throws a grappling hook at #target#!")
				if self:knowTalent(self.T_GRAPPLING_HOOK_MASTERY) then -- unarmed attack
					dam = self:callTalent(self.T_GRAPPLING_HOOK_MASTERY, "getDamage")
					dam2 = self:callTalent(self.T_GRAPPLING_HOOK_MASTERY, "getSecondaryDamage")
					hit = self:attackTarget(target, nil, dam, true, true)
				else 
					hit = self:attackTargetWith(target, {}, nil, 0)
				end
				if hit then
					self:logCombat(target, "#Source#'s grappling hook latches onto #target#!")
				else
					return
				end
				if size >= 1 or not target:canBe("knockback") then
					self:logCombat(target, "#Source# is dragged towards #target#!")
					local ox, oy = self.x, self.y
					self:move(tx, ty, true)
					if config.settings.tome.smooth_move > 0 then
						self:resetMoveAnim()
						self:setMoveAnim(ox, oy, 8, 5)
					end
				else
					self:logCombat(target, "#Target# is dragged towards #source#!")
					target:pull(self.x, self.y, tg.range)
				end
				if target:canBe("pin") then
					target:setEffect(target.EFF_PINNED, 2, {apply_power=self:combatAttack()})
				else
					game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
				end
				if dam > 0 then
					if target:canBe("cut") then target:setEffect(target.EFF_CUT, 4, {power=dam2/4, src=self, no_ct_effect=true}) end
					if target:canBe("poison") then target:setEffect(target.EFF_POISONED, 4, {power=dam2/4, src=self, no_ct_effect=true}) end
				end
			else -- anchor to terrain
				if game.level.map:checkAllEntities(x, y, "block_move", target) then
					if self:attr("never_move") then game.logPlayer(self, "You cannot move!") ok = false return end
					local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move") end
					local linestep = self:lineFOV(x, y, block_actor)
			
					local tx, ty, lx, ly, is_corner_blocked
					repeat  -- make sure each tile is passable
						tx, ty = lx, ly
						lx, ly, is_corner_blocked = linestep:step()
					until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move")
					if not tx or core.fov.distance(self.x, self.y, tx, ty) <= 1 then
						game.logPlayer(self, "You need more room to swing your hook effectively.")
						ok = false return
					end
			
					game.logSeen(self, "%s uses a grappling hook to pull %s %s!", self:getName():capitalize(), self:his_her_self(), game.level.map:compassDirection(tx - self.x, ty - self.y))
					local ox, oy = self.x, self.y
					self:move(tx, ty, true)
					if config.settings.tome.smooth_move > 0 then
						self:resetMoveAnim()
						self:setMoveAnim(ox, oy, 8, 5)
					end
				else
					ok = false
					game.logPlayer(self, "You must anchor the hook to something solid.")
				end
			end
		end)

		return ok
	end,
	short_info = function(self, t, slot_talent)
		return ([[Throw a grappling hook up to range %d that drags you towards the target or the target towards you. 8 turn cooldown.]]):tformat(t.range(self, slot_talent))
	end,
	info = function(self, t)
		local range = t.range(self,t)
		local slot = _t"not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[Toss out a grappling hook to a target within range %d.  If this strikes either a wall or a creature that is immovable or larger than you, you will pull yourself towards it, otherwise, you will drag the target towards you.  Creatures struck by the hook will be pinned for 2 turns.
		Your grapple target must be at least 2 tiles from you.
#YELLOW#Prepared with: %s#LAST#]]):
	tformat(range, slot)
	end,
}

newTalent{
	name = "Grappling Hook Mastery",
	type = {"cunning/tools", 1},
	mode = "passive",
	points = 1,
	getDamage = function (self, t) return self:combatTalentWeaponDamage(self:getTalentLevel(self.T_MASTER_ARTIFICER), 1.0, 1.9) end,
	getSecondaryDamage = function (self, t) return 30 + self:combatTalentStatDamage(self:getTalentFromId(self.T_MASTER_ARTIFICER), "cun", 15, 200) end,
	short_info = function(self, t)
		return ([[Your grappling hook deals %d%% unarmed damage when it hits, plus a further %0.2f physical and %0.2f nature damage over 4 turns.]]):tformat(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
	info = function(self, t)
		return ([[Your grappling hook is tipped with vicious, venomous barbs. Creatures struck by it will be hit for %d%% unarmed damage, bleed for %0.2f physical damage and be poisoned for %0.2f nature damage over 4 turns.]]):
		tformat(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
}
-- idea: Flash powder tool: Set off a bright flash with smoke and "phase-door" to a nearby spot.  Mastery: triggers stealth and makes NPC's in LOS lose track.
