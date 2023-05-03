assign
======

Enable Destructuring Assignment Syntax in Perl

# Synopsis

```
my {$foo, bar => [ $x1, $x2, @xs ]} = $self->data;
```

# Status

PRE-ALPHA. Forget you've seen this!

# Description

This module enables a destructuring assignment syntax for Perl.
Various complex data structure definitions on the LHS of assignment result can
be used to unpack a complex data structure using variables that match keys and
positions on the RHS.
