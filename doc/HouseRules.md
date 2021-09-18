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

Disengagement:
-------------
According to (original) Wizard (p19) a figure can attack a disengaging figure
even if it has equal or lower adjDX!  It just subtracts the difference in
adjDX from its adjDX.  (or adds it to his roll)

Though Advanced Melee gives the usual account.
As does the sample battle at the very end of Wizard!!

So I guess allow this as an optional rule.  Let's subtract an extra point from DX, and downgrade all automatic hits etc by 1, to make the game a little more stable.  But let's avoid this option for now. (25aug021)

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
And so yes I guess they can use non-metalic weapons, without any DX nor spell penalty.  Though no one ever does.  So maybe there is some talent issue which prevents it?  A strong wizard would rather use a club than a staff.  Oh, s/he can't cast spells when wielding such a weapon.  That is a reason.  But a wizard without manna will not be casting spells anyway.
Using non-metalic weapons contradicts the first rule from Wizard, but maybe that was just a simplified rule?  Though it seems kinda wrong somehow, since no example never appears of wizards with clubs, slings, nor bows...  Again, the talents will probably clarify this. (4sep021)

Broken weapons:
--------------
Broken sword or club does half damage round down.  Twice broken is useless.

Forced retreats:
---------------
If a forced retreat figure has no adjacent unoccupied hex to retreat to, it
must roll against adjDX to remain standing! (Wizard)

HTH:
---
Wizard in HTH gets -4 DX for spell casting
Wizard at -4 DX for drawing dagger
See ../art/urls for an interesting approach:
https://tft.brainiac.com/RicksTFT/Fighting/HTH_InTFT.html
He makes the point that the official rules really do seem to indicate engaging in HTH is a movement.  But that it led to the abuse I was concerned with:
engaging and then immediately disengaging!

Death Test 2 seems to imagine HTH happening during movement!  Hmm...!
There are modifiers to the initiative roll.  So it is not completely
arbitrary.  That is probably why they seem to imagine that it matters so much
in Death Test!
Also why the gargoyle is supposed to be so deadly!

Questions:
---------
* How are turns counted for the Rope spell?  Is the turn the spell is cast
  the 1st or the 0th turn?  I am presumming the former, making the spell a
  little more powerful. (10sep021)
* Wizard has a strange rule about attacking figures who disengaged, which
  even its own sample combat does not use!  What to make of it?  It weakens
  disengagement a bit, which may be a good thing.  Otherwise high DX figures
  can just dance around lower DX figures... (10sep021)

---
Rules from Other Houses:
-----------------------
[meleewizards.com](http://meleewizards.com/rules.html)
has some interesting suggestions re rules:
* ~ last fire missle weapons count as charge attacks in terms of timing.  Seems sorta reasonable.
* pole weapon charges only do an extra die damage
Though I am going to try to stick 'as close as possible' to the original rules for starters.
