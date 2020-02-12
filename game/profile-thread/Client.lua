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
local socket = require "socket"
local UserChat = require "profile-thread.UserChat"

module(..., package.seeall, class.make)

local debug = false

local metaport = 2240
local profilehost = "profiles.te4.org"
local mport = debug and 2259 or 2257
local pport = debug and 2260 or 2258

function _M:init()
	self.last_ping = os.time()
	self.chat = UserChat.new(self)
end

function _M:connected()
	if self.sock then return true end

	if not debug then
		local metasock = socket.connect("profiles.te4.org", metaport)
		if metasock then
			metasock:settimeout(2)
			local line = metasock:receive("*l")
			if line then
				local _, _, host, m, p = line:find("^([a-z0-9A-Z.]+):([0-9]+):([0-9]+)$")
				if host and tonumber(m) and tonumber(p) then
					profilehost = host
					mport = m
					pport = p
					print("[PROFILE] Got metaserver infos")
				end
			end
			metasock:close()
		end
	end

	print("[PROFILE] Thread connecting to "..tostring(profilehost).." on ports ", mport, pport)
	self.sock = socket.connect("profiles.te4.org", mport)
	if not self.sock then self:disconnect() return false end
--	self.sock:settimeout(10)
	print("[PROFILE] Thread connected to profiles.te4.org")
	self:login()
	self.chat:reconnect()
	cprofile.pushEvent("e='Connected'")
	self:orderFunFactsGrab{module="tome"}
	return true
end

--- Connects the second tcp channel to receive data
function _M:connectedPull()
	if self.psock then return true end
	self.psock = socket.connect("profiles.te4.org", pport)
	if not self.psock then return false end
--	self.psock:settimeout(10)
	print("[PROFILE] Pull socket connected to profiles.te4.org")
	self.psock:send(self.auth.push_id.."\n") -- Identify ourself
	return true
end

function _M:write(str, ...)
	self.sock:send(str:format(...))
end

function _M:disconnect()
	cprofile.pushEvent("e='Disconnected'")
	if self.psock then self.psock:close() end
	if self.sock then self.sock:close() end
	self.sock = nil
	self.psock = nil
	self.auth = nil
	core.game.sleep(5000) -- Wait 5 secs
end

function _M:receive(size)
	local try = 0
	local l, err = nil, "timeout"
	while not l and err == "timeout" and try < 10 do
		l, err = self.sock:receive(size)
		try = try + 1
	end
	if not l then
		if err == "closed" then
			print("[PROFILE] connection disrupted, trying to reconnect", err)
			self:disconnect()
		end
		return nil
	end
	return l
end

function _M:read(ncode)
	local try = 0
	local l, err = nil, "timeout"
	while not l and err == "timeout" and try < 10 do
		l, err = self.sock:receive("*l")
		try = try + 1
	end
	if not l then
		if err == "closed" then
			print("[PROFILE] connection disrupted, trying to reconnect", err)
			self:disconnect()
		end
		return nil
	end
	if ncode and l:sub(1, 3) ~= ncode then
		self.last_error = l:sub(5)
		return nil, "bad code"
	end
	self.last_line = l:sub(5)
	return l
end

function _M:pread(ncode)
	local try = 0
	local l, err = nil, "timeout"
	while not l and err == "timeout" and try < 10 do
		l, err = self.psock:receive("*l")
		try = try + 1
	end
	if not l then
		if err == "closed" then
			print("[PROFILE] push connection disrupted, trying to reconnect", err)
			self.psock = nil
			core.game.sleep(5000) -- Wait 5 secs
		end
		return nil
	end
	if ncode and l:sub(1, 3) ~= ncode then
		return nil, "bad code"
	end
	return l
end

function _M:login()
	if self.sock and not self.auth and self.steam_token then
		if self.steam_token_name then
			self:command("STM_ NAME", self.steam_token_name)
			self:read("200")
		end
		if self.steam_token_email then
			self:command("STM_ EMAIL", self.steam_token_email)
			self:read("200")
			self:command("STM_ NEWS", self.steam_token_news and 'yes' or 'no')
			self:read("200")
		end
		self:command("STM_ AUTH", self.steam_token)
		if not self:read("200") then
			local err = "unknown"
			if self.last_error:find('^auth refused') then err = "auth error"
			elseif self.last_error:find('^already exists') then err = "already exists"
			end
			cprofile.pushEvent(string.format("e='Auth' ok=false reason=%q", err))
			return false
		end
		self:command("PASS")
		if self:read("200") then
			self.auth = self.last_line:unserialize()
			print("[PROFILE] logged in with steam!", self.auth.login)
			cprofile.pushEvent(string.format("e='Auth' ok=%q", self.last_line))
			self:connectedPull()
			if self.cur_char then self:orderCurrentCharacter(self.cur_char) end
			return true
		else
			print("[PROFILE] could not log in with steam")
			self.user_login = nil
			self.user_pass = nil
			cprofile.pushEvent("e='Auth' ok=false")
			return false
		end
	elseif self.sock and not self.auth and self.user_login and self.user_pass then
		self:command("AUTH", self.user_login)
		self:read("200")
		self:command("PASH", self.user_pass)
		if self:read("200") then
			print("[PROFILE] logged in!", self.user_login)
			self.auth = self.last_line:unserialize()
			cprofile.pushEvent(string.format("e='Auth' ok=%q", self.last_line))
			self:connectedPull()
			if self.cur_char then self:orderCurrentCharacter(self.cur_char) end
			return true
		else
			print("[PROFILE] could not log in")
			self.user_login = nil
			self.user_pass = nil
			cprofile.pushEvent("e='Auth' ok=false")
			return false
		end
	elseif self.sock and self.auth then
		cprofile.pushEvent(string.format("e='Auth' ok=%q", table.serialize(self.auth)))
		return true
	end
end

function _M:command(c, ...)
	self.sock:send(("%s %s\n"):format(c, table.concat({...}, " ")))
end

function _M:step()
	if self:connected() then
		if not self.psock and self.auth then self:connectedPull() end

		local socks = {}
		if self.sock then socks[#socks+1] = self.sock end
		if self.psock then socks[#socks+1] = self.psock end
		local rready = socket.select(socks, nil, 0)
		if rready[self.psock] then
			local l = self:pread()
			if l then
				local code = l:sub(1, 3)
				local data = l:sub(5)
				if code == "101" then
					local e = data:unserialize()
					if e and e.e:find("^Chat") then self.chat:event(e)
					elseif e and e.e:find("^Friend") then self.chat:event(e)
					elseif e and e.e and self["push"..e.e] then self["push"..e.e](self, e)
					end
				end
			end
		end
		if rready[self.sock] then
			local l = self:read()
			if l then print("[PROFILE] req/rep thread got unwanted data", l) end
		end

		-- Ping every minute, lest the server kills us
		local time = os.time()
		if time - self.last_ping > 60 and self.sock then
			self.last_ping = time
			self:orderPing()
		end
		return true
	end
	return false
end

function _M:run()
--	while true do
	local st=core.game.getTime()
		local order = cprofile.popOrder()
		while order do self:handleOrder(order) order = cprofile.popOrder() end

		self:step()
		core.game.sleep(10)
--	end
end

function _M:handleOrder(o)
	o = o:unserialize()
	if not self.sock and o.o ~= "Login" and o.o ~= "CurrentCharacter" and o.o ~= "CheckModuleHash" and o.o ~= "CheckAddonHash" then return end -- Dont do stuff without a connection, unless we try to auth
	if self["order"..o.o] then self["order"..o.o](self, o) end
end

--------------------------------------------------------------------
-- Orders comming from the main thread
--------------------------------------------------------------------

function _M:orderNewProfile2(o)
	self:command("NEWP", table.serialize(o))
	if self:read("200") then
		cprofile.pushEvent(string.format("e='NewProfile2' uid=%d", tonumber(self.last_line) or -1))
	else
		cprofile.pushEvent(string.format("e='NewProfile2' uid=nil reason=%q", self.last_error))
	end
end

function _M:orderLogin(o)
	self.user_login = o.l
	self.user_pass = o.p

	if not self.sock then cprofile.pushEvent("e='Disconnected'") return end

	-- Already logged?
	if self.auth and self.auth.login == o.l then
		print("[PROFILE] reusing login", self.auth.name)
		if self.sock then cprofile.pushEvent("e='Connected'") end
		cprofile.pushEvent(string.format("e='Auth' ok=%q", table.serialize(self.auth)))
		self.chat:forwardFriends()
	else
		self:login()
	end
end

function _M:orderSteamLogin(o)
	self.steam_token = o.token
	self.steam_token_name = o.name
	if o.email and #o.email > 1 then
		self.steam_token_email = o.email
		self.steam_token_news = o.news
	end

	if not self.sock then cprofile.pushEvent("e='Disconnected'") return end

	-- Already logged?
	if self.auth then
		print("[PROFILE] reusing login", self.auth.name)
		if self.sock then cprofile.pushEvent("e='Connected'") end
		cprofile.pushEvent(string.format("e='Auth' ok=%q", table.serialize(self.auth)))
	else
		self:login()
	end
end

function _M:orderLogoff(o)
	-- Already logged?
	if self.auth then
		print("[PROFILE] logoff", self.auth.name)
		cprofile.pushEvent("e='Logoff'")
		self.auth = nil
	end
end

function _M:orderGetNews(o)
	if o.steam then self:command("NEWS", "STEAM")
	else self:command("NEWS")
	end
	if self:read("200") then
		local _, _, size, title = self.last_line:find("^([0-9]+) (.*)")
		size = tonumber(size)
		if not size or size < 1 or not title then cprofile.pushEvent("e='News' news=false") return end

		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='GetNews' news=%q", table.serialize{title=title, body=body}))
	else
		cprofile.pushEvent("e='GetNews' news=false")
	end
end

function _M:orderGetConfigs(o)
	if not self.auth then return end
	self:command("CGET", o.module, o.kind)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='GetConfigs' module=%q kind=%q data=%q", o.module, o.kind, body))
	end
end

function _M:orderSetConfigsBatch(o)
	if not o.v then
		if not self.setConfigsBatching then return end
		self.setConfigsBatchingLevel = self.setConfigsBatchingLevel - 1
		if self.setConfigsBatchingLevel > 0 then return end

		print("[PROFILE THREAD] flushing CSETs")

		if #self.setConfigsBatching <= 0 then
			print("[PROFILE THREAD] flushing CSETs ignored, empty dataset")
		else
			local data = zlib.compress(table.serialize(self.setConfigsBatching))
			self:command("FSET", data:len())
			if self:read("200") then self.sock:send(data) end
		end
		self.setConfigsBatching = nil
	else
		print("[PROFILE THREAD] batching CSETs")
		self.setConfigsBatching = self.setConfigsBatching or {}
		self.setConfigsBatchingLevel = (self.setConfigsBatchingLevel or 0) + 1
	end
end

function _M:orderSetConfigs(o)
	if not self.auth then return end
	if self.setConfigsBatching then
		self.setConfigsBatching[#self.setConfigsBatching+1] = o
	else
		self:command("CSET", o.data:len(), o.module, o.kind)
		if self:read("200") then self.sock:send(o.data) end
	end
end

function _M:orderSendIncrLog(o)
	if not self.auth then cprofile.pushEvent("e='IncrLogConsume' ok=false") return end
	self:command("CINC", o.data:len())
	if self:read("200") then self.sock:send(o.data) cprofile.pushEvent("e='IncrLogConsume' ok=true") end
end

function _M:orderSendError(o)
	o = table.serialize(o)
	self:command("ERR_", o:len())
	if self:read("200") then
		self.sock:send(o)
	end
end

function _M:orderCheckModuleHash(o)
	if not self.sock then cprofile.pushEvent("e='CheckModuleHash' ok=false not_connected=true") end
	self:command("CMD5", o.md5, o.module)
	if self:read("200") then
		cprofile.pushEvent("e='CheckModuleHash' ok=true")
	else
		cprofile.pushEvent("e='CheckModuleHash' ok=false")
	end
end

function _M:orderCheckAddonHash(o)
	if not self.sock then cprofile.pushEvent("e='CheckAddonHash' ok=false not_connected=true") end
	self:command("AMD5", o.md5, o.module, o.addon)
	if self:read("200") then
		cprofile.pushEvent("e='CheckAddonHash' ok=true")
	else
		cprofile.pushEvent("e='CheckAddonHash' ok=false")
	end
end

function _M:orderCheckBatchHash(o)
	if not self.sock then cprofile.pushEvent("e='CheckBatchHash' ok=false not_connected=true") end
	local data = table.serialize(o.data)
	self:command("BMD5", #data)
	if self:read("200") then
		self.sock:send(data)
		if self:read("200") then		
			cprofile.pushEvent("e='CheckBatchHash' ok=true")
		else
			cprofile.pushEvent(("e='CheckBatchHash' ok=false error=%q"):format(self.last_error))
		end
	else
		cprofile.pushEvent(("e='CheckBatchHash' ok=false error=%q"):format("unknown error"))
	end
end

function _M:orderCheckAddonUpdates(o)
	if not self.sock then cprofile.pushEvent("e='CheckAddonUpdates' ok=false not_connected=true") end
	local data = zlib.compress(table.serialize(o.list))
	self:command("ADDN SHOULD_UPDATE", #data)
	if self:read("200") then
		self.sock:send(data)
		if self:read("200") then
			local _, _, size = self.last_line:find("^([0-9]+)")
			size = tonumber(size)
			local list = {}
			if size and size > 1 then
				local body = self:receive(size)
				if body then body = zlib.decompress(body) end
				if body then body = body:unserialize() end
				if body then list = body end
			end

			cprofile.pushEvent(("e='CheckAddonUpdates' ok=%q"):format(table.serialize(list)))
			return
		end
	end
	cprofile.pushEvent("e='CheckAddonUpdates' ok=false")
end

function _M:orderRegisterNewCharacter(o)
	self:command("CHAR", "NEW", o.module)
	if self:read("200") then
		cprofile.pushEvent(string.format("e='RegisterNewCharacter' uuid=%q", self.last_line))
	else
		cprofile.pushEvent("e='RegisterNewCharacter' uuid=nil")
	end
end

function _M:orderSaveChardump(o)
	self:command("CHAR", "UPDATE", o.metadata:len(), o.data:len(), o.uuid, o.module)
	if not self:read("200") then return end
	self.sock:send(o.metadata)
	if not self:read("200") then return end
	self.sock:send(o.data)
	cprofile.pushEvent("e='SaveChardump' ok=true")
end

function _M:orderSaveCharball(o)
	self:command("CHAR", "CHARBALL", o.data:len(), o.uuid, o.module)
	if not self:read("200") then return end
	self.sock:send(o.data)
	cprofile.pushEvent("e='SaveCharball' ok=true")
end

function _M:orderGetCharball(o)
	self:command("CHAR", "GETCHARBALL", o.id_profile, o.uuid, o.module)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='GetCharball' id_profile=%q uuid=%q data=%q", o.id_profile, o.uuid, body))
	else
		cprofile.pushEvent(string.format("e='GetCharball' id_profile=%q uuid=%q unknown=true", o.id_profile, o.uuid))
	end
end

function _M:orderSaveMD5(o)
	self:command("CHAR", "SETSAVEID", o.md5, o.uuid, o.module, o.savename)
end

function _M:orderCheckSaveMD5(o)
	self:command("CHAR", "CHECKSAVEID", o.md5, o.uuid, o.module, o.savename)
	if self:read("200") then
		cprofile.pushEvent(string.format("e='CheckSaveMD5' ok=true savename=%q", o.savename))
	else
		cprofile.pushEvent(string.format("e='CheckSaveMD5' ok=false savename=%q", o.savename))
	end
end

function _M:orderCurrentCharacter(o)
	self:command("CHAR", "CUR", table.serialize(o))
	self.cur_char = o
end

function _M:orderChatTalk(o)
	self:command("BRDC", o.channel, o.msg)
	self:read("200")
end

function _M:orderChatWhisper(o)
	self:command("WHIS", o.target..":=:"..o.msg)
	self:read("200")
end

function _M:orderReportUser(o)
	self:command("RPTU", o.target..":=:"..o.msg)
	self:read("200")
end

function _M:orderChatAchievement(o)
	self:command("ACH2", o.huge and "1" or "0", o.first and "1" or "0", o.channel, o.msg)
	self:read("200")
end

function _M:orderChatSerialData(o)
	self:command("SERZ", o.channel, o.msg:len(), o.kind or "generic")
	if not self:read("200") then return end
	self.sock:send(o.msg)
end

function _M:orderChatJoin(o)
	self:command("JOIN", o.channel)
	if self:read("200") then
		self.chat:joined(o.channel)
	end
end

function _M:orderChatPart(o)
	self:command("Part", o.channel)
	if self:read("200") then
		self.chat:parted(o.channel)
	end
end

function _M:orderChatUserInfo(o)
	self:command("UINF", o.login)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='UserInfo' login=%q data=%q", o.login, body))
	else
		cprofile.pushEvent(string.format("e='UserInfo' unknown=true login=%q", o.login))
	end
end

function _M:orderChatChannelList(o)
	self:command("CLST", o.channel)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='Chat' se='ChannelList' channel=%q data=%q", o.channel, body))
	end
end

function _M:orderGetDLCD(o)
	self:command("DLCD", o.name, o.version, o.file)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='GetDLCD' data=%q", body))
	else
		cprofile.pushEvent("e='GetDLCD' data=''")
	end
end

function _M:orderEntityInfos(o)
	self:command("EVLT", "INFO", o.module, o.kind)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then 
			cprofile.pushEvent(string.format("e='EntityInfos' module=%q kind=%q data='list={} max=0'", o.module, o.kind))
			return 
		end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='EntityInfos' module=%q kind=%q data=%q", o.module, o.kind, body))
	else
		cprofile.pushEvent(string.format("e='EntityInfos' module=%q kind=%q data='list={} max=0'", o.module, o.kind))
	end
end

function _M:orderEntityPoke(o)
	self:command("EVLT", "POKE", o.desc:len(), o.data:len(), o.module, o.kind, o.name)
	if not self:read("200") then return cprofile.pushEvent(("e='EntityPoke' ok=false err=%q"):format(self.last_error)) end
	self.sock:send(o.desc)
	if not self:read("200") then return cprofile.pushEvent("e='EntityPoke' ok=false err='unknown reason'") end
	self.sock:send(o.data)
	cprofile.pushEvent("e='EntityPoke' ok=true")
end

function _M:orderEntityEmpty(o)
	self:command("EVLT", "EMPTY", o.module, o.kind, o.id)
end

function _M:orderEntityPeek(o)
	self:command("EVLT", "PEEK", o.module, o.kind, o.id)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then cprofile.pushEvent("e='EntityPeek' ok=false") return end
		local body = self:receive(size)
		cprofile.pushEvent(string.format("e='EntityPeek' ok=true id=%d data=%q", o.id, body))
	else
		cprofile.pushEvent("e='EntityPeek' ok=false")
	end
end

function _M:orderPing(o)
	local time = core.game.getTime()
	self:command("PING")
	self:read("200")
	local lat = core.game.getTime() - time
	print("Server latency", lat)
	self.server_latency = lat
end

function _M:orderAddFriend(o)
	self:command("FRND", "ADD", o.id)
	self:read("200")
end

function _M:orderRemoveFriend(o)
	self:command("FRND", "DEL", o.id)
	self:read("200")
end

function _M:orderFunFactsGrab(o)
	if self.funfacts then
		cprofile.pushEvent(string.format("e='FunFacts' data=%q", self.funfacts))
		return
	end
	if self.funfacts_wait then return end

	self.funfacts_wait = true
	self:command("FACT", o.module)
	if self:read("200") then
		local _, _, size = self.last_line:find("^([0-9]+)")
		size = tonumber(size)
		if not size or size < 1 then return end
		self.funfacts = self:receive(size)
		cprofile.pushEvent(string.format("e='FunFacts' data=%q", self.funfacts))
	end
end

function _M:orderAddonEnableUpload(o)
	self:command("ADDN MODULEMAKER ON")
	self:read("200")
end

function _M:orderAddonAuthoring(o)
	if o.suborder == "create" then
		local metadata = table.serialize(o.metadata)
		self:command("ADDN CREATE_ADDON ", #metadata)
		if self:read("200") then
			self.sock:send(metadata)
			if not self:read("200") then return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='create' ok=false reason=%q", self.last_error)) end
			return cprofile.pushEvent("e='AddonAuthoring' suborder='create' ok=true")
		else
			return cprofile.pushEvent("e='AddonAuthoring' suborder='create' ok=false reason='metadata invalid'")
		end
	elseif o.suborder == "version" then
		local f = fs.open(o.file, "r")
		local data = {}
		local size = 0
		while true do
			local l = f:read(1024)
			if not l then break end
			data[#data+1] = l
			size = size + #l
		end
		f:close()

		o.metadata.teaa_size = size
		local metadata = table.serialize(o.metadata)
		self:command("ADDN VERSION_ADDON ", #metadata)
		if self:read("200") then
			self.sock:send(metadata)
			if not self:read("200") then return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='version' ok=false reason=%q", self.last_error)) end
			cprofile.pushEvent("e='AddonAuthoring' suborder='version_upload_start' total="..size)
			for i, d in ipairs(data) do
				self.sock:send(d)
				cprofile.pushEvent("e='AddonAuthoring' suborder='version_upload_progress' sent="..#d)
			end
			if not self:read("200") then return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='version' ok=false reason=%q", self.last_error)) end
			return cprofile.pushEvent("e='AddonAuthoring' suborder='version' ok=true")
		else
			return cprofile.pushEvent("e='AddonAuthoring' suborder='version' ok=false reason='metadata invalid'")
		end
	elseif o.suborder == "steam_pubid" then
		local metadata = table.serialize{for_module=o.for_module, short_name=o.short_name, pubid=o.pubid}
		self:command("ADDN STEAM_PUBID ", #metadata)
		if self:read("200") then
			self.sock:send(metadata)
			self:read("200")
		end
	elseif o.suborder == "check_steam_pubid" then
		local metadata = table.serialize{for_module=o.for_module, short_name=o.short_name, md5=o.md5, version=o.version}
		self:command("ADDN CHECK_STEAM_PUBID ", #metadata)
		if self:read("200") then
			self.sock:send(metadata)
			if self:read("200") then
				return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='check_steam_pubid' pubid=%q", self.last_line))
			else
				return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='check_steam_pubid' err=%q", self.last_error))				
			end
		else
			return cprofile.pushEvent(string.format("e='AddonAuthoring' suborder='check_steam_pubid' err=%q", self.last_error))				
		end
	end
end

function _M:orderMicroTxn(o)
	if o.suborder == "get_actionables" then
		self:command("MTXN GET_ACTIONABLES", o.module)
		if self:read("200") then
			local _, _, size = self.last_line:find("^([0-9]+)")
			size = tonumber(size)
			local body = {}
			if size and size > 1 then
				body = self:receive(size)
				if body then body = zlib.decompress(body) end
			end

			cprofile.pushEvent(("e='MicroTxnListActionables' list=%q"):format(body))
			return
		else
			cprofile.pushEvent(("e='MicroTxnListActionables' error=%q"):format(self.last_error))
		end
	elseif o.suborder == "use_actionable" then
		self:command("MTXN USE_ACTIONABLE", o.module, o.id_purchasable)
		if self:read("200") then
			cprofile.pushEvent(("e='MicroTxnUseActionable' success=true"):format())
		else
			cprofile.pushEvent(("e='MicroTxnUseActionable' success=false error=%q"):format(tostring(self.last_error)))
		end
	elseif o.suborder == "list_purchasables" then
		self:command("MTXN LIST_PURCHASABLE", o.module, o.store)
		if self:read("200") then
			local _, _, size = self.last_line:find("^([0-9]+)")
			size = tonumber(size)
			local body = {}
			if size and size > 1 then
				body = self:receive(size)
				if body then body = zlib.decompress(body) end
			end

			cprofile.pushEvent(("e='MicroTxnListPurchasables' data=%q"):format(body))
			return
		else
			cprofile.pushEvent(("e='MicroTxnListPurchasables' error=%q"):format(self.last_error))
		end
	elseif o.suborder == "create_cart" then
		local data = table.serialize{module=o.module, store=o.store, cart=o.cart:unserialize()}
		self:command("MTXN CREATE_CART ", #data)
		if self:read("200") then
			self.sock:send(data)
			if self:read("200") then
				cprofile.pushEvent(("e='MicroTxnListCartResult' success=true info=%q"):format(self.last_line))
			else
				cprofile.pushEvent(("e='MicroTxnListCartResult' success=false"):format())
			end
		end
	elseif o.suborder == "steam_finalize_cart" then
		local data = table.serialize{module=o.module, store=o.store, id_cart=o.id_cart}
		self:command("MTXN STEAM_FINALIZE_CART ", #data)
		if self:read("200") then
			self.sock:send(data)
			if self:read("200") then
				cprofile.pushEvent(("e='MicroTxnSteamFinalizeCartResult' success=true new_donated=%d"):format(tonumber(self.last_line)))
			else
				cprofile.pushEvent(("e='MicroTxnSteamFinalizeCartResult' success=false"):format())
			end
		end
	elseif o.suborder == "te4_finalize_cart" then
		local data = table.serialize{module=o.module, store=o.store, id_cart=o.id_cart}
		self:command("MTXN TE4_FINALIZE_CART ", #data)
		if self:read("200") then
			self.sock:send(data)
			if self:read("200") then
				cprofile.pushEvent(("e='MicroTxnTE4FinalizeCartResult' success=true new_donated=%d"):format(tonumber(self.last_line)))
			else
				cprofile.pushEvent(("e='MicroTxnTE4FinalizeCartResult' success=false"):format())
			end
		end
	end
end

--------------------------------------------------------------------
-- Pushes comming from the push socket
--------------------------------------------------------------------

function _M:orderCodeReturn(o)
	self:command("ARET", "RETURN", o.uuid, #o.data)
	if self:read("200") then self.sock:send(o.data) end
end

function _M:pushCode(e)
	if e.profile then
		-- Unused anyway
		-- local f = loadstring(e.code)
		-- if f then pcall(f) end
	else
		if e.return_uuid then
			cprofile.pushEvent(string.format("e='PushCode' return_uuid=%q code=%q", e.return_uuid, e.code))
		else
			cprofile.pushEvent(string.format("e='PushCode' code=%q", e.code))
		end
	end
end
