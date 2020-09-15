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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"
local Combat = require "mod.class.interface.Combat"

-- Elemental Surge effects here to avoid interaction with duration increases since so many can be up at once
newEffect{
	name = "ETHEREAL_FORM", image = "talents/displace_damage.png",
	desc = _t"Ethereal Form",
	long_desc = function(self, eff) return ("Ethereal Form bonuses reduced by %d%%"):tformat(eff.stacks * 5) end,
	type = "other",
	subtype = { },
	status = "detrimental",
	parameters = { stacks = 0},
	charges = function(self, eff) return eff.stacks end,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	updateEffect = function(self, eff)
		eff.stacks = math.min(5, eff.stacks)
		if eff.resists then self:removeTemporaryValue("resists", eff.resists) end
		if eff.damage then self:removeTemporaryValue("resists_pen", eff.damage) end
		eff.resists = self:addTemporaryValue("resists", {absolute = -(eff.stacks * 5)})
		eff.damage = self:addTemporaryValue("resists_pen", {all = -(eff.stacks * 5)})
	end,
	on_merge = function(self, old_eff, new_eff, e)
		old_eff.stacks = old_eff.stacks + 1
		e.updateEffect(self, old_eff)
		return old_eff
	end,
	activate = function(self, eff, e)
		eff.stacks = 1
		e.updateEffect(self, eff)
	end,
	deactivate = function(self, eff, e)
		if eff.resists then self:removeTemporaryValue("resists", eff.resists) end
		if eff.damage then self:removeTemporaryValue("resists_pen", eff.damage) end
	end,

}

newEffect{
	name = "ELEMENTAL_SURGE_ARCANE", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Arcane",
	long_desc = function(self, eff) return (_t"Spell and mind speed increased by 30%") end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_spellspeed", 0.3)
		self:effectTemporaryValue(eff, "combat_mindspeed", 0.3)
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_PHYSICAL", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Physical",
	long_desc = function(self, eff) return (_t"Immune to detrimental physical effects") end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "physical_negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_NATURE", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Nature",
	long_desc = function(self, eff) return (_t"Immune to detrimental magical effects") end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "spell_negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_FIRE", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Fire",
	long_desc = function(self, eff) return ("All damage increased by %d%%"):tformat(eff.damage) end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = {damage = 30 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff,"inc_damage", {all = eff.damage})
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_COLD", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Cold",
	long_desc = function(self, eff) return ("Armor increased by %d, deals %d ice damage when hit in melee."):tformat(eff.armor, eff.dam) end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = {armor=0, dam=100 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_armor", eff.armor)
		self:effectTemporaryValue(eff, "on_melee_hit", {[DamageType.ICE]=eff.dam})
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_LIGHTNING", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Lightning",
	long_desc = function(self, eff) return ("Movement speed increased by %d%%."):tformat(eff.move) end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = { move = 50},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "movement_speed", eff.move/100)
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_LIGHT", image = "talents/elemental_surge.png",
	desc = _t"Elemental Surge: Light",
	long_desc = function(self, eff) return ("All talent cooldowns reduced by %d%%."):tformat(eff.cooldown) end,
	type = "other",
	subtype = {elemental = true },
	status = "beneficial",
	parameters = {cooldown = 20 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "talent_cd_reduction", {allpct = eff.cooldown / 100})
	end,
}

newEffect{
	name = "SURGING_CIRCLES", image = "talents/celestial_surge.png",
	desc = _t"Circle Surge",
	long_desc = function(self, eff) return _t[[Residual power from the surge is emanating from the circles.
		Shifting Shadows: +1 negative.
		Sanctity: +1 postive.
		Warding: +0.5 postive and negative.]] end,
	type = "other",
	subtype = {},
	status = "beneficial",
	paramters = {},
}

newEffect{
	name = "FLASH_SHIELD", image = "talents/flash_of_the_blade.png",
	desc = _t"Protected by the Sun",
	long_desc = function(self, eff) return _t"The Sun has granted a brief immunity to all damage." end,
	type = "other",
	subtype = {},
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target# whirls around and a radiant shield surrounds them!", _t"+Divine Shield" end,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "cancel_damage_chance", 100)
	end,
	deactivate = function(self, eff)

	end,
}

-- type other because this is a core defensive mechanic in debuff form, it should not interact with saves
newEffect{
	name = "ABSORPTION_STRIKE", image = "talents/absorption_strike.png",
	desc = _t"Absorption Strike",
	long_desc = function(self, eff) return ("The target's light has been drained, reducing light resistance by %d%% and damage by %d%%."):tformat(eff.power, eff.numb) end,
	type = "other",
	subtype = { sun=true, },
	status = "detrimental",
	parameters = { power = 10, numb = 1 },
	on_gain = function(self, err) return _t"#Target# is drained from light!", _t"+Absorption Strike" end,
	on_lose = function(self, err) return _t"#Target#'s light is back.", _t"-Absorption Strike" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHT]=-eff.power})
		self:effectTemporaryValue(eff, "numbed", eff.numb)
	end,
}

newEffect{
	name = "ITEM_CHARM_PIERCING", image = "talents/intricate_tools.png",
	desc = _t"Charm:  Piercing",
	long_desc = function(self, eff) return ("All damage penetration increased by %d%%."):tformat(eff.penetration) end,
	type = "other",
	subtype = { },
	status = "beneficial",
	parameters = { penetration=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists_pen", {all = eff.penetration})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ITEM_CHARM_POWERFUL", image = "talents/intricate_tools.png",
	desc = _t"Charm:  Damage",
	long_desc = function(self, eff) return ("All damage increased by %d%%."):tformat(eff.damage) end,
	type = "other",
	subtype = { },
	status = "beneficial",
	parameters = { damage=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {all = eff.damage})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ITEM_CHARM_SAVIOR", image = "talents/intricate_tools.png",
	desc = _t"Charm:  Saves",
	long_desc = function(self, eff) return ("All saves increased by %d."):tformat(eff.save) end,
	type = "other",
	subtype = { },
	status = "beneficial",
	parameters = { save=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physresist", eff.save)
		self:effectTemporaryValue(eff, "combat_spellresist", eff.save)
		self:effectTemporaryValue(eff, "combat_mentalresist", eff.save)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ITEM_CHARM_EVASIVE", image = "talents/intricate_tools.png",
	desc = _t"Charm:  Evasion",
	long_desc = function(self, eff) return ("%d%% chance to avoid weapon attacks"):tformat(eff.chance) end,
	type = "other",
	subtype = { },
	status = "beneficial",
	parameters = { chance=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "evasion", eff.chance)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ITEM_CHARM_INNERVATING", image = "talents/intricate_tools.png",
	desc = _t"Charm:  Innervating",
	long_desc = function(self, eff) return ("Fatigue reduced by %d%%."):tformat(eff.fatigue) end,
	type = "other",
	subtype = { },
	status = "beneficial",
	parameters = { fatigue=10, },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "fatigue", -eff.fatigue)
	end,
	deactivate = function(self, eff)
	end,
}

-- Design:  Temporary immobility in exchange for a large stat buff.
newEffect{
	name = "TREE_OF_LIFE", image = "shockbolt/object/artifact/tree_of_life.png",
	desc = _t"You have taken root!",
	long_desc = function(self, eff) return _t"You have taken root becoming one with nature.  Or at least the ground.  Your health, armor, and armor hardiness are improved but you cannot move." end,
	type = "other",
	subtype = { nature=true },
	--status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#LIGHT_BLUE##Target# takes root.", _t"+Pinned" end,
	on_lose = function(self, err) return _t"#LIGHT_BLUE##Target# is no longer a badass tree.", _t"-Pinned" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
		self:effectTemporaryValue(eff, "max_life", 300)
		self:effectTemporaryValue(eff, "combat_armor", 20)
		self:effectTemporaryValue(eff, "combat_armor_hardiness", 20)

		self.replace_display = mod.class.Actor.new{
			image="invis.png",
			add_mos = {{image = "npc/giant_treant_wrathroot.png",
			display_y = -1,
			display_h = 2}},
		}

		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

	end,
	deactivate = function(self, eff)
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "INFUSION_COOLDOWN", image = "effects/infusion_cooldown.png",
	desc = _t"Infusion Saturation",
	long_desc = function(self, eff) return ("The more you use infusions, the longer they will take to recharge (+%d cooldowns)."):tformat(eff.power) end,
	charges = function(self, eff) return eff.power end,
	type = "other",
	subtype = { infusion=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "RUNE_COOLDOWN", image = "effects/rune_cooldown.png",
	desc = _t"Runic Saturation",
	long_desc = function(self, eff) return ("The more you use runes, the longer they will take to recharge (+%d cooldowns)."):tformat(eff.power) end,
	charges = function(self, eff) return eff.power end,
	type = "other",
	subtype = { rune=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "TAINT_COOLDOWN", image = "effects/tainted_cooldown.png",
	desc = _t"Tainted",
	long_desc = function(self, eff) return ("The more you use taints, the longer they will take to recharge (+%d cooldowns)."):tformat(eff.power) end,
	type = "other",
	subtype = { taint=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "PATH_OF_THE_SUN", image = "talents/path_of_the_sun.png",
	desc = _t"Path of the Sun",
	long_desc = function(self, eff) return ("The target is able to instantly travel alongside Sun Paths."):tformat() end,
	type = "other",
	subtype = { sun=true, },
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "walk_sun_path", 1)
	end
}

newEffect{
	name = "TIME_PRISON", image = "talents/time_prison.png",
	desc = _t"Time Prison",
	long_desc = function(self, eff) return _t"The target is removed from the normal time stream, unable to act but unable to take any damage. Time does not pass for this creature." end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	tick_on_timeless = true,
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is removed from time!", _t"+Out of Time" end,
	on_lose = function(self, err) return _t"#Target# is returned to normal time.", _t"-Out of Time" end,
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("invulnerable", 1)
		eff.sid = self:addTemporaryValue("time_prison", 1)
		eff.tid = self:addTemporaryValue("no_timeflow", 1)
		eff.imid = self:addTemporaryValue("status_effect_immune", 1)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="arcanegeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=3000, noup=2.0}))
			eff.particle1.toback = true
			eff.particle2 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="arcanegeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=3000, noup=1.0}))
		else
			eff.particle1 = self:addParticles(Particles.new("time_prison", 1))
		end
		self.energy.value = 0
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.iid)
		self:removeTemporaryValue("time_prison", eff.sid)
		self:removeTemporaryValue("no_timeflow", eff.tid)
		self:removeTemporaryValue("status_effect_immune", eff.imid)
		if eff.particle1 then self:removeParticles(eff.particle1) end
		if eff.particle2 then self:removeParticles(eff.particle2) end
	end,
}

newEffect{
	name = "TIME_SHIELD", image = "talents/time_shield.png",
	desc = _t"Time Shield",
	long_desc = function(self, eff) return ("The target is surrounded by a time distortion, absorbing %d/%d damage and sending it forward in time. While active all newly applied status effects durations are reduced by %d%%."):tformat(self.time_shield_absorb, eff.power, eff.time_reducer) end,
	type = "other",
	subtype = { time=true, shield=true },
	status = "beneficial",
	parameters = { power=10, dot_dur=5, time_reducer=20 },
	on_gain = function(self, err) return _t"The very fabric of time alters around #target#.", _t"+Time Shield" end,
	on_lose = function(self, err) return _t"The fabric of time around #target# stabilizes to normal.", _t"-Time Shield" end,
	on_aegis = function(self, eff, aegis)
		self.time_shield_absorb = self.time_shield_absorb + eff.power * aegis / 100
		if core.shader.active(4) then
			self:removeParticles(eff.particle)
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1.2, scrollingSpeed=-2, time_factor=4000, bubbleColor={1, 1, 0.3, 1.0}, auraColor={1, 0.8, 0.2, 1}}))
		end
	end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		eff.power = self:getShieldAmount(eff.power)
		eff.dur = self:getShieldDuration(eff.dur)
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.time_reducer)
		eff.tmpid = self:addTemporaryValue("time_shield", eff.power)
		--- Warning there can be only one time shield active at once for an actor
		self.time_shield_absorb = eff.power
		self.time_shield_absorb_max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield3"}, {type="shield", shieldIntensity=0.1, horizontalScrollingSpeed=-0.2, verticalScrollingSpeed=-1, time_factor=2000, color={1, 1, 0.3}}))
		else
			eff.particle = self:addParticles(Particles.new("time_shield_bubble", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", eff.durid)

		self:removeParticles(eff.particle)

		-- Time shield ends, setup a restoration field if needed
		if eff.power - self.time_shield_absorb > 0 then
			local val = (eff.power - self.time_shield_absorb) / eff.dot_dur / 2
			print("Time shield restoration field", eff.power - self.time_shield_absorb, val)
			self:setEffect(self.EFF_TIME_DOT, eff.dot_dur, {power=val})
		end

		self:removeTemporaryValue("time_shield", eff.tmpid)
		self.time_shield_absorb = nil
		self.time_shield_absorb_max = 0
	end,
}

newEffect{
	name = "TIME_DOT",
	desc = _t"Temporal Restoration Field",
	long_desc = function(self, eff) return ("The time distortion has created a restoration field, healing the target for %d each turn."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"The powerful time-altering energies generate a restoration field on #target#.", _t"+Temporal Restoration Field" end,
	on_lose = function(self, err) return _t"The fabric of time around #target# returns to normal.", _t"-Temporal Restoration Field" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("time_shield", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		self:heal(eff.power, eff)
	end,
}

newEffect{
	name = "GOLEM_OFS",
	desc = _t"Golem out of sight",
	long_desc = function(self, eff) return _t"The golem is out of sight of the alchemist; direct control will be lost!" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#LIGHT_RED##Target# is out of sight of its master; direct control will break!", _t"+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#You lost sight of your golem for too long; direct control is broken!")
				game.player:runStop(_t"golem out of sight")
				game.player:restStop(_t"golem out of sight")
				game.party:setPlayer(self.summoner)
			end)
		end
	end,
}

newEffect{
	name = "AMBUSCADE_OFS", image = "talents/ambuscade.png",
	desc = _t"Shadow out of sight",
	long_desc = function(self, eff) return _t"The shadow is out of sight of its host; direct control will be lost!" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#LIGHT_RED##Target# is out of sight of its master; direct control will break!", _t"+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#You lost sight of your shadow for too long; it dissipates!")
				game.player:runStop(_t"shadow out of sight")
				game.player:restStop(_t"shadow out of sight")
				game.party:setPlayer(self.summoner)
			end)
		end
	end,
}

newEffect{
	name = "HUSK_OFS", image = "talents/animus_purge.png",
	desc = _t"Husk out of sight",
	long_desc = function(self, eff) return _t"The husk is out of sight of its host; direct control will be lost!" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#LIGHT_RED##Target# is out of sight of its master; direct control will break!", _t"+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#You lost sight of your husk for too long; it disintegrates!")
				game.player:runStop(_t"husk out of sight")
				game.player:restStop(_t"husk out of sight")
				game.party:setPlayer(self.summoner)
				self:die(self)
			end)
		end
	end,
}

newEffect{
	name = "CONTINUUM_DESTABILIZATION",
	desc = _t"Continuum Destabilization",
	long_desc = function(self, eff) return ("The target has been affected by space or time manipulations and is becoming more resistant to them (+%d)."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# looks a little pale around the edges.", _t"+Destabilized" end,
	on_lose = function(self, err) return _t"#Target# is firmly planted in reality.", _t"-Destabilized" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the continuum_destabilization
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- Need to remove and re-add the continuum_destabilization
		self:removeTemporaryValue("continuum_destabilization", old_eff.effid)
		old_eff.effid = self:addTemporaryValue("continuum_destabilization", old_eff.power)
		return old_eff
	end,
	activate = function(self, eff)
		eff.effid = self:addTemporaryValue("continuum_destabilization", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("continuum_destabilization", eff.effid)
	end,
}

newEffect{
	name = "SUMMON_DESTABILIZATION",
	desc = _t"Summoning Destabilization",
	long_desc = function(self, eff) return ("The more the target summons creatures the longer it will take to summon more (+%d turns)."):tformat(eff.power) end,
	type = "other", -- Type "other" so that nothing can dispel it
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { power=10 },
	no_stop_enter_worlmap = true,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the destabilizations
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		-- Need to remove and re-add the talents CD
		self:removeTemporaryValue("talent_cd_reduction", old_eff.effid)
		old_eff.effid = self:addTemporaryValue("talent_cd_reduction", { [self.T_SUMMON] = -old_eff.power })
		return old_eff
	end,
	activate = function(self, eff)
		eff.effid = self:addTemporaryValue("talent_cd_reduction", { [self.T_SUMMON] = -eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_cd_reduction", eff.effid)
	end,
}

newEffect{
	name = "DAMAGE_SMEARING", image = "talents/damage_smearing.png",
	desc = _t"Damage Smearing",
	long_desc = function(self, eff) return ("Damage received in the past is returned as %0.2f temporal damage per turn."):tformat(eff.dam) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return _t"#Target# is taking damage received in the past!", _t"+Smeared" end,
	on_lose = function(self, err) return _t"#Target# stops taking damage received in the past.", _t"-Smeared" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.dam * old_eff.dur
		local newdam = new_eff.dam * new_eff.dur
		new_eff.dam = (olddam + newdam) / new_eff.dur
		return new_eff
	end,
	on_timeout = function(self, eff)
		local dead, val = self:takeHit(eff.dam, self, {special_death_msg="was smeared across all space and time"})

		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):tformat(DamageType:get(DamageType.TEMPORAL).text_color or "#aaaaaa#", math.ceil(val), DamageType:get(DamageType.TEMPORAL).name), false)
	end,
}

newEffect{
	name = "SEE_THREADS", image = "talents/see_the_threads.png",
	desc = _t"See the Threads",
	long_desc = function(self, eff) return ("You walk three different timelines, choosing the one you prefer at the end (current timeline: %d)."):tformat(eff.thread) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10, defense=0, crits=0 },
	remove_on_clone = true,
	activate = function(self, eff)
		eff.thread = 1
		eff.max_dur = eff.dur
		game:onTickEnd(function()
			game:chronoClone("see_threads_base")
		end)

		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crits)
		self:effectTemporaryValue(eff, "combat_def", eff.defense)
	end,
	deactivate = function(self, eff)
		-- clone protection
		if self ~= game.player then
			return
		end

		game:onTickEnd(function()

			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#The see the threads spell fizzles and cancels, leaving you in this timeline.")
				return
			end

			if eff.thread < 3 then
				local worlds = game._chronoworlds

				-- Clone but not the subworlds
				game._chronoworlds = nil
				local clone = game:chronoClone()

				-- Restore the base world and resave it
				game._chronoworlds = worlds
				game:chronoRestore("see_threads_base", true)

				-- Setup next thread
				local eff = game.player:hasEffect(game.player.EFF_SEE_THREADS)
				eff.thread = eff.thread + 1
				game.logPlayer(game.player, "#LIGHT_BLUE#You unfold the space time continuum to the start of the time threads!")

				game._chronoworlds = worlds
				game:chronoClone("see_threads_base")

				-- Add the previous thread
				game._chronoworlds["see_threads_"..(eff.thread-1)] = clone
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "rewrite_universe")
				return
		else
				game._chronoworlds.see_threads_base = nil
				local chat = Chat.new("chronomancy-see-threads", {name=_t"See the Threads"}, self, {turns=eff.max_dur})
				chat:invoke()
			end
		end)
	end,
}

newEffect{
	name = "IMMINENT_PARADOX_CLONE",
	desc = _t"Imminent Paradox Clone",
	long_desc = function(self, eff) return _t"When the effect expires you'll be pulled into the past." end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { power=10 },
	activate = function(self, eff)
			game:onTickEnd(function()
			game:chronoClone("paradox_past")
		end)
	end,
	deactivate = function(self, eff)
		local t = self:getTalentFromId(self.T_PARADOX_CLONE)
		local base = t.getDuration(self, t) - 2
		game:onTickEnd(function()
			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#You've altered your destiny and will not be pulled into the past.")
				return
			end

			local worlds = game._chronoworlds
			-- save the players health so we can reload it
			local oldplayer = game.player

			-- Clone but not the subworlds
			game._chronoworlds = nil
			local clone = game:chronoClone()
			game._chronoworlds = worlds

			-- Move back in time, but keep the paradox_future world stored
			game:chronoRestore("paradox_past", true)
			game._chronoworlds = game._chronoworlds or {}
			game._chronoworlds["paradox_future"] = clone
			game.logPlayer(self, "#LIGHT_BLUE#You've been pulled into the past!")
			-- pass health and resources into the new timeline
			game.player.life = oldplayer.life
			for i, r in ipairs(game.player.resources_def) do
				game.player[r.short_name] = oldplayer[r.short_name]
			end

			-- Hack to remove the IMMINENT_PARADOX_CLONE effect in the past
			-- Note that we have to use game.player now since self refers to self from the future!
			game.player.tmp[self.EFF_IMMINENT_PARADOX_CLONE] = nil

			-- Setup the return effect
			game.player:setEffect(self.EFF_PARADOX_CLONE, base, {})
		end)
	end,
}

newEffect{
	name = "PARADOX_CLONE", image = "talents/paradox_clone.png",
	desc = _t"Paradox Clone",
	long_desc = function(self, eff) return _t"You've been pulled into the past." end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { power=10 },
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		-- save the players rescources so we can reload it
		local oldplayer = game.player
		game:onTickEnd(function()
			game:chronoRestore("paradox_future")
			-- Reload the player's health and resources
			game.logPlayer(game.player, "#LIGHT_BLUE#You've been returned to the present!")
			game.player.life = oldplayer.life
			for i, r in ipairs(game.player.resources_def) do
				game.player[r.short_name] = oldplayer[r.short_name]
			end
		end)
	end,
}

newEffect{
	name = "MILITANT_MIND", image = "talents/militant_mind.png",
	desc = _t"Militant Mind",
	long_desc = function(self, eff) return ("Increases physical power, physical save, spellpower, spell save, mindpower, and mental save by %d."):tformat(eff.power) end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", eff.power)
		eff.spellid = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.mindid = self:addTemporaryValue("combat_mindpower", eff.power)
		eff.presid = self:addTemporaryValue("combat_physresist", eff.power)
		eff.sresid = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.mresid = self:addTemporaryValue("combat_mentalresist", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_mindpower", eff.mindid)
		self:removeTemporaryValue("combat_physresist", eff.presid)
		self:removeTemporaryValue("combat_spellresist", eff.sresid)
		self:removeTemporaryValue("combat_mentalresist", eff.mresid)
	end,
}

newEffect{
	name = "SEVER_LIFELINE", image = "talents/sever_lifeline.png",
	desc = _t"Sever Lifeline",
	long_desc = function(self, eff) return ("The target's lifeline is being cut. When the effect ends %d temporal damage will hit the target."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = {power=10000},
	on_gain = function(self, err) return _t"#Target#'s lifeline is being severed!", _t"+Sever Lifeline" end,
	deactivate = function(self, eff)
		if not eff.src or eff.src.dead then return end
		if not eff.src:hasLOS(self.x, self.y) then return end
		if eff.dur >= 1 then return end
		DamageType:get(DamageType.TEMPORAL).projector(eff.src, self.x, self.y, DamageType.TEMPORAL, eff.power)
	end,
}

newEffect{
	name = "FADE_FROM_TIME", image = "talents/fade_from_time.png",
	desc = _t"Fade From Time",
	long_desc = function(self, eff) return ("The target is partially removed from the timeline, reducing all damage dealt by %d%%, all damage received by %d%%, and the duration of all detrimental effects by %d%%."):
	tformat(math.min(20,eff.dur * 2 + 2), eff.cur_power or eff.power, eff.cur_dur or eff.durred) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 ,durred = 15 },
	on_gain = function(self, err) return _t"#Target# has partially removed itself from the timeline.", _t"+Fade From Time" end,
	on_lose = function(self, err) return _t"#Target# has returned fully to the timeline.", _t"-Fade From Time" end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("inc_damage", old_eff.dmgid)
		self:removeTemporaryValue("resists", old_eff.rstid)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", old_eff.durid)
		old_eff.cur_power = (new_eff.power)
		old_eff.cur_dur = new_eff.durred
		old_eff.dmgid = self:addTemporaryValue("inc_damage", {all = - old_eff.dur * 2})
		old_eff.rstid = self:addTemporaryValue("resists", {all = old_eff.cur_power})
		old_eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", old_eff.cur_dur)
		old_eff.dur = old_eff.dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		local current = eff.power * eff.dur/10
		local currentdur = eff.durred * eff.dur/10
		self:setEffect(self.EFF_FADE_FROM_TIME, 1, {power = current, durred=currentdur})
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.rstid = self:addTemporaryValue("resists", { all = eff.power})
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.durred)
		eff.dmgid = self:addTemporaryValue("inc_damage", {all = -20})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", eff.durid)
		self:removeTemporaryValue("resists", eff.rstid)
		self:removeTemporaryValue("inc_damage", eff.dmgid)
	end,
}

newEffect{
	name = "SHADOW_VEIL", image = "talents/shadow_veil.png",
	desc = _t"Shadow Veil",
	long_desc = function(self, eff) return ("You veil yourself in shadows and let them control you. While in the veil you become immune to status effects, and gain %d%% all damage reduction. Each turn you blink to a nearby foe within range %d, hitting it for %d%% darkness weapon damage. While this goes on you cannot be stopped unless you are killed, and you cannot control your character."):tformat(eff.res, eff.range, eff.dam * 100) end,
	type = "other",
	subtype = { darkness=true },
	status = "beneficial",
	parameters = { res=10, dam=1.5, range=5, x=0, y=0},
	on_gain = function(self, err) return _t"#Target# is covered in a veil of shadows!", _t"+Assail" end,
	on_lose = function(self, err) return _t"#Target# is no longer covered by shadows.", _t"-Assail" end,
	activate = function(self, eff)
		eff.sefid = self:addTemporaryValue("negative_status_effect_immune", 1)
		eff.resid = self:addTemporaryValue("resists", {all=eff.res})
		self.never_act = true
	end,
	on_timeout = function(self, eff)
		local maxdist = self:callTalent(self.T_SHADOW_VEIL, "getBlinkRange")
		self.never_act = true
		repeat
			local acts = {}
			local act

			self:doFOV() -- update actors seen
			for i = 1, #self.fov.actors_dist do
				act = self.fov.actors_dist[i]
				if act and self:reactionToward(act) < 0 and not act.dead and eff.x and act:isNear(eff.x, eff.y, maxdist) then
					local sx, sy = util.findFreeGrid(act.x, act.y, 1, true, {[engine.Map.ACTOR]=true})
					if sx then acts[#acts+1] = {act, sx, sy} end
				end
			end
			if #acts == 0 then
				self.never_act = nil  -- If there was ever something worth making redundant..
				self:removeEffect(self.EFF_SHADOW_VEIL)
				return
			end

			act = rng.table(acts)
			self:move(act[2], act[3], true)
			game.level.map:particleEmitter(act[2], act[3], 1, "dark")
			self:attackTarget(act[1], DamageType.DARKNESS, eff.dam) -- Attack *and* use energy
		until self.energy.value < 0  -- keep blinking and attacking until out of energy (since on_timeout is only once per turn)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("negative_status_effect_immune", eff.sefid)
		self:removeTemporaryValue("resists", eff.resid)
		self.never_act = nil
	end,
}

newEffect{
	name = "ZERO_GRAVITY", image = "effects/zero_gravity.png",
	desc = _t"Zero Gravity",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"There is no gravity here; you float in the air. Movement is three times as slow, and any melee or archery blows have a chance to knockback. Maximum encumbrance is greatly increased.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { spacetime=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	on_merge = function(self, old_eff, new_eff)
		return old_eff
	end,
	activate = function(self, eff)
		eff.encumb = self:addTemporaryValue("max_encumber", self:getMaxEncumbrance() * 20),
		self:checkEncumbrance()
		game.logPlayer(self, "#LIGHT_BLUE#You enter a zero gravity zone, beware!")
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("max_encumber", eff.encumb)
		self:checkEncumbrance()
	end,
}

newEffect{
	name = "CURSE_OF_CORPSES",
	desc = _t"Curse of Corpses",
	short_desc = _t"Corpses",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	parameters = {Penalty = 1},
	getResistsUndead = function(eff, level) return -2 * level * (eff.Penalty or 1) end,
	getIncDamageUndead = function(level) return 2 + level * 2 end,
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getStrChange = function(level) return level end,
	getMagChange = function(level) return level end,
	getCorpselightRadius = function(level) return math.floor(level + 1) end,
	getLivingDeathFactor = function(level) return Combat:combatLimit(level-2, 0.6, 0.4, 1, 0.5, 5) end,
	getRetchLevel = function(level) return math.max(1, level - 2) end,
	getRetchCD = function(level) return math.max(16, math.floor(30 - level * 2)) end,
	getReprieveChance = function(level) return Combat:combatLimit(level-4, 100, 35, 0, 50, 5)  end, -- Limit < 100%
	display_desc = function(self, eff) return ([[Curse of Corpses (power %0.1f)]]):tformat(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[An aura of death surrounds you.
#CRIMSON#Penalty : #WHITE#Fear of Death: %+d%% resistance against damage from the undead.
#CRIMSON#Power 1+: %sPower over Death: %+d%% damage against the undead.
#CRIMSON#Power 2+: %s%+d Luck, %+d Strength, %+d Magic
#CRIMSON#Power 3+: %sLiving Death: Ghoulish retch heals you. Once every %d turns, retch (level %d) when you fall below %d%% health
#CRIMSON#Power 4+: %sReprieve from Death: Humanoids you slay have a %d%% chance to rise to fight beside you as ghouls for 6 turns.]]):tformat(
		def.getResistsUndead(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getIncDamageUndead(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getStrChange(math.max(level, 2)), def.getMagChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getRetchCD(math.max(level, 3)), def.getRetchLevel(math.max(level, 3)), def.getLivingDeathFactor(math.max(level, 3)) * 100,
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getReprieveChance(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Fear of Death
		eff.resistsUndeadId = self:addTemporaryValue("resists_actor_type", { ["undead"] = def.getResistsUndead(eff,level) })

		-- level 1: Power over Death
		if bonusLevel < 1 then return end
		eff.incDamageUndeadId = self:addTemporaryValue("inc_damage_actor_type", { ["undead"] = def.getIncDamageUndead(level) })

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_STR] = def.getStrChange(level),
			[Stats.STAT_MAG] = def.getMagChange(level),
		})

		-- level 3: Corpselight
		if bonusLevel < 3 then return end
		eff.retchHealId = self:addTemporaryValue("retch_heal", 1)
		eff.retchCooldown = eff.retchCooldown or 0

		-- level 4: Reprieve from Death
	end,
	deactivate = function(self, eff)
		if eff.resistsUndeadId then self:removeTemporaryValue("resists_actor_type", eff.resistsUndeadId) eff.resistsUndeadId = nil end
		if eff.incDamageUndeadId then self:removeTemporaryValue("inc_damage_actor_type", eff.incDamageUndeadId) eff.incDamageUndeadId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
		if eff.retchHealId then self:removeTemporaryValue("retch_heal", eff.retchHealId) eff.retchHealId = nil end
	end,

	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES], eff.level, math.min(eff.unlockLevel, eff.level)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			local retchThreshold = def.getLivingDeathFactor(level)
			eff.retchCooldown = eff.retchCooldown or 0
			if eff.retchCooldown == 0 and self.life > self.max_life * retchThreshold and self.life - dam <= self.max_life * retchThreshold then
				local retchLevel = def.getRetchLevel(level)
				self:forceUseTalent(self.T_RETCH, {ignore_cd=true, ignore_energy=true, force_target=self, force_level=retchLevel})
				eff.retchCooldown = math.max(16, math.floor(30 - level * 2))
			end
		end
	end,
	--hack a cooldown for retch
	on_timeout = function(self, eff)
		if eff.retchCooldown and eff.retchCooldown > 0 then eff.retchCooldown = math.max(0, eff.retchCooldown - 1) end
	end,

	on_merge = function(self, old_eff, new_eff) return old_eff end,
	--[[
	doCorpselight = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES]
			local tg = {type="ball", 10, radius=def.getCorpselightRadius(eff.level), talent=t}
			self:project(tg, target.x, target.y, DamageType.LITE, 1)
			game.logSeen(target, "#F53CBE#%s's remains glow with a strange light.", target:getName():capitalize())
		end
	end,
	]]
	npcWalkingCorpse = {
		name = _t"walking corpse",
		display = "z", color=colors.GREY, image="npc/undead_ghoul_ghoul.png",
		type = "undead", subtype = "ghoul",
		desc=_t[[This corpse was recently alive but moves as though it is just learning to use its body.]],
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		no_drops = true,
		autolevel = "ghoul",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=14, dex=12, mag=10, con=12 },
		rank = 2,
		size_category = 3,
		infravision = 10,
		resolvers.racial(),
		resolvers.tmasteries{ ["technique/other"]=1, },
		open_door = true,
		blind_immune = 1,
		see_invisible = 2,
		undead = 1,
		max_life = resolvers.rngavg(90,100),
		combat_armor = 2, combat_def = 7,
		resolvers.talents{
			T_STUN={base=1, every=10, max=5},
			T_BITE_POISON={base=1, every=10, max=5},
			T_ROTTING_DISEASE={base=1, every=10, max=5},
			T_RETCH={base=1, every=10, max=5},
		},
		combat = { dam=resolvers.levelup(10, 1, 1), atk=resolvers.levelup(5, 1, 1), apr=3, dammod={str=0.6} },
	},
	doReprieveFromDeath = function(self, eff, target)
		local def = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES]
		if math.min(eff.unlockLevel, eff.level) >= 4 and target.type == "humanoid" and rng.percent(def.getReprieveChance(eff.level)) then
			if not self:canBe("summon") then return end

			game:onTickEnd(function()
				local x, y = util.findFreeGrid(target.x, target.y,1)
				if not x then return end
				local m = require("mod.class.NPC").new(def.npcWalkingCorpse)
				m.faction = self.faction
				m.summoner = self
				m.summoner_gain_exp = true
				m.summon_time = 6
				m:resolve() m:resolve(nil, true)
				m:forceLevelup(math.max(1, self.level - 2))
				game.zone:addEntity(game.level, m, "actor", x, y)
				-- Add to the party
				if self.player then
					m.remove_from_party_on_death = true
					game.party:addMember(m, {control="no", type="summon", title=_t"Summon"})
				end

				game.level.map:particleEmitter(x, y, 1, "slime")

				game.logSeen(m, "#F53CBE#The corpse of the %s pulls itself up to fight for you.", target:getName())
				game:playSoundNear(who, "talents/slime")
			end)
			return true
		else
			return false
		end
	end,
}

newEffect{
	name = "CURSE_OF_MADNESS",
	desc = _t"Curse of Madness",
	short_desc = _t"Madness",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	parameters = {Penalty = 1},
	getMindResistChange = function(eff, level) return -level * 3 * (eff.Penalty or 1) end,
	getConfusionImmuneChange = function(eff, level) return -level * 0.04 * (eff.Penalty or 1) end,
	getCombatCriticalPowerChange = function(level) return level * 3 end,
	-- called by _M:getOffHandMult in mod.class.interface.Combat.lua
	getOffHandMultChange = function(level) return Combat:combatTalentLimit(level, 50, 4, 20) end, -- Limit < 50%
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getDexChange = function(level) return -1 + level * 2 end,
	getConspiratorChance = function(level) return 20 + (level * 10) end,
	getManiaDamagePercent = function(level)
		return Combat:combatLimit(level - 4, 5, 15, 0, 8, 4) -- Limit > 5%
	end,
	display_desc = function(self, eff) return ([[Curse of Madness (power %0.1f)]]):tformat(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[You feel your grip on reality slipping.
#CRIMSON#Penalty : #WHITE#Fractured Sanity: %+d%% Mind Resistance, %+d%% Confusion Immunity
#CRIMSON#Power 1+: %sUnleashed: %+d%% critical damage, %+d%% off-hand weapon damage
#CRIMSON#Power 2+: %s%+d Luck, %+d Dexterity
#CRIMSON#Power 3+: %sConspirator: Your madness is contagious. Every time you critically damage a foe there is a %d%% chance to spread one of your current detrimental mental effect to them.
#CRIMSON#Power 4+: %sMania: Once per turn, when an attack does more than %0.1f%% of your life, the remaining cooldown of all your talents is reduced by 1.]]):tformat(
		def.getMindResistChange(eff, level), def.getConfusionImmuneChange(eff, level) * 100,
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getCombatCriticalPowerChange(math.max(level, 1)), def.getOffHandMultChange(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getDexChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getConspiratorChance(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getManiaDamagePercent(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)

		-- reset stored values
		eff.last_life = self.life

		-- penalty: Fractured Sanity
		eff.mindResistId = self:addTemporaryValue("resists", { [DamageType.MIND] = def.getMindResistChange(eff, level) })
		eff.confusionImmuneId = self:addTemporaryValue("confusion_immune", def.getConfusionImmuneChange(eff, level) )

		-- level 1: Twisted Mind
		if bonusLevel < 1 then return end
		eff.getCombatCriticalPowerChangeId = self:addTemporaryValue("combat_critical_power", def.getCombatCriticalPowerChange(level) )

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_DEX] = def.getDexChange(level),
		})

		-- level 3: Conspirator
		-- level 4: Mania
	end,
	deactivate = function(self, eff)
		if eff.mindResistId then self:removeTemporaryValue("resists", eff.mindResistId) eff.mindResistId = nil end
		if eff.confusionImmuneId then self:removeTemporaryValue("confusion_immune", eff.confusionImmuneId) eff.confusionImmuneId = nil end
		if eff.getCombatCriticalPowerChangeId then self:removeTemporaryValue("combat_critical_power", eff.getCombatCriticalPowerChangeId) eff.getCombatCriticalPowerChangeId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
	end,

	--cooldown talents on taking damage
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if math.min(eff.unlockLevel, eff.level) >= 4 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS]
			if dam > 0 and dam >= self.max_life * (def.getManiaDamagePercent(eff.level) / 100) and not self.turn_procs.CoMania then

				local list = {}
				for tid, cd in pairs(self.talents_cd) do
					if cd and cd > 0 then
						list[#list + 1] = tid
					end
				end
				while #list > 0 do
					local tid = rng.tableRemove(list)
					local t = self:getTalentFromId(tid)
					self.talents_cd[tid] = self.talents_cd[tid] - 1
					if self.talents_cd[tid] <= 0 then
						self.talents_cd[tid] = nil
						if self.onTalentCooledDown then self:onTalentCooledDown(tid) end
					end
				end

				game.logSeen(self, "#F53CBE#%s's mania hastens cooldowns.", self:getName():capitalize())
				self.turn_procs.CoMania = true
				return {dam = dam}
			end
		end
	end,

	on_merge = function(self, old_eff, new_eff) return old_eff end,
	--[[
	--spread a random det mental effect on crit
	callbackOnCrit = function(self, eff, target)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			if rng.percent(def.getConspiratorChance(level)) then
				if not target then
					local tgts = {}
					self:project({type="ball", radius=10}, self.x, self.y, function(px, py)
						local act = game.level.map(px, py, Map.ACTOR)
						if not act or self:reactionToward(act) >= 0 then return end
						tgts[#tgts+1] = act
					end)
					if #tgts > 0 then
						target = rng.table(tgts)
					end
				end
				if target then
					local list = {}
					for eff_id, p in pairs(self.tmp) do
						local e = self.tempeffect_def[eff_id]
						if e.type == "mental" and e.status == "detrimental" and not target:hasEffect(target.eff_id) then
							list[#list+1] = eff_id
						end
					end
					if #list > 0 then
						local eff_id = rng.tableRemove(list)
						local p = self.tmp[eff_id]
						local e = self.tempeffect_def[eff_id]
						local effectParam = self:copyEffect(eff_id)
						effectParam.__tmpparticles = nil
						if effectParam then
							effectParam.src = self
							--spread effect
							target:setEffect(eff_id, p.dur, effectParam)
							self:logCombat(target, "#F53CBE##Source# spreads the madness to #Target#.")
						end
					end
				end
			end
		end
	end,
	]]
	--spread a random det mental effect damaging crit
	--called by damage_types.lua - n.b: src instead of self.
	doConspirator = function(src, eff, target)
		local def, level, bonusLevel = src.tempeffect_def[src.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			if not src.turn_procs.CoConspirator and rng.percent(def.getConspiratorChance(level)) then
				local list = {}
				for eff_id, p in pairs(src.tmp) do
					local e = src.tempeffect_def[eff_id]
					if e.type == "mental" and e.status == "detrimental" and not target:hasEffect(target.eff_id) then
						list[#list+1] = eff_id
					end
				end
				if #list > 0 then
					local eff_id = rng.tableRemove(list)
					local p = src.tmp[eff_id]
					local e = src.tempeffect_def[eff_id]
					local effectParam = src:copyEffect(eff_id)
					effectParam.__tmpparticles = nil
					if effectParam then
						effectParam.src = src
						--spread effect
						target:setEffect(eff_id, p.dur, effectParam)
						src:logCombat(target, "#F53CBE##Source# spreads the madness to #Target#.")
						src.turn_procs.CoConspirator = true
					end
				end
			end
		end
	end,

	--just confusions
	--[[
	doConspirator = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			--make list of confusion effects
			local madlist = {}
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.subtype.confusion and e.status == "detrimental" then
					madlist[#madlist+1] = eff_id
				end
			end
			--copy effects
			while #madlist > 0 do
				if target:canBe("confusion") then
					local eff_id = rng.tableRemove(madlist)
					local p = self.tmp[eff_id]
					local e = self.tempeffect_def[eff_id]
					local effectParam = self:copyEffect(eff_id)
					effectParam.__tmpparticles = nil
					if effectParam then
						effectParam.src = self
						--spread effect
						target:setEffect(eff_id, p.dur, effectParam)
					end
					self:logCombat(target, "#F53CBE##Source# spreads confusion to #Target#.")
				end
			end
		end
	end,
	]]
}


newEffect{
	name = "CURSE_OF_SHROUDS",
	desc = _t"Curse of Shrouds",
	short_desc = _t"Shrouds",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	parameters = {Penalty = 1},
	getShroudIncDamageChange = function(eff, level) return -(4 + level * 2) * (eff.Penalty or 1) end,
	getResistsDarknessChange = function(level) return level * 4 end,
	getResistsCapDarknessChange = function(level) return Combat:combatTalentLimit(level, 30, 4, 12) end, -- Limit < 30%
	getSeeInvisible = function(level) return 2 + level * 2 end,
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getConChange = function(level) return -1 + level * 2 end,
	getShroudResistsAllChange = function(level) return (level - 1) * 5 end,
	display_desc = function(self, eff) return ([[Curse of Shrouds (power %0.1f)]]):tformat(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[A shroud of darkness seems to fall across your path.
#CRIMSON#Penalty : #WHITE#Shroud of Weakness: Small chance of becoming enveloped in a Shroud of Weakness (reduces damage dealt by %d%%) for 4 turns.
#CRIMSON#Power 1+: %sNightwalker: %+d Darkness Resistance, %+d%% Max Darkness Resistance, %+d See Invisible
#CRIMSON#Power 2+: %s%+d Luck, %+d Constitution
#CRIMSON#Power 3+: %sShroud of Passing: Your form seems to fade as you move, reducing all damage taken by %d%% for 1 turn after movement.
#CRIMSON#Power 4+: %sShroud of Death: The power of every kill seems to envelop you like a shroud, reducing all damage taken by %d%% for 3 turns.]]):tformat(
		-def.getShroudIncDamageChange(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getResistsDarknessChange(math.max(level, 1)), def.getResistsCapDarknessChange(math.max(level, 1)), def.getSeeInvisible(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getConChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getShroudResistsAllChange(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getShroudResistsAllChange(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Shroud of Weakness

		-- level 1: Nightwalker
		if bonusLevel < 1 then return end
		eff.resistsDarknessId = self:addTemporaryValue("resists", { [DamageType.DARKNESS] = def.getResistsDarknessChange(level) })
		eff.resistsCapDarknessId = self:addTemporaryValue("resists_cap", { [DamageType.DARKNESS]= def.getResistsCapDarknessChange(level) })
		eff.seeInvisibleId = self:addTemporaryValue("see_invisible", def.getSeeInvisible(level))

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_CON] = def.getConChange(level),
		})

		-- level 3: Shroud of Passing
		-- level 4: Shroud of Death
	end,
	deactivate = function(self, eff)
		if eff.resistsDarknessId then self:removeTemporaryValue("resists", eff.resistsDarknessId) eff.resistsDarknessId = nil end
		if eff.resistsCapDarknessId then self:removeTemporaryValue("resists_cap", eff.resistsCapDarknessId) eff.resistsCapDarknessId = nil end
		if eff.seeInvisibleId then self:removeTemporaryValue("see_invisible", eff.seeInvisibleId) eff.seeInvisibleId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end

		if self:hasEffect(self.EFF_SHROUD_OF_WEAKNESS) then self:removeEffect(self.EFF_SHROUD_OF_WEAKNESS) end
		if self:hasEffect(self.EFF_SHROUD_OF_PASSING) then self:removeEffect(self.EFF_SHROUD_OF_PASSING) end
		if self:hasEffect(self.EFF_SHROUD_OF_DEATH) then self:removeEffect(self.EFF_SHROUD_OF_DEATH) end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	on_timeout = function(self, eff)
		-- Shroud of Weakness
		if rng.chance(100) then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			self:setEffect(self.EFF_SHROUD_OF_WEAKNESS, 4, { power=def.getShroudIncDamageChange(eff, eff.level) })
		end
	end,
	doShroudOfPassing = function(self, eff)
		-- called after energy is used; eff.moved may be set from movement
		local effShroud = self:hasEffect(self.EFF_SHROUD_OF_PASSING)
		if math.min(eff.unlockLevel, eff.level) >= 3 and eff.moved then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			if not effShroud then self:setEffect(self.EFF_SHROUD_OF_PASSING, 1, { power=def.getShroudResistsAllChange(eff.level) }) end
		else
			if effShroud then self:removeEffect(self.EFF_SHROUD_OF_PASSING) end
		end
		eff.moved = false
	end,
	doShroudOfDeath = function(self, eff)
		if math.min(eff.unlockLevel, eff.level) >= 4 and not self:hasEffect(self.EFF_SHROUD_OF_DEATH) then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			self:setEffect(self.EFF_SHROUD_OF_DEATH, 3, { power=def.getShroudResistsAllChange(eff.level) })
		end
	end,
}

newEffect{
	name = "SHROUD_OF_WEAKNESS",
	desc = _t"Shroud of Weakness",
	long_desc = function(self, eff) return ("The target is enveloped in a shroud that seems to hang upon it like a heavy burden. (Reduces damage dealt by %d%%)."):tformat(-eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	no_stop_enter_worlmap = true,
	no_stop_resting = true,
	parameters = { power=10 },
	activate = function(self, eff)
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all = eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "SHROUD_OF_PASSING",
	desc = _t"Shroud of Passing",
	long_desc = function(self, eff) return ("The target is enveloped in a shroud that seems to not only obscure it but also to fade its form (+%d%% resist all)."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	decrease = 0,
	parameters = { power=10 },
	activate = function(self, eff)
		eff.resistsId = self:addTemporaryValue("resists", { all = eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistsId)
	end,
}

newEffect{
	name = "SHROUD_OF_DEATH",
	desc = _t"Shroud of Death",
	long_desc = function(self, eff) return ("The target is enveloped in a shroud that seems to not only obscure it but also to fade its form (+%d%% resist all)."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.resistsId = self:addTemporaryValue("resists", { all = eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistsId)
	end,
}

newEffect{
	name = "CURSE_OF_NIGHTMARES",
	desc = _t"Curse of Nightmares",
	short_desc = _t"Nightmares",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	parameters = {Penalty = 1},
	-- called by _M:combatMentalResist in mod.class.interface.Combat.lua
	getVisionsReduction = function(eff, level)
		return Combat:combatTalentLimit(level, 100, 9, 25) * (eff.Penalty or 1) -- Limit < 100%
	end,
	getResistsPhysicalChange = function(level) return 1 + level end,
	getResistsCapPhysicalChange = function(level) return Combat:combatTalentLimit(level, 30, 1, 5) end, -- Limit < 30%
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getWilChange = function(level) return -1 + level * 2 end,
	--getBaseSuffocateAirChange = function(level) return Combat:combatTalentLimit(level, 50, 4, 16) end, -- Limit < 50 to take >2 hits to kill most monsters
	--getSuffocateAirChange = function(level) return Combat:combatTalentLimit(level, 10, 0, 7) end, -- Limit < 10
	getHarrowDam = function(self, level) return (Combat:combatTalentLimit(level, 100, 10, 40) + self:combatMindpower()) / 2 end,
	getNightmareChance = function(level) return Combat:combatTalentLimit(math.max(0, level-3), 25, 4, 10) end, -- Limit < 25%
	getNightmareRadius = function(level) return 5 + (level - 4) * 2 end,
	display_desc = function(self, eff)
		if math.min(eff.unlockLevel, eff.level) >= 4 then
			return ([[Curse of Nightmares (power %0.1f): %d%%]]):tformat(eff.level, eff.nightmareChance or 0)
		else
			return ([[Curse of Nightmares (power %0.1f)]]):tformat(eff.level)
		end
	end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES], eff.level, math.min(eff.unlockLevel, eff.level)

		return ([[Horrible visions fill your mind.
#CRIMSON#Penalty : #WHITE#Plagued by Visions: Your mental save has a 20%% chance to be reduced by %d%% when tested.
#CRIMSON#Power 1+: %sRemoved from Reality: %+d Physical Resistance, %+d Maximum Physical Resistance
#CRIMSON#Power 2+: %s%+d Luck, %+d Willpower
#CRIMSON#Power 3+: %sHarrow: When a foe attempts to inflict a detrimental effect upon you, your harrowing aura retaliates against a random foe in range 10, dealing %d mind and %d darkness damage.
#CRIMSON#Power 4+: %sNightmare: Each time you are damaged by a foe there is a chance (currently %d%%) of triggering a radius %d nightmare (summon Terrors and chances to slow, deal %d Mind damage, and deal %d Darkness damage) for 8 turns. The chance grows each time you are struck but fades over time.]]):tformat(
		def.getVisionsReduction(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getResistsPhysicalChange(math.max(level, 1)), def.getResistsCapPhysicalChange(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getWilChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", self:damDesc(DamageType.MIND, def.getHarrowDam(self, math.max(level, 3))), self:damDesc(DamageType.DARKNESS,  def.getHarrowDam(self, math.max(level, 3))),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", eff.nightmareChance or 0, def.getNightmareRadius(math.max(level, 4)), self:damDesc(DamageType.MIND, 10+self:combatMindpower()), self:damDesc(DamageType.DARKNESS, 10+self:combatMindpower())
	)
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Plagued by Visions

		-- level 1: Removed from Reality
		if bonusLevel < 1 then return end
		eff.resistsPhysicalId = self:addTemporaryValue("resists", { [DamageType.PHYSICAL]= def.getResistsPhysicalChange(level) })
		eff.resistsCapPhysicalId = self:addTemporaryValue("resists_cap", { [DamageType.PHYSICAL]= def.getResistsCapPhysicalChange(level) })

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_WIL] = def.getWilChange(level),
		})

		-- level 3: Suffocate
		-- level 4: Nightmare
	end,
	deactivate = function(self, eff)
		if eff.resistsPhysicalId then self:removeTemporaryValue("resists", eff.resistsPhysicalId); eff.resistsPhysicalId =  nil end
		if eff.resistsCapPhysicalId then self:removeTemporaryValue("resists_cap", eff.resistsCapPhysicalId) eff.resistsCapPhysicalId =  nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId =  nil end
	end,

	--Harrow
	callbackOnTemporaryEffect = function(self, eff, eff_id, e, p)
		if self.turn_procs.curse_of_nightmare_3 then return end
		if self.__curse_nightmare_recurse then return end
		self.__curse_nightmare_recurse = true
		(function()
			local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES], eff.level, math.min(eff.unlockLevel, eff.level)
			if math.min(eff.unlockLevel, eff.level) >= 3 then
				--if e.status == "detrimental" and not e.subtype["cross tier"] and p.src and p.src.__is_actor and not p.src.dead then
					--local e = self.tempeffect_def[eff_id]
				if e.status ~= "detrimental" or e.type == "other" or e.subtype["cross tier"] then return end
				local harrowDam = def.getHarrowDam(self, level)
				if p.src and p.src.__is_actor then
					DamageType:get(DamageType.MIND).projector(self, p.src.x, p.src.y, DamageType.MIND, harrowDam)
					DamageType:get(DamageType.MIND).projector(self, p.src.x, p.src.y, DamageType.DARKNESS, harrowDam)
					--game.logSeen(self, "#F53CBE#%s harrows '%s'!", self:getName():capitalize(), p.src.name)
					game.logSeen(self, "#F53CBE#%s harrows %s!", self:getName():capitalize(), p.src:getName())
					self.turn_procs.curse_of_nightmare_3 = true
				else
					local tgts = {}
					self:project({type="ball", radius=10}, self.x, self.y, function(px, py)
						local act = game.level.map(px, py, Map.ACTOR)
						if not act or self:reactionToward(act) >= 0 then return end
						tgts[#tgts+1] = act
					end)
					if #tgts > 0 then
						local target = rng.table(tgts)
						DamageType:get(DamageType.MIND).projector(self, target.x, target.y, DamageType.MIND, harrowDam)
						DamageType:get(DamageType.MIND).projector(self, target.x, target.y, DamageType.DARKNESS, harrowDam)
						--self:logCombat(target, "#F53CBE##Source# harrows #Target#!", self:getName():capitalize(), target:getName())
						game.logSeen(self, "#F53CBE#%s harrows %s!", self:getName():capitalize(), target:getName())
						self.turn_procs.curse_of_nightmare_3 = true
					end
				end
			end
		end)()
		self.__curse_nightmare_recurse = nil
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	--[[doSuffocate = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			if target and target.rank <= 2 and target.level <= self.level - 3 and not target:attr("no_breath") and not target:attr("invulnerable") then
				local def = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES]
				local airLoss = def.getBaseSuffocateAirChange(eff.level) + Combat:combatTalentScale(self.level - target.level - 3, 1, 5) * def.getSuffocateAirChange(eff.level)
				game.logSeen(self, "#F53CBE#%s begins to choke from a suffocating curse. (-%d air)", target:getName(), airLoss)
				target:suffocate(airLoss, self, "suffocated from a curse")
			end
		end
	end,]]
	npcTerror = {
		name = "terror",
		display = "h", color=colors.DARK_GREY, image="npc/horror_eldritch_nightmare_horror.png",
		blood_color = colors.BLUE,
		desc = _t"A formless terror that seems to cut through the air, and its victims, like a knife.",
		type = "horror", subtype = "eldritch",
		rank = 2,
		size_category = 2,
		body = { INVEN = 10 },
		no_drops = true,
		autolevel = "warrior",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=16, dex=20, wil=15, con=15 },
		infravision = 10,
		can_pass = {pass_wall=20},
		resists = {[DamageType.LIGHT] = -50, [DamageType.DARKNESS] = 100},
		silent_levelup = true,
		no_breath = 1,
		fear_immune = 1,
		blind_immune = 1,
		infravision = 10,
		see_invisible = 80,
		max_life = resolvers.rngavg(50, 80),
		combat_armor = 1, combat_def = 10,
		combat = { dam=resolvers.levelup(resolvers.rngavg(15,20), 1, 1.1), atk=resolvers.rngavg(5,15), apr=5, dammod={str=1} },
		resolvers.talents{
		},
	},
	on_timeout = function(self, eff) -- Chance for nightmare fades over time
		if eff.nightmareChance then eff.nightmareChance = math.max(0, eff.nightmareChance-1) end
	end,
	callbackOnHit = function(self, eff, cb)	game:onTickEnd(function()
		if math.min(eff.unlockLevel, eff.level) >= 4 then
			-- build chance for a nightmare
			local def = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES]
			if not self.turn_procs.curse_of_nightmare_4 then --don't build chance on turn nightmare triggered
				eff.nightmareChance = (eff.nightmareChance or 0) + def.getNightmareChance(eff.level)
			end

			-- invoke the nightmare, one per turn
			if not self.turn_procs.curse_of_nightmare_4 and rng.percent(eff.nightmareChance) then
				local radius = def.getNightmareRadius(eff.level)

				-- make sure there is at least one creature to torment
				local seen = false
				core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, radius,
					function(_, x, y) return game.level.map:opaque(x, y) end,
					function(_, x, y)
						local actor = game.level.map(x, y, game.level.map.ACTOR)
						if actor and actor ~= self and self:reactionToward(actor) < 0 then seen = true end
					end, nil)
				if not seen then return false end

				-- start the nightmare: slow, hateful whisper, random Terrors (minor horrors)
				local dam = (10+self:combatMindpower())
				eff.nightmareChance = 0
				game.level.map:addEffect(self,
					self.x, self.y, 8,
					DamageType.NIGHTMARE, dam,
					radius,
					5, nil,
					engine.MapEffect.new{alpha=93, color_br=134, color_bg=60, color_bb=134, effect_shader="shader_images/darkness_effect.png"},
					function(e, update_shape_only) if not update_shape_only then
						-- attempt one summon per turn
						if not e.src:canBe("summon") then return end

						local def = e.src.tempeffect_def[e.src.EFF_CURSE_OF_NIGHTMARES]

						-- random location nearby..not too picky and these things can move through walls but won't start there
						local locations = {}
						local grids = core.fov.circle_grids(e.x, e.y, e.radius, true)
						for lx, yy in pairs(grids) do for ly, _ in pairs(grids[lx]) do
							if not game.level.map:checkAllEntities(lx, ly, "block_move") then
								locations[#locations+1] = {lx, ly}
							end
						end end
						if #locations == 0 then return true end
						local location = rng.table(locations)

						local m = require("mod.class.NPC").new(def.npcTerror)
						m.faction = e.src.faction
						m.summoner = e.src
						m.summoner_gain_exp = true
						m.summon_time = 3
						m:resolve() m:resolve(nil, true)
						m:forceLevelup(e.src.level)

						-- Add to the party
						if e.src.player then
							m.remove_from_party_on_death = true
							game.party:addMember(m, {control="no", type="nightmare", title=_t"Nightmare"})
						end

						game.zone:addEntity(game.level, m, "actor", location[1], location[2])

						return true
					end end,
					false, false)

				self.turn_procs.curse_of_nightmare_4 = true

				game.logSeen(self, "#F53CBE#The air around %s grows cold and terrifying shapes begin to coalesce. A nightmare has begun.", self:getName():capitalize())
				game:playSoundNear(self, "talents/cloud")
			end
		end
	end) end,
}


newEffect{
	name = "CURSE_OF_MISFORTUNE",
	desc = _t"Curse of Misfortune",
	short_desc = _t"Misfortune",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	parameters = {Penalty = 1},
	getMoneyMult = function(eff, level) return Combat:combatTalentLimit(level, 1, 0.15, 0.35) * (eff.Penalty or 1)end, -- Limit < 1 bug fix
	getMissplacedEndeavours = function(level) return Combat:combatTalentLimit(level, 100, 25, 45) end, -- Limit < 100%
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getCunChange = function(level) return -1 + level * 2 end,
	getMissedOpportunities = function(level) return Combat:combatTalentLimit(math.max(1, level-2), 25, 10, 20) end,
	getUnfortunateEndIncrease = function(level) return Combat:combatTalentLimit(math.max(1, level-3), 100, 40, 60) end, -- Limit < 100%
	display_desc = function(self, eff) return ([[Curse of Misfortune (power %0.1f)]]):tformat(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE], eff.level, math.min(eff.unlockLevel, eff.level)

		return ([[Mayhem and destruction seem to follow you.
#CRIMSON#Penalty : #WHITE#Lost Fortune: You seem to find less gold in your journeys.
#CRIMSON#Power 1+: %sMissplaced Endeavours: The endeavours of those around you begin to fail (+%d%% chance to avoid traps).
#CRIMSON#Power 2+: %s%+d Luck, %+d Cunning
#CRIMSON#Power 3+: %sMissed Opportunities: Opportunities are fleeting, and those close to you begin to miss them (+%d%% evasion).
#CRIMSON#Power 4+: %sUnfortunate End: The damage you deal will increase by %d%% if the increase would be enough to kill your opponent.]]):tformat(
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getMissplacedEndeavours(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getCunChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getMissedOpportunities(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getUnfortunateEndIncrease(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Lost Fortune
		eff.moneyValueMultiplierId = self:addTemporaryValue("money_value_multiplier", -def.getMoneyMult(eff, level))

		-- level 1: Missplaced Endeavours
		if bonusLevel < 1 then return end
		eff.trapAvoidanceId = self:addTemporaryValue("trap_avoidance", def.getMissplacedEndeavours(level))

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_CUN] = def.getCunChange(level),
		})

		-- level 3: Missed Opportunities
		if bonusLevel < 3 then return end
		eff.missedEvasionId = self:addTemporaryValue("evasion", def.getMissedOpportunities(level))

		-- level 4: Unfortunate End - handled in doUnfortunateEnd

	end,
	deactivate = function(self, eff)
		if eff.moneyValueMultiplierId then self:removeTemporaryValue("money_value_multiplier", eff.moneyValueMultiplierId) eff.moneyValueMultiplierId = nil end
		if eff.trapAvoidanceId then self:removeTemporaryValue("trap_avoidance", eff.trapAvoidanceId) eff.trapAvoidanceId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
		if eff.missedEvasionId then self:removeTemporaryValue("evasion", eff.missedEvasionId) eff.missedEvasionId = nil end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,

	-- called by default projector in mod.data.damage_types.lua
	doUnfortunateEnd = function(self, eff, target, dam)
		if math.min(eff.unlockLevel, eff.level) >=4 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE]
			if target.life - dam > 0 then
				local multiplier = 1 + def.getUnfortunateEndIncrease(eff.level) / 100
				if target.life - dam * multiplier <= 0 then
					-- unfortunate end! note that this does not kill if target.die_at < 0
					dam = dam * multiplier
					if target.life - dam <= target.die_at then
						game.logSeen(target, "#F53CBE#%s suffers an unfortunate end.", target:getName():capitalize())
					else
						game.logSeen(target, "#F53CBE#%s suffers an unfortunate blow.", target:getName():capitalize())
					end
				end
			end
		end

		return dam
	end,
}

newEffect{
	name = "PROB_TRAVEL_UNSTABLE", image = "talents/probability_travel.png",
	desc = _t"Unstable Probabilites",
	long_desc = function(self, eff) return _t"The target has recently blinked through a wall using probability travel." end,
	type = "other",
	subtype = { time=true, space=true },
	status = "detrimental",
	parameters = {},
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("prob_travel_deny", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("prob_travel_deny", eff.iid)
	end,
}

newEffect{
	name = "CURSED_FORM", image = "talents/seethe.png",
	desc = _t"Cursed Form",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {},
	long_desc = function(self, eff)
		local desc = _t"The target's unnatural body has responded to damage taken."
		if (eff.incDamageChange or 0) > 0 then
			desc = desc..(" All damage that the target inflicts is increased by %d%%."):tformat(eff.incDamageChange)
		end
		if (eff.statChange or 0) > 0 then
			desc = desc..(" Strength and Willpower are increased by %d. Poisons and diseases have a %d%% chance of being neutralized each turn."):tformat(eff.statChange, eff.neutralizeChance)
		end
		return desc
	end,
	activate = function(self, eff)
		-- first on_timeout is ignored because it is applied immediately
		eff.firstHit = true
		eff.increase = 1
		self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)

		game.level.map:particleEmitter(self.x, self.y, 1, "cursed_form", {power=eff.increase})
	end,
	deactivate = function(self, eff)
		if eff.incDamageId then
			self:removeTemporaryValue("inc_damage", eff.incDamageId)
			eff.incDamageId = nil
		end
		if eff.incStatsId then
			self:removeTemporaryValue("inc_stats", eff.incStatsId)
			eff.incStatsId = nil
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		eff.hit = true
	end,
	updateEffect = function(self, eff)
		local tSeethe = self:getTalentFromId(self.T_SEETHE)
		local tGrimResolve = self:getTalentFromId(self.T_GRIM_RESOLVE)
		if tSeethe then
			eff.incDamageChange = tSeethe.getIncDamageChange(self, tSeethe, eff.increase)
		end
		if tGrimResolve then
			eff.statChange = tGrimResolve.getStatChange(self, tGrimResolve, eff.increase)
			eff.neutralizeChance = tGrimResolve.getNeutralizeChance(self, tGrimResolve)
		end

		if eff.incDamageId then
			self:removeTemporaryValue("inc_damage", eff.incDamageId)
			eff.incDamageId = nil
		end
		if eff.incDamageChange > 0 then
			eff.incDamageId = self:addTemporaryValue("inc_damage", {all = eff.incDamageChange})
		end
		if eff.incStatsId then
			self:removeTemporaryValue("inc_stats", eff.incStatsId)
			eff.incStatsId = nil
		end
		if eff.statChange > 0 then
			eff.incStatsId = self:addTemporaryValue("inc_stats", { [Stats.STAT_STR] = eff.statChange, [Stats.STAT_WIL] = eff.statChange })
		end
	end,
	on_timeout = function(self, eff)
		if eff.firstHit then
			eff.firstHit = nil
			eff.hit = false
		elseif eff.hit then
			if eff.increase < 5 then
				eff.increase = eff.increase + 1
				self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)

				game.level.map:particleEmitter(self.x, self.y, 1, "cursed_form", {power=eff.increase})
			end
			eff.hit = false
		else
			eff.increase = eff.increase - 1
			if eff.increase == 0 then
				self:removeEffect(self.EFF_CURSED_FORM, false, true)
			else
				self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)
			end
		end
		if (eff.statChange or 0)>0 and eff.neutralizeChance then -- Remove poisons/disease (w/Grim Resolve)
			local efdef
			for efid, ef in pairs(self.tmp) do
				efdef = self.tempeffect_def[efid]
				if efdef.subtype and (efdef.subtype.poison or efdef.subtype.disease) and rng.percent(eff.neutralizeChance) then
					self:removeEffect(efid)
				end
			end
		end
	end,
}

-- Predator is purely for the player's information
newEffect{
	name = "PREDATOR", image = "talents/mark_prey.png",
	desc = _t"Marked Prey",
	no_stop_enter_worlmap = true,
	decrease = 0,
	cancel_on_level_change = true,
	long_desc = function(self, eff)
		local desc = _t"Hunting:"
		local desc2 = ("\n%d%% Received damage reduction against:"):tformat(eff.power)
		if not game.level then return desc..desc2 end

		local preys = {}
		for uid, e in pairs(game.level.entities) do if e.marked_prey then
			preys[#preys+1] = e
		end end
		table.sort(preys, "rank")
		for _, p in ripairs(preys) do
			local mprank, mpcolour = p:TextRank()
			desc = desc..("\n- %s%s#LAST#"):tformat(mpcolour, p.name:capitalize())
		end

		local subtypes_list = table.get(self, "mark_prey2", game.level.id)
		for st, _ in pairs(subtypes_list or {}) do
			desc2 = desc2..("\n- #ffa0ff#%s#LAST#"):tformat(tostring(st):capitalize())
		end

		return desc..desc2
	end,
	type = "other",
	subtype = { predator=true },
	status = "beneficial",
	activate = function(self, eff) end,
	deactivate = function(self, eff) end,
}

newEffect{
	name = "FADED", image = "talents/shadow_fade.png",
	desc = _t"Faded",
	long_desc = function(self, eff) return _t"The target has faded and is no longer taking damage." end,
	type = "other",
	subtype = { },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target# fades!", _t"+Faded" end,
	parameters = {},
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("invulnerable", 1)
		eff.imid = self:addTemporaryValue("status_effect_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.iid)
		self:removeTemporaryValue("status_effect_immune", eff.imid)
	end,
	on_timeout = function(self, eff)
		-- always remove
		return true
	end,
}

-- Borrowed Time and the Borrowed Time stun effect
newEffect{
	name = "HIGHBORN_S_BLOOM", image = "talents/highborn_s_bloom.png",
	desc = _t"Highborn's Bloom",
	long_desc = function(self, eff) return _t"The target is using talents without consuming resources." end,
	type = "other",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("zero_resource_cost", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("zero_resource_cost", eff.tmpid)
	end,
}

newEffect{
	name = "VICTORY_RUSH_ZIGUR", image = "talents/arcane_destruction.png",
	desc = _t"Victory Rush",
	long_desc = function(self, eff) return _t"The thrill of victory makes this creature invulnerable." end,
	type = "other",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("invulnerable", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.tmpid)
	end,
}

newEffect{
	name = "SOLIPSISM", image = "talents/solipsism.png",
	desc = _t"Solipsism",
	long_desc = function(self, eff) return ("This creature has fallen into a solipsistic state and is caught up in its own egoic thoughts (-%d%% global speed)."):tformat(eff.power * 100) end,
	type = "other",
	subtype = { psionic=true },
	status = "detrimental",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "CLARITY", image = "talents/clarity.png",
	desc = _t"Clarity",
	long_desc = function(self, eff) return ("The creature has found a state of clarity and sees the world for what it is (+%d%% global speed)."):tformat(eff.power * 100) end,
	type = "other",
	subtype = { psionic=true },
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "DREAMSCAPE", image = "talents/dreamscape.png",
	desc = _t"Dreamscape",
	long_desc = function(self, eff) return ("This target has invaded %s's dreams and has gained a %d%% bonus to all damage."):tformat(eff.target:getName(), eff.power) end,
	type = "other",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=1, projections_killed=0 },
	on_timeout = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
		-- Dreamscape doesn't cooldown in the dreamscape
		self.talents_cd[self.T_DREAMSCAPE] = self.talents_cd[self.T_DREAMSCAPE] + 1

		-- Spawn a copy every other turn
		local spawn_time = 2
		if eff.dur%spawn_time == 0 then

			-- Find space
			local x, y = util.findFreeGrid(eff.target.x, eff.target.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "You could not find enough space to form a dream projection...")
				return
			end
			local m = require("mod.class.NPC").new(eff.target:cloneActor{
				shader = "shadow_simulacrum", shader_args = { color = {0.0, 1, 1}, base = 0.6 },
				is_psychic_projection = true,
				summoner = eff.target, summoner_gain_exp=true, exp_worth=0,
				_rst_full=true, can_change_level=table.NIL_MERGE, can_change_zone=table.NIL_MERGE,
				ai_target={actor=table.NIL_MERGE},
				max_level = eff.target.level,
				life = util.bound(eff.target.life, eff.target.die_at, eff.target.max_life),
				ai = "summoned", ai_real = "tactical",
				ai_state={ ai_move="move_complex", talent_in=1, ally_compassion = 10},
				name = ("%s's dream projection"):tformat(eff.target:getName()),
			})

			if not eff.target:attr("lucid_dreamer") then
				m.inc_damage.all = (m.inc_damage.all or 0) - 50
			end
			m.lucid_dreamer = 1

			-- Remove some talents
			local tids = {}
			for tid, _ in pairs(m.talents) do
				local t = m:getTalentFromId(tid)
				if (t.no_npc_use and not t.allow_temporal_clones) or t.remove_on_clone then tids[#tids+1] = t end
			end
			for i, t in ipairs(tids) do
				m:unlearnTalentFull(t.id)
			end

			-- remove imprisonment
			m:attr("invulnerable", -1)
			m:attr("time_prison", -1)
			m:attr("no_timeflow", -1)
			m:attr("status_effect_immune", -1)

			m:removeParticles(eff.particle)
			m:removeTimedEffectsOnClone()

			-- track number killed
			m.on_die = function(self, who)
				local p = (who and who:hasEffect(who.EFF_DREAMSCAPE)) or (who and who.summoner and who.summoner:hasEffect(who.summoner.EFF_DREAMSCAPE))
				if p then -- For the rare instance we die after the effect ends but before the dreamscape instance closes
					p.projections_killed = p.projections_killed + 1
					game.logSeen(p.target, "#LIGHT_RED#%s writhes in agony as a fragment of its mind is destroyed!", p.target:getName():capitalize())
				end
			end

			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
			game.logSeen(eff.target, "#LIGHT_BLUE#%s has spawned a dream projection to protect its mind!", eff.target:getName():capitalize())

			if game.party:hasMember(eff.target) then
				game.party:addMember(m, {
					control="full",
					type="projection",
					title=_t"Dream Self",
					orders = {target=true},
				})
				if eff.target == game.player then
					game.party:setPlayer(m)
					m:resetCanSeeCache()
				end
			end
		end

		-- Try to insure the AI isn't attacking the invulnerable actor
		if self.ai_target and self.ai_target.actor and self.ai_target.actor:attr("invulnerable") then
			self:setTarget(nil)
		end

		-- End the effect early if we've killed enough projections
		if eff.projections_killed/10 >= eff.target.life/eff.target.max_life then
			game:onTickEnd(function()
				eff.target:die(self)
				game.logSeen(eff.target, "#LIGHT_RED#%s's mind shatters into %d tiny fragments!", eff.target:getName():capitalize(), eff.target.max_life)
				eff.projections_killed = 0 -- clear this out to prevent closing messages
			end)
		end
	end,
	activate = function(self, eff)
		-- Make the target invulnerable
		eff.iid = eff.target:addTemporaryValue("invulnerable", 1)
		eff.sid = eff.target:addTemporaryValue("time_prison", 1)
		eff.tid = eff.target:addTemporaryValue("no_timeflow", 1)
		eff.imid = eff.target:addTemporaryValue("status_effect_immune", 1)
		eff.target.energy.value = 0

		-- Make the invader deadly
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.did = self:addTemporaryValue("lucid_dreamer", 1)
	end,
	deactivate = function(self, eff)
		-- Clone protection
		if not self.on_die then return end

		-- Remove the target's invulnerability
		eff.target:removeTemporaryValue("invulnerable", eff.iid)
		eff.target:removeTemporaryValue("time_prison", eff.sid)
		eff.target:removeTemporaryValue("no_timeflow", eff.tid)
		eff.target:removeTemporaryValue("status_effect_immune", eff.imid)

		-- Remove the invaders damage bonus
		self:removeTemporaryValue("inc_damage", eff.pid)
		self:removeTemporaryValue("lucid_dreamer", eff.did)

		-- Return from the dreamscape
		game:onTickEnd(function()
			-- Collect objects
			local objs = {}
			for i = 0, game.level.map.w - 1 do for j = 0, game.level.map.h - 1 do
				for z = game.level.map:getObjectTotal(i, j), 1, -1 do
					objs[#objs+1] = game.level.map:getObject(i, j, z)
					game.level.map:removeObject(i, j, z)
				end
			end end

			local oldzone = game.zone
			local oldlevel = game.level
			local zone = game.level.source_zone
			local level = game.level.source_level

			if not self.dead then
				oldlevel:removeEntity(self)
				level:addEntity(self)
			end

			game.zone = zone
			game.level = level
			game.zone_name_s = nil

			local x1, y1 = util.findFreeGrid(eff.x, eff.y, 20, true, {[Map.ACTOR]=true})
			if x1 then
				if not self.dead then
					self:move(x1, y1, true)
					self.on_die, self.dream_plane_on_die = self.dream_plane_on_die, nil
					game.level.map:particleEmitter(x1, y1, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					self.x, self.y = x1, y1
				end
			end
			local x2, y2 = util.findFreeGrid(eff.tx, eff.ty, 20, true, {[Map.ACTOR]=true})
			if not eff.target.dead then
				if x2 then
					eff.target:move(x2, y2, true)
					eff.target.on_die, eff.target.dream_plane_on_die = eff.target.dream_plane_on_die, nil
				end
				if oldlevel:hasEntity(eff.target) then oldlevel:removeEntity(eff.target) end
				level:addEntity(eff.target)
			else
				eff.target.x, eff.target.y = x2, y2
			end

			-- Add objects back
			for i, o in ipairs(objs) do
				if self.dead then
					game.level.map:addObject(eff.target.x, eff.target.y, o)
				else
					game.level.map:addObject(self.x, self.y, o)
				end
			end

			-- Remove all npcs in the dreamscape
			for uid, e in pairs(oldlevel.entities) do
				if e ~= self and e ~= eff.target and e.die then e:die() end
			end

			-- Reload MOs
			game.level.map:redisplay()
			game.level.map:recreate()
			game.uiset:setupMinimap(game.level)
			game.nicer_tiles:postProcessLevelTilesOnLoad(game.level)

			game.logPlayer(game.player, "#LIGHT_BLUE#You are brought back from the Dreamscape!")

			-- Apply Dreamscape hit
			if eff.projections_killed > 0 then
				local kills = eff.projections_killed
				eff.target:takeHit(eff.target.max_life/10 * kills, self)
				eff.target:setEffect(eff.target.EFF_BRAINLOCKED, kills, {})

				local loss = _t"loss"
				if kills >= 10 then loss = _t"potentially fatal loss" elseif kills >=8 then loss = _t"devastating loss" elseif kills >=6 then loss = _t"tremendous loss" elseif kills >=4 then loss = _t"terrible loss" end
				game.logSeen(eff.target, "#LIGHT_RED#%s suffered a %s of self in the Dreamscape!", eff.target:getName():capitalize(), loss)
			end
		end)
	end,
}

newEffect{
	name = "REVISIONIST_HISTORY", image = "talents/revisionist_history.png",
	desc = _t"Revisionist History",
	long_desc = function(self, eff) return _t"While this effect holds you can decide recent history did not happen the way it did." end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_REVISIONIST_HISTORY)
			if pos then
				self.hotkey[pos] = {"talent", self.T_REVISIONIST_HISTORY_BACK}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_REVISIONIST_HISTORY_BACK, true, 1, {no_unlearn=true})
		self.hotkey = ohk
		self:startTalentCooldown(self.T_REVISIONIST_HISTORY)
	end,
	deactivate = function(self, eff)
		if eff.back_in_time then game:onTickEnd(function()
			-- Update the shader of the original player
			self:updateMainShader()
			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#The spell fizzles.")
				self:startTalentCooldown(self.T_REVISIONIST_HISTORY)
				return
			end
			game.logPlayer(game.player, "#LIGHT_BLUE#You go back in time to rewrite history!")
			game:chronoRestore("revisionist_history", true)
			game._chronoworlds = nil
			game.player.talents_cd[self.T_REVISIONIST_HISTORY] = nil
			game.player:startTalentCooldown(self.T_REVISIONIST_HISTORY)
		end) else
			game._chronoworlds = nil
			game.player.talents_cd[self.T_REVISIONIST_HISTORY] = nil
			self:startTalentCooldown(self.T_REVISIONIST_HISTORY)

			if self.hotkey and self.isHotkeyBound then
				local pos = self:isHotkeyBound("talent", self.T_REVISIONIST_HISTORY_BACK)
				if pos then
					self.hotkey[pos] = {"talent", self.T_REVISIONIST_HISTORY}
				end
			end

			self:unlearnTalent(self.T_REVISIONIST_HISTORY_BACK, 1, nil, {no_unlearn=true})
		end
	end,
}

newEffect{
	name = "ZONE_AURA_FIRE",
	desc = _t"Oil mist",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% fire damage, -10% fire resistance, -10% armour, -2 sight range.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.FIRE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=10})
		self:effectTemporaryValue(eff, "sight", -2)
		self:effectTemporaryValue(eff, "combat_armor", -math.ceil(self:combatArmor() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_COLD",
	desc = _t"Grave chill",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% cold damage, -10% cold resistance, -10% physical save, -20% confusion immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.COLD]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.COLD]=10})
		self:effectTemporaryValue(eff, "confusion_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_physresist", -math.ceil(self:combatPhysicalResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_LIGHTNING",
	desc = _t"Static discharge",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% lightning damage, -10% lightning resistance, -10% physical power, -20% stun immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHTNING]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=10})
		self:effectTemporaryValue(eff, "stun_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_dam", -math.ceil(self:combatPhysicalpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ACID",
	desc = _t"Noxious fumes",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% acid damage, -10% acid resistance, -10% defense, -20% disarm immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.ACID]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ACID]=10})
		self:effectTemporaryValue(eff, "disarm_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_def", -math.ceil(self:combatDefense(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_DARKNESS",
	desc = _t"Echoes of the void",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% darkness damage, -10% darkness resistance, -10% mental save, -20% fear immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.DARKNESS]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.DARKNESS]=10})
		self:effectTemporaryValue(eff, "fear_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_mentalresist", -math.ceil(self:combatMentalResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_MIND",
	desc = _t"Eerie silence",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% mind damage, -10% mind resistance, -10% spellpower, -20% silence immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.MIND]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.MIND]=10})
		self:effectTemporaryValue(eff, "silence_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_spellpower", -math.ceil(self:combatSpellpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_LIGHT",
	desc = _t"Aura of light",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% light damage, -10% light resistance, -10% accuracy, -20% blind immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHT]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHT]=10})
		self:effectTemporaryValue(eff, "blind_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_atk", -math.ceil(self:combatAttack() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ARCANE",
	desc = _t"Aether residue",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% arcane damage, -10% arcane resistance, -10% armour hardiness, -20% stoning immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.ARCANE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ARCANE]=10})
		self:effectTemporaryValue(eff, "stone_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_armor_hardiness", -math.ceil(self:combatArmorHardiness() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_TEMPORAL",
	desc = _t"Impossible geometries",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% temporal damage, -10% temporal resistance, -10% spell save, -20% pinning immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.TEMPORAL]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.TEMPORAL]=10})
		self:effectTemporaryValue(eff, "pin_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_spellresist", -math.ceil(self:combatSpellResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_PHYSICAL",
	desc = _t"Uncontrolled anger",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% physical damage, -10% physical resistance, -10% mindpower, -20% knockback immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.PHYSICAL]=10})
		self:effectTemporaryValue(eff, "knockback_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_mindpower", -math.ceil(self:combatMindpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_BLIGHT",
	desc = _t"Miasma",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% blight damage, -10% blight resistance, -20% healing mod, -20% disease immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.BLIGHT]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.BLIGHT]=10})
		self:effectTemporaryValue(eff, "disease_immune", -0.2)
		self:effectTemporaryValue(eff, "healing_factor", -0.2)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_NATURE",
	desc = _t"Slimy floor",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% nature damage, -10% nature resistance, -10% ranged defense, -20% poison immunity.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.NATURE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=10})
		self:effectTemporaryValue(eff, "poison_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_def_ranged", -math.ceil(self:combatDefenseRanged(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "VAULTED", image = "talents/time_prison.png",
	desc = _t"In Vault",
	long_desc = function(self, eff) return _t"The target is part of a vault and cannot act until it has been openend." end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { vault=true },
	status = "neutral",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "dont_act", 1)
		self:effectTemporaryValue(eff, "no_timeflow", 1)
		self:effectTemporaryValue(eff, "status_effect_immune", 1)
		self.energy.value = 0
	end,
	deactivate = function(self, eff) --wake up vaulted npcs in LOS
	  self:computeFOV(5, nil,
		function(x, y, dx, dy, sqdist)
			local act = game.level.map(x, y, Map.ACTOR)
			if act then
				act:removeEffect(act.EFF_VAULTED, true, true)
			end
		end, true, false, false)
	end,
}

newEffect{
	name = "CAUTERIZE", image = "talents/cauterize.png",
	desc = _t"Cauterize",
	long_desc = function(self, eff) return ("Your body is cauterizing, burning for %0.2f damage each turn."):tformat(eff.dam) end,
	type = "other",
	subtype = { fire=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return _t"#CRIMSON##Target# is wreathed in flames on the brink of death!", _t"+Cauterize" end,
	on_lose = function(self, err) return _t"#CRIMSON#The flames around #target# vanish.", _t"-Cauterize" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.dam = old_eff.dam + new_eff.dam
		return old_eff
	end,
	activate = function(self, eff)
		self.life = self.old_life or 10
		eff.invulnerable = true
		eff.particle1 = self:addParticles(Particles.new("inferno", 1))
		eff.particle2 = self:addParticles(Particles.new("inferno", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
	on_timeout = function(self, eff)
		if eff.invulnerable then
			eff.dur = eff.dur + 1
			return
		end
		local dead, val = self:takeHit(eff.dam, self, {special_death_msg="burnt to death by cauterize"})

		local srcname = self.x and self.y and game.level.map.seens(self.x, self.y) and self:getName():capitalize() or _t"Something"
		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):tformat(DamageType:get(DamageType.FIRE).text_color or "#aaaaaa#", math.ceil(val), DamageType:get(DamageType.FIRE).name), false)
	end,
}

newEffect{
	name = "EIDOLON_PROTECT", image = "shockbolt/npc/unknown_unknown_the_eidolon.png",
	desc = _t"Protected by the Eidolon",
	long_desc = function(self, eff) return _t"The target is protected by the Eidolon, no creature may harm it (except self-harm)." end,
	zone_wide_effect = true,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { eidolon=true },
	status = "neutral",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "invulnerable_others", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CLOAK_OF_DECEPTION", image = "shockbolt/object/artifact/black_cloak.png",
	desc = _t"Cloak of Deception",
	long_desc = function(self, eff) return _t"The target is under the effect of the cloak of deception, making it look human." end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { undead=true },
	status = "neutral",
	parameters = {},
	on_gain = function(self, err) return ("#LIGHT_BLUE#An illusion appears around #Target# making %s appear human."):tformat(self:him_her()), _t"+CLOAK OF DECEPTION" end,
	on_lose = function(self, err) return _t"#LIGHT_BLUE#The illusion covering #Target# disappears.", _t"-CLOAK OF DECEPTION" end,
	activate = function(self, eff)
		self.old_faction_cloak = self.faction
		self.faction = "allied-kingdoms"
		if self.descriptor and self.descriptor.race and self:attr("undead") then self.descriptor.fake_race = "Human" end
		if self.descriptor and self.descriptor.subrace and self:attr("undead") then self.descriptor.fake_subrace = "Cornac" end
		if self.player then engine.Map:setViewerFaction(self.faction) end
	end,
	deactivate = function(self, eff)
		if self.permanent_undead_cloak then return end  -- Make absolutely sure that players can't lose this effect
		self.faction = self.old_faction_cloak
		if self.descriptor and self.descriptor.race and self:attr("undead") then self.descriptor.fake_race = nil end
		if self.descriptor and self.descriptor.subrace and self:attr("undead") then self.descriptor.fake_subrace = nil end
		if self.player then engine.Map:setViewerFaction(self.faction) end
	end,
}

newEffect{
	name = "SUFFOCATING",
	desc = _t"Suffocating",
	long_desc = function(self, eff) return ("You are suffocating! Each turn you lose an ever increasing percent of your total life (currently %d%%)"):tformat(eff.dam) end,
	type = "other",
	subtype = { suffocating=true },
	status = "detrimental",
	decrease = 0, no_remove = true,
	parameters = { dam=20 },
	on_gain = function(self, err) return _t"#Target# is suffocating.", _t"+SUFFOCATING" end,
	on_lose = function(self, err) return _t"#Target# can breathe again.", _t"-Suffocating" end,
	on_timeout = function(self, eff)
		if not self.is_suffocating then
			self:removeEffect(self.EFF_SUFFOCATING, false, true)
			return
		end
		-- We can breathe now! What a relief!
		local air_level, air_condition = game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "air_level"), game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "air_condition")
		if air_level then
			if not (not air_condition or not self.can_breath[air_condition] or self.can_breath[air_condition] <= 0) or self:attr("no_breath") or self:attr("invulnerable") then
				self.is_suffocating = nil
				self:removeEffect(self.EFF_SUFFOCATING, false, true)
				return
			end
		end

		-- Bypass all shields & such
		local old = self.onTakeHit
		self.onTakeHit = nil
		mod.class.interface.ActorLife.takeHit(self, self.max_life * eff.dam / 100, self, {special_death_msg=_t"suffocated to death"})
		eff.dam = util.bound(eff.dam + 5, 20, 100)
		self.onTakeHit = old
	end,
}

newEffect{
	name = "ANTIMAGIC_DISRUPTION",
	desc = _t"Antimagic Disruption",
	long_desc = function(self, eff)
		local chance = self:attr("spell_failure") or 0
		return ("Your arcane powers are disrupted by your antimagic equipment.  Arcane talents fail %d%% of the time and arcane sustains have a %0.1f%% chance to deactivate each turn."):tformat(chance, chance/10)
	end,
	type = "other",
	subtype = { antimagic=true },
	no_stop_enter_worlmap = true,
	status = "detrimental",
	decrease = 0, no_remove = true,
	parameters = { },
	on_timeout = function(self, eff)
		if not self:attr("has_arcane_knowledge") or not self:attr("spellpower_reduction") then
			self:removeEffect(self.EFF_ANTIMAGIC_DISRUPTION, true, true)
		end
	end,
}

newEffect{
	name = "SWIFT_HANDS_CD", image = "talents/swift_hands.png",
	desc = _t"Swift Hands",
	long_desc = function(self, eff) return _t"You swaped an item without taking time this turn." end,
	type = "other",
	subtype = { prodigy=true },
	status = "neutral",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "quick_wear_takeoff_disable", 1)
	end,
}

newEffect{
	name = "HUNTER_PLAYER", image = "talents/hunted_player.png",
	desc = _t"Hunter!",
	long_desc = function(self, eff) return _t"Knows where you are!" end,
	type = "other",
	subtype = { madness=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		if not self.ai_state then return end
		if self.ai_state and self.ai_state.ai_move and self.ai_state.ai_move ~= "move_astar_advanced" then self:effectTemporaryValue(eff, {"ai_state","ai_move"}, "move_astar") end  -- Not sure if theres a performance issue with giving everything astar_advanced so just make sure we don't overwrite it
		self:setTarget(eff.src)
	end,
}

newEffect{
	name = "THROUGH_THE_CROWD", image = "talents/through_the_crowd.png",
	desc = _t"Through The Crowd",
	long_desc = function(self, eff) return ("Increases physical save, spell save, and mental save by %d. Global speed increased by %d%%."):tformat(eff.power * 10, util.bound(eff.power, 0, 5) * 3) end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.presid = self:addTemporaryValue("combat_physresist", eff.power * 10)
		eff.sresid = self:addTemporaryValue("combat_spellresist", eff.power * 10)
		eff.mresid = self:addTemporaryValue("combat_mentalresist", eff.power * 10)
		eff.speedid = self:addTemporaryValue("global_speed_add", util.bound(eff.power, 0, 5) * 0.03)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physresist", eff.presid)
		self:removeTemporaryValue("combat_spellresist", eff.sresid)
		self:removeTemporaryValue("combat_mentalresist", eff.mresid)
		self:removeTemporaryValue("global_speed_add", eff.speedid)
	end,
}

newEffect{
	name = "RELOAD_DISARMED", image = "talents/disarm.png",
	desc = _t"Reloading",
	long_desc = function(self, eff) return _t"The target has replenished some ammo." end,
	type = "other",
	subtype = { disarm=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is disarmed!", _t"+Disarmed" end,
	on_lose = function(self, err) return _t"#Target# rearms.", _t"-Disarmed" end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_COUNTER_ATTACKING) -- Cannot parry or counterattack while disarmed
		self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE)
		eff.tmpid = self:addTemporaryValue("disarmed", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("disarmed", eff.tmpid)
	end,
}

newEffect{
	name = "SPACETIME_TUNING", image = "talents/spacetime_tuning.png",
	desc = _t"Spacetime Tuning",
	long_desc = function(self, eff) return ("Tuning Paradox at a rate of %+d per turn."):tformat(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10},
	on_gain = function(self, err) return _t"#Target# retunes the fabric of spacetime.", _t"+Spacetime Tuning" end,
	on_timeout = function(self, eff)
		self:callTalent(self.T_SPACETIME_TUNING, "tuneParadox") -- adjusts paradox level
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=2.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=1.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "TIME_STOP", image = "talents/time_stop.png",
	desc = _t"Time Stop",
	long_desc = function(self, eff)
		return ("The target has stopped time and is dealing %d%% less damage."):tformat(eff.power)
	end,
	charges = function(self, eff)
		local charges = math.floor(self.energy.value/1000) - 1
		if charges <= 0 then
			self:removeEffect(self.EFF_TIME_STOP)
		end
		return charges
	end,
	type = "other",
	subtype = {time=true},
	status = "detrimental",
	parameters = {power=50},
	remove_on_clone = true,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "generic_damage_penalty", eff.power)
		self:effectTemporaryValue(eff, "timestopping", 1)
		self.no_leave_control = true
		core.display.pauseAnims(true)

		-- clone protection
		if self.player then
			self:updateMainShader()
		end
	end,
	deactivate = function(self, eff)
		self.no_leave_control = false
		core.display.pauseAnims(false)

		-- clone protection
		if self == game.player then
			self:updateMainShader()
		end
	end,
}

newEffect{
	name = "TEMPORAL_REPRIEVE", image = "talents/temporal_reprieve.png",
	desc = _t"Temporal Reprieve",
	long_desc = function(self, eff) return ("This target has retreated to a safe place."):tformat() end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=1 },
	on_timeout = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
		-- Return from the reprieve
		game:onTickEnd(function()
			-- Collect objects
			local objs = {}
			for i = 0, game.level.map.w - 1 do for j = 0, game.level.map.h - 1 do
				for z = game.level.map:getObjectTotal(i, j), 1, -1 do
					objs[#objs+1] = game.level.map:getObject(i, j, z)
					game.level.map:removeObject(i, j, z)
				end
			end end

			local oldzone = game.zone
			local oldlevel = game.level
			local zone = game.level.source_zone
			local level = game.level.source_level

			if not self.dead then
				oldlevel:removeEntity(self)
				level:addEntity(self)
			end

			game.zone = zone
			game.level = level
			game.zone_name_s = nil

			local x1, y1 = util.findFreeGrid(eff.x, eff.y, 20, true, {[Map.ACTOR]=true})
			if x1 then
				if not self.dead then
					self:move(x1, y1, true)
					self.on_die, self.temporal_reprieve_on_die = self.temporal_reprieve_on_die, nil
					game.level.map:particleEmitter(x1, y1, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					self.x, self.y = x1, y1
				end
			end

			-- Add objects back
			for i, o in ipairs(objs) do
				game.level.map:addObject(self.x, self.y, o)
			end

			-- Remove all npcs in the reprieve
			for uid, e in pairs(oldlevel.entities) do
				if e ~= self and e.die then e:die() end
			end

			-- Reload MOs
			game.level.map:redisplay()
			game.level.map:recreate()
			game.uiset:setupMinimap(game.level)
			game.nicer_tiles:postProcessLevelTilesOnLoad(game.level)

			game.logPlayer(game.player, "#STEEL_BLUE#You are brought back from your repreive!")

		end)
	end,
}

newEffect{
	name = "TEMPORAL_FUGUE", image = "talents/temporal_fugue.png",
	desc = _t"Temporal Fugue",
	long_desc = function(self, eff) return _t"This target is splitting all damage with its fugue clones." end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	decrease = 0,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if src ~= self and src.hasEffect and src:hasEffect(src.EFF_TEMPORAL_FUGUE) then
			-- Find our clones
			for i = 1, #eff.targets do
				local target = eff.targets[i]
				if target == self then dam = 0 end
			end
		end
		return {dam=dam}
	end,
	callbackOnHit = function(self, eff, cb, src)
		if cb.value <= 0 then return cb.value end

		local clones = {}
		-- Find our clones
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if not target.dead and game.level:hasEntity(target) then
				clones[#clones+1] = target
			end
		end

		-- Split the damage
		if #clones > 0 and not self.turn_procs.temporal_fugue_damage_self and not self.turn_procs.temporal_fugue_damage_target then
			self.turn_procs.temporal_fugue_damage_self = true
			cb.value = cb.value/#clones
			game:delayedLogMessage(self, nil, "fugue_damage", "#STEEL_BLUE##Source# shares damage with %s fugue clones!", string.his_her(self))
			for i = 1, #clones do
				local target = clones[i]
				if target ~= self then
					target.turn_procs.temporal_fugue_damage_target = true
					target:takeHit(cb.value, src)
					game:delayedLogDamage(src or self, self, 0, ("#STEEL_BLUE#(%d shared)#LAST#"):tformat(cb.value), nil)
					target.turn_procs.temporal_fugue_damage_target = nil
				end
			end

			self.turn_procs.temporal_fugue_damage_self = nil
		end

		-- If we're the last clone remove the effect
		if #clones <= 0 then
			self:removeEffect(self.EFF_TEMPORAL_FUGUE)
		end

		return cb.value
	end,
	on_timeout = function(self, eff)
		-- Temporal Fugue does not cooldown while active
		if self.talents_cd[self.T_TEMPORAL_FUGUE] then
			self.talents_cd[self.T_TEMPORAL_FUGUE] = self.talents_cd[self.T_TEMPORAL_FUGUE] + 1
		end

		local alive = false
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if target ~=self and not target.dead then
				alive = true
				break
			end
		end
		if not alive then
			self:removeEffect(self.EFF_TEMPORAL_FUGUE)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "generic_damage_penalty", 66)
	end,
}

newEffect{
	name = "DRACONIC_WILL", image = "talents/draconic_will.png",
	desc = _t"Draconic Will",
	long_desc = function(self, eff) return _t"The target is immune to all detrimental effects." end,
	type = "other",
	subtype = { nature=true },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target#'s skin hardens.", _t"+Draconic Will" end,
	on_lose = function(self, err) return _t"#Target#'s skin is back to normal.", _t"-Draconic Will" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "REALITY_SMEARING", image = "talents/reality_smearing.png",
	desc = _t"Reality Smearing",
	long_desc = function(self, eff) return ("Damage received in the past is returned as %0.2f paradox damage per turn."):tformat(eff.paradox) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { paradox=10 },
	on_gain = function(self, err) return _t"Reality smears around #Target#.", _t"+Smearing" end,
	on_lose = function(self, err) return _t"Reality around #Target# is coherent again.", _t"-Smearing" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local oldparadox = old_eff.paradox * old_eff.dur
		local newparadox = new_eff.paradox * new_eff.dur
		old_eff.paradox = (oldparadox + newparadox) / new_eff.dur
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		self:incParadox(eff.paradox)
	end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="transparent_cylinder", scrollingSpeed=0.0002, density=15, radius=1.6, growSpeed=0.004, img="continuum_01_5"})
		else
			eff.particle1 = self:addParticles(Particles.new("time_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "AEONS_STASIS",
	desc = _t"Aeons Stasis",
	long_desc = function(self, eff) return _t"The target is in temporal stasis." end,
	type = "other", decrease = 0, no_remove = true,
	subtype = { temporal=true },
	status = "beneficial",
	on_lose = function(self, err) return _t"#Target#'s is back to the normal timeflow.", _t"-Aeons Stasis" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "status_effect_immune", 1)
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "cant_be_moved", 1)
		self.never_act = true
		eff.old_faction = self.faction
		self.faction = "neutral"
	end,
	deactivate = function(self, eff)
		self.faction = eff.old_faction
		self.never_act = nil
		self:disappear(self)
		local e = game.zone:makeEntity(game.level, "actor", {type="giant", subtype="ogre", special_rarity="special_rarity"}, nil, true)
		local x, y = util.findFreeGrid(self.x, self.y, 10, true, {[Map.ACTOR]=true})
		if e and x then
			game.zone:addEntity(game.level, e, "actor", x, y)

			local og = game.level.map(x, y, Map.TERRAIN)
			if not og or (not og.special and not og.change_level) then
				local g = game.zone.grid_list[self.to_vat]
				if g then game.zone:addEntity(game.level, g, "terrain", x, y) end
			end

			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
		end
	end,
	on_timeout = function(self, eff)
		if eff.timeout then
			eff.timeout = eff.timeout - 1
			if eff.timeout <= 0 then
				self:removeEffect(self.EFF_AEONS_STASIS, nil, true)
			end
		end
	end,
}

newEffect{
	name = "UNSTOPPABLE", image = "talents/unstoppable.png",
	desc = _t"Unstoppable",
	long_desc = function(self, eff) return ("The target is unstoppable! It refuses to die and cannot heal.  When the effect ends, it will heal %d Life (%d%% of maximum life per foe slain during the frenzy)."):tformat(eff.kills * eff.hp_per_kill * self.max_life / 100, eff.hp_per_kill) end,
	type = "other",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { hp_per_kill=2 },
	activate = function(self, eff)
		eff.kills = 0
		eff.tmpid = self:addTemporaryValue("unstoppable", 1)
		eff.healid = self:addTemporaryValue("no_life_regen", 1)
		eff.nohealid = self:addTemporaryValue("no_healing", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("unstoppable", eff.tmpid)
		self:removeTemporaryValue("no_life_regen", eff.healid)
		self:removeTemporaryValue("no_healing", eff.nohealid)
		self:heal(eff.kills * eff.hp_per_kill * self.max_life / 100, eff)
	end,
}

newEffect{
	name = "2H_PENALTY", image = "talents/unstoppable.png",
	desc = _t"Hit Penalty",
	long_desc = function(self, eff) return ("The target is using a two handed weapon in a single hand, reducing accuracy, physical power, spellpower and mindpower by %d%% (based on size); also all damage procs from your offhand are reduced by 50%%."):tformat(20 - math.min(self.size_category - 4, 4) * 5) end,
	type = "other", decrease = 0, no_remove = true,
	subtype = { combat=true, penalty=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "hit_penalty_2h", 1)
	end,
}

newEffect{
	name = "TWIST_FATE", image = "talents/twist_fate.png",
	desc = _t"Twist Fate",
	long_desc = function(self, eff)
		local t = self:getTalentFromId(eff.talent)
		return
		([[Currently Twisted Anomlay: %s

		%s]]):tformat(t.name or "none", t.info(self, t) or "none")
	end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { paradox=0, twisted=false },
	on_gain = function(self, err) return nil, _t"+Twist Fate" end,
	on_lose = function(self, err) return nil, _t"-Twist Fate" end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="fast_sphere", appear=10, radius=1.6, twist=30, density=30, growSpeed=0.004, scrollingSpeed=-0.004, img="continuum_01_3"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		if not game.zone.wilderness and not self.dead then
			if not eff.twisted then
				self:forceUseTalent(eff.talent, {force_target=self, ignore_energy=true})
				-- manually use energy
				local anom = self:getTalentFromId(eff.talent)
				self:useEnergy(self:getTalentSpeed(anom) * game.energy_to_act)

				game:playSoundNear(self, "talents/dispel")
				self:incParadox(-eff.paradox)
			end
		end
	end,
}

-- Dummy effect for particles
newEffect{
	name = "WARDEN_S_TARGET", image = "talents/warden_s_focus.png",
	desc = _t"Warden's Focus Target",
	long_desc = function(self, eff) return ("%s is focusing on this target."):tformat(eff.src:getName()) end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {},
	remove_on_clone = true, decrease = 0,
	on_gain = function(self, err) return nil, _t"+Warden's Focus" end,
	on_lose = function(self, err) return nil, _t"-Warden's Focus" end,
	on_timeout = function(self, eff)
		local p = eff.src:hasEffect(eff.src.EFF_WARDEN_S_FOCUS)
		if not p or p.target ~= self or eff.src.dead or not game.level:hasEntity(eff.src) or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 10 then
			self:removeEffect(self.EFF_WARDEN_S_TARGET)
		end
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={299/255, 0/255, 0/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={229/255, 0/255, 0/255, 1}, circleColor={0.8,0,0,0.8}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "DEATH_DREAM", image = "talents/sleep.png",
	desc = _t"Death in a Dream",
	type = "other", subtype={mind=true},
	status = "detrimental",
	long_desc = function(self, eff) return ("The target had breathed in noxious sleep-induced fumes and is losing %d life per turn."):tformat(eff.power) end,
	on_timeout = function(self, eff)
		local dead, val = self:takeHit(eff.power, self, {special_death_msg="killed in a dream"})
		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):tformat(DamageType:get(DamageType.MIND).text_color or "#aaaaaa#", math.ceil(val), "dream"), false)
	end,
}

newEffect{
	name = "ZONE_AURA_GORBAT",
	desc = _t"Natural Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +20 mindpower, +2 life regen, -1 equilibrium per turn, -20% resistance penetration.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_mindpower", 20)
		self:effectTemporaryValue(eff, "life_regen", 2)
		self:effectTemporaryValue(eff, "equilibrium_regen", -1)
		self:effectTemporaryValue(eff, "resists_pen", {all=-20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_VOR",
	desc = _t"Sorcerous Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +20 magic, +2 mana regen, -20 accuracy, -20 stealth power.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stats", {[Stats.STAT_MAG] = 20})
		self:effectTemporaryValue(eff, "mana_regen", 2)
		self:effectTemporaryValue(eff, "combat_atk", -20)
		self:effectTemporaryValue(eff, "inc_stealth", -20)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_GRUSHNAK",
	desc = _t"Disciplined Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +20 defense, +20 all saves, -20 spell power.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_def", 20)
		self:effectTemporaryValue(eff, "combat_physresist", 20)
		self:effectTemporaryValue(eff, "combat_spellresist", 20)
		self:effectTemporaryValue(eff, "combat_mentalresist", 20)
		self:effectTemporaryValue(eff, "combat_spellpower", -20)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_RAKSHOR",
	desc = _t"Sinister Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: +10% critical chance, +20% critical damage, -20% nature and blight resistance.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physcrit", 10)
		self:effectTemporaryValue(eff, "combat_spellcrit", 10)
		self:effectTemporaryValue(eff, "combat_mindcrit", 10)
		self:effectTemporaryValue(eff, "combat_critical_power", 20)
		self:effectTemporaryValue(eff, "resists", {[DamageType.NATURE]=-20, [DamageType.BLIGHT]=-20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_UNDERWATER",
	desc = _t"Underwater Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: Air decreases over time. If you run out of air you will start losing life. Look for bubbles to recover air. The water also reduces stun resistance by 10% and fire damage is reduced by 10%, however cold damage is increased by 10%.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stun_immune", -0.1)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.COLD]=10, [DamageType.FIRE]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_FEARSCAPE",
	desc = _t"Fearscape Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: The flames of the Fearscape increase all fire and blight damage by 10%, but the weird gravity reduces knockback resistance by 20%.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "knockback_immune", -0.2)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.BLIGHT]=10, [DamageType.FIRE]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_OUT_OF_TIME",
	desc = _t"Out of Time Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: You seem to be outside the normal spacetime continuum. +10% physical resistance, -10% temporal resistance and -20% teleport resistance.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "teleport_immune", -0.2)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=10, [DamageType.TEMPORAL]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_SPELLBLAZE",
	desc = _t"Spellblaze Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: The power of the Spellblaze still burns here. -10% resistance to fire, arcane and blight damage, but +10% cold resistance. WARNING: The powerful magic here reflects teleportation magic!") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.FIRE]=-10, [DamageType.ARCANE]=-10, [DamageType.BLIGHT]=-10, [DamageType.COLD]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_CALDERA",
	desc = _t"Heady Scent",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: Strong scents fill the air and make you feel drowsy. If the timer reaches 0 you will fall into a dreaming sleep state. -10% mind resistance, -20% sleep resistance, +10% nature damage.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "sleep_immune", -0.2)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=10})
		self:effectTemporaryValue(eff, "resists", {[DamageType.MIND]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_THUNDERSTORM",
	desc = _t"Thunderstorm",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: A huge thunderstorm rages above you. +10 lightning damage, -10% stun resistance.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stun_immune", -0.1)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ABASHED",
	desc = _t"Abashed Expanse",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (_t"Zone-wide effect: Your Phase Door spell is super easy to use here, allowing you to target it regardless of level. Any projectiles is slowed down by 80%.") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "slow_projectiles_outgoing", 80)
		self:effectTemporaryValue(eff, "phase_door_force_precise", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_CHALLENGE",
	desc = _t"Challenge",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return _t"???" else return self:hasQuest(eff.id_challenge_quest).name end end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "neutral",
	zone_wide_effect = false,
	parameters = {},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_exit_level", self)
	end,
	callbackOnKill = function(self, eff, who, death_note)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_kill_foe", self, who)
	end,
	callbackOnActBase = function(self, eff)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_act_base", self)
	end,
	callbackOnChangeLevel = function(self, eff)
		local q = eff.id_challenge_quest and self:hasQuest(eff.id_challenge_quest)
		if q then q:check("on_exit_level", self) end
	end,
}

newEffect{
	name = "THROWING_KNIVES", image = "talents/throwing_knives.png",
	desc = _t"Throwing Knives",  decrease = 0,
	display_desc = function(self, eff) return ("%d Knives"):tformat(eff.stacks) end,
	long_desc = function(self, eff) return ("Has %d throwing knives prepared:\n\n%s"):tformat(eff.stacks, self:callTalent(self.T_THROWING_KNIVES, "knivesInfo")) end,
	type = "other",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { stacks=1, max_stacks=6 },
	charges = function(self, eff) return eff.stacks end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.max_stacks = new_eff.max_stacks
		old_eff.stacks = util.bound(old_eff.stacks + new_eff.stacks, 0, new_eff.max_stacks)
		return old_eff
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

--while strictly speaking these fit better as physical effects, the ability for a mob to layer 3 different physical debuffs on a player with one swing and block off clearing stuns via wild infusions is not good. bad enough that they can bleed/poison

newEffect{
	name = "SCOUNDREL", image = "talents/scoundrel.png",
	desc = _t"Scoundrel's Strategies",
	long_desc = function(self, eff) return ("The target is suffering from disabling wounds, reducing their critical strike damage by %d%%."):
		tformat( eff.power ) end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = { power=1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_critical_power", -eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "FUMBLE", image = "talents/fumble.png",
	desc = _t"Fumble",
	long_desc = function(self, eff) return ("The target is suffering from distracting wounds, and has a %d%% chance to fail to use a talent and injure itself for %d physical damage."):
		tformat( eff.power*eff.stacks, eff.dam ) end,
	charges = function(self, eff) return eff.stacks end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	charges = function(self, eff) return eff.stacks or 1 end,
	parameters = { power=1, dam=10, stacks = 0, max_stacks=10 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur

		local stackCount = old_eff.stacks + new_eff.stacks
		if stackCount >= old_eff.max_stacks then
			stackCount = old_eff.max_stacks
		end

		self:removeTemporaryValue("scoundrel_failure", old_eff.failid)
		old_eff.failid = self:addTemporaryValue("scoundrel_failure", old_eff.cur_fail*stackCount)

		old_eff.stacks = stackCount

		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_fail = eff.power
		eff.failid = self:addTemporaryValue("scoundrel_failure", eff.cur_fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("scoundrel_failure", eff.failid)
	end,
	do_Fumble = function(self, eff)
		eff.src:projectSource({"hit"}, self.x, self.y, DamageType.PHYSICAL, eff.src:physicalCrit(eff.dam), nil, eff)
	end,
	callbackOnTalentDisturbed = function(self, eff, t, failure_cause)
		if self:attr("scoundrel_failure") then
			self:callEffect(self.EFF_FUMBLE, "do_Fumble")
			if failure_cause == eff then
				self:removeEffect(self.EFF_FUMBLE)
			end
		end
	end,
}

newEffect{
	name = "TOUCH_OF_DEATH", image = "talents/touch_of_death.png",
	desc = _t"Touch of Death",
	long_desc = function(self, eff) return ("The target is taking %0.2f physical damage each turn. If they die while under this effect, they will explode!"):tformat(eff.dam) end,
	type = "other", --extending this would be very bad
	subtype = {  },
	status = "detrimental",
	parameters = { dur=4, dam=10, radius=1, combo=1 },
	on_gain = function(self, err) return _t"#Target# is mortally wounded!", _t"+Touch of Death!" end,
	on_lose = function(self, err) return _t"#Target# overcomes the touch of death.", _t"-Touch of Death" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam)
		eff.dam = eff.dam * (1 + eff.mult)
	end,
	on_die = function(self, eff)
		eff.src:buildCombo()
		eff.src:buildCombo()
		eff.src:buildCombo()
		eff.src:buildCombo()
		local tg = {type="ball", radius=eff.radius, selffire=false, friendlyfire=false, x=self.x, y=self.y}
		local dam = eff.dam
		eff.src:project(tg, self.x, self.y, DamageType.PHYSICAL, dam, {type="bones"})
		game.logSeen(eff.src, "#LIGHT_RED#%s explodes into a shower of gore!", self:getName():capitalize())
		self:removeEffect(self.EFF_TOUCH_OF_DEATH)
	end,
}

newEffect{
	name = "MARKED", image = "talents/master_marksman.png",
	desc = _t"Marked",
	long_desc = function(self, eff) return ("Target is marked, leaving them vulnerable to marked shots."):tformat() end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, _t"+Marked!" end,
	on_lose = function(self, err) return nil, _t"-Marked" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("circle", 1, {base_rot=1, oversize=1.0, a=200, appear=8, speed=0, img="marked", radius=0}))
		self:effectTemporaryValue(eff, "marked", 1)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
--	on_die = function(self,eff)
--		if eff.src and eff.src:knowTalent(eff.src.T_FIRST_BLOOD) then eff.src:incStamina(eff.src:callTalent(eff.src.T_FIRST_BLOOD, "getStamina")) end
--	end,
}

newEffect{
	name = "FLARE",
	desc = _t"Flare", image = "talents/flare_raz.png",
	long_desc = function(self, eff) return ("The target is lit up by a flare, reducing its stealth and invisibility power by %d, defense by %d and removing all evasion bonus from being unseen."):tformat(eff.power, eff.power) end,
	type = "other",
	subtype = { sun=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return nil, _t"+Illumination" end,
	on_lose = function(self, err) return nil, _t"-Illumination" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stealth", -eff.power)
		if self:attr("invisible") then self:effectTemporaryValue(eff, "invisible", -eff.power) end
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
		self:effectTemporaryValue(eff, "blind_fighted", 1)
	end,
}

newEffect{
	name = "PIN_DOWN",
	desc = _t"Pinned Down", image = "talents/pin_down.png",
	long_desc = function(self, eff) return ("The next Steady Shot or Shoot has 100%% chance to be a critical hit and mark."):tformat() end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {power = 1},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "DEMI_GODMODE",
	desc = _t"Demigod Mode", image = "effects/darkgod.png",
	long_desc = function(self, eff) return ("DEMI-GODMODE: Target has 10000 additional life and regenerates 2000 life per turn.  It deals +500%% damage, and has full ESP."):tformat() end,
	type = "other",
	subtype = { cheat=true },
	status = "beneficial",
	parameters = {power = 1},
	decrease = 0, no_remove = true,
	activate = function(self, eff)
		eff.ignore_prodigies_special_reqs = game.state.birth.ignore_prodigies_special_reqs
		self:effectTemporaryValue(eff, "invulnerable", 0)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 0)
		self:effectTemporaryValue(eff, "esp_all", 1)
		self:effectTemporaryValue(eff, "esp_range", 500)
--		self:effectTemporaryValue(eff, "no_breath", 1)
		self:effectTemporaryValue(eff, "auto_id", 100)
		self:effectTemporaryValue(eff, "max_life", 10000)
		self:effectTemporaryValue(eff, "life_regen", 2000)
		self:effectTemporaryValue(eff, "inc_damage", {all=500})
		self:effectTemporaryValue(eff, "resists_pen", {all=0})
--		self:resetToFull()
		game.state.birth.ignore_prodigies_special_reqs = true
		self:resetCanSeeCache() game.level.map:cleanFOV() self:doFOV()
	end,
	deactivate = function(self, eff)
		game.state.birth.ignore_prodigies_special_reqs = eff.ignore_prodigies_special_reqs
		self:resetCanSeeCache() game.level.map:cleanFOV() self:doFOV()
	end,
}

newEffect{
	name = "GODMODE",
	desc = _t"God Mode", image = "effects/darkgod.png",
	long_desc = function(self, eff) return ("GODMODE: Target is invulnerable to damage, immune to bad status effects, deals +10000%% damage (100%% penetration), does not need to breathe, and has full ESP."):tformat() end,
	type = "other",
	subtype = { cheat=true },
	status = "beneficial",
	parameters = {power = 1},
	decrease = 0, no_remove = true,
	activate = function(self, eff)
		eff.ignore_prodigies_special_reqs = game.state.birth.ignore_prodigies_special_reqs
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
		self:effectTemporaryValue(eff, "esp_all", 1)
		self:effectTemporaryValue(eff, "esp_range", 500)
		self:effectTemporaryValue(eff, "no_breath", 1)
		self:effectTemporaryValue(eff, "auto_id", 100)
		self:effectTemporaryValue(eff, "inc_damage", {all=10000})
		self:effectTemporaryValue(eff, "resists_pen", {all=100})
		game.state.birth.ignore_prodigies_special_reqs = true
		self:resetCanSeeCache() game.level.map:cleanFOV() self:doFOV()
	end,
	deactivate = function(self, eff)
		game.state.birth.ignore_prodigies_special_reqs = eff.ignore_prodigies_special_reqs
		self:resetCanSeeCache() game.level.map:cleanFOV() self:doFOV()
	end,
}

newEffect{
	name = "SLIPPERY_GROUND", image = "talents/freeze.png",
	desc = _t"Slippery Ground",
	long_desc = function(self, eff) return ("The target is having trouble keeping their balance. Each time it tries to use a talent there is %d%% chance of failure."):tformat(eff.fail) end,
	type = "other",
	subtype = { nature=true },
	status = "detrimental",
	parameters = {fail=20},
	on_gain = function(self, err) return _t"#Target# is struggling to keep his footing!", _t"+Slippery Ground" end,
	on_lose = function(self, err) return _t"#Target# regains their balance.", _t"-Slippery Ground" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "FROZEN_GROUND", image = "talents/freeze.png",
	desc = _t"Frozen Ground",
	long_desc = function(self, eff) return ("The target is energized by the cold while wearing the Frost Treads, gaining 20%% increased cold damage."):tformat(eff.fail) end,
	type = "other",
	subtype = { nature=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is energized by the cold!", _t"+Frozen Ground" end,
	on_lose = function(self, err) return _t"#Target# regains balance.", _t"-Frozen Ground" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[engine.DamageType.COLD] = 20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RECALL", image = "effects/recall.png",
	desc = _t"Recalling",
	long_desc = function(self, eff) return _t"The target is waiting to be recalled back to the worldmap." end,
	type = "magical",
	subtype = { unknown=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		if (eff.allow_override or (self == game:getPlayer(true) and self:canBe("worldport") and not self:attr("never_move"))) and eff.dur <= 0 then
			game:onTickEnd(function()
				if eff.leveid == game.zone.short_name.."-"..game.level.level and game.player.can_change_zone then
					game.logPlayer(self, "You are yanked out of this place!")
					game:changeLevel(1, eff.where or game.player.last_wilderness)
				end
			end)
		else
			game.logPlayer(self, "Space restabilizes around you.")
		end
	end,
}

newEffect{
	name = "STEALTH_SKEPTICAL", image = "talents/stealth.png",
	desc = _t"Skeptical",
	long_desc = function(self, eff) return _t"The target doesn't believe its ally truly saw anything in the shadows." end,
	type = "other",
	subtype = { },
	status = "neutral",
	parameters = {target = {} },
	activate = function(self, eff)
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.target = new_eff.target
		return old_eff
	end,
	deactivate = function(self, eff)
		self:setTarget(eff.target.actor, eff.target.last)
	end,
}

newEffect{
	name = "UNLIT_HEART", image = "talents/armour_of_shadows.png",
	desc = _t"Empowered by the shadows",
	long_desc = function(self, eff) return ("Gain %d%% all damage and %d%% all res."):tformat(eff.dam, eff.res) end,
	type = "other",
	subtype = { darkness = true },
	status = "beneficial",
	parameters = { dam = 15, res = 10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {all = eff.dam})
		self:effectTemporaryValue(eff, "resists", {all = eff.res})
	end,
}

newEffect{
	name = "INTIMIDATED",
	desc = _t"Intimidated",
	long_desc = function(self, eff) return ("The target's morale is weakened, reducing its attack power, mind power, and spellpower by %d."):tformat(eff.power) end,
	charges = function(self, eff) return math.round(eff.power) end,
	type = "other",
	subtype = { },
	no_stop_enter_worlmap = true, cancel_on_level_change = true,
	status = "detrimental",
	on_gain = function(self, err) return _t"#Target#'s morale has been lowered.", _t"+Intimidated" end,
	on_lose = function(self, err) return _t"#Target# has regained its confidence.", _t"-Intimidated" end,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff, e)
		self:removeTemporaryValue("combat_dam", old_eff.damid)
		self:removeTemporaryValue("combat_spellpower", old_eff.spellid)
		self:removeTemporaryValue("combat_mindpower", old_eff.mindid)
		old_eff.damid = self:addTemporaryValue("combat_dam", -new_eff.power)
		old_eff.spellid = self:addTemporaryValue("combat_spellpower", -new_eff.power)
		old_eff.mindid = self:addTemporaryValue("combat_mindpower", -new_eff.power)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", -eff.power)
		eff.spellid = self:addTemporaryValue("combat_spellpower", -eff.power)
		eff.mindid = self:addTemporaryValue("combat_mindpower", -eff.power)
		if core.shader.active() then
			eff.particle = self:addParticles(Particles.new("circle", 1, {oversize=1, a=80, shader=true, appear=12, img="blood_vengeance_lightningshield", speed=0, base_rot=180, radius=0}))
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_mindpower", eff.mindid)
	end,
}

newEffect{
	name = "FEED", image = "talents/feed.png",
	desc = _t"Feeding",
	long_desc = function(self, eff) return ("%s is feeding from %s."):tformat(self:getName():capitalize(), eff.target:getName()) end,
	type = "other",
	subtype = { },
	no_stop_enter_worlmap = true, cancel_on_level_change = true,
	status = "beneficial",
	parameters = { },
	activate = function(self, eff, ed)
		eff.src = self

		-- hate
		if eff.hateGain and eff.hateGain > 0 then
			eff.hateGainId = self:addTemporaryValue("hate_regen", eff.hateGain)
		end

		-- health
		if eff.constitutionGain and eff.constitutionGain > 0 then
			eff.constitutionGainId = self:addTemporaryValue("inc_stats", { [Stats.STAT_CON] = eff.constitutionGain })
		end
		if eff.lifeRegenGain and eff.lifeRegenGain > 0 then
			eff.lifeRegenGainId = self:addTemporaryValue("life_regen", eff.lifeRegenGain / 2)
		end

		-- power
		if eff.damageGain and eff.damageGain > 0 then
			eff.damageGainId = self:addTemporaryValue("inc_damage", {all=eff.damageGain})
		end

		-- strengths
		if eff.resistGain and eff.resistGain > 0 then
			local gainList = {}
			for id, resist in pairs(eff.target.resists) do
				if resist > 0 and id ~= "all" then
					gainList[id] = eff.resistGain * 0.01 * resist
				end
			end

			eff.resistGainId = self:addTemporaryValue("resists", gainList)
		end

		eff.target:setEffect(eff.target.EFF_FED_UPON, eff.dur, { src = eff.src, target = eff.target, constitutionLoss = -eff.constitutionGain, lifeRegenLoss = -eff.lifeRegenGain, damageLoss = -eff.damageGain, resistLoss = -eff.resistGain })

		ed.updateFeed(self, eff)
	end,
	deactivate = function(self, eff)
		-- hate
		if eff.hateGainId then self:removeTemporaryValue("hate_regen", eff.hateGainId) end

		-- health
		if eff.constitutionGainId then self:removeTemporaryValue("inc_stats", eff.constitutionGainId) end
		if eff.lifeRegenGainId then self:removeTemporaryValue("life_regen", eff.lifeRegenGainId) end

		-- power
		if eff.damageGainId then self:removeTemporaryValue("inc_damage", eff.damageGainId) end

		-- strengths
		if eff.resistGainId then self:removeTemporaryValue("resists", eff.resistGainId) end

		if eff.particles then
			-- remove old particle emitter
			game.level.map:removeParticleEmitter(eff.particles)
			eff.particles = nil
		end

		eff.target:removeEffect(eff.target.EFF_FED_UPON, false, true)
	end,
	updateFeed = function(self, eff)
		local source = eff.src
		local target = eff.target

		if source.dead or target.dead or not game.level:hasEntity(source) or not game.level:hasEntity(target) or not self:canProject(eff.tg, target.x, target.y) then
			source:removeEffect(source.EFF_FEED)
			if eff.particles then
				game.level.map:removeParticleEmitter(eff.particles)
				eff.particles = nil
			end
			return
		end

		-- update particles position
		if not eff.particles or eff.particles.x ~= source.x or eff.particles.y ~= source.y or eff.particles.tx ~= target.x or eff.particles.ty ~= target.y then
			if eff.particles then
				game.level.map:removeParticleEmitter(eff.particles)
			end
			-- add updated particle emitter
			local dx, dy = target.x - source.x, target.y - source.y
			eff.particles = Particles.new("feed_hate", math.max(math.abs(dx), math.abs(dy)), { tx=dx, ty=dy })
			eff.particles.x = source.x
			eff.particles.y = source.y
			eff.particles.tx = target.x
			eff.particles.ty = target.y
			game.level.map:addParticleEmitter(eff.particles)
		end
	end
}

newEffect{
	name = "FED_UPON", image = "effects/fed_upon.png",
	desc = _t"Fed Upon",
	long_desc = function(self, eff) return ("%s is fed upon by %s."):tformat(self:getName():capitalize(), eff.src:getName()) end,
	type = "other",
	subtype = { psychic_drain=true },
	status = "detrimental",
	remove_on_clone = true,
	no_stop_enter_worlmap = true, cancel_on_level_change = true,
	no_remove = true,
	parameters = { },
	activate = function(self, eff)
		-- health
		if eff.constitutionLoss and eff.constitutionLoss < 0 then
			eff.constitutionLossId = self:addTemporaryValue("inc_stats", { [Stats.STAT_CON] = eff.constitutionLoss })
		end
		if eff.lifeRegenLoss and eff.lifeRegenLoss < 0 then
			eff.lifeRegenLossId = self:addTemporaryValue("life_regen", eff.lifeRegenLoss)
		end

		-- power
		if eff.damageLoss and eff.damageLoss < 0 then
			eff.damageLossId = self:addTemporaryValue("inc_damage", {all=eff.damageLoss})
		end

		-- strengths
		if eff.resistLoss and eff.resistLoss < 0 then
			local lossList = {}
			for id, resist in pairs(self.resists) do
				if resist > 0 and id ~= "all" then
					lossList[id] = eff.resistLoss * 0.01 * resist
				end
			end

			eff.resistLossId = self:addTemporaryValue("resists", lossList)
		end
	end,
	deactivate = function(self, eff)
		-- health
		if eff.constitutionLossId then self:removeTemporaryValue("inc_stats", eff.constitutionLossId) end
		if eff.lifeRegenLossId then self:removeTemporaryValue("life_regen", eff.lifeRegenLossId) end

		-- power
		if eff.damageLossId then self:removeTemporaryValue("inc_damage", eff.damageLossId) end

		-- strengths
		if eff.resistLossId then self:removeTemporaryValue("resists", eff.resistLossId) end

		if eff.target == self and eff.src:hasEffect(eff.src.EFF_FEED) then
			eff.src:removeEffect(eff.src.EFF_FEED)
		end
	end,
	on_timeout = function(self, eff)
		-- no_remove prevents targets from dispelling feeding, make sure this gets removed if something goes wrong
		if eff.dur <= 0 or eff.src.dead then
			self:removeEffect(eff.src.EFF_FED_UPON, false, true)
		end
	end,
}

newEffect{
	name = "LICH_HUNGER", image = "talents/lichform.png",
	desc = _t"Lich Hunger",
	long_desc = function(self, eff) return _t"To complete your resurrection you must kill a unique/boss/elite boss rank creature before the duration expires." end,
	type = "other",
	subtype = { lich = true },
	status = "neutral",
	parameters = { },
	callbackOnSummonKill = function(self, eff, minion, who, death_note)
		if who.rank >= 3.5 then
			eff.success = true
			self:removeEffect(self.EFF_LICH_HUNGER)
			game.bignews:say(120, "#DARK_ORCHID#Lichform regeneration is complete!#{normal}#")
		end
	end,
	callbackOnKill = function(self, eff, who, death_note)
		if who.rank >= 3.5 then
			eff.success = true
			self:removeEffect(self.EFF_LICH_HUNGER)
			game.bignews:say(120, "#DARK_ORCHID#Lichform regeneration is complete!#{normal}#")
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "lich_hunger", 1)
	end,
	deactivate = function(self, eff)
		if eff.success then return end
		self.lich_no_more_regen = true
		self:die(self, {special_death_msg="failed to complete the lich ressurection ritual"})
	end,
}

newEffect{
	name = "OMNIVISION", image = "talents/track.png",
	desc = _t"Sensing Everything",
	long_desc = function(self, eff) return _t"Improves senses, allowing the detection of everything." end,
	type = "other",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { range=10,},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "omnivision", eff.range)
		game.level.map.changed = true
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "DOZING", image = "talents/sleep.png",
	desc = _t"Dozing",
	long_desc = function(self, eff) return _t"The target is completely asleep, unable to act." end,
	type = "otber",
	subtype = { sleep=true },
	status = "detrimental",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "dont_act", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MIRROR_IMAGE_REAL", image = "talents/mirror_images.png",
	desc = _t"Protected by a Mirror Image",
	long_desc = function(self, eff) return ("Target is protected by a mirror image. Increases damage dealt to blind or dazzled creatures by %d%%"):tformat(eff.dam) end,
	type = "other",
	subtype = { phantasm=true },
	status = "beneficial", decrease = 0,
	cancel_on_level_change = true,
	parameters = { dam=10 },
	callbackOnTalentPost = function(self, eff, ab, ret, silent)
		if ab.id == self.T_MIRROR_IMAGES then return end
		if not ab.is_spell or ab.is_inscription then return end
		if ab.mode ~= "activated" then return end
		if not ret then return end
		local x, y, tgt = self:getTarget()
		if not tgt or not ab.requires_target then return end
		if eff.image:attr("dead") or not game.level:hasEntity(eff.image) then return end

		pcall(function() -- Just in case
			eff.image:forceUseTalent(ab.id, {force_level=self:getTalentLevelRaw(ab.id), ignore_cd=true, no_talent_fail=true, ignore_energy=true, force_talent_ignore_ressources=true, force_target=tgt})
			-- eff.image:takeHit(1, eff.image)
			eff.image:useCharge()
		end)

		eff.last_talent = true
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "blind_inc_damage", eff.dam)
	end,
}

newEffect{
	name = "MIRROR_IMAGE_FAKE", image = "talents/mirror_images.png",
	desc = _t"Protected by a Mirror Image",
	long_desc = function(self, eff) return ("Target is protected by a mirror image. Increases damage dealt to blind or dazzled creatures by %d%%"):tformat(eff.dam) end,
	type = "other",
	subtype = { phantasm=true },
	status = "beneficial", decrease = 0,
	cancel_on_level_change = true,
	parameters = { dam=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "blind_inc_damage", eff.dam)	
		eff.out_of_combat = 5
	end,
	on_timeout = function(self, eff)
		if not self.in_combat then
			eff.out_of_combat = eff.out_of_combat - 1
			if eff.out_of_combat <= 0 then
				self:die(self)
			end
		end
	end,
}

newEffect{
	name = "AETHER_PERMEATION", image = "talents/aether_permeation.png",
	desc = _t"Aether Permeation",
	long_desc = function(self, eff) return ("Target is protected from dispels"):tformat() end,
	type = "other",
	subtype = { prodigy=true, arcane=true },
	status = "beneficial",
	parameters = { },
	callbackPriorities={callbackOnDispel = -9999999}, -- Never set anything lower heh, it should trigger before anything else
	callbackOnDispel = function(self, t, type, effid_or_tid, src, allow_immunity, name)
		if not allow_immunity then return false end
		game.logSeen(self, "#ORCHID#Aether Permeation protects %s from a dispel!", name)
		return true
	end,
}

newEffect{
	name = "BLOOD_RUSH_MARK", image = "talents/blood_rush.png",
	desc = _t"Marked for Death",
	long_desc = function(self, eff) return ("Reduces Blood Rush cooldown if killed"):tformat() end,
	type = "other",
	subtype = { status=true, },
	status = "detrimental",
	parameters = { },
	activate = function(self, eff) 
		eff.particle = self:addParticles(Particles.new("circle", 1, {base_rot=1, oversize=1.0, a=200, appear=8, speed=0, img="blood_rush_mark", radius=0}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	callbackOnDeath = function(self, eff, src, note)
		marker = eff.src
		reduc = eff.dur * 2
		local tid = marker.T_BLOOD_RUSH
		if marker.talents_cd[tid] then
			marker.talents_cd[tid] = marker.talents_cd[tid] - reduc
		end
	end,
}

newEffect{
	name = "LIGHTS_OUT", image = "talents/final_sunbeam.png",
	desc = _t"Lights Out",
	long_desc = function(self, eff) return _t"The target is cut off from the sun" end,
	type = "other",
	subtype = { magic=true },
	status = "detrimental",
	parameters = { },
	callbackOnActBase = function(self, t)
		self:incPositive(-1 * self:getPositive())
	end,
	activate = function(self, eff) end,
	deactivate = function(self, eff) end,
}


newEffect{
	name = "SELF_JUDGEMENT", image = "talents/self_judgement.png",
	desc = _t"Self-Judgement",
	long_desc = function(self, eff) return ("Your body is bleeding, losing %0.2f life each turn."):tformat(eff.power) end,
	type = "other",
	subtype = { bleed=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#CRIMSON##Target# is torn open by the powerful blow!", _t"+Self-Judgement" end,
	on_lose = function(self, err) return _t"#CRIMSON##Target#'s wound has closed.", _t"-Self-Judgement" end,
	on_merge = function(self, old_eff, new_eff)
		local remaining = old_eff.dur*old_eff.power
		old_eff.dur = new_eff.dur
		old_eff.power = remaining/(new_eff.dur or 1) + new_eff.power
		return old_eff
	end,
	activate = function(self, eff) end,
	deactivate = function(self, eff) end,
	on_timeout = function(self, eff)
		if eff.invulnerable then
			eff.dur = eff.dur + 1
			return
		end
		local dead, val = self:takeHit(eff.power, self, {special_death_msg="died a well-deserved death by exsanguination"})
		
		local srcname = self.x and self.y and game.level.map.seens(self.x, self.y) and self.name:capitalize() or "Something"
		game:delayedLogDamage(eff, self, val, ("#CRIMSON#%d Bleed #LAST#"):tformat(math.ceil(val)), false)
	end,
}
