;============================================================================
;
; File Name     : cfft_izc.asm
; 
; Originator    : Advanced Embeeded Control 
;                 Texas Instruments 
; 
; Description   : This file contains source code to zero the imaginary parts of 
;                 the complex input to the FFT module.
;               
; Date          : 25/2/2002 (dd/mm/yyyy)
;===========================================================================    
; Poutine Type  : C Callable        
;
; Description   :
; void FFTC_izc(FFTxxxC_handle) 
; This function zeros the imaginary part of the complex input, in the case of 
; Complex FFT modules.
; 
;====================================================================== 
; COMPLEX FFT MODULES
;----------------------------------------------------------------------
;typedef struct {   
;        long *ipcbptr;
;        long *tfptr               
;        int size;
;        int nrstage;             
;        int *magptr;
;        int peakmag;
;        int peakfrq;
;        int normflag;
;        int *winptr; 
;        void (*init)(void);
;        void (*izero)(void *);
;        void (*calc)(void *);
;        void (*mag)(void *);
;        void (*win)(void *);
;        }CFFT32;
;======================================================================
;======================================================================
            .def   _CFFT32_izero  
            
_CFFT32_izero:            
; Fill the imaginary part of the samples with ZERO 
            MOVL    XAR5,*XAR4      ; XAR5=ipcbptr
            MOV     ACC,*+XAR4[4]   ; ACC=size
            SUBB    ACC,#1          ; AL=size-1
            
            MOVL    XAR6,XAR5       ; XAR6=ipcbptr
            
            ADDB    XAR5,#2         ; XAR5=ipcbptr+2
            ADDB    XAR6,#3         ; XAR5=ipcbptr+3
            MOVB    XAR0,#4         ; XAR0=0
            
            NOP     *,ARP5
            RPT     AL
            || MOV      *0++,#0     ; Clear MSW of imaginary part
            
            NOP     *,ARP6
            RPT     AL 
            || MOV      *0++,#0     ; Clear LSW of imaginart part
                        
            LRETR 
            
            
                 
