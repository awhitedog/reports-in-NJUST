/**********************************************************************/
/*File:    descriptors.h											  */
/*Author:  duanlifeng   											  */
/*																	  */
/*����: Defines USB descriptor table constants						  */
/*																	  */
/*  ��Ȩ(c) 	2003-		�������ڴ���Ӽ����������ι�˾			  */
/**********************************************************************/
#ifndef __DESCRIPTORS_H__
#define	__DESCRIPTORS_H__

#define	DSCR_DEVICE		1   /* �����������: Device */
#define	DSCR_CONFIG		2   /* �����������: Configuration */
#define	DSCR_STRING		3   /* �����������: String */
#define	DSCR_INTRFC		4   /* �����������: Interface */
#define	DSCR_ENDPNT		5   /* �����������: Endpoint */
#define	DSCR_DEVQUAL	6   /* �����������: Device Qualifier */

#define	DSCR_DEVICE_LEN		18
#define	DSCR_CONFIG_LEN		9
#define	DSCR_INTRFC_LEN		9
#define	DSCR_ENDPNT_LEN		7
#define	DSCR_DEVQUAL_LEN	10

#define	ET_CONTROL		0   /* �ڵ������: Control */
#define	ET_ISO			1   /* �ڵ������: Isochronous */
#define	ET_BULK			2   /* �ڵ������: Bulk */
#define	ET_INT			3   /* �ڵ������: Interrupt */

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
