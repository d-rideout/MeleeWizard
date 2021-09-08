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
use List::Util qw/max/;
# use List::MoreUtils qw/firstidx any/;

# Setting flags
my $debug = 0; # 1 ==> max debug output
my $initiative = 'c'; # c ==> character-based; p ==> party-based
                      # l ==> pLayer-based; s ==> 'side-based

# Check settings
die "Side-based initiative is not implemented yet\n" unless $initiative =~ /^[cpl]$/;
# die "Only character- party-based initiative is currently implemented\n" unless $initiative =~ /^[cpl]$/;
# die "Only character-based initiative is currently implemented\n" unless $initiative =~ /^[c]$/;
# Side-based initiative is problematic -- I need to add it to the UI somehow.  Should be a property of parties.  Could group the input parties somehow on the command line?  Or maybe better -- have each party file declare a side name at the top! (2AUG021)

# Banner
print 'Melee/Wizard turn sequence tool  Copyright (C) 2021  David P. Rideout
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under the
conditions of the GNU GENERAL PUBLIC LICENSE Version 3; see LICENSE file.
';
# This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
#     This is free software, and you are welcome to redistribute it
#     under certain conditions; type `show c' for details.
$debug && print "Debug level $debug\n";
print "\n";

# Check command line
my $restart;
if (@ARGV && $ARGV[0] eq '-l') {
  $restart = 1;
  shift @ARGV;
}
die "Usage: melee.pl [-l] <party 1> <party 2> <party 3> ...\n" .
    "  -l ==> restart from log file\n" unless @ARGV;

# Data structures
my @characters; # val hash with below keys
my %charkeys; # key namekey val index into @characters
my %hkeys = (NAME=>1, ST=>1, STrem=>1, adjDX=>1, PLAYER=>1, PARTY=>0, STUN=>0, FALL=>0, StunTurn=>0, DEAD=>0, NAMEKEY=>0, BAD=>1);
# STUN how much damage causes stun
# StunTurn becomes unstunned on this turn
# FALL how much damage causes fall
# 1 ==> can appear in party file
my $n = 0; # total number of characters
my $ncommands=0; # number of user entered commands

# Read parties
foreach my $partyfile (@ARGV) {
  unless (open FP, '<', $partyfile) {
    open FP, '<', "parties/$partyfile" or die "Error opening $partyfile: $!\n";
  }
  $partyfile =~ s/^parties\///; # strip parties/ off party names
  print "Reading party $partyfile:\n";
  my $tmp;
  # ignore leading comments
  do { chomp($tmp = <FP>); } while $tmp =~ /^#/;
  # read header of key names
  my @hkeys = split /\t/, $tmp;
  # Check that all headers are valid
  foreach (@hkeys) { die "Unrecognized field: $_\n" unless $hkeys{$_}; }
  while (<FP>) {
    next if /^#/;
    next unless /[^\s]/; # ignore pure-whitespace lines
    chomp;
#     next unless $_; should not be needed anymore (5sep021)
    my @l = split /\t/;
    print $n+1, "\t$l[0]\n"; # I hope they put name first! (5sep021)
    foreach my $i (0..$#hkeys) {
      $characters[$n]->{$hkeys[$i]} = $l[$i];
    }

    # Check some field values
    my $chr = $characters[$n];
    die "Please provide adjDX for all characters\n"
	unless $characters[$n]->{adjDX};
#     my $nhex = $characters[$n]->{NHEX};
#     die "Can only handle 1 or 3 hex characters currently\n"
    # 	unless $nhex==1 || $nhex==3;
    die "Please provide ST for each character\n" unless $chr->{ST};
    $characters[$n++]->{PARTY} = $partyfile;
  }
  close FP;
}
print "$n characters\n\n"; # with ", 0+@hkeys, " fields\n";

# Preparations
# ------------
foreach my $ci (0..$#characters) { character_prep($ci); }

# Open log file
# -------------
my @log;
my $seed;
if ($restart) {
  open LOG, '<log' or die "problem reading log file";
  chomp($seed = <LOG>);
  srand $seed;
  @log = <LOG>;
  close LOG;
} else {
  $seed = srand;
  print "\nOverwrite log file? (interrupt (Ctrl-C) if not!)"; <STDIN>;
 }
open LOG, '>log' or die "problem creating log file";
print LOG "$seed\n";

# Manage combat sequence
# ======================
my $turn = 0;
my $phase = ''; # Combat sequence phase
# my @dex; # adjDX for each character for this turn
my @turn_damage; # amt damage sustained this turn for each character
my @acted; # who acted so far this turn, for handling reactions to injuries
# my @damaged; # who has taken damage this turn [why not just use @turn_damage??]
my %retreats; # possible forced retreats  key forcer val hash key forced val num
my @dxmod = (0) x $n; # amt to add to adjDX for this turn
my @dxinj = (0) x $n; # amt to add to adjDX due to injury
my @roll; # action initiative roll, indexed by character index
my $maxdx; # adjDX of acting character

print "\nCapital letter is default option for each prompt\n\n";

# Main loop
while (1) {
  # Surprise
  my %surprise_parties;
  unless ($turn) {
    my $q = query('n', 'Surprise? (y)es (N)o');
    if ($q eq 'y') {
      # Generate list of suprised parties
      # I assume no one can be dead yet?
      ++$surprise_parties{$_->{PARTY}} foreach @characters;
      # no don't use an array.  Leave the surprised parties in a hash.
#       my @surprise_parties = keys %parties;
      foreach (keys %surprise_parties) { #my $i (0..$#surprise_parties) {
# 	$q = query('y', "Is $surprise_parties[$i] surprised? (Y)es (n)o");
# 	splice @surprise_parties, $i, 1 unless $q eq 'y';
	$q = query('y', "Is $_ surprised? (Y)es (n)o");
	delete $surprise_parties{$_} unless $q eq 'y';
      }
      # Below if !$turn && $surprise_parties{...PARTY} then skip that character
#       die "If no parties are surprised then please accept the default '(N)o' for  the 'Surprise?' question\n" unless keys %surprise_parties;
    } else { ++$turn; }
  }

  print "\n* Turn $turn:\n";

  # Movement
  # --------
  my @entities;
  if ($initiative eq 'c') {
    foreach my $c (@characters) {
      next unless $turn || !$surprise_parties{$c->{PARTY}};
      push @entities, $c->{NAME} unless $c->{DEAD};
    }
  }
  else {
    my $type = 'PARTY';
    $type = 'PLAYER' if $initiative eq 'l';
    my %entities;
    foreach my $c (@characters) {
      next unless $turn || !$surprise_parties{$c->{PARTY}};
      next if $c->{DEAD};
      my $ent = $c->{$type};
      push @entities, $ent unless $entities{$ent}++;
    }
  }
  die "There is no one available to move!\n" unless @entities;
  movement(@entities);
  
  # Actions
  # -------
  print "\nAction phase:\n";
  
  # Declare expected dex adjustments and other special considerations
  my @poles; # pole weapon charges
  my @bow2;  # double bow attacks

  $phase = 'action consideration';
  &displayCharacters;
  print 'Special considerations: <who> <consideration1> [consideration2]
  Considerations are
  * <adj>
    DEX adjustments as offset from original declared adjDX.  
    Ignore reactions to injury and weapon range penalties.
  * <c|b>
    c ==> pole weapon charge
    b ==> double shot with bow
  e.g. "2 -4 p" for char 2 doing rear attack as pole weapon charge
  * sh<adj>
    \'Permanently\' ready or unready a shield
';
  while (1) {
#     my $sccmd = query('', "Special consideration, (F)inished");
    my $sccmd = query('', "(F)inished");
    last unless $sccmd;
    my @sccmd = split / +/, $sccmd;
    my $who = who(shift @sccmd);
    next if $who eq 'x';
# ) {
# #       print "Invalid character specification $who\n";
#       next;
#     }
    print "$characters[$who]->{NAME}";
    foreach my $cmd (@sccmd) {
      if ($cmd =~ /^\+?-?\d+$/) { #(\+|-) ?(\d+)( ?([pm]))?/) {
	$dxmod[$who] = $cmd;
	my $plus = '+';
	$plus = '' if $cmd =~ /^[\+-]/;
	print " at $plus$cmd DEX = ", $characters[$who]->{adjDX}+$cmd, ' (- injury adjustments)';
      } elsif ($cmd eq 'c') {
	push @poles, $who;
	print " charging with pole weapon";
      } elsif ($cmd eq 'b') {
	push @bow2, $who;
	print " double shot with bow";
      } elsif (shield($characters[$who], $cmd)) {}
      else { print "\nUnrecognized consideration [$cmd]\n"; }
    } # loop over considerations for this character
    print "\n";
  } # special considerations
  print "\n";

  # Compute dx mods due to injury
  for my $i (0..$n-1) {
    my $chr = $characters[$i];
    
#     $dex[$i] = $chr->{adjDX};
#     $dex[$i] += $dexadj[$i] if $dexadj[$i]; # (it might be undefined!)

    # Reactions to injury
    $dxinj[$i] = 2 if $turn < $chr->{StunTurn};
#     $dex[$i] -= 3 if $chr->{STrem} < 4;
    # I have to keep track of the two different types of damage for wizards (7aug021)
    $dxinj[$i] -= 3 if $chr->{BAD} && $chr->{STrem} < 4;
  }

  # Act
  my @chars = 0..$n-1;
  $phase = 'action';
  unless ($turn) { # prune surprised characters
    foreach (my $i=$#chars; $i>=0; --$i) { # ($#chars..0) {
      splice @chars, $i, 1 if $surprise_parties{$characters[$i]->{PARTY}};
#       $debug && print "prunned suprised character $characters[$i]
    }
  }
      
  @turn_damage = ();
  @acted = ();
#   @damaged = (); # who has taken damage this turn
  %retreats = (); # possible forced retreats (I think perl is smart about
                  # freeing each hash value? (3sep021))
  if (@poles) {
    $phase = 'pole weapon charges';
    print "Pole weapon charges:\n";
    act(@poles);
    # remove @poles from @chars
#     foreach my $p (@poles) { splice @chars, (firstidx {$_==$p} @chars), 1; }
    # Above seems pretty slow.  This complication only because of surprise round. Rethink all this? (20aug021)
    # It should not be necessary to remove the poles, no?  They will have @acted so will get skipped anyway.
  }
  $phase = 'normal actions';
  print "\nNormal attacks:\n";
  # prune dead characters here?  They may die during this act() call too. (7aug021)
  # (Not sure what I was getting at.  Dead characters get skipped within &act.  No need to prune. (5sep021))
  act(@chars);
  if (@bow2) {
#     my $i;
    !$characters[$_]->{DEAD} && (@acted[$_] = 0) foreach @bow2;
    $phase = 'second missle shots';
    print "\nSecond bow attacks:\n";
    $debug && print "for @bow2\n";
    act(@bow2);
  }

  # Force Retreats
# Forced Retreats phase: Any figure which has inflicted attack hits on an adjacent
#   figure and has not taken damage this turn may execute a forced retreat on the
#   adjacent figure.  (Attack hits include any physical attack and missle spells.)
  $phase = 'forced retreats';
  print "\nPossible Forced Retreats: (if two chacters are adjacent)\n";
  print "None.\n" unless keys %retreats;
#   for (my $i=0; $i<@retreats; $i+=2) {
  foreach my $forcer (keys %retreats) {
#     my $who = $retreats[$i];
#     print "$characters[$who]->{NAME} on $characters[$retreats[$i+1]]->{NAME}?\n" unless $damaged[$who];
    next if $turn_damage[$forcer];
    foreach my $forced (keys %{$retreats{$forcer}}) {
      print "$characters[$forcer]->{NAME} on $characters[$forced]->{NAME}?\n";
    }
  }
#   print "\n";
  
  ++$turn;
}


# Display characters
sub displayCharacters {
  print '-'x26, "\nCharacters:\n";
  for my $i (0..$#characters) {
    my $c = $characters[$i];
    print $i, "\t$c->{NAMEKEY}\t$c->{NAME}\n" unless $c->{DEAD};
  }
  print '-'x26, "\n";
}


# Interact with user
# args: default value, query string
sub query {
  my $default = shift;
  my $query = shift;
  my %global_options = (q=>'n', '?'=>'n', u=>'n'); #, d=>l); # l ==> log; n ==> no log

  while (1) {
    #   print "Turn $turn $phase: ", shift, ' or (q)uit> ';
#     print "Turn $turn $phase: ", $query, ' or global option, (?) for list> ';
    print "Turn $turn $phase: ", $query, ' or (?) for global options> ';
    my $input;
    if ($restart && @log) {
      print $input = shift @log;
      chomp $input;
    }
    else { chomp($input = <STDIN>); }
    #   print "input is [$input]\n";
    #   print LOG "$input\n" unless $input eq 'q';
    my $cmd = substr $input, 0, 1;
    unless ($global_options{$cmd} && $global_options{$cmd} eq 'n') {
      print LOG "$input\n";
      ++$ncommands;
    }
    return $default unless $input;

    # Process global options
    if ($global_options{$cmd}) {
      die "Finished.\n" if $input eq 'q'; # Do we need to exit instead? (4sep021)
      if ($input eq '?') { print '(u <n>) to undo n previous entries;
' .
#(d <who> <DX mod>) to adjust <who>\'s DX by <DX mod>;
'or (q) to quit
'; }
#       elsif ($input =~ /^d (.+) ([-\d]+)$/) {
# 	my $who = who($1);
# 	my $c = $characters[$who];
# 	$c- ... This is really complicated.  I wonder if I should recompute the entire ordering for each character, since anything might change at any moment...
# 	print "$c->{NAME} adjDX ", $2>=0 ? '+':'', "$2 --> $c->{adjDX}
# 	print "DX modifications during another characters action (e.g. due to a Rope, Blur, Clumsiness spell) is not implemented yet.\n"; }
      elsif ($input =~ /^u ?(\d+)$/) {
	print "undoing previous $1 commands and restarting...\n\n";
	if ($1>$ncommands) {
	  print "There have only been $ncommands commands so far!\n";
	  next;
	}
	close LOG;
	system "head -n -$1 log > .junk";
	system 'mv .junk log';
	exec "./melee.pl -l @ARGV";
      } else { print "error in global option [$input]\n"; }
    } else { return $input; }
  }
  
  #   $input;
  'error'; # should never get here?
}


# Character preparations
# How are these declarations working?  Don't they have to appear above?? (28aug021)
# my $uniquify = 0;
my $msg_space; # Did we output a message about spaces in character names?
my %namekeys; # key character val char index or hash of next level of %namekeys ...
sub character_prep {
  my $ci = shift;

  # Stun & fall thresholds
  my $char = $characters[$ci];
  my $st = $char->{ST};
  if ($st < 30) { $char->{STUN} = 5; $char->{FALL} = 8; } # normal
  elsif ($st < 50) { $char->{STUN} = 9; $char->{FALL} = 16; } # giants
  else { $char->{STUN} = 15; $char->{FALL} = 25; } # dragons
  $char->{STrem} = $st unless $char->{STrem};
  $char->{StunTurn} = 0;
  if (!$char->{BAD} && $char->{ST}>$char->{STrem} && $char->{STrem}<4) {
    print "Assuming $char->{NAME} is at -3 DX due to injuries.  If not, please add a BAD column with 0 for this character.\n";
    $char->{BAD} = 1;
  }
  
  # Address some potential issues with names
  print "Replacing spaces with underscores in names\n"
      if $char->{NAME} =~ s/ /_/g && !$msg_space++;
  my $name = $char->{NAME};
#   print "WARNING: Numeric character specifications are considered as namekeys before character indices.  Character index specifications are deprecated. (20aug021)\n" if $name =~ /^\d/;
  
  # Name keys
#   my $namekey = extend_namekey($ci, '', \%namekeys);
  extend_namekey($ci, '', \%namekeys);
  
#   my $len = 1;
#   my $length = length $name;
#   my $namekey = substr $name, 0, $len;
#   $namekey = substr $name, 0, ++$len while $len <= $length && defined $charkeys{$namekey};
#   if ($len > $length) {
#     print "WARNING: namekey overflow.  Please use longer or more unique names.\n";
#     $namekey .= $uniquify++;
#   }
  # Is this good enough, or do I need to expand both keys? (27jul021)
  # Actually this could be better, e.g. if two people have the same first name.

#   if (defined $namekey) {
#     $charkeys{$namekey} = $ci;
#     $char->{NAMEKEY} = $namekey;
#   }
}


# Increments namekey (and all others implied by the new addition
sub extend_namekey {
  my $whoi = shift;    # character index to extend
  my $namekey = shift; # namekey so far I guess
  my $nextLetter = shift; # root in %namekeys ?
  
  my $name = $characters[$whoi]->{NAME};
  my $lkey = length $namekey;
  my $lname = length $name;

  my $letter = substr $name, $lkey, 1;

  $debug && print "extend_namekey($whoi, $namekey, $nextLetter): name=$name lkey=$lkey lname=$lname letter=$letter\n";
#   $namekey = substr $name, 0, ++$lkey;
  #   unless ($nextLetter->{substr $namekey, -1, 1}) {
  delete $charkeys{$namekey}; # Can I do this globally like this?
  $namekey .= $letter;
  my $whatsThere = $nextLetter->{$letter}; # I think this creates $nextLetter if it is an undef
  if (! defined $whatsThere) { # namekey is not used yet
    $debug && print "Valid namekey $namekey found for char $whoi: $name\n";
    $nextLetter->{$letter} = $whoi;
    #     return $namekey
    $charkeys{$namekey} = $whoi;
    $characters[$whoi]->{NAMEKEY} = $namekey;
#     return $namekey; # . $letter;
  }
  elsif (! ref $whatsThere)  { # single character uses this namekey currently
    die "Two characters with identical names! $name\n" if $name eq $characters[$whatsThere]->{NAME};
    # I used to be able to uniquify them.  Restore that? (28aug021)

    my @expandNamekeys;
#     push @expandNamekeys, $nextLetter->{$letter}, $whoi;
    push @expandNamekeys, $whatsThere, $whoi;
    $nextLetter->{$letter} = {}; # change its char index value into a new hashref, as new root

    foreach (@expandNamekeys) {
      # remove this old namekey from %charkeys
#       delete $charkeys{$namekey};
    
#       my $nk = extend_namekey($_, $namekey, $nextLetter->{$letter});
#       $charkeys{$nk} = $_;
#       $characters[$_]->{NAMEKEY} = $nk;
      extend_namekey($_, $namekey, $nextLetter->{$letter});

      # How do I want to handle this?? -- let's do everything inline
    }
  } else { # multiple characters' namekey begins with this string
    #     foreach (keys %$nextLetter) { ???
    # Keep going (?)
#     $namekey .= $letter;
    extend_namekey($whoi, $namekey, $whatsThere);
  }
    
#   $namekey = substr $name, 0, ++$len while $len <= $length && defined $charkeys{$namekey};

  # What to do about overflow??
#   if ($len > $length) {
#     print "WARNING: namekey overflow.  Please use longer or more unique names.\n";
#     $namekey .= $uniquify++;
#   }
}


# Who is next to act?
sub whosnext {
  my $maxroll;
  my $next;
  $maxdx = -1; # global so it can be used in &act

  foreach (@_) {
    next if $acted[$_];
    # This isn't good enough.  acted flags get cleared before 2nd bow shot!
    # should be fixed now...
#     print join(' ', @dxmod), "\n";
    my $dx = $characters[$_]->{adjDX} + $dxmod[$_] + $dxinj[$_];
    if ($dx > $maxdx) {
      $next = $_;
      $maxdx = $dx;
      $maxroll = $roll[$_];
    } elsif ($dx == $maxdx && $roll[$_] > $maxroll) {
      $next = $_;
      $maxroll = $roll[$_];
    }
  }
#   print "$next is next\n";
  $next;
}


# Act in order of dex
# Pass array of characters who will act
sub act {
  my @chars = @_;
#   my %dexes; # key dex val array of character indices
  
  # Preparations
#   foreach my $i (keys %{$chars}) {
  for my $i (@chars) {
    next if $characters[$i]->{DEAD};
#     $debug && print "$characters[$i]->{NAME} has adjDX $dex[$i]\n";
    # Gather DEXes
#     push @{$dexes{$dex[$i]}}, $i;
    # Roll initiative
    $roll[$i] = rand;
  }
  
  # Actions
  &displayCharacters;
  print "Actions:\n",
      "* [sp<ST>] <who>-<dam>\t(e.g. c-4 for 4 damage to character c after armor)\n";
  print "* [sp<ST>] sh<dex adj>\tready or unready shield, which changes base adjDX\n",
      "\t\t\t(e.g. 'sh -2' to ready a tower shield)\n",
      "* sp<ST> <name> <ST> <adjDX>\tcreate being\n",
      "* d <who>\t\t\tdisbelieve <who>\n",
      "* sp<ST> a <who> <DX mod>\tspell which modifies <who>\'s adjDX by <DX mod>\n",
      "\t(e.g. 'sp2 a x -2' for Rope spell on x (remember to put a DX adjustment\n\t each turn on x, during action considerations)\n",
      "  Prefix with 'sp<ST>' if result is from spell of ST cost <ST>.\n",
      "  (Note that spell can have no result, but still cost ST.)\n" if $phase =~ /n/;
  print '-' x 79, "\n";
  my $act_char;
  while (defined ($act_char = whosnext(@chars))) {
    my $ac = $characters[$act_char]; # acting character
    next if $ac->{DEAD};
    print "$ac->{NAME}: ST $ac->{ST} ($ac->{STrem})  adjDX $ac->{adjDX} -", -$dxinj[$act_char], $dxmod[$act_char]<0?'':' +', "$dxmod[$act_char] = $maxdx";
    print " (stunned until turn $ac->{StunTurn})" if $turn < $ac->{StunTurn};
    # Stunned 'through this turn' or '... next turn'? (12aug021)
    print "\n";

    # Action query loop for character with index $act_char
    while (1) {
      my $action = query('', "Action result? (N)o");
      $debug && print "act_char=$act_char acted=$acted[$act_char]\n";
      # Spell cost
      if ($action =~ s/^sp ?(\d+)\s*//) {
	$ac->{STrem} -= $1;
	print "$ac->{NAME} casts spell, has $ac->{STrem} ST remaining\n";
      }
      # Result of action
      if ($action =~ /(.+) ?- ?(\d+)/) { # Hit!
	my $injuredi = who($1);
	next if $injuredi eq 'x';
	print "Injuring self!\n" if $injuredi == $act_char;
	my $dc = $characters[$injuredi]; # damaged character
	my $damage = $2;
	$debug && print "$characters[$act_char]->{NAME} hits $characters[$injuredi]->{NAME} for $damage damage\n";
	++$retreats{$act_char}->{$injuredi};
	  
	# Reaction to Injury
	print "$damage ST damage to $dc->{NAME}\n";
	$dc->{STrem} -= $damage;
	my $old_turn_damage = $turn_damage[$injuredi];
	$old_turn_damage = 0 unless defined $old_turn_damage;
	$turn_damage[$injuredi] += $damage;
	print "$dc->{NAME} has taken $turn_damage[$injuredi] damage so far this turn, has $dc->{STrem} ST remaining\n";
	my $turn_damage = $turn_damage[$injuredi];
	if ($turn_damage >= $dc->{STUN} && $dc->{StunTurn} <= $turn) {
	  print "$dc->{NAME} is stunned\n";
	  $dc->{StunTurn} = $turn+2;
	  $dxinj[$injuredi] -= 2;
	}
	$debug && print "turn_damage=$turn_damage  FALL=$dc->{FALL}  old_turn_damage=$old_turn_damage\n";
	if ($turn_damage >= $dc->{FALL} && $old_turn_damage < $dc->{FALL}) {
	  print "$dc->{NAME} falls down\n";
	  $acted[$injuredi] = 1;
	}
	if ($dc->{STrem} <4 && $dc->{STrem}+$damage >3) {
	  print "$dc->{NAME} is in bad shape...\n";
	  ++$dc->{BAD};
	  $dxinj[$injuredi] -= 3;
	}
	if ($dc->{STrem} <2) {
	  $dc->{DEAD} = 1;
	  if ($dc->{STrem} == 1) {print "$dc->{NAME} falls unconscious\n";}
	  else { print "$dc->{NAME} dies\n"; }
	  $acted[$injuredi] = 1;
	}
	last; # exit from while (1) action query loop
      } # did damage
      elsif ($action =~ /^(.+) (\d+) (\d+)$/) { # Create being
	print "$1 created with ST $2 adjDX $3\n";
	print "Animals get automatic disbelieve roll\n";
	# Not too sure how to handle this.  Will write explicit code for now, but should put into function which is shared with 'Read parties' code above. (29jul021)
	$characters[$n]->{NAME} = $1;
	$characters[$n]->{ST} = $2;
	$characters[$n]->{STrem} = $2;
	$characters[$n]->{adjDX} = $3;
	$characters[$n]->{PLAYER} = $characters[$act_char]->{NAME};
	$characters[$n]->{PARTY} = $characters[$act_char]->{PARTY};
	push @dxmod, 0;
	push @dxinj, 0;
	character_prep($n++);
	&displayCharacters;
	last; # always last after successful action result
      } # create being
      elsif (shield($ac, $action)) { last; }
      elsif ($action =~ /^d (.+)$/) { # Disbelieve
	my $who = who($1);
	next if $who eq 'x';
	$characters[$who]->{DEAD} = 1;
	$acted[$who] = 1;
	last;
      } # disbelieve
      elsif ($action =~ /^a (.+) (-?\d+)$/) {
	my $targeti = who($1);
	next if $targeti eq 'x';
	$dxmod[$targeti] += $2;
      } # DX mod for this turn only, e.g. from Rope spell
      elsif (!$action) { last; } # exits action query for this character
      else { print "Unrecognized action $action\n"; }
    } # what happened during $act_char's action
    $acted[$act_char] = 1;
  } # loop over actors
} # main loop over turns



# Change shield state
# pass char ref and input string
# returns true if input changes shield state
sub shield {
  my $c = shift;
  my $input = shift;

  if ($input =~ /^sh ?([\d-]+)$/) { # change shield state
    my $adjDX = $c->{adjDX};
    print $c->{NAME}, $1>0 ? ' un' : ' ', "readies shield -- adjDX $adjDX --> ", $adjDX+$1, "\n";
    $c->{adjDX} += $1;
    1;
  } else { 0; }
}


# intiative, spell renewal, & movement
# pass me an array of alive entities
sub movement {
  my @ent = @_;
  
  # Initiative
  # ----------
  my @roll;
  for (my $i=0; $i<@ent; ++$i) { $roll[$i] = rand; }

  print "\nInitiative order:\n";
  my @order;
  my $prev_roll;
  my @moved; # who has moved so far
  foreach my $i (sort {$roll[$a] <=> $roll[$b]} 0..$#roll) {
    my $roll = $roll[$i];
    if (defined $prev_roll && $prev_roll == $roll) { die "Roll collision!\n"; }
    else { $prev_roll = $roll; }
    print " $ent[$i]\n";
    push @order, $i;
  }

  print "\nSpell phase: Renew spells or they end now\n";
  my $fmt = "format: <who> <spell cost>\n";
  while (1) {
    my $sccmd = query('', 'Spell cost, (F)inished');
    last unless $sccmd;
    my @sccmd = split / /, $sccmd;
#     unless $sccmd =~ /^([^ 
    my $whoi = shift @sccmd;
    my $cost = shift @sccmd;
    if ($whoi eq 'x') { print "Error in character specification $whoi", $fmt; next; }
    elsif ($cost !~ /^\d+$/) { print "Please use positive integer for ST cost $cost", $fmt; next; }
    elsif (@sccmd) { print $fmt; next; }
    my $c = $characters[$whoi];
    $c->{STrem} -= $cost;
    print "$c->{NAME} has $c->{STrem} remaining\n";
    last;
  }
  
  # Movement
  # --------
  my $i = 0;
  my $last = $#ent; # queue index of last in queue
  $phase = 'movement';
  print "\nMovement phase:\n";
  # Trim dead people from end of order
#   --$last while $characters[$order[$last]]->{DEAD};

  while (1) {

    # skip over people who have gone already
    $debug && print "skipping over moved characters at front of queue\n";
    while ($moved[$order[$i]]) {
#       $debug && print "i=$i last=$last $characters[$order[$i]]->{NAME} already moved\n";
      ++$i;
    }

    if ($i == $last) {
#       print "$characters[$order[$i]]->{NAME} moves\n";
      print "$ent[$order[$i]] moves\n";
      $moved[$order[$i]] = 1;
      $i = 0;
      while ($last>=0 && $moved[$order[--$last]]) {}
    } else {
      $debug && print "order[$i]=$order[$i] last=$last\n";
#       my $move = query('d', "$characters[$order[$i]]->{NAME} (m)ove, or (D)efer");
      my $move = query('d', "$ent[$order[$i]] (m)ove, (D)efer, (f)inished");
      if ($move eq 'm') {
	$moved[$order[$i]] = 1;
	--$last if $i==$last;
	$i = 0;
      }
      elsif ($move eq 'd') { ++$i; }
      elsif ($move eq 'f') { last; }
      else { print "unrecognized response [$move]\n"; }
    }
    last if $last<0;
  } # movement phase
}


# Returns character index to whom a string refers
# 'x' on error
sub who {
  my $s = shift;
#   my $retval = $charkeys{$s};

#   if (defined $retval) { return $retval; }
  my $l = length $s;
  while ($l) {
    my $retval = $charkeys{substr $s, 0, $l--};
    if (defined $retval) { return $retval; }
  }
#   elsif ($s =~ /^\d/) {
#     if ($s<0 || $s >= $n) { return -2; }
#     return $s;
  #   }
  # It would be nice to handle errors directly here somehow. (28aug021)
  print "Invalid character specification '$s'\n";
  'x'; # should be an invalid array index
}
