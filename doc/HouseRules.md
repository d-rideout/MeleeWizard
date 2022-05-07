<!-- ## Some Background on The Fantasy Trip (TFT) -->

# House Rules

TFT is a fantasy role playing game which was published in various forms by
Metagaming from 1977 to 1983.  Metagaming was a company founded by Howard
Thompson in Austin, Texas, circa 1975, which specialized in 'microgames':
games which are physically small enough to fit in a pocket and inexpensive
enough to be affordable by children.

I have *Melee "Micro Game 3"*, published in 1979, *Advanced Melee*, published
in 1982, *Wizard* Fourth Edition published in 1981, and *Advanced Wizard*
published in 1980.  I have seen a *Melee* booklet with different cover art --
perhaps that is a newer version, since mine does not mention multiple
editions?
<!--I will refer to the original version as 'Basic', and the newer version as
'Advanced' (and similarly for the original and Advanced versions of
Wizard).-->

There are occasional gaps, ambiguities, and discrepancies in these published
rules.  This document presents some discussion and 'house rules' which
attempt to address some of these issues.  I am very interested in others'
opinions on these issues, so please comment, in the Discussions tab, as an Issue ticket, or otherwise.  Usually one imagines that
'fun', in the context of games, is a purely subjective thing which cannot be understood, but the continuing
popularity of this relatively ancient game suggests that there are some deep
principles to learn here.

* Minimum attack damage is zero.
* Advanced rules generally take precedence over the original when they differ.
* The rules describe player-based initiative.  We also allow party- and character- based initiative.  I think character-based is most realistic and most interesting tactically, though a bit more complicated to execute.
(Occasionally rules ask for modifiers of initiative rolls.  These rules can be converted to modifiers on our [0,1) initiative 'rolls', however it is not as simple as adding or subtracting multiples of 1/6 to [0,1) 'rolls', in part due to conditioning on the two die rolls being unequal.  I am happy to work this out and implement it as the need arises.)
* 'Roll out' damage multipliers.  So a double damage dagger attack does 2-2 damage.  This reduces the probability of a hit doing zero damage, which I always find frustrating.
* ST cost of spells can cause unconsciousness but no DX penalties:
  - Spell cost does not contribute to being stunned.
  - A wizard reduced to 4 ST by casting spells, which then suffers 1 hit of damage, will be at -3 DX.
  - A wizard reduced to 4 ST from damage, which then casts a spell of cost 1, will suffer no DX penalty.
* An Aid spell can temporarily remove the -3 DX penalty due to ST <= 3, but the penalty returns when the Aid spell wears off.
* Dead figures cannot be forced to retreat.
* Rope spell causes -2 DX on the turn it is cast, and -3 DX on the next turn.
* Wait-for-an-opening only affects first of double bow shot.
<!-- * Note: An engaged figure cannot reload a missle weapon.  Thus an engaged figure cannot get a second bow attack. -->
<!-- * If a character is rendered unconscious, and there are no conscious
  characters remaining on the same side, then that character's remaining xp
  value is distributed evenly among the survivors from the other sides.  Note
  that unconscious characters are regarded as survivors.  This obviates a
  throat slitting ritual at the end of battles.  (GMs: If characters keep
  unconscious enemies alive after the battle just to kill them later to get
  more xp out of them, then disallow all such throat-slitting-or-not xp.) -->
* Any character wishing to use talent rules some day (including wizards) must choose three talents or languages to be studying using the following schedule:
  - One during character generation (i.e. before playing with character)
  - One after first gaming session (i.e. before start of second session)
  - One after second session (i.e. before third)
  This allows the character to choose talents and languages which may be relevant to the campaign, which is reasonable knowledge which the character will probably have from its experience before character generation.
* A character who must forget talents or languages due to a permanent loss of IQ may bump a talent or language from one of its three 'learning slots', and replace it with the forgotten talent or language.
* Turn is 5 seconds.  (This is stated in AM pg 2.  ITL implies 10 seconds on pg 66.  (5 seconds is already a ridiculously long time to run 10 hexes = 13 meters))

* A side which has at least one conscious figure still on the battlefield
  wins.  Surviving characters on sides which win a battle and remain on the
  battlefield evenly split the full xp value of unconscious foes, and 1/3 xp
  value for non-winners which flee.  (Because I am really unconfortable with the
  'slit throats for xp' and 'chase down foes for xp' motivations.)

These are the '**standard**' house rules.  It will be convenient to allow variants, to facilitate play testing them.  I will present the **named variants in boldface**, so that the choice of rules for a particular game can be easily described using these named variants.

## Disengagement:
A higher adjDX fighter can 'leave stranded' a lower adjDX fighter by
disengaging, and thereby avoid ever being attacked by them.  Is this
intended?  Should we allow such a 'stranded fighter' to also move one hex by
'disengaging' (possibly from nothing)?
<!-- I will follow the rules as stated in
this regard, though it seems to give an enormous advantage to the higher
adjDX fighter. -->

Though note that, according to (original) *Wizard* (p19), a figure can attack
a disengaging figure even if the figure has equal or lower adjDX!  It just subtracts
the difference in adjDX from its adjDX (or adds it to its to-hit roll).
Though Advanced Melee gives the usual account.
As does the sample battle at the very end of *Wizard*!!

So let's define an optional rule, called **weak disengagement**.  A figure A
can attack another B which has already disengaged, however A adds adjDX_B -
adjDX_A + 1 to its to-hit roll.  Note that this makes critical hits less
likely, however critical misses retain their usual probabilities based on the
unadjusted die roll.  (I added an additional +1 modifier to the to-hit roll, to
make the option slightly closer to the *standard* variant.  So the 'action initiative' roll also matters when using **weak disengagement**.)

## Hand-To-Hand (HTH) Combat:
I find the description of the HTH rules confusing, and the original and
Advanced rules appear to differ somewhat.  The original rules seem to regard
engaging in HTH combat as an *action* for engaged figures (M p8), while it is not so clear for disenagaged figures.
The Advanced rules
seem to describe engaging in HTH as a *movement*.
I think that the original
rules lead to a better game: allowing engaging in HTH as a movement is simply
too powerful -- it allows a higher MA character to almost completely trump
any non-ranged attack, by simply engaging the attacking figure in HTH combat
before they get a chance to act.  ([Musings from
Myriangia](https://myriangia.wordpress.com/2020/10/07/getting-a-grip-in-hand-to-hand-combat/)
has a nice page on this, which includes further rules on grappling.  For the
moment I am just trying to get a handle on the 'pure' Melee/Wizard rules.)
However, item 91 of *Death Test 2* makes it pretty clear that the intent is
for HTH engagement to happen during *movement*, as it discusses differences
between initiative rolls, which would make no sense if HTH engagement were an
action.

Thus, with some trepidation, I will regard the following HTH rules as standard, which I will also call **HTH-as-move**:

The attacker moves onto the enemy figure *during the movement phase* (using option IIe: a disengaged figure may move up to half its MA, while an engaged figure can only shift onto the opponent), and the outcome of the attempt is resolved then.  <!-- I *presume* that an attacking figure may pass through the front hex of the enemy figure during this movement?  What if another figure is facing that hex?  Can it still pass through it, or are only the front hexes of the attacked enemy figure 'canceled' by the HTH attack? -->
Note that, unless it is already engaged with the target, the attacking figure must enter the target's hex from the side or rear, as otherwise it will become engaged and must stop when it enters a front hex of the target (subject to questions about what exactly causes engagement, below).
(I find the absence of this remark in the official, published rules confusing, since it seems to follow from the rules as stated, if we interpret HTH engagement as a movement.)
The attacking figure *also* gets an action during the action phase, e.g. to attack, or disengage!

**HTH-as-action** is an alternate rule:

To engage in HTH combat, the attacking figure moves as with any other attack move: up to 1/2 MA if disengaged or shift 0-1 hexes if engaged.  
During the action phase, it moves a *further* hex, on to the target figure, and rolls the outcome as described in the rules.

There are two obvious further variants: We could allow *both* **HTH-as-move** and **HTH-as-action**, or neither.  I tended to play with the latter in my youth, since the rules were confusing.  But maybe the former is the best option??
<!--, e.g. because it better handles entering from a front hex.-->

Additional HTH rules:
* figure gets +4 DX on attempt to disengage! (according to Codex!)
  (Though this seems really strange!  Why bother make it 4 dice then?  It is even easier than a 3 die save vs DX!)
  I am going to ignore this at the moment.  Disengaging from HTH should be difficult.
* Figures in HTH can draw a dagger with 3d6 vs adjDX, without +4 rear bonus. (bottom p3AM)

Do figures attempting to draw a dagger in HTH get +4 DX?  I am going to assume no.

### Pinning a Foe:
The Pinning a Foe rules in Advanced Melee seem grossly unrealistic, since
they have almost no regard for ST.  (Some other website pointed this out but I
can't find the reference right now.)
And they are slightly ambiguous: I
assume the success roll is against the attacker's adjDX, as with an ordinary
attack.  A ST 4 adjDX 14 goblin can pin a ST 30 adjDX 11 bear with a roll of
14+3/2=15 or less on 3 dice, and hold it immobile for two entire turns!
Let's also add a ST difference modifier to the success roll, so the goblin's
success roll is now 14 + 3/2 - 26/2 = 2 or less on 3 dice.  That seems much
more reasonable.

### Further clarifications on HTH combat:

The Codex decrees that figures get +4 DX on attempts to disengage from HTH.
This seems pretty excessive -- surely it should be difficult!  But I am going
to allow it anyway.  Note that such an attempt is with 4 dice, so it is only
*slightly* easier than a plain 3-dice roll against adjDX.  More importantly,
it allows attempts to disengage happen 'at the same time' as attacks (which
are also at +4 DX).

Note that, when HTH is initiated, it causes two figures to fall.  If one of
them disengages, then the other is no longer in HTH combat, and must wait
until the next turn to stand up.  This is hard on the attacker, but I think
balances against so much that they have done this turn already.  Imagine that
the disengaging figure pushes the attacker while disengaging, thus delaying
its standing.

It would be cool to allow grabbing a fallen weapon or shield on the way up,
maybe as a 5-die DX maneuver?

Getting shoved underfoot by a huge creature is a little different than the
above -- if the defender manages to roll out (and therefore stand!) in the
same turn, then it can keep hold of its weapon and shield.  This is how I
read the rules.  Though this should probably require a die roll of some sort.
3-dice against DX?

### Questions re HTH:
* Does a failed HTH attempt consume an action?  Presumably not!
* Does a figure which falls under a multi-hex figure drop its weapon and shield?
  I don't see this explicitly stated, so I assume not.

## 'Melee' rules for wizards:

The rules for wizards using weapons and armor are not clear.  They are
probably intended to take into account the reality that your wizard will
likely not have any weapon or shield talents, so will be at -4 DX when
using such items?  
<!-- They can almost all be regarded as questions... -->

### Quotes & Questions
There are many ambiguous statements in the rules.  Here we quote some rules
and muse on what they might mean.
A main source of confusion stems from the apparent conflation of iron weapons with all
weapons, and likewise with armor.  And the dagger rules for wizards are not consistent, even within the Wizard booklet itself!

Below (and above) 'W' indicates that the quotation comes from Wizard, 'AM' from Advanced Melee, 'C' from the Fantasy Masters' Codex 1981, 'AW' Advanced Wizard.

* W: "Wizard whose weapon or armor is iron or steel, instead of silver .. -4 [DX]"
* W: "wizard ... DX is -4 with ANY weapon except his staff."
  - The codex seems to add dagger as permissible as well, as does the DX adjustments table in Wizard.
* W: "Wizards may wear armor and use shields, just like fighters."
* AM: "[silver] equipment is necessary for wizards who wish to fight without an extra DX-"
* AM&C: "If a weapon has ANY metal parts, they must be of silver for a wizard to use that weapon without injuring his magical abilities."
* C: "Q: WIZARD states that wizards are -4DX for all weapons except staff & dagger."
* C: "IRON/SILVER rules replace WIZARD's rules"
* AW pg 7 has an entire section entitled "IRON, SILVER, AND MAGIC"
  - Iron (and some other metals) prevents spells ==> -4 DX for casting
  - Does armor give an additional DX penalty for casting spells, as it would for
    everything else?  I am going to rule yes.
* AW: "iron armor is no protection against hostile magic"
  - I assume that the 'no' is a misprint?

### Rules
<!--We play with the following house rules, though these will likely change:-->
Below is my best guess as to the intended rules.

* Wizards get -4 DX when using weapons besides staff or dagger, and when using a shield.
* What about a club or torch??  Can wizards use clubs without penalty?  Presumably yes??
* A wizard in HTH gets -4 DX for spell casting, and can only cast spells on figures in the wizard's hex.
* A wizard in HTH is at -4 DX for drawing a dagger.
* A wizard wielding a dagger in HTH is presumably at +4 DX, because s/he is attacking a rear hex.
* Wizard cannot cast spell with weapon or shield besides staff ready.
* Anyone can use a dagger (in hand, no throwing) without non-talent or wizard penalty (C)
* The armor DX penalty for wizards is independent of necessity of using gestures in spells. (C)
* (ST<18) wizard in leather (cloth) armor: usual -2 (-1) DX on spells and attacks
* wizard in iron armor: -(4 + usual penalty) DX on spells and (non-staff/dagger) attacks
* wizard in iron armor: -(usual penalty) DX on staff/dagger attacks
* wizard in silver armor: -(usual penalty) DX on spells and (non-staff/dagger) attacks
* wizard carrying iron (e.g. as weapon) -4 DX on spells
* wizard wielding shield -4 DX
* wizard wielding weapon besides staff or non-silver dagger -4 DX
(so -8 DX for weapon and shield -- that seems to be what ITL pg 12 says)
<!-- * wizard wielding shield and non-(staff/silver dagger) -4 DX (i.e. the penalty is not doubled) -->

Is that a reasonable interpretation of the rules as stated?

#### How to handle heros casting spells??
* Can they cast when wielding a weapon or shield?  I assume not?
* Do heros get the additional -4 DX penalty for casting spells in iron armor?  I assume yes.
* Do heros get -4 DX on spells when carrying iron?  I assume yes.

<!-- #### Questions:
* Is a wizard at +4 DX when wielding a dagger in HTH?  Presumably so. -->


## Spell turn counting

Turn counting for spells is not terribly clear.  We will thus use the following convention:

The turn that a spell is cast is spell turn 0, for spell effects which are
time dependent.  Thus the strength cost for a summoning spell is

base_cost + spell_turn * rate

<!-- The adjDX penalty from being Roped is -min(2, 1+spell_turn). -->

An Aid spell has no effect on spell turn 3.

<!--We may wish to allow an optional **strong Rope** rule,-->
I believe the published rules intend an adjDX penalty of
-(2+spell_turn) for the Rope spell, as clarified above.

All spells have no effect on spell turn 13, unless they are renewed.


## Clarifications from *Questions* section of *the Fantasy Masters' Codex 1981*:
Any figure who falls down, for any reason, before their action for that turn, loses
that action.  They have to wait until next turn to stand up.

This rule seems to be contradicted by the trampling rules in Advanced Melee,
which makes me strongly question its validity.  I may rule that only a fall
due to injury has this property.  Or perhaps 'complete' falls, while
trampling foes by huge figure is not quite a proper fall?  While stumbling on
loose ground is a complete fall?

In fact I am starting to question the Codex in general.  It make a number of strange proclamations.

<!--
## Who is an enemy figure?

The engagement rules assume that it is clear how to determine if a given
figure is an enemy or not.  However, what if it is not clear?  Who is my
enemy?  We adopt the following approach, suggested by Scott Rideout:

During movement, there is a *mover*, who may wish to move through the front
hexes of a standing figure (a *stander*).  It is up to the *stander* to
enforce engagement: if a figure moves into its front hexes, the stander can
declare itself an enemy of the mover, and thereby halt the mover's movement
at the moment of declaration (subject to the usual engagement rules for
multi-hex figures).

If the mover ever leaves a front hex of the stander

in a manner which would
be disallowed were the mover engaged with the stander, then the stander may
take a free rear hex attack on the mover if it wishes.
-->




<!-- assuming of course that the stander is at least 1/3 of
the size of the mover in hexes). -->




Questions:
---------
I have not decided how to handle these issues.  Please comment on them!  

1. If a figure has multiple weapons ready, and another rolls a 6 when engaging
  it in HTH combat, does the attacking figure get hit with all ready weapons,
  or just one of the defender's choice? (18sep021)
  
2. Advanced Melee states that only armed opponents cause engagement, while (`plain') Melee make no such stipulation.  Surely a bear is armed with its claws.  So why is a human not armed with its fists?  Does a shield count as a weapon for this purpose?
   * Also: A fighter with only a bow ready causes engagement, no?  Even a fighter with an unloaded heavy crossbow.  But such a fighter has no usable weapon ready.
   * Proposal?: A 'non-armed opponent' is one with no (usable?) weapon ready, where a 'weapon' is something which can cause damage that turn.  An enemy figure which enters one of the non-armed opponent's front hexes must make a save vs. adjDX _or_ remaining ST, whichever is higher, to avoid becoming engaged.

   I am leaning toward the original rules here, for simplicity.

3. If a figure falls due to becomming under a larger figure during the
movement phase, then the trampling rules seem to indicate that it can stand
during its action phase, in contradiction to the falling rule as stated in
the Codex.  What is the resolution to this?
   * I am going to side with the trampling rules in this case.

5. To what extent should one follow the falling rules in the Codex?  Perhaps
unless the rules suggest otherwise?  What about when tripping over a fallen
figure?

6. Does a double-bow-shot figure get two shots off in the turn it becomes engaged?  Like Legolas?  It should depend on how much movement led up to the engagement...
   * Maybe Legolas-like bowmen is more fun?

7. Do most all wizards have to spend one spell slot to learn literacy talent?

8. Surely it makes no sense for characters to gain xp from 4-die rolls during combat.  I am excluding these.  Too much trouble to keep track.

9. TFT seems to neglect the weight of coins.  A coin is about 25g.  I may use 20g since it is more composite so arithmetic is easier?
So 100 weigh 2.0 kg.  Not negligible!

10. The official rules indicate that damage multipliers multiply, so rolling a 4 to-hit for a charging pole arm attack does 4x damage!  This seems excessive.  Shall multipliers add?  This seems more reasonable in a mathematical sense.  So each double damage effect increments the damage multiplier by 1, and triple damage by 2.  (Example: A charging pike ax attack rolls 3 to-hit for triple damage.  Under the official rules this does 6x damage, i.e. 12+12, while under the proposed rule it would 'only' do 4x damage 8+8. (8x3.5+8 = 36, 12x3.5+12 = 54))
<!--, as one might expect mathematically?  (One can think of the damage multiplier as incremeting the exponent -->

## Deviations from Official Rules:
For the most part I want to stick as close as possible to the published
rules, at least in the beginning.  Later we can discuss deviations from these
rules.

### Time rate of XP accrual
<!--Besides some minor tweaks mentioned above, the only deviation from the
official rules will be in the xp value of wallclock time.-->

The official TFT
rules grant 1 xp per 12 minutes of wallclock time.  It also grants 5(n-2) xp for
'making n die rolls', with n>3, and also for playing in character.  When one
is not playing with the full TFT rules (e.g. with talents), there are very
few n die rolls, with n>3.  Also in certain situations it can be difficult to
'play in character', e.g. in a pure combat scenario.
<!-- (Does hitting a dodging foe count for extra xp??  The rules do say *any* roll,
so I suppose so!  10 bonus xp per such successful roll!) -->
(In fact these rules seem a little silly -- n=4 rolls to hit dodging opponents should not be worth bonus xp.  But n=3 rolls to use a talent/skill should be worth xp, especially if it is done in a dangerous setting!  So I may disallow mundane combat n=4 die rolls, but allow exciting n=3 die rolls.  (n=2 rolls are worth 0 xp anyway.))


I thus offer two alternate rates of xp accrual: 1 xp / 10 min, and 1 xp / 6
min.  The `mewcosq` tool will use the former of these for the moment.  (In a
real extended campaign, which has play time outside of battles, you should
not use the 'time xp' awarded by `mewcosq` anyway -- keep track of the
wallclock time separately.)

### Sprinting
Turning around is expensive, and not recommended when fleeing a deadly foe.  I am going to rule that any figure can eek out an additional hex of MA in exchange for facing in the direction of the last hex of movement at the end of its movement.  (Do other games have something like this, for running figures?)

---


Broken weapons:
--------------
Broken sword or club does half damage round down.  Twice broken is useless.

Forced retreats:
---------------
If a forced retreat figure has no adjacent unoccupied hex to retreat to, it
must roll against adjDX to remain standing! (Wizard)


---
Rules from Other Houses:
-----------------------
There are lots of great suggestions for modifications to the official rules
to address various concerns, some of which I raise above.  Though I am going
to try to stick 'as close as possible' to the original rules for now.

* [meleewizards.com](http://meleewizards.com/rules.html)
has some interesting suggestions re rules:
    - ~ last fire missile weapons count as charge attacks in terms of timing.  Seems sorta reasonable.
    - pole weapon charges only do an extra die damage

* https://tft.brainiac.com/RicksTFT/Fighting/HTH_InTFT.html

  He makes the point that the official rules really do seem to indicate engaging in HTH is a movement.  But that it led to the abuse I was concerned with:
  engaging in HTH to get any figure disarmed and onto the ground, and then immediately disengaging!


<!--### Alternate HTH rules:
It is worth play testing the Advanced rules, say with the front hexes of the attacked-enemy-figure-only option below:-->

<!-- 3. See the questions about front hexes of enemy figures during an HTH attack above.  To what extent is an HTH attack allowed to pass through the front hexes of enemy figures during an HTH attack from a disengaged figure?  I suppose that only attacked figures' front hexes are 'cancelled' during this movement, so that if another enemy faces a hex then the attacking figure must end its movement there, and wait until next turn to engage in HTH combat?
> This issue is obviated by reverting to the original rules for HTH combat.

What if we do not modify the movement through front hexes rules for HTH engagement?  Then, for a disengaged figure to enter HTH combat during the movement phase, it would have to enter via a side or rear hex (depending on difference between MA's of course).  This would make the details of character placement even more high stake than usual, as you may have to keep track of all ways in which an enemy figure can enter your hex via the side or rear, if you don't want to end up disarmed and on the floor *during the movement phase*!

I feel uncomfortable with rules which place so much emphasis on the completely arbitrary initiative roll.  But maybe this 'variance in outcomes' is a desirable feature?  So that the underdog can have a fighting chance?  Perhaps one wants such variability and complication for a one off battle, but not for an extended adventure? -->
