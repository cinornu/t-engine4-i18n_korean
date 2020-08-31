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
	name = "Soul Leech",
	type = {"spell/animus",1},
	require = spells_req1,
	points = 5,
	mode = "passive",
	autolearn_talent = "T_SOUL_POOL",
	no_unlearn_last = true,
	getTurns = function(self, t) return self:combatTalentLimit(t, 1, 10, 3) end,
	getTurnsByRank = function(self, t, target)
		local base = t.getTurns(self, t)
		if target.innate_player then return math.ceil(base), true -- Player is like a boss for NPCs
		elseif target.rank == 3.2 then return math.ceil(base * 3), true
		elseif target.rank == 3.5 then return math.ceil(base * 2.2), true
		elseif target.rank == 4 then return math.ceil(base * 1.3), true
		elseif target.rank == 5 then return math.ceil(base), true
		elseif target.rank >= 10 then return math.ceil(base / 2), true
		else return 20, false
		end
	end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 2, 8)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "max_soul", t.getNb(self, t))
	end,
	callbackOnDealDamage = function(self, t, val, target, dead, death_note)
		if target.necrotic_minion then return end
		if dead then
			t:_gainSoul(self, target, "death")
		else
			if target:hasEffect(target.EFF_SOUL_LEECH) or target == self or target == self.summoner then return end -- Dont reset, we want it to exprei to leech
			local turns, powerful = t.getTurnsByRank(self, t, target)
			target:setEffect(target.EFF_SOUL_LEECH, turns, {src=self, powerful=powerful})
		end
	end,
	gainSoul = function(self, t, src, mode)
		if mode == "death" then
			if src.turn_procs.soul_leeched_death then return end
			src.turn_procs.soul_leeched_death = true
		end
		local summoner = self:resolveSource()
		summoner:incSoul(1)
		summoner:triggerHook{"Necromancer:SoulLeech:GainSoul", src=src}
	end,
	info = function(self, t)
		local _, c_rare = self:textRank(3.2)
		local _, c_unique = self:textRank(3.5)
		local _, c_boss = self:textRank(4)
		local _, c_eboss = self:textRank(5)

		return ([[Each time you or your undead minions deal damage to a creature you apply Soul Leech to them.
		If a creature dies with this effect active, you steal its soul.
		Strong creatures and bosses are so overflowing with soul power that you steal a fragment of their soul every few turns:
		%s- rare: at most every %d turns
		%s- unique: at most every %d turns
		%s- boss: at most every %d turns
		%s- elite boss: at most every %d turns#WHITE#

		Also increases your maximum souls capacity by %d .
		]]):tformat(c_rare, t.getTurnsByRank(self, t, {rank=3.2}), c_unique, t.getTurnsByRank(self, t, {rank=3.5}), c_boss, t.getTurnsByRank(self, t, {rank=4}), c_eboss, t.getTurnsByRank(self, t, {rank=5}), t.getNb(self, t))
	end,
}

newTalent{
	name = "Consume Soul",
	type = {"spell/animus", 2},
	require = spells_req2,
	points = 5,
	soul = 1,
	cooldown = 15,
	getHeal = function(self, t) return 20 + self:combatTalentSpellDamage(t, 40, 450) end,
	getMana = function(self, t) return 10 + self:combatTalentSpellDamage(t, 40, 180) end,
	getSpellpower = function(self, t) return self:combatTalentScale(t, 15, 50) end,
	tactical = { MANA=1, HEAL=2, BUFF=function(self) return self.life < 1 and 2 or 0 end},
	action = function(self, t, p)
		if self.life < 1 then
			self:setEffect(self.EFF_CONSUME_SOUL, 10, {power=t.getSpellpower(self, t)})
		end
		self:attr("allow_on_heal", 1)
		self:heal(self:spellCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		self:incMana(t.getMana(self, t))
		return true
	end,	
	info = function(self, t)
		return ([[Consume a soul whole to rebuild your body, healing you for %d and generating %d mana.
		If used below 1 life the surge increases your spellpower by %d for 10 turns.
		The heal and mana increases with your Spellpower.]]):
		tformat(t.getHeal(self, t), t.getMana(self, t), t.getSpellpower(self, t))
	end,
}

newTalent{
	name = "Torture Souls",
	type = {"spell/animus", 3},
	require = spells_req3,
	points = 5,
	mana = 25,
	cooldown = 18,
	tactical = { ATTACKAREA = { COLD=1, DARK=1 }, SOUL=2 },
	radius = 10,
	range = 0,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 300) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local dam = self:spellCrit(t.getDamage(self, t))
		local nb = 0
		self:projectApply(self:getTalentTarget(t), self.x, self.y, Map.ACTOR, function(target)
			if not target:hasEffect(target.EFF_SOUL_LEECH) then return end
			if DamageType:get(DamageType.FROSTDUSK).projector(self, target.x, target.y, DamageType.FROSTDUSK, dam) > 0 then
				nb = nb + 1
			end
			game.level.map:particleEmitter(target.x, target.y, 1, "circle", {oversize=1.7, a=170, base_rot=0, limit_life=12, shader=true, appear=12, speed=0, img="torture_souls_aura", radius=0})
		end, "hostile")
		self:incSoul(math.min(nb, t.getNb(self, t)))
		return true
	end,
	info = function(self, t)
		return ([[Unleash dark forces to all foes in sight that are afflicted by Soul Leech, dealing %0.2f frostdusk damage to them and tearing apart their souls.
		This returns up to %d souls to you (one for each foe hit).
		The damage increases with your Spellpower.]]):
		tformat(damDesc(self, DamageType.FROSTDUSK, t.getDamage(self, t)), t.getNb(self, t))
	end,
}

newTalent{
	name = "Reaping",
	type = {"spell/animus",4},
	require = spells_req4,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_mana = 30,
	getMana = function(self, t) return math.floor(self:combatTalentScale(t, 5, 30)) / 10 end,
	getSpellpower = function(self, t) return math.floor(self:combatTalentScale(t, 10, 40)) end,
	getResists = function(self, t) return math.floor(self:combatTalentLimit(t, 20, 5, 10)) end,
	callbackOnAct = function(self, t)
		if not self.__old_reaping_souls then self.__old_reaping_souls = self:getSoul() end
		if self.__old_reaping_souls == self:getSoul() then return end
		self:updateTalentPassives(t)
	end,
	passives = function(self, t, p)
		if not self:isTalentActive(t.id) then return end
		local s = self:getSoul()
		if s >= 2 then self:talentTemporaryValue(p, "mana_regen", t.getMana(self, t)) end
		if s >= 5 then self:talentTemporaryValue(p, "combat_spellpower", t.getSpellpower(self, t)) end
		if s >= 8 then self:talentTemporaryValue(p, "resists", {all=t.getResists(self, t)}) end
	end,
	activate = function(self, t)
		local ret = {}
		game:onTickEnd(function() self:updateTalentPassives(t) end)

		if core.shader.active(4) then
			self:talentParticles(ret, {type="shader_shield", args={toback=true,  size_factor=1.2, img="reaping_shieldwall"}, shader={type="rotatingshield", noup=2.0, time_factor=500, appearTime=0.8}})
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1.2, img="reaping_shieldwall"}, shader={type="rotatingshield", noup=1.0, time_factor=500, appearTime=0.8}})
		end

		return ret
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[You draw constant power from the souls you hold within your grasp.
		If you hold at least 2, your mana regeneration is increased by %0.1f per turn.
		If you hold at least 5, your spellpower is increased by %d.
		If you hold at least 8, all your resistances are increased by %d.]]):
		tformat(t.getMana(self, t), t.getSpellpower(self, t), t.getResists(self, t))
	end,
}
