#!/usr/bin/env perl

use v5.16;

use assign::0;

my $people = [
    { name => 'Ingy',  favs => ['coffee', 'yellow'] },
    { name => 'Gugod', favs => ['tea', 'blue'] },
];

for my $person (@people) {
    my {
        $name,
        favs => [ $drink, $color ],
    } = $person;

    say "$name wears $color and drinks $drink.";
}
