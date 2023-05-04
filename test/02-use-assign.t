use assign::Test;

use assign -0;

my $d = [111, 222];
my [$foo, $bar] = $d;
is $foo + $bar, 333, "It works";
