* Skip over unconscious characters during movement (20apr021)
* Sort out forced retreats! (16apr021)
* Take into account damage from casting spells! (16apr021)

* It may be cool to save the sequence of actions&outcomes to a file, so the
  code can be aborted and restarted in the middle of a battle.  For debugging
  primarily. (2may021)
* It may help to document the algorithms, so that one understands how to
  implement features. (2may021)

#### Later / Dunno:

* What happens with other missing fields? (14apr021)
* Allow referencing characters by first letters of name (14apr021)
* Implement deferred actions (4apr021)
* finish dx adj when all characters entered(?) (11apr021)
* Handle death / unconsciousness
* Allow changing mind about action -- how does that affect turn order?
* Only put 'q' to quit at beginning?
* GPL wants a blurb at the opening of the program
* Should I rename the file to something better, without the .pl extension?

* Flesh out surprise turn 0? (14apr021)
* initiative should be by player not character?  That is how it works in the
  usual rules.
* Declare deviations from usual rules somewhere?
* Publish house rules on wiki?

* Is it silly to use different vars to hold query responses? (4apr021)

#### Less important:

* use extensions for party files?
  Maybe not for starters.
* find parties in spite of extensions

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
