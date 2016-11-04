#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

my $pointer   = 0;
my $character = 0;
my $string    = reverse("\ntfgpfdfal,thg?bngbjnaxfcixz");
$string =~ tr/a-z/l-p r-za-k/;
foreach ( 1 .. length($string) ) {
    print substr( $string, $pointer, 1 );
    $pointer += length($string) / 2;
    $pointer %= length($string);
    ++$pointer if $character % 2;
    $character++;
}
