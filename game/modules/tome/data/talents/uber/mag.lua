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

local Dialog = require "engine.ui.Dialog"

uberTalent{
	name = "Spectral Shield",
	not_listed = true,  -- Functionality was baselined on shields
	mode = "passive",
	require = { special={desc=_t"Know the Block talent, have cast 100 spells, and have a block value over 200", fct=function(self)
		return self:knowTalent(self.T_BLOCK) and self:getTalentFromId(self.T_BLOCK).getBlockValue(self) >= 200 and self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 100
	end} },
	on_learn = function(self, t)
		self:attr("spectral_shield", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("spectral_shield", -1)
	end,
	info = function(self, t)
		return ([[By infusing your shield with raw magic, your block can now block any damage type.]])
		:tformat()
	end,
}

-- Re-used icon
uberTalent{
	name = "Ethereal Form", image = "talents/displace_damage.png",
	mode = "passive",
	require = { special={desc=_t"Have an effective defense of at least 40", fct=function(self)
		if self:combatDefense() >= 40 then return true end
	end} },
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "resists_pen", {all = 25})
		self:talentTemporaryValue(tmptable, "resists", {absolute = 25})
		self:talentTemporaryValue(tmptable, "combat_def", math.max(self:getMag(), self:getDex()) * 0.7)
	end,
	callbackOnStatChange = function(self, t, stat, v)
		if (stat == self.STAT_MAG) or (stat == self.STAT_DEX) then
			self:updateTalentPassives(t)
		end
	end,
	callbackOnMeleeHit = function(self, t, src, dam)
		self:setEffect(self.EFF_ETHEREAL_FORM, 8, {})
	end,
	callbackOnArcheryHit = function(self, t, src, dam)
		self:setEffect(self.EFF_ETHEREAL_FORM, 8, {})
	end,
	info = function(self, t)
		return ([[You gain 25%% absolute damage resistance and 25%% all damage penetration.  Each time you are struck by a weapon these bonuses are reduced by 5%% but fully recovered after 8 turns.
			Additionally, you gain 70%% of the highest of your Magic or Dexterity stat as defense (%d)]])
		:tformat(math.max(self:getMag(), self:getDex()) * 0.7)
	end,
}

uberTalent{
	name = "Aether Permeation",
	mode = "sustained",
	require = { special={desc=_t"Have been exposed to the void of space", fct=function(self)
		return (game.state.birth.ignore_prodigies_special_reqs or self:attr("planetary_orbit"))
	end} },
	cooldown = 20,
	callbackPriorities={callbackOnDispel = -9999}, -- Never set anything lower heh, it should trigger before anything else
	callbackOnDispel = function(self, t, type, effid_or_tid, src, allow_immunity, name)
		if not allow_immunity then return false end
		if self:hasEffect(self.EFF_AETHER_PERMEATION) then return end
		self:setEffect(self.EFF_AETHER_PERMEATION, 6, {})
		game:onTickEnd(function() self:forceUseTalent(t.id, {ignore_energy=true}) end)
		game.logSeen(self, "#ORCHID#Aether Permeation protects %s from a dispel!", name)
		return true
	end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "combat_spellpower", 40)
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[You manifest a thin layer of aether all around you. 
		Any time you are the target of a dispel effect the aether strengthens around you, protecting you from the dispel and any further ones for 6 turns and unsustaining this spell.
		While undisturbed the layer of aether provides you with 40 raw spellpower.]])
		:tformat()
	end,
}

uberTalent{
	name = "Mystical Cunning", image = "talents/vulnerability_poison.png",
	mode = "passive",
	require = { special={desc=_t"Know how to either prepare traps or apply poisons", fct=function(self)
		return self:knowTalent(self.T_APPLY_POISON) or self:knowTalent(self.T_TRAP_MASTERY)
	end} },
	autolearn_talent = {Talents.T_VULNERABILITY_POISON, Talents.T_GRAVITIC_TRAP}, -- requires uber.lua loaded last
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "talents_types_mastery", {["cunning/trapping"] = 1})
		self:talentTemporaryValue(tmptable, "talents_types_mastery", {["cunning/poisons"] = 1})
		self:talentTemporaryValue(tmptable, "talent_cd_reduction", {[Talents.T_VENOMOUS_STRIKE] = 3})
		self:talentTemporaryValue(tmptable, "talent_cd_reduction", {[Talents.T_LURE] = 5})
	end,
	info = function(self, t)
		local descs = ""
		for i, tid in pairs(t.autolearn_talent) do
			local bonus_t = self:getTalentFromId(tid)
			if bonus_t then
				descs = ("%s\n#YELLOW#%s#LAST#\n%s\n"):tformat(descs, bonus_t.name, self:callTalent(bonus_t.id, "info"))
			end
		end
		return ([[Your study of arcane forces has let you develop a new way of applying your aptitude for trapping and poisons.

		You gain 1.0 mastery in the Cunning/Poisons and Cunning/Trapping talent trees.
		Your Venomous Strike talent cooldown is reduced by 3.
		Your Lure talent cooldown is reduced by 5.

		You learn the following talents:
%s]])
		:tformat(descs)
	end,
}

uberTalent{
	name = "Arcane Might",
	mode = "passive",
	info = function(self, t)
		return ([[You have learned to harness your latent arcane powers, channeling them through your weapon.
		This has the following effects:
		Equipped weapons are treated as having an additional 50%% Magic modifier;
		Your raw Physical Power is increased by 100%% of your raw Spellpower;
		Your physical critical chance is increased by 25%% of your bonus spell critical chance.]])
		:tformat()
	end,
}

uberTalent{
	name = "Temporal Form",
	cooldown = 30,
	require = { special={desc=_t"Have cast over 1000 spells and visited a zone outside of time", fct=function(self) return
		self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 1000 and (game.state.birth.ignore_prodigies_special_reqs or self:attr("temporal_touched"))
	end} },
	no_energy = true,
	is_spell = true,
	requires_target = true,
	range = 10,
	tactical = { DEFEND = 2, BUFF = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_TEMPORAL_FORM, 10, {})
		return true
	end,
	info = function(self, t)
		return ([[You can wrap temporal threads around you, assuming the form of a telugoroth for 10 turns.
		While in this form you gain pinning, bleeding, blindness and stun immunity, 30%% temporal resistance, your temporal damage bonus is set to your current highest damage bonus + 30%%, 50%% of the damage you deal becomes temporal, and you gain 20%% temporal resistance penetration.
		You also are able to cast anomalies: Anomaly Rearrange, Anomaly Temporal Storm, Anomaly Flawed Design, Anomaly Gravity Pull and Anomaly Wormhole.]])
		:tformat()
	end,
}

uberTalent{
	name = "Blighted Summoning",
	mode = "passive",
	require = { special={desc=_t"Have summoned at least 100 creatures. More permanent summons may count as more than 1.", fct=function(self)
		return self:attr("summoned_times") and self:attr("summoned_times") >= 100
	end} },
	cant_steal = true,
	-- Give the bonus to all summons immediately
	on_learn = function(self, t)
		if game.party and game.party:hasMember(self) and game.party.members then
			for act, def in pairs(game.party.members) do
				if act ~= self and act.summoner == self and not act.escort_quest then
					self:callTalent(self.T_BLIGHTED_SUMMONING, "doBlightedSummon", act)
				end
			end
		end
	end,
	-- Called by addedToLevel Actor.lua
	doBlightedSummon = function(self, t, who)
		if who.is_blighted_summon or not self:knowTalent(self.T_BLIGHTED_SUMMONING) then return false end
		who:learnTalent(who.T_BONE_SHIELD, true, 3, {no_unlearn=true})
		who:forceUseTalent(who.T_BONE_SHIELD, {ignore_energy=true})
		if who.necrotic_minion then
			if who.name == "dread" or who.name == "dreadmaster" then
				who:learnTalent(who.T_SLUMBER, true, 3, {no_unlearn=true})				
			elseif who.subtype == "giant" then
				who:learnTalent(who.T_BONE_SPIKE, true, 3, {no_unlearn=true})
				who:learnTalent(who.T_RUIN, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_RUIN, {ignore_energy=true})
			elseif who.subtype == "vampire" or who.subtype == "lich" then
				who:learnTalent(who.T_BLOOD_GRASP, true, 3, {no_unlearn=true})
				who:learnTalent(who.T_BLOOD_BOIL, true, 3, {no_unlearn=true})
			elseif who.subtype == "ghost" or who.subtype == "wight" then
				who:learnTalent(who.T_BLOOD_FURY, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_BLOOD_FURY, {ignore_energy=true})
				who:learnTalent(who.T_CURSE_OF_DEATH, true, 3, {no_unlearn=true})
			elseif who.subtype == "ghoul" then
				who:learnTalent(who.T_VIRULENT_DISEASE, true, 3, {no_unlearn=true})
			elseif who.name == "skeleton archer" or who.name == "skeleton master archer" then
				who:learnTalent(who.T_BONE_SPIKE, true, 3, {no_unlearn=true})
			elseif who.name == "skeleton mage" then
				who:learnTalent(who.T_BONE_SPEAR, true, 3, {no_unlearn=true})
			elseif who.name == "degenerated skeleton warrior" or who.name == "skeleton warrior" or who.name == "armoured skeleton warrior" then
				who:learnTalent(who.T_RUIN, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_RUIN, {ignore_energy=true})
			else
				who:addTemporaryValue("all_damage_convert", DamageType.BLIGHT)
				who:addTemporaryValue("all_damage_convert_percent", 10)
				who:learnTalent(who.T_VIRULENT_DISEASE, true, 3, {no_unlearn=true})
			end
		elseif who.is_nature_summon then
			if who.subtype == "canine" then
				who:learnTalent(who.T_GNAW, true, 3, {no_unlearn=true})
			elseif who.subtype == "jelly" then
				who:learnTalent(who.T_CURSE_OF_DEFENSELESSNESS, true, 3, {no_unlearn=true})
			elseif who.subtype == "minotaur" then
				who:learnTalent(who.T_RUIN, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_RUIN, {ignore_energy=true})
			elseif who.subtype == "stone" then
				who:learnTalent(who.T_ACID_BLOOD, true, 3, {no_unlearn=true})
			elseif who.subtype == "ritch" then
				who:learnTalent(who.T_LIFE_TAP, true, 3, {no_unlearn=true})
			elseif who.type == "hydra" then
				who:learnTalent(who.T_BLOOD_SPRAY, true, 3, {no_unlearn=true})
			elseif who.subtype == "plants" then
				who:learnTalent(who.T_POISON_STORM, true, 3, {no_unlearn=true})
			-- I18N this line of code should be fixed.
			elseif who.name == "fire drake" or who.name == "fire drake (wild summon)" then
				who:learnTalent(who.T_FLAME_OF_URH_ROK, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_FLAME_OF_URH_ROK, {ignore_energy=true})
			elseif who.subtype == "turtle" then
				who:learnTalent(who.T_ELEMENTAL_DISCORD, true, 3, {no_unlearn=true}) who:forceUseTalent(who.T_ELEMENTAL_DISCORD, {ignore_energy=true})
			elseif who.subtype == "spider" then
				who:learnTalent(who.T_BLOOD_GRASP, true, 3, {no_unlearn=true})
			else
				who:addTemporaryValue("all_damage_convert", DamageType.BLIGHT)
				who:addTemporaryValue("all_damage_convert_percent", 10)
				who:learnTalent(who.T_VIRULENT_DISEASE, true, 3, {no_unlearn=true})
			end
		else
			who:addTemporaryValue("all_damage_convert", DamageType.BLIGHT)
			who:addTemporaryValue("all_damage_convert_percent", 10)
			who:learnTalent(who.T_VIRULENT_DISEASE, true, 3, {no_unlearn=true})
		end
		who:incVim(who:getMaxVim())
		who.is_blighted_summon = true
	end,
	info = function(self, t)
		return ([[You infuse blighted energies into all of your summons, granting them Bone Shield (level 3) and a bonus to Spellpower equal to your Magic.
		Your Wilder Summons and Necrotic Minions will gain special corrupted talents (level 3), other summons will gain 10%% Blight damage conversion and Virulent Disease (level 3).
		#GREEN#Wilder Summons:#LAST#
		- War Hound: Gnaw
		- Jelly: Curse of Defencelessness
		- Minotaur: Ruin
		- Golem: Acid Blood
		- Ritch: Life Tap
		- Hydra: Blood Spray
		- Rimebark: Poison Storm
		- Fire Drake: Flame of Urh’Rok
		- Turtle: Elemental Discord
		- Spider: Blood Grasp
		#GREY#Necrotic Minions:#LAST#
		- Skeleton Mages: Bone Spear
		- Skeleton Archers: Bone Spike
		- Skeleton Warriors: Ruin
		- Bone Giants: Bone Spike and Ruin
		- Ghouls: Virulent Disease
		- Dread: Slumber
		]]):tformat()
	end,
}

uberTalent{
	name = "Revisionist History",
	cooldown = 30,
	no_energy = true,
	is_spell = true,
	cant_steal = true,
	no_npc_use = true,
	require = { special={desc=_t"Have time-travelled at least once", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("time_travel_times") and self:attr("time_travel_times") >= 1) end} },
	action = function(self, t)
		if game._chronoworlds and game._chronoworlds.revisionist_history then
			self:hasEffect(self.EFF_REVISIONIST_HISTORY).back_in_time = true
			self:removeEffect(self.EFF_REVISIONIST_HISTORY)
			return nil -- the effect removal starts the cooldown
		end

		if checkTimeline(self) == true then return end

		game:onTickEnd(function()
			game:chronoClone("revisionist_history")
			self:setEffect(self.EFF_REVISIONIST_HISTORY, 19, {})
		end)
		return nil -- We do not start the cooldown!
	end,
	info = function(self, t)
		return ([[You can now control the recent past. Upon using this prodigy you gain a temporal effect for 20 turns.
		While this effect holds you can use the prodigy again to rewrite history.
		This prodigy splits the timeline. Attempting to use another spell that also splits the timeline while this effect is active will be unsuccessful.]])
		:tformat()
	end,
}
newTalent{
	name = "Unfold History", short_name = "REVISIONIST_HISTORY_BACK",
	type = {"uber/other",1},
	cooldown = 30,
	no_energy = true,
	is_spell = true,
	no_npc_use = true,
	action = function(self, t)
		if game._chronoworlds and game._chronoworlds.revisionist_history then
			self:hasEffect(self.EFF_REVISIONIST_HISTORY).back_in_time = true
			self:removeEffect(self.EFF_REVISIONIST_HISTORY)
			return nil -- the effect removal starts the cooldown
		end
		return nil -- We do not start the cooldown!
	end,
	info = function(self, t)
		return ([[Rewrite the recent past to go back to when you cast Revisionist History.]])
		:tformat()
	end,
}

uberTalent{
	name = "Cauterize",
	mode = "passive",
	cooldown = 12,
	require = { special={desc=_t"Have received at least 3500 fire damage and have cast at least 1000 spells", fct=function(self) return
		self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 1000 and self.damage_intake_log and self.damage_intake_log[DamageType.FIRE] and self.damage_intake_log[DamageType.FIRE] >= 3500
	end} },
	trigger = function(self, t, value)
		self:startTalentCooldown(t)

		if self.player then world:gainAchievement("AVOID_DEATH", self) end
		self:setEffect(self.EFF_CAUTERIZE, 8, {dam=value/10})
		return true
	end,
	info = function(self, t)
		return ([[Your inner flame is strong. Each time that you receive a blow that would kill you, your body is wreathed in flames.
		The flames will cauterize the wound, fully absorbing all damage done this turn, but they will continue to burn for 8 turns.
		Each turn 10%% of the damage absorbed will be dealt by the flames. This will bypass resistance and affinity.
		Warning: this has a cooldown.]]):tformat()
	end,
}

uberTalent{
	name = "Lich",
	require = {
		special={desc=_t"Is a living creature that knows necromancy", fct=function(self)
			local nb = 0
			for tid, lvl in pairs(self.talents) do local t = self:getTalentFromId(tid) if t.is_necromancy then nb = nb + lvl end end
			return not self:attr("true_undead") and nb > 0
		end},
		special2={desc=_t"Have completed the ritual", fct=function(self)
			if config.settings.cheat then return true end
			if self.lichform_quest_checker then return true end
			if not game.state.birth.supports_lich_transform then return true else return self:isQuestStatus(game.state.birth.supports_lich_transform, engine.Quest.DONE) end
		end},
		stat = {wil=25},
	},
	is_race_evolution = function(self, t)
		if self:knowTalent(t.id) then return true end
		if not t:_canGrantQuest(self) then return false end
		local nb = 0
		for tid, lvl in pairs(self.talents) do local t = self:getTalentFromId(tid) if t.is_necromancy then nb = nb + lvl end end
		return nb > 0
	end,
	canGrantQuest = function(self, t)
		if self:attr("necromancy_immune") then return false end
		if self:attr("greater_undead") then return false end
		if self:attr("true_undead") then return false end
		return true
	end,
	cant_steal = true,
	is_spell = true,
	is_necromancy = true,
	mode = "passive",
	no_npc_use = true,
	becomeLich = function(self, t)
		self.descriptor.race = "Undead"
		self.descriptor.subrace = "Lich"
		if not self.has_custom_tile then
			self.moddable_tile = "skeleton"
			self.moddable_tile_nude = 1
			self.moddable_tile_base = "base_lich_01.png"
			self.moddable_tile_ornament = nil
			self.moddable_tile_hair = nil
			self.moddable_tile_facial_features = nil
			self.moddable_tile_tatoo = nil
			self.moddable_tile_horn = nil
			self.attachement_spots = "race_skeleton"
		end
		self.blood_color = colors.GREY
		self:attr("poison_immune", 1)
		self:attr("disease_immune", 1)
		self:attr("stun_immune", 1)
		self:attr("cut_immune", 1)
		self:attr("fear_immune", 1)
		self:attr("no_breath", 1)
		self:attr("mana_regen", 7)
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 20
		self.resists[DamageType.DARKNESS] = (self.resists[DamageType.DARKNESS] or 0) + 20
		self.inscription_forbids = self.inscription_forbids or {}
		self.inscription_forbids["inscriptions/infusions"] = true

		self:incIncStat("mag", 12) self:incIncStat("wil", 12) self:incIncStat("cun", 12)
		self:attr("combat_spellresist", 35) self:attr("combat_mentalresist", 35)
		self.life_rating = self.life_rating + 4
		self:attr("ignore_direct_crits", 60)

		self:attr("undead", 1)
		self:attr("true_undead", 1)

		self:learnTalentType("undead/lich", true)

		if self:attr("blood_life") then
			self.blood_life = nil
			game.log("#GREY#As you turn into a powerful undead you feel your body violently rejecting the Blood of Life.")
		end

		if not self.has_custom_tile then
			self:removeAllMOs()
			self:updateModdableTile()
			Dialog:yesnoLongPopup(_t"Lichform", _t"#GREY#You feel your life slip away, only to be replaced by pure arcane forces! Your flesh starts to rot on your bones, and your eyes fall apart as you are reborn into a Lich!\n\n#{italic}#You may now choose to customize the appearance of your Lich, this can not be changed afterwards.", 600, function(ret) if ret then
				require("mod.dialogs.Birther"):showCosmeticCustomizer(self, _t"Lich Cosmetic Options")
			end end, _t"Customize Appearance", _t"Use Default", true)
		else
			Dialog:simplePopup(_t"Lichform", _t"#GREY#You feel your life slip away, only to be replaced by pure arcane forces! Your flesh starts to rot on your bones, and your eyes fall apart as you are reborn into a Lich!")
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
	end,
	on_learn = function(self, t)
		self:attr("greater_undead", 1) -- Set that here so that the player cant become an Exarch while waiting for their death to become a Lich
		self:learnTalent(self.T_NEVERENDING_UNLIFE, true, 1)

		-- Wait for death
		if not self.no_resurrect then
			game.bignews:say(120, "#DARK_ORCHID#You are on your way to Lichdom. #{bold}#Your next death will finish the ritual.#{normal}#")
		-- We cant wait for death! do it now!
		else
			local dialog = require("mod.dialogs.DeathDialog").new(self)
			t:_becomeLich(self)
			game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
		end
	end,
	on_unlearn = function(self, t)
	end,
	info = function(self, t)
		return ([[This is your true goal and the purpose of all necromancy - to become a powerful and everliving Lich!
		Once learnt, the next time you are killed, the arcane forces you unleash will be able to rebuild your body into the desired Lichform.
		Liches are immune to poisons, diseases, fear, cuts, stuns, do not need to breath and are 20%% resistant to cold and darkness.
		Liches also gain +12 Magic, Willpower and Cunning, 60%% chance to ignore critical hits, +4 life rating (not retroactive), +35 spell and mental saves and 7 mana regeneration.

		Liches gain a new racial tree with the following talents:
		- Neverending Unlife: A Lich body is extremely resilient, being able to go into negative life and when destroyed it can regenerate itself.
		- Frightening Presence: Your mere presence is enough to shatter the resolve of most, reducing their saves, damage and movement speed.
		- Doomed for Eternity: As a creature of doom and despair you now constantly spawn undead shadows around you.
		- Commander of the Dead: You are able to infuse all undead party members (including yourself) with un-natural power, increasing your physical and spellpower.
		]]):tformat()
	end,
}

uberTalent{
	name = "High Thaumaturgist",
	require = {
		birth_descriptors={{"subclass", "Archmage"}},
		special={desc=_t"Unlocked the High Thaumaturgist evolution", fct=function(self) return profile.mod.allow_build.mage_thaumaturgist end},
		stat = {wil=25},
	},
	is_class_evolution = "Archmage", requires_unlock = "mage_thaumaturgist",
	cant_steal = true,
	is_spell = true,
	mode = "passive",
	on_learn = function(self, t)
		self:learnTalentType("spell/thaumaturgy", true)
		self:setTalentTypeMastery("spell/thaumaturgy", 1.3)
		self:attr("archmage_widebeam", 1)

		if not game.party:hasMember(self) then return end
		self.descriptor.class_evolution = _t"High Thaumaturgist"
	end,
	on_unlearn = function(self, t)
	end,
	info = function(self, t)
		return ([[Thaumaturgists have unlocked a deeper understanding of their spells, allowing them to combine the elements into new ways and to empower them.
		The spells Flame, Manathrust, Lightning, Pulverizing Auger and Ice Shards are permanently turned into 3-wide beams spells.
		In addition they have access to the unique Thaumaturgy class tree:
		- Orb of Thaumaturgy: a temporary orb that duplicates any beam spells that you cast
		- Multicaster: When casting a beam spell adds a chance to also cast an other archmage spell
		- Slipstream: Allows movement when casting beams
		- Elemental Array Burst: a powerful, multi-elemental beam spell that can inflict all elemental ailments and can not be resisted
		#CRIMSON#The fine spellcasting required for wide beams and all thaumaturgy spells can only happen while wearing cloth. Anything heavier will hinder the casting too much.]])
		:tformat()
	end,
}
