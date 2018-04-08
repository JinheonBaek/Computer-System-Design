#include "uart_regs.h"

.macro uart_init

	ldr r0,	=slcr_UART_RST_CTRL
	ldr r1, =0x0	//	reset UART
	str r1, [r0]

	ldr r0, =slcr_UART_CLK_CTRL
	ldr r1, =0x1402	// divisor = 0x14 (ref clk = 50MHz), srcsel = 0, CLKACT1 = true, CLKACT0 = false
	str r1, [r0]

	ldr r0, =uart_mode_reg0
	ldr r1, =0x20
	str r1, [r0]

	ldr r0, =uart_Control_reg0
	ldr r1, =0x28	//uart off
	str r1, [r0]

	ldr r0, =uart_Baud_rate_gen_reg0
	ldr r1, =0x3e
	str r1, [r0]

	ldr r0, =uart_Baud_rate_divider_reg0
	ldr r1, =0x6
	str r1, [r0]

	ldr r0, =uart_Control_reg0
	ldr r1, =0x00000117	//uart start
	str r1, [r0]

	ldr r0, =uart_Modem_ctrl_reg0
	ldr r1, [r0]

	ldr r0, =uart_Modem_sts_reg0
	ldr r1, [r0]


.endm
