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

newTalent{
	name = "Illuminate",
	type = {"spell/phantasm",1},
	require = spells_req1,
	random_ego = "utility",
	points = 5,
	mana = 5,
	cooldown = 14,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	tactical = { DISABLE = function(self, t, aitarget)
			if self:getTalentLevel(t) >= 3 and not aitarget:attr("blind") then
				return 2
			end
			return 0
		end,
		ATTACKAREA = { LIGHT = 1 },
	},
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 210) end,
	getBlindPower = function(self, t) if self:getTalentLevel(t) >= 5 then return 4 else return 3 end end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y, max_alpha=80})
		if self:getTalentLevel(t) >= 3 then
			self:project(tg, self.x, self.y, DamageType.BLIND, t.getBlindPower(self, t))
		end
		self:project(tg, self.x, self.y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)))
		tg.selffire = true
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local turn = t.getBlindPower(self, t)
		local dam = t.getDamage(self, t)
		return ([[Creates a globe of pure light within a radius of %d that illuminates the area and deals %0.2f damage to all creatures.
		At level 3, it also blinds all who see it (except the caster) for %d turns.]]):
		tformat(radius, damDesc(self, DamageType.LIGHT, dam), turn)
	end,
}

newTalent{
	name = "Phantasmal Shield",
	type = {"spell/phantasm", 2},
	mode = "sustained",
	require = spells_req2,
	points = 5,
	sustain_mana = 30,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 200) end,
	getEvade = function(self, t) return self:combatTalentSpellDamage(t, 1, 16) + 5 end,
	getDur = function(self, t) return self:combatTalentLimit(t, 5, 15, 9) end,
	radius = function(self, t) return self:combatTalentScale(t, 1, 4) end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if not p.icd then return end
		p.icd = p.icd - 1
		if p.icd <= 0 then p.icd = nil end
	end,
	callbackOnHit = function(self, t, cb, src, dt)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if cb.value <= 0 or src == self then return end
		if rng.percent(t.getEvade(self, t)) then
			game:delayedLogDamage(src, self, 0, ("#YELLOW#(%d ignored)#LAST#"):format(cb.value), false)
			cb.value = 0
			return true
		elseif not p.icd and src.x and src.y then
			p.icd = t.getDur(self, t)
			local dam = self:spellCrit(t.getDamage(self, t))
			self:projectApply({type="ball", selffire=false, radius=self:getTalentRadius(t), x=src.x, y=src.y}, src.x, src.y, Map.ACTOR, function(target, x, y)
				DamageType:get(DamageType.LIGHT).projector(self, x, y, DamageType.LIGHT, dam)
				target:setEffect(target.EFF_DAZZLED, 5, {power=10, apply_power=self:combatSpellpower()})
			end)
			game.level.map:particleEmitter(src.x, src.y, self:getTalentRadius(t), "sunburst", {radius=self:getTalentRadius(t), max_alpha=80})
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local ret = {}
		self:talentParticles(ret, {type="phantasm_shield"})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Surround yourself with a phantasmal shield of pure light.
		Whenever you would take damage there is %d%% chance to become ethereal for an instant and fully ignore it.
		If you do get hit, the shield glows brightly, sending triggering a flash of light on the attacker, dealing %0.2f light damage in radius %d around it and dazzling any affected creature (deal 10%% less damage) for 5 turns. This can only happen every %d turns.
		The damage and ignore chance will increase with your Spellpower.]]):
		tformat(t.getEvade(self, t), damDesc(self, DamageType.LIGHT, damage), self:getTalentRadius(t), t.getDur(self, t))
	end,
}

newTalent{
	name = "Invisibility",
	type = {"spell/phantasm", 3},
	require = spells_req3,
	points = 5,
	mana = 35,
	cooldown = 20,
	tactical = { ESCAPE = 2, DEFEND = 2 },
	getInvisibilityPower = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	getDamPower = function(self, t) return self:combatTalentScale(t, 10, 30) end,
	action = function(self, t)
		self:setEffect(self.EFF_GREATER_INVISIBILITY, 7, {dam=t.getDamPower(self, t), power=t.getInvisibilityPower(self, t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[Weave a net of arcane disturbances around your body, removing yourself from the sight of all, granting %d bonus to invisibility for 7 turns.
		While invisible all damage you deal against blinded or dazzled foes is increased by %d%% (additive with other damage increases).
		The invisibility bonus will increase with your Spellpower.]]):
		tformat(t.getInvisibilityPower(self, t), t.getDamPower(self, t))
	end,
}

newTalent{
	name = "Mirror Image", short_name = "MIRROR_IMAGES",
	type = {"spell/phantasm", 4},
	require = spells_req4,
	points = 5,
	mana = 30,
	cooldown = 20,
	tactical = { DEFEND = 3, ATTACK = 2 },
	getLife = function(self, t) return math.ceil(self:combatTalentScale(t, 5, 12)) end,
	on_pre_use = function(self, t) return self.in_combat and not self:hasEffect(self.EFF_MIRROR_IMAGE_REAL) end,
	action = function(self, t)
		if not self:canBe("summon") then game.logPlayer(self, "You cannot summon; you are suppressed!") return end

		-- Find all actors in radius 10 and add them to a table
		local tg = {type="ball", radius=self.sight}
		local grids = self:project(tg, self.x, self.y, function() end)
		local tgts = {}
		for x, ys in pairs(grids) do for y, _ in pairs(ys) do
			local target = game.level.map(x, y, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
		end end

		local target = rng.tableRemove(tgts)
		if not target then return end
		local tx, ty = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
		if not tx then return end

		local Talents = require "engine.interface.ActorTalents"
		local NPC = require "mod.class.NPC"
		local image = NPC.new{
			name = ("Mirror Image (%s)"):tformat(self:getName()),
			type = "image", subtype = "image",
			ai = "mirror_image", ai_real = nil, ai_state = { talent_in=1, }, ai_target = {actor=nil},
			desc = _t"A blurred image.",
			image = self.image,
			add_mos = table.clone(self.add_mos, true),
			exp_worth=0,
			level_range = {self.level, self.level},
			level = self.level,
			size_category = self.size_category,
			global_speed = self.global_speed,
			global_speed_add = self.global_speed_add,
			global_speed_base = self.global_speed_base,
			combat_spellspeed = self.combat_spellspeed,
			combat_def = -1000,
			combat_armor = 0,
			max_mana = 10000,
			mana = 10000,
			rank = self.rank,
			difficulty_boosted = 1,
			life_rating = 0,
			life_regen = 0, no_life_regen = 1,
			cant_be_moved = 1,
			never_move = 1,
			never_anger = true,
			generic_damage_penalty = 66,
			inc_damage = table.clone(self.inc_damage or {}, true),
			resists_pen = table.clone(self.resists_pen or {}, true),
			combat_precomputed_spellpower = self:combatSpellpowerRaw(),
			resolvers.talents{
				[Talents.T_TAUNT]=1, -- Add the talent so the player can see it even though we cast it manually
			},
			faction = self.faction,
			summoner = self,
			heal = function() return 0 end, -- Cant ever heal
			useCharge = function(self)
				self.charges = (self.charges or 1) - 1
				self.max_life = self.max_charges or 1
				self.life = self.charges
				if self.charges < 0 then self:die(self) end
			end,
			callbackOnAct = function(self)
				self.max_life = self.max_charges or 1
				self.life = self.charges or 1
			end,
			onTemporaryValueChange = function(self, ...)
				self:callbackOnAct()
				return mod.class.NPC.onTemporaryValueChange(self, ...)
			end,
			takeHit = function(self, value, src, death_note) -- Cant ever take more than one damage per turn per actor
				if not src then return false, 0 end
				if src ~= self then
					if not death_note or death_note.source_talent_mode ~= "active" then return false, 0 end
					if self.turn_procs.mirror_image_dmg and self.turn_procs.mirror_image_dmg[src] then return false, 0 end
					self.turn_procs.mirror_image_dmg = self.turn_procs.mirror_image_dmg or {}
					self.turn_procs.mirror_image_dmg[src] = true
				end
				self:useCharge()
				return false, 1
				-- return mod.class.NPC.takeHit(self, 1, src, death_note)
			end,
			on_die = function(self)
				self.summoner:removeEffect(self.summoner.EFF_MIRROR_IMAGE_REAL, true, true)
			end,
			spellFriendlyFire = function(self) return self.summoner:spellFriendlyFire() end,
			archmage_widebeam = self.archmage_widebeam,
			iceblock_pierce = self.iceblock_pierce,
			no_breath = 1,
			remove_from_party_on_death = true,
		}

		image:resolve()
		game.zone:addEntity(game.level, image, "actor", tx, ty)
		image.max_life = t:_getLife(self)
		image.life = t:_getLife(self)
		image.max_charges = t:_getLife(self)
		image.charges = t:_getLife(self)

		-- Clone particles
		for ps, _ in pairs(self.__particles) do
			image:addParticles(ps:clone())
		end

		-- Let addons/dlcs that need to alter the image
		self:triggerHook{"Spell:Phantasm:MirrorImage", image=image}

		local dam_bonus = self:callTalent(self.T_INVISIBILITY, "getDamPower")
		image:setEffect(image.EFF_MIRROR_IMAGE_FAKE, 1, {dam=dam_bonus})
		self:setEffect(image.EFF_MIRROR_IMAGE_REAL, 1, {image=image, dam=dam_bonus})

		-- Player & NPC don't work the same for this spell
		if game.party:hasMember(self) then
			game.party:addMember(image, {
				control=false,
				type="summon",
				title=_t"Summon",
				temporary_level = true,
				orders = {},
			})
			image:forceUseTalent(image.T_TAUNT, {ignore_cd=true, no_talent_fail = true})
			image.ai_state.use_taunt = true
		else
			-- Dont reveal ourself to player
			image.tooltip = function(self, x, y, seen_by) return mod.class.NPC.tooltip(self.summoner, x, y, seen_by) end
			image.showCharacterSheet = function(self) return self.summoner end
			image.ai_state.use_taunt = false
		end

		return true
	end,
	info = function(self, t)
		return ([[Create a perfect lookalike of your own form made out of pure light near a creature.
		This image has %d life and can never take more than 1 damage per creature per turn and is immune to any non direct damage (ground effects, damage over time, ...).
		Whenever you cast a spell your mirror image will try to duplicate it at the same target for 66%% less damage, if possible. If it can it will loose 1 life, if not it will instead taunt a creature to focus its attention on itself.
		While the image exists you receive the damage bonus from the Invisibility spell as if you were invisible.
		This spell can not be cast while a Mirror Image already exists and only in combat. It will disappear after a few turn when outside of combat.
		]])
		:tformat(t.getLife(self, t))
	end,
}
