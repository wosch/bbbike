#!/usr/local/bin/perl
# Copyright (c) Sep 2012-2015 Wolfram Schneider, http://bbbike.org

BEGIN {
    if ( $ENV{BBBIKE_TEST_NO_NETWORK} || $ENV{BBBIKE_TEST_SLOW_NETWORK} ) {
        print "1..0 # skip due slow or no network\n";
        exit;
    }
}

use utf8;    # test contains unicode characters, see Test::More::UTF8;
use Encode;
use Test::More;

use lib qw(./world/lib ../lib);
use Test::More::UTF8;
use BBBike::Test;

use strict;
use warnings;

my $test = BBBike::Test->new();

my @cities = qw/Berlin Cottbus Toronto/;

# unicode cities
my @cities_utf8 = (
    "Київ",                                "‏بيروت",
    "กรุงเทพมหานคร", "Thành phố Hồ Chí Minh",
    "София"
);

my @list = (
    {
        'page'     => 'http://www.bbbike.org',
        'min_size' => 10_000,
        'match'    => [ "</html>", @cities, @cities_utf8 ]
    },
    {
        'page'     => 'http://m.bbbike.org',
        'min_size' => 1_000,
        'match'    => [ "</html>", @cities ]
    },
    {
        'page'     => 'http://www.bbbike.org/en/',
        'min_size' => 10_000,
        'match'    => [ "</html>", @cities ]
    },
    {
        'page'     => 'http://www.bbbike.org/de/',
        'min_size' => 10_000,
        'match'    => [ "</html>", @cities ]
    },
    {
        'page'     => 'http://extract.bbbike.org',
        'min_size' => 5_000,
        'match'    => [ "</html>", "about" ]
    },
    {
        'page'     => 'http://download.bbbike.org/osm/',
        'min_size' => 2_000,
        'match' =>
          [ "</html>", "Select your own region", "offers a database dump" ]
    },
    {
        'page'     => 'http://mc.bbbike.org/osm/',
        'min_size' => 1_500,
        'match'    => [ "</html>", qq/ id="map">/ ]
    },
    {
        'page'     => 'http://mc.bbbike.org/mc/',
        'min_size' => 5_000,
        'match'    => [ "</html>", "Choose map type", ' src="js/mc.js"' ]
    },
    {
        'page' =>
          'http://a.tile.bbbike.org/osm/mapnik-german/15/17602/10746.png',
        'min_size'  => 10_000,
        'match'     => [],
        'mime_type' => 'image/png'
    },
);

my $count = 3 * scalar(@list);
foreach my $obj (@list) {
    $count += scalar( @{ $obj->{'match'} } );
}

plan tests => $count;

my $ua = $test->{'ua'};

foreach my $obj (@list) {
    my $url = $obj->{'page'};

    my $resp = $ua->get($url);
    ok( $resp->is_success, $url );

    my $mime_type = exists $obj->{mime_type} ? $obj->{mime_type} : "text/html";
    is( $resp->content_type, $mime_type, "page $url is $mime_type" );
    my $content = $resp->decoded_content;
    my $content_length =
      defined $resp->content_length ? $resp->content_length : length($content);

    cmp_ok( $content_length, ">", $obj->{min_size},
            "page $url is greather than: "
          . $content_length . " > "
          . $obj->{min_size} );

    next if !exists $obj->{'match'};
    foreach my $match ( @{ $obj->{'match'} } ) {
        like $content, qr{$match}, qq{Found string '$match'};
    }
}

__END__