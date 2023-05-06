use assign::Test;

use assign -0;

# my [$foo, $bar] = [111, 222];
my $foo = 111; my $bar = 222;  # XXX fake for now

is $foo + $bar, 333, "It works";
