#!/usr/bin/env perl
# Draw a hex map
use strict;
use warnings;

my $n = 7;
my $x;
my $y = 'a';
print ' --', '    --'x$n, "\n";

for (0..1) {
  $x = 'a';
  print '/  \\', '  /  \\'x$n, "\n";
  print " $x$y", (" -- ".++$x.$y)x$n, "\n";
  print '\\  /', '  \\  /'x$n, "\n";
  ++$y;
  print ' --', " $x$y --"x$n, "\n";
}
++$y;
print '/  \\', '  /  \\'x$n, "\n";
print " $x$y", " -- $x$y"x$n, "\n";
print '\\  /', '  \\  /'x$n, "\n";
print ' --', '    --'x$n, "\n";


# 't' for top hex; 'b' for bottom; or $x$y of SW hex for neither
sub draw_hex {
  my $x = shift;
  my $y = shift;
  my $border = shift;

  ...
