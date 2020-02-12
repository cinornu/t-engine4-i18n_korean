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

--local DamageType = require "engine.DamageType"
--local Astar = require "engine.Astar"
--local ActorAI = require "engine.interface.ActorAI"
--local ActorAI = require "mod.class.interface.ActorAI"

--[[
IMPROVED TACTICAL AI:
This AI determines when (or if) to use various actions available to an NPC.  It evaluates each action (which can be either using a talent or invoking another AI) according to how well it addresses various needs, where the needs are classified into various predefined TACTICs (described below).  The AI assigns a TACTICAL SCORE (a number representing overall usefulness) to each possible action and then attempts to execute the most useful action based on this value.

In this description, terms in ALL CAPS refer to specific variables; e.g. "SELF" refers to the acting NPC invoking this AI.

For talents, the TACTICAL SCORE is primarily based on its TACTICAL TABLE such as:

		t.tactical = {attack = {LIGHTNING = 2}}

(This talent fulfils the "attack" TACTIC with average effectiveness, modified by the LIGHTNING DamageType.)

Another possible computation for the TACTICAL SCORE might be summarized as:

	TACTICs:			attack		closein		disable		interpretation
	TACTIC WEIGHTs:		1			2			3			the action attacks, disables, and closes with target
	WANTs:   			2			-2.5		1.5			SELF wants to attack and disable, but avoid closing in
	SELF.ai_tactic:		3			1			2			SELF (optionally) favors the attack and disable TACTICs
	---------------------------------------------------
	(Column) Product:	6		+	-5		+	9		==	10	RAW TACTICAL SCORE

The last value is modified to get the FINAL TACTICAL SCORE for comparison with other available actions.
	
METHOD:
Evaluating the TACTICAL SCORE for each talent (or other action) requires 3 steps, not necessarily performed in order:

	1.	Calculate the TACTIC WEIGHTs (a table for each talent/action) for each TACTIC the talent supports.
	This is a complex procedure, performed (for talents) by ActorAI:aiTalentTactics, that uses the tactical parameters for the talent (contained in t.tactical, usually a table).  It takes into account the actors that may be affected by the talent/action and various attributes, including resistances, immunities, other known talents, etc.  (The section "==== TALENT TACTICAL TABLES ==== (with examples)" in mod.class.interface.ActorAI.lua contains a detailed explanation of how to construct tactical tables and how they are interpreted for each talent.)
	
	2.	Calculate the WANT VALUEs (a table for SELF) for all TACTICs.
	This calculation is performed by this AI (see "--== SUPPORTED TACTICS ==--" below).  A WANT VALUE is number reflecting how desirable a TACTIC is to SELF, usually ranging from -10 to +10.  It increases as the TACTIC becomes more useful.  0 represents no tactical value, while +2 is typical for a TACTIC the AI considers useful, and +10 reflects an urgent need, giving a large priority boost to the action.  Negative values correspond to undesirable TACTICs that the AI considers harmful to SELF.

	3.	Calculate the FINAL TACTICAL SCORE (a number) for the talent/action.
	The RAW TACTICAL SCORE is computed as the sum of each TACTIC WEIGHT (for each supported TACTIC) times its corresponding WANT VALUE.  This is then adjusted for other factors, like effective talent level and action speed to get the FINAL TACTICAL SCORE.  Only actions for which this value is > 0.1 are considered worth performing.

The AI will attempt to perform the action with the highest (positive) FINAL TACTICAL SCORE.  SELF.ai_state.tactic is assigned the TACTIC label corresponding the highest TACTIC WEIGHT for the action before it is performed, and can be used as an additional input within talent and AI code where an NPC may need to make choices.

TALENT INPUTS:
In order to use talents, this AI uses certain talent fields, which must be defined appropriately within the root of the talent definition:

-	tactical: tactical parameters (table or function), for evaluation by the aiTalentTactics function, specifying which TACTICs the talent fulfils (Talents without this field will not be used by this AI.)
-	requires_target: must evaluate to true for talents that require a reachable target to use
-	range: <defaults to 1> used to determine if a targeted talent can reach the target and to build a target list
-	radius: <defaults to 0> used to determine if a targeted talent can reach the target and to build a target list
-	target: <optional, defaults to a "bolt" attack> a parameter table for targeted talents
		Used by engine.Target:getType to define how to target the talent (includes information on AOE dimensions, friendly fire parameters, etc.).  This is usually used directly by the talent's action function.
		If it is absent, the talent will automatically target SELF.
-	onAIGetTarget: <optional> a function(self, talent) returning x, y, target called to get the talent target
		(usually used to target something other than SELF's primary target).
-	ai_level: <optional, defaults to raw talent level> a number or function(self, talent)
		the talent level to use when calculating the FINAL TACTICAL SCORE

Targeted talents are those with a defined talent.target field or for which SELF:getTalentRequiresTarget(t) returns true.

ACTOR INPUTS:
NPC AI parameters from mod.class.interface.ActorAI and engine.interface.ActorAI:
SELF.AI_TACTICS holds benefit coefficients, indexed by TACTIC name, representing how beneficial each tactic is (to SELF) when applied to itself or allies, typically +1 (beneficial) or -1 (harmful).
SELF.AI_TACTICAL_TALENT_LEVEL_BONUS (default 0.2) = level adjustment for talents (as raw talent level)
SELF.AI_TACTICAL_AI_ACTION_BONUS (default 0.02) = level adjustment to AI (non-talent) actions when computing the FINAL TACTICAL SCORE
SELF.AI_RESOURCE_LEVEL_TRIGGER = minimum resource level (fraction of maximum) before the AI will consider replenishing a resource

SELF.ai_state parameters:
SELF.ai_state.tactical_random_range = random range applied to the RAW TACTICAL SCORE (default SELF.AI_TACTICAL_RANDOM_RANGE, 0.5) Increasing this makes talent choices more random.
SELF.ai_state.self_compassion = tactic value multiplier when affecting SELF (default 5, for harmful tactics)
SELF.ai_state.ally_compassion = tactic value multiplier when affecting an ally (default 1, for harmful tactics)

SELF.ai_tactic table:
This is a table of multipliers (see mod.resolvers.tactic) for each tactic:

	{TACTIC1 = multiplier1, TACTIC2 = multiplier2, ...} (each tactic is lower case)

The want values for each tactic are multiplied by these values (Undefined multipliers default to 1.) before the final RAW TACTICAL SCORE calculation.  This table may include the .safe_range field, specifying a minimum range that SELF will try to maintain to its target; want.escape (described below) will be increased if the range goes below this value.  (Note: if SELF has no talents that can reach the safe range, it will usually not fight effectively.)

For example:

	SELF.ai_tactic = {disable=2, escape=3, safe_range=4}
	
defines a tactical bias towards disabling the target (2x) and escape (3x, with a further increase if the target is closer than range 4).

ALGORITHM and IMPLEMENTATION:
The main (local) variables used by this AI are want, actions, and avail.  The want table (stored in SELF.ai_state._want) contains the WANT VALUEs for each TACTIC considered:

	want = {TACTIC1 = value1, TACTIC2 = value2, ...}
	
The actions table (stored in SELF.ai_state._actions) contains a list of all available actions (each either a talent or another AI) and the parameters to perform them:

	actions = {{action1 parameters, ...}, {action2 parameters, ...})
	
Each entry in the actions table is a sub-table containing the parameters needed to perform the action.  For talents, these are:

	tid:		talent id
	tacts:		resolved TACTIC WEIGHTs for the talent
	lvl:		raw talent level (or value returned from talent.ai_level, if defined)
	mode:		talent mode ("sustained" or "activated")
	is_active:	status table for active sustained talents
	speed:		relative energy cost to use the talent (SELF:getTalentSpeed(talent), minimum 0.1)
	force_target: <optional> specific target for the talent (for later implementation)
	
while for AI's they are:

	ai:			AI tag (e.g. "move_simple")
	tacts:		resolved TACTIC WEIGHTs for the action
	speed:		relative energy cost to perform the action (minimum 0.1)
	... :		indexed parameters to be passed to the action AI as SELF:runAI(action.ai, unpack(action))
	
The avail table (stored in SELF.ai_state._avail) contains data on each TACTIC supported by the available actions:

	avail = {TACTIC1 = {data1, ...}, TACTIC2 = {data2, ...}, ...}
	
where each datum is a table with the fields:

	num: number of available actions using TACTIC
	best: largest TACTIC WEIGHT for the available actions using TACTIC
	best_action: reference to the table of action parameters for the action with the largest TACTIC WEIGHT
	
Only actions with at least one positive TACTIC WEIGHT update the avail table.
	
PROCEDURE (see --=== EVALUATE TALENTS ===-- below):
For each possible action, a table of TACTIC WEIGHTs is created, representing how effectively it fulfils various TACTICs:

	tactical = {TACTIC WEIGHT1 = value1, TACTIC WEIGHT2 = value2, ...}
	
TACTIC WEIGHTs may be positive or negative, and are not typically bounded, but usually lie within the range [-5, +5].  For talents, they are generated from the talent.tactical field by the SELF:aiTalentTactics function.  The largest TACTIC WEIGHT for a useful action will typically be around +2 in most cases.  An active sustained talent that may be turned off has the sign of its tactic values reversed.

SELF:aiTalentTactics automatically generates a list of potentially affected targets (if required, calling self:aiTalentTargets) and uses the talent's targeting parameters to determine how to apply the talent tactical parameters to each target.  (See the notes section labelled "--BENEFICIAL VS. HARMFUL TACTICS and HOSTILE VS. FRIENDLY TARGETS--" in mod.class.interface.ActorAI:aiTalentTactics for a detailed explanation of how the weights of different targets are determined.)

If the action has at least one positive TACTIC WEIGHT, is considered useful, and an entry is added to the actions table and the avail table is updated.

After the TACTIC WEIGHTs of all available actions have been computed, the RAW TACTICAL SCORE of each action, representing its overall usefulness, is computed as the sum of the products of the matching want and TACTIC WEIGHT fields (an inner product of two vectors, weighted by the SELF.ai_tactic table):

	RAW TACTICAL SCORE = want[matching TACTIC1]*tactical[matching TACTIC1]*(SELF.ai_tactic[matching TACTIC1] or 1
				+ want[matching TACTIC2]*tactical[matching TACTIC2]*(SELF.ai_tactic[matching TACTIC2] or 1)
				+ ...

The action's primary TACTIC is designated according to the largest (positive) contribution to this sum.
Special Note:  The CLOSEIN and ESCAPE TACTICs are mutually exclusive; only the one contributing the most to the RAW TACTICAL SCORE is used.

The FINAL TACTICAL SCORE is computed by adjusting the RAW TACTICAL SCORE for action speed, effective level and a random bonus (used to provide both randomness and to break ties):

	FINAL TACTICAL SCORE = RAW TACTICAL SCORE*level_adjustment*random_range/speed

where:

	speed = action.speed (while in combat) or 1
	level_adjustment (for talents) = 1 + raw talent level*SELF.AI_TACTICAL_TALENT_LEVEL_BONUS
	level_adjustment (for AIs) = 1 + SELF.level*SELF.AI_TACTICAL_AI_ACTION_BONUS
	random_range = 1 + (SELF.ai_state.tactical_random_range or SELF.AI_TACTICAL_RANDOM_RANGE)

The action with the highest FINAL TACTICAL SCORE (> 0.1), is selected to be performed, as long as the WANT VALUE for its primary TACTIC is >= 0.1.

During its processing, the AI gathers some statistics about SELF's talents and the tactical situation:

	fight_data (SELF.ai_state._fight_data, reset whenever there is no target): 
		actions: total number of actions taken in the current fight
		attacks: total number of attacks performed in the current fight

	talent_stats (SELF.ai_state._talent_stats, updated every 100 game turns -- every 10 actions, usually):
		talent_count: number of non-passive talents known
		is_attack: list of talents fulfilling the ATTACK, ATTACKAREA, or ATTACKALL TACTICs
		attack_count: number of talents considered to be attacks
		combat_only: activated, untargeted talents excluded from use out of combat (with some exceptions)
		attack_ranges: attack counts indexed by talent reach (range + radius)
		attack_max_range: longest reach of all attack talents
		attack_desired_range: estimated best range in which at least 50% of attacks can be used
		attacks_in_range, attacks_out_range: number of currently available talents that can reach, not reach the current target (recomputed each time this AI is invoked)
		
This data is used to modify the WANT VALUEs for some TACTICs and to restrict the use of some actions.

--== SUPPORTED TACTICS ==--
A description of what each TACTIC does, including how its corresponding WANT VALUE is calculated as follows.  Notes and code statements related to each TACTIC are labelled below with a comment using the format --== <TACTIC NAME> ==--.

--== ATTACK ==--
description: the action deals damage to one or more targets
typical tactical table entry: {ATTACK = 2} or {ATTACK = {LIGHTNING=2}} or {ATTACK = {weapon=3}}
want: 2 (reduced if SELF has damage reducing attributes: "numbed", "stunned", "dazed", "invisible_damage_penalty")
This is the baseline WANT VALUE, against which all other tactics are compared.
	
--== ATTACKAREA ==--
description: the action deals damage to one or more targets
typical tactical table entry: as ATTACK but usually used for attacks that affect multiple targets
want: same as want.attack
There is currently no difference between this tactic and ATTACK, but it is useful for specifying multiple attack TACTICs within a single talent.

--== ATTACKALL ==--
description: mostly deprecated, handled as ATTACKAREA

--== LIFE ==--
description: an internally used tactic (not used in tactical tables) reflecting SELF's life condition, used to compute other tactics.
want range: [0, +10)
The want value is affected by self_compassion and is computed using the full life range from SELF.die_at to SELF.max_life and assumes one turn of regeneration.  If SELF knows the Solipsism talent, effective life is computed from a weighted average of life and psi.
want vs. %life (self_compassion = 5): 0.00@100%, 0.13@90%, 2.00@59%, 2.85@50%, 4.00@40%, 8.31@10%, 9.98@0%

--== HEAL ==--
description: action heals the target (usually SELF) or (rarely) prevents damage directly
typical tactical table entry: {HEAL = 2} or {HEAL = function(self, t, target) ...}
	(Typically, the function returns a number based on the target. i.e. self:reactionToward(target) > 0)

want range: [0, +10)
The want value is computed like want.life but takes into account SELF.healing_factor and attributes that prevent healing.
want vs. %life (self_compassion = 5, healing_factor = 1): 0.00@100%, 0.13@90%, 2.00@59%, 2.85@50%, 4.00@40%, 8.31@10%, 9.98@0%

--== CURE ==--
description: the action removes detrimental effects
typical tactical table entry: {CURE = 2} or {CURE = function(self, t, target)}
	(Typically, the function returns a number based on how many bad status effects can be removed by the action.)

want range: [0, +10)
The want value uses a diminishing returns formula based on the total duration of all (removable) detrimental effects on SELF.
want vs total detrimental duration: 0@0, 0.24@1, 2.00@10, 3.33@20, 5.55@50, 7.14@100

--== RESOURCES ==--
description: action replenishes the appropriate resource (i.e. STAMINA, MANA, VIM, ...)
typical tactical table entry: {STAMINA = 2}
want range: (-10, +10)
The want values for most standard resources are computed automatically and need no special treatment.
The default want computation evaluates the resource level vs. self.AI_RESOURCE_LEVEL_TRIGGER (default 0.90).  It assumes one turn of regeneration (if > 0) and is adjusted for global speed (faster increases want).
want vs % of self.AI_RESOURCE_LEVEL_TRIGGER (global_speed = 1): 0.1@100%, 2.0@35%, 5.4@10%, 9.9@0%
A TACTIC is automatically defined by ActorAI.AI_InitializeData() for all actor resources defined when tome.load.lua is run.
Resources can define a specialized want calculation in their definitions as resources_def.ai.tactical.want_level(self, aitarget).  (See the definitions for equilibrium, paradox, and psi for examples.)

--== FEEDBACK ==--
description: action replenishes the feedback pseudo-resource
want range: [0, +10)
The want computation is similar to standard resources, but is less aggressive and does not check self.AI_RESOURCE_LEVEL_TRIGGER.
want vs depleted(global_speed = 1): 0.00@0%, 0.03@20%, 0.40@50%, 2.00@76%, 4.79@90%, 9.92@100%

--== AMMO ==--
description: action replenishes ammunition
typical tactical table entry: {AMMO = 2}
want range: [0, +10)
The want computation requires SELF to have a quiver equipped, and depends on both how much ammo has been used and maximum ammo capacity.  Reloading is more aggressive with a smaller quiver.
want vs shots left (20 shot quiver): 0@20, 0.20@15, 1.11@10, 3.60@5, 10.0@0

--== MOVE ==--
description: an internally used tactic (not used in tactical tables) reflecting how much SELF needs to move from the current grid.  Used to avoid suffocating or damaging terrain.  May modify want.escape or want.closein.
want range: [0, +10)
The want computation is only performed if want.life or want.air > 0 while on damaging or suffocating terrain ( SELF:aiGridDamage)

--== ESCAPE ==--
description: action increases range to the target, prevents attacks (against SELF only), or avoids bad terrain
typical tactical table entry (T_PHASE_DOOR): {ESCAPE = 2}
want range: [-5, +10)
Base want.escape is want.life/2 - 1.  If the main target is closer that SELF.ai_tactic.safe_range (if defined), want.escape will be increased (~+2 @ 2/3 safe range).

--== CLOSEIN ==--
description: action decreases the range to AITARGET
typical tactical table entry (T_RUSH): {CLOSEIN = 3}
want range: [-10, +10)
The want computation is based on comparing the range to the target to the desired attack range for all of SELF's talents.  (It is slightly less than the median range.)  It is increased or decreased based on the difference, and want.escape is subtracted from it.

--== DEFEND ==--
description: action increase defenses/resistances or prevents damage or detrimental effects
typical tactical table entry (T_RESONANCE_FIELD): {DEFEND = 2}
want range: [0, +10)
Base want.defend is want.life/2, but always >= 0.1.  It is increased by up to +5 based on the number and rank of foes nearby.
want vs number of adjacent (rank 2) foes (at full health): 1.11@1, 1.82@2, 2.30@3, 2.67@4, 3.16@6, 3.48@8
	(+1.5 if adjacent to the (hostile) player only)

--== PROTECT ==--
description: action can help defend/assist SELF's summoner
typical tactical table entry (T_GOLEM_TAUNT): {PROTECT = 3}
want range: [0, +10)
The want computation is only performed if SELF.summoner is defined.  It is similar to want.life, but more sensitive to life loss and applies to SELF.summoner instead of SELF.
want vs. summoner life (ally_compassion = 5): 0.00@100%, 0.33@90%, 2.00@71%, 4.44@50%, 7.90@20%, 8.98@10%, 9.99@0%

--== SURROUNDED ==--
description: action is (offensively) useful when surrounded by foes
typical tactical table entry (T_GOLEM_REFLECTIVE_SKIN): {SURROUNDED = 3}
want range: [0, +10)
The want computation is based on the total relative strength of nearby foes vs allies.  It is similar to want.defend but is not affected by life levels.
want vs number of adjacent (rank 2) foes: 0.77@1, 1.43@2, 2.00@3, 2.50@4, 2.94@5, 3.33@6, 3.68@7, 4.00@8.
	(+1.11 if adjacent to the (hostile) player only)

--== DISABLE ==--
description: action hinders the target or reduces its damage, usually applying detrimental status effects to it
typical tactical table entry (T_STUN): {DISABLE = {stun = 2}}
want range: [0, +10)
The want computation assumes that the value of disabling abilities increase with the expected fight duration.  It estimates how long combat is likely to take (based on the apparent strength of AITARGET through a comparison of  life values, how long SELF has already been in combat, and how many attacks have been used during the current fight).  The WANT VALUE is also increased with want.life and want.cure (as a means to buy time).
At full health and with no detrimental effects, against an apparently "equal" foe, want.disable begins at ~2.7 early in combat, but settles to ~2.0 over time if half of the actions against the target have been attacks.

--== BUFF ==--
description: action improves the effectiveness of SELF's attacks, often applying beneficial status effects
typical tactical table entry: {BUFF = 2}
want range: [0.1, ~ want.attack*best attack tactic value/best buff tactic value)
The want computation is performed for each individual talent during the RAW TACTICAL SCORE calculation step after all other WANT VALUEs have been computed.  It uses similar assumptions to the want.disable calculation regarding expected fight duration (except for sustained talents), but adjusts for multiple hostile targets, range to target, and the number of currently available attacks that can reach the target.
The WANT VALUE scales with the best attack TACTIC WEIGHT so that the best buff TACTIC WEIGHT is close to (within the random range of) the best attack TACTIC WEIGHT.  This ensures that buffs always have a chance to be used before the attacks that they augment but are not used to the exclusion of those attacks. (See the actual code below for more details.)
In addition, the WANT VALUE is penalized while fleeing (want.escape > want.attack, typically), and decreases (possibly to negative values) as the range to the target exceeds the desired range for SELF's attacks.  This prevents the AI from wasting buff actions when it can't follow-up with attacks.
With a TACTIC WEIGHT of 2, the WANT VALUE approaches +2 against an "equal" opponent.

--== SPECIAL ==--
description: custom tactic
typical tactical table entry (T_SHOOT_DOWN): {SPECIAL = 10} or {SPECIAL = function(self, t, aitarget) ...}
want: always 1

The tactic value should account for a fixed WANT VALUE of 1, so a useful tactic should generally have a tactic value in the range of 4 (2x2) to 9 (3x3).  Unlike other TACTICs, the tactic value is not adjusted by reaction to the targets affected.

--==ADDITIONAL TACTICS ==--
Additional TACTICs can be defined for this AI.  ActorAI.AI_TACTICS must have a numerical benefit coefficient (usually -1 or +1, default -1) and ActorAI.AI_TACTICS_WANTS must include a function to compute the corresponding WANT VALUE.

For a new TACTIC called "my_tactic":

	ActorAI.AI_TACTICS.my_tactic = 1
	ActorAI.AI_TACTICS_WANTS.my_tactic = function(self, want, actions, avail) ... <return number> end

The function should return a WANT VALUE between -10 and +10, (<= 0 when "my_tactic" is not useful to SELF).  It is called immediately before the SELF.ai_tactic table coefficients are applied.  The function can also add additional actions to the actions table (using the format described in the ALGORITHM and IMPLEMENTATION section above) if needed.

Example -- adding a new tactic using the "ToME:load" hook:

	class:bindHook("ToME:load", function(self, data)
		print("Adding new tactic my_tactic at ToME:load hook")
		local ActorAI = require "mod.class.interface.ActorAI"
		ActorAI.AI_TACTICS.my_tactic = 1 -- define a benefit coefficient for the tactic
		ActorAI.AI_TACTICS_WANTS.my_tactic = function(self, want, actions, avail) -- want value computation
			print("### calculating want for my_tactic:")
			print("###want:") table.print(want, "\t_want_ ")
			print("###actions:") table.print(actions, "\t_actions_ ")
			print("###avail:") table.print(avail, "\t_avail_ ")
			return 2 -- want value (usually more complex than this)
		end
	end)

Note that want, actions, avail, and fight_data are stored in SELF.ai_state in the _want, _actions, _avail, and _fight_data fields respectively.
If may also be helpful to add more substitute damage types to ActorAI.aiSubstDamtypes.
The ActorAI.aiDHashProps and ActorAI.aiOHashProps tables should be updated for any actor attributes that affect how the new TACTIC's tactical tables are computed.

--]]

--- Attempt to perform an action using the improved_tactical AI
-- t_filter (@param for runAI) = optional filter applied to each talent considered
-- t_list (@param for runAI) = optional list of talent id's to consider (defaults to self.talents)
newAI("use_improved_tactical", function(self, t_filter, t_list)
	t_list = t_list or self.talents
	local log_detail = config.settings.log_detail_ai or 0
	--== ATTACK ==-- --== ATTACKAREA ==-- --== SPECIAL ==-- --== ATTACKALL ==-- (deprecated)
	local base_attack = 2
	-- adjust for attributes that reduce all damage inflicted (to a minimum of 50% of base)
	if self:attr("stunned") or self:attr("dazed") then base_attack = base_attack/2 end
	if self:attr("invisible_damage_penalty") then
		base_attack = base_attack * util.bound(1 - (self.invisible_damage_penalty / (self.invisible_damage_penalty_divisor or 1)), 0, 1)
	end
	base_attack = util.bound(base_attack*(1 - (self:attr("numbed") or 0)/100), 0.5, 2)
	local actions = {} -- actions holds data on all available (and useful) actions
	-- want holds the WANT VALUEs for each TACTICs. escape, special and the attack tactics are initialized
	local want = {attack=base_attack, attackarea=base_attack, attackall=base_attack, special=1, escape=0}
	-- avail holds information on TACTICs for which available actions are available
	local avail = {attack={num=0, best=base_attack/2}, escape={num=0, best=0}}
	-- make tactical data accessible outside of this AI
	self.ai_state._actions = actions
	self.ai_state._want = want
	self.ai_state._avail = avail
	local _
	local aitarget = self.ai_target.actor
	local ax, ay = self:aiSeeTargetPos(aitarget)
	local foes_near_strength, allies_near_strength = 0, 0
	if log_detail > 0 then print("[use_tactical AI]==##== RUNNING turn", game.turn, self.uid, self.name, self.x, self.y, "with target", aitarget and aitarget.name, aitarget and aitarget.uid, ax, ay, "==##==") end
	local target_dist = aitarget and core.fov.distance(self.x, self.y, ax, ay)
	-- affects how random action selection is; 0.5 --> FINAL TACTICAL SCORE of each action randomly increased by up to 50%
	local ai_weight_range = self.ai_state.tactical_random_range or self.AI_TACTICAL_RANDOM_RANGE
	local self_compassion = (self.ai_state.self_compassion == false and 0) or self.ai_state.self_compassion or 5
	local ally_compassion = (self.ai_state.ally_compassion == false and 0) or self.ai_state.ally_compassion or 1

	-- update talent stats every 100 game turns (accounts for actors (i.e. party members) learning new talents)
	local update_stats = not self.ai_state._talent_stats or (self.ai_state._talent_stats.last_update or 0) + 100 < game.turn and next(t_list)

	if update_stats then
		self.ai_state._talent_stats = {last_update=game.turn, combat_only={},
			talent_count=0,
			attack_ranges={},
			attack_desired_range = self.ai_tactic.safe_range or 1, -- default
			attack_count=0, attack_max_range=1, is_attack={}
		}
		update_stats = next(t_list)
		--print("[tactical AI] updating talent stats for", self.name, self.uid)
	end
	local talent_stats = self.ai_state._talent_stats
	
	-- keep track of the current fight (reset if no hostile target)
	self.ai_state._fight_data = self.ai_state._fight_data or {actions=0, attacks=0}
	local fight_data = self.ai_state._fight_data
	if not aitarget or self:reactionToward(aitarget) >= 0 then
		fight_data.actions, fight_data.attacks = 0, 0
	end
	
	-- consider moving this later to skip calculating wants with no corresponding avail (not for now)
	--== RESOURCES ==--
	-- Evaluate resource levels, populating the want table as needed (includes air calculation)
	--Note: life regen, resource replenishment, talent cooldown updates happen on game tick (every SELF.global_speed action turns through SELF:actBase())
	if log_detail > 2 then print("[use_tactical AI] --- evaluating resource levels ---") end
	-- coefficients for standard want limit formula
	-- want vs resource depletion as % of AI_RESOURCE_LEVEL_TRIGGER: 0.1 @ 100%, 2.0 @ 35%
	local dep_low = 1 - self.AI_RESOURCE_LEVEL_TRIGGER; dep_low = dep_low/(math.max(0.001, 1 - dep_low))
	local dep_high = 1 - 0.35*self.AI_RESOURCE_LEVEL_TRIGGER; dep_high = dep_high/(math.max(0.001, 1 - dep_high))
	for res, res_def in ipairs(self.resources_def) do
		if not res_def.talent or self:knowTalent(res_def.talent) then -- determine want for this resource
			-- resource-defined want calculation
			if res_def.ai and res_def.ai.tactical and res_def.ai.tactical.want_level then 
				want[res_def.short_name] = util.getval(res_def.ai.tactical.want_level, self, aitarget)
				if log_detail > 2 then print("\t--- checking resource", res_def.name, self[res_def.short_name], self[res_def.minname], self[res_def.maxname], "resource defined want:", want[res_def.short_name]) end
			else -- standard want calculation
				local depleted = 0
				local val, regen = self[res_def.getFunction](self)
				local min, max = (self[res_def.getMinFunction](self) or 0), (self[res_def.getMaxFunction](self) or 100)
				if res_def.invert_values and max then
					regen = math.min(0, self[res_def.regen_prop])/self.global_speed
					depleted = 1-(max+regen-val)/(max-min)
				elseif not res_def.invert_values and min then
					regen = math.max(0, self[res_def.regen_prop])/self.global_speed
					depleted = 1-(val+regen-min)/(max-min)
				end
				-- adjust depletion rate, de-emphasizing lower depletion levels, modified by global speed
				depleted = depleted/math.max(0.001, 1-depleted)*self.global_speed
				-- want vs % of self.AI_RESOURCE_LEVEL_TRIGGER (global_speed 1): 0.1@100%, 2.0@35%, 5.4@10%, 9.9@0%
				want[res_def.short_name] = math.max(0, self:combatLimit(depleted, 10, 0.1,  dep_low, 2, dep_high))
				if log_detail > 2 then print("\t--- checking resource", res_def.name, self[res_def.short_name], self[res_def.minname], self[res_def.maxname], "std. want:", want[res_def.short_name]) end
			end
		end
	end
	
	--== AMMO ==--
	local ammo = self:hasAmmo()
	if ammo then
		-- want depends on how much ammo has been used and maximum ammo capacity
		-- reloading is more aggressive with a smaller quiver
		local used = (ammo.combat.capacity - ammo.combat.shots_left)/ammo.combat.capacity
		used = used/math.max(0.001, 1-used) -- modified depletion
		want.ammo = 10*(used/(used + ammo.combat.capacity/10))^2
		-- for a 20 shot quiver, want vs shots left: 0@20, 0.20@15, 1.11@10, 3.60@5, 10.0@0
	end
	
	--== LIFE ==--
	local life -- fraction of maximum life
	local life_regen, psi_regen = self:regenLife(true) -- regeneration, accounting for caps
	life_regen, psi_regen = (life_regen or 0)/self.global_speed, (psi_regen or 0)/self.global_speed
	local effect_life, life_range = self.life - self.die_at, self.max_life - self.die_at -- effective total life and maximum used by buff/disable calculation
	
	-- Note: The want function defined in the psi resource definition adjusts for Solipsism
	if self:knowTalent(self.T_SOLIPSISM) then
		local ratio = self:callTalent(self.T_SOLIPSISM, "getConversionRatio")
		life_range = math.min(life_range/(1 - ratio), life_range + self:getMaxPsi())
		effect_life = math.min(effect_life/(1 - ratio), effect_life + self:getPsi())
		-- psi deficit is exaggerated to promote pre-emptive healing (for clarity/solipsism)
		life = (((self:getPsi() + psi_regen)/self:getMaxPsi())^2 * ratio + (self.life + life_regen- self.die_at)/(self.max_life-self.die_at)*(1-ratio))
	else
		life = (effect_life + life_regen)/life_range
	end
	
	life = (1 - life)/(math.max(.001, life)) --convert to modified life loss
	-- basic healing need reflecting self condition, used to compute other tactical wants
	want.life = 10*(life*self_compassion/(life*self_compassion + 4.36))^2 -- for self_compassion = 5: 0.13@90%, 2.00@59%, 2.85@50%, 4.00@40%, 6.00@25%, 8.31@10%, 9.98@0%

	--== HEAL ==--
	-- actual healing want is affected by healing_factor and attributes that prevent healing
	if self:attr("no_healing") or self:attr("unstoppable") then want.heal = 0 else
		local hf = util.bound((self.healing_factor or 1), 0, 2.5)
		want.heal = 10*(life*self_compassion*hf/(life*self_compassion*hf + 4.36))^2
	end

	--== PROTECT ==--
	-- like LIFE but for SELF's summoner
	if self.summoner then
		local life = math.max(0, self.summoner.life)/(self.summoner.max_life - self.summoner.die_at/2)
		life = (1 - life)/(math.max(.001, life)) -- modified life loss
		want.protect = 10*(life*ally_compassion/(life*ally_compassion + 2.5))^2
	end

	if log_detail > 2 then print("[use_tactical AI] Prelim wants:") table.print(want, "--") end

	-- initialize currently available attack stats
	 talent_stats.attacks_in_range, talent_stats.attacks_out_range = 0, 0

	 --=== EVALUATE TALENTS ===--
	for tid, lvl in pairs(t_list) do 
		local t = self:getTalentFromId(tid) if t and (not t_filter or self:filterTalent(t, t_filter)) then --talent loop
		local tactical = t.tactical_imp or t.tactical -- DEBUGGING transitional look for tactical_imp tactical table

		if tactical then -- eliminates passive talents
			local aitarget = aitarget
			local requires_target = self:getTalentRequiresTarget(t)
			local ax, ay = ax, ay
			local target_dist = target_dist
			local t_reach = (self:getTalentRange(t) or 0) + (self:getTalentRadius(t) or 0)
			local is_instant = util.getval(t.no_energy, self, t) == true
			local speed = aitarget and math.max(0.1, is_instant and 0 or self:getTalentSpeed(t)) or 1 -- compute talent speed (while in combat), affects tactical weights

			if t.onAIGetTarget then -- handles talent-specific targeting (mostly for heals and friendly effects)
				ax, ay, aitarget = t.onAIGetTarget(self, t)
				if not (ax and ay) then
					ax, ay = self:aiSeeTargetPos(aitarget)
				end
				target_dist = aitarget and core.fov.distance(self.x, self.y, ax, ay)
			end
			
			local t_avail, is_active = false
			local is_attack, tacts
			if log_detail > 1 then print("[use_tactical AI] ##", self.name, "TESTING", t.mode, "talent", tid, t.name, t.is_object_use and t.getObject(self, t).name or "", "with target", aitarget and aitarget.name or "<none>", ax, ay) end
			
			-- update talent statistics (all talents)
			if update_stats then
				if type(tactical) == "function" then tactical = tactical(self, t, aitarget) or {} end
				
				if log_detail > 2 then print("[use_tactical AI] updating talent statistics with", t.id, t.name) end
				is_attack = tactical.attack or tactical.attackarea or tactical.disable or tactical.attackall
				talent_stats.talent_count = talent_stats.talent_count + 1 --SELF tactics excluded
				if is_attack then
					-- special case: closing attacks (e.g. RUSH) don't increase desired range
					local des_range = tactical.closein and 1 or t_reach
					talent_stats.is_attack[t.id] = true
					talent_stats.attack_ranges[des_range] = (talent_stats.attack_ranges[des_range] or 0) + 1
					talent_stats.attack_count = talent_stats.attack_count + 1
					talent_stats.attack_max_range = math.max(talent_stats.attack_max_range, t_reach)
				end
				 -- out of combat, don't allow active talents unless they heal, cure, escape, or restore resources
				 -- "life" or "cure" --> talent can be used if want.heal or want.cure >= 0.1
				if t.mode == "activated" and not requires_target then
					-- some talents can be used out of combat while wounded or afflicted (see below)
					local combat_only = (tactical.attack or tactical.attackarea or tactical.closein or tactical.buff or tactical.protect or tactical.surrounded)-- and not tactical.escape
					if combat_only then
						combat_only = not tactical.escape and not tactical.ammo
						if combat_only then
							for res, val in pairs(tactical) do
								if self.resources_def[res] then
									combat_only = false break
								end
							end
						end
					end
					combat_only = (tactical.heal or tactical.defend) and "life" or tactical.cure and "cure" or combat_only
					talent_stats.combat_only[t.id] = combat_only
				end
			end
			is_attack = talent_stats.is_attack[t.id]

			if (aitarget or t.mode == "sustained" or not requires_target) then
				is_active = self:isTalentActive(tid)
				-- Only assume range... some talents may not require LOS, etc
				local within_range = target_dist and target_dist <= t_reach
				if is_attack then -- update talent attack in range stats
					if within_range then talent_stats.attacks_in_range = talent_stats.attacks_in_range + 1
					else talent_stats.attacks_out_range = talent_stats.attacks_out_range + 1
					end
				end
				-- primary talent availability check
				t_avail = not t.no_npc_use and not self:isTalentCoolingDown(t) and self:preUseTalent(t, true, true) and (not requires_target or within_range or is_active) and (not t.on_pre_use_ai or t.on_pre_use_ai(self, t, true, true)) -- includes checks from ActorAI:aiPreUseTalent, except aiCheckSustainedTalent

				-- Out of combat, reject some talents
				if t_avail and not aitarget then -- no non-sustained buffs, unless allowed while wounded or afflicted
					if t.mode == "activated" and talent_stats.combat_only[t.id] and (want.life < 0.1 or talent_stats.combat_only[t.id] ~= "life") and (not want.cure or want.cure < 0.1 or talent_stats.combat_only[t.id] ~= "cure") then
						t_avail = false
					end
					-- These checks replace those performed in aiCheckSustainedTalent for simpler AIs
					-- don't turn on sustains that cannot be sustained indefinitely
					-- active draining sustains may eventually be deactivated (std tactical evaluation)
					if t.mode == "sustained" and t._may_drain_resources and not is_active then
						local res_def, r_invert
						for res, _ in pairs(t._may_drain_resources) do
							res_def = self.resources_def[res]; r_invert = res_def.invert_values and -1 or 1
							if ((self[res_def.regen_prop] or 0) - (util.getval(t[res_def.drain_prop], self, t) or 0)*r_invert)*r_invert <= 0 then
								t_avail = false break
							end
						end
					end
				end
				if t_avail then -- evaluate the talent
					local force_target
					-- Compute the resolved table of TACTIC WEIGHTs (analyzes tactical tables, performs dummy projection, etc.)
					tacts = self:aiTalentTactics(t, aitarget)
					if log_detail >= 2 then print("[use_tactical AI] COMPUTED TACTIC WEIGHTs for:", tid) table.print(tacts, "---") end
					if tacts then
						local action
						for tact, val in pairs(tacts) do -- TACTIC loop
							local benefit = self.AI_TACTICS[tact] or -1
							avail[tact] = avail[tact] or {best=0, num=0}
							if val > 0 then
								-- Note: aiTalentTargets automatically selects self for untargeted talents
								--beneficial tactics cause untargeted talents to target the talent user by default
								--	force_target = force_target or benefit > 0 and not requires_target and self
								if log_detail >= 2 then print("[use_tactical AI]", self.uid, self.name, tid, "USEFUL TACTIC:", tact, val) end
								action = action or {tid=tid, lvl=lvl, tacts = tacts, speed=speed, is_attack=is_attack, mode=t.mode, is_active = is_active}
								-- update the avail table
								if val/speed > avail[tact].best then -- follows final speed adjustment
									avail[tact].best = val/speed
									avail[tact].best_action = action
								end
								avail[tact].num = avail[tact].num + 1
							end
						end -- end TACTIC loop
						if action then
							if t.ai_level then -- handle special talent level (prodigies, etc.)
								action.lvl = util.getval(t.ai_level, self, t) or 1
							end
							-- factor in chance for talent failure (i.e. confusion, eq failure)? (not for now):
							-- all talents: no_talent_fail, 
							-- non-instant talents: confused, terrified, scoundrel_failure, talent_fail_chance
							-- talent flags:
							-- t.never_fail
							-- t.is_spell: spell_failure, forbid_arcane(automatic failure) handled by preUseTalent
							-- t.is_nature: nature_failure, forbid_nature(automatic failure) handled by preUseTalent

							--factor talent tactic values by any general adjustments (for later implementation)
							local wt_adj = 1
							if wt_adj ~= 1 then
								for tact, val in pairs(tacts) do
									tacts[tact] = val*wt_adj
								end
							end
							actions[#actions+1] = action
							action.force_target = force_target
							if log_detail > 1 then print("[use_tactical AI]", t.id, "ADDED to actions list TACTIC WEIGHTs:\n\t", (string.fromTable(action.tacts))) end
						else
							if log_detail > 1 then print("[use_tactical AI]", t.id, "NOT TACTICALLY USEFUL") end
						end
					end
				else
					if log_detail > 1 then print("[use_tactical AI]", t.id, "NOT AVAILABLE") end
				end
			else
				if log_detail > 1 then print("[use_tactical AI]", t.id, "NOT CONSIDERED (no required target)") end
			end
		end
	end end -- end talent loop

	if update_stats then -- finish updating talent stats after all talents have been evaluated
		-- calculate the desired attack range as the (modified) median attack range (weighted avg range either side of median range, inclusive)
		talent_stats.attack_desired_range = self.ai_tactic.safe_range or 1 -- default

		local sum, break_pt, n, keys = 0, talent_stats.attack_count/2, 0, {} -- calculate around the median range
		for range, count in pairs(talent_stats.attack_ranges) do
			n = n + 1; keys[n] = range
		end
		table.sort(keys)
		local last_range, last_count, count = 0, 0, 0
		for i, range in ipairs(keys) do
			count = talent_stats.attack_ranges[range]
			if sum + count >= break_pt then
				talent_stats.attack_desired_range = math.max(1, math.floor((last_range*last_count + range*(break_pt - sum))/(last_count + break_pt - sum)))
				break
			end
			sum = sum + count
			last_range, last_count = range, count
		end
	end

	--== FEEDBACK ==-- -- pseudo resource uses std want formula, but ignores decay w/o feedback loop
	if avail.feedback and self.psionic_feedback then 
		local val, max = self:getFeedback(), self:getMaxFeedback()
		local regen = self:hasEffect(self.EFF_FEEDBACK_LOOP) and math.min(max - val, self:getFeedbackDecay()) or 0
		local depleted = 1 - (val + regen)/max
		depleted = depleted/math.max(0.001, 1-depleted)*self.global_speed
		want.feedback = 10*(depleted/(depleted + 4))^2 -- want vs depleted: 0.00@0%, 0.03@20%, 0.40@50%, 2.00@76%, 4.79@90%, 9.92@100%, (for normal speed)
	end

	--== CURE ==--
	if avail.cure then
		local detriment_dur = 0 -- calculate total duration of all detrimental effects
		for eff_id, p in pairs(self.tmp) do
			if p.dur and p.dur > 1 then
				local e = self.tempeffect_def[eff_id]
				if e.type ~= "other" and e.status == "detrimental" and e.decrease > 0 and not e.no_remove then
					detriment_dur = detriment_dur + (p.dur-1) --weight depends on remaining duration
				end
			end
		end
		want.cure = 10*detriment_dur/(detriment_dur + 40) -- = 2 for a single effect of 10 turns duration
	end

	--== DEFEND ==--
	want.defend = math.max(0.1, 0.5*want.life) -- minimum allows for buff sustains to be activated out of combat
	
	--== BUFF ==-- set up parameters for want.buff calculations (final tactical weight calculation, below)
	want.buff = 0.1
	local buff_best_attack_value = math.max(want.attack*(self.ai_tactic.attack or 1), want.attackarea*(self.ai_tactic.attackarea or 1))
	local buff_range_factor = 0
	local buff_duration_factor = 0.1 -- allows sustained buffs to be used out of combat
	
	local movement_speed = self:combatMovementSpeed()

	-- with a target, compute some combat-related tactical want values
	if target_dist then
		if log_detail > 2 then print("[use_tactical AI] targeted tactics: current fight_data:") table.print(fight_data, "__") end
		-- update talent_stats for currently available attack ranges
		talent_stats.range_avail = 0
		for range, count in pairs(talent_stats.attack_ranges) do
			if range >= target_dist then
				talent_stats.range_avail = talent_stats.range_avail + count
			end
		end
		talent_stats.range_avail = talent_stats.range_avail/math.max(1, talent_stats.attack_count)
		if log_detail > 2 then print("[use_tactical AI] TALENT STATS:") table.print(talent_stats) end

		--== ESCAPE ==--
--		want.escape = want.life/2 -- baseline escape value (=2 at 40% life for most actors, more agressive)
		want.escape = want.life/2 - 1 -- baseline escape value (=2 at 25% life for most actors)
		-- adjust if safe_range is defined
		if self.ai_tactic.safe_range and target_dist < self.ai_tactic.safe_range then want.escape = util.bound(want.escape + 6*(self.ai_tactic.safe_range - target_dist)/self.ai_tactic.safe_range, -5, 10) -- increase want.escape by +2 @ 2/3 safe range
		end

		-- add escape by normal movement to the action list, in case it's better than using a talent		
		if want.escape > 0.1 and not self:attr("never_move") and not self.ai_tactic.never_move_escape then
			local can_flee, fx, fy
			-- Note: values are <= weight of move_safe_grid if present
			-- Could use better testing to make sure fleeing is possible (and prevent back and forth movement)
			-- and check attack ranges of enemy
--			if want.escape <= 4 then -- flee but stay in contact (tunable parameter)
			if want.escape <= 3 then -- flee but stay in contact (tunable parameter)
				can_flee, fx, fy = self:aiCanFleeDmapKeepLos()
				if log_detail > 2 then print("[use_tactical AI] fleeDmapKeepLos calculation:", can_flee, fx, fy) end
				if can_flee then  -- make escape by movement available
					local val = 1/math.max(1, target_dist + 1 - math.min(self.sight, talent_stats.attack_max_range)) -- narrow tactic value range, <= weight of move_safe_grid, if present, don't flee beyond best attack range
					avail.escape.best = math.max(avail.escape.best, val/movement_speed)
					avail.escape.num = avail.escape.num + 1
					actions[#actions+1]={ai="flee_dmap_keep_los", fx, fy, tacts = {escape=val, ammo=ammo and 1 or nil}, speed = movement_speed}
				end
			else -- flee to up to 1.5x contact distance (note: ability to flee is not guaranteed)
				if log_detail > 2 then print("[use_tactical AI] flee_dmap selected, want.escape =", want.escape) end
				local val = math.min(1, (1.5*math.max(self.sight, talent_stats.attack_max_range) - target_dist)/target_dist)
				avail.escape.best = math.max(avail.escape.best, val/movement_speed)
				avail.escape.num = avail.escape.num + 1
				actions[#actions+1]={ai="flee_dmap", tacts = {escape=val, ammo=ammo and 1 or nil}, speed = movement_speed}
			end
		end
		 -- reduce want.escape with distance from the target (decrease to 0 at 2x either max attack range or 10)
		want.escape = want.escape*math.min(1, 2 - target_dist/math.max(talent_stats.attack_max_range, 10))

		--== CLOSEIN ==--
		-- closing in depends on the desired range for attacks and how many attacks can currently reach the target
		-- want.closein is intentionally kept low (limit 2.5), so that heals, resources, etc. are performed before closing when their want values approach 2
		local delta_range = target_dist - math.max(talent_stats.attack_desired_range, self.ai_tactic.safe_range or 0) -- distance outside of desired range to target
		local delta = delta_range*(talent_stats.attack_count - talent_stats.attacks_in_range + 1)/(talent_stats.attacks_in_range + 1) -- = effective distance difference if half talents in range

		want.closein = 2.5*delta/(math.abs(delta) + 1.25) --vs delta range, 50% attacks out of range: 1.11@1, 1.54@2, 2.00@5, 2.22@10, 2.31@15

		if log_detail >= 2 then print("[use_tactical AI] --closein calculation: want.closein:", want.closein, "target_dist", target_dist, "delta_fact", delta, "range_avail", talent_stats.range_avail, "want.move", want.move, "safe_range", self.ai_tactic.safe_range) end

		--if we can closein by movement, add it to the action list, in case it's better than using a talent
		if want.closein > 0.1 and target_dist > 1 and not self:attr("never_move") then
			-- decrease tactic value of movement at higher ranges to defer to other available actions
			actions[#actions+1]={ai=self.ai_state.ai_move or "move_simple", false, ax, ay, tacts = {closein=0.5*(1+2/target_dist)}, speed = movement_speed}
		end

		--== SURROUNDED ==--  --count all enemies within range 10, adjusting for range
		--(only used by choker of dread, reflective skin)
		local sqsense = 10 * 10
		local nb_foes_seen = 0
		for i, act in ipairs(self.fov.actors_dist) do
			if act and act ~= self and not act.dead and self.fov.actors[act] then
				if self.fov.actors[act].sqdist <= sqsense then
					if self:reactionToward(act) < 0 then
						nb_foes_seen = nb_foes_seen + 1
						foes_near_strength = foes_near_strength + (act.rank or 2)/self.fov.actors[act].sqdist
					else
						allies_near_strength = allies_near_strength + (act.rank or 2)/self.fov.actors[act].sqdist/2
					end
				else break
				end
			end
		end
		local hostiles = foes_near_strength-allies_near_strength
		if hostiles > 0 then
			want.surrounded = 10*hostiles/(hostiles + 24) -- = 1.11 if adjacent to the player only
		end

		--== DEFEND ==--
		want.defend = want.defend + 5*foes_near_strength/(foes_near_strength + 7) -- +1.5 if adjacent to player only at full health
		if log_detail >= 2 then print("[use_tactical AI] --defend/surrounded calculation: want.defend=", want.defend, "want.surrounded=", want.surrounded, "foes_near_strength=", foes_near_strength, "allies_near_strength=", allies_near_strength) end

		if avail.buff or avail.disable then -- buff and disable depend on target's condition and fight_data
			-- note: effect_life, life_range, calculated above for want.life
			local aitarget_life, aitarget_life_range = (aitarget.life or 1) - (aitarget.die_at or 0), (aitarget.max_life or 1) - (aitarget.die_at or 0)
			
			if aitarget.knowTalent and aitarget:knowTalent(aitarget.T_SOLIPSISM) then
				local ratio = aitarget:callTalent(aitarget.T_SOLIPSISM, "getConversionRatio")
				aitarget_life = math.min(aitarget_life/(1 - ratio), aitarget_life + aitarget:getPsi())
				aitarget_life_range = math.min(aitarget_life_range/(1 - ratio), aitarget_life_range + aitarget:getMaxPsi())
			end
			if log_detail >= 2 then
				print(" --- Want buff/disable calculations and effective life values):")
				print(("\tself: effect_life/life_range = %0.1f/%0.1f vs. target: life/life_range = %0.1f/%0.1f"):format(effect_life, life_range, aitarget_life, aitarget_life_range))
			end
	
			--== DISABLE ==--
			-- adjustment for expected fight duration:
			-- don't waste time disabling a foe that is about to be killed (based on target life vs self life range)
			-- factor in attack rate (a rough measure of engagement with the target and how hard it is to kill)
			-- if the fight has been going for a while (with significant attack rate), disabling the opponent is more useful since bad status effects are more likely to run their course
			local duration_factor = (aitarget_life/life_range)^.5*(fight_data.attacks + fight_data.actions + 1.5)/(1.5*fight_data.actions + 1) -- for equal life, = 1.5 initially and (long term) ~1.0 for a 50% attack rate, ~0.67 to ~1.33 for 0% to 100% attack rate
			-- treat disabling the target as a useful way of self preservation or to buy time to recover from detrimental status effects
			local disable_factor = 0.3*want.life + 0.2*(want.cure or 0) + 1.5*duration_factor
			want.disable = 10*disable_factor/(disable_factor + 6)
			-- with full health/no detrimental effects against an "equal" opponent = ~2.72 initially and ~2.0 for a long-running 50% attack rate
			--with want.heal = 10, want.cure = 10 against an "equal" opponent = ~5.47 initially and ~5.2 for a long-running 50% attack rate
			if log_detail >= 2 then print(" --- Want Disable updated calculation: WANT =", want.disable, ("disable_factor %0.2f(w.l=%0.2f, w.c=%0.2f, df=%0.2f)"):format(disable_factor, want.life, want.cure or 0, duration_factor)) end

			if avail.buff then
				--== BUFF ==--
				-- want.buff scales with the TACTIC WEIGHT of the best attack so that the FINAL TACTIC WEIGHT of the best buff falls within +- the random ai_weight_range of the FINAL TACTIC WEIGHT of the best attack
				-- The point within this range the buff falls depends on the TACTIC WEIGHT of the buff, 
				-- the availability of attacks vs the target (range vs. desired attack range),
				-- and the duration factor, reflecting an estimate of how many turns the buff will be useful
				-- this ensures that buffs are not used to the exclusion of attakcs and visaversa

				-- range penalty (if too far from target - won't be able to follow up with attacks)
				buff_range_factor = 1 - util.bound((target_dist - talent_stats.attack_desired_range-0.5)/math.max(1, talent_stats.attack_max_range - talent_stats.attack_desired_range)*(0.9 - 0.9* talent_stats.range_avail), 0, 1) -- decrease steadily from desired to max range, adjusting for available attacks
				-- adjustment for expected fight duration (as disable, but increase for extra foes):
				-- don't waste time on buffs if the target can be killed quickly (based on target life vs self life range)
				-- considers the total number of targets
				-- if the fight has been going for a while (with significant attack frequency), try to increase buffs to make attacks more effective
				buff_duration_factor = duration_factor*math.max(1, nb_foes_seen)
				
				-- keep track of the best (adjusted) tactical attack and attackarea values
				buff_best_attack_value = want.attack*(self.ai_tactic.attack or 1)*avail.attack.best*(1+(avail.attack.best_action and avail.attack.best_action.lvl or 0)*self.AI_TACTICAL_TALENT_LEVEL_BONUS) --avail.attack.best >= 1
				if avail.attackarea then
					buff_best_attack_value = math.max(buff_best_attack_value, want.attackarea*(self.ai_tactic.attackarea or 1)*avail.attackarea.best*(1+(avail.attackarea.best_action and avail.attackarea.best_action.lvl or 0)*self.AI_TACTICAL_TALENT_LEVEL_BONUS))
				end
			end
		end
	end -- end target-dependent wants
	
	--== MOVE ==--  -- Check for bad terrain (don't drown or stand in a fire and die)
	if want.air > 0 or want.life > 0 or self.ai_state.safe_grid then
		local turns = 10, grid
		local dam, air = self:aiGridDamage() --resistances, etc. factored in
		if air < 0 then -- suffocating terrain
			turns = math.max(1, (self.min_air - self.air)/math.min(-1, self.air_regen + air)) --est turns to suffocate
			want.move = math.max(0.1, want.air*(1-turns/(turns + 10))) -- = 50% of want.air at 10 turns left, ~91% of want.air at 1 turns left
			-- = < 10% of want.air for most actors (max_air = 100) that aren't suffocating
			if log_detail > 2 then 
				print(("%s wants escape(move) %0.2f (air: %s = %0.2f) on %s (%d, %d, air:%s = %s turns)"):format(self.name:capitalize(), want.move, self.air, want.air, game.level.map(self.x, self.y, engine.Map.TERRAIN).name, self.x, self.y, air, turns))
				if config.settings.cheat then game.log("#ORCHID#%s wants escape(move) %0.2f (air: %s = %0.2f) on %s (%d, %d, air:%s = %s turns)", self.name:capitalize(), want.move, self.air, want.air, game.level.map(self.x, self.y, engine.Map.TERRAIN).name, self.x, self.y, air, turns) end -- debugging
			end
		end
		if dam > 0 then -- want to move away from damaging terrain
			want.move = math.max(want.move or 0, math.max(0.1, want.life*5*dam/(5*dam + effect_life))) -- equal to 50% of want.life if 20% life will be lost (for self_compassion = 5)
			if log_detail > 2 then
				print(("%s wants escape(move) %0.2f (heal) in %s at(%d, %d) dam %d vs %d avail life)"):format(self.name:capitalize(), want.move, game.level.map(self.x, self.y, engine.Map.TERRAIN).name, self.x, self.y, dam, self.life-self.die_at))
				if config.settings.cheat then game.log("#ORCHID#%s wants escape(move) %0.2f (heal) in %s at(%d, %d) dam %d vs %d avail life)", self.name:capitalize(), want.move, game.level.map(self.x, self.y, engine.Map.TERRAIN).name, self.x, self.y, dam, self.life-self.die_at) end -- debugging
			end
		end
		
		if want.move then
			-- when escaping terrain, determine if closing or avoiding the target is better
			local dist_weight, want_closer = aitarget and 1 or 0.1
			want_closer = util.bound((want.closein or 0)*(self.ai_tactic.closein or 1) + (want.attack or 0)*(self.ai_tactic.attack or 1) - (want.escape or 0)*(self.ai_tactic.excape or 1), -1, 1)
			grid = self.ai_state.safe_grid
			if not (self.x and grid and grid.path and #grid.path > 1 and grid.path[1] and grid.path[1].x and core.fov.distance(self.x, self.y, grid.path[1].x, grid.path[1].y) == 1) then -- find a safer grid if needed/possible
				grid = self:aiFindSafeGrid(10, want.life, want.air, dist_weight, want_closer)
			else
				grid.start_haz = self:aiGridHazard()
			end

			if grid and grid.dist > 0 then -- found a better grid
				self.ai_state.safe_grid = grid
				if log_detail >= 2 then print("[use_tactical AI] found safe grid at:", grid[1], grid[2]) end
				-- increase want to start moving in time to prevent suffocating or dying to damage
				if turns < 10 then -- running out of air soon (grid.move_cost includes global speed, which tracks air loss)
					want.move = util.bound(want.air*grid.dist*grid.move_cost/math.max(turns-1, 0.5), want.move, 10)
				end
				if dam > 0 then -- start moving in time to reach a safe grid before dying to damage
					want.move = util.bound(want.life*grid.dist*grid.move_cost/math.max(effect_life/dam-1, 0.5), want.move, 10)
				end
				local val = 1.5*(grid.end_haz > 0 and 1 - grid.end_haz/grid.start_haz or 1) -- always >= weight for flee_dmap_keep_los if a safer grid can be reached
				avail.escape.best = math.max(avail.escape.best, val/movement_speed)
				avail.escape.num = avail.escape.num + 1
				actions[#actions+1]={ai="move_safe_grid", grid, 10, want.life, want.air, dist_weight, want_closer,
					tacts = {move=val, ammo=ammo and 1 or nil},
					speed = movement_speed
					}
			end
			--== ESCAPE ==-- --== CLOSEIN ==--
			-- Allow want.move to trigger non-movement closein and escape actions
			if want.closein and target_dist > 1 then
				want.closein = want.closein + math.max(0, want.move - 0.1)
			end
			want.escape = math.max(want.escape, want.move)
		else
			self.ai_state.safe_grid = nil
		end
	end

	if log_detail > 0 then
		if log_detail > 2 then
			if log_detail > 4 then -- full detail of available actions
				print("### [use_tactical AI] Final Actions Table:") table.print(actions, "_fa_ ")
				print("### [use_tactical AI] Available TACTICs Table:") table.print(avail, "_at_ ")
			end
			print("[use_tactical AI] ===Want Buff parameters:")
			print(" ___ buff_best_attack_value =", buff_best_attack_value, ("best attack[%s]: %s, lvl:%s, ai_tactic: %s"):format(avail.attack.best_action and (avail.attack.best_action.tid or avail.attack.best_action.ai), avail.attack.best, avail.attack.best_action and avail.attack.best_action.lvl, self.ai_tactic.attack), avail.attackarea and ("\n\t___ best attackarea[%s]: %s, lvl:%s, ai_tactic: %s"):format(avail.attackarea.best_action and (avail.attackarea.best_action.tid or avail.attackarea.best_action.ai), avail.attackarea.best, avail.attackarea.best_action and avail.attackarea.best_action.lvl, self.ai_tactic.attackarea))
			print((" ___ buff_range_factor: %s, target dist: %s, desired range: %s"):format(buff_range_factor, target_dist, talent_stats.attack_desired_range), "buff_duration_factor:", buff_duration_factor)
		end
	
		print("[use_tactical AI] ### foes_near_strength", foes_near_strength, "### allies_near_strength", allies_near_strength, "### want.life", want.life, "want.escape", want.escape)
--		print("[use_tactical AI] ### Computed Wants:") local tt = table.to_strings(want, "[%s]=%0.3f") table.sort(tt) print(table.concat(tt, ", "))
--		print("[use_tactical AI] ### Computed Wants:\n\t", (string.fromTable(want, nil, nil, nil, nil, true)))
	end

	--== Final Action Evaluation and Selection ==--
	if #actions == 0 then -- no useful actions available
		if log_detail > 0 then
			print("[use_tactical AI]", self.uid, self.name, "NO USEFUL ACTIONS available, NO ACTION TAKEN.")
			if log_detail > 1.4 and config.settings.cheat then game.log("#GREY#__%s[%d] tactical AI: NO USEFUL ACTIONS", self.name, self.uid) end -- debugging
		end
		return
	else  -- at least one useful action available, evaluate tactical "wants" corresponding to available actions
		--==ADDITIONAL TACTICS ==--
		for swant, sw_value in pairs(self.AI_TACTICS_WANTS) do
			if self.AI_TACTICS[swant] then
				if log_detail > 0 then print("[use_tactical AI] Evaluating want for additional TACTIC:", swant, sw_value) end
				want[swant] = util.getval(sw_value, self, want, actions, avail) or 0
			end
		end
		-- apply the ai_tactic table
--print("[use_tactical AI] ### ai_tactic:") local tt = table.to_strings(self.ai_tactic, "[%s]=%s") table.sort(tt) print(table.concat(tt, ", ")) -- debugging sort output (not needed by ai)
		if log_detail > 0 then print("[use_tactical AI] ### ai_tactic:\n\t", (string.fromTable(self.ai_tactic, nil, nil, nil, nil, true))) end
		for tact, mult in pairs(self.ai_tactic) do if want[tact] then want[tact] = want[tact]*mult end end
		-- closein and escape are mutually exclusive tactics, subtract want.escape from want.closein to prevent closing with the enemy while wounded
		if want.closein then
			want.closein = util.bound(want.closein - want.escape, -10, 10)
			if log_detail >= 2 then print("--want.closein adjusted for want.escape:", want.closein) end
		end

		-- DGDGDGDG; this is a temporary measure (so I suppose it'll stay like that for a few years :/ )
		if want.escape then want.escape = want.escape * 0.6 end

--		if log_detail > 0 then print("[use_tactical AI] ### Final Wants (ai_tactic applied):") local tt = table.to_strings(want, "[%s]=%0.3f") table.sort(tt) print(table.concat(tt, ", ")) end
		if log_detail > 0 then print("[use_tactical AI] ### Final Wants (ai_tactic applied):\n\t", (string.fromTable(want, nil, nil, nil, nil, true))) end

		--== BUFF ==-- The value of buffs are reduced while fleeing
		local buff_escape_coefficient = 1
		if avail.buff then
			local offense = math.max(want.attack, want.attackarea, want.closein or 0)  -- includes ai_tactic adjustments
			if want.escape > offense then buff_escape_coefficient = math.min(1, offense/want.escape) end
		end
		local sel, best_score
		local action_pick, success
		local action_attempt = 0
		repeat -- final actions evaluation
			action_attempt = action_attempt + 1
			if log_detail > 0 then -- Tactical Summary
				print("[use_tactical AI] === Tactical Action Summary === attempt:", action_attempt, self.uid, self.name)
				print("  #:type:tid/ai name                          score  [xmLVL xmSPD  xmRNG] (tact=want*value, ...)")
			end
			local mult, lvl_adjust
			sel, best_score = 0, - math.huge
			for k, action in ipairs(actions) do
				action.speed = action.speed or 1
				local speed = action.speed
				if not action.score then -- compute the FINAL TACTICAL SCORE for the action
					local escape_val, closein_val
					action.score, action.high_value = 0, -math.huge
					-- Apply any player set ai_talents weights
					mult = self.ai_talents and action.tid and self.ai_talents[action.tid] or 1
					
					-- adjust for character or talent levels (could also adjust for general action weight here)
					if action.tid then -- talents adjust for talent level
						lvl_adjust = 1 + (action.lvl or 0)*self.AI_TACTICAL_TALENT_LEVEL_BONUS
					else -- AI's adjust for character level
						lvl_adjust = 1 + (action.lvl or self.level)*self.AI_TACTICAL_AI_ACTION_BONUS
					end

					local desc = ""
					-- compute the RAW TACTICAL SCORE from the resolved TACTIC WEIGHTs and WANT VALUEs
					for tact, val in pairs(action.tacts) do
						local mult = mult
						--== BUFF ==-- buffs are scaled (within the random range) to match the best attack
						-- the multiplier (want.buff) is calculated from the buff parameters for the BUFF TACTIC for each action
						if tact == "buff" and val ~= 0 then
							if aitarget then
								-- buff magnitude, adjusted for range (except sustains), fight duration and speed
								local buff_mag = math.abs(val)*buff_duration_factor*(action.mode == "sustained" and 1 or buff_range_factor^(1/speed))/speed

								-- scale within range 1/(1 + ai_weight_range), 1+ai_weight_range, 1@2
								local buff_factor = self:combatLimit(buff_mag^2, 1 + ai_weight_range, 1/(1 + ai_weight_range), 0, 1, 4)
				--[[				
								-- scale within range (0, 1+ai_weight_range)
								local buff_factor = (1 + ai_weight_range)*buff_mag/(buff_mag + 2*ai_weight_range) -- values vs buff_mag = 0@0, 1@2 (typical buff value with no adjustments, "equal" opponent, etc.), approaches 1+ai_weight_range as buff_mag increases above 2
				--]]
								if log_detail > 2 then print("\t=== buff parameters for talent", action.tid, "buff_mag=", buff_mag, "buff_factor=", buff_factor, "buff_best_attack_value=", buff_best_attack_value, "buff_range_factor=", buff_range_factor, "buff_duration_factor=", buff_duration_factor, "buff_escape_coefficient=", buff_escape_coefficient) end
								-- compute multiplier (in place of want.buff), factoring out lvl_adjust and speed effects (reapplied at end)
								mult = mult * buff_best_attack_value*buff_escape_coefficient/lvl_adjust/math.abs(val)*buff_factor*speed
							else
								mult = mult*want.buff -- default passive weight with no target
							end
						else
							mult = mult*(want[tact] or 0)
						end
						
						if log_detail > 0 then desc = desc .. ("%s=%+0.2f*%+0.2f,"):format(tact, mult, val) end -- summary of tactics

						val = val*mult
						if tact == "closein" then -- test for mutually exclusive tactics
							closein_val = val
						elseif tact == "escape" then
							escape_val = val
						end
						
						action.score = action.score + val
						if val > action.high_value then -- update main tactic
							action.high_value, action.main_tactic = val, tact
						end
					end
					
					action.desc = desc
					-- the closein and escape tactics are mutually exclusive, use only the best value
					if closein_val and escape_val then
						if action.is_active then -- negated tactical weights
							if closein_val < escape_val then action.score = action.score - escape_val else action.score = action.score - closein_val end
						else
							if closein_val > escape_val then action.score = action.score - escape_val else action.score = action.score - closein_val end
						end
					end
					-- make final adjustments to get the FINAL TACTICAL SCORE
					-- adjust for action speed (compared to global)
					action.score = action.score/speed
					
					-- apply a random bonus (to de-optimize and break ties)
					mult = rng.float(1, 1 + ai_weight_range)
					action.mult = mult
					action.lvl_adjust = lvl_adjust
					action.score = action.score*lvl_adjust*mult
					
				end
				if log_detail > 0 then print(("%3d: %-40s =%+6.2f[x%-5.2fx%5.2f x%0.2f] (%s)"):format(k, action.tid and " tid:"..action.tid or action.ai and "  ai:"..action.ai or "no action", action.score, action.lvl_adjust, 1/speed, action.mult, action.desc)) end
				-- update the best action
				if action.score > best_score then sel, best_score = k, action.score end
			end
			
			action_pick = actions[sel]

			--don't do anything without a useful choice or if the best action doesn't address a significant want
			--(eliminates choosing relatively useless actions due to scaling of TACTICAL SCOREs with level)
			if best_score > 0.1 and (action_pick.mode == "sustained" or math.abs(want[action_pick.main_tactic]) >= 0.1) then
				if log_detail > 1.5 then -- debugging sort and summarize available actions
					if action_attempt < 2 then
						table.sort(actions, function(a, b) return a.score > b.score end)
						print("[use_tactical AI] === Tactical Action Summary (SORTED) === attempt:", action_attempt, self.uid, self.name)
						print("  #:type:tid/ai name                          score  [xmLVL xmSPD  xmRNG] (tact=want*value, ...)")
						for k, action in ipairs(actions) do
						print(("%3d: %-40s =%+6.2f[x%-5.2fx%5.2f x%0.2f] (%s)"):format(k, action.tid and " tid:"..action.tid or action.ai and "  ai:"..action.ai or "no action", action.score, action.lvl_adjust, 1/action.speed, action.mult, action.desc))
						end
					end
					if config.settings.cheat then  -- debugging top 3 actions to combat log
						for k, l_action in ipairs(actions) do
							if k > 3 then break end
							game.log("#GREY#%3d: %-40s score=%-+4.2f[Lx%-5.2f Sx%5.2f Mx%0.2f] (%s)", k, l_action.tid and " tid:"..l_action.tid or l_action.ai and "  ai:"..l_action.ai or "no l_action", l_action.score, l_action.lvl_adjust, 1/l_action.speed, l_action.mult, l_action.desc)
						end
					end -- end debugging
				end
				if log_detail > 0 then
					print(("[use_tactical AI]### %s[%d] tactical AI picked action (%s)%s [att:%d, turn %s: {score:%-+4.2f [%s]}"):format(self.name, self.uid, action_pick.main_tactic, action_pick.ai and "ai:"..action_pick.ai or action_pick.tid and "tid:"..action_pick.tid, action_attempt, game.turn, action_pick.score, action_pick.desc))
					if log_detail > 1.4 and config.settings.cheat then game.log("%s__%s[%d] tactical AI picked action[att:%d, turn %s]: (%s)%s {%-+4.2f [%s]}", action_pick.tid and "#ORCHID#" or "#ROYAL_BLUE#", self.name, self.uid, action_attempt, game.turn, action_pick.main_tactic, action_pick.ai and "ai:"..action_pick.ai or action_pick.tid and "tid:"..action_pick.tid, action_pick.score, action_pick.desc) end -- debugging
				end
				
				--if log_detail > 0 then print("[use_tactical AI] pre action energy for", self.uid, self.name) table.print(self.energy, "_energy\t") end -- debugging

				self.ai_state.tactic = action_pick.main_tactic -- set tactic for talent/ai code to be called
				if action_pick.tid then -- use a talent
					print("[use_tactical AI] === Action Selected:", self.uid, self.name, action_pick.main_tactic, " talent:"..action_pick.tid)
					success = self:useTalent(action_pick.tid, nil, nil, nil, action_pick.force_target)
				elseif action_pick.ai then -- run an AI
					print("[use_tactical AI] === Action Selected:", self.uid, self.name, action_pick.main_tactic, " AI:"..action_pick.ai)
					success = self:runAI(action_pick.ai, unpack(action_pick))
				end

				--if log_detail > 0 then print("[use_tactical AI] post action energy for", self.uid, self.name) table.print(self.energy, "_energy\t") end-- debugging
				if success then
					if log_detail > 0 then
						print("[use_tactical AI] turn", game.turn, self.uid, self.name, "### SUCCESSFUL ACTION returned:", action_pick.tid or action_pick.ai, success)
if log_detail > 1.4 and config.settings.cheat then game.log("#GREY#__[%d]%s ACTION SUCCEEDED:  %s, tacs: %s, FT:%s", self.uid, self.name, action_pick.tid or action_pick.ai, action_pick.desc, action_pick.force_target and ("[force_target: %s[%d] @(%d, %d)]"):format(action_pick.force_target.name, action_pick.force_target.uid, action_pick.force_target.x, action_pick.force_target.y)) end-- debugging
					end

					-- update fight_data for the action taken
					fight_data.actions = fight_data.actions + 1
					if action_pick.is_attack then fight_data.attacks = fight_data.attacks + 1 end
					-- return talent used, ai invoked, main tactic fulfilled, action_pick table
					return action_pick.tid, action_pick.ai, action_pick.main_tactic, action_pick
				else
					action_pick.score = 0; self.ai_state.tactic = nil
					print("[use_tactical AI] turn", game.turn, self.uid, self.name, "### FAILED ACTION returned:", action_pick.tid or action_pick.ai, success)
if log_detail > 1.4 and config.settings.cheat then game.log("__[%d]%s #ORANGE# ACTION FAILED:  %s, FT:%s", self.uid, self.name, action_pick.tid or action_pick.ai, action_pick.force_target and ("[force_target: %s[%d] @(%d, %d)]"):format(action_pick.force_target.name, action_pick.force_target.uid, action_pick.force_target.x, action_pick.force_target.y)) end -- debugging
				end
			else -- no suitable action to take
				if log_detail > 0 then 
					print("[use_tactical AI] turn", game.turn, self.uid, self.name, "### NO ACTION Selected ###: best TACTICAL SCORE =", best_score, action_pick and action_pick.main_tactic, action_pick and want[action_pick.main_tactic])
if log_detail > 1.4 and config.settings.cheat then game.log("__[%d]%s #SLATE# tactical AI: NO ACTION, best: %s, %s", self.uid, self.name, action_pick.tid or action_pick.ai, action_pick.force_target and ("[force_target: %s[%d] @(%d, %d)]"):format(action_pick.force_target.name, action_pick.force_target.uid, action_pick.force_target.x, action_pick.force_target.y)) end-- debugging
					end
				return
			end
		until best_score < 0.1 or self.energy.used or action_attempt > 5 -- end final actions evaluation loop
	end
end)

--=== TACTICAL ENTRY POINT ===--
-- t_filter = optional filter applied to each talent considered
-- t_list = optional list of talent id's to consider (defaults to self.talents)
newAI("improved_tactical", function(self, t_filter, t_list)
	local log_detail = config.settings.log_detail_ai or 0
	local targeted = self:runAI(self.ai_state.ai_target or "target_simple")
	local ax, ay = self:aiSeeTargetPos(self.ai_target.actor)
	if log_detail > 0 then 
		print("[tactical AI] turn", game.turn, self.uid, self.name, "running improved_tactical AI with target", self.ai_target.actor and self.ai_target.actor.uid, self.ai_target.actor and self.ai_target.actor.name, t_filter, t_list)
		if log_detail > 1.4 and config.settings.cheat then game.log("%s__turn %d: Invoking improved tactical AI for [%s]%s(%d,%d) target:[%s]%s %s", targeted and "#LIGHT_BLUE#" or "#ROYAL_BLUE#", game.turn, self.uid, self.name, self.x, self.y, self.ai_target.actor and self.ai_target.actor.uid, self.ai_target.actor and self.ai_target.actor.name, self.ai_target.actor and ("STP(%s,%s)"):format(ax, ay) or "") end -- debugging
	end
	
	-- by default, will evaluate all talents each turn
	-- (usually don't need to set talent_in since movement is always evaluated)
	local talents = ((self.ai_state.no_talents and self.ai_state.no_talents ~= 0) or (targeted and not rng.chance(self.ai_state.talent_in or 1))) and {} or t_list -- One in "talent_in" chance of using a talent in combat
	if talents and log_detail > 0 then
		if log_detail > 0 then
			print("[tactical AI] TALENTS DISABLED")
			if log_detail > 1.4 and config.settings.cheat then game.log("#ROYAL_BLUE#---talents disabled---") end-- debugging
		end
	end
	
	self.ai_state._advanced_ai = true -- temporary variable enabling advanced handling of tactical tables
	self.ai_state._imp_tactical = true -- DEBUGGING TRANSITIONAL look for talent.tactical_imp fields
	-- run the tactical AI
	-- Mostly uses talents but can invoke other AI's as well
	-- Actions may maintain health and resources or perform movement
	local used_talent, used_ai, tactic, action = self:runAI("use_improved_tactical", t_filter, talents)
	
	self.ai_state._advanced_ai = false -- revert to normal handling of tactical tables
	self.ai_state._imp_tactical = false -- DEBUGGING TRANSITIONAL
	
	if log_detail > 2 then print("[tactical AI] use_improved_tactical AI returned:", used_talent, used_ai, tactic, action) end

	-- Note: an invoked AI should already have used energy as appropriate
	if used_talent then -- make sure NPC can take another action after instant talents
		if self.ai_state.last_tid ~= used_talent then --but protect against repeated talent failures
			self.energy.used = true
			self.ai_state.last_tid = used_talent
		end
	end
	-- set escape mode: determines whether to flee or approach target when moving
	if targeted then
		if self.ai_tactic.safe_range and self.ai_tactic.safe_range > core.fov.distance(self.x, self.y, ax, ay) and self:hasLOS(ax, ay) then -- too close to target
			self.ai_state.escape = true
		else self.ai_state.escape = tactic == "escape" -- use tactical AI's decision to flee or not
		end
	end
	if self.energy.used then return true -- action complete
	else -- perform maintenance or movement if nothing else was done
		-- these actions are normally managed by the tactical AI unless talent_in is set > 1
		local move_action
		-- perform maintenance if specified
		if self.ai_state.maintenance_in and rng.chance(self.ai_state.maintenance_in) then
			local done
			done, action = self:runAI(self.ai_state.ai_maintenance or "maintenance", t_filter, t_list)
			if log_detail >= 2 then print("[Actor AI] improved_tactical -> maintenance AI returned:", done, action) end
			if done then return done end
		end
		if self.ai_state.safe_grid then move_action = "move_safe_grid" -- continue seeking safe terrain
		elseif targeted then -- either flee or perform std. move
			move_action = self.ai_state.escape and "flee_dmap_keep_los" or self.ai_state.ai_move or "move_simple"
		end
	
		if log_detail >= 2 then print("[tactical AI] move_action check: used_talent=", used_talent, "used_ai=", used_ai, "tactic=", tactic, "action=", action, "safe_grid=", safe_grid, "escape flag:", self.ai_state.escape, "move_action=", move_action) end
		if move_action then return self:runAI(move_action) end -- perform the move action
	end
	return false -- nothing was done
end)
