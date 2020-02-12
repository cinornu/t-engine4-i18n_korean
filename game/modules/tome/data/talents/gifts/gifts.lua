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

-- Wild Gifts
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/call", name = _t"call of the wild", generic = true, description = _t"Be at one with nature." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/harmony", name = _t"harmony", generic = true, description = _t"Nature heals and cleans you." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, is_antimagic=true, type="wild-gift/antimagic", name = _t"antimagic", generic = true, description = _t"The way to combat magic, or even nullify it." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/summon-melee", name = _t"summoning (melee)", description = _t"The art of calling creatures adept in melee combat to your aid." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/summon-distance", name = _t"summoning (distance)", description = _t"The art of calling creatures adept in elemental destruction to your aid." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/summon-utility", name = _t"summoning (utility)", description = _t"The art of calling versatile creatures to your aid." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/summon-augmentation", name = _t"summoning (augmentation)", description = _t"The art of manipulating the lifespan and location of your summons." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/summon-advanced", name = _t"summoning (advanced)", min_lev = 10, description = _t"The art of improving the quality of your summons." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/slime", name = _t"slime", description = _t"Through dedicated consumption of slime mold juice, you have gained an affinity with slime molds." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/fungus", name = _t"fungus", generic = true, description = _t"By covering yourself in fungus, you better your healing." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/sand-drake", name = _t"sand drake aspect", description = _t"Take on the defining aspects of a Sand Drake." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/fire-drake", name = _t"fire drake aspect", description = _t"Take on the defining aspects of a Fire Drake." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/cold-drake", name = _t"cold drake aspect", description = _t"Take on the defining aspects of a Cold Drake." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/storm-drake", name = _t"storm drake aspect", description = _t"Take on the defining aspects of a Storm Drake." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/venom-drake", name = _t"venom drake aspect", description = _t"Take on the defining aspects of a Venom Drake." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/higher-draconic", name = _t"higher draconic abilities", description = _t"Take on the aspects of aged and powerful dragons." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/mindstar-mastery", name = _t"mindstar mastery", generic = true, description = _t"Learn to channel your mental power through mindstars, forming powerful psionic blades." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/mucus", name = _t"mucus", description = _t"Cover the floor with natural mucus." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/ooze", name = _t"ooze", description = _t"Your body and internal organs are becoming more ooze-like in nature, allowing you to spawn more of you." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/moss", name = _t"moss", description = _t"You learn to control moss, making it grow at will to help you on the battlefield." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/malleable-body", name = _t"malleable body", description = _t"Your body's anatomy is starting to blur." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/oozing-blades", name = _t"oozing blades", description = _t"You channel ooze through your psiblades." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, type="wild-gift/corrosive-blades", name = _t"corrosive blades", description = _t"You channel acid through your psiblades." }
newTalentType{ allow_random=true, is_mind=true, is_nature=true, is_antimagic=true, type="wild-gift/eyals-fury", name = _t"eyal's fury", description = _t"Unleash nature's fury against foes around you." }
newTalentType{ allow_random=true, is_nature=true, type="wild-gift/earthen-power", name = _t"earthen power", description = _t"Dwarves have learned to imbue their shields with the power of stone itself." }
newTalentType{ allow_random=true, is_nature=true, type="wild-gift/earthen-vines", name = _t"earthen vines", description = _t"Control the stone itself and bring it alive in the form of dreadful vines." }
newTalentType{ allow_random=true, is_nature=true, type="wild-gift/dwarven-nature", name = _t"dwarven nature", description = _t"Learn to harness the innate power of your race." }

-- Generic requires for gifts based on talent level
gifts_req1 = {
	stat = { wil=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
gifts_req2 = {
	stat = { wil=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
gifts_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
gifts_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
gifts_req5 = {
	stat = { wil=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
gifts_req_high1 = {
	stat = { wil=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
gifts_req_high2 = {
	stat = { wil=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
gifts_req_high3 = {
	stat = { wil=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
gifts_req_high4 = {
	stat = { wil=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
gifts_req_high5 = {
	stat = { wil=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}

function checkMaxSummon(self, silent, div, check_attr)
	div = div or 1
	local nb = 0

	-- Count party members
	if game.party:hasMember(self) then
		for act, def in pairs(game.party.members) do
			if act.summoner and act.summoner == self and act.wild_gift_summon and not act.wild_gift_summon_ignore_cap and (not check_attr or act:attr(check_attr)) then nb = nb + 1 end
		end
	elseif game.level then
		for _, act in pairs(game.level.entities) do
			if act.summoner and act.summoner == self and act.wild_gift_summon and not act.wild_gift_summon_ignore_cap and (not check_attr or act:attr(check_attr)) then nb = nb + 1 end
		end
	end

	local max = util.bound(math.floor(self:combatStatScale("cun", 10^.5, 10)),1,math.max(1,math.floor(self:getCun() / 10))) -- scaling slows at higher levels of cunning
	if self:attr("nature_summon_max") then
		max = max + self:attr("nature_summon_max")
	end
	max = math.ceil(max / div)
	if nb >= max then
		if not silent then
			game.logPlayer(self, "#PINK#You can manage a maximum of %d summons at any time. You need %d Cunning to increase your limit.", nb, math.max((nb+1)*10, (nb+1)^2))
		end
		return true, nb, max
	else
		return false, nb, max
	end
end

function setupSummon(self, m, x, y, no_control)
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.no_inventory_access = true
	m.no_points_on_levelup = true
	m.save_hotkeys = true
	m.ai_state = m.ai_state or {}
	m.ai_state.tactic_leash = 100
	m.ai_state.target_last_seen = table.clone(self.ai_state.target_last_seen)
	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	local main_weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
	m.life_regen = m.life_regen + (self:attr("nature_summon_regen") or 0)
	m:attr("combat_apr", self:combatAPR(main_weapon))
	m.inc_damage = table.clone(self.inc_damage, true)
	m.resists_pen = table.clone(self.resists_pen, true)
	m:attr("stun_immune", self:attr("stun_immune"))
	m:attr("blind_immune", self:attr("blind_immune"))
	m:attr("pin_immune", self:attr("pin_immune"))
	m:attr("confusion_immune", self:attr("confusion_immune"))
	m:attr("numbed", self:attr("numbed"))
	if game.party:hasMember(self) then


		m.remove_from_party_on_death = true
		game.party:addMember(m, {
			control=can_control and "full" or "no",
			type="summon",
			title=_t"Summon",
			orders = {target=true, leash=true, anchor=true, talents=true},
		})
	end
	m:resolve() m:resolve(nil, true)
	m:forceLevelup(self.level)
	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "summon")

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0

	local p = self:hasEffect(self.EFF_FRANTIC_SUMMONING)
	if p and m.wild_gift_summon and not m.wild_gift_summon_ignore_cap then
		p.dur = p.dur - 1
		if p.dur <= 0 then self:removeEffect(self.EFF_FRANTIC_SUMMONING) end
	end

	if m.wild_gift_detonate and self:isTalentActive(self.T_MASTER_SUMMONER) and self:knowTalent(self.T_GRAND_ARRIVAL) then
		local dt = self:getTalentFromId(m.wild_gift_detonate)
		if dt.on_arrival then
			dt.on_arrival(self, self:getTalentFromId(self.T_GRAND_ARRIVAL), m)
		end
	end

	if m.wild_gift_detonate and self:isTalentActive(self.T_MASTER_SUMMONER) and self:knowTalent(self.T_NATURE_CYCLE) then
		local t = self:getTalentFromId(self.T_NATURE_CYCLE)
		for _, tid in ipairs{self.T_SUMMON_CONTROL, self.T_DETONATE, self.T_WILD_SUMMON} do
			if self.talents_cd[tid] and rng.percent(t.getChance(self, t)) then
				self.talents_cd[tid] = self.talents_cd[tid] - t.getReduction(self, t)
				if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
				self.changed = true
			end
		end
	end

end

load("/data/talents/gifts/call.lua")
load("/data/talents/gifts/harmony.lua")

load("/data/talents/gifts/antimagic.lua")

load("/data/talents/gifts/slime.lua")
load("/data/talents/gifts/fungus.lua")
load("/data/talents/gifts/mucus.lua")
load("/data/talents/gifts/ooze.lua")
load("/data/talents/gifts/moss.lua")
load("/data/talents/gifts/malleable-body.lua")
load("/data/talents/gifts/oozing-blades.lua")
load("/data/talents/gifts/corrosive-blades.lua")

load("/data/talents/gifts/sand-drake.lua")
load("/data/talents/gifts/fire-drake.lua")
load("/data/talents/gifts/cold-drake.lua")
load("/data/talents/gifts/storm-drake.lua")
load("/data/talents/gifts/venom-drake.lua")
load("/data/talents/gifts/higher-draconic.lua")

load("/data/talents/gifts/summon-melee.lua")
load("/data/talents/gifts/summon-distance.lua")
load("/data/talents/gifts/summon-utility.lua")
load("/data/talents/gifts/summon-augmentation.lua")
load("/data/talents/gifts/summon-advanced.lua")

load("/data/talents/gifts/mindstar-mastery.lua")
load("/data/talents/gifts/eyals-fury.lua")

load("/data/talents/gifts/earthen-power.lua")
load("/data/talents/gifts/earthen-vines.lua")
load("/data/talents/gifts/dwarven-nature.lua")
