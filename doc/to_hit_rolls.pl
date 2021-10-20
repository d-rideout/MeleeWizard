#!/usr/bin/perl
# Compute probabilities of sums of dice
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
use List::Util qw/sum/;

my %hist2;
my %hist3;
my %hist4;
my %hist5;

for (my $i=1; $i<7; ++$i) {
  for (my $j=1; $j<7; ++$j) {
    ++$hist2{sum($i,$j)};
    for (my $k=1; $k<7; ++$k) {
      ++$hist3{sum($i, $j, $k)};
      for my $l (1..6) {
	++$hist4{sum($i, $j, $k, $l)};
	++$hist5{sum($i, $j, $k, $l, $_)} for (1..6);
      }}}}

my $sum;
print "2d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist2) {
  $sum += $hist2{$_};
  printf "$_\t$hist2{$_}\t$sum\t%5.1f\n", 100*$sum/36;
}

$sum = 0;
print "\n3d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist3) {
  $sum += $hist3{$_};
  printf "$_\t$hist3{$_}\t$sum\t%5.1f\n", 100*$sum/216;
}

$sum = 0;
print "\n4d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist4) {
  $sum += $hist4{$_};
  printf "$_\t$hist4{$_}\t$sum\t%5.1f\n", 100*$sum/1296;
}

$sum = 0;
print "\n5d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist5) {
  $sum += $hist5{$_};
  printf "$_\t$hist5{$_}\t$sum\t%5.1f\n", 100*$sum/6**5;
}
