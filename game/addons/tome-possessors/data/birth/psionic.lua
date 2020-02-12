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

local Particles = require "engine.Particles"
local ParticlesCallback = require "engine.ParticlesCallback"

getBirthDescriptor("class", "Psionic").descriptor_choices.subclass["Possessor"] = "allow"
getBirthDescriptor("class", "Psionic").locked = nil

local function grab_possessor_forms(self, desc)
	local bodies = {}
	local extra_types = {}

	local m = {name="stone troll", base_list="mod.class.NPC:/data/general/npcs/troll.lua"}
	if m then bodies[#bodies+1] = m end

	local m = {name="panther", base_list="mod.class.NPC:/data/general/npcs/feline.lua"}
	if m then bodies[#bodies+1] = m end

	local assigned = false
	if desc then
		if desc.subrace == "Dwarf" then
			extra_types.horror = true assigned = true
			local m = {name="drem", base_list="mod.class.NPC:/data/general/npcs/horror-corrupted.lua"}
			if m then bodies[#bodies+1] = m end
		elseif desc.subrace == "Shalore" or desc.subrace == "Ogre" then
			extra_types.immovable = true assigned = true
			local m = {name="shimmering crystal", base_list="mod.class.NPC:/data/general/npcs/crystal.lua"}
			if m then bodies[#bodies+1] = m end
		elseif desc.subrace == "Thalore" then
			extra_types.elemental = true assigned = true
			local m = {name="umber hulk", base_list="mod.class.NPC:/data/general/npcs/xorn.lua"}
			if m then bodies[#bodies+1] = m end
		elseif desc.subrace == "Yeek" then
			extra_types.insect = true assigned = true
			local m = {name="ritch flamespitter", base_list="mod.class.NPC:/data/zones/ritch-tunnels/npcs.lua"}
			if m then bodies[#bodies+1] = m end
		elseif desc.subrace == "Skeleton" then
			extra_types.undead = true assigned = true
			local m = {name="ghoul", base_list="mod.class.NPC:/data/general/npcs/ghoul.lua"}
			if m then bodies[#bodies+1] = m end
		elseif desc.subrace == "Ghoul" then
			extra_types.undead = true assigned = true
			local m = {name="skeleton warrior", base_list="mod.class.NPC:/data/general/npcs/skeleton.lua"}
			if m then bodies[#bodies+1] = m end
		else
			if self:triggerHook{"Possessor:birthBodies", desc=desc, extra_types=extra_types, bodies=bodies} then
				assigned = true
			end
		end
	end
	if not assigned then
		extra_types.giant = true
		local m = {name="snow giant", base_list="mod.class.NPC:/data/general/npcs/snow-giant.lua"}
		if m then bodies[#bodies+1] = m end
	end
	return bodies, extra_types
end

newBirthDescriptor{
	type = "subclass",
	name = "Possessor",
	desc = {
		_t"#CRIMSON#BEWARE: This class is very #{italic}#strange#{normal}# and may be confusing to play for beginners.#LAST#",
		_t"Possessors are a rare breed of psionics. Some call them body snatchers. Some call them nightmarish.",
		_t"They are adept at stealing their foes corpses for their own use. Discarding their own bodies for a while to use other's.",
		_t"Their most important stats are: Willpower and Cunning",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * +2 Strength, +2 Dexterity, +0 Constitution",
		_t"#LIGHT_BLUE# * +0 Magic, +3 Willpower, +2 Cunning",
		_t"#GOLD#Life per level:#LIGHT_BLUE# -4",
	},
	birth_example_particles = {
		function(actor, birther)
			local Zone = require "mod.class.Zone"
			local NPC = require "mod.class.NPC"
			local st = core.game.getTime() - 500
			actor:addParticles(ParticlesCallback.new(function()
				local td = core.game.getTime() - st
				if td >= 1500 then
					st = core.game.getTime()
					-- if actor.replace_display then
					-- 	actor:removeShaderAura("possession")
					-- 	actor.replace_display = nil
					-- 	birther:setTile()
					-- else
						local bodies = grab_possessor_forms(actor, birther.descriptors_by_type)
						local bodydef = rng.table(bodies)
						local list = NPC:loadList(bodydef.base_list:gsub(".*:", ""))
						for i, m in ipairs(list) do
							if Zone:checkFilter(m, bodydef) and (not actor.replace_display or actor.replace_display.name ~= m.name) then
								local body = m:cloneFull()
								local resolves = table.reverse{"nice_tile"}
								for k, e in pairs(body) do
									if type(e) == "table" and e.__resolver and resolvers.calc[e.__resolver] and resolves[e.__resolver] then
										body[k] = resolvers.calc[e.__resolver](e, body, body, t, k, {})
									end
								end
								actor:addShaderAura("possession", "awesomeaura", {time_factor=2000, alpha=0.5, flame_scale=0.4}, "particles_images/lightningwings.png")
								actor.replace_display = body
								actor:updateModdableTile()
								break
							end
						end
					-- end
				end
				return true
			end))
		end,
		function(actor) if core.shader.active() then
			actor:removeShaderAura("possession")
			actor.replace_display = nil
			actor:addParticles(Particles.new("shader_shield", 1.5, {toback=true,  size_factor=1.5, img="tentacles_shader/original_tentacles_1"}, {type="tentacles", noup=2.0}))
			actor:addParticles(Particles.new("shader_shield", 1.5, {toback=false, size_factor=1.5, img="tentacles_shader/original_tentacles_1"}, {type="tentacles", noup=1.0}))
		end end,
		function(actor) if core.shader.active() then
			actor:removeShaderAura("possession")
			actor.replace_display = nil
			actor:addParticles(Particles.new("shader_shield", 1.5, {toback=true,  size_factor=1.5, img="tentacles_shader/whispy_tentacles_better"}, {type="tentacles", wobblingType=0, appearTime=0.4, time_factor=2000, noup=2.0}))
			actor:addParticles(Particles.new("shader_shield", 1.5, {toback=false, size_factor=1.5, img="tentacles_shader/whispy_tentacles_better"}, {type="tentacles", wobblingType=0, appearTime=0.4, time_factor=2000, noup=1.0}))
		end end,
	},
	not_on_random_boss = true,
	power_source = {psionic=true},
	stats = { str=2, dex=2, con=0, mag=0, wil=3, cun=2, },
	talents_types = {
		["psionic/possession"]={true, 0.3},
		["psionic/body-snatcher"]={false, 0.3},
		["psionic/psionic-menace"]={true, 0.3},
		["psionic/psychic-blows"]={true, 0.3},
		["psionic/battle-psionics"]={true, 0.3},
		["psionic/deep-horror"]={false, 0.3},
		["psionic/solipsism"]={true, 0.3},
		["psionic/mentalism"]={true, 0.3},
		["psionic/ravenous-mind"]={true, 0.3},
		["technique/combat-training"]={true, 0},
		["cunning/survival"]={true, 0},
	},
	talents = {
		[ActorTalents.T_POSSESS] = 1,
		[ActorTalents.T_BODIES_RESERVE] = 1,
		[ActorTalents.T_SOLIPSISM] = 1,
		[ActorTalents.T_PSIONIC_DISRUPTION] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		no_lichform_quest = 1, -- OH MY I feel dirty
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mace", name="iron mace", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_MAINHAND",
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_OFFHAND",
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, transmo=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ego_chance=-1000, ego_chance=-1000},
		},
		resolvers.generic(function(self) game:onTickEnd(function() -- Start with a few bodies
			local bodies, extra_types = grab_possessor_forms(self, self.descriptor)
			self.possess_allowed_extra_types = extra_types

			for _, bodydef in ipairs(bodies) do
				local m = game.zone:makeEntity(game.level, "actor", bodydef, nil, true)
				if m then m:forceLevelup(6) self:callTalent(self.T_BODIES_RESERVE, "storeBody", m, true) end
			end
		end) end),
	},
	copy_add = {
		life_rating = -4,
	},
}
