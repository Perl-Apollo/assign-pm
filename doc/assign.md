assign
======

Destructuring Assignment Syntax in Perl


# Synopsis

This code:

```
use assign -0;

my {$foo, bar => [ $first, @rest, $last ]} = $self->data;
```

works the same as this code:

```
my $_temp1 = $self->data;
my $foo = $_temp1->{foo};
my $_temp2 = $_temp1->{bar};
my $first = shift @$temp2;
my $last = pop @$temp2;
my @rest = @$temp2;
```


# Description

This module enables a destructuring assignment syntax for Perl.

Instead of assigning a value to a variable, you can now assign to a data
structure (array-ref or hash-ref) that specifies how to unpack a data structure
into all the variables you need.

When you use this module you can put array-refs or hash-refs in places where
you would put a variable that will be assigned to.
The contents of these refs act as instructions for what variables to create and
which parts of the target to take the assignment values from.

There are many useful combinations, which are documented below.
The destructuring refs can be nested, allowing you to extract all the values
you want from a complex data structure in a single statement.


# Status

This module is very new and experimental.
The hope is that this may one day become a pragma module or possibly even part
of Perl syntax.

To preserve backwards compatability for early adopters, the module currently
requires you to `use assign -0;`.
When the module becomes stable and vetted, it will become simply `use assign;`.


# Destructuring Forms

The best way to explain this module is by example.

All the forms below have been implemented and should work as described for this
version of the module.

Here we go...

* `my [$foo, $bar] = [111, 222];`

  Define 2 `my` variables and assign the array-ref-literal values in order.
  If there are less values on the RHS, the variables will be undefined.
  If there are more, they will be ignored.

* `my {$foo, $bar} = {bar => 111, foo => 222};`

  Define 2 `my` variables and use the variable name as the key to extract from
  the hash-ref on the RHS.

* `my [$foo, $bar] = (111, 222);`   ERROR

  If the LHS is an array-ref the RHS must also be an array-ref.
  If the LHS is a hash-ref the RHS must also be a hash-ref.

* `my ($foo, [$bar, $baz]) = (111, [222, 333]);`

  This works fine because the types match in the LHS and RHS lists.

* `my [$foo, $bar] = $data;`

  The RHS can be a variable or any expression as long as its value is an
  array-ref.


## TODO

There are many more forms that are intended to work, and many more cases we
haven't thought of yet.
Pretty much any place in Perl where a variable can be assigned to should also
allow a structure to be assigned to.

Here's the current list of things intended to be added soon:

```
our [ $x1, $x2 ] = $d;                  # Unpack into 'our' vars
my ( $x1, $x2 );
[ $x1, $x2 ] = $d;                      # Unpack into pre-defined vars

my [ $x1, $x2=42 ] = $d;                # Set a default variable
my [ $x1, @xs ] = $d;                   # Set remaining into an array
my [ $x1, @xs, $x2 ] $d;                # Set all but first and last into array
my [ _, $x2, _, $x4 ] = $d;             # Use _ ignore an array element
my [ $x1, $_ ] = $d;                    # $_ actually sets $_
my [ $first, [], $last ] = $d;          # Ignore middle
my [ 25, $x26, $x27 ] = $d;             # Use a number to ignore muliple
my [ $x1, $x2, -25 ] = $d;              # Take -27 and -26

my [ @a, @b, @c ] = $d;                 # Evenly distribute values over multiple arrays
my [ @a, @_, @_ ] = $d;                 # Take every third element (0, 3, 6, ...)
my [ @a, @19 ] = $d;                    # Take every 19th element

# Hash destructuring:
my { $k1, $k2 } = $d;                   # Unpack a hash ref
my { $k1, $k2 } = %d;                   # Unpack a hash

my { k1 => $x, $k2 } = $d;              # Use a var name different than key
my { k1 => $x=111, $k2=222 } = $d;      # Set default values

my { $key => $val } = $d;               # Unpack a single pair hash
my { @key => @val } = $d;               # Unpack all keys and values (unzip)
my [ @key => @val ] = $d;               # Unpack all keys and values *sorted*
my { @keys } = $d;                      # Key array of all keys
my [ @keys ] = $d;                      # Key array of all keys *sorted* (RHS must be hashref)
my { @keys => _ } = $d;                 #   Same as above
my [ @keys => _ ] = $d;                 #   Same as above but *sorted*
my { _ => @vals } = $d;                 # Get array of all values

my { 'a-key', 'b.key' } = $d;           # Short for { 'a-key' => $a_key, 'b.key' => $b_key }
my { 'foo bar' } = $d;                  # Short for { "foo bar" => $foo_bar }

# Nested destructuring:
my { k1 => { $k2, $k3 }} = $d;          # Unpack nested hash (no $k1)
my { $k1 => { $k2, $k3 }} = $d;         # Unpack nested hash w/ $k1 set to inner hash ref
my { k1 => [ $x1, $x2 ]} = $d;          # Unpack array ref nested in hash (no nesting depth limit)

# Operator assignments:
[ $a, $b ] //= $d;                      # Only assign undefined variables
[ $a, $b ] .= $d;                       # Append string to every var
[ $a, $b ] += $d;                       # Add number to every var

# In for loops:
for my { $k => [ $x1, $x2 ]} (@list) {  # Unpack each collection from a list
for my { $k => $v } (%hash) { $d;       # Unpack each key/val pair from a hash

# In signatures:
sub foo( $a, {$k1, [ $x1, $x2 ]} ) { … }
sub foo({
    $name = "Fred",
    number => $num = 42,
}) { … }

# Regex:
my [ $match, $cap1, $cap2 ] = $str =~ /…/;
my [ $match, $cap1, $cap2 ] = /…/;      # Match using $_

# Inline list expressions:
my [ $a, @l{reverse}, $y, $z ] = $d;
my [ $a, @l{map ($_ + 1), grep ($_ > 10)}, $z ] = $d;
my [ $a, @{join '-'} => $s, $z ] = $d;
```

# Prior Art

Destructuring assignment is available in many common languages.
This module got many ideas from the others.

* [CoffeeScript](
https://alchaplinsky.github.io/hard-rock-coffeescript/syntax/destructuring_assignment.html)
* [JavaScript](
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
* [Python](
https://riptutorial.com/python/example/14981/destructuring-assignment)


# Authors

* Ingy döt Net
