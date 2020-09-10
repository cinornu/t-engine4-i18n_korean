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

uberTalent{
	name = "Draconic Will",
	cooldown = 15,
	no_energy = true,
	requires_target = true,
	fixed_cooldown = true,
	tactical = { DEFEND = 1}, -- instant talent
	action = function(self, t)
		self:setEffect(self.EFF_DRACONIC_WILL, 5, {})
		return true
	end,
	require = { special={desc=_t"Be close to the draconic world", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("drake_touched") and self:attr("drake_touched") >= 2) end} },
	info = function(self, t)
		return ([[Your body is like that of a drake, easily resisting detrimental effects.
		For 5 turns, no detrimental effects may target you.]])
		:tformat()
	end,
}

uberTalent{
	name = "Meteoric Crash",
	mode = "passive",
	cooldown = 15,
	getDamage = function(self, t) return math.max(50 + self:combatSpellpower() * 5, 50 + self:combatMindpower() * 5) end,
	getLava = function(self, t) return math.max(self:combatSpellpower() + 30, self:combatMindpower() + 30) end,
	require = { special={desc=_t"Have witnessed a meteoric crash", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or self:attr("meteoric_crash") end} },
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "auto_highest_inc_damage", {[DamageType.FIRE] = 1})
		self:talentTemporaryValue(tmptable, "auto_highest_resists_pen", {[DamageType.FIRE] = 1})
		self:talentTemporaryValue(tmptable, "inc_damage", {[DamageType.FIRE] = 0.00001})  -- 0 so that it shows up in the UI
		self:talentTemporaryValue(tmptable, "resists_pen", {[DamageType.FIRE] = 0.00001})
	end,	
	trigger = function(self, t, target)
		self:startTalentCooldown(t)
		local terrains = t.terrains or mod.class.Grid:loadList("/data/general/grids/lava.lua")
		t.terrains = terrains -- cache

		local lava_dam = t.getLava(self, t)
		local dam = t.getDamage(self, t)
		if self:combatMindCrit() > self:combatSpellCrit() then 
			dam = self:mindCrit(dam)
			lava_dam = self:mindCrit(lava_dam)
		else 
			dam = self:spellCrit(dam)
			lava_dam = self:spellCrit(lava_dam)
		end
		local meteor = function(src, x, y, dam)
			game.level.map:particleEmitter(x, y, 10, "meteor", {x=x, y=y})
				game.level.map:particleEmitter(x, y, 10, "fireflash", {radius=2})
				game:playSoundNear(game.player, "talents/fireflash")

				local grids = {}
				for i = x-3, x+3 do for j = y-3, y+3 do
					local oe = game.level.map(i, j, engine.Map.TERRAIN)
					-- Create "patchy" lava, but guarantee that the center tiles are lava
					if oe and not oe:attr("temporary") and not oe.special and not game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "block_move") and (core.fov.distance(x, y, i, j) < 1 or rng.percent(40)) then
						local g = terrains.LAVA_FLOOR:clone()
						g:resolve() g:resolve(nil, true)
						game.zone:addEntity(game.level, g, "terrain", i, j)
						grids[#grids+1] = {x=i,y=j,oe=oe}
					end
				end end
				for i = x-3, x+3 do for j = y-3, y+3 do
					game.nicer_tiles:updateAround(game.level, i, j)
				end end
				for _, spot in ipairs(grids) do
					local i, j = spot.x, spot.y
					local g = game.level.map(i, j, engine.Map.TERRAIN)

					g.mindam = lava_dam
					g.maxdam = lava_dam
					g.faction = src.faction -- Don't hit self or allies
					g.temporary = 8
					g.x = i g.y = j
					g.canAct = false
					g.energy = { value = 0, mod = 1 }
					g.old_feat = spot.oe
					g.useEnergy = mod.class.Trap.useEnergy
					g.act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
							game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
							game.level:removeEntity(self, true)
							game.nicer_tiles:updateAround(game.level, self.x, self.y)
						end
					end
					g:altered()
					game.level:addEntity(g)
				end

				src:project({type="ball", radius=2, selffire=false, friendlyfire=false}, x, y, engine.DamageType.METEOR, dam)
				src:project({type="ball", radius=2, selffire=false, friendlyfire=false}, x, y, function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if target then
						if target:canBe("stun") then
							target:setEffect(target.EFF_STUNNED, 3, {apply_power=math.max(src:combatSpellpower(), src:combatMindpower())})
						else
							game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
						end
					end
				end)
				if core.shader.allow("distort") then game.level.map:particleEmitter(x, y, 2, "shockwave", {radius=2}) end
				game:getPlayer(true):attr("meteoric_crash", 1)
			end

		local dam = t.getDamage(self, t)
		if self:combatMindCrit() > self:combatSpellCrit() then dam = self:mindCrit(dam)
		else dam = self:spellCrit(dam)
		end
		meteor(self, target.x, target.y, dam)

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[When casting damaging spells or mind attacks, the release of your willpower can call forth a meteor to crash down near your foes.
		The meteor deals %0.2f fire and %0.2f physical damage in radius 2 and stuns enemies for 3 turns.
		Lava is created in radius 3 around the impact dealing %0.2f fire damage per turn for 8 turns.  This will overwrite tiles that already have modified terrain.
		You and your allies take no damage from either effect.

		Additionally, your fire damage bonus and resistance penetration is set to your current highest damage bonus and resistance penetration. This applies to all fire damage you deal.
		The damage scales with your Spellpower or Mindpower.]])
		:tformat(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam), damDesc(self, DamageType.FIRE, t.getLava(self, t)))
	end,
}

uberTalent{
	name = "Garkul's Revenge",
	mode = "passive",
	on_learn = function(self, t)
		self.inc_damage_actor_type = self.inc_damage_actor_type or {}
		self.inc_damage_actor_type.construct = (self.inc_damage_actor_type.construct or 0) + 1000
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.humanoid or 0) + 20
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.giant or 0) + 20
	end,
	on_unlearn = function(self, t)
		self.inc_damage_actor_type.construct = (self.inc_damage_actor_type.construct or 0) - 1000
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.humanoid or 0) - 20
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.giant or 0) - 20
	end,
	require = { special={desc=_t"Possess and wear two of Garkul's artifacts and know all about Garkul's life", fct=function(self)
		local o1 = self:findInAllInventoriesBy("define_as", "SET_GARKUL_TEETH")
		local o2 = self:findInAllInventoriesBy("define_as", "HELM_OF_GARKUL")
		return o1 and o2 and o1.wielded and o2.wielded and (game.state.birth.ignore_prodigies_special_reqs or (
			game.party:knownLore("garkul-history-1") and
			game.party:knownLore("garkul-history-2") and
			game.party:knownLore("garkul-history-3") and
			game.party:knownLore("garkul-history-4") and
			game.party:knownLore("garkul-history-5")
			))
	end} },
	info = function(self, t)
		return ([[Garkul's spirit is with you. You now deal 1000%% more damage to constructs and 20%% more damage to humanoids and giants.]])
		:tformat()
	end,
}

uberTalent{
	name = "Hidden Resources",
	cooldown = 15,
	no_energy = true,
	tactical = function(self, t, aitarget) -- build a tactical table for all defined resources the first time this is called.
		local tacs = {special = -1}
		for i, res_def in ipairs(self.resources_def) do
			if res_def.talent then tacs[res_def.short_name] = 0.5 end
		end
		t.tactical = tacs
		return tacs
	end,
	action = function(self, t)
		self:setEffect(self.EFF_HIDDEN_RESOURCES, 5, {})
		return true
	end,
	require = { special={desc=_t"Have been close to death(killed a foe while below 1 HP)", fct=function(self) return self:attr("barely_survived") end} },
	info = function(self, t)
		return ([[You focus your mind on the task at hand, regardless of how dire the situation is.
		For 5 turns, none of your talents use any resources.]])
		:tformat()
	end,
}

uberTalent{
	name = "Lucky Day",
	mode = "passive",
	require = { special={desc=_t"Be lucky already (at least +5 luck)", fct=function(self) return self:getLck() >= 55 end} },
	on_learn = function(self, t)
		self.inc_stats[self.STAT_LCK] = (self.inc_stats[self.STAT_LCK] or 0) + 40
		self:onStatChange(self.STAT_LCK, 40)
		self:attr("phase_shift", 0.1)
	end,
	on_unlearn = function(self, t)
		self.inc_stats[self.STAT_LCK] = (self.inc_stats[self.STAT_LCK] or 0) - 40
		self:onStatChange(self.STAT_LCK, -40)
		self:attr("phase_shift", -0.1)
	end,
	info = function(self, t)
		return ([[Every day is your lucky day! You gain a permanent +40 luck bonus and 10%% to move out of the way of every attack.]])
		:tformat()
	end,
}

uberTalent{
	name = "Unbreakable Will",
	mode = "passive",
	cooldown = 5,
	trigger = function(self, t)
		self:startTalentCooldown(t)
		game.logSeen(self, "#LIGHT_BLUE#%s's unbreakable will shrugs off the effect!", self:getName():capitalize())
		return true
	end,
	info = function(self, t)
		return ([[Your will is so strong that you simply ignore mental effects used against you.
		This effect can only occur once every 5 turns.]])
		:tformat()
	end,
}

uberTalent{
	name = "Spell Feedback",
	mode = "passive",
	cooldown = 9,
	require = { special={desc=_t"Antimagic", fct=function(self) return self:knowTalentType("wild-gift/antimagic") end} },
	trigger = function(self, t, target, source_t)
		self:startTalentCooldown(t)
		self:logCombat(target, "#LIGHT_BLUE##Source# punishes #Target# for casting a spell!", self:getName():capitalize(), target:getName())
		DamageType:get(DamageType.MIND).projector(self, target.x, target.y, DamageType.MIND, 20 + self:getWil() * 2)

		local dur = target:getTalentCooldown(source_t)
		if dur and dur > 0 then
			target:setEffect(target.EFF_SPELL_FEEDBACK, dur, {power=35})
		end
		return true
	end,
	info = function(self, t)
		return ([[Your will is a shield against assaults from crazed arcane users.
		Each time that you take damage from a spell, you punish the spellcaster with %0.2f mind damage.
		Also, they will suffer a 35%% spell failure chance (with duration equal to the cooldown of the spell they used on you).
		Note: this talent has a cooldown.]])
		:tformat(damDesc(self, DamageType.MIND, 20 + self:getWil() * 2))
	end,
}

uberTalent{
	name = "Mental Tyranny",
	mode = "sustained",
	require = { },
	cooldown = 20,
	tactical = { BUFF = 3 },
	require = { special={desc=_t"Have dealt over 50000 mind damage", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.MIND] and self.damage_log[DamageType.MIND] >= 50000)
		)
	end} },
	activate = function(self, t)
		game:playSoundNear(self, "talents/distortion")
		return {
			converttype = self:addTemporaryValue("all_damage_convert", DamageType.MIND),
			convertamount = self:addTemporaryValue("all_damage_convert_percent", 33),
			dam = self:addTemporaryValue("inc_damage", {[DamageType.MIND] = 10}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.MIND] = 30}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("all_damage_convert", p.converttype)
		self:removeTemporaryValue("all_damage_convert_percent", p.convertamount)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	info = function(self, t)
		return ([[Transcend the physical and rule over all with an iron will!
		While this sustain is active, 33%% of your damage is converted into mind damage.
		Additionally, you gain +30%% mind resistance penetration, and +10%% mind damage.]]):
		tformat()
	end,
}

uberTalent{
	name = "Fallen",
	require = {
		birth_descriptors={{"subclass", "Sun Paladin"}},
		special={desc=_t"Unlocked the Fallen evolution", fct=function(self) return profile.mod.allow_build.paladin_fallen end},
		special2={desc=_t"Committed a heinous act", fct=function(self) if not game.state.birth.supports_fallen_transform then return true else return game.state.birth.supports_fallen_transform(self) end end},
		stat = {mag=25},
	},
	is_class_evolution = "Sun Paladin",
	cant_steal = true,
	mode = "passive",
	no_npc_use = true,
	unlearnTalents = function(self, t, cats)
		local tids = {}
		local types = {}
		for id, lvl in pairs(self.talents) do
			local t = self.talents_def[id]
			if t.type[1] and cats[t.type[1]] ~= nil then
				types[t.type[1]] = true
				tids[id] = lvl
			end
		end
		local unlearnt = 0
		for id, lvl in pairs(tids) do self:unlearnTalent(id, lvl, nil, {no_unlearn=true}) unlearnt = unlearnt + lvl end
		self.unused_talents = self.unused_talents + unlearnt
		
		for cat, v in pairs(cats) do
			self.talents_types[cat] = nil
		end
	end,
	learnAndMaster = function(self, cat, unlocked, mastery)
		self:learnTalentType(cat, unlocked)
		self:setTalentTypeMastery(cat, mastery)
	end,
	on_learn = function(self, t)
		t.learnAndMaster(self, "cursed/bloodstained", true, 1.3)
		t.learnAndMaster(self, "celestial/darkside", true, 1.3)
		
		t.learnAndMaster(self, "cursed/gloom", self:knowTalentType("celestial/radiance"), 1.3 + (self.__increased_talent_types["celestial/radiance"] and 0.2 or 0))
		
		t.learnAndMaster(self, "cursed/crimson-templar", self:knowTalentType("celestial/guardian"), 1.3 + (self.__increased_talent_types["celestial/guardian"] and 0.2 or 0))
		t.learnAndMaster(self, "celestial/dark-sun", self:knowTalentType("celestial/crusader"), 1.3 + (self.__increased_talent_types["celestial/crusader"] and 0.2 or 0))
		
		t.learnAndMaster(self, "cursed/self-hatred", true, 1.3)
		t.learnAndMaster(self, "celestial/dirge", true, 1.3)
		
		local removes = {
			["celestial/crusader"] = true,
			["celestial/guardian"] = true,
			["celestial/radiance"] = true,
			["technique/2hweapon-assault"] = true,
			["technique/shield-offense"] = true,
		}
		if self.__increased_talent_types["technique/2hweapon-assault"] then
			self.unused_talents_types = self.unused_talents_types + 1
		end
		if self.__increased_talent_types["technique/shield-offense"] then
			self.unused_talents_types = self.unused_talents_types + 1
		end
		t.unlearnTalents(self, t, removes)

		self:attr("swap_combat_techniques_hate", 1)
		
		self:learnTalent(self.T_DIRGE_ACOLYTE, true, 1)
		self:learnTalent(self.T_SELF_HARM, true, 1)

		self.descriptor.class_evolution = _t"Fallen"

		game.bignews:say(120, "#CRIMSON#You give in to the darkness. You have fallen!")
		
		self:incHate(100)

		-- Remove stamina bar if we dont need it anymore
		local remove = true
		for tid, lvl in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t.stamina and util.getval(t.stamina, self, t) then remove = false break end
			if t.sustain_stamina and util.getval(t.sustain_stamina, self, t) then remove = false break end
			if t.drain_stamina and util.getval(t.drain_stamina, self, t) then remove = false break end
		end
		if remove then
			self:unlearnTalent(self.T_STAMINA_POOL)
		end
	end,
	info = function(self, t)
		return ([[The code of the Sun Paladins can be a heavy burden.	 Wouldn't you like to let go?
		#{italic}##GREY#To give in to the darkness?#LAST##{normal}#
		
		#CRIMSON#This evolution fundamentally alters your class and character in a huge way. Do not take it lightly.#LAST#

		Any offensive combat techniques or unlockable Celestial talent trees you know will be exchanged for cursed versions, allowing you to cut a bloody trail through enemies, turning your radiance to gloom, and more while also gaining new combat styles and defenses.

		The following talent trees are swapped:
		- #GOLD#Radiance#LAST# turns into #CRIMSON#Gloom#LAST#: Project onto others your own hate, hindering them
		- #GOLD#Guardian#LAST# turns into #CRIMSON#Crimson Templar#LAST#: Use the power of blood to control and defeat the fools that oppose you
		- #GOLD#Crusader#LAST# turns into #CRIMSON#Dark Sun#LAST#: Call upon the energies of dead suns to crush your foes

		You will learn the following talents trees:
		- #CRIMSON#Bloodstained#LAST#: Make your foes bleed!
		- #CRIMSON#Darkside#LAST#: Every light casts a shadow, yours is powerful indeed
		- #CRIMSON#Self-Hatred#LAST#: Manifest your self hatred through bleeding
		- #CRIMSON#Dirge#LAST#: Sing of death and sorrow to strength your resolve

		You will forget the following talent trees: Shield Offense, Two-handed Assault.
		Also the cost of any talents of the Combat Techniques tree will be converted to hate instead of stamina.
		]]):tformat()
	end,
}
