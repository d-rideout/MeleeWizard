#### Queue:
* label.configure(text="I will self destruct in 2 secs")? (10may022)

#### Urgent:
* Polyana: ST 11 (11)  adjDX 12 +0inj +0act +1spl = 13  Moved 6 hexes
+1 spl???

* Aid spell to ST! (7may022)
  Make it its own command for now.  (Does anything else modify another's ST??)
  Actually no why not just modify the 'a' command, to allow specification of
  modifying ST or DX.
  Though it is a bit different.  Need to store list of pairs of ST and expiration turn.  And need to spend ST from oldest stores first.  Including damage!  SO taking damage now becomes even more complicated!
  There is a &spendST for spending spell ST. Hmm, this is really complicated!
  I think I need yet another ST spending function, which is called by &spendST.  And also when a figure takes damage.  And it checks for Aid ST buffers.
  (9may022)

* Spell cost lost if command fails.
  Subtract cost after command completes? (9may022)

* move party files out of parties/ (?) (21sep022)

* Dragon disappear did not remove it from movement. (7may022)

* unconscious wizards are prompted to move (28jan022)

* +1 hit regeneration per turn for trolls (28apr022)
  Note that unconscious trolls recover! (28apr022)

* Warn when creating being with no spell cost (12may022)

* Allow submitting multiple DX mods for multiple scenarios?
  (Embrace the multiverse!) (27apr022)

* no opportunity to disbelieve on animal automatic disbelieve (29jan022)

* keep track of hexes moved to?
  distance function on roll20 coordinates?

* damage during movement from HTH fail! (27dec021)

* reverse missles xp needs to go to wizard not person hit (8jul022)
* need way to refer to creator in party file (9jul022)
  Argument "Lona" isn't numeric in array element at ./mewcosq line 975, <STDIN> line 21.

* no xp for injuring self (23jul022)

* Get rid of defaults, and use empty string instead?  May simplify some
  things and free up name space? (6jan022)
* Movement queries have multiple prompts, which confuses list of displayed
  options.  Better to put all options at top? (5may022)
* case insensitivity is confusing in general (5may022)



* action queue can become a mess if a battle fizzles (5may022)

* might be nice to indent stuff under each Actor
  Make a print function which adds indent? (7jan022)

* allow launch from specific log file (15mar022)

* lack of clarity about who is an enemy vs friend (1feb022)

* xp accrual on manual.md is out of date (16jan022)

* some warning when no log present or log file present (9jan022)

* blank SIDE is awkward (16feb022)
  'none' as default, like the Ents? (5may022)

* Tool to throw multiple dice (30dec021)

* I think changing one's own DX mod during an action may cause actor to defer
  unnecessarily. (7jan022)

* allow multiple headers? (27dec021)

* I think weak disengage may be better! (7nov021)

* It would be great to store the actor in the log file which damage is delivered.
Though I could piece it together with the information which is there!  (15mar022)
* Store actor in log file?  It is mismatching for some reason.  At least it can catch this error. (7jan022)

* PLAYER-based initiative should really be SIDE-PLAYER-based initiative, i.e. each player should move each of their sides separately.  (eg a DM with characters on multiple sides) (10feb022)

* Would be good to somehow focus attention on adjDX, esp when injured? (16feb022)

* command to fire missle weapon (to keep track of arrows etc) (19sep022)

* Clean up HouseRules:
  - clean up doc/HouseRules.md (17oct021)
  * Question C falling rule, e.g. when stumble over body
  - Consider FAQ at end of Codex!! (sep021)
  - Rethink House Rules presentation? (13sep021)
  - https://docs.github.com/en/communities/documenting-your-project-with-wikis/changing-access-permissions-for-wikis (14sep021)
  - Get xowa working? (23sep021)
    https://www.unixmen.com/xowa-offline-wikipedia-reader-editor/
  - Use wiki format on wiki?  See computer notes. (23sep021)
  * Questions section! (10feb022)

* Sort out licensing of documentation

* This tool will be helpful in large battles.
  Note: [meleewizards.com](http://meleewizards.com)! (5aug021)
  e.g. allows use of original rules on reactions to injury (29aug021)
  And character-based initiative seems a lot more realistic.  I would think we
  want to make as little as possible ride on a single coin toss...
  - Maybe add etiquette guidelines?  To press 'm' unless you have a good reason
    to defer.  'Can only defer if have a good reason to wait' sort of thing.
    (29aug021)
  Though need queue working better! (5may022)

#### Thoughts:
* clean up handling of @order, @orderCI, @ent2chr in &movement (7may022)
* FLEED ==> DEAD? (5may022)
* Eventually queue GUI will keep track of number of hexes moved, etc. (26apr022)
* Split Perl queue code into separate file/module? (10feb022)
* Add GNU copyright stuff as global option (10feb022)
* Have separate public and private name for each character? (4feb022)
* Keep track of fired missles somehow (1feb022)
* Allow comments in query responses, preceded by #?  Could somehow put names of actors into log file this way? (8jan022)
* Everyone shows on initiative display for surprise turn (6jan022)
* allow choice of log file from the command line (6jan022)
* logging should happen after command succeeds! (30dec021)
* How to handle un-sided characters? (29dec021)
* reading from party on side x... (29dec021)
* Worry about parsing forced move entry?  Currently it accepts any input. (7nov021)
* Blur spell would be nice?  Though may be too difficult to be worthwhile, as
  it seems to require that figures declare whom they intend to attack.  This
  could be a bit ridiculous in a huge battle with no wizards! (6nov021)
* make neater table of possible actions! (8oct021)
  - name, format, description
    nicely formatted using printf
    maybe store all this in a data structure.  (Array?  Prob hash better: key name
    val hash with standard keys.  Just nicer than arrays.
    Or can do array of hashes)
* python script which generates 'character cards' (10oct021)
* record die rolls, so can go back and fix errors (9oct021)
* reject actions taken in wrong sub-phase? (8oct021)
* Remove shield command? (8oct021)
* Store names for everything, so e.g. all dex mods can be described, including turns they happened? (8oct021)
* Save end time in log file, and only credit for time in play? (7oct021)
* Allow any (non-reserved) string for move? (6oct021)
* Maybe store formats, descriptions, subphase applicability, for each command? (27sep021)
* Note time is measured from start of log file, so can't sleep on it or whatever! (28sep021)
* Are there rolls to check before each turn? (28sep021)
* Have 'machine mode' for interacting with GUI frontend? (27sep021)
* Should created beings move with creator? (27sep021)
* break or drop weapon as action result -- so can remind next turn! (16sep021)
* throw dice, so they are recorded in the log file
  (could record results of physical dice, or roll my own)
  keep records in a file, to check statistics.
  all 1d6 marginals, and nd6 rolls
  and maybe some day sequences of rolls (nd6 is a first step in that direction - in fact can store sequence if roll from computer)
  (Can do same for physical dice!)
* Remove disbelieved figures from forced retreats? (15sep021)
* Need to distinguish disbelieved figures from dead ones?  Currently disbelieved figure can earn xp if their final STrem is 1.  Is this a problem? (15sep021)
* Note stun can stop double shot with bow (14sep021)
* Save xp earnings in adventure file? (12sep021)
* Make DX & xp computation optional? (12sep021)
* Add (IQ-8) theta(IQ-8) to xp value of kill? (12SEP021)
* Does figure have to die to get xp value?  What about unconscious? (12sep021)
* initiative mods, like someone winning? (11sep021)
  Maybe just start with commentary about conversion from d6 to [0,1)
  initiative.  Note conditioning on two dice being unequal complicates
  discussion!  +1 initiative \ne "need to exceed other party's initiative by
  more than 1"! (13sep021)
* Process DeathTest1 file (11sep021)
* https://directory.fsf.org/wiki/Free_Software_Directory:Requirements (21apr021)
* Restore "dex x:" output? (6sep021)
* Record sequence of moves?  2d coordinates should be easier than origin-based.
  The standard Melee map has a nice central axis.  Could be y=0, x=\pm 7.
  But can also have half coordinates. x = -3-
  y \in {-1, 1, 2, 3}
  x = 2+, y \in {-3, -2, -1, 1, 2}
  (or do I want to use all odd numbers for y coordinates?)
  Or do I want something which generalizes to other maps more easily?  Maybe better to start with this?
  Facing could be 0-5 counting from +x-axis and rotating counter-clockwise.
  (Or can use this facing to describe a hex -- locate hex on x-axis, face in direction, march number of hexes, then rotate facing again.  This is kinda what I mean by an origin-based approach.  It has the advantage of being more generalizable to other maps: All you have to do is select an origin hex and a facing-orientation.) (7sep021)
  https://math.stackexchange.com/questions/171299/calculating-distance-in-a-hexagonal-grid-map (27oct021)

* worry about character and command namespace collisions? (30aug021)
* expand &query to contain loop which handles errors in syntax and char
  specification, to uniformize its handling! (29aug021)
  - takes array which indicates which slots should be char refs?  
  - prob will return list, with char refs as indices? (30aug021)
  I don't know that this will work, as each action looks different in this regard.
  Take 2:
  while (query(args)) {
    next ==> problem, query again
    last ==> all good
    \# What about internal error?
    \# Either &query has an internal while loop, or it calls itself.
    \# The former may be simpler.
  }
  so same structure within &query itself  while (1) I suppose
  In fact this is what it does already!
  - Whoever calls &who must check for 'x' return value, but the error message is already reported by &who, so
  next if $who eq 'x';
* Make all commands two characters, for consistency? (2sep021)
* Resuming from log does not work if list of input characters changes.
  People at the initial, unchanged portion of the list keep their initiative
  rolls, but after the change rolls will be assigned to different characters.
  It is kinda a minor effect.  I am not super-keen on storing initiative
  rolls in the log file, but this could be done.  But it would not really fix
  the problem, as the sequence of queries would change.  It would fix
  movement initiative only.  I am leaning toward not worrying about this.  If
  you change the list of input characters then it is a different battle.  But
  this should be documented. (2sep021)
* put list of acting chars in hash, for more flexible interaction?
  get rid of &firstidx calls? (29aug021)
* warn on namekey conflicts? (28aug021)
* recommend names which begin with unique characters? (28aug021)
* Suprise which only grants initiative? (27aug021)
* Aid & Rope spells: modifies someone's adjDX (20aug021)
* Blur spell: decreases adjDX of everyone attacking someone (20aug021)
  - Have declaration of intent, maybe as part of move?  Or after all moves play out?  It is getting
    *more* complicated, not less... (20aug021)
* Character-based move initiative can get fairly thorny with many characters.
  Maybe default to party-based?  Player-based?
  Though I like it, as it 'reduces variance'.  Less rides on the initiative
  roll that way. (25aug021)
* Hiding information:
  - Use system `clear` to blank screen
  - history command to display blow-by-blow, with option to disregard deferred move details
  - Note that history content itself will have different content for different players!
    * q quit
    * h<options> history
    * ? itself
    * will probably need player mode stuff to indicate which view to display (20aug021)
    * eventually characters will have to declare intent to attack during adjustments phase, to
      keep track of Blur spells and the like.  Then there will have to be a global option to
      change one's mind.
      Though such commands will likely have to be recorded in the log! (26aug021)
      
* default interface to &query is a little silly.  Why not just return the
  empty string as the default always?  An issue is if a user actually tries
  to enter the default value.  Maybe that will be easier to catch within
  &query itself.  And maybe ever better yet -- forcucate the user into just
  pressing Enter for default, to ease pressure on the response namespace.  (I
  am thinking about move specifications.  I do not expect much agreement on
  the best approach for that...) (9sep021)

* I think @chars API to &act is a tad silly, in that figures never get prunned from the list.  However indexing into the list is non-trivial, so I don't know that it is worth trying to fix this. (19sep021)

* make move prompt smaller? (7oct021)

* could have views on battle state
  give bounds on adjDX of enemies etc.
  maybe ST ranges?  (14oct021)
* publish art/urls?  On the wiki? (15oct021)

* To what extent are commands case insensitive? (2nov021)

#### Non-urgent:
* two+ digit log file names (30dec021)
* Check if sp2 preceeds r action? (Rope spell)? (10sep021)
* All these spells will be confusing to keep track of.  Need a more generic spell action. (10sep021)
* Global commands will trump local ones.  So far this is not a problem, but
  should global commands start with a * or something? +? /? (25aug021)
* Specify space separated list of surprised parties, needs generic version of
      character listing subroutine (8aug021)
* declare DX and stun status when acting (10aug021)
* empty dex $dex: is still happening
  I think it can happen if someone gets stunned before acting, so they get
  pushed back in dex order, and then they fall.
  Is it a problem? (9aug021)

* name key will choke if run over end of name!  Put monsters first... (27jul021)
* Allow creating characters with spaces in name? (action commands are split on
  spaces) (1aug021)
* It may help to document the algorithms, so that one understands how to
  implement features. (2may021)
* Allow deferring action? (27jul021)
* Compute second bow shot automatically, based on adjdx, rather than entering
  it each turn.  Oh well, for now it must be entered each turn -- automatic
  will be complicated, as each character will have to declare what type of bow
  they are using. (30jul021)
* Stunned 'through this turn' or '... next turn'? (12aug021)
* Hide empty dex: slots (21aug021)

#### Later / Dunno:
* What happens with other missing fields in party file? (14apr021)
  Seems to be completely harmless.  Declare which fields are essential? (4sep021)
* Implement deferred actions (4apr021)
* Allow changing mind about action -- how does that affect turn order?
* Only put 'q' to quit at beginning? (Or now '?'. (4sep021))
* Should I rename the file to something better, without the .pl extension?
* Is it silly to use different vars to hold query responses? (4apr021)
  No, I think local variables are good! (2sep021)
* Assert collective-work copyright on project (ESR) (18oct021)

#### Less important:
* use extensions for party files?
  Maybe not for starters.
* find parties in spite of extensions

<!-- #### Questions: -->


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
* can get -3 reaction to injury adjustment twice! (26aug021)
* allow changing shield state during declaration subphase (27aug021)
- finish with character by index specifications
* would be nice to have more flexibility in referring to characters.  Long enough prefix
  string.  But this conflicts with my short string approach? (27aug021)
  - accept superstrings (27aug021)
* renew spells cost! (27aug021)
* disbelieve illusions! (26aug021)
* Flesh out surprise turn 0? (14apr021)
* Declare deviations from usual rules somewhere?
* Publish house rules on wiki?
* get rid of : in spell casting action? (27aug021)
* Don't repeat forced retreats? (27aug021)
* Sort out forced retreats (16apr021)
* Take into account damage from casting spells! (16apr021)
  - both for renewal and initial cast
  - actually not so crucial -- spell casting desn't seem to count as an injury
* Wizards lose 3 DX when STrem < 4, but this should only be from reaction to injury.  Hmm...! (4sep021)
* get rid of firstidx in removing pole attacks.
Store lists of actors in hash?  Here we go again...
Don't the pole people get skipped over anyway, since they have @acted?
Yes!  I don't know what is wrong here!
%
sparse sets pass well in a 'compact' list
dense sets pass well in a 'spread out' list
pole attackers will be sparse.  Even more so with surprise.
But I think the point is the set passed for the normal act phase.  That should almost always be dense.
So we should pass an array 0..$n-1, which is true if the character is acting in this subphase.
%
Actually pole and second bow attacks are super sparse, and normal is dense.  So no one method makes sense.  So maybe I am forced to the hash solution?
%
If the acted works for the pole people, I can do
pole
everyone
bow2
Won't that work well, with the current sparse API? (5sep021) (Yes, it does.)
* Document all this DX handling stuff, in the maintenance section of the manual.
  And consider rewriting it, yet again?  So that it is easy to implement new actions etc. (4sep021)
* rope spell (26aug021)
  - allow changing DX mods during any action, as sorta global option, though it
    needs to be stored in the log!
  - Needs rewrite of DX order code again, either to recompute with each character, or a routine to handle a change. (1sep021)
  - ACTUALLY I DID THIS ALL WRONG!  tHIS SHOULD BE A REGULAR ACTION!  sO A ROPE SPELL ON X WOULD BE: "sp2: d x -2" (2sep021)
  - THOUGH THERE IS ALSO THE "sh" ACTION FOR THIS.  hMM...
    The user can make a 'permanent' change with "sh" or a this-turn-only change with "a". (2SEP021)
* 'f' option to be finished with movement phase (6sep021)
* Catch Ctrl-C, so that it does not clobber the log file?  Or save a backup somehow?  It does not get written if I have to C-C out due to a bug... (6sep021)
* May be nice to keep track of Rope deduction for user!  It can get complicated. (4sep021)
  sp2 r <who>
  ->{ROPE} holds turn of rope, delete ->{ROPE} if not roped
  then put rope minus somewhere, as injury or so (4sep021)
  How do we feel if someone leaves off the sp2?  Maybe they have a 'wand of roping' or something -- may be best to allow maximal flexibility.  Maybe just give a warning for now.
  u <who> to unrope someone (9sep021)
* mewizseq? meWizSeq? MeWizSeq? combat_sequence? wizlee? melwizseq?
  tftseq mwseq ... (25aug021)
  tftcomseq comseq combseq mewcosq MeWCoSq?  mewsq?
  Better to start with lower case? (7sep021)
* TFT-style xp, as in Death Test 2 (11sep021)
* xp for time spent in battle, as lower bound at least (12sep021)
* Need to save wallclock time in log file (14sep021)
* Seems like cannot forced retreat a dead figure! (adv melee p 22) (16sep021)
* Control debug mode from command line (16sep021)
* defer action would be really useful, though complicated... (27aug021)
* -dl -ld (20sep021)
* Do single leading spaces cause any trouble?  such as alone? (26sep021)
* create being DX too!
* uncharged creation needs to disappear
  'discontinue' <who>
* separate time xp from rest
* wait for an opening
* combine spell recharges
* keep track of number of hexes moved!
* merge shield command into adjust, with a duration, and accept inf as duration (26sep021)
  - first give adjust a duration, then consider removing shield command? (8oct021)
* turn spell is cast is turn 0 -- this strengthens Aid and weakens Rope.  Put this into
  the house rules, and adjust code. (26sep021)
* monsters with multiple attacks! (10oct021)
* fall unconscious when casting down to ST 1 (12oct021)
- xfer [house rules] from wiki to doc/ (16oct021)
* double time rate of xp without talents (1 per 6 min of playtime)
* xp of creations!!
* wait for an opening needs to end on a miss!
* Proposed rule to handle ambiguity of action sequence:
  Figure declares a DX adjustment during the declaration phase.
  If figure chooses alternate action which should happen sooner, it looses out.
  If figure chooses action which happens later, it must wait until the end of that adjDX action period.  This latter aspect will need coding.
  Since I am coding anyway, perhaps a figure can change its mind at any time, as a global action.  But once things happen in real life they happen in the game too.  Like in other games when you can shout something at any time. (25oct021)
  Even better: allow changing mind at any time:
  as figure action
  as global option (e.g. during other figure's action)
* wait for x as move?
  or all defer until x
- fix wizard melee rules! (19oct021)
* Remind how far moved when deciding action
* allow party in party file
* allow name not first in party file
* NAME =
* PARTY =
* implement side-based initiative: declare side in party file
  SIDE = 
* XP for unconscious figures?
* Report everyone's damage at the end of the battle. (10nov021)
* list characters in initiative order?
  are the two lists compatible? (3nov021)
  Could just allow optional 'permutation' argument to &displayCharacters! (6nov021)
* My last commit broke non-character-based initiative:
  - Maybe write smarter sort routine which handles non-character-based initiative, dead characters, etc.  Or write some code to manuipulate @roll first.
  Could maybe do both -- allow initiative method to determine which sort routine is selected.
  Or maybe better still: prepare 'sorted' list before for loop.
  Probably returning 0 in the comparison function acts as an identity?  Though maybe not.
* Turn 1 normal actions: Action result? (N)o or (?) for glbl opts> n
  Unrecognized action n
* who matches!
* Suffix with '' if figure has more actions for this turn.
* put all logs into log/ (27nov021)
* Windows is confusing the line endings somehow.  Need a windows file or
  machine. (6dec021)
* ud does not work on Mac!! (24nov021)
  head there is broken -- need to implement my own (8dec021)
* 455730 hours and 32 minutes of wallclock time passed.
Each survivor earns (at least) 2734383 xp for wallclock time.
Something is wrong with reading the start time from log file??
* Turn 4 action consideration: (F)inished or (?) for glbl opts> c -3
error in global option [c -3]
* Do damage multipliers really multiply, or just add??
  Trying multiply for now, per rules! (4feb022)
* f as special consideration fails? (16jan022)
* Allow &qadd to receive list of characters (26apr022)
* Add everyone to deferral queue at outset so that players can see initiative order. (25apr022)
* Need some fleed action or move! (9jan022)
* created wolf does not show in character list
* is messed up after figure dies I think (7may022)
