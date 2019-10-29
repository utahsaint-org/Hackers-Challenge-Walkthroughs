# DJ 600

This one was interesting. You start out with `SaintConBadge` which appears to be a png file:
```
~$ file SaintConBadge
SaintConBadge: PNG image data, 1949 x 1457, 8-bit/color RGBA, non-interlaced
```

But when you look at it, no flag is shown:

<img src="walkthrough/first.png" width="500"> 

I decided to check if there was anything after the file, and found that there was:

```
$ binwalk SaintConBadge

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 1949 x 1457, 8-bit/color RGBA, non-interlaced
214           0xD6            Unix path: /www.w3.org/1999/02/22-rdf-syntax-ns#">
4710167       0x47DF17        PNG image, 2514 x 1324, 8-bit/color RGB, non-interlaced
```

So I tried to use binwalk to extract it, but it didn't work:

```
~$ binwalk -e SaintConBadge

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 1949 x 1457, 8-bit/color RGBA, non-interlaced
214           0xD6            Unix path: /www.w3.org/1999/02/22-rdf-syntax-ns#">
4710167       0x47DF17        PNG image, 2514 x 1324, 8-bit/color RGB, non-interlaced
~$ ls
SaintConBadge
```

So I looked for something online that would work instead. I stumbled upon **foremost**

>Foremost is a forensic data recovery program for Linux used to recover files using their headers, footers, and data structures through a process known as file carving. Although written for law enforcement use, it is freely available and can be used as a general data recovery tool.
([Wikipedia](https://en.wikipedia.org/wiki/Foremost_(software)))

Running that gave me what I was looking for:
```
$ foremost SaintConBadge
foremost: /usr/local/etc/foremost.conf: No such file or directory
Processing: SaintConBadge
|*|
~$ ls
SaintConBadge  output/
~$ ls output/
audit.txt  png/
~$ ls output/png/
00000000.png  00009199.png
```
00009199.png was our Golden Ticket.

<img src="walkthrough/last.png" width="500"> 
