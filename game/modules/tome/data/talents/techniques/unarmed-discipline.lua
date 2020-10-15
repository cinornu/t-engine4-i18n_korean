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

-- We don't have to worry much about this vs. players since it requires combo points to be really effective and the AI isn't very bright
-- I lied, letting the AI use this is a terrible idea
newTalent{
	name = "Combination Kick",
	type = {"technique/unarmed-discipline", 1},
	short_name = "PUSH_KICK",
	require = techs_dex_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 20,
	stamina = 40,
	message = _t"@Source@ unleashes a flurry of disrupting kicks.",
	tactical = { ATTACK = { weapon = 2 }, },
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	requires_target = true,
	--on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_COMBO) then if not silent then game.logPlayer(self, "You must have a combo going to use this ability.") end return false end return true end,
	getStrikes = function(self, t) return self:getCombo() end,
	getDamage = function(self, t) return 0.1 + getStrikingStyle(self, dam) end,  -- Multihits already do plenty of damage and this has a ton of utility
	checkType = function(self, t, talent)
		if talent.is_spell and self:getTalentLevel(t) < 3 then
			return false
		end
		if talent.is_mind and self:getTalentLevel(t) < 5 then
			return false
		end
		return true
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		local talents = {}

		for i = 1, t.getStrikes(self, t) do
			local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)
			if hit then
				for tid, active in pairs(target.sustain_talents) do
					if active then
						local talent = target:getTalentFromId(tid)
						if t.checkType(self, t, talent) then talents[tid] = true end
					end
				end
			end
		end

		local dispeltypes = {}
		local nb = t.getStrikes(self, t)
		talents = table.keys(talents)
		while #talents > 0 and nb > 0 do
			local tid = rng.tableRemove(talents)
			target:dispel(tid, self)
			nb = nb - 1
			local tt = self:getTalentFromId(tid)
			if tt.is_spell then dispeltypes.spell = true
			elseif tt.is_mind then dispeltypes.mind = true
			else dispeltypes.physical = true end
		end

		if next(dispeltypes) then
			local img = "combination_kicks_1"
			if dispeltypes.spell and not dispeltypes.mind then img = "combination_kicks_2"
			elseif not dispeltypes.spell and dispeltypes.mind then img = "combination_kicks_2"
			elseif dispeltypes.spell and dispeltypes.mind then img = "combination_kicks_3"
			end
			local a = util.dirToAngle(util.getDir(target.x, self.y, self.x, target.y))
			game.level.map:particleEmitter(target.x, target.y, 2, "circle", {appear_size=0, base_rot=45 + a, a=250, appear=6, limit_life=6, speed=0, img=img, radius=-0.5})
		end

		self:clearCombo()

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[Unleash a flurry of disruptive kicks at your target's vulnerable areas. For each combo point you attack for %d%% weapon damage and deactivate one physical sustain.
			At talent level 3 #DARK_ORCHID#Magical#LAST# sustains will also be effected.
			At talent level 5 #YELLOW#Mental#LAST# sustains will also be effected.
			Using this talent removes your combo points.]])
		:tformat(damage)
	end,
}

newTalent{
	name = "Relentless Strikes",
	type = {"technique/unarmed-discipline", 2},
	require = techs_dex_req2,
	points = 5,
	mode = "passive",
	getStamina = function(self, t) return self:combatTalentLimit(t, 6, 1, 4) end,
	getChance = function(self, t) return self:combatTalentLimit(t, 70, 25, 60) end,
	info = function(self, t)
		local stamina = t.getStamina(self, t)
		local chance = t.getChance(self, t)
		return ([[When gaining a combo point, you have a %d%% chance to gain an extra combo point. Additionally, every time you earn a combo point, you will regain %0.2f stamina, or %0.2f stamina if you would exceed 5 combo points.]])
		:tformat(chance, stamina, stamina*2)
	end,
}

newTalent{
	name = "Open Palm Block",
	short_name = "BREATH_CONTROL",
	type = {"technique/unarmed-discipline", 3},
	require = techs_dex_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 5,
	message = _t"@Source@ prepares to block incoming attacks.",
	tactical = { ATTACK = 3, DEFEND = 3 },
	requires_target = true,
	getBlock = function(self, t) return self:combatTalentPhysicalDamage(t, 30, 200) end,
	action = function(self, t)
		local blockval = t.getBlock(self, t) * self:getCombo()
		self:setEffect(self.EFF_BRAWLER_BLOCK, 3, {block = blockval})

		self:clearCombo()

		return true
	end,
	info = function(self, t)
		local block = t.getBlock(self, t)
		local maxblock = block*5
		return ([[Toughen your body blocking up to %d damage per combo point (Max %d) across 2 turns.
			Current block value: %d
			Using this talent removes your combo points.
			The damage absorbed scales with your Physical Power.]])
		:tformat(block, block * 5, block * self:getCombo())
	end,
}

-- fix me
newTalent{
	name = "Touch of Death",
	type = {"technique/unarmed-discipline", 4},
	require = techs_dex_req4,
	points = 5,
	stamina = 40,
	random_ego = "attack",
	cooldown = 18,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	message = _t"@Source@ strikes a deadly pressure point on the target.",
	tactical = { DISABLE = 3, ATTACK = { weapon = 3 } },
	requires_target = true,
	radius = function(self,t) return self:combatTalentScale(t, 1, 3) end,
	getDamage = function(self, t) return 0.2 + getStrikingStyle(self, dam) end,
	getMult = function(self, t) return self:combatTalentLimit(t, 100, 25, 40) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		-- This is really not a good way to calculate damage, consider changing to base off just the weapon damage dealt
		self.turn_procs.auto_melee_hit = true
		-- store old values to restore later
		local evasion = target.evasion
		target.evasion = 0
		local oldlife = target.life
		self:logCombat(target, "#Source# strikes at a vital spot on #target#!")
		local do_attack = function() self:attackTarget(target, nil, t.getDamage(self, t), true) end
		local ok, err = pcall(do_attack)
		target.evasion = evasion
		if not ok then error(err) end
		self.turn_procs.auto_melee_hit = nil
		
		local life_diff = oldlife - target.life
		if life_diff > 0 then
			game:onTickEnd(function()	
				target:setEffect(target.EFF_TOUCH_OF_DEATH, 4, {dam=life_diff, initial_dam=life_diff, mult=t.getMult(self,t)/100, radius=self:getTalentRadius(t), src=self})
			end)
		end

		return true

	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local mult = t.getMult(self,t)
		local finaldam = damage+(damage*(((mult/100)+1)^2))+(damage*(((mult/100)+1)^3))+(damage*(((mult/100)+1)^4))
		local radius = self:getTalentRadius(t)
		return ([[Using your deep knowledge of anatomy, you strike a target in a vital pressure point for %d%% weapon damage, bypassing their defense and evasion.
		This strike inflicts terrible wounds inside the target's body, causing them to take physical damage equal to 100%% of any damage dealt during the attack each turn for 4 turns, increasing by %d%% each turn (so after 4 turns, they would have taken a total of %d%% damage).
		If the target dies while under or from this effect their body will explode in a radius %d shower of bone and gore, inflicting physical damage equal to the current tick to all enemies and granting you 4 combo points.]])
		:tformat(damage, mult, finaldam, radius, life)
	end,
}

--[[
newTalent{
	name = "Tempo",
	type = {"technique/unarmed-discipline", 3},
	short_name = "BREATH_CONTROL",
	require = techs_dex_req3,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 15,
	tactical = { BUFF = 1, STAMINA = 2 },
	getStamina = function(self, t) return 1 end,
	getDamage = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 1, 4))) end,
	getDefense = function(self, t) return math.floor(self:combatTalentScale(t, 1, 8)) end,
	getResist = function(self, t) return 20 end,
	activate = function(self, t)
		return {

		}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if not hitted or self.turn_procs.tempo or not (self:reactionToward(target) < 0) then return end
		self.turn_procs.tempo = true

		self:setEffect(target.EFF_RELENTLESS_TEMPO, 2, {
			stamina = t.getStamina(self, t),
			damage = t.getDamage(self, t),
			defense = t.getDefense(self, t),
			resist = t.getResist(self, t)
			 })
		return true
	end,
	info = function(self, t)
		local stamina = t.getStamina(self, t)
		local damage = t.getDamage(self, t)
		local resistance = t.getResist(self, t)
		local defense = t.getDefense(self, t)

		return (Your years of fighting have trained you for sustained engagements.  Each turn you attack at least once you gain %d Stamina Regeneration, %d Defense, and %d%% Damage Increase.
			This effect lasts 2 turns and stacks up to 5 times.
			At talent level 3 you gain %d%% All Resistance upon reaching 5 stacks.
		 ):
		--format(stamina, defense, damage, resistance ) --
	--end,
--}
--]]
