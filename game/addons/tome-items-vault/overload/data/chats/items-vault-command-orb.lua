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

function getLevelReq(o)
	local ml = o.material_level or 1
	return 15 + math.max(ml - 3, 0) * 10
end

function willModify(o)
	local msg = ""
	if not rawget(o, "require") and getLevelReq(o) > 0 then
		msg = ("Transfering this item will place a level %d requirement on it, since it has no requirements. "):tformat(getLevelReq(o))
	end
	if o.unvault_ego then
		msg = msg.._t"Some properties of the item will be lost upon transfer, since they are class- or talent-specific. "
	end
	if #msg > 0 then return msg else return nil end
end

function doModify(o)
	if not rawget(o, "require") and getLevelReq(o) > 0 then
		o.require = {level=getLevelReq(o)}
	end
	if o.unvault_ego then
		local list = table.clone(o.ego_list)
		local n = #list, i, j
		j = 1
		-- remove dangerous egos!
		for i=1,n do
			if not list[i][1].unvault_ego then
				j = j + 1
				list[j-1] = list[i]
			end
		end
		for i=j,n do list[i] = nil end
		game.zone:setEntityEgoList(o, list)
		o:resolve()
		o:resolve(nil, true)
		o:identify(true)
	end
end

newChat{ id="welcome",
	text = (profile:isDonator() and _t[[*#LIGHT_GREEN#This orb seems to be some kind of interface to an extra-dimentional vault of items.
All your characters in alternate universes will be able to access it from here.
Only items from a validated game versions are uploadable.#WHITE#*

#GOLD#Donator's Feature#ANCIENT_WHITE#: Items are saved on the server, only donators have access to this feature and the number of items storable at once depends on your generosity.
I, DarkGod, the maker of this game want to personaly thank all donators because you people are keeping this game going. Thanks and enjoy!]]
or
[[*#LIGHT_GREEN#This orb seems to be some kind of interface to an extra-dimentional vault of items.
All your characters in alternate universes will be able to access it from here.
Only items from a validated game versions are uploadable.#WHITE#*

#GOLD#Donator's Feature#ANCIENT_WHITE#: Items are saved on the server, only donators have access to this feature and the number of items storable at once depends on your generosity.
If you wish to help the game select the donation option below a link will open in your browser. Make sure you are logged into your profile so the donation is registered to you.
I, DarkGod, the maker of this game want to personaly thank all donators because you people are keeping this game going. Thanks and enjoy!]]) ..
(core.steam and not profile.auth and _t[[

#CRIMSON#Note for Steam Players#ANCIENT_WHITE#: This feature requires you to have registered a profile & bound it to steam (automatic if you register ingame) because it needs to store things on the server.
Until you do so you will get an error.]] or ""),
	answers = {
		{"_t[Place an item in the vault]", cond=function() return profile:isDonator() end, action=function(npc, player)
			if game:isTainted() or not profile.hash_valid then
				require("engine.ui.Dialog"):simplePopup(_t"Item's Vault", _t"You can not place an item in the vault from an un-validated game.")
				return
			end

			local inven = player:getInven(player.INVEN_INVEN)
			local titleupdator = player:getEncumberTitleUpdator(_t"Place an item in the Item's Vault")
			local d d = player:showInventory(titleupdator(), inven, function(o)
				return profile:isDonator() and not o.quest and not o.special and not o.plot and not o.tinker and not game:isTainted() and profile.hash_valid and true or false
			end, function(o, item)
				local caution = willModify(o)
				if caution then
					require("engine.ui.Dialog"):yesnoPopup(_t"Caution", (caution .. _t"Continue?"):format(lev), function(ret)
						if ret then
							local so = o:cloneFull()
							doModify(so)
							require("mod.class.ItemsVaultDLC").transferToVault(player, so, function()
								player:removeObject(inven, item, true)
							end)
						end
					end)
				else
					local so = o:cloneFull()
					require("mod.class.ItemsVaultDLC").transferToVault(player, so, function()
						player:removeObject(inven, item, true)
					end)
				end
			end)
		end},
		{_t"[Retrieve an item from the vault]", cond=function() return profile:isDonator() end, action=function()
			local d = require("mod.dialogs.ItemsVault").new()
			if d and not d.dont_show then game:registerDialog(d) end
		end},
		{_t"#GOLD#I wish to help the funding of this game and donate#WHITE#", action=function() game:registerDialog(require("mod.dialogs.Donation").new()) end},
		{_t"[Leave the orb alone]"},
	}
}

return "welcome"
