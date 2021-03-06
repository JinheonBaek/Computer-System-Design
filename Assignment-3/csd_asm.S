
#define csd_LED_ADDR	0x41200000

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
	ldr r0, =csd_LED_ADDR		// Init
	mov r1, #0x1				// Init (First LED on)

forever:
	stmfd sp!, {r0-r1}			// Before call csd_main, using stack to save variables
	bl csd_main
	ldmfd sp!, {r0-r1}			// After call csd_main, loading variables from stack

	strb r1, [r0]				// Turn on next LED

	lsl r1, r1, #1				// logical shift left by 1
	cmp r1, #0x100				// compare
	moveq r1, #0x1				// reset LED if compare condition is true

	b forever


.data
.align 4

// Normal Interrupt Service Routine
csd_irq:
	b .
