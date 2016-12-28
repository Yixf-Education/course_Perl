#!/usr/bin/perl

use strict;
use warnings;
use Data::Table;

my $countries = Data::Table::fromFile("country.txt");

print "Population of France is ",
  $countries->
  match_pattern_hash('$_{Country} eq "France"')->
  col('Population'),
  "\n";
