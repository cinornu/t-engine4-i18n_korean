-- ToME - Tales of Middle-Earth
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

-- This file describes artifacts associated with a boss of the game, they have a high chance of dropping their respective ones, but they can still be found elsewhere

-- Design:  Revamp Wintertide to make it more unique, interesting, and not terrible.
-- Balance:  A cold themed weapon doesn't play nice with melee scalers, and Ice Block on hit, while useful overall, has some obvious anti-synergy.  So instead of focusing on stats I added a decent passive on hit and a very powerful active.  The active is a "better" Stone Wall but you have to be actively using the weapon in melee to make use of it.  The delayed expansion of the storm also limits its strength as an "oh shit" button.
newEntity{ base = "BASE_LONGSWORD",
	power_source = {arcane=true},
	define_as = "LONGSWORD_WINTERTIDE", unided_name = _t"glittering longsword", image="object/artifact/wintertide.png",
	name = "Wintertide", unique=true,
	moddable_tile = "special/%s_wintertide",
	moddable_tile_big = true,
	desc = _t[[The air seems to freeze around the blade of this sword, draining all heat from the area.
It is said the Conclave created this weapon for their warmaster during the dark times of the first allure war.]],
	require = { stat = { str=35 }, },
	level_range = {35, 45},
	rarity = 280,
	cost = 1000,
	material_level = 5,
	winterStorm = nil,
	special_desc = function(self)
		local storm = self.winterStorm
		if not storm or storm.duration <=0 then
			return (_t"No Winter Storm Active")
		else
			return (_t"Winter Storm: " .. ((storm.duration and storm.radius) and ("radius %d (%d turns remaining)"):tformat(math.floor(storm.radius), storm.duration) or _t"None"))
		end
	end,
	combat = {
		dam = 39, -- lower damage, defensive item with extremely powerful effects
		apr = 10,
		physcrit = 10,
		dammod = {str=1},
		damrange = 1.4,
		melee_project={[DamageType.ICE] = 25}, -- Iceblock HP is based on damage, since were adding iceblock pierce we want this to be less generous
		special_on_hit = {
			desc=function(self, who, special)
				local dam = who:damDesc(engine.DamageType.COLD, special:damage(self, who))
				return ("Create a Winter Storm that gradually expands (from radius %d to radius %d), dealing %0.2f cold damage (based on Strength) to your enemies each turn and slowing their ability to act by 20%%.  Subsequent melee strikes will relocate the storm on top of your target and increase its duration."):tformat(special.radius, special.max_radius, dam)
			end,
			on_kill=1,
			damage = function(special, self, who) return who:combatStatScale("str", 20, 80, 0.75) end,
			duration = 5,
			radius = 1,
			max_radius = 4,
			fct=function(combat, who, target, dam, special)
				local Object = require "mod.class.Object"
				local Map = require "engine.Map"

				-- special_on_hit doesn't know what item triggered it, so find it
				local self, item, inven_id = who:findInAllInventoriesBy("define_as", "LONGSWORD_WINTERTIDE")
				if not self or not who:getInven(inven_id).worn then return end

				if who.turn_procs.wintertide_sword then return end

				-- The reference to winterStorm is lost sometimes on reload but since we know only one can ever exist we can just check the map effects and set the reference every proc
				self.winterStorm = nil
				for k, eff in pairs(game.level.map.effects) do
					if eff and eff.is_wintertide then
						self.winterStorm = eff
					end
				end

				-- Who knows if this is necessary
				if self.winterStorm and self.winterStorm.duration <= 0 then
					self.winterStorm = nil
				end
				who.turn_procs.wintertide_sword = true

				-- If the map has no Winter Storm then create one
				if not self.winterStorm then
					game.logSeen(target, "#LIGHT_BLUE#A Winter Storm forms around %s.", target:getName():capitalize())
					local stormDam = special:damage(self, who)
					self.winterStorm = game.level.map:addEffect(who,
						target.x, target.y, special.duration,
						engine.DamageType.WINTER, {dam=stormDam, x=target.x, y=target.y}, -- Winter is cold damage+energy reduction, enemy only
						special.radius, -- starting radius
						5, nil,
						{type="icestorm", only_one=true, args = {radius = 1}},
						function(e, update_shape_only)
							if not update_shape_only then
								 -- Increase the radius by 0.2 each time the effect ticks (1000 energy)
								if e.radius < e.max_radius then
									e.radius = e.radius + 0.2
									if e.particles and math.floor(e.particles[1].args.radius) ~= math.floor(e.radius) then -- expand the graphical effect
										e.particles[1].args.radius = e.radius
										e.particles[1].radius = e.radius -- is this needed?
										e.particles[1]:dieDisplay()
										e.particles[1]:checkDisplay()
									end
								end
							end
							return true
						end,
						false,
						false
					)
					self.winterStorm.is_wintertide = true
					self.winterStorm.max_radius = special.max_radius
				else
					-- The storm already exists so move it on top of the target and increase its duration
					self.winterStorm.x = target.x
					self.winterStorm.y = target.y
					if self.winterStorm.duration < 7 then -- duration can be extended forever while meleeing
						self.winterStorm.duration = self.winterStorm.duration + 2
					end
					game.level.map.changed = true
				end
			end
		},
	},
	wielder = {
		iceblock_pierce=35, -- this can be generous because of how melee specific the item is
		resists = { [DamageType.COLD] = 25 },
		on_melee_hit={[DamageType.ICE] = 40},
		inc_damage = { [DamageType.COLD] = 20 },
	},
	max_power = 40, power_regen = 1,
	use_power = { name =_t"precipitate ice walls (lasting 10 turns) within your Winter Storm's area", power = 30,
		use = function(self, who)

			local Object = require "mod.class.Object"
			local Map = require "engine.Map"

			if not self.winterStorm then return end

			if self.winterStorm and self.winterStorm.duration <= 0 then
				self.winterStorm = nil
				return
			end

			local grids = core.fov.circle_grids(self.winterStorm.x, self.winterStorm.y, self.winterStorm.radius, true)
			game.logSeen(who, "#LIGHT_BLUE#%s brandishes %s %s, releasing a wave of Winter cold!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
			self.use_power.last_use = {turn = game.turn, x = self.winterStorm.x, y = self.winterStorm.y, radius = self.winterStorm.radius} -- for ai purposes

			local msg = false
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local oe = game.level.map(x, y, engine.Map.TERRAIN)

				if oe then
					if oe._wintertide_ice_wall then
						oe.temporary = 10
					elseif not oe:check("block_move", x, y) then
						local e = Object.new{
							old_feat = oe,
							name = _t"winter wall", image = "npc/iceblock.png",
							_wintertide_ice_wall = true,
							display = '#', color_r=255, color_g=255, color_b=255, back_color=colors.GREY,
							desc = _t"a summoned wall of ice",
							type = "wall", --subtype = "floor",
							always_remember = true,
							can_pass = {pass_wall=1},
							does_block_move = true,
							show_tooltip = true,
							block_move = true,
							block_sight = true,
							temporary = 10,
							x = x, y = y,
							canAct = false,
							act = function(self)
								self:useEnergy()
								self.temporary = self.temporary - 1
								if self.temporary <= 0 then
									game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
									game.level:removeEntity(self, true)
								end
							end,
							dig = function(src, x, y, old)
								game.level:removeEntity(old, true)
								return nil, old.old_feat
							end,
							summoner_gain_exp = true,
							summoner = who,
						}
						e.tooltip = mod.class.Grid.tooltip
						game.level:addEntity(e)
						game.level.map(x, y, engine.Map.TERRAIN, e)
						if game.level.map.seens(x, y) and game.player:canSee(e) then msg = true end
					end
				end
			end end
			if msg then game.log("#LIGHT_BLUE#Ice and snow form a barrier!") end
			return {id=true, used=true}
		end,
		on_pre_use = function(self, who, silent, fake)
			if not self.winterStorm then return false end
			local last_use = self.use_power.last_use
			if last_use then
				if game.turn - last_use.turn >= 11*game.energy_to_act/game.energy_per_tick then -- no current icewalls
					return true
				else -- current icewall, don't overlap
					if core.fov.distance(self.winterStorm.x, self.winterStorm.y, last_use.x, last_use.y) < math.floor(last_use.radius) then	return false end
				end
			end
			return true
		end,
		tactical = function(self, who, aitarget)
			if not (self.winterStorm and aitarget) then return end
			local tx, ty
			if not who:playerControlled() then tx, ty = who:aiSeeTargetPos(aitarget)
			else tx, ty = aitarget.x, aitarget.y end
			local TDist, TEnv, SEnv=
				core.fov.distance(who.x, who.y, tx, ty), -- dist to target
				core.fov.distance(tx, ty, self.winterStorm.x, self.winterStorm.y) < math.floor(self.winterStorm.radius), -- walls would surround target
				core.fov.distance(who.x, who.y, self.winterStorm.x, self.winterStorm.y) < math.floor(self.winterStorm.radius) -- walls would surround us

			local tac = {}
			-- escape: want walls around target but not around us if possible (so we can flee)
			local val = 0
			if TEnv then -- walls around target
				if not SEnv then val = val + 3 -- but not us
				elseif TDist > 1 then val = val + 1
				end
			elseif SEnv then -- walls around us
				if TDist > 1 then val = val + 0.5 end -- and target is not adjacent
			end
			if val > 0 then tac.escape = val end
			-- defense against multiple foes: want target adjacent with walls around us and target if possible
			val = 0
			if (TDist or 0) <= 1 then
				if SEnv then val = val + 1.5 end
				if TEnv then val = val + 0.5 end
			end
			if val > 0 then tac.defend = val end
			if who.summoner then -- protect summoner if we have one
				TDist =	core.fov.distance(who.summoner.x, who.summoner.y, tx, ty)
				SEnv = core.fov.distance(who.summoner.x, who.summoner.y, self.winterStorm.x, self.winterStorm.y) < math.floor(self.winterStorm.radius)
				val = 0
				if (TDist or 0) > 1 then -- summoner not adjacent to target
					if TEnv then val = val + 1 end -- walls around target
					if SEnv then val = val + 0.5 end -- walls around summoner
				end
				if val > 0 then tac.protect = val end
			end
			if true then return tac end
		end,
		radius = function(self, who)
			local winterStorm = self.winterStorm
			if winterStorm and winterStorm.duration > 0 then
				return winterStorm.radius
			else
				return 0
			end
		end,
	},
	on_wear = function(self, who)
		self.winterStorm = nil
	end,
	on_pickup = function(self, who)
		self.winterStorm = nil
	end,
}

newEntity{ base = "BASE_LITE", define_as = "WINTERTIDE_PHIAL",
	power_source = {arcane=true},
	unided_name = _t"phial filled with darkness", unique = true, image="object/artifact/wintertide_phial.png",
	name = "Wintertide Phial", color=colors.DARK_GREY,
	desc = _t[[This phial seems filled with darkness, yet it cleanses your thoughts.]],
	level_range = {1, 25},
	rarity = 200,
	encumber = 2,
	cost = 50,
	material_level = 2,

	wielder = {
		lite = 1,
		infravision = 6,
	},

	max_power = 60, power_regen = 1,
	use_power = {
		name = function(self, who) return ("cleanse your mind of up to %d (based on Magic) detrimental mental effects"):tformat(self.use_power.nbcure(self, who)) end,
		power = 40,
		nbcure = function(self, who) return math.floor(who:combatStatScale("mag", 2.5, 6, "log")) end,
		use = function(self, who)
			local target = who
			local effs = {}
			local known = false

			game.logSeen(who, "%s uses %s %s to cleanse %s mind!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color=true}), who:his_her())
			-- Go through all mental effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "mental" and e.status == "detrimental" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			for i = 1, self.use_power.nbcure(self, who) do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					target:removeEffect(eff[2])
					known = true
				end
			end
			return {id=true, used=true}
		end,
		tactical = {CURE = function(who, t, aitarget) -- count number of mental effects
			local nb = 0
			for eff_id, p in pairs(who.tmp) do
				local e = who.tempeffect_def[eff_id]
				if e.status == "detrimental" and e.type == "mental" then
					nb = nb + 1
				end
			end
			return nb
		end
		},
	},
}

-- Artifact, dropped by Rantha
newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {nature=true},
	define_as = "FROST_TREADS",
	unided_name = _t"ice-covered boots",
	name = "Frost Treads", unique=true, image="object/artifact/frost_treads.png",
	desc = _t[[A pair of leather boots. Cold to the touch, they radiate a cold blue light.]],
	level_range = {10, 18},
	material_level = 2,
	rarity = 220,
	cost = 200,
	special_desc = function(self) return _t"Each step taken casts a ground frost effect in a radius of 1 around you for 5 turns, giving you a 20% cold damage bonus for 3 turns. Additionally, any enemy standing in the frost has a 20% chance of talent failure for 3 turns." end,
	callbackOnMove = function(self, who, moved, force, ox, oy, x, y)
			if not moved or force or (ox == who.x and oy == who.y) then return end
			local Talents = require "engine.interface.ActorTalents"

			local e = game.level.map:hasEffectType(who.x, who.y, engine.DamageType.ITEM_FROST_TREADS)
			if not e then
				game.level.map:addEffect(who,
					who.x, who.y, 5,
					engine.DamageType.ITEM_FROST_TREADS, {},
					1,
					5, nil,
					engine.MapEffect.new{zdepth=3, color_br=245, color_bg=245, color_bb=245, effect_shader="shader_images/ice_effect.png"},
					function(e, update_shape_only, todel, i)
						if not e.__setup_frost_tread then
							e.__setup_frost_tread = true
							e.grids_duration = {}
							for lx, ys in pairs(e.grids) do
								e.grids_duration[lx] = {}
								for ly, _ in pairs(ys) do
									e.grids_duration[lx][ly] = e.duration
								end
							end
							e.duration = 50
						end
						if update_shape_only then return end

						-- Find the ones to remove
						local toremove = {}
						for lx, ys in pairs(e.grids_duration) do
							for ly, _ in pairs(ys) do
								e.grids_duration[lx][ly] = e.grids_duration[lx][ly] - 1
								if e.grids_duration[lx][ly] <= 0 then toremove[#toremove+1] = {x=lx, y=ly} end
							end
						end

						-- Remove then now
						while #toremove > 0 do
							local g = table.remove(toremove)
							e.grids_duration[g.x][g.y] = nil
							if not next(e.grids_duration[g.x]) then e.grids_duration[g.x] = nil end
							e.grids[g.x][g.y] = nil
							if not next(e.grids[g.x]) then e.grids[g.x] = nil end
						end

						-- If nothing is left, we remove the while effect
						if not next(e.grids) then
							table.insert(todel, i)
						end

						return false
					end, true
				)
			else
				if not e.grids_duration then return end
				e.x, e.y = who.x, who.y
				e.duration = 50
				local ngrids = core.fov.circle_grids(who.x, who.y, 1, true)
				for lx, ys in pairs(ngrids) do
					for ly, _ in pairs(ys) do
						e.grids[lx] = e.grids[lx] or {}
						e.grids[lx][ly] = true
						e.grids_duration[lx] = e.grids_duration[lx] or {}
						e.grids_duration[lx][ly] = 5
					end
				end
			end
	end,
	wielder = {
		lite = 1,
		combat_armor = 4,
		combat_def = 1,
		fatigue = 7,
		movement_speed = 0.2,
		inc_damage = {
			[DamageType.COLD] = 15,
		},
		resists = {
			[DamageType.COLD] = 20,
			[DamageType.NATURE] = 10,
		},
		inc_stats = { [Stats.STAT_STR] = 4, [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 4, },
	},
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	define_as = "DRAGON_SKULL",
	name = "Dragonskull Helm", unique=true, unided_name=_t"skull helm", image = "object/artifact/dragonskull_helmet.png",
	desc = _t[[Traces of a dragon's power still remain in this bleached and cracked skull.]],
	require = { stat = { wil=24 }, },
	level_range = {45, 50},
	material_level = 5,
	rarity = 280,
	cost = 200,

	wielder = {
		resists = {
			[DamageType.PHYSICAL] = 15,
			[DamageType.FIRE] = 15,
			[DamageType.COLD] = 15,
			[DamageType.ACID] = 15,
			[DamageType.LIGHTNING] = 15,
		},
		esp = {dragon=1},
		combat_armor = 20,
		fatigue = 12,
		combat_physresist = 12,
		combat_mentalresist = 12,
		combat_spellresist = 12,
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {nature=true},
	define_as = "EEL_SKIN", image = "object/artifact/eel_skin_armor.png",
	name = "Eel-skin armour", unique=true,
	unided_name = _t"slippery armour", color=colors.VIOLET,
	desc = _t[[This armour seems to have been patched together from many eels. Yuck.]],
	level_range = {5, 12},
	rarity = 200,
	cost = 500,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_DEX] = 2, [Stats.STAT_CUN] = 3,  },
		poison_immune = 0.5,
		pin_immune = 0.5, --it makes you slippery--
		combat_def = 16,
		fatigue = 2,
		resists={[DamageType.LIGHTNING] = 15,},
	},

	max_power = 50, power_regen = 1,
	use_talent = { id = Talents.T_CALL_LIGHTNING, level=2, power = 25 },
	talent_on_wild_gift = { {chance=10, talent=Talents.T_CALL_LIGHTNING, level=2} },
}

newEntity{ base = "BASE_RING",
	power_source = {psionic=true},
	define_as = "NIGHT_SONG",
	name = "Nightsong", unique=true, image = "object/artifact/ring_nightsong.png",
	desc = _t[[A pitch black ring, unadorned. It seems as though tendrils of darkness creep upon it.]],
	unided_name = _t"obsidian ring",
	level_range = {15, 23},
	rarity = 250,
	cost = 500,
	material_level = 2,
	wielder = {
		max_stamina = 25,
		combat_def = 6,
		fatigue = -7,
		inc_stats = { [Stats.STAT_CUN] = 6 },
		combat_mentalresist = 13,
		talent_cd_reduction={
			[Talents.T_SHADOWSTEP]=1,
		},
		inc_damage={ [DamageType.DARKNESS] = 10, },
	},

	max_power = 50, power_regen = 1,
	use_talent = { id = Talents.T_SHADOWSTEP, level=2, power = 50 },
}

newEntity{ base = "BASE_HELM",
	power_source = {nature=true},
	define_as = "HELM_OF_GARKUL",
	unided_name = _t"tribal helm",
	name = "Steel Helm of Garkul", unique=true, image="object/artifact/helm_of_garkul.png",
	desc = _t[[A great helm that belonged to Garkul the Devourer, one of the greatest orcs ever to live.]],
	require = { stat = { str=16 }, },
	level_range = {12, 22},
	rarity = 200,
	cost = 500,
	material_level = 2,
	skullcracker_mult = 5,

	wielder = {
		combat_armor = 6,
		fatigue = 8,
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, [Stats.STAT_WIL] = 4 },
		inc_damage={ [DamageType.PHYSICAL] = 10, },
		combat_physresist = 12,
		combat_mentalresist = 12,
		combat_spellresist = 12,
		talents_types_mastery = {["technique/thuggery"]=0.2},
	},

	set_list = { {"define_as","SET_GARKUL_TEETH"} },
	set_desc = {
		garkul = _t"Another of Garkul's heirlooms would bring out his spirit.",
	},
	on_set_complete = function(self, who)
		self:specialSetAdd("skullcracker_mult", 1)
		self:specialSetAdd({"wielder","melee_project"}, {[engine.DamageType.GARKUL_INVOKE]=5})
	end,
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	define_as = "LUNAR_SHIELD",
	unique = true,
	name = "Lunar Shield", image = "object/artifact/shield_lunar_shield.png",
	moddable_tile = "special/%s_lunar_shield",
	moddable_tile_big = true,
	unided_name = _t"chitinous shield",
	desc = _t[[A large section of chitin removed from Nimisil. It continues to give off a strange white glow.]],
	color = colors.YELLOW,
	metallic = false,
	require = { stat = { str=35 }, },
	level_range = {40, 50},
	rarity = 280,
	cost = 350,
	material_level = 5,
	special_combat = {
		dam = 45,
		block = 250,
		physcrit = 10,
		dammod = {str=1},
		damrange = 1.4,
		damtype = DamageType.DARKNESS,
	},
	wielder = {
		resists={[DamageType.DARKNESS] = 25},
		inc_damage={[DamageType.DARKNESS] = 40},

		combat_armor = 20,
		combat_spellpower = 20,
		fatigue = 2,

		talents_types_mastery = {["celestial/star-fury"]=0.3, ["celestial/twilight"]=0.3,},
		learn_talent = { [Talents.T_BLOCK] = 1, },
	},
	talent_on_spell = { {chance=10, talent=Talents.T_MOONLIGHT_RAY, level=2} },
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true},
	define_as = "WRATHROOT_SHIELD",
	unided_name = _t"large chunk of wood",
	moddable_tile = "special/%s_wrathroots_barkwood",
	moddable_tile_big = true,
	name = "Wrathroot's Barkwood", unique=true, image="object/artifact/shield_wrathroots_barkwood.png",
	desc = _t[[The barkwood of Wrathroot, made into roughly the shape of a shield.]],
	require = { stat = { str=25 }, },
	level_range = {12, 22},
	rarity = 200,
	cost = 20,
	material_level = 2,
	metallic = false,
	special_combat = {
		dam = resolvers.rngavg(20,30),
		block = 60,
		physcrit = 2,
		dammod = {str=1.5},
		damrange = 1.4,
	},
	wielder = {
		combat_armor = 10,
		combat_def = 9,
		fatigue = 14,
		resists = {
			[DamageType.DARKNESS] = 20,
			[DamageType.COLD] = 20,
			[DamageType.NATURE] = 20,
		},
		learn_talent = { [Talents.T_BLOCK] = 1, },
	},
}

newEntity{ base = "BASE_GEM",
	power_source = {nature=true},
	unique = true, define_as = "PETRIFIED_WOOD",
	unided_name = _t"burned piece of wood",
	name = "Petrified Wood", subtype = "red", --Visually black, but associate with fire, not acid
	color = colors.WHITE, image = "object/artifact/petrified_wood.png",
	level_range = {35, 45},
	rarity = 280,
	desc = _t[[A piece of the scorched wood taken from the remains of Snaproot.]],
	cost = 100,
	material_level = 4,
	color_attributes = {
		damage_type = 'FIRE',
		alt_damage_type = 'FLAMESHOCK',
		particle = 'flame',
	},
	identified = false,
	imbue_powers = {
		resists = { [DamageType.NATURE] = 25, [DamageType.DARKNESS] = 10, [DamageType.COLD] = 10 },
		inc_stats = { [Stats.STAT_CON] = 25, },
		ignore_direct_crits = 23,
	},
	wielder = {
		resists = { [DamageType.NATURE] = 25, [DamageType.DARKNESS] = 10, [DamageType.COLD] = 10 },
		inc_stats = { [Stats.STAT_CON] = 25, },
		ignore_direct_crits = 23,
	},
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	unique = true, define_as = "CRYSTAL_SHARD",
	name = "Crystal Shard",
	unided_name = _t"crystalline tree branch",
	flavor_name = "magestaff",
	level_range = {10, 22},
	color=colors.BLUE, image = "object/artifact/crystal_shard.png",
	rarity = 300,
	desc = _t[[This crystalline tree branch is remarkably rigid, and refracts light in myriad colors. Gazing at it entrances you, and you worry where its power may have come from.]],
	cost = 200,
	material_level = 2,
	require = { stat = { mag=20 }, },
	combat = {
		dam = 16,
		apr = 4,
		dammod = {mag=1.3},
		damtype = DamageType.ARCANE,
		convert_damage = {
			[DamageType.BLIGHT] = 50,
		},
	},
	wielder = {
		combat_spellpower = 14,
		combat_spellcrit = 4,
		inc_damage={
			[DamageType.ARCANE] = 18,
			[DamageType.BLIGHT] = 18,
		},
		resists={
			[DamageType.ARCANE] = 10,
			[DamageType.BLIGHT] = 10,
		},
		damage_affinity={
			[DamageType.ARCANE] = 20,
		},
	},
	max_power = 45, power_regen = 1,
	use_power = { name = _t"create 2 living shards of crystal to serve you for 10 turns", power = 45, use = function(self, who)
		if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end

		local NPC = require "mod.class.NPC"
		local list = NPC:loadList("/data/general/npcs/crystal.lua")
		game.logSeen(who, "Crystals splinter off of %s's %s and animate!", who:getName():capitalize(), self:getName({no_add_name = true, do_color=true}))
		for i = 1, 2 do
			-- Find space
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then break end
				local e
			repeat e = rng.tableRemove(list)

			until not e.unique and e.rarity
			e = e:clone()
			local crystal = game.zone:finishEntity(game.level, "actor", e)
			crystal.make_escort = nil
			crystal.silent_levelup = true
			crystal.faction = who.faction
			crystal.ai = "summoned"
			crystal.ai_real = "dumb_talented_simple"
			crystal.summoner = who
			crystal.summon_time = 10
			crystal.exp_worth = 0
			crystal:forgetInven(crystal.INVEN_INVEN)

			local setupSummon = getfenv(who:getTalentFromId(who.T_SPIDER).action).setupSummon
			setupSummon(who, crystal, x, y)
			game:playSoundNear(who, "talents/ice")
		end
		return {id=true, used=true}
	end,
	tactical = {ATTACK = 2}},
}

newEntity{ base = "BASE_WARAXE",
	power_source = {arcane=true},
	define_as = "MALEDICTION",
	unided_name = _t"pestilent waraxe",
	name = "Malediction", unique=true, image = "object/artifact/axe_malediction.png",
	moddable_tile = "special/%s_axe_malediction",
	moddable_tile_big = true,
	desc = _t[[The land withers and crumbles wherever this cursed axe rests.]],
	require = { stat = { str=55 }, },
	level_range = {35, 45},
	rarity = 290,
	cost = 450,
	material_level = 4,
	combat = {
		dam = 40,
		apr = 15,
		physcrit = 10,
		dammod = {str=1},
		damrange = 1.2,
		burst_on_hit={[DamageType.BLIGHT] = 25},
		talent_on_hit = {
				[Talents.T_CURSE_OF_VULNERABILITY] = {level=3, chance=10},
				[Talents.T_CURSE_OF_DEATH] = {level=3, chance=10},
		},
	},
	wielder = {
		combat_spellpower = 20,
		inc_damage = { [DamageType.BLIGHT] = 20 },
	},
	talent_on_spell = {
			{talent=Talents.T_CURSE_OF_DEFENSELESSNESS, level=3, chance=10},
			{talent=Talents.T_CURSE_OF_IMPOTENCE, level=3, chance=10},
	},
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	define_as = "STAFF_KOR", image = "object/artifact/staff_kors_fall.png",
	unided_name = _t"dark staff",
	flavor_name = "vilestaff",
	flavors = {vilestaff=true},
	name = "Kor's Fall", unique=true,
	desc = _t[[Made from the bones of many creatures, this staff glows with power. You can feel its evil presence even from a distance.]],
	require = { stat = { mag=25 }, },
	level_range = {1, 10},
	rarity = 200,
	cost = 60,
	material_level = 1,
	combat = {
		is_greater = true,
		dam = 10,
		apr = 0,
		physcrit = 1.5,
		dammod = {mag=1.1},
		element = DamageType.DARKNESS,
	},
	wielder = {
		see_invisible = 2,
		combat_spellpower = 7,
		combat_spellcrit = 8,
		inc_damage={
			[DamageType.ACID] = 10,
			[DamageType.DARKNESS] = 10,
			[DamageType.FIRE] = 10,
			[DamageType.BLIGHT] = 10,
		},
		talents_types_mastery = { ["corruption/bone"] = 0.1, },
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1},
	},
	max_power = 6, power_regen = 1,
	use_talent = { id = Talents.T_BONE_SPEAR, level = 3, power = 6 },
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true},
	define_as = "VOX",
	name = "Vox", unique=true,
	unided_name = _t"ringing amulet", color=colors.BLUE, image="object/artifact/jewelry_amulet_vox.png",
	desc = _t[[No force can hope to silence the wearer of this amulet.]],
	level_range = {40, 50},
	rarity = 220,
	cost = 3000,
	material_level = 5,
	wielder = {
		see_invisible = 20,
		silence_immune = 1,
		combat_spellpower = 9,
		combat_spellcrit = 4,
		max_mana = 50,
		combat_spellspeed = 0.15,
		max_vim = 50,
	},
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	define_as = "TELOS_TOP_HALF", image = "object/artifact/staff_broken_top_telos.png",
	slot_forbid = false,
	twohanded = false,
	unided_name = _t"broken staff", flavor_name = "magestaff",
	flavors = {magestaff=true},
	name = "Telos's Staff (Top Half)", unique=true,
	desc = _t[[The top part of Telos' broken staff.]],
	require = { stat = { mag=35 }, },
	level_range = {40, 50},
	rarity = 210,
	encumber = 2.5,
	material_level = 5,
	cost = 500,
	combat = {
		dam = 35,
		apr = 0,
		physcrit = 1.5,
		dammod = {mag=1.0},
		element = DamageType.ARCANE,
	},
	wielder = {
		combat_spellpower = 30,
		combat_spellcrit = 15,
		combat_mentalresist = 8,
		inc_stats = { [Stats.STAT_WIL] = 5, },
		inc_damage = {[DamageType.ARCANE] = 35 },
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1 },
	},
	set_list = { {"define_as","TELOS_BOTTOM_HALF"}, {"define_as","GEM_TELOS"} },
	on_set_complete = function(self, who)
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true},
	define_as = "AMULET_DREAD",
	name = "Choker of Dread", unique=true, image = "object/artifact/amulet_choker_of_dread.png",
	unided_name = _t"dark amulet", color=colors.LIGHT_DARK,
	desc = _t[[The evilness of undeath radiates from this amulet.]],
	level_range = {20, 28},
	rarity = 220,
	cost = 500,
	material_level = 3,
	wielder = {
		see_invisible = 10,
		blind_immune = 1,
		combat_spellpower = 5,
		combat_dam = 5,
	},
	on_takeoff = function(self)
		if self.summoned_vampire then self.summoned_vampire:die() end
		self.summoned_vampire = nil
	end,
	max_power = 60, power_regen = 1,
	use_power = { name = _t"summon an elder vampire with Taunt to your side for 15 turns", power = 60, use = function(self, who)
		if not who:canBe("summon") then game.logPlayer(who, "You cannot summon; you are suppressed!") return end

		local tg = {type="ball", radius=10, friendlyfire=false, selffire=false}
		local tgts = {}
		who:project(tg, who.x, who.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if target then tgts[#tgts+1] = target end
		end)

		local target = rng.tableRemove(tgts)
		if not target then
			game.logPlayer(who, "You need an enemy nearby to summon!")
			return
		end

		local x, y = util.findFreeGrid(target.x, target.y, 10, true, {[engine.Map.ACTOR]=true})
		if not x then
			game.logPlayer(who, "Not enough space to summon!")
			return
		end
		print("Invoking guardian on", x, y)
		game.logSeen(who, "%s taps %s %s, summoning a vampire thrall!", who:getName():capitalize(), who:his_her(), self:getName({no_add_name = true, do_color=true}))

		-- No gear melee that forces things to attack it, we have to do some work to make this useful..
		-- Worse, we need to be able to beat accuracy and ppower checks to land our talents, but scaling off our source on an item is bad for those
		-- Better to let level handle most of the scaling then
		local NPC = require "mod.class.NPC"
		local vampire = NPC.new{
			type = "undead", subtype = "vampire",
			display = "V", image = "npc/elder_vampire.png",
			name = _t"elder vampire", color=colors.RED,
			desc=_t[[A terrible robed undead figure, this creature has existed in its unlife for many centuries by stealing the life of others. It can summon the very shades of its victims from beyond the grave to come enslaved to its aid.]],

			combat = { dam=resolvers.levelup(80, 1, 4), atk=10, apr=who.level / 2, damtype=engine.DamageType.DRAINLIFE, dammod={str=1.9} },
			combat_atk = resolvers.levelup(1, 1, 4),
			combat_dam = resolvers.levelup(1, 1, 4),

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

			autolevel = "warriormage",

			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, },
			stats = { str=12, dex=12, mag=12, con=12 },
			life_regen = 3,
			life_rating = 14,
			size_category = 3,
			rank = 3,
			infravision = 10,

			inc_damage = table.clone(who.inc_damage, true),
			resists_pen = table.clone(who.resists_pen, true),

			resists = { all = math.min(who.level / 2, 40), [engine.DamageType.COLD] = 80, [engine.DamageType.NATURE] = 80, [engine.DamageType.LIGHT] = -50,  },
			blind_immune = 1,
			confusion_immune = 1,
			see_invisible = 5,
			undead = 1,

			level_range = {1, who.level}, exp_worth = 0,
			max_life = resolvers.rngavg(90,100),
			combat_armor = 12 + who.level / 2, combat_def = who.level,
			combat_armor_hardiness = 20,  -- 50% total
			resolvers.talents{
				[who.T_STUN]={base=2, every=6, max=5},
				[who.T_BLUR_SIGHT]={start = 10, base=2, every=6, max=5},
				[who.T_PHANTASMAL_SHIELD]={start = 5, base=1, every=6, max=5},
				[who.T_ROTTING_DISEASE]={start = 10, base=1, every=6, max=5},
				[who.T_TAUNT]=3,
				[who.T_BLURRED_MORTALITY]={base=1, every=7, max=6},
			},
			resolvers.sustains_at_birth(),
			faction = who.faction,
			summoner = who,
			summon_time = 15,
			summoner_gain_exp=true,
		}

		vampire:resolve()
		vampire:resolve(nil, true)
		vampire:forceLevelup(who.level)
		game.zone:addEntity(game.level, vampire, "actor", x, y)
		vampire:setTarget(target)
		vampire:forceUseTalent(vampire.T_TAUNT, {ignore_energy=true})

		if game.party:hasMember(who) then
			vampire.remove_from_party_on_death = true
			game.party:addMember(vampire, {
				control="no",
				temporary_level = true,
				type="minion",
				title=_t"Vampire",
			})
		end
		self.summoned_vampire = vampire

		game:playSoundNear(who, "talents/spell_generic")
		return {id=true, used=true}
	end,
	tactical = {ATTACK = 2, SURROUNDED = 2}},
}

newEntity{ define_as = "RUNED_SKULL",
	power_source = {arcane=true},
	unique = true,
	type = "gem", subtype="red", image = "object/artifact/bone_runed_skull.png",
	unided_name = _t"human skull",
	name = "Runed Skull",
	display = "*", color=colors.RED,
	level_range = {40, 50},
	rarity = 390,
	cost = 150,
	encumber = 3,
	material_level = 5,
	desc = _t[[Dull red runes are etched all over this blackened skull.]],
	color_attributes = {
		damage_type = 'FIRE',
		alt_damage_type = 'FLAMESHOCK',
		particle = 'flame',
	},

	carrier = {
		combat_spellpower = 7,
		on_melee_hit = {[DamageType.FIRE]=25},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true},
	define_as = "GREATMAUL_BILL_TRUNK",
	unided_name = _t"tree trunk", image = "object/artifact/bill_treestump.png",
	name = "Bill's Tree Trunk", unique=true,
	desc = _t[[This is a big, nasty-looking tree trunk that Bill the Troll used as a weapon. It could still serve this purpose, should you be strong enough to wield it!]],
	require = { stat = { str=25 }, },
	level_range = {1, 10},
	material_level = 1,
	moddable_tile = "special/%s_treetrunk",
	moddable_tile_big = true,

	rarity = 200,
	metallic = false,
	cost = 70,
	combat = {
		dam = 30,
		apr = 7,
		physcrit = 1.5,
		dammod = {str=1.3},
		damrange = 1.7,
	},

	wielder = {
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_SHATTERING_BLOW, level = 2, power = 20 },
}

newEntity{ base = "BASE_SHIELD",
	power_source = {technique=true},
	define_as = "SANGUINE_SHIELD",
	unided_name = _t"bloody shield",
	name = "Sanguine Shield", unique=true, image = "object/artifact/sanguine_shield.png",
	moddable_tile = "special/%s_hand_sanguine_shield", moddable_tile_big = true,
	desc = _t[[Though tarnished and spattered with blood, the emblem of the Sun still manages to shine through on this shield.]],
	require = { stat = { str=39 }, },
	level_range = {35, 45},
	material_level = 4,
	rarity = 240,
	cost = 120,

	special_combat = {
		dam = 40,
		block = 220,
		physcrit = 9,
		dammod = {str=1.2},
		lifesteal = 8,
	},
	wielder = {
		combat_armor = 15,
		inc_stats = { [Stats.STAT_CON] = 10, },
		fatigue = 19,
		resists = {
		[DamageType.BLIGHT] = 25,
		[DamageType.LIGHT] = 10,
		},
		life_regen = 5,
		on_melee_hit = {[DamageType. DRAINLIFE] = 15},
		learn_talent = { [Talents.T_BLOCK] = 1, },
		talents_types_mastery = { ["cursed/bloodstained"] = 0.3, },
	},
}

newEntity{ base = "BASE_GLOVES", define_as = "FLAMEWROUGHT",
	power_source = {nature=true},
	unique = true,
	name = "Flamewrought", color = colors.RED, image = "object/artifact/gloves_flamewrought.png",
	unided_name = _t"chitinous gloves",
	desc = _t[[These gloves seems to be made out of the exoskeletons of ritches. They are hot to the touch.]],
	level_range = {5, 12},
	rarity = 180,
	cost = 50,
	material_level = 1,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 3, [Stats.STAT_CUN] = 2,},
		resists = { [DamageType.FIRE]= 10, },
		inc_damage = { [DamageType.FIRE]= 5, },
		combat_mindpower=2,
		combat_armor = 2,
		combat = {
			dam = 5,
			apr = 7,
			physcrit = 1,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={[DamageType.FIRE] = 10},
			talent_on_hit = { T_RITCH_FLAMESPITTER_BOLT = {level=3, chance=30} },
			convert_damage = { [DamageType.FIRE] = 100,},
		},
	},
	max_power = 24, power_regen = 1,
	use_talent = { id = Talents.T_RITCH_FLAMESPITTER_BOLT, level = 3, power = 8 },
}

-- The crystal set
newEntity{ base = "BASE_GEM", define_as = "CRYSTAL_FOCUS",
	power_source = {arcane=true},
	unique = true,
	unided_name = _t"scintillating crystal",
	name = "Crystal Focus", subtype = "multi-hued",
	color = colors.WHITE, image = "object/artifact/crystal_focus.png",
	level_range = {5, 12},
	desc = _t[[This crystal radiates the power of the Spellblaze itself.]],
	special_desc = function(self) return _t"(The created item can be activated to recover the Focus.)" end,
	rarity = 200,
	identified = false,
	cost = 50,
	material_level = 2,
	color_attributes = {
		damage_type = 'ARCANE',
		alt_damage_type = 'ARCANE_SILENCE',
		particle = 'manathrust',
	},

	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 5 },
		inc_damage = {[DamageType.ARCANE] = 20, [DamageType.BLIGHT] = 20 },
	},

	max_power = 1, power_regen = 1,
	use_power = { name = _t"combine with a weapon (makes a non enchanted weapon into an artifact)", power = 1, use = function(self, who, gem_inven, gem_item)
		who:showInventory(_t"Fuse with which weapon?", who:getInven("INVEN"), function(o) return (o.type == "weapon" or o.subtype == "hands" or o.subtype == "shield") and o.subtype ~= "mindstar" and not o.egoed and not o.unique and not o.rare and not o.archery end, function(o, item)
			local oldname = o:getName{do_color=true}

			-- Remove the gem
			who:removeObject(gem_inven, gem_item)
			who:sortInven(gem_inven)

			local Entity = require("engine.Entity")
			local ActorStats = require("engine.interface.ActorStats")
			local crystalline_ego = Entity.new{
				name = _t"crystalline weapon",
				no_unique_lore = true,
				is_crystalline_weapon = true,
				power_source = {arcane=true},
				wielder = {
					combat_spellpower = 12,
					combat_dam = 12,
					inc_stats = {
						[ActorStats.STAT_WIL] = 3,
						[ActorStats.STAT_CON] = 3,
					},
					inc_damage = {ARCANE=10},
				},
				set_list = { {"is_crystalline_armor", true} },
				on_set_complete = function(self, wearer)
					self.talent_on_spell = { {chance=10, talent="T_MANATHRUST", level=3} }
					local weapon = self.combat or self.wielder.combat or self.special_combat
					if weapon then weapon.talent_on_hit = { T_MANATHRUST = {level=3, chance=10} } end
					self:specialSetAdd({"wielder","combat_spellcrit"}, 10)
					self:specialSetAdd({"wielder","combat_physcrit"}, 10)
					self:specialSetAdd({"wielder","resists_pen"}, {[engine.DamageType.ARCANE]=20, [engine.DamageType.PHYSICAL]=15})
					game.logPlayer(wearer, "#GOLD#As the crystalline weapon and armour are brought together, they begin to emit a constant humming.")
				end,
				on_set_broken = function(self, wearer)
					local weapon = self.combat or self.wielder.combat or self.special_combat
					self.talent_on_spell = nil
					if weapon then weapon.talent_on_hit = nil end
					game.logPlayer(wearer, "#GOLD#The humming from the crystalline artifacts fades as they are separated.")
				end,
				resolvers.generic(function(o)
					o.name = ("Crystalline %s"):tformat(o:getName{trans_only=true}:capitalize())
					o.unique = o.name
					o.desc = (o.desc or "") .._t" Transformed with the power of the Spellblaze."
					end),
				resolvers.generic(function(o)
					if o.combat and o.combat.dam then
						o.combat.dam = o.combat.dam * 1.25
						o.combat.damtype = engine.DamageType.ARCANE
					elseif o.wielder.combat and o.wielder.combat.dam then
						o.wielder.combat.dam = o.wielder.combat.dam * 1.25
						o.wielder.combat.convert_damage = o.wielder.combat.convert_damage or {}
						o.wielder.combat.convert_damage[engine.DamageType.ARCANE] = 100
					elseif o.special_combat then
						if o.special_combat.dam then
							o.special_combat.dam = o.special_combat.dam * 1.25
							o.special_combat.damtype = engine.DamageType.ARCANE
						end
						if o.special_combat.block then
							o.special_combat.block = o.special_combat.block * 1.25
						end
					end

					o.power = 1
					o.max_power = 1
					o.power_regen = 1
					o.use_no_wear = true
					o.use_power = { name = _t"recover the Crystal Focus (destroys this weapon)", power = 1, use = function(self, who, inven, item)
						local art_list = mod.class.Object:loadList("/data/general/objects/objects-maj-eyal.lua")
						local o = art_list.CRYSTAL_FOCUS:clone()
						o:resolve()
						o:resolve(nil, true)
						o:identify(true)
						who:addObject(who.INVEN_INVEN, o)
						who:sortInven(who.INVEN_INVEN)
						local name = self:getName({no_count=true, force_id=true, no_add_name=true})
						for i, h in ipairs(who.hotkey) do
							if h[2] == name then who.hotkey[i] = nil end
						end
						who.changed = true
						game.logPlayer(who, "You created: %s", o:getName{do_color=true})
						return {used=true, id=true, destroy=true}
					end }
				end),
				resolvers.genericlast(function(o) if o.wielder.learn_talent then o.wielder.learn_talent["T_COMMAND_STAFF"] = nil end end),
				fake_ego = true,
			}
			game.zone:applyEgo(o, crystalline_ego, "object", true)
			local images = {
				battleaxe = "object/artifact/2haxe_crystalline.png",
				greatmaul = "object/artifact/2hmace_crystalline.png",
				greatsword = "object/artifact/2hsword_crystalline.png",
				dagger = "object/artifact/dagger_crystalline.png",
				longsword = "object/artifact/1hsword_crystalline.png",
				mace = "object/artifact/1hmace_crystalline.png",
				waraxe = "object/artifact/1haxe_crystalline.png",
				shield = "object/artifact/shield_crystalline.png",
				staff = "object/artifact/staff_crystalline.png",
				trident = "object/artifact/trident_crystalline.png",
				hands = "object/artifact/gauntlets_crystalline.png",
			}
			if images[o.subtype] then o.image = images[o.subtype] o:removeAllMOs() end
			o:resolve()

			who:sortInven()
			who.changed = true

			game.logPlayer(who, "You fix the crystal on the %s and create the %s.", oldname, o:getName{do_color=true})
		end)
	end,
	no_npc_use = true},
}

newEntity{ base = "BASE_GEM", define_as = "CRYSTAL_HEART",
	power_source = {arcane=true},
	unique = true,
	unided_name = _t"coruscating crystal",
	name = "Crystal Heart", subtype = "multi-hued",
	color = colors.RED, image = "object/artifact/crystal_heart.png",
	level_range = {35, 42},
	desc = _t[[This crystal is huge, easily the size of your head. It sparkles brilliantly almost of its own accord.]],
	special_desc = function(self) return _t"(The created item can be activated to recover the Heart.)" end,
	rarity = 250,
	identified = false,
	cost = 200,
	material_level = 5,
	color_attributes = {
		damage_type = 'ARCANE',
		alt_damage_type = 'ARCANE_SILENCE',
		particle = 'manathrust',
	},

	wielder = {
		inc_stats = {[Stats.STAT_CON] = 5 },
		resists = {[DamageType.ARCANE] = 20, [DamageType.BLIGHT] = 20 },
	},

	max_power = 1, power_regen = 1,
	use_power = { name = _t"combine with a suit of body armor (makes a non enchanted armour into an artifact)", power = 1, use = function(self, who, gem_inven, gem_item)
		-- Body armour only, can be cloth, light, heavy, or massive though. No clue if o.slot works for this.
		who:showInventory(_t"Fuse with which armor?", who:getInven("INVEN"), function(o) return o.type == "armor" and o.slot == "BODY" and not o.egoed and not o.unique and not o.rare end, function(o, item)
			local oldname = o:getName{do_color=true}

			-- Remove the gem
			who:removeObject(gem_inven, gem_item)
			who:sortInven(gem_inven)

			local Entity = require("engine.Entity")
			local ActorStats = require("engine.interface.ActorStats")
			local crystalline_ego = Entity.new{
				name = _t"crystalline armour",
				no_unique_lore = true,
				is_crystalline_armor = true,
				power_source = {arcane=true},
				wielder = {
					combat_spellresist = 35,
					combat_physresist = 25,
					inc_stats = {
						[ActorStats.STAT_MAG] = 8,
						[ActorStats.STAT_CON] = 8,
						[ActorStats.STAT_LCK] = 12,
					},
					resists = {ARCANE=35, PHYSICAL=15},
					poison_immune=0.6,
					disease_immune=0.6,
				},
				set_list = { {"is_crystalline_weapon", true} },
				on_set_complete = function(self, who)
					self:specialSetAdd({"wielder","stun_immune"}, 0.5)
					self:specialSetAdd({"wielder","blind_immune"}, 0.5)
				end,
				resolvers.generic(function(o)
					o.name = ("Crystalline %s"):tformat(o:getName{trans_only=true}:capitalize())
					o.unique = o.name
					o.desc = (o.desc or "") .._t" Transformed with the power of the Spellblaze."
				end),
				resolvers.generic(function(o)
					-- This is supposed to add 1 def for crap cloth robes if for some reason you choose it instead of better robes, and then multiply by 1.25.
					o.wielder.combat_def = ((o.wielder.combat_def or 0) + 2) * 1.7
					-- Same for armour. Yay crap cloth!
					o.wielder.combat_armor = ((o.wielder.combat_armor or 0) + 3) * 1.7

					o.power = 1
					o.max_power = 1
					o.power_regen = 1
					o.use_no_wear = true
					o.use_power = { name = _t"recover the Crystal Heart (destroys this armour)", power = 1, use = function(self, who, inven, item)
						local art_list = mod.class.Object:loadList("/data/general/objects/objects-maj-eyal.lua")
						local o = art_list["CRYSTAL_HEART"]:clone()
						o:resolve()
						o:resolve(nil, true)
						o:identify(true)
						who:addObject(who.INVEN_INVEN, o)
						who:sortInven(who.INVEN_INVEN)
						local name = self:getName({no_count=true, force_id=true, no_add_name=true})
						for i, h in ipairs(who.hotkey) do
							if h[2] == name then who.hotkey[i] = nil end
						end
						who.changed = true
						game.logPlayer(who, "You created: %s", o:getName{do_color=true})
						return {used=true, id=true, destroy=true}
					end }
				end),
			}
			game.zone:applyEgo(o, crystalline_ego, "object", true)
			local images = {
				cloth = "object/artifact/cloth_armour_crystalline.png",
				leather = "object/artifact/leather_armour_crystalline.png",
				heavy = "object/artifact/heavy_armour_crystalline.png",
				massive = "object/artifact/massive_armour_crystalline.png",
			}
			if images[o.subtype] then o.image = images[o.subtype] o:removeAllMOs() end
			o:resolve()

			who:sortInven()
			who.changed = true

			game.logPlayer(who, "You fix the crystal on the %s and create the %s.", oldname, o:getName{do_color=true})
		end)
	end,
	no_npc_use = true},
}

newEntity{ base = "BASE_ROD", define_as = "ROD_OF_ANNULMENT",
	power_source = {arcane=true},
	unided_name = _t"dark rod",
	name = "Rod of Annulment", color=colors.LIGHT_BLUE, unique=true, image = "object/artifact/rod_of_annulment.png",
	desc = _t[[You can feel magic draining out around this rod. Even nature itself seems affected.]],
	cost = 50,
	rarity = 380,
	level_range = {5, 12},
	elec_proof = true,
	add_name = "#CHARGES#",
	material_level = 2,
	max_power = 30, power_regen = 1,
	use_power = {
		name = function(self, who) return ("put up to 3 of the target's runes, infusions or talents on cooldown for 3-5 turns (range %d)"):tformat(self.use_power.range) end,
		power = 30,
		range = 5,
		requires_target = true,
		target = function(self, who) return {type="bolt", range=self.use_power.range} end,
		use = function(self, who)
			local tg = self.use_power.target(self, who)
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local target = game.level.map(x, y, engine.Map.ACTOR)
			who:logCombat(target or {x=x, y=y}, "#Source# aims %s %s at #target#!", who:his_her(), self:getName({no_add_name = true, do_color = true}))
			if not target then
				return {used = true}
			end
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end

				local tids = {}
				for tid, lev in pairs(target.talents) do
					local t = target:getTalentFromId(tid)
					if not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
				end
				for i = 1, 3 do
					local t = rng.tableRemove(tids)
					if not t then break end
					target.talents_cd[t.id] = rng.range(3, 5)
					game.logSeen(target, "%s's %s is disrupted!", target:getName():capitalize(), t.name)
				end
				target.changed = true
			end, nil, {type="flame"})
			return {id=true, used=true}
		end,
		tactical = {DISABLE = function(who, t, aitarget)
			local nb = 0
			for tid, lev in pairs(aitarget.talents) do
				local t = aitarget:getTalentFromId(tid)
				if not aitarget.talents_cd[tid] and t.mode == "activated" and not t.innate then nb = nb + 1 end
			end
			return nb^0.5
		end}
	},
}

newEntity{ base = "BASE_WARAXE",
	power_source = {arcane=true},
	define_as = "SKULLCLEAVER",
	unided_name = _t"crimson waraxe",
	name = "Skullcleaver", unique=true, image = "object/artifact/axe_skullcleaver.png",
	moddable_tile = "special/%s_axe_skullcleaver",
	moddable_tile_big = true,
	desc = _t[[A small but sharp axe, with a handle made of polished bone.  The blade has chopped through the skulls of many, and has been stained a deep crimson.]],
	require = { stat = { str=18 }, },
	level_range = {5, 12},
	material_level = 1,
	rarity = 220,
	cost = 50,
	combat = {
		dam = 20,
		apr = 4,
		physcrit = 12,
		dammod = {str=1},
		lifesteal = 10,
		convert_damage = {[DamageType.BLIGHT] = 25},
	},
	wielder = {
		inc_damage = { [DamageType.BLIGHT] = 8 },
	},
}

newEntity{ base = "BASE_DIGGER",
	power_source = {unknown=true},
	define_as = "TOOTH_MOUTH",
	unided_name = _t"a tooth", unique = true,
	name = "Tooth of the Mouth", image = "object/artifact/tooth_of_the_mouth.png",
	desc = _t[[A huge tooth taken from the Mouth, in the Deep Bellow.]],
	level_range = {5, 12},
	cost = 50,
	rarity = 200,
	material_level = 1,
	digspeed = 12,
	wielder = {
		inc_damage = { [DamageType.BLIGHT] = 5 },
		on_melee_hit = {[DamageType. DRAINLIFE] = 10},
		combat_apr = 15,
	},
}

newEntity{ base = "BASE_HEAVY_BOOTS",
	define_as = "WARPED_BOOTS",
	power_source = {unknown=true},
	unique = true,
	name = "The Warped Boots", image = "object/artifact/the_warped_boots.png",
	unided_name = _t"pair of painful-looking boots",
	desc = _t[[These blackened boots have lost all vestiges of any former glory they might have had. Now, they are a testament to the corruption of the Deep Bellow, and its power.]],
	color = colors.DARK_GREEN,
	level_range = {35, 45},
	rarity = 250,
	cost = 200,
	material_level = 5,
	wielder = {
		combat_armor = 4,
		combat_def = 2,
		combat_dam = 10,
		fatigue = 8,
		combat_spellpower = 10,
		combat_mindresist = 10,
		combat_spellresist = 10,
 		resists={
			[DamageType.BLIGHT] = 10,
 		},
		max_life = 80,
		life_regen = -0.20,
	},
	max_power = 50, power_regen = 1,
	use_talent = { id = Talents.T_SPIT_BLIGHT, level=3, power = 10 },
}

newEntity{ base = "BASE_AMULET",
	power_source = {psionic=true},
	define_as = "WITHERING_ORBS",
	unique = true,
	name = "Withering Orbs", color = colors.WHITE, image = "object/artifact/artifact_jewelry_withering_orbs.png",
	unided_name = _t"shadow-strung orbs",
	desc = _t[[These opalescent orbs stare at you with deathly knowledge, undeceived by your vanities and pretences.  They have lived and died through horrors you could never imagine, and now they lie strung in black chords watching every twitch of the shadows.
If you close your eyes a moment, you can almost imagine what dread sights they see...]],
	level_range = {5, 12},
	rarity = 200,
	cost = 100,
	material_level = 1,
	metallic = false,
	wielder = {
		blind_fight = 1,
		see_invisible = 10,
		see_stealth = 10,
		combat_mindpower = 5,
		melee_project = {
			[DamageType.MIND] = 5,
		},
		ranged_project = {
			[DamageType.MIND] = 5,
		},
	},
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {technique=true},
	define_as = "BORFAST_CAGE",
	unique = true,
	name = "Borfast's Cage",
	unided_name = _t"a suit of pitted and pocked plate-mail",
	desc = _t[[Inch-thick stralite plates lock together with voratun joints. The whole suit looks impenetrable, but has clearly been subjected to terrible treatment - great dents and misshaping warps, and caustic fissures bored across the surface.
Though clearly a powerful piece, it must once have been much greater.]],
	color = colors.WHITE, image = "object/artifact/armor_plate_borfasts_cage.png",
	moddable_tile = "special/armor_plate_borfasts_cage",
	level_range = {20, 28},
	rarity = 200,
	require = { stat = { str=35 }, },
	cost = 500,
	material_level = 3,
	wielder = {
		combat_def = 10,
		combat_armor = 20,
		fatigue = 24,

		inc_stats = { [Stats.STAT_CON] = 5, },
		resists = {
			[DamageType.ACID] = - 15,
			[DamageType.PHYSICAL] = 15,
		},

		max_life = 50,
		life_regen = 2,

		knockback_immune = 0.3,

		combat_physresist = 15,
		combat_crit_reduction = 20,
	},
}

newEntity{ base = "BASE_LEATHER_CAP", -- No armor training requirement
	power_source = {psionic=true},
	define_as = "ALETTA_DIADEM",
	name = "Aletta's Diadem", unique=true, unided_name=_t"jeweled diadem", image = "object/artifact/diadem_alettas_diadem.png",
	moddable_tile = "special/diadem_alettas_diadem",
	desc = _t[[A filigree of silver set with many small jewels, this diadem seems radiant - ethereal almost. But its touch seems to freeze your skin and brings wild thoughts to your mind. You want to drop it, throw it away, and yet you cannot resist thinking of what powers it might bring you.
Is this temptation a weak will on your part, or some domination from the artifact itself...?]],
	require = { stat = { wil=24 }, },
	level_range = {20, 28},
	rarity = 200,
	cost = 1000,
	material_level = 3,
	metallic = true,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 4, },
		combat_mindpower = 12,
		combat_mindcrit = 5,
		on_melee_hit={ [DamageType.MIND] = 12, },
		inc_damage={ [DamageType.MIND] = 10, },
	},
	max_power = 10, power_regen = 1,
	use_talent = { id = Talents.T_PSYCHIC_LOBOTOMY, level=3, power = 8 },
}

newEntity{ base = "BASE_SLING",
	power_source = {nature=true},
	define_as = "HARESKIN_SLING",
	name = "Hare-Skin Sling", unique=true, unided_name = _t"hare-skin sling", image = "object/artifact/sling_hareskin_sling.png",
	moddable_tile = "special/%s_hareskin_sling",
	desc = _t[[This well-tended sling is made from the leather and sinews of a large hare. It feels smooth to the touch, yet very durable. Some say that the skin of a hare brings luck and fortune.
Hard to tell if that really helped its former owner, but it's clear that the skin is at least also strong and reliable.]],
	level_range = {20, 28},
	rarity = 200,
	require = { stat = { dex=35 }, },
	cost = 50,
	material_level = 3,
	use_no_energy = true,
	combat = {
		range = 10,
	},
	wielder = {
		movement_speed = 0.2,
		inc_stats = { [Stats.STAT_LCK] = 10, },
		combat_physcrit = 5,
		combat_def = 10,
		talents_types_mastery = { ["cunning/survival"] = 0.2, },
	},
	max_power = 8, power_regen = 1,
	use_talent = { id = Talents.T_INERTIAL_SHOT, level=3, power = 8 },
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {nature=true},
	define_as = "LUCKY_FOOT",
	unique = true,
	name = "Prox's Lucky Halfling Foot", color = colors.WHITE,
	unided_name = _t"a mummified halfling foot", image = "object/artifact/proxs_lucky_halfling_foot.png",
	desc = _t[[A large hairy foot, very recognizably a halfling's, is strung on a piece of thick twine. In its decomposed state it's hard to tell how long ago it parted with its owner, but from what look like teeth marks around the ankle you get the impression that it wasn't given willingly.
It has been kept somewhat intact with layers of salt and clay, but in spite of this it's clear that nature is beginning to take its toll on the dead flesh. Some say the foot of a halfling brings luck to its bearer - right now the only thing you can be sure of is that it stinks.]],
	level_range = {5, 12},
	rarity = 200,
	cost = 10,
	material_level = 1,
	metallic = false,
	sentient = true,
	cooldown=0,
	special_desc = function(self)
		local ready = self:min_power_to_trigger() - self.power
		return ("Detects traps.\nRemoves (25%% chance) up to three stuns, pins, or dazes each turn%s"):tformat((ready > 0) and (" (cooling down: %d turns)"):tformat(ready) or "")
	end,
	max_power = 10, power_regen = 1,
	min_power_to_trigger = function(self) return self.max_power * (self.worn_by and (100 - (self.worn_by:attr("use_object_cooldown_reduce") or 0))/100 or 1) end, -- special handling of the Charm Mastery attribute
	wielder = {
		inc_stats = { [Stats.STAT_LCK] = 5, },
		combat_def = 5,
		disarm_bonus = 5,
	},
	use_force_worn = true,
	use_power = { name = _t"", power = 10, hidden = true, use = function(self, who) return end, no_npc_use = true},
	act = function(self)
		self:useEnergy()
		if self.worn_by then
			local actor = self.worn_by
			local grids = core.fov.circle_grids(actor.x, actor.y, 1, true)
			local Map = require "engine.Map"
			local is_trap = false

			for x, yy in pairs(grids) do for y, _ in pairs(yy) do
				local trap = game.level.map(x, y, Map.TRAP)
				if trap and not (trap:knownBy(self) or trap:knownBy(actor)) then
					is_trap = true
					-- Set the artifact as knowing the trap, not the wearer
					trap:setKnown(self, true)
				end
			end end
			-- only one twitch per action
			if is_trap then
				game.logSeen(actor, "#CRIMSON#%s twitches, alerting %s that a hidden trap is nearby.", self:getName(), actor:getName():capitalize())
				if actor == game.player then
					game.player:runStop()
				end
			end
		end
		--Escape stuns/dazes/pins
		self:regenPower()

		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if not rng.percent(25) or self.power < self:min_power_to_trigger() then return end
		local who = self.worn_by
		local target = self.worn_by
			local effs = {}
			local known = false
			local num = 0

			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e and (e.subtype.pin or e.subtype.stun) then
					effs[#effs+1] = {"effect", eff_id}
					num = 1
				end
			end
			if num == 1 then
				game.logSeen(who, "%s shrugs off some effects!", who:getName():capitalize())
				self.power = 0
			end
			for i = 1, 3 do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					target:removeEffect(eff[2])
					known = true
				end
			end
	end,
	on_wear = function(self, who)
		self.worn_by = who
		if who.descriptor and who.descriptor.race == "Halfling" then
			local Stats = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_LCK] = -10}) -- Overcomes the +5 Bonus and adds a -5 penalty
			self:specialWearAdd({"wielder","combat_physresist"}, -10)
			self:specialWearAdd({"wielder","combat_mentalresist"}, -10)
			self:specialWearAdd({"wielder","combat_spellresist"}, -10)
			game.logPlayer(who, "#LIGHT_RED#You feel uneasy carrying %s.", self:getName())
		end
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
}

newEntity{ base = "BASE_MINDSTAR", define_as = "PSIONIC_FURY",
	power_source = {psionic=true},
	unique = true,
	name = "Psionic Fury",
	unided_name = _t"vibrating mindstar",
	level_range = {24, 32},
	color=colors.AQUAMARINE, image = "object/artifact/psionic_fury.png",
	rarity = 250,
	desc = _t[[This mindstar constantly shakes and vibrates, as if a powerful force is desperately trying to escape.]],
	cost = 85,
	require = { stat = { wil=24 }, },
	material_level = 3,
	combat = {
		dam = 12,
		apr = 25,
		physcrit = 5,
		dammod = {wil=0.5, cun=0.3},
		damtype = DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 10,
		combat_mindcrit = 8,
		inc_damage={
			[DamageType.MIND] 		= 15,
			[DamageType.PHYSICAL]	= 5,
		},
		resists={
			[DamageType.MIND] 		= 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 3, [Stats.STAT_CUN] = 3, },
	},
	max_power = 40, power_regen = 1,
	use_power = {
		name = function(self, who) return ("release a wave of psionic power, dealing %0.2f mind damage (based on Willpower) to all within radius %d"):
		tformat(who:damDesc(engine.DamageType.MIND, self.use_power.damage(self, who)), self.use_power.radius) end,
		power = 40,
		radius = 5,
		range = 0,
		target = function(self, who) return {type="ball", range=self.use_power.range, radius=self.use_power.radius, selffire=false} end,
		tactical = {ATTACKAREA = {MIND = 2}},
		damage = function(self, who) return 50 + who:getWil()*1.8 end,
		use = function(self, who)
			local radius = self.use_power.radius
			local dam = self.use_power.damage(self, who)
			local blast = self.use_power.target(self, who)
			game.logSeen(who, "%s's %s sends out a blast of psionic energy!", who:getName():capitalize(), self:getName({no_add_name = true, do_color = true}))
			who:project(blast, who.x, who.y, engine.DamageType.MIND, dam)
			game.level.map:particleEmitter(who.x, who.y, blast.radius, "force_blast", {radius=blast.radius})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GAUNTLETS", define_as = "STORM_BRINGER_GAUNTLETS",
	power_source = {arcane=true},
	unique = true,
	name = "Storm Bringer's Gauntlets", color = colors.LIGHT_STEEL_BLUE, image = "object/artifact/storm_bringers_gauntlets.png",
	unided_name = _t"fine-mesh gauntlets",
	desc = _t[[This pair of fine mesh voratun gauntlets is covered with glyphs of power that spark with azure energy.  The metal is supple and light so as not to interfere with spell-casting.  When and where these gauntlets were forged is a mystery, but odds are the crafter knew a thing or two about magic.]],
	level_range = {25, 35},
	rarity = 250,
	cost = 1000,
	material_level = 3,
	require = nil,
	wielder = {
		inc_stats = { [Stats.STAT_MAG] = 6, },
		combat_spellpower = 12,
		resists = { [DamageType.LIGHTNING] = 15, },
		inc_damage = { [DamageType.LIGHTNING] = 15 },
		combat_spellcrit = 5,
		combat_critical_power = 20,
		combat_armor = 5,
		combat = {
			dam = 22,
			apr = 10,
			physcrit = 4,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={ [DamageType.LIGHTNING] = 20, },
			talent_on_hit = { [Talents.T_CHAIN_LIGHTNING] = {level=2, chance=20}, [Talents.T_NOVA] = {level=1, chance=15} },
			damrange = 0.3,
		},
	},
	talents_add_levels_filters = {
		{desc=_t"+1 to all lightning damage spells", filter=function(who, t, lvl)
			if t.is_spell and t.tactical and (
				table.has(t.tactical, "attack", "LIGHTNING") or
				table.has(t.tactical, "attackarea", "LIGHTNING")
			) then
				return lvl + 1
			end
		end},
	},
	talent_on_spell = {
		{chance=10, talent=Talents.T_LIGHTNING, level=1},
	},
}

newEntity{ base = "BASE_TRIDENT",
	power_source = {arcane=true},
	define_as = "TRIDENT_STREAM",
	unided_name = _t"ornate trident",
	name = "River's Fury", unique=true, image = "object/artifact/the_rivers_fury.png",
	moddable_tile = "special/%s_the_rivers_fury",
	moddable_tile_big = true,
	desc = _t[[This gorgeous and ornate trident was wielded by Lady Nashva, and when you hold it, you can faintly hear the roar of a rushing river.]],
	require = { stat = { str=12 }, },
	level_range = {1, 10},
	rarity = 230,
	cost = 300,
	material_level = 1,
	combat = {
		dam = 23,
		apr = 8,
		physcrit = 5,
		dammod = {str=1.2},
		damrange = 1.4,
		melee_project={
			[DamageType.COLD] = 15,
		},
	},
	wielder = {
		combat_atk = 10,
		combat_spellpower = 10,
		resists={[DamageType.COLD] = 10},
		inc_damage = { [DamageType.COLD] = 10 },
		movement_speed=0.1,
	},
	talent_on_spell = { {chance=20, talent="T_GLACIAL_VAPOUR", level=1} },
	max_power = 80, power_regen = 1,
	use_talent = { id = Talents.T_TIDAL_WAVE, level=1, power = 80 },
}

newEntity{ base = "BASE_KNIFE",
	power_source = {arcane=true},
	define_as = "UNERRING_SCALPEL",
	unique = true,
	name = "Unerring Scalpel", image = "object/artifact/unerring_scalpel.png",
	unided_name = _t"long sharp scalpel",
	moddable_tile = "special/%s_unerring_scalpel",
	moddable_tile_big = true,
	desc = _t[[This scalpel was used by the dread sorcerer Kor'Pul when he began learning the necromantic arts in the Age of Dusk.  Many were the bodies, living and dead, that became unwilling victims of his terrible experiments.]],
	level_range = {1, 12},
	rarity = 200,
	require = { stat = { cun=16 }, },
	cost = 80,
	material_level = 1,
	combat = {
		dam = 15,
		apr = 25,
		physcrit = 0,
		dammod = {dex=0.55, str=0.45},
		phasing = 50,
	},
	wielder = {
		combat_atk=20,
		blind_fight = 1,
	},
}

newEntity{ base = "BASE_GLOVES", define_as = "VARSHA_CLAW",
	power_source = {nature=true},
	unique = true,
	name = "Wyrmbreath", color = colors.RED, image = "object/artifact/wyrmbreath.png",
	unided_name = _t"clawed dragon-scale gloves",
	desc = _t[[These dragon scale gloves are tipped with the claws and teeth of a vicious Wyrm. The gloves are warm to the touch.]],
	level_range = {12, 22},
	rarity = 180,
	cost = 50,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 5, },
		resists = { [DamageType.FIRE]= 18, [DamageType.DARKNESS]= 10, [DamageType.NATURE]= 10,},
		inc_damage = { [DamageType.FIRE]= 10, },
		combat_armor = 4,
		combat = {
			dam = 17,
			apr = 7,
			physcrit = 1,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={[DamageType.FIRE] = 10},
			convert_damage = { [DamageType.FIRE] = 50,},
			talent_on_hit = { [Talents.T_BELLOWING_ROAR] = {level=3, chance=10}, [Talents.T_FIRE_BREATH] = {level=2, chance=10} },
		},
	},
	max_power = 24, power_regen = 1,
	use_talent = { id = Talents.T_FIRE_BREATH, level = 2, power = 24 },
}

newEntity{ base = "BASE_TOOL_MISC", define_as = "EYE_OF_THE_DREAMING_ONE",
	power_source = {psionic=true},
	unique=true, rarity=240,
	name = "Eye of the Dreaming One",
	unided_name = _t"translucent sphere",
	color = colors.YELLOW,
	level_range = {1, 10},
	image = "object/artifact/eye_of_the_dreaming_one_new.png",
	desc = _t[[This ethereal eye stares eternally, as if seeing things that do not truly exist.]],
	cost = 320,
	material_level = 1,
	wielder = {
		combat_mindpower=5,
		sleep=1,
		lucid_dreamer=1,
		combat_mentalresist = 10,
		inc_stats = {[Stats.STAT_WIL] = 5,},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_SLEEP, level = 3, power = 20 },
}
