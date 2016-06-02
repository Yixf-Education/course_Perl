#!/usr/bin/perl

use strict;
use warnings;

for ( my $i = 0 ; $i < 10000 ; $i++ ) {
    my $percent;
    my @percentages;
    my $result;
    my @random_DNA = ();
    @random_DNA = make_random_DNA_set( 100, 100, 100 );
    for ( my $k = 0 ; $k < scalar @random_DNA - 1 ; ++$k ) {
        for ( my $i = ( $k + 1 ) ; $i < scalar @random_DNA ; ++$i ) {
            $percent = matching_percentage( $random_DNA[$k], $random_DNA[$i] );
            push( @percentages, $percent );
        }
    }
    $result = 0;
    foreach $percent (@percentages) {
        $result += $percent;
    }
    $result = $result / scalar(@percentages);
    print "$result\n";
}

sub matching_percentage {
    my ( $string1, $string2 ) = @_;
    my ($length) = length($string1);
    my ($position);
    my ($count) = 0;
    for ( $position = 0 ; $position < $length ; ++$position ) {
        if (
            substr( $string1, $position, 1 ) eq
            substr( $string2, $position, 1 ) )
        {
            ++$count;
        }
    }
    return $count / $length;
}

sub make_random_DNA_set {
    my ( $minimum_length, $maximum_length, $size_of_set ) = @_;
    my $length;
    my $dna;
    my @set;
    for ( my $i = 0 ; $i < $size_of_set ; ++$i ) {
        $length = randomlength( $minimum_length, $maximum_length );
        $dna = make_random_DNA($length);
        push( @set, $dna );
    }
    return @set;
}

sub randomlength {
    my ( $minlength, $maxlength ) = @_;
    return ( int( rand( $maxlength - $minlength + 1 ) ) + $minlength );
}

sub make_random_DNA {
    my ($length) = @_;
    my $dna;
    for ( my $i = 0 ; $i < $length ; ++$i ) {
        $dna .= randomnucleotide();
    }
    return $dna;
}

sub randomnucleotide {
    my (@nucleotides) = ( 'A', 'C', 'G', 'T' );
    return randomelement(@nucleotides);
}

sub randomelement {
    my (@array) = @_;
    return $array[ rand @array ];
}
