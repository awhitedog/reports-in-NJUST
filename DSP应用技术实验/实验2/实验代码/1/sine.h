/*
 *  Copyright (c) 2001-2002, Texas Instruments Incorporated.
 *  All rights reserved. Property of Texas Instruments Incorporated.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.
*/

/*
 *  Description: This application uses ProbePoints to obtain input
 *  (a sine wave). It then takes this signal, and applies a gain
 *  factor to it.
*/

// define boolean TRUE
#ifndef TRUE
#define TRUE 1
#endif

// buffer constants 
#define BUFFSIZE 128
#define INITIALGAIN -4

// IO buffer structure
typedef struct IOBuffer {				
	int input[BUFFSIZE]; 			
	int output[BUFFSIZE];	
} BufferContents;

                  	
