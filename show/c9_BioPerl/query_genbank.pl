#!/usr/bin/perl

use strict;
use warnings;

use Bio::DB::Query::GenBank;
use Bio::DB::GenBank;
use Bio::SeqIO;

my $query_string = $ARGV[0];
my $fo_fa        = $query_string . ".fa";
my $fo_gb        = $query_string . ".gb";
my $query        = Bio::DB::Query::GenBank->new(
    -db    => 'nucleotide',
    -query => $query_string
);

my $gb = Bio::DB::GenBank->new;

my $stream = $gb->get_Stream_by_query($query);

my %outfiles = (
    Fasta => Bio::SeqIO->new(
        -file   => ">$fo_fa",
        -format => 'Fasta',
    ),
    Genbank => Bio::SeqIO->new(
        -file   => ">$fo_gb",
        -format => 'Genbank',
    ),
);

while ( my $seq = $stream->next_seq ) {
    $outfiles{'Fasta'}->write_seq($seq);
    $outfiles{'Genbank'}->write_seq($seq);
}

