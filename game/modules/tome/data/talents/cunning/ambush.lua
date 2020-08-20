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

local Map = require "engine.Map"

newTalent{
	name = "Shadowguard",
	type = {"cunning/ambush", 1},
	mode = "passive",
	require = cuns_req_high1,
	points = 5,
	cooldown = 15,
	getDuration = function(self, t) return 5 end,
	getImmuneDuration = function(self, t) return 2 end,
	getSpellpower = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 30, 70)) end,
	getDefense = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 30, 70)) end,
	callbackOnHit = function(self, t, cb, src, death_note)
		if self:isTalentCoolingDown(t) then return end
		if self.life - cb.value <= self.max_life / 2 then
			self:startTalentCooldown(t)
			self:setEffect(self.EFF_SHADOWGUARD_IMMUNITY, t.getImmuneDuration(self, t), {})
			self:setEffect(self.EFF_SHADOWGUARD_BUFF, t.getDuration(self, t), {spellpower=t.getSpellpower(self, t), defense=t.getDefense(self, t)})
		end
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local duration2 = t.getImmuneDuration(self, t)
		local spellpower = t.getSpellpower(self, t)
		local defence = t.getDefense(self, t)
		return ([[Your Soothing Darkness talent effect now grants 25%% all damage resistance on exiting stealth.
		When your life drops below 50%% you become immune to negative detrimental effects for %d turns and gain %d defense and %d spellpower for %d turns.]]):
		tformat(duration2, defence, spellpower, duration)
	end,
}

newTalent{
	name = "Shadow Grasp", image = "talents/shadow_ambush.png",
	type = {"cunning/ambush", 2},
	require = cuns_req_high2,
	points = 5,
	cooldown = 20,
	stamina = 15,
	mana = 30,
	range = 10,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	tactical = { DISABLE = {silence = 2}, CLOSEIN = 2 },
	requires_target = true,
	no_break_stealth = true,
	getDuration = function(self, t) return 3 end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 450) end,
	speed = "spell",
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		local sx, sy = util.findFreeGrid(self.x, self.y, 5, true, {[engine.Map.ACTOR]=true})
		if not sx then return end

		if core.fov.distance(self.x, self.y, target.x, target.y) > 1 then
			-- Move first so we get the full benefit of Shadowstrike
			target:move(sx, sy, true)
		end
		
		self:project(tg, target.x, target.y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))

		if target:canBe("silence") then
			target:setEffect(target.EFF_SILENCED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
		end

		if target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the disarm!", target:getName():capitalize())
		end

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[You reach out with the shadows silencing and disarming your target for %d turns.
		The shadows will deal %d darkness damage to the target and pull it to you.
		The chance to apply debuffs improves with your Accuracy and the damage with your Spellpower.]]):
		tformat(duration, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Umbral Agility", image = "talents/ambuscade.png",
	type = {"cunning/ambush", 3},
	require = cuns_req_high3,
	points = 5,
	mode = "passive",
	no_npc_use = true,  -- This is likely fine on NPCs but disabled for now since accuracy/defense stacking is sometimes problematic, enable when weapon stuff is less in flux
	getAccuracy = function(self, t) return self:combatTalentSpellDamage(t, 15, 50) end,
	getDefense = function(self, t) return self:combatTalentSpellDamage(t, 15, 50) end,
	getPenetration = function(self, t) return self:combatTalentSpellDamage(t, 1, 40) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists_pen", {DARKNESS = 0})  -- Make sure its displayed since we don't modify Actor.resists_pen directly
	end,
	info = function(self, t)
		return ([[Your mastery of dark magic empowers you.
		You gain %d Accuracy, %d Defense, and %d%% Darkness damage penetration.
		The effects will increase with your Spellpower stat.]])
		:tformat(t.getAccuracy(self, t), t.getDefense(self, t), t.getPenetration(self, t))
	end,
}

newTalent{
	name = "Shadow Veil",
	type = {"cunning/ambush", 4},
	points = 5,
	cooldown = 15,
	stamina = 30,
	mana = 60,
	range = 7,
	require = cuns_req_high4,
	requires_target = true,
	tactical = { ATTACK = {DARKNESS = 2}, DEFEND = 1 },
	on_pre_use = function(self, t, silent)
		local acts = {}
		local act

		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and not act.dead and self:isNear(act.x, act.y, t.getBlinkRange(self, t)) then
				local sx, sy = util.findFreeGrid(act.x, act.y, 1, true, {[engine.Map.ACTOR]=true})
				if sx then acts[#acts+1] = {act, sx, sy} end
			end
		end

		if #acts == 0 then 
			if not silent then game.logPlayer(self, "No target nearby.") end 
			return false
		end
		return true 
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.9, 2.0) end, -- Nerf?
	getDuration = function(self, t) return 3 end,  -- 1 attack+3 turn effect, 4 total
	getDamageRes = function(self, t) return self:combatTalentSpellDamage(t, 15, 45) end,
	getBlinkRange = function(self, t) return 7 end,
	speed = "spell",
	action = function(self, t)
		local acts = {}
		local act

		self:doFOV() -- update actors seen
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and not act.dead and self:isNear(act.x, act.y, t.getBlinkRange(self, t)) then
				local sx, sy = util.findFreeGrid(act.x, act.y, 1, true, {[engine.Map.ACTOR]=true})
				if sx then acts[#acts+1] = {act, sx, sy} end
			end
		end

		act = rng.table(acts)
		if not act then return end
		self:move(act[2], act[3], true)
		game.level.map:particleEmitter(act[2], act[3], 1, "dark")
		self:attackTarget(act[1], DamageType.DARKNESS, t.getDamage(self, t), true)
		self:setEffect(self.EFF_SHADOW_VEIL, t.getDuration(self, t), {res=t.getDamageRes(self, t), dam=t.getDamage(self, t), range=t.getBlinkRange(self, t), x = act[2], y = act[3]})
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getDamageRes(self, t)
		return ([[You veil yourself in shadows and let them control you.
		Immediately after activation and each turn for %d turns, you blink to a nearby foe (within range %d of the location of the first target hit), hitting it for %d%% darkness weapon damage.
		While veiled, you become immune to status effects and gain %d%% all resistance.
		While this goes on, you cannot be stopped unless you are killed, and you cannot control your character.
		If a target isn't found this effect ends.
		The movement is not considered a teleport.
		The resistance will increase with your Spellpower stat.]]):
		tformat(duration, t.getBlinkRange(self, t) ,100 * damage, res)
	end,
}
