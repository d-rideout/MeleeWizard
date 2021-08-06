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

# Setting flags
my $debug = 0; # 1 ==> max debug output
my $initiative = 'c'; # c ==> character-based; p ==> party-based
                      # l ==> pLayer-based; s ==> 'side-based

# Check settings
die "Only character- and party-based initiative is currently implemented\n" unless $initiative =~ /^[cpl]$/;
# die "Only character-based initiative is currently implemented\n" unless $initiative =~ /^[c]$/;
# Side-based initiative is problematic -- I need to add it to the UI somehow.  Should be a property of parties.  Could group the input parties somehow on the command line?  Or maybe better -- have each party file declare a side name at the top! (2AUG021)

# Check command line
die "usage: melee.pl [-l] <party 1> <party 2> <party 3> ...\n" .
    "  -l ==> restart from log file\n" unless @ARGV;
my $restart;
if ($ARGV[0] eq '-l') {
  $restart = 1;
  shift @ARGV;
}

# Data structures
my @characters; # val hash with below keys
my %charkeys; # key namekey val index into @characters
my %hkeys = (NAME=>1, ST=>1, STrem=>1, adjDX=>1, PLAYER=>1, PARTY=>0, STUN=>0, FALL=>0, StunTurn=>0, DEAD=>0, NAMEKEY=>0);
# STUN how much damage causes stun
# StunTurn stunned until this turn
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
my @dex; # used in internal loop below, but needs to be accessed by &act
my @turn_damage; # amt damage sustained this turn for each character
my @acted; # who acted so far this turn

# Surprise
print "\nCapital letter is default\n";
my $q = query('n', 'Surprise? (y)es (N)o');
print "Sorry, not ready to handle this yet.\n" if $q eq 'y';
++$turn;

do {
  print "\n* Turn $turn:\n";

  # Movement
  # --------
  my @entities;
  if ($initiative eq 'c') {
    foreach my $c (@characters) {
      push @entities, $c->{NAME} unless $c->{DEAD};
    }
  }
  else {
    my $type = 'PARTY';
    $type = 'PLAYER' if $initiative eq 'l';
    my %entities;
    foreach my $c (@characters) {
      next if $c->{DEAD};
      my $ent = $c->{$type};
      push @entities, $ent unless $entities{$ent}++;
    }
  }
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
#   print "DEX adjustments?  Offset from original declared adj dex.  Ignore reactions to injury and weapon range penalties.\nwho +/- num [p|b] (e.g. 2+4p for char 2 doing rear attack as pole weapon charge; b ==> 2x shot with bow)\n";
  # In the future this will ask about pole weapon charges and doubled arrows (29jul021)
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
#       my $index = $1;
#       my $adj = $3;
#       $adj *= -1 if $2 eq '-';
	$dexadj[$who] = $cmd;
	my $plus = '+';
	$plus = '' if $cmd =~ /^[\+-]/;
	print " at $plus$cmd DEX = ", $characters[$who]->{adjDX}+$cmd;
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
  }

  # Act
  my @chars = 0..$n-1;
  @turn_damage = ();
  @acted = ();
  if (@poles) {
    $phase = 'pole weapon charges';
    print "Pole weapon charges:\n";
    act(@poles);
    splice @chars, $_, 1 foreach @poles;
  }
  $phase = 'normal actions';
  print "\nNormal attacks:\n";
  act(@chars);
  if (@bow2) {
    $phase = 'second missle shots';
    print "\nSecond bow attacks:\n";
    $debug && print "for @bow2\n";
    act(@bow2);
  }

  # Force Retreats
  print "\nForced Retreats phase: execute all forced retreats\n";
  $phase = 'forced retreats';
# I should probably record everything that happens in this phase, e.g. to
# decide about forced retreats
  
} while ($turn++);


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
sub character_prep {
  my $ci = shift;

  # stun & fall thresholds
  my $char = $characters[$ci];
  my $st = $char->{ST};
  if ($st < 30) { $char->{STUN} = 5; $char->{FALL} = 8; } # normal
  elsif ($st < 50) { $char->{STUN} = 9; $char->{FALL} = 16; } # giants
  else { $char->{STUN} = 15; $char->{FALL} = 25; } # dragons
  $char->{STrem} = $st unless $char->{STrem};
  $char->{StunTurn} = 0;

  # name keys
  my $name = $char->{NAME};
  my $len = 1;
  my $namekey = substr $name, 0, $len;
  $namekey = substr $name, 0, ++$len while defined $charkeys{$namekey};
  $charkeys{$namekey} = $ci;
  $char->{NAMEKEY} = $namekey;
  # Is this good enough, or do I need to expand both keys? (27jul021)
  # Actually this could be better, e.g. if two people have the same first name.
}


# Act in order of dex
sub act {
  # (not too sure how to handle changing one's mind -- add that later (4apr021))
  # Gather DEXes
  my %dexes; # key dex val array of character indices
  my @dexes_keys; # keys of %dexes, for looping
#   for $i (0..$n-1) {
  for my $i (@_) {
    push @{$dexes{$dex[$i]}}, $i;
    if ($characters[$i]->{DEAD}) { $acted[$i] = 1; }
    else { $acted[$i] = 0; }
  }
  # Act in order
  &displayCharacters;
  print "Actions:\n  who - dam (e.g. c-4 for 4 damage to character c after armor)\n";
  print "  name ST adjDX (for created being)\n" if $phase =~ /n/;
  @dexes_keys = sort {$b <=> $a} keys %dexes;
  $debug && print "dexes_keys = @dexes_keys\n";
#   foreach my $dex (sort {$b <=> $a} keys %dexes) { 
  while (my $dex = shift @dexes_keys) { # assuming no one has 0 dex! (20apr021)
    $debug && print "Doing dex = $dex\n";
    # Should I go though all this if there is no tie? (4apr021)
    my $ties = $dexes{$dex};
    unless (@$ties) {
      print "skipping empty dex slot $dex!\n";
      next;
    }
    print "dex ${dex}s:\n" if @{$ties}; # 0+@{$ties}, " ties\n";
    # roll initiative
    my @roll;
    foreach (0..$#{$ties}) { push @roll, rand; } # ignoring repeats (4apr021)
    my @dex_ties = sort {$roll[$b] <=> $roll[$a]} (0..$#{$ties});
    $debug && print "indices into ties sorted by roll: @dex_ties\n";
    while (defined(my $i = shift @dex_ties)) {
      next unless defined $ties->[$i];
      $debug && print "people with this dex: ties = @{$ties}\n";
      $debug && print "tie $i goes now, char $ties->[$i]\n";
      $debug && print "remaining ordered indices: @dex_ties\n";
      next if $acted[$ties->[$i]];
#       next if $acted[$i];
      while (1) {
	my $action = query('', "$characters[$ties->[$i]]->{NAME} action result? (N)o");
	$acted[$ties->[$i]] = 1;
	if ($action =~ /(.+) ?- ?(\d+)/) { # Hit!
	  my $injuredi = who($1);
	  if ($injuredi<0) {
	    print "Invalid character specification: $1\n";
	    next;
	  }
	  print 'Injuring self!  You must have rolled an 18 as an animal or '
	      . "in HTH combat...\n" if $injuredi == $ties->[$i];
	  my $chr = $characters[$injuredi];
	  my $damage = $2;
	  $debug && print "$characters[$ties->[$i]]->{NAME} hits $characters[$injuredi]->{NAME} for $damage damage\n";

	  # Reaction to Injury
	  print "$damage ST damage to $chr->{NAME}\n";
	  $chr->{STrem} -= $damage;
	  my $old_turn_damage = $turn_damage[$injuredi];
	  $old_turn_damage = 0 unless defined $old_turn_damage;
	  $turn_damage[$injuredi] += $damage;
	  print "$chr->{NAME} has taken $turn_damage[$injuredi] damage so far this turn\n"; 
	  my $turn_damage = $turn_damage[$injuredi];
	  my $olddex = $dex[$injuredi];
	  my $newdex = $dex[$injuredi];
	  if ($turn_damage >= $chr->{STUN} && $chr->{StunTurn} != $turn+2) {
	    print "$chr->{NAME} is stunned\n";
	    $chr->{StunTurn} = $turn+2;
	    $newdex -= 2;
	  }
	  $debug && print "turn_damage=$turn_damage  FALL=$chr->{FALL}  old_turn_damage=$old_turn_damage\n";
	  print "$chr->{NAME} falls down\n" if $turn_damage >= $chr->{FALL} &&
	      $old_turn_damage < $chr->{FALL};
	  if ($chr->{STrem} <4) {
	    print "$chr->{NAME} is in bad shape...\n";
	    $newdex -= 3;
	  }
	  if ($chr->{STrem} <2) {
	    $chr->{DEAD} = 1;
	    if ($chr->{STrem} == 1) {print "$chr->{NAME} falls unconscious\n";}
	    else {print "$chr->{NAME} dies\n";} # if $chr->{STrem} < 1;
	    $acted[$injuredi] = 1;
	  }

	  # Push injured back in action order
	  
	  # This below does not actually help -- does not remove injured from
	  # current dex loop if injured has current dex	  
	  if (!$acted[$injuredi] && $newdex < $olddex) {
	    # remove from %dexes, but I don't think this matters
	    for my $j (0..$#{$dexes{$olddex}}) {
	       if ($dexes{$olddex}->[$j] == $injuredi) {
		 splice @{$dexes{$olddex}},$j,1;
		 last;
	       }
	    }
	    # Remove from current dex queue, if olddex = dex
	    if ($olddex==$dex) {
	      for my $j (0..$#dex_ties) {
		if ($dex_ties[$j] == $injuredi) {
		  splice @dex_ties,$j,1;
		  last;
		}
	      }
	    }
	    # Add a new %dexes key, if there is not yet one for $newdex
	    unless ($dexes{$newdex}) {
	      push @dexes_keys, $newdex;
	      @dexes_keys = sort {$b <=> $a} @dexes_keys;
	    }
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
	  $characters[$n]->{PLAYER} = $characters[$ties->[$i]]->{NAME};
	  $characters[$n]->{PARTY} = $characters[$ties->[$i]]->{PARTY};
	  character_prep($n++);
	  last; # always last after successful action result
	} # create being
	elsif (!$action) { last; } # exits action query for this character
	else { print "Unrecognized action $action\n"; }
      } # what happened during $ties->[$i]'s action
    } # loop over ties
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
