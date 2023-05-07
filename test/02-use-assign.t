use assign::Test;

use assign -0;

my $aref1 = [111, 222];
my $href1 = {bar => 111, foo => 222};

my [$a1, $b1] = $aref1;
is $a1 + $b1, 333, "It works";

my [$a2, $b2, $c2] = $aref1;
is $a2, 111, "\$a2 == 111";
is $b2, 222, "\$b2 == 222";
ok not(defined($c2)), "\$c2 is not defined";

my [$a3, $b3, $c3] = [111, 222];
is $a3, 111, "\$a3 == 111";
is $b3, 222, "\$b3 == 222";
ok not(defined($c3)), "\$c3 is not defined";

our [$a4, $b4, $c4] = [111, 222];
is $main::a4, 111, "\$main::a4 == 111";
is $main::b4, 222, "\$main::b4 == 222";
ok not(defined($main::c4)), "\$main::c4 is not defined";
