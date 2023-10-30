# Concealment

This is classical cryptography. Just extract the plaintext. Here's the ciphertext:
> cofactor labella fuzzy garage = audio { alforja egg yu uno ziplock single ether crepes car water }

## Solution

```python
import sys

argv_len = len(sys.argv)

null_cipher = sys.argv[1].replace(" ", "") if argv_len >= 2 else None
start_pos = int(sys.argv[2]) if argv_len >= 3 else None
increment = int(sys.argv[3]) if argv_len >= 4 else None


def _raise_exc(msg: str):
    msg += f"\n\nUsage: {sys.argv[0]} <null cipher> <start pos> <increment>"
    raise Exception(msg)


if not null_cipher:
    _raise_exc("Missing required null_cipher text argument!")
if not start_pos:
    _raise_exc("Missing required start_pos argument!")
if not increment:
    _raise_exc("Missing required increment argument!")


curr_pos = start_pos - 1
flag = null_cipher[curr_pos]
cipher_len = len(null_cipher)


while curr_pos < (cipher_len - increment):
    curr_pos += increment
    flag += null_cipher[curr_pos]
    # print(flag)


print(flag)
#flag={jupiter}

# cofactorlabellafuzzygarage=audio{alforjaeggyuunoziplocksingleethercrepescarwater}
#   f     l     a     g     =     {     j     u     p     i     t     e     r     }
```

Script execution
```
python3 ./solve.py "cofactor labella fuzzy garage = audio { alforja egg yu uno ziplock single ether crepes car water }" 3 6
```