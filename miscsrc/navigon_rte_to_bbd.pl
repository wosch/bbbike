#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: navigon_rte_to_bbd.pl,v 1.4 2006/06/20 19:45:16 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 2006 Slaven Rezic. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: slaven@rezic.de
# WWW:  http://www.rezic.de/eserte/
#

# Simple conversion of navigon route (rte) format

# Sample data can be found here:
# http://www.tourentiger.de/

use strict;
use FindBin;
use lib ("$FindBin::RealBin/..",
	 "$FindBin::RealBin/../lib",
	);
use Karte::Standard;
use Karte::Polar;

my($lastx,$lasty);
while(<>) {
    my @row = split /\|/;
    my($plz1,$ort,$plz2,$street,$lon,$lat);
    if (@row == 18) {
	(undef,undef,undef,undef,$plz1,$ort,$plz2,$street,undef,undef,undef,$lon,$lat,undef,undef,undef,undef,undef) = @row;
    } else { # older format?
	(undef,undef,undef,$plz1,$ort,$plz2,$street,undef,undef,undef,$lon,$lat,undef) = @row;
    }
    my $name;
    if ($street ne "-") {
	$name = "$street ($ort)";
    } else {
	$name = $ort;
    }
    my $cat = "X";
    my($x, $y) = $Karte::Standard::obj->trim_accuracy($Karte::Polar::obj->map2standard($lon,$lat));
    print "$name\t$cat $x,$y\n";
    if (defined $lastx && defined $lasty) {
	print "\t$cat $lastx,$lasty $x,$y\n";
    }
    $lastx = $x;
    $lasty = $y;
}

__END__
