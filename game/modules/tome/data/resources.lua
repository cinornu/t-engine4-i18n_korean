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

local ActorResource = require "engine.interface.ActorResource"
local ActorTalents = require "engine.interface.ActorTalents"
print("[Resources] Defining Actor Resources")

-- Actor resources
-- Additional (ToME specific) fields (all optional):
-- cost_factor increases/decreases resource cost (used mostly to account for the effect of armor-based fatigue)
-- invert_values = true means the resource increases as it is consumed (equilibrium/paradox)
-- status_text = function(actor) returns a textual description of the resource status (defaults to "val/max")
-- color = text color string ("#COLOR#") to use to display the resource (text or uiset graphics)
-- hidden_resource = true prevents display of the resource in various interfaces
-- randomboss_enhanced = true gives random bosses some bonuses for the resource (see GameState:createRandomBoss)
-- depleted_unsustain = true makes sustained talents using the resource (with .remove_on_zero == true) deactivate when the resource is depleted
-- wait_on_rest = true causes resting (for the Player) to continue until the resource is replenished if possible
-- ai = parameters/routines for the ai:
-- 	tactical = table of tactical ai parameters (see ai.improved_tactical.lua, ActorAI):
--		default_pool_size, -- override the a default pool size (normally: def.max or 100 - def.min or 0), used to  evaluate the tactical value of gains/losses/regeneration, used by ActorAI.aiTalentTactics
--		want_level = function(act, aitarget), -- return a number (0 to +10) representing how much the actor needs to replenish the resource (used by the "improved tactical" AI)
-- 	aiResourceAction = function(actor, res_def, t_list) generate an action to replenish the resource
--		(for simple AIs, overrides the default method, called by ActorAI:aiResourceAction)
-- CharacterSheet = table of parameters to be used with the CharacterSheet (mod.dialogsCharacterSheet.lua):
--		status_text = function(act1, act2, compare_fields) generate text of resource status
-- Minimalist = table of parameters to be used with the Minimalist uiset (see uiset.Minimalist.lua)

-- == Resource Definitions ==
ActorResource:defineResource(_t"Air", "air", nil, "air_regen", _t"Air capacity in your lungs. Entities that need not breathe are not affected.", nil, nil, {
	color = "#LIGHT_STEEL_BLUE#",
	ai = {-- if drowning/suffocating due to terrain, try to move to a safe tile (simple AIs)
		aiResourceAction = function(actor, res_def)
			if actor.air >= actor.max_air then return end
			local dam, air = actor:aiGridDamage()
			local air_rate = air + actor.air_regen
			if air_rate <= 0 then
				local air_time = (actor.min_air - actor.air)/math.min(-1, air_rate)
				-- exaggerate time left while in combat (ignore air with > 20 turns left)
				if actor.ai_target.actor then
					if air_time > 20 then return else air_time = air_time*10 end
				end
				if actor.ai_state.safe_grid or rng.percent(100 - 100*air_time/(air_time + 50)) then -- 50% @ 50 turns left (5 turns in combat), 100% if already seeking air
					return {ai="move_safe_grid", name = "move to air"}
				end
			end
		end,
	}
})

ActorResource:defineResource(_t"Stamina", "stamina", ActorTalents.T_STAMINA_POOL, "stamina_regen", _t"Stamina represents your physical fatigue.  Most physical abilities consume it.", nil, nil, {
	color = "#ffcc80#",
	cost_factor = function(self, t, check) return (check and self:hasEffect(self.EFF_ADRENALINE_SURGE)) and 0 or (100 + self:combatFatigue()) / 100 end,
	wait_on_rest = true,
	restore_factor = 1,
	randomboss_enhanced = true,
})
ActorResource:defineResource(_t"Mana", "mana", ActorTalents.T_MANA_POOL, "mana_regen", _t"Mana represents your reserve of magical energies. Most spells cast consume mana and each sustained spell reduces your maximum mana.", nil, nil, {
	color = "#7fffd4#",
	cost_factor = function(self, t) return (100 + 2 * self:combatFatigue()) / 100 end,
	wait_on_rest = true,
	restore_factor = 1,
	randomboss_enhanced = true,
})
ActorResource:defineResource(_t"Equilibrium", "equilibrium", ActorTalents.T_EQUILIBRIUM_POOL, "equilibrium_regen", _t"Equilibrium represents your standing in the grand balance of nature. The closer it is to 0 the more balanced you are. Being out of equilibrium will adversely affect your ability to use Wild Gifts.", 0, false, {
	color = "#00ff74#", invert_values = true,
	wait_on_rest = true,
	restore_factor = -0.5,
	randomboss_enhanced = true,
	status_text = function(act)
		local _, chance = act:equilibriumChance()
		return ("%d (%d%%%% fail)"):tformat(act:getEquilibrium(), 100 - chance)
	end,
	ai = { -- special ai functions and data
		-- tactical AI
		tactical = {  default_pool_size = 100, -- assumed pool size to account for gains/losses/regeneration
			want_level = function(act, aitarget) -- (lower is always better) linear until failure chance > 0
				local value = math.min(2.5, 2.5*(act:getEquilibrium()-act:getMinEquilibrium())/act:getWil())*act.global_speed
				if value > 0 then
					local _, chance = act:equilibriumChance()
					value = value + 7.5*((100-chance)/100)^.5 -- avoid failure chance as much as possible
				end
				return value
			end
		},
		-- find a talent to restore equilibrium (simple AIs)
		aiResourceAction = function(act, res_def, t_filter, t_list)
			if act:getEquilibrium() > act:getMinEquilibrium() then
				local tid = act:aiGetResourceTalent(res_def, t_filter, t_list)
				if tid then
				if config.settings.log_detail_ai > 1 then print("[aiResourceAction:equilibrium]:", act.name, act.uid, "picked talent", tid, "to replenish", res_def.name) end
					return {name = "custom equilibrium", tid=tid}
				end
			end
		end,
	},
	CharacterSheet = { -- special params for the character sheet
		status_text = function(act1, act2, compare_fields)
			local text = compare_fields(act1, act2, function(act) local _, chance = act:equilibriumChance() return 100-chance end, "%d%%", "%+d%%", 1, true)
			return ("%d(fail: %s)"):tformat(act1:getEquilibrium(),text)
		end,
	},
	Minimalist = { --parameters for the Minimalist uiset
		images = {front = "resources/front_nature.png", front_dark = "resources/front_nature_dark.png"},
		highlight = function(player, vc, vn, vm, vr) -- dim the resource display if fail chance <= 15%
			if player then
				local _, chance = player:equilibriumChance()
				if chance > 85 then return true end
			end
		end,
		shader_params = {display_resource_bar = function(player, shader, x, y, color, a) -- update the resource bar shader
				if player ~= table.get(game, "player") or not shader or not a then return end
				local _, chance = player:equilibriumChance()
				local s = 100 - chance
				if s > 15 then s = 15 end
				s = s / 15
				if shader.shad then
					shader:setUniform("pivot", math.sqrt(s))
					shader:setUniform("a", a)
					shader:setUniform("speed", 10000 - s * 7000)
					shader.shad:use(true)
				end

				local p = chance / 100
				shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], color[1], color[2], color[3], a)
				if shader.shad then shader.shad:use(false) end
			end
		}
	}
})

ActorResource:defineResource(_t"Vim", "vim", ActorTalents.T_VIM_POOL, "vim_regen", _t"Vim represents the amount of life energy/souls you have stolen. Each corruption talent requires some.", nil, nil, {
	color = "#904010#",
	wait_on_rest = true,
	randomboss_enhanced = true,
	restore_factor = 0.8,
	Minimalist = {shader_params = {color = {0x90/255, 0x40/255, 0x10/255}}} --parameters for the Minimalist uiset
})
ActorResource:defineResource(_t"Positive energy", "positive", ActorTalents.T_POSITIVE_POOL, "positive_regen", _t"Positive energy represents your reserve of positive power. It slowly increases.", nil, nil, {
	color = "#ffd700#",
	wait_on_rest = true,
	restore_factor = 0.4,
	randomboss_enhanced = true,
	cost_factor = function(self, t, check, value) if value < 0 then return 1 else return (100 + self:combatFatigue()) / 100 end end,
	Minimalist = {highlight = function(player, vc, vn, vm, vr) return vc >=0.7*vm end},
})
ActorResource:defineResource(_t"Negative energy", "negative", ActorTalents.T_NEGATIVE_POOL, "negative_regen", _t"Negative energy represents your reserve of negative power. It slowly increases.", nil, nil, {
	color = "#7f7f7f#",
	randomboss_enhanced = true,
	restore_factor = 0.4,
	wait_on_rest = true,
	cost_factor = function(self, t, check, value) if value < 0 then return 1 else return (100 + self:combatFatigue()) / 100 end end,
	Minimalist = {highlight = function(player, vc, vn, vm, vr) return vc >=0.7*vm end},
})
ActorResource:defineResource(_t"Hate", "hate", ActorTalents.T_HATE_POOL, "hate_regen", _t"Hate represents your soul's primal antipathy towards others.  It generally decreases whenever you have no outlet for your rage, and increases when you are damaged or destroy others.", nil, nil, {
	color = "#ffa0ff#",
	restore_factor = 0.4,
	cost_factor = function(self, t) return (100 + self:combatFatigue()) / 100 end,
	Minimalist = {highlight = function(player, vc, vn, vm, vr) return vc >=100 end},
})
ActorResource:defineResource(_t"Paradox", "paradox", ActorTalents.T_PARADOX_POOL, "paradox_regen", _t"Paradox represents how much damage you've done to the space-time continuum. A high Paradox score makes Chronomancy less reliable and more dangerous to use but also amplifies its effects.", 0, false, {
	color = "#4198dc#", invert_values = true,
--	randomboss_enhanced = true,
	status_text = function(act)
		local chance = act:paradoxFailChance()
		return ("%d/%d (%d%%%%)"):tformat(act:getModifiedParadox(), act:getParadox(), chance), chance
	end,
	ai = { -- special ai functions and data
		tactical = { default_pool_size = 100, -- assumed pool size to account for gains/losses/regeneration
			want_level = function(act, aitarget)
				local value = util.bound(5*(act:getParadox()-(act.preferred_paradox or 300))*act.global_speed/300, -10, 5) -- excess paradox
				value = value + math.min(value, 5*(act:paradoxFailChance()/100)^.5) -- preferred paradox overrides failure chance
				return value
			end
		},
		-- find a talent to reduce paradox if it is above preferred_paradox (simple AIs)
		aiResourceAction = function(act, res_def, t_filter, t_list)
			local val, min = act:getParadox(), act:getMinParadox()
			if val - math.max(act.preferred_paradox or 300, min) > 0 then
				local tid = act:aiGetResourceTalent(res_def, t_filter, t_list)
				if tid then
					if config.settings.log_detail_ai > 1 then print("[aiResourceAction:paradox]:", act.name, act.uid, "picked talent", tid, "to replenish", res_def.name) end
					return {name = "custom paradox", tid=tid}
				end
			end
		end,
	},
	CharacterSheet = { -- special params for the character sheet
		status_text = function(act1, act2, compare_fields)
			local text = compare_fields(act1, act2, function(act) return act:paradoxFailChance() end, "%d%%", "%+d%%", 1, true)
			return ("%d/%d(anom: %s)"):tformat(act1:getModifiedParadox(), act1:getParadox(), text)
		end,
	},
	Minimalist = { --parameters for the Minimalist uiset
		highlight = function(player, vc, vn, vm, vr) -- highlight the resource display if fail chance > 10%
			if player then
				local chance = player:paradoxFailChance()
				if chance > 10 then return true end
			end
		end,
		shader_params = {display_resource_bar = function(player, shader, x, y, color, a) -- update the resource bar shader
			if player ~= table.get(game, "player") or not shader or not a then return end
			local chance = player:paradoxFailChance()
			local vm = player:getModifiedParadox()
			local s = chance
			if s > 15 then s = 15 end
			s = s / 15
			if shader.shad then
				shader:setUniform("pivot", math.sqrt(s))
				shader:setUniform("a", a)
				shader:setUniform("speed", 10000 - s * 7000)
				shader.shad:use(true)
			end
			local p = util.bound(600-vm, 0, 300) / 300
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], color[1], color[2], color[3], a)
			if shader.shad then shader.shad:use(false) end
		end
		}
	},
})
ActorResource:defineResource(_t"Psi", "psi", ActorTalents.T_PSI_POOL, "psi_regen", _t"Psi represents your reserve of psychic energy.", nil, nil, {
	color = "#4080ff#",
	wait_on_rest = true,
	randomboss_enhanced = true,
	restore_factor = 0.5,
	cost_factor = function(self, t) return (100 + 2 * self:combatFatigue()) / 100 end,
	ai = { -- special ai functions and data
		tactical = { -- tactical AI
			want_level = function(act, aitarget) -- compute want level for psi
				local life_regen, psi_regen = act:regenLife(true) -- (includes Solipsism effect on psi_regen)
				local depleted = 1-(act:getPsi() + math.max(0, psi_regen or 0))/act.max_psi
				-- use std resource formula, accounting for Solipsism regeneration
				depleted = depleted/math.max(0.001, 1-depleted)*act.global_speed
				return 10*(depleted/(depleted + 2.5))^2
			end
		},
		-- find a talent to restore psi (simple AIs)
		aiResourceAction = function(act, res_def, t_filter, t_list)
			if act:getPsi() < act.max_psi * act.AI_RESOURCE_LEVEL_TRIGGER then
				local tid = act:aiGetResourceTalent(res_def, t_filter, t_list)
				if tid then
					if config.settings.log_detail_ai > 1 then print("[aiResourceAction:psi]:", act.name, act.uid, "picked talent", tid, "to replenish", res_def.name) end
					return {name = "restore psi", tid=tid}
				end
				-- Solipsists can use healing to restore psi
				if act:knowTalent(act.T_SOLIPSISM) then
					local filter = {mode="activated", properties = {"is_heal"}}
					local tid_list = act:aiGetAvailableTalents(aitarget, filter)
					if #tid_list > 0 then
						local tid = rng.tableRemove(tid_list)
						if config.settings.log_detail_ai > 1 then print("[aiResourceAction:psi]:", act.name, act.uid, "picked healing talent", tid, "to replenish", res_def.name) end
						return {name = "restore psi (Solipsism heal)", tid=tid}
					end
				end
			end
		end
	},
})
ActorResource:defineResource(_t"Souls", "soul", ActorTalents.T_SOUL_POOL, "soul_regen", _t"This is the number of soul fragments you have extracted from your foes for your own use.", 0, 10, {
	color = "#bebebe#",
	randomboss_enhanced = true,
	Minimalist = {images = {front = "resources/front_souls.png", front_dark = "resources/front_souls_dark.png"}},
})
