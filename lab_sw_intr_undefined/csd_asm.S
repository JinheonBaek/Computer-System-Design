#include "csd_zynq_peripherals.h"

#define Undefined_Mode	0x1B
#define SVC_Mode	    0x13

.align 8

csd_vector_table:
	b csd_reset
	b csd_undefined
	b csd_software_interrupt
	b csd_prefetch
	b csd_data
	b csd_not_used
	b csd_irq
	b csd_fiq

.global main
main:

	// Set VBAR (Vector Base Address Register) to my own interrupt vectors
    ldr     r0, =csd_vector_table
    mcr     p15, 0, r0, c12, c0, 0
    dsb
    isb

	mrs	r0, cpsr			/* read CPSR */
	mvn	r1, #0x1f		/* to remove mode bits in CPSR */
	and	r2, r1, r0
	orr	r2, r2, #0x13		/* Supervisor (SVC) mode */
	msr	cpsr, r2
	ldr	r13,=svc_stack_top	/* SVC mode stack pointer */

	cps  #0x1b   // Change to Undefined Mode
	ldr	r13,=und_stack_top	/* SVC mode stack pointer */

	cps  #0x10   // Change to User Mode

forever:
    svc #10
    nop
    nop
    b forever


csd_reset:
    b .

csd_undefined:
	srsfd sp!, #Undefined_Mode  // SRS(Save Return State): save LR and SPSR to stack
	stmfd sp!, {r0-r12}

   // ISR body: do something

	ldmfd sp!, {r0-r12}
	rfefd sp!   // RFE(Return from Exception): restore PC and CPSR from stack
	// movs  pc, lr

csd_prefetch:
csd_data:
csd_not_used:
csd_irq:
csd_fiq:
	b .

csd_software_interrupt:

	srsfd sp!, #SVC_Mode  // SRS(Save Return State): save LR and SPSR to stack
	stmfd sp!, {r0-r12}

 	// Toggle LEDs
	ldr  r0, =csd_LED_ADDR
	ldr  r1, =led_initial
	ldr  r2, [r1]
	eor  r2, r2, #0xFF  // toggle the data
	strb r2,[r0]        // turn on LEDs
	str  r2, [r1]       // store a new value to led_initial

	// Exception: Undefined instruction
	.word 0xffffffff
	//svc #20

	ldmfd sp!, {r0-r12}
	rfefd sp!   // RFE(Return from Exception): restore PC and CPSR from stack
 //   movs  pc, lr


.data
.align 4

irq_stack:     .space 1024
irq_stack_top:
fiq_stack:     .space 1024
fiq_stack_top:
svc_stack:     .space 1024
svc_stack_top:
und_stack:     .space 1024
und_stack_top:

led_initial: .word 0xC3
