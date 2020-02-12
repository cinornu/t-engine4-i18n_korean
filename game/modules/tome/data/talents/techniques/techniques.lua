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

-- Physical combat
newTalentType{ allow_random=true, type="technique/2hweapon-assault", name = _t"two-handed assault", description = _t"Specialized two-handed techniques." }
newTalentType{ allow_random=true, type="technique/strength-of-the-berserker", name = _t"berserker's strength", description = _t"Fear nothing!" }
newTalentType{ allow_random=true, type="technique/2hweapon-offense", name = _t"two-handed weapons", description = _t"Specialized two-handed techniques." }
newTalentType{ allow_random=true, type="technique/2hweapon-cripple", name = _t"two-handed maiming", description = _t"Specialized two-handed techniques." }
newTalentType{ allow_random=true, type="technique/shield-offense", name = _t"shield offense", speed = "shield", description = _t"Specialized weapon and shield techniques." }
newTalentType{ allow_random=true, type="technique/shield-defense", name = _t"shield defense", speed = "shield", description = _t"Specialized weapon and shield techniques." }
newTalentType{ allow_random=true, type="technique/dualweapon-training", name = _t"dual weapons", description = _t"Specialized dual wielding techniques." }
newTalentType{ allow_random=true, type="technique/dualweapon-attack", name = _t"dual techniques", description = _t"Specialized dual wielding techniques." }
newTalentType{ allow_random=true, type="technique/archery-base", name = _t"archery - base", description = _t"Ability to shoot." }
newTalentType{ allow_random=true, type="technique/archery-bow", name = _t"archery - bows", description = _t"Specialized bow techniques." }
newTalentType{ allow_random=true, type="technique/archery-sling", name = _t"archery - slings", description = _t"Specialized sling techniques." }
newTalentType{ allow_random=true, type="technique/archery-training", name = _t"archery training", description = _t"Generic archery techniques." }
newTalentType{ allow_random=true, type="technique/archery-utility", name = _t"archery prowess", description = _t"Specialized archery techniques to maim your targets." }
newTalentType{ allow_random=true, type="technique/archery-excellence", name = _t"archery excellence", min_lev = 10, description = _t"Specialized archery techniques that result from honed training." }
newTalentType{ allow_random=true, type="technique/superiority", name = _t"superiority", min_lev = 10, description = _t"Advanced combat techniques." }
newTalentType{ allow_random=true, type="technique/battle-tactics", name = _t"battle tactics", min_lev = 10, description = _t"Advanced combat tactics." }
newTalentType{ allow_random=true, type="technique/warcries", name = _t"warcries", no_silence = true, min_lev = 10, description = _t"Master the warcries to improve yourself and weaken others." }
newTalentType{ allow_random=true, type="technique/bloodthirst", name = _t"bloodthirst", min_lev = 10, description = _t"Delight in the act of battle and the spilling of blood." }
newTalentType{ allow_random=true, type="technique/field-control", name = _t"field control", generic = true, description = _t"Control the battlefield using various techniques." }
newTalentType{ allow_random=true, type="technique/combat-techniques-active", name = _t"combat techniques", description = _t"Generic combat oriented techniques." }
newTalentType{ allow_random=true, type="technique/combat-techniques-passive", name = _t"combat veteran", description = _t"Generic combat oriented techniques." }
newTalentType{ allow_random=true, type="technique/combat-training", name = _t"combat training", generic = true, description = _t"Teaches to use various armours, weapons and improves health." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="technique/magical-combat", name = _t"magical combat", description = _t"The blending together of magic and melee prowess." }
newTalentType{ allow_random=true, type="technique/mobility", name = _t"mobility", generic = true, description = _t"Training and techniques to improve mobility and evade your enemies.  On the battlefield, positioning is paramount." }
newTalentType{ allow_random=true, type="technique/thuggery", name = _t"thuggery", generic = true, description = _t"Whatever wins the day, wins the day." }
newTalentType{ allow_random=true, type="technique/assassination", name = _t"assassination", min_lev=10, description = _t"Bring death from the shadows." }
newTalentType{ allow_random=true, type="technique/throwing-knives", name = _t"throwing knives", description = _t"Master the art of throwing knives to fight from a distance." }
newTalentType{ allow_random=true, type="technique/duelist", name = _t"duelist", description = _t"Use your dual weapons to parry and counter." }
newTalentType{ allow_random=true, type="technique/marksmanship", name = _t"marksmanship", description = _t"Training in the use of bows and slings." }
newTalentType{ allow_random=true, type="technique/reflexes", name = _t"reflexes", description = _t"Use your reflexes to evade and counter." }
newTalentType{ allow_random=true, type="technique/munitions", min_lev = 10, name = _t"munitions", description = _t"Equip specialised ammunition." }
newTalentType{ allow_random=true, type="technique/agility", min_lev = 10, name = _t"agility", description = _t"Take advantage of speed and shield to fight in close quarters." }
newTalentType{ allow_random=true, type="technique/sniper", min_lev = 10, name = _t"sniper", description = _t"Stealth and specialised long range archery techniques." }

-- Skirmisher
newTalentType {
  type = "technique/acrobatics",
  name = _t"Acrobatics",
  generic = true,
  allow_random = true,
  description = _t"For light footed Rogues who prefer flight to fighting fair!",
}

newTalentType {
  type = "technique/buckler-training",
  name = _t"Buckler Training",
  allow_random = true,
  description = _t"Mastery over their shields separates Skirmishers from Archers, and gives them an edge.",
}

newTalentType {
  type = "technique/skirmisher-slings",
  name = _t"Skirmisher - Slings",
  allow_random = true,
  description = _t"Slings! Pow Pow!",
}

newTalentType {
  type = "technique/tireless-combatant",
  name = _t"Tireless Combatant",
  allow_random = true,
  description = _t"Your will carries you through the most difficult struggles, allowing you to fight on when others would have collapsed from exhaustion.",
}

-- Unarmed Combat
newTalentType{ is_unarmed=true, allow_random=true, type="technique/pugilism", name = _t"pugilism", description = _t"Unarmed Boxing techniques that may not be practiced in massive armor or while a weapon or shield is equipped." }
newTalentType{ is_unarmed=true, allow_random=true, type="technique/finishing-moves", name = _t"finishing moves", description = _t"Finishing moves that use combo points and may not be practiced in massive armor or while a weapon or shield is equipped." }
newTalentType{ is_unarmed=true, allow_random=true, type="technique/grappling", name = _t"grappling", description = _t"Grappling techniques that may not be practiced in massive armor or while a weapon or shield is equipped." }
newTalentType{ is_unarmed=true, allow_random=true, type="technique/unarmed-discipline", name = _t"unarmed discipline", description = _t"Advanced unarmed techniques including kicks and blocks that may not be practiced in massive armor or while a weapon or shield is equipped." }
newTalentType{ is_unarmed=true, allow_random=true, generic = true, type="technique/unarmed-training", name = _t"unarmed training", description = _t"Teaches various martial arts techniques that may not be practiced in massive armor or while a weapon or shield is equipped." }
newTalentType{ allow_random=true, type="technique/conditioning", name = _t"conditioning", generic = true, description = _t"Physical conditioning." }

newTalentType{ is_unarmed=true, type="technique/unarmed-other", name = _t"unarmed other", generic = true, description = _t"Base martial arts attack and stances." }



-- Generic requires for techs based on talent level
-- Uses STR
techs_req1 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
} end
techs_req2 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
} end
techs_req3 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
} end
techs_req4 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
} end
techs_req5 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
} end
techs_req_high1 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
} end
techs_req_high2 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
} end
techs_req_high3 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
} end
techs_req_high4 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
} end
techs_req_high5 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
} end

-- Generic requires for techs_dex based on talent level
techs_dex_req1 = {
	stat = { dex=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
techs_dex_req2 = {
	stat = { dex=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
techs_dex_req3 = {
	stat = { dex=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
techs_dex_req4 = {
	stat = { dex=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
techs_dex_req5 = {
	stat = { dex=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
techs_dex_req_high1 = {
	stat = { dex=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
techs_dex_req_high2 = {
	stat = { dex=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
techs_dex_req_high3 = {
	stat = { dex=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
techs_dex_req_high4 = {
	stat = { dex=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
techs_dex_req_high5 = {
	stat = { dex=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}


-- Generic rquires based either on str or dex
techs_strdex_req1 = function(self, t) local stat = self:getStr() >= self:getDex() and "str" or "dex"; return {
	stat = { [stat]=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
} end
techs_strdex_req2 = function(self, t) local stat = self:getStr() >= self:getDex() and "str" or "dex"; return {
	stat = { [stat]=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
} end
techs_strdex_req3 = function(self, t) local stat = self:getStr() >= self:getDex() and "str" or "dex"; return {
	stat = { [stat]=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
} end
techs_strdex_req4 = function(self, t) local stat = self:getStr() >= self:getDex() and "str" or "dex"; return {
	stat = { [stat]=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
} end
techs_strdex_req5 = function(self, t) local stat = self:getStr() >= self:getDex() and "str" or "dex"; return {
	stat = { [stat]=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
} end

-- Generic requires for techs_con based on talent level
techs_con_req1 = {
	stat = { con=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
techs_con_req2 = {
	stat = { con=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
techs_con_req3 = {
	stat = { con=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
techs_con_req4 = {
	stat = { con=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
techs_con_req5 = {
	stat = { con=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

-- Generic requires for techs_cun based on talent level
techs_cun_req1 = {
	stat = { cun=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
techs_cun_req2 = {
	stat = { cun=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
techs_cun_req3 = {
	stat = { cun=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
techs_cun_req4 = {
	stat = { cun=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
techs_cun_req5 = {
	stat = { cun=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

-- Generic requires for techs_wil based on talent level
techs_wil_req1 = {
	stat = { wil=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
techs_wil_req2 = {
	stat = { wil=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
techs_wil_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
techs_wil_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
techs_wil_req5 = {
	stat = { wil=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

-- Unarmed stance changes and stance damage bonuses
getStrikingStyle = function(self, dam)
	local dam = 0
	if self:isTalentActive(self.T_STRIKING_STANCE) then
		local t = self:getTalentFromId(self.T_STRIKING_STANCE)
		dam = t.getDamage(self, t)
	end
	return dam / 100
end

-- Used for grapples and other unarmed attacks that don't rely on glove or gauntlet damage
getUnarmedTrainingBonus = function(self)
	local t = self:getTalentFromId(self.T_UNARMED_MASTERY)
	local damage = t.getPercentInc(self, t) or 0
	return damage + 1
end

cancelStances = function(self)
	if self.cancelling_stances then return end
	local stances = {self.T_STRIKING_STANCE, self.T_GRAPPLING_STANCE}
	self.cancelling_stances = true
	for i, t in ipairs(stances) do
		if self:isTalentActive(t) then
			self:forceUseTalent(t, {ignore_energy=true, ignore_cd=true})
		end
	end
	self.cancelling_stances = nil
end

-- Use the appropriate amount of stamina. Return false if we don't have enough.
use_stamina = function(self, cost)
	cost = cost * (1 + self:combatFatigue() * 0.01)
	local available = self:getStamina()
	if self:hasEffect("EFF_ADRENALINE_SURGE") then
		available = available + self.life
	end
	if cost > available then return end
	self:incStamina(-cost)
	return true
end

venomous_throw_check = function(self)
	if not self:knowTalent(self.T_VENOMOUS_THROW) then
		if self:knowTalent(self.T_VENOMOUS_STRIKE) and self:knowTalent(self.T_THROWING_KNIVES) then
			self:learnTalent(self.T_VENOMOUS_THROW, true, nil, {no_unlearn=true})
		end
	else
		if not self:knowTalent(self.T_VENOMOUS_STRIKE) or not self:knowTalent(self.T_THROWING_KNIVES) then
			self:unlearnTalent(self.T_VENOMOUS_THROW)
		end
	end
end

archeryWeaponCheck = function(self, weapon, ammo, silent, weapon_type)
	if not weapon then
		if not silent then
			-- ammo contains error message
			game.logPlayer(self, ({
				["disarmed"] = _t"You are currently disarmed and cannot use this talent.",
				["no shooter"] = ("You require a %s to use this talent."):tformat(weapon_type or _t"missile launcher"),
				["no ammo"] = _t"You require ammo to use this talent.",
				["bad ammo"] = _t"Your ammo cannot be used.",
				["incompatible ammo"] = _t"Your ammo is incompatible with your missile launcher.",
				["incompatible missile launcher"] = ("You require a %s to use this talent."):tformat(weapon_type or _t"bow"),
			})[ammo] or _t"You require a missile launcher and ammo for this talent.")
		end
		return false
	else
		local infinite = ammo and ammo.infinite or self:attr("infinite_ammo")
		if not ammo or (ammo.combat.shots_left <= 0 and not infinite) then
			if not silent then game.logPlayer(self, "You do not have enough ammo left!") end
			return false
		end
	end
	return true
end

archerPreUse = function(self, t, silent, weapon_type)
	local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon(weapon_type)
	weapon = weapon or pf_weapon
	return archeryWeaponCheck(self, weapon, ammo, silent, weapon_type)
end

wardenPreUse = function(self, t, silent, weapon_type)
	local weapon, ammo, offweapon, pf_weapon = self:hasArcheryWeapon(weapon_type)
	weapon = weapon or pf_weapon
	if self:attr("warden_swap") and not weapon and weapon_type == nil or weapon_type == "bow" then
		weapon, ammo = doWardenPreUse(self, "bow")
	end
	return archeryWeaponCheck(self, weapon, ammo, silent, weapon_type)
end

--- Warden weapon functions
-- Checks for weapons in main and quickslot
doWardenPreUse = function(self, weapon, silent)
	if weapon == "bow" then
		local bow, ammo, oh, pf_bow= self:hasArcheryWeapon("bow")
		if not bow and not pf_bow then
			bow, ammo, oh, pf_bow= self:hasArcheryWeaponQS("bow")
		end
		return bow or pf_bow, ammo
	end
	if weapon == "dual" then
		local mh, oh = self:hasDualWeapon()
		if not mh then
			mh, oh = self:hasDualWeaponQS()
		end
		return mh, oh
	end
end

-- Swaps weapons if needed
doWardenWeaponSwap = function(self, t, type, silent)
	local swap = false
	local mainhand, offhand, ammo, pf_weapon
	
	if type == "blade" then
		mainhand, offhand = self:hasDualWeapon()
		if not mainhand and self:hasDualWeapon(nil, nil, true) then  -- weird but this is lets ogers offhanding daggers still swap
		
			swap = true
		end
	end
	if type == "bow" then
		mainhand, offhand, ammo, pf_weapon = self:hasArcheryWeapon("bow")
		if not mainhand and not pf_weapon then
			mainhand, offhand, ammo, pf_weapon = self:hasArcheryWeapon("bow", true)
			if mainhand or pf_weapon then swap = true end
		end
	end
	
	if swap == true then
		local old_inv_access = self.no_inventory_access -- Make sure clones can swap
		self.no_inventory_access = nil
		self:attr("no_sound", 1)
		self:quickSwitchWeapons(true, "warden", silent)
		self:attr("no_sound", -1)
		self.no_inventory_access = old_inv_access
	end
	return swap
end

load("/data/talents/techniques/2hweapon.lua")
load("/data/talents/techniques/2h-assault.lua")
load("/data/talents/techniques/strength-of-the-berserker.lua")
load("/data/talents/techniques/dualweapon.lua")
load("/data/talents/techniques/weaponshield.lua")
load("/data/talents/techniques/superiority.lua")
load("/data/talents/techniques/warcries.lua")
load("/data/talents/techniques/bloodthirst.lua")
load("/data/talents/techniques/battle-tactics.lua")
load("/data/talents/techniques/field-control.lua")
load("/data/talents/techniques/combat-techniques.lua")
load("/data/talents/techniques/combat-training.lua")
load("/data/talents/techniques/archery.lua")
load("/data/talents/techniques/bow.lua")
load("/data/talents/techniques/sling.lua")
load("/data/talents/techniques/excellence.lua")
load("/data/talents/techniques/magical-combat.lua")
load("/data/talents/techniques/mobility.lua")
load("/data/talents/techniques/thuggery.lua")
load("/data/talents/techniques/assassination.lua")
load("/data/talents/techniques/throwing-knives.lua")
load("/data/talents/techniques/duelist.lua")
load("/data/talents/techniques/marksmanship.lua")
load("/data/talents/techniques/reflexes.lua")
load("/data/talents/techniques/sniper.lua")
load("/data/talents/techniques/agility.lua")
load("/data/talents/techniques/munitions.lua")


load("/data/talents/techniques/skirmisher-slings.lua")
load("/data/talents/techniques/buckler-training.lua")
load("/data/talents/techniques/acrobatics.lua")
load("/data/talents/techniques/tireless-combatant.lua")

load("/data/talents/techniques/pugilism.lua")
load("/data/talents/techniques/unarmed-discipline.lua")
load("/data/talents/techniques/finishing-moves.lua")
load("/data/talents/techniques/grappling.lua")
load("/data/talents/techniques/unarmed-training.lua")
load("/data/talents/techniques/conditioning.lua")