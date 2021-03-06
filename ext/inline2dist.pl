#!/usr/bin/env perl
# -*- perl -*-

#
# $Id: inline2dist.pl,v 1.2 2002/11/13 23:17:28 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 2001 Slaven Rezic. All rights reserved.
#

use ExtUtils::MakeMaker;

my $name = shift || die "Name missing";
(my $file = $name) =~ s/(.*::)//;
my $basefile = $file;
$file .= ".pm";
my $version = MY->parse_version($file);
die "Can't get version from $file" if !defined $version;

my $extra_use = "";
if (-e "${basefile}Perl.pm") {
    $extra_use = "use ${name}Perl;\n";
}

my $dest = "${basefile}Dist.pm";
open(W, "> $dest") or die "Can't write to $dest: $!";
print W <<EOF;
# -*- perl -*-
# DO NOT EDIT, generated by $0 from $name

package ${name}Dist;

package ${name};
require DynaLoader;
unshift \@ISA, 'DynaLoader';
#use base 'DynaLoader';
\$VERSION = "$version";
$extra_use
bootstrap $name \$VERSION;

1;
EOF
close W;

__END__
