#打开警告开关
BEGIN { $^W = 1; }

#符号引用检查
use strict 'refs';

#数组中第一个元素的索引号
my $f  = $[;
my $ch = 0;

#注意字符串中有个换行符
my $q = r("\ntfgpfdfal,thg?bngbjnaxfcixz");
$_ = $q;
$q =~ tr/[]a-z/[]l-p r-za-k/;

my (@ever) = 1 .. &l;
my $mine = $q;

be($mine) foreach (@ever);

#获取字符串的长度
sub l {
    length $_;
}

#反转字符串
#join, 0均为凑数用，可以省略
sub r {
    join '', reverse( split( //, $_[0], 0 ) );
}

#提取字符串中的子串
sub ss {
    substr $_[0], $_[1], $_[2];
}

#输出
sub p {
    print @_;
}

#从字符串的前半段和后半段交替提取一个字符并输出
sub be {
    $_ = $_[0];
    p( ss( $_, $f, 1 ) );
    $f += l() / 2;
    $f %= l();
    ++$f if $ch % 2;
    $ch++;
}
