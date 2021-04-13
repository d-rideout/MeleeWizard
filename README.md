# MeleeWizard
Tool to manage the combat sequence in Steve Jackson's Melee-Wizard

Melee-Wizard is the combat engine for *The Fantasy Trip* role-playing game.  The rules are very simple, and yet allow for rich tactics.  Do I run faster to engage the enemy this turn, and risk getting hit by an arrow, or should I dodge while running, so that I am less likely to be hit?

Unfortunately I tend to forget where I am in the combat sequence around the third or fourth turn or so.  After doing the tie-breaking initiative roll to determine the order of action for the three characters who happen to have adjusted DEX 11 because of their previous injuries and chosen actions during that turn...  This tool is intended to take care of all that, so you can focus on the game!  Let the computer tell you whose turn it is, so you don't have to keep all these details in your head.

**Note:** I have the version published by Metagaming in 1980.  I do not know if the rules for the more modern version published by Steve Jackson Games are the same.

## Instructions

A battle involves two or more *sides*.  Each side if composed of *parties*, which are groups of related *characters*.  Usually a side, especially that of the players, has only a single party, but not always.  Each *player* controls a number of characters, usually all within a single party.

Before starting the battle, create a file for each party, which details all characters in the party, including who is playing them and their 'usual' adjusted DEX.
There are two sample party files in the `parties/` folder.
They are tab-separated-value files: you can edit them with your favorite
spreadsheet program or text editor.

Run the tool however you launch Perl programs on your computer.  For
example, from the Linux command line:
```
$ melee.pl coyotes fair2midlin
```
(melee.pl looks for your party files in `parties/` if you do not specify a
full path to them.)
