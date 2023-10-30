# Stronger Crypto


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