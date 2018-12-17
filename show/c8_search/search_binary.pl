#!/usr/bin/perl

use strict;
use warnings;

my @numbers = map { $_ * 3 } ( 0 .. 1000000 );

sub search {
    my ( $numbers, $target ) = @_;
    return binary_search( $numbers, $target, 0, $#$numbers );
}

sub binary_search {
    my ( $numbers, $target, $low, $high ) = @_;
    return if $high < $low;

    # divide array in two
    my $middle = int( ( $low + $high ) / 2 );
    if ( $numbers->[$middle] > $target ) {

        # search the lower half
        return binary_search( $numbers, $target, $low, $middle - 1 );
    }
    elsif ( $numbers->[$middle] < $target ) {

        # search the upper half
        return binary_search( $numbers, $target, $middle + 1, $high );
    }

    # found it!
    return $middle;
}

print search( \@numbers, 3333 ), "\n";
print search( \@numbers, 3334 ),  "\n";
