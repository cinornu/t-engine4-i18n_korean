-- TE4 - T-Engine 4
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

--- Module that handles multiplayer chats extensions, automatically loaded by engine.UserChat if found
module(..., package.seeall, class.make)

function _M:init(chat)
	self.chat = chat
	chat:enableShadow(0.6)
end

function _M:sendTalentLink(t)
	local p = game:getPlayer()
	t = p:getTalentFromId(t)
	local desc = tstring{{"color","GOLD"}, {"font", "bold"}, t.name, {"font", "normal"}, {"color", "LAST"}, true}
	desc:merge(p:getTalentFullDescription(t))
	desc = desc:toString():removeUIDCodes()
	local ser = zlib.compress(table.serialize{kind="talent-link", name="#GOLD#"..t.name.."#LAST#", desc=desc})
	core.profile.pushOrder(string.format("o='ChatSerialData' kind='talent-link' channel=%q msg=%q", self.chat.cur_channel, ser))
end

function _M:sendObjectLink(o)
	local name = o:getName{do_color=true}:removeUIDCodes()
	local desc = tostring(o:getDesc(nil, nil, true)):removeUIDCodes()
	local ser = zlib.compress(table.serialize{kind="object-link", name=name, desc=desc})
	core.profile.pushOrder(string.format("o='ChatSerialData' kind='object-link' channel=%q msg=%q", self.chat.cur_channel, ser))
end

function _M:sendActorLink(m)
	if m == game:getPlayer(true) then
		world:gainAchievement("SELF_CENTERED", game.player)
	end

	local rank, rank_color = m:TextRank()
	local name = rank_color..m.name:removeUIDCodes().."#LAST#"
	local desc = tostring(m:tooltip(m.x, m.y, game.player) or "???"):removeUIDCodes()
	if not desc then return end
	local ser = zlib.compress(table.serialize{kind="actor-link", name=name, desc=desc})
	core.profile.pushOrder(string.format("o='ChatSerialData' kind='actor-link' channel=%q msg=%q", self.chat.cur_channel, ser))
end

function _M:sendKillerLink(msg, short_msg, src)
	local desc = nil
	if src.tooltip then desc = tostring(src:tooltip(src.x, src.y, game.player) or "???"):removeUIDCodes() end
	local ser = zlib.compress(table.serialize{kind="killer-link", msg=msg, short_msg=short_msg, desc=desc})
	core.profile.pushOrder(string.format("o='ChatSerialData' kind='killer-link' channel=%q msg=%q", self.chat.cur_channel, ser))
end

-- Receive a custom event
function _M:event(e)
	if e.se == "SerialData" then
		local data = zlib.decompress(e.msg)
		if not data then return end
		data = data:unserialize()
		if not data then return end

		local color, uname = self.chat:getUserColor(e)

		if data.kind == "object-link" then
			self.chat:addMessage("link", e.channel, e.login, {uname, color}, ("#ANTIQUE_WHITE#has linked an item: #WHITE# %s"):tformat(data.name), {mode="tooltip", tooltip=data.desc})
		elseif data.kind == "actor-link" then
			self.chat:addMessage("link", e.channel, e.login, {uname, color}, ("#ANTIQUE_WHITE#has linked a creature: #WHITE# %s"):tformat(data.name), {mode="tooltip", tooltip=data.desc})
		elseif data.kind == "talent-link" then
			self.chat:addMessage("link", e.channel, e.login, {uname, color}, ("#ANTIQUE_WHITE#has linked a talent: #WHITE# %s"):tformat(data.name), {mode="tooltip", tooltip=data.desc})
		elseif data.kind == "killer-link" then
			self.chat:addMessage("death", e.channel, e.login, {uname, color}, ("#CRIMSON#%s#WHITE#"):tformat(data.msg), data.desc and {mode="tooltip", tooltip=data.desc} or nil)
		else
			self:triggerHook{"UserChat:event", color=color, e=e, data=data}
		end
	elseif e.se == "Talk" then
		-- Shake screen?
		if e.login == "darkgod" then
			if e.msg == e.msg:upper() and #e.msg >= 10 then
				game:shakeScreen(30, 5)
				game.log("SHAKING")
			end
		end
	end
end
