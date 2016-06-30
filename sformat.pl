#!/usr/bin/perl -w

use English;
use strict;

my @f;
my @lines;
my @fields_1;
my @fields_2;

while (<>) {
	chomp;
	push @lines, $_;
	if (/^[*+]/) {
		@f = split /\s*\|\|\s*/;
		for my $i (0..$#f) {
			if ($i > $#fields_1 || length $f[$i] > $fields_1[$i]) {
				$fields_1[$i] = length $f[$i];
			}
		}
	}
	if (/^\./) {
		@f = split /\s*\|\|\s*/;
		for my $i (0..$#f) {
			if ($i > $#fields_2 || length $f[$i] > $fields_2[$i]) {
				$fields_2[$i] = length $f[$i];
			}
		}
	}
}

my $dots = -4;
foreach (@fields_1) {
	$dots += $_ + 4;
}

foreach (@lines) {
	if (/^[*+]/) {
		@f = split /\s*\|\|\s*/;
		for my $i (0..$#f) {
			print " || " if $i > 0;
			printf "%*s", $fields_1[$i], $f[$i];
		}
		print "\n";
		next;
	}
	if (/^\./) {
		@f = split /\s*\|\|\s*/;
		print "." x $dots;
		for my $i (1..$#f) {
			printf " || %*s", $fields_2[$i], $f[$i];
		}
		print "\n";
		next;
	}
	print "$_\n";
}

