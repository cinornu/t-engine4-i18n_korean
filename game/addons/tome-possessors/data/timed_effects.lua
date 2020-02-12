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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

local function possessorEffectTemporaryValue(self, tid, eff, name, bodyval, selfval)
	local val
	local selfscale = self:knowTalent(self.T_SELF_PERSISTENCE) and (self:callTalent(self.T_SELF_PERSISTENCE, "getPossessScale") / 100) or 1
	local bodyscale = self:knowTalent(self.T_IMPROVED_FORM) and (self:callTalent(self.T_IMPROVED_FORM, "getPossessScale") / 100) or 0.4
	if type(selfval) == "table" then
		val = {}
		for k, e in pairs(bodyval) do
			if type(e) == "number" and type(selfval[k]) == "number" then
				val[k] = (e - (selfval[k] or 0) * selfscale) * bodyscale
			end
		end
	else
		val = (bodyval - selfval * selfscale) * bodyscale
	end

	self:effectTemporaryValue(eff, name, val)
end

newEffect{
	name = "OMINOUS_FORM", image = "talents/ominous_form.png",
	desc = _t"Ominous Form",
	long_desc = function(self, eff) return _t"You stole your current form and share damage and healing with it." end,
	type = "other",
	subtype = { psionic=true, possession=true },
	status = "beneficial",
	parameters = { },
	callbackOnActBase = function(self, eff)
		if not game.level:hasEntity(eff.target) or eff.target:attr("dead") then game:onTickEnd(function() self:removeEffect(self.EFF_OMINOUS_FORM) end) return end
		self.life = eff.target.life / eff.target.max_life * self.max_life
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1, img="ominous_form_chains_texture"}, shader={type="rotatingshield", noup=2.0, appearTime=0.2}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1, img="ominous_form_chains_texture"}, shader={type="rotatingshield", noup=1.0, appearTime=0.2}})
		end
	end,
	deactivate = function(self, eff)
		local poss = self:hasEffect(self.EFF_POSSESSION)
		if poss and poss.ominous then self:removeEffect(self.EFF_POSSESSION, false, true) end
	end,
}

newEffect{
	name = "POSSESSION", image = "talents/possess.png",
	desc = _t"Assume Form",
	long_desc = function(self, eff) return _t"You use the body of one of your fallen victims. You can not heal in this form." end,
	type = "other",
	subtype = { psionic=true, possession=true },
	decrease = 0, no_remove = true,
	status = "beneficial",
	parameters = { },
	-- charges = function(self, eff) return eff.body.name or "???" end,
	activate = function(self, eff)
		local body = eff.body
		body._in_possession = true
		eff.old_type, eff.old_subtype = rawget(self, "type"), rawget(self, "subtype")
		self.type, self.subtype = rawget(body, "type") or "??", rawget(body, "subtype") or "??"

		eff.exp_to_recover = 0
		eff.life_offset = body.max_life - self.max_life
		eff.before_life = self.life
		for i, body in ipairs(self.bodies_storage) do if body.body == eff.body then eff.from_storage = true break end end

		-- Learn all passive talents
		eff.learnt_talents = {}
		local max_tlv = self:callTalent(self.T_IMPROVED_FORM, "getMaxTalentsLevel"), 1
		local available_talent_slots, nbt = self:callTalent(self.T_FULL_CONTROL, "getNbTalents"), 1
		eff.possession_talent_ids = {}
		for tid, blev in pairs(body.talents) do
			local lev = util.bound(blev, 1, max_tlv)
			local t = self:getTalentFromId(tid)
			if self:callTalent(self.T_ASSUME_FORM, "isUsableTalent", t, false) then
				self:learnTalent(tid, true, lev, {no_unlearn=true})
				eff.learnt_talents[tid] = lev
			elseif self:callTalent(self.T_ASSUME_FORM, "isUsableTalent", t, true) then
				if available_talent_slots > 0 and (not body.__possessor_talent_slots_config or table.hasInList(body.__possessor_talent_slots_config, tid)) then
					if self.hotkey and self.isHotkeyBound then
						local pos = self:isHotkeyBound("talent", self['T_POSSESSION_TALENT_'..nbt])
						if pos then
							self.hotkey[pos] = {"talent", tid}
						end
					end

					local ohk = self.hotkey
					self.hotkey = nil -- Prevent assigning hotkey, we just did
					self:learnTalent(tid, true, lev, {no_unlearn=true})
					eff.learnt_talents[tid] = lev
					eff.possession_talent_ids[tid] = "T_POSSESSION_TALENT_"..nbt
					self.hotkey = ohk

					available_talent_slots = available_talent_slots - 1
					nbt = nbt + 1
				end
			end
		end

		local fullcontrol = self:getTalentLevel(self.T_FULL_CONTROL)

		-- Disable regen & heal and adjust life
		self.max_life = self.max_life + eff.life_offset
		self.life = body.life
		eff.can_raise_life_over = body.life
		self:effectTemporaryValue(eff, "no_life_regen", 1)
		self:effectTemporaryValue(eff, "no_healing", 1)
		self:effectTemporaryValue(eff, "no_healing_no_warning", 1)
		self:effectTemporaryValue(eff, "no_levelup_access", 1)
		self:effectTemporaryValue(eff, "no_equipment_changes", 1)
		self.no_levelup_access_log = _t"#CRIMSON#While you assume a form you may not levelup. All exp gains are delayed and will be granted when you reintegrate your own body."

		if body:attr("never_move") then self:effectTemporaryValue(eff, "never_move", 1) end

		-- Apply powers, saves, stats, ...
		local bodystats, selfstats = {}, {}
		for id, stat_def in ipairs(self.stats_def) do
			if id ~= self.STAT_WIL and id ~= self.STAT_CON then
				bodystats[id] = body["get"..stat_def.short_name:lower():capitalize()](body)
				selfstats[id] = self["get"..stat_def.short_name:lower():capitalize()](self)
			end
		end
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "inc_stats", bodystats, selfstats)

		if fullcontrol >= 5 then
			if body.global_speed_base - self.global_speed_base > 0 then self:effectTemporaryValue(eff, "global_speed_base", body.global_speed_base - self.global_speed_base) end
			if body.global_speed_add - self.global_speed_add > 0 then self:effectTemporaryValue(eff, "global_speed_add", body.global_speed_add - self.global_speed_add) end
			if body.movement_speed - self.movement_speed > 0 then self:effectTemporaryValue(eff, "movement_speed", body.movement_speed - self.movement_speed) end
			if body.combat_physspeed - self.combat_physspeed > 0 then self:effectTemporaryValue(eff, "combat_physspeed", body.combat_physspeed - self.combat_physspeed) end
			if body.combat_spellspeed - self.combat_spellspeed > 0 then self:effectTemporaryValue(eff, "combat_spellspeed", body.combat_spellspeed - self.combat_spellspeed) end
			if body.combat_mindspeed - self.combat_mindspeed > 0 then self:effectTemporaryValue(eff, "combat_mindspeed", body.combat_mindspeed - self.combat_mindspeed) end
			self:recomputeGlobalSpeed()
		end

		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_def", body.combat_def, self.combat_def)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_armor", body.combat_armor, self.combat_armor)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_armor_hardiness", body.combat_armor_hardiness, self.combat_armor_hardiness)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_atk", body.combat_atk, self.combat_atk)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_apr", body.combat_apr, self.combat_apr)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_dam", body.combat_dam, self.combat_dam)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_physcrit", body.combat_physcrit, self.combat_physcrit)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_spellcrit", body.combat_spellcrit, self.combat_spellcrit)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_spellpower", body.combat_spellpower, self.combat_spellpower)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_mindpower", body.combat_mindpower, self.combat_mindpower)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_mindcrit", body.combat_mindcrit, self.combat_mindcrit)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_physresist", body.combat_physresist, self.combat_physresist)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_spellresist", body.combat_spellresist, self.combat_spellresist)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_mentalresist", body.combat_mentalresist, self.combat_mentalresist)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_critical_power", (body.combat_critical_power or 0), (self.combat_critical_power or 0))
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_generic_crit", (body.combat_generic_crit or 0), (self.combat_generic_crit or 0))
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "combat_generic_power", (body.combat_generic_power or 0), (self.combat_generic_power or 0))

		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "poison_immune", body.poison_immune or 0, self.poison_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "disease_immune", body.disease_immune or 0, self.disease_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "cut_immune", body.cut_immune or 0, self.cut_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "confusion_immune", body.confusion_immune or 0, self.confusion_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "blind_immune", body.blind_immune or 0, self.blind_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "silence_immune", body.silence_immune or 0, self.silence_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "disarm_immune", body.disarm_immune or 0, self.disarm_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "pin_immune", body.pin_immune or 0, self.pin_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "stun_immune", body.stun_immune or 0, self.stun_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "sleep_immune", body.sleep_immune or 0, self.sleep_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "fear_immune", body.fear_immune or 0, self.fear_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "knockback_immune", body.knockback_immune or 0, self.knockback_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "stone_immune", body.stone_immune or 0, self.stone_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "anomaly_immune", body.anomaly_immune or 0, self.anomaly_immune or 0)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "teleport_immune", body.teleport_immune or 0, self.teleport_immune or 0)

		self:effectTemporaryValue(eff, "size_category", body.size_category - self.size_category)

		self:effectTemporaryValue(eff, "on_melee_hit", body.on_melee_hit)
		self:effectTemporaryValue(eff, "melee_project", body.melee_project)
		self:effectTemporaryValue(eff, "ranged_project", body.ranged_project)
		self:effectTemporaryValue(eff, "can_pass", body.can_pass)
		self:effectTemporaryValue(eff, "move_project", body.move_project)
		self:effectTemporaryValue(eff, "can_breath", body.can_breath)
		possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "inc_damage", body.inc_damage, self.inc_damage)

		if fullcontrol >= 3 then
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "resists", body.resists, self.resists)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "resists_self", body.resists_self, self.resists_self)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "resists_actor_type", body.resists_actor_type, self.resists_actor_type)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "resists_pen", body.resists_pen, self.resists_pen)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "damage_affinity", body.damage_affinity, self.damage_affinity)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "flat_damage_cap", body.flat_damage_cap, self.flat_damage_cap)
			possessorEffectTemporaryValue(self, self.T_POSSESS, eff, "flat_damage_armor", body.flat_damage_armor, self.flat_damage_armor)
		end

-- can this be abused?
		-- go through all resources, add regen and set them to max, except psi obviously
		for res, res_def in ipairs(self.resources_def) do
			if res_def.short_name == "paradox" then
				self.paradox = self.preferred_paradox or 300
			elseif res_def.short_name ~= "psi" then
				if res_def.invert_values then
					self[res_def.short_name] = self:check(res_def.getMinFunction) or self[res_def.short_name] or res_def.min
				else
					self[res_def.short_name] = self:check(res_def.getMaxFunction) or self[res_def.short_name] or res_def.max
				end
			end
			for res, res_def in ipairs(self.resources_def) do
				if res_def.regen_prop then
					possessorEffectTemporaryValue(self, self.T_POSSESS, eff, res_def.regen_prop, body[res_def.regen_prop], self[res_def.regen_prop])
				end
			end
		end

		self.summon = body.summon
		if body.can_multiply then
			self.clone_base = body:cloneFull()
			self.can_multiply = body.can_multiply
		end

		self.replace_display = body
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		self:addShaderAura("possession", "awesomeaura", {time_factor=2000, alpha=0.5, flame_scale=0.4}, "particles_images/lightningwings.png")
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_line")
	end,
	deactivate = function(self, eff)
		self:removeShaderAura("possession")
		local body = eff.body
		body._in_possession = false
		self.type, self.subtype = eff.old_type, eff.old_subtype

		self.no_levelup_access_log = nil
		self.summon = nil
		self.can_multiply = nil

		self.replace_display = nil
		self:removeAllMOs()
		self:updateModdableTile()
		game.level.map:updateMap(self.x, self.y)

		-- Unlearn all talents
		for tid, lev in pairs(eff.learnt_talents) do
			if self.hotkey and self.isHotkeyBound then
				local pos = self:isHotkeyBound("talent", tid)
				if pos then
					self.hotkey[pos] = {"talent", eff.possession_talent_ids[tid]}
				end
			end
			self:unlearnTalent(tid, lev, nil, {no_unlearn=true})
		end

		body.life = math.min(self.life, eff.can_raise_life_over)
		self.max_life = self.max_life - eff.life_offset
		self.life = eff.before_life

		if not eff.ominous and eff.from_storage and (eff.death_triggered or eff.rejected) then
			self:callTalent(self.T_BODIES_RESERVE, "decreaseUse", eff.body)
		end

		if eff.exp_to_recover > 0 then
			local exp = eff.exp_to_recover
			game:onTickEnd(function() self:gainExp(exp) end)
		end

		if eff.ominous then self:removeEffect(self.EFF_OMINOUS_FORM) end
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_line")
	end,
	callbackOnDie = function(self, eff, value, src, death_note)
--set cooldown of Assume Form?
		if eff.death_triggered then return true end
		eff.death_triggered = true
		game:onTickEnd(function()
			-- Prevent death, but shock!
			game.bignews:say(90, "#CRIMSON#Your body died! You quickly return to your normal one but the shock is terrible!")
			self:removeEffect(self.EFF_POSSESSION, false, true)
			self:takeHit(self.max_life * self:callTalent(self.T_POSSESS, "getShock") / 100, src, {special_death_msg=_t"was killed by possession aftershock"})
			self:setEffect(self.EFF_POSSESSION_AFTERSHOCK, 6, {})
		end)
		return true
	end,
	callbackOnKill = function(self, eff, target, death_note)
		if not target then return end
		local Dialog = require "engine.ui.Dialog"
		local body = eff.body
		if     body.name == "Shasshhiy'Kaish" and target.name == "Kryl-Feijan" then
			Dialog:simplePopup(_t"Kryl-Feijan", _t"Your possessed body's eyelids briefly flutter, and a tear rolls down its cheek. You didn't tell it to do that.", function()
				world:gainAchievement("POSSESSOR_DEMON_KILL", self)
			end)
		elseif body.name == "Kryl-Feijan" and target.name == "Shasshhiy'Kaish" then
			Dialog:simpleLongPopup(_t"Shasshhiy'Kaish", _t[[The flames surrounding Shasshhiy'Kaish slowly die as she falls to her knees.  "Fiend...  and I thought #{italic}#I#{normal}# could cause suffering.  It's the one thing Eyalites always did best," she spits.  "I heard what had happened to him, and my followers have given more than enough of their life to restore me after this.  All you've accomplished here - [cough] - is giving us a worthwhile new goal...  and target.  All will be repaid tenfold, Eyalite."  Her coughing grows weaker, until she abruptly bursts into flame; her ashes scatter into the wind.]], 500, function()
				world:gainAchievement("POSSESSOR_DEMON_KILL", self)
			end)
		elseif body.name == "Outpost Leader John" and target.name == "High Sun Paladin Aeryn" then
			eff.rejected = true
			game:onTickEnd(function() self:removeEffect(self.EFF_POSSESSION, false, true) end)
			Dialog:simpleLongPopup(_t"High Sun Paladin Aeryn", _t"Aeryn's bewildered and terrified cries grow quiet, but...  your ears don't ring or hurt as screams of horror and rage surround you, louder than should be deafening.  When they shift to accusations, an unfamiliar guilt dominates your thoughts; you are forced to abandon your body before it can compel you to punish yourself.", 500, function()
				world:gainAchievement("POSSESSOR_ORCS_KILL", self)
			end)
		elseif body.name == "Bill the Stone Troll" and target.is_player_doomed_shade then
			world:gainAchievement("POSSESSOR_BILL_KILL", self)
		end
	end,
}


newEffect{
	name = "POSSESSION_AFTERSHOCK",
	desc = _t"Possession Aftershock",
	long_desc = function(self, eff) return ("The target is reeling from the aftershock of a destroyed possessed body, reducing damage by 60%%, reducing movement speed by 50%%."):tformat() end,
	type = "other",
	subtype = { stun=true, possession=true, psionic=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is stunned!", _t"+Stunned" end,
	on_lose = function(self, err) return _t"#Target# is not stunned anymore.", _t"-Stunned" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stunned", 1)
		self:effectTemporaryValue(eff, "movement_speed", -0.5)
	end,
}

newEffect{
	name = "POSSESS",
	desc = _t"Possess",
	long_desc = function(self, eff) return ("The victim is snared in a psionic web that is destroying its mind and preparing its body for possession.  It takes %0.2f Mind damage per turn."):tformat(eff.power) end,
	type = "other",
	subtype = { psionic=true, possess=true, mind=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target#'s mind is convulsing.", true end,
	on_lose = function(self, err) return _t"#Target#'s mind is not convulsing anymore.", true end,
	activate = function(self, eff)
		self:effectParticles(eff, {type="image", args={image="particles_images/possess_projectile", life=32, av=-0.6/32, size=64}})
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.power)
	end,
	callbackOnDeath = function(self, eff, value, src, death_note)
		if eff.death_triggered then return end
		eff.death_triggered = true

		if eff.src and eff.src ~= self then
			if eff.src:callTalent(eff.src.T_BODIES_RESERVE, "storeBody", self, true) then
				eff.src:logCombat(self, "#PURPLE##Source# shatters #Target#'s mind and takes possession of its body.")
			else
				eff.src:logCombat(self, "#PURPLE##Source# shatters #Target#'s mind, utterly destroying it.")
			end
		end
	end,
}

newEffect{
	name = "PSYCHIC_WIPE", image = "talents/psychic_wipe.png",
	desc = _t"Psychic Wipe",
	long_desc = function(self, eff) return ("Ethereal fingers destroy the brain dealing %0.2f mind damage per turn and reducing mental save by %d."):tformat(eff.dam, eff.reduct) end,
	type = "mental",
	subtype = { psionic=true, mind=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# suddently feels strange in the brain.", true end,
	on_lose = function(self, err) return _t"#Target# feels less strange.", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_mentalresist", -eff.reduct)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="psychic_wipe_small"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="psychic_wipe_small"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=1.0}})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.dam)
	end,
}

newEffect{
	name = "GHASTLY_WAIL", image = "talents/ghastly_wail.png",
	desc = _t"Ghastly Wail",
	long_desc = function(self, eff) return _t"The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze." end,
	type = "mental",
	subtype = { stun=true, psionic=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is dazed!", "+Dazed" end,
	on_lose = function(self, err) return _t"#Target# is not dazed anymore.", "-Dazed" end,
	callbackOnTakeDamage = function(self, eff)
		if not self:attr("damage_dont_undaze") then
			self:removeEffect(self.EFF_GHASTLY_WAIL)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "dazed", 1)
		self:effectTemporaryValue(eff, "never_move", 1)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="weird_psi_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="weird_psi_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MIND_STEAL_REMOVE", image = "talents/mind_steal.png",
	desc = _t"Mind Steal",
	long_desc = function(self, eff) return ("Stolen talent: %s"):tformat(self:getTalentFromId(eff.tid).name) end,
	type = "other",
	subtype = { psionic=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# stole a talent!", true end,
	on_lose = function(self, err) return _t"#Target# forgot a talent.", true end,
	activate = function(self, eff)
		self.forbid_talents = self.forbid_talents or {}
		if self.forbid_talents[eff.tid] then eff.tid = nil return end
		self.forbid_talents[eff.tid] = _t"%s can not use %s because it was stolen!"
	end,
	deactivate = function(self, eff)
		if eff.tid then
			self.forbid_talents[eff.tid] = nil
		end
	end,
}

newEffect{
	name = "MIND_STEAL", image = "talents/mind_steal.png",
	desc = _t"Mind Steal",
	long_desc = function(self, eff) return ("Stolen talent: %s"):tformat(self:getTalentFromId(eff.tid).name) end,
	type = "other",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# stole a talent!", true end,
	on_lose = function(self, err) return _t"#Target# forgot a talent.", true end,
	activate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_MIND_STEAL)
			if pos then
				self.hotkey[pos] = {"talent", eff.tid}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(eff.tid, true, eff.lev, {no_unlearn=true})
		self.hotkey = ohk

		self.talent_no_resources = self.talent_no_resources or {}
		self:effectTemporaryValue(eff, "talent_no_resources", {[eff.tid] = 1})

		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="tentacles_shader/whispy_tentacles_better"}, shader={type="tentacles", wobblingType=0, appearTime=0.4, time_factor=2000, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="tentacles_shader/whispy_tentacles_better"}, shader={type="tentacles", wobblingType=0, appearTime=0.4, time_factor=2000, noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", eff.tid)
			if pos then
				self.hotkey[pos] = {"talent", self.T_MIND_STEAL}
			end
		end
		self:unlearnTalent(eff.tid, eff.lev, nil, {no_unlearn=true})
	end,
}

newEffect{
	name = "WRITHING_PSIONIC_MASS", image = "talents/writhing_psionic_mass.png",
	desc = _t"Writhing Psionic Mass",
	long_desc = function(self, eff) return ("All resists increased by %d%%, chance to be crit reduced by %d%%."):tformat(eff.resists, eff.crit) end,
	type = "physical",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return _t"#Target#'s body writhe in psionic energies!", true end,
	on_lose = function(self, err) return _t"#Target#'s body looks more at rest.", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crit)
		self:effectTemporaryValue(eff, "resists", {all=eff.resists})

		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.7, img="tentacles_shader/original_tentacles_1"}, shader={type="tentacles", noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.7, img="tentacles_shader/original_tentacles_1"}, shader={type="tentacles", noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "PSIONIC_DISRUPTION", image = "talents/psionic_disruption.png",
	desc = _t"Psionic Disruption",
	long_desc = function(self, eff) return ("%d stacks. Each stack deals %0.2f mind damage per turn."):tformat(eff.stacks, eff.dam) end,
	type = "mental",
	subtype = { psionic=true, damage=true },
	status = "detrimental",
	parameters = { dam = 10, stacks = 1, max_stacks = 2 },
	charges = function(self, eff) return eff.stacks end,
	on_gain = function(self, err) return _t"#Target# is disprupted by psionic energies!", true end,
	on_lose = function(self, err) return _t"#Target# no longer tormented by psionic energies.", true end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.__tmpparticles = old_eff.__tmpparticles
		new_eff.oldstacks = old_eff.oldstacks
		new_eff.stacks = util.bound(old_eff.stacks + 1, 1, new_eff.max_stacks)
		if new_eff.stacks == old_eff.stacks then table.remove(new_eff.oldstacks, 1) end
		table.insert(new_eff.oldstacks, old_eff.dur)
		return new_eff
	end,
	activate = function(self, eff)
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, shader=true, appear=12, img="aura_psionic_disruption_debuf", speed=0, radius=0}})
		eff.oldstacks = {}
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.dam * eff.stacks)
		for i, dur in ripairs(eff.oldstacks) do
			if dur <= 1 then
				eff.stacks = eff.stacks - 1
				table.remove(eff.oldstacks, i)
			else
				eff.oldstacks[i] = dur - 1
			end
		end
	end,
}

newEffect{
	name = "PSIONIC_BLOCK", image = "talents/psionic_block.png",
	desc = _t"Psionic Block",
	long_desc = function(self, eff) return ("%d%% chances to ignore damage and to retaliate with %0.2f mind damage."):tformat(eff.chance, eff.dam) end,
	type = "mental",
	subtype = { psionic=true, damage=true },
	status = "beneficial",
	parameters = { dam = 10, chance = 10 },
	on_gain = function(self, err) return _t"#Target# is protected by a psionic block!", true end,
	on_lose = function(self, err) return _t"#Target# no longer protected by the psionic block.", true end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if not rng.percent(eff.chance) then return end
		if self.turn_procs.psionic_block and self.turn_procs.psionic_block >= 2 then game.logSeen(self, "#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", self:getName()) return {dam=0} end
		if not src or not src.x or not src.y or not src.takeHit then game.logSeen(self, "#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", self:getName()) return {dam=0} end
		self.turn_procs.psionic_block = (self.turn_procs.psionic_block or 0) + 1

		DamageType:get(DamageType.MIND).projector(self, src.x, src.y, DamageType.MIND, eff.dam)

		game.logSeen(self, "#ROYAL_BLUE#The attack against %s is cancelled by a psionic block!", self:getName()) return {dam=0}
	end,
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="psionic_block_1"}, shader={type="tentacles", backgroundLayersCount=-4, wobblingType=0, appearTime=0.4, time_factor=1500, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="psionic_block_1"}, shader={type="tentacles", backgroundLayersCount=-4, wobblingType=0, appearTime=0.4, time_factor=1500, noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "SADIST", image = "talents/sadist.png",
	desc = _t"Sadist",
	long_desc = function(self, eff) return ("Mindpower (raw) increased by %d."):tformat(eff.stacks * eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { stacks=1, power=10 },
	charges = function(self, eff) return eff.stacks end,
	on_gain = function(self, err) return _t"#Target# is empowered by the suffering of others!", true end,
	on_lose = function(self, err) return _t"#Target# is no longer empowered.", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_mindpower", eff.power * eff.stacks)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RADIATE_AGONY", image = "talents/radiate_agony.png",
	desc = _t"Radiate Agony",
	long_desc = function(self, eff) return ("All damage reduced by %d%%."):tformat(eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return _t"#Target# focuses on pain!", true end,
	on_lose = function(self, err) return _t"#Target# is no longer focusing on pain.", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "generic_damage_penalty", eff.power)
	end,
}

newEffect{
	name = "TORTURE_MIND", image = "talents/torture_mind.png",
	desc = _t"Tortured Mind",
	long_desc = function(self, eff) return ("%d talents unusable."):tformat(eff.nb) end,
	type = "mental",
	subtype = { psionic=true, lock=true },
	status = "detrimental",
	parameters = {nb=1},
	on_gain = function(self, err) return _t"#Target# is tormented!", true end,
	on_lose = function(self, err) return _t"#Target# is less tormented.", true end,
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="scaly_tentacles_glow", r=0, g=0.5, b=1, a=1}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="scaly_tentacles_glow", r=0, g=0.5, b=1, a=1}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=1.0}})
		end

		self.forbid_talents = self.forbid_talents or {}

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and not self.forbid_talents[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		
		eff.talents = {}
		local nb = eff.nb
		while nb > 1 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.forbid_talents[t.id] = _t"%s can not use %s because of Tortured Mind!"
			eff.talents[t.id] = true
			nb = nb - 1
		end
	end,
	deactivate = function(self, eff)
		for tid in pairs(eff.talents) do self.forbid_talents[tid] = nil end
	end,
}
