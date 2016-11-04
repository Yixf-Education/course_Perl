#!/usr/bin/perl 

use strict;
use warnings;

use Getopt::Std;

my %opts = ( n => 10 );
getopts( 'n:', \%opts );

&usage if ( @ARGV != 1 );

my $fi = $ARGV[0];
open my $IN, '<', $fi or die "$0 : failed to open  input file '$fi' : $!\n";

if ( $opts{n} == 1 ) {
    my $line;
    srand;
    rand($.) < 1 && ( $line = $_ ) while <$IN>;
    print $line;
}
elsif ( $opts{n} > 1 ) {
    my $n = $opts{n};
    my @lines;
    my $k = 0;
    srand;
    while (<$IN>) {
        $k++;
        if ( $k <= $n ) {
            push( @lines, $_ );
        }
        else {
            my $r = int( rand($k) );
            if ( $r < $n ) {
                $lines[$r] = $_;
            }
        }
    }
    foreach my $line (@lines) {
        print $line;
    }
}
else {
    print STDERR "The number must be integer!\n";
}

close $IN or warn "$0 : failed to close input file '$fi' : $!\n";

sub usage {
    die(
        qq/
Usage:   randLines.pl [options] <file>

Options:  -n INT   The number of lines. [$opts{n}]

Author:  Yixf, yixf1986\@gmail.com

Versions: v1.0, 2012-03-06
\n/
    );
}

