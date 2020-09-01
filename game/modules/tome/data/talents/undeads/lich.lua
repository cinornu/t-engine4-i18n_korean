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

newTalent{
	name = "Neverending Unlife", image = "talents/lichform.png",
	type = {"undead/lich", 1},
	mode = "passive",
	require = high_undeads_req1,
	points = 5,
	no_unlearn_last = true,
	getDieAt = function(self, t) return math.ceil(self:combatTalentLimit(t, 150, 20, 100)) end,
	getTurns = function(self, t) return math.ceil(self:combatTalentLimit(t, 300, 40, 130)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "die_at", -t.getDieAt(self, t))
	end,
	callbackOnDeathbox = function(self, t, dialog, list)
		if not self.lich_first_rez then
			dialog.dont_show = true
			self.lich_first_rez = true
			_G.a=dialog
			dialog:cleanActor(self)
			dialog:resurrectBasic(self, "lich_rebirth")
			dialog:restoreResources(self)
			self:callTalent(self.T_LICH, "becomeLich")

			game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
			self:check("on_resurrect", "lich_rebirth")
			self:triggerHook{"Actor:resurrect", reason="lich_rebirth"}
			world:gainAchievement("LICHFORM", actor)
			game:saveGame()
			return true
		elseif not self:hasEffect(self.EFF_LICH_HUNGER) and not self.lich_no_more_regen then
			list[#list+1] = {name=("Lich Regeneration (%d turns)"):tformat(t.getTurns(self, t)), action=function()
				dialog:cleanActor(self)
				dialog:resurrectBasic(self, "lich_regen")
				dialog:restoreResources(self)

				game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
				self:check("on_resurrect", "lich_regen")
				self:triggerHook{"Actor:resurrect", reason="lich_regen"}
				self:setEffect(self.EFF_LICH_HUNGER, t.getTurns(self, t), {})
				game:saveGame()
			end, force_choice=true}
		end
	end,
	info = function(self, t)
		return ([[A Lich's body is extremely hard to fully destroy. You only die with your life reaches -%d.
		In addition even when destroyed your body regenerates to full life.
		The first time this happens, your transformation into a Lich is completed, granting you all the powers of Lichdom.
		Any further death will still regenerate you but you will need to consume the essence of a creature of unique/boss/elite boss or more rank within %d turns to sustain yourself.
		If you have not killed one when the duration expires or if you are killed again in this duration, you die permanently.
		If this happens this power can never re-activate, even if you managed to resurrect by other means.]]):
		tformat(t.getDieAt(self, t), t.getTurns(self, t))
	end,
}

newTalent{
	name = "Frightening Presence",
	type = {"undead/lich", 2},
	require = high_undeads_req2,
	mode = "passive",
	points = 5,
	radius = function(self, t) return math.ceil(self:combatTalentLimit(t, 15, 3, 10)) end,
	getImmune = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 17, 9)) end,
	getSpeed = function(self, t) return math.ceil(self:combatTalentLimit(t, 50, 10, 30)) end,
	getSaves = function(self, t) return math.ceil(self:combatTalentScale(t, 10, 40)) end,
	getDam = function(self, t) return math.ceil(self:combatTalentScale(t, 10, 25)) end,
	callbackOnActBase = function(self, t)
		self:projectApply({type="ball", radius=self:getTalentRadius(t), selffire=false}, self.x, self.y, Map.ACTOR, function(target)
			if target:hasEffect(target.EFF_LICH_RESISTED) then return end
			if self:checkHit(math.max(self:combatSpellpower(), self:combatPhysicalpower()), target:combatMentalResist(), 0, 95, 5) then
				target:setEffect(target.EFF_LICH_FEAR, 3, {saves=t.getSaves(self, t), dam=t.getDam(self, t), speed=t.getSpeed(self, t)})
			else
				target:setEffect(target.EFF_LICH_RESISTED, t.getImmune(self, t), {})
			end
		end, "hostile")
	end,
	info = function(self, t)
		return ([[Your mere presence is terrying to any foes that dare stand against you.
		Every turn all foes in radius %d must make a metal save against your spellpower/physical power (whichever is highest) or become frightened (bypassing fear immunity), reducing all their saves by %d, all damage by %d%% and movement speed by %d%%.
		If they successfully resist, they are immune for %d turns.]]):
		tformat(self:getTalentRadius(t), t.getSaves(self, t), t.getDam(self, t), t.getSpeed(self, t), t.getImmune(self, t))
	end,
}

newTalent{
	short_name = "SHADOW_DARKNESS",
	name = "Shadow Invoke Darkness",
	type = {"spell/other", 1},
	require = { },
	points = 5,
	range = 6,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 140) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.DARKNESS, dam)
		game.level.map:particleEmitter(x, y, 1, "dark")
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Bathes the target in flames doing %0.2f damage
		The damage will increase with the Magic stat]]):
		tformat(damDesc(self, DamageType.DARKNESS, damage))
	end,
}
newTalent{
	short_name = "SHADOW_COLD",
	name = "Shadow Cold Touch",
	type = {"spell/other", 1},
	require = { },
	points = 5,
	range = 1,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 200) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.COLD, dam)
		game.level.map:particleEmitter(x, y, 1, "icetrail")
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Bathes the target in flames doing %0.2f damage
		The damage will increase with the Magic stat]]):
		tformat(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

local function createLichShadow(self, level, tCallShadows, tShadowWarriors, tShadowMages, duration, target)
	local npc = require("mod.class.NPC").new{
		type = "undead", subtype = "lich shadow",
		name = "shadow",
		desc = [[]], image = "npc/lich_s_shadow.png",
		display = 'b', color=colors.BLACK,

		never_anger = true,
		summoner = self,
		summoner_gain_exp=true,
		summon_time = duration,
		faction = self.faction,
		size_category = 2,
		rank = 2,
		autolevel = "none",
		level_range = {level, level},
		exp_worth=0,
		hate_regen = 1,
		avoid_traps = 1,
		is_lich_shadow = true,

		max_life = resolvers.rngavg(3,12), life_rating = 5,
		stats = { -- affected by stat limits
			str=math.floor(self:combatScale(level, 5, 0, 55, 50, 0.75)),
			dex=math.floor(self:combatScale(level, 10, 0, 85, 50, 0.75)),
			mag=math.floor(self:combatScale(level, 10, 0, 85, 50, 0.75)),
			wil=math.floor(self:combatScale(level, 5, 0, 55, 50, 0.75)),
			cun=math.floor(self:combatScale(level, 5, 0, 40, 50, 0.75)),
			con=math.floor(self:combatScale(level, 5, 0, 40, 50, 0.75)),
		},
		combat_armor = 0, combat_def = 3,
		combat = {
			dam=math.floor(self:combatScale(level, 1.5, 1, 75, 50, 0.75)),
			atk=10 + level,
			apr=8,
			dammod={str=0.5, dex=0.5}
		},
		mana = 100,
		combat_spellpower = tShadowMages and tShadowMages.getSpellpowerChange(self, tShadowMages) or 0,
		resolvers.talents{
			[self.T_SHADOW_PHASE_DOOR]=tCallShadows.getPhaseDoorLevel(self, tCallShadows),
			[self.T_SHADOW_BLINDSIDE]=tCallShadows.getBlindsideLevel(self, tCallShadows),
			[self.T_HEAL]=tCallShadows.getHealLevel(self, tCallShadows),
			[self.T_DOMINATE]=tShadowWarriors and tShadowWarriors.getDominateLevel(self, tShadowWarriors) or 0,
			[self.T_SHADOW_FADE]=tShadowWarriors and tShadowWarriors.getFadeLevel(self, tShadowWarriors) or 0,
			[self.T_SHADOW_COLD]=tShadowMages and tShadowMages.getLightningLevel(self, tShadowMages) or 0,
			[self.T_SHADOW_DARKNESS]=tShadowMages and tShadowMages.getFlamesLevel(self, tShadowMages) or 0,
			[self.T_SHADOW_REFORM]=tShadowMages and tShadowMages.getReformLevel(self, tShadowMages) or 0,
		},

		undead = 1,
		no_breath = 1,
		stone_immune = 1,
		confusion_immune = 1,
		fear_immune = 1,
		teleport_immune = 1,
		disease_immune = 1,
		poison_immune = 1,
		stun_immune = 1,
		blind_immune = 1,
		see_invisible = 80,
		resists = { [DamageType.LIGHT] = -100, [DamageType.DARKNESS] = 100 },
		resists_pen = { all=25 },

		avoid_master_damage = (100 - tCallShadows.getAvoidMasterDamage(self, tCallShadows)) / 100,

		ai = "shadow",
		ai_state = {
			summoner_range = 10,
			actor_range = 8,
			location_range = 4,
			target_time = 0,
			target_timeout = 10,
			focus_on_target = false,
			shadow_wall = false,
			shadow_wall_time = 0,

			blindside_chance = 15,
			phasedoor_chance = 5,
			close_attack_spell_chance = 0,
			far_attack_spell_chance = 0,
			can_reform = false,
			dominate_chance = 0,

			feed_level = 0
		},
		ai_target = {
			actor=target,
			x = nil,
			y = nil
		},

		healSelf = function(self)
			self:useTalent(self.T_HEAL)
		end,
		closeAttackSpell = function(self)
			return self:useTalent(self.T_SHADOW_COLD)
		end,
		farAttackSpell = function(self)
			if self:knowTalent(self.T_EMPATHIC_HEX) and not self:isTalentCoolingDown(self.T_EMPATHIC_HEX) and rng.percent(50) then
				return self:useTalent(self.T_EMPATHIC_HEX)
			else
				return self:useTalent(self.T_SHADOW_DARKNESS)
			end
		end,
		dominate = function(self)
			return self:useTalent(self.T_DOMINATE)
		end,
		feed = function(self)
			if self.summoner:knowTalent(self.summoner.T_DOOMED_FOR_ETERNITY) then
				local tShadowMages = self.summoner:getTalentFromId(self.summoner.T_DOOMED_FOR_ETERNITY)
				self.ai_state.close_attack_spell_chance = tShadowMages.getCloseAttackSpellChance(self.summoner, tShadowMages)
				self.ai_state.far_attack_spell_chance = tShadowMages.getFarAttackSpellChance(self.summoner, tShadowMages)
				self.ai_state.can_reform = self.summoner:getTalentLevel(tShadowMages) >= 5
			else
				self.ai_state.close_attack_spell_chance = 0
				self.ai_state.far_attack_spell_chance = 0
				self.ai_state.can_reform = false
			end

			if self.ai_state.feed_temp1 then self:removeTemporaryValue("combat_atk", self.ai_state.feed_temp1) end
			self.ai_state.feed_temp1 = nil
			if self.ai_state.feed_temp2 then self:removeTemporaryValue("inc_damage", self.ai_state.feed_temp2) end
			self.ai_state.feed_temp2 = nil
			if self.summoner:knowTalent(self.summoner.T_DOOMED_FOR_ETERNITY) then
				local tShadowWarriors = self.summoner:getTalentFromId(self.summoner.T_DOOMED_FOR_ETERNITY)
				self.ai_state.feed_temp1 = self:addTemporaryValue("combat_atk", tShadowWarriors.getCombatAtk(self.summoner, tShadowWarriors))
				self.ai_state.feed_temp2 = self:addTemporaryValue("inc_damage", {all=tShadowWarriors.getIncDamage(self.summoner, tShadowWarriors)})
				self.ai_state.dominate_chance = tShadowWarriors.getDominateChance(self.summoner, tShadowWarriors)
			else
				self.ai_state.dominate_chance = 0
			end
		end,
		onTakeHit = function(self, value, src)
			if src == self.summoner and self.avoid_master_damage then
				value = value * self.avoid_master_damage
			end

			if self:knowTalent(self.T_SHADOW_FADE) and not self:isTalentCoolingDown(self.T_SHADOW_FADE) and not (self.avoid_master_damage == 0) then
				self:forceUseTalent(self.T_SHADOW_FADE, {ignore_energy=true})
			end

			return mod.class.Actor.onTakeHit(self, value, src)
		end,
		on_act = function(self)
			-- clean up
			if self.summoner.dead then
				self:die(self)
			end
		end
	}
	self:attr("summoned_times", 1)
	return npc
end

newTalent{
	name = "Doomed For Eternity",
	type = {"undead/lich", 3},
	require = high_undeads_req3,
	points = 5,
	mode = "sustained",
	no_energy = true,
	cooldown = 10,
	unlearn_on_clone = true,
	tactical = { BUFF = 5 },
	getLevel = function(self, t) return self.level end,
	getMaxShadows = function(self, t)
		return math.min(4, math.max(1, math.floor(self:getTalentLevel(t) * 0.55)))
	end,
	getAvoidMasterDamage = function(self, t)
		return util.bound(self:combatTalentScale(t, 5, 85), 0, 100)
	end,
	getPhaseDoorLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getBlindsideLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getHealLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getIncDamage = function(self, t)
		return math.floor((math.sqrt(self:getTalentLevel(t)) - 0.5) * 35)
	end,
	getCombatAtk = function(self, t)
		return math.floor((math.sqrt(self:getTalentLevel(t)) - 0.5) * 23)
	end,
	getDominateLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getFadeLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getDominateChance = function(self, t)
		if self:getTalentLevelRaw(t) > 0 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	getCloseAttackSpellChance = function(self, t)
		if math.floor(self:getTalentLevel(t)) > 0 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	getFarAttackSpellChance = function(self, t)
		if math.floor(self:getTalentLevel(t)) >= 3 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	getLightningLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getFlamesLevel = function(self, t)
		if self:getTalentLevel(t) >= 3 then
			return self:getTalentLevelRaw(t)
		else
			return 0
		end
	end,
	getReformLevel = function(self, t)
		if self:getTalentLevel(t) >= 5 then
			return self:getTalentLevelRaw(t)
		else
			return 0
		end
	end,
	canReform = function(self, t)
		return t.getReformLevel(self, t) > 0
	end,
	getSpellpowerChange = function(self, t) return math.floor(self:combatTalentScale(t, 3, 15, 0.75)) end,
	activate = function(self, t)
		local ret = {}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="call_shadows"}, shader={type="rotatingshield", noup=2.0, cylinderRotationSpeed=1.7, appearTime=0.2}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="call_shadows"}, shader={type="rotatingshield", noup=1.0, cylinderRotationSpeed=1.7, appearTime=0.2}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		-- unsummon the shadows
		for _, e in pairs(game.level.entities) do
			if e.summoner and e.summoner == self and e.subtype == "lich shadow" then
				e.summon_time = 0
			end
		end

		return true
	end,
	nbShadowsUp = function(self, t)
		if not game.level then return 0 end
		local shadowCount = 0
		for _, e in pairs(game.level.entities) do
			if e.summoner and e.summoner == self and e.subtype == "lich shadow" then shadowCount = shadowCount + 1 end
		end
		return shadowCount
	end,
	summonShadow = function(self, t)
		local shadowCount = 0
		for _, e in pairs(game.level.entities) do
			if e.summoner and e.summoner == self and e.subtype == "lich shadow" then shadowCount = shadowCount + 1 end
		end

		if shadowCount >= t.getMaxShadows(self, t) then
			return false
		end
		
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 8, true, {[Map.ACTOR]=true})
		if not x then
			return false
		end

		local level = t.getLevel(self, t)
		local tShadowMages = self:knowTalent(self.T_DOOMED_FOR_ETERNITY) and self:getTalentFromId(self.T_DOOMED_FOR_ETERNITY) or nil

		local shadow = createLichShadow(self, level, t, t, t, 1000, nil)

		shadow:resolve()
		shadow:resolve(nil, true)
		shadow:forceLevelup(level)
		game.zone:addEntity(game.level, shadow, "actor", x, y)
		shadow:feed()
		game.level.map:particleEmitter(x, y, 1, "teleport_in")

		-- Reduce power of shadows for low level rares
		if self.inc_damage and self.inc_damage.all and self.inc_damage.all < 0 then
			shadow.inc_damage.all = (shadow.inc_damage.all or 0) + self.inc_damage.all
		end

		shadow.no_party_ai = true
		shadow.unused_stats = 0
		shadow.unused_talents = 0
		shadow.unused_generics = 0
		shadow.unused_talents_types = 0
		shadow.no_points_on_levelup = true
		if game.party:hasMember(self) then
			shadow.remove_from_party_on_death = true
			game.party:addMember(shadow, { control="no", type="summon", title="Summon"})
		end

		game:playSoundNear(self, "talents/spell_generic")
	end,
	callbackOnActBase = function(self, t)
		if not self.lich_shadows then
			self.lich_shadows = {
				remainingCooldown = 0
			}
		end

		if game.zone.wilderness then return false end

		self.lich_shadows.remainingCooldown = self.lich_shadows.remainingCooldown - 1
		if self.lich_shadows.remainingCooldown > 0 then return false end
		self.lich_shadows.remainingCooldown = 10

		t.summonShadow(self, t)
		return true
	end,
	info = function(self, t)
		local maxShadows = t.getMaxShadows(self, t)
		local level = t.getLevel(self, t)
		local healLevel = t.getHealLevel(self, t)
		local blindsideLevel = t.getBlindsideLevel(self, t)
		local avoid_master_damage = t.getAvoidMasterDamage(self, t)
		return ([[While this ability is active, you will continually call up to %d level %d shadows to aid you in battle. Shadows are weak combatants that can: Use Arcane Reconstruction to heal themselves (level %d), Blindside their opponents (level %d), and Phase Door from place to place.
		Shadows ignore %d%% of the damage dealt to them by their master.]]):tformat(maxShadows, level, healLevel, blindsideLevel, avoid_master_damage)
	end,
}

newTalent{
	name = "Commander of the Dead",
	type = {"undead/lich",4},
	require = high_undeads_req4,
	mode = "passive",
	points = 5,
	radius = 10,
	getChance = function(self, t) return self:combatTalentScale(t, 8, 25) end,
	getPower = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	callbackOnTalentPost = function(self, t, ab)
		if not ab.is_spell or ab.id == t.id or ab.no_energy == true then return end
		if not rng.percent(t.getChance(self, t)) then return end
		self:projectApply({type="ball", radius=self:getTalentRadius(t)}, self.x, self.y, Map.ACTOR, function(target)
			if target:attr("undead") then
				target:setEffect(target.EFF_COMMANDER_OF_THE_DEAD, 4, {power=t.getPower(self, t)})
			end
		end, "friend")
	end,
	info = function(self, t)
		return ([[You are so full with power that it overflows out of you whenever you cast a spell.
		Upon spell cast you have %d%% chances to boost the physical power, spellpower, mindpower and all saves of all friendly undeads in sight (including yourself) by %d for 4 turns.]]):
		tformat(t.getChance(self, t), t.getPower(self, t))
	end,
}
