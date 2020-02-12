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

load("/data/general/npcs/skeleton.lua", rarity(0))
load("/data/general/npcs/ghoul.lua", rarity(2))
load("/data/general/npcs/bone-giant.lua", rarity(8))

local Talents = require("engine.interface.ActorTalents")

newEntity{ define_as="SUBJECT_Z",
	name = "Subject Z", color=colors.VIOLET, display = "p", unique = true,
	desc = _t"This seems to be the 'subject Z' the notes spoke about. He looks human, but this cannot be -- he would be about five thousand years old!",
	type = "humanoid", subtype = "human",
	killer_message = _t"and bloodily smeared across the granite walls",
	level_range = {10, nil}, exp_worth = 2,
	rank = 4,
	autolevel = "roguemage",
	max_life = 100, life_rating = 12,
	combat_armor = 0, combat_def = 15,
	open_door = 1,
	never_act = true,

	ai = "tactical", ai_state = { talent_in=1, ai_move="move_astar", },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1, FINGER=1 },

	see_invisible = 20,

	resolvers.equip{
		{type="weapon", subtype="dagger", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{type="weapon", subtype="dagger", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{type="armor", subtype="light", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{defined="NIGHT_SONG", random_art_replace={chance=65}, autoreq=true},
	},

	resolvers.talents{
		[Talents.T_DUAL_WEAPON_DEFENSE]={base=3, every=8, max=6},
		[Talents.T_DUAL_WEAPON_TRAINING]={base=3, every=8, max=6},
		[Talents.T_FLURRY]={base=2, every=8, max=6},
		[Talents.T_LETHALITY]={base=3, every=8, max=6},
		[Talents.T_WEAPON_COMBAT]={base=1, every=10, max=4},
		[Talents.T_KNIFE_MASTERY]={base=1, every=10, max=4},
		[Talents.T_SHADOW_COMBAT]={base=1, every=8, max=7},
		[Talents.T_SHADOWSTEP]={base=1, every=6, max=5},
		[Talents.T_PHASE_DOOR]=3,
		[Talents.T_SECOND_WIND]={base=4, every=8, max=6},
		[Talents.T_SHADOW_GRASP]={base=4, every=8, max=6},
	},
	resolvers.inscriptions(1, {"manasurge rune"}),
	resolvers.inscriptions(1, "infusion"),

	resolvers.auto_equip_filters("Shadowblade"),
	auto_classes={{class="Shadowblade", start_level=22, level_rate=35}},

	resolvers.sustains_at_birth(),

	seen_by = function(self, who)
		if not game.party:hasMember(who) then return end
		self.seen_by = nil
		self.never_act = nil

		local wayist = nil
		for uid, e in pairs(game.level.entities) do if e.define_as == "YEEK_WAYIST" then wayist = e break end end
		if not wayist then return end
		wayist.never_act = nil

		wayist:setTarget(self)
		self:setTarget(wayist)
		wayist:doEmote(_t"Sacrifice for the Way!", 60)

		-- Warning for our good yeek folks to GTFOH
		if game:getPlayer(true) and game:getPlayer(true).starting_zone == "town-irkkk" then
			require("engine.ui.Dialog"):yesnoLongPopup(_t"#LIGHT_RED#Intense fight", _t"As you approach you come upon an other Wayist and receive a very clear mental message:\n#{italic}##UMBER#RUN AWAY! I am done for but you can save yourself still!#{normal}#", 600, function(ret) if ret then
				who:setEffect(who.EFF_RECALL, 5, {})
				game.bignews:say(120, "#GOLD#You hastily activate your Rod of Recall, vowing to come back later!")
				game.logPlayer(who, "Space around you starts to dissolve...")
			end end, _t"Emergency recall", _t"Stay and fight!")
		end
	end,

	on_die = function(self, who)
		local wayist = nil
		for uid, e in pairs(game.level.entities) do if e.define_as == "YEEK_WAYIST" then wayist = e break end end
		if not wayist then return end

		local p = game.party:findMember{main=true}
		-- Yeeks really, really, really, hate halflings
		if p.descriptor.race == "Halfling" then
			wayist:doEmote(_t"Halfling?! DIE!!!!!", 70)
			wayist:checkAngered(p, false, -200)
		elseif p.descriptor.race == "Yeek" then
			wayist:doEmote(_t"The Way sent you?", 70)
			wayist.can_talk = "yeek-wayist"
		else
			wayist:doEmote(_t"You.. saved me?", 70)
			wayist.can_talk = "yeek-wayist"
		end
	end,
}

newEntity{ define_as="YEEK_WAYIST",
	name = "Yeek Wayist", color=colors.VIOLET, display = "y", unique = true,
	desc = _t"This creature is about as tall as a halfling. It is covered in white silky fur and has a disproportionate head. The weirdest thing about it though, its weapon simply floats in front of it.",
	type = "humanoid", subtype = "yeek",
	level_range = {10, nil},
	rank = 3,
	autolevel = "wildcaster",
	max_life = 300, life_rating = 14,
	faction = "the-way",
	combat_armor = 0, combat_def = 0,
	psi_regen = 5,
	open_door = 1,
	never_act = true,

	ai = "tactical", ai_state = { talent_in=1, ai_move="move_astar", },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, PSIONIC_FOCUS=1 },

	resolvers.equip{
		{type="weapon", subtype="greatsword", autoreq=true},
	},

	resolvers.talents{
		[Talents.T_KINETIC_SHIELD]=3,
		[Talents.T_MINDHOOK]=1,
		[Talents.T_PYROKINESIS]=3,
		[Talents.T_MINDLASH]=2,
		[Talents.T_CHARGED_AURA]=2,
		[Talents.T_TELEKINETIC_SMASH]=2,
	},
	resolvers.inscriptions(1, "infusion"),

	resolvers.sustains_at_birth(),
}
