use strict; use warnings;
package assign;

our $VERSION = '0.0.7';

# TODO:
# * `use assign::0 -debug`

our $assign_class;

our $var_prefix = '___';
our $var_id = 1000;
our $var_suffix = '';

sub import {
    ::XXX "Currently invalid to 'use assign;'. Try 'use assign::0;'.";
}

sub new {
    ::ZZZ 42 unless defined $assign_class;
    my $class = shift;
    my $self = bless { @_ }, $assign_class;
    my $code = $self->{code}
        or die "assign->new requires 'code' string";
    $self->{line} //= 0;
    $self->{doc} = PPI::Document->new(\$code);
    $self->{doc}->index_locations;
    return $self;
}

1;
