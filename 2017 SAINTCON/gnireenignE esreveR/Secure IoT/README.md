The secure IoT challenge at Saintcon 2017 was an ARM binary [here](secure).

```
$ file secure

secure: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically
linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 3.2.0,
BuildID[sha1]=c81d804401ab92ab5a125712ca0862f8d8200bc2, not stripped
```

# Static Analysis

Looking at checkFlag, the disassembly looks like the below according to
Binary Ninja.  Important facts: the first four integer arguments are
passed in registers `r0`, `r1`, `r2`, and `r3` (in that order).
Additional arguments are passed relative to the `sp` (e.g. `sp, #4`).

![disassembly](disassemly.png)

Pseudo code for this function:

```c
checkFlag(char *input) {
	static uint8_t key[32] = { ... };
	static uint8_t iv[16] = { ... };
	static uint8_t answer[48] = { ... };
	EVP_CIPHER *cipher;
	EVP_CIPHER_CTX *ctx;
	int len, outlen;

	len = strlen(input);
	cipher = EVP_aes_256_cbc;
	ctx = EVP_CIPHER_CTX_new();
	if (ctx == NULL) {
		// error handling
		return;
	}
	EVP_EncryptInit_ex(ctx, cipher, NULL, key, iv);
	EVP_EncryptUpdate(ctx, output_buffer, &outlen, input,
	    strlen(input));
	EVP_EncryptFinal_ex(ctx, output_buffer+outlen, &outlen);
	if (memcmp(answer, output_buffer, 48) == 0)
		// success!
}
```

In other words, this function encrypts whatever we specify on the
commandline with AES-256-CBC using a key and initialization vector
*in the binary*. The result is compared against an encrypted blob
*in the binary*.

The key is at `0xbd61c`, the IV is at `0xbd63c`, and the encrypted
blob is at `0xbd64c`.

![memory dump](memdump.png)

Here's a program that does the decryption.  The flag comes out in
the result.

```c

#include <sys/types.h>
#include <openssl/evp.h>
#include <stdint.h>
#include <string.h>
#include <err.h>

const uint8_t answer[48] = 
{
	0xed, 0x8d, 0x4e, 0x32, 0xe6, 0x05, 0x38, 0xfb, 0xea, 0x5f, 0xb8, 0xa8, 0xaf, 0x52, 0x94, 0xc1,
	0xc8, 0xe8, 0x24, 0x93, 0xc9, 0x15, 0xee, 0x3b, 0x21, 0x1a, 0x6f, 0xab, 0x19, 0x3a, 0x67, 0x8b,
	0xfe, 0xb3, 0x87, 0x83, 0x61, 0xf5, 0x24, 0xe7, 0xc1, 0xff, 0x25, 0x9d, 0xb9, 0x86, 0x62, 0x7d
};

const uint8_t key[32] = {
	0xd7, 0x1b, 0x60, 0xad, 0xcb, 0x3f, 0x3b, 0x40, 0x94, 0x8a, 0x1e, 0x45, 0xed, 0xd1, 0x9c, 0x7e,
	0x2e, 0xdf, 0xbd, 0x4a, 0x36, 0x01, 0x37, 0x17, 0x4f, 0x68, 0xb9, 0x7a, 0x7e, 0x6e, 0x3d, 0xdd
};

const uint8_t iv[16] = 
{
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

int
main() {
	EVP_CIPHER_CTX *ctx = NULL;
	const EVP_CIPHER *cipher;
	uint8_t output[sizeof(answer)+1];
	int outlen, tmplen;

	ctx = EVP_CIPHER_CTX_new();
	if (ctx == NULL) {
		warnx("bad malloc");
		goto errout;
	}

	cipher = EVP_aes_256_cbc();

	if (!EVP_DecryptInit_ex(ctx, cipher, NULL, key, iv)) {
		warnx("init failed");
		goto errout;
	}

	memset(output, 0, sizeof(output));
	outlen = sizeof(answer);
	if (!EVP_DecryptUpdate(ctx, output, &outlen, answer, sizeof(answer))) {
		warnx("update failed");
		goto errout;
	}

	if (!EVP_DecryptFinal_ex(ctx, output+outlen, &tmplen)) {
		warnx("final failed");
		goto errout;
	}

	EVP_CIPHER_CTX_free(ctx);

	printf("%s\n", output);
	return (0);

errout:
	if (ctx != NULL)
		EVP_CIPHER_CTX_free(ctx);
	return (1);
}
```

And here's my Binary Ninja [database](secure.bndb).

# Dynamic Analysis

Suppose you wanted to run the ARM binary, but didn't have an ARM machine
handy. QEMU has a user mode emulation of Linux on ARM.  If you're on ubuntu,
to run this challenge, you need a few packages:

```
jason@ubuntu:~$ apt install gdb-multiarch qemu-user libc6-armhf-cross
```

I actually went down the path both ways when solving this problem.
As it turns out, static analysis works just fine because the binary
isn't obfuscated in any way.  Had it been obfuscated, running the
program to various points would have been necessary, and that's what
the rest of this document shows.

First, we need to start execution of the binary.  It needs to know where
it's dynamic linker and libraries are (`/usr/arm-linux-gnuebihf`).
The command line below loads the binary and breaks execution just before
`main()` is called.  We'll use port 8888 for `gdb`.  Finally, the binary
and it's arguments are passed.

So start this in one window:

```
jason@ubuntu:~$ qemu-arm -L /usr/arm-linux-gnueabihf -g 8888 secure hello
```

And attach `gdb` to the running binary in another:

```
jason@ubuntu:~$ gdb-multiarch -q
(gdb) file secure
Reading symbols from secure...(no debugging symbols found)...done.
(gdb) target remote localhost:8888
Remote debugging using localhost:8888
warning: remote target does not support file transfer, attempting to access files from local filesystem.
warning: Unable to find dynamic linker breakpoint function.
GDB will be unable to debug shared library initializers
and track explicitly loaded dynamic code.
0xf67d6a40 in ?? ()
```

Set a few break points.  One for the call to `EVP_EncryptInit_ex()`
and another on the `memcmp()`. Then start the program running and wait
for it to hit a breakpoint.

```
(gdb) break *0x11294
Breakpoint 1 at 0x11294
(gdb) break *0x112f6
Breakpoint 2 at 0x112f6
(gdb) c
Continuing.
warning: Could not load shared library symbols for 2 libraries, e.g. /lib/libc.so.6.
Use the "info sharedlibrary" command to see the complete listing.
Do you need "set solib-search-path" or "set sysroot"?
Breakpoint 1, 0x00011294 in checkFlag ()
```


Fetch the key (4th argument to EVP_EncryptInit_ex is in `r3`)

```
(gdb) x/32bx $r3
0xbd61c <key>:	0xd7	0x1b	0x60	0xad	0xcb	0x3f	0x3b	0x40
0xbd624 <key+8>:	0x94	0x8a	0x1e	0x45	0xed	0xd1	0x9c	0x7e
0xbd62c <key+16>:	0x2e	0xdf	0xbd	0x4a	0x36	0x01	0x37	0x17
0xbd634 <key+24>:	0x4f	0x68	0xb9	0x7a	0x7e	0x6e	0x3d	0xdd
```

Fetch the initialization vector (5th argument to EVP_EncryptInit_ex is
in *(sp + 0).

```
(gdb) x/16bx *(int *)($sp)
0xbd63c <iv>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xbd644 <iv+8>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
```

Continue to the memcmp.

```
(gdb) c
Continuing.
```

Dump the contents of the second argument (r1) to memcmp.

```
Breakpoint 2, 0x000112f6 in checkFlag ()
(gdb) x/48bx $r1
0xbd64c <answer>:	0xed	0x8d	0x4e	0x32	0xe6	0x05	0x38	0xfb
0xbd654 <answer+8>:	0xea	0x5f	0xb8	0xa8	0xaf	0x52	0x94	0xc1
0xbd65c <answer+16>:	0xc8	0xe8	0x24	0x93	0xc9	0x15	0xee	0x3b
0xbd664 <answer+24>:	0x21	0x1a	0x6f	0xab	0x19	0x3a	0x67	0x8b
0xbd66c <answer+32>:	0xfe	0xb3	0x87	0x83	0x61	0xf5	0x24	0xe7
0xbd674 <answer+40>:	0xc1	0xff	0x25	0x9d	0xb9	0x86	0x62	0x7d
```

With key, IV, and data, we can decrypt (see program further up).  Or use [cyberchef](https://gchq.github.io/CyberChef/) as shown below:

![cyberchef](chef.png)


# Credits

This walkthrough brought to you by Jason L. Wright (jason@thought.net,
@risenrigel)


