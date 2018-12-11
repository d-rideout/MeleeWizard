#!/usr/bin/env perl
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
  print "\nTurn $turn\n";
  foreach (keys %names) {
    $names{$_} = rand;
#     print "$_\t$names{$_}\n";
  }
#   print "\n";
  
  my $prev_roll;
  foreach (sort {$names{$a} <=> $names{$b}} keys %names) {
    my $roll = $names{$_};
    if (defined $prev_roll && $prev_roll == $roll) {
      die "Roll collision!!\n";
    } else {
      $prev_roll = $roll;
    }
    print "$_\n";
  }
  print "q to quit ";
  chomp(my $input = <>);
  $turn = 0 if $input eq 'q';

} while ($turn++);

# It would be faster to use array indices as identifiers, and keep the names in an array...  Hmm?
# my $n = @names;
# my @roll;
# for (my $i=0; $i<$n; ++$i) {
#   $roll[$i] = rand;
# }
# print "@roll\n";
