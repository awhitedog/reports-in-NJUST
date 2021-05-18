;============================================================================
;
; File Name     : cfft_winc.asm
; 
; Originator    : Advanced Embeeded Control 
;                 Texas Instruments 
; 
; Description   : This file contains source code to window the input data sequence in the case of 
;                 complex FFT modules
;               
; Date          : 26/4/2001 (dd/mm/yyyy)
;===========================================================================    
; Routine Type  : C Callable        
;
; Description   :
; void FFTC_win(FFTxxxC_handle) 
; This function windows N-point real data sequence stored in bit-reversed order 
; in alternate memory location.(used with Complex FFT modules)
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
;        int *winptr; 
;        int peakmag;
;        int peakfrq;
;        int normflag;
;        void (*init)(void);
;        void (*izero)(void *);
;        void (*calc)(void *);
;        void (*mag)(void *);
;        void (*win)(void *);
;        }CFFT32;
;======================================================================

            .def    _CFFT32_win       
                
_CFFT32_win:
            MOVL    XAR5,*XAR4++    ; XAR5=ipcbptr
            MOVL    XAR6,*+XAR4[6]  ; XAR6=winptr
            MOV     ACC,*+XAR4[2]<<15 ; AH=size/2
            MOVH    AR0,ACC<<2      ; AR0=2*size
            MOVZ    AR7,AH          ; AR7=(size/2)                                  
            SUBB    XAR7,#1         ; AR7=(size/2)-1
            MOVL    XAR4,XAR7       ; AR4=(size/2)-1
            
nextsamp1:  
            MOVL    XT,*XAR6++
            QMPYL   ACC,XT,*XAR5
            LSL     ACC,#1
            MOVL    *BR0++,ACC
            BANZ    nextsamp1,AR7--
            
nextsamp2:  
            MOVL    XT,*--XAR6
            QMPYL   ACC,XT,*XAR5
            LSL     ACC,#1
            MOVL    *BR0++,ACC
            BANZ    nextsamp2,AR4--
            LRETR

