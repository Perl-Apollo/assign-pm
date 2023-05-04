use assign::Test;

# Perl destruct

test <<'...', "111-222",
my [$foo, $bar] = [111, 222, 333];
print "$foo-$bar";
...
    "Simple array destructure";

my $da1 = [ qw< foo bar baz > ]

# Get reviews on these:
my $todo = <<'...';

# Array destructuring:
my [$x1, $x2] = $d;                     # Unpack array ref into 'my' vars
my [$x1, $x2] = @d;                     # Unpack array
my [$x1, $x2] = $self->d;               # Unpack array from a returned value
my [$x1, $x2] = [111, 222];             # Unpack array from literal
our [$x1, $x2] = $d;                    # Unpack into 'our' vars
my ($x1, $x2);
+[$x1, $x2] = $d;                       # Unpack into pre-defined vars

my [$x1, $x2=42] = …                    # Set a default variable
my [$x1, @xs] = …                       # Set remaining into an array
my [$x1, @xs, $x2] …                    # Set all but first and last into array
my [ _, $x2, _, $x4] = …                # Use _ ignore an array element
my [ 25, $x26, $x27 ] = …               # Use a number to ignore muliple
my [ $x1, $x2, -25 ] = …                # Take -27 and -26

# Hash destructuring:
my { $k1, $k2 } = $d;                   # Unpack a hash ref
my { $k1, $k2 } = %d;                   # Unpack a hash

my { k1 => $x, $k2} = …                 # Use a var name different than key
my { k1 => $x=111, $k2=222} = …         # Set default values

my { $key => $val } = …                 # Unpack a single pair hash
my { @key => @val } = …                 # Unpack all keys and values (unzip)

my { $a-key, $b.key } = …               # short for { 'a-key' => $a_key, 'b.key' => $b_key }

# Nested destructuring:
my { k1 => { $k2, $k3 }} = …            # Unpack nested hash (no $k1)
my { $k1 => { $k2, $k3 }} = …           # Unpack nested hash w/ $k1 set to inner hash ref
my { k1 => [ $x1, $x2 ]} = …            # Unpack array ref nested in hash (no nesting depth limit)

...

# TODO Make test cases for errors; combinations that don't make sense

# Questions
#
# * what is the return value of the assignment?
