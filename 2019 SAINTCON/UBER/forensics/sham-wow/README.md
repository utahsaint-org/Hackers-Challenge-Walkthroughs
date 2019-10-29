
# sham-wow

## hint

```
VCMG

If you have issues using openssl, try libressl instead.
```

## file

## solution

First hints. VCMG and the title of ShamWow is a follow up from the [shamr-one](shamr-one) story, telling you to use the same starting
point (ssss encryption).

The zip file provided was not encrypted, but simply a collection of images, and one unknown file.  The image contents are
hints to solving the puzzle, featuring 5 images of actress Jeri Ryan playing her role on Star Trek Voyager aptly named 7 of 9.

Similar to the previous shamir based story, you can simply run exiftool over each image, and inside the exif data there is a
simple key that contains a secret key value.  For most people this was the first place they would get an error.  You can
ssss-combine and get garbled data with insufficient keys.

The 7 of 9 clue lets us know there is more to find. Key #8 can be found in 3.jpg by running 

```
$ jsteg reveal 3.jpg
```

This gives your key shards/shares 1-6 and 8. This is good because our rules are 7 of 9, which means *any* of them.  

```
$ ssss-combine -t 7 < mykeyshards.txt

Enter 7 shares separated by newlines:
Resulting secret: CanYouCrack
```

Now you have a piece of text, but what do you do with it?  Two hints are:

```
$ file WhatIsIt
WhatIsIt: openssl enc'd data with salted password
```

And the image that is unlike the others, which is a blowfish.

Also of note, the file was encrypted specifically using the first example provided in the ssss manpage. As you can read in
there, the sharing scheme is limited to 1024 bytes of data, so commonly it is used to store a passphrase or key, instead of
the target data. The real data can then using a stronger encryption.

```
$ openssl bf -e < file.plain > file.encrypted
```

So to unlock this file, you can run the opposite direction:

```
$ openssl bf -d < WhatIsIt > outfile
$ file outfile
test.png: PNG image data, 1000 x 1000, 8-bit/color RGB, non-interlaced
```

Here lies a small problem that was found when we were launching.  If you attempt to run this command using kali, or certain
other distros, you are running openssl 1.1.1.  However this challenge was created using LibreSSL 2.8.3.  Attempting to decrypt
will break and give you partially reconstructed data.

Moving on, the output file is a png of a tardis. WARNING: by design, the key payload is designed to be slightly fragile.
Opening/viewing this file in certain file browsers, or editors will perform changes to the file that obliterate the key. This
is one of the critical lessons of forensics.

Interesting ways to find the data include binwalk or foremost:

```
$ binwalk test.png

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 1000 x 1000, 8-bit/color RGB, non-interlaced
257646        0x3EE6E         TIFF image data, big-endian, offset of first image directory: 8
257818        0x3EF1A         JPEG image data, JFIF standard 1.01
257848        0x3EF38         TIFF image data, big-endian, offset of first image directory: 8

```

Binwalk quickly points out something odd in the file, it's a png that has a plain JPEG inside of it. Using extract you can
pull it out.

```
$ foremost test.png
foremost: /usr/local/etc/foremost.conf: No such file or directory
Processing: test.png
|*|
```

simply running foremost creates an 'output' subdirectory by default, which then give an audit file, and a directory per
filetype containing any extracted data.


The tool used to actually add the data can also be used to extract it:

```
$ exiftool -b -ThumbnailImage test.png > thumbnail.jpg
```

exiftool is very handy in this way, and can be used for several forms of editing, and reading less common metadata for an
image.

Of course, I know of at least two people that took the hardest route, and just used vi to attempt to manually delete
everything before and after the JPEG itself, which can be done by looking into file format data.

Any of those methods will give you a jpg file, that when opened, is another picture of a Tardis, with an applicable key
printed on the image.
