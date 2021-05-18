/**********************************************************************/
/*File:    descriptors.c											  */
/*Author:  duanlifeng												  */
/*																	  */
/*描述: initializes character array with USB descriptor values 		  */
/*		that will be loaded into the SX2 descriptor RAM at startup	  */
/*																	  */
/*  版权(c) 	2003-		北京合众达电子技术有限责任公司			  */
/**********************************************************************/

#include "descriptors.h"

char desctbl[] = {
	/* 器件描述表 */   
	DSCR_DEVICE_LEN,	/* Descriptor length */
	DSCR_DEVICE,  		/* Decriptor type */
	0x00,0x02,			/* Specification Version (BCD) */
	0x00,				/* Device class */
	0x00,				/* Device sub-class */
	0x00,				/* Device sub-sub-class */
	0x40,				/* Maximum packet size */
	0xb4, 0x04,			/* Vendor ID */
	0x82, 0x00,			/* Product ID (Sample Device) */
	
	//0x46, 0x08,			/* Vendor ID */
	//0x10, 0x42,			/* Product ID (Sample Device) */
	
	
	0x00, 0x00,			/* Product version ID */
	0x01,				/* Manufacturer string index */
	0x02,				/* Product string index */
	0x00,				/* Serial number string index */
	0x01,				/* Number of configurations */

	/* Device Qualifier Descriptor */
	DSCR_DEVQUAL_LEN,	/* Descriptor length */
	DSCR_DEVQUAL,		/* Decriptor type */
	0x00, 0x02,			/* Specification Version (BCD) */
	0x00,				/* Device class */
	0x00,				/* Device sub-class */
	0x00,				/* Device sub-sub-class */
	0x40,				/* Maximum packet size */
	0x01,				/* Number of configurations */
	0x00,				/* Reserved */

	/* High-Speed Configuration Descriptor*/
	DSCR_CONFIG_LEN,	/* Descriptor length */
	DSCR_CONFIG,		/* Descriptor type */
	DSCR_CONFIG_LEN  +	/* Total Length (LSB) */
	 DSCR_INTRFC_LEN +
	 (4*DSCR_ENDPNT_LEN),
	0x00,				/* Total Length (MSB) */
	0x01,				/* Number of interfaces */
	0x01,				/* Configuration number */
	0x00,				/* Configuration string */
	0x40,				/* Attributes (b7 - buspwr, b6 - selfpwr, b5 - rwu) */
	0x32,				/* Power requirement (div 2 ma) */

	/* Interface Descriptor */
	DSCR_INTRFC_LEN,	/* Descriptor length */
	DSCR_INTRFC,		/* Descriptor type */
	0x00,				/* Zero-based index of this interface */
	0x00,				/* Alternate setting */
	0x04,				/* Number of end points */ 
	0xFF,				/* Interface class */
	0x00,				/* Interface sub class */
	0x00,				/* Interface sub sub class */
	0x00,				/* Interface descriptor string index */
      
	/* Endpoint 2 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x02,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x00,				/* Maximun packet size (LSB) */
	0x02,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 4 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x04,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x00,				/* Maximun packet size (LSB) */
	0x02,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 6 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x86,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x00,				/* Maximun packet size (LSB) */
	0x02,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 8 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
    0x88,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x00,				/* Maximun packet size (LSB) */
	0x02,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */
	/* End of High-Speed Configuration Descriptor */   

	/* Full-Speed Configuration Descriptor */
	DSCR_CONFIG_LEN,	/* Descriptor length */
	DSCR_CONFIG,		/* Descriptor type */
	DSCR_CONFIG_LEN+DSCR_INTRFC_LEN+(4*DSCR_ENDPNT_LEN),	/* Total Length (LSB) */
	0x00,				/* Total Length (MSB) */
	0x01,				/* Number of interfaces */
	0x01,				/* Configuration number */
	0x00,				/* Configuration string */
	0x40,				/* Attributes (b7 - buspwr, b6 - selfpwr, b5 - rwu) */
	0x32,				/* Power requirement (div 2 ma) */

	/* Interface Descriptor */
	DSCR_INTRFC_LEN,	/* Descriptor length */
	DSCR_INTRFC,		/* Descriptor type */
	0x00,				/* Zero-based index of this interface */
	0x00,				/* Alternate setting */
	0x04,				/* Number of end points */ 
	0xFF,				/* Interface class */
	0x00,				/* Interface sub class */
	0x00,				/* Interface sub sub class */
	0x00,				/* Interface descriptor string index */
      
	/* Endpoint 2 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x02,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x40,				/* Maximun packet size (LSB) */
	0x00,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 4 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x04,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x40,				/* Maximun packet size (LSB) */
	0x00,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 6 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
	0x86,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x40,				/* Maximun packet size (LSB) */
	0x00,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */

	/* Endpoint 8 Descriptor */
	DSCR_ENDPNT_LEN,	/* Descriptor length */
	DSCR_ENDPNT,		/* Descriptor type */
    0x88,				/* Endpoint number, and direction */
	ET_BULK,			/* Endpoint type */
	0x40,				/* Maximun packet size (LSB) */
	0x00,				/* Max packect size (MSB) */
	0x00,				/* Polling interval */
	/* End of Full-Speed Configuration Descriptor */ 

	/* String Descriptor 0 */
	2+2,
	DSCR_STRING,
	0x09, 0x04,
	
	/* String Descriptor 1 */
	2+(2*7),
	DSCR_STRING,
	'C', 0x00,
	'y', 0x00,
	'p', 0x00,
	'r', 0x00,
	'e', 0x00,
	's', 0x00,
	's', 0x00,

	/* String Descriptor 2 */
	2+(2*10),
	DSCR_STRING,
	'E', 0x00,
	'Z', 0x00,
	'-', 0x00,
	'U', 0x00,
	'S', 0x00,
	'B', 0x00,
	' ', 0x00,
	'S', 0x00,
	'X', 0x00,
	'2', 0x00};
