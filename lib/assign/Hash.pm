use strict; use warnings;
package assign::Hash;

use assign::Struct;
use base 'assign::Struct';

use assign::Types;
use assign::Array;

use XXX;

sub parse_elem {
    my ($self) = @_;
    my $in = $self->{in};
    my $elems = $self->{elems};
    while (@$in) {
        my $tok = shift(@$in);
        my $type = ref($tok);
        next if $type eq 'PPI::Token::Whitespace';

        if ($type eq 'PPI::Token::Word') {
            $self->parse_fat_comma;
            $self->parse_whitespaces;

            my $str = $tok->content;
            my $v = shift(@$in);
            if ($v && ref($v) eq 'PPI::Structure::Constructor') {
                my $deepkey = "{$str}";
                if ($v->braces eq '[]') {
                    my $struct = assign::Array->new(node => $v, deepkey => $deepkey)->parse;
                    push @$elems, $struct;
                }
                elsif ($v->braces eq '{}') {
                    my $struct = assign::Hash->new(node => $v, deepkey => $deepkey)->parse;
                    push @$elems, $struct;
                }
                else {
                    XXX $v, "Expecting [...] or {...}";
                }
            }

            return 1;
        }

        if ($type eq 'PPI::Token::Symbol') {
            my $str = $tok->content;
            if ($str =~ /^\$\w+$/) {
                push @$elems, assign::var->new($str);
                return 1;
            }
        }

        XXX $tok, "unexpected token";
    }
    return 0;
}

sub gen_code {
    my ($self, $decl, $oper, $from, $init) = @_;

    my $code = [ @$init ];
    my $elems = $self->{elems};

    if ($decl && (my @to_declares = grep $_->can("val"), @$elems)) {
        push @$code,
            "$decl(" .
            join(', ',
                 map $_->val,
                 @to_declares
            ) . ');'
    }

    for my $elem (@$elems) {
        my $type = ref $elem;
        if ( $type eq 'assign::Hash' ||  $type eq 'assign::Array' ) {
            my $_from = $from . ($elem->{deepkey} ?  "->" . $elem->{deepkey} : "");
            push @$code, $elem->gen_code($decl, $oper, $_from, $init);
        }
        else {
            my $var = $elem->val;
            (my $key = $var) =~ s/^\$//;
            my $deepkey = $elem->{deepkey};
            push @$code, "$var $oper $from\->$deepkey\{$key\};";
        }
    }

    return join "\n", @$code;
}

1;
