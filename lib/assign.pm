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

# FILTER_ONLY code_no_comments => \&filter;
FILTER_ONLY all => \&filter;

sub new {
    my $class = shift;
    my $self = bless {
        @_,
    }, $class;
    my $code = $self->{code}
        or die "assign->new requires 'code' string";
    $self->{doc} = PPI::Document->new(\$code);
    return $self;
}

sub filter {
    my ($class) = @_;
    local $; = 'xxxxxxx';
    $_ = $class->new(
        code => $_,
    )->transform();
};

sub transform {
    my ($self, $code) = @_;

    # Call the various possible assignment transformations:
    $self->transform_assignment_statements;
    # ... more to come ...

    $self->{doc}->serialize;
}

sub transform_assignment_statements {
    my ($self) = @_;

    my $doc = $self->{doc};

    $self->transform_assignment_statement($_) for
    map { $_ ||= []; @$_ }
    $doc->find(sub {
        my $n = $_[1];
        $n->isa('PPI::Statement::Variable');
        return 0 unless
            $n->isa('PPI::Statement::Variable') and
            @{[$n->schildren]} >= 5 and
            $n->schild(0)->isa('PPI::Token::Word') and
            $n->schild(0)->content eq 'my' and
            $n->schild(1)->isa('PPI::Structure::Constructor') and
            $n->schild(2)->isa('PPI::Token::Operator') and
            $n->schild(2)->content eq '=';
    });
}

sub transform_assignment_statement {
    my ($self, $node) = @_;
    my ($own, $lhs, $op, $rhs) = $node->schildren;
    die "Not yet supported" unless
        $lhs->start->content eq '[';
    $own = $own->{content};

    # TODO analyze node and generate this code string:
    my $code = q{my $x1 = $d->[0]; my $x2 = $d->[1];};

    my $parent = $node->parent;
    $self->replace_statement_node($node, $code);

    return;
}

sub replace_statement_node {
    my ($self, $node, $code) = @_;
    $node->insert_after($_->remove)
        for reverse PPI::Document->new(\$code)->elements;
    $node->remove;
    return;
}

1;
