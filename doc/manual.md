# Melee/Wizard Turn Sequence Tool - User & Maintenance Manual

## User Manual

Party file arguments are described in the [README.md](../README.md) file.

The "Overwrite log.bak file? (interrupt (Ctrl-C) if not!)" query is simply a
last chance to avoid clobbering the backup log file.  Press enter to
proceed.  To avoid clobbering the log file, interrupt the program by pressing
Ctrl-C (or however you abort the program on your system).

The code defaults to character-based initiative, rather than player-based or
side-based, as it suggests in the rules.  This will be substantially more
complicated, but also substantially more realistic?
Try to err on the side of hitting 'm' unless there is some substantial reason not to, to make the movement phase a little less complicated.
If it is too complicated for you, change the `$initiative` setting at the top of `mewcosq` to `p` for party-based or `l` for pLayer-based initiative.

### Commands
command|description
-------|-----------
ud <n> | undo <n> previous entries
? | list 'global' commands (valid at every prompt\*)
... | all are documented briefly in the program output

\* except the first 'Overwrite log file?' prompt.


## Maintenance Manual

### Data Structures

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
`StunTurn` | character is stunned until this turn
`DEAD` | true ==> character is dead or unconscious
`NAMEKEY` | Any extension of this string will refer to this character.
`BAD` | STrem has been brought to <=3 by injuries
`ROPE` | turn Rope spell cast on character (assuming noone will have multiple Ropes!)
`ADJ` | array of pairs DXmod, last turn of mod

`%hkeys` 'header keys':  The above keys, with value 1 if they can appear in a party file.

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

### adjDX Order

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
* `@dxmod` misc modifiers to DX
* `@dxinj` DX modifiers due to injury.  Compute at beginning of &act.
* Both must be maintained.

DX = adjDX + @dxmod + @dxinj

<!--
I think it also makes sense to change the &act API to take an array which is true if that char is acting.  So the array index is the char index.
No, I decided to do it the old way.  Note that it is often called with a single character, for pole and second bow attacks. (6sep021) -->