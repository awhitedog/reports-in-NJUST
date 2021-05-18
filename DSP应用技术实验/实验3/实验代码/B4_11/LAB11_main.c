//AD_epwm_da1

//epwm触发AD，用无缓存DA1输出成功

//信号源  freq 1kHz ampl 1V offset 500mV 20190823
//fs=20kHz

#include "DSP2833x_Device.h"     // DSP2833x Headerfile Include File
#include "DSP2833x_Examples.h"   // DSP2833x Examples Include File

// ADC start parameters
#if (CPU_FRQ_150MHZ)     // Default - 150 MHz SYSCLKOUT
  #define ADC_MODCLK 0x3 // HSPCLK = SYSCLKOUT/2*ADC_MODCLK = 150/(2*3) = 25 MHz
#endif
#if (CPU_FRQ_100MHZ)
  #define ADC_MODCLK 0x2 // HSPCLK = SYSCLKOUT/2*ADC_MODCLK = 100/(2*2) = 25 MHz
#endif

#define BUF_SIZE 1024

volatile Uint16  *Da_freq      = (Uint16 * )0x201100;
volatile Uint16  *Da_out       = (Uint16 * )0x200400;

volatile Uint16  *SPI_Reset   = (Uint16 * )0x202C00;

int i=0;                   //写给DA的数据



Uint16 SampleTable1[BUF_SIZE]={0};

Uint16 ConvCount=0;

void init_zone7(void);

void init_mcbsp_spi(void);
void mcbsp_write(Uint8 send_data);
void init_AD9747(void);

void InitAdcParameters(void);
void InitEPwm1Parameters(void);

interrupt void epwm1_timer_adc_isr(void);

int xn,yn;   //AD采集和DA输出数据

void main(void)
{
   InitSysCtrl();
   InitMcbspaGpio();
   DINT;                 //禁止 CPU中断，禁止全局中断
   InitPieCtrl();        //初始化PIE控制寄存器
   IER=0x0000;           //禁用所有CPU中断并清除CPU中断标志位
   IFR=0x0000;
   InitPieVectTable();   //初始化PIE向量表    里面包含了     PieCtrlRegs.PIECTRL.bit.ENPIE=1

   EALLOW;
   PieVectTable.SEQ1INT =&epwm1_timer_adc_isr;  //第一组第三中断
   EDIS;

   InitAdcParameters();
   InitEPwm1Parameters();

   PieCtrlRegs.PIEIER1.bit.INTx1 = 1;  // Enable SEQ1INT interrupt in PIE 
   PieCtrlRegs.PIECTRL.bit.ENPIE=1;  //打开PIE中断,使能PIE
   IER |= M_INT1;      //打开CPU第1组中断

   EINT;      //使能全局中断，允许中断响应
   ERTM;

   init_zone7();     //初始化地址空间zone7

   init_mcbsp_spi();
   init_AD9747();

   	//*Da_freq = 0x0007;   //配置DA频率，32数据，先写高16位，再写低16位
   //	*Da_freq = 0xA120;   //50K
   *Da_freq = 0x001E;   //配置DA频率，32数据，先写高16位，再写低16位
   *Da_freq = 0x8480;   //结果要除以10，200K

    while(1);
}
//主函数结束

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
		//data control register//////////////////////////////////////////
		mcbsp_write(0x02C0);
		DELAY_US(10);
		///////////////////////////////////////////
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

		/*
		 * 采样频率的计算:T(PWM1)=TBCLK/(TBPRD*2*3)=25/(208*3*2) = 0.02MHz , 20KHz
		 * 其中, TBCLK = SYSCLKOUT / (HSPCLKDIV*CLKDIV)=150/(6*1)=25MHz
		 * TBPRD乘以2: EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN,即设置的上升下降模式
		 * TBPRD乘以3: EPwm1Regs.ETPS.bit.INTPRD = ET_3RD,即每三次事件产生一次采样中断
		 * 可修改TBPRD的值以改变采样频率
		 *
		 * */

void InitAdcParameters(void)
{
// Specific clock setting
    EALLOW;
    SysCtrlRegs.HISPCP.all = ADC_MODCLK;
    EDIS;

    InitAdc();

    AdcRegs.ADCTRL1.bit.RESET=1;     // Reset ADC  复位ADC
    DELAY_US(10000);

    AdcRegs.ADCTRL1.bit.RESET=0;      // Do not Reset ADC

    AdcRegs.ADCTRL1.bit.SUSMOD=0;       //Ignore Emulation Suspend, Forward Running  //忽略仿真器悬挂模式    遇到断点，ADC模块继续

    AdcRegs.ADCTRL3.bit.ADCCLKPS=1;
    AdcRegs.ADCTRL1.bit.CPS=1;             // F_ADCCLK=F_HSPCLK/(2*ADCCLKPS*(CPS + 1))=25/(2*1*(1+1))=6.25MHz

    AdcRegs.ADCTRL1.bit.ACQ_PS=5;          // Pulse Width of ADC Width=(ADCCLK*(ACQ_PS+1))=0.96us

    AdcRegs.ADCTRL1.bit.CONT_RUN=0;  //---- ADC Run at Continuous Conversion Mode//连续转换模式      当接收到EOS信号后，排序器的动作依赖于SEQ-OVRD，如果它等于0，则排序器回到起始状态CONV00；如果它等于1，排序器从当前开始，不要复位
    AdcRegs.ADCTRL1.bit.SEQ_CASC=1;  //---- ADC SEQ at Cascaded Mode  工作于级联模式

    AdcRegs.ADCTRL3.bit.ADCBGRFDN=3;  // 带隙和参考源电路上电The Bandgap and Reference Circuitry is Powered up
    DELAY_US(10);

    AdcRegs.ADCTRL3.bit.ADCPWDN=1;       //其他上电    // The analog circuitry inside the core is powered up
    DELAY_US(10);

    AdcRegs.ADCTRL3.bit.SMODE_SEL=0;   // Sequenced sampling mode   顺序采样

	AdcRegs.ADCMAXCONV.all=1;         //ConversionCount---------最大转换通道+1=2个
    AdcRegs.ADCCHSELSEQ1.bit.CONV00 = 0x0;
    AdcRegs.ADCCHSELSEQ1.bit.CONV01 = 0x1;

// Interrupt clear bit.Clears the SEQ1 interrupt flag bit, INT_SEQ1.
    AdcRegs.ADCST.bit.INT_SEQ1_CLR=1;          //清除SEQ1中断标志位
// Restart SEQ1
   AdcRegs.ADCTRL2.bit.RST_SEQ1=0;             //--------无效，不能复位排序器   写1就是复位排序器
// Interrupt request by INT_SEQ1 is disabled
    AdcRegs.ADCTRL2.bit.INT_ENA_SEQ1=1;      //--------INT-SEQ1对CPU的中断请求被使能
// INT_SEQ1 is set at the end of every SEQ1 sequence.
    AdcRegs.ADCTRL2.bit.INT_MOD_SEQ1=0;    //每个SEQ1序列结束时，INT-SEQ1置位，置位就是赋值为1
// EPWM SOCA enable bit for SEQ1
    AdcRegs.ADCTRL2.bit.EPWM_SOCA_SEQ1=1;   //允许epwm_SOCA触发SEQ1
// External signal start-of-conversion bit for SEQ1, No Action
    AdcRegs.ADCTRL2.bit.EXT_SOC_SEQ1=0;  //SEQ1外部启动转换无效

}

void InitEPwm1Parameters(void)
{
//   InitEPwm1Gpio();

// Disable TBCLK within the ePWM
   EALLOW;
   SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0; //停止epwm模块内部的时间基准时钟
   EDIS;

// High Speed Time-base Clock Prescale Bits,These bits determine part of the time-base clock prescale
// TBCLK = SYSCLKOUT / (HSPCLKDIV*CLKDIV)=150/(6*1)=25
   EPwm1Regs.TBCTL.bit.HSPCLKDIV =0x03;        //高速时间基准时钟预分频位                     两倍
   EPwm1Regs.TBCTL.bit.CLKDIV = 0x00;          //时间基准时钟预分频位 等于0即1分频

// Set Period for EPWM1
   EPwm1Regs.TBPRD = 139;    //设定时间基准器计数器的周期       208-fs 20kHz,139-fs 30kHz  149--27.9kHz T(PWM1)=TBCLK/(TBPRD*2*3)=25/(208*3*2) = 0.02MHz , 20KHz
   EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN;  //增减计数模式
// Setup Compare A = 2 TBCLK counts
   EPwm1Regs.CMPA.half.CMPA = 2;   //计数比较寄存器A CMPA   当前工作的CMPA的值不断和时间基准计数器TBCTR比较
// Phase is 0 for Synchronization Event
   EPwm1Regs.TBPHS.half.TBPHS = 0x0000;     //TBCTR不装载相位寄存器TBPHS的值
// Clear  TB counter
   EPwm1Regs.TBCTR = 0x0000;   //事件基准计数寄存器TBCTR   读取写到其中的TBCTR的值    清除

// Phase loading disabled
   EPwm1Regs.TBCTL.bit.PHSEN = TB_DISABLE;//禁止TBCTR对TBPHS的装载
// Enable the TBCTL Shadow
   EPwm1Regs.TBCTL.bit.PRDLD = TB_SHADOW;//TBCTR装载其映射寄存器的值
// Disable EPWMxSYNCO signal
   EPwm1Regs.TBCTL.bit.SYNCOSEL = TB_SYNC_DISABLE; //禁用EPWMxSYNCO signal
// CMPA Register operating mode, 0 means operates as a double buffer, all writes via the CUP access the shadow register
   EPwm1Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;//映射模式，双缓冲模式，所有CPU写操作将访问映射寄存器
// Active CMPA Load From Shadow Select Mode when CTR=0
   EPwm1Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;  // load on CTR = Zero

// Set actions
// Force EPWMA output high when the counter equals the active CMPA register and the counter is incrementing
   EPwm1Regs.AQCTLA.bit.CAU = AQ_SET;//计数递增    强制ePWMxA输出高
// Force EPWMA output low Action when the counter equals the active CMPA register and the counter is decrementing
   EPwm1Regs.AQCTLA.bit.CAD = AQ_CLEAR;//计数递减    强制ePWMxA输出低

// Dead-Band Generator Rising Edge Delay Count Register=0
//   EPwm1Regs.DBRED=0;
// Dead-Band Generator Falling Edge Delay Count Register=0
//   EPwm1Regs.DBFED=0;

// Enable ADC Start of SOCA Pulse
   EPwm1Regs.ETSEL.bit.SOCAEN = 1;     //使能ePWMxSOCA脉冲
// Select SOC from CPMA on upcount
   EPwm1Regs.ETSEL.bit.SOCASEL = 2;     //TBCTR=TBPRD时产生ePWMxSOCA
// Select how many selected ETSEL events need to occur before an EPWMxSOCA pulse is generated;//在第三个事件产生ePWMxSOCA脉冲
   EPwm1Regs.ETPS.bit.SOCAPRD = 3;

// Enable event time-base counter equal to period (TBCTR = TBPRD)
   EPwm1Regs.ETSEL.bit.INTSEL = ET_CTR_PRD; // TBCTR=TBPRD时产生ePWMxSOCA
// Enable EPWMx_INT generation
   EPwm1Regs.ETSEL.bit.INTEN = 0;           //禁止ePWMx_INT产生
// These bits determine how many selected ETSEL[INTSEL] events need to occur before an interrupt is generated.
   EPwm1Regs.ETPS.bit.INTPRD = ET_3RD;      //在第三个事件产生中断

// Enable TBCLK within the ePWM
   EALLOW;
   SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
   EDIS;
}
unsigned int property=10000;
interrupt void epwm1_timer_adc_isr(void)    //中断函数
{


//DA
	xn= (AdcRegs.ADCRESULT1 & 0xFFF0);
	 if(ConvCount<1024)
	{
		SampleTable1[ConvCount]=xn;
		ConvCount++;
	}
	else
	{
		ConvCount=0;
	}
	*Da_out= xn ;
	 //*Da_out=property;
	 //property=10000-property;
 // *Da_out=AdcRegs.ADCRESULT1;


// Reinitialize for the next ADC Sequence
// Reset SEQ1
   AdcRegs.ADCTRL2.bit.RST_SEQ1 = 1;       //复位SEQ1
// Clear INT SEQ1 bit
// EPwm1Regs.ETCLR.bit.INT = 1;           //清除中断标志位
  // 清除SEQ1中断标志位 
   AdcRegs.ADCST.bit.INT_SEQ1_CLR = 1;
// Acknowledge interrupt to PIE
   PieCtrlRegs.PIEACK.all = PIEACK_GROUP1; //PIEACK-PIE ackonwledge register   //中断应答


   return;
}

