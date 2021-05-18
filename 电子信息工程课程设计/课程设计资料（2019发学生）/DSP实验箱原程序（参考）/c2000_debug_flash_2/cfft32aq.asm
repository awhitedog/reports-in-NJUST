;============================================================================
;
; File Name     : cfft_acqc.asm
; 
; Originator    : Advanced Embeeded Control 
;                 Texas Instruments 
; 
; Description   : This file contains to acquire N samples in bit reversed order 
;                 to perform complex FFT computation
;               
; Date          : 26/2/2001 (dd/mm/yyyy)
;===========================================================================    
; Routine Type  : C Callable        
;
; Description   :
; void FFTC_acq(FFTCACQ_handle) 
; This function acquires N samples in bit-reversed order to cater to the complex
; FFT computation. The buffer should be aligned to 2N words
; 
;======================================================================
; typedef   struct {
;       int acqflag;
;       int count;
;       long input; 
;       long *tempptr;
;       long *buffptr;
;       int size;
;       void (*update)(void *); 
;       }FFTCACQ;  
;======================================================================

            .def    _CFFT32_acq       
                
_CFFT32_acq:  
            MOV     ACC,*XAR4++     ; ACC=acqflag
            SBF     noacq,EQ
                              
            MOV     ACC,*XAR4++     ; ACC=count
            SBF     acqover,EQ      ; if count=0, acquisition is complete
            
            DEC     *--XAR4         ; count=count-1
            MOV     ACC,*+XAR4[7]<<1; ACC=2*size
            MOVL    XAR0,ACC        ; AR0=2*size            
                    
            MOVL    XAR5,*+XAR4[3]  ; XAR5=tempptr
            MOVL    ACC,*+XAR4[1]   ; ACC=input
            MOVL    *XAR5,ACC       ; *tempptr=input
            NOP     *BR0++
            MOVL    *+XAR4[3],XAR5
noacq:      LRETR   
                     
                     
                     
acqover:    MOV     ACC,*+XAR4[6]
            MOV     *--XAR4,ACC     ; count=size
            MOV     *--XAR4,#0      ; acqflag=0
            
            MOVL    XAR5,*+XAR4[6]  ; XAR5=buffptr
            MOVL    *+XAR4[4],XAR5  ; tempptr=buffptr
            LRETR
            
            
            
            
