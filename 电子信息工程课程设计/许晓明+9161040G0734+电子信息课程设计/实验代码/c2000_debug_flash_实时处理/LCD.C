/*************************************************************************
	filename	LCD.c
	designer	戴展波
	date		2004/12/31
*************************************************************************/
#include "DSP281x_Device.h"
#include "LCD.h"

#ifndef bool
#define bool unsigned short
#define FALSE 0
#define TRUE  1
#endif

/***************************************************************************
*	函数:	void wr_data(unsigned int data)
*	目的：	写LCD数据参数,判断0和1位
*	输入：	dat1 参数单元
*	输出：	无
*	参数：	status局部变量，用来存储LCD的状态量
***************************************************************************/

void wr_data(unsigned int dat1)
{
	unsigned int status;
	do
	{	
		status = *c_addr & 0x03;		/* 屏蔽status的2~15位为0 */
	}while(status != 0x03);
	*d_addr = dat1;
}

/***************************************************************************
*	函数:	void wr_data1(unsigned int dat1)
*	目的：	写LCD数据参数,判断3位
*	输入：	dat1 参数单元
*	输出：	无
*	参数：	status局部变量，用来存储LCD的状态量
***************************************************************************/

void wr_data1(unsigned int dat1)
{
	unsigned int status;
	do
	{
		status = *c_addr & 0x08;		/* 屏蔽status的0~2和3~15位为0 */
	}while(status != 0x08);
	*d_addr = dat1;
}

/***************************************************************************
*	函数:	void wr_com(WORD com)
*	目的：	写LCD指令参数
*	输入：	com 指令单元
*	输出：	无
*	参数：	status局部变量，用来存储LCD的状态量
***************************************************************************/

void wr_com(unsigned int com)
{
	unsigned int status;
	do
	{	
		status = *c_addr & 0x03;
	}while(status != 0x03);
	*c_addr = com;
}

/***************************************************************************
*	函数:	extern void GUILCD_init(void)

*	目的：	初始化LCD显示，设置显示方式为图形方式，开显示

*	输入：	无

*	输出：	无
****************************************************************************/

extern void GUILCD_init(void)
{
	wr_data(0x00);		/*设置图形显示区域首地址*/	
	wr_data(0x00);		/*或为文本属性区域首地址*/
	wr_com(0x42);
	
	wr_data(0x20);		/*设置图形显示区域宽度*/
	wr_data(0x00);		/*或为文本属性区域宽度*/
	wr_com(0x43);
	
	wr_com(0xa0);		/*光标形状设置*/
	
	wr_com(0x81);		/*显示方式设置，逻辑或合成*/
	
	wr_com(0x9b);		/*显示开关设置，仅文本开显示*/
	
}

/***************************************************************************
*	函数:	extern void GUILCD_clear(void)

*	目的：	清LCD屏，用自动方式，将LCD屏清为白屏

*	输入：	无

*	输出：	无

	参数：	page0局部变量
***************************************************************************/

extern void GUILCD_clear(void)
{
	int page0;

	wr_data(0x00);		/*设置显示RAM首地址*/	
	wr_data(0x00);
	wr_com(0x24);
	
	wr_com(0xb0);		/*设置自动写方式*/
	
	for(page0 = 0x2000; page0 >= 0; page0--)
	{
		wr_data1(0x00);		/* 清0 */
	}
	
	wr_com(0xb2);		/* 自动写结束 */
}




/***************************************************************************
*	函数:	void wr_hex(unsigned int code,unsigned int o_y,unsigned int o_x,bool fanxian)
*	目的：	写汉字，将汉字区位代码中的字写入X和Y位置，可以设置为反显
*	输入：	code	汉字区位代码
		o_y	y坐标，范围0~7
		o_x	x坐标，范围0~14
		fanxian 反显 0：无 1：反显
*	输出：	无
***************************************************************************/
void wr_hex(unsigned int code,unsigned int o_y,unsigned int o_x,unsigned short fanxian)
{
	unsigned int dat1_temp,dat2_temp;
	unsigned int *code_temp;
	int i1,i2;
	unsigned int zimu_conv[32];
	unsigned int hex_code[32];
	

	for(i1 = 0; i1 <32; i1++)
	{
		zimu_conv[i1] = zimu[32*code + i1];
	}
	
	for(i2 = 0; i2 < 32; i2++)
	{
		if(fanxian == FALSE)			/* 是否反显 */
		{
			hex_code[i2] = zimu_conv[i2];
		}
		else
		{
			hex_code[i2] = (~zimu_conv[i2]) & 0xff;
		}
	}
	
	i1 = o_y * 0x20;
	i1 = i1 + o_x;
	dat1_temp = i1 & 0xff;
	dat1_temp = dat1_temp ;
	dat2_temp = (i1>>8) & 0xff;
	dat2_temp = dat2_temp;
	code_temp = &hex_code[0];
	
	for(i2 = 0; i2 < 16 ; i2++)
	{
		wr_data(dat1_temp);			/* 汉字点阵在LCD中的位置 */
		wr_data(dat2_temp);
		wr_com(0x24);
			
		wr_data(*(code_temp+i2*2));			/* 写入汉字点阵 */
		wr_com(0xc0);
		
		wr_data(*(code_temp+i2*2+1));
		wr_com(0xc0);
		
		//code_temp++;
		i1 = i1 + 0x20;
		dat1_temp = i1 & 0xff;
		dat2_temp = (i1>>8) & 0xff;		/* 修改汉字点阵在LCD中的位置 */
	}
}


void plot(unsigned int x, unsigned int y)
{
	unsigned int index = y*32+13*2;
	unsigned int z = 0x8000;
	wr_data(index & 0xff);			/* 汉字点阵在LCD中的位置 */
	wr_data((index>>8) & 0xff);
	wr_com(0x24);
	
	//while(x & z){
	//	x &= z;
	//	z=z<<1;
	//}
	z=z>>(x-1);
	wr_data((z>>8) & 0xff);			/* 写入汉字点阵 */
	wr_com(0xc0);
	
	//wr_data(z & 0xff);
	//wr_com(0xc0);
}


/***************************************************************************
*	函数:	extern void GUILCD_writeCharStr(unsigned int Row, unsigned int Column, unsigned char *cString ,bool fanxian)
*	目的：	写汉字字符串，将函数传递的字符串放在LCD屏的ROW行和COLUMN列的位置显示
			自动写屏，直到字符串尾，判断为0停止。根据变量fanxi是否为0，
			决定当前字符串是否反显。显示位置从LCD屏的ROW行和COLUMN列的位置开始，
			为行显示，既ROW不变，COLUMN加1变化。
*	输入：	//string	代码字符串
		location	汉字在hanzi[]中的位置
		ROW	汉字行，范围(0到7),代表字符串起始Y位置
		COLUMN	汉字列，范围(0到14)，代表字符串起始X位置
		fanxian 反显 0：无 非0：反显
*	输出：	无
***************************************************************************/
extern void GUILCD_writeCharStr(unsigned int Row, unsigned int Column, unsigned int location ,unsigned short fanxian)
{
//	unsigned int ii1,ii4;
//	ii4 = 0;
	//ii1 = *cString;
	//while(ii1 != 0)				/* 判断字符串是否结束 */
	{
		wr_hex(location,Row*0x10,Column*2,fanxian);	/* 写汉字 */
		//Column++;				/* 列位置+1 */
		//ii4++;
		//ii1 = *(cString + ii4);		/* 读字符串内的值 */
	}
}







/***************************************************************************
*	函数:	extern void GUILCD_onLed(void)
*	目的：	开背光灯
			
*	输入：	无
			
*	输出：	无
*	参数：	无全局变量
***************************************************************************/
extern void GUILCD_onLed(void)
{
//	asm(" ssbx XF");
}

/***************************************************************************
*	函数:	extern void GUILCD_offLed(void)
*	目的：	关背光灯
			
*	输入：	无
			
*	输出：	无
*	参数：	无全局变量
***************************************************************************/
extern void GUILCD_offLed(void)
{
//	asm(" rsbx XF");
}


extern void menu_2(void)
{
  
GUILCD_writeCharStr(0x00,0x00,10,FALSE);//请选择
	GUILCD_writeCharStr(0x00,0x01,11,FALSE);
	GUILCD_writeCharStr(0x00,0x02,12,FALSE);
	GUILCD_writeCharStr(0x00,0x03,4,FALSE);
	GUILCD_writeCharStr(0x02,0x00,1,FALSE);//1
	GUILCD_writeCharStr(0x02,0x02,13,FALSE);//fir
	GUILCD_writeCharStr(0x02,0x03,14,FALSE);
	GUILCD_writeCharStr(0x03,0x00,2,FALSE);//2
	GUILCD_writeCharStr(0x03,0x02,15,FALSE);//iir
	GUILCD_writeCharStr(0x03,0x03,16,FALSE);
	GUILCD_writeCharStr(0x04,0x00,3,FALSE);//3
	GUILCD_writeCharStr(0x04,0x02,17,FALSE);//fft
	GUILCD_writeCharStr(0x04,0x03,18,FALSE);
	GUILCD_writeCharStr(0x05,0x00,4,FALSE);//4
	GUILCD_writeCharStr(0x05,0x02,55,FALSE);//AD
	GUILCD_writeCharStr(0x05,0x03,56,FALSE);

}

extern void menu_3(void)
{
    GUILCD_writeCharStr(0x00,0x00,10,FALSE);//请选择
	GUILCD_writeCharStr(0x00,0x01,11,FALSE);
	GUILCD_writeCharStr(0x00,0x02,12,FALSE);
	
    GUILCD_writeCharStr(0x02,0x00,1,FALSE);//1
    GUILCD_writeCharStr(0x02,0x02,24,FALSE);//低通
    GUILCD_writeCharStr(0x02,0x03,25,FALSE);
    GUILCD_writeCharStr(0x02,0x05,23,FALSE);//wn
    GUILCD_writeCharStr(0x02,0x06,28,FALSE);//=
    GUILCD_writeCharStr(0x02,0x07,33,FALSE);//0.
    GUILCD_writeCharStr(0x02,0x08,3,FALSE);//3
    
    GUILCD_writeCharStr(0x03,0x00,2,FALSE);//2
    GUILCD_writeCharStr(0x03,0x02,26,FALSE);//高通
    GUILCD_writeCharStr(0x03,0x03,25,FALSE);
    GUILCD_writeCharStr(0x03,0x05,23,FALSE);//wn
    GUILCD_writeCharStr(0x03,0x06,28,FALSE);//=
    GUILCD_writeCharStr(0x03,0x07,33,FALSE);//0.
    GUILCD_writeCharStr(0x03,0x08,2,FALSE);//2
    
    GUILCD_writeCharStr(0x04,0x00,3,FALSE);//3
    GUILCD_writeCharStr(0x04,0x02,27,FALSE);//带通
    GUILCD_writeCharStr(0x04,0x03,25,FALSE);
    GUILCD_writeCharStr(0x04,0x05,23,FALSE);//wn
    GUILCD_writeCharStr(0x04,0x06,28,FALSE);//=
    GUILCD_writeCharStr(0x04,0x07,33,FALSE);//0.
    GUILCD_writeCharStr(0x04,0x08,36,FALSE);//05
    GUILCD_writeCharStr(0x04,0x09,35,FALSE);//--
    GUILCD_writeCharStr(0x04,0x0a,33,FALSE);//0.
    GUILCD_writeCharStr(0x04,0x0b,2,FALSE);//2
}

extern void menu_1(void)
{
    GUILCD_writeCharStr(0x00,0x00,10,FALSE);//请选择
	GUILCD_writeCharStr(0x00,0x01,11,FALSE);
	GUILCD_writeCharStr(0x00,0x02,12,FALSE);
	GUILCD_writeCharStr(0x02,0x00,1,FALSE);//1
    GUILCD_writeCharStr(0x02,0x02,29,FALSE);//fs
    GUILCD_writeCharStr(0x02,0x03,28,FALSE);//=
    GUILCD_writeCharStr(0x02,0x04,30,FALSE);//20
    GUILCD_writeCharStr(0x02,0x05,31,FALSE);//k
    GUILCD_writeCharStr(0x03,0x00,2,FALSE);//2
    GUILCD_writeCharStr(0x03,0x02,29,FALSE);//fs
    GUILCD_writeCharStr(0x03,0x03,28,FALSE);//=
    GUILCD_writeCharStr(0x03,0x04,43,FALSE);//27
    GUILCD_writeCharStr(0x03,0x05,44,FALSE);//.9
    GUILCD_writeCharStr(0x03,0x06,31,FALSE);//k
}





extern void menu_4(void)
{
    GUILCD_writeCharStr(0x00,0x00,19,FALSE);//正
	GUILCD_writeCharStr(0x00,0x01,20,FALSE);//在
	GUILCD_writeCharStr(0x00,0x02,21,FALSE);//执
	GUILCD_writeCharStr(0x00,0x03,22,FALSE);//行
	GUILCD_writeCharStr(0x02,0x01,37,FALSE);//按
    GUILCD_writeCharStr(0x02,0x02,6,FALSE);//6
    GUILCD_writeCharStr(0x02,0x03,38,FALSE);//返
    GUILCD_writeCharStr(0x02,0x04,39,FALSE);//回
    GUILCD_writeCharStr(0x02,0x05,40,FALSE);//主
    GUILCD_writeCharStr(0x02,0x06,41,FALSE);//界
    GUILCD_writeCharStr(0x02,0x07,42,FALSE);//面

	/*
	GUILCD_writeCharStr(0x03,0x00,55,FALSE);//AD
	GUILCD_writeCharStr(0x03,0x01,56,FALSE);
	GUILCD_writeCharStr(0x03,0x02,48,FALSE);//采
    GUILCD_writeCharStr(0x03,0x03,49,FALSE);//样

	//显示幅度
	GUILCD_writeCharStr(0x04,0x01,67,FALSE);//幅
	GUILCD_writeCharStr(0x04,0x02,68,FALSE);//度

	//显示频率
	GUILCD_writeCharStr(0x05,0x01,65,FALSE);//频
	GUILCD_writeCharStr(0x05,0x02,66,FALSE);//率

	//显示周期
	GUILCD_writeCharStr(0x06,0x01,69,FALSE);//周
	GUILCD_writeCharStr(0x06,0x02,70,FALSE);//期 */

}


extern void menu_5(void)
{
    GUILCD_writeCharStr(0x00,0x00,10,FALSE);//请
	GUILCD_writeCharStr(0x00,0x01,46,FALSE);//输
	GUILCD_writeCharStr(0x00,0x02,47,FALSE);//入
	GUILCD_writeCharStr(0x00,0x03,3,FALSE); //5
	GUILCD_writeCharStr(0x00,0x04,57,FALSE);//位
	GUILCD_writeCharStr(0x00,0x05,48,FALSE);//采
    GUILCD_writeCharStr(0x00,0x06,49,FALSE);//样
    GUILCD_writeCharStr(0x00,0x07,50,FALSE);//频
    GUILCD_writeCharStr(0x00,0x08,51,FALSE);//率
	GUILCD_writeCharStr(0x03,0x00,58,FALSE);//按
	GUILCD_writeCharStr(0x03,0x01,59,FALSE);//E
	GUILCD_writeCharStr(0x03,0x02,60,FALSE);//nt
	GUILCD_writeCharStr(0x03,0x03,61,FALSE);//er
	GUILCD_writeCharStr(0x03,0x04,62,FALSE);//确
	GUILCD_writeCharStr(0x03,0x05,63,FALSE);//认
	wr_hex(0,0x012,0x05+2,1);
	wr_hex(0,0x012,0x05+4,FALSE);
	wr_hex(0,0x012,0x05+6,FALSE);
	//wr_hex(0,0x012,0x05+8,FALSE);
	//wr_hex(0,0x012,0x05+10,FALSE);
	//wr_hex(0,0x012,0x05+12,FALSE);
	wr_hex(31,0x012,0x05+14,FALSE);//Hz
 
}

extern void menu_6(void)
{
	GUILCD_writeCharStr(0x00,0x00,10,FALSE);//请选择
	GUILCD_writeCharStr(0x00,0x01,11,FALSE);
	GUILCD_writeCharStr(0x00,0x02,12,FALSE);
	GUILCD_writeCharStr(0x02,0x00,1,FALSE);//1
    GUILCD_writeCharStr(0x02,0x02,53,FALSE);//保
    GUILCD_writeCharStr(0x02,0x03,54,FALSE);//存
    GUILCD_writeCharStr(0x03,0x00,2,FALSE);//2
    GUILCD_writeCharStr(0x03,0x02,52,FALSE);//不
    GUILCD_writeCharStr(0x03,0x03,53,FALSE);//=保
    GUILCD_writeCharStr(0x03,0x04,54,FALSE);//存
 
}



