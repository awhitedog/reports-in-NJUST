clc;
premium= xlsread('签单保费.xlsx');
premium(isnan(premium)) = 0;
for i=1:size(premium,1)
    if premium(i,1)<=1000
        premium(i,2)=500;
    elseif premium(i,1)>1000 && premium(i,1)<=2000
        premium(i,2)=1500;
    elseif premium(i,1)>2000 && premium(i,1)<=3000
        premium(i,2)=2500;
    elseif premium(i,1)>3000 && premium(i,1)<=4000
        premium(i,2)=3500;
    elseif premium(i,1)>4000 && premium(i,1)<=5000
        premium(i,2)=4500;
    else premium(i,1)>5000
        premium(i,2)=5500;
    end
end
%统计开始
STAT=zeros(6,4);
STAT(:,1)=[500,1500,2500,3500,4500,5500];
for k=1:6
for i=1:size(premium,1)
    if STAT(k,1)==premium(i,2)
        STAT(k,2)=STAT(k,2)+1;
        if premium(i,4)==1
            STAT(k,3)=STAT(k,3)+1;
        end
    end
end
STAT(k,4)=STAT(k,3)/STAT(k,2);
end
