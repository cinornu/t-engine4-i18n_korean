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

local Object = require "mod.class.Object"

newTalent{
	name = "Ghost Walk",
	type = {"spell/spectre",1},
	require = spells_req1,
	points = 5,
	mana = 12,
	cooldown = 10,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9, 0.5, 0, 1)) end,
	requires_target = true,
	target = function(self, t)
		return {type="hit", nolock=true, range=self:getTalentRange(t)}
	end,
	direct_hit = true,
	is_teleport = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then -- To prevent teleporting through walls
			game.logPlayer(self, "You do not have line of sight.")
			return nil
		end
		local _ _, x, y = self:canProject(tg, x, y)
		
		local orig_x = self.x
		local orig_y = self.y
		
		game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		if not self:teleportRandom(x, y, 0) then
			game.logSeen(self, "%s's ghost walk fizzles!", self.name:capitalize())
		else
			self:setEffect(self.EFF_GHOST_WALK, 3, {src=self, range=self:getTalentRange(t), x=orig_x, y=orig_y})
			if self:knowTalent(self.T_SPECTRAL_SIGHT) then
				self:setEffect(self.EFF_SENSE, self:callTalent(self.T_SPECTRAL_SIGHT, "getDuration"), {
				range = self:callTalent(self.T_SPECTRAL_SIGHT, "getVision"),
				actor = 1,
				})			
			end
			if self:knowTalent(self.T_INTANGIBILITY) then
				self:setEffect(self.EFF_INTANGIBILITY, self:callTalent(self.T_INTANGIBILITY, "getDuration"), {
				src = self,
				power = self:callTalent(self.T_INTANGIBILITY, "getChance"),
				})
			end
			game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		end
		
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[Taking on a spectral form, you teleport to the target tile within range %d. 
		For 3 turns after using this spell, you gain the ability to instantly teleport back to your original tile as long as you are within range of it.]]):tformat(range)
	end,
}

newTalent{
	name = "Ghost Walk - Return", short_name = "GHOST_WALK_RETURN",
	type = {"spell/other",1},
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	requires_target = true,
	direct_hit = true,
	is_teleport = true,
	no_energy = true,
	action = function(self, t)
		local eff = self:hasEffect(self.EFF_GHOST_WALK)
		if not eff then return end
		local x = eff.x
		local y = eff.y
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then -- To prevent teleporting through walls
			game.logPlayer(self, "You do not have line of sight.")
			return nil
		end
		
		if self:knowTalent(self.T_PATH_TO_BEYOND) then
			local ActorTalents = require("engine.interface.ActorTalents")
			for i=1, self:callTalent(self.T_PATH_TO_BEYOND, "getNb") do
				local tx, ty = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
				if not tx then return end
				local NPC = require "mod.class.NPC"
				local m = NPC.new{
					name = "wisp",
					display = "g", color=colors.LIGHT_BLUE, image="npc/undead_ghost_will_o__the_wisp.png",
					blood_color = colors.BLUE,
					type = "undead", subtype = "ghost",
					rank = 2,
					size_category = 2,
					body = { INVEN = 10 },
					level_range = {self.level, self.level},
					no_drops = true,
					autolevel = "warriorwill",
					exp_worth = 0,
					ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2 },
					stats = { str=15, dex=15, wil=15, con=15, cun=15},
					infravision = 10,
					silent_levelup = true,
					no_breath = 1,
					negative_status_effect_immune = 1,
					infravision = 10,
					max_life = resolvers.rngavg(10, 30),
					life_rating = 6,
					combat_armor = 1, combat_def = 10,
					combat = { dam=1, atk=1, apr=1, damtype=DamageType.COLD },
		
				}
				m.faction = self.faction
				m.summoner = self
				m.summoner_gain_exp = true
				m.on_act = function(self)
					if self.turn_procs.taunt then return end
					self.turn_procs.taunt = true
					local tg = {type="ball", range=0, radius=3, friendlyfire=false}
					self:project(tg, self.x, self.y, function(tx, ty)
						local a = game.level.map(tx, ty, Map.ACTOR)
						if a and not a.dead and a:reactionToward(self) < 0 then a:setTarget(self) end
					end)
				end
				m.summon_time = self:callTalent(self.T_PATH_TO_BEYOND, "getDuration")
				m.remove_from_party_on_death = true
				m:resolve() m:resolve(nil, true)
				m:forceLevelup(self.level)			
				ActorTalents.main_env.setupSummon(self, m, tx, ty)
				game.level.map:particleEmitter(tx, ty, 1, "generic_teleport", {rm=60, rM=130, gm=20, gM=110, bm=90, bM=130, am=70, aM=180})
			end
		end
		
		game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		if not self:teleportRandom(x, y, 0) then
			game.logSeen(self, "%s's ghost walk fizzles!", self.name:capitalize())
		else
			game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		end
		
		self:removeEffect(self.EFF_GHOST_WALK)
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[Return to the location you used Ghost Walk from.]]):tformat()
	end,
}

newTalent{
	name = "Spectral Sight",
	type = {"spell/spectre", 2},
	require = spells_req2,
	points = 5,
	mode = "passive",
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4)) end,
	getVision = function(self, t) return math.min(10, math.floor(7.5 + self:getTalentLevel(t)/2)) end,
	getEsp = function(self, t) return math.floor(10 + self:getTalentLevel(t)) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, 1)) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "esp", {["undead"]=1})
	end,	
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local vision = t.getVision(self,t)
		local esp = t.getEsp(self,t)
		local range = self:getTalentRange(t)
		return ([[While in your spectral form from Ghost Walk and for %d turns afterwards, you gain vision of all enemies within radius %d.
In addition, at all times you gain the ability to sense undead within %d tiles, and can perceive any foe within %d tiles of your necrotic minions.]]):
		tformat(dur, vision, esp, range)
	end,
}

newTalent{
	name = "Intangibility",
	type = {"spell/spectre", 3},
	require = spells_req3,
	points = 5,
	mode = "passive",
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4)) end,
	getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 45, 12, 27)) end,
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local chance = t.getChance(self,t)
		return ([[While in your spectral form from Ghost Walk and for %d turns afterwards, damage and detrimental effects have a %d%% chance to harmlessly pass through you.]]):
		tformat(dur, chance)
	end,
}

newTalent{
	name = "Path to Beyond",
	type = {"spell/spectre",4},
	require = spells_req4,
	points = 5,
	mode = "passive",
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4.5)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		return ([[On using Ghost Walk - Return, you create a portal that summons %d spirits around you for %d turns. The spirits do very little damage, but taunt all enemies in radius 3 into attacking them.]]):
		tformat(nb, dur)
	end,
}
