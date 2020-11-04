; ----------------------------------------------------------------------------------------
; Author: gr3yR0n1n
; Date: 2020.10.13
; Secure Door Program
; ----------------------------------------------------------------------------------------

         global    _start

         section   .data
flag     db        "f","l","a","g","{","Y","0","u","_","4","r","e","_","S","a","f","3","!","}", 0xa
prompt   db        "Enter Password:", 0xa
length   equ       $-prompt

         section   .bss
input:   resb      0xff

         section   .text
_start:  mov       rax, 1
         mov       rdi, 1
         mov       rsi, prompt
         mov       rdx, length
         syscall

         mov       rdx, 0xff
         mov       rsi, input
         mov       rdi, 0
         mov       rax, 0
         syscall
     
         jmp       _start

quit:    mov       rax, 60
         xor       rdi, rdi
         syscall
         ret
     