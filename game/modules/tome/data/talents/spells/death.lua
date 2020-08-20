-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2020 Nicolas Casalini
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
	name = "Rigor Mortis",
	type = {"spell/death",1},
	require = spells_req1,
	points = 5,
	soul = 1,
	mana = 10,
	range = 10,
	cooldown = 15,
	requires_target = true,
	tactical = { ATTACK = { COLD=1, DARK=1 }, DISABLE = 1 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 300) end,
	getMax = function(self, t) return math.floor(self:combatTalentScale(t, 1, 9)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	on_pre_use_ai = function(self, t)
		local target = self.ai_target.actor
		if not target then return false end

		return true
	end,
	incFormula = function(nb)
		return 1 + math.log10(nb) * 1.5
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x then return end

		self:projectApply(tg, x, y, Map.ACTOR, function(target)
			local nb = #target:effectsFilter({status="detrimental", ignore_crosstier=true}, 999)
			if nb == 0 then return end
			local mult = t.incFormula(nb)
			local dam = self:spellCrit(mult * t:_getDamage(self))
			if DamageType:get(DamageType.FROSTDUSK).projector(self, target.x, target.y, DamageType.FROSTDUSK, dam) > 0 then
				if target:canBe("slow") then
					target:setEffect(target.EFF_RIGOR_MORTIS, util.bound(nb, 1, t:_getMax(self)), {power=0.25, apply_power=self:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the Rigor Mortis!", target:getName():capitalize())
				end
			end
		end, nil, {type="dark"})

		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.FROSTDUSK, t:_getDamage(self))
		return ([[Press your advantage when your foes are starting to crumble.
		For every detrimental effect on the target you deals %0.2f frostdusk damage (with diminishing returns) and reduce its global speed by 25%% for one turn per effect (up to a maximum of %d).
		The diminishing returns on damage bonus works this way:
		- 2 effects: %0.2f
		- 5 effects: %0.2f
		- 10 effects: %0.2f
		- 15 effects: %0.2f
		And so on...
		Damage increases with your Spellpower.
		]]):tformat(dam, t:_getMax(self), dam*t.incFormula(2), dam*t.incFormula(5), dam*t.incFormula(10), dam*t.incFormula(15))
	end,
}

newTalent{
	name = "Drawn To Death",
	type = {"spell/death", 2},
	require = spells_req2,
	points = 5,
	cooldown = 15,
	no_energy = true,
	no_npc_use = true,
	mana = 15,
	getTurns = function(self, t) return math.ceil(self:combatTalentScale(t, 2, 6)) end,
	on_learn = function(self, t)
		self.__drawn_to_death_portals = self.__drawn_to_death_portals or { portals = {} }
	end,
	registerPortal = function(self, t, x, y)
		local p = self.__drawn_to_death_portals
		if not p then return end
		table.insert(p.portals, {
			x = x, y = y,
			dur = t:_getTurns(self)
		})
	end,
	callbackOnChangeLevel = function(self, t, what)
		local p = self.__drawn_to_death_portals
		if not p then return end
		if what ~= "leave" then return end
		p.portals = {}
	end,
	callbackOnActBase = function(self, t)
		local p = self.__drawn_to_death_portals
		if not p then return end

		for i, portal in ripairs(p.portals) do
			portal.dur = portal.dur - 1
			if portal.dur <= 0 then table.remove(p.portals, i) end
		end
	end,
	callbackOnKill = function(self, t, target, death_note)
		if target.x then t:_registerPortal(self, target.x, target.y) end
	end,
	callbackOnSummonKill = function(self, t, minion, target, death_note)
		if target.x then t:_registerPortal(self, target.x, target.y) end
	end,
	requires_target = true,
	direct_hit = true,
	range = 10,
	target = function(self, t) return {type="hit", nolock=true, range=self:getTalentRange(t)} end,
	on_pre_use = function(self, t) return self.__drawn_to_death_portals and #self.__drawn_to_death_portals.portals > 0 end,
	action = function(self, t, p)
		local p = self.__drawn_to_death_portals
		if not p then return end

		local tg = self:getTalentTarget(t)

		-- Ok this is a bit weird, we add map effects before target and remove them afterwards
		-- this way the player will see the portals, but only while casting
		local list = {}
		for _, portal in ipairs(p.portals) do list[#list+1] = game.level.map:particleEmitter(portal.x, portal.y, 1, "death_door", {}) end
		local x, y = self:getTargetLimited(tg)
		for _, e in ipairs(list) do game.level.map:removeParticleEmitter(e) end
		if not x then return end
		
		for _, portal in ipairs(p.portals) do if portal.x == x and portal.y == y then
			if game.level.map(x, y, Map.ACTOR) then
				game.logPlayer("#LIGHT_RED#There already is a creature there! Kill it!")
				return false
			else
				local ox, oy = self.x, self.y
				game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
				self:teleportRandom(x, y, 0)
				game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
			end
			return true
		end end
		return nil
	end,	
	info = function(self, t)
		return ([[Every time you or one of your minions kill a creature you create a temporary link to the place of death.
		For %d turns afterwards you can instantly and accurately teleport to it (if it is in sight).
		]]):tformat(t:_getTurns(self))
	end,
}

newTalent{
	name = "Grim Shadow",
	type = {"spell/death", 3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	sustain_mana = 35,
	cooldown = 30,
	tactical = { BUFF=3 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 1, 3)) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), friendlyfire=false, talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 180) end,
	getResist = function(self, t) return math.floor(self:combatTalentScale(t, 10, 25)) end,
	getArmor = function(self, t) return math.floor(self:combatTalentScale(t, 5, 30)) end,
	getDef = function(self, t) return math.floor(self:combatTalentScale(t, 5, 30)) end,
	onSoulGain = function(self, t)
		if self.turn_procs.grim_shadow then return end
		if self:getSoul() == self:getMaxSoul() then return end
		self.turn_procs.grim_shadow = true

		game.logSeen(self, "#GREY#Darkness pulsates around %s!", self:getName())
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.FROSTDUSK, t:_getDamage(self))
		local list = table.listify(self:projectCollect(tg, self.x, self.y, Map.ACTOR))
		table.sort(list, function(a, b) return a[2].dist > b[2].dist end)
		for _, i in ipairs(list) do
			local target = i[1]
			if target:canBe("knockback") then target:knockback(self.x, self.y, 3) end
		end
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_darkness", {radius=tg.radius})
	end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "combat_armor", t:_getArmor(self))
		self:talentTemporaryValue(ret, "combat_def", t:_getDef(self))
		self:talentTemporaryValue(ret, "resists", {[DamageType.DARKNESS]=t:_getResist(self)})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Your body starts to radiate shadows, increasing your darkness resistance by %d%%, armour by %d and defence by %d.
		Any time you absorb a soul the shadows pulse outward, dealing %0.2f frostdusk damage to all foes in range %d and knocking them back 3 tiles.
		This can only happen once per turn.
		The damage increases with your Spellpower.]]):
		tformat(t:_getResist(self), t:_getArmor(self), t:_getDef(self), damDesc(self, DamageType.FROSTDUSK, t.getDamage(self, t)), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Utterly Destroyed",
	type = {"spell/death",4},
	require = spells_req4,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_mana = 15,
	getMana = function(self, t) return math.floor(self:combatTalentScale(t, 10, 27)) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	trigger = function(self, t)
		self:incMana(t:_getMana(self))
		if self:getTalentLevel(t) >= 3 then
			self:setEffect(self.EFF_DEATH_RUSH, t:_getDur(self), {power=0.5})
		end
	end,
	callbackOnKill = function(self, t, target, death_note)
		t:_trigger(self)
	end,
	callbackOnSummonKill = function(self, t, minion, target, death_note)
		t:_trigger(self)
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Whenever a creature is killed by yourself or a minion you feast on its essence, gaining %0.1f mana.
		At level 3 the thrill of the death invigorates you, granting a movement speed bonus of 50%% for %d turns.]]):
		tformat(t.getMana(self, t), t.getDur(self, t))
	end,
}
