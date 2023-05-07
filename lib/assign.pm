use strict; use warnings;
package assign;

our $VERSION = '0.0.6';

use Filter::Simple;
use PPI;
use XXX;

our $var_prefix = '___';
our $var_id = 1000;
our $var_suffix = '';

sub import {
    defined $_[1] and $_[1] eq '0'
        or die "Invalid 'use assign ...;' usage. Try 'use assign -0;'.";
}

# FILTER_ONLY code_no_comments => \&filter;
FILTER_ONLY all => \&filter;

sub filter {
    my ($class) = @_;
    $_ = $class->new(
        code => $_,
        line => ([caller(4)])->[2],
    )->transform();
};

sub new {
    my $class = shift;
    my $self = bless {
        @_,
    }, $class;
    my $code = $self->{code}
        or die "assign->new requires 'code' string";
    $self->{line} //= 0;
    $self->{doc} = PPI::Document->new(\$code);
    $self->{doc}->index_locations;
    return $self;
}

sub transform {
    my ($self) = @_;

    # Call the various possible assignment transformations:
    $self->transform_assignment_statements;
    $self->transform_assignment_statements_no_dec;
    # ... more to come ...

    $self->{doc}->serialize;
}

sub transform_assignment_statements {
    my ($self) = @_;

    my $doc = $self->{doc};

    do {
        my $node = $_;
        my ($dec, $lhs, $op, @rhs) = $node->schildren;
        my $rhs = join '', map $_->content, @rhs;
        $self->transform_assignment_statement(
            $node, $dec, $lhs, $op, $rhs,
        );
    } for map {
        $_ ||= []; @$_
    } $doc->find(sub {
        my $n = $_[1];
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

sub transform_assignment_statements_no_dec {
    my ($self) = @_;

    my $doc = $self->{doc};

    do {
        my $node = $_;
        my $dec = '';
        my ($lhs, $op, @rhs) = $node->schildren;
        my $rhs = join '', map $_->content, @rhs;
        $self->transform_assignment_statement(
            $node, $dec, $lhs, $op, $rhs,
        );
    } for map {
        $_ ||= []; @$_
    } $doc->find(sub {
        my $n = $_[1];
        return 0 unless
            ref($n) eq 'PPI::Statement' and
            @{[$n->schildren]} >= 4 and
            $n->schild(0)->isa('PPI::Structure::Constructor') and
            $n->schild(1)->isa('PPI::Token::Operator') and
            $n->schild(1)->content eq '=';
    });
}

sub transform_assignment_statement {
    my ($self, $node, $dec, $lhs, $op, $rhs) = @_;

    $self->{dec} = $dec ? $dec->{content} . ' ' : '';
    $self->{op} = $op->{content};

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
    my ($code, $dec, $op) = @$self{qw<code dec op>};
    my $from;
    if ($rhs =~ /^(\$\w+);/) {
        $from = $1;
    } else {
        $from = $self->gen_var;
        push @$code, "my $from = $rhs";
    }
    my $i = 0;
    do {
        my $var = $_->content;
        push @$code, "$dec$var $op $from\->[$i];";
        $i++;
    } for map { $_ ||= []; @$_ }
    $lhs->find('PPI::Token::Symbol');
    return;
}

sub gen_var {
    $var_id++;
    return "\$$var_prefix$var_id$var_suffix";
}

sub replace_statement_node {
    my ($self, $node, $code) = @_;
    my $line_number = $node->last_token->logical_line_number + $self->{line};
    $node->insert_after($_->remove)
        for reverse PPI::Document->new(\"\n#line $line_number")->elements;
    $node->insert_after($_->remove)
        for reverse PPI::Document->new(\$code)->elements;
    $node->remove;
    return;
}

1;
