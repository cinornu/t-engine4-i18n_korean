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

-- Archmage spells
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/arcane", name = _t"arcane", description = _t"Arcane studies manipulate the raw magic energies to shape them into both offensive and defensive spells." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/aether", name = _t"aether", description = _t"Tap on the core arcane forces of the aether, unleashing devastating effects on your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/fire", name = _t"fire", description = _t"Harness the power of fire to burn your foes to ashes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/wildfire", name = _t"wildfire", min_lev = 10, description = _t"Harness the power of wildfire to burn your foes to ashes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/earth", name = _t"earth", description = _t"Harness the power of the earth to protect and destroy." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/stone", name = _t"stone", min_lev = 10, description = _t"Harness the power of the stone to protect and destroy." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/water", name = _t"water", description = _t"Harness the power of water to drown your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/ice", name = _t"ice", min_lev = 10, description = _t"Harness the power of ice to freeze and shatter your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/air", name = _t"air", description = _t"Harness the power of the air to fry your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/storm", name = _t"storm", min_lev = 10, description = _t"Harness the power of the storm to incinerate your foes." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/meta", name = _t"meta", description = _t"Meta spells alter the working of magic itself." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/temporal", name = _t"temporal", description = _t"The school of time manipulation." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/phantasm", name = _t"phantasm", description = _t"Control the power of tricks and illusions." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/enhancement", name = _t"enhancement", description = _t"Magical enhancement of your body." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/thaumaturgy", name = _t"thaumaturgy", description = _t"The pinacle of spellcasting." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/conveyance", name = _t"conveyance", generic = true, description = _t"Conveyance is the school of travel. It allows you to travel faster and to track others." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/divination", name = _t"divination", generic = true, description = _t"Divination allows the caster to sense its surroundings, and find hidden things." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/aegis", name = _t"aegis", generic = true, description = _t"Command the arcane forces into healing and protection." }

-- Alchemist spells
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/explosives", name = _t"explosive admixtures", description = _t"Manipulate gems to turn them into explosive magical bombs." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/infusion", name = _t"infusion", description = _t"Infusion your gem bombs with the powers of the elements." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/golemancy-base", name = _t"golemancy", hide = true, description = _t"Learn to craft and upgrade your golem." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/golemancy", name = _t"golemancy", description = _t"Learn to craft and upgrade your golem." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/advanced-golemancy", name = _t"advanced-golemancy", min_lev = 10, description = _t"Advanced golem operations." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/war-alchemy", name = _t"fire alchemy", description = _t"Alchemical spells designed to wage war." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/fire-alchemy", name = _t"fire alchemy", description = _t"Alchemical control over fire." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/acid-alchemy", name = _t"acid alchemy", description = _t"Alchemical control over acid." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/frost-alchemy", name = _t"frost alchemy", description = _t"Alchemical control over frost." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/energy-alchemy", name = _t"energy alchemy", min_lev = 10, description = _t"Alchemical control over lightning energies." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/stone-alchemy-base", name = _t"stone alchemy", hide = true, description = _t"Manipulate gems, and imbue their powers into other objects." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/stone-alchemy", name = _t"stone alchemy", generic = true, description = _t"Alchemical control over stone and gems." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/staff-combat", name = _t"staff combat", generic = true, description = _t"Harness the power of magical staves." }
newTalentType{ type="golem/fighting", name = _t"fighting", description = _t"Golem melee capacity." }
newTalentType{ type="golem/arcane", no_silence=true, is_spell=true, name = _t"arcane", description = _t"Golem arcane capacity." }
newTalentType{ type="golem/golem", name = _t"golem", description = _t"Golem basic capacity." }
newTalentType{ type="golem/drolem", name = _t"drolem", description = _t"Drolem basic capacity." }

-- Necromancer spells
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/master-of-bones", name = _t"master of bones", description = _t"Become of the master of bones, creating skeletal minions to do your bidding." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/master-of-flesh", name = _t"master of flesh", description = _t"Become of the master of flesh, creating ghoul minions to do your bidding" }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/master-necromancer", name = _t"master necromancer", min_lev = 10, description = _t"Full and total control over your undead army." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/nightfall", name = _t"nightfall", description = _t"Manipulate darkness itself to slaughter your foes." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/dreadmaster", name = _t"dreadmaster", description = _t"Summon an undead minion of pure darkness to harass your foes." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/age-of-dusk", name = _t"age of dusk", min_lev = 10, description = _t"Recall the glorious days of the Age of Dusk when necromancers reigned supreme." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/grave", name = _t"grave", description = _t"Use the rotting cold doom of the tomb to fell your foes." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/glacial-waste", name = _t"glacial waste", description = _t"Wither the land into a cold, dead ground to protect yourself." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/rime-wraith", name = _t"rime wraith", min_lev = 10, description = _t"Summon an undead minion of pure cold to harass your foes." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/animus", name = _t"animus", description = _t"Crush the souls of your foes to improve yourself." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/death", name = _t"death", description = _t"Learn to fasten your foes way into the grave." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/eradication", name = _t"eradication", min_lev = 10, description = _t"Doom to all your foes. Crush them." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/necrosis", name = _t"necrosis", generic = true, description = _t"Gain control over death, by unnaturally expanding your life." }
newTalentType{ allow_random=true, no_silence=true, is_necromancy=true, is_spell=true, mana_regen=true, type="spell/spectre", name = _t"spectre", generic = true, description = _t"Turn into a spectre to move around the battlefield." }

-- Stone Warden spells
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/eldritch-shield", name = _t"eldritch shield", description = _t"Infuse arcane forces into your shield." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/eldritch-stone", name = _t"eldritch stone", description = _t"Summon stony spikes imbued with various powers." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/deeprock", name = _t"deeprock", description = _t"Harness the power of the world to turn into a Deeprock Form." }

-- Generic requires for spells based on talent level
spells_req1 = {
	stat = { mag=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
spells_req2 = {
	stat = { mag=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
spells_req3 = {
	stat = { mag=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
spells_req4 = {
	stat = { mag=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
spells_req5 = {
	stat = { mag=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
spells_req_high1 = {
	stat = { mag=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
spells_req_high2 = {
	stat = { mag=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
spells_req_high3 = {
	stat = { mag=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
spells_req_high4 = {
	stat = { mag=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
spells_req_high5 = {
	stat = { mag=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}

function thaumaturgyCheck(self)
	if not self:attr("archmage_widebeam") then return false end
	local inven = self:getInven("BODY")
	if not inven then return true end
	if not inven[1] then return true end
	if inven[1].type ~= "armor" or inven[1].subtype ~= "cloth" then return false end
	return true
end
function thaumaturgyBeamDamage(self, dam)
	local v = self:attr("archmage_beam_dam_mult")
	if not v then return dam end
	return dam * (1 + v / 100)
end

-------------------------------------------
-- Necromancer minions
function necroArmyStats(self)
	local stats = {nb=0, nb_skeleton=0, nb_ghoul=0, list={}}
	if not game.level then return stats end
	if not game.party or not game.party:hasMember(self) then
		for _, act in pairs(game.level.entities) do if act.summoner == self and act.necrotic_minion then
			stats.nb = stats.nb + 1
			if act.skeleton_minion then
				stats.nb_skeleton = stats.nb_skeleton + 1
				if act.skeleton_minion == "mage" then stats.has_skeleton_mage = true end
				if act.skeleton_minion == "archer" then stats.has_skeleton_archer = true end
			end
			if act.ghoul_minion then stats.nb_ghoul = stats.nb_ghoul + 1 end
			if act.lord_of_skulls then stats.lord_of_skulls = act end
			if act.is_bone_giant then stats.bone_giant = act end
			if act.dread_minion then stats.dread = act end
			stats.list[#stats.list+1] = act
		end end
	else
		for act, _ in pairs(game.party.members) do if act.summoner == self and act.necrotic_minion then
			stats.nb = stats.nb + 1
			if act.skeleton_minion then
				stats.nb_skeleton = stats.nb_skeleton + 1
				if act.skeleton_minion == "mage" then stats.has_skeleton_mage = true end
				if act.skeleton_minion == "archer" then stats.has_skeleton_archer = true end
			end
			if act.ghoul_minion then stats.nb_ghoul = stats.nb_ghoul + 1 end
			if act.lord_of_skulls then stats.lord_of_skulls = act end
			if act.is_bone_giant then stats.bone_giant = act end
			if act.dread_minion then stats.dread = act end
			stats.list[#stats.list+1] = act
		end end
	end
	return stats
end

function necroSetupSummon(self, def, x, y, level, turns, no_control)
	local hookdata = {"Necromancer:NecroSetupSummon", def=def, x=y, y=y, level=level, turns=turns, no_control=no_control}
	if self:triggerHook(hookdata) and hookdata.new_def then
		def = hookdata.new_def
	end

	local m = require("mod.class.NPC").new(def)
	m.necrotic_minion = true
	m.creation_turn = game.turn
	m.faction = self.faction
	m.summoner = self
	m.summoner_gain_exp = true
	if turns then
		m.summon_time_max = turns
		m.summon_time = turns
	end
	m.exp_worth = 0
	m.life_regen = 0
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.silent_levelup = true
	-- m.no_points_on_levelup = true
	m.ai_state = m.ai_state or {}
	m.ai_state.tactic_leash = 100
	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	m.inc_damage = table.clone(self.inc_damage, true)
	m.no_inventory_access = 1
	m.no_breath = 1
	m.no_drops = true
	m.minion_be_nice = 1
	m.heal = function(self, amt, src)
		if not src or src == self or src.necrotic_minion then return mod.class.NPC.heal(self, amt, src) end
		if src.getCurrentTalent and src:getCurrentTalent() and src:getTalentFromId(src:getCurrentTalent()) and not src:getTalentFromId(src:getCurrentTalent()).is_nature then return mod.class.NPC.heal(self, amt, src) end
		game.logSeen(self, "#GREY#%s can not be healed this way!", self:getName():capitalize())
	end

	if self:isTalentActive(self.T_NECROTIC_AURA) then
		local t = self:getTalentFromId(self.T_NECROTIC_AURA)
		local perc = t:_getInherit(self) / 100

		-- Damage
		m.combat_generic_crit = (m.combat_generic_crit or 0) + math.floor(self:combatSpellCrit() * perc)
		m.combat_generic_power = (m.combat_generic_crit or 0) + math.floor(self:combatSpellpowerRaw() * perc)
		local max_inc = self.inc_damage.all or 0
		for k, e in pairs(self.inc_damage) do
			max_inc = math.max(max_inc, self:combatGetDamageIncrease(k))
		end
		m.inc_damage.all = (m.inc_damage.all or 0) + math.floor(max_inc * perc)

		-- Resists
		for k, e in pairs(self.resists) do
			m.resists[k] = (m.resists[k] or 0) + math.floor(e * perc)
		end
		for k, e in pairs(self.resists_cap) do
			m.resists_cap[k] = e
		end

		-- Saves
		m.combat_physresist = m.combat_physresist + math.floor(self:combatPhysicalResistRaw() * perc)
		m.combat_spellresist = m.combat_spellresist + math.floor(self:combatSpellResistRaw() * perc)
		m.combat_mentalresist = m.combat_mentalresist + math.floor(self:combatMentalResistRaw() * perc)

		m.poison_immune = (m.poison_immune or 0) + (self:attr("poison_immune") or 0) * perc
		m.disease_immune = (m.disease_immune or 0) + (self:attr("disease_immune") or 0) * perc
		m.cut_immune = (m.cut_immune or 0) + (self:attr("cut_immune") or 0) * perc
		m.confusion_immune = (m.confusion_immune or 0) + (self:attr("confusion_immune") or 0) * perc
		m.blind_immune = (m.blind_immune or 0) + (self:attr("blind_immune") or 0) * perc
		m.silence_immune = (m.silence_immune or 0) + (self:attr("silence_immune") or 0) * perc
		m.disarm_immune = (m.disarm_immune or 0) + (self:attr("disarm_immune") or 0) * perc
		m.pin_immune = (m.pin_immune or 0) + (self:attr("pin_immune") or 0) * perc
		m.stun_immune = (m.stun_immune or 0) + (self:attr("stun_immune") or 0) * perc
		m.fear_immune = (m.fear_immune or 0) + (self:attr("fear_immune") or 0) * perc
		m.knockback_immune = (m.knockback_immune or 0) + (self:attr("knockback_immune") or 0) * perc
		m.stone_immune = (m.stone_immune or 0) + (self:attr("stone_immune") or 0) * perc
		m.teleport_immune = (m.teleport_immune or 0) + (self:attr("teleport_immune") or 0) * perc

	end

	-- Speeds
	m.movement_speed = self.movement_speed
	m.global_speed_add = self.global_speed_add

	if game.party:hasMember(self) then
		local can_control = not no_control

		m.remove_from_party_on_death = true
		game.party:addMember(m, {
			control=can_control and "full" or "order",
			type="minion",
			title=_t"Necrotic Minion",
			orders = {target=true, dismiss=true},
		})
	end
	m:resolve() m:resolve(nil, true)
	m.max_level = self.level + (level or 0)
	m:forceLevelup(math.max(1, self.level + (level or 0)))
	
	-- Skeletons minions do not heal up
	m:unlearnTalent(m.T_SKELETON_REASSEMBLE, 999)

	-- All minions know soul leech like their master, to feed tasty souls to the Master!
	if self:knowTalent(self.T_SOUL_LEECH) then
		m:learnTalent(m.T_SOUL_LEECH, true, self:getTalentLevelRaw(self.T_SOUL_LEECH))
	end

	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "summon")

	if m.ghoul_minion and self:knowTalent(self.T_PUTRESCENT_LIQUEFACTION) then
		m.on_die = function(self, killer)
			if not self.x or not game.level then return end
			local src = self:resolveSource()
			for i, e in ipairs(game.level.map.effects) do
				if e.src == src and e.damtype == engine.DamageType.PUTRESCENT_LIQUEFACTION and e.grids[self.x] and e.grids[self.x][self.y] and src:isTalentActive(src.T_PUTRESCENT_LIQUEFACTION) then
					src:callTalent(src.T_PUTRESCENT_LIQUEFACTION, "absorbGhoul", self)
					return
				end
			end
		end
	end

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0
	return m
end

function checkLifeThreshold(val, fct, basefct)
	return function(self, t)
		local checkid = "__check_threshold_"..t.id
		if not self[checkid] then self[checkid] = self.life end
		if (self[checkid] >= val and self.life < val) or (self[checkid] < val and self.life >= val) then
			fct(self, t)
		end
		self[checkid] = self.life
		if basefct then basefct(self, t) end
	end
end
-------------------------------------------

load("/data/talents/spells/arcane.lua")
load("/data/talents/spells/aether.lua")
load("/data/talents/spells/fire.lua")
load("/data/talents/spells/wildfire.lua")
load("/data/talents/spells/earth.lua")
load("/data/talents/spells/stone.lua")
load("/data/talents/spells/water.lua")
load("/data/talents/spells/ice.lua")
load("/data/talents/spells/air.lua")
load("/data/talents/spells/storm.lua")
load("/data/talents/spells/conveyance.lua")
load("/data/talents/spells/aegis.lua")
load("/data/talents/spells/meta.lua")
load("/data/talents/spells/divination.lua")
load("/data/talents/spells/temporal.lua")
load("/data/talents/spells/phantasm.lua")
load("/data/talents/spells/thaumaturgy.lua")
load("/data/talents/spells/enhancement.lua")

load("/data/talents/spells/explosives.lua")
load("/data/talents/spells/golemancy.lua")
load("/data/talents/spells/advanced-golemancy.lua")
load("/data/talents/spells/staff-combat.lua")
load("/data/talents/spells/war-alchemy.lua")
load("/data/talents/spells/fire-alchemy.lua")
load("/data/talents/spells/frost-alchemy.lua")
load("/data/talents/spells/acid-alchemy.lua")
load("/data/talents/spells/energy-alchemy.lua")
load("/data/talents/spells/stone-alchemy.lua")
load("/data/talents/spells/golem.lua")

load("/data/talents/spells/master-of-bones.lua")
load("/data/talents/spells/master-of-flesh.lua")
load("/data/talents/spells/master-necromancer.lua")
load("/data/talents/spells/nightfall.lua")
load("/data/talents/spells/dreadmaster.lua")
load("/data/talents/spells/age-of-dusk.lua")
load("/data/talents/spells/grave.lua")
load("/data/talents/spells/glacial-waste.lua")
load("/data/talents/spells/rime-wraith.lua")
load("/data/talents/spells/animus.lua")
load("/data/talents/spells/death.lua")
load("/data/talents/spells/eradication.lua")
load("/data/talents/spells/necrosis.lua")
load("/data/talents/spells/spectre.lua")

load("/data/talents/spells/eldritch-shield.lua")
load("/data/talents/spells/eldritch-stone.lua")
load("/data/talents/spells/deeprock.lua")
