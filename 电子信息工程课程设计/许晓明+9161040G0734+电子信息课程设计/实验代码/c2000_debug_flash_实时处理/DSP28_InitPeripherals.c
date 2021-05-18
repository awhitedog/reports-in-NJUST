//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_InitPeripherals.c
//
// TITLE:	DSP28 Device Initialization To Default State.
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  0.55| 06 May 2002 | S.S. | EzDSP Alpha Release
//  0.56| 20 May 2002 | L.H. | No change
//  0.57| 27 May 2002 | L.H. | No change
//###########################################################################

#include "DSP281x_Device.h"

//---------------------------------------------------------------------------
// InitPeripherals:
//---------------------------------------------------------------------------
// The following function initializes the peripherals to a default state.
// It calls each of the peripherals default initialization functions.
// This function should be executed at boot time or on a soft reset.
//
void InitPeripherals(void)
{

    #if F2812
    // Initialize External Interface To default State:
	InitXintf();
	#endif

	// Initialize CPU Timers To default State:
//	InitCpuTimers();

	// Initialize McBSP Peripheral To default State:
//	InitMcbsp();

	// Initialize Event Manager Peripheral To default State:
//	InitEv();
	
    // Initialize ADC Peripheral To default State:
//	InitAdc();
	
	// Initialize eCAN Peripheral To default State:
//  InitECan();

	// Initialize SPI Peripherals To default State:
//	InitSpi();

	// Initialize SCI Peripherals To default State:
//	InitSci();
}

//===========================================================================
// No more.
//===========================================================================
