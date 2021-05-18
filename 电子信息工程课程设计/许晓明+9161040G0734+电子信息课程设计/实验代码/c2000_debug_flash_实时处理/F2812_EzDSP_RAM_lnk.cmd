/*
//###########################################################################
//
// FILE:    F2812_EzDSP_RAM_lnk.cmd
//
// TITLE:   Linker Command File For F2812 eZdsp examples that run out of RAM
//          This linker file assumes the user is booting up in Jump to H0 mode
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  1.00| 11 Sep 2003 | L.H. | Changes since previous version (v.58 Alpha)
//      |             |      | Added BEGIN section to the start of H0
//      |             |      | Removed .bss, .const and .sysmem
//      |             |      |    These are for a small memory model.  All examples
//      |             |      |    use the large model.
//      |             |      | Added .esysmem section
//      |             |      | Changed ramfuncs section to load and run from RAM
//      |             |      |    (previously this was type DSECT)
//      |             |      | Moved peripheral register files to DSP28_Headers_BIOS.cmd
//      |             |      |    and DSP28_Headers_nonBIOS.cmd
//      |             |      | Added CSM_RSVD memory section in FLASHA - this region
//      |             |      |    should be programmed with all 0x0000 when using the CSM
// -----|-------------|------|-----------------------------------------------
//###########################################################################
*/

/* ======================================================
// For Code Composer Studio V2.2 and later
// ---------------------------------------
// In addition to this memory linker command file, 
// add the header linker command file directly to the project. 
// The header linker command file is required to link the
// peripheral structures to the proper locations within 
// the memory map.
//
// The header linker files are found in <base>\DSP281x_Headers\cmd
//   
// For BIOS applications add:      DSP281x_Headers_nonBIOS.cmd
// For nonBIOS applications add:   DSP281x_Headers_nonBIOS.cmd    
========================================================= */

/* ======================================================
// For Code Composer Studio prior to V2.2
// --------------------------------------
// 1) Use one of the following -l statements to include the 
// header linker command file in the project. The header linker
// file is required to link the peripheral structures to the proper 
// locations within the memory map                                    */

/* Uncomment this line to include file only for non-BIOS applications */
/* -l DSP281x_Headers_nonBIOS.cmd */

/* Uncomment this line to include file only for BIOS applications */
/* -l DSP281x_Headers_BIOS.cmd */

/* 2) In your project add the path to <base>\DSP281x_headers\cmd to the
   library search path under project->build options, linker tab, 
   library search path (-i).
/*========================================================= */



MEMORY
{
PAGE 0:    /* Program Memory */
           /* Memory (RAM/FLASH/OTP) blocks can be moved to PAGE1 for data allocation */

   ZONE0       : origin = 0x002000, length = 0x002000     /* XINTF zone 0 */
   ZONE1       : origin = 0x004000, length = 0x002000     /* XINTF zone 1 */

   ZONE6       : origin = 0x100000, length = 0x080000     /* XINTF zone 6 */
   OTP         : origin = 0x3D7800, length = 0x000800     /* on-chip OTP */

     FLASHA      : ORIGIN = 0x003E8000, LENGTH =0x0FF00     /* on-chip FLASH */
   CSM_RSVD    : origin = 0x3F7F80, length = 0x000076     /* Part of FLASHA.  Program with all 0x0000 when CSM is in use. */
   BEGIN       : origin = 0x3F7FF6, length = 0x000002     /* Part of FLASHA.  Used for "boot to Flash" bootloader mode. */
   CSM_PWL     : origin = 0x3F7FF8, length = 0x000008     /* Part of FLASHA.  CSM password locations in FLASHA */
   
/* ZONE7       : origin = 0x3FC000, length = 0x003FC0     /* XINTF zone 7 available if MP/MCn=1 */ 
   ROM         : origin = 0x3FF000, length = 0x000FC0     /* Boot ROM available if MP/MCn=0 */
   RESET       : origin = 0x3FFFC0, length = 0x000002     /* part of boot ROM (MP/MCn=0) or XINTF zone 7 (MP/MCn=1) */
   VECTORS     : origin = 0x3FFFC2, length = 0x00003E     /* part of boot ROM (MP/MCn=0) or XINTF zone 7 (MP/MCn=1) */

PAGE 1 :   /* Data Memory */
           /* Memory (RAM/FLASH/OTP) blocks can be moved to PAGE0 for program allocation */
           /* Registers remain on PAGE1                                                  */

   RAMM0       : origin = 0x000000, length = 0x000400     /* on-chip RAM block M0 */
   RAMM1       : origin = 0x000400, length = 0x000400     /* on-chip RAM block M1 */
   RAML0L1       : origin = 0x008000, length = 0x002000     /* on-chip RAM block L1 */
   RAMH0       : origin = 0x3F8000, length = 0x002000     /* on-chip RAM block H0 */

	SRAM0 : origin = 0x100000, length = 0x10000
    SRAM1 : origin = 0x0110000, length = 0x800  
}
 
 
SECTIONS
{
  /* Allocate program areas: */
   .cinit              : > FLASHA      PAGE = 0
   .pinit              : > FLASHA,     PAGE = 0
   .text               : > FLASHA      PAGE = 0
   codestart           : > BEGIN       PAGE = 0
   ramfuncs            :> FLASHA      PAGE = 0
   csmpasswds          : > CSM_PWL     PAGE = 0
   csm_rsvd            : > CSM_RSVD    PAGE = 0
   
   /* Allocate uninitalized data sections: */
   .stack              : > RAMM0       PAGE = 1
   .ebss               : > RAML0L1       PAGE = 1
   .esysmem            : > RAMH0       PAGE = 1

   /* Initalized sections go in Flash */
   /* For SDFlash to program these, they must be allocated to page 0 */
   .econst             : > FLASHA      PAGE = 0
   .switch             : > FLASHA      PAGE = 0      

   /* Allocate IQ math areas: */
   IQmath              : > FLASHA     PAGE = 0                  /* Math Code */
   IQmathTables        : > ROM         PAGE = 0, TYPE = NOLOAD   /* Math Tables In ROM */

   /* .reset is a standard section used by the compiler.  It contains the */ 
   /* the address of the start of _c_int00 for C Code.   /*
   /* When using the boot ROM this section and the CPU vector */
   /* table is not needed.  Thus the default type is set here to  */
   /* DSECT  */ 
   .reset              : > RESET,      PAGE = 0, TYPE = DSECT
   vectors             : > VECTORS     PAGE = 0, TYPE = DSECT



 SINTBL	: > FLASHA,   PAGE = 0
 FFTtf	>	FLASHA, 	 PAGE 0 
 FFTmag   >	    RAML0L1,	PAGE 1  

   .const   : > RAML0L1, PAGE = 1
   .bss     : > RAML0L1, PAGE = 1
   DLOG	 	: >	RAML0L1	, PAGE =	1
   FFTipcb	ALIGN(2048)  : { } >    RAML0L1 PAGE 1
   
   fftout0  : > SRAM0, PAGE=1
   fftout1  : > SRAM1, PAGE=1
   iirfilt	: >	RAML0L1	 PAGE = 1
   firldb   align(0x100)> RAML0L1	 PAGE = 1
   firfilt	: >	RAML0L1	 PAGE = 1
   newsect  : > SRAM0,   PAGE=1
   usbdata  : > SRAM0,   PAGE=1  
}
