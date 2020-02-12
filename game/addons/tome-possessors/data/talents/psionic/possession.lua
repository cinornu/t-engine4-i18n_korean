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

local Dialog = require "engine.ui.Dialog"

for i = 1, 8 do
	newTalent{
		name = ("Possession Talent %d"):tformat(i),
		short_name = "POSSESSION_TALENT_" .. i,
		type = {"psionic/other", 1},
		no_unlearn_last = true,
		points = 1,
		no_npc_use = true,
		on_pre_use = function(self, t, silent) if not silent then game.logPlayer(self, "You must assume a form to use that form's talents.") end return false end,
		action = function(self, t)
			return true
		end,
		info = function(self, t)
			return ([[When you assume a form, this talent will be replaced with one of the body's talents.
			The only use for this talent is to pre-organize your hotkeys bar.]]):
			tformat()
		end,
	}
end

local function bodies_desc(self)
	if #self.bodies_storage < 1 then return _t"none" end
	local b_list = ""
	for i, store in ipairs(self.bodies_storage) do
		local body = store.body
		local name = body:getName()
		if #name > 18 then name = string.sub(name, 1, 15).."..." end
		name = name:bookCapitalize()
		local in_use = body._in_possession and body:getDisplayString() or " "
		local _, rankcolor = body:TextRank()
		b_list = b_list..("\n%s%s%d)%s#LAST# (#LIGHT_BLUE#lv %d#LAST#, #LIGHT_RED#HP:%d/%d#LAST#)"):tformat(in_use, rankcolor, store.uses, name, body.level, body.life, body.max_life)
	end
	return b_list
end

newTalent{
	name = "Destroy Body",
	type = {"psionic/other", 1},
	no_unlearn_last = true,
	points = 1,
	no_npc_use = true,
	no_energy = true,
	on_pre_use = function(self, t, silent) if #self.bodies_storage == 0 then if not silent then game.logPlayer(self, "You have no stored bodies to delete.") end return false end return true end,
	action = function(self, t)
		package.loaded['mod.dialogs.AssumeForm'] = nil
		self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "destroy"))
		return true
	end,
	info = function(self, t)
		return ([[Discard a body from your psionic reserve.
		Bodies possessed:
		%s]]):
		tformat(bodies_desc(self))
	end,
}

-- Possible problematic talents: Multiply
-- should this go on cooldown after death?
newTalent{
	name = "Assume Form",
	type = {"psionic/other", 1},
	no_unlearn_last = true,
	points = 1,
	no_npc_use = true,
	cooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 18, 10, true)) end,
	psi = function(self, t) if not self:hasEffect(self.EFF_POSSESSION) then return 10 else return 0 end end,
	autolearn_talent = "T_DESTROY_BODY",
	isUsableTalent = function(self, _, checkt, mode)
		if checkt.no_player_use or checkt.cant_steal or checkt.is_inscription or checkt.hide == "always" or checkt.no_unlearn_last then return false end
		if checkt.type and checkt.type[1] == "misc/objects" then return false end
		if mode == nil then return true end
		if mode == "passive" and checkt.mode ~= "passive" then return false end
		if mode == "activated" and checkt.mode ~= "activated" then return false end
		if mode == "sustained" and checkt.mode ~= "sustained" then return false end
		if mode == false and checkt.mode ~= "passive" then return false end
		if mode == true and checkt.mode ~= "activated" and checkt.mode ~= "sustained" then return false end
		return true
	end,
	on_pre_use = function(self, t, silent) if #self.bodies_storage == 0 and not self:hasEffect(self.EFF_POSSESSION) then if not silent then game.logPlayer(self, "You have no stored bodies to use.") end return false end return true end,
	action = function(self, t)
		if self:hasEffect(self.EFF_POSSESSION) then
			self:removeEffect(self.EFF_POSSESSION, false, true)
		else
			package.loaded['mod.dialogs.AssumeForm'] = nil
			local body = self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "possess"))
			if not body then return false end

			-- Weissi prevention ;)
			if (self.subtype == "yeek" or (self.descriptor and self.descriptor.race == "Yeek")) and (body.subtype == "yeti") then
				game.logPlayer(self, "#CRIMSON#A strange feeling comes over you as two words imprint themselves on your mind: '#{italic}#Not yet.#{normal}#'")
				return false
			end

			self:setEffect(self.EFF_POSSESSION, 1, {body = body})
			game:onTickEnd(function() self.talents_cd[self.T_ASSUME_FORM] = nil end)
		end
		return true
	end,
	info = function(self, t)
		return ([[You call upon one of your reserve bodies, assuming its form.
		A body used this way may not be healed in any way.
		You can choose to exit the body at any moment by using this talent again, returning it to your reserve as it is.
		When you reach 0 life you are forced out of it and the shock deals %d%% of the maximum life of your normal body to you while reducing your movement speed by 50%% and your damage by 60%% for 6 turns.
		The cooldown only starts when you resume your normal form.
		While in another body all experience you gain still goes to you but will not be applied until you revert back.
		While in another body your currently equiped objects are #{italic}#merged#{normal}# in you, you can not take them of or wear new ones.
		Bodies possessed:
		%s]]):
		tformat(self:callTalent(self.T_POSSESS, "getShock"), bodies_desc(self))
	end,
}

newTalent{
	name = "Possess",
	type = {"psionic/possession", 1},
	require = psi_wil_req1,
	no_unlearn_last = true,
	autolearn_talent = "T_ASSUME_FORM",
	points = 5,
	cooldown = 30,
	psi = 30,
	no_npc_use = true,
	range = 3,
	requires_target = true,
	on_learn = function(self, t)
		self.possess_allowed_extra_types = self.possess_allowed_extra_types or {}
		if not self:knowTalent(self.T_POSSESSION_TALENT_1) then self:learnTalent(self.T_POSSESSION_TALENT_1, true) end
		if not self:knowTalent(self.T_POSSESSION_TALENT_2) then self:learnTalent(self.T_POSSESSION_TALENT_2, true) end
	end,
	allowedTypes = function(self, t, type)
		if type == "animal" then return true end
		if type == "humanoid" then return true end
		if self.possess_allowed_extra_types and self.possess_allowed_extra_types[type] then return true end
		return false
	end,
	allowedTypesExtraNb = function(self, t) return 1 + math.ceil(self:getTalentLevel(t) * 0.7) - (self.possess_allowed_extra_types and table.count(self.possess_allowed_extra_types) or 0) end,
	allowedRank = function(self, t, rank)
		if rank <= 2 then return true end
		if rank <= 3 and self:getTalentLevel(t) >= 3 then return true end
		if rank <= 3.5 and self:getTalentLevel(t) >= 5 then return true end
		if rank <= 4 and self:getTalentLevel(t) >= 7 then return true end
		return false
	end,
	getMaxTalents = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end, -- unused?
	getShock = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 50, 16)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 400) / t.getDur(self, t) end,
	getDur = function(self, t) return math.ceil(self:combatTalentScale(t, 5, 10)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), selffire=false, talent=t} end,
	on_pre_use = function(self, t, silent) if not self:callTalent(self.T_BODIES_RESERVE, "hasRoom") then if not silent then game.logPlayer(self, "You do not have enough room in your bodies storage.") end return false else return true end end,
	basicAbsorbCheck = function(self, t, target, allow_learn_extra_type)
		if target._possessor_already_snatched then return nil end
		if target.immune_possession then game.logPlayer(self, "This creature is immune to possession.") return nil end
		if target.summoner == self then game.logPlayer(self, "You may not possess a creature which you summoned.") return nil end
		if target.summoner_time or target.summoner then game.logPlayer(self, "You may not possess a creature which has an expiration time or a master.") return nil end
		if not t.allowedRank(self, t, target.rank) then local ranktext, rankcolor = target:TextRank() game.logPlayer(self, "You may not possess a creature of this rank (%s%s#LAST#).", rankcolor, ranktext) return nil end
		return true
	end,
	absorbCheck = function(self, t, target, allow_learn_extra_type)
		local ret = t.basicAbsorbCheck(self, t, target)
		if not ret then return end
		
		local type_allowed = t.allowedTypes(self, t, target.type)
		if not type_allowed and t.allowedTypesExtraNb(self, t) > 0 and allow_learn_extra_type then
			self:talentDialog(Dialog:yesnoPopup(_t"Possess", ("Permanently learn to possess creatures of type #LIGHT_BLUE#%s#LAST# (you may only do that a few times, based on talent level) ?"):tformat(tostring(_t(target.type))), function()end, _t"No", _t"Yes", true, nil, function(r) if not r then
				self.possess_allowed_extra_types = self.possess_allowed_extra_types or {}
				self.possess_allowed_extra_types[tostring(target.type)] = true
				type_allowed = true
			end end))
		end
		if not type_allowed then game.logPlayer(self, "You may not possess this kind of creature.") return nil end

		if not self:callTalent(self.T_BODIES_RESERVE, "hasRoom") then game.logPlayer(self, "You have no more room available to store a new body.") return end
		return true
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target or target == self then return nil end

		if not t.absorbCheck(self, t, target, true) then return nil end
		if target.dead then game.logPlayer(self, "Your target is dead!") return nil end

		target:setEffect(target.EFF_POSSESS, t.getDur(self, t), {apply_power=self:combatMindpower(), src=self, power=t.getDamage(self, t)})
		return true
	end,
	info = function(self, t)
		local fake = {rank=2}
		local rt0, rc0 = self.TextRank(fake)
		fake.rank = 3; local rt3, rc3 = self.TextRank(fake)
		fake.rank = 3.5; local rt5, rc5 = self.TextRank(fake)
		fake.rank = 4; local rt7, rc7 = self.TextRank(fake)

		return ([[You cast a psionic web at a target that lasts for %d turns. Each turn it deals %0.2f mind damage.
		If the target dies with the web in place you will capture its body and store it in a hidden psionic reserve.
		At any further time you can use the Assume Form talent to temporarily shed your own body and assume your new form, strengths and weaknesses both.
		You may only use this power if you have room for a new body in your storage.

		You may only steal the body of creatures of the following rank %s%s#LAST# or lower.
		At level 3 up to rank %s%s#LAST#.
		At level 5 up to rank %s%s#LAST#.
		At level 7 up to rank %s%s#LAST#.

		You may only steal the body of creatures of the following types: #LIGHT_BLUE#%s#LAST#
		When you try to possess a creature of a different type you may learn this type permanently, you can do that %d more times.]]):
		tformat(
			t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDamage(self, t)),
			rc0, rt0, rc3, rt3, rc5, rt5, rc7, rt7,
			table.concat(table.ts(table.append({"humanoid", "animal"}, table.keys(self.possess_allowed_extra_types or {}))), ", "), t.allowedTypesExtraNb(self, t)
		)
	end,
}

newTalent{
	name = "Self Persistence",
	type = {"psionic/possession", 2},
	require = psi_wil_req2,
	points = 5,
	mode = "passive",
	no_npc_use = true,
	no_unlearn_last = true,
	getPossessScale = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 100, 20)) end,
	info = function(self, t)
		return ([[When you assume the form of an other body you can still keep %d%% of the values (defences, crits, powers, save, ...) of your own body.]]):
		tformat(100 - t.getPossessScale(self, t))
	end,
}

newTalent{
	name = "Improved Form",
	type = {"psionic/possession", 3},
	require = psi_wil_req3,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	no_unlearn_last = true,
	getMaxTalentsLevel = function(self, t) return math.max(1, math.floor(self:getTalentLevel(t))) end,
	getPossessScale = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 40, 90)) end,
	info = function(self, t)
		return ([[When you assume the form of another body you gain %d%% of the values (defences, crits, powers, save, ...) of the body.
		In addition talents gained from bodies are limited to level %0.1f.]]):
		tformat(t.getPossessScale(self, t), t.getMaxTalentsLevel(self, t))
	end,
}

newTalent{
	name = "Full Control",
	type = {"psionic/possession", 4},
	require = psi_wil_req4,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	no_unlearn_last = true,
	on_levelup_close = function(self, t)
		for i = 3, t.getNbTalents(self, t) do
			if not self:knowTalent(self['T_POSSESSION_TALENT_'..i]) then self:learnTalent(self['T_POSSESSION_TALENT_'..i], true) end
		end
	end,
	getNbTalents = function(self, t)
		local nb = 2
		for i = 1, math.floor(self:getTalentLevel(t)) do
			if i ~= 3 and i ~= 5 then nb = nb + 1 end
		end
		return util.bound(nb, 1, 8)
	end,
	info = function(self, t)
		return ([[When you assume the form of an other body you gain more control over the body:
		- at level 1 you gain one more talent slot
		- at level 2 you gain one more talent slot
		- at level 3 you gain resistances and flat resistances
		- at level 4 you gain one more talent slot
		- at level 5 you gain all speeds (only if they are superior to yours)
		- at level 6+ you gain one more talent slot
		]]):
		tformat(t.getNbTalents(self, t))
	end,
}
