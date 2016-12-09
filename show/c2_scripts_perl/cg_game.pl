#!/usr/bin/perl

use strict;
use warnings;

#use Smart::Comments;
die(
    qq/
Usage:   cg_game.pl <command>

Commands: 
	play	Play the "car or goat" game
	test	Test the game by computer
\n/
) if ( @ARGV == 0 );
if ( $ARGV[0] eq "play" ) {
    &play;
}
elsif ( $ARGV[0] eq "test" ) {
    &test;
}

sub play {
    my $box     = "123";
    my $box_car = 1 + int( rand(3) );
    ### $box_car
    $box =~ s/$box_car//;
    ### $box
    printf
"\nThere are three boxs:\033[32m box 1, 2 and 3\033[0m. One of them contains a car. Anothers contain goats.\nChoose one box now.[\033[31m1/2/3\033[0m]\n";
    chomp( my $user_choose = <STDIN> );
    while ( $user_choose !~ /^[123]$/ ) {
        print
"Please input 1, or 2, or 3, not others! Please type again.[\033[31m1/2/3\033[0m]\n";
        chomp( $user_choose = <STDIN> );
    }
    $box =~ s/$user_choose//;
    ### $box
    if ( length($box) == 1 ) {
        print "I open the box $box, and it's a goat.\n";
        print "Keep or change your choose?[\033[31mk/c\033[0m]\n";
        chomp( my $user_switch = <STDIN> );
        while ( $user_switch !~ /^[kc]$/ ) {
            print
"Please input k, or c, not others! Please type again.[\033[31mk/c\033[0m]\n";
            chomp( $user_switch = <STDIN> );
        }
        if ( $user_switch =~ /k/ ) {
            print
"Sorry! You missed the car, but you got a goat. Good luck next time.\n";
        }
        elsif ( $user_switch =~ /c/ ) {
            print
"Congratulations! You own the car now. Blind Tom meets dead Jerry. Do you think so?\n";
        }
    }
    else {
        my $open = int( rand(2) );
        my @tmp  = split //, $box;
        my $goat = $tmp[$open];
        print "I open the box $goat, and it's a goat.\n";
        $box =~ s/$goat//;
        print "Keep or change your choose?[\033[31mk/c\033[0m]\n";
        chomp( my $user_switch = <STDIN> );
        while ( $user_switch !~ /^[kc]$/ ) {
            print
"Please input k, or c, not others! Please type again.[\033[31mk/c\033[0m]\n";
            chomp( $user_switch = <STDIN> );
        }
        if ( $user_switch =~ /k/ ) {
            print
"Congratulations! You own the car now. Blind Tom meets dead Jerry. Do you think so?\n";
        }
        elsif ( $user_switch =~ /c/ ) {
            print
"Sorry! You missed the car, but you got a goat. Good luck next time.\n";
        }
    }
    print "\nPlay again, or quit the game?[\033[31ma/q\033[0m]\n";
    chomp( my $more = <STDIN> );
    while ( $more !~ /^[aq]$/ ) {
        print
"Please input a, or q, not others! Please type again.[\033[31ma/q\033[0m]\n";
        chomp( $more = <STDIN> );
    }
    if ( $more =~ /a/ ) {
        play();
    }
    elsif ( $more =~ /q/ ) {
        return 1;
    }
}

sub test {
    my ( $switch_num, $switch_car, $stay_num, $stay_car ) = 0;
    print
"I think you have 1/3 chance to get the car if you hold your choose. But if you change it, your chance doubles! That is, you have 2/3 chance to get the car.\n
Don't believe me? Test it now!\nPlease enter the number you want to repeat:\n";
    chomp( my $number = <STDIN> );
    while ( $number !~ /^\d+$/ ) {
        print "Please input a number, not others! Try again\n";
        chomp( $number = <STDIN> );
    }
    for ( my $i = 0 ; $i < $number ; $i++ ) {
        my $box     = "123";
        my $box_car = 1 + int( rand(3) );
        $box =~ s/$box_car//;
        my $user_choose = 1 + int( rand(3) );
        $box =~ s/$user_choose//;
        if ( length($box) == 1 ) {

            #0 for stay, and 1 for switch
            my $heart = int( rand(2) );
            if ( $heart == 0 ) {
                $stay_num++;

                #$stay_bad++;
            }
            else {
                $switch_num++;
                $switch_car++;
            }
        }
        else {
            my $heart = int( rand(2) );
            if ( $heart == 0 ) {
                $stay_num++;
                $stay_car++;
            }
            else {
                $switch_num++;

                #$switch_bad++;
            }
        }
    }
    my $switch_exp = $switch_num * 2 / 3;
    my $stay_exp   = $stay_num / 3;
    print "\nYour Choose\tStay\tSwitch\n";
    print "Total Number\t$stay_num\t$switch_num\n";
    print "Observed Cars\t$stay_car\t$switch_car\n";
    print "Expected Cars\t";
    printf "%.0f\t%.0f\n\n", $stay_exp, $switch_exp;
    print
"Trust me now? Don't know why? Please visit following links for explanation:\n	http://www.nytimes.com/2008/04/08/science/08monty.html?_r=1#\n	http://yixf.72pines.com/2011/01/17/%E8%92%99%E6%8F%90%E9%9C%8D%E5%B0%94%E9%97%AE%E9%A2%98%EF%BC%88%E5%B1%B1%E7%BE%8A%E5%92%8C%E8%BD%A6%E7%9A%84%E6%B8%B8%E6%88%8F%EF%BC%89/\n";
}

