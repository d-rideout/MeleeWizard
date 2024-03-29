# MElee-Wizard COmbat SeQuence tool
> Tool to manage the combat sequence in Steve Jackson's Melee-Wizard

Melee-Wizard is the combat engine for *The Fantasy Trip* role-playing game.
The rules are very simple, and yet allow for rich tactics.  For example,
"Do I run faster
to engage the enemy this turn, and risk getting hit by an arrow, or should I
dodge while running, so that I am less likely to be hit?"
"My broadsword broke
last turn, so all I have ready is my shield.  Should I shield
rush the orc, even though I am weaker and it will almost certainly have no
effect, simply so that he will become engaged and not be able to charge at
the wizard?"

Unfortunately, I tend to forget where I am in the combat sequence around the
third or fourth turn or so.  After doing the tie-breaking initiative roll to
determine the order of action for the three characters who happen to have
adjusted DX 11 because of their previous injuries and chosen actions during
that turn...  This tool is intended to take care of all that, so you can
focus on the game!  Let the computer tell you whose turn it is, so you don't
have to keep all these details in your head.
It also keeps track of each figure's ST remaining, and experience points earned during combat, presenting
them at the end of the battle, so that less record keeping is required
during a battle.

**Note:** I have the (Advanced and 'basic') versions published by Metagaming circa 1982.  I
  do not know if the rules for the more modern versions published by Steve
  Jackson Games are the same.  See the
  [wiki](https://github.com/d-rideout/MeleeWizard/wiki "repository wiki"),
  and [doc/HouseRules.md](doc/HouseRules.md "House Rules documentation") for some comments on 'house rules'.

Keep in mind that this tool is not intended to enforce rules, it is merely a
game aid.  The onus is on the user to ensure that the game rules are followed
properly.  The ubiquitous undo command `ud` can be helpful in this regard...

## Instructions

A battle involves two or more *sides*.  Each side is composed of *parties*,
which are groups of related *characters*.  Usually a side, especially that of
the players, has only a single party, but not always.  Two characters on
different sides are assumed to be in an antagonistic relationship with each
other.  Each *player* controls a number of characters, usually all within a
single party.

Before starting the battle, create a file for each party, which details all
characters in the party, including who is playing them, their current ST, and
their 'usual' adjusted DX.  (You will have to declare most deviations from this
adjDX every turn, though some are taken care of automagically, such as those
from reactions to injury.)
There are two sample party files in the `parties/` folder.
They are tab-separated-value files: you can edit them with your favorite
spreadsheet program or text editor.

Run the tool however you launch Perl programs on your computer.  For
example, from the Linux command line:
```
$ cd <MeleeWizard checkout directory>
$ ./mewcosq coyotes fair2midlin
```
(mewcosq looks for your party files in `parties/` if you do not specify a
full path to them.)

mewcosq records all input in a `log` file, along with the random number generator
seed.  If you run with the `-l` option, e.g.
```
$ ./mewcosq -l coyotes fair2midlin
```
it reads the seed and enters all commands from this file, so that you can
restart the battle exactly where you left off.  (Note that, before
restarting, you can edit the `log` file -- it is a simple text file.)

For the moment you can control the initiative method by setting the
`$initiative` variable at the top of `mewcosq`.

Please submit issue tickets if you encounter any problems or wish to suggest
new features.

See the [UsersManual](doc/UsersManual.md) for some more information.

## Files

<!-- trying to get it to underline column headers below -->
__File__ | __Description__
---- | -----------
`doc/to_hit_rolls.pl` | generates probability tables for sums of 2-5 dice
`parties/` | contains two sample party files.  Put your own party files here.
`LICENSE` | GPLv3
`TODO.md` | some plans for future development
`log/`	  | mewcosq generated log files go here
`map.pl`  | an initial attempt to build an ASCII hex map
`mewcosq` | the main program
`mewcosq-gui` | first steps toward a GUI interface to mewcosq
`queue-gui` | graphical display of queue (experimental!  Try `$ watch cat .queue` instead.)
