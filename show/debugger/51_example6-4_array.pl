#!/usr/bin/perl

use warnings;
use strict;

my $dna = "CGACGTCTTCTAAGGCGA";
my $subsequence = @ARGV ? $ARGV[0] : "TC";

my @dna = split "", $dna;
my $base1 = substr( $subsequence, 0, 1 );
my $base2 = substr( $subsequence, 1, 1 );

for ( my $i = 0 ; $i < @dna - 1 ; $i++ ) {
    if ( $dna[$i] eq $base1 ) {
        if ( $dna[ $i + 1 ] eq $base2 ) {
            print join "", @dna[ $i .. $#dna ];
            print "\n";

            # last;
        }
    }
}
