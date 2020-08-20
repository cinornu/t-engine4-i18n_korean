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
local Astar = require "engine.Astar"

-- Item specific
newEffect{
	name = "ITEM_EXPOSED", image = "talents/curse_of_the_meek.png",  -- Re-used icon
	desc = _t"Exposed",
	long_desc = function(self, eff) return ("Mind and body exposed to effects and attacks, reducing all saves and defense by %d."):tformat(eff.reduce) end,
	charges = function(self, eff) return (tostring(math.floor(eff.reduce))) end,
	type = "mental",
	subtype = { },
	status = "detrimental",
	parameters = {reduce=0},
	on_gain = function(self, err) return _t"#Target#'s is vulnerable to attacks and effects!" end,
	on_lose = function(self, err) return _t"#Target# is less vulnerable." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physresist", -eff.reduce)
		self:effectTemporaryValue(eff, "combat_spellresist", -eff.reduce)
		self:effectTemporaryValue(eff, "combat_mentalresist", -eff.reduce)
		self:effectTemporaryValue(eff, "combat_def", -eff.reduce)
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "ITEM_NUMBING_DARKNESS", image = "effects/bane_blinded.png",
	desc = _t"Numbing Darkness",
	long_desc = function(self, eff) return ("The target is losing hope, all damage it does is reduced by %d%%."):tformat(eff.reduce) end,
	charges = function(self, eff) return (tostring(math.floor(eff.reduce))) end,
	type = "mental",
	subtype = { darkness=true,}, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return _t"#Target# is weakened by the darkness!", _t"+Numbing Darkness" end,
	on_lose = function(self, err) return _t"#Target# regains their energy.", _t"-Numbing Darkness" end,
	on_timeout = function(self, eff)

	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

newEffect{
	name = "SILENCED", image = "effects/silenced.png",
	desc = _t"Silenced",
	long_desc = function(self, eff) return _t"The target is silenced, preventing it from casting spells and using some vocal talents." end,
	type = "mental",
	subtype = { silence=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is silenced!", _t"+Silenced" end,
	on_lose = function(self, err) return _t"#Target# is not silenced anymore.", _t"-Silenced" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("silence", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("silence", eff.tmpid)
	end,
}

newEffect{
	name = "SUMMON_CONTROL", image = "talents/summon_control.png", --Backwards compatibility
	desc = _t"Pheromones",
	long_desc = function(self, eff) return ("The target has been marked as the focus for all nature summons within %d radius, receiving %d%% increased damage from nature summons."):tformat(eff.range, eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "detrimental",
	parameters = { power = 10 },
	on_gain = function(self, err) return _t"Summons flock towards #Target#.", true end,
	on_lose = function(self, err) return _t"#Target# is no longer being targeted by summons.", true end,
	on_timeout = function(self, eff)
		self:project({type="ball", range=0, friendlyfire=false, radius=eff.range}, self.x, self.y, function(px, py)
		local target = game.level.map(px, py, Map.ACTOR)
		if not target then return end
		if target.summoner == eff.src then
			target:setTarget(self)
		end
		end)
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_nature_summon", eff.power)

		self:project({type="ball", range=0, friendlyfire=false, radius=eff.range}, self.x, self.y, function(px, py)
		local target = game.level.map(px, py, Map.ACTOR)
		if not target then return end
		if target.summoner == eff.src then
			target:setTarget(self)
		end
		end)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CONFUSED", image = "effects/confused.png",
	desc = _t"Confused",
	long_desc = function(self, eff) return ("The target is confused, acting randomly (chance %d%%) and unable to perform complex actions."):tformat(eff.power) end,
	charges = function(self, eff) return (tostring(math.floor(eff.power)).."%") end,
	type = "mental",
	subtype = { confusion=true },
	status = "detrimental",
	parameters = { power=30 },
	on_gain = function(self, err) return _t"#Target# wanders around!", _t"+Confused" end,
	on_lose = function(self, err) return _t"#Target# seems more focused.", _t"-Confused" end,
	activate = function(self, eff)
		eff.power = math.floor(util.bound(eff.power, 0, 50))
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
		if eff.power <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "DOMINANT_WILL", image = "talents/yeek_will.png",
	desc = _t"Mental Domination",
	long_desc = function(self, eff) return ("The target's mind has been shattered. Its body remains as a thrall to %s."):tformat(eff.src:getName():capitalize()) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#Target#'s mind is shattered." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=-15})
		self.ai_state = self.ai_state or {}
		eff.oldstate = {
			faction = self.faction,
			ai_state = table.clone(self.ai_state, true),
			remove_from_party_on_death = self.remove_from_party_on_death,
			no_inventory_access = self.no_inventory_access,
			move_others = self.move_others,
			summoner = self.summoner,
			summoner_gain_exp = self.summoner_gain_exp,
			ai = self.ai,
		}
		self.faction = eff.src.faction

		self.ai_state.tactic_leash = 100
		self.remove_from_party_on_death = true
		self.no_inventory_access = true
		self.move_others = true
		self.summoner = eff.src
		self.summoner_gain_exp = true
		if self.dead then return end
		game:onTickEnd(function()
			game.party:addMember(self, {
				control="full",
				type="thrall",
				title=_t"Thrall",
				orders = {leash=true, follow=true},
				on_control = function(self)
					self:hotkeyAutoTalents()
				end,
				leave_level = function(self, party_def) -- Cancel control and restore previous actor status.
					local eff = self:hasEffect(self.EFF_DOMINANT_WILL)
					if not eff then return end
					local uid = self.uid
					eff.survive_domination = true
					self:removeTemporaryValue("inc_damage", eff.pid)
					game.party:removeMember(self)
					self:replaceWith(require("mod.class.NPC").new(self))
					self.uid = uid
					__uids[uid] = self
					self.faction = eff.oldstate.faction
					self.ai_state = eff.oldstate.ai_state
					self.ai = eff.oldstate.ai
					self.remove_from_party_on_death = eff.oldstate.remove_from_party_on_death
					self.no_inventory_access = eff.oldstate.no_inventory_access
					self.move_others = eff.oldstate.move_others
					self.summoner = eff.oldstate.summoner
					self.summoner_gain_exp = eff.oldstate.summoner_gain_exp
					self:removeEffect(self.EFF_DOMINANT_WILL)
				end,
			})
		end)
	end,
	deactivate = function(self, eff)
		if eff.survive_domination then
			game.logSeen(self, "%s's mind recovers from the domination.",self:getName():capitalize())
		else
			game.logSeen(self, "%s collapses.",self:getName():capitalize())
			self:die(eff.src)
		end
	end,
}

newEffect{
	name = "DOMINANT_WILL_BOSS", image = "talents/yeek_will.png",
	desc = _t"Mental Domination",
	long_desc = function(self, eff) return ("The target's mind has been shaken. It is temporarily aligned with %s and immune to all damage."):tformat(eff.src:getName():capitalize()) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#Target#'s mind is dominated.", _t"+Dominant Will" end,
	on_lose = function(self, err) return _t"#Target# is free from the domination.",  "-Dominant Will"  end,
	activate = function(self, eff)
		self:setTarget() -- clear ai target
		eff.old_faction = self.faction
		self.faction = eff.src.faction
		self:effectTemporaryValue(eff, "never_anger", 1)
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "hostile_for_level_change", 1)
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self.faction = eff.old_faction
		self:setTarget(eff.src)
	end,
}

newEffect{
	name = "BATTLE_SHOUT", image = "talents/battle_shout.png",
	desc = _t"Battle Shout",
	long_desc = function(self, eff) return ("Increases maximum life and stamina by %d%%. When the effect ends, the extra life and stamina will be lost."):tformat(eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		local lifeb = self.max_life * eff.power/100
		local stamb = self.max_stamina * eff.power/100
		eff.max_lifeID = self:addTemporaryValue("max_life", lifeb) --Avoid healing effects
		eff.lifeID = self:addTemporaryValue("life",lifeb)
		eff.max_stamina = self:addTemporaryValue("max_stamina", stamb)
		self:incStamina(stamb)
		eff.stamina = stamb
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("life", eff.lifeID)
		self:removeTemporaryValue("max_life", eff.max_lifeID)
		self:removeTemporaryValue("max_stamina", eff.max_stamina)
		self:incStamina(-eff.stamina)
	end,
}

newEffect{
	name = "BATTLE_CRY", image = "talents/battle_cry.png",
	desc = _t"Battle Cry",
	long_desc = function(self, eff) return ("The target's will to defend itself is shattered by the powerful battle cry, reducing defense by %d."):tformat(eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target#'s will is shattered.", _t"+Battle Cry" end,
	on_lose = function(self, err) return _t"#Target# regains some of its will.", _t"-Battle Cry" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
		self:effectTemporaryValue(eff, "no_evasion", 1)
		self:effectTemporaryValue(eff, "blind_fighted", 1)
	end,
}

newEffect{
	name = "WILLFUL_COMBAT", image = "talents/willful_combat.png",
	desc = _t"Willful Combat",
	long_desc = function(self, eff) return ("The target puts all its willpower into its blows, improving physical power by %d."):tformat(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# lashes out with pure willpower." end,
	on_lose = function(self, err) return _t"#Target#'s willpower rush ends." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "GLOOM_WEAKNESS", image = "effects/gloom_weakness.png",
	desc = _t"Gloom Weakness",
	long_desc = function(self, eff) return ("The gloom reduces damage the target inflicts by %d%%."):tformat(eff.incDamageChange) end,
	type = "mental",
	subtype = { gloom=true },
	status = "detrimental",
	parameters = { atk=10, dam=10 },
	on_gain = function(self, err) return _t"#F53CBE##Target# is weakened by the gloom." end,
	on_lose = function(self, err) return _t"#F53CBE##Target# is no longer weakened." end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_weakness", 1))
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all = -eff.incDamageChange})
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "GLOOM_SLOW", image = "effects/gloom_slow.png",
	desc = _t"Slowed by the gloom",
	long_desc = function(self, eff) return ("The gloom reduces the target's global speed by %d%%."):tformat(eff.power * 100) end,
	type = "mental",
	subtype = { gloom=true, slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#F53CBE##Target# moves reluctantly!", _t"+Slow" end,
	on_lose = function(self, err) return _t"#Target# overcomes the gloom.", _t"-Slow" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_slow", 1))
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "GLOOM_STUNNED", image = "effects/gloom_stunned.png",
	desc = _t"Stunned by the gloom",
	long_desc = function(self, eff) return ("The gloom has stunned the target, reducing damage by 50%%, putting 4 random talents on cooldown and reducing movement speed by 50%%.  While stunned talents cooldown twice as slow."):tformat() end,
	type = "mental",
	subtype = { gloom=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# is stunned with fear!", _t"+Stunned" end,
	on_lose = function(self, err) return _t"#Target# overcomes the gloom", _t"-Stunned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "GLOOM_CONFUSED", image = "effects/gloom_confused.png",
	desc = _t"Confused by the gloom",
	long_desc = function(self, eff) return ("The gloom has confused the target, making it act randomly (%d%% chance) and unable to perform complex actions."):tformat(eff.power) end,
	type = "mental",
	charges = function(self, eff) return (tostring(eff.power).."%") end,
	subtype = { gloom=true, confusion=true },
	status = "detrimental",
	parameters = { power = 10 },
	on_gain = function(self, err) return _t"#F53CBE##Target# is lost in despair!", _t"+Confused" end,
	on_lose = function(self, err) return _t"#Target# overcomes the gloom", _t"-Confused" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_confused", 1))
		eff.power = math.floor(util.bound(eff.power, 0, 50))
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
		if eff.power <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player then self:updateMainShader() end
	end,
}

newEffect{
	name = "DISMAYED", image = "talents/dismay.png",
	desc = _t"Dismayed",
	long_desc = function(self, eff) return (_t"The target is dismayed. The next melee attack against the target will be a guaranteed critical hit.") end,
	type = "mental",
	subtype = { gloom=true, confusion=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# is dismayed!", _t"+Dismayed" end,
	on_lose = function(self, err) return _t"#Target# overcomes the dismay", _t"-Dismayed" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("dismayed", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "STALKER", image = "talents/stalk.png",
	desc = _t"Stalking",
	display_desc = function(self, eff)
		return ([[Stalking %d/%d +%d ]]):tformat(eff.target.life, eff.target.max_life, eff.bonus)
	end,
	long_desc = function(self, eff)
		local t = self:getTalentFromId(self.T_STALK)
		local effStalked = eff.target:hasEffect(eff.target.EFF_STALKED)
		local desc = ([[Stalking %s. Bonus level %d: +%d accuracy, +%d%% melee damage, +%0.2f hate/turn prey was hit.]]):tformat(
			eff.target.name, eff.bonus, t.getAttackChange(self, t, eff.bonus), t.getStalkedDamageMultiplier(self, t, eff.bonus) * 100 - 100, t.getHitHateChange(self, t, eff.bonus))
		if effStalked and effStalked.damageChange and effStalked.damageChange > 0 then
			desc = desc..("Prey damage modifier: %d%%."):tformat(effStalked.damageChange)
		end
		return desc
	end,
	type = "mental",
	subtype = { veil=true },
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		self:logCombat(eff.target, "#F53CBE##Target# is being stalked by #Source#!")
	end,
	deactivate = function(self, eff)
		self:logCombat(eff.target, "#F53CBE##Target# is no longer being stalked by #Source#.")
	end,
	on_timeout = function(self, eff)
		if not eff.target or eff.target.dead or not eff.target:hasEffect(eff.target.EFF_STALKED) then
			self:removeEffect(self.EFF_STALKER)
		end
	end,
}

newEffect{
	name = "STALKED", image = "effects/stalked.png",
	desc = _t"Stalked",
	long_desc = function(self, eff)
		local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
		if not effStalker then return _t"Being stalked." end
		local t = self:getTalentFromId(eff.src.T_STALK)
		local desc = ([[Being stalked by %s. Stalker bonus level %d: +%d accuracy, +%d%% melee damage, +%0.2f hate/turn prey was hit.]]):tformat(
			eff.src:getName(), effStalker.bonus, t.getAttackChange(eff.src, t, effStalker.bonus), t.getStalkedDamageMultiplier(eff.src, t, effStalker.bonus) * 100 - 100, t.getHitHateChange(eff.src, t, effStalker.bonus))
		if eff.damageChange and eff.damageChange > 0 then
			desc = desc..(" Prey damage modifier: %d%%."):tformat(eff.damageChange)
		end
		return desc
	end,
	type = "mental",
	subtype = { veil=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, cancel_on_level_change = true,
	parameters = {},
	activate = function(self, eff)
		local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
		if not effStalker then game:onTickEnd(function() self:removeEffect(self.EFF_STALKED, true, true) end) return end
		eff.particleBonus = effStalker.bonus
		eff.particle = self:addParticles(Particles.new("stalked", 1, { bonus = eff.particleBonus }))
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		if eff.damageChangeId then self:removeTemporaryValue("inc_damage", eff.damageChangeId) end
	end,
	on_timeout = function(self, eff)
		if not eff.src or eff.src.dead or not eff.src:hasEffect(eff.src.EFF_STALKER) then
			self:removeEffect(self.EFF_STALKED)
		else
			local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
			if eff.particleBonus ~= effStalker.bonus then
				eff.particleBonus = effStalker.bonus
				self:removeParticles(eff.particle)
				eff.particle = self:addParticles(Particles.new("stalked", 1, { bonus = eff.particleBonus }))
			end
		end
	end,
	updateDamageChange = function(self, eff)
		if eff.damageChangeId then
			self:removeTemporaryValue("inc_damage", eff.damageChangeId)
			eff.damageChangeId = nil
		end
		if eff.damageChange and eff.damageChange > 0 then
			eff.damageChangeId = eff.target:addTemporaryValue("inc_damage", {all=eff.damageChange})
		end
	end,
}

newEffect{
	name = "BECKONED", image = "talents/beckon.png",
	desc = _t"Beckoned",
	long_desc = function(self, eff)
		local message = ("The target has been beckoned by %s and is heeding the call. There is a %d%% chance of moving towards the beckoner each turn."):tformat(eff.src:getName(), eff.chance)
		if eff.spellpowerChangeId and eff.mindpowerChangeId then
			message = message..(" (spellpower: %d, mindpower: %d"):tformat(eff.spellpowerChange, eff.mindpowerChange)
		end
		return message
	end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = { speedChange=0.5 },
	on_gain = function(self, err) return _t"#Target# has been beckoned.", _t"+Beckoned" end,
	on_lose = function(self, err) return _t"#Target# is no longer beckoned.", _t"-Beckoned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("beckoned", 1))

		eff.spellpowerChangeId = self:addTemporaryValue("combat_spellpower", eff.spellpowerChange)
		eff.mindpowerChangeId = self:addTemporaryValue("combat_mindpower", eff.mindpowerChange)
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end

		if eff.spellpowerChangeId then
			self:removeTemporaryValue("combat_spellpower", eff.spellpowerChangeId)
			eff.spellpowerChangeId = nil
		end
		if eff.mindpowerChangeId then
			self:removeTemporaryValue("combat_mindpower", eff.mindpowerChangeId)
			eff.mindpowerChangeId = nil
		end
	end,
	on_timeout = function(self, eff)
	end,
	do_act = function(self, eff)
		if eff.src.dead then
			self:removeEffect(self.EFF_BECKONED)
			return
		end
		if not self:enoughEnergy() then return nil end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.chance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the beckoning.", self:getName():capitalize())
		else
			eff.timer = eff.timer + eff.chance
		end

		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local distance = self.x and eff.src.x and core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) or 1000
			if math.floor(distance) > 1 and distance <= eff.range then
				-- in range but not adjacent

				-- add debuffs
				if not eff.spellpowerChangeId then eff.spellpowerChangeId = self:addTemporaryValue("combat_spellpower", eff.spellpowerChange) end
				if not eff.mindpowerChangeId then eff.mindpowerChangeId = self:addTemporaryValue("combat_mindpower", eff.mindpowerChange) end

				-- custom pull logic (adapted from move_dmap; forces movement, pushes others aside, custom particles)

				if not self:attr("never_move") then
					local source = eff.src
					local moveX, moveY = source.x, source.y -- move in general direction by default
					if not self:hasLOS(source.x, source.y) then
						local a = Astar.new(game.level.map, self)
						local path = a:calc(self.x, self.y, source.x, source.y)
						if path then
							moveX, moveY = path[1].x, path[1].y
						end
					end

					if moveX and moveY then
						local old_move_others, old_x, old_y = self.move_others, self.x, self.y
						self.move_others = true
						local old = rawget(self, "aiCanPass")
						self.aiCanPass = mod.class.NPC.aiCanPass
						mod.class.NPC.moveDirection(self, moveX, moveY, false)
						self.aiCanPass = old
						self.move_others = old_move_others
						if old_x ~= self.x or old_y ~= self.y then
							game.level.map:particleEmitter(self.x, self.y, 1, "beckoned_move", {power=power, dx=self.x - source.x, dy=self.y - source.y})
						end
					end
				end
			else
				-- adjacent or out of range..remove debuffs
				if eff.spellpowerChangeId then
					self:removeTemporaryValue("combat_spellpower", eff.spellpowerChangeId)
					eff.spellpowerChangeId = nil
				end
				if eff.mindpowerChangeId then
					self:removeTemporaryValue("combat_mindpower", eff.mindpowerChangeId)
					eff.mindpowerChangeId = nil
				end
			end
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		eff.resistChance = (eff.resistChance or 0) + math.min(100, math.max(0, dam / self.max_life * 100))
		if rng.percent(eff.resistChance) then
			game.logSeen(self, "#F53CBE#%s is jolted to attention by the damage and is no longer being beckoned.", self:getName():capitalize())
			self:removeEffect(self.EFF_BECKONED)
		end

		return dam
	end,
}

newEffect{
	name = "OVERWHELMED", image = "talents/frenzy.png",
	desc = _t"Overwhelmed",
	long_desc = function(self, eff) return ("The target has been overwhemed by a furious assault, reducing defence by %d."):tformat( -eff.defenseChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { damageChange=0.1 },
	on_gain = function(self, err) return _t"#Target# has been overwhelmed.", _t"+Overwhelmed" end,
	on_lose = function(self, err) return _t"#Target# is no longer overwhelmed.", _t"-Overwhelmed" end,
	parameters = { chance=5 },
	activate = function(self, eff)
		eff.defenseChangeId = self:addTemporaryValue("combat_def", -eff.defenseChange)
		eff.particle = self:addParticles(Particles.new("overwhelmed", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defenseChangeId)
		self:removeParticles(eff.particle)
 end,
}


newEffect{
	name = "CURSED_MIASMA", image = "talents/savage_hunter.png",
	desc = _t"Cursed Miasma",
	long_desc = function(self, eff) return ("The target is enveloped in a cursed miasma."):tformat(eff.sight) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { chance=5 },
	on_gain = function(self, err) return _t"#Target# is surrounded by a cursed miasma.", _t"+Cursed Miasma" end,
	on_lose = function(self, err) return _t"The cursed miasma around #target# dissipates.", _t"-Cursed Miasma" end,
	activate = function(self, eff)
		self:setTarget(nil) -- Reset target to grab a random new one
		self:effectTemporaryValue(eff, "hates_everybody", 1)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="shadow_shot_debuff_tentacles"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "HARASSED", image = "talents/harass_prey.png",
	desc = _t"Harassed",
	long_desc = function(self, eff) return ("The target has been harassed by its stalker, reducing damage by %d%%."):tformat( -eff.damageChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { damageChange=0.1 },
	on_gain = function(self, err) return _t"#Target# has been harassed.", _t"+Harassed" end,
	on_lose = function(self, err) return _t"#Target# is no longer harassed.", _t"-Harassed" end,
	activate = function(self, eff)
		eff.damageChangeId = self:addTemporaryValue("inc_damage", {all=eff.damageChange})
		eff.particle = self:addParticles(Particles.new("harassed", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.damageChangeId)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "DOMINATED", image = "talents/dominate.png",
	desc = _t"Dominated",
	long_desc = function(self, eff) return ("The target has been dominated.  It is unable to move and has lost %d armor and %d defense. Attacks from %s gain %d%% damage penetration."):tformat(-eff.armorChange, -eff.defenseChange, eff.src:getName():capitalize(), eff.resistPenetration) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	on_gain = function(self, err) return _t"#F53CBE##Target# has been dominated!", _t"+Dominated" end,
	on_lose = function(self, err) return _t"#F53CBE##Target# is no longer dominated.", _t"-Dominated" end,
	parameters = { armorChange = -3, defenseChange = -3, physicalResistChange = -0.1 },
	activate = function(self, eff)
		eff.neverMoveId = self:addTemporaryValue("never_move", 1)
		eff.armorId = self:addTemporaryValue("combat_armor", eff.armorChange)
		eff.defenseId = self:addTemporaryValue("combat_def", eff.armorChange)

		eff.particle = self:addParticles(Particles.new("dominated", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.neverMoveId)
		self:removeTemporaryValue("combat_armor", eff.armorId)
		self:removeTemporaryValue("combat_def", eff.defenseId)

		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "AGONY", image = "talents/agony.png",
	desc = _t"Agony",
	long_desc = function(self, eff) return ("%s is writhing in agony, suffering from %d to %d damage over %d turns."):tformat(self:getName():capitalize(), eff.damage / eff.duration, eff.damage, eff.duration) end,
	type = "mental",
	subtype = { pain=true, psionic=true },
	status = "detrimental",
	parameters = { damage=10, mindpower=10, range=10, minPercent=10 },
	on_gain = function(self, err) return _t"#Target# is writhing in agony!", _t"+Agony" end,
	on_lose = function(self, err) return _t"#Target# is no longer writhing in agony.", _t"-Agony" end,
	activate = function(self, eff)
		eff.power = 0
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
	on_timeout = function(self, eff)
		eff.turn = (eff.turn or 0) + 1

		local damage = math.floor(eff.damage * (eff.turn / eff.duration))
		if damage > 0 then
			DamageType:get(DamageType.MIND).projector(eff.src, self.x, self.y, DamageType.MIND, { dam=damage, crossTierChance=25 })
			game:playSoundNear(self, "talents/fire")
		end

		if self.dead then
			if eff.particle then self:removeParticles(eff.particle) end
			return
		end

		if eff.particle then self:removeParticles(eff.particle) end
		eff.particle = nil
		eff.particle = self:addParticles(Particles.new("agony", 1, { power = 5 * eff.turn / eff.duration }))
	end,
}

newEffect{
	name = "HATEFUL_WHISPER", image = "talents/hateful_whisper.png",
	desc = _t"Hateful Whisper",
	long_desc = function(self, eff) return ("%s has heard the hateful whisper."):tformat(self:getName():capitalize()) end,
	type = "mental",
	subtype = { madness=true, psionic=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return _t"#Target# has heard the hateful whisper!", _t"+Hateful Whisper" end,
	on_lose = function(self, err) return _t"#Target# no longer hears the hateful whisper.", _t"-Hateful Whisper" end,
	activate = function(self, eff)
		if not eff.src.dead and eff.src:knowTalent(eff.src.T_HATE_POOL) then
			eff.src:incHate(eff.hateGain)
		end
		DamageType:get(DamageType.MIND).projector(eff.src, self.x, self.y, DamageType.MIND, { dam=eff.damage, crossTierChance=25 })

		if self.dead then
			-- only spread on activate if the target is dead
			if eff.jumpCount > 0 then
				eff.jumpCount = eff.jumpCount - 1
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			end
		else
			eff.particle = self:addParticles(Particles.new("hateful_whisper", 1, { }))
		end

		game:playSoundNear(self, "talents/fire")

		eff.firstTurn = true
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
	on_timeout = function(self, eff)
		if self.dead then return false end

		if eff.firstTurn then
			-- pause a turn before infecting others
			eff.firstTurn = false
		elseif eff.jumpDuration > 0 then
			-- limit the total duration of all spawned effects
			eff.jumpDuration = eff.jumpDuration - 1

			if eff.jumpCount > 0 then
				-- guaranteed jump
				eff.jumpCount = eff.jumpCount - 1
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			elseif rng.percent(eff.jumpChance) then
				-- per turn chance of a jump
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			end
		end
	end,
	doSpread = function(self, eff)
		local targets = {}
		local grids = core.fov.circle_grids(self.x, self.y, eff.jumpRange, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, game.level.map.ACTOR)
				if a and eff.src:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
					if not a:hasEffect(a.EFF_HATEFUL_WHISPER) then
						targets[#targets+1] = a
					end
				end
			end
		end

		if #targets > 0 then
			local target = rng.table(targets)
			target:setEffect(target.EFF_HATEFUL_WHISPER, eff.duration, {
				src = eff.src,
				duration = eff.duration,
				damage = eff.damage,
				mindpower = eff.mindpower,
				jumpRange = eff.jumpRange,
				jumpCount = 0, -- secondary effects do not get automatic spreads
				jumpChance = eff.jumpChance,
				jumpDuration = eff.jumpDuration,
				hateGain = eff.hateGain
			})

			game.level.map:particleEmitter(target.x, target.y, 1, "reproach", { dx = self.x - target.x, dy = self.y - target.y })
		end
	end,
}

newEffect{
	name = "MADNESS_SLOW", image = "effects/madness_slowed.png",
	desc = _t"Slowed by madness",
	long_desc = function(self, eff) return ("Madness reduces the target's global speed by %d%% and lowers mind resistance by %d%%."):tformat(eff.power * 100, -eff.mindResistChange) end,
	type = "mental",
	subtype = { madness=true, slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#F53CBE##Target# slows in the grip of madness!", _t"+Slow" end,
	on_lose = function(self, err) return _t"#Target# overcomes the madness.", _t"-Slow" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_slow", 1))
		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "MADNESS_STUNNED", image = "effects/madness_stunned.png",
	desc = _t"Stunned by madness",
	long_desc = function(self, eff) return ("Madness has stunned the target, reducing damage by 50%%, lowering mind resistance by %d%%, putting 4 random talents on cooldown and reducing movement speed by 50%%.  While stunned talents cooldown twice as slow."):tformat(eff.mindResistChange) end,
	type = "mental",
	subtype = { madness=true, stun=true },
	status = "detrimental",
	parameters = {mindResistChange = -10},
	on_gain = function(self, err) return _t"#F53CBE##Target# is stunned by madness!", _t"+Stunned" end,
	on_lose = function(self, err) return _t"#Target# overcomes the madness", _t"-Stunned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))

		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)

		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "MADNESS_CONFUSED", image = "effects/madness_confused.png",
	desc = _t"Confused by madness",
	long_desc = function(self, eff) return ("Madness has confused the target, lowering mind resistance by %d%% and making it act randomly (%d%% chance)"):tformat(eff.mindResistChange, eff.power) end,
	type = "mental",
	subtype = { madness=true, confusion=true, power=50 },
	status = "detrimental",
	charges = function(self, eff) return (tostring(eff.power).."%") end,
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#F53CBE##Target# is lost in madness!", _t"+Confused" end,
	on_lose = function(self, err) return _t"#Target# overcomes the madness", _t"-Confused" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_confused", 1))
		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.power = math.floor(util.bound(eff.power, 0, 50))
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "MALIGNED", image = "talents/getsture_of_malice.png",
	desc = _t"Maligned",
	long_desc = function(self, eff) return ("The target is under a malign influence. All resists have been lowered by %d%%."):tformat(-eff.resistAllChange) end,
	type = "mental",
	subtype = { curse=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# has been maligned!", _t"+Maligned" end,
	on_lose = function(self, err) return _t"#Target# is no longer maligned", _t"-Maligned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("maligned", 1))
		eff.resistAllChangeId = self:addTemporaryValue("resists", { all=eff.resistAllChange })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistAllChangeId)
		self:removeParticles(eff.particle)
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
}

local function updateFearParticles(self)
	local hasParticles = false
	if self:hasEffect(self.EFF_PARANOID) then hasParticles = true end
	if self:hasEffect(self.EFF_DISPAIR) then hasParticles = true end
	if self:hasEffect(self.EFF_TERRIFIED) then hasParticles = true end
	if self:hasEffect(self.EFF_DISTRESSED) then hasParticles = true end
	if self:hasEffect(self.EFF_HAUNTED) then hasParticles = true end
	if self:hasEffect(self.EFF_TORMENTED) then hasParticles = true end

	if not self.fearParticlesId and hasParticles then
		self.fearParticlesId = self:addParticles(Particles.new("fear_blue", 1))
	elseif self.fearParticlesId and not hasParticles then
		self:removeParticles(self.fearParticlesId)
		self.fearParticlesId = nil
	end
end

newEffect{
	name = "HEIGHTEN_FEAR", image = "talents/heighten_fear.png",
	desc = _t"Heighten Fear",
	long_desc = function(self, eff) return ("The target is in a state of growing fear. If they spend %d more turns within range %d and in sight of the source of this fear (%s), they will take %d mind and darkness damage and be subjected to a new fear."):
		tformat(eff.turns_left, eff.range, eff.src:getName(), eff.damage) end,
	type = "other",
	charges = function(self, eff) return _t"#ORANGE#"..eff.turns_left.."#LAST#" end,
	subtype = { },
	status = "detrimental",
	cancel_on_level_change = true,
	parameters = { },
	on_timeout = function(self, eff)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
--		if tInstillFear.hasEffect(eff.src, tInstillFear, self) then
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.range and eff.src:hasLOS(self.x, self.y) then
				eff.turns_left = eff.turns_left - 1
			end
			if eff.turns_left <= 0 then
				eff.turns_left = eff.turns
				if rng.percent(eff.chance or 100) then
					game.logSeen(self, "%s succumbs to heightening fears!", self:getName():capitalize())
					DamageType:get(DamageType.MIND).projector(eff.src, self.x, self.y, DamageType.MIND, { dam=eff.damage, crossTierChance=25 })
					DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.damage)
					tInstillFear.applyEffect(eff.src, tInstillFear, self, true)
				else
					game.logSeen(self, "%s feels a little less afraid!", self:getName():capitalize())
				end
			end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "Tyrant", image = "talents/tyrant.png",
	desc = _t"Tyrant",
	long_desc = function(self, eff) return ("Your tyranny is increasing your Mindpower and Physicalpower by 2 for each fear applied, for a total of %d"): format(eff.tyrantPower * eff.stacks) end,
	type = "mental",
	subtype = {  },
	status = "beneficial",
	parameters = { stacks=1 },
	activate = function(self, eff)
		eff.mpower = self:addTemporaryValue("combat_mindpower", eff.tyrantPower * eff.stacks)
		eff.ppower = self:addTemporaryValue("combat_dam", eff.tyrantPower * eff.stacks)
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.stacks = util.bound(old_eff.stacks + 1, 1, new_eff.maxStacks)
		self:removeTemporaryValue("combat_mindpower", old_eff.mpower)
		self:removeTemporaryValue("combat_dam", old_eff.ppower)
		old_eff.mpower = self:addTemporaryValue("combat_mindpower", old_eff.tyrantPower * old_eff.stacks)
		old_eff.ppower = self:addTemporaryValue("combat_dam", old_eff.tyrantPower * old_eff.stacks)
		return old_eff
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mindpower", eff.mpower)
		self:removeTemporaryValue("combat_dam", eff.ppower)
	end,
}

newEffect{
	name = "PARANOID", image = "effects/paranoid.png",
	desc = _t"Paranoid",
	long_desc = function(self, eff) return ("Paranoia has gripped the target, causing a %d%% chance they will physically attack anyone nearby, friend or foe. Targets of the attack may become paranoid themselves."):tformat(eff.attackChance) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { tyrantDur=5, tyrantPower=2, maxStacks=7 },
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes paranoid!", _t"+Paranoid" end,
	on_lose = function(self, err) return _t"#Target# is no longer paranoid", _t"-Paranoid" end,
	activate = function(self, eff)
		--fear effect for each fear effect in mental.lua to give caster a buff
		if eff.src and eff.src.knowTalent and eff.src:knowTalent(eff.src.T_TYRANT) then
			eff.src:setEffect(eff.src.EFF_TYRANT, eff.tyrantDur, { tyrantPower = eff.tyrantPower, maxStacks = eff.maxStacks })
		end
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)
	end,
	do_act = function(self, eff)
		if not self:enoughEnergy() then return nil end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.attackChance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the paranoia.", self:getName():capitalize())
		else
			eff.timer = eff.timer + eff.attackChance
		end
		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local start = rng.range(0, 8)
			for i = start, start + 8 do
				local x = self.x + (i % 3) - 1
				local y = self.y + math.floor((i % 9) / 3) - 1
				if (self.x ~= x or self.y ~= y) then
					local target = game.level.map(x, y, Map.ACTOR)
					if target then
						self:logCombat(target, "#F53CBE##Source# attacks #Target# in a fit of paranoia.")
						if self:attackTarget(target, nil, 1, false) and target ~= eff.src then
							if not target:canBe("fear") then
								game.logSeen(target, "#F53CBE#%s ignores the fear!", target:getName():capitalize())
							elseif not target:checkHit(eff.mindpower, target:combatMentalResist()) then
								game.logSeen(target, "%s resists the fear!", target:getName():capitalize())
							else
								target:setEffect(target.EFF_PARANOID, eff.duration, {src=eff.src, attackChance=eff.attackChance, mindpower=eff.mindpower, duration=eff.duration, tyrantDur = eff.tyrantDur, tyrantPower = eff.tyrantPower, maxStacks = eff.maxStacks })
							end
						end
						return
					end
				end
			end
		end
	end,
}

newEffect{
	name = "DISPAIR", image = "effects/despair.png",
	desc = _t"Despair",
	long_desc = function(self, eff) return ("The target is in despair, reducing their armour, defence, mindsave and mind resist by %d."):tformat(-eff.statChange) end,
	charges = function(self, eff) return math.floor(-eff.statChange) end,	
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# is in despair!", _t"+Despair" end,
	on_lose = function(self, err) return _t"#Target# is no longer in despair", _t"-Despair" end,
	activate = function(self, eff)
		--fear effect for each fear effect in mental.lua to give caster a buff
		if eff.src and eff.src.knowTalent and eff.src:knowTalent(eff.src.T_TYRANT) then
			eff.src:setEffect(eff.src.EFF_TYRANT, eff.tyrantDur, { tyrantPower = eff.tyrantPower, maxStacks = eff.maxStacks })
		end
		eff.despairRes = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.statChange })
		eff.despairSave = self:addTemporaryValue("combat_mentalresist", eff.statChange)
		eff.despairArmor = self:addTemporaryValue("combat_armor", eff.statChange)
		eff.despairDef = self:addTemporaryValue("combat_def", eff.statChange)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.despairRes)
		self:removeTemporaryValue("combat_mentalresist", eff.despairSave)
		self:removeTemporaryValue("combat_armor", eff.despairArmor)
		self:removeTemporaryValue("combat_def", eff.despairDef)
		updateFearParticles(self)
	end,
}

newEffect{
	name = "TERRIFIED", image = "effects/terrified.png",
	desc = _t"Terrified",
	long_desc = function(self, eff) return ("The target is terrified taking %d mind and darkness damage per turn and increasing all their cooldowns by %d%%."):tformat(eff.damage, eff.cooldownPower * 100) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	charges = function(self, eff) return (tostring(math.floor(eff.cooldownPower * 100)).."%") end,
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes terrified!", _t"+Terrified" end,
	on_lose = function(self, err) return _t"#Target# is no longer terrified", _t"-Terrified" end,
	activate = function(self, eff) --cooldown increase handled in class.actor.lua
		--fear effect for each fear effect in mental.lua to give caster a buff
		if eff.src and eff.src.knowTalent and eff.src:knowTalent(eff.src.T_TYRANT) then
			eff.src:setEffect(eff.src.EFF_TYRANT, eff.tyrantDur, { tyrantPower = eff.tyrantPower, maxStacks = eff.maxStacks })
		end
		updateFearParticles(self)
	end,
	on_timeout = function(self, eff)
		eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.MIND, eff.damage)
		eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.DARKNESS, eff.damage)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)
	end,
}

-- distressed fear for prosperity
--[[
newEffect{
	name = "DISTRESSED", image = "effects/distressed.png",
	desc = _t"Distressed",
	long_desc = function(self, eff) return ("The target is distressed, reducing all saves by %d."):tformat(-eff.saveChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes distressed!", _t"+Distressed" end,
	on_lose = function(self, err) return _t"#Target# is no longer distressed", _t"-Distressed" end,
	activate = function(self, eff)
		eff.physicalId = self:addTemporaryValue("combat_physresist", eff.saveChange)
		eff.mentalId = self:addTemporaryValue("combat_mentalresist", eff.saveChange)
		eff.spellId = self:addTemporaryValue("combat_spellresist", eff.saveChange)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physresist", eff.physicalId)
		self:removeTemporaryValue("combat_mentalresist", eff.mentalId)
		self:removeTemporaryValue("combat_spellresist", eff.spellId)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
}
]]

newEffect{
	name = "HAUNTED", image = "effects/haunted.png",
	desc = _t"Haunted",
	long_desc = function(self, eff) return ("The target is haunted by a feeling of dread, causing each detrimental mental effect to inflict %d mind and darkness damage every turn."):tformat(eff.damage) end, --perhaps add total.
	charges = function(self, eff) return (math.floor(eff.damage)) end,	
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {damage=10},
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes haunted!", _t"+Haunted" end,
	on_lose = function(self, err) return _t"#Target# is no longer haunted", _t"-Haunted" end,
	activate = function(self, eff)
		--fear effect for each fear effect in mental.lua to give caster a buff
		if eff.src and eff.src.knowTalent and eff.src:knowTalent(eff.src.T_TYRANT) then
			eff.src:setEffect(eff.src.EFF_TYRANT, eff.tyrantDur, { tyrantPower = eff.tyrantPower, maxStacks = eff.maxStacks })
		end
		updateFearParticles(self)
	end,
	
	on_timeout = function(self, eff)
		local nb = 0
		for e, p in pairs(self.tmp) do
			local def = self.tempeffect_def[e]
			if def.type == "mental" and def.status == "detrimental" then
				nb = nb + 1
			end
		end
		if nb > 0 and not self.dead then
			eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.MIND, { dam=nb * eff.damage,alwaysHit=true,crossTierChance=0 })
			eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.DARKNESS, nb * eff.damage)
		end
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)
	end,
	on_setFearEffect = function(self, e)
		local eff = self:hasEffect(self.EFF_HAUNTED)
	end,
}

--tormented for prosperity
--[[
newEffect{
	name = "TORMENTED", image = "effects/tormented.png",
	desc = _t"Tormented",
	long_desc = function(self, eff) return ("The target's mind is being tormented, causing %d apparitions to manifest and attack the target, inflicting %d mind damage each before disappearing."):tformat(eff.count, eff.damage) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {count=1, damage=10},
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes tormented!", _t"+Tormented" end,
	on_lose = function(self, err) return _t"#Target# is no longer tormented", _t"-Tormented" end,
	activate = function(self, eff)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	npcTormentor = {
		name = "tormentor",
		display = "h", color=colors.DARK_GREY, image="npc/horror_eldritch_nightmare_horror.png",
		blood_color = colors.BLACK,
		desc = _t"A vision of terror that wracks the mind.",
		type = "horror", subtype = "eldritch",
		rank = 2,
		size_category = 2,
		body = { INVEN = 10 },
		no_drops = true,
		autolevel = "summoner",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=10, dex=20, wil=20, con=10, cun=30 },
		infravision = 10,
		can_pass = {pass_wall=20},
		resists = { all = 100, [DamageType.MIND]=-100 },
		no_breath = 1,
		fear_immune = 1,
		blind_immune = 1,
		infravision = 10,
		see_invisible = 80,
		max_life = resolvers.rngavg(50, 80),
		combat_armor = 1, combat_def = 50,
		combat = { dam=1 },
		resolvers.talents{
		},
		on_act = function(self)
			local target = self.ai_target.actor
			if not target or target.dead then
				self:die()
			else
				game.logSeen(self, "%s is tormented by a vision!", target:getName():capitalize())
				self:project({type="hit", x=target.x,y=target.y}, target.x, target.y, engine.DamageType.MIND, { dam=self.tormentedDamage,alwaysHit=true,crossTierChance=75 })
				self:die()
			end
		end,
	},
	on_timeout = function(self, eff)
		if eff.src.dead then return true end

		-- tormentors per turn are pre-calculated in a table, but ordered, so take a random one
		local count = rng.tableRemove(eff.counts)
		for c = 1, count do
			local start = rng.range(0, 8)
			for i = start, start + 8 do
				local x = self.x + (i % 3) - 1
				local y = self.y + math.floor((i % 9) / 3) - 1
				if game.level.map:isBound(x, y) and not game.level.map(x, y, Map.ACTOR) then
					local def = self.tempeffect_def[self.EFF_TORMENTED]
					local m = require("mod.class.NPC").new(def.npcTormentor)
					m.faction = eff.src.faction
					m.summoner = eff.src
					m.summoner_gain_exp = true
					m.summon_time = 3
					m.tormentedDamage = eff.damage
					m:resolve() m:resolve(nil, true)
					m:forceLevelup(self.level)
					m:setTarget(self)

					game.zone:addEntity(game.level, m, "actor", x, y)

					break
				end
			end
		end
	end,
}
]]

newEffect{
	name = "PANICKED", image = "talents/panic.png",
	desc = _t"Panicked",
	long_desc = function(self, eff) return ("The target has been panicked by %s, causing them to have a %d%% chance of fleeing in terror instead of acting."):tformat(eff.src:getName(), eff.chance) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#F53CBE##Target# becomes panicked!", _t"+Panicked" end,
	on_lose = function(self, err) return _t"#Target# is no longer panicked", _t"-Panicked" end,
	activate = function(self, eff)
		eff.particlesId = self:addParticles(Particles.new("fear_violet", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particlesId)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	do_act = function(self, eff)
		if not self:enoughEnergy() then return nil end
		if eff.src.dead then return true end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.chance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the panic.", self:getName():capitalize())
		else
			eff.timer = eff.timer + eff.chance
		end
		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local distance = core.fov.distance(self.x, self.y, eff.src.x, eff.src.y)
			if distance <= eff.range then
				-- in range
				if not self:attr("never_move") then
					local sourceX, sourceY = eff.src.x, eff.src.y

					local bestX, bestY
					local bestDistance = 0
					local start = rng.range(0, 8)
					for i = start, start + 8 do
						local x = self.x + (i % 3) - 1
						local y = self.y + math.floor((i % 9) / 3) - 1

						if x ~= self.x or y ~= self.y then
							local distance = core.fov.distance(x, y, sourceX, sourceY)
							if distance > bestDistance
									and game.level.map:isBound(x, y)
									and not game.level.map:checkAllEntities(x, y, "block_move", self)
									and not game.level.map(x, y, Map.ACTOR) then
								bestDistance = distance
								bestX = x
								bestY = y
							end
						end
					end

					if bestX then
						self:move(bestX, bestY, false)
						game.logPlayer(self, "#F53CBE#You panic and flee from %s.", eff.src:getName())
					else
						self:logCombat(eff.src, "#F53CBE##Source# panics but fails to flee from #Target#.")
						self:useEnergy(game.energy_to_act * self:combatMovementSpeed(bestX, bestY))
					end
				end
			end
		end
	end,
}

newEffect{
	name = "QUICKNESS", image = "effects/quickness.png",
	desc = _t"Quick",
	long_desc = function(self, eff) return ("Increases global speed by %d%%."):tformat(eff.power * 100) end,
	type = "mental",
	subtype = { telekinesis=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#Target# speeds up.", _t"+Quick" end,
	on_lose = function(self, err) return _t"#Target# slows down.", _t"-Quick" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "PSIFRENZY", image = "talents/frenzied_focus.png",
	desc = _t"Frenzied Focus",
	long_desc = function(self, eff) return (_t"This creatures psionic focus item is supercharged!") end,
	type = "mental",
	subtype = { telekinesis=true, frenzy=true },
	status = "beneficial",
	parameters = {dam=10},
	on_gain = function(self, err) return _t"#Target# enters a frenzy!", _t"+Frenzy" end,
	on_lose = function(self, err) return _t"#Target# is no longer frenzied.", _t"-Frenzy" end,
}

newEffect{
	name = "KINSPIKE_SHIELD", image = "talents/kinetic_shield.png",
	desc = _t"Spiked Kinetic Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and _t", nature" or "")..(tl>=6 and _t", temporal" or "")
		return ("The target erects a powerful kinetic shield capable of absorbing %d/%d physical%s or acid damage before it crumbles."):tformat(self.kinspike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return _t"A powerful kinetic shield forms around #target#.", _t"+Shield" end,
	on_lose = function(self, err) return _t"The powerful kinetic shield around #target# crumbles.", _t"-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("kinspike_shield", eff.power)
		self.kinspike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={1, 0, 0.3, 0.6}, auraColor={1, 0, 0.3, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=0, b=0.3, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("kinspike_shield", eff.tmpid)
		self.kinspike_shield_absorb = nil
	end,
}
newEffect{
	name = "THERMSPIKE_SHIELD", image = "talents/thermal_shield.png",
	desc = _t"Spiked Thermal Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and _t", light" or "")..(tl>=6 and _t", arcane" or "")
		return ("The target erects a powerful thermal shield capable of absorbing %d/%d fire%s or cold damage before it crumbles."):tformat(self.thermspike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return _t"A powerful thermal shield forms around #target#.", _t"+Shield" end,
	on_lose = function(self, err) return _t"The powerful thermal shield around #target# crumbles.", _t"-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("thermspike_shield", eff.power)
		self.thermspike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={0.3, 1, 1, 0.6}, auraColor={0.3, 1, 1, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0.3, g=1, b=1, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("thermspike_shield", eff.tmpid)
		self.thermspike_shield_absorb = nil
	end,
}
newEffect{
	name = "CHARGESPIKE_SHIELD", image = "talents/charged_shield.png",
	desc = _t"Spiked Charged Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and _t", darkness" or "")..(tl>=6 and _t", mind" or "")
		return ("The target erects a powerful charged shield capable of absorbing %d/%d lightning%s or blight damage before it crumbles."):tformat(self.chargespike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return _t"A powerful charged shield forms around #target#.", _t"+Shield" end,
	on_lose = function(self, err) return _t"The powerful charged shield around #target# crumbles.", _t"-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("chargespike_shield", eff.power)
		self.chargespike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={0.8, 1, 0.2, 0.6}, auraColor={0.8, 1, 0.2, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0.8, g=1, b=0.2, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("chargespike_shield", eff.tmpid)
		self.chargespike_shield_absorb = nil
	end,
}

newEffect{
	name = "CONTROL", image = "talents/perfect_control.png",
	desc = _t"Perfect control",
	long_desc = function(self, eff) return ("The target's combat attack and crit chance are improved by %d and %d%%, respectively."):tformat(eff.power, 0.5*eff.power) end,
	type = "mental",
	subtype = { telekinesis=true, focus=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.attack = self:addTemporaryValue("combat_atk", eff.power)
		eff.crit = self:addTemporaryValue("combat_physcrit", 0.5*eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.attack)
		self:removeTemporaryValue("combat_physcrit", eff.crit)
	end,
}

newEffect{
	name = "PSI_REGEN", image = "talents/matter_is_energy.png",
	desc = _t"Matter is energy",
	long_desc = function(self, eff) return ("The gem's matter gradually transforms, granting %0.2f psi per turn."):tformat(eff.power) end,
	type = "mental",
	subtype = { psychic_drain=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"Energy starts pouring from the gem into #Target#.", _t"+Energy" end,
	on_lose = function(self, err) return _t"The flow of energy from #Target#'s gem ceases.", _t"-Energy" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("psi_regen", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("psi_regen", eff.tmpid)
	end,
}

newEffect{
	name = "MASTERFUL_TELEKINETIC_ARCHERY", image = "talents/masterful_telekinetic_archery.png",
	desc = _t"Telekinetic Archery",
	long_desc = function(self, eff) return (_t"Your telekinetically-wielded bow automatically attacks the nearest target each turn.") end,
	type = "mental",
	subtype = { telekinesis=true },
	status = "beneficial",
	parameters = {dam=10},
	on_gain = function(self, err) return _t"#Target# enters a telekinetic archer's trance!", _t"+Telekinetic archery" end,
	on_lose = function(self, err) return _t"#Target# is no longer in a telekinetic archer's trance.", _t"-Telekinetic archery" end,
}

newEffect{
	name = "WEAKENED_MIND", image = "talents/taint__telepathy.png",
	desc = _t"Receptive Mind",
	long_desc = function(self, eff) return ("Decreases mind save by %d and increases mindpower by %d."):tformat(eff.save, eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "detrimental",
	parameters = { power=10, save=10 },
	activate = function(self, eff)
		eff.mindid = self:addTemporaryValue("combat_mentalresist", -eff.save)
		eff.powdid = self:addTemporaryValue("combat_mindpower", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.mindid)
		self:removeTemporaryValue("combat_mindpower", eff.powdid)
	end,
}

newEffect{
	name = "VOID_ECHOES", image = "talents/echoes_from_the_void.png",
	desc = _t"Void Echoes",
	long_desc = function(self, eff) return ("The target is seeing echoes from the void and will take %0.2f mind damage as well as some resource damage each turn it fails a mental save."):tformat(eff.power) end,
	type = "mental",
	subtype = { madness=true, psionic=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# is being driven mad by the void.", _t"+Void Echoes" end,
	on_lose = function(self, err) return _t"#Target# has survived the void madness.", _t"-Void Echoes" end,
	on_timeout = function(self, eff)
		local drain = DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.power) / 2
		self:incMana(-drain)
		self:incVim(-drain * 0.5)
		self:incPositive(-drain * 0.25)
		self:incNegative(-drain * 0.25)
		self:incStamina(-drain * 0.65)
		self:incHate(-drain * 0.2)
		self:incPsi(-drain * 0.2)
	end,
}

newEffect{
	name = "WAKING_NIGHTMARE", image = "talents/waking_nightmare.png",
	desc = _t"Waking Nightmare",
	long_desc = function(self, eff) return ("The target is lost in a nightmare that deals %0.2f mind damage each turn and has a %d%% chance to cause a random detrimental effect."):tformat(eff.dam, eff.chance) end,
	type = "mental",
	subtype = { nightmare=true, darkness=true },
	status = "detrimental",
	parameters = { chance=10, dam = 10 },
	on_gain = function(self, err) return _t"#F53CBE##Target# is lost in a nightmare.", _t"+Night Terrors" end,
	on_lose = function(self, err) return _t"#Target# is free from the nightmare.", _t"-Night Terrors" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src or self, self.x, self.y, DamageType.DARKNESS, eff.dam)
		local chance = eff.chance
		if self:attr("sleep") then chance = 100-(100-chance)/2 end -- Half normal chance to avoid effect
		if rng.percent(chance) then
			-- Pull random effect
			chance = rng.range(1, 3)
			if chance == 1 then
				if self:canBe("blind") then
					self:setEffect(self.EFF_BLINDED, 3, {})
				end
			elseif chance == 2 then
				if self:canBe("stun") then
					self:setEffect(self.EFF_STUNNED, 3, {})
				end
			elseif chance == 3 then
				if self:canBe("confusion") then
					self:setEffect(self.EFF_CONFUSED, 3, {power=30})
				end
			end
			game.logSeen(self, "#F53CBE#%s succumbs to the nightmare!", self:getName():capitalize())
		end
	end,
}

newEffect{
	name = "INNER_DEMONS", image = "talents/inner_demons.png",
	desc = _t"Inner Demons",
	long_desc = function(self, eff) return ("The target is plagued by inner demons and each turn there's a %d%% chance that one will appear.  If the caster is killed or the target resists setting his demons loose the effect will end early."):tformat(eff.chance) end,
	type = "mental",
	subtype = { nightmare=true },
	status = "detrimental",
	remove_on_clone = true,
	parameters = {chance=0},
	on_gain = function(self, err) return _t"#F53CBE##Target# is plagued by inner demons!", _t"+Inner Demons" end,
	on_lose = function(self, err) return _t"#Target# is freed from the demons.", _t"-Inner Demons" end,
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="inner_demons_tentacle_shader"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
	on_timeout = function(self, eff)
		if eff.src.dead or not game.level:hasEntity(eff.src) then eff.dur = 0 return true end
		local t = eff.src:getTalentFromId(eff.src.T_INNER_DEMONS)
		local chance = eff.chance
		if self:attr("sleep") then chance = 100-(100-chance)/2 end -- Half normal chance not to manifest
		if rng.percent(chance) then
			if self:attr("sleep") or self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
				t.summon_inner_demons(eff.src, self, t)
				self:removeEffectsFilter(self, {subtype={["sleep"] = true}}, 3) -- Allow the player to actually react to one of the biggest threats in the game before 50 more spawn
			else
				eff.dur = 0
			end
		end
	end,
}

newEffect{
	name = "DOMINATE_ENTHRALL", image = "talents/yeek_will.png",
	desc = _t"Enthralled",
	long_desc = function(self, eff) return (_t"The target is enthralled, temporarily changing its faction.") end,-- to %s.")--:tformat(engine.Faction.factions[eff.faction].name) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return _t"#Target# is entralled.", _t"+Enthralled" end,
	on_lose = function(self, err) return _t"#Target# is free from the domination.", _t"-Enthralled" end,
	activate = function(self, eff)
		eff.olf_faction = self.faction
		self.faction = eff.src.faction
	end,
	deactivate = function(self, eff)
		self.faction = eff.olf_faction
	end,
}

newEffect{
	name = "HALFLING_LUCK", image = "talents/halfling_luck.png",
	desc = _t"Halflings's Luck",
	long_desc = function(self, eff) return ("The target's luck and cunning combine to grant it %d%% higher critical chance and %d saves."):tformat(eff.crit, eff.save) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { crit=10, save=10 },
	on_gain = function(self, err) return _t"#Target# seems more aware." end,
	on_lose = function(self, err) return _t"#Target#'s awareness returns to normal." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_generic_crit", eff.crit)
		self:effectTemporaryValue(eff, "combat_physresist", eff.save)
		self:effectTemporaryValue(eff, "combat_spellresist", eff.save)
		self:effectTemporaryValue(eff, "combat_mentalresist", eff.save)
	end,
}

newEffect{
	name = "ATTACK", image = "talents/perfect_strike.png",
	desc = _t"Perfect Accuracy",
	long_desc = function(self, eff) return ("The target's accuracy is improved by %d."):tformat(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# aims carefully." end,
	on_lose = function(self, err) return _t"#Target# aims less carefully." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_atk", eff.power)
		eff.bid = self:addTemporaryValue("blind_fight", 1)
		self:effectParticles(eff, {type="perfect_strike", args={radius=1}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.tmpid)
		self:removeTemporaryValue("blind_fight", eff.bid)
	end,
}

newEffect{
	name = "DEADLY_STRIKES", image = "talents/deadly_strikes.png",
	desc = _t"Deadly Strikes",
	long_desc = function(self, eff) return ("The target's armour penetration is increased by %d."):tformat(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# aims carefully." end,
	on_lose = function(self, err) return _t"#Target# aims less carefully." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_apr", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_apr", eff.tmpid)
	end,
}

newEffect{
	name = "FRENZY", image = "effects/frenzy.png",
	desc = _t"Frenzy",
	long_desc = function(self, eff) return ("Increases global action speed by %d%% and physical crit by %d%%.\nAdditionally the target will continue to fight until its Life reaches -%d%%."):tformat(eff.power * 100, eff.crit, eff.dieat * 100) end,
	type = "mental",
	subtype = { frenzy=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return _t"#Target# goes into a killing frenzy.", _t"+Frenzy" end,
	on_lose = function(self, err) return _t"#Target# calms down.", _t"-Frenzy" end,
	on_merge = function(self, old_eff, new_eff)
		-- use on merge so reapplied frenzy doesn't kill off creatures with negative life
		old_eff.dur = new_eff.dur
		old_eff.power = new_eff.power
		old_eff.crit = new_eff.crit
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
		eff.critid = self:addTemporaryValue("combat_physcrit", eff.crit)
		eff.dieatid = self:addTemporaryValue("die_at", -self.max_life * eff.dieat)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeTemporaryValue("combat_physcrit", eff.critid)
		self:removeTemporaryValue("die_at", eff.dieatid)

		-- check negative life first incase the creature has healing
		if self.life <= (self.die_at or 0) then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), _t"Falls dead!", {255,0,255})
			game.logSeen(self, "%s dies when its frenzy ends!", self:getName():capitalize())
			self:die(self)
		end
	end,
}

newEffect{
	name = "BLOODBATH", image = "talents/bloodbath.png",
	desc = _t"Bloodbath",
	long_desc = function(self, eff) return ("The thrill of combat improves the target's maximum life by %d%%, life regeneration by %0.2f, and stamina regeneration by %0.2f."):tformat(eff.hp, eff.cur_regen or eff.regen, eff.cur_regen/5 or eff.regen/5) end,
	type = "mental",
	subtype = { frenzy=true, heal=true, regeneration=true, },
	status = "beneficial",
	parameters = { hp=10, regen=10, max=50 },
	on_gain = function(self, err) return nil, _t"+Bloodbath" end,
	on_lose = function(self, err) return nil, _t"-Bloodbath" end,
	on_merge = function(self, old_eff, new_eff)
		if old_eff.cur_regen + new_eff.regen < new_eff.max then	game.logSeen(self, "%s's blood frenzy intensifies!", self:getName():capitalize()) end
		new_eff.templife_id = old_eff.templife_id
		self:removeTemporaryValue("max_life", old_eff.life_id)
		self:removeTemporaryValue("life_regen", old_eff.life_regen_id)
		self:removeTemporaryValue("stamina_regen", old_eff.stamina_regen_id)
		new_eff.particle1 = old_eff.particle1
		new_eff.particle2 = old_eff.particle2

		-- Take the new values, dont heal, otherwise you get a free heal each crit .. which is totaly broken
		local v = new_eff.hp * self.max_life / 100
		new_eff.life_id = self:addTemporaryValue("max_life", v)
		new_eff.cur_regen = math.min(old_eff.cur_regen + new_eff.regen, new_eff.max)
		new_eff.life_regen_id = self:addTemporaryValue("life_regen", new_eff.cur_regen)
		new_eff.stamina_regen_id = self:addTemporaryValue("stamina_regen", new_eff.cur_regen/5)
		return new_eff
	end,
	activate = function(self, eff)
		local v = eff.hp * self.max_life / 100
		eff.life_id = self:addTemporaryValue("max_life", v)
		eff.templife_id = self:addTemporaryValue("life",v) -- Prevent healing_factor affecting activation
		eff.cur_regen = eff.regen
		eff.life_regen_id = self:addTemporaryValue("life_regen", eff.regen)
		eff.stamina_regen_id = self:addTemporaryValue("stamina_regen", eff.regen /5)
		game.logSeen(self, "%s revels in the spilt blood and grows stronger!",self:getName():capitalize())

		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)

		self:removeTemporaryValue("max_life", eff.life_id)
		self:removeTemporaryValue("life_regen", eff.life_regen_id)
		self:removeTemporaryValue("stamina_regen", eff.stamina_regen_id)

		self:removeTemporaryValue("life",eff.templife_id) -- remove extra hps to prevent excessive heals at high level
		game.logSeen(self, "%s no longer revels in blood quite so much.",self:getName():capitalize())
	end,
}

newEffect{
	name = "BLOODRAGE", image = "talents/bloodrage.png",
	desc = _t"Bloodrage",
	long_desc = function(self, eff) return ("The target's strength is increased by %d by the thrill of combat."):tformat(eff.cur_inc) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { inc=1, max=10 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("inc_stats", old_eff.tmpid)
		old_eff.cur_inc = math.min(old_eff.cur_inc + new_eff.inc, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = old_eff.cur_inc})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_inc = eff.inc
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = eff.inc})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "INCREASED_LIFE", image = "effects/increased_life.png",
	desc = _t"Increased Life",
	long_desc = function(self, eff) return ("The target's maximum life is increased by %d."):tformat(eff.life) end,
	type = "mental",
	subtype = { frenzy=true, heal=true },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target# gains extra life.", _t"+Life" end,
	on_lose = function(self, err) return _t"#Target# loses extra life.", _t"-Life" end,
	parameters = { life = 50 },
	activate = function(self, eff)
		self.max_life = self.max_life + eff.life
		self.life = self.life + eff.life
		self.changed = true
	end,
	deactivate = function(self, eff)
		self.max_life = self.max_life - eff.life
		self.life = self.life - eff.life
		self.changed = true
		if self.life <= 0 then
			self.life = 1
			self:setEffect(self.EFF_STUNNED, 3, {})
			game.logSeen(self, "%s's increased life fades, leaving it stunned by the loss.", self:getName():capitalize())
		end
	end,
}

newEffect{
	name = "GESTURE_OF_GUARDING", image = "talents/gesture_of_guarding.png",
	desc = _t"Guarded",
	long_desc = function(self, eff)
		local xs = ""
		local dam, deflects = eff.dam, eff.deflects
		if deflects < 1 then -- Partial deflect has reduced effectiveness
			dam = dam*math.max(0,deflects)
			deflects = 1
		end
		if self:isTalentActive(self.T_GESTURE_OF_PAIN) then xs = (" with a %d%% chance to counterattack"):tformat(self:callTalent(self.T_GESTURE_OF_GUARDING,"getCounterAttackChance")) end
		return ("Guarding against melee damage:  Will dismiss up to %d damage from the next %0.1f attack(s)%s."):tformat(dam, deflects, xs)
	end,
	charges = function(self, eff) return _t"#LIGHT_GREEN#"..math.ceil(eff.deflects) end,
	type = "mental",
	subtype = { curse=true },
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {dam = 1, deflects = 1},
	activate = function(self, eff)
		eff.dam = self:callTalent(self.T_GESTURE_OF_GUARDING,"getDamageChange")
		eff.deflects = self:callTalent(self.T_GESTURE_OF_GUARDING,"getDeflects")
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RAMPAGE", image = "talents/rampage.png",
	desc = _t"Rampaging",
	long_desc = function(self, eff)
		local desc = ("The target is rampaging! (+%d%% movement speed, +%d%% attack speed, +%d%% mind speed"):tformat(eff.movementSpeedChange * 100, eff.combatPhysSpeedChange * 100, eff.combatMindSpeedChange * 100)
		if eff.physicalDamageChange > 0 then
			desc = desc..(", +%d%% physical damage, +%d physical save, +%d mental save"):tformat(eff.physicalDamageChange, eff.combatPhysResistChange, eff.combatMentalResistChange)
		end
		if eff.damageShieldMax > 0 then
			desc = desc..(", %d/%d damage shrugged off this turn"):tformat(math.max(0, eff.damageShieldMax - eff.damageShield), eff.damageShieldMax)
		end
		desc = desc..")"
		return desc
	end,
	type = "mental",
	subtype = { frenzy=true, speed=true, evade=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return _t"#F53CBE##Target# begins rampaging!", _t"+Rampage" end,
	on_lose = function(self, err) return _t"#F53CBE##Target# is no longer rampaging.", _t"-Rampage" end,
	activate = function(self, eff)
		if eff.movementSpeedChange or 0 > 0 then eff.movementSpeedId = self:addTemporaryValue("movement_speed", eff.movementSpeedChange) end
		if eff.combatPhysSpeedChange or 0 > 0 then eff.combatPhysSpeedId = self:addTemporaryValue("combat_physspeed", eff.combatPhysSpeedChange) end
		if eff.combatMindSpeedChange or 0 > 0 then eff.combatMindSpeedId = self:addTemporaryValue("combat_mindspeed", eff.combatMindSpeedChange) end
		if eff.physicalDamageChange or 0 > 0 then eff.physicalDamageId = self:addTemporaryValue("inc_damage", { [DamageType.PHYSICAL] = eff.physicalDamageChange }) end
		if eff.combatPhysResistChange or 0 > 0 then eff.combatPhysResistId = self:addTemporaryValue("combat_physresist", eff.combatPhysResistChange) end
		if eff.combatMentalResistChange or 0 > 0 then eff.combatMentalResistId = self:addTemporaryValue("combat_mentalresist", eff.combatMentalResistChange) end

		if not self:addShaderAura("rampage", "awesomeaura", {time_factor=5000, alpha=0.7}, "particles_images/bloodwings.png") then
			eff.particle = self:addParticles(Particles.new("rampage", 1))
		end
	end,
	deactivate = function(self, eff)
		if eff.movementSpeedId then self:removeTemporaryValue("movement_speed", eff.movementSpeedId) end
		if eff.combatPhysSpeedId then self:removeTemporaryValue("combat_physspeed", eff.combatPhysSpeedId) end
		if eff.combatMindSpeedId then self:removeTemporaryValue("combat_mindspeed", eff.combatMindSpeedId) end
		if eff.physicalDamageId then self:removeTemporaryValue("inc_damage", eff.physicalDamageId) end
		if eff.combatPhysResistId then self:removeTemporaryValue("combat_physresist", eff.combatPhysResistId) end
		if eff.combatMentalResistId then self:removeTemporaryValue("combat_mentalresist", eff.combatMentalResistId) end

		self:removeShaderAura("rampage")
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		-- restore damage shield
		if eff.damageShieldMax and eff.damageShield ~= eff.damageShieldMax and not self.dead then
			eff.damageShieldUsed = (eff.damageShieldUsed or 0) + eff.damageShieldMax - eff.damageShield
			game.logSeen(self, "%s has shrugged off %d damage and is ready for more.", self:getName():capitalize(), eff.damageShieldMax - eff.damageShield)
			eff.damageShield = eff.damageShieldMax

			if eff.damageShieldBonus and eff.damageShieldUsed >= eff.damageShieldBonus and eff.actualDuration < eff.maxDuration then
				eff.actualDuration = eff.actualDuration + 1
				eff.dur = eff.dur + 1
				eff.damageShieldBonus = nil

				game.logPlayer(self, "#F53CBE#Your rampage is invigorated by the intense onslaught! (+1 duration)")
			end
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		if not eff.damageShieldMax or eff.damageShield <= 0 then return dam end

		local absorb = math.min(eff.damageShield, dam)
		eff.damageShield = eff.damageShield - absorb

		--game.logSeen(self, "%s shrugs off %d damage.", self:getName():capitalize(), absorb)

		return dam - absorb
	end,
	do_postUseTalent = function(self, eff)
		if eff.dur > 0 then
			eff.dur = eff.dur - 1

			game.logPlayer(self, "#F53CBE#You feel your rampage slowing down. (-1 duration)")
		end
	end,
}

newEffect{
	name = "ORC_FURY", image = "talents/orc_fury.png",
	desc = _t"Orcish Fury",
	long_desc = function(self, eff) return ("The target enters a destructive fury, increasing all damage done by %d%%."):tformat(eff.power) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return _t"#Target# enters a state of bloodlust." end,
	on_lose = function(self, err) return _t"#Target# calms down." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid)
	end,
}

newEffect{
	name = "ORC_TRIUMPH", image = "talents/skirmisher.png",
	desc = _t"Orcish Triumph",
	long_desc = function(self, eff) return ("Inspired by a recent kill increasing all resistance by %d%%."):tformat(eff.resists) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { resists=10 },
	on_gain = function(self, err) return _t"#Target# roars triumphantly." end, -- Too spammy?
	on_lose = function(self, err) return _t"#Target# is no longer inspired." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.resists})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "BRAINLOCKED",
	desc = _t"Brainlocked",
	long_desc = function(self, eff) return ("Renders a random talent unavailable. Talent cooldown is halved until the effect has worn off."):tformat() end,
	type = "mental",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return nil, _t"+Brainlocked" end,
	on_lose = function(self, err) return nil, _t"-Brainlocked" end,
	activate = function(self, eff)
		eff.tcdid = self:addTemporaryValue("half_talents_cooldown", 1)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and not t.no_energy then tids[#tids+1] = t end
		end
		for i = 1, 1 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("half_talents_cooldown", eff.tcdid)
	end,
}

newEffect{
	name = "FRANTIC_SUMMONING", image = "talents/frantic_summoning.png",
	desc = _t"Frantic Summoning",
	long_desc = function(self, eff) return ("Reduces the time taken for summoning by %d%%."):tformat(eff.power) end,
	type = "mental",
	subtype = { summon=true },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target# starts summoning at high speed.", _t"+Frantic Summoning" end,
	on_lose = function(self, err) return _t"#Target#'s frantic summoning ends.", _t"-Frantic Summoning" end,
	parameters = { power=20 },
	activate = function(self, eff)
		eff.failid = self:addTemporaryValue("no_equilibrium_summon_fail", 1)
		eff.speedid = self:addTemporaryValue("fast_summons", eff.power)

		-- Find a cooling down summon talent and enable it
		local list = {}
		for tid, dur in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t.is_summon then
				list[#list+1] = t
			end
		end
		if #list > 0 then
			local t = rng.table(list)
			self.talents_cd[t.id] = nil
			if self.onTalentCooledDown then self:onTalentCooledDown(t.id) end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("no_equilibrium_summon_fail", eff.failid)
		self:removeTemporaryValue("fast_summons", eff.speedid)
	end,
}

newEffect{
	name = "WILD_SUMMON", image = "talents/wild_summon.png",
	desc = _t"Wild Summon",
	long_desc = function(self, eff) return ("%d%% chance to get a more powerful summon."):tformat(eff.chance) end,
	type = "mental",
	subtype = { summon=true },
	status = "beneficial",
	parameters = { chance=100 },
	activate = function(self, eff)
		eff.tid = self:addTemporaryValue("wild_summon", eff.chance)
	end,
	on_timeout = function(self, eff)
		eff.chance = eff.chance or 100
		eff.chance = math.floor(eff.chance * 0.66)
		self:removeTemporaryValue("wild_summon", eff.tid)
		eff.tid = self:addTemporaryValue("wild_summon", eff.chance)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_summon", eff.tid)
	end,
}

newEffect{
	name = "LOBOTOMIZED", image = "talents/psychic_lobotomy.png",
	desc = _t"Lobotomized (confused)",
	long_desc = function(self, eff) return ("The target's mental faculties have been severely impaired, making it act randomly each turn (%d%% chance) and reducing its cunning by %d."):tformat(eff.confuse, eff.power/2) end,
	type = "mental",
	subtype = { confusion=true },
	status = "detrimental",
	charges = function(self, eff) return (tostring(math.floor(eff.confuse)).."%") end,
	on_gain = function(self, err) return _t"#Target# higher mental functions have been imparied.", _t"+Lobotomized" end,
	on_lose = function(self, err) return _t"#Target#'s regains its senses.", _t"-Lobotomized" end,
	parameters = { power=1, confuse=10, dam=1 },
	activate = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, {dam=eff.dam, alwaysHit=true})
		eff.confuse = math.floor(util.bound(eff.confuse, 0, 50)) -- Confusion cap of 50%
		eff.tmpid = self:addTemporaryValue("confused", eff.confuse)
		eff.cid = self:addTemporaryValue("inc_stats", {[Stats.STAT_CUN]=-eff.power/2})
		if eff.power <= 0 then eff.dur = 0 end
		eff.particles = self:addParticles(engine.Particles.new("generic_power", 1, {rm=100, rM=125, gm=100, gM=125, bm=100, bM=125, am=200, aM=255}))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("confused", eff.tmpid)
		self:removeTemporaryValue("inc_stats", eff.cid)
		if eff.particles then self:removeParticles(eff.particles) end
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "PSIONIC_SHIELD", image = "talents/kinetic_shield.png",
	desc = _t"Psionic Shield",
	display_desc = function(self, eff) return ("%s Psionic Shield"):tformat(_t(eff.kind):capitalize()) end,
	long_desc = function(self, eff) return ("Reduces all incoming %s damage by %d."):tformat(eff.what, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=10, kind="kinetic" },
	activate = function(self, eff)
		if eff.kind == "kinetic" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.PHYSICAL] = eff.power,
				[DamageType.ACID] = eff.power,
				[DamageType.NATURE] = eff.power,
				[DamageType.TEMPORAL] = eff.power,
			})
			eff.what = _t"physical, nature, acid, temporal"
		elseif eff.kind == "thermal" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.FIRE] = eff.power,
				[DamageType.COLD] = eff.power,
				[DamageType.LIGHT] = eff.power,
				[DamageType.ARCANE] = eff.power,
				})
			eff.what = _t"fire, cold, light, arcane"
		elseif eff.kind == "charged" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.LIGHTNING] = eff.power,
				[DamageType.BLIGHT] = eff.power,
				[DamageType.MIND] = eff.power,
				[DamageType.DARKNESS] = eff.power,
				})
			eff.what = _t"lightning, blight, mind, darkness"
		elseif eff.kind == "all" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				all = eff.power,
				})
			eff.what = _t"all"
		end
	end,
	deactivate = function(self, eff)
		if eff.sid then
			self:removeTemporaryValue("flat_damage_armor", eff.sid)
		end
	end,
}

newEffect{
	name = "CLEAR_MIND", image = "talents/mental_shielding.png",
	desc = _t"Clear Mind",
	long_desc = function(self, eff) return ("Nullifies the next %d detrimental mental effects."):tformat(self.clear_mind_immune) end,
	type = "mental",
	subtype = { psionic=true, },
	status = "beneficial",
	parameters = { power=2 },
	activate = function(self, eff)
		self.clear_mind_immune = eff.power
		eff.particles = self:addParticles(engine.Particles.new("generic_power", 1, {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=200, aM=255}))
	end,
	deactivate = function(self, eff)
		self.clear_mind_immune = nil
		self:removeParticles(eff.particles)
	end,
}

newEffect{
	name = "RESONANCE_FIELD", image = "talents/resonance_field.png",
	desc = _t"Resonance Field",
	long_desc = function(self, eff) return ("The target is surrounded by a psychic field, absorbing 50%% of all damage (up to %d/%d)."):tformat(self.resonance_field_absorb, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return _t"A psychic field forms around #target#.", _t"+Resonance Shield" end,
	on_lose = function(self, err) return _t"The psychic field around #target# crumbles.", _t"-Resonance Shield" end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		self.resonance_field_absorb = eff.power
		eff.sid = self:addTemporaryValue("resonance_field", eff.power)
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1}, {type="shield", time_factor=-8000, llpow=1, aadjust=7, color={1, 1, 0}}))
		--	eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, color={1, 1, 0}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=1, b=0, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self.resonance_field_absorb = nil
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("resonance_field", eff.sid)
	end,
}

newEffect{
	name = "MIND_LINK_TARGET", image = "talents/mind_link.png",
	desc = _t"Mind Link",
	long_desc = function(self, eff) return ("The target's mind has been invaded, increasing all mind damage it receives from %s by %d%%."):tformat(eff.src:getName():capitalize(), eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "detrimental",
	parameters = {power = 1, range = 5},
	remove_on_clone = true, decrease = 0,
	on_gain = function(self, err) return _t"#Target#'s mind has been invaded!", _t"+Mind Link" end,
	on_lose = function(self, err) return _t"#Target# is free from the mental invasion.", _t"-Mind Link" end,
	on_timeout = function(self, eff)
		-- Remove the mind link when appropriate
		local p = eff.src:isTalentActive(eff.src.T_MIND_LINK)
		if not p or p.target ~= self or eff.src.dead or not game.level:hasEntity(eff.src) or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > eff.range then
			self:removeEffect(self.EFF_MIND_LINK_TARGET)
		end
	end,
}

newEffect{
	name = "FEEDBACK_LOOP", image = "talents/feedback_loop.png",
	desc = _t"Feedback Loop",
	long_desc = function(self, eff) return _t"The target is gaining feedback." end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power = 1 },
	on_gain = function(self, err) return _t"#Target# is gaining feedback.", _t"+Feedback Loop" end,
	on_lose = function(self, err) return _t"#Target# is no longer gaining feedback.", _t"-Feedback Loop" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("ultrashield", 1, {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90, radius=0.2, density=15, life=28, instop=40}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "FOCUSED_WRATH", image = "talents/focused_wrath.png",
	desc = _t"Focused Wrath",
	long_desc = function(self, eff) return ("The target's subconscious has focused, increasing Mind resistance penetration by +%d%% and turning its attention on %s."):tformat(eff.pen, eff.target:getName():capitalize()) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power = 1 },
	on_gain = function(self, err) return _t"#Target#'s subconscious has been focused.", _t"+Focused Wrath" end,
	on_lose = function(self, err) return _t"#Target#'s subconscious has returned to normal.", _t"-Focused Wrath" end,
	activate = function(self, eff)
			self:effectTemporaryValue(eff, "resists_pen", {[DamageType.MIND]=eff.pen})
		end,
	on_timeout = function(self, eff)
		if not eff.target or eff.target.dead or not game.level:hasEntity(eff.target) then
			self:removeEffect(self.EFF_FOCUSED_WRATH)
		end
	end,
}

newEffect{
	name = "SLEEP", image = "talents/sleep.png",
	desc = _t"Sleep",
	long_desc = function(self, eff) return ("The target is asleep and unable to perform most actions.  Every %d damage it takes will reduce the duration of the effect by one turn."):tformat(eff.power) end,
	type = "mental",
	subtype = { sleep=true },
	status = "detrimental",
	parameters = { power=1, insomnia=1, waking=0, contagious=0 },
	on_gain = function(self, err) return _t"#Target# has been put to sleep.", _t"+Sleep" end,
	on_lose = function(self, err) return _t"#Target# is no longer sleeping.", _t"-Sleep" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		elseif eff.contagious > 0 and eff.dur > 1 then
			local t = eff.src:getTalentFromId(eff.src.T_SLEEP)
			t.doContagiousSleep(eff.src, self, eff, t)
		end
		if eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "SLUMBER", image = "talents/slumber.png",
	desc = _t"Slumber",
	long_desc = function(self, eff) return ("The target is in a deep sleep and unable to perform most actions.  Every %d damage it takes will reduce the duration of the effect by one turn."):tformat(eff.power) end,
	type = "mental",
	subtype = { sleep=true },
	status = "detrimental",
	parameters = { power=1, insomnia=1, waking=0 },
	on_gain = function(self, err) return _t"#Target# is in a deep sleep.", _t"+Slumber" end,
	on_lose = function(self, err) return _t"#Target# is no longer sleeping.", _t"-Slumber" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		elseif eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "NIGHTMARE", image = "talents/nightmare.png",
	desc = _t"Nightmare",
	long_desc = function(self, eff) return ("The target is in a nightmarish sleep, suffering %0.2f mind damage each turn and unable to to perform most actions.  Every %d damage it takes will reduce the duration of the effect by one turn."):tformat(eff.dam, eff.power) end,
	type = "mental",
	subtype = { nightmare=true, sleep=true },
	status = "detrimental",
	parameters = { power=1, dam=0, insomnia=1, waking=0},
	on_gain = function(self, err) return _t"#F53CBE##Target# is lost in a nightmare.", _t"+Nightmare" end,
	on_lose = function(self, err) return _t"#Target# is free from the nightmare.", _t"-Nightmare" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		else
			-- Store the power for later
			local real_power = eff.temp_power or eff.power
			-- Temporarily spike the temp_power so the nightmare doesn't break it
			eff.temp_power = 10000
			DamageType:get(DamageType.DARKNESS).projector(eff.src or self, self.x, self.y, DamageType.DARKNESS, eff.dam)
			-- Set the power back to its baseline
			eff.temp_power = real_power
		end
		if eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "RESTLESS_NIGHT", image = "talents/restless_night.png",
	desc = _t"Restless Night",
	long_desc = function(self, eff) return ("Fatigue from poor sleep, dealing %0.2f mind damage per turn."):tformat(eff.power) end,
	type = "mental",
	subtype = { psionic=true},
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return _t"#Target# had a restless night.", _t"+Restless Night" end,
	on_lose = function(self, err) return _t"#Target# has recovered from poor sleep.", _t"-Restless Night" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.power)
	end,
}

newEffect{
	name = "INSOMNIA", image = "effects/insomnia.png",
	desc = _t"Insomnia",
	long_desc = function(self, eff) return ("The target is wide awake and has %d%% resistance to sleep effects."):tformat(eff.cur_power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=0 },
	on_gain = function(self, err) return _t"#Target# is suffering from insomnia.", _t"+Insomnia" end,
	on_lose = function(self, err) return _t"#Target# is no longer suffering from insomnia.", _t"-Insomnia" end,
	on_merge = function(self, old_eff, new_eff)
		-- Add the durations on merge
		local dur = old_eff.dur + new_eff.dur
		old_eff.dur = math.min(10, dur)
		old_eff.cur_power = old_eff.power * old_eff.dur
		-- Need to remove and re-add the effect
		self:removeTemporaryValue("sleep_immune", old_eff.sid)
		old_eff.sid = self:addTemporaryValue("sleep_immune", old_eff.cur_power/100)
		return old_eff
	end,
	on_timeout = function(self, eff)
		-- Insomnia only ticks when we're awake
		if self:attr("sleep") and self:attr("sleep") > 0 then
			eff.dur = eff.dur + 1
		else
			-- Deincrement the power
			eff.cur_power = eff.power * eff.dur
			self:removeTemporaryValue("sleep_immune", eff.sid)
			eff.sid = self:addTemporaryValue("sleep_immune", eff.cur_power/100)
		end
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power * eff.dur
		eff.sid = self:addTemporaryValue("sleep_immune", eff.cur_power/100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep_immune", eff.sid)
	end,
}

newEffect{
	name = "SUNDER_MIND", image = "talents/sunder_mind.png",
	desc = _t"Sundered Mind",
	long_desc = function(self, eff) return ("The target's mental faculties have been impaired, reducing its mental save by %d."):tformat(eff.cur_power or eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "detrimental",
	on_gain = function(self, err) return _t"#Target#'s mental functions have been impaired.", _t"+Sundered Mind" end,
	on_lose = function(self, err) return _t"#Target# regains its senses.", _t"-Sundered Mind" end,
	parameters = { power=10 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_mentalresist", old_eff.sunder)
		old_eff.cur_power = old_eff.cur_power + new_eff.power
		old_eff.sunder = self:addTemporaryValue("combat_mentalresist", -old_eff.cur_power)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.sunder = self:addTemporaryValue("combat_mentalresist", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.sunder)
	end,
}

newEffect{
	name = "BROKEN_DREAM", image = "effects/broken_dream.png",
	desc = _t"Broken Dream",
	long_desc = function(self, eff) return ("The target's dreams have been broken by the dreamforge, reducing its mental save by %d and reducing its chance of successfully casting a spell by %d%%."):tformat(eff.power, eff.fail) end,
	type = "mental",
	subtype = { psionic=true, morale=true },
	status = "detrimental",
	on_gain = function(self, err) return _t"#Target#'s dreams have been broken.", _t"+Broken Dream" end,
	on_lose = function(self, err) return _t"#Target# regains hope.", _t"-Broken Dream" end,
	parameters = { power=10, fail=10 },
	activate = function(self, eff)
		eff.silence = self:addTemporaryValue("spell_failure", eff.fail)
		eff.sunder = self:addTemporaryValue("combat_mentalresist", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("spell_failure", eff.silence)
		self:removeTemporaryValue("combat_mentalresist", eff.sunder)
	end,
}

newEffect{
	name = "FORGE_SHIELD", image = "talents/block.png",
	desc = _t"Forge Shield",
	long_desc = function(self, eff)
		local e_string = ""
		if eff.number == 1 then
			e_string = DamageType.dam_def[next(eff.d_types)].name
		else
			local list = table.keys(eff.d_types)
			for i = 1, #list do
				list[i] = DamageType.dam_def[list[i]].name
			end
			e_string = table.concat(list, ", ")
		end
		local function tchelper(first, rest)
		  return first:upper()..rest:lower()
		end
		return ("Absorbs %d damage from the next blockable attack.  Currently Blocking: %s."):tformat(eff.power, e_string:gsub("(%a)([%w_']*)", tchelper))
	end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
		damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1}, {type="shield", time_factor=-8000, llpow=1, aadjust=7, color={1, 0.5, 0}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=0.5, b=0.0, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "HIDDEN_RESOURCES", image = "talents/hidden_resources.png",
	desc = _t"Hidden Resources",
	long_desc = function(self, eff) return _t"The target does not consume any resources." end,
	type = "mental",
	subtype = { willpower=true },
	status = "beneficial",
	on_gain = function(self, err) return _t"#Target#'s focuses.", _t"+Hidden Ressources" end,
	on_lose = function(self, err) return _t"#Target#'s loses some focus.", _t"-Hidden Ressources" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "force_talent_ignore_ressources", 1)
	end,
}

newEffect{
	name = "SPELL_FEEDBACK", image = "talents/spell_feedback.png",
	desc = _t"Spell Feedback",
	long_desc = function(self, eff) return ("The target suffers %d%% spell failue."):tformat(eff.power) end,
	type = "mental",
	subtype = { nature=true },
	status = "detrimental",
	on_gain = function(self, err) return _t"#Target# is surrounded by antimagic forces.", _t"+Spell Feedback" end,
	on_lose = function(self, err) return _t"#Target#'s antimagic forces vanishes.", _t"-Spell Feedback" end,
	parameters = { power=40 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "spell_failure", eff.power)
	end,
}

newEffect{
	name = "MIND_PARASITE", image = "talents/mind_parasite.png",
	desc = _t"Mind Parasite",
	long_desc = function(self, eff) return ("The target is infected with a mind parasite. Each time it uses a talent it has a %d%% chance to have %d random talent(s) put on cooldown for %d turns."):tformat(eff.chance, eff.nb, eff.turns) end,
	type = "mental",
	subtype = { nature=true, mind=true },
	status = "detrimental",
	on_gain = function(self, err) return _t"#Target# is infected with a mind parasite.", _t"+Mind Parasite" end,
	on_lose = function(self, err) return _t"#Target# is free from the mind parasite.", _t"-Mind Parasite" end,
	parameters = { chance=40, nb=1, turns=2 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use", eff.chance)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use_nb", eff.nb)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use_turns", eff.turns)
	end,
}

newEffect{
	name = "MINDLASH", image = "talents/mindlash.png",
	desc = _t"Mindlash",
	long_desc = function(self, eff) return ("Repeated mindlash usage is very taxing increasing the psi cost each time (currently %d%%)"):tformat(eff.power * 100) end,
	type = "mental",
	subtype = { mind=true },
	status = "detrimental",
	parameters = {  },
	on_merge = function(self, old_eff, new_eff)
		new_eff.power = old_eff.power + 1
		return new_eff
	end,
	activate = function(self, eff)
		eff.power = 2
	end,
}

newEffect{
	name = "SHADOW_EMPATHY", image = "talents/shadow_empathy.png",
	desc = _t"Shadow Empathy",
	long_desc = function(self, eff) return ("%d%% of all damage is redirected to a random shadow."):tformat(eff.power) end,
	type = "mental",
	subtype = { mind=true, shield=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "shadow_empathy", eff.power)
		eff.particle = self:addParticles(Particles.new("darkness_power", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "SHADOW_DECOY", image = "talents/shadow_decoy.png",
	desc = _t"Shadow Decoy",
	long_desc = function(self, eff) return ("A random shadow absorbed a fatal blow for you, granting you a negative shield of %d."):tformat(eff.power) end,
	type = "mental",
	subtype = { mind=true, shield=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.power)
		self:effectParticles(eff, {type="darkness_power"})
		if core.shader.active() then
			self:effectParticles(eff, {type="circle", args={shader=true, oversize=1.5, a=225, appear=8, speed=0, img="shadow_decoy_aura", base_rot=0, radius=0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CRYSTAL_BUFF", image = "talents/stone_touch.png",
	desc = _t"Crystal Resonance",
	--Might consider adding the gem properties to this tooltip
	long_desc = function(self, eff) return ("The power released by the %s resonates."):tformat(eff.name) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return _t"#Target# glints with a crystaline aura", _t"+Crystal Resonance" end,
	on_lose = function(self, err) return _t"#Target# is no longer glinting.", _t"-Crystal Resonance" end,
	activate = function(self, eff)
		for a, b in pairs(eff.effects) do
			self:effectTemporaryValue(eff, a, b)
		end
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "WEAPON_WARDING", image = "talents/warding_weapon.png",
	desc = _t"Weapon Warding",
	long_desc = function(self, eff) return ("Target is using %s telekinetically wielded weapon defensively and will block the next melee attack and retaliate."):tformat(string.his_her(self)) end,
	type = "mental",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	do_block = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed") then return end

		self:removeEffect(self.EFF_WEAPON_WARDING)
		if self:getInven(self.INVEN_PSIONIC_FOCUS) then
			local t = self:getTalentFromId(self.T_WARDING_WEAPON)
			for i, o in ipairs(self:getInven(self.INVEN_PSIONIC_FOCUS)) do
				if o.combat and not o.archery then
					self:logCombat(target, "#CRIMSON##Source# blocks #Target#'s attack and retaliates with %s telekinetically wielded weapon!#LAST#", string.his_her(self))
					self:attackTargetWith(target, o.combat, nil, t.getWeaponDamage(self, t))
				end
			end
			if self:getTalentLevelRaw(t) >= 3 and target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, 3, {apply_power=self:combatMindpower()})
			end
		end
		return true
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "THOUGHTSENSE", image = "talents/thought_sense.png",
	desc = _t"Thought Sense",
	long_desc = function(self, eff) return ("Detect nearby thoughts, revealing creature locations in a radius of %d and boosting defense by %d."):tformat(eff.range, eff.def) end,
	type = "mental",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "detect_range", eff.range)
		self:effectTemporaryValue(eff, "detect_actor", 1)
		self:effectTemporaryValue(eff, "combat_def", eff.def)
		game.level.map.changed = true
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.5, a=225, appear=8, speed=0, img="thoughtsense", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
}

newEffect{
	name = "STATIC_CHARGE", image = "talents/static_net.png",
	desc = _t"Static Charge",
	long_desc = function(self, eff) return ("You have accumulated an electric charge. Your next melee hit does %d extra lightning damage."):tformat(eff.power) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.power = new_eff.power + old_eff.power
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("hand1", true) if h1x then eff.particle1 = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.3, a=185, appear=8, speed=0, img="transcend_electro", base_rot=0, radius=0, x=h1x, y=h1y})) end
			local h2x, h2y = self:attachementSpot("hand2", true) if h2x then eff.particle2 = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.3, a=185, appear=8, speed=0, img="transcend_electro", base_rot=0, radius=0, x=h2x, y=h2y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle1 then self:removeParticles(eff.particle1) end
		if eff.particle2 then self:removeParticles(eff.particle2) end
	end,
}

newEffect{
	name = "HEART_STARTED", image = "talents/heartstart.png",
	desc = _t"Heart Started",
	long_desc = function(self, eff) return ("A psionic charge is keeping your heart pumping, allowing you to survive to %+d health."):tformat(-eff.power) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "TRANSCENDENT_TELEKINESIS", image = "talents/transcendent_telekinesis.png",
	desc = _t"Transcendent Telekinesis",
	long_desc = function(self, eff) return ("Your telekinesis transcends normal limits. +%d Physical damage and +%d%% Physical damage penetration, and improved kinetic effects."):tformat(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { physical=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.PHYSICAL]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.PHYSICAL]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_tele", radius=0}))
		self:callTalent(self.T_KINETIC_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_KINETIC_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "TRANSCENDENT_PYROKINESIS", image = "talents/transcendent_pyrokinesis.png",
	desc = _t"Transcendent Pyrokinesis",
	long_desc = function(self, eff) return ("Your pyrokinesis transcends normal limits. +%d%% Fire/Cold damage and +%d%% Fire/Cold damage penetration, and improved thermal effects."):tformat(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { fire=true, cold=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0, weaken = 0},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=eff.power, [DamageType.COLD]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.FIRE]=eff.penetration, [DamageType.COLD]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_pyro", radius=0}))
		self:callTalent(self.T_THERMAL_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_THERMAL_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "TRANSCENDENT_ELECTROKINESIS", image = "talents/transcendent_electrokinesis.png",
	desc = _t"Transcendent Electrokinesis",
	long_desc = function(self, eff) return ("Your electrokinesis transcends normal limits. +%d%% Lightning damage and +%d%% Lightning damage penetration, and improved charged effects."):tformat(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.LIGHTNING]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_electro", radius=0}))
		self:callTalent(self.T_CHARGED_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_CHARGED_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "PSI_DAMAGE_SHIELD", image = "talents/barrier.png",
	desc = _t"Psionic Damage Shield",
	long_desc = function(self, eff) return ("The target is surrounded by a psionic shield, absorbing %d/%d damage before it crumbles."):tformat(self.damage_shield_absorb, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return _t"A psionic shield forms around #target#.", _t"+Shield" end,
	on_lose = function(self, err) return _t"The psionic shield around #target# crumbles.", _t"-Shield" end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_DAMAGE_SHIELD)
		eff.tmpid = self:addTemporaryValue("damage_shield", eff.power)
		if eff.reflect then eff.refid = self:addTemporaryValue("damage_shield_reflect", eff.reflect) end
		--- Warning there can be only one time shield active at once for an actor
		self.damage_shield_absorb = eff.power
		self.damage_shield_absorb_max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {a=eff.shield_transparency or 1, size_factor=1.4, img="shield3"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor=colors.hex1alpha"9fe836a0", auraColor=colors.hex1alpha"36bce8da"}))
		else
			eff.particle = self:addParticles(Particles.new("damage_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("damage_shield", eff.tmpid)
		if eff.refid then self:removeTemporaryValue("damage_shield_reflect", eff.refid) end
		self.damage_shield_absorb = nil
		self.damage_shield_absorb_max = nil
	end,
}

newEffect{
	name = "UNSEEN_FORCE", desc = _t"Unseen Force",
	image="talents/unseen_force.png",
	long_desc = function(self, eff)
		local hits = (eff.extrahit > 0 and ("from %d to %d"):tformat(eff.hits, eff.hits + 1) or ("%s"):tformat(eff.hits))
		return ("An unseen force strikes %s targets in a range of %d around this creature every turn, doing %d damage and knocking them back for %d tiles."):tformat(hits, eff.range, eff.damage, eff.knockback) end,
	type = "mental",
	subtype = {psionic=true},
	status = "beneficial",
	activate = function(self, eff)
		game.logSeen(self, "An unseen force begins to swirl around %s!", self:getName())
		eff.particles = self:addParticles(Particles.new("force_area", 1, { radius = self:getTalentRange(self.T_UNSEEN_FORCE) }))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particles)
		game.logSeen(self, "The unseen force around %s subsides.", self:getName())
	end,
	on_timeout = function(self, eff)
		local targets = {}
		local grids = core.fov.circle_grids(self.x, self.y, eff.range, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, Map.ACTOR)
				if a and self:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
					targets[#targets+1] = a
				end
			end
		end

		if #targets > 0 then
			local hitCount = eff.hits
			if rng.percent(eff.extrahit) then hitCount = hitCount + 1 end

			local t = self:getTalentFromId(self.T_WILLFUL_STRIKE)
			-- Randomly take targets
			local sample = rng.tableSample(targets, hitCount)
			for _, target in ipairs(sample) do
				t.forceHit(self, t, target, target.x, target.y, eff.damage, eff.knockback, 7, 0.6, 10)
			end
		end
	end,
}

newEffect{
	name = "PSIONIC_MAELSTROM", image = "talents/psionic_maelstrom.png",
	desc = _t"Psionic Maelstrom",
	long_desc = function(self, eff) return ("This creature is standing in the eye of a powerful storm of psionic forces."):tformat() end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	activate = function(self, eff)
		eff.dir = 0--rng.range(0, 7)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		local tg = {type="beam", range=4, selffire=false}
		local x, y
		if eff.kinetic then
			x = self.x+math.modf(4*math.sin(math.pi*eff.dir/4))
			y = self.y+math.modf(4*math.cos(math.pi*eff.dir/4))
			self:project(tg, x, y, engine.DamageType.PHYSICAL, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "matter_beam", {tx=x-self.x, ty=y-self.y})
		end
		if eff.charged then
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+4)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+4)/4))
			self:project(tg, x, y, engine.DamageType.LIGHTNING, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning_beam", {tx=x-self.x, ty=y-self.y}, {type="lightning"})
			else game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning_beam", {tx=x-self.x, ty=y-self.y})
			end
		end
		if eff.thermal then
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+2)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+2)/4))
			self:project(tg, x, y, engine.DamageType.FIRE, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "flamebeam", {tx=x-self.x, ty=y-self.y})
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+6)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+6)/4))
			self:project(tg, x, y, engine.DamageType.COLD, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "ice_beam", {tx=x-self.x, ty=y-self.y})
		end
		eff.dir = eff.dir+1
	end,
}

newEffect{
	name = "CAUGHT_LIGHTNING", image = "talents/transcendent_electrokinesis.png",
	desc = _t"Caught Lightning",
	long_desc = function(self, eff) return ("Lightning Catcher has caught energy and is empowering you for +%d%% lightning damage and +%d to all stats."):tformat((eff.dur+1)*5, eff.dur+1) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = {  },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.min(old_eff.dur + new_eff.dur, 10)
		return old_eff
	end,
	activate = function(self, eff)
		eff.lightning = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING]=eff.dur*5})
		eff.stats = self:addTemporaryValue("inc_stats", { 
			[Stats.STAT_STR] = eff.dur,
			[Stats.STAT_DEX] = eff.dur,
			[Stats.STAT_CON] = eff.dur,
			[Stats.STAT_MAG] = eff.dur,
			[Stats.STAT_WIL] = eff.dur,
			[Stats.STAT_CUN] = eff.dur,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.lightning)
		self:removeTemporaryValue("inc_stats", eff.stats)
	end,
	on_timeout = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.lightning)
		self:removeTemporaryValue("inc_stats", eff.stats)
		eff.lightning = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING]=eff.dur*5})
		eff.stats = self:addTemporaryValue("inc_stats", { 
			[Stats.STAT_STR] = eff.dur,
			[Stats.STAT_DEX] = eff.dur,
			[Stats.STAT_CON] = eff.dur,
			[Stats.STAT_MAG] = eff.dur,
			[Stats.STAT_WIL] = eff.dur,
			[Stats.STAT_CUN] = eff.dur,
		})
	end,
}