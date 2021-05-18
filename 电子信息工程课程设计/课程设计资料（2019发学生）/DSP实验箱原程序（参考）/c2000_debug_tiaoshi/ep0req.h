/***************************************************
File:    ep0req.h
Author:  PCD Applications
Created: 09/09/2002

Description: Defines constants and function 
			 prototypes for the ep0Req.c program

Copyright (C) CYPRESS SEMICONDUCTOR, 2002
*****************************************************/

#ifndef __EP0REQ_H__
#define __EP0REQ_H__

#include "type.h"

/* Constants */
#define	FIFO2		0x00
#define	FIFO4		0x01
#define	FIFO6		0x02
#define	FIFO8		0x03
#define	COMMAND		0x04

#define VR_TYPE_OUT	     	0x40
#define	VR_TYPE_IN	     	0xC0
#define VR_RESET		 	0xB0
#define VR_ENDPOINT0READ 	0xB1
#define VR_REGWRITE     	0xB2
#define VR_REGREAD		 	0xB3
#define VR_ENDPOINT0WRITE	0xB4
#define VR_BULK_READ        0xB5
#define VR_BULK_WRITE       0xB6
#define VR_LED_OPTION       0xB7
	#define LED_ON          0x0
	#define LED_OFF         0x1
	#define LED_BLINK       0x2
#define VR_USB_VERION       0xB8
#define VR_FLASH_ERASE      0xB9
#define VR_FLASH_WRITE      0xBA
#define VR_FLASH_READ       0xBB
#define VR_CODEC_SET        0xBC
#define VR_CODEC_FREQ       0xBD
	#define CODEC_FREQ_8K   0x0
	#define CODEC_FREQ_44k  0x1
	#define CODEC_FREQ_96k  0x2
#define VR_CODEC_CIRCLE     0xBE
#define VR_CODEC_HALT       0xBF
#define VR_CODEC_REV        0xC0
	#define CODEC_REV_START 0x1
	#define CODEC_REV_STOP  0x2
#define VR_CODEC_PLAY       0xC1
#define VR_CODEC_DATA       0xC2	

#define TIMER0_COUNT 0x00C0
#define  FLASH_ADDR 0x10000
#define  FLash_ADDR_MAX 0x3FFFF

#define  ADSAMPL8K     0xd		//采样率为8k
#define  ADSAMPL44K    0x23		//采样率为44k
#define  ADSAMPL96K    0x1d		//采样率为96k 

#endif
