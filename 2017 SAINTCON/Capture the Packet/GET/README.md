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

You can decode/encode to see the above hex data in ASCII using xxd:

~~~~
cat get.hex | xxd -r | xxd -g 1 | cat > get.hexdump
~~~~


# WALKTHROUGH: #

At first glance at hexdump with my human eye balls, it appears to be a normal "GET" request:

0000040: 2b c2 *47 45 54 20 2f 20 48 54 54 50 2f 31 2e 31*  +.**GET / HTTP/1.1**

I haven't memorized the header format of a raw TCP packet, so we'll have to Reverse Engineer it. We can fire up tcpdump to try to catch the real thing:

~~~~
$ sudo tcpdump -n -w live.get.pcap port 80
~~~~

Then quickly visit some site on port 80 ( such as http://hackerschallenge.org/ ) to see what a real request looks like. Then quickly hit CTRL-C to stop the tcpdump process. Now we can peek at the dump to see if we caught a real live packet:

~~~~
tcpdump -Xen -r live.get.pcap | less

12:06:18.758521 a4:5e:60:b8:e6:8d > 52:54:00:a8:fd:fb, ethertype IPv4 (0x0800), length 461: 10.200.0.138.52421 > 54.165.138.4.80: Flags [P.], seq 1:396, ack 1, win 4117,
 options [nop,nop,TS val 1210163294 ecr 432040457], length 395
        0x0000:  4500 01bf e8ad 4000 4006 8490 0ac8 008a  E.....@.@.......
        0x0010:  36a5 8a04 ccc5 0050 b356 3068 e455 379d  6......P.V0h.U7.
        0x0020:  8018 1015 f761 0000 0101 080a 4821 a05e  .....a......H!.^
        0x0030:  19c0 6a09 4745 5420 2f20 4854 5450 2f31  ..j.GET./.HTTP/1
        0x0040:  2e31 0d0a 486f 7374 3a20 6861 636b 6572  .1..Host:.hacker
        0x0050:  7363 6861 6c6c 656e 6765 2e6f 7267 0d0a  schallenge.org..
        0x0060:  436f 6e6e 6563 7469 6f6e 3a20 6b65 6570  Connection:.keep
~~~~

Yey! We found one! Notice tcpdump decodes the dump to show the Source and Destination MAC and IP Addresses. We see this packet is coming from my local MAC (a4:5e:60:b8:e6:8d) to my router's MAC (52:54:00:a8:fd:fb). And this packet is coming from my local IP (10.200.0.138 from port 52421) to remote IP (54.165.138.4 to port 80). Luckily this target matches exactly with what was typed into the browser: http://hackerschallenge.org/

So now we can look at this raw capture file to see where this info actually lives:

~~~~
$ xxd -g 1 live.get.pcap | less

0004bf0: cd 01 00 00{52 54 00 a8 fd fb|a4 5e 60 b8 e6 8d} ....RT.....^`...
0004c00: 08 00 45 00 01 bf e8 ad 40 00 40 06 84 90{0a c8  ..E.....@.@.....
0004c10: 00 8a|36 a5 8a 04}cc c5 00 50 b3 56 30 68 e4 55  ..6......P.V0h.U
0004c20: 37 9d 80 18 10 15 f7 61 00 00 01 01 08 0a 48 21  7......a......H!
0004c30: a0 5e 19 c0 6a 09{47 45 54 20 2f 20 48 54 54 50} .^..j.GET / HTTP
0004c40: 2f 31 2e 31 0d 0a 48 6f 73 74 3a 20 68 61 63 6b  /1.1..Host: hack
0004c50: 65 72 73 63 68 61 6c 6c 65 6e 67 65 2e 6f 72 67  erschallenge.org
0004c60: 0d 0a 43 6f 6e 6e 65 63 74 69 6f 6e 3a 20 6b 65  ..Connection: ke
0004c70: 65 70 2d 61 6c 69 76 65 0d 0a 55 73 65 72 2d 41  ep-alive..User-A
~~~~

(I just added the "{" "}" to help denote interesting portions of the hexdump.)

My MAC Addresses are already in HEX in the tcpdump output so those are trivial to spot at offset 0004bf4.

And we can convert the IP to HEX just to make it a little easier to spot in the dump:

~~~~
$ perl -le 'print unpack H8 => 10.200.0.138; print unpack H8 => 54.165.138.4;'
0ac8008a
36a58a04
$
~~~~

So we can more easily spot these exact HEX values at offset 0004c0e.

And just for fun, it looks like the PORTS come immediately after that at offset 0004c16, which we don't actually need this info for this puzzle.

The actual stream data "GET / HTTP" obviously starts at offset 0004c36 in this particular capture file.

## Breakdown ##

So we can see this:

~~~~
  OFFSET |  HEX                | Description                                 | Bytes before stream
@ 0004bf4: "52 54 00 a8 fd fb" - Destination MAC Address (a4:5e:60:b8:e6:8d) | 66
@ 0004bfa: "a4 5e 60 b8 e6 8d" - Source MAC Address (52:54:00:a8:fd:fb)      | 60
@ 0004c0e: "0a c8 00 8a"       - Source IP Address (10.200.0.138)            | 40
@ 0004c12: "36 a5 8a 04"       - Destination IP (54.165.138.4)               | 36
@ 0004c16: "cc c5"             - Source Port (52421)                         | 32
@ 0004c18: "00 50"             - Destination Port (80)                       | 30
@ 0004c36: "47 45 54"          - Actual stream data begins (GET)             |  0
~~~~

And now that we know the offsets, we can extract the useful information from the raw capture:

~~~~
head get.hexdump

00000000  80 2a a8 4c 9d e8 a0 99  9b 1d 5d 8f 08 00 45 00  |.*.L......]...E.|
00000010  01 cd 2a 21 40 00 40 06  05 2f c0 a8 0d 0d cb 00  |..*!@.@../......|
00000020  71 25 e1 e3 00 50 b0 1c  53 75 3e 58 55 7c 80 18  |q%...P..Su>XU|..|
00000030  10 2c a9 1f 00 00 01 01  08 0a 3a ae ea 9c 1c 18  |.,........:.....|
00000040  2b c2 47 45 54 20 2f 20  48 54 54 50 2f 31 2e 31  |+.GET / HTTP/1.1|
~~~~

We can see the actual data stream starts at offset 0000042 (GET).

So if we look 66 bytes before the "GET" we will see "80 2a a8 4c 9d e8" at offset 00000000, which is exactly the Destination MAC Address (80:2A:A8:4C:9D:E8) we are looking for. And if we look 36 bytes before "GET" we will see "cb 00 71 25" at offset 0000001e, which is exactly the Destination IP Address we are looking for.

We need the MAC in "HEX" so we need to remove all the colons and spaces.
And we need to convert the hex IP to DOTTED DECIMAL:

~~~~
$ perl -le 'print join ".", 0xCB,0x00,0x71,0x25'
~~~~

Then just put a "+" in between these two strings as explained in the instructions.

80:2a:a8:4c:9d:e8+203.0.113.37
