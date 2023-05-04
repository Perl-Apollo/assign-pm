use strict; use warnings;
package assign::Test;

use Test::More;

use base 'Exporter';

our @EXPORT = qw(
    test_transform
    is ok pass fail
);

sub import {
    strict->import;
    warnings->import;
    goto &Exporter::import;
}

sub test_transform {
    require assign;

    my ($spec, $label) = @_;

    $spec =~ /(.*\n)\+\+\+\n(.*)/s
        or die "Invalid spec for 'test()'";
    my ($perl, $want) = ($1, $2);

    my $got = assign->new(code => $perl)->transform;

    is $got, $want, $label;
}

END {
    package main;

    if (not defined $ENV{PERL_ZILD_TEST_000_COMPILE_MODULES}) {
        Test::More::done_testing();
    }
}

1;
