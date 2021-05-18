#include "DSP2833x_Device.h"
#include "DSP2833x_Examples.h"
#include "DSP2833x_Lcd.h"


#include <stdint.h>


volatile Uint16 *LCD_RAM  =     (Uint16 * )0x00203100;     //LCD���ݵ�ַ
volatile Uint16 *LCD_REG  =     (Uint16 * )0x00203100;	   //LCD�����ַ�������ݵ�ַ��ͬ��ͨ���Ĵ����ṩ��D/CX�������������
volatile Uint16 *LCD_Register = (Uint16 * )0x00203000;     //LCD�Ĵ�����ַ

static sFONT *LCD_Currentfonts;
  /*Һ������ǰ��ɫ�ͱ���ɫ*/
static  volatile uint16_t TextColor = 0x0000, BackColor = 0xFFFF;
//static  volatile uint16_t LCD_DeviceID=0;


//Uint16 par0=0,par1=0,par2=0,par3=0,par4=0,par5=0,par6=0;





void LCD_Reset(void)//LCD��λ
{
	*LCD_Register=0x0000;

}
/**************************************************************************************************************
 * ��������LCD_WriteRegister()
 * ����  ��uint8_t LCD_RegisterValue �Ĵ�����ַ, uint16_t LCD_RegisterValue �Ĵ�����ֵ
 * ���  ��void
 * ����  ��дLCD�Ĵ�������
 * ����  ���ⲿ����
**************************************************************************************************************/
void LCD_WriteRegister(uint16_t LCD_RegisterValue)
{
	*LCD_Register=LCD_RegisterValue;
}

/**************************************************************************************************************
 * ��������LCD_WR_REG()
 * ����  : uint16_t regval �Ĵ�����ֵ
 * ���  ��void
 * ����  ��дLCD�Ĵ�������
 * ����  ���ⲿ����
 *****************************************************************************************************************/

void LCD_WR_REG(uint16_t regval)         //д����
{ 
	LCD_WriteRegister(0x0002);//֪ͨFPGA��Ҫ��һ��ָ����д����
	*LCD_REG=regval;       //д��Ҫд�ļĴ������
}
/**************************************************************************************************************
 * ��������LCD_WR_RAM()
 * ����  ��uint16_t data  16bit��ɫ����
 * ���  ��void
 * ����  ����LCD��RAMд����
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_WR_DATA(uint16_t data)
{										    	   
	LCD_WriteRegister(0x0003);//֪ͨFPGA��Ҫ��һ��ָ����д����
	*LCD_RAM=data;
}
/**************************************************************************************************************
 * ��������LCD_WriteReg()
 * ����  ��uint8_t LCD_Reg �Ĵ�����ַ, uint16_t LCD_RegValue �Ĵ�����ֵ
 * ���  ��void
 * ����  ��дLCD�Ĵ�������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_WriteReg(uint16_t LCD_Reg, uint16_t LCD_RegValue)  //��дһ������    ��дһ������
{
	/*д�Ĵ�����ַ*/
  LCD_WriteRegister(0x0002);
  *LCD_REG = LCD_Reg;
   /*д��Ĵ���ֵ*/
  LCD_WriteRegister(0x0003);
  *LCD_RAM = LCD_RegValue;
}
/**************************************************************************************************************
 * ��������LCD_ReadReg()
 * ����  ��uint8_t LCD_Reg ��Ҫ��ȡ�ļĴ�����ַ
 * ���  ��uint16_t �Ĵ�����ֵ
 * ����  ����ȡLCD�Ĵ�����ֵ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
Uint16 LCD_ReadReg(uint16_t LCD_Reg)
{
  /*д�Ĵ�����ַ*/
  LCD_WriteRegister(0x0002);
  *LCD_REG = LCD_Reg;
  /*�����Ĵ���ֵ������*/
  //LCD_WriteRegister(0x0003);
  return (*LCD_RAM);
}

/*
void LCD_DeviceCode(uint16_t LCD_Reg)
{
	LCD_WriteRegister(0x0002);
	*LCD_REG = LCD_Reg;

	  par0=*LCD_RAM;
	  par1=*LCD_RAM;
	  par2=*LCD_RAM;
	  //par3=*LCD_RAM;
	  //par4=*LCD_RAM;
	  //par5=*LCD_RAM;
	  //par6=*LCD_RAM;
}
*/
/**************************************************************************************************************
 * ��������LCD_WriteRAM_Start()
 * ����  ��void
 * ���  ��void
 * ����  ����ʼдLCD��RAM
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_WriteRAM_Start(void)

{
  LCD_WriteRegister(0x0002);
  *LCD_REG = 0x002C;
}
/**************************************************************************************************************
 * ��������LCD_DisplayOn()
 * ����  ��void
 * ���  ��void
 * ����  ��LCD����ʾ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_DisplayOn(void)
{
  /*����ʾ */
  LCD_WriteReg(0x07, 0x0173); /*����LCDΪ262Kɫ������ʾ*/
}

/**************************************************************************************************************
 * ��������LCD_DisplayOff()
 * ����  ��void
 * ���  ��void
 * ����  ��LCD�ر���ʾ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_DisplayOff(void)
{
  /*�ر���ʾ*/
  LCD_WriteReg(0x07, 0x0); 
}


/**************************************************************************************************************
 * ��������LCD_SetCursor()
 * ����  ��uint16_t Xpos, uint16_t Ypos �趨����Ļ��Xֵ��Yֵ
 * ���  ��void
 * ����  ��LCD���ù��λ�ú���
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetCursor(uint16_t Xpos, uint16_t Ypos)
{
	#if HORIZONTAL
  LCD_WR_REG(0x002A);LCD_WR_DATA(Ypos>>8);
  LCD_WR_DATA(0x00FF&Ypos);                 //�趨X����
  LCD_WR_DATA(0x0001);LCD_WR_DATA(0x003F);

  LCD_WR_REG(0x002B);LCD_WR_DATA((480-Xpos)>>8);
  LCD_WR_DATA(0x00FF&(480-Xpos));           //�趨Y����
  LCD_WR_DATA(0x0001);LCD_WR_DATA(0x00df);
	#else
	LCD_WR_REG(0x002A);LCD_WR_DATA(Xpos>>8);
  LCD_WR_DATA(0x00FF&Xpos);                  //�趨X����
  LCD_WR_DATA(0x0001);LCD_WR_DATA(0x003F);

  LCD_WR_REG(0x002B);LCD_WR_DATA(Ypos>>8);
  LCD_WR_DATA(0x00FF&Ypos);                  //�趨Y����
  LCD_WR_DATA(0x0001);LCD_WR_DATA(0x00df);
	#endif
}
/**************************************************************************************************************
 * ��������LCD_Clear()
 * ����  ��void
 * ���  ��void
 * ����  ��LCD��������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_Clear(uint16_t Color)
{
	Uint32 index = 0;

	LCD_SetCursor(0x00,0x0000);	//���ù��λ��

	LCD_WR_REG(0x002C);
	for(index=0;index<153600;index++) LCD_WR_DATA(Color);
}



/**************************************************************************************************************
 * ��������LCD_Init()
 * ����  ��void
 * ���  ��void
 * ����  ��LCD��ʼ������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_Init(void)
{ 
	//LCD_FSMC_Config();
	  //delay_nms(50);

	  *LCD_Register=0x0000;
	  DELAY_US(50000);
	  *LCD_Register=0x0002;
	  DELAY_US(50000);
	  *LCD_Register=0x0000;
	  DELAY_US(50000);


	  LCD_WR_REG(0x0011);          //�˳�˯��ģʽ��0x0010Ϊ����
	  DELAY_US(50000);

	  LCD_WR_REG(0x0013);			//������ͨ��ʾģʽ
	  DELAY_US(50000);

	  LCD_WR_REG(0x00D0);          //���õ�Դ����������3������
	  LCD_WR_DATA(0x0007);         //1.0xVci
	  LCD_WR_DATA(0x0040);         //
	  LCD_WR_DATA(0x001c);         //

	  LCD_WR_REG(0x00D1);          //Vcom Control ������������
	  LCD_WR_DATA(0x0000);         //
	  LCD_WR_DATA(0x0005);         //
	  LCD_WR_DATA(0x0000);         //
		
	  LCD_WR_REG(0x00D2);          //������ͨģʽ�µĵ�Դ������������������
	  LCD_WR_DATA(0x0001);         //
	  LCD_WR_DATA(0x0011);         //

	  LCD_WR_REG(0x00C0);          //Panel Driving setting  ����5������
	  LCD_WR_DATA(0x0000);         //����ɨ��ģʽ
	  LCD_WR_DATA(0x003B);         //�趨����480��
	  LCD_WR_DATA(0x0000);         //
	  LCD_WR_DATA(0x0002);         //5frames
	  LCD_WR_DATA(0x0011);         //
	  //LCD_WR_DATA(0x0001);

	  LCD_WR_REG(0x00C1);          //Timing setting ����3������
	  LCD_WR_DATA(0x0010);         //
	  LCD_WR_DATA(0x000B);         //
	  LCD_WR_DATA(0x0088);         //

	  LCD_WR_REG(0x00C5);          //Frame Rate and Inversion Control ����һ������
	  LCD_WR_DATA(0x0001);         //100hz

	  LCD_WR_REG(0x00C8);          //٤��У��,����12������
	  LCD_WR_DATA(0x0000);LCD_WR_DATA(0x0030);LCD_WR_DATA(0x0036);
	  LCD_WR_DATA(0x0045);LCD_WR_DATA(0x0004);LCD_WR_DATA(0x0016);
	  LCD_WR_DATA(0x0037);LCD_WR_DATA(0x0075);LCD_WR_DATA(0x0077);
	  LCD_WR_DATA(0x0054);LCD_WR_DATA(0x000f);LCD_WR_DATA(0x0000);


	  //LCD_WR_REG(0x00B4);LCD_WR_DATA(0x0011);
	  //DELAY_US(50000);

	  LCD_WR_REG(0x00E4);LCD_WR_DATA(0x00A0);
	  LCD_WR_REG(0x00F0);LCD_WR_DATA(0x0001);
	  LCD_WR_REG(0x00F3);LCD_WR_DATA(0x0040);
	  LCD_WR_DATA(0x000A);
	  LCD_WR_REG(0x00F7);LCD_WR_DATA(0x0080);
	  LCD_WR_REG(0x0036);LCD_WR_DATA(0x000a);
	  LCD_WR_REG(0x003A);LCD_WR_DATA(0x0055);
	  LCD_WR_REG(0x002A);
	  LCD_WR_DATA(0x0000);
	  LCD_WR_DATA(0x0000);
	  LCD_WR_DATA(0x0001);
	  LCD_WR_DATA(0x003F);

	  LCD_WR_REG(0x002B);
	  LCD_WR_DATA(0x0000);
	  LCD_WR_DATA(0x0000);
	  LCD_WR_DATA(0x0001);
	  LCD_WR_DATA(0x00df);

	  DELAY_US(50000);
	  LCD_WR_REG(0x0029);   //����ʾ
	  LCD_WR_REG(0x002C);   //��ʼд����

		//GPIO_SetBits(GPIOB,GPIO_Pin_5);
		//LCD_Clear(BLUE);
      //LCD_SetFont(&Font16x24);
}

/**************************************************************************************************************
 * ��������LCD_SetWindow()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint8_t Height, uint16_t Width �������㣬��͸�
 * ���  ��void
 * ����  ������ĳ���ض����������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetWindow(uint16_t Xpos, uint16_t Ypos, uint16_t Width, uint16_t Height)
{
  /*����ˮƽ����X��ʼ����*/
  if(Xpos >= Height)
  {
    LCD_WriteReg(0x50, (Xpos - Height + 1));
  }
  else
  {
    LCD_WriteReg(0x50, 0);
  }
  /*����ˮƽ����X��������*/
  LCD_WriteReg(0x51, Xpos);
  /*������ֱ����Y��ʼ����*/
  if(Ypos >= Width)
  {
    LCD_WriteReg(0x52, (Ypos - Width + 1));
  }
  else
  {
    LCD_WriteReg(0x52, 0);
  }
  /*������ֱ����Y��������*/
  LCD_WriteReg(0x53, Ypos);
  LCD_SetCursor(Xpos, Ypos);
}

/**************************************************************************************************************
 * ��������LCD_SetColors()
 * ����  ��_TextColor ǰ��ɫ,_BackColor ����ɫ
 * ���  ��void
 * ����  ������LCD��ǰ��ɫ�ͱ���ɫ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetColors(volatile uint16_t _TextColor, volatile uint16_t _BackColor)
{
  TextColor = _TextColor;
  BackColor = _BackColor;
}
/**************************************************************************************************************
 * ��������LCD_GetColors()
 * ����  ��*_TextColor ǰ��ɫ��ָ��,*_BackColor ����ɫ��ָ��
 * ���  ��void
 * ����  ����ȡLCD��ǰ��ɫ�ͱ���ɫ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_GetColors(volatile uint16_t *_TextColor, volatile uint16_t *_BackColor)
{
  *_TextColor = TextColor; *_BackColor = BackColor;
}


/**************************************************************************************************************
 * ��������LCD_SetTextColor()
 * ����  ��uint16_t Color ǰ��ɫ
 * ���  ��void
 * ����  ������LCD��ǰ��ɫ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetTextColor(volatile uint16_t Color)
{
  TextColor = Color;
}

/**************************************************************************************************************
 * ��������LCD_SetBackColor()
 * ����  ��uint16_t Color ����ɫ
 * ���  ��void
 * ����  ������LCD�ı���ɫ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetBackColor(volatile uint16_t Color)
{
  BackColor = Color;
}

/**************************************************************************************************************
 * ��������LCD_SetFont()
 * ����  ��sFONT *fonts Ҫ���õ�����
 * ���  ��void
 * ����  ������LCD������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_SetFont(sFONT *fonts)
{
  LCD_Currentfonts = fonts;
}
/**************************************************************************************************************
 * ��������LCD_GetFont()
 * ����  ��void
 * ���  ��sFONT * ��ȡ����
 * ����  ������LCD������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
sFONT *LCD_GetFont(void)
{
  return LCD_Currentfonts;
}

/**************************************************************************************************************
 * ��������LCD_DrawHLine()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Length ���X��Y���꼰����
 * ���  ��void
 * ����  ����ˮƽ��
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawHLine(uint16_t Xpos, uint16_t Ypos, uint16_t Length)
{
	uint32_t i = 0;
    LCD_SetCursor(Xpos, Ypos);
    LCD_WriteRAM_Start();       // Prepare to write GRAM
    //LCD_WR_REG(0x002C);
    for(i = 0; i < Length; i++)
    {
      LCD_WR_DATA(TextColor);
    }
}*/
/**************************************************************************************************************
 * ��������LCD_DrawVLine()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Length ���X��Y���꼰����
 * ���  ��void
 * ����  ������ֱ��
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawVLine(uint16_t Xpos, uint16_t Ypos, uint16_t Length)
{
	uint32_t i = 0;
    LCD_SetCursor(Xpos, Ypos);
    for(i = 0; i < Length; i++)
    {
      LCD_WriteRAM_Start(); //Prepare to write GRAM
      //LCD_WR_REG(0x002C); //gai
      LCD_WR_DATA(TextColor);
      Ypos++;
      LCD_SetCursor(Xpos, Ypos);
    }
}
*/
/**************************************************************************************************************
 * ��������LCD_DrawRect()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Width, uint8_t Height �������Ͻǵ�����꼰��͸�
 * ���  ��void
 * ����  �������κ���
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawRect(uint16_t Xpos, uint16_t Ypos, uint16_t Width, uint16_t Height)
{
  LCD_DrawHLine(Xpos, Ypos, Width);
  LCD_DrawHLine(Xpos, Ypos+ Height, Width);
  LCD_DrawVLine(Xpos, Ypos, Height);
  LCD_DrawVLine(Xpos+ Width,Ypos, Height);
}
*/
/**************************************************************************************************************
 * ��������LCD_DrawCircle()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Radius Բ������㼰�뾶
 * ���  ��void
 * ����  ����Բ����
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawCircle(uint16_t Xpos, uint16_t Ypos, uint16_t Radius)
{
  int32_t  D;      // Decision Variable
  uint32_t  CurX;  // Current X Value
  uint32_t  CurY;  // Current Y Value

  D = 3 - (Radius << 1);
  CurX = 0;
  CurY = Radius;

  while (CurX <= CurY)
  {
    LCD_SetCursor(Xpos + CurX, Ypos + CurY);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos + CurX, Ypos - CurY);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos - CurX, Ypos + CurY);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos - CurX, Ypos - CurY);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos + CurY, Ypos + CurX);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos + CurY, Ypos - CurX);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos - CurY, Ypos + CurX);
    LCD_WriteRAM_Start(); // Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    LCD_SetCursor(Xpos - CurY, Ypos - CurX);
    LCD_WriteRAM_Start(); //Prepare to write GRAM
    LCD_WR_DATA(TextColor);
    if (D < 0)
    {
      D += (CurX << 2) + 6;
    }
    else
    {
      D += ((CurX - CurY) << 2) + 10;
      CurY--;
    }
    CurX++;
  }
}

*/
/**************************************************************************************************************
 * ��������LCD_DrawMonoPict()
 * ����  ��const uint32_t *Pict ��һ��ȫ����ɫ��ȡĤ����
 * ���  ��void
 * ����  ����һ����ɫ��ȫ��ͼƬ����
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawMonoPict(const uint32_t *Pict)
{
  uint32_t index = 0, i = 0;
  LCD_SetCursor(0, (LCD_PIXEL_WIDTH - 1));
  LCD_WriteRAM_Start(); // Prepare to write GRAM
  for(index = 0; index < 2400; index++)
  {
    for(i = 0; i < 32; i++)
    {
      if((Pict[index] & (1 << i)) == 0x00)
      {
        LCD_WR_DATA(BackColor);
      }
      else
      {
        LCD_WR_DATA(TextColor);
      }
    }
  }
}
*/
/**************************************************************************************************************
 * ��������LCD_FillRect()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Width, uint16_t Height ���������Ͻǵ㡢��͸�
 * ���  ��void
 * ����  ����һ�����ľ���
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_FillRect(uint16_t Xpos, uint16_t Ypos, uint16_t Width, uint16_t Height)
{
	uint16_t tempcolor;
  LCD_SetTextColor(TextColor);
  LCD_DrawHLine(Xpos, Ypos, Width);
  LCD_DrawHLine(Xpos, Ypos+ Height, Width);

  LCD_DrawVLine(Xpos, Ypos, Height);
  LCD_DrawVLine(Xpos+Width, Ypos, Height);

  Width --;
  Height-=2;
  Xpos++;
  tempcolor=TextColor;
  LCD_SetTextColor(BackColor);

  while(Height--)
  {
    LCD_DrawHLine(Xpos, ++Ypos, Width);
  }

  LCD_SetTextColor(tempcolor);
}
*/
/**************************************************************************************************************
 * ��������LCD_FillCircle()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint16_t Radius ���Բ��Բ�ĺͰ뾶
 * ���  ��void
 * ����  ����һ�����Բ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_FillCircle(uint16_t Xpos, uint16_t Ypos, uint16_t Radius)
{
  int32_t  D;      //Decision Variable
  uint32_t  CurX;  //Current X Value
  uint32_t  CurY;  // Current Y Value
  uint16_t tempcolor;
  D = 3 - (Radius << 1);

  CurX = 0;
  CurY = Radius;
  tempcolor=TextColor;
  LCD_SetTextColor(BackColor);

  while (CurX <= CurY)
  {
    if(CurY > 0)
    {
      LCD_DrawHLine(Xpos - CurY, Ypos - CurX, 2*CurY);
      LCD_DrawHLine(Xpos - CurY, Ypos + CurX, 2*CurY);
    }

    if(CurX > 0)
    {
      LCD_DrawHLine(Xpos - CurX, Ypos -CurY, 2*CurX);
      LCD_DrawHLine(Xpos - CurX, Ypos + CurY, 2*CurX);
    }
    if (D < 0)
    {
      D += (CurX << 2) + 6;
    }
    else
    {
      D += ((CurX - CurY) << 2) + 10;
      CurY--;
    }
    CurX++;
  }

  LCD_SetTextColor(tempcolor);
  LCD_DrawCircle(Xpos, Ypos, Radius);
}
*/
/**************************************************************************************************************
 * ��������DrawPixel()
 * ����  ��int16_t x, int16_t y  �������
 * ���  ��void
 * ����  ����һ�����ص�
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void DrawPixel(uint16_t x, uint16_t y)
{
	LCD_SetCursor(x,y);
	LCD_WR_REG(0x002C);
    LCD_WR_DATA(TextColor);
}

/**************************************************************************************************************
 * ��������LCD_DrawUniLine()
 * ����  ��uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2 ��ʼ��������յ�����
 * ���  ��void
 * ����  �������ⷽ���ֱ��
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawUniLine(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2)
{
  int16_t deltax = 0, deltay = 0, x = 0, y = 0, xinc1 = 0, xinc2 = 0,
  yinc1 = 0, yinc2 = 0, den = 0, num = 0, numadd = 0, numpixels = 0,
  curpixel = 0;

  deltax = ABS(x2 - x1);        //The difference between the x's
  deltay = ABS(y2 - y1);        // The difference between the y's
  x = x1;                       //Start x off at the first pixel
  y = y1;                       //Start y off at the first pixel

  if (x2 >= x1)                 //The x-values are increasing
  {
    xinc1 = 1;
    xinc2 = 1;
  }
  else                          //The x-values are decreasing
  {
    xinc1 = -1;
    xinc2 = -1;
  }

  if (y2 >= y1)                 //The y-values are increasing
  {
    yinc1 = 1;
    yinc2 = 1;
  }
  else                          //The y-values are decreasing
  {
    yinc1 = -1;
    yinc2 = -1;
  }

  if (deltax >= deltay)         //There is at least one x-value for every y-value
  {
    xinc1 = 0;                  // Don't change the x when numerator >= denominator
    yinc2 = 0;                  // Don't change the y for every iteration
    den = deltax;
    num = deltax / 2;
    numadd = deltay;
    numpixels = deltax;         // There are more x-values than y-values
  }
  else                          // There is at least one y-value for every x-value
  {
    xinc2 = 0;                  // Don't change the x for every iteration
    yinc1 = 0;                  // Don't change the y when numerator >= denominator
    den = deltay;
    num = deltay / 2;
    numadd = deltax;
    numpixels = deltay;         // There are more y-values than x-values
  }

  for (curpixel = 0; curpixel <= numpixels; curpixel++)
  {
    DrawPixel(x, y);             // Draw the current pixel
    num += numadd;              //Increase the numerator by the top of the fraction
    if (num >= den)             //Check if numerator >= denominator
    {
      num -= den;               //Calculate the new numerator value
      x += xinc1;               //Change the x as appropriate
      y += yinc1;               //Change the y as appropriate
    }
    x += xinc2;                 // Change the x as appropriate
    y += yinc2;                 // Change the y as appropriate
  }
}

*/

/**************************************************************************************************************
 * ��������GetPixel()
 * ����  ��int16_t x, int16_t y  �������
 * ���  ��uint16_t ���������ص����ɫ
 * ����  ����ȡһ�����ص�
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*
uint16_t GetPixel(uint16_t x,uint16_t y)
{
   LCD_SetCursor(x,y);
   return LCD_ReadRAM();
}
*/
/**************************************************************************************************************
 * ��������LCD_DrawChar()
 * ����  ��const uint16_t *c   �ַ�����
 * ���  ��void
 * ����  ��LCD��һ���ַ�
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_DrawChar(uint16_t Xpos, uint16_t Ypos, const uint16_t *c)
{
  uint32_t index = 0, i = 0;
  uint16_t  Yaddress = 0;
  Yaddress = Ypos;

  LCD_SetCursor(Xpos, Yaddress);

  for(index = 0; index < LCD_Currentfonts->Height; index++)
  {
    LCD_WriteRAM_Start();
    for(i = 0; i < LCD_Currentfonts->Width; i++)
    {

      if((((c[index] & ((0x80 << ((LCD_Currentfonts->Width / 12 ) * 8 ) ) >> i)) == 0x00) &&(LCD_Currentfonts->Width <= 12))||
        (((c[index] & (0x1 << i)) == 0x00)&&(LCD_Currentfonts->Width > 12 )))

      {
        LCD_WR_DATA(BackColor);
      }
      else
      {
        LCD_WR_DATA(TextColor);
      }
    }
    Yaddress++;
    LCD_SetCursor(Xpos, Yaddress);
  }
}

/**************************************************************************************************************
 * ��������LCD_DisplayChar()
 * ����  ��uint16_t Xpos, uint16_t Ypos, uint8_t Ascii ��ʾ��λ�ú��ַ�
 * ���  ��void
 * ����  ��LCD��ʾһ���ַ�
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_DisplayChar(uint16_t Xpos, uint16_t Ypos, uint16_t Ascii)
{
  Ascii -= 32;
  LCD_DrawChar(Xpos, Ypos, &LCD_Currentfonts->table[Ascii * LCD_Currentfonts->Height]);
}

/**************************************************************************************************************
 * ��������LCD_DrawString()
 * ����  ��u16 xpos, u16 ypos, u8 *ptr ��ʾ��λ�ú��ַ���
 * ���  ��void
 * ����  ��LCD��ʾһ���ַ�
 * ����  ���ⲿ����
 *****************************************************************************************************************/
void LCD_DrawString(uint16_t xpos, uint16_t ypos, char *ptr)
{
	char refypos=xpos;

  	while(*ptr!=0)
  	{
    	LCD_DisplayChar(refypos,ypos,*ptr);
    	refypos+=LCD_Currentfonts->Width;
    	ptr++;
  	}
}


/**************************************************************************************************************
 * ��������LCD_DrawNum()
 * ����  ��u16 x, u16 y, s32 num, u8 len   ��ʾ��λ�ã����ּ�����
 * ���  ��void
 * ����  ��LCD��ʾһ������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void LCD_DrawNum(uint16_t x, uint16_t y, uint32_t num, uint16_t len)
{
	uint16_t t,temp;
	uint16_t enshow=0;
	t=0;
	if(num<0)
	{
		LCD_DisplayChar(x+(LCD_Currentfonts->Width)*t,y,'-');
		num=-num;
		t++;
	}
	for(;t<len;t++)
	{
		temp=(num/mypow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
				LCD_DisplayChar(x+(LCD_Currentfonts->Width)*t,y,' ');
				continue;
			}else enshow=1;
		}
	 	LCD_DisplayChar(x+(LCD_Currentfonts->Width)*t,y,temp+'0');
	}
}*/

/**************************************************************************************************************
 * ��������ClearAera()
 * ����  ��uint16_t x,uint16_t y,uint16_t w,uint16_t h   �����λ�ã����ȺͿ��
 * ���  ��void
 * ����  ��LCD���ĳ������
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*void ClearAera(uint16_t x,uint16_t y,uint16_t w,uint16_t h)
{
	uint16_t tempcolor;
  tempcolor=TextColor;
  LCD_SetTextColor(BackColor);
  while(h--)
  {
    LCD_DrawHLine(x, y++, w);
  }
  LCD_SetTextColor(tempcolor);
}
*/
/**************************************************************************************************************
 * ��������LCD_DrawImage()
 * ����  ��u8 *p   ͼƬȡĤ����
 * ���  ��void
 * ����  ��LCD��һ��ȫ��ͼƬ
 * ����  ���ⲿ����
 *****************************************************************************************************************/
/*
void LCD_DrawImage(const uint16_t *p)
{
	uint16_t i,j,temp;
	for(i=0;i<240;i++)
		{
			for(j=0;j<320;j++)
				{
					temp=(uint16_t)(*(p+1)<<8|*(p));
					//temp<<=8;
					TextColor=temp;
					DrawPixel(j,i);
					p+=2;
				}
		}
}
*/
