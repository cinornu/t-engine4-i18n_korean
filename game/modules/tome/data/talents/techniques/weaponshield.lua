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

----------------------------------------------------------------------
-- Offense
----------------------------------------------------------------------

newTalent{
	name = "Shield Pummel",
	type = {"technique/shield-offense", 1},
	require = techs_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 8,
	requires_target = true,
	is_special_melee = true,
	tactical = { ATTACK = 1, DISABLE = { stun = 3 } },
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	getStunDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Pummel without a shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		self:attackTargetWith(target, shield_combat, nil, self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
		local speed, hit = self:attackTargetWith(target, shield_combat, nil, self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStunDuration(self, t), {apply_power=self:combatAttackStr()})
			else
				game.logSeen(target, "%s resists the shield bash!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target with two shield strikes, doing %d%% and %d%% shield damage. If it hits a second time, it stuns the target for %d turns.
		The stun chance increases with your Accuracy and your Strength.]])
		:tformat(100 * self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		100 * self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		t.getStunDuration(self, t))
	end,
}

newTalent{
	name = "Riposte",
	type = {"technique/shield-offense", 2},
	require = techs_req2,
	mode = "passive",
	points = 5,
	getDurInc = function(self, t)  -- called in effect "BLOCKING" in mod.data\timed_effects\physical.lua
		return math.ceil(self:combatTalentScale(t, 0.15, 1.15))
	end,
	getCritInc = function(self, t)
		return self:combatTalentIntervalDamage(t, "dex", 10, 50)
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "allow_incomplete_blocks", 1)
	end,
	info = function(self, t)
		local inc = t.getDurInc(self, t)
		return ([[Improves your ability to perform counterstrikes after blocks in the following ways:
		Allows counterstrikes after incomplete blocks.
		Increases the duration of the counterstrike debuff on attackers by %d %s.
		Increases the number of counterstrikes you can perform on a target while they're vulnerable by %d.
		Increases the crit chance of counterstrikes by %d%%. This increase scales with your Dexterity.]]):tformat(inc, (inc > 1 and _t"turns" or _t"turn"), inc, t.getCritInc(self, t))
	end,
}

newTalent{
	name = "Shield Slam",
	type = {"technique/shield-offense", 3},
	require = techs_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 12,
	requires_target = true,
	is_special_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	tactical = { ATTACK = 2}, -- is there a way to make this consider the free Block?
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Slam without a shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local damage = t.getShieldDamage(self, t)

		self:attackTargetWith(target, shield_combat, nil, damage)
		self:attackTargetWith(target, shield_combat, nil, damage)
		self:attackTargetWith(target, shield_combat, nil, damage)

		self:forceUseTalent(self.T_BLOCK, {ignore_energy=true, ignore_cd = true, silent = true})

		return true
	end,
	info = function(self, t)
		local damage = t.getShieldDamage(self, t)*100
		return ([[Hit your target with your shield 3 times for %d%% damage then quickly return to a blocking position.  The bonus block will not check or trigger Block cooldown.]])
		:tformat(damage)
	end,
}

newTalent{
	name = "Assault",
	type = {"technique/shield-offense", 4},
	require = techs_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 16,
	requires_target = true,
	tactical = { ATTACK = 4 },
	is_melee = true,
	is_special_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	on_pre_use = function(self, t, silent) if not (self:hasShield() and self:hasMHWeapon() ) then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		local weapon = self:hasMHWeapon() and self:hasMHWeapon().combat
		if not shield or not weapon then
			game.logPlayer(self, "You cannot use Assault without a mainhand weapon and shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- First attack with shield
		local speed, hit = self:attackTargetWith(target, shield_combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Second & third attack with weapon
		if hit then
			self.turn_procs.auto_phys_crit = true
			self:attackTargetWith(target, weapon, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3))
			self:attackTargetWith(target, weapon, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3))
			self.turn_procs.auto_phys_crit = nil
		end

		return true
	end,
	info = function(self, t)
		return ([[Hits the target with your shield, doing %d%% damage. If it hits, you follow up with two automatic critical hits with your weapon, doing %d%% base damage each.]]):
		tformat(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}


----------------------------------------------------------------------
-- Defense
----------------------------------------------------------------------
newTalent{
	name = "Shield Wall",
	type = {"technique/shield-defense", 1},
	require = techs_req1,
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_stamina = 30,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	getArmor = function(self,t) return self:combatTalentStatDamage(t, "str", 6, 30) + self:combatTalentStatDamage(t, "dex", 6, 30) end,
	getBlock = function(self, t) return self:combatTalentStatDamage(t, "str", 20, 75) + self:combatTalentStatDamage(t, "dex", 20, 75) end,
	stunKBresist = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.50) end, -- Limit <100%
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Wall without a shield!")
			return nil
		end
		local ret = {
			stun = self:addTemporaryValue("stun_immune", t.stunKBresist(self, t)),
			knock = self:addTemporaryValue("knockback_immune", t.stunKBresist(self, t)),
			armor = self:addTemporaryValue("combat_armor", t.getArmor(self,t)),
			block = self:addTemporaryValue("block_bonus", t.getBlock(self,t)),
			block_cd = self:addTemporaryValue("talent_cd_reduction", {[self.T_BLOCK] = 2}),
		}
		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1, img="rotating_shield"}, shader={type="rotatingshield", noup=2.0, appearTime=0.2}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1, img="rotating_shield"}, shader={type="rotatingshield", noup=1.0, appearTime=0.2}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_armor", p.armor)
		self:removeTemporaryValue("stun_immune", p.stun)
		self:removeTemporaryValue("knockback_immune", p.knock)
		self:removeTemporaryValue("block_bonus", p.block)
		self:removeTemporaryValue("talent_cd_reduction", p.block_cd)
		return true
	end,
	info = function(self, t)
		return ([[Enter a protective battle stance allowing you to defend yourself more proficiently while using a shield.
		Increases Armour by %d, Block value by %d, and reduces Block cooldown by 2.
		Increases stun and knockback resistance by %d%%.
		The Armor and Block bonuses increase equally with your Dexterity and Strength.]]):
		tformat(t.getArmor(self, t), t.getBlock(self, t), 100*t.stunKBresist(self, t))
	end,
}

newTalent{
	name = "Repulsion",
	type = {"technique/shield-defense", 2},
	require = techs_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 20,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 2.5, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	tactical = { ESCAPE = { knockback = 2 }, DEFEND = { knockback = 0.5 } },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	range = 0,
	radius = 1,
	requires_target = true,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDuration = function(self, t) return math.floor(self:combatStatScale("str", 3.8, 11)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		local shield, shield_combat = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Repulsion without a shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then
				local damage = t.getShieldDamage(self, t)
				local speed, hit = self:attackTargetWith(target, shield_combat, nil, damage)
				if hit and self:getTalentFromId(game.player.T_RUSH) then self.talents_cd["T_RUSH"] = nil end
				if target:checkHit(self:combatAttack(shield_combat), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then --Deprecated checkHit call
					target:knockback(self.x, self.y, t.getDist(self, t))
					if target:canBe("stun") then target:setEffect(target.EFF_DAZED, t.getDuration(self, t), {}) end
				else
					game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
				end
			end
		end)
		self:addParticles(Particles.new("meleestorm2", 1, {radius=2}))
		return true
	end,
	info = function(self, t)
		return ([[Smash your shield into the face of all adjacent foes dealing %d%% shield damage and knocking them back %d grids.
		In addition, all creatures knocked back will also be dazed for %d turns.
		If known, activating this talent will refresh your Rush cooldown if the attack hits.
		The distance increases with your talent level, and the Daze duration with your Strength.]]):tformat(t.getShieldDamage(self, t)*100, t.getDist(self, t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Shield Expertise",
	type = {"technique/shield-defense", 3},
	require = techs_req3,
	mode = "passive",
	points = 5,
	getPhysical = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	getSpell = function(self, t) return self:combatTalentScale(t, 3, 10, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physresist", t.getPhysical(self, t))
		self:talentTemporaryValue(p, "combat_spellresist", t.getSpell(self, t))
	end,
	info = function(self, t)
		return ([[Improves your damage with shield-based skills, and increases your Spell (+%d) and Physical (+%d) Saves.]]):tformat(t.getSpell(self, t), t.getPhysical(self, t))
	end,
}

newTalent{
	name = "Last Stand",
	type = {"technique/shield-defense", 4},
	require = techs_req4,
	mode = "sustained",
	points = 5,
	cooldown = 8,
	sustain_stamina = 30,
	tactical = { DEFEND = 3 },
	deactivate_on = {no_combat=true, run=true, rest=true},
	no_npc_use = true,
	no_energy = true,
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	lifebonus = function(self,t, base_life) -- Scale bonus with max life
		return self:combatTalentStatDamage(t, "con", 30, 500) + (base_life or self.max_life) * self:combatTalentLimit(t, 1, 0.02, 0.10) -- Limit <100% of base life
	end,
	getDefense = function(self, t) return self:combatTalentStatDamage(t, "dex", 6, 20) end,
	getArmor = function(self, t) return self:combatTalentStatDamage(t, "dex", 6, 20) end,
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Last Stand without a shield!")
			return nil
		end
		local hp = t.lifebonus(self,t)
		local ret = {
			base_life = self.max_life,
			max_life = self:addTemporaryValue("max_life", hp),
			def = self:addTemporaryValue("combat_def", t.getDefense(self, t)),
			armor = self:addTemporaryValue("combat_armor", t.getArmor(self, t)),
			nomove = self:addTemporaryValue("never_move", 1),
			dieat = self:addTemporaryValue("die_at", -hp),
			extra_life = self:addTemporaryValue("life", hp), -- Avoid healing effects
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_def", p.def)
		self:removeTemporaryValue("combat_armor", p.armor)
		self:removeTemporaryValue("max_life", p.max_life)
		self:removeTemporaryValue("never_move", p.nomove)
		self:removeTemporaryValue("die_at", p.dieat)
		self:removeTemporaryValue("life", p.extra_life)
		if self.life <= 0 then self.life = 1 end  -- Don't kill players on deactivation, this does let you use die_at tricks to heal though
		return true
	end,
	info = function(self, t)
		local hp = self:isTalentActive(self.T_LAST_STAND)
		if hp then
			hp = t.lifebonus(self, t, hp.base_life)
		else
			hp = t.lifebonus(self,t)
		end
		return ([[You brace yourself for the final stand, increasing Defense and Armor by %d, maximum and current life by %d, but making you unable to move.
		Your stand lets you concentrate on every blow, allowing you to avoid death from normally fatal wounds. You can only die when reaching -%d life.
		If your life is below 0 when Last Stand ends it will be set to 1.
		The increase in Defense and Armor is based on your Dexterity, and the increase in life is based on your Constitution and normal maximum life.]]):
		tformat(t.getDefense(self, t), hp, hp)
	end,
}
