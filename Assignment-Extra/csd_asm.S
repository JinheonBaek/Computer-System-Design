
#include "csd_zynq_peripherals.h"
#include "uart_init.s"
#include "uart_print.s"
#include "uart_regs.h"

#define TIMER_INITIAL	0x1000000


.extern csd_main
.extern task1_c
.extern task2_c
.extern task3_c

.align 8

csd_entry:
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

//--- UART Configuration
	uart_init

//--- Stack setup for each mode

	// Disable interrupt: Turn on I bit in CPSR
    cpsID i

	cps #0x12	   	       /* IRQ mode */
	ldr	r13,=irq_stack_top /* stack pointer setup for IRQ mode */

	cps #0x13		       /* supervisor mode */
	ldr	r13,=svc_stack_top /* stack pointer setup for SVC mode */

    cps #0x11		       /* FIQ mode */
	ldr	r13,=fiq_stack_top /* stack pointer setup for FIQ mode */

	cps #0x1F	           /* SYS mode */

	// Set VBAR (Vector Base Address Register) to the base of my interrupt vector table
    ldr     r0, =csd_entry
    mcr     p15, 0, r0, c12, c0, 0
    dsb
    isb

	// Enable interrupt: Turn off I bit in CPSR
    cpsIE i

//--- Generic Interrupt Controller (GIC) setup - Begin

	// CPU Interface ID Register
	ldr r0, =GICC_IIDR
	ldr r3, [r0]

	// CPU Controller Type Register
	ldr r0, =GICD_TYPER
	ldr r3, [r0]

	// CPU Binary Pointer Register
	ldr r0, =GICC_BPR
	ldr r3, [r0]

	// Distributor Control Register
	ldr r0, =GICD_CTLR
	ldr r1, [r0]
	mov r2, #1       // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	 // Interrupt Set-Enable Register 0
	ldr r0, =GICD_ISENABLER0
	ldr r1, [r0]
	mov r2, #1 << 29   // Enable #29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR7
	ldr r1, [r0]
	mov r2, #1 << 8    // 2nd Highest: 1 for ID# 29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

 	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     // Lowest
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]


//--- Generic Interrupt Controller (GIC) setup - End

//--- Private Timer setup - Begin

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #10 << 8   // Prescalar
 	orr r1, r1, #7     // IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

//--- Private Timer setup - End

//--- Stack setup for each user program
	ldr r0, =task_stack_top
	mov r1, #0x0
	str r1, [r0]

 	// Simple check out
  	ldr r0, =PRIVATE_COUNTER
	ldr r1, =PRIVATE_STATUS
 	ldr r2, =GICD_ISPENDR0

	// Load lr stack (for storing each task's pc)
 	ldr r3, =lr_stack_top

 	ldr r0, =task1_c
 	add r0, r0, #0x4		// IRQ (Interrupt: pc - 4)

 	ldr r1, =task2_c
 	add r1, r1, #0x4		// IRQ (Interrupt: pc - 4)

 	ldr r2, =task3_c
 	add r2, r2, #0x4		// IRQ (Interrupt: pc - 4)

 	stm r3, {r0-r2}			// Save lr stack (each task's pc are stored in lr stack)

forever:
   b task1_c				// Run task1 at first time
   b forever


// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
//

csd_software_interrupt:
csd_reset:
csd_undefined:
csd_prefetch:
csd_data:
csd_not_used:
csd_irq:

	// Start IRQ Interrupt
	stmfd sp!, {r0-r12, lr}			// Save current registers

 	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

 	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

	// Clear I, F (IRQ / FIQ) for next timer interrupt (IRQ)
	CPSIE if

	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldmfd sp!, {r0-r12, lr}			// Load before IRQ interrupt registers

//--- Task1 / Task2 / Task3 (All pattern is same) ---//

//--- Task 1
	ldr r0, =task_stack_top			// task_stack_top: which task already be runned at this time
	ldr r1, [r0]					// load task num that already be runned (0 : task1 / 1 : task2 / 2 : task3)

	cmp r1, #0x0					// Task1 already be runned at this time?
	addeq r1, r1, #1				// If that, next task that should be run is task2
	streq r1, [r0]

	ldreq r0, =lr_stack_top			// lr_stack: that holds task's pc address
	ldmeq r0, {r1-r3}				// load task1 ~ task3's pc address into r1 ~ r3
	moveq r1, lr					// for saving purpose, store current task's pc(lr) into r1 register (task1)
	moveq lr, r2					// for loading purpose, load next task's pc(lr) into lr register (task2 will be launched)
	stmeq r0, {r1-r3}				// store each task's current address

	ldreq sp, =usr1_stack_top		// usr1_stack_top hold's task1's current context
	stmeq sp, {r0-lr}^

	ldreq sp, =usr2_stack_top		// usr2_stack_top hold's task2's current context
	ldmeq sp, {r0-r12}^

	subeqs pc, lr, #4				// task2 is launched !

//--- Task 2	(Pattern is same as Task1)
	ldr r0, =task_stack_top
	ldr r1, [r0]

	cmp r1, #0x1
	addeq r1, r1, #1
	streq r1, [r0]

	ldreq r0, =lr_stack_top
	ldmeq r0, {r1-r3}
	moveq lr, r3
	stmeq r0, {r1-r3}

	ldreq sp, =usr2_stack_top
	stmeq sp, {r0-lr}^

	ldreq sp, =usr3_stack_top
	ldmeq sp, {r0-r12}^

	subeqs pc, lr, #4

//--- Task 3	(Pattern is same as Task1)
	ldr r0, =task_stack_top
	ldr r1, [r0]

	cmp r1, #0x2
	moveq r1, #0x0
	streq r1, [r0]

	ldreq r0, =lr_stack_top
	ldmeq r0, {r1-r3}
	moveq r3, lr
	moveq lr, r1
	stmeq r0, {r1-r3}

	ldreq sp, =usr3_stack_top
	stmeq sp, {r0-lr}^

	ldreq sp, =usr1_stack_top
	ldmeq sp, {r0-r12}^

	subeqs pc, lr, #4

csd_fiq:
	b .

//
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
.align 4

irq_stack:     .space 1024
irq_stack_top:
fiq_stack:     .space 1024
fiq_stack_top:
svc_stack:     .space 1024
svc_stack_top:
usr1_stack:		.space 1024
usr1_stack_top:
usr2_stack:		.space 1024
usr2_stack_top:
usr3_stack:		.space 1024
usr3_stack_top:
task_stack:		.space 1024
task_stack_top:
lr_stack:		.space 1024
lr_stack_top:

