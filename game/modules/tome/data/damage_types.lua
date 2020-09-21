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

local print = print
if not config.settings.cheat then print = function() end end

function DamageType.initState(state)
	if state == nil then return {}
	elseif state == true or state == false then return {}
	else return state end
end

-- Loads the implicit crit if one has not been passed.
function DamageType.useImplicitCrit(src, state)
	if state.crit_set then return end
	state.crit_set = true
	if not src.turn_procs then
		state.crit_type = false
		state.crit_power = 1
	else
		state.crit_type = src.turn_procs.is_crit
		state.crit_power = src.turn_procs.crit_power or 1
		src.turn_procs.is_crit = nil
		src.turn_procs.crit_power = nil
	end
end

local useImplicitCrit = DamageType.useImplicitCrit
local initState = DamageType.initState

-- The basic stuff used to damage a grid
setDefaultProjector(function(src, x, y, type, dam, state)
	if not game.level.map:isBound(x, y) then return 0 end

	-- Manage crits.
	state = initState(state)
	useImplicitCrit(src, state)
	local crit_type = state.crit_type
	local crit_power = state.crit_power

	local add_dam = 0
	if not src.turn_procs or not src.turn_procs.damage_type_fix_type then
		if not src._all_damage_convert_recurs and src:attr("all_damage_convert") and src:attr("all_damage_convert_percent") and src.all_damage_convert ~= type then
			local ndam = dam * src.all_damage_convert_percent / 100
			dam = dam - ndam
			local nt = src.all_damage_convert
			src._all_damage_convert_recurs = true
			add_dam = DamageType:get(nt).projector(src, x, y, nt, ndam, state)
			src._all_damage_convert_recurs = nil
			if dam <= 0 then return add_dam end
		end

		if src:attr("elemental_mastery") then
			local ndam = dam * src.elemental_mastery
			local old = src.elemental_mastery
			src.elemental_mastery = nil
			dam = 0
			dam = dam + DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, ndam, state)
			dam = dam + DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, ndam, state)
			dam = dam + DamageType:get(DamageType.LIGHTNING).projector(src, x, y, DamageType.LIGHTNING, ndam, state)
			dam = dam + DamageType:get(DamageType.ARCANE).projector(src, x, y, DamageType.ARCANE, ndam, state)
			src.elemental_mastery = old
			return dam
		end

		if src:attr("twilight_mastery") then
			local ndam = dam * src.twilight_mastery
			local old = src.twilight_mastery
			src.twilight_mastery = nil
			dam = 0
			dam = dam + DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, ndam, state)
			dam = dam + DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, ndam, state)
			src.twilight_mastery = old
			return dam
		end

		if src:attr("darkest_light_mastery") and type == "LIGHT" then
			local ndam = dam * src.darkest_light_mastery
			dam = dam - ndam
			local old = src.darkest_light_mastery
			src.darkest_light_mastery = nil
			add_dam = DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, ndam, state)
			src.darkest_light_mastery = old
			if dam <= 0 then return add_dam end
		end

		if src:attr("darklight") then
			local add_dam = 0
			local ndam = dam * src.darklight / 2
			dam = dam - ndam * 2
			local old = src.darklight
			src.darklight = nil
			add_dam = DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, ndam, state)
			+ DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, ndam, state)
			src.darklight = old
			if dam <= 0 then return add_dam end
		end
	end

	local source_talent = src.__projecting_for and src.__projecting_for.project_type and (src.__projecting_for.project_type.talent_id or src.__projecting_for.project_type.talent) and src.getTalentFromId and src:getTalentFromId(src.__projecting_for.project_type.talent or src.__projecting_for.project_type.talent_id)
	local source_talent_mode = src.__projecting_for and src.__projecting_for.project_type and src.__projecting_for.project_type.talent_mode
	if not source_talent_mode and src.getCurrentTalentMode then source_talent_mode = src:getCurrentTalentMode() end

	local terrain = game.level.map(x, y, Map.TERRAIN)
	if terrain then terrain:check("damage_project", src, x, y, type, dam, source_talent) end

	local target = game.level.map(x, y, Map.ACTOR)
	if target then
		local rsrc = src.resolveSource and src:resolveSource() or src
		local rtarget = target.resolveSource and target:resolveSource() or target

		print("[PROJECTOR] starting dam", type, dam)

		local ignore_direct_crits = target:attr 'ignore_direct_crits'
		if crit_power > 1 and ignore_direct_crits then -- Reduce the post crit damage, we have to do this here since most crits are calculated before knowing their target

			-- Add crit bonus power for being unseen (direct damage only, diminished with range)
			local unseen_crit = src.__is_actor and target.__is_actor and not src.__project_source and src.unseen_critical_power
			if unseen_crit and not target:canSee(src) and src:canSee(target) then
				local d, reduc = core.fov.distance(src.x, src.y, x, y), 0
				if d > 3 then
					reduc = math.scale(d, 3, 10, 0, 1)
					unseen_crit = math.max(0, unseen_crit*(1 - reduc))
				end
				if unseen_crit > 0 then
					if target.unseen_crit_defense and target.unseen_crit_defense > 0 then
						unseen_crit = math.max(0, unseen_crit*(1 - target.unseen_crit_defense))
					end
					crit_power = crit_power + unseen_crit
					print("[PROJECTOR] after unseen_critical_power type/dam/range/power", type, dam, d, unseen_crit, "::", crit_power - unseen_crit, "=>", crit_power)
				end
			end	

			dam = dam / crit_power
			local reduce = (crit_power - 1) * (util.bound(ignore_direct_crits, 0, 100) / 100)
			crit_power = math.max(1, crit_power - reduce)
			dam = dam * crit_power
			print("[PROJECTOR] crit power reduce dam", dam)
		end

		local hd = {"DamageProjector:base", src=src, x=x, y=y, type=type, dam=dam, state=state}
		if src:triggerHook(hd) then dam = hd.dam if hd.stopped then return hd.stopped end end

		-- Difficulty settings
		if game.difficulty == game.DIFFICULTY_EASY and rtarget.player then
			dam = dam * 0.7
		end
		print("[PROJECTOR] after difficulty dam", dam)

		if src.__global_accuracy_damage_bonus then
			dam = dam * src.__global_accuracy_damage_bonus
			print("[PROJECTOR] after staff accuracy damage bonus", dam)
		end

		-- Daze
		if src:attr("dazed") then
			dam = dam * 0.5
		end

		if src:attr("stunned") then
			dam = dam * 0.5
			print("[PROJECTOR] stunned dam", dam)
		end
		if src:attr("invisible_damage_penalty") then
			dam = dam * util.bound(1 - (src.invisible_damage_penalty / (src.invisible_damage_penalty_divisor or 1)), 0, 1)
			print("[PROJECTOR] invisible dam", dam)
		end
		if src:attr("numbed") then
			dam = dam - dam * src:attr("numbed") / 100
			print("[PROJECTOR] numbed dam", dam)
		end
		if src:attr("generic_damage_penalty") then
			dam = dam - dam * math.min(100, src:attr("generic_damage_penalty")) / 100
			print("[PROJECTOR] generic dam", dam)
		end

		-- Preemptive shielding
		if target.isTalentActive and target:isTalentActive(target.T_PREMONITION) then
			local t = target:getTalentFromId(target.T_PREMONITION)
			t.on_damage(target, t, type)
		end

		local lastdam = dam
		-- Item-granted damage ward talent
		if target:hasEffect(target.EFF_WARD) then
			local e = target.tempeffect_def[target.EFF_WARD]
			dam = e.absorb(type, dam, target.tmp[target.EFF_WARD], target, src)
			if dam ~= lastdam then
				game:delayedLogDamage(src, target, 0, ("%s(%d warded)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam-dam), false)
			end
		end

		-- Increases damage
		local mind_linked = false
		local inc = 0
		if src.inc_damage then
			if src.combatGetDamageIncrease then inc = src:combatGetDamageIncrease(type)
			else inc = (src.inc_damage.all or 0) + (src.inc_damage[type] or 0) end
			if src.getVim and src:attr("demonblood_dam") then inc = inc + ((src.demonblood_dam or 0) * (src:getVim() or 0)) end
			if src.attr and src:attr("blind_inc_damage") and (target:attr("blind") or target:attr("dazzled")) then inc = inc + src:attr("blind_inc_damage") end
			if inc ~= 0 then print("[PROJECTOR] after DamageType increase dam", dam + (dam * inc / 100)) end
		end

		-- Increases damage for the entity type (Demon, Undead, etc)
		if target.type and src and src.inc_damage_actor_type then
			local increase = 0
			for k, v in pairs(src.inc_damage_actor_type) do
				if target:checkClassification(tostring(k)) then increase = math.max(increase, v) end
			end
			if increase and increase~= 0 then
				print("[PROJECTOR] before inc_damage_actor_type", dam + (dam * inc / 100))
				inc = inc + increase
				print("[PROJECTOR] after inc_damage_actor_type", dam + (dam * inc / 100))
			end
		end

		-- Increases damage to sleeping targets
		if target:attr("sleep") and src.attr and src:attr("night_terror") then
			inc = inc + src:attr("night_terror")
			print("[PROJECTOR] after night_terror", dam + (dam * inc / 100))
		end
		-- Increases damage to targets with Insomnia
		if src.attr and src:attr("lucid_dreamer") and target:hasEffect(target.EFF_INSOMNIA) then
			inc = inc + src:attr("lucid_dreamer")
			print("[PROJECTOR] after lucid_dreamer", dam + (dam * inc / 100))
		end
		-- Mind Link
		if type == DamageType.MIND and target:hasEffect(target.EFF_MIND_LINK_TARGET) then
			local eff = target:hasEffect(target.EFF_MIND_LINK_TARGET)
			if eff.src == src or eff.src == src.summoner then
				mind_linked = true
				inc = inc + eff.power
				print("[PROJECTOR] after mind_link", dam + (dam * inc / 100))
			end
		end

		-- Pheremones 
		if src.is_nature_summon and target:attr("inc_nature_summon") then 
			inc = inc + target:attr("inc_nature_summon")
			print("[PROJECTOR] after nature summon increase dam", dam + (dam * inc) / 100)
		end
		
		-- Rigor mortis
		if src.necrotic_minion and target:attr("inc_necrotic_minions") then
			inc = inc + target:attr("inc_necrotic_minions")
			print("[PROJECTOR] after necrotic increase dam", dam + (dam * inc) / 100)
		end

		-- dark vision increases damage done in creeping dark
		if src and src ~= target and game.level.map:checkAllEntities(x, y, "creepingDark") then
			local dark = game.level.map:checkAllEntities(x, y, "creepingDark")
			if dark.summoner == src and dark.damageIncrease > 0 and not dark.projecting then
				local source = src.__project_source or src
				inc = inc + dark.damageIncrease
				game:delayedLogMessage(source, target, "dark_strike"..(source.uid or ""), "#Source# strikes #Target# in the darkness (%+d%%%%%%%% damage).", dark.damageIncrease) -- resolve %% 3 levels deep
			end
		end

		if dam > 0 and src and src.__is_actor and src:knowTalent(src.T_BACKSTAB) then
			local power = src:callTalent("T_BACKSTAB", "getDamageBoost")
			local nb = 0
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if (e.subtype.stun or e.subtype.blind or e.subtype.pin or e.subtype.disarm or e.subtype.cripple or e.subtype.confusion or e.subtype.silence)then nb = nb + 1 end
			end
			if nb > 0 then
				local boost = math.min(power*nb, power*3)
				inc = inc + boost
				print("[PROJECTOR] after backstab", dam + (dam * inc / 100))
			end
		end

		dam = dam + (dam * inc / 100)

		-- Blast the iceblock
		if src.attr and src:attr("encased_in_ice") then
			local eff = src:hasEffect(src.EFF_FROZEN)
			eff.hp = eff.hp - dam
			local srcname = src.x and src.y and game.level.map.seens(src.x, src.y) and src:getName():capitalize() or _t"Something"
			if eff.hp < 0 and not eff.begone then
				game.logSeen(src, "%s forces the iceblock to shatter.", src:getName():capitalize())
				game:onTickEnd(function() src:removeEffect(src.EFF_FROZEN) end)
				eff.begone = game.turn
			else
				game:delayedLogDamage(src, eff.ice, dam, ("%s%d %s#LAST#"):format(DamageType:get(type).text_color or "#aaaaaa#", math.ceil(dam), DamageType:get(type).name))
				if eff.begone and eff.begone < game.turn and eff.hp < 0 then
					game.logSeen(src, "%s forces the iceblock to shatter.", src:getName():capitalize())
					src:removeEffect(src.EFF_FROZEN)
				end
			end
			return 0 + add_dam
		end


		local hd = {"DamageProjector:beforeResists", src=src, x=x, y=y, type=type, dam=dam, state=state}
		if src:triggerHook(hd) then dam = hd.dam if hd.stopped then return hd.stopped end end
		if target.iterCallbacks then
			for cb in target:iterCallbacks("callbackOnTakeDamageBeforeResists") do
				local ret = cb(src, x, y, type, dam, state)
				if ret then
					if ret.dam then dam = ret.dam end
					if ret.stopped then return ret.stopped end
				end
			end
		end

		--target.T_STONE_FORTRESS could be checked/applied here (ReduceDamage function in Dwarven Fortress talent)

		-- affinity healing, we store it to apply it after damage is resolved
		local affinity_heal = 0
		if target.damage_affinity then
			affinity_heal = math.max(0, dam * target:combatGetAffinity(type) / 100)
		end

		-- reduce by resistance to entity type (Demon, Undead, etc)
		-- Summoned, Unnatural, Unliving still go into this table, we just parse them differently in checkClassification
		if target.resists_actor_type and src and src.type then
			local res = 0

			for k, v in pairs(target.resists_actor_type) do
				if src:checkClassification(tostring(k)) then res = math.max(res, v) end
			end

			res = math.min(res, target.resists_cap_actor_type or 90)

			if res ~= 0 then
				print("[PROJECTOR] before entity", src.type, "resists dam", dam)
				if res >= 100 then dam = 0
				elseif res <= -100 then dam = dam * 2
				else dam = dam * ((100 - res) / 100)
				end
				print("[PROJECTOR] after entity", src.type, "resists dam", dam)
			end
		end

		-- Reduce damage with resistance
		if target.resists then
			local pen = 0
			if src.combatGetResistPen then 
				pen = src:combatGetResistPen(type)
				if type == DamageType.ARCANE and src.knowTalent and src:knowTalent(src.T_AURA_OF_SILENCE) then pen = pen + src:combatGetResistPen(DamageType.NATURE) end
			elseif src.resists_pen then pen = (src.resists_pen.all or 0) + (src.resists_pen[type] or 0)
			end
			local dominated = target:hasEffect(target.EFF_DOMINATED)
			if dominated and dominated.src == src then pen = pen + (dominated.resistPenetration or 0) end
			if target:attr("sleep") and src.attr and src:attr("night_terror") then pen = pen + src:attr("night_terror") end
			local res = target:combatGetResist(type)
			pen = util.bound(pen, 0, 100)
			if res > 0 then	res = res * (100 - pen) / 100 end
			print("[PROJECTOR] res", res, (100 - res) / 100, " on dam", dam)
			if res >= 100 then dam = 0
			elseif res <= -100 then dam = dam * 2
			else dam = dam * ((100 - res) / 100)
			end
		end
		print("[PROJECTOR] after resists dam", dam)

		-- Reduce damage with resistance against self
		if src == target and target.resists_self then
			local res = (target.resists_self[type] or 0) + (target.resists_self.all or 0)
			print("[PROJECTOR] res", res, (100 - res) / 100, " on dam", dam)
			if res >= 100 then dam = 0
			elseif res <= -100 then dam = dam * 2
			else dam = dam * ((100 - res) / 100)
			end
			print("[PROJECTOR] after self-resists dam", dam)
		end

		local initial_dam = dam
		lastdam = dam
		-- Static reduce damage for psionic kinetic shield
		if target.isTalentActive and target:isTalentActive(target.T_KINETIC_SHIELD) then
			local t = target:getTalentFromId(target.T_KINETIC_SHIELD)
			dam = t.ks_on_damage(target, t, type, dam)
		end
		-- Static reduce damage for psionic thermal shield
		if target.isTalentActive and target:isTalentActive(target.T_THERMAL_SHIELD) then
			local t = target:getTalentFromId(target.T_THERMAL_SHIELD)
			dam = t.ts_on_damage(target, t, type, dam)
		end
		-- Static reduce damage for psionic charged shield
		if target.isTalentActive and target:isTalentActive(target.T_CHARGED_SHIELD) then
			local t = target:getTalentFromId(target.T_CHARGED_SHIELD)
			dam = t.cs_on_damage(target, t, type, dam)
		end
		if dam ~= lastdam then
			game:delayedLogDamage(src, target, 0, ("%s(%d to psi shield)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam-dam), false)
		end

		-- Block talent from shields
		if dam > 0 and target:attr("block") then
			local e = target.tempeffect_def[target.EFF_BLOCKING]
			lastdam = dam
			dam = e.do_block(type, dam, target.tmp[target.EFF_BLOCKING], target, src)
			if lastdam - dam > 0 then game:delayedLogDamage(src, target, 0, ("%s(%d blocked)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam-dam), false) end
		end
		if dam > 0 and target.isTalentActive and target:isTalentActive(target.T_FORGE_SHIELD) then
			local t = target:getTalentFromId(target.T_FORGE_SHIELD)
			lastdam = dam
			dam = t.doForgeShield(type, dam, t, target, src)
			if lastdam - dam > 0 then game:delayedLogDamage(src, target, 0, ("%s(%d blocked)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam-dam), false) end
		end

		--Vim based defence
		if target:attr("demonblood_def") and target.getVim then
			local demon_block = math.min(dam*0.5,target.demonblood_def*(target:getVim() or 0))
			dam= dam - demon_block
			target:incVim((-demon_block)/20)
		end

		-- Static reduce damage
		if dam > 0 and target.isTalentActive and target:isTalentActive(target.T_ANTIMAGIC_SHIELD) then
			local t = target:getTalentFromId(target.T_ANTIMAGIC_SHIELD)
			lastdam = dam
			dam = t.on_damage(target, t, type, dam, src)
			if lastdam - dam  > 0 then game:delayedLogDamage(src, target, 0, ("%s(%d antimagic)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", lastdam - dam), false) end
		end

		-- Flat damage reduction ("armour")
		if dam > 0 and target.flat_damage_armor then
			local dec = math.min(dam, target:combatGetFlatResist(type))
			-- I hate myself
			if target.knowTalent and target:knowTalent(target.T_STONE_FORTRESS) and not target:attr("stone_fortress_active") and type ~= DamageType.PHYSICAL and src.hasEffect and src:hasEffect(src.EFF_STONE_VINE) then
				dec = math.min(dam, dec + target:combatArmor() * target:callTalent(target.T_STONE_FORTRESS, "getPercent") / 100 / 2)
			end
			if dec > 0 then game:delayedLogDamage(src, target, 0, ("%s(%d flat reduction)#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", dec), false) end
			dam = math.max(0, dam - dec)
			print("[PROJECTOR] after flat damage armor", dam, dec)
		end

		-- roll with it damage reduction
		if type == DamageType.PHYSICAL and target:knowTalent(target.T_ROLL_WITH_IT) and not target:attr("never_move") then
			dam = dam * target:callTalent(target.T_ROLL_WITH_IT, "getMult")
			print("[PROJECTOR] after Roll With It dam", dam)
		end

		if target:attr("resist_unseen") and not target:canSee(src) then
			dam = dam * (1 - math.min(target.resist_unseen,100)/100)
		end

		-- Sanctuary: reduces damage if it comes from outside of Gloom
		if target.isTalentActive and target:isTalentActive(target.T_GLOOM) and target:knowTalent(target.T_SANCTUARY) then
			if state and state.sanctuaryDamageChange then
				-- projectile was targeted outside of gloom
				dam = dam * (100 + state.sanctuaryDamageChange) / 100
				print("[PROJECTOR] Sanctuary (projectile) dam", dam)
			elseif src and src.x and src.y then
				-- assume instantaneous projection and check range to source
				local t = target:getTalentFromId(target.T_GLOOM)
				if core.fov.distance(target.x, target.y, src.x, src.y) > target:getTalentRange(t) then
					t = target:getTalentFromId(target.T_SANCTUARY)
					dam = dam * (100 + t.getDamageChange(target, t)) / 100
					print("[PROJECTOR] Sanctuary (source) dam", dam)
				end
			end
		end

		-- Mark Prey: reduces damage from subtype of marked prey
		if target.hasEffect and target:hasEffect(target.EFF_PREDATOR) and src.subtype then
			if table.get(target, "mark_prey2", game.level.id, src.subtype) then
				dam = dam * (100 - target:callTalent(target.T_MARK_PREY, "getPower")) / 100
				print("[PROJECTOR] predator reduction dam", dam)
			end
		end

		-- Psychic Projection
		if src.attr and src:attr("is_psychic_projection") and not game.zone.is_dream_scape then
			if (target.subtype and target.subtype == "ghost") or mind_linked then
				dam = dam
			else
				dam = 0
			end
		end

		--Dark Empathy (Reduce damage against summoner)
		if src.minion_be_nice and src.summoner == target then
			dam = dam * (1 - src.minion_be_nice)
		end

		--Dark Empathy (Reduce damage against other minions)
		if src.minion_be_nice and target.summoner and src.summoner == target.summoner then
			dam = dam * (1 - src.minion_be_nice)
		end

		-- Curse of Misfortune: Unfortunate End (chance to increase damage enough to kill)
		if src and src.hasEffect and src:hasEffect(src.EFF_CURSE_OF_MISFORTUNE) then
			local eff = src:hasEffect(src.EFF_CURSE_OF_MISFORTUNE)
			local def = src.tempeffect_def[src.EFF_CURSE_OF_MISFORTUNE]
			dam = def.doUnfortunateEnd(src, eff, target, dam)
		end

		if src:attr("crushing_blow") and (dam * (1.25 + (src.combat_critical_power or 0)/200)) > target.life then
			dam = dam * (1.25 + (src.combat_critical_power or 0)/200)
			game.logPlayer(src, "You end your target with a crushing blow!")
		end

		-- Flat damage cap
		if target.flat_damage_cap then
			local cap = nil
			if target.flat_damage_cap.all then cap = target.flat_damage_cap.all end
			if target.flat_damage_cap[type] then cap = target.flat_damage_cap[type] end
			if cap and cap > 0 then
				local ignored = math.max(0, dam - cap * target.max_life / 100)
				if ignored > 0 then game:delayedLogDamage(src, target, 0, ("#LIGHT_GREY#(%d resilience)#LAST#"):tformat(ignored), false) end
				dam = dam - ignored
				print("[PROJECTOR] after flat damage cap", dam)
			end
		end

		print("[PROJECTOR] final dam after static checks", dam)

		local hd = {"DamageProjector:final", src=src, target=target, x=x, y=y, type=type, dam=dam, state=state, source_talent=source_talent, source_talent_mode=source_talent_mode}
		if src:triggerHook(hd) then dam = hd.dam if hd.stopped then return hd.stopped end end
		if target.iterCallbacks then
			for cb in target:iterCallbacks("callbackOnTakeDamage") do
				local ret = cb(src, x, y, type, dam, state)
				if ret then
					if ret.dam then dam = ret.dam end
					if ret.stopped then return ret.stopped end
				end
			end
		end

		if target.resists and target.resists.absolute then -- absolute resistance (from Terrasca)
			dam = dam * ((100 - math.min(target.resists_cap.absolute or 70, target.resists.absolute)) / 100)
			print("[PROJECTOR] after absolute resistance dam", dam)
		end

		print("[PROJECTOR] final dam after hooks and callbacks", dam)

		local dead
		dead, dam = target:takeHit(dam, src, {damtype=type, damstate=state, source_talent=source_talent, source_talent_mode=source_talent_mode, initial_dam=initial_dam})

		-- Log damage for later
		if not DamageType:get(type).hideMessage then
			local visible, srcSeen, tgtSeen = game:logVisible(src, target)
			if visible then -- don't log damage that the player doesn't know about
				if crit_power > 1 then
					game:delayedLogDamage(src, target, dam, ("#{bold}#%s%d %s#{normal}##LAST#"):format(DamageType:get(type).text_color or "#aaaaaa#", dam, DamageType:get(type).name), true)
				else
					game:delayedLogDamage(src, target, dam, ("%s%d %s#LAST#"):format(DamageType:get(type).text_color or "#aaaaaa#", dam, DamageType:get(type).name), false)
				end
			end
		end

		if dam > 0 and src.attr and src:attr("martyrdom") and not state.no_reflect then
			game:delayedLogMessage(src, target, "martyrdom", "#CRIMSON##Source# damages %s through Martyrdom!", string.his_her_self(src))
			state.no_reflect = true
			DamageType.defaultProjector(target, src.x, src.y, type, dam * src.martyrdom / 100, state)
			state.no_reflect = nil
		end
		if target.attr and target:attr("reflect_damage") and not state.no_reflect and src.x and src.y then
			game:delayedLogMessage(target, src, "reflect_damage"..(src.uid or ""), "#CRIMSON##Source# reflects damage back to #Target#!")
			state.no_reflect = true
			DamageType.defaultProjector(target, src.x, src.y, type, dam * target.reflect_damage / 100, state)
			state.no_reflect = nil
		end
		-- Braided damage
		if dam > 0 and target:hasEffect(target.EFF_BRAIDED) then
			game:onTickEnd(function()target:callEffect(target.EFF_BRAIDED, "doBraid", dam)end)
		end

		if target.knowTalent and target:knowTalent(target.T_RESOLVE) and target:reactionToward(src) <= 0 then local t = target:getTalentFromId(target.T_RESOLVE) t.on_absorb(target, t, type, dam) end

		if target ~= src and target.attr and target:attr("damage_resonance") and not target:hasEffect(target.EFF_RESONANCE) then
			target:setEffect(target.EFF_RESONANCE, 5, {damtype=type, dam=target:attr("damage_resonance")})
		end

		if not target.dead and dam > 0 and type == DamageType.MIND and src and src.knowTalent and src:knowTalent(src.T_MADNESS) then
			local t = src:getTalentFromId(src.T_MADNESS)
			t.doMadness(target, t, src)
		end

		-- Curse of Nightmares: Nightmare
		if not target.dead and dam > 0 and src and target.hasEffect and target:hasEffect(src.EFF_CURSE_OF_NIGHTMARES) then
			local eff = target:hasEffect(target.EFF_CURSE_OF_NIGHTMARES)
			eff.isHit = true -- handle at the end of the turn
		end

		if not target.dead and dam > 0 and target:attr("elemental_harmony") and not target:hasEffect(target.EFF_ELEMENTAL_HARMONY) and target ~= src then
			if type == DamageType.FIRE or type == DamageType.COLD or type == DamageType.LIGHTNING or type == DamageType.ACID or type == DamageType.NATURE then
				target:setEffect(target.EFF_ELEMENTAL_HARMONY, target:callTalent(target.T_ELEMENTAL_HARMONY, "duration"), {power=target:attr("elemental_harmony"), type=type, no_ct_effect=true})
			end
		end

		-- damage affinity healing
		if not target.dead and affinity_heal > 0 then
			target:heal(affinity_heal, src)
			game:delayedLogMessage(target, nil, "Affinity"..type, ("#Source##LIGHT_GREEN# HEALS#LAST# from %s %s #LAST# damage!"):tformat(DamageType:get(type).text_color or "#aaaaaa#", DamageType:get(type).name))
		end

		if dam > 0 and src.damage_log and src.damage_log.weapon then
			src.damage_log[type] = (src.damage_log[type] or 0) + dam
			if src.turn_procs and src.turn_procs.weapon_type then
				src.damage_log.weapon[src.turn_procs.weapon_type.kind] = (src.damage_log.weapon[src.turn_procs.weapon_type.kind] or 0) + dam
				src.damage_log.weapon[src.turn_procs.weapon_type.mode] = (src.damage_log.weapon[src.turn_procs.weapon_type.mode] or 0) + dam
			end
		end

		if dam > 0 and target.damage_intake_log and target.damage_intake_log.weapon then
			target.damage_intake_log[type] = (target.damage_intake_log[type] or 0) + dam
			if src.turn_procs and src.turn_procs.weapon_type then
				target.damage_intake_log.weapon[src.turn_procs.weapon_type.kind] = (target.damage_intake_log.weapon[src.turn_procs.weapon_type.kind] or 0) + dam
				target.damage_intake_log.weapon[src.turn_procs.weapon_type.mode] = (target.damage_intake_log.weapon[src.turn_procs.weapon_type.mode] or 0) + dam
			end
		end

		if dam > 0 and source_talent then
			local t = source_talent

			local spellshock = src:attr("spellshock_on_damage")
			if spellshock and t.is_spell and target:checkHit(src:combatSpellpower(1, spellshock), target:combatSpellResist(), 0, 95, 15) and not target:hasEffect(target.EFF_SPELLSHOCKED) then
				target:crossTierEffect(target.EFF_SPELLSHOCKED, src:combatSpellpower(1, spellshock))
			end

			if src.__projecting_for then
				-- Disable friendly fire for procs since players can't control when they happen or where they hit
				local old_ff = src.nullify_all_friendlyfire
				src.nullify_all_friendlyfire = true
				if src.talent_on_spell and next(src.talent_on_spell) and t.is_spell and not src.turn_procs.spell_talent then
					for id, d in pairs(src.talent_on_spell) do
						if rng.percent(d.chance) and t.id ~= d.talent then
							src.turn_procs.spell_talent = true
							local old = src.__projecting_for
							src:forceUseTalent(d.talent, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=d.level, ignore_ressources=true})
							src.__projecting_for = old
						end
					end
				end

				if src.talent_on_wild_gift and next(src.talent_on_wild_gift) and t.is_nature and not src.turn_procs.wild_gift_talent then
					for id, d in pairs(src.talent_on_wild_gift) do
						if rng.percent(d.chance) and t.id ~= d.talent then
							src.turn_procs.wild_gift_talent = true
							local old = src.__projecting_for
							src:forceUseTalent(d.talent, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=d.level, ignore_ressources=true})
							src.__projecting_for = old
						end
					end
				end

				if src.talent_on_mind and next(src.talent_on_mind) and t.is_mind and not src.turn_procs.mind_talent then
					for id, d in pairs(src.talent_on_mind) do
						if rng.percent(d.chance) and t.id ~= d.talent then
							src.turn_procs.mind_talent = true
							local old = src.__projecting_for
							src:forceUseTalent(d.talent, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=d.level, ignore_ressources=true})
							src.__projecting_for = old
						end
					end
				end
				src.nullify_all_friendlyfire = old_ff

				if not target.dead and (t.is_spell or t.is_mind) and not src.turn_procs.meteoric_crash and src.knowTalent and src:knowTalent(src.T_METEORIC_CRASH) then
					src.turn_procs.meteoric_crash = true
					src:triggerTalent(src.T_METEORIC_CRASH, nil, target)
				end

				if not target.dead and t.is_spell and target.knowTalent then
					if target:knowTalent(target.T_SPELL_FEEDBACK) then
						target:triggerTalent(target.T_SPELL_FEEDBACK, nil, src, t)
					end
					if target:knowTalent(target.T_NATURE_S_DEFIANCE) then
						target:triggerTalent(target.T_NATURE_S_DEFIANCE, nil, src, t)
					end
				end
				if t.is_spell and src.knowTalent and src:knowTalent(src.T_BORN_INTO_MAGIC) and type ~= DamageType.THAUM then
					src:triggerTalent(target.T_BORN_INTO_MAGIC, nil, type)
				end

				if not target.dead and src.isTalentActive and src:isTalentActive(src.T_UNSTOPPABLE_NATURE) and t.is_nature and not src.turn_procs.unstoppable_nature then
					src:callTalent(src.T_UNSTOPPABLE_NATURE, "freespit", target)
					src.turn_procs.unstoppable_nature = true
				end
			end
		end

		if src.turn_procs and not src.turn_procs.dazing_damage and src.hasEffect and src:hasEffect(src.EFF_DAZING_DAMAGE) then
			if target:canBe("stun") then
				local power = math.max(src:combatSpellpower(), src:combatMindpower(), src:combatPhysicalpower())
				target:setEffect(target.EFF_DAZED, 2, {})
			end
			src:removeEffect(src.EFF_DAZING_DAMAGE)
			src.turn_procs.dazing_damage = true
		end

		if src.turn_procs and not src.turn_procs.blighted_soil and src:attr("blighted_soil") and rng.percent(src:attr("blighted_soil")) then
			local tid = rng.table{src.EFF_ROTTING_DISEASE, src.EFF_DECREPITUDE_DISEASE, src.EFF_DECREPITUDE_DISEASE}
			if not target:hasEffect(tid) then
				local l = game.zone:level_adjust_level(game.level, game.zone, "object")
				local p = math.ceil(4 + l / 2)
				target:setEffect(tid, 8, {str=p, con=p, dex=p, dam=5 + l / 2, src=src})
				src.turn_procs.blighted_soil = true
			end
		end

		--curse of madness effect spread on crit
		if state.crit_power > 1 and src.hasEffect and src:hasEffect(src.EFF_CURSE_OF_MADNESS) then
			local eff = src:hasEffect(src.EFF_CURSE_OF_MADNESS)
			local def = src.tempeffect_def[src.EFF_CURSE_OF_MADNESS]
			def.doConspirator(src, eff, target)
		end


		return dam + add_dam
	end
	return 0 + add_dam
end)

local function tryDestroy(who, inven, dam, destroy_prop, proof_prop, msg)
	do return end -- Disabled for now
	if not inven then return end

	local reduction = 1

	for i = #inven, 1, -1 do
		local o = inven[i]
		if o[destroy_prop] and not o[proof_prop] then
			for j, test in ipairs(o[destroy_prop]) do
				if dam >= test[1] and rng.percent(test[2] * reduction) then
					game.logPlayer(who, msg, o:getName{do_color=true, no_count=true})
					local obj = who:removeObject(inven, i)
					obj:removed()
					break
				end
			end
		end
	end
end

newDamageType{
	name = _t"cosmetic", type = "COSMETIC", text_color = "#WHITE#",
	projector = function(src, x, y, type, dam)
	end,
	death_message = {_t"cosmeticed"},
}

-- The base elemental damage types are:
-- PHYSICAL, FIRE, COLD, ARCANE, LIGHTNING, ACID, NATURE, BLIGHT, LIGHT, DARKNESS, MIND, TEMPORAL

-- Need a provision to allow for compound DamageTypes to work with damDesc, combatGetResist, combatGetDamageIncrease, combatGetResistPen, combatGetAffinity, etc.

newDamageType{
	name = _t"physical", type = "PHYSICAL", text_color = "#WHITE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)

		local target = game.level.map(x, y, Map.ACTOR)
		if target and src.isTalentActive and src:isTalentActive(src.T_DISINTEGRATION) then
			src:callTalent(src.T_DISINTEGRATION, "doStrip", target, type)
		end

		return realdam
	end,
	death_message = {_t"battered", _t"bludgeoned", _t"sliced", _t"maimed", _t"raked", _t"bled", _t"impaled", _t"dissected", _t"disembowelled", _t"decapitated", _t"stabbed", _t"pierced", _t"torn limb from limb", _t"crushed", _t"shattered", _t"smashed", _t"cleaved", _t"swiped", _t"struck", _t"mutilated", _t"tortured", _t"skewered", _t"squished", _t"mauled", _t"chopped into tiny pieces", _t"splattered", _t"ground", _t"minced", _t"punctured", _t"hacked apart", _t"eviscerated"},
}

-- Arcane is basic (usually) unresistable damage
newDamageType{
	name = _t"arcane", type = "ARCANE", text_color = "#PURPLE#",
	antimagic_resolve = true,
	death_message = {_t"blasted", _t"energised", _t"mana-torn", _t"dweomered", _t"imploded"},
}
-- The elemental damages
newDamageType{
	name = _t"fire", type = "FIRE", text_color = "#LIGHT_RED#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if src.fire_convert_to then
			if src.fire_convert_to[2] >= 100 then
				return DamageType:get(src.fire_convert_to[1]).projector(src, x, y, src.fire_convert_to[1], dam * src.fire_convert_to[2] / 100, state)
			else
				local old = src.fire_convert_to
				src.fire_convert_to = nil
				dam = DamageType:get(old[1]).projector(src, x, y, old[1], dam * old[2] / 100, state) +
				       DamageType:get(type).projector(src, x, y, type, dam * (100 - old[2]) / 100, state)
				src.fire_convert_to = old
				return dam
			end
		end
		local a = game.level.map(x, y, Map.ACTOR)
		local acheive = a and src.player and not a.training_dummy and a ~= src
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if realdam > 0 and acheive then
			world:gainAchievement("PYROMANCER", src, realdam)
		end
		return realdam
	end,
	death_message = {_t"burnt", _t"scorched", _t"blazed", _t"roasted", _t"flamed", _t"fried", _t"combusted", _t"toasted", _t"slowly cooked", _t"boiled"},
}
newDamageType{
	name = _t"cold", type = "COLD", text_color = "#1133F3#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local a = game.level.map(x, y, Map.ACTOR)
		local acheive = a and src.player and not a.training_dummy and a ~= src
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if realdam > 0 and acheive then
			world:gainAchievement("CRYOMANCER", src, realdam)
		end
		if realdam > 0 and src:attr("cold_freezes") and rng.percent(src.cold_freezes) then
			DamageType:get(DamageType.FREEZE).projector(src, x, y, DamageType.FREEZE, {dur=2, hp=70+dam*1.5})
		end
		return realdam
	end,
	death_message = {_t"frozen", _t"chilled", _t"iced", _t"cooled", _t"frozen and shattered into a million little shards"},
}
newDamageType{
	name = _t"lightning", type = "LIGHTNING", text_color = "#ROYAL_BLUE#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if realdam > 0 and src:attr("lightning_brainlocks") then
			local target = game.level.map(x, y, Map.ACTOR)
			if target and realdam > target.max_life / 10 then
				target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatMindpower())
			end
		end
		return realdam
	end,
	death_message = {_t"electrocuted", _t"shocked", _t"bolted", _t"volted", _t"amped", _t"zapped"},
}

-- Acid, few specific interactions currently aside from damage types later derived from this
newDamageType{
	name = _t"acid", type = "ACID", text_color = "#GREEN#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if realdam > 0 and target and src.knowTalent and src:knowTalent(src.T_NATURAL_ACID) then
			local t = src:getTalentFromId(src.T_NATURAL_ACID)
			src:setEffect(src.EFF_NATURAL_ACID, t.getDuration(src, t), {})
		end
		return realdam
	end,
	death_message = {_t"dissolved", _t"corroded", _t"scalded", _t"melted"},
}

-- Nature & Blight: Opposing damage types
newDamageType{
	name = _t"nature", type = "NATURE", text_color = "#LIGHT_GREEN#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if realdam > 0 and target and src.knowTalent and src:knowTalent(src.T_CORROSIVE_NATURE) then
			local t = src:getTalentFromId(src.T_CORROSIVE_NATURE)
			src:setEffect(src.EFF_CORROSIVE_NATURE, t.getDuration(src, t), {})
		end
		return realdam
	end,
	death_message = {_t"slimed", _t"splurged", _t"treehugged", _t"naturalised"},
}

newDamageType{
	name = _t"blight", type = "BLIGHT", text_color = "#DARK_GREEN#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		-- Spread diseases if possible
		if realdam > 0 and target and target:attr("diseases_spread_on_blight") and (not state or not state.from_disease) and src.callTalent then
			src:callTalent(src.T_EPIDEMIC, "do_spread", target, realdam)
		end
		if src and src.knowTalent and realdam > 0 and target and src:knowTalent(src.T_PESTILENT_BLIGHT) then
			src:callTalent(src.T_PESTILENT_BLIGHT, "do_rot", target, realdam)
		end
		if src and src.knowTalent and realdam > 0 and target and src:knowTalent(src.T_VIRULENT_DISEASE) and (not state or not state.from_disease) then
			src:callTalent(src.T_VIRULENT_DISEASE, "do_disease", target, realdam)
		end
		return realdam
	end,
	death_message = {_t"diseased", _t"poxed", _t"infected", _t"plagued", _t"debilitated by noxious blight before falling", _t"fouled", _t"tainted"},
}

-- Light damage
newDamageType{
	name = _t"light", type = "LIGHT", text_color = "#YELLOW#",
	antimagic_resolve = true,
	death_message = {_t"radiated", _t"seared", _t"purified", _t"sun baked", _t"jerkied", _t"tanned"},
}

-- Darkness damage
newDamageType{
	name = _t"darkness", type = "DARKNESS", text_color = "#GREY#",
	antimagic_resolve = true,
	death_message = {_t"shadowed", _t"darkened", _t"swallowed by the void"},
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		-- Darken
		if realdam > 0 and src:attr("darkness_darkens") then
			game.level.map.lites(x, y, false)
			if src.x and src.y then game.level.map.lites(src.x, src.y, false) end
		end
		return realdam
	end,
}

-- Mind damage
-- Most uses of this have their damage effected by mental save and do not trigger cross tiers, ie, melee items
newDamageType{
	name = _t"mind", type = "MIND", text_color = "#ORANGE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local thought_form
		if target and src and target.summoner and target.summoner == src and target.type and target.type == "thought-form" then thought_form = true end
		if target and not thought_form then
			local mindpower, mentalresist, alwaysHit, crossTierChance
			if _G.type(dam) == "table" then dam, mindpower, mentalresist, alwaysHit, crossTierChance = dam.dam, dam.mindpower, dam.mentalresist, dam.alwaysHit, dam.crossTierChance end
			local hit_power = mindpower or src:combatMindpower()
			if alwaysHit or target:checkHit(hit_power, mentalresist or target:combatMentalResist(), 0, 95, 15) then
				if crossTierChance and rng.percent(crossTierChance) then
					target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatMindpower())
				end
				return DamageType.defaultProjector(src, x, y, type, dam, state)
			else
				--game.logSeen(target, "%s resists the mind attack!", target:getName():capitalize())
				return DamageType.defaultProjector(src, x, y, type, dam / 2, state)
			end
		end
		return 0
	end,
	death_message = {_t"psyched", _t"mentally tortured", _t"mindraped"},
}

-- Cold damage+turn energy drain, used exclusively by the Wintertide weapon
-- If you use this for something else make sure to note it has no power check or sanity check on how much turn energy is drained
newDamageType{
	name = _t"winter", type = "WINTER",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local srcx, srcy = dam.x, dam.y
		local base = dam
		dam = dam.dam
		if not base.st then
			DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		else
			DamageType:get(base.st).projector(src, x, y, base.st, dam, state)
		end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			local energyDrain = (game.energy_to_act * 0.2)
			target.energy.value = target.energy.value - energyDrain
		end
	end,
}

-- Temporal damage
newDamageType{
	name = _t"temporal", type = "TEMPORAL", text_color = "#LIGHT_STEEL_BLUE#",
	antimagic_resolve = true,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)

		local target = game.level.map(x, y, Map.ACTOR)
		if target and src.isTalentActive and src:isTalentActive(src.T_DISINTEGRATION) then
			src:callTalent(src.T_DISINTEGRATION, "doStrip", target, type)
		end

		return realdam
	end,
	death_message = {_t"timewarped", _t"temporally distorted", _t"spaghettified across the whole of space and time", _t"paradoxed", _t"replaced by a time clone (and no one ever knew the difference)", _t"grandfathered", _t"time dilated"},
}

-- Temporal + Stun
newDamageType{
	name = _t"temporal stun", type = "TEMPORALSTUN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 4, {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		end
	end,
}

-- Lite up the room
newDamageType{
	name = _t"lite", type = "LITE", text_color = "#YELLOW#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		-- Counter magical unlite level before lighting grids
		local g = game.level.map(x, y, Map.TERRAIN+1)
		if g and g.unlit then
			if g.unlit <= dam then game.level.map:remove(x, y, Map.TERRAIN+1)
			else g.unlit = g.unlit - dam return end -- Lite wears down darkness
		end
		game.level.map.lites(x, y, true)
	end,
}

-- Break stealth
newDamageType{
	name = _t"illumination", type = "BREAK_STEALTH",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		-- Dont lit magically unlit grids
		local a = game.level.map(x, y, Map.ACTOR)
		if a then
			a:setEffect(a.EFF_LUMINESCENCE, math.ceil(dam.turns), {power=dam.power, no_ct_effect=true})
		end
	end,
}

-- Silence
newDamageType{
	name = _t"silence", type = "SILENCE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, math.ceil(dam.dur), {apply_power=dam.power_check or src:combatMindpower() * 0.7})
			else
				game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
			end
		end
	end,
}

-- Silence
newDamageType{
	name = _t"arcane silence", type = "ARCANE_SILENCE", text_color = "#PURPLE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 100
		if _G.type(dam) == "table" then dam, chance = dam.dam, dam.chance end

		local target = game.level.map(x, y, Map.ACTOR)
		local realdam = DamageType:get(DamageType.ARCANE).projector(src, x, y, DamageType.ARCANE, dam, state)
		if target then
			if rng.percent(chance) and target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, 3, {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Silence
newDamageType{
	name = _t"silence", type = "RANDOM_SILENCE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam) then
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, 4, {apply_power=src:combatAttack()*0.7, no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
			end
		end
	end,
}

-- Blinds
newDamageType{
	name = _t"blindness", type = "BLIND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, math.ceil(dam), {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the blinding light!", target:getName():capitalize())
			end
		end
	end,
}
newDamageType{
	name = _t"blindness", type = "BLINDPHYSICAL",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, math.ceil(dam), {apply_power=src:combatAttack()})
			else
				game.logSeen(target, "%s resists the blinding light!", target:getName():capitalize())
			end
		end
	end,
}
newDamageType{
	name = _t"blinding ink", type = "BLINDING_INK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, math.ceil(dam), {apply_power=src:combatPhysicalpower(), apply_save="combatPhysicalResist"})
			else
				game.logSeen(target, "%s avoids the blinding ink!", target:getName():capitalize())
			end
		end
	end,
}
newDamageType{
	name = _t"blindness", type = "BLINDCUSTOMMIND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, math.ceil(dam.turns), {apply_power=dam.power, apply_save="combatMentalResist", no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the blinding light!", target:getName():capitalize())
			end
		end
	end,
}

-- Lite + Light damage
newDamageType{
	name = _t"bright light", type = "LITE_LIGHT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.LITE).projector(src, x, y, DamageType.LITE, 1, state)
		return DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
	end,
}

-- Fire damage + DOT
newDamageType{
	name = _t"fire burn", type = "FIREBURN", text_color = "#LIGHT_RED#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local dur = 3
		local perc = 50
		if _G.type(dam) == "table" then dam, dur, perc = dam.dam, dam.dur, (dam.initial or perc) end
		local init_dam = dam * perc / 100
		if init_dam > 0 then DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, init_dam, state) end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Set on fire!
			dam = dam - init_dam
			target:setEffect(target.EFF_BURNING, dur, {src=src, power=dam / dur, no_ct_effect=true})
		end
		return init_dam
	end,
}

-- Fire damage + DOT + 25% chance of Fireflash
newDamageType{
	name = _t"stunning fire", type = "FIRE_STUN", text_color = "#LIGHT_RED#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 25
		local dur = 3
		local perc = 50
		if _G.type(dam) == "table" then dam, dur, perc = dam.dam, dam.dur, (dam.initial or perc) end
		local init_dam = dam * perc / 100
		if init_dam > 0 then DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, init_dam, state) end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			dam = dam - init_dam
			target:setEffect(target.EFF_BURNING, dur, {src=src, power=dam / dur, no_ct_effect=true})
				if rng.percent(chance) then
					DamageType:get(DamageType.FLAMESHOCK).projector(src, x, y, DamageType.FLAMESHOCK, {dur=3, dam=15, apply_power=math.max(src:combatMindpower(), src:combatSpellpower())}, state)
			end
		end
		return init_dam
	end,
}

newDamageType{
	name = _t"fire burn", type = "GOLEM_FIREBURN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = 0
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target ~= src and target ~= src.summoner then
			realdam = DamageType:get(DamageType.FIREBURN).projector(src, x, y, DamageType.FIREBURN, dam, state)
		end
		return realdam
	end,
}

-- Drain Life... with fire!
newDamageType{
	name = _t"devouring flames", type = "FIRE_DRAIN", text_color = "#LIGHT_RED#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, healfactor=0.1} end
		local target = game.level.map(x, y, Map.ACTOR) -- Get the target first to make sure we heal even on kill
		local realdam = DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam.dam, state)
		if target and realdam > 0 and not src:attr("dead") then
			src:heal(realdam * dam.healfactor, target)
			src:logCombat(target, "#Source# drains life from #Target#!")
		end
		return realdam
	end,
}

-- Darkness + Fire
newDamageType{
	name = _t"shadowflame", type = "SHADOWFLAME", text_color = "#BF7F73#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam / 2, state)
		DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam / 2, state)
	end,
}

-- Darkness + Stun
newDamageType{
	name = _t"stunning darkness", type = "DARKSTUN", text_color = "#GREY#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- try to stun
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 4, {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the darkness!", target:getName():capitalize())
			end
		end
	end,
}

-- Darkness but not over minions
newDamageType{
	name = _t"darkness", type = "MINION_DARKNESS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and (not target.necrotic_minion or target.summoner ~= src) then
			DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
		end
	end,
}

-- Fore but not over minions
newDamageType{
	name = _t"fire", type = "FIRE_FRIENDS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target.summoner ~= src then
			DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam, state)
		end
	end,
}

-- Cold + Stun
newDamageType{
	name = _t"cold", type = "COLDSTUN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 4, {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		end
	end,
}

-- Fire DOT + Stun
newDamageType{
	name = _t"flameshock", type = "FLAMESHOCK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=4} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Set on fire!
			if target:canBe("stun") then
				target:setEffect(target.EFF_BURNING_SHOCK, dam.dur, {src=src, power=dam.dam / dam.dur, apply_power=dam.apply_power or src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the searing flame!", target:getName():capitalize())
			end
		end
	end,
}

-- Cold damage + freeze chance
newDamageType{
	name = _t"ice", type = "ICE", text_color = "#1133F3#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 25
		local do_wet = false
		if _G.type(dam) == "table" then chance, dam, do_wet = dam.chance, dam.dam, dam.do_wet end

		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:hasEffect(target.EFF_WET) then dam = dam * 1.3 chance = 50 end

		local realdam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		if rng.percent(chance) then
			DamageType:get(DamageType.FREEZE).projector(src, x, y, DamageType.FREEZE, {dur=2, hp=70+dam*1.5}, state)
		end
		if target and do_wet and not target:hasEffect(target.EFF_FROZEN) then
			target:setEffect(target.EFF_WET, 3, {apply_power=math.max(src:combatSpellpower(), src:combatMindpower()), min_dur=1})
		end
		return realdam
	end,
}

-- Cold damage + freeze chance + 20% slow
newDamageType{
	name = _t"slowing ice", type = "ICE_SLOW", text_color = "#1133F3#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 25
		local target = game.level.map(x, y, Map.ACTOR)
		if _G.type(dam) == "table" then chance, dam = dam.chance, dam.dam end
		local realdam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		if target then
			target:setEffect(target.EFF_SLOW, 3, {power=0.2, no_ct_effect=true})
			if rng.percent(chance) then
				DamageType:get(DamageType.FREEZE).projector(src, x, y, DamageType.FREEZE, {dur=2, hp=70+dam*1.5}, state)
			end
		end
		return realdam
	end,
}

-- Cold damage + freeze chance, increased if wet
newDamageType{
	name = _t"ice storm", type = "ICE_STORM", text_color = "#1133F3#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 25

		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:hasEffect(target.EFF_WET) then dam = dam * 1.3 chance = 50 end

		local realdam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		if rng.percent(chance) then
			DamageType:get(DamageType.FREEZE).projector(src, x, y, DamageType.FREEZE, {dur=2, hp=70+dam*1.5}, state)
		end
		return realdam
	end,
}

-- Increased cold damage + freeze chance if wet
newDamageType{
	name = _t"glacial vapour", type = "GLACIAL_VAPOUR", text_color = "#1133F3#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local chance = 0
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:hasEffect(target.EFF_WET) then dam = dam * 1.3 chance = 15 end
		local realdam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		if rng.percent(chance) then
			DamageType:get(DamageType.FREEZE).projector(src, x, y, DamageType.FREEZE, {dur=2, hp=70+dam*1.2}, state)
		end
		return realdam
	end,
}

-- Cold damage + freeze ground
newDamageType{
	name = _t"pinning cold", type = "COLDNEVERMOVE", text_color = "#CADET_BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=4, apply_power = math.max(src:combatSpellpower(), src:combatMindpower())} end
		DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			local apply = dam.apply_power
			if target:attr("negative_status_effect_immune_frozen") or (target:canBe("pin") and not target:attr("fly") and not target:attr("levitation")) then
				target:setEffect(target.EFF_FROZEN_FEET, dam.dur, {apply_power=dam.apply_power})
			end

			if dam.shatter_reduce and target:hasEffect(target.EFF_WET) then
				src:alterTalentCoolingdown(src.T_SHATTER, -dam.shatter_reduce)
			end
		end
	end,
}

-- Freezes target, checks for spellresistance and stun resistance
newDamageType{
	name = _t"freeze", type = "FREEZE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Freeze it, if we pass the test
			local sx, sy = game.level.map:getTileToScreen(x, y, true)
			if target:canBe("stun") then
				target:setEffect(target.EFF_FROZEN, dam.dur, {hp=dam.hp * 1.5, apply_power=math.max(src:combatSpellpower(), src:combatMindpower()), min_dur=1})
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, _t"Frozen!", {0,255,155})
			else
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, _t"Resist!", {0,255,155})
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}

-- Dim vision
newDamageType{
	name = _t"sticky smoke", type = "STICKY_SMOKE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_DIM_VISION, 5, {sight=dam, apply_power=src:combatAttack()})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}

-- Acid damage + blind chance
newDamageType{
	name = _t"acid blind", type = "ACID_BLIND", text_color = "#GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.ACID).projector(src, x, y, DamageType.ACID, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(25) then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, 3, {src=src, apply_power=math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Darkness damage + blind chance
newDamageType{
	name = _t"blinding darkness", type = "DARKNESS_BLIND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(25) then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, 3, {src=src, apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Light damage + blind chance
newDamageType{
	name = _t"blinding light", type = "LIGHT_BLIND", text_color = "#YELLOW#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(25) then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, 3, {src=src, apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Lightning damage + daze chance
newDamageType{
	name = _t"dazing lightning", type = "LIGHTNING_DAZE", text_color = "#ROYAL_BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, daze=25} end
		dam.daze = dam.daze or 25
		local oldundaze
		if src.turn_procs then src.turn_procs.dealing_damage_dont_undaze, oldundaze = true, src.turn_procs.dealing_damage_dont_undaze end
		local realdam = DamageType:get(DamageType.LIGHTNING).projector(src, x, y, DamageType.LIGHTNING, dam.dam, state)
		if src.turn_procs then src.turn_procs.dealing_damage_dont_undaze = oldundaze end
		local target = game.level.map(x, y, Map.ACTOR)
		if target and dam.daze > 0 and rng.percent(dam.daze) then
			if target:canBe("stun") then
				game:onTickEnd(function() target:setEffect(target.EFF_DAZED, (dam.daze_duration or 3), {src=src, apply_power=dam.power_check or math.max(src:combatSpellpower(), src:combatMindpower(), src:combatAttack())}) end) -- Do it at the end so we don't break our own daze
				if src:isTalentActive(src.T_HURRICANE) then
					local t = src:getTalentFromId(src.T_HURRICANE)
					t.do_hurricane(src, t, target)
				end
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
				if dam.shock then
					target:setEffect(target.EFF_SHOCKED, dam.shock, {apply_power=src:combatSpellpower()})
				end
			end
		end
		return realdam
	end,
}

-- Cold/physical damage + repulsion; checks for spell power against physical resistance
newDamageType{
	name = _t"cold repulsion", type = "WAVE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local srcx, srcy = dam.x, dam.y
		local base = dam
		dam = dam.dam
		if not base.st then
			DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam / 2, state)
			DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 2, state)
		else
			DamageType:get(base.st).projector(src, x, y, base.st, dam, state)
		end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if base.apply_wet then
				target:setEffect(target.EFF_WET, base.apply_wet, {})
			end

			if target:checkHit(base.power or src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(srcx, srcy, base.dist or 1)
				target:crossTierEffect(target.EFF_OFFBALANCE, base.power or src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the wave!", target:getName():capitalize())
			end
		end
	end,
}

-- Bloodspring damage + repulsion; checks for spell power against physical resistance
newDamageType{
	name = _t"bloodspring", type = "BLOODSPRING",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local srcx, srcy = dam.x, dam.y
		local base = dam
		dam = dam.dam
		DamageType:get(base.st).projector(src, x, y, base.st, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:checkHit(base.power or src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(srcx, srcy, base.dist or 1)
				target:crossTierEffect(target.EFF_OFFBALANCE, base.power or src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the bloody wave!", target:getName():capitalize())
			end
		end
	end,
}

-- Fireburn damage + repulsion; checks for spell power against physical resistance
newDamageType{
	name = _t"fire repulsion", type = "FIREKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if _G.type(dam) ~= "table" then dam = {dam=dam, dist=3} end
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			DamageType:get(DamageType.FIREBURN).projector(src, x, y, DamageType.FIREBURN, dam.dam, state)
			if target:checkHit(src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, dam.dist)
				target:crossTierEffect(target.EFF_OFFBALANCE, src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the punch!", target:getName():capitalize())
			end
		end
	end,
}

-- Fireburn damage + repulsion; checks for mind power against physical resistance
newDamageType{
	name = _t"burning repulsion", type = "FIREKNOCKBACK_MIND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if _G.type(dam) ~= "table" then dam = {dam=dam, dist=3} end
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			DamageType:get(DamageType.FIREBURN).projector(src, x, y, DamageType.FIREBURN, dam.dam, state)
			if target:checkHit(src:combatMindpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, dam.dist)
				target:crossTierEffect(target.EFF_OFFBALANCE, src:combatMindpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the punch!", target:getName():capitalize())
			end
		end
	end,
}

-- Darkness damage + repulsion; checks for spell power against mental resistance
newDamageType{
	name = _t"darkness repulsion", type = "DARKKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if _G.type(dam) ~= "table" then dam = {dam=dam, dist=3} end
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam.dam, state)
			if target:checkHit(src:combatSpellpower(), target:combatMentalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, dam.dist)
				target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the darkness!", target:getName():capitalize())
			end
		end
	end,
}

-- Physical damage + repulsion; checks for spell power against physical resistance
newDamageType{
	name = _t"physical repulsion", type = "SPELLKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local realdam = 0
		if _G.type(dam) ~= "table" then dam = {dam=dam, dist=3} end
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			realdam = DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
			if target:checkHit(src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, dam.dist)
				target:crossTierEffect(target.EFF_OFFBALANCE, src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the punch!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Physical damage + repulsion; checks for mind power against physical resistance
newDamageType{
	name = _t"physical repulsion", type = "MINDKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam, state)
			if target:checkHit(src:combatMindpower() * 0.8, target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, 3)
				target:crossTierEffect(target.EFF_OFFBALANCE, src:combatMindpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the punch!", target:getName():capitalize())
			end
		end
	end,
}

-- Physical damage + repulsion; checks for attack power against physical resistance
newDamageType{
	name = _t"physical repulsion", type = "PHYSKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		state = initState(state)
		if _G.type(dam) ~= "table" then dam = {dam=dam, dist=3} end
		if not dam.check then dam.check = src:combatPhysicalpower() end
		if target and not state[target] then
			state[target] = true
			DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
			if target:checkHit(dam.check, target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(dam.x or src.x, dam.y or src.y, dam.dist)
				target:crossTierEffect(target.EFF_OFFBALANCE, dam.check)
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
			end
		end
	end,
}

-- Fear check + repulsion; checks for mind power against physical resistance
newDamageType{
	name = _t"fear repulsion", type = "FEARKNOCKBACK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			if target:checkHit(src:combatMindpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("fear") then
				target:knockback(dam.x, dam.y, dam.dist)
				target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatMindpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the frightening sight!", target:getName():capitalize())
			end
		end
	end,
}

-- Poisoning damage
newDamageType{
	name = _t"poison", type = "POISON", text_color = "#LIGHT_GREEN#",
	projector = function(src, x, y, t, dam)
		state = initState(state)
		useImplicitCrit(src, state)
		local power
		if type(dam) == "table" then
			power = dam.apply_power
			dam = dam.dam
		end
		local realdam = DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam / 6, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("poison") then
			target:setEffect(target.EFF_POISONED, 5, {src=src, power=dam / 6})
		end
		return realdam
	end,
}

-- Inferno: fire and maybe remove stuff
newDamageType{
	name = _t"cleansing fire", type = "INFERNO",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:attr("cleansing_flames") and rng.percent(src:attr("cleansing_flames")) then
			local effs = {}
			local status = (src:reactionToward(target) >= 0) and "detrimental" or "beneficial"
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.status == status and (e.type == "magical" or e.type == "physical") then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
			if #effs > 0 then
				local eff = rng.tableRemove(effs)
				target:dispel(eff[2], src)
			end
		end
		return realdam
	end,
}

-- Spydric poison: prevents movement
newDamageType{
	name = _t"spydric poison", type = "SPYDRIC_POISON",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=3} end
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam / dam.dur, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("poison") then
			target:setEffect(target.EFF_SPYDRIC_POISON, dam.dur, {src=src, power=dam.dam / dam.dur, no_ct_effect=true})
		end
	end,
}

-- Crippling poison: failure to act
newDamageType{
	name = _t"crippling poison", type = "CRIPPLING_POISON", text_color = "#LIGHT_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=3, fail=50*dam/(dam+50)} end
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam / dam.dur, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("poison") then
			target:setEffect(target.EFF_CRIPPLING_POISON, dam.dur, {src=src, power=dam.dam / dam.dur, fail=dam.fail or 0, no_ct_effect=true})
		end
	end,
}

-- Insidious poison: prevents healing
newDamageType{
	name = _t"insidious poison", type = "INSIDIOUS_POISON", text_color = "#LIGHT_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=7, heal_factor=150*dam/(dam+100)} end
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam / dam.dur, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("poison") then
			target:setEffect(target.EFF_INSIDIOUS_POISON, dam.dur, {src=src, power=dam.dam / dam.dur, heal_factor=dam.heal_factor, no_ct_effect=true})
		end
	end,
}

-- Bleeding damage
newDamageType{
	name = _t"bleed", type = "BLEED",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 6, state)
		dam = dam - dam / 6
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("cut") then
			-- Set on fire!
			target:setEffect(target.EFF_CUT, 5, {src=src, power=dam / 5, no_ct_effect=true})
		end
	end,
}

-- Physical damage + bleeding (50% of base over 5 turns)
newDamageType{
	name = _t"physical bleed", type = "PHYSICALBLEED",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if realdam > 0 and target and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 5, {src=src, power=dam * 0.1, no_ct_effect=true})
		end
	end,
}

-- Slime damage
newDamageType{
	name = _t"nature slow", type = "SLIME", text_color = "#LIGHT_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, power=0.15} end
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SLOW, 3, {power=dam.power, no_ct_effect=true})
		end
	end,
}


newDamageType{
	name = _t"dig", type = "DIG",
	projector = function(src, x, y, typ, dam)
		state = initState(state)
		useImplicitCrit(src, state)
		local feat = game.level.map(x, y, Map.TERRAIN)
		if feat then
			if feat.dig then
				local newfeat_name, newfeat, silence = feat.dig, nil, false
				if type(feat.dig) == "function" then newfeat_name, newfeat, silence = feat.dig(src, x, y, feat) end
				newfeat = newfeat or game.zone.grid_list[newfeat_name]
				if newfeat then
					game.level.map(x, y, Map.TERRAIN, newfeat)
					src.dug_times = (src.dug_times or 0) + 1
					if src.turn_procs then src.turn_procs.has_dug = (src.turn_procs.has_dug or 0) + 1 end
					game.nicer_tiles:updateAround(game.level, x, y)
					if not silence then
						game.logSeen({x=x,y=y}, "%s turns into %s.", _t(feat.name):capitalize(), _t(newfeat.name))
					end
				end
			end
		end
	end,
}

-- Slowness
newDamageType{
	name = _t"slow", type = "SLOW",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local dur = 7
		if _G.type(dam) == "table" then dam, dur = dam.dam, dam.dur end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Freeze it, if we pass the test
			target:setEffect(target.EFF_SLOW, dur, {power=dam, apply_power=src:combatSpellpower()})
		end
	end,
}

newDamageType{
	name = _t"congeal time", type = "CONGEAL_TIME",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Freeze it, if we pass the test
			target:setEffect(target.EFF_CONGEAL_TIME, 7, {slow=dam.slow, proj=dam.proj, apply_power=src:combatSpellpower()})
		end
	end,
}

-- Time prison, invulnerability and stun
newDamageType{
	name = _t"time prison", type = "TIME_PRISON",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Freeze it, if we pass the test
			if src == target then
				target:setEffect(target.EFF_TIME_PRISON, dam, {no_ct_effect=true})
				target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=src:combatSpellpower(0.3), no_ct_effect=true})
			elseif target:checkHit(src:combatSpellpower() - (target:attr("continuum_destabilization") or 0), target:combatSpellResist(), 0, 95, 15) then
				target:setEffect(target.EFF_TIME_PRISON, dam, {apply_power=src:combatSpellpower() - (target:attr("continuum_destabilization") or 0), apply_save="combatSpellResist", no_ct_effect=true})
				target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=src:combatSpellpower(0.3), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the time prison.", target:getName():capitalize())
			end
		end
	end,
}

-- Confusion
newDamageType{
	name = _t"confusion", type = "CONFUSION",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, dam.dur, {power=dam.dam or 30, apply_power=(dam.power_check or src.combatSpellpower)(src)})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}

-- Confusion
newDamageType{
	name = _t"% chance of confusion", type = "RANDOM_CONFUSION",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam.dam) then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, 4, {power=dam.power or 30, apply_power=(dam.power_check or src.combatSpellpower)(src), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}

-- Confusion
newDamageType{
	name = _t"% chance of confusion", type = "RANDOM_CONFUSION_PHYS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam.dam) then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, 4, {power=dam.power or 30, apply_power=src:combatPhysicalpower(), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"% chance of gloom effects", type = "RANDOM_GLOOM",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam) then
			if not src:checkHit(src:combatMindpower(), target:combatMentalResist()) then return end
			local effect = rng.range(1, 3)
			if effect == 1 then
				-- confusion
				if target:canBe("confusion") and not target:hasEffect(target.EFF_GLOOM_CONFUSED) then
					target:setEffect(target.EFF_GLOOM_CONFUSED, 2, {power=70})
				end
			elseif effect == 2 then
				-- stun
				if target:canBe("stun") and not target:hasEffect(target.EFF_GLOOM_STUNNED) then
					target:setEffect(target.EFF_GLOOM_STUNNED, 2, {})
				end
			elseif effect == 3 then
				-- slow
				if target:canBe("slow") and not target:hasEffect(target.EFF_GLOOM_SLOW) then
					target:setEffect(target.EFF_GLOOM_SLOW, 2, {power=0.3})
				end
			end
		end
	end,
}

----------------------------------------------------------------
-- Item-specific damage types
----------------------------------------------------------------
-- Each uses the highest of Accuracy, Spellpower, or Mindpower for apply_power but typically uses the most thematic power for other effects
-- tdesc is only used in item tooltips and replaces the normal melee_project display

-- Name:  item - theme - debuff/effect
-- This entire system should probably be moved outside of DTs/melee_project at some point
newDamageType{
	name = _t"item darkness numbing", type = "ITEM_DARKNESS_NUMBING",
	text_color = "#GREY#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 1, 35))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to reduce damage dealt by #YELLOW#%d%%#LAST#%s")
			:tformat(dam, val, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
				local reduction = math.floor(src:combatStatScale(src:combatMindpower(), 1, 35))+5
				target:setEffect(target.EFF_ITEM_NUMBING_DARKNESS, 3, {reduce = reduction, apply_power=check, no_ct_effect=true})
			end
		end
	end,
}

newDamageType{
	name = _t"item expose", type = "ITEM_MIND_EXPOSE",
	text_color = "#GREY#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 1, 45))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to reduce all saves and defense by #YELLOW#%d#LAST#%s")
			:tformat(dam, val, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
				local reduction = math.floor(src:combatStatScale(src:combatMindpower(), 1, 45))+5
				target:setEffect(target.EFF_ITEM_EXPOSED, 3, {reduce = reduction, apply_power=check, no_ct_effect=true})
			end
		end
	end,
}

newDamageType{
	name = _t"item temporal energize", type = "ITEM_TEMPORAL_ENERGIZE",
	text_color = "#LIGHT_STEEL_BLUE#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to gain 10%% of a turn (3/turn limit)%s")
			:tformat(dam, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src and src.name and rng.percent(dam) then
			if src.turn_procs and src.turn_procs.item_temporal_energize and src.turn_procs.item_temporal_energize > 3 then
				game.logSeen(src, "#LIGHT_STEEL_BLUE#%s can't gain any more energy this turn! ", src:getName():capitalize())
				return
			end
			local energy = (game.energy_to_act * 0.1)
			src.energy.value = src.energy.value + energy
			src.turn_procs.item_temporal_energize = 1 + (src.turn_procs.item_temporal_energize or 0)
		end
	end,
}

newDamageType{
	name = _t"item acid corrode", type = "ITEM_ACID_CORRODE", text_color = "#GREEN#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and src:combatStatScale(src:combatSpellpower(), 10, 45)+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to reduce armor by #VIOLET#%d%%#LAST#%s")
			:tformat(dam, val, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
				local reduction = src:combatStatScale(src:combatSpellpower(), 10, 45)+5
				target:setEffect(target.EFF_ITEM_ACID_CORRODE, 3, {pct = reduction / 100, no_ct_effect = true, apply_power = check})
			end
		end
	end,
}

newDamageType{
	name = _t"item blight disease", type = "ITEM_BLIGHT_DISEASE", text_color = "#DARK_GREEN#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatSpellpower(), 1, 35))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to reduce strength, dexterity, and constitution by #VIOLET#%d#LAST#%s")
			:tformat(dam, val, parens )
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				if target:canBe("disease") then
					local check = math.max(src:combatSpellpower(), src:combatMindpower(), src:combatAttack())
					local disease_power = math.floor(src:combatStatScale(src:combatSpellpower(), 1, 35))+5
					target:setEffect(target.EFF_ITEM_BLIGHT_ILLNESS, 3, {reduce = disease_power, no_ct_effect = true})
				end
			end
		end
	end,
}

newDamageType{
	name = _t"item manaburn arcane", type = "ITEM_ANTIMAGIC_MANABURN", text_color = "#PURPLE#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d#LAST#)"):format(diff)
			end
		end
		return ("* #DARK_ORCHID#%d arcane resource#LAST# burn%s")
			:tformat(dam or 0, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			return DamageType:get(DamageType.MANABURN).projector(src, x, y, DamageType.MANABURN, dam, state)
		end
		return 0
	end,
}

newDamageType{
	name = _t"item nature slow", type = "ITEM_NATURE_SLOW", text_color = "#LIGHT_GREEN#",
	tdesc = function(dam, oldDam, src)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 20, 70))+10 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to slow global speed by #YELLOW#%d%%#LAST#%s")
			:tformat(dam or 0, val, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam) then
			local slow_power = math.floor(src:combatStatScale(src:combatMindpower(), 20, 70)+10) / 100
			target:setEffect(target.EFF_SLOW, 3, {power = slow_power, no_ct_effect=true})
		end
	end,
}

------------------------------------------------------------------------------------
-- The item damage types below have been removed from most if not all egos
-- You can still use them, just note that they're rare/unused for a reason

-- Reduces all offensive powers by 20%
newDamageType{
	name = _t"item antimagic scouring", type = "ITEM_ANTIMAGIC_SCOURING", text_color = "#ORCHID#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to #ORCHID#reduce effective powers#LAST# by %d%%%s")
			:tformat(dam, 20, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				target:setEffect(target.EFF_ITEM_ANTIMAGIC_SCOURED, 3, {pct = 0.2, no_ct_effect=true})
			end
		end
	end,
}

newDamageType{
	name = _t"item lightning daze", type = "ITEM_LIGHTNING_DAZE",
	text_color = "#ROYAL_BLUE#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to #ROYAL_BLUE#daze#LAST# at end of turn%s")
			:tformat(dam, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				if target:canBe("stun") then
					local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
					game:onTickEnd(function() target:setEffect(target.EFF_DAZED, 3, {apply_power=check, no_ct_effect=true}) end) --onTickEnd to avoid breaking the daze
				end
			end
		end
	end,
}

newDamageType{
	name = _t"item light blind", type = "ITEM_LIGHT_BLIND",
	text_color = "#YELLOW#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to #YELLOW#blind#LAST#%s")
			:tformat(dam, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				if target:canBe("blind") then
					local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
					target:setEffect(target.EFF_BLINDED, 3, {apply_power=(check), no_ct_effect=true})
				else
					game.logSeen(target, "%s resists the blinding light!", target:getName():capitalize())
				end
			end
		end
	end,
}

newDamageType{
	name = _t"item mind gloom", type = "ITEM_MIND_GLOOM",
	text_color = "#YELLOW#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to cause #YELLOW#random gloom#LAST#%s")
			:tformat(dam, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
				local check = math.max(src:combatAttack(), src:combatSpellpower(), src:combatMindpower())
				if not src:checkHit(check, target:combatMentalResist()) then return end
				local effect = rng.range(1, 3)
				local name
				if effect == 1 then
					if target:canBe("confusion") and not target:hasEffect(target.EFF_GLOOM_CONFUSED) then
						target:setEffect(target.EFF_GLOOM_CONFUSED, 2, {power=25, no_ct_effect=true} )
					end
					name = _t"confusion"
				elseif effect == 2 then
					if target:canBe("stun") and not target:hasEffect(target.EFF_GLOOM_STUNNED) then
						target:setEffect(target.EFF_GLOOM_STUNNED, 2, {no_ct_effect=true})
					end
					name = _t"stun"
				elseif effect == 3 then
					if target:canBe("slow") and not target:hasEffect(target.EFF_GLOOM_SLOW) then
						target:setEffect(target.EFF_GLOOM_SLOW, 2, {power=0.3, no_ct_effect=true})
					end
					name = _t"slow'"
				end
			end
		end
	end,
}
------------------------------------------------------------------------------------

-- Blind
newDamageType{
	name = _t"blinding", type = "RANDOM_BLIND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam.dam) then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, 4, {apply_power=(dam.power_check or math.max(src:combatSpellpower(), src:combatPhysicalpower())), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists the blind!", target:getName():capitalize())
			end
		end
	end,
}

-- Physical + Blind
newDamageType{
	name = _t"blinding physical", type = "SAND",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, dam.dur, {apply_power=src:combatPhysicalpower(), apply_save="combatPhysicalResist"})
			else
				game.logSeen(target, "%s resists the sandstorm!", target:getName():capitalize())
			end
		end
	end,
}

-- Physical + Pinned
newDamageType{
	name = _t"physical pinning", type = "PINNING",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, dam.dur, {apply_power=src:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
			end
		end
	end,
}

-- Drain Exp
newDamageType{
	name = _t"regressive blight", type = "DRAINEXP",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local realdam = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:checkHit((dam.power_check or src.combatSpellpower)(src), (dam.resist_check or target.combatMentalResist)(target), 0, 95, 15) then
				target:gainExp(-dam.dam*2)
				src:logCombat(target, "#Source# drains experience from #Target#!")
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Drain Life
newDamageType{
	name = _t"draining blight", type = "DRAINLIFE", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, healfactor=0.4} end
		local target = game.level.map(x, y, Map.ACTOR) -- Get the target first to make sure we heal even on kill
		dam.source = dam.source or target
		local realdam = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam, state)
		if target and realdam > 0 and not src:attr("dead") then
			src:heal(realdam * dam.healfactor, dam.source)
		end
		return realdam
	end,
}

-- Used by Blood Grasp, heal+temporary max life based on damage
newDamageType{
	name = _t"sanguine blight", type = "SANGUINE", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR) -- Get the target first to make sure we heal even on kill
		local dealt = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam, state)
		if dealt > 0 then
			src:setEffect(src.EFF_BLOOD_GRASP, 7, {life = dealt * 0.5} )
			src:heal(dealt * 0.2, src)
		end
		return dealt
	end,
}
-- Drain Vim
newDamageType{
	name = _t"vim draining blight", type = "DRAIN_VIM", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, vim=0.2} end
		local target = game.level.map(x, y, Map.ACTOR)
		local realdam = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam, state)
		if target and target ~= src and target.summoner ~= src and realdam > 0 then
			src:incVim(realdam * dam.vim * target:getRankVimAdjust())
		end
		return realdam
	end,
}

-- Demonfire: heal demon; damage others
newDamageType{
	name = _t"demonfire", type = "DEMONFIRE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:attr("demon") then
			target:heal(dam, src)
			return -dam
		elseif target then
			DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam, state)
			return dam
		end
	end,
}

-- Retch: heal undead; damage living
newDamageType{
	name = _t"purging blight", type = "RETCH",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)

		if target and src == target and target.type == "undead" and target.subtype == "ghoul" then
			target:setEffect(target.EFF_RETCHED, 1, {})
		end

		if target and (target:attr("undead") or target:attr("retch_heal")) then
			target:heal(dam * 1.5, src)

			if src.callTalent then
				if rng.percent(src:callTalent(src.T_RETCH, "getPurgeChance")) then
					local effs = {}
					local status = "detrimental"
					for eff_id, p in pairs(target.tmp) do
						local e = target.tempeffect_def[eff_id]
						if e.status == status and e.type == "physical" then
							effs[#effs+1] = {"effect", eff_id}
						end
					end
					if #effs > 0 then
						local eff = rng.tableRemove(effs)
						target:dispel(eff[2], src)
					end
				end
			end
		elseif target then
			DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam, state)

			if src.callTalent then
				if rng.percent(src:callTalent(src.T_RETCH, "getPurgeChance")) then
					local effs = {}
					local status = "beneficial"
					for eff_id, p in pairs(target.tmp) do
						local e = target.tempeffect_def[eff_id]
						if e.status == status and e.type == "physical" then
							effs[#effs+1] = {"effect", eff_id}
						end
					end
					if #effs > 0 then
						local eff = rng.tableRemove(effs)
						target:removeEffect(eff[2])
					end
				end
			end
		end
	end,
}

-- Holy light, damage demon/undead; heal others
newDamageType{
	name = _t"holy light", type = "HOLY_LIGHT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and not target:attr("undead") and not target:attr("demon") then
			target:heal(dam / 2, src)
		elseif target then
			DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
		end
	end,
}

-- Heals
newDamageType{
	name = _t"healing", type = "HEAL",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:attr("allow_on_heal", 1)
			target:heal(dam, src)
			target:attr("allow_on_heal", -1)
		end
	end,
}

-- Used by Bathe in Light, healing
-- Keep an eye on this and Weapon of Light for any infinite stack shield then engage combos
newDamageType{
	name = _t"healing light", type = "HEALING_POWER",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_EMPOWERED_HEALING, 1, {power=(dam/(dam+50))})
			if dam >= 100 then target:attr("allow_on_heal", 1) end
			target:heal(dam, src)

			-- If the target is shielded already then add to the shield power, else add a shield
			local shield_power = dam * util.bound((target.healing_factor or 1), 0, 2.5)
			if not target:hasEffect(target.EFF_DAMAGE_SHIELD) then
				target:setEffect(target.EFF_DAMAGE_SHIELD, 2, {power=shield_power})
			else
				-- Shields can't usually merge, so change the parameters manually
				local shield = target:hasEffect(target.EFF_DAMAGE_SHIELD)
				shield.power = shield.power + shield_power
				target.damage_shield_absorb = target.damage_shield_absorb + shield_power
				target.damage_shield_absorb_max = target.damage_shield_absorb_max + shield_power
				shield.dur = math.max(2, shield.dur)

				-- Limit the number of times a shield can be extended
				if shield.dur_extended then
					shield.dur_extended = shield.dur_extended + 1
					if shield.dur_extended >= 20 then
						game.logPlayer(target, "#DARK_ORCHID#Your damage shield cannot be extended any farther and has exploded.")
						target:removeEffect(target.EFF_DAMAGE_SHIELD)
					end
				else shield.dur_extended = 1 end
			end
			if dam >= 100 then target:attr("allow_on_heal", -1) end
		end
	end,
}

-- Light damage+heal source, used by Radiance
newDamageType{
	name = _t"judgement", type = "JUDGEMENT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target ~= src then
			--print("[JUDGEMENT] src ", src, "target", target, "src", src )
			DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
			if not src:attr("dead") then
				if dam >= 100 then src:attr("allow_on_heal", 1) end
				src:heal(dam / 2, src)
				if dam >= 100 then src:attr("allow_on_heal", -1) end
			end
		end
	end,
}

newDamageType{
	name = _t"healing nature", type = "HEALING_NATURE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and not target:attr("undead") then
			if dam >= 100 then target:attr("allow_on_heal", 1) else target:attr("silent_heal", 1) end
			target:heal(dam, src)
			if dam >= 100 then target:attr("allow_on_heal", -1) else target:attr("silent_heal", -1) end
		elseif target then
			DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam, state)
		end
	end,
}

-- Corrupted blood, blight damage + potential diseases
-- Should no longer be used on items, use ITEM_BLIGHT_DISEASE
newDamageType{
	name = _t"infective blight", type = "CORRUPTED_BLOOD", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("disease") and rng.percent(dam.disease_chance or 20) then
			local eff = rng.table{{target.EFF_ROTTING_DISEASE, "con"}, {target.EFF_DECREPITUDE_DISEASE, "dex"}, {target.EFF_WEAKNESS_DISEASE, "str"}}
			target:setEffect(eff[1], dam.dur or 5, { src = src, [eff[2]] = dam.disease_power or 5, dam = dam.disease_dam or (dam.dam / 5) })
		end
		DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam, state)
	end,
}

-- blood boiled, blight damage + slow
newDamageType{
	name = _t"hindering blight", type = "BLOOD_BOIL", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and not target:attr("undead") and not target:attr("construct") then
			target:setEffect(target.EFF_SLOW, 4, {power=0.2, no_ct_effect=true})
		end
	end,
}

-- life leech (used cursed gloom skill)
newDamageType{
	name = _t"life leech",
	type = "LIFE_LEECH",
	text_color = "#F53CBE#",
	hideMessage=true,
	hideFlyer=true
}

-- Physical + Stun Chance
newDamageType{
	name = _t"physical stun", type = "PHYSICAL_STUN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(25) then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, 2, {src=src, apply_power=src:combatSpellpower(), min_dur=1})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		end
	end,
}

-- Physical Damage/Cut Split
newDamageType{
	name = _t"physical bleed", type = "SPLIT_BLEED",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 2, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 12, state)
		dam = dam - dam / 12
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 5, {src=src, power=dam / 11, no_ct_effect=true})
		end
	end,
}

-- Temporal/Physical damage
newDamageType{
	name = _t"warp", type = "WARP",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam / 2, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 2, state)
	end,
}

-- Temporal/Darkness damage
newDamageType{
	name = _t"temporal darkness", type = "VOID", text_color = "#GREY#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam / 2, state)
		DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam / 2, state)
	end,
}

-- Gravity damage types
newDamageType{
	name = _t"gravity", type = "GRAVITY",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		if target then
			if target:isTalentActive(target.T_GRAVITY_LOCUS) then return end
			if dam.slow then
				target:setEffect(target.EFF_SLOW, dam.dur, {power=dam.slow, apply_power=apply, no_ct_effect=true})
			end
		end
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
	end,
}

newDamageType{
	name = _t"gravity pin", type = "GRAVITYPIN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local reapplied = false
		if target and not target:isTalentActive(target.T_GRAVITY_LOCUS) then
			-- silence the apply message if the target already has the effect
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.desc == "Pinned to the ground" then
					reapplied = true
				end
			end
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, 2, {apply_power=src:combatSpellpower(), min_dur=1}, reapplied)
			else
				game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
			end
			DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam, state)
		end
	end,
}

newDamageType{
	name = _t"physical repulsion", type = "REPULSION",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		state = initState(state)
		-- extra damage on pinned targets
		if target and target:attr("never_move") then
			dam = dam * 1.5
		end
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam, state) -- This damage type can deal damage multiple times, use with accordingly
		-- check knockback
		if target and not target:attr("never_move") and not state[target] then
			state[target] = true
			if target:checkHit(src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				target:knockback(src.x, src.y, 2)
				target:crossTierEffect(target.EFF_OFFBALANCE, src:combatSpellpower())
				game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
			else
				game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"grow", type = "GROW",
	projector = function(src, x, y, typ, dam)
		state = initState(state)
		useImplicitCrit(src, state)
		local feat = game.level.map(x, y, Map.TERRAIN)
		if feat then
			if feat.grow then
				local newfeat_name, newfeat, silence = feat.grow, nil, false
				if type(feat.grow) == "function" then newfeat_name, newfeat, silence = feat.grow(src, x, y, feat) end
				newfeat = newfeat or game.zone.grid_list[newfeat_name]
				if newfeat then
					game.level.map(x, y, Map.TERRAIN, newfeat)
					if not silence then
						game.logSeen({x=x,y=y}, "%s turns into %s.", _t(feat.name):capitalize(), (_t(newfeat) or _t(game.zone.grid_list[newfeat_name]).name))
					end
				end
			end
		end
	end,
}

-- Mosses
newDamageType{
	name = _t"pinning nature", type = "GRASPING_MOSS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam, state)
			target:setEffect(target.EFF_SLOW_MOVE, 4, {apply_power=src:combatMindpower(), power=dam.slow/100}, true)
			if target:canBe("pin") and rng.percent(dam.pin) then
				target:setEffect(target.EFF_PINNED, 4, {apply_power=src:combatMindpower()}, true)
			else
				game.logSeen(target, "%s resists the pinning!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"healing nature", type = "NOURISHING_MOSS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			local realdam = DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam, state)
			if realdam > 0 and not src:attr("dead") then src:heal(realdam * dam.factor, target) end
		end
	end,
}

newDamageType{
	name = _t"impeding nature", type = "SLIPPERY_MOSS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam, state)
			target:setEffect(target.EFF_SLIPPERY_MOSS, 2, {apply_power=src:combatMindpower(), fail=dam.fail}, true)
		end
	end,
}

newDamageType{
	name = _t"confounding nature", type = "HALLUCINOGENIC_MOSS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam, state)
			if target:canBe("confusion") and rng.percent(dam.chance) then
				target:setEffect(target.EFF_CONFUSED, 2, {apply_power=src:combatMindpower(), power=dam.power or 30}, true)
			else
				game.logSeen(target, "%s resists the confusion!", target:getName():capitalize())
			end
		end
	end,
}

-- Circles
newDamageType{
	name = _t"sanctity", type = "SANCTITY",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target == src then
				target:setEffect(target.EFF_SANCTITY, 1, {power=dam, no_ct_effect=true})
			elseif target:canBe("silence") then
				DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
				target:setEffect(target.EFF_SILENCED, 2, {apply_power=src:combatSpellpower(), min_dur=1, no_ct_effect=true}, true)
			else
				DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
				game.logSeen(target, "%s resists the silence!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"defensive darkness", type = "SHIFTINGSHADOWS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target == src then
				target:setEffect(target.EFF_SHIFTING_SHADOWS, 1, {power= dam, no_ct_effect=true})
			else
				DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
			end
		end
	end,
}

newDamageType{
	name = _t"blazing light", type = "BLAZINGLIGHT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target == src then
				target:setEffect(target.EFF_BLAZING_LIGHT, 1, {power= 1 + (dam / 4), no_ct_effect=true})
			else
				DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam, state)
				DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
			end
		end
	end,
}

newDamageType{
	name = _t"prismatic repulsion", type = "WARDING",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target == src then
				target:setEffect(target.EFF_WARDING, 1, {power=dam*5, no_ct_effect=true})
			elseif target ~= src then
				DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
				DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
				if target:checkHit(src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
					target:knockback(src.x, src.y, 1)
					game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
				else
					game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
				end
			end
		end
	end,
}

newDamageType{
	name = _t"mind slow", type = "MINDSLOW",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SLOW, 4, {power=dam/100, apply_power=src:combatMindpower()})
		end
	end,
}

-- Freezes target, checks for physresistance
newDamageType{
	name = _t"mind freeze", type = "MINDFREEZE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			-- Freeze it, if we pass the test
			if target:canBe("stun") then
				target:setEffect(target.EFF_FROZEN, dam, {hp=70 + src:combatMindpower() * 10, apply_power=src:combatMindpower()})
			else
				game.logSeen(target, "%s resists the freezing!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"implosion", type = "IMPLOSION",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local dur = 3
		local perc = 50
		if _G.type(dam) == "table" then dam, dur, perc = dam.dam, dam.dur, (dam.initial or perc) end
		local init_dam = dam
		if init_dam > 0 then DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, init_dam, state) end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_IMPLODING, dur, {src=src, power=dam})
		end
	end,
}

-- Temporal + Stat damage
newDamageType{
	name = _t"regressive temporal", type = "CLOCK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, stat=2 + math.ceil(dam/15), apply=src:combatSpellpower()} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_REGRESSION, 3, {power=dam.stat, apply_power=dam.apply,  min_dur=1, no_ct_effect=true})
		end
		-- Reduce Con then deal the damage
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam.dam, state)
	end,
}

-- Temporal Over Time
newDamageType{
	name = _t"wasting temporal", type = "WASTING", text_color = "#LIGHT_STEEL_BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local dur = 3
		local perc = 30
		if _G.type(dam) == "table" then dam, dur, perc = dam.dam, dam.dur, (dam.initial or perc) end
		local init_dam = dam * perc / 100
		if init_dam > 0 then DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, init_dam, state) end
		if target then
			-- Set wasting effect
			dam = dam - init_dam
			target:setEffect(target.EFF_WASTING, dur, {src=src, power=dam / dur, no_ct_effect=true})
		end
		return init_dam
	end,
}

newDamageType{
	name = _t"stop", type = "STOP",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, dam, {apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s has not been stopped!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"debilitating temporal", type = "RETHREAD",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local chance = rng.range(1, 4)
		-- Pull random effect
		if target then
			if chance == 1 then
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, 3, {apply_power=src:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
				end
			elseif chance == 2 then
				if target:canBe("blind") then
					target:setEffect(target.EFF_BLINDED, 3, {apply_power=src:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the blindness!", target:getName():capitalize())
				end
			elseif chance == 3 then
				if target:checkHit(src:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("pin") then
					target:setEffect(target.EFF_PINNED, 3, {apply_power=src:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
				end
			elseif chance == 4 then
				if target:canBe("confusion") then
					target:setEffect(target.EFF_CONFUSED, 3, {power=dam.power or 30, apply_power=src:combatSpellpower()})
				else
					game.logSeen(target, "%s resists the confusion!", target:getName():capitalize())
				end
			end
		end
	end,
}

newDamageType{
	name = _t"draining physical", type = "DEVOUR_LIFE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR) -- Get the target first to make sure we heal even on kill
		if target then dam.dam = math.max(0, math.min(target.life, dam.dam)) end
		local realdam = DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
		if target and realdam > 0 and not src:attr("dead") then
			local heal = realdam * (dam.healfactor or 1)
			-- cannot be reduced
			local temp = src.healing_factor
			src.healing_factor = 1
			src:heal(heal, target)
			src.healing_factor = temp
			src:logCombat(target, "#Source# consumes %d life from #Target#!", heal)
		end
	end,
	hideMessage=true,
}

newDamageType{
	name = _t"temporal slow", type = "CHRONOSLOW",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.TEMPORAL).projector(src, x, y, DamageType.TEMPORAL, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local reapplied = false
		if target then
			-- silence the apply message if the target already has the effect
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.desc == "Slow" then
					reapplied = true
				end
			end
			target:setEffect(target.EFF_SLOW, 3, {power=dam.slow, apply_power=src:combatSpellpower()}, reapplied)
		end
	end,
}

newDamageType{
	name = _t"molten rock", type = "MOLTENROCK",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		return DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam / 2, state) +
		       DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 2, state)
	end,
}

newDamageType{
	name = _t"entangle", type = "ENTANGLE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam/3, state)
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, 2*dam/3, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, 5, {no_ct_effect=true})
			else
				game.logSeen(target, "%s resists entanglement!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"manaworm arcane", type = "MANAWORM",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.ARCANE).projector(src, x, y, DamageType.ARCANE, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if game.zone.void_blast_hits and game.party:hasMember(target) then game.zone.void_blast_hits = game.zone.void_blast_hits + 1 end

			if target:knowTalent(target.T_MANA_POOL) then
				target:setEffect(target.EFF_MANAWORM, 5, {power=dam * 5, src=src, no_ct_effect=true})
				src:disappear(src)
			else
				game.logSeen(target, "%s has no mana to burn.", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

newDamageType{
	name = _t"arcane blast", type = "VOID_BLAST",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.ARCANE).projector(src, x, y, DamageType.ARCANE, dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if game.zone.void_blast_hits and target and game.party:hasMember(target) then
			game.zone.void_blast_hits = game.zone.void_blast_hits + 1
		end
		return realdam
	end,
}

newDamageType{
	name = _t"circle of death", type = "CIRCLE_DEATH",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and (src:reactionToward(target) < 0 or dam.ff) then
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.subtype.bane then return end
			end

			local what = rng.percent(50) and "blind" or "confusion"
			if target:canBe(what) then
				target:setEffect(what == "blind" and target.EFF_BANE_BLINDED or target.EFF_BANE_CONFUSED, math.ceil(dam.dur), {src=src, power=50, dam=dam.dam, apply_power=src:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the baneful energy!", target:getName():capitalize())
			end
		end
	end,
}

-- Darkness damage + speed reduction + minion damage inc
newDamageType{
	name = _t"decaying darkness", type = "RIGOR_MORTIS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam.dam, state)
			target:setEffect(target.EFF_SLOW, dam.dur, {power=dam.speed, apply_power=src:combatSpellpower()})
			target:setEffect(target.EFF_RIGOR_MORTIS, dam.dur, {power=dam.minion, apply_power=src:combatSpellpower()})
		end
	end,
}

newDamageType{
	name = _t"abyssal darkness", type = "ABYSSAL_SHROUD",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		--make it dark
		game.level.map.remembers(x, y, false)
		game.level.map.lites(x, y, false)

		local target = game.level.map(x, y, Map.ACTOR)
		local reapplied = false
		if target then
			-- silence the apply message it if the target already has the effect
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.desc == "Abyssal Shroud" then
					reapplied = true
				end
			end
			target:setEffect(target.EFF_ABYSSAL_SHROUD, 2, {power=dam.power, lite=dam.lite, apply_power=src:combatSpellpower(), min_dur=1}, reapplied)
			DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam.dam, state)
		end
	end,
}

newDamageType{
	name = _t"% chance to summon an orc spirit", type = "GARKUL_INVOKE",
	text_color = "#SALMON#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, engine.Map.ACTOR)
		if not target then return end
		if game.party:hasMember(src) and game.party:findMember{type="garkul spirit"} then return end
		if not rng.percent(dam) then
			game:delayedLogDamage(src, target, 0, ("%s<%d%%%% orc summon chance>#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#", dam), false)
			return
		end

		game:delayedLogDamage(src, target, 0, ("%s<orc summon>#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#"), false)

		-- Find space
		local x, y = util.findFreeGrid(src.x, src.y, 5, true, {[engine.Map.ACTOR]=true})
		if not x then return end

		print("Invoking garkul spirit on", x, y)

		local NPC = require "mod.class.NPC"
		local orc = NPC.new{
			type = "humanoid", subtype = "orc",
			display = "o", color=colors.UMBER,
			combat = { dam=resolvers.rngavg(5,12), atk=2, apr=6, physspeed=2 },
			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			infravision = 10,
			lite = 1,
			rank = 2,
			size_category = 3,
			resolvers.racial(),
			resolvers.sustains_at_birth(),
			autolevel = "warrior",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=2, },
			stats = { str=20, dex=8, mag=6, con=16 },
			name = _t"orc spirit", color=colors.SALMON, image = "npc/humanoid_orc_orc_berserker.png",
			desc=_t[[An orc clad in massive armour, wielding a huge axe.]],
			level_range = {35, nil}, exp_worth = 0,
			max_life = resolvers.rngavg(110,120), life_rating = 12,
			resolvers.equip{
				{type="weapon", subtype="battleaxe", autoreq=true},
				{type="armor", subtype="massive", autoreq=true},
			},
			combat_armor = 0, combat_def = 5,

			resolvers.talents{
				[src.T_ARMOUR_TRAINING]={base=2, every=10, max=4},
				[src.T_WEAPON_COMBAT]={base=2, every=10, max=4},
				[src.T_WEAPONS_MASTERY]={base=2, every=10, max=4},
				[src.T_RUSH]={base=3, every=7, max=6},
				[src.T_STUNNING_BLOW]={base=3, every=7, max=6},
				[src.T_BERSERKER]={base=3, every=7, max=6},
			},

			faction = src.faction,
			summoner = src,
			summon_time = 6,
		}

		orc:resolve() orc:resolve(nil, true)
		game.zone:addEntity(game.level, orc, "actor", x, y)
		orc:forceLevelup(src.level)

		orc.remove_from_party_on_death = true
		game.party:addMember(orc, {control="no", type="garkul spirit", title=_t"Garkul Spirit"})
		orc:setTarget(target)
	end,
}

-- speed reduction, mind dam, darkness dam
newDamageType{
	name = _t"nightmare", type = "NIGHTMARE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then

			--Mind dam
			if rng.chance(10) then
				DamageType:get(DamageType.MIND).projector(src, x, y, DamageType.MIND, dam, state)
			end
			--Darkness dam
			if rng.chance(10) then
				DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
			end
			--slow
			if rng.chance(10) then
				target:setEffect(target.EFF_SLOW, 3, {power=0.3})
			end
		end
	end,
}

-- cursed/predator/savage hunter/cursed miasma effect damage type
newDamageType{
	name = _t"cursed miasma", type = "CURSED_MIASMA",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if src:reactionToward(target) < 0 then
				DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam, state)
				DamageType:get(DamageType.MIND).projector(src, x, y, DamageType.MIND, dam, state)
				local chance = src.callTalent and src:callTalent(src.T_SAVAGE_HUNTER, "getChance")
				if rng.percent(chance) then
					target:setEffect(target.EFF_CURSED_MIASMA, 1, {chance=chance, no_ct_effect=true})
				end
			end
		end
	end,
}

newDamageType{
	name = _t"weakness", type = "WEAKNESS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			local reapplied = target:hasEffect(target.EFF_WEAKENED)
			target:setEffect(target.EFF_WEAKENED, dam.dur, { power=dam.incDamage }, reapplied)
		end
	end,
}

-- Generic apply temporary effect
newDamageType{
	name = _t"special effect", type = "TEMP_EFFECT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			local ok = false
			if dam.friends then if src:reactionToward(target) >= 0 then ok = true end
			elseif dam.foes then if src:reactionToward(target) < 0 then ok = true end
			else ok = true
			end
			if ok and (not dam.check_immune or target:canBe(dam.check_immune)) then target:setEffect(dam.eff, dam.dur, table.clone(dam.p)) end
		end
	end,
}

newDamageType{
	name = _t"manaburn arcane", type = "MANABURN", text_color = "#PURPLE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			dam = target.burnArcaneResources and target:burnArcaneResources(dam) or 0
			if src.knowTalent and src:knowTalent(src.T_AURA_OF_SILENCE) and src.combatGetDamageIncrease then
				local bonus = src:combatGetDamageIncrease(DamageType.NATURE) / 100
				if bonus > 0 then dam = dam * (1 + bonus) end
			end
			return DamageType:get(DamageType.ARCANE).projector(src, x, y, DamageType.ARCANE, dam, state)
		end
		return 0
	end,
}

newDamageType{
	name = _t"leaves", type = "LEAVES",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if src:reactionToward(target) < 0 then
				if target:canBe("cut") then
					local reapplied = target:hasEffect(target.EFF_CUT)
					target:setEffect(target.EFF_CUT, 2, { power=dam.dam, src=src }, reapplied)
				end
			else
				local reapplied = target:hasEffect(target.EFF_LEAVES_COVER)
				target:setEffect(target.EFF_LEAVES_COVER, 1, { power=dam.chance }, reapplied)
			end
		end
	end,
}

-- Distortion; Includes knockback, penetrate, stun, and explosion paramters
newDamageType{
	name = _t"distorting physical", type = "DISTORTION",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		state = initState(state)
		if target and not state[target] then
			state[target] = true
			local old_pen = 0

			if core.shader.allow("distort") then game.level.map:particleEmitter(x, y, 1, "distortion") end

			-- Spike resists pen
			if dam.penetrate then
				old_pen = src.resists_pen and src.resists_pen[engine.DamageType.PHYSICAL] or 0
				src.resists_pen[engine.DamageType.PHYSICAL] = 100
			end
			-- Handle distortion effects
			if target:hasEffect(target.EFF_DISTORTION) then
				-- Explosive?
				if dam.explosion then
					src:project({type="ball", target.x, target.y, radius=dam.radius, friendlyfire=dam.friendlyfire}, target.x, target.y, engine.DamageType.DISTORTION, {dam=dam.explosion, power=dam.distort or 0})
					game.level.map:particleEmitter(target.x, target.y, dam.radius, "generic_blast", {radius=dam.radius, tx=target.x, ty=target.y, rm=255, rM=255, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
					dam.explosion_done = true
				end
				-- Stun?
				if dam.stun then
					dam.do_stun = true
				end
			end
			-- Our damage
			target:setEffect(target.EFF_DISTORTION, 2, {power=dam.distort or 0})
			if not dam.explosion_done then
				DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
			end
			-- Do knockback
			if dam.knockback then
				if target:checkHit(src:combatMindpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
					target:knockback(src.x, src.y, dam.knockback)
					target:crossTierEffect(target.EFF_OFFBALANCE, src:combatMindpower())
					game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
				else
					game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
				end
			end
			-- Do stun
			if dam.do_stun then
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, dam.stun, {apply_power=src:combatMindpower()})
				else
					game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
				end
			end
			-- Reset resists pen
			if dam.penetrate then
				src.resists_pen[engine.DamageType.PHYSICAL] = old_pen
			end
		end
	end,
}

-- Mind/Fire damage with lots of parameter options
newDamageType{
	name = _t"dreamforge", type = "DREAMFORGE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		local power, dur, chance, dist, fail, do_particles
		state = initState(state)
		if _G.type(dam) == "table" then dam, power, dur, chance, fail, dist, do_particles = dam.dam, dam.power, dam.dur, dam.chance, dam.fail, dam.dist, dam.do_particles end
		if target and not state[target] then
			if src:checkHit(src:combatMindpower(), target:combatMentalResist(), 0, 95) then
				DamageType:get(DamageType.MIND).projector(src, x, y, DamageType.MIND, {dam=dam/2, alwaysHit=true}, state)
				DamageType:get(DamageType.FIREBURN).projector(src, x, y, DamageType.FIREBURN, dam/2, state)
				if power and power > 0 then
					local silent = true and target:hasEffect(target.EFF_BROKEN_DREAM) or false
					target:setEffect(target.EFF_BROKEN_DREAM, dur, {power=power, fail=fail}, silent)
					if rng.percent(chance) then
						target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatMindpower())
					end
				end
				-- Do knockback
				if dist then
					if target:canBe("knockback") then
						target:knockback(src.x, src.y, dist)
						target:crossTierEffect(target.EFF_OFFBALANCE, src:combatMindpower())
						game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
					else
						game.logSeen(target, "%s resists the forge bellow!", target:getName():capitalize())
					end
				end
				if do_particles then
					if rng.percent(50) then
						game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=160, gM=160, bm=0, bM=0, am=35, aM=90})
					elseif hit then
						game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=255, bM=255, am=35, aM=90})
					end
				end
			else -- Save for half damage
				DamageType:get(DamageType.MIND).projector(src, x, y, DamageType.MIND, {dam=dam/4, alwaysHit=true}, state)
				DamageType:get(DamageType.FIREBURN).projector(src, x, y, DamageType.FIREBURN, dam/4, state)
				game.logSeen(target, "%s resists the dream forge!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"natural mucus", type = "MUCUS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and not target.turn_procs.mucus then
			target.turn_procs.mucus = true
			if src:reactionToward(target) >= 0 then
				if src == target then
					target:incEquilibrium(-(dam.self_equi or 1))
				else
					target:incEquilibrium(-(dam.equi or 1))
					src:incEquilibrium(-(dam.equi or 1))
				end
			elseif target:canBe("poison") then
				target:setEffect(target.EFF_POISONED, 5, {src=src, power=dam.dam, max_power = dam.dam*5, apply_power=src:combatMindpower()})
			end
		elseif not target and not src.turn_procs.living_mucus and src:knowTalent(src.T_LIVING_MUCUS) and game.zone and not game.zone.wilderness then
			src.turn_procs.living_mucus = true
			local t = src:getTalentFromId(src.T_LIVING_MUCUS)
			if rng.percent(t.getChance(src, t)) then
				t.spawn(src, t)
			end
		end
	end,
}

newDamageType{
	name = _t"disarming acid", type = "ACID_DISARM", text_color = "#GREEN#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {chance=25, dam=dam} end
		local realdam = DamageType:get(DamageType.ACID).projector(src, x, y, DamageType.ACID, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and rng.percent(dam.chance) then
			if target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, dam.dur or 3, {src=src, apply_power=src:combatMindpower()})
			else
				game.logSeen(target, "%s resists disarming!", target:getName():capitalize())
			end
		end
		return realdam
	end,
}

-- Acid damage + Accuracy/Defense/Armor Down Corrosion
newDamageType{
	name = _t"corrosive acid", type = "ACID_CORRODE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dur = 4, armor = dam/2, defense = dam/2, dam = dam, atk=dam/2} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			DamageType:get(DamageType.ACID).projector(src, x, y, DamageType.ACID, dam.dam, state)
			target:setEffect(target.EFF_CORRODE, dam.dur, {atk=dam.atk, armor=dam.armor, defense=dam.defense, apply_power=src:combatMindpower()})
		end
	end,
}

-- Bouncy slime!
newDamageType{
	name = _t"bouncing slime", type = "BOUNCE_SLIME",
	projector = function(src, x, y, type, dam, state, _, tg)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			local realdam = DamageType:get(DamageType.SLIME).projector(src, x, y, DamageType.SLIME, {dam=dam.dam, power=0.30}, state)

			if dam.nb > 0 then
				dam.done = dam.done or {}
				dam.done[target.uid] = true
				dam.nb = dam.nb - 1
				dam.dam = dam.dam*(dam.bounce_factor or 0.5) -- lose 50% damage by default
				local list = {}
				src:project({type="ball", selffire=false, x=x, y=y, radius=6, range=0}, x, y, function(bx, by)
					local actor = game.level.map(bx, by, Map.ACTOR)
					if actor and not dam.done[actor.uid] and src:reactionToward(actor) < 0 then
						print("[BounceSlime] found possible actor", actor.name, bx, by, "distance", core.fov.distance(x, y, bx, by))
						list[#list+1] = actor
					end
				end)
				if #list > 0 then
					local st = rng.table(list)
					src:projectile({type="bolt", range=6, x=x, y=y, speed = tg.speed or 6, name=tg.name or "bouncing slime", selffire=false, display={particle="bolt_slime"}}, st.x, st.y, DamageType.BOUNCE_SLIME, dam, {type="slime"})
				end
			end
			return realdam
		end
	end,
}

-- Acid damage + Slow
newDamageType{
	name = _t"caustic mire", type = "CAUSTIC_MIRE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dur = 2, slow=20} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			DamageType:get(DamageType.ACID).projector(src, x, y, DamageType.ACID, dam.dam, state)
			target:setEffect(target.EFF_SLOW, dam.dur, {power=dam.slow/100, apply_power=src:combatSpellpower()})
		end
	end,
}

-- Sun Path damage
newDamageType{
	name = _t"sun path", type = "SUN_PATH",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			return DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam, state)
		end
	end,
}

newDamageType{
	name = _t"telekinetic shove", type = "TK_PUSHPIN",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("knockback") then
				target:knockback(src.x, src.y, dam.push, nil, function(g, x, y)
					if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move", target) then
						DamageType:get(DamageType.PHYSICAL).projector(src, target.x, target.y, DamageType.PHYSICAL, dam.dam, state)
						if target:canBe("pin") then
							target:setEffect(target.EFF_PINNED, dam.dur, {apply_power=src:combatMindpower()})
						else
							game.logSeen(src, "%s resists pinning!", target:getName():capitalize())
						end
					end
				end)
				return dam.dam
			else
				DamageType:get(DamageType.PHYSICAL).projector(src, target.x, target.y, DamageType.PHYSICAL, dam.dam, state)
				game.logSeen(src, "%s resists the shove!", target:getName():capitalize())
				return dam.dam
			end
		end
	end,
}

-- Prevents Teleportation
newDamageType{
	name = _t"dimensional anchor", type = "DIMENSIONAL_ANCHOR",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, dur=dur or 4, apply_power=apply_power or src:combatSpellpower()} end
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_DIMENSIONAL_ANCHOR, 1, {damage=dam.dam, src=src, dur=dam.dur, apply_power=dam.apply_power, no_ct_effect=true})
		end
	end,
}

-- Causes a random warp status effect; these do cause cross tier effects
newDamageType{
	name = _t"phase pulse", type = "RANDOM_WARP",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)

		local target = game.level.map(x, y, Map.ACTOR)
		if not target or target.dead then return end

		local eff = rng.range(1, 4)
		local power = dam.apply_power or src:combatSpellpower()
		local dur = dam.dur or 4
		-- Pull random effect
		if eff == 1 then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, dur, {apply_power=power})
			else
				game.logSeen(target, "%s resists the stun!", target:getName():capitalize())
			end
		elseif eff == 2 then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, dur, {apply_power=power})
			else
				game.logSeen(target, "%s resists the blindness!", target:getName():capitalize())
			end
		elseif eff == 3 then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, dur, {apply_power=power})
			else
				game.logSeen(target, "%s resists the pin!", target:getName():capitalize())
			end
		elseif eff == 4 then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, dur, {power=dam.power or 30, apply_power=power})
			else
				game.logSeen(target, "%s resists the confusion!", target:getName():capitalize())
			end
		end
	end,
}

newDamageType{
	name = _t"brain storm", type = "BRAINSTORM",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			DamageType:get(DamageType.LIGHTNING).projector(src, target.x, target.y, DamageType.LIGHTNING, dam, state)
			if target:checkHit(src:combatMindpower(), target:combatMentalResist(), 0, 95, 15) then
				target:crossTierEffect(target.EFF_BRAINLOCKED, src:combatMindpower())
			else
				game.logSeen(target, "%s resists the mind attack!", target:getName():capitalize())
			end

			if src:hasEffect(src.EFF_TRANSCENDENT_ELECTROKINESIS) then
				if target:canBe("blind") then
					target:setEffect(target.EFF_BLINDED, 4, {apply_power=src:combatMindpower()})
				end
			end
			return dam
		end
	end,
}

newDamageType{
	name = _t"static net", type = "STATIC_NET",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			DamageType:get(DamageType.LIGHTNING).projector(src, x, y, DamageType.LIGHTNING, dam.dam, state)
			target:setEffect(target.EFF_SLOW, 4, {apply_power=src:combatMindpower(), power=dam.slow/100}, true)
		elseif target == src then
			target:setEffect(target.EFF_STATIC_CHARGE, 4, {power=dam.weapon}, true)
		end
	end,
}

newDamageType{
	name = _t"wormblight", type = "WORMBLIGHT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:attr("worm") then
			target:heal(dam / 3, src)
			return -dam
		elseif target and not target.carrion_worm then  -- Carrion worms are immune but not healed by the damage, this spams the log so we just don't hit them instead
			DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam)
			return dam
		end
	end,
}

newDamageType{
	name = _t"pestilent blight", type = "PESTILENT_BLIGHT",
	text_color = "#GREEN#",
	tdesc = function(dam, oldDam)
		local parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# chance to cause #GREEN#random blight#LAST#%s")
			:tformat(dam, parens)
	end,
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if rng.percent(dam) then
			local check = src:combatSpellpower()
			if not src:checkHit(check, target:combatSpellResist()) then return end
			local effect = rng.range(1, 4)
			if effect == 1 then
				if target:canBe("blind") and not target:hasEffect(target.EFF_BLINDED) then
					target:setEffect(target.EFF_BLINDED, 2, {no_ct_effect=true} )
				end
			elseif effect == 2 then
				if target:canBe("silence") and not target:hasEffect(target.EFF_SILENCED) then
					target:setEffect(target.EFF_SILENCED, 2, {no_ct_effect=true})
				end
			elseif effect == 3 then
				if target:canBe("disarm") and not target:hasEffect(target.EFF_DISARMED) then
					target:setEffect(target.EFF_DISARMED, 2, {no_ct_effect=true})
				end
			elseif effect == 4 then
				if target:canBe("pin") and not target:hasEffect(target.EFF_PINNED) then
					target:setEffect(target.EFF_PINNED, 2, {no_ct_effect=true})
				end
			end
		end
		end
	end,
}

newDamageType{
	name = _t"blight poison", type = "BLIGHT_POISON", text_color = "#DARK_GREEN#",
	projector = function(src, x, y, t, dam, poison, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam.dam / 4)
		local target = game.level.map(x, y, Map.ACTOR)
		local chance = 0
		if dam.poison == 4 then
			chance = rng.range(1, 4)
		elseif dam.poison == 3 then
			chance = rng.range(1, 3)
		elseif dam.poison == 2 then
			chance = rng.range(1, 2)
		else chance = 1
		end
		if target and (target:canBe("poison") or rng.percent(dam.penetration or 0)) then
			local apply = dam.apply_power or (src.combatAttack and src:combatAttack()) or 0
			if chance == 1 then
				target:setEffect(target.EFF_BLIGHT_POISON, 4, {src=src, power=dam.dam / 4, apply_power=apply})
			elseif chance == 2 then
				target:setEffect(target.EFF_INSIDIOUS_BLIGHT, 4, {src=src, power=dam.dam / 4, heal_factor=dam.heal_factor or 150*dam.power/(dam.power + 100), apply_power=apply})
			elseif chance == 3 then
				target:setEffect(target.EFF_NUMBING_BLIGHT, 4, {src=src, power=dam.dam / 4, reduce=dam.power, apply_power=apply})
			elseif chance == 4 then
				target:setEffect(target.EFF_CRIPPLING_BLIGHT, 4, {src=src, power=dam.dam / 4, fail=dam.fail or 50*dam.power/(dam.power+100), apply_power=apply})
			end
		end
		return realdam
	end,
}

newDamageType{
	name = _t"terror", type = "TERROR",
	text_color = "#YELLOW#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:canSee(src) then
			game:delayedLogDamage(src, target, 0, ("%s<terror chance>#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#"), false)
			if not src:checkHit(src:combatAttack(), target:combatMentalResist()) then return end
			local effect = rng.range(1, 3)
			if effect == 1 then
				-- confusion
				if target:canBe("confusion") and not target:hasEffect(target.EFF_CONFUSED) then
					target:setEffect(target.EFF_CONFUSED, dam.dur, {power=dam.power or 30})
					game.level.map:particleEmitter(target.x, target.y, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_04", radius=0})
				end
			elseif effect == 2 then
				-- stun
				if target:canBe("stun") and not target:hasEffect(target.EFF_STUNNED) then
					target:setEffect(target.EFF_STUNNED, dam.dur, {})
					game.level.map:particleEmitter(target.x, target.y, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_04", radius=0})
				end
			elseif effect == 3 then
				-- slow
				if target:canBe("slow") and not target:hasEffect(target.EFF_SLOW) then
					target:setEffect(target.EFF_SLOW, dam.dur, {power=0.4})
					game.level.map:particleEmitter(target.x, target.y, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_04", radius=0})
				end
			end
		end
	end,
}

-- Random poison: 25% to be enhanced
newDamageType{
	name = _t"random poison", type = "RANDOM_POISON", text_color = "#LIGHT_GREEN#",
	projector = function(src, x, y, t, dam, poison, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local power
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 and target:canBe("poison") then
			local realdam = DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam / 6, state)
			if rng.percent(dam.random_chance or 25) then
				local chance = rng.range(1, 3)
				if chance == 1 then
					target:setEffect(target.EFF_INSIDIOUS_POISON, 5, {src=src, power=dam.dam / 6, heal_factor=150*dam.power/(dam.power+50), apply_power=dam.apply_power or (src.combatAttack and src:combatAttack()) or 0})
				elseif chance == 2 then
					target:setEffect(target.EFF_NUMBING_POISON, 5, {src=src, power=dam.dam / 6, reduce=2*dam.power^0.75, apply_power=dam.apply_power or (src.combatAttack and src:combatAttack()) or 0})
				elseif chance == 3 then
					target:setEffect(target.EFF_CRIPPLING_POISON, 5, {src=src, power=dam.dam / 6, fail=50*dam.power/(dam.power+50), apply_power=dam.apply_power or (src.combatAttack and src:combatAttack()) or 0})
				end
			else
				target:setEffect(target.EFF_POISONED, 5, {src=src, power=dam.dam / 6, apply_power=dam.apply_power or (src.combatAttack and src:combatAttack()) or 0})
			end
			return realdam
		end
	end,
}

newDamageType{
	name = _t"blinding powder", type = "BLINDING_POWDER",
	text_color = "#GREY#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			game:delayedLogDamage(src, target, 0, ("%s<blinding powder>#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#"), false)
			if not src:checkHit(src:combatAttack(), target:combatPhysicalResist()) then return end

			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, dam.dur, {})
			end

			target:setEffect(target.EFF_DISABLE, dam.dur, {speed=dam.slow, atk=dam.acc})

		end
	end,
}

newDamageType{
	name = _t"smokescreen", type = "SMOKESCREEN",
	text_color = "#GREY#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0 then
			game:delayedLogDamage(src, target, 0, ("%s<smoke>#LAST#"):tformat(DamageType:get(type).text_color or "#aaaaaa#"), false)
			if target:canBe("blind") then
				target:setEffect(target.EFF_DIM_VISION, 2, {sight=dam.dam, apply_power=src:combatAttack(), no_ct_effect=true})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end

			if dam.poison and dam.poison > 0 then
				DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.poison)
				if target:canBe("silence") and rng.percent(50) then
					target:setEffect(target.EFF_SILENCED, 2, {apply_power=src:combatAttack(), no_ct_effect=true})
				end
			end
		end
	end,
}

newDamageType{
	name = _t"flare", type = "FLARE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local g = game.level.map(x, y, Map.TERRAIN+1)
		if g and g.unlit then
			if g.unlit <= 1 then game.level.map:remove(x, y, Map.TERRAIN+1)
			else g.unlit = g.unlit - 1 return end -- Lite wears down darkness
		end
		game.level.map.lites(x, y, true)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, math.ceil(dam), {apply_power=src:combatAttack()})
			else
				game.logSeen(target, "%s resists the blinding flare!", target:getName():capitalize())
			end
			target:setEffect(target.EFF_MARKED, 2, {src=src})
		end
	end,
}

newDamageType{
	name = _t"flare light", type = "FLARE_LIGHT",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local g = game.level.map(x, y, Map.TERRAIN+1)
		if g and g.unlit then
			if g.unlit <= 1 then game.level.map:remove(x, y, Map.TERRAIN+1)
			else g.unlit = g.unlit - 1 return end -- Lite wears down darkness
		end
		game.level.map.lites(x, y, true)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_FLARE, 2, {src=src, power=dam})
		end
	end,
}

newDamageType{
	name = _t"sticky pitch", type = "PITCH",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("slow") then
				target:setEffect(target.EFF_STICKY_PITCH, dam.dur, {slow=dam.dam/100, resist=dam.fire, apply_power=src:combatAttack()})
			else
				game.logSeen(target, "%s resists!", target:getName():capitalize())
			end
		end
	end,
}


newDamageType{
	name = _t"fire sunder", type = "FIRE_SUNDER",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam, power=10} end
		DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam.dam, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SUNDER_ARMOUR, dam.dur, {src=dam.self, power=dam.power})
		end
	end,
}

-- Dim vision+confuse
newDamageType{
	name = _t"shadow smoke", type = "SHADOW_SMOKE",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SHADOW_SMOKE, 5, {sight=dam, apply_power=src:combatAttack()})
		end
	end,
}

newDamageType{
	name = _t"frozen earth", type = "ITEM_FROST_TREADS",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and src:reactionToward(target) < 0  then
			target:setEffect(target.EFF_SLIPPERY_GROUND, 2, { fail=20}, true)
		end
		if target and target == src then
			target:setEffect(target.EFF_FROZEN_GROUND, 2, { }, true)
		end
	end,
}

newDamageType{
	name = _t"void echoes", type = "VOID_ECHOES",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("fear") then
				target:setEffect(target.EFF_VOID_ECHOES, 6, {src=src, power=dam, apply_power=src:combatMindpower()})
				target:crossTierEffect(target.EFF_VOID_ECHOES, src:combatMindpower())
			else
				game.logSeen(target, "%s resists the void!", target:getName():capitalize())
			end
		end
	end,
}

---new lite light burst for summertide phial
newDamageType{
	name = _t"#YELLOW#Lite Light#LAST# Burst (radius 1)", type = "LITE_LIGHT_BURST", --text_color = "#YELLOW#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		src:project({type="ball", selffire=true, x=x, y=y, radius=1, range=0}, x, y, function(bx, by) -- selffire to lite our tile, reaction check will prevent damage
			DamageType:get(DamageType.LITE).projector(src, bx, by, DamageType.LITE, 1, state) -- lite the tiles
			local actor = game.level.map(bx, by, Map.ACTOR)
			if actor and src:reactionToward(actor) < 0 then -- only deal damage to hostiles
				DamageType:get(DamageType.LIGHT).projector(src, bx, by, DamageType.LIGHT, dam, state)
			end
		end)
	end,
}

-- Light + Darkness
newDamageType{
	name = _t"dark light", type = "DARKLIGHT", text_color = "#9D9DC9#",
	damdesc_split = { {DamageType.DARKNESS, 0.5}, {DamageType.LIGHT, 0.5} },
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam1 = DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam / 2, state)
		local realdam2 = DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam / 2, state)
		return (realdam1 or 0) + (realdam2 or 0)
	end,
}

-- Fire + Physical
newDamageType{
	name = _t"meteor", type = "METEOR", text_color = "#CRIMSON#",
	damdesc_split = { {DamageType.PHYSICAL, 0.5}, {DamageType.FIRE, 0.5} },
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		state.is_meteor = true
		local realdam1 = DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam / 2, state)
		local realdam2 = DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.FIRE, dam / 2, state)
		return (realdam1 or 0) + (realdam2 or 0)
	end,
}

newDamageType{
	name = _t"fetid", type = "FETID", text_color = "#DARK_GREEN#",
	damdesc_split = { {DamageType.BLIGHT, 0.5}, {DamageType.DARKNESS, 0.5} },
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam1 = DamageType:get(DamageType.BLIGHT).projector(src, x, y, DamageType.BLIGHT, dam / 2, state)
		local realdam2 = DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam / 2, state)
		return (realdam1 or 0) + (realdam2 or 0)
	end,
}

-- Cold/Darkness damage
newDamageType{
	name = _t"frostdusk", type = "FROSTDUSK", text_color = "#DARK_BLUE#",
	damdesc_split = { {DamageType.COLD, 0.5}, {DamageType.DARKNESS, 0.5} },
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam1 = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam / 2, state)
		local realdam2 = DamageType:get(DamageType.DARKNESS).projector(src, x, y, DamageType.DARKNESS, dam / 2, state)
		return (realdam1 or 0) + (realdam2 or 0)
	end,
}

newDamageType{
	name = _t"chill of the tomb", type = "CHILL_OF_THE_TOMB", text_color = "#DARK_BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		local realdam = 0
		if src:reactionToward(target) < 0 then
			realdam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam.dam, state)
		elseif target.summoner == src and target.necrotic_minion then
			target:setEffect(target.EFF_CHILL_OF_THE_TOMB, 4, {power=dam.resist})
		end
		return realdam
	end,
}

newDamageType{
	name = _t"putrescent liquefaction", type = "PUTRESCENT_LIQUEFACTION", text_color = "#OLIVE_DRAB#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local realdam = DamageType:get(DamageType.FROSTDUSK).projector(src, x, y, DamageType.FROSTDUSK, dam, state)
		return realdam or 0
	end,
}

newDamageType{
	name = _t"boneyard", type = "BONEYARD", text_color = "#GREY#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end

		if src:reactionToward(target) < 0 then
			target:setEffect(target.EFF_BRITTLE_BONES, 1, {apply_power=src:combatSpellpower(), resist=dam.resist, cooldown=dam.cooldown})
		elseif target.summoner == src and target.necrotic_minion then
			target:setEffect(target.EFF_BONEYARD, 1, {power=dam.power})
		end
	end,
}

newDamageType{
	name = _t"desolate waste", type = "DESOLATE_WASTE", text_color = "#BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target and (target.old_x ~= x or target.old_y ~= y) and src:knowTalent(src.T_CRUMBLING_EARTH) and src:reactionToward(target) < 0 then
			src:callTalent(src.T_CRUMBLING_EARTH, "trigger", target)
		end
		return DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
	end,
}

newDamageType{
	name = _t"desolate waste", type = "HIEMAL_SHIELD", text_color = "#BLUE#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		local dam = DamageType:get(DamageType.COLD).projector(src, x, y, DamageType.COLD, dam, state)
		if dam > 0 and target then
			local waste = game.level.map:hasEffectType(x, y, DamageType.DESOLATE_WASTE)
			if waste then
				src:callTalent(src.T_DESOLATE_WASTE, "trigger")
			end			
		end
	end,
}

-- Unresistible damage, always uses highest resistance penetration, highest damage increase and can never be altered into something else
-- NEVER add items that resist that! Use sparingly!
newDamageType{
	name = _t"thaumic energy", type = "THAUM", text_color = "#C259D0#",
	death_message = {_t"utterly vaporized", _t"annihilated", _t"disintegrated"},
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if src.combatGetResistPen then
			if not src.auto_highest_resists_pen then src.auto_highest_resists_pen = {} end
			if not src.auto_highest_resists_pen[DamageType.THAUM] then src.auto_highest_resists_pen[DamageType.THAUM] = 1 end
		end
		if src.combatGetDamageIncrease then
			if not src.auto_highest_inc_damage then src.auto_highest_inc_damage = {} end
			if not src.auto_highest_inc_damage[DamageType.THAUM] then src.auto_highest_inc_damage[DamageType.THAUM] = 1 end
		end

		local target = game.level.map(x, y, Map.ACTOR)
		if target and target:hasEffect(target.EFF_WET) and src.hasEffect and src:hasEffect(src.EFF_SHIVGOROTH_FORM) then dam = dam * 1.3 end

		if src.turn_procs then src.turn_procs.damage_type_fix_type = true end
		local realdam = DamageType.defaultProjector(src, x, y, type, dam, state)
		if src.turn_procs then src.turn_procs.damage_type_fix_type = nil end
		return realdam
	end,
}


-- physical that pulls and might reduce knockback resistance
newDamageType{
	name = _t"black-hole gravity", type = "BLACK_HOLE_GRAVITY",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		if _G.type(dam) == "number" then dam = {dam=dam} end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		if target then
			if target:isTalentActive(target.T_GRAVITY_LOCUS) then return end
			if dam.slow then
				target:setEffect(target.EFF_SLOW, dam.dur, {power=dam.slow, apply_power=src:combatPhysicalpower(), no_ct_effect=true})
			end
			if src:isTalentActive(src.T_SINGULARITY_ARMOR) then
				target:setEffect(target.EFF_ANTI_GRAVITY, 2, {})
			end
		end
		
		if target:checkHit(src:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 5) and target:canBe("knockback") then
			local source = src.__project_source or src
			target:pull(source.x, source.y, 2)
			game.logSeen(target, "%s is pulled in!", target.name:capitalize())
		else
			game.logSeen(target, "%s resists the gravity!", target.name:capitalize())
		end
		
		DamageType:get(DamageType.PHYSICAL).projector(src, x, y, DamageType.PHYSICAL, dam.dam, state)
	end,
}

-- blinding light that restores positive energy to its caster
newDamageType{
	name = _t"solar blood", type = "SOLAR_BLOOD",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target == src then
				target:incPositive(2)
			elseif target:reactionToward(src) < 0 then
				if target:canBe("blind") then
					target:setEffect(target.EFF_BLINDING_LIGHT, 1, {src=src, power=dam.dam, apply_power=dam.pow, no_ct_effect=true})
				end
				DamageType:get(DamageType.LIGHT).projector(src, x, y, DamageType.LIGHT, dam.dam, state)
			end
		end
	end,
}

