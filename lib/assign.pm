use strict; use warnings;
package assign;

our $VERSION = '0.0.4';

use Filter::Simple;
use PPI;
use XXX;

our $varid = 1000;

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
    $_ = $class->new(
        code => $_,
    )->transform();
};

sub transform {
    my ($self) = @_;

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
            $n->schild(0)->content =~ /^(my|our|local)$/ and
            $n->schild(1)->isa('PPI::Structure::Constructor') and
            $n->schild(2)->isa('PPI::Token::Operator') and
            $n->schild(2)->content eq '=';
    });
}

sub transform_assignment_statement {
    my ($self, $node) = @_;
    my ($own, $lhs, $op, @rhs) = $node->schildren;

    $self->{own} = $own->{content};
    $self->{op} = $op->{content};
    my $rhs = join '', map $_->content, @rhs;

    $self->{code} = [];
    if ($lhs->start->content eq '[') {
        $self->transform_aref($lhs, $rhs);
    } elsif ($lhs->start->content eq '{') {
        $self->transform_aref($lhs, $rhs);
    } else {
        ZZZ $node, "Unsupported statement";
    }

    my $code = join "\n", @{$self->{code}};

    $self->replace_statement_node($node, $code);

    return;
}

sub transform_aref {
    my ($self, $lhs, $rhs) = @_;
    my ($code, $own, $op) = @$self{qw<code own op>};
    my $from;
    if ($rhs =~ /^(\$\w+);/) {
        $from = $1;
    } else {
        $from = $self->genvar;
        push @$code, "my $from = $rhs";
    }
    my $i = 0;
    do {
        my $var = $_->content;
        push @$code, "$own $var $op $from\->[$i];";
        $i++;
    } for map { $_ ||= []; @$_ }
    $lhs->find('PPI::Token::Symbol');
    return;
}

sub genvar {
    $varid++;
    return "\$___${varid}";
}

sub replace_statement_node {
    my ($self, $node, $code) = @_;
    $node->insert_after($_->remove)
        for reverse PPI::Document->new(\$code)->elements;
    $node->remove;
    return;
}

1;
