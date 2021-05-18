//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_XIntrupt.c
//
// TITLE:	DSP28 External Interrupt Initalization & Support Functions.
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
// InitXIntrupt: 
//---------------------------------------------------------------------------
// This function initializes external interrupts to a known state.
//
void InitXIntrupt(void)
{
	XIntruptRegs.XINT2CR.bit.ENABLE=1;
	XIntruptRegs.XINT2CR.bit.POLARITY=0;
}	

//===========================================================================
// No more.
//===========================================================================
