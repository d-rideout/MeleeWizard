filename is name of 'party'

We are starting with character-based initiative, rather than player-based or
side-based, as it suggests in the rules.  This will be substantially more
complicated, but also substantially more realistic?
Does the computer should make it managable?  Is it fun?
Yes, I think so!  Though please hit 'm' unless there is some substantial reason not to.

## Maintenance

### Query User

To query the user, use the following code template:

```
while (my $response = query(<default>, <query string>)) {
  next if problem, e.g.
  my @args = split / +/, $response;
  my $whoi = who($args[3]);
  next if $whoi eq 'x';
  next if another problem;
  last if success;
  catch leak in logic above?;
}
```

Is this too complicated?  It allows great flexibility in the interpretation of the response.  e.g. ignoring spaces and the like.

### adjDX Order

Have `&act` take a hashref of characters to act, val 1.

