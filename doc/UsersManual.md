# Melee/Wizard Turn Sequence Tool - User Manual

Party file arguments are described in the [README.md](../README.md) file.

The code defaults to character-based initiative, rather than player-based or
side-based, as it suggests in the rules.  This will be substantially more
complicated, but also substantially more realistic?
If it is too complicated, change the `$initiative` setting at the top of `mewcosq` to `p` for party-based or `l` for pLayer-based initiative.
<!-- Try to err on the side of hitting '0' unless there is some substantial reason not to, to make the movement phase a little less complicated. -->


## Global commands
These commands can be used at any prompt.

Command|Description
-------|-----------
`?` | list 'global' commands
`ca <who> <DXmod>` | change `<who>`'s DX modifier due to new choice of action for this turn
`q` | quit game
`ud <n>` | undo `<n>` previous entries

The `ca` command will presumably have no effect outside of the action sub-phase.


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
