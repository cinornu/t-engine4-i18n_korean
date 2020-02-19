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

module(..., package.seeall, class.make)


-------------------------------------------------------------
-- Resources
-------------------------------------------------------------
TOOLTIP_GOLD = _t[[#GOLD#Gold#LAST#
Money!
With gold you can buy items in the various stores in town.
You can gain money by looting it from your foes, by selling items and by doing some quests.
]]

TOOLTIP_LIVES = _t[[#GOLD#Lives#LAST#
How many lives you have and how many you lost.
Your total number of lives depends on the permadeath setting you choose.
You may find other ways to save yourself but they are not considered extra lives.
]]

TOOLTIP_BLOOD_LIFE = _t[[#GOLD#Blood of Life#LAST#
The Blood of Life courses through your veins.
This can save you from death and restore you to full health (once) if you would otherwise die.
]]

TOOLTIP_LIFE = _t[[#GOLD#Life#LAST#
This is your life force, which is reduced each time you take damage.
Normally, you will die if this drops below zero, though some effects will allow you survive with negative life.
Death is usually permanent so beware!
It is increased by Constitution.
]]

TOOLTIP_DAMAGE_SHIELD = _t[[#GOLD#Damage shields#LAST#
Various talents, items and powers can grant you a temporary damage shield.
Each works in a distinct manner, but will usually intercept a certain amount of damage that would otherwise hit you before crumbling.
]]

TOOLTIP_UNNATURAL_BODY = _t[[#GOLD#Unnatrual Body Regeneration#LAST#
Your Unnatural Body talent allows you to feed off the life of your fallen foes.
Each time you kill a creature your maximum regeneration pool increases and each turn some of it transfers into your own life.
]]

TOOLTIP_LIFE_REGEN = _t[[#GOLD#Life Regeneration#LAST#
How much life you regenerate per turn.
This value can be improved with spells, talents, infusions, equipment.
]]

TOOLTIP_HEALING_MOD = _t[[#GOLD#Healing mod#LAST#
This represents how effective healing is for you.
All healing values are multiplied by this value (including life regeneration).
It is increased by Constitution.
]]

TOOLTIP_AIR = _t[[#GOLD#Air#LAST#
The breath counter only appears when you are suffocating.
If it reaches zero you will die. Being stuck in a wall, being in deep water, ... all those kinds of situations will decrease your air.
When you come back into a breathable atmosphere you will slowly regain your air level.
]]

TOOLTIP_STAMINA = _t[[#GOLD#Stamina#LAST#
Stamina represents your physical fatigue. Each physical ability used reduces it.
It regenerates slowly over time or when resting.
It is increased by Willpower.
]]

TOOLTIP_MANA = _t[[#GOLD#Mana#LAST#
Mana represents your reserve of magical energies. Each spell cast consumes mana and each sustained spell reduces your maximum mana.
It is increased by Willpower.
]]

TOOLTIP_POSITIVE = _t[[#GOLD#Positive Energy#LAST#
Positive energy represents your reserve of positive "celestial" power, most closely associated with the Sun.
]]

TOOLTIP_NEGATIVE = _t[[#GOLD#Negative Energy#LAST#
Negative energy represents your reserve of negative "celestial" power, most closely associated with the Moon.
]]

TOOLTIP_VIM = _t[[#GOLD#Vim#LAST#
Vim represents the amount of life energy you control. Each corruption talent requires some.
It does not regenerate naturally; you need to drain it from yourself or your victims.
Each time you kill a creature you gain 30% of your Willpower + 1 as Vim.  This value is multiplied by half the rank of the creature.
If you can't pay for the Vim cost of a talent you may instead pay with life at a rate of 200% of the Vim cost.
]]

TOOLTIP_EQUILIBRIUM = _t[[#GOLD#Equilibrium#LAST#
Equilibrium reflects your standing in the grand balance of nature and how easily you can access Wild Gifts.
The closer it is to 0 the more in-balance you are.
Being too far out of balance may cause your Wild Gifts to fail when called upon.
]]

TOOLTIP_HATE = _t[[#GOLD#Hate#LAST#
Hate represents your inner rage against all that lives and dares face you.
It is replenished by killing creatures and through the application of your talents.
All afflicted talents are based on Hate, and many are more effective at higher levels of hate.
]]

TOOLTIP_PARADOX = _t[[#GOLD#Paradox#LAST#
Paradox represents how stable the current timeline is. 
As your Paradox grows so does your Spellpower, but you may be shifted to a more stable timeline when you attempt to use your magic.
When your modified Paradox is above 600 the shifts will become more violent.
Your control over chronomancy spells increases with your Willpower.
]]

TOOLTIP_PSI = _t[[#GOLD#Psi#LAST#
Psi represents how much energy your mind can harness. Like matter, it can be neither created nor destroyed.
It regenerates naturally, though slowly, as you pull minute amounts of heat and kinetic energy from your surroundings.
To get meaningful amounts back in combat, you must absorb it through shields or various other talents.
Your capacity for storing energy is determined by your Willpower.
]]

TOOLTIP_FEEDBACK = _t[[#GOLD#Feedback#LAST#
Feedback represents using pain as a means of psionic grounding and it can be used to power feedback abilities.
Feedback decays at the rate of 10% or 1 per turn (which ever is greater) depending on talents.
All damage you take from an outside source will increase your Feedback based on to how much of your health is lost and your level.  First level characters gain 100 Feedback when losing 50% health, while 50th level characters gain the same amount when losing 20% health.
]]

TOOLTIP_NECROTIC_AURA = _t[[#GOLD#Necrotic Aura#LAST#
Represents the raw materials for creating undead minions.
It increases each time you or your minions kill something that is inside the aura radius.
]]

TOOLTIP_FORTRESS_ENERGY = _t[[#GOLD#Fortress Energy#LAST#
The energy of the Sher'Tul Fortress. It is replenished by transmogrifying items and used to power all the Fortress systems.
]]

TOOLTIP_LEVEL = _t[[#GOLD#Level and experience#LAST#
Each time you kill a creature that is over your own level - 5 you gain some experience.
When you reach enough experience you advance to the next level. There is a maximum of 50 levels you can gain.
Each time you level you gain stat and talent points to use to improve your character.
]]

TOOLTIP_ENCUMBERED = _t[[#GOLD#Encumbrance#LAST#
Each object you carry has an encumbrance value. Your maximum carrying capacity is determined by your strength.
You cannot move while encumbered; drop some items.
]]

-------------------------------------------------------------
-- Talents
-------------------------------------------------------------
TOOLTIP_INSCRIPTIONS = _t[[#GOLD#Inscriptions#LAST#
The people of Eyal have found a way to create herbal infusions and runes that can be inscribed on the skin of a creature.  More exotic types of inscriptions also exist.
Those inscriptions give the bearer always-accessible powers that can be used an unlimited number of times.
A simple regeneration infusion is the most common type of infusion, and the use of runes of various types is also common among arcane users.
]]

TOOLTIP_PRODIGIES = _t[[#GOLD#Prodigies#LAST#
Prodigies are special talents that only the most powerful of characters can acquire.
All of them require at least 50 in a core stat and many also have other, very specific and/or demanding requirements to learn.
Players can learn new prodigies at levels 30 and 42.]]

TOOLTIP_ITEM_TALENTS = _t[[#GOLD#Item Talents#LAST#
Some objects bestow additional talents on the wearer or holder.
These talents work like normal, learned talents, but are lost if the object granting them is taken off or dropped, even for a moment.]]

TOOLTIP_ACTIVATED = _t[[#GOLD#Activated Talents#LAST#
Most talents require activation (i.e. time) to use, and create a specific effect when called upon.
Specific information on each talent appears its tooltip.]]

TOOLTIP_INSTANT = _t[[#GOLD#Instant Talents#LAST#
Some activated talents take no time to use, being activated with but a thought.
Unlike most talents, instant talents are never put on cooldown from being stunned, and may be usable when most other talents are not.
Specific information on each talent appears its tooltip.]]

TOOLTIP_PASSIVE = _t[[#GOLD#Passive Talents#LAST#
When learned, passive talents permanently alter the user in some way.
The effects are always present and are usually not dispellable or removable, though other effects may counteract or negate them.
Specific information on each talent appears its tooltip.]]

TOOLTIP_SUSTAINED = _t[[#GOLD#Sustained Talents#LAST#
Sustained talents are turned on and left on.
While active, a sustained talent produces some effects on the user that stay in effect until the talent is deactivated. Activating most sustained talents require the user to put aside some resources, which become unavailable until the talent is turned off.
Deactivating a sustained talent causes it to go on cooldown.
Specific information on each talent appears its tooltip.]]

-------------------------------------------------------------
-- Speeds
-------------------------------------------------------------
TOOLTIP_SPEED_GLOBAL = _t[[#GOLD#Global Speed#LAST#
Global speed represents how fast you are and affects everything you do.
Higher is faster, so at 200% global speed you can performa twice as many actions as you would at 100% speed.
Note that the amount of time to performa various actions like moving, casting spells, and attacking is also affected by their respective speeds.
]]
TOOLTIP_SPEED_MOVEMENT = _t[[#GOLD#Movement Speed#LAST#
How quickly you move compared to normal.
Higher is faster, so 200% means that you move twice as fast as normal.
Minimum:  40%
]]
TOOLTIP_SPEED_SPELL = _t[[#GOLD#Spell Speed#LAST#
How quickly you cast spells.
Higher is faster, so 200% means that you can cast spells twice as fast as normal.
Minimum:  40%
]]
TOOLTIP_SPEED_ATTACK = _t[[#GOLD#Attack Speed#LAST#
How quickly you attack with weapons, either ranged or melee.
Higher is faster, so 200% means that you can attack twice as fast as normal.
The actual speed may also be affected by the weapon used.
Minimum:  40%
]]
TOOLTIP_SPEED_MENTAL = _t[[#GOLD#Mental Speed#LAST#
How quickly you perform mind powers.
Higher is faster, so 200% means that you can use mind powers twice as fast as normal.
Minimum:  40%
]]
-------------------------------------------------------------
-- Stats
-------------------------------------------------------------
TOOLTIP_STATS = _t[[#GOLD#Stats#LAST#
Your character's primary attributes.  Base: the value inherent to your character, which may be increased by applying stat points (limited by character level). Current: the base value plus any bonuses from equipment, effects, certain talents, etc. that is used to determine the overall effectiveness of the stat.
]]
TOOLTIP_STR = _t[[#GOLD#Strength#LAST#
Strength defines your character's ability to apply physical force. It increases Physical Power, damage done with heavy weapons, Physical Save, and carrying capacity.
]]
TOOLTIP_DEX = _t[[#GOLD#Dexterity#LAST#
Dexterity defines your character's ability to be agile and alert. It increases Accuracy, Defense, chance to shrug off critical hits and your damage with light weapons.
]]
TOOLTIP_CON = _t[[#GOLD#Constitution#LAST#
Constitution defines your character's ability to withstand and resist damage. It increases your maximum life, Physical Save and Healing mod.
]]
TOOLTIP_MAG = _t[[#GOLD#Magic#LAST#
Magic defines your character's ability to manipulate the magical energy of the world. It increases your Spellpower, Spell Save, and the effect of spells and other magic items.
]]
TOOLTIP_WIL = _t[[#GOLD#Willpower#LAST#
Willpower defines your character's ability to concentrate. It increases your mana, stamina, psi capacity, Mindpower, Spell Save, and Mental Save.
]]
TOOLTIP_CUN = _t[[#GOLD#Cunning#LAST#
Cunning defines your character's ability to learn, think, and react. It allows you to learn many worldly abilities, and increases your Mindpower, Mental Save, and critical chance.
]]
TOOLTIP_STRDEXCON = _t"#AQUAMARINE#Physical stats#LAST#\n---\n"..TOOLTIP_STR.."\n---\n"..TOOLTIP_DEX.."\n---\n"..TOOLTIP_CON
TOOLTIP_MAGWILCUN = _t"#AQUAMARINE#Mental stats#LAST#\n---\n"..TOOLTIP_MAG.."\n---\n"..TOOLTIP_WIL.."\n---\n"..TOOLTIP_CUN

-------------------------------------------------------------
-- Melee
-------------------------------------------------------------
TOOLTIP_COMBAT_ATTACK = _t[[#GOLD#Accuracy#LAST#
Determines your chance to hit your target as well as knock your target off-balance when measured against the target's Defense.
When you use Accuracy to inflict temporary physical effects on an enemy, every point your opponent's relevant saving throw exceeds your accuracy will reduce the duration of the effect by 5%.
Many weapon types will have an additional "accuracy bonus" scaling per point of Accuracy greater than the targets Defense.
]]
TOOLTIP_COMBAT_PHYSICAL_POWER = _t[[#GOLD#Physical Power#LAST#
Measures your ability to deal physical damage in combat.
When you use Physical Power to inflict temporary physical effects on an enemy, every point your opponent's relevant saving throw exceeds your physical power will reduce the duration of the effect by 5%.
]]
TOOLTIP_COMBAT_DAMAGE = _t[[#GOLD#Damage#LAST#
This is the damage you inflict on your foes when you hit them.
This damage can be reduced by the target's armour or by percentile damage resistances.
It is improved by Strength or Dexterity, depending on your weapon. Some talents can change the stats that affect it.
]]
TOOLTIP_COMBAT_BLOCK = _t[[#GOLD#Shield Block Value#LAST#
The amount of damage a shield will block when actively used in defense.
Usually this is only effective against Physical damage, but some special shields (and talents) allow the wearer to block other types.
]]
TOOLTIP_COMBAT_APR = _t[[#GOLD#Armour Penetration#LAST#
Armour penetration allows you to ignore a part of the target's armour (this only works for armour, not damage resistance).
This can never increase the damage you do beyond reducing armour, so it is only useful against armoured foes.
]]
TOOLTIP_COMBAT_CRIT = _t[[#GOLD#Critical chance#LAST#
Each time you deal damage you have a chance to make a critical hit that deals extra damage.
Some talents allow you to increase this percentage.
It is improved by Cunning.
]]
TOOLTIP_COMBAT_SPEED = _t[[#GOLD#Attack speed#LAST#
Attack speed represents how fast your attacks are compared to normal.
Higher is faster, representing more attacks performed in the same amount of time.
]]
TOOLTIP_COMBAT_RANGE = _t[[#GOLD#Firing range#LAST#
The maximum distance your weapon can reach.
]]
TOOLTIP_ARCHERY_RANGE_SPEED = _t[[#GOLD#Archery range and speed#LAST#
Archery attacks create projectiles with a maximum range, beyond which they will terminate.
The projectiles travel at their own speed, measured as a percentage (higher, usually) of normal movement speed.
]]
TOOLTIP_COMBAT_AMMO = _t[[#GOLD#Ammo remaining#LAST#
This is the amount of ammunition you have left.
Bows and slings must be reloaded when this reaches 0, which you will do automatically each turn you rest or don't perform a non-movement action.
Alchemists use specially prepared gems as ammunition to throw bombs, which must be reloaded manually.
]]

-------------------------------------------------------------
-- Defense
-------------------------------------------------------------
TOOLTIP_FATIGUE = _t[[#GOLD#Fatigue#LAST#
Fatigue is a percentile value that increases the cost of your talents and spells.
It represents the fatigue created by wearing heavy equipment.
Not all talents are affected; notably, Wild Gifts are not.
]]
TOOLTIP_ARMOR = _t[[#GOLD#Armour#LAST#
Armour value is a damage reduction from all incoming melee and ranged weapon attacks.
Absorbs (hardiness)% of incoming weapon damage, up to a maximum of (armour) damage absorbed.
This is countered by armour penetration and is applied before all kinds of critical damage increase, talent multipliers and damage multiplier, thus making even small amounts have greater effects.
]]
TOOLTIP_ARMOR_HARDINESS = _t[[#GOLD#Armour Hardiness#LAST#
Armour hardiness represents how much of each incoming blows the armour will affect.
Absorbs (hardiness)% of incoming weapon damage, up to a maximum of (armour) damage absorbed.
]]
TOOLTIP_CRIT_REDUCTION = _t[[#GOLD#Crit Reduction#LAST#
Crit reduction reduces the chance an opponent has of landing a critical strike with a melee or ranged attack.
]]
TOOLTIP_CRIT_SHRUG = _t[[#GOLD#Crits Shrug Off#LAST#
Gives a chance to ignore the bonus critical damage from any direct damage attacks (melee, spells, ranged, mind powers, ...).
]]
TOOLTIP_DEFENSE = _t[[#GOLD#Defense#LAST#
Defense represents your chance to avoid melee weapon attacks and reduces the chance you'll be knocked off-balance by an enemy's attack. It is measured against the attacker's Accuracy.
]]
TOOLTIP_RDEFENSE = _t[[#GOLD#Ranged Defense#LAST#
Defense represents your chance to avoid ranged weapon attacks and reduces the chance you'll be knocked off-balance by an enemy's attack. It is measured against the attacker's Accuracy.
]]
TOOLTIP_SAVES = _t[[#GOLD#Saves#LAST#
Saving throws represent your ability to shrug off, partially or fully, detrimental effects applied to you.  Most detrimental effects will check their power (physical, spell, mental) vs your corresponding save type to determine if they take effect or not.  The chance is usually ~50% when power and save are equal.
]]
TOOLTIP_PHYS_SAVE = _t[[#GOLD#Physical saving throw#LAST#
Increases chance to shrug off physically-induced effects.  Also reduces duration of detrimental physical effects by up to 5% per point, depending on the power of the opponent's effect.
]]
TOOLTIP_SPELL_SAVE = _t[[#GOLD#Spell saving throw#LAST#
Increases chance to shrug off magically-induced effects.  Also reduces duration of detrimental magical effects by up to 5% per point, depending on the power of the opponent's effect.
]]
TOOLTIP_MENTAL_SAVE = _t[[#GOLD#Mental saving throw#LAST#
Increases chance to shrug off mentally-induced effects.  Also reduces duration of detrimental mental effects by up to 5% per point, depending on the power of the opponent's effect.
]]
-------------------------------------------------------------
-- Physical
-------------------------------------------------------------
TOOLTIP_PHYSICAL_POWER = _t[[#GOLD#Physical Power#LAST#
Your physical power represents how overwhelming your physcial abilities are. It is usually improved by Strength, but may be modified by your weapon.  It is opposed by your opponent's physical save.
In addition, when your physical attacks inflict temporary detrimental effects, every point your opponent's save exceeds your physical power will reduce the duration of the effect by 5%.
]]
TOOLTIP_PHYSICAL_CRIT = _t[[#GOLD#Physical critical chance#LAST#
Each time you deal damage with a physical ability you may have a chance to perform a critical hit that deals extra damage.
Some talents allow you to increase this percentage, and it may be modified by your weapon.
It is improved by Cunning.
]]
-------------------------------------------------------------
-- Spells
-------------------------------------------------------------
TOOLTIP_SPELL_POWER = _t[[#GOLD#Spellpower#LAST#
Your spellpower represents how powerful your magical spells are.  It is opposed by your opponent's spell save.
In addition, when your spells inflict temporary detrimental effects, every point your opponent's save exceeds your spellpower will reduce the duration of the effect by 5%.
]]
TOOLTIP_SPELL_CRIT = _t[[#GOLD#Spell critical chance#LAST#
Each time you deal damage with a spell you may have a chance to perform a critical hit that deals extra damage.
Some talents allow you to increase this percentage.
It is improved by Cunning.
]]
TOOLTIP_SPELL_SPEED = _t[[#GOLD#Spellcasting speed#LAST#
Spellcasting speed represents how fast your spellcasting is compared to normal.
Higher is faster - 200% means that you cast spells twice as fast as someone at 100%.
]]
TOOLTIP_SPELL_COOLDOWN = _t[[#GOLD#Spellcooldown#LAST#
Spell cooldown represents how fast your spells will come off of cooldown.
The lower it is, the more often you'll be able to use your spell talents and runes.
]]
-------------------------------------------------------------
-- Mental
-------------------------------------------------------------
TOOLTIP_MINDPOWER = _t[[#GOLD#Mindpower#LAST#
Your mindpower represents how powerful your mental abilities are.  It is opposed by your opponent's mental save.
In addition, when your mental abilities inflict temporary detrimental effects, every point your opponent's save exceeds your mindpower will reduce the duration of the effect by 5%.
]]
TOOLTIP_MIND_CRIT = _t[[#GOLD#Mental critical chance#LAST#
Each time you deal damage with a mental attack you may have a chance to perform a critical hit that deals extra damage.
Some talents allow you to increase this percentage.
It is improved by Cunning.
]]
TOOLTIP_MIND_SPEED = _t[[#GOLD#Mental speed#LAST#
Mental speed represents how fast you use psionic abilities compared to normal.
Higher is faster.
]]
-------------------------------------------------------------
-- Damage and resists
-------------------------------------------------------------
TOOLTIP_INC_DAMAGE_ALL = _t[[#GOLD#Damage increase: all#LAST#
All damage you deal, through any means, is increased by this percentage.
This stacks with individual damage type increases.
]]
TOOLTIP_INC_DAMAGE = _t[[#GOLD#Damage increase: specific#LAST#
All damage of this type that you deal, through any means, is increased by this percentage.
]]
TOOLTIP_INC_DAMAGE_ACTOR = _t[[#GOLD#Damage increase: creature type#LAST#
All damage you deal to creatures of this type, through any means, is increased by this percentage.  This is applied in addition to (stacks with) other damage modifiers.
]]
TOOLTIP_INC_CRIT_POWER = _t[[#GOLD#Critical multiplier#LAST#
All critical hits (melee, spells, ...) do this much damage compared to normal.
]]
TOOLTIP_RESIST_DAMAGE = _t[[#GOLD#Damage resistance#LAST#
Whenever you take damage, the percent resistance you have to its type, if any, is checked.  The damage is reduced by this percentage (which may be partially negated by the attacker's Damage Penetration) before being applied.
Your effective resistance can never be higher than your resistance cap and negative resistances increase the damage you recieve (up to +100%).
]]
TOOLTIP_RESIST_ALL = _t[[#GOLD#Damage resistance: all#LAST#
All damage you receive, through any means, is decreased by this percentage.
This stacks (multiplicatively) with individual damage type resistances up to their respective caps.
(So 20% resistance: All + 50% resistance: Fire = 60% total resistance to Fire.)
]]
TOOLTIP_RESIST_ABSOLUTE = _t[[#GOLD#Damage resistance: absolute#LAST#
All damage you receive, through any means, is decreased by this percentage.
This is applied after normal damage resistance and is not affected by resistance penetration.
]]
TOOLTIP_RESIST = _t[[#GOLD#Damage resistance: specific#LAST#
All damage of this type that you receive, through any means, is reduced by this percentage.
]]
TOOLTIP_RESIST_SPEED = _t[[#GOLD#Damage resistance: by speed#LAST#
All damage you receive, through any means, is decreased by this percentage, which increases as your total movement speed (global times movement) decreases.
This is applied after normal damage type resistances.
]]
TOOLTIP_RESIST_DAMAGE_ACTOR = _t[[#GOLD#Damage resistance: creature type#LAST#
All damage you receive from creatures of this type, through any means, is decreased by this percentage.  This is applied separately to (stacks with) normal resistances.
]]
TOOLTIP_AFFINITY_ALL = _t[[#GOLD#Damage affinity: all#LAST#
All damage you receive, through any means, also heals you for this percentage of the damage.
This stacks with individual damage type affinities.
Important: Affinity healing happens after damage has been taken, it can not prevent death.
]]
TOOLTIP_AFFINITY = _t[[#GOLD#Damage affinity: specific#LAST#
All damage of this type that you receive, through any means, also heals you for this percentage of the damage.
Important: Affinity healing happens after damage has been taken, it can not prevent death.
]]
TOOLTIP_STATUS_IMMUNE = _t[[#GOLD#Status resistance#LAST#
Most bad status effects can be avoided by having an appropriate immunity, represented by a percent chance to completely avoid the effect in question.  This chance is applied in addition to any saving throws or other checks that may apply.
]]
TOOLTIP_SPECIFIC_IMMUNE = _t[[#GOLD#Effect resistance chance#LAST#
This represents your chance to completely resist this specific effect.
]]
TOOLTIP_STUN_IMMUNE = _t[[#GOLD#Stun immunity chance#LAST#
This represents your chance to completely avoid being stunned, dazed, or frozen.
]]
TOOLTIP_ANOMALY_IMMUNE = _t[[#GOLD#Anomaly immunity chance#LAST#
This represents your chance to avoid most chronomatic anomaly effects.
]]
TOOLTIP_INSTAKILL_IMMUNE = _t[[#GOLD#Instant death resistance#LAST#
This represents your chance to avoid being instantly killed, severely incapacitated, or controlled by certain abilities.
]]
TOOLTIP_NEGATIVE_STATUS_IMMUNE = _t[[#GOLD#Negative status effect immunity chance#LAST#
This represents your chance to completely avoid ANY persistent bad effects applied to you from others.
]]
TOOLTIP_NEGATIVE_MENTAL_STATUS_IMMUNE = _t[[#GOLD#Negative mental effect immunity chance#LAST#
This represents your chance to completely avoid ANY persistent bad mental effects applied to you from others.
]]
TOOLTIP_NEGATIVE_PHYSICAL_STATUS_IMMUNE = _t[[#GOLD#Negative physical effect immunity chance#LAST#
This represents your chance to completely avoid ANY persistent bad physical effects applied to you from others.
]]
TOOLTIP_NEGATIVE_SPELL_STATUS_IMMUNE = _t[[#GOLD#Negative magical effect immunity chance#LAST#
This represents your chance to completely avoid ANY persistent bad magical effects applied to you from others.
]]
TOOLTIP_ON_HIT_DAMAGE = _t[[#GOLD#Damage when hit#LAST#
Each time a creature hits you with a melee attack, it will suffer damage or other effects.
]]
TOOLTIP_MELEE_PROJECT = _t[[#GOLD#Additional Melee Damage#LAST#
Each time you strike a creature with a melee attack, you will deal additional damage or other effects.
]]
TOOLTIP_MELEE_PROJECT_INNATE = TOOLTIP_MELEE_PROJECT.._t[[
This is separate from any special damage of your weapon.
]]
TOOLTIP_RANGED_PROJECT = _t[[#GOLD#Additional Ranged Damage#LAST#
Each time you strike a creature with a ranged attack, you will deal additional damage or other effects.
]]
TOOLTIP_RANGED_PROJECT_INNATE = TOOLTIP_RANGED_PROJECT.._t[[
This is separate from any special damage of your weapon or ammo.
]]
TOOLTIP_RESISTS_PEN_ALL = _t[[#GOLD#Damage penetration: all#LAST#
Reduces the amount of effective resistance of your foes to any damage you deal by this percent.
If you have 50% penetration against a creature with 50% resistance it will have an effective resistance of 25%.
This stacks with individual damage type penetrations.
You can never have more than 70% penetration.
]]
TOOLTIP_RESISTS_PEN = _t[[#GOLD#Damage penetration: specific#LAST#
Reduces the effective resistance of your foes to all damage of this type you deal by this percent.
If you have 50% penetration against a creature with 50% resistance it will have an effective resistance of 25%.
You can never have more than 70% penetration.
]]
TOOLTIP_FLAT_RESIST = _t[[#GOLD#Flat resistances#LAST#
Reduces each hit of a certain damage type (or all) by this amount.
]]

-------------------------------------------------------------
-- Misc
-------------------------------------------------------------
TOOLTIP_ESP = _t[[#GOLD#Telepathy#LAST#
Allows you to sense creatures of the given type(s) even if they are not currently in your line of sight.
]]
TOOLTIP_ESP_RANGE = _t[[#GOLD#Telepathy range#LAST#
Determines the distance up to which you can sense creatures with telepathy.
]]
TOOLTIP_ESP_ALL = _t[[#GOLD#Telepathy#LAST#
Allows you to sense any creatures even if they are not currently in your line of sight.
]]
TOOLTIP_VISION_LITE = _t[[#GOLD#Lite radius#LAST#
The maximum distance your lite can light up. Anything further cannot be seen by natural means, unless the place itself is lit.
]]
TOOLTIP_VISION_SIGHT = _t[[#GOLD#Sight range#LAST#
How far you can see. This only works within your lite radius, or in lit areas.
]]
TOOLTIP_VISION_INFRA = _t[[#GOLD#Heightened Senses#LAST#
Special vision (including infravision) that works even in the dark, but only creatures can be seen this way.  Only the best ability is used.
]]
TOOLTIP_VISION_STEALTH = _t[[#GOLD#Stealth#LAST#
To use stealth one must possess the 'Stealth' talent.
Stealth allows you to try to hide from any creatures that would otherwise see you.
Even if they have seen you they will have a harder time hitting you.
Any creature can try to see through your stealth.
]]
TOOLTIP_VISION_SEE_STEALTH = _t[[#GOLD#See stealth#LAST#
Your power to see stealthed creatures. The higher it is, the more likely you are to see them (based on their own stealth score).
]]
TOOLTIP_VISION_INVISIBLE = _t[[#GOLD#Invisibility#LAST#
Invisible creatures are magically removed from the sight of all others. They can only be see by creatures that can see invisible.
]]
TOOLTIP_VISION_SEE_INVISIBLE = _t[[#GOLD#See invisible#LAST#
Your power to see invisible creatures. The higher it is, the more likely you are to see them (based on their own invisibility score).
If you do not have any see invisible score you will never be able to see invisible creatures.
]]
TOOLTIP_SEE_TRAPS = _t[[#GOLD#Detect Traps#LAST#
Your power to find hidden traps. The higher it is, the more likely you are to notice a trap before setting it off  (based on its own detection score).
If you do not have any detect traps score, you can not detect traps without triggering them.
]]
TOOLTIP_ANTIMAGIC_USER = _t[[#GOLD#Antimagic User#LAST#
Dedicated to opposing and destroying magical and arcane influence in the world.
The use of spells or arcane-powered equipment is impossible.
]]
