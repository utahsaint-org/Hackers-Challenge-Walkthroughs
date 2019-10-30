

	.equiv	SYS_WRITE, 4
	.equiv	SYS_EXIT, 1

	.text
	.global _start
	.type _start,%function

_start:
	moveml	%d2-%d3,%sp@-
	lea	-0x20(%sp),%sp
	bra	1f

	.include "key.s"
1:	
	clr.l	%d3			| cnt = 0
	lea xorstuff-.-2(%pc), %a0	| %a0 = &xorstuff[0]
	lea 1(%a0), %a1			| %a1 = &xorstuff[1]

1:
	move.w	(%a0)+, %d0
	move.w	(%a1)+, %d1
	eor.w	%d0, %d1
	lsr.w	#8, %d1
	mov.b	%d1,(%d3,%sp)
	add.l	#1, %d3
	tst.b	%d1
	bne	1b

	movel	%sp,%d2
	moveq	#1, %d1
	moveq	#4, %d0
	trap	#0

	clr.l %d1
	moveq #SYS_EXIT, %d0
	trap #0

	lea	0x20(%sp),%sp
	moveml	%sp@+,%d2-%d3
	rts
	.size _start,.-_start

