use assign::Test;

test <<'...', "Assign scalars at start end of array, and array of in-betweens";
my [$a, $b, @$m, $y, $z] = $o;
+++
my ($a, $b, $m, $y, $z);
$a = $o->[0];
$b = $o->[1];
$m = [@$o[2..@$o-3]];
$y = $o->[-2];
$z = $o->[-1];
#line 1
...
