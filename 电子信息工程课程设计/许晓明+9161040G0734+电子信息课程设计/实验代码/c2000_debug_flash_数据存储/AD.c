/****************************************************/
/*   ADC ²ÉÑùÆµÂÊ 9.3KHz							*/
#include <stdlib.h>


#include "type.h"
#include "sx2.h"
#include "descriptors.h"
#include "DEC2812_USB.h" 
#include "ep0req.h"

#include "DPS2812_LCD.h"
#include "DSP281x_Device.h"
//#include "dlog4ch.h"
#include "fir.h"
#include "iir.h"
#include "filter.h" 
//#include "stb.h"                
#include "fft.h" 
void ConfigureGpio(void);
void InitSystem(void);
void SCI_Init(void);
 
void FIRZ(void);
void IIRZ(void);
void FFTZ(void);
void AD_read(void);
void AD_read_2(void);
void calculate_f(void);
void AD_DA(void);
void input_display(void);
void Scia_Send(void);


void f11(void);
void f12(void);
void f13(void);

void f21(void);
void f22(void);
void f23(void);


void f32(void);
void KeyValue(unsigned int k);
unsigned int  Save_keyvalue[2];
unsigned int  adfreq[3]={0,0,0};
unsigned int  adfreq_last;
//unsigned int  result[299];
unsigned int  a,k,m=0;
int x;
unsigned int  freq1=0,freq2=0,freq3=0;
unsigned int  flag[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
unsigned int  bz=0;
unsigned int  key1=1;
unsigned int  key2=1;
unsigned int  key3=1;
unsigned int  key4=1;
unsigned int  key5=1;
unsigned int  key6=1;
unsigned int  key7=1;
unsigned int  key8=1;
unsigned int  key9=1;
unsigned int  number=0;
unsigned int  count_ad=0;
unsigned int  can=0;
unsigned int  aa,bb,cc,dd;
unsigned int  choice=2;
unsigned int  Send_Flag=0;
unsigned int  read_over=0;
unsigned int  read_stop=0;
unsigned int  threshold=100;
int change_result=0;
//unsigned int last_i=0; 
unsigned int interval_;
float return_hz;
#pragma DATA_SECTION(result,"newsect");
unsigned int result[1024];
//int result_gezhi[1024];
int result_filter[1019];
int threshold_result;
int interval_result=0;
int last_threshold=0;
unsigned int last_i=0;
int measure_f;
 int result_max, result_min;
 int max_k, min_k, mean_k;
unsigned int result_mean=0;
unsigned int count_display = 20;
long int result1;
long int result1_max;
long int result1_min;
int flag_result;
//unsigned int  aa,bb,cc;
/* Create an instance of DATALOG Module             */
//DLOG_4CH dlog=DLOG_4CH_DEFAULTS;      
    





//************************USBÏà¹Ø*************************/
BOOL Load_descriptors(char length, char* desc);
BOOL Write_SX2reg(unsigned char addr, unsigned int value);
BOOL SX2_comwritebyte(unsigned int value);
BOOL SX2_FifoWrite(int channel,unsigned int *pdata,unsigned length);
BOOL SX2_FifoWriteSingle(int channel,unsigned int pdata);
unsigned int SX2_FifoReadSingle(int channel);
interrupt void XINT2_ISR_A(void);

extern char desctbl[];

unsigned char keepAliveCnt;	/* counter of Timer0 interrupts */
HANDLE codec_command =0;
HANDLE codec_data=0;
unsigned int FifoWriteCnt = 0;
#pragma DATA_SECTION(epdatar,"usbdata");
#pragma DATA_SECTION(epdataw,"usbdata");
#pragma DATA_SECTION(epdataw1,"usbdata");
#pragma DATA_SECTION(epdataw2,"usbdata");
unsigned int epdatar[256] ={0};
unsigned int epdataw[512] ={0};
//int epdataw[512] ={0};
unsigned int epdataw1[512] ={0};  
unsigned int  epdataw2[512] ={0};
//int  epdataw2[512] ={0};
unsigned int irqValue;			 /* interrupt register value */
unsigned int setupBuff[8];		 /* setup transaction buffer */
BOOL sx2Ready;			 /* status byte for POST */ 
BOOL sx2BusActivity;	 /* status byte for suspend */ 
BOOL sx2EnumOK;			 /* status byte for enumeration complete */
BOOL sx2EP0Buf;			 /* status for endpoint 0 buffer */
BOOL sx2Setup;			 /* setup flag set in Int0() ISR */
BOOL FLAGS_READ = FALSE; /*FIFOµÄ×´Ì¬¶ÁÇëÇó*/
unsigned int INT_STATUS;
unsigned int SX2_int;   

unsigned long readFlag;

unsigned int usbtimeout = 0x400;
unsigned int regdataread = 0; 	

unsigned int Fifolong = 0;     /*FIFOµÄ³¤¶È*/

unsigned int setupCnt = 0;
unsigned int Usb2or11= 1;    /*USB¹¤×÷ÔÚÄÄÒ»¸ö±ê×¼ÉÏ*/
unsigned int hshostlink = 0; /*ÎªÕæÊÇ¸ßËÙUSB½Ó¿Ú£¬Îª¼ÙÊÇµÍËÙUSB½Ó¿Ú*/
static BOOL setupDat = FALSE;

unsigned int SX2_Clc;
unsigned int Count_main = 0;


int count_bao;
int count_bao_shu;
unsigned int usb_sendover;
int usb_stop;
int Fifostatus_first=0;
int Fifostatus_second=0;
int count_usb;
int count_inside;
unsigned int usb_right;
unsigned int usb_left;
unsigned int enum_start=1;




//************************FIRÍ·ÎÄ¼þ*************************/
#define FIR_ORDER   50                                        
long dbuffer[(FIR_ORDER+2)/2];  
FIR16  fir= FIR16_DEFAULTS;                                        
#pragma DATA_SECTION(fir, "firfilt");
#pragma DATA_SECTION(dbuffer,"firldb");                                      
const long coeff11[(FIR_ORDER+2)/2]= FIR16_LPF50;
const long coeff12[(FIR_ORDER+2)/2]= FIR16_HPF50;
const long coeff13[(FIR_ORDER+2)/2]= FIR16_BPF50;
const long coeff14[(FIR_ORDER+2)/2]= FIR16_BSF50;


//************************IIRÍ·ÎÄ¼þ*************************/    
#pragma DATA_SECTION(iir, "iirfilt");                       
IIR5BIQ16  iir=IIR5BIQ16_DEFAULTS;
                                                                  

#pragma DATA_SECTION(dbuffer1,"iirfilt");                     
int dbuffer1[2*IIR16_BSF_NBIQ];

const int coeff21[5*IIR16_LPF_NBIQ]=IIR16_LPF_COEFF;
const int coeff22[5*IIR16_HPF_NBIQ]=IIR16_HPF_COEFF;
const int coeff23[5*IIR16_BPF_NBIQ]=IIR16_BPF_COEFF;
const int coeff24[5*IIR16_BSF_NBIQ]=IIR16_BSF_COEFF;




//********************FFTÍ·ÎÄ¼þ******************************//



 
#define N   1024
#pragma DATA_SECTION(ipcb, "FFTipcb");
#pragma DATA_SECTION(mag, "FFTmag");
#pragma DATA_SECTION(shuchu0,"fftout0");
#pragma DATA_SECTION(shuchu1,"fftout1");
CFFT32  fft=CFFT32_1024P_DEFAULTS;     
long ipcb[2*N];
long mag[N]; 
int shuchu0[N];
int shuchu1[N];
int c;
int i;
volatile unsigned int* sram_control = (volatile unsigned int *) 0x002D00;


const long win[N/2]=HAMMING1024;

CFFT32_ACQ  acq=CFFT32_ACQ_DEFAULTS;        
    
int xn,yn;
unsigned long q;
unsigned long led_light;



interrupt void adc_isr(void); 


volatile unsigned int* DAOUT = (volatile unsigned int *) 0x002900;
volatile unsigned int* LED8 = (volatile unsigned int *) 0x002000; 
volatile unsigned int* LED7 = (volatile unsigned int *) 0x002100;
volatile unsigned int* LED6 = (volatile unsigned int *) 0x002200;
volatile unsigned int* LED5 = (volatile unsigned int *) 0x002300;
volatile unsigned int* LED4 = (volatile unsigned int *) 0x002400;
volatile unsigned int* LED3 = (volatile unsigned int *) 0x002500;
volatile unsigned int* LED2 = (volatile unsigned int *) 0x002600;
volatile unsigned int* LED1 = (volatile unsigned int *) 0x002700;
volatile unsigned int* LEDWR = (volatile unsigned int *) 0x002C00;
       


     
void fang(void)
{
	GpioDataRegs.GPBDAT.bit.GPIOB12= 0;
	GpioDataRegs.GPBDAT.bit.GPIOB13 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB14 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB15 = 1;
	KeyValue(1);
	
	GpioDataRegs.GPBDAT.bit.GPIOB12 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB13 = 0;
	GpioDataRegs.GPBDAT.bit.GPIOB14 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB15 = 1;
	KeyValue(2);
		
	GpioDataRegs.GPBDAT.bit.GPIOB12 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB13 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB14 = 0;
	GpioDataRegs.GPBDAT.bit.GPIOB15 = 1;
	KeyValue(3);	

	GpioDataRegs.GPBDAT.bit.GPIOB12 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB13 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB14 = 1;
	GpioDataRegs.GPBDAT.bit.GPIOB15 = 0;
	KeyValue(50);	

}

		void result_calculate()
		{
		    int k;
		    int i;
			int j;
			//ÂË²¨
		for(i=0;i<=1019;i++)
		/*{
		result_filter[i]=result[i]+result[i+1]+result[i+2]+result[i+3]+result[i+4];
		result_filter[i]=result_filter[i]/5;
		}
		result_mean=0;*/
		 /*   for(k=0;k<1019;k++)
		        result_mean = result_mean + result_filter[k];
		    result_mean = result_mean / 1019;
		    for(k=0;k<1019;k++)
		        result_filter[k] = result_filter[k] - result_mean;
	*/
		    result_max = result[0];
			result_min = result[0];


			    for(k=0;k<1024;k++)
			    {
			        if(result[k]>result_max)
			        {
			            result_max = result[k];
			        }
			        if(result[k]<result_min)
			        {
			            result_min = result[k];
			        }
					
				    }
			threshold=result_min+(result_max-result_min)*0.6;
			for(i=0;i<1019;i++)
			{
		 if(	result[i]<threshold && result[i+1]>=threshold)
		 {interval_result=i-last_i;
		 last_i=i;
		 measure_f=adfreq_last/interval_result;}
			}
	}




void lednum(void)//ÊýÂë¹ÜÏÔÊ¾
  {

       * LED8 = 0x7F;
        //* LED8 = 0xFF;
        * LED7 = 0x07;
        * LED6 = 0x7D;
        * LED5 = 0x6D;
        * LED4 = 0x66;
        * LED3 = 0x4F;
        * LED2 = 0x5B;
        * LED1 = 0x06;
        * LEDWR = 0x11;
      }

void  main(void)
{   


//************************USBÏà¹Ø*************************/
	unsigned int regValue = 0;	 /* register value from a read */
//	unsigned int Sx2int = 0;     /*SX2µÄÖÐ¶Ï×´Ì¬*/
	
	unsigned int endpoint0count = 0;/*EP0µÄÊý¾Ý³¤¶È*/
	unsigned int endpoint0data[64] ={0};/*EP0µÄÊý¾Ý»º³åÇø*/
	unsigned int i = 0;
	unsigned int FifoStatus24 = 0;	/*FIFO24µÄ×´Ì¬±êÊ¶*/
	unsigned int FifoStatus68 = 0; 	/*FIFO68µÄ×´Ì¬±êÊ¶*/
	unsigned int Fifostatus = 0;
	
//	BOOL codec_runing = FALSE;
//	BOOL codec_halt = FALSE;
//	BOOL codec_rev = FALSE;
//	BOOL codec_play = FALSE;
//	BOOL codec_datok = FALSE;
//	BOOL codec_horfull = TRUE;
//	BOOL codec_back = FALSE;  
//	BOOL sx2EnumOK = FALSE;
//	unsigned int codec_count = 0;
//	unsigned int codec_sample = 0;
//	unsigned int codec_regvalue = 0;
//	unsigned int audiodata =0;
	unsigned int RecievedDataLongth = 0;
//	unsigned int LedCount = 0; /*¼ÇÂ¼LED´ÎÊý*/
	unsigned int DataToEndpoint0 = 0;/*Ð´ÈëEndpoint0µÄÊý¾Ý»º³å*/
//	unsigned long flashbaddr = 0;
//	unsigned int flashdata = 0;
//	unsigned int flasherr = 0;
//	unsigned long flashlong = 0;



     /*  dlog.iptr1=&xn;  
       dlog.iptr2=&yn;
       dlog.trig_value=0x800;
       dlog.size=0x400;         
       dlog.init(&dlog);*/
       
     //****************ÒÔÏÂÎªFFT³õÊ¼»¯**************************
      /* Initialize acquisition module                    */
         acq.buffptr=ipcb;
        acq.tempptr=ipcb;
        acq.size=N;
        acq.count=N;
        acq.acqflag=1;

/* Initialize FFT module                            */
        fft.ipcbptr=ipcb;
        fft.magptr=mag;  
        fft.winptr=(long *)win;
        fft.init(&fft); 
                  
        iir.qfmat=IIR16_BSF_QFMAT;
        iir.nbiq=IIR16_BSF_NBIQ; 
        iir.isf=IIR16_BSF_ISF; 
        iir.dbuffer_ptr=dbuffer1;    
        iir.coeff_ptr=(int *)coeff24;

    InitSystem();            //³õÊ¼»¯DSPÄÚºË¼Ä´æÆ÷
    InitPieCtrl();             //µ÷ÓÃPIE¿ØÖÆµ¥Ôª³õÊ¼»¯º¯Êý
    InitPieVectTable();         //  µ÷ÓÃPIEÏòÁ¿±í³õÊ¼»¯º¯Êý
    InitAdc();
    SCI_Init(); 
    /*³õÊ¼»¯GPIO*/
	InitGpio1(); 
    
	InitPeripherals();/* ³õÊ¼»¯ÍâÉè¼Ä´æÆ÷ */
	GUILCD_init();/*³õÊ¼»¯LCD*/
	GUILCD_clear(); //ÇåÆÁ              
    menu_1();
    
    EALLOW;
    PieVectTable.ADCINT=&adc_isr;    //ÉèÖÃPIEÏòÁ¿±íÖÐADcµÄÖÐ¶ÏÈë¿ÚÏòÁ¿
	PieVectTable.XINT2 = &XINT2_ISR_A;
    EDIS;
	
	InitXIntrupt();
    *USB_STS = 0x20;//»½ÐÑCY7C68001£¬Ê¹ÆäÕý³£¹¤×÷

    PieCtrlRegs.PIEIER1.bit.INTx6=1;     //Ê¹ÄÜPIEÖÐ¶Ï·Ö×é1ÖÐµÄADCÖÐ¶Ï
    
    IER=1;          //Ê¹ÄÜºÍADCÖÐ¶ÏÏàÁ¬µÄCPU INT1ÖÐ¶Ï
	IER|=M_INT9;		//Ê¹ÄÜCPU¼¶ÖÐ¶ÏINT9
	IER |= M_INT1;//¿ªCPUµÄµÚÒ»×éÖÐ¶Ï£¬ÒòÎªÍâÎ§ÖÐ¶Ï2ÊôÓÚÕâÒ»×é
    
    EINT;           //Ê¹ÄÜÈ«¾ÖÖÐ¶ÏÎ»INTM
    ERTM;           // Ê¹ÄÜÈ«¾ÖÊµÊ±µ÷ÊÔÖÐ¶ÏDBGM
    
    
    /* SET ADC*/
    AdcRegs.ADCTRL1.bit.SEQ_CASC=0;
    AdcRegs.ADCTRL1.bit.CONT_RUN=0;
    AdcRegs.ADCTRL1.bit.CPS=0;
    AdcRegs.ADCMAXCONV.all=0x0000;         //µ¥Í¨µÀ×ª»»
    AdcRegs.ADCCHSELSEQ1.bit.CONV00=0x0;//½«ADCINA0ÉèÖÃÎªSEQ1µÄµÚÒ»¸ö×ª»»Í¨µÀ
    AdcRegs.ADCTRL2.bit.EVA_SOC_SEQ1=1;       //Ê¹ÄÜEVAÒýÆðµÄÖÐ¶Ï
    AdcRegs.ADCTRL2.bit.INT_ENA_SEQ1=1;       
    AdcRegs.ADCTRL3.bit.ADCCLKPS=2;       //ADcÄ£¿éµÄºËÐÄÊ±ÖÓÆµÂÊ=HSPCLK/4
    
    /* SET EVA*/
    EvaRegs.GPTCONA.bit.TCMPOE=0;     //½ûÖ¹±È½ÏÊä³ö
    EvaRegs.GPTCONA.bit.T1PIN=0; 
    EvaRegs.GPTCONA.bit.T1TOADC=2;       //ÉèÖÃÖÜÆÚÖÐ¶Ï±êÖ¾Æô¶¯ADC
    EvaRegs.T1CON.bit.FREE=0;    //·ÀÕæ¹ÒÆðÊ±£¬¶¨Ê±Æ÷1Á¢¼´Í£Ö¹¹¤×÷
    EvaRegs.T1CON.bit.SOFT=0;
    EvaRegs.T1CON.bit.TMODE=2;   //Á¬ÐøÔö¼ÆÊýÄ£Ê½
    EvaRegs.T1CON.bit.TPS=4;     //ÉèÖÃ¶¨Ê±Æ÷Ê±ÖÓÆµÂÊÎªHSPCLK/16
    EvaRegs.T1CON.bit.TENABLE=1;     //ÔÊÐí¶¨Ê±Æ÷²Ù×÷
    EvaRegs.T1CON.bit.TCLKS10=0;     //ÄÚ²¿Ê±ÖÓ
    EvaRegs.T1CON.bit.TCLD10=0;     //¼ÆÊýÆ÷Îª0Ê±ÖØÔØ
    EvaRegs.T1CON.bit.TECMPR=0;     //½ûÖ¹±È½Ï²Ù×÷
    EvaRegs.T1PR=234;       //¶¨Ê±Æ÷ÖÜÆÚ¼Ä´æÆ÷
                            
       
       i=0;
      * sram_control=0x14;  

    /* SET GPIO*/
 	EALLOW;
   	
   	
   	GpioMuxRegs.GPBMUX.all = 0x0;
    GpioMuxRegs.GPBDIR.bit.GPIOB12 = 1;//¼üÅÌGPIOB[15£º12]Êä³ö£¬[11£º 7]»Ø¶Á£¬Êép97£¬DIR
    GpioMuxRegs.GPBDIR.bit.GPIOB13 = 1;
    GpioMuxRegs.GPBDIR.bit.GPIOB14 = 1;
    GpioMuxRegs.GPBDIR.bit.GPIOB15 = 1;

    GpioMuxRegs.GPBDIR.bit.GPIOB11 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB10 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB9 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB8 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB7 = 0;

    GpioMuxRegs.GPBDIR.bit.GPIOB3 = 1;//Êä³ö£¬ÓÃÓÚ²âfftÊ±¼ä
    /*¶þ¼«¹ÜÉèÖÃ*/
    GpioMuxRegs.GPFDIR.bit.GPIOF8 = 1;
    GpioMuxRegs.GPFDIR.bit.GPIOF9 = 1;
    GpioMuxRegs.GPFDIR.bit.GPIOF10 = 1;
    GpioMuxRegs.GPFDIR.bit.GPIOF11 = 1;
    GpioMuxRegs.GPFDIR.bit.GPIOF12 = 1;
    GpioMuxRegs.GPFDIR.bit.GPIOF13 = 1;
    
    GpioDataRegs.GPFDAT.bit.GPIOF8 = 1;
    GpioDataRegs.GPFDAT.bit.GPIOF9 = 0;
	GpioDataRegs.GPFDAT.bit.GPIOF10 =0;
    GpioDataRegs.GPFDAT.bit.GPIOF11 = 0;
    GpioDataRegs.GPFDAT.bit.GPIOF12 = 1;
	GpioDataRegs.GPFDAT.bit.GPIOF13 =0; 

	GpioMuxRegs.GPFMUX.bit.SCITXDA_GPIOF4=1;//ÍâÉè¹¦ÄÜTXÒý½Å
//	GpioMuxRegs.GPFDIR.all=0x0;
				

    
  	EDIS;
   	
   	a = 0;
	x = 0;

	
   //EvaRegs.T1CON.bit.TENABLE=1;     //ÔÊÐí¶¨Ê±Æ÷²Ù×÷
while(1)
{ 
    
    can=0;
    lednum();//LEDÏÔ
    
	GUILCD_clear(); //ÇåÆÁ
	menu_2();
	Save_keyvalue[1] = 0;
	
   while(key1)
	{   
	   
		GpioDataRegs.GPFDAT.bit.GPIOF8 = !(GpioDataRegs.GPFDAT.bit.GPIOF8);
	    GpioDataRegs.GPFDAT.bit.GPIOF9 = !(GpioDataRegs.GPFDAT.bit.GPIOF9);
		GpioDataRegs.GPFDAT.bit.GPIOF10 = !(GpioDataRegs.GPFDAT.bit.GPIOF10);
	    GpioDataRegs.GPFDAT.bit.GPIOF11 = !(GpioDataRegs.GPFDAT.bit.GPIOF11);
	    GpioDataRegs.GPFDAT.bit.GPIOF12 = !(GpioDataRegs.GPFDAT.bit.GPIOF12);
		GpioDataRegs.GPFDAT.bit.GPIOF13 = !(GpioDataRegs.GPFDAT.bit.GPIOF13);

		led_light=2000;
	   	while(led_light)
	   	{
	   		led_light--;
			fang();

			if(x==4)
			{
				GUILCD_clear();
				menu_5();
				Save_keyvalue[0] = x;
				choice=0;
				x=20;
				key1=0;
				led_light=0;
			}
	   		else if((x==1)||(x==2) ||(x==3))
			{
				GUILCD_clear();
				menu_1();
				Save_keyvalue[0] = x;
				//a++;
				x = 0;
				key1=0; 
				choice=1;
				led_light=0;
	    	}
			 
		}
	}
	key1=1;
	q=500000;
	while(q)
	{
	q--;
	}


	bz=Save_keyvalue[0]*8;

	while(choice==1)
	{
		while(key2)
		{  
			fang();
		    if((x==1)||(x==2))
			{	
					if(bz==24)
				{
					GUILCD_clear(); //ÇåÆÁ
					menu_4();
					choice=2;
				
				}
					else if((bz==8)||(bz==16))
				{
					GUILCD_clear(); //ÇåÆÁ
					menu_3();
							
				}

				switch(x)
				{
	    		case 1: EvaRegs.T1PR=234;break;//²ÉÑùÆµÂÊ20K
	    		case 2: EvaRegs.T1PR=167;break;//ÉèÖÃ²ÉÑùÆµÂÊ27.9k
	    	    default:break;
				}
				x = 0;
				key2=0;
		    }
		}
		key2=1;
		q=500000;
		while(q)
		{
		q--;
		}


		if(bz!=24)
	 	{
			while(key3)
			{  
				fang();
			    if((x==1)||(x==2)||(x==3))
				{
					GUILCD_clear(); //ÇåÆÁ
					menu_4();
					Save_keyvalue[1] = x;
				//	a++;
					x = 0;
					key3=0; 
					choice=2;
					
			    }
			 }
		}
		key3=1;
		q=500000;
		while(q)
		{
		q--;
		}
		
		
		bz=Save_keyvalue[0]*8+Save_keyvalue[1];
	  	switch(bz)
	      {
            case 9:  f11();break;//fir³õÊ¼»¯
            case 10: f12();break;
            case 11: f13();break;
            
            case 17: f21();break;//iir³õÊ¼»¯
            case 18: f22();break;
            case 19: f23();break;
            
            case 24: break;
			//case 32: break;
            default:break;
          }
	}



	while(choice==0)
	{	

		while(key5)
		{
			fang();
			adfreq_last=0;
			if((x>=0)&&(x<=9))
			{	
				input_display();//ÊäÈë²ÉÑùÆµÂÊ			
				x=20;
				q=120000;
				while(q)
				{
					q--;
				}
				
			}
			else if(x==12)
			{
				GUILCD_clear(); //ÇåÆÁ
				menu_6();
				count_ad=0;
				key5=0;
				x=0;
				key8=1;
				q=120000;
				while(q)
				{
					q--;
				}
			}
			
		}
	
        EvaRegs.T1CON.bit.TPS=2;
		adfreq_last=1000*adfreq[0]+100*adfreq[1]+10*adfreq[2]+1*adfreq[3];	
		EvaRegs.T1PR=18750/adfreq_last*500-1;
		adfreq[0]=0;
		adfreq[1]=0;
		adfreq[2]=0;
		adfreq[3]=0;
       



		read_over=0;
		while(key8)
		{

			
			fang();
			if(x==1)
			{
				GUILCD_clear();
				menu_4();
			
				x=0;
				choice=2;
				bz=33;
				count_bao=0;
				usb_sendover=5;
				usb_stop=10;
				count_inside=0;
				
				
			
while(enum_start==1)
{

			/* SX2_intÊ²Ã´º¬Òå£¿Ê²Ã´¹¦ÄÜ*/ //Ã»ÓÃ,Ö÷Òª¹¦ÄÜ´ò¿ªÈ«¾ÖÖÐ¶Ï 
	for(;;)
    	{
    		if(GpioDataRegs.GPEDAT.bit.GPIOE1 == 1)
    		{
    			InitGpio();
    			// USBÃüÁî¿ÚµØÖ·£¬USB_COMMAND = 0x2804£»
    			SX2_Clc = *USB_COMMAND;
    		//	SX2_int = *USB_COMMAND & (SX2_INT_ENUMOK + SX2_INT_READY);   
    			if(SX2_int)
    			{
    				EINT;   // Enable Global interrupt INTM
					ERTM;	// Enable Global realtime interrupt DBGM
					break;
			}
		}
		else
		{
			InitGpio();
			SX2_int = *USB_COMMAND & (SX2_INT_ENUMOK + SX2_INT_READY);
			EINT;   // Enable Global interrupt INTM
			ERTM;	// Enable Global realtime interrupt DBGM
			break;
		}
    	}
		
		
/* initialize global variables */
		readFlag 		= 0;	/* false until register read */
		sx2Ready		= FALSE;	/* false until POST or wakeup */
		sx2BusActivity	= FALSE;	/* false until absence or resumption of USB bus activity */
		sx2EnumOK		= FALSE;	/* false until ENUMOK interrupt */
		sx2EP0Buf		= FALSE;	/* false until EP0BUF interrupt */
		sx2Setup		= FALSE;	/* false until SETUP interrupt */
		
		/* Initialize global variables specific to this test firmware */
		keepAliveCnt		= 0;

		/* Initialize local variables */
		/* reusable variable for read register data */
		regValue			= 0;
		// Load_descriptors:¼ÓÔØÖ¸¶¨µØÖ·ºÍ³¤¶ÈµÄÄÚÈÝµ½usbÃèÊö·û±íÖÐ
		if(!Load_descriptors(DESCTBL_LEN, &desctbl[0]))
		{
			while(TRUE);
		}
	//	SX2_Clc = *USB_COMMAND;
		/*
		//*USB_STS = 0x00;//
		//*USB_STS = 0x20;//»½ÐÑCY7C68001£¬Ê¹ÆäÕý³£¹¤×÷
		if(!Load_descriptors(DESCTBL_LEN, &desctbl[0]))
		{
			while(TRUE);
		}		
		
		*/		

		Read_SX2reg(SX2_EP24FLAGS, &FifoStatus24);
		Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
		
		
		/*×°ÔØÃèÊö±íºó£¬µÈ´ý×Ô¾Ù³É¹¦*/
		/*×°ÔØÃèÊö±íºó£¬µÈ´ý×Ô¾Ù³É¹¦*/ 
		while(TRUE)
		{
			if(sx2EnumOK == TRUE)
			{
				break;
			}
		}
		//´ËÊ±µÈ´ýÖ÷»úÓëcypress USBÐ¾Æ¬Í¨ÐÅÖÐ¶Ï£¬Í¨ÐÅ³É¹¦ºóUSB·¢³öÒ»¸öÖÐ¶Ï±íÃ÷×Ô¾Ù³É¹¦
		

		/*ÉèÖÃµ±Ç°µÄ½Ó¿ÚµÄÐÎÊ½*/
		Write_SX2reg(SX2_IFCONFIG , 0xE8);
		/*ÉèÖÃµ±Ç°ÏµÍ³ÖÐ¸÷Ê¹ÄÜÐÅºÅµÄ¼«ÐÔ
		  ÆäÖÐSLOE¡¢SLRD¡¢SLWRÖ»ÄÜÓÐEEPROMÀ´ÅäÖÃ*/
		Write_SX2reg(SX2_FIFOPOLAR, SX2_WUPOL | SX2_EF | SX2_FF);
		/*¶ÁÈ¡µ±Ç°¹¤×÷ÔÚÄÄ¸öUSBµÄ±ê×¼???    wrong*/
		Read_SX2reg(SX2_FNADDR, &Usb2or11);
		hshostlink = (Usb2or11 & SX2_HSGRANT) ? 1 : 0;//Ö¸Ê¾¹¤×÷ÔÚ¸ßËÙ»¹ÊÇÈ«ËÙ×´Ì¬
		/*³õÊ¼»¯USBµÄ¹¤×÷×´Ì¬*/
		//if(hshostlink == 1)
		{
			/*¹¤×÷ÔÚ2.00±ê×¼,Éè¶¨Êý×Ö½Ó¿ÚÎª16Î»£¬Êý¾Ý°üµÄ´óÐ¡Îª512×Ö½Ú*/
			Fifolong = 0x100;
			Write_SX2reg(SX2_EP2PKTLENH , SX2_WORDWIDE | 0x02);
			Write_SX2reg(SX2_EP2PKTLENL , 0x00);
			Write_SX2reg(SX2_EP4PKTLENH , SX2_WORDWIDE | 0x02);
			Write_SX2reg(SX2_EP4PKTLENL , 0x00);
			Write_SX2reg(SX2_EP6PKTLENH , SX2_WORDWIDE | 0x02);
			Write_SX2reg(SX2_EP6PKTLENL , 0x00);
			Write_SX2reg(SX2_EP8PKTLENH , SX2_WORDWIDE | 0x02);
			Write_SX2reg(SX2_EP8PKTLENL , 0x00);
		}
/*		else
		{
			
			Fifolong =0x20;
			Write_SX2reg(SX2_EP2PKTLENH , SX2_WORDWIDE);
			Write_SX2reg(SX2_EP2PKTLENL , 0x40);
			Write_SX2reg(SX2_EP4PKTLENH , SX2_WORDWIDE);
			Write_SX2reg(SX2_EP4PKTLENL , 0x40);
			Write_SX2reg(SX2_EP6PKTLENH , SX2_WORDWIDE);
			Write_SX2reg(SX2_EP6PKTLENL , 0x40);
			Write_SX2reg(SX2_EP8PKTLENH , SX2_WORDWIDE);
			Write_SX2reg(SX2_EP8PKTLENL , 0x40);
		}*/
		/*ÉèÖÃFLAGSAÎªFIFO6µÄ¿ÕµÄ±êÖ¾Î»£»
		  ÉèÖÃFLAGSBÎªFIFO8µÄ¿ÕµÄ±êÖ¾Î»£»
		  FLAGSCÓëFLAGSDµÄ×´Ì¬ÎªÄ¬ÈÏµÄ×´Ì¬*/
		Write_SX2reg(SX2_FLAGAB , SX2_FLAGA_FF6 | SX2_FLAGB_FF8); 
		/*Çå¿ÕËùÓÐµÄ½Úµã*/
		Write_SX2reg(SX2_INPKTEND, SX2_CLEARALL);
		enum_start=2;
	}



	while(1)
	{
		if(read_over==1)break;
	}  //ÅÐ¶ÏÊÇ·ñ²ÉÍê
			
	//	Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);		
		//if(sx2EnumOK)
		//{
		//	SX2_FifoWrite(ENDPOINT6,&epdatar[0],Fifolong);			
		//}
		//Read_SX2reg(SX2_EP68FLAGS, &Fifostatus);
		
		//Read_SX2reg(SX2_EP68FLAGS, &Fifostatus);  ¶Áfifo¼Ä´æÆ÷À´¿ØÖÆÊÇ·ñÐ´ÈëÐÂÊý×é
		/*×Ô¾Ùºó½øÐÐÖ÷³ÌÐòµÄÑ­»·*/
		while(sx2EnumOK&&usb_sendover)
		{
		    usb_sendover--;
		    if(sx2BusActivity==FALSE)
			{
								
				Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
				Fifostatus=FifoStatus68;
				Fifostatus_first=FifoStatus68;
							//			if(Fifostatus_second==0x0061&&(Fifostatus_first==0x0066||Fifostatus_first==0x0064))
							//			{
							//				usb_sendover=0;
							//			}
								
				while(1)
				{
					count_inside++;
					Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
					if(FifoStatus68 ==0x66)
					break;
					if(count_inside>  100000 )
					break;//return false;
				}
				if(usb_sendover==0)
				{
					epdatar[0]=0x0000;
					epdatar[1]=0x1000;
				}
				else
				{
					epdatar[0]=0x0100;
					epdatar[1]=0xFE01;
				}
				if(usb_sendover==0)
				{
					for(count_bao_shu=2;count_bao_shu<10;count_bao_shu++)
					{
						usb_right=result[(4-usb_sendover)*254+count_bao_shu-2]>>8;
						usb_left=result[(4-usb_sendover)*254+count_bao_shu-2]<<8;
						epdatar[count_bao_shu]=usb_right|usb_left;
						key8=0;
					}
				}
				else
				{	
					for(count_bao_shu=2;count_bao_shu<256;count_bao_shu++)
					{
						usb_right=result[(4-usb_sendover)*254+count_bao_shu-2]>>8;
						usb_left=result[(4-usb_sendover)*254+count_bao_shu-2]<<8;
						epdatar[count_bao_shu]=usb_right|usb_left;
					}
				}
				
				SX2_FifoWrite(ENDPOINT6,&epdatar[0],Fifolong);
			

					while(1)
				{
					
					Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
					if(FifoStatus68 ==0x66)
					break;
				}
			}
		   	/*¹ØÓÚsetupÖÐ¶ÏµÄ´¦Àí*/
		
		}/*×Ô¾Ùºó½øÐÐÖ÷³ÌÐòµÄÑ­»·*/
 
	
	
	 
	 key8=0;

  }
			else if(x==2)
			{
				GUILCD_clear();
				menu_4();
				bz=34;//½øDAÖÐ¶Ï
				x=0;
				key8=0;
				choice=2;
			}                                  
}
}
	
	key5=1;
	key8=1;
	read_over=0;

		
	EvaRegs.T1CON.bit.TPS=4;

	while(can!=6)
    {
 if(count_display == 0)
            {
                count_display = 20;
//                GUILCD_clear();
//                menu_4();
              
//                min_k = 0;
//				max_k = 0;
//				mean_k = 0;
				read_over=0;
//				bz = 33;
                AD_read();
                result_calculate();             
				change_result=(result_max - result_min)*1.37931+10.34483;

                GUILCD_writeCharStr(0x03,0x02,change_result / 10000 % 10,FALSE);
                GUILCD_writeCharStr(0x03,0x03,change_result / 1000 % 10,FALSE);
                GUILCD_writeCharStr(0x03,0x04,change_result / 100 % 10,FALSE);
                GUILCD_writeCharStr(0x03,0x05,change_result / 10 % 10,FALSE);
                GUILCD_writeCharStr(0x03,0x06,change_result % 10,FALSE);


                GUILCD_writeCharStr(0x05,0x02,result_max / 1000 % 10,FALSE);
                GUILCD_writeCharStr(0x05,0x03,result_max / 100 % 10,FALSE);
                GUILCD_writeCharStr(0x05,0x04,result_max / 10 % 10,FALSE);
                GUILCD_writeCharStr(0x05,0x05,result_max % 10,FALSE);

                GUILCD_writeCharStr(0x06,0x02,threshold / 1000 % 10,FALSE);
                GUILCD_writeCharStr(0x06,0x03,threshold / 100 % 10,FALSE);
                GUILCD_writeCharStr(0x06,0x04,threshold / 10 % 10,FALSE);
                GUILCD_writeCharStr(0x06,0x05,threshold % 10,FALSE);

 				

                GUILCD_writeCharStr(0x07,0x02,measure_f / 1000000 % 10,FALSE);
                GUILCD_writeCharStr(0x07,0x03,measure_f / 100000 % 10,FALSE);
                GUILCD_writeCharStr(0x07,0x04,measure_f / 10000 % 10,FALSE);
                GUILCD_writeCharStr(0x07,0x05,measure_f / 1000 % 10,FALSE);
                GUILCD_writeCharStr(0x07,0x06,measure_f / 1000 %10,FALSE);
				GUILCD_writeCharStr(0x07,0x08,measure_f / 10 % 10,FALSE);
                GUILCD_writeCharStr(0x07,0x09,measure_f % 10,FALSE);


            }
			bz = 34;
            fang();
            if(x != 0)
            {
                can= x;
                a++;
                x = 0;

            }
            count_display --;
        }

    //IER=0;
    
    //if(can==6)
    //{asm(" BF main,UNC");} 
    bz=34;


	
}
}



   
   
void f11()
{           
	fir.order=FIR_ORDER; 
    fir.dbuffer_ptr=dbuffer;
    fir.coeff_ptr=(long *)coeff11;
    fir.init(&fir);
           
            
}
 void f12()
{
    fir.order=FIR_ORDER; 
    fir.dbuffer_ptr=dbuffer;
    fir.coeff_ptr=(long *)coeff12; 
    fir.init(&fir);
}
 void f13()
{
	fir.order=FIR_ORDER; 
    fir.dbuffer_ptr=dbuffer;
    fir.coeff_ptr=(long *)coeff13; 
    fir.init(&fir);
}


void  f21()
{
	iir.qfmat=IIR16_LPF_QFMAT;
    iir.nbiq=IIR16_LPF_NBIQ; 
    iir.isf=IIR16_LPF_ISF; 
	iir.dbuffer_ptr=dbuffer1;    
    iir.coeff_ptr=(int *)coeff21; 
    iir.init(&iir);
} 

void  f22()
{ 
	iir.qfmat=IIR16_HPF_QFMAT;
    iir.nbiq=IIR16_HPF_NBIQ; 
    iir.isf=IIR16_HPF_ISF;     
    iir.dbuffer_ptr=dbuffer1;    
    iir.coeff_ptr=(int *)coeff22; 
         
    iir.init(&iir);
}   
void  f23()
{
	iir.qfmat=IIR16_BPF_QFMAT;
    iir.nbiq=IIR16_BPF_NBIQ; 
    iir.isf=IIR16_BPF_ISF; 
    iir.dbuffer_ptr=dbuffer1;    
    iir.coeff_ptr=(int *)coeff23; 
        
    iir.init(&iir);
        
}   
 
        
  
/* void f32()
 {  EvaRegs.T1PR=167;//ÉèÖÃ²ÉÑùÆµÂÊ27.9k
 }*/
  
  
  
	
	  
void InitSystem(void)
    {
        EALLOW;
        SysCtrlRegs.WDCR=0x00E8;        //½ûÖ¹¿´ÃÅ¹·Ä£¿é
        SysCtrlRegs.PLLCR.bit.DIV=10;    //½«CPUµÄPLL±¶ÆµÏµÊýÉèÎª5
        
        SysCtrlRegs.HISPCP.all=0x1;      //¸ßËÙÊ±ÖÓµÄÔ¤¶¨±êÆ÷ÉèÖÃ³É³ýÒÔ2
        SysCtrlRegs.LOSPCP.all=0x2;      //µÍËÙÊ±ÖÓµÄÔ¤¶¨±êÆ÷ÉèÖÃ³É³ýÒÔ4
        
        
        //¸ù¾ÝÐèÒªÊ±ÄÜ¸÷ÖÖÍâÉèÄ£¿éµÄÊ±ÖÓ
        SysCtrlRegs.PCLKCR.bit.EVAENCLK=1;
        SysCtrlRegs.PCLKCR.bit.EVBENCLK=0;
        SysCtrlRegs.PCLKCR.bit.SCIAENCLK=1;
        SysCtrlRegs.PCLKCR.bit.SCIBENCLK=0;
        SysCtrlRegs.PCLKCR.bit.MCBSPENCLK=0;
        SysCtrlRegs.PCLKCR.bit.SPIENCLK=0;
        SysCtrlRegs.PCLKCR.bit.ECANENCLK=0;
        SysCtrlRegs.PCLKCR.bit.ADCENCLK=1;
        EDIS;
     }


void SCI_Init(void)
	{
		SciaRegs.SCICCR.bit.STOPBITS=0;
		SciaRegs.SCICCR.bit.PARITYENA=0;
		SciaRegs.SCICCR.bit.LOOPBKENA=0;
		SciaRegs.SCICCR.bit.ADDRIDLE_MODE=0;
		SciaRegs.SCICCR.bit.SCICHAR=7;
		SciaRegs.SCICTL1.bit.TXENA=1;
		SciaRegs.SCIHBAUD=0;
		SciaRegs.SCILBAUD=0xF3;
		SciaRegs.SCICTL1.bit.SWRESET=1;

	}

	
int SciaTx_Ready(void)
{
	unsigned int u;
	if(SciaRegs.SCICTL2.bit.TXRDY==1)
	{
		u=1;
	}
	else
	{
		u=0;
	}
	return(u);
} 
   
   
void Scia_Send(void)
{
	unsigned int  stop=0,q=0;
	Send_Flag=1;
	for(;stop!=1;)					//·¢Êý¾Ý
	{
		if((SciaTx_Ready()==1)&&(Send_Flag==1))
		{
			SciaRegs.SCITXBUF=result[q];
			result[q]=0;	
			q++;
			if(q>=1024)
			{
				q=0;
				stop=1;	
				Send_Flag=0;
			}
		}
	}
}
    

      
interrupt void adc_isr(void)
{	
	EALLOW;
    GpioDataRegs.GPASET.all = 0xFFFF;   
    switch(bz)
	{
    	case 9:  FIRZ();break;
        case 10: FIRZ();break;
        case 11: FIRZ();break;
        
        case 17: IIRZ();break;
        case 18: IIRZ();break;
        case 19: IIRZ();break;
            
        case 24: FFTZ();break;
		case 33: AD_read();break;
		case 34: AD_DA();break;
        //case 26: FFTZ();break;
        default:break;
    }
         
        //ÖØÐÂ³õÊ¼»¯ADC²ÉÑùÐòÁÐ
    AdcRegs.ADCTRL2.bit.RST_SEQ1=1;  //¸´Î»SEQ1  
    AdcRegs.ADCST.bit.INT_SEQ1_CLR=1; //Çå³ýÖÐ¶ÏÎ»INT SEQ1
    PieCtrlRegs.PIEACK.all=PIEACK_GROUP1; //Çå³ýPIE1µÄÖÐ¶ÏÏìÓ¦Î»
    GpioDataRegs.GPACLEAR.all = 0xFFFF;
    //GpioDataRegs.GPADAT.bit.GPIOA1 = 1;
    EDIS;
}
     


void KeyValue(unsigned int k)	
{	
	if(GpioDataRegs.GPBDAT.bit.GPIOB10 == 1)
	{	
		flag[3*k-3] = 0; 	
	}
	else
	{
		if(flag[3*k-3] == 0)
		{
			x = 3*k-2;
			flag[3*k-3] = 1;
			
		}
	}
	
	if(GpioDataRegs.GPBDAT.bit.GPIOB9== 1)		
	{	
		flag[3*k-2] = 0; 	
	}
	else
	{
		if(flag[3*k-2] == 0)
		{
			if(k==50)
			{
				x=0;
				flag[3*k-2] = 1;
			}
			else
			{
				x = 3*k-1;
				flag[3*k-2] = 1;
			}
		}
	}
	
	if(GpioDataRegs.GPBDAT.bit.GPIOB8 == 1)		
	{	
		flag[3*k-1] = 0; 	
	}
	else
	{
		if(flag[3*k-1] == 0)
		{
			x = 3*k;
			flag[3*k-1] = 1;
			
		}
	}

	if((GpioDataRegs.GPBDAT.bit.GPIOB7== 1))		
	{	
		flag[k+8] = 0; 	
	}
	else
	{
		if(flag[k+8] == 0)
		{
			x = k+9;
			flag[k+8] = 1;
		
		}
	}
}         			                 		
     		

void AD_read()
{	
	result[number]=AdcRegs.ADCRESULT0>>4;
// 	result[number]-=2047;
//	result[number]=result[number]>>8;
	number++;
	if(number>=1024)
		{
		number=0;
		bz=0;
		read_over=1;
		}
}
void AD_read_2()
{	
	result[number]=AdcRegs.ADCRESULT0>>4;
// 	result[number]-=2047;
//	result[number]=result[number]>>8;

	number++;
	if(number>=1024)
		{
		number=0;
		bz=34;
		read_over=0;
		}
}

void AD_DA()
{
	GpioDataRegs.GPBDAT.bit.GPIOB3 = 1;          
	xn=AdcRegs.ADCRESULT0;//>>8;
    result1=AdcRegs.ADCRESULT0;
	GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
	* DAOUT=xn;


}




void input_display()
{	
		int copy_x=0;
		int copy_count=0;
		adfreq[count_ad]=x;
		if(count_ad==5)
		{
			copy_x=adfreq[0];
			copy_count=0;
		}
		else
		{
			copy_x=adfreq[count_ad+1];
			copy_count=count_ad+2;
		}
		count_ad=count_ad+1;
		wr_hex(x,0x012,0x05+count_ad*2,FALSE);
		wr_hex(31,0x012,0x05+14,FALSE);
		wr_hex(copy_x,0x012,0x05+copy_count*2,1);
		if(count_ad>=6)count_ad=0;
}



void FIRZ()
{  
	xn=AdcRegs.ADCRESULT0>>4;
    xn-=2047;
    xn=xn<<4;
         
    fir.input=xn; 
    GpioDataRegs.GPBDAT.bit.GPIOB3 = 1;          
    fir.calc(&fir);
    yn=fir.output;
    yn+=32768;
    GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
    // dlog.update(&dlog);
    * DAOUT=yn;
}
    
void IIRZ()
{    
	xn=AdcRegs.ADCRESULT0>>4;
    xn-=2047;
    xn=xn<<4;

           
    iir.input=xn; 
    GpioDataRegs.GPBDAT.bit.GPIOB3 = 1;          
    iir.calc(&iir);
    yn=iir.output+32768;
    GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
    //dlog.update(&dlog);
    * DAOUT=yn;
}

void FFTZ()
{       
	xn=AdcRegs.ADCRESULT0>>4;
    xn-=2047;
    xn=xn<<4;
    yn=0;
           
    // dlog.update(&dlog);
    acq.input=((unsigned long)xn)<<16;
    acq.update(&acq);   

    if (acq.acqflag==0)     // If the samples are acquired      
    {   
    	GpioDataRegs.GPBDAT.bit.GPIOB3 = 1;
	   // * DAOUT=0;
        CFFT32_brev2(ipcb,ipcb,N);
        CFFT32_brev2(ipcb,ipcb,N);  // Input samples in Real Part
                
        fft.win(&fft);      
        CFFT32_brev2(ipcb,ipcb,N);
        CFFT32_brev2(ipcb,ipcb,N);  // Input after windowing    
        fft.izero(&fft); 
        fft.calc(&fft);
        
        fft.mag(&fft);
        GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
        if(i==0)
        {
        	for(c=1;c<1024;c++)
        	{
            	mag[c]=1.3*mag[c]; 
                shuchu1[c]=((unsigned int)(mag[c]>>6));
            }
            shuchu1[0]=0xffff;
            * sram_control=0x15;
            i=1;
        }
                
                
        else
        {
        	for(c=1;c<1024;c++)
            {
                mag[c]=1.3*mag[c]; 
                shuchu0[c]=((unsigned int)(mag[c]>>6));
            }
                
            shuchu0[0]=0xffff;
            * sram_control=0x14;
            i=0;
        }
       // * DAOUT=0xFFFF; 
        // GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
        acq.acqflag=1;      // Enable the next acquisition          
	}  
}




//********************USBÏà¹Øº¯Êý******************************//
/*Load_descriptors°Ñdescriptor¼ÓÔØµ½usb¼Ä´æÆ÷*/
BOOL Load_descriptors(char length, char* desc)
{
	unsigned char i;
	/* write LSB of descriptor length,and the address of the Descriptor */
	if(!Write_SX2reg(SX2_DESC, (unsigned int)length))
	{
		return FALSE;
	}

	/* write high nibble of MSB of descriptor length */
	SX2_comwritebyte((unsigned char)(length >> 12));
	//SX2_comwritebyte((unsigned char)(length & 0x00FF));
	
	/* write low nibble of MSB of descriptor length */
	SX2_comwritebyte((unsigned char)((length & 0x0F00)>>8));
	//SX2_comwritebyte((unsigned char)(length>>8));
	
	for(i=0; i<length; i++)
	{
		/* write high nibble of MSB of descriptor length */
		SX2_comwritebyte((desc[i] >> 4));
		/* write low nibble of MSB of descriptor length */
		SX2_comwritebyte((desc[i] & 0x0F));
	}

	return TRUE;
}

/**********************************************************************************/
/*	Function: Write_SX2reg														  */
/*	Purpose:  Writes to a SX2 register											  */
/*	Input:	  addr  - address of register										  */
/*			  value - value to write to address									  */
/*	Output:	  TRUE  on success													  */
/*			  FALSE on failure													  */
/*Write_SX2reg°ÑvalueÐ´µ½µØÖ·ÎªaddrµÄ¼Ä´æÆ÷*/
/**********************************************************************************/
BOOL Write_SX2reg(unsigned char addr, unsigned int value)
{
	unsigned int transovertime = 0 ;
	/*clear the high two bit of the addr*/
	addr = addr & 0x3f;
	/* write register address to the SX2 */
	if(!SX2_comwritebyte(0x80 | addr))
	{
		return FALSE;
	}
	/* write high nibble of register data */
	SX2_comwritebyte((value >> 4) & 0xF);
	/* write low nibble of register data */
	SX2_comwritebyte(value & 0x0F);
	/*wait the ready is ok*/
	transovertime = 0;
	while((*USB_STS & 0x08) == 0 )
	{
		if( transovertime++ > usbtimeout )
		{
			return FALSE;
		}
	}
	/*the write is ok*/
	return TRUE;
}

/**********************************************************************************/
/*	Function: SX2_comwritebyte													  */
/*	Purpose:  Writes to a SX2 command interface									  */
/*	Input:	  value - value to write to address									  */
/*	Output:	  TRUE  on success													  */
/*			  FALSE on failure													  */
/*°ÑvalueÐ´µ½USB_COMMAND¿Ú*/
/**********************************************************************************/
BOOL SX2_comwritebyte(unsigned int value)
{
	unsigned int time_count = 0;
	/*wait the ready is ok*/
	while((*USB_STS & 0x08) ==0 )
	{
		if( time_count++ > usbtimeout )
		{
			return FALSE;
		}
	}
	*USB_COMMAND = value;
	/*the write is ok*/
	return TRUE;
}

/**********************************************************
*
*	Function: Read_SX2reg
*	Purpose:  Reads a SX2 register
*	Input:	  addr  - address of register
*			  value - value read from register
*	Output:	  TRUE  on success
*			  FALSE on failure
*
*Read_SX2reg°ÑµØÖ·ÎªaddrµÄ¼Ä´æÆ÷¶Áµ½value
***********************************************************/

BOOL Read_SX2reg(unsigned char addr, unsigned int *value)
{
	unsigned int transovertime = 0;
	/*READYÊÇ·ñ×¼±¸Ã£¬ÑÓÊ±Ê±¼äµ½£¬·µ»Ø*/
	while((*USB_STS & 0x08) == 0 )
	{
		if( transovertime++ > usbtimeout )
		{
			return FALSE;
		}
	}
	/*clear the high two bit of the addr*/
	addr = addr & 0x3f;
	/* write 'read register' command to SX2 */
	*USB_COMMAND = 0xC0 | addr;

	/* set read flag to indicate to the interrupt routine that we
	   are expecting an interrupt to read back the contents of the
	   addressed register. The interrupt latency of the SX2 is in
	   tens of microseconds, so it's safe to write this flag after
	   the initial 'read' byte is written.  */
	/*ÉèÖÃ¶Á±êÖ¾£¬Í¨ÖªÖÐ¶Ï³ÌÐò²»×ö´¦Àí¶ÁÖÐ¶Ï£¬Ö»Òª·µ»Ø±êÖ¾Îª¼Ù¾Í¿ÉÒÔÁË*/
	readFlag = 1;
	//SX2_Clc = *USB_COMMAND;

	/* wait for read flag to be cleared by an interrupt */
	/*µÈ´ý¶Á±êÖ¾Îª¼Ù*/
	while(1)
	{
		if(readFlag == 0)
		{
			break;
		}
		else
		{
			transovertime = 0;
		}
	}
	
	/*wait the ready is ok*/
	while((*USB_STS & 0x08) == 0 )
	{
		if( transovertime++ > usbtimeout )
		{
			return FALSE;
		}
	}
	/*¶ÁÈ¡¼Ä´æÆ÷ÄÊý¾Ý*/
	*value = *USB_COMMAND;
	return TRUE;
}

/*********************************************************/
/*                                                       */
/*	Function: SX2_FifoWrite                              */
/*	Purpose:  write buffer to sx2fifo                    */
/*	Input:	  channel,the endpoint you select			 */
/*			  pdata - the pointer to databuffer			 */
/*			  longth - the longth of the databuffer      */
/*	Output:	  TRUE  on success                           */
/*			  FALSE on failure							 */
/*														 */
/*********************************************************/

BOOL SX2_FifoWrite(int channel,unsigned int *pdata,unsigned length)
{
	unsigned int i = 0;
		if(channel == ENDPOINT2)
		{
			for(i = 0;i<length;i++)
			{
				*USB_FIFO2 = pdata[i];
			}
		}
		else if(channel == ENDPOINT4)
		{
			for(i = 0;i<length;i++)
			{
				*USB_FIFO4 = pdata[i];
			}
		}
		else if(channel == ENDPOINT6)
		{
			for(i = 0;i<length;i++)
			{
				*USB_FIFO6 = pdata[i];  
			} 
		}
		else if(channel == ENDPOINT8)
		{
			for(i = 0;i<length;i++)
			{
				*USB_FIFO8 = pdata[i]; 
			}
		}
/*		if(!SX2_FifoWriteSingle(channel,pdata[i]))
		{
			return FALSE;
		}*/
	return TRUE;	
}

BOOL SX2_FifoWriteSingle(int channel1,unsigned int pdata1)
{
	if(channel1 == ENDPOINT2)
	{
		*USB_FIFO2 = pdata1;
		return(TRUE);
	}
	else if(channel1 == ENDPOINT4)
	{
		*USB_FIFO4 = pdata1;
		return(TRUE);
	}
	else if(channel1 == ENDPOINT6)
	{
		*USB_FIFO6 = pdata1;   
		return(TRUE);
	}
	else if(channel1 == ENDPOINT8)
	{
		*USB_FIFO8 = pdata1;
		return(TRUE);
	}
	return(FALSE);
}

unsigned int SX2_FifoReadSingle(int channel1)
{
	unsigned int pdata1;
	if(channel1 == ENDPOINT2)
	{
		pdata1 = *USB_FIFO2;
	}
	else if(channel1 == ENDPOINT4)
	{
		pdata1 = *USB_FIFO4;
	}
	else if(channel1 == ENDPOINT6)
	{
		pdata1 = *USB_FIFO6;   
	}
	else if(channel1 == ENDPOINT8)
	{
		pdata1 = *USB_FIFO8;
	}
	return(pdata1);
}

interrupt void XINT2_ISR_A(void)
{
		
		/* during a read, an interrupt occurs after the host 
	   CPU requests a register value to read. The host CPU 
	   then reads the data from the SX2 */
		if(readFlag == 1)
		{
			readFlag = 0;
		}
	/* setup's are a special case. Whenever we get a setup 
	   the next eight interrupts represent the data of the
	   setup packet */
		else if(setupDat)
		{
			/* read the setup data */
			setupBuff[setupCnt++] = *USB_COMMAND;

			/* stop when we have collected eight bytes */
			if(setupCnt > 7)
			{
				setupDat = FALSE;
				sx2Setup = TRUE;
			}
			else
			{
				*USB_COMMAND = 0xC0 | SX2_SETUP;
			}
	     	}
		    /* if this is a new request, then we have to read the
		 value and parse the interrupt value. The value 
		 can't be parsed in the main loop, otherwise we could
		 get two interrupts back to back and trash the first 
		 one in the series. */
		 else
		 {
			/* read the interrupt register value */
			//irqValue = *USB_COMMAND;
			irqValue = *USB_COMMAND;

			switch(irqValue)
			{
				case SX2_INT_SETUP:
					/* endpoint 0 setup */
					/* next eight interrupts are setup data */
					/* parse the interrupt register value */		
					setupDat = TRUE;			
					setupCnt = 0;
					/* send read register command to SX2 */
					*USB_COMMAND = 0xC0 | SX2_SETUP;
					break;
		
				case SX2_INT_EP0BUF:
					/* endpoint 0 ready */
					sx2EP0Buf = TRUE;
					break;
		
				case SX2_INT_FLAGS:
					/* FIFO flags -FF,PF,EF */
					FLAGS_READ = TRUE;
					break;
		
				case SX2_INT_ENUMOK:
					/* enumeration successful */
					sx2EnumOK = TRUE;
					break;
		
				case SX2_INT_BUSACTIVITY:
					/* detected either an absence or resumption of activity on the USB bus.	 */
					/* Indicates that the host is either suspending or resuming or that a 	 */
					/* self-powered device has been plugged into or unplugged from the USB.	 */
					/* If the SX2 is bus-powered, the host processor should put the SX2 into */ 
					/* a low-power mode after detecting a USB suspend condition.			 */
					sx2BusActivity = TRUE;
					break;
				case SX2_INT_READY:
					/* awakened from low power mode via wakeup pin */
					/* or completed power on self test */
					sx2Ready = TRUE;
					break;
		
				default:
					break;
			}
	  	}
	PieCtrlRegs.PIEACK.bit.ACK1 = 1;
	EINT;
	//ERTM;
}

      


