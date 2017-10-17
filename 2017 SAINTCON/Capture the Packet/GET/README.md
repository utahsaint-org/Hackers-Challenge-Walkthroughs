# DESCRIPTION: #

~~~~
Puzzle Detail:
You captured this packet off the wire.  Where is it going?

0000  80 2a a8 4c 9d e8 a0 99 9b 1d 5d 8f 08 00 45 00
0010  01 cd 2a 21 40 00 40 06 05 2f c0 a8 0d 0d cb 00
0020  71 25 e1 e3 00 50 b0 1c 53 75 3e 58 55 7c 80 18
0030  10 2c a9 1f 00 00 01 01 08 0a 3a ae ea 9c 1c 18
0040  2b c2 47 45 54 20 2f 20 48 54 54 50 2f 31 2e 31
0050  0d 0a 43 6f 6e 6e 65 63 74 69 6f 6e 3a 20 6b 65
0060  65 70 2d 61 6c 69 76 65 0d 0a 41 63 63 65 70 74
0070  3a 20 74 65 78 74 2f 68 74 6d 6c 2c 20 61 70 70
0080  6c 69 63 61 74 69 6f 6e 2f 78 68 74 6d 6c 2b 78
0090  6d 6c 2c 20 61 70 70 6c 69 63 61 74 69 6f 6e 2f
00a0  78 6d 6c 3b 71 3d 30 2e 39 2c 20 69 6d 61 67 65
00b0  2f 77 65 62 70 2c 20 69 6d 61 67 65 2f 61 70 6e
00c0  67 2c 20 2a 2f 2a 3b 71 3d 30 2e 38 0d 0a 41 63
00d0  63 65 70 74 2d 45 6e 63 6f 64 69 6e 67 3a 20 67
00e0  7a 69 70 2c 20 64 65 66 6c 61 74 65 0d 0a 41 63
00f0  63 65 70 74 2d 4c 61 6e 67 75 61 67 65 3a 20 65
0100  6e 2d 55 53 2c 20 65 6e 3b 71 3d 30 2e 38 0d 0a
0110  48 6f 73 74 3a 20 70 63 61 70 77 69 6e 2e 68 61
0120  63 6b 65 72 73 63 68 61 6c 6c 65 6e 67 65 2e 6f
0130  72 67 0d 0a 55 73 65 72 2d 41 67 65 6e 74 3a 20
0140  4d 6f 7a 69 6c 6c 61 2f 35 2e 30 20 28 4d 61 63
0150  69 6e 74 6f 73 68 3b 20 49 6e 74 65 6c 20 4d 61
0160  63 20 4f 53 20 58 20 31 30 5f 31 32 5f 35 29 20
0170  41 70 70 6c 65 57 65 62 4b 69 74 2f 35 33 37 2e
0180  33 36 20 28 4b 48 54 4d 4c 2c 20 6c 69 6b 65 20
0190  47 65 63 6b 6f 29 20 43 68 72 6f 6d 65 2f 35 39
01a0  2e 30 2e 33 30 37 31 2e 31 31 35 20 53 61 66 61
01b0  72 69 2f 35 33 37 2e 33 36 0d 0a 55 70 67 72 61
01c0  64 65 2d 49 6e 73 65 63 75 72 65 2d 52 65 71 75
01d0  65 73 74 73 3a 20 31 0d 0a 0d 0a

FIRST: As your flag, submit the destination MAC address
as HEX joined to the destination IP address as dotted decimal with a + sign.

THEN for Bonus Points:
THEN: As your flag, submit the destination MAC address
as HEX, and the destination IP address as dotted decimal,
and the destination host name as a string, all joined with a + sign.
~~~~

## Hint ##

You can decode/encode the hex data using the xxd program:

`cat get.hex | xxd -r | xxd -g 1 | cat > get.hexdump`


# WALKTHROUGH: #

At first glance at hexdump with my human eye balls, it appears to be a normal "GET" request:

0000040: 2b c2 *47 45 54 20 2f 20 48 54 54 50 2f 31 2e 31*  +.**GET / HTTP/1.1**
