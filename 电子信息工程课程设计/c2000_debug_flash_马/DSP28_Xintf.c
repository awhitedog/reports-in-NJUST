//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_Xintf.c
//
// TITLE:	DSP28 Device External Interface Init & Support Functions.
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  0.55| 06 May 2002 | L.H. | EzDSP Alpha Release
//  0.56| 20 May 2002 | L.H. | No change
//  0.57| 27 May 2002 | L.H. | No change
//###########################################################################

#include "DSP281x_Device.h"

//---------------------------------------------------------------------------
// InitXINTF: 
//---------------------------------------------------------------------------
// This function initializes the External Interface to a known state.
//
void InitXintf(void)
{

	#if  F2812
    // Example of chaning the timing of XINTF Zones.  
    // Note acutal values should be based on the hardware 
    // attached to the zone - timings presented here are 
    // for example purposes.
     
    // All Zones:
    // Timing for all zones based on XTIMCLK = SYSCLKOUT 
 //   XintfRegs.XINTCNF2.bit.XTIMCLK = 0x0000;
    XintfRegs.XTIMING1.bit.X2TIMING = 0;     //改动
    
    // Zone 0:
    // Change write access lead active trail timing
	// When using ready, ACTIVE must be 1 or greater
	// Lead must always be 1 or greater
	// Use timings based on SYSCLKOUT = XTIMCLK
	XintfRegs.XTIMING1.bit.XWRTRAIL = 1;       //改动
	XintfRegs.XTIMING1.bit.XWRACTIVE = 3;       //改动
	XintfRegs.XTIMING1.bit.XWRLEAD = 1;       //改动
	// Do not double lead/active/trail for Zone 0
//	XintfRegs.XTIMING0.bit.X2TIMING = 0;
	
	// Zone 2
	// Ignore XREADY for Zone 2 accesses
	// Change read access lead/active/trail timing

    // Zone 2 is slow, so add additional BCYC cycles when ever switching
    // from Zone 2 to another Zone.  This will help avoid
    // bus contention.
    XintfRegs.XINTCNF2.bit.XTIMCLK=0;     //改动
    XintfRegs.XINTCNF2.bit.CLKMODE=0;     //改动
//    XintfRegs.XBANK.bit.BANK = 7;
//    XintfRegs.XBANK.bit.BCYC = 1; 
	



	
	#endif
}	
	
//===========================================================================
// No more.
//===========================================================================
