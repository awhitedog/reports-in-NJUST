//AD_epwm_da1

//epwm����AD�����޻���DA1����ɹ�

//�ź�Դ  freq 1kHz ampl 1V offset 500mV 20190823
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

int i=0;                   //д��DA������



Uint16 SampleTable1[BUF_SIZE]={0};

Uint16 ConvCount=0;

void init_zone7(void);

void init_mcbsp_spi(void);
void mcbsp_write(Uint8 send_data);
void init_AD9747(void);

void InitAdcParameters(void);
void InitEPwm1Parameters(void);

interrupt void epwm1_timer_adc_isr(void);

int xn,yn;   //AD�ɼ���DA�������

void main(void)
{
   InitSysCtrl();
   InitMcbspaGpio();
   DINT;                 //��ֹ CPU�жϣ���ֹȫ���ж�
   InitPieCtrl();        //��ʼ��PIE���ƼĴ���
   IER=0x0000;           //��������CPU�жϲ����CPU�жϱ�־λ
   IFR=0x0000;
   InitPieVectTable();   //��ʼ��PIE������    ���������     PieCtrlRegs.PIECTRL.bit.ENPIE=1

   EALLOW;
   PieVectTable.SEQ1INT =&epwm1_timer_adc_isr;  //��һ������ж�
   EDIS;

   InitAdcParameters();
   InitEPwm1Parameters();

   PieCtrlRegs.PIEIER1.bit.INTx1 = 1;  // Enable SEQ1INT interrupt in PIE 
   PieCtrlRegs.PIECTRL.bit.ENPIE=1;  //��PIE�ж�,ʹ��PIE
   IER |= M_INT1;      //��CPU��1���ж�

   EINT;      //ʹ��ȫ���жϣ������ж���Ӧ
   ERTM;

   init_zone7();     //��ʼ����ַ�ռ�zone7

   init_mcbsp_spi();
   init_AD9747();

   	//*Da_freq = 0x0007;   //����DAƵ�ʣ�32���ݣ���д��16λ����д��16λ
   //	*Da_freq = 0xA120;   //50K
   *Da_freq = 0x001E;   //����DAƵ�ʣ�32���ݣ���д��16λ����д��16λ
   *Da_freq = 0x8480;   //���Ҫ����10��200K

    while(1);
}
//����������

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
	XintfRegs.XINTCNF2.bit.WRBUFF = 3;   //   д����ģʽ����
	// XCLKOUT is enabled
	XintfRegs.XINTCNF2.bit.CLKOFF = 0;   //   XCLKOUTʹ��
	// XCLKOUT = XTIMCLK
	XintfRegs.XINTCNF2.bit.CLKMODE = 0;  //   XCLKOUT=XTIMCLK

    // zone7 ����-------------------------------------
	// When using ready, ACTIVE must be 1 or greater
    // Lead must always be 1 or greater
    // Zone write timing
    XintfRegs.XTIMING7.bit.XWRLEAD = 2;   //д���ڸ��׶�ʱ������  8��ʱ������
    XintfRegs.XTIMING7.bit.XWRACTIVE = 4;
    XintfRegs.XTIMING7.bit.XWRTRAIL = 2;
    // Zone read timing
    XintfRegs.XTIMING7.bit.XRDLEAD = 1;   //�����ڸ��׶�ʱ������ 7��ʱ������
    XintfRegs.XTIMING7.bit.XRDACTIVE = 5;
    XintfRegs.XTIMING7.bit.XRDTRAIL = 1;

    // don't double all Zone read/write lead/active/trail timing
    XintfRegs.XTIMING7.bit.X2TIMING = 0;

    // Zone will not sample XREADY signal
    XintfRegs.XTIMING7.bit.USEREADY = 0;    //������XREADY�ź�
    XintfRegs.XTIMING7.bit.READYMODE = 0;

    // 1,1 = x16 data bus
    // 0,1 = x32 data bus
    // other values are reserved
    XintfRegs.XTIMING7.bit.XSIZE = 3;   //ʹ��16λ������
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
    //McbspaRegs.SPCR1.bit.DLB = 0;        //����ѭ��ģʽ�������Է�

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

void mcbsp_write(Uint8 send_data)        //SPI���ݷ��ͺ���
{
	while( McbspaRegs.SPCR2.bit.XRDY == 0 ) {} ;
	McbspaRegs.DXR1.all=send_data;
}

/***********************AD9747����ģʽ���ú���**************************/
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
		 * ����Ƶ�ʵļ���:T(PWM1)=TBCLK/(TBPRD*2*3)=25/(208*3*2) = 0.02MHz , 20KHz
		 * ����, TBCLK = SYSCLKOUT / (HSPCLKDIV*CLKDIV)=150/(6*1)=25MHz
		 * TBPRD����2: EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN,�����õ������½�ģʽ
		 * TBPRD����3: EPwm1Regs.ETPS.bit.INTPRD = ET_3RD,��ÿ�����¼�����һ�β����ж�
		 * ���޸�TBPRD��ֵ�Ըı����Ƶ��
		 *
		 * */

void InitAdcParameters(void)
{
// Specific clock setting
    EALLOW;
    SysCtrlRegs.HISPCP.all = ADC_MODCLK;
    EDIS;

    InitAdc();

    AdcRegs.ADCTRL1.bit.RESET=1;     // Reset ADC  ��λADC
    DELAY_US(10000);

    AdcRegs.ADCTRL1.bit.RESET=0;      // Do not Reset ADC

    AdcRegs.ADCTRL1.bit.SUSMOD=0;       //Ignore Emulation Suspend, Forward Running  //���Է���������ģʽ    �����ϵ㣬ADCģ�����

    AdcRegs.ADCTRL3.bit.ADCCLKPS=1;
    AdcRegs.ADCTRL1.bit.CPS=1;             // F_ADCCLK=F_HSPCLK/(2*ADCCLKPS*(CPS + 1))=25/(2*1*(1+1))=6.25MHz

    AdcRegs.ADCTRL1.bit.ACQ_PS=5;          // Pulse Width of ADC Width=(ADCCLK*(ACQ_PS+1))=0.96us

    AdcRegs.ADCTRL1.bit.CONT_RUN=0;  //---- ADC Run at Continuous Conversion Mode//����ת��ģʽ      �����յ�EOS�źź��������Ķ���������SEQ-OVRD�����������0�����������ص���ʼ״̬CONV00�����������1���������ӵ�ǰ��ʼ����Ҫ��λ
    AdcRegs.ADCTRL1.bit.SEQ_CASC=1;  //---- ADC SEQ at Cascaded Mode  �����ڼ���ģʽ

    AdcRegs.ADCTRL3.bit.ADCBGRFDN=3;  // ��϶�Ͳο�Դ��·�ϵ�The Bandgap and Reference Circuitry is Powered up
    DELAY_US(10);

    AdcRegs.ADCTRL3.bit.ADCPWDN=1;       //�����ϵ�    // The analog circuitry inside the core is powered up
    DELAY_US(10);

    AdcRegs.ADCTRL3.bit.SMODE_SEL=0;   // Sequenced sampling mode   ˳�����

	AdcRegs.ADCMAXCONV.all=1;         //ConversionCount---------���ת��ͨ��+1=2��
    AdcRegs.ADCCHSELSEQ1.bit.CONV00 = 0x0;
    AdcRegs.ADCCHSELSEQ1.bit.CONV01 = 0x1;

// Interrupt clear bit.Clears the SEQ1 interrupt flag bit, INT_SEQ1.
    AdcRegs.ADCST.bit.INT_SEQ1_CLR=1;          //���SEQ1�жϱ�־λ
// Restart SEQ1
   AdcRegs.ADCTRL2.bit.RST_SEQ1=0;             //--------��Ч�����ܸ�λ������   д1���Ǹ�λ������
// Interrupt request by INT_SEQ1 is disabled
    AdcRegs.ADCTRL2.bit.INT_ENA_SEQ1=1;      //--------INT-SEQ1��CPU���ж�����ʹ��
// INT_SEQ1 is set at the end of every SEQ1 sequence.
    AdcRegs.ADCTRL2.bit.INT_MOD_SEQ1=0;    //ÿ��SEQ1���н���ʱ��INT-SEQ1��λ����λ���Ǹ�ֵΪ1
// EPWM SOCA enable bit for SEQ1
    AdcRegs.ADCTRL2.bit.EPWM_SOCA_SEQ1=1;   //����epwm_SOCA����SEQ1
// External signal start-of-conversion bit for SEQ1, No Action
    AdcRegs.ADCTRL2.bit.EXT_SOC_SEQ1=0;  //SEQ1�ⲿ����ת����Ч

}

void InitEPwm1Parameters(void)
{
//   InitEPwm1Gpio();

// Disable TBCLK within the ePWM
   EALLOW;
   SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0; //ֹͣepwmģ���ڲ���ʱ���׼ʱ��
   EDIS;

// High Speed Time-base Clock Prescale Bits,These bits determine part of the time-base clock prescale
// TBCLK = SYSCLKOUT / (HSPCLKDIV*CLKDIV)=150/(6*1)=25
   EPwm1Regs.TBCTL.bit.HSPCLKDIV =0x03;        //����ʱ���׼ʱ��Ԥ��Ƶλ                     ����
   EPwm1Regs.TBCTL.bit.CLKDIV = 0x00;          //ʱ���׼ʱ��Ԥ��Ƶλ ����0��1��Ƶ

// Set Period for EPWM1
   EPwm1Regs.TBPRD = 139;    //�趨ʱ���׼��������������       208-fs 20kHz,139-fs 30kHz  149--27.9kHz T(PWM1)=TBCLK/(TBPRD*2*3)=25/(208*3*2) = 0.02MHz , 20KHz
   EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN;  //��������ģʽ
// Setup Compare A = 2 TBCLK counts
   EPwm1Regs.CMPA.half.CMPA = 2;   //�����ȽϼĴ���A CMPA   ��ǰ������CMPA��ֵ���Ϻ�ʱ���׼������TBCTR�Ƚ�
// Phase is 0 for Synchronization Event
   EPwm1Regs.TBPHS.half.TBPHS = 0x0000;     //TBCTR��װ����λ�Ĵ���TBPHS��ֵ
// Clear  TB counter
   EPwm1Regs.TBCTR = 0x0000;   //�¼���׼�����Ĵ���TBCTR   ��ȡд�����е�TBCTR��ֵ    ���

// Phase loading disabled
   EPwm1Regs.TBCTL.bit.PHSEN = TB_DISABLE;//��ֹTBCTR��TBPHS��װ��
// Enable the TBCTL Shadow
   EPwm1Regs.TBCTL.bit.PRDLD = TB_SHADOW;//TBCTRװ����ӳ��Ĵ�����ֵ
// Disable EPWMxSYNCO signal
   EPwm1Regs.TBCTL.bit.SYNCOSEL = TB_SYNC_DISABLE; //����EPWMxSYNCO signal
// CMPA Register operating mode, 0 means operates as a double buffer, all writes via the CUP access the shadow register
   EPwm1Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;//ӳ��ģʽ��˫����ģʽ������CPUд����������ӳ��Ĵ���
// Active CMPA Load From Shadow Select Mode when CTR=0
   EPwm1Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;  // load on CTR = Zero

// Set actions
// Force EPWMA output high when the counter equals the active CMPA register and the counter is incrementing
   EPwm1Regs.AQCTLA.bit.CAU = AQ_SET;//��������    ǿ��ePWMxA�����
// Force EPWMA output low Action when the counter equals the active CMPA register and the counter is decrementing
   EPwm1Regs.AQCTLA.bit.CAD = AQ_CLEAR;//�����ݼ�    ǿ��ePWMxA�����

// Dead-Band Generator Rising Edge Delay Count Register=0
//   EPwm1Regs.DBRED=0;
// Dead-Band Generator Falling Edge Delay Count Register=0
//   EPwm1Regs.DBFED=0;

// Enable ADC Start of SOCA Pulse
   EPwm1Regs.ETSEL.bit.SOCAEN = 1;     //ʹ��ePWMxSOCA����
// Select SOC from CPMA on upcount
   EPwm1Regs.ETSEL.bit.SOCASEL = 2;     //TBCTR=TBPRDʱ����ePWMxSOCA
// Select how many selected ETSEL events need to occur before an EPWMxSOCA pulse is generated;//�ڵ������¼�����ePWMxSOCA����
   EPwm1Regs.ETPS.bit.SOCAPRD = 3;

// Enable event time-base counter equal to period (TBCTR = TBPRD)
   EPwm1Regs.ETSEL.bit.INTSEL = ET_CTR_PRD; // TBCTR=TBPRDʱ����ePWMxSOCA
// Enable EPWMx_INT generation
   EPwm1Regs.ETSEL.bit.INTEN = 0;           //��ֹePWMx_INT����
// These bits determine how many selected ETSEL[INTSEL] events need to occur before an interrupt is generated.
   EPwm1Regs.ETPS.bit.INTPRD = ET_3RD;      //�ڵ������¼������ж�

// Enable TBCLK within the ePWM
   EALLOW;
   SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
   EDIS;
}
unsigned int property=10000;
interrupt void epwm1_timer_adc_isr(void)    //�жϺ���
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
   AdcRegs.ADCTRL2.bit.RST_SEQ1 = 1;       //��λSEQ1
// Clear INT SEQ1 bit
// EPwm1Regs.ETCLR.bit.INT = 1;           //����жϱ�־λ
  // ���SEQ1�жϱ�־λ 
   AdcRegs.ADCST.bit.INT_SEQ1_CLR = 1;
// Acknowledge interrupt to PIE
   PieCtrlRegs.PIEACK.all = PIEACK_GROUP1; //PIEACK-PIE ackonwledge register   //�ж�Ӧ��


   return;
}

