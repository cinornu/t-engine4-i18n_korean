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

newTalent{
	name = "Heightened Senses",
	type = {"cunning/survival", 1},
	require = cuns_req1,
	mode = "passive",
	points = 5,
	random_boss_rarity = 50, -- make sure a reasonable number of randbosses don't take this
	sense = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	seePower = function(self, t) return math.max(0, self:combatScale(self:getCun(15, true)*self:getTalentLevel(t), 10, 1, 80, 75, 0.25)) end, --TL 5, cun 100 = 80
	trapDetect = function(self, t) return math.max(0, self:combatScale(self:getTalentLevel(t) * self:getCun(25, true), 10, 3.75, 75, 125, 0.25)) end, -- trap detection power, same formula used for trap power (gain advantage with Danger Sense)
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_CUN then
			self:updateTalentPassives(t)
		end
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "heightened_senses", t.sense(self, t))
		self:talentTemporaryValue(p, "see_invisible", t.seePower(self, t))
		self:talentTemporaryValue(p, "see_stealth", t.seePower(self, t))
		self:talentTemporaryValue(p, "see_traps", t.trapDetect(self, t))
	end,
	autolearn_talent = "T_DISARM_TRAP",
	info = function(self, t)
		return ([[You notice the small things others do not notice, allowing you to "see" creatures in a %d radius even outside of light radius.
		This is not telepathy, however, and it is still limited to line of sight.
		Also, your attention to detail increases stealth detection and invisibility detection by %d, and you gain the ability to detect traps (+%d detect 'power').
		The detection abilities improve with Cunning.]]):
		tformat(t.sense(self,t), t.seePower(self,t), t.trapDetect(self, t))
	end,
}

newTalent{
	name = "Device Mastery",
	type = {"cunning/survival", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	random_boss_rarity = 50, -- make sure a reasonable number of randbosses don't take this
	cdReduc = function(self, t) return self:combatTalentLimit(t, 100, 10, 40) end,
	passives = function(self, t, p) -- slight nerf to compensate for trap disarming ability?
		self:talentTemporaryValue(p, "use_object_cooldown_reduce", t.cdReduc(self, t))
	end,
	autolearn_talent = "T_DISARM_TRAP",
	trapDisarm = function(self, t)
		local tl, power = self:getTalentLevel(t), self:attr("disarm_bonus") or 0
		if tl > 0 then 
			power = power + math.max(0, self:combatScale(tl * self:getCun(25, true), 10, 3.75, 90, 125, 0.25)) -- ~ 90 at TL 5, 100 cunning
		end
		return power
	end,
	info = function(self, t)
		return ([[Your cunning manipulations allow you to use charms (wands, totems and torques) more efficiently, reducing their cooldowns and the power cost of all usable items by %d%%.
		In addition your knowledge of devices allows you to disarm known traps (%d disarm 'power', improves with Cunning).]]):
		tformat(t.cdReduc(self, t), t.trapDisarm(self, t))
	end,
}

newTalent{
	name = "Track",
	type = {"cunning/survival", 3},
	require = cuns_req3,
	points = 5,
	random_ego = "utility",
	cooldown = 20,
	radius = function(self, t) return math.floor(self:combatScale(self:getCun(10, true) * self:getTalentLevel(t), 5, 0, 55, 50)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	no_npc_use = true,
	no_break_stealth = true,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		self:setEffect(self.EFF_SENSE, t.getDuration(self, t), {
			range = rad,
			actor = 1,
		})
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[Sense foes around you in a radius of %d for %d turns.
		The radius will increase with your Cunning.]]):tformat(rad, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Danger Sense",
	type = {"cunning/survival", 4},
	require = cuns_req4,
	points = 5,
	random_boss_rarity = 50, -- make sure a reasonable number of randbosses don't take this
	mode = "passive",
	trapDetect = function(self, t) return math.max(0, self:combatScale(self:getTalentLevel(t) * self:getCun(25, true), 5, 3.75, 35, 125, 0.25)) end, -- bonus trap detection power
	critResist = function(self, t) return self:combatTalentScale(t, 1.3, 5) end,
	getUnseenReduction = function(self, t) return self:combatTalentLimit(t, 1, .1, .25) end, -- Limit < 100%
	savePenalty = function(self, t) return self:combatLimit(self:getTalentLevel(t) * self:getCun(25, true), 5, 20, 0, 10, 125) end, --Limit: best is save @ -5
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_CUN then -- force recalculation of bonuses
			self:updateTalentPassives(t)
		end
	end,
	callbackOnEffectSave = function(self, t, hd) -- Handled by Actor:on_set_temporary_effect
		if not hd.saved then
			local add_save = -t.savePenalty(self, t)
			print("[callbackOnEffectSave]", t.id, "additional save at", add_save) -- table.print(hd, "\thd..")
			hd.saved = self:checkHit(hd.save + add_save, hd.p.apply_power, 0, 95)
		end
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "ignore_direct_crits", t.critResist(self, t))
		self:talentTemporaryValue(p, "unseen_crit_defense", t.getUnseenReduction(self, t))
		self:talentTemporaryValue(p, "see_traps", t.trapDetect(self, t))
	end,
	info = function(self, t)
		return ([[You have an enhanced sense of self preservation, and your keen intuition allows you to sense dangers others miss.
		Your ability to detect traps is enhanced (+%d detect 'power').
		Attacks against you have a %0.1f%% reduced chance to be critical hits, and damage bonuses attackers gain against you for being unseen are reduced by %d%%.
		You also gain an additional chance (at your normal save %+d, effective) to resist detrimental status effects that can be resisted.
		The detection and additional save chance improve with Cunning.]]):
		tformat(t.trapDetect(self, t), t.critResist(self, t), t.getUnseenReduction(self, t)*100, -t.savePenalty(self, t))
	end,
}

newTalent{
	name = "Disarm Trap",
	type = {"base/class", 1},
	no_npc_use = true,
	innate = true,
	points = 1,
	range = 1,
	message = false,
	no_break_stealth = true,
	image = "talents/trap_priming.png",
	target = {type="hit", range=1, nowarning=true, immediate_keys=true, no_lock=false},
	action = function(self, t)
		if self.player then
--			core.mouse.set(game.level.map:getTileToScreen(self.x, self.y, true))
			game.log("#CADET_BLUE#Disarm A Trap: (direction keys to select where to disarm, shift+direction keys to move freely)")
		end
		local tg = self:getTalentTarget(t)
		local x, y, dir = self:getTarget(tg)
		if not (x and y) then return end
		
		dir = util.getDir(x, y, self.x, self.y)
		x, y = util.coordAddDir(self.x, self.y, dir)
		print("Requesting disarm trap", self:getName(), t.id, x, y)
		local t_det = self:attr("see_traps") or 0
		local trap = game.level.map(x, y, engine.Map.TRAP)
		if trap and not trap:knownBy(self) then trap = self:detectTrap(nil, x, y, t_det) end
		if trap then
			local t_dis = self:callTalent(self.T_DEVICE_MASTERY, "trapDisarm")
			print("Found trap", trap.name, x, y)
			if t_dis <= 0 and not self:attr("can_disarm") then
				game.logPlayer(self, "#CADET_BLUE#You don't have the skill to disarm traps.")
			elseif (x == self.x and y == self.y) or self:canMove(x, y) then
				local px, py = self.x, self.y
				mod.class.Actor.move(self, x, y, true) -- temporarily move to make sure trap can trigger properly
				trap:trigger(self.x, self.y, self) -- then attempt to disarm the trap, which may trigger it
				mod.class.Actor.move(self, px, py, true)
			else
				game.logPlayer(self, "#CADET_BLUE#You cannot disarm traps in grids you cannot enter.")
			end
		else
			game.logPlayer(self, "#CADET_BLUE#You don't see a trap there.")
		end
		
		return true
	end,
	info = function(self, t)
		local tdm = self:getTalentFromId(self.T_DEVICE_MASTERY)
		local t_det, t_dis = self:attr("see_traps") or 0, tdm.trapDisarm(self, tdm)
		return ([[You search a nearby grid for a hidden trap (%d detection 'power') and disarm it if possible (%d disarm 'power', based on your skill with %s).
		Disarming a trap requires at least a minimum skill level, and you must be able to enter the trap's grid to manipulate it, though you stay in your current location.  A failed attempt to disarm a trap may trigger it.
		Your skill improves with your your Cunning.]]):tformat(t_det, t_dis, tdm.name)
	end,
}


