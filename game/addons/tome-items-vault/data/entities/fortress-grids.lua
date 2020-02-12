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

newEntity{
	define_as = "ITEMS_VAULT",
	name = "Item's Vault Control Orb", image = "terrain/solidwall/solid_floor1.png", add_displays = {class.new{z=18, image="terrain/pedestal_orb_02.png", display_y=-1, display_h=2}},
	display = '*', color=colors.LIGHT_BLUE,
	notice = true,
	always_remember = true,
	block_move = function(self, x, y, e, act, couldpass)
		if e and e.player and act then
			local chat = nil
			if profile:isDonator() and (not profile.connected or not profile.auth) then
				chat = require("engine.Chat").new("items-vault-command-orb-offline", self, e, {player=e})
			else
				chat = require("engine.Chat").new("items-vault-command-orb", self, e, {player=e})
			end
			chat:invoke()
		end
		return true
	end,
}
