/*-------------------------------------------------------------------------*/
/* This linker command file works for:                                     */
/* sim28 UNIX and PC, emu28 PC, and load28 (sim-based)                     */
/*-------------------------------------------------------------------------*/
-c
-stack 0x1000
-heap 0x800
-farheap 0x800

MEMORY
{
PAGE 0 : RESET(R):    origin = 0x000000, length =  0x00002
         VECTORS(R) : origin = 0x000002, length =  0x003FE
         PROG(R)    : origin = 0x3f0000, length =  0x10000
PAGE 1 : RAM1 (RW)  : origin = 0x000402 , length = 0x003FE
PAGE 1 : RAM2 (RW)  : origin = 0x001000 , length = 0x05000
PAGE 1 : RAM3 (RW)  : origin = 0x3e0000 , length = 0x08000
}
 
SECTIONS
{
         vectors : load = VECTORS, PAGE = 0
        .text    : load = PROG, PAGE = 0
        .data    : load = 440h, PAGE = 1
        .cinit   : > PROG, PAGE = 0
        .bss     : > RAM2, PAGE = 1
	.ebss    : > RAM3, PAGE = 1
	.econst  : > RAM3, PAGE = 1
	.const   : > RAM2, PAGE = 1
        .reset   : > RESET, PAGE = 0
	.stack   : > RAM2, PAGE = 1
	.sysmem  : > RAM2, PAGE = 1
	.esysmem : > RAM3, PAGE = 1
}
