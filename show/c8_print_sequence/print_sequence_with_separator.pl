#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $dna  = "ACGT" x 100;
my $len  = 60;
my $step = 10;
my $sep  = " ";
print_sequence_with_separator( $dna, $len, $step, $sep );

sub print_sequence_with_separator {
    my ( $sequence, $length, $step, $separator ) = @_;
    use strict;
    use warnings;

    if ( $step !~ /^\d+$/ ) {
        $separator = $step;
        $step      = undef;
    }
    $step      = 10  unless $step;
    $separator = " " unless $separator;

    my $n = length( length($sequence) );

    for ( my $pos = 0 ; $pos < length($sequence) ; $pos += $length ) {
        my $sub_sequence = substr( $sequence, $pos, $length );
        my $line;
        for ( my $i = 0 ; $i < length($sub_sequence) ; $i += $step ) {
            $line .= substr( $sub_sequence, $i, $step ) . $separator;
        }
        $line =~ s/$separator$//;

        # print add_prefix( 0, $n, $pos, $line );
        print add_prefix( 1, $n, $pos, $line );
        print "\n";
    }
}

sub add_prefix {
    my ( $prefix, $n, $pos, $line ) = @_;

    my $new_line;
    if ($prefix) {
        $new_line = sprintf "%${n}d", $pos + 1;
        $new_line .= " $line";
    }
    else {
        $new_line = $line;
    }
    return ($new_line);
}

