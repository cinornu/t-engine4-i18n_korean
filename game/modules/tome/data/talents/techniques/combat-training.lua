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
	name = "Thick Skin",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	mode = "passive",
	points = 5,
	require = { stat = { con=function(level) return 14 + level * 9 end }, },
	getRes = function(self, t) return self:combatTalentScale(t, 4, 15, 0.75, 0, 0, true) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists", {all = t.getRes(self, t)})
	end,
	info = function(self, t)
		local res = t.getRes(self, t)
		return ([[Your skin becomes more resilient to damage. Increases resistance to all damage by %0.1f%%.]]):
		tformat(res)
	end,
}

newTalent{
	name = "Heavy Armour Training", short_name = "ARMOUR_TRAINING",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	mode = "passive",
	no_unlearn_last = true,
	points = 5,
	require = {stat = {str = function(level) return 16 + (level + 2) * (level - 1) end}},
	ArmorEffect = function(self, t)  -- Becomes more effective with heavier armors
		if not self:getInven("BODY") then return 0 end
		local am = self:getInven("BODY")[1] or {}
--		if am.subtype == "cloth" then return 0.75
--		elseif am.subtype == "light" then return 1.0
		if am.subtype == "cloth" then return 0
		elseif am.subtype == "light" then return 0
		elseif am.subtype == "heavy" then return 1.5
		elseif am.subtype == "massive" then	return 2.0
		end
		return 0
	end,
	-- Called by _M:combatArmor in mod.class.interface.Combat.lua
	getArmor = function(self, t) return self:combatTalentScale(t, 1, 7, 0.75) * t.ArmorEffect(self, t) end,
	-- Called by _M:combatArmorHardiness in mod.class.interface.Combat.lua
	getArmorHardiness = function(self, t) -- Matches previous progression for "heavy" armor
		return math.max(0, self:combatLimit(self:getTalentLevel(t) * 5 * t.ArmorEffect(self, t), 100, 5, 3.75, 50, 37.5))
	end,
	getCriticalChanceReduction = function(self, t)
		return self:combatTalentScale(t, 1, 9) * t.ArmorEffect(self, t)
	end,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then self:attr("allow_wear_heavy", 1)
		elseif self:getTalentLevelRaw(t) == 2 then self:attr("allow_wear_shield", 1)
		elseif self:getTalentLevelRaw(t) == 3 then self:attr("allow_wear_massive", 1)
		end
	end,
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 0 then self:attr("allow_wear_heavy", -1)
		elseif self:getTalentLevelRaw(t) == 1 then self:attr("allow_wear_shield", -1)
		elseif self:getTalentLevelRaw(t) == 2 then self:attr("allow_wear_massive", -1)
		end

		for inven_id, inven in pairs(self.inven) do if inven.worn then
			for i = #inven, 1, -1 do
				local o = inven[i]
				local ok, err = self:canWearObject(o)
				if not ok then
					game.logPlayer(self, "You cannot use your %s anymore.", o:getName{do_color=true})
					local o = self:removeObject(inven, i, true)
					self:addObject(self.INVEN_INVEN, o)
					self:sortInven()
				end
			end
		end end
	end,
--	getArmorHardiness = function(self, t) return self:getTalentLevel(t) * 10 end,
--	getArmor = function(self, t) return self:getTalentLevel(t) * 2.8 end,
--	getCriticalChanceReduction = function(self, t) return self:getTalentLevel(t) * 3.8 end,
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local criticalreduction = t.getCriticalChanceReduction(self, t)
		local classrestriction = ""
		if self.descriptor and self.descriptor.subclass == "Brawler" then
			classrestriction = _t"(Note that brawlers will be unable to perform many of their talents in massive armour.)"
		end
		if self:knowTalent(self.T_STEALTH) then
			classrestriction = _t"(Note that wearing mail or plate armour will interfere with stealth.)"
		end
		return ([[You become better at using your armour to deflect blows and protect your vital areas. Increases Armour value by %d, Armour hardiness by %d%%, and reduces the chance melee or ranged attacks critically hit you by %d%% with your current body armour.
		(This talent only provides bonuses for heavy mail or massive plate armour.)
		At level 1, it allows you to wear heavy mail armour, gauntlets, helms, and heavy boots.
		At level 2, it allows you to wear shields.
		At level 3, it allows you to wear massive plate armour.
		%s]]):tformat(armor, hardiness, criticalreduction, classrestriction)
	end,
}

-- could fold this into regular armour training to reduce investment
newTalent{
	name = "Light Armour Training",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	mode = "passive",
	levelup_screen_break_line = true,
	points = 5,
	no_npc_use = true,
	require = {stat = {dex = function(level) return 16 + (level + 2) * (level - 1) end}},
	getArmorHardiness = function(self, t)
		return math.max(0, self:combatLimit(self:getTalentLevel(t) * 4, 100, 5, 3.75, 50, 37.5))
	end,
	getDefense = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 50, 500, 0.375)) end, -- net scaling ~^0.75 with level
	getFatigue = function(self, t, fake)
		-- Note: drakeskin body armour @ 8% + drakeskin leather cap @ 5% + drakeskin leather boots @ 5% = 18%
		if fake or self:hasLightArmor() then
			return self:combatTalentLimit(t, 50, 5, 18)
		else return 0
		end
	end,
	callbackOnMove = function(self, t, moved, force, ox, oy)
		if not moved or (ox == self.x and oy == self.y) or not self:hasLightArmor() then return end
		local nb_foes = 0
		local add_if_visible_enemy = function(x, y)
			local target = game.level.map(x, y, game.level.map.ACTOR)
			if target and self:reactionToward(target) < 0 and self:canSee(target) then
				nb_foes = nb_foes + 1
			end
		end
		local adjacent_tg = {type = "ball", range = 0, radius = 1, selffire = false}
		self:project(adjacent_tg, self.x, self.y, add_if_visible_enemy)

		if nb_foes > 0 then
			self:setEffect(self.EFF_MOBILE_DEFENCE, 3, {power=t.getDefense(self,t)/2, stamina=0})
		end
	end,
	info = function(self, t)
		local defense = t.getDefense(self,t)
		return ([[You learn to maintain your agility and manage your combat posture while wearing light armour.  When wearing armour no heavier than leather in your main body slot, you gain %d Defense, %d%% Armour hardiness, and %d%% reduced Fatigue.
		In addition, when you step adjacent to a (visible) enemy, you use the juxtaposition to increase your total Defense by %d for 2 turns.
		The Defense bonus scales with your Dexterity.]]):
		tformat(defense, t.getArmorHardiness(self,t), t.getFatigue(self, t, true), defense/2)
	end,
}

newTalent{
	name = "Combat Accuracy", short_name = "WEAPON_COMBAT",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	points = 5,
	require = { level=function(level) return (level - 1) * 4 end },
	mode = "passive",
	getAttack = function(self, t) return math.floor(self:combatTalentScale(t, 14, 55)) end,
	info = function(self, t)
		local attack = t.getAttack(self, t)
		return ([[Increases the accuracy of unarmed, melee and ranged weapons by %d.]]):
		tformat(attack)
	end,
}

newTalent{
	name = "Weapons Mastery",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	points = 5,
	require = { stat = { str=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases weapon damage by %d%% and physical power by 30 when using swords, axes or maces.]]):
		tformat(100*inc)
	end,
}


newTalent{
	name = "Dagger Mastery", short_name = "KNIFE_MASTERY",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	points = 5,
	require = { stat = { dex=function(level) return 10 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases weapon damage by %d%% and physical power by 30 when using daggers.]]):
		tformat(100*inc)
	end,
}

newTalent{
	name = "Exotic Weapons Mastery",
	type = {"technique/combat-training", 1},
	no_levelup_category_deps = true,
	hide = true,
	points = 5,
	require = { stat = { str=function(level) return 10 + level * 6 end, dex=function(level) return 10 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return 30 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 1.5 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases weapon damage by %d%% and physical power by 30 when using exotic weapons.]]):
		tformat(100*inc)
	end,
}
