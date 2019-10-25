#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $string = "abxxxxxxyz";

print "Position\tPrematch\tMatch\tPosmatch\n";

print "\n# Match exact 'xx':\n";
while ( $string =~ /x{2}/g ) {
    my $pos = pos($string);
    print join "\t", $pos, $`, $&, $';
    print "\n";
}

print "\n# Match two or three x with greedy mode:\n";
while ( $string =~ /x{2,3}/g ) {
    my $pos = pos($string);
    print join "\t", $pos, $`, $&, $';
    print "\n";
}

print "\n# Match two or three x with non-greedy mode:\n";
while ( $string =~ /x{2,3}?/g ) {
    my $pos = pos($string);
    print join "\t", $pos, $`, $&, $';
    print "\n";
}
