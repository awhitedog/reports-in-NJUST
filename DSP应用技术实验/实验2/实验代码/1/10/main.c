/********************************************/
/*  C2000 DSP (SEED_DEC28335) 实验教学箱  		   */
//		信号发生程序
//  created: 2019.8.23
//  功能：计算数值赋值到RAM中，并DA输出
//

#include"DSP2833x_Device.h"
#include"DSP2833x_Examples.h"

#include "stdio.h"
#include"FPU.h"
#include"math.h"

#define	Pi	3.1415927
#define N	1024
#define T	0.00128
//#define B	800
#define K	39062

//RAML7      : origin = 0x00F000, length = 0x001000
volatile int *RamAddr = (volatile int *) 0x00F000;

//volatile int *zone7Addr = (volatile int *) 0x20FC10;

volatile Uint16  *Da_freq      = (Uint16 * )0x201100;
volatile Uint16  *Da_out       = (Uint16 * )0x200400;//DA1  示波器接 J5 DA OUTPUT1
volatile Uint16  *SPI_Reset   = (Uint16 * )0x202C00;

void init_zone7(void);

void init_mcbsp_spi(void);
void mcbsp_write(Uint8 send_data);
void init_AD9747(void);

void main()
{

	InitSysCtrl();

	InitMcbspaGpio();//

	DINT;                 //禁止 CPU中断，禁止全局中断
    InitPieCtrl();        //初始化PIE控制寄存器
    IER=0x0000;           //禁用所有CPU中断并清除CPU中断标志位
    IFR=0x0000;
    InitPieVectTable();   //初始化PIE向量表

    init_zone7();

    init_mcbsp_spi();
    init_AD9747();

    *Da_freq = 0x003D;   //配置DA频率，32数据，先写高16位，再写低16位
    *Da_freq = 0x0900;     //4000K 结果要除以10，400K

    //*Da_freq = 0x000F;   //配置DA频率，32数据，先写高16位，再写低16位
   // *Da_freq = 0x4240;     //1000K 结果要除以10，100K

    //*Da_freq = 0x001E;   //配置DA频率，32数据，先写高16位，再写低16位
   //*Da_freq = 0x8480;   //结果要除以10，200K
     //??可以省略？

    int i;


    for(i=0;i<1024;i++)
    {
		*(RamAddr+i) = (int)((cos(Pi*39062*(-0.0128+(0.0256/1024)*i)*(-0.0128+(0.0256/1024)*i))*4096));
    	//*(RamAddr+i) = (int)(((sin(2*Pi*i/1024))*2048));
    }
    //*zone7Addr = 66;

    while(1)
    {int freqK=1;
    	for(i=0;i<1024/freqK;i++)
    	{
    		//*Da_out = (unsigned int)((*(RamAddr+freqK*i))<<4)+ 0x8000;//左移4位
    		//*Da_out = (unsigned int)((*(RamAddr+freqK*i)<<3))+ 0x8000;//左移3位
    		*Da_out = (unsigned int)(((*(RamAddr+freqK*i)<<2))+ 0x8000);//左移2位
    		//*Da_out = (unsigned int)((*(RamAddr+freqK*i))<<3);
    	}
    }

}

void init_zone7(void)
{
	EALLOW;
	// Make sure the XINTF clock is enabled
	SysCtrlRegs.PCLKCR3.bit.XINTFENCLK = 1;
	EDIS;
	// Configure the GPIO for XINTF with a 16-bit data bus
	// This function is in DSP2833x_Xintf.c
	InitXintf16Gpio();

	// All Zones---------------------------------
	// Timing for all zones based on XTIMCLK = SYSCLKOUT
	EALLOW;
	XintfRegs.XINTCNF2.bit.XTIMCLK = 0;  //   XTIMCLK=SYSCLKOUT/1
	// Buffer up to 3 writes
	XintfRegs.XINTCNF2.bit.WRBUFF = 3;   //   写缓冲模式配置
	// XCLKOUT is enabled
	XintfRegs.XINTCNF2.bit.CLKOFF = 0;   //   XCLKOUT使能
	// XCLKOUT = XTIMCLK
	XintfRegs.XINTCNF2.bit.CLKMODE = 0;  //   XCLKOUT=XTIMCLK

    // zone7 配置-------------------------------------
	// When using ready, ACTIVE must be 1 or greater
    // Lead must always be 1 or greater
    // Zone write timing
    XintfRegs.XTIMING7.bit.XWRLEAD = 2;   //写周期各阶段时序配置  8个时钟周期
    XintfRegs.XTIMING7.bit.XWRACTIVE = 4;
    XintfRegs.XTIMING7.bit.XWRTRAIL = 2;
    // Zone read timing
    XintfRegs.XTIMING7.bit.XRDLEAD = 1;   //读周期各阶段时序配置 7个时钟周期
    XintfRegs.XTIMING7.bit.XRDACTIVE = 5;
    XintfRegs.XTIMING7.bit.XRDTRAIL = 1;

    // don't double all Zone read/write lead/active/trail timing
    XintfRegs.XTIMING7.bit.X2TIMING = 0;

    // Zone will not sample XREADY signal
    XintfRegs.XTIMING7.bit.USEREADY = 0;    //不采样XREADY信号
    XintfRegs.XTIMING7.bit.READYMODE = 0;

    // 1,1 = x16 data bus
    // 0,1 = x32 data bus
    // other values are reserved
    XintfRegs.XTIMING7.bit.XSIZE = 3;   //使用16位数据线
    EDIS;
    //Force a pipeline flush to ensure that the write to
    //the last register configured occurs before returning.
    asm(" RPT #7 || NOP");
}

void init_mcbsp_spi()
{
    // McBSP-A register settings
    McbspaRegs.SPCR2.all=0x0000;		 // Reset FS generator, sample rate generator & transmitter
	McbspaRegs.SPCR1.all=0x0000;		 // Reset Receiver, Right justify word, Digital loopback dis.
    McbspaRegs.PCR.all=0x0F08;           //(CLKXM=CLKRM=FSXM=FSRM= 1, FSXP = 1)
    //McbspaRegs.SPCR1.bit.DLB = 0;        //数字循环模式，自收自发

    McbspaRegs.SPCR1.bit.CLKSTP = 2;     //Clock stop mode, without clock delay

	McbspaRegs.PCR.bit.CLKXP = 1;		 //0: Transmit data is sampled on the rising edge of CLKX.
	McbspaRegs.PCR.bit.CLKRP = 1;        //0: Receive data is sampled on the falling edge of MCLKR.

    McbspaRegs.RCR2.bit.RDATDLY=01;      // FSX setup time 1 in master mode. 0 for slave mode (Receive)
    McbspaRegs.XCR2.bit.XDATDLY=01;      // FSX setup time 1 in master mode. 0 for slave mode (Transmit)

    McbspaRegs.XCR1.bit.XFRLEN1=0;
    McbspaRegs.XCR2.bit.XPHASE=0;
    //McbspaRegs.XCR2.bit.XFRLEN2=0;
    //McbspaRegs.XCR2.bit.XWDLEN2=0;

    McbspaRegs.RCR1.bit.RFRLEN1=0;
    McbspaRegs.RCR2.bit.RPHASE=0;

//------
	McbspaRegs.RCR1.bit.RWDLEN1=2;       // 16-bit word
    McbspaRegs.XCR1.bit.XWDLEN1=2;       // 16-bit word

// Sample Rate Generator Registers
    McbspaRegs.SRGR2.all=0x2000; 	 	 // CLKSM=1, FPER = 1 CLKG periods
    McbspaRegs.SRGR1.all=0x000F;	     // Frame Width = 1 CLKG period, CLKGDV=16

    McbspaRegs.SPCR2.bit.GRST=1;         // Enable the sample rate generator
	delay_loop();                        // Wait at least 2 SRG clock cycles
	McbspaRegs.SPCR2.bit.XRST=1;         // Release TX from Reset
	McbspaRegs.SPCR1.bit.RRST=1;         // Release RX from Reset
    McbspaRegs.SPCR2.bit.FRST=1;         // Frame Sync Generator reset

}

void mcbsp_write(Uint8 send_data)        //SPI数据发送函数
{
	while( McbspaRegs.SPCR2.bit.XRDY == 0 ) {} ;
	McbspaRegs.DXR1.all=send_data;
}

/***********************AD9747工作模式配置函数**************************/
void init_AD9747(void)
{
	*SPI_Reset = 1 ;
	DELAY_US(100);
	*SPI_Reset = 0 ;

	mcbsp_write(0x0020);
	DELAY_US(10);
	mcbsp_write(0x0000);
	DELAY_US(10);
	mcbsp_write(0x02C0);
	DELAY_US(10);
	mcbsp_write(0x0300);
	DELAY_US(10);
	mcbsp_write(0x0A00);
	DELAY_US(10);
	mcbsp_write(0x0B3D);
	DELAY_US(10);
	mcbsp_write(0x0C00);
	DELAY_US(10);
	mcbsp_write(0x0D00);
	DELAY_US(10);
	mcbsp_write(0x0E00);
	DELAY_US(10);
	mcbsp_write(0x0F3D);
	DELAY_US(10);
	mcbsp_write(0x1000);
	DELAY_US(10);
	mcbsp_write(0x1100);
	DELAY_US(10);
	mcbsp_write(0x1200);
	DELAY_US(10);

}
