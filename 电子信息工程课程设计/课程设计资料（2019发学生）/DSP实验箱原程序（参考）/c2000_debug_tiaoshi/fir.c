//#include <sgen.h>
#include <dlog4ch.h>
#include <fir.h>

/* Create an instance of Signal generator module    */
SGENTI_1 sgen = SGENTI_1_DEFAULTS;

/* Create an instance of DATALOG Module             */
DLOG_4CH dlog=DLOG_4CH_DEFAULTS;      
    
/* Filter Symbolic Constants                        */
#define FIR_ORDER   50                                        
                                        
/* Create an Instance of FIRFILT_GEN module and place the object in "firfilt" section       */ 
#pragma DATA_SECTION(fir, "firfilt");
FIR16  fir= FIR16_DEFAULTS;
                                            
/* Define the Delay buffer for the 50th order filterfilter and place it in "firldb" section */  
#pragma DATA_SECTION(dbuffer,"firldb");
long dbuffer[(FIR_ORDER+2)/2];                                        
         
/* Define Constant Co-efficient Array  and place the
.constant section in ROM memory				*/ 

long const coeff[(FIR_ORDER+2)/2]= FIR16_LPF50;
         
         
/* Finter Input and Output Variables                */   
int xn,yn;
 xn=AdcRegs.ADCRESULT0>>4;
          xn-=2047;
          xn=xn<<4;

         //caiyangx[n]=xn;
      
         
          fir.input=xn;           
          fir.calc(&fir);
          yn=fir.output;
          yn+=32768;
          
          //caiyangy[n]=yn;
           //n--;
             //if(n==0)
        //{EvaRegs.T1CON.bit.TENABLE=0;  }
          //dlog.update(&dlog);
             * DAOUT=yn;