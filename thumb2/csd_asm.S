
.syntax unified    // note this...

.extern thumb_C_test
.extern arm_C_test

.align 8
// Our interrupt vector table
csd_entry:
	b csd_reset
	b .
	b .
	b .
	b .
	b .
	b .
	b .
.global main
csd_reset:
main:

    mov r0,  #0x00
    mov r1,  #0x11
    mov r2,  #0x22
    mov r3,  #0x33
    mov r4,  #0x44
    mov r5,  #0x55
    mov r6,  #0x66
    mov r7,  #0x77
    mov r8,  #0x88
    mov r9,  #0x99
    mov r10, #0xaa
    mov r11, #0xbb
    mov r12, #0xcc
    ldr r13, =stack_top  // C code would use stack for backing up registers

forever:

    mov r0, #1

    // Switch from ARM to Thumb2
    blx thumb_C_test   // branch to C code (Thumb2 mode)

    // Switch (?) from ARM to ARM
    blx arm_C_test  // The spec says blx always changes the instruction set.
                    // But, it does NOT. It seems that the compiler changes it to BL instruction
                    // since the pragma in C Code indicates the code is for ARM


    mov r1, r0     // expecting r0 = 0x5555_5555 according to the calling convention

    // Use either (a) 2 insts (ldr, blx) or (b) blx thumb_Assem_test
    // (a) Switch from ARM to Thumb2,
    //ldr r0,=thumb_Assem_test
    //blx r0

    // (b) Switch from ARM to Thumb2
    blx thumb_Assem_test  // branch to assembly code (Thumb2 mode)

    b forever

.thumb
.thumb_func
thumb_Assem_test:
    // If-Then conditional execution in Thumb2
    mov r0, #1
    mov r1, #2
    cmp r0, r1
    ittee  eq
    addeq  r0, #2
    addeq  r1, #2
    addne  r0, #4
    addne  r1, #4

    // ---- ittee eq  ---
    //cmpne r5, r5   // Try replacing 'addne r0, #4' with "cmpne r1 r1"
                     // It changes N,Z,C,V in CPSR. the next 'addne r1, #4' is then skipped.
                     // The question is why you want to do this?
    //addne  r0, #4
    // ------------------

    // want to see if compiler generate 16-bit code or mixed (thus thumb2)...
    sub   r1, r0
    add   r8, r1
    add.w  r8, r1
    add   r8, r1, #10

    push {lr}
    // Switch from Thumb2 to ARM
    // Check if LSB of r14 (lr) is set to 1 after blx.
    blx arm_C_test

    pop {lr}

    // to see if thumb2 has a dedicated register set
    // it turn out to be wrong... That is, ARM and Thumb share registers
    mov r0, #0x77
    mov r1, #0x66
    mov r2, #0x55
    mov r3, #0x44
    mov r4, #0x33
    mov r5, #0x22
    mov r6, #0x11
    mov r7, #0x00

    // To return back to ARM caller
    bx  lr


.data
.align 4

stack:     .space 1024
stack_top:
