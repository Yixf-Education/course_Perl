#!/usr/bin/perl 

use strict;
use warnings;
use Getopt::Long;
use Bit::Vector;
use 5.010;

my ( $from, $to, $bits, $help );

GetOptions(
    "f|from=s" => \$from,
    "t|to=s"   => \$to,
    "b|bits=i" => \$bits,
    "h|help"   => \$help
);

if ( $help || !$from || !@ARGV ) {
    print STDOUT <DATA>;
    exit(0);
}

$to   = $to   ? $to   : "a";
$bits = $bits ? $bits : 32;
my @items = @ARGV;

given ($from) {
    when (/^2$/) {
        print "Bin:\t";
        print join "\t", @items, "\n";
        given ($to) {
            when (/^2$/) { print "Bin:\t"; print join "\t", @items, "\n"; }
            when (/^8$/) { bin2oct(@items); }
            when (/^10$/) { bin2dec(@items); }
            when (/^16$/) { bin2hex(@items); }
            when (/^a$/)  { bin2oct(@items); bin2dec(@items); bin2hex(@items); }
            default { print STDOUT <DATA>; exit(0); }
        }
    }
    when (/^8$/) {
        print "Oct:\t";
        print join "\t", @items, "\n";
        given ($to) {
            when (/^2$/)  { oct2bin(@items); }
            when (/^8$/)  { print "Oct:\t"; print join "\t", @items, "\n"; }
            when (/^10$/) { oct2dec(@items); }
            when (/^16$/) { oct2hex(@items); }
            when (/^a$/) { oct2bin(@items); oct2dec(@items); oct2hex(@items); }
            default { print STDOUT <DATA>; exit(0); }
        }
    }
    when (/^10$/) {
        print "Dec:\t";
        print join "\t", @items, "\n";
        given ($to) {
            when (/^2$/)  { dec2bin(@items); }
            when (/^8$/)  { dec2oct(@items); }
            when (/^10$/) { print "Dec:\t"; print join "\t", @items, "\n"; }
            when (/^16$/) { dec2hex(@items); }
            when (/^a$/) { dec2bin(@items); dec2oct(@items); dec2hex(@items); }
            default { print STDOUT <DATA>; exit(0); }
        }
    }
    when (/^16$/) {
        print "Hex:\t";
        print join "\t", @items, "\n";
        given ($to) {
            when (/^2$/)  { hex2bin(@items); }
            when (/^8$/)  { hex2oct(@items); }
            when (/^10$/) { hex2dec(@items); }
            when (/^16$/) { print "Hex:\t"; print join "\t", @items, "\n"; }
            when (/^a$/) { hex2bin(@items); hex2oct(@items); hex2dec(@items); }
            default { print STDOUT <DATA>; exit(0); }
        }
    }
    default { print STDOUT <DATA>; exit(0); }
}

sub bin2oct {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Bin( $bits, "$a" );
        $b = reverse join( "", $vec->Chunk_List_Read(3) );
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Oct:\t";
    print join "\t", @b, "\n";
}

sub bin2dec {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Bin( $bits, "$a" );
        $b = $vec->to_Dec();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Dec:\t";
    print join "\t", @b, "\n";
}

sub bin2hex {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Bin( $bits, "$a" );
        $b = $vec->to_Hex();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Hex:\t";
    print join "\t", @b, "\n";
}

sub oct2bin {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new($bits);
        $vec->Chunk_List_Store( 3, split( //, reverse "$a" ) );
        $b = $vec->to_Bin();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Bin:\t";
    print join "\t", @b, "\n";
}

sub oct2dec {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new($bits);
        $vec->Chunk_List_Store( 3, split( //, reverse "$a" ) );
        $b = $vec->to_Dec();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Dec:\t";
    print join "\t", @b, "\n";
}

sub oct2hex {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new($bits);
        $vec->Chunk_List_Store( 3, split( //, reverse "$a" ) );
        $b = $vec->to_Hex();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Hex:\t";
    print join "\t", @b, "\n";
}

sub dec2bin {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Dec( $bits, $a );
        $b = $vec->to_Bin();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Bin:\t";
    print join "\t", @b, "\n";
}

sub dec2oct {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Dec( $bits, $a );
        $b = reverse join( "", $vec->Chunk_List_Read(3) );
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Oct:\t";
    print join "\t", @b, "\n";
}

sub dec2hex {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Dec( $bits, $a );
        $b = $vec->to_Hex();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Hex:\t";
    print join "\t", @b, "\n";
}

sub hex2bin {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Hex( $bits, "$a" );
        $b = $vec->to_Bin();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Bin:\t";
    print join "\t", @b, "\n";
}

sub hex2oct {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Hex( $bits, "$a" );
        $b = reverse join( "", $vec->Chunk_List_Read(3) );
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Oct:\t";
    print join "\t", @b, "\n";
}

sub hex2dec {
    my @a = @_;
    my @b;
    foreach my $a (@a) {
        my $vec = Bit::Vector->new_Hex( $bits, "$a" );
        $b = $vec->to_Dec();
        push @b, $b;
    }
    foreach (@b) { s/^0+//; }
    print "Hex:\t";
    print join "\t", @b, "\n";
}

__DATA__

Program:   radixConvert.pl (v20110517)
Author:    Yixf (xfyin@sibs.ac.cn)
Summary:   Convert between binary(bin, 2), octonary(oct, 8), decimal(dec, 10) and hexadecimal(hex, 16).

Usage:   radixConvert.pl [OPTIONS] number(s) 

Options:
	-f, --from [2|8|10|16]  Which you want to convert from.
	-t, --to [2|8|10|16|a]  Which you want to convert to. [defaule: a]
	-b, --bits Please refer to Bit::Vector for more information. [default: 32]
	-h, --help  Print this help message.

Notes:   
	1. -f must be specified.
	2. When -t is omitted, "a" will be used for all.
	2. Numbers must be seperated by space(s).

