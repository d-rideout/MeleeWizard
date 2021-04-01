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
die "usage: melee.pl <infile>\n" unless @ARGV==1;
my $infile = shift;

# Initialize
open FP, "<$infile" or die "Error opening $infile: $!\n";
my %names;
while (<FP>) {
  chomp;
  $names{$_} = 0;
}
close FP;

# Manage combat sequence
my $turn = 1;
do {
  print "\n* Turn $turn:\n";

  # Initiative
  print "Initiative order:\n";
  my @stack;
  foreach (keys %names) {
    $names{$_} = rand;
#     print "$_\t$names{$_}\n";
  }
#   print "\n";
  my $prev_roll;
  my $rank;
  foreach (sort {$names{$a} <=> $names{$b}} keys %names) {
    my $roll = $names{$_};
    if (defined $prev_roll && $prev_roll == $roll) {
      die "Roll collision!!\n";
    } else {
      $prev_roll = $roll;
    }
    print ++$rank, " $_\n";
    push @stack, $_;
  }

  print "Renew spells\n";
  query('Finished with spells');

  # Movement
  do {

    # Select next move
    my $i = 0;
    my $name;
    until ($i<$n && $name = $stack[$i++]) {}
    print $name;
    my $move = query(" move, (d)efer");
    unless $move

  }

#   query('Proceed to next turn');
} while ($turn++);


# Interact with user
sub query {
  print shift, ' or (q)uit> ';
  chomp(my $input = <>);
  $turn = 0 if $input eq 'q';
  $input;
}


# It would be faster to use array indices as identifiers, and keep the names in an array...  Hmm?
# my $n = @names;
# my @roll;
# for (my $i=0; $i<$n; ++$i) {
#   $roll[$i] = rand;
# }
# print "@roll\n";
