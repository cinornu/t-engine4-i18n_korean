-- ToME - Tales of Middle-Earth
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

local Emote = require "engine.Emote"

newTalent{
	name = "Shadow Senses",
	type = {"cursed/one-with-shadows", 1},
	require = cursed_cun_req_high1,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, 1)) end,
	info = function(self, t)
		return ([[Your awareness extends to your shadows.
		You always know exactly where your shadows are and can perceive any foe within %d tiles of their vision.]])
		:tformat(self:getTalentRange(t))
	end,
}

newTalent{
	name = "Shadows Empathy", image = "talents/shadow_empathy.png",
	type = {"cursed/one-with-shadows", 2},
	require = cursed_cun_req_high2,
	points = 5,
	cooldown = 10,
	mode = 'sustained',
	no_npc_use = true,
	--count shadows in party
	getShadows = function(self, t)
		local shadowsCount = 0
		for _, actor in pairs(game.level.entities) do
			if actor.summoner and actor.summoner == self and actor.subtype == "shadow" then shadowsCount = shadowsCount + 1 end
		end
		return shadowsCount
	end,
	--values for resists and affinity
	getLightResist = function(self, t) return -15 end,
	getDarkResist = function(self, t) return self:combatTalentScale(t, 10, 25) end,
	getAffinity = function(self, t) return self:combatTalentScale(t, 10, 25) end,
	getAllResScale = function(self, t) return self:combatTalentScale(t, 2, 4) end,
	getAllResist = function(self, t) return t.getAllResScale(self, t) * t.getShadows(self, t) end, 
	--activate effects
	activate = function(self, t)
		local ret = {
			shadowres = self:addTemporaryValue("resists", {all=t.getAllResist(self, t)}),
			res = self:addTemporaryValue("resists", {[DamageType.LIGHT]=t.getLightResist(self, t), [DamageType.DARKNESS]=t.getDarkResist(self, t)}),
			aff = self:addTemporaryValue("damage_affinity", {[DamageType.DARKNESS]=t.getAffinity(self, t)}),
		}
		return ret
	end,
	--callbacks
	callbackOnPartyAdd = function(self, t)
		local p = self:isTalentActive(t.id)
		if p.shadowres then self:removeTemporaryValue("resists", p.shadowres) end
		p.shadowres = self:addTemporaryValue("resists", {all=t.getAllResist(self, t)})
	end,
	callbackOnPartyRemove = function(self, t)
		local p = self:isTalentActive(t.id)
		game:onTickEnd(function()
		if p.shadowres then self:removeTemporaryValue("resists", p.shadowres) end
		p.shadowres = self:addTemporaryValue("resists", {all=t.getAllResist(self, t)})
		end)
	end,
	--daectivate effects
	deactivate = function(self, t, p)
		self:removeTemporaryValue("resists", p.shadowres)
		self:removeTemporaryValue("resists", p.res)
		self:removeTemporaryValue("damage_affinity", p.aff)
		return true
	end,
	info = function(self, t)
		return ([[You empathy with your shadows causes the line between you and your shadows to blur.
		You lose %d%% light resistance, but gain %d%% darkness resistance and affinity. You also gain %0.2f%% all resistance for each shadow in your party.]]):
		tformat(t.getLightResist(self, t), t.getDarkResist(self, t), t.getAllResScale(self, t))
	end,
}

newTalent{
	name = "Shadow Transposition",
	type = {"cursed/one-with-shadows", 3},
	require = cursed_cun_req_high3,
	points = 5,
	hate = 6,
	cooldown = 10,
	no_npc_use = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 15, 1)) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, 1)) end,
	on_pre_use = function(self, t) return self:callTalent(self.T_CALL_SHADOWS, "nbShadowsUp") > 0 end,
	action = function(self, t) --closest friend will be a shadow almost all the time
		local tg = {type="hit", nolock=true, pass_terrain = true, first_target="friend", range=self:getTalentRadius(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, target.x, target.y) > self:getTalentRadius(t) then return nil end
		if target.summoner ~= self or not target.is_doomed_shadow then return end

		-- Displace
		local tx, ty, sx, sy = target.x, target.y, self.x, self.y
		target.x = nil target.y = nil
		self.x = nil self.y = nil
		target:move(sx, sy, true)
		self:move(tx, ty, true)

		self:removeEffectsFilter(self, function(t) return (t.type == "physical" or t.type == "magical") and t.status == "detrimental" end, t.getNb(self, t))

		return true
	end,
	info = function(self, t)
		return ([[Observers find it difficult to tell you and your shadows apart.
		You can target a shadow in radius %d and instantly trade places with it.
		%d random negative physical or magical effects are transferred from you to the chosen shadow in the process.]])
		:tformat(self:getTalentRadius(t), t.getNb(self, t))
	end,
}

newTalent{
	name = "Shadow Decoy",
	type = {"cursed/one-with-shadows", 4},
	require = cursed_cun_req_high4,
	mode = "sustained",
	cooldown = 10,
	points = 5,
	cooldown = 50,
	getPower = function(self, t) return 10 + self:combatTalentMindDamage(t, 0, 700) end, --be generous
	onDie = function(self, t, value, src)
		local shadows = {}
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		end
		local shadow = #shadows > 0 and rng.table(shadows)
		-- Nope! -- DG
		-- if not shadow and self:knowTalent(self.T_CALL_SHADOWS) then
		-- 	local t = self:getTalentFromId(self.T_CALL_SHADOWS)
		-- 	t.summonShadow(self, t) --summon a shadow if you have none
		-- end
		if not shadow then return false end

		game:delayedLogDamage(src, self, 0, ("#GOLD#(%d decoy)#LAST#"):tformat(value), false)
		game:delayedLogDamage(src, shadow, value, ("#GOLD#%d decoy#LAST#"):tformat(value), false)
		shadow:takeHit(value, src)
		self:setEffect(self.EFF_SHADOW_DECOY, 4, {power=t.getPower(self, t)})
		self:forceUseTalent(t.id, {ignore_energy=true})

		if self.player then
			self:setEmote(Emote.new("Fools, you never killed me; that was only my shadow!", 45))
			world:gainAchievement("AVOID_DEATH", self)
		end
		return true
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Your shadows guard you with their lives.
		When you would receive a fatal blow, you instantly transpose with a random shadow that takes the blow instead, putting this talent on cooldown.
		For the next 4 turns you only die if you reach -%d life.
		Effect increases with Mindpower.]]):
		tformat(t.getPower(self, t))
	end,
}
