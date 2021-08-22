#!/usr/bin/env perl
# Manage turn sequence in The Fantasy Trip's Melee/Wizard
# Copyright (C) 2021 David P. Rideout
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
use strict;
use warnings;
use List::Util qw/max/;
use List::MoreUtils qw/firstidx/;

# Setting flags
my $debug = 0; # 1 ==> max debug output
my $initiative = 'c'; # c ==> character-based; p ==> party-based
                      # l ==> pLayer-based; s ==> 'side-based

# Check settings
die "Side-based initiative is not implemented yet\n" unless $initiative =~ /^[cpl]$/;
# die "Only character- party-based initiative is currently implemented\n" unless $initiative =~ /^[cpl]$/;
# die "Only character-based initiative is currently implemented\n" unless $initiative =~ /^[c]$/;
# Side-based initiative is problematic -- I need to add it to the UI somehow.  Should be a property of parties.  Could group the input parties somehow on the command line?  Or maybe better -- have each party file declare a side name at the top! (2AUG021)

# Check command line
my $restart;
if (@ARGV && $ARGV[0] eq '-l') {
  $restart = 1;
  shift @ARGV;
}
die "usage: melee.pl [-l] <party 1> <party 2> <party 3> ...\n" .
    "  -l ==> restart from log file\n" unless @ARGV;

# Data structures
my @characters; # val hash with below keys
my %charkeys; # key namekey val index into @characters
my %hkeys = (NAME=>1, ST=>1, STrem=>1, adjDX=>1, PLAYER=>1, PARTY=>0, STUN=>0, FALL=>0, StunTurn=>0, DEAD=>0, NAMEKEY=>0);
# STUN how much damage causes stun
# StunTurn becomes unstunned on this turn
# FALL how much damage causes fall
# 1 ==> can appear in party file
my $n = 0; # total number of characters

# Banner
$debug && print "Debug level $debug\n\n";

# Read parties
foreach my $partyfile (@ARGV) {
  unless (open FP, '<', $partyfile) {
    open FP, '<', "parties/$partyfile" or die "Error opening $partyfile: $!\n";
  }
  $partyfile =~ s/^parties\///;
  print "Reading party $partyfile:\n";
  my $tmp;
  # ignore leading comments
  do { chomp($tmp = <FP>); } while $tmp =~ /^#/;
  # read header of key names
  my @hkeys = split /\t/, $tmp;
  # Check that all headers are valid
  foreach (@hkeys) { die "Unrecognized field: $_\n" unless $hkeys{$_}; }
  while (<FP>) {
    next if /^#/;
    next unless /[^\s]/;
    chomp;
    next unless $_;
    my @l = split /\t/;
    print $n+1, "\t$l[0]\n";
    foreach my $i (0..$#hkeys) {
      $characters[$n]->{$hkeys[$i]} = $l[$i];
    }

    # Check some field values
    my $chr = $characters[$n];
    #   foreach (keys %hkeys)
    die "Please provide adjDX for all characters\n"
	unless $characters[$n]->{adjDX};
#     my $nhex = $characters[$n]->{NHEX};
#     die "Can only handle 1 or 3 hex characters currently\n"
    # 	unless $nhex==1 || $nhex==3;
    die "Please provide ST for each character\n" unless $chr->{ST};
    $characters[$n++]->{PARTY} = $partyfile;
  }
  close FP;
}
print "$n characters\n\n"; # with ", 0+@hkeys, " fields\n";

# Preparations
# ------------
foreach my $ci (0..$#characters) { character_prep($ci); }

# Open log file
# -------------
my @log;
my $seed;
if ($restart) {
  open LOG, '<log' or die "problem reading log file";
  chomp($seed = <LOG>);
  srand $seed;
  @log = <LOG>;
  close LOG;
} else {
  $seed = srand;
  print "Overwrite log file? (interrupt (Ctrl-C) if not!)"; <STDIN>;
 }
open LOG, '>log' or die "problem creating log file";
print LOG "$seed\n";

# Manage combat sequence
# ======================
my $turn = 0;
my $phase = ''; # Combat sequence phase
my @dex; # adjDX for each character for this turn
my @turn_damage; # amt damage sustained this turn for each character
my @acted; # who acted so far this turn, for handling reactions to injuries
my @damaged; # who has taken damage this turn
my @retreats; # possible forced retreats

print "\nCapital letter is default\n";

# Surprise
# print "Sorry, not ready to handle this yet.\n" if $q eq 'y';
# ++$turn;

# Main loop
while (1) {
  my %surprise_parties;
  unless ($turn) {
    my $q = query('n', 'Surprise? (y)es (N)o');
    if ($q eq 'y') {
      # Generate list of suprised parties
      # I assume no one can be dead yet?
      ++$surprise_parties{$_->{PARTY}} foreach @characters;
      # no don't use an array.  Leave the surprised parties in a hash.
#       my @surprise_parties = keys %parties;
      foreach (keys %surprise_parties) { #my $i (0..$#surprise_parties) {
# 	$q = query('y', "Is $surprise_parties[$i] surprised? (Y)es (n)o");
# 	splice @surprise_parties, $i, 1 unless $q eq 'y';
	$q = query('y', "Is $_ surprised? (Y)es (n)o");
	delete $surprise_parties{$_} unless $q eq 'y';
      }
      # Below if !$turn && $surprise_parties{...PARTY} then skip that character
#       die "If no parties are surprised then please accept the default '(N)o' for  the 'Surprise?' question\n" unless keys %surprise_parties;
    } else { ++$turn; }
  }

  print "\n* Turn $turn:\n";

  # Movement
  # --------
  my @entities;
  if ($initiative eq 'c') {
    foreach my $c (@characters) {
      next unless $turn || !$surprise_parties{$c->{PARTY}};
      push @entities, $c->{NAME} unless $c->{DEAD};
    }
  }
  else {
    my $type = 'PARTY';
    $type = 'PLAYER' if $initiative eq 'l';
    my %entities;
    foreach my $c (@characters) {
      next unless $turn || !$surprise_parties{$c->{PARTY}};
      next if $c->{DEAD};
      my $ent = $c->{$type};
      push @entities, $ent unless $entities{$ent}++;
    }
  }
  die "There is no one available to move!\n" unless @entities;
  movement(@entities);
  
  # Actions
  # -------
  print "\nAction phase:\n";
  $phase = 'action';
  
  # Declare expected dex adjustments and other special considerations
  my @poles; # pole weapon charges
  my @bow2;  # double bow attacks
  my @dexadj; # amt to add to adjDX
  &displayCharacters;
  print 'Special considerations: <who> <consideration1> [consideration2]
  Considerations are
  * <num>
    DEX adjustments as offset from original declared adjDX.  
    Ignore reactions to injury and weapon range penalties.
  * <c|b>
    c ==> pole weapon charge
    b ==> double shot with bow
  e.g. "2 -4 p" for char 2 doing rear attack as pole weapon charge
';
  while (1) {
    my $sccmd = query('', "Special consideration, (F)inished");
    last unless $sccmd;
    my @sccmd = split / /, $sccmd;
    my $who = who(shift @sccmd);
    if ($who<0) {
      print "Invalid character specification $who\n";
      next;
    }
    print "$characters[$who]->{NAME}";
    foreach my $cmd (@sccmd) {
      if ($cmd =~ /^\+?-?\d+$/) { #(\+|-) ?(\d+)( ?([pm]))?/) {
	$dexadj[$who] = $cmd;
	my $plus = '+';
	$plus = '' if $cmd =~ /^[\+-]/;
	print " at $plus$cmd DEX = ", $characters[$who]->{adjDX}+$cmd, ' (- injury adjustments)';
      } elsif ($cmd eq 'c') {
	push @poles, $who;
	print " charging with pole weapon";
      } elsif ($cmd eq 'b') {
	push @bow2, $who;
	print " double shot with bow";
      } else { print "Unrecognized consideration $cmd\n"; }
    } # loop over considerations for this character
    print "\n";
  } # special considerations
  print "\n";

  # Compute dex for this turn
  for my $i (0..$n-1) {
    my $chr = $characters[$i];
    
    $dex[$i] = $chr->{adjDX};
    $dex[$i] += $dexadj[$i] if $dexadj[$i]; # (it might be undefined!)

    # Reactions to injury
    $dex[$i] -= 2 if $turn < $chr->{StunTurn};
    $dex[$i] -= 3 if $chr->{STrem} < 4;
    # I have to keep track of the two different types of damage for wizards (7aug021)
  }

  # Act
  my @chars = 0..$n-1;
  unless ($turn) { # prune surprised characters
    foreach (my $i=$#chars; $i>=0; --$i) { # ($#chars..0) {
      splice @chars, $i, 1 if $surprise_parties{$characters[$i]->{PARTY}};
#       $debug && print "prunned suprised character $characters[$i]
    }
  }
      
  @turn_damage = ();
  @acted = ();
  @damaged = (); # who has taken damage this turn
  @retreats = (); # possible forced retreats
  if (@poles) {
    $phase = 'pole weapon charges';
    print "Pole weapon charges:\n";
    act(@poles);
    # remove @poles from @chars
    foreach my $p (@poles) { splice @chars, (firstidx {$_==$p} @chars), 1; }
    # Above seems pretty slow.  This complication only because of surprise round. Rethink all this? (20aug021)
  }
  $phase = 'normal actions';
  print "\nNormal attacks:\n";
  # prune dead characters here?  They may die during this act() call too. (7aug021)
  act(@chars);
  if (@bow2) {
#     my $i;
    @acted[$_] = 0 foreach @bow2;
    $phase = 'second missle shots';
    print "\nSecond bow attacks:\n";
    $debug && print "for @bow2\n";
    act(@bow2);
  }

  # Force Retreats
#   print '
# Forced Retreats phase: Any figure which has inflicted attack hits on an adjacent
#   figure and has not taken damage this turn may execute a forced retreat on the
#   adjacent figure.  (Attack hits include any physical attack and missle spells.)
# ';
  $phase = 'forced retreats';
  print "\nPossible Forced Retreats: (if two chacters are adjacent)\n";
  for (my $i=0; $i<@retreats; $i+=2) {
    my $who = $retreats[$i];
    print "$characters[$who]->{NAME} on $characters[$retreats[$i+1]]->{NAME}?\n" unless $damaged[$who];
  }
#   print "\n";
  
  ++$turn;
} # while (++$turn); # Why this check??


# Display characters
sub displayCharacters {
  print '-'x25, "\nCharacters:\n";
  for my $i (0..$#characters) {
    my $c = $characters[$i];
    print $i, "\t$c->{NAMEKEY}\t$c->{NAME}\n" unless $c->{DEAD};
  }
  print '-'x25, "\n";
}


# Interact with user
# args: default value, query string
sub query {
  my $default = shift;
  print "Turn $turn $phase: ", shift, ' or (q)uit> ';
  my $input;
  if ($restart && @log) {
    print $input = shift @log;
    chomp $input;
  }
  else { chomp($input = <STDIN>); }
  #   print "input is [$input]\n";
  print LOG "$input\n" unless $input eq 'q';
  return $default unless $input;
  die "Finished.\n" if $input eq 'q';
  $input;
}


# Character preparations
my $uniquify = 0;
my $msg_space;
sub character_prep {
  my $ci = shift;

  # Stun & fall thresholds
  my $char = $characters[$ci];
  my $st = $char->{ST};
  if ($st < 30) { $char->{STUN} = 5; $char->{FALL} = 8; } # normal
  elsif ($st < 50) { $char->{STUN} = 9; $char->{FALL} = 16; } # giants
  else { $char->{STUN} = 15; $char->{FALL} = 25; } # dragons
  $char->{STrem} = $st unless $char->{STrem};
  $char->{StunTurn} = 0;

  # Address some potential issues with names
  print "Replacing spaces with underscores in names\n"
      if $char->{NAME} =~ s/ /_/g && !$msg_space++;
  my $name = $char->{NAME};
  print "WARNING: Numeric character specifications are considered as namekeys before character indices.  Character index specifications are deprecated. (20aug021)\n" if $name =~ /^\d/;
  
  # Name keys
  my $len = 1;
  my $length = length $name;
  my $namekey = substr $name, 0, $len;
  $namekey = substr $name, 0, ++$len while $len <= $length && defined $charkeys{$namekey};
  if ($len > $length) {
    print "WARNING: namekey overflow.  Please use longer or more unique names.\n";
    $namekey .= $uniquify++;
  }
  $charkeys{$namekey} = $ci;
  $char->{NAMEKEY} = $namekey;
  # Is this good enough, or do I need to expand both keys? (27jul021)
  # Actually this could be better, e.g. if two people have the same first name.
}


# Act in order of dex
# Pass list of characters who will act
sub act {
  my %dexes; # key dex val array of character indices
  my @roll; # indexed by character index

  # Preparations
  for my $i (@_) {
    next if $characters[$i]->{DEAD};
    $debug && print "$characters[$i]->{NAME} has adjDX $dex[$i]\n";
    # Gather DEXes
    push @{$dexes{$dex[$i]}}, $i;
    # Roll initiative
    $roll[$i] = rand;
  }
  
  # Actions
  &displayCharacters;
  print 'Actions:
  * <who> - <dam> (e.g. c-4 for 4 damage to character c after armor)
  * s <dex adj>   ready or unready shield, which changes base adjDX
                  (e.g. s -2 to ready a tower shield)';
  print "* name ST adjDX (for created being)\n" if $phase =~ /n/;
  while (my $dex = max keys %dexes) { # assuming no one has 0 dex! (20apr021)
    $debug && print "Doing dex = $dex\n";
    my $ties = $dexes{$dex};
    unless (@$ties) {
      $debug && print "skipping empty dex slot $dex!\n";
      delete $dexes{$dex};
      next;
    }
    print "dex ${dex}s:\n"; # if @{$ties}; # 0+@{$ties}, " ties\n";

    # Sort characters with $dex by action initiative roll
    my @dex_ties = sort {$roll[$b] <=> $roll[$a]} @$ties;
#     $debug && print "character indices sorted by roll: @dex_ties\n";
    
    while (defined(my $act_char = shift @dex_ties)) {
#       next unless defined $ties->[$act_char];
      $debug && print "people with this dex: ties = @{$ties}\n";
      $debug && print "ordered: @dex_ties\n";
#       $debug && print "tie $act_char goes now, char $ties->[$act_char]\n";
      $debug && print "tie $act_char goes now\n";
#       next if $acted[$ties->[$act_char]];
#       die "$act_char already acted??" if $acted[$act_char];
      # dead characters already acted
      next if $acted[$act_char];
      my $c = $characters[$act_char];
      print "$c->{NAME}: ST $c->{ST} ($c->{STrem})  adjDX $dex";
      print " (stunned until turn $c->{StunTurn})" if $turn < $c->{StunTurn};
      # Stunned 'through this turn' or '... next turn'? (12aug021)
      print "\n";

      # Action query loop for character with index $act_char
      while (1) {
# 	my $action = query('', "$characters[$act_char]->{NAME} action result? (N)o");
	my $action = query('', "Action result? (N)o");
	$acted[$act_char] = 1;
	$debug && print "act_char=$act_char acted=$acted[$act_char]\n";
	if ($action =~ /(.+) ?- ?(\d+)/) { # Hit!
	  my $injuredi = who($1);
	  if ($injuredi<0) {
	    print "Invalid character specification: $1\n";
	    next;
	  }
	  print "Injuring self!  You must have rolled an 18 while attacking ",
	      "with your body\n" if $injuredi == $act_char;
	  my $chr = $characters[$injuredi];
	  my $damage = $2;
	  $debug && print "$characters[$act_char]->{NAME} hits $characters[$injuredi]->{NAME} for $damage damage\n";
	  ++$damaged[$injuredi] if $damage;
	  push @retreats, $act_char, $injuredi;
	  
	  # Reaction to Injury
	  print "$damage ST damage to $chr->{NAME}\n";
	  $chr->{STrem} -= $damage;
	  my $old_turn_damage = $turn_damage[$injuredi];
	  $old_turn_damage = 0 unless defined $old_turn_damage;
	  $turn_damage[$injuredi] += $damage;
	  print "$chr->{NAME} has taken $turn_damage[$injuredi] damage so far this turn, has $chr->{STrem} ST remaining\n"; 
	  my $turn_damage = $turn_damage[$injuredi];
	  my $olddex = $dex[$injuredi];
	  my $newdex = $dex[$injuredi];
	  if ($turn_damage >= $chr->{STUN} && $chr->{StunTurn} != $turn+2) {
	    print "$chr->{NAME} is stunned\n";
	    $chr->{StunTurn} = $turn+2;
	    $newdex -= 2;
	  }
	  $debug && print "turn_damage=$turn_damage  FALL=$chr->{FALL}  old_turn_damage=$old_turn_damage\n";
	  if ($turn_damage >= $chr->{FALL} && $old_turn_damage < $chr->{FALL}) {
	    print "$chr->{NAME} falls down\n";
	    $acted[$injuredi] = 1;
	  }
	  if ($chr->{STrem} <4) {
	    print "$chr->{NAME} is in bad shape...\n";
	    $newdex -= 3;
	  }
	  if ($chr->{STrem} <2) {
	    $chr->{DEAD} = 1;
	    if ($chr->{STrem} == 1) {print "$chr->{NAME} falls unconscious\n";}
	    else { print "$chr->{NAME} dies\n"; }
	    $acted[$injuredi] = 1;
	  }

	  # Push injured back in action order
	  $debug && print "push back? injuredi=$injuredi acted=$acted[$injuredi] olddex=$olddex newdex=$newdex\n";
	  if (!$acted[$injuredi] && $newdex < $olddex) {
	    # Don't have to worry about initiative order -- that is computed later for each $dex
	    # 	    for my $j (0..$#{$dexes{$olddex}}) {
	    # 	       if ($dexes{$olddex}->[$j] == $injuredi) {
	    # 		 splice @{$dexes{$olddex}},$j,1;
	    # 		 last;
	    # 	       }
	    # 	    }
	    # Below should replace above code (8aug021)
	    # https://metacpan.org/pod/List::MoreUtils#first_index-BLOCK-LIST
	    splice(@{$dexes{$olddex}},
		   (firstidx {$_==$injuredi} @{$dexes{$olddex}}), 1);
	    # Remove from current dex queue, if olddex = dex
	    if ($olddex==$dex) {
	      # Do I also need to remove $injuredi from @$dexes{$olddex}?  Presumably not. (8aug021)
	      # 	      for my $j (0..$#dex_ties) {
	      # 		if ($dex_ties[$j] == $injuredi) {
	      # 		  splice @dex_ties,$j,1;
	      # 		  last;
	      # 		}
	      # 	      }
	      # also have to remove injured from current @dex_ties
	      splice(@dex_ties, (firstidx {$_==$injuredi} @dex_ties), 1);
	    } #else { die "How did I get here??"; }
	    # Add to $dexes{$newdex}
	    push @{$dexes{$newdex}}, $injuredi;
	  } # push back in action order

	  last; # exit from while (1) damage query loop
	} # did damage
	elsif ($action =~ /^(.+) (\d+) (\d+)$/) { # Create being
	  print "$1 created with ST $2 adjDX $3\n";
	  print "Animals get automatic disbelieve roll\n";
	  # Not too sure how to handle this.  Will write explicit code for now, but should put into function which is shared with 'Read parties' code above. (29jul021)
	  $characters[$n]->{NAME} = $1;
	  $characters[$n]->{ST} = $2;
	  $characters[$n]->{STrem} = $2;
	  $characters[$n]->{adjDX} = $3;
	  $characters[$n]->{PLAYER} = $characters[$act_char]->{NAME};
	  $characters[$n]->{PARTY} = $characters[$act_char]->{PARTY};
	  character_prep($n++);
	  last; # always last after successful action result
	} # create being
	elsif ($action =~ /^s ([\d-]+)$/) { # change shield state
	  my $adjDX = $characters[$act_char]->{adjDX};
	  print $characters[$act_char]->{NAME}, $1>0 ? ' un' : ' ', "readies shield -- adjDX $adjDX --> ", $adjDX+$1, "\n";
	  $characters[$act_char]->{adjDX} += $1;
	}
	elsif (!$action) { last; } # exits action query for this character
	else { print "Unrecognized action $action\n"; }
      } # what happened during $act_char's action
    } # loop over ties
    delete $dexes{$dex};
  } # loop over dexes
}


# intiative, spell renewal, & movement
# pass me an array of alive entities
sub movement {
  my @ent = @_;
  
  # Initiative
  # ----------
  my @roll;
  for (my $i=0; $i<@ent; ++$i) { $roll[$i] = rand; }

  print "\nInitiative order:\n";
  my @order;
  my $prev_roll;
#   my $rank;
  my @moved; # who has moved so far
  foreach my $i (sort {$roll[$a] <=> $roll[$b]} 0..$#roll) {
    my $roll = $roll[$i];
    if (defined $prev_roll && $prev_roll == $roll) { die "Roll collision!\n"; }
    else { $prev_roll = $roll; }
#     unless ($characters[$i]->{DEAD}) {
#     print ++$rank, " $characters[$i]->{NAME}\n";
    print " $ent[$i]\n";
#     } else { $moved[$i] = 1; }
    push @order, $i;
  }

  print "\nSpell phase: Renew spells or they end now\n";
  # need to charge st cost for spells here (3jul021)
#   query('Finished with spells');

  # Movement
  # --------
  my $i = 0;
  my $last = $#ent; # queue index of last in queue
  $phase = 'movement';
  print "\nMovement phase:\n";
  # Trim dead people from end of order
#   --$last while $characters[$order[$last]]->{DEAD};

  while (1) {

    # skip over people who have gone already
    $debug && print "skipping over moved characters at front of queue\n";
    while ($moved[$order[$i]]) {
#       $debug && print "i=$i last=$last $characters[$order[$i]]->{NAME} already moved\n";
      ++$i;
    }

    if ($i == $last) {
#       print "$characters[$order[$i]]->{NAME} moves\n";
      print "$ent[$order[$i]] moves\n";
      $moved[$order[$i]] = 1;
      $i = 0;
      while ($last>=0 && $moved[$order[--$last]]) {}
    } else {
      $debug && print "order[$i]=$order[$i] last=$last\n";
#       my $move = query('d', "$characters[$order[$i]]->{NAME} (m)ove, or (D)efer");
      my $move = query('d', "$ent[$order[$i]] (m)ove, or (D)efer");
      if ($move eq 'm') {
	$moved[$order[$i]] = 1;
	--$last if $i==$last;
	$i = 0;
      }
      elsif ($move eq 'd') { ++$i; }
      else { print "unrecognized response [$move]\n"; }
    }
    last if $last<0;
  } # movement phase
}


# Returns character index to whom a string refers
# negative on error
sub who {
  my $s = shift;
  my $retval = $charkeys{$s};

  if (defined $retval) { return $retval; }
  elsif ($s =~ /^\d/) {
    if ($s<0 || $s >= $n) { return -2; }
    return $s;
  }
  -1;
}
