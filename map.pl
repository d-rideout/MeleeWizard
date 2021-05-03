#!/usr/bin/env perl
# Draw a hex map
use strict;
use warnings;

my $n = 7;
# for (0..6) {
print ' --', '    --'x$n, "\n";

for (0..0) {
  print '/  \\', '  /  \\'x$n, "\n";
  print ' xx', ' -- xx'x$n, "\n";
  print '\\  /', '  \\  /'x$n, "\n";
  print ' --', ' xx --'x$n, "\n";
}

print '/  \\', '  /  \\'x$n, "\n";
print ' xx', ' -- xx'x$n, "\n";
print '\\  /', '  \\  /'x$n, "\n";
print ' --', '    --'x$n, "\n";
