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
	name = "Bodies Reserve",
	type = {"psionic/body-snatcher", 1},
	require = psi_wil_req1,
	points = 5,
	mode = "passive",
	no_npc_use = true,
	no_unlearn_last = true,
	getMax = function(self, t) return math.min(15, math.ceil(2 * self:getTalentLevel(t)) + 1) end,
	passives = function(self, t)
		self.bodies_storage = self.bodies_storage or {}
		self.bodies_storage.max = t.getMax(self, t)
		while #self.bodies_storage > self.bodies_storage.max do
			table.remove(self.bodies_storage)
		end
	end,
	hasRoom = function(self, t)
		return #self.bodies_storage < self.bodies_storage.max
	end,
	setupBody = function(self, t, target)
		local oldsummoner = target.summoner
		target.summoner = nil
	 	local body = target:cloneFull()
	 	target.summoner = oldsummoner

	 	-- Remove FOV
	 	body.fov = {actors={}, actors_dist={}}
	 	body.distance_map = {}

		-- Disable all effects & sustains
		body.on_die = nil -- because it's cleaner and because this prevents a silly fearscape bug
		body:removeEffectsSustainsFilter(function() return true end, 9999, nil, true, true)
		
		-- reset talent cooldowns
		body.talents_cd = {}

		-- Remove misc stuff
		body.__project_source = nil
		body.ai_target = {}
		body.summoner = nil
		body.alchemy_golem = nil
		body.brother = nil
		body.turn_procs = {}
		self:triggerHook{"Possessor:bodySnatcher:setupBody", body=body, target=target}

		-- Heal up & regen all ressources
		body.dead = nil
		if body.max_life_no_difficulty_boost then
			body.max_life = body.max_life_no_difficulty_boost
			body.max_life_no_difficulty_boost = nil
		end
		body:resetToFull()
		return body
	end,
	storeBody = function(self, t, target, setup)
		if not t.hasRoom(self, t) then return false end

		local body
		if setup then
			if target._possessor_already_snatched then return false end
			target._possessor_already_snatched = true

			body = t.setupBody(self, t, target)
		else
			body = target
		end

		self.bodies_storage[#self.bodies_storage+1] = { body=body, uses=self:callTalent(self.T_PSIONIC_DUPLICATION, "getNb", body) }
		return true
	end,
	decreaseUse = function(self, t, bodycheck, all)
		for i, body in ipairs(self.bodies_storage) do
			if body.body == bodycheck then
				body.uses = body.uses - (all and body.uses or 1)
				body.body.life = body.body.max_life -- Heal up !
				body.body._cannibalize_penalty = nil
				if body.uses <= 0 then
					table.remove(self.bodies_storage, i)
				end
				break
			end
		end
	end,
	usesLeft = function(self, t, bodycheck)
		for i, body in ipairs(self.bodies_storage) do
			if body.body == bodycheck then
				return body.uses
			end
		end
		return 0
	end,
	info = function(self, t)
		return ([[Your mind is so powerful it can bend reality, providing you with an extra-natural #{italic}#storage#{normal}# for bodies you snatch.
		You can store up to %d bodies.]]):
		tformat(t.getMax(self, t))
	end,
}

newTalent{
	name = "Psionic Minion",
	type = {"psionic/body-snatcher", 2},
	require = psi_wil_req2,
	points = 5,
	psi = 30,
	cooldown = 20,
	no_npc_use = true,
	getDur = function(self, t) return math.ceil(self:combatTalentScale(t, 10, 25)) end,
	action = function(self, t)
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke your minion!")
			return
		end

		local body = self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "minion"))
		if not body then return false end

		local m = body:cloneFull{
			shader = "shadow_simulacrum", shader_args = { color = {0.3, 0.5, 1}, base = 0.5, time_factor = 1500 },
			no_drops = true, keep_inven_on_death = false,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDur(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			name = body.name.." (Psionic Minion)",
			resolvers.sustains_at_birth(),
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil

		m.energy.value = 0
		m.player = nil
		-- m.max_life = m.max_life * t.getHealth(self, t)
		m.life = m.max_life
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.puuid = nil
		m.on_takehit = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		m.exp_worth = 0
		m.no_inventory_access = true
		m.no_levelup_access = true
		m.cant_teleport = true
		m.remove_from_party_on_death = true
		m.no_life_regen = 1
		m.no_healing = 1
		m.no_healing_no_warning = 1

		m:resolve()
		m:resolve(nil, true)
		game.zone:addEntity(game.level, m, "actor", x, y)
		-- game.level.map:particleEmitter(x, y, 1, "shadow")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="order",
				type="psionic minion",
				title=m.name,
				temporary_level=1,
				orders = {target=true},
			})
		end
		game:onTickEnd(function() game.party:setPlayer(m) end)

		self:callTalent(self.T_BODIES_RESERVE, "decreaseUse", body)

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[You imbue a part of your own mind into a body without actually taking its form.
		The body will work as your minion for %d turns.
		Psionic minions can not heal in any way.
		When the effect ends the body is permanently lost.]]):
		tformat(t.getDur(self, t))
	end,
}

newTalent{
	name = "Psionic Duplication",
	type = {"psionic/body-snatcher", 3},
	require = psi_wil_req3,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	no_unlearn_last = true,
	getNb = function(self, t, body)
		local nb = math.ceil(self:getTalentLevel(t)) + 1
		if body and body.rank > 3 then nb = math.ceil(nb / 3) end
		return nb
	end,
	info = function(self, t)
		return ([[When you store a body you also store %d more identical copies of it that you can use later.
		When you store a rare/unique/boss or higher rank creature you only get a third of the uses (but never less than one).]]):
		tformat(t.getNb(self, t))
	end,
}

-- interaction with solipsism?
newTalent{
	name = "Cannibalize",
	type = {"psionic/body-snatcher", 4},
	require = psi_wil_req4,
	psi = 25,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 15, 40, 25)) end,
	points = 5,
	no_npc_use = true,
	on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_POSSESSION) then if not silent then game.logPlayer(self, "You require need to assume a form first.") end return false end return true end,
	getHeal = function(self, t) return math.ceil(self:combatTalentScale(t, 40, 80)) end,
	action = function(self, t)
		local eff = self:hasEffect(self.EFF_POSSESSION)		
		local body = self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "cannibalize", {filter_rank=eff.body.rank or 1, exclude_body=eff.body}))
		if not body then return false end
		if body.rank < eff.body.rank then game.logPlayer(self, "Rank of body too low.") return false end

		self:callTalent(self.T_BODIES_RESERVE, "decreaseUse", body, false)

		local hp = t.getHeal(self, t) * body.max_life / 100
		eff.body._cannibalize_penalty = eff.body._cannibalize_penalty or 1
		hp = hp * eff.body._cannibalize_penalty
		eff.body._cannibalize_penalty = eff.body._cannibalize_penalty * 0.66

		local old_no_healing = self.no_healing
		self.no_healing = nil -- This even bypasses no healing set by npcs
		local oldlife = self.life
		self:heal(hp)
		eff.can_raise_life_over = eff.can_raise_life_over + (self.life - oldlife)
		self.no_healing = old_no_healing
		self:incPsi(hp * 0.5)

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[When you assume a form you may cannibalize a body in your reserve to replenish your current body.
		You can only use bodies that are of same or higher rank for the effect to work and each time you heal a body the effect will be reduced by 33%% for that body.
		Your current body will heal for %d%% of the max life of the cannibalized one and you will also regenerate 50%% of this value as psi.
		The healing effect is more psionic in nature than a real heal. As such may things that prevent healing will not prevent cannibalize from working.
		Cannibalize is the only possible way to heal a body.
		]]):
		tformat(t.getHeal(self, t))
	end,
}
