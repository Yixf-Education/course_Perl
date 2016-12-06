#!/usr/bin/perl

use strict;
use warnings;

while (<>) {
    if (/^>/) {
        my ($id) = split;
        $id =~ s/>//;
        print "$id\n";
    }
}
