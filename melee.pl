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

# my $debug = 1;

# Check command line
die "usage: melee.pl <party 1> <party 2> <party 3> ...\n"
    unless @ARGV;

# Data structures
my @characters;
# hkeys: NAME ADJDEX PLAYER PARTY
my $n = 0;

# Read parties
foreach my $partyfile (@ARGV) {
  $partyfile = "parties/$partyfile" unless $partyfile =~ /^parties\//;
  open FP, "<$partyfile" or die "Error opening $partyfile: $!\n";
  print "Reading party $partyfile:\n";
  my $tmp;
  # ignore leading comments
  do {
    chomp($tmp = <FP>);
  } while $tmp =~ /^#/;
  # read header of key names
  my @hkeys = split /\t/, $tmp;
  while (<FP>) {
    next if /^#/;
    chomp;
    next unless $_;
    my @l = split /\t/;
    print $n+1, "\t$l[0]\n";
    foreach my $i (0..$#hkeys) {
      $characters[$n]->{$hkeys[$i]} = $l[$i];
    }
    $characters[$n++]->{PARTY} = $partyfile;
  }
  close FP;
}
print "$n characters\n\n"; # with ", 0+@hkeys, " fields\n";
print "Capital letter is default\n";

# Manage combat sequence
# ----------------------
# Combat sequence phase
my $turn = 0;
my $phase = ''; #power spells';
# movement
# action
# force retreats

# Surprise
my $q = query('n', 'Surprise? (y)es (N)o');
print "Sorry, not ready to handle this yet." if $q eq 'y';
++$turn;

do {
  print "\n* Turn $turn:\n";

  # Initiative
  my @roll;
  for (my $i=0; $i<$n; ++$i) {
    $roll[$i] = rand;
  }
#   print "@roll\n";

  print "\nInitiative order:\n";
  my @order;
#   foreach (keys %names) {
#     $names{$_} = rand;
# #     print "$_\t$names{$_}\n";
#   }
# #   print "\n";
  my $prev_roll;
  my $rank;
  foreach my $i (sort {$roll[$a] <=> $roll[$b]} 0..$#roll) {
    my $roll = $roll[$i];
    if (defined $prev_roll && $prev_roll == $roll) { die "Roll collision!\n"; }
    else { $prev_roll = $roll; }
#     print "$i\n";
#     print "$characters[$i]\n";
    print ++$rank, " $characters[$i]->{NAME}\n";
    push @order, $i;
  }

  print "\nSpell phase: Renew spells or they end now\n";
#   query('Finished with spells');

  # Movement
  my @moved; # who has moved so far
  my $i = 0;
  my $last = $n-1;
  $phase = 'movement';
  print "\nMovement phase:\n";
  while (1) {

    # skip over people who have gone already
    while ($moved[$i]) { ++$i; }

    # move $i
#     my $name;
#     until ($i<$n && $name = $stack[$i++]) {}
#     print $name;
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
	#       next;
      } elsif ($move eq 'd') {
	++$i;
	#  elsif ($move eq 'q') {
	# 	die "Finished.";
      } else { print "unrecognized response [$move]\n"; }
    }
    last if $last<0;
  } # movement phase

  # Actions
  print "\nAction phase:\n";
  $phase = 'action';
  #   declare expected dex adjustments
#   my $dexadj = 1;
  my @dexadj;
  print "DEX adjustments?  Offset from original declared adj dex.  Ignore reactions to injury.\nwho +/- num (e.g. 2+4 for char 2 doing rear attack)\n";
  while (1) {
    my $dexadj = query('', "DEX adjustment");
    last unless $dexadj; # get rid of redundancy above!
    if ($dexadj =~ /(\d+) ?(\+|-) ?(\d+)/) {
      my $index = $1-1;
      if ($index<0 || $index > $n) {
	print "Invalid character index: $1\n";
	next;
      }
      my $adj = $3;
      $adj *= -1 if $2 eq '-';
      print "$characters[$index]->{NAME} at $2$3 DEX = ", $characters[$index]->{ADJDEX}+$adj, "\n";
      $dexadj[$index] = $adj; # when do I add them together? (4apr021)
    }
  }

  # Compute dex for this turn
  my @dex;
  for $i (0..$n-1) {
    $dex[$i] = $characters[$i]->{ADJDEX};
    $dex[$i] += $dexadj[$i] if $dexadj[$i];
  }

  # Move in order of dex
  # (not too sure how to handle changing one's mind -- add that later (4apr021))
  my %dexes; # key dex val array of indices
  for $i (0..$n-1) {
    push @{$dexes{$dex[$i]}}, $i;
  }
#   foreach $i (sort {$dex[$b] <=> $dex[$a]} (0..$n-1)) {
  foreach my $dex (sort {$b <=> $a} keys %dexes) {
    # Should I go though all this if there is no tie? (4apr021)
    my $ties = $dexes{$dex};
    print "dex ${dex}s:\n"; # ", 0+@{$ties}, " ties\n";
    # roll initiative
    my @roll;
    foreach $i (0..$#{$ties}) {
      push @roll, rand; # ignoring repeats here (4apr021)
    }
    foreach $i (sort {$roll[$b] <=> $roll[$a]} (0..$#{$ties})) {
#       print $ties->[$i]+1, " rolled a $roll[$i]\n";
      print "$characters[$ties->[$i]]->{NAME} goes\n";
    }
  }
  
# i should probably record everything that happens in this phase, e.g. to decide about forced retreats, and to manage reactions to injury

  # Force Retreats
  print "\nForced Retreats phase: execute all forced retreats\n";
  $phase = 'forced retreats';
  
#   die "Finished with first turn\n";
#   query('Proceed to next turn');
} while ($turn++);


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
