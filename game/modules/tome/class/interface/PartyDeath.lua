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

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.make)

function _M:onPartyDeath(src, death_note)
	if self.dead then if game.level:hasEntity(self) then game.level:removeEntity(self, true) end return true end

	-- Die
	death_note = death_note or {}
	if not mod.class.Actor.die(self, src, death_note) then return end

	-- Remove from the party if needed
	if self.remove_from_party_on_death then
		game.party:removeMember(self, true)
	-- Overwise note the death turn
	else
		game.party:setDeathTurn(self, game.turn)
	end

	-- Was not the current player, just die
	if game.player ~= self then return true end

	-- Check for any survivor that can be controlled
	local game_ender = not game.party:findSuitablePlayer()

	-- Special game neder handler?
	if game_ender and game.party.on_game_end then
		game_ender = game.party:on_game_end(self, src, death_note)
	end

	-- No more player found! Switch back to main and die
	if game_ender then
		if self == src then world:gainAchievement("HALFLING_SUICIDE", self) end
		game.party:setPlayer(game.party:findMember{main=true}, true)
		game.paused = true
		game.player.energy.value = game.energy_to_act
		src = src or {name=_t"unknown"}
		game.player.killedBy = src
		game.player.died_times[#game.player.died_times+1] = {name=src.name, level=game.player.level, turn=game.turn}
		game.player:registerDeath(game.player.killedBy)
		local dialog = require("mod.dialogs."..(game.player.death_dialog or "DeathDialog")).new(game.player)
		if not dialog.dont_show then
			game:registerDialog(dialog)
		end
		game.player:saveUUID()

		local death_mean = nil
		if death_note and death_note.damtype then
			local dt = DamageType:get(death_note.damtype)
			if dt and dt.death_message then death_mean = rng.table(dt.death_message) end
		end

		local top_killer = nil
		if profile.mod.deaths then
			local l = {}
			for _, names in pairs(profile.mod.deaths.sources or {}) do
				for name, nb in pairs(names) do l[name] = (l[name] or 0) + nb end
			end
			l = table.listify(l)
			if #l > 0 then
				table.sort(l, function(a,b) return a[2] > b[2] end)
				top_killer = l[1][1]
			end
		end

		local msg, short_msg
		if not death_note.special_death_msg then
			msg = _t"%s the level %d %s %s was %s to death by %s%s%s on level %s of %s."
			short_msg = _t"%s(%d %s %s) was %s to death by %s%s on %s %s."
			local srcname
			if src.getName and src.unique then srcname = src:getName()
			elseif src.getName then srcname = src:getName():a_an()
			else srcname = src.name and tostring(src.name) or "(???)"
			end
			local killermsg = (src.killer_message and " "..src.killer_message or ""):gsub("#sex#", game.player.female and _t"her" or _t"him")
			if src.name == game.player.name then
				srcname = game.player.female and _t"herself" or _t"himself"
				killermsg = rng.table{
					_t" (the fool)",
					_t" in an act of extreme incompetence",
					_t" out of supreme humility",
					_t", by accident of course,",
					_t" in some sort of fetish experiment gone wrong",
					_t", providing a free meal to the wildlife",
					_t" (how embarrassing)",
				}
			end
			msg = msg:format(
				game.player.name, game.player.level, _t(game.player.descriptor.subrace):lower(), _t(game.player.descriptor.subclass):lower(),
				death_mean or _t"battered",
				srcname,
				src.name == top_killer and _t" (yet again)" or "",
				killermsg,
				game.level.level, game.zone.name
			)
			short_msg = short_msg:format(
				game.player.name, game.player.level, _t(game.player.descriptor.subrace):lower(), _t(game.player.descriptor.subclass):lower(),
				death_mean or _t"battered",
				srcname,
				killermsg,
				game.zone.name, game.level.level
			)
		else
			msg = _t"%s the level %d %s %s %s on level %s of %s."
			short_msg = _t"%s(%d %s %s) %s on %s %s."
			msg = msg:format(
				game.player.name, game.player.level, _t(game.player.descriptor.subrace):lower(), _t(game.player.descriptor.subclass):lower(),
				death_note.special_death_msg,
				game.level.level, game.zone.name
			)
			short_msg = short_msg:format(
				game.player.name, game.player.level, _t(game.player.descriptor.subrace):lower(), _t(game.player.descriptor.subclass):lower(),
				death_note.special_death_msg,
				game.zone.name, game.level.level
			)
		end

		game:playSound("actions/death")
		game.delayed_death_message = _t"#{bold}#"..msg.."#{normal}#"
		if (not game.player.easy_mode_lifes or game.player.easy_mode_lifes <= 0) and not game.player.infinite_lifes then
			profile.chat.uc_ext:sendKillerLink(msg, short_msg, src)
		end
	end
	return true
end
