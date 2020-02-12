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
startx = 12
starty = 10

setStatusAll{no_teleport=true}
rotates = {"default", "90", "180", "270", "flipx", "flipy"}

local Talents = require("engine.interface.ActorTalents")
--make other requirement equipment from Cursed Sentry
local make_req = function(el, o, subtype, slot)
    local o2 = nil
    if o.subtype == subtype then
        o2 = o:clone()
        o2.no_drop = true
    else
        local level = o.material_level or 1
        -- Code from cursed aura
        local egos = o.egos_number or (o.ego_list and #o.ego_list) or (o.egoed and 1) or 0
        local greater = o.greater_ego or 0
        local double_greater = (o.unique and egos == 0) or greater > 1  -- artifact or purple
        local greater_normal = (o.unique and egos > 2) or greater == 1 and egos > 1 -- randart or blue
        local greater = (o.unique and egos > 0) or greater == 1 and egos == 1  -- rare or blue
        local double_ego = not o.unique and greater == 0 and egos > 1
        local ego = not o.unique and greater == 0 and egos == 1
        local filter = {subtype=subtype, ignore_material_restriction=true, tome={double_greater=double_greater and 1, greater_normal=greater_normal and 1,
        greater = greater and 1, double_ego = double_ego and 1, ego = ego and 1}, special = function(e) return not e.unique and e.material_level == level end}
        o2 = game.zone:makeEntity(game.level, "object", filter, nil, true)
        o2.no_drop = true
        if slot == "QUIVER" then o2.infinite = true end
    end
    el[#el+1] = {o2, slot or "OFFHAND"}
end

local imbueEgo = function(gem, object)
   if not gem then return end
   if not object then return end
   local Entity = require("engine.Entity")
	local ego = Entity.new{
		name = "imbue "..gem.name,
		keywords = {[gem.name] = true},
		wielder = table.clone(gem.imbue_powers),
		talent_on_spell = gem.talent_on_spell,
		fake_ego = true, unvault_ego = true,
	}
   game.zone:applyEgo(object, ego, "object", true)
end
-- A lot of elseif
local make_poltergeist = function(type)
    local o = nil
    local filter = nil
    local x_level = nil
    if type == "greater" then
		filter = {no_tome_drops=true, unique=true, special=function(o) return (o.slot == "MAINHAND") end}
        x_level = math.max(15, resolvers.current_level + 10)
    elseif type == "normal" then
        filter = {id=true, type="weapon", add_levels=5, force_tome_drops=true, tome_drops="store", tome_mod="gvault", special=function(o) return true end}
        x_level = math.max(10, resolvers.current_level + 5)
    else
        filter = {id=true, type="weapon", add_levels=0, force_tome_drops=true, tome_drops="store", tome_mod="vault", special=function(o) return true end}
        x_level = math.max(5, resolvers.current_level)
    end
    o = game.zone:makeEntity(game.level, "object", filter, nil, true)
    o.no_drop = false
    local e = mod.class.NPC.new{
        type = "construct", subtype = "weapon",
        display = o.display, color=o.color, image = o.image, blood_color = colors.GREY,
        faction = "enemies",
        body = { INVEN = 10, MAINHAND=1, OFFHAND=1, QUIVER=1,PSIONIC_FOCUS=1},
        level_range = {x_level, nil},
        size_category = 1,
        ai = "tactical", ai_state = { talent_in=2, ai_move="move_astar", },
        ai_tactic = resolvers.tactic"melee",
        max_life = resolvers.rngavg(100,120),
        stats = {wil= 20, cun = 20, mag = 20, con = 20},
        resolvers.sustains_at_birth(),
        resolvers.talents{
            [Talents.T_WEAPON_COMBAT]={base=1, every=10, max=5},
        }
    }
    local class = nil
    local req = nil
    local el = {}
    if o.subtype == "staff" then
        class = "Archmage"
        e.autolevel = "caster"
		e.max_mana = e.max_mana + 250 -- protect staffs from being dumb and having 0 mana left over after sustains
        e.ai_tactic = resolvers.tactic"ranged"
        e[#e+1] = resolvers.talents{
            [Talents.T_MANATHRUST]={base=1, every=10, max=5},
            [Talents.T_FLAME]={base=1, every=10, max=5},
        }
    elseif o.subtype == "dagger" then
        class = "Rogue"
        e.autolevel = "rogue"
        e[#e+1] = resolvers.talents{
            [Talents.T_KNIFE_MASTERY]={base=1, every=10, max=5},
        }
        make_req(el, o, "dagger")
    elseif o.subtype == "longbow" then
        class = "Archer"
        e.autolevel = "warrior"
        e.ai_tactic = resolvers.tactic"ranged"
        e[#e+1] = resolvers.talents{
            [Talents.T_MASTER_MARKSMAN] = {base=1, every=10, max=5},
        }
        make_req(el, o, "arrow", "QUIVER")
    elseif o.subtype == "sling" then
        class = "Skirmisher"
        e.autolevel = "rogue"
        e.ai_tactic = resolvers.tactic"ranged"
        e[#e+1] = resolvers.talents{
            [Talents.T_SKIRMISHER_SLING_SUPREMACY] = {base=1, every=10, max=5},
            [Talents.T_SKIRMISHER_KNEECAPPER] = {base=1, every=10, max=5},
            [Talents.T_SHOOT] = 1
        }
        make_req(el, o, "shield")
        make_req(el, o, "shot", "QUIVER")
    elseif o.subtype == "mindstar" then
        class = "Mindslayer"
        e.autolevel = "wildcaster"
        e[#e+1] = resolvers.talents{
            [Talents.T_PSIBLADES] = {base=1, every=10, max=5},
            [Talents.T_TELEKINETIC_SMASH] = 1,
        }
        e[#e+1] = resolvers.equip{
            {type="weapon", subtype="greatsword", autoreq=true, force_inven = "PSIONIC_FOCUS", no_drops=true},
        }
        make_req(el, o, "mindstar")
    elseif o.subtype == "steamgun" then --For Orcs DLC!
        class = "Gunslinger"
        e.autolevel = "slinger"
        e.ai_tactic = resolvers.tactic"ranged"
        e[#e+1] = resolvers.talents{
            [Talents.T_STEAMGUN_MASTERY] = {base=1, every=10, max=5},
            [Talents.T_STRAFE] = {base=1, every=10, max=5},
            [Talents.T_SHOOT] = 1
        }
        e[#e+1] = resolvers.inscription("IMPLANT:_STEAM_GENERATOR", {cooldown=32, power=10}),
        make_req(el, o, "steamgun")
        make_req(el, o, "shot", "QUIVER")
    elseif o.subtype == "steamsaw" then
        class = "Sawbutcher"
        e.autolevel = "warrior"
        e[#e+1] = resolvers.talents{
            [Talents.T_STEAMSAW_MASTERY]={base=1, every=10, max=5},
            [Talents.T_TO_THE_ARMS] = {base=1, every=10, max=5},
        }
        e[#e+1] = resolvers.inscription("IMPLANT:_STEAM_GENERATOR", {cooldown=32, power=10}),
        make_req(el, o, "steamsaw")
	elseif o.subtype == "whip" then
		class = "Corruptor"
		e.autolevel = "caster"
        e.ai_tactic = resolvers.tactic"ranged"
		e[#e+1] = resolvers.talents{
			[Talents.T_CORRUPTED_NEGATION]={base=3, every=12, max=6},
			[Talents.T_DRAIN]={base=5, every=10, max=7},
			[Talents.T_BLOOD_GRASP]={base=4, every=5, max=7},
		}
    elseif o.type == "weapon" and o.slot_forbid == "OFFHAND" then
        class = "Berserker"
        e.autolevel = "warrior"
        e[#e+1] = resolvers.talents{
            [Talents.T_WEAPONS_MASTERY]={base=1, every=10, max=5},
        }
    elseif o.type == "weapon" and o.offslot == nil then
        class = "Bulwark"
        e.autolevel = "warrior"
        e[#e+1] = resolvers.talents{
            [Talents.T_WEAPONS_MASTERY]={base=1, every=10, max=5},
            [Talents.T_ARMOUR_TRAINING]=2
        }
        make_req(el, o, "shield")
	else -- failsafe for if no other category fits so we don't break generation
		class = "Doomed"
        e.autolevel = "wildcaster"
        e[#e+1] = resolvers.talents{
			[Talents.T_CALL_SHADOWS]={base=1, every=8, max=6},
			[Talents.T_SHADOW_WARRIORS]={base=1, every=8, max=6},
			[Talents.T_REPROACH]={base=5, every=10, max=5},
        }
    end
    e[#e+1] = resolvers.auto_equip_filters(class)

    if type == "greater" then
        e.name = ("Poltergeist %s"):tformat(_t(o.name))
        e.rank = 3.5
        e.max_life = resolvers.rngavg(100,120)
        e.life_rating = 20
        e.resist = {all=20}
        e.auto_classes={
            {class=class, start_level=10, level_rate=80},
            {class=(rng.percent(65) and "Cursed" or "Doomed"), start_level=20, level_rate=40}
        }
    elseif type == "normal" then
        e.name = ("Animated %s"):tformat(_t(o.name))
        e.rank = 3
        e.max_life = resolvers.rngavg(80,100)
        e.life_rating = 15
        e.auto_classes={
            {class=class, start_level=10, level_rate=50}
        }
    else
        e.name = ("Moving %s"):tformat(_t(o.name))
        e.rank = 2
        e.max_life = resolvers.rngavg(60,80)
        e.life_rating = 12
        e.auto_classes={
            {class=class, start_level=10, level_rate=30}
        }
    end

    if type == "greater" then
        local filter = {type="gem", ignore_material_restriction=true,special=function(ee) return ee.material_level == o.material_level end}
        gem = game.zone:makeEntity(game.level, "object", filter, nil, true)
        imbueEgo(gem, o)
        o.name = ("Poltergeist's %s"):tformat(_t(o.name))
    end
    local qo = nil
    --if class ==
    e:resolve()
    e:resolve(nil, true)
    e:wearObject(o, true, false, "MAINHAND")
    for _, v in ipairs(el) do
        e:wearObject(v[1], true, false, v[2])
    end
    return e
end
specialList("actor", {
    "/data/general/npcs/wight.lua",
    "/data/general/npcs/skeleton.lua",
    "/data/general/npcs/horror.lua",
})


local p_char = '0'
local used_char = {}
local function check_def(def)
    for x = 1, #(def[1]) do
        for y = 1, #def do
            used_char[used_char[y]:sub(x,x)] = true
        end
    end
end
local function get_next(p_char)
    while used_char[p_char] == true do
        p_char = string.char(string.byte(p_char) + 1)
    end
    used_char[p_char] = true
    return p_char
end
function make_poltergeist_room(def)
    for x = 1, #(def[1]) do
        for y = 1, #def do
			if def[y]:sub(x, x) == "P" then
                p_char = get_next(p_char)
                defineTile(p_char, "FLOOR", nil, make_poltergeist("greater"))
                def[y] = def[y]:sub(1, x-1)..p_char..def[y]:sub(x+1, #def[y])
			elseif def[y]:sub(x, x) == "p" then
                p_char = get_next(p_char)
                defineTile(p_char, "FLOOR", nil, make_poltergeist("normal"))
                def[y] = def[y]:sub(1, x-1)..p_char..def[y]:sub(x+1, #def[y])
			elseif def[y]:sub(x, x) == "a" then
                p_char = get_next(p_char)
                defineTile(p_char, "FLOOR", nil, make_poltergeist("smaller"))
                def[y] = def[y]:sub(1, x-1)..p_char..def[y]:sub(x+1, #def[y])
            end
        end
    end
    return def
end

-- It had been updated to detect unused characters on alphabet to be replaced with moving weapons.
-- Just use make_poltergeist_room(def)
defineTile('#', "WALL")
defineTile('+', "DOOR")
defineTile('.', "FLOOR")
defineTile('X', "HARDWALL")
defineTile('!', "DOOR_VAULT")
defineTile('A', "FLOOR", {random_filter={type="armor", add_levels=5, tome_mod="gvault"}}, nil)
defineTile('W', "FLOOR", {random_filter={type="weapon", add_levels=5, tome_mod="gvault"}}, {random_filter={subtype='wight', add_levels=5}})
defineTile('Z', "FLOOR", {random_filter={add_levels=10, tome_mod="gvault"}}, nil)
defineTile('b', "FLOOR", nil, {random_filter={name='blade horror', add_levels=10}})
defineTile('h', "FLOOR", {random_filter={add_levels=10, tome_mod="gvault"}}, {random_filter={subtype='eldritch', add_levels=10}})
defineTile('s', "FLOOR", nil, {random_filter={subtype='skeleton', add_levels=5}})

startx = 12
starty = 10
local def = {
    [[XXXXXXXXXXXXXXX]],
    [[XA#pA.a#...aZZX]],
    [[XP+....+....hpX]],
    [[XW#.W.a##.....X]],
    [[X##+######....X]],
    [[Xp..#..P.##a..X]],
    [[X..a#p...p##+#X]],
    [[XA..#.....#.a.X]],
    [[X...###+###s.sX]],
    [[XWpA+..b###...X]],
    [[XXXXXXXXXXXX!XX]],
}
	
return make_poltergeist_room(def)