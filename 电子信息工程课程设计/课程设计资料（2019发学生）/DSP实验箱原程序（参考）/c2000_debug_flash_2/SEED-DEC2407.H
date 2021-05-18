/************************************************************************************
	FILENAME:	SEED-DEC2407.h
************************************************************************************/
#ifndef _Register
#define _Register

/* CPU CORE REGISTERS */
volatile unsigned int* IMR = (volatile unsigned int *) 0x0004;
volatile unsigned int* IFR = (volatile unsigned int *) 0x0006;

/* SYSTEM CONFIG AND INTERRUPT REGISTERS */
volatile unsigned int* SCSR1 = (volatile unsigned int *) 0x7018;
volatile unsigned int* SCSR2 = (volatile unsigned int *) 0x7019;
volatile unsigned int* DINR = (volatile unsigned int *) 0x701C;
volatile unsigned int* PIVR = (volatile unsigned int *) 0x701E;
volatile unsigned int* PIRQR0 = (volatile unsigned int *) 0x7010;
volatile unsigned int* PIRQR1 = (volatile unsigned int *) 0x7011;
volatile unsigned int* PIRQR2 = (volatile unsigned int *) 0x7012;
volatile unsigned int* PIACKR0 = (volatile unsigned int *) 0x7014;
volatile unsigned int* PIACKR1 = (volatile unsigned int *) 0x7015;
volatile unsigned int* PIACKR2 = (volatile unsigned int *) 0x7016;

/* EXTERNAL INTERRUPT CONFIG REGISTERS */
volatile unsigned int* XINT1CR = (volatile unsigned int *) 0x7070;
volatile unsigned int* XINT2CR = (volatile unsigned int *) 0x7071;

/* DIGITAL I/O REGISTERS */
volatile unsigned int* MCRA = (volatile unsigned int *) 0x7090;
volatile unsigned int* MCRB = (volatile unsigned int *) 0x7092;
volatile unsigned int* MCRC = (volatile unsigned int *) 0x7094;
volatile unsigned int* PADATDIR = (volatile unsigned int *) 0x7098;
volatile unsigned int* PBDATDIR = (volatile unsigned int *) 0x709A;
volatile unsigned int* PCDATDIR = (volatile unsigned int *) 0x709C;
volatile unsigned int* PDDATDIR = (volatile unsigned int *) 0x709E;
volatile unsigned int* PEDATDIR = (volatile unsigned int *) 0x7095;
volatile unsigned int* PFDATDIR = (volatile unsigned int *) 0x7096;

/* WATCHDOG REGISTERS */
volatile unsigned int* WDCNTR = (volatile unsigned int *) 0x7023;
volatile unsigned int* WDKEY = (volatile unsigned int *) 0x7025;
volatile unsigned int* WDCR = (volatile unsigned int *) 0x7029;

/* ADC REGISTERS */
volatile unsigned int* ADCTRL1 = (volatile unsigned int *) 0x70A0;
volatile unsigned int* ADCTRL2 = (volatile unsigned int *) 0x70A1;
volatile unsigned int* MAXCONV = (volatile unsigned int *) 0x70A2;
volatile unsigned int* CHSELSEQ1 = (volatile unsigned int *) 0x70A3;
volatile unsigned int* CHSELSEQ2 = (volatile unsigned int *) 0x70A4;
volatile unsigned int* CHSELSEQ3 = (volatile unsigned int *) 0x70A5;
volatile unsigned int* CHSELSEQ4 = (volatile unsigned int *) 0x70A6;
volatile unsigned int* AUTO_SEQ_SR = (volatile unsigned int *) 0x70A7;
volatile unsigned int* RESULT0 = (volatile unsigned int *) 0x70A8;
volatile unsigned int* RESULT1 = (volatile unsigned int *) 0x70A9;
volatile unsigned int* RESULT2 = (volatile unsigned int *) 0x70AA;
volatile unsigned int* RESULT3 = (volatile unsigned int *) 0x70AB;
volatile unsigned int* RESULT4 = (volatile unsigned int *) 0x70AC;
volatile unsigned int* RESULT5 = (volatile unsigned int *) 0x70AD;
volatile unsigned int* RESULT6 = (volatile unsigned int *) 0x70AE;
volatile unsigned int* RESULT7 = (volatile unsigned int *) 0x70AF;
volatile unsigned int* RESULT8 = (volatile unsigned int *) 0x70B0;
volatile unsigned int* RESULT9 = (volatile unsigned int *) 0x70B1;
volatile unsigned int* RESULT10 = (volatile unsigned int *) 0x70B2;
volatile unsigned int* RESULT11 = (volatile unsigned int *) 0x70B3;
volatile unsigned int* RESULT12 = (volatile unsigned int *) 0x70B4;
volatile unsigned int* RESULT13 = (volatile unsigned int *) 0x70B5;
volatile unsigned int* RESULT14 = (volatile unsigned int *) 0x70B6;
volatile unsigned int* RESULT15 = (volatile unsigned int *) 0x70B7;
volatile unsigned int* CALIBRATION = (volatile unsigned int *) 0x70B8;

/* SPI REGISTERS */
volatile unsigned int* SPICCR = (volatile unsigned int *) 0x7040;
volatile unsigned int* SPICTL = (volatile unsigned int *) 0x7041;
volatile unsigned int* SPISTS = (volatile unsigned int *) 0x7042;
volatile unsigned int* SPIBRR = (volatile unsigned int *) 0x7044;
volatile unsigned int* SPIRXEMU = (volatile unsigned int *) 0x7046;
volatile unsigned int* SPIRXBUF = (volatile unsigned int *) 0x7047;
volatile unsigned int* SPITXBUF = (volatile unsigned int *) 0x7048;
volatile unsigned int* SPIDAT = (volatile unsigned int *) 0x7049;
volatile unsigned int* SPIPRI = (volatile unsigned int *) 0x704F;

/* SCI REGISTERS */
volatile unsigned int* SCICCR = (volatile unsigned int *) 0x7050;
volatile unsigned int* SCICTL1 = (volatile unsigned int *) 0x7051;
volatile unsigned int* SCIHBAUD = (volatile unsigned int *) 0x7052;
volatile unsigned int* SCILBAUD = (volatile unsigned int *) 0x7053;
volatile unsigned int* SCICTL2 = (volatile unsigned int *) 0x7054;
volatile unsigned int* SCIRXST = (volatile unsigned int *) 0x7055;
volatile unsigned int* SCIRXEMU = (volatile unsigned int *) 0x7056;
volatile unsigned int* SCIRXBUF= (volatile unsigned int *) 0x7057;
volatile unsigned int* SCITXBUF = (volatile unsigned int *) 0x7059;
volatile unsigned int* SCIPRI = (volatile unsigned int *) 0x705F;

/* EVENT MANAGER A REGISTERS */
volatile unsigned int* GPTCONA = (volatile unsigned int *) 0x7400;
volatile unsigned int* T1CNT = (volatile unsigned int *) 0x7401;
volatile unsigned int* T1CMPR = (volatile unsigned int *) 0x7402;
volatile unsigned int* T1PR = (volatile unsigned int *) 0x7403;
volatile unsigned int* T1CON = (volatile unsigned int *) 0x7404;
volatile unsigned int* T2CNT = (volatile unsigned int *) 0x7405;
volatile unsigned int* T2CMPR = (volatile unsigned int *) 0x7406;
volatile unsigned int* T2PR = (volatile unsigned int *) 0x7407;
volatile unsigned int* T2CON = (volatile unsigned int *) 0x7408;
volatile unsigned int* COMCONA = (volatile unsigned int *) 0x7411;
volatile unsigned int* ACTRA = (volatile unsigned int *) 0x7413;
volatile unsigned int* DBTCONA = (volatile unsigned int *) 0x7415;

volatile unsigned int* CMPR1 = (volatile unsigned int *) 0x7417;
volatile unsigned int* CMPR2 = (volatile unsigned int *) 0x7418;
volatile unsigned int* CMPR3 = (volatile unsigned int *) 0x7419;
volatile unsigned int* CAPCONA = (volatile unsigned int *) 0x7420;
volatile unsigned int* CAPFIFOA = (volatile unsigned int *) 0x7422;
volatile unsigned int* CAP1FIFO = (volatile unsigned int *) 0x7423;
volatile unsigned int* CAP2FIFO = (volatile unsigned int *) 0x7424;
volatile unsigned int* CAP3FIFO = (volatile unsigned int *) 0x7425;
volatile unsigned int* CAP1FBOT = (volatile unsigned int *) 0x7427;
volatile unsigned int* CAP2FBOT = (volatile unsigned int *) 0x7428;
volatile unsigned int* CAP3FBOT = (volatile unsigned int *) 0x7429;
volatile unsigned int* EVAIMRA = (volatile unsigned int *) 0x742C;
volatile unsigned int* EVAIMRB = (volatile unsigned int *) 0x742D;
volatile unsigned int* EVAIMRC = (volatile unsigned int *) 0x742E;

volatile unsigned int* EVAIFRA = (volatile unsigned int *) 0x742F;
volatile unsigned int* EVAIFRB = (volatile unsigned int *) 0x7430;
volatile unsigned int* EVAIFRC = (volatile unsigned int *) 0x7431;

/* EVENT MANAGER B REGISTERS */
volatile unsigned int* GPTCONB = (volatile unsigned int *) 0x7500;
volatile unsigned int* T3CNT = (volatile unsigned int *) 0x7501;
volatile unsigned int* T3CMPR = (volatile unsigned int *) 0x7502;
volatile unsigned int* T3PR = (volatile unsigned int *) 0x7503;
volatile unsigned int* T3CON = (volatile unsigned int *) 0x7504;
volatile unsigned int* T4CNT = (volatile unsigned int *) 0x7505;
volatile unsigned int* T4CMPR = (volatile unsigned int *) 0x7506;
volatile unsigned int* T4PR = (volatile unsigned int *) 0x7507;
volatile unsigned int* T4CON = (volatile unsigned int *) 0x7508;
volatile unsigned int* COMCONB = (volatile unsigned int *) 0x7511;
volatile unsigned int* ACTRB = (volatile unsigned int *) 0x7513;
volatile unsigned int* DBTCONB = (volatile unsigned int *) 0x7515;

volatile unsigned int* CMPR4 = (volatile unsigned int *) 0x7517;
volatile unsigned int* CMPR5 = (volatile unsigned int *) 0x7518;
volatile unsigned int* CMPR6 = (volatile unsigned int *) 0x7519;
volatile unsigned int* CAPCONB = (volatile unsigned int *) 0x7520;
volatile unsigned int* CAPFIFOB = (volatile unsigned int *) 0x7522;
volatile unsigned int* CAP4FIFO = (volatile unsigned int *) 0x7523;
volatile unsigned int* CAP5FIFO = (volatile unsigned int *) 0x7524;
volatile unsigned int* CAP6FIFO = (volatile unsigned int *) 0x7525;
volatile unsigned int* CAP4FBOT = (volatile unsigned int *) 0x7527;
volatile unsigned int* CAP5FBOT = (volatile unsigned int *) 0x7528;
volatile unsigned int* CAP6FBOT = (volatile unsigned int *) 0x7529;
volatile unsigned int* EVBIMRA = (volatile unsigned int *) 0x752C;
volatile unsigned int* EVBIMRB = (volatile unsigned int *) 0x752D;
volatile unsigned int* EVBIMRC = (volatile unsigned int *) 0x752E;

volatile unsigned int* EVBIFRA = (volatile unsigned int *) 0x752F;
volatile unsigned int* EVBIFRB = (volatile unsigned int *) 0x7530;
volatile unsigned int* EVBIFRC = (volatile unsigned int *) 0x7531;

/* CAN REGISTERS */
volatile unsigned int* CANMDER = (volatile unsigned int *) 0x7100;
volatile unsigned int* CANTCR = (volatile unsigned int *) 0x7101;
volatile unsigned int* CANRCR = (volatile unsigned int *) 0x7102;
volatile unsigned int* CANMCR = (volatile unsigned int *) 0x7103;
volatile unsigned int* CANBCR2 = (volatile unsigned int *) 0x7104;
volatile unsigned int* CANBCR1 = (volatile unsigned int *) 0x7105;
volatile unsigned int* CANESR = (volatile unsigned int *) 0x7106;
volatile unsigned int* CANGSR = (volatile unsigned int *) 0x7107;
volatile unsigned int* CANCEC = (volatile unsigned int *) 0x7108;
volatile unsigned int* CANIFR = (volatile unsigned int *) 0x7109;
volatile unsigned int* CANIMR = (volatile unsigned int *) 0x710A;
volatile unsigned int* CANLAM0H = (volatile unsigned int *) 0x710B;
volatile unsigned int* CANLAM0L = (volatile unsigned int *) 0x710C;
volatile unsigned int* CANLAM1H = (volatile unsigned int *) 0x710D;
volatile unsigned int* CANLAM1L = (volatile unsigned int *) 0x710E;

volatile unsigned int* CANMSGID0L = (volatile unsigned int *) 0x7200;
volatile unsigned int* CANMSGID0H = (volatile unsigned int *) 0x7201;
volatile unsigned int* CANMSGCTRL0 = (volatile unsigned int *) 0x7202;
volatile unsigned int* CANMBX0A = (volatile unsigned int *) 0x7204;
volatile unsigned int* CANMBX0B = (volatile unsigned int *) 0x7205;
volatile unsigned int* CANMBX0C = (volatile unsigned int *) 0x7206;
volatile unsigned int* CANMBX0D = (volatile unsigned int *) 0x7207;

volatile unsigned int* CANMSGID1L = (volatile unsigned int *) 0x7208;
volatile unsigned int* CANMSGID1H = (volatile unsigned int *) 0x7209;
volatile unsigned int* CANMSGCTRL1 = (volatile unsigned int *) 0x720A;
volatile unsigned int* CANMBX1A = (volatile unsigned int *) 0x720C;
volatile unsigned int* CANMBX1B = (volatile unsigned int *) 0x720D;
volatile unsigned int* CANMBX1C = (volatile unsigned int *) 0x720E;
volatile unsigned int* CANMBX1D = (volatile unsigned int *) 0x720F;

volatile unsigned int* CANMSGID2L = (volatile unsigned int *) 0x7210;
volatile unsigned int* CANMSGID2H = (volatile unsigned int *) 0x7211;
volatile unsigned int* CANMSGCTRL2 = (volatile unsigned int *) 0x7212;
volatile unsigned int* CANMBX2A = (volatile unsigned int *) 0x7214;
volatile unsigned int* CANMBX2B = (volatile unsigned int *) 0x7215;
volatile unsigned int* CANMBX2C = (volatile unsigned int *) 0x7216;
volatile unsigned int* CANMBX2D = (volatile unsigned int *) 0x7217;

volatile unsigned int* CANMSGID3L = (volatile unsigned int *) 0x7218;
volatile unsigned int* CANMSGID3H = (volatile unsigned int *) 0x7219;
volatile unsigned int* CANMSGCTRL3 = (volatile unsigned int *) 0x721A;
volatile unsigned int* CANMBX3A = (volatile unsigned int *) 0x721C;
volatile unsigned int* CANMBX3B = (volatile unsigned int *) 0x721D;
volatile unsigned int* CANMBX3C = (volatile unsigned int *) 0x721E;
volatile unsigned int* CANMBX3D = (volatile unsigned int *) 0x721F;

volatile unsigned int* CANMSGID4L = (volatile unsigned int *) 0x7220;
volatile unsigned int* CANMSGID4H = (volatile unsigned int *) 0x7221;
volatile unsigned int* CANMSGCTRL4 = (volatile unsigned int *) 0x7222;
volatile unsigned int* CANMBX4A = (volatile unsigned int *) 0x7224;
volatile unsigned int* CANMBX4B = (volatile unsigned int *) 0x7225;
volatile unsigned int* CANMBX4C = (volatile unsigned int *) 0x7226;
volatile unsigned int* CANMBX4D = (volatile unsigned int *) 0x7227;

volatile unsigned int* CANMSGID5L = (volatile unsigned int *) 0x7228;
volatile unsigned int* CANMSGID5H = (volatile unsigned int *) 0x7229;
volatile unsigned int* CANMSGCTRL5 = (volatile unsigned int *) 0x722A;
volatile unsigned int* CANMBX5A = (volatile unsigned int *) 0x722C;
volatile unsigned int* CANMBX5B = (volatile unsigned int *) 0x722D;
volatile unsigned int* CANMBX5C = (volatile unsigned int *) 0x722E;
volatile unsigned int* CANMBX5D = (volatile unsigned int *) 0x722F;

/* IO REGISTERS */

ioport unsigned portFFFF;
#define WSGR	portFFFF
	
ioport unsigned portFF0F;
#define FCMR	portFF0F	

#define DINT	asm(" SETC INTM ")
#define EINT	asm(" CLRC INTM ")
#define NOP	asm(" NOP ")
#define ONLED	asm(" SETC XF ")
#define OFFLED	asm(" CLRC XF ")


#define TRUE	1
#define FALSE	0  

#define Uint16	unsigned int
#define Bool	unsigned short

#endif
