use strict; use warnings;
package assign;

our $VERSION = '0.0.1';

use Module::Compile -base;
use Pegex;
# use assign::Grammar;

sub pmc_compile {
    my ($class, $code) = @_;
    ::XXX $_ = $code;

    return q<print "hello\n";>;
}

sub pmc_output {
    my ($class, $file, $output) = @_;
    goto &Module::Compile::pmc_output if $file =~ /\.pm$/;
    1 while $output =~ s/.*?\n\#line 1\n//s;
    eval $output;
}

1;
