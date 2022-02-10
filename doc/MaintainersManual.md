# Melee/Wizard Turn Sequence Tool - Maintenance Manual

<!-- <u>Turn phases</u>: -->
## Turn Phases

1. (Movement) Initiative
1. Spell Renewal
3. Movement
4. Actions
   1. Intent Declarations (adjDX, pole attacks, 2x bow shots)
   2. Pole Attacks
   3. Normal Actions
   4. Second Bow Shots
5. Forced Retreats

## Global Data Structures

'Global' data structures, which are relevant to more than a single turn
phase.  'Local' data structures which are only relevant to a single turn
phase are detailed under the description of that turn phase.

**`$initiative`**:

<u>value</u> | <u>meaning</u>
----- | -------
`c` | character-based
`PARTY` | party-based
`PLAYER` | player-based
`SIDE` | side-based

**`@characters`**: array of hashes:

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

**`%hkeys`**: 'header keys':  The above keys, with value 1 if they can appear
in a party file, else 0.

**`$qi`**: queue index, incremented when something added to queue

**`%queue`**: Movement or action queue.
<!-- Key is character index, 
(Is the queue needed for non-character-based movement initiative?) -->

    key =~ /[^\d]/ ==> name
    else char index
    API tag `APIq0`

value is `$qi`

**`$qfh`**: queue file handle, for writing to queue file


Store information which persists across turns in the characters' hash, and
information which is relevant for this turn only in an array (or hash) below.
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

## Movement
`@entities` which can move this turn.  May be character, player, party, or side
names, based upon `$initiative`.  Excludes 'dead' and surprised characters.

`&movement(@entities)` handles all movement.

### `&movement`
`@ent = @entities`

`@roll` = movement initiative roll for each entity, \in [0,1)

(Movement) initiative is displayed by `&displayCharacters` if using
character-based initiative and turn>0.  Else it is displayed separately
before `&displayCharacters`.

`@order` indices of `@ent`, sorted by `@roll`



## Utilities
In (case-insensitive) alphabetical order.

### `displayCharacters`
List all living characters along with their `NAMEKEY`.  The display is
sometimes in initiative order, see **Movement** above.

<!-- `@order` *character* indices, sorted by `@roll`.  Note that this is different
from `&movement`'s `@order`, which contains indices into `@ent`! -->

### Query User

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
