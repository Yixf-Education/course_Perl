#!/usr/bin/perl

use strict;
use warnings;

{
    my %fib;

    sub F {
        my $n = shift;
        return 0 if $n == 0;
        return 1 if $n == 1;
        if ( not exists $fib{$n} ) {
            $fib{$n} = F( $n - 1 ) + F( $n - 2 );
        }
        return $fib{$n};
    }
}

print F( $ARGV[0] ), "\n";
