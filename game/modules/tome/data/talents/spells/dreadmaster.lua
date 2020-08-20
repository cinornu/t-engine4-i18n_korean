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
	name = "Dread",
	type = {"spell/dreadmaster",1},
	require = spells_req1,
	points = 5,
	mana = 20,
	soul = 4,
	cooldown = 40,
	tactical = { ATTACK = {DARKNESS=1}, DISABLE = 5 },
	requires_target = true,
	autolearn_talent = "T_SOUL_POOL",
	range = 10,
	minions_list = {
		dread = {
			type = "undead", subtype = "ghost",
			name = "dread", blood_color = colors.GREY,
			display = "G", color=colors.ORANGE, image="npc/dread.png",
			combat = {dam=resolvers.mbonus(45, 45), atk=resolvers.mbonus(25, 45), apr=100, dammod={str=0.5, mag=0.5}, sound={"creatures/ghost/attack%d", 1, 2}},
			sound_moam = {"creatures/ghost/on_hit%d", 1, 2},
			sound_die = {"creatures/ghost/death%d", 1, 1},
			sound_random = {"creatures/ghost/random%d", 1, 1},
			level_range = {1, nil}, exp_worth = 0,
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			autolevel = "wisecaster",
			ai = "dumb_talented_simple", ai_state = { ai_target="target_closest", ai_move="move_complex", talent_in=2, },
			dont_pass_target = true,
			stats = { str=14, dex=18, mag=20, con=12 },
			rank = 2,
			size_category = 3,
			infravision = 10,
			mana_regen = 5,
			vim_regen = 5,
			stealth = resolvers.mbonus(40, 10),

			can_pass = {pass_wall=70},
			resists = {all = 35, [DamageType.LIGHT] = -70, [DamageType.DARKNESS] = 65},

			no_breath = 1,
			stone_immune = 1,
			confusion_immune = 1,
			fear_immune = 1,
			teleport_immune = 0.5,
			disease_immune = 1,
			poison_immune = 1,
			stun_immune = 1,
			blind_immune = 1,
			cut_immune = 1,
			see_invisible = 80,
			undead = 1,
			avoid_pressure_traps = 1,
			resolvers.sustains_at_birth(),
			dread_minion = "dread",
			no_boneyard_resurrect = true,

			resolvers.talents{
				T_BURNING_HEX={base=1, every=5},
				T_EMPATHIC_HEX={base=0, last=10, every=5},
				T_PACIFICATION_HEX={base=0, last=15, every=5},
				T_BLUR_SIGHT={base=3, every=5},
				T_PHASE_DOOR={base=1, every=6},
			},
			max_life = resolvers.rngavg(90,100),
		},
		dreadmaster = {
			type = "undead", subtype = "ghost",
			name = "dreadmaster", blood_color = colors.GREY,
			display = "G", color=colors.YELLOW, image="npc/dreadmaster.png",
			combat = {dam=resolvers.mbonus(45, 45), atk=resolvers.mbonus(25, 45), apr=100, dammod={str=0.5, mag=0.5}, sound={"creatures/ghost/attack%d", 1, 2}},
			sound_moam = {"creatures/ghost/on_hit%d", 1, 2},
			sound_die = {"creatures/ghost/death%d", 1, 1},
			sound_random = {"creatures/ghost/random%d", 1, 1},
			level_range = {1, nil}, exp_worth = 0,
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			autolevel = "wisecaster",
			ai = "dumb_talented_simple", ai_state = { ai_target="target_closest", ai_move="move_complex", talent_in=2, },
			dont_pass_target = true,
			stats = { str=14, dex=18, mag=20, con=12 },
			rank = 2,
			size_category = 3,
			infravision = 10,
			mana_regen = 5,
			vim_regen = 5,
			stealth = resolvers.mbonus(30, 20),

			can_pass = {pass_wall=70},
			resists = {all = 35, [DamageType.LIGHT] = -70, [DamageType.DARKNESS] = 65},

			no_breath = 1,
			stone_immune = 1,
			confusion_immune = 1,
			fear_immune = 1,
			teleport_immune = 0.5,
			disease_immune = 1,
			poison_immune = 1,
			stun_immune = 1,
			blind_immune = 1,
			cut_immune = 1,
			see_invisible = 80,
			undead = 1,
			avoid_pressure_traps = 1,
			resolvers.sustains_at_birth(),
			dread_minion = "dread",
			no_boneyard_resurrect = true,

			resolvers.talents{
				T_BURNING_HEX={base=1, every=5},
				T_EMPATHIC_HEX={base=0, last=10, every=5},
				T_PACIFICATION_HEX={base=0, last=15, every=5},
				T_BLUR_SIGHT={base=3, every=5},
				T_PHASE_DOOR={base=1, every=6},
				-- Dreadmaster talents are learnt after summoning
			},
			max_life = resolvers.rngavg(140,170),
		},
	},
	getLevel = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), -6, 0.9, 2, 5)) end, -- -6 @ 1, +2 @ 5, +5 @ 8
	on_pre_use = function(self, t) return not necroArmyStats(self).dread end,
	action = function(self, t)
		local lev = t.getLevel(self, t)

		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then return end
		local dread = necroSetupSummon(self, self:knowTalent(self.T_DREADMASTER) and t.minions_list.dreadmaster or t.minions_list.dread, x, y, lev, nil, true)
		if self:knowTalent(self.T_DREADMASTER) then
			local lvl = math.floor(self:getTalentLevel(self.T_DREADMASTER))
			dread:learnTalent(dread.T_SILENCE, true, lvl)
			dread:learnTalent(dread.T_MIND_DISRUPTION, true, lvl)
			dread:learnTalent(dread.T_DISPERSE_MAGIC, true, lvl)
		end
		game:playSoundNear(self, "creatures/ghost/random1")
		return true
	end,
	info = function(self, t)
		return ([[Summon a Dread of level %d that will annoyingly blink around, hexing your foes.
		]]):tformat(math.max(1, self.level + t:_getLevel(self)))
	end,
}

newTalent{
	name = "Souleater",
	type = {"spell/dreadmaster",2},
	require = spells_req2,
	points = 5,
	mode = "passive",
	getHeal = function(self, t) return 10 + self:combatTalentSpellDamage(t, 30, 200) end,
	getCD = function(self, t) return math.floor(self:combatTalentScale(t, 1, 4)) end,
	getFoes = function(self, t) return math.floor(self:combatTalentScale(t, 2, 8)) end,
	callbackOnSummonDeath = function(self, t, summon, src, death_note)
		if summon.summoner ~= self or not summon.necrotic_minion then return end
		local dread = necroArmyStats(self).dread
		if not dread then return end

		dread:heal(t:_getHeal(self), dread)
		for tid, _ in pairs(dread.talents) do dread:alterTalentCoolingdown(tid, -t:_getCD(self)) end

		dread.__souleater_count = (dread.__souleater_count or 0) + 1
		if dread.__souleater_count < 10 then return end
		dread.__souleater_count = 0
		game.logSeen(summon, "#GREY#%s has fed on enough minions and starts to randomly hex foes!", summon:getName():capitalize())

		-- Find targets
		local targets = table.keys(dread:projectCollect({type="ball", radius=10}, dread.x, dread.y, engine.Map.ACTOR, "hostile"))
		if #targets == 0 then return end

		-- Find hexes
		local hexes = {}
		for tid, _ in pairs(dread.talents) do
			local tt = dread:getTalentFromId(tid)
			if tt.is_hex or tt.is_curse then hexes[#hexes+1] = tid end
		end
		if #hexes == 0 then return end

		local nb = t:_getFoes(self)
		while nb > 0 and #targets > 0 do
			nb = nb - 1
			local target = rng.tableRemove(targets)
			dread:forceUseTalent(rng.table(hexes), {ignore_energy=true, ignore_ressources=true, force_target=target, ignore_cd=true})
		end
	end,
	info = function(self, t)
		return ([[Any time one of your minions dies or expires, and even if it is resurrected by a boneyard, the dread feeds on it.
		Each time it feeds it gets healed for %d and reduces remaining cooldown of its spells by %d.
		Every 10 minion deaths it casts a random hex on up to %d foes at once, instantly and without triggering a cooldown.]]):
		tformat(t:_getHeal(self), t:_getCD(self), t:_getFoes(self))
	end,
}

newTalent{
	name = "Neverending Peril",
	type = {"spell/dreadmaster",3},
	require = spells_req3,
	points = 5,
	mana = 10,
	soul = 1,
	cooldown = 20,
	tactical = { BUFF=1 },
	getTurns = function(self, t) return math.floor(self:combatTalentScale(t, 3, 9)) end,
	on_pre_use = function(self, t) return necroArmyStats(self).dread end,
	action = function(self, t)
		local dread = necroArmyStats(self).dread
		if not dread then return end
		dread:setEffect(dread.EFF_NEVERENDING_PERIL, t:_getTurns(self), {})
		return true
	end,
	info = function(self, t)
		return ([[In an effort to make your dread more annoying you focus a shell of darkness around it, rendering it fully invincible for %d turns.]]):
		tformat(t:_getTurns(self))
	end,
}

newTalent{
	name = "Dreadmaster",
	type = {"spell/dreadmaster",4},
	require = spells_req4,
	points = 5,
	mode = "passive",
	info = function(self, t)
		return ([[You now summon a Dreadmaster instead of a Dread.
		Dreadmasters learn to cast silence, disperse magic and mind disruption, making them the ultimate annoyance tool.
		It learns them at talent level %d.]]):
		tformat(math.floor(self:getTalentLevel(t)))
	end,
}
