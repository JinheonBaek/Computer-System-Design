
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

    blx arm_C_test		// arm_sorting		(arm mode)

    blx thumb_C_test	// thumb_sorting	(thumb mode)

	b main				// Loop

.data
.align 4
