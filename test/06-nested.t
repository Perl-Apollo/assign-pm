use assign::Test;

test <<'...', "Unpack hash nested with array and hash";
my { a => [ $a1, $a2], $b => {$b1, $b2} } = foo;
+++
my ($a1, $a2, $b, $b1, $b2);
$a1 = $foo->{a}[0];
$a2 = $foo->{a}[1];
$b = $foo->{b};
$b1 = $foo->{b}{b1};
$b2 = $foo->{b}{b2};
#line 1
...
