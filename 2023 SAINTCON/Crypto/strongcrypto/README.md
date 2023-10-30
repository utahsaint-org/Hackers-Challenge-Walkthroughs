# strongcrypto

Recover the message, save the world. Your flag is the full text of the recovered
message.

---

You are given a `zip` file consisting of:

- ciphertext.txt
- README.md
- strong.py

where `strong.py` is the following:

```python
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes

with open("plaintext.txt") as f:
    plaintext = f.read().strip()

assert all(
    [c.islower() or c == " " for c in plaintext]
), "invalid characters in plaintext"

private_key = rsa.generate_private_key(
    public_exponent=65537, key_size=2048, backend=default_backend()
)

public_key = private_key.public_key()

with open("rsakey.pem", "wb") as f:
    f.write(
        private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.TraditionalOpenSSL,
            encryption_algorithm=serialization.NoEncryption(),
        )
    )

x = [
    pow(ord(c), public_key.public_numbers().e, public_key.public_numbers().n)
    for c in plaintext
]
print(len(plaintext))

with open("ciphertext_new.txt", "w") as f:
    [print(f"{i:x}", file=f) for i in x]
```

## Solution

Examining the `ciphertext.txt` file, you'll start to see repeats:

```bash
$ wc -l ciphertext.txt 
57 ciphertext.txt

$ cat ciphertext.txt | sort | uniq | wc -l
21
```

Looking at the code above, there is something missing: padding

This means that if an `a` is encrypted in two different spots in the plaintext,
the ciphertext will have the same output. This means we can start creating a
simplified mask and use a cryptogram solver to help us solve this overly complex
substituion cipher. 

We know from above that the length of the plaintext is 57. So the following
script will create a mask for us:

```python
mask =  [None] * 57 

with open("ciphertext.txt", "r") as f:
    # create a dict that will let us know what
    # lines are duplicated where
    s_mask = {}
    lines = f.readlines()
    count = 0
    
    # for each line in the file, check to see if
    # we have seen it before. If so, we can append 
    # the line number for use later, or we can create
    # a new list for something we have never seen before
    for line in lines:
        s_mask.setdefault(line, []).append(count)
        count = count + 1
    
    # Now loop through the dict that knows where each line
    # is, and assign a letter value to it. We are just gonna
    # start with a.
    count = 0
    for k in s_mask:
        for location in s_mask[k]:
            print(location)
            mask[location] = ord('a') + count
        count = count + 1

print(''.join([chr(x) for x in mask]))
```

Is it the most pythonic code? No. Is it the prettiest? No. But eh, it works and
gives us the following:

```
abacdeffgdhijklfdhmcdnadopagdqcdiamrrjdkffidsmjpdmtqiqeul
```

Throwing that into something like https://quipquip.com doesn't yield something
that looks like a flag. 

Looking more into the string, seems like we need to find out where the spaces
should go so that the cryptogram solvers can work better. All of the cryptogram solvers show spaces in the examples. The letter `d` appears
the most frequently in our text above and at opportune locations where a space
may be appropriate. 

This means we can try the following with [quipquip](https://quipquip.com):

```
abac effg hijklf hmc na opag qc iamrrj kffi smjp mtqiqeul
```

And get a few results like:

- `even good crypto can be used in really poor ways akiright`
- `even good crypto can be fzed in really poor wayz akiright`
- `even food crypso can be hued in really poor wayu amirifts`
- `even boot crypso can we duet in really poor fayu akiribhs`
- `even boot crypso can he duet in really poor wayu akiribms`
- `even mood clypro can be used in leatty pool ways akilimgr`
- `even good clufto can we bred in leazzu fool maur akilight`

That is looking better, but if you are like nopesled, you can use a bit more help to arrive at the right answer. 

There is an option in [quipquip](https://quipquip.com) to solve using a dicitonary and the results include:

```
even good crypto can be used in really poor ways a?irig?t
```

What letters could that phrase be missing?

```python
import string
set(string.ascii_lowercase) - set('even good crypto can be used in really poor ways a?irig?t')
{'j', 'f', 'k', 'x', 'h', 'q', 'z', 'm'}
```

Process of elimination will yield:

```
even good crypto can be used in really poor ways amiright
```

### Extra Commentary

While this solution seems simple, it took a few hours to figure out the crypto
had no issues associated with it. The crypto is called Textbook RSA and is how
RSA typically is exampled. In a practical sense, there are more factors in RSA
to make this attack imposible, one such factor is padding. This ensures that
encrypting the same input twice does not yield the same output twice.

Also, knowing that tools like quipquip exist makes life much easier. 