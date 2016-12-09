#!/usr/bin/perl

use warnings;
use strict;

my $dna = "CGACGTCTTCTAAGGCGA";
my $subsequence = @ARGV ? $ARGV[0] : "TC";

for ( my $i = 0 ; $i < length($dna) - 1 ; $i++ ) {
    if ( substr( $dna, $i, 2 ) eq $subsequence ) {
        print substr( $dna, $i );
        print "\n";

        # last;
    }
}
