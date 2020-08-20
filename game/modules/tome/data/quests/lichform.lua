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

name = _t"From Death, Life"
desc = function(self, who)
	local desc = {}
	desc[#desc+1] = _t"The affairs of this mortal world are trifling compared to your true goal: To conquer death."
	desc[#desc+1] = _t"Your studies have uncovered much surrounding this subject, but now you must prepare for your glorious rebirth."
	desc[#desc+1] = _t"You will need:"

	if who.level >= 25 and who.unused_prodigies >= 1 and who:getMag() >= 50 and who:getWil() >= 25 then desc[#desc+1] = _t"#LIGHT_GREEN#* You are experienced enough.#WHITE#"
	else desc[#desc+1] = _t"#SLATE#* The ceremony will require that you are worthy, experienced, and possessed of a certain amount of power (level 25, Magic over 50, Willpower over 25 and one prodigy point available).#WHITE#" end

	if self:isCompleted("heart") then desc[#desc+1] = _t"#LIGHT_GREEN#* You have 'extracted' the heart of one of your fellow necromancers.#WHITE#"
	else desc[#desc+1] = _t"#SLATE#* The beating heart of a powerful necromancer.#WHITE#" end

	if who:isQuestStatus("shertul-fortress", self.COMPLETED, "butler") then
		desc[#desc+1] = _t"#LIGHT_GREEN#* Yiilkgur the Sher'tul Fortress is a suitable location.#WHITE#"

		if who:hasQuest("shertul-fortress").shertul_energy >= 40 then
			desc[#desc+1] = _t"#LIGHT_GREEN#* Yiilkgur has enough energy.#WHITE#"

			if who:knowTalent(who.T_LICH) then desc[#desc+1] = _t"#LIGHT_GREEN#* You are now on the path of lichdom.#WHITE#"
			else desc[#desc+1] = _t"#SLATE#* Use the control orb of Yiilkgur to begin the ceremony.#WHITE#" end
		else desc[#desc+1] = _t"#SLATE#* Your lair must amass enough energy to use in your rebirth (40 energy).#WHITE#" end
	else
		desc[#desc+1] = _t"#SLATE#* The ceremony will require a suitable location, secluded and given to the channelling of energy#WHITE#"
	end

	return table.concat(desc, "\n")
end

on_status_change = function(self, who, status, sub)
	if self:isCompleted() then
		local q = who:hasQuest("shertul-fortress")
		if q then q.shertul_energy = q.shertul_energy - 40 end

		who:setQuestStatus(self.id, engine.Quest.DONE)
		who.unused_prodigies = who.unused_prodigies - 1
		who:learnTalent(who.T_LICH, true, 1, {no_unlearn=true})
		require("engine.ui.Dialog"):simplePopup(_t"Lichform", _t"The secrets of death lay open to you! You are to become a Lich upon your next death!")
	end
end

check_lichform = function(self, who)
	if self:isStatus(self.DONE) then return end

	if who.level < 25 then return end
	if who:getMag() < 50 then return end
	if who:getWil() < 25 then return end
	if who.unused_prodigies < 1 then return end

	local t = who:getTalentFromId(who.T_LICH)
	who.lichform_quest_checker = true
	who:learnTalentType("uber/magic", true)
	local res, err = who:canLearnTalent(t)
	who.lichform_quest_checker = nil
	if not res then return end

	if not self:isCompleted("heart") then return end

	local q = who:hasQuest("shertul-fortress")
	if not q then return end
	if not q:isCompleted("butler") then return end
	if q.shertul_energy < 40 then return end

	return true
end
