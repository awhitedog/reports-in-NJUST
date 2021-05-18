;========================================================================
;
; File Name     : iir16.asm
; 
; Originator    : Advanced Embeeded Control (AEC)
;                 Texas Instruments Inc.
; 
; Description   : This file contain source code for 16 bit IIR implementation
;               
; Date          : 25/12/2001
;======================================================================
; 
; 
; Routine Name  : Generic Function      
; Routine Type  : C Callable
; 
; Description   :
; void IIR5BIQ16_calc(IIR5BIQ16_handle) 
;
; This routine implements the IIR filter using cacade biquad structure
;======================================================================
;typedef struct { 
;   void (*init)(void *);   /* Ptr to Init funtion           */
;   void (*calc)(void *);   /* Ptr to calc fn                */  
;   int *coeff_ptr;         /* Pointer to Filter coefficient */
;   int *dbuffer_ptr;       /* Delay buffer ptr              */
;   int nbiq;               /* No of biquad                  */
;   int input;              /* Latest Input sample           */
;   int isf;                /* Input Scale Factor            */ 
;   int qfmat;              /* Coefficients Q Format         */
;   int output;             /* Filter Output                 */
;   }IIR5BIQ16;     
;=====================================================================

; Module definition for external referance
                .def    _IIR5BIQ16_calc
                .def    _IIR5BIQ16_init 

_IIR5BIQ16_init:
            ADDB    XAR4,#6         ; XAR4->dbuffer_ptr
            MOVL    XAR6,*+XAR4[0]  ; XAR6=dbuffer_ptr
            MOV     ACC,*+XAR4[2]<<1; ACC=2*nbiq
            SUB     ACC,#1          ; ACC=(2*nbiq)-1
            MOVZ    AR0,AL          ; AR0=(2*nbiq)-1
            ADDL    ACC,*XAR4       ; ACC=dbuffer_ptr + (2*nbiq) - 1
            MOVL    *XAR4,ACC       ; XAR4->dbuffer_ptr, 
                                    ; dbuffer_ptr=dbuffer_ptr + (2*nbiq) - 1

            MOV     *+XAR4[3],#0    ; input=0
            MOVB    ACC,#16
            SUB     ACC,*+XAR4[5]
            MOV     *+XAR4[5],AL    ; qfmat=16-qfmat
            MOV     *+XAR4[6],#0    ; output=0

            RPT     AR0
            || MOV  *XAR6++,#0
            
            LRETR

                   
_IIR5BIQ16_calc:        
            SETC    SXM,OVM          
            ZAPA                    ; Zero the ACC, P registers and OVC counter

            ADDB    XAR4,#4         ; XAR4->coeff_ptr
            MOVL    XAR7,*XAR4++    ; XAR4->dbuffer_ptr, XAR7=coeff_ptr->a21
            MOVL    XAR6,*XAR4++    ; XAR4->order, XAR6=dbuffer_ptr->d1(n-2)  
            MOVZ    AR0,*XAR4++     ; XAR4->input, AR0=nbiq

            MOV     T,*XAR4++       ; XAR4->isf, T=input
            MPY     ACC,T,*XAR4++   ; XAR4->qfmat, ACC=input*isf
            ADDB    XAR6,#1 
            SUBB    XAR0,#1         ; AR0=nbiq-1
                                      
; kth Biquad Computation, where k=1:nbiq
biqd:       
            MOV     T,*--XAR6       ; T=dk(n-2)
            MPY     P,T,*XAR7++     ; P= dk(n-2)*a2k
            MOV     T,*--XAR6       ; T=dk(n-1)
            MPYA    P,T,*XAR7++     ; ACC=input*isf + dk(n-2)*a2k
                                    ; P=dk(n-1)*a1k
                        
            MOV     T,*+XAR6[1]     ; T=dk(n-2)
            MPYA    P,T,*XAR7++     ; ACC=input*isf + dk(n-2)*a2k + dk(n-1)*a1k
                                    ; P=dk(n-2)*b2k
            
            MOV     T,*XAR4         ; T=qfmat
            LSLL    ACC,T           ; ACC=input*isf + dk(n-2)*a2k + dk(n-1)*a1k (Q15)
                                
            MOVZ    AR5,AH          ; AR5=dk(n)=input*isf + dk(n-2)*a2k + dk(n-1)*a1k (Q15)
            
            MOV     ACC,#0          ; ACC=0 
            MOVAD   T,*XAR6         ; T=dk(n-1), dk(n-2)=dk(n-1), ACC=dk(n-2)*b2k
            MPY     P,T,*XAR7++     ; P=dk(n-1)*b1k, 
            MOV     T,AR5           ; T=dk(n)
            MPYA    P,T,*XAR7++     ; ACC=dk(n-1)*b1k + dk(n-2)*b2k, P=dk(n)*b0k
            ADDL    ACC,P
            MOV     *XAR6,T         ; dk(n-1)=dk(n)
            BANZ    biqd,AR0--
            
            MOV     T,*XAR4++       ; T=qfmat, XAR4->output
            LSLL    ACC,T
            ROR     ACC
            MOV     *XAR4,AH        ; output=Filtered Output in Q14 format 
	        CLRC    OVM
            LRETR                   ; !!!Do not shift it left to store in Q15 format
                                    ; If you do so, and if the output is >1, then it will
                                    ; become negative..instead of the most desirable Saturation


