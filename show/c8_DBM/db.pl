#!/usr/bin/perl

use warnings;
use strict;
use DB_File;
my ( %h, $k, $v );

unlink "fruit";
tie %h, "DB_File", "fruit", O_RDWR | O_CREAT, 0666, $DB_HASH
  or die "Cannot open file 'fruit': $!\n";

# Add a few key/value pairs to the file
$h{"apple"}  = "red";
$h{"orange"} = "orange";
$h{"banana"} = "yellow";
$h{"tomato"} = "red";

# Check for existence of a key
print "Banana Exists\n\n" if $h{"banana"};

# Delete a key/value pair.
delete $h{"apple"};

# print the contents of the file
while ( ( $k, $v ) = each %h ) { print "$k -> $v\n" }

untie %h;
