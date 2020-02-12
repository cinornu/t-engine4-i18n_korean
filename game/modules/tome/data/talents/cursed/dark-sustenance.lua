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

newTalent{
	name = "Feed",
	type = {"cursed/dark-sustenance", 1},
	require = cursed_wil_req1,
	points = 5,
	cooldown = 15,
	range = 7,
	hate = 0,
	no_energy = true,
	tactical = { BUFF = 2, DEFEND = 1 },
	requires_target = true,
	direct_hit = true,
	getHateGain = function(self, t)
		return math.sqrt(self:getTalentLevel(t)) * 2 + self:combatMindpower() * 0.02
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local tg = {type="hit", range=range}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target or not self:canProject(tg, x, y) then return nil end
		if target == self then return nil end -- avoid targeting while frozen

		if self:reactionToward(target) >= 0 or target.summoner == self then
			game.logPlayer(self, "You can only gain sustenance from your foes!");
			return nil
		end

		-- remove old effect
		if self:hasEffect(self.EFF_FEED) then
			self:removeEffect(self.EFF_FEED)
		end

		local hateGain = t.getHateGain(self, t)
		local constitutionGain = 0
		local lifeRegenGain = 0
		local damageGain = 0
		local resistGain = 0

		local tFeedPower = self:getTalentFromId(self.T_FEED_POWER)
		if tFeedPower and self:getTalentLevelRaw(tFeedPower) > 0 then
			damageGain = tFeedPower.getDamageGain(self, tFeedPower, target)
		end

		local tFeedStrengths = self:getTalentFromId(self.T_FEED_STRENGTHS)
		if tFeedStrengths and self:getTalentLevelRaw(tFeedStrengths) > 0 then
			resistGain = tFeedStrengths.getResistGain(self, tFeedStrengths, target)
		end

		local devour = self:getTalentFromId(self.T_DEVOUR_LIFE)
		if devour and self:getTalentLevelRaw(devour) > 0 then
			lifeRegenGain = devour.getLifeRegen(self, devour, target)
		end

		self:setEffect(self.EFF_FEED, 40, { target=target, tg=tg, range=range, hateGain=hateGain, constitutionGain=constitutionGain, lifeRegenGain=lifeRegenGain, damageGain=damageGain, resistGain=resistGain })

		return true
	end,
	-- QOL behavior mostly
	callbackOnActBase = function(self, t)
		if self:hasEffect(self.EFF_FEED) then return end
		if not self.in_combat then return end

		local nb_foes = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			local tg = {type="hit", range=self:getTalentRange(t)}
			if act and self:reactionToward(act) < 0 and self:canSee(act) and self:canProject(tg, act.x, act.y) then 
				local hateGain = t.getHateGain(self, t)
				local constitutionGain = 0
				local lifeRegenGain = 0
				local damageGain = 0
				local resistGain = 0

				local tFeedPower = self:getTalentFromId(self.T_FEED_POWER)
				if tFeedPower and self:getTalentLevelRaw(tFeedPower) > 0 then
					damageGain = tFeedPower.getDamageGain(self, tFeedPower, target)
				end

				local tFeedStrengths = self:getTalentFromId(self.T_FEED_STRENGTHS)
				if tFeedStrengths and self:getTalentLevelRaw(tFeedStrengths) > 0 then
					resistGain = tFeedStrengths.getResistGain(self, tFeedStrengths, target)
				end

				local devour = self:getTalentFromId(self.T_DEVOUR_LIFE)
				if devour and self:getTalentLevelRaw(devour) > 0 then
					lifeRegenGain = devour.getLifeRegen(self, devour, target)
				end
				self:setEffect(self.EFF_FEED, 40, 
					{ target=act, tg=tg, range=range, hateGain=hateGain, constitutionGain=constitutionGain, lifeRegenGain=lifeRegenGain, damageGain=damageGain, resistGain=resistGain })
			end
		end		

	end,
	info = function(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[Feed from the essence of your enemy. Draws %0.1f hate per turn from a targeted foe, as long as they remain in your line of sight.
			If you aren't already feeding this will be automatically applied to the nearest enemy.
		Hate gain improves with your Mindpower.]]):tformat(hateGain)
	end,
}

newTalent{
	name = "Devour Life",
	type = {"cursed/dark-sustenance", 2},
	require = cursed_wil_req2,
	points = 5,
	mode = "passive",
	getLifeRegen = function(self, t, target)
		return self:combatTalentMindDamage(t, 1, 40)  -- Essentially damage without damage synergies like crit, damage%, etc
	end,
	info = function(self, t)
		local regen = t.getLifeRegen(self, t)
		return ([[Devours life from the target of your feeding reducing their life regeneration by %d and adding half of that to yours.
		Improves with your Mindpower.]]):tformat(regen)
	end,
}

--[[
newTalent{
	name = "Feed Health",
	type = {"cursed/dark-sustenance", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	getConstitutionGain = function(self, t, target)
		local gain = math.floor((6 + self:getWil(6)) * math.sqrt(self:getTalentLevel(t)) * 0.392)
		if target then
			-- return capped gain
			return math.min(gain, math.floor(target:getCon() * 0.75))
		else
			-- return max gain
			return gain
		end
	end,
	getLifeRegenGain = function(self, t, target)
		return self.max_life * (math.sqrt(self:getTalentLevel(t)) * 0.012 + self:getWil(0.01))
	end,
	info = function(self, t)
		local constitutionGain = t.getConstitutionGain(self, t)
		local lifeRegenGain = t.getLifeRegenGain(self, t)
		return ([Enhances your feeding by transferring %d constitution and %0.1f life per turn from a targeted foe to you.
		Improves with the Willpower stat.]):tformat(constitutionGain, lifeRegenGain)
	end,
}
]]
newTalent{
	name = "Feed Power",
	type = {"cursed/dark-sustenance", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	getDamageGain = function(self, t)
		return self:combatLimit(self:getTalentLevel(t)^0.5 * 5 + self:combatMindpower() * 0.05, 100, 0, 0, 14, 14) -- Limit < 100%
	end,
	info = function(self, t)
		local damageGain = t.getDamageGain(self, t)
		return ([[Enhances your feeding by reducing your targeted foe's damage by %d%%, and increasing yours by the same amount.
		Improves with your Mindpower.]]):tformat(damageGain)
	end,
}

newTalent{
	name = "Feed Strengths",
	type = {"cursed/dark-sustenance", 4},
	mode = "passive",
	require = cursed_wil_req4,
	points = 5,
	getResistGain = function(self, t)
		return self:combatLimit(self:getTalentLevel(t)^0.5 * 14 + self:combatMindpower() * 0.15, 100, 0, 0, 40, 40) -- Limit < 100%
	end,
	info = function(self, t)
		local resistGain = t.getResistGain(self, t)
		return ([[Enhances your feeding by reducing your targeted foe's resistances, multiplying them by %0.2f and increasing your resistances by the amount drained. Resistance to "all" is not affected.
		Improves with your Mindpower.]]):tformat((1-(resistGain/100)))
	end,
}
