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

local cooldown_bonus = function(self)
	local t = self:getTalentFromId("T_SKIRMISHER_SUPERB_AGILITY")
	return t.cooldown_bonus(self, t)
end

local stamina_bonus = function(self)
	local t = self:getTalentFromId("T_SKIRMISHER_SUPERB_AGILITY")
	return t.stamina_bonus(self, t)
end

newTalent {
	short_name = "SKIRMISHER_VAULT",
	name = "Vault",
	type = {"technique/acrobatics", 1},
	require = techs_dex_req1,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) return 10 - cooldown_bonus(self) end,
	stamina = function(self, t) return math.max(0, 18 - stamina_bonus(self)) end,
	tactical = {SELF = {ESCAPE = 2, CLOSEIN = 2}},
	on_pre_use = function(self, t, silent, fake)
		if self:attr("never_move") then
			if not silent then game.logPlayer(self, "You cannot move!") end
			return
		end
		return true
	end,
	on_pre_use_ai = function(self, t)
		for i, act in ipairs(self.fov.actors_dist) do
			if act ~= self then	return self.fov.actors[act].sqdist <= 1	end
		end
	end,
	range = function(self, t)
		return math.floor(self:combatTalentScale(t, 3, 8))
	end,
	target = function(self, t)
		return {type="beam", talent=t, range=self:getTalentRange(t), nolock=true,
			-- Set up grid_params. Desired range depends on if we have a target and the current tactic.
			grid_params = {want_range = (not self.ai_target.actor or self.ai_state.tactic == "escape") and 10 + self:getTalentCooldown(t) or 0, max_delta=-1},
		}
	end,
	speed_bonus = function(self, t)
		return self:combatTalentScale(t, 0.6, 1.0, 0.75)
	end,
	action = function(self, t)
		local tx, ty, target
		local vault_launch_target = function(bx, by) -- find someone to launch from to reach a grid
			local vault_block = function(_, bx, by)
				return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self)
			end
			local line = self:lineFOV(bx, by, vault_block)
			local lx, ly, is_corner_blocked = line:step()
			local launch_target = game.level.map(lx, ly, Map.ACTOR)
			if launch_target then print("\tSKIRMISHER_VAULT: grid", bx, by, "has vault launch target at", launch_target.x, launch_target.y) end
			return self:canSee(launch_target) and launch_target
		end
		-- Get Landing Point.
		local tg = self:getTalentTarget(t)
		tg.grid_params.check=vault_launch_target
		local range = tg.range
		if self.player then
			tg.display_line_step = function(self, d) -- highlight permissible grids for the player
				local t_range = core.fov.distance(self.target_type.start_x, self.target_type.start_y, d.lx, d.ly)
				if t_range >= 2 and t_range <= tg.range and not d.block and vault_launch_target(d.lx, d.ly) then
					d.s = self.sb
				else
					d.s = self.sr
				end
				d.display_highlight(d.s, d.lx, d.ly)
			end
		end

		tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return end
		if game.level.map:checkAllEntities(tx, ty, "block_move", self) or not self:canProject(tg, tx, ty) then
			game.logPlayer(self, "You cannot land in that space.") return
		end
		
		-- Get Launch target.
		local launch_target = vault_launch_target(tx, ty)

		if not launch_target then
			game.logPlayer(self, "You must vault over someone adjacent to you.")
			return
		end

		self:logCombat(launch_target, "#Source# #YELLOW#vaults#LAST# over #target#!")
		local ox, oy = self.x, self.y
		self:move(tx, ty, true)

		local give_speed = function()
			self:setEffect(self.EFF_SKIRMISHER_DIRECTED_SPEED, 3, {
				 direction = math.atan2(ty - oy, tx - ox),
				 leniency = math.pi * 0.25, -- 90 degree cone
				 move_speed_bonus = t.speed_bonus(self, t),
				 compass = game.level.map:compassDirection(tx-ox, ty-oy)
			})
		end
		game:onTickEnd(give_speed)

		return true
	end,
	info = function(self, t)
		return ([[Use an adjacent friend or foe as a springboard, vaulting over them to another tile within range.
		This maneuver grants you a burst of speed from your momentum, allowing you run %d%% faster (movement speed bonus) in the same direction you vaulted for 3 turns.
		The increased speed ends if you change directions or stop moving.
		]]):tformat(t.speed_bonus(self, t) * 100)
	end,
}

newTalent {
	name = "Tumble",
	short_name = "SKIRMISHER_CUNNING_ROLL",
	type = {"technique/acrobatics", 2},
	require = techs_dex_req2,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) return 20 - cooldown_bonus(self) end,
	no_energy = true,
	message = function(self, t) return _t"@Source@ tumbles to a better position!" end,
	stamina = function(self, t)
		return math.max(0, 20 - stamina_bonus(self))
	end,
	tactical = {SELF = {CLOSEIN = 1, ESCAPE = 1, BUFF = 0.5}},
	on_pre_use = function(self, t, silent, fake)
		if self:attr("never_move") then
			if not silent then game.logPlayer(self, "You cannot move!") end
			return
		end
		return true
	end,
	range = function(self, t)
		return math.floor(self:combatTalentScale(t, 2, 4))
	end,
	target = function(self, t)
		return {type="beam", talent=t, range=self:getTalentRange(t),
			-- Set up grid_params. Desired range depends on if we have a target and the current tactic.
			grid_params = {want_range=(not self.ai_target.actor or self.ai_state.tactic == "escape") and 10 + self:getTalentCooldown(t) or 0, max_delta=-1}
		}
	end,
	combat_physcrit = function(self, t)
		return self:combatTalentScale(t, 2.3, 7.5, 0.75)
	end,
	action = function(self, t)
		local tx, ty, target
		local range = t.range(self, t)
		-- Get Landing Point.
		local tg = self:getTalentTarget(t)
		tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return end
		if game.level.map:checkAllEntities(tx, ty, "block_move", self) or not self:canProject(tg, tx, ty) then
			game.logPlayer(self, "You cannot tumble to that space.")
			return
		end

		print(t.id, "tumbling from", self.x, self.y, "to", tx, ty)
		self:move(tx, ty, true)
		local combat_physcrit = t.combat_physcrit(self, t)
		if combat_physcrit then
			-- Can't set to 0 duration directly, so set to 1 and then decrease by 1.
			self:setEffect("EFF_SKIRMISHER_TACTICAL_POSITION", 1, {combat_physcrit = combat_physcrit})
			local eff = self:hasEffect("EFF_SKIRMISHER_TACTICAL_POSITION")
			eff.dur = eff.dur - 1
		end

		return true
	end,
	info = function(self, t)
		return ([[Move to a spot within range, bounding around, over, or through any enemies in the way.
		This maneuver can surprise your foes and improves your tactical position, improving your physical critical chance by %d%% for 1 turn.]]):tformat(t.combat_physcrit(self, t))
	end
}

newTalent {
	short_name = "SKIRMISHER_TRAINED_REACTIONS",
	name = "Trained Reactions",
	type = {"technique/acrobatics", 3},
	mode = "sustained",
	points = 5,
	cooldown = function(self, t) return 10 - cooldown_bonus(self) end,
	stamina_per_use = function(self, t) return 30 - stamina_bonus(self) end,
	sustain_stamina = 10,
	require = techs_dex_req3,
	tactical = { DEFEND = 2,
		SELF = {STAMINA = function(self, t, target) return -t.stamina_per_use(self, t)/30 end}
	},
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	getLifeTrigger = function(self, t)
		return self:combatTalentLimit(t, 10, 40, 24)
	end,
	getReduction = function(self, t)
		return self:combatTalentLimit(t, 60, 10, 30)
	end,
	-- called by mod/Actor.lua, although it could be a callback one day
	onHit = function(self, t, damage)
		-- Don't have trigger cooldown.

		local cost = t.stamina_per_use(self, t)
		if damage >= self.max_life * t.getLifeTrigger(self, t) * 0.01 then
			
			local nx, ny = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
			if nx and ny and use_stamina(self, cost) then

				-- Apply effect with duration 0.
				self:setEffect("EFF_SKIRMISHER_DEFENSIVE_ROLL", 1, {reduce = t.getReduction(self, t)})
				local eff = self:hasEffect("EFF_SKIRMISHER_DEFENSIVE_ROLL")
				eff.dur = eff.dur - 1

				-- Try to apply bonus effect from Superb Agility.
				local agility = self:getTalentFromId("T_SKIRMISHER_SUPERB_AGILITY")
				local speed = agility.speed_buff(self, agility)
				if speed then
					self:setEffect("EFF_SKIRMISHER_SUPERB_AGILITY", speed.duration, speed)
				end

				return damage * (100-t.getReduction(self, t)) / 100
			end
		end
		return damage
	end,

	info = function(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t)
		local cost = t.stamina_per_use(self, t) * (1 + self:combatFatigue() * 0.01)
		return ([[While this talent is sustained, you anticipate deadly attacks against you.
		Any time you would lose more than %d%% of your maximum life in a single hit, you instead duck out of the way and assume a defensive posture.
		This reduces the triggering damage and all further damage in the same turn by %d%%.
		You need %0.1f Stamina and an adjacent open tile to perform this feat (though it does not cause you to move).]])
		:tformat(trigger, reduce, cost)
	end,
}

newTalent {
	short_name = "SKIRMISHER_SUPERB_AGILITY",
	name = "Superb Agility",
	type = {"technique/acrobatics", 4},
	require = techs_dex_req4,
	mode = "passive",
	points = 5,
	stamina_bonus = function(self, t) return self:combatTalentLimit(t, 18, 3, 10) end, --Limit < 18
	cooldown_bonus = function(self, t) return math.floor(math.max(0, self:combatTalentLimit(t, 10, 1, 5))) end, --Limit < 10
	speed_buff = function(self, t)
		local level = self:getTalentLevel(t)
		if level >= 5 then return {global_speed_add = 0.2, duration = 2} end
		if level >= 3 then return {global_speed_add = 0.1, duration = 1} end
	end,
	info = function(self, t)
		return ([[You gain greater facility with your acrobatic moves, lowering the cooldowns of Vault, Tumble, and Trained Reactions by %d, and their stamina costs by %0.1f.
		At Rank 3 you also gain 10%% global speed for 1 turn after Trained Reactions activates. At rank 5 this speed bonus improves to 20%% and lasts for 2 turns.]])
		:tformat(t.cooldown_bonus(self, t), t.stamina_bonus(self, t))
	end,
}
