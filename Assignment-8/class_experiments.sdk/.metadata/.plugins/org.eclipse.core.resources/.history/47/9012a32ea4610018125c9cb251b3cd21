#include "csd_zynq_peripherals.h"

#define csd_LED_ADDR 0x41200000

.extern csd_main

.section .csd_boot,"ax"

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

	// Set VBAR (Vector Base Address Register) to my own interrupt vectors
   ldr     r0, =csd_entry
   mcr     p15, 0, r0, c12, c0, 0
   dsb
   isb


forever:
	nop

	ldr r0, =csd_LED_ADDR
	ldr r1, =led_initial
	ldr r2, [r1]
	eor r2, r2, #0xFF
	str r2, [r0]
	str r2, [r1]

	bl csd_main

	cmp r0, #0x0

	// Read Cache Type Register (CTR)
	mrc p15, 0, r1, c0, c0, 1

	// Read Cache Level ID Register (CLIDR)
	mrc p15, 1, r2, c0, c0, 1

	@------------------------
	@ Disable Caches (L2)
	@------------------------
	ldrne r0, =L2_reg1_ctrl
    movne r1, #0x0
    strne r0, [r0]
	@------------------------
	@ Disable Caches (IL1, DL1)
	@------------------------
	mrcne		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	bicne		r0, r0, #4096		    @ disable I bit (Instruction Cache)
	bicne		r0, r0, #4		        @ disable C bit (Data and Unified Caches)
	mcrne		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)

	@------------------------
	@ Enable Caches (L2)
	@------------------------
	ldreq r0, =L2_reg1_ctrl
    moveq r1, #0x1
    streq r0, [r0]

	@------------------------
	@ Enable Caches (IL1, DL1)
	@------------------------
	mrceq		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	orreq		r0, r0, #(1<<12)	    @ Enable I bit (Instruction Cache)
	orreq		r0, r0, #(1<<2)         @ Enable C bit (Data and Unified Caches)
	mcreq		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)


	// read SCTLR (System Control Register) to r0
	mrc	p15, 0, r0, c1, c0, 0

	b forever

led_initial: .word 0xC3

// Normal Interrupt Service Routine
csd_irq:
	b .

.end

