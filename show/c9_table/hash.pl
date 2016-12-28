#!/usr/bin/perl

use strict;
use warnings;

my $fi = "country.txt";
my ( @header, @fields );
my %countries;

open my $IN, '<', $fi or die "$0 : failed to open  input file '$fi' : $!\n";
while (<$IN>) {
    chomp;
    if ( $. == 1 ) {
        @header = map { lc } split /\t/;
    }
    else {
        @fields = map { lc } split /\t/;
        for ( my $i = 1 ; $i < @header ; $i++ ) {
            $countries{ $fields[0] }->{ $header[$i] } = $fields[$i];
        }
    }
}
close $IN or warn "$0 : failed to close input file '$fi' : $!\n";

print "Population of France is ", $countries{france}->{population}, "\n";
