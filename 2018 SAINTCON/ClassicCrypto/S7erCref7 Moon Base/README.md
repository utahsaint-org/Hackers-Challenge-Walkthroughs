# title

S7erCref7 Moon Base

# hint

'''
5 20 3 24 34 22 26 5 4 _ 16 5 25 25 1 10 5 _ 26 21 _ 13 12 16 _ 24 1 34 20 21 24 ,
3 1 15 15 _ 6 21 24 _ 1 25 25 12 25 26 1 20 3 5 _ 6 24 21 16 _ 16 21 21 20 2 1 25 5 .7 . _ 26 11 5 _ 35 5 24 10 _ 22 24 5 25 5 20 3 5 _ 32 1 25 _ 16 30 3 11 _ 16 21 24 5 _ 26 11 1 20 _ 32 5 _ 1 20 26 12 3 12 22 1 26 5 4
11 5 24 5 . _ 5 1 24 15 34 _ 26 11 12 25 _ 16 21 24 20 12 20 10 _ 32 5 _ 32 5 24 5 _ 1 26 26 1 3 14 5 4 _ 2 34 _ 25 12 33 _ 35 5 24 10 15 12 20 10 25 . _ 26 11 21 30 10 11 _ 26 11 5 _ 1 26 26 1 3 14 _ 32 1 25 _ 25 16 1 15 15 , _ 32 5
32 5 24 5 _ 30 20 22 24 5 22 1 24 5 4 . _ 32 5 _ 16 1 20 1 10 5 4 _ 26 21 _ 32 1 24 4 _ 26 11 5 16 _ 21 6 6 , _ 26 11 21 30 10 11 _ 1 24 5 _ 20 21 32 _ 15 5 6 26 _ 32 12 26 11 _ 6 5 32 _ 25 30 22 22 15 12 5 25 _ 1 20 4
1 24 5 _ 21 22 5 20 _ 26 21 _ 1 20 21 26 11 5 24 _ 1 26 26 1 3 14 . _ 22 15 5 1 25 5 _ 24 5 25 22 21 20 4 _ 1 25 _ 25 21 21 20 _ 1 25 _ 22 21 25 25 12 2 15 5 .
20 21 31 5 16 2 5 24 _ 26 5 24 24 1
14 5 34 : _ 25 .1 33 22 .0 21 15 .4 26 11 .3 32 12 20
'''

# solution

Let's take the first little bit and make some assumptions:
 - each number maps to a letter
 - underscores are spaces

so let's translate: "5 20 3 24 34 22 26 5 4 _ 16 5 25 25 1 10 5" into "ABCDEFGAH IAJJKLA"
and let's take "ABCDEFGAH IAJJKLA" and plug it into quipquip.
top 4 answers:

'''
0	-0.332	EXPLOITED MESSAGE
1	-0.404	ENCRYPTED MESSAGE
2	-0.450	EXCLAIMED JESSORE
3	-0.470	EXPLAINED JESSORE
'''

Let's make the wild leap that the first two words are "encrypted message" and look closer.

'''
 5: e is the 5th letter in the alphabet
20: n is the 14th letter in the alphabet
 3: c is the 3rd letter in the alphabet
24: r is the 18th in the alphabet
'''

Wait a minute: there are 7's in the title of this puzzle. Could this simply be
base 7? 20 in base 7 is 14 in base 10; 24 in base 7 is 18 in base 10.

Ok, maybe we should convert all of the "normal" numbers (without decimals) into base 10 and
find the corresponding ASCII letter.
Further, let's assume that ',', ':', and '.' are literals.
Now we get: "encrypted message to jim raynor,call for assistance from"

That leaves the following untranslated: .7 .1 .0 .4 .3
Maybe those are litteral numbers: 7 1 0 4 3

Now we get: "encrypted message to jim raynor,call for assistance from moonbase7"

The python program [here](solve.py) solves the puzzle given the rules:
 - non-fractional numbers are base7 (convert to base10 and find the corresponding alphabet letter)
 - .digit are literal digits
 - \_ is space
 - ',' is comma, ':' is colon, and '.' is period

# Author

[jason@thought.net](mailto:jason@thought.net), [@risenrigel](https://twitter.com/risenrigel)

