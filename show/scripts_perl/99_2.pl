#!/usr/bin/perl 

use strict;
use warnings;
use utf8;

for ( my $i = 1 ; $i <= 9 ; $i++ ) {
    for ( my $j = 1 ; $j <= $i ; $j++ ) {
        print "$j" . "x" . "$i" . "=" . $i * $j;
        if   ( $j == $i ) { print "\n"; }
        else              { print "\t"; }
    }
}
