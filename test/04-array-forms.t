use assign::Test;

# Array destructuring:

test <<'...', "Unpack aref with _ skips";
my [ $a, _, _, $d ] = $aref;
+++
my $a = $aref->[0];
my $d = $aref->[3];
#line 1
...

test <<'...', "Unpack into \$_ global var";
my [ $a, $_, $b ] = $aref;
+++
my $a = $aref->[0];
$_ = $aref->[1];
my $b = $aref->[2];
#line 1
...

test <<'...', "Unpack aref with numeric skips";
my [ 7, $a, 42, $b ] = $aref;
+++
my $a = $aref->[7];
my $b = $aref->[50];
#line 1
...
