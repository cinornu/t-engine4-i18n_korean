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
	name = "Drain",
	type = {"corruption/sanguisuge", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 5,
	reflectable = true,
	proj_speed = 15,
	tactical = { ATTACK = {BLIGHT = 1.75},
		VIM = {BLIGHT = function(self, t, target) return 2*target:getRankVimAdjust()^.5 end}
	},
	requires_target = true,
	range = function(self, t) return math.min(10, math.floor(self:combatTalentScale(t, 6, 10))) end,
	action = function(self, t)
		local tg = {type="bolt", friendlyblock=false, range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DRAIN_VIM, self:spellCrit(self:combatTalentSpellDamage(t, 25, 200)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[Fires a bolt of blight, doing %0.2f blight damage and replenishing 20%% of it as vim energy.
		The amount of vim regained depends on the target's rank (higher ranks give more vim).
		The effect will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 25, 200)))
	end,
}

newTalent{
	name = "Bloodcasting",
	type = {"corruption/sanguisuge", 2},
	require = corrs_req2,
	points = 5,
	mode = "passive",
	no_npc_use = true,
	getLifeCost = function(self, t) return math.floor(self:combatTalentScale(t, 180, 100)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "bloodcasting", t.getLifeCost(self, t))
	end,
	info = function(self, t)
		return ([[The cost of using life instead of vim for talents is reduced to %d%%.]]):
		tformat(t.getLifeCost(self,t))
	end,
}

newTalent{
	name = "Absorb Life",
	type = {"corruption/sanguisuge", 3},
	mode = "sustained",
	require = corrs_req3,
	points = 5,
	sustain_vim = 5,
	cooldown = 30,
	range = 10,
	no_energy = true,
	tactical = { BUFF = 2 },
	VimOnDeath = function(self, t) return self:combatTalentScale(t, 6, 16) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			vim_regen = self:addTemporaryValue("vim_regen", -0.5),
			vim_on_death = self:addTemporaryValue("vim_on_death", t.VimOnDeath(self, t)),
		}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1.5, img="absorb_life_tentacles_wings"}, shader={type="tentacles", appearTime=0.6, time_factor=1000, noup=0.0}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("vim_regen", p.vim_regen)
		self:removeTemporaryValue("vim_on_death", p.vim_on_death)
		return true
	end,
	info = function(self, t)
		return ([[Absorbs the life force of your foes as you kill them.
		As long as this talent is active, vim will decrease by 0.5 per turn and increase by %0.1f for each kill of a non-undead creature (in addition to the usual increase based on Willpower).]]):
		tformat(t.VimOnDeath(self, t))
	end,
}

newTalent{
	name = "Life Tap",
	type = {"corruption/sanguisuge", 4},
	require = corrs_req4,
	points = 5,
	vim = 40,
	cooldown = 20,
	no_energy = true,
	tactical = { HEAL = 2 },
	getMult = function(self,t) return self:combatTalentSpellDamage(t, 4, 30) end,
	action = function(self, t)
		self:setEffect(self.EFF_LIFE_TAP, 2, {power=t.getMult(self,t)})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[Feed on the pain you cause your foes.
			For 2 turns you gain %d%% lifesteal on all damage dealt.
			The lifesteal will increase with your Spellpower.]]):
		tformat(t.getMult(self,t))
	end,
}
