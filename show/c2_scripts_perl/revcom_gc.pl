#!/usr/bin/perl 

use strict;
use warnings;

my $dna    = "ACGGGCGGCACGGGAAAAAATTTTTAACTCTTACGCG";
my $revcom = reverse $dna;
$revcom =~ tr /ACGT/TGCA/;
print "Input DNA:\n$dna\nReverse complementary DNA:\n$revcom\n\n";
my $gc = $revcom =~ tr/GC//;
my $gc_content = sprintf( "%.2F", $gc / length($revcom) * 100 );
print "GC number:\t$gc\n";
print "GC content:\t${gc_content}%\n";

