num = xlsread('C:\Users\LENOVO\Desktop\2019_MCM-ICM_Problems\2018_MCMProblemC_DATA\ACS_16_5YR_DP02_with_ann.csv');
[c,b]=size(num);
B = zeros(464,22);
C=zeros(1,22);
% 132 136 140 236 240 244 248 252 256 260 264 268];

 for i=1:1:464
     B(i,1)=num(i,1);
     B(i,2)=num(i,3);
     B(i,3)=num(i,39);
     B(i,4)=num(i,97);
     B(i,5)=num(i,99);
     B(i,6)=num(i,107);
     B(i,7)=num(i,111);
     B(i,8)=num(i,115);
     B(i,9)=num(i,119);
     B(i,10)=num(i,123);
     B(i,11)=num(i,131);
     B(i,12)=num(i,135);
     B(i,13)=num(i,139);
     B(i,14)=num(i,235);
     B(i,15)=num(i,239);
     B(i,16)=num(i,243);
     B(i,17)=num(i,247);
     B(i,18)=num(i,251);
     B(i,19)=num(i,255);
     B(i,20)=num(i,259);
     B(i,21)=num(i,263);
     B(i,22)=num(i,267);
 end
    
       
        