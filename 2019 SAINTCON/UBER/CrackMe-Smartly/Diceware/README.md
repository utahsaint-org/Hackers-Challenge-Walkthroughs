# Diceware

## Description

This passphrase was generated using dice and the [EFF's wordlist](https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt).

The first letter of each generated word has been capitalized and there is a space between every word.

Hash Type: NTLM
f0c845c934251926ee2a8b1d87a16b64

## Solution
<details>
    <summary>Show solution</summary>
For this challenge I read up on how diceware passphrases are generated. On EFF's website it said that this particular list is meant to be used for generating shorter passphrases of 4 words, so I figured this password was the suggested 4 words. I downloaded the password list and saw it contained 1926 words, meaning there are 571,557,761,775 possible combinations. That's well over a 100G file to try create a wordlist (I tried). So I took an easier route.

First, I downloaded the EFF list and used a vim macro to delete the leading numbers and capitalize each word. Then I used this Perl script to create a wordlist of 2 words per line:

```perl
#!/usr/bin/env perl
use strict;
use warnings;

my $in = do { local $/; <STDIN> };
my @words = split /\n/, $in;
my @words2 = @words;

my $filename = './base.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

for my $word (@words) {
    for my $word2 (@words2) {
        print $fh "$word $word2\n";
    }
}

close($fh);
```

Then I let hashcat do the heavy lifting of combining the lists in memory using a combinator attack and a simple rule.

`hashcat -a 1 -m 1000 hash.txt base.txt. base.txt -j '$ '`

`-a 1` tells hashcat to use a combinator attack, `-m 1000` tells it that hash in NTLM, the hash is in `hash.txt`, to use `base.txt` as the two word lists to combine, and finally `-j '$ '` says to put a space between the two wordlists.

My MacBook Pro cracked this in 1 hour and 22 minutes.
</summary>
