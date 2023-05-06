use assign::Test;

# Array destructuring:

test_transform <<'...', "Unpack aref into 'my' vars";
my [ $x1, $x2 ] = $d;
+++
my $x1 = $d->[0]; my $x2 = $d->[1];
...

# test_transform <<'...', "Unpack a literal aref";
# my [$foo, $bar] = [111, 222];
# +++
# my $_1 = [111, 222]; my $foo = 111; my $bar = 222;
# ...
