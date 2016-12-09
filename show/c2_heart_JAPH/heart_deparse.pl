BEGIN { $^W = 1; }
use strict 'refs';
my $f = $[;
my $ch = 0;
sub l {
    length $_;
}
sub r {
    join '', reverse(split(//, $_[0], 0));
}
sub ss {
    substr $_[0], $_[1], $_[2];
}
sub be {
    $_ = $_[0];
    p(ss($_, $f, 1));
    $f += l() / 2;
    $f %= l();
    ++$f if $ch % 2;
    $ch++;
}
my $q = r("\ntfgpfdfal,thg?bngbjnaxfcixz");
$_ = $q;
$q =~ tr/[]a-z/[]l-p r-za-k/;
my(@ever) = 1 .. &l;
my $mine = $q;
sub p {
    print @_;
}
be $mine foreach (@ever);
