use assign::Test;

test <<'...', "Unpack array nested with an hash";
my { b => [ $b1, $b2 ] } = $foo;
+++
my ($b1, $b2);
$b1 = $foo->{b}->[0];
$b2 = $foo->{b}->[1];
#line 1
...

test <<'...', "Unpack hash nested with a hash";
my { a => { $a1, $a2 } } = $foo;
+++
my ($a1, $a2);
$a1 = $foo->{a}->{a1};
$a2 = $foo->{a}->{a2};
#line 1
...

test <<'...', "Unpack a mixed bag";
my { a => { $a1, $a2 }, b => [ $b1, $b2 ] } = $foo;
+++
my ($a1, $a2);
$a1 = $foo->{a}->{a1};
$a2 = $foo->{a}->{a2};
my ($b1, $b2);
$b1 = $foo->{b}->[0];
$b2 = $foo->{b}->[1];
#line 1
...
