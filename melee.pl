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
  chomp(my $tmp = <FP>);
  my @hkeys = split /\t/, $tmp;
  while (<FP>) {
    chomp;
    next unless $_;
    my @l = split /\t/;
    foreach my $hkey (@l) {
      $characters[$n]->{$hkey} = $_;
    }
    $characters[$n++]->{PARTY} = $partyfile;
  }
  close FP;
}
print "$n characters\n"; # with ", 0+@hkeys, " fields\n";
print "Capital letter is default\n";

# Manage combat sequence
# ----------------------
# Surprise
my $q = query('n', 'Surprise? (y)es (N)o');
print "Sorry, not ready to handle this yet." if $q eq 'y';

my $turn = 1;
do {
  print "\n* Turn $turn:\n";

  # Initiative

# my @roll;
# for (my $i=0; $i<$n; ++$i) {
#   $roll[$i] = rand;
# }
# print "@roll\n";

  print "Initiative order:\n";
#   my @stack;
#   foreach (keys %names) {
#     $names{$_} = rand;
# #     print "$_\t$names{$_}\n";
#   }
# #   print "\n";
#   my $prev_roll;
#   my $rank;
#   foreach (sort {$names{$a} <=> $names{$b}} keys %names) {
#     my $roll = $names{$_};
#     if (defined $prev_roll && $prev_roll == $roll) {
#       die "Roll collision!!\n";
#     } else {
#       $prev_roll = $roll;
#     }
#     print ++$rank, " $_\n";
#     push @stack, $_;
#   }

  print "Renew spells\n"; # Does this come before rolling for initiative?
#   query('Finished with spells');

  # Movement
#   do {
# 
#     # Select next move
#     my $i = 0;
#     my $name;
# #     until ($i<$n && $name = $stack[$i++]) {}
#     print $name;
#     my $move = query(" move, (d)efer");
# #     unless $move
# 
#   }

  die;
#   query('Proceed to next turn');
} while ($turn++);


# Interact with user
# args: default value, query string
sub query {
  my $default = shift;
  print shift, ' or (q)uit> ';
  chomp(my $input = <STDIN>);
#   print "input is [$input]\n";
  $turn = 0 if $input eq 'q';
  return $default unless $input;
  $input;
}
