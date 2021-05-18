/*
 *  Copyright (c) 2001-2002, Texas Instruments Incorporated.
 *  All rights reserved. Property of Texas Instruments Incorporated.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.
*/

/*
 * Description: This application uses Probe Points to obtain input
 * (a sine wave). It then takes this signal, and applies a gain
 * factor to it.
*/

/********************************************/
/*  C2000 DSP (DEC28335) 实验教学箱  		   */
//		DSP开发基础
//  created: 2019.8.21
//

#include"DSP2833x_Device.h"
#include"DSP2833x_Examples.h"

#include "stdio.h"
#include "sine.h"
#include"FPU.h"

// gain control variable
int gain = INITIALGAIN;



// declare and initalize a IO buffer
BufferContents currentBuffer;

// Define some functions
static void processing();						// process the input and generate output
static void dataIO();							// dummy function to be used with ProbePoint

void main()
{

	InitSysCtrl();
	DINT;                 //禁止 CPU中断，禁止全局中断
    InitPieCtrl();        //初始化PIE控制寄存器
    IER=0x0000;           //禁用所有CPU中断并清除CPU中断标志位
    IFR=0x0000;
    InitPieVectTable();   //初始化PIE向量表

    printf("SineWave example started\n");

    while(TRUE) // loop forever
    {
        /*  Read input data using a probe-point connected to a host file.
            Write output data to a graph connected through a probe-point. */
        dataIO();

        /* Apply the gain to the input to obtain the output */
        processing();

        asm (" ESTOP0");            // 断点
    }
}

/*
 * FUNCTION:		Apply signal processing transform to input signal
 *			 		to generate output signal
 * PARAMETERS: 		BufferContents struct containing input/output arrays of size BUFFSIZE
 * RETURN VALUE: 	none.
 */
static void processing()
{
    int size = BUFFSIZE;

    while(size--){
        currentBuffer.output[size] = currentBuffer.input[size] * gain;	// apply gain to input
    }
}

/*
 * FUNCTION: 		Read input signal and write processed output signal
 *					using ProbePoints
 * PARAMETERS: none.
 * RETURN VALUE: none.
 */
static void dataIO()
{
    /* do data I/O */
    return;
}

