.macro uart_print

	bleq uart_trans_init

.endm

//////////////////////////////////////////////
//		reference error : clean project		//
//////////////////////////////////////////////

#include "uart_regs.h"

uart_trans_init:

	ldr r0, =uart_TX_RX_FIFO0
	ldr r1, =uart_Channel_sts_reg0
	ldr r2, =timer_space

	// Timer Cal
	ldrb r3, [r2, #15]
	add r3, r3, #1
	strb r3, [r2, #15]

	cmp r3, #0x3A
	moveq r3, #0x30
	streqb r3, [r2, #15]

	ldreqb r3, [r2, #14]
	addeq r3, r3, #1
	streqb r3, [r2, #14]

	cmpeq r3, #0x36
	moveq r3, #0x30
	streqb r3, [r2, #14]

	ldreqb r3, [r2, #12]
	addeq r3, r3, #1
	streqb r3, [r2, #12]

	cmpeq r3, #0x3A
	moveq r3, #0x30
	streqb r3, [r2, #12]

	ldreqb r3, [r2, #11]
	addeq r3, r3, #1
	streqb r3, [r2, #11]

	cmpeq r3, #0x36
	moveq r3, #0x30
	streqb r3, [r2, #11]

	ldreqb r3, [r2, #9]
	addeq r3, r3, #1
	streqb r3, [r2, #9]

	cmpeq r3, #0x3A
	moveq r3, #0x30
	streqb r3, [r2, #9]

	ldreqb r3, [r2, #8]
	addeq r3, r3, #1
	streqb r3, [r2, #8]

	// 24 hours -> 0
	cmpeq r3, #0x32
	ldreqb r4, [r2, #9]
	cmpeq r4, #0x34

	moveq r3, #0x30
	streqb r3, [r2, #8]
	streqb r3, [r2, #9]

TRANSMIT_loop:

	// check to see if the Tx FIFO is empty
	ldr r3, [r1]
	and r3, r3, #0x8
	cmp r3, #0x8
	bne TRANSMIT_loop

	ldrb r4, [r2], #1
	strb r4, [r0]			// fill the Tx FIFO
	cmp r4, #0x00
	bne TRANSMIT_loop

	mov pc, lr

.data
timer_space:
	.byte 0x08		// 0
	.byte 0x08		// 1
	.byte 0x08		// 2
	.byte 0x08		// 3
	.byte 0x08		// 4
	.byte 0x08		// 5
	.byte 0x08		// 6
	.byte 0x08		// 7
	.byte 0x30		// 8 (hour)
	.byte 0x30		// 9 (hour)
	.byte 0x3A		// 10
	.byte 0x30		// 11 (min)
	.byte 0x30		// 12 (min)
	.byte 0x3A		// 13
	.byte 0x30		// 14 (sec)
	.byte 0x30		// 15 (sec)
	.byte 0x00
.text
