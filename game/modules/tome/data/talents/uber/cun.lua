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

uberTalent{
	name = "Fast As Lightning",
	mode = "passive",
	not_listed = true,
	trigger = function(self, t, ox, oy)
		local dx, dy = (self.x - ox), (self.y - oy)
		if dx ~= 0 then dx = dx / math.abs(dx) end
		if dy ~= 0 then dy = dy / math.abs(dy) end
		local dir = util.coordToDir(dx, dy, 0)

		local eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)
		if eff and eff.blink then
			if eff.dir ~= dir then
				self:removeEffect(self.EFF_FAST_AS_LIGHTNING)
			else
				return
			end
		end

		self:setEffect(self.EFF_FAST_AS_LIGHTNING, 1, {})
		eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)

		if not eff.dir then eff.dir = dir eff.nb = 0 end

		if eff.dir ~= dir then
			self:removeEffect(self.EFF_FAST_AS_LIGHTNING)
			self:setEffect(self.EFF_FAST_AS_LIGHTNING, 1, {})
			eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)
			eff.dir = dir eff.nb = 0
			game.logSeen(self, "#LIGHT_BLUE#%s slows from critical velocity!", self:getName():capitalize())
		end

		eff.nb = eff.nb + 1

		if eff.nb >= 3 and not eff.blink then
			self:effectTemporaryValue(eff, "prob_travel", 5)
			game.logSeen(self, "#LIGHT_BLUE#%s reaches critical velocity!", self:getName():capitalize())
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, rng.float(-3, -2), (rng.range(0,2)-1) * 0.5, "CRITICAL VELOCITY!", {0,128,255})
			eff.particle = self:addParticles(Particles.new("megaspeed", 1, {angle=util.dirToAngle((dir == 4 and 6) or (dir == 6 and 4 or dir))}))
			eff.blink = true
			game:playSoundNear(self, "talents/thunderstorm")
		end
	end,
	info = function(self, t)
		return ([[When moving over 800%% speed for at least 3 steps in the same direction, you become so fast you can blink through obstacles as if they were not there.
		While moving this fast you have 50%% chances to fully ignore an attack by displacing yourself (this may only happen once per turn).
		Changing direction will break the effect.]])
		:tformat()
	end,
}

uberTalent{
	name = "Tricky Defenses",
	mode = "passive",
	require = { special={desc=_t"Antimagic", fct=function(self) return self:knowTalentType("wild-gift/antimagic") end} },
	-- called by getMax function in Antimagic shield talent definition mod.data.talents.gifts.antimagic.lua
	shieldmult = function(self) return self:combatStatScale("cun", 0.1, 0.5) end,
	info = function(self, t)
		return ([[You are full of tricks and surprises; your Antimagic Shield can absorb %d%% more damage.
		The increase scales with your Cunning.]])
		:tformat(t.shieldmult(self)*100)
	end,
}

uberTalent{
	name = "Endless Woes",
	mode = "passive",
	require = { special={desc=_t"Have dealt over 10000 acid, blight, darkness, mind or temporal damage", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.ACID] and self.damage_log[DamageType.ACID] >= 10000) or
			(self.damage_log[DamageType.BLIGHT] and self.damage_log[DamageType.BLIGHT] >= 10000) or
			(self.damage_log[DamageType.DARKNESS] and self.damage_log[DamageType.DARKNESS] >= 10000) or
			(self.damage_log[DamageType.MIND] and self.damage_log[DamageType.MIND] >= 10000) or
			(self.damage_log[DamageType.TEMPORAL] and self.damage_log[DamageType.TEMPORAL] >= 10000)
		)
	end} },
	getBlight = function(self, t)
		return self:combatStatScale("cun", 1, 20, 0.75), self:combatStatScale("cun", 5, 30, 0.75)
	end,
	getDarkness = function(self, t) return self:combatStatScale("cun", 1, 30, 0.75) end,
	getAcid = function(self, t) return self:combatStatScale("cun", 10, 100, 0.75) end,
	getTemporal = function(self, t) return self:combatStatScale("cun", 1, 40, 0.75) end,
	getMind = function(self, t) return util.bound(self:combatStatScale("cun", 1, 40, 0.75), 0, 50) end,
	range = 10,
	radius = 3,
	dts = {TEMPORAL=true, BLIGHT=true, ACID=true, DARKNESS=true, MIND=true, PHYSICAL=true},
	getThreshold = function(self, t) return 16*self.level end,
	getDamage = function(self, t) return self:combatStatScale("cun", 10, 350) end,
	doProject = function(self, t, damtype, effect, part)
		local tgts = {}
		-- Find everything nearby and pick one at random
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end
		local target = rng.table(tgts)
		if not target then return end
		
		local eff = effect
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
		game.level.map:particleEmitter(target.x, target.y, tg.radius, part, {radius=tg.radius})
		self:project(tg, target.x, target.y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			if not effect.params then return end
			local eff = table.clone(effect, true)

			if not effect.canbe or (effect.canbe and target:canBe(effect.canbe)) then
				eff.params.apply_power = math.max(self:combatSpellpower(), self:combatMindpower())
				target:setEffect(target[effect.id], 5, eff.params)
			end

			self:projectSource({}, target.x, target.y, damtype, t.getDamage(self, t), nil, t)
		end)
	end,
	callbackOnRest = function(self, t) self.endless_woes = {} end, -- No storing damage out of combat
	callbackOnRun = function(self, t) self.endless_woes = {} end,
	callbackOnDealDamage = function(self, t, value, target, dead, death_note)
		if not death_note then return end
		if not death_note.damtype then return end
		local damtype = death_note.damtype
		if not t.dts[damtype] then return end
		self.endless_woes = self.endless_woes or {}
		self.endless_woes[damtype] = (self.endless_woes[damtype] or 0) + value

		if self.endless_woes[damtype] > t.getThreshold(self, t) then
			self.endless_woes[damtype] = 0
			if damtype == DamageType.TEMPORAL and not self:hasProc("endless_woes_temporal") then
				self:setProc("endless_woes_temporal", true, 10)
				game.logSeen(self, "You unleash a blast of #LIGHT_STEEL_BLUE#temporal#LAST# energy!", self:getName():capitalize())
				t.doProject(self, t, damtype, {id="EFF_SLOW", dur=5, params={power=0.3}, canbe="slow"}, "ball_temporal")
			elseif damtype == DamageType.BLIGHT and not self:hasProc("endless_woes_blight") then
				self:setProc("endless_woes_blight", true, 10)				
				game.logSeen(self, "You unleash a blast of #DARK_GREEN#virulent blight!#LAST#!", self:getName():capitalize())
				local dam, stat = t.getBlight(self, t)
				t.doProject(self, t, damtype, {id="EFF_WOEFUL_DISEASE", dur=5, params = {src=self, dam=dam, str=stat, con=stat, dex=stat}, canbe="disease"}, "ball_blight")
			elseif damtype == DamageType.ACID and not self:hasProc("endless_woes_acid") then
				self:setProc("endless_woes_acid", true, 10)
				local dam = t.getAcid(self, t)
				game.logSeen(self, "You unleash a blast of #GREEN#acid#LAST#!", self:getName():capitalize())
				t.doProject(self, t, damtype, {id="EFF_WOEFUL_CORROSION", dur=5, params={src=self, dam=dam}}, "ball_acid")
			elseif damtype == DamageType.DARKNESS and not self:hasProc("endless_woes_darkness") then
				self:setProc("endless_woes_darkness", true, 10)
				game.logSeen(self, "You unleash a blast of numbing #GREY#darkness#LAST#!", self:getName():capitalize())
				t.doProject(self, t, damtype, {id="EFF_WOEFUL_DARKNESS", dur=5, params={reduce=t.getDarkness(self, t)}}, "shadow_flash")
			elseif damtype == DamageType.MIND and not self:hasProc("endless_woes_mind") then
				self:setProc("endless_woes_mind", true, 10)
				game.logSeen(self, "You unleash a confusing blast of #YELLOW#mental#LAST# energy!", self:getName():capitalize())
				t.doProject(self, t, damtype, {id="EFF_CONFUSED", dur=5, params={power=t.getMind(self, t)}, canbe="confusion"}, "starfall")
			elseif damtype == DamageType.PHYSICAL and not self:hasProc("endless_woes_physical") then
				self:setProc("endless_woes_physical", true, 10)
				game.logSeen(self, "You unleash a crippling blast of earthen energy!", self:getName():capitalize())
				t.doProject(self, t, damtype, {id="EFF_WOEFUL_CRIPPLE", dur=5, params={power=0.2}}, "ball_earth")
			end
		end
	end,
	info = function(self, t)
		local blight_dam, blight_disease = t.getBlight(self, t)
		local cooldowns = {}
		local str = ""
		-- Display the remaining cooldowns in the talent tooltip only if its learned
		if self:knowTalent(self.T_ENDLESS_WOES) then
			for dt, _ in pairs(t.dts) do
				local proc = self:hasProc("endless_woes_"..dt:lower())
				if proc then cooldowns[#cooldowns+1] = DamageType:get(DamageType[dt]).name:capitalize()..": "..proc.turns end
			end
			str = _t"(Cooldowns)".."\n"..table.concat(cooldowns, "\n")
		end
		return ([[Surround yourself with a malevolent aura that stores damage you deal.
		Whenever you have stored %d damage of one type you unleash a powerful blast at a random enemy dealing %d damage of that type in radius %d and applying one of the following effects:

		Physical:		Slows combat, mind, and spell speed by 20%%.
		#GREEN#Acid:#LAST#  Deals %d acid damage each turn for 5 turns (%d total).
		#DARK_GREEN#Blight:#LAST#  Deals %d blight damage each turn for 5 turns and reduces strength, constitution, and dexterity by %d.
		#GREY#Darkness:#LAST#  Reduces damage dealt by %d%% for 5 turns.
		#LIGHT_STEEL_BLUE#Temporal:#LAST#  Slows global action speed by %d%% for 5 turns.
		#ORANGE#Mind:#LAST#  Confuses (power %d%%) for 5 turns.

		Each effect can only happen once per 10 player turns.  This does not count as a typical cooldown.
		The damage and effect power increase with your Cunning, the threshold with your level, and the apply power is the highest of your mind or spell power.
		%s]])
		:tformat(t.getThreshold(self, t), t.getDamage(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ACID, t.getAcid(self, t)), damDesc(self, DamageType.ACID, t.getAcid(self, t)*5), blight_dam, blight_disease, t.getDarkness(self, t), t.getTemporal(self, t), t.getMind(self, t), str)
	end,
}

-- Item rarities
uberTalent{
	name = "Secrets of Telos",
	mode = "passive",
	require = { special={desc=_t"Possess Telos Top Half, Telos Bottom Half, and Telos Staff Crystal", fct=function(self)
		local o1 = self:findInAllInventoriesBy("define_as", "GEM_TELOS")
		local o2 = self:findInAllInventoriesBy("define_as", "TELOS_TOP_HALF")
		local o3 = self:findInAllInventoriesBy("define_as", "TELOS_BOTTOM_HALF")
		return o1 and o2 and o3
	end} },
	cant_steal = true,
	np_npc_use = true,
	on_learn = function(self, t)
		if not game.party:hasMember(self) then return end
		local list = mod.class.Object:loadList("/data/general/objects/special-artifacts.lua")
		local o = game.zone:makeEntityByName(game.level, list, "TELOS_SPIRE", true)
		if o then
			o:identify(true)
			self:addObject(self.INVEN_INVEN, o)

			local o1, item1, inven1 = self:findInAllInventoriesBy("define_as", "GEM_TELOS")
			if item1 and inven1 then self:removeObject(inven1, item1, true) end
			local o2, item2, inven2 = self:findInAllInventoriesBy("define_as", "TELOS_TOP_HALF")
			if item2 and inven2 then self:removeObject(inven2, item2, true) end
			local o3, item3, inven3 = self:findInAllInventoriesBy("define_as", "TELOS_BOTTOM_HALF")
			if item3 and inven3 then self:removeObject(inven3, item3, true) end

			self:sortInven()

			game.logSeen(self, "#VIOLET#%s assembles %s!", self:getName():capitalize(), o:getName{do_colour=true, no_count=true})
		end
	end,
	info = function(self, t)
		return ([[You have obtained the three parts of the Staff of Telos and studied them carefully. You believe that you can merge them back into a single highly potent staff.]])
		:tformat()
	end,
}

uberTalent{
	name = "Elemental Surge",
	mode = "passive",
	require = { special={desc=_t"Have dealt over 10000 arcane, fire, cold, lightning, light or nature damage", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.ARCANE] and self.damage_log[DamageType.ARCANE] >= 10000) or
			(self.damage_log[DamageType.FIRE] and self.damage_log[DamageType.FIRE] >= 10000) or
			(self.damage_log[DamageType.COLD] and self.damage_log[DamageType.COLD] >= 10000) or
			(self.damage_log[DamageType.LIGHTNING] and self.damage_log[DamageType.LIGHTNING] >= 10000) or
			(self.damage_log[DamageType.LIGHT] and self.damage_log[DamageType.LIGHT] >= 10000) or
			(self.damage_log[DamageType.NATURE] and self.damage_log[DamageType.NATURE] >= 10000)
		)
	end} },
	dts = {PHYSICAL=true, ARCANE=true, LIGHT=true, COLD=true, LIGHTNING=true, FIRE=true, NATURE=true,},	
	getCold = function(self, t)
		return {
			armor = self:combatStatScale("cun", 10, 30, 0.75),
			dam = math.max(100, self:getCun()),
		}
	end,
	getLight = function(self, t) return 20 end,
	getLightning = function(self, t) return self:combatStatScale("cun", 200, 500, 0.75) end,
	getFire = function(self, t) return 30 end,
	range = 10,
	radius = 3,
	getThreshold = function(self, t) return 16*self.level end,
	getDamage = function(self, t) return self:combatStatScale("cun", 10, 350) end,
	doProject = function(self, t, damtype, part)
		local tgts = {}
		-- Find everything nearby and pick one at random
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end
		local target = rng.table(tgts)
		if not target then return end
		
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
		game.level.map:particleEmitter(target.x, target.y, tg.radius, part, {radius=tg.radius})
		self:projectSource(tg, target.x, target.y, damtype, t.getDamage(self, t), nil, t)
	end,
	callbackOnRest = function(self, t) self.elemental_surge = nil end, -- No storing damage out of combat
	callbackOnRun = function(self, t) self.elemental_surge = nil end,
	callbackOnDealDamage = function(self, t, value, target, dead, death_note)
		local damtype = death_note and death_note.damtype
		if not damtype then return end
		if not t.dts[damtype] then return end
		self.elemental_surge = self.elemental_surge or {}
		self.elemental_surge[damtype] = (self.elemental_surge[damtype] or 0) + value

		if self.elemental_surge[damtype] > t.getThreshold(self, t) then
			self.elemental_surge[damtype] = 0
			if damtype == DamageType.PHYSICAL and not self:hasProc("elemental_surge_physical") then
				self:setProc("elemental_surge_physical", true, 10)
				game.logSeen(self, "%s surges with earthen power!", self:getName():capitalize())
				self:removeEffectsFilter({status="detrimental", type="physical", ignore_crosstier=true}, 1)
				self:setEffect(self.EFF_ELEMENTAL_SURGE_PHYSICAL, 2, {})
				t.doProject(self, t, damtype, "ball_earth")
			elseif damtype == DamageType.ARCANE and not self:hasProc("elemental_surge_arcane") then
				self:setProc("elemental_surge_arcane", true, 10)
				game.logSeen(self, "%s surges with #PURPLE#arcane#LAST# power!", self:getName():capitalize())
				self:setEffect(self.EFF_ELEMENTAL_SURGE_ARCANE, 3, {})
				t.doProject(self, t, damtype, "ball_arcane")
			elseif damtype == DamageType.FIRE and not self:hasProc("elemental_surge_fire") then
				self:setProc("elemental_surge_fire", true, 10)
				game.logSeen(self, "%s surges with #LIGHT_RED#fiery#LAST# power!", self:getName():capitalize())
				self:setEffect(self.EFF_ELEMENTAL_SURGE_FIRE, 3, {damage = t.getFire(self, t)})
				t.doProject(self, t, damtype, "ball_fire")
			elseif damtype == DamageType.COLD and not self:hasProc("elemental_surge_cold") then
				self:setProc("elemental_surge_cold", true, 10)
				game.logSeen(self, "%s surges with #1133F3#icy#LAST# power!", self:getName():capitalize()) 
				self:setEffect(self.EFF_ELEMENTAL_SURGE_COLD, 3, t.getCold(self, t) )
				t.doProject(self, t, damtype, "ball_ice")
			elseif damtype == DamageType.LIGHTNING and not self:hasProc("elemental_surge_lightning") then
				self:setProc("elemental_surge_lightning", true, 10)
				game.logSeen(self, "%s surges with #ROYAL_BLUE#lightning#LAST# power!", self:getName():capitalize())
				self:setEffect(self.EFF_ELEMENTAL_SURGE_LIGHTNING, 2, {move = t.getLightning(self, t)})
				t.doProject(self, t, damtype, "ball_lightning")
			elseif damtype == DamageType.LIGHT and not self:hasProc("elemental_surge_light") then
				self:setProc("elemental_surge_light", true, 10)
				game.logSeen(self, "%s surges with #YELLOW#light#LAST# power!", self:getName():capitalize())
				self:setEffect(self.EFF_ELEMENTAL_SURGE_LIGHT, 3, {cooldown = t.getLight(self, t)})
				t.doProject(self, t, damtype, "ball_light")				
			elseif damtype == DamageType.NATURE and not self:hasProc("elemental_surge_nature") then
				self:setProc("elemental_surge_nature", true, 10)
				game.logSeen(self, "%s surges with #LIGHT_GREEN#natural#LAST# power!", self:getName():capitalize())
				self:removeEffectsFilter({status="detrimental", type="magical", ignore_crosstier=true}, 1)
				self:setEffect(self.EFF_ELEMENTAL_SURGE_NATURE, 2, {})
				t.doProject(self, t, damtype, "slime")
			end
		end
	end,
	info = function(self, t)
		local cooldowns = {}
		local str = ""
		local cold = t.getCold(self, t)
		-- Display the remaining cooldowns in the talent tooltip only if its learned
		if self:knowTalent(self.T_ELEMENTAL_SURGE) then
			for dt, _ in pairs(t.dts) do
				local proc = self:hasProc("elemental_surge_"..dt:lower())
				if proc then cooldowns[#cooldowns+1] = DamageType:get(DamageType[dt]).name:capitalize()..": "..proc.turns end
			end
		str = _t"(Cooldowns)".."\n"..table.concat(cooldowns, "\n")
		end
		return ([[Surround yourself with an elemental aura that stores damage you deal.
		Whenever you have stored %d damage of one type you unleash a powerful blast at a random enemy dealing %d damage of that type in radius %d and granting you one of the following effects:

		Physical:		Cleanses 1 physical debuff and grant immunity to physical debuffs for 2 turns.
		#PURPLE#Arcane:#LAST#		Increases your mind and spell action speeds by 30%% for 3 turns.
		#LIGHT_RED#Fire:#LAST#		Increases all damage dealt by %d%% for 3 turns.
		#1133F3#Cold:#LAST#		Turns your skin into ice for 3 turns increasing armor by %d and dealing %d ice damage to attackers.
		#ROYAL_BLUE#Lightning:#LAST#	Increases your movement speed by %d%% for 2 turns.
		#YELLOW#Light:#LAST#		Reduces all cooldowns by 20%% for 3 turns.
		#LIGHT_GREEN#Nature:#LAST#		Cleanses 1 magical debuff and grant immunity to magical debuffs for 2 turns.

		Each effect can only happen once per 10 player turns.  This does not count as a typical cooldown.
		The damage and some effect powers increase with your Cunning and the threshold with your level.
		%s]])
		:tformat(t.getThreshold(self, t), t.getDamage(self, t), self:getTalentRadius(t), t.getFire(self, t), cold.armor, cold.dam, t.getLightning(self, t), str)
	end,
}

eye_of_the_tiger_data = {
	physical = {
		desc = _t"All physical criticals reduce the remaining cooldown of a random technique or cunning talent by 2.",
		types = { "^technique/", "^cunning/" },
		reduce = 2,
	},
	spell = {
		desc = _t"All spell criticals reduce the remaining cooldown of a random spell/corruption/celestial/chronomancy talent by 2.",
		types = { "^spell/", "^corruption/", "^celestial/", "^chronomancy/" },
		reduce = 2,
	},
	mind = {
		desc = _t"All mind criticals reduce the remaining cooldown of a random wild gift/psionic/afflicted talent by 2.",
		types = { "^wild%-gift/", "^cursed/", "^psionic/" },
		reduce = 2,
	},
}

uberTalent{
	name = "Eye of the Tiger",
	mode = "passive",
	trigger = function(self, t, kind)
		local kind_str = "eye_tiger_"..kind
		if self:hasProc(kind_str) then return end

		local tids = {}

		for tid, _ in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if not t.fixed_cooldown then
				local ok = false
				local d = eye_of_the_tiger_data[kind]
				if d then for _, check in ipairs(d.types) do
						if t.type[1]:find(check) then ok = true break end
				end end
				if ok then
					tids[#tids+1] = tid
				end
			end
		end
		if #tids == 0 then return end
		local tid = rng.table(tids)
		local d = eye_of_the_tiger_data[kind]
		self.talents_cd[tid] = self.talents_cd[tid] - (d and d.reduce or 1)
		if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
		self.changed = true
		self:setProc(kind_str)
	end,
	info = function(self, t)
		local list = {}
		for _, d in pairs(eye_of_the_tiger_data) do list[#list+1] = d.desc end
		return ([[%s		
		This can only happen once per turn per type, and cannot affect the talent that triggers it.]])
		:tformat(table.concat(list, "\n"))
	end,
}

uberTalent{
	name = "Worldly Knowledge",
	mode = "passive",
	cant_steal = true,
	no_npc_use = true,
	on_learn = function(self, t, kind)
		if not game.party:hasMember(self) then return end
		local Chat = require "engine.Chat"
		local chat = Chat.new("worldly-knowledge", {name=_t"Worldly Knowledge"}, self)
		chat:invoke()
	end,
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "unused_generics", 5)
	end,
	info = function(self, t)
		return ([[Gain 5 generic talent points and learn a new talent category from one of the below at 1.0 mastery, unlocked. Group 1 categories are available to anyone; Group 2 are available only to people without any spells or runes, and Group 3 are not available to followers of Zigur.
		GROUP 1:
		- Technique / Conditioning
		- Cunning / Survival
		- Wild Gift / Harmony
		GROUP 2:
		- Wild Gift / Call of the Wild
		- Wild Gift / Mindstar Mastery
		- Psionic / Dreaming
		- Psionic / Augmented Mobility
		- Psionic / Feedback
		GROUP 3:
		- Spell / Divination
		- Spell / Staff Combat
		- Spell / Stone Alchemy
		- Corruption / Vile Life
		- Corruption / Hexes
		- Corruption / Curses
		- Celestial / Chants
		- Chronomancy / Chronomancy]])
		:tformat()
	end,
}

-- Re-used icon
uberTalent{
	name = "Adept", image = "talents/meditation.png",
	mode = "passive",
	cant_steal = true,
	info = function(self, t)
		return ([[Your talent masteries are increased by 0.3.  Note that many talents will not benefit from this increase.]])
		:tformat()
	end,
	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "talents_mastery_bonus", {all = 0.3})
		
		if not self._updating_adept then
			self._updating_adept = true
			self:updateAllTalentsPassives()
			self._updating_adept = nil
		end
	end,
}

uberTalent{
	name = "Tricks of the Trade",
	mode = "passive",
	cant_steal = true,
	require = { special={desc=_t"Have sided with the Assassin Lord", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:isQuestStatus("lost-merchant", engine.Quest.COMPLETED, "evil")) end} },
	on_learn = function(self, t) 
		if self:knowTalentType("cunning/stealth") then
			self:setTalentTypeMastery("cunning/stealth", self:getTalentTypeMastery("cunning/stealth") + 0.2)
		elseif self:knowTalentType("cunning/stealth") == false then
			self:learnTalentType("cunning/stealth", true)
		end
		if self:knowTalentType("cunning/scoundrel") then
			self:setTalentTypeMastery("cunning/scoundrel", self:getTalentTypeMastery("cunning/scoundrel") + 0.1)
		else
			self:learnTalentType("cunning/scoundrel", true)
			self:setTalentTypeMastery("cunning/scoundrel", 0.9)
		end
		self.invisible_damage_penalty_divisor = (self.invisible_damage_penalty_divisor or 0) + 2
	end,
	info = function(self, t)
		return ([[You have friends in low places and have learned some underhanded tricks.
		Gain 0.2 Category Mastery to the Cunning/Stealth Category (or unlock it, if you have the tree and it is locked), and either gain +0.1 to the Cunning/Scoundrel category or learn and unlock the category at 0.9 if you lack it.
		Additionally, all of your damage penalties from invisibility are permanently halved.]]):
		tformat()
	end,
}
