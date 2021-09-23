# House Rules

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
opinions on these issues, so please comment.  (Usually one imagines that
'fun', in the context of games, is a purely subjective thing, but the continuing
popularity of this relatively ancient game suggests that there are some deep
principles to learn here.)

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

These are the '**standard**' house rules.  It will be convenient to allow variants, to facilitate play testing them.  I will present the **named variants in boldface**, so that the choice of rules for a particular game can be easily described using these named variants.

Disengagement:
-------------
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

Hand-To-Hand (HTH) Combat:
-------------------------
I find the description of the HTH rules confusing, and the original and Advanced rules appear to differ slightly.  In short, the original rules seem to describe engaging in HTH combat as an *action*, while the Advanced rules seem to describe it as a *movement*.  <!-- Although we generally adopt the Advanced rules where they differ, in this case -->
I think that the original rules lead to a better game: allowing engaging in HTH as a movement is simply too powerful -- it allows a higher MA character to almost completely trump any non-ranged attack, by simply engaging the attacking figure in HTH combat before they get a chance to act.  ([Musings from Myriangia](https://myriangia.wordpress.com/2020/10/07/getting-a-grip-in-hand-to-hand-combat/) has a nice page on this, which includes further rules on grappling.  For the moment I am just trying to get a handle on the 'pure' Melee/Wizard rules.)
However, item 91 of *Death Test 2* makes it pretty clear that the intent is for HTH engagement to happen during *movement*, as it discusses differences between initiative rolls, which would make no sense if HTH engagement were an action.

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

### Rules from *Wizard*:
* A wizard in HTH gets -4 DX for spell casting.
* A wizard in HTH is at -4 DX for drawing a dagger.

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

---

Wizard weapons & armor:
----------------------
Wizard says wizards get -4 DX with weapon or armor besides staff and dagger,
unless it is silver.
Is it cumulative?  Is a wizard with a metal weapon and shield at -8 DX?  I am going to guess not. (25aug021)
Wizard cannot cast spell with weapon besides staff ready.
Wizard cannot cast spell with shield ready.
Apparently non-metal weapons and armor are okay for wizard?  The statement in
Advanced Melee is not so clear.
It *seems* like also all metal must be silver for wizards, so that they can cast spells?
What about armor?
I am guessing that they can't cast spells if they have ferrous metal on them anywhere.  And they are at -4 DX if they wield anything with ferrous metal.
And so yes I guess they can use non-metallic weapons, without any DX nor spell penalty.  Though no one ever does.  So maybe there is some talent issue which prevents it?  A strong wizard would rather use a club than a staff.  Oh, s/he can't cast spells when wielding such a weapon.  That is a reason.  But a wizard without manna will not be casting spells anyway.
Using non-metallic weapons contradicts the first rule from Wizard, but maybe that was just a simplified rule?  Though it seems kinda wrong somehow, since no example never appears of wizards with clubs, slings, nor bows...  Again, the talents will probably clarify this. (4sep021)

Broken weapons:
--------------
Broken sword or club does half damage round down.  Twice broken is useless.

Forced retreats:
---------------
If a forced retreat figure has no adjacent unoccupied hex to retreat to, it
must roll against adjDX to remain standing! (Wizard)

Questions:
---------
* How are turns counted for the Rope spell?  Is the turn the spell is cast
  the 1st or the 0th turn?  I am presuming the former, making the spell a
  little more powerful. (10sep021)
* Wizard has a strange rule about attacking figures who disengaged, which
  even its own sample combat does not use!  What to make of it?  It weakens
  disengagement a bit, which may be a good thing.  Otherwise high DX figures
  can just dance around lower DX figures... (10sep021)
* If a figure has multiple weapons ready, and another rolls a 6 when engaging it in HTH combat, does the attacking figure get hit with all ready weapons, or just one of the defender's choice? (18sep021)

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
