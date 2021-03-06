// Figure 2. (Page Table #1)
.globl  csd_MMUTable_lv2
.section .csd_mmu_tbl_lv2,"a"

csd_MMUTable_lv2:
.set	PAGE, 0x400000
.word	PAGE + 0x2
.set	PAGE, 0x401000
.word	PAGE + 0x2
.set	PAGE, 0x402000
.word	PAGE + 0x2

.globl  csd_MMUTable
.section .csd_mmu_tbl,"a"

csd_MMUTable:
	/* Each table entry occupies one 32-bit word and there are
	 * 4096 entries, so the entire table takes up 16KB.
	 * Each entry covers a 1MB section.
	 *
	 * The following defines only 3 1MB sections
	 *     1st 1MB: 0x0000_0000 (VA) -> 0x0000_0000 (PA)
	 *     2nd 1MB: 0x0010_0000 (VA) -> 0x0020_0000 (PA)
	 *     3rd 1MB: 0x0020_0000 (VA) -> 0x0040_0000 (PA)
	 */
.set	SECT, 0
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, 0x100000
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, 0x400000
.word	csd_MMUTable_lv2 + 0x1e1


// Figure 3. (Page Table #2)
.globl  csd_MMUTable2_lv2
.section .csd_mmu_tb2_lv2,"a"

csd_MMUTable2_lv2:
.set	PAGE, 0x400000
.word	PAGE + 0x2
.set	PAGE, 0x402000
.word	PAGE + 0x2
.set	PAGE, 0x400000
.word	PAGE + 0x2

.globl  csd_MMUTable2
.section .csd_mmu_tb2,"a"

csd_MMUTable2:
	/* Each table entry occupies one 32-bit word and there are
	 * 4096 entries, so the entire table takes up 16KB.
	 * Each entry covers a 1MB section.
	 *
	 * The following defines only 3 1MB sections
	 *     1st 1MB: 0x0000_0000 (VA) -> 0x0000_0000 (PA)
	 *     2nd 1MB: 0x0010_0000 (VA) -> 0x0020_0000 (PA)
	 *     3rd 1MB: 0x0020_0000 (VA) -> 0x0040_0000 (PA)
	 */
.set	SECT, 0
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, 0x100000
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, 0x400000
.word	csd_MMUTable2_lv2 + 0x1e1
