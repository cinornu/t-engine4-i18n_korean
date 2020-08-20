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
	name = "Infectious Bite",
	type = {"technique/other", 1},
	points = 5,
	message = _t"@Source@ bites blight poison into @target@.",
	cooldown = 3,
	tactical = { ATTACK = {BLIGHT = 2}, },
	requires_target = true,
	range = 1,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getPoisonDamage = function(self, t) return self:combatTalentSpellDamage(t, 12, 150) end,
	action = function(self, t)
		
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		
		local dam = t.getDamage(self,t)
		local poison = t.getPoisonDamage(self,t)
		
		-- Hit?
		local hitted = self:attackTarget(target, nil, dam, true)
		
		if hitted then
			self:project({type="hit"}, target.x, target.y, DamageType.BLIGHT_POISON, {dam=poison, power=0, poison=1, heal_factor=0, apply_power=self:combatSpellpower()})
		end
		
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local poison = t.getPoisonDamage(self, t)
		return ([[Bite the target, dealing %d%% melee damage  
		If the attack hits you'll inject blight poison into the target, dealing %0.2f blight damage and a further %0.2f blight damage over 4 turns.
		The bonus damage improves with your Spellpower.]])
		:tformat(damage, damDesc(self, DamageType.BLIGHT, poison/4), damDesc(self, DamageType.BLIGHT, poison) )
	end
}


carrionworm = function(self, target, duration, x, y)
	local m = mod.class.NPC.new{
		type = "vermin", subtype = "worms",
		display = "w", color=colors.SANDY_BROWN, image = "npc/vermin_worms_carrion_worm_mass.png",
		name = "carrion worm mass", faction = self.faction,
		desc = _t[[A worm spawned from a damaged horror.  Destroying it may have consequences.]],
		autolevel = "none",
		ai = "summoned", ai_real = "tactical",
		ai_state = { ai_move="move_complex", talent_in=1, ally_compassion=10, ai_target="target_closest", },
		ai_tactic = resolvers.tactic"melee",
		stats = { str=10, dex=15, mag=3, con=3 },
		level_range = {1, self.level}, exp_worth = 0,
		global_speed_base = 1.0,

		max_life = resolvers.rngavg(5,9),
		size_category = 1,
		cut_immune = 1,
		blind_immune = 1,
		life_rating = 6,
		disease_immune = 1,
		movement_speed = 1.5,
		melee_project={[DamageType.PESTILENT_BLIGHT] = self:callTalent(self.T_PESTILENT_BLIGHT, "getChance")/2,},
		resists = { [DamageType.PHYSICAL] = 50, [DamageType.ACID] = 100, [DamageType.BLIGHT] = 100, [DamageType.FIRE] = -50},
		
		combat_armor = 1, combat_def = 1,
		combat = { dam=40, atk=900, apr=900 },  -- We only care about making sure we do at least 1 damage for on hit stuff
		autolevel = "warriormage",
		resolvers.talents{ 
		[Talents.T_INFECTIOUS_BITE]=math.floor(self:getTalentLevelRaw(self.T_INFESTATION)),
		},
		summoner = self, summoner_gain_exp=true, carrion_worm = true,
		summon_time = 5,
		carrion_worm = true,  -- This prevents combat log spam from blight pools dealing 0 damage and lets the AI pick targets for Worm Rot
	}
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.no_inventory_access = true
	m.no_points_on_levelup = true
	m.carrion_worm = true  -- This keeps the on_death effect from spamming the damage log with 0s
	m.save_hotkeys = true
	m.ai_state.tactic_leash = 100
	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	m.on_die = function(self, src)
		local t = self.summoner:getTalentFromId(self.summoner.T_INFESTATION)
		game.level.map:addEffect(self, self.x, self.y, 5,
			engine.DamageType.WORMBLIGHT, t.getDamage(self.summoner, t),
			2, 5, nil,
			engine.MapEffect.new{alpha=90, color_br=1, color_bg=1, color_bb=1, effect_shader="shader_images/poison_effect.png"}
		)
		game.logSeen(self, "%s exudes a corrupted gas as it dies.", self:getName():capitalize())
	end

	-- Snapshot the casters effective (not base) spellpower
	m.summoner_spellpower = self:combatSpellpower()
	m.combatSpellpower = function(self) return self.summoner_spellpower end
	
	m:resolve() m:resolve(nil, true)
	m:forceLevelup(self.level)
	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "summon")

	mod.class.NPC.castAs(m)
	engine.interface.ActorAI.init(m, m)
	m.remove_from_party_on_death = true
	if game.party:hasMember(self) then
		game.party:addMember(m, {
			control=false,
			temporary_level = true,
			type="summon",
			title=_t"Summon",
		})
	end
	return m
end

newTalent{
	name = "Infestation",
	type = {"corruption/rot", 1},
	require = corrs_req_high1,
	points = 5,
	mode = "sustained",
	sustain_vim = 30,
	cooldown = 15,
	getDamage = function(self, t)
		return self:combatTalentSpellDamage(t, 10, 70)
	end,
	getResist = function(self, t) return self:combatTalentLimit(t, 30, 5, 25) end,
	getAffinity = function(self, t) return self:combatTalentLimit(t, 25, 4, 20) end,
	getDamageReduction = function(self, t) 
		return self:combatTalentLimit(t, 0.5, 0.1, 0.22)
	end,
	tactical = {BUFF = 3},
	activate = function(self, t)
		local resist = t.getResist(self,t)
		local affinity = t.getAffinity(self,t)
		local ret = {
			res = self:addTemporaryValue("resists", {[DamageType.BLIGHT]=resist, [DamageType.ACID]=resist}),
			aff = self:addTemporaryValue("damage_affinity", {[DamageType.BLIGHT]=affinity}),
			worm = self:addTemporaryValue("worm", 1),
		}
		if core.shader.active() then
			self:talentParticles(ret, {type="shader_shield", args={toback=false, size_factor=1.5, img="infestation_sustain_tentacles2"}, shader={type="tentacles", appearTime=0.6, time_factor=1000, noup=0.0}})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("resists", p.res)
		self:removeTemporaryValue("damage_affinity", p.aff)
		self:removeTemporaryValue("worm", p.worm)
		return true
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if ( dam > (0.15 * self.max_life) ) then
			local damageReduction = dam * t.getDamageReduction(self, t)
			dam = dam - damageReduction

			local nb = 0 
			if game.level then
				for _, act in pairs(game.level.entities) do
					if act.summoner and act.summoner == self and act.carrion_worm then nb = nb + 1 end
				end
			end
			
			if nb >= 5 then return nil end

			game.logPlayer(self, "#GREEN#A carrion worm mass bursts forth from your wounds, softening the blow and reducing damage taken by #ORCHID#" .. math.ceil(damageReduction) .. "#LAST#.")
			
			if not self.turn_procs.infestation then
				self.turn_procs.infestation = true

				local grids = {}
				self:project({type="ball", radius=4, x=self.x, y=self.y}, self.x, self.y, function(px, py)
					if not game.level.map:checkAllEntities(px, py, "block_move") then
						table.insert(grids, {x=px, y=py})
					end
				end)

				local spot = rng.table(grids)
				if spot then
					local gx, gy = util.findFreeGrid(spot.x, spot.y, 4, true, {[Map.ACTOR]=true})
					if gx and gy then 
						carrionworm(self, self, 5, gx, gy)
					end
				end
			end
			return {dam = dam}
		end
	end,
	info = function(self, t)
	local resist = t.getResist(self,t)
	local affinity = t.getAffinity(self,t)
	local dam = t.getDamage(self,t)
	local reduction = t.getDamageReduction(self,t)*100
		return ([[Your body has become a mass of living corruption, increasing your blight and acid resistance by %d%% and blight affinity by %d%%.
On taking damage greater than 15%% of your maximum health, the damage will be reduced by %d%% and a carrion worm mass will burst forth onto a nearby tile, attacking your foes for 5 turns.
You can never have more than 5 worms active from any source at a time.
When a carrion worm dies it will explode into a radius 2 pool of blight for 5 turns, dealing %0.2f blight damage each turn and healing you for 33%% of that amount.]]):
		tformat(resist, affinity, reduction, damDesc(self, DamageType.BLIGHT, dam), dam)
	end,
}

newTalent{
	name = "Worm Walk",
	type = {"corruption/rot", 2},
	require = corrs_req_high2,
	points = 5,
	cooldown = 10,
	vim = 8,
	requires_target = true,
	radius = function(self, t) return math.max(0, 7 - math.floor(self:getTalentLevel(t))) end,
	direct_hit = true,
	range = 7,
	getHeal = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 20, 400)) end,
	getVim = function(self, t) return 8 + math.floor(self:combatTalentScale(t, 5, 35)) end,
	getDam = function(self, t) return self:combatTalentLimit(t, 1, 20, 5) end,
	tactical = {HEAL = 0.5},  -- Only use the healing functionality of this since in practice thats almost always optimal, but use it rarely so we don't waste time hopping around a lot as a melee
	target = function(self, t) -- no change to default_target because worms will usually be in melee with an enemy
		return {type="hit", nolock=true, range=self:getTalentRange(t)}
	end,
	onAIGetTarget = function(self, t) -- Find a worm to target
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, engine.Map.ACTOR)
			if a and a.carrion_worm and self:reactionToward(a) > 0 then tgts[#tgts+1] = a end
		end end

		local target = rng.tableRemove(tgts)
		if target then return target.x, target.y, target end
	end,
	on_pre_use_ai = function(self, t, silent) return t.onAIGetTarget(self, t) and true or false end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
			game.logPlayer(self, "You do not have line of sight to this location.")
			return nil
		end
		local __, x, y = self:canProject(tg, x, y)
		target = game.level.map(x, y, Map.ACTOR)
		local teleport = self:getTalentRadius(t)

		if target and target.summoner and target.summoner == self and target.name == "carrion worm mass" then
			teleport = 0
			self:incVim(t.getVim(self, t))
			self:attr("allow_on_heal", 1)
			self:heal(t.getHeal(self, t), self)
			self:attr("allow_on_heal", -1)
			target:die()
		end
		
		if not self:teleportRandom(x, y, teleport) then
			game.logSeen(self, "The worm walk fizzles!")
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "acidflash", {radius=1})
		game:playSoundNear(self, "talents/teleport")

		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t)
		local vim = t.getVim(self, t)
		return ([[You disperse into a mass of carrion worms, reforming near the target location (%d teleport accuracy).
If used on a worm mass, you merge with it, moving to it's location, healing you for %d, restoring %d vim, and destroying the mass.]]):
tformat (radius, heal, vim)
	end,
}

newTalent{
	name = "Pestilent Blight",
	type = {"corruption/rot",3},
	require = corrs_req_high3,
	points = 5,
	mode = "passive",
	cooldown = 5,
	radius = function(self, t) return self:getTalentLevel(t) >= 4 and 1 or 0 end,
	getChance = function(self, t) return self:combatTalentScale(t, 15, 45) end,
	getDuration = function(self, t)  return math.floor(self:combatTalentScale(t, 2, 5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	do_rot = function(self, t, target, dam)
		local chance = t.getChance(self,t)
		local dur = t.getDuration(self,t)
		if not dam or type(dam) ~= "number" then return end
		if target.dead then return end
		if rng.percent(chance) and not self:isTalentCoolingDown(t.id) then 
				local tg = self:getTalentTarget(t)
				self:project(tg, target.x, target.y, function(px, py, tg, self)
					local target = game.level.map(px, py, Map.ACTOR)
					if target then
						local eff = rng.table{"blind", "silence", "disarm", "pin", }
						if eff == "blind" and target:canBe("blind") then target:setEffect(target.EFF_BLINDED, dur, {apply_power=self:combatSpellpower(), no_ct_effect=true})
							elseif eff == "silence" and target:canBe("silence") then target:setEffect(target.EFF_SILENCED, dur, {apply_power=self:combatSpellpower(), no_ct_effect=true})
							elseif eff == "disarm" and target:canBe("disarm") then target:setEffect(target.EFF_DISARMED, dur, {apply_power=self:combatSpellpower(), no_ct_effect=true})
							elseif eff == "pin" and target:canBe("pin") then target:setEffect(target.EFF_PINNED, dur, {apply_power=self:combatSpellpower(), no_ct_effect=true})
						end
					end
				end)
				self:startTalentCooldown(t.id)
			end
	end,
info = function(self, t)
	local chance = t.getChance(self,t)
	local duration = t.getDuration(self,t)
		return ([[You have a %d%% chance on dealing blight damage to cause the target to rot away, silencing, disarming, blinding or pinning them for %d turns. This effect has a cooldown.
At talent level 4, this affects targets in a radius 1 ball.
Your worms also have a %d%% chance to blind, silence, disarm or pin with their melee attacks, lasting 2 turns.
The chance to apply this effect will increase with your Spellpower.]]):
		tformat(chance, duration, chance/2)
	end,
}

newTalent{
	name = "Worm Rot",
	type = {"corruption/rot", 4},
	require = corrs_req_high4,
	points = 5,
	cooldown = 8,
	vim = 10,
	range = 6,
	requires_target = true,
	tactical = { ATTACK = { ACID = 1, BLIGHT = 1 }, DISABLE = 4 },
	getBurstDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 150) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 55) end,
	getChance = function(self, t) return math.min(100, self:combatTalentScale(t, 20, 90)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}} end,
	spawn_carrion_worm = function(self, t, target)
		if not game.level then return end
		local nb = 0 
		for _, act in pairs(game.level.entities) do
			if act.summoner and act.summoner == self and act.carrion_worm then nb = nb + 1 end
		end
		if nb >= 5 then return nil end

		local x, y = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
		if not x then return nil end
		local m = carrionworm(self, self, 10, x, y)		
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			if target:canBe("disease") then
				target:setEffect(target.EFF_WORM_ROT, 5, {src=self, chance=t.getChance(self,t), dam=t.getDamage(self, t), burst=t.getBurstDamage(self, t), apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the worm rot!", target:getName():capitalize())
			end
			game.level.map:particleEmitter(px, py, 1, "slime")
		end)
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local burst = t.getBurstDamage(self, t)
		local chance = t.getChance(self,t)
		return ([[Infects the target with parasitic carrion worm larvae for 5 turns.  Each turn the disease will remove a beneficial physical effect and deal %0.2f acid and %0.2f blight damage.
If not cleared after five turns it will inflict %0.2f blight damage as the larvae hatch, removing the effect but spawning a full grown carrion worm mass near the target's location.
Even if this disease is removed early, there is still a %d%% chance for the larvae to hatch.
You can never have more than 5 worms active from any source at a time.
The damage dealt will increase with your Spellpower.]]):
		tformat(damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.BLIGHT, (burst)), chance)
	end,
}
