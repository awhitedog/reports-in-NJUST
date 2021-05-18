/**********************************************************************/
/*File:    descriptors.h											  */
/*Author:  duanlifeng   											  */
/*																	  */
/*描述: Defines USB descriptor table constants						  */
/*																	  */
/*  版权(c) 	2003-		北京合众达电子技术有限责任公司			  */
/**********************************************************************/
#ifndef __DESCRIPTORS_H__
#define	__DESCRIPTORS_H__

#define	DSCR_DEVICE		1   /* 描述表的类型: Device */
#define	DSCR_CONFIG		2   /* 描述表的类型: Configuration */
#define	DSCR_STRING		3   /* 描述表的类型: String */
#define	DSCR_INTRFC		4   /* 描述表的类型: Interface */
#define	DSCR_ENDPNT		5   /* 描述表的类型: Endpoint */
#define	DSCR_DEVQUAL	6   /* 描述表的类型: Device Qualifier */

#define	DSCR_DEVICE_LEN		18
#define	DSCR_CONFIG_LEN		9
#define	DSCR_INTRFC_LEN		9
#define	DSCR_ENDPNT_LEN		7
#define	DSCR_DEVQUAL_LEN	10

#define	ET_CONTROL		0   /* 节点的类型: Control */
#define	ET_ISO			1   /* 节点的类型: Isochronous */
#define	ET_BULK			2   /* 节点的类型: Bulk */
#define	ET_INT			3   /* 节点的类型: Interrupt */

#define DESCTBL_LEN DSCR_DEVICE_LEN		 + \
					DSCR_DEVQUAL_LEN	 + \
					DSCR_CONFIG_LEN		 + \
					DSCR_INTRFC_LEN		 + \
					(4*DSCR_ENDPNT_LEN)  + \
					DSCR_CONFIG_LEN      + \
					DSCR_INTRFC_LEN      + \
					(4*DSCR_ENDPNT_LEN)  + \
					2+2+2+(2*7)+2+(2*10)
					
#endif
