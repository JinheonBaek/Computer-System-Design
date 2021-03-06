
#define csd_LED_ADDR	0x41200000


#include "uart_init.s"
#include "uart_print.s"


.extern csd_main

.align 8

// Our interrupt vector table
csd_entry:
	b csd_reset
	b .
	b .
	b .
	b .
	b .
	b csd_irq
	b .

.global main
csd_reset:
main:

	uart_init // uart 초기화

	uart_print // uart 프린트

	uart_print // 재 호출

/*
	mov r0, #10
	mov r1, #3
	add r0, r0, r1

	ldr r0, =src
	ldr r1, =dst
	mov r2, #16

loop:
	ldr r3, [r0], #4   // load a word into r3 and upate r0 (= r0 + 4)
	str r3, [r1], #4   // store the word to memory and upate r1 (= r1 + 4)
	subs r2, r2, #1
	bne  loop

 	ldr r0, =csd_LED_ADDR
	mov r1, #0x5
	str r1, [r0]

	bl csd_main


	uart_init

	bl uart_trans
*/

forever:
	nop
	b forever


.data
.align 4

src:
	.word  1,  2,  3,  4,  5,  6,  7,  8
	.word 11, 12, 13, 14, 15, 16, 17, 18

dst:
	.space 16  // allocate memory for 16 words


// Normal Interrupt Service Routine
csd_irq:
	b .
