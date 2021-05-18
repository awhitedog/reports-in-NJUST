/****************************************************/
/*   ADC 采样频率 9.3KHz							*/
#include <stdlib.h>
#include "type.h"
#include "sx2.h"
#include "descriptors.h"
#include "DEC2812_USB.h" 
#include "ep0req.h"
#include "DPS2812_LCD.h"
#include "DSP281x_Device.h"
void ConfigureGpio(void);
void InitSystem(void);
void SCI_Init(void);
void AD_read(void);
void AD_DA(void);
void input_display(void);
void Scia_Send(void);
void KeyValue(unsigned int k);
unsigned int  Save_keyvalue[2];
unsigned int  adfreq[6]={0,0,0,0,0,0};
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
unsigned int  result_threshold;
#pragma DATA_SECTION(result,"newsect");
unsigned int result[1024];
//unsigned int  aa,bb,cc;
/* Create an instance of DATALOG Module             */
//DLOG_4CH dlog=DLOG_4CH_DEFAULTS;      
//************************USB相关*************************/
int Load_descriptors(char length, char* desc);
int Write_SX2reg(unsigned char addr, unsigned int value);
int SX2_comwritebyte(unsigned int value);
int SX2_FifoWrite(int channel,unsigned int *pdata,unsigned length);
int SX2_FifoWriteSingle(int channel,unsigned int pdata);
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
unsigned int epdataw1[512] ={0};  
unsigned int  epdataw2[512] ={0};
unsigned int irqValue;			 /* interrupt register value */
unsigned int setupBuff[8];		 /* setup transaction buffer */
int sx2Ready;			 /* status byte for POST */ 
int sx2BusActivity;	 /* status byte for suspend */ 
int sx2EnumOK;			 /* status byte for enumeration complete */
int sx2EP0Buf;			 /* status for endpoint 0 buffer */
int sx2Setup;			 /* setup flag set in Int0() ISR */
int FLAGS_READ = 0; /*FIFO的状态读请求*/
unsigned int INT_STATUS;
unsigned int SX2_int;   
unsigned long readFlag;
unsigned int usbtimeout = 0x400;
unsigned int regdataread = 0; 	
unsigned int Fifolong = 0;     /*FIFO的长度*/
unsigned int setupCnt = 0;
unsigned int Usb2or11= 1;    /*USB工作在哪一个标准上*/
unsigned int hshostlink = 0; /*为真是高速USB接口，为假是低速USB接口*/
static int setupDat = FALSE;
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

int c;
int i;
volatile unsigned int* sram_control = (volatile unsigned int *) 0x002D00;
int xn,yn, result,Avg,last_result=32767;
unsigned long q;
unsigned long led_light;
int Freq=0, Period=0, Value=0;//频率计数变量
long int  Freq_time=0;
int result_max=0,result_min=32767;
unsigned int flag_result=1, y_index = 0;


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



void lednum(void)//数码管显示
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


	unsigned int FifoStatus24 = 0;	/*FIFO24的状态标识*/
	unsigned int FifoStatus68 = 0; 	/*FIFO68的状态标识*/

    InitSystem();            //初始化DSP内核寄存器
    InitPieCtrl();             //调用PIE控制单元初始化函数
    InitPieVectTable();         //  调用PIE向量表初始化函数
    InitAdc();
    SCI_Init(); 
    /*初始化GPIO*/
	InitGpio1(); 
    
	InitPeripherals();/* 初始化外设寄存器 */
	GUILCD_init();/*初始化LCD*/
	GUILCD_clear(); //清屏              
   
    
    EALLOW;
    PieVectTable.ADCINT=&adc_isr;    //设置PIE向量表中ADc的中断入口向量
	PieVectTable.XINT2 = &XINT2_ISR_A;
    EDIS;
	
	InitXIntrupt();
    *USB_STS = 0x20;//唤醒CY7C68001，使其正常工作

    PieCtrlRegs.PIEIER1.bit.INTx6=1;     //使能PIE中断分组1中的ADC中断
    
    IER=1;          //使能和ADC中断相连的CPU INT1中断
	IER|=M_INT9;		//使能CPU级中断INT9
	IER |= M_INT1;//开CPU的第一组中断，因为外围中断2属于这一组
    
    EINT;           //使能全局中断位INTM
    ERTM;           // 使能全局实时调试中断DBGM
    
    
    /* SET ADC*/
    AdcRegs.ADCTRL1.bit.SEQ_CASC=0;
    AdcRegs.ADCTRL1.bit.CONT_RUN=0;
    AdcRegs.ADCTRL1.bit.CPS=0;
    AdcRegs.ADCMAXCONV.all=0x0000;         //单通道转换
    AdcRegs.ADCCHSELSEQ1.bit.CONV00=0x0;//将ADCINA0设置为SEQ1的第一个转换通道
    AdcRegs.ADCTRL2.bit.EVA_SOC_SEQ1=1;       //使能EVA引起的中断
    AdcRegs.ADCTRL2.bit.INT_ENA_SEQ1=1;       
    AdcRegs.ADCTRL3.bit.ADCCLKPS=2;       //ADc模块的核心时钟频率=HSPCLK/4
    
    /* SET EVA*/
    EvaRegs.GPTCONA.bit.TCMPOE=0;     //禁止比较输出
    EvaRegs.GPTCONA.bit.T1PIN=0; 
    EvaRegs.GPTCONA.bit.T1TOADC=2;       //设置周期中断标志启动ADC
    EvaRegs.T1CON.bit.FREE=0;    //防真挂起时，定时器1立即停止工作
    EvaRegs.T1CON.bit.SOFT=0;
    EvaRegs.T1CON.bit.TMODE=2;   //连续增计数模式
    EvaRegs.T1CON.bit.TPS=7;     //设置定时器时钟频率为HSPCLK/16
    EvaRegs.T1CON.bit.TENABLE=1;     //允许定时器操作
    EvaRegs.T1CON.bit.TCLKS10=0;     //内部时钟
    EvaRegs.T1CON.bit.TCLD10=0;     //计数器为0时重载
    EvaRegs.T1CON.bit.TECMPR=0;     //禁止比较操作
    EvaRegs.T1PR=234;       //定时器周期寄存器
                            
       
       i=0;
        * sram_control=0x14;  

    /* SET GPIO*/
 	EALLOW;
   	
   	
   	GpioMuxRegs.GPBMUX.all = 0x0;
    GpioMuxRegs.GPBDIR.bit.GPIOB12 = 1;//键盘GPIOB[15：12]输出，[11： 7]回读，书p97，DIR
    GpioMuxRegs.GPBDIR.bit.GPIOB13 = 1;
    GpioMuxRegs.GPBDIR.bit.GPIOB14 = 1;
    GpioMuxRegs.GPBDIR.bit.GPIOB15 = 1;

    GpioMuxRegs.GPBDIR.bit.GPIOB11 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB10 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB9 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB8 = 0;
    GpioMuxRegs.GPBDIR.bit.GPIOB7 = 0;

    GpioMuxRegs.GPBDIR.bit.GPIOB3 = 1;//输出，用诓鈌ft时间
    /*二极管设置*/
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
	GpioDataRegs.GPFDAT.bit.GPIOF13 =1; 

	GpioMuxRegs.GPFMUX.bit.SCITXDA_GPIOF4=1;//外设功能TX引脚
//	GpioMuxRegs.GPFDIR.all=0x0;
				

    
  	EDIS;
   	
   	a = 0;
	x = 0;

	
   //EvaRegs.T1CON.bit.TENABLE=1;     //允许定时器操作
while(1)
{ 
    
    can=0;
    lednum();//LED显
    
	GUILCD_clear(); //清屏
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
			
				x = 0;
				key1=1; 
				choice=0;
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

	


	while(choice==0)
	{	

		while(key5)
		{
			fang();
			adfreq_last=0;
			if((x>=0)&&(x<=9))
			{	
				input_display();//输入采样频率			
				x=20;
				q=120000;
				while(q)
				{
					q--;
				}
				
			}
			else if(x==12)
			{
				GUILCD_clear(); //清屏
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
	
		EvaRegs.T1CON.bit.TPS=7;
		adfreq_last=10000*adfreq[0]+1000*adfreq[1]+100*adfreq[2]+10*adfreq[3]+adfreq[4];	
		EvaRegs.T1PR=60000/adfreq_last;
		adfreq[0]=0;
		adfreq[1]=0;
		adfreq[2]=0;
		adfreq[3]=0;
		adfreq[4]=0;
		adfreq[5]=0;
		


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

			/* SX2_int什么含义？什么功能*/ //没用,主要功能打开全局中断 
	for(;;)
    	{
    		if(GpioDataRegs.GPEDAT.bit.GPIOE1 == 1)
    		{
    			InitGpio();
    			// USB命令口地址，USB_COMMAND = 0x2804；
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
		sx2Ready		= 0;	/* false until POST or wakeup */
		sx2BusActivity	= 0;	/* false until absence or resumption of USB bus activity */
		sx2EnumOK		= 0;	/* false until ENUMOK interrupt */
		sx2EP0Buf		= 0;	/* false until EP0BUF interrupt */
		sx2Setup		= 0;	/* false until SETUP interrupt */
		
		/* Initialize global variables specific to this test firmware */
		keepAliveCnt		= 0;

		/* Initialize local variables */
		/* reusable variable for read register data */
	//	regValue			= 0;
		// Load_descriptors:加载指定地址和长度的内容到usb描述符表中
		if(!Load_descriptors(DESCTBL_LEN, &desctbl[0]))
		{
			while(1);
		}
	//	SX2_Clc = *USB_COMMAND;
		/*
		USB_STS = 0x00;
		USB_STS = 0x20;唤醒CY7C68001，使其正常工作
		if(!Load_descriptors(DESCTBL_LEN, &desctbl[0]))
		{
			while(1);
		}		
		
		*/		
	q=500000;
	while(q)
	{
	q--;
	}
		Read_SX2reg(SX2_EP24FLAGS, &FifoStatus24);
		Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
		
		
		/*装载描述表后，等待自举成功*/
		/*装载描述表后，等待自举成功*/ 
		while(1)
		{
			if(sx2EnumOK == 1)
			{
				break;
			}
		}
		//此时等待主机与cypress USB芯片通信中断，通信成功后USB发出一个中断表明自举成功
		

		/*设置当前的接口的形式*/
		Write_SX2reg(SX2_IFCONFIG , 0xE8);
		/*设置当前系统中各使能信号的极性
		  其中SLOE、SLRD、SLWR只能有EEPROM来配置*/
		Write_SX2reg(SX2_FIFOPOLAR, SX2_WUPOL | SX2_EF | SX2_FF);
		/*读取当前工作在哪个USB的标准???    wrong*/
		Read_SX2reg(SX2_FNADDR, &Usb2or11);
		hshostlink = (Usb2or11 & SX2_HSGRANT) ? 1 : 0;//指示工作在高速还是全速状态
		/*初始化USB的工作状态*/
		//if(hshostlink == 1)
		{
			/*工作在2.00标准,设定数字接口为16位，数据包的大小为512字节*/
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
		/*设置FLAGSA为FIFO6的空的标志位；
		  设置FLAGSB为FIFO8的空的标志位；
		  FLAGSC与FLAGSD的状态为默认的状态*/
		Write_SX2reg(SX2_FLAGAB , SX2_FLAGA_FF6 | SX2_FLAGB_FF8); 
		/*清空所有的节点*/
		Write_SX2reg(SX2_INPKTEND, SX2_CLEARALL);
		enum_start=2;
	}



	while(1)
	{
		if(read_over==1)break;
	}  //判断是否采完
			
	//	Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);		
		//if(sx2EnumOK)
		//{
		//	SX2_FifoWrite(ENDPOINT6,&epdatar[0],Fifolong);			
		//}
		//Read_SX2reg(SX2_EP68FLAGS, &Fifostatus);
		
		//Read_SX2reg(SX2_EP68FLAGS, &Fifostatus);  读fifo寄存器来控制是否写入新数组
		/*自举后进行主程序的循环*/
		while(sx2EnumOK&&usb_sendover)
		{
		    usb_sendover--;
		    if(sx2BusActivity==FALSE)
			{
								
				Read_SX2reg(SX2_EP68FLAGS, &FifoStatus68);
			
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
		   	/*关于setup中断的处理*/
		
		}/*自举后进行主程序的循环*/
 
	
	
	 
	 key8=0;

  }
			else if(x==2)
			{
				GUILCD_clear();
				menu_4();
				bz=34;//进DA中断
				x=0;
				key8=0;
				choice=2;
			}                                  
}
}
	
	key5=1;
	key8=1;
	read_over=0;

		
	EvaRegs.T1CON.bit.TPS=7;

	while(can!=6)
    {
     	fang();
	    if(x != 0)
		{
			can= x;
			a++;
			x = 0;
			//result_max=0;
			//result_min=32767;
			
	    }
		Value =( (result_max - result_min)*14.01869-10.2804);
		

		//GUILCD_writeCharStr(0x03,0x0A,result_max%10, FALSE);
		//GUILCD_writeCharStr(0x03,0x09,71,FALSE)
		GUILCD_writeCharStr(0x04,0x04,result_max/10%10, FALSE);
		GUILCD_writeCharStr(0x04,0x03,result_max/100%10, FALSE);
		GUILCD_writeCharStr(0x04,0x02,result_max/1000%10, FALSE);
		GUILCD_writeCharStr(0x04,0x01,result_max/10000%10, FALSE);

		//显示频率
	//	GUILCD_writeCharStr(0x04, 0x0B, 73, FALSE);
		GUILCD_writeCharStr(0x06, 0x05, Freq%10, FALSE);
	//	GUILCD_writeCharStr(0x04, 0x09, 71, FALSE);
		GUILCD_writeCharStr(0x06, 0x03, Freq/10%10, FALSE);
		GUILCD_writeCharStr(0x06, 0x02, Freq/100%10, FALSE);
		GUILCD_writeCharStr(0x06, 0x01, Freq/1000%10, FALSE);

		//显示幅度
		//GUILCD_writeCharStr(0x03, 0x0B, 72, FALSE);
		GUILCD_writeCharStr(0x03, 0x05, Value%10, FALSE);
	//	GUILCD_writeCharStr(0x03, 0x09, 71, FALSE);
		GUILCD_writeCharStr(0x03, 0x03, Value/10%10, FALSE);
		GUILCD_writeCharStr(0x03, 0x02, Value/100%10, FALSE);
		GUILCD_writeCharStr(0x03, 0x01, Value/1000%10, FALSE);

		//显示阈值
	//	GUILCD_writeCharStr(0x06, 0x0B, 74, FALSE);
	//	GUILCD_writeCharStr(0x06, 0x0A, result_threshold%10, FALSE);
	//	GUILCD_writeCharStr(0x06, 0x09, 71, FALSE);
		GUILCD_writeCharStr(0x05, 0x04,  result_threshold/10%10, FALSE);
		GUILCD_writeCharStr(0x05, 0x03,  result_threshold/100%10, FALSE);
		GUILCD_writeCharStr(0x05, 0x02,  result_threshold/1000%10, FALSE);
		GUILCD_writeCharStr(0x05, 0x01,  result_threshold/10000%10, FALSE);


	}
    //IER=0;
    
    //if(can==6)
    //{asm(" BF main,UNC");} 
    bz=0;


	
}
}


	
	  
void InitSystem(void)
    {
        EALLOW;
        SysCtrlRegs.WDCR=0x00E8;        //禁止看门狗模块
        SysCtrlRegs.PLLCR.bit.DIV=10;    //将CPU的PLL倍频系数设为5
        
        SysCtrlRegs.HISPCP.all=0x1;      //高速时钟的预定标器设置成除以2
        SysCtrlRegs.LOSPCP.all=0x2;      //低速时钟的预定标器设置成除以4
        
        
        //根据需要时能各种外设模块的时钟
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
	for(;stop!=1;)					//发数据
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
    	
		case 33: AD_read();break;
		case 34: AD_DA();break;
        //case 26: FFTZ();break;
        default:break;
    }
         
        //重新初始化ADC采样序列
    AdcRegs.ADCTRL2.bit.RST_SEQ1=1;  //复位SEQ1  
    AdcRegs.ADCST.bit.INT_SEQ1_CLR=1; //清除中断位INT SEQ1
    PieCtrlRegs.PIEACK.all=PIEACK_GROUP1; //清除PIE1的中断响应位
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


void AD_DA()
{
	GpioDataRegs.GPBDAT.bit.GPIOB3 = 1;          
	xn=AdcRegs.ADCRESULT0;//>>8;
	result=AdcRegs.ADCRESULT0>>4;
	GpioDataRegs.GPBDAT.bit.GPIOB3 = 0;
	* DAOUT=xn;
	if (result_max<result) result_max=result;
	if (result_min>result) result_min=result;

	/*************测频率***************/
	result_threshold=result_min+(result_max-result_min)*0.8;
	if ( last_result < result_threshold && result>=result_threshold )
	{
		flag_result++;
		if(flag_result>10)
		{
			flag_result=1;
			result_max=result_threshold;
			result_min=result_threshold;
		}
		Freq = adfreq_last*100/Freq_time;
		Freq_time = 1;
	}
	else{Freq_time++;}
	last_result = result;


	//显示波形
/*	if (Freq_time % 20==0){
		y_index++;
		if (y_index>=120){y_index=1;}
		plot((result-(result_min-100))*16/ (result_max-result_min), y_index);
	}
	//plot((result-result_min)*16 / Value, y_index);
	*/
}



void input_display()
{	
		int copy_x=0;
		int copy_count=0;
		adfreq[count_ad]=x;
		if(count_ad==5)
		{
			copy_x=adfreq[0];
			copy_count=1;
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







//********************USB相关函数******************************//
/*Load_descriptors把descriptor加载到usb寄存器*/
int Load_descriptors(char length, char* desc)
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

	return 1;
}

/**********************************************************************************/
/*	Function: Write_SX2reg														  */
/*	Purpose:  Writes to a SX2 register											  */
/*	Input:	  addr  - address of register										  */
/*			  value - value to write to address									  */
/*	Output:	  1  on success													  */
/*			  FALSE on failure													  */
/*Write_SX2reg把value写到地址为addr的寄存器*/
/**********************************************************************************/
int Write_SX2reg(unsigned char addr, unsigned int value)
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
	return 1;
}

/**********************************************************************************/
/*	Function: SX2_comwritebyte													  */
/*	Purpose:  Writes to a SX2 command interface									  */
/*	Input:	  value - value to write to address									  */
/*	Output:	  1  on success													  */
/*			  FALSE on failure													  */
/*把value写到USB_COMMAND口*/
/**********************************************************************************/
int SX2_comwritebyte(unsigned int value)
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
	return 1;
}

/**********************************************************
*
*	Function: Read_SX2reg
*	Purpose:  Reads a SX2 register
*	Input:	  addr  - address of register
*			  value - value read from register
*	Output:	  1  on success
*			  FALSE on failure
*
*Read_SX2reg把地址为addr的寄存器读到value
***********************************************************/

int Read_SX2reg(unsigned char addr, unsigned int *value)
{
	unsigned int transovertime = 0;
	/*READY是否准备茫邮笔奔涞剑祷?/
	while((*USB_STS & 0x08) == 0 )
	{
		if( transovertime++ > usbtimeout )
		{
			return FALSE;
		}
	}
	clear the high two bit of the addr*/
	addr = addr & 0x3f;
	/* write 'read register' command to SX2 */
	*USB_COMMAND = 0xC0 | addr;

	/* set read flag to indicate to the interrupt routine that we
	   are expecting an interrupt to read back the contents of the
	   addressed register. The interrupt latency of the SX2 is in
	   tens of microseconds, so it's safe to write this flag after
	   the initial 'read' byte is written.  */
	/*设置读标志，通知中断程序不做处理读中断，只要返回标志为假就可以了*/
	readFlag = 1;
	//SX2_Clc = *USB_COMMAND;

	/* wait for read flag to be cleared by an interrupt */
	/*等待读标志为假*/
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
			return 0;
		}
	}
	/*读取寄存器氖*/
	*value = *USB_COMMAND;
	return 1;
}

/*********************************************************/
/*                                                       */
/*	Function: SX2_FifoWrite                              */
/*	Purpose:  write buffer to sx2fifo                    */
/*	Input:	  channel,the endpoint you select			 */
/*			  pdata - the pointer to databuffer			 */
/*			  longth - the longth of the databuffer      */
/*	Output:	  1  on success                           */
/*			  FALSE on failure							 */
/*														 */
/*********************************************************/

int SX2_FifoWrite(int channel,unsigned int *pdata,unsigned length)
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
	return 1;	
}

int SX2_FifoWriteSingle(int channel1,unsigned int pdata1)
{
	if(channel1 == ENDPOINT2)
	{
		*USB_FIFO2 = pdata1;
		return(1);
	}
	else if(channel1 == ENDPOINT4)
	{
		*USB_FIFO4 = pdata1;
		return(1);
	}
	else if(channel1 == ENDPOINT6)
	{
		*USB_FIFO6 = pdata1;   
		return(1);
	}
	else if(channel1 == ENDPOINT8)
	{
		*USB_FIFO8 = pdata1;
		return(1);
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
				sx2Setup = 1;
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
					setupDat = 1;			
					setupCnt = 0;
					/* send read register command to SX2 */
					*USB_COMMAND = 0xC0 | SX2_SETUP;
					break;
		
				case SX2_INT_EP0BUF:
					/* endpoint 0 ready */
					sx2EP0Buf = 1;
					break;
		
				case SX2_INT_FLAGS:
					/* FIFO flags -FF,PF,EF */
					FLAGS_READ = 1;
					break;
		
				case SX2_INT_ENUMOK:
					/* enumeration successful */
					sx2EnumOK = 1;
					break;
		
				case SX2_INT_BUSACTIVITY:
					/* detected either an absence or resumption of activity on the USB bus.	 */
					/* Indicates that the host is either suspending or resuming or that a 	 */
					/* self-powered device has been plugged into or unplugged from the USB.	 */
					/* If the SX2 is bus-powered, the host processor should put the SX2 into */ 
					/* a low-power mode after detecting a USB suspend condition.			 */
					sx2BusActivity = 1;
					break;
				case SX2_INT_READY:
					/* awakened from low power mode via wakeup pin */
					/* or completed power on self test */
					sx2Ready = 1;
					break;
		
				default:
					break;
			}
	  	}
	PieCtrlRegs.PIEACK.bit.ACK1 = 1;
	EINT;
	//ERTM;
}

      


