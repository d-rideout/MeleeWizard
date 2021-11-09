# Melee/Wizard Turn Sequence Tool - User Manual

Party file arguments are described in the [README.md](../README.md) file.

The "Overwrite log.bak file? (interrupt (Ctrl-C) if not!)" query is simply a
last chance to avoid clobbering the backup log file.  Press enter to
proceed.  To avoid clobbering the log file, interrupt the program by pressing
Ctrl-C (or however you abort the program on your system).

The code defaults to character-based initiative, rather than player-based or
side-based, as it suggests in the rules.  This will be substantially more
complicated, but also substantially more realistic?
Try to err on the side of hitting '0' unless there is some substantial reason not to, to make the movement phase a little less complicated.
If it is too complicated, change the `$initiative` setting at the top of `mewcosq` to `p` for party-based or `l` for pLayer-based initiative.


## Global commands
These commands can be used at any prompt (besides the initial 'Overwrite log.bak file?').

Command|Description
-------|-----------
`?` | list 'global' commands
`c <who> <DXmod>` | change `<who>`'s DX modifier due to new choice of action for this turn
`q` | quit game
`ud <n>` | undo `<n>` previous entries

The `c` command will presumably have no effect outside of the action sub-phase.


## Movement
Be sure you have everyone's permission in between if you defer movement until some entity!


## Action

Prefix any action with `sp<ST>` to spend <ST> ST on casting a spell.

Suffix any action with `\` to allow for a subsequent action for the same figure.

Command format|Action|Meaning
--------------|------|-------
`de [DX mod]` | defer action | wait for outcome of other actions before acting
`m` | miss | cancel wait-for-an-opening DX bonus
`a <who> <DXmod> <duration>` | adjust DX | modify `<who>`'s DX by `<DXmod>` through spell turn `<duration>`
|| use `inf` duration for a permanent change
... | ... | ...


## Abbreviations
The screen output is terse to preserve space, so that you do not have to keep scrolling backwards.  To maintain this we define some abbreviations:

Abbreviation | Meaning
------------ | -------
inj | DX adjustments due to injury
act | DX adjustments due to chosen action for this turn
spl | DX adjustments due to other figures' actions (such as spells)


## Experience Points
`mewcosq` keeps track of experience points during combat, using the TFT rules, with the following modifications:

* Each surviving character earns 1 pt per 6 minutes of wallclock time.  This is double the rate in the official TFT rules, to account for the lack of xp from nd rolls with n>3.
* We assume hitting a dogding or defending character does not earn any extra experience points.
<!-- * If a character is rendered unconscious, and there are no conscious
  characters remaining on the same side, that character's remaining xp value
  is distributed evenly among the survivors from the other sides.  Note that
  unconscious characters are regarded as survivors.
  This obviates a potential morose slitting throats ritual at the end of every battle.  Is it really worth xp to slit a throat?  I think not.  -->

---
# Melee/Wizard Turn Sequence Tool - Maintenance Manual

## Data Structures

`@characters` array of hashes:

<u>key</u> | <u>value</u>
----------- | -------------
`NAME` | name of character
`ST` | strength of character
`STrem` | strength remaining
`DX` | base DX of character
`adjDX` | 'core' adjusted DX (e.g. after armor and shield deductions)
`PLAYER` | who plays this character (created beings are played by the character which created them!)
`PARTY` | In which party is this character?
`STUN` | How must ST damage in one turn will stun this character?
`FALL` | How must ST damage in one turn will cause this character to fall?
`StunTurn` | character is stunned *until* this turn
`DEAD` | true ==> character is dead or unconscious
`NAMEKEY` | Any extension of this string will refer to this character.
`BAD` | STrem has been brought to <=3 by injuries
`ROPE` | turn Rope spell cast on character (assuming noone will have multiple Ropes!)
`ADJ` | array of pairs DXmod, last turn of mod
`WAIT` | wait for an opening bonus
`CREATOR` | character index of creator

`%hkeys` 'header keys':  The above keys, with value 1 if they can appear in a party file.

Store information which persists across turns in the characters' hash, and
information which is relevant for this turn only in an array (or hash).
(Information in the character hash will take longer to access.)
All arrays below are indexed by character index.

<u>array</u> | <u>values</u>
----- | ------
`@turn_damage` | amt damage sustained this turn for each character
`@acted` | who acted so far this turn, -1 ==> deferred action
`%retreats` | possible forced retreats:  key forcer val hash key forced (value not used)
`@dxact` |  amt to add to adjDX for this turn due to chosen action
`@dxspl` | amt to add to adjDX for this turn due to others' actions
`@dxinj` | amt to add to adjDX due to injury
`@roll` | action initiative roll
`@distMoved` | how far each character moved during the movement phase

### adjDX Order
* `@dxact` modifiers to DX due to choice of action *this turn*
* `@dxspl` modifiers to DX due to others' actions
* `@dxinj` DX modifiers due to injury.  Compute at beginning of &act.
* All must be maintained.

DX = adjDX + @dxact + @dxspl + @dxinj

## Query User

To query the user, use the following code template:

```perl
while (my $response = query(<default>, <query string>)) {
  next if problem, e.g.
  my @args = split / +/, $response;
  my $whoi = who($args[3]);
  next if $whoi eq 'x';
  next if another problem;
  last if success;
  catch leak in logic above?;
}
```
Is this too complicated?  It allows great flexibility in the interpretation of the response.  e.g. ignoring spaces and the like.


<!--
I think it also makes sense to change the &act API to take an array which is true if that char is acting.  So the array index is the char index.
No, I decided to do it the old way.  Note that it is often called with a single character, for pole and second bow attacks. (6sep021) -->


<!-- #### old scheme:
`@dex` is adjDX of each character, computed after Considerations
takes into account reactions to injury
[deprecate I think]

`@dexadj` is dex adjustment declared in 'Special considerations'.

@dex = adjDX + @dexadj - reactions to injury

`%dexes` list of characters of each dex

`$dex` is the current max dex

`$ties` is the list of people with this dex

`@dex_ties` is `$ties` sorted by `@roll`

`$newdex` is new dex after new injuries

#### new scheme: -->
