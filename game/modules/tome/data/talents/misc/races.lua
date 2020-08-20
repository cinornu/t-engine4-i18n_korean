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

-- Generic requires for racial based on talent level
racial_req1 = {
	level = function(level) return 0 + (level-1)  end,
}
racial_req2 = {
	level = function(level) return 8 + (level-1)  end,
}
racial_req3 = {
	level = function(level) return 16 + (level-1)  end,
}
racial_req4 = {
	level = function(level) return 24 + (level-1)  end,
}

------------------------------------------------------------------
-- Highers' powers
------------------------------------------------------------------
newTalentType{ type="race/higher", name = _t"higher", generic = true, description = _t"The various racial bonuses a character can have." }

newTalent{
	short_name = "HIGHER_HEAL",  -- Backwards compatibility, two tier 1 racials were swapped
	name = "Wrath of the Highborn",
	type = {"race/higher", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit > 5
	getPower = function(self, t) return self:combatStatScale("mag", 11, 25) end,
	tactical = { ATTACK = 1, DEFEND = 1 },
	action = function(self, t)
		self:setEffect(self.EFF_HIGHBORN_WRATH, 5, {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[Call upon the power of the Highborn, increasing all damage by %d%% and reducing all damage taken by %d%% for 5 turns.
		The bonus will increase with your Magic.]]):
		tformat(t.getPower(self, t), t.getPower(self, t))
	end,
}

newTalent{
	name = "Overseer of Nations",
	type = {"race/higher", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getSight = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getESight = function(self, t) return math.ceil(self:combatTalentScale(t, 0.3, 2.3, "log", 0, 2)) end,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.1, 0.4) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "blind_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "sight", t.getSight(self, t))
		self:talentTemporaryValue(p, "infravision", t.getESight(self, t))
		self:talentTemporaryValue(p, "heightened_senses", t.getESight(self, t))
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if not game.player or self:getTalentLevel(t) < 5 then return end
		if self:hasEffect(self.EFF_OVERSEER_OF_NATIONS) then return end
		self:setEffect(self.EFF_OVERSEER_OF_NATIONS, 5, {type=tostring(target.type), subtype=tostring(target.subtype)})
	end,
	info = function(self, t)
		return ([[While Highers are not meant to rule other humans - and show no particular will to do so - they are frequently called to higher duties.
		Their nature grants them better senses than other humans.
		Increase blindness immunity by %d%%, maximum sight range by %d, and increases existing infravision, and heightened senses range by %d.
		At talent level 5, each time you hit a target you gain telepathy to all similar creatures in radius 15 for 5 turns.]]):
		tformat(t.getImmune(self, t) * 100, t.getSight(self, t), t.getESight(self, t))
	end,
}

newTalent{
	name = "Born into Magic",
	type = {"race/higher", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 19, 5)) end, -- Limit > 0
	getSave = function(self, t) return self:combatTalentScale(t, 5, 35, 0.75) end,
	power = function(self, t) return self:combatTalentScale(t, 7, 25) end,
	trigger = function(self, t, damtype)
		self:startTalentCooldown(t)
		self:setEffect(self.EFF_BORN_INTO_MAGIC, 5, {damtype=damtype})
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellresist", t.getSave(self, t))
		self:talentTemporaryValue(p, "resists",{[DamageType.ARCANE]=t.power(self, t)})
	end,
	info = function(self, t)
		local netpower = t.power(self, t)
		return ([[Highers were originally created during the Age of Allure by the human Conclave. They are imbued with magic at the very core of their being.
		Increase spell save by %d and arcane resistance by %d%%.
		Also, when you cast a spell dealing damage, you gain a 20%% bonus to the damage type for 5 turns. (This effect has a cooldown.)]]):
		tformat(t.getSave(self, t), netpower)
	end,
}

newTalent{
	name = "Highborn's Bloom",
	type = {"race/higher", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 20, 47, 35)) end, -- Limit >20
	on_pre_use_ai = function(self, t)
		local aitarget = self.ai_target.actor
		if not aitarget then return end -- don't activate without a target
		for i, res_def in ipairs(self.resources_def) do -- look for a depleted resource (~ 25% level or want > 4)
			if res_def.talent and self:knowTalent(res_def.talent) then
				if res_def.ai and res_def.ai.tactical and res_def.ai.tactical.want_level then
					if res_def.ai.tactical.want_level(self, aitarget) > 4 then return true end
				elseif res_def.min and res_def.max then
					local min, max, val = self[res_def.getMinFunction](self), self[res_def.getMaxFunction](self), self[res_def.getFunction](self)
					if res_def.invert_values then
						if (max-val)/(max-min) < 0.25 then return true end
					else
						if (val-min)/(max-min) < 0.25 then return true end
					end
				end
			end
		end
	end,
	tactical = function(self, t, aitarget) -- build a tactical table for all defined resources the first time this is called.
		local tacs = {}
		for i, res_def in ipairs(self.resources_def) do
			if res_def.talent then tacs[res_def.short_name] = 0.5 end
		end
		t.tactical = tacs
		return tacs
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 2, 6.1)) end,  --  Limit to < 10
	action = function(self, t)
		self:setEffect(self.EFF_HIGHBORN_S_BLOOM, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Activate some of your inner magic, using it to power your abilities.  For the next %d turns all active talents will be used without resource cost.
		Your resources must still be high enough to initially power the talent and failure rates (etc.) still apply.
		]]):tformat(duration)
	end,
}

------------------------------------------------------------------
-- Shaloren's powers
------------------------------------------------------------------
newTalentType{ type="race/shalore", name = _t"shalore", generic = true, is_spell=true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "SHALOREN_SPEED",
	name = "Grace of the Eternals",
	type = {"race/shalore", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 46, 30)) end,  -- Limit to >10 turns
	getSpeed = function(self, t) return self:combatStatScale(math.max(self:getDex(), self:getMag()), 0.1, 0.476) end,
	tactical = { DEFEND = 1 },
	action = function(self, t)
		self:setEffect(self.EFF_SPEED, 5, {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[Call upon the grace of the Eternals to increase your global speed by %d%% for 5 turns.
		The speed bonus will increase with your Dexterity or Magic (whichever is higher).]]):
		tformat(t.getSpeed(self, t) * 100)
	end,
}

newTalent{
	name = "Magic of the Eternals",
	type = {"race/shalore", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	critChance = function(self, t) return self:combatTalentScale(t, 3, 10, 0.75) end,
	critPower = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_generic_crit", t.critChance(self, t))
		self:talentTemporaryValue(p, "combat_critical_power", t.critPower(self, t))
	end,
	info = function(self, t)
		return ([[Reality bends slightly in the presence of a Shaloren due to their inherent magical nature.
		Increases critical chance by %d%% and critical strike power by %d%%.]]):
		tformat(t.critChance(self, t), t.critPower(self, t))
	end,
}

newTalent{
	name = "Secrets of the Eternals",
	type = {"race/shalore", 3},
	require = racial_req3,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 47, 25)) end, -- Limit > 5
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 21, 45) end, -- Limit < 100%
	getInvis = function(self, t) return math.ceil(self:combatStatScale("mag" , 7, 25)) end,
	mode = "sustained",
	no_energy = true,
	activate = function(self, t)
		self.invis_on_hit_disable = self.invis_on_hit_disable or {}
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			invis = self:addTemporaryValue("invis_on_hit", t.getChance(self, t)),
			power = self:addTemporaryValue("invis_on_hit_power", t.getInvis(self, t)),
			talent = self:addTemporaryValue("invis_on_hit_disable", {[t.id]=1}),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("invis_on_hit", p.invis)
		self:removeTemporaryValue("invis_on_hit_power", p.power)
		self:removeTemporaryValue("invis_on_hit_disable", p.talent)
		return true
	end,
	info = function(self, t)
		return ([[As the only immortal race of Eyal, Shaloren have learnt over the long years to use their innate inner magic to protect themselves.
		%d%% chance to become invisible (power %d) for 5 turns when hit by a blow doing at least 10%% of your total life.]]):
		tformat(t.getChance(self, t), t.getInvis(self, t))
	end,
}

newTalent{
	name = "Timeless",
	type = {"race/shalore", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	fixed_cooldown = true,
	cooldown = 50,
	getEffectGood = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getEffectBad = function(self, t) return math.floor(self:combatTalentScale(t, 2.9, 10.01, "log")) end,
	tactical = {
		BUFF = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.status == "beneficial" then nb = nb + 1 end
			end
			return nb
		end,
		CURE = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type ~= "other" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end,
	},
	action = function(self, t)
		local target = self
		local todel = {}
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.type ~= "other" then
				if e.status == "beneficial" then
					p.dur = math.min(p.dur*2, p.dur + t.getEffectGood(self, t))
				elseif e.status == "detrimental" then
					p.dur = p.dur - t.getEffectBad(self, t)
					if p.dur <= 0 then todel[#todel+1] = eff_id end
				end
			end
		end
		while #todel > 0 do
			target:removeEffect(table.remove(todel))
		end

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and self.talents_cd[tid] and not t.fixed_cooldown then tids[#tids+1] = t end
		end
		while #tids > 0 do
			local tt = rng.tableRemove(tids)
			if not tt then break end
			self.talents_cd[tt.id] = self.talents_cd[tt.id] - t.getEffectGood(self, t)
			if self.talents_cd[tt.id] <= 0 then self.talents_cd[tt.id] = nil end
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[The world grows old as you stand through the ages. To you, time is different.
		Reduces the time remaining on detrimental effects by %d, most cooling down talents by %d, and increases the time remaining on beneficial effects by %d (up to 2 times the current duration).]]):
		tformat(t.getEffectBad(self, t), t.getEffectGood(self, t), t.getEffectGood(self, t))
	end,
}

------------------------------------------------------------------
-- Thaloren's powers
------------------------------------------------------------------
newTalentType{ type="race/thalore", name = _t"thalore", generic = true, is_nature=true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "THALOREN_WRATH",  -- Backwards compatibility..
	name = "Gift of the Woods",
	type = {"race/thalore", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 45, 25)) end, -- Limit >10
	tactical = { HEAL = 2 },
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	getHealMod = function(self, t) return self:combatTalentLimit(t, 50, 10, 30) end,
	getHealing = function(self, t) return 6 + math.max(self:getWil(), self:getCon()) * 0.6 end,
	action = function(self, t)
		self:setEffect(self.EFF_REGENERATION, 8, {power=t.getHealing(self,  t)})
		self:setEffect(self.EFF_GIFT_WOODS, 8, {power=t.getHealMod(self, t) / 100})
		return true
	end,
	info = function(self, t)
		return ([[Call upon nature to regenerate your body for %d life every turn and increase healing mod by %d%% for 8 turns.
		The life healed will increase with your Willpower or Constitution (whichever is higher).]]):tformat(t.getHealing(self,  t), t.getHealMod(self, t))
	end,
}

newTalent{
	name = "Verdant",
	short_name = "UNSHACKLED",
	type = {"race/thalore", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getAffinity = function(self, t) return self:combatTalentScale(t, 25, 35) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "damage_affinity", {
			[DamageType.ACID] = t.getAffinity(self, t),
			[DamageType.NATURE] = t.getAffinity(self, t)
			})
	end,
	info = function(self, t)
		return ([[Thaloren have an affinity for natural elements, allowing them to heal for a portion of damage taken from them.
		You gain %d%% Nature and Acid damage affinity.]]):
		tformat(t.getAffinity(self, t))
	end,
}

newTalent{
	name = "Guardian of the Wood",
	type = {"race/thalore", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getDiseaseImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.75) end, -- Limit < 100%
	getBResist = function(self, t) return self:combatTalentScale(t, 3, 10) end,
	getAllResist = function(self, t) return self:combatTalentScale(t, 2, 6.5) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "disease_immune", t.getDiseaseImmune(self, t))
		self:talentTemporaryValue(p, "resists",{[DamageType.BLIGHT]=t.getBResist(self, t)})
		self:talentTemporaryValue(p, "resists",{all=t.getAllResist(self, t)})
	end,
	info = function(self, t)
		return ([[Thaloren are part of the wood; it shields them from corruption.
		Increase disease immunity by %d%%, blight resistance by %0.1f%%, and all resistances by %0.1f%%.]]):
		tformat(t.getDiseaseImmune(self, t)*100, t.getBResist(self, t), t.getAllResist(self, t))
	end,
}

newTalent{
	name = "Nature's Pride",
	type = {"race/thalore", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 46, 34)) end, -- limit >8
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = { stun = 1, knockback = 1 } },
	range = 4,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		for i = 1, 2 do
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				if i == 1 then return else break end
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "immovable", subtype = "plants",
				display = "#",
				name = _t"treant", color=colors.GREEN,
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/immovable_plants_treant.png", display_h=2, display_y=-1}}},
				desc = _t"A very strong near-sentient tree.",

				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

				rank = 3,
				life_rating = 16,
				max_life = resolvers.rngavg(50,80),
				infravision = 10,
				autolevel = "none",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, },
				stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
				combat = { dam=resolvers.levelup(resolvers.rngavg(15,25), 1, 2), atk=resolvers.levelup(resolvers.rngavg(15,25), 1, 2), dammod={str=3} },
				combat_dam = resolvers.levelup(1, 1, 2),
				combat_atk = resolvers.levelup(1, 1, 2),

				inc_stats = {
					str=25 + self:getWil(),
					dex=18 + self:getWil(),
					con=10 + self:getWil(),
					wil=25 + self:getWil(),
					cun=25 + self:getWil(),
				},
				level_range = {1, self.level}, exp_worth = 0,
				silent_levelup = true,

				resists = {all = self:combatGetResist(DamageType.BLIGHT)},

				combat_armor = 13 + self.level / 2, combat_def = 8,
				combat_armor_hardiness = 30,  -- 50% total
				resolvers.talents{ [Talents.T_STUN]=self:getTalentLevel(t), [Talents.T_KNOCKBACK]=self:getTalentLevel(t), [Talents.T_TAUNT]=self:getTalentLevel(t), },

				faction = self.faction,
				summoner = self, summoner_gain_exp=true,
				summon_time = 8,
				ai_target = {actor=target}
			}
			setupSummon(self, m, x, y)
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local base_stats = self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75)
		return ([[Nature is with the Thaloren; they can always feel the call of the woods.
		Summons two elite Treants to your side for 8 turns.
		The treants have a global resistance equal to your blight resistance and can stun, knockback, and taunt foes.
		Your Willpower (%d) will be added to all of their non-Magic primary stats and their talent levels will increase with your Nature's Pride talent level.
		Your increased damage, damage penetration, and many other stats will be inherited.]]):tformat(self:getWil())
	end,
}

------------------------------------------------------------------
-- Dwarves' powers
------------------------------------------------------------------
newTalentType{ type="race/dwarf", name = _t"dwarf", generic = true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "DWARF_RESILIENCE",
	name = "Resilience of the Dwarves",
	type = {"race/dwarf", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 45, 25)) end, -- Limit >8
	getParams = function(self, t)
		return {
			armor = self:combatStatScale("con", 7, 25),
			armor_hardiness = self:combatTalentLimit(t, 40, 20, 35),
			physical = self:combatStatScale("con", 12, 30, 0.75),
			spell = self:combatStatScale("con", 12, 30, 0.75),
		}
	end,
	tactical = { DEFEND = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_DWARVEN_RESILIENCE, 8, t.getParams(self, t))
		return true
	end,
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[Call upon the legendary resilience of the Dwarven race to increase armour (+%d), armour hardiness (+%d%%), spell (+%d) and physical (+%d) saves for 8 turns.
		The bonuses will increase with your Constitution.]]):
		tformat(params.armor, params.armor_hardiness, params.physical, params.spell)
	end,
}

newTalent{
	name = "Stoneskin",
	type = {"race/dwarf", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	armor = function(self, t) return self:combatTalentScale(t, 6, 40) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "auto_stoneskin", t.armor(self, t))
	end,
	info = function(self, t)
		return ([[Dwarf skin is a complex structure; it can automatically react to physical blows and harden itself.
		When you are hit in melee, you have a 15%% chance to increase your armour total by %d for 5 turns and fully ignore the attack triggering it.
		There is no cooldown to this effect; it can happen while already active.]]):
		tformat(t.armor(self, t))
	end,
}

newTalent{
	name = "Power is Money",
	type = {"race/dwarf", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getMaxSaves = function(self, t) return self:combatTalentScale(t, 8, 50) end,
	getGold = function(self, t) return self:combatTalentLimit(t, 40, 85, 65) end, -- Limit > 40
	-- called by _M:combatPhysicalResist, _M:combatSpellResist, _M:combatMentalResist in mod.class.interface.Combat.lua
	getSaves = function(self, t)
		return util.bound(self.money / t.getGold(self, t), 0, t.getMaxSaves(self, t))
	end,
	info = function(self, t)
		return ([[Money is the heart of the Dwarven Empire; it rules over all other considerations.
		Increases Physical, Mental and Spell Saves based on the amount of gold you possess.
		+1 save every %d gold, up to +%d. (currently +%d)]]):
		tformat(t.getGold(self, t), t.getMaxSaves(self, t), t.getSaves(self, t))
	end,
}

newTalent{
	name = "Stone Walking",
	type = {"race/dwarf", 4},
	require = racial_req4,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit >5
	range = 1,
	no_npc_use = true,
	getRange = function(self, t)
		return math.max(1, math.floor(self:combatScale(0.04*self:getCon() + self:getTalentLevel(t), 2.4, 1.4, 10, 9)))
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), nolock=true, talent=t, simple_dir_request=true}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		local ox, oy = self.x, self.y
		local l = line.new(self.x, self.y, x, y)
		local nextx, nexty = l()
		if not nextx or not game.level.map:checkEntity(nextx, nexty, Map.TERRAIN, "block_move", self) then return end

		self:probabilityTravel(x, y, t.getRange(self, t))

		if ox == self.x and oy == self.y then return end

		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[While the origins of the dwarves remain clouded in mystery to the other races, it is obvious that they share strong ties to the stone.
		You can target any wall and immediately enter it, appearing on the other side.
		This can pass through up to %d tiles (increases with Constitution and talent level).]]):
		tformat(range)
	end,
}

------------------------------------------------------------------
-- Halflings' powers
------------------------------------------------------------------
newTalentType{ type="race/halfling", name = _t"halfling", generic = true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "HALFLING_LUCK",
	name = "Luck of the Little Folk",
	type = {"race/halfling", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit >5
	getParams = function(self, t)
		return {
			crit = self:combatStatScale("cun", 15, 60, 0.75),
			save = self:combatStatScale("cun", 15, 60, 0.75),
			}
	end,
	tactical = { ATTACK = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_HALFLING_LUCK, 5, t.getParams(self, t))
		return true
	end,
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[Call upon the luck and cunning of the Little Folk to increase your critical strike chance by %d%% and your saves by %d for 5 turns.
		The bonus will increase with your Cunning.]]):
		tformat(params.crit, params.save)
	end,
}

newTalent{
	name = "Duck and Dodge",
	type = {"race/halfling", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getThreshold = function(self, t) return math.max(10, (15 - self:getTalentLevelRaw(t))) / 100 end,
	getEvasionChance = function(self, t) return 50 end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 1.3, 3.3)) end,
	-- called by _M:onTakeHit function in mod.class.Actor.lua for trigger 
	getDefense = function(self) 
		local oldevasion = self:hasEffect(self.EFF_EVASION)
		return self:getStat("lck")/200*(self:combatDefenseBase() - (oldevasion and oldevasion.defense or 0)) -- Prevent stacking
	end,
	info = function(self, t)
		local threshold = t.getThreshold(self, t)
		local evasion = t.getEvasionChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[Halfling's incredible luck always kicks in at just the right moment to save their skin.
		Whenever you take %d%% or more of your life from a single attack, you gain %d%% Evasion and %d additional defense for the next %d turns. The defense increases based on your luck and other defensive stats.]]):
		tformat(threshold * 100, evasion, t.getDefense(self), duration)
	end,
}

newTalent{
	name = "Militant Mind",
	type = {"race/halfling", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	info = function(self, t)
		return ([[Halflings have always been a very organised and methodical race; the more foes they face, the more organised they are.
		If two or more foes are in sight your Physical Power, Physical Save, Spellpower, Spell Save, Mental Save, and Mindpower are increased by %0.1f per foe (up to 5 foes).]]):
		tformat(self:getTalentLevel(t) * 2)
	end,
}

newTalent{
	name = "Indomitable",
	type = {"race/halfling", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 45, 25)) end, -- limit >10
	tactical = { DEFEND = function(self, t, aitarget)
			local count, t = 0
			for tid, _ in pairs(aitarget.talents) do
				t = aitarget.talents_def[tid]
				if t and type(t.tactical) == "table" and type(t.tactical.disable) == "table" and (t.tactical.disable.stun or t.tactical.disable.pin) then
					count = count + 1
					if count > 1 then break end
				end
			end
			return count
		end,
		CURE = function(self, t, aitarget)
			local count, e = 0
			for eff_id, p in pairs(self.tmp) do
				e = self.tempeffect_def[eff_id]
				if e.subtype.stun or e.subtype.pin then
					count = count + 1
				end
			end
			return count
		end},
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local effs = {}

		-- Go through all effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.stun or e.subtype.pin then -- Daze is stun subtype
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
			end
		end
	
		self:setEffect(self.EFF_FREE_ACTION, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[Halflings have one of the most powerful military forces in the known world and have been at war with most other races for thousands of years.
		Removes %d stun, daze, or pin effects and grants immunity to stuns, dazes and pins for %d turns.]]):tformat(duration, count)
	end,
}

------------------------------------------------------------------
-- Orcs' powers
------------------------------------------------------------------
newTalentType{ type="race/orc", name = _t"orc", generic = true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "ORC_FURY",
	name = "Orcish Fury",
	type = {"race/orc", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 46, 30)) end, -- Limit to >5 turns
	getPower = function(self, t) return self:combatStatScale("con", 1, 6 ) end,
	enemyCount = function(self, t) -- Count actors in LOS and seen
		local nb = 0
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and self:canSee(act) then nb = nb + 1 end
			if nb >= 5 then break end
		end
		self.turn_procs[t.id] = {count = nb}
		return nb
	end,
	on_pre_use_ai = function(self, t, silent, fake) -- don't use without visible enemies
		local nb = self.turn_procs[t.id] and self.turn_procs[t.id].count or t.enemyCount(self, t)
		if nb > 0 then return true end
	end,
	tactical = { BUFF = function(self, t, aitarget)
			local nb = self.turn_procs[t.id] and self.turn_procs[t.id].count or t.enemyCount(self, t)
			return nb^.5
		end
	},
	action = function(self, t)
		local nb = self.turn_procs[t.id] and self.turn_procs[t.id].count or t.enemyCount(self, t)
		if nb <= 0 then return false end
		self:setEffect(self.EFF_ORC_FURY, 3, {power=10 + t.getPower(self, t) * math.min(5, nb)})
		return true
	end,
	info = function(self, t)
		return ([[Summons your lust for blood and destruction; especially when the odds are against you.  
		You increase your damage by 10%% + %0.1f%% per enemy you can see in line of sight of you (maximum 5 enemies, %0.1f%% bonus) for 3 turns.
		The damage bonus will increase with your Constitution.]]):
		tformat(t.getPower(self, t), 10 + t.getPower(self, t) * 5)
	end,
}

newTalent{
	name = "Hold the Ground",
	type = {"race/orc", 2},
	require = racial_req2,
	points = 5,
	cooldown = function(self, t) return 12 end,
	mode = "passive",
	getSaves = function(self, t) return self:combatTalentScale(t, 4, 16, 0.75) end,
	getDebuff = function(self, t) return math.ceil(self:combatTalentStatDamage(t, "wil", 1, 5)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physresist", t.getSaves(self, t))
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if self:isTalentCoolingDown(t) then return end
		if not ( (self.life - dam) < (self.max_life * 0.5) ) then return end
		
		local nb = self:removeEffectsFilter(self, {status = "detrimental", type = "mental"}, t.getDebuff(self, t))
		if nb > 0 then
			game.logSeen(self, "#CRIMSON#%s roars with rage shaking off %d mental debuffs!", self:getName():capitalize(), nb)
			self:startTalentCooldown(t)
		end
	end,
	info = function(self, t)
		return ([[Orcs have been the prey of the other races for thousands of years, with or without justification. They have learnt to withstand things that would break weaker races.
		When your life goes below 50%% your sheer determination cleanses you of %d mental debuff(s) based on talent level and Willpower.  This can only happen once every %d turns.
		Also increases physical save by %d.]]):
		tformat(t.getDebuff(self, t), self:getTalentCooldown(t), t.getSaves(self, t))
	end,
}

newTalent{
	name = "Skirmisher",
	type = {"race/orc", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getPen = function(self, t) return self:combatTalentLimit(t, 20, 7, 15) end,
	getResist = function(self, t) return 5+self:combatTalentStatDamage(t, "con", 3, 10) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists_pen", {all = t.getPen(self, t)})
	end,
	callbackOnKill = function(self, t, who)
		self:setEffect(self.EFF_ORC_TRIUMPH, 2, {resists = t.getResist(self, t)})
	end,

	info = function(self, t)
		return ([[Orcs have seen countless battles, and won many of them.
		You revel in the defeat of your foes, gaining %d%% damage resistance for 2 turns each time you kill an enemy.
		The resistance will scale with talent level and your Constitution.
		Additionally, passively increase all damage penetration by %d%%.]]):
		tformat(t.getResist(self, t), t.getPen(self, t))
	end,
}

newTalent{
	name = "Pride of the Orcs",
	type = {"race/orc", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 46, 30)) end, -- Limit to >10
	remcount  = function(self,t) return math.ceil(self:combatTalentScale(t, 0.5, 3, "log", 0, 3)) end,
	heal = function(self, t) return 50+self:combatTalentStatDamage(t, "wil", 100, 500) end,
	tactical = { HEAL = 1, CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				nb = nb + 1
			end
		end
		return nb^0.5
	end },
	action = function(self, t)
		local target = self
		local effs = {}

		-- Go through all temporary effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.remcount(self,t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end

		if not self:attr("no_healing") and ((self.healing_factor or 1) > 0) then
			self:attr("allow_on_heal", 1)
			self:heal(t.heal(self, t), t)
			if core.shader.active(4) then
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
			self:attr("allow_on_heal", -1)
		end
		return true
	end,
	info = function(self, t)
		return ([[Call upon the will of all of the Orc Prides to survive this battle.
		You remove up to %d detrimental effect(s) then heal for %d life.
		The healing will increase with talent level and your Willpower.]]):
		tformat(t.remcount(self,t), t.heal(self, t))
	end,
}

------------------------------------------------------------------
-- Yeeks' powers
------------------------------------------------------------------
-- We check for max life on boss targets to avoid people using this to engage thus ensuring all their allies target them first
newTalentType{ type="race/yeek", name = _t"yeek", is_mind=true, generic = true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "YEEK_WILL",
	name = "Dominant Will",
	type = {"race/yeek", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 47, 35)) end, -- Limit >10
	getduration = function(self) return math.floor(self:combatStatScale("wil", 5, 14)) end,
	range = 4,
	no_npc_use = true,
	requires_target = true,
	direct_hit = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not x or not y then return nil end
		if not target or target.dead or target == self then return end
		if game.party:hasMember(target) then return end
		if target.instakill_immune and target.instakill_immune >= 1 then  -- We special case this instead of letting the canBe check waste the talent because instakill is at present always binary
			game.logSeen(target, "%s is immune to instakill and mind control effects!", target:getName():capitalize())
			return
		end
		if target.rank > 3 and ((target.life / target.max_life) >= 0.8) then
			game.logSeen(target, "%s must be below 80%% of their max life to be controlled!", target:getName():capitalize())
			return
		end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target:canBe("instakill") then
				target:takeHit(1, self)
				target:takeHit(1, self)
				target:takeHit(1, self)
				if target.rank > 3 then
					target:setEffect(target.EFF_DOMINANT_WILL_BOSS, 3, {src=self})
				else
					target:setEffect(target.EFF_DOMINANT_WILL, t.getduration(self), {src=self})
				end
			else
				game.logSeen(target, "%s resists the mental assault!", target:getName():capitalize())
			end

		end)
		return true
	end,
	info = function(self, t)
	return ([[Shatter the mind of your victim, giving you full control of its actions for %s turns (based on your Willpower).
	When the effect ends, you pull out your mind and the victim's body collapses, dead.
	Targets with ranks at or above rare must be below 80%% of their maximum life to be controlled, will be invulnerable for the duration, and will break free of the effect without dying after 3 turns.
	This effect cannot be saved against but checks instakill immunity.]]):tformat(t.getduration(self))
	end,
}

newTalent{
	name = "Unity",
	type = {"race/yeek", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.17, 0.6) end, -- Limit < 100%
	getSave = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "confusion_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "silence_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "combat_mentalresist", t.getSave(self, t))
	end,
	info = function(self, t)
		return ([[Your mind becomes more attuned to the Way, and is shielded from outside effects.
		Increase confusion and silence immunities by %d%% and Mental Save by %d.]]):
		tformat(100*t.getImmune(self, t), t.getSave(self, t))
	end,
}

newTalent{
	name = "Quickened",
	type = {"race/yeek", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	speedup = function(self, t) return self:combatTalentScale(t, 0.04, 0.15, 0.75) end,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 20, 50, 30)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "global_speed_base", t.speedup(self, t))
		self:recomputeGlobalSpeed()
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if self:isTalentCoolingDown(t) then return end
		if (self.life / self.max_life) >= 0.3 then return end

		game.logSeen(self, "#RED#%s reacts immediately after taking severe wounds!#LAST#", self:getName():capitalize())
		self.energy.value = self.energy.value + game.energy_to_act * 1.5
		self:startTalentCooldown(t)
	end,
	info = function(self, t)
		return ([[Yeeks live fast, think fast, and sacrifice fast for the Way.
		Your global speed is increased by %0.1f%%.
		If your life drops below 30%% you gain 1.5 turns.  This effect can only happen once every %d turns.]]):tformat(100*t.speedup(self, t), self:getTalentCooldown(t))
	end,
}

newTalent{
	name = "Wayist",
	type = {"race/yeek", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 6, 47, 35)) end, -- Limit >6
	range = 4,
	no_npc_use = true, -- make available to NPCs?
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		for i = 1, 3 do
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				break
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "humanoid", subtype = "yeek",
				display = "y",
				name = _t"yeek mindslayer", color=colors.YELLOW,
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_yeek_yeek_mindslayer.png", display_h=2, display_y=-1}}},
				desc = _t"A wayist that came to help.",

				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, PSIONIC_FOCUS=1 },

				rank = 3,
				life_rating = 8,
				max_life = resolvers.rngavg(50,80),
				combat_atk = resolvers.levelup(1, 1, 3),

				infravision = 10,

				autolevel = "none",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=2, },
				stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
				inc_stats = {
					str=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					mag=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					cun=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					wil=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					dex=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					con=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
				},
				resolvers.equip{
					{type="weapon", subtype="longsword", autoreq=true},
					{type="weapon", subtype="dagger", autoreq=true},
					{type="weapon", subtype="greatsword", autoreq=true, force_inven = "PSIONIC_FOCUS"},
				},

				level_range = {1, self.level}, exp_worth = 0,
				silent_levelup = true,

				combat_armor = 13, combat_def = 8,
				resolvers.talents{
					[Talents.T_KINETIC_SHIELD]={base=1, every=5, max=5},
					[Talents.T_KINETIC_AURA]={base=1, every=5, max=5},
					[Talents.T_CHARGED_AURA]={base=1, every=5, max=5},
				},
				resolvers.sustains_at_birth(),
				
				faction = self.faction,
				summoner = self, summoner_gain_exp=true,
				summon_time = 6,
				ai_target = {actor=target},
				no_drops = 1,
			}
			setupSummon(self, m, x, y)
			m.temporary_level = true
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local base_stats = self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75)
		return ([[Reach through the collective psionic gestalt of the yeeks, the Way, to call for immediate help.
		Summons up to 3 yeek mindslayers to your side for 6 turns.
		All their primary stats will be set to %d (based on your Willpower and Talent Level).
		Your increased damage, damage penetration, and many other stats will be inherited.]]):tformat(base_stats)
	end,
}

-- Yeek's power: ID
newTalent{
	short_name = "YEEK_ID",
	name = "Knowledge of the Way",
	type = {"base/race", 1},
	no_npc_use = true,
	no_unlearn_last = true,
	mode = "passive",
	on_learn = function(self, t) self.auto_id = 100 end,
	info = function(self, t)
		return ([[You merge your mind with the rest of the Way for a brief moment; the sum of all yeek knowledge gathers in your mind
		and allows you to identify any item you could not recognize yourself.]]):tformat()
	end,
}

------------------------------------------------------------------
-- Ogre' powers
------------------------------------------------------------------
newTalentType{ type="race/ogre", name = _t"ogre", is_spell=true, generic = true, description = _t"The various racial bonuses a character can have." }
newTalent{
	short_name = "OGRE_WRATH",
	name = "Ogric Wrath",
	type = {"race/ogre", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 47, 35)) end, -- Limit >10
	getduration = function(self) return math.floor(self:combatStatScale("str", 5, 12)) end,
	range = 4,
	no_npc_use = true,
	requires_target = true,
	direct_hit = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		self:setEffect(self.EFF_OGRIC_WRATH, t.getduration(self, t), {})
		return true
	end,
	info = function(self, t)
		return ([[You enter an ogric wrath for %d turns, increasing your stun and pinning resistances by 20%% and all damage done by 10%%.
		In addition, whenever you use an infusion or rune, miss a melee attack, or any damage you deal is reduced by a damage shield (or similar effect) you gain a charge of Ogre Fury (up to 5 charges total, each lasting 7 turns).
		Each charge grants 20%% critical damage power and 5%% critical strike chance.
		You lose a charge each time you deal a critical strike.
		The duration will increase with your Strength.]]):tformat(t.getduration(self))
	end,
}

newTalent{
	name = "Grisly Constitution",
	type = {"race/ogre", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	no_unlearn_last = true,
	getSave = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	getMult = function(self, t) return self:combatTalentScale(t, 15, 30) / 100 end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellresist", t.getSave(self, t))
		self:talentTemporaryValue(p, "inscriptions_stat_multiplier", t.getMult(self, t))
	end,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 5 then self:attr("allow_mainhand_2h_in_1h", 1) end
	end,
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 4 then self:attr("allow_mainhand_2h_in_1h", -1) end
	end,
	info = function(self, t)
		return ([[An ogre's body is acclimated to spells and inscriptions.
		Increases spell save by %d and improves the contribution of primary stats on infusions and runes by %d%%.
		At level 5 your body is so strong you can use a two handed weapon in your main hand while still using an offhand item.
		When using a two handed weapon this way you suffer a 20%% accuracy, physical power, spellpower and mindpower penalty, decreasing by 5%% per size category above #{italic}#big#{normal}#; further, all damage procs from your weapons are reduced by 50%%.]]):
		tformat(t.getSave(self, t), t.getMult(self, t) * 100)
	end,
}

newTalent{
	name = "Scar-Scripted Flesh", short_name = "SCAR_SCRIPTED_FLESH",
	type = {"race/ogre", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 20, 45) end, -- Limit < 100%
	callbackOnCrit = function(self, t)
		if self.turn_procs.scar_scripted_flesh then return end
		if not rng.percent(t.getChance(self, t)) then return end
		self.turn_procs.scar_scripted_flesh = true
		self:alterEffectDuration(self.EFF_RUNE_COOLDOWN, -1)
		self:alterEffectDuration(self.EFF_INFUSION_COOLDOWN, -1)

		local list = {}
		for tid, c in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t and t.is_inscription then
				list[#list+1] = tid
			end
		end
		if #list > 0 then
			local tid = rng.table(list)
			self:alterTalentCoolingdown(tid, -1)
		end
	end,
	info = function(self, t)
		return ([[When you crit you have a %d%% chance to reduce by 1 the remaining cooldown of one of your inscriptions and of any saturations effects.
		This effect can only happen once per turn.]]):
		tformat(t.getChance(self, t))
	end,
}

newTalent{
	name = "Writ Large",
	type = {"race/ogre", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	no_unlearn_last = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 6, 47, 35)) end, -- Limit >6
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 15, 5, 10)) end,
	on_levelup_close = function(self, t, lvl, old_lvl, lvl_raw, old_lvl_raw)
		if lvl_raw >= 5 and old_lvl_raw < 5 then
			self.inscriptions_slots_added = self.inscriptions_slots_added - 1
			game.logPlayer(self, "#PURPLE#Your mastery over inscriptions is unmatched! One more inscriptions slot available to buy.")
		end
	end,
	action = function(self, t)
		self:removeEffect(self.EFF_RUNE_COOLDOWN)
		self:removeEffect(self.EFF_INFUSION_COOLDOWN)
		self:setEffect(self.EFF_WRIT_LARGE, t.getDuration(self, t), {power=1})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[Instantly removes runic and infusion saturations.
		For %d turns your inscriptions cool down twice as fast.
		At level 5 your command over inscriptions is so good that you can use one more (you still need a category point to unlock it; you need to exit the levelup screen to validate it).]]):
		tformat(t.getDuration(self, t))
	end,
}
