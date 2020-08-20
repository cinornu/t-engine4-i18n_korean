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

newTalent{
	name = "Shadow Combat",
	type = {"cunning/shadow-magic", 1},
	mode = "sustained",
	points = 5,
	require = cuns_req1,
	sustain_stamina = 10,
	sustain_mana = 50,
	cooldown = 5,
	tactical = { BUFF = 2 },
	iconOverlay = function(self, t, p)
		local p = self.sustain_talents[t.id]
		if not p then return "" end
		return tostring(math.floor(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)))), "buff_font_smaller"
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 70)+10 end,  -- This doesn't crit or generally scale easily so its safe to be aggressive
	getManaCost = function(self, t) return 0 end,
	activate = function(self, t)
		local ret = {}
		if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = self:attachementSpot("hand1", true) if h1x then self:talentParticles(ret, {type="shader_shield", args={img="shadowhands_01", dir=180, a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, shader={type="flamehands", time_factor=slow and 700 or 1000}}) end
			local h2x, h2y = self:attachementSpot("hand2", true) if h2x then self:talentParticles(ret, {type="shader_shield", args={img="shadowhands_01", dir=180, a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, shader={type="flamehands", time_factor=not slow and 700 or 1000}}) end
		end
		game:playSoundNear(self, "talents/arcane")
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Channel raw magical energy into your melee attacks; each blow you land will do an additional %.2f darkness damage.
		The damage will improve with your Spellpower.]]):
		tformat(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Shadow Cunning",
	type = {"cunning/shadow-magic", 2},
	mode = "passive",
	points = 5,
	require = cuns_req2,
	-- called in _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local bonus = self:getCun()*spellpower/100
		return ([[Your preparations give you greater magical capabilities. You gain a bonus to Spellpower equal to %d%% of your Cunning (Current bonus: %d).]]):
		tformat(spellpower, bonus)
	end,
}

newTalent{
	name = "Shadow Feed",
	type = {"cunning/shadow-magic", 3},
	mode = "sustained",
	points = 5,
	cooldown = 5,
	sustain_stamina = 10,
	sustain_mana = 20,
	require = cuns_req3,
	tactical = { BUFF = 2 },
	getManaRegen = function(self, t) return self:combatTalentLimit(t, 1, 0.3, 0.8) * (1+t.getAtkSpeed(self, t)/100) end,
	getAtkSpeed = function(self, t) return self:combatTalentScale(t, 2.2, 15) end,
	activate = function(self, t)
		local speed = t.getAtkSpeed(self, t)/100
		game:playSoundNear(self, "talents/arcane")
		return {
			regen = self:addTemporaryValue("mana_regen", t.getManaRegen(self, t)),
			ps = self:addTemporaryValue("combat_physspeed", speed),
			ss = self:addTemporaryValue("combat_spellspeed", speed),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.regen)
		self:removeTemporaryValue("combat_physspeed", p.ps)
		self:removeTemporaryValue("combat_spellspeed", p.ss)
		return true
	end,
	info = function(self, t)
		local manaregen = t.getManaRegen(self, t)
		return ([[You draw energy from the depths of the shadows.
		While sustained, you regenerate %0.2f mana per turn, and your physical and spell attack speed increases by %0.1f%%.]]):
		tformat(manaregen, t.getAtkSpeed(self, t))
	end,
}

newTalent{
	name = "Shadowstep",
	type = {"cunning/shadow-magic", 4},
	points = 5,
	cooldown = 6,
	stamina = 20,
	mana = 20,
	require = cuns_req4,
	tactical = { CLOSEIN = 2, DISABLE = { stun = 1 } },
	range = function(self, t) return math.min(math.floor(self:combatTalentScale(t, 6, 10), 10)) end,
	direct_hit = true,
	requires_target = true,
	is_melee = true,
	is_teleport = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.min(5, 2 + math.ceil(self:getTalentLevel(t) / 2)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 2) end,
	on_pre_use = function(self, t, silent) if self:attr("never_move") then if not silent then game.logPlayer(self, "You require to be able to move to use this talent.") end return false end return true end,
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "You cannot do that currently.") return end
		
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not target or not self:canProject(tg, x, y) then return nil end
		if not game.level.map.seens(x, y) or not self:hasLOS(x, y) then
			game.logSeen(self, "You do not have line of sight.")
			return nil
		end

		if not self:teleportRandom(x, y, 0) then game.logSeen(self, "The spell fizzles!") return true end

		-- Attack ?
		if target and target.x and core.fov.distance(self.x, self.y, target.x, target.y) == 1 then
			self:attackTarget(target, DamageType.DARKNESS, t.getDamage(self, t), true)
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, t.getDuration(self, t), {})
			else
				game.logSeen(target, "%s is not dazed!", target:getName():capitalize())
			end
		end
		
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Step through the shadows to your target, dazing it for %d turns and hitting it with all your weapons for %d%% darkness weapon damage.
		Dazed targets are significantly impaired, but any damage will free them.
		To Shadowstep, you need to be able to see the target.]]):
		tformat(duration, t.getDamage(self, t) * 100)
	end,
}
