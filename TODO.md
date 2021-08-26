#### Urgent:
* http://www.sjgames.com/general/online_policy.html (23aug021)
* mewizseq? meWizSeq? MeWizSeq? combat_sequence? wizlee? melwizseq?
  tftseq mwseq ... (25aug021)
* Check for bugs in bugs file

* This tool will be helpful in large battles.
  Note [meleewizards.com](http://meleewizards.com). (5aug021)


#### Thoughts:
* Aid & Rope spells: modifies someone's adjDX (20aug021)
* Blur spell: decreases adjDX of everyone attacking someone (20aug021)
  - Have declaration of intent, maybe as part of move?  Or after all moves play out?  It is getting *more* complicated, not less... (20aug021)
* Character-based move initiative can get fairly thorny with many characters.
  Maybe default to party-based?  Player-based?
  Though I like it, as it 'reduces variance'.  Less rides on the initiative
  roll that way. (25aug021)
* Hiding information:
  - Use system `clear` to blank screen
  - history command to display blow-by-blow, with option to disregard deferred move details
  - Note that history content itself will have different content for different players!
  - Maybe have '?' command at all prompts, which displays global command options:
    * q quit
    * h<options> history
    * ? itself
    * will probably need player mode stuff to indicate which view to display (20aug021)

#### Non-urgent:
* Global commands will trump local ones.  So far this is not a problem, but
  should global commands start with a * or something? +? /? (25aug021)
* Specify space separated list of surprised parties, needs generic version of
      character listing subroutine (8aug021)
* declare DX and stun status when acting (10aug021)
* empty dex $dex: is still happening
  I think it can happen if someone gets stunned before acting, so they get
  pushed back in dex order, and then they fall.
  Is it a problem? (9aug021)
* implement side-based initiative:
  declare side in party file
  store hash party -> side to determine side of each character (9aug021)
* name key will choke if run over end of name!  Put monsters first... (27jul021)
* Allow creating characters with spaces in name? (action commands are split on
  spaces) (1aug021)
* It may help to document the algorithms, so that one understands how to
  implement features. (2may021)
* Sort out forced retreats (16apr021)
* Take into account damage from casting spells! (16apr021)
  - both for renewal and initial cast
  - actually not so crucial -- spell casting desn't seem to count as an injury
* Allow deferring action? (27jul021)
* Compute second bow shot automatically, based on adjdx, rather than entering
  it each turn.  Oh well, for now it must be entered each turn -- automatic
  will be complicated, as each character will have to declare what type of bow
  they are using. (30jul021)
* Stunned 'through this turn' or '... next turn'? (12aug021)
* Hide empty dex: slots (21aug021)

#### Later / Dunno:
* What happens with other missing fields? (14apr021)
* Implement deferred actions (4apr021)
* Allow changing mind about action -- how does that affect turn order?
* Only put 'q' to quit at beginning?
* GPL wants a blurb at the opening of the program
* Should I rename the file to something better, without the .pl extension?

* Flesh out surprise turn 0? (14apr021)
* Declare deviations from usual rules somewhere?
* Publish house rules on wiki?

* Is it silly to use different vars to hold query responses? (4apr021)

#### Less important:
* use extensions for party files?
  Maybe not for starters.
* find parties in spite of extensions

#### Questions:


#### DONE:
* Should have separate file for each party (4apr021)
* Handle 'q' response within query subroutine (4apr021)
* find parties in `parties/` (13apr021)
* Provide party template for github (4apr021)
* Write README.md?
* abort if no adj dx declared (11apr021)
* display char numbers before dex adj? (11apr021)
* dx adjustments enter when finished (11apr021)
* put in reactions to injury or have them put it into adj dx!
  note injury will change execution order!! (11apr021)
* Skip over unconscious characters during movement (20apr021)
* Handle death / unconsciousness
* pole weapon attacks go first! (25jul021)
* illusions etc need to be added (for initiative and turn order)!!
* dead things need to be taken out of queries
* It may be cool to save the sequence of actions&outcomes to a file, so the
  code can be aborted and restarted in the middle of a battle.  For debugging
  primarily. (2may021)
* charging Pole arms go first (27jul021)
* log file will need iniative rolls to be useful!  Or a seed say. (27jul021)
* Generate probability tables for 3 & 4 dice to-hit.
* refer to characters with namekey (2aug021)
* party-wise initiative (3aug021)
* dead characters should not populate dex ties lists (3jul021)
  Is this still an issue?? (31jul021)
* Implement non-character iniative schemes? (27jul021)
* Allow referencing characters by first letters of name (14apr021)
* stunned chars go twice when multiply stunned!
  - and falling too
  when stun check if already stunned, and possibly entend by a turn
  when fall check if damage taken already exceeds FALL threshold (5aug021)
* flesh out story in README, and move out local file descriptions
  maybe ask people to submit issue tickets (6aug021)
* rewrite action sequence.  It still shows dex xs: for list of characters
  which have already acted.  When they take damage after they have acted,
  they should not be placed down in a smaller DX list. (6aug021)
* fallen character 'acts' (9aug021)
* Put ST before ADJDEX in party samples?
  ADJDX --> ADJDX?  adjDX?  Conflate all? (5aug021)
* GPL in all source files (10aug021)
* Surprise:  If yes, ask about each party in turn, if they are surprised, and
  then have everyone else participate in a turn 0. (11aug021)
* Show stun status when acting.  Stunned through this turn or next turn. (11aug021)
* Names which start with a number will be problematic, since their namekey will
  be interpreted as a character index.  Should I dispense with character index
  referencing?  Or disallow names which contain spaces, or begin with a digit?
  (5aug021)
  Though possibly many people will want spaces in their names?  I think that
  they will have to use underscores for them in their party file. (9aug021)
  Just check names for potential problems when they are read, including key
  overflow! (10aug021)
* action to ready or unready a shield, which permanantly changes adjDX! (20aug021)
* list possible forced retreats (20aug021)
* Undo previous entry...  Maybe write a script for this, to undo n entries?
  Maybe the script wraps ./melee.pl itself? (2aug021)
  Or melee.pl relaunches itself! (11aug021)
- blurb at banner time
