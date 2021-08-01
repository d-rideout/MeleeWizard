#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw/sum/;

my %hist;

for (my $i=1; $i<7; ++$i) {
  for (my $j=1; $j<7; ++$j) {
    for (my $k=1; $k<7; ++$k) {	++$hist{tot($i, $j, $k)}; }}}

my $sum;
print "roll\tnum\tcum\tprob\n";
foreach (sort {$a <=> $b} keys %hist) {
  $sum += $hist{$_};
#   print "$_\t$hist{$_}\t$sum\t", $sum/216, "\n";
  printf "$_\t$hist{$_}\t$sum\t%5.1f\n", 100*$sum/216;
}


sub tot {
  my @rolls = @_; #sort @_;
#   print "@rolls\n";
#   my $d1 = shift;
#   my $d2 = shift;
  return $rolls[1]+$rolls[2]+$rolls[0];
}
