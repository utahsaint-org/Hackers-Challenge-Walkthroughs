; ----------------------------------------------------------------------------------------
; Author: gr3yR0n1n
; Date: 2020.10.13
; Secret 
; ----------------------------------------------------------------------------------------

         global    _start

         section   .data
prompt   db        "Enter the secret:", 0xa
length   equ       $-prompt
secret   db        "secret:", 0xa
slength   equ       $-prompt

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
     
unlock:  mov       rax, 1
         mov       rdi, 1
         push      'fl'
         mov       rsi, rsp
         mov       rdx, 2
         syscall

         mov       rax, 1 
         mov       rdi, 1
         push      'ag'
         mov       rsi, rsp
         mov       rdx, 2
         syscall

         mov       rax, 1 
         mov       rdi, 1
         push      '{'
         mov       rsi, rsp
         mov       rdx, 1
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '68' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '65' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '72'
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '65' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '20' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '69' 
         mov       rsi, rsp
         mov       rdx, 2
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '73' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '20' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '79' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '6f' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '75' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '72' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '20' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '73' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '65' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '63' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '72' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '65' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '74' 
         mov       rsi, rsp
         mov       rdx, 2 
         syscall

         mov       rax, 1
         mov       rdi, 1
         push      '}'
         mov       rsi, rsp
         mov       rdx, 1 
         syscall

         call      quit





