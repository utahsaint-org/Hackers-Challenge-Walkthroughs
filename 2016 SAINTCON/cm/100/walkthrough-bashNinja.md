# CM 100

The puzzle starts off with the phrase:

`Eunuchs say U4fVNAKqiIpNN/AAYF6BY88flLtilHvAG0bgYbyClHlAm8aZGtJYSNSShNPfxysvWDNNNN==`

Which seemed to be a base64 encoded string, though an attempt to decode it fails.

```
~$ echo -n "U4fVNAKqiIpNN/AAYF6BY88flLtilHvAG0bgYbyClHlAm8aZGtJYSNSShNPfxysvWDNNNN==" | base64 -D > base64
~$ cat base64
S��4���M7�`^�c���b�{��a���y@�ƙ�XHԒ����+/X3M4
~$ file base64
base64: data
````

I knew this was a base64 encoded string, as the `==` gives it away, but it wasn't giving me anything, so that lead me to assume it was encrypted somehow. 

I started thinking about how, as a challenge writer, I would write this challenge. I figured it had to be some sort of cipher on the base64 encoded string, that was either simple or used a passphrase. Something like `eunuchs` would be a good passphrase. I just started with some basic ones, and the first one I tried was the Ceaser Cipher.

I found a bash [script](https://gist.github.com/75th/5778694) that allows me to run through rot super simply. I'll probably expand on it later, as I found it very useful for this challenge.

I took that script and ran this with it:

```
~$ for ((i=1; i<=26; i++)); do ./rot.sh $i "U4fVNAKqiIpNN/AAYF6BY88flLtilHvAG0bgYbyClHlAm8aZGtJYSNSShNPfxysvWDNNNN==" | base64 -D > base64.$i.bin && file base64.$i.bin; done
base64.1.bin: data
base64.2.bin: data
base64.3.bin: data
base64.4.bin: data
base64.5.bin: data
base64.6.bin: data
base64.7.bin: data
base64.8.bin: data
base64.9.bin: data
base64.10.bin: data
base64.11.bin: data
base64.12.bin: data
base64.13.bin: gzip compressed data, last modified: Wed Aug 24 17:48:05 2016, from Unix
base64.14.bin: data
base64.15.bin: data
base64.16.bin: data
base64.17.bin: data
base64.18.bin: data
base64.19.bin: data
base64.20.bin: data
base64.21.bin: data
base64.22.bin: data
base64.23.bin: data
base64.24.bin: data
base64.25.bin: data
base64.26.bin: data
```

That showed that ROT(13) is what we needed. Just compress the file and profit:
```
~$ mv base64.13.bin base64.13.gz
~$ gzip -d base64.13.gz
~$ file base64.13
base64.13: ASCII text
~$ cat base64.13
Mess_with_the_best_die_like_the_rest
```
