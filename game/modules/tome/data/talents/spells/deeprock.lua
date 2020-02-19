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
	name = "Deeprock Form",
	type = {"spell/deeprock", 1},
	require = spells_req_high1,
	points = 5,
	equilibrium = 15,
	mana = 60,
	cooldown = 30,
	tactical = { ATTACK = 5 },
	range = 10,
	radius = function(self, t) return 5 end,
	requires_target = true,
	getTime = function(self, t) return math.floor(self:combatLimit(self:combatTalentSpellDamage(t, 10, 150), 30, 5, 0, 15.3, 103)) end, -- limit < 30
	getDam = function(self, t) return 5 + (self:combatTalentSpellDamage(t, 10, 250) / 10) end,
	getPen = function(self, t) return self:combatTalentLimit(t, 100, 6.6, 13) end, -- Limit < 100%
	getArmor = function(self, t) return self:combatTalentScale(t, 7.3, 11.5, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_DEEPROCK_FORM, t.getTime(self, t), {dam=t.getDam(self, t), pen=t.getPen(self, t), armor=t.getArmor(self, t)})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local xs = ""
		local xsi = ""
		if self:knowTalent(self.T_VOLCANIC_ROCK) then
			xs = xs..(", Arcane damage by %0.1f%% and Arcane damage penetration by %0.1f%%"):
			tformat(self:callTalent(self.T_VOLCANIC_ROCK, "getDam"), self:callTalent(self.T_VOLCANIC_ROCK, "getPen"))
		end
		if self:knowTalent(self.T_BOULDER_ROCK) then
			xs = (", Nature damage by %0.1f%% and Nature damage penetration by %0.1f%%"):
			tformat(self:callTalent(self.T_BOULDER_ROCK, "getDam"), self:callTalent(self.T_BOULDER_ROCK, "getPen"))..xs
		end
		if self:knowTalent(self.T_MOUNTAINHEWN) then
			xsi = (" and %d%% bleeding, poison, disease, and stun immunity"):
			tformat(self:callTalent(self.T_MOUNTAINHEWN, "getImmune")*100)
		end
		return ([[You call upon the very core of the world, harnessing its power to transform your body.
		For %d turns you become a Deeprock Elemental, gaining two size categories%s.
		This increases your Physical damage by %0.1f%% and Physical damage penetration by %0.1f%%%s, and armour by %d.%s
		The effects increase with spellpower.]])
		:tformat(t.getTime(self, t), xsi, t.getDam(self, t),t.getPen(self, t), xs, t.getArmor(self, t), self:getTalentLevel(self.T_MOUNTAINHEWN) >=5 and _t"\nIn addition, you use your physical resistance versus all damage against you." or "")
	end,
}

newTalent{
	name = "Volcanic Rock",
	type = {"spell/deeprock", 2},
	require = spells_req_high2,
	points = 5,
	mode = "passive",
	getDam = function(self, t) return 5 + (self:combatTalentSpellDamage(t, 10, 250) / 10) end,
	getPen = function(self, t) return self:combatTalentLimit(t, 100, 6.6, 13) end, -- Limit < 100%
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_VOLCANO)
		return ([[When you turn into a Deeprock elemental your Arcane damage is increased by %0.1f%%, Arcane damage penetration by %0.1f%% and you gain the power to invoke volcanos:
		%s]]):
		tformat(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString()) -- rescale volcano talent levels?
	end,
}

newTalent{
	name = "Boulder Rock",
	type = {"spell/deeprock", 3},
	require = spells_req_high3,
	points = 5,
	mode = "passive",
	getDam = function(self, t) return 5 + (self:combatTalentSpellDamage(t, 10, 250) / 10) end,
	getPen = function(self, t) return self:combatTalentLimit(t, 100, 6.6, 13) end, -- Limit < 100%
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_THROW_BOULDER)
		return ([[When you turn into a Deeprock elemental your Nature damage is increased by %0.1f%%, Nature damage penetration by %0.1f%% and you gain the power to throw boulders:
		%s]]):
		tformat(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString())
	end,
}

newTalent{
	name = "Mountainhewn",
	type = {"spell/deeprock", 4},
	require = spells_req_high4,
	points = 5,
	mode = "passive",
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.27, 0.55) end, -- Limit < 100%
	info = function(self, t)
		return ([[While in deeprock form, you become indomitable, granting you %d%% resistance to cuts, poisons, diseases and stuns.
		At level 5 and higher, while Deeprock Form is active, all incoming damage is applied against physical resistance instead of the normal resistance type.]]):
		tformat(t.getImmune(self, t)*100)
	end,
}
