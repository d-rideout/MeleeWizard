#!/usr/bin/env perl
# Draw a hex map
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
