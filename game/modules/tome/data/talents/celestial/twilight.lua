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

--local Object = require "engine.Object"

newTalent{
	name = "Twilight",
	type = {"celestial/twilight", 1},
	require = divi_req1,
	points = 5,
	cooldown = 6,
	positive = 15,
	tactical = { NEGATIVE = 2, POSITIVE = -0.5 },
	range = 10,
	getNegativeGain = function(self, t) return math.max(0, self:combatScale(self:getTalentLevel(t) * self:getCun(40, true), 24, 4, 220, 200, nil, nil, 40)) end,
	action = function(self, t)
		self:incNegative(t.getNegativeGain(self, t))
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[You stand between the darkness and the light, allowing you to convert 15 positive energy into %d negative energy.
		The negative energy gain will increase with your Cunning.]]):
		tformat(t.getNegativeGain(self, t))
	end,
}

newTalent{
	name = "Jumpgate: Teleport To", short_name = "JUMPGATE_TELEPORT",
	type = {"celestial/other", 1},
	points = 1,
	cooldown = 7,
	negative = 14,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	no_npc_use = true,
	no_unlearn_last = true,
	getRange = function(self, t) return math.floor(self:combatTalentScale(t, 13, 18)) end,
	-- Check distance in preUseTalent to grey out the talent
	on_pre_use = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE]
		return eff and core.fov.distance(self.x, self.y, eff.jumpgate_x, eff.jumpgate_y) <= t.getRange(self, t)
	end,
	is_teleport = true,
	action = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE]
		if not eff then
			game.logPlayer(self, "You must sustain the Jumpgate spell to be able to teleport.")
			return
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(eff.jumpgate_x, eff.jumpgate_y, 1)
		game.level.map:particleEmitter(eff.jumpgate_x, eff.jumpgate_y, 1, "teleport")
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[Instantly travel to your jumpgate, as long as you are within %d tiles of it.]]):tformat(t.getRange(self, t))
 	end,
}

newTalent{
	name = "Jumpgate",
	type = {"celestial/twilight", 2},
	require = divi_req2,
	mode = "sustained", no_sustain_autoreset = true,
	points = 5,
	cooldown = function(self, t)
		local tl = self:getTalentLevelRaw(t)
		if tl < 4 then
			return math.ceil(self:combatLimit(tl, 0, 20, 1, 8, 4))
		else
			return math.ceil(self:combatLimit(tl, 0, 8, 4, 4, 5)) --I5 Limit >0
		end
	end,
	sustain_negative = 20,
	no_npc_use = true,
	tactical = { ESCAPE = 2 },
	iconOverlay = function(self, t, p)
		if not self.x or not self.y or not p.jumpgate_x or not p.jumpgate_y then return "" end
		local val = math.floor(core.fov.distance(self.x, self.y, p.jumpgate_x, p.jumpgate_y))
		local jt = self:getTalentFromId(self.T_JUMPGATE_TELEPORT)
		local max = jt.getRange(self, jt)
		local fnt = "buff_font_small"
		if val >= 1000 then fnt = "buff_font_smaller" end
		if val <= max then
			return "#LIGHT_GREEN#"..tostring(math.ceil(val)), fnt
		else
			return "#LIGHT_RED#"..tostring(math.ceil(val)), fnt
		end
	end,
 	on_learn = function(self, t)
		if self:getTalentLevel(t) >= 4 and not self:knowTalent(self.T_JUMPGATE_TWO) then
			self:learnTalent(self.T_JUMPGATE_TWO, nil, nil, {no_unlearn=true})
 		end
			self:learnTalent(self.T_JUMPGATE_TELEPORT, nil, nil, {no_unlearn=true})
	end,
 	on_unlearn = function(self, t)
		if self:getTalentLevel(t) < 4 and self:knowTalent(self.T_JUMPGATE_TWO) then
 			self:unlearnTalent(self.T_JUMPGATE_TWO)
 		end
			self:unlearnTalent(self.T_JUMPGATE_TELEPORT)
 	end,
	activate = function(self, t)
		local oe = game.level.map(self.x, self.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return false end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = _t"jumpgate", image = oe.image, add_mos = {{image = "terrain/wormhole.png"}},
			display = '&', color=colors.PURPLE,
			temporary = 1, -- This prevents overlapping of terrain changing effects; as this talent is a sustain it does nothing else
		}
		game.level.map(game.player.x, game.player.y, engine.Map.TERRAIN, e)

		local ret = {
			jumpgate = e, jumpgate_x = game.player.x, jumpgate_y = game.player.y,
			jumpgate_level = game.zone.short_name .. "-" .. game.level.level,
			particle = self:addParticles(Particles.new("time_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		-- Reset the terrain tile
		game.level.map(p.jumpgate_x, p.jumpgate_y, engine.Map.TERRAIN, p.jumpgate.old_feat)
		game.nicer_tiles:updateAround(game.level, p.jumpgate_x, p.jumpgate_y)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[Create a shadow jumpgate at your current location. As long as you sustain this spell, you can use 'Jumpgate: Teleport' to instantly travel to the jumpgate, as long as you are within %d tiles of it.
		Note that any stairs underneath the jumpgate will be unusable while the spell is sustained, and you may need to cancel this sustain in order to leave certain locations.
		At talent level 4, you learn to create and sustain a second jumpgate.]]):tformat(range)
 	end,
 }


newTalent{
	name = "Mind Blast",
	type = {"celestial/twilight",3},
	require = divi_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	negative = 20,
	tactical = { DISABLE = 3 },
	radius = 10,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, selffire=false}
	end,
	getConfuseDuration = function(self, t) return math.min(10, math.floor(self:combatScale(self:getTalentLevel(t) + self:getCun(5), 2, 0, 12, 10))) end,
	getConfuseEfficency = function(self, t) return self:combatTalentLimit(t, 60, 15, 45) end, -- Limit < 60% (slightly better than most confusion effects)
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 100) end,  -- Mostly for the crit synergy
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.CONFUSION, {
			dur = t.getConfuseDuration(self, t),
			dam = t.getConfuseEfficency(self, t)
		})
		self:project(tg, self.x, self.y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))
		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		return ([[Let out a mental cry that shatters the will of your targets within radius %d, dealing %0.2f darkness damage and confusing (%d%% to act randomly) them for %d turns.
		The damage will improve with your spellpower and the duration will improve with your Cunning.]]):
		tformat(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getConfuseEfficency(self,t), duration)
	end,
}

newTalent{
	name = "Shadow Simulacrum",
	type = {"celestial/twilight", 4},
	require = divi_req4,
	random_ego = "attack",
	points = 5,
	cooldown = 50,
	negative = 30,
	tactical = { ATTACK = 2 },
	requires_target = true,
	range = 5,
	random_boss_rarity = 50,
	unlearn_on_clone = true,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.floor(self:combatTalentStatDamage(t, "cun", 3, 10)+1) end,
	getPercent = function(self, t) return self:combatLimit(self:getCun(10, true)*self:getTalentLevel(t), 90, 0, 0, 50, 50) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target or self:reactionToward(target) >= 0 then return end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		if target:attr("summon_time") then
			game.logSeen(self, "You can't target summons!")
			return
		end

		if target:reactionToward(self) >= 0 then
			game.logSeen(self, "You can't target allies!")
			return
		end

		local modifier = t.getPercent(self, t)

		local m = target:cloneActor{
			shader = "shadow_simulacrum",
			name=("%s's shadow simulacrum"):tformat(target:getName()),
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			life=target.life*modifier/100, max_life=target.max_life*modifier/100, die_at=target.die_at*modifier/100,
			exp_worth=0, forceLevelup=function() end,
			ai_target = {actor=target},
			ai = "summoned", ai_real = target.ai,
			desc = _t[[A dark, shadowy shape whose form resembles the creature it was copied from. It is not a perfect replica, though, and it makes you feel uneasy to look at it.]],
		}
		table.mergeAdd(m.resists, {[DamageType.DARKNESS]=50, [DamageType.LIGHT]=- 50})
		table.mergeAdd(m.inc_damage, {all = -50})
		m:removeTimedEffectsOnClone()
		m:unlearnTalentsOnClone()

		if m.talents.T_SUMMON then m.talents.T_SUMMON = nil end
		if m.talents.T_MULTIPLY then m.talents.T_MULTIPLY = nil end

		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Creates a shadowy copy of a hostile target. The copy will attack its progenitor immediately and lasts for %d turns.
		The duplicate has %d%% of the target's life, +50%% darkness resistance, -50%% light resistance, and deals 50%% less damage.
		The duration and life scale with your Cunning.]]):
		tformat(duration, t.getPercent(self, t))
	end,
}

-- Extra Jumpgates

newTalent{
	name = "Jumpgate Two",
	type = {"celestial/other", 1},
	mode = "sustained", no_sustain_autoreset = true,
	points = 1,
	cooldown = 20,
	sustain_negative = 20,
	no_npc_use = true,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	no_unlearn_last = true,
	on_learn = function(self, t)
		if not self:knowTalent(self.T_JUMPGATE_TELEPORT_TWO) then
			self:learnTalent(self.T_JUMPGATE_TELEPORT_TWO, nil, nil, {no_unlearn=true})
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:unlearnTalent(self.T_JUMPGATE_TELEPORT_TWO)
		end
	end,
	iconOverlay = function(self, t, p)
		if not self.x or not self.y or not p.jumpgate2_x or not p.jumpgate2_y then return "" end
		local val = math.floor(core.fov.distance(self.x, self.y, p.jumpgate2_x, p.jumpgate2_y))
		local jt = self:getTalentFromId(self.T_JUMPGATE_TELEPORT_TWO)
		local max = jt.getRange(self, jt)
		local fnt = "buff_font_small"
		if val >= 1000 then fnt = "buff_font_smaller" end
		if val <= max then
			return "#LIGHT_GREEN#"..tostring(math.ceil(val)), fnt
		else
			return "#LIGHT_RED#"..tostring(math.ceil(val)), fnt
		end
	end,
	activate = function(self, t)
		local oe = game.level.map(self.x, self.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return false end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = _t"jumpgate", image = oe.image, add_mos = {{image = "terrain/wormhole.png"}},
			display = '&', color=colors.PURPLE,
			temporary = 1, -- This prevents overlapping of terrain changing effects; as this talent is a sustain it does nothing else
		}

		game.level.map(game.player.x, game.player.y, engine.Map.TERRAIN, e)
		local ret = {
			jumpgate2 = e, jumpgate2_x = game.player.x,	jumpgate2_y = game.player.y,
			jumpgate2_level = game.zone.short_name .. "-" .. game.level.level,
			particle = self:addParticles(Particles.new("time_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		-- Reset the terrain tile
		game.level.map(p.jumpgate2_x, p.jumpgate2_y, engine.Map.TERRAIN, p.jumpgate2.old_feat)
		game.nicer_tiles:updateAround(game.level, p.jumpgate2_x, p.jumpgate2_y)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT_TWO)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[Create a second shadow jumpgate at your location. As long as you sustain this spell, you can use 'Jumpgate: Teleport' to instantly travel to the jumpgate, as long as you are within %d tiles of it.]]):tformat(range)
	end,
}

newTalent{
	name = "Jumpgate Two: Teleport To", short_name = "JUMPGATE_TELEPORT_TWO",
	type = {"celestial/other", 1},
	points = 1,
	cooldown = 7,
	negative = 14,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	no_npc_use = true,
	getRange = function(self, t) return self:callTalent(self.T_JUMPGATE_TELEPORT, "getRange") end,
	-- Check distance in preUseTalent to grey out the talent
	is_teleport = true,
	no_unlearn_last = true,
	on_pre_use = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE_TWO]
		return eff and core.fov.distance(self.x, self.y, eff.jumpgate2_x, eff.jumpgate2_y) <= t.getRange(self, t)
	end,
	action = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE_TWO]
		if not eff then
			game.logPlayer(self, "You must sustain the Jumpgate Two spell to be able to teleport.")
			return
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(eff.jumpgate2_x, eff.jumpgate2_y, 1)
		game.level.map:particleEmitter(eff.jumpgate2_x, eff.jumpgate2_y, 1, "teleport")
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[Instantly travel to your second jumpgate, as long as you are within %d tiles of it.]]):tformat(t.getRange(self, t))
	end,
}
