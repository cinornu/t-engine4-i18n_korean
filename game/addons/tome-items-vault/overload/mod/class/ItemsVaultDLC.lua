-- ToME - Tales of Maj'Eyal:
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

local class = require "class"
local Dialog = require "engine.ui.Dialog"

module(..., package.seeall, class.make)

--------------------------------------------------------------------------------------------------
-- Hooks
--------------------------------------------------------------------------------------------------

function hookDonationDialogFeatures(self, data)
	data.list[#data.list+1] = _t"the #GOLD#Item's Vault#WHITE#"
end

function hookMapGeneratorStaticSubgenRegister(self, data)
	if data.mapfile ~= "zones/shertul-fortress" then return end

	data.list[#data.list+1] = {
		x = 11, y = 42, w = 8, h = 6, overlay = true,
		generator = "engine.generator.map.Static",
		data = {
			map = "items-vault/fortress",
		},
	}
end

function hookEntityLoadList(self, data)
	if data.file ~= "/data/zones/shertul-fortress/grids.lua" then return end

	self:loadList("/data-items-vault/entities/fortress-grids.lua", data.no_default, data.res, data.mod, data.loaded)
end

function hookPlayerDumpJSON(self, data)
	if self.used_items_vault then
		data.js:hiddenData("used_items_vault", true)
	end
end

--------------------------------------------------------------------------------------------------
-- Data transfers
--------------------------------------------------------------------------------------------------

function transferToVault(actor, o, cb_success)
	local ok1, ok2 = pcall(function()
		if not o.__items_vault then o.desc = o.desc.._t"\n#CRIMSON#This item has been sent to the Item's Vault." end
		o.__items_vault = true
		savefile_pipe:push(o.name, "entity", o, "engine.EntityVaultSave", function(save)
			fs.mkdir("/tmp")
			f = fs.open("/tmp/"..save:nameSaveEntity(o), "r")
			if f then
				local data = {}
				while true do
					local l = f:read()
					if not l then break end
					data[#data+1] = l
				end
				f:close()

				profile:entityVaultPoke(game.__mod_info.short_name, 'object', o:getName{do_color=1, no_image=1}:toString(), o:getDesc{do_color=1, no_image=1}:toString(), table.concat(data))

				local popup = Dialog:simpleWaiter(_t"Transfering...", _t"Teleporting object to the vault, please wait...")
				core.display.forceRedraw()
				local done = false
				local err = _t"unknown reason"
				profile:waitEvent("EntityPoke", function(e)
					if e.ok then
						game.logPlayer(actor, "#LIGHT_BLUE#You transfer %s to the online item's vault.", o:getName{do_colour=true, do_count=true})
						cb_success()
						actor:sortInven()
						game:onTickEnd(function() game:saveGame() end)
						done = true
					elseif e.err then
						err = e.err
					end
				end, 10000)
				popup:done()
				if not done then
					game.logPlayer(actor, "#LIGHT_RED#Error while transfering %s to the online item's vault, please retry later.", o:getName{do_colour=true, do_count=true})
					if err then game.logPlayer(actor, "#CRIMSON#Server said: %s", err) end
				end
			end
			fs.delete("/tmp/"..save:nameSaveEntity(o))
			if core.steam then core.steam.deleteFile("/tmp/"..save:nameSaveEntity(o)) end
		end)
		return true
	end)
end

function transferToVaultOffline(actor, o, cb_success)
	if not world.items_vault then world.items_vault = {} end
	if #world.items_vault >= 3 then return end

	world.items_vault[#world.items_vault+1] = {o=o, time=os.time()}

	game.logPlayer(actor, "#LIGHT_BLUE#You transfer %s to the offline item's vault.", o:getName{do_colour=true, do_count=true})
	cb_success()
	actor:sortInven()
	game:onTickEnd(function() game:saveGame() end)
	return true
end

local fix_types = {
	[1] = "PHYSICAL",
	[2] = "ARCANE",
	[3] = "FIRE",
	[4] = "COLD",
	[5] = "LIGHTNING",
	[6] = "ACID",
	[7] = "NATURE",
	[8] = "BLIGHT",
	[9] = "LIGHT",
	[10] = "DARKNESS",
	[11] = "MIND",
	[12] = "TEMPORAL",
	[13] = "TEMPORALSTUN",
	[14] = "LITE",
	[15] = "BREAK_STEALTH",
	[16] = "SILENCE",
	[17] = "ARCANE_SILENCE",
	[18] = "RANDOM_SILENCE",
	[19] = "BLIND",
	[20] = "BLINDPHYSICAL",
	[21] = "BLINDING_INK",
	[22] = "BLINDCUSTOMMIND",
	[23] = "LITE_LIGHT",
	[24] = "FIREBURN",
	[25] = "GOLEM_FIREBURN",
	[26] = "SHADOWFLAME",
	[27] = "DARKSTUN",
	[28] = "MINION_DARKNESS",
	[29] = "FIRE_FRIENDS",
	[30] = "COLDSTUN",
	[31] = "FLAMESHOCK",
	[32] = "ICE",
	[33] = "COLDNEVERMOVE",
	[34] = "FREEZE",
	[35] = "STICKY_SMOKE",
	[36] = "ACID_BLIND",
	[37] = "DARKNESS_BLIND",
	[38] = "LIGHT_BLIND",
	[39] = "LIGHTNING_DAZE",
	[40] = "WAVE",
	[41] = "BLOODSPRING",
	[42] = "FIREKNOCKBACK",
	[43] = "FIREKNOCKBACK_MIND",
	[44] = "DARKKNOCKBACK",
	[45] = "SPELLKNOCKBACK",
	[46] = "MINDKNOCKBACK",
	[47] = "PHYSKNOCKBACK",
	[48] = "FEARKNOCKBACK",
	[49] = "POISON",
	[50] = "INFERNO",
	[51] = "SPYDRIC_POISON",
	[52] = "CRIPPLING_POISON",
	[53] = "INSIDIOUS_POISON",
	[54] = "BLEED",
	[55] = "PHYSICALBLEED",
	[56] = "SLIME",
	[57] = "DIG",
	[58] = "SLOW",
	[59] = "CONGEAL_TIME",
	[60] = "TIME_PRISON",
	[61] = "CONFUSION",
	[62] = "RANDOM_CONFUSION",
	[63] = "RANDOM_CONFUSION_PHYS",
	[64] = "RANDOM_GLOOM",
	[65] = "RANDOM_BLIND",
	[66] = "SAND",
	[67] = "PINNING",
	[68] = "DRAINEXP",
	[69] = "DRAINLIFE",
	[70] = "DRAIN_VIM",
	[71] = "DEMONFIRE",
	[72] = "RETCH",
	[73] = "HOLY_LIGHT",
	[74] = "HEAL",
	[75] = "HEALING_POWER",
	[76] = "HEALING_NATURE",
	[77] = "CORRUPTED_BLOOD",
	[78] = "BLOOD_BOIL",
	[79] = "LIFE_LEECH",
	[80] = "PHYSICAL_STUN",
	[81] = "SPLIT_BLEED",
	[82] = "MATTER",
	[83] = "VOID",
	[84] = "GRAVITY",
	[85] = "GRAVITYPIN",
	[86] = "REPULSION",
	[87] = "GROW",
	[88] = "GRASPING_MOSS",
	[89] = "NOURISHING_MOSS",
	[90] = "SLIPPERY_MOSS",
	[91] = "HALLUCINOGENIC_MOSS",
	[92] = "SANCTITY",
	[93] = "SHIFTINGSHADOWS",
	[94] = "BLAZINGLIGHT",
	[95] = "WARDING",
	[96] = "MINDSLOW",
	[97] = "MINDFREEZE",
	[98] = "IMPLOSION",
	[99] = "CLOCK",
	[100] = "WASTING",
	[101] = "STOP",
	[102] = "RETHREAD",
	[103] = "TEMPORAL_ECHO",
	[104] = "DEVOUR_LIFE",
	[105] = "CHRONOSLOW",
	[106] = "MOLTENROCK",
	[107] = "ENTANGLE",
	[108] = "MANAWORM",
	[109] = "VOID_BLAST",
	[110] = "CIRCLE_DEATH",
	[111] = "RIGOR_MORTIS",
	[112] = "ABYSSAL_SHROUD",
	[113] = "GARKUL_INVOKE",
	[114] = "NIGHTMARE",
	[115] = "WEAKNESS",
	[116] = "TEMP_EFFECT",
	[117] = "MANABURN",
	[118] = "LEAVES",
	[119] = "DISTORTION",
	[120] = "DREAMFORGE",
	[121] = "MUCUS",
	[122] = "ACID_DISARM",
	[123] = "ACID_CORRODE",
	[124] = "BOUNCE_SLIME",
}
local function tryFixDamageType(o)
	local function fixtable(t)
		for id, d in pairs(t) do
			if type(id) == "number" and fix_types[id] then
				t[id] = nil
				t[fix_types[id]] = d
				return fixtable(t)
			end
		end
	end

	if o.combat and type(o.combat.damtype) == "number" and fix_types[o.combat.damtype] then
		o.combat.damtype = fix_types[o.combat.damtype]
	end
	if o.wielder then
		if o.wielder.resists then fixtable(o.wielder.resists) end
		if o.wielder.resists_pen then fixtable(o.wielder.resists_pen) end
		if o.wielder.inc_damage then fixtable(o.wielder.inc_damage) end
	end
end

function transferFromVault(id)
	profile:entityVaultPeek(game.__mod_info.short_name, 'object', id)

	local popup = Dialog:simpleWaiter(_t"Transfering...", _t"Teleporting object from the vault, please wait...")
	core.display.forceRedraw()
	local done = false
	profile:waitEvent("EntityPeek", function(e) if e.ok then
		local o = nil
		fs.mkdir("/tmp")
		fs.delete("/tmp/__tmp_entity.entity")
		local f = fs.open("/tmp/__tmp_entity.entity", "w")
		if f then
			f:write(e.data)
			f:close()

			savefile_pipe:ignoreSaveToken(true)
			savefile_pipe:ignoreCloudSave(true)
			o = savefile_pipe:doLoad("", "entity", "engine.EntityVaultSave", "__tmp_entity.entity")
			savefile_pipe:ignoreCloudSave(false)
			savefile_pipe:ignoreSaveToken(false)
			fs.delete("/tmp/__tmp_entity.entity")
			if core.steam then core.steam.deleteFile("/tmp/__tmp_entity.entity") end

			local ok = o and true or false
			if ok then
				tryFixDamageType(o)
				local works, desc = pcall(o.getDesc, o, {do_color=1, no_image=1})
				if not works then
					o = nil
					ok = false
					Dialog:simpleLongPopup(_t"Transfer failed", _t"This item comes from a previous version and would not work in your current game.\nTo prevent the universe from imploding the item was not transfered from the vault.", 500)
				end
			end

			if ok then profile:entityVaultEmpty(game.__mod_info.short_name, 'object', id) end
		end

		done = o
	end end, 10000)
	popup:done()
	return done
end

function transferFromVaultOffline(id)
	if not world.items_vault then world.items_vault = {} end
	if not world.items_vault[id] then return end

	local o = world.items_vault[id]
	table.remove(world.items_vault, id)
	return o.o
end

function listVault()
	profile:entityVaultInfos(game.__mod_info.short_name, 'object')

	local popup = Dialog:simpleWaiter(_t"Item's Vault", _t"Checking item's vault list, please wait...")
	core.display.forceRedraw()
	local done = false
	profile:waitEvent("EntityInfos", function(e)
		done = e.data
	end, 10000)
	popup:done()

	if done then done = done:unserialize() else done = {list={}, max=0, error="timeout"} end

	return done
end

function listVaultOffline()
	if not world.items_vault then world.items_vault = {} end
	local done = {list={}, max=3}

	for i, o in ipairs(world.items_vault) do
		done.list[#done.list+1] = {
			id_entity = i,
			name = o.o:getName{do_color=1, no_image=1}:toString(),
			desc = o.o:getDesc{do_color=1, no_image=1}:toString(),
			usable = (os.time() - o.time) >= 3600,
			sec_until = 3600 - (os.time() - o.time),
			last_updated = o.time,
		}
	end

	return done
end
