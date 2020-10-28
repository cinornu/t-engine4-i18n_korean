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
	name = "Black Ice",
	type = {"spell/grave",1},
	require = spells_req1,
	points = 5,
	mana = 7,
	cooldown = 4,
	tactical = { ATTACK= { COLD = 2 }, DISABLE = 2 },
	range = 10,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		if self:getTalentLevel(t) < 5 then
			return {type="hit", range=self:getTalentRange(t), friendlyfire=false}
		else
			return {type="ball", radius=1, range=self:getTalentRange(t), friendlyfire=false}
		end
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 250) end,
	getMinionsInc = function(self,t) return math.floor(self:combatTalentScale(t, 10, 30)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end

		local dam = self:spellCrit(t:_getDamage(self))
		self:projectApply(tg, x, y, Map.ACTOR, function(target, x, y)
			if DamageType:get(DamageType.COLD).projector(self, x, y, DamageType.COLD, dam) > 0 then
				target:setEffect(target.EFF_BLACK_ICE, 3, {apply_power=self:combatSpellpower(), power=t:_getMinionsInc(self)})
			end
			game.level.map:particleEmitter(x, y, 1, "black_ice", {})
		end)

		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Summon an icy spike directly on a foe, impaling it for %0.2f cold damage.
		At level 5 it hits all foes in range 1 around the target.
		Any creature hit will take %d%% more damage from your necrotic minions for 3 turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD, damage), t:_getMinionsInc(self))
	end,
}

newTalent{
	name = "Chill of the Tomb",
	type = {"spell/grave",2},
	require = spells_req2,
	points = 5,
	mana = 30,
	cooldown = 8,
	tactical = { ATTACKAREA = { COLD = 2 } },
	range = 7,
	radius = function(self, t)
		return math.floor(self:combatTalentScale(t, 2, 6))
	end,
	proj_speed = 4,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=self:spellFriendlyFire(), talent=t, display={particle="bolt_ice", trail="icetrail"}}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 280) end,
	getFlatResist = function(self, t) return math.floor(self:combatTalentScale(t, 5, 25)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.CHILL_OF_THE_TOMB, {dam=self:spellCrit(t:_getDamage(self)), resist=t:_getFlatResist(self)}, function(self, tg, x, y, grids)
			game.level.map:particleEmitter(x, y, tg.radius, "iceflash", {radius=tg.radius, tx=x, ty=y})
		end)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Conjures up a bolt of cold that moves toward the target and explodes into a chilly circle of death, doing %0.2f cold damage in a radius of %d.
		Necrotic minions caught in the blast do not take damage but are instead coated with a thin layer of ice, reducing all damage they take by %d for 4 turns.
		The damage will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.COLD, damage), radius, t:_getFlatResist(self))
	end,
}

newTalent{
	name = "Corpselight",
	type = {"spell/grave",3},
	require = spells_req3,
	points = 5,
	mana = 20,
	soul = function(self, t) return self:knowTalent(self.T_GRAVE_MISTAKE) and 2 or 1 end,
	cooldown = 15,
	tactical = { ATTACKAREA={ COLD=4 } }, -- Higher prioriy to make sure it's cast before other spells so taht it can be extended
	radius = 3,
	range = 7,
	getMaxStacks = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7.5)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 400) / 7 end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t) + (self.life < 1 and 3 or 0), range=self:getTalentRange(t), nolock=true, nowarning=true} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTargetLimitedWallStop(tg)
		if not x then return end
		self:setEffect(self.EFF_CORPSELIGHT, 7, {x=x, y=y, radius=self:getTalentRadius(t), dam=t:_getDamage(self), stacks=self.life < 1 and 3 or 0, max_stacks=t:_getMaxStacks(self)})
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[You summon a corpselight that radiates cold for 7 turns in radius %d.
		Every turn all foes inside take %0.2f cold damage.
		Anytime you cast a spell inside your corpselight's area it grows by one stack, each stack giving +1 radius and +10%% damage.
		The corpselight can gain at most %d stacks and the radius will never extend beyond 10.
		If cast while under 1 life it spawns with 3 stacks.
		The damage will increase with your Spellpower.]]):
		tformat(radius, damDesc(self, DamageType.COLD, damage), t:_getMaxStacks(self))
	end,
}

newTalent{
	name = "Grave Mistake",
	type = {"spell/grave",4},
	require = spells_req4,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 250) end,
	explode = function(self, t, x, y, radius, stacks)
		local dam = t:_getDamage(self) * (1 + stacks * 0.1)
		local list = table.values(self:projectCollect({type="ball", radius=radius, x=x, y=y, friendlyfire=false}, x, y, Map.ACTOR))
		table.sort(list, "dist")
		for _, l in ipairs(list) do
			if l.target:canBe("knockback") then l.target:pull(x, y, radius) end
			DamageType:get(DamageType.COLD).projector(self, l.target.x, l.target.y, DamageType.COLD, dam)
		end
		game.level.map:particleEmitter(x, y, radius, "iceflash", {radius=radius})
		game.logSeen(self, "#STEEL_BLUE#The corpselight implodes!")
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Upon expiring the corpselight implodes, pulling in all foes towards its center and dealing %0.2f cold damage.
		The damage is increased by +10%% per stack.
		The damage will increase with your Spellpower.

		#PURPLE#Learning this spell will make Corpselight cost two souls to use instead of one.]]):
		tformat(damDesc(self, DamageType.COLD, damage))
	end,
}
