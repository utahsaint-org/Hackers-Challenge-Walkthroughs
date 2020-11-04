# First run strings, note the curous unlock text 
灰色浪人$ strings secret
Enter the secret:
secret:
secret.asm
prompt
secret
slength
input
quit
unlock
__bss_start
_edata
_end
.symtab
.strtab
.shstrtab
.text
.data
.bss

# Use objdump to look for unlock, note that unlock has an address in the code (.text) section 
灰色浪人$ objdump -x secret

secret:     file format elf64-x86-64
secret
architecture: i386:x86-64, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000004000b0

Program Header:
    LOAD off    0x0000000000000000 vaddr 0x0000000000400000 paddr 0x0000000000400000 align 2**21
         filesz 0x0000000000000331 memsz 0x0000000000000331 flags r-x
    LOAD off    0x0000000000000334 vaddr 0x0000000000600334 paddr 0x0000000000600334 align 2**21
         filesz 0x000000000000001a memsz 0x000000000000011c flags rw-

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         00000281  00000000004000b0  00000000004000b0  000000b0  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         0000001a  0000000000600334  0000000000600334  00000334  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000100  0000000000600350  0000000000600350  0000034e  2**2
                  ALLOC
SYMBOL TABLE:
00000000004000b0 l    d  .text	0000000000000000 .text
0000000000600334 l    d  .data	0000000000000000 .data
0000000000600350 l    d  .bss	0000000000000000 .bss
0000000000000000 l    df *ABS*	0000000000000000 secret.asm
0000000000600334 l       .data	0000000000000000 prompt
0000000000000012 l       *ABS*	0000000000000000 length
0000000000600346 l       .data	0000000000000000 secret
000000000000001a l       *ABS*	0000000000000000 slength
0000000000600350 l       .bss	0000000000000000 input
00000000004000e8 l       .text	0000000000000000 quit
00000000004000f3 l       .text	0000000000000000 unlock
00000000004000b0 g       .text	0000000000000000 _start
000000000060034e g       .bss	0000000000000000 __bss_start
000000000060034e g       .data	0000000000000000 _edata
0000000000600450 g       .bss	0000000000000000 _end

# Let's start gdb and see if we can call unlock as a function
灰色浪人$ gdb ./secret
{...}
gdb-peda$ b _start
Breakpoint 1 at 0x4000b0
gdb-peda$ r
gdb-peda$ call unlock
$1 = {<text variable, no debug info>} 0x4000f3 <unlock>

## Doesn't look like we can call the address in this way, so we'll set RIP to the address for unlock
gdb-peda$ set $rip = 0x4000f3
0x00000000004000f8 in unlock ()
gdb-peda$ c
Continuing.
flag{6865726520697320796f757220736563726574}[Inferior 1 (process 2424) exited normally]
Warning: not running

## Flag is written to the console
flag{6865726520697320796f757220736563726574}

