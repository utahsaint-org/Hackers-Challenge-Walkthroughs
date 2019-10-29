# Algebraic Notation

## Description

Ken Thompson's password from the 1970s was cracked [earlier this month](https://thehackernews.com/2019/10/unix-bsd-password-cracked.html). This password was a chess opening described using [descriptive notation](https://en.wikipedia.org/wiki/Descriptive_notation). Descriptive chess notation was popular in the 1970s, but has been superseded by [algebraic notation](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)).

Ken Thompson's new password is another pair of chess moves described using Algebraic Notation.

The hash of this password is:

$1$hgxBiNDD$/jGQLDNEqcYn5QA/SR.2Y0

In this particular case we know that:
- Neither of the moves are a special move (en passant, castling, pawn promotion, etc.).
- The pair of moves is prepended with a number.

Here are some examples of valid moves:
2. Nf3 Nc6
17. Bd3 Be4+
33. Ke3 Bc7
39. Qxh5 Bf6

Can you generate pairs of possible chess moves and crack his new password?

## Solution

My first approach to this was to craft a mask attack using hashcat to cover every possible chess move in Algebraic Notation. This approach proved to be too complicated for my limited knowledge of hashcat, so I opted to create a (inefficient) python script to output every possible move combination within scope (without the number needed before the move). When I ran the below script, I piped it out into the file titled `dict.txt`

```python
pieces = ['K','Q','R','B','N','P','']
capture_mod = ['','x']
alpha_spaces = ['a','b','c','d','e','f','g','h']
nums = ['1','2','3','4','5','6','7','8']
final_mod = ['','+']

for piece in pieces:
    for mod_one in capture_mod:
        for alpha in alpha_spaces:
            for num in nums:
                for mod_two in final_mod:
                    for piece2 in pieces:
                        for mod_three in capture_mod:
                            for alpha2 in alpha_spaces:
                                for num2 in nums:
                                    for mod_four in final_mod:
                                        move = ". "+piece+mod_one+alpha+num+mod_two+" "+piece2+mod_three+alpha2+num2+mod_four
                                        print(move)
```

Then using hashcat. I performed a hybrid attack. Using the dictionary I created and a mask for the numbers preceding the move

`hashcat -m 500 -a 7 salt.pass ?d?d dict.txt`

`-a 7` tells hashcat to use a hybrid attack with the mask on the left side, `-m 500` tells it that the hash format is md5crypt, the hash is located in `salt.pass`, to use `dict.txt` as the dictionary of moves.
