# Melee/Wizard Turn Sequence Tool - User & Maintenance Manual

## User

filename is name of 'party'

The "Overwrite log file? (interrupt (Ctrl-C) if not!)" query is simply a last
chance to avoid clobbering the current log file.  Just press enter unless you
do not want to clobber the existing log file.

We are starting with character-based initiative, rather than player-based or
side-based, as it suggests in the rules.  This will be substantially more
complicated, but also substantially more realistic?
Does the computer should make it managable?  Is it fun?
Yes, I think so!  Though please hit 'm' unless there is some substantial reason not to.

## Maintenance

### Data Structures

`@characters` array of hashes:

<u>key</u> | <u>value</u>
----------- | -------------
`NAME` | name of character
`ST` | strength of character
`STrem` | strength remaining
`adjDX` | 'core' adjusted DX (e.g. after armor and shield deductions)
PLAYER | who plays this character (created beings are played by the character which created them!)
`PARTY` | In which party is this character?
`STUN` | How must ST damage in one turn will stun this character?
`FALL` | How must ST damage in one turn will cause this character to fall?
`StunTurn` | character is stunned until this turn
`DEAD` | true ==> character is dead or unconscious
`NAMEKEY` | Any extension of this string will refer to this character.
`BAD` | STrem has been brought to <=3 by injuries

### Query User

To query the user, use the following code template:

```
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

[ firstidx is actually used for dealing with pole attacks...  Should be redesigned. ]

#### old scheme:
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

#### new scheme:
* `@dxmods` misc modifiers to DX
* `@dxinj` DX modifiers due to injury.  Compute at beginning of &act
* Both must be maintained.

DX = adjDX + @dxmods + @dxinj

I think it also makes sense to change the &act API to take an array which is true if that char is acting.  So the array index is the char index.
