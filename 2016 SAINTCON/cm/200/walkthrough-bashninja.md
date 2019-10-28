# CM 200

We are given the cipher text and hint:

```
Author: eightyeight
Puzzle Name: Deal with it

You are heading home from the bar late one night. You come across a dead
man in an alley. Looking for identification, you find a deck of playing cards
and a note card in a shirt pocket. The note has the following text:
yvzji DmnzR yggor pmrdW BnNfN OUIhe qOKXo PVhaW RKHlA rszAz OdPkN unDEY
```

The first thing I did with this was recognize that the hint was telling us it was a _card cipher_. Another thing I noticed was the author's name, **EightyEight**. I happen to follow him on twitter and find a lot of the crypto he does interesting, so it was very easy for me to recognize what this was. For those that don't follow his work, you can find some hints on twitter. 

###Twitter Hint:###
https://twitter.com/AaronToponce/status/786569210507907073

`QOpFN kLrlw TZJcm tqDJX FAdEZ dOssO gyfWS JrFWn Npvkh lmrsB kYcJQ xdXen xbROz ipjFZ zduNC KrqTD LLNtd xwKDo QRMRh #talon #cardciphers`

If you'll notice, this is in the exact format as our challenge, adding the _#cardciphers #talon_. Those are useful as they are clue on how to decode it.

He's got a wonderful [whitepaper](https://pthree.org/2014/09/02/talon/) on talon and how it works, but the real magic is found in his github.

```
~$ git clone https://github.com/atoponce/cardciphers/
Cloning into 'cardciphers'...
remote: Counting objects: 409, done.
remote: Total 409 (delta 0), reused 0 (delta 0), pack-reused 409
Receiving objects: 100% (409/409), 75.87 KiB | 104.00 KiB/s, done.
Resolving deltas: 100% (239/239), done.
~$ cd cardciphers/talon/
~$ python crypto.py -h
usage: crypto.py [-h] (-d DECRYPT | -e ENCRYPT) [-p PASSPHRASE] [-k KEY] [-b]

Python implementation of Talon

optional arguments:
  -h, --help            show this help message and exit
  -d DECRYPT, --decrypt DECRYPT
                        Decrypt a message
  -e ENCRYPT, --encrypt ENCRYPT
                        Encrypt a message
  -p PASSPHRASE, --passphrase PASSPHRASE
                        Private passphrase to key deck
  -k KEY, --key KEY     Private comma-separated deck order.
  -b, --base26          Use base-26 encoding/decoding.
```

Awesome. We didn't have to fully understand how it works, as he's given us a tool to decode it. 

```
~$ python crypto.py -d 'yvzji DmnzR yggor pmrdW BnNfN OUIhe qOKXo PVhaW RKHlA rszAz OdPkN unDEY'
O=R2RE-N-8,43/-V2LSCS9?7N8E3&#.TR=7Y:JQW)M-U3GO+9M)=)SA
```

Now, that didn't give me the key with the default passphrase like his tweets do... So I decided he must be using a custom passphase. So tried a bunch of phrases. I eventually found the one that decoded it:

```
~$ python crypto.py -p saintcon -d 'yvzji DmnzR yggor pmrdW BnNfN OUIhe qOKXo PVhaW RKHlA rszAz OdPkN unDEY'
REMEMBERHACKING0ISMORETHANJUSTACRIMEITSASURVIVALTRAIT
```

Game Over.
