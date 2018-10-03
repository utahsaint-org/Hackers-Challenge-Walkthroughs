# MMM... PI...

## Description

```
https://garth.tech/pi.zip
```

# Walkthrough

```
$ zipinfo pi.zip
Archive:  pi.zip
Zip file size: 1747633862 bytes, number of entries: 1
-rw-r--r--  3.0 unx 4823449600 bx defN 18-Sep-25 15:12 2018-06-27-raspbian-stretch-ctf.img
1 file, 4823449600 bytes uncompressed, 1747633534 bytes compressed:  63.8%
$ unzip pi.zip
Archive:  pi.zip
  inflating: 2018-06-27-raspbian-stretch-ctf.img
$ strings 2018-06-27-raspbian-stretch-ctf.img | grep -i 'flag{'
FLAG{DaTaXXXXXXXXXiSkEy}
$
```
