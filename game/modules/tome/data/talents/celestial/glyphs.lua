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

local Trap = require "mod.class.Trap"

newTalent{
	name = "Glyphs",
	type = {"celestial/glyphs", 1},
	require = divi_req_high1,
	random_ego = "attack",
	points = 5,
	mode = "sustained",
	cooldown = 5,
	sustain_positive = 5,
	sustain_negative = 5,
	range = function(self, t) return 10 end,
	radius = function(self, t) return 1 end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t} end,
	iconOverlay = function(self, t, p)
		local p = self.sustain_talents[t.id]
		if not p or not p.glyphs_last_turn then return "" end
		local cd = math.ceil(t.getGlyphCD(self, t) - ((game.turn - p.glyphs_last_turn) / 10))
		cd = (cd > 0) and "#RED#"..tostring(cd).."#LAST#" or ""
		return cd, "buff_font"
	end,
	getGlyphCD = function(self, t) return 4 end,
	getDuration = function(self, t)
		if self:knowTalent(self.T_GLYPHS_OF_FURY) then
			local pg = self:getTalentFromId(self.T_GLYPHS_OF_FURY)
			return self:combatTalentLimit(t, 6, 2, 5) + pg.getPersistentDuration(self, pg)
		else
			return self:combatTalentLimit(t, 6, 2, 5)
		end
	end,
	getGlyphDam = function(self, t)
		if self:knowTalent(self.T_GLYPHS_OF_FURY) then
			local pg = self:getTalentFromId(self.T_GLYPHS_OF_FURY)
			return pg.getTriggerDam(self, pg)
		else
			return 0
		end
	end,
	getSunlightHeal = function(self, t) return self:combatTalentSpellDamage(t, 1, 100) end,  -- No crit
	getMoonlightNumb = function(self, t) return math.min(100, self:combatTalentSpellDamage(t, 40, 80)) end,
	getMoonlightNumbDur = function(self, t) return 2 end,
	getTwilightKnockback = function(self, t) return 1 end,
	callbackOnCrit = function(self, t, kind)
		if kind ~= "spell" then return end
		if self:getPositive() < 5 or self:getNegative() < 5 then return nil end
		local p = self:isTalentActive(self.T_GLYPHS)
		if not p then return end
		if p.glyphs_last_turn and ((game.turn - p.glyphs_last_turn) / 10) < t.getGlyphCD(self, t) then return end

		-- Find a target
		-- Invalidate any target with a glyph adjacent
		local valid_for_glyph = function(target)
			local grids = core.fov.circle_grids(target.x, target.y, 1, true)
			local valid = false
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local t = game.level.map(x, y, Map.TRAP)
				if t and t.is_glyph then return false end
			end end
			return true
		end

		-- Prioritize self, else pick a random valid target
		local target
		if valid_for_glyph(self) then
			target = self
		else
			local tgts = {}
			local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, Map.ACTOR)
				if a and self:reactionToward(a) < 0 and valid_for_glyph(a) then
					tgts[#tgts+1] = a
				end
			end end
			if #tgts < 1 then return nil end
			target = rng.tableRemove(tgts)
		end

		-- Set cooldown after we think a glyph can be placed
		p.glyphs_last_turn = game.turn

--target glyphs
		local tg = self:getTalentTarget(t)
		local glyphgrids = {}
		if not self:canProject(tg, target.x, target.y) then return end

		-- Grab all adjacent coordinates that don't have an existing trap or something that blocks movement
		self:project(tg, target.x, target.y, function(px, py)
			local trap = game.level.map(px, py, Map.TRAP)
			if not game.level.map:checkEntity(px, py, Map.TERRAIN, "block_move") and not (trap and trap.is_glyph) then glyphgrids[#glyphgrids+1] = {x=px, y=py} end
		end)

		local dam = self:spellCrit(t.getGlyphDam(self, t))
		local heal = t.getSunlightHeal(self, t)  -- It gets very weird to avoid double crits if this can crit, if thats needed define its value in relation to getGlyphDam
		local numb = t.getMoonlightNumb(self, t)
		local numbDur = t.getMoonlightNumbDur(self, t)
		local dist = t.getTwilightKnockback(self, t)

----------------------------------------------------------------
-- START - Define Glyph Traps - START
----------------------------------------------------------------
local function makeSunGlyph()
	local sun_glyph = Trap.new{
		name = _t"glyph of sunlight",
		is_glyph = "sunlight",
		type = "elemental", id_by_type=true, unided_name = _t"trap",
		display = '^', color=colors.GOLD, image = "trap/trap_glyph_explosion_02_64.png",
		disarmable = false,
		no_disarm_message = true,
		message = false,
		all_know = true,
		always_remember = true,
		faction = self.faction,
		dam = dam,
		heal = heal,
		desc = function(self)
			return ([[Deals %d light damage and heals the summoner for %d]]):tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam), self.heal)
		end,
		canTrigger = function(self, x, y, who)
			if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
			return false
		end,
		triggered = function(self, x, y, who)
			if self.dam then
				self.summoner:project({type="hit", x=x,y=y}, x, y, engine.DamageType.LIGHT, self.dam, {type="light"})
			end
			game.level.map:particleEmitter(x, y, 0, "sunburst", {radius=0, x=x, y=y})
			self.summoner:heal(self.heal, self)
	--divine glyphs buff
			if self.summoner:knowTalent(self.summoner.T_DIVINE_GLYPHS) then
				self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs or 0
				if self.summoner.turn_procs.divine_glyphs < 3 then
					local dg = self.summoner:getTalentFromId(self.summoner.T_DIVINE_GLYPHS)
					local maxStacks = dg.getMaxStacks(self.summoner, dg)
					local dur = dg.getTurns(self.summoner, dg)
					self.summoner:setEffect(self.summoner.EFF_DIVINE_GLYPHS, dur, {maxStacks=maxStacks})
					self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs + 1
				end
			end
			return true, true
		end,
		temporary = t.getDuration(self, t),
		x = tx, y = ty,
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		canAct = false,
		energy = {value=0},
		act = function(self)
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
				game.level:removeEntity(self)
			end
		end,
		summoner = self,
		summoner_gain_exp = true,
	}
	return sun_glyph
end

local function makeMoonGlyph()
	local star_glyph = Trap.new{
		name = _t"glyph of moonlight",
		is_glyph = "moonlight",
		type = "elemental", id_by_type=true, unided_name = _t"trap",
		display = '^', color=colors.GOLD, image = "trap/trap_glyph_fatigue_01_64.png",
		disarmable = false,
		no_disarm_message = true,
		message = false,
		all_know = true,
		always_remember = true,
		faction = self.faction,
		dam = dam,
		numb = numb,
		numbDur = numbDur,
		desc = function(self)
			return ([[Deals %d darkness damage and saps the foes energy, reducing all damage dealt by %d%% for %d turns.]]):
				tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.DARKNESS, self.dam), self.numb, self.numbDur)
		end,
		canTrigger = function(self, x, y, who)
			if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
			return false
		end,
		triggered = function(self, x, y, who)
			if self.dam then
				self.summoner:project({type="hit", x=x,y=y}, x, y, engine.DamageType.DARKNESS, self.dam, {type="light"})
			end
			who:setEffect(who.EFF_GLYPH_OF_MOONLIGHT, self.numbDur, {reduce = self.numb})
			game.level.map:particleEmitter(x, y, 0, "shadow_flash", {radius=0, x=x, y=y})
	--divine glyphs buff
			if self.summoner:knowTalent(self.summoner.T_DIVINE_GLYPHS) then
				self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs or 0
				if self.summoner.turn_procs.divine_glyphs < 3 then
					local dg = self.summoner:getTalentFromId(self.summoner.T_DIVINE_GLYPHS)
					local maxStacks = dg.getMaxStacks(self.summoner, dg)
					local dur = dg.getTurns(self.summoner, dg)
					self.summoner:setEffect(self.summoner.EFF_DIVINE_GLYPHS, dur, {maxStacks=maxStacks})
					self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs + 1
				end
			end
			return true, true
		end,
		temporary = t.getDuration(self, t),
		x = tx, y = ty,
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		canAct = false,
		energy = {value=0},
		act = function(self)
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
				game.level:removeEntity(self)
			end
		end,
		summoner = self,
		summoner_gain_exp = true,
	}
	return star_glyph
end

local function makeTwilightGlyph()
	local twi_glyph = Trap.new{
		name = _t"glyph of twilight",
		is_glyph = "twilight",
		type = "elemental", id_by_type=true, unided_name = _t"trap",
		display = '^', color=colors.GOLD, image = "trap/trap_glyph_repulsion_01_64.png",
		disarmable = false,
		no_disarm_message = true,
		message = false,
		all_know = true,
		always_remember = true,
		faction = self.faction,
		dam = dam,
		dist=dist,
		desc = function(self)
			return ([[Explodes knocking the enemy 1 space in a random direction and dealing %d light and %d darkness damage.]]):tformat(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam/2), engine.interface.ActorTalents.damDesc(self, engine.DamageType.DARKNESS, self.dam/2))
		end,
		canTrigger = function(self, x, y, who)
			if who:reactionToward(self.summoner) < 0 then return mod.class.Trap.canTrigger(self, x, y, who) end
			return false
		end,
		triggered = function(self, x, y, who)
			if self.dam then
				self.summoner:project({type="hit", x=x,y=y}, x, y, engine.DamageType.LIGHT, self.dam/2, {type="light"})
				self.summoner:project({type="hit", x=x,y=y}, x, y, engine.DamageType.DARKNESS, self.dam/2, {type="light"})
			end
			if who:canBe("knockback") then
				local ox, oy = self.x, self.y
				local dir = util.getDir(who.x, who.y, who.old_x, who.old_y)
				self.x, self.y = util.coordAddDir(self.x, self.y, dir)
				who:knockback(self.x, self.y, self.dist)
				self.x, self.y = ox, oy
			end
	--divine glyphs buff
			if self.summoner:knowTalent(self.summoner.T_DIVINE_GLYPHS) then
				self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs or 0
				if self.summoner.turn_procs.divine_glyphs < 3 then
					local dg = self.summoner:getTalentFromId(self.summoner.T_DIVINE_GLYPHS)
					local maxStacks = dg.getMaxStacks(self.summoner, dg)
					local dur = dg.getTurns(self.summoner, dg)
					self.summoner:setEffect(self.summoner.EFF_DIVINE_GLYPHS, dur, {maxStacks=maxStacks})
					self.summoner.turn_procs.divine_glyphs = self.summoner.turn_procs.divine_glyphs + 1
				end
			end
			return true, true
		end,
		temporary = t.getDuration(self, t),
		x = tx, y = ty,
		inc_damage = table.clone(self.inc_damage or {}, true),
		resists_pen = table.clone(self.resists_pen or {}, true),
		canAct = false,
		energy = {value=0},
		act = function(self)
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
				game.level:removeEntity(self)
			end
		end,
		summoner = self,
		summoner_gain_exp = true,
	}
	return twi_glyph
end
----------------------------------------------------------------
-- END - Define Glyph Traps - END
----------------------------------------------------------------
		for _, spot in pairs(glyphgrids) do
			local trap2
			local trap = rng.table{"sun", "star", "twilight"}
			if trap == "sun" then trap2 = makeSunGlyph()
			elseif trap == "star" then trap2 = makeMoonGlyph()
			elseif trap == "twilight" then trap2 = makeTwilightGlyph()
			end

			trap2:identify(true)
			trap2:resolve() trap2:resolve(nil, true)
			trap2:setKnown(self, true)
			game.level:addEntity(trap2)
			game.zone:addEntity(game.level, trap2, "trap", spot.x, spot.y)
			game.level.map:particleEmitter(spot.x, spot.y, 1, "summon")
		end
	end,
	activate = function(self, t)
		local ret = {}
		if core.shader.active() then
			ret.particle1 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=0.8, img="runicshield_yellow"}, {type="lightningshield", time_factor=3000, noup=1.0}))
			ret.particle1.toback = true
			ret.particle2 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=0.8, img="runicshield_dark"}, {type="lightningshield", time_factor=3000, noup=1.0}))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		return true
	end,
	info = function(self, t)
		local dam = t.getGlyphDam(self, t)
		local heal = t.getSunlightHeal(self, t)
		local numb = t.getMoonlightNumb(self, t)
		local numbDur = t.getMoonlightNumbDur(self, t)
		local dist = t.getTwilightKnockback(self, t)
		return ([[When one of your spells goes critical, you bind glyphs in radius 1 centered on a random target in range %d at the cost of 5 positive and 5 negative energy.
		Glyphs last for %d turns and cause various effects when an enemy enters their grid.
		Glyphs will only spawn on enemies that aren't adjacent to an existing glyph and will prioritize your own position if it is valid.
		This can only happen every %d game turns.
		Glyph effects will scale with your Spellpower.

		Avalable glyphs are:
		#ffd700#Glyph of Sunlight#LAST#:  Bind sunlight into a glyph. When triggered it will release a brilliant light, dealing %0.2f light damage and healing you for %d.
		#7f7f7f#Glyph of Moonlight#LAST#:  Bind moonlight into a glyph. When triggered it will release a fatiguing darkness,  dealing %0.2f darkness damage and reducing the foes damage dealt by %d%% for %d turns.
		#9D9DC9#Glyph of Twilight#LAST#:  Bind twilight into a glyph. When triggered it will release a burst of twilight, dealing %0.2f light and %0.2f darkness damage and knocking the foe back %d tiles.
		]]):tformat(self:getTalentRange(t), t.getDuration(self, t), t.getGlyphCD(self, t),
			damDesc(self, DamageType.LIGHT, dam), heal,
			damDesc(self, DamageType.DARKNESS, dam), numb, numbDur,
			damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2), dist)
	end,
}

newTalent{
	name = "Glyphs of Fury",
	type = {"celestial/glyphs", 2},
	require = divi_req_high2,
	random_ego = "attack",
	points = 5,
	mode = "passive",
	getPersistentDuration = function(self, t) return self:combatTalentLimit(t, 6, 2, 5) end,
	getTriggerDam = function(self, t) return self:combatTalentSpellDamage(t, 1, 100) end,
	info = function(self, t)
		local dam = t.getTriggerDam(self, t)
		return ([[Your glyphs are imbued with celestial fury; they last %d turns longer and when triggered they will deal damage.
		#ffd700#Glyph of Sunlight#LAST#:  Deals %0.2f light damage.
		#7f7f7f#Glyph of Moonlight#LAST#:  Deals %0.2f darkness damage.
		#9D9DC9#Glyph of Twilight#LAST#:  Deals %0.2f light and %0.2f darkness damage.]]):tformat(t.getPersistentDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}

newTalent{
	name = "Empowered Glyphs", short_name = "DIVINE_GLYPHS",
	type = {"celestial/glyphs", 3},
	require = divi_req_high3,
	random_ego = "attack",
	points = 5,
	mode = "passive",
	getMaxStacks = function(self, t) return self:combatTalentLimit(t, 6, 2, 5) end,
	getTurns = function(self, t) return self:combatTalentLimit(t, 10, 1, 7) end,
	info = function(self, t)
		return ([[Up to 3 times per turn when one of your glyphs triggers you feel a surge of celestial power, increasing your darkness and light resistance and affinity by 5%% for %d turns, stacking up to %d times.]]):tformat(t.getTurns(self, t), t.getMaxStacks(self, t))
	end,
}

newTalent{
	short_name = "TWILIGHT_GLYPH", -- for minor release save compatibility
	name = "Destabilize Glyphs",
	type = {"celestial/glyphs",4},
	require = divi_req_high4,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) return 20 end,
	negative = 10,
	positive = 10,
	tactical = { ATTACKAREA = {LIGHT = 1, DARKNESS = 1} },
	range = 10,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 0, 5)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 0, 70) end,
	on_pre_use = function(self, t, silent)
		if not game.level then return end
		for _, e in pairs(game.level.entities) do
			local trap = e.is_glyph and e.summoner and e.summoner == self and e
			if trap then
				local a = e.x and e.y and game.level.map(e.x, e.y, engine.Map.ACTOR)
				if a and core.fov.distance(self.x, self.y, e.x, e.y) <= 10 and self:reactionToward(a) < 0 then return true end
			end
		end
		return false
	end,
	action = function(self, t)
		local dam = self:spellCrit(t.getDamage(self, t))
		local dur = t.getDuration(self, t)
		-- Search for applicable glyphs
		for _, e in pairs(game.level.entities) do
			local trap = e.is_glyph and e.summoner and e.summoner == self and e
			if trap then
				local a = e.x and e.y and game.level.map(e.x, e.y, engine.Map.ACTOR)
				if a and core.fov.distance(self.x, self.y, e.x, e.y) <= 10 and self:reactionToward(a) < 0 then
					-- Trigger glyph
					trap:triggered(e.x, e.y, a)
					game.level.map:remove(e.x, e.y, Map.TRAP)
					if self:getTalentLevel(t) >= 2 then
						-- Set map effect
						if trap.is_glyph == "sunlight" then
							game.level.map:addEffect(self, e.x, e.y, dur, DamageType.LIGHT, dam, 0, 5, nil, {type="light_zone"}, nil, false, false)
						elseif trap.is_glyph == "moonlight" then
							game.level.map:addEffect(self, e.x, e.y, dur, DamageType.DARKNESS, dam, 0, 5, nil, {type="shadow_zone"}, nil, false, false)
						else
							game.level.map:addEffect(self, e.x, e.y, dur, DamageType.DARKLIGHT, dam, 0, 5, nil, {type="light_dark_zone"}, nil, false, false)
						end
					end
				end
			end
		end
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[Destabilize your glyphs, triggering every glyph in radius 10 with an enemy standing on it.
		At talent level 2 glyphs triggered this way will leave a residue of themselves on the ground, dealing damage each turn for %d turns.
		#ffd700#Sunlight#LAST#:  %0.2f light damage.
		#7f7f7f#Moonlight#LAST#:  %0.2f darkness damage.
		#9D9DC9#Twilight#LAST#:  %0.2f light and %0.2f darkness damage]]):tformat(t.getDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}
