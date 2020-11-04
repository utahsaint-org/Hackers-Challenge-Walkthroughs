; ----------------------------------------------------------------------------------------
; Author: gr3yR0n1n
; Date: 2020.10.13
; Escape
; ----------------------------------------------------------------------------------------

         global    _start

         section   .data
flag     dd        "f","l","a","g","{","S","t","r","i","n","g","s","_","w","i","t","h","_","E","x","t","r","4","_","S","t","3","p","5","}",0xa
empty    dw        "G","e","t","t","i","n","g","_","w","a","r","m","e","r",0xa
dumb     db        "Good_start",0xa
prompt   db        "You find yourself in a dark room, surrounded by four walls. Choose a direction.", 0xa
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
     