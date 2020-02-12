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
	name = "Stoneshield",
	type = {"wild-gift/earthen-power", 1},
	mode = "passive",
	require = gifts_req1,
	points = 5,
	no_unlearn_last = true,
	on_learn = function(self, t)
		self:attr("show_shield_combat", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("show_shield_combat", -1)
	end,
	getValues = function(self, t)
		return
			self:combatTalentLimit(t, 1, 0.07, 0.15),
			self:combatTalentScale(t, 6, 10),
			self:combatTalentLimit(t, 0.5, 0.067, 0.185),
			self:combatTalentScale(t, 5, 9, "log")
	end,
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	info = function(self, t)
		local m, mm, e, em = t.getValues(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[The first time you take damage each turn, you regenerate %d%% of the damage dealt as mana (up to a maximum of %0.2f) and %d%% as equilibrium (up to %0.2f).
		Increases Physical Power by %d, increases damage done with shields by %d%%, and allows you to dual-wield shields.
		Also, all of your melee attacks will perform a shield bash in addition to their normal effects.]]):tformat(100 * m, mm, 100 * e, em, damage, inc*100)
	end,
}

newTalent{
	name = "Stone Fortress",
	type = {"wild-gift/earthen-power", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
--	getPercent = function(self, t) return self:combatTalentLimit(t, 200, 60, 100) end, -- base damage version Limit < 200%
	getPercent = function(self, t) return self:combatTalentScale(t, 60, 100, "log") end,
	ReduceDamage = function(self, t, dam, src) -- unused: called by default projector in data.damage_types.lua
		local effArmor = self:combatArmor()*t.getPercent(self, t)/100
		-- Apply attacker base APR (but not for melee attacks which apply it separately) 
		if not (src.turn_procs and src.turn_procs.weapon_type) and src.combatAPR then effArmor = effArmor - src:combatAPR() end
		return math.max(0, dam - effArmor)
	end,
	info = function(self, t)
		return ([[When you use your Resilience of the Dwarves racial power your skin becomes so tough that it even absorbs damage from non-physical attacks.
		Non-physical damage is reduced by %d%% of your total armour value (ignoring hardiness).]]):
		tformat(t.getPercent(self, t))
	end,
}

newTalent{
	name = "Shards",
	type = {"wild-gift/earthen-power", 3},
	require = gifts_req3,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 15,
	cooldown = 30,
	tactical = { BUFF = 2 },
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Sharp shards of stone grow from your shields.
		When you are hit in melee, you will get a free attack against the attacker with the shards doing %d%% shield damage (as Nature).
		This effect can only happen once per turn.]]):
		tformat(self:combatTalentWeaponDamage(t, 0.4, 1) * 100)
	end,
}

newTalent{
	name = "Eldritch Stone",
	type = {"wild-gift/earthen-power", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 10,
	cooldown = 20,
	tactical = { DEFEND = 2, EQUILIBRIUM=1, MANA=1 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	getPower = function(self, t) return 70 + self:combatTalentStatDamage(t, "wil", 5, 400) end,
	manaRegen = function(self, t) return self:combatTalentScale(t, 0.25, 1, 0.75) end,
	maxDamage = function(self, t) return self:combatTalentScale(t, 150, 500) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "mana_regen_on_rest", t.manaRegen(self, t))
	end,
	action = function(self, t)
		self:setEffect(self.EFF_ELDRITCH_STONE, 7, {power=t.getPower(self, t), radius=self:getTalentRadius(t), maxdam = t.maxDamage(self, t)})
		game:playSoundNear(self, "talents/stone")
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a shield of impenetrable stone around you for 7 turns, absorbing up to %d damage.
		Your equilibrium will increase by twice the damage absorbed.
		When the effect ends, all equilibrium above minimum will be converted to mana in a storm of arcane energy and the cooldown of your Block is reset.
		The storm inflicts Arcane damage equal to the converted equilibrium (maximum %d) against everyone around you in a radius %d.
		Also while resting you will passively regenerate %0.2f mana each turn.
		The shield strength will increase with Willpower]]):tformat(power, t.maxDamage(self, t), radius, t.manaRegen(self, t))
	end,
}
