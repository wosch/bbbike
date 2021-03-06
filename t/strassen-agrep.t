#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;
use lib (
	 "$FindBin::RealBin/..",
	 "$FindBin::RealBin/../lib",
	);

use File::Temp qw(tempfile);

use BBBikeUtil qw(is_in_path);

BEGIN {
    if (!eval q{
	use Test::More;
	1;
    }) {
	print "1..0 # skip no Test::More module\n";
	exit;
    }
}

my $data = <<'EOF';
Dudenstr.	X 1,1
Angermünder Str.	X 1,1
Unkeallee (A)	X 1,1
Unkeallee (B)	X 1,1
Weißenseer Weg	X 1,1
EOF

my @search_types = (
		    ($^O ne 'MSWin32' && $^O ne 'darwin' ? "agrep" : ()), # usually no agrep available on Windows systems; also no (original) agrep on darwin
		    (is_in_path('tre-agrep') ? 'tre-agrep' : ()), # XXX tre-agrep is available on darwin through the homebrew package tre as "agrep", but correct detection is missing in the module
		    "String::Approx",
		    "perl",
		   );
my $non_approx_tests = 7;
my $approx_tests     = 2;
my $tests_per_type = $non_approx_tests + $approx_tests;

plan tests => @search_types * 2 * $tests_per_type;

use Strassen::Core;

my $s_latin1;
{
    my($tmpfh,$tmpfile) = tempfile(SUFFIX => "teststrassen.bbd",
				   UNLINK => 1);
    print $tmpfh <<EOF;
#: encoding: iso-8859-1
#:
EOF
    print $tmpfh $data;
    close $tmpfh;
    $s_latin1 = Strassen->new($tmpfile);
}

my $s_utf8;
{
    my($tmpfh,$tmpfile) = tempfile(SUFFIX => "teststrassen_utf8.bbd",
				   UNLINK => 1);
    print $tmpfh <<EOF;
#: encoding: utf-8
#:
EOF
    binmode $tmpfh, ':encoding(utf-8)';
    print $tmpfh $data;
    close $tmpfh;
    $s_utf8 = Strassen->new($tmpfile);
}

#                    agrep or perl
#                      String::Approx or perl
for my $search_def (@search_types) {
    local $Strassen::OLD_AGREP;
    my %args;
    if ($search_def eq 'agrep') {
	# OK
    } elsif ($search_def eq 'tre-agrep') {
	%args = (UseTreAgrep => 1);
    } else {
	$Strassen::OLD_AGREP = 1;
	if ($search_def eq 'String::Approx') {
	    # OK
	} else {
	    %args = (NoStringApprox => 1);
	}
    }

    for my $encoding_def ([$s_latin1, 'latin1'],
			  [$s_utf8, 'utf-8'],
			 ) {
	my($s, $encoding) = @$encoding_def;
	my $check = sub {
	    my($supply, $expected) = @_;
	    local $Test::Builder::Level = $Test::Builder::Level+1;
	    is_deeply([$s->agrep($supply, %args)], $expected, "Search for '$supply' ($search_def, $encoding)");
	};
	$check->("Dudenstr", ["Dudenstr."]);
	$check->("Angermünder Str", ["Angermünder Str."]);
	$check->("Weißenseer Weg", ["Weißenseer Weg"]);
	$check->("Unkeallee", ["Unkeallee (A)", "Unkeallee (B)"]);
	$check->("Really does not exist!", []);
	{
	    local $TODO = "Not implemented yet: substituting straße with str";
	    # see _strip_strasse and _expand_strasse in PLZ.pm
	    {
		local $TODO = undef if $encoding eq 'latin1' && $search_def eq 'agrep'; # this is working just accidentally, so turn TODO off
		$check->("Dudenstra.e", ["Dudenstr."]);
	    }
	    $check->("Dudenstrasse", ["Dudenstr."]);
	}
    SKIP: {
	    skip("No approx search with 'perl' search type", $approx_tests)
		if $search_def eq 'perl';
	    $check->("Dudentsr", ["Dudenstr."]);
	    $check->("Angermunder Str", ["Angermünder Str."]);
	}
    }
}

__END__
