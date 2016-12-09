#!/usr/bin/perl

use strict;
use warnings;

my @numbers = map { $_ * 3 } ( 0 .. 1000000 );

sub search {
    my ( $numbers, $target ) = @_;
    for my $i ( 0 .. $#$numbers ) {
        return $i if $numbers->[$i] == $target;
    }
    return;
}

print search( \@numbers, 699 ), "\n";
print search( \@numbers, 28 ),  "\n";
