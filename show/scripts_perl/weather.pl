#!/usr/bin/perl 

use strict;
use warnings;

use utf8;
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

use Getopt::Long;
use Date::Simple ( 'date', 'today' );
use LWP::Simple;
use JSON;

my ( $id, $help );
GetOptions(
    "i|id=s" => \$id,
    "h|help" => \$help
);

#101020100是上海的ID
#$id = $id ? $id : "101020100";
#101030100是天津的ID
$id = $id ? $id : "101030100";

if ($help) {
    print STDOUT <DATA>;
    exit(0);
}

my $today = today();
my $week  = $today->day_of_week();
my %weeks = (
    "0" => "星期日",
    "1" => "星期一",
    "2" => "星期二",
    "3" => "星期三",
    "4" => "星期四",
    "5" => "星期五",
    "6" => "星期六"
);
my ( @days, @weeks );
for ( my $i = 0 ; $i < 6 ; $i++ ) {
    my $t = $today + $i;
    push @days, $t;
    my $w = $t->day_of_week();
    push @weeks, $weeks{$w};
}

my $url_current  = "http://wap.weather.com.cn/data/sk/$id.html";
my $url_forcast  = "http://m.weather.com.cn/data/$id.html";
my $page_current = get($url_current);
my $page_forcast = get($url_forcast);
my $json         = JSON->new->allow_nonref;
my $current      = $json->decode($page_current);
my $cwi          = $current->{weatherinfo};
my $forcast      = $json->decode($page_forcast);
my $fwi          = $forcast->{weatherinfo};

print "*" x 60, "\n";
print "*   ", $fwi->{city}, ",", $fwi->{city_en}, "\t", $fwi->{date}, ",",
  $fwi->{date_y}, "\t", $fwi->{week}, "   *\n";
print "*" x 60, "\n\n";

print "*" x 10, "\n*当前实况*\n", "*" x 10, "\n";
print "时间\t气温\t风向\t风力\t相对湿度\n";
print "-" x 40, "\n";
print $cwi->{time}, "\t", $cwi->{temp}, "\t", $cwi->{WD}, "\t", $cwi->{WS},
  "\t", $cwi->{SD}, "\n";

print "\n", "*" x 10, "\n*一周预报*\n", "*" x 10, "\n";
print "日期\t\t星期\t气温\t\t天气\t\t风向与风力\n";
print "-" x 80, "\n";
for ( my $i = 0 ; $i < 6 ; $i++ ) {
    my $index = $i + 1;
    print "$days[$i]\t$weeks[$i]\t", $fwi->{"temp$index"}, "\t\t",
      $fwi->{"weather$index"}, "\t\t", $fwi->{"wind$index"}, "\n";
}

print "\n", "*" x 10, "\n*生活指数*\n", "*" x 10, "\n";
print "穿衣指数：\t", $fwi->{index}, "。", $fwi->{index_d}, "\n";
print "紫外线指数：\t", $fwi->{index_uv}, "。\n";
print "旅游指数：\t",    $fwi->{index_tr}, "。\n";
print "舒适度指数：\t", $fwi->{index_co}, "。\n";
print "晨练指数：\t",    $fwi->{index_cl}, "。\n";
print "晾晒指数：\t",    $fwi->{index_ls}, "。\n";

__DATA__

Program:   weather.pl (v20110715)
Author:    Yixf (xfyin@sibs.ac.cn)
Summary:   Fetch weather information from 中国天气网(http://www.weather.com).

Usage:   weather.pl [OPTIONS] 

Options:
	-i, --id   The ID of your city.
	-h, --help   Print this help message.

Notes:
	获取城市ID的方法（以上海市为例）：
	0. 下面链接中的level参数均可省略。
	1. 访问http://m.weather.com.cn/data5/city.xml?level=0得到一级列表（省、直辖市、自治区）。结果用逗号隔开，ID和城市名称使用竖线“|”隔开。
	2. 访问http://m.weather.com.cn/data5/city02.xml?level=1得到二级列表。
	3. 访问http://m.weather.com.cn/data5/city0201.xml?level=2得到三级列表。
	4. 访问http://m.weather.com.cn/data5/city020101.xml?level=3得到最后一级的ID，后面的数字就是获得天气数据需要的城市ID。
