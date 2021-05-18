/***************************************************
File:    sx2.h
Author:  PCD Applications
Created: 09/09/2002

Description: Defines constants for accessing SX2 
			 registers

Copyright (C) CYPRESS SEMICONDUCTOR, 2002
*****************************************************/

#ifndef __SX2_H__
#define	__SX2_H__

#include "type.h"

/* General Configuration */
#define	SX2_IFCONFIG		0x01	/* Interface Configuration */
	#define	SX2_IFCLKSRC	0x80
	#define	SX2_3048MHZ		0x40
	#define	SX2_IFCLKOE		0x20
	#define	SX2_IFCLKPOL	0x10
	#define	SX2_ASYNC		0x08
	#define	SX2_STANDBY		0x04
	#define	SX2_FLAGDCS		0x02
	#define	SX2_DISCON		0x01
	
#define	SX2_FLAGAB			0x02	/* FIFO FlagA and FlagB Assignments */
	#define	SX2_FLAGB_FF    0x00
	#define	SX2_FLAGA_PF    0x00
	
	#define	SX2_FLAGA_PF2	0x04
	#define	SX2_FLAGA_PF4	0x05
	#define	SX2_FLAGA_PF6	0x06
	#define	SX2_FLAGA_PF8	0x07
	#define	SX2_FLAGA_EF2	0x08
	#define	SX2_FLAGA_EF4	0x09
	#define	SX2_FLAGA_EF6	0x0A
	#define	SX2_FLAGA_EF8	0x0B
	#define	SX2_FLAGA_FF2	0x0C
	#define	SX2_FLAGA_FF4	0x0D
	#define	SX2_FLAGA_FF6	0x0E
	#define	SX2_FLAGA_FF8	0x0F
	
	#define	SX2_FLAGB_PF2	0x40
	#define	SX2_FLAGB_PF4	0x50
	#define	SX2_FLAGB_PF6	0x60
	#define	SX2_FLAGB_PF8	0x70
	#define	SX2_FLAGB_EF2	0x80
	#define	SX2_FLAGB_EF4	0x90
	#define	SX2_FLAGB_EF6	0xA0
	#define	SX2_FLAGB_EF8	0xB0
	#define	SX2_FLAGB_FF2	0xC0
	#define	SX2_FLAGB_FF4	0xD0
	#define	SX2_FLAGB_FF6	0xE0
	#define	SX2_FLAGB_FF8	0xF0


#define	SX2_FLAGCD			0x03	/* FIFO FlagC and FlagD Assignments */
	#define	SX2_FLAGC_EF    0x00
	#define	SX2_FLAGD_CS    0x00
	
	#define	SX2_FLAGC_PF2	0x04
	#define	SX2_FLAGC_PF4	0x05
	#define	SX2_FLAGC_PF6	0x06
	#define	SX2_FLAGC_PF8	0x07
	#define	SX2_FLAGC_EF2	0x08
	#define	SX2_FLAGC_EF4	0x09
	#define	SX2_FLAGC_EF6	0x0A
	#define	SX2_FLAGC_EF8	0x0B
	#define	SX2_FLAGC_FF2	0x0C
	#define	SX2_FLAGC_FF4	0x0D
	#define	SX2_FLAGC_FF6	0x0E
	#define	SX2_FLAGC_FF8	0x0F
	
	#define	SX2_FLAGD_PF2	0x40
	#define	SX2_FLAGD_PF4	0x50
	#define	SX2_FLAGD_PF6	0x60
	#define	SX2_FLAGD_PF8	0x70
	#define	SX2_FLAGD_EF2	0x80
	#define	SX2_FLAGD_EF4	0x90
	#define	SX2_FLAGD_EF6	0xA0
	#define	SX2_FLAGD_EF8	0xB0
	#define	SX2_FLAGD_FF2	0xC0
	#define	SX2_FLAGD_FF4	0xD0
	#define	SX2_FLAGD_FF6	0xE0
	#define	SX2_FLAGD_FF8	0xF0

#define	SX2_FIFOPOLAR		0x04	/* FIFO polarities */
	#define	SX2_WUPOL		0x80
	#define	SX2_PKTEND		0x20
	#define	SX2_OE			0x10
	#define	SX2_RD			0x08
	#define	SX2_WR			0x04
	#define	SX2_EF			0x02
	#define	SX2_FF			0x01

#define	SX2_REVID			0x05	/* Chip Revision */

/* Endpoint Configuration */
#define	SX2_EP2CFG			0x06	/* Endpoint 2 Configuration */
	#define SX2_VALID		0x80
	#define	SX2_DIR			0x40
	#define	SX2_TYPE1		0x20
	#define	SX2_TYPE0		0x10
	#define	SX2_SIZE		0x08
	#define	SX2_STALL		0x04
	#define	SX2_BUF1		0x02
	#define	SX2_BUF0		0x01

#define	SX2_EP4CFG			0x07	/* Endpoint 4 Configuration */ 
#define	SX2_EP6CFG			0x08	/* Endpoint 6 Configuration */
#define	SX2_EP8CFG			0x09	/* Endpoint 8 Configuration */
#define	SX2_EP2PKTLENH		0x0A	/* Endpoint 2 Packet Length H (IN only) */
	#define	SX2_INFM1		0x80
	#define	SX2_OEP1		0x40
	#define	SX2_ZEROLEN		0x20
	#define	SX2_WORDWIDE	0x10

#define	SX2_EP2PKTLENL		0x0B	/* Endpoint 2 Packet Length L (IN only) */
#define	SX2_EP4PKTLENH		0x0C	/* Endpoint 4 Packet Length H (IN only) */
#define	SX2_EP4PKTLENL		0x0D	/* Endpoint 4 Packet Length L (IN only) */
#define	SX2_EP6PKTLENH		0x0E	/* Endpoint 6 Packet Length H (IN only) */
#define	SX2_EP6PKTLENL		0x0F	/* Endpoint 6 Packet Length L (IN only) */
#define	SX2_EP8PKTLENH		0x10	/* Endpoint 8 Packet Length H (IN only) */
#define	SX2_EP8PKTLENL		0x11	/* Endpoint 8 Packet Length L (IN only) */
#define	SX2_EP2PFH			0x12	/* EP2 Programmable Flag H */
#define	SX2_EP2PFL			0x13	/* EP2 Programmable Flag L */
#define	SX2_EP4PFH			0x14	/* EP4 Programmable Flag H */
#define	SX2_EP4PFL			0x15	/* EP4 Programmable Flag L */
#define	SX2_EP6PFH			0x16	/* EP6 Programmable Flag H */
#define	SX2_EP6PFL			0x17	/* EP6 Programmable Flag L */
#define	SX2_EP8PFH			0x18	/* EP8 Programmable Flag H */
#define	SX2_EP8PFL			0x19	/* EP8 Programmable Flag L */
	#define	SX2_DECIS		0x80
	#define	SX2_PKTSTAT		0x40
	#define	SX2_INPKTS4		0x20
	#define	SX2_INPKTS3		0x18
	#define	SX2_INPKTS2		0x10
	#define	SX2_INPKTS1		0x08

#define	SX2_EP2ISOINPKTS	0x1A	/* EP2 (if ISO) IN Packets per frame (1-3) */
	#define	SX2_INPPF1		0x02
	#define	SX2_INPPF0		0x01

#define	SX2_EP4ISOINPKTS	0x1B	/* EP4 (if ISO) IN Packets per frame (1-3) */
#define	SX2_EP6ISOINPKTS	0x1C	/* EP6 (if ISO) IN Packets per frame (1-3) */
#define	SX2_EP8ISOINPKTS	0x1D	/* EP8 (if ISO) IN Packets per frame (1-3) */

/* Flags */
#define	SX2_EP24FLAGS		0x1E	/* Endpoints 2,4 FIFO Flags */
	#define	SX2_EP4PF		0x40
	#define	SX2_EP4EF		0x20
	#define	SX2_EP4FF		0x10
	#define	SX2_EP2PF		0x04
	#define	SX2_EP2EF		0x02
	#define	SX2_EP2FF		0x01

#define	SX2_EP68FLAGS		0x1F	/* Endpoints 6,8 FIFO Flags */
	#define	SX2_EP8PF		0x40
	#define	SX2_EP8EF		0x20
	#define	SX2_EP8FF		0x10
	#define	SX2_EP6PF		0x04
	#define	SX2_EP6EF		0x02
	#define	SX2_EP6FF		0x01

/* In Packent End */
#define	SX2_INPKTEND		0x20	/* Force Packet End */
	#define SX2_CLEARALL    0xf0    /* Clear All FIFO*/

/* USB Configuration */
#define	SX2_USBFRAMEH		0x2A	/* USB Frame count H */
#define	SX2_USBFRAMEL		0x2B	/* USB Frame count L */
#define	SX2_MICROFRAME		0x2C	/* Microframe Count, 0-7 */
#define	SX2_FNADDR			0x2D	/* USB Function Address */
	#define	SX2_HSGRANT		0x80

/* Interrupts */
#define	SX2_INTENABLE			0x2E	/* Interrupt Enable */
	#define	SX2_INT_SETUP		0x80
	#define	SX2_INT_EP0BUF		0x40
	#define	SX2_INT_FLAGS		0x20
	#define	SX2_INT_ENUMOK		0x04
	#define	SX2_INT_BUSACTIVITY	0x02
	#define	SX2_INT_READY		0x01

#define	SX2_IRQ					0x2F	/* Interrupt Requests Flags */

/* Descriptor */
#define	SX2_DESC			0x30	/* Descriptor RAM */

/* Endpoint Buffers */
#define	SX2_EP0BUF			0x31	/* Endpoint 0 Buffer */
#define	SX2_SETUP			0x32	/* Endpoint 0 Setup Data/Stall register */
#define	SX2_EP0BC			0x33	/* Endpoint 0 Byte Count */


#define ENDPOINT2 			0
#define ENDPOINT4 			1
#define ENDPOINT6 			2
#define ENDPOINT8 			3


/*********************************************************/
/*	Function: SX2_comwritebyte		    				 */
/*	Purpose:  Writes to a SX2 command interface			 */
/*	Input:	  value - value to write to address			 */
/*	Output:	  TRUE  on success							 */
/*			  FALSE on failure							 */
/*********************************************************/
BOOL SX2_comwritebyte(unsigned int value);           
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
//BOOL SX2_FifoWrite(unsigned int channel,u16* pdata,unsigned int longth);
/*********************************************************/
/*                                                       */
/*	Function: SX2_FifoRead                               */
/*	Purpose:  read sx2fifo to data buffer                */
/*	Input:	  channel,the endpoint you select			 */
/*			  pdata - the pointer to databuffer			 */
/*			  longth - the longth of the databuffer      */
/*	Output:	  TRUE  on success                           */
/*			  FALSE on failure							 */
/*														 */
/*********************************************************/
BOOL SX2_FifoRead(int channel,u16* pdata,unsigned int longth);
/***********************************************************/
/*	Function: Write_SX2reg						   		   */
/*	Purpose:  Writes to a SX2 register					   */
/*	Input:	  addr  - address of register				   */
/*			  value - value to write to address			   */
/*	Output:	  TRUE  on success							   */
/*			  FALSE on failure							   */
/*************************************** *******************/
BOOL Write_SX2reg(unsigned char addr, unsigned int value);
/**********************************************************/
/*														  */
/*	Function: Read_SX2reg								  */
/*	Purpose:  Reads a SX2 register						  */
/*	Input:	  addr  - address of register				  */	
/*			  value - value read from register			  */
/*	Output:	  TRUE  on success							  */
/*			  FALSE on failure							  */
/*														  */
/**********************************************************/
BOOL Read_SX2reg(unsigned char addr, unsigned int *value);

/**********************************************************/
/*	Function: Load_descriptors							  */
/*	Purpose:  loads the descriptor memory of SX2		  */
/*	Input:	  count - number of bytes in the descriptor	  */
/*			  desc  - pointer to descriptor table		  */
/*	Output:	  TRUE  on success							  */
/*			  FALSE on failure						      */
/*														  */
/************************************** *******************/
BOOL Load_descriptors(char length,char* desc);

#endif
