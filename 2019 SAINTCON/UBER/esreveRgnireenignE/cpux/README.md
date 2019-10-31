
# Hint

CPU CPU CPU CPU CPU CPU CPU CPU
CPU CPU CPU CPU CPU CPU CPU CPU
CPU CPU CPU CPU CPU CPU CPU CPU
CPU CPU CPU CPU CPU CPU CPU CPU

# file

[challenge](challenge)

# Alternative hint

Or maybe a little less obtuse: This challenge was written
by @risenrigel, I wonder what he's been hacking on in github.

# Description/walkthrough

This challenge was inspred by the 2018 challenge "bicep carapace".
That binary was a snippet of ARM machine code with no identifying
headers. You had to guess (based on the name of the challenge)
that it referred to StrongARM. The challenge was easy with that
information.

Fast forward to 2019 and I was forced to relearn m68k assembly.
Since I had to learn it, so do you =) Fortunately, I revived
an older binaryninja m68k architecture plugin. @zznop and I
made some improvements, etc., and you can find it
[here](https://github.com/wrigjl/binaryninja-m68k).

I hand crafted the assembly, mainly so I could use instructions
like `move.w (%a0)+, %d0`. I mean, really, who doesn't like
dereference and postincrement instructions.

Btw, the hint "CPU" repeated 32 times is a reference to the fact
that m68k was called CPU32, the other hint requires a bit of
digging on the web, but is otherwise trivial (I don't have
alot of stuff on github).

Ghidra gives you this:

```
undefined4 _start(void)

{
  byte bVar1;
  int iVar2;
  undefined2 *puVar3;
  undefined2 *puVar4;
  byte local_28 [32];
  
  iVar2 = 0;
  puVar3 = &xorstuff;
  puVar4 = (undefined2 *)((int)&xorstuff + 1);
  do {
    bVar1 = (byte)((ushort)*puVar3 >> 8) ^ (byte)((ushort)*puVar4 >> 8);
    local_28[iVar2] = bVar1;
    iVar2 = iVar2 + 1;
    puVar3 = puVar3 + 1;
    puVar4 = puVar4 + 1;
  } while (bVar1 != 0);
  trap(0x20);
  trap(0x20);
  return 1;
}
```

So, the code xor's two strings together and then calls write(2) and exit(2).

# Alternative solution

You could also run it... With m68k cross binutils and gcc as well as qemu's m68k
emulator installed:

```
make runit
qemu-m68k -L /usr/m68k-linux-gnu -cpu m68030 ./runit challenge   
```

This runs the challenge in a 68k emulator by memory mapping it and jumping to it.
Running arbitrary code loaded from the filesystem... what could go wrong?

# Alternative alternative solution

One of my friends who solved this did it by simply xor'n all the bytes in the
adjacent pairs of bytes in the file.

```
import struct, sys
f = open('challenge', 'rb')
l = struct.unpack('B', f.read(1))[0]
flag = True

while True:
    b = f.read(1)
    if len(b) == 0:
        break
    if flag:
        r = struct.unpack('B', b)[0]
        print(struct.pack('B', l ^ r))
    else:
        l = struct.unpack('B', b)[0]
    flag = not flag
```

# Author 
This challenge and walkthrough was written by Jason Wright
([jason@thought.net](mailto:jason@thought.net),
 [@risenrigel](https://twitter.com/risenrigel)).
