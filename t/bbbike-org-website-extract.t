#!/usr/bin/perl
# Copyright (c) Sep 2012-2013 Wolfram Schneider, http://bbbike.org

use Test::More;
use strict;
use warnings;

BEGIN {
    if ( $ENV{BBBIKE_TEST_NO_NETWORK} ) {
        print "1..0 # skip due no network\n";
        exit;
    }
    if ( $ENV{BBBIKE_TEST_SLOW_NETWORK} ) {
        print "0..0 # skip some test due slow network\n";
    }
}

use LWP;
use LWP::UserAgent;

my $homepage = 'http://extract.bbbike.org';
my @lang     = qw/en de ru es fr/;
my @extract_dialog =
  qw/about.html email.html format.html name.html polygon.html select-area.html/;

use constant MYGET => 3;

if ( !$ENV{BBBIKE_TEST_SLOW_NETWORK} ) {
    plan tests => MYGET * scalar(@lang) +
      ( MYGET * scalar(@extract_dialog) * scalar(@lang) ) + 31;
}
else {
    plan 'no_plan';
}

my $ua = LWP::UserAgent->new;
$ua->agent("BBBike.org-Test/1.0");

sub myget {
    my $url  = shift;
    my $size = shift;

    $size = 10_000 if !defined $size;

    my $req = HTTP::Request->new( GET => $url );
    my $res = $ua->request($req);

    isnt( $res->is_success, undef, "$url is success" );
    is( $res->status_line, "200 OK", "status code 200" );

    my $content = $res->decoded_content();
    cmp_ok( length($content), ">", $size, "greather than $size for URL $url" );

    return $res;
}

sub html {
    foreach my $l (@lang) {
        myget( "$homepage/?lang=$l", 9_000 );
    }
    foreach my $l (@lang) {
        foreach my $file (@extract_dialog) {
            myget( "$homepage/extract-dialog/$l/$file", 420 );
        }
    }

    myget( "$homepage/html/extract.css",         3_000 );
    myget( "$homepage/html/extract.js",          1_000 );
    myget( "$homepage/extract.html",             12_000 );
    myget( "$homepage/extract-screenshots.html", 4_000 );

    if ( !$ENV{BBBIKE_TEST_SLOW_NETWORK} ) {
        my $res = myget( "$homepage", 10_000 );
        like( $res->decoded_content, qr|id="map"|,           "bbbike extract" );
        like( $res->decoded_content, qr|polygon_update|,     "bbbike extract" );
        like( $res->decoded_content, qr|"garmin-cycle.zip"|, "bbbike extract" );
        like( $res->decoded_content,
            qr|Content-Type" content="text/html; charset=utf-8"|, "charset" );

        myget( "$homepage/html/jquery/jquery-ui-1.9.1.custom.min.js", 1_000 );
        myget( "$homepage/html/jquery/jquery-1.7.1.min.js",           20_000 );
        myget( "$homepage/html/OpenLayers/2.12/OpenStreetMap.js",     10_000 );
        myget( "$homepage/html/OpenLayers/2.12/OpenLayers-min.js",    500_000 );
    }
}

&html;

__END__
