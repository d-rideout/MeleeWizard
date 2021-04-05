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
die "usage: melee.pl <party 1 file> <party 2 file> <party 3 file> ...\n"
    unless @ARGV;

# Data structures
my @characters;
# hkeys: NAME ADJDEX PLAYER PARTY
my $n = 0;

# Read parties
foreach my $partyfile (@ARGV) {
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
    print " $l[0]\n";
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

  print "Initiative order:\n";
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

  print "Renew spells or they end now\n";
#   query('Finished with spells');

  # Movement
  my @moved; # who has moved so far
  my $i = 0;
  my $last = $n-1;
  $phase = 'movement';
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
      } elsif ($move eq 'q') {
	die "aborting";
      } else { print "unrecognized response [$move]\n"; }
    }
    last if $last<0;
  } # movement phase

  die "finished with first turn";
#   query('Proceed to next turn');
} while ($turn++);


# Interact with user
# args: default value, query string
sub query {
  my $default = shift;
  print "Turn $turn $phase: ", shift, ' or (q)uit> ';
  chomp(my $input = <STDIN>);
#   print "input is [$input]\n";
  $turn = 0 if $input eq 'q';
  return $default unless $input;
  $input;
}
