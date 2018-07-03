.extern csd_vector

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

     mrc   p15, 0x0, r0, c1, c0, 2  // Read CP15 CPACR
     orr   r0, r0, #(0x0f<<20)      // Full access rights for CP10 and CP11
     mcr   p15, 0x0, r0, c1, c0, 2  // Write CP15 CPACR

     mov   r0, #0x40000000
     vmsr  fpexc, r0       // Write to enable NEON
     vmrs  r0, fpexc       // Read from Floating point exception control register

// Byte elements

     ldr   r1, =src1b
     ldr   r2, =src2b
     ldr   r3, =dst1b

     vld1.8  {d0}, [r1]!
     vld1.8  {d2}, [r2]!
     vadd.i8  d4, d0, d2
     vst1.8  {d4}, [r3]!

// Halfword elements

     ldr   r1, =src1hw
     ldr   r2, =src2hw
     ldr   r3, =dst1hw

     vld1.16   {q0}, [r1]!
     vld1.16   {q1}, [r2]!
     vadd.i16  q2, q0, q1
     vst1.16   {q2}, [r3]!

// Word elements

     ldr   r1, =src1w
     ldr   r2, =src2w
     ldr   r3, =dst1w

     vld1.32  {q0, q1}, [r1]!
     vld1.32  {q2, q3}, [r2]!
     vadd.i32  q4, q0, q2
     vadd.i32  q5, q1, q3
     vst1.32  {q4, q5}, [r3]!

// Saturation Mode (Q)

     ldr   r1, =src1sat
     ldr   r2, =src2sat
     ldr   r3, =dst1sat
     ldr   r4, =dst2sat

     vld1.32  {q0}, [r1]!
     vld1.32  {q1}, [r2]!
     vqadd.s32  q2, q0, q1
     vst1.32  {q2}, [r3]!

     vqadd.u32 q3, q0, q1
     vst1.32  {q3}, [r4]!

// Half Mode (H), Half Mode (H) & Rounding (R)

     ldr   r1, =src1half
     ldr   r2, =src2half
     ldr   r3, =dst1half
     ldr   r4, =dst2halfrounding

     vld1.8  {q0}, [r1]!
     vld1.8  {q1}, [r2]!
     vhadd.s8  q2, q0, q1
     vst1.8  {q2}, [r3]!

     vrhadd.s8  q3, q0, q1
     vst1.8  {q3}, [r4]!

// Narrow Shape (N)

     ldr   r1, =src1n
     ldr   r2, =src2n

     vld1.16  {q0}, [r1]!
     vld1.16  {q1}, [r2]!
     vaddhn.i16  d4, q0, q1

// Polynomial (P)
 
     ldr   r1, =src1p
     ldr   r2, =src2p
     ldr   r3, =dst1p

     vld1.8  {d0}, [r1]!
     vld1.8  {d2}, [r2]!
     vmull.p8  q2, d0, d2


// Single precision floating-point elements

     ldr   r1, =src1f
     ldr   r2, =src2f
     ldr   r3, =dst1f

     vld1.32  {q0}, [r1]!
     vld1.32  {q1}, [r2]!
     vadd.f32  q2, q0, q1
     vst1.32  {q2}, [r3]!

// GE[3:0] test in CPSR

     ldr  r1, =0x224488AA
     ldr  r0, =0x99999999

     usub8 r2, r1, r0
     sel   r2, r1, r0  // select the unsigned greater or equal of the corresponding bytes in r0 and r1
     sel   r3, r0, r1  // select the unsigned minimum of the corresponding bytes in r0 and r1

     ssub16 r2, r1, r0
     sel   r2, r0, r1  // select the signed minimum of the corresponding bytes in r0 and r1

// Q bit test in CPSR

     ldr  r1, =0x7fffffff
     mov  r2, #1
     qadd r3, r1, r2

     mrs	r4, cpsr			/* get the current PSR */
     mvn	r5, #1 << 27	/* To clear Q bit in CPSR */
     and	r5, r4, r5
     msr	cpsr, r5

     qsub r3, r1, r2

     ldr  r1, =0x80000000
     mov  r2, #1
     qsub r3, r1, r2


     bl csd_vector
     b .

.data
.align 4

src1b:
     .byte 1, 2, 3, 4, 5, 6, 7, 8
src2b:
     .byte 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
dst1b:
    .space 8 // allocate memory for 8 bytes


src1hw:
     .hword 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707, 0x0808
src2hw:
     .hword 0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888
dst1hw:
    .space 16 // allocate memory for 32 (2-byte x 8) bytes


src1w:
     .word 0x01010101, 0x02020202, 0x03030303, 0x04040404
     .word 0x05050505, 0x06060606, 0x07070707, 0x08080808
src2w:
     .word 0x11111111, 0x22222222, 0x33333333, 0x44444444
     .word 0x55555555, 0x66666666, 0x77777777, 0x88888888
dst1w:
    .space 32 // allocate memory for 32 (4-byte x 8) bytes
	 

src1sat:
     .word 0x0, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF
src2sat:
     .word 0x1, 0x1,        -0x1,       0x1
dst1sat:
    .space 16 // allocate memory for 16 (4-byte x 4) bytes
dst2sat:
    .space 16 // allocate memory for 16 (4-byte x 4) bytes


src1half:
     .byte 0x11, 0x22, 0x33, 0x44, 0xFF, 0xFE, 0xFD, 0xFC, 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0
src2half:
     .byte  0x1,  0x1,  0x2,  0x1,  0x1,  0x1,  0x1,  0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x2
dst1half:
    .space 16 // allocate memory for 16 (1-byte x 16) bytes
dst2halfrounding:
    .space 16 // allocate memory for 16 (1-byte x 16) bytes

src1n:
     .hword 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707, 0x0808
src2n:
     .hword 0x1122, 0x3344, 0x5566, 0x7788, 0x99AA, 0xBBCC, 0xDDEE, 0xFF00


src1p:
     .byte 0x83, 0xFF, 0x33, 0x44, 0xFF, 0xFE, 0xFD, 0xFC
src2p:
     .byte  0x3,  0x7,  0x3,  0x5,  0x9,  0xF,  0xE, 0x1C
dst1p:
    .space 8 // allocate memory for 8 (1-byte x 8) bytes


src1f:
     .word 0x3dcccccd, 0x3e4ccccd, 0x3e99999a, 0x3ecccccd // 0.1, 0.2, 0.3, 0.4
src2f:
     .word 0x3e4ccccd, 0x3e99999a, 0x3ecccccd, 0x3f000000 // 0.2, 0.3, 0.4, 0.5
dst1f:
    .space 16 // allocate memory for 32 (4-byte x 4) bytes
