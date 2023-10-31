# Pyckup line

I lost the source, but at least I have this. Can you help?

> Python 3.11.5 (tags/v3.11.5:cce6ba9, Aug 24 2023, 14:38:34) [MSC v.1936 64 bit (AMD64)] on win32


[challenge](./challenge)

## Solution

The first hint we're given in the challenge description indicates the challenge will have something to do with Python and might have something to do with version 3.11.5 running on AMD64 architecture. After downloading and inspecting the contents of [challenge](./challenge), it's clear we aren't given a regular python script (.py) that can be executed easily.


```python
163           0 RESUME                   0

164           2 LOAD_CONST               1 (0)
...
```


Taking a closer look at the contents of the challenge file, it seems we're given Python [bytecode](https://en.wikipedia.org/wiki/Bytecode). A quick search for `Python LOAD_CONST` validates this with a result linking to the Python standard library disassembler package [dis](https://docs.python.org/3/library/dis.html).

> The dis module supports the analysis of CPython bytecode by disassembling it. The CPython bytecode which this module takes as an input is defined in the file Include/opcode.h and used by the compiler and the interpreter.

Okay, great. So it seems like we're on the right track. Let's look through the challenge file some more and try to make sense of what the byte code does. While tedious, we should be able to step through the byte code line-by-line and recreate it as a functional script.

```python
163           0 RESUME                   0
```

Looking up the RESUME opcode in the python dis package doc, we discover this is just a no-op. Nothing to translate here so we move on to line 164.


```python
164           2 LOAD_CONST               1 (0)
              4 LOAD_CONST               2 (('Cipher', 'algorithms', 'modes'))
              6 IMPORT_NAME              0 (cryptography.hazmat.primitives.ciphers)
              8 IMPORT_FROM              1 (Cipher)
             10 STORE_FAST               0 (Cipher)
             12 IMPORT_FROM              2 (algorithms)
             14 STORE_FAST               1 (algorithms)
             16 IMPORT_FROM              3 (modes)
             18 STORE_FAST               2 (modes)
             20 POP_TOP
```

If you were playing in the Saintcon 2023 hacker's challenge, this probably looked familiar when you saw it. One of the other challeneges "Stronger Crypto" provided a .py source file that imported Cipher, algorithms and modes from the package cryptography.hazmat.primitives.ciphers. So this challenege must have something to do with cryptography. Let's create a [solve.py](./solve.py) and add the import to it.

```python
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
```

---
Great, our first part of the challenge file is translated to something executable. Let's carry on to line 165 and continue translating.

```python
165          22 LOAD_CONST               1 (0)
             24 LOAD_CONST               0 (None)
             26 IMPORT_NAME              4 (random)
             28 STORE_FAST               3 (random)
```

This appears to be another module import but this time importing `random` so add `import random` to the script:

```python
import random
```
---

Continuing on to line 166
```python

166          30 LOAD_CONST               3 (b'\xf1\xb3\xf0"\x8e\xe8\xd3\xb3R\x89\xdb\x99\x97\xbe\xfb\x970\xe3\x16\xe2\xe9\xae\xae\xaf\xea{J0\xd4\xee\x88|\xeb\xb0\xc3|\xcf&\x87\xfbT\xf0mG\xe3\xa5\x08\x1cc\xa6\xba\xae\xfeL\x08>\xa5\xea\x84\xe2\x97\x06L\xc7\xba^B\xf6X\x10\xc7\xd0\xda"\xc5\x00\xd3\xcbW\x87')
             32 STORE_FAST               4 (msg)
```

This is a variable definition setting `msg` to a byte string. Straight forward enoughl.. Let's add that to the script:

```python
msg = b'\xf1\xb3\xf0"\x8e\xe8\xd3\xb3R\x89\xdb\x99\x97\xbe\xfb\x970\xe3\x16\xe2\xe9\xae\xae\xaf\xea{J0\xd4\xee\x88|\xeb\xb0\xc3|\xcf&\x87\xfbT\xf0mG\xe3\xa5\x08\x1cc\xa6\xba\xae\xfeL\x08>\xa5\xea\x84\xe2\x97\x06L\xc7\xba^B\xf6X\x10\xc7\xd0\xda"\xc5\x00\xd3\xcbW\x87'
```

---
Continuing on to line 167
```python
167          34 PUSH_NULL
             36 LOAD_FAST                3 (random)
             38 LOAD_ATTR                5 (seed)
             48 LOAD_CONST               4 (12345)
             50 PRECALL                  1
             54 CALL                     1
             64 POP_TOP
```

This appears to be a function call passing 12345 to the seed attribute on the random object. So this is seeding random with 12345.

```python
random.seed(12345)
```

---
Line 168
```python
168          66 PUSH_NULL
             68 LOAD_FAST                3 (random)
             70 LOAD_ATTR                6 (randbytes)
             80 LOAD_CONST               5 (48)
             82 PRECALL                  1
             86 CALL                     1
             96 STORE_FAST               5 (x)
```

calls the randbytes attribute on random passing in 48:

```python
x = random.randbytes(48)
```

---
Line 169 - 216

Takes the byte from `x[39]` and stores it in the variable `i3`. Repeat this up to line 216.
```python
169          98 LOAD_FAST                5 (x)
            100 LOAD_CONST               6 (39)
            102 BINARY_SUBSCR
            112 STORE_FAST               6 (i3)
```


```python
i3 = x[39]
# ...
```

---

Lines 217 - 264

```python
217         866 LOAD_FAST               48 (i22)
            868 LOAD_FAST               25 (i0)
            870 BINARY_OP                5 (*)
            874 STORE_FAST              14 (i30)
```

```python
i30 = i22 * i0
```

---

Line 265

```python
265        1346 BUILD_LIST               0
           1348 STORE_FAST               5 (x)
```

Creates a empty list and stores it in the variable `x`
```python
x = list()
```

---

Line 266 - 313

```python
266        1350 LOAD_FAST                5 (x)
           1352 LOAD_METHOD              7 (append)
           1374 LOAD_FAST               46 (i26)
           1376 PRECALL                  1
           1380 CALL                     1
           1390 POP_TOP
```

Append variable `i26` to x

```python
x.append(i26)
# ...
```

---

Line 314

```python
314        3366 LOAD_CONST              53 (<code object <listcomp> at 0x000001FE4A40A0B0, file "[redacted]" line 314>)
           3368 MAKE_FUNCTION            0
           3370 LOAD_FAST                5 (x)
           3372 GET_ITER
           3374 PRECALL                  0
           3378 CALL                     0
           3388 STORE_FAST               5 (x)
```

And we find the disassembly of the list comprehension code object at the bottom of the file. CPython creates a separate function for list comprehensions (i.e `[x for x in some_list if x not some_cond]`).

```python
Disassembly of <code object <listcomp> at 0x000001FE4A40A0B0, file "[redacted]" line 314>:
314           0 RESUME                   0
              2 BUILD_LIST               0
              4 LOAD_FAST                0 (.0)
        >>    6 FOR_ITER                 7 (to 22)
              8 STORE_FAST               1 (i)
             10 LOAD_FAST                1 (i)
             12 LOAD_CONST               0 (256)
             14 BINARY_OP                6 (%)
             18 LIST_APPEND              2
             20 JUMP_BACKWARD            8 (to 6)
        >>   22 RETURN_VALUE
```

This ends up being a list comprehsion that wraps any list values greater than 256 so each value fits in 1 byte / 8 bits.

```python
x = [i % 256 for i in x]
```

---

Line 315

```python
315        3390 LOAD_GLOBAL             17 (NULL + bytearray)
           3402 LOAD_FAST                5 (x)
           3404 PRECALL                  1
           3408 CALL                     1
           3418 STORE_FAST               5 (x)
```

Converts the `x` list to a bytearray.
```python
x = bytearray(x)
```

---

Line 316

```python
316        3420 PUSH_NULL
           3422 LOAD_FAST                0 (Cipher)
           3424 PUSH_NULL
           3426 LOAD_FAST                1 (algorithms)
           3428 LOAD_ATTR                9 (AES256)
           3438 LOAD_GLOBAL             17 (NULL + bytearray)
           3450 LOAD_FAST                5 (x)
           3452 LOAD_CONST               0 (None)
           3454 LOAD_CONST              25 (32)
           3456 BUILD_SLICE              2
           3458 BINARY_SUBSCR
           3468 PRECALL                  1
           3472 CALL                     1
           3482 PRECALL                  1
           3486 CALL                     1
           3496 PUSH_NULL
           3498 LOAD_FAST                2 (modes)
           3500 LOAD_ATTR               10 (CBC)
           3510 LOAD_GLOBAL             17 (NULL + bytearray)
           3522 LOAD_FAST                5 (x)
           3524 LOAD_CONST              25 (32)
           3526 LOAD_CONST               0 (None)
           3528 BUILD_SLICE              2
           3530 BINARY_SUBSCR
           3540 PRECALL                  1
           3544 CALL                     1
           3554 PRECALL                  1
           3558 CALL                     1
           3568 PRECALL                  2
           3572 CALL                     2
           3582 LOAD_METHOD             11 (decryptor)
           3604 PRECALL                  0
           3608 CALL                     0
           3618 STORE_FAST              54 (d)
```

Okay, there's a bit going on in this line. I won't go step through each instruction individually explaining each one but essentially, this is constructing a Cipher object passing in the AES key and the CBC iv. The key and iv come from the `x` list. It then calls decryptor on the instantiated Cipher object and stores the return value in the variable `d`.
```python
d = Cipher(algorithms.AES(x[:32]), modes.CBC(x[32:48])).decryptor()
```

---

Line 317

```python
317        3620 LOAD_FAST               54 (d)
           3622 LOAD_METHOD             12 (update)
           3644 LOAD_FAST                4 (msg)
           3646 PRECALL                  1
           3650 CALL                     1
           3660 LOAD_FAST               54 (d)
           3662 LOAD_METHOD             13 (finalize)
           3684 PRECALL                  0
           3688 CALL                     0
           3698 BINARY_OP                0 (+)
           3702 RETURN_VALUE
```

And finally, we decrypt and print the message containing the flag
```python
print(d.update(msg) + d.finalize())
```

---

And after all that hard tedious work, we can run the complete [solve.py](./solve.py) script and reveal the flag:

```python
b'look it could have been the jvm,right? or would that have been easier or harder?'
```

Neat, it worked! By knowing the seed that was fed to random, we're able to reproduce that exact same random bytes and therefore the same decryption key and iv.