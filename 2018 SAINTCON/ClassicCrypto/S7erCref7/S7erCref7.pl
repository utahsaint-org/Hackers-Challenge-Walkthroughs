#!/usr/bin/env perl

# Email: <rob.brown@utahsaint.org>
# Usage: ./S7erCref7.pl < encoded.txt

use strict;

# Slurp input
$_ = join "", <STDIN>;
my $enc = 1;
foreach my $dec ("A".."Z") {
    # Convert all $enc to $dec except anything preceded by "."
    s/(?<![0-9.])$enc\b/$dec/g;
    # Increment $enc
    do {$enc++}
    # Ignoring numbers that have illegal "Base 7" digits
    while $enc =~ /[789]/;
}
# Remove spaces and convert underbars to spaces
y/_ / /d;
# Remove "." from .DIGIT
s/\.(.)/$1/g;
# Show decoded message
print;
