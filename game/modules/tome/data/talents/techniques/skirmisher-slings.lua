-- Skirmisher, a class for Tales of Maj'Eyal 1.1.5
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

-- Currently just a copy of Sling Mastery.
newTalent {
	short_name = "SKIRMISHER_SLING_SUPREMACY",
	name = "Sling Supremacy",
	image = "talents/sling_mastery.png",
	type = {"technique/skirmisher-slings", 1},
	points = 5,
	require = { stat = { dex=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	ammo_mastery_reload = function(self, t)
		return math.floor(self:combatTalentScale(t, 0, 2.7, "log"))
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, 'ammo_mastery_reload', t.ammo_mastery_reload(self, t))
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[Increases weapon damage by %d%% and physical power by 30 when using slings.
		Also, increases your reload rate by %d.]]):tformat(inc * 100, reloads)
	end,
}

newTalent {
	short_name = "SKIRMISHER_SWIFT_SHOT",
	name = "Swift Shot",
	type = {"technique/skirmisher-slings", 2},
	require = techs_dex_req2,
	points = 5,
	no_energy = "fake",
	random_ego = "attack",
	tactical = {ATTACK = {archery = 2}},
	range = archery_range,
	cooldown = 5,
	stamina = 15,
	requires_target = true,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "sling") end,
	getDamage = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.4, 1.6)
	end,
	callbackOnMove = function(self, t, moved, force, ox, oy)
		if (self.x == ox and self.y == oy) or force then return end
		local cooldown = self.talents_cd[t.id] or 0
		if cooldown > 0 then
			self.talents_cd[t.id] = math.max(cooldown - 1, 0)
		end
	end,
	speed = function(self, t) return self:getSpeed('archery') * 0.5 end,
	getAttackSpeed = function(self,t) return self:combatTalentLimit(t, 40, 10, 25) end,
	display_speed = function(self, t)
		return ("Double Archery (#LIGHT_GREEN#%d%%#LAST# of a turn)"):
			tformat(self:getSpeed('archery') * 50)
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true, add_speed=self.combat_physspeed})
		if not targets then
			return
		end

		self:archeryShoot(targets, t, nil, {mult=t.getDamage(self, t)})

		-- Cooldown Hurricane Shot by 1.
		local hurricane_cd = self.talents_cd["T_SKIRMISHER_HURRICANE_SHOT"]
		if hurricane_cd then
			self.talents_cd["T_SKIRMISHER_HURRICANE_SHOT"] = math.max(0, hurricane_cd - 1)
		end
		
		self:setEffect(self.EFF_SWIFT_SHOT, 5, {src=self, speed=t.getAttackSpeed(self,t)/100})
		return true
	end,
	info = function(self, t)
		return ([[Fire off a quick sling bullet for %d%% damage at double your normal attack speed, as well as increasing your attack speed by %d%% for 5 turns.
		Each time you move, the cooldown of this talent is reduced by 1.]])
			:tformat(t.getDamage(self, t) * 100, t.getAttackSpeed(self,t))
	end,
}

newTalent {
	short_name = "SKIRMISHER_HURRICANE_SHOT",
	name = "Hurricane Shot",
	type = {"technique/skirmisher-slings", 3},
	require = techs_dex_req3,
	points = 5,
	no_energy = "fake",
	speed = "archery",
	random_ego = "attack",
	tactical = {ATTACKAREA = {weapon = 3}},
	range = 0,
	radius = archery_range,
	cooldown = 7,
	stamina = 45,
	requires_target = true,
	target = function(self, t)
		return {
			type = "cone",
			range = self:getTalentRange(t),
			radius = self:getTalentRadius(t),
			selffire = false,
			talent = t,
			--cone_angle = 50, -- degrees
		}
	end,
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "sling") end,
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.4, 1.2)
	end,
	-- Maximum number of shots fired.
	limit_shots = function(self, t)
		return math.floor(self:combatTalentScale(t, 9, 16, "log"))
	end,
	action = function(self, t)
		-- Get list of possible targets, possibly doubled.
		local double = self:getTalentLevel(t) >= 3
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		local targets = {}
		local add_target = function(x, y)
			local target = game.level.map(x, y, game.level.map.ACTOR)
			if target and self:reactionToward(target) < 0 and self:canSee(target) then
				targets[#targets + 1] = target
				if double then targets[#targets + 1] = target end
			end
		end
		self:project(tg, x, y, add_target)
		if #targets == 0 then return end

		table.shuffle(targets)

		-- Fire each shot individually.
		local limit_shots = t.limit_shots(self, t)
		local shot_params_base = {mult = t.damage_multiplier(self, t), phasing = true}
		local fired = nil -- If we've fired at least one shot.
		for i = 1, math.min(limit_shots, #targets) do
			local target = targets[i]
			local targets = self:archeryAcquireTargets({type = "hit", speed = 200}, {one_shot=true, no_energy = fired, x = target.x, y = target.y})
			if targets then
				local params = table.clone(shot_params_base)
				local target = targets.dual and targets.main[1] or targets[1]
				params.phase_target = game.level.map(target.x, target.y, game.level.map.ACTOR)
				self:archeryShoot(targets, t, {type = "hit", speed = 200}, params)
				fired = true
			else
				-- If no target that means we're out of ammo.
				break
			end
		end

		return fired
	end,
	info = function(self, t)
		return ([[Take aim and unload up to %d shots for %d%% weapon damage each against random enemies inside a cone. Each enemy can only be hit once (twice for talent level 3 and higher). Using Swift Shot lowers the cooldown by 1.]]):tformat(t.limit_shots(self, t),	t.damage_multiplier(self, t) * 100)
	end,
}

newTalent {
	short_name = "SKIRMISHER_BOMBARDMENT",
	name = "Bombardment",
	type = {"technique/skirmisher-slings", 4},
	require = techs_dex_req4,
	points = 5,
	mode = "sustained",
	no_energy = true,
	no_npc_use = true, -- let's not allow NPCs to attack three times a turn for over 100% weapon damage at high TL
	on_pre_use = function(self, t, silent) return archerPreUse(self, t, silent, "sling") end,
	cooldown = function(self, t)
		return 10
	end,
	bullet_count = function(self, t)
		return 3
	end,
	shot_stamina = function(self, t)
		return 20
	end,
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.1, 0.6)
	end,
	activate = function(self, t) return {} end,
	deactivate = function(self, t, p) return true end,
	info = function(self, t)
		return ([[Your Shoot talent now costs %d stamina but fires %d times for %d%% damage per shot.]])
		:tformat(t.shot_stamina(self, t), t.bullet_count(self, t), t.damage_multiplier(self, t) * 100 )
	end,
}
