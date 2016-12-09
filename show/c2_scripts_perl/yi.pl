#!/usr/bin/perl 

use warnings;
use strict;

use Getopt::Long;
use File::Find;
use File::Trash qw(trash);
use Class::Date qw(now);
use Date::Format;
use Encode;
use Benchmark;

my $version           = "1.0";
my $time              = now;
my $current_directory = `pwd`;
chomp($current_directory);

# used to calculate the running time
my $t0 = new Benchmark;

my ( $algorithm, $file_log, $mode_recursive, $mode_test, $mode_verbose, $help );
GetOptions(
    "a|algorithm=s" => \$algorithm,
    "l|log=s"       => \$file_log,
    "r|recursive"   => \$mode_recursive,
    "t|test"        => \$mode_test,
    "v|verbose"     => \$mode_verbose,
    "h|?|help"      => \$help
);

$algorithm = $algorithm ? $algorithm : "md5";
my $fl = "yi.log($time)";
$file_log = $file_log ? $file_log : $fl;

my $work_directory = join ", ", @ARGV;
my @path_list;
if ( !@ARGV || $help ) {
    die `pod2text $0`;
}
else {
    foreach (@ARGV) {
        chop if (/.*\/$/);
        if ( !-d $_ ) {
            print STDERR "\nThe path \e[31m $_ \e[0m does not exist!\n";
            exit(0);
        }
        else { push @path_list, $_; }
    }
}

$| = 1;
print "\nScanning the path(s) ...";
my @file_list;
my @dir_file;
foreach (@path_list) {
    if ($mode_recursive) {
        find( \&recursiveSearch, $_ );
    }
    else {
        @dir_file = glob "$_/*";
    }
    foreach (@dir_file) {
        if ( -f $_ ) {
            push @file_list, $_;
        }
    }
}
print " Done!\n\nAnalyzing ...\n";

my $cmd;
if ( $algorithm eq "md5" ) {
    unless (`which md5deep`) {
        print STDERR
"\n\e[31m md5deep \3[0m can not be found. You can install it by:\n\e[34m sudo apt-get install md5deep \e[0m\n";
        exit(0);
    }
    $cmd = "md5deep";
}
elsif ( $algorithm eq "sha1" ) {
    unless (`which sha1deep`) {
        print STDERR
"\n\e[31m sha1deep \3[0m can not be found. You can install it by:\n\e[34m sudo apt-get install md5deep \e[0m\n";
        exit(0);
    }
    $cmd = "sha1deep";
}
elsif ( $algorithm eq "crc" ) {
    unless (`which crc32`) {
        print STDERR
"\n\e[31m crc32 \3[0m can not be found. And I am sorry I don't known how to install it!\n";
        exit(0);
    }
    $cmd = "crc32";
}
else {
    print
"\n\nI don't known \e[31m $algorithm \e[0m is what algorithm. I think \e[34m md5 \e[0m, \e[34m sha1 \e[0m or \e[34m crc \e[0m is enough.\n\n";
}

my $bar_n     = @file_list;
my $bar_index = 1;
my %duplicate;
my $digest;
foreach my $file (@file_list) {
    my @tmp = split /\s+/, `$cmd "$file"`;
    $digest = $tmp[0];
    chomp($digest);

    # digest is the key, value is an array whose elements are files
    push @{ $duplicate{$digest} }, $file;
    ProgressBar( $bar_index, $bar_n );
    if ($mode_verbose) {
        print " $file\n";
    }
    $bar_index++;
}
print "\n\e[32m ", $#file_list + 1, " \e[0m files analyzed!\n";

my $group_test = "001";
my @info_test;
foreach my $hash ( sort keys %duplicate ) {
    if ( @{ $duplicate{$hash} } > 1 ) {
        foreach my $single_file ( @{ $duplicate{$hash} } ) {
            my @stat = stat($single_file);
            push @info_test,
              (
                join "\t",
                $group_test,
                $hash,
                NiceSize( $stat[7] ),
                NiceTime( $stat[9] ),
                encode( "gbk", decode( "utf-8", $single_file ) )
              );
        }
        $group_test++;
    }
}

my @info_move;
my $number_move = "000";
if ($mode_test) {
    if ( $group_test eq "001" ) {
        print STDOUT "\n\033[32m 0 \033[0m duplicate file found!\n";
    }
    else {
        print STDOUT "\n\033[31m ", $group_test - 1,
          " \033[0m duplicate groups found!\n";
    }
}
else {
    my $group_move = "001";
    foreach my $hash ( sort keys %duplicate ) {
        if ( @{ $duplicate{$hash} } > 1 ) {
            for ( my $i = 0 ; $i < $#{ $duplicate{$hash} } ; $i++ ) {
                $number_move++;
                my @sorted_duplicate = sort @{ $duplicate{$hash} };
                push @info_move,
                  (
                    join "\t", $number_move, $group_move,
                    encode( "gbk", decode( "utf-8", $sorted_duplicate[$i] ) )
                  );
                trash( $sorted_duplicate[$i] );
            }
            $group_move++;
        }
    }
    if ( $group_test eq "001" ) {
        print STDOUT "\n\033[32m 0 \033[0m duplicate file found!\n";
    }
    else {
        print STDOUT "\n\033[31m ", $group_test - 1,
          " \033[0m duplicate groups found!\n";
    }
}

# used to calculate the running time
my $t1 = new Benchmark;

# calculate the running time
my $td = Benchmark::timediff( $t1, $t0 );
$td = Benchmark::timestr($td);

open LOG, ">$file_log";
select LOG;
print "### Script info and your options ###\n";
print "Program: $0;\tVersion: $version\n";
print "Date&Time: $time\n";
print "CurrentDirectory: $current_directory;\tWorkDirectory: $work_directory\n";
print "Algorithm: \U$algorithm\E\n";
print "Recursive: ", SwitchFlag($mode_recursive), ";\tTest: ",
  SwitchFlag($mode_test), "\n";
print "LogFile: $file_log\n";
print "\n\n### Groups of duplicate files ###\n";
print "Group\t\U$algorithm\E\t\t\t\t\t\t\t\tSize\tMTime\t\t\t\tFile\n";
print "-" x 80;

my %hash_test;
my $flag_test;
foreach (@info_test) {
    my ( $group_test, @other ) = split /\t/;
    $_ .= "\n";
    if ( exists( $hash_test{$group_test} ) ) {
        print "$_";
        $flag_test = 1;
    }
    else {
        print "\n$_";
        $flag_test = 1;
        $hash_test{$group_test} = 1;
    }
}
unless ($flag_test) {
    print "\n";
}
print "=" x 80;
if ( $group_test eq "001" ) {
    print "\n0 duplicate file found!\n";
}
else {
    print "\n", $group_test - 1, " duplicate groups found!\n\n";
}

print "\n### Duplicate files removed ###\n";
print "Number\tGroup\tFile\n";
print "-" x 80;
my %hash_move;
my $flag_move;
foreach (@info_move) {
    my ( $num, $group_move, @other ) = split /\t/;
    $_ .= "\n";
    if ( exists( $hash_move{$group_move} ) ) {
        print "$_";
        $flag_move = 1;
    }
    else {
        print "\n$_";
        $flag_move = 1;
        $hash_move{$group_move} = 1;
    }
}
unless ($flag_move) {
    print "\n";
}
print "=" x 80;
if ( $number_move eq "000" ) {
    print "\n0 duplicate file removed!\n";
    print STDOUT "\033[32m 0 \033[0m duplicate file removed!\n";
}
else {
    print "\n", $number_move - 0, " duplicate files removed!\n";
    print STDOUT "\n\033[31m ", $number_move - 0,
      " \033[0m duplicate files removed!\n";
}
print "\n\nTime expend: $td\n\n";
close LOG;

print STDOUT "\nTime expend: $td\n\n";

sub recursiveSearch {
    push @dir_file, $File::Find::name;
}

sub ProgressBar {
    local $| = 1;
    my $i = $_[0] || return 0;
    my $n = $_[1] || return 0;
    print "\r\033[36m[\033[33m"
      . ( "#" x int( ( $i / $n ) * 50 ) )
      . ( " " x ( 50 - int( ( $i / $n ) * 50 ) ) )
      . "\033[36m]";
    printf( " %2.1f%%\033[0m", $i / $n * 100 );
    local $| = 0;
}

# get the switch value -- YES or NO
sub SwitchFlag {
    my $option = shift;
    return ($option) ? "YES" : "NO";
}

sub NiceTime {
    my $mtime = shift;
    my $nice_mtime = time2str( '%Y-%m-%d %H:%M:%S', $mtime );
    return $nice_mtime;
}

# change file size to human readable format
sub NiceSize {
    my $bsize = shift;
    my $mod   = 1024;
    my @units = ( "b", "k", "M", "G", "T", "P" );
    my $i;
    for ( $i = 0 ; $bsize >= $mod ; $i++ ) {
        $bsize /= $mod;
    }
    my $nice_size = sprintf( "%.2f", $bsize );
    return "$nice_size$units[$i]";
}

__END__

=head1 Name

yi.pl -- find (and remove) duplicate files in one directory (or directories) on *nix system

=head1 Description

This program can find duplicate files in a directory or several directories, and to remove the redundancy files.

Tips: If you want to scan folder(s) including their subfolder(s), please use "-r" for the recursive mode. 
 
=head1 Usage

 perl yi.pl [options] <dir1> [dir2] [dir3] ...
 ./yi.pl [options] <dir1> [dir2] [dir3] ...

=head1 Options

 -a|algorithm <str>	Hash algorithm: md5, crc, sha1. [default: md5]
 -l|--log <str>	Log file. [default: yi.log]
 -r|--recursive	Recursive mode. 
 -t|--test	Test mode: get the redundancy information, and do nothing else.
 -v|--verbose	Verbose mode: output running progress info_testrmation to the screen. 
 -h|-?|--help	Output this help info_testrmation to the screen.

=head1 Example

 perl yi.pl .
 perl yi.pl -r . /home/
 perl yi.pl -t .
 perl yi.pl -t -r -l log.txt /home/

=head1 Note 

 1. "YI" means "DU YI WU ER", in English, only one.
 2. Log file will be created under CURRENT directory, not WORK directory.
 3. Redundancy files are removed to TRASH actually, so it's possible to turn back the clock before reboot.
 4. The dir for TRASH is "/tmp/trash" on Linux. 

=head1 Version 

 Author: Yixf, yixf1986@gmail.com
 Version: beta	Date: 2010-11-13
 Version: 0.09	Date: 2010-11-15
 Version: 0.1	Date: 2010-11-23
 Version: 1.0	Date: 2011-05-22

=cut

