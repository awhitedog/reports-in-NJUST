
#ifndef _register
#define _register
//mondify 08725 
unsigned int * USB_STS = (unsigned int *) 0x2d00;//×´Ì¬¼Ä´æÆ÷
unsigned int * USB_FIFO2 = (unsigned int *) 0x2800;//usb¼Ä´æÆ÷¼°fifoÔÚ2812ÖĞµÄÓ³ÉäµØÖ·
unsigned int * USB_FIFO4 = (unsigned int *) 0x2801;
unsigned int * USB_FIFO6 = (unsigned int *) 0x2802;
unsigned int * USB_FIFO8 = (unsigned int *) 0x2803;
unsigned int * USB_COMMAND = (unsigned int *) 0x2804;

#endif
