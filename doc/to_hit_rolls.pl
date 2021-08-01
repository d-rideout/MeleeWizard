#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw/sum/;

my %hist3;
my %hist4;

for (my $i=1; $i<7; ++$i) {
  for (my $j=1; $j<7; ++$j) {
    for (my $k=1; $k<7; ++$k) {
      ++$hist3{sum($i, $j, $k)};
      for my $l (1..6) { ++$hist4{sum($i, $j, $k, $l)}; }}}}

my $sum;
print "3d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist3) {
  $sum += $hist3{$_};
#   print "$_\t$hist{$_}\t$sum\t", $sum/216, "\n";
  printf "$_\t$hist3{$_}\t$sum\t%5.1f\n", 100*$sum/216;
}

$sum = 0;
print "\n4d6:\n";
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist4) {
  $sum += $hist4{$_};
#   print "$_\t$hist{$_}\t$sum\t", $sum/216, "\n";
  printf "$_\t$hist4{$_}\t$sum\t%5.1f\n", 100*$sum/1296;
}


# sub tot {
#   my @rolls = @_; #sort @_;
# #   print "@rolls\n";
# #   my $d1 = shift;
# #   my $d2 = shift;
#   return $rolls[1]+$rolls[2]+$rolls[0];
# }
