.data
string:
	.byte 0x0D
	.byte 0x0A
	.ascii "----------------- LED On Period -----------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "1. 100ms 2. 200ms 3. 300ms 4. 400 ms"
	.byte 0x0D
	.byte 0x0A
	.ascii "5. 500ms 6. 600ms 7. 700ms 8. 1 sec"
	.byte 0x0D
	.byte 0x0A
	.ascii "----------------------------------------------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "Select: "
	.byte 0x00
.text

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
	ldr r2, =string

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
