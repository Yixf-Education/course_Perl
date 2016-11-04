#!/usr/bin/perl 

use strict;
use warnings;

use Getopt::Std;
use Math::Counting;

my %opts;
my ( $n, $r );

getopts( 'aecfpn:r:h', \%opts );

if ( @ARGV == 0 || exists $opts{h} ) {
    print STDOUT <DATA>;
    exit(0);
}

if ( exists $opts{n} ) {
    $n = $opts{n};
}
elsif ( @ARGV == 1 || @ARGV == 2 ) {
    $n = $ARGV[0];
}
else {
    print STDOUT <DATA>;
    exit(0);
}

if ( exists $opts{r} ) {
    $r = $opts{r};
}
elsif ( @ARGV == 2 ) {
    $r = $ARGV[1];
}
elsif ( defined($n) ) {
}
else {
    print STDOUT <DATA>;
    exit(0);
}

unless ( $n =~ /^\d+$/ ) {
    print "Please input an NATURAL NUMBER for \"n\"!\n";
    exit(0);
}
if ( defined($r) && $r !~ /^\d+$/ ) {
    print "Please input an NATURAL NUMBER for \"r\"!\n";
    exit(0);
}

my $f  = Math::Counting::bfact($n);
my $fe = Math::Counting::factorial($n);
my ( $p, $pe, $c, $ce );
if ( defined($r) ) {
    $p = Math::Counting::bperm( $n, $r );
    $pe = Math::Counting::permutation( $n, $r );
    $c = Math::Counting::bcomb( $n, $r );
    $ce = Math::Counting::combination( $n, $r );
}

if ( exists $opts{e} ) {
    $f = $fe;
    $p = $pe;
    $c = $ce;
}

if ( exists $opts{a}
    || ( !( exists $opts{f} ) && !( exists $opts{p} ) && !( exists $opts{c} ) )
  )
{
    if ( defined($r) ) {
        print "$n!     = $f\n";
        print "P($n,$r) = $p\n";
        print "C($n,$r) = $c\n";
    }
    else {
        print "$n!     = $f\n";
    }
}

if ( exists $opts{f} ) {
    print "$f\n";
}

if ( exists $opts{p} ) {
    if ( defined($r) ) {
        print "$p\n";
    }
    else {
        print
          "Please input the \"r\" if you want to compute the permutations.\n";
    }
}

if ( exists $opts{c} ) {
    if ( defined($r) ) {
        print "$c\n";
    }
    else {
        print
          "Please input the \"r\" if you want to compute the combinations.\n";
    }
}

__DATA__

Program:   fpc.pl (v20110927)
Author:    Yixf (yixf1986@gmail.com)
Summary:   Compute the factorial, number of permutations/arrangements and number of combinations.

Usage:   fpc.pl [OPTIONS] (N|-n N) (R|-r R)

Options:
	-a  (All) Compute the factorial, permutations/arrangements and combinations. [default]
	-e  Use the scientific notation.
	-f  (Factorial) Return the number of arrangements of n.
	-p  (Permutation) Return the number of arrangements of r elements drawn from a set of n elements.
	-c  (Combination) Return the number of ways to choose r elements from a set of n elements.
	-n  (N) The number of elements to draw from.
	-r  (R) The number of elements to choose.

