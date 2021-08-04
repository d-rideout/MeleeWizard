#### Urgent:
* bugs in bugs file
* stunned chars go twice when multiply stunned!
  - and falling too
* flesh out story in README, and move out local file descriptions
* mewizseq?
  - blurb at banner time
  - GPL in all source files

#### Non-urgent:
* Undo previous entry...  Maybe write a script for this, to undo n entries?  Maybe the script wraps ./melee.pl itself? (2aug021)
* Allow creating characters with spaces in name? (action commands are split on spaces) (1aug021)
* It may help to document the algorithms, so that one understands how to
  implement features. (2may021)
* Sort out forced retreats (16apr021)
* Take into account damage from casting spells! (16apr021)
  - both for renewal and initial cast
  - actually not so crucial -- spell casting desn't seem to count as an injury
* name key will choke if run over end of name!  Put monsters first... (27jul021)

* Allow deferring action? (27jul021)
* Compute second bow shot automatically, based on adjdx, rather than entering
  it each turn.  Oh well, for now it must be entered each turn -- automatic
  will be complicated, as each character will have to declare what type of bow they are using. (30jul021)

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
