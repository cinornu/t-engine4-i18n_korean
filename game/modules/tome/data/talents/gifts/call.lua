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
	name = "Meditation",
	type = {"wild-gift/call", 1},
	require = gifts_req1,
	points = 5,
	message = function(self, t) return self.sustain_talents[t.id] and _t"@Source@ interrupts @hisher@ #GREEN#meditation#LAST#." or _t"@Source@ #GREEN#meditates#LAST# on nature." end,
	mode = "sustained",
	cooldown = 20,
	range = 10,
	no_energy = true,
	no_npc_use = true, -- It is almost never a good idea for resource cheating NPCs to use this but they often do with this tactical table does
	tactical = {EQUILIBRIUM = 2, HEAL = 0.1, BUFF = -3,
		SPECIAL = function(self, t) return self.ai_target.actor and -2 or 0 end -- offsets minimal equilibrium and healing tactics while in combat
	},
	drain_equilibrium = function(self, t)
		local boost = 1 + (self.enhance_meditate or 0)
		return -(2 + self:combatTalentMindDamage(t, 20, 120) / 10) * boost
	end,
	on_pre_use_ai = function(self, t, silent, fake)
		if self.ai_state._advanced_ai then return true end -- let the advanced AI decide to use
		local equil, _, chance = self:getEquilibrium(), self:equilibriumChance()
		local aitarget = self.ai_target.actor and not self.ai_target.actor.dead
		local is_active = self:isTalentActive(t.id)
		if self:isTalentActive(t.id) then
			return rng.percent(chance + (not aitarget and self.min_equilibrium - equil or 0)*5)
		else
			return not aitarget and equil > self.min_equilibrium or rng.percent(2*(100 - chance))
		end
	end,
	restingRegen = function(self, t) return self:combatTalentScale(t, 0.5, 2.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "equilibrium_regen_on_rest", -t.restingRegen(self, t))
	end,
	activate = function(self, t)
		local ret = {}

		local boost = 1 + (self.enhance_meditate or 0)

		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost

		if self:knowTalent(self.T_EARTH_S_EYES) then
			local te = self:getTalentFromId(self.T_EARTH_S_EYES)
			self:talentTemporaryValue(ret, "esp_all", 1)
			self:talentTemporaryValue(ret, "esp_range", te.radius_esp(self, te) - 10)
		end

		game:playSoundNear(self, "talents/heal")
		self:talentTemporaryValue(ret, "combat_mentalresist", save)
		self:talentTemporaryValue(ret, "healing_factor", heal / 100)
		self:talentTemporaryValue(ret, "numbed", 50)
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local boost = 1 + (self.enhance_meditate or 0)
		local pt = -t.drain_equilibrium(self, t)
		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
		local rest = t.restingRegen(self, t)
		return ([[Meditate on your link with Nature.
		While meditating, your equilibrium decreases by %0.2f per turn, your Mental Save is increased by %d, and your healing factor increases by %d%%.
		Your deep meditation does not let you deal damage correctly, reducing the damage you and your summons deal by 50%%.
		Also, any time you are resting (even with Meditation not sustained) you enter a simple meditative state that decreases your equilibrium by %0.2f per turn.
		The activated effects increase with your Mindpower.]]):
		tformat(pt, save, heal, rest)
	end,
}

newTalent{ short_name = "NATURE_TOUCH",
	name = "Nature's Touch",
	type = {"wild-gift/call", 2},
	require = gifts_req2,
	random_ego = "defensive",
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	range = 1,
	onAIGetTarget = function(self, t) -- find target to heal (prefers self, usually, doesn't consider Solipsism)
		local target
		local heal, bestheal = t.getHeal(self, t), 0
		if not self:attr("undead") and self.max_life - self.life > 0 then -- check self
			target = self
			bestheal = math.min(self.max_life - self.life, heal*self.healing_factor)*(self.ai_state.self_compassion or 5)
		end
		local adjacents = util.adjacentCoords(self.x, self.y)
		local act
		for dir, coords in pairs(adjacents) do -- check for nearby allies
			act = game.level.map(coords[1], coords[2], Map.ACTOR)
		--if act then game.log("heal...found actor %s at (%d, %d)", act.name, act.x, act.y) end
			if act and self:reactionToward(act) > 0 and not act:attr("undead") then
				local effectheal = math.min(act.max_life - act.life, heal*act.healing_factor)*(self.ai_state.ally_compassion or 1)
				if effectheal > bestheal then
					target, bestheal = act, effectheal
				end
			end
		end
		if target and bestheal > 0 then
			return target.x, target.y, target
		end
	end,
	on_pre_use_ai = function(self, t, silent) return t.onAIGetTarget(self, t) and true or false end,
	getHeal = function(self, t) return 20 + self:combatTalentMindDamage(t, 20, 500) end,
	tactical = { HEAL = function(self, t, target)
		return not target:attr("undead") and 2*(target.healing_factor or 1) or 0 
	end},
	is_heal = true,
	target = function(self, t) return {talent = t, default_target=self, type="hit", nowarning=true, range=self:getTalentRange(t), first_target="friend"} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		if not target:attr("undead") then
			target:attr("allow_on_heal", 1)
			target:heal(self:mindCrit(t.getHeal(self, t)), self)
			target:attr("allow_on_heal", -1)
			if core.shader.active(4) then
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[Touch a target (or yourself) to infuse it with Nature, healing it for %d (this heal does not work on undead).
		The amount healed will increase with your Mindpower.]]):
		tformat(t.getHeal(self, t))
	end,
}

newTalent{
	name = "Earth's Eyes",
	type = {"wild-gift/call", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "utility",
	equilibrium = 3,
	cooldown = 10,
	radius = function(self, t) return math.ceil(self:combatTalentScale(t, 6.1, 11.5)) end,
	radius_esp = function(self, t) return math.floor(self:combatTalentScale(t, 3.5, 5.5)) end,
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		self:magicMap(self:getTalentRadius(t), self.x, self.y)
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local radius_esp = t.radius_esp(self, t)
		return ([[Using your connection to Nature, you can see your surrounding area in a radius of %d.
		Also, while meditating, you are able to detect the presence of creatures around you in a radius of %d.]]):
		tformat(radius, radius_esp)
	end,
}

newTalent{
	name = "Nature's Balance",
	type = {"wild-gift/call", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 20,
	cooldown = 50,
	range = 10,
	tactical = { BUFF = 2 },
	fixed_cooldown = true,
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return self:getTalentLevel(t) end,
	action = function(self, t)
		local nb = t.getTalentCount(self, t)
		local maxlev = t.getMaxLevel(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if not tt.fixed_cooldown then
				if tt.type[2] <= maxlev and tt.type[1]:find("^wild%-gift/") then
					tids[#tids+1] = tid
				end
			end
		end
		for i = 1, nb do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self.changed = true
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[Your deep link with Nature allows you to reset the cooldown of %d of your wild gifts of tier %d or less.]]):
		tformat(t.getTalentCount(self, t), t.getMaxLevel(self, t))
	end,
}
