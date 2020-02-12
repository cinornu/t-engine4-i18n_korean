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

-- Compute the total detection ability of enemies to see through stealth
-- Each foe loses 10% detection power per tile beyond range 1
-- returns detect, closest = total detection power, distance to closest enemy
-- if estimate is true, only counts the detection power of seen actors
local function stealthDetection(self, radius, estimate)
	if not self.x then return nil end
	local dist = 0
	local closest, detect = math.huge, 0
	for i, act in ipairs(self.fov.actors_dist) do
		dist = core.fov.distance(self.x, self.y, act.x, act.y)
		if dist > radius then break end
		if act ~= self and act:reactionToward(self) < 0 and not act:attr("blind") and (not act.fov or not act.fov.actors or act.fov.actors[self]) and (not estimate or self:canSee(act)) then
			detect = detect + act:combatSeeStealth() * (1.1 - dist/10) -- detection strength reduced 10% per tile
			if dist < closest then closest = dist end
		end
	end
	return detect, closest
end
Talents.stealthDetection = stealthDetection

-- radius of detection for stealth talents
local function stealthRadius(self, t, fake)
	local base = math.ceil(self:combatTalentLimit(t, 0, 8.9, 4.6)) -- Limit to range >= 1
	local sooth = self:callTalent(self.T_SOOTHING_DARKNESS, "getRadius", fake)
	local final = math.max(0, base - sooth)
	if fake then return base, final
	else return final
	end
end

newTalent{
	name = "Stealth",
	type = {"cunning/stealth", 1},
	require = cuns_req1,
	mode = "sustained", no_sustain_autoreset = true,
	points = 5,
	cooldown = 10,
	allow_autocast = true,
	no_energy = true,
	tactical = { BUFF = 3 },
	no_break_stealth = true,
	getStealthPower = function(self, t) return math.max(0, self:combatScale(self:getCun(10, true) * self:getTalentLevel(t), 15, 1, 64, 50, 0.25)) end, --TL 5, cun 100 = 64
	getRadius = stealthRadius,
	on_pre_use = function(self, t, silent, fake)
		local armor = self:getInven("BODY") and self:getInven("BODY")[1]
		if armor and (armor.subtype == "heavy" or armor.subtype == "massive") then
			if not silent then game.logPlayer(self, "You cannot be stealthy with such heavy armour on!") end
			return nil
		end
		if self:isTalentActive(t.id) then return true end
		
		-- Check nearby actors detection ability
		if not self.x or not self.y or not game.level then return end
		if not rng.percent(self.hide_chance or 0) then
			if stealthDetection(self, t.getRadius(self, t)) > 0 then
				if not silent then game.logPlayer(self, "You are being observed too closely to enter Stealth!") end
				return nil
			end
		end
		return true
	end,
	sustain_lists = "break_with_stealth",
	activate = function(self, t)
		if self:knowTalent(self.T_SOOTHING_DARKNESS) then
			local life = self:callTalent(self.T_SOOTHING_DARKNESS, "getLife")
			local sta = self:callTalent(self.T_SOOTHING_DARKNESS, "getStamina")
			local dur = self:callTalent(self.T_SOOTHING_DARKNESS, "getDuration")
			self:setEffect(self.EFF_SOOTHING_DARKNESS, dur, {life=life, stamina=sta})
		end
		local res = {
			stealth = self:addTemporaryValue("stealth", t.getStealthPower(self, t)),
			lite = self:addTemporaryValue("lite", -1000),
			infra = self:addTemporaryValue("infravision", 3),  -- Losing wall visibility is already annoying, may as well let stealth have a vision advantage
			stealthed_prevents_targetting = self:addTemporaryValue("stealthed_prevents_targetting", 1),
		}
		self:resetCanSeeCacheOf()
		if self.updateMainShader then self:updateMainShader() end
		return res
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("stealth", p.stealth)
		self:removeTemporaryValue("infravision", p.infra)
		self:removeTemporaryValue("lite", p.lite)
		self:removeTemporaryValue("stealthed_prevents_targetting", p.stealthed_prevents_targetting)
		if self:knowTalent(self.T_TERRORIZE) then
			local t = self:getTalentFromId(self.T_TERRORIZE)
			t.terrorize(self,t)
		end

		if self:knowTalent(self.T_SHADOWSTRIKE) then
			local power = self:callTalent(self.T_SHADOWSTRIKE, "getMultiplier") * 100
			local dur = self:callTalent(self.T_SHADOWSTRIKE, "getDuration")
			
			self:setEffect(self.EFF_SHADOWSTRIKE, dur, {power=power})
		end

		if self:knowTalent(self.T_SOOTHING_DARKNESS) then
			local shadowguard = self:knowTalent(self.T_SHADOWGUARD) and 25 or 0
			local life = self:callTalent(self.T_SOOTHING_DARKNESS, "getLife") * 5
			local sta = self:callTalent(self.T_SOOTHING_DARKNESS, "getStamina") * 5
			local dur = self:callTalent(self.T_SOOTHING_DARKNESS, "getDuration")
			self:setEffect(self.EFF_SOOTHING_DARKNESS, dur, {life=life, stamina=sta, shadowguard = shadowguard})
		end

		local sd = self:hasEffect(self.EFF_SHADOW_DANCE)
		if sd then
			sd.no_cancel_stealth = true
			self:removeEffect(sd.effect_id)
		end
		self:resetCanSeeCacheOf()
		if self.updateMainShader then self:updateMainShader() end
		return true
	end,
	callbackOnActBase = function(self, t)
		if self:knowTalent(self.T_SOOTHING_DARKNESS) then
			local life = self:callTalent(self.T_SOOTHING_DARKNESS, "getLife")
			local sta = self:callTalent(self.T_SOOTHING_DARKNESS, "getStamina")
			local dur = self:callTalent(self.T_SOOTHING_DARKNESS, "getDuration")
			self:setEffect(self.EFF_SOOTHING_DARKNESS, dur, {life=life, stamina=sta})
		end
	end,
	info = function(self, t)
		local stealthpower = t.getStealthPower(self, t) + (self:attr("inc_stealth") or 0)
		local radius, rad_dark = t.getRadius(self, t, true)
		xs = rad_dark ~= radius and (" (range %d in an unlit grid)"):tformat(rad_dark) or ""
		return ([[Enters stealth mode (power %d, based on Cunning), making you harder to detect.
		If successful (re-checked each turn), enemies will not know exactly where you are, or may not notice you at all.
		Stealth reduces your light radius to 0, increases your infravision by 3, and will not work with heavy or massive armours.
		You cannot enter stealth if there are foes in sight within range %d%s.
		Any non-instant, non-movement action will break stealth if not otherwise specified.

		Enemies uncertain of your location will still make educated guesses at it.
		While stealthed, enemies cannot share information about your location with each other and will be delayed in telling their allies that you exist at all.]]):
		tformat(stealthpower, radius, xs)
	end,
}

newTalent{
	name = "Shadowstrike",
	type = {"cunning/stealth", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	getMultiplier = function(self, t) return self:combatTalentScale(t, 0.15, 0.40, 0.1) end,
	getDuration = function(self,t) if self:getTalentLevel(t) >= 3 then return 4 else return 3 end end,
	no_npc_use = true,  -- Massive damage scaler on almost all forms of attack	
	passives = function(self, t, p) -- attribute that increases crit multiplier vs targets that cannot see us
		self:talentTemporaryValue(p, "unseen_critical_power", t.getMultiplier(self, t))
	end,
	info = function(self, t)
		local multiplier = t.getMultiplier(self, t)*100
		local dur = t.getDuration(self, t)
		return ([[You know how to make the most out of being unseen.
		When striking from stealth, your attacks are automatically critical if the target does not notice you just before you land it.  (Spell and mind attacks critically strike even if the target notices you.)
		Your critical multiplier against targets that cannot see you is increased by up to %d%%. (You must be able to see your target and the bonus is reduced from its full value at range 3 to 0 at range 10.)
		Also, after exiting stealth for any reason, the critical multiplier persists for %d turns (with no range limitation).]]):tformat(multiplier, dur)
	end,
}

newTalent{
	name = "Soothing Darkness",
	type = {"cunning/stealth", 3},
	require = cuns_req3,
	points = 5,
	mode = "passive",
	getLife = function(self, t) return self:combatStatScale("cun", 0.5, 5, 0.75) + self:combatTalentScale(t, 0.5, 5, 0.75) end,
	getStamina = function(self, t) return self:combatTalentScale(t, 1, 2.5) end, --2.9 @TL6.5
	getRadius = function(self, t, fake)
		if not fake and game.level.map.lites(self.x, self.y) then return 0 end
		return math.floor(self:combatTalentLimit(t, 10, 2, 5))
	end,
	getDuration = function(self,t) if self:getTalentLevel(t) >= 3 then return 4 else return 3 end end,
	info = function(self, t)
		return ([[You have a special affinity for darkness and shadows.
		When standing in an unlit grid, the minimum range to your foes for activating stealth or for maintaining it after a Shadow Dance is reduced by %d.
		While stealthed, your life regeneration is increased by %0.1f (based on your Cunning) and your stamina regeneration is increased by %0.1f.  The regeneration effects persist for %d turns after exiting stealth, with 5 times the normal rate.]]):
		tformat(t.getRadius(self, t, true), t.getLife(self,t), t.getStamina(self,t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Shadow Dance",
	type = {"cunning/stealth", 4},
	require = cuns_req4,
	no_energy = true,
	no_break_stealth = true,
	no_npc_use = true,  -- This turns into a 100% crit hyperscaler with bonus crit mult pretty easily
	points = 5,
	stamina = 30,
	cooldown = function(self, t) return self:combatTalentLimit(t, 10, 30, 15) end,
	tactical = { DEFEND = 2, ESCAPE = 2 },
	getRadius = stealthRadius,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 7, 2, 5)) end,
	action = function(self, t)
		self:setEffect(self.EFF_SHADOW_DANCE, t.getDuration(self,t), {src=self, rad=t.getRadius(self,t)}) 
		if not self:isTalentActive(self.T_STEALTH) then
			self:forceUseTalent(self.T_STEALTH, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, silent=true})
		end	
		return true
	end,
	info = function(self, t)
		return ([[Your mastery of stealth allows you to vanish from sight at any time.
		You automatically enter stealth and cause it to not break from unstealthy actions for %d turns.]]):
		tformat(t.getDuration(self, t))
	end,
}
