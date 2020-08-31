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

----------------------------------------------------
-- Active techniques
----------------------------------------------------
newTalent{
	name = "Rush",
	type = {"technique/combat-techniques-active", 1},
	message = _t"@Source@ rushes out!",
	require = techs_strdex_req1,
	points = 5,
	random_ego = "attack",
	stamina = function(self, t) return not self:attr("swap_combat_techniques_hate") and (self:knowTalent(self.T_STEAMROLLER) and 2 or 22) end,
	hate = function(self, t) return self:attr("swap_combat_techniques_hate") and (self:knowTalent(self.T_STEAMROLLER) and 1 or 6) end,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 36, 20)) end, --Limit to >0
	tactical = { ATTACK = { weapon = 1, stun = 1 }, CLOSEIN = 3 },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), requires_knowledge=false, stop__block=true} end,
	range = function(self, t) return math.min(14, math.floor(self:combatTalentScale(t, 6, 10))) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	on_pre_use_ai = function(self, t)
		local target = self.ai_target.actor
		if target and core.fov.distance(self.x, self.y, target.x, target.y) > 1 then return true end
		return false
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not target then game.logPlayer(self, "You can only rush to a creature.") return nil end
		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local linestep = self:lineFOV(x, y, block_actor)

		local tx, ty, lx, ly, is_corner_blocked
		repeat  -- make sure each tile is passable
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = linestep:step()
		until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move", self)
		if not tx or core.fov.distance(self.x, self.y, tx, ty) < 1 then
			game.logPlayer(self, "You are too close to build up momentum!")
			return
		end
		if not tx or not ty or core.fov.distance(x, y, tx, ty) > 1 then return nil end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end
		-- Attack ?
		if target and core.fov.distance(self.x, self.y, target.x, target.y) <= 1 then
			if self:knowTalent(self.T_STEAMROLLER) then
				target:setEffect(target.EFF_STEAMROLLER, 2, {src=self})
				self:setEffect(self.EFF_STEAMROLLER_USER, 2, {buff=20})
			end

			if self:attackTarget(target, nil, 1.2, true) and target:canBe("stun") then
				-- Daze, no save
				target:setEffect(target.EFF_DAZED, 3, {})
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Rush toward a target enemy with incredible speed and perform a melee attack for 120%% weapon damage that can daze the target for 3 turns if it hits.
		You must rush from at least 2 tiles away.]]):tformat()
	end,
}

newTalent{
	name = "Precise Strikes",
	type = {"technique/combat-techniques-active", 2},
	mode = "sustained",
	points = 5,
	require = techs_strdex_req2,
	cooldown = 30,
	sustain_stamina = function(self, t) return not self:attr("swap_combat_techniques_hate") and 30 end,
	sustain_hate = function(self, t) return self:attr("swap_combat_techniques_hate") and 9 end,
	tactical = { BUFF = 1 },
	getAtk = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 37, 500) end,
	getCrit = function(self, t)
		local dex = self:combatStatScale("dex", 10/25, 100/25, 0.75)
		return (self:combatTalentScale(t, dex, dex*5, 0.5, 4))
	end,
	activate = function(self, t)
		return {
			speed = self:addTemporaryValue("combat_physspeed", -0.10),
			atk = self:addTemporaryValue("combat_atk", t.getAtk(self, t)),
			crit = self:addTemporaryValue("combat_physcrit", t.getCrit(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("combat_atk", p.atk)
		return true
	end,
	info = function(self, t)
		return ([[You focus your strikes, reducing your attack speed by %d%% and increasing your Accuracy by %d and critical chance by %d%%.
		The effects will increase with your Dexterity.]]):
		tformat(10, t.getAtk(self, t), t.getCrit(self, t))
	end,
}

newTalent{
	name = "Perfect Strike",
	type = {"technique/combat-techniques-active", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 25,
	stamina = function(self, t) return not self:attr("swap_combat_techniques_hate") and 25 end,
	hate = function(self, t) return self:attr("swap_combat_techniques_hate") and 7 end,
	require = techs_strdex_req3,
	no_energy = true,
	tactical = { BUFF = 2 },
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 7, 2, 5)) end, -- Limit < 25
	getAtk = function(self, t) return self:combatTalentScale(t, 40, 100, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_ATTACK, t.getDuration(self, t), {power = t.getAtk(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[You have learned to focus your blows to hit your target, granting +%d accuracy and allowing you to attack creatures you cannot see without penalty for the next %d turns.]]):tformat(t.getAtk(self, t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Blinding Speed",
	type = {"technique/combat-techniques-active", 4},
	points = 5,
	random_ego = "utility",
	cooldown = 55,
	stamina = function(self, t) return not self:attr("swap_combat_techniques_hate") and 25 end,
	hate = function(self, t) return self:attr("swap_combat_techniques_hate") and 7 end,
	no_energy = true,
	require = techs_strdex_req4,
	random_boss_rarity = 33, -- common tree on classes and global speed is immensely powerful 
	tactical = { BUFF = 2, CLOSEIN = 2, ESCAPE = 2 },
	on_pre_use_ai = function(self, t) -- don't use out of combat
		local target = self.ai_target.actor
		if target and core.fov.distance(self.x, self.y, target.x, target.y) <= 10 and self:hasLOS(target.x, target.y, "block_move") then return true end
		return false
	end,
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.14, 0.4) end,
	action = function(self, t)
		self:setEffect(self.EFF_SPEED, 5, {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[Through rigorous training, you have learned to focus your actions for a short while, increasing your speed by %d%% for 5 turns.]]):tformat(100*t.getSpeed(self, t))
	end,
}

----------------------------------------------------
-- Passive techniques
----------------------------------------------------
newTalent{
	name = "Quick Recovery",
	type = {"technique/combat-techniques-passive", 1},
	require = techs_strdex_req1,
	mode = "passive",
	points = 5,
	getStamRecover = function(self, t) return self:combatTalentScale(t, 0.6, 2.5, 0.75) end,
	getHateRecover = function(self, t) return self:combatTalentScale(t, 0.2, 1, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "stamina_regen", t.getStamRecover(self, t))
	end,
	callbackOnTalentPost = function(self, t, ab, ret, silent)
		if ab.no_energy then return end
		if ab.mode ~= "activated" then return end
		if not self:attr("swap_combat_techniques_hate") then return end
		if not ab.hate or util.getval(ab.hate, self, ab) <= 0 then return end
		self:incHate(t.getHateRecover(self, t))
	end,
	info = function(self, t)
		if self:attr("swap_combat_techniques_hate") then return ([[Your combat focus allows you to keep your hatred burning (%0.1f hate refunded after spending hate on a talent)]]):tformat(t.getHateRecover(self, t)) end
		return ([[Your combat focus allows you to regenerate stamina faster (+%0.1f stamina/turn).]]):tformat(t.getStamRecover(self, t))
	end,
}

newTalent{
	name = "Fast Metabolism",
	type = {"technique/combat-techniques-passive", 2},
	require = techs_strdex_req2,
	mode = "passive",
	points = 5,
	getRegen = function(self, t) return self:combatTalentScale(t, 3, 7.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "life_regen", t.getRegen(self, t))
	end,
	info = function(self, t)
		return ([[Your combat focus allows you to regenerate life faster (+%0.1f life/turn).]]):tformat(t.getRegen(self, t))
	end,
}

newTalent{
	name = "Spell Shield",
	type = {"technique/combat-techniques-passive", 3},
	require = techs_strdex_req3,
	mode = "passive",
	points = 5,
	random_boss_rarity = 50, -- super common tree and this disproportionately targets mages
	getSaves = function(self, t) return math.floor(self:combatTalentScale(t, 12, 48)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellresist", t.getSaves(self,t))
	end,
	info = function(self, t)
		return ([[Rigorous training allows you to be more resistant to some spell effects (+%d spell save).]]):tformat(t.getSaves(self,t))
	end,
}

newTalent{
	name = "Unending Frenzy",
	type = {"technique/combat-techniques-passive", 4},
	require = techs_strdex_req4,
	mode = "passive",
	-- called by mod.class.Actor:die
	getStamRecover = function(self, t) return self:combatTalentScale(t, 5, 20, 0.5) end, -- Lower scaling than other recovery talents because it effectively scales with character speed and can trigger more than once a turn
	getHateRecover = function(self, t) return self:combatTalentScale(t, 1, 4.5, 0.5) end,
	points = 5,
	passives = function(self, t, p)
		if self:attr("swap_combat_techniques_hate") then
			self:talentTemporaryValue(p, "hate_per_kill", t.getHateRecover(self,t))
		end
	end,
	info = function(self, t)
		if self:attr("swap_combat_techniques_hate") then return ([[You revel in the death of your foes, regaining %0.1f additional hate with each death you cause.]]):tformat(t.getHateRecover(self, t)) end
		return ([[You revel in the death of your foes, regaining %0.1f stamina with each death you cause.]]):tformat(t.getStamRecover(self, t))
	end,
}
