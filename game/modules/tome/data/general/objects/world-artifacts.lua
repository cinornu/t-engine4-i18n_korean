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
local Talents = require "engine.interface.ActorTalents"

--- Load additional artifacts
for def, e in pairs(game.state:getWorldArtifacts()) do
	importEntity(e)
	print("Importing "..e.name.." into world artifacts")
end

-- This file describes artifacts not bound to a special location, they can be found anywhere

newEntity{ base = "BASE_GEM",
	power_source = {arcane=true},
	unique = true,
	unided_name = _t"windy gem",
	name = "Windborne Azurite", subtype = "blue",
	color = colors.BLUE, image = "object/artifact/windborn_azurite.png",
	level_range = {18, 40},
	desc = _t[[Air currents swirl around this bright blue jewel.]],
	rarity = 240,
	cost = 200,
	identified = false,
	material_level = 4,
	color_attributes = {
		damage_type = 'LIGHTNING',
		alt_damage_type = 'LIGHTNING_DAZE',
		particle = 'lightning_explosion',
	},
	wielder = {
		inc_stats = {[Stats.STAT_DEX] = 8, [Stats.STAT_CUN] = 8 },
		inc_damage = {[DamageType.LIGHTNING] = 20 },
		cancel_damage_chance = 8, -- add to tooltip
		damage_affinity={
			[DamageType.LIGHTNING] = 20,
		},
		movement_speed = 0.2,
	},
	imbue_powers = {
		inc_stats = {[Stats.STAT_DEX] = 8, [Stats.STAT_CUN] = 8 },
		inc_damage = {[DamageType.LIGHTNING] = 20 },
		cancel_damage_chance = 8,
		damage_affinity={
			[DamageType.LIGHTNING] = 20,
		},
		movement_speed = 0.15,
	},
}

newEntity{ base = "BASE_INFUSION",
	name = "Primal Infusion", unique=true, image = "object/artifact/primal_infusion.png",
	desc = _t[[This wild infusion has evolved.]],
	unided_name = _t"pulsing infusion",
	level_range = {15, 50},
	rarity = 300,
	cost = 500,

	inscription_kind = "protect",
	inscription_data = {
		cooldown = 18,
		dur = 4,
		reduce = 2,
		power = 10,
		use_stat_mod = 0.01, -- +2 duration reduction and +10% affinity at 100 stat
		use_stat = "wil",
	},
	inscription_talent = "INFUSION:_PRIMAL",
}

newEntity{ base = "BASE_RUNE",
	name = "Prismatic Rune", unique=true, define_as="RUNE_PRISMATIC",
	image = "object/artifact/prismatic_rune.png",
	level_range = {5, 50},
	rarity = 300,
	cost = 500,
	inscription_kind = "protect",
	types = {"FIRE", "LIGHTNING", "COLD", "ACID", "MIND", "ARCANE", "BLIGHT", "NATURE", "TEMPORAL", "LIGHT", "DARKNESS"},
	inscription_data = {
		cooldown = 18,
		dur = 6,
		num_types = resolvers.rngrange(3, 5),
		wards = {},
		resolvers.genericlast(function(e)
			e.inscription_data.wards["PHYSICAL"] = resolvers.rngrange(2, 4) -- guarantee physical wards
			for _ = 1,e.inscription_data.num_types do
				local pick = rng.tableRemove(e.types)
				e.inscription_data.wards[pick] = resolvers.rngrange(3, 5)
			end
		end)
	},
	inscription_talent = "RUNE:_PRISMATIC",
}

newEntity{ base = "BASE_RUNE",
	name = "Mirror Image Rune", unique=true, define_as="RUNE_MIRROR_IMAGE",
	image = "object/artifact/mirror_image_rune.png",
	level_range = {5, 50},
	rarity = 300,
	cost = 500,
	inscription_kind = "protect",
	inscription_data = {
		cooldown = 24,
		dur = 6,
		inheritance = 1,
	},
	inscription_talent = "RUNE:_MIRROR_IMAGE",
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	unique = true,
	name = "Staff of Destruction",
	flavor_name = "magestaff",
	flavors = {magestaff=true},
	unided_name = _t"darkness infused staff", image = "object/artifact/staff_of_destruction.png",
	level_range = {20, 25},
	color=colors.VIOLET,
	rarity = 170,
	desc = _t[[This unique-looking staff is carved with runes of destruction.]],
	cost = resolvers.rngrange(225,350),
	material_level = 3,

	require = { stat = { mag=24 }, },
	combat = {
		dam = 20,
		apr = 4,
		dammod = {mag=1.0},
		damtype = DamageType.FIRE,
		element = DamageType.FIRE,
		is_greater = true,
		melee_element = true,
		sentient = "agressive",
	},
	wielder = {
		combat_spellpower = 10,
		combat_spellcrit = 15,
		inc_damage={
			[DamageType.FIRE] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.COLD] = 20,
			[DamageType.ARCANE] = 20,
		},
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1},
	},
	talent_on_spell = { {chance=10, talent=Talents.T_IMPENDING_DOOM, level=1}},
}

newEntity{ base = "BASE_RING",
	power_source = {nature=true},
	unique = true,
	name = "Vargh Redemption", color = colors.LIGHT_BLUE, image="object/artifact/ring_vargh_redemption.png",
	unided_name = _t"sea-blue ring",
	desc = _t[[This azure ring seems to be always moist to the touch.]],
	level_range = {10, 20},
	rarity = 150,
	cost = 500,
	material_level = 2,

	max_power = 60, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = self.use_power.damage(self, who)
			return ("summon a radius %d tidal wave that expands slowly over %d turns, dealing %0.2f cold and %0.2f physical damage (based on Willpower) each turn, knocking opponents back, and lowering their stun resistance"):
			tformat(self.use_power.radius(self, who), self.use_power.duration, who:damDesc(engine.DamageType.COLD, dam/2), who:damDesc(engine.DamageType.PHYSICAL, dam/2))
		end,
		power = 60,
		range = 0,
		radius = function(self, who) return 1 + 0.4 * self.use_power.duration end,
		duration = 7,
		damage = function(self, who) return who:combatStatScale("wil", 15, 40) end,
		tactical = {ESCAPE = 1.5, ATTACKAREA = {COLD = 1.5, PHYSICAL = 1.5}},
		requires_target = true,
		target = function(self, who) return {type="ball", range=0, radius=self.use_power.radius(self, who), selffire=false} end,
		use = function(self, who)
			local duration = self.use_power.duration
			local initial_radius = 1
			local dam = self.use_power.damage(self, who)
			-- Add a lasting map effect
			local wave = game.level.map:addEffect(who,
				who.x, who.y, duration,
				engine.DamageType.WAVE, {dam=dam, x=who.x, y=who.y, apply_wet=1},
				initial_radius,
				5, nil,
				engine.MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader="shader_images/water_effect1.png"},
				function(e, update_shape_only)
					if not update_shape_only then e.radius = e.radius + 0.4 end
					return true
				end,
				false
			)
			wave.name = _t"tidal wave"
			game.logSeen(who, "%s brandishes %s, calling forth the might of the oceans!", who:getName():capitalize(), self:getName({no_add_name = true, do_color = true}))
			return {id=true, used=true}
		end
	},
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CON] = 6 },
		max_mana = 20,
		max_stamina = 20,
		max_psi = 20,
		max_air = 50,
		resists = {
			[DamageType.COLD] = 25,
			[DamageType.NATURE] = 10,
		},
		inc_damage={ [DamageType.COLD] = 15, },
	},
}

newEntity{ base = "BASE_RING",
	power_source = {nature=true},
	unique = true,
	name = "Ring of the Dead", color = colors.DARK_GREY, image = "object/artifact/jewelry_ring_of_the_dead.png",
	unided_name = _t"dull black ring",
	desc = _t[[This ring is imbued with powers from beyond the grave. It is said that those who wear it may find a new path when all other roads turn dim.]],
	level_range = {35, 42},
	rarity = 250,
	cost = 500,
	material_level = 4,
	special_desc = function(self) return _t"Will bring you back from death, but only once!" end,
	special = true,
	wielder = {
		inc_stats = { [Stats.STAT_LCK] = 10, },
		die_at = -100,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
	},
	one_shot_life_saving = true,
}

-- Mostly useful for getting through specific defenses or for cute multiDT synergies (Elemental Surge)
newEntity{ base = "BASE_RING",
	power_source = {arcane=true},
	unique = true,
	name = "Elemental Fury", color = colors.PURPLE, image = "object/artifact/ring_elemental_fury.png",
	unided_name = _t"multi-hued ring",
	desc = _t[[This ring shines with many colors.]],
	level_range = {15, 30},
	rarity = 200,
	cost = 200,
	material_level = 3,
	special_desc = function(self) return _t"All your damage is converted and split into arcane, fire, cold and lightning." end,
	wielder = {
		elemental_mastery = 0.25,
		inc_stats = { [Stats.STAT_MAG] = 6, [Stats.STAT_CUN] = 6, },
		inc_damage = {
			[DamageType.ARCANE]    = 25,
			[DamageType.FIRE]      = 25,
			[DamageType.COLD]      = 25,
			[DamageType.LIGHTNING] = 25,
		},
		resists_pen = {
			[DamageType.ARCANE]    = 25,
			[DamageType.FIRE]      = 25,
			[DamageType.COLD]      = 25,
			[DamageType.LIGHTNING] = 25,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {technique=true},
	unique = true,
	name = "Feathersteel Amulet", color = colors.WHITE, image = "object/artifact/feathersteel_amulet.png",
	unided_name = _t"light amulet",
	desc = _t[[The weight of the world seems a little lighter with this amulet around your neck.]],
	level_range = {5, 20},
	rarity = 200,
	cost = 90,
	material_level = 2,
	wielder = {
		slow_projectiles = 15,
		combat_def = 15,
		max_encumber = 20,
		fatigue = -20,
		avoid_pressure_traps = 1,
		movement_speed = 0.25, --ghoul movespeed breakpoint!--
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {unknown=true},
	unique = true,
	name = "The Far-Hand", color = colors.YELLOW, image = "object/artifact/the_far_hand.png",
	unided_name = _t"a weird metallic hand",
	desc = _t[[You can feel this strange metallic hand wriggling around, it feels as if space distorts around it.]],
	level_range = {20, 40},
	rarity = 200,
	cost = 1000,
	material_level = 3,
	wielder = {
		teleport_immune = 1,
		inc_stats = {
			[Stats.STAT_CON] = 10,
		},
	},
	max_power = 36, power_regen = 1,
	use_talent = { id = Talents.T_TELEPORT, level = 4, power = 36 },
}

newEntity{ base = "BASE_AMULET", define_as = "SET_GARKUL_TEETH",
	power_source = {technique=true},
	unique = true,
	name = "Garkul's Teeth", color = colors.YELLOW, image = "object/artifact/amulet_garkuls_teeth.png",
	unided_name = _t"a necklace made of teeth",
	desc = _t[[Hundreds of humanoid teeth have been strung together on multiple strands of thin leather, creating this tribal necklace.  One would have to assume that these are not the teeth of Garkul the Devourer but rather the teeth of Garkul's many meals.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 1000,
	material_level = 5,
	wielder = {
		inc_stats = {
			[Stats.STAT_STR] = 10,
			[Stats.STAT_CON] = 6,
		},
		talents_types_mastery = {
			["technique/strength-of-the-berserker"] = 0.1,
			["technique/2hweapon-assault"] = 0.1,
			["technique/warcries"] = 0.1,
			["technique/bloodthirst"] = 0.1,
		},
		combat_physresist = 18,
		combat_mentalresist = 18,
		pin_immune = 1,
	},
	max_power = 48, power_regen = 1,
	use_talent = { id = Talents.T_SHATTERING_SHOUT, level = 4, power = 10 },

	set_list = { {"define_as", "HELM_OF_GARKUL"} },
	set_desc = {
		garkul = _t"Another of Garkul's heirlooms would bring out his spirit.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","die_at"}, -100)
		game.logSeen(who, "#CRIMSON#As you wear both Garkul's heirlooms you can feel the mighty warrior's spirit flowing through you.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#CRIMSON#The spirit of Garkul fades away.")
	end,
}

newEntity{ base = "BASE_LITE", define_as = "SUMMERTIDE_PHIAL",
	power_source = {nature=true},
	unique = true,
	name = "Summertide Phial", image="object/artifact/summertide_phial.png",
	unided_name = _t"glowing phial",
	level_range = {1, 10},
	color=colors.YELLOW,
	encumber = 1,
	rarity = 100,
	desc = _t[[A small crystal phial that captured Sunlight during the Summertide.]],
	special_desc = function(self) return _t"When attacking in melee, deals 15 light damage and lights tiles in radius 1." end,
	cost = 200,

	max_power = 15, power_regen = 1,
	use_power = {
		name = function(self, who) return ("call light, dispelling darkness and lighting tiles in radius 20.(%d power, based on Willpower)"):tformat(self.use_power.litepower(self, who)) end,
		power = 10,
		litepower = function(self, who) return who:combatStatScale("wil", 50, 150) end,
		use = function(self, who)
			who:project({type="ball", range=0, radius=20}, who.x, who.y, engine.DamageType.LITE, self.use_power.litepower(self, who))
			game.logSeen(who, "%s brandishes %s %s and banishes all shadows!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			return {id=true, used=true}
		end,
		no_npc_use = function(self, who) return not game.party:hasMember(who) end,
	},
	wielder = {
		lite = 5,
		healing_factor = 0.1,
		inc_damage = {[DamageType.LIGHT]=10},
		resists = {[DamageType.LIGHT]=30},
		melee_project={[DamageType.LITE_LIGHT_BURST] = 15}
	},
}

newEntity{ base = "BASE_GEM",
	power_source = {arcane=true},
	unique = true,
	name = "Burning Star", image = "object/artifact/jewel_gem_burning_star.png",
	unided_name = _t"burning jewel",
	level_range = {20, 30},
	color=colors.YELLOW,
	encumber = 1,
	identified = false,
	rarity = 250,
	material_level = 3,
	color_attributes = {
		damage_type = 'LIGHT',
		alt_damage_type = 'LIGHT_BLIND',
		particle = 'light',
	},
	desc = _t[[The first Halfling mages during the Age of Allure discovered how to capture the Sunlight and infuse gems with it.
This star is the culmination of their craft. Light radiates from its ever-shifting yellow surface.]],
	cost = 400,

	max_power = 30, power_regen = 1,
	use_power = { name = _t"map surroundings within range 20", power = 30,
		no_npc_use = function(self, who) return not game.party:hasMember(who) end,
		use = function(self, who)
			who:magicMap(20)
			game.logSeen(who, "%s brandishes the %s which radiates in all directions!", who:getName():capitalize(), self:getName({no_add_name = true, do_color = true}))
			return {id=true, used=true}
		end
	},
	carrier = {
		lite = 1,
	},
}

newEntity{ base = "BASE_LITE",
	power_source = {arcane=true},
	unique = true,
	name = "Dúathedlen Heart",
	unided_name = _t"a dark, fleshy mass", image = "object/artifact/dark_red_heart.png",
	level_range = {30, 40},
	color = colors.RED,
	encumber = 1,
	unlit_bonus = false,
	rarity = 300,
	material_level = 4,
	sentient = true,
	desc = _t[[This dark red heart still beats despite being separated from its owner.  It also snuffs out any light source that comes near it.]],
	special_desc = function(self) return _t"The heart seems to absorb light when you deal darkness damage. Standing on unlit tiles, you feel stronger." end,
	cost = resolvers.rngrange(400,650),

	wielder = {
		lite = -1000,
		infravision = 7,
		inc_stats = {
			[Stats.STAT_MAG] = 5,
		},
		resists_cap = { [DamageType.LIGHT] = 10 },
		resists = { [DamageType.LIGHT] = 30 },
		talents_types_mastery = {
		["cunning/stealth"] = 0.2,
		["cursed/darkness"] = 0.2
		},
		combat_dam = 7,
		melee_project={[DamageType.DARKNESS] = 20},
	},

	talent_on_spell = { {chance=15, talent=Talents.T_INVOKE_DARKNESS, level=4}},

	on_wear = function(self, who)
		self.worn_by = who
		who:attr("darkness_darkens", 1)
	end,
	on_takeoff = function(self, who)
		who:attr("darkness_darkens", -1)
		self.worn_by = nil
	end,
	act = function(self)
		local who=self.worn_by
		if not self.worn_by then return end
		if who.x and who.y and not game.level.map.lites(who.x, who.y) then
			who:setEffect(who.EFF_UNLIT_HEART, 1,  { dam = 15, res = 10})
		else
			if who.x and who.y and game.level.map.lites(who.x, who.y) and who:hasEffect(who.EFF_UNLIT_HEART) then
				who:removeEffect(who.EFF_UNLIT_HEART)
			end
		end
	end,
}

newEntity{
	power_source = {nature=true},
	unique = true,
	type = "potion", subtype="potion",
	name = "Blood of Life",
	unided_name = _t"bloody phial",
	level_range = {1, 50},
	display = '!', color=colors.VIOLET, image="object/artifact/potion_blood_of_life.png",
	encumber = 0.4,
	rarity = 350,
	desc = _t[[This vial of blood was drawn from an ancient race in the Age of Haze. Some of the power and vitality of those early days of the world still flows through it. "Drink me, mortal," the red liquid seems to whisper in your thoughts. "I will bring you light beyond darkness. Those who taste my essence fear not the death of flesh. Drink me, mortal, if you value your life..."]],
	cost = 1000,
	special = true,

	use_simple = { name = _t"quaff the Blood of Life to grant an extra life", use = function(self, who)
		game.logSeen(who, "%s quaffs the %s!", who:getName():capitalize(), self:getName({no_add_name = true, do_color = true}))
		if self:triggerHook{"Artifact:BloodOfLife:used", who=who} then
			-- let addons do stuff
		elseif not who:attr("undead") then
			who.blood_life = true
			game.logPlayer(who, "#LIGHT_RED#You feel the Blood of Life rushing through your veins.")
		else
			game.logPlayer(who, "The Blood of Life seems to have no effect on you.")
		end
		return {used=true, id=true, destroy=true}
	end},
}

newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {technique=true},
	unique = true,
	name = "Eden's Guile", image = "object/artifact/boots_edens_guile.png",
	moddable_tile = "special/boots_edens_guile",
	unided_name = _t"pair of yellow boots",
	desc = _t[[The boots of a Rogue outcast, who knew that the best way to deal with a problem was to run from it.]],
	on_id_lore = "eden-guile",
	color = colors.YELLOW,
	level_range = {1, 20},
	rarity = 300,
	cost = 100,
	material_level = 2,
	wielder = {
		combat_armor = 1,
		combat_def = 2,
		fatigue = 2,
		talents_types_mastery = { ["cunning/survival"] = 0.2 },
		inc_stats = { [Stats.STAT_CUN] = 3, },
	},

	max_power = 50, power_regen = 1,
	use_power = {
		name = function(self, who) return ("boost speed by %d%% (based on Cunning)"):tformat(100 * self.use_power.speedboost(self, who)) end,
		power = 50,
		speedboost = function(self, who) return math.min(0.20 + who:getCun() / 200, 0.7) end,
		use = function(self, who)
			who:setEffect(who.EFF_SPEED, 8, {power=self.use_power:speedboost(who)})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true, technique=true},
	unique = true,
	name = "Fire Dragon Shield", image = "object/artifact/fire_dragon_shield.png",
	unided_name = _t"dragon shield",
	moddable_tile = "special/%s_fire_dragon_shield",
	moddable_tile_big = true,
	desc = _t[[This large shield was made using scales of many fire drakes from the lost land of Tar'Eyal.]],
	color = colors.LIGHT_RED,
	metallic = false,
	level_range = {27, 35},
	rarity = 300,
	require = { stat = { str=28 }, },
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	special_combat = {
		dam = 58,
		block = 220,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.FIRE,
	},
	wielder = {
		resists={[DamageType.FIRE] = 35},
		on_melee_hit={[DamageType.FIRE] = 17},
		damage_affinity = { [DamageType.FIRE] = 15, },
		combat_armor = 9,
		combat_def = 16,
		combat_def_ranged = 15,
		fatigue = 20,
		learn_talent = { [Talents.T_BLOCK] = 1, },
	},
	on_block = {desc = _t"30% chance that you'll breathe fire in a cone at the attacker (if within range 6).  This can only occur up to 4 times per turn.", fct = function(self, who, target, type, dam, eff)
		local hits = table.get(who.turn_procs, "flame_shield_procs") or 0
		if hits and hits >= 4 then return end

		if rng.percent(30) then
		table.set(who.turn_procs, "flame_shield_procs", hits + 1)
		if not target or not target.x or not target.y or core.fov.distance(who.x, who.y, target.x, target.y) > 6 then return end
			who:forceUseTalent(who.T_FIRE_BREATH, {ignore_energy=true, no_talent_fail=true, no_equilibrium_fail=true, ignore_cd=true, force_target=target, force_level=2, ignore_ressources=true})
		end
	end,
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {technique=true},
	unique = true,
	name = "Titanic", image = "object/artifact/shield_titanic.png",
	moddable_tile = "special/%s_titanic",
	moddable_tile_big = true,
	unided_name = _t"huge shield",
	desc = _t[[This shield made of the darkest stralite is huge, heavy and very solid.]],
	color = colors.GREY,
	level_range = {20, 30},
	rarity = 270,
	require = { stat = { str=37 }, },
	cost = 300,
	material_level = 3,
	special_combat = {
		dam = 48,
		block = 320,
		physcrit = 4.5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 18,
		combat_def = 20,
		combat_def_ranged = 10,
		fatigue = 30,
		combat_armor_hardiness = 20,
		learn_talent = { [Talents.T_BLOCK] = 1, },
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true},
	unique = true,
	name = "Black Mesh", image = "object/artifact/shield_mesh.png",
	unided_name = _t"pile of tendrils",
	desc = _t[[Black, interwoven tendrils form this mesh that can be used as a shield. It reacts visibly to your touch, clinging to your arm and engulfing it in a warm, black mass.]],
	color = colors.BLACK,
	level_range = {15, 30},
	rarity = 270,
	require = { stat = { str=20 }, },
	cost = 400,
	material_level = 3,
	moddable_tile = "special/%s_black_mesh",
	moddable_tile_big = true,
	metallic = false,
	special_combat = {
		dam = 40,
		block = 120,
		physcrit = 5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 2,
		combat_def = 8,
		combat_def_ranged = 8,
		fatigue = 6,
		learn_talent = { [Talents.T_BLOCK] = 1, },
		resists = { [DamageType.BLIGHT] = 25, [DamageType.DARKNESS] = 25, },
		inc_stats = { [Stats.STAT_WIL] = 5, },
	},
	on_block = {desc = _t"Up to once per turn, pull an attacker up to 15 spaces away into melee range, pinning and asphyxiating it", fct = function(self, who, src, type, dam, eff)
		if not src then return end
		if who.turn_procs.black_mesh then return end
 		if not src.canBe then return end

		who:logCombat(src, "#ORCHID#Black tendrils from #Source# grab #Target#!")
		local kb = src:canBe("knockback")
		if kb then
			who:logCombat(src, "#ORCHID##Source#'s tendrils pull #Target# in!")
			src:pull(who.x, who.y, 15)
		else
			game.logSeen(src, "#ORCHID#%s resists the tendrils' pull!", src:getName():capitalize())
		end
		if core.fov.distance(who.x, who.y, src.x, src.y) <= 1 and src:canBe('pin') then
			src:setEffect(src.EFF_CONSTRICTED, 6, {src=who})
		end
		who.turn_procs.black_mesh = true
	end,}
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Rogue Plight", image = "object/artifact/armor_rogue_plight.png",
	define_as = "ROGUE_PLIGHT",
	unided_name = _t"blackened leather armour",
	desc = _t[[No rogue blades shall incapacitate the wearer of this armour.]],
	level_range = {25, 40},
	rarity = 270,
	cost = 200,
	sentient = true,
	global_speed = 0.25, -- act every 4th turn
	require = { stat = { str=22 }, },
	material_level = 3,
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	special_desc = function(self) return _t"Transfers a bleed, poison, or wound to its source or a nearby enemy every 4 turns."
	end,
	wielder = {
		combat_def = 6,
		combat_armor = 7,
		fatigue = 7,
		ignore_direct_crits = 30,
		inc_stats = { [Stats.STAT_WIL] = 5, [Stats.STAT_CON] = 4, },
		resists={[DamageType.NATURE] = 35},
	},
	act = function(self)
		self:useEnergy()

		if not self.worn_by then return end -- items act even when not equipped
		local who = self.worn_by

		-- Make sure the item is worn
		-- This should be redundant but whatever
		local o, item, inven_id = who:findInAllInventoriesBy("define_as", "ROGUE_PLIGHT")
		if not o or not who:getInven(inven_id).worn then return end

		local Map = require "engine.Map"

		for eff_id, p in pairs(who.tmp) do
			-- p only has parameters, we need to get the effect definition (e) to check subtypes
			local e = who.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.subtype and (e.subtype.bleed or e.subtype.poison or e.subtype.wound) then

				-- Copy the effect parameters then change only the source
				-- This will preserve everything passed to the debuff in setEffect but will use the new source for +damage%, etc
				local effectParam = who:copyEffect(eff_id)
				effectParam.src = who

				if p.src and p.src.setEffect and not p.src.dead then -- Most debuffs don't define a source
					p.src:setEffect(eff_id, p.dur, effectParam)
					who:removeEffect(eff_id)
					game.logPlayer(who, "#CRIMSON#Rogue Plight transfers an effect to its source!")
					return true
				else
					-- If there is no source move the debuff to an adjacent enemy instead
					-- If there is no source or adjacent enemy the effect fails
					for _, coor in pairs(util.adjacentCoords(who.x, who.y)) do
						local act = game.level.map(coor[1], coor[2], Map.ACTOR)
						if act then
							act:setEffect(eff_id, p.dur, effectParam)
							who:removeEffect(eff_id)
							game.logPlayer(who, "#CRIMSON#Rogue Plight transfers an effect to a nearby enemy!")
							return true
						end
					end
				end
			end
		end
		return true
	end,
}

newEntity{
	power_source = {nature=true},
	unique = true,
	type = "misc", subtype="egg",
	unided_name = _t"dark egg",
	define_as = "MUMMIFIED_EGGSAC",
	name = "Mummified Egg-sac of Ungolë", image = "object/artifact/mummified_eggsack.png",
	level_range = {20, 35},
	rarity = 190,
	cost = 200,
	display = "*", color=colors.DARK_GREY,
	encumber = 2,
	not_in_stores = true,
	desc = _t[[Dry and dusty to the touch, it still seems to retain some shadow of life.]],

	carrier = {
		lite = -2,
	},
	max_power = 100, power_regen = 1,
	use_power = { name = _t"summon up to 2 spiders", power = 80, use = function(self, who)
		if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end

		local NPC = require "mod.class.NPC"
		local list = NPC:loadList("/data/general/npcs/spider.lua")

		for i = 1, 2 do
			-- Find space
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then break end

			local e
			repeat e = rng.tableRemove(list)
			until not e.unique and e.rarity

			local spider = game.zone:finishEntity(game.level, "actor", e)
			spider.make_escort = nil
			spider.silent_levelup = true
			spider.faction = who.faction
			spider.ai = "summoned"
			spider.ai_real = "dumb_talented_simple"
			spider.summoner = who
			spider.summon_time = 10
			spider.exp_worth = 0

			local setupSummon = getfenv(who:getTalentFromId(who.T_SPIDER).action).setupSummon
			setupSummon(who, spider, x, y)
			game:playSoundNear(who, "talents/slime")
		end
		return {id=true, used=true}
	end },
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Helm of the Dwarven Emperors", image = "object/artifact/helm_of_the_dwarven_emperors.png",
	unided_name = _t"shining helm",
	desc = _t[[A Dwarven helm embedded with a single diamond that can banish all underground shadows.]],
	level_range = {16, 28},
	rarity = 240,
	cost = resolvers.rngrange(125,200),
	material_level = 2,
	wielder = {
		lite = 6,
		combat_armor = 6,
		fatigue = 4,
		blind_immune = 0.3,
		confusion_immune = 0.3,
		inc_stats = { [Stats.STAT_WIL] = 3, [Stats.STAT_MAG] = 4, },
		resists={ [DamageType.DARKNESS] = 10, },
		inc_damage={
			[DamageType.LIGHT] = 10,
		},
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CON] = 10, [Stats.STAT_MAG] = 6, [Stats.STAT_WIL] = 7})
			self:specialWearAdd({"wielder","blind_immune"}, 0.3)
			self:specialWearAdd({"wielder","confusion_immune"}, 0.3)
			game.logPlayer(who, "#LIGHT_BLUE#The legacy of Dwarven Emperors grants you their wisdom.")
		end
	end,
}

newEntity{ base = "BASE_KNIFE",
	power_source = {technique=true},
	unique = true,
	name = "Silent Blade", image = "object/artifact/dagger_silent_blade.png",
	unided_name = _t"shining dagger",
	moddable_tile = "special/%s_dagger_silent_blade",
	moddable_tile_big = true,
	desc = _t[[A thin, dark dagger that seems to meld seamlessly into the shadows.]],
	level_range = {23, 28},
	rarity = 200,
	require = { stat = { cun=25 }, },
	cost = resolvers.rngrange(125,200),
	material_level = 2,
	combat = {
		dam = 25,
		apr = 10,
		physcrit = 8,
		dammod = {dex=0.55,str=0.35},
		no_stealth_break = true,
		melee_project={[DamageType.RANDOM_SILENCE] = 10},
		special_on_kill = {desc=_t"Enter stealth for 3 turns.", fct=function(combat, who, target)
			who:setEffect(who.EFF_SILENT_STEALTH, 3, { power = 30 })
		end},
	},
	wielder = {
		combat_atk = 10,
	},
}

-- The Moon/Star set offers an alternative damage scaling that works well with Dexterity and Cunning but doesn't play nice with the usual high weapon damage+physical dam/pen+crit setups
newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_MOON",
	power_source = {arcane=true},
	unique = true,
	name = "Moon", image = "object/artifact/dagger_moon.png",
	unided_name = _t"crescent blade",
	moddable_tile = "special/%s_dagger_moon",
	moddable_tile_big = true,
	desc = _t[[A viciously curved blade that a folk story says is made from a material that originates from the moon.  Devouring the light around it, it fades.]],
	level_range = {20, 50},
	rarity = 200,
	require = { stat = { dex=24, cun=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		damtype = DamageType.DARKNESS,
		dam = 10,
		physspeed = 0.8,
		dammod = {dex=0.2,str=0.2},
		special_on_hit = {desc=function(self, who, special)
				local dam = special.damage(self, who)
				local str
				if self.set_complete then
					str = ("Deal 200%% of your Cunning as Darkness damage (%d)."):tformat(dam)
				else
					str = ("Deal %d Darkness damage."):tformat(dam)
				end
				return str
			end,
			damage = function(self, who)
				return self.set_complete and who:getCun()*2 or 70
			end,
			fct=function(self, who, target, dam, special)
				local tg = {type="hit", range=1, radius=0, selffire=false}
				local damage = special.damage(self, who)
				who:project(tg, target.x, target.y, engine.DamageType.DARKNESS, damage)
		end},
	},
	wielder = {
		lite = -1,
	},
	set_list = { {"define_as","ART_PAIR_STAR"} },
	set_desc = {
		moon = _t"The moon shines alone in a starless sky.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","lite"}, 2)
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.DARKNESS]=25})
		self:specialSetAdd({"wielder","resists_pen"}, {[engine.DamageType.DARKNESS]=25})
		game.logSeen(who, "#ANTIQUE_WHITE#The two blades glow brightly as they are brought close together.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#ANTIQUE_WHITE#The light from the two blades fades as they are separated.")
	end,
}

newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_STAR",
	power_source = {arcane=true},
	unique = true,
	name = "Star",
	unided_name = _t"jagged blade", image = "object/artifact/dagger_star.png",
	moddable_tile = "special/%s_dagger_star",
	moddable_tile_big = true,
	desc = _t[[Legend tells of a blade, shining bright as a star. Forged from a material fallen from the skies, it glows.]],
	level_range = {20, 50},
	rarity = 200,
	require = { stat = { dex=24, cun=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		damtype = DamageType.LIGHT,
		dam = 10,
		physspeed = 0.8,
		dammod = {dex=0.2,str=0.2},
		special_on_hit = {desc=function(self, who, special)
				local dam = special.damage(self, who)
				local str
				if self.set_complete then
					str = ("Deal 200%% of your Dexterity as Light damage (%d)."):tformat(dam)
				else
					str = ("Deal %d Light damage."):tformat(dam)
				end
				return str
			end,
			damage = function(self, who)
				return self.set_complete and who:getDex()*2 or 70
			end,
			fct=function(self, who, target, dam, special)
				local tg = {type="hit", range=1, radius=0, selffire=false}
				local damage = special.damage(self, who)
				who:project(tg, target.x, target.y, engine.DamageType.LIGHT, damage)
		end},
	},
	wielder = {
		lite = 1,
	},
	set_list = { {"define_as","ART_PAIR_MOON"} },
	set_desc = {
		star = _t"The star shines alone in a moonless sky.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","lite"}, 2)
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.LIGHT]=25})
		self:specialSetAdd({"wielder","resists_pen"}, {[engine.DamageType.LIGHT]=25})
	end,

}

newEntity{ base = "BASE_RING",
	power_source = {technique=true},
	unique = true,
	name = "Ring of the War Master", color = colors.DARK_GREY, image = "object/artifact/ring_of_war_master.png",
	unided_name = _t"blade-edged ring",
	desc = _t[[A blade-edged ring that radiates power. As you put it on, strange thoughts of pain and destruction come to your mind.]],
	level_range = {40, 50},
	rarity = 200,
	cost = 500,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 3, [Stats.STAT_DEX] = 3, [Stats.STAT_CON] = 3, },
		combat_apr = 15,
		combat_dam = 10,
		combat_physcrit = 5,
		talents_mastery_bonus = {
			["technique"] = 0.3,
		},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true},
	unique = true,
	name = "Unstoppable Mauler", color = colors.UMBER, image = "object/artifact/unstoppable_mauler.png",
	unided_name = _t"heavy maul",
	desc = _t[[A huge greatmaul of incredible weight. Wielding it, you feel utterly unstoppable.]],
	level_range = {23, 30},
	rarity = 270,
	require = { stat = { str=40 }, },
	cost = 250,
	material_level = 3,
	combat = {
		dam = 48,
		apr = 15,
		physcrit = 3,
		dammod = {str=1.2},
		talent_on_hit = { [Talents.T_SUNDER_ARMOUR] = {level=3, chance=15} },
	},
	wielder = {
		combat_atk = 20,
		pin_immune = 1,
		knockback_immune = 1,
	},
	max_power = 18, power_regen = 1,
	use_talent = { id = Talents.T_FEARLESS_CLEAVE, level = 3, power = 18 },
}

newEntity{ base = "BASE_MACE", define_as = "CROOKED_CLUB",
	power_source = {technique=true},
	unique = true,
	name = "Crooked Club", color = colors.GREEN, image = "object/artifact/weapon_crooked_club.png",
	unided_name = _t"weird club",
	moddable_tile = "special/%s_weapon_crooked_club",
	moddable_tile_big = true,
	desc = _t[[An oddly twisted club with a hefty weight on the end. There's something very strange about it.]],
	level_range = {12, 20},
	rarity = 192,
	require = { stat = { str=20 }, },
	cost = 250,
	material_level = 2,
	combat = {
		dam = 25,
		apr = 4,
		physcrit = 10,
		dammod = {str=1},
		melee_project={
			[DamageType.RANDOM_CONFUSION_PHYS] = 14,
			[DamageType.PHYSICAL] = 30,

		},
		special_on_hit = {desc=_t"Reduce targets accuracy and powers by 5 (stacks 5 times)", fct=function(combat, who, target)
			target:setEffect(target.EFF_CROOKED, 5, { power = 5 })
		end},
	},
	wielder = {
		combat_atk = 12,
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {nature=true},
	unique = true,
	name = "Spider-Silk Robe of Spydrë", color = colors.DARK_GREEN, image = "object/artifact/robe_spider_silk_robe_spydre.png",
	unided_name = _t"spider-silk robe",
	desc = _t[[This set of robes is made wholly of spider silk. It looks outlandish and some sages think it came from another world, probably through a farportal.]],
	level_range = {20, 30},
	rarity = 190,
	cost = 250,
	material_level = 3,
	wielder = {
		combat_def = 10,
		combat_armor = 15,
		combat_armor_hardiness = 30,
		inc_stats = { [Stats.STAT_CON] = 5, [Stats.STAT_WIL] = 4, },
		combat_mindpower = 10,
		combat_mindcrit = 5,
		combat_spellresist = 10,
		combat_physresist = 10,
		inc_damage={[DamageType.NATURE] = 15, [DamageType.MIND] = 15, [DamageType.ACID] = 15},
		resists={[DamageType.NATURE] = 30},
		on_melee_hit={[DamageType.POISON] = 20, [DamageType.SLIME] = 20},
	},
	on_wear = function(self, who)
		if not game.state.spydre_mantra and who.player then
			game.state.spydre_mantra = true
			require("engine.ui.Dialog"):simpleLongPopup(_t"Huh?", _t"As you wear the strange set of robes, you notice something folded into one of its pockets...", 500, function()
				game.party:learnLore("shiiak-mantra")
			end)
		end
	end,
}


newEntity{ base = "BASE_HELM", define_as = "HELM_KROLTAR",
	power_source = {technique=true},
	unique = true,
	name = "Dragon-helm of Kroltar", image = "object/artifact/dragon_helm_of_kroltar.png",
	unided_name = _t"dragon-helm",
	desc = _t[[A visored steel helm, embossed and embellished with gold, that bears as its crest the head of Kroltar, the greatest of the fire drakes.]],
	require = { stat = { str=35 }, },
	level_range = {37, 45},
	rarity = 280,
	cost = 400,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, [Stats.STAT_LCK] = -4, [Stats.STAT_WIL] = 5 },
		inc_damage={
			[DamageType.PHYSICAL] = 10,
			[DamageType.FIRE] = 10,
		},
		talents_types_mastery = { ["wild-gift/fire-drake"] = 0.2, },
		combat_def = 5,
		combat_armor = 9,
		fatigue = 10,
	},
	max_power = 45, power_regen = 1,
	use_talent = { id = Talents.T_BELLOWING_ROAR, level = 3, power = 45 },
	set_list = { {"define_as","SCALE_MAIL_KROLTAR"} },
	set_desc = {
		kroltar = _t"Kroltar's power resides in his scales.",
	},
	on_set_complete = function(self, who)
		local Stats = require "engine.interface.ActorStats"
		self:specialSetAdd("skullcracker_mult", 1)
		self:specialSetAdd({"wielder","combat_spellresist"}, 15)
		self:specialSetAdd({"wielder","combat_mentalresist"}, 15)
		self:specialSetAdd({"wielder","combat_physresist"}, 15)
		self:specialSetAdd({"wielder","inc_stats"}, { [Stats.STAT_LCK] = 14 })
		game.logPlayer(who, "#GOLD#As the helm of Kroltar approaches the your scale armour, they begin to fume and emit fire.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#GOLD#The fumes and fire fade away.")
	end,
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Crown of Command", image = "object/artifact/crown_of_command.png",
	unided_name = _t"unblemished silver crown",
	desc = _t[[This crown was worn by the Halfling king Roupar, who ruled over the Nargol lands in the Age of Dusk.  Those were dark times, and the king enforced order and discipline under the harshest of terms.  Any who deviated were punished, any who disagreed were repressed, and many disappeared without a trace into his numerous prisons.  All must be loyal to the crown or suffer dearly.  When he died without heir the crown was lost and his kingdom fell into chaos.]],
	require = { stat = { cun=25 } },
	level_range = {20, 35},
	rarity = 280,
	cost = resolvers.rngrange(225,350),
	material_level = 3,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 3, [Stats.STAT_WIL] = 10, },
		combat_def = 3,
		combat_armor = 6,
		combat_mindpower = 5,
		fatigue = 4,
		resists = { [DamageType.PHYSICAL] = 8},
		talents_types_mastery = { ["technique/superiority"] = 0.2, ["cunning/survival"] = 0.2 },
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_INDOMITABLE, level = 1, power = 60 },
	on_wear = function(self, who)
		self.worn_by = who
		if who.descriptor and who.descriptor.race == "Halfling" then
			local Stats = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CUN] = 7, [Stats.STAT_STR] = 7, })
			game.logPlayer(who, "#LIGHT_BLUE#As you don the %s, you gain understanding of the might of your race.", self:getName({no_add_name = true, do_color = true}))
		end
	end,
	on_takeoff = function(self)
		self.worn_by = nil

	end,
}

newEntity{ base = "BASE_GLOVES",
	power_source = {technique=true},
	unique = true,
	name = "Gloves of the Firm Hand", image = "object/artifact/gloves_of_the_firm_hand.png",
	unided_name = _t"heavy gloves",
	desc = _t[[These gloves make you feel rock steady! These magical gloves feel really soft to the touch from the inside. On the outside, magical stones create a rough surface that is constantly shifting. When you brace yourself, a magical ray of earth energy seems to automatically bind them to the ground, granting you increased stability.]],
	level_range = {17, 27},
	rarity = 210,
	cost = 150,
	material_level = 3,
	wielder = {
		talent_cd_reduction={[Talents.T_CLINCH]=2},
		inc_stats = { [Stats.STAT_CON] = 4 },
		combat_armor = 8,
		disarm_immune=0.4,
		knockback_immune=0.3,
		stun_immune = 0.3,
		combat = {
			dam = 18,
			apr = 1,
			physcrit = 7,
			talent_on_hit = { T_CLINCH = {level=3, chance=20}, T_MAIM = {level=3, chance=10}, T_TAKE_DOWN = {level=3, chance=10} },
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
		},
	},
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Dakhtun's Gauntlets", color = colors.STEEL_BLUE, image = "object/artifact/dakhtuns_gauntlets.png",
	unided_name = _t"expertly-crafted dwarven-steel gauntlets",
	desc = _t[[Fashioned by Grand Smith Dakhtun in the Age of Allure, these dwarven-steel gauntlets have been etched with golden arcane runes and are said to grant the wearer unparalleled physical and magical might.]],
	level_range = {40, 50},
	rarity = 300,
	cost = resolvers.rngrange(700,1200),
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_MAG] = 6 },
		inc_damage = { [DamageType.PHYSICAL] = 10 },
		combat_physcrit = 10,
		combat_spellcrit = 10,
		combat_critical_power = 50,
		combat_armor = 6,
		combat = {
			dam = 35,
			apr = 10,
			physcrit = 10,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={[DamageType.ARCANE] = 20},
			talent_on_hit = { T_DISPLACEMENT_SHIELD = {level=3, chance=10}, T_WAVE_OF_POWER = {level=1, chance=15}, },
			damrange = 0.3,
		},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true, arcane=true},
	unique = true,
	name = "Voratun Hammer of the Deep Bellow", color = colors.LIGHT_RED, image = "object/artifact/voratun_hammer_of_the_deep_bellow.png",
	unided_name = _t"flame scorched voratun hammer",
	desc = _t[[The legendary hammer of the Dwarven master smiths. For ages it was used to forge powerful weapons with searing heat until it became highly powerful by itself.]],
	level_range = {38, 50},
	rarity = 250,
	require = { stat = { str=48 }, },
	cost = 650,
	material_level = 5,
	combat = {
		dam = 82,
		apr = 7,
		physcrit = 4,
		dammod = {str=1.2},
		talent_on_hit = { [Talents.T_FLAMESHOCK] = {level=3, chance=10} },
		melee_project={[DamageType.FIRE] = 30},
	},
	wielder = {
		inc_damage={
			[DamageType.PHYSICAL] = 15,
		},
	},
}

newEntity{ base = "BASE_GLOVES",
	power_source = {nature=true}, define_as = "SET_GIANT_WRAPS",
	unique = true,
	name = "Snow Giant Wraps", color = colors.SANDY_BROWN, image = "object/artifact/snow_giant_arm_wraps.png",
	unided_name = _t"fur-lined leather wraps",
	desc = _t[[Two large pieces of leather designed to be wrapped about the hands and the forearms.  This particular pair of wraps has been enchanted, imparting the wearer with great strength.]],
	level_range = {15, 25},
	rarity = 200,
	cost = 500,
	material_level = 3,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 4, },
		resists = { [DamageType.COLD]= 10, [DamageType.LIGHTNING] = 10, },
		knockback_immune = 0.5,
		combat_armor = 2,
		max_life = 60,
		combat = {
			dam = 16,
			apr = 1,
			physcrit = 4,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			talent_on_hit = { T_CALL_LIGHTNING = {level=5, chance=25}},
			melee_project={ [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10, },
		},
	},
	max_power = 6, power_regen = 1,
	use_talent = { id = Talents.T_THROW_BOULDER, level = 2, power = 6 },

	set_list = { {"define_as", "SET_MIGHTY_GIRDLE"} },
	set_desc = {
		giantset = _t"This would be great with a mighty matching belt.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","combat_dam"}, 10)
		self:specialSetAdd({"wielder","combat_physresist"}, 10)
	end,
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {technique=true}, define_as = "SET_MIGHTY_GIRDLE",
	unique = true,
	name = "Mighty Girdle", image = "object/artifact/belt_mighty_girdle.png",
	unided_name = _t"massive, stained girdle",
	desc = _t[[This girdle is enchanted with mighty wards against expanding girth. Whatever the source of its wondrous strength, it will prove of great aid in the transport of awkward burdens.]],
	color = colors.LIGHT_RED,
	level_range = {5, 14},
	rarity = 170,
	cost = 150,
	material_level = 1,
	wielder = {
		knockback_immune = 0.4,
		max_encumber = 70,
		combat_armor = 4,
		max_life = 40,
		fatigue = -10,
	},

	set_list = { {"define_as", "SET_GIANT_WRAPS"} },
	set_desc = {
		giantset = _t"Some giant wraps would make you feel great.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","max_life"}, 60)
		self:specialSetAdd({"wielder","size_category"}, 2)
		self:specialSetAdd({"wielder","fatigue"}, -10)
		game.logPlayer(who, "#GOLD#You grow to immense size!")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#LIGHT_BLUE#You feel a lot smaller...")
	end,
}

-- Benefits are large but mostly mutually exclusive, Rogues don't easily use the proc, etc, etc
newEntity{ base = "BASE_CLOAK",
	power_source = {nature=true},
	unique = true,
	name = "Serpentine Cloak", image = "object/artifact/serpentine_cloak.png",
	unided_name = _t"tattered cloak",
	desc = _t[[Cunning and malice seem to emanate from this cloak.]],
	level_range = {20, 29},
	rarity = 240,
	cost = resolvers.rngrange(225,350),
	material_level = 3,
	wielder = {
		combat_def = 20,
		poison_immune = 0.5,
		inc_stats = { [Stats.STAT_CUN] = 4, [Stats.STAT_DEX] = 4, [Stats.STAT_WIL] = 4 },
		resists_pen = { [DamageType.NATURE] = 20 },
		inc_damage = { [DamageType.NATURE] = 20 },
		talents_types_mastery = { ["cunning/stealth"] = 0.2, ["cunning/poisons"] = 0.5, },
	},
	talent_on_mind = { {chance=10, talent=Talents.T_POISON_STRIKE, level=1} }

}

newEntity{ base = "BASE_CLOTH_ARMOR", define_as = "CONCLAVE_ROBE",
	power_source = {arcane=true},
	unique = true,
	name = "Vestments of the Conclave", color = colors.DARK_GREY, image = "object/artifact/robe_vestments_of_the_conclave.png",
	unided_name = _t"tattered robe",
	desc = _t[[An ancient set of robes that has survived from the Age of Allure. Primal magic forces inhabit it.
It was made by Humans for Humans; only they can harness the true power of the robes.]],
	level_range = {12, 22},
	rarity = 220,
	cost = resolvers.rngrange(125,200),
	material_level = 2,
	wielder = {
		inc_damage = {[DamageType.ARCANE]=15},
		inc_stats = { [Stats.STAT_MAG] = 6 },
		combat_spellcrit = 15,
		combat_spellpower = 15,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Human" then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_MAG] = 3, [Stats.STAT_CUN] = 9, })
			self:specialWearAdd({"wielder","inc_damage"}, {[DamageType.ARCANE]=7})
			self:specialWearAdd({"wielder","combat_spellcrit"}, 5)
			game.logPlayer(who, "#LIGHT_BLUE#You feel as surge of power as you wear the vestments of the old Human Conclave!")
		end
	end,
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Firewalker", color = colors.RED, image = "object/artifact/robe_firewalker.png",
	unided_name = _t"blazing robe",
	desc = _t[[This fiery robe was worn by the mad pyromancer Halchot, who terrorised many towns in the late Age of Dusk, burning and looting villages as they tried to recover from the Spellblaze.  Eventually he was tracked down by the Ziguranth, who cut out his tongue, chopped off his head, and rent his body to shreds.  The head was encased in a block of ice and paraded through the streets of nearby towns amidst the cheers of the locals.  Only this robe remains of the flames of Halchot.]],
	special_desc = function(self) return _t"Damage all enemies in range 4 for 40 fire damage and yourself for 5 fire damage every turn." end,
	level_range = {20, 30},
	rarity = 300,
	cost = resolvers.rngrange(225,350),
	material_level = 3,
	wielder = {
		inc_damage = {[DamageType.FIRE]=20},
		combat_def = 15,
		combat_armor = 2,
		combat_spellpower = 12,
		inc_stats = { [Stats.STAT_MAG] = 10, [Stats.STAT_CUN] = 6, },
		resists = {[DamageType.FIRE] = 50, [DamageType.COLD] = -10},
		resists_pen = { [DamageType.FIRE] = 20 },
		on_melee_hit = {[DamageType.FIRE] = 18},
	},
	hasFoes = function(self, who)
		local who = self.worn_by
		for i = 1, #who.fov.actors_dist do
			local act = who.fov.actors_dist[i]
			if act and who:reactionToward(act) < 0 and who:canSee(act) then return true end
		end
		return false
	end,
	on_takeoff = function(self, who)
		self.worn_by=nil
		who:removeParticles(self.particle)
	end,
	on_wear = function(self, who)
		self.worn_by=who
		if core.shader.active(4) then
			self.particle = who:addParticles(engine.Particles.new("shader_ring_rotating", 1, {rotation=0, radius=4}, {type="flames", aam=0.5, zoom=3, npow=4, time_factor=4000, color1={1,0,0,1}, color2={1,0,0,1}, hide_center=0}))
		else
			self.particle = who:addParticles(engine.Particles.new("ultrashield", 1, {rm=0, rM=0, gm=180, gM=220, bm=10, bM=80, am=80, aM=150, radius=3, density=40, life=14, instop=17}))
		end
		game.logPlayer(who, "#CRIMSON# A powerful fire aura appears around you as you equip the %s.", self:getName({no_add_name = true, do_color = true}))
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		if self.hasFoes(self, who) then
			local blast = {type="ball", range=0, radius=4, friendlyfire=false}
			who:project(blast, who.x, who.y, engine.DamageType.FIRE, 40)
			local blast2 = {type="ball", range=0, radius=0, friendlyfire=true}
			who:project(blast2, who.x, who.y, engine.DamageType.FIRE, 5)
		end
	end,
	max_power = 15, power_regen = 1,
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Robe of the Archmage", color = colors.RED, image = "object/artifact/robe_of_the_archmage.png",
	unided_name = _t"glittering robe",
	desc = _t[[A plain elven-silk robe. It would be unremarkable if not for the sheer power it radiates.]],
	level_range = {30, 40},
	rarity = 290,
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	moddable_tile = "special/robe_of_the_archmage",
	moddable_tile_big = true,
	wielder = {
		lite = 1,
		inc_damage = {all=12},
		silence_immune = 0.5,
		combat_def = 10,
		combat_armor = 10,
		inc_stats = { [Stats.STAT_MAG] = 6, [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 6, },
		combat_spellpower = 15,
		combat_spellresist = 20,
		combat_mentalresist = 15,
		resists={[DamageType.FIRE] = 10, [DamageType.LIGHTNING] = 10, [DamageType.ARCANE] = 10, [DamageType.COLD] = 10},
		on_melee_hit={[DamageType.ARCANE] = 15},
		mana_regen = 2,
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR", define_as = "SET_TEMPORAL_ROBE",
	power_source = {arcane=true},
	unique = true,
	name = "Temporal Augmentation Robe - Designed In-Style", color = colors.BLACK, image = "object/artifact/robe_temporal_augmentation_robe.png",
	unided_name = _t"stylish robe with a scarf",
	desc = _t[[Designed by a slightly quirky Paradox Mage, this robe always appears to be stylish in any time the user finds him, her, or itself in. Crafted to aid Paradox Mages through their adventures, this robe is of great help to those that understand what a wibbly-wobbly, timey-wimey mess time actually is. Curiously, as a result of a particularly prolonged battle involving its fourth wearer, the robe appends a very long, multi-coloured scarf to its present wearers.]],
	level_range = {30, 40},
	rarity = 310,
	cost = 540,
	material_level = 4,
	wielder = {
		combat_spellpower = 23,
		inc_damage = {
			[DamageType.TEMPORAL]=20,
			[DamageType.PHYSICAL]=20
		},
		combat_def = 9,
		combat_armor = 3,
		inc_stats = { [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 3, },
		resists={
			[DamageType.TEMPORAL] = 10,
			[DamageType.PHYSICAL] = 10,
		},
		resists_pen = {
			[DamageType.TEMPORAL] = 20,
			[DamageType.PHYSICAL] = 20,
		},
		on_melee_hit={
			[DamageType.TEMPORAL] = 10,
			[DamageType.PHYSICAL] = 20,
		},
	},
	max_power = 50, power_regen = 1,
	use_talent = { id = Talents.T_TEMPORAL_REPRIEVE, level = 1, power = 50 },

	set_list = { {"define_as", "SET_TEMPORAL_FEZ"} },
	set_desc = {
		tardis = _t"Oddly it never produces a hat.",
	},
	on_set_complete = function(self, who)
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_WIZARD_HAT", define_as = "SET_TEMPORAL_FEZ",
	power_source = {arcane=true, psionic=true},
	unique = true,
	name = "Un'fezan's Cap",
	unided_name = _t"red stylish hat",
	desc = _t[[This fez once belonged to a traveler; it always seems to be found lying around in odd locations.
#{italic}#Fezzes are cool.#{normal}#]],
	color = colors.BLUE, image = "object/artifact/fez.png",
	moddable_tile = "special/fez",
	moddable_tile_big = true,
	level_range = {20, 40},
	rarity = 300,
	cost = 100,
	material_level = 3,
	wielder = {
		combat_def = 1,
		combat_spellpower = 8,
		combat_mindpower = 8,
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 8, },
		paradox_reduce_anomalies = 5,
		resists = {
			[DamageType.TEMPORAL] = 10,
			[DamageType.PHYSICAL] = 10,
		},
		talents_types_mastery = {
			["chronomancy/timetravel"]=0.2,
		},
	},
	max_power = 15, power_regen = 1,
	use_talent = { id = Talents.T_WORMHOLE, level = 1, power = 15 },

	set_list = { {"define_as", "SET_TEMPORAL_ROBE"} },
	set_desc = {
		tardis = _t"Needs something equally stylish and cool to go with it.",
	},
	on_set_complete = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#A time vortex briefly appears in front of you.")
		self:specialSetAdd({"wielder","paradox_reduce_anomalies"}, 20)
		self:specialSetAdd({"wielder","confusion_immune"}, 0.4)
		self:specialSetAdd({"wielder","combat_spellspeed"}, 0.1)
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.TEMPORAL] = 10 })
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL] = 10 })
	end,
	on_set_broken = function(self, who)
		self.use_talent = nil
		game.logPlayer(who, "#STEEL_BLUE#A time vortex briefly appears in front of you.")
	end,
}

newEntity{ base = "BASE_BATTLEAXE",
	power_source = {technique=true},
	unique = true,
	unided_name = _t"crude iron battle axe",
	name = "Crude Iron Battle Axe of Kroll", color = colors.GREY, image = "object/artifact/crude_iron_battleaxe_of_kroll.png",
	moddable_tile = "special/%s_crude_iron_battleaxe_of_kroll",
	moddable_tile_big = true,
	desc = _t[[Made in times before the Dwarves learned beautiful craftsmanship, the rough appearance of this axe belies its great power. Only Dwarves may harness its true strength, however.]],
	require = { stat = { str=50 }, },
	level_range = {39, 46},
	rarity = 300,
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	combat = {
		dam = 68,
		apr = 7,
		physcrit = 10,
		dammod = {str=1.3},
	},
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 2, [Stats.STAT_DEX] = 2, },
		combat_def = 6, combat_armor = 6,
		inc_damage = { [DamageType.PHYSICAL]=10 },
		stun_immune = 0.3,
		knockback_immune = 0.3,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CON] = 7, [Stats.STAT_DEX] = 7, })
			self:specialWearAdd({"wielder","stun_immune"}, 0.7)
			self:specialWearAdd({"wielder","knockback_immune"}, 0.7)
			game.logPlayer(who, "#LIGHT_BLUE#You feel as surge of power as you wield the axe of your ancestors!")
		end
	end,
}

newEntity{ base = "BASE_WHIP",
	power_source = {nature=true},
	unided_name = _t"metal whip",
	name = "Scorpion's Tail", color=colors.GREEN, unique = true, image = "object/artifact/whip_scorpions_tail.png",
	desc = _t[[A long whip of linked metal joints finished with a viciously sharp barb leaking terrible venom.]],
	require = { stat = { dex=28 }, },
	cost = resolvers.rngrange(225,350),
	rarity = 340,
	level_range = {20, 30},
	material_level = 3,
	combat = {
		dam = 28,
		apr = 8,
		physcrit = 5,
		dammod = {dex=1},
		melee_project={[DamageType.POISON] = 22, [DamageType.BLEED] = 22},
		talent_on_hit = { T_DISARM = {level=3, chance=30} },
	},
	wielder = {
		combat_atk = 10,
		see_invisible = 9,
		see_stealth = 9,
	},
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {nature=true},
	unique = true,
	name = "Girdle of Preservation", image = "object/artifact/belt_girdle_of_preservation.png",
	unided_name = _t"shimmering, flawless belt",
	desc = _t[[A pristine belt of purest white leather with a runed voratun buckle. The ravages of neither time nor the elements have touched it.]],
	color = colors.WHITE,
	level_range = {45, 50},
	rarity = 400,
	cost = 750,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 5, [Stats.STAT_WIL] = 5,  },
		resists = {
			[DamageType.ACID] = 15,
			[DamageType.LIGHTNING] = 15,
			[DamageType.FIRE] = 15,
			[DamageType.COLD] = 15,
			[DamageType.LIGHT] = 15,
			[DamageType.DARKNESS] = 15,
			[DamageType.BLIGHT] = 15,
			[DamageType.TEMPORAL] = 15,
			[DamageType.NATURE] = 15,
			[DamageType.PHYSICAL] = 10,
			[DamageType.ARCANE] = 10,
		},
		confusion_immune = 0.2,
		combat_physresist = 15,
		combat_mentalresist = 15,
		combat_spellresist = 15,
	},
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {nature=true},
	unique = true,
	name = "Girdle of the Calm Waters", image = "object/artifact/girdle_of_the_calm_waters.png",
	unided_name = _t"golden belt",
	desc = _t[[A belt rumoured to have been worn by the Conclave healers.]],
	color = colors.GOLD,
	level_range = {1, 25},
	rarity = 120,
	cost = 150,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 3,  },
		resists = {
			[DamageType.COLD] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.NATURE] = 20,
		},
		healing_factor = 0.15,
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Behemoth Hide", image = "object/artifact/behemoth_skin.png",
	moddable_tile = "special/behemoth_skin",
	unided_name = _t"tough weathered hide",
	desc = _t[[A rough hide made from a massive beast.  Seeing as it's so weathered but still usable, maybe it's a bit special...]],
	color = colors.BROWN,
	level_range = {18, 23},
	rarity = 230,
	require = { stat = { str=22 }, },
	cost = 250,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 3 },

		combat_armor = 6,
		combat_def = 4,
		combat_def_ranged = 8,

		max_encumber = 20,
		life_regen = 2,
		stamina_regen = 1,
		fatigue = 10,
		max_stamina = 45,
		max_life = 45,
		knockback_immune = 0.5,
		size_category = 1,
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR", define_as = "SKIN_OF_MANY",
	power_source = {technique=true},
	unique = true,
	name = "Skin of Many", image = "object/artifact/robe_skin_of_many.png",
	unided_name = _t"stitched skin armour",
	moddable_tile = "special/skin_of_many",
	moddable_tile2 = "special/skin_of_many_legs",
	moddable_tile_big = true,
	desc = _t[[The stitched-together skins of many creatures. Some eyes and mouths still decorate the robe, and some still live, screaming in tortured agony.]],
	color = colors.BROWN,
	level_range = {12, 22},
	rarity = 200,
	require = { stat = { str=16 }, },
	cost = 200,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 4 },
		combat_armor = 6,
		combat_def = 12,
		fatigue = 7,
		max_life = 40,
		infravision = 3,
		talents_types_mastery = { ["cunning/stealth"] = -0.2, },
	},
	on_wear = function(self, who)
		-- We cant use :attr("undead") as this can easily change so .. ugh :/
		if who.descriptor and (who.descriptor.race == "Undead" or who.descriptor.race == "MinotaurUndead" or who.descriptor.race == "EmpireUndead") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["cunning/stealth"] = 0.4 })
			self:specialWearAdd({"wielder","confusion_immune"}, 0.4)
			self:specialWearAdd({"wielder","blind_immune"}, 0.4)
			game.logPlayer(who, "#BLUE#The skin seems pleased to be worn by the unliving, and grows silent.")
		end
	end,
}

newEntity{ base = "BASE_HEAVY_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Iron Mail of Bloodletting", image = "object/artifact/iron_mail_of_bloodletting.png",
	unided_name = _t"gore-encrusted suit of iron mail",
	desc = _t[[Blood drips continuously from this fell suit of iron, and dark magics churn almost visibly around it. Bloody ruin comes to those who stand against its wearer.]],
	color = colors.RED,
	level_range = {15, 25},
	rarity = 190,
	require = { stat = { str=14 }, },
	cost = 200,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 2, [Stats.STAT_STR] = 2 },
		resists = {
			[DamageType.ACID] = 10,
			[DamageType.DARKNESS] = 10,
			[DamageType.FIRE] = 10,
			[DamageType.BLIGHT] = 10,
		},
		talents_types_mastery = { ["technique/bloodthirst"] = 0.1 },
		life_regen = 3,
		healing_factor = 0.3,
		combat_def = 2,
		combat_armor = 4,
		fatigue = 12,
	},
}


newEntity{ base = "BASE_HEAVY_ARMOR", define_as = "SCALE_MAIL_KROLTAR",
	power_source = {technique=true, nature=true},
	unique = true,
	name = "Scale Mail of Kroltar", image = "object/artifact/scale_mail_of_kroltar.png",
	unided_name = _t"perfectly-wrought suit of dragon scales",
	desc = _t[[A heavy shirt of scale mail constructed from the remains of Kroltar, whose armour was like tenfold shields.]],
	color = colors.LIGHT_RED,
	metallic = false,
	level_range = {38, 45},
	rarity = 300,
	require = { stat = { str=38 }, },
	cost = 500,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 4, [Stats.STAT_STR] = 5, [Stats.STAT_DEX] = 3 },
		resists = {
			[DamageType.ACID] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.FIRE] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.NATURE] = 20,
		},
		max_life=120,
		combat_def = 10,
		combat_armor = 18,
		fatigue = 16,
	},
	max_power = 80, power_regen = 1,
	use_talent = { id = Talents.T_DEVOURING_FLAME, level = 3, power = 50 },
	set_list = { {"define_as","HELM_KROLTAR"} },
	set_desc = {
		kroltar = _t"Kroltar's head would turn up the heat.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","max_life"}, 120)
		self:specialSetAdd({"wielder","fatigue"}, -8)
		self:specialSetAdd({"wielder","combat_def"}, 10)
	end,
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Cuirass of the Thronesmen", image = "object/artifact/armor_cuirass_of_the_thronesmen.png",
	unided_name = _t"heavy dwarven-steel armour",
	desc = _t[[This heavy dwarven-steel armour was created in the deepest forges of the Iron Throne. While it grants incomparable protection, it demands that you rely only on your own strength.]],
	color = colors.WHITE,
	level_range = {35, 40},
	rarity = 320,
	require = { stat = { str=44 }, },
	cost = 500,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 6, },
		resists = {
			[DamageType.FIRE] = 25,
			[DamageType.DARKNESS] = 25,
		},
		combat_def = 20,
		combat_armor = 32,
		combat_armor_hardiness = 10,
		stun_immune = 0.4,
		knockback_immune = 0.4,
		combat_physresist = 40,
		healing_factor = -0.3,
		fatigue = 15,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Talents = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","max_life"}, 100)
			self:specialWearAdd({"wielder","fatigue"}, -15)

			game.logPlayer(who, "#LIGHT_BLUE#You feel your dwarven power swelling to meet the challenge of this armor!")
		end
	end,
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {psionic=true},
	unique = true,
	name = "Golden Three-Edged Sword 'The Truth'", image = "object/artifact/golden_3_edged_sword.png",
	unided_name = _t"three-edged sword",
	desc = _t[[The wise ones say that truth is a three-edged sword. And sometimes, the truth hurts.]],
	level_range = {27, 36},
	require = { stat = { str=18, wil=18, cun=18 }, },
	color = colors.GOLD,
	encumber = 12,
	cost = 350,
	rarity = 240,
	material_level = 3,
	moddable_tile = "special/2H_golden_sword_%s",
	moddable_tile_big = true,
	combat = {
		dam = 49,
		apr = 9,
		physcrit = 9,
		dammod = {str=1.29},
		special_on_hit = {desc=_t"9% chance to stun or confuse the target", fct=function(combat, who, target)
			if not rng.percent(9) then return end
			local eff = rng.table{"stun", "confusion"}
			if not target:canBe(eff) then return end
			if not target:checkHit(who:combatAttack(combat), target:combatPhysicalResist(), 15) then return end
			if eff == "stun" then target:setEffect(target.EFF_STUNNED, 3, {})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 3, {power=50})
			end
		end},
		melee_project={[DamageType.LIGHT] = 49, [DamageType.DARKNESS] = 49},
	},
}

newEntity{ base = "BASE_MACE",
	power_source = {nature=true},
	name = "Ureslak's Femur", define_as = "URESLAK_FEMUR", image="object/artifact/club_ureslaks_femur.png",
	unided_name = _t"a strangely colored bone", unique = true,
	moddable_tile = "special/%s_club_ureslaks_femur",
	moddable_tile_big = true,
	desc = _t[[A shortened femur of the mighty prismatic dragon Ureslak, this erratic club still resonates with his volatile nature.]],
	level_range = {42, 50},
	require = { stat = { str=45, dex=30 }, },
	rarity = 400,
	metallic = false,
	cost = 300,
	material_level = 5,
	combat = {
		dam = 52,
		apr = 5,
		physcrit = 2.5,
		dammod = {str=1},
		special_on_hit = {desc=_t"10% chance to shimmer to a different hue and gain powers", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(10) then return end
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "URESLAK_FEMUR")
			if not o or not who:getInven(inven_id).worn then return end

			who:onTakeoff(o, inven_id, true)
			local b = rng.table(o.ureslak_bonuses)
			o.name = ("Ureslak's %s Femur"):tformat(b.name)
			o.combat.damtype = b.damtype
			o.wielder = b.wielder
			who:onWear(o, inven_id, true)
			game.logSeen(who, "#GOLD#Ureslak's Femur glows and shimmers!")
		end },
	},
	ureslak_bonuses = {
		{ name = _t"Flaming", damtype = DamageType.FIREBURN, wielder = {
			global_speed_add = 0.3,
			resists = { [DamageType.FIRE] = 45 },
			resists_pen = { [DamageType.FIRE] = 30 },
			inc_damage = { [DamageType.FIRE] = 30 },
		} },
		{ name = _t"Frozen", damtype = DamageType.ICE, wielder = {
			combat_armor = 15,
			resists = { [DamageType.COLD] = 45 },
			resists_pen = { [DamageType.COLD] = 30 },
			inc_damage = { [DamageType.COLD] = 30 },
		} },
		{ name = _t"Crackling", damtype = DamageType.LIGHTNING_DAZE, wielder = {
			inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_DEX] = 6, [Stats.STAT_CON] = 6, [Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 6, [Stats.STAT_MAG] = 6, },
			resists = { [DamageType.LIGHTNING] = 45 },
			resists_pen = { [DamageType.LIGHTNING] = 30 },
			inc_damage = { [DamageType.LIGHTNING] = 30 },
		} },
		{ name = _t"Venomous", damtype = DamageType.POISON, wielder = {
			resists = { all = 15, [DamageType.NATURE] = 45 },
			resists_pen = { [DamageType.NATURE] = 30 },
			inc_damage = { [DamageType.NATURE] = 30 },
		} },
		{ name = _t"Starry", damtype = DamageType.DARKNESS_BLIND, wielder = {
			combat_spellresist = 15, combat_mentalresist = 15, combat_physresist = 15,
			resists = { [DamageType.DARKNESS] = 45 },
			resists_pen = { [DamageType.DARKNESS] = 30 },
			inc_damage = { [DamageType.DARKNESS] = 30 },
		} },
		{ name = _t"Eldritch", damtype = DamageType.ARCANE, wielder = {
			resists = { [DamageType.ARCANE] = 45 },
			resists_pen = { [DamageType.ARCANE] = 30 },
			inc_damage = { all = 12, [DamageType.ARCANE] = 30 },
		} },
	},
	set_list = { {"define_as","URESLAK_CLOAK"} },
	set_desc = {
		ureslak = _t"What would happen if more of Ureslak's remains were reunited?",
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {nature=true},
	unique = true,
	name = "Ureslak's Molted Scales", define_as = "URESLAK_CLOAK", image = "object/artifact/ureslaks_molted_scales.png",
	unided_name = _t"scaly multi-hued cloak",
	desc = _t[[This cloak is fashioned from the scales of some large reptilian creature.  It appears to reflect every color of the rainbow.]],
	level_range = {40, 50},
	rarity = 400,
	cost = 300,
	material_level = 5,
	wielder = {
		resists_cap = {
			[DamageType.FIRE] = 10,
			[DamageType.COLD] = 10,
			[DamageType.LIGHTNING] = 10,
			[DamageType.NATURE] = 10,
			[DamageType.DARKNESS] = 10,
			[DamageType.ARCANE] = -30,
		},
		resists = {
			[DamageType.FIRE] = 20,
			[DamageType.COLD] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.NATURE] = 20,
			[DamageType.DARKNESS] = 20,
			[DamageType.ARCANE] = -30,
		},
	},
	max_power = 50, power_regen = 1,
	use_power = {
		name = function(self, who)
			local resists={"Fire", "Cold", "Lightning", "Nature", "Darkness"}
			if self.set_complete then table.insert(resists, "Arcane") end
			return ("energize the scales for 16 turns, increasing resistance to %s damage by 15%% just before you are damaged. (This effect lasts 5 turns and only works on one type of damage.)"):tformat(table.concatNice(table.capitalize(table.ts(table.lower(resists))), ", ", _t", or "))
		end,
		tactical = { DEFEND = 1 },
		power = 50,
		use = function(self, who)
			game.logSeen(who, "%s empowers %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			local resists = table.values({engine.DamageType.FIRE, engine.DamageType.COLD, engine.DamageType.LIGHTNING, engine.DamageType.NATURE, engine.DamageType.DARKNESS2, engine.DamageType.DARKNESS})
			if self.set_complete then table.insert(resists, engine.DamageType.ARCANE) end
			who:setEffect(who.EFF_CHROMATIC_RESONANCE, 16, {resist_types=resists})
			return {id=true, used=true}
		end,
	},
	set_list = { {"define_as","URESLAK_FEMUR"} },
	set_desc = {
		ureslak = _t"It would go well with another part of Ureslak.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","equilibrium_regen"}, -1)
		self:specialSetAdd({"wielder","resists"}, {[engine.DamageType.ARCANE]=15})
		self:specialSetAdd({"wielder","resists_cap"}, {[engine.DamageType.ARCANE]=15})
		game.logSeen(who, "#YELLOW_GREEN#An ironic harmony surrounds Ureslak's remains as they reunite.")
	end,
	on_set_broken = function(self, who)
		self.wielder.equilibrium_regen = nil
		game.logSeen(who, "#YELLOW_GREEN#Ureslak's remains seem more unsettled.")
	end,
}

-- Anti-mitigation DoT weapon
newEntity{ base = "BASE_WARAXE",
	power_source = {psionic=true},
	unique = true, unided_name = _t"razor sharp war axe",
	name = "Razorblade, the Cursed Waraxe", color = colors.LIGHT_BLUE, image = "object/artifact/razorblade_the_cursed_waraxe.png",
	moddable_tile = "special/%s_razorblade_the_cursed_waraxe",
	moddable_tile_big = true,
	desc = _t[[This mighty axe can cleave through armour like the sharpest swords, yet hit with all the impact of a heavy club.
It is said the wielder will slowly grow mad. This, however, has never been proven - no known possessor of this item has lived to tell the tale.]],
	require = { stat = { str=42 }, },
	level_range = {40, 50},
	rarity = 250,
	cost = resolvers.rngrange(400,650),
	material_level = 5,
	combat = {
		dam = 38,
		apr = 16,
		physcrit = 7,
		dammod = {str=1},
		damrange = 1.4,
		damtype = DamageType.PHYSICALBLEED,
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 4, [Stats.STAT_DEX] = 4, },
		combat_atk = 40,
		combat_apr = 30,
		resists_pen = { [DamageType.PHYSICAL]=30 },
	},
}

newEntity{ base = "BASE_LONGSWORD", define_as = "ART_PAIR_TWSWORD",
	power_source = {arcane=true},
	unique = true,
	name = "Sword of Potential Futures", image = "object/artifact/sword_of_potential_futures.png",
	unided_name = _t"under-wrought blade",
	moddable_tile = "special/%s_sword_of_potential_futures",
	moddable_tile_big = true,
	desc = _t[[Legend has it this blade is one of a pair: twin blades forged in the earliest of days of the Wardens. To an untrained wielder it is less than perfect; to a Warden, it represents the untapped potential of time.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=24, mag=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 28,
		apr = 10,
		physcrit = 8,
		physspeed = 0.9,
		dammod = {str=0.8,mag=0.2},
		melee_project={[DamageType.TEMPORAL] = 5},
		convert_damage = {
			[DamageType.TEMPORAL] = 30,
		},
	},
	wielder = {
		inc_damage={
			[DamageType.TEMPORAL] = 5,
		},
		combat_spellpower = 5,
		combat_spellcrit = 5,
		resist_all_on_teleport = 5,
		defense_on_teleport = 10,
		effect_reduction_on_teleport = 15,
		talents_types_mastery = {
			["chronomancy/blade-threading"] = 0.1,
			["chronomancy/guardian"] = 0.1,
		}
	},
	set_list = { {"define_as","ART_PAIR_TWDAG"} },
	set_desc = {
		twsword = _t"In the past there was a dagger with it.",
	},
	on_set_complete = function(self, who)
		self.combat.special_on_hit = {desc=_t"10% chance to reduce the target's resistances to all damage", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			target:setEffect(target.EFF_FLAWED_DESIGN, 3, {power=20})
		end}
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.TEMPORAL]=5, [engine.DamageType.PHYSICAL]=10,})
		game.logSeen(who, "#CRIMSON#The echoes of time resound as the blades are reunited once more.")
	end,
	on_set_broken = function(self, who)
		self.combat.special_on_hit = nil
		game.logPlayer(who, "#CRIMSON#Time seems less perfect in your eyes as the blades are separated.")
	end,
}

newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_TWDAG",
	power_source = {arcane=true},
	unique = true,
	name = "Dagger of the Past", image = "object/artifact/dagger_of_the_past.png",
	unided_name = _t"rusted blade",
	moddable_tile = "special/%s_dagger_of_the_past",
	moddable_tile_big = true,
	desc = _t[[Legend has it this blade is one of a pair: twin blades forged in the earliest of days of the Wardens. To an untrained wielder it is less than perfect; to a Warden, it represents the opportunity to learn from the mistakes of the past.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=24, mag=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 25,
		apr = 20,
		physcrit = 20,
		physspeed = 0.9,
		dammod = {dex=0.5,mag=0.5},
		melee_project={[DamageType.TEMPORAL] = 5},
		convert_damage = {
			[DamageType.TEMPORAL] = 30,
	},
	},
	wielder = {
		inc_damage={
			[DamageType.TEMPORAL] = 5,
		},
		movement_speed = 0.20,
		combat_def = 10,
		combat_spellresist = 10,
		resist_all_on_teleport = 5,
		defense_on_teleport = 10,
		effect_reduction_on_teleport = 15,
		talents_types_mastery = {
			["chronomancy/blade-threading"] = 0.1,
			["chronomancy/guardian"] = 0.1,
		}
	},
	set_list = { {"define_as","ART_PAIR_TWSWORD"} },
	set_desc = {
		twsword = _t"Potentially it would go with a sword in the future.",
	},
	on_set_complete = function(self, who)
		self.combat.special_on_hit = {desc=_t"10% chance to return the target to a much younger state", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			target:setEffect(target.EFF_TURN_BACK_THE_CLOCK, 3, {power=10})
		end}
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.TEMPORAL]=5, [engine.DamageType.PHYSICAL]=10,})
		self:specialSetAdd({"wielder","resists_pen"}, {[engine.DamageType.TEMPORAL]=15,})
	end,
	on_set_broken = function(self, who)
		self.combat.special_on_hit = nil
	end,
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true},
	unique = true,
	name = "Stone Gauntlets of Harkor'Zun", image = "object/artifact/harkor_zun_gauntlets.png",
	unided_name = _t"dark stone gauntlets",
	desc = _t[[Fashioned in ancient times by cultists of Harkor'Zun, these heavy granite gauntlets were designed to protect the wearer from the wrath of their dark master.]],
	level_range = {26, 31},
	rarity = 210,
	encumber = 7,
	metallic = false,
	cost = 150,
	material_level = 3,
	wielder = {
		talent_cd_reduction={
			[Talents.T_CLINCH]=2,
		},
		fatigue = 10,
		combat_armor = 7,
		inc_damage = { [DamageType.PHYSICAL]=5, [DamageType.ACID]=10, },
		resists = {[DamageType.ACID] = 20, [DamageType.PHYSICAL] = 10, },
		resists_cap = {[DamageType.ACID] = 10, [DamageType.PHYSICAL] = 5, },
		resists_pen = {[DamageType.ACID] = 15, [DamageType.PHYSICAL] = 15, },
		combat = {
			dam = 26,
			apr = 15,
			physcrit = 5,
			dammod = {dex=0.3, str=-0.4, cun=0.3 },
			melee_project={[DamageType.ACID] = 10},
			talent_on_hit = { T_EARTHEN_MISSILES = {level=3, chance=20}, T_CORROSIVE_MIST = {level=1, chance=10} },
			damrange = 0.3,
			physspeed = 0.2,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true, psionic=true},
	unique = true,
	name = "Unflinching Eye", color = colors.WHITE, image = "object/artifact/amulet_unflinching_eye.png",
	unided_name = _t"a bloodshot eye",
	desc = _t[[Someone has strung a thick black cord through this large bloodshot eyeball, allowing it to be worn around the neck, should you so choose.]],
	level_range = {30, 40},
	rarity = 300,
	cost = 300,
	material_level = 4,
	metallic = false,
	wielder = {
		infravision = 3,
		resists = { [DamageType.LIGHT] = -25 },
		resists_cap = { [DamageType.LIGHT] = -25 },
		blind_immune = 1,
		confusion_immune = 0.5,
		esp = { horror = 1 }, esp_range = 10,
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_ARCANE_EYE, level = 2, power = 60 },
}

newEntity{ base = "BASE_DIGGER",
	power_source = {technique=true, arcane=true},
	unique = true,
	name = "Pick of Dwarven Emperors", color = colors.GREY, image = "object/artifact/pick_of_dwarven_emperors.png",
	unided_name = _t"crude iron pickaxe",
	desc = _t[[This ancient pickaxe was used to pass down dwarven legends from one generation to the next. Every bit of the head and shaft is covered in runes that recount the stories of the dwarven people.]],
	level_range = {40, 50},
	rarity = 290,
	cost = 150,
	material_level = 5,
	digspeed = 12,
	wielder = {
		resists_pen = { [DamageType.PHYSICAL] = 10, },
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, },
		combat_mentalresist = 10,
		combat_physresist = 10,
		combat_spellresist = 10,
		max_life = 50,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_EARTHQUAKE, level = 4, power = 30 },
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, })
			self:specialWearAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL] = 10 })
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["race/dwarf"] = 0.2 })

			game.logPlayer(who, "#LIGHT_BLUE#You feel the whisper of your ancestors as you wield this pickaxe!")
		end
	end,
}

newEntity{ base = "BASE_ARROW",
	power_source = {arcane=true},
	unique = true,
	name = "Quiver of the Sun",
	unided_name = _t"bright quiver",
	desc = _t[[This strange orange quiver is made of brass and etched with many bright red runes that glow and glitter in the light.  The arrows themselves appear to be solid shafts of blazing hot light, like rays of sunshine, hammered and forged into a solid state.]],
	color = colors.BLUE, image = "object/artifact/quiver_of_the_sun.png",
	proj_image = "object/artifact/arrow_s_quiver_of_the_sun.png",
	level_range = {20, 40},
	rarity = 300,
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	require = { stat = { dex=24 }, },
	combat = {
		capacity = 25,
		tg_type = "beam",
		travel_speed = 3,
		dam = 34,
		apr = 15, --Piercing is piercing
		physcrit = 2,
		dammod = {dex=0.6, str=0.5, mag=0.2},
		damtype = DamageType.LITE_LIGHT,
		ranged_project = {[DamageType.ITEM_LIGHT_BLIND] = 25},

	},
}

newEntity{ base = "BASE_ARROW",
	power_source = {psionic=true},
	unique = true,
	name = "Quiver of Domination",
	unided_name = _t"grey quiver",
	desc = _t[[Powerful telepathic forces emanate from the arrows of this quiver. The tips appear dull, but touching them causes you intense pain.]],
	color = colors.GREY, image = "object/artifact/quiver_of_domination.png",
	proj_image = "object/artifact/arrow_s_quiver_of_domination.png",
	level_range = {20, 40},
	rarity = 300,
	cost = 100,
	material_level = 4,
	require = { stat = { dex=24 }, },
	combat = {
		capacity = 20,
		dam = 24,
		apr = 8,
		physcrit = 2,
		dammod = {dex=0.6, str=0.5, wil=0.2},
		damtype = DamageType.MIND,
		special_on_crit = {desc=_t"dominate the target", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:canBe("instakill") then
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				target:setEffect(target.EFF_DOMINATE_ENTHRALL, 3, {src=who, apply_power=check})
			end
		end},
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true, antimagic=true},
	unique = true,
	name = "Blightstopper",
	unided_name = _t"vine coated shield",
	moddable_tile = "special/%s_blightstopper",
	moddable_tile_big = true,
	desc = _t[[This voratun shield, coated with thick vines, was imbued with nature's power long ago by the Halfling General Almadar Riul, who used it to stave off the magic and diseases of orcish corruptors during the peak of the Pyre Wars.]],
	color = colors.LIGHT_GREEN, image = "object/artifact/blightstopper.png",
	level_range = {36, 45},
	rarity = 300,
	require = { stat = { str=35 }, },
	cost = 375,
	material_level = 5,
	special_combat = {
		dam = 52,
		block = 240,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.PHYSICAL,
		convert_damage = {
			[DamageType.NATURE] = 30,
			[DamageType.MANABURN] = 10,
		},
	},
	wielder = {
		resists={[DamageType.BLIGHT] = 35, [DamageType.NATURE] = 15},
		on_melee_hit={[DamageType.NATURE] = 15},
		combat_armor = 12,
		combat_def = 18,
		combat_def_ranged = 12,
		combat_spellresist = 24,
		talents_types_mastery = { ["wild-gift/antimagic"] = 0.2, },
		fatigue = 22,
		learn_talent = { [Talents.T_BLOCK] = 1,},
		disease_immune = 0.6,
	},
	max_power = 40, power_regen = 1,
	use_power = {
		name = function(self, who)
			local effpower = self.use_power.effpower(self, who)
			return ("purge up to %d diseases (based on Willpower) and gain disease immunity, %d%% blight resistance, and %d spell save for 5 turns"):tformat(self.use_power.nbdisease(self, who), effpower, effpower)
		end,
		tactical = {CURE = function(who, t, aitarget) -- cure diseases
				local nb, e = 0
				for eff_id, p in pairs(who.tmp) do
					e = who.tempeffect_def[eff_id]
					if e.status == "detrimental" and e.subtype.disease then
						nb = nb + 1
					end
				return nb
				end
			end,
			DEFEND = function(who, t, aitarget) -- if the target can hit us with spells or blight damage, prepare
				if not aitarget or who:hasEffect(who.EFF_PURGE_BLIGHT) then return 0 end
				local count, nb, tal = 0, 0
				for t_id, p in pairs(aitarget.talents) do
					tal = aitarget.talents_def[t_id]
					if tal.mode == "activated" then
						count = count + 1
						if tal.is_spell and tal.mode == "activated" then
							nb = nb + 0.1
							if type(tal.tactical) == "table" then
								nb = nb + ((type(tal.tactical.attack) == "table" and tal.tactical.attack.BLIGHT or type(tal.tactical.attackarea) == "table" and tal.tactical.attackarea.BLIGHT) and 0.75 or 0)
							end
						end
					end
				end
				return math.min(5*(nb/count)^.5, 5)
			end
		},
		power = 24,
		nbdisease = function(self, who) return math.floor(who:combatStatScale("wil", 3, 5, "log")) end, -- There really aren't that many different disease you can have at one time.
		effpower = function(self, who) return 20 end,
		use = function(self, who)
			local target = who
			local effs = {}
			local known = false

			game.logSeen(who, "%s holds %s %s close, cleansing %s of corruption!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}), who:his_her_self())
			who:setEffect(who.EFF_PURGE_BLIGHT, 5, {power=self.use_power.effpower(self, who)})

				-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.subtype.disease then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			for i = 1, self.use_power.nbdisease(self, who) do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					target:removeEffect(eff[2])
					known = true
				end
			end
			if known then game.logSeen(who, "%s is purged of diseases!", who:getName():capitalize()) end
			return {id=true, used=true}
		end,
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","resists"}, {[DamageType.ARCANE] = 15, [DamageType.BLIGHT] = 5})
			self:specialWearAdd({"wielder","disease_immune"}, 0.15)
			self:specialWearAdd({"wielder","poison_immune"}, 0.5)
			game.logPlayer(who, "#DARK_GREEN#You feel nature's power protecting you!")
		end
	end,
}

newEntity{ base = "BASE_SHOT",
	power_source = {arcane=true},
	unique = true,
	name = "Star Shot",
	unided_name = _t"blazing shot",
	desc = _t[[Intense heat radiates from this powerful shot.]],
	color = colors.RED, image = "object/artifact/star_shot.png",
	proj_image = "object/artifact/shot_s_star_shot.png",
	level_range = {25, 40},
	rarity = 300,
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 20,
		dam = 32,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5},
		damtype = DamageType.FIRE,
		special_on_hit = {desc=_t"sets off a powerful explosion", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=0, radius=3, friendlyfire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.FIREKNOCKBACK, {dist=3, dam=40 + who:getMag()*0.6 + who:getCun()*0.6})
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=tg.radius})
		end},
	},
}

--[[ For now
newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Withered Force", define_as = "WITHERED_STAR",
	unided_name = _t"dark mindstar",
	level_range = {28, 38},
	color=colors.AQUAMARINE,
	rarity = 250,
	desc = [=[A hazy aura emanates from this ancient gem, coated with withering, thorny vines.]=],
	cost = 98,
	require = { stat = { wil=24 }, },
	material_level = 4,
	combat = {
		dam = 16,
		apr = 28,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.MIND,
		convert_damage = {
			[DamageType.DARKNESS] = 30,
		},
		talents_types_mastery = {
			["cursed/gloom"] = 0.2,
			["cursed/darkness"] = 0.2,
		}
	},
	ms_combat = {},
	wielder = {
		combat_mindpower = 14,
		combat_mindcrit = 7,
		inc_damage={
			[DamageType.DARKNESS] 	= 10,
			[DamageType.PHYSICAL]	= 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 4,},
		hate_per_kill = 3,
	},
	max_power = 40, power_regen = 1,
	use_power = { name = _t"switch the weapon between an axe and a mindstar", power = 40,
		use = function(self, who)
		if self.subtype == "mindstar" then
			ms_combat = table.clone(self.combat)
			--self.name	= "Withered Axe"
			if self:isTalentActive (who.T_PSIBLADES) then
				self:forceUseTalent(who.T_PSIBLADES, {ignore_energy=true})
				game.logSeen(who, "%s rejects the inferior psionic blade!", self:getName():capitalize())
			end
			self.desc	= [=[A hazy aura emanates from this dark axe, withering, thorny vines twisting around the handle.]=]
			self.subtype = "waraxe"
			self.image = self.resolvers.image_material("axe", "metal")
			self.moddable_tile = self.resolvers.moddable_tile("axe")
					self:removeAllMOs()
			--Set moddable tile here
			self.combat = nil
			self.combat = {
				talented = "axe", damrange = 1.4, physspeed = 1, sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2},
				no_offhand_penalty = true,
				dam = 34,
				apr = 8,
				physcrit = 7,
				dammod = {str=0.85, wil=0.2},
				damtype = DamageType.PHYSICAL,
				convert_damage = {
					[DamageType.DARKNESS] = 25,
					[DamageType.MIND] = 15,
				},
			}
		else
			--self.name	= "Withered Star"
			self.image = self.resolvers.image_material("mindstar", "nature")
			self.moddable_tile = self.resolvers.moddable_tile("mindstar")
					self:removeAllMOs()
			--Set moddable tile here
			self.desc	= [=[A hazy aura emanates from this ancient gem, coated with withering, thorny vines."]=]
			self.subtype = "mindstar"
			self.combat = nil
			self.combat = table.clone(ms_combat)
		end
		return {id=true, used=true}
		end
	},
}
]]

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Nexus of the Way",
	unided_name = _t"brilliant green mindstar",
	level_range = {38, 50},
	color=colors.AQUAMARINE, image = "object/artifact/nexus_of_the_way.png",
	rarity = 350,
	desc = _t[[The vast psionic force of the Way reverberates through this gemstone. With a single touch, you can sense overwhelming power, and hear countless thoughts.]],
	cost = 280,
	require = { stat = { wil=48 }, },
	material_level = 5,
	combat = {
		dam = 22,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 18,
		combat_mindcrit = 9,
		confusion_immune=0.3,
		inc_damage={
			[DamageType.MIND] 	= 20,
		},
		resists={
			[DamageType.MIND] 	= 20,
		},
		resists_pen={
			[DamageType.MIND] 	= 20,
		},
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 3, },
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_WAYIST, level = 1, power = 60 },
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Yeek" then
			local Talents = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["race/yeek"] = 0.2 })
			self:specialWearAdd({"wielder","combat_mindpower"}, 5)
			self:specialWearAdd({"wielder","combat_mentalresist"}, 15)
			game.logPlayer(who, "#LIGHT_BLUE#You feel the power of the Way within you!")
		end
		if who.descriptor and who.descriptor.race == "Halfling" then
			self:specialWearAdd({"wielder","resists"}, {[engine.DamageType.MIND] = -25,})
			self:specialWearAdd({"wielder","combat_mentalresist"}, -20)
			game.logPlayer(who, "#RED#The Way rejects its former captors!")
		end
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Amethyst of Sanctuary",
	unided_name = _t"deep purple gem",
	level_range = {30, 38},
	color=colors.AQUAMARINE, image = "object/artifact/amethyst_of_sanctuary.png",
	rarity = 250,
	desc = _t[[This bright violet gem exudes a calming, focusing force. Holding it, you feel protected against outside forces.]],
	special_desc = function(self) return _t"Reduce damage from attackers more than 3 tiles away by 25%" end,
	cost = 185,
	require = { stat = { wil=28 }, },
	material_level = 4,
	combat = {
		dam = 15,
		apr = 26,
		physcrit = 6,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 14,
		combat_mindcrit = 7,
		combat_mentalresist = 25,
		max_psi = 20,
		talents_types_mastery = {
			["psionic/focus"] = 0.3,
			["psionic/absorption"] = 0.3,
		},
		resists={
			[DamageType.MIND] 	= 15,
		},
		inc_stats = { [Stats.STAT_WIL] = 8,},
	},
	callbackOnTakeDamage = function(self, who, src, x, y, type, dam, tmp, no_martyr)
		if src and src.x and src.y then
			if core.fov.distance(who.x, who.y, src.x, src.y) > 3 then
				dam = dam * 0.75
			end
		end
		return {dam=dam}
	end,
}

newEntity{ base = "BASE_STAFF", define_as = "SET_SCEPTRE_LICH",
	power_source = {arcane=true},
	unique = true,
	name = "Sceptre of the Archlich",
	flavor_name = "vilestaff",
	unided_name = _t"bone carved sceptre",
	level_range = {35, 50},
	color=colors.VIOLET, image = "object/artifact/sceptre_of_the_archlich.png",
	rarity = 320,
	desc = _t[[This sceptre, carved of ancient, blackened bone, holds a single gem of deep obsidian. You feel a dark power from deep within, looking to get out.]],
	cost = resolvers.rngrange(700,1200),
	material_level = 5,

	require = { stat = { mag=50 }, },
	combat = {
		dam = 40,
		apr = 12,
		dammod = {mag=0.8},
		element = DamageType.DARKNESS,
	},
	wielder = {
		combat_spellpower = 40,
		combat_spellcrit = 15,
		inc_damage={
			[DamageType.DARKNESS] = 35,
		},
		talents_types_mastery = {
			["celestial/star-fury"] = 0.2,
			["spell/master-of-bones"] = 0.2,
			["spell/master-of-flesh"] = 0.2,
			["spell/master-necromancer"] = 0.2,
		}
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Undead" then
			local Talents = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["spell/nightfall"] = 0.2 })
			self:specialWearAdd({"wielder","combat_spellpower"}, 12)
			self:specialWearAdd({"wielder","combat_spellresist"}, 10)
			self:specialWearAdd({"wielder","combat_mentalresist"}, 10)
			self:specialWearAdd({"wielder","max_mana"}, 50)
			self:specialWearAdd({"wielder","mana_regen"}, 0.5)
			self:specialWearAdd({"wielder","negative_regen"}, 0.5)
			game.logPlayer(who, "#LIGHT_BLUE#You feel the power of the sceptre flow over your undead form!")
		end
	end,
	set_list = { {"define_as", "SET_LICH_RING"} },
	set_desc = {
		archlich = _t"It desires to be surrounded by undeath.",
	},
	on_set_complete = function(self, who)
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true, antimagic=true},
	unique = true,
	name = "Oozing Heart",
	unided_name = _t"slimy mindstar",
	level_range = {27, 34},
	color=colors.GREEN, image = "object/artifact/oozing_heart.png",
	rarity = 250,
	desc = _t[[This mindstar oozes a thick, caustic liquid. Magic seems to die around it.]],
	cost = 185,
	require = { stat = { wil=36 }, },
	material_level = 4,
	combat = {
		dam = 17,
		apr = 25,
		physcrit = 7,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.SLIME,
	},
	wielder = {
		combat_mindpower = 12,
		combat_mindcrit = 8,
		combat_spellresist=15,
		inc_damage={
			[DamageType.NATURE] = 18,
			[DamageType.ACID] = 15,
		},
		resists={
			[DamageType.ARCANE] = 12,
			[DamageType.BLIGHT] = 12,
		},
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 2, },
		talents_types_mastery = { ["wild-gift/ooze"] = 0.1, ["wild-gift/slime"] = 0.1,},
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_OOZE_SPIT, level = 2, power = 20 },
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"combat","melee_project"}, {[DamageType.MANABURN]=30})
			game.logPlayer(who, "#DARK_GREEN#The Heart pulses with antimagic forces as you grasp it.")
		end
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	unique = true,
	name = "Bloomsoul",
	unided_name = _t"flower covered mindstar",
	level_range = {10, 20},
	color=colors.GREEN, image = "object/artifact/bloomsoul.png",
	rarity = 180,
	desc = _t[[Pristine flowers coat the surface of this mindstar. Touching it fills you with a sense of calm and refreshes your body.]],
	cost = 40,
	require = { stat = { wil=18 }, },
	material_level = 2,
	combat = {
		dam = 8,
		apr = 13,
		physcrit = 7,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 8,
		combat_mindcrit = 4,
		life_regen = 2,
		healing_factor = 0.2,
		talents_types_mastery = { ["wild-gift/fungus"] = 0.3,},
	},
	max_power = 40, power_regen = 1,
	use_talent = { id = Talents.T_BLOOM_HEAL, level = 1, power = 40 },
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	unique = true,
	name = "Gravitational Staff",
	flavor_name = "starstaff",
	unided_name = _t"heavy staff",
	level_range = {25, 33},
	color=colors.VIOLET, image = "object/artifact/gravitational_staff.png",
	rarity = 240,
	desc = _t[[Time and Space seem to warp and bend around the massive tip of this stave.]],
	cost = resolvers.rngrange(225,350),
	material_level = 3,
	require = { stat = { mag=35 }, },
	combat = {
		dam = 30,
		apr = 8,
		dammod = {mag=0.8},
		damtype = DamageType.GRAVITYPIN,
		element = DamageType.PHYSICAL,
	},
	wielder = {
		combat_spellpower = 25,
		combat_spellcrit = 7,
		inc_damage={
			[DamageType.PHYSICAL] 	= 20,
			[DamageType.TEMPORAL] 	= 10,
		},
		resists={
			[DamageType.PHYSICAL] 	= 15,
		},
		talents_types_mastery = {
			["chronomancy/gravity"] = 0.1,
			["chronomancy/matter"] = 0.1,
			["spell/earth"] = 0.1,
		}
	},
	max_power = 14, power_regen = 1,
	use_talent = { id = Talents.T_GRAVITY_SPIKE, level = 3, power = 14 },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	name = "Eye of the Wyrm", define_as = "EYE_WYRM",
	unided_name = _t"multi-colored mindstar", unique = true,
	desc = _t[[A black iris cuts through the core of this mindstar, which shifts with myriad colours. It darts around, as if searching for something.]],
	special_desc = function(self) return _t"The breath attack has a chance to shift randomly between Fire, Ice, Lightning, Acid, and Sand each turn." end,
	color = colors.BLUE, image = "object/artifact/eye_of_the_wyrm.png",
	level_range = {30, 40},
	require = { stat = { wil=45, }, },
	rarity = 280,
	cost = 230,
	material_level = 4,
	sentient=true,
	combat = {
		dam = 16,
		apr = 24,
		physcrit = 2.5,
		dammod = {wil=0.5, cun=0.1, str=0.2},
		damtype=DamageType.PHYSICAL,
		convert_damage = {
			[DamageType.COLD] = 20,
			[DamageType.FIRE] = 20,
			[DamageType.ACID] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.PHYSICAL] = 20,
		},
	},
	wielder = {
		combat_mindpower = 10,
		combat_dam = 10,
		combat_mindcrit = 5,
		combat_physcrit = 5,
		inc_damage={
			[DamageType.PHYSICAL] 	= 12,
			[DamageType.FIRE] 	= 12,
			[DamageType.COLD] 	= 12,
			[DamageType.LIGHTNING] 	= 12,
			[DamageType.ACID] 	= 12,
		},
		resists={
			[DamageType.PHYSICAL] 	= 10,
			[DamageType.FIRE] 	= 10,
			[DamageType.COLD] 	= 10,
			[DamageType.ACID] 	= 10,
			[DamageType.LIGHTNING] 	= 10,
		},
		talents_types_mastery = {
			["wild-gift/sand-drake"] = 0.3,
			["wild-gift/fire-drake"] = 0.3,
			["wild-gift/cold-drake"] = 0.3,
			["wild-gift/storm-drake"] = 0.3,
			["wild-gift/venom-drake"] = 0.3,
		}
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if not rng.percent(25) then return end
		self.use_talent.id=rng.table{ "T_FIRE_BREATH", "T_ICE_BREATH", "T_LIGHTNING_BREATH", "T_SAND_BREATH", "T_CORROSIVE_BREATH" }
		self.worn_by:check("useObjectEnable", self)
--		game.logSeen(self.worn_by, "#GOLD#The %s shifts colour!", self:getName():capitalize())
	end,
	max_power = 30, power_regen = 1,
	use_talent = { id = rng.table{ Talents.T_FIRE_BREATH, Talents.T_ICE_BREATH, Talents.T_LIGHTNING_BREATH, Talents.T_SAND_BREATH, Talents.T_CORROSIVE_BREATH }, level = 4, power = 30 }
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	name = "Great Caller",
	unided_name = _t"humming mindstar", unique = true, image = "object",
	desc = _t[[This mindstar constantly emits a low tone. Life seems to be pulled towards it.]],
	special_desc = function(self) return _t"Gives a 30% chance that your nature summons appear as wild summons." end,
	color = colors.GREEN,  image = "object/artifact/great_caller.png",
	level_range = {20, 32},
	require = { stat = { wil=34, }, },
	rarity = 250,
	cost = 120,
	material_level = 3,
	combat = {
		dam = 10,
		apr = 18,
		physcrit = 2.5,
		dammod = {wil=0.3, cun=0.5},
		damtype=DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 12,
		combat_mindcrit = 6,
		inc_damage={
			[DamageType.PHYSICAL] 	= 8,
			[DamageType.FIRE] 	= 8,
			[DamageType.COLD] 	= 8,
		},
		talents_types_mastery = {
			["wild-gift/summon-melee"] = 0.1,
			["wild-gift/summon-distance"] = 0.1,
			["wild-gift/summon-augmentation"] = 0.1,
			["wild-gift/summon-utility"] = 0.1,
			["wild-gift/summon-advanced"] = 0.1,
		},
		heal_on_nature_summon = 30,
		wild_summon = 30,
		nature_summon_max = 2,
		inc_stats = { [Stats.STAT_WIL] = 3, [Stats.STAT_CUN] = 3 },
	},
}

newEntity{ base = "BASE_HELM",
	power_source = {arcane=true},
	unique = true,
	name = "Corrupted Gaze", image = "object/artifact/corrupted_gaze.png",
	unided_name = _t"dark visored helm",
	desc = _t[[This helmet radiates a dark power. Its visor seems to twist and corrupt the vision of its wearer. You feel worried that if you were to lower it for long, the visions may affect your mind.]],
	require = { stat = { mag=16 } },
	level_range = {28, 40},
	rarity = 300,
	cost = 300,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_MAG] = 8, [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 8,},
		combat_def = 4,
		combat_armor = 8,
		fatigue = 6,
		resists = { [DamageType.BLIGHT] = 20},
		inc_damage = { [DamageType.BLIGHT] = 20},
		resists_pen = { [DamageType.BLIGHT] = 10},
		disease_immune=0.5,
		talents_types_mastery = { ["corruption/vim"] = 0.3, },
		combat_atk = 10,
		see_invisible = 12,
		see_stealth = 12,
	},
	talent_on_spell = {
		{chance=10, talent=Talents.T_VIMSENSE, level=3},
	},
}

newEntity{ base = "BASE_KNIFE",
	power_source = {arcane=true},
	unique = true,
	name = "Umbral Razor", image = "object/artifact/dagger_umbral_razor.png",
	unided_name = _t"shadowy dagger",
	moddable_tile = "special/%s_dagger_silent_blade",
	moddable_tile_big = true,
	desc = _t[[This dagger seems to be formed of pure shadows, with a strange miasma surrounding it.]],
	level_range = {12, 25},
	rarity = 200,
	require = { stat = { dex=32 }, },
	cost = resolvers.rngrange(125,200),
	material_level = 2,
	combat = {
		dam = 25,
		apr = 10,
		physcrit = 9,
		dammod = {dex=0.45,str=0.45, mag=0.1},
		convert_damage = {
			[DamageType.DARKNESS] = 50,
		},
		special_on_hit = {desc=_t"20% chance to make the target bleed shadows. You heal for 15 whenever you hit an enemy bleeding shadows.", fct=function(combat, who, target)
			if target:canBe("cut") and rng.percent(20) then
				target:setEffect(target.EFF_SHADOW_CUT, 5, {apply_power=math.max(who:combatSpellpower(), who:combatAttack()), src=who, dam=20, heal=15})
			else
				game.logSeen(target, "%s resists the shadowy cut", target:getName():capitalize())
			end
		end},
	},
	wielder = {
		inc_stealth=10,
		inc_stats = {[Stats.STAT_MAG] = 4, [Stats.STAT_CUN] = 4,},
		resists = {[DamageType.DARKNESS] = 10,},
		resists_pen = {[DamageType.DARKNESS] = 10,},
		inc_damage = {[DamageType.DARKNESS] = 5,},
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_INVOKE_DARKNESS, level = 3, power = 20 },
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {technique=true},
	unique = true,
	name = "Emblem of Evasion", color = colors.GOLD,
	unided_name = _t"gold coated emblem", image = "object/artifact/emblem_of_evasion.png",
	desc = _t[[Said to have belonged to a master of avoiding attacks, this gilded steel emblem symbolizes his talent.]],
	level_range = {28, 38},
	rarity = 200,
	cost = 450,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_LCK] = 8, [Stats.STAT_DEX] = 12, [Stats.STAT_CUN] = 10,},
		slow_projectiles = 30,
		combat_def_ranged = 20,
		projectile_evasion = 15,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_EVASION, level = 4, power = 30 },
}

newEntity{ base = "BASE_LONGBOW",
	power_source = {technique=true},
	name = "Surefire", unided_name = _t"high-quality bow", unique=true, image = "object/artifact/surefire.png",
	desc = _t[[This tightly strung bow appears to have been crafted by someone of considerable talent. When you pull the string, you feel incredible power behind it.]],
	level_range = {5, 15},
	rarity = 200,
	require = { stat = { dex=18 }, },
	cost = resolvers.rngrange(50,80),
	material_level = 1,
	combat = {
		range = 9,
		physspeed = 0.95,
	},
	wielder = {
		inc_damage={ [DamageType.PHYSICAL] = 5, },
		inc_stats = { [Stats.STAT_DEX] = 3},
		combat_atk=12,
		combat_physcrit=5,
		apr = 10,
	},
}

newEntity{ base = "BASE_SHOT",
	power_source = {arcane=true},
	unique = true,
	name = "Frozen Shards", image = "object/artifact/frozen_shards.png",
	proj_image = "object/artifact/shot_s_frozen_shards.png",
	unided_name = _t"pouch of crystallized ice",
	desc = _t[[In this dark blue pouch lie several small orbs of ice. A strange vapour surrounds them, and touching them chills you to the bone.]],
	color = colors.BLUE,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 25,
		dam = 32,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5},
		damtype = DamageType.ICE,
		special_on_hit = {desc=_t"bursts into an icy cloud",on_kill=1, fct=function(combat, who, target)
			local duration = 4
			local radius = 1
			local dam = (10 + who:getMag()/5 + who:getDex()/3)
			game.level.map:particleEmitter(target.x, target.y, radius, "iceflash", {radius=radius})
			-- Add a lasting map effect
			game.level.map:addEffect(who,
				target.x, target.y, duration,
				engine.DamageType.ICE, dam,
				radius,
				5, nil,
				{type="ice_vapour"},
				nil,
				false
			)
		end},
	},
}

newEntity{ base = "BASE_WHIP",
	power_source = {arcane=true},
	unided_name = _t"electrified whip",
	name = "Stormlash", color=colors.BLUE, unique = true, image = "object/artifact/stormlash.png",
	desc = _t[[This steel plated whip arcs with intense electricity. The force feels uncontrollable, explosive, powerful.]],
	require = { stat = { dex=15 }, },
	cost = resolvers.rngrange(50,80),
	rarity = 250,
	level_range = {6, 15},
	material_level = 1,
	combat = {
		dam = 17,
		apr = 7,
		physcrit = 5,
		dammod = {dex=1},
		convert_damage = {[DamageType.LIGHTNING_DAZE] = 50,},
		special_on_crit = {desc=_t"Focus the lightning forces on an enemy", fct=function(combat, who, target)
			if rng.percent(25) then
				game.logPlayer(who, "The storm is on your side !")
				target:setEffect(target.EFF_HURRICANE, 5, {src=who, dam=who:getDex()*0.5+who:getMag()*0.5, radius=2 })
			else
				game.logPlayer(who, "The storm betrayed you...")
			end
		end},
	},
	wielder = {
		combat_atk = 7,
		inc_damage={ [DamageType.LIGHTNING] = 10, },
	},
	max_power = 10, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.LIGHTNING, self.use_power.damage(self, who))
			return ("strike an enemy within range %d (for 100%% weapon damage as lightning) and release a radius %d burst of electricity dealing %0.2f to %0.2f lightning damage (based on Magic and Dexterity)"):tformat(self.use_power.range, self.use_power.radius, dam/3, dam)
		end,
		power = 10,
		range = 3,
		radius = 1,
		requires_target = true,
		tactical = {ATTACKAREA = {LIGHTNING = 1.5}, ATTACK = {weapon = 2}},
		damage = function(self, who) return 20 + who:getMag()/2 + who:getDex()/3 end,
		use = function(self, who)
			local dam = self.use_power.damage(self, who)
			local tg = {type="bolt", range=self.use_power.range}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			local target = game.level.map(x, y, engine.Map.ACTOR)
			if not target then return end
			local blast = {type="ball", start_x = target.x, start_y = target.y, range=0, radius=self.use_power.radius, selffire=false}
			who:logCombat(target, "#Source# strikes #Target# with %s %s, sending out an arc of lightning!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			who:attackTarget(target, engine.DamageType.LIGHTNING, 1, true)
			local _ _, x, y = who:canProject(tg, x, y)
			game:playSoundNear(self, "talents/lightning")
			game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(x-who.x), math.abs(y-who.y)), "lightning", {tx=x-who.x, ty=y-who.y})
			who:project(blast, x, y, engine.DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
			game.level.map:particleEmitter(x, y, radius, "ball_lightning", {radius=blast.radius})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_WHIP",
	power_source = {psionic=true},
	unided_name = _t"gemmed whip handle",
	name = "Focus Whip", color=colors.YELLOW, unique = true, image = "object/artifact/focus_whip.png",
	desc = _t[[A small mindstar rests at top of this handle. As you touch it, a translucent cord appears, flicking with your will.]],
	require = { stat = { dex=15 }, },
	cost = resolvers.rngrange(225,350),
	rarity = 250,
	metallic = false,
	level_range = {18, 28},
	material_level = 3,
	combat = {
		dam = 19,
		apr = 7,
		physcrit = 5,
		dammod = {dex=0.7, wil=0.2, cun=0.1},
		wil_attack = true,
		damtype=DamageType.MIND,
		special_on_crit = {desc=_t"Try to fry your enemies brain (25% chance to brainlock)", fct=function(combat, who, target)
			if rng.percent(25) then
				local maxpower = math.max(who:combatAttack(), who:combatMindpower())
				target:crossTierEffect(target.EFF_BRAINLOCKED, maxpower)
			end
		end},
	},
	wielder = {
		combat_mindpower = 10,
		combat_mindcrit = 3,
		talent_on_hit = { [Talents.T_MINDLASH] = {level=1, chance=18} },
	},
	max_power = 10, power_regen = 1,
	use_power = { name = _t"strike all targets in a line (for 100%% weapon damage as mind) out to range 4", power = 10,
		range = 4,
		requires_target = true,
		tactical = {ATTACK = {weapon = 1, mind = 1}},
		use = function(self, who)
			local tg = {type="beam", range=self.use_power.range}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:logCombat(target, "#Source# manifests a psychic assult with %s %s!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				who:attackTarget(target, engine.DamageType.MIND, 1, true)
			end)
			local _ _, x, y = who:canProject(tg, x, y)
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "matter_beam", {tx=x-who.x, ty=y-who.y})
			game:playSoundNear(self, "talents/lightning")
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Latafayn",
	unided_name = _t"flame covered greatsword", image = "object/artifact/latafayn.png",
	level_range = {32, 40},
	color=colors.DARKRED,
	rarity = 300,
	desc = _t[[This massive, flame-coated greatsword was stolen by the adventurer Kestin Highfin, during the Age of Dusk. It originally belonged to a demon named Frond'Ral the Red.  It roars with vile flames and its very existence seems to be a blight upon the lands.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 4,
	combat = {
		dam = 68,
		apr = 5,
		physcrit = 10,
		dammod = {str=1.25},
		convert_damage={[DamageType.FIREBURN] = 50},
		lifesteal = 8, --Won't affect the burn damage, so it gets to have a bit more
	},
	wielder = {
		resists = {
			[DamageType.FIRE] = 15,
		},
		inc_damage = {
			[DamageType.FIRE] = 15,
			[DamageType.DARKNESS] = 10,
		},
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CUN] = 3 },
	},
	max_power = 25, power_regen = 1,
	use_power = { --slightly less obviously Pure's copy of Catalepsy
		name = function(self, who) return ("accelerate burning effects on all creatures in a radius %d ball within range %d, consuming them to instantly inflict 125%% of all remaining burn damage"):tformat(self.use_power.radius(self, who), self.use_power.range(self, who)) end,
		power = 10,
		requires_target = true,
		range = function(self, who) return 5 end,
		radius = function(self, who) return 1 end,
		target = function(self, who) return {type="ball", range=self.use_power.range(self, who), radius=self.use_power.radius(self, who), selffire=false} end,
		tactical = {ATTACK = function(who, t, aitarget)
			local nb = 0
			if aitarget then
				local tg = who:getTalentTarget(t)
				local x, y = who:getTarget(tg)
				who:project(tg, x, y, function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if not target then return end

					local burns = {}
					for eff_id, p in pairs(target.tmp) do
						local e = target.tempeffect_def[eff_id]
						if e.subtype.fire and (p.dur or 0) > 0 and p.power and e.status == "detrimental" then
							nb = nb + 1
						end
					end
				end)
			end
			return nb > 0 and {fire = math.min(5, nb)}
		end},
		use=function(self, who, target)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s's %s lashes out in a flaming arc, intensifying the burning of %s enemies!", who:getName():capitalize(), self:getName({do_color = true, no_add_name = true}), who:his_her())
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end

				-- List all diseases, I mean, burns
				local burns = {}
				for eff_id, p in pairs(target.tmp) do
					local e = target.tempeffect_def[eff_id]
					if e.subtype.fire and p.power and e.status == "detrimental" then
						burns[#burns+1] = {id=eff_id, params=p}
					end
				end
				-- Make them EXPLODE !!!
				for i, d in ipairs(burns) do
					engine.DamageType:get(engine.DamageType.FIRE).projector(who, px, py, engine.DamageType.FIRE, d.params.power * d.params.dur * 1.25)
					target:removeEffect(d.id)
				end
				game.level.map:particleEmitter(target.x, target.y, 1, "ball_fire", {radius=1})
			end)
			game:playSoundNear(who, "talents/fireflash")
			return {id=true, used=true}
		end},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {psionic=true},
	unique = true,
	name = "Robe of Force", color = colors.YELLOW, image = "object/artifact/robe_of_force.png",
	unided_name = _t"rippling cloth robe",
	desc = _t[[This thin cloth robe is surrounded by a pulsating shroud of telekinetic force.]],
	level_range = {20, 28},
	rarity = 190,
	cost = 250,
	material_level = 2,
	wielder = {
		combat_def = 12,
		combat_armor = 8,
		inc_stats = { [Stats.STAT_CUN] = 3, [Stats.STAT_WIL] = 4, },
		combat_mindpower = 8,
		combat_mindcrit = 4,
		combat_physresist = 10,
		inc_damage={[DamageType.PHYSICAL] = 5, [DamageType.MIND] = 5,},
		resists_pen={[DamageType.PHYSICAL] = 10, [DamageType.MIND] = 10,},
		resists={[DamageType.PHYSICAL] = 12, [DamageType.ACID] = 15,},
	},
	max_power = 10, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
			return ("send out a range %d beam of kinetic energy, dealing %0.2f to %0.2f physical damage (based on Willpower and Cunning) with knockback"):tformat(self.use_power.range, 0.8*dam, dam) end,
		power = 10,
		damage = function(self, who) return 15 + who:getWil()/3 + who:getCun()/3 end,
		range =5,
		target = function(self, who) return {type="beam", range=self.use_power.range} end,
		requires_target = true,
		tactical = {ATTACK = {PHYSICAL = 2}, ESCAPE = {knockback = 1.5}},
		use = function(self, who)
			local dam = self.use_power.damage(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s focuses a beam of force from %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			who:project(tg, x, y, engine.DamageType.MINDKNOCKBACK, who:mindCrit(rng.avg(0.8*dam, dam)))
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "matter_beam", {tx=x-who.x, ty=y-who.y})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	unique = true,
	name = "Serpent's Glare", image = "object/artifact/serpents_glare.png",
	unided_name = _t"venomous gemstone",
	level_range = {1, 10},
	color=colors.GREEN,
	rarity = 180,
	desc = _t[[A thick venom drips from this mindstar.]],
	cost = 20,
	require = { stat = { wil=12 }, },
	material_level = 1,
	combat = {
		dam = 7,
		apr = 15,
		physcrit = 7,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.NATURE,
		convert_damage={[DamageType.POISON] = 30,}
	},
	wielder = {
		combat_mindpower = 4,
		combat_mindcrit = 2,
		poison_immune = 0.5,
		resists = {
			[DamageType.NATURE] = 10,
		},
		inc_damage = {
			[DamageType.NATURE] = 10,
		}
	},
	max_power = 8, power_regen = 1,
	use_talent = { id = Talents.T_SPIT_POISON, level = 2, power = 8 },
}

--[=[ seems to generate more bugs than it's worth
newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {psionic=true},
	unique = true,
	name = "The Inner Eye", image = "object/artifact/the_inner_eye.png",
	unided_name = _t"engraved marble eye",
	level_range = {24, 32},
	color=colors.WHITE,
	encumber = 1,
	rarity = 140,
	desc = _t[[This thick blindfold, with an embedded marble eye, is said to allow the wearer to sense beings around them, at the cost of physical sight.
You suspect the effects will require a moment to recover from.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=3,
		esp_range=-3,
		esp_all=1,
		blind=1,
		combat_mindpower=6,
		combat_mindcrit=4,
		blind_immune=1,
		blind_sight=1, -- So we can see walls, objects, and what not nearby and not break auto-explore.
		combat_mentalresist = 12,
		resists = {[DamageType.LIGHT] = 10,},
		resists_cap = {[DamageType.LIGHT] = 10,},
		resists_pen = {all=5, [DamageType.MIND] = 10,}
	},
	on_wear = function(self, who)
		game.logPlayer(who, "#CRIMSON#Your eyesight fades!")
		who:resetCanSeeCache()
		if who.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
	end,
}
]=]

newEntity{ base = "BASE_LONGSWORD", define_as="CORPUS",
	power_source = {unknown=true, technique=true},
	unique = true,
	name = "Corpathus", image = "object/artifact/corpus.png",
	unided_name = _t"bound sword",
	moddable_tile = "special/%s_corpus",
	moddable_tile_big = true,
	desc = _t[[Thick straps encircle this blade. Jagged edges like teeth travel down the blade, bisecting it. It fights to overcome the straps, but lacks the strength.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { str=40, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 40,
		apr = 12,
		physcrit = 4,
		dammod = {str=1,},
		melee_project={[DamageType.DRAINLIFE] = 18},
		special_on_kill = {desc=_t"grows dramatically in power", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "CORPUS")
			if not o or not who:getInven(inven_id).worn then return end
			who:onTakeoff(o, inven_id, true)
			o.combat.physcrit = (o.combat.physcrit or 0) + 2
			o.wielder.combat_critical_power = (o.wielder.combat_critical_power or 0) + 4
			who:onWear(o, inven_id, true)
			if not rng.percent(o.combat.physcrit*0.8) or o.combat.physcrit < 30 then return end
			o.summon(o, who)
		end},
		special_on_crit = {desc=_t"grows in power", on_kill=1, fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "CORPUS")
			if not o or not who:getInven(inven_id).worn then return end
			who:onTakeoff(o, inven_id, true)
			o.combat.physcrit = (o.combat.physcrit or 0) + 1
			o.wielder.combat_critical_power = (o.wielder.combat_critical_power or 0) + 2
			who:onWear(o, inven_id, true)
			if not rng.percent(o.combat.physcrit*0.8) or o.combat.physcrit < 30 then return end
			o.summon(o, who)
		end},
	},
	summon=function(o, who)
		o.cut=nil
		o.combat.physcrit=6
		o.wielder.combat_critical_power = 0
		game.logSeen(who, "Corpathus bursts open, unleashing a horrific mass!")
		local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "horror", subtype = "eldritch",
				display = "h",
				name = _t"Vilespawn", color=colors.GREEN,
				image="npc/horror_eldritch_oozing_horror.png",
				desc = _t"This mass of putrid slime burst from Corpathus, and seems quite hungry.",
				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, },
				rank = 2,
				life_rating = 8, exp_worth = 0,
				life_regen=0,
				max_vim=200,
				max_life = resolvers.rngavg(50,90),
				infravision = 20,
				autolevel = "dexmage",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=2, ally_compassion=0},
				stats = { str=15, dex=18, mag=18, wil=15, con=10, cun=18 },
				level_range = {10, nil}, exp_worth = 0,
				silent_levelup = true,
				combat_armor = 0, combat_def = 24,
				combat = { dam=resolvers.rngavg(10,13), atk=15, apr=15, dammod={mag=0.5, dex=0.5}, damtype=engine.DamageType.BLIGHT, },

				resists = { [engine.DamageType.BLIGHT] = 100, [engine.DamageType.NATURE] = -100, },

				on_melee_hit = {[engine.DamageType.DRAINLIFE]=resolvers.mbonus(10, 30)},
				melee_project = {[engine.DamageType.DRAINLIFE]=resolvers.mbonus(10, 30)},

				resolvers.talents{
					[who.T_DRAIN]={base=1, every=7, max = 10},
					[who.T_SPIT_BLIGHT]={base=1, every=6, max = 9},
					[who.T_VIRULENT_DISEASE]={base=1, every=9, max = 7},
					[who.T_BLOOD_FURY]={base=1, every=8, max = 6},
				},
				resolvers.sustains_at_birth(),
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time = 30,
			}

			m:resolve()

			game.zone:addEntity(game.level, m, "actor", x, y)
			if game.party:hasMember(who) then
				m.remove_from_party_on_death = true
				game.party:addMember(m, {
					control="no",
					temporary_level = true,
					type="minion",
					title=_t"Vilespawn",
				})
			end
	end,
	wielder = {
		inc_damage={[DamageType.BLIGHT] = 5,},
		combat_critical_power = 0,
		cut_immune=-0.25,
		max_vim=20,
	},

}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {unknown=true, psionic=true},
	unique = true,
	name = "Anmalice", image = "object/artifact/anima.png", define_as = "ANIMA",
	unided_name = _t"twisted blade",
	moddable_tile = "special/%s_anmalice",
	moddable_tile_big = true,
	desc = _t[[The eye on the hilt of this blade seems to glare at you, piercing your soul and mind. Tentacles surround the hilt, latching onto your hand.]],
	level_range = {30, 40},
	rarity = 250,
	require = { stat = { str=32, wil=20, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 47,
		apr = 20,
		physcrit = 7,
		dammod = {str=1,wil=0.1},
		damage_convert = {[DamageType.MIND]=20,},
		special_on_hit = {desc=_t"torments the target with many mental effects", fct=function(combat, who, target)
			if not who:checkHit(who:combatMindpower(), target:combatMentalResist()*0.9) then return end
			target:setEffect(target.EFF_WEAKENED_MIND, 2, {power=0, save=20})
			if not rng.percent(40) then return end
			local eff = rng.table{"stun", "malign", "agony", "confusion", "silence",}
			if not target:canBe(eff) then return end
			if not who:checkHit(who:combatMindpower(), target:combatMentalResist()) then return end
			if eff == "stun" then target:setEffect(target.EFF_MADNESS_STUNNED, 3, {mindResistChange=-25})
			elseif eff == "malign" then target:setEffect(target.EFF_MALIGNED, 3, {resistAllChange=10})
			elseif eff == "agony" then target:setEffect(target.EFF_AGONY, 5, { src=who, damage=40, mindpower=40, range=10, minPercent=10, duration=5})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 3, {power=50})
			elseif eff == "silence" then target:setEffect(target.EFF_SILENCED, 3, {})
			end
		end},
		special_on_kill = {desc=_t"reduces mental save penalty", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "ANIMA")
			if not o or not who:getInven(inven_id).worn then return end
			if o.wielder.combat_mentalresist >= 0 then return end
			o.skipfunct=1
			who:onTakeoff(o, inven_id, true)
			o.wielder.combat_mentalresist = (o.wielder.combat_mentalresist or 0) + 2
			who:onWear(o, inven_id, true)
			o.skipfunct=nil
		end},
	},
	wielder = {
		combat_mindpower=9,
		combat_mentalresist=-30,
		inc_damage={
			[DamageType.MIND] = 8,
		},
	},
	sentient=true,
	act = function(self)
		self:useEnergy()
		if not self.worn_by then return end
		local _, item, inven_id = self.worn_by:findInAllInventoriesByObject(self)
		if not item or not self.worn_by:getInven(inven_id).worn then self.worn_by = nil return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
			local blast = {type="ball", range=0, radius=2, selffire=false}
			who:project(blast, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if not rng.percent(20) then return end
				target:setEffect(target.EFF_WEAKENED_MIND, 2, {power=0, save=5})
				who:logCombat(target, "Anmalice focuses its mind-piercing eye on #Target#!")
			end)
	end,
	on_takeoff = function(self, who)
		if self.skipfunct then return end
		self.worn_by=nil
		who:removeParticles(self.particle)
		if self.wielder.combat_mentalresist == 0 then
			game.logPlayer(who, "#CRIMSON#The tentacles release your arm, sated.")
		else
			game.logPlayer(who, "#CRIMSON#As you tear the tentacles from your arm, horrible images enter your mind!")
			who:setEffect(who.EFF_WEAKENED_MIND, 15, {power=0, save=25})
			who:setEffect(who.EFF_AGONY, 5, { src=who, damage=15, mindpower=40, range=10, minPercent=10, duration=5})
		end
		self.wielder.combat_mentalresist = -30
	end,
	on_wear = function(self, who)
		if self.skipfunct then return end
		self.particle = who:addParticles(engine.Particles.new("gloom", 1))
		self.worn_by = who
		game.logPlayer(who, "#CRIMSON#As you wield the sword, the tentacles on its hilt wrap around your arm. You feel the sword's will invading your mind!")
	end,
}

newEntity{ base = "BASE_LONGSWORD", define_as="MORRIGOR",
	power_source = {arcane=true, unknown=true},
	unique = true, sentient = true,
	name = "Morrigor", image = "object/artifact/morrigor.png",
	moddable_tile = "special/%s_morrigor",
	moddable_tile_big = true,
	unided_name = _t"jagged, segmented, sword",
	desc = _t[[This heavy, ridged blade emanates magical power, yet as you grasp the handle an icy chill runs its course through your spine. You feel the disembodied presence of all those slain by it. In unison, they demand company.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { mag=40, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 50,
		apr = 12,
		physcrit = 7,
		dammod = {str=0.6, mag=0.6},
		special_on_hit = {desc=function(self, who, special)
				local dam = special.damage(self, who)
				return ("deal %0.2f arcane and %0.2f darkness damage (based on Magic) in a radius 1 around the target"):tformat(who:damDesc(engine.DamageType.ARCANE, dam), who:damDesc(engine.DamageType.DARKNESS, dam))
			end,
			damage = function(self, who) return who:getMag()*0.5 end,
			fct=function(combat, who, target, dam, special)
				local tg = {type="ball", range=1, radius=0, selffire=false}
				local damage = special.damage(self, who)
				who:project(tg, target.x, target.y, engine.DamageType.ARCANE, damage)
				who:project(tg, target.x, target.y, engine.DamageType.DARKNESS, damage)
			end},
		special_on_kill = {desc=_t"swallows the victim's soul, gaining a new power", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "MORRIGOR")
			if o.use_talent then return end
			local got_talent = false
			local tids = {}
			for tid, _ in pairs(target.talents) do
				local t = target:getTalentFromId(tid)
				if t.mode == "activated" and not t.uber and not t.on_pre_use and not t.no_npc_use and not t.is_object_use and not t.hide and not t.is_nature and not t.type[1]:find("/other") and not t.type[1]:find("horror") and not t.type[1]:find("race/") and not t.type[1]:find("inscriptions/") and t.id ~= who.T_HIDE_IN_PLAIN_SIGHT then
					tids[#tids+1] = tid
					got_talent = true
				end
			end
			if got_talent == true then
				local get_talent = rng.table(tids)
				local t = target:getTalentFromId(get_talent)
				o.use_talent = {}
				o.use_talent.id = t.id
				o.use_talent.level = 3
				get_talent = target.talents[t.id]
				target.talents[t.id] = o.use_talent.level
				o.use_talent.power = (target:getTalentCooldown(t, true) or 5)
				target.talents[t.id] = get_talent
				o.use_talent.name = ((t.display_entity and t.display_entity:getDisplayString() or "")..t.name):toString()
				o.use_talent.message = ("@Source@ taps the #SALMON#trapped soul#LAST# of %s, xmanifesting %s!"):tformat(target:getName(), o.use_talent.name)
				o.power = 1
				o.max_power = o.use_talent.power
				o.power_regen = 1
				game.logSeen(who, "%s's %s #SALMON#CONSUMES THE SOUL#LAST# of %s, gaining the power of %s!", who:getName():capitalize(), o:getName({no_add_name = true, do_color = true}), target:getName(), o.use_talent.name)
				who:check("useObjectEnable", o, inven_id, item)
			end
	end},
	},
	wielder = {
		combat_spellpower=24,
		combat_spellcrit=12,
		learn_talent = { [Talents.T_SOUL_PURGE] = 1, },
	},
}

-- cathtifacts : breath damage are ridiculously low, put them to TL3 and buffed stat mod. Multi-hit when fighting several things at once isn't good enough to warrant how bad this weapon is
newEntity{ base = "BASE_WHIP", define_as = "HYDRA_BITE",
	slot_forbid = "OFFHAND",
	offslot = false,
	twohanded=true,
	power_source = {technique=true, nature=true},
	unique = true,
	name = "Hydra's Bite", color = colors.LIGHT_RED, image = "object/artifact/hydras_bite.png",
	unided_name = _t"triple headed flail",
	desc = _t[[This three-headed stralite flail strikes with the power of a hydra. With each attack it lashes out, hitting everyone around you.]],
	level_range = {32, 40},
	rarity = 250,
	require = { stat = { str=40 }, },
	cost = 650,
	material_level = 4,
	running = 0, --For the on hit
	combat = {
		dam = 56,
		apr = 7,
		physcrit = 14,
		dammod = {str=0.9, dex=0.4},
		talent_on_hit = { [Talents.T_LIGHTNING_BREATH_HYDRA] = {level=3, chance=10}, [Talents.T_ACID_BREATH] = {level=3, chance=10}, [Talents.T_POISON_BREATH] = {level=3, chance=10} },
		--convert_damage = {[DamageType.NATURE]=25,[DamageType.ACID]=25,[DamageType.LIGHTNING]=25},
		special_on_hit = {desc=_t"hit up to two adjacent enemies",on_kill=1, fct=function(combat, who, target)
				local o, item, inven_id = who:findInAllInventoriesBy("define_as", "HYDRA_BITE")
				if not o or not who:getInven(inven_id).worn then return end
				local tgts = {}
				local twohits=1
				for _, c in pairs(util.adjacentCoords(who.x, who.y)) do
				local targ = game.level.map(c[1], c[2], engine.Map.ACTOR)
				if targ and targ ~= target and who:reactionToward(target) < 0 then tgts[#tgts+1] = targ end
				end
				if #tgts == 0 then return end
					local target1 = rng.table(tgts)
					local target2 = rng.table(tgts)
					local tries = 0
				while target1 == target2 and tries < 100 do
					local target2 = rng.table(tgts)
					tries = tries + 1
				end
				if o.running == 1 then return end
				o.running = 1
				if tries >= 100 or #tgts==1 then twohits=nil end
				if twohits then
					who:logCombat(target1, "#Source#'s three headed flail lashes at #Target#%s!",who:canSee(target2) and (" and %s"):tformat(target2.name:capitalize()) or "")
				else
					who:logCombat(target1, "#Source#'s three headed flail lashes at #Target#!")
				end
				who:attackTarget(target1, engine.DamageType.PHYSICAL, 0.4,  true)
				if twohits then who:attackTarget(target2, engine.DamageType.PHYSICAL, 0.4,  true) end
				o.running=0
		end},
	},
	wielder = {
		inc_damage={[DamageType.NATURE]=12, [DamageType.ACID]=12, [DamageType.LIGHTNING]=12,},

	},
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {technique=true, antimagic=true},
	define_as = "GAUNTLETS_SPELLHUNT",
	unique = true,
	name = "Spellhunt Remnants", color = colors.GREY, image = "object/artifact/spellhunt_remnants.png",
	unided_name = _t"heavily corroded voratun gauntlets",
	desc = _t[[These once brilliant voratun gauntlets have fallen into a deep decay. Originally used in the spellhunt, they were often used to destroy arcane artifacts, curing the world of their influence.]],
	special_desc = function(self) return _t"Can't be worn by those with arcane powers." end,
--	material_level = 1, --Special: this artifact can appear anywhere and adjusts its material level to the zone
	level_range = {1, nil},
	rarity = 550, -- Extra rare to make it not ALWAYS appear.
	addedToLevel = function(self, level, x, y) -- generated on a level
		local mat_level = util.getval(game.zone.min_material_level) or 1
		if mat_level == 1 then
			self.material_level = 1
		else
			self.power_up(self, nil, mat_level)
		end
	end,
	on_canwear = function(self, who)
		if who:attr("has_arcane_knowledge") then
			game.logPlayer(who, "#ORCHID#Your arcane equipment or powers conflict with the gauntlets!#LAST#", self:getName({do_color=true}))
			return true
		end
	end,
	on_preaddobject = function(self, who, inven) -- generated in an actor's inventory
		if not self.material_level then self.addedToLevel(self, game.level) end
	end,
	cost = 450,
	wielder = {
		combat_mindpower=4,
		combat_mindcrit=3,
		combat_spellresist=4,
		combat_def=1,
		combat_armor=2,
		inc_stats = { [Stats.STAT_CUN] = 2, [Stats.STAT_WIL] = 2, },
		inc_damage = { [DamageType.NATURE] = 5 },
		resists_pen = { [DamageType.NATURE] = 5 },
		max_life = 20,
		combat = {
			dam = 12,
			apr = 4,
			physcrit = 3,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4,},
			damrange = 0.3,
			melee_project={[DamageType.RANDOM_SILENCE] = 10},
			talent_on_hit = {  },
		},
	},
	power_up= function(self, who, level)
		local Stats = require "engine.interface.ActorStats"
		local Talents = require "engine.interface.ActorTalents"
		local DamageType = require "engine.DamageType"
		local _, _, inven_id = who and who:findInAllInventoriesByObject(self)
		if who then who:onTakeoff(self, inven_id, true) end
		self.wielder=nil
		self.wielded=nil
		self.material_level = level
		if level == 2 then -- LEVEL 2
		self.unided_name = _t"corroded voratun gauntlets"
		self.desc = _t[[These once brilliant voratun gauntlets appear heavily decayed. Originally used in the spellhunt, they were often used to destroy arcane artifacts, ridding the world of their influence.]]
		self.wielder={
			combat_mindpower=6,
			combat_mindcrit=6,
			combat_spellresist=6,
			combat_def=2,
			combat_armor=3,
			inc_stats = { [Stats.STAT_CUN] = 4, [Stats.STAT_WIL] = 4, },
			inc_damage = { [DamageType.NATURE] = 10 },
			resists_pen = { [DamageType.NATURE] = 10 },
			max_life = 40,
			combat = {
				dam = 17,
				apr = 8,
				physcrit = 6,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 12},
				talent_on_hit = { },
			},
		}
		elseif level == 3 then -- LEVEL 3
		self.unided_name = _t"tarnished voratun gauntlets"
		self.desc = _t[[These voratun gauntlets appear to have suffered considerable damage. Originally used in the spellhunt, they were often used to destroy arcane artifacts, ridding the world of their influence.]]
		self.wielder={
			combat_mindpower=8,
			combat_mindcrit=9,
			combat_spellresist=8,
			combat_def=3,
			combat_armor=4,
			inc_stats = { [Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 6, },
			inc_damage = { [DamageType.NATURE] = 15 },
			resists_pen = { [DamageType.NATURE] = 15 },
			max_life = 60,
			combat = {
				dam = 22,
				apr = 12,
				physcrit = 8,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 15, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 20,},
				talent_on_hit = { [Talents.T_MANA_CLASH] = {level=1, chance=5} },
			},
		}
		elseif level == 4 then -- LEVEL 4
		self.unided_name = _t"slightly tarnished voratun gauntlets"
		self.desc = _t[[These voratun gauntlets shine brightly beneath a thin layer of wear. Originally used in the spellhunt, they were often used to destroy arcane artifacts, ridding the world of their influence.]]
		self.wielder={
			combat_mindpower=10,
			combat_mindcrit=12,
			combat_spellresist=10,
			combat_def=4,
			combat_armor=5,
			inc_stats = { [Stats.STAT_CUN] = 8, [Stats.STAT_WIL] = 8, },
			inc_damage = { [DamageType.NATURE] = 20 },
			resists_pen = { [DamageType.NATURE] = 20 },
			max_life = 80,
			combat = {
				dam = 27,
				apr = 15,
				physcrit = 10,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 17, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 35,},
				talent_on_hit = { [Talents.T_MANA_CLASH] = {level=2, chance=10} },
			},
		}
		elseif level >= 5 then -- LEVEL 5
		self.unided_name = _t"gleaming voratun gauntlets"
		self.desc = _t[[These brilliant voratun gauntlets shine with an almost otherworldly glow. Originally used in the spellhunt, they were often used to destroy arcane artifacts, ridding the world of their influence. Pride in the fulfillment of this ancient duty practically radiates from them.]]
		self.wielder={
			combat_mindpower=12,
			combat_mindcrit=15,
			combat_spellresist=15,
			combat_def=6,
			combat_armor=8,
			inc_stats = { [Stats.STAT_CUN] = 10, [Stats.STAT_WIL] = 10, },
			inc_damage = { [DamageType.NATURE] = 25 },
			resists_pen = { [DamageType.NATURE] = 25 },
			max_life = 100,
			lite=1,
			combat = {
				dam = 33,
				apr = 18,
				physcrit = 12,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 20, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 50,},
				talent_on_hit = { [Talents.T_MANA_CLASH] = {level=3, chance=15}, [Talents.T_AURA_OF_SILENCE] = {level=3, chance=15} },
			},
		}
		self.use_power = {
			name = function(self, who)
				dam = who:damDesc(engine.DamageType.ARCANE, self.use_power.unnaturaldam(self, who))
				return ("attempt to destroy all magic effects and sustains on creatures in a radius %d cone (unnatural creatures are additionally dealt %0.2f arcane damage and stunned)"):tformat(self.use_power.radius, dam)
			end,
			power = 100,
			unnaturaldam = function(self, who) return 100+who:combatMindpower() end,
			radius = 5,
			range = 0,
			requires_target = true,
			target = function(self, who) return {type="cone", range=self.use_power.range, radius=self.use_power.radius} end,
			tactical = { ATTACK = function(self, t, aitarget)
					if aitarget.undead or aitarget.construct then return {arcane = 2} end
				end,
				DISABLE = function(self, t, aitarget)
					local base = (aitarget.undead or aitarget.construct) and 2 or 0
					local nb = 0
					for eff_id, p in pairs(aitarget.tmp) do
						local e = self.tempeffect_def[eff_id]
						if e.type == "magical" and e.status == "beneficial" then nb = nb + 1 end
					end
					for tid, act in pairs(aitarget.sustain_talents) do
						if act then
							local talent = aitarget:getTalentFromId(tid)
							if talent.is_spell then nb = nb + 1 end
						end
					end
					local ef = aitarget:hasEffect(aitarget.EFF_SPELL_DISRUPTION)
					if not ef or rng.percent(100-(ef.power or 0)) then
						for tid, lev in pairs(aitarget.talents) do
							local t = aitarget.talents_def[tid]
							if t.is_spell then nb = nb + 0.5 end
						end
					end
					return base + nb^0.5
				end},
			use= function(self,who)
				local tg = self.use_power.target(self, who)
				local x, y = who:getTarget(tg)
				if not x or not y then return nil end
				game.logSeen(who, "%s unleashes antimagic forces from %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
				who:project(tg, x, y, function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if not target then return end
					target:setEffect(target.EFF_SPELL_DISRUPTION, 10, {src=who, power = 50, max = 75, apply_power=who:combatMindpower()})
					for i = 1, 2 do
						local effs = {}
						-- Go through all spell effects
						for eff_id, p in pairs(target.tmp) do
							local e = target.tempeffect_def[eff_id]
							if e.type == "magical" then
								effs[#effs+1] = {"effect", eff_id}
							end
						end
						-- Go through all sustained spells
						for tid, act in pairs(target.sustain_talents) do
							if act then
								local talent = target:getTalentFromId(tid)
								if talent.is_spell then effs[#effs+1] = {"talent", tid} end
							end
						end
						local eff = rng.tableRemove(effs)
						if eff then
							target:dispel(eff[2], who)
						end
					end
					if target.undead or target.construct then
						game.logSeen(target, "%s's animating magic is disrupted by the burst of power!", target:getName():capitalize())
						who:project({type="hit"}, target.x, target.y, engine.DamageType.ARCANE, self.use_power.unnaturaldam(self, who))
						if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, 10, {apply_power=who:combatMindpower()}) end
					end
				end, nil, {type="slime"})
				game:playSoundNear(who, "talents/breath")
				return {id=true, used=true}
			end}
		end
		if who then
			who:onWear(self, inven_id, true)
			who:useObjectEnable(self, inven_id)
		end
	end,
	max_power = 150, power_regen = 1,
	use_power = {
	name = _t"destroy an arcane item (of a higher tier than the gauntlets)", power = 1,
	no_npc_use = true,
	use = function(self, who, obj_inven, obj_item)
		if self.tinker then
			game.log("#LIGHT_RED#You can not do that with a tinker attached. Remove it first.")
			return
		end

		local d = who:showInventory(_t"Destroy which item?", who:getInven("INVEN"), function(o) return o.unique and o.power_source and o.power_source.arcane and o.power_source.arcane and o.power_source.arcane == true and o.material_level and o.material_level > self.material_level end, function(o, item, inven)
			if o.material_level <= self.material_level then return end
			self.material_level=self.material_level + 1
			game.logPlayer(who, "You crush the %s, and the gloves take on an illustrious shine!", o:getName{do_color=true})

			if not o then return end
			who:removeObject(who:getInven("INVEN"), item)
			who:sortInven(who:getInven("INVEN"))

			self.power_up(self, who, self.material_level)

			who.changed=true
		end)
	end },
}

newEntity{ base = "BASE_LONGBOW",
	power_source = {arcane=true},
	name = "Merkul's Second Eye", unided_name = _t"sleek stringed bow", unique=true, image = "object/artifact/merkuls_second_eye.png",
	desc = _t[[This bow is said to have been the tool of an infamous dwarven spy. Rumours say it allowed him to "steal" the eyes of his enemies. Adversaries struck were left alive, only to unknowingly divulge their secrets to his unwavering sight.]],
	level_range = {20, 38},
	rarity = 250,
	require = { stat = { dex=24 }, },
	cost = 200,
	material_level = 3,
	combat = {
		range = 9,
		travel_speed = 4,
		talent_on_hit = { [Talents.T_ARCANE_EYE] = {level=4, chance=100} },
	},
	wielder = {
		lite = 2,
		ranged_project = {[DamageType.ARCANE] = 25},
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true},
	unique = true,
	name = "Summertide",
	unided_name = _t"shining gold shield", image = "object/artifact/summertide.png",
	moddable_tile = "special/%s_hand_summertide", moddable_tile_big = true,
	level_range = {38, 50},
	color=colors.GOLD,
	rarity = 350,
	desc = _t[[A bright light shines from the center of this shield. Holding it clears your mind.]],
	cost = 280,
	require = { stat = { wil=28, str=20, }, },
	material_level = 5,
	special_combat = {
		dam = 52,
		block = 260,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.LIGHT,
		special_on_hit = {desc=_t"releases a burst of light", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=0, radius=1, selffire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.LITE_LIGHT, 30 + who:getWil()*0.5)
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_light", {radius=tg.radius})
		end},
		melee_project = {[DamageType.ITEM_LIGHT_BLIND]=30},
	},
	wielder = {
		combat_armor = 15,
		combat_def = 17,
		combat_def_ranged = 17,
		fatigue = 12,
		combat_mindpower = 8,
		combat_mentalresist=18,
		blind_immune=1,
		confusion_immune=0.25,
		lite=3,
		max_psi=20,
		inc_damage={
			[DamageType.MIND] 	= 15,
			[DamageType.LIGHT] 	= 15,
			[DamageType.FIRE] 	= 10,
		},
		resists={
			[DamageType.LIGHT] 		= 20,
			[DamageType.DARKNESS] 	= 15,
			[DamageType.MIND] 		= 12,
			[DamageType.FIRE] 		= 10,
		},
		resists_pen={
			[DamageType.LIGHT] 	= 10,
			[DamageType.MIND] 	= 10,
			[DamageType.FIRE] 	= 10,
		},
		learn_talent = { [Talents.T_BLOCK] = 1, },
		inc_stats = { [Stats.STAT_WIL] = 5, [Stats.STAT_CUN] = 3, },
	},
	max_power = 30, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.LIGHT, self.use_power.damage(self, who))
			return ("send out a range %d beam, lighting its path and dealing %0.2f to %0.2f light damage (based on Willpower and Cunning)"):tformat(self.use_power.range, 0.8*dam, dam)
		end,
		power = 12,
		damage = function(self, who) return 20 + who:getWil()/3 + who:getCun()/3 end,
		range = 7,
		target = function(self, who) return {type="beam", range=self.use_power.range} end,
		tactical = {ATTACK = {LIGHT = 2}},
		requires_target = true,
		use = function(self, who)
			local dam = self.use_power.damage(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s's %s flashes!", who:getName():capitalize(), self:getName({do_color = true, no_add_name = true}))
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "light_beam", {tx=x-who.x, ty=y-who.y})
			who:project(tg, x, y, engine.DamageType.LITE_LIGHT, who:mindCrit(rng.avg(0.8*dam, dam)))
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {psionic=true},
	unique = true,
	name = "Wanderer's Rest", image = "object/artifact/wanderers_rest.png",--Thanks Grayswandir! (just for the name this time!)
	unided_name = _t"weightless boots",
	desc = _t[[These boots feel nearly completely weightless. Touching them, you feel an enormous burden lifted from you.]],
	encumber=0,
	color = colors.YELLOW,
	level_range = {17, 28},
	rarity = 200,
	cost = 100,
	material_level = 3,
	wielder = {
		combat_def = 4,
		fatigue = -10,
		mindpower=4,
		inc_stats = { [Stats.STAT_DEX] = 3, },
		movement_speed=0.10,
		pin_immune=1,
		resists={
			[DamageType.PHYSICAL] = 5,
		},
		talents_types_mastery = {
			["psionic/augmented-mobility"] = 0.2,
		},
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_TELEKINETIC_LEAP, level = 3, power = 20 },
}

newEntity{ base = "BASE_CLOTH_ARMOR", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Silk Current", color = colors.BLUE, image = "object/artifact/silk_current.png",
	unided_name = _t"flowing robe",
	desc = _t[[This deep blue robe flows and ripples as if pushed by an invisible tide.]],
	level_range = {1, 15},
	rarity = 220,
	cost = resolvers.rngrange(50,80),
	material_level = 1,
	wielder = {
		combat_def = 12,
		combat_spellpower = 5,

		inc_damage={[DamageType.COLD] = 10},
		resists={[DamageType.COLD] = 15},
		resists_pen={[DamageType.COLD] = 8},
		on_melee_hit={[DamageType.COLD] = 10,},

		movement_speed=0.15,
		talents_types_mastery = {
			["spell/water"] = 0.3,
			["spell/ice"] = 0.3,
			["spell/frost-alchemy"] = 0.3, --more!
			["spell/grave"] = 0.3, --more!
			["spell/glacial-waste"] = 0.3, --more!
			["spell/rime-wraith"] = 0.3, --more!
 		},
	},
	talent_on_spell = {
		{chance=5, talent=Talents.T_WATER_JET, level=1},
	},
}

newEntity{ base = "BASE_WHIP", --Thanks Grayswandir!
	power_source = {arcane=true},
	unided_name = _t"bone-link chain",
	name = "Skeletal Claw", color=colors.GREEN, unique = true, image = "object/artifact/skeletal_claw.png",
	desc = _t[[This whip appears to have been made from a human spine. A handle sits on one end, a sharply honed claw on the other.]],
	require = { stat = { dex=14 }, },
	cost = 150,
	rarity = 325,
	level_range = {40, 50},
	metallic = false,
	material_level = 5,
	combat = {
		dam = 55,
		apr = 8,
		physcrit = 9,
		dammod = {dex=1},
		melee_project={[DamageType.BLEED] = 30},
		burst_on_crit = {
			[DamageType.BLEED] = 50,
		},
		talent_on_hit = { [Talents.T_BONE_GRAB] = {level=3, chance=10}, [Talents.T_BONE_SPEAR] = {level=4, chance=20} },

	},
	wielder = {
		combat_def = 12,
		combat_spellpower = 4,
		combat_physspeed = 0.1,
		talents_types_mastery = { ["corruption/bone"] = 0.25, },
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_BONE_NOVA, level = 4, power = 20 },
	talent_on_spell = { {chance=10, talent=Talents.T_BONE_SPEAR, level=4} },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Core of the Forge", image = "object/artifact/core_of_the_forge.png",
	unided_name = _t"fiery mindstar",
	level_range = {38, 50},
	color=colors.RED,
	rarity = 350,
	desc = _t[[This blazing hot mindstar beats rhythmically, releasing a burst of heat with each strike.]],
	cost = 280,
	require = { stat = { wil=40 }, },
	material_level = 5,
	combat = {
		dam = 24,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.DREAMFORGE,
	},
	wielder = {
		combat_mindpower = 16,
		combat_mindcrit = 8,
		combat_atk=10,
		combat_dam=10,
		inc_damage={
			[DamageType.MIND] 		= 10,
			[DamageType.PHYSICAL] 	= 10,
			[DamageType.FIRE] 		= 10,
		},
		resists={
			[DamageType.MIND] 		= 5,
			[DamageType.PHYSICAL] 	= 5,
			[DamageType.FIRE] 		= 15,
		},
		resists_pen={
			[DamageType.MIND] 		= 10,
			[DamageType.PHYSICAL] 	= 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 4, },
		talents_types_mastery = {
			["psionic/dream-forge"] = 0.2,
			["psionic/dream-smith"] = 0.2,
		},
		melee_project={[DamageType.DREAMFORGE] = 30,},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_FORGE_BELLOWS, level = 3, power = 24 },
}

newEntity{ base = "BASE_LEATHER_BOOT", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true, define_as = "AETHERWALK",
	name = "Aetherwalk", image = "object/artifact/aether_walk.png",
	moddable_tile = "special/aether_walk",
	unided_name = _t"ethereal boots",
	desc = _t[[A wispy purple aura surrounds these translucent black boots.]],
	color = colors.PURPLE,
	level_range = {30, 40},
	rarity = 200,
	cost = 100,
	material_level = 4,
	callbackOnTeleport = function(self, who, teleported, ox, oy, x, y) game.level.map:particleEmitter(who.x, who.y, 3, "generic_sploom", {rm=150, rM=180, gm=20, gM=60, bm=180, bM=200, am=80, aM=150, radius=3, basenb=120})
		local damage = who:combatStatScale("mag", 50, 250) -- Generous because scaling Arcane is hard and its not exactly easy to proc this .. I think
		who:project({type="ball", range=0, radius=3, friendlyfire=false}, who.x, who.y, engine.DamageType.ARCANE, who:spellCrit(damage))
	end,
	special_desc = function(self, who) return ("Creates an arcane explosion dealing %d arcane damage based on magic in a radius of 3 around the user after any teleport."):tformat(who:combatStatScale("mag", 50, 250)) end,
	wielder = {
		combat_def = 6,
		fatigue = 1,
		combat_spellpower=15,
		resist_all_on_teleport = 20,
		defense_on_teleport = 20,
		effect_reduction_on_teleport = 20,
		inc_stats = { [Stats.STAT_MAG] = 8, [Stats.STAT_CUN] = 8,},
		resists={
			[DamageType.ARCANE] = 25,
		},
		inc_damage={
			[DamageType.ARCANE] = 25,
		},
	},
	max_power = 24, power_regen = 1,
	use_power = { name = _t"phase door up to range 6, within radius 2 of the target location", power = 24,
		tactical = {ESCAPE = 2, CLOSEIN = 1.5},
		on_pre_use = function(self, who, silent, fake) return not who:attr("encased_in_ice") and not who:attr("cant_teleport") end,
		use = function(self, who)
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=6, radius=2, requires_knowledge=false,
			grid_params = {want_range = (not who.ai_target.actor or who.ai_state.tactic == "escape") and 6 or 1	}
			}
			local tx, ty = who:getTarget(tg)
			if not tx or not ty or core.fov.distance(who.x, who.y, tx, ty) <=1 then return nil end

			local _ _, x, y = who:canProject(tg, tx, ty)
			if not x or not y then return {id=true} end

			local rad = 2
			game.logSeen(who, "%s is #PURPLE#ENVELOPED#LAST# in a deep purple aura from %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.level.map:particleEmitter(who.x, who.y, 1, "teleport")
			who:teleportRandom(x, y, rad)
			game.level.map:particleEmitter(who.x, who.y, 1, "teleport")

			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GREATSWORD", -- Thanks Alex!
	power_source = {arcane=true},
	unique = true,
	name = "Colaryem",
	unided_name = _t"floating sword", image = "object/artifact/colaryem.png",
	level_range = {16, 36},
	color=colors.BLUE,
	rarity = 300,
	desc = _t[[This intricate blade is impractically long and almost as wide as your body, yet contrary to its size and apparent girth it is not only light, but threatens to escape your grasp and fly away. You will need to be really strong to keep it grounded. Or really big.]],
	cost = 400,
	require = { stat = { str=10 }, },
	sentient=true,
	material_level = 3,
	special_desc = function(self) return _t"Attack speed improves with your strength and size category." end,
	combat = {
		dam = 48,
		apr = 12,
		physcrit = 11,
		dammod = {str=1.3},
		physspeed=1.8,
	},
	wielder = {
		resists = { [DamageType.LIGHTNING] = 7 },
		inc_damage = { [DamageType.LIGHTNING] = 7, },
		movement_speed = 0.1,
		inc_stats = { [Stats.STAT_DEX] = 7 },
		max_encumber = 50,
		fatigue = -12,
		avoid_pressure_traps = 1,
	},
	act = function(self)
		self:useEnergy()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end

		local size = self.worn_by.size_category-3
		local str = self.worn_by:getStr()
		self.combat.physspeed=util.bound(1.8-(str-10)*0.02-size*0.1, 0.80, 1.8)
	end,
	on_wear = function(self, who)
		self.worn_by = who

		local size = self.worn_by.size_category-3
		local str = self.worn_by:getStr()
		self.combat.physspeed=util.bound(1.8-(str-10)*0.02-size*0.1, 0.80, 1.8)
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
		self.combat.physspeed=2
	end,
}

newEntity{ base = "BASE_ARROW", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Void Quiver",
	unided_name = _t"ethereal quiver",
	desc = _t[[An endless supply of arrows lay within this deep black quiver. Tiny white lights dot its surface.]],
	color = colors.BLUE, image = "object/artifact/void_quiver.png",
	proj_image = "object/artifact/arrow_s_void_quiver.png",
	level_range = {35, 50},
	rarity = 300,
	cost = resolvers.rngrange(700,1100),
	material_level = 5,
	infinite=true,
	require = { stat = { dex=32 }, },
	combat = {
		capacity = 0,
		dam = 45,
		apr = 120, --No armor can stop the void
		physcrit = 6,
		dammod = {dex=0.7, str=0.5, mag=0.4,},
		damtype = DamageType.VOID,
		-- Redo these when void talents are added
		talent_on_hit = { [Talents.T_SPATIAL_TETHER] = {level=1, chance=15}, [Talents.T_DIMENSIONAL_ANCHOR] = {level=1, chance=15} },
	},
}

newEntity{ base = "BASE_ARROW", --Thanks Grayswandir!
	power_source = {nature=true},
	unique = true,
	name = "Hornet Stingers", image = "object/artifact/hornet_stingers.png",
	proj_image = "object/artifact/arrow_s_hornet_stingers.png",
	unided_name = _t"sting tipped arrows",
	desc = _t[[A vile poison drips from the tips of these arrows.]],
	color = colors.BLUE,
	level_range = {15, 25},
	rarity = 240,
	cost = 100,
	material_level = 2,
	require = { stat = { dex=18 }, },
	combat = {
		capacity = 20,
		dam = 18,
		apr = 10,
		physcrit = 5,
		dammod = {dex=0.7, str=0.5},
		-- Items can't pass parameters to DamageTypes, so we use special_on_hit instead. Thanks Shibari!
		special_on_hit = {desc=_t"afflicts the target with a poison dealing 20 damage per turn and causing actions to fail 20% of the time for 6 turns", fct=function(combat, who, target)
			if target and target:canBe("poison") then
				target:setEffect(target.EFF_CRIPPLING_POISON, 6, {src=who, power=20, fail=20, no_ct_effect=true})
			end
		end},
	},
}

newEntity{ base = "BASE_LITE", --Thanks Frumple!
	power_source = {psionic=true},
	unique = true,
	name = "Umbraphage", image="object/artifact/umbraphage.png",
	unided_name = _t"deep black lantern",
	level_range = {20, 30},
	color=colors.BLACK,
	rarity = 240,
	desc = _t[[This lantern of pale white crystal holds a sphere of darkness, that yet emanates light. Everywhere it shines, darkness vanishes entirely.]],
	cost = 320,
	material_level=3,
	sentient=true,
	charge = 0,
	special_desc = function(self) return ("Absorbs all darkness (power %d, based on Willpower and Cunning) within its light radius, increasing its own brightness. (current charge %d)."):tformat(self.worn_by and self.use_power.litepower(self, self.worn_by) or 100, self.charge) end,
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()

		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end

		who:project({type="ball", range=0, radius=self.wielder.lite}, who.x, who.y, function(px, py) -- The main event!
			local is_lit = game.level.map.lites(px, py)
			if is_lit then return end

			if not self.max_charge then
				self.charge = self.charge + 1
				if self.charge == 200 then
					self.charge = 300 -- Power boost when fully charged :)
					self.max_charge=true
					game.logPlayer(who, "#ORCHID#Umbraphage is fully powered!")
				end
			end
		end)
		who:project({type="ball", range=0, radius=self.wielder.lite}, who.x, who.y, engine.DamageType.LITE, self.use_power.litepower(self, who)) -- Light the space!
		if (5 + math.floor(self.charge/20)) > self.wielder.lite and self.wielder.lite < 10 then
			local p = self.power
			who:onTakeoff(self, who.INVEN_LITE, true)
			self.wielder.lite = math.min(10, 5+math.floor(self.charge/20))
			who:onWear(self, who.INVEN_LITE, true)
			self.power = p
		end
	end,
	wielder = {
		lite = 5,
		combat_mindpower=10,
		combat_mentalresist=10,

		inc_damage = {[DamageType.LIGHT]=15, [DamageType.DARKNESS]=15},
		resists = {[DamageType.DARKNESS]=20},
		resists_pen = {[DamageType.DARKNESS]=10},
		damage_affinity={
			[DamageType.DARKNESS] = 20,
		},
		talents_types_mastery = {
			["cursed/shadows"] = 0.2,
		}
	},
	max_power = 10, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.DARKNESS, self.use_power.damage(self, who))
			return ("release absorbed darkness in a %d radius cone with a %d%% chance to blind (based on lite radius), dealing %0.2f darkness damage (based on Mindpower and charge)"):tformat(self.use_power.radius(self, who), self.use_power.blindchance(self, who), dam)
		end,
		power = 10,
		damage = function(self, who) return 15 + 3*who:combatMindpower() + math.floor(self.charge/4) end, -- Damage is based on charge
		-- radius of cone and chance to blind depend on lite radius of the artifact
		radius = function(self, who) return self.wielder.lite end,
		blindchance = function(self, who) return self.wielder.lite*10 end,
		range = 0,
		target = function(self, who) return {type="cone", range=0, radius=self.use_power.radius(self, who)} end,
		tactical = {ATTACKAREA = {DARKNESS = 2}, DISABLE = {blind = 2}},
		requires_target = true,
		litepower = function(self, who) return who:combatStatScale(who:getWil(70)+who:getCun(30), 50, 150) end,
		use = function(self, who)
			local dam = self.use_power.damage(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s unshutters %s %s, unleashing a torrent of shadows!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			who:project(tg, x, y, engine.DamageType.DARKNESS, who:mindCrit(dam)) -- FIRE!
			who:project(tg, x, y, engine.DamageType.RANDOM_BLIND, self.use_power.blindchance(self, who)) -- blind
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "breath_dark", {radius=tg.radius, tx=x-who.x, ty=y-who.y})
			self.max_charge=nil -- Reset charge.
			self.charge=0

			local p = self.power
			who:onTakeoff(self, who.INVEN_LITE, true)
			self.wielder.lite = 5
			who:onWear(self, who.INVEN_LITE, true)
			self.power = p
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LITE", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Spectral Cage", image="object/artifact/spectral_cage.png",
	unided_name = _t"ethereal blue lantern",
	level_range = {20, 30},
	color=colors.BLUE,
	rarity = 240,
	desc = _t[[This ancient, weathered lantern glows with a pale blue light emanating from several ghostly forms trapped within.  The metal is icy cold to the touch.]],
	cost = 320,
	material_level=3,
	wielder = {
		lite = 5,
		combat_spellpower=10,

		inc_damage = {[DamageType.COLD]=15},
		resists = {[DamageType.COLD]=20},
		resists_pen = {[DamageType.COLD]=10},

		talent_cd_reduction = {
			-- DGDGDGDG !!!!
			-- [Talents.T_CHILL_OF_THE_TOMB] = 2,
		},
	},
	max_power = 20, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.COLD, self.use_power.damage(self, who))
			return ("release a will o' the wisp that will explode against your foes for %d cold damage (based on your Magic)"):tformat(dam)
		end,
		power = 20,
		damage = function(self, who) return 110 + who:getMag() * 2.5 end,
		tactical = {ATTACK = {COLD = 2}},
		use = function(self, who)
			if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			local NPC = require "mod.class.NPC"
			local Talents = require "engine.interface.ActorTalents"
			local m = NPC.new{
				name = _t"will o' the wisp",
				desc = _t"A chilling, ghostly form that floats in the air.",
				type = "undead", subtype = "ghost",
				blood_color = colors.GREY,
				display = "G", color=colors.WHITE,
				combat = { dam=1, atk=1, apr=1 },
				autolevel = "warriormage",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				dont_pass_target = true,
				movement_speed = 2,
				stats = { str=14, dex=18, mag=20, con=12 },
				rank = 2,
				size_category = 1,
				infravision = 10,
				can_pass = {pass_wall=70},
				resists = {all = 35, [engine.DamageType.LIGHT] = -70, [engine.DamageType.COLD] = 65, [engine.DamageType.DARKNESS] = 65},
				no_breath = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 0.5,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				see_invisible = 80,
				undead = 1,
				will_o_wisp_dam = self.use_power.damage(self, who),
				inc_damage = table.clone(who.inc_damage),
				resists_pen = table.clone(who.resists_pen),
				resolvers.talents{[Talents.T_WILL_O__THE_WISP_EXPLODE] = 1,},

				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time = 20,
			}

			m:resolve()
			who:logCombat(who.ai_target.actor, "#Source# releases an icy whisp from %s %s!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true,
			game.party:addMember(m, {
				control=false,
				type="summon",
				title=_t"Summon",
				orders = {target=true, leash=true, anchor=true, talents=true},
			})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {nature = true, antimagic=true},
	unique=true, rarity=240,
	type = "charm", subtype="totem",
	name = "The Guardian's Totem", image = "object/artifact/the_guardians_totem.png",
	unided_name = _t"a cracked stone totem",
	color = colors.GREEN,
	level_range = {40, 50},
	desc = _t[[This totem of ancient stone oozes a thick slime from myriad cracks. Nonetheless, you sense great power within it.]],
	cost = 320,
	material_level = 5,
	wielder = {
		resists={[DamageType.BLIGHT] = 20, [DamageType.ARCANE] = 20},
		on_melee_hit={[DamageType.ITEM_NATURE_SLOW] = 18},
		combat_spellresist = 20,
		talents_types_mastery = { ["wild-gift/antimagic"] = 0.1, ["wild-gift/fungus"] = 0.1},
		inc_stats = {[Stats.STAT_WIL] = 10,},
		combat_mindpower=8,
	},
	on_takeoff = function(self)
		if self.summoned_totem then self.summoned_totem:die() end
		self.summoned_totem = nil
	end,
	max_power = 50, power_regen = 1,
	use_power = {
		name = _t"call forth an immobile antimagic pillar for 10 turns.  (It spits slime, pulls in, stuns, and burns the arcane resources of your foes, while emitting an aura of silence against them within range 5, and will silence you for 5 turns when first summoned.)",
		power = 50,
		tactical = {ATTACK = {NATURE = 2},
			CLOSEIN = 1.5,
			DISABLE = function(self, t, aitarget)
				local val = 1.5 + (aitarget:attr("has_arcane_knowledge") and 2 or 0) + (aitarget:knowTalent(aitarget.T_MANA_POOL) and 1 or 0) + (aitarget:knowTalent(aitarget.T_VIM_POOL) and 1 or 0)
			end
		},
		no_npc_use = function(self, who) return self:restrictAIUseObject(who) end,
		on_pre_use_ai = function(self, who) return not who:attr("has_arcane_knowledge") end,
		use = function(self, who)
			if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to invoke!")
				return
			end
			local Talents = require "engine.interface.ActorTalents"
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				resolvers.nice_tile{image="invis.png", add_mos = {{image="terrain/darkgreen_moonstone_01.png", display_h=2, display_y=-1}}},
				name = _t"Stone Guardian",
				type = "totem", subtype = "antimagic",
				desc = _t"This massive stone pillar drips with a viscous slime. Nature's power flows through it, obliterating magic all around it...",
				rank = 3,
				blood_color = colors.GREEN,
				display = "T", color=colors.GREEN,
				life_rating=18,
				combat_dam = 40,
				combat = {
					dam=resolvers.rngavg(50,60),
					atk=resolvers.rngavg(50,75), apr=25,
					dammod={wil=1.2}, physcrit = 10,
					damtype=engine.DamageType.SLIME,
				},
				level_range = {1, who.level}, exp_worth = 0,
				silent_levelup = true,
				combat_armor=50,
				combat_armor_hardiness=70,
				autolevel = "wildcaster",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				never_move=1,
				stats = { str=14, dex=18, mag=10, con=12, wil=20, cun=20, },
				combat_mindpower = resolvers.levelup(1, 1, 3),  -- ~87 mindpower at L50 including stats
				size_category = 5,
				blind=1,
				esp_all=1,
				resists={all = 15, [engine.DamageType.BLIGHT] = 40, [engine.DamageType.ARCANE] = 40, [engine.DamageType.NATURE] = 70},
				no_breath = 1,
				cant_be_moved = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 1,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				knockback_resist=1,
				combat_mentalresist=50,
				combat_spellresist=100,
				on_act = function(self) self:project({type="ball", range=0, radius=5, friendlyfire=false}, self.x, self.y, engine.DamageType.SILENCE, {dur=2, power_check=self:combatMindpower()}) end,
				power_source = {nature=true, antimagic=true},
				resolvers.talents{
					[Talents.T_RESOLVE]={base=3, every=8},
					[Talents.T_MANA_CLASH]={base=3, every=10},
					[Talents.T_STUN]={base=3, every=8},
					[Talents.T_OOZE_SPIT]={base=5, every=10},
					[Talents.T_TENTACLE_GRAB]={base=1, every=6,},
				},

				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time=10,
			}

			m:resolve()
			who:logCombat(m, "#Source# uses %s to summon a natural guardian!", self:getName({do_color=true, no_add_name=true}))
			m:forceLevelup(who.level)

			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true,
			game.party:addMember(m, {
				control=false,
				type="summon",
				title=_t"Summon",
				temporary_level = true,
				orders = {target=true, leash=true, anchor=true, talents=true},
			})
			who:setEffect(who.EFF_SILENCED, 5, {})
			self.summoned_totem = m
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {psionic=true},
	unique = true,
	name = "Cloth of Dreams", image = "object/artifact/cloth_of_dreams.png",
	unided_name = _t"tattered cloak",
	desc = _t[[Touching this cloak of otherworldly fabric makes you feel both drowsy yet completely aware.]],
	level_range = {30, 40},
	rarity = 240,
	cost = 200,
	material_level = 4,
	wielder = {
		combat_def = 10,
		combat_mindpower = 6,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		inc_stats = { [Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 5, },
		resists = { [DamageType.MIND] = 15 },
		lucid_dreamer=1,
		sleep=1,
		talents_types_mastery = { ["psionic/dreaming"] = 0.1, ["psionic/slumber"] = 0.1,},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_SLUMBER, level = 3, power = 10 },
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {arcane=true},
	unique=true, rarity=240,
	type = "charm", subtype="wand",
	name = "Void Shard", image = "object/artifact/void_shard.png",
	unided_name = _t"strange jagged shape",
	color = colors.GREY,
	level_range = {40, 50},
	desc = _t[[This jagged shape looks like a hole in space, yet it is solid, though light in weight.]],
	cost = 320,
	material_level = 5,
	wielder = {
		resists={[DamageType.DARKNESS] = 10, [DamageType.TEMPORAL] = 10},
		inc_damage={[DamageType.DARKNESS] = 12, [DamageType.TEMPORAL] = 12},
		on_melee_hit={[DamageType.VOID] = 16},
		inc_stats = {[Stats.STAT_MAG] = 8,},
		combat_spellpower=10,
	},
	max_power = 40, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = self.use_power.damage(self, who)/2
			return ("release a radius %d burst of void energy at up to range %d, dealing %0.2f temporal and %0.2f darkness damage (based on Magic)"):tformat(self.use_power.radius, self.use_power.range, who:damDesc(engine.DamageType.TEMPORAL, dam), who:damDesc(engine.DamageType.DARKNESS, dam))
		end,
		power = 20,
		damage = function(self, who) return 200 + who:getMag() * 2 end,
		range = 5,
		radius = 2,
		target = function(self, who) return {type="ball", range=self.use_power.range, radius=self.use_power.radius} end,
		requires_target = true,
		tactical = {ATTACKAREA = {TEMPORAL = 2, DARKNESS = 2}},
		use = function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s siphons space and time into %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			who:project(tg, x, y, engine.DamageType.VOID, self.use_power.damage(self, who))
			game.level.map:particleEmitter(x, y, tg.radius, "shadow_flash", {radius=tg.radius, tx=x, ty=y})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD", --Thanks SageAcrin!
	power_source = {nature=true},
	unided_name = _t"thick coral plate",
	name = "Coral Spray", unique=true, image = "object/artifact/coral_spray.png",
	desc = _t[[A chunk of jagged coral, dredged from the ocean.]],
	require = { stat = { str=16 }, },
	level_range = {1, 15},
	rarity = 200,
	cost = 60,
	material_level = 1,
	moddable_tile = "special/%s_coral_spray",
	moddable_tile_big = true,
	metallic = false,
	special_combat = {
		dam = 18,
		block = 48,
		physcrit = 2,
		dammod = {str=1.4},
		damrange = 1.4,
		melee_project = { [DamageType.COLD] = 10, },
	},
	wielder = {
		combat_armor = 8,
		combat_def = 8,
		fatigue = 12,
		resists = {
			[DamageType.COLD] = 15,
			[DamageType.FIRE] = 10,
		},
		learn_talent = { [Talents.T_BLOCK] = 1, },
		max_air = 20,
	},
	on_block = {desc = _t"30% chance to spray freezing water (radius 4 cone) at the target.", fct = function(self, who, target, type, dam, eff)
		if rng.percent(30) then
			if not target or target:attr("dead") or not target.x or not target.y then return end

			local burst = {type="cone", range=0, radius=4, force_target=target, selffire=false,}

			who:project(burst, target.x, target.y, engine.DamageType.ICE, 30)
			game.level.map:particleEmitter(who.x, who.y, burst.radius, "breath_cold", {radius=burst.radius, tx=target.x-who.x, ty=target.y-who.y})
			who:logCombat(target, "A wave of icy water sprays out from #Source# towards #Target#!")
		end
	end,},
}

newEntity{ base = "BASE_AMULET", --Thanks Grayswandir!
	power_source = {psionic=true},
	unique = true,
	name = "Shard of Insanity", color = colors.DARK_GREY, image = "object/artifact/shard_of_insanity.png",
	unided_name = _t"cracked black amulet",
	desc = _t[[A deep red light glows from within this damaged amulet of black stone. When you touch it, you can hear voices whispering within your mind.]],
	level_range = {20, 32},
	rarity = 290,
	cost = 500,
	material_level = 3,
	wielder = {
		combat_mindpower = 8,
		combat_mentalresist = 35,
		confusion_immune=-1,
		inc_damage={
			[DamageType.MIND] 	= 25,
		},
		resists={
			[DamageType.MIND] 	= -10,
		},
		resists_pen={
			[DamageType.MIND] 	= 20,
		},
		on_melee_hit={[DamageType.RANDOM_CONFUSION] = 5},
		melee_project={[DamageType.RANDOM_CONFUSION] = 5},
	},
	max_power = 30, power_regen = 1,
	talent_on_mind = { {chance=8, talent=Talents.T_SUNDER_MIND, level=1} },
}

newEntity{ base = "BASE_SHOT", --Thanks Grayswandir!
	power_source = {psionic=true},
	unique = true,
	name = "Pouch of the Subconscious", image = "object/artifact/pouch_of_the_subconscious.png",
	proj_image = "object/artifact/shot_s_pouch_of_the_subconscious.png",
	unided_name = _t"familiar pouch",
	desc = _t[[You find yourself constantly fighting an urge to handle this strange pouch of shot.]],
	color = colors.RED,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 20,
		dam = 38,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5, wil=0.1},
		ranged_project={
			[DamageType.MIND] = 25,
			[DamageType.MINDSLOW] = 30,
		},
		special_on_hit = {desc=_t"50% chance to reload 1 ammo", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(50) then return end
			local ammo = who:hasAmmo()
			if not ammo then return end
			ammo.combat.shots_left = util.bound(ammo.combat.shots_left + 1, 0, ammo.combat.capacity)
		end},
	},
}

newEntity{ base = "BASE_SHOT", --Thanks Grayswandir!
	power_source = {nature=true},
	unique = true,
	name = "Wind Worn Shot", image = "object/artifact/wind_worn_shot.png",
	proj_image = "object/artifact/shot_s_wind_worn_shot.png",
	unided_name = _t"perfectly smooth shot",
	desc = _t[[These perfectly white spheres appear to have been worn down by years of exposure to strong winds.]],
	color = colors.RED,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 25,
		dam = 39,
		apr = 15,
		physcrit = 10,
		travel_speed = 1,
		dammod = {dex=0.7, cun=0.5},
		talent_on_hit = { [Talents.T_TORNADO] = {level=2, chance=10} },
		special_on_hit = {desc=_t"35% chance for lightning to arc to a second target", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(35) then return end
			local tgts = {}
			local x, y = target.x, target.y
			local grids = core.fov.circle_grids(x, y, 5, true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, engine.Map.ACTOR)
				if a and a ~= target and who:reactionToward(a) < 0 then
					tgts[#tgts+1] = a
				end
			end end

			-- Randomly take targets
			local tg = {type="beam", range=5, friendlyfire=false, x=target.x, y=target.y}
			if #tgts <= 0 then return end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			local dam = 30 + (who:combatMindpower())

			who:project(tg, a.x, a.y, engine.DamageType.LIGHTNING, rng.avg(1, dam, 3))
			game.level.map:particleEmitter(x, y, math.max(math.abs(a.x-x), math.abs(a.y-y)), "lightning", {tx=a.x-x, ty=a.y-y})
			game:playSoundNear(who, "talents/lightning")
		end},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {nature=true, antimagic=true},
	name = "Spellcrusher", color = colors.GREEN, image = "object/artifact/spellcrusher.png",
	unided_name = _t"vine coated hammer", unique = true,
	desc = _t[[This large steel greatmaul has thick vines wrapped around the handle.]],
	level_range = {10, 20},
	rarity = 300,
	require = { stat = { str=20 }, },
	cost = 650,
	material_level = 2,
	combat = {
		dam = 32,
		apr = 4,
		physcrit = 4,
		dammod = {str=1.2},
		melee_project={[DamageType.NATURE] = 20},
		special_on_hit = {desc=_t"50% chance to shatter magical shields", fct=function(combat, who, target)
			if not rng.percent(50) then return end
			if not target then return end

			-- List all diseases, I mean, burns, I mean, shields.
			local shields = {}
			for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
				if e.subtype.shield and p.power and e.type == "magical" then
					shields[#shields+1] = {id=eff_id, params=p}
				end
			end
			local is_shield = false
			-- Make them EXPLODE !!!, I mean, remove them.
			for i, d in ipairs(shields) do
				if target:dispel(d.id, who) then
					is_shield = true
				end
			end

			if target:attr("disruption_shield") then
				if target:dispel(target.T_DISRUPTION_SHIELD, who) then
					is_shield = true
				end
			end
			if is_shield == true then
				game.logSeen(target, "%s's magical shields are shattered!", target:getName():capitalize())
			end
		end},
	},
	wielder = {
		inc_damage= {[DamageType.NATURE] = 25},
		inc_stats = {[Stats.STAT_CON] = 6,},
		combat_spellresist=15,
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"combat","melee_project"}, {[DamageType.MANABURN]=20})
			self:specialWearAdd({"wielder","resists"}, {[DamageType.ARCANE] = 10, [DamageType.BLIGHT] = 10})
			game.logPlayer(who, "#DARK_GREEN#You feel a great power rise within you!")
		end
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {psionic=true},
	unique=true, rarity=240,
	type = "charm", subtype="torque",
	name = "Telekinetic Core", image = "object/artifact/telekinetic_core.png",
	unided_name = _t"heavy torque",
	color = colors.BLUE,
	level_range = {5, 20},
	desc = _t[[This heavy torque appears to draw nearby matter towards it.]],
	cost = 320,
	material_level = 2,
	wielder = {
		resists={[DamageType.PHYSICAL] = 5,},
		inc_damage={[DamageType.PHYSICAL] = 6,},
		combat_physresist = 12,
		inc_stats = {[Stats.STAT_WIL] = 5,},
		combat_mindpower=3,
		combat_dam=3,
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_PSIONIC_PULL, level = 3, power = 18 },
}

newEntity{ base = "BASE_GREATSWORD", --Thanks Grayswandir!
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Spectral Blade", image = "object/artifact/spectral_blade.png",
	unided_name = _t"immaterial sword",
	level_range = {10, 20},
	color=colors.GRAY,
	rarity = 300,
	encumber = 0.1,
	desc = _t[[This sword appears weightless, and nearly invisible.]],
	cost = 400,
	require = { stat = { mag=18, }, },
	metallic = false,
	material_level = 2,
	combat = {
		dam = 26,
		physspeed=0.9,
		apr = 25,
		physcrit = 3,
		dammod = {str=1.2, mag=0.1},
		melee_project={[DamageType.ARCANE] = 15,},
		burst_on_crit = {
			[DamageType.ARCANE_SILENCE] = 30,
		},
	},
	wielder = {
		blind_fight = 1,
		see_invisible=10,
		combat_spellpower = 5,
		mana_regen = 0.5,
	},
}

newEntity{ base = "BASE_GLOVES", --Thanks SageAcrin /AND/ Edge2054!
	power_source = {technique=true, arcane=true},
	unique = true,
	name = "Crystle's Astral Bindings", --Yes, CRYSTLE. It's a name.
	unided_name = _t"crystalline gloves", image = "object/artifact/crystles_astral_bindings.png",
	desc = _t[[Said to have belonged to a lost Anorithil, stars are reflected in the myriad surfaces of these otherworldly bindings.]],
	level_range = {8, 20},
	rarity = 225,
	cost = 340,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_MAG] = 3 },
		combat_spellpower = 2,
		combat_spellcrit = 3,
		spellsurge_on_crit = 4,
		resists={[DamageType.DARKNESS] = 8, [DamageType.TEMPORAL] = 8},
		inc_damage={[DamageType.DARKNESS] = 8, [DamageType.TEMPORAL] = 8},
		resists_pen={[DamageType.DARKNESS] = 10, [DamageType.TEMPORAL] = 10},
		negative_regen=0.2,
		combat = {
			dam = 13,
			apr = 3,
			physcrit = 6,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.2 },
			convert_damage = {[DamageType.VOID] = 100,},
			talent_on_hit = { [Talents.T_DUST_TO_DUST] = {level=1, chance=15}, [Talents.T_MIND_BLAST] = {level=1, chance=10}, [Talents.T_TURN_BACK_THE_CLOCK] = {level=1, chance=10} },
		},
	},
	-- Change when void talents are done
	talent_on_spell = { {chance=10, talent=Talents.T_DUST_TO_DUST, level=2} },
}

-- Display on this is kinda screwy since talent_on_spell doesn't go in wielder tables, imbues special case adding it
newEntity{ base = "BASE_GEM", --Thanks SageAcrin and Graziel!
	power_source = {arcane=true},
	unique = true,
	unided_name = _t"cracked golem eye",
	name = "Prothotipe's Prismatic Eye", subtype = "multi-hued",
	color = colors.WHITE, image = "object/artifact/prothotipes_prismatic_eye.png",
	level_range = {18, 30},
	desc = _t[[This cracked gemstone looks faded with age. It appears to have once been the eye of a golem.]],
	rarity = 240,
	cost = 200,
	identified = false,
	material_level = 3,
	color_attributes = {
		damage_type = 'LIGHTNING',
		alt_damage_type = 'LIGHTNING_DAZE',
		particle = 'lightning_explosion',
	},
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 5, [Stats.STAT_CON] = 5, },
		inc_damage = {[DamageType.FIRE] = 10, [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10,  },
		talents_types_mastery = {
			["golem/arcane"] = 0.2,
		},
		talent_on_spell = { {chance=10, talent=Talents.T_GOLEM_BEAM, level=2} },

	},
	imbue_powers = {
		inc_stats = {[Stats.STAT_MAG] = 5, [Stats.STAT_CON] = 5, },
		inc_damage = {[DamageType.FIRE] = 10, [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10,  },
		talents_types_mastery = {
			["golem/arcane"] = 0.2,
		},
		talent_on_spell = { {chance=10, talent=Talents.T_GOLEM_BEAM, level=2} },
	},
	talent_on_spell = { {chance=10, talent=Talents.T_GOLEM_BEAM, level=2} },
	special_desc = function(self) return _t"Casts lasers on spellcast when worn or imbued." end,

}

newEntity{ base = "BASE_MASSIVE_ARMOR", --Thanks SageAcrin!
	power_source = {psionic=true},
	unique = true,
	name = "Plate of the Blackened Mind", image = "object/artifact/plate_of_the_blackened_mind.png",
	unided_name = _t"solid black breastplate",
	desc = _t[[This deep black armor absorbs all light that touches it. A dark power sleeps within, primal, yet aware. When you touch the plate, you feel dark thoughts creeping into your mind.]],
	color = colors.BLACK,
	level_range = {40, 50},
	rarity = 390,
	require = { stat = { str=48 }, },
	cost = 800,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 4, [Stats.STAT_CON] = 3,},
		resists = {
			[DamageType.ACID] = 15,
			[DamageType.LIGHT] = 15,
			[DamageType.MIND] = 25,
			[DamageType.BLIGHT] = 20,
			[DamageType.DARKNESS] = 20,
		},
		combat_def = 15,
		combat_armor = 40,
		confusion_immune = 1,
		fear_immune = 1,
		combat_mentalresist = 25,
		combat_physresist = 15,
		combat_mindpower=10,
		lite = -2,
		infravision=4,
		fatigue = 17,
		talents_types_mastery = {
			["cursed/gloom"] = 0.2,
		},
		on_melee_hit={[DamageType.ITEM_MIND_GLOOM] = 20}, --Thanks Edge2054!
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_DOMINATE, level = 2, power = 15 },
}

newEntity{ base = "BASE_TOOL_MISC", --Sorta Thanks Donkatsu!
	power_source = {nature = true},
	unique=true, rarity=220,
	type = "charm", subtype="totem",
	name = "Tree of Life", image = "object/artifact/tree_of_life.png",
	unided_name = _t"tree shaped totem",
	color = colors.GREEN,
	level_range = {40, 50},
	desc = _t[[This small tree-shaped totem is imbued with powerful healing energies.]],
	cost = 320,
	material_level = 4,
	special_desc = function(self) return _t"Heals all nearby living creatures by 5 points each turn." end,
	sentient=true,
	use_no_energy = true,
	wielder = {
		resists={[DamageType.BLIGHT] = 20, [DamageType.NATURE] = 20},
		inc_damage={[DamageType.NATURE] = 20},
		talents_types_mastery = { ["wild-gift/call"] = 0.1, ["wild-gift/harmony"] = 0.1, },
		inc_stats = {[Stats.STAT_WIL] = 7, [Stats.STAT_CON] = 6,},
		combat_mindpower=7,
		healing_factor=0.25,
	},
	on_takeoff = function(self, who)
		self.worn_by=nil
		who:removeParticles(self.particle)
	end,
	on_wear = function(self, who)
		self.worn_by=who
		if core.shader.active(4) then
			self.particle = who:addParticles(engine.Particles.new("shader_ring_rotating", 1, {rotation=0, radius=4}, {type="flames", aam=0.5, zoom=3, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0}))
		else
			self.particle = who:addParticles(engine.Particles.new("ultrashield", 1, {rm=0, rM=0, gm=180, gM=220, bm=10, bM=80, am=80, aM=150, radius=2, density=30, life=14, instop=17}))
		end
		game.logPlayer(who, "#CRIMSON# A powerful healing aura appears around you as you equip the %s.", self:getName({no_add_name = true, do_color = true}))
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		local blast = {type="ball", range=0, radius=2, selffire=true}
		who:project(blast, who.x, who.y, engine.DamageType.HEALING_NATURE, 5)
	end,
	max_power = 15, power_regen = 1,
	use_power = {
		name = _t"take root increasing health by 300, armor by 20, and armor hardiness by 20%% but rooting you in place for 4 turns",
		power = 10,
		tactical = {DEFEND = 2},
		on_pre_use_ai = function(self, who, silent, fake)
			if who:hasEffect(who.EFF_TREE_OF_LIFE) then return end
			if who.ai_tactic then
				if math.max(who.ai_tactic.closein or 1, who.ai_tactic.escape or 1) > (who.ai_tactic.defend or 1) then return end
			end
			return true
		end,
		no_npc_use = function(self, who) return who:attr("undead") or self:restrictAIUseObject(who) end,
		use = function(self, who)
			game.logSeen(who, "%s merges with %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color=true, no_add_name = true}))
			who:setEffect(who.EFF_TREE_OF_LIFE, 4, {})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_RING",
	power_source = {technique=true, nature=true},
	name = "Ring of Growth", unique=true, image = "object/artifact/ring_of_growth.png",
	desc = _t[[This small wooden ring has a single green stem wrapped around it. Thin leaves still seem to be growing from it.]],
	unided_name = _t"vine encircled ring",
	level_range = {6, 20},
	rarity = 250,
	cost = 500,
	material_level = 2,
	wielder = {
		combat_physresist = 8,
		inc_stats = {[Stats.STAT_WIL] = 4, [Stats.STAT_STR] = 4,},
		inc_damage={ [DamageType.PHYSICAL] = 8, [DamageType.NATURE] = 8,},
		resists={[DamageType.NATURE] = 10,},
		life_regen=3,
		healing_factor=0.2,
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Wrap of Stone", image = "object/artifact/wrap_of_stone.png",
	unided_name = _t"solid stone cloak",
	desc = _t[[This thick cloak is incredibly tough, yet bends and flows with ease.]],
	level_range = {8, 20},
	rarity = 400,
	cost = 250,
	material_level = 2,
	wielder = {
		combat_spellpower=6,
		talents_types_mastery = {
			["spell/earth"] = 0.2,
			["spell/stone"] = 0.2,
			["chronomancy/gravity"] = 0.2,
			["chronomancy/matter"] = 0.1,
		},
		inc_damage={ [DamageType.PHYSICAL] = 5,},
		resists={ [DamageType.PHYSICAL] = 5,},
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_STONE_WALL, level = 1, power = 60 },
}

newEntity{ base = "BASE_LIGHT_ARMOR", --Thanks SageAcrin!
	power_source = {arcane=true},
	unided_name = _t"black leather armor",
	name = "Death's Embrace", unique=true, image = "object/artifact/deaths_embrace.png",
	desc = _t[[This deep black leather armor, wrapped with thick silk, is icy cold to the touch.]],
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level=5,
	wielder = {
		combat_spellpower = 10,
		combat_critical_power = 20,
		combat_def = 18,
		combat_armor = 18,
		combat_armor_hardiness=15,
		inc_stats = {
			[Stats.STAT_MAG] = 5,
			[Stats.STAT_CUN] = 5,
			[Stats.STAT_DEX] = 5,
		},
		on_melee_hit = {[DamageType.DARKNESS]=15, [DamageType.COLD]=15},
		inc_stealth=10,
 		inc_damage={
			[DamageType.DARKNESS] = 20,
			[DamageType.COLD] = 20,
 		},
 		resists={
			[DamageType.TEMPORAL] = 30,
			[DamageType.DARKNESS] = 30,
			[DamageType.COLD] = 30,
 		},
 		talents_types_mastery = {
 			["spell/phantasm"] = 0.1,
 			["spell/dreadmaster"] = 0.1,
			["cunning/stealth"] = 0.1,
 		},
	},
	max_power = 50, power_regen = 1,
		use_power = {
		name = function(self, who) return ("turn yourself invisible (power %d, based on Cunning and Magic) for 10 turns"):tformat(self.use_power.invispower(self, who)) end,
		power = 50,
		tactical = {DEFEND = 2, ESCAPE = 2},
		on_pre_use_ai = function(self, who, silent, fake)
			return not who:hasEffect(who.EFF_INVISIBILITY)
		end,
		invispower = function(self, who) return 10+who:getCun()/6+who:getMag()/6 end,
		use = function(self, who)
			game.logSeen(who, "%s pulls %s %s around %s like a dark shroud!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}), who:his_her_self())
			who:setEffect(who.EFF_INVISIBILITY, 10, {power=self.use_power.invispower(self, who), penalty=0.5, regen=true})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR", --Thanks SageAcrin!
	power_source = {nature=true, antimagic=true},
	unided_name = _t"gauzy green armor",
	name = "Breath of Eyal", unique=true, image = "object/artifact/breath_of_eyal.png",
	desc = _t[[This lightweight armor appears to have been woven of countless sprouts, still curling and growing. When you put it on, you feel the weight of the world on your shoulders, in spite of how light it feels in your hands.]],
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level=5,
	wielder = {
		combat_spellresist = 20,
		combat_mindpower = 10,
		combat_def = 10,
		combat_armor = 10,
		fatigue = 20,
		resists = {
			[DamageType.ACID] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.FIRE] = 20,
			[DamageType.COLD] = 20,
			[DamageType.LIGHT] = 20,
			[DamageType.DARKNESS] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.TEMPORAL] = 20,
			[DamageType.NATURE] = 20,
			[DamageType.ARCANE] = 15,
		},
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","resists"}, {all = 10})
			game.logPlayer(who, "#DARK_GREEN#You feel the strength of the whole world behind you!")
		end
	end,
}

newEntity{ base = "BASE_TOOL_MISC", --Thanks Alex!
	power_source = {arcane=true},
	unique = true,
	name = "Eternity's Counter", color = colors.WHITE,
	unided_name = _t"crystalline hourglass", image="object/artifact/eternities_counter.png",
	desc = _t[[This hourglass of otherworldly crystal appears to be filled with countless tiny gemstones in place of sand. As they fall, you feel the flow of time change around you.]],
	level_range = {30, 40},
	rarity = 300,
	cost = 200,
	material_level = 4,
	direction=1,
	position = 0,
	finished=false,
	sentient=true,
	metallic = false,
	special_desc = function(self) return _t"Offers either offensive or defensive benefits, depending on the position of the sands.  Switching the direction of flow takes no time." end,
	wielder = {
		inc_damage = { [DamageType.TEMPORAL]= 15},
		resists = { [DamageType.TEMPORAL] = 15, all = 0, },
		movement_speed=0,
		combat_physspeed=0,
		combat_spellspeed=0,
		combat_mindspeed=0,
		flat_damage_armor = {all=0},
	},
	max_power = 20, power_regen = 1,
	use_power = {
		name = function(self, who) return ("flip the hourglass (sands currently flowing towards %s)"):tformat(self.direction > 0 and _t"stability" or _t"entropy") end,
		power = 20,
		tactical = function(self, who, aitarget)
			if not aitarget then return end

			local tac = {}
				if self.direction > 0 then tac.buff = self.position/10 end
				if self.direction < 0 then tac.escape = -self.position/20 end
				if self.direction < 0 then tac.closein = -self.position/20 end
				if self.direction < 0 then tac.defend = -self.position/10 end

			if true then return tac end
		end,
		on_pre_use_ai = function(self, who, silent, fake)
			self.use_power.last_used = self.use_power.last_used or game.turn
			return game.turn - self.use_power.last_used > 100 -- don't want the ai to switch too much
		end,
		no_npc_use = function(self, who) return self:restrictAIUseObject(who) end,
		use = function(self, who)
--game.log("%s: ai_tactic: %s", who:getName(), who.ai_state.tactic)
			local power = self.power
			self.use_power.last_used = game.turn
			self.direction = self.direction * -1
			self.finished = false
			who:onTakeoff(self, who.INVEN_TOOL, true)
			self.wielder.inc_damage.all = 0
			self.wielder.flat_damage_armor.all = 0
			who:onWear(self, who.INVEN_TOOL, true)
			game.logSeen(who, "%s flips %s %s over...", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.logPlayer(who, "#GOLD#The sands slowly begin falling towards %s.", self.direction > 0 and _t"stability" or _t"entropy")
			self.power = power
			return {id=true, used=true, no_energy = true} -- effectively instant use without the AI priority boost
		end
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		local direction=self.direction
		if self.finished == true then return end
		local power = self.power
		who:onTakeoff(self, who.INVEN_TOOL, true)

		self.position = self.position + direction

		if self.position <= -4 then
			self.position = -4
			self.wielder.inc_damage.all = 10
			game.logPlayer(who, "#GOLD#As the final sands drop into place, you feel a surge of power.")
			self.finished=true
		end
		if self.position >= 4 then
			self.position = 4
			self.wielder.flat_damage_armor.all = 10
			game.logPlayer(who, "#GOLD#As the final sands drop into place, you suddenly feel safer.")
			self.finished=true
		end

		self.wielder.resists.all = self.position * 3
		self.wielder.movement_speed = self.position * 0.04
		self.wielder.combat_physspeed = -self.position * 0.03
		self.wielder.combat_spellspeed = -self.position * 0.03
		self.wielder.combat_mindspeed = -self.position * 0.03

		who:onWear(self, who.INVEN_TOOL, true)
		self.power = power
	end,
}

newEntity{ base = "BASE_WIZARD_HAT", --Thanks SageAcrin!
	power_source = {psionic=true},
	unique = true,
	name = "Malslek the Accursed's Hat",
	unided_name = _t"black charred hat",
	desc = _t[[This black hat once belonged to a powerful mage named Malslek, in the Age of Dusk, who was known to deal with beings from other planes. In particular, he dealt with many powerful demons, until one of them, tired of his affairs, betrayed him and stole his power. In his rage, Malslek set fire to his own tower in an attempt to kill the demon. This charred hat is all that remained in the ruins.]],
	color = colors.BLUE, image = "object/artifact/malslek_the_accursed_hat.png",
	level_range = {30, 40},
	rarity = 300,
	cost = 100,
	material_level = 4,
	wielder = {
		combat_def = 2,
		combat_mentalresist = -10,
		healing_factor=-0.1,
		combat_mindpower = 15,
		combat_spellpower = 10,
		combat_mindcrit=10,
		hate_on_crit = 2,
		hate_per_kill = 2,
		max_hate = 20,
		resists = { [DamageType.FIRE] = 20 },
		talents_types_mastery = {
			["cursed/punishments"]=0.2,
		},
		melee_project={[DamageType.RANDOM_GLOOM] = 30},
		inc_damage={
			[DamageType.DARKNESS] 	= 10,
			[DamageType.PHYSICAL]	= 10,
		},
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.subclass == "Doomed" then
			local Talents = require "engine.interface.ActorTalents"
			self.talent_on_mind = { {chance=10, talent=Talents.T_DARK_TORRENT, level=2} }
			game.logPlayer(who, "#RED#Malslek's hatred flows through you.")
		end
	end,
	talent_on_spell = { {chance=10, talent=Talents.T_AGONY, level=2} },
	talent_on_mind  = { {chance=10, talent=Talents.T_HATEFUL_WHISPER, level=2} },
}

newEntity{ base = "BASE_TOOL_MISC", --And finally, Thank you, Darkgod, for making such a wonderful game!
	power_source = {technique=true},
	unique=true, rarity=240,
	name = "Fortune's Eye", image = "object/artifact/fortunes_eye.png",
	unided_name = _t"golden telescope",
	color = colors.GOLD,
	level_range = {28, 40},
	desc = _t[[This finely crafted telescope once belonged to the explorer and adventurer Kestin Highfin. With this tool in hand he traveled in search of treasures all across Maj'Eyal, and before his death it was said his collection was incredibly vast. He often credited this telescope with his luck, saying that as long as he had it, he could escape any situation, no matter how dangerous. It is said he died confronting a demon seeking revenge for a stolen sword.

His last known words were "Somehow this feels like an ending, yet I know there is so much more to find."]],
	cost = 350,
	material_level = 4,
	wielder = {
		inc_stats = {[Stats.STAT_LCK] = 10, [Stats.STAT_CUN] = 5,},
		combat_atk=12,
		combat_apr=12,
		combat_physresist = 10,
		combat_spellresist = 10,
		combat_mentalresist = 10,
		combat_def = 12,
		see_invisible = 12,
		see_stealth = 12,
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_TRACK, level = 2, power = 18 },
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {nature=true},
	unique = true,
	name = "Eye of the Forest",
	unided_name = _t"overgrown leather cap", image = "object/artifact/eye_of_the_forest.png",
	level_range = {24, 32},
	color=colors.GREEN,
	encumber = 2,
	rarity = 200,
	desc = _t[[This leather cap is overgrown with a thick moss, except for around the very front, where an eye, carved of wood, rests. A thick green slime slowly pours from the corners of the eye, like tears.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=8,
		inc_stats = { [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6, },
		blind_immune=1,
		combat_mentalresist = 12,
		see_invisible = 15,
		see_stealth = 15,
		inc_damage={
			[DamageType.NATURE] = 20,
		},
		infravision=2,
		resists_pen={
			[DamageType.NATURE] = 15,
		},
		talents_types_mastery = { ["wild-gift/moss"] = 0.1,},
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_EARTH_S_EYES, level = 2, power = 35 },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {antimagic=true},
	unique = true,
	name = "Eyal's Will",
	unided_name = _t"pale green mindstar",
	level_range = {38, 50},
	color=colors.AQUAMARINE, image = "object/artifact/eyals_will.png",
	rarity = 380,
	desc = _t[[This smooth green crystal flows with a light green slime in its core. Droplets occasionally form on its surface, tufts of grass growing quickly on the ground where they fall.]],
	cost = 280,
	require = { stat = { wil=48 }, },
	material_level = 5,
	combat = {
		dam = 22,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 18,
		combat_mindcrit = 9,
		resists={[DamageType.BLIGHT] = 25, [DamageType.NATURE] = 15},
		inc_damage={
			[DamageType.NATURE] = 20,
			[DamageType.ACID] = 10,
		},
		resists_pen={
			[DamageType.NATURE] = 20,
			[DamageType.ACID] = 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 10, },
		learn_talent = {[Talents.T_OOZE_SPIT] = 3},
		talents_types_mastery = { ["wild-gift/mindstar-mastery"] = 0.1,},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_SLIME_WAVE, level = 3, power = 30 },
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {nature=true},
	unique = true,
	name = "Evermoss Robe", color = colors.DARK_GREEN, image = "object/artifact/evermoss_robe.png",
	unided_name = _t"fuzzy green robe",
	desc = _t[[This thick robe is woven from a dark green moss, firmly bound and cool to the touch. It is said to have rejuvenating properties.]],
	level_range = {30, 42},
	rarity = 200,
	cost = 350,
	material_level = 4,
	wielder = {
		combat_def=12,
		inc_stats = { [Stats.STAT_WIL] = 5, },
		combat_mindpower = 12,
		combat_mindcrit = 5,
		combat_physresist = 15,
		life_regen=0.2,
		healing_factor=0.15,
		inc_damage={[DamageType.NATURE] = 30,},
		resists={[DamageType.NATURE] = 25},
		resists_pen={[DamageType.NATURE] = 10},
		on_melee_hit={[DamageType.SLIME] = 35},
		talents_types_mastery = { ["wild-gift/moss"] = 0.3,},
	},
}

newEntity{ base = "BASE_SLING",
	power_source = {technique=true},
	unique = true,
	name = "Nithan's Force", image = "object/artifact/nithans_force.png",
	unided_name = _t"massive sling",
	desc = _t[[This powerful sling is said to have belonged to a warrior so strong his shots could knock down a brick wall...]],
	level_range = {35, 50},
	rarity = 220,
	require = { stat = { dex=32 }, },
	cost = 350,
	material_level = 5,
	combat = {
		range = 10,
		physspeed = 0.9,
	},
	wielder = {
		pin_immune = 0.3,
		knockback_immune = 0.3,
		inc_stats = { [Stats.STAT_STR] = 10, [Stats.STAT_CON] = 5,},
		inc_damage={ [DamageType.PHYSICAL] = 35},
		resists_pen={[DamageType.PHYSICAL] = 15},
		resists={[DamageType.PHYSICAL] = 10},
	},
	max_power = 16, power_regen = 1,
	use_talent = { id = Talents.T_BULL_SHOT, level = 4, power = 16 },
}

newEntity{ base = "BASE_ARROW",
	power_source = {technique=true},
	unique = true,
	name = "The Titan's Quiver", image = "object/artifact/the_titans_quiver.png",
	proj_image = "object/artifact/arrow_s_the_titans_quiver.png",
	unided_name = _t"gigantic ceramic arrows",
	desc = _t[[These massive arrows are honed to a vicious sharpness, and appear to be nearly unbreakable. They seem more like spikes than any arrow you've ever seen.]],
	color = colors.GREY,
	level_range = {35, 50},
	rarity = 300,
	cost = 150,
	material_level = 5,
	require = { stat = { dex=20, str=30 }, },
	combat = {
		capacity = 18,
		dam = 62,
		apr = 20,
		physcrit = 8,
		dammod = {dex=0.5, str=0.7},
		special_on_crit = {desc=_t"pin the target to the nearest wall", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:checkHit(who:combatPhysicalpower()*1.25, target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				game.logSeen(target, "%s is knocked back and pinned!", target:getName():capitalize())
				target:knockback(who.x, who.y, 10)
				target:setEffect(target.EFF_PINNED, 5, {}) --ignores pinning resistance, too strong!
			end
		end},
	},
}

newEntity{ base = "BASE_RING",
	power_source = {technique=true, psionic=true},
	name = "Inertial Twine", unique=true, image = "object/artifact/inertial_twine.png",
	desc = _t[[This double-helical ring seems resistant to attempts to move it. Wearing it seems to extend this property to your entire body.]],
	unided_name = _t"entwined iron ring",
	level_range = {17, 28},
	rarity = 250,
	cost = 300,
	material_level = 3,
	wielder = {
		combat_physresist = 12,
		inc_stats = {[Stats.STAT_WIL] = 8, [Stats.STAT_STR] = 4,},
		inc_damage={ [DamageType.PHYSICAL] = 5,},
		resists={[DamageType.PHYSICAL] = 5,},
		knockback_immune=1,
		combat_armor = 5,
	},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {nature=true, technique=true},
	unique = true,
	name = "Everpyre Blade",
	unided_name = _t"flaming wooden blade", image = "object/artifact/everpyre_blade.png",
	moddable_tile = "special/%s_everpyre_blade",
	moddable_tile_big = true,
	level_range = {28, 38},
	color=colors.RED,
	rarity = 300,
	metallic = false,
	desc = _t[[This ornate blade is carved from the wood of a tree said to burn eternally. Its hilt is encrusted with gems, suggesting it once belonged to a figure of considerable status. The flames seem to bend to the will of the sword's holder.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 4,
	combat = {
		dam = 38,
		apr = 10,
		physcrit = 18,
		dammod = {str=1},
		damtype = DamageType.FIRE,
		talent_on_hit = {
				[Talents.T_FIRE_BREATH] = {level=4, chance=15},
		},
	},
	wielder = {
		resists = {
			[DamageType.FIRE] = 15,
			[DamageType.NATURE] = 10,
		},
		inc_damage = {
			[DamageType.FIRE] = 20,
		},
		resists_pen = {
			[DamageType.FIRE] = 15,
		},
		inc_stats = { [Stats.STAT_STR] = 7, [Stats.STAT_WIL] = 7 },
	},
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	image = "object/artifact/eclipse.png",
	unided_name = _t"dark, radiant staff",
	flavor_name = "starstaff",
	flavors = {starstaff=true},
	name = "Eclipse", unique=true,
	desc = _t[[This tall staff is tipped with a pitch black sphere that yet seems to give off a strong light.]],
	require = { stat = { mag=32 }, },
	level_range = {10, 20},
	rarity = 200,
	cost = 60,
	material_level = 2,
	combat = {
		is_greater = true,
		dam = 18,
		staff_power = 15,
		apr = 4,
		physcrit = 3.5,
		dammod = {mag=1.1},
		element = DamageType.DARKNESS,
	},
	wielder = {
		combat_spellpower = 12,
		combat_spellcrit = 8,
		inc_damage={
			[DamageType.LIGHT] = 15,
			[DamageType.DARKNESS] = 15,
			[DamageType.PHYSICAL] = 15,
			[DamageType.TEMPORAL] = 15,
		},
		positive_regen=0.1,
		negative_regen=0.1,
		talent_cd_reduction = {
			[Talents.T_TWILIGHT] = 1,
			[Talents.T_SEARING_LIGHT] = 1,
			[Talents.T_MOONLIGHT_RAY] = 1,
		},
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1},
	},
}

newEntity{ base = "BASE_BATTLEAXE",
	power_source = {technique=true},
	unique = true,
	unided_name = _t"gore stained battleaxe",
	name = "Eksatin's Ultimatum", color = colors.GREY, image = "object/artifact/eskatins_ultimatum.png",
	moddable_tile = "special/%s_eskatins_ultimatum",
	moddable_tile_big = true,
	cost = 500,
	desc = _t[[This gore-stained battleaxe was once used by an infamously sadistic king, who took the time to personally perform each and every execution he ordered. He kept a vault of every head he ever removed, each and every one of them carefully preserved. When he was overthrown, his own head was added as the centrepiece of the vault, which was maintained as a testament to his cruelty.]],
	require = { stat = { str=50 }, },
	level_range = {39, 46},
	rarity = 300,
	material_level = 4,
	combat = {
		dam = 63,
		apr = 25,
		physcrit = 25,
		dammod = {str=1.3},
		special_on_crit = {desc=_t"decapitate a weakened target", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:checkHit(who:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("instakill") and target.life > 0 and ((target.life < target.max_life * 0.25 and target.rank < 3.5) or target.life < target.max_life * 0.10) then
				target:die(who)
				game.logSeen(target, "#RED#%s#GOLD# has been decapitated!#LAST#", target:getName():capitalize())
			end
		end},
	},
	wielder = {
		combat_critical_power = 25,
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Radiance", image = "object/artifact/radiance.png",
	unided_name = _t"a sparkling, golden cloak",
	desc = _t[[This pristine golden cloak flows with a wind that seems to be conjured from nowhere. Its inner surface is a completely plain white, but the outside shines with intense light.]],
	level_range = {45, 50},
	color = colors.GOLD,
	rarity = 500,
	cost = 300,
	material_level = 5,
	wielder = {
		combat_def = 15,
		combat_spellpower = 20,
		inc_stats = {
			[Stats.STAT_MAG] = 10,
			[Stats.STAT_CUN] = 10,
		},
		inc_damage = { [DamageType.LIGHT]= 25 },
		resists_cap = { [DamageType.LIGHT] = 10, },
		resists = { [DamageType.LIGHT] = 30, [DamageType.DARKNESS] = 30, },
		talents_mastery_bonus = {
			["celestial"] = 0.2,
		},
		on_melee_hit={[DamageType.LIGHT_BLIND] = 30},
	},
}

newEntity{ base = "BASE_HEAVY_BOOTS",
	power_source = {technique=true},
	unique = true,
	name = "Unbreakable Greaves", image = "object/artifact/unbreakable_greaves.png",
	unided_name = _t"huge stony boots",
	desc = _t[[These titanic boots appear to have been carved from stone. They appear weathered and cracked, but easily deflect all blows.]],
	color = colors.DARK_GRAY,
	level_range = {40, 50},
	rarity = 250,
	cost = 200,
	material_level = 5,
	wielder = {
		combat_armor = 20,
		combat_def = 8,
		fatigue = 12,
		combat_dam = 10,
		inc_stats = {
			[Stats.STAT_STR] = 20,
			[Stats.STAT_CON] = 10,
			[Stats.STAT_DEX] = -6,
		},
		knockback_immune=1,
		combat_armor_hardiness = 20,
		inc_damage = { [DamageType.PHYSICAL] = 15 },
		resists = { [DamageType.PHYSICAL] = 15,  [DamageType.ACID] = 15,},
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {arcane=true},
	unique = true, sentient=true,
	name = "The Untouchable", color = colors.BLUE, image = "object/artifact/the_untouchable.png",
	unided_name = _t"tough leather coat",
	desc = _t[[This rugged jacket is the subject of many a rural legend.
Some say it was fashioned by an adventurous mage turned rogue, in times before the Spellblaze, but was since lost.
All manner of shady gamblers have since claimed to have worn it at one point or another. To fail, but live, is what it means to be untouchable, they said.]],
	level_range = {20, 30},
	rarity = 200,
	cost = 350,
	require = { stat = { str=16 }, },
	material_level = 3,
	wearer_hp = 100,
	wielder = {
		combat_def=14,
		combat_armor=12,
		combat_apr=10,
		inc_stats = { [Stats.STAT_CUN] = 8, },
	},
	on_wear = function(self, who)
		self.worn_by = who
		self.wearer_hp = who.life / who.max_life
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	special_desc = function(self) return _t"When you take a hit of more than 20% of your max life a shield is created equal to 130% the damage taken." end,
	act = function(self)
		self:useEnergy()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		local hp_diff = (self.wearer_hp - self.worn_by.life/self.worn_by.max_life)

		if hp_diff >= 0.2 and not self.worn_by:hasEffect(self.worn_by.EFF_DAMAGE_SHIELD) then
			self.worn_by:setEffect(self.worn_by.EFF_DAMAGE_SHIELD, 4, {power = (hp_diff * self.worn_by.max_life)*1.3})
			game.logPlayer(self.worn_by, "#LIGHT_BLUE#A barrier bursts from the leather jacket!")
		end

		self.wearer_hp = self.worn_by.life/self.worn_by.max_life
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {nature = true},
	unique=true, rarity=240, image = "object/artifact/honeywood_chalice.png",
	type = "charm", subtype="totem",
	name = "Honeywood Chalice",
	unided_name = _t"sap filled cup",
	color = colors.BROWN,
	level_range = {30, 40},
	desc = _t[[This wooden cup seems perpetually filled with a thick sap-like substance. Tasting it is exhilarating, and you feel intensely aware when you do so.]],
	cost = 320,
	material_level = 4,
	wielder = {
		combat_physresist = 10,
		inc_stats = {[Stats.STAT_STR] = 5,},
		inc_damage={[DamageType.PHYSICAL] = 5,},
		resists={[DamageType.NATURE] = 10,},
		life_regen=0.15,
		healing_factor=0.1,

		learn_talent = {[Talents.T_BATTLE_TRANCE] = 1},
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "The Calm", color = colors.GREEN, image = "object/artifact/the_calm.png",
	unided_name = _t"ornate green robe",
	desc = _t[[This green robe is engraved with icons showing clouds and swirling winds. Its original owner, a powerful mage named Proccala, was often revered for both his great benevolence and his intense power when it proved necessary.]],
	level_range = {30, 40},
	rarity = 250,
	cost = 500,
	material_level = 4,
	special_desc = function(self) return _t"Your Lightning and Chain Lightning spells gain a 24% chance to daze, and your Thunderstorm spell gains a 12% chance to daze." end,
	wielder = {
		combat_spellpower = 20,
		inc_damage = {[DamageType.LIGHTNING]=25},
		combat_def = 15,
		inc_stats = { [Stats.STAT_MAG] = 10, [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6,},
		resists={[DamageType.LIGHTNING] = 20},
		resists_pen = { [DamageType.LIGHTNING] = 15 },
		slow_projectiles = 15,
		movement_speed = 0.1,
		lightning_daze_tempest=24,
	},
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {psionic=true},
	unique = true,
	name = "Omniscience", image = "object/artifact/omniscience.png",
	unided_name = _t"very plain leather cap",
	level_range = {40, 50},
	color=colors.WHITE,
	encumber = 1,
	rarity = 300,
	desc = _t[[This white cap is plain and dull, but as the light reflects off of its surface, you see images of faraway corners of the world in the sheen."]],
	cost = 200,
	material_level=5,
	wielder = {
		combat_def=7,
		combat_mindpower=20,
		combat_mindcrit=9,
		combat_mentalresist = 25,
		infravision=5,
		confusion_immune=0.4,
		resists = {[DamageType.MIND] = 15,},
		resists_cap = {[DamageType.MIND] = 10,},
		resists_pen = {[DamageType.MIND] = 10,},
		max_psi=50,
		psi_on_crit=6,
	},
	max_power = 30, power_regen = 1,
	use_power = { name = _t"reveal the surrounding area (range 20)", power = 30,
		no_npc_use = function(self, who) return not game.party:hasMember(who) end,
		use = function(self, who)
			game.logSeen(who, "%s grasps %s %s and has a sudden vision!", who:getName():capitalize(), who:his_her(), self:getName({do_color=true, no_add_name=true}))
			who:magicMap(20)
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {nature=true},
	unique = true,
	name = "Earthen Beads", color = colors.BROWN, image = "object/artifact/earthen_beads.png",
	unided_name = _t"strung clay beads",
	desc = _t[[This is a string of ancient, hardened clay beads, cracked and faded with age. It was used by Wilders in ancient times, in an attempt to enhance their connection with Nature.]],
	level_range = {10, 20},
	rarity = 200,
	cost = 100,
	material_level = 2,
	metallic = false,
	special_desc = function(self) return _t"Enhances the effectiveness of Meditation by 20%" end,
	wielder = {
		combat_mindpower = 5,
		enhance_meditate=0.2,
		inc_stats = { [Stats.STAT_WIL] = 5,},
		life_regen=2,
		damage_affinity={
			[DamageType.NATURE] = 15,
		},
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_NATURE_TOUCH, level = 2, power = 35 },
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true, nature=true}, --Perhaps it is of Dwarven make :)
	unique = true,
	name = "Hand of the World-Shaper", color = colors.BROWN, image = "object/artifact/hand_of_the_worldshaper.png",
	unided_name = _t"otherworldly stone gauntlets",
	desc = _t[[These heavy stone gauntlets make the very ground beneath you bend and warp as they move.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_MAG] = 6 },
		inc_damage = { [DamageType.PHYSICAL] = 12 },
		resists = { [DamageType.PHYSICAL] = 10 },
		resists_pen = { [DamageType.PHYSICAL] = 15 },
		combat_spellpower=10,
		combat_spellcrit = 10,
		combat_armor = 12,
		talents_types_mastery = {
			["spell/earth"] = 0.1,
			["spell/stone"] = 0.2,
			["wild-gift/sand-drake"] = 0.1,
		},
		combat = {
			dam = 38,
			apr = 10,
			physcrit = 7,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.1 },
			talent_on_hit = { T_EARTHEN_MISSILES = {level=5, chance=15},},
			damrange = 0.3,
			burst_on_hit = {
			[DamageType.GRAVITY] = 50,
			},
			burst_on_crit = {
			[DamageType.GRAVITYPIN] = 30,
			},
		},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_EARTHQUAKE, level = 4, power = 30 },
}

newEntity{ base = "BASE_CLOAK",
	power_source = {psionic=true},
	unique = true,
	name = "Guise of the Hated", image = "object/artifact/guise_of_the_hated.png",
	unided_name = _t"gloomy black cloak",
	desc = _t[[Forget the moons, the starry sky,
The warm and greeting sheen of sun,
The rays of light will never reach inside,
The heart which wishes that it be unseen.]],
	level_range = {40, 50},
	color = colors.BLACK,
	rarity = 370,
	cost = resolvers.rngrange(700,1200),
	material_level = 5,
	wielder = {
		combat_def = 14,
		combat_mindpower = 20,
		combat_mindcrit = 10,
		combat_physcrit = 10,
		inc_stealth=12,
		combat_mentalresist = 10,
		hate_per_kill = 5,
		hate_per_crit = 5,
		inc_stats = {
			[Stats.STAT_WIL] = 8,
			[Stats.STAT_CUN] = 6,
			[Stats.STAT_DEX] = 4,
		},
		inc_damage = { all = 4 },
		resists = {[DamageType.DARKNESS] = 10, [DamageType.MIND] = 10,},
		talents_types_mastery = {
			["cursed/gloom"] = 0.3,
			["cursed/darkness"] = 0.3,
		},
		on_melee_hit = {[DamageType.MIND] = 30, [DamageType.DARKNESS] = 30},
		melee_project = {[DamageType.MIND] = 30, [DamageType.DARKNESS] = 30},
		learn_talent = {[Talents.T_DARK_VISION] = 5},
	},
	talent_on_mind = { {chance=10, talent=Talents.T_CREEPING_DARKNESS, level=3}},
}

newEntity{ base = "BASE_KNIFE", --Thanks FearCatalyst/FlarePusher!
	power_source = {arcane=true},
	unique = true,
	name = "Spelldrinker", image = "object/artifact/spelldrinker.png",
	unided_name = _t"eerie black dagger",
	moddable_tile = "special/%s_spelldrinker",
	moddable_tile_big = true,
	desc = _t[[Countless mages have fallen victim to the sharp sting of this blade, betrayed by those among them with greed for ever greater power.
Passed on and on, this blade has developed a thirst of its own.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=30 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 27,
		apr = 8,
		physcrit = 9,
		dammod = {str=0.45, dex=0.55, mag=0.05},
		talent_on_hit = { T_DISPERSE_MAGIC = {level=1, chance=15},},
		special_on_hit = {desc=_t"steals up to 50 mana from the target", fct=function(combat, who, target)
			local manadrain = util.bound(target:getMana(), 0, 50)
			target:incMana(-manadrain)
			who:incMana(manadrain)
			local tg = {type="ball", range=10, radius=0, selffire=false}
			who:project(tg, target.x, target.y, engine.DamageType.ARCANE, manadrain)
		end},
	},
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 6, [Stats.STAT_CUN] = 6,},
		combat_spellresist=12,
		resists={
			[DamageType.ARCANE] = 12,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true},
	unique = true,
	name = "Frost Lord's Chain",
	unided_name = _t"ice coated chain", image = "object/artifact/frost_lords_chain.png",
	desc = _t[[This impossibly cold chain of frost-coated metal radiates a strange and imposing aura.]],
	color = colors.LIGHT_RED,
	level_range = {40, 50},
	rarity = 220,
	cost = 350,
	material_level = 5,
	special_desc = function(self) return _t"Gives all your cold damage a 20% chance to freeze the target." end,
	wielder = {
		combat_spellpower=12,
		inc_damage={
			[DamageType.COLD] = 12,
		},
		resists={
			[DamageType.COLD] = 25,
		},
		stun_immune = 0.3,
		on_melee_hit = {[DamageType.COLD]=10},
		cold_freezes = 20,
		iceblock_pierce=20,
		learn_talent = {[Talents.T_SHIV_LORD] = 2},
	},
}

newEntity{ base = "BASE_LONGSWORD", --Thanks BadBadger?
	power_source = {arcane=true},
	unique = true,
	name = "Twilight's Edge", image = "object/artifact/twilights_edge.png",
	unided_name = _t"shining long sword",
	moddable_tile = "special/%s_twilights_edge",
	moddable_tile_big = true,
	level_range = {32, 42},
	color=colors.GREY,
	rarity = 250,
	desc = _t[[The blade of this sword seems to have been forged of a mixture of voratun and stralite, resulting in a blend of swirling light and darkness.]],
	cost = 800,
	require = { stat = { str=35,}, },
	material_level = 4,
	combat = {
		dam = 47,
		apr = 7,
		physcrit = 12,
		dammod = {str=1},
		special_on_crit = {desc=_t"release a burst of light and dark damage (scales with Magic)", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=10, radius=2, selffire=false}
			who:project(tg, target.x, target.y, engine.DamageType.LIGHT, 40 + who:getMag()*0.6)
			who:project(tg, target.x, target.y, engine.DamageType.DARKNESS, 40 + who:getMag()*0.6)
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "shadow_flash", {radius=tg.radius})
		end},
	},
	wielder = {
		lite = 1,
		combat_spellpower = 12,
		combat_spellcrit = 4,
		inc_damage={
			[DamageType.DARKNESS] = 18,
			[DamageType.LIGHT] = 18,
		},
		inc_stats = { [Stats.STAT_MAG] = 4, [Stats.STAT_STR] = 4, [Stats.STAT_CUN] = 4, },
	},
}

newEntity{ base = "BASE_RING",
	power_source = {psionic=true},
	name = "Mnemonic", unique=true, image = "object/artifact/mnemonic.png",
	desc = _t[[As long as you wear this ring, you will never forget who you are.]],
	unided_name = _t"familiar ring",
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level = 5,
	special_desc = function(self) return _t"When using a mental talent, gives a 10% chance to lower the current cooldowns of up to three of your wild gift, psionic, or cursed talents by three turns." end,
	wielder = {
		combat_mentalresist = 20,
		combat_mindpower = 12,
		inc_stats = {[Stats.STAT_WIL] = 8,},
		resists={[DamageType.MIND] = 25,},
		confusion_immune=0.4,
		talents_types_mastery = {
			["psionic/mentalism"]=0.2,
		},
		psi_regen=0.5,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_MENTAL_SHIELDING, level = 2, power = 30 },
	talent_on_mind = { {chance=10, talent=Talents.T_MENTAL_REFRESH, level=1}},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Acera",
	unided_name = _t"corroded sword", image = "object/artifact/acera.png",
	moddable_tile = "special/%s_acera",
	moddable_tile_big = true,
	level_range = {25, 35},
	color=colors.GREEN,
	rarity = 300,
	desc = _t[[This warped, blackened sword drips acid from its countless pores.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 3,
	combat = {
		dam = 33,
		apr = 4,
		physcrit = 10,
		damtype = DamageType.ACID,
		dammod = {str=1},
		burst_on_crit = {
			[DamageType.ACID_CORRODE] = 40,
		},
	},
	wielder = {
		inc_damage={ [DamageType.ACID] = 20,},
		resists={[DamageType.ACID] = 15,},
		resists_pen={[DamageType.ACID] = 20,}, --Burns right through your pathetic ACID resists
		combat_physcrit = 10,
		combat_spellcrit = 10,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_CORROSIVE_WORM, level = 4, power = 30 },
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {technique=true},
	define_as = "DOUBLESWORD",
	name = "Borosk's Hate", unique=true, image="object/artifact/borosks_hate.png",
	moddable_tile = "special/%s_borosks_hate",
	unided_name = _t"double-bladed sword", color=colors.GREY,
	desc = _t[[This impressive looking sword features two massive blades aligned in parallel. They seem weighted remarkably well.]],
	require = { stat = { str=35 }, },
	level_range = {40, 50},
	rarity = 240,
	cost = 280,
	material_level = 5,
	running=false,
	combat = {
		dam = 60,
		apr = 22,
		physcrit = 10,
		dammod = {str=1.2},
		special_on_hit = {desc=_t"25% chance to strike the target again.", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "DOUBLESWORD")
			if not o or not who:getInven(inven_id).worn then return end
			if o.running == true then return end
			if not rng.percent(25) then return end
			o.running=true
			who:attackTarget(target, engine.DamageType.PHYSICAL, 1,  true)
			o.running=false
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 10, [Stats.STAT_DEX] = 5, [Stats.STAT_CON] = 15 },
		talents_types_mastery = {
			["technique/2hweapon-assault"] = 0.2,
		},
	},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {technique=true, psionic=true}, define_as = "BUTCHER",
	name = "Butcher", unique=true, image="object/artifact/butcher.png",
	unided_name = _t"blood drenched shortsword", color=colors.CRIMSON,
	moddable_tile = "special/%s_butcher",
	moddable_tile_big = true,
	desc = _t[[Be it corruption, madness or eccentric boredom, the halfling butcher by the name of Caleb once took to eating his kin instead of cattle. His spree was never ended and nobody knows where he disappeared to. Only the blade remained, stuck fast in a bloodied block. Beneath, a carving said "This was fun, let's do it again some time."]],
	require = { stat = { str=40 }, },
	level_range = {36, 48},
	rarity = 250,
	cost = 300,
	material_level = 5,
	running=false,
	special_desc = function(self)
		local maxp = self:min_power_to_trigger()
		return ("Enter Rampage if health falls below 20%%%s"):tformat(self.power < maxp and (" (cooling down: %d turns)"):tformat(maxp - self.power) or "")
	end,
	combat = {
		dam = 48,
		apr = 12,
		physcrit = 10,
		dammod = {str=1},
		special_on_hit = {desc=_t"Attempt to devour a low HP enemy, striking again and possibly killing it instantly.", fct=function(combat, who, target)
			local Talents = require "engine.interface.ActorTalents"
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "BUTCHER")
			if not o or not who:getInven(inven_id).worn then return end
			if target.life / target.max_life > 0.15 or o.running==true then return end
			local Talents = require "engine.interface.ActorTalents"
			o.running=true
			if target:canBe("instakill") then
				who:forceUseTalent(Talents.T_SWALLOW, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=4, ignore_ressources=true})
			end
			o.running=false
		end},
		special_on_kill = {desc=_t"Enter a Rampage (Shared cooldown).", fct=function(combat, who, target)
			if who:hasEffect(who.EFF_RAMPAGE) then return end
			local Talents = require "engine.interface.ActorTalents"
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "BUTCHER")
			if not o or not who:getInven(inven_id).worn then return end
			if o.power < o:min_power_to_trigger() then return end
			who:forceUseTalent(Talents.T_RAMPAGE, {ignore_cd=true, ignore_energy=true, force_level=2, ignore_ressources=true})
			o.power = 0
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_CUN] = 7, [Stats.STAT_STR] = 10, [Stats.STAT_WIL] = 10, },
		talents_types_mastery = {
			["cursed/rampage"] = 0.2,
			["cursed/slaughter"] = 0.2,
		},
		combat_atk = 18,
	},
	max_power = 30, power_regen = 1,
	min_power_to_trigger = function(self) return self.max_power * (self.worn_by and (100 - (self.worn_by:attr("use_object_cooldown_reduce") or 0))/100 or 1) end, -- special handling of the Charm Mastery attribute
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	callbackOnTakeDamage = function(self, who, src, x, y, type, dam, state) -- Trigger Rampage
		if not self.worn_by or self.power < self:min_power_to_trigger() then return end
		if (who.life - dam)/who.max_life >=0.2 then return end
		game:onTickEnd(function() -- make sure all damage has been resolved
			if who.life/who.max_life < 0.2 and not who:hasEffect(who.EFF_RAMPAGE) then
				local Talents = require "engine.interface.ActorTalents"
				who:forceUseTalent(Talents.T_RAMPAGE, {ignore_cd=true, ignore_energy=true, force_level=2, ignore_ressources=true})
				self.power=0
				end
			end
		)
	end,
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Ethereal Embrace", image = "object/artifact/ethereal_embrace.png",
	unided_name = _t"wispy purple cloak",
	desc = _t[[This cloak waves and bends with shimmering light, reflecting the depths of space and the heart of the Aether.]],
	level_range = {30, 40},
	rarity = 400,
	cost = 250,
	material_level = 4,
	special_desc = function(self) return (_t"Damage shields have +1 duration and +15% power") end,
	wielder = {
		combat_spellcrit = 6,
		combat_def = 10,
		inc_stats = {
			[Stats.STAT_MAG] = 8,
		},
		talents_types_mastery = {
			["spell/arcane"] = 0.2,
			["spell/nightfall"] = 0.2,
			["spell/aether"] = 0.1,
		},
		spellsurge_on_crit = 5,
		inc_damage={ [DamageType.ARCANE] = 15, [DamageType.DARKNESS] = 15, },
		resists={ [DamageType.ARCANE] = 12, [DamageType.DARKNESS] = 12,},
		shield_factor=15,
		shield_dur=1,
	},
	max_power = 28, power_regen = 1,
	use_talent = { id = Talents.T_AETHER_BREACH, level = 2, power = 28 },
}

newEntity{ base = "BASE_HEAVY_BOOTS",
	power_source = {psionic=true},
	unique = true,
	name = "Boots of the Hunter", image = "object/artifact/boots_of_the_hunter.png",
	unided_name = _t"well-worn boots",
	desc = _t[[These cracked boots are caked with a thick layer of mud. It isn't clear who they previously belonged to, but they've clearly seen extensive use.]],
	color = colors.BLACK,
	level_range = {30, 40},
	rarity = 240,
	cost = 280,
	material_level = 4,
	use_no_energy = true,
	wielder = {
		combat_armor = 12,
		combat_def = 2,
		combat_dam = 12,
		combat_apr = 15,
		fatigue = 8,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		max_life = 80,
		stun_immune=0.4,
		talents_types_mastery = {
			["cursed/predator"] = 0.2,
			["cursed/endless-hunt"] = 0.2,
			["cunning/trapping"] = 0.2,
		},
	},
	max_power = 32, power_regen = 1,
	on_wear = function(self, who)
		self.worn_by = who
		self.use_power.t_bias = 0
	end,
	on_takeoff = function(self, who) self.worn_by = nil end,
	act = function(self) -- update tactical bias
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		local who = self.worn_by
		local UP = self.use_power
		if math.abs(UP.t_bias) ~= 0 then
			UP.t_bias = util.bound(UP.t_bias + (UP.t_bias > 1 and -1 or 1), -10, 10)
		end
--print(("%s acting: worn by %s with tactic %s, bias: %s"):tformat(self.name, who:getName(), who.ai_state.tactic, UP.t_bias))

	end,
	use_power = { name = _t"boost movement speed by 300% for up to 5 turns (or until you perform a non-movement action)", power = 32,
		t_bias = 0, -- keeps track of tactical use
		on_pre_use_ai = function(self, who) return not who:attr("never_move") and not who:attr("cant_be_moved") and not who:hasEffect(who.EFF_HUNTER_SPEED) end,
		tactical = function(self, who, aitarget)
			local TB = self.use_power.t_bias
			local tac = {}
			tac.closein = 0.5 + TB/10
			tac.escape = 0.5 - TB/10
			return tac
		end,
		use = function(self, who)
			game.logSeen(who, "%s digs in %s %s.", who:getName():capitalize(), who:his_her(), self:getName({do_color=true, no_add_name = true}))
			if not who.player then -- NPCs keep track of tactics to prevent overuse
				local UP = self.use_power
				if who.ai_state.tactic == "closein" then
					UP.t_bias = UP.t_bias + 10
				elseif who.ai_state.tactic == "escape" then
					UP.t_bias = UP.t_bias - 10
				end
			end
			who:setEffect(who.EFF_HUNTER_SPEED, 5, {power=300})
			return {id=true, used=true, nobreakStepUp = true}
		end
	},
}

newEntity{ base = "BASE_GLOVES",
	power_source = {nature=true},
	unique = true,
	name = "Sludgegrip", color = colors.GREEN, image = "object/artifact/sludgegrip.png",
	unided_name = _t"slimy gloves",
	desc = _t[[These gloves are coated with a thick, green liquid.]],
	level_range = {1, 10},
	rarity = 190,
	cost = 70,
	material_level = 1,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 4,},
		resists = { [DamageType.NATURE]= 10, },
		inc_damage = { [DamageType.NATURE]= 5, },
		combat_mindpower=2,
		poison_immune=0.2,
		talents_types_mastery = {
			["wild-gift/slime"] = 0.2,
		},
		combat = {
			dam = 6,
			apr = 7,
			physcrit = 4,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			talent_on_hit = { T_SLIME_SPIT = {level=1, chance=35} },
		},
	},
}

newEntity{ base = "BASE_RING", define_as = "SET_LICH_RING",
	power_source = {arcane=true},
	unique = true,
	name = "Ring of the Archlich", image = "object/artifact/ring_of_the_archlich.png",
	unided_name = _t"dusty, cracked ring",
	desc = _t[[This ring is filled with an overwhelming, yet restrained, power. It lashes, grasps from its metal prison, searching for life to snuff out. You alone are unharmed.
Perhaps it feels all the death you will bring to others in the near future.]],
	color = colors.DARK_GREY,
	level_range = {30, 40},
	cost = 170,
	rarity = 280,
	material_level = 4,
	wielder = {
		max_soul = 3,
		combat_spellpower=8,
		combat_spellresist=8,
		inc_damage={[DamageType.DARKNESS] = 10, [DamageType.COLD] = 10, },
		poison_immune=0.25,
		cut_immune=0.25,
		resists={ [DamageType.COLD] = 10, [DamageType.DARKNESS] = 10,},
	},
	max_power = 40, power_regen = 1,
	set_list = { {"define_as", "SET_SCEPTRE_LICH"} },
	set_desc = {
		archlich = _t"It desires to be surrounded by undeath.",
	},
	on_set_complete = function(self, who)
		game.logPlayer(who, "#DARK_GREY#Your ring releases a burst of necromantic energy!")
		self:specialSetAdd({"wielder","combat_spellpower"}, 10)
		self.use_talent = { id = "T_IMPENDING_DOOM", level = 2, power = 40 }
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.DARKNESS] = 14 })
		self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.DARKNESS] = 5 })
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#DARK_GREY#Your ring's power fades away.")
		self.use_talent = nil
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {arcane = true},
	unique=true, rarity=240,
	type = "charm", subtype="wand",
	name = "Lightbringer's Wand", image = "object/artifact/lightbringers_rod.png",
	unided_name = _t"bright wand",
	color = colors.GOLD,
	level_range = {20, 30},
	desc = _t[[This gold-tipped wand shines with an unnatural sheen.]],
	cost = 320,
	material_level = 3,
	wielder = {
		resists={[DamageType.DARKNESS] = 12, [DamageType.LIGHT] = 12},
		inc_damage={[DamageType.LIGHT] = 10},
		on_melee_hit={[DamageType.LIGHT] = 18},
		combat_spellresist = 15,
		lite=2,
	},
		max_power = 35, power_regen = 1,
	use_power = { name = function(self, who)
			local dam = who:damDesc(engine.DamageType.LIGHT, self.use_power.damage(self, who))
			return ("summon a stationary shining orb within range %d for 15 turns that will illuminate its area and deal %d light damage (based on your Magic and Strength) to your foes within radius %d each turn"):tformat(self.use_power.range, dam, self.use_power.radius)
		end,
		power = 35,
		range = 5,
		radius = 5,
		damage = function(self, who) return (who:getMag()*2 + who:getStr())/3 + 20 end,
		target = function(self, who) return {type="ball", nowarning=true, range=self.use_power.range, radius=self.use_power.radius, friendlyfire=false, nolock=true} end,
		requires_target = true,
		tactical = {ATTACKAREA = {LIGHT = 2}},
		no_npc_use = function(self, who) return self:restrictAIUseObject(who) end,
		use = function(self, who)
			if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end
			local tg = self.use_power.target(self, who)
			local tx, ty, target = who:getTarget(tg)
			if not tx or not ty then return nil end
			local _ _, _, _, tx, ty = who:canProject(tg, tx, ty)
			target = game.level.map(tx, ty, engine.Map.ACTOR)
			if target == who then target = nil end
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			local Talents = require "engine.interface.ActorTalents"
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_ghost_will_o__the_wisp.png", display_h=1, display_y=0}}},
				name = _t"Lightbringer",
				type = "orb", subtype = "light",
				desc = _t"A shining orb.",
				rank = 1,
				blood_color = colors.YELLOW,
				display = "T", color=colors.YELLOW,
				life_rating=10,
				combat = {
					dam=resolvers.rngavg(50,60),
					atk=resolvers.rngavg(50,75), apr=25,
					dammod={mag=1}, physcrit = 10,
					damtype=engine.DamageType.LIGHT,
				},
				level_range = {1, nil}, exp_worth = 0,
				silent_levelup = true,
				combat_armor=30,
				combat_armor_hardiness=30,
				autolevel = "caster",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				never_move=1,
				stats = { str=14, dex=18, mag=20, con=12, wil=20, cun=20, },
				size_category = 2,
				lite=10,
				blind=1,
				esp_all=1,
				resists={[engine.DamageType.LIGHT] = 100, [engine.DamageType.DARKNESS] = 100},
				inc_damage = table.clone(who.inc_damage),
				resists_pen = table.clone(who.resists_pen),
				no_breath = 1,
				cant_be_moved = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 1,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				knockback_resist=1,
				combat_physresist=50,
				combat_spellresist=100,
				light_damage = self.use_power.damage(self, who),
				light_radius = self.use_power.radius,
				on_act = function(self)
					game.level.map:particleEmitter(self.x, self.y, self.light_radius, "ball_light", {radius=self.light_radius, tx=self.x, ty=self.y, max_alpha=25})
					self:project({type="ball", range=0, radius=self.light_radius, friendlyfire=false}, self.x, self.y, engine.DamageType.LITE_LIGHT, self.light_damage)
				end,
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time=15,
			}

			m:resolve()
			who:logCombat(target or {name = _t"a spot nearby"}, "#Source# points %s %s at #target#, releasing a brilliant orb of light!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true
			if game.party:hasMember(who) then
				game.party:addMember(m, {
					control=false,
					temporary_level = true,
					type="summon",
					title=_t"Summon",
					orders = {target=true, leash=true, anchor=true, talents=true},
				})
			end
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	unided_name = _t"handled hole in space",
	name = "Temporal Rift", image = "object/artifact/temporal_rift.png",
	moddable_tile = "special/%s_temporal_rift",
	moddable_tile_big = true,
	desc = _t[[Some mad Chronomancer appears to have affixed a handle to this hole in spacetime. It looks highly effective, in its own strange way.]],
	color = colors.LIGHT_GREY,
	rarity = 300,
	metallic = false,
	level_range = {35, 45},
	require = { stat = { str=40 }, },
	cost = 400,
	material_level = 5,
	special_combat = {
		dam = 50,
		block = 325,
		physcrit = 4.5,
		dammod = {str=1, mag=0.2},
		damtype = DamageType.TEMPORAL,
		talent_on_hit = { [Talents.T_TURN_BACK_THE_CLOCK] = {level=3, chance=25} },
	},
	wielder = {
		combat_armor = 4,
		combat_def = 8,
		combat_def_ranged = 10,
		fatigue = 0,
		combat_spellpower=12,
		combat_spellresist = 20,
		resists = {[DamageType.TEMPORAL] = 30},
		learn_talent = { [Talents.T_BLOCK] = 1, },
		flat_damage_armor = {all=20},
		slow_projectiles = 50,
	},
}

newEntity{ base = "BASE_ARROW",
	power_source = {technique=true},
	unique = true,
	name = "Arkul's Siege Arrows", image = "object/artifact/arkuls_seige_arrows.png",
	moddable_tile = "special/arkuls_seige_arrows",
	proj_image = "object/artifact/arrow_s_arkuls_seige_arrows.png",
	unided_name = _t"gigantic spiral arrows",
	desc = _t[[These titanic double-helical arrows seem to have been designed more for knocking down towers than for use in regular combat. They'll no doubt make short work of most foes.]],
	color = colors.GREY,
	level_range = {42, 50},
	rarity = 400,
	cost = 400,
	material_level = 5,
	require = { stat = { dex=20, str=30 }, },
	special_desc = function(self) return _t"25% of all damage splashes in a radius of 1 around the target." end,
	combat = {
		capacity = 14,
		dam = 68,
		apr = 100,
		physcrit = 10,
		dammod = {dex=0.5, str=0.7},
		siege_impact=0.25,
	},
}

newEntity{ base = "BASE_LONGSWORD", --For whatever artists draws this: it's a rapier.
	power_source = {technique=true},
	unique = true,
	name = "Punae's Blade",
	unided_name = _t"thin blade", image = "object/artifact/punaes_blade.png",
	moddable_tile = "special/%s_punaes_blade",
	moddable_tile_big = true,
	level_range = {28, 38},
	color=colors.GREY,
	rarity = 300,
	desc = _t[[This very thin sword cuts through the air with ease, allowing remarkably quick movement.]],
	cost = 400,
	require = { stat = { str=30 }, },
	material_level = 4,
	combat = {
		dam = 46,
		apr = 4,
		physcrit = 10,
		dammod = {str=1},
	},
	wielder = {
		evasion=10,
		combat_def = 40,
		combat_physcrit = 20,
		combat_physspeed = 0.2,
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR", --Thanks SageAcrin!
	power_source = {psionic=true},
	unique = true,
	name = "Crimson Robe", color = colors.RED, image = "object/artifact/crimson_robe.png",
	unided_name = _t"blood-stained robe",
	desc = _t[[This robe was formerly owned by Callister the Psion, a powerful Psionic that pioneered many Psionic abilities. After his wife was murdered, Callister became obsessed with finding her killer, using his own hatred as a fuel for new and disturbing arts. After forcing the killer to torture himself to death, Callister walked the land, forcing any he found to kill themselves - his way of releasing them from the world's horrors. One day, he simply disappeared. This robe, soaked in blood, was the only thing he left behind.]],
	level_range = {40, 50},
	rarity = 230,
	cost = 350,
	material_level = 5,
	special_desc = function(self) return _t"Increases your solipsism threshold by 20% (if you have one). If you do, also grants 15% global speed when worn." end,
	wielder = {
		combat_def=12,
		inc_stats = { [Stats.STAT_WIL] = 10, [Stats.STAT_CUN] = 10, },
		combat_mindpower = 20,
		combat_mindcrit = 9,
		psi_regen=0.2,
		psi_on_crit = 4,
		hate_on_crit = 4,
		hate_per_kill = 2,
		resists_pen={all = 20},
		on_melee_hit={[DamageType.MIND] = 35, [DamageType.RANDOM_GLOOM] = 10},
		melee_project={[DamageType.MIND] = 35, [DamageType.RANDOM_GLOOM] = 10},
		talents_types_mastery = { ["psionic/solipsism"] = 0.1, ["psionic/focus"] = 0.2, ["cursed/slaughter"] = 0.2, ["cursed/punishments"] = 0.2,},
	},
	on_wear = function(self, who)
		if who:attr("solipsism_threshold") then
			self:specialWearAdd({"wielder","solipsism_threshold"}, 0.2)
			self:specialWearAdd({"wielder","global_speed_add"}, 0.15)
			game.logPlayer(who, "#RED#You feel yourself lost in the aura of the robe.")
		end
		if who.descriptor and who.descriptor.subclass == "Doomed" then
			local Talents = require "engine.interface.ActorTalents"
			self.talent_on_mind = {
				{chance=8, talent=Talents.T_CURSED_BOLT, level=2},
				{chance=8, talent=Talents.T_WAKING_NIGHTMARE, level=2 }
			}
			game.logPlayer(who, "#RED#The robe drapes comfortably over your doomed body.")
		end
	end,
	talent_on_mind  = { {chance=8, talent=Talents.T_HATEFUL_WHISPER, level=2}, {chance=8, talent=Talents.T_AGONY, level=2}  },
}

newEntity{ base = "BASE_RING", --Thanks Alex!
	power_source = {arcane=true},
	name = "Exiler", unique=true, image = "object/artifact/exiler.png",
	desc = _t[[The chronomancer known as Solith was renowned across all of Eyal. He always seemed to catch his enemies alone.
In the case of opponents who weren't alone, he had to improvise.]],
	unided_name = _t"insignia ring",
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level = 5,
	wielder = {
		combat_spellpower = 10,
		paradox_reduce_anomalies = 10,
		talent_cd_reduction={
			[Talents.T_TIME_SKIP]=1,
		},
		inc_damage={ [DamageType.TEMPORAL] = 15, [DamageType.PHYSICAL] = 10, },
		resists={ [DamageType.TEMPORAL] = 15,},
		melee_project={ [DamageType.TEMPORAL] = 15,},
		talents_types_mastery = {
 			["chronomancy/timetravel"] = 0.2,
 		},
	},
	talent_on_spell = { {chance=10, talent="T_RETHREAD", level = 2} },
	max_power = 32, power_regen = 1,
	use_power = {
		name = function(self, who)
			local Talents = require "engine.interface.ActorTalents"
			local tal = Talents:getTalentFromId(Talents.T_TIME_SKIP)
			local oldlevel = who.talents[Talents.T_TIME_SKIP]
			who.talents[Talents.T_TIME_SKIP] = 2 --Set up to calculate damage accurately
			local dam = who:damDesc(engine.DamageType.TEMPORAL, who:callTalent(Talents.T_TIME_SKIP, "getDamage", who, tal))
			local dur = who:callTalent(Talents.T_TIME_SKIP, "getDuration", who, tal)
			who.talents[Talents.T_TIME_SKIP] = oldlevel
			return ("attempt to inflict %0.2f temporal damage (based on Spellpower and Paradox, if any) on foes in a radius %d ball out to range %d (chance depends on rank, summons are always affected), removing any that survive from time for up to %d turn(s)"):tformat(dam, self.use_power.radius, self.use_power.range, dur)
		end,
		power = 32,
		range =5,
		radius = 2,
		target = function(self, who) return {type="ball", range=self.use_power.range, radius=self.use_power.radius, friendlyfire = false} end,
		requires_target = true,
		tactical = {ATTACKAREA = function(who, t, aitarget) -- count # of summons in area
			if not who.aiSeeTargetPos or not aitarget then return end
			local o = t.is_object_use and t.getObject(who, t)
			if not o then return end
			local ok, nb
			local tg = o.use_power.target(o, who)
			local x, y = who:aiSeeTargetPos(aitarget)
			ok, nb, nb, x, y = who:canProject(tg, x, y)
			nb = 0
			if ok then who:project(o.use_power.target(o, who), x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if target.summoner then
					nb = nb + 1
				else
					nb = nb + 1/(target.rank or 5)
				end
			end) end
			return {temporal = nb}
		end},
		use = function(self, who)
			local Talents = require "engine.interface.ActorTalents"
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			game.logSeen(who, "%s focuses time flows through %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color=true, no_add_name=true}))
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if target.summoner or rng.chance(target.rank or 5) then -- works on summons or low rank enemies
					who:forceUseTalent(Talents.T_TIME_SKIP, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=2, ignore_ressources=true, silent = true})
				end
			end)
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	name = "Piercing Gaze", image = "object/artifact/piercing_gaze.png",
	moddable_tile = "special/%s_piercing_gaze",
	moddable_tile_big = true,
	unided_name = _t"stone-eyed shield",
	desc = _t[[This gigantic shield has a stone eye embedded in it.]],
	color = colors.BROWN,
	level_range = {30, 40},
	rarity = 270,
	--require = { stat = { str=28 }, },
	cost = 400,
	material_level = 4,
	metallic = false,
	special_combat = {
		dam = 40,
		block = 180,
		physcrit = 5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 25,
		combat_def = 5,
		combat_def_ranged = 10,
		fatigue = 12,
		learn_talent = { [Talents.T_BLOCK] = 1, },
		resists = { [DamageType.PHYSICAL] = 10, [DamageType.ACID] = 10, [DamageType.LIGHTNING] = 10, [DamageType.FIRE] = 10,},
	},
	on_block = {desc = _t"30% chance of petrifying the attacker.", fct = function(self, who, src, type, dam, eff)
		if rng.percent(30) then
			if not src then return end
			game.logSeen(src, "The eye locks onto %s, freezing it in place!", src:getName():capitalize())
			if src.canBe and src:canBe("stun") and src:canBe("stone") and src:canBe("instakill") then
				src:setEffect(who.EFF_STONED, 5, {})
			end
		end
	end,}
}

newEntity{ base = "BASE_KNIFE", --Shibari's #1
	power_source = {nature=true},
	unique = true,
	name = "Shantiz the Stormblade",
	unided_name = _t"thin stormy blade", image = "object/artifact/shantiz_the_stromblade.png",
	moddable_tile = "special/%s_shantiz_the_stromblade",
	moddable_tile_big = true,
	level_range = {18, 33},
	material_level = 3,
	rarity = 300,
	desc = _t[[This surreal dagger crackles with the intensity of a vicious storm.]],
	cost = 400,
	color=colors.BLUE,
	require = { stat = { dex=30}},
	combat = {
		dam = 15,
		apr = 20,
		physcrit = 10,
		dammod = {dex=1},
		special_on_hit = {desc=_t"Causes lightning to strike and destroy any projectiles in a radius of 10, dealing damage and dazing enemies in a radius of 5 around them.", on_kill=1, fct=function(combat, who, target)
			local grids = core.fov.circle_grids(who.x, who.y, 10, true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local i = 0
				local p = game.level.map(x, y, engine.Map.PROJECTILE+i)
				while p do
					local DamageType = require "engine.DamageType"
					if p.src and p.src:reactionToward(who) >= 0 then return end -- Let's not destroy friendly projectiles
					if p.name then
						game.logPlayer(who, "#GREEN#Lightning strikes the " .. p.name .. "!")
					else
						game.logPlayer(who, "#GREEN#Shantiz strikes down a projectile!")
					end

					p:terminate(x, y)
					game.level:removeEntity(p, true)
					p.dead = true
					game.level.map:particleEmitter(x, y, 5, "ball_lightning_beam", {radius=5, tx=x, ty=y})

					local tg = {type="ball", radius=5, friendlyfire=false} -- Let's not kill pets or escorts with uncontrolled AoE
					local dam = 3*who:getDex()

					who:project(tg, x, y, DamageType.LIGHTNING, dam)

					who:project(tg, x, y, function(tx, ty)
							local target = game.level.map(tx, ty, engine.Map.ACTOR)
							if not target or target == who then return end
							target:setEffect(target.EFF_DAZED, 3, {apply_power=who:combatAttack()})
					end)

					i = i + 1
					p = game.level.map(x, y, engine.Map.PROJECTILE+i)
				end end end
			return
			end
		},
	},
	wielder = {
		inc_stats = { [Stats.STAT_DEX] = 20 },
		slow_projectiles = 40,
		quick_weapon_swap = 1,
	},
}

newEntity{ base = "BASE_KNIFE",
	power_source = {technique=true},
	unique = true,
	name = "Swordbreaker", image = "object/artifact/swordbreaker.png",
	unided_name = _t"hooked blade",
	moddable_tile = "special/%s_swordbreaker",
	moddable_tile_big = true,
	desc = _t[[This ordinary blade is made of fine, sturdy voratun and outfitted with jagged hooks along the edge. This simple appearance belies a great power - the hooked maw of this dagger broke many a blade and the stride of many would-be warriors.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=10, cun=10 }, },
	cost = 300,
	material_level = 3,
	special_desc = function(self) return _t"Can block like a shield, potentially disarming the enemy." end,
	combat = {
		dam = 25,
		apr = 20,
		physcrit = 15,
		physspeed = 0.9,
		dammod = {dex=0.5,cun=0.5},
		special_on_crit = {desc=_t"Breaks enemy weapon.", fct=function(combat, who, target)
			target:setEffect(target.EFF_SUNDER_ARMS, 5, {power=5+(who:combatPhysicalpower()*0.33), apply_power=who:combatPhysicalpower()})
		end},
	},
	wielder = {
		combat_def = 15,
		disarm_immune=0.5,
		combat_physresist = 15,
		inc_stats = {
			[Stats.STAT_DEX] = 8,
			[Stats.STAT_CUN] = 8,
		},
		combat_armor_hardiness = 20,
		learn_talent = { [Talents.T_DAGGER_BLOCK] = 1, },
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	name = "Shieldsmaiden", image = "object/artifact/shieldmaiden.png",
	unided_name = _t"icy shield",
	moddable_tile = "special/%s_shieldmaiden",
	moddable_tile_big = true,
	desc = _t[[Myths tell of shieldsmaidens, a tribe of warrior women from the northern wastes of Maj'Eyal. Their martial prowess and beauty drew the fascination of swaths of admirers, yet all unrequited. So began the saying, that a shieldsmaiden's heart is as cold and unbreakable as her shield.]],
	color = colors.BLUE,
	level_range = {36, 48},
	rarity = 270,
	require = { stat = { str=28 }, },
	cost = 400,
	material_level = 5,
	metallic = false,
	special_desc = function(self) return _t"Granted talent can block up to 1 instance of damage each 10 turns." end,
	special_combat = {
		dam = 48,
		block = 150,
		physcrit = 8,
		dammod = {str=1},
		damtype = DamageType.ICE,
		talent_on_hit = { [Talents.T_ICE_SHARDS] = {level=3, chance=15} },
	},
	wielder = {
		combat_armor = 20,
		combat_def = 5,
		combat_def_ranged = 12,
		fatigue = 10,
		learn_talent = { [Talents.T_BLOCK] = 1, [Talents.T_SHIELDSMAIDEN_AURA] = 1,  },
		resists = { [DamageType.COLD] = 25, [DamageType.FIRE] = 25,},
	},
}

-- Thanks to Naghyal's Beholder code for the basic socket skeleton
newEntity{ base = "BASE_GREATMAUL",
	power_source = {arcane=true},
	unique = true,
	color = colors.BLUE,
	name = "Tirakai's Maul", image = "object/artifact/tirakais_maul.png",
	desc = _t[[This massive hammer is formed from a thick mass of strange crystalline growths. In the side of the hammer itself you see an empty slot; it looks like a gem of your own could easily fit inside it.]],
	moddable_tile = "special/%s_tirakais_maul", moddable_tile_big = true,
	gemdesc = _t"None", -- Defined by the elemental properties and used by special_desc
	special_desc = function(self)
		-- You'll want to color this and such
		if not self.Gem then return (_t"No gem") end
		return ("%s: %s"):tformat(self.Gem:getName():capitalize(), self.gemDesc or (_t"Write a description for this gem's properties!"))
	end,
	cost = 1000,
	material_level = 2, -- Changes to gem material level on socket
	level_range = {1, 30},
	rarity = 280,
	combat = {
		dam = 32,
		apr = 6,
		physcrit = 8,
		damrange=1.3,
		dammod = {str=1.2, mag=0.1},
	},
	-- executed for specific gems.
	-- key corresponds to: gem.define_as or gem.name
	unique_gems = {
		GOEDALATH_ROCK = function(maul, gem)
			maul.combat.damtype = 'SHADOWFLAME'
			table.mergeAdd(maul.wielder, {
					inc_damage = {FIRE = 3 * gem.material_level, DARKNESS = 3 * gem.material_level,},
					resists_pen = {all = 2 * gem.material_level},},
				true)
			maul.gemDesc = _t"Demonic"
		end,},
	max_power = 10, power_regen = 1,
	use_power = { name = _t"imbue the hammer with a gem of your choice", power = 10,
		no_npc_use = true,
		use = function(self, who)
			local DamageType = require "engine.DamageType"
			local Stats = require "engine.interface.ActorStats"
			local d
			d = who:showInventory(_t"Use which gem?", who:getInven("INVEN"), function(gem) return gem.type == "gem" and gem.imbue_powers and gem.material_level end, function(gem, gem_item)
				local name_old=self.name
				local old_hotkey
				for i, v in pairs(who.hotkey) do
					if v[2]==name_old then
						old_hotkey=i
					end
				end

				-- Recycle the old gem
				local old_gem=self.Gem
				if gem then
					local gem = who:removeObject(who:getInven("INVEN"), gem_item)
					if old_gem then
						who:addObject(who:getInven("INVEN"), old_gem)
						game.logPlayer(who, "You remove your %s.", old_gem:getName{do_colour=true, no_count=true})
					end
					who:sortInven()

					local _, _, inven_id = who:findInAllInventoriesByObject(self)
					who:onTakeoff(self, inven_id)

					self.Gem = gem
					self.gemdesc = _t"something has gone wrong"

					self.sentient = false
					self.act = mod.class.Object.act

					self.talent_on_spell = nil

					local scalingFactor = gem.material_level
					local combatFactor = math.max(scalingFactor, 2) -- Prevent tier 1 gems from degrading the maul

					self.material_level=combatFactor

					self.combat.dam = 8 + (12 * combatFactor)
					self.combat.apr = (3 * combatFactor)
					self.combat.physcrit = 4 + (2 * combatFactor)
					self.combat.dammod = {str=1.2, mag=0.1}
					self.combat.damrange = 1.3
					self.combat.burst_on_crit = nil
					self.combat.convert_damage = nil

					self.wielder = {
						inc_stats = {[Stats.STAT_MAG] = (2 * scalingFactor), [Stats.STAT_CUN] = (2 * scalingFactor), [Stats.STAT_DEX] = (2 * scalingFactor),},
					}


					-- Each element merges its effect into the combat/wielder tables (or anything else) after the base stats are scaled
					-- You can modify damage and such here too but you should probably make static tables instead of merging

					if gem.on_tirakai_maul_equip then
						gem:on_tirakai_maul_equip(self)
					elseif self.unique_gems[gem.define_as or gem.name] then
						self.unique_gems[gem.define_as or gem.name](self, gem)
					elseif gem.color_attributes then
						self.combat.damtype = gem.color_attributes.damage_type
						table.mergeAdd(self.wielder,
							{inc_damage = {[gem.color_attributes.damage_type] = 4 * scalingFactor},},
							true)
						self.combat.burst_on_crit = {[gem.color_attributes.alt_damage_type] = 12 * scalingFactor,}
						self.gemDesc = gem.color_attributes.desc or _t(gem.color_attributes.damage_type:lower()):capitalize()
					else -- Backup for weird artifacts.
						table.mergeAdd(self.combat, {convert_damage = {[DamageType.COLD] = 25, [DamageType.FIRE] = 25, [DamageType.LIGHTNING] = 25, [DamageType.ARCANE] = 25,} }, true)
						table.mergeAdd(self.wielder, {
							inc_damage = { all = 2 * scalingFactor},
							resists_pen = { all = 2 * scalingFactor},
							}, true)
							self.gemDesc = _t'Unique'
					end

					game.logPlayer(who, "You imbue your %s with %s.", self:getName{do_colour=true, no_count=true}, gem:getName{do_colour=true, no_count=true})

					--self.name = (gem.name .. " of Divinity")

					table.mergeAdd(self.wielder, gem.imbue_powers, true)

					if gem.talent_on_spell then
						self.talent_on_spell = self.talent_on_spell or {}
						table.append(self.talent_on_spell, gem.talent_on_spell)
					end

					who:onWear(self, inven_id)
				end
				for i, v in pairs(who.hotkey) do
					if v[2]==name_old then
						v[2]=self.name
					end
					if v[2]==self.name and old_hotkey and i~=old_hotkey then
						who.hotkey[i] = nil
					end
				end
				d.used_talent=true
				game:unregisterDialog(d)
				return true
			end)
			return {id=true, used=true}
		end
	},
	on_wear = function(self, who)

		return true
	end,
	wielder = {
	-- Stats only from gems
	},
}

newEntity{ base = "BASE_GLOVES", define_as = "SET_GLOVE_DESTROYER",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Fist of the Destroyer", color = colors.RED, image = "object/artifact/fist_of_the_destroyer.png",
	unided_name = _t"vile gauntlets",
	desc = _t[[These fell looking gloves glow with untold power.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	special_desc = function(self)
		local num=4
		if self.set_complete then
			num=6
		end
		return ("Increases all damage by %d%% of current vim \nCurrent Bonus: %d%%"):tformat(num, num*0.01*(game.player:getVim() or 0))
	end,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 9, [Stats.STAT_MAG] = 9, [Stats.STAT_CUN] = 3, },
		demonblood_dam=0.04,
		max_vim = 25,
		combat_def = 8,
		stun_immune = 0.2,
		talents_types_mastery = { ["corruption/shadowflame"] = 0.2, ["corruption/vim"] = 0.2,},
		combat = {
			dam = 35,
			apr = 15,
			physcrit = 10,
			physspeed = 0,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.2,},
			damrange = 0.3,
			talent_on_hit = { T_DRAIN = {level=2, chance=8}, T_SOUL_ROT = {level=3, chance=12}, T_BLOOD_GRASP = {level=3, chance=10}},
		},
	},
	max_power = 12, power_regen = 1,
	use_talent = { id = Talents.T_DARKFIRE, level = 5, power = 12 },
	set_list = { {"define_as", "SET_ARMOR_MASOCHISM"} },
	set_desc = {
		destroyer = _t"Only the masochistic can unlock its full power.",
	},
	on_set_complete = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#The fist and the mangled clothing glow ominously!")
		self:specialSetAdd({"wielder","demonblood_dam"}, 0.02)
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.FIRE] = 15, [engine.DamageType.DARKNESS] = 15, all = 5 })
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#The ominous glow dies down.")
	end,
}

newEntity{ base = "BASE_LIGHT_ARMOR", define_as = "SET_ARMOR_MASOCHISM",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Masochism", color = colors.RED, image = "object/artifact/masochism.png",
	unided_name = _t"mangled clothing",
	desc = _t[[Stolen flesh,
	Stolen pain,
	To give it up,
	Is to live again.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	special_desc = function(self)
		local num=7
		if self.set_complete then
			num=10
		end
		return ("Reduces all damage by %d%% of current vim or 50%% of the damage, whichever is lower; but at the cost of vim equal to 5%% of the damage blocked. \nCurrent Bonus: %d"):tformat(num, num*0.01*(game.player:getVim() or 0))
	end,
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 9, [Stats.STAT_CUN] = 3, },
		combat_spellpower = 10,
		demonblood_def=0.07,
		max_vim = 25,
		disease_immune = 1,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		on_melee_hit={[DamageType.DRAIN_VIM] = 25},
		melee_project={[DamageType.DRAIN_VIM] = 25},
		talents_types_mastery = { ["corruption/sanguisuge"] = 0.2, ["corruption/blood"] = 0.2,},
	},
	max_power = 12, power_regen = 1,
	use_talent = { id = Talents.T_BLOOD_GRASP, level = 5, power = 12 },
	set_list = { {"define_as", "SET_GLOVE_DESTROYER"} },
	set_desc = {
		masochism = _t"With a better grip it would be the destroyer of your enemies.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","demonblood_def"}, 0.03)
		self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE] = 15, [engine.DamageType.DARKNESS] = 15, all = 5 })
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true},
	unique = true,
	name = "Obliterator", color = colors.UMBER, image = "object/artifact/obliterator.png",
	unided_name = _t"titanic maul",
	desc = _t[[This massive hammer strikes with deadly force. Bones crunch, splinter and grind to dust under its impact.]],
	level_range = {23, 30},
	rarity = 270,
	require = { stat = { str=40 }, },
	cost = 250,
	material_level = 3,
	combat = {
		dam = 48,
		apr = 10,
		physcrit = 0,
		dammod = {str=1.2},
		crushing_blow=1,
		special_on_hit = { --thanks nsrr!--
			desc=function(self, who, special)
				local damage = special.damage(self, who)
				local s = ("Sends a tremor through the ground which causes jagged rocks to erupt in a beam of length 5, dealing %d Physical damage (equal to your Strength, up to 150) and causing targets hit to bleed for an additional 50 damage over 5 turns. Bleeding can stack."):tformat(damage)
				return s
			end,
			damage = function(self, who)
				return math.min (150, who:getStr())
			end,
			fct=function(self, who, target, dam, special)
				local damage = special.damage(self, who)
				local l = who:lineFOV(target.x, target.y)
				l:set_corner_block()
				local lx, ly, is_corner_blocked = l:step(true)
				local target_x, target_y = lx, ly
				-- Check for terrain and friendly actors
				while lx and ly and not is_corner_blocked and core.fov.distance(who.x, who.y, lx, ly) <= 5 do -- projects to maximum range
					local actor = game.level.map(lx, ly, engine.Map.ACTOR)
					if actor and (who:reactionToward(actor) >= 0) then
						break
					elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
						target_x, target_y = lx, ly
						break
					end
					target_x, target_y = lx, ly
					lx, ly = l:step(true)
				end
				if not target_x then return end
				local tg = {type="beam", range=5, selffire=false}
				game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(target_x-who.x), math.abs(target_y-who.y)), "earth_beam", {tx=target_x-who.x, ty=target_y-who.y})
				game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(target_x-who.x), math.abs(target_y-who.y)), "shadow_beam", {tx=target_x-who.x, ty=target_y-who.y})
				local grids1 = who:project(tg, target_x, target_y, engine.DamageType.PHYSICAL, damage)
				local grids2 = who:project(tg, target_x, target_y, engine.DamageType.BLEED, 50)
				game:playSoundNear(who, "talents/earth")
			end,
		},

	},
	wielder = {
		combat_critical_power = 10,
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, },
	},
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Yaldan Baoth", image = "object/artifact/yaldan_baoth.png",
	unided_name = _t"obscuring helm",
	desc = _t[[The golden bascinet crown, affiliated with Veluca of Yaldan. King of the mythical city of Yaldan, that was struck from the face of Eyal by the arrogance of its people. Lone survivor of his kin, he spent his last years wandering the early world, teaching man to stand against the darkness. With his dying words, "Fear no evil", the crown was passed onto his successor.]],
	level_range = {28, 39,},
	rarity = 240,
	cost = 700,
	material_level = 4,
	wielder = {
		combat_armor = 10,
		fatigue = 4,
		resist_unseen = 33,
		sight = -2,
		lite = -2,
		inc_stats = { [Stats.STAT_STR] = 10, [Stats.STAT_CON] = 10, },
		inc_damage={
			[DamageType.LIGHT] = 15,
		},
		resists={
			[DamageType.LIGHT] = 15,
			[DamageType.DARKNESS] = 25,
		},
		resists_cap={
			[DamageType.DARKNESS] = 10,
		},
		blind_fight = 1,
	},
	max_power = 40, power_regen = 1,
	use_power = {
		name = function(self, who) return ("lower the helmet's visor, blinding yourself (and protecting from other blinds) for 6 turns. If the helmet is taken off, the effect will end early."):tformat(self.use_power.range) end,
		power = 40,
		use = function(self, who)
			who:setEffect(who.EFF_FORGONE_VISION, 6, {power = 2})
			game.logSeen(who, "%s forgoes their vision!", who:getName():capitalize())
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {technique=true, arcane=true},
	name = "Champion's Will", unique=true, image = "object/artifact/champions_will.png",
	moddable_tile = "special/%s_champions_will",
	unided_name = _t"blindingly bright sword", color=colors.YELLOW,
	desc = _t[[This impressive looking sword features a golden engraving of a sun in its hilt. Etched into its blade are a series of runes claiming that only one who has mastered both their body and mind may wield this sword effectively.]],
	require = { stat = { str=35 }, },
	level_range = {40, 50},
	rarity = 240,
	cost = 280,
	material_level = 5,
	special_desc = function(self) return _t"Increases the damage of Sun Beam by 15%." end,
	combat = {
		dam = 67,
		apr = 22,
		physcrit = 12,
		dammod = {str=1.15, con = 0.2},
		special_on_hit = {
		desc=function(self, who, special)
			return ("releases a burst of light, dealing %d light damage (based on Spellpower) in a radius 3 cone."):tformat(who:damDesc(engine.DamageType.LIGHT, who:combatSpellpower()))
		end,
		on_kill=1, fct=function(combat, who, target)
			who.turn_procs.champion_will = (who.turn_procs.champion_will or 0) + 1
			local tg = {type="cone", range=10, radius=3, force_target=target, selffire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.LIGHT, who:combatSpellpower() / (who.turn_procs.champion_will))
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "light_cone", {radius=tg.radius, tx=target.x-who.x, ty=target.y-who.y})
			who.turn_procs.champion_will = (who.turn_procs.champion_will or 0) + 1
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 12, [Stats.STAT_MAG] = 6, [Stats.STAT_CON] = 7},
		talents_types_mastery = {
			["celestial/crusader"] = 0.2,
			["celestial/sun"] = 0.2,
			["celestial/radiance"] = 0.1,
		},
		talent_cd_reduction= {
			[Talents.T_ABSORPTION_STRIKE] = 1,
			[Talents.T_SUN_BEAM] = 1,
			[Talents.T_FLASH_OF_THE_BLADE] = 1,
		},
		amplify_sun_beam = 15,
	},
	max_power = 30, power_regen = 1,
	use_power = {
		name = function(self, who) return ("attack everything in a line out to range %d, dealing 100%% weapon damage (as light), and healing for 50%% of the damage dealt"):tformat(self.use_power.range) end,
		power = 30,
		range = 4,
		target = function(self, who) return {type="beam", range=self.use_power.range} end,
		requires_target = true,
		tactical = {ATTACK = {weapon = 2}, ATTACKAREA = {LIGHT = 1.5}, HEAL = 1.5},
		use = function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y, target = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			who:logCombat(target or who.ai_target.actor or {name = _t"something"}, "#Source# strikes out at #target# with %s %s!", who:his_her(), self:getName({do_color = true, no_add_name = true}))
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "light_beam", {tx=x-who.x, ty=y-who.y})
			game:playSoundNear(self, "talents/lightning")
			who:attr("lifesteal", 50)
			-- a bug in combat with this ability could be game breaking
			local ok, ret = pcall(who.project, who, tg, x, y,
				function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if not target then return end
					who:attackTarget(target, engine.DamageType.LIGHT, 1, true)
				end
			)
			who:attr("lifesteal", -50)
			if ok then return {id=true, used=true}
			else error(ret)	return end
		end
	},
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Tarrasca", image = "object/artifact/terrasca.png",
	unided_name = _t"absurdly large armor",
	desc = _t[[This massive suit of plate boasts an enormous bulk and overbearing weight. Said to belong to a nameless soldier who safeguarded a passage across the bridge to his village, in defiance to the cohorts of invading orcs. After days of assault failed to fell him, the orcs turned back. The man however, fell dead on the spot - from exhaustion. The armor had finally claimed his life.]],
	color = colors.RED,
	level_range = {30, 40},
	rarity = 320,
	require = { stat = { str=52 }, },
	cost = 500,
	material_level = 4,
	special_desc = function(self, who)
		local resist = who and self.worn_by == who and self:set_resist(who) or 0
		return ("When your effective movement speed (global speed times movement speed) is less than 100%%, reduces all incoming damage by a percent equal to the speed detriment (up to 70%%).\nCurrent reduction bonus: %d%%"):tformat(resist) end,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 15, },
		combat_armor = 50,
		combat_armor_hardiness = 15,
		knockback_immune = 1,
		combat_physresist = 45,
		fatigue = 35,
--		speed_resist=1,
	},
	on_wear = function(self, who)
		self.worn_by = who
		self:set_resist(who)
	end,
	on_takeoff = function(self, who)
		if self.resist_id then who:removeTemporaryValue("resists", self.resist_id) end
		self.resist_id = nil
		self.worn_by = nil
	end,
	set_resist = function(self, who) -- update the resistance bonus based on speed
		local resist = 100*(1-(util.bound(who.global_speed * who.movement_speed, 0.3, 1)))
		if who == self.worn_by and resist ~= self.last_resist then -- update resistance
			if self.resist_id then who:removeTemporaryValue("resists", self.resist_id) end
			if resist > 0 then
				self.resist_id = who:addTemporaryValue("resists", {absolute = resist})
			else self.resist_id = nil
			end
			self.last_resist = resist
		end
		return resist
	end,
	callbackOnAct = function(self, who)
		self:set_resist(who)
	end,
	callbackOnTemporaryEffectAdd = function(self, who, eff_id, e_def, p)
		self:set_resist(who)
	end,
	callbackOnTemporaryEffectRemove = function(self, who, eff_id, e_def, p)
		self:set_resist(who)
	end,
	callbackOnTakeDamage = function(self, who, src, x, y, type, dam, state) -- make sure damage reduction is updated on hit
		self:set_resist(who)
	end,
	max_power = 25, power_regen = 1,
	use_power = { name = _t"slow the movement speed of all creatures (including yourself) within range 5 by 40% for 3 turns",
		power = 25,
		range = 0,
		radius = 5,
		target = function(self, who) return {type="ball", range=0, radius=self.use_power.radius, selffire = false} end,
		tactical = {DISABLE = function(who, t, aitarget)
				if not (aitarget and who.aiSeeTargetPos) or aitarget:hasEffect(aitarget.EFF_SLOW_MOVE) then return end
				local tx, ty = who:aiSeeTargetPos(aitarget)
				if core.fov.distance(who.x, who.y, tx, ty) <= 1 then return {slow = 1} end
			end,
			SELF = function(who, t, aitarget)
				local resist = (util.bound(who.global_speed * (who.movement_speed), 0.3, 1) - (util.bound(who.global_speed * (who.movement_speed - .4), 0.3, 1)))*5
				if resist > 0 then
					return {defend=2*resist, escape=-resist, closein=-resist}
				end
			end,
			__wt_cache_turns = 1,
		},
		on_pre_use_ai = function(self, who) return not who:hasEffect(who.EFF_SLOW_MOVE) end,
		use = function(self, who)
			local tg = self.use_power.target(self, who)
			tg.selffire = true -- set here so that the ai will use it
			game.logSeen(who, "%s rebalances the bulky plates of %s %s, and things slow down a bit.", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			who:project(tg, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				target:setEffect(target.EFF_SLOW_MOVE, 3, {power=0.4, no_ct_effect=true, })
			end)
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {unknown=true},
	unique = true,
	name = "The Face of Fear",
	unided_name = _t"bone mask", image = "object/artifact/the_face_of_fear.png",
	level_range = {24, 32},
	color=colors.GREEN,
	moddable_tile = "special/the_face_of_fear",
	moddable_tile_big = true,
	encumber = 2,
	rarity = 200,
	desc = _t[[This mask appears to be carved out of the skull of a creature that never should have existed, malformed and distorted. You shiver as you look upon it, and its hollow eye sockets seem to stare back into you.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=8,
		fear_immune = 0.6,
		inc_stats = { [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6, },
		combat_mindpower = 16,
		talents_types_mastery = { ["cursed/fears"] = 0.2,},
	},
	max_power = 45, power_regen = 1,
	use_talent = { id = Talents.T_INSTILL_FEAR, level = 2, power = 18 },
}

newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {arcane=true},
	unided_name = _t"flame coated sandals",
	name = "Cinderfeet", unique=true, image = "object/artifact/cinderfeet.png",
	desc = _t[[A cautionary tale tells of the ancient warlock by the name of Caim, who fancied himself daily walks through Goedalath, both to test himself and the harsh demonic wastes. He was careful to never bring anything back with him, lest it provide a beacon for the demons to find him. Unfortunately, over time, his sandals drenched in the soot and ashes of the fearscape and the fire followed his footsteps outside, drawing in the conclusion of his grim fate.]],
	require = { stat = { dex=10 }, },
	level_range = {28, 38},
	material_level = 4,
	rarity = 195,
	cost = 40,
	sentient=true,
	oldx=0,
	oldy=0,
	wielder = {
		lite = 2,
		combat_armor = 5,
		combat_def = 3,
		fatigue = 6,
		inc_damage = {
			[DamageType.FIRE] = 18,
		},
		resists = {
			[DamageType.COLD] = 20,
		},
		inc_stats = { [Stats.STAT_MAG] = 4, [Stats.STAT_CUN] = 4, },
	},
	special_desc = function(self, who)
		local dam = who and who:damDesc(engine.DamageType.FIRE, self:trail_damage(who)) or 0
		return ("Each step you take leaves a burning trail behind you lasting 5 turns that deals %d fire damage (based on Spellpower) to foes who enter it."):tformat(dam)
	end,
	on_wear = function(self, who)
		self.worn_by = who
		self.oldx=who.x
		self.oldy=who.y
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	trail_damage = function(self, who) return who and who:combatSpellpower() or 0 end,
	act = function(self)
		self:useEnergy()
		self:regenPower()

		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if self.oldx ~= who.x or self.oldy ~= who.y then
			local DamageType = require "engine.DamageType"
			local duration = 6
			local radius = 0
			local dam = self:trail_damage(self.worn_by)
			-- Add a lasting map effect
			local ef = game.level.map:addEffect(who,
				who.x, who.y, duration,
				DamageType.FIRE, dam,
				radius,
				5, nil,
				{type="inferno"},
				nil,
				false,
				false
			)
			ef.name = _t"fire trail"
		end
		self.oldx=who.x
		self.oldy=who.y
		return
	end
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Cuirass of the Dark Lord", image = "object/artifact/dg_casual_outfit.png",
	unided_name = _t"black, spiked armor",
	moddable_tile = "special/dgs_clothes",
	moddable_tile_big = true,
	desc = _t[[Worn by a villain long forgotten, this armor was powered by the blood of thousands of innocents. Decrepit and old, the dark lord died in solitude, his dominion crumbled, his subjects gone. Only this cuirass remained, dying to finally taste fresh blood again.]],
	color = colors.RED,
	level_range = {40, 50},
	rarity = 320,
	require = { stat = { str=52 }, },
	cost = 500,
	material_level = 5,
	sentient=true,
	blood_charge=0,
	blood_dur=0,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 10,  [Stats.STAT_CON] = 10, },
		combat_armor = 30,
		combat_dam=10,
		combat_physresist = 15,
		fatigue = 25,
		life_regen=0,
		on_melee_hit={[DamageType.PHYSICAL] = 30},
		resists={[DamageType.PHYSICAL] = 20},
	},
	max_power = 25, power_regen = 1,
	use_power = {
		name = function(self, who)
			local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.bleed(self, who))
			return ("drain blood from all creatures within range 5, causing them to bleed for %0.2f physical damage over 4 turns (based on your Physicalpower). For each creature drained (up to 10), the armor gains strength, which fades over 10 turns if it is not fed"):tformat(dam)
		end,
		power = 25,
		bleed = function(self, who) return who:combatPhysicalpower()*3 end,
		requires_target = true,
		target = function(self, who) return {type="ball", range=self.use_power.range, radius=self.use_power.radius, selffire=false} end,
		tactical = function(self, who, aitarget)
			local nb, allies = 0, 0
			local charge, dur = self.blood_charge, self.blood_dur
			local oldboost = charge*dur
			who:project(self.use_power.target(self, who), who.x, who.y, function(px, py)
				local act = game.level.map(px, py, engine.Map.ACTOR)
				if act and act:canBe("cut") then
					nb = nb + 1
					if who:reactionToward(act) > 0 then allies = allies + 1 end
					dur = 10
					charge = math.min(charge + 1, 10)
				end
			end)
			if nb > 0 then
				local tac = {attackarea = {cut = 2}}
				local boost = charge*dur-oldboost --increase in bonus power
				tac.special = boost/20 + math.max(5-self.blood_dur,0)/5  -- ~ 10 effective tac weight at 50 boost (half of full blood charges), extra boost at low blood duration to preserve bonuses and kickoff
				if allies > 0 then
					tac.special = tac.special - 1.5*((who.ai_state.ally_compassion == false and 0) or who.ai_state.ally_compassion or 1)*allies
				end
				tac.defend = boost/25
				return tac
			end
		end,
		range = 0,
		radius  = 5,
		no_npc_use = function(self, who) return self:restrictAIUseObject(who) end,
		use = function(self, who)
			game.logSeen(who, "%s revels in the bloodlust of %s %s!", who:getName():capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
			local damage = self.use_power.bleed(self, who)/4
			who:project(self.use_power.target(self, who), who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target or not target:canBe("cut") then return end
				self.blood_charge = self.blood_charge + 1
				target:setEffect(target.EFF_CUT, 4, {power=damage, no_ct_effect=true, src = who})
			end)
			if self.blood_charge > 10 then self.blood_charge = 10 end
			self.blood_dur = 10
			return {id=true, used=true}
		end
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	special_desc = function(self)
		return (("Blood Charges: %d"):tformat(self.blood_charge or 0))
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()

		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.blood_charge ~= self.last_blood_charge or self.blood_dur ~= self.last_blood_dur then --update stats?
			self.last_blood_charge = self.blood_charge
			self.last_blood_dur = self.blood_dur
			local boost = self.blood_charge
			local dur = self.blood_dur
			local storepower=self.power
			local _, _, inven_id = who:findInAllInventoriesByObject(self)
			local DamageType = require "engine.DamageType"

			who:onTakeoff(self, inven_id, true)
			if self.compute_vals then self:removeTemporaryValue("wielder", self.bonuses) end--remove old wielder bonuses
			-- add new wielder bonuses
			self.bonuses = self:addTemporaryValue("wielder", {
				inc_stats = { [who.STAT_STR] = math.ceil(boost * dur/5),  [who.STAT_CON] = math.ceil(boost * dur/5), },
				combat_armor = math.ceil(boost * dur * 0.4),
				combat_dam = math.ceil(boost/5 * dur),
				combat_physresist = math.ceil(boost/5 * dur),
				fatigue = math.ceil(- boost/5 * dur),
				life_regen= math.ceil(boost/2 * dur),
				on_melee_hit={[DamageType.PHYSICAL] = math.ceil(boost * dur * 0.8)},
				resists={[DamageType.PHYSICAL] = math.ceil(boost/5 * dur)},
			})
			who:onWear(self, inven_id, true)
			self.power = storepower
		end
		if self.blood_dur > 0 then
			self.blood_dur = self.blood_dur - 1
			if self.blood_dur <= 0 then self.blood_charge = 0 end
		end
		return
	end
}

--[=[
newEntity{
	unique = true,
	type = "jewelry", subtype="ankh",
	unided_name = _t"glowing ankh",
	name = "Anchoring Ankh",
	desc = _t[[As you lift the ankh you feel stable. The world around you feels stable.]],
	level_range = {15, 50},
	rarity = 400,
	display = "*", color=colors.YELLOW, image = "object/fireopal.png",
	encumber = 2,

	carrier = {

	},
}
]=]

-- Semi-random Artifacts
newEntity{ base = "BASE_LEATHER_CAP", define_as = "DECAYED_VISAGE",
	power_source = {arcane=true},
	unique = true,
	name = "Decayed Visage",
	unided_name = _t"mask of mummified skin", image = "object/artifact/decayed_visage.png",
	level_range = {24, 32},
	color=colors.GRAY,
	rarity = 200,
	desc = _t[[A desiccated mask of human skin, all that remains of a necromancer from the Age of Pyre who failed to achieve lichdom.  The transformative process partially succeeded, leaving him unable to die as his body slowly rotted from the inside out over several years.  Now his spirit resides within this last bit of mummified flesh, still hungering for eternal life.]],
	cost = 200,
	material_level=3,
	encumber = 1,
	require = { stat = { mag=25, wil=20 }, },
	wielder = {
		on_melee_hit = {[DamageType.DRAIN_VIM]=10},
		max_vim = 25,
	},
	max_power = 45, power_regen = 1,
	use_talent = { id = Talents.T_VIMSENSE, level = 2, power = 25 },
	finish = function(self, zone, level) -- add the blood magic ego, another arcane or psionic powered ego, and some random powers (at level 25)
		game.state:addRandartProperties(self, {lev = 25, egos = 2,
			force_egos = {"of blood magic"},
--			forbid_power_source = {antimagic=true}, power_source = {arcane = true, psionic=true},
			power_source = {arcane = true, psionic=true},
			force_themes = {"dark", "arcane", "blight"}})
	end,
}

newEntity{ base = "BASE_GREATMAUL", define_as = "DREAM_MALLEUS",
	power_source = {technique=true, psionic=true},
	unique = true,
	name = "Dream Malleus", color = colors.UMBER, image = "object/artifact/dream_malleus.png",
	unided_name = _t"keening hammer",
	desc = _t[[A large shimmering maul that seems to produce a ringing in your ears.  It is both as malleable as thought and as hard as the strongest steel.]],
	level_range = {25, 40},
	rarity = 300,
	require = { stat = { str=25, wil=25 }, },
	cost = 250,
	material_level = 4,
	combat = {
		dam = 56,
		apr = 5,
		dammod = {str=0.7, wil=0.7},
		melee_project={[DamageType.MIND] = 10}
	},
	wielder = {
		combat_mindpower = 15,
		combat_mindcrit = 5,
		psi_regen = 0.1,
		inc_damage={
			[DamageType.MIND] = 10,
			[DamageType.PHYSICAL] = 10,
			},
		learn_talent = {[Talents.T_DREAM_HAMMER] = 3, [Talents.T_HAMMER_TOSS] = 3},
		talent_cd_reduction={[Talents.T_HAMMER_TOSS]=2},
	},
	finish = function(self, zone, level) -- add the projection and thought-forged egos, plus another possibly physical or mental themed ego, and 25 points of physical or mental themed random powers
		game.state:addRandartProperties(self, {lev = 0, nb_points_add=25, egos = 3,
			force_egos = {"of projection", "thought-forged"},
			force_themes = {'physical', 'mental'},
			ego_special = function(e) -- reject egos (charms) that could overwrite the ability of the projection ego
				for i, r in ipairs(e) do
					if r.__resolver == "charm" then return false end
				end
				return true
			end})
	end,
}

newEntity{ base = "BASE_WIZARD_HAT",
	power_source = {nature=true},
	unique = true,
	name = "Cloud Caller",
	unided_name = _t"broad brimmed hat",
	desc = _t[[This hat's broad brim protects you from biting colds and sudden storms.]],
	color = colors.BLUE, image = "object/artifact/cloud_caller.png",
	moddable_tile = "special/cloud_caller",
	level_range = {1, 10},
	rarity = 300,
	cost = 30,
	material_level = 1,
	special_desc = function(self) return _t"A small storm cloud follows you, dealing 15 lightning damage to all enemies in a radius of 3 each turn." end,
	wielder = {
		resists = {
			[DamageType.COLD]	= 10,
			[DamageType.LIGHTNING]	= 10,
		},
		inc_damage={
			[DamageType.COLD]	= 10,
			[DamageType.LIGHTNING]	= 10,
		},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_CALL_LIGHTNING, level=1, power = 15 },
	on_takeoff = function(self, who)
		self.worn_by=nil
	end,
	on_wear = function(self, who)
		self.worn_by=who
	end,
	act = function(self)
		self:regenPower()
		self:useEnergy()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		local blast = {type="ball", range=0, radius=3, friendlyfire=false}
		who:project(blast, who.x, who.y, engine.DamageType.LIGHTNING, 15)
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {psionic=true},
	unique=true, rarity=300,
	type = "charm", subtype="torque",
	name = "The Jolt", image = "object/artifact/the_jolt.png",
	unided_name = _t"tingling torque",
	color = colors.BLUE,
	level_range = {10, 20},
	desc = _t[[This torque feels tingly to the touch, but seems to enhance your thinking.]],
	special_desc = function(self) return _t[[Your mind is attuned to electricity.
Any lightning damage you do that is more than 10% of the victim's maximum life will attempt to brainlock the target.
Upon taking lightning damage >10% of your max life, your mind fires back, dealing 30% of the original damage as mind and trying to brainlock the target.
Upon taking mind damage >10% of your max life, you reflexively trigger the jolt, sending an arc of dazing lightning toward the target (damage based on mindpower).
This item can have up to 2 charges, with each charge having 4 turn cooldown.]] end,
	cost = resolvers.rngrange(125,200),
	material_level = 2,
	wielder = {
		inc_damage={
			[DamageType.MIND] 	= 10,
			[DamageType.LIGHTNING]	= 10,
		},
		inc_stats = {[Stats.STAT_CUN] = 4,},
		lightning_brainlocks = 1,
	},
	on_wear = function(self, who)
		self.worn_by=who
		-- who.cooldown_mind = 4
		-- who.cooldown_lightning = 4
	end,

	onTakeoff = function(self)
		self.worn_by = nil
	end,
	max_power = 8,
	power_regen= 1,
	-- act = function(self)
		-- who.cooldown_mind = math.max(who.cooldown_mind - 1, 0)
		-- who.cooldown_lightning = math.max(who.cooldown_lightning - 1, 0)
		-- self:useEnergy()
	-- end,

	callbackOnTakeDamage = function(self, who, src, x, y, type, dam, state)
		local dam2 = dam
		if not self.worn_by or self.worn_by:attr("dead") then return end
		if type == engine.DamageType.LIGHTNING then
			if self.power >= 4 then
				if dam > who.max_life *0.1 then
				self.power = self.power - 4
				who:project(src, src.x, src.y, engine.DamageType.MIND, { dam = 0.3 * dam2, crossTierChance=25 })
				end
			end
		else
			if type == engine.DamageType.MIND  then
				if self.power >= 4 then
					if dam > who.max_life *0.1 then
					self.power = self.power - 4
					who:project(src, src.x, src.y, engine.DamageType.LIGHTNING_DAZE, who:combatScale(who.combat_mindpower, 50, 0, 300, 100))
					end
				end
			end
		end
	end,
}

newEntity{ base = "BASE_BATTLEAXE",
	power_source = {nature=true},
	unique = true,
	unided_name = _t"damp steel battle axe",
	name = "Stormfront", color = colors.BLUE, image = "object/artifact/stormfront.png",
	moddable_tile = "special/%s_stormfront",
	desc = _t[[The blade glows faintly blue, and reflects a sky full of stormy clouds.]],
	require = { stat = { str=16 }, },
	level_range = {10, 20},
	rarity = 300,
	cost = 100,
	material_level = 2,
	combat = {
		dam = 30,
		apr = 15,
		physcrit = 5,
		dammod = {str=1.2},
		melee_project={
			[DamageType.LIGHTNING]=15,
			[DamageType.COLD]=15,
		},
		special_on_crit = {desc=_t"inflicts either shocked or wet, chosen at random", fct=function(combat, who, target)
			if not target or target == self then return end
			if rng.percent(50) then
				target:setEffect(target.EFF_SHOCKED, 3, {src=who})
			else
				target:setEffect(target.EFF_WET, 3, {src=who})
			end
		end},
	},
	wielder = {
		inc_damage = {
			[DamageType.LIGHTNING]=12,
			[DamageType.COLD]=12,
		},
	},
}

newEntity{ base = "BASE_MINDSTAR", define_as = "EYE_OF_SUMMER",
	power_source = {nature=true},
	unique = true,
	name = "Eye of Summer",
	unided_name = _t"warm mindstar",
	level_range = {10, 20},
	color=colors.RED, image = "object/artifact/eye_of_summer.png",
	moddable_tile = "special/%s_eye_of_summer",
	rarity = 300,
	desc = _t[[This mindstar glows with a bright warm light, but seems somehow incomplete.]],
	cost = 40,
	require = { stat = { wil=18 }, },
	material_level = 2,
	combat = {
		dam = 8,
		apr = 18,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.FIRE,
	},
	wielder = {
		combat_mindpower = 8,
		combat_mindcrit = 4,
		inc_damage = { [DamageType.FIRE]=10 },
		resists_pen = { [DamageType.FIRE] = 10 },
		resists = { [DamageType.COLD]=-10 },
		global_speed_add = 0.05,
	},
	talent_on_mind = {{chance=10, talent=Talents.T_FLAME_FURY, level=2},},
	ms_set_nature = true,
	set_list = {
		multiple = true,
		seasons = {{"define_as", "EYE_OF_WINTER"},},
		harmonious = {{"ms_set_harmonious", true},},
	},
	set_desc = {
		eyesummer = _t"Nature requires balance in these matters.",
	},
	on_set_complete = {
		multiple = true,
		seasons = function(self, who)
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.COLD]=20 }, "seasons")
			self:specialSetAdd({"wielder","combat_mindpower"}, 4, "seasons")
			game.logSeen(who, "#GREEN#You feel the seasons in perfect balance.")
		end,
		harmonious = function(self, who)
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.COLD]=20 }, "harmonious")
			self:specialSetAdd({"wielder","combat_mindpower"}, 4, "harmonious")
			game.logSeen(who, "#GREEN#You feel the seasons in perfect balance.")
		end,
	},
	on_set_broken = function(self, who)
		game.logPlayer(who, "#GREEN#The seasons no longer feel balanced.")
	end,
}

newEntity{ base = "BASE_MINDSTAR", define_as = "EYE_OF_WINTER",
	power_source = {nature=true},
	unique = true,
	name = "Eye of Winter",
	unided_name = _t"cold mindstar",
	level_range = {10, 20},
	color=colors.BLUE, image = "object/artifact/eye_of_winter.png",
	moddable_tile = "special/%s_eye_of_winter",
	rarity = 300,
	desc = _t[[This mindstar glows with a dim cool light, but seems somehow incomplete.]],
	cost = 40,
	require = { stat = { wil=18 }, },
	material_level = 2,
	combat = {
		dam = 8,
		apr = 18,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.COLD,
	},
	wielder = {
		combat_mindpower = 8,
		combat_mindcrit = 4,
		inc_damage = { [DamageType.COLD]=10 },
		resists_pen = { [DamageType.COLD] = 10 },
		resists = { [DamageType.FIRE]=-10 },
		combat_armor = 10,
	},
	talent_on_mind = {{chance=10, talent=Talents.T_WINTER_S_FURY, level=2},},
	ms_set_nature = true,
	set_list = {
		multiple = true,
		seasons = {{"define_as", "EYE_OF_SUMMER"},},
		harmonious = {{"ms_set_harmonious", true},},
	},
	set_desc = {
		eyewinter = _t"Nature requires balance in these matters.",
	},
	on_set_complete = {
		multiple = true,
		seasons = function(self, who)
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE]=20 }, "seasons")
			self:specialSetAdd({"wielder","combat_mindpower"}, 4, "seasons")
		end,
		harmonious = function(self, who)
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE]=20 }, "harmonious")
			self:specialSetAdd({"wielder","combat_mindpower"}, 4, "harmonious")
		end,
	},
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {psionic=true},
	unique = true,
	name = "Ruthless Grip", color = colors.DARK_BLUE, image = "object/artifact/grip_of_death.png",
	moddable_tile = "special/grip_of_death",
	unided_name = _t"sinister gauntlets",
	desc = _t[[Crafted for a warlord who wanted to keep his subjects under a stralite grip. Dark thoughts went into the making of these gauntlets, literally.]],
	level_range = {30, 40},
	rarity = 300,
	cost = resolvers.rngrange(400,650),
	material_level = 4,
	wielder = {
		combat_armor = 5,
		inc_damage = {
			[DamageType.DARKNESS]=20,
			[DamageType.COLD]=20,
		},
		melee_project = {
			[DamageType.DARKNESS]=15,
			[DamageType.COLD]=15,
		},
		max_hate = 20,
		healing_factor = -0.1,
		die_at = -100,
		combat = {
			dam = 25,
			apr = 15,
			physcrit = 10,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4, wil=0.4 },
			damrange = 0.3,
			talent_on_hit = { T_DOMINATE = {level = 3, chance = 10}, T_SLASH = {level = 3, chance = 5} },
		},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_INSTILL_FEAR, level=3, power = 20 },
}

newEntity{ base = "BASE_KNIFE",
	power_source = {psionic=true, nature=true},
	unique = true,
	name = "Icy Kill", image = "object/artifact/icy_kill.png",
	moddable_tile = "special/%s_icy_kill",
	unided_name = _t"sharpened icicle",
	desc = _t[[As any scryer knows, the link between the murderer and the murdered is the murder weapon, and a scryer can follow that link from the murdered to the weapon to the murderer.
One rather cold blooded killer thought of a way around this. By carving blades out of ice, they could kill as they wished and the link would just melt away.
Their killing spree ended when one of the victims got lucky and managed to stab the murderer in the heart with the icey blade. After being united with the cold heart that created it, the final ice blade has never melted.]],
	level_range = {30, 40},
	rarity = 300,
	require = { stat = { dex=42 }, },
	cost = 400,
	material_level = 4,
	metallic = false,
	combat = {
		dam = 35,
		apr = 10,
		physcrit = 15,
		dammod = {str=0.45, dex=0.45},
		melee_project = { [DamageType.COLD]=30 },
		special_on_crit = {desc=_t"freezes the target", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:canBe("stun") then
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				target:setEffect(target.EFF_FROZEN, 4, {src=who, apply_power=check})
			end
		end},
		special_on_kill = {desc=_t"explodes a frozen creature (damage scales with willpower)", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:hasEffect(target.EFF_FROZEN) then
				local tg = {type="ball", range=0, radius=1, selffire=false}
				local grids = who:project(tg, target.x, target.y, engine.DamageType.ICE, {chance=50, dam=30 + who:getWil()*0.5})
				game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_ice", {radius=tg.radius})
			end
		end},
	},
	wielder = {
		inc_stats = {[Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 6,},
		inc_damage = { [DamageType.COLD]=25 },
		iceblock_pierce = 50,
		hate_per_kill = 4,
	},
}

newEntity{ base = "BASE_MACE",
	power_source = {psionic=true},
	name = "Thunderfall", define_as = "THUNDERFALL", image="object/artifact/thunderfall.png",
	unided_name = _t"large echoing mace", unique = true,
	moddable_tile = "special/%s_thunderfall",
	desc = _t[[Tremendous power is concentrated in this heavy mace. Just dropping it can knock down nearby walls.]],
	level_range = {40, 50},
	require = { stat = { str=50, wil=30 }, },
	rarity = 400,
	cost = 500,
	material_level = 5,
	combat = {
		dam = 50,
		apr = 6,
		physcrit = 3,
		dammod = {str=1},
		burst_on_hit = {
			[DamageType.PHYSICAL] = 50,
			[DamageType.LIGHTNING] = 50,
		},
		burst_on_crit = {
			[DamageType.PHYSICAL] = 100,
			[DamageType.LIGHTNING] = 100,
		},
	},
	max_power = 60, power_regen = 1,
	use_power = {
		name = function(self, who) return ("perform a melee strike against a target at up to range %d for an automatic critical hit as lightning damage"):tformat(self.use_power.range) end,
		power = 60,
		range = 10,
		target = function(self, who) return {type="ball", range=self.use_power.range, radius = 2, friendlyfire = false} end, -- treated as an AOE for AI purposes
		tactical = {ATTACK = {LIGHTNING = 2},
			ATTACKAREA = {PHYSICAL = 1.5, LIGHTNING = 1.5}
		},
		requires_target = true,
		on_pre_use_ai = function(self, who, silent, fake)
			local target, tx, ty = who.ai_target.actor
			if target then
				tx, ty = who:aiSeeTargetPos(target)
				return core.fov.distance(who.x, who.y, tx, ty) >1
			end
		end,
		use = function(self, who)
			local tg = {type="hit", range=self.use_power.range}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			local target = game.level.map(x, y, engine.Map.ACTOR)
			who:logCombat(target or {name = _t"something"}, "#Source# hurls %s %s at #target#!", who:his_her(), self:getName({do_color=true, no_add_name=true}))
			if target then
				local x2, y2 = x + rng.range(-4, 4), y - rng.range(5, 10)
				game.level.map:particleEmitter(x, y, math.max(math.abs(x2-x), math.abs(y2-y)), "lightning", {tx=x2-x, ty=y2-y})
				game:playSoundNear({x=x,y=y}, "talents/thunderstorm")

				who.turn_procs.auto_phys_crit = true
				who:attackTarget(target, engine.DamageType.LIGHTNING, 1.0, true)
				who.turn_procs.auto_phys_crit = nil

				if core.shader.active() then game.level.map:particleEmitter(x, y, 2, "ball_lightning_beam", {radius=2, tx=x, ty=y}, {type="lightning"})
				else game.level.map:particleEmitter(x, y, 2, "ball_lightning_beam", {radius=2, tx=x, ty=y}) end
			end
			game.logSeen(who, "%s's weapon returns to %s!", who:getName():capitalize(), who:him_her())
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_MINDSTAR", define_as = "KINETIC_FOCUS",
	power_source = {psionic=true},
	unique = true,
	name = "Kinetic Focus",
	unided_name = _t"humming mindstar",
	level_range = {10, 30},
	color=colors.YELLOW, image = "object/artifact/kinetic_focus.png",
	moddable_tile = "special/%s_kinetic_focus",
	rarity = 300,
	desc = _t[[Kinetic energies are focussed in the core of this mindstar.]],
	cost = 50,
	require = { stat = { wil=18 }, },
	material_level = 2,
	combat = {
		dam = 6,
		apr = 18,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.PHYSICAL,
	},
	wielder = {
		combat_mindpower = 8,
		combat_mindcrit = 4,
		inc_damage = { [DamageType.PHYSICAL]=10 },
		resists_pen = { [DamageType.PHYSICAL] = 6 },
		resists = { [DamageType.PHYSICAL]=10 },
		psi_on_crit = 1,
		combat_physresist = 6,
		talents_types_mastery = { ["psionic/kinetic-mastery"] = 0.1 },
		learn_talent = { [Talents.T_PSIONIC_MAELSTROM] = 1,},
	},
	ms_set_psionic = true,
	set_list = {
		multiple = true,
		kinchar = {{"define_as", "CHARGED_FOCUS"},},
		kinther = {{"define_as", "THERMAL_FOCUS"},},
		resonating = {{"ms_set_resonating", true},},
	},
	set_desc = {
		trifocus = _t"You feel two unconnected psionic channels on this item.",
	},
	on_set_complete = {
		multiple = true,
		kinchar = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 6, "kinchar")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 3, "kinchar")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL]=10 }, "kinchar")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.PHYSICAL]=6 }, "kinchar")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.PHYSICAL]=10 }, "kinchar")
			self:specialSetAdd({"wielder","psi_on_crit"}, 1, "kinchar")
			self:specialSetAdd({"wielder","combat_physresist"}, 6, "kinchar")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/kinetic-mastery"] = 0.1 }, "kinchar")
			game.logSeen(who, "#YELLOW#You feel psionic energy linking the mindstars.")
		end,
		kinther = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 6, "kinther")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 3, "kinther")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL]=10 }, "kinther")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.PHYSICAL]=6 }, "kinther")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.PHYSICAL]=10 }, "kinther")
			self:specialSetAdd({"wielder","psi_on_crit"}, 1, "kinther")
			self:specialSetAdd({"wielder","combat_physresist"}, 6, "kinther")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/kinetic-mastery"] = 0.1 }, "kinther")
			game.logSeen(who, "#YELLOW#You feel psionic energy linking the mindstars.")
		end,
		resonating = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "resonating")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "resonating")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL]=5 }, "resonating")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.PHYSICAL]=3 }, "resonating")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.PHYSICAL]=5 }, "resonating")
			self:specialSetAdd({"wielder","psi_on_crit"}, 0.5, "resonating")
			self:specialSetAdd({"wielder","combat_physresist"}, 3, "resonating")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/kinetic-mastery"] = 0.05 }, "resonating")
			game.logSeen(who, "#YELLOW#You feel psionic energy linking the mindstars.")
		end,
	},
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_MINDSTAR", define_as = "CHARGED_FOCUS",
	power_source = {psionic=true},
	unique = true,
	name = "Charged Focus",
	unided_name = _t"sparking mindstar",
	level_range = {20, 40},
	color=colors.BLUE, image = "object/artifact/charged_focus.png",
	moddable_tile = "special/%s_charged_focus",
	rarity = 300,
	desc = _t[[Electrical energies are focussed in the core of this mindstar.]],
	cost = 100,
	require = { stat = { wil=24 }, },
	material_level = 3,
	combat = {
		dam = 10,
		apr = 24,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.LIGHTNING,
	},
	wielder = {
		combat_mindpower = 12,
		combat_mindcrit = 6,
		inc_damage = { [DamageType.LIGHTNING]=15 },
		resists_pen = { [DamageType.LIGHTNING] = 9 },
		resists = { [DamageType.LIGHTNING]=15 },
		max_psi = 30,
		combat_mentalresist = 9,
		talents_types_mastery = { ["psionic/charged-mastery"] = 0.15 },
		learn_talent = { [Talents.T_PSIONIC_MAELSTROM] = 1,},
	},
	ms_set_psionic = true,
	set_list = {
		multiple = true,
		kinchar = {{"define_as", "KINETIC_FOCUS"},},
		charther = {{"define_as", "THERMAL_FOCUS"},},
		resonating = {{"ms_set_resonating", true,},},
	},
	set_desc = {
		trifocus = _t"You feel two unconnected psionic channels on this item.",
	},
	on_set_complete = {
		multiple = true,
		kinchar = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "kinchar")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "kinchar")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.LIGHTNING]=5 }, "kinchar")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.LIGHTNING]=3 }, "kinchar")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.LIGHTNING]=5 }, "kinchar")
			self:specialSetAdd({"wielder","max_psi"}, 10, "kinchar")
			self:specialSetAdd({"wielder","combat_mentalresist"}, 3, "kinchar")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/charged-mastery"] = 0.05 }, "kinchar")
		end,
		charther = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 6, "charther")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 3, "charther")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.LIGHTNING]=10 }, "charther")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.LIGHTNING]=6 }, "charther")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.LIGHTNING]=10 }, "charther")
			self:specialSetAdd({"wielder","max_psi"}, 20, "charther")
			self:specialSetAdd({"wielder","combat_mentalresist"}, 6, "charther")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/charged-mastery"] = 0.1 }, "charther")
		end,
		resonating = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "resonating")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "resonating")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.LIGHTNING]=5 }, "resonating")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.LIGHTNING]=3 }, "resonating")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.LIGHTNING]=5 }, "resonating")
			self:specialSetAdd({"wielder","max_psi"}, 10, "resonating")
			self:specialSetAdd({"wielder","combat_mentalresist"}, 3, "resonating")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/charged-mastery"] = 0.05 }, "resonating")
		end,
	},
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_MINDSTAR", define_as = "THERMAL_FOCUS",
	power_source = {psionic=true},
	unique = true,
	name = "Thermal Focus",
	unided_name = _t"blazing mindstar",
	level_range = {30, 50},
	color=colors.RED, image = "object/artifact/thermal_focus.png",
	moddable_tile = "special/%s_thermal_focus",
	rarity = 300,
	desc = _t[[Thermal energies are focussed in the core of this mindstar.]],
	cost = 200,
	require = { stat = { wil=35 }, },
	material_level = 4,
	combat = {
		dam = 14,
		apr = 32,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.FIRE,
		convert_damage = {
			[DamageType.COLD] = 50,
		},
	},
	wielder = {
		combat_mindpower = 16,
		combat_mindcrit = 8,
		inc_damage = { [DamageType.FIRE]=20, [DamageType.COLD]=20,  },
		resists_pen = { [DamageType.FIRE] = 12, [DamageType.COLD]=12,  },
		resists = { [DamageType.FIRE]=20, [DamageType.COLD]=20,  },
		psi_regen = 1,
		combat_spellresist = 12,
		talents_types_mastery = { ["psionic/thermal-mastery"] = 0.2 },
		learn_talent = { [Talents.T_PSIONIC_MAELSTROM] = 1,},
	},
	ms_set_psionic = true,
	set_list = {
		multiple = true,
		kinther = {{"define_as", "KINETIC_FOCUS"},},
		charther = {{"define_as", "CHARGED_FOCUS"},},
		resonating = {{"ms_set_resonating", true,},},
	},
	set_desc = {
		trifocus = _t"You feel two unconnected psionic channels on this item.",
	},
	on_set_complete = {
		multiple = true,
		kinther = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "kinther")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "kinther")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "kinther")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.FIRE]=3, [engine.DamageType.COLD]=3, }, "kinther")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "kinther")
			self:specialSetAdd({"wielder","psi_regen"}, 1, "kinther")
			self:specialSetAdd({"wielder","combat_spellresist"}, 3, "kinther")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/thermal-mastery"] = 0.05 }, "kinther")
		end,
		charther = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "charther")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "charther")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "charther")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.FIRE]=3, [engine.DamageType.COLD]=3, }, "charther")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "charther")
			self:specialSetAdd({"wielder","psi_regen"}, 1, "charther")
			self:specialSetAdd({"wielder","combat_spellresist"}, 3, "charther")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/thermal-mastery"] = 0.05 }, "charther")
		end,
		resonating = function(self, who)
			self:specialSetAdd({"wielder","combat_mindpower"}, 2, "resonating")
			self:specialSetAdd({"wielder","combat_mindcrit"}, 1, "resonating")
			self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "resonating")
			self:specialSetAdd({"wielder","resists_pen"}, { [engine.DamageType.FIRE]=3, [engine.DamageType.COLD]=3, }, "resonating")
			self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE]=5, [engine.DamageType.COLD]=5, }, "resonating")
			self:specialSetAdd({"wielder","psi_regen"}, 1, "resonating")
			self:specialSetAdd({"wielder","combat_spellresist"}, 3, "resonating")
			self:specialSetAdd({"wielder","talents_types_mastery"},{ ["psionic/thermal-mastery"] = 0.05 }, "resonating")
		end,
	},
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {psionic=true},
	unique = true,
	name = "Lightning Catcher", image = "object/artifact/lightning_collector.png",
	unided_name = _t"coiled metal belt",
	desc = _t[[A fine mesh of metal threads held together by a sturdy chain. Sparks dance across it.]],
	special_desc = function(self) return _t[[Taking lightning damage or making critical hits builds 2 energy charges, which give you +5% lightning damage and +1 to all stats.
The charges decay at a rate of 1 per turn. Max 10 charges.]] end,
	color = colors.WHITE,
	level_range = {40, 50},
	rarity = 400,
	cost = 750,
	material_level = 5,
	wielder = {
		resists = {
			[DamageType.LIGHTNING] = 30,
		},
		stun_immune = 0.3,
		fatigue = 5,
	},
	callbackOnTakeDamage = function(self, src, x, y, type, dam, tmp, no_martyr)
		if type == engine.DamageType.LIGHTNING then
			self:setEffect(self.EFF_CAUGHT_LIGHTNING, 2, {})
		end
	end,
	callbackOnCrit = function(self, src, type, dam, chance, target)
		src:setEffect(src.EFF_CAUGHT_LIGHTNING, 2, {})
	end,
}
