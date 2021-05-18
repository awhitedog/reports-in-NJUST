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
PAGE 0 :
   /* For this example, H0 is split between PAGE 0 and PAGE 1 */  
   /* BEGIN is used for the "boot to HO" bootloader mode      */
   /* RESET is loaded with the reset vector only if           */
   /* the boot is from XINTF Zone 7.  Otherwise reset vector  */
   /* is fetched from boot ROM. See .reset section below      */
   
   RAMM0      : origin = 0x000000, length = 0x000400
   BEGIN      : origin = 0x3F8000, length = 0x000002             
   PRAMH0     : origin = 0x3F8002, length = 0x001FFE
   RESET      : origin = 0x3FFFC0, length = 0x000002           
   PAGE 0 : VECS(R)     : origin = 0x3FFFC2, length = 0x3E
   PAGE 0 : KKRAM:  origin = 0x100000, length = 0x9000    
PAGE 1 : 

   /* For this example, H0 is split between PAGE 0 and PAGE 1 */

   RAMM1    : origin = 0x000400, length = 0x000400
/*   DRAMH0   : origin = 0x3f9102, length = 0x000EFE */
  /* SHUZU	: origin = 0x3FF000, length = 0x001000*/
   PAGE 1 : M0RAM(RW)   : origin = 0x000000, length = 0x400
   PAGE 1 : L0L1RAM : origin = 0x008000, length = 0x2000   
   PAGE 1 : SRAM0 : origin = 0x080000, length = 0x800
   PAGE 1 : SRAM1 : origin = 0x080800, length = 0x800 
  
}
 
 
SECTIONS
{
   /* Setup for "boot to H0" mode: 
      The codestart section (found in DSP28_CodeStartBranch.asm)
      re-directs execution to the start of user code.  
      Place this section at the start of H0  */

   codestart        : > BEGIN,       PAGE = 0
   ramfuncs         : > PRAMH0       PAGE = 0  
   .text            : > PRAMH0,      PAGE = 0
   .cinit           : > L0L1RAM,      PAGE = 1
   .pinit           : > PRAMH0,      PAGE = 0
   .switch          : > RAMM0,       PAGE = 0
   .reset           : > RESET,       PAGE = 0, TYPE = DSECT 
 SINTBL	: > PRAMH0,   PAGE = 0
FFTtf	>	KKRAM, 	 PAGE 0 
 FFTmag   >	    L0L1RAM,	PAGE 1  
/* not used, */
   vectors : > VECS, 	 PAGE = 0
   
   .stack           : > RAMM1,       PAGE = 1
   .ebss            : > KKRAM,      PAGE = 0
   .econst          : > KKRAM,      PAGE = 0      
   .esysmem         : > KKRAM,      PAGE = 0
   .sysmem  : > M0RAM, 	 PAGE = 1
   .const   : > L0L1RAM, PAGE = 1
   .bss     : > L0L1RAM, PAGE = 1
   DLOG	 	: >	L0L1RAM	, PAGE =	1
   FFTipcb	ALIGN(4096)  : { } >    L0L1RAM PAGE 1
   
   fftout0  : > SRAM0, PAGE=1
   fftout1  : > SRAM1, PAGE=1
   iirfilt	: >	KKRAM	 PAGE = 0
   firldb   align(0x100)> L0L1RAM	 PAGE = 1
   firfilt	: >	KKRAM	 PAGE=0  
   newsect  : > KKRAM,   PAGE=0
   usbdata  : > KKRAM,   PAGE=0

}


