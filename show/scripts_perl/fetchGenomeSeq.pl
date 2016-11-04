#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use LWP::Simple;
use XML::Simple;
use Bio::Seq;
use Bio::SeqIO;

my ( $genome, $coordinate, $fi, $fo, $help );
GetOptions(
    "g|genome=s"     => \$genome,
    "c|coordinate=s" => \$coordinate,
    "i|input=s"      => \$fi,
    "o|output=s"     => \$fo,
    "h|help"         => \$help
);

if ($help) {
    print STDOUT <DATA>;
    exit(0);
}

$genome = $genome ? $genome : "hg19";

my $mode;
if ( ($coordinate) && ( !$fi ) ) {
    print STDERR "Using single mode...\n\n";

    #1 for single mode
    $mode = 1;
}
if ( ( !$coordinate ) && ($fi) ) {
    print STDERR "Using batch mode...\n\n";

    #0 for batch mode
    $mode = 0;
}
if ( ( !$coordinate ) && ( !$fi ) ) {
    print STDOUT <DATA>;
    exit(0);
}
if ( ($coordinate) && ($fi) ) {
    print STDERR "You can use single OR batch mode, but not both!\n\n";
    exit(0);
}

my $out;

#Save results to a file, or print them to the STDOUT
if ($fo) {
    $out = Bio::SeqIO->new( -file => ">$fo", -format => "Fasta" );
}
else {
    $out = Bio::SeqIO->new( -fh => \*STDOUT, -format => "Fasta" );
}

if ($mode) {

    #Single mode
    if ( $coordinate =~ /(chr.+):(\d+)-(\d+)/ ) {
        my $record = &process( $genome, $1, $2, $3 );
        $out->write_seq($record);
    }
    else {
        print STDOUT <DATA>;
        exit(0);
    }

}
else {

    #Batch mode
    open my $IN, '<', $fi or die "$0 : failed to open  input file '$fi' : $!\n";
    while (<$IN>) {
        chomp;
        my ( $chr_in, $start_in, $stop_in, @null ) = split /\t/;
        my $record = &process( $genome, $chr_in, $start_in, $stop_in );
        $out->write_seq($record);
    }
    close $IN or warn "$0 : failed to close input file '$fi' : $!\n";
}

sub process {
    my ( $g, $c, $s, $e ) = @_;

    #Get the XML results using DAS from UCSC
    my $url  = "http://genome.ucsc.edu/cgi-bin/das/$g/dna?segment=$c:$s,$e";
    my $page = get($url);

    #Parse the XML results
    my $xml    = new XML::Simple;
    my $data   = $xml->XMLin("$page");
    my $chr    = $data->{SEQUENCE}->{id};
    my $start  = $data->{SEQUENCE}->{start};
    my $stop   = $data->{SEQUENCE}->{stop};
    my $length = $data->{SEQUENCE}->{DNA}->{length};
    my $seq    = uc( $data->{SEQUENCE}->{DNA}->{content} );
    $seq =~ s/\n//g;
    my $id     = "$chr:$start-$stop";
    my $desc   = "genome=$genome;length=$length";
    my $record = Bio::Seq->new(
        -display_id => "$id",
        -desc       => "$desc",
        -seq        => "$seq",
        -moltype    => "dna"
    );
    return ($record);
}

__DATA__

Program:   fetchGenomeSequence.pl (v20110514)
Author:    Yixf (xfyin@sibs.ac.cn)
Summary:   Fetch subsequence(s) from a specified genome according to coordinate(s).

Usage:   fetchGenomeSequence.pl [OPTIONS] 

Options:
	-g, --genome   Specify a genome.[default: hg19]
	-c, --coordinate   The coordinate of a region in "chr1:10-20" format.
	-i, --input   The input file containing many coordinates.
	-o, --output   The output file to save FASTA result(s).
	-h, --help   Print this help message.

Notes:
	1. You can use -c (coordinate for single mode) OR -i (input file for batch mode), but not both at the same time.
	2. Unless you use -o, the results will be printed to the STDOUT[terminal].
	3. If you use -i, please pay attention to: 
		1) The delimiter in the file MUST be TAB.
		2) The file must have 3 columns at least.
		3) The first 3 columns MUST be "Chromosome,Start,Stop".
		4) Columns after the third column will be ignored.
		5) An example: "chr1\t10\t20".
	4. The coordinate uses 1-based system. (For more information, please refer to: http://yixf.name/2011/03/26/基因组的坐标系统：0-based与1-based/)

