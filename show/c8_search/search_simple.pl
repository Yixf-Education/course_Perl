#!/usr/bin/perl

use strict;
use warnings;

my @numbers = map { $_ * 3 } ( 0 .. 1000000 );

sub search {
    my ( $numbers, $target ) = @_;
    for my $i ( 0 .. $#$numbers ) {
        return $i if $numbers->[$i] == $target;
    }
    return "Not found!";
}

print search( \@numbers, 3333 ), "\n";
print search( \@numbers, 3334 ),  "\n";
