# Title

PlugX

# Hint

I leet hacker, none can decode my strings!

# Solution

If you run the binary, you get the following:

```
user@user-virtual-machine ~ $ Desktop/plugx/plugx.dms
Usage: Desktop/plugx/plugx.dms flag

user@user-virtual-machine ~ $ Desktop/plugx/plugx.dms asdfasdf
Sorry, that is incorrect
```

It appears the binary checks the user-entered value, and returns whether the values match. Taking a look in Binary Ninja, the routine looks a little complicated. Fortunately for us, the challenge authors left some symbols for us, namely `encFlag` (global variable) and `dec()`. `dec()` is not called directly, and it appears the code used to encrypt the user string (or decrypt the flag) is done inline.

Rather than figure out the algorithm, we can use a debugger to do the work for us!

First, we start up GDB specifying arguments for the plugx app, set a breakpoint on `main()`, and run:

```
user@user-virtual-machine ~ $ gdb --args Desktop/plugx/plugx.dms asdfasdf
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.04) 7.11.1
...

(gdb) b main
Breakpoint 1 at 0x610

(gdb) r
Starting program: /home/user/Desktop/plugx/plugx.dms asdfasdf

Breakpoint 1, 0x0000555555554610 in main ()
```

Next, we can verify that GDB recognizes the `dec()` and `encFlag` symbols in our loaded binary:

```
(gdb) info address encFlag
Symbol "encFlag" is at 0x555555755050 in a file compiled without debugging.

(gdb) info address dec
Symbol "dec" is at 0x5555555548f0 in a file compiled without debugging.
```

We can also verify that this contains the data we saw in the .data section, via the disassembler:

```
(gdb) x/22xb 0x555555755050
0x555555755050 <encFlag>:       0x71	0x7c	0x56	0xb3	0x9d	0x85	0xeb	0x6c
0x555555755058 <encFlag+8>:     0xda	0x22	0xd8	0xeb	0x9a	0xc6	0xff	0x24
0x555555755060 <encFlag+16>:	0x90	0xf1	0x34	0xc5	0xda	0xac
```

Now we can just call the `dec()` function with that data, and the length of the buffer (knowing this requires a bit of static RE, refer to solution1):

```
(gdb) call dec(0x555555755050, 22)
$1 = -1664873812
```

What this has done, is decrypt the `encFlag` variable in-place! Let's verify:

```
(gdb) x/22xb 0x555555755050
0x555555755050 <encFlag>:       0x4e	0x65	0x76	0x65	0x72	0x52	0x6f	0x6c
0x555555755058 <encFlag+8>:     0x6c	0x59	0x6f	0x75	0x72	0x4f	0x77	0x6e
0x555555755060 <encFlag+16>:    0x43	0x72	0x79	0x70	0x74	0x6f
```

The value has definitely changed; let's look at it as a string:

```
(gdb) x/1s 0x555555755050
0x555555755050 <encFlag>:	"NeverRollYourOwnCrypto"
```

# Writeup Author
[klustic@gmail.com](mailto:klustic@gmail.com)
