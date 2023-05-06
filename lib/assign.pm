use strict; use warnings;
package assign;

our $VERSION = '0.0.1';

use Filter::Simple;
use PPI;
use XXX;

my $symbol = 1;

sub import {
    defined $_[1] and $_[1] eq '0'
        or die "Invalid 'use assign ...;' usage. Try 'use assign -0;'.";
}

FILTER_ONLY code_no_comments => \&filter;

sub new { bless {}, shift }

sub filter {
    my ($class) = @_;

    $_ = $class->new->transform($_);
};

sub transform {
    my ($self, $code) = @_;

    WWW + PPI::Document->new(\$code);

    return $code;
}

1;
