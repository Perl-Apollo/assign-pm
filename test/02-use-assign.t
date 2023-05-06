use assign::Test;

use assign -0;

my $d = [111, 222];
my [$foo, $bar] = $d;
is $foo + $bar, 333, "It works";

my [$x, $y, $z] = $d;
is $x, 111, "\$x == 111";
is $y, 222, "\$y == 222";
ok not(defined($z)), "\$z is not defined";
