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
	name = "Call of the Mausoleum",
	type = {"spell/master-of-flesh",1},
	require = spells_req1,
	points = 5,
	fake_ressource = true,
	mana = 5,
	soul = function(self, t) return math.max(1, math.min(t.getNb(self, t), self:getSoul())) end,
	cooldown = 14,
	tactical = { ATTACK = 10 },
	requires_target = true,
	autolearn_talent = "T_SOUL_POOL",
	range = 0,
	minions_list = {
		ghoul = {
			type = "undead", subtype = "ghoul",
			display = "z",
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
			autolevel = "ghoul",
			level_range = {1, nil}, exp_worth = 0,
			ai = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
			stats = { str=14, dex=12, mag=10, con=12 },
			rank = 2,
			size_category = 3,
			infravision = 10,
			resolvers.racial(),
			resolvers.tmasteries{ ["technique/other"]=0.3, },
			open_door = true,
			blind_immune = 1,
			see_invisible = 2,
			undead = 1,
			name = "ghoul", color=colors.TAN,
			max_life = resolvers.rngavg(90,100),
			combat_armor = 2, combat_def = 7,
			resolvers.talents{
				T_STUN={base=1, every=10, max=5},
				T_BITE_POISON={base=1, every=10, max=5},
				T_ROTTING_DISEASE={base=1, every=10, max=5},
			},
			ai_state = { talent_in=4, },
			combat = { dam=resolvers.levelup(10, 1, 1), atk=resolvers.levelup(5, 1, 1), apr=3, dammod={str=0.6} },
			ghoul_minion = "ghoul", basic_ghoul_minion = true,
		},
		ghast = {
			type = "undead", subtype = "ghoul",
			display = "z",
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
			level_range = {1, nil}, exp_worth = 0,
			autolevel = "ghoul",
			ai = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
			stats = { str=14, dex=12, mag=10, con=12 },
			rank = 2,
			size_category = 3,
			infravision = 10,
			resolvers.racial(),
			resolvers.tmasteries{ ["technique/other"]=0.3, },
			open_door = true,
			blind_immune = 1,
			see_invisible = 2,
			undead = 1,
			name = "ghast", color=colors.UMBER,
			max_life = resolvers.rngavg(90,100),
			combat_armor = 2, combat_def = 7,
			resolvers.talents{
				T_STUN={base=1, every=10, max=5},
				T_BITE_POISON={base=1, every=10, max=5},
				T_ROTTING_DISEASE={base=1, every=10, max=5},
			},
			ai_state = { talent_in=4, },
			combat = { dam=resolvers.levelup(10, 1, 1), atk=resolvers.levelup(5, 1, 1), apr=3, dammod={str=0.6} },
			ghoul_minion = "ghast",
		},
		ghoulking = {
			type = "undead", subtype = "ghoul",
			display = "z",
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
			level_range = {1, nil}, exp_worth = 0,
			autolevel = "ghoul",
			ai = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
			stats = { str=14, dex=12, mag=10, con=12 },
			rank = 2,
			size_category = 3,
			infravision = 10,
			resolvers.racial(),
			resolvers.tmasteries{ ["technique/other"]=0.3, },
			open_door = true,
			blind_immune = 1,
			see_invisible = 2,
			undead = 1,
			name = "ghoulking", color={0,0,0},
			max_life = resolvers.rngavg(90,100),
			combat_armor = 3, combat_def = 10,
			ai_state = { talent_in=2, ai_pause=20 },
			rank = 3,
			combat = { dam=resolvers.levelup(30, 1, 1.2), atk=resolvers.levelup(8, 1, 1), apr=4, dammod={str=0.6} },
			resolvers.talents{
				T_STUN={base=3, every=9, max=7},
				T_BITE_POISON={base=3, every=9, max=7},
				T_ROTTING_DISEASE={base=4, every=9, max=7},
				T_DECREPITUDE_DISEASE={base=3, every=9, max=7},
				T_WEAKNESS_DISEASE={base=3, every=9, max=7},
			},
			ghoul_minion = "ghoulking",
		},
	},
	radius = function(self, t) return self:getTalentRadius(self:getTalentFromId(self.T_NECROTIC_AURA)) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	getNb = function(self, t, ignore)
		local nb = math.max(1, math.floor(self:combatTalentScale(t, 1, 5)))
		if nb > 6 then nb = math.floor(6 + (nb - 6) ^ 0.7) end
		return nb
	end,
	getEvery = function(self, t, ignore) return math.floor(self:combatTalentLimit(t, 10, 30, 12)) end,
	getTurns = function(self, t, ignore) return math.floor(self:combatTalentScale(t, 5, 10)) end,
	getLevel = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), -6, 0.9, 2, 5)) end, -- -6 @ 1, +2 @ 5, +5 @ 8
	on_pre_use = function(self, t) return self:getTalentLevel(t) >= 3 and self:getSoul() >= 1 end,
	-- Fucking respec.
	on_levelup_changed = function(self, t, lvl, old_lvl, lvl_raw, old_lvl_raw)
		local stats = necroArmyStats(self)
		for i, minion in ipairs(stats.list) do if minion.ghoul_minion then
			if self:getTalentLevel(t) < 3 and not minion.basic_ghoul_minion then
				game.party:removeMember(minion, true)
				minion:disappear(self)
			elseif self:getTalentLevel(t) < 5 and minion.ghoul_minion == "ghoulking" then
				game.party:removeMember(minion, true)
				minion:disappear(self)
			end
		end end
	end,
	summonGhoul = function(self, t, possible_spots, def)
		local pos = table.remove(possible_spots, 1)
		if pos then
			necroSetupSummon(self, def, pos.x, pos.y, t.getLevel(self, t), t:_getTurns(self), true)
			self.__call_mausoleum_count = (self.__call_mausoleum_count or 0) + 1
			if self.__call_mausoleum_count == 4 then
				self.__call_mausoleum_count = 0
				if self:getTalentLevel(t) >= 5 then
					local pos = table.remove(possible_spots, 1)
					if pos then necroSetupSummon(self, t.minions_list.ghoulking, pos.x, pos.y, t.getLevel(self, t), t:_getTurns(self), true) end
				end
			end
			return true
		end
		return false
	end,
	callbackOnCombat = function(self, t, state)
		if self.__call_mausoleum_active ~= state and state == true then
			local tg = self:getTalentTarget(t)
			local possible_spots = {}
			self:project(tg, self.x, self.y, function(px, py)
				if not game.level.map:checkAllEntities(px, py, "block_move") then
					possible_spots[#possible_spots+1] = {x=px, y=py, dist=core.fov.distance(self.x, self.y, px, py)}
				end
			end)
			if #possible_spots >= 1 then
				table.sort(possible_spots, "dist")
				t:_summonGhoul(self, possible_spots, t.minions_list.ghoul)
			end
			self.__call_mausoleum_turns = 0
		end
		self.__call_mausoleum_active = state
	end,
	callbackOnActBase = function(self, t)
		if not self.__call_mausoleum_active then return end
		self.__call_mausoleum_turns = self.__call_mausoleum_turns + 1
		if self.__call_mausoleum_turns >= t:_getEvery(self) then
			local tg = self:getTalentTarget(t)
			local possible_spots = {}
			self:project(tg, self.x, self.y, function(px, py)
				if not game.level.map:checkAllEntities(px, py, "block_move") then
					possible_spots[#possible_spots+1] = {x=px, y=py, dist=core.fov.distance(self.x, self.y, px, py)}
				end
			end)
			if #possible_spots >= 1 then
				table.sort(possible_spots, "dist")
				t:_summonGhoul(self, possible_spots, t.minions_list.ghoul)
			end
			self.__call_mausoleum_turns = 0
		end
	end,
	action = function(self, t)
		if self:getTalentLevel(t) < 3 then return end
		local nb = t:_getNb(self)
		nb = math.min(nb, self:getSoul())
		if nb < 1 then return end
		local lev = t.getLevel(self, t)

		local tg = self:getTalentTarget(t)
		local possible_spots = {}
		self:project(tg, self.x, self.y, function(px, py)
			if not game.level.map:checkAllEntities(px, py, "block_move") then
				possible_spots[#possible_spots+1] = {x=px, y=py, dist=core.fov.distance(self.x, self.y, px, py)}
			end
		end)
		if #possible_spots == 0 then return end
		table.sort(possible_spots, "dist")

		local use_ressource = not self:attr("zero_resource_cost") and not self:attr("force_talent_ignore_ressources")
		for i = 1, nb do
			if t:_summonGhoul(self, possible_spots, t.minions_list.ghast) and use_ressource then
				self:incSoul(-1)
			end
		end

		if use_ressource then self:incMana(-util.getval(t.mana, self, t) * (100 + 2 * self:combatFatigue()) / 100) end
		game:playSoundNear(self, "talents/ghoul")
		return true
	end,
	info = function(self, t)
		local when = ""

		if self.__call_mausoleum_active then
			when = ("\n#DARK_SEA_GREEN#Next free ghoul in %d turn(s).\n#LAST#"):tformat(t:_getEvery(self) - self.__call_mausoleum_turns)
		end

		return ([[You control dead matter around you, lyring in the ground, decaying.
		When you enter combat and every %d turns thereafter a ghoul of level %d automatically raises to fight for you.
		At level 3 you can forcefully activate this spell to summon up to %d ghasts around you.
		At level 5 every 4 summoned ghouls or ghasts a ghoulking is summoned for free.
		Ghouls, ghasts and ghoulkings last for %d turns.
		%s
		#GREY##{italic}#Ghoul minions come in larger numbers than skeleton minions but are generally more frail and disposable.#{normal}#
		]]):tformat(t:_getEvery(self), math.max(1, self.level + t:_getLevel(self)), t:_getNb(self), t:_getTurns(self), when)
	end,
}

newTalent{
	name = "Corpse Explosion",
	type = {"spell/master-of-flesh",2},
	require = spells_req2,
	points = 5,
	cooldown = 20,
	mana = 30,
	tactical = { ATTACKAREA = {COLD=2, DARKNESS=2} },
	requires_target = true,
	radius = 2,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 8)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 200) end,
	getDiseasePower = function(self, t) return self:combatTalentSpellDamage(t, 5, 28) end,
	on_pre_use = function(self, t) local stats = necroArmyStats(self) return stats.nb_ghoul > 0 end,
	action = function(self, t)
		self:setEffect(self.EFF_CORPSE_EXPLOSION, t:_getDur(self), {damage=t:_getDamage(self), disease=t:_getDiseasePower(self), radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[Ghouls are nothing but mere tools to you, for %d turns you render them bloated with dark forces.
		Anytime a ghoul or ghast is hit it will explode in a messy splash of gore, dealing %0.2f frostdusk damage to all foes in radius %d of it.
		Any creature caught in the blast also receives a random disease that deals %0.2f blight damage over 6 turns and reduces one attribute by %d.
		Only one ghoul may explode per turn. The one with the least time left to live is always the first to do so.
		The damage and disease power is increased by your Spellpower.
		]]):
		tformat(t:_getDur(self), damDesc(self, DamageType.FROSTDUSK, t:_getDamage(self)), self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t:_getDamage(self)), t:_getDiseasePower(self))
	end,
}

newTalent{
	name = "Putrescent Liquefaction",
	type = {"spell/master-of-flesh", 3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	mana = 20, -- This is NOT an error, this is a sustain but with an activation cost
	soul = 1,
	cooldown = 10,
	tactical = { ATTACKAREA = {COLD=2, DARKNESS=2} },
	requires_target = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	target = function(self, t) return {type="ball", range=0, radius=self:getTalentRadius(t), talent=t, friendlyfire=false} end,
	getNb = function(self, t) return math.max(1, math.floor(self:combatTalentLimit(t, 3.1, 1, 3))) end,
	getIncrease = function(self, t) return math.floor(self:combatTalentScale(t, 1, 2)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 400) / 5 end,
	on_pre_use = function(self, t) return necroArmyStats(self).nb_ghoul > 0 end,
	iconOverlay = function(self, t, p)
		local val = p.dur
		if val <= 0 then return "" end
		return tostring(math.ceil(val)), "buff_font_small"
	end,
	endEffect = function(self, t, final)
		local p = self:isTalentActive(t.id)
		if not p then return end
		game.level.map:removeEffect(p.effect)
		if not final then
			self:forceUseTalent(t.id, {ignore_energy=true})
		end
	end,
	callbackOnChangeLevel = function(self, t, what)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if what ~= "leave" then return end

		t:_endEffect(self)
	end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end

		p.dur = p.dur - 1
		if p.dur == 0 then
			t:_endEffect(self)
		end
	end,
	absorbGhoul = function(self, t, src)
		local p = self:isTalentActive(self.T_PUTRESCENT_LIQUEFACTION)
		p.dur = p.dur + self:callTalent(self.T_PUTRESCENT_LIQUEFACTION, "getIncrease")
		game.level.map:particleEmitter(src.x, src.y, 1, "pustulent_fulmination", {radius=1})
		game.logSeen(src, "#GREY#%s dissolves into the cloud of gore.", src:getName():capitalize())

		p.absorb_cnt = p.absorb_cnt + 1
		if p.absorb_cnt >= 2 then
			self:incSoul(1)
			p.absorb_cnt = 0
		end
	end,
	activate = function(self, t)
		local list = {}
		local stats = necroArmyStats(self)
		for _, m in ipairs(stats.list) do if m.ghoul_minion then list[#list+1] = m end end
		table.sort(list, function(a, b) return a.creation_turn < b.creation_turn end)

		local dur = 0
		for i = 1, t:_getNb(self) do
			if #list == 0 then break end
			local m = table.remove(list, 1)
			m:die(self)
			dur = dur + 3
		end
		if dur == 0 then return nil end

		local ret = { dur = dur + 1, absorb_cnt = 0 }

		-- Add a lasting map effect
		local radius = self:getTalentRadius(t)
		ret.effect = game.level.map:addEffect(self,
			self.x, self.y, 10, -- Duration is fake, its handled by the sustain
			DamageType.PUTRESCENT_LIQUEFACTION, t.getDamage(self, t),
			radius,
			5, nil,
			{stack={
				{type="putrescent_liquefaction", args={radius=radius, img=1}, zdepth=3},
				{type="putrescent_liquefaction", args={radius=radius, img=2}, zdepth=3},
				{type="putrescent_liquefaction", args={radius=radius, img=3}, zdepth=3},
				{type="putrescent_liquefaction", args={radius=radius, img=4}, zdepth=3},
				{type="putrescent_liquefaction", args={radius=radius, img=5}, zdepth=3},
			}},
			function(e)
				if e.src.dead then return end
				e.x = e.src.x
				e.y = e.src.y
				e.duration = 10 -- Duration is fake, its handled by the sustain
				return true
			end,
			false, false
		)

		return ret
	end,
	deactivate = function(self, t, p)
		t:_endEffect(self, true)
		return true
	end,
	info = function(self, t)
		return ([[Shattering up to %d ghouls or ghasts you create a putrescent swirling cloud of radius %d that follows you around for 3 turns per dead ghoul plus one turn. Oldest ghouls are prioritized for destruction.
		Any ghoul or ghast dying or expiring within this cloud increases its duration by %d turn and every two absorbed ghoul/ghast your gain back one soul.
		The cloud deals %0.2f frostdusk damage to any foes caught inside.
		The damage will increase with your Spellpower.
		]]):tformat(t:_getNb(self), self:getTalentRadius(t), t:_getIncrease(self), damDesc(self, DamageType.FROSTDUSK, t:_getDamage(self)))
	end,
}

newTalent{
	name = "Discarded Refuse",
	type = {"spell/master-of-flesh", 4},
	require = spells_req4,
	points = 5,
	mode = "sustained",
	mana = 40,
	soul = 1,
	cooldown = 30,
	tactical = { CURE = 1 },
	range = 10,
	no_energy = true,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 6)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	callbackOnTemporaryEffect = function(self, t, eff_id, e, p)
		if e.status ~= "detrimental" then return end
		if self.life < 1 then
			if e.type == "other" then return end
		else
			if e.type ~= "physical" then return end
		end
		local stats = necroArmyStats(self)
		if stats.nb_ghoul == 0 then return end

		local nb = self.turn_procs.discarded_refuse or 0
		if nb > t:_getNb(self) then return end
		self.turn_procs.discarded_refuse = nb + 1

		local list = {}
		for _, m in ipairs(stats.list) do if m.ghoul_minion then list[#list+1] = m end end
		local m = rng.table(list)
		game.logSeen(self, "%s sacrifices a ghoul to avoid being affected by %s!", self:getName():capitalize(), self:getEffectFromId(eff_id).desc)
		m:die(self)		
		return true
	end,
	activate = function(self, t)
		local ret = {}
		return ret
	end,	
	deactivate = function(self, t, p)
		return true
	end,	
	info = function(self, t)
		return ([[Whenever you would be affected by a detrimental physical effect you instead transfer it instantly to one of your ghouls.
		The ghoul dies from the process.
		While under 1 life it also affects magical and mental effects.
		At most %d effects can be affected per turn.
		Cross-tier effects are never affected.]]):
		tformat(t:_getNb(self))
	end,
}
