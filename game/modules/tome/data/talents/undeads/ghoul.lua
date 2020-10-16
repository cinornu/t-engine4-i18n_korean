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
	name = "Ghoul",
	type = {"undead/ghoul", 1},
	mode = "passive",
	require = undeads_req1,
	points = 5,
	statBonus = function(self, t) return math.ceil(self:combatTalentScale(t, 2, 15, 0.75)) end,
	getMaxDamage = function(self, t) return 50 end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_STR]=t.statBonus(self, t)})
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_CON]=t.statBonus(self, t)})
		self:talentTemporaryValue(p, "flat_damage_cap", {all=t.getMaxDamage(self, t)})
	end,
	info = function(self, t)
		return ([[Improves your ghoulish body, increasing Strength and Constitution by %d.
		Your body also becomes incredibly resilient to damage; you can never take a blow that deals more than %d%% of your maximum life.]])
		:tformat(t.statBonus(self, t), t.getMaxDamage(self, t))
	end,
}

newTalent{
	name = "Ghoulish Leap",
	type = {"undead/ghoul", 2},
	require = undeads_req2,
	points = 5,
	tactical = { CLOSEIN = 3 },
	direct_hit = true,
	fixed_cooldown = true,
	cooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 20, 10, false, 1.1)) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5, 10, 0.5, 0, 1)) end,
	getSpeed = function(self, t) return math.floor(self:combatTalentLimit(t, 40, 20, 30, false, 1.1)) end,
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), nolock=true}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local ox, oy = self.x, self.y

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		local tx, ty, _ = lx, ly
		while lx and ly do
			if is_corner_blocked or block_actor(_, lx, ly) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		-- Find space
		if block_actor(_, tx, ty) then return nil end
		local fx, fy = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not fx then
			return
		end
		self:move(fx, fy, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 9, 5)
		end

		self:setEffect(self.EFF_GHOULISH_LEAP, 4, {speed=t.getSpeed(self, t) / 100})

		return true
	end,
	info = function(self, t)
		return ([[Leap toward your target.
		When you land your global speed is increased by %d%% for 4 turns.]]):tformat(t.getSpeed(self, t))
	end,
}

newTalent{
	name = "Retch",
	type = {"undead/ghoul",3},
	require = undeads_req3,
	points = 5,
	cooldown = 20,
	tactical = { ATTACKAREA = function(self, t, aitarget)
			return not aitarget:attr("undead") and { BLIGHT = 1 } or nil
		end,
		HEAL = function(self, t, aitarget)
			return self:attr("undead") and 1 or nil
		end},
	radius = 3,
	range=0,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire = not self:attr("undead")} end,  --selffire is set only for the ai, the map effect doesn't use it
	requires_target = true,
	getduration = function(self, t) return 10 end,
	getPurgeChance = function(self, t) return self:combatTalentLimit(t, 100, 10, 33, false, 1.1) end, -- Limit < 100%
	-- status effect removal handled in mod.data.damage_types (type = "RETCH")
	action = function(self, t)
		local duration = t.getduration(self, t)
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		local tg = self:getTalentTarget(t)
		local tx, ty = self.x, self.y
		if not tx or not ty then return nil end

		-- Add a lasting map effect
		game.level.map:addEffect(self,
			tx, ty, duration,
			DamageType.RETCH, dam,
			tg.radius,
			5, nil,
			MapEffect.new{color_br=30, color_bg=180, color_bb=60, effect_shader="shader_images/retch_effect.png"},
			nil
		)
		game.logSeen(self, "%s #YELLOW_GREEN#VOMITS#LAST# on the ground!", self:getName():capitalize())
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		return ([[Vomit on the ground around you, healing any undead in the area and damaging anyone else.
		Lasts %d turns and deals %d blight damage or heals %d life.
		Creatures standing in the retch also have %d%% chance to remove a physical effect each turn; undeads will be stripped from a detrimental effect while others will be stripped from a beneficial effect.
		When you stand in your own retch your racial -20%% global speed is cancelled.]]):tformat(t.getduration(self, t), damDesc(self, DamageType.BLIGHT, dam), dam * 1.5, t.getPurgeChance(self, t))
	end,
}

newTalent{
	name = "Gnaw",
	type = {"undead/ghoul", 4},
	require = undeads_req4,
	points = 5,
	cooldown = 10,
	tactical = { ATTACK = {BLIGHT = {disease = 6}} },  -- Ghouls really like making more ghouls
	range = 1,
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentScale(t, 1, 1.6) end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7, false, 1.1)) end,
	getGhoulDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3, 7, false, 1.1)) end,
	getDiseaseDamage = function(self, t) return self:combatTalentStatDamage(t, "con", 10, 70) end,
	spawn_ghoul = function (self, target, t)
		local x, y = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
		if not x then return nil end
		local NPC = require "mod.class.NPC"
		local ghoul = NPC.new{
			type = "undead", subtype = "ghoul",
			display = "z",
			name = _t"Risen Ghoul", color=colors.TAN,
			image="npc/undead_ghoul_ghoul.png",
			desc = _t[[Flesh is falling off in chunks from this decaying abomination.]],
			faction = self.faction,
			level_range = {1, nil}, exp_worth = 0,
			life_rating = 10,
			max_life = 100,
			combat_armor_hardiness = 40,  -- 70% total
			combat_armor=resolvers.levelup(3, 1, 1), combat_def = 7,
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
			autolevel = "ghoul",
			silent_levelup = true,
			no_inventory_access = true,
			no_drops = true,
			summoner = self, summoner_gain_exp = true,
			summon_time = t.getGhoulDuration(self, t),
			ai = "summoned", ai_state = { talent_in=1, ai_move="move_ghoul", },
			ai_real = "tactical",
			ai_tactic = resolvers.tactic"melee",
			stats = { str=14, dex=12, mag=10, con=12 },
			-- 1200 life, 82 Accuracy, 80 ppower at level 50 (with difficulty player summon bug fixed)
			-- Melee damage is terrible, but we need these to scale to beat save checks
			-- APR isn't thematic but its the best way to ensure armor can't 0 out our low damage and thus prevent the much more relevant on hit effects
			combat_dam = resolvers.levelup(1, 1, 3),
			combat = { dam=resolvers.levelup(10, 1, 1), atk=resolvers.levelup(9, 1, 4), apr=resolvers.levelup(3, 1, 1), dammod={str=1} },

			rank = 2,
			size_category = 3,
			infravision = 10,

			resolvers.talents{
				[Talents.T_GHOUL]={base=1, every=10, max=5},
				[Talents.T_GNAW]={base=1, every=10, max=3},
				[Talents.T_GHOULISH_LEAP]={base=1, every=10, max=5},
				[Talents.T_STUN]={base=1, every=10, max=3},
				[Talents.T_ROTTING_DISEASE]={base=1, max=1},  -- The scaling on this is completely insane, TL1 is plenty
			},

			blind_immune = 1,
			see_invisible = 2,
			undead = 1,
			not_power_source = {nature=true},
		}
		ghoul:resolve() ghoul:resolve(nil, true)
		ghoul:forceLevelup(self.level)
		ghoul.unused_talents = 0
		ghoul.unused_generics = 0
		ghoul.unused_talents_types = 0

		game.zone:addEntity(game.level, ghoul, "actor", x, y)
		game.level.map:particleEmitter(target.x, target.y, 1, "slime")
		game:playSoundNear(target, "talents/slime")
		ghoul:logCombat(target, "A #GREY##Source##LAST# rises from the corpse of #Target#.")

		if game.party:hasMember(self) then
			ghoul.remove_from_party_on_death = true
			game.party:addMember(ghoul, {
				control="no",
				type="minion",
				title=_t"Ghoulish Minion",
				orders = {target=true},
			})
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			if target:canBe("disease") then
				if target.dead then
					t.spawn_ghoul(self, target, t)
				else
					target:setEffect(target.EFF_GHOUL_ROT, t.getDuration(self,t), {src=self, apply_power=self:combatPhysicalpower(), dam=t.getDiseaseDamage(self, t),  make_ghoul=1})
				end
			else
				game.logSeen(target, "%s resists the disease!", target:getName():capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local ghoul_duration = t.getGhoulDuration(self, t)
		local disease_damage = t.getDiseaseDamage(self, t)
		return ([[Gnaw your target for %d%% damage.  If your attack hits, the target may be infected with Ghoul Rot for %d turns.
		Each turn, Ghoul Rot inflicts %0.2f blight damage.
		Targets suffering from Ghoul Rot rise as friendly ghouls when slain.
		Ghouls last for %d turns and can use Gnaw, Ghoulish Leap, Stun, and Rotting Disease.
		The blight damage scales with your Constitution.]]):
		tformat(100 * damage, duration, damDesc(self, DamageType.BLIGHT, disease_damage), ghoul_duration)
	end,
}
