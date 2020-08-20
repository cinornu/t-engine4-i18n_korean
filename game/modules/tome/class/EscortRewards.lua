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

require "engine.class"
local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")

module(..., package.seeall, class.make)

function _M:listGivers()
	local possible_types = {
		warrior = {
			chance = 70,
			classes = {"Berserker", "Bulwark"},
			escort = { name="lost warrior", random="male",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					type = "humanoid", subtype = "human", image = "player/higher_male.png",
					display = "@", color=colors.UMBER,
					name = _t"%s, the lost warrior",
					desc = _t[[He looks tired and wounded.]],
					autolevel = "warrior",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=18, dex=13, mag=5, con=15 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="greatsword", autoreq=true} },
					resolvers.talents{ [Talents.T_STUNNING_BLOW]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,
					antimagic_ok = true,

					max_life = 50, life_regen = 0,
					life_rating = 12,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		divination = {
			chance = 70,
			classes = {"Archmage"},
			escort = { name="injured seer", random="female",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I will not be able to continue the road alone. Would you help me?]],
				actor = {
					name = _t"%s, the injured seer",
					type = "humanoid", subtype = "elf", female=true, image = "player/halfling_female.png",
					display = "@", color=colors.LIGHT_BLUE,
					desc = _t[[She looks tired and wounded.]],
					autolevel = "caster",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
					resolvers.talents{ [Talents.T_MANATHRUST]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,

					max_life = 50, life_regen = 0,
					life_rating = 11,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		survival = {
			chance = 70,
			classes = {"Rogue", "Shadowblade", "Marauder"},
			escort = { name="repented thief", random="male",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					name = _t"%s, the repented thief",
					type = "humanoid", subtype = "halfling", image = "player/cornac_male.png",
					display = "@", color=colors.BLUE,
					desc = _t[[He looks tired and wounded.]],
					autolevel = "rogue",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="dagger", autoreq=true}, {type="weapon", subtype="dagger", autoreq=true} },
					resolvers.talents{ [Talents.T_DIRTY_FIGHTING]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,
					antimagic_ok = true,

					max_life = 50, life_regen = 0,
					life_rating = 11,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		alchemy = {
			chance = 70,
			classes = {"Alchemist"},
			escort = { name="lone alchemist", random="male",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					name = _t"%s, the lone alchemist",
					type = "humanoid", subtype = "human", image = "player/shalore_male.png",
					display = "@", color=colors.AQUAMARINE,
					desc = _t[[He looks tired and wounded.]],
					autolevel = "rogue",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
					resolvers.talents{ [Talents.T_HEAT]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,

					max_life = 50, life_regen = 0,
					life_rating = 11,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		sun_paladin = {
			chance = 70,
			classes = {"Sun Paladin"},
			escort = { name="lost sun paladin", random="female",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					name = _t"%s, the lost sun paladin",
					type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
					display = "@", color=colors.GOLD,
					desc = _t[[She looks tired and wounded.]],
					autolevel = "warriormage",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=18, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="mace", autoreq=true} },
					resolvers.talents{ [Talents.T_CHANT_OF_FORTRESS]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,

					max_life = 50, life_regen = 0,
					life_rating = 12,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
					sunwall_query = true,
				},
			},
		},
		defiler = {
			chance = 70,
			classes = {"Corruptor", "Reaver"},
			escort = { name="lost defiler", random="female",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					name = _t"%s, the lost defiler",
					type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
					display = "@", color=colors.YELLOW,
					desc = _t[[She looks tired and wounded.]],
					autolevel = "caster",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
					resolvers.talents{ [Talents.T_CURSE_OF_IMPOTENCE]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,

					max_life = 50, life_regen = 0,
					life_rating = 11,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		temporal = {
			chance = 30,
			classes = {"Paradox Mage", "Temporal Warden"},
			escort = { name="temporal explorer", random="player", portal=_t"temporal portal",
				text = _t[[Oh but you are ... are you ?! ME?!
		So I was right, this is not my original time-thread!
		Please help me! I am afraid I lost myself in this place. I know there is a temporal portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me? Would you help .. yourself?]],
				actor = {
					name = _t"%s, temporal explorer",
					type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
					display = "@", color=colors.YELLOW,
					desc = _t[[She looks tired and wounded. She is so similar to you and yet completely different. Weird.]],
					autolevel = "caster",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
					resolvers.talents{ [Talents.T_DUST_TO_DUST]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,

					max_life = 50, life_regen = 0,
					life_rating = 11,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
		exotic = {
			chance = 30,
			classes = "any",
			escort = { name="worried loremaster", random="female",
				text = _t[[Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I have fought too many battles, and I fear I will not make it. Would you help me?]],
				actor = {
					name = _t"%s, the worried loremaster",
					type = "humanoid", subtype = "human", female=true, image = "player/thalore_female.png",
					display = "@", color=colors.LIGHT_GREEN,
					desc = _t[[She looks tired and wounded.]],
					autolevel = "wildcaster",
					ai = "escort_quest", ai_state = { talent_in=4, },
					stats = { str=8, dex=7, mag=18, con=12 },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
					resolvers.talents{ [Talents.T_MIND_SEAR]=1, },
					lite = 4,
					rank = 2,
					exp_worth = 1,
					antimagic_ok = true,

					max_life = 50, life_regen = 0,
					life_rating = 10,
					combat_armor = 3, combat_def = 3,
					inc_damage = {all=-50},
				},
			},
		},
	}
	local hd = {"EscortRewards:givers", possible_types=possible_types}
	if self:triggerHook(hd) then possible_types = hd.possible_types end
	return possible_types
end

function _M:getGiver()
	local possible_types = self:listGivers()

	game.state.escorts_seen = game.state.escorts_seen or {}
	local escorts_seen = game.state.escorts_seen
	local kind_id, kind
	while true do
		kind_id = rng.tableIndex(possible_types)
		kind = possible_types[kind_id]
		if not kind.unique or not escorts_seen[kind_id] then
			if rng.percent(kind.chance) then break end
		end
	end
	escorts_seen[kind_id] = (escorts_seen[kind_id] or 0) + 1

	return kind_id, kind
end

function _M:listRewards()
	local reward_types = {
		warrior = {
			types = {
				["technique/conditioning"] = 1.0,
			},
			talents = {
				[Talents.T_VITALITY] = 1,
				[Talents.T_UNFLINCHING_RESOLVE] = 1,
				[Talents.T_EXOTIC_WEAPONS_MASTERY] = 1,
			},
			stats = {
				[Stats.STAT_STR] = 5,
				[Stats.STAT_CON] = 5,
			},
		},
		divination = {
			types = {
				["spell/divination"] = 1.0,
			},
			talents = {
				[Talents.T_ARCANE_EYE] = 1,
				[Talents.T_PREMONITION] = 1,
				[Talents.T_VISION] = 1,
			},
			stats = {
				[Stats.STAT_MAG] = 5,
				[Stats.STAT_WIL] = 5,
			},
			antimagic = {
				types = {
					["wild-gift/call"] = 1.0,
				},
				saves = { mental = 12 },
				talents = {
					[Talents.T_NATURE_TOUCH] = 1,
					[Talents.T_EARTH_S_EYES] = 1,
				},
				stats = {
					[Stats.STAT_CUN] = 5,
					[Stats.STAT_WIL] = 5,
				},
			},
		},
		alchemy = {
			types = {
				["spell/staff-combat"] = 1.0,
				["spell/stone-alchemy"] = 1.0,
			},
			talents = {
				[Talents.T_CHANNEL_STAFF] = 1,
				[Talents.T_STAFF_MASTERY] = 1,
				[Talents.T_STONE_TOUCH] = 1,
			},
			stats = {
				[Stats.STAT_MAG] = 5,
				[Stats.STAT_DEX] = 5,
			},
			antimagic = {
				types = {
					["wild-gift/mindstar-mastery"] = 1.0,
				},
				talents = {
					[Talents.T_PSIBLADES] = 1,
					[Talents.T_THORN_GRAB] = 1,
				},
				saves = { spell = 12 },
				stats = {
					[Stats.STAT_WIL] = 5,
					[Stats.STAT_DEX] = 5,
				},
			},
		},
		survival = {
			types = {
				["cunning/survival"] = 1.0,
				["cunning/scoundrel"] = 1.0,
			},
			talents = {
				[Talents.T_HEIGHTENED_SENSES] = 1,
				[Talents.T_TRACK] = 1,
				[Talents.T_LACERATING_STRIKES] = 1,
				[Talents.T_MISDIRECTION] = 1,
			},
			stats = {
				[Stats.STAT_DEX] = 5,
				[Stats.STAT_CUN] = 5,
			},
		},
		sun_paladin = {
			types = {
				["celestial/chants"] = 1.0,
			},
			talents = {
				[Talents.T_CHANT_OF_FORTITUDE] = 1,
				[Talents.T_CHANT_OF_FORTRESS] = 1,
			},
			stats = {
				[Stats.STAT_STR] = 5,
				[Stats.STAT_MAG] = 5,
			},
			antimagic = {
				types = {
					["psionic/augmented-mobility"] = 1.0,
				},
				talents = {
					[Talents.T_SKATE] = 1,
					[Talents.T_TELEKINETIC_LEAP] = 1,
				},
				saves = { spell = 12, phys = 12 },
				stats = {
					[Stats.STAT_CUN] = 5,
					[Stats.STAT_WIL] = 5,
				},
			},
		},
		defiler = {
			types = {
				["corruption/curses"] = 1.0,
			},
			talents = {
				[Talents.T_CURSE_OF_DEFENSELESSNESS] = 1,
				[Talents.T_CURSE_OF_IMPOTENCE] = 1,
				[Talents.T_CURSE_OF_DEATH] = 1,
			},
			stats = {
				[Stats.STAT_CUN] = 5,
				[Stats.STAT_MAG] = 5,
			},
			antimagic = {
				types = {
					["psionic/feedback"] = 1.0,
				},
				talents = {
					[Talents.T_RESONANCE_FIELD] = 1,
					[Talents.T_CONVERSION] = 1,
				},
				saves = { spell = 12, mental = 12 },
				stats = {
					[Stats.STAT_CUN] = 5,
					[Stats.STAT_WIL] = 5,
				},
			},
		},
		temporal = {
			types = {
				["chronomancy/chronomancy"] = 1.0,
			},
			talents = {
				[Talents.T_PRECOGNITION] = 1,
				[Talents.T_FORESIGHT] = 1,
			},										
			stats = {
				[Stats.STAT_MAG] = 5,
				[Stats.STAT_WIL] = 5,
			},
			antimagic = {
				types = {
					["psionic/dreaming"] = 1.0,
				},
				talents = {
					[Talents.T_SLEEP] = 1,
					[Talents.T_DREAM_WALK] = 1,
				},
				saves = { spell = 12 },
				stats = {
					[Stats.STAT_WIL] = 5,
					[Stats.STAT_CUN] = 5,
				},
			},
		},
		exotic = {
			talents = {
				[Talents.T_DISARM] = 1,
				[Talents.T_SPIT_POISON] = 1,
				[Talents.T_MIND_SEAR] = 1,
			},
			stats = {
				[Stats.STAT_STR] = 5,
				[Stats.STAT_DEX] = 5,
				[Stats.STAT_MAG] = 5,
				[Stats.STAT_WIL] = 5,
				[Stats.STAT_CUN] = 5,
				[Stats.STAT_CON] = 5,
			},
		},
	}

	local hd = {"EscortRewards:rewards", reward_types=reward_types}
	if self:triggerHook(hd) then reward_types = hd.reward_types end

	return reward_types
end

function _M:getReward(reward_type)
	local rts = self:listRewards()
	if rts[reward_type] then
		return rts[reward_type]
	else
		game.log('[EscortRewards] ERROR: reward_type "'..tostring(reward_type)..'" not defined, using warrior')
		return rts.warrior
	end
end

local saves_name = { mental=_t"mental", spell=_t"spell", phys=_t"physical"}
local saves_tooltips = { mental="MENTAL", spell="SPELL", phys="PHYS"}

function _M:rewardChatAnwsers(who, reward, jump_to, on_chose)
	local answers = {}
	if reward.stats then
		for i = 1, #who.stats_def do if reward.stats[i] then
			local doit = function(npc, player) game.party:reward(_t"Select the party member to receive the reward:", function(player)
				player.inc_stats[i] = (player.inc_stats[i] or 0) + reward.stats[i]
				player:onStatChange(i, reward.stats[i])
				player.changed = true
				on_chose(npc, player, "stat", i, reward.stats[i], ("improved %s by +%d"):tformat(npc.stats_def[i].name, reward.stats[i]))
			end) end
			answers[#answers+1] = {("[Improve %s by +%d]"):tformat(who.stats_def[i].name, reward.stats[i]),
				jump=jump_to or "done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					local TooltipsData = require("mod.class.interface.TooltipsData")
					game:tooltipDisplayAtMap(game.w, game.h, TooltipsData["TOOLTIP_"..npc.stats_def[i].short_name:upper()])
				end,
			}
		end end
	end
	if reward.saves then
		for save, v in pairs(reward.saves) do
			local doit = function(npc, player) game.party:reward(_t"Select the party member to receive the reward:", function(player)
				player:attr("combat_"..save.."resist", v)
				player.changed = true
				on_chose(npc, player, "save", save, v, ("improved %s save by +%d"):tformat(saves_name[save], v))
			end) end
			answers[#answers+1] = {("[Improve %s save by +%d]"):tformat(saves_name[save], v),
				jump=jump_to or "done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					local TooltipsData = require("mod.class.interface.TooltipsData")
					game:tooltipDisplayAtMap(game.w, game.h, TooltipsData["TOOLTIP_"..saves_tooltips[save]:upper().."_SAVE"])
				end,
			}
		end
	end
	if reward.talents then
		for tid, level in pairs(reward.talents) do
			local t = who:getTalentFromId(tid)
			level = math.min(t.points - who:getTalentLevelRaw(tid), level)
			if level > 0 then
				local doit = function(npc, player) game.party:reward(_t"Select the party member to receive the reward:", function(player)
					if player:knowTalentType(t.type[1]) == nil then player:setTalentTypeMastery(t.type[1], 1.0) end
					player:learnTalent(tid, true, level, {no_unlearn=true})
					if t.hide then player.__show_special_talents = player.__show_special_talents or {} player.__show_special_talents[tid] = true end
					on_chose(npc, player, "talent", tid, level, ("%s talent %s (+%d level(s))"):tformat(player:knowTalent(tid) and _t"improved" or _t"learnt", t.name, level))
				end) end
				answers[#answers+1] = {
					("[%s talent %s (+%d level(s))]"):tformat(who:knowTalent(tid) and _t"Improve" or _t"Learn", t.name, level),
						jump=jump_to or "done",
						action=doit,
						on_select=function(npc, player)
							game.tooltip_x, game.tooltip_y = 1, 1
							local mastery = nil
							if player:knowTalentType(t.type[1]) == nil then mastery = 1.0 end
							game:tooltipDisplayAtMap(game.w, game.h, ("#GOLD#%s#LAST#\n%s"):tformat(t.name,tostring(player:getTalentFullDescription(t, 1, nil, mastery))))
						end,
					}
			end
		end
	end
	if reward.types then
		for tt, mastery in pairs(reward.types) do if who:knowTalentType(tt) == nil then
			local tt_def = who:getTalentTypeFrom(tt)
			local cat = tt_def.type:gsub("/.*", "")
			local doit = function(npc, player) game.party:reward(_t"Select the party member to receive the reward:", function(player)
				if player:knowTalentType(tt) == nil then player:setTalentTypeMastery(tt, mastery - 1 + player:getTalentTypeMastery(tt)) end
				player:learnTalentType(tt, false)
				on_chose(npc, player, "talent_type", tt, mastery, ("gained talent category %s (at mastery %0.2f)"):tformat(_t(cat):capitalize().." / "..tt_def.name:capitalize(), mastery))
			end) end
			answers[#answers+1] = {("[Allow training of talent category %s (at mastery %0.2f)]"):tformat(_t(cat):capitalize().." / "..tt_def.name:capitalize(), mastery),
				jump=jump_to or "done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, ("#GOLD#%s / %s#LAST#\n%s"):tformat(_t(cat):capitalize(), tt_def.name:capitalize(), tt_def.description))
				end,
			}
		end end
	end
	if reward.special then
		for _, data in ipairs(reward.special) do
			answers[#answers+1] = {data.desc,
				jump=jump_to or "done",
				action=function(npc, player)
					return data.action(npc, player, on_chose)
				end,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, data.tooltip)
				end,
			}
		end
	end
	return answers
end
