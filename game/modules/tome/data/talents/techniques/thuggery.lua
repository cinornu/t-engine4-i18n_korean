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
	name = "Skullcracker",
	type = {"technique/thuggery", 1},
	points = 5,
	cooldown = 12,
	stamina = 20,
	tactical = { DISABLE = { confusion = 2 }, ATTACK = { PHYSICAL = 1 } },
	require = techs_req1,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 3.2, 5.3)) end,
	getConfusion = function(self, t) return self:combatStatLimit("dex", 50, 25, 45) end, --Limit < 50%
	getDamage = function(self, t)
		local o = self:getInven(self.INVEN_HEAD) and self:getInven(self.INVEN_HEAD)[1]

		local add = 0
		if o then
			add = 15 + o:getPriceFlags() * 0.3 * math.sqrt(o:getPowerRank() + 1) * (o:attr("metallic") and 1 or 0.5) * (o.skullcracker_mult or 1)
		end

		local totstat = self:getStat("str")
		local talented_mod = math.sqrt((self:getTalentLevel(t) + (o and o.material_level or 1)) / 10) + 1
		local power = math.max(self.combat_dam + add, 1)
		power = (math.sqrt(power / 10) - 1) * 0.8 + 1
--		print(("[COMBAT HEAD DAMAGE] power(%f) totstat(%f) talent_mod(%f)"):tformat(power, totstat, talented_mod))
		return self:rescaleDamage(totstat / 1.5 * power * talented_mod)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local dam = t.getDamage(self, t)

		local _, hitted = self:attackTargetWith(target, nil, nil, nil, dam)

		if hitted then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, t.getDuration(self, t), {power=t.getConfusion(self, t), apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the headblow!", target:getName():capitalize())
			end
			if target:attr("dead") then
				world:gainAchievement("HEADBANG", self, target)
			end
		end
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		return ([[You smack your forehead against your enemy's head (or whatever sensitive part you can find), causing %0.1f Physical damage.
		If the attack hits, the target is confused (%d%% effect) for %d turns.
		Damage done increases with the quality of your headgear, your Strength, and your physical damage bonuses.
		Confusion power increases with your Dexterity, and chance increases with Accuracy.]]):
		tformat(dam, t.getConfusion(self, t), duration)
	end,
}

newTalent{
	name = "Riot-born",
	type = {"technique/thuggery", 2},
	mode = "passive",
	points = 5,
	require = techs_req2,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.5) end,
	passives = function(self, t, p)
		local immune = t.getImmune(self, t)
		self:talentTemporaryValue(p, "stun_immune", immune)
		self:talentTemporaryValue(p, "confusion_immune", immune)
	end,
	info = function(self, t)
		return ([[Your attunement to violence has given you %d%% resistance to stuns and confusion arising in battle.]]):
		tformat(t.getImmune(self, t)*100)
	end,
}
newTalent{
	name = "Vicious Strikes",
	type = {"technique/thuggery", 3},
	mode = "passive",
	points = 5,
	require = techs_req3,
	critpower = function(self, t) return self:combatTalentScale(t, 6, 25) end,
	getAPR = function(self, t) return self:combatTalentScale(t, 5, 20) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
		self:talentTemporaryValue(p, "combat_apr", t.getAPR(self, t))
	end,
	info = function(self, t)
		return ([[You know how to hit the right places, gaining +%d%% critical damage modifier and %d armour penetration.]]):
		tformat(t.critpower(self, t), t.getAPR(self, t))
	end,
}

newTalent{
	name = "Total Thuggery",
	type = {"technique/thuggery", 4},
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_stamina = 40,
	drain_stamina = 6,
	remove_on_zero = true,
	no_energy = true,
	require = techs_req4,
	range = 1,
	tactical = { BUFF = 2},
	on_pre_use_ai = function(self, t, silent, fake)
		if self.ai_state._advanced_ai then return true end -- let the advanced AI decide to use
		local is_active = self:isTalentActive(t.id)
		if is_active then -- may turn off without a LOS target or if stamina is not enough for at least 2 turns
			return not self.fov.actors[self.ai_target.actor] or self:getStamina() < -2*self.stamina_regen
		else -- may only turn on with a LOS target and stamina for 5 turns
			return self.fov.actors[self.ai_target.actor] and self:getStamina() >= -5*(self.stamina_regen-t.drain_stamina)
		end
	end,
	getCrit = function(self, t) return self:combatTalentStatDamage(t, "dex", 10, 50) / 1.5 end,
	getPen = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "str", 10, 50), 100, 0, 0, 35.7, 35.7) end, -- Limit to <100%
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.10, 0.20) end,
	deactivate_on = {no_combat=true, run=true, rest=true},
	activate = function(self, t)
		local ret = {
			crit = self:addTemporaryValue("combat_physcrit", t.getCrit(self, t)),
			pen = self:addTemporaryValue("resists_pen", {[DamageType.PHYSICAL] = t.getPen(self, t)}),
			speed = self:addTemporaryValue("combat_physspeed", t.getSpeed(self, t)),
		}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1.5, y=-0.2, img="total_thuggery_tentacles2"}, shader={type="tentacles", wobblingType=1, appearTime=0.5, time_factor=1400, noup=0.0}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("resists_pen", p.pen)
		return true
	end,
	info = function(self, t)
		return ([[You go all out, trying to burn down your foes as fast as possible.
		You gain +%d%% attack speed, +%d%% critical chance and +%d%% physical resistance penetration, but this talent drains 6 stamina each turn.
		This effect is disabled automatically on rest or run.
		]]):
		tformat(t.getSpeed(self,t)*100, t.getCrit(self, t), t.getPen(self, t))
	end,
}
