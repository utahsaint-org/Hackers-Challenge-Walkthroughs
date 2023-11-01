# Stronger Crypto

Just how strong is AES256? Break this! https://strongercrypto.youcanhack.me

## Problem

This is a flask app that is hosted on a server. There is a link to view the
source code and when navigated to, the following is returned:

```python
"""AES256 is a pretty strong algorithm, think you can beat it? -- rigel
"""
import os
import base64
import random
import time
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from flask import Flask, Response, request

app = Flask(__name__)

SECRET_KEY_TEXT = os.environ.get("KEY")
FLAG = os.environ.get("FLAG")

DIGEST = hashes.Hash(hashes.SHA256())
DIGEST.update(SECRET_KEY_TEXT.encode("utf-8"))
SECRET_KEY = DIGEST.finalize()
SECRET_KEY_TEXT = None
DIGEST = None


def encrypt(msg, rsp):
    """pylint is annoying"""
    random.seed(((int(time.time()) // 3) * 3) + len(msg))
    nonce = random.randbytes(16)
    encryptor = Cipher(algorithms.AES(SECRET_KEY), modes.CTR(nonce)).encryptor()
    ciphertext = encryptor.update(msg) + encryptor.finalize()
    rsp.headers["flag"] = base64.b64encode(nonce + ciphertext).decode('utf-8')
    return rsp


@app.route("/", methods=["GET", "POST"])
def home():
    """Return the index page"""
    rsp = Response(
        """
<html>
  <head>
    <title>Stronger Crypto</title>
  </head>
  <body>
    <h1>Stronger Crypto</h1>
    <p>Give me a message and I will encrypt it using mega-strong AES256.</p>
    <form method="POST" action="/post">
      <p><input type="text" name="message" /></p>
      <p><input type="submit" name="ok" value="encrypt" /></p>
    </form>
    <p><a href="/source">My awesome source</a></p>
  </body>
</html>
"""
    )
    return encrypt(FLAG.encode("utf-8"), rsp)


@app.route("/source")
def source():
    """Display the source code"""
    with open(__file__, encoding="utf-8") as fdata:
        rsp = Response(fdata.read(), mimetype="text/plain")
        return rsp


@app.route("/post", methods=["POST"])
def post():
    """Encryptor!"""
    msg = request.form.getlist("message")
    if len(msg) == 0:
        return """Missing message"""
    if len(msg) > 1:
        return """Sorry, one per customer."""
    msg = msg[0]

    try:
        msg = msg.encode("utf-8")
    except ValueError:
        return """message is not utf-8 encodable"""

    return encrypt(msg, Response("""Done"""))

```

## Solution

We are given the source code of the application which is handy. After a lot of
glancing around, testing responses and googling AES CTF exploits, you might
notice the following line in the source code that is interesting:

```python
random.seed(((int(time.time()) // 3) * 3) + len(msg))
```

Huh. That `// 3` is floor division. Check it out:

```python
>>> 3 // 1
3
>>> 3 // 2
1
>>> 3 // 4
0
```

So essentially it removes the remainder. And let's look at what that affects with time:

```python 
>>> import time
>>> (int(time.time()) // 3)
566262584
>>> (int(time.time()) // 3)
566262584
>>> (int(time.time()) // 3)
566262584
>>> (int(time.time()) // 3)
566262585
```

Oh cool! So if I run the command fast enough, I'll get the same value from the
time, which means that the seed is not truly random anymore for the nonce. The
message length matters for the nonce, but we know from the flag, given as a header from the
code above, the length is easily discoverable.

```python
import base64
len(base64.b64decode('15HOrgXscETV9EBcbzfOKeS3hNYGx33k76FCN0WyxtPUcBYaLyfOztL7dzU/Kjxsd5lx2lwCWRopkf8GJzx/0OEZz+M='))
68
```

Don't forget the fixed sized nonce is added to this! (see server code):

```python
base64.b64encode(nonce + ciphertext).decode('utf-8')
```

so the actual flag length is:

```python
import base64
len(base64.b64decode('15HOrgXscETV9EBcbzfOKeS3hNYGx33k76FCN0WyxtPUcBYaLyfOztL7dzU/Kjxsd5lx2lwCWRopkf8GJzx/0OEZz+M=')) - 16 # 16 = length of randbytes
52
```

So now we know we can calculate the same nonce for messages created within a
certain time window. Combining this information with AES CTR, a little google,
and lots of reading, presents us a way to recover plaintext without knowing the
key! 

Essentially, if you do the following you'll be able to retrieve the original
plaintext:

```
keystream = KNOWN_CIPHERTEXT xor KNOWN_PLAINTEXT
plaintext = FLAG_CIPHERTEXT xor keystream
```

Notice the `keystream` includes the nonce and `SECRET_KEY` combined with AES
magic (now you know I'm not a crypto guy). So if we send a request with a
message of `52` in length within a certain amount of time, we will be able to
use that to decrypt the flag. 

Let's put this all together:

First, let's get some values. Looking at developer tools in Chrome/Firefox, I
gathered the cURL commands I would need and put them in a script:

```bash
cat > get_values.sh << EOF

curl -v 'https://strongercrypto.youcanhack.me/' 


curl -v 'https://strongercrypto.youcanhack.me/post' -X POST --data-raw 'message=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa&ok=encrypt'

EOF
```

Then I ran it and `grep` for the flag:

```bash
$ bash get_values.sh  2>&1 | grep -i flag
< flag: mq5Y0sWZLsUupc3+gReh3s3cNHaEhB9zPgpEDyXqEWOp8elwEbk60+FFhIlLv+eTcBx6nc/20IEL2xpe4NZIuoD+h38=
< flag: mq5Y0sWZLsUupc3+gReh3sTeLl7Flh97O0tLASroFSKm//wxHqws2+NBxYlEuqacZRVplc3ykYkZmglW5t9d+47qkmM=
```

Again. Is this the best way? Is it the prettiest? No. But it works. 

> A little sanity check is that both flags start with the same values. This
> means our nonce is the same! If yours is different between the two flags, just
> run again cause you were (un)lucky and sent the requests when the time changed
> within those 3 seconds.

So let's start our XOR operations. I'm using `PyCryptoDom` for the `strxor` function:


```bash
$ docker run --rm -it python:3.9 bash
root@docker$ pip3 install PyCrytoDome
root@docker$ python3
```

Which gets me a Python session with the right package installed:

```python
>>> import base64
>>> from Crypto.Util import strxor

>>> flag = base64.b64decode("mq5Y0sWZLsUupc3+gReh3s3cNHaEhB9zPgpEDyXqEWOp8elwEbk60+FFhIlLv+eTcBx6nc/20IEL2xpe4NZIuoD+h38=")
>>> flag_enc = flag[16:] # ignore the nonce, i.e. FLAG_CIPHERTEXT

>>> aa_plain = ('a' * 52).encode() # this is what we sent in the second call, i.e. KNOWN_PLAINTEXT
>>> aa_flag = base64.b64decode('mq5Y0sWZLsUupc3+gReh3sTeLl7Flh97O0tLASroFSKm//wxHqws2+NBxYlEuqacZRVplc3ykYkZmglW5t9d+47qkmM=')

>>> aa_enc = aa_flag[16:] # ignore the nonce, i.e. KNOWN_CIPHERTEXT
>>> aa_key = strxor.strxor(aa_enc, aa_plain) # i.e., keystream = KNOWN_CIPHERTEXT xor KNOWN_PLAINTEXT

>>> print(strxor.strxor(flag_enc, aa_key)) #i.e., FLAG_CIPHERTEXT xor keystream
b'hc{I said nonce not ntwice and nthrice is right out}'
```

We have a string that is our flag!

One question you may have is why we didn't have to deal with the blocks that CTR
operates on. This is because I made the known plaintext the right length so
everything worked out in the end. The main reason I did this is not because I
knew it would work out nicely, but because I'm not good at crypto and if I could
get the nonce to be exactly what is used for the flag, my life was hopefully
gonna be easier and less drowned in AES math.