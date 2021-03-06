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

my $debug = 0;

# Check command line
die "usage: melee.pl <party 1> <party 2> <party 3> ...\n"
    unless @ARGV;

# Data structures
my @characters; # val hash with below keys
my %hkeys = (NAME=>1, ST=>1, STrem=>1, ADJDEX=>1, PLAYER=>1, PARTY=>0, STUN=>0, FALL=>0, StunTurn=>0, DEAD=>0);
# 1 ==> can appear in party file
my $n = 0; # total number of characters

# Banner
$debug && print "Debug level $debug\n\n";

# Read parties
foreach my $partyfile (@ARGV) {
  unless (open FP, '<', $partyfile) {
    open FP, '<', "parties/$partyfile" or die "Error opening $partyfile: $!\n";
  }
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
    die "Please provide ADJDEX for all characters\n"
	unless $characters[$n]->{ADJDEX};
#     my $nhex = $characters[$n]->{NHEX};
#     die "Can only handle 1 or 3 hex characters currently\n"
    # 	unless $nhex==1 || $nhex==3;
    die "Please provide ST for each character\n" unless $chr->{ST};
    
    $characters[$n++]->{PARTY} = $partyfile;
  }
  close FP;
}
print "$n characters\n\n"; # with ", 0+@hkeys, " fields\n";
print "Capital letter is default\n";

# Preparations
# ------------
foreach (@characters) {
  my $st = $_->{ST};
  if ($st < 30) { $_->{STUN} = 5; $_->{FALL} = 8; } # normal
  elsif ($st < 50) { $_->{STUN} = 9; $_->{FALL} = 16; } # giants
  else { $_->{STUN} = 15; $_->{FALL} = 25; } # dragons
  $_->{STrem} = $st unless $_->{STrem};
  $_->{StunTurn} = 0;
}

# Manage combat sequence
# ----------------------
# Combat sequence phase
my $turn = 0;
my $phase = '';

# Surprise
my $q = query('n', 'Surprise? (y)es (N)o');
print "Sorry, not ready to handle this yet." if $q eq 'y';
++$turn;

do {
  print "\n* Turn $turn:\n";

  # Initiative
  # ----------
  my @roll;
  for (my $i=0; $i<$n; ++$i) { $roll[$i] = rand; }

  print "\nInitiative order:\n";
  my @order;
  my $prev_roll;
  my $rank;
  my @moved; # who has moved so far
  #my $ndead = 0;
  foreach my $i (sort {$roll[$a] <=> $roll[$b]} 0..$#roll) {
    my $roll = $roll[$i];
    if (defined $prev_roll && $prev_roll == $roll) { die "Roll collision!\n"; }
    else { $prev_roll = $roll; }
    unless ($characters[$i]->{DEAD}) {
      print ++$rank, " $characters[$i]->{NAME}\n";
    } else { $moved[$i] = 1; } # ++$ndead; }
    push @order, $i;
  }

  print "\nSpell phase: Renew spells or they end now\n";
  # need to charge st cost for spells here (3jul021)
#   query('Finished with spells');

  # Movement
  # --------
  my $i = 0;
  my $last = $n-1; # who is last in queue
  $phase = 'movement';
  print "\nMovement phase:\n";
  while (1) {

    # skip over people who have gone already
 #   while ($moved[$i] || $characters[$order[$i]]->{DEAD}) { ++$i; }
    while ($moved[$i]) { ++$i; }

    if ($i == $last) {
      print "$characters[$order[$i]]->{NAME} moves\n";
      $moved[$i] = 1;
      $i = 0;
      while ($last>=0 && $moved[--$last]) {}
    } else {
      my $move = query('d', "$characters[$order[$i]]->{NAME} (m)ove, or (D)efer");
      if ($move eq 'm') {
	$moved[$i] = 1;
	$i = 0;
      } elsif ($move eq 'd') { ++$i; }
      else { print "unrecognized response [$move]\n"; }
    }
    last if $last<0;
  } # movement phase

  # Actions
  # -------
  print "\nAction phase:\n";
  $phase = 'action';
  
  # Declare expected dex adjustments
  my @dexadj; # amt to add to ADJDEX
  &displayCharacters;
  print "DEX adjustments?  Offset from original declared adj dex.  Ignore reactions to injury.\nwho +/- num (e.g. 2+4 for char 2 doing rear attack)\n";
#   print "DEX adjustments?  Offset from original declared adjDX.  Include reactions to injury for now.\nwho +/- num (e.g. 2+4 for char 2 doing rear attack)\n";
  while (1) {
    my $dexadj = query('', "DEX adjustment, (F)inished");
    last unless $dexadj;
    if ($dexadj =~ /(\d+) ?(\+|-) ?(\d+)/) {
      my $index = $1-1;
      if ($index<0 || $index >= $n) {
	print "Invalid character index: $1\n";
	next;
      }
      my $adj = $3;
      $adj *= -1 if $2 eq '-';
      print "$characters[$index]->{NAME} at $2$3 DEX = ", $characters[$index]->{ADJDEX}+$adj, "\n";
      $dexadj[$index] = $adj;
    } else { print "Unrecognized adjustment $dexadj\n"; }
  } # query DEX adjustments
  print "\n";

  # Compute dex for this turn
  my @dex;
  for $i (0..$n-1) {
    my $chr = $characters[$i];
    
    $dex[$i] = $chr->{ADJDEX};
    $dex[$i] += $dexadj[$i] if $dexadj[$i];

    # Reactions to injury
    $dex[$i] -= 2 if $turn < $chr->{StunTurn};
    $dex[$i] -= 3 if $chr->{STrem} < 4;
  }

  # Act in order of dex
  # (not too sure how to handle changing one's mind -- add that later (4apr021))
  # Gather DEXes
  my %dexes; # key dex val array of indices
  my @dexes_keys; # keys of %dexes, for looping
  my @acted; # who acted this turn
  for $i (0..$n-1) {
    push @{$dexes{$dex[$i]}}, $i;
    if ($characters[$i]->{DEAD}) { $acted[$i] = 1; }
    else { $acted[$i] = 0; }
  }
  # Act in order
  &displayCharacters;
  print "Actions: who - dam (e.g. 2-4 for 4 damage to character 2 after armor)\n";
  @dexes_keys = sort {$b <=> $a} keys %dexes;
#   foreach my $dex (sort {$b <=> $a} keys %dexes) { 
  my @turn_damage;
  while (my $dex = shift @dexes_keys) { # assuming no one has 0 dex! (20apr021)
    # Should I go though all this if there is no tie? (4apr021)
    my $ties = $dexes{$dex};
    print "dex ${dex}s:\n"; # ", 0+@{$ties}, " ties\n";
    # roll initiative
    my @roll;
    foreach $i (0..$#{$ties}) { push @roll, rand; } # ignoring repeats (4apr021)
    my @dex_ties = sort {$roll[$b] <=> $roll[$a]} (0..$#{$ties});
    while (defined($i = shift @dex_ties)) {
      $debug && print "people with this dex: ties = @{$ties}\n";
      $debug && print "people with this dex: ties = @dex_ties\n";
      $debug && print "$i goes now\n";
      next if $acted[$ties->[$i]];
      while (1) {
	my $dam = query('', "$characters[$ties->[$i]]->{NAME} does damage? (N)o");
	if ($dam =~ /(\d+) ?- ?(\d+)/) {
	  my $injuredi = $1-1;
	  if ($injuredi<0 || $injuredi >= $n) {
	    print "Invalid character index: $1\n";
	    next;
	  }
	  if ($injuredi == $ties->[$i]) {
	    print "Did you really attack yourself??\n";
	    next;
	  }
	  my $chr = $characters[$injuredi];
	  my $damage = $2;

	  # Reaction to Injury
	  print "$damage ST damage to $chr->{NAME}\n";
	  $chr->{STrem} -= $damage;
	  $turn_damage[$injuredi] += $damage;
	  print "$chr->{NAME} has taken $turn_damage[$injuredi] damage so far this turn\n"; 
	  my $turn_damage = $turn_damage[$injuredi];
	  my $olddex = $dex[$injuredi];
	  my $newdex = $dex[$injuredi];
	  if ($turn_damage >= $chr->{STUN}) {
	    print "$chr->{NAME} is stunned\n";
	    $chr->{StunTurn} = $turn+2;
	    $newdex -= 2;
	  }
	  print "$chr->{NAME} falls down\n" if $turn_damage >= $chr->{FALL};
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

	  # Record that $ties->[$i] acted
# 	  print "i=$i\n";
	  $acted[$ties->[$i]] = 1;

	  # Push injured back in action order?
# 	  need to pull injuredi out of ties array if $dex == $olddex
# 	      but how does that interact with the loop structure?
	  # 	      either change loop or build special case to skip this person

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
	} elsif (!$dam) { last; }
	else { print "Unrecognized damage $dam\n"; }
      } # what happened
    } # loop over ties
  } # loop over dexes
  
# I should probably record everything that happens in this phase, e.g. to
# decide about forced retreats, and to manage reactions to injury...

  # Force Retreats
  print "\nForced Retreats phase: execute all forced retreats\n";
  $phase = 'forced retreats';
  
#   die "Finished with first turn\n";
#   query('Proceed to next turn');
} while ($turn++);


# Display characters
sub displayCharacters {
  print '-'x25, "\nCharacters:\n";
  for my $i (0..$#characters) {
    print $i+1, "\t$characters[$i]->{NAME}\n" unless $characters[$i]->{DEAD};
  }
  print '-'x25, "\n";
}


# Interact with user
# args: default value, query string
sub query {
  my $default = shift;
  print "Turn $turn $phase: ", shift, ' or (q)uit> ';
  chomp(my $input = <STDIN>);
#   print "input is [$input]\n";
  return $default unless $input;
  die "Finished.\n" if $input eq 'q';
  $input;
}
