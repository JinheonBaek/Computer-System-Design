
.data
string:
	.ascii "Hello World!\nHello World!\nHello World!\nHello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!\n"
	.byte 0x0D
	.byte 0x0A
	.ascii "Hello World!\nHello World!\nHello World!\nHello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!\n"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00

.text

.macro uart_print

	bl uart_trans

.endm


#include "uart_regs.h"

uart_trans:

//////////////////////////////////////////////
//       �Ʒ��� ���� �߻� �� clean project  //
//////////////////////////////////////////////

	ldr 	r0, =UART1_BASE
	ldr 	r1, =string

TRANSMIT_loop:

	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r2, [r0, #UART_CHANNEL_STS_REG0_OFFSET]	@ get Channel Status Register
	and	r2, r2, #0x8		@ get Transmit Buffer Empty bit(bit[3:3])
	cmp	r2, #0x8				@ check if TxFIFO is empty and ready to receive new data
	bne	TRANSMIT_loop		@ if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	ldrb     r3, [r1], #1
	streqb	r3, [r0, #UART_TX_RX_FIFO0_OFFSET]	@ fill the TxFIFO with 0x48
	cmp      r3, #0x00
	bne		TRANSMIT_loop

	mov		pc, lr				@    return to the caller